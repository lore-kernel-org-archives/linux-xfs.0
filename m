Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74374C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A4D0610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhIOXK2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXK1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:10:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7B4F610A4;
        Wed, 15 Sep 2021 23:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747347;
        bh=oDJ165+vGkrvTKvPuoCJeeaAE25u4IYm3cKlNewHW2g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oVOAfCQ/00PovLkccmuesbZpoTp/t5h3tKJ0vtrAdQ84ruLejR1yCirF/BAjYF5Ez
         8BCOxZyt5vqZOhOvRgZqT/7FcBN6EORzVXFntc4fOz4fwFGc8ideQYVgi9BfF4TDaS
         PQyz1dcGcnorBE+olqw71LxM/+cGW8kOt/9jQMFOKWRcLMS6Uv3WIRsTxDu4MI4a9E
         u8CtCf/rOMioKHhv3kDkcAxBlBxczPqiUkDBcMG9kl7YoYZNPdeHEdTHgnHXeI2KNM
         us3mTW/mxDYuzHuFUlDGP/1xWzO+WTdjYlyBT08oEkRgNJ5BMx4xBYannPIsS2T/dx
         boMABxQjWU1JA==
Subject: [PATCH 28/61] xfs: pass perags through to the busy extent code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:09:07 -0700
Message-ID: <163174734754.350433.3891889253499929151.stgit@magnolia>
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

Source kernel commit: 45d0662117565e6100f9e0cf356cd873542c95b1

All of the callers of the busy extent API either have perag
references available to use so we can pass a perag to the busy
extent functions rather than having them have to do unnecessary
lookups.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h     |    4 ++--
 libxfs/xfs_alloc.c       |   37 +++++++++++++++++++------------------
 libxfs/xfs_alloc.h       |    2 +-
 libxfs/xfs_alloc_btree.c |    5 ++---
 libxfs/xfs_rmap.c        |   32 +++++++++++++++++++-------------
 libxfs/xfs_rmap_btree.c  |    9 ++++-----
 6 files changed, 47 insertions(+), 42 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 110a88a9..b9cb302a 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -486,8 +486,8 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 
 #define xfs_extent_busy_reuse(mp,ag,bno,len,user)	((void) 0)
 /* avoid unused variable warning */
