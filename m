Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A3217F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 17:11:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DDC38AC006
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 15:11:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sR137SrbkYhaByI8 for <xfs@oss.sgi.com>;
	Mon, 26 Aug 2013 15:11:53 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VE4zt-0000hV-RM
	for xfs@oss.sgi.com; Tue, 27 Aug 2013 08:10:53 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VE4zt-0005zY-Q7
	for xfs@oss.sgi.com; Tue, 27 Aug 2013 08:10:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't account buffer cancellation during log recovery
	readahead
Date: Tue, 27 Aug 2013 08:10:53 +1000
Message-Id: <1377555053-23000-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When doing readhaead in log recovery, we check to see if buffers are
cancelled before doing readahead. If we find a cancelled buffer,
however, we always decrement the reference count we have on it, and
that means that readahead is causing a double decrement of the
cancelled buffer reference count.

This results in log recovery *replaying cancelled buffers* as the
actual recovery pass does not find the cancelled buffer entry in the
commit phase of the second pass across a transaction. On debug
kernels, this results in an ASSERT failure like so:

XFS: Assertion failed: !(flags & XFS_BLF_CANCEL), file: fs/xfs/xfs_log_recover.c, line: 1815

xfstests generic/311 reproduces this ASSERT failure with 100%
reproducability.

Fix it by making readahead only peek at the buffer cancelled state
rather than the full accounting that xlog_check_buffer_cancelled()
does.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 61 +++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 64e530e..90b756f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1769,19 +1769,11 @@ xlog_recover_buffer_pass1(
 
 /*
  * Check to see whether the buffer being recovered has a corresponding
- * entry in the buffer cancel record table.  If it does then return 1
- * so that it will be cancelled, otherwise return 0.  If the buffer is
- * actually a buffer cancel item (XFS_BLF_CANCEL is set), then decrement
- * the refcount on the entry in the table and remove it from the table
- * if this is the last reference.
- *
- * We remove the cancel record from the table when we encounter its
- * last occurrence in the log so that if the same buffer is re-used
- * again after its last cancellation we actually replay the changes
- * made at that point.
+ * entry in the buffer cancel record table. If it is, return the cancel
+ * buffer structure to the caller.
  */
-STATIC int
-xlog_check_buffer_cancelled(
+STATIC struct xfs_buf_cancel *
+xlog_peek_buffer_cancelled(
 	struct xlog		*log,
 	xfs_daddr_t		blkno,
 	uint			len,
@@ -1790,22 +1782,16 @@ xlog_check_buffer_cancelled(
 	struct list_head	*bucket;
 	struct xfs_buf_cancel	*bcp;
 
-	if (log->l_buf_cancel_table == NULL) {
-		/*
-		 * There is nothing in the table built in pass one,
-		 * so this buffer must not be cancelled.
-		 */
+	if (!log->l_buf_cancel_table) {
+		/* empty table means no cancelled buffers in the log */
 		ASSERT(!(flags & XFS_BLF_CANCEL));
-		return 0;
+		return NULL;
 	}
 
-	/*
-	 * Search for an entry in the  cancel table that matches our buffer.
-	 */
 	bucket = XLOG_BUF_CANCEL_BUCKET(log, blkno);
 	list_for_each_entry(bcp, bucket, bc_list) {
 		if (bcp->bc_blkno == blkno && bcp->bc_len == len)
-			goto found;
+			return bcp;
 	}
 
 	/*
@@ -1813,9 +1799,32 @@ xlog_check_buffer_cancelled(
 	 * that the buffer is NOT cancelled.
 	 */
 	ASSERT(!(flags & XFS_BLF_CANCEL));
-	return 0;
+	return NULL;
+}
+
+/*
+ * If the buffer is being cancelled then return 1 so that it will be cancelled,
+ * otherwise return 0.  If the buffer is actually a buffer cancel item
+ * (XFS_BLF_CANCEL is set), then decrement the refcount on the entry in the
+ * table and remove it from the table if this is the last reference.
+ *
+ * We remove the cancel record from the table when we encounter its last
+ * occurrence in the log so that if the same buffer is re-used again after its
+ * last cancellation we actually replay the changes made at that point.
+ */
+STATIC int
+xlog_check_buffer_cancelled(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len,
+	ushort			flags)
+{
+	struct xfs_buf_cancel	*bcp;
+
+	bcp = xlog_peek_buffer_cancelled(log, blkno, len, flags);
+	if (!bcp)
+		return 0;
 
-found:
 	/*
 	 * We've go a match, so return 1 so that the recovery of this buffer
 	 * is cancelled.  If this buffer is actually a buffer cancel log
@@ -3127,7 +3136,7 @@ xlog_recover_buffer_ra_pass2(
 	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
 	struct xfs_mount		*mp = log->l_mp;
 
-	if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
+	if (xlog_peek_buffer_cancelled(log, buf_f->blf_blkno,
 			buf_f->blf_len, buf_f->blf_flags)) {
 		return;
 	}
@@ -3156,7 +3165,7 @@ xlog_recover_inode_ra_pass2(
 			return;
 	}
 
-	if (xlog_check_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len, 0))
+	if (xlog_peek_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len, 0))
 		return;
 
 	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
