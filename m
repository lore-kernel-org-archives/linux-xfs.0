Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55523 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752067AbdIQVHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:18 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/47] xfs: don't crash on unexpected holes in dir/attr btrees
Date: Sun, 17 Sep 2017 14:06:35 -0700
Message-Id: <20170917210712.10804-11-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit cd87d867920155911d0d2e6485b769d853547750 upstream.

In quite a few places we call xfs_da_read_buf with a mappedbno that we
don't control, then assume that the function passes back either an error
code or a buffer pointer.  Unfortunately, if mappedbno == -2 and bno
maps to a hole, we get a return code of zero and a NULL buffer, which
means that we crash if we actually try to use that buffer pointer.  This
happens immediately when we set the buffer type for transaction context.

Therefore, check that we have no error code and a non-NULL bp before
trying to use bp.  This patch is a follow-up to an incomplete fix in
96a3aefb8ffde231 ("xfs: don't crash if reading a directory results in an
unexpected hole").

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  | 2 +-
 fs/xfs/libxfs/xfs_da_btree.c   | 2 +-
 fs/xfs/libxfs/xfs_dir2_block.c | 2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2852521fc8ec..c6c15e5717e4 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -351,7 +351,7 @@ xfs_attr3_leaf_read(
 
 	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
 				XFS_ATTR_FORK, &xfs_attr3_leaf_buf_ops);
-	if (!err && tp)
+	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_ATTR_LEAF_BUF);
 	return err;
 }
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 1bdf2888295b..b305dbfd81c4 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -263,7 +263,7 @@ xfs_da3_node_read(
 
 	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
 					which_fork, &xfs_da3_node_buf_ops);
-	if (!err && tp) {
+	if (!err && tp && *bpp) {
 		struct xfs_da_blkinfo	*info = (*bpp)->b_addr;
 		int			type;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index aa17cb788946..43c902f7a68d 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -139,7 +139,7 @@ xfs_dir3_block_read(
 
 	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
 				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
-	if (!err && tp)
+	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
 	return err;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b887fb2a2bcf..f2e342e05365 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -268,7 +268,7 @@ xfs_dir3_leaf_read(
 
 	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_leaf1_buf_ops);
-	if (!err && tp)
+	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAF1_BUF);
 	return err;
 }
@@ -285,7 +285,7 @@ xfs_dir3_leafn_read(
 
 	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_leafn_buf_ops);
-	if (!err && tp)
+	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAFN_BUF);
 	return err;
 }
-- 
2.14.1

