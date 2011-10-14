Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9EIr5Se043330 for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 13:53:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC6001473DAB
	for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 12:00:36 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	MGP0P8nTXF4SbH6o for <xfs@oss.sgi.com>;
	Fri, 14 Oct 2011 12:00:36 -0700 (PDT)
Message-Id: <20111014185301.722534249@bombadil.infradead.org>
Date: Fri, 14 Oct 2011 14:50:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfs: revert to using a kthread for AIL pushing
References: <20111014185048.893798829@bombadil.infradead.org>
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

commit 0030807c66f058230bcb20d2573bcaf28852e804 upstream

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

Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-10-14 14:43:45.316393949 +0200
+++ xfs/fs/xfs/xfs_trans_ail.c	2011-10-14 14:45:11.937395278 +0200
@@ -28,8 +28,6 @@
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
 
-struct workqueue_struct	*xfs_ail_wq;	/* AIL workqueue */
-
 #ifdef DEBUG
 /*
  * Check that the list is sorted as it should be.
@@ -406,16 +404,10 @@ xfs_ail_delete(
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
 	struct xfs_ail_cursor	*cur = &ailp->xa_cursors;
 	xfs_log_item_t		*lip;
@@ -556,20 +548,6 @@ out_done:
 		/* We're past our target or empty, so idle */
 		ailp->xa_last_pushed_lsn = 0;
 
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
@@ -592,9 +570,30 @@ out_done:
 		tout = 20;
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
@@ -629,8 +628,9 @@ xfs_ail_push(
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
@@ -865,9 +865,18 @@ xfs_trans_ail_init(
 	ailp->xa_mount = mp;
 	INIT_LIST_HEAD(&ailp->xa_ail);
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
@@ -876,6 +885,6 @@ xfs_trans_ail_destroy(
 {
 	struct xfs_ail	*ailp = mp->m_ail;
 
-	cancel_delayed_work_sync(&ailp->xa_work);
+	kthread_stop(ailp->xa_task);
 	kmem_free(ailp);
 }
Index: xfs/fs/xfs/xfs_trans_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_priv.h	2011-10-14 14:42:03.000000000 +0200
+++ xfs/fs/xfs/xfs_trans_priv.h	2011-10-14 14:45:38.191895324 +0200
@@ -64,23 +64,17 @@ struct xfs_ail_cursor {
  */
 struct xfs_ail {
 	struct xfs_mount	*xa_mount;
+	struct task_struct	*xa_task;
 	struct list_head	xa_ail;
 	xfs_lsn_t		xa_target;
 	struct xfs_ail_cursor	xa_cursors;
 	spinlock_t		xa_lock;
-	struct delayed_work	xa_work;
 	xfs_lsn_t		xa_last_pushed_lsn;
-	unsigned long		xa_flags;
 };
 
-#define XFS_AIL_PUSHING_BIT	0
-
 /*
  * From xfs_trans_ail.c
  */
-
-extern struct workqueue_struct	*xfs_ail_wq;	/* AIL workqueue */
-
 void	xfs_trans_ail_update_bulk(struct xfs_ail *ailp,
 				struct xfs_ail_cursor *cur,
 				struct xfs_log_item **log_items, int nr_items,
Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2011-10-14 14:41:41.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2011-10-14 14:45:11.941411722 +0200
@@ -70,6 +70,8 @@
 #include <linux/ctype.h>
 #include <linux/writeback.h>
 #include <linux/capability.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <linux/list_sort.h>
 
 #include <asm/page.h>
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-10-14 14:46:38.497394866 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-10-14 14:46:49.047894210 +0200
@@ -1660,24 +1660,13 @@ xfs_init_workqueues(void)
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
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
