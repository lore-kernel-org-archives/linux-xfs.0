Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96IZqD9195435 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 13:35:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7334414513A1
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 11:42:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CFhDd0uRzcXJFqs1 for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 11:42:39 -0700 (PDT)
Message-Id: <20111006183549.770414484@bombadil.infradead.org>
Date: Thu, 06 Oct 2011 14:33:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] xfs: revert to using a kthread for AIL pushing
References: <20111006183257.036884724@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-ail-revert-to-kthread
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
Cc: Stefan Priebe <s.priebe@profihost.ag>

Currently we have a few issues with the way the workqueue code is used to
implement AIL pushing:

 - it accidentally uses the same workqueue as the syncer action, and thus
   can be prevented from running if there are enough sync actions active
   in the system.
 - it doesn't use the HIGHPRI flag to queue at the head of the queue of
   work items

At this point I'm not confident enough in getting all the workqueue flags and
tweaks right to provide a perfectly reliable execution context for AIL
pushing, which is the most important piece in XFS to make forward progress
when the log fills.

Revert back to use a kthread per filesystem which fixes all the above issues
at the cost of having a task struct and stack around for each mounted
filesystem.  In addition this also gives us much better ways to diagnose
any issues involving hung AIL pushing and removes a small amount of code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Tested-by: Stefan Priebe <s.priebe@profihost.ag>

Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-10-06 14:10:53.810920565 -0400
+++ xfs/fs/xfs/xfs_super.c	2011-10-06 14:22:18.951422706 -0400
@@ -1648,24 +1648,13 @@ xfs_init_workqueues(void)
 	 */
 	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_CPU_INTENSIVE, 8);
 	if (!xfs_syncd_wq)
-		goto out;
-
-	xfs_ail_wq = alloc_workqueue("xfsail", WQ_CPU_INTENSIVE, 8);
-	if (!xfs_ail_wq)
-		goto out_destroy_syncd;
-
+		return -ENOMEM;
 	return 0;
-
-out_destroy_syncd:
-	destroy_workqueue(xfs_syncd_wq);
-out:
-	return -ENOMEM;
 }
 
 STATIC void
 xfs_destroy_workqueues(void)
 {
-	destroy_workqueue(xfs_ail_wq);
 	destroy_workqueue(xfs_syncd_wq);
 }
 
Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-10-06 14:20:46.730936535 -0400
+++ xfs/fs/xfs/xfs_trans_ail.c	2011-10-06 14:22:18.955418059 -0400
@@ -28,8 +28,6 @@
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
 
-struct workqueue_struct	*xfs_ail_wq;	/* AIL workqueue */
-
 #ifdef DEBUG
 /*
  * Check that the list is sorted as it should be.
@@ -356,16 +354,10 @@ xfs_ail_delete(
 	xfs_trans_ail_cursor_clear(ailp, lip);
 }
 
-/*
- * xfs_ail_worker does the work of pushing on the AIL. It will requeue itself
- * to run at a later time if there is more work to do to complete the push.
- */
-STATIC void
-xfs_ail_worker(
-	struct work_struct	*work)
+static long
+xfsaild_push(
+	struct xfs_ail		*ailp)
 {
-	struct xfs_ail		*ailp = container_of(to_delayed_work(work),
-					struct xfs_ail, xa_work);
 	xfs_mount_t		*mp = ailp->xa_mount;
 	struct xfs_ail_cursor	cur;
 	xfs_log_item_t		*lip;
@@ -508,20 +500,6 @@ out_done:
 		ailp->xa_last_pushed_lsn = 0;
 		ailp->xa_log_flush = 0;
 
-		/*
-		 * We clear the XFS_AIL_PUSHING_BIT first before checking
-		 * whether the target has changed. If the target has changed,
-		 * this pushes the requeue race directly onto the result of the
-		 * atomic test/set bit, so we are guaranteed that either the
-		 * the pusher that changed the target or ourselves will requeue
-		 * the work (but not both).
-		 */
-		clear_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags);
-		smp_rmb();
-		if (XFS_LSN_CMP(ailp->xa_target, target) == 0 ||
-		    test_and_set_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags))
-			return;
-
 		tout = 50;
 	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
 		/*
@@ -548,9 +526,30 @@ out_done:
 		ailp->xa_last_pushed_lsn = 0;
 	}
 
-	/* There is more to do, requeue us.  */
-	queue_delayed_work(xfs_syncd_wq, &ailp->xa_work,
-					msecs_to_jiffies(tout));
+	return tout;
+}
+
+static int
+xfsaild(
+	void		*data)
+{
+	struct xfs_ail	*ailp = data;
+	long		tout = 0;	/* milliseconds */
+
+	while (!kthread_should_stop()) {
+		if (tout && tout <= 20)
+			__set_current_state(TASK_KILLABLE);
+		else
+			__set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(tout ?
+				 msecs_to_jiffies(tout) : MAX_SCHEDULE_TIMEOUT);
+
+		try_to_freeze();
+
+		tout = xfsaild_push(ailp);
+	}
+
+	return 0;
 }
 
 /*
@@ -585,8 +584,9 @@ xfs_ail_push(
 	 */
 	smp_wmb();
 	xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_lsn);
