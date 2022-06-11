Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F81AC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbiFKB1a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348741AbiFKB1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:20 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A58153A4839
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 205FD5EC7F6
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005AOz-JI
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELM6-I6
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 19/50] xfs: inobt can use perags in many more places than it does
Date:   Sat, 11 Jun 2022 11:26:28 +1000
Message-Id: <20220611012659.3418072-20-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=0ge8BwLW4vw9qPQq:21 a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8
        a=vkg8fwN_WJCJDa3EOIkA:9 a=_ocrC5ktTllhZKVzGroH:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Lots of code in the inobt infrastructure is passed both xfs_mount
and perags. We only need perags for the per-ag inode allocation
code, so reduce the duplication by passing only the perags as the
primary object.

This ends up reducing the code size by a bit:

	   text    data     bss     dec     hex filename
orig	1138878  323979     548 1463405  16546d (TOTALS)
patched	1138709  323979     548 1463236  1653c4 (TOTALS)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c      |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c       | 25 +++++++++++----------
 fs/xfs/libxfs/xfs_ialloc_btree.c | 37 ++++++++++++++------------------
 fs/xfs/libxfs/xfs_ialloc_btree.h | 20 ++++++++---------
 fs/xfs/scrub/agheader_repair.c   |  7 +++---
 fs/xfs/scrub/common.c            |  8 +++----
 fs/xfs/xfs_iwalk.c               |  4 ++--
 7 files changed, 47 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 5af123d13a63..7fd1fea95552 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -264,7 +264,7 @@ xfs_ag_resv_init(
 		if (error)
 			goto out;
 
-		error = xfs_finobt_calc_reserves(mp, tp, pag, &ask, &used);
+		error = xfs_finobt_calc_reserves(pag, tp, &ask, &used);
 		if (error)
 			goto out;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 314750fbd170..b0a6e88f3f5f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -176,13 +176,12 @@ xfs_inobt_insert(
 	xfs_agino_t		newlen,
 	xfs_btnum_t		btnum)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_btree_cur	*cur;
 	xfs_agino_t		thisino;
 	int			i;
 	int			error;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, btnum);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, btnum);
 
 	for (thisino = newino;
 	     thisino < newino + newlen;
@@ -527,7 +526,7 @@ xfs_inobt_insert_sprec(
 	int				i;
 	struct xfs_inobt_rec_incore	rec;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, btnum);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, btnum);
 
 	/* the new record is pre-aligned so we know where to look */
 	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
