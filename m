Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RGkolv128466 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 11:46:50 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	gaH8vVNxwymjqmbg (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 09:46:47 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCZXj-0007Dn-12
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 16:46:47 +0000
Message-Id: <20120327164646.975031281@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 12:44:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/10] xfs: on-stack delayed write buffer lists
References: <20120327164400.967415009@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfsbufd
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Queue delwri buffers on a local on-stack list instead of a per-buftarg one,
and write back the buffers per-process instead of by waking up xfsbufd.

This is now easily doable given that we have very few places left that write
delwri buffers:

 - log recovery:
	Only done at mount time, and already forcing out the buffers
	synchronously using xfs_flush_buftarg

 - quotacheck:
	Same story.

 - dquot reclaim:
	Writes out dirty dquots on the LRU under memory pressure.  We might
	want to look into doing more of this via xfsaild, but it's already
	more optimal than the synchronous inode reclaim that writes each
	buffer synchronously.

 - xfsaild:
	This is the main beneficiary of the change.  By keeping a local list
	of buffers to write we reduce latency of writing out buffers, and
	more importably we can remove all the delwri list promotions which
	were hitting the buffer cache hard under sustained metadata loads.

The implementation is very straight forward - xfs_buf_delwri_queue now gets
a new list_head pointer that it adds the delwri buffers to, and all callers
need to eventually submit the list using xfs_buf_delwi_submit or
xfs_buf_delwi_submit_nowait.  Buffers that already are on a delwri list are
skipped in xfs_buf_delwri_queue, assuming they already are on another delwri
list.  The biggest change to pass down the buffer list was done to the AIL
pushing. Now that we operate on buffers the trylock, push and pushbuf log
item methods are merged into a single push routine, which tries to lock the
item, and if possible add the buffer that needs writeback to the buffer list.
This leads to much simpler code than the previous split but requires the
individual IOP_PUSH instances to unlock and reacquire the AIL around calls
to blocking routines.

