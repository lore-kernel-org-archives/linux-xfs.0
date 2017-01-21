Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24682 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdAUIAd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:00:33 -0500
Subject: [PATCH 02/55] xfs: fail _dir_open when readahead fails
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:00:28 -0800
Message-ID: <148498562832.15323.6024908061745348285.stgit@birch.djwong.org>
In-Reply-To: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
References: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When we open a directory, we try to readahead block 0 of the directory
on the assumption that we're going to need it soon.  If the bmbt is
corrupt, the directory will never be usable so we might as well prevent
the directory from being opened at all.. This prevents a subsequent read
or modify operation from hitting it and taking the fs offline.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |    6 ++----
 fs/xfs/libxfs/xfs_da_btree.h |    2 +-
 fs/xfs/xfs_file.c            |    4 ++--
 3 files changed, 5 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index f2dc1a9..1bdf288 100644
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
index 98c75cb..4e29cb6 100644
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
index bbb9eb6..4c87e60f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -908,9 +908,9 @@ xfs_dir_open(
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

