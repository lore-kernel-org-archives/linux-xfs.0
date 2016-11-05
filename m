Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18105 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753593AbcKEAWN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:22:13 -0400
Subject: [PATCH 29/41] xfs: cross-reference inode btrees during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:22:08 -0700
Message-ID: <147830532878.2155.934602750728948316.stgit@birch.djwong.org>
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

Cross-reference the inode btrees with the other metadata when we
scrub the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |   58 ++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |    4 +
 fs/xfs/xfs_scrub.c         |  179 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 241 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 720c93a..900978e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2666,3 +2666,61 @@ xfs_ialloc_pagi_init(
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
index 2c33f76..34ebd2e 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1723,6 +1723,7 @@ xfs_scrub_superblock(
 	struct xfs_sb			sb;
 	xfs_agnumber_t			agno;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error;
 	int				err2;
 
@@ -1800,6 +1801,22 @@ xfs_scrub_superblock(
 			XFS_SCRUB_SB_CHECK(!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				XFS_SB_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &psa->ino_cur))
+			XFS_SCRUB_SB_CHECK(!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				XFS_SB_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &psa->fino_cur))
+			XFS_SCRUB_SB_CHECK(!has_inodes);
+	}
+
 out:
 	return error;
 }
@@ -1840,6 +1857,7 @@ xfs_scrub_agf(
 	xfs_agblock_t			fl_count;
 	xfs_extlen_t			blocks;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				have;
 	int				level;
 	int				error = 0;
@@ -1958,6 +1976,22 @@ xfs_scrub_agf(
 	}
 skip_cntbt:
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				XFS_AGF_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &psa->ino_cur))
+			XFS_SCRUB_AGF_CHECK(!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				XFS_AGF_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &psa->fino_cur))
+			XFS_SCRUB_AGF_CHECK(!has_inodes);
+	}
+
 out:
 	return error;
 }
@@ -2034,6 +2068,7 @@ xfs_scrub_agfl_block(
 	xfs_agnumber_t			agno = sc->sa.agno;
 	struct xfs_scrub_agfl		*sagfl = priv;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				err2;
 
 	XFS_SCRUB_AGFL_CHECK(agbno > XFS_AGI_BLOCK(mp));
@@ -2052,6 +2087,22 @@ xfs_scrub_agfl_block(
 			XFS_SCRUB_AGFL_CHECK(!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (sc->sa.ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur,
+				agbno, 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.ino_cur))
+			XFS_SCRUB_AGFL_CHECK(!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (sc->sa.fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(sc->sa.fino_cur,
+				agbno, 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.fino_cur))
+			XFS_SCRUB_AGFL_CHECK(!has_inodes);
+	}
+
 	return 0;
 }
 
@@ -2064,6 +2115,7 @@ xfs_scrub_agfl(
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	struct xfs_agf			*agf;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				err2;
 
 	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
@@ -2078,6 +2130,22 @@ xfs_scrub_agfl(
 			XFS_SCRUB_AGFL_CHECK(!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (sc->sa.ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur,
+			XFS_AGFL_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.ino_cur))
+			XFS_SCRUB_AGFL_CHECK(!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (sc->sa.fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(sc->sa.fino_cur,
+				XFS_AGFL_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.fino_cur))
+			XFS_SCRUB_AGFL_CHECK(!has_inodes);
+	}
+
 	/* Check the blocks in the AGFL. */
 	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sagfl);
 }
@@ -2103,6 +2171,7 @@ xfs_scrub_agi(
 	xfs_agino_t			first_agino;
 	xfs_agino_t			last_agino;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				i;
 	int				level;
 	int				error = 0;
@@ -2182,6 +2251,22 @@ xfs_scrub_agi(
 			XFS_SCRUB_AGI_CHECK(!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				XFS_AGI_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &psa->ino_cur))
+			XFS_SCRUB_AGI_CHECK(!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				XFS_AGI_BLOCK(mp), 1, &has_inodes);
+		if (xfs_scrub_should_xref(sc, err2, &psa->fino_cur))
+			XFS_SCRUB_AGI_CHECK(!has_inodes);
+	}
+
 out:
 	return error;
 }
