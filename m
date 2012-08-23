Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53298134901 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:02 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Ui1EF7cCjt2KiE9T for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:47 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pa0-0003FL-AO
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:40 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZq-0003d1-8a
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 023/102] xfs: fix the logspace waiting algorithm
Date: Thu, 23 Aug 2012 15:01:41 +1000
Message-Id: <1345698180-13612-24-git-send-email-david@fromorbit.com>
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

Upstream commit: 9f9c19ec1a59422c7687b11847ed3408128aa0d6

Apply the scheme used in log_regrant_write_log_space to wake up any other
threads waiting for log space before the newly added one to
log_regrant_write_log_space as well, and factor the code into readable
helpers.  For each of the queues we have add two helpers:

 - one to try to wake up all waiting threads.  This helper will also be
   usable by xfs_log_move_tail once we remove the current opportunistic
   wakeups in it.
 - one to sleep on t_wait until enough log space is available, loosely
   modelled after Linux waitqueues.

And use them to reimplement the guts of log_regrant_write_log_space and
log_regrant_write_log_space.  These two function now use one and the same
algorithm for waiting on log space instead of subtly different ones before,
with an option to completely unify them in the near future.

Also move the filesystem shutdown handling to the common caller given
that we had to touch it anyway.

Based on hard debugging and an earlier patch from
Chandra Seetharaman <sekharan@us.ibm.com>.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>
Tested-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |   12 +-
 fs/xfs/xfs_log.c             |  348 +++++++++++++++++++++---------------------
 2 files changed, 177 insertions(+), 183 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index b5f892a..59e8096 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -835,18 +835,14 @@ DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep1);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake1);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep2);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake2);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake_up);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep1);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake1);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep2);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake2);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake_up);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b180b55..42d8a5d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -150,6 +150,117 @@ xlog_grant_add_space(
 	} while (head_val != old);
 }
 
