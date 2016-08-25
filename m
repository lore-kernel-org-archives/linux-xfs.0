Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 70BEC7F7C
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:42:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3534F8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:16 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id x7KNt3pSQYNv82Ei (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:13 -0700 (PDT)
Subject: [PATCH 18/25] xfs: scrub should cross-reference with the bnobt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:42:09 -0700
Message-ID: <147216852921.3108.6982601521206127601.stgit@birch.djwong.org>
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

When we're scrubbing various btrees, cross-reference the records with
the bnobt to ensure that we don't also think the space is free.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   19 +++++
 fs/xfs/libxfs/xfs_alloc.h |    3 +
 fs/xfs/xfs_scrub.c        |  184 +++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 197 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 37782a1..0de83f5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2974,3 +2974,22 @@ xfs_alloc_query_range(
 	return xfs_btree_query_range(cur, &low_brec, &high_brec,
 			xfs_alloc_query_range_helper, &query);
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_alloc_has_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*exists)
+{
+	union xfs_btree_irec	low;
+	union xfs_btree_irec	high;
+
+	memset(&low, 0, sizeof(low));
+	low.a.ar_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.a.ar_startblock = bno + len - 1;
+
+	return xfs_btree_has_record(cur, &low, &high, exists);
+}
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index c3ada6b..b740456 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -222,4 +222,7 @@ int xfs_alloc_query_range(struct xfs_btree_cur *cur,
 		struct xfs_alloc_rec_incore *high_rec,
 		xfs_alloc_query_range_fn fn, void *priv);
 
+int xfs_alloc_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, bool *exist);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 22ba07d..612d3c3 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -515,6 +515,67 @@ xfs_scrub_should_terminate(
 }
 
 /*
+ * Make sure this btree block isn't in the free list and that there's
+ * an rmap record for it.
+ */
+STATIC int
+xfs_scrub_btree_check_block_owner(
+	struct xfs_scrub_btree		*bs,
+	xfs_fsblock_t			fsb)
+{
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+	bool				is_freesp;
+	struct xfs_buf			*agf_bp = NULL;
+	struct xfs_btree_cur		*bcur = NULL;
+	int				error = 0;
+	int				err2;
+
+	agno = XFS_FSB_TO_AGNO(bs->cur->bc_mp, fsb);
+	bno = XFS_FSB_TO_AGBNO(bs->cur->bc_mp, fsb);
+
+	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		err2 = xfs_alloc_read_agf(bs->cur->bc_mp, NULL, agno,
+				0, &agf_bp);
+		if (err2)
+			return error;
+		bcur = xfs_allocbt_init_cursor(bs->cur->bc_mp, NULL,
+				agf_bp, agno, XFS_BTNUM_BNO);
+	} else {
+		bcur = bs->bno_cur;
+	}
+
+	/* Check that this block isn't free. */
+	err2 = xfs_alloc_has_record(bcur, bno, 1, &is_freesp);
+	if (!err2)
+		XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
+
+	if (agf_bp) {
+		xfs_btree_del_cursor(bcur, XFS_BTREE_ERROR);
+		xfs_buf_relse(agf_bp);
+	}
+
+	return error;
+}
+
+/* Check the owner of a btree block. */
+STATIC int
+xfs_scrub_btree_check_owner(
+	struct xfs_scrub_btree		*bs,
+	struct xfs_buf			*bp)
+{
+	struct xfs_btree_cur		*cur = bs->cur;
+	xfs_fsblock_t			fsbno;
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) && bp == NULL)
+		return 0;
+
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+
+	return xfs_scrub_btree_check_block_owner(bs, fsbno);
+}
+
+/*
  * Visit all nodes and leaves of a btree.  Check that all pointers and
  * records are in order, that the keys reflect the records, and use a callback
  * so that the caller can verify individual records.  The callback is the same
@@ -604,6 +665,9 @@ xfs_scrub_btree(
 	error = xfs_btree_check_block(cur, block, level, bp);
 	if (error)
 		goto out;
+	error = xfs_scrub_btree_check_owner(bs, bp);
+	if (error)
+		goto out;
 
 	cur->bc_ptrs[level] = 1;
 
@@ -664,6 +728,10 @@ xfs_scrub_btree(
 		if (error)
 			goto out;
 
+		error = xfs_scrub_btree_check_owner(bs, bp);
+		if (error)
+			goto out;
+
 		cur->bc_ptrs[level] = 1;
 	}
 
@@ -716,9 +784,14 @@ xfs_scrub_sb(
 {
 	struct xfs_mount		*mp = ip->i_mount;
 	struct xfs_buf			*bp;
+	struct xfs_buf			*agi_bp = NULL;
+	struct xfs_buf			*agf_bp = NULL;
+	struct xfs_btree_cur		*xcur = NULL;
 	struct xfs_sb			sb;
 	xfs_agnumber_t			agno;
+	bool				is_freesp;
 	int				error;
+	int				err2;
 
 	if (sm->control >= mp->m_sb.sb_agcount || sm->flags)
 		return -EINVAL;
@@ -732,7 +805,7 @@ xfs_scrub_sb(
 		return error;
 
 	if (agno == 0)
-		goto out;
+		goto btree_xref;
 
 	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
 
@@ -776,6 +849,22 @@ xfs_scrub_sb(
         XFS_SCRUB_SB_FEAT(realtime);
 #undef XFS_SCRUB_SB_FEAT
 
+	if (error)
+		goto out;
+
+btree_xref:
+	error = xfs_scrub_get_ag_headers(mp, agno, &agi_bp, &agf_bp);
+	if (error)
+		goto out;
+
+	/* Cross-reference with bnobt. */
+	xcur = xfs_allocbt_init_cursor(mp, NULL, agf_bp, agno, XFS_BTNUM_BNO);
+	err2 = xfs_alloc_has_record(xcur, XFS_SB_BLOCK(mp), 1, &is_freesp);
+	if (!err2)
+		XFS_SCRUB_CHECK(mp, bp, "superblock", !is_freesp);
+	xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
+	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 out:
 	xfs_buf_relse(bp);
 	return error;
