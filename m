Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFB8E7F93
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:42:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 73E46AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:40 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id EsfjGDMEMZYUmPCf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:38 -0700 (PDT)
Subject: [PATCH 21/25] xfs: cross-reference inode btrees during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:42:33 -0700
Message-ID: <147216855295.3108.5148111072976994293.stgit@birch.djwong.org>
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

Cross-reference the inode btrees with the other metadata when we
scrub the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |   58 ++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |    4 +
 fs/xfs/xfs_scrub.c         |  205 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 267 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ab05f63..d6521fd 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2665,3 +2665,61 @@ xfs_ialloc_pagi_init(
 		xfs_trans_brelse(tp, bp);
 	return 0;
 }
+
+/* Is there an inode record covering a given range of inode numbers? */
+int
+xfs_ialloc_has_inode_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agino_t		low,
+	xfs_agino_t		high,
+	bool			*exists)
+{
+	struct xfs_inobt_rec_incore	irec;
+	xfs_agino_t		agino;
+	__uint16_t		holemask;
+	int			has;
+	int			i;
+	int			error;
+
+	*exists = false;
+	error = xfs_inobt_lookup(cur, low, XFS_LOOKUP_LE, &has);
+	while (error == 0 && has) {
+		error = xfs_inobt_get_rec(cur, &irec, &has);
+		if (error || irec.ir_startino > high)
+			break;
+
+		agino = irec.ir_startino;
+		holemask = irec.ir_holemask;
+		for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; holemask >>= 1,
+				i++, agino += XFS_INODES_PER_HOLEMASK_BIT) {
+			if (holemask & 1)
+				continue;
+			if (agino + XFS_INODES_PER_HOLEMASK_BIT > low &&
+					agino <= high) {
+				*exists = true;
+				goto out;
+			}
+		}
+
+		error = xfs_btree_increment(cur, 0, &has);
+	}
+out:
+	return error;
+}
+
+/* Is there an inode record covering a given extent? */
+int
+xfs_ialloc_has_inodes_at_extent(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*exists)
+{
+	xfs_agino_t		low;
+	xfs_agino_t		high;
+
+	low = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno, 0);
+	high = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno + len, 0) - 1;
+
+	return xfs_ialloc_has_inode_record(cur, low, high, exists);
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 8e5861d..f20d958 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -171,5 +171,9 @@ int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 union xfs_btree_rec;
 void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
+int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
+		xfs_agino_t high, bool *exists);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 63a7434..cc85584 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -814,6 +814,7 @@ xfs_scrub_sb(
 	struct xfs_sb			sb;
 	xfs_agnumber_t			agno;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error;
 	int				err2;
 
@@ -888,6 +889,26 @@ btree_xref:
 		XFS_SCRUB_CHECK(mp, bp, "superblock", !is_freesp);
 	xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 
+	/* Cross-reference with inobt. */
+	xcur = xfs_inobt_init_cursor(mp, NULL, agi_bp, agno, XFS_BTNUM_INO);
+	err2 = xfs_ialloc_has_inodes_at_extent(xcur, XFS_SB_BLOCK(mp), 1,
+			&has_inodes);
+	if (!err2)
+		XFS_SCRUB_CHECK(mp, bp, "superblock", !has_inodes);
+	xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
+	/* Cross-reference with finobt. */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		xcur = xfs_inobt_init_cursor(mp, NULL, agi_bp, agno,
+				XFS_BTNUM_FINO);
+		err2 = xfs_ialloc_has_inodes_at_extent(xcur, XFS_SB_BLOCK(mp),
+				1, &has_inodes);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, bp, "superblock", !has_inodes);
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+	}
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 out:
 	xfs_buf_relse(bp);
@@ -911,6 +932,7 @@ xfs_scrub_agf(
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			eofs;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error;
 	int				err2;
 
@@ -976,6 +998,26 @@ xfs_scrub_agf(
 		XFS_SCRUB_CHECK(mp, agf_bp, "AGF", !is_freesp);
 	xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 
+	/* Cross-reference with inobt. */
+	xcur = xfs_inobt_init_cursor(mp, NULL, agi_bp, agno, XFS_BTNUM_INO);
+	err2 = xfs_ialloc_has_inodes_at_extent(xcur, XFS_AGF_BLOCK(mp), 1,
+			&has_inodes);
+	if (!err2)
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF", !has_inodes);
+	xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
+	/* Cross-reference with finobt. */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		xcur = xfs_inobt_init_cursor(mp, NULL, agi_bp, agno,
+				XFS_BTNUM_FINO);
+		err2 = xfs_ialloc_has_inodes_at_extent(xcur, XFS_AGF_BLOCK(mp),
+				1, &has_inodes);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, agf_bp, "AGF", !has_inodes);
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+	}
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 	return error;
 }