+STATIC bool
+xlog_reserveq_wake(
+	struct log		*log,
+	int			*free_bytes)
+{
+	struct xlog_ticket	*tic;
+	int			need_bytes;
+
+	list_for_each_entry(tic, &log->l_reserveq, t_queue) {
+		if (tic->t_flags & XLOG_TIC_PERM_RESERV)
+			need_bytes = tic->t_unit_res * tic->t_cnt;
+		else
+			need_bytes = tic->t_unit_res;
+
+		if (*free_bytes < need_bytes)
+			return false;
+		*free_bytes -= need_bytes;
+
+		trace_xfs_log_grant_wake_up(log, tic);
+		wake_up(&tic->t_wait);
+	}
+
+	return true;
+}
+
+STATIC bool
+xlog_writeq_wake(
+	struct log		*log,
+	int			*free_bytes)
+{
+	struct xlog_ticket	*tic;
+	int			need_bytes;
+
+	list_for_each_entry(tic, &log->l_writeq, t_queue) {
+		ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
+
+		need_bytes = tic->t_unit_res;
+
+		if (*free_bytes < need_bytes)
+			return false;
+		*free_bytes -= need_bytes;
+
+		trace_xfs_log_regrant_write_wake_up(log, tic);
+		wake_up(&tic->t_wait);
+	}
+
+	return true;
+}
+
+STATIC int
+xlog_reserveq_wait(
+	struct log		*log,
+	struct xlog_ticket	*tic,
+	int			need_bytes)
+{
+	list_add_tail(&tic->t_queue, &log->l_reserveq);
+
+	do {
+		if (XLOG_FORCED_SHUTDOWN(log))
+			goto shutdown;
+		xlog_grant_push_ail(log, need_bytes);
+
+		XFS_STATS_INC(xs_sleep_logspace);
+		trace_xfs_log_grant_sleep(log, tic);
+
+		xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
+		trace_xfs_log_grant_wake(log, tic);
+
+		spin_lock(&log->l_grant_reserve_lock);
+		if (XLOG_FORCED_SHUTDOWN(log))
+			goto shutdown;
+	} while (xlog_space_left(log, &log->l_grant_reserve_head) < need_bytes);
+
+	list_del_init(&tic->t_queue);
+	return 0;
+shutdown:
+	list_del_init(&tic->t_queue);
+	return XFS_ERROR(EIO);
+}
+
+STATIC int
+xlog_writeq_wait(
+	struct log		*log,
+	struct xlog_ticket	*tic,
+	int			need_bytes)
+{
+	list_add_tail(&tic->t_queue, &log->l_writeq);
+
+	do {
+		if (XLOG_FORCED_SHUTDOWN(log))
+			goto shutdown;
+		xlog_grant_push_ail(log, need_bytes);
+
+		XFS_STATS_INC(xs_sleep_logspace);
+		trace_xfs_log_regrant_write_sleep(log, tic);
+
+		xlog_wait(&tic->t_wait, &log->l_grant_write_lock);
+		trace_xfs_log_regrant_write_wake(log, tic);
+
+		spin_lock(&log->l_grant_write_lock);
+		if (XLOG_FORCED_SHUTDOWN(log))
+			goto shutdown;
+	} while (xlog_space_left(log, &log->l_grant_write_head) < need_bytes);
+
+	list_del_init(&tic->t_queue);
+	return 0;
+shutdown:
+	list_del_init(&tic->t_queue);
+	return XFS_ERROR(EIO);
+}
+
 static void
 xlog_tic_reset_res(xlog_ticket_t *tic)
 {
@@ -350,8 +461,19 @@ xfs_log_reserve(
 		retval = xlog_grant_log_space(log, internal_ticket);
 	}
 
+	if (unlikely(retval)) {
+		/*
+		 * If we are failing, make sure the ticket doesn't have any
+		 * current reservations.  We don't want to add this back
+		 * when the ticket/ transaction gets cancelled.
+		 */
+		internal_ticket->t_curr_res = 0;
+		/* ungrant will give back unit_res * t_cnt. */
+		internal_ticket->t_cnt = 0;
+	}
+
 	return retval;
-}	/* xfs_log_reserve */
+}
 
 
 /*
@@ -2495,8 +2617,8 @@ restart:
 /*
  * Atomically get the log space required for a log ticket.
  *
- * Once a ticket gets put onto the reserveq, it will only return after
- * the needed reservation is satisfied.
+ * Once a ticket gets put onto the reserveq, it will only return after the
+ * needed reservation is satisfied.
  *
  * This function is structured so that it has a lock free fast path. This is
  * necessary because every new transaction reservation will come through this
@@ -2504,113 +2626,53 @@ restart:
  * every pass.
  *
  * As tickets are only ever moved on and off the reserveq under the
- * l_grant_reserve_lock, we only need to take that lock if we are going
- * to add the ticket to the queue and sleep. We can avoid taking the lock if the
- * ticket was never added to the reserveq because the t_queue list head will be
- * empty and we hold the only reference to it so it can safely be checked
- * unlocked.
+ * l_grant_reserve_lock, we only need to take that lock if we are going to add
+ * the ticket to the queue and sleep. We can avoid taking the lock if the ticket
+ * was never added to the reserveq because the t_queue list head will be empty
+ * and we hold the only reference to it so it can safely be checked unlocked.
  */
 STATIC int
