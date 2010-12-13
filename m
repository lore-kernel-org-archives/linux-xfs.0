Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4tJtJ160433 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:55:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 286071CBADEA
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:46:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	A2tfMcgsOLBEOHza for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:46:46 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49889433-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:16:45 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS0Iz-00022h-Iz
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:46:33 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS0HV-0004md-EE
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:45:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/12] xfs: convert l_tail_lsn to an atomic variable.
Date: Mon, 13 Dec 2010 15:44:39 +1100
Message-Id: <1292215483-18224-9-git-send-email-david@fromorbit.com>
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

log->l_tail_lsn is currently protected by the log grant lock. The
lock is only needed for serialising readers against writers, so we
don't really need the lock if we make the l_tail_lsn variable an
atomic. Converting the l_tail_lsn variable to an atomic64_t means we
can start to peel back the grant lock from various operations.

Also, provide functions to safely crack an atomic LSN variable into
it's component pieces and to recombined the components into an
atomic variable. Use them where appropriate.

This also removes the need for explicitly holding a spinlock to read
the l_tail_lsn on 32 bit platforms.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |    2 +-
 fs/xfs/xfs_log.c             |   56 ++++++++++++++++++-----------------------
 fs/xfs/xfs_log_priv.h        |   37 +++++++++++++++++++++++----
 fs/xfs/xfs_log_recover.c     |   14 ++++------
 4 files changed, 63 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 82dfcd7..2f62d0f 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -794,7 +794,7 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 				&__entry->grant_write_bytes);
 		__entry->curr_cycle = log->l_curr_cycle;
 		__entry->curr_block = log->l_curr_block;
