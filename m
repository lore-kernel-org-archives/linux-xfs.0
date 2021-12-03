Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E3B1C4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Dec 2021 00:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377745AbhLCAEt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:04:49 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:56446 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377736AbhLCAEs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:48 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 7B71E606ABA
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:16 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00G1KR-KT
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00Bkh5-It
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/36] xfs: Pre-calculate per-AG agbno geometry
Date:   Fri,  3 Dec 2021 11:00:46 +1100
Message-Id: <20211203000111.2800982-12-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61a95e4c
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=_Pyvntc1yrSeCOnvVKIA:9
        a=W1BubcHRaAuuSv8Q:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There is a lot of overhead in functions like xfs_verify_agbno() that
repeatedly calculate the geometry limits of an AG. These can be
pre-calculated as they are static and the verification context has
a per-ag context it can quickly reference.

In the case of xfs_verify_agbno(), we now always have a perag
context handy, so we can store the AG length and the minimum valid
block in the AG in the perag. This means we don't have to calculate
it on every call and it can be inlined in callers if we move it
to xfs_ag.h.

Move xfs_ag_block_count() to xfs_ag.c because it's really a
per-ag function and not an XFS type function. We need a little
bit of rework that is specific to xfs_initialise_perag() to allow
growfs to calculate the new perag sizes before we've updated the
primary superblock during the grow (chicken/egg situation).

Note that we leave the original xfs_verify_agbno in place in
xfs_types.c as a static function as other callers in that file do
not have per-ag contexts so still need to go the long way. It's been
renamed to xfs_verify_agno_agbno() to indicate it takes both an agno
and an agbno to differentiate it from new function.

Future commits will make similar changes for other per-ag geometry
validation functions.

Further:

$ size --totals fs/xfs/built-in.a
	   text    data     bss     dec     hex filename
before	1137325  322835     484 1460644  1649a4 (TOTALS)
after	1136681  322835     484 1460000  164720 (TOTALS)

This rework reduces the binary size by ~650 bytes, indicating
that much less work is being done to bounds check the agbno values
against on per-ag geometry information.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c         | 40 +++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_ag.h         | 21 +++++++++++++++++-
 fs/xfs/libxfs/xfs_alloc.c      |  9 ++++----
 fs/xfs/libxfs/xfs_btree.c      |  6 ++---
 fs/xfs/libxfs/xfs_refcount.c   | 13 +++++------
 fs/xfs/libxfs/xfs_rmap.c       |  8 +++----
 fs/xfs/libxfs/xfs_types.c      | 18 +++------------
 fs/xfs/libxfs/xfs_types.h      |  3 ---
 fs/xfs/scrub/agheader.c        | 19 ++++++++--------
 fs/xfs/scrub/agheader_repair.c |  7 ++----
 fs/xfs/scrub/alloc.c           |  7 +++---
 fs/xfs/scrub/ialloc.c          |  6 ++---
 fs/xfs/scrub/refcount.c        |  7 +++---
 fs/xfs/scrub/rmap.c            |  6 ++---
 fs/xfs/xfs_fsops.c             |  2 +-
 fs/xfs/xfs_log_recover.c       |  3 ++-
 fs/xfs/xfs_mount.c             |  3 ++-
 17 files changed, 108 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index a357ac6bc4ad..d6af12d2510b 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -202,10 +202,35 @@ xfs_free_perag(
 	}
 }
 
