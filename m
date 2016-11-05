Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36958 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbcKEAKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:10:51 -0400
Subject: [PATCH 08/10] xfs: move dir_ino_validate declaration per xfsprogs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:10:45 -0700
Message-ID: <147830464573.27129.12392536295365582387.stgit@birch.djwong.org>
In-Reply-To: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
References: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Move the declaration of _dir_ino_validate out of the private
dir2 header file into the public one, since xfsprogs did that
for the benefit of xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.h      |    2 ++
 fs/xfs/libxfs/xfs_dir2_priv.h |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index b55db61..0197590 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -180,6 +180,8 @@ extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
 		struct xfs_dir2_data_unused *dup);
 
+extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
+
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index ef9f6ea..d04547f 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -21,7 +21,6 @@
 struct dir_context;
 
 /* xfs_dir2.c */
-extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
 extern int xfs_dir_cilookup_result(struct xfs_da_args *args,