-#define xfs_extent_busy_insert(tp,ag,bno,len,flags)({ 	\
-	xfs_agnumber_t __foo = ag; 			\
+#define xfs_extent_busy_insert(tp,pag,bno,len,flags)({ 	\
+	struct xfs_perag *__foo = pag;			\
 	__foo = __foo; /* no set-but-unused warning */	\
 })
 #define xfs_extent_busy_trim(args,bno,len,busy_gen) 	({	\
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 37f10751..c69761eb 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1059,7 +1059,7 @@ xfs_alloc_ag_vextent_small(
 	if (fbno == NULLAGBLOCK)
 		goto out;
 
-	xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
+	xfs_extent_busy_reuse(args->mp, args->pag, fbno, 1,
 			      (args->datatype & XFS_ALLOC_NOBUSY));
 
 	if (args->datatype & XFS_ALLOC_USERDATA) {
@@ -1174,7 +1174,7 @@ xfs_alloc_ag_vextent(
 		if (error)
 			return error;
 
-		ASSERT(!xfs_extent_busy_search(args->mp, args->agno,
+		ASSERT(!xfs_extent_busy_search(args->mp, args->pag,
 					      args->agbno, args->len));
 	}
 
@@ -3288,7 +3288,7 @@ xfs_alloc_vextent(
 int
 xfs_free_extent_fix_freelist(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	struct xfs_buf		**agbp)
 {
 	struct xfs_alloc_arg	args;
@@ -3297,7 +3297,8 @@ xfs_free_extent_fix_freelist(
 	memset(&args, 0, sizeof(struct xfs_alloc_arg));
 	args.tp = tp;
 	args.mp = tp->t_mountp;
-	args.agno = agno;
+	args.agno = pag->pag_agno;
+	args.pag = pag;
 
 	/*
 	 * validate that the block number is legal - the enables us to detect
@@ -3306,17 +3307,12 @@ xfs_free_extent_fix_freelist(
 	if (args.agno >= args.mp->m_sb.sb_agcount)
 		return -EFSCORRUPTED;
 
-	args.pag = xfs_perag_get(args.mp, args.agno);
-	ASSERT(args.pag);
-
 	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
 	if (error)
-		goto out;
+		return error;
 
 	*agbp = args.agbp;
-out:
-	xfs_perag_put(args.pag);
-	return error;
+	return 0;
 }
 
 /*
@@ -3340,6 +3336,7 @@ __xfs_free_extent(
 	struct xfs_agf			*agf;
 	int				error;
 	unsigned int			busy_flags = 0;
+	struct xfs_perag		*pag;
 
 	ASSERT(len != 0);
 	ASSERT(type != XFS_AG_RESV_AGFL);
@@ -3348,33 +3345,37 @@ __xfs_free_extent(
 			XFS_ERRTAG_FREE_EXTENT))
 		return -EIO;
 
-	error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
+	pag = xfs_perag_get(mp, agno);
+	error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
 	if (error)
-		return error;
+		goto err;
 	agf = agbp->b_addr;
 
 	if (XFS_IS_CORRUPT(mp, agbno >= mp->m_sb.sb_agblocks)) {
 		error = -EFSCORRUPTED;
-		goto err;
+		goto err_release;
 	}
 
 	/* validate the extent size is legal now we have the agf locked */
 	if (XFS_IS_CORRUPT(mp, agbno + len > be32_to_cpu(agf->agf_length))) {
 		error = -EFSCORRUPTED;
-		goto err;
+		goto err_release;
 	}
 
 	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, oinfo, type);
 	if (error)
-		goto err;
+		goto err_release;
 
 	if (skip_discard)
 		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
-	xfs_extent_busy_insert(tp, agno, agbno, len, busy_flags);
+	xfs_extent_busy_insert(tp, pag, agbno, len, busy_flags);
+	xfs_perag_put(pag);
 	return 0;
 
-err:
+err_release:
 	xfs_trans_brelse(tp, agbp);
+err:
+	xfs_perag_put(pag);
 	return error;
 }
 
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index a4427c57..e30900b6 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -214,7 +214,7 @@ int xfs_alloc_read_agfl(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
 			struct xfs_buf *, struct xfs_owner_info *);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
-int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
+int xfs_free_extent_fix_freelist(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_buf **agbp);
 
 xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index fa1d3a0f..00a17bb0 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -70,7 +70,7 @@ xfs_allocbt_alloc_block(
 	}
 
 	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agbp->b_pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 
@@ -84,7 +84,6 @@ xfs_allocbt_free_block(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
-	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -94,7 +93,7 @@ xfs_allocbt_free_block(
 		return error;
 
 	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
+	xfs_extent_busy_insert(cur->bc_tp, agbp->b_pag, bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	return 0;
 }
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 631c62c0..6323ccdc 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -11,6 +11,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_sb.h"
 #include "xfs_defer.h"
 #include "xfs_btree.h"
 #include "xfs_trans.h"
@@ -2362,31 +2363,32 @@ xfs_rmap_finish_one(
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_perag		*pag;
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
 	int				error = 0;
-	xfs_agnumber_t			agno;
 	struct xfs_owner_info		oinfo;
 	xfs_agblock_t			bno;
 	bool				unwritten;
 
-	agno = XFS_FSB_TO_AGNO(mp, startblock);
-	ASSERT(agno != NULLAGNUMBER);
+	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, startblock));
 	bno = XFS_FSB_TO_AGBNO(mp, startblock);
 
-	trace_xfs_rmap_deferred(mp, agno, type, bno, owner, whichfork,
+	trace_xfs_rmap_deferred(mp, pag->pag_agno, type, bno, owner, whichfork,
 			startoff, blockcount, state);
 
-	if (XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_RMAP_FINISH_ONE))
-		return -EIO;
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE)) {
+		error = -EIO;
+		goto out_drop;
+	}
+
 
 	/*
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_ag.agno != agno) {
+	if (rcur != NULL && rcur->bc_ag.agno != pag->pag_agno) {
 		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
@@ -2397,13 +2399,15 @@ xfs_rmap_finish_one(
 		 * rmapbt, because a shape change could cause us to
 		 * allocate blocks.
 		 */
-		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
+		error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
 		if (error)
-			return error;
-		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
-			return -EFSCORRUPTED;
+			goto out_drop;
+		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
+			error = -EFSCORRUPTED;
+			goto out_drop;
+		}
 
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag->pag_agno);
 	}
 	*pcur = rcur;
 
@@ -2441,6 +2445,8 @@ xfs_rmap_finish_one(
 		ASSERT(0);
 		error = -EFSCORRUPTED;
 	}
+out_drop:
+	xfs_perag_put(pag);
 	return error;
 }
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index bcbe9833..7abca87e 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -98,8 +98,7 @@ xfs_rmapbt_alloc_block(
 		return 0;
 	}
 
-	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1,
-			false);
+	xfs_extent_busy_reuse(cur->bc_mp, agbp->b_pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
@@ -131,10 +130,10 @@ xfs_rmapbt_free_block(
 	if (error)
 		return error;
 
-	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
-			      XFS_EXTENT_BUSY_SKIP_DISCARD);
-
 	pag = cur->bc_ag.agbp->b_pag;
+	xfs_extent_busy_insert(cur->bc_tp, pag, bno, 1,
+			      XFS_EXTENT_BUSY_SKIP_DISCARD);
+
 	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
 	return 0;
 }

