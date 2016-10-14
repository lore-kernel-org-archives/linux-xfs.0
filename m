Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48644 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755469AbcJNM2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2016 08:28:13 -0400
From: Chris Mason <clm@fb.com>
Subject: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag during
 slab reclaim
Message-ID: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
Date: Fri, 14 Oct 2016 08:27:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org


Hi Dave,

This is part of a series of patches we're growing to fix a perf
regression on a few straggler tiers that are still on v3.10.  In this
case, hadoop had to switch back to v3.10 because v4.x is as much as 15%
slower on recent kernels.

Between v3.10 and v4.x, kswapd is less effective overall.  This leads
more and more procs to get bogged down in direct reclaim Using SYNC_WAIT
in xfs_reclaim_inodes_ag().

Since slab shrinking happens very early in direct reclaim, we've seen
systems with 130GB of ram where hundreds of procs are stuck on the xfs
slab shrinker fighting to walk a slab 900MB in size.  They'd have better
luck moving on to the page cache instead.

Also, we're going into direct reclaim much more often than we should
because kswapd is getting stuck on XFS inode locks and writeback.
Dropping the SYNC_WAIT means that kswapd can move on to other things and
let the async worker threads get kicked to work on the inodes.

We're still working on the series, and this is only compile tested on
current Linus git.  I'm working out some better simulations for the
hadoop workload to stuff into Mel's tests.  Numbers from prod take
roughly 3 days to stabilize, so I haven't isolated this patch from the rest
of the series.

Unpatched v4.x our base allocation stall rate goes up to as much as
200-300/sec, averaging 70/sec.  The series I'm finalizing gets that
number down to < 1 /sec.

Omar Sandoval did some digging and found you added the SYNC_WAIT in
response to a workload I sent ages ago.  I tried to make this OOM with
fsmark creating empty files, and it has been soaking in memory
constrained workloads in production for almost two weeks.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/xfs/xfs_icache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index bf2d607..63938fb 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1195,7 +1195,7 @@ xfs_reclaim_inodes_nr(
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT, &nr_to_scan);
+	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
 }
 
 /*
-- 
2.9.3

