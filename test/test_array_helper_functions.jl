module TestArrayHelperFunctions

using FactCheck
using MultidimensionalTables
using MultidimensionalTables: wrap_array, gtake

facts("ArrayHelperFunctions tests") do
  @fact sum(@nalift([1,20,3])) --> x -> MultidimensionalTables.naop_eq(Nullable(24), x).value
  @fact sum(@nalift([1,20,3,NA])) --> x -> MultidimensionalTables.naop_eq(Nullable(24), x).value
  @fact sum(@nalift([1,2,3,NA,50])) --> x -> MultidimensionalTables.naop_eq(Nullable(56), x).value
  @fact prod(@nalift([1,2,5])) --> x -> MultidimensionalTables.naop_eq(x, Nullable(10)).value
  @fact prod(@nalift([1,2,3,NA])) --> x -> MultidimensionalTables.naop_eq(x, Nullable(6)).value
  @fact prod(@nalift([1,2,3,NA,15])) --> x -> MultidimensionalTables.naop_eq(x, Nullable(90)).value
  @fact collect(MultidimensionalTables.dropnaiter(@nalift([1,20,3,NA,50,NA,NA]))) --> [1,20,3,50]
  @fact MultidimensionalTables.simplify_array(map(x->x[1],collect(MultidimensionalTables.enum_dropnaiter(@nalift([1,20,3,NA,50,NA,NA]))))) --> map(x->x[1],MultidimensionalTables.wrap_array(collect(zip([1,2,3,5],@nalift([1,20,3,50])))))
  @fact MultidimensionalTables.simplify_array(map(x->x[2],collect(MultidimensionalTables.enum_dropnaiter(@nalift([1,20,3,NA,50,NA,NA]))))) --> map(x->x[2],MultidimensionalTables.wrap_array(collect(zip([1,2,3,5],[1,20,3,50]))))
  @fact collect(MultidimensionalTables.zip_dropnaiter(@nalift([1,2,3,NA,NA,4,5,7,8,9]), @nalift([NA,2,3,NA,10,14,NA,NA,10]))) --> [(2,2),(3,3),(4,14),(8,10)]
  @fact cov(@nalift([1,2,35,NA,NA]),@nalift([10,NA,12,NA,5])).value --> roughly(cov([1,35],[10,12]))
  @fact cor(@nalift([1,2,35,NA,NA]),@nalift([10,NA,12,NA,5])).value --> roughly(cor([1,35],[10,12]))
  @fact median(@nalift([1,10,100,NA])).value --> roughly(10.0)
  @fact median(@nalift([1,10,NA,100])).value --> roughly(10.0)
  @fact middle(@nalift([1,10,NA,100])).value --> roughly(50.5)
  @fact middle(@nalift([1,10,NA,100])).value --> roughly(50.5)
  @fact quantile(@nalift([1,10,NA,100,2,3,NA]),0.0).value --> roughly(1.0)
  @fact quantile(@nalift([1,10,NA,100,2,3,NA]),0.25).value --> roughly(2.0)
  @fact quantile(@nalift([1,10,NA,100,2,3,NA]),0.5).value --> roughly(3.0)
  @fact quantile(@nalift([1,10,NA,100,2,3,NA]),0.75).value --> roughly(10.0)
  @fact quantile(@nalift([1,10,NA,100,2,3,NA]),1.0).value --> roughly(100.0)
  @fact cumsum(larr(a=reshape(1:10,2,5), axis1=darr(k=[:x,:y]))) --> larr(a=[1 3 5 7 9;3 7 11 15 19], axis1=darr(k=[:x,:y]))
  @fact cumsum(larr(a=reshape(1:10,2,5), axis1=darr(k=[:x,:y])),1) --> larr(a=[1 3 5 7 9;3 7 11 15 19], axis1=darr(k=[:x,:y]))
  @fact cumsum(larr(a=reshape(1:10,2,5), axis1=darr(k=[:x,:y])),2) --> larr(a=[1 4 9 16 25;2 6 12 20 30], axis1=darr(k=[:x,:y]))
  @fact cumprod(larr(a=reshape(1:10,2,5), axis1=darr(k=[:x,:y]))) --> larr(a=[1 3 5 7 9;2 12 30 56 90], axis1=darr(k=[:x,:y]))
  @fact cumprod(larr(a=reshape(1:10,2,5), axis1=darr(k=[:x,:y])),1) --> larr(a=[1 3 5 7 9;2 12 30 56 90], axis1=darr(k=[:x,:y]))
  @fact cumprod(larr(a=reshape(1:10,2,5), axis1=darr(k=[:x,:y])),2) --> larr(a=[1 3 15 105 945;2 8 48 384 3840], axis1=darr(k=[:x,:y]))
  @fact cumsum(@nalift([1 2 3;4 5 NA])) --> nalift([1 2 3;5 7 3])
  @fact cumprod(@nalift([1 2 3;4 5 NA])) --> nalift([1 2 3;4 10 3])
  @fact mean(larr(a=[1 2 3;4 5 6],b=[1.0 2.0 3.0;4.0 5.0 6.0], axis1=[:x,:y]))[:a].value --> roughly(3.5)
  @fact cor(larr(a=[1 2;3 4],b=[5 6;7 8]))[1,2].value --> roughly(1.0)
  @fact cor(larr(a=[1.0 2.0;3.0 4.0],b=[5 6;7 8]))[1,2].value --> roughly(1.0)
  @fact maximum(@nalift([1,10,NA,100,2,3,NA])).value --> roughly(quantile(@nalift([1,10,NA,100,2,3,NA]),1).value)
  @fact minimum(@nalift([1,10,NA,100,2,3,NA])).value --> roughly(quantile(@nalift([1,10,NA,100,2,3,NA]),0).value)
  @fact mmaximum(@nalift([1 NA 3;4 NA NA]),window=2,1) --> @nalift([1 NA 3;4 NA 3])
  @fact mmaximum(@nalift([1 NA 3;4 NA NA]),window=2,2) --> @nalift([1 1 3;4 4 NA])
  @fact mminimum(@nalift([1 NA 3;4 NA NA]),window=2,1) --> @nalift([1 NA 3;1 NA 3])
  @fact mminimum(@nalift([1 NA 3;4 NA NA]),2,window=2) --> @nalift([1 1 3;4 4 NA])
  @fact mmedian(@nalift([1 NA 3;4 NA NA]),window=2,1) --> @nalift([1.0 NA 3.0;2.5 NA 3.0])
  @fact mmedian(@nalift([1 NA 3;4 NA NA]),2,window=2) --> @nalift([1.0 1.0 3.0;4.0 4.0 NA])
  @fact mmiddle(@nalift([1 NA 3;4 NA NA]),window=2,1) --> @nalift([1.0 NA 3.0;2.5 NA 3.0])
  @fact mmiddle(@nalift([1 NA 3;4 NA NA]),window=2,2) --> @nalift([1.0 1.0 3.0;4.0 4.0 NA])
  @fact mmean(@nalift([1 NA 3;4 NA NA]),window=2,1) --> @nalift([1.0 NA 3.0;2.5 NA 3.0])
  @fact mmean(@nalift([1 NA 3;4 NA NA]),2,window=2) --> @nalift([1.0 1.0 3.0;4.0 4.0 NA])
  @fact mquantile(@nalift([1 NA 3;4 NA NA]),0.5,window=2,1) --> mmedian(@nalift([1 NA 3;4 NA NA]),window=2,1)
  @fact mquantile(@nalift([1 NA 3;4 NA NA]),0.5,window=2,2) --> mmedian(@nalift([1 NA 3;4 NA NA]),2,window=2)
  @fact mmedian(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> roughly(5.0)
  @fact mmean(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> roughly(17/3)
  @fact mminimum(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> 4
  @fact mmaximum(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> 8
  @fact mmiddle(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> roughly(6.0)
  @fact cumsum(@nalift([1,2,NA,8,4,NA,NA,5,8])) --> nalift([1,3,3,11,15,15,15,20,28])
  @fact cumprod(@nalift([1,2,NA,8,4,NA,NA,5,8])) --> nalift([1,2,2,16,64,64,64,320,2560])
  @fact cummin(@nalift([1,2,NA,8,4,NA,NA,5,8])) --> nalift([1,1,1,1,1,1,1,1,1])
  @fact cummax(@nalift([1,2,NA,8,4,NA,NA,5,8])) --> nalift([1,2,2,8,8,8,8,8,8])
  @fact msum(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5) --> nalift([1,3,3,11,15,14,12,17,17])
  @fact mprod(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5) --> nalift([1,2,2,16,64,64,32,160,160])
  @fact mquantile(@nalift([1,2,NA,8,4,NA,NA,5,8]), 0.25, window=5, 1)[8].value --> roughly(4.5)

  context("nullable array tests") do
    @fact maximum(@nalift([1,10,NA,100,2,3,NA])).value --> roughly(quantile(@nalift([1,10,NA,100,2,3,NA]),1).value)
    @fact minimum(@nalift([1,10,NA,100,2,3,NA])).value --> roughly(quantile(@nalift([1,10,NA,100,2,3,NA]),0).value)
    @fact mmaximum(@nalift([1 NA 3;4 NA NA]),window=2,1) --> @nalift([1 NA 3;4 NA 3])
    @fact mmaximum(@nalift([1 NA 3;4 NA NA]),2,window=2) --> @nalift([1 1 3;4 4 NA])
    @fact mminimum(@nalift([1 NA 3;4 NA NA]),1,window=2) --> @nalift([1 NA 3;1 NA 3])
    @fact mminimum(@nalift([1 NA 3;4 NA NA]),2,window=2) --> @nalift([1 1 3;4 4 NA])
    @fact mmedian(@nalift([1 NA 3;4 NA NA]),window=2,1) --> @nalift([1.0 NA 3.0;2.5 NA 3.0])
    @fact mmedian(@nalift([1 NA 3;4 NA NA]),2,window=2) --> @nalift([1.0 1.0 3.0;4.0 4.0 NA])
    @fact mmiddle(@nalift([1 NA 3;4 NA NA]),window=2,1) --> @nalift([1.0 NA 3.0;2.5 NA 3.0])
    @fact mmiddle(@nalift([1 NA 3;4 NA NA]),2,window=2) --> @nalift([1.0 1.0 3.0;4.0 4.0 NA])
    @fact mmean(@nalift([1 NA 3;4 NA NA]),window=2,1) --> @nalift([1.0 NA 3.0;2.5 NA 3.0])
    @fact mmean(@nalift([1 NA 3;4 NA NA]),2,window=2) --> @nalift([1.0 1.0 3.0;4.0 4.0 NA])
    @fact mquantile(@nalift([1 NA 3;4 NA NA]),0.5,window=2) --> mmedian(@nalift([1 NA 3;4 NA NA]),window=2,1)
    @fact mquantile(@nalift([1 NA 3;4 NA NA]),0.5,window=2,2) --> mmedian(@nalift([1 NA 3;4 NA NA]),2,window=2)
    @fact mmedian(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> roughly(5.0)
    @fact mmean(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> roughly(17/3)
    @fact mminimum(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> 4
    @fact mmaximum(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> 8
    @fact mmiddle(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> roughly(6.0)
    @fact cumsum(@nalift([1,2,NA,8,4,NA,NA,5,8])) --> nalift([1,3,3,11,15,15,15,20,28])
    @fact cumprod(@nalift([1,2,NA,8,4,NA,NA,5,8])) --> nalift([1,2,2,16,64,64,64,320,2560])
    @fact cummin(@nalift([1,2,NA,8,4,NA,NA,5,8])) --> nalift([1,1,1,1,1,1,1,1,1])
    @fact cummax(@nalift([1,2,NA,8,4,NA,NA,5,8])) --> nalift([1,2,2,8,8,8,8,8,8])
    @fact msum(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5) --> nalift([1,3,3,11,15,14,12,17,17])
    @fact mprod(@nalift([1,2,NA,8,4,NA,NA,5,8]), window=5) --> nalift([1,2,2,16,64,64,32,160,160])
    @fact mquantile(@nalift([1,2,NA,8,4,NA,NA,5,8]), 0.25, window=5)[8].value --> roughly(4.5)
    @fact mmean(nalift(1:10)) --> nalift([1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5])
  end

  context("darr tests") do
    @fact mmaximum(@darr(a=[1 NA 3;4 NA NA]),window=2,1) --> @darr(a=[1 NA 3;4 NA 3])
    @fact mmaximum(@darr(a=[1 NA 3;4 NA NA]),2,window=2) --> @darr(a=[1 1 3;4 4 NA])
    @fact mminimum(@darr(a=[1 NA 3;4 NA NA]),window=2,1) --> @darr(a=[1 NA 3;1 NA 3])
    @fact mminimum(@darr(a=[1 NA 3;4 NA NA]),window=2,2) --> @darr(a=[1 1 3;4 4 NA])
    @fact mmedian(@darr(a=[1 NA 3;4 NA NA]),window=2,1) --> @darr(a=[1.0 NA 3.0;2.5 NA 3.0])
    @fact mmedian(@darr(a=[1 NA 3;4 NA NA]),2,window=2) --> @darr(a=[1.0 1.0 3.0;4.0 4.0 NA])
    @fact mmiddle(@darr(a=[1 NA 3;4 NA NA]),window=2,1) --> @darr(a=[1.0 NA 3.0;2.5 NA 3.0])
    @fact mmiddle(@darr(a=[1 NA 3;4 NA NA]),2,window=2) --> @darr(a=[1.0 1.0 3.0;4.0 4.0 NA])
    @fact mmean(@darr(a=[1 NA 3;4 NA NA]),window=2,1) --> @darr(a=[1.0 NA 3.0;2.5 NA 3.0])
    @fact mmean(@darr(a=[1 NA 3;4 NA NA]),window=2,2) --> @darr(a=[1.0 1.0 3.0;4.0 4.0 NA])
    @fact mquantile(@darr(a=[1 NA 3;4 NA NA]),0.5,window=2,1) --> mmedian(@darr(a=[1 NA 3;4 NA NA]),window=2,1)
    @fact mquantile(@darr(a=[1 NA 3;4 NA NA]),0.5,2,window=2) --> mmedian(@darr(a=[1 NA 3;4 NA NA]),window=2,2)
    @fact mmedian(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5)[8][:a].value --> roughly(5.0)
    @fact mmean(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5)[8][:a].value --> roughly(17/3)
    @fact mminimum(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5)[8][:a].value --> 4
    @fact mmaximum(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5)[:a][8].value --> 8
    @fact mmiddle(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5)[:a][8].value --> roughly(6.0)
    @fact cumsum(@darr(a=[1,2,NA,8,4,NA,NA,5,8])) --> darr(a=[1,3,3,11,15,15,15,20,28])
    @fact cumprod(@darr(a=[1,2,NA,8,4,NA,NA,5,8])) --> darr(a=[1,2,2,16,64,64,64,320,2560])
    @fact cummin(@darr(a=[1,2,NA,8,4,NA,NA,5,8])) --> darr(a=[1,1,1,1,1,1,1,1,1])
    @fact cummax(@darr(a=[1,2,NA,8,4,NA,NA,5,8])) --> darr(a=[1,2,2,8,8,8,8,8,8])
    @fact msum(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5) --> darr(a=[1,3,3,11,15,14,12,17,17])
    @fact mprod(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5) --> darr(a=[1,2,2,16,64,64,32,160,160])
    @fact mquantile(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), 0.25, window=5, 1)[:a][8].value --> roughly(4.5)
    @fact maximum(@darr(a=[1,10,NA,100,2,3,NA]))[:a].value --> roughly(quantile(@darr(a=[1,10,NA,100,2,3,NA]),1)[:a].value)
    @fact minimum(@darr(a=[1,10,NA,100,2,3,NA]))[:a].value --> roughly(quantile(@darr(a=[1,10,NA,100,2,3,NA]),0)[:a].value)
    @fact mmaximum(@darr(a=[1 NA 3;4 NA NA]),window=2,1) --> @darr(a=[1 NA 3;4 NA 3])
    @fact mmaximum(@darr(a=[1 NA 3;4 NA NA]),window=2,2) --> @darr(a=[1 1 3;4 4 NA])
    @fact mminimum(@darr(a=[1 NA 3;4 NA NA]),window=2,1) --> @darr(a=[1 NA 3;1 NA 3])
    @fact mminimum(@darr(a=[1 NA 3;4 NA NA]),2,window=2) --> @darr(a=[1 1 3;4 4 NA])
    @fact mmedian(@darr(a=[1 NA 3;4 NA NA]),window=2,1) --> @darr(a=[1.0 NA 3.0;2.5 NA 3.0])
    @fact mmedian(@darr(a=[1 NA 3;4 NA NA]),2,window=2) --> @darr(a=[1.0 1.0 3.0;4.0 4.0 NA])
    @fact mmiddle(@darr(a=[1 NA 3;4 NA NA]),window=2,1) --> @darr(a=[1.0 NA 3.0;2.5 NA 3.0])
    @fact mmiddle(@darr(a=[1 NA 3;4 NA NA]),2,window=2) --> @darr(a=[1.0 1.0 3.0;4.0 4.0 NA])
    @fact mmean(@darr(a=[1 NA 3;4 NA NA]),window=2,1) --> @darr(a=[1.0 NA 3.0;2.5 NA 3.0])
    @fact mmean(@darr(a=[1 NA 3;4 NA NA]),2,window=2) --> @darr(a=[1.0 1.0 3.0;4.0 4.0 NA])
    @fact mquantile(@darr(a=[1 NA 3;4 NA NA]),0.5,window=2) --> mmedian(@darr(a=[1 NA 3;4 NA NA]),window=2,1)
    @fact mquantile(@darr(a=[1 NA 3;4 NA NA]),0.5,2,window=2) --> mmedian(@darr(a=[1 NA 3;4 NA NA]),window=2,2)
    @fact mmedian(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5)[8][:a].value --> roughly(5.0)
    @fact mmean(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5)[:a][8].value --> roughly(17/3)
    @fact mminimum(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5)[:a][8].value --> 4
    @fact mmaximum(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5)[8][:a].value --> 8
    @fact mmiddle(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5)[8][:a].value --> roughly(6.0)
    @fact cumsum(@darr(a=[1,2,NA,8,4,NA,NA,5,8])) --> darr(a=[1,3,3,11,15,15,15,20,28])
    @fact cumprod(@darr(a=[1,2,NA,8,4,NA,NA,5,8])) --> darr(a=[1,2,2,16,64,64,64,320,2560])
    @fact cummin(@darr(a=[1,2,NA,8,4,NA,NA,5,8])) --> darr(a=[1,1,1,1,1,1,1,1,1])
    @fact cummax(@darr(a=[1,2,NA,8,4,NA,NA,5,8])) --> darr(a=[1,2,2,8,8,8,8,8,8])
    @fact msum(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5) --> darr(a=[1,3,3,11,15,14,12,17,17])
    @fact mprod(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), window=5) --> darr(a=[1,2,2,16,64,64,32,160,160])
    @fact mquantile(@darr(a=[1,2,NA,8,4,NA,NA,5,8]), 0.25, window=5)[:a][8].value --> roughly(4.5)
  end

  context("larr tests") do
    @fact maximum(@larr([1,10,NA,100,2,3,NA])).value --> roughly(quantile(@larr([1,10,NA,100,2,3,NA]),1).value)
    @fact minimum(@larr([1,10,NA,100,2,3,NA])).value --> roughly(quantile(@larr([1,10,NA,100,2,3,NA]),0).value)
    @fact mmaximum(@larr([1 NA 3;4 NA NA]),window=2,1) --> @larr([1 NA 3;4 NA 3])
    @fact mmaximum(@larr([1 NA 3;4 NA NA]),2,window=2) --> @larr([1 1 3;4 4 NA])
    @fact mminimum(@larr([1 NA 3;4 NA NA]),window=2,1) --> @larr([1 NA 3;1 NA 3])
    @fact mminimum(@larr([1 NA 3;4 NA NA]),2,window=2) --> @larr([1 1 3;4 4 NA])
    @fact mmedian(@larr([1 NA 3;4 NA NA]),window=2,1) --> @larr([1.0 NA 3.0;2.5 NA 3.0])
    @fact mmedian(@larr([1 NA 3;4 NA NA]),1) --> @larr([1.0 NA 3.0;2.5 NA 3.0])
    @fact mmedian(@larr([1 NA 3;4 NA NA]),2,window=2) --> @larr([1.0 1.0 3.0;4.0 4.0 NA])
    @fact mmedian(@larr([1 NA 3;4 NA NA]),2) --> @larr([1.0 1.0 2.0;4.0 4.0 4.0])
    @fact mmiddle(@larr([1 NA 3;4 NA NA]),window=2,1) --> @larr([1.0 NA 3.0;2.5 NA 3.0])
    @fact mmiddle(@larr([1 NA 3;4 NA NA]),window=2,2) --> @larr([1.0 1.0 3.0;4.0 4.0 NA])
    @fact mmiddle(@larr([1 NA 3 5 2 8;4 NA NA 7 2 NA]),2) --> larr([1.0 1.0 2.0 3.0 3.0 4.5;4.0 4.0 4.0 5.5 4.5 4.5])
    @fact mmiddle(@larr([1 NA 3 5 2 8;4 NA NA 7 2 NA]),2,rev=true) --> @larr([4.5 5.0 5.0 5.0 5.0 8.0;4.5 4.5 4.5 4.5 2.0 NA])
    @fact mmean(@larr([1 NA 3;4 NA NA]),window=2,1) --> @larr([1.0 NA 3.0;2.5 NA 3.0])
    @fact mmean(@larr([1 NA 3;4 NA NA]),2) --> @larr([1.0 1.0 2.0;4.0 4.0 4.0])
    @fact mquantile(@larr([1 NA 3;4 NA NA]),0.5,window=2,1) --> mmedian(@larr([1 NA 3;4 NA NA]),window=2,1)
    @fact mquantile(@larr([1 NA 3;4 NA NA]),0.5,window=2,2) --> mmedian(@larr([1 NA 3;4 NA NA]),2,window=2)
    @fact mmedian(@larr([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> roughly(5.0)
    @fact mmean(@larr([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> roughly(17/3)
    @fact mminimum(@larr([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> 4
    @fact mmaximum(@larr([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> 8
    @fact mmiddle(@larr([1,2,NA,8,4,NA,NA,5,8]), window=5)[8].value --> roughly(6.0)
    @fact cumsum(@larr([1,2,NA,8,4,NA,NA,5,8])) --> larr([1,3,3,11,15,15,15,20,28])
    @fact msum(@larr([1,2,NA,8,4,NA,NA,5,8])) --> larr([1,3,3,11,15,15,15,20,28])
    @fact cumprod(@larr([1,2,NA,8,4,NA,NA,5,8])) --> larr([1,2,2,16,64,64,64,320,2560])
    @fact mprod(@larr([1,2,NA,8,4,NA,NA,5,8])) --> larr([1,2,2,16,64,64,64,320,2560])
    @fact cummin(@larr([1,2,NA,8,4,NA,NA,5,8])) --> larr([1,1,1,1,1,1,1,1,1])
    @fact mminimum(@larr([1,2,NA,8,4,NA,NA,5,8])) --> larr([1,1,1,1,1,1,1,1,1])
    @fact cummax(@larr([1,2,NA,8,4,NA,NA,5,8])) --> larr([1,2,2,8,8,8,8,8,8])
    @fact mmaximum(@larr([1,2,NA,8,4,NA,NA,5,8])) --> larr([1,2,2,8,8,8,8,8,8])
    @fact msum(@larr([1,2,NA,8,4,NA,NA,5,8]), window=5) --> larr([1,3,3,11,15,14,12,17,17])
    @fact mprod(@larr([1,2,NA,8,4,NA,NA,5,8]), window=5) --> larr([1,2,2,16,64,64,32,160,160])
    @fact mquantile(@larr([1,2,NA,8,4,NA,NA,5,8]), 0.25, window=5, 1)[8].value --> roughly(4.5)
    @fact mquantile(@larr([1,2,NA,8,4,NA,NA,5,8]), 0.25, window=5)[8].value --> roughly(4.5)
    @fact mquantile(@larr([1,2,NA,8,4,NA,NA,5,8]), 0.25)[8].value --> roughly(2.0)
    @fact mquantile(@larr([1,2,NA,8,4,NA,NA,5,8]), 0.5)[8].value --> roughly(4.0)
    @fact mmedian(@larr([1,2,NA,8,4,NA,NA,5,8]))[8].value --> roughly(4.0)
  end

  context("reverse tests") do
    @fact mprod(@larr([1,2,NA,8,4,NA,NA,5,8]), window=5, rev=true) --> larr([64,64,32,160,160,40,40,40,8])
    @fact mmedian(@larr([1 NA 3;4 NA NA]),window=2,1, rev=true) --> @larr([2.5 NA 3.0;4.0 NA NA])
  end
  context("nafill tests") do
    @fact nafill(@larr([1 NA 3;4 NA NA]),window=1,2) --> @larr([1 NA 3;4 NA NA])
    @fact nafill(@larr([1 NA 3;4 NA NA]),window=2,2) --> @larr([1 1 3;4 4 NA])
    @fact nafill(@larr([1 NA 3;4 NA NA]),window=3,2) --> @larr([1 1 3;4 4 4])
    @fact nafill(@larr([1 NA 3;4 NA NA]),2) --> @larr([1 1 3;4 4 4])
    @fact nafill(@larr([1 NA 3;4 NA NA]),window=1,1) --> @larr([1 NA 3;4 NA NA])
    @fact nafill(@larr([1 NA 3;4 NA NA]),window=2,1) --> @larr([1 NA 3;4 NA 3])
    @fact nafill(@larr([1 NA 3;4 NA NA]),1) --> @larr([1 NA 3;4 NA 3])
  end
  context("describe tests") do
    @fact wrap_array(extract(describe(@darr(a=[1,2,3,4,5])), Nullable(:a)).values) --> nalift([1.0,2.0,3.0,4.0,5.0,3.0,std([1,2,3,4,5]),5.0,0.0,0.0])
    @fact keys(extract(describe(@darr(a=[1,2,3,4,5])), Nullable(:a))) --> [:min,:q1,:med,:q3,:max,:mean,:std,:count,:nacount,:naratio]
    @fact describe(@darr(a=[1,2,3,NA,5]))[:nacount] --> nalift([Nullable(1)])
    @fact describe(@larr(a=[1,2,3,4,5])) --> describe(@darr(a=[1,2,3,4,5]))
    @fact describe(nalift([1,2,3,4,5])) --> describe(@larr(a=[1,2,3,4,5]))[1]
    @fact describe(@larr(a=[1,NA,3,4,NA], b=[1.0,2.0,3.0,4.0,5.0], axis1['x','y','z','u','v'])) --> describe(@darr(a=[1,NA,3,4,NA], b=[1.0,2.0,3.0,4.0,5.0]))
    @fact shift(@nalift([1,2,NA,4,5]), 2) --> @nalift([NA,4,5,NA,NA])
    @fact shift(@nalift([1,2,NA,4,5]), -2) --> @nalift([NA,NA,1,2,NA])
    @fact shift(nalift(reshape(1:20,4,5)),1,-2) --> extract(nalift(reshape(1:20,4,5)),2:5,-1:3)
    @fact shift(darr(a=[1 2 3;4 5 6]),1,1,isbound=true) --> darr(a=[5 6 6;5 6 6])
    @fact shift(larr(a=[1 2 3;4 5 6],axis2=[:m,:n,:p]),1,1,isbound=true) --> larr(a=[5 6 6;5 6 6],axis2=[:m,:n,:p])
  end
end

end
