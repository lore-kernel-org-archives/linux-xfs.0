Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221CAEB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 01:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjFPBhp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 21:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFPBho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 21:37:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6982948
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8EF661B32
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 01:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C177C433C0;
        Fri, 16 Jun 2023 01:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686879462;
        bh=0KX008XuG0soOyIRD7RT3NItVI+xxyzZGlwZm9QAl94=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YFmK73gPxBAsX9Zw6jq+7FP0S0wpg6tu+QuHZP1kRnrkupdilvI3Uc/E8Ss838ALV
         IfKJ7IU4MIDsvEG1p+802D+PX9gZGfg/IErlOK64a8oBQDLLo5q9Sov3xFXYvkpXpr
         8+hqs+6zaXvQ+8sjyXx1ig3F/R56e12jAmg2TYc8n2nIvZIctitqENEErW/KcUCTEy
         JCSHBwoAO13/a0vmhV8o5X1+s/K4F5R2IeoWc2JcEXc7TpUvjaUMm17aQuhak6vlGv
         YGndVHCQd9f/8rl9vQvlCiQMseCMmnvT8LGc3ySPbxG3gRHS8Ol5BgkdwZ593lPwZn
         z7wfKeOMKV/Ug==
Subject: [PATCH 8/8] xfs: validate block number being freed before adding to
 xefi
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 15 Jun 2023 18:37:41 -0700
Message-ID: <168687946148.831530.5118642712658328389.stgit@frogsfrogsfrogs>
In-Reply-To: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
References: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 7dfee17b13e5024c5c0ab1911859ded4182de3e5

Bad things happen in defered extent freeing operations if it is
passed a bad block number in the xefi. This can come from a bogus
agno/agbno pair from deferred agfl freeing, or just a bad fsbno
being passed to __xfs_free_extent_later(). Either way, it's very
difficult to diagnose where a null perag oops in EFI creation
is coming from when the operation that queued the xefi has already
been completed and there's no longer any trace of it around....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_ag.c         |    5 ++++-
 libxfs/xfs_alloc.c      |   16 +++++++++++++---
 libxfs/xfs_alloc.h      |    6 +++---
 libxfs/xfs_bmap.c       |   10 ++++++++--
 libxfs/xfs_bmap_btree.c |    7 +++++--
 libxfs/xfs_ialloc.c     |   24 ++++++++++++++++--------
 libxfs/xfs_refcount.c   |   13 ++++++++++---
 7 files changed, 59 insertions(+), 22 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 5d269312..c82afbb8 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -982,7 +982,10 @@ xfs_ag_shrink_space(
 		if (err2 != -ENOSPC)
 			goto resv_err;
 
-		__xfs_free_extent_later(*tpp, args.fsbno, delta, NULL, true);
+		err2 = __xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
+				true);
+		if (err2)
+			goto resv_err;
 
 		/*
 		 * Roll the transaction before trying to re-init the per-ag
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 40a36efa..107a8492 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2427,7 +2427,7 @@ xfs_agfl_reset(
  * the real allocation can proceed. Deferring the free disconnects freeing up
  * the AGFL slot from freeing the block.
  */
-STATIC void
+static int
 xfs_defer_agfl_block(
 	struct xfs_trans		*tp,
 	xfs_agnumber_t			agno,
@@ -2446,17 +2446,21 @@ xfs_defer_agfl_block(
 	xefi->xefi_blockcount = 1;
 	xefi->xefi_owner = oinfo->oi_owner;
 
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, xefi->xefi_startblock)))
+		return -EFSCORRUPTED;
+
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
 	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &xefi->xefi_list);
+	return 0;
 }
 
 /*
  * Add the extent to the list of extents to be free at transaction end.
  * The list is maintained sorted (by block number).
  */
