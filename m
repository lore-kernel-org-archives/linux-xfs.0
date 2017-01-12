Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39849 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdALDHD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 22:07:03 -0500
Subject: [PATCH 5/5] xfs_repair: strengthen geometry checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Jan 2017 19:06:59 -0800
Message-ID: <148419041963.32674.9938209133184119040.stgit@birch.djwong.org>
In-Reply-To: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

In xfs_repair, the inodelog, sectlog, and dirblklog values are read
directly into the xfs_mount structure without any sanity checking by the
verifier.  This results in xfs_repair segfaulting when those fields have
ridiculously high values because the pointer arithmetic runs us off the
end of the metadata buffers.  Therefore, reject the superblock if these
values are garbage and try to find one of the other ones.

Also clean up the dblocks checking to use the relevant macros and remove
a bogus ASSERT that crashes repair when sunit is set but swidth isn't.

The superblock field fuzzer (xfs/1301) triggers all these segfaults.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/sb.c         |   19 ++++++++++++++-----
 repair/xfs_repair.c |    5 ++++-
 2 files changed, 18 insertions(+), 6 deletions(-)


diff --git a/repair/sb.c b/repair/sb.c
index 004702c..d784420 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -395,21 +395,26 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 	/* sanity check ag count, size fields against data size field */
 
 	if (sb->sb_dblocks == 0 ||
-		sb->sb_dblocks >
-			((__uint64_t)sb->sb_agcount * sb->sb_agblocks) ||
-		sb->sb_dblocks <
-			((__uint64_t)(sb->sb_agcount - 1) * sb->sb_agblocks
-			+ XFS_MIN_AG_BLOCKS))
+		sb->sb_dblocks > XFS_MAX_DBLOCKS(sb) ||
+		sb->sb_dblocks < XFS_MIN_DBLOCKS(sb))
 		return(XR_BAD_FS_SIZE_DATA);
 
 	if (sb->sb_agblklog != (__uint8_t)libxfs_log2_roundup(sb->sb_agblocks))
 		return(XR_BAD_FS_SIZE_DATA);
 
+	if (sb->sb_inodelog < XFS_DINODE_MIN_LOG ||
+		sb->sb_inodelog > XFS_DINODE_MAX_LOG ||
+		sb->sb_inodelog != libxfs_log2_roundup(sb->sb_inodesize))
+		return XR_BAD_INO_SIZE_DATA;
+
 	if (sb->sb_inodesize < XFS_DINODE_MIN_SIZE ||
 		sb->sb_inodesize > XFS_DINODE_MAX_SIZE ||
 		sb->sb_inopblock != howmany(sb->sb_blocksize,sb->sb_inodesize))
 		return(XR_BAD_INO_SIZE_DATA);
 
+	if (sb->sb_blocklog - sb->sb_inodelog != sb->sb_inopblog)
+		return XR_BAD_INO_SIZE_DATA;
+
 	if (xfs_sb_version_hassector(sb))  {
 
 		/* check to make sure log sector is legal 2^N, 9 <= N <= 15 */
@@ -494,6 +499,10 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 			return(XR_BAD_SB_WIDTH);
 	}
 
+	/* Directory block log */
+	if (sb->sb_dirblklog > XFS_MAX_BLOCKSIZE_LOG)
+		return XR_BAD_FS_SIZE_DATA;
+
 	return(XR_OK);
 }
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 5c79fd9..8d4be83 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -621,7 +621,10 @@ is_multidisk_filesystem(
 	if (!sbp->sb_unit)
 		return false;
 
-	ASSERT(sbp->sb_width);
+	/* Stripe unit but no stripe width?  Something's funny here... */
+	if (!sbp->sb_width)
+		return false;
+
 	return true;
 }
 