@@ -993,11 +1035,14 @@ xfs_scrub_agfl(
 	struct xfs_buf			*agfl_bp;
 	__be32				*agfl_bno;
 	struct xfs_btree_cur		*xcur = NULL;
+	struct xfs_btree_cur		*icur = NULL;
+	struct xfs_btree_cur		*fcur = NULL;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	xfs_agblock_t			eoag;
 	xfs_daddr_t			eofs;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				i;
 	int				error;
 	int				err2;
@@ -1025,6 +1070,23 @@ xfs_scrub_agfl(
 	if (!err2)
 		XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", !is_freesp);
 
+	/* Cross-reference with inobt. */
+	icur = xfs_inobt_init_cursor(mp, NULL, agi_bp, agno, XFS_BTNUM_INO);
+	err2 = xfs_ialloc_has_inodes_at_extent(icur, XFS_AGFL_BLOCK(mp), 1,
+			&has_inodes);
+	if (!err2)
+		XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", !has_inodes);
+
+	/* Cross-reference with finobt. */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		fcur = xfs_inobt_init_cursor(mp, NULL, agi_bp, agno,
+				XFS_BTNUM_FINO);
+		err2 = xfs_ialloc_has_inodes_at_extent(fcur, XFS_AGFL_BLOCK(mp),
+				1, &has_inodes);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", !has_inodes);
+	}
+
 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
 	for (i = be32_to_cpu(agf->agf_flfirst);
 	     i <= be32_to_cpu(agf->agf_fllast);
@@ -1045,8 +1107,26 @@ xfs_scrub_agfl(
 		err2 = xfs_alloc_has_record(xcur, agbno, 1, &is_freesp);
 		if (!err2)
 			XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", !is_freesp);
+
+		/* Cross-reference with inobt. */
+		err2 = xfs_ialloc_has_inodes_at_extent(icur, agbno, 1,
+				&has_inodes);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", !has_inodes);
+
+		/* Cross-reference with finobt. */
+		if (fcur) {
+			err2 = xfs_ialloc_has_inodes_at_extent(fcur, agbno, 1,
+					&has_inodes);
+			if (!err2)
+				XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL",
+						!has_inodes);
+		}
 	}
 
+	if (fcur)
+		xfs_btree_del_cursor(fcur, XFS_BTREE_ERROR);
+	xfs_btree_del_cursor(icur, XFS_BTREE_ERROR);
 	xfs_btree_del_cursor(xcur, XFS_BTREE_ERROR);
 	xfs_buf_relse(agfl_bp);
 err_no_agfl:
@@ -1072,6 +1152,7 @@ xfs_scrub_agi(
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			eofs;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error;
 	int				err2;
 
@@ -1110,6 +1191,26 @@ xfs_scrub_agi(
 		XFS_SCRUB_CHECK(mp, agi_bp, "AGI", !is_freesp);
 	xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 
+	/* Cross-reference with inobt. */
+	xcur = xfs_inobt_init_cursor(mp, NULL, agi_bp, agno, XFS_BTNUM_INO);
+	err2 = xfs_ialloc_has_inodes_at_extent(xcur, XFS_AGI_BLOCK(mp), 1,
+			&has_inodes);
+	if (!err2)
+		XFS_SCRUB_CHECK(mp, agi_bp, "AGI", !has_inodes);
+	xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
+	/* Cross-reference with finobt. */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		xcur = xfs_inobt_init_cursor(mp, NULL, agi_bp, agno,
+				XFS_BTNUM_FINO);
+		err2 = xfs_ialloc_has_inodes_at_extent(xcur, XFS_AGI_BLOCK(mp),
+				1, &has_inodes);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, agi_bp, "AGI", !has_inodes);
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+	}
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 	return error;
 }
@@ -1129,6 +1230,7 @@ xfs_scrub_allocbt_helper(
 	xfs_agblock_t			bno;
 	xfs_extlen_t			flen;
 	xfs_extlen_t			len;
+	bool				has_inodes;
 	int				has_otherrec;
 	int				error = 0;
 	int				err2;
@@ -1168,6 +1270,20 @@ xfs_scrub_allocbt_helper(
 	}
 skip_freesp_xref:
 
+	/* Cross-reference with inobt. */
+	err2 = xfs_ialloc_has_inodes_at_extent(bs->ino_cur, bno, len,
+			&has_inodes);
+	if (!err2)
+		XFS_BTREC_SCRUB_CHECK(bs, !has_inodes);
+
+	/* Cross-reference with finobt. */
+	if (bs->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(bs->fino_cur, bno, len,
+				&has_inodes);
+		if (!err2)
+			XFS_BTREC_SCRUB_CHECK(bs, !has_inodes);
+	}
+
 	return error;
 }
 
