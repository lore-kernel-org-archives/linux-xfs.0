Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17895 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbdHKHK7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:10:59 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7Awvn018536
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7Av8T017562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:58 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7AvmI020471
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:57 GMT
Subject: [PATCH 07/16] xfs: scrub should cross-reference with the bnobt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:10:56 -0700
Message-ID: <150243545609.29473.4126774043463021833.stgit@magnolia>
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

When we're scrubbing various btrees, cross-reference the records with
the bnobt to ensure that we don't also think the space is free.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/bmap.c     |   12 ++++++
 fs/xfs/scrub/btree.c    |   11 +++++
 fs/xfs/scrub/ialloc.c   |   21 +++++++++-
 fs/xfs/scrub/refcount.c |   13 ++++++
 fs/xfs/scrub/rmap.c     |   14 +++++++
 6 files changed, 167 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index cfbbe9e..17d4b4e 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -30,6 +30,7 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_inode.h"
+#include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -124,10 +125,12 @@ xfs_scrub_superblock(
 {
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_buf			*bp;
+	struct xfs_scrub_ag		*psa;
 	struct xfs_dsb			*sb;
 	xfs_agnumber_t			agno;
 	uint32_t			v2_ok;
 	__be32				features_mask;
+	bool				is_freesp;
 	int				error;
 	__be16				vernum_mask;
 
@@ -388,11 +391,38 @@ xfs_scrub_superblock(
 			!memchr_inv(sb + 1, 0,
 				BBTOB(bp->b_length) - sizeof(struct xfs_dsb)));
 
+	/* Set up for cross-referencing */
+	error = xfs_scrub_ag_init(sc, agno, &sc->sa);
+	if (!xfs_scrub_xref_op_ok(sc, agno, XFS_SB_BLOCK(mp), &error))
+		return error;
+
+	psa = &sc->sa;
+	/* Cross-reference with bnobt. */
+	if (psa->bno_cur) {
+		error = xfs_alloc_has_record(psa->bno_cur, XFS_SB_BLOCK(mp),
+				1, &is_freesp);
+		if (xfs_scrub_should_xref(sc, &error, &psa->bno_cur))
+			xfs_scrub_block_xref_check_ok(sc, bp, !is_freesp);
+	}
+
 	return error;
 }
 
 /* AGF */
 
