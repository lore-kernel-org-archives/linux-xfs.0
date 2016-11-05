Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18800 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754187AbcKEA0q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:26:46 -0400
Subject: [PATCH 20/39] xfs: scrub directories
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:26:42 -0700
Message-ID: <147830560225.4165.236927505212222540.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Scrub all the entries, hash tree, and freespace data in a
directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_dir2_priv.h |    2 ++
 libxfs/xfs_fs.h        |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 1abd314..5e54571 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -131,5 +131,7 @@ extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
 /* xfs_dir2_readdir.c */
 extern int xfs_readdir(struct xfs_inode *dp, struct dir_context *ctx,
 		       size_t bufsize);
+extern int xfs_readdir_locked(struct xfs_trans *tp, struct xfs_inode *dp,
+		       struct dir_context *ctx, size_t bufsize);
 
 #endif /* __XFS_DIR2_PRIV_H__ */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index fc8efef..5dfa0bb 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -613,7 +613,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTD	12	/* data fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTA	13	/* attr fork block mapping */
 #define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
-#define XFS_SCRUB_TYPE_MAX	14
+#define XFS_SCRUB_TYPE_DIR	15	/* directory */
+#define XFS_SCRUB_TYPE_MAX	15
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */

