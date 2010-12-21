Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7Sgte244994 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:42 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C3621CE33D9
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:30:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	BTjpepplhlLzJR6M for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:30:38 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50839345-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 18:00:37 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfx-0001EG-RN
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:25 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwfm-0006a8-FV
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 29/34] xfs: convert l_last_sync_lsn to an atomic variable
Date: Tue, 21 Dec 2010 18:29:25 +1100
Message-Id: <1292916570-25015-30-git-send-email-david@fromorbit.com>
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

log->l_last_sync_lsn is updated in only one critical spot - log
buffer Io completion - and is protected by the grant lock here. This
requires the grant lock to be taken for every log buffer IO
completion. Converting the l_last_sync_lsn variable to an atomic64_t
means that we do not need to take the grant lock in log buffer IO
completion to update it.

This also removes the need for explicitly holding a spinlock to read
the l_last_sync_lsn on 32 bit platforms.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c         |   55 +++++++++++++++++++++-------------------------
 fs/xfs/xfs_log_priv.h    |    9 ++++++-
 fs/xfs/xfs_log_recover.c |    6 ++--
 3 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1e2020d..70790eb 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -675,12 +675,8 @@ xfs_log_move_tail(xfs_mount_t	*mp,
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
 
@@ -800,11 +796,9 @@ xlog_assign_tail_lsn(xfs_mount_t *mp)
 
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
@@ -1014,9 +1008,9 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_flags	   |= XLOG_ACTIVE_RECOVERY;
 
 	log->l_prev_block  = -1;
-	log->l_tail_lsn	   = xlog_assign_lsn(1, 0);
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
-	log->l_last_sync_lsn = log->l_tail_lsn;
+	log->l_tail_lsn	   = xlog_assign_lsn(1, 0);
+	atomic64_set(&log->l_last_sync_lsn, xlog_assign_lsn(1, 0));
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
 	xlog_assign_grant_head(&log->l_grant_reserve_head, 1, 0);
 	xlog_assign_grant_head(&log->l_grant_write_head, 1, 0);
@@ -1194,6 +1188,7 @@ xlog_grant_push_ail(
 	int		need_bytes)
 {
 	xfs_lsn_t	threshold_lsn = 0;
+	xfs_lsn_t	last_sync_lsn;
 	xfs_lsn_t	tail_lsn;
 	int		free_blocks;
 	int		free_bytes;
@@ -1228,10 +1223,12 @@ xlog_grant_push_ail(
 					threshold_block);
 	/*
 	 * Don't pass in an lsn greater than the lsn of the last
-	 * log record known to be on disk.
+	 * log record known to be on disk. Use a snapshot of the last sync lsn
+	 * so that it doesn't change between the compare and the set.
 	 */
-	if (XFS_LSN_CMP(threshold_lsn, log->l_last_sync_lsn) > 0)
-		threshold_lsn = log->l_last_sync_lsn;
+	last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
+	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
+		threshold_lsn = last_sync_lsn;
 
 	/*
 	 * Get the transaction layer to kick the dirty buffers out to
@@ -2194,7 +2191,7 @@ xlog_state_do_callback(
 				lowest_lsn = xlog_get_lowest_lsn(log);
 				if (lowest_lsn &&
 				    XFS_LSN_CMP(lowest_lsn,
-				    		be64_to_cpu(iclog->ic_header.h_lsn)) < 0) {
+						be64_to_cpu(iclog->ic_header.h_lsn)) < 0) {
 					iclog = iclog->ic_next;
 					continue; /* Leave this iclog for
 						   * another thread */
@@ -2202,23 +2199,21 @@ xlog_state_do_callback(
 
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
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e2bb276..958f356 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -507,7 +507,6 @@ typedef struct log {
 	spinlock_t		l_icloglock;    /* grab to change iclog state */
 	xfs_lsn_t		l_tail_lsn;     /* lsn of 1st LR with unflushed
 						 * buffers */
-	xfs_lsn_t		l_last_sync_lsn;/* lsn of last LR on disk */
 	int			l_curr_cycle;   /* Cycle number of log writes */
 	int			l_prev_cycle;   /* Cycle number before last
 						 * block increment */
@@ -521,6 +520,14 @@ typedef struct log {
 	int64_t			l_grant_reserve_head;
 	int64_t			l_grant_write_head;
 
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
index 1550404..18e1e18 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -937,7 +937,7 @@ xlog_find_tail(
 	if (found == 2)
 		log->l_curr_cycle++;
 	log->l_tail_lsn = be64_to_cpu(rhead->h_tail_lsn);
-	log->l_last_sync_lsn = be64_to_cpu(rhead->h_lsn);
+	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
 	xlog_assign_grant_head(&log->l_grant_reserve_head, log->l_curr_cycle,
 					BBTOB(log->l_curr_block));
 	xlog_assign_grant_head(&log->l_grant_write_head, log->l_curr_cycle,
@@ -989,9 +989,9 @@ xlog_find_tail(
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