Given that xfsailds now also handles writing out buffers the conditions for
log forcing and the sleep times needed some small changes.  The most
important one is that we consider an AIL busy as long we still have buffers
to push, and the other one is that we do increment the pushed LSN for
buffers that are under flushing at this moment, but still count them towards
the stuck items for restart purposes.  Without this we could hammer on stuck
items without ever forcing the log and not make progress under heavy random
delete workloads on fast flash storage devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_buf.c          |  336 ++++++++++++++++------------------------------
 fs/xfs/xfs_buf.h          |   28 ---
 fs/xfs/xfs_buf_item.c     |   96 +++----------
 fs/xfs/xfs_dquot.c        |   33 ----
 fs/xfs/xfs_dquot.h        |    1 
 fs/xfs/xfs_dquot_item.c   |  161 ++++------------------
 fs/xfs/xfs_extfree_item.c |   53 +------
 fs/xfs/xfs_inode.c        |   25 ---
 fs/xfs/xfs_inode.h        |    1 
 fs/xfs/xfs_inode_item.c   |  152 ++++----------------
 fs/xfs/xfs_log_recover.c  |   46 +++---
 fs/xfs/xfs_qm.c           |  150 +++++++++-----------
 fs/xfs/xfs_super.c        |   16 --
 fs/xfs/xfs_sync.c         |   18 --
 fs/xfs/xfs_trace.h        |    7 
 fs/xfs/xfs_trans.h        |   18 --
 fs/xfs/xfs_trans_ail.c    |  133 +++++++-----------
 fs/xfs/xfs_trans_buf.c    |   86 +++--------
 fs/xfs/xfs_trans_priv.h   |    1 
 19 files changed, 437 insertions(+), 924 deletions(-)

Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2012-03-25 16:41:00.134550721 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2012-03-25 16:46:11.977889836 +0200
@@ -2103,6 +2103,7 @@ xlog_recover_do_dquot_buffer(
 STATIC int
 xlog_recover_buffer_pass2(
 	xlog_t			*log,
+	struct list_head	*buffer_list,
 	xlog_recover_item_t	*item)
 {
 	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
@@ -2173,7 +2174,7 @@ xlog_recover_buffer_pass2(
 	} else {
 		ASSERT(bp->b_target->bt_mount == mp);
 		bp->b_iodone = xlog_recover_iodone;
-		xfs_buf_delwri_queue(bp);
+		xfs_buf_delwri_queue(bp, buffer_list);
 	}
 
 	xfs_buf_relse(bp);
@@ -2183,6 +2184,7 @@ xlog_recover_buffer_pass2(
 STATIC int
 xlog_recover_inode_pass2(
 	xlog_t			*log,
+	struct list_head	*buffer_list,
 	xlog_recover_item_t	*item)
 {
 	xfs_inode_log_format_t	*in_f;
@@ -2436,7 +2438,7 @@ xlog_recover_inode_pass2(
 write_inode_buffer:
 	ASSERT(bp->b_target->bt_mount == mp);
 	bp->b_iodone = xlog_recover_iodone;
-	xfs_buf_delwri_queue(bp);
+	xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
 error:
 	if (need_free)
@@ -2477,6 +2479,7 @@ xlog_recover_quotaoff_pass1(
 STATIC int
 xlog_recover_dquot_pass2(
 	xlog_t			*log,
+	struct list_head	*buffer_list,
 	xlog_recover_item_t	*item)
 {
 	xfs_mount_t		*mp = log->l_mp;
@@ -2558,7 +2561,7 @@ xlog_recover_dquot_pass2(
 	ASSERT(dq_f->qlf_size == 2);
 	ASSERT(bp->b_target->bt_mount == mp);
 	bp->b_iodone = xlog_recover_iodone;
-	xfs_buf_delwri_queue(bp);
+	xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
 
 	return (0);
@@ -2712,21 +2715,22 @@ STATIC int
 xlog_recover_commit_pass2(
 	struct log		*log,
 	struct xlog_recover	*trans,
+	struct list_head	*buffer_list,
 	xlog_recover_item_t	*item)
 {
 	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
 
 	switch (ITEM_TYPE(item)) {
 	case XFS_LI_BUF:
-		return xlog_recover_buffer_pass2(log, item);
+		return xlog_recover_buffer_pass2(log, buffer_list, item);
 	case XFS_LI_INODE:
-		return xlog_recover_inode_pass2(log, item);
+		return xlog_recover_inode_pass2(log, buffer_list, item);
 	case XFS_LI_EFI:
 		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
 	case XFS_LI_EFD:
 		return xlog_recover_efd_pass2(log, item);
 	case XFS_LI_DQUOT:
-		return xlog_recover_dquot_pass2(log, item);
+		return xlog_recover_dquot_pass2(log, buffer_list, item);
 	case XFS_LI_QUOTAOFF:
 		/* nothing to do in pass2 */
 		return 0;
@@ -2750,8 +2754,9 @@ xlog_recover_commit_trans(
 	struct xlog_recover	*trans,
 	int			pass)
 {
-	int			error = 0;
+	int			error = 0, error2;
 	xlog_recover_item_t	*item;
+	LIST_HEAD		(buffer_list);
 
 	hlist_del(&trans->r_list);
 
@@ -2760,16 +2765,27 @@ xlog_recover_commit_trans(
 		return error;
 
 	list_for_each_entry(item, &trans->r_itemq, ri_list) {
-		if (pass == XLOG_RECOVER_PASS1)
+		switch (pass) {
+		case XLOG_RECOVER_PASS1:
 			error = xlog_recover_commit_pass1(log, trans, item);
-		else
-			error = xlog_recover_commit_pass2(log, trans, item);
+			break;
+		case XLOG_RECOVER_PASS2:
+			error = xlog_recover_commit_pass2(log, trans,
+							  &buffer_list, item);
+			break;
+		default:
+			ASSERT(0);
+		}
+
 		if (error)
-			return error;
+			goto out;
 	}
 
 	xlog_recover_free_trans(trans);
-	return 0;
+
+out:
+	error2 = xfs_buf_delwri_submit(&buffer_list);
+	return error ? error : error2;
 }
 
 STATIC int
@@ -3650,11 +3666,8 @@ xlog_do_recover(
 	 * First replay the images in the log.
 	 */
 	error = xlog_do_log_recovery(log, head_blk, tail_blk);
-	if (error) {
+	if (error)
 		return error;
-	}
-
-	xfs_flush_buftarg(log->l_mp->m_ddev_targp, 1);
 
 	/*
 	 * If IO errors happened during recovery, bail out.
@@ -3681,7 +3694,6 @@ xlog_do_recover(
 	bp = xfs_getsb(log->l_mp, 0);
 	XFS_BUF_UNDONE(bp);
 	ASSERT(!(XFS_BUF_ISWRITE(bp)));
-	ASSERT(!(XFS_BUF_ISDELAYWRITE(bp)));
 	XFS_BUF_READ(bp);
 	XFS_BUF_UNASYNC(bp);
 	xfsbdstrat(log->l_mp, bp);
Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2012-03-25 16:41:00.144550722 +0200
+++ xfs/fs/xfs/xfs_buf.c	2012-03-25 17:11:17.154584413 +0200
@@ -42,7 +42,6 @@
 #include "xfs_trace.h"
 
 static kmem_zone_t *xfs_buf_zone;
-STATIC int xfsbufd(void *);
 
 static struct workqueue_struct *xfslogd_workqueue;
 
@@ -144,8 +143,11 @@ void
 xfs_buf_stale(
 	struct xfs_buf	*bp)
 {
+	ASSERT(xfs_buf_islocked(bp));
+
 	bp->b_flags |= XBF_STALE;
-	xfs_buf_delwri_dequeue(bp);
+	bp->b_flags &= ~_XBF_DELWRI_Q;
+
 	atomic_set(&(bp)->b_lru_ref, 0);
 	if (!list_empty(&bp->b_lru)) {
 		struct xfs_buftarg *btp = bp->b_target;
@@ -592,10 +594,10 @@ _xfs_buf_read(
 {
 	int			status;
 
-	ASSERT(!(flags & (XBF_DELWRI|XBF_WRITE)));
+	ASSERT(!(flags & XBF_WRITE));
 	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
 
-	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_DELWRI | XBF_READ_AHEAD);
+	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
 
 	status = xfs_buf_iorequest(bp);
@@ -855,7 +857,7 @@ xfs_buf_rele(
 			spin_unlock(&pag->pag_buf_lock);
 		} else {
 			xfs_buf_lru_del(bp);
-			ASSERT(!(bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)));
+			ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 			rb_erase(&bp->b_rbnode, &pag->pag_buf_tree);
 			spin_unlock(&pag->pag_buf_lock);
 			xfs_perag_put(pag);
@@ -915,13 +917,6 @@ xfs_buf_lock(
 	trace_xfs_buf_lock_done(bp, _RET_IP_);
 }
 
-/*
- *	Releases the lock on the buffer object.
- *	If the buffer is marked delwri but is not queued, do so before we
- *	unlock the buffer as we need to set flags correctly.  We also need to
- *	take a reference for the delwri queue because the unlocker is going to
- *	drop their's and they don't know we just queued it.
- */
 void
 xfs_buf_unlock(
 	struct xfs_buf		*bp)
@@ -1019,10 +1014,11 @@ xfs_bwrite(
 {
 	int			error;
 
+	ASSERT(xfs_buf_islocked(bp));
+
 	bp->b_flags |= XBF_WRITE;
-	bp->b_flags &= ~(XBF_ASYNC | XBF_READ);
+	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q);
 
-	xfs_buf_delwri_dequeue(bp);
 	xfs_bdstrat_cb(bp);
 
 	error = xfs_buf_iowait(bp);
@@ -1254,7 +1250,7 @@ xfs_buf_iorequest(
 {
 	trace_xfs_buf_iorequest(bp, _RET_IP_);
 
-	ASSERT(!(bp->b_flags & XBF_DELWRI));
+	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 
 	if (bp->b_flags & XBF_WRITE)
 		xfs_buf_wait_unpin(bp);
@@ -1435,11 +1431,9 @@ xfs_free_buftarg(
 {
 	unregister_shrinker(&btp->bt_shrinker);
 
-	xfs_flush_buftarg(btp, 1);
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_blkdev_issue_flush(btp);
 
-	kthread_stop(btp->bt_task);
 	kmem_free(btp);
 }
 
@@ -1491,20 +1485,6 @@ xfs_setsize_buftarg(
 	return xfs_setsize_buftarg_flags(btp, blocksize, sectorsize, 1);
 }
 
-STATIC int
-xfs_alloc_delwri_queue(
-	xfs_buftarg_t		*btp,
-	const char		*fsname)
-{
-	INIT_LIST_HEAD(&btp->bt_delwri_queue);
-	spin_lock_init(&btp->bt_delwri_lock);
-	btp->bt_flags = 0;
-	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd/%s", fsname);
-	if (IS_ERR(btp->bt_task))
-		return PTR_ERR(btp->bt_task);
-	return 0;
-}
-
 xfs_buftarg_t *
 xfs_alloc_buftarg(
 	struct xfs_mount	*mp,
@@ -1527,8 +1507,6 @@ xfs_alloc_buftarg(
 	spin_lock_init(&btp->bt_lru_lock);
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error;
-	if (xfs_alloc_delwri_queue(btp, fsname))
-		goto error;
 	btp->bt_shrinker.shrink = xfs_buftarg_shrink;
 	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
 	register_shrinker(&btp->bt_shrinker);
@@ -1539,125 +1517,52 @@ error:
 	return NULL;
 }
 
-
 /*
- *	Delayed write buffer handling
+ * Add a buffer to the delayed write list.
+ *
+ * This queues a buffer for writeout if it hasn't already been.  Note that
+ * neither this routine nor the buffer list submission functions perform
+ * any internal synchronization.  It is expected that the lists are thread-local
+ * to the callers.
+ *
+ * Returns true if we queued up the buffer, or false if it already had
+ * been on the buffer list.
  */
-void
+bool
 xfs_buf_delwri_queue(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp,
+	struct list_head	*list)
 {
-	struct xfs_buftarg	*btp = bp->b_target;
-
-	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
-
+	ASSERT(xfs_buf_islocked(bp));
 	ASSERT(!(bp->b_flags & XBF_READ));
 
-	spin_lock(&btp->bt_delwri_lock);
-	if (!list_empty(&bp->b_list)) {
-		/* if already in the queue, move it to the tail */
-		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-		list_move_tail(&bp->b_list, &btp->bt_delwri_queue);
-	} else {
-		/* start xfsbufd as it is about to have something to do */
-		if (list_empty(&btp->bt_delwri_queue))
-			wake_up_process(bp->b_target->bt_task);
-
-		atomic_inc(&bp->b_hold);
-		bp->b_flags |= XBF_DELWRI | _XBF_DELWRI_Q | XBF_ASYNC;
-		list_add_tail(&bp->b_list, &btp->bt_delwri_queue);
-	}
-	bp->b_queuetime = jiffies;
-	spin_unlock(&btp->bt_delwri_lock);
-}
-
-void
-xfs_buf_delwri_dequeue(
-	xfs_buf_t		*bp)
-{
-	int			dequeued = 0;
-
-	spin_lock(&bp->b_target->bt_delwri_lock);
-	if ((bp->b_flags & XBF_DELWRI) && !list_empty(&bp->b_list)) {
-		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-		list_del_init(&bp->b_list);
-		dequeued = 1;
+	/*
+	 * If the buffer is already marked delwri it already is queued up
+	 * by someone else for imediate writeout.  Just ignore it in that
+	 * case.
+	 */
+	if (bp->b_flags & _XBF_DELWRI_Q) {
+		trace_xfs_buf_delwri_queued(bp, _RET_IP_);
+		return false;
 	}
-	bp->b_flags &= ~(XBF_DELWRI|_XBF_DELWRI_Q);
-	spin_unlock(&bp->b_target->bt_delwri_lock);
-
-	if (dequeued)
-		xfs_buf_rele(bp);
-
-	trace_xfs_buf_delwri_dequeue(bp, _RET_IP_);
-}
 
-/*
- * If a delwri buffer needs to be pushed before it has aged out, then promote
- * it to the head of the delwri queue so that it will be flushed on the next
- * xfsbufd run. We do this by resetting the queuetime of the buffer to be older
- * than the age currently needed to flush the buffer. Hence the next time the
- * xfsbufd sees it is guaranteed to be considered old enough to flush.
- */
-void
-xfs_buf_delwri_promote(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buftarg *btp = bp->b_target;
-	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10) + 1;
-
-	ASSERT(bp->b_flags & XBF_DELWRI);
-	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
+	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
 
 	/*
-	 * Check the buffer age before locking the delayed write queue as we
-	 * don't need to promote buffers that are already past the flush age.
+	 * If a buffer gets written out synchronously while it is on a delwri
+	 * list we lazily remove it, aka only the _XBF_DELWRI_Q flag gets
+	 * cleared, but it remains referenced and on the list.  In a rare
+	 * corner case it might get readded to a delwri list after the
+	 * synchronous writeout, in which case we need just need to re-add
+	 * the flag here.
 	 */
-	if (bp->b_queuetime < jiffies - age)
-		return;
-	bp->b_queuetime = jiffies - age;
-	spin_lock(&btp->bt_delwri_lock);
-	list_move(&bp->b_list, &btp->bt_delwri_queue);
-	spin_unlock(&btp->bt_delwri_lock);
-}
-
-/*
- * Move as many buffers as specified to the supplied list
- * idicating if we skipped any buffers to prevent deadlocks.
- */
-STATIC int
-xfs_buf_delwri_split(
-	xfs_buftarg_t	*target,
-	struct list_head *list,
-	unsigned long	age)
-{
-	xfs_buf_t	*bp, *n;
-	int		skipped = 0;
-	int		force;
-
-	force = test_and_clear_bit(XBT_FORCE_FLUSH, &target->bt_flags);
-	INIT_LIST_HEAD(list);
-	spin_lock(&target->bt_delwri_lock);
-	list_for_each_entry_safe(bp, n, &target->bt_delwri_queue, b_list) {
-		ASSERT(bp->b_flags & XBF_DELWRI);
-
-		if (!xfs_buf_ispinned(bp) && xfs_buf_trylock(bp)) {
-			if (!force &&
-			    time_before(jiffies, bp->b_queuetime + age)) {
-				xfs_buf_unlock(bp);
-				break;
-			}
-
-			bp->b_flags &= ~(XBF_DELWRI | _XBF_DELWRI_Q);
-			bp->b_flags |= XBF_WRITE;
-			list_move_tail(&bp->b_list, list);
-			trace_xfs_buf_delwri_split(bp, _RET_IP_);
-		} else
-			skipped++;
+	bp->b_flags |= _XBF_DELWRI_Q;
+	if (list_empty(&bp->b_list)) {
+		atomic_inc(&bp->b_hold);
+		list_add_tail(&bp->b_list, list);
 	}
 
-	spin_unlock(&target->bt_delwri_lock);
-	return skipped;
+	return true;
 }
 
 /*
@@ -1683,99 +1588,106 @@ xfs_buf_cmp(
 	return 0;
 }
 
-STATIC int
-xfsbufd(
-	void		*data)
-{
-	xfs_buftarg_t   *target = (xfs_buftarg_t *)data;
-
-	current->flags |= PF_MEMALLOC;
-
-	set_freezable();
+static int
+__xfs_buf_delwri_submit(
+	struct list_head	*submit_list,
+	struct list_head	*list,
+	bool			wait)
+{
+	struct blk_plug		plug;
+	struct xfs_buf		*bp, *n;
+	int			pinned = 0;
+
+	list_for_each_entry_safe(bp, n, list, b_list) {
+		if (!wait) {
+			if (xfs_buf_ispinned(bp)) {
+				pinned++;
+				continue;
+			}
+			if (!xfs_buf_trylock(bp))
+				continue;
+		} else {
+			xfs_buf_lock(bp);
+		}
 
-	do {
-		long	age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
-		long	tout = xfs_buf_timer_centisecs * msecs_to_jiffies(10);
-		struct list_head tmp;
-		struct blk_plug plug;
+		/*
+		 * Someone else might have written the buffer synchronously
+		 * in the meantime.  In that case only the _XBF_DELWRI_Q flag
+		 * got cleared, and we have to drop the reference and remove
+		 * it from the list here.
+		 */
+		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
+			list_del_init(&bp->b_list);
+			xfs_buf_relse(bp);
+			continue;
+		}
 
-		if (unlikely(freezing(current)))
-			try_to_freeze();
+		list_move_tail(&bp->b_list, submit_list);
+		trace_xfs_buf_delwri_split(bp, _RET_IP_);
+	}
 
-		/* sleep for a long time if there is nothing to do. */
-		if (list_empty(&target->bt_delwri_queue))
-			tout = MAX_SCHEDULE_TIMEOUT;
-		schedule_timeout_interruptible(tout);
+	list_sort(NULL, submit_list, xfs_buf_cmp);
 
-		xfs_buf_delwri_split(target, &tmp, age);
-		list_sort(NULL, &tmp, xfs_buf_cmp);
+	blk_start_plug(&plug);
+	list_for_each_entry_safe(bp, n, submit_list, b_list) {
+		bp->b_flags &= ~_XBF_DELWRI_Q;
+		bp->b_flags |= XBF_WRITE;
 
-		blk_start_plug(&plug);
-		while (!list_empty(&tmp)) {
-			struct xfs_buf *bp;
-			bp = list_first_entry(&tmp, struct xfs_buf, b_list);
+		if (!wait) {
+			bp->b_flags |= XBF_ASYNC;
 			list_del_init(&bp->b_list);
-			xfs_bdstrat_cb(bp);
 		}
-		blk_finish_plug(&plug);
-	} while (!kthread_should_stop());
+		xfs_bdstrat_cb(bp);
+	}
+	blk_finish_plug(&plug);
 
-	return 0;
+	return pinned;
 }
 
 /*
- *	Go through all incore buffers, and release buffers if they belong to
- *	the given device. This is used in filesystem error handling to
- *	preserve the consistency of its metadata.
+ * Write out a buffer list asynchronously.
+ *
+ * This will take the buffer list, write all non-locked and non-pinned buffers
+ * out and not wait for I/O completion on any of the buffers.  This interface
+ * is only safely useable for callers that can track I/O completion by higher
+ * level means, e.g. AIL pushing.
  */
 int
-xfs_flush_buftarg(
-	xfs_buftarg_t	*target,
-	int		wait)
-{
-	xfs_buf_t	*bp;
-	int		pincount = 0;
-	LIST_HEAD(tmp_list);
-	LIST_HEAD(wait_list);
-	struct blk_plug plug;
+xfs_buf_delwri_submit_nowait(
+	struct list_head	*list)
+{
+	LIST_HEAD		(submit_list);
+	return __xfs_buf_delwri_submit(&submit_list, list, false);
+}
 
-	flush_workqueue(xfslogd_workqueue);
+/*
+ * Write out a buffer list synchronously.
+ *
+ * This will take the buffer list, write all buffers out and wait for I/O
+ * completion on all of the buffers.
+ */
+int
+xfs_buf_delwri_submit(
+	struct list_head	*list)
+{
+	LIST_HEAD		(submit_list);
+	int			error = 0, error2;
+	struct xfs_buf		*bp;
 
-	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
-	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);
+	__xfs_buf_delwri_submit(&submit_list, list, true);
 
-	/*
-	 * Dropped the delayed write list lock, now walk the temporary list.
-	 * All I/O is issued async and then if we need to wait for completion
-	 * we do that after issuing all the IO.
-	 */
-	list_sort(NULL, &tmp_list, xfs_buf_cmp);
+	/* Wait for IO to complete. */
+	while (!list_empty(&submit_list)) {
+		bp = list_first_entry(&submit_list, struct xfs_buf, b_list);
 
-	blk_start_plug(&plug);
-	while (!list_empty(&tmp_list)) {
-		bp = list_first_entry(&tmp_list, struct xfs_buf, b_list);
-		ASSERT(target == bp->b_target);
 		list_del_init(&bp->b_list);
-		if (wait) {
-			bp->b_flags &= ~XBF_ASYNC;
-			list_add(&bp->b_list, &wait_list);
-		}
-		xfs_bdstrat_cb(bp);
-	}
-	blk_finish_plug(&plug);
-
-	if (wait) {
-		/* Wait for IO to complete. */
-		while (!list_empty(&wait_list)) {
-			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
-
-			list_del_init(&bp->b_list);
-			xfs_buf_iowait(bp);
-			xfs_buf_relse(bp);
-		}
+		error2 = xfs_buf_iowait(bp);
+		xfs_buf_relse(bp);
+		if (!error)
+			error = error2;
 	}
 
-	return pincount;
+	return error;
 }
 
 int __init
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2012-03-25 16:46:11.337889825 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2012-03-25 17:16:31.607923578 +0200
@@ -418,7 +418,6 @@ xfs_buf_item_unpin(
 	if (freed && stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
 		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(!(XFS_BUF_ISDELAYWRITE(bp)));
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
 
@@ -469,34 +468,28 @@ xfs_buf_item_unpin(
 	}
 }
 
-/*
- * This is called to attempt to lock the buffer associated with this
- * buf log item.  Don't sleep on the buffer lock.  If we can't get
- * the lock right away, return 0.  If we can get the lock, take a
- * reference to the buffer. If this is a delayed write buffer that
- * needs AIL help to be written back, invoke the pushbuf routine
- * rather than the normal success path.
- */
 STATIC uint
-xfs_buf_item_trylock(
-	struct xfs_log_item	*lip)
+xfs_buf_item_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
+	uint			rval = XFS_ITEM_SUCCESS;
 
 	if (xfs_buf_ispinned(bp))
 		return XFS_ITEM_PINNED;
 	if (!xfs_buf_trylock(bp))
 		return XFS_ITEM_LOCKED;
 
-	/* take a reference to the buffer.  */
-	xfs_buf_hold(bp);
-
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	trace_xfs_buf_item_trylock(bip);
-	if (XFS_BUF_ISDELAYWRITE(bp))
-		return XFS_ITEM_PUSHBUF;
-	return XFS_ITEM_SUCCESS;
+
+	trace_xfs_buf_item_push(bip);
+
+	if (!xfs_buf_delwri_queue(bp, buffer_list))
+		rval = XFS_ITEM_FLUSHING;
+	xfs_buf_unlock(bp);
+	return rval;
 }
 
 /*
@@ -609,48 +602,6 @@ xfs_buf_item_committed(
 	return lsn;
 }
 
-/*
- * The buffer is locked, but is not a delayed write buffer.
- */
-STATIC void
-xfs_buf_item_push(
-	struct xfs_log_item	*lip)
-{
-	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
-	struct xfs_buf		*bp = bip->bli_buf;
-
-	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(!XFS_BUF_ISDELAYWRITE(bp));
-
-	trace_xfs_buf_item_push(bip);
-
-	xfs_buf_delwri_queue(bp);
-	xfs_buf_relse(bp);
-}
-
-/*
- * The buffer is locked and is a delayed write buffer. Promote the buffer
- * in the delayed write queue as the caller knows that they must invoke
- * the xfsbufd to get this buffer written. We have to unlock the buffer
- * to allow the xfsbufd to write it, too.
- */
-STATIC bool
-xfs_buf_item_pushbuf(
-	struct xfs_log_item	*lip)
-{
-	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
-	struct xfs_buf		*bp = bip->bli_buf;
-
-	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
-	ASSERT(XFS_BUF_ISDELAYWRITE(bp));
-
-	trace_xfs_buf_item_pushbuf(bip);
-
-	xfs_buf_delwri_promote(bp);
-	xfs_buf_relse(bp);
-	return true;
-}
-
 STATIC void
 xfs_buf_item_committing(
 	struct xfs_log_item	*lip,
@@ -666,11 +617,9 @@ static const struct xfs_item_ops xfs_buf
 	.iop_format	= xfs_buf_item_format,
 	.iop_pin	= xfs_buf_item_pin,
 	.iop_unpin	= xfs_buf_item_unpin,
-	.iop_trylock	= xfs_buf_item_trylock,
 	.iop_unlock	= xfs_buf_item_unlock,
 	.iop_committed	= xfs_buf_item_committed,
 	.iop_push	= xfs_buf_item_push,
-	.iop_pushbuf	= xfs_buf_item_pushbuf,
 	.iop_committing = xfs_buf_item_committing
 };
 
@@ -989,20 +938,27 @@ xfs_buf_iodone_callbacks(
 	 * If the write was asynchronous then no one will be looking for the
 	 * error.  Clear the error state and write the buffer out again.
 	 *
-	 * During sync or umount we'll write all pending buffers again
-	 * synchronous, which will catch these errors if they keep hanging
-	 * around.
+	 * XXX: This helps against transient write errors, but we need to find
+	 * a way to shut the filesystem down if the writes keep failing.
+	 *
+	 * In practice we'll shut the filesystem down soon as non-transient
+	 * erorrs tend to affect the whole device and a failing log write
+	 * will make us give up.  But we really ought to do better here.
 	 */
 	if (XFS_BUF_ISASYNC(bp)) {
+		ASSERT(bp->b_iodone != NULL);
+
+		trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
+
 		xfs_buf_ioerror(bp, 0); /* errno of 0 unsets the flag */
 
 		if (!XFS_BUF_ISSTALE(bp)) {
-			xfs_buf_delwri_queue(bp);
-			XFS_BUF_DONE(bp);
+			bp->b_flags |= XBF_WRITE | XBF_ASYNC | XBF_DONE;
+			xfs_bdstrat_cb(bp);
+		} else {
+			xfs_buf_relse(bp);
 		}
-		ASSERT(bp->b_iodone != NULL);
-		trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
-		xfs_buf_relse(bp);
+
 		return;
 	}
 
Index: xfs/fs/xfs/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot_item.c	2012-03-25 16:46:10.211223137 +0200
+++ xfs/fs/xfs/xfs_dquot_item.c	2012-03-25 16:47:50.337891661 +0200
@@ -108,46 +108,6 @@ xfs_qm_dquot_logitem_unpin(
 		wake_up(&dqp->q_pinwait);
 }
 
-/*
- * Given the logitem, this writes the corresponding dquot entry to disk
- * asynchronously. This is called with the dquot entry securely locked;
- * we simply get xfs_qm_dqflush() to do the work, and unlock the dquot
- * at the end.
- */
-STATIC void
-xfs_qm_dquot_logitem_push(
-	struct xfs_log_item	*lip)
-{
-	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
-	struct xfs_buf		*bp = NULL;
-	int			error;
-
-	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	ASSERT(!completion_done(&dqp->q_flush));
-	ASSERT(atomic_read(&dqp->q_pincount) == 0);
-
-	/*
-	 * Since we were able to lock the dquot's flush lock and
-	 * we found it on the AIL, the dquot must be dirty.  This
-	 * is because the dquot is removed from the AIL while still
-	 * holding the flush lock in xfs_dqflush_done().  Thus, if
-	 * we found it in the AIL and were able to obtain the flush
-	 * lock without sleeping, then there must not have been
-	 * anyone in the process of flushing the dquot.
-	 */
-	error = xfs_qm_dqflush(dqp, &bp);
-	if (error) {
-		xfs_warn(dqp->q_mount, "%s: push error %d on dqp %p",
-			__func__, error, dqp);
-		goto out_unlock;
-	}
-
-	xfs_buf_delwri_queue(bp);
-	xfs_buf_relse(bp);
-out_unlock:
-	xfs_dqunlock(dqp);
-}
-
 STATIC xfs_lsn_t
 xfs_qm_dquot_logitem_committed(
 	struct xfs_log_item	*lip,
@@ -179,67 +139,15 @@ xfs_qm_dqunpin_wait(
 	wait_event(dqp->q_pinwait, (atomic_read(&dqp->q_pincount) == 0));
 }
 
-/*
- * This is called when IOP_TRYLOCK returns XFS_ITEM_PUSHBUF to indicate that
- * the dquot is locked by us, but the flush lock isn't. So, here we are
- * going to see if the relevant dquot buffer is incore, waiting on DELWRI.
- * If so, we want to push it out to help us take this item off the AIL as soon
- * as possible.
- *
- * We must not be holding the AIL lock at this point. Calling incore() to
- * search the buffer cache can be a time consuming thing, and AIL lock is a
- * spinlock.
- */
-STATIC bool
-xfs_qm_dquot_logitem_pushbuf(
-	struct xfs_log_item	*lip)
-{
-	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
-	struct xfs_dquot	*dqp = qlip->qli_dquot;
-	struct xfs_buf		*bp;
-	bool			ret = true;
-
-	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-
-	/*
-	 * If flushlock isn't locked anymore, chances are that the
-	 * inode flush completed and the inode was taken off the AIL.
-	 * So, just get out.
-	 */
-	if (completion_done(&dqp->q_flush) ||
-	    !(lip->li_flags & XFS_LI_IN_AIL)) {
-		xfs_dqunlock(dqp);
-		return true;
-	}
-
-	bp = xfs_incore(dqp->q_mount->m_ddev_targp, qlip->qli_format.qlf_blkno,
-			dqp->q_mount->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK);
-	xfs_dqunlock(dqp);
-	if (!bp)
-		return true;
-	if (XFS_BUF_ISDELAYWRITE(bp))
-		xfs_buf_delwri_promote(bp);
-	if (xfs_buf_ispinned(bp))
-		ret = false;
-	xfs_buf_relse(bp);
-	return ret;
-}
-
-/*
- * This is called to attempt to lock the dquot associated with this
- * dquot log item.  Don't sleep on the dquot lock or the flush lock.
- * If the flush lock is already held, indicating that the dquot has
- * been or is in the process of being flushed, then see if we can
- * find the dquot's buffer in the buffer cache without sleeping.  If
- * we can and it is marked delayed write, then we want to send it out.
- * We delay doing so until the push routine, though, to avoid sleeping
- * in any device strategy routines.
- */
 STATIC uint
-xfs_qm_dquot_logitem_trylock(
-	struct xfs_log_item	*lip)
+xfs_qm_dquot_logitem_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
 {
 	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
+	struct xfs_buf		*bp = NULL;
+	uint			rval = XFS_ITEM_SUCCESS;
+	int			error;
 
 	if (atomic_read(&dqp->q_pincount) > 0)
 		return XFS_ITEM_PINNED;
@@ -252,20 +160,36 @@ xfs_qm_dquot_logitem_trylock(
 	 * taking the quota lock.
 	 */
 	if (atomic_read(&dqp->q_pincount) > 0) {
-		xfs_dqunlock(dqp);
-		return XFS_ITEM_PINNED;
+		rval = XFS_ITEM_PINNED;
+		goto out_unlock;
 	}
 
+	/*
+	 * Someone else is already flushing the dquot.  Nothing we can do
+	 * here but wait for the flush to finish and remove the item from
+	 * the AIL.
+	 */
 	if (!xfs_dqflock_nowait(dqp)) {
-		/*
-		 * dquot has already been flushed to the backing buffer,
-		 * leave it locked, pushbuf routine will unlock it.
-		 */
-		return XFS_ITEM_PUSHBUF;
+		rval = XFS_ITEM_FLUSHING;
+		goto out_unlock;
 	}
 
-	ASSERT(lip->li_flags & XFS_LI_IN_AIL);
-	return XFS_ITEM_SUCCESS;
+	spin_unlock(&lip->li_ailp->xa_lock);
+
+	error = xfs_qm_dqflush(dqp, &bp);
+	if (error) {
+		xfs_warn(dqp->q_mount, "%s: push error %d on dqp %p",
+			__func__, error, dqp);
+	} else {
+		if (!xfs_buf_delwri_queue(bp, buffer_list))
+			rval = XFS_ITEM_FLUSHING;
+		xfs_buf_relse(bp);
+	}
+
+	spin_lock(&lip->li_ailp->xa_lock);
+out_unlock:
+	xfs_dqunlock(dqp);
+	return rval;
 }
 
 /*
@@ -316,11 +240,9 @@ static const struct xfs_item_ops xfs_dqu
 	.iop_format	= xfs_qm_dquot_logitem_format,
 	.iop_pin	= xfs_qm_dquot_logitem_pin,
 	.iop_unpin	= xfs_qm_dquot_logitem_unpin,
-	.iop_trylock	= xfs_qm_dquot_logitem_trylock,
 	.iop_unlock	= xfs_qm_dquot_logitem_unlock,
 	.iop_committed	= xfs_qm_dquot_logitem_committed,
 	.iop_push	= xfs_qm_dquot_logitem_push,
-	.iop_pushbuf	= xfs_qm_dquot_logitem_pushbuf,
 	.iop_committing = xfs_qm_dquot_logitem_committing
 };
 
@@ -415,11 +337,13 @@ xfs_qm_qoff_logitem_unpin(
 }
 
 /*
- * Quotaoff items have no locking, so just return success.
+ * There isn't much you can do to push a quotaoff item.  It is simply
+ * stuck waiting for the log to be flushed to disk.
  */
 STATIC uint
-xfs_qm_qoff_logitem_trylock(
-	struct xfs_log_item	*lip)
+xfs_qm_qoff_logitem_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
 {
 	return XFS_ITEM_LOCKED;
 }
@@ -446,17 +370,6 @@ xfs_qm_qoff_logitem_committed(
 	return lsn;
 }
 
-/*
- * There isn't much you can do to push on an quotaoff item.  It is simply
- * stuck waiting for the log to be flushed to disk.
- */
-STATIC void
-xfs_qm_qoff_logitem_push(
-	struct xfs_log_item	*lip)
-{
-}
-
-
 STATIC xfs_lsn_t
 xfs_qm_qoffend_logitem_committed(
 	struct xfs_log_item	*lip,
@@ -504,7 +417,6 @@ static const struct xfs_item_ops xfs_qm_
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_pin	= xfs_qm_qoff_logitem_pin,
 	.iop_unpin	= xfs_qm_qoff_logitem_unpin,
-	.iop_trylock	= xfs_qm_qoff_logitem_trylock,
 	.iop_unlock	= xfs_qm_qoff_logitem_unlock,
 	.iop_committed	= xfs_qm_qoffend_logitem_committed,
 	.iop_push	= xfs_qm_qoff_logitem_push,
@@ -519,7 +431,6 @@ static const struct xfs_item_ops xfs_qm_
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_pin	= xfs_qm_qoff_logitem_pin,
 	.iop_unpin	= xfs_qm_qoff_logitem_unpin,
-	.iop_trylock	= xfs_qm_qoff_logitem_trylock,
 	.iop_unlock	= xfs_qm_qoff_logitem_unlock,
 	.iop_committed	= xfs_qm_qoff_logitem_committed,
 	.iop_push	= xfs_qm_qoff_logitem_push,
Index: xfs/fs/xfs/xfs_extfree_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extfree_item.c	2012-03-25 16:41:00.177884056 +0200
+++ xfs/fs/xfs/xfs_extfree_item.c	2012-03-25 16:48:54.091226177 +0200
@@ -147,22 +147,20 @@ xfs_efi_item_unpin(
 }
 
 /*
- * Efi items have no locking or pushing.  However, since EFIs are
- * pulled from the AIL when their corresponding EFDs are committed
- * to disk, their situation is very similar to being pinned.  Return
- * XFS_ITEM_PINNED so that the caller will eventually flush the log.
- * This should help in getting the EFI out of the AIL.
+ * Efi items have no locking or pushing.  However, since EFIs are pulled from
+ * the AIL when their corresponding EFDs are committed to disk, their situation
+ * is very similar to being pinned.  Return XFS_ITEM_PINNED so that the caller
+ * will eventually flush the log.  This should help in getting the EFI out of
+ * the AIL.
  */
 STATIC uint
-xfs_efi_item_trylock(
-	struct xfs_log_item	*lip)
+xfs_efi_item_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
 {
 	return XFS_ITEM_PINNED;
 }
 
-/*
- * Efi items have no locking, so just return.
- */
 STATIC void
 xfs_efi_item_unlock(
 	struct xfs_log_item	*lip)
@@ -190,17 +188,6 @@ xfs_efi_item_committed(
 }
 
 /*
- * There isn't much you can do to push on an efi item.  It is simply
- * stuck waiting for all of its corresponding efd items to be
- * committed to disk.
- */
-STATIC void
-xfs_efi_item_push(
-	struct xfs_log_item	*lip)
-{
-}
-
-/*
  * The EFI dependency tracking op doesn't do squat.  It can't because
  * it doesn't know where the free extent is coming from.  The dependency
  * tracking has to be handled by the "enclosing" metadata object.  For
@@ -222,7 +209,6 @@ static const struct xfs_item_ops xfs_efi
 	.iop_format	= xfs_efi_item_format,
 	.iop_pin	= xfs_efi_item_pin,
 	.iop_unpin	= xfs_efi_item_unpin,
-	.iop_trylock	= xfs_efi_item_trylock,
 	.iop_unlock	= xfs_efi_item_unlock,
 	.iop_committed	= xfs_efi_item_committed,
 	.iop_push	= xfs_efi_item_push,
@@ -404,19 +390,17 @@ xfs_efd_item_unpin(
 }
 
 /*
- * Efd items have no locking, so just return success.
+ * There isn't much you can do to push on an efd item.  It is simply stuck
+ * waiting for the log to be flushed to disk.
  */
 STATIC uint
-xfs_efd_item_trylock(
-	struct xfs_log_item	*lip)
+xfs_efd_item_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
 {
 	return XFS_ITEM_LOCKED;
 }
 
-/*
- * Efd items have no locking or pushing, so return failure
- * so that the caller doesn't bother with us.
- */
 STATIC void
 xfs_efd_item_unlock(
 	struct xfs_log_item	*lip)
@@ -451,16 +435,6 @@ xfs_efd_item_committed(
 }
 
 /*
- * There isn't much you can do to push on an efd item.  It is simply
- * stuck waiting for the log to be flushed to disk.
- */
-STATIC void
-xfs_efd_item_push(
-	struct xfs_log_item	*lip)
-{
-}
-
-/*
  * The EFD dependency tracking op doesn't do squat.  It can't because
  * it doesn't know where the free extent is coming from.  The dependency
  * tracking has to be handled by the "enclosing" metadata object.  For
@@ -482,7 +456,6 @@ static const struct xfs_item_ops xfs_efd
 	.iop_format	= xfs_efd_item_format,
 	.iop_pin	= xfs_efd_item_pin,
 	.iop_unpin	= xfs_efd_item_unpin,
-	.iop_trylock	= xfs_efd_item_trylock,
 	.iop_unlock	= xfs_efd_item_unlock,
 	.iop_committed	= xfs_efd_item_committed,
 	.iop_push	= xfs_efd_item_push,
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2012-03-25 16:41:21.651217787 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2012-03-25 16:49:09.501226460 +0200
@@ -480,25 +480,16 @@ xfs_inode_item_unpin(
 		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
 }
 
-/*
- * This is called to attempt to lock the inode associated with this
- * inode log item, in preparation for the push routine which does the actual
- * iflush.  Don't sleep on the inode lock or the flush lock.
- *
- * If the flush lock is already held, indicating that the inode has
- * been or is in the process of being flushed, then (ideally) we'd like to
- * see if the inode's buffer is still incore, and if so give it a nudge.
- * We delay doing so until the pushbuf routine, though, to avoid holding
- * the AIL lock across a call to the blackhole which is the buffer cache.
- * Also we don't want to sleep in any device strategy routines, which can happen
- * if we do the subsequent bawrite in here.
- */
 STATIC uint
-xfs_inode_item_trylock(
-	struct xfs_log_item	*lip)
+xfs_inode_item_push(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
+	struct xfs_buf		*bp = NULL;
+	uint			rval = XFS_ITEM_SUCCESS;
+	int			error;
 
 	if (xfs_ipincount(ip) > 0)
 		return XFS_ITEM_PINNED;
@@ -511,34 +502,45 @@ xfs_inode_item_trylock(
 	 * taking the ilock.
 	 */
 	if (xfs_ipincount(ip) > 0) {
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		return XFS_ITEM_PINNED;
+		rval = XFS_ITEM_PINNED;
+		goto out_unlock;
 	}
 
+	/*
+	 * Someone else is already flushing the inode.  Nothing we can do
+	 * here but wait for the flush to finish and remove the item from
+	 * the AIL.
+	 */
 	if (!xfs_iflock_nowait(ip)) {
-		/*
-		 * inode has already been flushed to the backing buffer,
-		 * leave it locked in shared mode, pushbuf routine will
-		 * unlock it.
-		 */
-		return XFS_ITEM_PUSHBUF;
+		rval = XFS_ITEM_FLUSHING;
+		goto out_unlock;
 	}
 
-	/* Stale items should force out the iclog */
+	/*
+	 * Stale inode items should force out the iclog.
+	 */
 	if (ip->i_flags & XFS_ISTALE) {
 		xfs_ifunlock(ip);
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		return XFS_ITEM_PINNED;
 	}
 
-#ifdef DEBUG
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		ASSERT(iip->ili_fields != 0);
-		ASSERT(iip->ili_logged == 0);
-		ASSERT(lip->li_flags & XFS_LI_IN_AIL);
+	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
+	ASSERT(iip->ili_logged == 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
+
+	spin_unlock(&lip->li_ailp->xa_lock);
+
+	error = xfs_iflush(ip, &bp);
+	if (!error) {
+		if (!xfs_buf_delwri_queue(bp, buffer_list))
+			rval = XFS_ITEM_FLUSHING;
+		xfs_buf_relse(bp);
 	}
-#endif
-	return XFS_ITEM_SUCCESS;
+
+	spin_lock(&lip->li_ailp->xa_lock);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return rval;
 }
 
 /*
@@ -623,92 +625,6 @@ xfs_inode_item_committed(
 }
 
 /*
- * This gets called by xfs_trans_push_ail(), when IOP_TRYLOCK
- * failed to get the inode flush lock but did get the inode locked SHARED.
- * Here we're trying to see if the inode buffer is incore, and if so whether it's
- * marked delayed write. If that's the case, we'll promote it and that will
- * allow the caller to write the buffer by triggering the xfsbufd to run.
- */
-STATIC bool
-xfs_inode_item_pushbuf(
-	struct xfs_log_item	*lip)
-{
-	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
-	struct xfs_inode	*ip = iip->ili_inode;
-	struct xfs_buf		*bp;
-	bool			ret = true;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
-
-	/*
-	 * If a flush is not in progress anymore, chances are that the
-	 * inode was taken off the AIL. So, just get out.
-	 */
-	if (!xfs_isiflocked(ip) ||
-	    !(lip->li_flags & XFS_LI_IN_AIL)) {
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		return true;
-	}
-
-	bp = xfs_incore(ip->i_mount->m_ddev_targp, iip->ili_format.ilf_blkno,
-			iip->ili_format.ilf_len, XBF_TRYLOCK);
-
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	if (!bp)
-		return true;
-	if (XFS_BUF_ISDELAYWRITE(bp))
-		xfs_buf_delwri_promote(bp);
-	if (xfs_buf_ispinned(bp))
-		ret = false;
-	xfs_buf_relse(bp);
-	return ret;
-}
-
-/*
- * This is called to asynchronously write the inode associated with this
- * inode log item out to disk. The inode will already have been locked by
- * a successful call to xfs_inode_item_trylock().
- */
-STATIC void
-xfs_inode_item_push(
-	struct xfs_log_item	*lip)
-{
-	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
-	struct xfs_inode	*ip = iip->ili_inode;
-	struct xfs_buf		*bp = NULL;
-	int			error;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
-	ASSERT(xfs_isiflocked(ip));
-
-	/*
-	 * Since we were able to lock the inode's flush lock and
-	 * we found it on the AIL, the inode must be dirty.  This
-	 * is because the inode is removed from the AIL while still
-	 * holding the flush lock in xfs_iflush_done().  Thus, if
-	 * we found it in the AIL and were able to obtain the flush
-	 * lock without sleeping, then there must not have been
-	 * anyone in the process of flushing the inode.
-	 */
-	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || iip->ili_fields != 0);
-
-	/*
-	 * Push the inode to it's backing buffer. This will not remove the
-	 * inode from the AIL - a further push will be required to trigger a
-	 * buffer push. However, this allows all the dirty inodes to be pushed
-	 * to the buffer before it is pushed to disk. The buffer IO completion
-	 * will pull the inode from the AIL, mark it clean and unlock the flush
-	 * lock.
-	 */
-	error = xfs_iflush(ip, &bp);
-	if (!error) {
-		xfs_buf_delwri_queue(bp);
-		xfs_buf_relse(bp);
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-}
-
-/*
  * XXX rcc - this one really has to do something.  Probably needs
  * to stamp in a new field in the incore inode.
  */
@@ -728,11 +644,9 @@ static const struct xfs_item_ops xfs_ino
 	.iop_format	= xfs_inode_item_format,
 	.iop_pin	= xfs_inode_item_pin,
 	.iop_unpin	= xfs_inode_item_unpin,
-	.iop_trylock	= xfs_inode_item_trylock,
 	.iop_unlock	= xfs_inode_item_unlock,
 	.iop_committed	= xfs_inode_item_committed,
 	.iop_push	= xfs_inode_item_push,
-	.iop_pushbuf	= xfs_inode_item_pushbuf,
 	.iop_committing = xfs_inode_item_committing
 };
 
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2012-03-25 16:41:18.207884389 +0200
+++ xfs/fs/xfs/xfs_trace.h	2012-03-25 17:09:36.381249212 +0200
@@ -328,7 +328,7 @@ DEFINE_BUF_EVENT(xfs_buf_unlock);
 DEFINE_BUF_EVENT(xfs_buf_iowait);
 DEFINE_BUF_EVENT(xfs_buf_iowait_done);
 DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
-DEFINE_BUF_EVENT(xfs_buf_delwri_dequeue);
+DEFINE_BUF_EVENT(xfs_buf_delwri_queued);
 DEFINE_BUF_EVENT(xfs_buf_delwri_split);
 DEFINE_BUF_EVENT(xfs_buf_get_uncached);
 DEFINE_BUF_EVENT(xfs_bdstrat_shut);
@@ -486,12 +486,10 @@ DEFINE_BUF_ITEM_EVENT(xfs_buf_item_forma
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin_stale);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_trylock);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock_stale);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_committed);
 DEFINE_BUF_ITEM_EVENT(xfs_buf_item_push);
-DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pushbuf);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf_recur);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_getsb);
@@ -881,10 +879,9 @@ DEFINE_EVENT(xfs_log_item_class, name, \
 	TP_PROTO(struct xfs_log_item *lip), \
 	TP_ARGS(lip))
 DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
-DEFINE_LOG_ITEM_EVENT(xfs_ail_pushbuf);
-DEFINE_LOG_ITEM_EVENT(xfs_ail_pushbuf_pinned);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
+DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
 
 
 DECLARE_EVENT_CLASS(xfs_file_class,
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2012-03-25 16:41:00.214550722 +0200
+++ xfs/fs/xfs/xfs_trans.h	2012-03-25 16:46:11.987889837 +0200
@@ -345,11 +345,9 @@ struct xfs_item_ops {
 	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
 	void (*iop_pin)(xfs_log_item_t *);
 	void (*iop_unpin)(xfs_log_item_t *, int remove);
-	uint (*iop_trylock)(xfs_log_item_t *);
+	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
 	void (*iop_unlock)(xfs_log_item_t *);
 	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
-	void (*iop_push)(xfs_log_item_t *);
-	bool (*iop_pushbuf)(xfs_log_item_t *);
 	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
 };
 
@@ -357,20 +355,18 @@ struct xfs_item_ops {
 #define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)
 #define IOP_PIN(ip)		(*(ip)->li_ops->iop_pin)(ip)
 #define IOP_UNPIN(ip, remove)	(*(ip)->li_ops->iop_unpin)(ip, remove)
-#define IOP_TRYLOCK(ip)		(*(ip)->li_ops->iop_trylock)(ip)
+#define IOP_PUSH(ip, list)	(*(ip)->li_ops->iop_push)(ip, list)
 #define IOP_UNLOCK(ip)		(*(ip)->li_ops->iop_unlock)(ip)
 #define IOP_COMMITTED(ip, lsn)	(*(ip)->li_ops->iop_committed)(ip, lsn)
-#define IOP_PUSH(ip)		(*(ip)->li_ops->iop_push)(ip)
-#define IOP_PUSHBUF(ip)		(*(ip)->li_ops->iop_pushbuf)(ip)
 #define IOP_COMMITTING(ip, lsn) (*(ip)->li_ops->iop_committing)(ip, lsn)
 
 /*
- * Return values for the IOP_TRYLOCK() routines.
+ * Return values for the IOP_PUSH() routines.
  */
-#define	XFS_ITEM_SUCCESS	0
-#define	XFS_ITEM_PINNED		1
-#define	XFS_ITEM_LOCKED		2
-#define XFS_ITEM_PUSHBUF	3
+#define XFS_ITEM_SUCCESS	0
+#define XFS_ITEM_PINNED		1
+#define XFS_ITEM_LOCKED		2
+#define XFS_ITEM_FLUSHING	3
 
 /*
  * This is the type of function which can be given to xfs_trans_callback()
Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2012-03-25 16:41:20.901217773 +0200
+++ xfs/fs/xfs/xfs_trans_ail.c	2012-03-25 17:16:19.787923358 +0200
@@ -364,29 +364,31 @@ xfsaild_push(
 	xfs_log_item_t		*lip;
 	xfs_lsn_t		lsn;
 	xfs_lsn_t		target;
-	long			tout = 10;
+	long			tout;
 	int			stuck = 0;
+	int			flushing = 0;
 	int			count = 0;
-	int			push_xfsbufd = 0;
 
 	/*
-	 * If last time we ran we encountered pinned items, force the log first
-	 * and wait for it before pushing again.
+	 * If we encountered pinned items or did not finish writing out all
+	 * buffers the last time we ran, force the log first and wait for it
+	 * before pushing again.
 	 */
-	spin_lock(&ailp->xa_lock);
-	if (ailp->xa_last_pushed_lsn == 0 && ailp->xa_log_flush &&
-	    !list_empty(&ailp->xa_ail)) {
+	if (ailp->xa_log_flush && ailp->xa_last_pushed_lsn == 0 &&
+	    (!list_empty_careful(&ailp->xa_buf_list) ||
+	     xfs_ail_min_lsn(ailp))) {
 		ailp->xa_log_flush = 0;
-		spin_unlock(&ailp->xa_lock);
+
 		XFS_STATS_INC(xs_push_ail_flush);
 		xfs_log_force(mp, XFS_LOG_SYNC);
-		spin_lock(&ailp->xa_lock);
 	}
 
+	spin_lock(&ailp->xa_lock);
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);
 	if (!lip) {
 		/*
-		 * AIL is empty or our push has reached the end.
+		 * If the AIL is empty or our push has reached the end we are
+		 * done now.
 		 */
 		xfs_trans_ail_cursor_done(ailp, &cur);
 		spin_unlock(&ailp->xa_lock);
@@ -396,64 +398,49 @@ xfsaild_push(
 	XFS_STATS_INC(xs_push_ail);
 
 	/*
-	 * If we are draining the AIL push all items, not just the current
-	 * threshold.
+	 * If at least one caller asks us to drain the AIL we have to push
+	 * out all all items, not just the current threshold.
 	 */
 	if (atomic_read(&ailp->xa_wait_empty))
 		target = xfs_ail_max(ailp)->li_lsn;
 	else
 		target = ailp->xa_target;
 
-	/*
-	 * While the item we are looking at is below the given threshold
-	 * try to flush it out. We'd like not to stop until we've at least
-	 * tried to push on everything in the AIL with an LSN less than
-	 * the given threshold.
-	 *
-	 * However, we will stop after a certain number of pushes and wait
-	 * for a reduced timeout to fire before pushing further. This
-	 * prevents use from spinning when we can't do anything or there is
-	 * lots of contention on the AIL lists.
-	 */
 	lsn = lip->li_lsn;
 	while ((XFS_LSN_CMP(lip->li_lsn, target) <= 0)) {
 		int	lock_result;
+
 		/*
-		 * If we can lock the item without sleeping, unlock the AIL
-		 * lock and flush the item.  Then re-grab the AIL lock so we
-		 * can look for the next item on the AIL. List changes are
-		 * handled by the AIL lookup functions internally
-		 *
-		 * If we can't lock the item, either its holder will flush it
-		 * or it is already being flushed or it is being relogged.  In
-		 * any of these case it is being taken care of and we can just
-		 * skip to the next item in the list.
+		 * Note that IOP_PUSH may unlocked and reacquire the AIL lock.
+		 * We rely on the AIL cursor implementation to handle be able
+		 * to deal with the dropped lock.
 		 */
-		lock_result = IOP_TRYLOCK(lip);
-		spin_unlock(&ailp->xa_lock);
+		lock_result = IOP_PUSH(lip, &ailp->xa_buf_list);
 		switch (lock_result) {
 		case XFS_ITEM_SUCCESS:
 			XFS_STATS_INC(xs_push_ail_success);
 			trace_xfs_ail_push(lip);
 
-			IOP_PUSH(lip);
 			ailp->xa_last_pushed_lsn = lsn;
 			break;
+		case XFS_ITEM_FLUSHING:
+			/*
+			 * The item or its backing buffer is already beeing
+			 * flushed.  The typical reason for that is that an
+			 * inode buffer is locked because we already pushed
+			 * the updates to it as part of inode clustering.
+			 *
+			 * We do not want to to stop flushing just because
+			 * lots of items are already beeing flushed, but we
+			 * need to re-try the flushing relatively soon if
+			 * most of the AIL is beeing flushed.
+			 */
+			XFS_STATS_INC(xs_push_ail_flushing);
+			trace_xfs_ail_flushing(lip);
 
-		case XFS_ITEM_PUSHBUF:
-			XFS_STATS_INC(xs_push_ail_pushbuf);
-			trace_xfs_ail_pushbuf(lip);
-
-			if (!IOP_PUSHBUF(lip)) {
-				trace_xfs_ail_pushbuf_pinned(lip);
-				stuck++;
-				ailp->xa_log_flush++;
-			} else {
-				ailp->xa_last_pushed_lsn = lsn;
-			}
-			push_xfsbufd = 1;
+			flushing++;
+			ailp->xa_last_pushed_lsn = lsn;
 			break;
-
 		case XFS_ITEM_PINNED:
 			XFS_STATS_INC(xs_push_ail_pinned);
 			trace_xfs_ail_pinned(lip);
@@ -461,23 +448,22 @@ xfsaild_push(
 			stuck++;
 			ailp->xa_log_flush++;
 			break;
-
 		case XFS_ITEM_LOCKED:
 			XFS_STATS_INC(xs_push_ail_locked);
 			trace_xfs_ail_locked(lip);
+
 			stuck++;
 			break;
-
 		default:
 			ASSERT(0);
 			break;
 		}
 
-		spin_lock(&ailp->xa_lock);
 		count++;
 
 		/*
 		 * Are there too many items we can't do anything with?
+		 *
 		 * If we we are skipping too many items because we can't flush
 		 * them or they are already being flushed, we back off and
 		 * given them time to complete whatever operation is being
@@ -499,42 +485,36 @@ xfsaild_push(
 	xfs_trans_ail_cursor_done(ailp, &cur);
 	spin_unlock(&ailp->xa_lock);
 
-	if (push_xfsbufd) {
-		/* we've got delayed write buffers to flush */
-		wake_up_process(mp->m_ddev_targp->bt_task);
-	}
+	if (xfs_buf_delwri_submit_nowait(&ailp->xa_buf_list))
+		ailp->xa_log_flush++;
 
-	/* assume we have more work to do in a short while */
+	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
 out_done:
-	if (!count) {
-		/* We're past our target or empty, so idle */
-		ailp->xa_last_pushed_lsn = 0;
-		ailp->xa_log_flush = 0;
-
-		tout = 50;
-	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
 		/*
-		 * We reached the target so wait a bit longer for I/O to
-		 * complete and remove pushed items from the AIL before we
-		 * start the next scan from the start of the AIL.
+		 * We reached the target or the AIL is empty, so wait a bit
+		 * longer for I/O to complete and remove pushed items from the
+		 * AIL before we start the next scan from the start of the AIL.
 		 */
 		tout = 50;
 		ailp->xa_last_pushed_lsn = 0;
-	} else if ((stuck * 100) / count > 90) {
+	} else if (((stuck + flushing) * 100) / count > 90) {
 		/*
-		 * Either there is a lot of contention on the AIL or we
-		 * are stuck due to operations in progress. "Stuck" in this
-		 * case is defined as >90% of the items we tried to push
-		 * were stuck.
+		 * Either there is a lot of contention on the AIL or we are
+		 * stuck due to operations in progress. "Stuck" in this case
+		 * is defined as >90% of the items we tried to push were stuck.
 		 *
 		 * Backoff a bit more to allow some I/O to complete before
-		 * restarting from the start of the AIL. This prevents us
-		 * from spinning on the same items, and if they are pinned will
-		 * all the restart to issue a log force to unpin the stuck
-		 * items.
+		 * restarting from the start of the AIL. This prevents us from
+		 * spinning on the same items, and if they are pinned will all
+		 * the restart to issue a log force to unpin the stuck items.
 		 */
 		tout = 20;
 		ailp->xa_last_pushed_lsn = 0;
+	} else {
+		/*
+		 * Assume we have more work to do in a short while.
+		 */
+		tout = 10;
 	}
 
 	return tout;
@@ -547,6 +527,8 @@ xfsaild(
 	struct xfs_ail	*ailp = data;
 	long		tout = 0;	/* milliseconds */
 
+	current->flags |= PF_MEMALLOC;
+
 	while (!kthread_should_stop()) {
 		if (tout && tout <= 20)
 			__set_current_state(TASK_KILLABLE);
@@ -806,6 +788,7 @@ xfs_trans_ail_init(
 	INIT_LIST_HEAD(&ailp->xa_ail);
 	INIT_LIST_HEAD(&ailp->xa_cursors);
 	spin_lock_init(&ailp->xa_lock);
+	INIT_LIST_HEAD(&ailp->xa_buf_list);
 	init_waitqueue_head(&ailp->xa_empty);
 	atomic_set(&ailp->xa_wait_empty, 0);
 
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2012-03-25 16:46:11.341223159 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2012-03-25 16:46:11.991223170 +0200
@@ -165,14 +165,6 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 			XFS_BUF_DONE(bp);
 		}
 
-		/*
-		 * If the buffer is stale then it was binval'ed
-		 * since last read.  This doesn't matter since the
-		 * caller isn't allowed to use the data anyway.
-		 */
-		else if (XFS_BUF_ISSTALE(bp))
-			ASSERT(!XFS_BUF_ISDELAYWRITE(bp));
-
 		ASSERT(bp->b_transp == tp);
 		bip = bp->b_fspriv;
 		ASSERT(bip != NULL);
@@ -418,19 +410,6 @@ xfs_trans_read_buf(
 	return 0;
 
 shutdown_abort:
-	/*
-	 * the theory here is that buffer is good but we're
-	 * bailing out because the filesystem is being forcibly
-	 * shut down.  So we should leave the b_flags alone since
-	 * the buffer's not staled and just get out.
-	 */
-#if defined(DEBUG)
-	if (XFS_BUF_ISSTALE(bp) && XFS_BUF_ISDELAYWRITE(bp))
-		xfs_notice(mp, "about to pop assert, bp == 0x%p", bp);
-#endif
-	ASSERT((bp->b_flags & (XBF_STALE|XBF_DELWRI)) !=
-				     (XBF_STALE|XBF_DELWRI));
-
 	trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
 	xfs_buf_relse(bp);
 	*bpp = NULL;
@@ -649,22 +628,33 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 
 
 /*
- * This called to invalidate a buffer that is being used within
- * a transaction.  Typically this is because the blocks in the
- * buffer are being freed, so we need to prevent it from being
- * written out when we're done.  Allowing it to be written again
- * might overwrite data in the free blocks if they are reallocated
- * to a file.
- *
- * We prevent the buffer from being written out by clearing the
- * B_DELWRI flag.  We can't always
- * get rid of the buf log item at this point, though, because
- * the buffer may still be pinned by another transaction.  If that
- * is the case, then we'll wait until the buffer is committed to
- * disk for the last time (we can tell by the ref count) and
- * free it in xfs_buf_item_unpin().  Until it is cleaned up we
- * will keep the buffer locked so that the buffer and buf log item
- * are not reused.
+ * Invalidate a buffer that is being used within a transaction.
+ *
+ * Typically this is because the blocks in the buffer are being freed, so we
+ * need to prevent it from being written out when we're done.  Allowing it
+ * to be written again might overwrite data in the free blocks if they are
+ * reallocated to a file.
+ *
+ * We prevent the buffer from being written out by marking it stale.  We can't
+ * get rid of the buf log item at this point because the buffer may still be
+ * pinned by another transaction.  If that is the case, then we'll wait until
+ * the buffer is committed to disk for the last time (we can tell by the ref
+ * count) and free it in xfs_buf_item_unpin().  Until that happens we will
+ * keep the buffer locked so that the buffer and buf log item are not reused.
+ *
+ * We also set the XFS_BLF_CANCEL flag in the buf log format structure and log
+ * the buf item.  This will be used at recovery time to determine that copies
+ * of the buffer in the log before this should not be replayed.
+ *
+ * We mark the item descriptor and the transaction dirty so that we'll hold
+ * the buffer until after the commit.
+ *
+ * Since we're invalidating the buffer, we also clear the state about which
+ * parts of the buffer have been logged.  We also clear the flag indicating
+ * that this is an inode buffer since the data in the buffer will no longer
+ * be valid.
+ *
+ * We set the stale bit in the buffer as well since we're getting rid of it.
  */
 void
 xfs_trans_binval(
@@ -684,7 +674,6 @@ xfs_trans_binval(
 		 * If the buffer is already invalidated, then
 		 * just return.
 		 */
-		ASSERT(!(XFS_BUF_ISDELAYWRITE(bp)));
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		ASSERT(!(bip->bli_flags & (XFS_BLI_LOGGED | XFS_BLI_DIRTY)));
 		ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_INODE_BUF));
@@ -694,27 +683,8 @@ xfs_trans_binval(
 		return;
 	}
 
-	/*
-	 * Clear the dirty bit in the buffer and set the STALE flag
-	 * in the buf log item.  The STALE flag will be used in
-	 * xfs_buf_item_unpin() to determine if it should clean up
-	 * when the last reference to the buf item is given up.
-	 * We set the XFS_BLF_CANCEL flag in the buf log format structure
-	 * and log the buf item.  This will be used at recovery time
-	 * to determine that copies of the buffer in the log before
-	 * this should not be replayed.
-	 * We mark the item descriptor and the transaction dirty so
-	 * that we'll hold the buffer until after the commit.
-	 *
-	 * Since we're invalidating the buffer, we also clear the state
-	 * about which parts of the buffer have been logged.  We also
-	 * clear the flag indicating that this is an inode buffer since
-	 * the data in the buffer will no longer be valid.
-	 *
-	 * We set the stale bit in the buffer as well since we're getting
-	 * rid of it.
-	 */
 	xfs_buf_stale(bp);
+
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~(XFS_BLI_INODE_BUF | XFS_BLI_LOGGED | XFS_BLI_DIRTY);
 	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-03-25 16:46:10.211223137 +0200
+++ xfs/fs/xfs/xfs_qm.c	2012-03-25 17:09:36.364582545 +0200
@@ -65,7 +65,8 @@ STATIC int
 xfs_qm_dquot_walk(
 	struct xfs_mount	*mp,
 	int			type,
-	int			(*execute)(struct xfs_dquot *dqp))
+	int			(*execute)(struct xfs_dquot *dqp, void *data),
+	void			*data)
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	struct radix_tree_root	*tree = XFS_DQUOT_TREE(qi, type);
@@ -97,7 +98,7 @@ restart:
 
 			next_index = be32_to_cpu(dqp->q_core.d_id) + 1;
 
-			error = execute(batch[i]);
+			error = execute(batch[i], data);
 			if (error == EAGAIN) {
 				skipped++;
 				continue;
@@ -129,7 +130,8 @@ restart:
  */
 STATIC int
 xfs_qm_dqpurge(
-	struct xfs_dquot	*dqp)
+	struct xfs_dquot	*dqp,
+	void			*data)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
@@ -153,21 +155,7 @@ xfs_qm_dqpurge(
 
 	dqp->dq_flags |= XFS_DQ_FREEING;
 
-	/*
-	 * If we're turning off quotas, we have to make sure that, for
-	 * example, we don't delete quota disk blocks while dquots are
-	 * in the process of getting written to those disk blocks.
-	 * This dquot might well be on AIL, and we can't leave it there
-	 * if we're turning off quotas. Basically, we need this flush
-	 * lock, and are willing to block on it.
-	 */
-	if (!xfs_dqflock_nowait(dqp)) {
-		/*
-		 * Block on the flush lock after nudging dquot buffer,
-		 * if it is incore.
-		 */
-		xfs_dqflock_pushbuf_wait(dqp);
-	}
+	xfs_dqflock(dqp);
 
 	/*
 	 * If we are turning this type of quotas off, we don't care
@@ -183,7 +171,7 @@ xfs_qm_dqpurge(
 		 * to purge this dquot anyway, so we go ahead regardless.
 		 */
 		error = xfs_qm_dqflush(dqp, &bp);
-		if (error)
+		if (error) {
 			xfs_warn(mp, "%s: dquot %p flush failed",
 				__func__, dqp);
 		} else {
@@ -231,11 +219,11 @@ xfs_qm_dqpurge_all(
 	uint			flags)
 {
 	if (flags & XFS_QMOPT_UQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge);
+		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
 	if (flags & XFS_QMOPT_GQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge);
+		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
 	if (flags & XFS_QMOPT_PQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge);
+		xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge, NULL);
 }
 
 /*
@@ -860,15 +848,16 @@ xfs_qm_reset_dqcounts(
 
 STATIC int
 xfs_qm_dqiter_bufs(
-	xfs_mount_t	*mp,
-	xfs_dqid_t	firstid,
-	xfs_fsblock_t	bno,
-	xfs_filblks_t	blkcnt,
-	uint		flags)
+	struct xfs_mount	*mp,
+	xfs_dqid_t		firstid,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		blkcnt,
+	uint			flags,
+	struct list_head	*buffer_list)
 {
-	xfs_buf_t	*bp;
-	int		error;
-	int		type;
+	struct xfs_buf		*bp;
+	int			error;
+	int			type;
 
 	ASSERT(blkcnt > 0);
 	type = flags & XFS_QMOPT_UQUOTA ? XFS_DQ_USER :
@@ -892,7 +881,7 @@ xfs_qm_dqiter_bufs(
 			break;
 
 		xfs_qm_reset_dqcounts(mp, bp, firstid, type);
-		xfs_buf_delwri_queue(bp);
+		xfs_buf_delwri_queue(bp, buffer_list);
 		xfs_buf_relse(bp);
 		/*
 		 * goto the next block.
@@ -900,6 +889,7 @@ xfs_qm_dqiter_bufs(
 		bno++;
 		firstid += mp->m_quotainfo->qi_dqperchunk;
 	}
+
 	return error;
 }
 
@@ -909,11 +899,12 @@ xfs_qm_dqiter_bufs(
  */
 STATIC int
 xfs_qm_dqiterate(
-	xfs_mount_t	*mp,
-	xfs_inode_t	*qip,
-	uint		flags)
+	struct xfs_mount	*mp,
+	struct xfs_inode	*qip,
+	uint			flags,
+	struct list_head	*buffer_list)
 {
-	xfs_bmbt_irec_t		*map;
+	struct xfs_bmbt_irec	*map;
 	int			i, nmaps;	/* number of map entries */
 	int			error;		/* return value */
 	xfs_fileoff_t		lblkno;
@@ -980,21 +971,17 @@ xfs_qm_dqiterate(
 			 * Iterate thru all the blks in the extent and
 			 * reset the counters of all the dquots inside them.
 			 */
-			if ((error = xfs_qm_dqiter_bufs(mp,
-						       firstid,
-						       map[i].br_startblock,
-						       map[i].br_blockcount,
-						       flags))) {
-				break;
-			}
+			error = xfs_qm_dqiter_bufs(mp, firstid,
+						   map[i].br_startblock,
+						   map[i].br_blockcount,
+						   flags, buffer_list);
+			if (error)
+				goto out;
 		}
-
-		if (error)
-			break;
 	} while (nmaps > 0);
 
+out:
 	kmem_free(map);
-
 	return error;
 }
 
@@ -1187,8 +1174,10 @@ error0:
 
 STATIC int
 xfs_qm_flush_one(
-	struct xfs_dquot	*dqp)
+	struct xfs_dquot	*dqp,
+	void			*data)
 {
+	struct list_head	*buffer_list = data;
 	struct xfs_buf		*bp = NULL;
 	int			error = 0;
 
@@ -1198,14 +1187,12 @@ xfs_qm_flush_one(
 	if (!XFS_DQ_IS_DIRTY(dqp))
 		goto out_unlock;
 
-	if (!xfs_dqflock_nowait(dqp))
-		xfs_dqflock_pushbuf_wait(dqp);
-
+	xfs_dqflock(dqp);
 	error = xfs_qm_dqflush(dqp, &bp);
 	if (error)
 		goto out_unlock;
 
-	xfs_buf_delwri_queue(bp);
+	xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
 out_unlock:
 	xfs_dqunlock(dqp);
@@ -1225,6 +1212,7 @@ xfs_qm_quotacheck(
 	size_t		structsz;
 	xfs_inode_t	*uip, *gip;
 	uint		flags;
+	LIST_HEAD	(buffer_list);
 
 	count = INT_MAX;
 	structsz = 1;
@@ -1243,7 +1231,8 @@ xfs_qm_quotacheck(
 	 */
 	uip = mp->m_quotainfo->qi_uquotaip;
 	if (uip) {
-		error = xfs_qm_dqiterate(mp, uip, XFS_QMOPT_UQUOTA);
+		error = xfs_qm_dqiterate(mp, uip, XFS_QMOPT_UQUOTA,
+					 &buffer_list);
 		if (error)
 			goto error_return;
 		flags |= XFS_UQUOTA_CHKD;
@@ -1252,7 +1241,8 @@ xfs_qm_quotacheck(
 	gip = mp->m_quotainfo->qi_gquotaip;
 	if (gip) {
 		error = xfs_qm_dqiterate(mp, gip, XFS_IS_GQUOTA_ON(mp) ?
-					XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA);
+					 XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA,
+					 &buffer_list);
 		if (error)
 			goto error_return;
 		flags |= XFS_OQUOTA_CHKD;
@@ -1275,19 +1265,27 @@ xfs_qm_quotacheck(
 	 * We've made all the changes that we need to make incore.  Flush them
 	 * down to disk buffers if everything was updated successfully.
 	 */
-	if (XFS_IS_UQUOTA_ON(mp))
-		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_flush_one);
+	if (XFS_IS_UQUOTA_ON(mp)) {
+		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_flush_one,
+					  &buffer_list);
+	}
 	if (XFS_IS_GQUOTA_ON(mp)) {
-		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_flush_one);
+		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_flush_one,
+					   &buffer_list);
 		if (!error)
 			error = error2;
 	}
 	if (XFS_IS_PQUOTA_ON(mp)) {
-		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_flush_one);
+		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_flush_one,
+					   &buffer_list);
 		if (!error)
 			error = error2;
 	}
 
+	error2 = xfs_buf_delwri_submit(&buffer_list);
+	if (!error)
+		error = error2;
+
 	/*
 	 * We can get this error if we couldn't do a dquot allocation inside
 	 * xfs_qm_dqusage_adjust (via bulkstat). We don't care about the
@@ -1301,15 +1299,6 @@ xfs_qm_quotacheck(
 	}
 
 	/*
-	 * We didn't log anything, because if we crashed, we'll have to
-	 * start the quotacheck from scratch anyway. However, we must make
-	 * sure that our dquot changes are secure before we put the
-	 * quotacheck'd stamp on the superblock. So, here we do a synchronous
-	 * flush.
-	 */
-	xfs_flush_buftarg(mp->m_ddev_targp, 1);
-
-	/*
 	 * If one type of quotas is off, then it will lose its
 	 * quotachecked status, since we won't be doing accounting for
 	 * that type anymore.
@@ -1318,6 +1307,13 @@ xfs_qm_quotacheck(
 	mp->m_qflags |= flags;
 
  error_return:
+	while (!list_empty(&buffer_list)) {
+		struct xfs_buf *bp =
+			list_first_entry(&buffer_list, struct xfs_buf, b_list);
+		list_del_init(&bp->b_list);
+		xfs_buf_relse(bp);
+	}
+
 	if (error) {
 		xfs_warn(mp,
 	"Quotacheck: Unsuccessful (Error %d): Disabling quotas.",
@@ -1434,6 +1430,7 @@ xfs_qm_dqfree_one(
 STATIC void
 xfs_qm_dqreclaim_one(
 	struct xfs_dquot	*dqp,
+	struct list_head	*buffer_list,
 	struct list_head	*dispose_list)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
@@ -1466,21 +1463,11 @@ xfs_qm_dqreclaim_one(
 	if (!xfs_dqflock_nowait(dqp))
 		goto out_busy;
 
-	/*
-	 * We have the flush lock so we know that this is not in the
-	 * process of being flushed. So, if this is dirty, flush it
-	 * DELWRI so that we don't get a freelist infested with
-	 * dirty dquots.
-	 */
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		struct xfs_buf	*bp = NULL;
 
 		trace_xfs_dqreclaim_dirty(dqp);
 
-		/*
-		 * We flush it delayed write, so don't bother releasing the
-		 * freelist lock.
-		 */
 		error = xfs_qm_dqflush(dqp, &bp);
 		if (error) {
 			xfs_warn(mp, "%s: dquot %p flush failed",
@@ -1488,7 +1475,7 @@ xfs_qm_dqreclaim_one(
 			goto out_busy;
 		}
 
-		xfs_buf_delwri_queue(bp);
+		xfs_buf_delwri_queue(bp, buffer_list);
 		xfs_buf_relse(bp);
 		/*
 		 * Give the dquot another try on the freelist, as the
@@ -1533,8 +1520,10 @@ xfs_qm_shake(
 	struct xfs_quotainfo	*qi =
 		container_of(shrink, struct xfs_quotainfo, qi_shrinker);
 	int			nr_to_scan = sc->nr_to_scan;
+	LIST_HEAD		(buffer_list);
 	LIST_HEAD		(dispose_list);
 	struct xfs_dquot	*dqp;
+	int			error;
 
 	if ((sc->gfp_mask & (__GFP_FS|__GFP_WAIT)) != (__GFP_FS|__GFP_WAIT))
 		return 0;
@@ -1547,15 +1536,20 @@ xfs_qm_shake(
 			break;
 		dqp = list_first_entry(&qi->qi_lru_list, struct xfs_dquot,
 				       q_lru);
-		xfs_qm_dqreclaim_one(dqp, &dispose_list);
+		xfs_qm_dqreclaim_one(dqp, &buffer_list, &dispose_list);
 	}
 	mutex_unlock(&qi->qi_lru_lock);
 
+	error = xfs_buf_delwri_submit(&buffer_list);
+	if (error)
+		xfs_warn(NULL, "%s: dquot reclaim failed", __func__);
+
 	while (!list_empty(&dispose_list)) {
 		dqp = list_first_entry(&dispose_list, struct xfs_dquot, q_lru);
 		list_del_init(&dqp->q_lru);
 		xfs_qm_dqfree_one(dqp);
 	}
+
 out:
 	return (qi->qi_lru_count / 100) * sysctl_vfs_cache_pressure;
 }
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2012-03-25 16:41:21.647884454 +0200
+++ xfs/fs/xfs/xfs_inode.c	2012-03-25 17:11:20.831251148 +0200
@@ -2347,11 +2347,11 @@ cluster_corrupt_out:
 	 */
 	rcu_read_unlock();
 	/*
-	 * Clean up the buffer.  If it was B_DELWRI, just release it --
+	 * Clean up the buffer.  If it was delwri, just release it --
 	 * brelse can handle it with no problems.  If not, shut down the
 	 * filesystem before releasing the buffer.
 	 */
-	bufwasdelwri = XFS_BUF_ISDELAYWRITE(bp);
+	bufwasdelwri = (bp->b_flags & _XBF_DELWRI_Q);
 	if (bufwasdelwri)
 		xfs_buf_relse(bp);
 
@@ -2685,27 +2685,6 @@ corrupt_out:
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
-void
-xfs_promote_inode(
-	struct xfs_inode	*ip)
-{
-	struct xfs_buf		*bp;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-
-	bp = xfs_incore(ip->i_mount->m_ddev_targp, ip->i_imap.im_blkno,
-			ip->i_imap.im_len, XBF_TRYLOCK);
-	if (!bp)
-		return;
-
-	if (XFS_BUF_ISDELAYWRITE(bp)) {
-		xfs_buf_delwri_promote(bp);
-		wake_up_process(ip->i_mount->m_ddev_targp->bt_task);
-	}
-
-	xfs_buf_relse(bp);
-}
-
 /*
  * Return a pointer to the extent record at file index idx.
  */
Index: xfs/fs/xfs/xfs_trans_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_priv.h	2012-03-25 16:41:20.901217773 +0200
+++ xfs/fs/xfs/xfs_trans_priv.h	2012-03-25 16:46:11.994556504 +0200
@@ -71,6 +71,7 @@ struct xfs_ail {
 	spinlock_t		xa_lock;
 	xfs_lsn_t		xa_last_pushed_lsn;
 	int			xa_log_flush;
+	struct list_head	xa_buf_list;
 	wait_queue_head_t	xa_empty;
 	atomic_t		xa_wait_empty;
 };
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2012-03-25 16:41:00.284550724 +0200
+++ xfs/fs/xfs/xfs_super.c	2012-03-25 16:46:11.994556504 +0200
@@ -967,15 +967,7 @@ xfs_fs_put_super(
 
 	xfs_syncd_stop(mp);
 
-	/*
-	 * Blow away any referenced inode in the filestreams cache.
-	 * This can and will cause log traffic as inodes go inactive
-	 * here.
-	 */
 	xfs_filestream_unmount(mp);
-
-	xfs_flush_buftarg(mp->m_ddev_targp, 1);
-
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
@@ -1391,15 +1383,7 @@ out_destroy_workqueues:
  out_syncd_stop:
 	xfs_syncd_stop(mp);
  out_unmount:
-	/*
-	 * Blow away any referenced inode in the filestreams cache.
-	 * This can and will cause log traffic as inodes go inactive
-	 * here.
-	 */
 	xfs_filestream_unmount(mp);
-
-	xfs_flush_buftarg(mp->m_ddev_targp, 1);
-
 	xfs_unmountfs(mp);
 	goto out_free_sb;
 }
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2012-03-25 16:45:50.037889431 +0200
+++ xfs/fs/xfs/xfs_sync.c	2012-03-25 17:11:20.847917816 +0200
@@ -313,17 +313,10 @@ xfs_quiesce_data(
 	/* write superblock and hoover up shutdown errors */
 	error = xfs_sync_fsdata(mp);
 
-	/* make sure all delwri buffers are written out */
-	xfs_flush_buftarg(mp->m_ddev_targp, 1);
-
 	/* mark the log as covered if needed */
 	if (xfs_log_need_covered(mp))
 		error2 = xfs_fs_log_dummy(mp);
 
-	/* flush data-only devices */
-	if (mp->m_rtdev_targp)
-		xfs_flush_buftarg(mp->m_rtdev_targp, 1);
-
 	return error ? error : error2;
 }
 
@@ -681,17 +674,6 @@ restart:
 	if (!xfs_iflock_nowait(ip)) {
 		if (!(sync_mode & SYNC_WAIT))
 			goto out;
-
-		/*
-		 * If we only have a single dirty inode in a cluster there is
-		 * a fair chance that the AIL push may have pushed it into
-		 * the buffer, but xfsbufd won't touch it until 30 seconds
-		 * from now, and thus we will lock up here.
-		 *
-		 * Promote the inode buffer to the front of the delwri list
-		 * and wake up xfsbufd now.
-		 */
-		xfs_promote_inode(ip);
 		xfs_iflock(ip);
 	}
 
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2012-03-25 16:46:10.207889804 +0200
+++ xfs/fs/xfs/xfs_dquot.h	2012-03-25 16:46:11.997889838 +0200
@@ -152,7 +152,6 @@ extern int		xfs_qm_dqget(xfs_mount_t *,
 extern void		xfs_qm_dqput(xfs_dquot_t *);
 
 extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
-extern void		xfs_dqflock_pushbuf_wait(struct xfs_dquot *dqp);
 
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2012-03-25 16:41:00.317884058 +0200
+++ xfs/fs/xfs/xfs_buf.h	2012-03-25 16:46:11.997889838 +0200
@@ -50,8 +50,7 @@ typedef enum {
 #define XBF_MAPPED	(1 << 3) /* buffer mapped (b_addr valid) */
 #define XBF_ASYNC	(1 << 4) /* initiator will not wait for completion */
 #define XBF_DONE	(1 << 5) /* all pages in the buffer uptodate */
-#define XBF_DELWRI	(1 << 6) /* buffer has dirty pages */
-#define XBF_STALE	(1 << 7) /* buffer has been staled, do not find it */
+#define XBF_STALE	(1 << 6) /* buffer has been staled, do not find it */
 
 /* I/O hints for the BIO layer */
 #define XBF_SYNCIO	(1 << 10)/* treat this buffer as synchronous I/O */
@@ -66,7 +65,7 @@ typedef enum {
 /* flags used only internally */
 #define _XBF_PAGES	(1 << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	(1 << 21)/* backed by heap memory */
-#define _XBF_DELWRI_Q	(1 << 22)/* buffer on delwri queue */
+#define _XBF_DELWRI_Q	(1 << 22)/* buffer on a delwri queue */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -77,7 +76,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_MAPPED,		"MAPPED" }, \
 	{ XBF_ASYNC,		"ASYNC" }, \
 	{ XBF_DONE,		"DONE" }, \
-	{ XBF_DELWRI,		"DELWRI" }, \
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_SYNCIO,		"SYNCIO" }, \
 	{ XBF_FUA,		"FUA" }, \
@@ -89,10 +87,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
 
-typedef enum {
-	XBT_FORCE_FLUSH = 0,
-} xfs_buftarg_flags_t;
-
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;
@@ -102,12 +96,6 @@ typedef struct xfs_buftarg {
 	unsigned int		bt_sshift;
 	size_t			bt_smask;
 
-	/* per device delwri queue */
-	struct task_struct	*bt_task;
-	struct list_head	bt_delwri_queue;
-	spinlock_t		bt_delwri_lock;
-	unsigned long		bt_flags;
-
 	/* LRU control structures */
 	struct shrinker		bt_shrinker;
 	struct list_head	bt_lru;
@@ -151,7 +139,6 @@ typedef struct xfs_buf {
 	struct xfs_trans	*b_transp;
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
-	unsigned long		b_queuetime;	/* time buffer was queued */
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	unsigned int		b_page_count;	/* size of page array */
@@ -221,24 +208,22 @@ static inline int xfs_buf_geterror(xfs_b
 extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
 
 /* Delayed Write Buffer Routines */
-extern void xfs_buf_delwri_queue(struct xfs_buf *);
-extern void xfs_buf_delwri_dequeue(struct xfs_buf *);
-extern void xfs_buf_delwri_promote(struct xfs_buf *);
+extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
+extern int xfs_buf_delwri_submit(struct list_head *);
+extern int xfs_buf_delwri_submit_nowait(struct list_head *);
 
 /* Buffer Daemon Setup Routines */
 extern int xfs_buf_init(void);
 extern void xfs_buf_terminate(void);
 
 #define XFS_BUF_ZEROFLAGS(bp) \
-	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI| \
+	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC| \
 			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH))
 
 void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
 #define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XBF_STALE)
 
-#define XFS_BUF_ISDELAYWRITE(bp)	((bp)->b_flags & XBF_DELWRI)
-
 #define XFS_BUF_DONE(bp)	((bp)->b_flags |= XBF_DONE)
 #define XFS_BUF_UNDONE(bp)	((bp)->b_flags &= ~XBF_DONE)
 #define XFS_BUF_ISDONE(bp)	((bp)->b_flags & XBF_DONE)
@@ -288,7 +273,6 @@ extern xfs_buftarg_t *xfs_alloc_buftarg(
 extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
-extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
 
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2012-03-25 16:41:21.647884454 +0200
+++ xfs/fs/xfs/xfs_inode.h	2012-03-25 16:46:11.997889838 +0200
@@ -529,7 +529,6 @@ int		xfs_iunlink(struct xfs_trans *, xfs
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 void		xfs_iunpin_wait(xfs_inode_t *);
 int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
-void		xfs_promote_inode(struct xfs_inode *);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-03-25 16:46:10.207889804 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2012-03-25 17:09:36.354582544 +0200
@@ -1005,39 +1005,6 @@ xfs_dqlock2(
 	}
 }
 
-/*
- * Give the buffer a little push if it is incore and
- * wait on the flush lock.
- */
-void
-xfs_dqflock_pushbuf_wait(
-	xfs_dquot_t	*dqp)
-{
-	xfs_mount_t	*mp = dqp->q_mount;
-	xfs_buf_t	*bp;
-
-	/*
-	 * Check to see if the dquot has been flushed delayed
-	 * write.  If so, grab its buffer and send it
-	 * out immediately.  We'll be able to acquire
-	 * the flush lock when the I/O completes.
-	 */
-	bp = xfs_incore(mp->m_ddev_targp, dqp->q_blkno,
-			mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK);
-	if (!bp)
-		goto out_lock;
-
-	if (XFS_BUF_ISDELAYWRITE(bp)) {
-		if (xfs_buf_ispinned(bp))
-			xfs_log_force(mp, 0);
-		xfs_buf_delwri_promote(bp);
-		wake_up_process(bp->b_target->bt_task);
-	}
-	xfs_buf_relse(bp);
-out_lock:
-	xfs_dqflock(dqp);
-}
-
 int __init
 xfs_qm_init(void)
 {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
