Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bP6m082154 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:26 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DCDB1C7C9FE
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:39:05 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	rD0A9PLZnp0bz0bn for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:39:05 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	47949951-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:09:03 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMshf-0000dK-GI
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:51 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMshQ-0005cN-1Y
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/14] xfs: convert log grant heads to LSN notation
Date: Mon, 29 Nov 2010 12:38:21 +1100
Message-Id: <1290994712-21376-4-git-send-email-david@fromorbit.com>
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

Before we can start to remove the grant lock from grant head
accounting operations, we need to be able to do atomic operations on
the grant heads themselves. Currently they are made up of two 32 bit
integers - the cycle number and the byte offset into the cycle - and
as such cannot be updated atomically.

To solve this problem, encode the grant heads into a single 64 bit
variable as though they were an LSN, where the cycle number is held
in the upper 32 bits and the byte offset in the lower 32 bits. By
using this encoding, we can use the existing lsn manipulation macros
to encode and extract the relevant details for calculations.  Once
we have the the grant heads encoded into a 64 bit variable it will
be trivial to convert them to atomic variables for lockless
manipulation later on.

Further, rework xlog_space_left() so that it is passed the new
combined value into xlog_space_left rather than a split cycle/bytes
pair to simplify the caller code by hiding the encoding inside the
xlog_space_left(). Also just pass the tail lsn in prepartion for
atomic variale conversion.

Also, factor out the common write head vs tail lsn debug code into
it's own function to hide the encoding and remove some ifdef DEBUG
mess.

Finally, redo the space calculations to work on a pointer to a grant
head so that the same calculation code is not duplicated for each
grant head. This will further simplify the conversion to atomic
grant head manipulation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |   20 ++---
 fs/xfs/xfs_log.c             |  225 ++++++++++++++++++++++++------------------
 fs/xfs/xfs_log_priv.h        |    6 +-
 fs/xfs/xfs_log_recover.c     |    8 +-
 4 files changed, 144 insertions(+), 115 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 0884f93..05a4bb9 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -768,10 +768,8 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__field(unsigned int, flags)
 		__field(void *, reserveq)
 		__field(void *, writeq)
-		__field(int, grant_reserve_cycle)
-		__field(int, grant_reserve_bytes)
-		__field(int, grant_write_cycle)
-		__field(int, grant_write_bytes)
+		__field(xfs_lsn_t, grant_reserve_lsn)
+		__field(xfs_lsn_t, grant_write_lsn)
 		__field(int, curr_cycle)
 		__field(int, curr_block)
 		__field(xfs_lsn_t, tail_lsn)
@@ -786,10 +784,8 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->flags = tic->t_flags;
 		__entry->reserveq = log->l_reserveq.next;
 		__entry->writeq = log->l_writeq.next;
-		__entry->grant_reserve_cycle = log->l_grant_reserve_cycle;
-		__entry->grant_reserve_bytes = log->l_grant_reserve_bytes;
-		__entry->grant_write_cycle = log->l_grant_write_cycle;
-		__entry->grant_write_bytes = log->l_grant_write_bytes;
+		__entry->grant_reserve_lsn = log->l_grant_reserve_lsn;
+		__entry->grant_write_lsn = log->l_grant_write_lsn;
 		__entry->curr_cycle = log->l_curr_cycle;
 		__entry->curr_block = log->l_curr_block;
 		__entry->tail_lsn = log->l_tail_lsn;
@@ -809,10 +805,10 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		  __print_flags(__entry->flags, "|", XLOG_TIC_FLAGS),
 		  __entry->reserveq,
 		  __entry->writeq,
-		  __entry->grant_reserve_cycle,
-		  __entry->grant_reserve_bytes,
-		  __entry->grant_write_cycle,
-		  __entry->grant_write_bytes,
+		  CYCLE_LSN(__entry->grant_reserve_lsn),
+		  BLOCK_LSN(__entry->grant_reserve_lsn),
+		  CYCLE_LSN(__entry->grant_write_lsn),
+		  BLOCK_LSN(__entry->grant_write_lsn),
 		  __entry->curr_cycle,
 		  __entry->curr_block,
 		  CYCLE_LSN(__entry->tail_lsn),
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 399e559..69a9563 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -47,7 +47,8 @@ STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
 				xfs_buftarg_t	*log_target,
 				xfs_daddr_t	blk_offset,
 				int		num_bblks);
