Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F14CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E91610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhIOXLM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232740AbhIOXLL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:11:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B2FE600D4;
        Wed, 15 Sep 2021 23:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747391;
        bh=iO3fKynndXKuVKMI2u16RFM8nqnPwt2nwLLfICa05bE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KGh3FN3wuoAuy7iRoFN92yC7NJclN7+8GddmEz0K36GOt4rfmL8tZAqBA+htqfxAE
         LI26Nmat5P058MhW4BuKPe4mSgb+y2sprTGR8Nm0dhDPLDvKov81nOQfYAp0Byb68a
         XAZ3sDxlSPumEhCkTX6nHb2a79kM1kdLAj70INo2RFgGtOD3C2zH29U/53/PcWdhB1
         v6Gug/Eev0b8ffgsQbDGeD9gG+Pw1k5797f9/kafNHuun6CIBU5WdlkkxHRgk1b8/Y
         mlFc7LKgath4aeq/wPZpFdY1fmaId8sNHZh5BQxJxfzicvxs32QKUCWaU9AJO04/ym
         Ldep4EPpRAowQ==
Subject: [PATCH 36/61] xfs: remove agno from btree cursor
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:09:51 -0700
Message-ID: <163174739136.350433.18413532763841759348.stgit@magnolia>
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

Source kernel commit: 50f02fe3338d3fee6b298a1b262a4c562e7d84e0

Now that everything passes a perag, the agno is not needed anymore.
Convert all the users to use pag->pag_agno instead and remove the
agno from the cursor. This was largely done as an automated search
and replace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c          |    2 -
 libxfs/xfs_alloc_btree.c    |    1 
 libxfs/xfs_btree.c          |   12 ++---
 libxfs/xfs_btree.h          |    1 
 libxfs/xfs_ialloc.c         |    2 -
 libxfs/xfs_ialloc_btree.c   |    7 +--
 libxfs/xfs_refcount.c       |   82 ++++++++++++++++-----------------
 libxfs/xfs_refcount_btree.c |   11 ++--
 libxfs/xfs_rmap.c           |  108 ++++++++++++++++++++++---------------------
 libxfs/xfs_rmap_btree.c     |    1 
 repair/agbtree.c            |    4 +-
 11 files changed, 113 insertions(+), 118 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index d41d11c7..5ecf6706 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -226,7 +226,7 @@ xfs_alloc_get_rec(
 	int			*stat)	/* output: success/failure */
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_ag.agno;
+	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
 	union xfs_btree_rec	*rec;
 	int			error;
 
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index abc06574..3847f7cb 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -495,7 +495,6 @@ xfs_allocbt_init_common(
 	/* take a reference for the cursor */
 	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
-	cur->bc_ag.agno = pag->pag_agno;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index d9c5e8a3..9caff949 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -213,7 +213,7 @@ xfs_btree_check_sptr(
 {
 	if (level <= 0)
 		return false;
-	return xfs_verify_agbno(cur->bc_mp, cur->bc_ag.agno, agbno);
+	return xfs_verify_agbno(cur->bc_mp, cur->bc_ag.pag->pag_agno, agbno);
 }
 
 /*
@@ -242,7 +242,7 @@ xfs_btree_check_ptr(
 			return 0;
 		xfs_err(cur->bc_mp,
 "AG %u: Corrupt btree %d pointer at level %d index %d.",
-				cur->bc_ag.agno, cur->bc_btnum,
+				cur->bc_ag.pag->pag_agno, cur->bc_btnum,
 				level, index);
 	}
 
@@ -885,13 +885,13 @@ xfs_btree_readahead_sblock(
 
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
-		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.agno,
+		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 				     left, 1, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLAGBLOCK) {
-		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.agno,
+		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 				     right, 1, cur->bc_ops->buf_ops);
 		rval++;
 	}
@@ -949,7 +949,7 @@ xfs_btree_ptr_to_daddr(
 		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, fsbno);
 	} else {
 		agbno = be32_to_cpu(ptr->s);
-		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_ag.agno,
+		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 				agbno);
 	}
 
@@ -1150,7 +1150,7 @@ xfs_btree_init_block_cur(
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		owner = cur->bc_ino.ip->i_ino;
 	else
-		owner = cur->bc_ag.agno;
+		owner = cur->bc_ag.pag->pag_agno;
 
 	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
 				 cur->bc_btnum, level, numrecs,
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index e71f33f1..4dbdc659 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -181,7 +181,6 @@ union xfs_btree_irec {
 
 /* Per-AG btree information. */
 struct xfs_btree_cur_ag {
-	xfs_agnumber_t		agno;
 	struct xfs_perag	*pag;
 	union {
 		struct xfs_buf		*agbp;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 830001f9..b6652be3 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -100,7 +100,7 @@ xfs_inobt_get_rec(
 	int				*stat)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	xfs_agnumber_t			agno = cur->bc_ag.agno;
+	xfs_agnumber_t			agno = cur->bc_ag.pag->pag_agno;
 	union xfs_btree_rec		*rec;
 	int				error;
 	uint64_t			realfree;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index c8a96369..3e8afe76 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -101,7 +101,7 @@ __xfs_inobt_alloc_block(
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	args.oinfo = XFS_RMAP_OINFO_INOBT;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.agno, sbno);
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.pag->pag_agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
 	args.prod = 1;
@@ -234,7 +234,7 @@ xfs_inobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.agno == be32_to_cpu(agi->agi_seqno));
+	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agi->agi_seqno));
 
 	ptr->s = agi->agi_root;
 }
