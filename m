Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56460 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752995AbdIRJQX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 05:16:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 40/78] xfs: dont crash on unexpected holes in dir/attr btrees
Date: Mon, 18 Sep 2017 11:11:49 +0200
Message-Id: <20170918091132.407510627@linuxfoundation.org>
In-Reply-To: <20170918091126.077483037@linuxfoundation.org>
References: <20170918091126.077483037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |    2 +-
 fs/xfs/libxfs/xfs_da_btree.c   |    2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |    2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

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
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -263,7 +263,7 @@ xfs_da3_node_read(
 
 	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
 					which_fork, &xfs_da3_node_buf_ops);
-	if (!err && tp) {
+	if (!err && tp && *bpp) {
 		struct xfs_da_blkinfo	*info = (*bpp)->b_addr;
 		int			type;
 
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


