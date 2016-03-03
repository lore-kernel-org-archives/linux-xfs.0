Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 375CF7CA4
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 06:40:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8F32CAC003
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 04:40:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nICBSMjGRbjI0mbs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2016 04:40:00 -0800 (PST)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/4] xfs: refactor unmount record detection into helper
Date: Thu,  3 Mar 2016 07:39:56 -0500
Message-Id: <1457008798-58734-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1457008798-58734-1-git-send-email-bfoster@redhat.com>
References: <1457008798-58734-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Beulich <JBeulich@suse.com>

Once the mount sequence has identified the head and tail blocks of the
physical log, the record at the head of the log is located and examined
for an unmount record to determine if the log is clean. This currently
occurs after torn write verification of the head region of the log.

This must ultimately be separated from torn write verification and may
need to be called again if the log head is walked back due to a torn
write (to determine whether the new head record is an unmount record).
Separate this logic into a new helper function. This patch does not
change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 153 ++++++++++++++++++++++++++++-------------------
 1 file changed, 93 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6813e28..8a240d1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1198,6 +1198,84 @@ xlog_verify_head(
 }
 
 /*
+ * Check whether the head of the log points to an unmount record. In other
+ * words, determine whether the log is clean. If so, update the in-core state
+ * appropriately.
+ */
+static int
+xlog_check_unmount_rec(
+	struct xlog		*log,
+	xfs_daddr_t		*head_blk,
+	xfs_daddr_t		*tail_blk,
+	struct xlog_rec_header	*rhead,
+	xfs_daddr_t		rhead_blk,
+	struct xfs_buf		*bp,
+	bool			*clean)
+{
+	struct xlog_op_header	*op_head;
+	xfs_daddr_t		umount_data_blk;
+	xfs_daddr_t		after_umount_blk;
+	int			hblks;
+	int			error;
+	char			*offset;
+
+	*clean = false;
+
+	/*
+	 * Look for unmount record. If we find it, then we know there was a
+	 * clean unmount. Since 'i' could be the last block in the physical
+	 * log, we convert to a log block before comparing to the head_blk.
+	 *
+	 * Save the current tail lsn to use to pass to xlog_clear_stale_blocks()
+	 * below. We won't want to clear the unmount record if there is one, so
+	 * we pass the lsn of the unmount record rather than the block after it.
+	 */
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+		int	h_size = be32_to_cpu(rhead->h_size);
+		int	h_version = be32_to_cpu(rhead->h_version);
+
+		if ((h_version & XLOG_VERSION_2) &&
+		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
+			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
+			if (h_size % XLOG_HEADER_CYCLE_SIZE)
+				hblks++;
+		} else {
+			hblks = 1;
+		}
+	} else {
+		hblks = 1;
+	}
+	after_umount_blk = rhead_blk + hblks + BTOBB(be32_to_cpu(rhead->h_len));
+	after_umount_blk = do_mod(after_umount_blk, log->l_logBBsize);
+	if (*head_blk == after_umount_blk &&
+	    be32_to_cpu(rhead->h_num_logops) == 1) {
+		umount_data_blk = rhead_blk + hblks;
+		umount_data_blk = do_mod(umount_data_blk, log->l_logBBsize);
+		error = xlog_bread(log, umount_data_blk, 1, bp, &offset);
+		if (error)
+			return error;
+
+		op_head = (struct xlog_op_header *)offset;
+		if (op_head->oh_flags & XLOG_UNMOUNT_TRANS) {
+			/*
+			 * Set tail and last sync so that newly written log
+			 * records will point recovery to after the current
+			 * unmount record.
+			 */
+			xlog_assign_atomic_lsn(&log->l_tail_lsn,
+					log->l_curr_cycle, after_umount_blk);
+			xlog_assign_atomic_lsn(&log->l_last_sync_lsn,
+					log->l_curr_cycle, after_umount_blk);
+			*tail_blk = after_umount_blk;
+
+			*clean = true;
+		}
+	}
+
+	return 0;
+}
+
+/*
  * Find the sync block number or the tail of the log.
  *
  * This will be the block number of the last record to have its
@@ -1220,16 +1298,13 @@ xlog_find_tail(
 	xfs_daddr_t		*tail_blk)
 {
 	xlog_rec_header_t	*rhead;
-	xlog_op_header_t	*op_head;
 	char			*offset = NULL;
 	xfs_buf_t		*bp;
 	int			error;
-	xfs_daddr_t		umount_data_blk;
-	xfs_daddr_t		after_umount_blk;
 	xfs_daddr_t		rhead_blk;
 	xfs_lsn_t		tail_lsn;
-	int			hblks;
 	bool			wrapped = false;
+	bool			clean = false;
 
 	/*
 	 * Find previous log record
@@ -1300,66 +1375,24 @@ xlog_find_tail(
 					BBTOB(log->l_curr_block));
 	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
 					BBTOB(log->l_curr_block));
+	tail_lsn = atomic64_read(&log->l_tail_lsn);
 
 	/*
-	 * Look for unmount record.  If we find it, then we know there
-	 * was a clean unmount.  Since 'i' could be the last block in
-	 * the physical log, we convert to a log block before comparing
-	 * to the head_blk.
-	 *
-	 * Save the current tail lsn to use to pass to
-	 * xlog_clear_stale_blocks() below.  We won't want to clear the
-	 * unmount record if there is one, so we pass the lsn of the
-	 * unmount record rather than the block after it.
+	 * Look for an unmount record at the head of the log. This sets the log
+	 * state to determine whether recovery is necessary.
 	 */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