@@ -1004,7 +1003,7 @@ xfs_dialloc_ag_inobt(
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1457,7 +1456,7 @@ xfs_dialloc_ag(
 	if (!pagino)
 		pagino = be32_to_cpu(agi->agi_newino);
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_FINO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
 
 	error = xfs_check_agi_freecount(cur);
 	if (error)
@@ -1500,7 +1499,7 @@ xfs_dialloc_ag(
 	 * the original freecount. If all is well, make the equivalent update to
 	 * the inobt using the finobt record and offset information.
 	 */
-	icur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
+	icur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
 
 	error = xfs_check_agi_freecount(icur);
 	if (error)
@@ -1909,7 +1908,7 @@ xfs_difree_inobt(
 	/*
 	 * Initialize the cursor.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
 
 	error = xfs_check_agi_freecount(cur);
 	if (error)
@@ -2034,7 +2033,7 @@ xfs_difree_finobt(
 	int				error;
 	int				i;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_FINO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
 
 	error = xfs_inobt_lookup(cur, ibtrec->ir_startino, XFS_LOOKUP_EQ, &i);
 	if (error)
@@ -2231,7 +2230,7 @@ xfs_imap_lookup(
 	 * we have a record, we need to ensure it contains the inode number
 	 * we are looking up.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, pag, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_INO);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 	if (!error) {
 		if (i)
@@ -2920,17 +2919,17 @@ xfs_ialloc_check_shrink(
 {
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_btree_cur	*cur;
-	struct xfs_mount	*mp = tp->t_mountp;
-	xfs_agino_t		agino = XFS_AGB_TO_AGINO(mp, new_length);
+	xfs_agino_t		agino;
 	int			has;
 	int			error;
 
-	if (!xfs_has_sparseinodes(mp))
+	if (!xfs_has_sparseinodes(pag->pag_mount))
 		return 0;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agibp, pag, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(pag, tp, agibp, XFS_BTNUM_INO);
 
 	/* Look up the inobt record that would correspond to the new EOFS. */
+	agino = XFS_AGB_TO_AGINO(pag->pag_mount, new_length);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has);
 	if (error || !has)
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 8c83e265770c..d657af2ec350 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -36,8 +36,8 @@ STATIC struct xfs_btree_cur *
 xfs_inobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
-	return xfs_inobt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_ag.pag, cur->bc_btnum);
+	return xfs_inobt_init_cursor(cur->bc_ag.pag, cur->bc_tp,
+			cur->bc_ag.agbp, cur->bc_btnum);
 }
 
 STATIC void
@@ -427,11 +427,11 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
  */
 static struct xfs_btree_cur *
 xfs_inobt_init_common(
-	struct xfs_mount	*mp,		/* file system mount point */
-	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,		/* transaction pointer */
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, btnum,
@@ -456,16 +456,15 @@ xfs_inobt_init_common(
 /* Create an inode btree cursor. */
 struct xfs_btree_cur *
 xfs_inobt_init_cursor(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
 	struct xfs_agi		*agi = agbp->b_addr;
 
-	cur = xfs_inobt_init_common(mp, tp, pag, btnum);
+	cur = xfs_inobt_init_common(pag, tp, btnum);
 	if (btnum == XFS_BTNUM_INO)
 		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
 	else
@@ -477,14 +476,13 @@ xfs_inobt_init_cursor(
 /* Create an inode btree cursor with a fake root for staging. */
 struct xfs_btree_cur *
 xfs_inobt_stage_cursor(
-	struct xfs_mount	*mp,
-	struct xbtree_afakeroot	*afake,
 	struct xfs_perag	*pag,
+	struct xbtree_afakeroot	*afake,
 	xfs_btnum_t		btnum)
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_inobt_init_common(mp, NULL, pag, btnum);
+	cur = xfs_inobt_init_common(pag, NULL, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
@@ -708,9 +706,8 @@ xfs_inobt_max_size(
 /* Read AGI and create inobt cursor. */
 int
 xfs_inobt_cur(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
 	xfs_btnum_t		which,
 	struct xfs_btree_cur	**curpp,
 	struct xfs_buf		**agi_bpp)
@@ -725,16 +722,15 @@ xfs_inobt_cur(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, pag, which);
+	cur = xfs_inobt_init_cursor(pag, tp, *agi_bpp, which);
 	*curpp = cur;
 	return 0;
 }
 
 static int
 xfs_inobt_count_blocks(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
 	xfs_btnum_t		btnum,
 	xfs_extlen_t		*tree_blocks)
 {
@@ -742,7 +738,7 @@ xfs_inobt_count_blocks(
 	struct xfs_btree_cur	*cur = NULL;
 	int			error;
 
-	error = xfs_inobt_cur(mp, tp, pag, btnum, &cur, &agbp);
+	error = xfs_inobt_cur(pag, tp, btnum, &cur, &agbp);
 	if (error)
 		return error;
 
@@ -779,22 +775,21 @@ xfs_finobt_read_blocks(
  */
 int
 xfs_finobt_calc_reserves(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
 	xfs_extlen_t		*ask,
 	xfs_extlen_t		*used)
 {
 	xfs_extlen_t		tree_len = 0;
 	int			error;
 
-	if (!xfs_has_finobt(mp))
+	if (!xfs_has_finobt(pag->pag_mount))
 		return 0;
 
-	if (xfs_has_inobtcounts(mp))
+	if (xfs_has_inobtcounts(pag->pag_mount))
 		error = xfs_finobt_read_blocks(pag, tp, &tree_len);
 	else
-		error = xfs_inobt_count_blocks(mp, tp, pag, XFS_BTNUM_FINO,
+		error = xfs_inobt_count_blocks(pag, tp, XFS_BTNUM_FINO,
 				&tree_len);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 26451cb76b98..e859a6e05230 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -46,12 +46,10 @@ struct xfs_perag;
 		 (maxrecs) * sizeof(xfs_inobt_key_t) + \
 		 ((index) - 1) * sizeof(xfs_inobt_ptr_t)))
 
-extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *mp,
-		struct xfs_trans *tp, struct xfs_buf *agbp,
-		struct xfs_perag *pag, xfs_btnum_t btnum);
-struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, struct xfs_perag *pag,
-		xfs_btnum_t btnum);
+extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_perag *pag,
+		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_btnum_t btnum);
+struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_perag *pag,
+		struct xbtree_afakeroot *afake, xfs_btnum_t btnum);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
@@ -64,13 +62,13 @@ int xfs_inobt_rec_check_count(struct xfs_mount *,
 #define xfs_inobt_rec_check_count(mp, rec)	0
 #endif	/* DEBUG */
 
-int xfs_finobt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
-		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
+int xfs_finobt_calc_reserves(struct xfs_perag *perag, struct xfs_trans *tp,
+		xfs_extlen_t *ask, xfs_extlen_t *used);
 extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
-int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
-		struct xfs_perag *pag, xfs_btnum_t btnum,
-		struct xfs_btree_cur **curpp, struct xfs_buf **agi_bpp);
+int xfs_inobt_cur(struct xfs_perag *pag, struct xfs_trans *tp,
+		xfs_btnum_t btnum, struct xfs_btree_cur **curpp,
+		struct xfs_buf **agi_bpp);
 
 void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 1b0b4e243f77..c0e391de2b6d 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -820,8 +820,7 @@ xrep_agi_calc_from_btrees(
 	xfs_agino_t		freecount;
 	int			error;
 
-	cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp,
-			sc->sa.pag, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp, agi_bp, XFS_BTNUM_INO);
 	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
 	if (error)
 		goto err;
@@ -841,8 +840,8 @@ xrep_agi_calc_from_btrees(
 	if (xfs_has_finobt(mp) && xfs_has_inobtcounts(mp)) {
 		xfs_agblock_t	blocks;
 
-		cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp,
-				sc->sa.pag, XFS_BTNUM_FINO);
+		cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp, agi_bp,
+				XFS_BTNUM_FINO);
 		error = xfs_btree_count_blocks(cur, &blocks);
 		if (error)
 			goto err;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 70aebc12734a..46e15885c87e 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -482,15 +482,15 @@ xchk_ag_btcur_init(
 	/* Set up a inobt cursor for cross-referencing. */
 	if (sa->agi_bp &&
 	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_INO)) {
-		sa->ino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
-				sa->pag, XFS_BTNUM_INO);
+		sa->ino_cur = xfs_inobt_init_cursor(sa->pag, sc->tp, sa->agi_bp,
+				XFS_BTNUM_INO);
 	}
 
 	/* Set up a finobt cursor for cross-referencing. */
 	if (sa->agi_bp && xfs_has_finobt(mp) &&
 	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_FINO)) {
-		sa->fino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
-				sa->pag, XFS_BTNUM_FINO);
+		sa->fino_cur = xfs_inobt_init_cursor(sa->pag, sc->tp, sa->agi_bp,
+				XFS_BTNUM_FINO);
 	}
 
 	/* Set up a rmapbt cursor for cross-referencing. */
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index c31857d903a4..21be93bf006d 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -275,7 +275,7 @@ xfs_iwalk_ag_start(
 
 	/* Set up a fresh cursor and empty the inobt cache. */
 	iwag->nr_recs = 0;
-	error = xfs_inobt_cur(mp, tp, pag, XFS_BTNUM_INO, curpp, agi_bpp);
+	error = xfs_inobt_cur(pag, tp, XFS_BTNUM_INO, curpp, agi_bpp);
 	if (error)
 		return error;
 
@@ -390,7 +390,7 @@ xfs_iwalk_run_callbacks(
 	}
 
 	/* ...and recreate the cursor just past where we left off. */
-	error = xfs_inobt_cur(mp, iwag->tp, iwag->pag, XFS_BTNUM_INO, curpp,
+	error = xfs_inobt_cur(iwag->pag, iwag->tp, XFS_BTNUM_INO, curpp,
 			agi_bpp);
 	if (error)
 		return error;
-- 
2.35.1

