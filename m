Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2IMqXJA198442 for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:52:33 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 145B5304071
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 15:54:12 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o2IMsBuO001889
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:54:11 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o2IMsBck001887
	for xfs@oss.sgi.com; Thu, 18 Mar 2010 17:54:11 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201003182254.o2IMsBck001887@stout.americas.sgi.com>
Date: Thu, 18 Mar 2010 17:54:11 -0500
Subject: [PATCH 6/7] xfs: nothing special about 1-block log sector
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

There are a number of places where a log sector size of 1 uses
special case code.  The round_up() and round_down() macros
produce the correct result even when the log sector size is 1, and
this eliminates the need for treating this as a special case.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_log_recover.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -89,6 +89,11 @@ _xlog_buf_bbcount_valid(
 	return 0;	/* Basic block count out of log's range */
 }
 
+/*
+ * Allocate a buffer to hold log data.  The buffer needs to be able
+ * to map to a range of nbblks basic blocks at any valid (basic
+ * block) offset within the log.
+ */
 STATIC xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,
@@ -97,11 +102,26 @@ xlog_get_bp(
 	if (!xlog_buf_bbcount_valid(log, nbblks))
 		return NULL;
 
-	if (log->l_sectbb_log) {
-		if (nbblks > 1)
-			nbblks += xlog_sectbb(log);
-		nbblks = round_up(nbblks, xlog_sectbb(log));
-	}
+	/*
+	 * We do log I/O in units of log sectors (a power-of-2
+	 * multiple of the basic block size), so we round up the
+	 * requested size to acommodate the basic blocks required
+	 * for complete log sectors.
+	 *
+	 * In addition, the buffer may be used for a non-sector-
+	 * aligned block offset, in which case an I/O of the
+	 * requested size could extend beyond the end of the
+	 * buffer.  If the requested size is only 1 basic block it
+	 * will never straddle a sector boundary, so this won't be
+	 * an issue.  Nor will this be a problem if the log I/O is
+	 * done in basic blocks (sector size 1).  But otherwise we
+	 * extend the buffer by one extra log sector to ensure
+	 * there's space to accomodate this possiblility.
+	 */
+	if (nbblks > 1 && log->l_sectbb_log)
+		nbblks += xlog_sectbb(log);
+	nbblks = round_up(nbblks, xlog_sectbb(log));
+
 	return xfs_buf_get_noaddr(BBTOB(nbblks), log->l_mp->m_logdev_targp);
 }
 
@@ -146,10 +166,8 @@ xlog_bread_noalign(
 	if (!xlog_buf_bbcount_valid(log, nbblks))
 		return EFSCORRUPTED;
 
-	if (log->l_sectbb_log) {
-		blk_no = round_down(blk_no, xlog_sectbb(log));
-		nbblks = round_up(nbblks, xlog_sectbb(log));
-	}
+	blk_no = round_down(blk_no, xlog_sectbb(log));
+	nbblks = round_up(nbblks, xlog_sectbb(log));
 
 	ASSERT(nbblks > 0);
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
@@ -204,10 +222,8 @@ xlog_bwrite(
 	if (!xlog_buf_bbcount_valid(log, nbblks))
 		return EFSCORRUPTED;
 
-	if (log->l_sectbb_log) {
-		blk_no = round_down(blk_no, xlog_sectbb(log));
-		nbblks = round_up(nbblks, xlog_sectbb(log));
-	}
+	blk_no = round_down(blk_no, xlog_sectbb(log));
+	nbblks = round_up(nbblks, xlog_sectbb(log));
 
 	ASSERT(nbblks > 0);
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
