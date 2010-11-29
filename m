Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bXUk082227 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:33 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4987A1AE77D
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:39:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	mb4mYarBatTk7br7 for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:39:13 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	48209029-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:09:12 +1030 (CDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMshp-0000dW-LT
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:39:01 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMshQ-0005cb-9C
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/14] xfs: convert log grant heads to atomic variables
Date: Mon, 29 Nov 2010 12:38:26 +1100
Message-Id: <1290994712-21376-9-git-send-email-david@fromorbit.com>
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

Convert the log grant heads to atomic64_t types in preparation for
converting the accounting algorithms to atomic operations. his patch
just converts the variables; the algorithmic changes are in a
separate patch for clarity.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |   18 +++++++------
 fs/xfs/xfs_log.c             |   54 +++++++++++++++++++++--------------------
 fs/xfs/xfs_log_priv.h        |    4 +-
 fs/xfs/xfs_log_recover.c     |    8 +++---
 4 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index d2cdc85..68c3bdd 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -768,8 +768,8 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__field(unsigned int, flags)
 		__field(void *, reserveq)
 		__field(void *, writeq)
-		__field(xfs_lsn_t, grant_reserve_lsn)
-		__field(xfs_lsn_t, grant_write_lsn)
+		__field(xfs_lsn_t, grant_reserve_head)
+		__field(xfs_lsn_t, grant_write_head)
 		__field(int, curr_cycle)
 		__field(int, curr_block)
 		__field(xfs_lsn_t, tail_lsn)
@@ -784,8 +784,10 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->flags = tic->t_flags;
 		__entry->reserveq = log->l_reserveq.next;
 		__entry->writeq = log->l_writeq.next;
-		__entry->grant_reserve_lsn = log->l_grant_reserve_lsn;
-		__entry->grant_write_lsn = log->l_grant_write_lsn;
+		__entry->grant_reserve_head =
+				atomic64_read(&log->l_grant_reserve_head);
+		__entry->grant_write_head =
+				atomic64_read(&log->l_grant_write_head);
 		__entry->curr_cycle = log->l_curr_cycle;
 		__entry->curr_block = log->l_curr_block;
 		__entry->tail_lsn = atomic64_read(&log->l_tail_lsn);
@@ -805,10 +807,10 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		  __print_flags(__entry->flags, "|", XLOG_TIC_FLAGS),
 		  __entry->reserveq,
 		  __entry->writeq,
