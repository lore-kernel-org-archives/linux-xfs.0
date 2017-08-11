Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18069 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdHKHLY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:11:24 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7BNTs019000
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BNgk031873
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:23 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7BMkq020716
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:11:23 GMT
Subject: [PATCH 11/16] xfs: cross-reference reverse-mapping btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:11:21 -0700
Message-ID: <150243548139.29473.1430026269960952121.stgit@magnolia>
In-Reply-To: <150243541274.29473.1227559008347544526.stgit@magnolia>
References: <150243541274.29473.1227559008347544526.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When scrubbing various btrees, we should cross-reference the records
with the reverse mapping btree and ensure that traversing the btree
finds the same number of blocks that the rmapbt thinks are owned by
that btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   84 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/alloc.c    |   10 +++++
 fs/xfs/scrub/bmap.c     |   88 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/btree.c    |   11 ++++++
 fs/xfs/scrub/common.c   |   47 +++++++++++++++++++++++++
 fs/xfs/scrub/common.h   |    4 ++
 fs/xfs/scrub/ialloc.c   |   88 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/inode.c    |   36 +++++++++++++++++++
 8 files changed, 366 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index fedd86b..569d3c0 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -32,6 +32,7 @@
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
+#include "xfs_rmap.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -152,11 +153,13 @@ xfs_scrub_superblock(
 	struct xfs_buf			*bp;
 	struct xfs_scrub_ag		*psa;
 	struct xfs_dsb			*sb;
+	struct xfs_owner_info		oinfo;
 	xfs_agnumber_t			agno;
 	uint32_t			v2_ok;
 	__be32				features_mask;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				error;
 	__be16				vernum_mask;
 
