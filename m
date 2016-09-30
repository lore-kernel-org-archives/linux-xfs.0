Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49711 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964826AbcI3DMR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:12:17 -0400
Subject: [PATCH 60/63] xfs: recognize the reflink feature bit
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:12:10 -0700
Message-ID: <147520512997.29434.12091596971723209819.stgit@birch.djwong.org>
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

Add the reflink feature flag to the set of recognized feature flags.
This enables users to write to reflink filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 fs/xfs/xfs_super.c         |    7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 94f610a..7a40855 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -459,7 +459,8 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2152ab6..0e95485 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1604,6 +1604,9 @@ xfs_fs_fill_super(
 			"DAX unsupported by block device. Turning off DAX.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
 		}
+		if (xfs_sb_version_hasreflink(&mp->m_sb))
+			xfs_alert(mp,
+		"DAX and reflink have not been tested together!");
 	}
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
@@ -1617,6 +1620,10 @@ xfs_fs_fill_super(
 	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
 	}
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		xfs_alert(mp,
+	"EXPERIMENTAL reflink feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;

