Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48745 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755957AbcI3DIk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:08:40 -0400
Subject: [PATCH 27/63] xfs: add reflink feature flag to geometry
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:08:36 -0700
Message-ID: <147520491621.29434.3212841899872609879.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

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

