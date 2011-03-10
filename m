Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2A02fPY068757 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 18:02:46 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7024C1BD3520
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 16:05:29 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XeEikkZrHRsnhALM for <xfs@oss.sgi.com>;
	Wed, 09 Mar 2011 16:05:29 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PxTNd-0002vZ-44
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 11:05:25 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PxTNl-0002tF-1R
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 11:05:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: convert the xfsaild threads to a workqueue
Date: Thu, 10 Mar 2011 11:05:28 +1100
Message-Id: <1299715529-11026-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1299715529-11026-1-git-send-email-david@fromorbit.com>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
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

Similar to the xfssyncd, the per-filesystem xfsaild threads can be
converted to a global workqueue and run periodically by delayed
works. This makes sense for the AIL pushing because it uses
variable timeouts depending on the work that needs to be done.

By removing the xfsaild, we simplify the AIL pushing code and
remove the need to spread the code to implement the threading
and pushing across multiple files.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |  109 ++++++++++-------------------------
 fs/xfs/xfs_trans_ail.c       |  130 ++++++++++++++++++++++++------------------
 fs/xfs/xfs_trans_priv.h      |   11 ++--
 3 files changed, 111 insertions(+), 139 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 1cbee9c..b0bcfb3 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -816,75 +816,6 @@ xfs_setup_devices(
 	return 0;
 }
 
-/*
- * XFS AIL push thread support
- */
-void
-xfsaild_wakeup(
-	struct xfs_ail		*ailp,
-	xfs_lsn_t		threshold_lsn)
-{
-	/* only ever move the target forwards */
-	if (XFS_LSN_CMP(threshold_lsn, ailp->xa_target) > 0) {
-		ailp->xa_target = threshold_lsn;
-		wake_up_process(ailp->xa_task);
-	}
-}
-
-STATIC int
-xfsaild(
-	void	*data)
-{
-	struct xfs_ail	*ailp = data;
-	xfs_lsn_t	last_pushed_lsn = 0;
-	long		tout = 0; /* milliseconds */
-
-	while (!kthread_should_stop()) {
-		/*
-		 * for short sleeps indicating congestion, don't allow us to
-		 * get woken early. Otherwise all we do is bang on the AIL lock
-		 * without making progress.
-		 */
-		if (tout && tout <= 20)
-			__set_current_state(TASK_KILLABLE);
-		else
-			__set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(tout ?
-				 msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
-
-		/* swsusp */
-		try_to_freeze();
-
-		ASSERT(ailp->xa_mount->m_log);
-		if (XFS_FORCED_SHUTDOWN(ailp->xa_mount))
-			continue;
-
-		tout = xfsaild_push(ailp, &last_pushed_lsn);
-	}
-
-	return 0;
-}	/* xfsaild */
-
-int
-xfsaild_start(
-	struct xfs_ail	*ailp)
-{
-	ailp->xa_target = 0;
-	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
-				    ailp->xa_mount->m_fsname);
-	if (IS_ERR(ailp->xa_task))
-		return -PTR_ERR(ailp->xa_task);
-	return 0;
-}
-
-void
-xfsaild_stop(
-	struct xfs_ail	*ailp)
-{
-	kthread_stop(ailp->xa_task);
-}
-
-
 /* Catch misguided souls that try to use this interface on XFS */
 STATIC struct inode *
 xfs_fs_alloc_inode(
@@ -1772,6 +1703,32 @@ xfs_destroy_zones(void)
 }
 
 STATIC int __init
