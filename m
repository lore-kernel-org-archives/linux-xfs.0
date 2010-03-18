Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2IMqSco198346 for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:52:28 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0E779304062
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 15:54:07 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o2IMs6VW001882
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:54:06 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o2IMs6g0001880
	for xfs@oss.sgi.com; Thu, 18 Mar 2010 17:54:06 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201003182254.o2IMs6g0001880@stout.americas.sgi.com>
Date: Thu, 18 Mar 2010 17:54:06 -0500
Subject: [PATCH 5/7] xfs: encapsulate bbcount validity checking
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This replaces is a duplicated block of essentially identical code
in three spots with a call to a common helper routine.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_log_recover.c |   44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -63,17 +63,39 @@ STATIC void	xlog_recover_check_summary(x
 /* Number of basic blocks in a log sector */
 #define xlog_sectbb(log) (1 << (log)->l_sectbb_log)
 
+/*
+ * Verify the given count of basic blocks is valid number of blocks
+ * to specify for an operation involving the given XFS log buffer.
+ * If not, report the error.
+ *
+ * Returns 1 if the count is valid, 0 otherwise.
+ */
+
+#define xlog_buf_bbcount_valid(log, bbcount) \
+		_xlog_buf_bbcount_valid(log, bbcount, __func__)
+inline static int
+_xlog_buf_bbcount_valid(
+	xlog_t		*log,
+	int		bbcount,
+	const void	*function)
+{
+	if (bbcount > 0 && bbcount <= log->l_logBBsize)
+	    	return 1;
+
+	xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+		bbcount);
+	XFS_ERROR_REPORT(function, XFS_ERRLEVEL_HIGH, log->l_mp);
+
+	return 0;	/* Basic block count out of log's range */
+}
+
 STATIC xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,
 	int		nbblks)
 {
-	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
-		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
-		XFS_ERROR_REPORT("xlog_get_bp(1)",
-				 XFS_ERRLEVEL_HIGH, log->l_mp);
+	if (!xlog_buf_bbcount_valid(log, nbblks))
 		return NULL;
-	}
 
 	if (log->l_sectbb_log) {
 		if (nbblks > 1)
@@ -121,12 +143,8 @@ xlog_bread_noalign(
 {
 	int		error;
 
-	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
-		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
-		XFS_ERROR_REPORT("xlog_bread(1)",
-				 XFS_ERRLEVEL_HIGH, log->l_mp);
+	if (!xlog_buf_bbcount_valid(log, nbblks))
 		return EFSCORRUPTED;
-	}
 
 	if (log->l_sectbb_log) {
 		blk_no = round_down(blk_no, xlog_sectbb(log));
@@ -183,12 +201,8 @@ xlog_bwrite(
 {
 	int		error;
 
-	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
-		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
-		XFS_ERROR_REPORT("xlog_bwrite(1)",
-				 XFS_ERRLEVEL_HIGH, log->l_mp);
+	if (!xlog_buf_bbcount_valid(log, nbblks))
 		return EFSCORRUPTED;
-	}
 
 	if (log->l_sectbb_log) {
 		blk_no = round_down(blk_no, xlog_sectbb(log));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
