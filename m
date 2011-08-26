Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7Q6pvla043600 for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 01:51:57 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A800C13A135F
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 23:54:51 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	mELN0zYq8h8JuODB for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2011 23:54:51 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1QwqGS-0006jt-Tl
	for xfs@oss.sgi.com; Fri, 26 Aug 2011 16:51:40 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QwqGS-0006ER-Mc
	for xfs@oss.sgi.com; Fri, 26 Aug 2011 16:51:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: convert xfsbufd to use a workqueue
Date: Fri, 26 Aug 2011 16:51:37 +1000
Message-Id: <1314341497-23910-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1314341497-23910-1-git-send-email-david@fromorbit.com>
References: <1314341497-23910-1-git-send-email-david@fromorbit.com>
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
control flushing.  This greatly simplifes the process of flushing
and also removes a bunch of duplicated code between buftarg flushing
and delwri buffer writeback.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c       |  172 +++++++++++++++++++++---------------------------
 fs/xfs/xfs_buf.h       |    5 +-
 fs/xfs/xfs_dquot.c     |    1 -
 fs/xfs/xfs_trans_ail.c |    2 +-
 4 files changed, 78 insertions(+), 102 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 415ab71..9aa4e60 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -42,9 +42,9 @@
 #include "xfs_trace.h"
 
 static kmem_zone_t *xfs_buf_zone;
-STATIC int xfsbufd(void *);
-STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
+STATIC void xfs_buf_delwri_queue(xfs_buf_t *bp, int unlock);
 
+static struct workqueue_struct *xfs_buf_wq;
 static struct workqueue_struct *xfslogd_workqueue;
 struct workqueue_struct *xfsdatad_workqueue;
 struct workqueue_struct *xfsconvertd_workqueue;
@@ -1407,8 +1407,9 @@ xfs_buf_delwri_queue(
 	}
 
 	if (list_empty(dwq)) {
-		/* start xfsbufd as it is about to have something to do */
-		wake_up_process(bp->b_target->bt_task);
+		/* queue a delayed flush as we are about to queue a buffer */
+		queue_delayed_work(xfs_buf_wq, &bp->b_target->bt_delwrite_work,
+			xfs_buf_timer_centisecs * msecs_to_jiffies(10));
 	}
 
 	bp->b_flags |= _XBF_DELWRI_Q;
