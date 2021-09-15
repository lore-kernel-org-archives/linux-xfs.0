Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8465EC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 697AF610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhIOXKq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232133AbhIOXKn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:10:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27D3A610A6;
        Wed, 15 Sep 2021 23:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747364;
        bh=rVzH3tkHhsnnoIHocr4h6A4YCREyoyxYj/s5PRR9Ddk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R2jlONAY60KZlMp1an0vcmnKYSXDe3nvl+JuQBnj3WbMzI9yseKdgSDXpZIP2ceLT
         nnQP49G3Pgdp8c5e09D6UNpSlfAeb2+buOrxrn+dKuA0EU2FRnJ9I/jUC8pNIjmyZs
         resTcfr/l+KPT2+vTyFQ1U+mYZB/Gsd+JvuRGcOhGdxb9Fx6ZSeDXBxu881/7FGIaR
         r3p3vCHtNX849ztcQcEkyP1yh81aUwT8mqTEXVIOcg9S3ti6pEM2q7eOKPHcZO/XVQ
         VKYc98YxegDXc72pw6UcLcVT3oMBEmo5Za9TrfkbuQ7iqO2fRm8AjrlQdUeMYF+2mx
         D6OhOoVOZsiQw==
Subject: [PATCH 31/61] xfs: add a perag to the btree cursor
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:09:23 -0700
Message-ID: <163174736389.350433.4692071564636215053.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: be9fb17d88f08af648a89784d30dbac83d893154

Which will eventually completely replace the agno in it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/fsmap.c                  |   18 +++++++++++-------
 db/info.c                   |    4 ++--
 include/atomic.h            |    1 +
 libxfs/xfs_alloc.c          |   25 +++++++++++++++----------
 libxfs/xfs_alloc_btree.c    |   13 ++++++++++---
 libxfs/xfs_alloc_btree.h    |    3 ++-
 libxfs/xfs_btree.c          |    2 ++
 libxfs/xfs_btree.h          |   11 ++++++++++-
 libxfs/xfs_ialloc.c         |   16 ++++++++--------
 libxfs/xfs_ialloc_btree.c   |   15 +++++++++++----
 libxfs/xfs_ialloc_btree.h   |    7 ++++---
 libxfs/xfs_refcount.c       |    4 ++--
 libxfs/xfs_refcount_btree.c |   17 ++++++++++++-----
 libxfs/xfs_refcount_btree.h |    2 +-
 libxfs/xfs_rmap.c           |    6 +++---
 libxfs/xfs_rmap_btree.c     |   17 ++++++++++++-----
 libxfs/xfs_rmap_btree.h     |    2 +-
 repair/rmap.c               |   38 ++++++++++++++++++++------------------
 18 files changed, 127 insertions(+), 74 deletions(-)