-		__entry->tail_lsn = log->l_tail_lsn;
+		__entry->tail_lsn = atomic64_read(&log->l_tail_lsn);
 	),
 	TP_printk("dev %d:%d type %s t_ocnt %u t_cnt %u t_curr_res %u "
 		  "t_unit_res %u t_flags %s reserve_headq 0x%p "
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6ed6ee9..57bd143 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -678,15 +678,11 @@ xfs_log_move_tail(xfs_mount_t	*mp,
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
+	/* tail_lsn == 1 implies that we weren't passed a valid value.  */
+	if (tail_lsn != 1)
+		atomic64_set(&log->l_tail_lsn, tail_lsn);
 
+	spin_lock(&log->l_grant_lock);
 	if (!list_empty(&log->l_writeq)) {
 #ifdef DEBUG
 		if (log->l_flags & XLOG_ACTIVE_RECOVERY)
@@ -789,21 +785,19 @@ xfs_log_need_covered(xfs_mount_t *mp)
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
@@ -831,8 +825,8 @@ xlog_space_left(
 	int		head_bytes;
 
 	xlog_crack_grant_head(head, &head_cycle, &head_bytes);
-	tail_bytes = BBTOB(BLOCK_LSN(log->l_tail_lsn));
-	tail_cycle = CYCLE_LSN(log->l_tail_lsn);
+	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
+	tail_bytes = BBTOB(tail_bytes);
 	if ((tail_cycle == head_cycle) && (head_bytes >= tail_bytes)) {
 		free_bytes = log->l_logsize - (head_bytes - tail_bytes);
 	} else if ((tail_cycle + 1) < head_cycle) {
@@ -1009,8 +1003,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 	log->l_prev_block  = -1;
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
-	log->l_tail_lsn	   = xlog_assign_lsn(1, 0);
-	atomic64_set(&log->l_last_sync_lsn, xlog_assign_lsn(1, 0));
+	xlog_assign_atomic_lsn(&log->l_tail_lsn, 1, 0);
+	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
 	xlog_assign_grant_head(&log->l_grant_reserve_head, 1, 0);
 	xlog_assign_grant_head(&log->l_grant_write_head, 1, 0);
@@ -1189,7 +1183,6 @@ xlog_grant_push_ail(
 {
 	xfs_lsn_t	threshold_lsn = 0;
 	xfs_lsn_t	last_sync_lsn;
-	xfs_lsn_t	tail_lsn;
 	int		free_blocks;
 	int		free_bytes;
 	int		threshold_block;
@@ -1198,7 +1191,6 @@ xlog_grant_push_ail(
 
 	ASSERT(BTOBB(need_bytes) < log->l_logBBsize);
 
-	tail_lsn = log->l_tail_lsn;
 	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
 	free_blocks = BTOBBT(free_bytes);
 
@@ -1213,8 +1205,9 @@ xlog_grant_push_ail(
 	if (free_blocks >= free_threshold)
 		return;
 
-	threshold_block = BLOCK_LSN(tail_lsn) + free_threshold;
-	threshold_cycle = CYCLE_LSN(tail_lsn);
+	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
+						&threshold_block);
+	threshold_block += free_threshold;
 	if (threshold_block >= log->l_logBBsize) {
 		threshold_block -= log->l_logBBsize;
 		threshold_cycle += 1;
@@ -2828,11 +2821,11 @@ xlog_state_release_iclog(
 
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
@@ -3435,7 +3428,7 @@ STATIC void
 xlog_verify_grant_tail(
 	struct log	*log)
 {
-	xfs_lsn_t	tail_lsn = log->l_tail_lsn;
+	int		tail_cycle, tail_blocks;
 	int		cycle, space;
 
 	/*
@@ -3445,9 +3438,10 @@ xlog_verify_grant_tail(
 	 * check the byte count.
 	 */
 	xlog_crack_grant_head(&log->l_grant_write_head, &cycle, &space);
-	if (CYCLE_LSN(tail_lsn) != cycle) {
-		ASSERT(cycle - 1 == CYCLE_LSN(tail_lsn));
-		ASSERT(space <= BBTOB(BLOCK_LSN(tail_lsn)));
+	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_blocks);
+	if (tail_cycle != cycle) {
+		ASSERT(cycle - 1 == tail_cycle);
+		ASSERT(space <= BBTOB(tail_blocks));
 	}
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 129068c..100a410 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -54,7 +54,6 @@ struct xfs_mount;
 	BTOBB(XLOG_MAX_ICLOGS << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
 	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
 
-
 static inline xfs_lsn_t xlog_assign_lsn(uint cycle, uint block)
 {
 	return ((xfs_lsn_t)cycle << 32) | block;
@@ -506,8 +505,6 @@ typedef struct log {
 						 * log entries" */
 	xlog_in_core_t		*l_iclog;       /* head log queue	*/
 	spinlock_t		l_icloglock;    /* grab to change iclog state */
-	xfs_lsn_t		l_tail_lsn;     /* lsn of 1st LR with unflushed
-						 * buffers */
 	int			l_curr_cycle;   /* Cycle number of log writes */
 	int			l_prev_cycle;   /* Cycle number before last
 						 * block increment */
@@ -522,12 +519,15 @@ typedef struct log {
 	int64_t			l_grant_write_head;
 
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
@@ -564,6 +564,31 @@ int	xlog_write(struct log *log, struct xfs_log_vec *log_vector,
 				xlog_in_core_t **commit_iclog, uint flags);
 
 /*
+ * When we crack an atomic LSN, we sample it first so that the value will not
+ * change while we are cracking it into the component values. This means we
+ * will always get consistent component values to work from. This should always
+ * be used to smaple and crack LSNs taht are stored and updated in atomic
+ * variables.
+ */
+static inline void
+xlog_crack_atomic_lsn(atomic64_t *lsn, uint *cycle, uint *block)
+{
+	xfs_lsn_t val = atomic64_read(lsn);
+
+	*cycle = CYCLE_LSN(val);
+	*block = BLOCK_LSN(val);
+}
+
+/*
+ * Calculate and assign a value to an atomic LSN variable from component pieces.
+ */
+static inline void
+xlog_assign_atomic_lsn(atomic64_t *lsn, uint cycle, uint block)
+{
+	atomic64_set(lsn, xlog_assign_lsn(cycle, block));
+}
+
+/*
  * When we crack the grrant head, we sample it first so that the value will not
  * change while we are cracking it into the component values. This means we
  * will always get consistent component values to work from.
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7e5b8ab..147fb34 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -925,7 +925,7 @@ xlog_find_tail(
 	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
 	if (found == 2)
 		log->l_curr_cycle++;
-	log->l_tail_lsn = be64_to_cpu(rhead->h_tail_lsn);
+	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
 	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
 	xlog_assign_grant_head(&log->l_grant_reserve_head, log->l_curr_cycle,
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
@@ -975,12 +975,10 @@ xlog_find_tail(
 			 * log records will point recovery to after the
 			 * current unmount record.
 			 */
-			log->l_tail_lsn =
-				xlog_assign_lsn(log->l_curr_cycle,
-						after_umount_blk);
-			atomic64_set(&log->l_last_sync_lsn,
-				xlog_assign_lsn(log->l_curr_cycle,
-						after_umount_blk));
+			xlog_assign_atomic_lsn(&log->l_tail_lsn,
+					log->l_curr_cycle, after_umount_blk);
+			xlog_assign_atomic_lsn(&log->l_last_sync_lsn,
+					log->l_curr_cycle, after_umount_blk);
 			*tail_blk = after_umount_blk;
 
 			/*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
