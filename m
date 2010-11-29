Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bEZu082061 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:14 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C1F21C7C51C
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:38:54 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	UG0IHJR085rLfBxa for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:38:54 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	47821747-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:08:53 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMshf-0000dM-Hi
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:51 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMshQ-0005cQ-3A
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/14] xfs: use wait queues directly for log grant queues
Date: Mon, 29 Nov 2010 12:38:22 +1100
Message-Id: <1290994712-21376-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1290994712-21376-1-git-send-email-david@fromorbit.com>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
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

The log grant queues are one of the few places left using sv_t
constructs for waiting. Convert them to use wait queues directly
while we are cleaning up the code to move one step closer to remove
the sv_t type from the XFS codebase.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      |   32 +++++++++++++++++++++-----------
 fs/xfs/xfs_log_priv.h |    2 +-
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 69a9563..93b5b2d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -739,7 +739,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 				break;
 			tail_lsn = 0;
 			free_bytes -= tic->t_unit_res;
-			sv_signal(&tic->t_wait);
+			wake_up(&tic->t_wait);
 		}
 	}
 
@@ -759,7 +759,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 				break;
 			tail_lsn = 0;
 			free_bytes -= need_bytes;
-			sv_signal(&tic->t_wait);
+			wake_up(&tic->t_wait);
 		}
 	}
 	spin_unlock(&log->l_grant_lock);
@@ -2537,6 +2537,7 @@ xlog_grant_log_space(
 {
 	int			 free_bytes;
 	int			 need_bytes;
+	DECLARE_WAITQUEUE(wait, current);
 
 #ifdef DEBUG
 	if (log->l_flags & XLOG_ACTIVE_RECOVERY)
@@ -2573,7 +2574,12 @@ redo:
 
 		XFS_STATS_INC(xs_sleep_logspace);
 		trace_xfs_log_grant_sleep(log, tic);
-		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
+
+		add_wait_queue_exclusive(&tic->t_wait, &wait);
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_unlock(&log->l_grant_lock);
+		schedule();
+		remove_wait_queue(&tic->t_wait, &wait);
 
 		spin_lock(&log->l_grant_lock);
 		trace_xfs_log_grant_wake(log, tic);
@@ -2617,6 +2623,7 @@ xlog_regrant_write_log_space(
 {
 	int			free_bytes;
 	int			need_bytes;
+	DECLARE_WAITQUEUE(wait, current);
 
 	tic->t_curr_res = tic->t_unit_res;
 	xlog_tic_reset_res(tic);
@@ -2662,7 +2669,7 @@ redo:
 					break;
 				}
 				free_bytes -= ntic->t_unit_res;
-				sv_signal(&ntic->t_wait);
+				wake_up(&ntic->t_wait);
 			}
 			list_add_tail(&tic->t_queue, &log->l_writeq);
 			if (woke_all)
@@ -2675,7 +2682,12 @@ redo:
 
 		XFS_STATS_INC(xs_sleep_logspace);
 		trace_xfs_log_regrant_write_sleep(log, tic);
-		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
+
+		add_wait_queue_exclusive(&tic->t_wait, &wait);
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_unlock(&log->l_grant_lock);
+		schedule();
+		remove_wait_queue(&tic->t_wait, &wait);
 
 		spin_lock(&log->l_grant_lock);
 		trace_xfs_log_regrant_write_wake(log, tic);
@@ -3237,10 +3249,8 @@ xfs_log_ticket_put(
 	xlog_ticket_t	*ticket)
 {
 	ASSERT(atomic_read(&ticket->t_ref) > 0);
-	if (atomic_dec_and_test(&ticket->t_ref)) {
-		sv_destroy(&ticket->t_wait);
+	if (atomic_dec_and_test(&ticket->t_ref))
 		kmem_zone_free(xfs_log_ticket_zone, ticket);
-	}
 }
 
 xlog_ticket_t *
@@ -3373,7 +3383,7 @@ xlog_ticket_alloc(
 	tic->t_trans_type	= 0;
 	if (xflags & XFS_LOG_PERM_RESERV)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
-	sv_init(&tic->t_wait, SV_DEFAULT, "logtick");
+	init_waitqueue_head(&tic->t_wait);
 
 	xlog_tic_reset_res(tic);
 
@@ -3701,10 +3711,10 @@ xfs_log_force_umount(
 	 * action is protected by the GRANTLOCK.
 	 */
 	list_for_each_entry(tic, &log->l_reserveq, t_queue)
-		sv_signal(&tic->t_wait);
+		wake_up(&tic->t_wait);
 
 	list_for_each_entry(tic, &log->l_writeq, t_queue)
-		sv_signal(&tic->t_wait);
+		wake_up(&tic->t_wait);
 	spin_unlock(&log->l_grant_lock);
 
 	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 4ebaf07..6fcee10 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -242,7 +242,7 @@ typedef struct xlog_res {
 } xlog_res_t;
 
 typedef struct xlog_ticket {
-	sv_t		   t_wait;	 /* ticket wait queue            : 20 */
+	wait_queue_head_t  t_wait;	 /* ticket wait queue */
 	struct list_head   t_queue;	 /* reserve/write queue */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
 	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