diff --git a/db/fsmap.c b/db/fsmap.c
index a6e61962..5973f0d6 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -41,12 +41,12 @@ fsmap(
 	struct fsmap_info	info;
 	xfs_agnumber_t		start_ag;
 	xfs_agnumber_t		end_ag;
-	xfs_agnumber_t		agno;
 	xfs_daddr_t		eofs;
 	struct xfs_rmap_irec	low = {0};
 	struct xfs_rmap_irec	high = {0};
 	struct xfs_btree_cur	*bt_cur;
 	struct xfs_buf		*agbp;
+	struct xfs_perag	*pag;
 	int			error;
 
 	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
@@ -63,29 +63,33 @@ fsmap(
 	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
 
 	info.nr = 0;
-	for (agno = start_ag; agno <= end_ag; agno++) {
-		if (agno == end_ag)
+	for_each_perag_range(mp, start_ag, end_ag, pag) {
+		if (pag->pag_agno == end_ag)
 			high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsb);
 
-		error = -libxfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+		error = -libxfs_alloc_read_agf(mp, NULL, pag->pag_agno, 0, &agbp);
 		if (error) {
+			libxfs_perag_put(pag);
 			dbprintf(_("Error %d while reading AGF.\n"), error);
 			return;
 		}
 
-		bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
+		bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp,
+				pag->pag_agno, pag);
 		if (!bt_cur) {
 			libxfs_buf_relse(agbp);
+			libxfs_perag_put(pag);
 			dbprintf(_("Not enough memory.\n"));
 			return;
 		}
 
-		info.agno = agno;
+		info.agno = pag->pag_agno;
 		error = -libxfs_rmap_query_range(bt_cur, &low, &high,
 				fsmap_fn, &info);
 		if (error) {
 			libxfs_btree_del_cursor(bt_cur, XFS_BTREE_ERROR);
 			libxfs_buf_relse(agbp);
+			libxfs_perag_put(pag);
 			dbprintf(_("Error %d while querying fsmap btree.\n"),
 				error);
 			return;
@@ -94,7 +98,7 @@ fsmap(
 		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
 		libxfs_buf_relse(agbp);
 
-		if (agno == start_ag)
+		if (pag->pag_agno == start_ag)
 			low.rm_startblock = 0;
 	}
 }
diff --git a/db/info.c b/db/info.c
index 6c5c3e5b..2ecaea64 100644
--- a/db/info.c
+++ b/db/info.c
@@ -66,7 +66,7 @@ print_agresv_info(
 {
 	struct xfs_buf	*bp;
 	struct xfs_agf	*agf;
-	struct xfs_perag *pag = xfs_perag_get(mp, agno);
+	struct xfs_perag *pag = libxfs_perag_get(mp, agno);
 	xfs_extlen_t	ask = 0;
 	xfs_extlen_t	used = 0;
 	xfs_extlen_t	free = 0;
@@ -97,7 +97,7 @@ print_agresv_info(
 	if (ask - used > free)
 		printf(" <not enough space>");
 	printf("\n");
-	xfs_perag_put(pag);
+	libxfs_perag_put(pag);
 }
 
 static int
diff --git a/include/atomic.h b/include/atomic.h
index e0e1ba84..770c5aaa 100644
--- a/include/atomic.h
+++ b/include/atomic.h
@@ -15,6 +15,7 @@
 typedef	int32_t	atomic_t;
 typedef	int64_t	atomic64_t;
 
+#define atomic_inc(x)		((*(x))++)
 #define atomic_inc_return(x)	(++(*(x)))
 #define atomic_dec_return(x)	(--(*(x)))
 
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index c69761eb..dfe0a9ce 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -772,7 +772,8 @@ xfs_alloc_cur_setup(
 	 */
 	if (!acur->cnt)
 		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
-					args->agbp, args->agno, XFS_BTNUM_CNT);
+						args->agbp, args->agno,
+						args->pag, XFS_BTNUM_CNT);
 	error = xfs_alloc_lookup_ge(acur->cnt, 0, args->maxlen, &i);
 	if (error)
 		return error;
@@ -782,10 +783,12 @@ xfs_alloc_cur_setup(
 	 */
 	if (!acur->bnolt)
 		acur->bnolt = xfs_allocbt_init_cursor(args->mp, args->tp,
-					args->agbp, args->agno, XFS_BTNUM_BNO);
+						args->agbp, args->agno,
+						args->pag, XFS_BTNUM_BNO);
 	if (!acur->bnogt)
 		acur->bnogt = xfs_allocbt_init_cursor(args->mp, args->tp,
-					args->agbp, args->agno, XFS_BTNUM_BNO);
+						args->agbp, args->agno,
+						args->pag, XFS_BTNUM_BNO);
 	return i == 1 ? 0 : -ENOSPC;
 }
 
@@ -1213,7 +1216,7 @@ xfs_alloc_ag_vextent_exact(
 	 * Allocate/initialize a cursor for the by-number freespace btree.
 	 */
 	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-					  args->agno, XFS_BTNUM_BNO);
+					  args->agno, args->pag, XFS_BTNUM_BNO);
 
 	/*
 	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
@@ -1273,7 +1276,7 @@ xfs_alloc_ag_vextent_exact(
 	 * Allocate/initialize a cursor for the by-size btree.
 	 */
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT);
+					args->agno, args->pag, XFS_BTNUM_CNT);
 	ASSERT(args->agbno + args->len <= be32_to_cpu(agf->agf_length));
 	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
 				      args->len, XFSA_FIXUP_BNO_OK);
