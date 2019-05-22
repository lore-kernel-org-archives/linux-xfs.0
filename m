Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46804 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbfEVSFr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 14:05:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CC6285360
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:47 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEE825C296
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:46 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 00/11] xfs: rework extent allocation
Date: Wed, 22 May 2019 14:05:35 -0400
Message-Id: <20190522180546.17063-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is v2 of the extent allocation rework series. The changes in this
version are mostly associated with code factoring, based on feedback to
v1. The small mode helper refactoring has been isolated and pulled to
the start of the series. The active flag that necessitated the btree
cursor container structure has been pushed into the xfs_btree_cur
private area. The resulting high level allocation code in
xfs_ag_alloc_vextent() has been cleaned up to remove an unnecessary
level of abstraction. Finally, there are various minor cleanups and
fixes.

On the testing front, I've run a couple more filebench oriented tests
since v1. The first is a high load, large filesystem, parallel file
write+fsync test to try and determine whether the modified near mode
allocation algorithm resulted in larger latencies in the common
(non-fragmented) case. The results show comparable latencies, though the
updated algorithm has a slightly faster overall runtime for whatever
reason.

The second is another filebench test (but with a smaller fileset against
a smaller filesystem), but with the purpose of measuring "locality
effectiveness" of the updated algorithm via post-test analysis of the
resulting/populated filesystem. I've been thinking a bit about how to
test for locality since starting on this series and ultimately came up
with the following, fairly crude heuristic: track and compare the worst
locality allocation for each regular file inode in the fs. This
essentially locates the most distant extent for each inode, tracks the
delta from that extent to the inode location on disk and calculates the
average worst case delta across the entire set of regular files. The
results show that the updated algorithm provides a comparable level of
locality to the existing algorithm. Note that this test also involves a
control run using a kernel modified to replace all near mode allocations
with by-size allocations. This is to show the effectiveness of near mode
allocation in general as compared to essentially random allocations.

Further details and results from both of these tests are appended below
the changelog. Thoughts, reviews, flames appreciated.

Brian

v2:
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

--- filebench 200 thread file create test, 20k files, 7TB 32AG fs:

- baseline summary results (3 runs):

 3541: 34498.540: Run took 34495 seconds...
 3541: 34498.547: Per-Operation Breakdown
closefile1           19801ops        1ops/s   0.0mb/s      0.0ms/op      318us/op-cpu [0ms - 5ms]
fsync1               19801ops        1ops/s   0.0mb/s    883.0ms/op   408529us/op-cpu [0ms - 106670ms]
writefile1           19801ops        1ops/s 152.5mb/s 322687.8ms/op 80040329us/op-cpu [0ms - 10344864ms]
createfile1          20000ops        1ops/s   0.0mb/s      1.0ms/op     8460us/op-cpu [0ms - 593ms]
 3541: 34498.548: IO Summary: 79403 ops, 2.302 ops/s, (0/1 r/w), 152.5mb/s, 174211us cpu/op, 323571.9ms latency

94799: 34457.516: Run took 34454 seconds...
94799: 34457.524: Per-Operation Breakdown
closefile1           19801ops        1ops/s   0.0mb/s      0.1ms/op      266us/op-cpu [0ms - 329ms]
fsync1               19801ops        1ops/s   0.0mb/s   1014.5ms/op   394296us/op-cpu [0ms - 188565ms]
writefile1           19801ops        1ops/s 152.7mb/s 322228.1ms/op 80961984us/op-cpu [0ms - 10354419ms]
createfile1          20000ops        1ops/s   0.0mb/s      0.9ms/op    10845us/op-cpu [0ms - 944ms]
94799: 34457.524: IO Summary: 79403 ops, 2.304 ops/s, (0/1 r/w), 152.7mb/s, 174494us cpu/op, 323243.6ms latency

70863: 34440.504: Run took 34437 seconds...
70863: 34440.513: Per-Operation Breakdown
closefile1           19801ops        1ops/s   0.0mb/s      0.0ms/op      322us/op-cpu [0ms - 43ms]
fsync1               19801ops        1ops/s   0.0mb/s    909.0ms/op   412324us/op-cpu [0ms - 135906ms]
writefile1           19801ops        1ops/s 152.8mb/s 322198.4ms/op 82080900us/op-cpu [0ms - 10368105ms]
createfile1          20000ops        1ops/s   0.0mb/s      1.0ms/op     9544us/op-cpu [0ms - 605ms]
70863: 34440.513: IO Summary: 79403 ops, 2.306 ops/s, (0/1 r/w), 152.8mb/s, 174420us cpu/op, 323108.4ms latency

