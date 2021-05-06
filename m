Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF142C433B4
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9098E611CB
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhEFHjq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 03:39:46 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:50164 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229908AbhEFHjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 03:39:45 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 5091380B079
        for <linux-xfs@vger.kernel.org>; Thu,  6 May 2021 17:38:45 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-005loQ-Id
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-00197k-9I
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/22] xfs: remove agno from btree cursor
Date:   Thu,  6 May 2021 17:20:48 +1000
Message-Id: <20210506072054.271157-17-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210506072054.271157-1-david@fromorbit.com>
References: <20210506072054.271157-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=MeUIpdCaB2E3Dnhj9pkA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that everything passes a perag, the agno is not needed anymore.
Convert all the users to use pag->pag_agno instead and remove the
agno from the cursor. This was largely done as an automated search
and replace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |   2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |   1 -
 fs/xfs/libxfs/xfs_btree.c          |  12 ++--
 fs/xfs/libxfs/xfs_btree.h          |   1 -
 fs/xfs/libxfs/xfs_ialloc.c         |   2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   7 +-
 fs/xfs/libxfs/xfs_refcount.c       |  82 +++++++++++-----------
 fs/xfs/libxfs/xfs_refcount_btree.c |  11 ++-
 fs/xfs/libxfs/xfs_rmap.c           | 108 ++++++++++++++---------------
 fs/xfs/libxfs/xfs_rmap_btree.c     |   1 -
 fs/xfs/scrub/agheader_repair.c     |   2 +-
 fs/xfs/scrub/alloc.c               |   3 +-
 fs/xfs/scrub/bmap.c                |   2 +-
 fs/xfs/scrub/ialloc.c              |   9 +--
 fs/xfs/scrub/refcount.c            |   3 +-
 fs/xfs/scrub/rmap.c                |   3 +-
 fs/xfs/scrub/trace.c               |   3 +-
 fs/xfs/xfs_fsmap.c                 |   4 +-
 fs/xfs/xfs_trace.h                 |   4 +-
 19 files changed, 130 insertions(+), 130 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c99a80286efa..f7864f33c1f0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -230,7 +230,7 @@ xfs_alloc_get_rec(
 	int			*stat)	/* output: success/failure */
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_ag.agno;
+	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
 	union xfs_btree_rec	*rec;
 	int			error;
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 0c2e4cff4ee3..6b363f78cfa2 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -497,7 +497,6 @@ xfs_allocbt_init_common(
 	/* take a reference for the cursor */
 	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
-	cur->bc_ag.agno = pag->pag_agno;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 44044317c0fb..be74a6b53689 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -216,7 +216,7 @@ xfs_btree_check_sptr(
 {
 	if (level <= 0)
 		return false;
-	return xfs_verify_agbno(cur->bc_mp, cur->bc_ag.agno, agbno);
+	return xfs_verify_agbno(cur->bc_mp, cur->bc_ag.pag->pag_agno, agbno);
 }
 
 /*
@@ -245,7 +245,7 @@ xfs_btree_check_ptr(
 			return 0;
 		xfs_err(cur->bc_mp,
 "AG %u: Corrupt btree %d pointer at level %d index %d.",
-				cur->bc_ag.agno, cur->bc_btnum,
+				cur->bc_ag.pag->pag_agno, cur->bc_btnum,
 				level, index);
 	}
 
@@ -888,13 +888,13 @@ xfs_btree_readahead_sblock(
 
 
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
@@ -952,7 +952,7 @@ xfs_btree_ptr_to_daddr(
 		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, fsbno);
 	} else {
 		agbno = be32_to_cpu(ptr->s);
-		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_ag.agno,
+		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 				agbno);
 	}
 
@@ -1153,7 +1153,7 @@ xfs_btree_init_block_cur(
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		owner = cur->bc_ino.ip->i_ino;
 	else
-		owner = cur->bc_ag.agno;
+		owner = cur->bc_ag.pag->pag_agno;
 
 	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
 				 cur->bc_btnum, level, numrecs,
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 8233f8679ba9..13bbcf107e5d 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -181,7 +181,6 @@ union xfs_btree_irec {
 
 /* Per-AG btree information. */
 struct xfs_btree_cur_ag {
-	xfs_agnumber_t		agno;
 	struct xfs_perag	*pag;
 	union {
 		struct xfs_buf		*agbp;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index e6f64d41e208..4540fbcd68a3 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -105,7 +105,7 @@ xfs_inobt_get_rec(
 	int				*stat)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	xfs_agnumber_t			agno = cur->bc_ag.agno;
+	xfs_agnumber_t			agno = cur->bc_ag.pag->pag_agno;
 	union xfs_btree_rec		*rec;
 	int				error;
 	uint64_t			realfree;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 450161b53648..823a038939f8 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -102,7 +102,7 @@ __xfs_inobt_alloc_block(
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	args.oinfo = XFS_RMAP_OINFO_INOBT;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.agno, sbno);
+	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.pag->pag_agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
 	args.prod = 1;
@@ -235,7 +235,7 @@ xfs_inobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.agno == be32_to_cpu(agi->agi_seqno));
+	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agi->agi_seqno));
 
 	ptr->s = agi->agi_root;
 }
