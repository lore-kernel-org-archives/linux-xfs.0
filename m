Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729838AbfHOMzk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Aug 2019 08:55:40 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A63253023083
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2019 12:55:39 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E4715DA8B
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2019 12:55:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/4] xfs: rework near mode extent allocation
Date: Thu, 15 Aug 2019 08:55:34 -0400
Message-Id: <20190815125538.49570-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's a v3 of the near allocation mode extent rework algorithm. The
most obvious difference from v2 is that I've dropped the by-size and
exact mode algorithm reworks and subsequent refactoring from the series
for now. It became a bit unwieldy to keep everything together with all
of the refactoring and whatnot, so I'll plan to follow up with those
bits once the near mode algorithm and associated factoring is settled.
Refer to the previous version(s) for an idea of how this approach
facilitates reuse by the other allocation modes.

Another notable change from v2 is reintroduction of the "last block
scan" in the near mode algorithm. I found that this logic tends to
dominate on allocations from a clean filesystem for quite some time, so
this change adds some consistency between current behavior/performance
and with this patch and makes the fundamental algorithm change a bit
more conservative. From an algorithmic perspective, this change now
essentially enhances the fallback algorithm from a pure bnobt span to a
combined bnobt/cntbt span for improved worst case performance at a
slight cost in locality.

This version has been more thoroughly tested than the previous versions.
I've run fstests with various configurations without regression and some
performance tests to compare with the existing allocator with regard to
performance and resulting allocation locality. While the latter is a bit
ad hoc, it provides some data as to how much this patch changes locality
allocations over time. IOW, the locality data is not necessarily for
deep analysis or detailed comparison of locality between the algorithms,
but rather to provide a data point that locality is still effective with
the algorithm change.

I'll append some raw data to the end of this mail for some of the more
recent filebench tests. For context, each test runs on the same 16xcpu
128GB RAM box against the same striped lvm volume. The test is a simple
64x concurrent file write+fsync of a random distribution of file sizes
from 4k to 500MB to fill up ~70% of a 500GB (16 AGs) fs. The locality
output is from a hacked up version of the xfs_io 'frag' command to scan
for and measure distances of known near mode allocations from the
presumed hint (i.e., the previous extent in a file or the inode location
for initial extents). The largest histogram bucket is the AG size and
represents AG switches (i.e., an allocation occurred on an external AG
from the locality hint).

The first set of tests are run against a clean filesystem and show
comparable performance and locality between the original and updated
algorithms. The second set of tests prepopulates the filesystem and
creates a sequence of randomly sized free space extents before the test
runs. This test is designed to stress the updated algorithm by creating
a large set of unique and randomly sized free extents. Not surprisingly,
this test shows slightly degraded performance for the updated algorithm
when compared to the baseline. While this is not quite an apples to
apples comparison, this is a significantly milder degradation than what
occurs when the baseline algorithm encounters its worst case free space
layout (refer to the v1 cover letter for details). Note that both
variants of the test were repeated a couple times but I'm only including
one set of output for each since the runs were similar.

An interesting design note related to the performance results is that
some followup experimentation shows that the performance is fairly
sensitive to the search key increment aggressiveness implemented in
xfs_alloc_lookup_iter(). This controls how aggressive we search for
ideal locality in the lookup algorithm once we've already found one
suitable maxlen extent. The currently implemented approach is to visit
each set of equal size extents until we have an allocation candidate and
from that point forward, double the search cur key to optimize the scan
of the rest of the tree for better locality. A hack to this logic to
exit on the first available extent can turn the above slight performance
degradation into an overall improvement at the cost of random locality
(i.e., this basically becomes a by-size allocation). I've played around
with this a bit to try and improve this heuristic and close the gap from
the current algorithm, including even considering some form of sysfs
knob to tune behavior (even if just for debug/testing), but so far I
haven't come up with anything preferable to the simplicity of the
current approach that doesn't negatively affect the effectiveness of the
allocator with respect to locality.

Thoughts, reviews, flames appreciated.

Brian

