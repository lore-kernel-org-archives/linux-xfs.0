Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 99AF57F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 20:39:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 86AA68F8035
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 18:39:44 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	C2yWW7iHbwB15tHS for <xfs@oss.sgi.com>;
	Mon, 26 Aug 2013 18:39:42 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VE8Ft-00019l-Ip
	for xfs@oss.sgi.com; Tue, 27 Aug 2013 11:39:37 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VE8Ft-0006Ki-Hv
	for xfs@oss.sgi.com; Tue, 27 Aug 2013 11:39:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: inode buffers may not be valid during recovery readahead
Date: Tue, 27 Aug 2013 11:39:37 +1000
Message-Id: <1377567577-24312-1-git-send-email-david@fromorbit.com>
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

CRC enabled filesystems fail log recovery with 100% reliability on
xfstests xfs/085 with the following failure:

XFS (vdb): Mounting Filesystem
XFS (vdb): Starting recovery (logdev: internal)
XFS (vdb): Corruption detected. Unmount and run xfs_repair
XFS (vdb): bad inode magic/vsn daddr 144 #0 (magic=0)
XFS: Assertion failed: 0, file: fs/xfs/xfs_inode_buf.c, line: 95

The problem is that the inode buffer has not been recovered before
the readahead on the inode buffer is issued. The checkpoint being
recovered actually allocates the inode chunk we are doing readahead
from, so what comes from disk during readahead is essentially
random and the verifier barfs on it.

This inode buffer readahead problem affects non-crc filesystems,
too, but xfstests does not trigger it at all on such
configurations....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_buf.c   | 36 +++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_inode_buf.h   |  1 +
 fs/xfs/xfs_log_recover.c |  2 +-
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
index 38fe509..e011d59 100644
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -61,9 +61,22 @@ xfs_inobp_check(
 }
 #endif
 
+/*
+ * If we are doing readahead on an inode buffer, we might be in log recovery
+ * reading an inode allocation buffer that hasn't yet been replayed, and hence
+ * has not had the inode cores stamped into it. Hence for readahead, the buffer
+ * may be potentially invalid.
+ *
+ * If the readahead buffer is invalid, we don't want to mark it with an error,
+ * but we do want to clear the DONE status of the buffer so that a followup read
+ * will re-read it from disk. This will ensure that we don't get an unnecessary
+ * warnings during log recovery and we don't get unnecssary panics on debug
+ * kernels.
+ */
 static void
 xfs_inode_buf_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf	*bp,
+	bool		readahead)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	int		i;
@@ -84,6 +97,11 @@ xfs_inode_buf_verify(
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP,
 						XFS_RANDOM_ITOBP_INOTOBP))) {
+			if (readahead) {
+				bp->b_flags &= ~XBF_DONE;
+				return;
+			}
+
 			xfs_buf_ioerror(bp, EFSCORRUPTED);
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
 					     mp, dip);
@@ -104,14 +122,21 @@ static void
 xfs_inode_buf_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_inode_buf_verify(bp);
+	xfs_inode_buf_verify(bp, false);
+}
+
+static void
+xfs_inode_buf_readahead_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_inode_buf_verify(bp, true);
 }
 
 static void
 xfs_inode_buf_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_inode_buf_verify(bp);
+	xfs_inode_buf_verify(bp, false);
 }
 
 const struct xfs_buf_ops xfs_inode_buf_ops = {
@@ -119,6 +144,11 @@ const struct xfs_buf_ops xfs_inode_buf_ops = {
 	.verify_write = xfs_inode_buf_write_verify,
 };
 
+const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
+	.verify_read = xfs_inode_buf_readahead_verify,
+	.verify_write = xfs_inode_buf_write_verify,
+};
+
 
 /*
  * This routine is called to map an inode to the buffer containing the on-disk
diff --git a/fs/xfs/xfs_inode_buf.h b/fs/xfs/xfs_inode_buf.h
index aae9fc4..599e6c0 100644
--- a/fs/xfs/xfs_inode_buf.h
+++ b/fs/xfs/xfs_inode_buf.h
@@ -48,5 +48,6 @@ void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #endif /* DEBUG */
 
 extern const struct xfs_buf_ops xfs_inode_buf_ops;
+extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 90b756f..ac9c18b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3169,7 +3169,7 @@ xlog_recover_inode_ra_pass2(
 		return;
 
 	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
-				ilfp->ilf_len, &xfs_inode_buf_ops);
+				ilfp->ilf_len, &xfs_inode_buf_ra_ops);
 }
 
 STATIC void
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
