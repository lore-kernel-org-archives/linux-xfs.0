Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bENW082071 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FF8313F5AF0
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:38:54 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	C1vOyFCRYExIyVCE for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:38:54 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48208978-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:08:52 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMshf-0000dc-Qs
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:51 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMshQ-0005ch-CE
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/14] xfs: convert grant head manipulations to lockless
	algorithm
Date: Mon, 29 Nov 2010 12:38:28 +1100
Message-Id: <1290994712-21376-11-git-send-email-david@fromorbit.com>
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

The only thing that the grant lock remains to protect is the grant head
manipulations when adding or removing space from the log. These calculations
are already based on atomic variables, so we can already update them safely
without locks. However, the grant head manpulations require atomic multi-step
calculations to be executed, which the algorithms currently don't allow.

To make these multi-step calculations atomic, convert the algorithms to
compare-and-exchange loops on the atomic variables. That is, we sample the old
value, perform the calculation and use atomic64_cmpxchg() to attempt to update
the head with the new value. If the head has not changed since we sampled it,
it will succeed and we are done. Otherwise, we rerun the calculation again from
a new sample of the head.

This allows us to remove the grant lock from around all the grant head space
manipulations, and that effectively removes the grant lock from the log
completely.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c |  133 ++++++++++++++++++++++++++++++------------------------
 1 files changed, 74 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8365496..50cf6af 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -111,6 +111,13 @@ STATIC int	xlog_iclogs_empty(xlog_t *log);
  * is the byte offset into the log for the marker. Unlike the xfs_lsn_t, this
  * is held in bytes rather than basic blocks, even though it uses the
  * BLOCK_LSN() macro to extract it.
+ *
+ * We use a lock-free compare and exchange algorithm to atomically update
+ * the grant head. That is, we sample the current head, crack it, perform the
+ * calculation, recombine it into a new value, and then conditionally set the
+ * value back into the atomic variable only if it hasn't changed since we first
+ * sampled it. This provides atomic updates of the head, even though we do
+ * non-atomic, multi-step calculation to arrive at the new value.
  */
 static void
 __xlog_grant_sub_space(
@@ -119,16 +126,23 @@ __xlog_grant_sub_space(
 	int		logsize)
 {
 	xfs_lsn_t	head_lsn = atomic64_read(head);
-	int		cycle, space;
+	xfs_lsn_t	old, new;
 
-	cycle = CYCLE_LSN(head_lsn);
-	space = BLOCK_LSN(head_lsn);
-	space -= bytes;
-	if (space < 0) {
-		cycle--;
-		space += logsize;
-	}
-	atomic64_set(head, xlog_assign_lsn(cycle, space));
+	do {
+		int	cycle, space;
+
+		cycle = CYCLE_LSN(head_lsn);
+		space = BLOCK_LSN(head_lsn);
+		space -= bytes;
+		if (space < 0) {
+			cycle--;
+			space += logsize;
+		}
+
+		old = head_lsn;
+		new = xlog_assign_lsn(cycle, space);
+		head_lsn = atomic64_cmpxchg(head, old, new);
+	} while (head_lsn != old);
 }
 
 static void
@@ -138,18 +152,25 @@ __xlog_grant_add_space(
 	int		logsize)
 {
 	xfs_lsn_t	head_lsn = atomic64_read(head);
-	int		cycle, space, tmp;
+	xfs_lsn_t	old, new;
 
-	cycle = CYCLE_LSN(head_lsn);
-	space = BLOCK_LSN(head_lsn);
-	tmp = logsize - space;
-	if (tmp > bytes)
-		space += bytes;
-	else {
-		cycle++;
-		space = bytes - tmp;
-	}
-	atomic64_set(head, xlog_assign_lsn(cycle, space));
+	do {
+		int	cycle, space, tmp;
+
+		cycle = CYCLE_LSN(head_lsn);
+		space = BLOCK_LSN(head_lsn);
+		tmp = logsize - space;
+		if (tmp > bytes)
+			space += bytes;
+		else {
+			cycle++;
+			space = bytes - tmp;
+		}
+
+		old = head_lsn;
+		new = xlog_assign_lsn(cycle, space);
+		head_lsn = atomic64_cmpxchg(head, old, new);
+	} while (head_lsn != old);
 }
 
 static inline void
@@ -360,11 +381,9 @@ xfs_log_reserve(
 
 		trace_xfs_log_reserve(log, internal_ticket);
 
-		spin_lock(&log->l_grant_lock);
 		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
 				    atomic64_read(&log->l_last_sync_lsn),
 				    internal_ticket->t_unit_res);
-		spin_unlock(&log->l_grant_lock);
 		retval = xlog_regrant_write_log_space(log, internal_ticket);
 	} else {
 		/* may sleep if need to allocate more tickets */
@@ -378,12 +397,10 @@ xfs_log_reserve(
 
 		trace_xfs_log_reserve(log, internal_ticket);
 
-		spin_lock(&log->l_grant_lock);
 		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
 				    atomic64_read(&log->l_last_sync_lsn),
 				    (internal_ticket->t_unit_res *
 				     internal_ticket->t_cnt));
-		spin_unlock(&log->l_grant_lock);
 		retval = xlog_grant_log_space(log, internal_ticket);
 	}
 
@@ -1376,9 +1393,7 @@ xlog_sync(xlog_t		*log,
 		 roundoff < BBTOB(1)));
 
 	/* move grant heads by roundoff in sync */
-	spin_lock(&log->l_grant_lock);
 	xlog_grant_add_space(log, roundoff);
-	spin_unlock(&log->l_grant_lock);
 
 	/* put cycle number in every block */
 	xlog_pack_data(log, iclog, roundoff); 