@@ -1670,7 +1673,7 @@ xfs_alloc_ag_vextent_size(
 	 * Allocate and initialize a cursor for the by-size btree.
 	 */
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT);
+					args->agno, args->pag, XFS_BTNUM_CNT);
 	bno_cur = NULL;
 	busy = false;
 
@@ -1833,7 +1836,7 @@ xfs_alloc_ag_vextent_size(
 	 * Allocate and initialize a cursor for the by-block tree.
 	 */
 	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_BNO);
+					args->agno, args->pag, XFS_BTNUM_BNO);
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
 			rbno, rlen, XFSA_FIXUP_CNT_OK)))
 		goto error0;
@@ -1905,7 +1908,8 @@ xfs_free_ag_extent(
 	/*
 	 * Allocate and initialize a cursor for the by-block btree.
 	 */
-	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_BNO);
+	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno,
+					NULL, XFS_BTNUM_BNO);
 	/*
 	 * Look for a neighboring block on the left (lower block numbers)
 	 * that is contiguous with this space.
@@ -1975,7 +1979,8 @@ xfs_free_ag_extent(
 	/*
 	 * Now allocate and initialize a cursor for the by-size tree.
 	 */
-	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_CNT);
+	cnt_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno,
+					NULL, XFS_BTNUM_CNT);
 	/*
 	 * Have both left and right contiguous neighbors.
 	 * Merge all three into a single free block.
@@ -2486,7 +2491,7 @@ xfs_exact_minlen_extent_available(
 	int			error = 0;
 
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
-			args->agno, XFS_BTNUM_CNT);
+					args->agno, args->pag, XFS_BTNUM_CNT);
 	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
 	if (error)
 		goto out;
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 00a17bb0..d2f2a82e 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -25,7 +25,7 @@ xfs_allocbt_dup_cursor(
 {
 	return xfs_allocbt_init_cursor(cur->bc_mp, cur->bc_tp,
 			cur->bc_ag.agbp, cur->bc_ag.agno,
-			cur->bc_btnum);
+			cur->bc_ag.pag, cur->bc_btnum);
 }
 
 STATIC void
@@ -471,6 +471,7 @@ xfs_allocbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
@@ -495,6 +496,11 @@ xfs_allocbt_init_common(
 
 	cur->bc_ag.agno = agno;
 	cur->bc_ag.abt.active = false;
+	if (pag) {
+		/* take a reference for the cursor */
+		atomic_inc(&pag->pag_ref);
+	}
+	cur->bc_ag.pag = pag;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
@@ -511,12 +517,13 @@ xfs_allocbt_init_cursor(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_buf		*agbp,		/* buffer for agf structure */
 	xfs_agnumber_t		agno,		/* allocation group number */
+	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)		/* btree identifier */
 {
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_allocbt_init_common(mp, tp, agno, btnum);
+	cur = xfs_allocbt_init_common(mp, tp, agno, pag, btnum);
 	if (btnum == XFS_BTNUM_CNT)
 		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
 	else
@@ -537,7 +544,7 @@ xfs_allocbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_allocbt_init_common(mp, NULL, agno, btnum);
+	cur = xfs_allocbt_init_common(mp, NULL, agno, NULL, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
diff --git a/libxfs/xfs_alloc_btree.h b/libxfs/xfs_alloc_btree.h
index a5b998e9..a10cedba 100644
--- a/libxfs/xfs_alloc_btree.h
+++ b/libxfs/xfs_alloc_btree.h
@@ -13,6 +13,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xfs_perag;
 struct xbtree_afakeroot;
 
 /*
@@ -48,7 +49,7 @@ struct xbtree_afakeroot;
 
 extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
-		xfs_agnumber_t, xfs_btnum_t);
+		xfs_agnumber_t, struct xfs_perag *pag, xfs_btnum_t);
 struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
 		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
 		xfs_btnum_t btnum);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4faf4a67..d9c5e8a3 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -374,6 +374,8 @@ xfs_btree_del_cursor(
 	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
+	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
+		xfs_perag_put(cur->bc_ag.pag);
 	kmem_cache_free(xfs_btree_cur_zone, cur);
 }
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 10e50cba..e71f33f1 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -11,6 +11,7 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_ifork;
+struct xfs_perag;
 
 extern kmem_zone_t	*xfs_btree_cur_zone;
 
@@ -180,11 +181,12 @@ union xfs_btree_irec {
 
 /* Per-AG btree information. */
 struct xfs_btree_cur_ag {
+	xfs_agnumber_t		agno;
+	struct xfs_perag	*pag;
 	union {
 		struct xfs_buf		*agbp;
 		struct xbtree_afakeroot	*afake;	/* for staging cursor */
 	};
-	xfs_agnumber_t		agno;
 	union {
 		struct {
 			unsigned long nr_ops;	/* # record updates */
@@ -231,6 +233,13 @@ typedef struct xfs_btree_cur
 	uint8_t		bc_blocklog;	/* log2(blocksize) of btree blocks */
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	int		bc_statoff;	/* offset of btre stats array */
+
+	/*
+	 * Short btree pointers need an agno to be able to turn the pointers
+	 * into physical addresses for IO, so the btree cursor switches between
+	 * bc_ino and bc_ag based on whether XFS_BTREE_LONG_PTRS is set for the
+	 * cursor.
+	 */
 	union {
 		struct xfs_btree_cur_ag	bc_ag;
 		struct xfs_btree_cur_ino bc_ino;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 745daafb..5d61be05 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -178,7 +178,7 @@ xfs_inobt_insert(
 	int			i;
 	int			error;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, btnum);
 
 	for (thisino = newino;
 	     thisino < newino + newlen;
@@ -526,7 +526,7 @@ xfs_inobt_insert_sprec(
 	int				i;
 	struct xfs_inobt_rec_incore	rec;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, btnum);
 
 	/* the new record is pre-aligned so we know where to look */
 	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
@@ -1140,7 +1140,7 @@ xfs_dialloc_ag_inobt(
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1593,7 +1593,7 @@ xfs_dialloc_ag(
 	if (!pagino)
 		pagino = be32_to_cpu(agi->agi_newino);
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_FINO);
 
 	error = xfs_check_agi_freecount(cur, agi);
 	if (error)
@@ -1636,7 +1636,7 @@ xfs_dialloc_ag(
 	 * the original freecount. If all is well, make the equivalent update to
 	 * the inobt using the finobt record and offset information.
 	 */
-	icur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
+	icur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
 
 	error = xfs_check_agi_freecount(icur, agi);
 	if (error)
@@ -1949,7 +1949,7 @@ xfs_difree_inobt(
 	/*
 	 * Initialize the cursor.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
 
 	error = xfs_check_agi_freecount(cur, agi);
 	if (error)
@@ -2075,7 +2075,7 @@ xfs_difree_finobt(
 	int				error;
 	int				i;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_FINO);
 
 	error = xfs_inobt_lookup(cur, ibtrec->ir_startino, XFS_LOOKUP_EQ, &i);
 	if (error)
@@ -2276,7 +2276,7 @@ xfs_imap_lookup(
 	 * we have a record, we need to ensure it contains the inode number
 	 * we are looking up.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, NULL, XFS_BTNUM_INO);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 	if (!error) {
 		if (i)
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index e93843e2..9b971453 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -35,7 +35,7 @@ xfs_inobt_dup_cursor(
 {
 	return xfs_inobt_init_cursor(cur->bc_mp, cur->bc_tp,
 			cur->bc_ag.agbp, cur->bc_ag.agno,
-			cur->bc_btnum);
+			cur->bc_ag.pag, cur->bc_btnum);
 }
 
 STATIC void
@@ -428,6 +428,7 @@ xfs_inobt_init_common(
 	struct xfs_mount	*mp,		/* file system mount point */
 	struct xfs_trans	*tp,		/* transaction pointer */
 	xfs_agnumber_t		agno,		/* allocation group number */
+	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
 	struct xfs_btree_cur	*cur;
@@ -450,6 +451,11 @@ xfs_inobt_init_common(
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_ag.agno = agno;
+	if (pag) {
+		/* take a reference for the cursor */
+		atomic_inc(&pag->pag_ref);
+	}
+	cur->bc_ag.pag = pag;
 	return cur;
 }
 
@@ -460,12 +466,13 @@ xfs_inobt_init_cursor(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
 	struct xfs_agi		*agi = agbp->b_addr;
 
-	cur = xfs_inobt_init_common(mp, tp, agno, btnum);
+	cur = xfs_inobt_init_common(mp, tp, agno, pag, btnum);
 	if (btnum == XFS_BTNUM_INO)
 		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
 	else
@@ -484,7 +491,7 @@ xfs_inobt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_inobt_init_common(mp, NULL, agno, btnum);
+	cur = xfs_inobt_init_common(mp, NULL, agno, NULL, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
@@ -671,7 +678,7 @@ xfs_inobt_cur(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, which);
+	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, NULL, which);
 	*curpp = cur;
 	return 0;
 }
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index d5afe01f..04dfa7ee 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -13,6 +13,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xfs_perag;
 
 /*
  * Btree block header size depends on a superblock flag.
@@ -45,9 +46,9 @@ struct xfs_mount;
 		 (maxrecs) * sizeof(xfs_inobt_key_t) + \
 		 ((index) - 1) * sizeof(xfs_inobt_ptr_t)))
 
-extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
-		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t,
-		xfs_btnum_t);
+extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_agnumber_t agno,
+		struct xfs_perag *pag, xfs_btnum_t btnum);
 struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
 		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
 		xfs_btnum_t btnum);
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 2097e0ea..0516ae6d 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1177,7 +1177,7 @@ xfs_refcount_finish_one(
 		if (error)
 			return error;
 
-		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
+		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
 		rcur->bc_ag.refc.nr_ops = nr_ops;
 		rcur->bc_ag.refc.shape_changes = shape_changes;
 	}
@@ -1706,7 +1706,7 @@ xfs_refcount_recover_cow_leftovers(
 	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (error)
 		goto out_trans;
-	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
+	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
 
 	/* Find all the leftover CoW staging extents. */
 	memset(&low, 0, sizeof(low));
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index e23ea313..0851d357 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -25,7 +25,7 @@ xfs_refcountbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_refcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_ag.agno);
+			cur->bc_ag.agbp, cur->bc_ag.agno, cur->bc_ag.pag);
 }
 
 STATIC void
@@ -315,7 +315,8 @@ static struct xfs_btree_cur *
 xfs_refcountbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno)
+	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
 
@@ -331,6 +332,11 @@ xfs_refcountbt_init_common(
 
 	cur->bc_ag.agno = agno;
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
+	if (pag) {
+		/* take a reference for the cursor */
+		atomic_inc(&pag->pag_ref);
+	}
+	cur->bc_ag.pag = pag;
 
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
@@ -344,12 +350,13 @@ xfs_refcountbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	xfs_agnumber_t		agno)
+	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag)
 {
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_refcountbt_init_common(mp, tp, agno);
+	cur = xfs_refcountbt_init_common(mp, tp, agno, pag);
 	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
 	cur->bc_ag.agbp = agbp;
 	return cur;
@@ -364,7 +371,7 @@ xfs_refcountbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_refcountbt_init_common(mp, NULL, agno);
+	cur = xfs_refcountbt_init_common(mp, NULL, agno, NULL);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
index eab1b0c6..8b82a39f 100644
--- a/libxfs/xfs_refcount_btree.h
+++ b/libxfs/xfs_refcount_btree.h
@@ -47,7 +47,7 @@ struct xbtree_afakeroot;
 
 extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *agbp,
-		xfs_agnumber_t agno);
+		xfs_agnumber_t agno, struct xfs_perag *pag);
 struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
 		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
 extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 6323ccdc..e61de3b2 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -707,7 +707,7 @@ xfs_rmap_free(
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno, NULL);
 
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
@@ -961,7 +961,7 @@ xfs_rmap_alloc(
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno, NULL);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -2407,7 +2407,7 @@ xfs_rmap_finish_one(
 			goto out_drop;
 		}
 
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag->pag_agno);
+		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag->pag_agno, pag);
 	}
 	*pcur = rcur;
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index c8cac84f..bed2f381 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -50,7 +50,7 @@ xfs_rmapbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_rmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_ag.agno);
+			cur->bc_ag.agbp, cur->bc_ag.agno, cur->bc_ag.pag);
 }
 
 STATIC void
