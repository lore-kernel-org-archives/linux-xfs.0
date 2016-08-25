Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BA1D7F23
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:41:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 554048F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:38 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Axx1gc6cbyd61cdY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:41:36 -0700 (PDT)
Subject: [PATCH 12/25] xfs: support scrubbing inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:41:31 -0700
Message-ID: <147216849160.3108.13963850933878815940.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Plumb in the pieces necessary to check the inode btrees.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h           |    4 +
 fs/xfs/libxfs/xfs_ialloc.c       |   41 +++++++-----
 fs/xfs/libxfs/xfs_ialloc.h       |    3 +
 fs/xfs/libxfs/xfs_ialloc_btree.c |   32 ++++++++-
 fs/xfs/xfs_scrub.c               |  129 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 186 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2cb47e2..6b8ff75 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -541,7 +541,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_AGI	3	/* AG inode header */
 #define XFS_SCRUB_TYPE_BNOBT	4	/* freesp by block btree */
 #define XFS_SCRUB_TYPE_CNTBT	5	/* freesp by length btree */
-#define XFS_SCRUB_TYPE_MAX	5
+#define XFS_SCRUB_TYPE_INOBT	6	/* inode btree */
+#define XFS_SCRUB_TYPE_FINOBT	7	/* free inode btree */
+#define XFS_SCRUB_TYPE_MAX	7
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1240064..ab05f63 100644
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
index eab68ae..f09ec06 100644
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
index b93dedb..81d24f5 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1037,6 +1037,133 @@ xfs_scrub_cntbt(
 	return xfs_scrub_allocbt(ip->i_mount, sm, XFS_BTNUM_CNT);
 }
 
+/* Inode btree scrubber. */
+
+/* Scrub an inobt/finobt record. */
+STATIC int
+xfs_scrub_iallocbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_agf			*agf;
+	struct xfs_inobt_rec_incore	irec;
+	__uint16_t			holemask;
+	xfs_agino_t			agino;
+	xfs_agblock_t			bno;
+	xfs_agblock_t			eoag;
+	xfs_extlen_t			len;
+	int				holecount;
+	int				i;
+	int				error = 0;
+	uint64_t			holes;
+
+	xfs_inobt_btrec_to_irec(mp, rec, &irec);
+
+	XFS_BTREC_SCRUB_CHECK(bs, irec.ir_count <= XFS_INODES_PER_CHUNK);
+	XFS_BTREC_SCRUB_CHECK(bs, irec.ir_freecount <= XFS_INODES_PER_CHUNK);
+	agino = irec.ir_startino;
+	agf = XFS_BUF_TO_AGF(bs->agf_bp);
+	eoag = be32_to_cpu(agf->agf_length);
+
+	/* Handle non-sparse inodes */
+	if (!xfs_inobt_issparse(irec.ir_holemask)) {
+		len = XFS_B_TO_FSB(mp,
+				XFS_INODES_PER_CHUNK * mp->m_sb.sb_inodesize);
+		bno = XFS_AGINO_TO_AGBNO(mp, agino);
+
+		XFS_BTREC_SCRUB_CHECK(bs, bno < mp->m_sb.sb_agblocks)
+		XFS_BTREC_SCRUB_CHECK(bs, bno < eoag);
+		XFS_BTREC_SCRUB_CHECK(bs, bno < bno + len);
+		XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
+				mp->m_sb.sb_agblocks);
+		XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
+				eoag);
+		return error;
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
+		XFS_BTREC_SCRUB_CHECK(bs, bno < eoag);
+		XFS_BTREC_SCRUB_CHECK(bs, bno < bno + len);
+		XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
+				mp->m_sb.sb_agblocks);
+		XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
+				eoag);
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
+xfs_scrub_iallocbt(
+	struct xfs_mount		*mp,
+	struct xfs_scrub_metadata	*sm,
+	xfs_btnum_t			which)
+{
+	struct xfs_scrub_btree		bs;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	if (sm->control >= mp->m_sb.sb_agcount || sm->flags)
+		return -EINVAL;
+	agno = sm->control;
+
+	error = xfs_scrub_btree_get_ag_headers(mp, &bs, agno);
+	if (error)
+		return error;
+
+	bs.cur = xfs_inobt_init_cursor(mp, NULL, bs.agi_bp, agno, which);
+	bs.scrub_rec = xfs_scrub_iallocbt_helper;
+	xfs_rmap_ag_owner(&bs.oinfo, XFS_RMAP_OWN_INOBT);
+	error = xfs_scrub_btree(&bs);
+	xfs_btree_del_cursor(bs.cur,
+			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_scrub_btree_put_ag_headers(&bs);
+
+	if (!error && bs.error)
+		error = bs.error;
+
+	return error;
+}
+
+STATIC int
+xfs_scrub_inobt(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	return xfs_scrub_iallocbt(ip->i_mount, sm, XFS_BTNUM_INO);
+}
+
+STATIC int
+xfs_scrub_finobt(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	return xfs_scrub_iallocbt(ip->i_mount, sm, XFS_BTNUM_FINO);
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -1051,6 +1178,8 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_agi,		NULL},
 	{xfs_scrub_bnobt,	NULL},
 	{xfs_scrub_cntbt,	NULL},
+	{xfs_scrub_inobt,	NULL},
+	{xfs_scrub_finobt,	xfs_sb_version_hasfinobt},
 };
 
 /* Dispatch metadata scrubbing. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
