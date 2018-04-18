Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46950 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753141AbeDRCrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:47:09 -0400
Subject: [PATCH 03/11] xfs_repair: validate some of the log space information
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:46:50 -0700
Message-ID: <152401961080.13319.3976228325503296406.stgit@magnolia>
In-Reply-To: <152401958920.13319.10756339531174871801.stgit@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Validate the log space information in a similar manner to the kernel so
that repair will stumble over (and fix) broken log info that prevents
mounting.  Fixes logsunit fuzz-and-fix failures in xfs/350.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/sb.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)


diff --git a/repair/sb.c b/repair/sb.c
index 3dc6538..f2968cd 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -299,6 +299,27 @@ sb_validate_ino_align(struct xfs_sb *sb)
 }
 
 /*
+ * Validate the given log space.  Derived from xfs_log_mount, though we
+ * can't validate the minimum log size until later.
+ * Returns false if the log is garbage.
+ */
+static bool
+verify_sb_loginfo(
+	struct xfs_sb	*sb)
+{
+	if (xfs_sb_version_hascrc(sb) &&
+	    (sb->sb_logblocks == 0 ||
+	     sb->sb_logblocks > XFS_MAX_LOG_BLOCKS ||
+	     (sb->sb_logblocks << sb->sb_blocklog) > XFS_MAX_LOG_BYTES))
+		return false;
+
+	if (sb->sb_logsunit > 1 && sb->sb_logsunit % sb->sb_blocksize)
+		return false;
+
+	return true;
+}
+
+/*
  * verify a superblock -- does not verify root inode #
  *	can only check that geometry info is internally
  *	consistent.  because of growfs, that's no guarantee
@@ -409,7 +430,8 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 	    sb->sb_inodesize != (1 << sb->sb_inodelog)                 ||
 	    sb->sb_logsunit > XLOG_MAX_RECORD_BSIZE                    ||
 	    sb->sb_inopblock != howmany(sb->sb_blocksize, sb->sb_inodesize) ||
-	    (sb->sb_blocklog - sb->sb_inodelog != sb->sb_inopblog))
+	    (sb->sb_blocklog - sb->sb_inodelog != sb->sb_inopblog) ||
+	    !verify_sb_loginfo(sb))
 		return XR_BAD_INO_SIZE_DATA;
 
 	if (xfs_sb_version_hassector(sb))  {

