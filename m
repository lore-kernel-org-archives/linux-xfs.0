Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55094 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753684AbeEWDPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 23:15:51 -0400
Date: Tue, 22 May 2018 20:15:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 03/11] xfs_repair: validate some of the log space
 information
Message-ID: <20180523031536.GH14384@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401961080.13319.3976228325503296406.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152401961080.13319.3976228325503296406.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Validate the log space information in a similar manner to the kernel so
that repair will stumble over (and fix) broken log info that prevents
mounting.  Fixes logsunit fuzz-and-fix failures in xfs/350.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/globals.h    |    3 ++-
 repair/sb.c         |   27 +++++++++++++++++++++++++++
 repair/xfs_repair.c |    2 ++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/repair/globals.h b/repair/globals.h
index e777ba27..164619b0 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -51,7 +51,8 @@
 #define XR_BAD_SVN		19	/* bad shared version number */
 #define XR_BAD_CRC		20	/* Bad CRC */
 #define XR_BAD_DIR_SIZE_DATA	21	/* Bad directory geometry */
-#define XR_BAD_ERR_CODE		22	/* Bad error code */
+#define XR_BAD_LOG_GEOMETRY	22	/* Bad log geometry */
+#define XR_BAD_ERR_CODE		23	/* Bad error code */
 
 /* XFS filesystem (il)legal values */
 
diff --git a/repair/sb.c b/repair/sb.c
index 3dc6538b..ef44e39c 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -298,6 +298,30 @@ sb_validate_ino_align(struct xfs_sb *sb)
 	return false;
 }
 
+/*
+ * Validate the given log space.  Derived from xfs_log_mount, though we
+ * can't validate the minimum log size until later.  We only do this
+ * validation on V5 filesystems because the kernel doesn't reject malformed
+ * log geometry on older revision filesystems.
+ *
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
 /*
  * verify a superblock -- does not verify root inode #
  *	can only check that geometry info is internally
@@ -412,6 +436,9 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 	    (sb->sb_blocklog - sb->sb_inodelog != sb->sb_inopblog))
 		return XR_BAD_INO_SIZE_DATA;
 
+	if (!verify_sb_loginfo(sb))
+		return XR_BAD_LOG_GEOMETRY;
+
 	if (xfs_sb_version_hassector(sb))  {
 
 		/* check to make sure log sector is legal 2^N, 9 <= N <= 15 */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ff6a7384..b7c2d267 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -155,6 +155,8 @@ err_string(int err_code)
 			_("bad CRC in superblock");
 		err_message[XR_BAD_DIR_SIZE_DATA] =
 			_("inconsistent directory geometry information");
+		err_message[XR_BAD_LOG_GEOMETRY] =
+			_("inconsistent log geometry information");
 		done = 1;
 	}
 
