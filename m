Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3ngK145649 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8DD21CC702E
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	5HcF1VWpyTWNhLAQ for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHr-0003Cb-5A
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:43 +0000
Message-Id: <20111028100343.113731238@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:55:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 42/45] xfs: on-stack delayed write buffer lists
References: <20111028095423.796574703@bombadil.infradead.org>
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
	This should switch to some form of synchronous writeout, but that
	will require more surgery to the quota code.

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
 fs/xfs/xfs_buf.c          |  340 ++++++++++++++++------------------------------
 fs/xfs/xfs_buf.h          |   29 ---
 fs/xfs/xfs_buf_item.c     |   92 +++---------
 fs/xfs/xfs_dquot.c        |   50 ------
 fs/xfs/xfs_dquot.h        |    1 
 fs/xfs/xfs_dquot_item.c   |  167 ++++++----------------
 fs/xfs/xfs_extfree_item.c |   36 +---
 fs/xfs/xfs_inode.c        |    4 
 fs/xfs/xfs_inode_item.c   |  156 +++++----------------
 fs/xfs/xfs_log_recover.c  |   46 +++---
 fs/xfs/xfs_qm.c           |   61 +++-----
 fs/xfs/xfs_super.c        |   16 --
 fs/xfs/xfs_sync.c         |    7 
 fs/xfs/xfs_trace.h        |    7 
 fs/xfs/xfs_trans.h        |   18 --
 fs/xfs/xfs_trans_ail.c    |  107 ++++++--------
 fs/xfs/xfs_trans_buf.c    |   86 +++--------
 fs/xfs/xfs_trans_priv.h   |    1 
 18 files changed, 399 insertions(+), 825 deletions(-)

Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-10-27 22:39:31.754174668 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2011-10-27 22:40:16.206172914 +0200
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
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-27 22:39:57.490177027 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-10-27 22:40:16.210189457 +0200
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
+ * any internal synchronization.  It is expected that the lists are
+ * thread-local in the callers.
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
@@ -1683,103 +1588,106 @@ xfs_buf_cmp(
 	return 0;
 }
 
-STATIC int
-xfsbufd(
-	void		*data)
-{
-	xfs_buftarg_t   *target = (xfs_buftarg_t *)data;
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
 
-	current->flags |= PF_MEMALLOC;
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
 
-	set_freezable();
+		list_move_tail(&bp->b_list, submit_list);
+		trace_xfs_buf_delwri_split(bp, _RET_IP_);
+	}
 
