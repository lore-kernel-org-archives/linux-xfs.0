Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB6FC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 10:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D47E660F70
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 10:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhHBKgN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 06:36:13 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:47297 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231357AbhHBKgM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 06:36:12 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id D8010106208;
        Mon,  2 Aug 2021 20:36:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mAVId-00Dco5-6u; Mon, 02 Aug 2021 20:35:59 +1000
Date:   Mon, 2 Aug 2021 20:35:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCHSET v8 00/20] xfs: deferred inode inactivation
Message-ID: <20210802103559.GH2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=1PG21wl3XUyo1Hio1KAA:9 a=nsQFpZwz05IZj-EU:21 a=I8aYqFBGDDZmAs91:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 29, 2021 at 11:43:53AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This patch series implements deferred inode inactivation.  Inactivation
> is what happens when an open file loses its last incore reference: if
> the file has speculative preallocations, they must be freed, and if the
> file is unlinked, all forks must be truncated, and the inode marked
> freed in the inode chunk and the inode btrees.
> 
> Currently, all of this activity is performed in frontend threads when
> the last in-memory reference is lost and/or the vfs decides to drop the
> inode.  Three complaints stem from this behavior: first, that the time
> to unlink (in the worst case) depends on both the complexity of the
> directory as well as the the number of extents in that file; second,
> that deleting a directory tree is inefficient and seeky because we free
> the inodes in readdir order, not disk order; and third, the upcoming
> online repair feature needs to be able to xfs_irele while scanning a
> filesystem in transaction context.  It cannot perform inode inactivation
> in this context because xfs does not support nested transactions.
> 
> The implementation will be familiar to those who have studied how XFS
> scans for reclaimable in-core inodes -- we create a couple more inode
> state flags to mark an inode as needing inactivation and being in the
> middle of inactivation.  When inodes need inactivation, we set
> NEED_INACTIVE in iflags, set the INACTIVE radix tree tag, and schedule a
> deferred work item.  The deferred worker runs in an unbounded workqueue,
> scanning the inode radix tree for tagged inodes to inactivate, and
> performing all the on-disk metadata updates.  Once the inode has been
> inactivated, it is left in the reclaim state and the background reclaim
> worker (or direct reclaim) will get to it eventually.
> 
> Doing the inactivations from kernel threads solves the first problem by
> constraining the amount of work done by the unlink() call to removing
> the directory entry.  It solves the third problem by moving inactivation
> to a separate process.  Because the inactivations are done in order of
> inode number, we solve the second problem by performing updates in (we
> hope) disk order.  This also decreases the amount of time it takes to
> let go of an inode cluster if we're deleting entire directory trees.
> 
> There are three big warts I can think of in this series: first, because
> the actual freeing of nlink==0 inodes is now done in the background,
> this means that the system will be busy making metadata updates for some
> time after the unlink() call returns.  This temporarily reduces
> available iops.  Second, in order to retain the behavior that deleting
> 100TB of unshared data should result in a free space gain of 100TB, the
> statvfs and quota reporting ioctls wait for inactivation to finish,
> which increases the long tail latency of those calls.  This behavior is,
> unfortunately, key to not introducing regressions in fstests.  The third
> problem is that the deferrals keep memory usage higher for longer,
> reduce opportunities to throttle the frontend when metadata load is
> heavy, and the unbounded workqueues can create transaction storms.

Yup, those transaction storms are a problem (where all the CIL
contention is coming from, I think), but there's a bigger
issue....

The problem I see is that way the background work has been
structured is that we lose all the implicit CPU affinity we end up
with by having all the objects in a directory be in the same AG.
This means that when we do work across different directories in
different processes, the filesystem objects they operate on are
largely CPU, node and AG affine. The only contention point is
typically the transaction commit (i.e. the CIL).

However, the use of the mark-and-sweep AG work technique for
inactivation breaks this implicit CPU affinity for the inactivation
work that is usually done in process context when it drops the last
reference to the file. We now just mark the inode for inactivation,
and move on to the next thing. Some time later, an unbound workqueue
thread walks across all the AG and processes all those
inactivations. It's not affine to the process that placed the inode
in the queue, so the inactivation takes place on a mostly cold data
cache.  Hence we end up loading the data set into CPU caches a
second time to do the inactivation, rather than running on a hot
local cache.

The other problem here is that with the really deep queues (65536
inodes before throttling) we grow the unlinked lists a lot and so
there is more overhead managing them. i.e. We end up with more cold
cache misses and buffer lookups...

SO, really, now that I dig into the workings of the perag based
deferred mechanism and tried to help it regain all the lost
performance, I'm not sure that mark-and-sweep works for this
infrastructure.