-void
+int
 __xfs_free_extent_later(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
@@ -2483,6 +2487,9 @@ __xfs_free_extent_later(
 #endif
 	ASSERT(xfs_extfree_item_cache != NULL);
 
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
+		return -EFSCORRUPTED;
+
 	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
 	xefi->xefi_startblock = bno;
@@ -2506,6 +2513,7 @@ __xfs_free_extent_later(
 
 	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
+	return 0;
 }
 
 #ifdef DEBUG
@@ -2666,7 +2674,9 @@ xfs_alloc_fix_freelist(
 			goto out_agbp_relse;
 
 		/* defer agfl frees */
-		xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
+		error = xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
+		if (error)
+			goto out_agbp_relse;
 	}
 
 	targs.tp = tp;
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 5dbb2554..85ac470b 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -230,7 +230,7 @@ xfs_buf_to_agfl_bno(
 	return bp->b_addr;
 }
 
-void __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
+int __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
 		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
 		bool skip_discard);
 
@@ -254,14 +254,14 @@ void xfs_extent_free_get_group(struct xfs_mount *mp,
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
 
-static inline void
+static inline int
 xfs_free_extent_later(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo)
 {
-	__xfs_free_extent_later(tp, bno, len, oinfo, false);
+	return __xfs_free_extent_later(tp, bno, len, oinfo, false);
 }
 
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 18e0006f..5deeb472 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -565,8 +565,12 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
+
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
-	xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
+	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
+	if (error)
+		return error;
+
 	ip->i_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -5223,10 +5227,12 @@ xfs_bmap_del_extent_real(
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else {
-			__xfs_free_extent_later(tp, del->br_startblock,
+			error = __xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
 					(bflags & XFS_BMAPI_NODISCARD) ||
 					del->br_state == XFS_EXT_UNWRITTEN);
+			if (error)
+				goto done;
 		}
 	}
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index c87cb0f6..751e8165 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -266,11 +266,14 @@ xfs_bmbt_free_block(
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	struct xfs_owner_info	oinfo;
+	int			error;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
-	xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
+	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
+	if (error)
+		return error;
+
 	ip->i_nblocks--;
-
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	return 0;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index ee292356..42d8863e 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1829,7 +1829,7 @@ xfs_dialloc(
  * might be sparse and only free the regions that are allocated as part of the
  * chunk.
  */
-STATIC void
+static int
 xfs_difree_inode_chunk(
 	struct xfs_trans		*tp,
 	xfs_agnumber_t			agno,
@@ -1846,10 +1846,10 @@ xfs_difree_inode_chunk(
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
-		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
-				  M_IGEO(mp)->ialloc_blks,
-				  &XFS_RMAP_OINFO_INODES);
-		return;
+		return xfs_free_extent_later(tp,
+				XFS_AGB_TO_FSB(mp, agno, sagbno),
+				M_IGEO(mp)->ialloc_blks,
+				&XFS_RMAP_OINFO_INODES);
 	}
 
 	/* holemask is only 16-bits (fits in an unsigned long) */
@@ -1866,6 +1866,8 @@ xfs_difree_inode_chunk(
 						XFS_INOBT_HOLEMASK_BITS);
 	nextbit = startidx + 1;
 	while (startidx < XFS_INOBT_HOLEMASK_BITS) {
+		int error;
+
 		nextbit = find_next_zero_bit(holemask, XFS_INOBT_HOLEMASK_BITS,
 					     nextbit);
 		/*
@@ -1891,8 +1893,11 @@ xfs_difree_inode_chunk(
 
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
-		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
-				  contigblk, &XFS_RMAP_OINFO_INODES);
+		error = xfs_free_extent_later(tp,
+				XFS_AGB_TO_FSB(mp, agno, agbno),
+				contigblk, &XFS_RMAP_OINFO_INODES);
+		if (error)
+			return error;
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;
@@ -1900,6 +1905,7 @@ xfs_difree_inode_chunk(
 next:
 		nextbit++;
 	}
+	return 0;
 }
 
 STATIC int
@@ -1998,7 +2004,9 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		xfs_difree_inode_chunk(tp, pag->pag_agno, &rec);
+		error = xfs_difree_inode_chunk(tp, pag->pag_agno, &rec);
+		if (error)
+			goto error0;
 	} else {
 		xic->deleted = false;
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index a406d6b2..0006ad7c 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1150,8 +1150,10 @@ xfs_refcount_adjust_extents(
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 						cur->bc_ag.pag->pag_agno,
 						tmp.rc_startblock);
-				xfs_free_extent_later(cur->bc_tp, fsbno,
+				error = xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, NULL);
+				if (error)
+					goto out_error;
 			}
 
 			(*agbno) += tmp.rc_blockcount;
@@ -1209,8 +1211,10 @@ xfs_refcount_adjust_extents(
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 					cur->bc_ag.pag->pag_agno,
 					ext.rc_startblock);
-			xfs_free_extent_later(cur->bc_tp, fsbno,
+			error = xfs_free_extent_later(cur->bc_tp, fsbno,
 					ext.rc_blockcount, NULL);
+			if (error)
+				goto out_error;
 		}
 
 skip:
@@ -1975,7 +1979,10 @@ xfs_refcount_recover_cow_leftovers(
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
-		xfs_free_extent_later(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
+		error = xfs_free_extent_later(tp, fsb,
+				rr->rr_rrec.rc_blockcount, NULL);
+		if (error)
+			goto out_trans;
 
 		error = xfs_trans_commit(tp);
 		if (error)

