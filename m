Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bQWR082161 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:26 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 826D213F6558
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:39:06 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Crn0CD3E9zcxLWtY for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:39:06 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48209016-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:09:03 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMshf-0000dJ-Ee
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:51 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMshQ-0005cK-04
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/14] xfs: clean up log space grant functions
Date: Mon, 29 Nov 2010 12:38:20 +1100
Message-Id: <1290994712-21376-3-git-send-email-david@fromorbit.com>
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

xlog_grant_log_space and xlog_regrant_log_write_space both have very
similar structure. Both have a "wait on non-empty queue" section at
the start, followed by a "wait for space" loop of which the contents
are almost identical to the initial non-empty queue section.

In both cases, the non-empty queue wait can be folded into the wait
for space loop, simply by entering the loop if the queue is not
empty and the current ticket is not on the queue. If we trigger the
non-empty queue case, we always add ourselves to the queue, and
hence the second and subsequent loops are always driven by the "wait
for space" test.

IOWs, both wait conditions can be folded into the one loop, removing
a bunch of duplicated code and making it simpler to modify in
future patches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |   12 +--
 fs/xfs/xfs_log.c             |  171 +++++++++++++++---------------------------
 2 files changed, 64 insertions(+), 119 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index f400668..0884f93 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -831,17 +831,13 @@ DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep1);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake1);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep2);
-DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake2);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep);
+DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_error);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep1);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake1);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep2);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake2);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_sleep);
+DEFINE_LOGGRANT_EVENT(xfs_log_regrant_write_wake);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1b82735..399e559 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -68,14 +68,14 @@ STATIC void xlog_state_switch_iclogs(xlog_t		*log,
 STATIC void xlog_state_want_sync(xlog_t	*log, xlog_in_core_t *iclog);
 
 /* local functions to manipulate grant head */
-STATIC int  xlog_grant_log_space(xlog_t		*log,
-				 xlog_ticket_t	*xtic);
+STATIC int  xlog_grant_log_space(struct log		*log,
+				 struct xlog_ticket	*xtic);
 STATIC void xlog_grant_push_ail(xfs_mount_t	*mp,
 				int		need_bytes);
 STATIC void xlog_regrant_reserve_log_space(xlog_t	 *log,
 					   xlog_ticket_t *ticket);
-STATIC int xlog_regrant_write_log_space(xlog_t		*log,
-					 xlog_ticket_t  *ticket);
+STATIC int xlog_regrant_write_log_space(struct log		*log,
+					struct xlog_ticket	*xtic);
 STATIC void xlog_ungrant_log_space(xlog_t	 *log,
 				   xlog_ticket_t *ticket);
 
@@ -2498,52 +2498,27 @@ restart:
  * the needed reservation is satisfied.
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
+	int			 free_bytes;
+	int			 need_bytes;
 #ifdef DEBUG
-	xfs_lsn_t	 tail_lsn;
-#endif
+	xfs_lsn_t		 tail_lsn;
 
-
-#ifdef DEBUG
 	if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 		panic("grant Recovery problem");
 #endif
 
 	/* Is there space or do we need to sleep? */
 	spin_lock(&log->l_grant_lock);
-
 	trace_xfs_log_grant_enter(log, tic);
+	ASSERT(list_empty(&tic->t_queue));
 
-	/* something is already sleeping; insert new transaction at end */
-	if (!list_empty(&log->l_reserveq)) {
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
-		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
-		/*
-		 * If we got an error, and the filesystem is shutting down,
-		 * we'll catch it down below. So just continue...
-		 */
-		trace_xfs_log_grant_wake1(log, tic);
-		spin_lock(&log->l_grant_lock);
-	}
+	need_bytes = tic->t_unit_res;
 	if (tic->t_flags & XFS_LOG_PERM_RESERV)
-		need_bytes = tic->t_unit_res*tic->t_ocnt;
-	else
-		need_bytes = tic->t_unit_res;
+		need_bytes *= tic->t_ocnt;
 
 redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
@@ -2551,25 +2526,25 @@ redo:
 
 	free_bytes = xlog_space_left(log, log->l_grant_reserve_cycle,
 				     log->l_grant_reserve_bytes);
-	if (free_bytes < need_bytes) {
+	/*
+	 * If there is not enough space or there is queued waiter and we
+	 * are not already on the queue, we need to wait.
+	 */
+	if (free_bytes < need_bytes ||
+	    (!list_empty(&log->l_reserveq) && list_empty(&tic->t_queue))) {
 		if (list_empty(&tic->t_queue))
 			list_add_tail(&tic->t_queue, &log->l_reserveq);
 
-		trace_xfs_log_grant_sleep2(log, tic);
-
 		spin_unlock(&log->l_grant_lock);
 		xlog_grant_push_ail(log->l_mp, need_bytes);
 		spin_lock(&log->l_grant_lock);
 
 		XFS_STATS_INC(xs_sleep_logspace);
+		trace_xfs_log_grant_sleep(log, tic);
 		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
 
 		spin_lock(&log->l_grant_lock);
-		if (XLOG_FORCED_SHUTDOWN(log))
-			goto error_return;
-
-		trace_xfs_log_grant_wake2(log, tic);
-
+		trace_xfs_log_grant_wake(log, tic);
 		goto redo;
 	}
 
@@ -2608,21 +2583,21 @@ redo:
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
 	spin_unlock(&log->l_grant_lock);
 	return XFS_ERROR(EIO);
-}	/* xlog_grant_log_space */
+}
 
 
 /*
  * Replenish the byte reservation required by moving the grant write head.
- *
- *
  */
 STATIC int