-	if (!test_and_set_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags))
-		queue_delayed_work(xfs_syncd_wq, &ailp->xa_work, 0);
+	smp_wmb();
+
+	wake_up_process(ailp->xa_task);
 }
 
 /*
@@ -824,9 +824,18 @@ xfs_trans_ail_init(
 	INIT_LIST_HEAD(&ailp->xa_ail);
 	INIT_LIST_HEAD(&ailp->xa_cursors);
 	spin_lock_init(&ailp->xa_lock);
-	INIT_DELAYED_WORK(&ailp->xa_work, xfs_ail_worker);
+
+	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
+			ailp->xa_mount->m_fsname);
+	if (IS_ERR(ailp->xa_task))
+		goto out_free_ailp;
+
 	mp->m_ail = ailp;
 	return 0;
+
+out_free_ailp:
+	kmem_free(ailp);
+	return ENOMEM;
 }
 
 void
@@ -835,6 +844,6 @@ xfs_trans_ail_destroy(
 {
 	struct xfs_ail	*ailp = mp->m_ail;
 
-	cancel_delayed_work_sync(&ailp->xa_work);
+	kthread_stop(ailp->xa_task);
 	kmem_free(ailp);
 }
Index: xfs/fs/xfs/xfs_trans_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_priv.h	2011-10-06 14:10:53.826919208 -0400
+++ xfs/fs/xfs/xfs_trans_priv.h	2011-10-06 14:22:18.963416965 -0400
@@ -64,24 +64,19 @@ struct xfs_ail_cursor {
  */
 struct xfs_ail {
 	struct xfs_mount	*xa_mount;
+	struct task_struct	*xa_task;
 	struct list_head	xa_ail;
 	xfs_lsn_t		xa_target;
 	struct list_head	xa_cursors;
 	spinlock_t		xa_lock;
-	struct delayed_work	xa_work;
 	xfs_lsn_t		xa_last_pushed_lsn;
-	unsigned long		xa_flags;
 	int			xa_log_flush;
 };
 
-#define XFS_AIL_PUSHING_BIT	0
 
 /*
  * From xfs_trans_ail.c
  */
-
-extern struct workqueue_struct	*xfs_ail_wq;	/* AIL workqueue */
-
 void	xfs_trans_ail_update_bulk(struct xfs_ail *ailp,
 				struct xfs_ail_cursor *cur,
 				struct xfs_log_item **log_items, int nr_items,
Index: xfs/fs/xfs/xfs_linux.h
===================================================================
--- xfs.orig/fs/xfs/xfs_linux.h	2011-10-06 14:10:53.838923105 -0400
+++ xfs/fs/xfs/xfs_linux.h	2011-10-06 14:22:18.967417308 -0400
@@ -68,6 +68,8 @@
 #include <linux/ctype.h>
 #include <linux/writeback.h>
 #include <linux/capability.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <linux/list_sort.h>
 
 #include <asm/page.h>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
