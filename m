Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23517 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759047AbcLCBjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:33 -0500
Subject: [PATCH 37/55] xfs: cross-reference reverse-mapping btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:39:22 -0800
Message-ID: <148072916234.12995.2993513928064398301.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

When scrubbing various btrees, we should cross-reference the records
with the reverse mapping btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   58 ++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h |    5 +
 fs/xfs/repair/agheader.c |   95 +++++++++++++++++++++++
 fs/xfs/repair/alloc.c    |    9 ++
 fs/xfs/repair/bmap.c     |   89 ++++++++++++++++++++++
 fs/xfs/repair/btree.c    |   10 ++
 fs/xfs/repair/ialloc.c   |   30 +++++++
 fs/xfs/repair/inode.c    |   23 ++++++
 fs/xfs/repair/refcount.c |  187 ++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 506 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index c7d5102..cce51cb 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2306,3 +2306,61 @@ xfs_rmap_free_extent(
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
+	*has_rmap = (irec.rm_owner == owner && irec.rm_startblock <= bno &&
+		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 3fa4559..ea359ab 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -217,5 +217,10 @@ int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 union xfs_btree_rec;
 int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
+int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, bool *exists);
+int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
+		xfs_filblks_t len, struct xfs_owner_info *oinfo,
+		bool *has_rmap);
 
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index 62baeed..9751f52 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
@@ -32,6 +32,7 @@
 #include "xfs_sb.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_rmap.h"
 #include "repair/common.h"
 
 /* Find the size of the AG, in blocks. */
