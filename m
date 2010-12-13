Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4tJ4s160431 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:55:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEA551CB9B1B
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:46:36 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	dTiTdbWwyHU6vXvK for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:46:36 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49889414-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:16:35 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS0Iz-00022m-MK
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:46:33 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS0HV-0004mj-HZ
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:45:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/12] xfs: introduce new locks for the log grant ticket wait
	queues
Date: Mon, 13 Dec 2010 15:44:41 +1100
Message-Id: <1292215483-18224-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1292215483-18224-1-git-send-email-david@fromorbit.com>
References: <1292215483-18224-1-git-send-email-david@fromorbit.com>
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

To ensure forced shutdowns work correctly in conjunction with the
new fast paths, ensure that we check whether the log has been shut
down in the grant functions once we hold the relevant spin locks but
before we go to sleep. This is needed to co-ordinate correctly with
the wakeups that are issued on the ticket queues so we don't leave
any processes sleeping on the queues during a shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |    2 +
 fs/xfs/xfs_log.c             |  139 +++++++++++++++++++++++++-----------------
 fs/xfs/xfs_log_priv.h        |   16 ++++-
 3 files changed, 97 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 2f62d0f..7fae8d5 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -837,6 +837,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep1);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake1);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep2);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake2);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake_up);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
@@ -844,6 +845,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep1);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake1);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep2);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake2);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake_up);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index cddfc6b..de3ad18 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -682,12 +682,12 @@ xfs_log_move_tail(xfs_mount_t	*mp,
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
 		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
 		list_for_each_entry(tic, &log->l_writeq, t_queue) {
 			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
@@ -696,15 +696,18 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 				break;
 			tail_lsn = 0;
 			free_bytes -= tic->t_unit_res;
+			trace_xfs_log_regrant_write_wake_up(log, tic);
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
 		free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
 		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
 			if (tic->t_flags & XLOG_TIC_PERM_RESERV)
@@ -715,11 +718,12 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 				break;
 			tail_lsn = 0;
 			free_bytes -= need_bytes;
+			trace_xfs_log_grant_wake_up(log, tic);
 			wake_up(&tic->t_wait);
 		}
+		spin_unlock(&log->l_grant_reserve_lock);
 	}
-	spin_unlock(&log->l_grant_lock);
-}	/* xfs_log_move_tail */
+}
 
 /*
  * Determine if we have a transaction that has gone to disk
@@ -1010,6 +1014,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	xlog_assign_grant_head(&log->l_grant_write_head, 1, 0);
 	INIT_LIST_HEAD(&log->l_reserveq);
 	INIT_LIST_HEAD(&log->l_writeq);
+	spin_lock_init(&log->l_grant_reserve_lock);
+	spin_lock_init(&log->l_grant_write_lock);
 
 	error = EFSCORRUPTED;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
@@ -2477,6 +2483,18 @@ restart:
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
 xlog_grant_log_space(xlog_t	   *log,
@@ -2490,13 +2508,20 @@ xlog_grant_log_space(xlog_t	   *log,
 		panic("grant Recovery problem");
 #endif
 
-	/* Is there space or do we need to sleep? */
-	spin_lock(&log->l_grant_lock);
-
 	trace_xfs_log_grant_enter(log, tic);
 
+	need_bytes = tic->t_unit_res;
+	if (tic->t_flags & XFS_LOG_PERM_RESERV)
+		need_bytes *= tic->t_ocnt;
+
 	/* something is already sleeping; insert new transaction at end */
