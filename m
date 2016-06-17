Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 22DEF84C2
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:45:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A10FAAC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:45:54 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ytsqlsCbAZvEdsUk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:45:52 -0700 (PDT)
Subject: [PATCH 141/145] xfs: support scrubbing inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:45:34 -0700
Message-ID: <146612793409.16048.2627788174769006287.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Plumb in the pieces necessary to check the inode btrees.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_ialloc.c       |  178 +++++++++++++++++++++++++++++++++++++++++----
 libxfs/xfs_ialloc.h       |    2 +
 libxfs/xfs_ialloc_btree.c |   18 +++--
 3 files changed, 176 insertions(+), 22 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 8c2344c..d0fb2db 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -34,6 +34,8 @@
 #include "xfs_cksum.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_scrub.h"
 
 
 /*
@@ -92,24 +94,14 @@ xfs_inobt_update(
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
+STATIC void
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
@@ -124,6 +116,25 @@ xfs_inobt_get_rec(
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
@@ -2644,3 +2655,138 @@ xfs_ialloc_pagi_init(
 		xfs_trans_brelse(tp, bp);
 	return 0;
 }
+
+STATIC int
+xfs_iallocbt_scrub_helper(
+	struct xfs_btree_scrub		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_inobt_rec_incore	irec;
+	__uint16_t			holemask;
+	xfs_agino_t			agino;
+	xfs_agblock_t			bno;
+	xfs_extlen_t			len;
+	int				holecount;
+	int				i;
+	bool				has_rmap = false;
+	struct xfs_owner_info		oinfo;
+	int				error = 0;
+	uint64_t			holes;
+
+	xfs_inobt_btrec_to_irec(mp, rec, &irec);
+
+	XFS_BTREC_SCRUB_CHECK(bs, irec.ir_count <= XFS_INODES_PER_CHUNK);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.ir_freecount <= XFS_INODES_PER_CHUNK);
+	agino = irec.ir_startino;
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+
+	/* Handle non-sparse inodes */
+	if (!xfs_inobt_issparse(irec.ir_holemask)) {
+		len = XFS_B_TO_FSB(mp,
+				XFS_INODES_PER_CHUNK * mp->m_sb.sb_inodesize);
+		bno = XFS_AGINO_TO_AGBNO(mp, agino);
+
+		XFS_BTREC_SCRUB_CHECK(bs, bno < mp->m_sb.sb_agblocks)
+		XFS_BTREC_SCRUB_CHECK(bs, bno < bno + len);
+		XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
+				mp->m_sb.sb_agblocks);
+
+		if (!bs->rmap_cur)
+			return error;
+		error = xfs_rmap_record_exists(bs->rmap_cur, bno, len, &oinfo,
+				&has_rmap);
+		if (error)
+			return error;
+		XFS_BTREC_SCRUB_CHECK(bs, has_rmap);
+		return 0;
+	}
+
+	/* Check each chunk of a sparse inode cluster. */
+	holemask = irec.ir_holemask;
+	holecount = 0;
+	len = XFS_B_TO_FSB(mp,
+			XFS_INODES_PER_HOLEMASK_BIT * mp->m_sb.sb_inodesize);
+	holes = ~xfs_inobt_irec_to_allocmask(&irec);
+	XFS_BTREC_SCRUB_CHECK(bs, (holes & irec.ir_free) == holes);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.ir_freecount <= irec.ir_count);
+
+	for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; holemask >>= 1,
+			i++, agino += XFS_INODES_PER_HOLEMASK_BIT) {
+		if (holemask & 1) {
+			holecount += XFS_INODES_PER_HOLEMASK_BIT;
+			continue;
+		}
+		bno = XFS_AGINO_TO_AGBNO(mp, agino);
+
+		XFS_BTREC_SCRUB_CHECK(bs, bno < mp->m_sb.sb_agblocks)
+		XFS_BTREC_SCRUB_CHECK(bs, bno < bno + len);
+		XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
+				mp->m_sb.sb_agblocks);
+
+		if (!bs->rmap_cur)
+			continue;
+		error = xfs_rmap_record_exists(bs->rmap_cur, bno, len, &oinfo,
+				&has_rmap);
+		if (error)
+			break;
+		XFS_BTREC_SCRUB_CHECK(bs, has_rmap);
+	}
+
+	XFS_BTREC_SCRUB_CHECK(bs, holecount <= XFS_INODES_PER_CHUNK);
+	XFS_BTREC_SCRUB_CHECK(bs, holecount + irec.ir_count ==
+			XFS_INODES_PER_CHUNK);
+
+	return error;
+}
+
+/* Scrub the inode btrees for some AG. */
+STATIC int
+xfs_iallocbt_scrub(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		which)
+{
+	struct xfs_btree_scrub	bs;
+	int			error;
+
+	error = xfs_ialloc_read_agi(mp, NULL, agno, &bs.agi_bp);
+	if (error)
+		return error;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &bs.agf_bp);
+	if (error) {
+		xfs_trans_brelse(NULL, bs.agi_bp);
+		return error;
+	}
+
+	bs.cur = xfs_inobt_init_cursor(mp, NULL, bs.agi_bp, agno, which);
+	bs.scrub_rec = xfs_iallocbt_scrub_helper;
+	xfs_rmap_ag_owner(&bs.oinfo, XFS_RMAP_OWN_INOBT);
+	error = xfs_btree_scrub(&bs);
+	xfs_btree_del_cursor(bs.cur,
+			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_trans_brelse(NULL, bs.agf_bp);
+	xfs_trans_brelse(NULL, bs.agi_bp);
+
+	if (!error && bs.error)
+		error = bs.error;
+
+	return error;
+}
+
+int
+xfs_inobt_scrub(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	return xfs_iallocbt_scrub(mp, agno, XFS_BTNUM_INO);
+}
+
+int
+xfs_finobt_scrub(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	return xfs_iallocbt_scrub(mp, agno, XFS_BTNUM_FINO);
+}
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 0bb8966..7ea6ff3 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -168,5 +168,7 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, struct xfs_buf **bpp);
 
+extern int xfs_inobt_scrub(struct xfs_mount *mp, xfs_agnumber_t agno);
+extern int xfs_finobt_scrub(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 36d09eb..81a7b97 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -203,6 +203,16 @@ xfs_inobt_key_diff(
 			  cur->bc_rec.i.ir_startino;
 }
 
+STATIC __int64_t
+xfs_inobt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be32_to_cpu(k2->inobt.ir_startino) -
+			  be32_to_cpu(k1->inobt.ir_startino);
+}
+
 static int
 xfs_inobt_verify(
 	struct xfs_buf		*bp)
@@ -277,7 +287,6 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.verify_write = xfs_inobt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_inobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -297,7 +306,6 @@ xfs_inobt_recs_inorder(
 	return be32_to_cpu(r1->inobt.ir_startino) + XFS_INODES_PER_CHUNK <=
 		be32_to_cpu(r2->inobt.ir_startino);
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
@@ -314,10 +322,9 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
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
@@ -335,10 +342,9 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
