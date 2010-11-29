Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bZJ8082254 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 816661AE784
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:39:14 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	UrZLyEk72BjYtJPa for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:39:14 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48421691-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:09:13 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMshz-0000dx-NK
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:39:11 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMshQ-0005ce-Ah
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/14] xfs: introduce new locks for the log grant ticket wait
	queues
Date: Mon, 29 Nov 2010 12:38:27 +1100
Message-Id: <1290994712-21376-10-git-send-email-david@fromorbit.com>
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

The log grant ticket wait queues are currently protected by the log
grant lock.  However, the queues are functionally independent from
each other, and operations on them only require serialisation
against other queue operations now that all of the other log
variables they use are atomic values.

Hence, we can make them independent of the grant lock by introducing
new locks just to protect the lists operations. because the lists
are independent, we can use a lock per list and ensure that reserve
and write head queuing do not contend.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      |  116 +++++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_log_priv.h |   16 +++++--
 2 files changed, 100 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6298310..8365496 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -727,12 +727,12 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 	if (tail_lsn != 1)
 		atomic64_set(&log->l_tail_lsn, tail_lsn);
 
-	spin_lock(&log->l_grant_lock);
-	if (!list_empty(&log->l_writeq)) {
+	if (!list_empty_careful(&log->l_writeq)) {
 #ifdef DEBUG
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
 #endif
+		spin_lock(&log->l_grant_write_lock);
 		free_bytes = xlog_space_left(log->l_logsize,
 				atomic64_read(&log->l_tail_lsn),
 				atomic64_read(&log->l_grant_write_head));
@@ -745,13 +745,15 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 			free_bytes -= tic->t_unit_res;
 			wake_up(&tic->t_wait);
 		}
+		spin_unlock(&log->l_grant_write_lock);
 	}
 
-	if (!list_empty(&log->l_reserveq)) {
+	if (!list_empty_careful(&log->l_reserveq)) {
 #ifdef DEBUG
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
 #endif
+		spin_lock(&log->l_grant_reserve_lock);
 		free_bytes = xlog_space_left(log->l_logsize,
 				atomic64_read(&log->l_tail_lsn),
 				atomic64_read(&log->l_grant_reserve_head));
@@ -766,9 +768,9 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 			free_bytes -= need_bytes;
 			wake_up(&tic->t_wait);
 		}
+		spin_unlock(&log->l_grant_reserve_lock);
 	}