@@ -791,12 +880,15 @@ xfs_scrub_agf(
 	struct xfs_agf			*agf;
 	struct xfs_buf			*agi_bp = NULL;
 	struct xfs_buf			*agf_bp = NULL;
+	struct xfs_btree_cur		*xcur = NULL;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	xfs_agblock_t			eoag;
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			eofs;
+	bool				is_freesp;
 	int				error;
+	int				err2;
 
 	if (sm->control >= mp->m_sb.sb_agcount || sm->flags)
 		return -EINVAL;
@@ -853,6 +945,13 @@ xfs_scrub_agf(
 		XFS_SCRUB_CHECK(mp, agf_bp, "AGF", daddr < eofs);
 	}
 
+	/* Cross-reference with the bnobt. */
+	xcur = xfs_allocbt_init_cursor(mp, NULL, agf_bp, agno, XFS_BTNUM_BNO);
+	err2 = xfs_alloc_has_record(xcur, XFS_AGF_BLOCK(mp), 1, &is_freesp);
+	if (!err2)
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF", !is_freesp);
+	xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 	return error;
 }
@@ -869,12 +968,15 @@ xfs_scrub_agfl(
 	struct xfs_buf			*agf_bp = NULL;
 	struct xfs_buf			*agfl_bp;
 	__be32				*agfl_bno;
+	struct xfs_btree_cur		*xcur = NULL;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	xfs_agblock_t			eoag;
 	xfs_daddr_t			eofs;
+	bool				is_freesp;
 	int				i;
 	int				error;
+	int				err2;
 
 	if (sm->control >= mp->m_sb.sb_agcount || sm->flags)
 		return -EINVAL;
@@ -893,6 +995,12 @@ xfs_scrub_agfl(
 	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	eoag = be32_to_cpu(agf->agf_length);
 
+	/* Cross-reference with the bnobt. */
+	xcur = xfs_allocbt_init_cursor(mp, NULL, agf_bp, agno, XFS_BTNUM_BNO);
+	err2 = xfs_alloc_has_record(xcur, XFS_AGFL_BLOCK(mp), 1, &is_freesp);
+	if (!err2)
+		XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", !is_freesp);
+
 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
 	for (i = be32_to_cpu(agf->agf_flfirst);
 	     i <= be32_to_cpu(agf->agf_fllast);
@@ -904,8 +1012,14 @@ xfs_scrub_agfl(
 				agbno < mp->m_sb.sb_agblocks);
 		XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL",
 				agbno < eoag);
+
+		/* Cross-reference with the bnobt. */
+		err2 = xfs_alloc_has_record(xcur, agbno, 1, &is_freesp);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", !is_freesp);
 	}
 
+	xfs_btree_del_cursor(xcur, XFS_BTREE_ERROR);
 	xfs_buf_relse(agfl_bp);
 err_no_agfl:
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
@@ -923,12 +1037,15 @@ xfs_scrub_agi(
 	struct xfs_agf			*agf;
 	struct xfs_buf			*agi_bp = NULL;
 	struct xfs_buf			*agf_bp = NULL;
+	struct xfs_btree_cur		*xcur = NULL;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	xfs_agblock_t			eoag;
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			eofs;
+	bool				is_freesp;
 	int				error;
+	int				err2;
 
 	if (sm->control >= mp->m_sb.sb_agcount || sm->flags)
 		return -EINVAL;
@@ -958,6 +1075,13 @@ xfs_scrub_agi(
 		XFS_SCRUB_CHECK(mp, agi_bp, "AGI", daddr < eofs);
 	}
 
+	/* Cross-reference with bnobt. */
+	xcur = xfs_allocbt_init_cursor(mp, NULL, agf_bp, agno, XFS_BTNUM_BNO);
+	err2 = xfs_alloc_has_record(xcur, XFS_AGI_BLOCK(mp), 1, &is_freesp);
+	if (!err2)
+		XFS_SCRUB_CHECK(mp, agi_bp, "AGI", !is_freesp);
+	xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 	return error;
 }
@@ -1056,9 +1180,11 @@ xfs_scrub_iallocbt_helper(
 	xfs_agblock_t			bno;
 	xfs_agblock_t			eoag;
 	xfs_extlen_t			len;
+	bool				is_freesp;
 	int				holecount;
 	int				i;
 	int				error = 0;
+	int				err2;
 	uint64_t			holes;
 
 	xfs_inobt_btrec_to_irec(mp, rec, &irec);
@@ -1082,7 +1208,14 @@ xfs_scrub_iallocbt_helper(
 				mp->m_sb.sb_agblocks);
 		XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
 				eoag);
-		return error;
+
+		/* Cross-reference with the bnobt. */
+		err2 = xfs_alloc_has_record(bs->bno_cur, bno, len,
+				&is_freesp);
+		if (!err2)
+			XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
+
+		goto out;
 	}
 
 	/* Check each chunk of a sparse inode cluster. */
