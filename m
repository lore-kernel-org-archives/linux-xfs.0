Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F97C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236050AbiLaBfF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbiLaBfE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:35:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B974DEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:35:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48CC7B81E0C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09601C433D2;
        Sat, 31 Dec 2022 01:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450500;
        bh=8LrT17KqNaBckobM4YNyYY36b4UqwH/rajYGXYWQxok=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ouguCV3WaEWCJXtmB8XcpLYz5dcCRz16KiXE5s1+7raLpesf4Rgqv3SNQ9mBkrqhf
         Zk6ryrFfKQMBRF2mRD5RzUHrZPL/TBmnnLEUzVCgMvl8NKmkHcbw3b8p5CCt8E2Zxb
         bBhEHmUncMfMRhKndBnltJPnbmxMD4je1sPT6RZDiihVkslwa5PdyMvpqK55ZFZ8R5
         JLQ4Iyo3XZiFh5fWXAq+gWS00jdAPBBvpVuIe9wsRezLbp41TAqnDnam89FAjEm1PT
         Kn39KirIp9QSaArYiBJGnaRpLt0U+5viY3nNUAJf3vJ2lGe8NmLmTrk/EBP+HgFcUj
         kk6iRVTbKMIMA==
Subject: [PATCH 2/2] xfs: convert "skip_discard" to a proper flags bitset
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:05 -0800
Message-ID: <167243868548.714498.11115919528347820153.stgit@magnolia>
In-Reply-To: <167243868517.714498.12799285534857942283.stgit@magnolia>
References: <167243868517.714498.12799285534857942283.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the boolean to skip discard on free into a proper flags field so
that we can add more flags in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c         |    3 ++-
 fs/xfs/libxfs/xfs_alloc.c      |    7 ++++---
 fs/xfs/libxfs/xfs_alloc.h      |   19 +++++++------------
 fs/xfs/libxfs/xfs_bmap.c       |   14 +++++++++-----
 fs/xfs/libxfs/xfs_bmap_btree.c |    2 +-
 fs/xfs/libxfs/xfs_ialloc.c     |    6 +++---
 fs/xfs/libxfs/xfs_refcount.c   |    7 ++++---
 fs/xfs/scrub/newbt.c           |    4 ++--
 fs/xfs/scrub/reap.c            |   11 +++++++----
 fs/xfs/xfs_reflink.c           |    2 +-
 10 files changed, 40 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index bc1fc86df322..baf13b4fc0f2 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -921,7 +921,8 @@ xfs_ag_shrink_space(
 		if (err2 != -ENOSPC)
 			goto resv_err;
 
-		__xfs_free_extent_later(*tpp, args.fsbno, delta, NULL, true);
+		xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
+				XFS_FREE_EXTENT_SKIP_DISCARD);
 
 		/*
 		 * Roll the transaction before trying to re-init the per-ag
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b9aef7937a2c..d4943c197a76 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2598,12 +2598,12 @@ xfs_defer_agfl_block(
  * The list is maintained sorted (by block number).
  */
 void