@@ -246,7 +246,7 @@ xfs_finobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.agno == be32_to_cpu(agi->agi_seqno));
+	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agi->agi_seqno));
 	ptr->s = agi->agi_free_root;
 }
 
@@ -451,7 +451,6 @@ xfs_inobt_init_common(
 	/* take a reference for the cursor */
 	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
-	cur->bc_ag.agno = pag->pag_agno;
 	return cur;
 }
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 13385394..2ef00c64 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -46,7 +46,7 @@ xfs_refcount_lookup_le(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -63,7 +63,7 @@ xfs_refcount_lookup_ge(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
 			XFS_LOOKUP_GE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -80,7 +80,7 @@ xfs_refcount_lookup_eq(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -108,7 +108,7 @@ xfs_refcount_get_rec(
 	int				*stat)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	xfs_agnumber_t			agno = cur->bc_ag.agno;
+	xfs_agnumber_t			agno = cur->bc_ag.pag->pag_agno;
 	union xfs_btree_rec		*rec;
 	int				error;
 	xfs_agblock_t			realstart;
@@ -119,7 +119,7 @@ xfs_refcount_get_rec(
 
 	xfs_refcount_btrec_to_irec(rec, irec);
 
-	agno = cur->bc_ag.agno;
+	agno = cur->bc_ag.pag->pag_agno;
 	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
 		goto out_bad_rec;
 
@@ -144,7 +144,7 @@ xfs_refcount_get_rec(
 	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
 		goto out_bad_rec;
 
-	trace_xfs_refcount_get(cur->bc_mp, cur->bc_ag.agno, irec);
+	trace_xfs_refcount_get(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
 	return 0;
 
 out_bad_rec:
@@ -169,14 +169,14 @@ xfs_refcount_update(
 	union xfs_btree_rec	rec;
 	int			error;
 
-	trace_xfs_refcount_update(cur->bc_mp, cur->bc_ag.agno, irec);
+	trace_xfs_refcount_update(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
 	rec.refc.rc_startblock = cpu_to_be32(irec->rc_startblock);
 	rec.refc.rc_blockcount = cpu_to_be32(irec->rc_blockcount);
 	rec.refc.rc_refcount = cpu_to_be32(irec->rc_refcount);
 	error = xfs_btree_update(cur, &rec);
 	if (error)
 		trace_xfs_refcount_update_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -193,7 +193,7 @@ xfs_refcount_insert(
 {
 	int				error;
 
-	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_ag.agno, irec);
+	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
 	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
 	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
 	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
@@ -208,7 +208,7 @@ xfs_refcount_insert(
 out_error:
 	if (error)
 		trace_xfs_refcount_insert_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -234,7 +234,7 @@ xfs_refcount_delete(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
-	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_ag.agno, &irec);
+	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_ag.pag->pag_agno, &irec);
 	error = xfs_btree_delete(cur, i);
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
 		error = -EFSCORRUPTED;
@@ -246,7 +246,7 @@ xfs_refcount_delete(
 out_error:
 	if (error)
 		trace_xfs_refcount_delete_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -366,7 +366,7 @@ xfs_refcount_split_extent(
 		return 0;
 
 	*shape_changed = true;
-	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			&rcext, agbno);
 
 	/* Establish the right extent. */
@@ -391,7 +391,7 @@ xfs_refcount_split_extent(
 
 out_error:
 	trace_xfs_refcount_split_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -411,7 +411,7 @@ xfs_refcount_merge_center_extents(
 	int				found_rec;
 
 	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
-			cur->bc_ag.agno, left, center, right);
+			cur->bc_ag.pag->pag_agno, left, center, right);
 
 	/*
 	 * Make sure the center and right extents are not in the btree.
@@ -468,7 +468,7 @@ xfs_refcount_merge_center_extents(
 
 out_error:
 	trace_xfs_refcount_merge_center_extents_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -487,7 +487,7 @@ xfs_refcount_merge_left_extent(
 	int				found_rec;
 
 	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
-			cur->bc_ag.agno, left, cleft);
+			cur->bc_ag.pag->pag_agno, left, cleft);
 
 	/* If the extent at agbno (cleft) wasn't synthesized, remove it. */
 	if (cleft->rc_refcount > 1) {
@@ -530,7 +530,7 @@ xfs_refcount_merge_left_extent(
 
 out_error:
 	trace_xfs_refcount_merge_left_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -548,7 +548,7 @@ xfs_refcount_merge_right_extent(
 	int				found_rec;
 
 	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
-			cur->bc_ag.agno, cright, right);
+			cur->bc_ag.pag->pag_agno, cright, right);
 
 	/*
 	 * If the extent ending at agbno+aglen (cright) wasn't synthesized,
@@ -594,7 +594,7 @@ xfs_refcount_merge_right_extent(
 
 out_error:
 	trace_xfs_refcount_merge_right_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -679,13 +679,13 @@ xfs_refcount_find_left_extents(
 		cleft->rc_blockcount = aglen;
 		cleft->rc_refcount = 1;
 	}
-	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			left, cleft, agbno);
 	return error;
 
 out_error:
 	trace_xfs_refcount_find_left_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -768,13 +768,13 @@ xfs_refcount_find_right_extents(
 		cright->rc_blockcount = aglen;
 		cright->rc_refcount = 1;
 	}
-	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			cright, right, agbno + aglen);
 	return error;
 
 out_error:
 	trace_xfs_refcount_find_right_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -952,7 +952,7 @@ xfs_refcount_adjust_extents(
 					ext.rc_startblock - *agbno);
 			tmp.rc_refcount = 1 + adj;
 			trace_xfs_refcount_modify_extent(cur->bc_mp,
-					cur->bc_ag.agno, &tmp);
+					cur->bc_ag.pag->pag_agno, &tmp);
 
 			/*
 			 * Either cover the hole (increment) or
@@ -971,7 +971,7 @@ xfs_refcount_adjust_extents(
 				cur->bc_ag.refc.nr_ops++;
 			} else {
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-						cur->bc_ag.agno,
+						cur->bc_ag.pag->pag_agno,
 						tmp.rc_startblock);
 				xfs_bmap_add_free(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, oinfo);
@@ -998,7 +998,7 @@ xfs_refcount_adjust_extents(
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.agno, &ext);
+				cur->bc_ag.pag->pag_agno, &ext);
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
@@ -1016,7 +1016,7 @@ xfs_refcount_adjust_extents(
 			goto advloop;
 		} else {
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-					cur->bc_ag.agno,
+					cur->bc_ag.pag->pag_agno,
 					ext.rc_startblock);
 			xfs_bmap_add_free(cur->bc_tp, fsbno, ext.rc_blockcount,
 					  oinfo);
@@ -1035,7 +1035,7 @@ xfs_refcount_adjust_extents(
 	return error;
 out_error:
 	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1057,10 +1057,10 @@ xfs_refcount_adjust(
 	*new_agbno = agbno;
 	*new_aglen = aglen;
 	if (adj == XFS_REFCOUNT_ADJUST_INCREASE)
-		trace_xfs_refcount_increase(cur->bc_mp, cur->bc_ag.agno,
+		trace_xfs_refcount_increase(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 				agbno, aglen);
 	else
-		trace_xfs_refcount_decrease(cur->bc_mp, cur->bc_ag.agno,
+		trace_xfs_refcount_decrease(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 				agbno, aglen);
 
 	/*
@@ -1099,7 +1099,7 @@ xfs_refcount_adjust(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			error, _RET_IP_);
 	return error;
 }
@@ -1296,7 +1296,7 @@ xfs_refcount_find_shared(
 	int				have;
 	int				error;
 
-	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			agbno, aglen);
 
 	/* By default, skip the whole range */
@@ -1376,12 +1376,12 @@ xfs_refcount_find_shared(
 
 done:
 	trace_xfs_refcount_find_shared_result(cur->bc_mp,
-			cur->bc_ag.agno, *fbno, *flen);
+			cur->bc_ag.pag->pag_agno, *fbno, *flen);
 
 out_error:
 	if (error)
 		trace_xfs_refcount_find_shared_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1478,7 +1478,7 @@ xfs_refcount_adjust_cow_extents(
 		tmp.rc_blockcount = aglen;
 		tmp.rc_refcount = 1;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.agno, &tmp);
+				cur->bc_ag.pag->pag_agno, &tmp);
 
 		error = xfs_refcount_insert(cur, &tmp,
 				&found_tmp);
@@ -1506,7 +1506,7 @@ xfs_refcount_adjust_cow_extents(
 
 		ext.rc_refcount = 0;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.agno, &ext);
+				cur->bc_ag.pag->pag_agno, &ext);
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
@@ -1522,7 +1522,7 @@ xfs_refcount_adjust_cow_extents(
 	return error;
 out_error:
 	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1568,7 +1568,7 @@ xfs_refcount_adjust_cow(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			error, _RET_IP_);
 	return error;
 }
@@ -1582,7 +1582,7 @@ __xfs_refcount_cow_alloc(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_ag.agno,
+	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
 			agbno, aglen);
 
 	/* Add refcount btree reservation */
@@ -1599,7 +1599,7 @@ __xfs_refcount_cow_free(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_ag.agno,
+	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
 			agbno, aglen);
 
 	/* Remove refcount btree reservation */
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 1794b36d..26fef861 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -64,7 +64,7 @@ xfs_refcountbt_alloc_block(
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.agno,
+	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			xfs_refc_block(args.mp));
 	args.oinfo = XFS_RMAP_OINFO_REFC;
 	args.minlen = args.maxlen = args.prod = 1;
@@ -73,13 +73,13 @@ xfs_refcountbt_alloc_block(
 	error = xfs_alloc_vextent(&args);
 	if (error)
 		goto out_error;
-	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			args.agbno, 1);
 	if (args.fsbno == NULLFSBLOCK) {
 		*stat = 0;
 		return 0;
 	}
-	ASSERT(args.agno == cur->bc_ag.agno);
+	ASSERT(args.agno == cur->bc_ag.pag->pag_agno);
 	ASSERT(args.len == 1);
 
 	new->s = cpu_to_be32(args.agbno);
@@ -104,7 +104,7 @@ xfs_refcountbt_free_block(
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	int			error;
 
-	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
@@ -169,7 +169,7 @@ xfs_refcountbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_refcount_root;
 }
@@ -333,7 +333,6 @@ xfs_refcountbt_init_common(
 	/* take a reference for the cursor */
 	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
-	cur->bc_ag.agno = pag->pag_agno;
 
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index f0621ca5..b95421ef 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -80,7 +80,7 @@ xfs_rmap_update(
 	union xfs_btree_rec	rec;
 	int			error;
 
-	trace_xfs_rmap_update(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_rmap_update(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			irec->rm_startblock, irec->rm_blockcount,
 			irec->rm_owner, irec->rm_offset, irec->rm_flags);
 
@@ -92,7 +92,7 @@ xfs_rmap_update(
 	error = xfs_btree_update(cur, &rec);
 	if (error)
 		trace_xfs_rmap_update_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -108,7 +108,7 @@ xfs_rmap_insert(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_ag.agno, agbno,
+	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_ag.pag->pag_agno, agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -134,7 +134,7 @@ xfs_rmap_insert(
 done:
 	if (error)
 		trace_xfs_rmap_insert_error(rcur->bc_mp,
-				rcur->bc_ag.agno, error, _RET_IP_);
+				rcur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -150,7 +150,7 @@ xfs_rmap_delete(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_ag.agno, agbno,
+	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_ag.pag->pag_agno, agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -171,7 +171,7 @@ xfs_rmap_delete(
 done:
 	if (error)
 		trace_xfs_rmap_delete_error(rcur->bc_mp,
-				rcur->bc_ag.agno, error, _RET_IP_);
+				rcur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -198,7 +198,7 @@ xfs_rmap_get_rec(
 	int			*stat)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_ag.agno;
+	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
 	union xfs_btree_rec	*rec;
 	int			error;
 
@@ -261,7 +261,7 @@ xfs_rmap_find_left_neighbor_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_find_left_neighbor_candidate(cur->bc_mp,
-			cur->bc_ag.agno, rec->rm_startblock,
+			cur->bc_ag.pag->pag_agno, rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -313,7 +313,7 @@ xfs_rmap_find_left_neighbor(
 	info.stat = stat;
 
 	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
-			cur->bc_ag.agno, bno, 0, owner, offset, flags);
+			cur->bc_ag.pag->pag_agno, bno, 0, owner, offset, flags);
 
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_find_left_neighbor_helper, &info);
@@ -321,7 +321,7 @@ xfs_rmap_find_left_neighbor(
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_ag.agno, irec->rm_startblock,
+				cur->bc_ag.pag->pag_agno, irec->rm_startblock,
 				irec->rm_blockcount, irec->rm_owner,
 				irec->rm_offset, irec->rm_flags);
 	return error;
@@ -337,7 +337,7 @@ xfs_rmap_lookup_le_range_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_lookup_le_range_candidate(cur->bc_mp,
-			cur->bc_ag.agno, rec->rm_startblock,
+			cur->bc_ag.pag->pag_agno, rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -386,14 +386,14 @@ xfs_rmap_lookup_le_range(
 	info.stat = stat;
 
 	trace_xfs_rmap_lookup_le_range(cur->bc_mp,
-			cur->bc_ag.agno, bno, 0, owner, offset, flags);
+			cur->bc_ag.pag->pag_agno, bno, 0, owner, offset, flags);
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_lookup_le_range_helper, &info);
 	if (error == -ECANCELED)
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_ag.agno, irec->rm_startblock,
+				cur->bc_ag.pag->pag_agno, irec->rm_startblock,
 				irec->rm_blockcount, irec->rm_owner,
 				irec->rm_offset, irec->rm_flags);
 	return error;
@@ -499,7 +499,7 @@ xfs_rmap_unmap(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -523,7 +523,7 @@ xfs_rmap_unmap(
 		goto out_error;
 	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_ag.agno, ltrec.rm_startblock,
+			cur->bc_ag.pag->pag_agno, ltrec.rm_startblock,
 			ltrec.rm_blockcount, ltrec.rm_owner,
 			ltrec.rm_offset, ltrec.rm_flags);
 	ltoff = ltrec.rm_offset;
@@ -589,7 +589,7 @@ xfs_rmap_unmap(
 
 	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
 		/* exact match, simply remove the record from rmap tree */
-		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 				ltrec.rm_startblock, ltrec.rm_blockcount,
 				ltrec.rm_owner, ltrec.rm_offset,
 				ltrec.rm_flags);
@@ -667,7 +667,7 @@ xfs_rmap_unmap(
 		else
 			cur->bc_rec.r.rm_offset = offset + len;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno,
 				cur->bc_rec.r.rm_startblock,
 				cur->bc_rec.r.rm_blockcount,
 				cur->bc_rec.r.rm_owner,
@@ -679,11 +679,11 @@ xfs_rmap_unmap(
 	}
 
 out_done:
-	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_unmap_error(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_unmap_error(mp, cur->bc_ag.pag->pag_agno,
 				error, _RET_IP_);
 	return error;
 }
@@ -774,7 +774,7 @@ xfs_rmap_map(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 	ASSERT(!xfs_rmap_should_skip_owner_update(oinfo));
 
@@ -796,7 +796,7 @@ xfs_rmap_map(
 			goto out_error;
 		}
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_ag.agno, ltrec.rm_startblock,
+				cur->bc_ag.pag->pag_agno, ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
 				ltrec.rm_offset, ltrec.rm_flags);
 
@@ -832,7 +832,7 @@ xfs_rmap_map(
 			goto out_error;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_ag.agno, gtrec.rm_startblock,
+			cur->bc_ag.pag->pag_agno, gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
@@ -871,7 +871,7 @@ xfs_rmap_map(
 			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
 			 */
 			ltrec.rm_blockcount += gtrec.rm_blockcount;
-			trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+			trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 					gtrec.rm_startblock,
 					gtrec.rm_blockcount,
 					gtrec.rm_owner,
@@ -922,7 +922,7 @@ xfs_rmap_map(
 		cur->bc_rec.r.rm_owner = owner;
 		cur->bc_rec.r.rm_offset = offset;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno, len,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			owner, offset, flags);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -933,11 +933,11 @@ xfs_rmap_map(
 		}
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_map_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_map_error(mp, cur->bc_ag.pag->pag_agno,
 				error, _RET_IP_);
 	return error;
 }
@@ -1011,7 +1011,7 @@ xfs_rmap_convert(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1035,7 +1035,7 @@ xfs_rmap_convert(
 		goto done;
 	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_ag.agno, PREV.rm_startblock,
+			cur->bc_ag.pag->pag_agno, PREV.rm_startblock,
 			PREV.rm_blockcount, PREV.rm_owner,
 			PREV.rm_offset, PREV.rm_flags);
 
@@ -1077,7 +1077,7 @@ xfs_rmap_convert(
 			goto done;
 		}
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_ag.agno, LEFT.rm_startblock,
+				cur->bc_ag.pag->pag_agno, LEFT.rm_startblock,
 				LEFT.rm_blockcount, LEFT.rm_owner,
 				LEFT.rm_offset, LEFT.rm_flags);
 		if (LEFT.rm_startblock + LEFT.rm_blockcount == bno &&
@@ -1115,7 +1115,7 @@ xfs_rmap_convert(
 			goto done;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_ag.agno, RIGHT.rm_startblock,
+				cur->bc_ag.pag->pag_agno, RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (bno + len == RIGHT.rm_startblock &&
@@ -1133,7 +1133,7 @@ xfs_rmap_convert(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.agno, state,
+	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
 			_RET_IP_);
 
 	/* reset the cursor back to PREV */
@@ -1163,7 +1163,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1181,7 +1181,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1211,7 +1211,7 @@ xfs_rmap_convert(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1248,7 +1248,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1327,7 +1327,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1384,7 +1384,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1415,7 +1415,7 @@ xfs_rmap_convert(
 		NEW = PREV;
 		NEW.rm_blockcount = offset - PREV.rm_offset;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno,
 				NEW.rm_startblock, NEW.rm_blockcount,
 				NEW.rm_owner, NEW.rm_offset,
 				NEW.rm_flags);
@@ -1442,7 +1442,7 @@ xfs_rmap_convert(
 		/* new middle extent - newext */
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno, len,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
 				owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1466,12 +1466,12 @@ xfs_rmap_convert(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_convert_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1507,7 +1507,7 @@ xfs_rmap_convert_shared(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1574,7 +1574,7 @@ xfs_rmap_convert_shared(
 			goto done;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_ag.agno, RIGHT.rm_startblock,
+				cur->bc_ag.pag->pag_agno, RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (xfs_rmap_is_mergeable(&RIGHT, owner, newext))
@@ -1590,7 +1590,7 @@ xfs_rmap_convert_shared(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.agno, state,
+	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
 			_RET_IP_);
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
@@ -1881,12 +1881,12 @@ xfs_rmap_convert_shared(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_convert_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1924,7 +1924,7 @@ xfs_rmap_unmap_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -2073,12 +2073,12 @@ xfs_rmap_unmap_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_unmap_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -2113,7 +2113,7 @@ xfs_rmap_map_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 
 	/* Is there a left record that abuts our range? */
@@ -2139,7 +2139,7 @@ xfs_rmap_map_shared(
 			goto out_error;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_ag.agno, gtrec.rm_startblock,
+			cur->bc_ag.pag->pag_agno, gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 
@@ -2232,12 +2232,12 @@ xfs_rmap_map_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_map_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -2388,7 +2388,7 @@ xfs_rmap_finish_one(
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_ag.agno != pag->pag_agno) {
+	if (rcur != NULL && rcur->bc_ag.pag != pag) {
 		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 7f71d355..47e32d20 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -462,7 +462,6 @@ xfs_rmapbt_init_common(
 	/* take a reference for the cursor */
 	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
-	cur->bc_ag.agno = pag->pag_agno;
 
 	return cur;
 }
diff --git a/repair/agbtree.c b/repair/agbtree.c
index be7831f9..f20dc9ba 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -193,7 +193,7 @@ get_bno_rec(
 	struct xfs_btree_cur	*cur,
 	struct extent_tree_node	*prev_value)
 {
-	xfs_agnumber_t		agno = cur->bc_ag.agno;
+	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
 
 	if (cur->bc_btnum == XFS_BTNUM_BNO) {
 		if (!prev_value)
@@ -355,7 +355,7 @@ get_ino_rec(
 	struct xfs_btree_cur	*cur,
 	struct ino_tree_node	*prev_value)
 {
-	xfs_agnumber_t		agno = cur->bc_ag.agno;
+	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
 
 	if (cur->bc_btnum == XFS_BTNUM_INO) {
 		if (!prev_value)

