Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38591 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751493AbcKEAUu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:20:50 -0400
Subject: [PATCH 16/41] xfs: support scrubbing inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:20:46 -0700
Message-ID: <147830524686.2155.16622646584377694478.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Check the records of the inode btrees to make sure that the values
make sense given the inode records themselves.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h           |    4 +
 fs/xfs/libxfs/xfs_ialloc.c       |   41 +++++++-----
 fs/xfs/libxfs/xfs_ialloc.h       |    3 +
 fs/xfs/libxfs/xfs_ialloc_btree.c |   32 +++++++--
 fs/xfs/xfs_scrub.c               |  135 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h               |    4 +
 6 files changed, 195 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d640464..00be3ca 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -581,7 +581,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
 #define XFS_SCRUB_TYPE_BNOBT	5	/* freesp by block btree */
 #define XFS_SCRUB_TYPE_CNTBT	6	/* freesp by length btree */
-#define XFS_SCRUB_TYPE_MAX	6
+#define XFS_SCRUB_TYPE_INOBT	7	/* inode btree */
+#define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
+#define XFS_SCRUB_TYPE_MAX	8
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c4f17d2..720c93a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -99,24 +99,14 @@ xfs_inobt_update(
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
@@ -131,6 +121,25 @@ xfs_inobt_get_rec(
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
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 0bb8966..8e5861d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -168,5 +168,8 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, struct xfs_buf **bpp);
 
+union xfs_btree_rec;
+void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
+		struct xfs_inobt_rec_incore *irec);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 6c6b959..dbdd532 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -152,6 +152,18 @@ xfs_inobt_init_key_from_rec(
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
@@ -205,6 +217,16 @@ xfs_inobt_key_diff(
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
@@ -279,7 +301,6 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.verify_write = xfs_inobt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_inobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -299,7 +320,6 @@ xfs_inobt_recs_inorder(
 	return be32_to_cpu(r1->inobt.ir_startino) + XFS_INODES_PER_CHUNK <=
 		be32_to_cpu(r2->inobt.ir_startino);
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
@@ -312,14 +332,14 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
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
@@ -333,14 +353,14 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
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
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 3784f46..d87f092 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1758,6 +1758,139 @@ xfs_scrub_cntbt(
 	return xfs_scrub_allocbt(sc, XFS_BTNUM_CNT);
 }
 
+/* Inode btree scrubber. */
+
+/* Scrub a chunk of an inobt record. */
+STATIC int
+xfs_scrub_iallocbt_chunk(
+	struct xfs_scrub_btree		*bs,
+	struct xfs_inobt_rec_incore	*irec,
+	xfs_agino_t			agino,
+	xfs_extlen_t			len,
+	bool				*keep_scanning)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_agf			*agf;
+	xfs_agblock_t			eoag;
+	xfs_agblock_t			bno;
+	int				error = 0;
+
+	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
+	eoag = be32_to_cpu(agf->agf_length);
+	bno = XFS_AGINO_TO_AGBNO(mp, agino);
+
+	*keep_scanning = true;
+	XFS_SCRUB_BTREC_CHECK(bs, bno < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, bno < eoag);
+	XFS_SCRUB_BTREC_CHECK(bs, bno < bno + len);
+	XFS_SCRUB_BTREC_CHECK(bs, (unsigned long long)bno + len <=
+			mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, (unsigned long long)bno + len <=
+			eoag);
+	if (error) {
+		*keep_scanning = false;
+		goto out;
+	}
+
+out:
+	return error;
+}
+
+/* Scrub an inobt/finobt record. */
+STATIC int
+xfs_scrub_iallocbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_inobt_rec_incore	irec;
+	__uint16_t			holemask;
+	xfs_agino_t			agino;
+	xfs_extlen_t			len;
+	bool				keep_scanning;
+	int				holecount;
+	int				i;
+	int				error = 0;
+	int				err2 = 0;
+	uint64_t			holes;
+
+	xfs_inobt_btrec_to_irec(mp, rec, &irec);
+
+	XFS_SCRUB_BTREC_CHECK(bs, irec.ir_count <= XFS_INODES_PER_CHUNK);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.ir_freecount <= XFS_INODES_PER_CHUNK);
+	agino = irec.ir_startino;
+
+	/* Handle non-sparse inodes */
+	if (!xfs_inobt_issparse(irec.ir_holemask)) {
+		len = XFS_B_TO_FSB(mp,
+				XFS_INODES_PER_CHUNK * mp->m_sb.sb_inodesize);
+
+		error = xfs_scrub_iallocbt_chunk(bs, &irec, agino, len,
+				&keep_scanning);
+		goto out;
+	}
+
+	/* Check each chunk of a sparse inode cluster. */
+	holemask = irec.ir_holemask;
+	holecount = 0;
+	len = XFS_B_TO_FSB(mp,
+			XFS_INODES_PER_HOLEMASK_BIT * mp->m_sb.sb_inodesize);
+	holes = ~xfs_inobt_irec_to_allocmask(&irec);
+	XFS_SCRUB_BTREC_CHECK(bs, (holes & irec.ir_free) == holes);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.ir_freecount <= irec.ir_count);
+
+	for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; holemask >>= 1,
+			i++, agino += XFS_INODES_PER_HOLEMASK_BIT) {
+		if (holemask & 1) {
+			holecount += XFS_INODES_PER_HOLEMASK_BIT;
+			continue;
+		}
+
+		err2 = xfs_scrub_iallocbt_chunk(bs, &irec, agino, len,
+				&keep_scanning);
+		if (!error && err2)
+			error = err2;
+		if (!keep_scanning)
+			break;
+	}
+
+	XFS_SCRUB_BTREC_CHECK(bs, holecount <= XFS_INODES_PER_CHUNK);
+	XFS_SCRUB_BTREC_CHECK(bs, holecount + irec.ir_count ==
+			XFS_INODES_PER_CHUNK);
+
+out:
+	return error;
+}
+
+/* Scrub the inode btrees for some AG. */
+STATIC int
+xfs_scrub_iallocbt(
+	struct xfs_scrub_context	*sc,
+	xfs_btnum_t			which)
+{
+	struct xfs_btree_cur		*cur;
+	struct xfs_owner_info		oinfo;
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
+	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
+	return xfs_scrub_btree(sc, cur, xfs_scrub_iallocbt_helper,
+			&oinfo, NULL);
+}
+
+STATIC int
+xfs_scrub_inobt(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_iallocbt(sc, XFS_BTNUM_INO);
+}
+
+STATIC int
+xfs_scrub_finobt(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_iallocbt(sc, XFS_BTNUM_FINO);
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -1776,6 +1909,8 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_agi, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_bnobt, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_cntbt, NULL, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_inobt, NULL, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_finobt, NULL, xfs_sb_version_hasfinobt},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 48e0191..d9d3a61 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3468,7 +3468,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }, \
 	{ XFS_SCRUB_TYPE_AGI,		"AGI" }, \
 	{ XFS_SCRUB_TYPE_BNOBT,		"bnobt" }, \
-	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }
+	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }, \
+	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
+	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