@@ -141,10 +142,12 @@ xfs_scrub_superblock(
 	struct xfs_buf			*bp;
 	struct xfs_scrub_ag		*psa;
 	struct xfs_sb			sb;
+	struct xfs_owner_info		oinfo;
 	xfs_agnumber_t			agno;
 	uint32_t			v2_ok;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				error;
 	int				err2;
 
@@ -297,6 +300,15 @@ xfs_scrub_superblock(
 			XFS_SCRUB_SB_CHECK(!has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (psa->rmap_cur) {
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+		err2 = xfs_rmap_record_exists(psa->rmap_cur, XFS_SB_BLOCK(mp),
+				1, &oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(sc, err2, &psa->rmap_cur))
+			XFS_SCRUB_SB_CHECK(has_rmap);
+	}
+
 out:
 	return error;
 }
@@ -328,6 +340,7 @@ int
 xfs_scrub_agf(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	struct xfs_agf			*agf;
 	struct xfs_scrub_ag		*psa;
@@ -341,8 +354,10 @@ xfs_scrub_agf(
 	xfs_agblock_t			agfl_count;
 	xfs_agblock_t			fl_count;
 	xfs_extlen_t			blocks;
+	xfs_extlen_t			btreeblks = 0;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				have;
 	int				level;
 	int				error = 0;
@@ -478,6 +493,37 @@ xfs_scrub_agf(
 			XFS_SCRUB_AGF_CHECK(!has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (psa->rmap_cur) {
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+		err2 = xfs_rmap_record_exists(psa->rmap_cur, XFS_AGF_BLOCK(mp),
+				1, &oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(sc, err2, &psa->rmap_cur))
+			XFS_SCRUB_AGF_CHECK(has_rmap);
+	}
+	if (psa->rmap_cur) {
+		err2 = xfs_btree_count_blocks(psa->rmap_cur, &blocks);
+		if (xfs_scrub_should_xref(sc, err2, &psa->rmap_cur)) {
+			btreeblks = blocks - 1;
+			XFS_SCRUB_AGF_CHECK(blocks == be32_to_cpu(
+					agf->agf_rmap_blocks));
+		}
+	}
+
+	/* Check btreeblks */
+	if ((!xfs_sb_version_hasrmapbt(&mp->m_sb) || psa->rmap_cur) &&
+	    psa->bno_cur && psa->cnt_cur) {
+		err2 = xfs_btree_count_blocks(psa->bno_cur, &blocks);
+		if (xfs_scrub_should_xref(sc, err2, &psa->bno_cur))
+			btreeblks += blocks - 1;
+		err2 = xfs_btree_count_blocks(psa->cnt_cur, &blocks);
+		if (xfs_scrub_should_xref(sc, err2, &psa->cnt_cur))
+			btreeblks += blocks - 1;
+		if (psa->bno_cur && psa->cnt_cur)
+			XFS_SCRUB_AGF_CHECK(btreeblks == be32_to_cpu(
+					agf->agf_btreeblks));
+	}
+
 out:
 	return error;
 }
@@ -489,6 +535,7 @@ xfs_scrub_agf(
 #define XFS_SCRUB_AGFL_CHECK(fs_ok) \
 	XFS_SCRUB_CHECK(sc, sc->sa.agfl_bp, "AGFL", fs_ok)
 struct xfs_scrub_agfl {
+	struct xfs_owner_info		oinfo;
 	xfs_agblock_t			eoag;
 	xfs_daddr_t			eofs;
 };
@@ -505,6 +552,7 @@ xfs_scrub_agfl_block(
 	struct xfs_scrub_agfl		*sagfl = priv;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				err2;
 
 	XFS_SCRUB_AGFL_CHECK(agbno > XFS_AGI_BLOCK(mp));
@@ -539,6 +587,14 @@ xfs_scrub_agfl_block(
 			XFS_SCRUB_AGFL_CHECK(!has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (sc->sa.rmap_cur) {
+		err2 = xfs_rmap_record_exists(sc->sa.rmap_cur, agbno, 1,
+				&sagfl->oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.rmap_cur))
+			XFS_SCRUB_AGFL_CHECK(has_rmap);
+	}
+
 	return 0;
 }
 
@@ -554,6 +610,8 @@ xfs_scrub_agfl(
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	struct xfs_agf			*agf;
 	bool				is_freesp;
+	bool				has_inodes;
+	bool				has_rmap;
 	int				error;
 	int				err2;
 
@@ -575,7 +633,33 @@ xfs_scrub_agfl(
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
+	/* Set up cross-reference with rmapbt. */
+	if (sc->sa.rmap_cur) {
+		xfs_rmap_ag_owner(&sagfl.oinfo, XFS_RMAP_OWN_FS);
+		err2 = xfs_rmap_record_exists(sc->sa.rmap_cur,
+				XFS_AGFL_BLOCK(mp), 1, &sagfl.oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.rmap_cur))
+			XFS_SCRUB_AGFL_CHECK(has_rmap);
+	}
+
 	/* Check the blocks in the AGFL. */
+	xfs_rmap_ag_owner(&sagfl.oinfo, XFS_RMAP_OWN_AG);
 	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sagfl);
 out:
 	return error;
@@ -595,6 +679,7 @@ int
 xfs_scrub_agi(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	struct xfs_agi			*agi;
 	struct xfs_scrub_ag		*psa;
@@ -610,6 +695,7 @@ xfs_scrub_agi(
 	xfs_agino_t			freecount;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				i;
 	int				level;
 	int				error = 0;
@@ -721,6 +807,15 @@ xfs_scrub_agi(
 			XFS_SCRUB_AGI_CHECK(!has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (psa->rmap_cur) {
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+		err2 = xfs_rmap_record_exists(psa->rmap_cur, XFS_AGI_BLOCK(mp),
+				1, &oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(sc, err2, &psa->rmap_cur))
+			XFS_SCRUB_AGI_CHECK(has_rmap);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/repair/alloc.c b/fs/xfs/repair/alloc.c
index d7ca294..1020e8d 100644
--- a/fs/xfs/repair/alloc.c
+++ b/fs/xfs/repair/alloc.c
@@ -52,6 +52,7 @@ xfs_scrub_allocbt_helper(
 	xfs_agblock_t			bno;
 	xfs_extlen_t			flen;
 	xfs_extlen_t			len;
+	bool				has_rmap;
 	bool				has_inodes;
 	int				has_otherrec;
 	int				error = 0;
@@ -112,6 +113,14 @@ xfs_scrub_allocbt_helper(
 			XFS_SCRUB_BTREC_CHECK(bs, !has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (psa->rmap_cur) {
+		err2 = xfs_rmap_has_record(psa->rmap_cur, bno, len,
+				&has_rmap);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->rmap_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !has_rmap);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/repair/bmap.c b/fs/xfs/repair/bmap.c
index 94d40f4..a393c82 100644
--- a/fs/xfs/repair/bmap.c
+++ b/fs/xfs/repair/bmap.c
@@ -80,8 +80,13 @@ xfs_scrub_bmap_extent(
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
 
@@ -154,6 +159,90 @@ xfs_scrub_bmap_extent(
 			XFS_SCRUB_BMAP_CHECK(!has_inodes);
 	}
 
+	/* Cross-reference with rmapbt. */
+	if (sa.rmap_cur) {
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
+			err2 = xfs_rmap_lookup_le_range(sa.rmap_cur, bno, owner,
+					offset, rflags, &rmap,
+					&has_rmap);
+			if (xfs_scrub_should_xref(info->sc, err2,
+					&sa.rmap_cur)) {
+				XFS_SCRUB_BMAP_GOTO(has_rmap, skip_rmap_xref);
+			} else
+				goto skip_rmap_xref;
+		} else {
+			err2 = xfs_rmap_lookup_le(sa.rmap_cur, bno, 0, owner,
+					offset, rflags, &has_rmap);
+			if (xfs_scrub_should_xref(info->sc, err2,
+					&sa.rmap_cur)) {
+				XFS_SCRUB_BMAP_GOTO(has_rmap, skip_rmap_xref);
+			} else
+				goto skip_rmap_xref;
+
+			err2 = xfs_rmap_get_rec(sa.rmap_cur, &rmap,
+					&has_rmap);
+			if (xfs_scrub_should_xref(info->sc, err2,
+					&sa.rmap_cur)) {
+				XFS_SCRUB_BMAP_GOTO(has_rmap, skip_rmap_xref);
+			} else
+				goto skip_rmap_xref;
+		}
+
+		/* Check the rmap. */
+		XFS_SCRUB_BMAP_CHECK(rmap.rm_startblock <= bno);
+		XFS_SCRUB_BMAP_CHECK(rmap.rm_startblock <
+				rmap.rm_startblock + rmap.rm_blockcount);
+		XFS_SCRUB_BMAP_CHECK(bno + irec->br_blockcount <=
+				rmap.rm_startblock + rmap.rm_blockcount);
+		if (owner != XFS_RMAP_OWN_COW) {
+			XFS_SCRUB_BMAP_CHECK(rmap.rm_offset <= offset);
+			XFS_SCRUB_BMAP_CHECK(rmap.rm_offset <
+					rmap.rm_offset + rmap.rm_blockcount);
+			XFS_SCRUB_BMAP_CHECK(offset + irec->br_blockcount <=
+					rmap.rm_offset + rmap.rm_blockcount);
+		}
+		XFS_SCRUB_BMAP_CHECK(rmap.rm_owner == owner);
+		switch (irec->br_state) {
+		case XFS_EXT_UNWRITTEN:
+			XFS_SCRUB_BMAP_CHECK(
+					rmap.rm_flags & XFS_RMAP_UNWRITTEN);
+			break;
+		case XFS_EXT_NORM:
+			XFS_SCRUB_BMAP_CHECK(
+					!(rmap.rm_flags & XFS_RMAP_UNWRITTEN));
+			break;
+		default:
+			break;
+		}
+		switch (info->whichfork) {
+		case XFS_ATTR_FORK:
+			XFS_SCRUB_BMAP_CHECK(
+					rmap.rm_flags & XFS_RMAP_ATTR_FORK);
+			break;
+		case XFS_DATA_FORK:
+		case XFS_COW_FORK:
+			XFS_SCRUB_BMAP_CHECK(
+					!(rmap.rm_flags & XFS_RMAP_ATTR_FORK));
+			break;
+		}
+		XFS_SCRUB_BMAP_CHECK(!(rmap.rm_flags & XFS_RMAP_BMBT_BLOCK));
+skip_rmap_xref:
+		;
+	}
+
 	xfs_scrub_ag_free(&sa);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
diff --git a/fs/xfs/repair/btree.c b/fs/xfs/repair/btree.c
index ed6628f..fdffe36 100644
--- a/fs/xfs/repair/btree.c
+++ b/fs/xfs/repair/btree.c
@@ -32,6 +32,7 @@
 #include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
+#include "xfs_rmap.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -513,6 +514,7 @@ xfs_scrub_btree_check_block_owner(
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			bno;
 	bool				is_freesp;
+	bool				has_rmap;
 	int				error = 0;
 	int				err2;
 
@@ -536,6 +538,14 @@ xfs_scrub_btree_check_block_owner(
 			XFS_SCRUB_BTREC_CHECK(bs, !is_freesp);
 	}
 
+	/* Check that there's an rmap for this. */
+	if (psa->rmap_cur) {
+		err2 = xfs_rmap_record_exists(psa->rmap_cur, bno, 1, bs->oinfo,
+				&has_rmap);
+		if (xfs_scrub_btree_should_xref(bs, err2, NULL))
+			XFS_SCRUB_BTREC_CHECK(bs, has_rmap);
+	}
+
 	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		xfs_scrub_ag_free(&sa);
 
diff --git a/fs/xfs/repair/ialloc.c b/fs/xfs/repair/ialloc.c
index 141c6bb..2fa4c25 100644
--- a/fs/xfs/repair/ialloc.c
+++ b/fs/xfs/repair/ialloc.c
@@ -54,16 +54,19 @@ xfs_scrub_iallocbt_chunk(
 	struct xfs_agf			*agf;
 	struct xfs_scrub_ag		*psa;
 	struct xfs_btree_cur		**xcur;
+	struct xfs_owner_info		oinfo;
 	xfs_agblock_t			eoag;
 	xfs_agblock_t			bno;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				error = 0;
 	int				err2;
 
 	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
 	eoag = be32_to_cpu(agf->agf_length);
 	bno = XFS_AGINO_TO_AGBNO(mp, agino);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 
 	*keep_scanning = true;
 	XFS_SCRUB_BTREC_CHECK(bs, bno < mp->m_sb.sb_agblocks);
@@ -105,6 +108,14 @@ xfs_scrub_iallocbt_chunk(
 			XFS_SCRUB_BTREC_CHECK(bs, has_inodes);
 	}
 
+	/* Cross-reference with rmapbt. */
+	if (psa->rmap_cur) {
+		err2 = xfs_rmap_record_exists(psa->rmap_cur, bno,
+				len, &oinfo, &has_rmap);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->rmap_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, has_rmap);
+	}
+
 out:
 	return error;
 }
@@ -137,6 +148,7 @@ xfs_scrub_iallocbt_check_freemask(
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_dinode		*dip;
 	struct xfs_buf			*bp;
+	struct xfs_scrub_ag		*psa;
 	xfs_ino_t			fsino;
 	xfs_agino_t			nr_inodes;
 	xfs_agino_t			agino;
@@ -146,12 +158,15 @@ xfs_scrub_iallocbt_check_freemask(
 	int				blks_per_cluster;
 	__uint16_t			holemask;
 	__uint16_t			ir_holemask;
+	bool				has;
 	int				error = 0;
+	int				err2;
 
 	/* Make sure the freemask matches the inode records. */
 	blks_per_cluster = xfs_icluster_size_fsb(mp);
 	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+	psa = &bs->sc->sa;
 
 	for (agino = irec->ir_startino;
 	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
@@ -171,6 +186,21 @@ xfs_scrub_iallocbt_check_freemask(
 		XFS_SCRUB_BTREC_CHECK(bs, ir_holemask == holemask ||
 				ir_holemask == 0);
 
+		/* Does the rmap agree that we have inodes here? */
+		if (psa->rmap_cur) {
+			err2 = xfs_rmap_record_exists(psa->rmap_cur, agbno,
+					blks_per_cluster, &oinfo, &has);
+			if (!xfs_scrub_btree_should_xref(bs, err2,
+					&psa->rmap_cur))
+				goto skip_xref;
+			if (has)
+				XFS_SCRUB_BTREC_CHECK(bs, ir_holemask == 0);
+			else
+				XFS_SCRUB_BTREC_CHECK(bs,
+						ir_holemask == holemask);
+		}
+
+skip_xref:
 		/* If any part of this is a hole, skip it. */
 		if (ir_holemask)
 			goto next_cluster;
diff --git a/fs/xfs/repair/inode.c b/fs/xfs/repair/inode.c
index b0786a2..9eb3e35 100644
--- a/fs/xfs/repair/inode.c
+++ b/fs/xfs/repair/inode.c
@@ -36,6 +36,7 @@
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_ialloc.h"
+#include "xfs_rmap.h"
 #include "repair/common.h"
 
 /* Inode core */
@@ -69,6 +70,7 @@ xfs_scrub_inode(
 	uint16_t			flags;
 	uint16_t			mode;
 	int				error = 0;
+	int				err2;
 
 	/* Did we get the in-core inode, or are we doing this manually? */
 	if (sc->ip) {
@@ -255,6 +257,27 @@ xfs_scrub_inode(
 		XFS_SCRUB_INODE_PREEN(ifp->if_bytes > 0);
 	}
 
+	/* Make sure the rmap thinks there's an inode here. */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		struct xfs_owner_info		oinfo;
+		struct xfs_scrub_ag		sa = {0};
+		xfs_agnumber_t			agno;
+		xfs_agblock_t			agbno;
+		bool				has_rmap;
+
+		agno = XFS_INO_TO_AGNO(mp, ino);
+		agbno = XFS_INO_TO_AGBNO(mp, ino);
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+		error = xfs_scrub_ag_init(sc, agno, &sa);
+		XFS_SCRUB_INODE_OP_ERROR_GOTO(out);
+
+		err2 = xfs_rmap_record_exists(sa.rmap_cur, agbno,
+				1, &oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(sc, err2, &sa.rmap_cur))
+			XFS_SCRUB_INODE_CHECK(has_rmap);
+		xfs_scrub_ag_free(&sa);
+	}
+
 out:
 	if (bp)
 		xfs_trans_brelse(sc->tp, bp);
diff --git a/fs/xfs/repair/refcount.c b/fs/xfs/repair/refcount.c
index 95b54d6..12e92e2 100644
--- a/fs/xfs/repair/refcount.c
+++ b/fs/xfs/repair/refcount.c
@@ -38,6 +38,163 @@
 
 /* Reference count btree scrubber. */
 
+struct xfs_scrub_refcountbt_fragment {
+	struct xfs_rmap_irec		rm;
+	struct list_head		list;
+};
+
+struct xfs_scrub_refcountbt_rmap_check_info {
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
+xfs_scrub_refcountbt_rmap_check(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_scrub_refcountbt_rmap_check_info	*rsrci = priv;
+	struct xfs_scrub_refcountbt_fragment		*frag;
+	xfs_agblock_t			rm_last;
+	xfs_agblock_t			rc_last;
+
+	rm_last = rec->rm_startblock + rec->rm_blockcount;
+	rc_last = rsrci->rc.rc_startblock + rsrci->rc.rc_blockcount;
+	XFS_SCRUB_BTREC_CHECK(rsrci->bs, rsrci->rc.rc_refcount != 1 ||
+			rec->rm_owner == XFS_RMAP_OWN_COW);
+	if (rec->rm_startblock <= rsrci->rc.rc_startblock && rm_last >= rc_last)
+		rsrci->nr++;
+	else {
+		frag = kmem_zalloc(sizeof(struct xfs_scrub_refcountbt_fragment),
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
+xfs_scrub_refcountbt_process_rmap_fragments(
+	struct xfs_mount				*mp,
+	struct xfs_scrub_refcountbt_rmap_check_info	*rsrci)
+{
+	struct list_head				worklist;
+	struct xfs_scrub_refcountbt_fragment		*cur;
+	struct xfs_scrub_refcountbt_fragment		*n;
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
+	list_for_each_entry_safe(cur, n, &worklist, list) {
+		list_del(&cur->list);
+		kmem_free(cur);
+	}
+	list_for_each_entry_safe(cur, n, &rsrci->fragments, list) {
+		cur = list_first_entry(&rsrci->fragments,
+				struct xfs_scrub_refcountbt_fragment, list);
+		list_del(&cur->list);
+		kmem_free(cur);
+	}
+}
+
 /* Scrub a refcountbt record. */
 STATIC int
 xfs_scrub_refcountbt_helper(
@@ -48,6 +205,11 @@ xfs_scrub_refcountbt_helper(
 	struct xfs_agf			*agf;
 	struct xfs_scrub_ag		*psa;
 	struct xfs_refcount_irec	irec;
+	struct xfs_rmap_irec		low;
+	struct xfs_rmap_irec		high;
+	struct xfs_scrub_refcountbt_rmap_check_info	rsrci;
+	struct xfs_scrub_refcountbt_fragment		*cur;
+	struct xfs_scrub_refcountbt_fragment		*n;
 	xfs_agblock_t			eoag;
 	bool				has_cowflag;
 	bool				is_freesp;
@@ -109,6 +271,31 @@ xfs_scrub_refcountbt_helper(
 			XFS_SCRUB_BTREC_CHECK(bs, !has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt to confirm the refcount. */
+	if (psa->rmap_cur) {
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
+		err2 = xfs_rmap_query_range(psa->rmap_cur, &low, &high,
+				&xfs_scrub_refcountbt_rmap_check, &rsrci);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->rmap_cur)) {
+			xfs_scrub_refcountbt_process_rmap_fragments(mp, &rsrci);
+			XFS_SCRUB_BTREC_CHECK(bs, irec.rc_refcount == rsrci.nr);
+		}
+
+		list_for_each_entry_safe(cur, n, &rsrci.fragments, list) {
+			list_del(&cur->list);
+			kmem_free(cur);
+		}
+	}
+
 out:
 	return error;
 }