@@ -1230,6 +1346,7 @@ xfs_scrub_iallocbt_helper(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
+	struct xfs_btree_cur		*other_cur;
 	struct xfs_inobt_rec_incore	irec;
 	__uint16_t			holemask;
 	xfs_agino_t			agino;
@@ -1237,6 +1354,7 @@ xfs_scrub_iallocbt_helper(
 	xfs_agblock_t			eoag;
 	xfs_extlen_t			len;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				holecount;
 	int				i;
 	int				error = 0;
@@ -1275,6 +1393,18 @@ xfs_scrub_iallocbt_helper(
 		if (!err2)
 			XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
 
+		/* If we have a finobt, cross-reference with it. */
+		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+			other_cur = bs->fino_cur ? bs->fino_cur : bs->ino_cur;
+			if (bs->cur->bc_btnum == XFS_BTNUM_FINO ||
+					irec.ir_freecount) {
+				err2 = xfs_ialloc_has_inode_record(other_cur,
+						agino, agino, &has_inodes);
+				if (!err2)
+					XFS_BTREC_SCRUB_CHECK(bs, has_inodes);
+			}
+		}
+
 		goto out;
 	}
 
@@ -1312,6 +1442,18 @@ xfs_scrub_iallocbt_helper(
 				&is_freesp);
 		if (!err2)
 			XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
+
+		/* If we have a finobt, cross-reference with it. */
+		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+			other_cur = bs->fino_cur ? bs->fino_cur : bs->ino_cur;
+			if (bs->cur->bc_btnum == XFS_BTNUM_FINO ||
+					irec.ir_freecount) {
+				err2 = xfs_ialloc_has_inode_record(other_cur,
+						agino, agino, &has_inodes);
+				if (!err2)
+					XFS_BTREC_SCRUB_CHECK(bs, has_inodes);
+			}
+		}
 	}
 
 	XFS_BTREC_SCRUB_CHECK(bs, holecount <= XFS_INODES_PER_CHUNK);
@@ -1388,6 +1530,7 @@ xfs_scrub_rmapbt_helper(
 	bool				is_unwritten;
 	bool				is_bmbt;
 	bool				is_attr;
+	bool				has_inodes;
 	int				error = 0;
 	int				err2;
 
@@ -1429,6 +1572,25 @@ xfs_scrub_rmapbt_helper(
 	if (!err2)
 		XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
 
+	/* Cross-reference with inobt. */
+	err2 = xfs_ialloc_has_inodes_at_extent(bs->ino_cur, irec.rm_startblock,
+			irec.rm_blockcount, &has_inodes);
+	if (!err2)
+		XFS_BTREC_SCRUB_CHECK(bs,
+				irec.rm_owner == XFS_RMAP_OWN_INODES ||
+				!has_inodes);
+
+	/* Cross-reference with finobt. */
+	if (bs->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(bs->fino_cur,
+				irec.rm_startblock, irec.rm_blockcount,
+				&has_inodes);
+		if (!err2)
+			XFS_BTREC_SCRUB_CHECK(bs,
+					irec.rm_owner == XFS_RMAP_OWN_INODES ||
+					!has_inodes);
+	}
+
 	return error;
 }
 
@@ -1478,6 +1640,7 @@ xfs_scrub_refcountbt_helper(
 	struct xfs_refcount_irec	irec;
 	xfs_agblock_t			eoag;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 	int				err2;
 
@@ -1507,6 +1670,21 @@ xfs_scrub_refcountbt_helper(
 	if (!err2)
 		XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
 
+	/* Cross-reference with inobt. */
+	err2 = xfs_ialloc_has_inodes_at_extent(bs->ino_cur, irec.rc_startblock,
+			irec.rc_blockcount, &has_inodes);
+	if (!err2)
+		XFS_BTREC_SCRUB_CHECK(bs, !has_inodes);
+
+	/* Cross-reference with finobt. */
+	if (bs->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(bs->fino_cur,
+				irec.rc_startblock, irec.rc_blockcount,
+				&has_inodes);
+		if (!err2)
+			XFS_BTREC_SCRUB_CHECK(bs, !has_inodes);
+	}
+
 	return error;
 }
 
@@ -1645,6 +1823,7 @@ xfs_scrub_bmap_extent(
 	xfs_agnumber_t			agno;
 	xfs_fsblock_t			bno;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 	int				err2 = 0;
 
@@ -1702,6 +1881,32 @@ xfs_scrub_bmap_extent(
 			XFS_BTREC_SCRUB_CHECK(&info->bs, !is_freesp);
 		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
 						  XFS_BTREE_NOERROR);
+
+		/* Cross-reference with inobt. */
+		xcur = xfs_inobt_init_cursor(mp, NULL, agi_bp, agno,
+				XFS_BTNUM_INO);
+		err2 = xfs_ialloc_has_inodes_at_extent(xcur,
+				irec->br_startblock, irec->br_blockcount,
+				&has_inodes);
+		if (!err2)
+			XFS_INO_SCRUB_CHECK(ip, bp, info->type, !has_inodes);
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+
+		/* Cross-reference with finobt. */
+		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+			xcur = xfs_inobt_init_cursor(mp, NULL, agi_bp, agno,
+					XFS_BTNUM_FINO);
+			err2 = xfs_ialloc_has_inodes_at_extent(xcur,
+					irec->br_startblock,
+					irec->br_blockcount,
+					&has_inodes);
+			if (!err2)
+				XFS_INO_SCRUB_CHECK(ip, bp, info->type,
+						!has_inodes);
+			xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+							  XFS_BTREE_NOERROR);
+		}
 	}
 
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
