Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:54497 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752824AbcKNH1O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 02:27:14 -0500
Date: Mon, 14 Nov 2016 18:27:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161114072708.GN28922@dastard>
References: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
 <20161015223454.GS23194@dastard>
 <20161017002427.GA70229@clm-mbp.masoncoding.com>
 <20161017015251.GU23194@dastard>
 <e0c37926-a670-98b6-4bd7-b438def130bd@fb.com>
 <20161017223057.GV23194@dastard>
 <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
 <20161018020324.GA23194@dastard>
 <20161114005951.GB2127@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161114005951.GB2127@clm-mbp.thefacebook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Nov 13, 2016 at 08:00:04PM -0500, Chris Mason wrote:
> On Tue, Oct 18, 2016 at 01:03:24PM +1100, Dave Chinner wrote:
> 
> [ Long stalls from xfs_reclaim_inodes_ag ]
> 
> >XFS has *1* tunable that can change the behaviour of metadata
> >writeback. Please try it.
> 
> [ weeks go by, so this email is insanely long ]
> 
> Testing all of this was slow going because two of the three test
> boxes I had with the hadoop configuration starting having hardware
> problems.  The good news is that while I was adjusting the
> benchmark, we lined up access to a bunch of duplicate boxes, so I
> can now try ~20 different configurations in parallel.
> 
> My rough benchmark is here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/simoop.git
> 
> The command line I ended up using was:
> 
> simoop -t 512 -m 190 -M 128 -C 28 -r 60000 -f 70 -T 20 -R1 -W 1 -i
> 60 -w 300 -D 2 /hammer/*

There's a lightly tested patch below that should do the trick.

After 5 minutes on a modified simoop cli on a single filesystem,
4.9-rc4+for-next:

$ ./simoop -t 128 -m 50 -M 128 -C 14 -r 60000 -f 2 -T 20 -R1 -W 1 -i 60 -w 300 -D 2 /mnt/scratch
....
Run time: 300 seconds
Read latency (p50: 3,174,400) (p95: 4,530,176) (p99: 18,055,168)
Write latency (p50: 14,991,360) (p95: 28,672,000) (p99: 33,325,056)
Allocation latency (p50: 1,771,520) (p95: 17,530,880) (p99: 23,756,800)
work rate = 4.75/sec (avg 5.24/sec) (p50: 5.79) (p95: 6.99) (p99: 6.99)
alloc stall rate = 94.42/sec (avg: 51.63) (p50: 51.60) (p95: 59.12) (p99: 59.12)

With the patch below:

Run time: 300 seconds
Read latency (p50: 3,043,328) (p95: 3,649,536) (p99: 4,710,400)
Write latency (p50: 21,004,288) (p95: 27,557,888) (p99: 29,130,752)
Allocation latency (p50: 280,064) (p95: 680,960) (p99: 863,232)
work rate = 4.08/sec (avg 4.76/sec) (p50: 5.39) (p95: 6.93) (p99: 6.93)
alloc stall rate = 0.08/sec (avg: 0.02) (p50: 0.00) (p95: 0.01) (p99: 0.01)

Stall rate went to zero and stayed there at the 120s mark of the
warmup. Note the p99 difference for read and allocation latency,
too.

I'll post some graphs tomorrow from my live PCP telemetry that
demonstrate the difference in behaviour better than any words...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: reduce blocking in inode reclaim

From: Dave Chinner <dchinner@redhat.com>

When we already have maximum reclaim concurrency going on, stop the
caller from doing any more reclaim rather than blocking them.
Instead, transfer the scanning work the next context that gets
access to the reclaim locks.

Further, make sure not to block kswapd ireclaim on IO or locks. This
means it will always be able to move on to reclaim something else
rather than blocking and preventing reclaim from other filesytsems.

Finally, change the blocking reclaim cases to follow the reclaim
cursor so that we don't restart from a position where inodes may
curentl be under IO from a previous flush. This means we cycle
through all inodes int eh AG before revisting indoes that may now be
clean for reclaim.

This change does not appear to cause overall performance regression
with the pure dirty inode cache load (such as fsmark inode creation)
and inode traversal worklaods (find, rm -rf) on inodes
collections much larger than can be cached in memory. The reclaim
pattern is noticably lumpier, so work still to be done.

Under initial simoop testing, p99 read latencies are down by 70%,
p99 allocation latency is down by over 90% and allocation stalls
completely go away.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/super.c          |  8 +++++++-
 fs/xfs/xfs_icache.c | 59 +++++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index c183835566c1..9fff5630b12d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -102,8 +102,14 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	freed += prune_icache_sb(sb, sc);
 
 	if (fs_objects) {
+		unsigned long ret;
+
 		sc->nr_to_scan = fs_objects + 1;
-		freed += sb->s_op->free_cached_objects(sb, sc);
+		ret = sb->s_op->free_cached_objects(sb, sc);
+		if (ret == SHRINK_STOP)
+			freed = SHRINK_STOP;
+		else
+			freed += ret;
 	}
 
 	up_read(&sb->s_umount);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9c3e5c6ddf20..65c0f79f3edc 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -975,7 +975,7 @@ xfs_reclaim_inode(
 	error = 0;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (!xfs_iflock_nowait(ip)) {
-		if (!(sync_mode & SYNC_WAIT))
+		if (sync_mode & SYNC_TRYLOCK)
 			goto out;
 		xfs_iflock(ip);
 	}
@@ -987,7 +987,7 @@ xfs_reclaim_inode(
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip)) {
-		if (!(sync_mode & SYNC_WAIT))
+		if (sync_mode & SYNC_TRYLOCK)
 			goto out_ifunlock;
 		xfs_iunpin_wait(ip);
 	}
@@ -1103,7 +1103,7 @@ xfs_reclaim_inode(
  * then a shut down during filesystem unmount reclaim walk leak all the
  * unreclaimed inodes.
  */