@@ -447,7 +447,8 @@ static struct xfs_btree_cur *
 xfs_rmapbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno)
+	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
 
@@ -461,6 +462,11 @@ xfs_rmapbt_init_common(
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ag.agno = agno;
 	cur->bc_ops = &xfs_rmapbt_ops;
+	if (pag) {
+		/* take a reference for the cursor */
+		atomic_inc(&pag->pag_ref);
+	}
+	cur->bc_ag.pag = pag;
 
 	return cur;
 }
@@ -471,12 +477,13 @@ xfs_rmapbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	xfs_agnumber_t		agno)
+	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag)
 {
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_rmapbt_init_common(mp, tp, agno);
+	cur = xfs_rmapbt_init_common(mp, tp, agno, pag);
 	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
 	cur->bc_ag.agbp = agbp;
 	return cur;
@@ -491,7 +498,7 @@ xfs_rmapbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_rmapbt_init_common(mp, NULL, agno);
+	cur = xfs_rmapbt_init_common(mp, NULL, agno, NULL);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index cef361a1..b036470a 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -43,7 +43,7 @@ struct xbtree_afakeroot;
 
 struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_trans *tp, struct xfs_buf *bp,
-				xfs_agnumber_t agno);
+				xfs_agnumber_t agno, struct xfs_perag *pag);
 struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
 		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
 void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
