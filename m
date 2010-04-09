Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39MTlB5146499 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 17:29:47 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1ADD08F80D4
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 15:31:40 -0700 (PDT)
Subject: [PATCHv2 5/10] xfs: encapsulate bbcount validity checking
From: Alex Elder <aelder@sgi.com>
Date: Fri, 09 Apr 2010 17:28:11 -0500
Message-ID: <1270852091.7840.143.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

Define a function that encapsulates checking the validity of a log
block count.

(Updated from previous version--no longer includes error reporting in the
encapsulated validation function.)

Signed-off-by: Alex Elder <aelder@sgi.com>

---
fs/xfs/xfs_log_recover.c |   44 +++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_log_recover.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -63,15 +63,29 @@ STATIC void	xlog_recover_check_summary(x
 /* Number of basic blocks in a log sector */
 #define xlog_sectbb(log) (1 << (log)->l_sectbb_log)
 
+/*
+ * Verify the given count of basic blocks is valid number of blocks
+ * to specify for an operation involving the given XFS log buffer.
+ * Returns nonzero if the count is valid, 0 otherwise.
+ */
+
+inline static int
+xlog_buf_bbcount_valid(
+	xlog_t		*log,
+	int		bbcount)
+{
+	return bbcount > 0 && bbcount <= log->l_logBBsize;
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
+	if (!xlog_buf_bbcount_valid(log, nbblks)) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+			nbblks);
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
 		return NULL;
 	}
 
@@ -121,10 +135,10 @@ xlog_bread_noalign(
 {
 	int		error;
 
-	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
-		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
-		XFS_ERROR_REPORT("xlog_bread(1)",
-				 XFS_ERRLEVEL_HIGH, log->l_mp);
+	if (!xlog_buf_bbcount_valid(log, nbblks)) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+			nbblks);
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
 		return EFSCORRUPTED;
 	}
 
@@ -183,10 +197,10 @@ xlog_bwrite(
 {
 	int		error;
 
-	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
-		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
-		XFS_ERROR_REPORT("xlog_bwrite(1)",
-				 XFS_ERRLEVEL_HIGH, log->l_mp);
+	if (!xlog_buf_bbcount_valid(log, nbblks)) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+			nbblks);
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
 		return EFSCORRUPTED;
 	}
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