-		  CYCLE_LSN(__entry->grant_reserve_lsn),
-		  BLOCK_LSN(__entry->grant_reserve_lsn),
-		  CYCLE_LSN(__entry->grant_write_lsn),
-		  BLOCK_LSN(__entry->grant_write_lsn),
+		  CYCLE_LSN(__entry->grant_reserve_head),
+		  BLOCK_LSN(__entry->grant_reserve_head),
+		  CYCLE_LSN(__entry->grant_write_head),
+		  BLOCK_LSN(__entry->grant_write_head),
 		  __entry->curr_cycle,
 		  __entry->curr_block,
 		  CYCLE_LSN(__entry->tail_lsn),
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 647f724..6298310 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -114,32 +114,34 @@ STATIC int	xlog_iclogs_empty(xlog_t *log);
  */
 static void
 __xlog_grant_sub_space(
-	xfs_lsn_t	*head,
+	atomic64_t	*head,
 	int		bytes,
 	int		logsize)
 {
+	xfs_lsn_t	head_lsn = atomic64_read(head);
 	int		cycle, space;
 
-	cycle = CYCLE_LSN(*head);
-	space = BLOCK_LSN(*head);
+	cycle = CYCLE_LSN(head_lsn);
+	space = BLOCK_LSN(head_lsn);
 	space -= bytes;
 	if (space < 0) {
 		cycle--;
 		space += logsize;
 	}
-	*head = xlog_assign_lsn(cycle, space);
+	atomic64_set(head, xlog_assign_lsn(cycle, space));
 }
 
 static void
 __xlog_grant_add_space(
-	xfs_lsn_t	*head,
+	atomic64_t	*head,
 	int		bytes,
 	int		logsize)
 {
+	xfs_lsn_t	head_lsn = atomic64_read(head);
 	int		cycle, space, tmp;
 
-	cycle = CYCLE_LSN(*head);
-	space = BLOCK_LSN(*head);
+	cycle = CYCLE_LSN(head_lsn);
+	space = BLOCK_LSN(head_lsn);
 	tmp = logsize - space;
 	if (tmp > bytes)
 		space += bytes;
@@ -147,27 +149,27 @@ __xlog_grant_add_space(
 		cycle++;
 		space = bytes - tmp;
 	}
-	*head = xlog_assign_lsn(cycle, space);
+	atomic64_set(head, xlog_assign_lsn(cycle, space));
 }
 
 static inline void
 xlog_grant_sub_space(struct log *log, int bytes)
 {
-	__xlog_grant_sub_space(&log->l_grant_write_lsn, bytes, log->l_logsize);
-	__xlog_grant_sub_space(&log->l_grant_reserve_lsn, bytes,
+	__xlog_grant_sub_space(&log->l_grant_write_head, bytes, log->l_logsize);
+	__xlog_grant_sub_space(&log->l_grant_reserve_head, bytes,
 					log->l_logsize);
 }
 
 static inline void
 xlog_grant_add_space_write(struct log *log, int bytes)
 {
-	__xlog_grant_add_space(&log->l_grant_write_lsn, bytes, log->l_logsize);
+	__xlog_grant_add_space(&log->l_grant_write_head, bytes, log->l_logsize);
 }
 
 static void
 xlog_grant_add_space_reserve(struct log *log, int bytes)
 {
-	__xlog_grant_add_space(&log->l_grant_reserve_lsn, bytes,
+	__xlog_grant_add_space(&log->l_grant_reserve_head, bytes,
 					log->l_logsize);
 }
 
@@ -732,8 +734,8 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 			panic("Recovery problem");
 #endif
 		free_bytes = xlog_space_left(log->l_logsize,
-					atomic64_read(&log->l_tail_lsn),
-					log->l_grant_write_lsn);
+				atomic64_read(&log->l_tail_lsn),
+				atomic64_read(&log->l_grant_write_head));
 		list_for_each_entry(tic, &log->l_writeq, t_queue) {
 			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
 
@@ -751,8 +753,8 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 			panic("Recovery problem");
 #endif
 		free_bytes = xlog_space_left(log->l_logsize,
-					atomic64_read(&log->l_tail_lsn),
-					log->l_grant_reserve_lsn);
+				atomic64_read(&log->l_tail_lsn),
+				atomic64_read(&log->l_grant_reserve_head));
 		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
 			if (tic->t_flags & XLOG_TIC_PERM_RESERV)
 				need_bytes = tic->t_unit_res*tic->t_cnt;
@@ -1050,8 +1052,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
 	atomic64_set(&log->l_tail_lsn, xlog_assign_lsn(1, 0));
 	atomic64_set(&log->l_last_sync_lsn, atomic64_read(&log->l_tail_lsn));
-	log->l_grant_reserve_lsn = xlog_assign_lsn(1, 0);
-	log->l_grant_write_lsn = xlog_assign_lsn(1, 0);
+	atomic64_set(&log->l_grant_reserve_head, xlog_assign_lsn(1, 0));
+	atomic64_set(&log->l_grant_write_head, xlog_assign_lsn(1, 0));
 	INIT_LIST_HEAD(&log->l_reserveq);
 	INIT_LIST_HEAD(&log->l_writeq);
 
@@ -1240,7 +1242,7 @@ xlog_grant_push_ail(
 	ASSERT(BTOBB(need_bytes) < log->l_logBBsize);
 
 	free_bytes = xlog_space_left(log->l_logsize, tail_lsn,
-					log->l_grant_reserve_lsn);
+				atomic64_read(&log->l_grant_reserve_head));
 	free_blocks = BTOBBT(free_bytes);
 
 	/*
@@ -2552,8 +2554,8 @@ redo:
 		goto error_return;
 
 	free_bytes = xlog_space_left(log->l_logsize,
-					atomic64_read(&log->l_tail_lsn),
-					log->l_grant_reserve_lsn);
+				atomic64_read(&log->l_tail_lsn),
+				atomic64_read(&log->l_grant_reserve_head));
 	/*
 	 * If there is not enough space or there is queued waiter and we
 	 * are not already on the queue, we need to wait.
@@ -2641,8 +2643,8 @@ redo:
 		goto error_return;
 
 	free_bytes = xlog_space_left(log->l_logsize,
-					atomic64_read(&log->l_tail_lsn),
-					log->l_grant_write_lsn);
+				atomic64_read(&log->l_tail_lsn),
+				atomic64_read(&log->l_grant_write_head));
 	/*
 	 * If there is not enough space or there is queued waiter and we
 	 * are not already on the queue, we need to wait.
@@ -3422,8 +3424,8 @@ xlog_verify_grant_head(
 	struct log	*log,
 	int		equals)
 {
-	xfs_lsn_t reserve = log->l_grant_reserve_lsn;
-	xfs_lsn_t write = log->l_grant_write_lsn;
+	xfs_lsn_t reserve = atomic64_read(&log->l_grant_reserve_head);
+	xfs_lsn_t write = atomic64_read(&log->l_grant_write_head);
 
 	if (CYCLE_LSN(reserve) == CYCLE_LSN(write)) {
 		if (equals)
@@ -3441,7 +3443,7 @@ xlog_verify_grant_tail(
 	struct log	*log)
 {
 	xfs_lsn_t	 tail_lsn = atomic64_read(&log->l_tail_lsn);
-	xfs_lsn_t	 write_lsn = log->l_grant_write_lsn;
+	xfs_lsn_t	 write_lsn = atomic64_read(&log->l_grant_write_head);
 
 	/*
 	 * Check to make sure the grant write head didn't just over lap the
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 667d8cb..971dc8a 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -516,8 +516,8 @@ typedef struct log {
 	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
 	struct list_head	l_reserveq;
 	struct list_head	l_writeq;
-	xfs_lsn_t		l_grant_reserve_lsn;
-	xfs_lsn_t		l_grant_write_lsn;
+	atomic64_t		l_grant_reserve_head;
+	atomic64_t		l_grant_write_head;
 
 	/*
 	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c6285fd..6e7dfbb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -927,10 +927,10 @@ xlog_find_tail(
 		log->l_curr_cycle++;
 	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
 	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
-	log->l_grant_reserve_lsn = xlog_assign_lsn(log->l_curr_cycle,
-						BBTOB(log->l_curr_block));
-	log->l_grant_write_lsn = xlog_assign_lsn(log->l_curr_cycle,
-						BBTOB(log->l_curr_block));
+	atomic64_set(&log->l_grant_reserve_head,
+		xlog_assign_lsn(log->l_curr_cycle, BBTOB(log->l_curr_block)));
+	atomic64_set(&log->l_grant_write_head,
+		xlog_assign_lsn(log->l_curr_cycle, BBTOB(log->l_curr_block)));
 
 	/*
 	 * Look for unmount record.  If we find it, then we know there
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
