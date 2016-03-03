Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3AB4C7CA3
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 06:40:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F0E53304032
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 04:40:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rocw6xeeeB6mmt6i (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2016 04:40:00 -0800 (PST)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/4] xfs: separate log head record discovery from verification
Date: Thu,  3 Mar 2016 07:39:55 -0500
Message-Id: <1457008798-58734-2-git-send-email-bfoster@redhat.com>
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

The code that locates the log record at the head of the log is buried in
the log head verification function. This is fine when torn write
verification occurs unconditionally, but this behavior is problematic
for filesystems that might be moved across systems with different
architectures.

In preparation for separating examination of the log head for unmount
records from torn write detection, lift the record location logic out of
the log verification function and into the caller. This patch does not
change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1dc0e14..6813e28 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1108,27 +1108,10 @@ xlog_verify_head(
 	bool			tmp_wrapped;
 
 	/*
-	 * Search backwards through the log looking for the log record header
-	 * block. This wraps all the way back around to the head so something is
-	 * seriously wrong if we can't find it.
-	 */
-	found = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, bp, rhead_blk,
-				      rhead, wrapped);
-	if (found < 0)
-		return found;
-	if (!found) {
-		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EIO;
-	}
-
-	*tail_blk = BLOCK_LSN(be64_to_cpu((*rhead)->h_tail_lsn));
-
-	/*
-	 * Now that we have a tail block, check the head of the log for torn
-	 * writes. Search again until we hit the tail or the maximum number of
-	 * log record I/Os that could have been in flight at one time. Use a
-	 * temporary buffer so we don't trash the rhead/bp pointer from the
-	 * call above.
+	 * Check the head of the log for torn writes. Search backwards from the
+	 * head until we hit the tail or the maximum number of log record I/Os
+	 * that could have been in flight at one time. Use a temporary buffer so
+	 * we don't trash the rhead/bp pointers from the caller.
 	 */
 	tmp_bp = xlog_get_bp(log, 1);
 	if (!tmp_bp)
@@ -1253,6 +1236,7 @@ xlog_find_tail(
 	 */
 	if ((error = xlog_find_head(log, head_blk)))
 		return error;
+	ASSERT(*head_blk < INT_MAX);
 
 	bp = xlog_get_bp(log, 1);
 	if (!bp)
@@ -1270,12 +1254,26 @@ xlog_find_tail(
 	}
 
 	/*
+	 * Search backwards through the log looking for the log record header
+	 * block. This wraps all the way back around to the head so something is
+	 * seriously wrong if we can't find it.
+	 */
+	error = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, bp,
+				      &rhead_blk, &rhead, &wrapped);
+	if (error < 0)
+		return error;
+	if (!error) {
+		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
+		return -EIO;
+	}
+	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
+
+	/*
 	 * Trim the head block back to skip over torn records. We can have
 	 * multiple log I/Os in flight at any time, so we assume CRC failures
 	 * back through the previous several records are torn writes and skip
 	 * them.
 	 */
-	ASSERT(*head_blk < INT_MAX);
 	error = xlog_verify_head(log, head_blk, tail_blk, bp, &rhead_blk,
 				 &rhead, &wrapped);
 	if (error)
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