+xfs_init_workqueues(void)
+{
+	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_CPU_INTENSIVE, 8);
+	if (!xfs_syncd_wq)
+		goto out;
+
+	xfs_ail_wq = alloc_workqueue("xfsail", WQ_CPU_INTENSIVE, 8);
+	if (!xfs_ail_wq)
+		goto out_destroy_syncd;
+
+	return 0;
+
+out_destroy_syncd:
+	destroy_workqueue(xfs_syncd_wq);
+out:
+	return -ENOMEM;
+}
+
+STATIC void __exit
+xfs_destroy_workqueues(void)
+{
+	destroy_workqueue(xfs_ail_wq);
+	destroy_workqueue(xfs_syncd_wq);
+}
+
+STATIC int __init
 init_xfs_fs(void)
 {
 	int			error;
@@ -1806,21 +1763,19 @@ init_xfs_fs(void)
 	if (error)
 		goto out_cleanup_procfs;
 
-	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_CPU_INTENSIVE, 8);
-	if (!xfs_syncd_wq) {
-		error = -ENOMEM;
+	error = xfs_init_workqueues();
+	if (error)
 		goto out_sysctl_unregister;
-	}
 
 	vfs_initquota();
 
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
-		goto out_destroy_xfs_syncd;
+		goto out_destroy_wq;
 	return 0;
 
-out_destroy_xfs_syncd:
-	destroy_workqueue(xfs_syncd_wq);
+out_destroy_wq:
+	xfs_destroy_workqueues();
 out_sysctl_unregister:
 	xfs_sysctl_unregister();
 out_cleanup_procfs:
@@ -1842,7 +1797,7 @@ exit_xfs_fs(void)
 {
 	vfs_exitquota();
 	unregister_filesystem(&xfs_fs_type);
-	destroy_workqueue(xfs_syncd_wq);
+	xfs_destroy_workqueues();
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
 	xfs_buf_terminate();
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 12aff95..8b68679 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -28,6 +28,8 @@
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
 
+struct workqueue_struct	*xfs_ail_wq;	/* AIL workqueue */
+
 STATIC void xfs_ail_splice(struct xfs_ail *, struct list_head *, xfs_lsn_t);
 STATIC void xfs_ail_delete(struct xfs_ail *, xfs_log_item_t *);
 STATIC xfs_log_item_t * xfs_ail_min(struct xfs_ail *);
@@ -69,36 +71,6 @@ xfs_trans_ail_tail(
 }
 
 /*
- * xfs_trans_push_ail
- *
- * This routine is called to move the tail of the AIL forward.  It does this by
- * trying to flush items in the AIL whose lsns are below the given
- * threshold_lsn.
- *
- * the push is run asynchronously in a separate thread, so we return the tail
- * of the log right now instead of the tail after the push. This means we will
- * either continue right away, or we will sleep waiting on the async thread to
- * do its work.
- *
- * We do this unlocked - we only need to know whether there is anything in the
- * AIL at the time we are called. We don't need to access the contents of
- * any of the objects, so the lock is not needed.
- */
-void
-xfs_trans_ail_push(
-	struct xfs_ail	*ailp,
-	xfs_lsn_t	threshold_lsn)
-{
-	xfs_log_item_t	*lip;
-
-	lip = xfs_ail_min(ailp);
-	if (lip && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
-		if (XFS_LSN_CMP(threshold_lsn, ailp->xa_target) > 0)
-			xfsaild_wakeup(ailp, threshold_lsn);
-	}
-}
-
-/*
  * AIL traversal cursor initialisation.
  *
  * The cursor keeps track of where our current traversal is up
@@ -236,16 +208,16 @@ out:
 }
 
 /*
- * xfsaild_push does the work of pushing on the AIL.  Returning a timeout of
- * zero indicates that the caller should sleep until woken.
+ * xfs_ail_worker does the work of pushing on the AIL. It will requeue itself
+ * to run at a later time if there is more work to do to complete the push.
  */
-long
-xfsaild_push(
-	struct xfs_ail	*ailp,
-	xfs_lsn_t	*last_lsn)
+STATIC void
+xfs_ail_worker(
+	struct work_struct *work)
 {
+	struct xfs_ail	*ailp = container_of(to_delayed_work(work),
+					struct xfs_ail, xa_work);
 	long		tout = 0;
-	xfs_lsn_t	last_pushed_lsn = *last_lsn;
 	xfs_lsn_t	target =  ailp->xa_target;
 	xfs_lsn_t	lsn;
 	xfs_log_item_t	*lip;
@@ -256,15 +228,15 @@ xfsaild_push(
 
 	spin_lock(&ailp->xa_lock);
 	xfs_trans_ail_cursor_init(ailp, cur);
-	lip = xfs_trans_ail_cursor_first(ailp, cur, *last_lsn);
+	lip = xfs_trans_ail_cursor_first(ailp, cur, ailp->xa_last_pushed_lsn);
 	if (!lip || XFS_FORCED_SHUTDOWN(mp)) {
 		/*
 		 * AIL is empty or our push has reached the end.
 		 */
 		xfs_trans_ail_cursor_done(ailp, cur);
 		spin_unlock(&ailp->xa_lock);
-		*last_lsn = 0;
-		return tout;
+		ailp->xa_last_pushed_lsn = 0;
+		return;
 	}
 
 	XFS_STATS_INC(xs_push_ail);
@@ -301,13 +273,13 @@ xfsaild_push(
 		case XFS_ITEM_SUCCESS:
 			XFS_STATS_INC(xs_push_ail_success);
 			IOP_PUSH(lip);
-			last_pushed_lsn = lsn;
+			ailp->xa_last_pushed_lsn = lsn;
 			break;
 
 		case XFS_ITEM_PUSHBUF:
 			XFS_STATS_INC(xs_push_ail_pushbuf);
 			IOP_PUSHBUF(lip);
-			last_pushed_lsn = lsn;
+			ailp->xa_last_pushed_lsn = lsn;
 			push_xfsbufd = 1;
 			break;
 
@@ -319,7 +291,7 @@ xfsaild_push(
 
 		case XFS_ITEM_LOCKED:
 			XFS_STATS_INC(xs_push_ail_locked);
-			last_pushed_lsn = lsn;
+			ailp->xa_last_pushed_lsn = lsn;
 			stuck++;
 			break;
 
@@ -376,7 +348,7 @@ xfsaild_push(
 
 	if (!count) {
 		/* We're past our target or empty, so idle */
-		last_pushed_lsn = 0;
+		ailp->xa_last_pushed_lsn = 0;
 	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
 		/*
 		 * We reached the target so wait a bit longer for I/O to
@@ -384,7 +356,7 @@ xfsaild_push(
 		 * start the next scan from the start of the AIL.
 		 */
 		tout = 50;
-		last_pushed_lsn = 0;
+		ailp->xa_last_pushed_lsn = 0;
 	} else if ((stuck * 100) / count > 90) {
 		/*
 		 * Either there is a lot of contention on the AIL or we
@@ -400,10 +372,63 @@ xfsaild_push(
 		/* more to do, but wait a short while before continuing */
 		tout = 10;
 	}
-	*last_lsn = last_pushed_lsn;
-	return tout;
+
+	/*
+	 * If there is more to do, requeue us. Otherwise the next push will
+	 * start us again.
+	 */
+	if (tout)
+		queue_delayed_work(xfs_syncd_wq, &ailp->xa_work, tout);
 }
 
+/*
+ * Kick the AIL workqueue into action.
+ *
+ * If we already have work in progress, we do not queue new work, simply move
+ * the target forwards. Otherwise queue for the given amount of time in the
+ * future.
+ */
+static void
+xfs_ail_push_queue(
+	struct xfs_ail		*ailp,
+	xfs_lsn_t		threshold_lsn,
+	int			tout)
+{
+	if (XFS_LSN_CMP(threshold_lsn, ailp->xa_target) > 0) {
+		ailp->xa_target = threshold_lsn;
+		queue_delayed_work(xfs_syncd_wq, &ailp->xa_work, tout);
+	}
+}
+
+/*
+ * xfs_trans_push_ail
+ *
+ * This routine is called to move the tail of the AIL forward.  It does this by
+ * trying to flush items in the AIL whose lsns are below the given
+ * threshold_lsn.
+ *
+ * the push is run asynchronously in a workqueue, so we return the tail
+ * of the log right now instead of the tail after the push. This means we will
+ * either continue right away, or we will sleep waiting on the async thread to
+ * do its work. We don't want the workqueue to interrupt any backoff it is
+ * current engaged in, so start the flush in a short while rather than
+ * immediately.
+ *
+ * We do this unlocked - we only need to know whether there is anything in the
+ * AIL at the time we are called. We don't need to access the contents of
+ * any of the objects, so the lock is not needed.
+ */
+void
+xfs_trans_ail_push(
+	struct xfs_ail	*ailp,
+	xfs_lsn_t	threshold_lsn)
+{
+	xfs_log_item_t	*lip;
+
+	lip = xfs_ail_min(ailp);
+	if (lip && !XFS_FORCED_SHUTDOWN(ailp->xa_mount))
+		xfs_ail_push_queue(ailp, threshold_lsn, 1);
+}
 
 /*
  * This is to be called when an item is unlocked that may have
@@ -615,7 +640,6 @@ xfs_trans_ail_init(
 	xfs_mount_t	*mp)
 {
 	struct xfs_ail	*ailp;
-	int		error;
 
 	ailp = kmem_zalloc(sizeof(struct xfs_ail), KM_MAYFAIL);
 	if (!ailp)
@@ -624,15 +648,9 @@ xfs_trans_ail_init(
 	ailp->xa_mount = mp;
 	INIT_LIST_HEAD(&ailp->xa_ail);
 	spin_lock_init(&ailp->xa_lock);
-	error = xfsaild_start(ailp);
-	if (error)
-		goto out_free_ailp;
+	INIT_DELAYED_WORK(&ailp->xa_work, xfs_ail_worker);
 	mp->m_ail = ailp;
 	return 0;
-
-out_free_ailp:
-	kmem_free(ailp);
-	return error;
 }
 
 void
@@ -641,7 +659,7 @@ xfs_trans_ail_destroy(
 {
 	struct xfs_ail	*ailp = mp->m_ail;
 
-	xfsaild_stop(ailp);
+	cancel_delayed_work_sync(&ailp->xa_work);
 	kmem_free(ailp);
 }
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 35162c2..2410da4 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -66,15 +66,19 @@ struct xfs_ail {
 	struct xfs_mount	*xa_mount;
 	struct list_head	xa_ail;
 	uint			xa_gen;
-	struct task_struct	*xa_task;
 	xfs_lsn_t		xa_target;
 	struct xfs_ail_cursor	xa_cursors;
 	spinlock_t		xa_lock;
+	struct delayed_work	xa_work;
+	xfs_lsn_t		xa_last_pushed_lsn;
 };
 
 /*
  * From xfs_trans_ail.c
  */
+
+extern struct workqueue_struct	*xfs_ail_wq;	/* AIL workqueue */
+
 void	xfs_trans_ail_update_bulk(struct xfs_ail *ailp,
 				struct xfs_log_item **log_items, int nr_items,
 				xfs_lsn_t lsn) __releases(ailp->xa_lock);
@@ -112,11 +116,6 @@ struct xfs_log_item	*xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
 void			xfs_trans_ail_cursor_done(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur);
 
-long	xfsaild_push(struct xfs_ail *, xfs_lsn_t *);
-void	xfsaild_wakeup(struct xfs_ail *, xfs_lsn_t);
-int	xfsaild_start(struct xfs_ail *);
-void	xfsaild_stop(struct xfs_ail *);
-
 #if BITS_PER_LONG != 64
 static inline void
 xfs_trans_ail_copy_lsn(
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