+/* Find the size of the AG, in blocks. */
+static xfs_agblock_t
+__xfs_ag_block_count(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agnumber_t		agcount,
+	xfs_rfsblock_t		dblocks)
+{
+	ASSERT(agno < agcount);
+
+	if (agno < agcount - 1)
+		return mp->m_sb.sb_agblocks;
+	return dblocks - (agno * mp->m_sb.sb_agblocks);
+}
+
+xfs_agblock_t
+xfs_ag_block_count(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	return __xfs_ag_block_count(mp, agno, mp->m_sb.sb_agcount,
+			mp->m_sb.sb_dblocks);
+}
+
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agcount,
+	xfs_rfsblock_t		dblocks,
 	xfs_agnumber_t		*maxagi)
 {
 	struct xfs_perag	*pag;
@@ -271,6 +296,13 @@ xfs_initialize_perag(
 		/* first new pag is fully initialized */
 		if (first_initialised == NULLAGNUMBER)
 			first_initialised = index;
+
+		/*
+		 * Pre-calculated geometry
+		 */
+		pag->block_count = __xfs_ag_block_count(mp, index, agcount,
+				dblocks);
+		pag->min_block = XFS_AGFL_BLOCK(mp);
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
@@ -927,10 +959,16 @@ xfs_ag_extend_space(
 	if (error)
 		return error;
 
-	return  xfs_free_extent(tp, XFS_AGB_TO_FSB(pag->pag_mount, pag->pag_agno,
+	error = xfs_free_extent(tp, XFS_AGB_TO_FSB(pag->pag_mount, pag->pag_agno,
 					be32_to_cpu(agf->agf_length) - len),
 				len, &XFS_RMAP_OINFO_SKIP_UPDATE,
 				XFS_AG_RESV_NONE);
+	if (error)
+		return error;
+
+	/* Update perag geometry */
+	pag->block_count = be32_to_cpu(agf->agf_length);
+	return 0;
 }
 
 /* Retrieve AG geometry. */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 1132cda9a92f..77640f1409fd 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -67,6 +67,10 @@ struct xfs_perag {
 	/* for rcu-safe freeing */
 	struct rcu_head	rcu_head;
 
+	/* Precalculated geometry info */
+	xfs_agblock_t		block_count;
+	xfs_agblock_t		min_block;
+
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 
@@ -107,7 +111,7 @@ struct xfs_perag {
 };
 
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
-			xfs_agnumber_t *maxagi);
+			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_free_perag(struct xfs_mount *mp);
 
@@ -116,6 +120,21 @@ struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int tag);
 void xfs_perag_put(struct xfs_perag *pag);
 
+/*
+ * Per-ag geometry infomation and validation
+ */
+xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
+
+static inline bool
+xfs_verify_agbno(struct xfs_perag *pag, xfs_agblock_t agbno)
+{
+	if (agbno >= pag->block_count)
+		return false;
+	if (agbno <= pag->min_block)
+		return false;
+	return true;
+}
+
 /*
  * Perag iteration APIs
  */
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b81d62a4ed5b..c0f345ba198b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -230,7 +230,7 @@ xfs_alloc_get_rec(
 	int			*stat)	/* output: success/failure */
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
+	struct xfs_perag	*pag = cur->bc_ag.pag;
 	union xfs_btree_rec	*rec;
 	int			error;
 
@@ -245,11 +245,11 @@ xfs_alloc_get_rec(
 		goto out_bad_rec;
 
 	/* check for valid extent range, including overflow */
-	if (!xfs_verify_agbno(mp, agno, *bno))
+	if (!xfs_verify_agbno(pag, *bno))
 		goto out_bad_rec;
 	if (*bno > *bno + *len)
 		goto out_bad_rec;
-	if (!xfs_verify_agbno(mp, agno, *bno + *len - 1))
+	if (!xfs_verify_agbno(pag, *bno + *len - 1))
 		goto out_bad_rec;
 
 	return 0;
@@ -257,7 +257,8 @@ xfs_alloc_get_rec(
 out_bad_rec:
 	xfs_warn(mp,
 		"%s Freespace BTree record corruption in AG %d detected!",
-		cur->bc_btnum == XFS_BTNUM_BNO ? "Block" : "Size", agno);
+		cur->bc_btnum == XFS_BTNUM_BNO ? "Block" : "Size",
+		pag->pag_agno);
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", *bno, *len);
 	return -EFSCORRUPTED;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f18a875f51c6..956d895dd4b5 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -216,7 +216,7 @@ xfs_btree_check_sptr(
 {
 	if (level <= 0)
 		return false;
-	return xfs_verify_agbno(cur->bc_mp, cur->bc_ag.pag->pag_agno, agbno);
+	return xfs_verify_agbno(cur->bc_ag.pag, agbno);
 }
 
 /*
@@ -4508,10 +4508,10 @@ xfs_btree_sblock_verify(
 	/* sibling pointer verification */
 	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
 	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_leftsib)))
+	    !xfs_verify_agbno(bp->b_pag, be32_to_cpu(block->bb_u.s.bb_leftsib)))
 		return __this_address;
 	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_rightsib)))
+	    !xfs_verify_agbno(bp->b_pag, be32_to_cpu(block->bb_u.s.bb_rightsib)))
 		return __this_address;
 
 	return NULL;
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index e90a02391906..70795cefe645 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -111,7 +111,7 @@ xfs_refcount_get_rec(
 	int				*stat)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	xfs_agnumber_t			agno = cur->bc_ag.pag->pag_agno;