+/* Tally freespace record lengths. */
+STATIC int
+xfs_scrub_agf_record_bno_lengths(
+	struct xfs_btree_cur		*cur,
+	struct xfs_alloc_rec_incore	*rec,
+	void				*priv)
+{
+	xfs_extlen_t			*blocks = priv;
+
+	(*blocks) += rec->ar_blockcount;
+	return 0;
+}
+
 /* Scrub the AGF. */
 int
 xfs_scrub_agf(
@@ -400,6 +430,7 @@ xfs_scrub_agf(
 {
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_agf			*agf;
+	struct xfs_scrub_ag		*psa;
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			eofs;
 	xfs_agnumber_t			agno;
@@ -409,6 +440,8 @@ xfs_scrub_agf(
 	xfs_agblock_t			agfl_last;
 	xfs_agblock_t			agfl_count;
 	xfs_agblock_t			fl_count;
+	xfs_extlen_t			blocks;
+	bool				is_freesp;
 	int				level;
 	int				error = 0;
 
@@ -485,6 +518,32 @@ xfs_scrub_agf(
 	xfs_scrub_block_check_ok(sc, sc->sa.agf_bp,
 			agfl_count == 0 || fl_count == agfl_count);
 
+	/* Load btrees for xref if the AGF is ok. */
+	psa = &sc->sa;
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+	error = xfs_scrub_ag_btcur_init(sc, psa);
+	if (error)
+		goto out;
+
+	/* Cross-reference with the bnobt. */
+	while (psa->bno_cur) {
+		error = xfs_alloc_has_record(psa->bno_cur, XFS_AGF_BLOCK(mp),
+				1, &is_freesp);
+		if (!xfs_scrub_should_xref(sc, &error, &psa->bno_cur))
+			break;
+		xfs_scrub_block_xref_check_ok(sc, sc->sa.agf_bp, !is_freesp);
+
+		blocks = 0;
+		error = xfs_alloc_query_all(psa->bno_cur,
+				xfs_scrub_agf_record_bno_lengths, &blocks);
+		if (!xfs_scrub_should_xref(sc, &error, &psa->bno_cur))
+			break;
+		xfs_scrub_block_xref_check_ok(sc, sc->sa.agf_bp,
+				blocks == be32_to_cpu(agf->agf_freeblks));
+		break;
+	}
+
 out:
 	return error;
 }
@@ -506,6 +565,7 @@ xfs_scrub_agfl_block(
 	struct xfs_mount		*mp = sc->mp;
 	xfs_agnumber_t			agno = sc->sa.agno;
 	struct xfs_scrub_agfl		*sagfl = priv;
+	bool				is_freesp;
 	int				error = 0;
 
 	xfs_scrub_block_check_ok(sc, sc->sa.agfl_bp,
@@ -514,6 +574,15 @@ xfs_scrub_agfl_block(
 			agbno < sagfl->eoag &&
 			XFS_AGB_TO_DADDR(mp, agno, agbno) < sagfl->eofs);
 
+	/* Cross-reference with the bnobt. */
+	if (sc->sa.bno_cur) {
+		error = xfs_alloc_has_record(sc->sa.bno_cur, agbno,
+				1, &is_freesp);
+		if (xfs_scrub_should_xref(sc, &error, &sc->sa.bno_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agfl_bp,
+					!is_freesp);
+	}
+
 	return error;
 }
 
@@ -526,6 +595,7 @@ xfs_scrub_agfl(
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_agf			*agf;
 	xfs_agnumber_t			agno;
+	bool				is_freesp;
 	int				error;
 
 	agno = sc->sm->sm_agno;
@@ -539,6 +609,15 @@ xfs_scrub_agfl(
 	sagfl.eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	sagfl.eoag = be32_to_cpu(agf->agf_length);
 
+	/* Cross-reference with the bnobt. */
+	if (sc->sa.bno_cur) {
+		error = xfs_alloc_has_record(sc->sa.bno_cur, XFS_AGFL_BLOCK(mp),
+				1, &is_freesp);
+		if (xfs_scrub_should_xref(sc, &error, &sc->sa.bno_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agfl_bp,
+					!is_freesp);
+	}
+
 	/* Check the blocks in the AGFL. */
 	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sagfl);
 out:
@@ -554,6 +633,7 @@ xfs_scrub_agi(
 {
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_agi			*agi;
+	struct xfs_scrub_ag		*psa;
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			eofs;
 	xfs_agnumber_t			agno;
@@ -562,6 +642,7 @@ xfs_scrub_agi(
 	xfs_agino_t			agino;
 	xfs_agino_t			first_agino;
 	xfs_agino_t			last_agino;
+	bool				is_freesp;
 	int				i;
 	int				level;
 	int				error = 0;
@@ -629,6 +710,23 @@ xfs_scrub_agi(
 				(agino >= first_agino && agino <= last_agino));
 	}
 
+	/* Load btrees for xref if the AGI is ok. */
+	psa = &sc->sa;
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
+	if (error)
+		goto out;
+
+	/* Cross-reference with bnobt. */
+	if (psa->bno_cur) {
+		error = xfs_alloc_has_record(psa->bno_cur, XFS_AGI_BLOCK(mp),
+				1, &is_freesp);
+		if (xfs_scrub_should_xref(sc, &error, &psa->bno_cur))
+			xfs_scrub_block_xref_check_ok(sc, sc->sa.agi_bp,
+					!is_freesp);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 353ed4f..0a427329 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -35,6 +35,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -139,6 +140,7 @@ xfs_scrub_bmap_extent(
 	xfs_daddr_t			dlen;
 	xfs_fsblock_t			bno;
 	xfs_agnumber_t			agno;
+	bool				is_freesp;
 	int				error = 0;
 
 	if (cur)
@@ -181,6 +183,16 @@ xfs_scrub_bmap_extent(
 			goto out;
 	}
 
+	/* Cross-reference with the bnobt. */
+	if (sa.bno_cur) {
+		error = xfs_alloc_has_record(sa.bno_cur, bno,
+				irec->br_blockcount, &is_freesp);
+		if (xfs_scrub_should_xref(info->sc, &error, &sa.bno_cur))
+			xfs_scrub_fblock_xref_check_ok(info->sc,
+					info->whichfork, irec->br_startoff,
+					!is_freesp);
+	}
+
 	xfs_scrub_ag_free(info->sc, &sa);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 4053bb1..5bf4d11 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -387,9 +387,12 @@ xfs_scrub_btree_check_block_owner(
 	struct xfs_scrub_ag		sa = { 0 };
 	struct xfs_scrub_ag		*psa;
 	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+	bool				is_freesp;
 	int				error = 0;
 
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
+	bno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
 
 	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		error = xfs_scrub_ag_init(bs->sc, agno, &sa);
@@ -400,6 +403,14 @@ xfs_scrub_btree_check_block_owner(
 		psa = &bs->sc->sa;
 	}
 
+	/* Cross-reference with the bnobt. */
+	if (psa->bno_cur) {
+		error = xfs_alloc_has_record(psa->bno_cur, bno, 1, &is_freesp);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->bno_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->bno_cur, 0,
+					!is_freesp);
+	}
+
 	if (psa == &sa)
 		xfs_scrub_ag_free(bs->sc, &sa);
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index f422f46..b1cb647 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -36,6 +36,7 @@
 #include "xfs_rmap.h"
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
+#include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -67,18 +68,34 @@ xfs_scrub_iallocbt_chunk(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
+	struct xfs_scrub_ag		*psa;
 	unsigned long long		rec_end;
 	xfs_agblock_t			eoag;
 	xfs_agblock_t			bno;
+	bool				is_freesp;
+	int				error = 0;
 
 	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
 	eoag = be32_to_cpu(agf->agf_length);
 	bno = XFS_AGINO_TO_AGBNO(mp, agino);
 	rec_end = (unsigned long long)bno + len;
 
-	return xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0,
+	if (!xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0,
 			bno < mp->m_sb.sb_agblocks && bno < eoag &&
-			rec_end <= mp->m_sb.sb_agblocks && rec_end <= eoag);
+			rec_end <= mp->m_sb.sb_agblocks && rec_end <= eoag))
+		return false;
+
+	psa = &bs->sc->sa;
+	/* Cross-reference with the bnobt. */
+	if (psa->bno_cur) {
+		error = xfs_alloc_has_record(psa->bno_cur, bno, len,
+				&is_freesp);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->bno_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->bno_cur, 0,
+					!is_freesp);
+	}
+
+	return true;
 }
 
 /* Count the number of free inodes. */
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 86e6759..e0c5a24 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -30,6 +30,7 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -57,10 +58,12 @@ xfs_scrub_refcountbt_helper(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
+	struct xfs_scrub_ag		*psa;
 	struct xfs_refcount_irec	irec;
 	unsigned long long		rec_end;
 	xfs_agblock_t			eoag;
 	bool				has_cowflag;
+	bool				is_freesp;
 	int				error = 0;
 
 	irec.rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
@@ -83,6 +86,16 @@ xfs_scrub_refcountbt_helper(
 			rec_end <= eoag &&
 			irec.rc_refcount >= 1);
 
+	psa = &bs->sc->sa;
+	/* Cross-reference with the bnobt. */
+	if (psa->bno_cur) {
+		error = xfs_alloc_has_record(psa->bno_cur, irec.rc_startblock,
+				irec.rc_blockcount, &is_freesp);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->bno_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->bno_cur, 0,
+					!is_freesp);
+	}
+
 	return error;
 }
 
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 7331ecf..ecb948a 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -30,6 +30,7 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -57,9 +58,11 @@ xfs_scrub_rmapbt_helper(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
+	struct xfs_scrub_ag		*psa;
 	struct xfs_rmap_irec		irec;
 	unsigned long long		rec_end;
 	xfs_agblock_t			eoag;
+	bool				is_freesp;
 	bool				non_inode;
 	bool				is_unwritten;
 	bool				is_bmbt;
@@ -113,6 +116,17 @@ xfs_scrub_rmapbt_helper(
 	xfs_scrub_btree_check_ok(bs->sc, bs->cur, 0, !non_inode ||
 			(irec.rm_owner > XFS_RMAP_OWN_MIN &&
 			 irec.rm_owner <= XFS_RMAP_OWN_FS));
+
+	psa = &bs->sc->sa;
+	/* Cross-reference with the bnobt. */
+	if (psa->bno_cur) {
+		error = xfs_alloc_has_record(psa->bno_cur, irec.rm_startblock,
+				irec.rm_blockcount, &is_freesp);
+		if (xfs_scrub_should_xref(bs->sc, &error, &psa->bno_cur))
+			xfs_scrub_btree_xref_check_ok(bs->sc, psa->bno_cur, 0,
+					!is_freesp);
+	}
+
 out:
 	return error;
 }

