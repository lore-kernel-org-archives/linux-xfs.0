Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p371sXKv067128 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 20:54:33 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A67023AF841
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 18:57:47 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	F7wZ1znZKxMJmKqs for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 18:57:47 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q7eTN-00063N-Uh
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 11:57:25 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q7eTQ-00079m-JG
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 11:57:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/9] xfs: convert the xfsaild threads to a workqueue
Date: Thu,  7 Apr 2011 11:57:21 +1000
Message-Id: <1302141445-27457-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1302141445-27457-1-git-send-email-david@fromorbit.com>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_super.c |  115 ++++++++++++------------------------
 fs/xfs/xfs_trans_ail.c       |  133 +++++++++++++++++++++++-------------------
 fs/xfs/xfs_trans_priv.h      |   15 +++--
 3 files changed, 118 insertions(+), 145 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a20071f..b5674ed 100644
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
@@ -1786,6 +1717,32 @@ xfs_destroy_zones(void)
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
@@ -1800,10 +1757,14 @@ init_xfs_fs(void)
 	if (error)
 		goto out;
 
-	error = xfs_mru_cache_init();
+	error = xfs_init_workqueues();
 	if (error)
 		goto out_destroy_zones;
 
+	error = xfs_mru_cache_init();
+	if (error)
+		goto out_destroy_wq;
+
 	error = xfs_filestream_init();
 	if (error)
 		goto out_mru_cache_uninit;
@@ -1820,21 +1781,17 @@ init_xfs_fs(void)
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
+		goto out_sysctl_unregister;
 	return 0;
 
- out_destroy_xfs_syncd:
-	destroy_workqueue(xfs_syncd_wq);
  out_sysctl_unregister:
 	xfs_sysctl_unregister();
  out_cleanup_procfs:
@@ -1845,6 +1802,8 @@ init_xfs_fs(void)
 	xfs_filestream_uninit();
  out_mru_cache_uninit:
 	xfs_mru_cache_uninit();
+ out_destroy_wq:
+	xfs_destroy_workqueues();
  out_destroy_zones:
 	xfs_destroy_zones();
  out:
@@ -1856,12 +1815,12 @@ exit_xfs_fs(void)
 {
 	vfs_exitquota();
 	unregister_filesystem(&xfs_fs_type);
-	destroy_workqueue(xfs_syncd_wq);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
 	xfs_buf_terminate();
 	xfs_filestream_uninit();
 	xfs_mru_cache_uninit();
+	xfs_destroy_workqueues();
 	xfs_destroy_zones();
 }
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 12aff95..cb3aeac 100644
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
-	long		tout = 0;
-	xfs_lsn_t	last_pushed_lsn = *last_lsn;
+	struct xfs_ail	*ailp = container_of(to_delayed_work(work),
+					struct xfs_ail, xa_work);
+	long		tout;
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
 
@@ -374,9 +346,23 @@ xfsaild_push(
 		wake_up_process(mp->m_ddev_targp->bt_task);
 	}
 
+	/* assume we have more work to do in a short while */
+	tout = 10;
 	if (!count) {
 		/* We're past our target or empty, so idle */
-		last_pushed_lsn = 0;
+		ailp->xa_last_pushed_lsn = 0;
+
+		/*
+		 * Check for an updated push target before clearing the
+		 * XFS_AIL_PUSHING_BIT. If the target changed, we've got more
+		 * work to do. Wait a bit longer before starting that work.
+		 */
+		smp_rmb();
+		if (ailp->xa_target == target) {
+			clear_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags);
+			return;
+		}
+		tout = 50;
 	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
 		/*
 		 * We reached the target so wait a bit longer for I/O to
@@ -384,7 +370,7 @@ xfsaild_push(
 		 * start the next scan from the start of the AIL.
 		 */
 		tout = 50;
-		last_pushed_lsn = 0;
+		ailp->xa_last_pushed_lsn = 0;
 	} else if ((stuck * 100) / count > 90) {
 		/*
 		 * Either there is a lot of contention on the AIL or we
@@ -396,14 +382,48 @@ xfsaild_push(
 		 * continuing from where we were.
 		 */
 		tout = 20;
-	} else {
-		/* more to do, but wait a short while before continuing */
-		tout = 10;
 	}
-	*last_lsn = last_pushed_lsn;
-	return tout;
+
+	/* There is more to do, requeue us.  */
+	queue_delayed_work(xfs_syncd_wq, &ailp->xa_work,
+					msecs_to_jiffies(tout));
 }
 
+/*
+ * This routine is called to move the tail of the AIL forward.  It does this by
+ * trying to flush items in the AIL whose lsns are below the given
+ * threshold_lsn.
+ *
+ * The push is run asynchronously in a workqueue, which means the caller needs
+ * to handle waiting on the async flush for space to become available.
+ * We don't want to interrupt any push that is in progress, hence we only queue
+ * work if we set the pushing bit approriately.
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
+	if (!lip || XFS_FORCED_SHUTDOWN(ailp->xa_mount) ||
+	    XFS_LSN_CMP(threshold_lsn, ailp->xa_target) <= 0)
+		return;
+
+	/*
+	 * Ensure that the new target is noticed in push code before it clears
+	 * the XFS_AIL_PUSHING_BIT.
+	 */
+	smp_wmb();
+	ailp->xa_target = threshold_lsn;
+	if (!test_and_set_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags))
+		queue_delayed_work(xfs_syncd_wq, &ailp->xa_work, 0);
+}
 
 /*
  * This is to be called when an item is unlocked that may have
@@ -615,7 +635,6 @@ xfs_trans_ail_init(
 	xfs_mount_t	*mp)
 {
 	struct xfs_ail	*ailp;
-	int		error;
 
 	ailp = kmem_zalloc(sizeof(struct xfs_ail), KM_MAYFAIL);
 	if (!ailp)
@@ -624,15 +643,9 @@ xfs_trans_ail_init(
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
@@ -641,7 +654,7 @@ xfs_trans_ail_destroy(
 {
 	struct xfs_ail	*ailp = mp->m_ail;
 
-	xfsaild_stop(ailp);
+	cancel_delayed_work_sync(&ailp->xa_work);
 	kmem_free(ailp);
 }
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 35162c2..6ebd322 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -65,16 +65,22 @@ struct xfs_ail_cursor {
 struct xfs_ail {
 	struct xfs_mount	*xa_mount;
 	struct list_head	xa_ail;
-	uint			xa_gen;
-	struct task_struct	*xa_task;
 	xfs_lsn_t		xa_target;
 	struct xfs_ail_cursor	xa_cursors;
 	spinlock_t		xa_lock;
+	struct delayed_work	xa_work;
+	xfs_lsn_t		xa_last_pushed_lsn;
+	unsigned long		xa_flags;
 };
 
+#define XFS_AIL_PUSHING_BIT	0
+
 /*
  * From xfs_trans_ail.c
  */
+
+extern struct workqueue_struct	*xfs_ail_wq;	/* AIL workqueue */
+
 void	xfs_trans_ail_update_bulk(struct xfs_ail *ailp,
 				struct xfs_log_item **log_items, int nr_items,
 				xfs_lsn_t lsn) __releases(ailp->xa_lock);
@@ -112,11 +118,6 @@ struct xfs_log_item	*xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
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
