Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39612 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754146AbcKEA0J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:26:09 -0400
Subject: [PATCH 14/39] xfs: support scrubbing inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:26:05 -0700
Message-ID: <147830556575.4165.2567549018894210404.stgit@birch.djwong.org>
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

Plumb in the pieces necessary to check the inode btrees.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h           |    4 +++-
 libxfs/xfs_ialloc.c       |   41 +++++++++++++++++++++++++----------------
 libxfs/xfs_ialloc.h       |    3 +++
 libxfs/xfs_ialloc_btree.c |   32 ++++++++++++++++++++++++++------
 4 files changed, 57 insertions(+), 23 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 0e0c35f..97df1b9 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -605,7 +605,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
 #define XFS_SCRUB_TYPE_BNOBT	5	/* freesp by block btree */
 #define XFS_SCRUB_TYPE_CNTBT	6	/* freesp by length btree */
-#define XFS_SCRUB_TYPE_MAX	6
+#define XFS_SCRUB_TYPE_INOBT	7	/* inode btree */
+#define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
+#define XFS_SCRUB_TYPE_MAX	8
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 8f7fe60..1445315 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -93,24 +93,14 @@ xfs_inobt_update(
 	return xfs_btree_update(cur, &rec);
 }
 
-/*
- * Get the data from the pointed-to record.
- */
-int					/* error */
-xfs_inobt_get_rec(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_inobt_rec_incore_t	*irec,	/* btree record */
-	int			*stat)	/* output: success/failure */
+void
+xfs_inobt_btrec_to_irec(
+	struct xfs_mount		*mp,
+	union xfs_btree_rec		*rec,
+	struct xfs_inobt_rec_incore	*irec)
 {
-	union xfs_btree_rec	*rec;
-	int			error;
-
-	error = xfs_btree_get_rec(cur, &rec, stat);
-	if (error || *stat == 0)
-		return error;
-
 	irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
-	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb)) {
 		irec->ir_holemask = be16_to_cpu(rec->inobt.ir_u.sp.ir_holemask);
 		irec->ir_count = rec->inobt.ir_u.sp.ir_count;
 		irec->ir_freecount = rec->inobt.ir_u.sp.ir_freecount;
@@ -125,6 +115,25 @@ xfs_inobt_get_rec(
 				be32_to_cpu(rec->inobt.ir_u.f.ir_freecount);
 	}
 	irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+int					/* error */
+xfs_inobt_get_rec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_inobt_rec_incore_t	*irec,	/* btree record */
+	int			*stat)	/* output: success/failure */
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (error || *stat == 0)
+		return error;
+
+	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, irec);
 
 	return 0;
 }
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 0bb8966..8e5861d 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -168,5 +168,8 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, struct xfs_buf **bpp);
 
+union xfs_btree_rec;
+void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
+		struct xfs_inobt_rec_incore *irec);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index c2d4a5e..4795f08 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -151,6 +151,18 @@ xfs_inobt_init_key_from_rec(
 }
 
 STATIC void
+xfs_inobt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	__u32			x;
+
+	x = be32_to_cpu(rec->inobt.ir_startino);
+	x += XFS_INODES_PER_CHUNK - 1;
+	key->inobt.ir_startino = cpu_to_be32(x);
+}
+
+STATIC void
 xfs_inobt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -204,6 +216,16 @@ xfs_inobt_key_diff(
 			  cur->bc_rec.i.ir_startino;
 }
 
+STATIC __int64_t
+xfs_inobt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be32_to_cpu(k1->inobt.ir_startino) -
+			  be32_to_cpu(k2->inobt.ir_startino);
+}
+
 static int
 xfs_inobt_verify(
 	struct xfs_buf		*bp)
@@ -278,7 +300,6 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.verify_write = xfs_inobt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_inobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -298,7 +319,6 @@ xfs_inobt_recs_inorder(
 	return be32_to_cpu(r1->inobt.ir_startino) + XFS_INODES_PER_CHUNK <=
 		be32_to_cpu(r2->inobt.ir_startino);
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
@@ -311,14 +331,14 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.get_minrecs		= xfs_inobt_get_minrecs,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_inobt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
+	.diff_two_keys		= xfs_inobt_diff_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
-#endif
 };
 
 static const struct xfs_btree_ops xfs_finobt_ops = {
@@ -332,14 +352,14 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 	.get_minrecs		= xfs_inobt_get_minrecs,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_inobt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
+	.diff_two_keys		= xfs_inobt_diff_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
-#endif
 };
 
 /*