+	struct xfs_perag		*pag = cur->bc_ag.pag;
 	union xfs_btree_rec		*rec;
 	int				error;
 	xfs_agblock_t			realstart;
@@ -121,8 +121,6 @@ xfs_refcount_get_rec(
 		return error;
 
 	xfs_refcount_btrec_to_irec(rec, irec);
-
-	agno = cur->bc_ag.pag->pag_agno;
 	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
 		goto out_bad_rec;
 
@@ -137,22 +135,23 @@ xfs_refcount_get_rec(
 	}
 
 	/* check for valid extent range, including overflow */
-	if (!xfs_verify_agbno(mp, agno, realstart))
+	if (!xfs_verify_agbno(pag, realstart))
 		goto out_bad_rec;
 	if (realstart > realstart + irec->rc_blockcount)
 		goto out_bad_rec;
-	if (!xfs_verify_agbno(mp, agno, realstart + irec->rc_blockcount - 1))
+	if (!xfs_verify_agbno(pag, realstart + irec->rc_blockcount - 1))
 		goto out_bad_rec;
 
 	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
 		goto out_bad_rec;
 
-	trace_xfs_refcount_get(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
+	trace_xfs_refcount_get(cur->bc_mp, pag->pag_agno, irec);
 	return 0;
 
 out_bad_rec:
 	xfs_warn(mp,
-		"Refcount BTree record corruption in AG %d detected!", agno);
+		"Refcount BTree record corruption in AG %d detected!",
+		pag->pag_agno);
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index cd322174dbff..acbfce36171e 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -201,7 +201,7 @@ xfs_rmap_get_rec(
 	int			*stat)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
+	struct xfs_perag	*pag = cur->bc_ag.pag;
 	union xfs_btree_rec	*rec;
 	int			error;
 
@@ -221,12 +221,12 @@ xfs_rmap_get_rec(
 			goto out_bad_rec;
 	} else {
 		/* check for valid extent range, including overflow */
-		if (!xfs_verify_agbno(mp, agno, irec->rm_startblock))
+		if (!xfs_verify_agbno(pag, irec->rm_startblock))
 			goto out_bad_rec;
 		if (irec->rm_startblock >
 				irec->rm_startblock + irec->rm_blockcount)
 			goto out_bad_rec;
-		if (!xfs_verify_agbno(mp, agno,
+		if (!xfs_verify_agbno(pag,
 				irec->rm_startblock + irec->rm_blockcount - 1))
 			goto out_bad_rec;
 	}
@@ -240,7 +240,7 @@ xfs_rmap_get_rec(
 out_bad_rec:
 	xfs_warn(mp,
 		"Reverse Mapping BTree record corruption in AG %d detected!",
-		agno);
+		pag->pag_agno);
 	xfs_warn(mp,
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index e810d23f2d97..b3c6b0274e95 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -13,25 +13,13 @@
 #include "xfs_mount.h"
 #include "xfs_ag.h"
 
-/* Find the size of the AG, in blocks. */
-inline xfs_agblock_t
-xfs_ag_block_count(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	ASSERT(agno < mp->m_sb.sb_agcount);
-
-	if (agno < mp->m_sb.sb_agcount - 1)
-		return mp->m_sb.sb_agblocks;
-	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
-}
 
 /*
  * Verify that an AG block number pointer neither points outside the AG
  * nor points at static metadata.
  */
-inline bool
-xfs_verify_agbno(
+static inline bool
+xfs_verify_agno_agbno(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno)
@@ -59,7 +47,7 @@ xfs_verify_fsbno(
 
 	if (agno >= mp->m_sb.sb_agcount)
 		return false;
-	return xfs_verify_agbno(mp, agno, XFS_FSB_TO_AGBNO(mp, fsbno));
+	return xfs_verify_agno_agbno(mp, agno, XFS_FSB_TO_AGBNO(mp, fsbno));
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b6da06b40989..b417e8929235 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -186,9 +186,6 @@ enum xfs_ag_resv_type {
  */
 struct xfs_mount;
 
-xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
-bool xfs_verify_agbno(struct xfs_mount *mp, xfs_agnumber_t agno,
-		xfs_agblock_t agbno);
 bool xfs_verify_fsbno(struct xfs_mount *mp, xfs_fsblock_t fsbno);
 bool xfs_verify_fsbext(struct xfs_mount *mp, xfs_fsblock_t fsbno,
 		xfs_fsblock_t len);
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index bed798792226..60d7a7d5ea97 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -542,16 +542,16 @@ xchk_agf(
 
 	/* Check the AG length */
 	eoag = be32_to_cpu(agf->agf_length);
-	if (eoag != xfs_ag_block_count(mp, agno))
+	if (eoag != pag->block_count)
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	/* Check the AGF btree roots and levels */
 	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
-	if (!xfs_verify_agbno(mp, agno, agbno))
+	if (!xfs_verify_agbno(pag, agbno))
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
-	if (!xfs_verify_agbno(mp, agno, agbno))
+	if (!xfs_verify_agbno(pag, agbno))
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
@@ -564,7 +564,7 @@ xchk_agf(
 
 	if (xfs_has_rmapbt(mp)) {
 		agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
-		if (!xfs_verify_agbno(mp, agno, agbno))
+		if (!xfs_verify_agbno(pag, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 		level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
@@ -574,7 +574,7 @@ xchk_agf(
 
 	if (xfs_has_reflink(mp)) {
 		agbno = be32_to_cpu(agf->agf_refcount_root);
-		if (!xfs_verify_agbno(mp, agno, agbno))
+		if (!xfs_verify_agbno(pag, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 		level = be32_to_cpu(agf->agf_refcount_level);
@@ -640,9 +640,8 @@ xchk_agfl_block(
 {
 	struct xchk_agfl_info	*sai = priv;
 	struct xfs_scrub	*sc = sai->sc;
-	xfs_agnumber_t		agno = sc->sa.pag->pag_agno;
 
-	if (xfs_verify_agbno(mp, agno, agbno) &&
+	if (xfs_verify_agbno(sc->sa.pag, agbno) &&
 	    sai->nr_entries < sai->sz_entries)
 		sai->entries[sai->nr_entries++] = agbno;
 	else
@@ -872,12 +871,12 @@ xchk_agi(
 
 	/* Check the AG length */
 	eoag = be32_to_cpu(agi->agi_length);
-	if (eoag != xfs_ag_block_count(mp, agno))
+	if (eoag != pag->block_count)
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	/* Check btree roots and levels */
 	agbno = be32_to_cpu(agi->agi_root);
-	if (!xfs_verify_agbno(mp, agno, agbno))
+	if (!xfs_verify_agbno(pag, agbno))
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	level = be32_to_cpu(agi->agi_level);
@@ -886,7 +885,7 @@ xchk_agi(
 
 	if (xfs_has_finobt(mp)) {
 		agbno = be32_to_cpu(agi->agi_free_root);
-		if (!xfs_verify_agbno(mp, agno, agbno))
+		if (!xfs_verify_agbno(pag, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 		level = be32_to_cpu(agi->agi_free_level);
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 66c33f9d8541..b32bb6bb3bc5 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -94,7 +94,7 @@ xrep_agf_check_agfl_block(
 {
 	struct xfs_scrub	*sc = priv;
 
-	if (!xfs_verify_agbno(mp, sc->sa.pag->pag_agno, agbno))
+	if (!xfs_verify_agbno(sc->sa.pag, agbno))
 		return -EFSCORRUPTED;
 	return 0;
 }
@@ -118,10 +118,7 @@ xrep_check_btree_root(
 	struct xfs_scrub		*sc,
 	struct xrep_find_ag_btree	*fab)
 {
-	struct xfs_mount		*mp = sc->mp;
-	xfs_agnumber_t			agno = sc->sm->sm_agno;
-
-	return xfs_verify_agbno(mp, agno, fab->root) &&
+	return xfs_verify_agbno(sc->sa.pag, fab->root) &&
 	       fab->height <= fab->maxlevels;
 }
 
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 87518e1292f8..ab427b4d7fe0 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -93,8 +93,7 @@ xchk_allocbt_rec(
 	struct xchk_btree	*bs,
 	const union xfs_btree_rec *rec)
 {
-	struct xfs_mount	*mp = bs->cur->bc_mp;
-	xfs_agnumber_t		agno = bs->cur->bc_ag.pag->pag_agno;
+	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
 
@@ -102,8 +101,8 @@ xchk_allocbt_rec(
 	len = be32_to_cpu(rec->alloc.ar_blockcount);
 
 	if (bno + len <= bno ||
-	    !xfs_verify_agbno(mp, agno, bno) ||
-	    !xfs_verify_agbno(mp, agno, bno + len - 1))
+	    !xfs_verify_agbno(pag, bno) ||
+	    !xfs_verify_agbno(pag, bno + len - 1))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	xchk_allocbt_xref(bs->sc, bno, len);
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 00848ee542fb..b80a54be8634 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -104,13 +104,13 @@ xchk_iallocbt_chunk(
 	xfs_extlen_t			len)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
-	xfs_agnumber_t			agno = bs->cur->bc_ag.pag->pag_agno;
+	struct xfs_perag		*pag = bs->cur->bc_ag.pag;
 	xfs_agblock_t			bno;
 
 	bno = XFS_AGINO_TO_AGBNO(mp, agino);
 	if (bno + len <= bno ||
-	    !xfs_verify_agbno(mp, agno, bno) ||
-	    !xfs_verify_agbno(mp, agno, bno + len - 1))
+	    !xfs_verify_agbno(pag, bno) ||
+	    !xfs_verify_agbno(pag, bno + len - 1))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	xchk_iallocbt_chunk_xref(bs->sc, irec, agino, bno, len);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 2744eecdbaf0..3f82a1a1f390 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -332,9 +332,8 @@ xchk_refcountbt_rec(
 	struct xchk_btree	*bs,
 	const union xfs_btree_rec *rec)
 {
-	struct xfs_mount	*mp = bs->cur->bc_mp;
 	xfs_agblock_t		*cow_blocks = bs->private;
-	xfs_agnumber_t		agno = bs->cur->bc_ag.pag->pag_agno;
+	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
 	xfs_nlink_t		refcount;
@@ -354,8 +353,8 @@ xchk_refcountbt_rec(
 	/* Check the extent. */
 	bno &= ~XFS_REFC_COW_START;
 	if (bno + len <= bno ||
-	    !xfs_verify_agbno(mp, agno, bno) ||
-	    !xfs_verify_agbno(mp, agno, bno + len - 1))
+	    !xfs_verify_agbno(pag, bno) ||
+	    !xfs_verify_agbno(pag, bno + len - 1))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	if (refcount == 0)
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 8dae0345c7df..229826b2e1c0 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -92,7 +92,7 @@ xchk_rmapbt_rec(
 {
 	struct xfs_mount	*mp = bs->cur->bc_mp;
 	struct xfs_rmap_irec	irec;
-	xfs_agnumber_t		agno = bs->cur->bc_ag.pag->pag_agno;
+	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
 	bool			non_inode;
 	bool			is_unwritten;
 	bool			is_bmbt;
@@ -121,8 +121,8 @@ xchk_rmapbt_rec(
 		 * Otherwise we must point somewhere past the static metadata
 		 * but before the end of the FS.  Run the regular check.
 		 */
-		if (!xfs_verify_agbno(mp, agno, irec.rm_startblock) ||
-		    !xfs_verify_agbno(mp, agno, irec.rm_startblock +
+		if (!xfs_verify_agbno(pag, irec.rm_startblock) ||
+		    !xfs_verify_agbno(pag, irec.rm_startblock +
 				irec.rm_blockcount - 1))
 			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 	}
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 7a209fd9eec7..23f0794b8911 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -131,7 +131,7 @@ xfs_growfs_data_private(
 	oagcount = mp->m_sb.sb_agcount;
 	/* allocate the new per-ag structures */
 	if (nagcount > oagcount) {
-		error = xfs_initialize_perag(mp, nagcount, &nagimax);
+		error = xfs_initialize_perag(mp, nagcount, nb, &nagimax);
 		if (error)
 			return error;
 	} else if (nagcount < oagcount) {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 74f399ceddd9..e135f05f5b3f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3346,7 +3346,8 @@ xlog_do_recover(
 	/* re-initialise in-core superblock and geometry structures */
 	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
-	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
+	error = xfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
+			&mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
 		return error;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 359109b6f0d3..992f438cb4d7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -754,7 +754,8 @@ xfs_mountfs(
 	/*
 	 * Allocate and initialize the per-ag data.
 	 */
-	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
+	error = xfs_initialize_perag(mp, sbp->sb_agcount, mp->m_sb.sb_dblocks,
+			&mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed per-ag init: %d", error);
 		goto out_free_dir;
-- 
2.33.0

