Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53WAY135142 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:33 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gxbr0Hyh21D4sV0F for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:18 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaK-0003GU-Uy
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:01 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaK-0003eR-SE
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 040/102] xfs: remove log space waitqueues
Date: Thu, 23 Aug 2012 15:01:58 +1000
Message-Id: <1345698180-13612-41-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 14a7235fba4302a82d61150eda92ec90d3ae9cfb

The tic->t_wait waitqueues can never have more than a single waiter
on them, so we can easily replace them with a task_struct pointer
and wake_up_process.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_log.c      |   24 +++++++++++++++---------
 fs/xfs/xfs_log_priv.h |    2 +-
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d299223..fc2b84b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
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
@@ -3327,6 +3333,7 @@ xlog_ticket_alloc(
         }
 
 	atomic_set(&tic->t_ref, 1);
+	tic->t_task		= current;
 	INIT_LIST_HEAD(&tic->t_queue);
 	tic->t_unit_res		= unit_bytes;
 	tic->t_curr_res		= unit_bytes;
@@ -3338,7 +3345,6 @@ xlog_ticket_alloc(
 	tic->t_trans_type	= 0;
 	if (xflags & XFS_LOG_PERM_RESERV)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
-	init_waitqueue_head(&tic->t_wait);
 
 	xlog_tic_reset_res(tic);
 
@@ -3666,12 +3672,12 @@ xfs_log_force_umount(
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
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 785905e..d8c5e47 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -239,8 +239,8 @@ typedef struct xlog_res {
 } xlog_res_t;
 
 typedef struct xlog_ticket {
-	wait_queue_head_t  t_wait;	 /* ticket wait queue */
 	struct list_head   t_queue;	 /* reserve/write queue */
+	struct task_struct *t_task;	 /* task that owns this ticket */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
 	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
