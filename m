Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4tJDP160429 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:55:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1C891CBADE9
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:46:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	IQdD3FtGduIHkB6c for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:46:46 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	4436869-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:16:45 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS0J9-000234-Nj
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:46:43 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS0Hf-0004mm-ID
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:45:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/12] xfs: convert grant head manipulations to lockless
	algorithm
Date: Mon, 13 Dec 2010 15:44:42 +1100
Message-Id: <1292215483-18224-12-git-send-email-david@fromorbit.com>
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
completely. Hence we can remove the grant lock completely from the log at this
point.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      |  103 ++++++++++++++++---------------------------------
 fs/xfs/xfs_log_priv.h |   23 +++++++----
 2 files changed, 49 insertions(+), 77 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index de3ad18..58326ba 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -81,7 +81,6 @@ STATIC void xlog_ungrant_log_space(xlog_t	 *log,
 
 #if defined(DEBUG)
 STATIC void	xlog_verify_dest_ptr(xlog_t *log, char *ptr);
-STATIC void	xlog_verify_grant_head(xlog_t *log, int equals);
 STATIC void	xlog_verify_grant_tail(struct log *log);
 STATIC void	xlog_verify_iclog(xlog_t *log, xlog_in_core_t *iclog,
 				  int count, boolean_t syncing);
@@ -89,7 +88,6 @@ STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
 				     xfs_lsn_t tail_lsn);
 #else
 #define xlog_verify_dest_ptr(a,b)
-#define xlog_verify_grant_head(a,b)
 #define xlog_verify_grant_tail(a)
 #define xlog_verify_iclog(a,b,c,d)
 #define xlog_verify_tail_lsn(a,b,c)
@@ -103,17 +101,24 @@ xlog_grant_sub_space(
 	atomic64_t	*head,
 	int		bytes)
 {
-	int		cycle, space;
+	int64_t	head_val = atomic64_read(head);
+	int64_t new, old;
 
-	xlog_crack_grant_head(head, &cycle, &space);
+	do {
+		int	cycle, space;
 
-	space -= bytes;
-	if (space < 0) {
-		space += log->l_logsize;
-		cycle--;
-	}
+		xlog_crack_grant_head_val(head_val, &cycle, &space);
 
-	xlog_assign_grant_head(head, cycle, space);
+		space -= bytes;
+		if (space < 0) {
+			space += log->l_logsize;
+			cycle--;
+		}
+
+		old = head_val;
+		new = xlog_assign_grant_head_val(cycle, space);
+		head_val = atomic64_cmpxchg(head, old, new);
+	} while (head_val != old);
 }
 
 static void
@@ -122,20 +127,27 @@ xlog_grant_add_space(
 	atomic64_t	*head,
 	int		bytes)
 {
-	int		tmp;
-	int		cycle, space;
+	int64_t	head_val = atomic64_read(head);
+	int64_t new, old;
 
-	xlog_crack_grant_head(head, &cycle, &space);
+	do {
+		int		tmp;
+		int		cycle, space;
 
-	tmp = log->l_logsize - space;
-	if (tmp > bytes)
-		space += bytes;
-	else {
-		space = bytes - tmp;
-		cycle++;
-	}
+		xlog_crack_grant_head_val(head_val, &cycle, &space);
 
-	xlog_assign_grant_head(head, cycle, space);
+		tmp = log->l_logsize - space;
+		if (tmp > bytes)
+			space += bytes;
+		else {
+			space = bytes - tmp;
+			cycle++;
+		}
+
+		old = head_val;
+		new = xlog_assign_grant_head_val(cycle, space);
+		head_val = atomic64_cmpxchg(head, old, new);
+	} while (head_val != old);
 }
 
 static void
@@ -318,9 +330,7 @@ xfs_log_reserve(
 
 		trace_xfs_log_reserve(log, internal_ticket);
 
-		spin_lock(&log->l_grant_lock);
 		xlog_grant_push_ail(log, internal_ticket->t_unit_res);
-		spin_unlock(&log->l_grant_lock);
 		retval = xlog_regrant_write_log_space(log, internal_ticket);
 	} else {
 		/* may sleep if need to allocate more tickets */
@@ -334,11 +344,9 @@ xfs_log_reserve(
 
 		trace_xfs_log_reserve(log, internal_ticket);
 
-		spin_lock(&log->l_grant_lock);
 		xlog_grant_push_ail(log,
 				    (internal_ticket->t_unit_res *
 				     internal_ticket->t_cnt));
-		spin_unlock(&log->l_grant_lock);
 		retval = xlog_grant_log_space(log, internal_ticket);
 	}
 
@@ -1057,7 +1065,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_xbuf = bp;
 
 	spin_lock_init(&log->l_icloglock);
-	spin_lock_init(&log->l_grant_lock);
 	init_waitqueue_head(&log->l_flush_wait);
 
 	/* log record size must be multiple of BBSIZE; see xlog_rec_header_t */
@@ -1135,7 +1142,6 @@ out_free_iclog:
 		kmem_free(iclog);
 	}
 	spinlock_destroy(&log->l_icloglock);
-	spinlock_destroy(&log->l_grant_lock);
 	xfs_buf_free(log->l_xbuf);
 out_free_log:
 	kmem_free(log);
@@ -1331,10 +1337,8 @@ xlog_sync(xlog_t		*log,
 		 roundoff < BBTOB(1)));
 
 	/* move grant heads by roundoff in sync */
-	spin_lock(&log->l_grant_lock);
 	xlog_grant_add_space(log, &log->l_grant_reserve_head, roundoff);
 	xlog_grant_add_space(log, &log->l_grant_write_head, roundoff);
