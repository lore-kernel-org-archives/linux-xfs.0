Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7SXrE244914 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:34 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36DEE1470328
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:30:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	ZgUKcNdeHWlStF9i for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:30:28 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50575237-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 18:00:27 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfn-0001E1-MG
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:15 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwfc-0006Zw-Ae
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 26/34] xfs: combine grant heads into a single 64 bit integer
Date: Tue, 21 Dec 2010 18:29:22 +1100
Message-Id: <1292916570-25015-27-git-send-email-david@fromorbit.com>
In-Reply-To: <1292916570-25015-1-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
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

Prepare for switching the grant heads to atomic variables by
combining the two 32 bit values that make up the grant head into a
single 64 bit variable.  Provide wrapper functions to combine and
split the grant heads appropriately for calculations and use them as
necessary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_trace.h |   10 ++-
 fs/xfs/xfs_log.c             |  166 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_log_priv.h        |   26 ++++++-
 fs/xfs/xfs_log_recover.c     |    8 +-
 4 files changed, 119 insertions(+), 91 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 69b9e1f..3ff6b35 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -786,10 +786,12 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->flags = tic->t_flags;
 		__entry->reserveq = list_empty(&log->l_reserveq);
 		__entry->writeq = list_empty(&log->l_writeq);
-		__entry->grant_reserve_cycle = log->l_grant_reserve_cycle;
-		__entry->grant_reserve_bytes = log->l_grant_reserve_bytes;
-		__entry->grant_write_cycle = log->l_grant_write_cycle;
-		__entry->grant_write_bytes = log->l_grant_write_bytes;
+		xlog_crack_grant_head(&log->l_grant_reserve_head,
+				&__entry->grant_reserve_cycle,
+				&__entry->grant_reserve_bytes);
+		xlog_crack_grant_head(&log->l_grant_write_head,
+				&__entry->grant_write_cycle,
+				&__entry->grant_write_bytes);
 		__entry->curr_cycle = log->l_curr_cycle;
 		__entry->curr_block = log->l_curr_block;
 		__entry->tail_lsn = log->l_tail_lsn;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9a4b9ed..6bba8b4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -47,7 +47,7 @@ STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
 				xfs_buftarg_t	*log_target,
 				xfs_daddr_t	blk_offset,
 				int		num_bblks);
-STATIC int	 xlog_space_left(xlog_t *log, int cycle, int bytes);
+STATIC int	 xlog_space_left(struct log *log, int64_t *head);
 STATIC int	 xlog_sync(xlog_t *log, xlog_in_core_t *iclog);
 STATIC void	 xlog_dealloc_log(xlog_t *log);
 
