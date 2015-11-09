Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7A937F5F
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 14:21:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA2D5304043
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 12:21:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AtxGpm2DWQaRFMhh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2015 12:21:18 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 1D9FCC0032F3
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 20:21:18 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-67.bos.redhat.com [10.18.41.67])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tA9KLHZx017094
	for <xfs@oss.sgi.com>; Mon, 9 Nov 2015 15:21:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 6/8] xfs: refactor log record start detection into a new helper
Date: Mon,  9 Nov 2015 15:21:13 -0500
Message-Id: <1447100475-33465-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1447100475-33465-1-git-send-email-bfoster@redhat.com>
References: <1447100475-33465-1-git-send-email-bfoster@redhat.com>
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

As part of the head/tail discovery process, log recovery locates the
head block and then reverse seeks to find the start of the last active
record in the log. This is non-trivial as the record itself could have
wrapped around the end of the physical log. Log recovery torn write
detection potentially needs to walk further behind the last record in
the log, as multiple log I/Os can be in-flight at one time during a
crash event.

Therefore, refactor the reverse log record header search mechanism into
a new helper that supports the ability to seek past an arbitrary number
of log records (or until the tail is hit). Update the head/tail search
mechanism to call the new helper, but otherwise there is no change in
log recovery behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 118 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 83 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ae514df..1b3f8fe 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -868,6 +868,79 @@ validate_head:
 }
 
 /*
+ * Seek backwards in the log for log record headers.
+ *
+ * Given a starting log block, walk backwards until we find the provided number
+ * of records or hit the provided tail block. The return value is the number of
+ * records encountered or a negative error code. The log block and buffer
+ * pointer of the last record seen are returned in rblk and rhead respectively.
+ */
+STATIC int
+xlog_rseek_logrec_hdr(
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	xfs_daddr_t		tail_blk,
+	int			count,
+	struct xfs_buf		*bp,
+	xfs_daddr_t		*rblk,
+	struct xlog_rec_header	**rhead,
+	bool			*wrapped)
+{
+	int			i;
+	int			error;
+	int			found = 0;
+	char			*offset = NULL;
+	xfs_daddr_t		end_blk;
+
+	*wrapped = false;
+
+	/*
+	 * Walk backwards from the head block until we hit the tail or the first
+	 * block in the log.
+	 */
+	end_blk = head_blk > tail_blk ? tail_blk : 0;
+	for (i = (int) head_blk - 1; i >= end_blk; i--) {
+		error = xlog_bread(log, i, 1, bp, &offset);
+		if (error)
+			goto out_error;
+
+		if (*(__be32 *) offset == cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
+			*rblk = i;
+			*rhead = (struct xlog_rec_header *) offset;
+			if (++found == count)
+				break;
+		}
+	}
+
+	/*
+	 * If we haven't hit the tail block or the log record header count,
+	 * start looking again from the end of the physical log. Note that
+	 * callers can pass head == tail if the tail is not yet known.
+	 */
+	if (tail_blk >= head_blk && found != count) {
+		for (i = log->l_logBBsize - 1; i >= (int) tail_blk; i--) {
+			error = xlog_bread(log, i, 1, bp, &offset);
+			if (error)
+				goto out_error;
+
+			if (*(__be32 *)offset ==
+			    cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
+				*wrapped = true;
+				*rblk = i;
+				*rhead = (struct xlog_rec_header *) offset;
+				if (++found == count)
+					break;
+			}
+		}
+	}
+
+	return found;
+
+out_error:
+	return error;
+}
+
+/*
  * Find the sync block number or the tail of the log.
  *
  * This will be the block number of the last record to have its
@@ -898,8 +971,7 @@ xlog_find_tail(
 	xfs_daddr_t		after_umount_blk;
 	xfs_lsn_t		tail_lsn;
 	int			hblks;
-
-	found = 0;
+	bool			wrapped = false;
 
 	/*
 	 * Find previous log record
@@ -923,37 +995,16 @@ xlog_find_tail(
 	}
 
 	/*
-	 * Search backwards looking for log record header block
+	 * Search backwards through the log looking for the log record header
+	 * block. This wraps all the way back around to the head so something is
+	 * seriously wrong if we can't find it.
 	 */
 	ASSERT(*head_blk < INT_MAX);
-	for (i = (int)(*head_blk) - 1; i >= 0; i--) {
-		error = xlog_bread(log, i, 1, bp, &offset);
-		if (error)
-			goto done;
-
-		if (*(__be32 *)offset == cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
-			found = 1;
-			break;
-		}
-	}
-	/*
-	 * If we haven't found the log record header block, start looking
-	 * again from the end of the physical log.  XXXmiken: There should be
-	 * a check here to make sure we didn't search more than N blocks in
-	 * the previous code.
-	 */
-	if (!found) {
-		for (i = log->l_logBBsize - 1; i >= (int)(*head_blk); i--) {
-			error = xlog_bread(log, i, 1, bp, &offset);
-			if (error)
-				goto done;
-
-			if (*(__be32 *)offset ==
-			    cpu_to_be32(XLOG_HEADER_MAGIC_NUM)) {
-				found = 2;
-				break;
-			}
-		}
+	found = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, bp, &i,
+				      &rhead, &wrapped);
+	if (found < 0) {
+		error = found;
+		goto done;
 	}
 	if (!found) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
@@ -961,9 +1012,6 @@ xlog_find_tail(
 		ASSERT(0);
 		return -EIO;
 	}
-
-	/* find blk_no of tail of log */
-	rhead = (xlog_rec_header_t *)offset;
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
 	/*
@@ -979,7 +1027,7 @@ xlog_find_tail(
 	log->l_prev_block = i;
 	log->l_curr_block = (int)*head_blk;
 	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
-	if (found == 2)
+	if (wrapped)
 		log->l_curr_cycle++;
 	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
 	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
