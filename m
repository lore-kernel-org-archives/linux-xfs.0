Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B6DA7FA9
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:42:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1F72A304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:52 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id U3Rk6VFrg7nbn3Sl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:49 -0700 (PDT)
Subject: [PATCH 23/25] xfs: cross-reference refcount btree during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:42:45 -0700
Message-ID: <147216856568.3108.7611118372039280000.stgit@birch.djwong.org>
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

During metadata btree scrub, we should cross-reference with the
reference counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   19 ++++
 fs/xfs/libxfs/xfs_refcount.h |    3 +
 fs/xfs/xfs_scrub.c           |  184 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 206 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 9136745..af82ea3 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1535,3 +1535,22 @@ xfs_refcount_free_cow_extent(
 	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_FREE_COW,
 			fsb, len);
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_refcount_has_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*exists)
+{
+	union xfs_btree_irec	low;
+	union xfs_btree_irec	high;
+
+	memset(&low, 0, sizeof(low));
+	low.rc.rc_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rc.rc_startblock = bno + len - 1;
+
+	return xfs_btree_has_record(cur, &low, &high, exists);
+}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 105c246..a00400f 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -64,4 +64,7 @@ extern int xfs_refcount_free_cow_extent(struct xfs_mount *mp,
 		struct xfs_defer_ops *dfops, xfs_fsblock_t fsb,
 		xfs_extlen_t len);
 
+extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+
 #endif	/* __XFS_REFCOUNT_H__ */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 34c23f7..ff55d8c 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -867,6 +867,7 @@ xfs_scrub_sb(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				error;
 	int				err2;
 
@@ -973,6 +974,17 @@ btree_xref:
 						  XFS_BTREE_NOERROR);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		xcur = xfs_refcountbt_init_cursor(mp, NULL, agf_bp, agno, NULL);
+		err2 = xfs_refcount_has_record(xcur, XFS_SB_BLOCK(mp), 1,
+				&has_refcount);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, bp, "superblock", !has_refcount);
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+	}
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 out:
 	xfs_buf_relse(bp);
@@ -1000,6 +1012,7 @@ xfs_scrub_agf(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				error;
 	int				err2;
 
@@ -1103,6 +1116,23 @@ skip_rmap_xref:
 						  XFS_BTREE_NOERROR);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		xcur = xfs_refcountbt_init_cursor(mp, NULL, agf_bp, agno, NULL);
+		err2 = xfs_refcount_has_record(xcur, XFS_AGF_BLOCK(mp), 1,
+				&has_refcount);
+		if (err2)
+			goto skip_refc_xref;
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF", !has_refcount);
+		err2 = xfs_btree_count_blocks(xcur, &blocks);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, agf_bp, "AGF", blocks ==
+					be32_to_cpu(agf->agf_refcount_blocks));
+skip_refc_xref:
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+	}
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 	return error;
 }
@@ -1123,6 +1153,7 @@ xfs_scrub_agfl(
 	struct xfs_btree_cur		*icur = NULL;
 	struct xfs_btree_cur		*fcur = NULL;
 	struct xfs_btree_cur		*rcur = NULL;
+	struct xfs_btree_cur		*ccur = NULL;
 	struct xfs_owner_info		oinfo;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
@@ -1131,6 +1162,7 @@ xfs_scrub_agfl(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				i;
 	int				error;
 	int				err2;
@@ -1185,6 +1217,15 @@ xfs_scrub_agfl(
 			XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", has_rmap);
 	}
 
+	/* Set up cross-reference with refcountbt. */
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		ccur = xfs_refcountbt_init_cursor(mp, NULL, agf_bp, agno, NULL);
+		err2 = xfs_refcount_has_record(ccur, XFS_AGFL_BLOCK(mp), 1,
+				&has_refcount);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", !has_refcount);
+	}
+
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
 	for (i = be32_to_cpu(agf->agf_flfirst);
@@ -1229,8 +1270,19 @@ xfs_scrub_agfl(
 			if (!err2)
 				XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", has_rmap);
 		}
+
+		/* Cross-reference with the refcountbt. */
+		if (ccur) {
+			err2 = xfs_refcount_has_record(ccur, agbno, 1,
+					&has_refcount);
+			if (!err2)
+				XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL",
+						!has_refcount);
+		}
 	}
 