-xlog_grant_log_space(xlog_t	   *log,
-		     xlog_ticket_t *tic)
+xlog_grant_log_space(
+	struct log		*log,
+	struct xlog_ticket	*tic)
 {
-	int		 free_bytes;
-	int		 need_bytes;
+	int			free_bytes, need_bytes;
+	int			error = 0;
 
-#ifdef DEBUG
-	if (log->l_flags & XLOG_ACTIVE_RECOVERY)
-		panic("grant Recovery problem");
-#endif
+	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
 
 	trace_xfs_log_grant_enter(log, tic);
 
+	/*
+	 * If there are other waiters on the queue then give them a chance at
+	 * logspace before us.  Wake up the first waiters, if we do not wake
+	 * up all the waiters then go to sleep waiting for more free space,
+	 * otherwise try to get some space for this transaction.
+	 */
 	need_bytes = tic->t_unit_res;
 	if (tic->t_flags & XFS_LOG_PERM_RESERV)
 		need_bytes *= tic->t_ocnt;
-
-	/* something is already sleeping; insert new transaction at end */
-	if (!list_empty_careful(&log->l_reserveq)) {
-		spin_lock(&log->l_grant_reserve_lock);
-		/* recheck the queue now we are locked */
-		if (list_empty(&log->l_reserveq)) {
-			spin_unlock(&log->l_grant_reserve_lock);
-			goto redo;
-		}
-		list_add_tail(&tic->t_queue, &log->l_reserveq);
-
-		trace_xfs_log_grant_sleep1(log, tic);
-
-		/*
-		 * Gotta check this before going to sleep, while we're
-		 * holding the grant lock.
-		 */
-		if (XLOG_FORCED_SHUTDOWN(log))
-			goto error_return;
-
-		XFS_STATS_INC(xs_sleep_logspace);
-		xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
-
-		/*
-		 * If we got an error, and the filesystem is shutting down,
-		 * we'll catch it down below. So just continue...
-		 */
-		trace_xfs_log_grant_wake1(log, tic);
-	}
-
-redo:
-	if (XLOG_FORCED_SHUTDOWN(log))
-		goto error_return_unlocked;
-
 	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
-	if (free_bytes < need_bytes) {
+	if (!list_empty_careful(&log->l_reserveq)) {
 		spin_lock(&log->l_grant_reserve_lock);
-		if (list_empty(&tic->t_queue))
-			list_add_tail(&tic->t_queue, &log->l_reserveq);
-
-		trace_xfs_log_grant_sleep2(log, tic);
-
-		if (XLOG_FORCED_SHUTDOWN(log))
-			goto error_return;
-
-		xlog_grant_push_ail(log, need_bytes);
-
-		XFS_STATS_INC(xs_sleep_logspace);
-		xlog_wait(&tic->t_wait, &log->l_grant_reserve_lock);
-
-		trace_xfs_log_grant_wake2(log, tic);
-		goto redo;
-	}
-
-	if (!list_empty(&tic->t_queue)) {
+		if (!xlog_reserveq_wake(log, &free_bytes) ||
+		    free_bytes < need_bytes)
+			error = xlog_reserveq_wait(log, tic, need_bytes);
+		spin_unlock(&log->l_grant_reserve_lock);
+	} else if (free_bytes < need_bytes) {
 		spin_lock(&log->l_grant_reserve_lock);
-		list_del_init(&tic->t_queue);
+		error = xlog_reserveq_wait(log, tic, need_bytes);
 		spin_unlock(&log->l_grant_reserve_lock);
 	}
+	if (error)
+		return error;
 
-	/* we've got enough space */
 	xlog_grant_add_space(log, &log->l_grant_reserve_head, need_bytes);
 	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
 	trace_xfs_log_grant_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
-
-error_return_unlocked:
-	spin_lock(&log->l_grant_reserve_lock);
-error_return:
-	list_del_init(&tic->t_queue);
-	spin_unlock(&log->l_grant_reserve_lock);
-	trace_xfs_log_grant_error(log, tic);
-
-	/*
-	 * If we are failing, make sure the ticket doesn't have any
-	 * current reservations. We don't want to add this back when
-	 * the ticket/transaction gets cancelled.
-	 */
-	tic->t_curr_res = 0;
-	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	return XFS_ERROR(EIO);
-}	/* xlog_grant_log_space */
-
+}
 
 /*
  * Replenish the byte reservation required by moving the grant write head.
@@ -2619,10 +2681,12 @@ error_return:
  * free fast path.
  */
 STATIC int
