Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19773 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdAUIEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:04:11 -0500
Subject: [PATCH 33/55] xfs: scrub should cross-reference with the bnobt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:03:57 -0800
Message-ID: <148498583757.15323.3689141800292064711.stgit@birch.djwong.org>
In-Reply-To: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
References: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When we're scrubbing various btrees, cross-reference the records with
the bnobt to ensure that we don't also think the space is free.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   19 +++++++
 fs/xfs/libxfs/xfs_alloc.h |    3 +
 fs/xfs/scrub/agheader.c   |  117 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/bmap.c       |   21 ++++++++
 fs/xfs/scrub/btree.c      |    9 +++
 fs/xfs/scrub/ialloc.c     |   13 +++++
 fs/xfs/scrub/refcount.c   |   17 +++++++
 fs/xfs/scrub/rmap.c       |   18 +++++++
 8 files changed, 214 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5384d88..2c471bb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2932,3 +2932,22 @@ xfs_alloc_query_all(
 	query.fn = fn;
 	return xfs_btree_query_all(cur, xfs_alloc_query_range_helper, &query);
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
index 1e7e2e2..c24fe03 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -237,4 +237,7 @@ int xfs_alloc_query_range(struct xfs_btree_cur *cur,
 int xfs_alloc_query_all(struct xfs_btree_cur *cur, xfs_alloc_query_range_fn fn,
 		void *priv);
 
+int xfs_alloc_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, bool *exist);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 374157f..eda4abd 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -31,6 +31,7 @@
 #include "xfs_trace.h"
 #include "xfs_sb.h"
 #include "xfs_inode.h"
+#include "xfs_alloc.h"
 #include "scrub/common.h"
 
 /* Set us up to check an AG header. */
@@ -122,6 +123,8 @@ xfs_scrub_walk_agfl(
 	XFS_SCRUB_PREEN(sc, bp, "superblock", fs_ok)
 #define XFS_SCRUB_SB_OP_ERROR_GOTO(label) \
 	XFS_SCRUB_OP_ERROR_GOTO(sc, agno, 0, "superblock", &error, out)
+#define XFS_SCRUB_SB_XCHECK(fs_ok) \
+	XFS_SCRUB_XCHECK(sc, bp, "superblock", fs_ok)
 /* Scrub the filesystem superblock. */
 int
 xfs_scrub_superblock(
@@ -129,10 +132,13 @@ xfs_scrub_superblock(
 {
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	struct xfs_buf			*bp;
+	struct xfs_scrub_ag		*psa;
 	struct xfs_sb			sb;
 	xfs_agnumber_t			agno;
 	uint32_t			v2_ok;
+	bool				is_freesp;
 	int				error;
+	int				err2;
 
 	agno = sc->sm->sm_agno;
 
@@ -152,7 +158,7 @@ xfs_scrub_superblock(
 	 * so there's no point in comparing the two.
 	 */
 	if (agno == 0)
-		goto out;
+		goto btree_xref;
 
 	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
 
@@ -258,19 +264,53 @@ xfs_scrub_superblock(
 	XFS_SCRUB_SB_FEAT_PREEN(attr2);
 #undef XFS_SCRUB_SB_FEAT_PREEN
 
+	if (error)
+		goto out;
+
+btree_xref:
+
+	err2 = xfs_scrub_ag_init(sc, agno, &sc->sa);
+	if (!xfs_scrub_should_xref(sc, err2, NULL))
+		goto out;
+
+	psa = &sc->sa;
+	/* Cross-reference with bnobt. */
+	if (psa->bno_cur) {
+		err2 = xfs_alloc_has_record(psa->bno_cur, XFS_SB_BLOCK(mp),
+				1, &is_freesp);
+		if (xfs_scrub_should_xref(sc, err2, &psa->bno_cur))
+			XFS_SCRUB_SB_XCHECK(!is_freesp);
+	}
+
 out:
 	return error;
 }
+#undef XFS_SCRUB_SB_XCHECK
 #undef XFS_SCRUB_SB_OP_ERROR_GOTO
 #undef XFS_SCRUB_SB_CHECK
 
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
 #define XFS_SCRUB_AGF_CHECK(fs_ok) \
 	XFS_SCRUB_CHECK(sc, sc->sa.agf_bp, "AGF", fs_ok)
 #define XFS_SCRUB_AGF_OP_ERROR_GOTO(error, label) \
 	XFS_SCRUB_OP_ERROR_GOTO(sc, sc->sm->sm_agno, \
 			XFS_AGF_BLOCK(sc->tp->t_mountp), "AGF", error, label)
+#define XFS_SCRUB_AGF_XCHECK(fs_ok) \
+	XFS_SCRUB_XCHECK(sc, sc->sa.agf_bp, "AGF", fs_ok)
 /* Scrub the AGF. */
 int
 xfs_scrub_agf(
@@ -278,6 +318,7 @@ xfs_scrub_agf(
 {
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	struct xfs_agf			*agf;
+	struct xfs_scrub_ag		*psa;
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			eofs;
 	xfs_agnumber_t			agno;
@@ -287,8 +328,11 @@ xfs_scrub_agf(
 	xfs_agblock_t			agfl_last;
 	xfs_agblock_t			agfl_count;
 	xfs_agblock_t			fl_count;
+	xfs_extlen_t			blocks;
+	bool				is_freesp;
 	int				level;
 	int				error = 0;
+	int				err2;
 
 	agno = sc->sm->sm_agno;
 	error = xfs_scrub_load_ag_headers(sc, agno, XFS_SCRUB_TYPE_AGF);
@@ -360,9 +404,35 @@ xfs_scrub_agf(
 		fl_count = XFS_AGFL_SIZE(mp) - agfl_first + agfl_last + 1;
 	XFS_SCRUB_AGF_CHECK(agfl_count == 0 || fl_count == agfl_count);
 
+	/* Load btrees for xref if the AGF is ok. */
+	psa = &sc->sa;
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_FLAG_CORRUPT))
+		goto out;
+	error = xfs_scrub_ag_btcur_init(sc, psa);
+	if (error)
+		goto out;
+
+	/* Cross-reference with the bnobt. */
+	if (psa->bno_cur) {
+		err2 = xfs_alloc_has_record(psa->bno_cur, XFS_AGF_BLOCK(mp),
+				1, &is_freesp);
+		if (!xfs_scrub_should_xref(sc, err2, &psa->bno_cur))
+			goto skip_bnobt;
+		XFS_SCRUB_AGF_XCHECK(!is_freesp);
+
+		blocks = 0;
+		err2 = xfs_alloc_query_all(psa->bno_cur,
+				xfs_scrub_agf_record_bno_lengths, &blocks);
+		if (!xfs_scrub_should_xref(sc, err2, &psa->bno_cur))
+			goto skip_bnobt;
+		XFS_SCRUB_AGF_XCHECK(blocks == be32_to_cpu(agf->agf_freeblks));
+	}
+skip_bnobt:
+
 out:
 	return error;
 }
+#undef XFS_SCRUB_AGF_XCHECK
 #undef XFS_SCRUB_AGF_OP_ERROR_GOTO
 #undef XFS_SCRUB_AGF_CHECK
 
@@ -370,6 +440,8 @@ xfs_scrub_agf(
 
 #define XFS_SCRUB_AGFL_CHECK(fs_ok) \
 	XFS_SCRUB_CHECK(sc, sc->sa.agfl_bp, "AGFL", fs_ok)
+#define XFS_SCRUB_AGFL_XCHECK(fs_ok) \
+	XFS_SCRUB_XCHECK(sc, sc->sa.agfl_bp, "AGFL", fs_ok)
 struct xfs_scrub_agfl {
 	xfs_agblock_t			eoag;
 	xfs_daddr_t			eofs;
@@ -385,12 +457,22 @@ xfs_scrub_agfl_block(
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	xfs_agnumber_t			agno = sc->sa.agno;
 	struct xfs_scrub_agfl		*sagfl = priv;
+	bool				is_freesp;
+	int				err2;
 
 	XFS_SCRUB_AGFL_CHECK(agbno > XFS_AGI_BLOCK(mp));
 	XFS_SCRUB_AGFL_CHECK(XFS_AGB_TO_DADDR(mp, agno, agbno) < sagfl->eofs);
 	XFS_SCRUB_AGFL_CHECK(agbno < mp->m_sb.sb_agblocks);
 	XFS_SCRUB_AGFL_CHECK(agbno < sagfl->eoag);
 
+	/* Cross-reference with the bnobt. */
+	if (sc->sa.bno_cur) {
+		err2 = xfs_alloc_has_record(sc->sa.bno_cur, agbno,
+				1, &is_freesp);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.bno_cur))
+			XFS_SCRUB_AGFL_XCHECK(!is_freesp);
+	}
+
 	return 0;
 }
 
@@ -405,7 +487,9 @@ xfs_scrub_agfl(
 	struct xfs_scrub_agfl		sagfl;
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	struct xfs_agf			*agf;
+	bool				is_freesp;
 	int				error;
+	int				err2;
 
 	error = xfs_scrub_load_ag_headers(sc, sc->sm->sm_agno,
 			XFS_SCRUB_TYPE_AGFL);
@@ -417,12 +501,21 @@ xfs_scrub_agfl(
 	sagfl.eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	sagfl.eoag = be32_to_cpu(agf->agf_length);
 
+	/* Cross-reference with the bnobt. */
+	if (sc->sa.bno_cur) {
+		err2 = xfs_alloc_has_record(sc->sa.bno_cur, XFS_AGFL_BLOCK(mp),
+				1, &is_freesp);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.bno_cur))
+			XFS_SCRUB_AGFL_XCHECK(!is_freesp);
+	}
+
 	/* Check the blocks in the AGFL. */
 	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sagfl);
 out:
 	return error;
 }
 #undef XFS_SCRUB_AGFL_OP_ERROR_GOTO
+#undef XFS_SCRUB_AGFL_XCHECK
 #undef XFS_SCRUB_AGFL_CHECK
 
 /* AGI */
@@ -432,6 +525,8 @@ xfs_scrub_agfl(
 #define XFS_SCRUB_AGI_OP_ERROR_GOTO(error, label) \
 	XFS_SCRUB_OP_ERROR_GOTO(sc, sc->sm->sm_agno, \
 			XFS_AGI_BLOCK(sc->tp->t_mountp), "AGI", error, label)
+#define XFS_SCRUB_AGI_XCHECK(fs_ok) \
+	XFS_SCRUB_XCHECK(sc, sc->sa.agi_bp, "AGI", fs_ok)
 /* Scrub the AGI. */
 int
 xfs_scrub_agi(
@@ -439,6 +534,7 @@ xfs_scrub_agi(
 {
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	struct xfs_agi			*agi;
+	struct xfs_scrub_ag		*psa;
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			eofs;
 	xfs_agnumber_t			agno;
@@ -447,9 +543,11 @@ xfs_scrub_agi(
 	xfs_agino_t			agino;
 	xfs_agino_t			first_agino;
 	xfs_agino_t			last_agino;
+	bool				is_freesp;
 	int				i;
 	int				level;
 	int				error = 0;
+	int				err2;
 
 	agno = sc->sm->sm_agno;
 	error = xfs_scrub_load_ag_headers(sc, agno, XFS_SCRUB_TYPE_AGI);
@@ -515,8 +613,25 @@ xfs_scrub_agi(
 		XFS_SCRUB_AGI_CHECK(agino <= last_agino);
 	}
 
+	/* Load btrees for xref if the AGI is ok. */
+	psa = &sc->sa;
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_FLAG_CORRUPT))
+		goto out;
+	error = xfs_scrub_ag_btcur_init(sc, &sc->sa);
+	if (error)
+		goto out;
+
+	/* Cross-reference with bnobt. */
+	if (psa->bno_cur) {
+		err2 = xfs_alloc_has_record(psa->bno_cur, XFS_AGI_BLOCK(mp),
+				1, &is_freesp);
+		if (xfs_scrub_should_xref(sc, err2, &psa->bno_cur))
+			XFS_SCRUB_AGI_XCHECK(!is_freesp);
+	}
+
 out:
 	return error;
 }
+#undef XFS_SCRUB_AGI_XCHECK
 #undef XFS_SCRUB_AGI_CHECK
 #undef XFS_SCRUB_AGI_OP_ERROR_GOTO
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 87ee945..0f860ea 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -36,6 +36,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
 
@@ -85,6 +86,10 @@ struct xfs_scrub_bmap_info {
 	XFS_SCRUB_INO_GOTO(info->sc, info->sc->ip->i_ino, bp, info->type, fs_ok, label)
 #define XFS_SCRUB_BMAP_OP_ERROR_GOTO(label) \
 	XFS_SCRUB_OP_ERROR_GOTO(info->sc, agno, 0, "bmap", &error, label);
+#define XFS_SCRUB_BMAP_OP_ERROR_XGOTO(label) \
+	XFS_SCRUB_OP_ERROR_XGOTO(info->sc, agno, 0, "bmap", &error, label);
+#define XFS_SCRUB_BMAP_XCHECK(fs_ok) \
+	XFS_SCRUB_INO_XCHECK(info->sc, info->sc->ip->i_ino, bp, info->type, fs_ok)
 /* Scrub a single extent record. */
 STATIC int
 xfs_scrub_bmap_extent(
@@ -99,7 +104,10 @@ xfs_scrub_bmap_extent(
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			dlen;
 	xfs_agnumber_t			agno;
+	xfs_fsblock_t			bno;
+	bool				is_freesp;
 	int				error = 0;
+	int				err2 = 0;
 
 	if (cur)
 		xfs_btree_get_block(cur, 0, &bp);
@@ -112,10 +120,12 @@ xfs_scrub_bmap_extent(
 	if (info->is_rt) {
 		daddr = XFS_FSB_TO_BB(mp, irec->br_startblock);
 		agno = NULLAGNUMBER;
+		bno = irec->br_startblock;
 	} else {
 		daddr = XFS_FSB_TO_DADDR(mp, irec->br_startblock);
 		agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
 		XFS_SCRUB_BMAP_GOTO(agno < mp->m_sb.sb_agcount, out);
+		bno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
 	}
 	dlen = XFS_FSB_TO_BB(mp, irec->br_blockcount);
 	XFS_SCRUB_BMAP_CHECK(agno < mp->m_sb.sb_agcount);
@@ -134,7 +144,15 @@ xfs_scrub_bmap_extent(
 		if (!xfs_scrub_ag_can_lock(info->sc, agno))
 			return -EDEADLOCK;
 		error = xfs_scrub_ag_init(info->sc, agno, &sa);
-		XFS_SCRUB_BMAP_OP_ERROR_GOTO(out);
+		XFS_SCRUB_BMAP_OP_ERROR_XGOTO(out);
+	}
+
+	/* Cross-reference with the bnobt. */
+	if (sa.bno_cur) {
+		err2 = xfs_alloc_has_record(sa.bno_cur, bno,
+				irec->br_blockcount, &is_freesp);
+		if (xfs_scrub_should_xref(info->sc, err2, &sa.bno_cur))
+			XFS_SCRUB_BMAP_XCHECK(!is_freesp);
 	}
 
 	xfs_scrub_ag_free(&sa);
@@ -179,6 +197,7 @@ xfs_scrub_bmapbt_helper(
 	xfs_bmbt_get_all(&ihost, &irec);
 	return xfs_scrub_bmap_extent(ip, bs->cur, info, &irec);
 }
+#undef XFS_SCRUB_BMAP_XCHECK
 #undef XFS_SCRUB_BMAP_CHECK
 
 #define XFS_SCRUB_FORK_CHECK(fs_ok) \
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 9ea0fbe..30360e0 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -514,7 +514,9 @@ xfs_scrub_btree_check_block_owner(
 	struct xfs_scrub_ag		*psa;
 	xfs_agnumber_t			agno;
 	xfs_agblock_t			bno;
+	bool				is_freesp;
 	int				error = 0;
+	int				err2;
 
 	agno = XFS_FSB_TO_AGNO(bs->cur->bc_mp, fsb);
 	bno = XFS_FSB_TO_AGBNO(bs->cur->bc_mp, fsb);
@@ -529,6 +531,13 @@ xfs_scrub_btree_check_block_owner(
 	} else
 		psa = &bs->sc->sa;
 
+	/* Cross-reference with the bnobt. */
+	if (psa->bno_cur) {
+		err2 = xfs_alloc_has_record(psa->bno_cur, bno, 1, &is_freesp);
+		if (xfs_scrub_btree_should_xref(bs, err2, NULL))
+			XFS_SCRUB_BTREC_XCHECK(bs, !is_freesp);
+	}
+
 	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		xfs_scrub_ag_free(&sa);
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 0c654c9..69d9e77 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -37,6 +37,7 @@
 #include "xfs_rmap.h"
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
+#include "xfs_alloc.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
 
@@ -83,9 +84,12 @@ xfs_scrub_iallocbt_chunk(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
+	struct xfs_scrub_ag		*psa;
 	xfs_agblock_t			eoag;
 	xfs_agblock_t			bno;
+	bool				is_freesp;
 	int				error = 0;
+	int				err2;
 
 	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
 	eoag = be32_to_cpu(agf->agf_length);
@@ -104,6 +108,15 @@ xfs_scrub_iallocbt_chunk(
 		goto out;
 	}
 
+	psa = &bs->sc->sa;
+	/* Cross-reference with the bnobt. */
+	if (psa->bno_cur) {
+		err2 = xfs_alloc_has_record(psa->bno_cur, bno, len,
+				&is_freesp);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->bno_cur))
+			XFS_SCRUB_BTREC_XCHECK(bs, !is_freesp);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index f7ceba9..b371a58 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -31,6 +31,7 @@
 #include "xfs_trace.h"
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
 
@@ -44,10 +45,13 @@ xfs_scrub_refcountbt_helper(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
+	struct xfs_scrub_ag		*psa;
 	struct xfs_refcount_irec	irec;
 	xfs_agblock_t			eoag;
 	bool				has_cowflag;
+	bool				is_freesp;
 	int				error = 0;
+	int				err2;
 
 	irec.rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
 	irec.rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
@@ -69,6 +73,19 @@ xfs_scrub_refcountbt_helper(
 			irec.rc_blockcount <= eoag);
 	XFS_SCRUB_BTREC_CHECK(bs, irec.rc_refcount >= 1);
 
+	if (error)
+		goto out;
+
+	psa = &bs->sc->sa;
+	/* Cross-reference with the bnobt. */
+	if (psa->bno_cur) {
+		err2 = xfs_alloc_has_record(psa->bno_cur, irec.rc_startblock,
+				irec.rc_blockcount, &is_freesp);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->bno_cur))
+			XFS_SCRUB_BTREC_XCHECK(bs, !is_freesp);
+	}
+
+out:
 	return error;
 }
 
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index bb94260..f92ddad 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -31,6 +31,7 @@
 #include "xfs_trace.h"
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
 
@@ -44,13 +45,16 @@ xfs_scrub_rmapbt_helper(
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_agf			*agf;
+	struct xfs_scrub_ag		*psa;
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
 	XFS_SCRUB_BTREC_OP_ERROR_GOTO(bs, &error, out);
@@ -99,6 +103,18 @@ xfs_scrub_rmapbt_helper(
 	XFS_SCRUB_BTREC_CHECK(bs, !non_inode ||
 			(irec.rm_owner > XFS_RMAP_OWN_MIN &&
 			 irec.rm_owner <= XFS_RMAP_OWN_FS));
+	if (error)
+		goto out;
+
+	psa = &bs->sc->sa;
+	/* Cross-reference with the bnobt. */
+	if (psa->bno_cur) {
+		err2 = xfs_alloc_has_record(psa->bno_cur, irec.rm_startblock,
+				irec.rm_blockcount, &is_freesp);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->bno_cur))
+			XFS_SCRUB_BTREC_XCHECK(bs, !is_freesp);
+	}
+
 out:
 	return error;
 }