-	do {
-		long	age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
-		long	tout = xfs_buf_timer_centisecs * msecs_to_jiffies(10);
-		struct list_head tmp;
-		struct blk_plug plug;
+	list_sort(NULL, submit_list, xfs_buf_cmp);
 
-		if (unlikely(freezing(current))) {
-			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
-			refrigerator();
-		} else {
-			clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
-		}
+	blk_start_plug(&plug);
+	list_for_each_entry_safe(bp, n, submit_list, b_list) {
+		bp->b_flags &= ~_XBF_DELWRI_Q;
+		bp->b_flags |= XBF_WRITE;
 
-		/* sleep for a long time if there is nothing to do. */
-		if (list_empty(&target->bt_delwri_queue))
-			tout = MAX_SCHEDULE_TIMEOUT;
-		schedule_timeout_interruptible(tout);
-
-		xfs_buf_delwri_split(target, &tmp, age);
-		list_sort(NULL, &tmp, xfs_buf_cmp);
-
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
+ * Write out  buffer list asynchronously.
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
+ * Write out  buffer list synchronously.
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
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-10-27 22:39:31.778172132 +0200
+++ xfs/fs/xfs/xfs_buf.h	2011-10-27 22:40:16.210189457 +0200
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
@@ -89,11 +87,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
 
-typedef enum {
-	XBT_FORCE_SLEEP = 0,
-	XBT_FORCE_FLUSH = 1,
-} xfs_buftarg_flags_t;
-
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
 	struct block_device	*bt_bdev;
@@ -103,12 +96,6 @@ typedef struct xfs_buftarg {
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
@@ -152,7 +139,6 @@ typedef struct xfs_buf {
 	struct xfs_trans	*b_transp;
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
-	unsigned long		b_queuetime;	/* time buffer was queued */
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	unsigned int		b_page_count;	/* size of page array */
@@ -222,24 +208,22 @@ static inline int xfs_buf_geterror(xfs_b
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
@@ -289,7 +273,6 @@ extern xfs_buftarg_t *xfs_alloc_buftarg(
 extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
-extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
 
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-10-27 22:40:15.630172342 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2011-10-27 22:40:16.210189457 +0200
@@ -418,7 +418,6 @@ xfs_buf_item_unpin(
 	if (freed && stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
 		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(!(XFS_BUF_ISDELAYWRITE(bp)));
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
 
@@ -470,33 +469,33 @@ xfs_buf_item_unpin(
 }
 
 /*
- * This is called to attempt to lock the buffer associated with this
- * buf log item.  Don't sleep on the buffer lock.  If we can't get
- * the lock right away, return 0.  If we can get the lock, take a
- * reference to the buffer. If this is a delayed write buffer that
- * needs AIL help to be written back, invoke the pushbuf routine
- * rather than the normal success path.
+ * This is called to attempt to flush the buffer associated with this log item.
+ *
+ * We try to do the whole thing non-blocking, and tell the caller to try again
+ * later if the item is pinned or locked.
  */
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
@@ -609,48 +608,6 @@ xfs_buf_item_committed(
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
@@ -666,11 +623,9 @@ static const struct xfs_item_ops xfs_buf
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
 
@@ -992,17 +947,24 @@ xfs_buf_iodone_callbacks(
 	 * During sync or umount we'll write all pending buffers again
 	 * synchronous, which will catch these errors if they keep hanging
 	 * around.
+	 *
+	 * XXX(hch): that won't nessecarily help us to pick up the errors
+	 * with the current code..
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
--- xfs.orig/fs/xfs/xfs_dquot_item.c	2011-10-27 22:40:14.813173372 +0200
+++ xfs/fs/xfs/xfs_dquot_item.c	2011-10-27 22:40:16.218216695 +0200
@@ -109,44 +109,6 @@ xfs_qm_dquot_logitem_unpin(
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
-	} else if (bp) {
-		xfs_buf_delwri_queue(bp);
-		xfs_buf_relse(bp);
-	}
-	xfs_dqunlock(dqp);
-}
-
 STATIC xfs_lsn_t
 xfs_qm_dquot_logitem_committed(
 	struct xfs_log_item	*lip,
@@ -179,66 +141,23 @@ xfs_qm_dqunpin_wait(
 }
 
 /*
- * This is called when IOP_TRYLOCK returns XFS_ITEM_PUSHBUF to indicate that
- * the dquot is locked by us, but the flush lock isn't. So, here we are
- * going to see if the relevant dquot buffer is incore, waiting on DELWRI.
- * If so, we want to push it out to help us take this item off the AIL as soon
- * as possible.
+ * This is called to attempt to flush the dquot associated with this log item.
+ * We try to do the whole thing non-blocking, and tell the caller to try again
+ * later if the item is pinned or locked.
  *
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
+ * We drop the AIL lock across the call to xfs_qm_dqflush as it might block
+ * when reading the dquot from disk, and generally might take far too many
+ * other locks to keep a sane locking hierachy.
  */
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
@@ -251,20 +170,41 @@ xfs_qm_dquot_logitem_trylock(
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
+	/*
+	 * Given that xfs_qm_dqflush might block on memory allocation
+	 * and/or reading the dquot from disk drop the AIL lock before
+	 * calling it.
+	 */
+	spin_unlock(&lip->li_ailp->xa_lock);
+
+	error = xfs_qm_dqflush(dqp, &bp);
+	if (error) {
+		xfs_warn(dqp->q_mount, "%s: push error %d on dqp %p",
+			__func__, error, dqp);
+	} else if (bp) {
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
@@ -315,11 +255,9 @@ static const struct xfs_item_ops xfs_dqu
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
 
@@ -414,11 +352,13 @@ xfs_qm_qoff_logitem_unpin(
 }
 
 /*
- * Quotaoff items have no locking, so just return success.
+ * There isn't much you can do to push on an quotaoff item.  It is simply
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
@@ -445,17 +385,6 @@ xfs_qm_qoff_logitem_committed(
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
@@ -503,7 +432,6 @@ static const struct xfs_item_ops xfs_qm_
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_pin	= xfs_qm_qoff_logitem_pin,
 	.iop_unpin	= xfs_qm_qoff_logitem_unpin,
-	.iop_trylock	= xfs_qm_qoff_logitem_trylock,
 	.iop_unlock	= xfs_qm_qoff_logitem_unlock,
 	.iop_committed	= xfs_qm_qoffend_logitem_committed,
 	.iop_push	= xfs_qm_qoff_logitem_push,
@@ -518,7 +446,6 @@ static const struct xfs_item_ops xfs_qm_
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_pin	= xfs_qm_qoff_logitem_pin,
 	.iop_unpin	= xfs_qm_qoff_logitem_unpin,
-	.iop_trylock	= xfs_qm_qoff_logitem_trylock,
 	.iop_unlock	= xfs_qm_qoff_logitem_unlock,
 	.iop_committed	= xfs_qm_qoff_logitem_committed,
 	.iop_push	= xfs_qm_qoff_logitem_push,
Index: xfs/fs/xfs/xfs_extfree_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extfree_item.c	2011-10-27 22:39:42.528674212 +0200
+++ xfs/fs/xfs/xfs_extfree_item.c	2011-10-27 22:40:16.218216695 +0200
@@ -154,8 +154,9 @@ xfs_efi_item_unpin(
  * This should help in getting the EFI out of the AIL.
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
@@ -190,17 +191,6 @@ xfs_efi_item_committed(
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
@@ -222,7 +212,6 @@ static const struct xfs_item_ops xfs_efi
 	.iop_format	= xfs_efi_item_format,
 	.iop_pin	= xfs_efi_item_pin,
 	.iop_unpin	= xfs_efi_item_unpin,
-	.iop_trylock	= xfs_efi_item_trylock,
 	.iop_unlock	= xfs_efi_item_unlock,
 	.iop_committed	= xfs_efi_item_committed,
 	.iop_push	= xfs_efi_item_push,
@@ -404,11 +393,13 @@ xfs_efd_item_unpin(
 }
 
 /*
- * Efd items have no locking, so just return success.
+ * There isn't much you can do to push on an efd item.  It is simply
+ * stuck waiting for the log to be flushed to disk.
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
@@ -451,16 +442,6 @@ xfs_efd_item_committed(
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
@@ -482,7 +463,6 @@ static const struct xfs_item_ops xfs_efd
 	.iop_format	= xfs_efd_item_format,
 	.iop_pin	= xfs_efd_item_pin,
 	.iop_unpin	= xfs_efd_item_unpin,
-	.iop_trylock	= xfs_efd_item_trylock,
 	.iop_unlock	= xfs_efd_item_unlock,
 	.iop_committed	= xfs_efd_item_committed,
 	.iop_push	= xfs_efd_item_push,
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-10-27 22:40:13.681172022 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2011-10-27 22:40:16.218216695 +0200
@@ -527,24 +527,25 @@ xfs_inode_item_unpin(
 }
 
 /*
- * This is called to attempt to lock the inode associated with this
- * inode log item, in preparation for the push routine which does the actual
- * iflush.  Don't sleep on the inode lock or the flush lock.
+ * This is called to attempt to flush the inode associated with this log item.
  *
- * If the flush lock is already held, indicating that the inode has
- * been or is in the process of being flushed, then (ideally) we'd like to
- * see if the inode's buffer is still incore, and if so give it a nudge.
- * We delay doing so until the pushbuf routine, though, to avoid holding
- * the AIL lock across a call to the blackhole which is the buffer cache.
- * Also we don't want to sleep in any device strategy routines, which can happen
- * if we do the subsequent bawrite in here.
+ * We try to do the whole thing non-blocking, and tell the caller to try again
+ * later if the item is pinned or locked.
+ *
+ * We drop the AIL lock across the call to xfs_iflush as it might block when
+ * reading the inode cluster from disk, and generally might take far too many
+ * other locks to keep a sane locking hierachy.
  */
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
@@ -557,20 +558,23 @@ xfs_inode_item_trylock(
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
 		/*
@@ -585,10 +589,27 @@ xfs_inode_item_trylock(
 	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		ASSERT(iip->ili_format.ilf_fields != 0);
 		ASSERT(iip->ili_logged == 0);
-		ASSERT(lip->li_flags & XFS_LI_IN_AIL);
 	}
 #endif
-	return XFS_ITEM_SUCCESS;
+
+	/*
+	 * Given that xfs_iflush might block on memory allocation
+	 * and/or reading the dquot from disk drop the AIL lock before
+	 * calling it.
+	 */
+	spin_unlock(&lip->li_ailp->xa_lock);
+
+	error = xfs_iflush(ip, &bp);
+	if (!error) {
+		if (!xfs_buf_delwri_queue(bp, buffer_list))
+			rval = XFS_ITEM_FLUSHING;
+		xfs_buf_relse(bp);
+	}
+
+	spin_lock(&lip->li_ailp->xa_lock);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return rval;
 }
 
 /*
@@ -673,93 +694,6 @@ xfs_inode_item_committed(
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
-	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) ||
-	       iip->ili_format.ilf_fields != 0);
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
@@ -779,11 +713,9 @@ static const struct xfs_item_ops xfs_ino
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
--- xfs.orig/fs/xfs/xfs_trace.h	2011-10-27 22:40:08.610173785 +0200
+++ xfs/fs/xfs/xfs_trace.h	2011-10-27 22:40:16.222187321 +0200
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
@@ -880,10 +878,9 @@ DEFINE_EVENT(xfs_log_item_class, name, \
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
--- xfs.orig/fs/xfs/xfs_trans.h	2011-10-27 22:39:42.536670491 +0200
+++ xfs/fs/xfs/xfs_trans.h	2011-10-27 22:40:16.230218778 +0200
@@ -346,11 +346,9 @@ struct xfs_item_ops {
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
 
@@ -358,20 +356,18 @@ struct xfs_item_ops {
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
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-10-27 22:40:12.489171652 +0200
+++ xfs/fs/xfs/xfs_trans_ail.c	2011-10-27 22:40:16.230218778 +0200
@@ -364,25 +364,24 @@ xfsaild_push(
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
 	 * If last time we ran we encountered pinned items, force the log first
 	 * and wait for it before pushing again.
 	 */
-	spin_lock(&ailp->xa_lock);
-	if (ailp->xa_last_pushed_lsn == 0 && ailp->xa_log_flush &&
-	    !list_empty(&ailp->xa_ail)) {
+	if (ailp->xa_log_flush && ailp->xa_last_pushed_lsn == 0 &&
+	    (!list_empty(&ailp->xa_buf_list) || xfs_ail_min_lsn(ailp))) {
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
@@ -418,42 +417,35 @@ xfsaild_push(
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
+		 * Try to push them item without blocking on locks.  Note that
+		 * IOP_PUSH may unlocked and reacquire the ail lock, but the
+		 * AIL cursor routines can handle that just fine.
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
-
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
+		case XFS_ITEM_FLUSHING:
+			XFS_STATS_INC(xs_push_ail_flushing);
+			trace_xfs_ail_flushing(lip);
+
+			/*
+			 * We do not want to break out of the loop early just
+			 * because we have too many items that are already
+			 * beeing flushed - this could happen for to easily
+			 * e.g. because of inode flush clustering.  But when
+			 * we have an almost empty AIL that only contains
+			 * locked buffers we must not stop pushing things.
+			 */
+			flushing++;
+			ailp->xa_last_pushed_lsn = lsn;
 			break;
-
 		case XFS_ITEM_PINNED:
 			XFS_STATS_INC(xs_push_ail_pinned);
 			trace_xfs_ail_pinned(lip);
@@ -461,19 +453,17 @@ xfsaild_push(
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
@@ -499,42 +489,36 @@ xfsaild_push(
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
@@ -547,6 +531,8 @@ xfsaild(
 	struct xfs_ail	*ailp = data;
 	long		tout = 0;	/* milliseconds */
 
+	current->flags |= PF_MEMALLOC;
+
 	while (!kthread_should_stop()) {
 		if (tout && tout <= 20)
 			__set_current_state(TASK_KILLABLE);
@@ -866,6 +852,7 @@ xfs_trans_ail_init(
 	INIT_LIST_HEAD(&ailp->xa_ail);
 	INIT_LIST_HEAD(&ailp->xa_cursors);
 	spin_lock_init(&ailp->xa_lock);
+	INIT_LIST_HEAD(&ailp->xa_buf_list);
 	init_waitqueue_head(&ailp->xa_empty);
 	atomic_set(&ailp->xa_wait_empty, 0);
 
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2011-10-27 22:40:15.630172342 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2011-10-27 22:40:16.234188505 +0200
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
@@ -672,22 +651,33 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 
 
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
@@ -707,7 +697,6 @@ xfs_trans_binval(
 		 * If the buffer is already invalidated, then
 		 * just return.
 		 */
-		ASSERT(!(XFS_BUF_ISDELAYWRITE(bp)));
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		ASSERT(!(bip->bli_flags & (XFS_BLI_LOGGED | XFS_BLI_DIRTY)));
 		ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_INODE_BUF));
@@ -717,27 +706,8 @@ xfs_trans_binval(
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
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:14.813173372 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:16.238187917 +0200
@@ -387,7 +387,8 @@ xfs_qm_dqflush_all(
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	int			recl;
 	struct xfs_dquot	*dqp;
-	int			error;
+	int			error = 0, error2;
+	LIST_HEAD		(buffer_list);
 
 	if (!q)
 		return 0;
@@ -405,16 +406,8 @@ again:
 
 		/* XXX a sentinel would be better */
 		recl = q->qi_dqreclaims;
-		if (!xfs_dqflock_nowait(dqp)) {
-			/*
-			 * If we can't grab the flush lock then check
-			 * to see if the dquot has been flushed delayed
-			 * write.  If so, grab its buffer and send it
-			 * out immediately.  We'll be able to acquire
-			 * the flush lock when the I/O completes.
-			 */
-			xfs_dqflock_pushbuf_wait(dqp);
-		}
+		xfs_dqflock(dqp);
+
 		/*
 		 * Let go of the mplist lock. We don't want to hold it
 		 * across a disk write.
@@ -422,12 +415,12 @@ again:
 		mutex_unlock(&q->qi_dqlist_lock);
 		error = xfs_qm_dqflush(dqp, &bp);
 		if (!error && bp) {
-			xfs_buf_delwri_queue(bp);
+			xfs_buf_delwri_queue(bp, &buffer_list);
 			xfs_buf_relse(bp);
 		}
 		xfs_dqunlock(dqp);
 		if (error)
-			return error;
+			goto out;
 
 		mutex_lock(&q->qi_dqlist_lock);
 		if (recl != q->qi_dqreclaims) {
@@ -438,8 +431,9 @@ again:
 	}
 
 	mutex_unlock(&q->qi_dqlist_lock);
-	/* return ! busy */
-	return 0;
+out:
+	error2 = xfs_buf_delwri_submit(&buffer_list);
+	return error ? error : error2;
 }
 
 /*
@@ -1085,8 +1079,9 @@ xfs_qm_dqiter_bufs(
 	uint		flags)
 {
 	xfs_buf_t	*bp;
-	int		error;
+	int		error = 0, error2;
 	int		type;
+	LIST_HEAD	(buffer_list);
 
 	ASSERT(blkcnt > 0);
 	type = flags & XFS_QMOPT_UQUOTA ? XFS_DQ_USER :
@@ -1110,7 +1105,7 @@ xfs_qm_dqiter_bufs(
 			break;
 
 		xfs_qm_reset_dqcounts(mp, bp, firstid, type);
-		xfs_buf_delwri_queue(bp);
+		xfs_buf_delwri_queue(bp, &buffer_list);
 		xfs_buf_relse(bp);
 		/*
 		 * goto the next block.
@@ -1118,7 +1113,9 @@ xfs_qm_dqiter_bufs(
 		bno++;
 		firstid += mp->m_quotainfo->qi_dqperchunk;
 	}
-	return error;
+
+	error2 = xfs_buf_delwri_submit(&buffer_list);
+	return error ? error : error2;
 }
 
 /*
@@ -1469,9 +1466,11 @@ xfs_qm_quotacheck(
 	} while (!done);
 
 	/*
-	 * We've made all the changes that we need to make incore.
-	 * Flush them down to disk buffers if everything was updated
-	 * successfully.
+	 * We didn't log anything, because if we crashed, we'll have to
+	 * start the quotacheck from scratch anyway. However, we must make
+	 * sure that our dquot changes are secure before we put the
+	 * quotacheck'd stamp on the superblock. So, here we do a synchronous
+	 * write of all buffers that we modified.
 	 */
 	if (!error)
 		error = xfs_qm_dqflush_all(mp);
@@ -1489,15 +1488,6 @@ xfs_qm_quotacheck(
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
@@ -1644,29 +1634,30 @@ xfs_qm_dqreclaim_one(
 
 	/*
 	 * We have the flush lock so we know that this is not in the
-	 * process of being flushed. So, if this is dirty, flush it
-	 * DELWRI so that we don't get a freelist infested with
-	 * dirty dquots.
+	 * process of being flushed. So, if this is dirty, write it
+	 * out so that we don't get a freelist infested with dirty
+	 * dquots.
 	 */
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		if (!write_dirty)
 			goto out_busy;
 		else {
 			struct xfs_buf	*bp = NULL;
-
+			LIST_HEAD	(buffer_list);
 
 			trace_xfs_dqreclaim_dirty(dqp);
 
 			mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 			error = xfs_qm_dqflush(dqp, &bp);
 			if (!error && bp) {
-				xfs_buf_delwri_queue(bp);
+				xfs_buf_delwri_queue(bp, &buffer_list);
 				xfs_buf_relse(bp);
 			}
 			if (error) {
 				xfs_warn(mp, "%s: dquot %p flush failed",
 					 __func__, dqp);
 			}
+			xfs_buf_delwri_submit(&buffer_list);
 			mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
 		}
 	}
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:40:14.809173098 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:16.244688077 +0200
@@ -1135,22 +1135,7 @@ xfs_qm_dqpurge(
 	struct xfs_dqhash	*qh = dqp->q_hash;
 
 	xfs_dqlock(dqp);
-
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
@@ -1202,36 +1187,3 @@ xfs_qm_dqpurge(
 
 	xfs_qm_dqdestroy(dqp);
 }
-
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
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-10-27 22:40:13.673170747 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-10-27 22:40:16.244688077 +0200
@@ -2357,11 +2357,11 @@ cluster_corrupt_out:
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
 
Index: xfs/fs/xfs/xfs_trans_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_priv.h	2011-10-27 22:40:12.489171652 +0200
+++ xfs/fs/xfs/xfs_trans_priv.h	2011-10-27 22:40:16.248721987 +0200
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
--- xfs.orig/fs/xfs/xfs_super.c	2011-10-27 22:40:01.238188776 +0200
+++ xfs/fs/xfs/xfs_super.c	2011-10-27 22:40:16.248721987 +0200
@@ -974,15 +974,7 @@ xfs_fs_put_super(
 
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
@@ -1398,15 +1390,7 @@ out_destroy_workqueues:
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
--- xfs.orig/fs/xfs/xfs_sync.c	2011-10-27 22:40:13.685172888 +0200
+++ xfs/fs/xfs/xfs_sync.c	2011-10-27 22:40:16.257172598 +0200
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
 
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2011-10-27 22:40:14.809173098 +0200
+++ xfs/fs/xfs/xfs_dquot.h	2011-10-27 22:40:16.261181282 +0200
@@ -145,7 +145,6 @@ extern void		xfs_qm_dqput(xfs_dquot_t *)
 
 extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
 extern void		xfs_dqunlock(struct xfs_dquot *);
-extern void		xfs_dqflock_pushbuf_wait(struct xfs_dquot *dqp);
 
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