-__xfs_free_extent_later(
+xfs_free_extent_later(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
-	bool				skip_discard)
+	unsigned int			flags)
 {
 	struct xfs_extent_free_item	*xefi;
 	struct xfs_mount		*mp = tp->t_mountp;
@@ -2622,13 +2622,14 @@ __xfs_free_extent_later(
 	ASSERT(len < mp->m_sb.sb_agblocks);
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
+	ASSERT(!(flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
 	ASSERT(xfs_extfree_item_cache != NULL);
 
 	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
 	xefi->xefi_startblock = bno;
 	xefi->xefi_blockcount = (xfs_extlen_t)len;
-	if (skip_discard)
+	if (flags & XFS_FREE_EXTENT_SKIP_DISCARD)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 83b92c3b3452..19c5f046c3c4 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -221,9 +221,14 @@ xfs_buf_to_agfl_bno(
 	return bp->b_addr;
 }
 
-void __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
+void xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
 		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
-		bool skip_discard);
+		unsigned int flags);
+
+/* Don't issue a discard for the blocks freed. */
+#define XFS_FREE_EXTENT_SKIP_DISCARD	(1U << 0)
+
+#define XFS_FREE_EXTENT_ALL_FLAGS	(XFS_FREE_EXTENT_SKIP_DISCARD)
 
 /*
  * List of extents to be free "later".
@@ -245,16 +250,6 @@ void xfs_extent_free_get_group(struct xfs_mount *mp,
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
 
-static inline void
-xfs_free_extent_later(
-	struct xfs_trans		*tp,
-	xfs_fsblock_t			bno,
-	xfs_filblks_t			len,
-	const struct xfs_owner_info	*oinfo)
-{
-	__xfs_free_extent_later(tp, bno, len, oinfo, false);
-}
-
 extern struct kmem_cache	*xfs_extfree_item_cache;
 
 int __init xfs_extfree_intent_init_cache(void);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index eda20bb5c4af..2e93b018d150 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -585,7 +585,7 @@ xfs_bmap_btree_to_extents(
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
-	xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
+	xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo, 0);
 	ip->i_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -5307,10 +5307,14 @@ xfs_bmap_del_extent_real(
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else {
-			__xfs_free_extent_later(tp, del->br_startblock,
-					del->br_blockcount, NULL,
-					(bflags & XFS_BMAPI_NODISCARD) ||
-					del->br_state == XFS_EXT_UNWRITTEN);
+			unsigned int	efi_flags = 0;
+
+			if ((bflags & XFS_BMAPI_NODISCARD) ||
+			    del->br_state == XFS_EXT_UNWRITTEN)
+				efi_flags |= XFS_FREE_EXTENT_SKIP_DISCARD;
+
+			xfs_free_extent_later(tp, del->br_startblock,
+					del->br_blockcount, NULL, efi_flags);
 		}
 	}
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 4c6a91acdad6..4f0bf593c2a5 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -287,7 +287,7 @@ xfs_bmbt_free_block(
 	struct xfs_owner_info	oinfo;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
-	xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
+	xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo, 0);
 	ip->i_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 331d22a60272..7bfda1c884aa 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1918,8 +1918,8 @@ xfs_difree_inode_chunk(
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
 		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
-				  M_IGEO(mp)->ialloc_blks,
-				  &XFS_RMAP_OINFO_INODES);
+				M_IGEO(mp)->ialloc_blks,
+				&XFS_RMAP_OINFO_INODES, 0);
 		return;
 	}
 
@@ -1963,7 +1963,7 @@ xfs_difree_inode_chunk(
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
-				  contigblk, &XFS_RMAP_OINFO_INODES);
+				  contigblk, &XFS_RMAP_OINFO_INODES, 0);
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index ba329fa53a56..2721c6076712 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1180,7 +1180,7 @@ xfs_refcount_adjust_extents(
 						cur->bc_ag.pag->pag_agno,
 						tmp.rc_startblock);
 				xfs_free_extent_later(cur->bc_tp, fsbno,
-						  tmp.rc_blockcount, NULL);
+						tmp.rc_blockcount, NULL, 0);
 			}
 
 			(*agbno) += tmp.rc_blockcount;
@@ -1241,7 +1241,7 @@ xfs_refcount_adjust_extents(
 					cur->bc_ag.pag->pag_agno,
 					ext.rc_startblock);
 			xfs_free_extent_later(cur->bc_tp, fsbno,
-					ext.rc_blockcount, NULL);
+					ext.rc_blockcount, NULL, 0);
 		}
 
 skip:
@@ -2021,7 +2021,8 @@ xfs_refcount_recover_cow_leftovers(
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
-		xfs_free_extent_later(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
+		xfs_free_extent_later(tp, fsb, rr->rr_rrec.rc_blockcount, NULL,
+				0);
 
 		error = xfs_trans_commit(tp);
 		if (error)
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 9c0ccba75656..6812ff67848d 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -416,8 +416,8 @@ xrep_newbt_free_extent(
 		 * if the system goes down.
 		 */
 		fsbno = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno, free_agbno);
-		__xfs_free_extent_later(sc->tp, fsbno, free_aglen, &xnr->oinfo,
-				true);
+		xfs_free_extent_later(sc->tp, fsbno, free_aglen, &xnr->oinfo,
+				XFS_FREE_EXTENT_SKIP_DISCARD);
 		return 1;
 	}
 
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index f43ad4dfc6f7..151afacab982 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -382,7 +382,8 @@ xreap_agextent(
 
 		rs->force_roll = true;
 		xfs_refcount_free_cow_extent(sc->tp, fsbno, *aglenp);
-		__xfs_free_extent_later(sc->tp, fsbno, *aglenp, NULL, true);
+		xfs_free_extent_later(sc->tp, fsbno, *aglenp, NULL,
+				XFS_FREE_EXTENT_SKIP_DISCARD);
 		return 0;
 	}
 
@@ -412,7 +413,8 @@ xreap_agextent(
 		 * to minimize the window in which we could crash and lose the
 		 * old blocks.
 		 */
-		__xfs_free_extent_later(sc->tp, fsbno, *aglenp, rs->oinfo, true);
+		xfs_free_extent_later(sc->tp, fsbno, *aglenp, rs->oinfo,
+				XFS_FREE_EXTENT_SKIP_DISCARD);
 		rs->deferred++;
 		break;
 	}
@@ -959,8 +961,9 @@ xreap_ifork_extent(
 		xfs_bmap_unmap_extent(sc->tp, ip, whichfork, imap);
 		xfs_trans_mod_dquot_byino(sc->tp, ip, XFS_TRANS_DQ_BCOUNT,
 				-(int64_t)imap->br_blockcount);
-		__xfs_free_extent_later(sc->tp, imap->br_startblock,
-				imap->br_blockcount, NULL, true);
+		xfs_free_extent_later(sc->tp, imap->br_startblock,
+				imap->br_blockcount, NULL,
+				XFS_FREE_EXTENT_SKIP_DISCARD);
 	}
 
 out_agf:
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0804f0ad6b1c..cf514af238ce 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -618,7 +618,7 @@ xfs_reflink_cancel_cow_blocks(
 					del.br_blockcount);
 
 			xfs_free_extent_later(*tpp, del.br_startblock,
-					  del.br_blockcount, NULL);
+					del.br_blockcount, NULL, 0);
 
 			/* Roll the transaction */
 			error = xfs_defer_finish(tpp);