To put my money where my mouth is, I just wrote a small patch on top
this series that rips out the mark-and-sweep stuff and replaces it
with a small, simple, lockless per-cpu inactivation queue. I set it
up to trigger the work to be run at 32 queued inodes, and converted
the workqueue to be bound to the CPU and have no concurrency on the
CPU. IOWs, we get a per-cpu worker thread to process the per-cpu
inactivation queue. I gutted all the throttling, all the enospc
and quota stuff, and neutered recycling of inodes that need
inactivation. Yeah, I ripped the guts out of it. But with that, the
unlink performance is largely back to the pre-inactivation rate.

I see AGI buffer lockstepping where I'd expect to see it, and
there's no additional contention on other locks because it mostly
keeps the cpu affinity of the data set being inactivated intact.
Being bound to the same CPU and only running for a short period of
time means that it pre-empts the process that released the inodes
and doesn't trigger it to be scheduled away onto a different CPU.
Hence the workload still largely runs on hot(-ish) caches and so
runs at nearly the same efficiency/IPC as the pre-inactivation code.

Hacky patch below, let me know what you think.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

xfs: hacks on deferred inodes.

From: Dave Chinner <dchinner@redhat.com>

A couple of minor bug fixes.

Real change in this is per-cpu deferred inode gc queues. It's a fast
hack to demonstrate the principle, and I'm worried I've screwed
something major up because it largely has worked first go and
behaved as I expected it to work

The unlink workload is now demonstrating clear AGI
lockstepping, with a very large proportion of the inode freeing
operations hitting the AGI lock like so:

-   61.61%     0.00%  [kernel]            [k] xfs_inodegc_worker
   - xfs_inodegc_worker
      - 61.56% xfs_inodegc_inactivate
         - 61.54% xfs_inactive
            - 61.50% xfs_inactive_ifree.isra.0
               - 60.04% xfs_ifree
                  - 57.49% xfs_iunlink_remove
                     - 57.17% xfs_read_agi
                        - 57.15% xfs_trans_read_buf_map
                           - xfs_buf_read_map
                              - 57.14% xfs_buf_get_map
                                 - xfs_buf_find
                                    - 57.09% xfs_buf_lock

The context switch rate is running between 120-150k/s and unlinks
are saw-toothing between 0 and 300k/s. There is no noise in the
behaviour, the CPU usage is saw-toothing in exactly the same pattern
as the unlink rate, etc.

I've stripped out all the enospc, quota, and memory pressure trims -
it's just a small, lockless per-cpu deferred work queue that caps
runs with a depth of ~32 inodes. The queues use llist to provide a
lockless list for the multiple producer, single consumer pattern. I
probably need to change the work queues to be bound so that they run
on the same CPU as the object was queued, and that might actually
reduce the lockstepping problems somewhat.

