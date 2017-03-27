Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33858 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbdC0IjD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:39:03 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/26] xfs: fail _dir_open when readahead fails
Date: Mon, 27 Mar 2017 10:38:16 +0200
Message-Id: <20170327083837.11027-6-hch@lst.de>
In-Reply-To: <20170327083837.11027-1-hch@lst.de>
References: <20170327083837.11027-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 7a652bbe366464267190c2792a32ce4fff5595ef upstream.

When we open a directory, we try to readahead block 0 of the directory
on the assumption that we're going to need it soon.  If the bmbt is
corrupt, the directory will never be usable and the readahead fails
immediately, so we might as well prevent the directory from being opened
at all.  This prevents a subsequent read or modify operation from
hitting it and taking the fs offline.

NOTE: We're only checking for early failures in the block mapping, not
the readahead directory block itself.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.c | 6 ++----
 fs/xfs/libxfs/xfs_da_btree.h | 2 +-
 fs/xfs/xfs_file.c            | 4 ++--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index f2dc1a950c85..1bdf2888295b 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2633,7 +2633,7 @@ xfs_da_read_buf(
 /*
  * Readahead the dir/attr block.
  */
-xfs_daddr_t
+int
 xfs_da_reada_buf(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
@@ -2664,7 +2664,5 @@ xfs_da_reada_buf(
 	if (mapp != &map)
 		kmem_free(mapp);
 
-	if (error)
-		return -1;
-	return mappedbno;
+	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 98c75cbe6ac2..4e29cb6a3627 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -201,7 +201,7 @@ int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			       xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			       struct xfs_buf **bpp, int whichfork,
 			       const struct xfs_buf_ops *ops);
-xfs_daddr_t	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
+int	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
 				xfs_daddr_t mapped_bno, int whichfork,
 				const struct xfs_buf_ops *ops);
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0a29739f785e..032c8a74824a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -913,9 +913,9 @@ xfs_dir_open(
 	 */
 	mode = xfs_ilock_data_map_shared(ip);
 	if (ip->i_d.di_nextents > 0)
-		xfs_dir3_data_readahead(ip, 0, -1);
+		error = xfs_dir3_data_readahead(ip, 0, -1);
 	xfs_iunlock(ip, mode);
-	return 0;
+	return error;
 }
 
 STATIC int
-- 
2.11.0

