Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A3847CB9
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 18:39:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 61684304048
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 16:39:38 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	miXTk9kMwt4fdV9D for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2016 16:39:33 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aQOzw-0007pr-KA
	for xfs@oss.sgi.com; Tue, 02 Feb 2016 11:39:12 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aQOzw-0000pl-JB
	for xfs@oss.sgi.com; Tue, 02 Feb 2016 11:39:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: RT bitmap and summary buffers need verifiers
Date: Tue,  2 Feb 2016 11:39:10 +1100
Message-Id: <1454373550-3102-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1454373550-3102-1-git-send-email-david@fromorbit.com>
References: <1454373550-3102-1-git-send-email-david@fromorbit.com>
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

Buffers without verifiers issue runtime warnings on XFS. We don't
have anything we can actually verify in the RT buffers (no CRCs, not
magic numbers, etc), but we still need verifiers to avoid the
warnings.

Add a set of dummy verifier operations for the realtime buffers and
apply them in the appropriate places.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 27 ++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_shared.h   |  1 +
 fs/xfs/xfs_log_recover.c     |  4 ++--
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index bfa7b85..01c0cdb 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -42,6 +42,31 @@
  */
 
 /*
+ * Real time buffers need verifiers to avoid runtime warnigns during IO.
+ * We don't have anything to verify, however, so these are just dummy
+ * operations.
+ */
+static void
+xfs_rtbuf_verify_read(
+	struct xfs_buf	*bp)
+{
+	return;
+}
+
+static void
+xfs_rtbuf_verify_write(
+	struct xfs_buf	*bp)
+{
+	return;
+}
+
+const struct xfs_buf_ops xfs_rtbuf_ops = {
+	.name = "rtbuf",
+	.verify_read = xfs_rtbuf_verify_read,
+	.verify_write = xfs_rtbuf_verify_write,
+};
+
+/*
  * Get a buffer for the bitmap or summary file block specified.
  * The buffer is returned read and locked.
  */
@@ -68,7 +93,7 @@ xfs_rtbuf_get(
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
-				   mp->m_bsize, 0, &bp, NULL);
+				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 15c3ceb..81ac870 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -53,6 +53,7 @@ extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+extern const struct xfs_buf_ops xfs_rtbuf_ops;
 
 /*
  * Transaction types.  Used to distinguish types of buffers. These never reach
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e2d7533..9d09a0d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2475,8 +2475,8 @@ xlog_recover_validate_buf_type(
 		break;
 	case XFS_BLFT_RTBITMAP_BUF:
 	case XFS_BLFT_RTSUMMARY_BUF:
-		/* no verification of RT buffers is done */
-		bp->b_ops = NULL;
+		/* no magic numbers for verification of RT buffers */
+		bp->b_ops = &xfs_rtbuf_ops;
 		break;
 	default:
 		xfs_warn(mp, "Unknown buffer type %d!",
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