Ok, I forgot to bind the workqueue again. Ok, now I've done that and
limited it to one work per cpu (because there's one queue per CPU)
and all the lockstepping largely disappears....

Old code on 32-way unlink took 3m40s. This version comes in at 3m2s
for the last process to complete, with the majority of rm's
completing in 2m45si (28 of 32 processes under 2m50s). The unlink
rate is up where I'd expect it to be for most of the test
(~350,000/sec), just the 40-50s it tails off as the context switch
rate sky-rockets to 250-300k/s....

Overall, very promising performance and so far is much simpler. It
may need a backlog throttle, but I won't know that until I've run it
on other workloads...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c |  12 +-
 fs/xfs/libxfs/xfs_ag.h |   4 -
 fs/xfs/xfs_icache.c    | 469 ++++++++++++++-----------------------------------
 fs/xfs/xfs_inode.h     |   1 +
 fs/xfs/xfs_mount.h     |  13 ++
 fs/xfs/xfs_super.c     |  42 ++++-
 6 files changed, 189 insertions(+), 352 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index f000644e5da3..125a4b1f5be5 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -173,7 +173,6 @@ __xfs_free_perag(
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
 	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
-	ASSERT(!delayed_work_pending(&pag->pag_inodegc_work));
 	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
@@ -196,9 +195,7 @@ xfs_free_perag(
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
 		ASSERT(pag->pag_ici_needs_inactive == 0);
 
-		unregister_shrinker(&pag->pag_inodegc_shrink);
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
-		cancel_delayed_work_sync(&pag->pag_inodegc_work);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 
@@ -257,19 +254,14 @@ xfs_initialize_perag(
 		spin_lock_init(&pag->pagb_lock);
 		spin_lock_init(&pag->pag_state_lock);
 		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
-		INIT_DELAYED_WORK(&pag->pag_inodegc_work, xfs_inodegc_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		init_waitqueue_head(&pag->pagb_wait);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 
-		error = xfs_inodegc_register_shrinker(pag);
-		if (error)
-			goto out_remove_pag;
-
 		error = xfs_buf_hash_init(pag);
 		if (error)
-			goto out_inodegc_shrink;
+			goto out_remove_pag;
 
 		error = xfs_iunlink_init(pag);
 		if (error)
@@ -290,8 +282,6 @@ xfs_initialize_perag(
 
 out_hash_destroy:
 	xfs_buf_hash_destroy(pag);
-out_inodegc_shrink:
-	unregister_shrinker(&pag->pag_inodegc_shrink);
 out_remove_pag:
 	radix_tree_delete(&mp->m_perag_tree, index);
 out_free_pag:
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 28db7fc4ebc0..b49a8757cca2 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -103,10 +103,6 @@ struct xfs_perag {
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 
-	/* background inode inactivation */
-	struct delayed_work	pag_inodegc_work;
-	struct shrinker		pag_inodegc_shrink;
-
 	/*
 	 * Unlinked inode information.  This incore information reflects
 	 * data stored in the AGI, so callers must hold the AGI buffer lock
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b21d1d37bcb0..17d0289414f5 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -32,14 +32,6 @@
 #define XFS_ICI_RECLAIM_TAG	0
 /* Inode has speculative preallocations (posteof or cow) to clean. */
 #define XFS_ICI_BLOCKGC_TAG	1
-/* Inode can be inactivated. */
-#define XFS_ICI_INODEGC_TAG	2
-
-/*
- * Upper bound on the number of inodes in each AG that can be queued for
- * inactivation at any given time, to avoid monopolizing the workqueue.
- */
-#define XFS_INODEGC_MAX_BACKLOG	(1024 * XFS_INODES_PER_CHUNK)
 
 /*
  * The goal for walking incore inodes.  These can correspond with incore inode
@@ -49,7 +41,6 @@ enum xfs_icwalk_goal {
 	/* Goals directly associated with tagged inodes. */
 	XFS_ICWALK_BLOCKGC	= XFS_ICI_BLOCKGC_TAG,
 	XFS_ICWALK_RECLAIM	= XFS_ICI_RECLAIM_TAG,
-	XFS_ICWALK_INODEGC	= XFS_ICI_INODEGC_TAG,
 };
 
 #define XFS_ICWALK_NULL_TAG	(-1U)
@@ -410,22 +401,6 @@ xfs_gc_delay_ms(
 	unsigned int		udelay, gdelay, pdelay, fdelay, rdelay, adelay;
 
 	switch (tag) {
-	case XFS_ICI_INODEGC_TAG:
-		default_ms = xfs_inodegc_ms;
-
-		/* If we're in a shrinker, kick off the worker immediately. */
-		if (current->reclaim_state != NULL) {
-			trace_xfs_inodegc_delay_mempressure(mp,
-					__return_address);
-			return 0;
-		}
-
-		/* Kick the worker immediately if we've hit the max backlog. */
-		if (pag->pag_ici_needs_inactive > XFS_INODEGC_MAX_BACKLOG) {
-			trace_xfs_inodegc_delay_backlog(pag);
-			return 0;
-		}
-		break;
 	case XFS_ICI_BLOCKGC_TAG:
 		default_ms = xfs_blockgc_secs * 1000;
 		break;
@@ -476,33 +451,6 @@ xfs_blockgc_queue(
 	rcu_read_unlock();
 }
 
-/*
- * Queue a background inactivation worker if there are inodes that need to be
- * inactivated and higher level xfs code hasn't disabled the background
- * workers.
- */
-static void
-xfs_inodegc_queue(
-	struct xfs_perag	*pag,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount        *mp = pag->pag_mount;
-
-	if (!test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
-		return;
-
-	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
-		unsigned int	delay;
-
-		delay = xfs_gc_delay_ms(pag, ip, XFS_ICI_INODEGC_TAG);
-		trace_xfs_inodegc_queue(pag, delay);
-		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work,
-				msecs_to_jiffies(delay));
-	}
-	rcu_read_unlock();
-}
-
 /*
  * Reschedule the background inactivation worker immediately if space is
  * getting tight and the worker hasn't started running yet.
@@ -519,11 +467,6 @@ xfs_gc_requeue_now(
 	unsigned int		default_ms;
 
 	switch (tag) {
-	case XFS_ICI_INODEGC_TAG:
-		dwork = &pag->pag_inodegc_work;
-		default_ms = xfs_inodegc_ms;
-		opflag_bit = XFS_OPFLAG_INODEGC_RUNNING_BIT;
-		break;
 	case XFS_ICI_BLOCKGC_TAG:
 		dwork = &pag->pag_blockgc_work;
 		default_ms = xfs_blockgc_secs * 1000;
@@ -568,8 +511,6 @@ xfs_perag_set_inode_tag(
 
 	if (tag == XFS_ICI_RECLAIM_TAG)
 		pag->pag_ici_reclaimable++;
-	else if (tag == XFS_ICI_INODEGC_TAG)
-		pag->pag_ici_needs_inactive++;
 
 	if (was_tagged) {
 		xfs_gc_requeue_now(pag, ip, tag);
@@ -589,9 +530,6 @@ xfs_perag_set_inode_tag(
 	case XFS_ICI_BLOCKGC_TAG:
 		xfs_blockgc_queue(pag, ip);
 		break;
-	case XFS_ICI_INODEGC_TAG:
-		xfs_inodegc_queue(pag, ip);
-		break;
 	}
 
 	trace_xfs_perag_set_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
@@ -619,8 +557,6 @@ xfs_perag_clear_inode_tag(
 
 	if (tag == XFS_ICI_RECLAIM_TAG)
 		pag->pag_ici_reclaimable--;
-	else if (tag == XFS_ICI_INODEGC_TAG)
-		pag->pag_ici_needs_inactive--;
 
 	if (radix_tree_tagged(&pag->pag_ici_root, tag))
 		return;
@@ -633,132 +569,6 @@ xfs_perag_clear_inode_tag(
 	trace_xfs_perag_clear_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
 }
 
-#ifdef DEBUG
-static void
-xfs_check_delalloc(
-	struct xfs_inode	*ip,
-	int			whichfork)
-{
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
-	struct xfs_bmbt_irec	got;
-	struct xfs_iext_cursor	icur;
-
-	if (!ifp || !xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got))
-		return;
-	do {
-		if (isnullstartblock(got.br_startblock)) {
-			xfs_warn(ip->i_mount,
-	"ino %llx %s fork has delalloc extent at [0x%llx:0x%llx]",
-				ip->i_ino,
-				whichfork == XFS_DATA_FORK ? "data" : "cow",
-				got.br_startoff, got.br_blockcount);
-		}
-	} while (xfs_iext_next_extent(ifp, &icur, &got));
-}
-#else
-#define xfs_check_delalloc(ip, whichfork)	do { } while (0)
-#endif
-
-/*
- * Decide if we're going to throttle frontend threads that are inactivating
- * inodes so that we don't overwhelm the background workers with inodes and OOM
- * the machine.
- */
-static inline bool
-xfs_inodegc_want_throttle(
-	struct xfs_perag	*pag)
-{
-	/*
-	 * If we're in memory reclaim context, we don't want to wait for inode
-	 * inactivation to finish because it can take a very long time to
-	 * commit all the metadata updates and push the inodes through memory
-	 * reclamation.  Also, we might be the background inodegc thread.
-	 */
-	if (current->reclaim_state != NULL)
-		return false;
-
-	/* Enforce an upper bound on how many inodes can queue up. */
-	if (pag->pag_ici_needs_inactive > XFS_INODEGC_MAX_BACKLOG) {
-		trace_xfs_inodegc_throttle_backlog(pag);
-		return true;
-	}
-
-	/* Throttle if memory reclaim anywhere has triggered us. */
-	if (atomic_read(&pag->pag_inodegc_reclaim) > 0) {
-		trace_xfs_inodegc_throttle_mempressure(pag);
-		return true;
-	}
-
-	return false;
-}
-
-/*
- * We set the inode flag atomically with the radix tree tag.
- * Once we get tag lookups on the radix tree, this inode flag
- * can go away.
- */
-void
-xfs_inode_mark_reclaimable(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_perag	*pag;
-	unsigned int		tag;
-	bool			need_inactive;
-	bool			flush_inodegc = false;
-
-	need_inactive = xfs_inode_needs_inactive(ip);
-	if (!need_inactive) {
-		/* Going straight to reclaim, so drop the dquots. */
-		xfs_qm_dqdetach(ip);
-
-		if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
-			xfs_check_delalloc(ip, XFS_DATA_FORK);
-			xfs_check_delalloc(ip, XFS_COW_FORK);
-			ASSERT(0);
-		}
-	}
-
-	XFS_STATS_INC(mp, vn_reclaim);
-
-	/*
-	 * We should never get here with any of the reclaim flags already set.
-	 */
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_ALL_IRECLAIM_FLAGS));
-
-	/*
-	 * We always use background reclaim here because even if the inode is
-	 * clean, it still may be under IO and hence we have wait for IO
-	 * completion to occur before we can reclaim the inode. The background
-	 * reclaim path handles this more efficiently than we can here, so
-	 * simply let background reclaim tear down all inodes.
-	 */
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-	spin_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-
-	if (need_inactive) {
-		trace_xfs_inode_set_need_inactive(ip);
-		ip->i_flags |= XFS_NEED_INACTIVE;
-		tag = XFS_ICI_INODEGC_TAG;
-		flush_inodegc = xfs_inodegc_want_throttle(pag);
-	} else {
-		trace_xfs_inode_set_reclaimable(ip);
-		ip->i_flags |= XFS_IRECLAIMABLE;
-		tag = XFS_ICI_RECLAIM_TAG;
-	}
-
-	xfs_perag_set_inode_tag(pag, ip, tag);
-
-	spin_unlock(&ip->i_flags_lock);
-	spin_unlock(&pag->pag_ici_lock);
-
-	if (flush_inodegc && flush_work(&pag->pag_inodegc_work.work))
-		trace_xfs_inodegc_throttled(pag, __return_address);
-
-	xfs_perag_put(pag);
-}
-
 static inline void
 xfs_inew_wait(
 	struct xfs_inode	*ip)
@@ -820,7 +630,7 @@ xfs_iget_recycle(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
-	unsigned int		tag;
+	unsigned int		tag = UINT_MAX;
 	int			error;
 
 	trace_xfs_iget_recycle(ip);
@@ -835,7 +645,6 @@ xfs_iget_recycle(
 		tag = XFS_ICI_RECLAIM_TAG;
 		ip->i_flags |= XFS_IRECLAIM;
 	} else if (ip->i_flags & XFS_NEED_INACTIVE) {
-		tag = XFS_ICI_INODEGC_TAG;
 		ip->i_flags |= XFS_INACTIVATING;
 	} else {
 		ASSERT(0);
@@ -878,7 +687,8 @@ xfs_iget_recycle(
 	 */
 	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
 	ip->i_flags |= XFS_INEW;
-	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino), tag);
+	if (tag != UINT_MAX)
+		xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino), tag);
 	inode->i_state = I_NEW;
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
@@ -965,10 +775,17 @@ xfs_iget_cache_hit(
 	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_INACTIVATING))
 		goto out_skip;
 
-	/* Unlinked inodes cannot be re-grabbed. */
-	if (VFS_I(ip)->i_nlink == 0 && (ip->i_flags & XFS_NEED_INACTIVE)) {
-		error = -ENOENT;
-		goto out_error;
+	if (ip->i_flags & XFS_NEED_INACTIVE) {
+		/* Unlinked inodes cannot be re-grabbed. */
+		if (VFS_I(ip)->i_nlink == 0) {
+			error = -ENOENT;
+			goto out_error;
+		}
+		/*
+		 * XXX: need to trigger a gc list flush before we can allow
+		 * inactivated inodes past here.
+		 */
+		goto out_skip;
 	}
 
 	/*
@@ -1936,7 +1753,8 @@ xfs_blockgc_free_space(
 	if (error)
 		return error;
 
-	return xfs_icwalk(mp, XFS_ICWALK_INODEGC, icw);
+	xfs_inodegc_flush(mp);
+	return 0;
 }
 
 /*
@@ -2024,6 +1842,33 @@ xfs_blockgc_free_quota(
 			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), iwalk_flags);
 }
 
+
+#ifdef DEBUG
+static void
+xfs_check_delalloc(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_bmbt_irec	got;
+	struct xfs_iext_cursor	icur;
+
+	if (!ifp || !xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got))
+		return;
+	do {
+		if (isnullstartblock(got.br_startblock)) {
+			xfs_warn(ip->i_mount,
+	"ino %llx %s fork has delalloc extent at [0x%llx:0x%llx]",
+				ip->i_ino,
+				whichfork == XFS_DATA_FORK ? "data" : "cow",
+				got.br_startoff, got.br_blockcount);
+		}
+	} while (xfs_iext_next_extent(ifp, &icur, &got));
+}
+#else
+#define xfs_check_delalloc(ip, whichfork)	do { } while (0)
+#endif
+
 /*
  * Inode Inactivation and Reclaimation
  * ===================================
@@ -2069,42 +1914,6 @@ xfs_blockgc_free_quota(
  * incore inode tree lock and then the inode i_flags lock, in that order.
  */
 
-/*
- * Decide if the given @ip is eligible for inactivation, and grab it if so.
- * Returns true if it's ready to go or false if we should just ignore it.
- *
- * Skip inodes that don't need inactivation or are being inactivated (or
- * recycled) by another thread.  Inodes should not be tagged for inactivation
- * while also in INEW or any reclaim state.
- *
- * Otherwise, mark this inode as being inactivated even if the fs is shut down
- * because we need xfs_inodegc_inactivate to push this inode into the reclaim
- * state.
- */
-static bool
-xfs_inodegc_igrab(
-	struct xfs_inode	*ip)
-{
-	bool			ret = false;
-
-	ASSERT(rcu_read_lock_held());
-
-	/* Check for stale RCU freed inode */
-	spin_lock(&ip->i_flags_lock);
-	if (!ip->i_ino)
-		goto out_unlock_noent;
-
-	if ((ip->i_flags & XFS_NEED_INACTIVE) &&
-	    !(ip->i_flags & XFS_INACTIVATING)) {
-		ret = true;
-		ip->i_flags |= XFS_INACTIVATING;
-	}
-
-out_unlock_noent:
-	spin_unlock(&ip->i_flags_lock);
-	return ret;
-}
-
 /*
  * Free all speculative preallocations and possibly even the inode itself.
  * This is the last chance to make changes to an otherwise unreferenced file
@@ -2112,12 +1921,10 @@ xfs_inodegc_igrab(
  */
 static void
 xfs_inodegc_inactivate(
-	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
-	struct xfs_icwalk	*icw)
+	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	struct xfs_perag	*pag;
 
 	/*
 	 * Inactivation isn't supposed to run when the fs is frozen because
@@ -2125,20 +1932,6 @@ xfs_inodegc_inactivate(
 	 */
 	ASSERT(mp->m_super->s_writers.frozen < SB_FREEZE_FS);
 
-	/*
-	 * Foreground threads that have hit ENOSPC or EDQUOT are allowed to
-	 * pass in a icw structure to look for inodes to inactivate
-	 * immediately to free some resources.  If this inode isn't a match,
-	 * put it back on the shelf and move on.
-	 */
-	spin_lock(&ip->i_flags_lock);
-	if (!xfs_icwalk_match(ip, icw)) {
-		ip->i_flags &= ~XFS_INACTIVATING;
-		spin_unlock(&ip->i_flags_lock);
-		return;
-	}
-	spin_unlock(&ip->i_flags_lock);
-
 	trace_xfs_inode_inactivating(ip);
 
 	xfs_inactive(ip);
@@ -2150,6 +1943,7 @@ xfs_inodegc_inactivate(
 	}
 
 	/* Schedule the inactivated inode for reclaim. */
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 
@@ -2157,11 +1951,11 @@ xfs_inodegc_inactivate(
 	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
 	ip->i_flags |= XFS_IRECLAIMABLE;
 
-	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_INODEGC_TAG);
 	xfs_perag_set_inode_tag(pag, ip, XFS_ICI_RECLAIM_TAG);
 
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
+	xfs_perag_put(pag);
 }
 
 /* Inactivate inodes until we run out. */
@@ -2169,23 +1963,16 @@ void
 xfs_inodegc_worker(
 	struct work_struct	*work)
 {
-	struct xfs_perag	*pag = container_of(to_delayed_work(work),
-					struct xfs_perag, pag_inodegc_work);
+	struct xfs_inodegc	*gc = container_of(work, struct xfs_inodegc,
+							work);
+	struct llist_node	*node = llist_del_all(&gc->list);
+	struct xfs_inode	*ip, *n;
 
-	/*
-	 * Inactivation never returns error codes and never fails to push a
-	 * tagged inode to reclaim.  Loop until there there's nothing left.
-	 */
-	while (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_INODEGC_TAG)) {
-		trace_xfs_inodegc_worker(pag, __return_address);
-		xfs_icwalk_ag(pag, XFS_ICWALK_INODEGC, NULL);
+	gc->items = 0;
+	llist_for_each_entry_safe(ip, n, node, i_gclist) {
+		xfs_iflags_set(ip, XFS_INACTIVATING);
+		xfs_inodegc_inactivate(ip);
 	}
-
-	/*
-	 * We inactivated all the inodes we could, so disable the throttling
-	 * of new inactivations that happens when memory gets tight.
-	 */
-	atomic_set(&pag->pag_inodegc_reclaim, 0);
 }
 
 /*
@@ -2196,13 +1983,15 @@ void
 xfs_inodegc_flush(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_inodegc	*gc;
+	int			cpu;
 
 	trace_xfs_inodegc_flush(mp, __return_address);
 
-	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG)
-		flush_delayed_work(&pag->pag_inodegc_work);
+	for_each_online_cpu(cpu) {
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		flush_work(&gc->work);
+	}
 }
 
 /* Disable the inode inactivation background worker and wait for it to stop. */
@@ -2210,14 +1999,16 @@ void
 xfs_inodegc_stop(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_inodegc	*gc;
+	int			cpu;
 
 	if (!test_and_clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
 		return;
 
-	for_each_perag(mp, agno, pag)
-		cancel_delayed_work_sync(&pag->pag_inodegc_work);
+	for_each_online_cpu(cpu) {
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		cancel_work_sync(&gc->work);
+	}
 	trace_xfs_inodegc_stop(mp, __return_address);
 }
 
@@ -2229,85 +2020,100 @@ void
 xfs_inodegc_start(
 	struct xfs_mount	*mp)
 {
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		agno;
+	struct xfs_inodegc	*gc;
+	int			cpu;
 
 	if (test_and_set_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
 		return;
 
 	trace_xfs_inodegc_start(mp, __return_address);
-	for_each_perag_tag(mp, agno, pag, XFS_ICI_INODEGC_TAG)
-		xfs_inodegc_queue(pag, NULL);
+	for_each_online_cpu(cpu) {
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		if (!llist_empty(&gc->list))
+			queue_work(mp->m_gc_workqueue, &gc->work);
+	}
 }
 
-/*
- * Register a phony shrinker so that we can speed up background inodegc and
- * throttle new inodegc queuing when there's memory pressure.  Inactivation
- * does not itself free any memory but it does make inodes reclaimable, which
- * eventually frees memory.  The count function, seek value, and batch value
- * are crafted to trigger the scan function any time the shrinker is not being
- * called from a background idle scan (i.e. the second time).
- */
-#define XFS_INODEGC_SHRINK_COUNT	(1UL << DEF_PRIORITY)
-#define XFS_INODEGC_SHRINK_BATCH	(LONG_MAX)
 
-static unsigned long
-xfs_inodegc_shrink_count(
-	struct shrinker		*shrink,
-	struct shrink_control	*sc)
+static void
+xfs_inodegc_queue(
+	struct xfs_inode	*ip)
 {
-	struct xfs_perag	*pag;
-
-	pag = container_of(shrink, struct xfs_perag, pag_inodegc_shrink);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_inodegc	*gc;
 
-	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_INODEGC_TAG))
-		return XFS_INODEGC_SHRINK_COUNT;
+	spin_lock(&ip->i_flags_lock);
+	ip->i_flags |= XFS_NEED_INACTIVE;
+	if (!test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags)) {
+		ip->i_flags |= XFS_INACTIVATING;
+		spin_unlock(&ip->i_flags_lock);
+		xfs_inodegc_inactivate(ip);
+		return;
+	}
+	spin_unlock(&ip->i_flags_lock);
 
-	return 0;
+	gc = get_cpu_ptr(mp->m_inodegc);
+	llist_add(&ip->i_gclist, &gc->list);
+	if (++gc->items > 32)
+		queue_work(mp->m_gc_workqueue, &gc->work);
+	put_cpu_ptr(gc);
 }
 
-static unsigned long
-xfs_inodegc_shrink_scan(
-	struct shrinker		*shrink,
-	struct shrink_control	*sc)
+/*
+ * We set the inode flag atomically with the radix tree tag.
+ * Once we get tag lookups on the radix tree, this inode flag
+ * can go away.
+ */
+void
+xfs_inode_mark_reclaimable(
+	struct xfs_inode	*ip)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	bool			need_inactive;
+
+	XFS_STATS_INC(mp, vn_reclaim);
 
 	/*
-	 * Inode inactivation work requires NOFS allocations, so don't make
-	 * things worse if the caller wanted a NOFS allocation.
+	 * We should never get here with any of the reclaim flags already set.
 	 */
-	if (!(sc->gfp_mask & __GFP_FS))
-		return SHRINK_STOP;
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_ALL_IRECLAIM_FLAGS));
 
