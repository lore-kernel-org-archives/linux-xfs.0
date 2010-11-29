Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bP9J082149 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B809A1AE77B
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:39:05 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	IDXxQeFVNO8yuFBJ for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:39:05 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	47447232-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:09:04 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMshf-0000dU-ME
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:51 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMshQ-0005cZ-7i
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/14] xfs: convert l_tail_lsn to an atomic variable.
Date: Mon, 29 Nov 2010 12:38:25 +1100
Message-Id: <1290994712-21376-8-git-send-email-david@fromorbit.com>
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

log->l_tail_lsn is currently protected by the log grant lock. The
lock is only needed for serialising readers against writers, so we
don't really need the lock if we make the l_tail_lsn variable an
atomic. Converting the l_tail_lsn variable to an atomic64_t means we
can start to peel back the grant lock from various operations.

This also removes the need for explicitly holding a spinlock to read
the l_tail_lsn on 32 bit platforms.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |    2 +-
 fs/xfs/xfs_log.c             |   62 ++++++++++++++++++++---------------------
 fs/xfs/xfs_log_priv.h        |   11 ++++---
 fs/xfs/xfs_log_recover.c     |    8 +++---
 4 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 05a4bb9..d2cdc85 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -788,7 +788,7 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->grant_write_lsn = log->l_grant_write_lsn;
 		__entry->curr_cycle = log->l_curr_cycle;
 		__entry->curr_block = log->l_curr_block;