@@ -247,7 +247,7 @@ xfs_finobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.agno == be32_to_cpu(agi->agi_seqno));
+	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agi->agi_seqno));
 	ptr->s = agi->agi_free_root;
 }
 
@@ -452,7 +452,6 @@ xfs_inobt_init_common(
 	/* take a reference for the cursor */
 	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
-	cur->bc_ag.agno = pag->pag_agno;
 	return cur;
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 3c2b99cbd57d..82b2810d85a6 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -47,7 +47,7 @@ xfs_refcount_lookup_le(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -64,7 +64,7 @@ xfs_refcount_lookup_ge(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
 			XFS_LOOKUP_GE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -81,7 +81,7 @@ xfs_refcount_lookup_eq(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.agno, bno,
+	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
 	cur->bc_rec.rc.rc_blockcount = 0;
@@ -109,7 +109,7 @@ xfs_refcount_get_rec(
 	int				*stat)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	xfs_agnumber_t			agno = cur->bc_ag.agno;
+	xfs_agnumber_t			agno = cur->bc_ag.pag->pag_agno;
 	union xfs_btree_rec		*rec;
 	int				error;
 	xfs_agblock_t			realstart;
@@ -120,7 +120,7 @@ xfs_refcount_get_rec(
 
 	xfs_refcount_btrec_to_irec(rec, irec);
 
-	agno = cur->bc_ag.agno;
+	agno = cur->bc_ag.pag->pag_agno;
 	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
 		goto out_bad_rec;
 
@@ -145,7 +145,7 @@ xfs_refcount_get_rec(
 	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
 		goto out_bad_rec;
 
-	trace_xfs_refcount_get(cur->bc_mp, cur->bc_ag.agno, irec);
+	trace_xfs_refcount_get(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
 	return 0;
 
 out_bad_rec:
@@ -170,14 +170,14 @@ xfs_refcount_update(
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
 
@@ -194,7 +194,7 @@ xfs_refcount_insert(
 {
 	int				error;
 
-	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_ag.agno, irec);
+	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
 	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
 	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
 	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
@@ -209,7 +209,7 @@ xfs_refcount_insert(
 out_error:
 	if (error)
 		trace_xfs_refcount_insert_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -235,7 +235,7 @@ xfs_refcount_delete(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
-	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_ag.agno, &irec);
+	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_ag.pag->pag_agno, &irec);
 	error = xfs_btree_delete(cur, i);
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
 		error = -EFSCORRUPTED;
@@ -247,7 +247,7 @@ xfs_refcount_delete(
 out_error:
 	if (error)
 		trace_xfs_refcount_delete_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -367,7 +367,7 @@ xfs_refcount_split_extent(
 		return 0;
 
 	*shape_changed = true;
-	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			&rcext, agbno);
 
 	/* Establish the right extent. */
@@ -392,7 +392,7 @@ xfs_refcount_split_extent(
 
 out_error:
 	trace_xfs_refcount_split_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -412,7 +412,7 @@ xfs_refcount_merge_center_extents(
 	int				found_rec;
 
 	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
-			cur->bc_ag.agno, left, center, right);
+			cur->bc_ag.pag->pag_agno, left, center, right);
 
 	/*
 	 * Make sure the center and right extents are not in the btree.
@@ -469,7 +469,7 @@ xfs_refcount_merge_center_extents(
 
 out_error:
 	trace_xfs_refcount_merge_center_extents_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -488,7 +488,7 @@ xfs_refcount_merge_left_extent(
 	int				found_rec;
 
 	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
-			cur->bc_ag.agno, left, cleft);
+			cur->bc_ag.pag->pag_agno, left, cleft);
 
 	/* If the extent at agbno (cleft) wasn't synthesized, remove it. */
 	if (cleft->rc_refcount > 1) {
@@ -531,7 +531,7 @@ xfs_refcount_merge_left_extent(
 
 out_error:
 	trace_xfs_refcount_merge_left_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -549,7 +549,7 @@ xfs_refcount_merge_right_extent(
 	int				found_rec;
 
 	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
-			cur->bc_ag.agno, cright, right);
+			cur->bc_ag.pag->pag_agno, cright, right);
 
 	/*
 	 * If the extent ending at agbno+aglen (cright) wasn't synthesized,
@@ -595,7 +595,7 @@ xfs_refcount_merge_right_extent(
 
 out_error:
 	trace_xfs_refcount_merge_right_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -680,13 +680,13 @@ xfs_refcount_find_left_extents(
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
 
@@ -769,13 +769,13 @@ xfs_refcount_find_right_extents(
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
 
@@ -953,7 +953,7 @@ xfs_refcount_adjust_extents(
 					ext.rc_startblock - *agbno);
 			tmp.rc_refcount = 1 + adj;
 			trace_xfs_refcount_modify_extent(cur->bc_mp,
-					cur->bc_ag.agno, &tmp);
+					cur->bc_ag.pag->pag_agno, &tmp);
 
 			/*
 			 * Either cover the hole (increment) or
@@ -972,7 +972,7 @@ xfs_refcount_adjust_extents(
 				cur->bc_ag.refc.nr_ops++;
 			} else {
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-						cur->bc_ag.agno,
+						cur->bc_ag.pag->pag_agno,
 						tmp.rc_startblock);
 				xfs_bmap_add_free(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, oinfo);
@@ -999,7 +999,7 @@ xfs_refcount_adjust_extents(
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.agno, &ext);
+				cur->bc_ag.pag->pag_agno, &ext);
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
@@ -1017,7 +1017,7 @@ xfs_refcount_adjust_extents(
 			goto advloop;
 		} else {
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-					cur->bc_ag.agno,
+					cur->bc_ag.pag->pag_agno,
 					ext.rc_startblock);
 			xfs_bmap_add_free(cur->bc_tp, fsbno, ext.rc_blockcount,
 					  oinfo);
@@ -1036,7 +1036,7 @@ xfs_refcount_adjust_extents(
 	return error;
 out_error:
 	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1058,10 +1058,10 @@ xfs_refcount_adjust(
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
@@ -1100,7 +1100,7 @@ xfs_refcount_adjust(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			error, _RET_IP_);
 	return error;
 }
@@ -1298,7 +1298,7 @@ xfs_refcount_find_shared(
 	int				have;
 	int				error;
 
-	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			agbno, aglen);
 
 	/* By default, skip the whole range */
@@ -1378,12 +1378,12 @@ xfs_refcount_find_shared(
 
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
 
@@ -1480,7 +1480,7 @@ xfs_refcount_adjust_cow_extents(
 		tmp.rc_blockcount = aglen;
 		tmp.rc_refcount = 1;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.agno, &tmp);
+				cur->bc_ag.pag->pag_agno, &tmp);
 
 		error = xfs_refcount_insert(cur, &tmp,
 				&found_tmp);
@@ -1508,7 +1508,7 @@ xfs_refcount_adjust_cow_extents(
 
 		ext.rc_refcount = 0;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.agno, &ext);
+				cur->bc_ag.pag->pag_agno, &ext);
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
@@ -1524,7 +1524,7 @@ xfs_refcount_adjust_cow_extents(
 	return error;
 out_error:
 	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
-			cur->bc_ag.agno, error, _RET_IP_);
+			cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -1570,7 +1570,7 @@ xfs_refcount_adjust_cow(
 	return 0;
 
 out_error:
-	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcount_adjust_cow_error(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			error, _RET_IP_);
 	return error;
 }
@@ -1584,7 +1584,7 @@ __xfs_refcount_cow_alloc(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_ag.agno,
+	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
 			agbno, aglen);
 
 	/* Add refcount btree reservation */
@@ -1601,7 +1601,7 @@ __xfs_refcount_cow_free(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_ag.agno,
+	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
 			agbno, aglen);
 
 	/* Remove refcount btree reservation */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 8f6577cb3475..92d336c17e83 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -65,7 +65,7 @@ xfs_refcountbt_alloc_block(
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.agno,
+	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			xfs_refc_block(args.mp));
 	args.oinfo = XFS_RMAP_OINFO_REFC;
 	args.minlen = args.maxlen = args.prod = 1;
@@ -74,13 +74,13 @@ xfs_refcountbt_alloc_block(
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
@@ -105,7 +105,7 @@ xfs_refcountbt_free_block(
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	int			error;
 
-	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
@@ -170,7 +170,7 @@ xfs_refcountbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_refcount_root;
 }
@@ -334,7 +334,6 @@ xfs_refcountbt_init_common(
 	/* take a reference for the cursor */
 	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
-	cur->bc_ag.agno = pag->pag_agno;
 
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index b23f949ee15c..d1dfad0204e3 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -81,7 +81,7 @@ xfs_rmap_update(
 	union xfs_btree_rec	rec;
 	int			error;
 
-	trace_xfs_rmap_update(cur->bc_mp, cur->bc_ag.agno,
+	trace_xfs_rmap_update(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			irec->rm_startblock, irec->rm_blockcount,
 			irec->rm_owner, irec->rm_offset, irec->rm_flags);
 
@@ -93,7 +93,7 @@ xfs_rmap_update(
 	error = xfs_btree_update(cur, &rec);
 	if (error)
 		trace_xfs_rmap_update_error(cur->bc_mp,
-				cur->bc_ag.agno, error, _RET_IP_);
+				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -109,7 +109,7 @@ xfs_rmap_insert(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_ag.agno, agbno,
+	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_ag.pag->pag_agno, agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -135,7 +135,7 @@ xfs_rmap_insert(
 done:
 	if (error)
 		trace_xfs_rmap_insert_error(rcur->bc_mp,
-				rcur->bc_ag.agno, error, _RET_IP_);
+				rcur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -151,7 +151,7 @@ xfs_rmap_delete(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_ag.agno, agbno,
+	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_ag.pag->pag_agno, agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -172,7 +172,7 @@ xfs_rmap_delete(
 done:
 	if (error)
 		trace_xfs_rmap_delete_error(rcur->bc_mp,
-				rcur->bc_ag.agno, error, _RET_IP_);
+				rcur->bc_ag.pag->pag_agno, error, _RET_IP_);
 	return error;
 }
 
@@ -199,7 +199,7 @@ xfs_rmap_get_rec(
 	int			*stat)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_ag.agno;
+	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
 	union xfs_btree_rec	*rec;
 	int			error;
 
@@ -262,7 +262,7 @@ xfs_rmap_find_left_neighbor_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_find_left_neighbor_candidate(cur->bc_mp,
-			cur->bc_ag.agno, rec->rm_startblock,
+			cur->bc_ag.pag->pag_agno, rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -314,7 +314,7 @@ xfs_rmap_find_left_neighbor(
 	info.stat = stat;
 
 	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
-			cur->bc_ag.agno, bno, 0, owner, offset, flags);
+			cur->bc_ag.pag->pag_agno, bno, 0, owner, offset, flags);
 
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_find_left_neighbor_helper, &info);
@@ -322,7 +322,7 @@ xfs_rmap_find_left_neighbor(
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_ag.agno, irec->rm_startblock,
+				cur->bc_ag.pag->pag_agno, irec->rm_startblock,
 				irec->rm_blockcount, irec->rm_owner,
 				irec->rm_offset, irec->rm_flags);
 	return error;
@@ -338,7 +338,7 @@ xfs_rmap_lookup_le_range_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_lookup_le_range_candidate(cur->bc_mp,
-			cur->bc_ag.agno, rec->rm_startblock,
+			cur->bc_ag.pag->pag_agno, rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -387,14 +387,14 @@ xfs_rmap_lookup_le_range(
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
@@ -500,7 +500,7 @@ xfs_rmap_unmap(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -524,7 +524,7 @@ xfs_rmap_unmap(
 		goto out_error;
 	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_ag.agno, ltrec.rm_startblock,
+			cur->bc_ag.pag->pag_agno, ltrec.rm_startblock,
 			ltrec.rm_blockcount, ltrec.rm_owner,
 			ltrec.rm_offset, ltrec.rm_flags);
 	ltoff = ltrec.rm_offset;
@@ -590,7 +590,7 @@ xfs_rmap_unmap(
 
 	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
 		/* exact match, simply remove the record from rmap tree */
-		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 				ltrec.rm_startblock, ltrec.rm_blockcount,
 				ltrec.rm_owner, ltrec.rm_offset,
 				ltrec.rm_flags);
@@ -668,7 +668,7 @@ xfs_rmap_unmap(
 		else
 			cur->bc_rec.r.rm_offset = offset + len;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno,
 				cur->bc_rec.r.rm_startblock,
 				cur->bc_rec.r.rm_blockcount,
 				cur->bc_rec.r.rm_owner,
@@ -680,11 +680,11 @@ xfs_rmap_unmap(
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
@@ -775,7 +775,7 @@ xfs_rmap_map(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 	ASSERT(!xfs_rmap_should_skip_owner_update(oinfo));
 
@@ -797,7 +797,7 @@ xfs_rmap_map(
 			goto out_error;
 		}
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_ag.agno, ltrec.rm_startblock,
+				cur->bc_ag.pag->pag_agno, ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
 				ltrec.rm_offset, ltrec.rm_flags);
 
@@ -833,7 +833,7 @@ xfs_rmap_map(
 			goto out_error;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_ag.agno, gtrec.rm_startblock,
+			cur->bc_ag.pag->pag_agno, gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
@@ -872,7 +872,7 @@ xfs_rmap_map(
 			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
 			 */
 			ltrec.rm_blockcount += gtrec.rm_blockcount;
-			trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+			trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 					gtrec.rm_startblock,
 					gtrec.rm_blockcount,
 					gtrec.rm_owner,
@@ -923,7 +923,7 @@ xfs_rmap_map(
 		cur->bc_rec.r.rm_owner = owner;
 		cur->bc_rec.r.rm_offset = offset;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno, len,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			owner, offset, flags);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -934,11 +934,11 @@ xfs_rmap_map(
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
@@ -1012,7 +1012,7 @@ xfs_rmap_convert(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1036,7 +1036,7 @@ xfs_rmap_convert(
 		goto done;
 	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_ag.agno, PREV.rm_startblock,
+			cur->bc_ag.pag->pag_agno, PREV.rm_startblock,
 			PREV.rm_blockcount, PREV.rm_owner,
 			PREV.rm_offset, PREV.rm_flags);
 
@@ -1078,7 +1078,7 @@ xfs_rmap_convert(
 			goto done;
 		}
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_ag.agno, LEFT.rm_startblock,
+				cur->bc_ag.pag->pag_agno, LEFT.rm_startblock,
 				LEFT.rm_blockcount, LEFT.rm_owner,
 				LEFT.rm_offset, LEFT.rm_flags);
 		if (LEFT.rm_startblock + LEFT.rm_blockcount == bno &&
@@ -1116,7 +1116,7 @@ xfs_rmap_convert(
 			goto done;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_ag.agno, RIGHT.rm_startblock,
+				cur->bc_ag.pag->pag_agno, RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (bno + len == RIGHT.rm_startblock &&
@@ -1134,7 +1134,7 @@ xfs_rmap_convert(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.agno, state,
+	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
 			_RET_IP_);
 
 	/* reset the cursor back to PREV */
@@ -1164,7 +1164,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1182,7 +1182,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1212,7 +1212,7 @@ xfs_rmap_convert(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1249,7 +1249,7 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1328,7 +1328,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1385,7 +1385,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1416,7 +1416,7 @@ xfs_rmap_convert(
 		NEW = PREV;
 		NEW.rm_blockcount = offset - PREV.rm_offset;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno,
 				NEW.rm_startblock, NEW.rm_blockcount,
 				NEW.rm_owner, NEW.rm_offset,
 				NEW.rm_flags);
@@ -1443,7 +1443,7 @@ xfs_rmap_convert(
 		/* new middle extent - newext */
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.agno, bno, len,
+		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
 				owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1467,12 +1467,12 @@ xfs_rmap_convert(
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
 
@@ -1508,7 +1508,7 @@ xfs_rmap_convert_shared(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1575,7 +1575,7 @@ xfs_rmap_convert_shared(
 			goto done;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_ag.agno, RIGHT.rm_startblock,
+				cur->bc_ag.pag->pag_agno, RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (xfs_rmap_is_mergeable(&RIGHT, owner, newext))
@@ -1591,7 +1591,7 @@ xfs_rmap_convert_shared(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.agno, state,
+	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
 			_RET_IP_);
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
@@ -1882,12 +1882,12 @@ xfs_rmap_convert_shared(
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
 
@@ -1925,7 +1925,7 @@ xfs_rmap_unmap_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -2074,12 +2074,12 @@ xfs_rmap_unmap_shared(
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
 
@@ -2114,7 +2114,7 @@ xfs_rmap_map_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.agno, bno, len,
+	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
 			unwritten, oinfo);
 
 	/* Is there a left record that abuts our range? */
@@ -2140,7 +2140,7 @@ xfs_rmap_map_shared(
 			goto out_error;
 		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_ag.agno, gtrec.rm_startblock,
+			cur->bc_ag.pag->pag_agno, gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 
@@ -2233,12 +2233,12 @@ xfs_rmap_map_shared(
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
 
@@ -2389,7 +2389,7 @@ xfs_rmap_finish_one(
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_ag.agno != pag->pag_agno) {
+	if (rcur != NULL && rcur->bc_ag.pag != pag) {
 		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index cafe181bc92d..f29bc71b9950 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -464,7 +464,6 @@ xfs_rmapbt_init_common(
 	/* take a reference for the cursor */
 	atomic_inc(&pag->pag_ref);
 	cur->bc_ag.pag = pag;
-	cur->bc_ag.agno = pag->pag_agno;
 
 	return cur;
 }
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index ecc9146647ba..e95f8c98f0f7 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -454,7 +454,7 @@ xrep_agfl_walk_rmap(
 
 	/* Record all the OWN_AG blocks. */
 	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
-		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.agno,
+		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 				rec->rm_startblock);
 		error = xbitmap_set(ra->freesp, fsb, rec->rm_blockcount);
 		if (error)
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 2720bd7fe53b..d5741980094a 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -15,6 +15,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "xfs_ag.h"
 
 /*
  * Set us up to scrub free space btrees.
@@ -93,7 +94,7 @@ xchk_allocbt_rec(
 	union xfs_btree_rec	*rec)
 {
 	struct xfs_mount	*mp = bs->cur->bc_mp;
-	xfs_agnumber_t		agno = bs->cur->bc_ag.agno;
+	xfs_agnumber_t		agno = bs->cur->bc_ag.pag->pag_agno;
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 5adef162115d..b9c205a2fede 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -515,7 +515,7 @@ xchk_bmap_check_rmap(
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					rec->rm_offset);
 		if (irec.br_startblock != XFS_AGB_TO_FSB(sc->mp,
-				cur->bc_ag.agno, rec->rm_startblock))
+				cur->bc_ag.pag->pag_agno, rec->rm_startblock))
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					rec->rm_offset);
 		if (irec.br_blockcount > rec->rm_blockcount)
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 8d9f3fb0cd22..30e568596b79 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -21,6 +21,7 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
+#include "xfs_ag.h"
 
 /*
  * Set us up to scrub inode btrees.
@@ -103,7 +104,7 @@ xchk_iallocbt_chunk(
 	xfs_extlen_t			len)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
-	xfs_agnumber_t			agno = bs->cur->bc_ag.agno;
+	xfs_agnumber_t			agno = bs->cur->bc_ag.pag->pag_agno;
 	xfs_agblock_t			bno;
 
 	bno = XFS_AGINO_TO_AGBNO(mp, agino);
@@ -163,7 +164,7 @@ xchk_iallocbt_check_cluster_ifree(
 	 * the record, compute which fs inode we're talking about.
 	 */
 	agino = irec->ir_startino + irec_ino;
-	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_ag.agno, agino);
+	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_ag.pag->pag_agno, agino);
 	irec_free = (irec->ir_free & XFS_INOBT_MASK(irec_ino));
 
 	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC ||
@@ -213,7 +214,7 @@ xchk_iallocbt_check_cluster(
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_buf			*cluster_bp;
 	unsigned int			nr_inodes;
-	xfs_agnumber_t			agno = bs->cur->bc_ag.agno;
+	xfs_agnumber_t			agno = bs->cur->bc_ag.pag->pag_agno;
 	xfs_agblock_t			agbno;
 	unsigned int			cluster_index;
 	uint16_t			cluster_mask = 0;
@@ -423,7 +424,7 @@ xchk_iallocbt_rec(
 	struct xchk_iallocbt		*iabt = bs->private;
 	struct xfs_inobt_rec_incore	irec;
 	uint64_t			holes;
-	xfs_agnumber_t			agno = bs->cur->bc_ag.agno;
+	xfs_agnumber_t			agno = bs->cur->bc_ag.pag->pag_agno;
 	xfs_agino_t			agino;
 	xfs_extlen_t			len;
 	int				holecount;
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 744530a66c0c..7014b7408bad 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -13,6 +13,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "xfs_ag.h"
 
 /*
  * Set us up to scrub reference count btrees.
@@ -333,7 +334,7 @@ xchk_refcountbt_rec(
 {
 	struct xfs_mount	*mp = bs->cur->bc_mp;
 	xfs_agblock_t		*cow_blocks = bs->private;
-	xfs_agnumber_t		agno = bs->cur->bc_ag.agno;
+	xfs_agnumber_t		agno = bs->cur->bc_ag.pag->pag_agno;
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
 	xfs_nlink_t		refcount;
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index a4f17477c5d1..fc306573f0ac 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -15,6 +15,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "xfs_ag.h"
 
 /*
  * Set us up to scrub reverse mapping btrees.
@@ -91,7 +92,7 @@ xchk_rmapbt_rec(
 {
 	struct xfs_mount	*mp = bs->cur->bc_mp;
 	struct xfs_rmap_irec	irec;
-	xfs_agnumber_t		agno = bs->cur->bc_ag.agno;
+	xfs_agnumber_t		agno = bs->cur->bc_ag.pag->pag_agno;
 	bool			non_inode;
 	bool			is_unwritten;
 	bool			is_bmbt;
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 2c6c248be823..03882a605a3c 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -13,6 +13,7 @@
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "scrub/scrub.h"
+#include "xfs_ag.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
@@ -26,7 +27,7 @@ xchk_btree_cur_fsbno(
 		 cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
 	else if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
-		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.agno, 0);
+		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno, 0);
 	return NULLFSBLOCK;
 }
 
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 7501dd941a63..7d0b09c1366e 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -355,7 +355,7 @@ xfs_getfsmap_datadev_helper(
 	xfs_fsblock_t			fsb;
 	xfs_daddr_t			rec_daddr;
 
-	fsb = XFS_AGB_TO_FSB(mp, cur->bc_ag.agno, rec->rm_startblock);
+	fsb = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno, rec->rm_startblock);
 	rec_daddr = XFS_FSB_TO_DADDR(mp, fsb);
 
 	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
@@ -373,7 +373,7 @@ xfs_getfsmap_datadev_bnobt_helper(
 	struct xfs_rmap_irec		irec;
 	xfs_daddr_t			rec_daddr;
 
-	rec_daddr = XFS_AGB_TO_DADDR(mp, cur->bc_ag.agno,
+	rec_daddr = XFS_AGB_TO_DADDR(mp, cur->bc_ag.pag->pag_agno,
 			rec->ar_startblock);
 
 	irec.rm_startblock = rec->ar_startblock;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 808ae337b222..5ba9c6396dcb 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3730,7 +3730,7 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
 		__entry->btnum = cur->bc_btnum;
-		__entry->agno = cur->bc_ag.agno;
+		__entry->agno = cur->bc_ag.pag->pag_agno;
 		__entry->agbno = cur->bc_ag.afake->af_root;
 		__entry->levels = cur->bc_ag.afake->af_levels;
 		__entry->blocks = cur->bc_ag.afake->af_blocks;
@@ -3845,7 +3845,7 @@ TRACE_EVENT(xfs_btree_bload_block,
 			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);
 			__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsb);
 		} else {
-			__entry->agno = cur->bc_ag.agno;
+			__entry->agno = cur->bc_ag.pag->pag_agno;
 			__entry->agbno = be32_to_cpu(ptr->s);
 		}
 		__entry->nr_records = nr_records;
-- 
2.31.1

