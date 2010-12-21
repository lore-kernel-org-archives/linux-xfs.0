Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7Sgwv244997 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:43 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20A3A21203C
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:30:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	4Sk7cbEWUm8f9y95 for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:30:39 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50434469-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 18:00:38 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfx-0001EF-Pl
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:25 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwfm-0006a0-Da
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 28/34] xfs: make AIL tail pushing independent of the grant lock
Date: Tue, 21 Dec 2010 18:29:24 +1100
Message-Id: <1292916570-25015-29-git-send-email-david@fromorbit.com>
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

The xlog_grant_push_ail() currently takes the grant lock internally to sample
the tail lsn, last sync lsn and the reserve grant head. Most of the callers
already hold the grant lock but have to drop it before calling
xlog_grant_push_ail(). This is a left over from when the AIL tail pushing was
done in line and hence xlog_grant_push_ail had to drop the grant lock. AIL push
is now done in another thread and hence we can safely hold the grant lock over
the entire xlog_grant_push_ail call.

Push the grant lock outside of xlog_grant_push_ail() to simplify the locking
and synchronisation needed for tail pushing.  This will reduce traffic on the
grant lock by itself, but this is only one step in preparing for the complete
removal of the grant lock.

While there, clean up the formatting of xlog_grant_push_ail() to match the
rest of the XFS code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c |  111 ++++++++++++++++++++++++++---------------------------
 1 files changed, 54 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index cc0504e..1e2020d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -70,7 +70,7 @@ STATIC void xlog_state_want_sync(xlog_t	*log, xlog_in_core_t *iclog);
 /* local functions to manipulate grant head */
 STATIC int  xlog_grant_log_space(xlog_t		*log,
 				 xlog_ticket_t	*xtic);
