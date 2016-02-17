Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CCD5B7F53
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E30DAC001
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:24 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HNGQEA8lQIJsFOUm for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:22 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004ly-PI
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00014I-OS
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/15] xfs: RT bitmap and summary buffers need verifiers
Date: Wed, 17 Feb 2016 18:20:44 +1100
Message-Id: <1455693652-3899-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1455693652-3899-1-git-send-email-david@fromorbit.com>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
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

Source kernel commit bf85e0998ae8bafc1e0863d914df3be2b1bc372a

Buffers without verifiers issue runtime warnings on XFS. We don't
have anything we can actually verify in the RT buffers (no CRCs, not
magic numbers, etc), but we still need verifiers to avoid the
warnings.

Add a set of dummy verifier operations for the realtime buffers and
apply them in the appropriate places.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_rtbitmap.c | 27 ++++++++++++++++++++++++++-
 libxfs/xfs_shared.h   |  1 +
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 3e61eb2..684a18b 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -37,6 +37,31 @@
  */
 
 /*
+ * Real time buffers need verifiers to avoid runtime warnings during IO.
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
@@ -63,7 +88,7 @@ xfs_rtbuf_get(
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
-				   mp->m_bsize, 0, &bp, NULL);
+				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 15c3ceb..81ac870 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -53,6 +53,7 @@ extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+extern const struct xfs_buf_ops xfs_rtbuf_ops;
 
 /*
  * Transaction types.  Used to distinguish types of buffers. These never reach
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