@@ -100,32 +100,44 @@ STATIC int	xlog_iclogs_empty(xlog_t *log);
 static void
 xlog_grant_sub_space(
 	struct log	*log,
-	int		*cycle,
-	int		*space,
+	int64_t		*head,
 	int		bytes)
 {
-	*space -= bytes;
-	if (*space < 0) {
-		*space += log->l_logsize;
-		(*cycle)--;
+	int		cycle, space;
+
+	xlog_crack_grant_head(head, &cycle, &space);
+
+	space -= bytes;
+	if (space < 0) {
+		space += log->l_logsize;
+		cycle--;
 	}
+
+	xlog_assign_grant_head(head, cycle, space);
 }
 
 static void
 xlog_grant_add_space(
 	struct log	*log,
-	int		*cycle,
-	int		*space,
+	int64_t		*head,
 	int		bytes)
 {
-	int tmp = log->l_logsize - *space;
+	int		tmp;
+	int		cycle, space;
+
+	xlog_crack_grant_head(head, &cycle, &space);
+
+	tmp = log->l_logsize - space;
 	if (tmp > bytes)
-		*space += bytes;
+		space += bytes;
 	else {
-		*space = bytes - tmp;
-		(*cycle)++;
+		space = bytes - tmp;
+		cycle++;
 	}
+
+	xlog_assign_grant_head(head, cycle, space);
 }
+
 static void
 xlog_tic_reset_res(xlog_ticket_t *tic)
 {
@@ -654,7 +666,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 {
 	xlog_ticket_t	*tic;
 	xlog_t		*log = mp->m_log;
-	int		need_bytes, free_bytes, cycle, bytes;
+	int		need_bytes, free_bytes;
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
@@ -680,9 +692,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
 #endif
-		cycle = log->l_grant_write_cycle;
-		bytes = log->l_grant_write_bytes;
-		free_bytes = xlog_space_left(log, cycle, bytes);
+		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
 		list_for_each_entry(tic, &log->l_writeq, t_queue) {
 			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
 
@@ -699,9 +709,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
 #endif
-		cycle = log->l_grant_reserve_cycle;
-		bytes = log->l_grant_reserve_bytes;
-		free_bytes = xlog_space_left(log, cycle, bytes);
+		free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
 		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
 			if (tic->t_flags & XLOG_TIC_PERM_RESERV)
 				need_bytes = tic->t_unit_res*tic->t_cnt;
@@ -814,21 +822,26 @@ xlog_assign_tail_lsn(xfs_mount_t *mp)
  * result is that we return the size of the log as the amount of space left.
  */
 STATIC int
-xlog_space_left(xlog_t *log, int cycle, int bytes)
+xlog_space_left(
+	struct log	*log,
+	int64_t		*head)
 {
-	int free_bytes;
-	int tail_bytes;
-	int tail_cycle;
+	int		free_bytes;
+	int		tail_bytes;
+	int		tail_cycle;
+	int		head_cycle;
+	int		head_bytes;
 
+	xlog_crack_grant_head(head, &head_cycle, &head_bytes);
 	tail_bytes = BBTOB(BLOCK_LSN(log->l_tail_lsn));
 	tail_cycle = CYCLE_LSN(log->l_tail_lsn);
-	if ((tail_cycle == cycle) && (bytes >= tail_bytes)) {
-		free_bytes = log->l_logsize - (bytes - tail_bytes);
-	} else if ((tail_cycle + 1) < cycle) {
+	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
+		free_bytes = log->l_logsize - (head_bytes - tail_bytes);
+	else if (tail_cycle + 1 < head_cycle)
 		return 0;
-	} else if (tail_cycle < cycle) {
-		ASSERT(tail_cycle == (cycle - 1));
-		free_bytes = tail_bytes - bytes;
+	else if (tail_cycle < head_cycle) {
+		ASSERT(tail_cycle == (head_cycle - 1));
+		free_bytes = tail_bytes - head_bytes;
 	} else {
 		/*
 		 * The reservation head is behind the tail.
@@ -839,12 +852,12 @@ xlog_space_left(xlog_t *log, int cycle, int bytes)
 			"xlog_space_left: head behind tail\n"
 			"  tail_cycle = %d, tail_bytes = %d\n"
 			"  GH   cycle = %d, GH   bytes = %d",
-			tail_cycle, tail_bytes, cycle, bytes);
+			tail_cycle, tail_bytes, head_cycle, head_bytes);
 		ASSERT(0);
 		free_bytes = log->l_logsize;
 	}
 	return free_bytes;
-}	/* xlog_space_left */
+}
 
 
 /*
@@ -1001,8 +1014,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
 	log->l_last_sync_lsn = log->l_tail_lsn;
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
-	log->l_grant_reserve_cycle = 1;
-	log->l_grant_write_cycle = 1;
+	xlog_assign_grant_head(&log->l_grant_reserve_head, 1, 0);
+	xlog_assign_grant_head(&log->l_grant_write_head, 1, 0);
 	INIT_LIST_HEAD(&log->l_reserveq);
 	INIT_LIST_HEAD(&log->l_writeq);
 
@@ -1190,9 +1203,7 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
     ASSERT(BTOBB(need_bytes) < log->l_logBBsize);
 
     spin_lock(&log->l_grant_lock);
-    free_bytes = xlog_space_left(log,
-				 log->l_grant_reserve_cycle,
-				 log->l_grant_reserve_bytes);
+    free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
     tail_lsn = log->l_tail_lsn;
     free_blocks = BTOBBT(free_bytes);
 
@@ -1325,10 +1336,8 @@ xlog_sync(xlog_t		*log,
 
 	/* move grant heads by roundoff in sync */
 	spin_lock(&log->l_grant_lock);
-	xlog_grant_add_space(log, &log->l_grant_reserve_cycle,
-				&log->l_grant_reserve_bytes, roundoff);
-	xlog_grant_add_space(log, &log->l_grant_write_cycle,
-				&log->l_grant_write_bytes, roundoff);
+	xlog_grant_add_space(log, &log->l_grant_reserve_head, roundoff);
+	xlog_grant_add_space(log, &log->l_grant_write_head, roundoff);
 	spin_unlock(&log->l_grant_lock);
 
 	/* put cycle number in every block */
@@ -2531,8 +2540,7 @@ redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error_return;
 
-	free_bytes = xlog_space_left(log, log->l_grant_reserve_cycle,
-				     log->l_grant_reserve_bytes);
+	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
 	if (free_bytes < need_bytes) {
 		if (list_empty(&tic->t_queue))
 			list_add_tail(&tic->t_queue, &log->l_reserveq);
@@ -2558,10 +2566,8 @@ redo:
 	list_del_init(&tic->t_queue);
 
 	/* we've got enough space */
-	xlog_grant_add_space(log, &log->l_grant_reserve_cycle,
-				&log->l_grant_reserve_bytes, need_bytes);
-	xlog_grant_add_space(log, &log->l_grant_write_cycle,
-				&log->l_grant_write_bytes, need_bytes);
+	xlog_grant_add_space(log, &log->l_grant_reserve_head, need_bytes);
+	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
 	trace_xfs_log_grant_exit(log, tic);
 	xlog_verify_grant_head(log, 1);
 	xlog_verify_grant_tail(log);
@@ -2622,8 +2628,7 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 	need_bytes = tic->t_unit_res;
 	if (!list_empty(&log->l_writeq)) {
 		struct xlog_ticket *ntic;
-		free_bytes = xlog_space_left(log, log->l_grant_write_cycle,
-					     log->l_grant_write_bytes);
+		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
 		list_for_each_entry(ntic, &log->l_writeq, t_queue) {
 			ASSERT(ntic->t_flags & XLOG_TIC_PERM_RESERV);
 
@@ -2662,8 +2667,7 @@ redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error_return;
 
-	free_bytes = xlog_space_left(log, log->l_grant_write_cycle,
-				     log->l_grant_write_bytes);
+	free_bytes = xlog_space_left(log, &log->l_grant_write_head);
 	if (free_bytes < need_bytes) {
 		if (list_empty(&tic->t_queue))
 			list_add_tail(&tic->t_queue, &log->l_writeq);
@@ -2688,8 +2692,7 @@ redo:
 	list_del_init(&tic->t_queue);
 
 	/* we've got enough space */
-	xlog_grant_add_space(log, &log->l_grant_write_cycle,
-				&log->l_grant_write_bytes, need_bytes);
+	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
 	trace_xfs_log_regrant_write_exit(log, tic);
 	xlog_verify_grant_head(log, 1);
 	xlog_verify_grant_tail(log);
@@ -2730,12 +2733,10 @@ xlog_regrant_reserve_log_space(xlog_t	     *log,
 		ticket->t_cnt--;
 
 	spin_lock(&log->l_grant_lock);
-	xlog_grant_sub_space(log, &log->l_grant_reserve_cycle,
-				&log->l_grant_reserve_bytes,
-				ticket->t_curr_res);
-	xlog_grant_sub_space(log, &log->l_grant_write_cycle,
-				&log->l_grant_write_bytes,
-				ticket->t_curr_res);
+	xlog_grant_sub_space(log, &log->l_grant_reserve_head,
+					ticket->t_curr_res);
+	xlog_grant_sub_space(log, &log->l_grant_write_head,
+					ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
 
@@ -2749,9 +2750,8 @@ xlog_regrant_reserve_log_space(xlog_t	     *log,
 		return;
 	}
 
-	xlog_grant_add_space(log, &log->l_grant_reserve_cycle,
-				&log->l_grant_reserve_bytes,
-				ticket->t_unit_res);
+	xlog_grant_add_space(log, &log->l_grant_reserve_head,
+					ticket->t_unit_res);
 
 	trace_xfs_log_regrant_reserve_exit(log, ticket);
 
@@ -2799,10 +2799,8 @@ xlog_ungrant_log_space(xlog_t	     *log,
 		bytes += ticket->t_unit_res*ticket->t_cnt;
 	}
 
-	xlog_grant_sub_space(log, &log->l_grant_reserve_cycle,
-				&log->l_grant_reserve_bytes, bytes);
-	xlog_grant_sub_space(log, &log->l_grant_write_cycle,
-				&log->l_grant_write_bytes, bytes);
+	xlog_grant_sub_space(log, &log->l_grant_reserve_head, bytes);
+	xlog_grant_sub_space(log, &log->l_grant_write_head, bytes);
 
 	trace_xfs_log_ungrant_exit(log, ticket);
 
@@ -3430,22 +3428,31 @@ xlog_verify_dest_ptr(
 STATIC void
 xlog_verify_grant_head(xlog_t *log, int equals)
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
+	int	reserve_cycle, reserve_space;
+	int	write_cycle, write_space;
+
+	xlog_crack_grant_head(&log->l_grant_reserve_head,
+					&reserve_cycle, &reserve_space);
+	xlog_crack_grant_head(&log->l_grant_write_head,
+					&write_cycle, &write_space);
+
+	if (reserve_cycle == write_cycle) {
+		if (equals)
+			ASSERT(reserve_space >= write_space);
+		else
+			ASSERT(reserve_space > write_space);
+	} else {
+		ASSERT(reserve_cycle - 1 == write_cycle);
+		ASSERT(write_space >= reserve_space);
+	}
+}
 
 STATIC void
 xlog_verify_grant_tail(
 	struct log	*log)
 {
 	xfs_lsn_t	tail_lsn = log->l_tail_lsn;
+	int		cycle, space;
 
 	/*
 	 * Check to make sure the grant write head didn't just over lap the
@@ -3453,9 +3460,10 @@ xlog_verify_grant_tail(
 	 * Otherwise, make sure that the cycles differ by exactly one and
 	 * check the byte count.
 	 */
-	if (CYCLE_LSN(tail_lsn) != log->l_grant_write_cycle) {
-		ASSERT(log->l_grant_write_cycle - 1 == CYCLE_LSN(tail_lsn));
-		ASSERT(log->l_grant_write_bytes <= BBTOB(BLOCK_LSN(tail_lsn)));
+	xlog_crack_grant_head(&log->l_grant_write_head, &cycle, &space);
+	if (CYCLE_LSN(tail_lsn) != cycle) {
+		ASSERT(cycle - 1 == CYCLE_LSN(tail_lsn));
+		ASSERT(space <= BBTOB(BLOCK_LSN(tail_lsn)));
 	}
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index a5b3c02..2f74c80 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -518,10 +518,8 @@ typedef struct log {
 	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
 	struct list_head	l_reserveq;
 	struct list_head	l_writeq;
-	int			l_grant_reserve_cycle;
-	int			l_grant_reserve_bytes;
-	int			l_grant_write_cycle;
-	int			l_grant_write_bytes;
+	int64_t			l_grant_reserve_head;
+	int64_t			l_grant_write_head;
 
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
@@ -561,6 +559,26 @@ int	xlog_write(struct log *log, struct xfs_log_vec *log_vector,
 				xlog_in_core_t **commit_iclog, uint flags);
 
 /*
+ * When we crack the grrant head, we sample it first so that the value will not
+ * change while we are cracking it into the component values. This means we
+ * will always get consistent component values to work from.
+ */
+static inline void
+xlog_crack_grant_head(int64_t *head, int *cycle, int *space)
+{
+	int64_t	val = *head;
+
+	*cycle = val >> 32;
+	*space = val & 0xffffffff;
+}
+
+static inline void
+xlog_assign_grant_head(int64_t *head, int cycle, int space)
+{
+	*head = ((int64_t)cycle << 32) | space;
+}
+
+/*
  * Committed Item List interfaces
  */
 int	xlog_cil_init(struct log *log);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4abe7a9..1550404 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -938,10 +938,10 @@ xlog_find_tail(
 		log->l_curr_cycle++;
 	log->l_tail_lsn = be64_to_cpu(rhead->h_tail_lsn);
 	log->l_last_sync_lsn = be64_to_cpu(rhead->h_lsn);
-	log->l_grant_reserve_cycle = log->l_curr_cycle;
-	log->l_grant_reserve_bytes = BBTOB(log->l_curr_block);
-	log->l_grant_write_cycle = log->l_curr_cycle;
-	log->l_grant_write_bytes = BBTOB(log->l_curr_block);
+	xlog_assign_grant_head(&log->l_grant_reserve_head, log->l_curr_cycle,
+					BBTOB(log->l_curr_block));
+	xlog_assign_grant_head(&log->l_grant_write_head, log->l_curr_cycle,
+					BBTOB(log->l_curr_block));
 
 	/*
 	 * Look for unmount record.  If we find it, then we know there
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