-	if (!list_empty(&log->l_reserveq)) {
+	if (!list_empty_careful(&log->l_reserveq)) {
+		spin_lock(&log->l_grant_reserve_lock);
+		/* recheck the queue now we are locked */
+		if (list_empty(&log->l_reserveq)) {
+			spin_unlock(&log->l_grant_reserve_lock);
+			goto redo;
+		}
 		list_add_tail(&tic->t_queue, &log->l_reserveq);
 
 		trace_xfs_log_grant_sleep1(log, tic);
@@ -2509,48 +2534,47 @@ xlog_grant_log_space(xlog_t	   *log,
 			goto error_return;
 
 		XFS_STATS_INC(xs_sleep_logspace);
-		xlog_wait(&tic->t_wait, &log->l_grant_lock);
+		xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
 
 		/*
 		 * If we got an error, and the filesystem is shutting down,
 		 * we'll catch it down below. So just continue...
 		 */
 		trace_xfs_log_grant_wake1(log, tic);
-		spin_lock(&log->l_grant_lock);
 	}
-	if (tic->t_flags & XFS_LOG_PERM_RESERV)
-		need_bytes = tic->t_unit_res*tic->t_ocnt;
-	else
-		need_bytes = tic->t_unit_res;
 
 redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
-		goto error_return;
+		goto error_return_unlocked;
 
 	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
 	if (free_bytes < need_bytes) {
+		spin_lock(&log->l_grant_reserve_lock);
 		if (list_empty(&tic->t_queue))
 			list_add_tail(&tic->t_queue, &log->l_reserveq);
 
 		trace_xfs_log_grant_sleep2(log, tic);
 
+		if (XLOG_FORCED_SHUTDOWN(log))
+			goto error_return;
+
 		xlog_grant_push_ail(log, need_bytes);
 
 		XFS_STATS_INC(xs_sleep_logspace);
-		xlog_wait(&tic->t_wait, &log->l_grant_lock);
-
-		spin_lock(&log->l_grant_lock);
-		if (XLOG_FORCED_SHUTDOWN(log))
-			goto error_return;
+		xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
 
 		trace_xfs_log_grant_wake2(log, tic);
-
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
 	xlog_grant_add_space(log, &log->l_grant_reserve_head, need_bytes);
 	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
 	trace_xfs_log_grant_exit(log, tic);
@@ -2559,8 +2583,11 @@ redo:
 	spin_unlock(&log->l_grant_lock);
 	return 0;
 
- error_return:
+error_return_unlocked:
+	spin_lock(&log->l_grant_reserve_lock);
+error_return:
 	list_del_init(&tic->t_queue);
+	spin_unlock(&log->l_grant_reserve_lock);
 	trace_xfs_log_grant_error(log, tic);
 
 	/*
@@ -2570,7 +2597,6 @@ redo:
 	 */
 	tic->t_curr_res = 0;
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	spin_unlock(&log->l_grant_lock);
 	return XFS_ERROR(EIO);
 }	/* xlog_grant_log_space */
 
@@ -2578,7 +2604,8 @@ redo:
 /*
  * Replenish the byte reservation required by moving the grant write head.
  *
- *
+ * Similar to xlog_grant_log_space, the function is structured to have a lock
+ * free fast path.
  */
 STATIC int
 xlog_regrant_write_log_space(xlog_t	   *log,
@@ -2597,12 +2624,9 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 		panic("regrant Recovery problem");
 #endif
 
-	spin_lock(&log->l_grant_lock);
-
 	trace_xfs_log_regrant_write_enter(log, tic);
-
 	if (XLOG_FORCED_SHUTDOWN(log))
-		goto error_return;
+		goto error_return_unlocked;
 
 	/* If there are other waiters on the queue then give them a
 	 * chance at logspace before us. Wake up the first waiters,
@@ -2611,8 +2635,10 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 	 * this transaction.
 	 */
 	need_bytes = tic->t_unit_res;
-	if (!list_empty(&log->l_writeq)) {
+	if (!list_empty_careful(&log->l_writeq)) {
 		struct xlog_ticket *ntic;
+
+		spin_lock(&log->l_grant_write_lock);
 		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
 		list_for_each_entry(ntic, &log->l_writeq, t_queue) {
 			ASSERT(ntic->t_flags & XLOG_TIC_PERM_RESERV);
@@ -2627,50 +2653,48 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 						struct xlog_ticket, t_queue)) {
 			if (list_empty(&tic->t_queue))
 				list_add_tail(&tic->t_queue, &log->l_writeq);
-
 			trace_xfs_log_regrant_write_sleep1(log, tic);
 
 			xlog_grant_push_ail(log, need_bytes);
 
 			XFS_STATS_INC(xs_sleep_logspace);
-			xlog_wait(&tic->t_wait, &log->l_grant_lock);
-
-			/* If we're shutting down, this tic is already
-			 * off the queue */
-			spin_lock(&log->l_grant_lock);
-			if (XLOG_FORCED_SHUTDOWN(log))
-				goto error_return;
-
+			xlog_wait(&tic->t_wait, &log->l_grant_write_lock);
 			trace_xfs_log_regrant_write_wake1(log, tic);
-		}
+		} else
+			spin_unlock(&log->l_grant_write_lock);
 	}
 
 redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
-		goto error_return;
+		goto error_return_unlocked;
 
 	free_bytes = xlog_space_left(log, &log->l_grant_write_head);
 	if (free_bytes < need_bytes) {
+		spin_lock(&log->l_grant_write_lock);
 		if (list_empty(&tic->t_queue))
 			list_add_tail(&tic->t_queue, &log->l_writeq);
+
+		if (XLOG_FORCED_SHUTDOWN(log))
+			goto error_return;
+
 		xlog_grant_push_ail(log, need_bytes);
 
 		XFS_STATS_INC(xs_sleep_logspace);
 		trace_xfs_log_regrant_write_sleep2(log, tic);
-		xlog_wait(&tic->t_wait, &log->l_grant_lock);
-
-		/* If we're shutting down, this tic is already off the queue */
-		spin_lock(&log->l_grant_lock);
-		if (XLOG_FORCED_SHUTDOWN(log))
-			goto error_return;
+		xlog_wait(&tic->t_wait, &log->l_grant_write_lock);
 
 		trace_xfs_log_regrant_write_wake2(log, tic);
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
 	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
 	trace_xfs_log_regrant_write_exit(log, tic);
 	xlog_verify_grant_head(log, 1);
@@ -2679,8 +2703,11 @@ redo:
 	return 0;
 
 
+ error_return_unlocked:
+	spin_lock(&log->l_grant_write_lock);
  error_return:
 	list_del_init(&tic->t_queue);
+	spin_unlock(&log->l_grant_write_lock);
 	trace_xfs_log_regrant_write_error(log, tic);
 
 	/*
@@ -2690,7 +2717,6 @@ redo:
 	 */
 	tic->t_curr_res = 0;
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	spin_unlock(&log->l_grant_lock);
 	return XFS_ERROR(EIO);
 }	/* xlog_regrant_write_log_space */
 
@@ -3664,12 +3690,10 @@ xfs_log_force_umount(
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
@@ -3694,14 +3718,17 @@ xfs_log_force_umount(
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
index 24f510f..c8e23ff 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -513,10 +513,6 @@ typedef struct log {
 
 	/* The following block of fields are changed while holding grant_lock */
 	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
-	struct list_head	l_reserveq;
-	struct list_head	l_writeq;
-	atomic64_t			l_grant_reserve_head;
-	atomic64_t			l_grant_write_head;
 
 	/*
 	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
@@ -529,6 +525,18 @@ typedef struct log {
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