+	if (ccur)
+		xfs_btree_del_cursor(ccur, XFS_BTREE_ERROR);
 	if (rcur)
 		xfs_btree_del_cursor(rcur, XFS_BTREE_ERROR);
 	if (fcur)
@@ -1264,6 +1316,7 @@ xfs_scrub_agi(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				error;
 	int				err2;
 
@@ -1334,6 +1387,17 @@ xfs_scrub_agi(
 						  XFS_BTREE_NOERROR);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		xcur = xfs_refcountbt_init_cursor(mp, NULL, agf_bp, agno, NULL);
+		err2 = xfs_refcount_has_record(xcur, XFS_AGI_BLOCK(mp), 1,
+				&has_refcount);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, agi_bp, "AGI", !has_refcount);
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+	}
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 	return error;
 }
@@ -1355,6 +1419,7 @@ xfs_scrub_allocbt_helper(
 	xfs_extlen_t			len;
 	bool				has_rmap;
 	bool				has_inodes;
+	bool				has_refcount;
 	int				has_otherrec;
 	int				error = 0;
 	int				err2;
@@ -1415,6 +1480,14 @@ skip_freesp_xref:
 			XFS_BTREC_SCRUB_CHECK(bs, !has_rmap);
 	}
 
+	/* Cross-reference with the refcountbt. */
+	if (bs->refc_cur) {
+		err2 = xfs_refcount_has_record(bs->refc_cur, bno, len,
+				&has_refcount);
+		if (!err2)
+			XFS_BTREC_SCRUB_CHECK(bs, !has_refcount);
+	}
+
 	return error;
 }
 
@@ -1488,6 +1561,7 @@ xfs_scrub_iallocbt_helper(
 	bool				is_freesp;
 	bool				has_inodes;
 	bool				has_rmap;
+	bool				has_refcount;
 	int				holecount;
 	int				i;
 	int				error = 0;
@@ -1547,6 +1621,14 @@ xfs_scrub_iallocbt_helper(
 				XFS_BTREC_SCRUB_CHECK(bs, has_rmap);
 		}
 
+		/* Cross-reference with the refcountbt. */
+		if (bs->refc_cur) {
+			err2 = xfs_refcount_has_record(bs->refc_cur, bno,
+					len, &has_refcount);
+			if (!err2)
+				XFS_BTREC_SCRUB_CHECK(bs, !has_refcount);
+		}
+
 		goto out;
 	}
 
@@ -1604,6 +1686,14 @@ xfs_scrub_iallocbt_helper(
 			if (!err2)
 				XFS_BTREC_SCRUB_CHECK(bs, has_rmap);
 		}
+
+		/* Cross-reference with the refcountbt. */
+		if (bs->refc_cur) {
+			err2 = xfs_refcount_has_record(bs->refc_cur, bno,
+					len, &has_refcount);
+			if (!err2)
+				XFS_BTREC_SCRUB_CHECK(bs, !has_refcount);
+		}
 	}
 
 	XFS_BTREC_SCRUB_CHECK(bs, holecount <= XFS_INODES_PER_CHUNK);
@@ -1674,13 +1764,17 @@ xfs_scrub_rmapbt_helper(
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
 	struct xfs_rmap_irec		irec;
+	struct xfs_refcount_irec	crec;
 	xfs_agblock_t			eoag;
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
 	bool				is_freesp;
 	bool				non_inode;
 	bool				is_unwritten;
 	bool				is_bmbt;
 	bool				is_attr;
 	bool				has_inodes;
+	int				has_refcount;
 	int				error = 0;
 	int				err2;
 
@@ -1741,6 +1835,45 @@ xfs_scrub_rmapbt_helper(
 					!has_inodes);
 	}
 
+	/* Cross-reference with the refcount btree. */
+	if (bs->refc_cur) {
+		if (irec.rm_owner == XFS_RMAP_OWN_COW) {
+			/* Check this CoW staging extent. */
+			err2 = xfs_refcount_lookup_le(bs->refc_cur,
+					irec.rm_startblock, &has_refcount);
+			if (err2)
+				goto skip_refc_xref;
+			XFS_BTREC_SCRUB_GOTO(bs, has_refcount, skip_refc_xref);
+
+			err2 = xfs_refcount_get_rec(bs->refc_cur, &crec,
+					&has_refcount);
+			if (err2)
+				goto skip_refc_xref;
+			XFS_BTREC_SCRUB_GOTO(bs, has_refcount, skip_refc_xref);
+			XFS_BTREC_SCRUB_CHECK(bs, crec.rc_startblock <=
+					irec.rm_startblock);
+			XFS_BTREC_SCRUB_CHECK(bs, crec.rc_startblock +
+					crec.rc_blockcount >
+					crec.rc_startblock);
+			XFS_BTREC_SCRUB_CHECK(bs, crec.rc_startblock +
+					crec.rc_blockcount >=
+					irec.rm_startblock +
+					irec.rm_blockcount);
+			XFS_BTREC_SCRUB_CHECK(bs,
+					crec.rc_refcount == 1);
+		} else {
+			/* If this is shared, the inode flag must be set. */
+			err2 = xfs_refcount_find_shared(bs->refc_cur,
+					irec.rm_startblock, irec.rm_blockcount,
+					&fbno, &flen, false);
+			if (!err2)
+				XFS_BTREC_SCRUB_CHECK(bs, flen == 0 ||
+						(!non_inode && !is_attr &&
+						 !is_bmbt && !is_unwritten));
+		}
+skip_refc_xref:;
+	}
+
 	return error;
 }
 
@@ -2164,12 +2297,16 @@ xfs_scrub_bmap_extent(
 	xfs_agnumber_t			agno;
 	xfs_fsblock_t			bno;
 	struct xfs_rmap_irec		rmap;
+	struct xfs_refcount_irec	crec;
 	uint64_t			owner;
 	xfs_fileoff_t			offset;
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
 	bool				is_freesp;
 	bool				has_inodes;
 	unsigned int			rflags;
 	int				has_rmap;
+	int				has_refcount;
 	int				error = 0;
 	int				err2 = 0;
 
@@ -2348,6 +2485,53 @@ skip_rmap_xref:
 						  XFS_BTREE_NOERROR);
 	}
 
+	/*
+	 * If this is a non-shared file on a reflink filesystem,
+	 * check the refcountbt to see if the flag is wrong.
+	 */
+	if (xfs_sb_version_hasreflink(&mp->m_sb) && !info->is_rt) {
+		xcur = xfs_refcountbt_init_cursor(mp, NULL, agf_bp, agno, NULL);
+
+		if (info->whichfork == XFS_COW_FORK) {
+			/* Check this CoW staging extent. */
+			err2 = xfs_refcount_lookup_le(xcur, bno, &has_refcount);
+			if (err2)
+				goto skip_refc_xref;
+			XFS_INO_SCRUB_GOTO(ip, NULL, info->type, has_refcount,
+					skip_refc_xref);
+
+			err2 = xfs_refcount_get_rec(xcur, &crec, &has_refcount);
+			if (err2)
+				goto skip_refc_xref;
+			XFS_INO_SCRUB_GOTO(ip, NULL, info->type, has_refcount,
+					skip_refc_xref);
+
+			XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+					crec.rc_startblock <= bno);
+			XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+					crec.rc_startblock +
+					crec.rc_blockcount >
+					crec.rc_startblock);
+			XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+					crec.rc_startblock +
+					crec.rc_blockcount >=
+					bno + irec->br_blockcount);
+			XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+					crec.rc_refcount == 1);
+		} else {
+			/* If this is shared, the inode flag must be set. */
+			err2 = xfs_refcount_find_shared(xcur, bno,
+					irec->br_blockcount, &fbno, &flen,
+					false);
+			if (!err2)
+				XFS_INO_SCRUB_CHECK(ip, bp, info->type,
+						flen == 0 ||
+						xfs_is_reflink_inode(ip));
+		}
+skip_refc_xref:
+		xfs_btree_del_cursor(xcur, XFS_BTREE_NOERROR);
+	}
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
