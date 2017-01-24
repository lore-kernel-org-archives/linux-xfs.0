Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44364 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750874AbdAXA4A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2017 19:56:00 -0500
Date: Mon, 23 Jan 2017 16:55:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 3/5] xfs_repair: strengthen geometry checks
Message-ID: <20170124005556.GH31202@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494393485.5256.16822617236354659766.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148494393485.5256.16822617236354659766.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

In xfs_repair, the inodelog, sectlog, and dirblklog values are read
directly into the xfs_mount structure without any sanity checking by the
verifier.  This results in xfs_repair segfaulting when those fields have
ridiculously high values because the pointer arithmetic runs us off the
end of the metadata buffers.  Therefore, reject the superblock if these
values are garbage and try to find one of the other ones.  Clean up the
dblocks checking to use the relevant macros.

The superblock field fuzzer (xfs/1301) triggers all these segfaults.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: make the inode geometry more consistent with the kernel sb verifier,
and prevent an ASSERT if the fs is !dalign but sunit != 0.
v3: add a new failure message for directory geometry inconsistency and
complain if sunit/swidth are set and dalign is not.
---
 repair/globals.h    |    3 ++-
 repair/sb.c         |   27 +++++++++++++++++----------
 repair/xfs_repair.c |    2 ++
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/repair/globals.h b/repair/globals.h
index efd1d03..4085ccc 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -50,7 +50,8 @@
 #define XR_BAD_SB_WIDTH		18	/* bad stripe width */
 #define XR_BAD_SVN		19	/* bad shared version number */
 #define XR_BAD_CRC		20	/* Bad CRC */
-#define XR_BAD_ERR_CODE		21	/* Bad error code */
+#define XR_BAD_DIR_SIZE_DATA	21	/* Bad directory geometry */
+#define XR_BAD_ERR_CODE		22	/* Bad error code */
 
 /* XFS filesystem (il)legal values */
 
diff --git a/repair/sb.c b/repair/sb.c
index 004702c..77e5154 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -395,20 +395,22 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
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
 
-	if (sb->sb_inodesize < XFS_DINODE_MIN_SIZE ||
-		sb->sb_inodesize > XFS_DINODE_MAX_SIZE ||
-		sb->sb_inopblock != howmany(sb->sb_blocksize,sb->sb_inodesize))
-		return(XR_BAD_INO_SIZE_DATA);
+	if (sb->sb_inodesize < XFS_DINODE_MIN_SIZE                     ||
+	    sb->sb_inodesize > XFS_DINODE_MAX_SIZE                     ||
+	    sb->sb_inodelog < XFS_DINODE_MIN_LOG                       ||
+	    sb->sb_inodelog > XFS_DINODE_MAX_LOG                       ||
+	    sb->sb_inodesize != (1 << sb->sb_inodelog)                 ||
+	    sb->sb_logsunit > XLOG_MAX_RECORD_BSIZE                    ||
+	    sb->sb_inopblock != howmany(sb->sb_blocksize, sb->sb_inodesize) ||
+	    (sb->sb_blocklog - sb->sb_inodelog != sb->sb_inopblog))
+		return XR_BAD_INO_SIZE_DATA;
 
 	if (xfs_sb_version_hassector(sb))  {
 
@@ -492,7 +494,12 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		if ((sb->sb_unit && !sb->sb_width) ||
 		    (sb->sb_width && sb->sb_unit && sb->sb_width % sb->sb_unit))
 			return(XR_BAD_SB_WIDTH);
-	}
+	} else if (sb->sb_unit || sb->sb_width)
+		return XR_BAD_SB_WIDTH;
+
+	/* Directory block log */
+	if (sb->sb_blocklog + sb->sb_dirblklog > XFS_MAX_BLOCKSIZE_LOG)
+		return XR_BAD_DIR_SIZE_DATA;
 
 	return(XR_OK);
 }
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 5c79fd9..b07567b 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -143,6 +143,8 @@ err_string(int err_code)
 			_("bad shared version number in superblock");
 		err_message[XR_BAD_CRC] =
 			_("bad CRC in superblock");
+		err_message[XR_BAD_DIR_SIZE_DATA] =
+			_("inconsistent directory geometry information");
 		done = 1;
 	}
 