-STATIC int
+STATIC long
 xfs_reclaim_inodes_ag(
 	struct xfs_mount	*mp,
 	int			flags,
@@ -1113,18 +1113,22 @@ xfs_reclaim_inodes_ag(
 	int			error = 0;
 	int			last_error = 0;
 	xfs_agnumber_t		ag;
-	int			trylock = flags & SYNC_TRYLOCK;
+	int			trylock;
 	int			skipped;
+	int			dirty_ags;
 
 restart:
+	trylock = flags & SYNC_TRYLOCK;
 	ag = 0;
 	skipped = 0;
+	dirty_ags = 0;
 	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
 		unsigned long	first_index = 0;
 		int		done = 0;
 		int		nr_found = 0;
 
 		ag = pag->pag_agno + 1;
+		dirty_ags++;
 
 		if (trylock) {
 			if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
@@ -1132,10 +1136,16 @@ xfs_reclaim_inodes_ag(
 				xfs_perag_put(pag);
 				continue;
 			}
-			first_index = pag->pag_ici_reclaim_cursor;
 		} else
 			mutex_lock(&pag->pag_ici_reclaim_lock);
 
+		/*
+		 * Always start from the last scanned inode so that we don't
+		 * block on inodes that a previous iteration just flushed.
+		 * Iterate over the entire inode range before coming back to
+		 * skipped/dirty inodes.
+		 */
+		first_index = pag->pag_ici_reclaim_cursor;
 		do {
 			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
 			int	i;
@@ -1201,23 +1211,31 @@ xfs_reclaim_inodes_ag(
 
 		} while (nr_found && !done && *nr_to_scan > 0);
 
-		if (trylock && !done)
-			pag->pag_ici_reclaim_cursor = first_index;
-		else
-			pag->pag_ici_reclaim_cursor = 0;
+		if (done)
+			first_index = 0;
+		pag->pag_ici_reclaim_cursor = first_index;
 		mutex_unlock(&pag->pag_ici_reclaim_lock);
 		xfs_perag_put(pag);
 	}
 
 	/*
-	 * if we skipped any AG, and we still have scan count remaining, do
+	 * If we skipped all AGs because they are locked, we've reached maximum
+	 * reclaim concurrency. At this point there is no point in having more
+	 * attempts to shrink the cache from this context. Tell the shrinker to
+	 * stop and defer the reclaim work till later.
+	 */
+	if (skipped && skipped == dirty_ags)
+		return SHRINK_STOP;
+
+	/*
+	 * If we skipped any AG, and we still have scan count remaining, do
 	 * another pass this time using blocking reclaim semantics (i.e
 	 * waiting on the reclaim locks and ignoring the reclaim cursors). This
 	 * ensure that when we get more reclaimers than AGs we block rather
 	 * than spin trying to execute reclaim.
 	 */
 	if (skipped && (flags & SYNC_WAIT) && *nr_to_scan > 0) {
-		trylock = 0;
+		flags &= ~SYNC_TRYLOCK;
 		goto restart;
 	}
 	return last_error;
@@ -1229,8 +1247,12 @@ xfs_reclaim_inodes(
 	int		mode)
 {
 	int		nr_to_scan = INT_MAX;
+	long		ret;
 
-	return xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+	ret = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+	if (ret == SHRINK_STOP)
+		return 0;
+	return ret;
 }
 
 /*
@@ -1241,17 +1263,28 @@ xfs_reclaim_inodes(
  * reclaim of inodes. That means if we come across dirty inodes, we wait for
  * them to be cleaned, which we hope will not be very long due to the
  * background walker having already kicked the IO off on those dirty inodes.
+ *
+ * Also, treat kswapd specially - we really want it to run asynchronously and
+ * not block on dirty inodes, unlike direct reclaim that we can tolerate
+ * blocking and some amount of IO latency. If we start to overload the reclaim
+ * subsystem with too many direct reclaimers, it will start returning
+ * SHRINK_STOP to tell the mm subsystem to defer the work rather than continuing
+ * to call us and forcing us to block.
  */
 long
 xfs_reclaim_inodes_nr(
 	struct xfs_mount	*mp,
 	int			nr_to_scan)
 {
+	int			flags = SYNC_TRYLOCK;
+
 	/* kick background reclaimer and push the AIL */
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT, &nr_to_scan);
+	if (!current_is_kswapd())
+		flags |= SYNC_WAIT;
+	return xfs_reclaim_inodes_ag(mp, flags, &nr_to_scan);
 }
 
 /*