diff --git a/repair/rmap.c b/repair/rmap.c
index 54451a7e..2ffa27c8 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -976,14 +976,14 @@ rmaps_verify_btree(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
+	struct xfs_rmap_irec	tmp;
 	struct xfs_slab_cursor	*rm_cur;
 	struct xfs_btree_cur	*bt_cur = NULL;
-	int			error;
-	int			have;
 	struct xfs_buf		*agbp = NULL;
 	struct xfs_rmap_irec	*rm_rec;
-	struct xfs_rmap_irec	tmp;
-	struct xfs_perag	*pag;		/* per allocation group data */
+	struct xfs_perag	*pag = NULL;
+	int			have;
+	int			error;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
@@ -1005,9 +1005,8 @@ rmaps_verify_btree(
 	/* Leave the per-ag data "uninitialized" since we rewrite it later */
 	pag = libxfs_perag_get(mp, agno);
 	pag->pagf_init = 0;
-	libxfs_perag_put(pag);
 
-	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
+	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, agno, pag);
 	if (!bt_cur) {
 		error = -ENOMEM;
 		goto err;
@@ -1081,6 +1080,8 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 err:
 	if (bt_cur)
 		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+	if (pag)
+		libxfs_perag_put(pag);
 	if (agbp)
 		libxfs_buf_relse(agbp);
 	free_slab_cursor(&rm_cur);
@@ -1333,18 +1334,18 @@ refcount_avoid_check(void)
  */
 int
 check_refcounts(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno)
 {
-	struct xfs_slab_cursor	*rl_cur;
-	struct xfs_btree_cur	*bt_cur = NULL;
-	int			error;
-	int			have;
-	int			i;
-	struct xfs_buf		*agbp = NULL;
-	struct xfs_refcount_irec	*rl_rec;
 	struct xfs_refcount_irec	tmp;
-	struct xfs_perag	*pag;		/* per allocation group data */
+	struct xfs_slab_cursor		*rl_cur;
+	struct xfs_btree_cur		*bt_cur = NULL;
+	struct xfs_buf			*agbp = NULL;
+	struct xfs_perag		*pag = NULL;
+	struct xfs_refcount_irec	*rl_rec;
+	int				have;
+	int				i;
+	int				error;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return 0;
@@ -1366,9 +1367,8 @@ check_refcounts(
 	/* Leave the per-ag data "uninitialized" since we rewrite it later */
 	pag = libxfs_perag_get(mp, agno);
 	pag->pagf_init = 0;
-	libxfs_perag_put(pag);
 
-	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, agno);
+	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, agno, pag);
 	if (!bt_cur) {
 		error = -ENOMEM;
 		goto err;
@@ -1417,6 +1417,8 @@ _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) le
 	if (bt_cur)
 		libxfs_btree_del_cursor(bt_cur, error ? XFS_BTREE_ERROR :
 							XFS_BTREE_NOERROR);
+	if (pag)
+		libxfs_perag_put(pag);
 	if (agbp)
 		libxfs_buf_relse(agbp);
 	free_slab_cursor(&rl_cur);