v3:
- Drop by-size and exact allocation rework bits.
- Add near mode last block scan.
- Add debug mode patch to randomly toggle near mode algos.
- Refactor cursor setup/lookup logic.
- Refactor minlen reverse scan to be common between near mode algos.
- Fix up logic to consistently prioritize extent size over locality.
- Add more useful tracepoints.
- Miscellaneous bug fixes and code/comment cleanups.
v2: https://marc.info/?l=linux-xfs&m=155854834815400&w=2
- Lift small mode refactoring into separate patch (retained review
  tag(s).
- Various logic cleanups and refactors.
- Push active flag down into btree cursor private area; eliminate cursor
  container struct.
- Refactor final allocation code. Fold xfs_alloc_ag_vextent_type() into
  caller and factor out accounting.                                                                                                                     
- Fix up tracepoints.
v1: https://marc.info/?l=linux-xfs&m=155742169729590&w=2
- Continued development (various fixes, refinements) on generic bits and
  near mode implementation.
- Added patches 4-6 to refactor exact, by-size and small allocation
  modes.
rfcv2: https://marc.info/?l=linux-xfs&m=155197946630582&w=2
- Dropped spurious initial refactoring.
- Added minlen functionality.
- Properly tied into near alloc path.
- General refactoring and cleanups.
rfcv1: https://marc.info/?l=linux-xfs&m=154479089914351&w=2

Brian Foster (4):
  xfs: track active state of allocation btree cursors
  xfs: use locality optimized cntbt lookups for near mode allocations
  xfs: randomly fall back to near mode lookup algorithm in debug mode
  xfs: refactor successful AG allocation accounting code

 fs/xfs/libxfs/xfs_alloc.c       | 1156 +++++++++++++++++--------------
 fs/xfs/libxfs/xfs_alloc_btree.c |    1 +
 fs/xfs/libxfs/xfs_btree.h       |    3 +
 fs/xfs/xfs_trace.h              |   43 +-
 4 files changed, 660 insertions(+), 543 deletions(-)

-- 
2.20.1

--- test results

- clean fs, baseline:

 2016: 3537.429: Run took 3536 seconds...
 2016: 3537.431: Per-Operation Breakdown
closefile1           39939ops       11ops/s   0.0mb/s      1.2ms/op      430us/op-cpu [0ms - 1812ms]
fsync1               39944ops       11ops/s   0.0mb/s   5557.3ms/op   688845us/op-cpu [3ms - 429730ms]
writefile1           39999ops       11ops/s 100.4mb/s      6.8ms/op    10280us/op-cpu [0ms - 532ms]
createfile1          40000ops       11ops/s   0.0mb/s      0.5ms/op      814us/op-cpu [0ms - 801ms]
 2016: 3537.431: IO Summary: 159882 ops, 45.211 ops/s, (0/11 r/w), 100.4mb/s,  12807us cpu/op, 5558.1ms latency
 2016: 3537.431: Shutting down processes

actual 40732, ideal 40720, fragmentation factor 0.03%
Note, this number is largely meaningless.
Files on this filesystem average 1.00 extents per file
   from      to extents  blocks    pct
      0       0       6       0   0.01
      1       1      81      81   0.20
      2       3     343     884   0.84
      4       7    1173    6786   2.88
      8      15    3527   35273   8.66
     16      31     488   11400   1.20
     32      63    3153  140510   7.74
     64     127    2567  233234   6.30
    128     255    1175  201550   2.88
    256     511     568  216547   1.39
    512    1023     627  460669   1.54
   1024    2047     831 1357531   2.04
   2048    4095     857 2498448   2.10
   4096    8191     597 3637740   1.47
   8192   16383     516 6196647   1.27
  16384   32767     690 16778626   1.69
  32768   65535    1189 58881806   2.92
  65536  131071    1582 152275877   3.88
 131072  262143    2078 397775535   5.10
 262144  524287    3163 1250504038   7.77
 524288 1048575    2789 2010791315   6.85
1048576 2097151    2956 4678090228   7.26
2097152 4194303    4084 12741930013  10.03
4194304 8191983    2239 11372991216   5.50
8191984 8191984    3453 28286920752   8.48

- clean fs, test:

19362: 3540.426: Run took 3539 seconds...
19362: 3540.428: Per-Operation Breakdown
closefile1           39942ops       11ops/s   0.0mb/s      1.1ms/op      459us/op-cpu [0ms - 1991ms]
fsync1               39945ops       11ops/s   0.0mb/s   5566.4ms/op   692442us/op-cpu [3ms - 464333ms]
writefile1           39999ops       11ops/s 100.3mb/s      6.9ms/op    10198us/op-cpu [0ms - 544ms]
createfile1          40000ops       11ops/s   0.0mb/s      0.4ms/op      675us/op-cpu [0ms - 752ms]
19362: 3540.428: IO Summary: 159886 ops, 45.174 ops/s, (0/11 r/w), 100.3mb/s,  12928us cpu/op, 5567.2ms latency
19362: 3540.428: Shutting down processes

actual 40730, ideal 40720, fragmentation factor 0.02%
Note, this number is largely meaningless.
Files on this filesystem average 1.00 extents per file
   from      to extents  blocks    pct
      0       0       6       0   0.01
      1       1     109     109   0.27
      2       3     338     856   0.83
      4       7    1136    6582   2.79
      8      15    3408   33781   8.37
     16      31     648   14649   1.59
     32      63    3145  142563   7.72
     64     127    2809  258454   6.90
    128     255    1482  255051   3.64
    256     511     502  191520   1.23
    512    1023     654  487802   1.61
   1024    2047    1067 1752771   2.62
   2048    4095    1109 3314767   2.72
   4096    8191     906 5534201   2.22
   8192   16383     649 8100247   1.59
  16384   32767     812 18740413   1.99
  32768   65535     996 46874568   2.45
  65536  131071    1861 181198557   4.57
 131072  262143    2570 480355851   6.31
 262144  524287    1801 663068591   4.42
 524288 1048575    2010 1564391753   4.93
1048576 2097151    3008 4760143526   7.39
2097152 4194303    4485 13773793202  11.01
4194304 8191983    1686 8263583893   4.14
8191984 8191984    3533 28942279472   8.67

- randomized free space, baseline:

 1933: 4053.531: Run took 4052 seconds...
 1933: 4053.533: Per-Operation Breakdown
closefile1           39939ops       10ops/s   0.0mb/s      1.1ms/op      470us/op-cpu [0ms - 1339ms]
fsync1               39939ops       10ops/s   0.0mb/s   6379.4ms/op   677902us/op-cpu [3ms - 376494ms]
writefile1           39997ops       10ops/s  87.6mb/s      6.8ms/op    10159us/op-cpu [0ms - 522ms]
createfile1          40000ops       10ops/s   0.0mb/s      0.7ms/op      887us/op-cpu [0ms - 371ms]
 1933: 4053.533: IO Summary: 159875 ops, 39.452 ops/s, (0/10 r/w),  87.6mb/s,  13219us cpu/op, 6378.8ms latency
 1933: 4053.533: Shutting down processes

actual 82107, ideal 72320, fragmentation factor 11.92%
Note, this number is largely meaningless.
Files on this filesystem average 1.14 extents per file
   from      to extents  blocks    pct
      0       0       2       0   0.00
      1       1      74      74   0.09
      2       3     371     962   0.45
      4       7    1174    6710   1.43
      8      15    3633   36965   4.42
     16      31     859   19650   1.05
     32      63    3244  145941   3.95
     64     127    2945  267753   3.59
    128     255    1940  347233   2.36
    256     511    1537  579226   1.87
    512    1023    2597 1977748   3.16
   1024    2047    4773 7310593   5.81
   2048    4095    8990 27491096  10.95
   4096    8191   16422 100901820  20.00
   8192   16383     816 9837468   0.99
  16384   32767     914 21952573   1.11
  32768   65535    2037 98635533   2.48
  65536  131071    3434 336852501   4.18
 131072  262143    3340 593712009   4.07
 262144  524287    2459 951760115   2.99
 524288 1048575    2808 2116317254   3.42
1048576 2097151    2479 3510197318   3.02
2097152 4194303    1005 2975191867   1.22
4194304 8191983     571 3166999981   0.70
8191984 8191984   13683 112090917072  16.66

- randomized free space, test:

 1837: 4117.481: Run took 4116 seconds...
 1837: 4117.483: Per-Operation Breakdown
closefile1           39937ops       10ops/s   0.0mb/s      1.5ms/op      535us/op-cpu [0ms - 1507ms]
fsync1               39937ops       10ops/s   0.0mb/s   6488.7ms/op   682138us/op-cpu [2ms - 399490ms]
writefile1           40000ops       10ops/s  86.2mb/s      6.8ms/op    10332us/op-cpu [0ms - 524ms]
createfile1          40000ops       10ops/s   0.0mb/s      0.7ms/op      852us/op-cpu [0ms - 1027ms]
 1837: 4117.483: IO Summary: 159874 ops, 38.839 ops/s, (0/10 r/w),  86.2mb/s,  13295us cpu/op, 6487.5ms latency
 1837: 4117.483: Shutting down processes

actual 82311, ideal 72323, fragmentation factor 12.13%
Note, this number is largely meaningless.
Files on this filesystem average 1.14 extents per file
   from      to extents  blocks    pct
      0       0       7       0   0.01
      1       1      95      95   0.12
      2       3     395    1032   0.48
      4       7    1169    6696   1.42
      8      15    3512   35631   4.27
     16      31    1167   25350   1.42
     32      63    3563  161086   4.33
     64     127    3296  299665   4.00
    128     255    2370  426781   2.88
    256     511    2568  977733   3.12
    512    1023    4357 3271492   5.29
   1024    2047    5871 8937475   7.13
   2048    4095    9396 28541302  11.42
   4096    8191   16546 101380257  20.10
   8192   16383     400 4415125   0.49
  16384   32767     206 4922473   0.25
  32768   65535     256 12692379   0.31
  65536  131071     318 30349888   0.39
 131072  262143     467 90335617   0.57
 262144  524287     803 312116185   0.98
 524288 1048575    1238 972993740   1.50
1048576 2097151    2173 3398364897   2.64
2097152 4194303    3594 11074400645   4.37
4194304 8191983    4362 25547937595   5.30
8191984 8191984   14182 116178717088  17.23
