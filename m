Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbfFFPVM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Jun 2019 11:21:12 -0400
Date: Thu, 6 Jun 2019 11:21:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190606152101.GA2791@bfoster>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190523015659.GL29573@dread.disaster.area>
 <20190523125535.GA20099@bfoster>
 <20190523221552.GM29573@dread.disaster.area>
 <20190524120015.GA32730@bfoster>
 <20190525224317.GZ29573@dread.disaster.area>
 <20190531171136.GA26315@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531171136.GA26315@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 31, 2019 at 01:11:36PM -0400, Brian Foster wrote:
> On Sun, May 26, 2019 at 08:43:17AM +1000, Dave Chinner wrote:
> > On Fri, May 24, 2019 at 08:00:18AM -0400, Brian Foster wrote:
> > > On Fri, May 24, 2019 at 08:15:52AM +1000, Dave Chinner wrote:
> > > > On Thu, May 23, 2019 at 08:55:35AM -0400, Brian Foster wrote:
> > > > > Hmmm.. I suppose if I had a script that
> > > > > just dumped every applicable stride/delta value for an inode, I could
> > > > > dump all of those numbers into a file and we can process it from there..
> > > > 
> > > > See how the freesp commands work in xfs_db - they just generate a
> > > > set of {offset, size} tuples that are then bucketted appropriately.
> > > > This is probably the best way to do this at the moment - have xfs_db
> > > > walk the inode BMBTs outputting something like {extent size,
> > > > distance to next extent} tuples and everything else falls out from
> > > > how we bucket that information.
> > > > 
> > > 
> > > That sounds plausible. A bit more involved than what I'm currently
> > > working with, but we do already have a blueprint for the scanning
> > > implementation required to collect this data via the frag command.
> > > Perhaps some of this code between the frag/freesp can be generalized and
> > > reused. I'll take a closer look at it.
> > > 
> > > My only concern is I'd prefer to only go down this path as long as we
> > > plan to land the associated command in xfs_db. So this approach suggests
> > > to me that we add a "locality" command similar to frag/freesp that
> > > presents the locality state of the fs. For now I'm only really concerned
> > > with the data associated with known near mode allocations (i.e., such as
> > > the extent size:distance relationship you've outlined above) so we can
> > > evaluate these algorithmic changes, but this would be for fs devs only
> > > so we could always expand on it down the road if we want to assess
> > > different allocations. Hm?
> > 
> > Yup, I'm needing to do similar analysis myself to determine how
> > quickly I'm aging the filesystem, so having the tool in xfs_db or
> > xfs_spaceman would be very useful.
> > 
> > FWIW, the tool I've just started writing will just use fallocate and
> > truncate to hammer the allocation code as hard and as quickly as
> > possible - I want to do accelerated aging of the filesystem, and so
> > being able to run tens to hundreds of thousands of free space
> > manipulations a second is the goal here....
> > 
> 
> Ok. FWIW, from playing with this so far (before getting distracted for
> much of this week) the most straightforward place to add this kind of
> functionality turns out to be the frag command itself. It does 99% of
> the work required to process data extents already, including pulling the
> on-disk records of each inode in-core for processing. I basically just
> had to update that code to include all of the record data and add the
> locality tracking logic (I haven't got to actually presenting it yet..).
> 

I managed to collect some preliminary data based on this strategy. I
regenerated the associated dataset as I wanted to introduce more near
mode allocation events where locality is relevant/measurable. The set is
still generated via filebench, but the workload now runs file 8x file
creators in parallel with 16x random size file appenders (with 1% of the
dataset being preallocated to support the appends, and thus without
contention). In total, it creates 10k files that amount to ~5.8TB of
space. The filesystem geometry is as follows:

meta-data=/dev/mapper/fedora_hpe--apollo--cn99xx--19-tmp isize=512    agcount=8, agsize=268435455 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=1941012480, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

The locality data is collected via a hacked up variant of 'xfs_db -c
frag ...' that reuses the 'freesp' command histogram to display locality
deltas instead of extent lengths. Each bucket shows how many
extents/allocs fall into that particular delta range and the average
length of the associated extents. Note that the percent column is based
on extent count vs the total (not block or delta counts). Finally, note
that the final row uses a dummy value of agsize to account AG jumps. As
such, the associated delta values are invalid, but the extent count/size
values are valid. This data is included to provide some insight on how
often we fall back to external AGs (from the locality target) due to
contention.

Bear in mind that so far I've only run this workload once on each kernel
and I believe there is opportunity for variance run-to-run. Current data
and observations follow:

- Baseline kernel (5.2.0-rc1):

Files on this filesystem average 59.81 extents per file
      from         to    extents           delta      avgsz    pct
         0          0          1               0       4879   0.00
         1          1         18              18        633   0.00
         2          3         76             193        630   0.01
         4          7        117             644      10801   0.02
         8         15        246            2735        701   0.04
        16         31        411            9769        873   0.07
        32         63        858           40614        877   0.14
        64        127       1931          183122        872   0.32
       128        255       3658          693079       1423   0.60
       256        511       4393         1619094        767   0.73
       512       1023       6049         4582491        666   1.00
      1024       2047      19564        34684608        810   3.23
      2048       4095      21391        62471744        828   3.53
      4096       8191      24735       140424459        920   4.08
      8192      16383      18383       213465918       1030   3.03
     16384      32767      14447       336272956       1195   2.38
     32768      65535      12359       580683797       1154   2.04
     65536     131071      11943      1138606730       1446   1.97
    131072     262143      16825      3279118006       1701   2.78
    262144     524287      32133     12725299194       1905   5.30
    524288    1048575      58899     45775066024       1845   9.72
   1048576    2097151      95302    147197567651       2020  15.73
   2097152    4194303      86659    252037848233       2794  14.30
   4194304    8388607      67067    397513880288       2876  11.07
   8388608   16777215      47940    583161227489       2319   7.91
  16777216   33554431      24878    537577890034       3321   4.11
  33554432   67108863       5889    269065981311      16106   0.97
  67108864  134217727       3022    304867554478      33429   0.50
 134217728  268435454       2994    539180795612      35744   0.49
 268435455  268435455      23709   6364336202595       4840   3.91

- Control (base w/ unconditional SIZE mode allocs):

Files on this filesystem average 58.60 extents per file
      from         to    extents           delta      avgsz    pct
         0          0          1               0        180   0.00
         4          7         19             115      11379   0.00
         8         15         21             231         15   0.00
        16         31          3              58         45   0.00
        64        127          3             288       7124   0.00
       128        255          4             780      60296   0.00
       256        511          3             978      51563   0.00
       512       1023          9            7072     105727   0.00
      1024       2047         33           50773       4765   0.01
      2048       4095         98          306258      15689   0.02
      4096       8191        258         1513775       1981   0.04
      8192      16383        458         5633481       2537   0.08
     16384      32767        934        23078682       3013   0.16
     32768      65535       1783        87851701       3109   0.30
     65536     131071       3382       332685185       1810   0.57
    131072     262143       8904      1784659842       2275   1.50
    262144     524287      23878      9433551033       1903   4.02
    524288    1048575      54422     42483032893       1894   9.17
   1048576    2097151      97884    148883431239       2048  16.49
   2097152    4194303      81999    236737184381       2741  13.81
   4194304    8388607      86826    510450130696       2639  14.63
   8388608   16777215      54870    652250378434       2101   9.24
  16777216   33554431      40408    985568011752       1959   6.81
  33554432   67108863      46354   2258464180697       2538   7.81
  67108864  134217727      59461   5705095317989       3380  10.02
 134217728  268435454      16205   2676447855794       4891   2.73
 268435455  268435455      15423   4140080022465       5243   2.60

- Test (base + this series):

Files on this filesystem average 59.76 extents per file
      from         to    extents           delta      avgsz    pct
         0          0          2               0        419   0.00
         1          1        258             258        387   0.04
         2          3         81             201        598   0.01
         4          7        139             790      13824   0.02
         8         15        257            2795        710   0.04
        16         31        417            9790        852   0.07
        32         63        643           30714        901   0.11
        64        127       1158          110148        835   0.19
       128        255       1947          370953        822   0.32
       256        511       3567         1348313        744   0.59
       512       1023       5151         3921794        695   0.85
      1024       2047      22895        39640251        924   3.78
      2048       4095      34375       100757727        922   5.68
      4096       8191      30381       171773183        914   5.02
      8192      16383      18977       214896159       1091   3.13
     16384      32767       8460       192726268       1212   1.40
     32768      65535       6071       286544623       1611   1.00
     65536     131071       7803       757765738       1680   1.29
    131072     262143      15300      3001300980       1877   2.53
    262144     524287      27218     10868169139       1993   4.50
    524288    1048575      60423     47321126020       1948   9.98
   1048576    2097151     100683    158191884842       2174  16.63
   2097152    4194303      92642    274106200889       2508  15.30
   4194304    8388607      73987    436219940202       2421  12.22
   8388608   16777215      49636    591854981117       2434   8.20
  16777216   33554431      15716    353157130237       4772   2.60
  33554432   67108863       4948    228004142686      19221   0.82
  67108864  134217727       2381    231811967738      35781   0.39
 134217728  268435454       2140    385403697868      29221   0.35
 268435455  268435455      17746   4763655584430       7603   2.93

Firstly, comparison of the baseline and control data shows that near
mode allocation is effective at improving allocation locality compared
to size mode. In both cases, the 1048576-4194304 buckets hold the
majority of extents. If we look at the sub-1048576 data, however, ~40%
of allocations land in this range on the baseline kernel vs. only ~16%
for the control. Another interesting data point is the noticeable drop
in AG skips (~24k) from the baseline kernel to the control (~15k). I
suspect this is due to the additional overhead of locality based
allocation causing more contention.

Comparison of the baseline and test data shows a generally similar
breakdown between the two. The sub-1048576 range populates the same
buckets and makes up ~41% of the total extents. The per-bucket numbers
differ, but all of the buckets are within a percentage point or so. One
previously unknown advantage of the test algorithm shown by this data is
that the number of AG skips drops down to ~18k, which almost splits the
difference between the baseline and control (and slightly in favor of
the latter). I suspect that is related to the more simple and bounded
near mode algorithm as compared to the current 

Thoughts on any of this data or presentation? I could dig further into
details or alternatively base the histogram on something like extent
size and show the average delta for each extent size bucket, but I'm not
sure that will tell us anything profound with respect to this patchset.
One thing I noticed while processing this data is that the current
dataset skews heavily towards smaller allocations. I still think it's a
useful comparison because smaller allocations are more likely to stress
either algorithm via a larger locality search space, but I may try to
repeat this test with a workload with fewer files and larger allocations
and see how that changes things.

Brian
