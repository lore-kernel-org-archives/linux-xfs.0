Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C29F7FB9
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:16:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB9808F8039
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	WyyHxdGmQBylOwBP for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:58 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxa-0006Oz-4N
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxa-0002GD-3i
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/32] libxfs: bring across inode buffer readahead verifier
	changes
Date: Mon, 30 Sep 2013 13:15:27 +1000
Message-Id: <1380510944-8571-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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

These were made for log recovery readahead in the kernel, so are not
directly used in userspace. Hence bringing the change across is
simply to keep files in sync.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_inode_buf.c | 41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index b096f77..67d5eb4 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -46,9 +46,22 @@ xfs_inobp_check(
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
@@ -69,6 +82,11 @@ xfs_inode_buf_verify(
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
@@ -87,14 +105,21 @@ static void
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
@@ -102,6 +127,12 @@ const struct xfs_buf_ops xfs_inode_buf_ops = {
 	.verify_write = xfs_inode_buf_write_verify,
 };
 
+const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
+	.verify_read = xfs_inode_buf_readahead_verify,
+	.verify_write = xfs_inode_buf_write_verify,
+};
+
+
 /*
  * This routine is called to map an inode to the buffer containing the on-disk
  * version of the inode.  It returns a pointer to the buffer containing the
@@ -191,7 +222,7 @@ xfs_dinode_from_disk(
 		to->di_ino = be64_to_cpu(from->di_ino);
 		to->di_lsn = be64_to_cpu(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		platform_uuid_copy(&to->di_uuid, &from->di_uuid);
+		uuid_copy(&to->di_uuid, &from->di_uuid);
 	}
 }
 
@@ -237,7 +268,7 @@ xfs_dinode_to_disk(
 		to->di_ino = cpu_to_be64(from->di_ino);
 		to->di_lsn = cpu_to_be64(from->di_lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		platform_uuid_copy(&to->di_uuid, &from->di_uuid);
+		uuid_copy(&to->di_uuid, &from->di_uuid);
 		to->di_flushiter = 0;
 	} else {
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