-	spin_unlock(&log->l_grant_lock);
 
 	/* put cycle number in every block */
 	xlog_pack_data(log, iclog, roundoff); 
@@ -1455,7 +1459,6 @@ xlog_dealloc_log(xlog_t *log)
 		iclog = next_iclog;
 	}
 	spinlock_destroy(&log->l_icloglock);
-	spinlock_destroy(&log->l_grant_lock);
 
 	xfs_buf_free(log->l_xbuf);
 	log->l_mp->m_log = NULL;
@@ -2574,13 +2577,10 @@ redo:
 	}
 
 	/* we've got enough space */
-	spin_lock(&log->l_grant_lock);
 	xlog_grant_add_space(log, &log->l_grant_reserve_head, need_bytes);
 	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
 	trace_xfs_log_grant_exit(log, tic);
-	xlog_verify_grant_head(log, 1);
 	xlog_verify_grant_tail(log);
-	spin_unlock(&log->l_grant_lock);
 	return 0;
 
 error_return_unlocked:
@@ -2694,12 +2694,9 @@ redo:
 	}
 
 	/* we've got enough space */
-	spin_lock(&log->l_grant_lock);
 	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
 	trace_xfs_log_regrant_write_exit(log, tic);
-	xlog_verify_grant_head(log, 1);
 	xlog_verify_grant_tail(log);
-	spin_unlock(&log->l_grant_lock);
 	return 0;
 
 
@@ -2737,7 +2734,6 @@ xlog_regrant_reserve_log_space(xlog_t	     *log,
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	spin_lock(&log->l_grant_lock);
 	xlog_grant_sub_space(log, &log->l_grant_reserve_head,
 					ticket->t_curr_res);
 	xlog_grant_sub_space(log, &log->l_grant_write_head,
@@ -2747,21 +2743,15 @@ xlog_regrant_reserve_log_space(xlog_t	     *log,
 
 	trace_xfs_log_regrant_reserve_sub(log, ticket);
 
-	xlog_verify_grant_head(log, 1);
-
 	/* just return if we still have some of the pre-reserved space */
-	if (ticket->t_cnt > 0) {
-		spin_unlock(&log->l_grant_lock);
+	if (ticket->t_cnt > 0)
 		return;
-	}
 
 	xlog_grant_add_space(log, &log->l_grant_reserve_head,
 					ticket->t_unit_res);
 
 	trace_xfs_log_regrant_reserve_exit(log, ticket);
 
-	xlog_verify_grant_head(log, 0);
-	spin_unlock(&log->l_grant_lock);
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
 }	/* xlog_regrant_reserve_log_space */
@@ -2790,7 +2780,6 @@ xlog_ungrant_log_space(xlog_t	     *log,
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	spin_lock(&log->l_grant_lock);
 	trace_xfs_log_ungrant_enter(log, ticket);
 	trace_xfs_log_ungrant_sub(log, ticket);
 
@@ -2809,8 +2798,6 @@ xlog_ungrant_log_space(xlog_t	     *log,
 
 	trace_xfs_log_ungrant_exit(log, ticket);
 
-	xlog_verify_grant_head(log, 1);
-	spin_unlock(&log->l_grant_lock);
 	xfs_log_move_tail(log->l_mp, 1);
 }	/* xlog_ungrant_log_space */
 
@@ -3429,28 +3416,6 @@ xlog_verify_dest_ptr(
 }
 
 STATIC void
-xlog_verify_grant_head(xlog_t *log, int equals)
-{
-	int	reserve_cycle, reserve_space;
-	int	write_cycle, write_space;
-
-	xlog_crack_grant_head(&log->l_grant_reserve_head,
-					&reserve_cycle, &reserve_space);
-	xlog_crack_grant_head(&log->l_grant_write_head,
-					&write_cycle, &write_space);
-
-	if (reserve_cycle == write_cycle) {
-		if (equals)
-			ASSERT(reserve_space >= write_space);
-		else
-			ASSERT(reserve_space > write_space);
-	} else {
-		ASSERT(reserve_cycle - 1 == write_cycle);
-		ASSERT(write_space >= reserve_space);
-	}
-}
-
-STATIC void
 xlog_verify_grant_tail(
 	struct log	*log)
 {
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index c8e23ff..3b59d61 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -511,9 +511,6 @@ typedef struct log {
 	int			l_curr_block;   /* current logical log block */
 	int			l_prev_block;   /* previous logical log block */
 
-	/* The following block of fields are changed while holding grant_lock */
-	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
-
 	/*
 	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
 	 * read without needing to hold specific locks. To avoid operations
@@ -597,23 +594,33 @@ xlog_assign_atomic_lsn(atomic64_t *lsn, uint cycle, uint block)
 }
 
 /*
- * When we crack the grrant head, we sample it first so that the value will not
+ * When we crack the grant head, we sample it first so that the value will not
  * change while we are cracking it into the component values. This means we
  * will always get consistent component values to work from.
  */
 static inline void
-xlog_crack_grant_head(atomic64_t *head, int *cycle, int *space)
+xlog_crack_grant_head_val(int64_t val, int *cycle, int *space)
 {
-	int64_t	val = atomic64_read(head);
-
 	*cycle = val >> 32;
 	*space = val & 0xffffffff;
 }
 
 static inline void
+xlog_crack_grant_head(atomic64_t *head, int *cycle, int *space)
+{
+	xlog_crack_grant_head_val(atomic64_read(head), cycle, space);
+}
+
+static inline int64_t
+xlog_assign_grant_head_val(int cycle, int space)
+{
+	return ((int64_t)cycle << 32) | space;
+}
+
+static inline void
 xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
 {
-	atomic64_set(head, ((int64_t)cycle << 32) | space);
+	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
 }
 
 /*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
