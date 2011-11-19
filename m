Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJIJXYJ072445 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 12:19:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BDBA16DB92E
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 10:19:31 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	w1xoJS7WRQcei0Vg for <xfs@oss.sgi.com>;
	Sat, 19 Nov 2011 10:19:31 -0800 (PST)
Date: Sat, 19 Nov 2011 13:19:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Remove the entries from the queue while waking them
	up.
Message-ID: <20111119181929.GA25739@infradead.org>
References: <1321644054.2201.80.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1321644054.2201.80.camel@chandra-lucid.austin.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

Thanks a lot for tracking this issue down!

Unfortunately I don't think the fix is entirely safe.  If we remove
the ticket from the list before the wakeup we have to assume no one
else ever wakes up a process waiting for log space.  In Linux that
generally isn't a safe assumption - e.g. higher level code could have
added itself to another waitqueue before calling into this code (
possibly even outside the XFS code) and now getting a wake up, or
other bits of the kernel could have all kinds of reasons to wake
this process up.

Below is patch I hacked up on the airplane today - it makes sure
we always wake other waiters on the log space queues first before
adding a new process and should have the same effect.  Can you
test if this also fixes the 234 hang for you?

---
From: Christoph Hellwig <hch@lst.de>
Subject: xfs: fix and cleanup logspace waiter lists

Apply the scheme used in log_regrant_write_log_space to wake up any
other threads waiting for log space before the newly added one to
log_regrant_write_log_space as well, and factor the code into
readable helpers.  For each of the queues we have:

 - one helper to wake up all waiting threads, and return if we
   succeeded into doing that.  These helpers will also be usable
   by xfs_log_move_tail once we remove the current opportunistic
   wakeups in it.
 - one helper to sleep on t_wait until enough log space is available,
   which is modelled after the Linux waitqueue model.
 
and rewrite log_regrant_write_log_space and log_regrant_write_log_space
around these helpers, including comments documenting what is going on.
These two function now use one and the same algorithm for waiting
on log space instead of subtly different ones before.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/linux-2.6/xfs_trace.h |   12 -
 fs/xfs/xfs_log.c             |  329 +++++++++++++++++++++----------------------
 2 files changed, 170 insertions(+), 171 deletions(-)

Index: linux-2.6/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log.c	2011-11-19 15:51:55.689999172 +0100
+++ linux-2.6/fs/xfs/xfs_log.c	2011-11-19 16:57:07.226659537 +0100
@@ -670,6 +670,52 @@ xfs_log_write(
 	return error;
 }
 
+STATIC bool
+xlog_wake_writeq(
+	struct log		*log,
+	int			free_bytes)
+{
+	struct xlog_ticket	*tic;
+
+	list_for_each_entry(tic, &log->l_writeq, t_queue) {
+		ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
+
+		if (free_bytes < tic->t_unit_res)
+			return false;
+		free_bytes -= tic->t_unit_res;
+
+		trace_xfs_log_regrant_write_wake_up(log, tic);
+		wake_up(&tic->t_wait);
+	}
+
+	return true;
+}
+
+STATIC bool
+xlog_wake_reserveq(
+	struct log		*log,
+	int			free_bytes)
+{
+	struct xlog_ticket	*tic;
+	int			need_bytes;
+
+	list_for_each_entry(tic, &log->l_reserveq, t_queue) {
+		if (tic->t_flags & XLOG_TIC_PERM_RESERV)
+			need_bytes = tic->t_unit_res*tic->t_cnt;
+		else
+			need_bytes = tic->t_unit_res;
+
+		if (free_bytes < need_bytes)
+			return false;
+		free_bytes -= tic->t_unit_res;
+
+		trace_xfs_log_grant_wake_up(log, tic);
+		wake_up(&tic->t_wait);
+	}
+
+	return true;
+}
+
 void
 xfs_log_move_tail(xfs_mount_t	*mp,
 		  xfs_lsn_t	tail_lsn)
@@ -2492,11 +2538,42 @@ restart:
 	return 0;
 }	/* xlog_state_get_iclog_space */
 
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
@@ -2504,113 +2581,94 @@ restart:
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
+		if (!xlog_wake_reserveq(log, free_bytes))
+			error = xlog_reserveq_wait(log, tic, need_bytes);
+		spin_unlock(&log->l_grant_reserve_lock);
+	} else if (free_bytes < need_bytes) {
 		spin_lock(&log->l_grant_reserve_lock);
-		list_del_init(&tic->t_queue);
+		error = xlog_reserveq_wait(log, tic, need_bytes);
 		spin_unlock(&log->l_grant_reserve_lock);
 	}
 
-	/* we've got enough space */
+	if (error)
+		goto error0;
+
 	xlog_grant_add_space(log, &log->l_grant_reserve_head, need_bytes);
 	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
 	trace_xfs_log_grant_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
 
-error_return_unlocked:
-	spin_lock(&log->l_grant_reserve_lock);
-error_return:
-	list_del_init(&tic->t_queue);
-	spin_unlock(&log->l_grant_reserve_lock);
-	trace_xfs_log_grant_error(log, tic);
-
+error0:
 	/*
-	 * If we are failing, make sure the ticket doesn't have any
-	 * current reservations. We don't want to add this back when
-	 * the ticket/transaction gets cancelled.
+	 * If we are failing, make sure the ticket doesn't have any current
+	 * reservations.  We don't want to add this back when the ticket/
+	 * transaction gets cancelled.
 	 */
 	tic->t_curr_res = 0;
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	return XFS_ERROR(EIO);
-}	/* xlog_grant_log_space */
+	return error;
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
 
+	list_del_init(&tic->t_queue);
+	return 0;
+shutdown:
+	list_del_init(&tic->t_queue);
+	return XFS_ERROR(EIO);
+}
 
 /*
  * Replenish the byte reservation required by moving the grant write head.
@@ -2619,10 +2677,12 @@ error_return:
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
@@ -2630,104 +2690,47 @@ xlog_regrant_write_log_space(xlog_t	   *
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
+		if (!xlog_wake_writeq(log, free_bytes))
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
+		goto error0;
+
 	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
 	trace_xfs_log_regrant_write_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
 
-
- error_return_unlocked:
-	spin_lock(&log->l_grant_write_lock);
- error_return:
-	list_del_init(&tic->t_queue);
-	spin_unlock(&log->l_grant_write_lock);
-	trace_xfs_log_regrant_write_error(log, tic);
-
+error0:
 	/*
-	 * If we are failing, make sure the ticket doesn't have any
-	 * current reservations. We don't want to add this back when
-	 * the ticket/transaction gets cancelled.
+	 * If we are failing, make sure the ticket doesn't have any current
+	 * reservations. We don't want to add this back when the ticket/
+	 * transaction gets cancelled.
 	 */
 	tic->t_curr_res = 0;
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	return XFS_ERROR(EIO);
-}	/* xlog_regrant_write_log_space */
-
+	return error;
+}
 
 /* The first cnt-1 times through here we don't need to
  * move the grant write head because the permanent
Index: linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-11-19 16:36:00.493329401 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_trace.h	2011-11-19 16:39:53.303332382 +0100
@@ -833,18 +833,14 @@ DEFINE_LOGGRANT_EVENT(xfs_log_umount_wri
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
