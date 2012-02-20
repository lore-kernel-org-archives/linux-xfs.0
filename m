Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K2matx042610 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 20:48:36 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	k1hOQUDHlZz6D6yv (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 18:31:53 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RzJ2e-0005ex-SA
	for xfs@oss.sgi.com; Mon, 20 Feb 2012 02:31:52 +0000
Message-Id: <20120220023152.817950376@bombadil.infradead.org>
Date: Sun, 19 Feb 2012 21:31:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/12] xfs: remove log space waitqueues
References: <20120220023119.435889631@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-log-wakeup-processes
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

The tic->t_wait waitqueues can never have more than a single waiter
on them, so we can easily replace them with a task_struct pointer
and wake_up_process.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_log.c      |   24 +++++++++++++++---------
 fs/xfs/xfs_log_priv.h |    2 +-
 2 files changed, 16 insertions(+), 10 deletions(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 20:15:38.095176497 +0100
+++ xfs/fs/xfs/xfs_log.c	2011-12-11 21:28:53.101366703 +0100
@@ -169,7 +169,7 @@ xlog_reserveq_wake(
 		*free_bytes -= need_bytes;
 
 		trace_xfs_log_grant_wake_up(log, tic);
-		wake_up(&tic->t_wait);
+		wake_up_process(tic->t_task);
 	}
 
 	return true;
@@ -193,7 +193,7 @@ xlog_writeq_wake(
 		*free_bytes -= need_bytes;
 
 		trace_xfs_log_regrant_write_wake_up(log, tic);
-		wake_up(&tic->t_wait);
+		wake_up_process(tic->t_task);
 	}
 
 	return true;
@@ -212,10 +212,13 @@ xlog_reserveq_wait(
 			goto shutdown;
 		xlog_grant_push_ail(log, need_bytes);
 
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_unlock(&log->l_grant_reserve_lock);
+
 		XFS_STATS_INC(xs_sleep_logspace);
-		trace_xfs_log_grant_sleep(log, tic);
 
-		xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
+		trace_xfs_log_grant_sleep(log, tic);
+		schedule();
 		trace_xfs_log_grant_wake(log, tic);
 
 		spin_lock(&log->l_grant_reserve_lock);
@@ -243,10 +246,13 @@ xlog_writeq_wait(
 			goto shutdown;
 		xlog_grant_push_ail(log, need_bytes);
 
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_unlock(&log->l_grant_write_lock);
+
 		XFS_STATS_INC(xs_sleep_logspace);
-		trace_xfs_log_regrant_write_sleep(log, tic);
 
-		xlog_wait(&tic->t_wait, &log->l_grant_write_lock);
+		trace_xfs_log_regrant_write_sleep(log, tic);
+		schedule();
 		trace_xfs_log_regrant_write_wake(log, tic);
 
 		spin_lock(&log->l_grant_write_lock);
@@ -3276,6 +3282,7 @@ xlog_ticket_alloc(
         }
 
 	atomic_set(&tic->t_ref, 1);
+	tic->t_task		= current;
 	INIT_LIST_HEAD(&tic->t_queue);
 	tic->t_unit_res		= unit_bytes;
 	tic->t_curr_res		= unit_bytes;
@@ -3287,7 +3294,6 @@ xlog_ticket_alloc(
 	tic->t_trans_type	= 0;
 	if (xflags & XFS_LOG_PERM_RESERV)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
-	init_waitqueue_head(&tic->t_wait);
 
 	xlog_tic_reset_res(tic);
 
@@ -3615,12 +3621,12 @@ xfs_log_force_umount(
 	 */
 	spin_lock(&log->l_grant_reserve_lock);
 	list_for_each_entry(tic, &log->l_reserveq, t_queue)
-		wake_up(&tic->t_wait);
+		wake_up_process(tic->t_task);
 	spin_unlock(&log->l_grant_reserve_lock);
 
 	spin_lock(&log->l_grant_write_lock);
 	list_for_each_entry(tic, &log->l_writeq, t_queue)
-		wake_up(&tic->t_wait);
+		wake_up_process(tic->t_task);
 	spin_unlock(&log->l_grant_write_lock);
 
 	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
Index: xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log_priv.h	2011-12-11 20:15:35.918521622 +0100
+++ xfs/fs/xfs/xfs_log_priv.h	2011-12-11 21:28:53.114699966 +0100
@@ -239,8 +239,8 @@ typedef struct xlog_res {
 } xlog_res_t;
 
 typedef struct xlog_ticket {
-	wait_queue_head_t  t_wait;	 /* ticket wait queue */
 	struct list_head   t_queue;	 /* reserve/write queue */
+	struct task_struct *t_task;	 /* task that owns this ticket */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
 	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
