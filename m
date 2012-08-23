Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53bVj135186 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:37 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	O83L49QvFCapBRlx for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:22 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaV-0003Gk-0O
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:11 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaK-0003eV-TX
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 041/102] xfs: add the xlog_grant_head structure
Date: Thu, 23 Aug 2012 15:01:59 +1000
Message-Id: <1345698180-13612-42-git-send-email-david@fromorbit.com>
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

Upstream commit: 28496968a6ac37c8b8c44b5156e633c581bb8378

Add a new data structure to allow sharing code between the log grant and
regrant code.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |    8 +--
 fs/xfs/xfs_log.c             |  112 +++++++++++++++++++++---------------------
 fs/xfs/xfs_log_priv.h        |   23 ++++-----
 fs/xfs/xfs_log_recover.c     |    4 +-
 4 files changed, 74 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 70c7739..cc7311c 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -786,12 +786,12 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->curr_res = tic->t_curr_res;
 		__entry->unit_res = tic->t_unit_res;
 		__entry->flags = tic->t_flags;
-		__entry->reserveq = list_empty(&log->l_reserveq);
-		__entry->writeq = list_empty(&log->l_writeq);
-		xlog_crack_grant_head(&log->l_grant_reserve_head,
+		__entry->reserveq = list_empty(&log->l_reserve_head.waiters);
+		__entry->writeq = list_empty(&log->l_write_head.waiters);
+		xlog_crack_grant_head(&log->l_reserve_head.grant,
 				&__entry->grant_reserve_cycle,
 				&__entry->grant_reserve_bytes);
-		xlog_crack_grant_head(&log->l_grant_write_head,
+		xlog_crack_grant_head(&log->l_write_head.grant,
 				&__entry->grant_write_cycle,
 				&__entry->grant_write_bytes);
 		__entry->curr_cycle = log->l_curr_cycle;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fc2b84b..5c5aa54 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -158,7 +158,7 @@ xlog_reserveq_wake(
 	struct xlog_ticket	*tic;
 	int			need_bytes;
 
-	list_for_each_entry(tic, &log->l_reserveq, t_queue) {
+	list_for_each_entry(tic, &log->l_reserve_head.waiters, t_queue) {
 		if (tic->t_flags & XLOG_TIC_PERM_RESERV)
 			need_bytes = tic->t_unit_res * tic->t_cnt;
 		else
@@ -183,7 +183,7 @@ xlog_writeq_wake(
 	struct xlog_ticket	*tic;
 	int			need_bytes;
 
-	list_for_each_entry(tic, &log->l_writeq, t_queue) {
+	list_for_each_entry(tic, &log->l_write_head.waiters, t_queue) {
 		ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
 
 		need_bytes = tic->t_unit_res;
@@ -205,7 +205,7 @@ xlog_reserveq_wait(
 	struct xlog_ticket	*tic,
 	int			need_bytes)
 {
-	list_add_tail(&tic->t_queue, &log->l_reserveq);
+	list_add_tail(&tic->t_queue, &log->l_reserve_head.waiters);
 
 	do {
 		if (XLOG_FORCED_SHUTDOWN(log))
@@ -213,7 +213,7 @@ xlog_reserveq_wait(
 		xlog_grant_push_ail(log, need_bytes);
 
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock(&log->l_grant_reserve_lock);
+		spin_unlock(&log->l_reserve_head.lock);
 
 		XFS_STATS_INC(xs_sleep_logspace);
 
@@ -221,10 +221,10 @@ xlog_reserveq_wait(
 		schedule();
 		trace_xfs_log_grant_wake(log, tic);
 
-		spin_lock(&log->l_grant_reserve_lock);
+		spin_lock(&log->l_reserve_head.lock);
 		if (XLOG_FORCED_SHUTDOWN(log))
 			goto shutdown;
-	} while (xlog_space_left(log, &log->l_grant_reserve_head) < need_bytes);
+	} while (xlog_space_left(log, &log->l_reserve_head.grant) < need_bytes);
 
 	list_del_init(&tic->t_queue);
 	return 0;
@@ -239,7 +239,7 @@ xlog_writeq_wait(
 	struct xlog_ticket	*tic,
 	int			need_bytes)
 {
-	list_add_tail(&tic->t_queue, &log->l_writeq);
+	list_add_tail(&tic->t_queue, &log->l_write_head.waiters);
 
 	do {
 		if (XLOG_FORCED_SHUTDOWN(log))
@@ -247,7 +247,7 @@ xlog_writeq_wait(
 		xlog_grant_push_ail(log, need_bytes);
 
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock(&log->l_grant_write_lock);
+		spin_unlock(&log->l_write_head.lock);
 
 		XFS_STATS_INC(xs_sleep_logspace);
 
@@ -255,10 +255,10 @@ xlog_writeq_wait(
 		schedule();
 		trace_xfs_log_regrant_write_wake(log, tic);
 
-		spin_lock(&log->l_grant_write_lock);
+		spin_lock(&log->l_write_head.lock);
 		if (XLOG_FORCED_SHUTDOWN(log))
 			goto shutdown;
-	} while (xlog_space_left(log, &log->l_grant_write_head) < need_bytes);
+	} while (xlog_space_left(log, &log->l_write_head.grant) < need_bytes);
 
 	list_del_init(&tic->t_queue);
 	return 0;
@@ -811,22 +811,22 @@ xfs_log_space_wake(
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
 
-	if (!list_empty_careful(&log->l_writeq)) {
+	if (!list_empty_careful(&log->l_write_head.waiters)) {
 		ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
 
-		spin_lock(&log->l_grant_write_lock);
-		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
+		spin_lock(&log->l_write_head.lock);
+		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
 		xlog_writeq_wake(log, &free_bytes);
-		spin_unlock(&log->l_grant_write_lock);
+		spin_unlock(&log->l_write_head.lock);
 	}
 
-	if (!list_empty_careful(&log->l_reserveq)) {
+	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
 		ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
 
-		spin_lock(&log->l_grant_reserve_lock);
-		free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
+		spin_lock(&log->l_reserve_head.lock);
+		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
 		xlog_reserveq_wake(log, &free_bytes);
-		spin_unlock(&log->l_grant_reserve_lock);
+		spin_unlock(&log->l_reserve_head.lock);
 	}
 }
 
@@ -1108,12 +1108,12 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	xlog_assign_atomic_lsn(&log->l_tail_lsn, 1, 0);
 	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
-	xlog_assign_grant_head(&log->l_grant_reserve_head, 1, 0);
-	xlog_assign_grant_head(&log->l_grant_write_head, 1, 0);
-	INIT_LIST_HEAD(&log->l_reserveq);
-	INIT_LIST_HEAD(&log->l_writeq);
-	spin_lock_init(&log->l_grant_reserve_lock);
-	spin_lock_init(&log->l_grant_write_lock);
+	xlog_assign_grant_head(&log->l_reserve_head.grant, 1, 0);
+	xlog_assign_grant_head(&log->l_write_head.grant, 1, 0);
+	INIT_LIST_HEAD(&log->l_reserve_head.waiters);
+	INIT_LIST_HEAD(&log->l_write_head.waiters);
+	spin_lock_init(&log->l_reserve_head.lock);
+	spin_lock_init(&log->l_write_head.lock);
 
 	error = EFSCORRUPTED;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {
@@ -1293,7 +1293,7 @@ xlog_grant_push_ail(
 
 	ASSERT(BTOBB(need_bytes) < log->l_logBBsize);
 
-	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
+	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
 	free_blocks = BTOBBT(free_bytes);
 
 	/*
@@ -1427,8 +1427,8 @@ xlog_sync(xlog_t		*log,
 		 roundoff < BBTOB(1)));
 
 	/* move grant heads by roundoff in sync */
-	xlog_grant_add_space(log, &log->l_grant_reserve_head, roundoff);
-	xlog_grant_add_space(log, &log->l_grant_write_head, roundoff);
+	xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
+	xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
 
 	/* put cycle number in every block */
 	xlog_pack_data(log, iclog, roundoff); 
@@ -2595,8 +2595,8 @@ restart:
  * path. Hence any lock will be globally hot if we take it unconditionally on
  * every pass.
  *
- * As tickets are only ever moved on and off the reserveq under the
- * l_grant_reserve_lock, we only need to take that lock if we are going to add
+ * As tickets are only ever moved on and off the l_reserve.waiters under the
+ * l_reserve.lock, we only need to take that lock if we are going to add
  * the ticket to the queue and sleep. We can avoid taking the lock if the ticket
  * was never added to the reserveq because the t_queue list head will be empty
  * and we hold the only reference to it so it can safely be checked unlocked.
@@ -2622,23 +2622,23 @@ xlog_grant_log_space(
 	need_bytes = tic->t_unit_res;
 	if (tic->t_flags & XFS_LOG_PERM_RESERV)
 		need_bytes *= tic->t_ocnt;
-	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
-	if (!list_empty_careful(&log->l_reserveq)) {
-		spin_lock(&log->l_grant_reserve_lock);
+	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
+	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
+		spin_lock(&log->l_reserve_head.lock);
 		if (!xlog_reserveq_wake(log, &free_bytes) ||
 		    free_bytes < need_bytes)
 			error = xlog_reserveq_wait(log, tic, need_bytes);
-		spin_unlock(&log->l_grant_reserve_lock);
+		spin_unlock(&log->l_reserve_head.lock);
 	} else if (free_bytes < need_bytes) {
-		spin_lock(&log->l_grant_reserve_lock);
+		spin_lock(&log->l_reserve_head.lock);
 		error = xlog_reserveq_wait(log, tic, need_bytes);
-		spin_unlock(&log->l_grant_reserve_lock);
+		spin_unlock(&log->l_reserve_head.lock);
 	}
 	if (error)
 		return error;
 
-	xlog_grant_add_space(log, &log->l_grant_reserve_head, need_bytes);
-	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
+	xlog_grant_add_space(log, &log->l_reserve_head.grant, need_bytes);
+	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
 	trace_xfs_log_grant_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
@@ -2675,23 +2675,23 @@ xlog_regrant_write_log_space(
 	 * otherwise try to get some space for this transaction.
 	 */
 	need_bytes = tic->t_unit_res;
-	free_bytes = xlog_space_left(log, &log->l_grant_write_head);
-	if (!list_empty_careful(&log->l_writeq)) {
-		spin_lock(&log->l_grant_write_lock);
+	free_bytes = xlog_space_left(log, &log->l_write_head.grant);
+	if (!list_empty_careful(&log->l_write_head.waiters)) {
+		spin_lock(&log->l_write_head.lock);
 		if (!xlog_writeq_wake(log, &free_bytes) ||
 		    free_bytes < need_bytes)
 			error = xlog_writeq_wait(log, tic, need_bytes);
-		spin_unlock(&log->l_grant_write_lock);
+		spin_unlock(&log->l_write_head.lock);
 	} else if (free_bytes < need_bytes) {
-		spin_lock(&log->l_grant_write_lock);
+		spin_lock(&log->l_write_head.lock);
 		error = xlog_writeq_wait(log, tic, need_bytes);
-		spin_unlock(&log->l_grant_write_lock);
+		spin_unlock(&log->l_write_head.lock);
 	}
 
 	if (error)
 		return error;
 
-	xlog_grant_add_space(log, &log->l_grant_write_head, need_bytes);
+	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
 	trace_xfs_log_regrant_write_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
@@ -2713,9 +2713,9 @@ xlog_regrant_reserve_log_space(xlog_t	     *log,
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	xlog_grant_sub_space(log, &log->l_grant_reserve_head,
+	xlog_grant_sub_space(log, &log->l_reserve_head.grant,
 					ticket->t_curr_res);
-	xlog_grant_sub_space(log, &log->l_grant_write_head,
+	xlog_grant_sub_space(log, &log->l_write_head.grant,
 					ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
@@ -2726,7 +2726,7 @@ xlog_regrant_reserve_log_space(xlog_t	     *log,
 	if (ticket->t_cnt > 0)
 		return;
 
-	xlog_grant_add_space(log, &log->l_grant_reserve_head,
+	xlog_grant_add_space(log, &log->l_reserve_head.grant,
 					ticket->t_unit_res);
 
 	trace_xfs_log_regrant_reserve_exit(log, ticket);
@@ -2772,8 +2772,8 @@ xlog_ungrant_log_space(xlog_t	     *log,
 		bytes += ticket->t_unit_res*ticket->t_cnt;
 	}
 
-	xlog_grant_sub_space(log, &log->l_grant_reserve_head, bytes);
-	xlog_grant_sub_space(log, &log->l_grant_write_head, bytes);
+	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
+	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
 
 	trace_xfs_log_ungrant_exit(log, ticket);
 
@@ -3400,7 +3400,7 @@ xlog_verify_grant_tail(
 	int		tail_cycle, tail_blocks;
 	int		cycle, space;
 
-	xlog_crack_grant_head(&log->l_grant_write_head, &cycle, &space);
+	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &space);
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_blocks);
 	if (tail_cycle != cycle) {
 		if (cycle - 1 != tail_cycle &&
@@ -3670,15 +3670,15 @@ xfs_log_force_umount(
 	 * we don't enqueue anything once the SHUTDOWN flag is set, and this
 	 * action is protected by the grant locks.
 	 */
-	spin_lock(&log->l_grant_reserve_lock);
-	list_for_each_entry(tic, &log->l_reserveq, t_queue)
+	spin_lock(&log->l_reserve_head.lock);
+	list_for_each_entry(tic, &log->l_reserve_head.waiters, t_queue)
 		wake_up_process(tic->t_task);
-	spin_unlock(&log->l_grant_reserve_lock);
+	spin_unlock(&log->l_reserve_head.lock);
 
-	spin_lock(&log->l_grant_write_lock);
-	list_for_each_entry(tic, &log->l_writeq, t_queue)
+	spin_lock(&log->l_write_head.lock);
+	list_for_each_entry(tic, &log->l_write_head.waiters, t_queue)
 		wake_up_process(tic->t_task);
-	spin_unlock(&log->l_grant_write_lock);
+	spin_unlock(&log->l_write_head.lock);
 
 	if (!(log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
 		ASSERT(!logerror);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index d8c5e47..eba4ec9 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -470,6 +470,16 @@ struct xfs_cil {
 #define XLOG_CIL_HARD_SPACE_LIMIT(log)	(3 * (log->l_logsize >> 4))
 
 /*
+ * ticket grant locks, queues and accounting have their own cachlines
+ * as these are quite hot and can be operated on concurrently.
+ */
+struct xlog_grant_head {
+	spinlock_t		lock ____cacheline_aligned_in_smp;
+	struct list_head	waiters;
+	atomic64_t		grant;
+};
+
+/*
  * The reservation head lsn is not made up of a cycle number and block number.
  * Instead, it uses a cycle number and byte number.  Logs don't expect to
  * overflow 31 bits worth of byte offset, so using a byte number will mean
@@ -520,17 +530,8 @@ typedef struct log {
 	/* lsn of 1st LR with unflushed * buffers */
 	atomic64_t		l_tail_lsn ____cacheline_aligned_in_smp;
 
-	/*
-	 * ticket grant locks, queues and accounting have their own cachlines
-	 * as these are quite hot and can be operated on concurrently.
-	 */
-	spinlock_t		l_grant_reserve_lock ____cacheline_aligned_in_smp;
-	struct list_head	l_reserveq;
-	atomic64_t		l_grant_reserve_head;
-
-	spinlock_t		l_grant_write_lock ____cacheline_aligned_in_smp;
-	struct list_head	l_writeq;
-	atomic64_t		l_grant_write_head;
+	struct xlog_grant_head	l_reserve_head;
+	struct xlog_grant_head	l_write_head;
 
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index eead6dd..687bc9f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -964,9 +964,9 @@ xlog_find_tail(
 		log->l_curr_cycle++;
 	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
 	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
-	xlog_assign_grant_head(&log->l_grant_reserve_head, log->l_curr_cycle,
+	xlog_assign_grant_head(&log->l_reserve_head.grant, log->l_curr_cycle,
 					BBTOB(log->l_curr_block));
-	xlog_assign_grant_head(&log->l_grant_write_head, log->l_curr_cycle,
+	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
 					BBTOB(log->l_curr_block));
 
 	/*
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