-xlog_regrant_write_log_space(xlog_t	   *log,
-			     xlog_ticket_t *tic)
+xlog_regrant_write_log_space(
+	struct log		*log,
+	struct xlog_ticket	*tic)
 {
-	int		free_bytes, need_bytes;
+	int			free_bytes, need_bytes;
+	int			error = 0;
 
 	tic->t_curr_res = tic->t_unit_res;
 	xlog_tic_reset_res(tic);
@@ -2630,104 +2694,38 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 	if (tic->t_cnt > 0)
 		return 0;
 
-#ifdef DEBUG
-	if (log->l_flags & XLOG_ACTIVE_RECOVERY)
-		panic("regrant Recovery problem");
-#endif
+	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
 
 	trace_xfs_log_regrant_write_enter(log, tic);
-	if (XLOG_FORCED_SHUTDOWN(log))
-		goto error_return_unlocked;
 
-	/* If there are other waiters on the queue then give them a
-	 * chance at logspace before us. Wake up the first waiters,
-	 * if we do not wake up all the waiters then go to sleep waiting
-	 * for more free space, otherwise try to get some space for
-	 * this transaction.
+	/*
+	 * If there are other waiters on the queue then give them a chance at
+	 * logspace before us.  Wake up the first waiters, if we do not wake
+	 * up all the waiters then go to sleep waiting for more free space,
+	 * otherwise try to get some space for this transaction.
 	 */
 	need_bytes = tic->t_unit_res;
-	if (!list_empty_careful(&log->l_writeq)) {
-		struct xlog_ticket *ntic;
-
-		spin_lock(&log->l_grant_write_lock);
-		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
-		list_for_each_entry(ntic, &log->l_writeq, t_queue) {
-			ASSERT(ntic->t_flags & XLOG_TIC_PERM_RESERV);
-
-			if (free_bytes < ntic->t_unit_res)
-				break;
-			free_bytes -= ntic->t_unit_res;
-			wake_up(&ntic->t_wait);
-		}
-
-		if (ntic != list_first_entry(&log->l_writeq,
-						struct xlog_ticket, t_queue)) {
-			if (list_empty(&tic->t_queue))
-				list_add_tail(&tic->t_queue, &log->l_writeq);
-			trace_xfs_log_regrant_write_sleep1(log, tic);
-
-			xlog_grant_push_ail(log, need_bytes);
-
-			XFS_STATS_INC(xs_sleep_logspace);
-			xlog_wait(&tic->t_wait, &log->l_grant_write_lock);
-			trace_xfs_log_regrant_write_wake1(log, tic);
-		} else
-			spin_unlock(&log->l_grant_write_lock);
-	}
-
-redo:
-	if (XLOG_FORCED_SHUTDOWN(log))
-		goto error_return_unlocked;
-
 	free_bytes = xlog_space_left(log, &log->l_grant_write_head);
-	if (free_bytes < need_bytes) {
+	if (!list_empty_careful(&log->l_writeq)) {
 		spin_lock(&log->l_grant_write_lock);
-		if (list_empty(&tic->t_queue))
-			list_add_tail(&tic->t_queue, &log->l_writeq);
-
-		if (XLOG_FORCED_SHUTDOWN(log))
-			goto error_return;
-
-		xlog_grant_push_ail(log, need_bytes);
-
-		XFS_STATS_INC(xs_sleep_logspace);
-		trace_xfs_log_regrant_write_sleep2(log, tic);
-		xlog_wait(&tic->t_wait, &log->l_grant_write_lock);
-
-		trace_xfs_log_regrant_write_wake2(log, tic);
-		goto redo;
-	}
-
-	if (!list_empty(&tic->t_queue)) {
+		if (!xlog_writeq_wake(log, &free_bytes) ||
+		    free_bytes < need_bytes)
+			error = xlog_writeq_wait(log, tic, need_bytes);
+		spin_unlock(&log->l_grant_write_lock);
+	} else if (free_bytes < need_bytes) {
 		spin_lock(&log->l_grant_write_lock);
-		list_del_init(&tic->t_queue);
+		error = xlog_writeq_wait(log, tic, need_bytes);
 		spin_unlock(&log->l_grant_write_lock);
 	}
 
-	/* we've got enough space */
+	if (error)
+		return error;
+
 	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
 	trace_xfs_log_regrant_write_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
-
-
- error_return_unlocked:
-	spin_lock(&log->l_grant_write_lock);
- error_return:
-	list_del_init(&tic->t_queue);
-	spin_unlock(&log->l_grant_write_lock);
-	trace_xfs_log_regrant_write_error(log, tic);
-
-	/*
-	 * If we are failing, make sure the ticket doesn't have any
-	 * current reservations. We don't want to add this back when
-	 * the ticket/transaction gets cancelled.
-	 */
-	tic->t_curr_res = 0;
-	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	return XFS_ERROR(EIO);
-}	/* xlog_regrant_write_log_space */
-
+}
 
 /* The first cnt-1 times through here we don't need to
  * move the grant write head because the permanent
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
