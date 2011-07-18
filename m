Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6I3o0pG078355 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 22:50:00 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE05DECC776
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 20:49:57 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	aX8M7101ZiM6uRMc for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2011 20:49:57 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Qieq9-0008Cx-2D
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:49:53 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Qieq8-0002hX-RG
	for xfs@oss.sgi.com; Mon, 18 Jul 2011 13:49:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: convert xfsbufd to use a workqueue
Date: Mon, 18 Jul 2011 13:49:48 +1000
Message-Id: <1310960989-10284-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1310960989-10284-1-git-send-email-david@fromorbit.com>
References: <1310960989-10284-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

There is no reason we need a thread per filesystem to do the
flushing of the delayed write buffer queue. This can be easily
handled by a global concurrency managed workqueue.

Convert the delayed write buffer handling to use workqueues and
workqueue flushes to implement buffer writeback by embedding a
delayed work structure into the struct xfs_buftarg and using that to
control flushing. While there, group all the delayed write list and
buffer handling functions into the same section of code to make it
easier to find all the relevant code.

This greatly simplifes the process of flushing and also removes a
bunch of duplicated code between buftarg flushing and delwri buffer
writeback.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |  522 ++++++++++++++++++++------------------------
 fs/xfs/linux-2.6/xfs_buf.h |    5 +-
 fs/xfs/quota/xfs_dquot.c   |    1 -
 fs/xfs/xfs_trans_ail.c     |    2 +-
 4 files changed, 244 insertions(+), 286 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index b2b4119..1d2b5f9 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -33,6 +33,7 @@
 #include <linux/migrate.h>
 #include <linux/backing-dev.h>
 #include <linux/freezer.h>
+#include <linux/workqueue.h>
 
 #include "xfs_sb.h"
 #include "xfs_inum.h"
@@ -42,9 +43,9 @@
 #include "xfs_trace.h"
 
 static kmem_zone_t *xfs_buf_zone;
-STATIC int xfsbufd(void *);
 STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
 
+static struct workqueue_struct *xfs_buf_wq;
 static struct workqueue_struct *xfslogd_workqueue;
 struct workqueue_struct *xfsdatad_workqueue;
 struct workqueue_struct *xfsconvertd_workqueue;
@@ -1367,9 +1368,236 @@ xfs_buf_iomove(
 	}
 }
 