-		__entry->tail_lsn = log->l_tail_lsn;
+		__entry->tail_lsn = atomic64_read(&log->l_tail_lsn);
 	),
 	TP_printk("dev %d:%d type %s t_ocnt %u t_cnt %u t_curr_res %u "
 		  "t_unit_res %u t_flags %s reserve_headq 0x%p "
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 90a605cc..647f724 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -359,7 +359,7 @@ xfs_log_reserve(
 		trace_xfs_log_reserve(log, internal_ticket);
 
 		spin_lock(&log->l_grant_lock);
-		xlog_grant_push_ail(log, log->l_tail_lsn,
+		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
 				    atomic64_read(&log->l_last_sync_lsn),
 				    internal_ticket->t_unit_res);
 		spin_unlock(&log->l_grant_lock);
@@ -377,7 +377,7 @@ xfs_log_reserve(
 		trace_xfs_log_reserve(log, internal_ticket);
 
 		spin_lock(&log->l_grant_lock);
-		xlog_grant_push_ail(log, log->l_tail_lsn,
+		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
 				    atomic64_read(&log->l_last_sync_lsn),
 				    (internal_ticket->t_unit_res *
 				     internal_ticket->t_cnt));
@@ -721,22 +721,19 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 	if (tail_lsn == 0)
 		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
 
-	spin_lock(&log->l_grant_lock);
-
-	/* Also an invalid lsn.  1 implies that we aren't passing in a valid
-	 * tail_lsn.
-	 */
-	if (tail_lsn != 1) {
-		log->l_tail_lsn = tail_lsn;
-	}
+	/* tail_lsn == 1 implies that we aren't passing in a valid value.  */
+	if (tail_lsn != 1)
+		atomic64_set(&log->l_tail_lsn, tail_lsn);
 
+	spin_lock(&log->l_grant_lock);
 	if (!list_empty(&log->l_writeq)) {
 #ifdef DEBUG
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
 #endif
-		free_bytes = xlog_space_left(log->l_logsize, log->l_tail_lsn,
-						log->l_grant_write_lsn);
+		free_bytes = xlog_space_left(log->l_logsize,
+					atomic64_read(&log->l_tail_lsn),
+					log->l_grant_write_lsn);
 		list_for_each_entry(tic, &log->l_writeq, t_queue) {
 			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
 
@@ -753,8 +750,9 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
 			panic("Recovery problem");
 #endif
-		free_bytes = xlog_space_left(log->l_logsize, log->l_tail_lsn,
-						log->l_grant_reserve_lsn);
+		free_bytes = xlog_space_left(log->l_logsize,
+					atomic64_read(&log->l_tail_lsn),
+					log->l_grant_reserve_lsn);
 		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
 			if (tic->t_flags & XLOG_TIC_PERM_RESERV)
 				need_bytes = tic->t_unit_res*tic->t_cnt;
@@ -834,21 +832,19 @@ xfs_log_need_covered(xfs_mount_t *mp)
  * We may be holding the log iclog lock upon entering this routine.
  */
 xfs_lsn_t
-xlog_assign_tail_lsn(xfs_mount_t *mp)
+xlog_assign_tail_lsn(
+	struct xfs_mount	*mp)
 {
-	xfs_lsn_t tail_lsn;
-	xlog_t	  *log = mp->m_log;
+	xfs_lsn_t		tail_lsn;
+	struct log		*log = mp->m_log;
 
 	tail_lsn = xfs_trans_ail_tail(mp->m_ail);
-	spin_lock(&log->l_grant_lock);
 	if (!tail_lsn)
 		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
-	log->l_tail_lsn = tail_lsn;
-	spin_unlock(&log->l_grant_lock);
 
+	atomic64_set(&log->l_tail_lsn, tail_lsn);
 	return tail_lsn;
-}	/* xlog_assign_tail_lsn */
-
+}
 
 /*
  * Return the space in the log between the tail and the head.  The head
@@ -1052,8 +1048,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 	log->l_prev_block  = -1;
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
-	log->l_tail_lsn	   = xlog_assign_lsn(1, 0);
-	atomic64_set(&log->l_last_sync_lsn, log->l_tail_lsn);
+	atomic64_set(&log->l_tail_lsn, xlog_assign_lsn(1, 0));
+	atomic64_set(&log->l_last_sync_lsn, atomic64_read(&log->l_tail_lsn));
 	log->l_grant_reserve_lsn = xlog_assign_lsn(1, 0);
 	log->l_grant_write_lsn = xlog_assign_lsn(1, 0);
 	INIT_LIST_HEAD(&log->l_reserveq);
@@ -2555,7 +2551,8 @@ redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error_return;
 
-	free_bytes = xlog_space_left(log->l_logsize, log->l_tail_lsn,
+	free_bytes = xlog_space_left(log->l_logsize,
+					atomic64_read(&log->l_tail_lsn),
 					log->l_grant_reserve_lsn);
 	/*
 	 * If there is not enough space or there is queued waiter and we
@@ -2566,7 +2563,7 @@ redo:
 		if (list_empty(&tic->t_queue))
 			list_add_tail(&tic->t_queue, &log->l_reserveq);
 
-		xlog_grant_push_ail(log, log->l_tail_lsn,
+		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
 				    atomic64_read(&log->l_last_sync_lsn),
 				    need_bytes);
 
@@ -2643,7 +2640,8 @@ redo:
 	if (XLOG_FORCED_SHUTDOWN(log))
 		goto error_return;
 
-	free_bytes = xlog_space_left(log->l_logsize, log->l_tail_lsn,
+	free_bytes = xlog_space_left(log->l_logsize,
+					atomic64_read(&log->l_tail_lsn),
 					log->l_grant_write_lsn);
 	/*
 	 * If there is not enough space or there is queued waiter and we
@@ -2674,7 +2672,7 @@ redo:
 				goto redo;
 		}
 
-		xlog_grant_push_ail(log, log->l_tail_lsn,
+		xlog_grant_push_ail(log, atomic64_read(&log->l_tail_lsn),
 				    atomic64_read(&log->l_last_sync_lsn),
 				    need_bytes);
 
@@ -2838,11 +2836,11 @@ xlog_state_release_iclog(
 
 	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
 		/* update tail before writing to iclog */
-		xlog_assign_tail_lsn(log->l_mp);
+		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);
 		sync++;
 		iclog->ic_state = XLOG_STATE_SYNCING;
-		iclog->ic_header.h_tail_lsn = cpu_to_be64(log->l_tail_lsn);
-		xlog_verify_tail_lsn(log, iclog, log->l_tail_lsn);
+		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
+		xlog_verify_tail_lsn(log, iclog, tail_lsn);
 		/* cycle incremented when incrementing curr_block */
 	}
 	spin_unlock(&log->l_icloglock);
@@ -3442,7 +3440,7 @@ STATIC void
 xlog_verify_grant_tail(
 	struct log	*log)
 {
-	xfs_lsn_t	 tail_lsn = log->l_tail_lsn;
+	xfs_lsn_t	 tail_lsn = atomic64_read(&log->l_tail_lsn);
 	xfs_lsn_t	 write_lsn = log->l_grant_write_lsn;
 
 	/*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 97db8a8..667d8cb 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -506,8 +506,6 @@ typedef struct log {
 						 * log entries" */
 	xlog_in_core_t		*l_iclog;       /* head log queue	*/
 	spinlock_t		l_icloglock;    /* grab to change iclog state */
-	xfs_lsn_t		l_tail_lsn;     /* lsn of 1st LR with unflushed
-						 * buffers */
 	int			l_curr_cycle;   /* Cycle number of log writes */
 	int			l_prev_cycle;   /* Cycle number before last
 						 * block increment */
@@ -522,12 +520,15 @@ typedef struct log {
 	xfs_lsn_t		l_grant_write_lsn;
 
 	/*
-	 * l_last_sync_lsn is an atomic so it can be set and read without
-	 * needing to hold specific locks. To avoid operations contending with
-	 * other hot objects, place it on a separate cacheline.
+	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
+	 * read without needing to hold specific locks. To avoid operations
+	 * contending with other hot objects, place each of them on a separate
+	 * cacheline.
 	 */
 	/* lsn of last LR on disk */
 	atomic64_t		l_last_sync_lsn ____cacheline_aligned_in_smp;
+	/* lsn of 1st LR with unflushed * buffers */
+	atomic64_t		l_tail_lsn ____cacheline_aligned_in_smp;
 
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2ce7b48..c6285fd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -925,7 +925,7 @@ xlog_find_tail(
 	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
 	if (found == 2)
 		log->l_curr_cycle++;
-	log->l_tail_lsn = be64_to_cpu(rhead->h_tail_lsn);
+	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
 	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
 	log->l_grant_reserve_lsn = xlog_assign_lsn(log->l_curr_cycle,
 						BBTOB(log->l_curr_block));
@@ -960,7 +960,7 @@ xlog_find_tail(
 	}
 	after_umount_blk = (i + hblks + (int)
 		BTOBB(be32_to_cpu(rhead->h_len))) % log->l_logBBsize;
-	tail_lsn = log->l_tail_lsn;
+	tail_lsn = atomic64_read(&log->l_tail_lsn);
 	if (*head_blk == after_umount_blk &&
 	    be32_to_cpu(rhead->h_num_logops) == 1) {
 		umount_data_blk = (i + hblks) % log->l_logBBsize;
@@ -975,9 +975,9 @@ xlog_find_tail(
 			 * log records will point recovery to after the
 			 * current unmount record.
 			 */
-			log->l_tail_lsn =
+			atomic64_set(&log->l_tail_lsn,
 				xlog_assign_lsn(log->l_curr_cycle,
-						after_umount_blk);
+						after_umount_blk));
 			atomic64_set(&log->l_last_sync_lsn,
 				xlog_assign_lsn(log->l_curr_cycle,
 						after_umount_blk));
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