@@ -447,6 +450,15 @@ xfs_scrub_superblock(
 			xfs_scrub_block_xref_check_ok(sc, bp, !has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (psa->rmap_cur) {
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+		error = xfs_rmap_record_exists(psa->rmap_cur, XFS_SB_BLOCK(mp),
+				1, &oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(sc, &error, &psa->rmap_cur))
+			xfs_scrub_block_xref_check_ok(sc, bp, has_rmap);
+	}
+
 	return error;
 }
 
@@ -470,6 +482,7 @@ int
 xfs_scrub_agf(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_agf			*agf;
 	struct xfs_scrub_ag		*psa;
@@ -483,8 +496,10 @@ xfs_scrub_agf(
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
@@ -626,6 +641,40 @@ xfs_scrub_agf(
 					!has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (psa->rmap_cur) {
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+		error = xfs_rmap_record_exists(psa->rmap_cur, XFS_AGF_BLOCK(mp),
+				1, &oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(sc, &error, &psa->rmap_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agf_bp,
+					has_rmap);
+	}
+	if (psa->rmap_cur) {
+		error = xfs_btree_count_blocks(psa->rmap_cur, &blocks);
+		if (xfs_scrub_should_xref(sc, &error, &psa->rmap_cur)) {
+			btreeblks = blocks - 1;
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agf_bp,
+					blocks == be32_to_cpu(
+						agf->agf_rmap_blocks));
+		}
+	}
+
+	/* Check btreeblks */
+	if ((!xfs_sb_version_hasrmapbt(&mp->m_sb) || psa->rmap_cur) &&
+	    psa->bno_cur && psa->cnt_cur) {
+		error = xfs_btree_count_blocks(psa->bno_cur, &blocks);
+		if (xfs_scrub_should_xref(sc, &error, &psa->bno_cur))
+			btreeblks += blocks - 1;
+		error = xfs_btree_count_blocks(psa->cnt_cur, &blocks);
+		if (xfs_scrub_should_xref(sc, &error, &psa->cnt_cur))
+			btreeblks += blocks - 1;
+		if (psa->bno_cur && psa->cnt_cur)
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agf_bp,
+					btreeblks == be32_to_cpu(
+						agf->agf_btreeblks));
+	}
+
 out:
 	return error;
 }
@@ -633,6 +682,7 @@ xfs_scrub_agf(
 /* AGFL */
 
 struct xfs_scrub_agfl {
+	struct xfs_owner_info		oinfo;
 	xfs_agblock_t			eoag;
 	xfs_daddr_t			eofs;
 };
@@ -649,6 +699,7 @@ xfs_scrub_agfl_block(
 	struct xfs_scrub_agfl		*sagfl = priv;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				error = 0;
 
 	xfs_scrub_block_check_ok(sc, sc->sa.agfl_bp,
@@ -688,6 +739,15 @@ xfs_scrub_agfl_block(
 					!has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (sc->sa.rmap_cur) {
+		error = xfs_rmap_record_exists(sc->sa.rmap_cur, agbno, 1,
+				&sagfl->oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(sc, &error, &sc->sa.rmap_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agfl_bp,
+					has_rmap);
+	}
+
 	return error;
 }
 
@@ -702,6 +762,7 @@ xfs_scrub_agfl(
 	xfs_agnumber_t			agno;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				error;
 
 	agno = sc->sm->sm_agno;
@@ -742,7 +803,18 @@ xfs_scrub_agfl(
 					!has_inodes);
 	}
 
+	/* Set up cross-reference with rmapbt. */
+	if (sc->sa.rmap_cur) {
+		xfs_rmap_ag_owner(&sagfl.oinfo, XFS_RMAP_OWN_FS);
+		error = xfs_rmap_record_exists(sc->sa.rmap_cur,
+				XFS_AGFL_BLOCK(mp), 1, &sagfl.oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(sc, &error, &sc->sa.rmap_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agfl_bp,
+					has_rmap);
+	}
+
 	/* Check the blocks in the AGFL. */
+	xfs_rmap_ag_owner(&sagfl.oinfo, XFS_RMAP_OWN_AG);
 	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sagfl);
 out:
 	return error;
@@ -755,6 +827,7 @@ int
 xfs_scrub_agi(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_agi			*agi;
 	struct xfs_scrub_ag		*psa;
@@ -770,6 +843,7 @@ xfs_scrub_agi(
 	xfs_agino_t			freecount;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				i;
 	int				level;
 	int				error = 0;
@@ -882,6 +956,16 @@ xfs_scrub_agi(
 					!has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (psa->rmap_cur) {
+		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_FS);
+		error = xfs_rmap_record_exists(psa->rmap_cur, XFS_AGI_BLOCK(mp),
+				1, &oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(sc, &error, &psa->rmap_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agi_bp,
+					has_rmap);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index d99ad99..a45ca18 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -67,6 +67,7 @@ xfs_scrub_allocbt_helper(
 	xfs_agblock_t			bno;
 	xfs_extlen_t			flen;
 	xfs_extlen_t			len;
+	bool				has_rmap;
 	bool				has_inodes;
 	int				has_otherrec;
 	int				error = 0;
@@ -130,6 +131,15 @@ xfs_scrub_allocbt_helper(
 					!has_inodes);
 	}
 
+	/* Cross-reference with the rmapbt. */
+	if (psa->rmap_cur) {
+		error = xfs_rmap_has_record(psa->rmap_cur, bno, len,
+				&has_rmap);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->rmap_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->rmap_cur, 0,
+					!has_rmap);
+	}
+
 	return error;
 }
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7ad8ba0..1bd16db 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -126,6 +126,90 @@ struct xfs_scrub_bmap_info {
 	int				whichfork;
 };
 
+/* Make sure that we have rmapbt records for this extent. */
+STATIC void
+xfs_scrub_bmap_xref_rmap(
+	struct xfs_scrub_bmap_info	*info,
+	struct xfs_scrub_ag		*sa,
+	struct xfs_bmbt_irec		*irec,
+	xfs_fsblock_t			bno)
+{
+	struct xfs_rmap_irec		rmap;
+	uint64_t			owner;
+	xfs_fileoff_t			offset;
+	unsigned long long		rmap_end;
+	unsigned int			rflags;
+	int				has_rmap;
+	int				error;
+
+	if (info->whichfork == XFS_COW_FORK) {
+		owner = XFS_RMAP_OWN_COW;
+		offset = 0;
+	} else {
+		owner = info->sc->ip->i_ino;
+		offset = irec->br_startoff;
+	}
+
+	/* Look for a corresponding rmap. */
+	rflags = 0;
+	if (info->whichfork == XFS_ATTR_FORK)
+		rflags |= XFS_RMAP_ATTR_FORK;
+
+	if (info->is_shared) {
+		error = xfs_rmap_lookup_le_range(sa->rmap_cur, bno, owner,
+				offset, rflags, &rmap,
+				&has_rmap);
+		if (!xfs_scrub_should_xref(info->sc, &error, &sa->rmap_cur) ||
+		    !xfs_scrub_fblock_xref_check_ok(info->sc, info->whichfork,
+				irec->br_startoff, has_rmap))
+			return;
+	} else {
+		error = xfs_rmap_lookup_le(sa->rmap_cur, bno, 0, owner,
+				offset, rflags, &has_rmap);
+		if (!xfs_scrub_should_xref(info->sc, &error, &sa->rmap_cur) ||
+		    !xfs_scrub_fblock_xref_check_ok(info->sc, info->whichfork,
+				irec->br_startoff, has_rmap))
+			return;
+
+		error = xfs_rmap_get_rec(sa->rmap_cur, &rmap,
+				&has_rmap);
+		if (!xfs_scrub_should_xref(info->sc, &error, &sa->rmap_cur) ||
+		    !xfs_scrub_fblock_xref_check_ok(info->sc, info->whichfork,
+				irec->br_startoff, has_rmap))
+			return;
+	}
+
+	/* Check the rmap. */
+	rmap_end = (unsigned long long)rmap.rm_startblock + rmap.rm_blockcount;
+	xfs_scrub_fblock_xref_check_ok(info->sc, info->whichfork,
+			irec->br_startoff,
+			rmap.rm_startblock <= bno &&
+			bno + irec->br_blockcount <= rmap_end);
+
+	if (owner != XFS_RMAP_OWN_COW) {
+		rmap_end = (unsigned long long)rmap.rm_offset +
+				rmap.rm_blockcount;
+		xfs_scrub_fblock_xref_check_ok(info->sc, info->whichfork,
+				irec->br_startoff,
+				rmap.rm_offset <= offset &&
+				offset + irec->br_blockcount <= rmap_end);
+	} else {
+		/*
+		 * We don't set the unwritten flag for CoW
+		 * staging extent rmaps; everything is unwritten.
+		 */
+		irec->br_state = XFS_EXT_NORM;
+	}
+	xfs_scrub_fblock_xref_check_ok(info->sc, info->whichfork,
+			irec->br_startoff,
+			rmap.rm_owner == owner &&
+			(irec->br_state != XFS_EXT_UNWRITTEN ||
+			 (rmap.rm_flags & XFS_RMAP_UNWRITTEN)) &&
+			(info->whichfork != XFS_ATTR_FORK ||
+			 (rmap.rm_flags & XFS_RMAP_ATTR_FORK)) &&
+			!(rmap.rm_flags & XFS_RMAP_BMBT_BLOCK));
+}
+
 /* Scrub a single extent record. */
 STATIC int
 xfs_scrub_bmap_extent(
@@ -224,6 +308,10 @@ xfs_scrub_bmap_extent(
 					!has_inodes);
 	}
 
+	/* Cross-reference with rmapbt. */
+	if (sa.rmap_cur)
+		xfs_scrub_bmap_xref_rmap(info, &sa, irec, bno);
+
 	xfs_scrub_ag_free(info->sc, &sa);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 5bf4d11..6d6bd76 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -31,6 +31,7 @@
 #include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
+#include "xfs_rmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -389,6 +390,7 @@ xfs_scrub_btree_check_block_owner(
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			bno;
 	bool				is_freesp;
+	bool				has_rmap;
 	int				error = 0;
 
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
@@ -411,6 +413,15 @@ xfs_scrub_btree_check_block_owner(
 					!is_freesp);
 	}
 
+	/* Check that there's an rmap for this. */
+	if (psa->rmap_cur) {
+		error = xfs_rmap_record_exists(psa->rmap_cur, bno, 1, bs->oinfo,
+				&has_rmap);
+		if (xfs_scrub_should_xref(bs->sc, &error, NULL))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->bno_cur, 0,
+					has_rmap);
+	}
+
 	if (psa == &sa)
 		xfs_scrub_ag_free(bs->sc, &sa);
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index b80c771..db32c31 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -410,6 +410,53 @@ xfs_scrub_check_thoroughness(
 }
 
 /*
+ * rmap scrubbing -- compute the number of blocks with a given owner,
+ * at least according to the reverse mapping data.
+ */
+
+struct xfs_scrub_rmap_ownedby_info {
+	struct xfs_owner_info	*oinfo;
+	xfs_filblks_t		*blocks;
+};
+
+STATIC int
+xfs_scrub_count_rmap_ownedby_helper(
+	struct xfs_btree_cur			*cur,
+	struct xfs_rmap_irec			*rec,
+	void					*priv)
+{
+	struct xfs_scrub_rmap_ownedby_info	*sroi = priv;
+
+	if (rec->rm_owner == sroi->oinfo->oi_owner &&
+	    (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
+	     !!(rec->rm_flags & XFS_RMAP_ATTR_FORK) ==
+	     !!(sroi->oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)))
+		(*sroi->blocks) += rec->rm_blockcount;
+	return 0;
+}
+
+/*
+ * Calculate the number of blocks the rmap thinks are owned by something.
+ * The caller should pass us an rmapbt cursor.
+ */
+int
+xfs_scrub_count_rmap_ownedby_ag(
+	struct xfs_scrub_context		*sc,
+	struct xfs_btree_cur			*cur,
+	struct xfs_owner_info			*oinfo,
+	xfs_filblks_t				*blocks)
+{
+	struct xfs_scrub_rmap_ownedby_info	sroi;
+
+	sroi.oinfo = oinfo;
+	*blocks = 0;
+	sroi.blocks = blocks;
+
+	return xfs_rmap_query_all(cur, xfs_scrub_count_rmap_ownedby_helper,
+			&sroi);
+}
+
+/*
  * AG scrubbing
  *
  * These helpers facilitate locking an allocation group's header
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 8ef5bc4..e20fb1d 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -160,6 +160,10 @@ int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 			void *priv);
 bool xfs_scrub_extent_covers_ag_head(struct xfs_mount *mp, xfs_agblock_t agbno,
 				     xfs_extlen_t len);
+int xfs_scrub_count_rmap_ownedby_ag(struct xfs_scrub_context *sc,
+				    struct xfs_btree_cur *cur,
+				    struct xfs_owner_info *oinfo,
+				    xfs_filblks_t *blocks);
 
 int xfs_scrub_setup_ag_btree(struct xfs_scrub_context *sc,
 			     struct xfs_inode *ip, bool force_log);
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 7f7247f..310d5ad 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -66,6 +66,7 @@ xfs_scrub_iallocbt_chunk(
 	xfs_agino_t			agino,
 	xfs_extlen_t			len)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
 	struct xfs_scrub_ag		*psa;
@@ -75,12 +76,14 @@ xfs_scrub_iallocbt_chunk(
 	xfs_agblock_t			bno;
 	bool				is_freesp;
 	bool				has_inodes;
+	bool				has_rmap;
 	int				error = 0;
 
 	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
 	eoag = be32_to_cpu(agf->agf_length);
 	bno = XFS_AGINO_TO_AGBNO(mp, agino);
 	rec_end = (unsigned long long)bno + len;
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 
 	if (!xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0,
 			bno < mp->m_sb.sb_agblocks && bno < eoag &&
@@ -116,6 +119,15 @@ xfs_scrub_iallocbt_chunk(
 					has_inodes);
 	}
 
+	/* Cross-reference with rmapbt. */
+	if (psa->rmap_cur) {
+		error = xfs_rmap_record_exists(psa->rmap_cur, bno,
+				len, &oinfo, &has_rmap);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->rmap_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->rmap_cur, 0,
+					has_rmap);
+	}
+
 	return true;
 }
 
@@ -190,6 +202,7 @@ xfs_scrub_iallocbt_check_freemask(
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_dinode		*dip;
 	struct xfs_buf			*bp;
+	struct xfs_scrub_ag		*psa;
 	xfs_ino_t			fsino;
 	xfs_agino_t			nr_inodes;
 	xfs_agino_t			agino;
@@ -199,12 +212,14 @@ xfs_scrub_iallocbt_check_freemask(
 	int				blks_per_cluster;
 	uint16_t			holemask;
 	uint16_t			ir_holemask;
+	bool				has;
 	int				error = 0;
 
 	/* Make sure the freemask matches the inode records. */
 	blks_per_cluster = xfs_icluster_size_fsb(mp);
 	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+	psa = &bs->sc->sa;
 
 	for (agino = irec->ir_startino;
 	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
@@ -224,6 +239,19 @@ xfs_scrub_iallocbt_check_freemask(
 		xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0,
 				ir_holemask == holemask || ir_holemask == 0);
 
+		/* Does the rmap agree that we have inodes here? */
+		while (psa->rmap_cur) {
+			error = xfs_rmap_record_exists(psa->rmap_cur, agbno,
+					blks_per_cluster, &oinfo, &has);
+			if (!xfs_scrub_should_xref(bs->sc, &error,
+					&psa->rmap_cur))
+				break;
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->rmap_cur, 0,
+					(has && ir_holemask == 0) ||
+					(!has && ir_holemask == holemask));
+			break;
+		}
+
 		/* If any part of this is a hole, skip it. */
 		if (ir_holemask)
 			continue;
@@ -263,6 +291,7 @@ xfs_scrub_iallocbt_helper(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agi			*agi;
+	xfs_filblks_t			*inode_blocks = bs->private;
 	struct xfs_inobt_rec_incore	irec;
 	uint64_t			holes;
 	xfs_agino_t			agino;
@@ -293,6 +322,8 @@ xfs_scrub_iallocbt_helper(
 	xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0,
 			!(agbno & (xfs_ialloc_cluster_alignment(mp) - 1)) &&
 			!(agbno & (xfs_icluster_size_fsb(mp) - 1)));
+	*inode_blocks += XFS_B_TO_FSB(mp,
+			irec.ir_count * mp->m_sb.sb_inodesize);
 
 	/* Handle non-sparse inodes */
 	if (!xfs_inobt_issparse(irec.ir_holemask)) {
@@ -340,6 +371,50 @@ xfs_scrub_iallocbt_helper(
 	return error;
 }
 
+/* Make sure the inode btrees are as large as the rmap thinks they are. */
+STATIC void
+xfs_scrub_iallocbt_xref_rmap(
+	struct xfs_scrub_context	*sc,
+	int				which,
+	struct xfs_owner_info		*oinfo,
+	xfs_filblks_t			inode_blocks)
+{
+	xfs_filblks_t			blocks;
+	xfs_extlen_t			inobt_blocks = 0;
+	xfs_extlen_t			iblocks;
+	int				error;
+
+	while (sc->sa.fino_cur) {
+		/* Check that we saw as many inobt blocks as the rmap says. */
+		error = xfs_btree_count_blocks(sc->sa.ino_cur, &inobt_blocks);
+		if (error)
+			break;
+		if (xfs_sb_version_hasfinobt(&sc->mp->m_sb)) {
+			error = xfs_btree_count_blocks(sc->sa.fino_cur,
+					&iblocks);
+			if (error)
+				break;
+			inobt_blocks += iblocks;
+		}
+
+		error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur,
+				oinfo, &blocks);
+		if (xfs_scrub_should_xref(sc, &error, &sc->sa.rmap_cur))
+			break;
+		xfs_scrub_block_check_ok(sc, sc->sa.agi_bp,
+				blocks == inobt_blocks);
+	}
+
+	/* Check that we saw as many inode blocks as the rmap knows about. */
+	xfs_rmap_ag_owner(oinfo, XFS_RMAP_OWN_INODES);
+	error = xfs_scrub_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+			&blocks);
+	if (!xfs_scrub_should_xref(sc, &error, &sc->sa.rmap_cur))
+		return;
+	xfs_scrub_block_check_ok(sc, sc->sa.agi_bp,
+			blocks == inode_blocks);
+}
+
 /* Scrub the inode btrees for some AG. */
 STATIC int
 xfs_scrub_iallocbt(
@@ -348,11 +423,20 @@ xfs_scrub_iallocbt(
 {
 	struct xfs_btree_cur		*cur;
 	struct xfs_owner_info		oinfo;
+	xfs_filblks_t			inode_blocks = 0;
+	int				error;
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
-	return xfs_scrub_btree(sc, cur, xfs_scrub_iallocbt_helper,
-			&oinfo, NULL);
+	error = xfs_scrub_btree(sc, cur, xfs_scrub_iallocbt_helper,
+			&oinfo, &inode_blocks);
+	if (error)
+		return error;
+
+	if (which != XFS_BTNUM_FINO && sc->sa.rmap_cur)
+		xfs_scrub_iallocbt_xref_rmap(sc, which, &oinfo, inode_blocks);
+
+	return error;
 }
 
 int
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 2a0668c..9a689cc 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -37,6 +37,7 @@
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
 #include "xfs_reflink.h"
+#include "xfs_rmap.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -92,6 +93,35 @@ xfs_scrub_setup_inode(
 
 /* Inode core */
 
+/* Make sure the rmap thinks there's an inode here. */
+STATIC int
+xfs_scrub_inode_xref_rmap(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino)
+{
+	struct xfs_owner_info		oinfo;
+	struct xfs_scrub_ag		sa = { 0 };
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	bool				has_rmap;
+	int				error;
+
+	agno = XFS_INO_TO_AGNO(sc->mp, ino);
+	agbno = XFS_INO_TO_AGBNO(sc->mp, ino);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+	error = xfs_scrub_ag_init(sc, agno, &sa);
+	if (!xfs_scrub_xref_op_ok(sc, agno, agbno, &error))
+		return error;
+
+	error = xfs_rmap_record_exists(sa.rmap_cur, agbno,
+			1, &oinfo, &has_rmap);
+	if (xfs_scrub_should_xref(sc, &error, &sa.rmap_cur))
+		xfs_scrub_ino_xref_check_ok(sc, ino, NULL,
+				has_rmap);
+	xfs_scrub_ag_free(sc, &sa);
+	return error;
+}
+
 /* Scrub an inode. */
 int
 xfs_scrub_inode(
@@ -335,6 +365,12 @@ xfs_scrub_inode(
 		xfs_scrub_ino_preen_ok(sc, bp, has_shared == true);
 	}
 
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		error = xfs_scrub_inode_xref_rmap(sc, ino);
+		if (error)
+			goto out;
+	}
+
 out:
 	if (bp)
 		xfs_trans_brelse(sc->tp, bp);