+
+
+/*
+ *	Delayed write buffer handling
+ */
+STATIC void
+xfs_buf_delwri_queue(
+	xfs_buf_t		*bp,
+	int			unlock)
+{
+	struct list_head	*dwq = &bp->b_target->bt_delwrite_queue;
+	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
+
+	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
+
+	ASSERT((bp->b_flags&(XBF_DELWRI|XBF_ASYNC)) == (XBF_DELWRI|XBF_ASYNC));
+
+	spin_lock(dwlk);
+	/* If already in the queue, dequeue and place at tail */
+	if (!list_empty(&bp->b_list)) {
+		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
+		if (unlock)
+			atomic_dec(&bp->b_hold);
+		list_del(&bp->b_list);
+	}
+
+	if (list_empty(dwq)) {
+		/* queue a delayed flush as we are about to queue a buffer */
+		queue_delayed_work(xfs_buf_wq, &bp->b_target->bt_delwrite_work,
+			xfs_buf_timer_centisecs * msecs_to_jiffies(10));
+	}
+
+	bp->b_flags |= _XBF_DELWRI_Q;
+	list_add_tail(&bp->b_list, dwq);
+	bp->b_queuetime = jiffies;
+	spin_unlock(dwlk);
+
+	if (unlock)
+		xfs_buf_unlock(bp);
+}
+
+void
+xfs_buf_delwri_dequeue(
+	xfs_buf_t		*bp)
+{
+	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
+	int			dequeued = 0;
+
+	spin_lock(dwlk);
+	if ((bp->b_flags & XBF_DELWRI) && !list_empty(&bp->b_list)) {
+		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
+		list_del_init(&bp->b_list);
+		dequeued = 1;
+	}
+	bp->b_flags &= ~(XBF_DELWRI|_XBF_DELWRI_Q);
+	spin_unlock(dwlk);
+
+	if (dequeued)
+		xfs_buf_rele(bp);
+
+	trace_xfs_buf_delwri_dequeue(bp, _RET_IP_);
+}
+
+/*
+ * If a delwri buffer needs to be pushed before it has aged out, then promote
+ * it to the head of the delwri queue so that it will be flushed on the next
+ * xfsbufd run. We do this by resetting the queuetime of the buffer to be older
+ * than the age currently needed to flush the buffer. Hence the next time the
+ * xfsbufd sees it is guaranteed to be considered old enough to flush.
+ */
+void
+xfs_buf_delwri_promote(
+	struct xfs_buf	*bp)
+{
+	struct xfs_buftarg *btp = bp->b_target;
+	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10) + 1;
+
+	ASSERT(bp->b_flags & XBF_DELWRI);
+	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
+
+	/*
+	 * Check the buffer age before locking the delayed write queue as we
+	 * don't need to promote buffers that are already past the flush age.
+	 */
+	if (bp->b_queuetime < jiffies - age)
+		return;
+	bp->b_queuetime = jiffies - age;
+	spin_lock(&btp->bt_delwrite_lock);
+	list_move(&bp->b_list, &btp->bt_delwrite_queue);
+	spin_unlock(&btp->bt_delwrite_lock);
+}
+
+/*
+ * Move buffers older than the age specified to the supplied list, avoiding
+ * locked buffers to prevent deadlocks.
+ */
+STATIC void
+xfs_buf_delwri_split(
+	xfs_buftarg_t	*target,
+	struct list_head *list,
+	unsigned long	age,
+	int		force)
+{
+	xfs_buf_t	*bp, *n;
+	struct list_head *dwq = &target->bt_delwrite_queue;
+	spinlock_t	*dwlk = &target->bt_delwrite_lock;
+
+	INIT_LIST_HEAD(list);
+	spin_lock(dwlk);
+	list_for_each_entry_safe(bp, n, dwq, b_list) {
+		ASSERT(bp->b_flags & XBF_DELWRI);
+
+		if (!XFS_BUF_ISPINNED(bp) && xfs_buf_trylock(bp)) {
+			if (!force &&
+			    time_before(jiffies, bp->b_queuetime + age)) {
+				xfs_buf_unlock(bp);
+				break;
+			}
+
+			bp->b_flags &= ~(XBF_DELWRI | _XBF_DELWRI_Q);
+			bp->b_flags |= XBF_WRITE;
+			list_move_tail(&bp->b_list, list);
+			trace_xfs_buf_delwri_split(bp, _RET_IP_);
+		}
+	}
+	spin_unlock(dwlk);
+}
+
 /*
- *	Handling of buffer targets (buftargs).
+ * Compare function is more complex than it needs to be because
+ * the return value is only 32 bits and we are doing comparisons
+ * on 64 bit values
  */