-	pag = container_of(shrink, struct xfs_perag, pag_inodegc_shrink);
+	need_inactive = xfs_inode_needs_inactive(ip);
+	if (need_inactive) {
+		xfs_inodegc_queue(ip);
+		return;
+	}
 
-	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_INODEGC_TAG)) {
-		struct xfs_mount *mp = pag->pag_mount;
+	/* Going straight to reclaim, so drop the dquots. */
+	xfs_qm_dqdetach(ip);
 
-		trace_xfs_inodegc_requeue_mempressure(pag, sc->nr_to_scan,
-				__return_address);
-		atomic_inc(&pag->pag_inodegc_reclaim);
-		mod_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work, 0);
+	if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
+		xfs_check_delalloc(ip, XFS_DATA_FORK);
+		xfs_check_delalloc(ip, XFS_COW_FORK);
+		ASSERT(0);
 	}
 
-	return 0;
-}
 
-/* Register a shrinker so we can accelerate inodegc and throttle queuing. */
-int
-xfs_inodegc_register_shrinker(
-	struct xfs_perag	*pag)
-{
-	struct shrinker		*shrink = &pag->pag_inodegc_shrink;
+	/*
+	 * We always use background reclaim here because even if the inode is
+	 * clean, it still may be under IO and hence we have wait for IO
+	 * completion to occur before we can reclaim the inode. The background
+	 * reclaim path handles this more efficiently than we can here, so
+	 * simply let background reclaim tear down all inodes.
+	 */
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
 
-	shrink->count_objects = xfs_inodegc_shrink_count;
-	shrink->scan_objects = xfs_inodegc_shrink_scan;
-	shrink->seeks = 0;
-	shrink->flags = SHRINKER_NONSLAB;
-	shrink->batch = XFS_INODEGC_SHRINK_BATCH;
+	trace_xfs_inode_set_reclaimable(ip);
+	ip->i_flags |= XFS_IRECLAIMABLE;
+	xfs_perag_set_inode_tag(pag, ip, XFS_ICI_RECLAIM_TAG);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
 
-	return register_shrinker(shrink);
+	xfs_perag_put(pag);
 }
 
 /* XFS Inode Cache Walking Code */