@@ -1486,15 +1487,14 @@ STATIC int
 xfs_buf_delwri_split(
 	xfs_buftarg_t	*target,
 	struct list_head *list,
-	unsigned long	age)
+	unsigned long	age,
+	int		force)
 {
 	xfs_buf_t	*bp, *n;
 	struct list_head *dwq = &target->bt_delwrite_queue;
 	spinlock_t	*dwlk = &target->bt_delwrite_lock;
 	int		skipped = 0;
-	int		force;
 
-	force = test_and_clear_bit(XBT_FORCE_FLUSH, &target->bt_flags);
 	INIT_LIST_HEAD(list);
 	spin_lock(dwlk);
 	list_for_each_entry_safe(bp, n, dwq, b_list) {
@@ -1543,90 +1543,33 @@ xfs_buf_cmp(
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
 /*
- *	Handling of buffer targets (buftargs).
+ * If we are doing a forced flush, then we need to wait for the IO that we
+ * issue to complete.
  */
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
+static void
+xfs_buf_delwri_work(
+	struct work_struct *work)
 {
-	xfs_buf_t	*bp;
-	int		pincount = 0;
+	struct xfs_buftarg *btp = container_of(to_delayed_work(work),
+					struct xfs_buftarg, bt_delwrite_work);
+	struct xfs_buf	*bp;
+	struct blk_plug	plug;
 	LIST_HEAD(tmp_list);
 	LIST_HEAD(wait_list);
-	struct blk_plug plug;
-
-	xfs_buf_runall_queues(xfsconvertd_workqueue);
-	xfs_buf_runall_queues(xfsdatad_workqueue);
-	xfs_buf_runall_queues(xfslogd_workqueue);
+	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
+	int		force = 0;
 
-	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
-	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);
+	force = test_and_clear_bit(XBT_FORCE_FLUSH, &btp->bt_flags);
 
-	/*
-	 * Dropped the delayed write list lock, now walk the temporary list.
-	 * All I/O is issued async and then if we need to wait for completion
-	 * we do that after issuing all the IO.
-	 */
+	xfs_buf_delwri_split(btp, &tmp_list, age, force);
 	list_sort(NULL, &tmp_list, xfs_buf_cmp);
 
 	blk_start_plug(&plug);
 	while (!list_empty(&tmp_list)) {
 		bp = list_first_entry(&tmp_list, struct xfs_buf, b_list);
-		ASSERT(target == bp->b_target);
 		list_del_init(&bp->b_list);
-		if (wait) {
+		if (force) {
 			bp->b_flags &= ~XBF_ASYNC;
 			list_add(&bp->b_list, &wait_list);
 		}
@@ -1634,7 +1577,7 @@ xfs_flush_buftarg(
 	}
 	blk_finish_plug(&plug);
 
-	if (wait) {
+	if (force) {
 		/* Wait for IO to complete. */
 		while (!list_empty(&wait_list)) {
 			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
@@ -1645,7 +1588,48 @@ xfs_flush_buftarg(
 		}
 	}
 
-	return pincount;
+	if (list_empty(&btp->bt_delwrite_queue))
+		return;
+
+	queue_delayed_work(xfs_buf_wq, &btp->bt_delwrite_work,
+			xfs_buf_timer_centisecs * msecs_to_jiffies(10));
+}
+
+/*
+ *	Handling of buffer targets (buftargs).
+ */
+
+/*
+ * Flush all the queued buffer work, then flush any remaining dirty buffers
+ * and wait for them to complete. If there are buffers remaining on the delwri
+ * queue, then they were pinned so couldn't be flushed. Return a value of 1 to
+ * indicate that there were pinned buffers and the caller needs to retry the
+ * flush.
+ */
+int
+xfs_flush_buftarg(
+	xfs_buftarg_t	*target,
+	int		wait)
+{
+	xfs_buf_runall_queues(xfsconvertd_workqueue);
+	xfs_buf_runall_queues(xfsdatad_workqueue);
+	xfs_buf_runall_queues(xfslogd_workqueue);
+
+	if (wait) {
+		/*
+		 * Ensure we have work queued up after setting the force flag.
+		 * If work is already in progress then the wq flush below won't
+		 * cause new work to start and hence the force flag will not be
+		 * seen by the flush and the flush will be incomplete.
+		 */
+		set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
+		queue_delayed_work(xfs_buf_wq, &target->bt_delwrite_work, 0);
+	}
+	flush_delayed_work_sync(&target->bt_delwrite_work);
+
+	if (!list_empty(&target->bt_delwrite_queue))
+		return 1;
+	return 0;
 }
 
 /*
@@ -1740,7 +1724,6 @@ xfs_free_buftarg(
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_blkdev_issue_flush(btp);
 
-	kthread_stop(btp->bt_task);
 	kmem_free(btp);
 }
 
@@ -1788,20 +1771,6 @@ xfs_setsize_buftarg(
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
-
 xfs_buftarg_t *
 xfs_alloc_buftarg(
 	struct xfs_mount	*mp,
@@ -1824,8 +1793,11 @@ xfs_alloc_buftarg(
 	spin_lock_init(&btp->bt_lru_lock);
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error;
-	if (xfs_alloc_delwrite_queue(btp, fsname))
-		goto error;
+
+	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
+	spin_lock_init(&btp->bt_delwrite_lock);
+	INIT_DELAYED_WORK(&btp->bt_delwrite_work, xfs_buf_delwri_work);
+
 	btp->bt_shrinker.shrink = xfs_buftarg_shrink;
 	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
 	register_shrinker(&btp->bt_shrinker);
@@ -1860,8 +1832,13 @@ xfs_buf_init(void)
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
@@ -1875,6 +1852,7 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
+	destroy_workqueue(xfs_buf_wq);
 	destroy_workqueue(xfsconvertd_workqueue);
 	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 620972b..c1aabfd 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
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
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index db62959..1fb9d93 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1446,7 +1446,6 @@ xfs_qm_dqflock_pushbuf_wait(
 		if (xfs_buf_ispinned(bp))
 			xfs_log_force(mp, 0);
 		xfs_buf_delwri_promote(bp);
-		wake_up_process(bp->b_target->bt_task);
 	}
 	xfs_buf_relse(bp);
 out_lock:
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 13188df..a3d1784 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -494,7 +494,7 @@ xfs_ail_worker(
 
 	if (push_xfsbufd) {
 		/* we've got delayed write buffers to flush */
-		wake_up_process(mp->m_ddev_targp->bt_task);
+		flush_delayed_work(&mp->m_ddev_targp->bt_delwrite_work);
 	}
 
 	/* assume we have more work to do in a short while */
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