- test summary results:

22975: 34215.483: Run took 34212 seconds...
22975: 34215.491: Per-Operation Breakdown
closefile1           19801ops        1ops/s   0.0mb/s      0.0ms/op      272us/op-cpu [0ms - 7ms]
fsync1               19801ops        1ops/s   0.0mb/s    914.5ms/op   383151us/op-cpu [0ms - 176244ms]
writefile1           19801ops        1ops/s 153.8mb/s 319896.9ms/op 75523888us/op-cpu [0ms - 10337439ms]
createfile1          20000ops        1ops/s   0.0mb/s      1.1ms/op    12534us/op-cpu [0ms - 628ms]
22975: 34215.491: IO Summary: 79403 ops, 2.321 ops/s, (0/1 r/w), 153.8mb/s, 322858us cpu/op, 320812.6ms latency

 3954: 34197.494: Run took 34194 seconds...
 3954: 34197.503: Per-Operation Breakdown
closefile1           19801ops        1ops/s   0.0mb/s      0.1ms/op      261us/op-cpu [0ms - 549ms]
fsync1               19801ops        1ops/s   0.0mb/s    808.8ms/op   376216us/op-cpu [0ms - 107815ms]
writefile1           19801ops        1ops/s 153.8mb/s 319904.9ms/op 86184221us/op-cpu [0ms - 10315909ms]
createfile1          20000ops        1ops/s   0.0mb/s      1.0ms/op     5954us/op-cpu [0ms - 591ms]
 3954: 34197.503: IO Summary: 79403 ops, 2.322 ops/s, (0/1 r/w), 153.8mb/s, 172877us cpu/op, 320714.8ms latency

180845: 34295.481: Run took 34292 seconds...
180845: 34295.489: Per-Operation Breakdown
closefile1           19801ops        1ops/s   0.0mb/s      0.1ms/op      306us/op-cpu [0ms - 330ms]
fsync1               19801ops        1ops/s   0.0mb/s    868.4ms/op   387699us/op-cpu [0ms - 159923ms]
writefile1           19801ops        1ops/s 153.4mb/s 320814.7ms/op 84496457us/op-cpu [0ms - 10314107ms]
createfile1          20000ops        1ops/s   0.0mb/s      1.4ms/op     6386us/op-cpu [0ms - 425ms]
180845: 34295.489: IO Summary: 79403 ops, 2.315 ops/s, (0/1 r/w), 153.4mb/s, 174443us cpu/op, 321684.6ms latency

--- filebench 200 thread file create test, 5k files, 2TB 64AG fs
    (agsize: 8388608 4k blocks)

Locality measured in 512b sectors.

- baseline	- min: 8  max: 568752250 median: 434794.5 mean: 11446328
- test		- min: 33 max: 568402234 median: 437405.5 mean: 11752963
- by-size only	- min: 33 max: 568593146 median: 784805   mean: 11912300

Brian Foster (11):
  xfs: clean up small allocation helper
  xfs: move small allocation helper
  xfs: skip small alloc cntbt logic on NULL cursor
  xfs: always update params on small allocation
  xfs: track active state of allocation btree cursors
  xfs: use locality optimized cntbt lookups for near mode allocations
  xfs: refactor exact extent allocation mode
  xfs: refactor by-size extent allocation mode
  xfs: replace small allocation logic with agfl only logic
  xfs: refactor successful AG allocation accounting code
  xfs: condense high level AG allocation functions

 fs/xfs/libxfs/xfs_alloc.c       | 1485 +++++++++++++------------------
 fs/xfs/libxfs/xfs_alloc_btree.c |    1 +
 fs/xfs/libxfs/xfs_btree.h       |    3 +
 fs/xfs/xfs_trace.h              |   44 +-
 4 files changed, 643 insertions(+), 890 deletions(-)

-- 
2.17.2
