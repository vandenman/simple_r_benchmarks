library(BDgraph)
library(bgms)
library(bootnet)
library(bench)

# set this up
data("Wenchuan")

benchpress <- bench::press(

  rows = c(30, 60),
  cols = c(3, 6),
  rep  = 1:2,

  {
    rows <- 30
    cols <- 3
    x <- Wenchuan[1:rows, 1:cols]
    bench::mark(
      bgm_nosave = suppressWarnings(bgm(x, display_progress = FALSE, iter = 1e3, save = FALSE)),
      bgm_save   = suppressWarnings(bgm(x, display_progress = FALSE, iter = 1e3, save = TRUE)),
      bdgraph    = bdgraph(data = x, method = "ggm", iter = 5000, verbose = FALSE, cores = 1),
      bootnet    = suppressWarnings(suppressMessages(estimateNetwork(x, default = "EBICglasso", verbose = FALSE))),
      check = FALSE # otherwise bench::mark will compare results for equality
      min_iterations = 5,
    )
  }
)

# save the figure and email it to me!
ggplot2::autoplot(benchpress)

# email this as well
saveRDS(benchpress, "benchpress.rds")