-xlog_regrant_write_log_space(xlog_t	   *log,
-			     xlog_ticket_t *tic)
+xlog_regrant_write_log_space(
+	struct log		*log,
+	struct xlog_ticket	*tic)
 {
-	int		free_bytes, need_bytes;
+	int			free_bytes;
+	int			need_bytes;
 #ifdef DEBUG
-	xfs_lsn_t	tail_lsn;
+	xfs_lsn_t		tail_lsn;
 #endif
 
 	tic->t_curr_res = tic->t_unit_res;
@@ -2637,81 +2612,55 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 #endif
 
 	spin_lock(&log->l_grant_lock);
-
 	trace_xfs_log_regrant_write_enter(log, tic);
+	ASSERT(list_empty(&tic->t_queue));
 
-	if (XLOG_FORCED_SHUTDOWN(log))
-		goto error_return;
-
-	/* If there are other waiters on the queue then give them a
-	 * chance at logspace before us. Wake up the first waiters,
-	 * if we do not wake up all the waiters then go to sleep waiting
-	 * for more free space, otherwise try to get some space for
-	 * this transaction.
-	 */
 	need_bytes = tic->t_unit_res;
-	if (!list_empty(&log->l_writeq)) {
-		struct xlog_ticket *ntic;
-		free_bytes = xlog_space_left(log, log->l_grant_write_cycle,
-					     log->l_grant_write_bytes);
-		list_for_each_entry(ntic, &log->l_writeq, t_queue) {
-			ASSERT(ntic->t_flags & XLOG_TIC_PERM_RESERV);
-
-			if (free_bytes < ntic->t_unit_res)
-				break;
-			free_bytes -= ntic->t_unit_res;
-			sv_signal(&ntic->t_wait);
-		}
-
-		if (ntic != list_first_entry(&log->l_writeq,
-						struct xlog_ticket, t_queue)) {
-			if (list_empty(&tic->t_queue))
-				list_add_tail(&tic->t_queue, &log->l_writeq);
-
-			trace_xfs_log_regrant_write_sleep1(log, tic);
-
-			spin_unlock(&log->l_grant_lock);
-			xlog_grant_push_ail(log->l_mp, need_bytes);
-			spin_lock(&log->l_grant_lock);
-
-			XFS_STATS_INC(xs_sleep_logspace);
-			sv_wait(&tic->t_wait, PINOD|PLTWAIT,
-				&log->l_grant_lock, s);
-
-			/* If we're shutting down, this tic is already
-			 * off the queue */
-			spin_lock(&log->l_grant_lock);
-			if (XLOG_FORCED_SHUTDOWN(log))
-				goto error_return;
-
-			trace_xfs_log_regrant_write_wake1(log, tic);
-		}
-	}
-
 redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error_return;
 
 	free_bytes = xlog_space_left(log, log->l_grant_write_cycle,
 				     log->l_grant_write_bytes);
-	if (free_bytes < need_bytes) {
-		if (list_empty(&tic->t_queue))
+	/*
+	 * If there is not enough space or there is queued waiter and we
+	 * are not already on the queue, we need to wait.
+	 */
+	if (free_bytes < need_bytes ||
+	    (!list_empty(&log->l_writeq) && list_empty(&tic->t_queue))) {
+		if (list_empty(&tic->t_queue)) {
+			/*
+			 * give existing waiters a chance at logspace before
+			 * us.  If we woke all the waiters, then immediately
+			 * retry the space, otherwise sleep first.
+			 */
+			struct xlog_ticket	*ntic;
+			int			woke_all = 1;
+			list_for_each_entry(ntic, &log->l_writeq, t_queue) {
+				ASSERT(ntic->t_flags & XLOG_TIC_PERM_RESERV);
+
+				if (free_bytes < ntic->t_unit_res) {
+					woke_all = 0;
+					break;
+				}
+				free_bytes -= ntic->t_unit_res;
+				sv_signal(&ntic->t_wait);
+			}
 			list_add_tail(&tic->t_queue, &log->l_writeq);
+			if (woke_all)
+				goto redo;
+		}
+
 		spin_unlock(&log->l_grant_lock);
 		xlog_grant_push_ail(log->l_mp, need_bytes);
 		spin_lock(&log->l_grant_lock);
 
 		XFS_STATS_INC(xs_sleep_logspace);
-		trace_xfs_log_regrant_write_sleep2(log, tic);
-
+		trace_xfs_log_regrant_write_sleep(log, tic);
 		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
 
-		/* If we're shutting down, this tic is already off the queue */
 		spin_lock(&log->l_grant_lock);
-		if (XLOG_FORCED_SHUTDOWN(log))
-			goto error_return;
-
-		trace_xfs_log_regrant_write_wake2(log, tic);
+		trace_xfs_log_regrant_write_wake(log, tic);
 		goto redo;
 	}
 
@@ -2747,7 +2696,7 @@ redo:
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
 	spin_unlock(&log->l_grant_lock);
 	return XFS_ERROR(EIO);
-}	/* xlog_regrant_write_log_space */
+}
 
 
 /* The first cnt-1 times through here we don't need to
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
