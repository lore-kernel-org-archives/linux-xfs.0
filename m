Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED0BC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345226AbiFKB1Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348187AbiFKB1S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:18 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5064A3A480E
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 55ADB5EC7EC
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005AOb-A6
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELLS-8w
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/50] xfs: Pre-calculate per-AG agbno geometry
Date:   Sat, 11 Jun 2022 11:26:20 +1000
Message-Id: <20220611012659.3418072-12-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a3ef68
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=iCZSsLxZKn0fRfsFkSAA:9
        a=FTk_TCTX4Db5Bpu1:21
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
 fs/xfs/libxfs/xfs_btree.c      | 25 +++++++++------------
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
 17 files changed, 115 insertions(+), 82 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index c1a1c9f414c3..d0032c43fef7 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -201,10 +201,35 @@ xfs_free_perag(
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
@@ -270,6 +295,13 @@ xfs_initialize_perag(
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
@@ -926,10 +958,16 @@ xfs_ag_extend_space(
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
index 74c8bd1b0b75..037b1bc2196b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -248,7 +248,7 @@ xfs_alloc_get_rec(
 	int			*stat)	/* output: success/failure */
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
+	struct xfs_perag	*pag = cur->bc_ag.pag;
 	union xfs_btree_rec	*rec;
 	int			error;
 
@@ -263,11 +263,11 @@ xfs_alloc_get_rec(
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
@@ -275,7 +275,8 @@ xfs_alloc_get_rec(
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
index 2eecc49fc1b2..06ab364d2de3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -91,10 +91,9 @@ xfs_btree_check_lblock_siblings(
 
 static inline xfs_failaddr_t
 xfs_btree_check_sblock_siblings(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_btree_cur	*cur,
 	int			level,
-	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	__be32			dsibling)
 {
@@ -110,7 +109,7 @@ xfs_btree_check_sblock_siblings(
 		if (!xfs_btree_check_sptr(cur, sibling, level + 1))
 			return __this_address;
 	} else {
-		if (!xfs_verify_agbno(mp, agno, sibling))
+		if (!xfs_verify_agbno(pag, sibling))
 			return __this_address;
 	}
 	return NULL;
@@ -195,11 +194,11 @@ __xfs_btree_check_sblock(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_perag	*pag = cur->bc_ag.pag;
 	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
 	xfs_agblock_t		agbno = NULLAGBLOCK;
-	xfs_agnumber_t		agno = NULLAGNUMBER;
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -217,16 +216,14 @@ __xfs_btree_check_sblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
-	if (bp) {
+	if (bp)
 		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
-		agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
-	}
 
-	fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno, agbno,
+	fa = xfs_btree_check_sblock_siblings(pag, cur, level, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno,
-				 agbno, block->bb_u.s.bb_rightsib);
+		fa = xfs_btree_check_sblock_siblings(pag, cur, level, agbno,
+				block->bb_u.s.bb_rightsib);
 	return fa;
 }
 
@@ -288,7 +285,7 @@ xfs_btree_check_sptr(
 {
 	if (level <= 0)
 		return false;
-	return xfs_verify_agbno(cur->bc_mp, cur->bc_ag.pag->pag_agno, agbno);
+	return xfs_verify_agbno(cur->bc_ag.pag, agbno);
 }
 
 /*
@@ -4595,7 +4592,6 @@ xfs_btree_sblock_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	xfs_failaddr_t		fa;
 
@@ -4604,12 +4600,11 @@ xfs_btree_sblock_verify(
 		return __this_address;
 
 	/* sibling pointer verification */
-	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
 	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
-	fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
+	fa = xfs_btree_check_sblock_siblings(bp->b_pag, NULL, -1, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
+		fa = xfs_btree_check_sblock_siblings(bp->b_pag, NULL, -1, agbno,
 				block->bb_u.s.bb_rightsib);
 	return fa;
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 098dac888c22..64b910caafaa 100644
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
index 2845019d31da..094dfc897ebc 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -215,7 +215,7 @@ xfs_rmap_get_rec(
 	int			*stat)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
+	struct xfs_perag	*pag = cur->bc_ag.pag;
 	union xfs_btree_rec	*rec;
 	int			error;
 
@@ -235,12 +235,12 @@ xfs_rmap_get_rec(
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
@@ -254,7 +254,7 @@ xfs_rmap_get_rec(
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
index 373f64a492a4..ccf61afb959d 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -179,9 +179,6 @@ enum xfs_ag_resv_type {
  */
 struct xfs_mount;
 
-xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
-bool xfs_verify_agbno(struct xfs_mount *mp, xfs_agnumber_t agno,
-		xfs_agblock_t agbno);
 bool xfs_verify_fsbno(struct xfs_mount *mp, xfs_fsblock_t fsbno);
 bool xfs_verify_fsbext(struct xfs_mount *mp, xfs_fsblock_t fsbno,
 		xfs_fsblock_t len);
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 90aebfe9dc5f..181bba5f9b8f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -541,16 +541,16 @@ xchk_agf(
 
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
@@ -563,7 +563,7 @@ xchk_agf(
 
 	if (xfs_has_rmapbt(mp)) {
 		agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
-		if (!xfs_verify_agbno(mp, agno, agbno))
+		if (!xfs_verify_agbno(pag, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 		level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
@@ -573,7 +573,7 @@ xchk_agf(
 
 	if (xfs_has_reflink(mp)) {
 		agbno = be32_to_cpu(agf->agf_refcount_root);
-		if (!xfs_verify_agbno(mp, agno, agbno))
+		if (!xfs_verify_agbno(pag, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 		level = be32_to_cpu(agf->agf_refcount_level);
@@ -639,9 +639,8 @@ xchk_agfl_block(
 {
 	struct xchk_agfl_info	*sai = priv;
 	struct xfs_scrub	*sc = sai->sc;
-	xfs_agnumber_t		agno = sc->sa.pag->pag_agno;
 
-	if (xfs_verify_agbno(mp, agno, agbno) &&
+	if (xfs_verify_agbno(sc->sa.pag, agbno) &&
 	    sai->nr_entries < sai->sz_entries)
 		sai->entries[sai->nr_entries++] = agbno;
 	else
@@ -871,12 +870,12 @@ xchk_agi(
 
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
@@ -885,7 +884,7 @@ xchk_agi(
 
 	if (xfs_has_finobt(mp)) {
 		agbno = be32_to_cpu(agi->agi_free_root);
-		if (!xfs_verify_agbno(mp, agno, agbno))
+		if (!xfs_verify_agbno(pag, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 		level = be32_to_cpu(agi->agi_free_level);
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 10ac1118a595..ba012a5da0bf 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -106,7 +106,7 @@ xrep_agf_check_agfl_block(
 {
 	struct xfs_scrub	*sc = priv;
 
-	if (!xfs_verify_agbno(mp, sc->sa.pag->pag_agno, agbno))
+	if (!xfs_verify_agbno(sc->sa.pag, agbno))
 		return -EFSCORRUPTED;
 	return 0;
 }
@@ -130,10 +130,7 @@ xrep_check_btree_root(
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
index 7be4d83d5884..5fe9af24dfcd 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -132,7 +132,7 @@ xfs_growfs_data_private(
 	oagcount = mp->m_sb.sb_agcount;
 	/* allocate the new per-ag structures */
 	if (nagcount > oagcount) {
-		error = xfs_initialize_perag(mp, nagcount, &nagimax);
+		error = xfs_initialize_perag(mp, nagcount, nb, &nagimax);
 		if (error)
 			return error;
 	} else if (nagcount < oagcount) {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 38aae3409c96..3e8c62c6c2b1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3313,7 +3313,8 @@ xlog_do_recover(
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
index daa8d29c46b4..f10c88cee116 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -778,7 +778,8 @@ xfs_mountfs(
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
2.35.1