-		int	h_size = be32_to_cpu(rhead->h_size);
-		int	h_version = be32_to_cpu(rhead->h_version);
-
-		if ((h_version & XLOG_VERSION_2) &&
-		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
-			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
-			if (h_size % XLOG_HEADER_CYCLE_SIZE)
-				hblks++;
-		} else {
-			hblks = 1;
-		}
-	} else {
-		hblks = 1;
-	}
-	after_umount_blk = rhead_blk + hblks + BTOBB(be32_to_cpu(rhead->h_len));
-	after_umount_blk = do_mod(after_umount_blk, log->l_logBBsize);
-	tail_lsn = atomic64_read(&log->l_tail_lsn);
-	if (*head_blk == after_umount_blk &&
-	    be32_to_cpu(rhead->h_num_logops) == 1) {
-		umount_data_blk = rhead_blk + hblks;
-		umount_data_blk = do_mod(umount_data_blk, log->l_logBBsize);
-		error = xlog_bread(log, umount_data_blk, 1, bp, &offset);
-		if (error)
-			goto done;
-
-		op_head = (xlog_op_header_t *)offset;
-		if (op_head->oh_flags & XLOG_UNMOUNT_TRANS) {
-			/*
-			 * Set tail and last sync so that newly written
-			 * log records will point recovery to after the
-			 * current unmount record.
-			 */
-			xlog_assign_atomic_lsn(&log->l_tail_lsn,
-					log->l_curr_cycle, after_umount_blk);
-			xlog_assign_atomic_lsn(&log->l_last_sync_lsn,
-					log->l_curr_cycle, after_umount_blk);
-			*tail_blk = after_umount_blk;
+	error = xlog_check_unmount_rec(log, head_blk, tail_blk, rhead,
+				       rhead_blk, bp, &clean);
+	if (error)
+		goto done;
 
-			/*
-			 * Note that the unmount was clean. If the unmount
-			 * was not clean, we need to know this to rebuild the
-			 * superblock counters from the perag headers if we
-			 * have a filesystem using non-persistent counters.
-			 */
-			log->l_mp->m_flags |= XFS_MOUNT_WAS_CLEAN;
-		}
-	}
+	/*
+	 * Note that the unmount was clean. If the unmount was not clean, we
+	 * need to know this to rebuild the superblock counters from the perag
+	 * headers if we have a filesystem using non-persistent counters.
+	 */
+	if (clean)
+		log->l_mp->m_flags |= XFS_MOUNT_WAS_CLEAN;
 
 	/*
 	 * Make sure that there are no blocks in front of the head
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