-STATIC int	 xlog_space_left(xlog_t *log, int cycle, int bytes);
+STATIC int	 xlog_space_left(int logsize, xfs_lsn_t tail_lsn,
+				xfs_lsn_t head);
 STATIC int	 xlog_sync(xlog_t *log, xlog_in_core_t *iclog);
 STATIC void	 xlog_dealloc_log(xlog_t *log);
 
@@ -81,7 +82,8 @@ STATIC void xlog_ungrant_log_space(xlog_t	 *log,
 
 #if defined(DEBUG)
 STATIC void	xlog_verify_dest_ptr(xlog_t *log, char *ptr);
-STATIC void	xlog_verify_grant_head(xlog_t *log, int equals);
+STATIC void	xlog_verify_grant_head(struct log *log, int equals);
+STATIC void	xlog_verify_grant_tail(struct log *log);
 STATIC void	xlog_verify_iclog(xlog_t *log, xlog_in_core_t *iclog,
 				  int count, boolean_t syncing);
 STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
@@ -89,51 +91,82 @@ STATIC void	xlog_verify_tail_lsn(xlog_t *log, xlog_in_core_t *iclog,
 #else
 #define xlog_verify_dest_ptr(a,b)
 #define xlog_verify_grant_head(a,b)
+#define xlog_verify_grant_tail(a)
 #define xlog_verify_iclog(a,b,c,d)
 #define xlog_verify_tail_lsn(a,b,c)
 #endif
 
 STATIC int	xlog_iclogs_empty(xlog_t *log);
 
+/*
+ * Grant space calculations use 64 bit atomic variables to store the current reserve
+ * and write grant markers. However, these are really two 32 bit numbers which
+ * need to be cracked out of the 64 bit variable, modified, recombined and then
+ * written back into the 64 bit atomic variable. And it has to be done
+ * atomically (i.e. without locks).
+ *
+ * The upper 32 bits is the log cycle, just like a xfs_lsn_t. The lower 32 bits
+ * is the byte offset into the log for the marker. Unlike the xfs_lsn_t, this
+ * is held in bytes rather than basic blocks, even though it uses the
+ * BLOCK_LSN() macro to extract it.
+ */
 static void
-xlog_grant_sub_space(struct log *log, int bytes)
+__xlog_grant_sub_space(
+	xfs_lsn_t	*head,
+	int		bytes,
+	int		logsize)
 {
-	log->l_grant_write_bytes -= bytes;
-	if (log->l_grant_write_bytes < 0) {
-		log->l_grant_write_bytes += log->l_logsize;
-		log->l_grant_write_cycle--;
-	}
+	int		cycle, space;
 
-	log->l_grant_reserve_bytes -= bytes;
-	if ((log)->l_grant_reserve_bytes < 0) {
-		log->l_grant_reserve_bytes += log->l_logsize;
-		log->l_grant_reserve_cycle--;
+	cycle = CYCLE_LSN(*head);
+	space = BLOCK_LSN(*head);
+	space -= bytes;
+	if (space < 0) {
+		cycle--;
+		space += logsize;
 	}
-
+	*head = xlog_assign_lsn(cycle, space);
 }
 
 static void
-xlog_grant_add_space_write(struct log *log, int bytes)
+__xlog_grant_add_space(
+	xfs_lsn_t	*head,
+	int		bytes,
+	int		logsize)
 {
-	int tmp = log->l_logsize - log->l_grant_write_bytes;
+	int		cycle, space, tmp;
+
+	cycle = CYCLE_LSN(*head);
+	space = BLOCK_LSN(*head);
+	tmp = logsize - space;
 	if (tmp > bytes)
-		log->l_grant_write_bytes += bytes;
+		space += bytes;
 	else {
-		log->l_grant_write_cycle++;
-		log->l_grant_write_bytes = bytes - tmp;
+		cycle++;
+		space = bytes - tmp;
 	}
+	*head = xlog_assign_lsn(cycle, space);
+}
+
+static inline void
+xlog_grant_sub_space(struct log *log, int bytes)
+{
+	__xlog_grant_sub_space(&log->l_grant_write_lsn, bytes, log->l_logsize);
+	__xlog_grant_sub_space(&log->l_grant_reserve_lsn, bytes,
+					log->l_logsize);
+}
+
+static inline void
+xlog_grant_add_space_write(struct log *log, int bytes)
+{
+	__xlog_grant_add_space(&log->l_grant_write_lsn, bytes, log->l_logsize);
 }
 
 static void
 xlog_grant_add_space_reserve(struct log *log, int bytes)
 {
-	int tmp = log->l_logsize - log->l_grant_reserve_bytes;
-	if (tmp > bytes)
-		log->l_grant_reserve_bytes += bytes;
-	else {
-		log->l_grant_reserve_cycle++;
-		log->l_grant_reserve_bytes = bytes - tmp;
-	}
+	__xlog_grant_add_space(&log->l_grant_reserve_lsn, bytes,
+					log->l_logsize);
 }
 
 static inline void
@@ -671,7 +704,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 {
 	xlog_ticket_t	*tic;
 	xlog_t		*log = mp->m_log;
-	int		need_bytes, free_bytes, cycle, bytes;
+	int		need_bytes, free_bytes;
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
@@ -697,9 +730,8 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
 #endif
-		cycle = log->l_grant_write_cycle;
-		bytes = log->l_grant_write_bytes;
-		free_bytes = xlog_space_left(log, cycle, bytes);
+		free_bytes = xlog_space_left(log->l_logsize, log->l_tail_lsn,
+						log->l_grant_write_lsn);
 		list_for_each_entry(tic, &log->l_writeq, t_queue) {
 			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
 
@@ -716,9 +748,8 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
 #endif
-		cycle = log->l_grant_reserve_cycle;
-		bytes = log->l_grant_reserve_bytes;
-		free_bytes = xlog_space_left(log, cycle, bytes);
+		free_bytes = xlog_space_left(log->l_logsize, log->l_tail_lsn,
+						log->l_grant_reserve_lsn);
 		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
 			if (tic->t_flags & XLOG_TIC_PERM_RESERV)
 				need_bytes = tic->t_unit_res*tic->t_cnt;
@@ -831,37 +862,40 @@ xlog_assign_tail_lsn(xfs_mount_t *mp)
  * result is that we return the size of the log as the amount of space left.
  */
 STATIC int
-xlog_space_left(xlog_t *log, int cycle, int bytes)
+xlog_space_left(
+	int		logsize,
+	xfs_lsn_t	tail_lsn,
+	xfs_lsn_t	head)
 {
-	int free_bytes;
-	int tail_bytes;
-	int tail_cycle;
-
-	tail_bytes = BBTOB(BLOCK_LSN(log->l_tail_lsn));
-	tail_cycle = CYCLE_LSN(log->l_tail_lsn);
-	if ((tail_cycle == cycle) && (bytes >= tail_bytes)) {
-		free_bytes = log->l_logsize - (bytes - tail_bytes);
-	} else if ((tail_cycle + 1) < cycle) {
+	int		free_bytes;
+	int		tail_bytes = BBTOB(BLOCK_LSN(tail_lsn));
+	int		tail_cycle = CYCLE_LSN(tail_lsn);
+	int		head_cycle = CYCLE_LSN(head);
+	int		head_bytes = BLOCK_LSN(head);
+
+	if ((tail_cycle == head_cycle) && (head_bytes >= tail_bytes)) {
+		free_bytes = logsize - (head_bytes - tail_bytes);
+	} else if ((tail_cycle + 1) < head_cycle) {
 		return 0;
-	} else if (tail_cycle < cycle) {
-		ASSERT(tail_cycle == (cycle - 1));
-		free_bytes = tail_bytes - bytes;
+	} else if (tail_cycle < head_cycle) {
+		ASSERT(tail_cycle == (head_cycle - 1));
+		free_bytes = tail_bytes - head_bytes;
 	} else {
 		/*
 		 * The reservation head is behind the tail.
 		 * In this case we just want to return the size of the
 		 * log as the amount of space left.
 		 */
-		xfs_fs_cmn_err(CE_ALERT, log->l_mp,
+		cmn_err(CE_ALERT,
 			"xlog_space_left: head behind tail\n"
 			"  tail_cycle = %d, tail_bytes = %d\n"
 			"  GH   cycle = %d, GH   bytes = %d",
-			tail_cycle, tail_bytes, cycle, bytes);
+			tail_cycle, tail_bytes, head_cycle, head_bytes);
 		ASSERT(0);
-		free_bytes = log->l_logsize;
+		free_bytes = logsize;
 	}
 	return free_bytes;
-}	/* xlog_space_left */
+}
 
 
 /*
@@ -1018,8 +1052,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
 	log->l_last_sync_lsn = log->l_tail_lsn;
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
-	log->l_grant_reserve_cycle = 1;
-	log->l_grant_write_cycle = 1;
+	log->l_grant_reserve_lsn = xlog_assign_lsn(1, 0);
+	log->l_grant_write_lsn = xlog_assign_lsn(1, 0);
 	INIT_LIST_HEAD(&log->l_reserveq);
 	INIT_LIST_HEAD(&log->l_writeq);
 
@@ -1207,9 +1241,8 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
     ASSERT(BTOBB(need_bytes) < log->l_logBBsize);
 
     spin_lock(&log->l_grant_lock);
-    free_bytes = xlog_space_left(log,
-				 log->l_grant_reserve_cycle,
-				 log->l_grant_reserve_bytes);
+    free_bytes = xlog_space_left(log->l_logsize, log->l_tail_lsn,
+						log->l_grant_reserve_lsn);
     tail_lsn = log->l_tail_lsn;
     free_blocks = BTOBBT(free_bytes);
 
@@ -2504,9 +2537,8 @@ xlog_grant_log_space(
 {
 	int			 free_bytes;
 	int			 need_bytes;
-#ifdef DEBUG
-	xfs_lsn_t		 tail_lsn;
 
+#ifdef DEBUG
 	if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 		panic("grant Recovery problem");
 #endif
@@ -2524,8 +2556,8 @@ redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error_return;
 
-	free_bytes = xlog_space_left(log, log->l_grant_reserve_cycle,
-				     log->l_grant_reserve_bytes);
+	free_bytes = xlog_space_left(log->l_logsize, log->l_tail_lsn,
+					log->l_grant_reserve_lsn);
 	/*
 	 * If there is not enough space or there is queued waiter and we
 	 * are not already on the queue, we need to wait.
@@ -2552,20 +2584,9 @@ redo:
 
 	/* we've got enough space */
 	xlog_grant_add_space(log, need_bytes);
-#ifdef DEBUG
-	tail_lsn = log->l_tail_lsn;
-	/*
-	 * Check to make sure the grant write head didn't just over lap the
-	 * tail.  If the cycles are the same, we can't be overlapping.
-	 * Otherwise, make sure that the cycles differ by exactly one and
-	 * check the byte count.
-	 */
-	if (CYCLE_LSN(tail_lsn) != log->l_grant_write_cycle) {
-		ASSERT(log->l_grant_write_cycle-1 == CYCLE_LSN(tail_lsn));
-		ASSERT(log->l_grant_write_bytes <= BBTOB(BLOCK_LSN(tail_lsn)));
-	}
-#endif
+
 	trace_xfs_log_grant_exit(log, tic);
+	xlog_verify_grant_tail(log);
 	xlog_verify_grant_head(log, 1);
 	spin_unlock(&log->l_grant_lock);
 	return 0;
@@ -2596,9 +2617,6 @@ xlog_regrant_write_log_space(
 {
 	int			free_bytes;
 	int			need_bytes;
-#ifdef DEBUG
-	xfs_lsn_t		tail_lsn;
-#endif
 
 	tic->t_curr_res = tic->t_unit_res;
 	xlog_tic_reset_res(tic);
@@ -2620,8 +2638,8 @@ redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error_return;
 
-	free_bytes = xlog_space_left(log, log->l_grant_write_cycle,
-				     log->l_grant_write_bytes);
+	free_bytes = xlog_space_left(log->l_logsize, log->l_tail_lsn,
+					log->l_grant_write_lsn);
 	/*
 	 * If there is not enough space or there is queued waiter and we
 	 * are not already on the queue, we need to wait.
@@ -2668,16 +2686,9 @@ redo:
 
 	/* we've got enough space */
 	xlog_grant_add_space_write(log, need_bytes);
-#ifdef DEBUG
-	tail_lsn = log->l_tail_lsn;
-	if (CYCLE_LSN(tail_lsn) != log->l_grant_write_cycle) {
-		ASSERT(log->l_grant_write_cycle-1 == CYCLE_LSN(tail_lsn));
-		ASSERT(log->l_grant_write_bytes <= BBTOB(BLOCK_LSN(tail_lsn)));
-	}
-#endif
 
 	trace_xfs_log_regrant_write_exit(log, tic);
-
+	xlog_verify_grant_tail(log);
 	xlog_verify_grant_head(log, 1);
 	spin_unlock(&log->l_grant_lock);
 	return 0;
@@ -3401,18 +3412,42 @@ xlog_verify_dest_ptr(
 }
 
 STATIC void
-xlog_verify_grant_head(xlog_t *log, int equals)
+xlog_verify_grant_head(
+	struct log	*log,
+	int		equals)
 {
-    if (log->l_grant_reserve_cycle == log->l_grant_write_cycle) {
-	if (equals)
-	    ASSERT(log->l_grant_reserve_bytes >= log->l_grant_write_bytes);
-	else
-	    ASSERT(log->l_grant_reserve_bytes > log->l_grant_write_bytes);
-    } else {
-	ASSERT(log->l_grant_reserve_cycle-1 == log->l_grant_write_cycle);
-	ASSERT(log->l_grant_write_bytes >= log->l_grant_reserve_bytes);
-    }
-}	/* xlog_verify_grant_head */
+	xfs_lsn_t reserve = log->l_grant_reserve_lsn;
+	xfs_lsn_t write = log->l_grant_write_lsn;
+
+	if (CYCLE_LSN(reserve) == CYCLE_LSN(write)) {
+		if (equals)
+			ASSERT(BLOCK_LSN(reserve) >= BLOCK_LSN(write));
+		else
+			ASSERT(BLOCK_LSN(reserve) > BLOCK_LSN(write));
+	} else {
+		ASSERT(CYCLE_LSN(reserve) - 1 == CYCLE_LSN(write));
+		ASSERT(BLOCK_LSN(write) >= BLOCK_LSN(reserve));
+	}
+}
+
+STATIC void
+xlog_verify_grant_tail(
+	struct log	*log)
+{
+	xfs_lsn_t	 tail_lsn = log->l_tail_lsn;
+	xfs_lsn_t	 write_lsn = log->l_grant_write_lsn;
+
+	/*
+	 * Check to make sure the grant write head didn't just over lap the
+	 * tail.  If the cycles are the same, we can't be overlapping.
+	 * Otherwise, make sure that the cycles differ by exactly one and
+	 * check the byte count.
+	 */
+	if (CYCLE_LSN(tail_lsn) != CYCLE_LSN(write_lsn)) {
+		ASSERT(CYCLE_LSN(write_lsn) - 1 == CYCLE_LSN(tail_lsn));
+		ASSERT(BLOCK_LSN(write_lsn) <= BBTOB(BLOCK_LSN(tail_lsn)));
+	}
+}
 
 /* check if it will fit */
 STATIC void
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index d45fe2d..4ebaf07 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -519,10 +519,8 @@ typedef struct log {
 	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
 	struct list_head	l_reserveq;
 	struct list_head	l_writeq;
-	int			l_grant_reserve_cycle;
-	int			l_grant_reserve_bytes;
-	int			l_grant_write_cycle;
-	int			l_grant_write_bytes;
+	xfs_lsn_t		l_grant_reserve_lsn;
+	xfs_lsn_t		l_grant_write_lsn;
 
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index baad94a..d8c62f0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -927,10 +927,10 @@ xlog_find_tail(
 		log->l_curr_cycle++;
 	log->l_tail_lsn = be64_to_cpu(rhead->h_tail_lsn);
 	log->l_last_sync_lsn = be64_to_cpu(rhead->h_lsn);
-	log->l_grant_reserve_cycle = log->l_curr_cycle;
-	log->l_grant_reserve_bytes = BBTOB(log->l_curr_block);
-	log->l_grant_write_cycle = log->l_curr_cycle;
-	log->l_grant_write_bytes = BBTOB(log->l_curr_block);
+	log->l_grant_reserve_lsn = xlog_assign_lsn(log->l_curr_cycle,
+						BBTOB(log->l_curr_block));
+	log->l_grant_write_lsn = xlog_assign_lsn(log->l_curr_cycle,
+						BBTOB(log->l_curr_block));
 
 	/*
 	 * Look for unmount record.  If we find it, then we know there
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
