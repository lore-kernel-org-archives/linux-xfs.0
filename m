Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17114 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756745AbcI1C42 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:56:28 -0400
Subject: [PATCH 26/63] xfs: add reflink feature flag to geometry
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:56:24 -0700
Message-ID: <147503138451.30303.14286196572651173300.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Report the reflink feature in the XFS geometry so that xfs_info and
friends know the filesystem has this feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    3 ++-
 fs/xfs/xfs_fsops.c     |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 7945505..6f4f2c3 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -206,7 +206,8 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
 #define XFS_FSOP_GEOM_FLAGS_FINOBT	0x20000	/* free inode btree */
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
-#define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* Reverse mapping btree */
+#define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* reverse mapping btree */
+#define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* files can share blocks */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 4b4059b..3acbf4e0 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -108,7 +108,9 @@ xfs_fs_geometry(
 			(xfs_sb_version_hassparseinodes(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_SPINODES : 0) |
 			(xfs_sb_version_hasrmapbt(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0);
+				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0) |
+			(xfs_sb_version_hasreflink(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_REFLINK : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;