@@ -2203,6 +2288,7 @@ xfs_scrub_allocbt_helper(
 	xfs_agblock_t			bno;
 	xfs_extlen_t			flen;
 	xfs_extlen_t			len;
+	bool				has_inodes;
 	int				has_otherrec;
 	int				error = 0;
 	int				err2;
@@ -2246,6 +2332,22 @@ xfs_scrub_allocbt_helper(
 		}
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur, bno,
+				len, &has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->ino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur, bno,
+				len, &has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->fino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !has_inodes);
+	}
+
 out:
 	return error;
 }
@@ -2293,9 +2395,11 @@ xfs_scrub_iallocbt_chunk(
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
 	struct xfs_scrub_ag		*psa;
+	struct xfs_btree_cur		**xcur;
 	xfs_agblock_t			eoag;
 	xfs_agblock_t			bno;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 	int				err2;
 
@@ -2329,6 +2433,20 @@ xfs_scrub_iallocbt_chunk(
 			XFS_SCRUB_BTREC_CHECK(bs, !is_freesp);
 	}
 
+	/* If we have a finobt, cross-reference with it. */
+	if (bs->cur == psa->fino_cur)
+		xcur = &psa->ino_cur;
+	else if (bs->cur == psa->ino_cur && irec->ir_freecount > 0)
+		xcur = &psa->fino_cur;
+	else
+		xcur = NULL;
+	if (xcur && *xcur) {
+		err2 = xfs_ialloc_has_inode_record(*xcur,
+				agino, agino, &has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, xcur))
+			XFS_SCRUB_BTREC_CHECK(bs, has_inodes);
+	}
+
 out:
 	return error;
 }
@@ -2446,6 +2564,7 @@ xfs_scrub_rmapbt_helper(
 	bool				is_unwritten;
 	bool				is_bmbt;
 	bool				is_attr;
+	bool				has_inodes;
 	int				error = 0;
 	int				err2;
 
@@ -2513,6 +2632,28 @@ xfs_scrub_rmapbt_helper(
 			XFS_SCRUB_BTREC_CHECK(bs, !is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				irec.rm_startblock, irec.rm_blockcount,
+				&has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->ino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs,
+					irec.rm_owner == XFS_RMAP_OWN_INODES ||
+					!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				irec.rm_startblock, irec.rm_blockcount,
+				&has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->fino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs,
+					irec.rm_owner == XFS_RMAP_OWN_INODES ||
+					!has_inodes);
+	}
+
 out:
 	return error;
 }
@@ -2544,6 +2685,7 @@ xfs_scrub_refcountbt_helper(
 	xfs_agblock_t			eoag;
 	bool				has_cowflag;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 	int				err2;
 
@@ -2583,6 +2725,24 @@ xfs_scrub_refcountbt_helper(
 			XFS_SCRUB_BTREC_CHECK(bs, !is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (psa->ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->ino_cur,
+				irec.rc_startblock, irec.rc_blockcount,
+				&has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->ino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (psa->fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(psa->fino_cur,
+				irec.rc_startblock, irec.rc_blockcount,
+				&has_inodes);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->fino_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !has_inodes);
+	}
+
 out:
 	return error;
 }
@@ -2691,6 +2851,7 @@ xfs_scrub_bmap_extent(
 	xfs_agnumber_t			agno;
 	xfs_fsblock_t			bno;
 	bool				is_freesp;
+	bool				has_inodes;
 	int				error = 0;
 	int				err2 = 0;
 
@@ -2744,6 +2905,24 @@ xfs_scrub_bmap_extent(
 			XFS_SCRUB_BMAP_CHECK(!is_freesp);
 	}
 
+	/* Cross-reference with inobt. */
+	if (sa.ino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(sa.ino_cur,
+				irec->br_startblock, irec->br_blockcount,
+				&has_inodes);
+		if (xfs_scrub_should_xref(info->sc, err2, &sa.ino_cur))
+			XFS_SCRUB_BMAP_CHECK(!has_inodes);
+	}
+
+	/* Cross-reference with finobt. */
+	if (sa.fino_cur) {
+		err2 = xfs_ialloc_has_inodes_at_extent(sa.fino_cur,
+				irec->br_startblock, irec->br_blockcount,
+				&has_inodes);
+		if (xfs_scrub_should_xref(info->sc, err2, &sa.fino_cur))
+			XFS_SCRUB_BMAP_CHECK(!has_inodes);
+	}
+
 	xfs_scrub_ag_free(&sa);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;

