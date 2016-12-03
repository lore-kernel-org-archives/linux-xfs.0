Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19830 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756546AbcLCBjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:33 -0500
Subject: [PATCH 33/55] xfs: scrub should cross-reference with the bnobt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:38:49 -0800
Message-ID: <148072912942.12995.9447728497997104497.stgit@birch.djwong.org>
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

When we're scrubbing various btrees, cross-reference the records with
the bnobt to ensure that we don't also think the space is free.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   19 ++++++++
 fs/xfs/libxfs/xfs_alloc.h |    3 +
 fs/xfs/repair/agheader.c  |  106 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/repair/bmap.c      |   14 ++++++
 fs/xfs/repair/btree.c     |  101 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/repair/common.c    |   42 ++++++++++++++++++
 fs/xfs/repair/common.h    |   10 ++++
 fs/xfs/repair/ialloc.c    |   13 ++++++
 fs/xfs/repair/refcount.c  |   17 +++++++
 fs/xfs/repair/rmap.c      |   18 +++++++-
 10 files changed, 340 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1b6bddb..ad8044b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2991,3 +2991,22 @@ xfs_alloc_query_all(
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
index 89a23be..3fd6540 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -237,4 +237,7 @@ int xfs_alloc_query_range(struct xfs_btree_cur *cur,
 int xfs_alloc_query_all(struct xfs_btree_cur *cur, xfs_alloc_query_range_fn fn,
 		void *priv);
 
+int xfs_alloc_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, bool *exist);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/repair/agheader.c b/fs/xfs/repair/agheader.c
index 07087f4..bcb67c9 100644
--- a/fs/xfs/repair/agheader.c
+++ b/fs/xfs/repair/agheader.c
@@ -30,6 +30,7 @@
 #include "xfs_trans.h"
 #include "xfs_trace.h"
 #include "xfs_sb.h"
+#include "xfs_alloc.h"
 #include "repair/common.h"
 
 /* Find the size of the AG, in blocks. */
@@ -113,10 +114,13 @@ xfs_scrub_superblock(
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
 
@@ -136,7 +140,7 @@ xfs_scrub_superblock(
 	 * so there's no point in comparing the two.
 	 */
 	if (agno == 0)
-		goto out;
+		goto btree_xref;
 
 	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
 
@@ -233,6 +237,24 @@ xfs_scrub_superblock(
 	XFS_SCRUB_SB_FEAT(realtime);
 #undef XFS_SCRUB_SB_FEAT
 
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
+			XFS_SCRUB_SB_CHECK(!is_freesp);
+	}
+
 out:
 	return error;
 }
@@ -241,6 +263,19 @@ xfs_scrub_superblock(
 
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
@@ -253,6 +288,7 @@ xfs_scrub_agf(
 {
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	struct xfs_agf			*agf;
+	struct xfs_scrub_ag		*psa;
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			eofs;
 	xfs_agnumber_t			agno;
@@ -262,8 +298,11 @@ xfs_scrub_agf(
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
@@ -335,6 +374,31 @@ xfs_scrub_agf(
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
+		XFS_SCRUB_AGF_CHECK(!is_freesp);
+
+		blocks = 0;
+		err2 = xfs_alloc_query_all(psa->bno_cur,
+				xfs_scrub_agf_record_bno_lengths, &blocks);
+		if (!xfs_scrub_should_xref(sc, err2, &psa->bno_cur))
+			goto skip_bnobt;
+		XFS_SCRUB_AGF_CHECK(blocks == be32_to_cpu(agf->agf_freeblks));
+	}
+skip_bnobt:
+
 out:
 	return error;
 }
@@ -360,12 +424,22 @@ xfs_scrub_agfl_block(
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
+			XFS_SCRUB_AGFL_CHECK(!is_freesp);
+	}
+
 	return 0;
 }
 
@@ -380,7 +454,9 @@ xfs_scrub_agfl(
 	struct xfs_scrub_agfl		sagfl;
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	struct xfs_agf			*agf;
+	bool				is_freesp;
 	int				error;
+	int				err2;
 
 	error = xfs_scrub_load_ag_headers(sc, sc->sm->sm_agno,
 			XFS_SCRUB_TYPE_AGFL);
@@ -392,6 +468,14 @@ xfs_scrub_agfl(
 	sagfl.eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	sagfl.eoag = be32_to_cpu(agf->agf_length);
 
+	/* Cross-reference with the bnobt. */
+	if (sc->sa.bno_cur) {
+		err2 = xfs_alloc_has_record(sc->sa.bno_cur, XFS_AGFL_BLOCK(mp),
+				1, &is_freesp);
+		if (xfs_scrub_should_xref(sc, err2, &sc->sa.bno_cur))
+			XFS_SCRUB_AGFL_CHECK(!is_freesp);
+	}
+
 	/* Check the blocks in the AGFL. */
 	return xfs_scrub_walk_agfl(sc, xfs_scrub_agfl_block, &sagfl);
 out:
@@ -414,6 +498,7 @@ xfs_scrub_agi(
 {
 	struct xfs_mount		*mp = sc->tp->t_mountp;
 	struct xfs_agi			*agi;
+	struct xfs_scrub_ag		*psa;
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			eofs;
 	xfs_agnumber_t			agno;
@@ -422,9 +507,11 @@ xfs_scrub_agi(
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
@@ -490,8 +577,23 @@ xfs_scrub_agi(
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
+			XFS_SCRUB_AGI_CHECK(!is_freesp);
+	}
+
 out:
 	return error;
 }
 #undef XFS_SCRUB_AGI_CHECK
-#undef XFS_SCRUB_AGI_OP_ERROR_GOTO
diff --git a/fs/xfs/repair/bmap.c b/fs/xfs/repair/bmap.c
index 2550228..d81214a 100644
--- a/fs/xfs/repair/bmap.c
+++ b/fs/xfs/repair/bmap.c
@@ -36,6 +36,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -77,7 +78,10 @@ xfs_scrub_bmap_extent(
 	xfs_daddr_t			daddr;
 	xfs_daddr_t			dlen;
 	xfs_agnumber_t			agno;
+	xfs_fsblock_t			bno;
+	bool				is_freesp;
 	int				error = 0;
+	int				err2 = 0;
 
 	if (cur)
 		xfs_btree_get_block(cur, 0, &bp);
@@ -94,10 +98,12 @@ xfs_scrub_bmap_extent(
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
 	XFS_SCRUB_BMAP_CHECK(daddr < info->eofs);
@@ -115,6 +121,14 @@ xfs_scrub_bmap_extent(
 		XFS_SCRUB_BMAP_OP_ERROR_GOTO(out);
 	}
 
+	/* Cross-reference with the bnobt. */
+	if (sa.bno_cur) {
+		err2 = xfs_alloc_has_record(sa.bno_cur, bno,
+				irec->br_blockcount, &is_freesp);
+		if (xfs_scrub_should_xref(info->sc, err2, &sa.bno_cur))
+			XFS_SCRUB_BMAP_CHECK(!is_freesp);
+	}
+
 	xfs_scrub_ag_free(&sa);
 out:
 	info->lastoff = irec->br_startoff + irec->br_blockcount;
diff --git a/fs/xfs/repair/btree.c b/fs/xfs/repair/btree.c
index 9502844..ed6628f 100644
--- a/fs/xfs/repair/btree.c
+++ b/fs/xfs/repair/btree.c
@@ -494,6 +494,93 @@ xfs_scrub_btree_sblock_check_siblings(
 	return error;
 }
 
+struct check_owner {
+	struct list_head	list;
+	xfs_fsblock_t		fsb;
+};
+
+/*
+ * Make sure this btree block isn't in the free list and that there's
+ * an rmap record for it.
+ */
+STATIC int
+xfs_scrub_btree_check_block_owner(
+	struct xfs_scrub_btree		*bs,
+	xfs_fsblock_t			fsb)
+{
+	struct xfs_scrub_ag		sa;
+	struct xfs_scrub_ag		*psa;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+	bool				is_freesp;
+	int				error = 0;
+	int				err2;
+
+	agno = XFS_FSB_TO_AGNO(bs->cur->bc_mp, fsb);
+	bno = XFS_FSB_TO_AGBNO(bs->cur->bc_mp, fsb);
+
+	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (!xfs_scrub_ag_can_lock(bs->sc, agno))
+			return -EDEADLOCK;
+		error = xfs_scrub_ag_init(bs->sc, agno, &sa);
+		if (error)
+			return error;
+		psa = &sa;
+	} else
+		psa = &bs->sc->sa;
+
+	/* Check that this block isn't free. */
+	if (psa->bno_cur) {
+		err2 = xfs_alloc_has_record(psa->bno_cur, bno, 1, &is_freesp);
+		if (xfs_scrub_btree_should_xref(bs, err2, NULL))
+			XFS_SCRUB_BTREC_CHECK(bs, !is_freesp);
+	}
+
+	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		xfs_scrub_ag_free(&sa);
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
+	struct check_owner		*co;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) && bp == NULL)
+		return 0;
+
+	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+	agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
+
+	/* Turn back if we could deadlock. */
+	if ((bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
+	    !xfs_scrub_ag_can_lock(bs->sc, agno))
+		return -EDEADLOCK;
+
+	/*
+	 * We want to cross-reference each btree block with the bnobt
+	 * and the rmapbt.  We cannot cross-reference the bnobt or
+	 * rmapbt while scanning the bnobt or rmapbt, respectively,
+	 * because that would trash the cursor state.  Therefore, save
+	 * the block numbers for later scanning.
+	 */
+	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
+		co = kmem_alloc(sizeof(struct check_owner), KM_SLEEP | KM_NOFS);
+		co->fsb = fsbno;
+		list_add_tail(&co->list, &bs->to_check);
+		return 0;
+	}
+
+	return xfs_scrub_btree_check_block_owner(bs, fsbno);
+}
+
 /* Grab and scrub a btree block. */
 STATIC int
 xfs_scrub_btree_block(
@@ -514,6 +601,10 @@ xfs_scrub_btree_block(
 	if (error)
 		return error;
 
+	error = xfs_scrub_btree_check_owner(bs, *pbp);
+	if (error)
+		return error;
+
 	return bs->check_siblings_fn(bs, *pblock);
 }
 
@@ -539,6 +630,8 @@ xfs_scrub_btree(
 	struct xfs_btree_block		*block;
 	int				level;
 	struct xfs_buf			*bp;
+	struct check_owner		*co;
+	struct check_owner		*n;
 	int				i;
 	int				error = 0;
 
@@ -653,6 +746,14 @@ xfs_scrub_btree(
 		}
 	}
 
+	/* Process deferred owner checks on btree blocks. */
+	list_for_each_entry_safe(co, n, &bs.to_check, list) {
+		if (!error)
+			error = xfs_scrub_btree_check_block_owner(&bs, co->fsb);
+		list_del(&co->list);
+		kmem_free(co);
+	}
+
 out_badcursor:
 	return error;
 }
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index a35a962..8c69ac4 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -538,6 +538,48 @@ xfs_scrub_ag_lock_all(
 	return error;
 }
 
+/*
+ * Predicate that decides if we need to evaluate the cross-reference check.
+ * If there was an error accessing the cross-reference btree, just delete
+ * the cursor and skip the check.
+ */
+bool
+__xfs_scrub_should_xref(
+	struct xfs_scrub_context	*sc,
+	int				error,
+	struct xfs_btree_cur		**curpp,
+	const char			*func,
+	int				line)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+
+	/* If not a btree cross-reference, just check the error code. */
+	if (curpp == NULL) {
+		if (error == 0)
+			return true;
+		trace_xfs_scrub_xref_error(mp, "unknown", error, func, line);
+		return false;
+	}
+
+	ASSERT(*curpp != NULL);
+	/* If no error or we've already given up on xref, just bail out. */
+	if (error == 0 || *curpp == NULL)
+		return true;
+
+	/* xref error, delete cursor and bail out. */
+	sc->sm->sm_flags |= XFS_SCRUB_FLAG_XREF_FAIL;
+	trace_xfs_scrub_xref_error(mp, btree_types[(*curpp)->bc_btnum],
+			error, func, line);
+	xfs_btree_del_cursor(*curpp, XFS_BTREE_ERROR);
+	*curpp = NULL;
+
+	return false;
+}
+#define xfs_scrub_should_xref(sc, error, curpp) \
+	__xfs_scrub_should_xref((sc), (error), (curpp), __func__, __LINE__)
+#define xfs_scrub_btree_should_xref(bs, error, curpp) \
+	__xfs_scrub_should_xref((bs)->sc, (error), (curpp), __func__, __LINE__)
+
 /* Dummy scrubber */
 
 STATIC int
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index 13986cd..fbde19c 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -179,6 +179,14 @@ bool xfs_scrub_data_ok(struct xfs_scrub_context *sc, int whichfork,
 			goto label; \
 	} while(0)
 
+bool __xfs_scrub_should_xref(struct xfs_scrub_context *sc, int error,
+			     struct xfs_btree_cur **curpp, const char *func,
+			     int line);
+#define xfs_scrub_should_xref(sc, error, curpp) \
+	__xfs_scrub_should_xref((sc), (error), (curpp), __func__, __LINE__)
+#define xfs_scrub_btree_should_xref(bs, error, curpp) \
+	__xfs_scrub_should_xref((bs)->sc, (error), (curpp), __func__, __LINE__)
+
 bool xfs_scrub_ag_can_lock(struct xfs_scrub_context *sc, xfs_agnumber_t agno);
 int xfs_scrub_ag_lock_all(struct xfs_scrub_context *sc);
 void xfs_scrub_ag_free(struct xfs_scrub_ag *sa);
@@ -188,6 +196,8 @@ int xfs_scrub_ag_btcur_init(struct xfs_scrub_context *sc,
 			    struct xfs_scrub_ag *sa);
 int xfs_scrub_load_ag_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 			      unsigned int type);
+int xfs_scrub_ag_btcur_init(struct xfs_scrub_context *sc,
+			    struct xfs_scrub_ag *sa);
 
 int xfs_scrub_walk_agfl(struct xfs_scrub_context *sc,
 			int (*fn)(struct xfs_scrub_context *, xfs_agblock_t bno,
diff --git a/fs/xfs/repair/ialloc.c b/fs/xfs/repair/ialloc.c
index 33d9458..70fc5fc 100644
--- a/fs/xfs/repair/ialloc.c
+++ b/fs/xfs/repair/ialloc.c
@@ -35,6 +35,7 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_icache.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -51,9 +52,12 @@ xfs_scrub_iallocbt_chunk(
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
@@ -72,6 +76,15 @@ xfs_scrub_iallocbt_chunk(
 		goto out;
 	}
 
+	psa = &bs->sc->sa;
+	/* Cross-reference with the bnobt. */
+	if (psa->bno_cur) {
+		err2 = xfs_alloc_has_record(psa->bno_cur, bno, len,
+				&is_freesp);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->bno_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !is_freesp);
+	}
+
 out:
 	return error;
 }
diff --git a/fs/xfs/repair/refcount.c b/fs/xfs/repair/refcount.c
index 740888b..f5c0aef 100644
--- a/fs/xfs/repair/refcount.c
+++ b/fs/xfs/repair/refcount.c
@@ -31,6 +31,7 @@
 #include "xfs_trace.h"
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
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
+			XFS_SCRUB_BTREC_CHECK(bs, !is_freesp);
+	}
+
+out:
 	return error;
 }
 
diff --git a/fs/xfs/repair/rmap.c b/fs/xfs/repair/rmap.c
index d84bef1..ef2aea5 100644
--- a/fs/xfs/repair/rmap.c
+++ b/fs/xfs/repair/rmap.c
@@ -31,6 +31,7 @@
 #include "xfs_trace.h"
 #include "xfs_sb.h"
 #include "xfs_rmap.h"
+#include "xfs_alloc.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
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
+	/* check there's no record in freesp btrees */
+	if (psa->bno_cur) {
+		err2 = xfs_alloc_has_record(psa->bno_cur, irec.rm_startblock,
+				irec.rm_blockcount, &is_freesp);
+		if (xfs_scrub_btree_should_xref(bs, err2, &psa->bno_cur))
+			XFS_SCRUB_BTREC_CHECK(bs, !is_freesp);
+	}
+
 out:
 	return error;
 }