-STATIC void xlog_grant_push_ail(xfs_mount_t	*mp,
+STATIC void xlog_grant_push_ail(struct log	*log,
 				int		need_bytes);
 STATIC void xlog_regrant_reserve_log_space(xlog_t	 *log,
 					   xlog_ticket_t *ticket);
@@ -318,7 +318,9 @@ xfs_log_reserve(
 
 		trace_xfs_log_reserve(log, internal_ticket);
 
-		xlog_grant_push_ail(mp, internal_ticket->t_unit_res);
+		spin_lock(&log->l_grant_lock);
+		xlog_grant_push_ail(log, internal_ticket->t_unit_res);
+		spin_unlock(&log->l_grant_lock);
 		retval = xlog_regrant_write_log_space(log, internal_ticket);
 	} else {
 		/* may sleep if need to allocate more tickets */
@@ -332,9 +334,11 @@ xfs_log_reserve(
 
 		trace_xfs_log_reserve(log, internal_ticket);
 
-		xlog_grant_push_ail(mp,
+		spin_lock(&log->l_grant_lock);
+		xlog_grant_push_ail(log,
 				    (internal_ticket->t_unit_res *
 				     internal_ticket->t_cnt));
+		spin_unlock(&log->l_grant_lock);
 		retval = xlog_grant_log_space(log, internal_ticket);
 	}
 
@@ -1185,59 +1189,58 @@ xlog_commit_record(
  * water mark.  In this manner, we would be creating a low water mark.
  */
 STATIC void
-xlog_grant_push_ail(xfs_mount_t	*mp,
-		    int		need_bytes)
+xlog_grant_push_ail(
+	struct log	*log,
+	int		need_bytes)
 {
-    xlog_t	*log = mp->m_log;	/* pointer to the log */
-    xfs_lsn_t	tail_lsn;		/* lsn of the log tail */
-    xfs_lsn_t	threshold_lsn = 0;	/* lsn we'd like to be at */
-    int		free_blocks;		/* free blocks left to write to */
-    int		free_bytes;		/* free bytes left to write to */
-    int		threshold_block;	/* block in lsn we'd like to be at */
-    int		threshold_cycle;	/* lsn cycle we'd like to be at */
-    int		free_threshold;
-
-    ASSERT(BTOBB(need_bytes) < log->l_logBBsize);
-
-    spin_lock(&log->l_grant_lock);
-    free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
-    tail_lsn = log->l_tail_lsn;
-    free_blocks = BTOBBT(free_bytes);
-
-    /*
-     * Set the threshold for the minimum number of free blocks in the
-     * log to the maximum of what the caller needs, one quarter of the
-     * log, and 256 blocks.
-     */
-    free_threshold = BTOBB(need_bytes);
-    free_threshold = MAX(free_threshold, (log->l_logBBsize >> 2));
-    free_threshold = MAX(free_threshold, 256);
-    if (free_blocks < free_threshold) {
+	xfs_lsn_t	threshold_lsn = 0;
+	xfs_lsn_t	tail_lsn;
+	int		free_blocks;
+	int		free_bytes;
+	int		threshold_block;
+	int		threshold_cycle;
+	int		free_threshold;
+
+	ASSERT(BTOBB(need_bytes) < log->l_logBBsize);
+
+	tail_lsn = log->l_tail_lsn;
+	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
+	free_blocks = BTOBBT(free_bytes);
+
+	/*
+	 * Set the threshold for the minimum number of free blocks in the
+	 * log to the maximum of what the caller needs, one quarter of the
+	 * log, and 256 blocks.
+	 */
+	free_threshold = BTOBB(need_bytes);
+	free_threshold = MAX(free_threshold, (log->l_logBBsize >> 2));
+	free_threshold = MAX(free_threshold, 256);
+	if (free_blocks >= free_threshold)
+		return;
+
 	threshold_block = BLOCK_LSN(tail_lsn) + free_threshold;
 	threshold_cycle = CYCLE_LSN(tail_lsn);
 	if (threshold_block >= log->l_logBBsize) {
-	    threshold_block -= log->l_logBBsize;
-	    threshold_cycle += 1;
+		threshold_block -= log->l_logBBsize;
+		threshold_cycle += 1;
 	}
-	threshold_lsn = xlog_assign_lsn(threshold_cycle, threshold_block);
-
-	/* Don't pass in an lsn greater than the lsn of the last
+	threshold_lsn = xlog_assign_lsn(threshold_cycle,
+					threshold_block);
+	/*
+	 * Don't pass in an lsn greater than the lsn of the last
 	 * log record known to be on disk.
 	 */
 	if (XFS_LSN_CMP(threshold_lsn, log->l_last_sync_lsn) > 0)
-	    threshold_lsn = log->l_last_sync_lsn;
-    }
-    spin_unlock(&log->l_grant_lock);
-
-    /*
-     * Get the transaction layer to kick the dirty buffers out to
-     * disk asynchronously. No point in trying to do this if
-     * the filesystem is shutting down.
-     */
-    if (threshold_lsn &&
-	!XLOG_FORCED_SHUTDOWN(log))
-	    xfs_trans_ail_push(log->l_ailp, threshold_lsn);
-}	/* xlog_grant_push_ail */
+		threshold_lsn = log->l_last_sync_lsn;
+
+	/*
+	 * Get the transaction layer to kick the dirty buffers out to
+	 * disk asynchronously. No point in trying to do this if
+	 * the filesystem is shutting down.
+	 */
+	if (!XLOG_FORCED_SHUTDOWN(log))
+		xfs_trans_ail_push(log->l_ailp, threshold_lsn);
+}
 
 /*
  * The bdstrat callback function for log bufs. This gives us a central
@@ -2543,9 +2546,7 @@ redo:
 
 		trace_xfs_log_grant_sleep2(log, tic);
 
-		spin_unlock(&log->l_grant_lock);
-		xlog_grant_push_ail(log->l_mp, need_bytes);
-		spin_lock(&log->l_grant_lock);
+		xlog_grant_push_ail(log, need_bytes);
 
 		XFS_STATS_INC(xs_sleep_logspace);
 		xlog_wait(&tic->t_wait, &log->l_grant_lock);
@@ -2641,9 +2642,7 @@ xlog_regrant_write_log_space(xlog_t	   *log,
 
 			trace_xfs_log_regrant_write_sleep1(log, tic);
 
-			spin_unlock(&log->l_grant_lock);
-			xlog_grant_push_ail(log->l_mp, need_bytes);
-			spin_lock(&log->l_grant_lock);
+			xlog_grant_push_ail(log, need_bytes);
 
 			XFS_STATS_INC(xs_sleep_logspace);
 			xlog_wait(&tic->t_wait, &log->l_grant_lock);
@@ -2666,9 +2665,7 @@ redo:
 	if (free_bytes < need_bytes) {
 		if (list_empty(&tic->t_queue))
 			list_add_tail(&tic->t_queue, &log->l_writeq);
-		spin_unlock(&log->l_grant_lock);
-		xlog_grant_push_ail(log->l_mp, need_bytes);
-		spin_lock(&log->l_grant_lock);
+		xlog_grant_push_ail(log, need_bytes);
 
 		XFS_STATS_INC(xs_sleep_logspace);
 		trace_xfs_log_regrant_write_sleep2(log, tic);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