-	spin_unlock(&log->l_grant_lock);
-}	/* xfs_log_move_tail */
+}
 
 /*
  * Determine if we have a transaction that has gone to disk
@@ -1056,6 +1058,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	atomic64_set(&log->l_grant_write_head, xlog_assign_lsn(1, 0));
 	INIT_LIST_HEAD(&log->l_reserveq);
 	INIT_LIST_HEAD(&log->l_writeq);
+	spin_lock_init(&log->l_grant_reserve_lock);
+	spin_lock_init(&log->l_grant_write_lock);
 
 	error = EFSCORRUPTED;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
@@ -2525,6 +2529,18 @@ restart:
  *
  * Once a ticket gets put onto the reserveq, it will only return after
  * the needed reservation is satisfied.
+ *
+ * This function is structured so that it has a lock free fast path. This is
+ * necessary because every new transaction reservation will come through this
+ * path. Hence any lock will be globally hot if we take it unconditionally on
+ * every pass.
+ *
+ * As tickets are only ever moved on and off the reserveq under the
+ * l_grant_reserve_lock, we only need to take that lock if we are going
+ * to add the ticket to the queue and sleep. We can avoid taking the lock if the
+ * ticket was never added to the reserveq because the t_queue list head will be
+ * empty and we hold the only reference to it so it can safely be checked
+ * unlocked.
  */
 STATIC int
 xlog_grant_log_space(
@@ -2540,8 +2556,6 @@ xlog_grant_log_space(
 		panic("grant Recovery problem");
 #endif
 
-	/* Is there space or do we need to sleep? */
-	spin_lock(&log->l_grant_lock);
 	trace_xfs_log_grant_enter(log, tic);
 	ASSERT(list_empty(&tic->t_queue));
 
@@ -2561,9 +2575,19 @@ redo:
 	 * are not already on the queue, we need to wait.
 	 */
 	if (free_bytes < need_bytes ||
-	    (!list_empty(&log->l_reserveq) && list_empty(&tic->t_queue))) {
-		if (list_empty(&tic->t_queue))
+	    (list_empty(&tic->t_queue) &&
+	     !list_empty_careful(&log->l_reserveq))) {
+
+		spin_lock(&log->l_grant_reserve_lock);
+		if (list_empty(&tic->t_queue)) {
+			/* recheck the queue now we are locked */
+			if (list_empty(&log->l_reserveq) &&
+			    free_bytes >= need_bytes) {
+				spin_unlock(&log->l_grant_reserve_lock);
+				goto redo;
+			}
 			list_add_tail(&tic->t_queue, &log->l_reserveq);
+		}
 
 		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
 				    atomic64_read(&log->l_last_sync_lsn),
@@ -2572,20 +2596,29 @@ redo:
 		XFS_STATS_INC(xs_sleep_logspace);
 		trace_xfs_log_grant_sleep(log, tic);
 
+		/* co-ordinate with xfs_log_force_shutdown */
+		if (XLOG_FORCED_SHUTDOWN(log)) {
+			spin_unlock(&log->l_grant_reserve_lock);
+			goto error_return;
+		}
 		add_wait_queue_exclusive(&tic->t_wait, &wait);
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock(&log->l_grant_lock);
+		spin_unlock(&log->l_grant_reserve_lock);
 		schedule();
 		remove_wait_queue(&tic->t_wait, &wait);
 
-		spin_lock(&log->l_grant_lock);
 		trace_xfs_log_grant_wake(log, tic);
 		goto redo;
 	}
 
-	list_del_init(&tic->t_queue);
+	if (!list_empty(&tic->t_queue)) {
+		spin_lock(&log->l_grant_reserve_lock);
+		list_del_init(&tic->t_queue);
+		spin_unlock(&log->l_grant_reserve_lock);
+	}
 
 	/* we've got enough space */
+	spin_lock(&log->l_grant_lock);
 	xlog_grant_add_space(log, need_bytes);
 
 	trace_xfs_log_grant_exit(log, tic);
@@ -2595,7 +2628,9 @@ redo:
 	return 0;
 
  error_return:
+	spin_lock(&log->l_grant_reserve_lock);
 	list_del_init(&tic->t_queue);
+	spin_unlock(&log->l_grant_reserve_lock);
 	trace_xfs_log_grant_error(log, tic);
 
 	/*
@@ -2605,13 +2640,15 @@ redo:
 	 */
 	tic->t_curr_res = 0;
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	spin_unlock(&log->l_grant_lock);
 	return XFS_ERROR(EIO);
 }
 
 
 /*
  * Replenish the byte reservation required by moving the grant write head.
+ *
+ * Similar to xlog_grant_log_space, the function is structured to have a lock
+ * free fast path.
  */
 STATIC int
 xlog_regrant_write_log_space(
@@ -2633,7 +2670,6 @@ xlog_regrant_write_log_space(
 		panic("regrant Recovery problem");
 #endif
 
-	spin_lock(&log->l_grant_lock);
 	trace_xfs_log_regrant_write_enter(log, tic);
 	ASSERT(list_empty(&tic->t_queue));
 
@@ -2650,15 +2686,26 @@ redo:
 	 * are not already on the queue, we need to wait.
 	 */
 	if (free_bytes < need_bytes ||
-	    (!list_empty(&log->l_writeq) && list_empty(&tic->t_queue))) {
+	    (list_empty(&tic->t_queue) &&
+	     !list_empty_careful(&log->l_writeq))) {
+
+		spin_lock(&log->l_grant_write_lock);
 		if (list_empty(&tic->t_queue)) {
+			struct xlog_ticket	*ntic;
+			int			woke_all = 1;
+
+			/* recheck the queue now we are locked */
+			if (list_empty(&log->l_writeq) &&
+			    free_bytes >= need_bytes) {
+				spin_unlock(&log->l_grant_write_lock);
+				goto redo;
+			}
+
 			/*
 			 * give existing waiters a chance at logspace before
 			 * us.  If we woke all the waiters, then immediately
 			 * retry the space, otherwise sleep first.
 			 */
-			struct xlog_ticket	*ntic;
-			int			woke_all = 1;
 			list_for_each_entry(ntic, &log->l_writeq, t_queue) {
 				ASSERT(ntic->t_flags & XLOG_TIC_PERM_RESERV);
 
@@ -2670,8 +2717,10 @@ redo:
 				wake_up(&ntic->t_wait);
 			}
 			list_add_tail(&tic->t_queue, &log->l_writeq);
-			if (woke_all)
+			if (woke_all) {
+				spin_unlock(&log->l_grant_write_lock);
 				goto redo;
+			}
 		}
 
 		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
@@ -2681,20 +2730,29 @@ redo:
 		XFS_STATS_INC(xs_sleep_logspace);
 		trace_xfs_log_regrant_write_sleep(log, tic);
 
+		/* co-ordinate with xfs_log_force_shutdown */
+		if (XLOG_FORCED_SHUTDOWN(log)) {
+			spin_unlock(&log->l_grant_write_lock);
+			goto error_return;
+		}
 		add_wait_queue_exclusive(&tic->t_wait, &wait);
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock(&log->l_grant_lock);
+		spin_unlock(&log->l_grant_write_lock);
 		schedule();
 		remove_wait_queue(&tic->t_wait, &wait);
 
-		spin_lock(&log->l_grant_lock);
 		trace_xfs_log_regrant_write_wake(log, tic);
 		goto redo;
 	}
 
-	list_del_init(&tic->t_queue);
+	if (!list_empty(&tic->t_queue)) {
+		spin_lock(&log->l_grant_write_lock);
+		list_del_init(&tic->t_queue);
+		spin_unlock(&log->l_grant_write_lock);
+	}
 
 	/* we've got enough space */
+	spin_lock(&log->l_grant_lock);
 	xlog_grant_add_space_write(log, need_bytes);
 
 	trace_xfs_log_regrant_write_exit(log, tic);
@@ -2705,7 +2763,9 @@ redo:
 
 
  error_return:
+	spin_lock(&log->l_grant_write_lock);
 	list_del_init(&tic->t_queue);
+	spin_unlock(&log->l_grant_write_lock);
 	trace_xfs_log_regrant_write_error(log, tic);
 
 	/*
@@ -2715,7 +2775,6 @@ redo:
 	 */
 	tic->t_curr_res = 0;
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	spin_unlock(&log->l_grant_lock);
 	return XFS_ERROR(EIO);
 }
 
@@ -3676,12 +3735,10 @@ xfs_log_force_umount(
 		xlog_cil_force(log);
 
 	/*
-	 * We must hold both the GRANT lock and the LOG lock,
-	 * before we mark the filesystem SHUTDOWN and wake
-	 * everybody up to tell the bad news.
+	 * mark the filesystem and the as in a shutdown state and wake
+	 * everybody up to tell them the bad news.
 	 */
 	spin_lock(&log->l_icloglock);
-	spin_lock(&log->l_grant_lock);
 	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
 	if (mp->m_sb_bp)
 		XFS_BUF_DONE(mp->m_sb_bp);
@@ -3706,14 +3763,17 @@ xfs_log_force_umount(
 	 * means we have to wake up everybody queued up on reserveq as well as
 	 * writeq.  In addition, we make sure in xlog_{re}grant_log_space that
 	 * we don't enqueue anything once the SHUTDOWN flag is set, and this
-	 * action is protected by the GRANTLOCK.
+	 * action is protected by the grant locks.
 	 */
+	spin_lock(&log->l_grant_reserve_lock);
 	list_for_each_entry(tic, &log->l_reserveq, t_queue)
 		wake_up(&tic->t_wait);
+	spin_unlock(&log->l_grant_reserve_lock);
 
+	spin_lock(&log->l_grant_write_lock);
 	list_for_each_entry(tic, &log->l_writeq, t_queue)
 		wake_up(&tic->t_wait);
-	spin_unlock(&log->l_grant_lock);
+	spin_unlock(&log->l_grant_write_lock);
 
 	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
 		ASSERT(!logerror);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 971dc8a..621002c 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -514,10 +514,6 @@ typedef struct log {
 
 	/* The following block of fields are changed while holding grant_lock */
 	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
-	struct list_head	l_reserveq;
-	struct list_head	l_writeq;
-	atomic64_t		l_grant_reserve_head;
-	atomic64_t		l_grant_write_head;
 
 	/*
 	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
@@ -530,6 +526,18 @@ typedef struct log {
 	/* lsn of 1st LR with unflushed * buffers */
 	atomic64_t		l_tail_lsn ____cacheline_aligned_in_smp;
 
+	/*
+	 * ticket grant locks, queues and accounting have their own cachlines
+	 * as these are quite hot and can be operated on concurrently.
+	 */
+	spinlock_t		l_grant_reserve_lock ____cacheline_aligned_in_smp;
+	struct list_head	l_reserveq;
+	atomic64_t		l_grant_reserve_head;
+
+	spinlock_t		l_grant_write_lock ____cacheline_aligned_in_smp;
+	struct list_head	l_writeq;
+	atomic64_t		l_grant_write_head;
+
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
 	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