@@ -2336,8 +2142,6 @@ xfs_icwalk_igrab(
 		return xfs_blockgc_igrab(ip);
 	case XFS_ICWALK_RECLAIM:
 		return xfs_reclaim_igrab(ip, icw);
-	case XFS_ICWALK_INODEGC:
-		return xfs_inodegc_igrab(ip);
 	default:
 		return false;
 	}
@@ -2363,9 +2167,6 @@ xfs_icwalk_process_inode(
 	case XFS_ICWALK_RECLAIM:
 		xfs_reclaim_inode(ip, pag);
 		break;
-	case XFS_ICWALK_INODEGC:
-		xfs_inodegc_inactivate(ip, pag, icw);
-		break;
 	}
 	return error;
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa5be0d071ad..4ef0667689f3 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -27,6 +27,7 @@ typedef struct xfs_inode {
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
 	struct xfs_dquot	*i_pdquot;	/* project dquot */
+	struct llist_node	i_gclist;
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 83bd288d55b8..99d447aac153 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -56,6 +56,12 @@ struct xfs_error_cfg {
 	long		retry_timeout;	/* in jiffies, -1 = infinite */
 };
 
+struct xfs_inodegc {
+	struct llist_head	list;
+	struct work_struct	work;
+	int			items;
+};
+
 /*
  * The struct xfsmount layout is optimised to separate read-mostly variables
  * from variables that are frequently modified. We put the read-mostly variables
@@ -219,6 +225,13 @@ typedef struct xfs_mount {
 	uint32_t		m_generation;
 	struct mutex		m_growlock;	/* growfs mutex */
 
+	void __percpu		*m_inodegc;	/* percpu inodegc structures */
+
+	struct inodegc {
+		struct llist_head	list;
+		struct delayed_work	work;
+	}			inodegc_list;
+
 #ifdef DEBUG
 	/*
 	 * Frequency with which errors are injected.  Replaces xfs_etest; the
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 920ab6c3c983..0aa2af155072 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -503,8 +503,8 @@ xfs_init_mount_workqueues(
 		goto out_destroy_unwritten;
 
 	mp->m_gc_workqueue = alloc_workqueue("xfs-gc/%s",
-			WQ_SYSFS | WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM,
-			0, mp->m_super->s_id);
+			WQ_SYSFS | WQ_FREEZABLE | WQ_MEM_RECLAIM,
+			1, mp->m_super->s_id);
 	if (!mp->m_gc_workqueue)
 		goto out_destroy_reclaim;
 
@@ -1009,6 +1009,35 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
 
+static int
+xfs_inodegc_init_percpu(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inodegc	*gc;
+	int			cpu;
+
+	mp->m_inodegc = alloc_percpu(struct xfs_inodegc);
+	if (!mp->m_inodegc)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		init_llist_head(&gc->list);
+		gc->items = 0;
+                INIT_WORK(&gc->work, xfs_inodegc_worker);
+	}
+	return 0;
+}
+
+static void
+xfs_inodegc_free_percpu(
+	struct xfs_mount	*mp)
+{
+	if (!mp->m_inodegc)
+		return;
+	free_percpu(mp->m_inodegc);
+}
+
 static void
 xfs_fs_put_super(
 	struct super_block	*sb)
@@ -1025,6 +1054,7 @@ xfs_fs_put_super(
 
 	xfs_freesb(mp);
 	free_percpu(mp->m_stats.xs_stats);
+	xfs_inodegc_free_percpu(mp);
 	xfs_destroy_percpu_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
@@ -1396,11 +1426,15 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_destroy_workqueues;
 
+	error = xfs_inodegc_init_percpu(mp);
+	if (error)
+		goto out_destroy_counters;
+
 	/* Allocate stats memory before we do operations that might use it */
 	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
 	if (!mp->m_stats.xs_stats) {
 		error = -ENOMEM;
-		goto out_destroy_counters;
+		goto out_destroy_inodegc;
 	}
 
 	error = xfs_readsb(mp, flags);
@@ -1605,6 +1639,8 @@ xfs_fs_fill_super(
 	free_percpu(mp->m_stats.xs_stats);
  out_destroy_counters:
 	xfs_destroy_percpu_counters(mp);
+ out_destroy_inodegc:
+	xfs_inodegc_free_percpu(mp);
  out_destroy_workqueues:
 	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