+static int
+xfs_buf_cmp(
+	void		*priv,
+	struct list_head *a,
+	struct list_head *b)
+{
+	struct xfs_buf	*ap = container_of(a, struct xfs_buf, b_list);
+	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
+	xfs_daddr_t		diff;
+
+	diff = ap->b_bn - bp->b_bn;
+	if (diff < 0)
+		return -1;
+	if (diff > 0)
+		return 1;
+	return 0;
+}
+
+/*
+ * If we are doing a forced flush, then we need to wait for the IO that we
+ * issue to complete.
+ */
+static void
+xfs_buf_delwri_work(
+	struct work_struct *work)
+{
+	struct xfs_buftarg *btp = container_of(to_delayed_work(work),
+					struct xfs_buftarg, bt_delwrite_work);
+	struct xfs_buf	*bp;
+	struct blk_plug	plug;
+	LIST_HEAD(tmp_list);
+	LIST_HEAD(wait_list);
+	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
+	int		force = 0;
+
+	if (test_and_clear_bit(XBT_FORCE_FLUSH, &btp->bt_flags)) {
+		force = 1;
+		age = 0;
+	}
+
+	xfs_buf_delwri_split(btp, &tmp_list, age, force);
+	list_sort(NULL, &tmp_list, xfs_buf_cmp);
+
+	blk_start_plug(&plug);
+	while (!list_empty(&tmp_list)) {
+		bp = list_first_entry(&tmp_list, struct xfs_buf, b_list);
+		list_del_init(&bp->b_list);
+		if (force) {
+			bp->b_flags &= ~XBF_ASYNC;
+			list_add(&bp->b_list, &wait_list);
+		}
+		xfs_bdstrat_cb(bp);
+	}
+	blk_finish_plug(&plug);
+
+	if (force) {
+		/* Wait for IO to complete. */
+		while (!list_empty(&wait_list)) {
+			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
+
+			list_del_init(&bp->b_list);
+			xfs_buf_iowait(bp);
+			xfs_buf_relse(bp);
+		}
+	}
+
+	if (list_empty(&btp->bt_delwrite_queue))
+		return;
+
+	queue_delayed_work(xfs_buf_wq, &btp->bt_delwrite_work,
+			xfs_buf_timer_centisecs * msecs_to_jiffies(10));
+}
+
+/*
+ * Go through all incore buffers, and release buffers if they belong to
+ * the given device. This is used in filesystem error handling to
+ * preserve the consistency of its metadata.
+ *
+ * If we flush all the delayed write metadata, return 0. Otherwise, return 1 to
+ * indicate more work needs to be done.
+ */
+int
+xfs_flush_buftarg(
+	xfs_buftarg_t	*target,
+	int		wait)
+{
+	flush_workqueue(xfsconvertd_workqueue);
+	flush_workqueue(xfsdatad_workqueue);
+	flush_workqueue(xfslogd_workqueue);
+
+	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
+	flush_delayed_work_sync(&target->bt_delwrite_work);
+
+	if (!list_empty(&target->bt_delwrite_queue))
+		return 1;
+	return 0;
+}
 
 /*
  * Wait for any bufs with callbacks that have been submitted but have not yet
@@ -1463,7 +1691,6 @@ xfs_free_buftarg(
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_blkdev_issue_flush(btp);
 
-	kthread_stop(btp->bt_task);
 	kmem_free(btp);
 }
 
@@ -1511,19 +1738,6 @@ xfs_setsize_buftarg(
 	return xfs_setsize_buftarg_flags(btp, blocksize, sectorsize, 1);
 }
 
-STATIC int
-xfs_alloc_delwrite_queue(
-	xfs_buftarg_t		*btp,
-	const char		*fsname)
-{
-	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
-	spin_lock_init(&btp->bt_delwrite_lock);
-	btp->bt_flags = 0;
-	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd/%s", fsname);
-	if (IS_ERR(btp->bt_task))
-		return PTR_ERR(btp->bt_task);
-	return 0;
-}
 
 xfs_buftarg_t *
 xfs_alloc_buftarg(
@@ -1545,10 +1759,13 @@ xfs_alloc_buftarg(
 
 	INIT_LIST_HEAD(&btp->bt_lru);
 	spin_lock_init(&btp->bt_lru_lock);
+
+	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
+	spin_lock_init(&btp->bt_delwrite_lock);
+	INIT_DELAYED_WORK(&btp->bt_delwrite_work, xfs_buf_delwri_work);
+
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error;
-	if (xfs_alloc_delwrite_queue(btp, fsname))
-		goto error;
 	btp->bt_shrinker.shrink = xfs_buftarg_shrink;
 	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
 	register_shrinker(&btp->bt_shrinker);
@@ -1559,269 +1776,6 @@ error:
 	return NULL;
 }
 
-
-/*
- *	Delayed write buffer handling
- */
-STATIC void
-xfs_buf_delwri_queue(
-	xfs_buf_t		*bp,
-	int			unlock)
-{
-	struct list_head	*dwq = &bp->b_target->bt_delwrite_queue;
-	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
-
-	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
-
-	ASSERT((bp->b_flags&(XBF_DELWRI|XBF_ASYNC)) == (XBF_DELWRI|XBF_ASYNC));
-
-	spin_lock(dwlk);
-	/* If already in the queue, dequeue and place at tail */
-	if (!list_empty(&bp->b_list)) {
-		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-		if (unlock)
-			atomic_dec(&bp->b_hold);
-		list_del(&bp->b_list);
-	}
-
-	if (list_empty(dwq)) {
-		/* start xfsbufd as it is about to have something to do */
-		wake_up_process(bp->b_target->bt_task);
-	}
-
-	bp->b_flags |= _XBF_DELWRI_Q;
-	list_add_tail(&bp->b_list, dwq);
-	bp->b_queuetime = jiffies;
-	spin_unlock(dwlk);
-
-	if (unlock)
-		xfs_buf_unlock(bp);
-}
-
-void
-xfs_buf_delwri_dequeue(
-	xfs_buf_t		*bp)
-{
-	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
-	int			dequeued = 0;
-
-	spin_lock(dwlk);
-	if ((bp->b_flags & XBF_DELWRI) && !list_empty(&bp->b_list)) {
-		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-		list_del_init(&bp->b_list);
-		dequeued = 1;
-	}
-	bp->b_flags &= ~(XBF_DELWRI|_XBF_DELWRI_Q);
-	spin_unlock(dwlk);
-
-	if (dequeued)
-		xfs_buf_rele(bp);
-
-	trace_xfs_buf_delwri_dequeue(bp, _RET_IP_);
-}
-
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
-
-	/*
-	 * Check the buffer age before locking the delayed write queue as we
-	 * don't need to promote buffers that are already past the flush age.
-	 */
-	if (bp->b_queuetime < jiffies - age)
-		return;
-	bp->b_queuetime = jiffies - age;
-	spin_lock(&btp->bt_delwrite_lock);
-	list_move(&bp->b_list, &btp->bt_delwrite_queue);
-	spin_unlock(&btp->bt_delwrite_lock);
-}
-
-STATIC void
-xfs_buf_runall_queues(
-	struct workqueue_struct	*queue)
-{
-	flush_workqueue(queue);
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
-	struct list_head *dwq = &target->bt_delwrite_queue;
-	spinlock_t	*dwlk = &target->bt_delwrite_lock;
-	int		skipped = 0;
-	int		force;
-
-	force = test_and_clear_bit(XBT_FORCE_FLUSH, &target->bt_flags);
-	INIT_LIST_HEAD(list);
-	spin_lock(dwlk);
-	list_for_each_entry_safe(bp, n, dwq, b_list) {
-		ASSERT(bp->b_flags & XBF_DELWRI);
-
-		if (!XFS_BUF_ISPINNED(bp) && xfs_buf_trylock(bp)) {
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
-	}
-	spin_unlock(dwlk);
-
-	return skipped;
-
-}
-
-/*
- * Compare function is more complex than it needs to be because
- * the return value is only 32 bits and we are doing comparisons
- * on 64 bit values
- */
-static int
-xfs_buf_cmp(
-	void		*priv,
-	struct list_head *a,
-	struct list_head *b)
-{
-	struct xfs_buf	*ap = container_of(a, struct xfs_buf, b_list);
-	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
-	xfs_daddr_t		diff;
-
-	diff = ap->b_bn - bp->b_bn;
-	if (diff < 0)
-		return -1;
-	if (diff > 0)
-		return 1;
-	return 0;
-}
-
-STATIC int
-xfsbufd(
-	void		*data)
-{
-	xfs_buftarg_t   *target = (xfs_buftarg_t *)data;
-
-	current->flags |= PF_MEMALLOC;
-
-	set_freezable();
-
-	do {
-		long	age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
-		long	tout = xfs_buf_timer_centisecs * msecs_to_jiffies(10);
-		struct list_head tmp;
-		struct blk_plug plug;
-
-		if (unlikely(freezing(current))) {
-			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
-			refrigerator();
-		} else {
-			clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
-		}
-
-		/* sleep for a long time if there is nothing to do. */
-		if (list_empty(&target->bt_delwrite_queue))
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
-			list_del_init(&bp->b_list);
-			xfs_bdstrat_cb(bp);
-		}
-		blk_finish_plug(&plug);
-	} while (!kthread_should_stop());
-
-	return 0;
-}
-
-/*
- *	Go through all incore buffers, and release buffers if they belong to
- *	the given device. This is used in filesystem error handling to
- *	preserve the consistency of its metadata.
- */
-int
-xfs_flush_buftarg(
-	xfs_buftarg_t	*target,
-	int		wait)
-{
-	xfs_buf_t	*bp;
-	int		pincount = 0;
-	LIST_HEAD(tmp_list);
-	LIST_HEAD(wait_list);
-	struct blk_plug plug;
-
-	xfs_buf_runall_queues(xfsconvertd_workqueue);
-	xfs_buf_runall_queues(xfsdatad_workqueue);
-	xfs_buf_runall_queues(xfslogd_workqueue);
-
-	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
-	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);
-
-	/*
-	 * Dropped the delayed write list lock, now walk the temporary list.
-	 * All I/O is issued async and then if we need to wait for completion
-	 * we do that after issuing all the IO.
-	 */
-	list_sort(NULL, &tmp_list, xfs_buf_cmp);
-
-	blk_start_plug(&plug);
-	while (!list_empty(&tmp_list)) {
-		bp = list_first_entry(&tmp_list, struct xfs_buf, b_list);
-		ASSERT(target == bp->b_target);
-		list_del_init(&bp->b_list);
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
-	}
-
-	return pincount;
-}
-
 int __init
 xfs_buf_init(void)
 {
@@ -1844,8 +1798,13 @@ xfs_buf_init(void)
 	if (!xfsconvertd_workqueue)
 		goto out_destroy_xfsdatad_workqueue;
 
+	xfs_buf_wq = alloc_workqueue("xfsbufd", WQ_MEM_RECLAIM, 8);
+	if (!xfs_buf_wq)
+		goto out_destroy_xfsconvertd_wq;
 	return 0;
 
+ out_destroy_xfsconvertd_wq:
+	destroy_workqueue(xfsconvertd_workqueue);
  out_destroy_xfsdatad_workqueue:
 	destroy_workqueue(xfsdatad_workqueue);
  out_destroy_xfslogd_workqueue:
@@ -1859,6 +1818,7 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
+	destroy_workqueue(xfs_buf_wq);
 	destroy_workqueue(xfsconvertd_workqueue);
 	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 6a83b46..2196cd1 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -90,8 +90,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
 
 typedef enum {
-	XBT_FORCE_SLEEP = 0,
-	XBT_FORCE_FLUSH = 1,
+	XBT_FORCE_FLUSH = 0,
 } xfs_buftarg_flags_t;
 
 typedef struct xfs_buftarg {
@@ -104,7 +103,7 @@ typedef struct xfs_buftarg {
 	size_t			bt_smask;
 
 	/* per device delwri queue */
-	struct task_struct	*bt_task;
+	struct delayed_work	bt_delwrite_work;
 	struct list_head	bt_delwrite_queue;
 	spinlock_t		bt_delwrite_lock;
 	unsigned long		bt_flags;
diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 837f311..0136928 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1450,7 +1450,6 @@ xfs_qm_dqflock_pushbuf_wait(
 		if (XFS_BUF_ISPINNED(bp))
 			xfs_log_force(mp, 0);
 		xfs_buf_delwri_promote(bp);
-		wake_up_process(bp->b_target->bt_task);
 	}
 	xfs_buf_relse(bp);
 out_lock:
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 8cd329b..3cfd6e6 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -505,7 +505,7 @@ xfs_ail_worker(
 
 	if (push_xfsbufd) {
 		/* we've got delayed write buffers to flush */
-		wake_up_process(mp->m_ddev_targp->bt_task);
+		flush_delayed_work(&mp->m_ddev_targp->bt_delwrite_work);
 	}
 
 	/* assume we have more work to do in a short while */
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
