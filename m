Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39690 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754146AbcKEA0d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:26:33 -0400
Subject: [PATCH 18/39] xfs: scrub inode block mappings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:26:30 -0700
Message-ID: <147830559011.4165.17937663704012458827.stgit@birch.djwong.org>
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

Scrub an individual inode's block mappings to make sure they make sense.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap_btree.c |   26 ++++++++++++++++++++++----
 libxfs/xfs_fs.h         |    5 ++++-
 2 files changed, 26 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 2997a3a..78a0440 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -620,6 +620,16 @@ xfs_bmbt_init_key_from_rec(
 }
 
 STATIC void
+xfs_bmbt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->bmbt.br_startoff = cpu_to_be64(
+			xfs_bmbt_disk_get_startoff(&rec->bmbt) +
+			xfs_bmbt_disk_get_blockcount(&rec->bmbt) - 1);
+}
+
+STATIC void
 xfs_bmbt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -644,6 +654,16 @@ xfs_bmbt_key_diff(
 				      cur->bc_rec.b.br_startoff;
 }
 
+STATIC __int64_t
+xfs_bmbt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be64_to_cpu(k1->bmbt.br_startoff) -
+			  be64_to_cpu(k2->bmbt.br_startoff);
+}
+
 static bool
 xfs_bmbt_verify(
 	struct xfs_buf		*bp)
@@ -734,7 +754,6 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 };
 
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_bmbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -755,7 +774,6 @@ xfs_bmbt_recs_inorder(
 		xfs_bmbt_disk_get_blockcount(&r1->bmbt) <=
 		xfs_bmbt_disk_get_startoff(&r2->bmbt);
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
@@ -769,14 +787,14 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.get_minrecs		= xfs_bmbt_get_minrecs,
 	.get_dmaxrecs		= xfs_bmbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
+	.diff_two_keys		= xfs_bmbt_diff_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 7a794b4..fc8efef 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -610,7 +610,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_RMAPBT	9	/* reverse mapping btree */
 #define XFS_SCRUB_TYPE_REFCNTBT	10	/* reference count btree */
 #define XFS_SCRUB_TYPE_INODE	11	/* inode record */
-#define XFS_SCRUB_TYPE_MAX	11
+#define XFS_SCRUB_TYPE_BMBTD	12	/* data fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTA	13	/* attr fork block mapping */
+#define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
+#define XFS_SCRUB_TYPE_MAX	14
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */

