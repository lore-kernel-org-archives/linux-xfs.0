Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D7D4B7F9C
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:42:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C9E58F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:47 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 9xsNJtXuaKvWbInp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:42:43 -0700 (PDT)
Subject: [PATCH 22/25] xfs: cross-reference reverse-mapping btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:42:39 -0700
Message-ID: <147216855926.3108.17144534581470868653.stgit@birch.djwong.org>
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

When scrubbing various btrees, we should cross-reference the records
with the reverse mapping btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   58 ++++++
 fs/xfs/libxfs/xfs_rmap.h |    5 +
 fs/xfs/xfs_scrub.c       |  441 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 503 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index b0308fc..b22f93d 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2292,3 +2292,61 @@ xfs_rmap_free_extent(
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_FREE, owner,
 			XFS_DATA_FORK, &bmap);
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_rmap_has_record(
+	struct xfs_btree_cur	*cur,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
+	bool			*exists)
+{
+	union xfs_btree_irec	low;
+	union xfs_btree_irec	high;
+
+	memset(&low, 0, sizeof(low));
+	low.r.rm_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.r.rm_startblock = bno + len - 1;
+
+	return xfs_btree_has_record(cur, &low, &high, exists);
+}
+
+/* Is there a record covering a given extent? */
+int
+xfs_rmap_record_exists(
+	struct xfs_btree_cur	*cur,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
+	struct xfs_owner_info	*oinfo,
+	bool			*has_rmap)
+{
+	uint64_t		owner;
+	uint64_t		offset;
+	unsigned int		flags;
+	int			stat;
+	struct xfs_rmap_irec	irec;
+	int			error;
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
+
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*has_rmap = false;
+		return 0;
+	}
+
+	error = xfs_rmap_get_rec(cur, &irec, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*has_rmap = false;
+		return 0;
+	}
+
+	*has_rmap = (irec.rm_startblock <= bno &&
+		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 188db38..c5c5817 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -215,5 +215,10 @@ int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 union xfs_btree_rec;
 int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
+int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, bool *exists);
+int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, struct xfs_owner_info *oinfo,
+		bool *has_rmap);
 
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index cc85584..34c23f7 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -393,6 +393,11 @@ xfs_scrub_btree_key(
 	return 0;
 }
 
+struct check_owner {
+	struct list_head	list;
+	xfs_fsblock_t		bno;
+};
+
 /*
  * For scrub, grab the AGI and the AGF headers, in that order.
  * Locking order requires us to get the AGI before the AGF.
@@ -550,8 +555,10 @@ xfs_scrub_btree_check_block_owner(
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			bno;
 	bool				is_freesp;
+	bool				has_rmap;
 	struct xfs_buf			*agf_bp = NULL;
 	struct xfs_btree_cur		*bcur = NULL;
+	struct xfs_btree_cur		*rcur = NULL;
 	int				error = 0;
 	int				err2;
 
@@ -565,8 +572,12 @@ xfs_scrub_btree_check_block_owner(
 			return error;
 		bcur = xfs_allocbt_init_cursor(bs->cur->bc_mp, NULL,
 				agf_bp, agno, XFS_BTNUM_BNO);
+		if (xfs_sb_version_hasrmapbt(&bs->cur->bc_mp->m_sb))
+			rcur = xfs_rmapbt_init_cursor(bs->cur->bc_mp, NULL,
+					agf_bp, agno);
 	} else {
 		bcur = bs->bno_cur;
+		rcur = bs->rmap_cur;
 	}
 
 	/* Check that this block isn't free. */
@@ -574,7 +585,17 @@ xfs_scrub_btree_check_block_owner(
 	if (!err2)
 		XFS_BTREC_SCRUB_CHECK(bs, !is_freesp);
 
+	/* Check that this block is in the rmap. */
+	if (rcur) {
+		err2 = xfs_rmap_record_exists(rcur, bno, 1, &bs->oinfo,
+				&has_rmap);
+		if (!err2)
+			XFS_BTREC_SCRUB_CHECK(bs, has_rmap);
+	}
+
 	if (agf_bp) {
+		if (rcur)
+			xfs_btree_del_cursor(rcur, XFS_BTREE_ERROR);
 		xfs_btree_del_cursor(bcur, XFS_BTREE_ERROR);
 		xfs_buf_relse(agf_bp);
 	}
@@ -589,6 +610,7 @@ xfs_scrub_btree_check_owner(
 	struct xfs_buf			*bp)
 {
 	struct xfs_btree_cur		*cur = bs->cur;
+	struct check_owner		*co;
 	xfs_fsblock_t			fsbno;
 
 	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) && bp == NULL)
@@ -596,6 +618,15 @@ xfs_scrub_btree_check_owner(
 
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
 
+	/* Do we need to defer this one? */
+	if ((!bs->rmap_cur && xfs_sb_version_hasrmapbt(&cur->bc_mp->m_sb)) ||
+	    !bs->bno_cur) {
+		co = kmem_alloc(sizeof(struct check_owner), KM_SLEEP | KM_NOFS);
+		co->bno = fsbno;
+		list_add_tail(&co->list, &bs->to_check);
+		return 0;
+	}
+
 	return xfs_scrub_btree_check_block_owner(bs, fsbno);
 }
 
@@ -617,6 +648,8 @@ xfs_scrub_btree(
 	struct xfs_btree_block		*block;
 	int				level;
 	struct xfs_buf			*bp;
+	struct check_owner		*co;
+	struct check_owner		*n;
 	int				i;
 	int				error = 0;
 
@@ -778,6 +811,23 @@ out:
 		}
 	}
 
+	/* Process deferred rmap owner checks on btree blocks. */
+	if (!error) {
+		if (bs->cur->bc_btnum == XFS_BTNUM_BNO)
+			bs->bno_cur = bs->cur;
+		else if (bs->cur->bc_btnum == XFS_BTNUM_RMAP)
+			bs->rmap_cur = bs->cur;
+		list_for_each_entry(co, &bs->to_check, list) {
+			error = xfs_scrub_btree_check_block_owner(bs, co->bno);
+			if (error)
+				break;
+		}
+	}
+	list_for_each_entry_safe(co, n, &bs->to_check, list) {
+		list_del(&co->list);
+		kmem_free(co);
+	}
+
 	if (bs->refc_cur)
 		xfs_btree_del_cursor(bs->refc_cur, XFS_BTREE_ERROR);
 	if (bs->rmap_cur && bs->rmap_cur != bs->cur)
@@ -812,9 +862,11 @@ xfs_scrub_sb(
 	struct xfs_buf			*agf_bp = NULL;
 	struct xfs_btree_cur		*xcur = NULL;
 	struct xfs_sb			sb;
+	struct xfs_owner_info		oinfo;
 	xfs_agnumber_t			agno;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				error;
 	int				err2;
 
@@ -909,6 +961,18 @@ btree_xref:
 						  XFS_BTREE_NOERROR);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+		xcur = xfs_rmapbt_init_cursor(mp, NULL, agf_bp, agno);
+		err2 = xfs_rmap_record_exists(xcur, XFS_SB_BLOCK(mp), 1,
+				&oinfo, &has_rmap);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, bp, "superblock", has_rmap);
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+	}
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 out:
 	xfs_buf_relse(bp);
@@ -926,13 +990,16 @@ xfs_scrub_agf(
 	struct xfs_buf			*agi_bp = NULL;
 	struct xfs_buf			*agf_bp = NULL;
 	struct xfs_btree_cur		*xcur = NULL;
+	struct xfs_owner_info		oinfo;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	xfs_agblock_t			eoag;
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			eofs;
+	xfs_extlen_t			blocks;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				error;
 	int				err2;
 
@@ -1018,6 +1085,24 @@ xfs_scrub_agf(
 						  XFS_BTREE_NOERROR);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+		xcur = xfs_rmapbt_init_cursor(mp, NULL, agf_bp, agno);
+		err2 = xfs_rmap_record_exists(xcur, XFS_AGF_BLOCK(mp), 1,
+				&oinfo, &has_rmap);
+		if (err2)
+			goto skip_rmap_xref;
+		XFS_SCRUB_CHECK(mp, agf_bp, "AGF", has_rmap);
+		err2 = xfs_btree_count_blocks(xcur, &blocks);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, agf_bp, "AGF", blocks ==
+					be32_to_cpu(agf->agf_rmap_blocks));
+skip_rmap_xref:
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+	}
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 	return error;
 }
@@ -1037,12 +1122,15 @@ xfs_scrub_agfl(
 	struct xfs_btree_cur		*xcur = NULL;
 	struct xfs_btree_cur		*icur = NULL;
 	struct xfs_btree_cur		*fcur = NULL;
+	struct xfs_btree_cur		*rcur = NULL;
+	struct xfs_owner_info		oinfo;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	xfs_agblock_t			eoag;
 	xfs_daddr_t			eofs;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				i;
 	int				error;
 	int				err2;
@@ -1087,6 +1175,17 @@ xfs_scrub_agfl(
 			XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", !has_inodes);
 	}
 
+	/* Set up cross-reference with rmapbt. */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		rcur = xfs_rmapbt_init_cursor(mp, NULL, agf_bp, agno);
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+		err2 = xfs_rmap_record_exists(rcur, XFS_AGFL_BLOCK(mp), 1,
+				&oinfo, &has_rmap);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", has_rmap);
+	}
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
 	for (i = be32_to_cpu(agf->agf_flfirst);
 	     i <= be32_to_cpu(agf->agf_fllast);
@@ -1122,8 +1221,18 @@ xfs_scrub_agfl(
 				XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL",
 						!has_inodes);
 		}
+
+		/* Cross-reference with the rmapbt. */
+		if (rcur) {
+			err2 = xfs_rmap_record_exists(rcur, agbno, 1, &oinfo,
+					&has_rmap);
+			if (!err2)
+				XFS_SCRUB_CHECK(mp, agfl_bp, "AGFL", has_rmap);
+		}
 	}
 
+	if (rcur)
+		xfs_btree_del_cursor(rcur, XFS_BTREE_ERROR);
 	if (fcur)
 		xfs_btree_del_cursor(fcur, XFS_BTREE_ERROR);
 	xfs_btree_del_cursor(icur, XFS_BTREE_ERROR);
@@ -1146,6 +1255,7 @@ xfs_scrub_agi(
 	struct xfs_buf			*agi_bp = NULL;
 	struct xfs_buf			*agf_bp = NULL;
 	struct xfs_btree_cur		*xcur = NULL;
+	struct xfs_owner_info		oinfo;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			agbno;
 	xfs_agblock_t			eoag;
@@ -1153,6 +1263,7 @@ xfs_scrub_agi(
 	xfs_daddr_t			eofs;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				error;
 	int				err2;
 
@@ -1211,6 +1322,18 @@ xfs_scrub_agi(
 						  XFS_BTREE_NOERROR);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+		xcur = xfs_rmapbt_init_cursor(mp, NULL, agf_bp, agno);
+		err2 = xfs_rmap_record_exists(xcur, XFS_AGI_BLOCK(mp), 1,
+				&oinfo, &has_rmap);
+		if (!err2)
+			XFS_SCRUB_CHECK(mp, agi_bp, "AGI", has_rmap);
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+	}
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 	return error;
 }
@@ -1230,6 +1353,7 @@ xfs_scrub_allocbt_helper(
 	xfs_agblock_t			bno;
 	xfs_extlen_t			flen;
 	xfs_extlen_t			len;
+	bool				has_rmap;
 	bool				has_inodes;
 	int				has_otherrec;
 	int				error = 0;
@@ -1284,6 +1408,13 @@ skip_freesp_xref:
 			XFS_BTREC_SCRUB_CHECK(bs, !has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (bs->rmap_cur) {
+		err2 = xfs_rmap_has_record(bs->rmap_cur, bno, len, &has_rmap);
+		if (!err2)
+			XFS_BTREC_SCRUB_CHECK(bs, !has_rmap);
+	}
+
 	return error;
 }
 
@@ -1348,6 +1479,7 @@ xfs_scrub_iallocbt_helper(
 	struct xfs_agf			*agf;
 	struct xfs_btree_cur		*other_cur;
 	struct xfs_inobt_rec_incore	irec;
+	struct xfs_owner_info		oinfo;
 	__uint16_t			holemask;
 	xfs_agino_t			agino;
 	xfs_agblock_t			bno;
@@ -1355,10 +1487,11 @@ xfs_scrub_iallocbt_helper(
 	xfs_extlen_t			len;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				holecount;
 	int				i;
 	int				error = 0;
-	int				err2;
+	int				err2 = 0;
 	uint64_t			holes;
 
 	xfs_inobt_btrec_to_irec(mp, rec, &irec);
@@ -1368,6 +1501,7 @@ xfs_scrub_iallocbt_helper(
 	agino = irec.ir_startino;
 	agf = XFS_BUF_TO_AGF(bs->agf_bp);
 	eoag = be32_to_cpu(agf->agf_length);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 
 	/* Handle non-sparse inodes */
 	if (!xfs_inobt_issparse(irec.ir_holemask)) {
@@ -1405,6 +1539,14 @@ xfs_scrub_iallocbt_helper(
 			}
 		}
 
+		/* Cross-reference with rmapbt. */
+		if (bs->rmap_cur) {
+			err2 = xfs_rmap_record_exists(bs->rmap_cur, bno, len,
+					&oinfo, &has_rmap);
+			if (!err2)
+				XFS_BTREC_SCRUB_CHECK(bs, has_rmap);
+		}
+
 		goto out;
 	}
 
@@ -1454,6 +1596,14 @@ xfs_scrub_iallocbt_helper(
 					XFS_BTREC_SCRUB_CHECK(bs, has_inodes);
 			}
 		}
+
+		/* Cross-reference with the rmapbt. */
+		if (bs->rmap_cur) {
+			err2 = xfs_rmap_record_exists(bs->rmap_cur, bno, len,
+					&oinfo, &has_rmap);
+			if (!err2)
+				XFS_BTREC_SCRUB_CHECK(bs, has_rmap);
+		}
 	}
 
 	XFS_BTREC_SCRUB_CHECK(bs, holecount <= XFS_INODES_PER_CHUNK);
@@ -1629,6 +1779,165 @@ xfs_scrub_rmapbt(
 
 /* Reference count btree scrubber. */
 
+struct xfs_refcountbt_scrub_fragment {
+	struct xfs_rmap_irec		rm;
+	struct list_head		list;
+};
+
+struct xfs_refcountbt_scrub_rmap_check_info {
+	struct xfs_scrub_btree		*bs;
+	xfs_nlink_t			nr;
+	struct xfs_refcount_irec	rc;
+	struct list_head		fragments;
+};
+
+/*
+ * Decide if the given rmap is large enough that we can redeem it
+ * towards refcount verification now, or if it's a fragment, in
+ * which case we'll hang onto it in the hopes that we'll later
+ * discover that we've collected exactly the correct number of
+ * fragments as the refcountbt says we should have.
+ */
+STATIC int
+xfs_refcountbt_scrub_rmap_check(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_refcountbt_scrub_rmap_check_info	*rsrci = priv;
+	struct xfs_refcountbt_scrub_fragment		*frag;
+	xfs_agblock_t			rm_last;
+	xfs_agblock_t			rc_last;
+
+	rm_last = rec->rm_startblock + rec->rm_blockcount;
+	rc_last = rsrci->rc.rc_startblock + rsrci->rc.rc_blockcount;
+	XFS_BTREC_SCRUB_CHECK(rsrci->bs, rsrci->rc.rc_refcount != 1 ||
+			rec->rm_owner == XFS_RMAP_OWN_COW);
+	if (rec->rm_startblock <= rsrci->rc.rc_startblock && rm_last >= rc_last)
+		rsrci->nr++;
+	else {
+		frag = kmem_zalloc(sizeof(struct xfs_refcountbt_scrub_fragment),
+				KM_SLEEP);
+		frag->rm = *rec;
+		list_add_tail(&frag->list, &rsrci->fragments);
+	}
+
+	return 0;
+}
+
+/*
+ * Given a bunch of rmap fragments, iterate through them, keeping
+ * a running tally of the refcount.  If this ever deviates from
+ * what we expect (which is the refcountbt's refcount minus the
+ * number of extents that totally covered the refcountbt extent),
+ * we have a refcountbt error.
+ */
+STATIC void
+xfs_refcountbt_process_rmap_fragments(
+	struct xfs_mount				*mp,
+	struct xfs_refcountbt_scrub_rmap_check_info	*rsrci)
+{
+	struct list_head				worklist;
+	struct xfs_refcountbt_scrub_fragment		*cur;
+	struct xfs_refcountbt_scrub_fragment		*n;
+	xfs_agblock_t					bno;
+	xfs_agblock_t					rbno;
+	xfs_agblock_t					next_rbno;
+	xfs_nlink_t					nr;
+	xfs_nlink_t					target_nr;
+
+	target_nr = rsrci->rc.rc_refcount - rsrci->nr;
+	if (target_nr == 0)
+		return;
+
+	/*
+	 * There are (rsrci->rc.rc_refcount - rsrci->nr refcount)
+	 * references we haven't found yet.  Pull that many off the
+	 * fragment list and figure out where the smallest rmap ends
+	 * (and therefore the next rmap should start).  All the rmaps
+	 * we pull off should start at or before the beginning of the
+	 * refcount record's range.
+	 */
+	INIT_LIST_HEAD(&worklist);
+	rbno = NULLAGBLOCK;
+	nr = 1;
+	list_for_each_entry_safe(cur, n, &rsrci->fragments, list) {
+		if (cur->rm.rm_startblock > rsrci->rc.rc_startblock)
+			goto fail;
+		bno = cur->rm.rm_startblock + cur->rm.rm_blockcount;
+		if (rbno > bno)
+			rbno = bno;
+		list_del(&cur->list);
+		list_add_tail(&cur->list, &worklist);
+		if (nr == target_nr)
+			break;
+		nr++;
+	}
+
+	if (nr != target_nr)
+		goto fail;
+
+	while (!list_empty(&rsrci->fragments)) {
+		/* Discard any fragments ending at rbno. */
+		nr = 0;
+		next_rbno = NULLAGBLOCK;
+		list_for_each_entry_safe(cur, n, &worklist, list) {
+			bno = cur->rm.rm_startblock + cur->rm.rm_blockcount;
+			if (bno != rbno) {
+				if (next_rbno > bno)
+					next_rbno = bno;
+				continue;
+			}
+			list_del(&cur->list);
+			kmem_free(cur);
+			nr++;
+		}
+
+		/* Empty list?  We're done. */
+		if (list_empty(&rsrci->fragments))
+			break;
+
+		/* Try to add nr rmaps starting at rbno to the worklist. */
+		list_for_each_entry_safe(cur, n, &rsrci->fragments, list) {
+			bno = cur->rm.rm_startblock + cur->rm.rm_blockcount;
+			if (cur->rm.rm_startblock != rbno)
+				goto fail;
+			list_del(&cur->list);
+			list_add_tail(&cur->list, &worklist);
+			if (next_rbno > bno)
+				next_rbno = bno;
+			nr--;
+			if (nr == 0)
+				break;
+		}
+
+		rbno = next_rbno;
+	}
+
+	/*
+	 * Make sure the last extent we processed ends at or beyond
+	 * the end of the refcount extent.
+	 */
+	if (rbno < rsrci->rc.rc_startblock + rsrci->rc.rc_blockcount)
+		goto fail;
+
+	rsrci->nr = rsrci->rc.rc_refcount;
+fail:
+	/* Delete fragments and work list. */
+	while (!list_empty(&worklist)) {
+		cur = list_first_entry(&worklist,
+				struct xfs_refcountbt_scrub_fragment, list);
+		list_del(&cur->list);
+		kmem_free(cur);
+	}
+	while (!list_empty(&rsrci->fragments)) {
+		cur = list_first_entry(&rsrci->fragments,
+				struct xfs_refcountbt_scrub_fragment, list);
+		list_del(&cur->list);
+		kmem_free(cur);
+	}
+}
+
 /* Scrub a refcountbt record. */
 STATIC int
 xfs_scrub_refcountbt_helper(
@@ -1638,6 +1947,10 @@ xfs_scrub_refcountbt_helper(
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
 	struct xfs_refcount_irec	irec;
+	struct xfs_rmap_irec		low;
+	struct xfs_rmap_irec		high;
+	struct xfs_refcountbt_scrub_rmap_check_info	rsrci;
+	struct xfs_refcountbt_scrub_fragment		*cur;
 	xfs_agblock_t			eoag;
 	bool				is_freesp;
 	bool				has_inodes;
@@ -1685,6 +1998,34 @@ xfs_scrub_refcountbt_helper(
 			XFS_BTREC_SCRUB_CHECK(bs, !has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt to confirm the refcount. */
+	if (bs->rmap_cur) {
+		memset(&low, 0, sizeof(low));
+		low.rm_startblock = irec.rc_startblock;
+		memset(&high, 0xFF, sizeof(high));
+		high.rm_startblock = irec.rc_startblock +
+				irec.rc_blockcount - 1;
+
+		rsrci.bs = bs;
+		rsrci.nr = 0;
+		rsrci.rc = irec;
+		INIT_LIST_HEAD(&rsrci.fragments);
+		err2 = xfs_rmap_query_range(bs->rmap_cur, &low, &high,
+				&xfs_refcountbt_scrub_rmap_check, &rsrci);
+		if (err2 == 0) {
+			xfs_refcountbt_process_rmap_fragments(mp, &rsrci);
+			XFS_BTREC_SCRUB_CHECK(bs, irec.rc_refcount == rsrci.nr);
+		}
+
+		while (!list_empty(&rsrci.fragments)) {
+			cur = list_first_entry(&rsrci.fragments,
+					struct xfs_refcountbt_scrub_fragment,
+					list);
+			list_del(&cur->list);
+			kmem_free(cur);
+		}
+	}
+
 	return error;
 }
 
@@ -1822,8 +2163,13 @@ xfs_scrub_bmap_extent(
 	xfs_daddr_t			dlen;
 	xfs_agnumber_t			agno;
 	xfs_fsblock_t			bno;
+	struct xfs_rmap_irec		rmap;
+	uint64_t			owner;
+	xfs_fileoff_t			offset;
 	bool				is_freesp;
 	bool				has_inodes;
+	unsigned int			rflags;
+	int				has_rmap;
 	int				error = 0;
 	int				err2 = 0;
 
@@ -1909,6 +2255,99 @@ xfs_scrub_bmap_extent(
 		}
 	}
 
+	/* Cross-reference with rmapbt. */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && !info->is_rt) {
+		xcur = xfs_rmapbt_init_cursor(mp, NULL, agf_bp, agno);
+
+		if (info->whichfork == XFS_COW_FORK) {
+			owner = XFS_RMAP_OWN_COW;
+			offset = 0;
+		} else {
+			owner = ip->i_ino;
+			offset = irec->br_startoff;
+		}
+
+		/* Look for a corresponding rmap. */
+		rflags = 0;
+		if (info->whichfork == XFS_ATTR_FORK)
+			rflags |= XFS_RMAP_ATTR_FORK;
+
+		if (info->is_shared) {
+			err2 = xfs_rmap_lookup_le_range(xcur, bno, owner,
+					offset, rflags, &rmap,
+					&has_rmap);
+			if (err2)
+				goto skip_rmap_xref;
+			XFS_INO_SCRUB_GOTO(ip, NULL, info->type, has_rmap,
+					skip_rmap_xref);
+		} else {
+			err2 = xfs_rmap_lookup_le(xcur, bno, 0, owner,
+					offset, rflags, &has_rmap);
+			if (err2)
+				goto skip_rmap_xref;
+			XFS_INO_SCRUB_GOTO(ip, NULL, info->type, has_rmap,
+					skip_rmap_xref);
+
+			err2 = xfs_rmap_get_rec(xcur, &rmap, &has_rmap);
+			if (err2)
+				goto skip_rmap_xref;
+			XFS_INO_SCRUB_GOTO(ip, NULL, info->type, has_rmap,
+					skip_rmap_xref);
+		}
+
+		/* Check the rmap. */
+		XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+				rmap.rm_startblock <= bno);
+		XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+				rmap.rm_startblock + rmap.rm_blockcount >
+				rmap.rm_startblock);
+		XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+				rmap.rm_startblock + rmap.rm_blockcount >=
+				bno + irec->br_blockcount);
+		if (owner != XFS_RMAP_OWN_COW) {
+			XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+					rmap.rm_offset <= offset);
+			XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+					rmap.rm_offset + rmap.rm_blockcount >
+					rmap.rm_offset);
+			XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+					rmap.rm_offset + rmap.rm_blockcount >=
+					offset + irec->br_blockcount);
+		}
+		XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+				rmap.rm_owner == owner);
+		switch (irec->br_state) {
+		case XFS_EXT_UNWRITTEN:
+			XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+					rmap.rm_flags & XFS_RMAP_UNWRITTEN);
+			break;
+		case XFS_EXT_NORM:
+			XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+					!(rmap.rm_flags & XFS_RMAP_UNWRITTEN));
+			break;
+		default:
+			break;
+		}
+		switch (info->whichfork) {
+		case XFS_ATTR_FORK:
+			XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+					rmap.rm_flags & XFS_RMAP_ATTR_FORK);
+			break;
+		case XFS_DATA_FORK:
+		case XFS_COW_FORK:
+			XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+					!(rmap.rm_flags & XFS_RMAP_ATTR_FORK));
+			break;
+		}
+		XFS_INO_SCRUB_CHECK(ip, NULL, info->type,
+				!(rmap.rm_flags & XFS_RMAP_BMBT_BLOCK));
+
+skip_rmap_xref:
+		/* Free cursor. */
+		xfs_btree_del_cursor(xcur, err2 ? XFS_BTREE_ERROR :
+						  XFS_BTREE_NOERROR);
+	}
+
 	xfs_scrub_put_ag_headers(&agi_bp, &agf_bp);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
