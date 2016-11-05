Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39628 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754146AbcKEA0P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:26:15 -0400
Subject: [PATCH 15/39] xfs: support scrubbing rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:26:11 -0700
Message-ID: <147830557191.4165.714337758098057841.stgit@birch.djwong.org>
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

Plumb in the pieces necessary to check the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h         |    3 ++-
 libxfs/xfs_rmap.c       |    3 ++-
 libxfs/xfs_rmap.h       |    3 +++
 libxfs/xfs_rmap_btree.c |    4 ----
 4 files changed, 7 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 97df1b9..ff3c232 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -607,7 +607,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_CNTBT	6	/* freesp by length btree */
 #define XFS_SCRUB_TYPE_INOBT	7	/* inode btree */
 #define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
-#define XFS_SCRUB_TYPE_MAX	8
+#define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
+#define XFS_SCRUB_TYPE_MAX	9
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 7738f50..97fc4dd 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -177,7 +177,8 @@ xfs_rmap_delete(
 	return error;
 }
 
-static int
+/* Convert an internal btree record to an rmap record. */
+int
 xfs_rmap_btrec_to_irec(
 	union xfs_btree_rec	*rec,
 	struct xfs_rmap_irec	*irec)
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index faf2c1a..3fa4559 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -214,5 +214,8 @@ int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
 		struct xfs_rmap_irec *irec, int	*stat);
+union xfs_btree_rec;
+int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
+		struct xfs_rmap_irec *irec);
 
 #endif	/* __XFS_RMAP_H__ */
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index d11112a..4ceed59 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -375,7 +375,6 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_write		= xfs_rmapbt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_rmapbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -435,7 +434,6 @@ xfs_rmapbt_recs_inorder(
 		return 1;
 	return 0;
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
@@ -454,10 +452,8 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
 	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
-#endif
 };
 
 /*