@@ -1109,12 +1242,19 @@ xfs_scrub_iallocbt_helper(
 				mp->m_sb.sb_agblocks);
 		XFS_BTREC_SCRUB_CHECK(bs, (unsigned long long)bno + len <=
 				eoag);
+
+		/* Cross-reference with the bnobt. */
+		err2 = xfs_alloc_has_record(bs->bno_cur, bno, len,
+				&is_freesp);
+		if (!err2)
+			XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
 	}
 
 	XFS_BTREC_SCRUB_CHECK(bs, holecount <= XFS_INODES_PER_CHUNK);
 	XFS_BTREC_SCRUB_CHECK(bs, holecount + irec.ir_count ==
 			XFS_INODES_PER_CHUNK);
 
+out:
 	return error;
 }
 
@@ -1179,11 +1319,13 @@ xfs_scrub_rmapbt_helper(
 	struct xfs_agf			*agf;
 	struct xfs_rmap_irec		irec;
 	xfs_agblock_t			eoag;
+	bool				is_freesp;
 	bool				non_inode;
 	bool				is_unwritten;
 	bool				is_bmbt;
 	bool				is_attr;
-	int				error;
+	int				error = 0;
+	int				err2;
 
 	error = xfs_rmap_btrec_to_irec(rec, &irec);
 	if (error)
@@ -1212,7 +1354,11 @@ xfs_scrub_rmapbt_helper(
 	XFS_BTREC_SCRUB_CHECK(bs, !non_inode || !(is_bmbt || is_unwritten ||
 			is_attr));
 
-	/* XXX: check with the owner */
+	/* check there's no record in freesp btrees */
+	err2 = xfs_alloc_has_record(bs->bno_cur, irec.rm_startblock,
+			irec.rm_blockcount, &is_freesp);
+	if (!err2)
+		XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
 
 	return error;
 }
@@ -1262,7 +1408,9 @@ xfs_scrub_refcountbt_helper(
 	struct xfs_agf			*agf;
 	struct xfs_refcount_irec	irec;
 	xfs_agblock_t			eoag;
+	bool				is_freesp;
 	int				error = 0;
+	int				err2;
 
 	irec.rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
 	irec.rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
@@ -1280,6 +1428,12 @@ xfs_scrub_refcountbt_helper(
 			irec.rc_blockcount <= eoag);
 	XFS_BTREC_SCRUB_CHECK(bs, irec.rc_refcount >= 1);
 
+	/* Cross-reference with the bnobt. */
+	err2 = xfs_alloc_has_record(bs->bno_cur, irec.rc_startblock,
+			irec.rc_blockcount, &is_freesp);
+	if (!err2)
+		XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
+
 	return error;
 }
 
@@ -1412,10 +1566,12 @@ xfs_scrub_bmap_extent(
 	struct xfs_buf			*bp = NULL;
 	struct xfs_buf			*agi_bp = NULL;
 	struct xfs_buf			*agf_bp = NULL;
+	struct xfs_btree_cur		*xcur = NULL;
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			dlen;
 	xfs_agnumber_t			agno;
 	xfs_fsblock_t			bno;
+	bool				is_freesp;
 	int				error = 0;
 	int				err2 = 0;
 
@@ -1450,19 +1606,29 @@ xfs_scrub_bmap_extent(
 	XFS_INO_SCRUB_CHECK(ip, bp, info->type,
 			irec->br_state != XFS_EXT_UNWRITTEN ||
 			xfs_sb_version_hasextflgbit(&mp->m_sb));
+	if (error)
+		goto out;
 
 	/* Set ourselves up for cross-referencing later. */
 	if (!info->is_rt) {
-		err2 = xfs_scrub_get_ag_headers(mp, agno, &agi_bp, &agf_bp);
-		if (err2)
+		error = xfs_scrub_get_ag_headers(mp, agno, &agi_bp, &agf_bp);
+		if (error)
 			goto out;
+
+		/* Cross-reference with the bnobt. */
+		xcur = xfs_allocbt_init_cursor(mp, NULL, agf_bp, agno,
+				XFS_BTNUM_BNO);
+		err2 = xfs_alloc_has_record(xcur, bno,
+				irec->br_blockcount, &is_freesp);
+		if (!err2)
+			XFS_BTREC_SCRUB_CHECK(&info->bs, !is_freesp);
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
 	}
 
-out:
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
+out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
-	if (!error && err2)
-		error = err2;
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
