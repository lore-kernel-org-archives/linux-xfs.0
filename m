Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT1bOIl082134 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 19:37:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6D9B1C7C9FB
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 17:39:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	hgBDWei3ign9RJRf for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 17:39:04 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	47949950-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 12:09:03 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMshf-0000dS-Kl
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:51 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMshQ-0005cW-6D
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 12:38:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/14] xfs: convert l_last_sync_lsn to an atomic variable
Date: Mon, 29 Nov 2010 12:38:24 +1100
Message-Id: <1290994712-21376-7-git-send-email-david@fromorbit.com>
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

log->l_last_sync_lsn is updated in only one critical spot - log
buffer Io completion - and is protected by the grant lock here. This
requires the grant lock to be taken for every log buffer IO
completion. Converting the l_last_sync_lsn variable to an atomic64_t
means that we do not need to take the grant lock in log buffer IO
completion to update it.

This also removes the need for explicitly holding a spinlock to read
the l_last_sync_lsn on 32 bit platforms.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c         |   57 ++++++++++++++++++++-------------------------
 fs/xfs/xfs_log_priv.h    |    9 ++++++-
 fs/xfs/xfs_log_recover.c |    6 ++--
 3 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a35ef8f..90a605cc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -360,7 +360,7 @@ xfs_log_reserve(
 
 		spin_lock(&log->l_grant_lock);
 		xlog_grant_push_ail(log, log->l_tail_lsn,
-				    log->l_last_sync_lsn,
+				    atomic64_read(&log->l_last_sync_lsn),
 				    internal_ticket->t_unit_res);
 		spin_unlock(&log->l_grant_lock);
 		retval = xlog_regrant_write_log_space(log, internal_ticket);
@@ -378,7 +378,7 @@ xfs_log_reserve(
 
 		spin_lock(&log->l_grant_lock);
 		xlog_grant_push_ail(log, log->l_tail_lsn,
-				    log->l_last_sync_lsn,
+				    atomic64_read(&log->l_last_sync_lsn),
 				    (internal_ticket->t_unit_res *
 				     internal_ticket->t_cnt));
 		spin_unlock(&log->l_grant_lock);
@@ -718,12 +718,8 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
 
-	if (tail_lsn == 0) {
-		/* needed since sync_lsn is 64 bits */
-		spin_lock(&log->l_icloglock);
-		tail_lsn = log->l_last_sync_lsn;
-		spin_unlock(&log->l_icloglock);
-	}
+	if (tail_lsn == 0)
+		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
 
 	spin_lock(&log->l_grant_lock);
 
@@ -845,11 +841,9 @@ xlog_assign_tail_lsn(xfs_mount_t *mp)
 
 	tail_lsn = xfs_trans_ail_tail(mp->m_ail);
 	spin_lock(&log->l_grant_lock);
-	if (tail_lsn != 0) {
-		log->l_tail_lsn = tail_lsn;
-	} else {
-		tail_lsn = log->l_tail_lsn = log->l_last_sync_lsn;
-	}
+	if (!tail_lsn)
+		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
+	log->l_tail_lsn = tail_lsn;
 	spin_unlock(&log->l_grant_lock);
 
 	return tail_lsn;
@@ -1057,10 +1051,9 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_flags	   |= XLOG_ACTIVE_RECOVERY;
 
 	log->l_prev_block  = -1;
-	log->l_tail_lsn	   = xlog_assign_lsn(1, 0);
-	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
-	log->l_last_sync_lsn = log->l_tail_lsn;
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
+	log->l_tail_lsn	   = xlog_assign_lsn(1, 0);
+	atomic64_set(&log->l_last_sync_lsn, log->l_tail_lsn);
 	log->l_grant_reserve_lsn = xlog_assign_lsn(1, 0);
 	log->l_grant_write_lsn = xlog_assign_lsn(1, 0);
 	INIT_LIST_HEAD(&log->l_reserveq);
@@ -2241,7 +2234,7 @@ xlog_state_do_callback(
 				lowest_lsn = xlog_get_lowest_lsn(log);
 				if (lowest_lsn &&
 				    XFS_LSN_CMP(lowest_lsn,
-				    		be64_to_cpu(iclog->ic_header.h_lsn)) < 0) {
+						be64_to_cpu(iclog->ic_header.h_lsn)) < 0) {
 					iclog = iclog->ic_next;
 					continue; /* Leave this iclog for
 						   * another thread */
@@ -2249,23 +2242,21 @@ xlog_state_do_callback(
 
 				iclog->ic_state = XLOG_STATE_CALLBACK;
 
-				spin_unlock(&log->l_icloglock);
 
-				/* l_last_sync_lsn field protected by
-				 * l_grant_lock. Don't worry about iclog's lsn.
-				 * No one else can be here except us.
+				/*
+				 * update the last_sync_lsn before we drop the
+				 * icloglock to ensure we are the only one that
+				 * can update it.
 				 */
-				spin_lock(&log->l_grant_lock);
-				ASSERT(XFS_LSN_CMP(log->l_last_sync_lsn,
-				       be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
-				log->l_last_sync_lsn =
-					be64_to_cpu(iclog->ic_header.h_lsn);
-				spin_unlock(&log->l_grant_lock);
+				ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
+					be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
+				atomic64_set(&log->l_last_sync_lsn,
+					be64_to_cpu(iclog->ic_header.h_lsn));
 
-			} else {
-				spin_unlock(&log->l_icloglock);
+			} else
 				ioerrors++;
-			}
+
+			spin_unlock(&log->l_icloglock);
 
 			/*
 			 * Keep processing entries in the callback list until
@@ -2576,7 +2567,8 @@ redo:
 			list_add_tail(&tic->t_queue, &log->l_reserveq);
 
 		xlog_grant_push_ail(log, log->l_tail_lsn,
-				    log->l_last_sync_lsn, need_bytes);
+				    atomic64_read(&log->l_last_sync_lsn),
+				    need_bytes);
 
 		XFS_STATS_INC(xs_sleep_logspace);
 		trace_xfs_log_grant_sleep(log, tic);
@@ -2683,7 +2675,8 @@ redo:
 		}
 
 		xlog_grant_push_ail(log, log->l_tail_lsn,
-				    log->l_last_sync_lsn, need_bytes);
+				    atomic64_read(&log->l_last_sync_lsn),
+				    need_bytes);
 
 		XFS_STATS_INC(xs_sleep_logspace);
 		trace_xfs_log_regrant_write_sleep(log, tic);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 6fcee10..97db8a8 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -508,7 +508,6 @@ typedef struct log {
 	spinlock_t		l_icloglock;    /* grab to change iclog state */
 	xfs_lsn_t		l_tail_lsn;     /* lsn of 1st LR with unflushed
 						 * buffers */
-	xfs_lsn_t		l_last_sync_lsn;/* lsn of last LR on disk */
 	int			l_curr_cycle;   /* Cycle number of log writes */
 	int			l_prev_cycle;   /* Cycle number before last
 						 * block increment */
@@ -522,6 +521,14 @@ typedef struct log {
 	xfs_lsn_t		l_grant_reserve_lsn;
 	xfs_lsn_t		l_grant_write_lsn;
 
+	/*
+	 * l_last_sync_lsn is an atomic so it can be set and read without
+	 * needing to hold specific locks. To avoid operations contending with
+	 * other hot objects, place it on a separate cacheline.
+	 */
+	/* lsn of last LR on disk */
+	atomic64_t		l_last_sync_lsn ____cacheline_aligned_in_smp;
+
 	/* The following field are used for debugging; need to hold icloglock */
 #ifdef DEBUG
 	char			*l_iclog_bak[XLOG_MAX_ICLOGS];
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d8c62f0..2ce7b48 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -926,7 +926,7 @@ xlog_find_tail(
 	if (found == 2)
 		log->l_curr_cycle++;
 	log->l_tail_lsn = be64_to_cpu(rhead->h_tail_lsn);
-	log->l_last_sync_lsn = be64_to_cpu(rhead->h_lsn);
+	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
 	log->l_grant_reserve_lsn = xlog_assign_lsn(log->l_curr_cycle,
 						BBTOB(log->l_curr_block));
 	log->l_grant_write_lsn = xlog_assign_lsn(log->l_curr_cycle,
@@ -978,9 +978,9 @@ xlog_find_tail(
 			log->l_tail_lsn =
 				xlog_assign_lsn(log->l_curr_cycle,
 						after_umount_blk);
-			log->l_last_sync_lsn =
+			atomic64_set(&log->l_last_sync_lsn,
 				xlog_assign_lsn(log->l_curr_cycle,
-						after_umount_blk);
+						after_umount_blk));
 			*tail_blk = after_umount_blk;
 
 			/*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
