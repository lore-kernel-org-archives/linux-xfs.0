Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932228AbdJZN1q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 09:27:46 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EED4025C4D
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 13:27:45 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D32F36F80A
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2017 13:27:45 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3] xfs: more robust recovery xlog buffer validation
Date: Thu, 26 Oct 2017 09:27:44 -0400
Message-Id: <20171026132744.6282-1-bfoster@redhat.com>
In-Reply-To: <20171025185705.64983-2-bfoster@redhat.com>
References: <20171025185705.64983-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

mkfs has a historical problem where it can format very small
filesystems with too small of a physical log. Under certain
conditions, log recovery of an associated filesystem can end up
passing garbage parameter values to some of the cycle and log record
verification functions due to bugs in log recovery not dealing with
such filesystems properly. This results in attempts to read from
bogus/underflowed log block addresses.

Since the buffer read may ultimately succeed, log recovery can
proceed with bogus data and otherwise go off the rails and crash.
One example of this is a negative last_blk being passed to
xlog_find_verify_log_record() causing us to skip the loop, pass a
NULL head pointer to xlog_header_check_mount() and crash.

Improve the xlog buffer verification to address this problem. We
already verify xlog buffer length, so update this mechanism to also
sanity check for a valid log relative block address and otherwise
return an error. Pass a fixed, valid log block address from
xlog_get_bp() since the target address will be validated when the
buffer is read. This ensures that any bogus log block address/length
calculations lead to graceful mount failure rather than risking a
crash or worse if recovery proceeds with bogus data.

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v3:
- Verify log buf I/O range is within log boundary.

 fs/xfs/xfs_log_recover.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ee34899..1074b5f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -85,17 +85,21 @@ struct xfs_buf_cancel {
  */
 
 /*
- * Verify the given count of basic blocks is valid number of blocks
- * to specify for an operation involving the given XFS log buffer.
- * Returns nonzero if the count is valid, 0 otherwise.
+ * Verify the log-relative block number and length in basic blocks are valid for
+ * an operation involving the given XFS log buffer. Returns true if the fields
+ * are valid, false otherwise.
  */
-
-static inline int
-xlog_buf_bbcount_valid(
+static inline bool
+xlog_verify_bp(
 	struct xlog	*log,
+	xfs_daddr_t	blk_no,
 	int		bbcount)
 {
-	return bbcount > 0 && bbcount <= log->l_logBBsize;
+	if (blk_no < 0 || blk_no >= log->l_logBBsize)
+		return false;
+	if (bbcount <= 0 || (blk_no + bbcount) > log->l_logBBsize)
+		return false;
+	return true;
 }
 
 /*
@@ -110,7 +114,11 @@ xlog_get_bp(
 {
 	struct xfs_buf	*bp;
 
-	if (!xlog_buf_bbcount_valid(log, nbblks)) {
+	/*
+	 * Pass log block 0 since we don't have an addr yet, buffer will be
+	 * verified on read.
+	 */
+	if (!xlog_verify_bp(log, 0, nbblks)) {
 		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
 			nbblks);
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
@@ -180,9 +188,10 @@ xlog_bread_noalign(
 {
 	int		error;
 
-	if (!xlog_buf_bbcount_valid(log, nbblks)) {
-		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
-			nbblks);
+	if (!xlog_verify_bp(log, blk_no, nbblks)) {
+		xfs_warn(log->l_mp,
+			 "Invalid log block/length (0x%llx, 0x%x) for buffer",
+			 blk_no, nbblks);
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
 		return -EFSCORRUPTED;
 	}
@@ -265,9 +274,10 @@ xlog_bwrite(
 {
 	int		error;
 
-	if (!xlog_buf_bbcount_valid(log, nbblks)) {
-		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
-			nbblks);
+	if (!xlog_verify_bp(log, blk_no, nbblks)) {
+		xfs_warn(log->l_mp,
+			 "Invalid log block/length (0x%llx, 0x%x) for buffer",
+			 blk_no, nbblks);
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
 		return -EFSCORRUPTED;
 	}
-- 
2.9.5