@@ -2618,13 +2633,11 @@ redo:
 	}
 
 	/* we've got enough space */
-	spin_lock(&log->l_grant_lock);
 	xlog_grant_add_space(log, need_bytes);
 
 	trace_xfs_log_grant_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	xlog_verify_grant_head(log, 1);
-	spin_unlock(&log->l_grant_lock);
 	return 0;
 
  error_return:
@@ -2752,13 +2765,11 @@ redo:
 	}
 
 	/* we've got enough space */
-	spin_lock(&log->l_grant_lock);
 	xlog_grant_add_space_write(log, need_bytes);
 
 	trace_xfs_log_regrant_write_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	xlog_verify_grant_head(log, 1);
-	spin_unlock(&log->l_grant_lock);
 	return 0;
 
 
@@ -2779,23 +2790,23 @@ redo:
 }
 
 
-/* The first cnt-1 times through here we don't need to
- * move the grant write head because the permanent
- * reservation has reserved cnt times the unit amount.
- * Release part of current permanent unit reservation and
- * reset current reservation to be one units worth.  Also
- * move grant reservation head forward.
+/*
+ * The first cnt-1 times through here we don't need to move the grant write
+ * head because the permanent reservation has reserved cnt times the unit
+ * amount.  Release part of current permanent unit reservation and reset
+ * current reservation to be one units worth.  Also move grant reservation head
+ * forward.
  */
 STATIC void
-xlog_regrant_reserve_log_space(xlog_t	     *log,
-			       xlog_ticket_t *ticket)
+xlog_regrant_reserve_log_space(
+	struct log		*log,
+	struct xlog_ticket	*ticket)
 {
 	trace_xfs_log_regrant_reserve_enter(log, ticket);
 
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	spin_lock(&log->l_grant_lock);
 	xlog_grant_sub_space(log, ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
@@ -2805,20 +2816,17 @@ xlog_regrant_reserve_log_space(xlog_t	     *log,
 	xlog_verify_grant_head(log, 1);
 
 	/* just return if we still have some of the pre-reserved space */
-	if (ticket->t_cnt > 0) {
-		spin_unlock(&log->l_grant_lock);
+	if (ticket->t_cnt > 0)
 		return;
-	}
 
 	xlog_grant_add_space_reserve(log, ticket->t_unit_res);
 
 	trace_xfs_log_regrant_reserve_exit(log, ticket);
 
 	xlog_verify_grant_head(log, 0);
-	spin_unlock(&log->l_grant_lock);
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
-}	/* xlog_regrant_reserve_log_space */
+}
 
 
 /*
@@ -2836,34 +2844,33 @@ xlog_regrant_reserve_log_space(xlog_t	     *log,
  * in the current reservation field.
  */
 STATIC void
-xlog_ungrant_log_space(xlog_t	     *log,
-		       xlog_ticket_t *ticket)
+xlog_ungrant_log_space(
+	struct log		*log,
+	struct xlog_ticket	*ticket)
 {
-	if (ticket->t_cnt > 0)
-		ticket->t_cnt--;
+	int			space;
 
-	spin_lock(&log->l_grant_lock);
 	trace_xfs_log_ungrant_enter(log, ticket);
+	if (ticket->t_cnt > 0)
+		ticket->t_cnt--;
 
-	xlog_grant_sub_space(log, ticket->t_curr_res);
-
-	trace_xfs_log_ungrant_sub(log, ticket);
-
-	/* If this is a permanent reservation ticket, we may be able to free
+	/*
+	 * If this is a permanent reservation ticket, we may be able to free
 	 * up more space based on the remaining count.
 	 */
+	space = ticket->t_curr_res;
 	if (ticket->t_cnt > 0) {
 		ASSERT(ticket->t_flags & XLOG_TIC_PERM_RESERV);
-		xlog_grant_sub_space(log, ticket->t_unit_res*ticket->t_cnt);
+		space += ticket->t_unit_res * ticket->t_cnt;
 	}
+	trace_xfs_log_ungrant_sub(log, ticket);
+	xlog_grant_sub_space(log, space);
 
 	trace_xfs_log_ungrant_exit(log, ticket);
-
 	xlog_verify_grant_head(log, 1);
-	spin_unlock(&log->l_grant_lock);
-	xfs_log_move_tail(log->l_mp, 1);
-}	/* xlog_ungrant_log_space */
 
+	xfs_log_move_tail(log->l_mp, 1);
+}
 
 /*
  * Flush iclog to disk if this is the last reference to the given iclog and
@@ -3478,11 +3485,18 @@ xlog_verify_dest_ptr(
 		xlog_panic("xlog_verify_dest_ptr: invalid ptr");
 }
 
+/*
+ * XXX: because we cannot atomically sample both the reserve and write heads,
+ * we cannot verify them reliably as they may be sampled in the middle of
+ * racing modifications. Hence just taking snapshots of the heads can give an
+ * incorrect view of the state of log. Hence just disable this check for now.
+ */
 STATIC void
 xlog_verify_grant_head(
 	struct log	*log,
 	int		equals)
 {
+#if 0
 	xfs_lsn_t reserve = atomic64_read(&log->l_grant_reserve_head);
 	xfs_lsn_t write = atomic64_read(&log->l_grant_write_head);
 
@@ -3495,6 +3509,7 @@ xlog_verify_grant_head(
 		ASSERT(CYCLE_LSN(reserve) - 1 == CYCLE_LSN(write));
 		ASSERT(BLOCK_LSN(write) >= BLOCK_LSN(reserve));
 	}
+#endif
 }
 
 STATIC void
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
