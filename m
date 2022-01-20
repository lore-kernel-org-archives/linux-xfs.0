Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DCC2C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiATAUR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:20:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46446 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357759AbiATAUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:20:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A9A1B81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D5AC004E1;
        Thu, 20 Jan 2022 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638014;
        bh=Bb4Ci6rYS6K5RCybYkbFJLY45kOjjZrRoSWonyd04EA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JS6ca4FcZbjJ0P3SNKeSI+utmo32HUQXWmBOCuC7a4ox7CJt0PWPEXCnmrhpltW8x
         KJ38tg5985upGA63udZsU/yiyH4To6lXO46csLh2T6jdj05Cftu6yh6hCg4nacQn0q
         r52TazfDt2ttzvzIRFTR/PDPccdrfFIxfRFGftCK9UXoDcpI7GZjP8j+Qc5UyPft2V
         zdt3AnkQjY107ZwohdGmqbqKQXrgQlHsBnJRWRoI0Z7O+5JskHJRlQfnJKeeLwGSUb
         dJkbl7uWn71scgzUOwVRcVs/l1B29MhUtA5ZWvxQtFUTu1VdsX58qeQCLHwEjgHwa2
         irWATQXA1qWzw==
Subject: [PATCH 31/45] xfs: convert xfs_sb_version_has checks to use mount
 features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:20:13 -0800
Message-ID: <164263801361.860211.13342461251909044818.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: ebd9027d088b3a4e49d294f79e6cadb7b7a88b28

This is a conversion of the remaining xfs_sb_version_has..(sbp)
checks to use xfs_has_..(mp) feature checks.

This was largely done with a vim replacement macro that did:

:0,$s/xfs_sb_version_has\(.*\)&\(.*\)->m_sb/xfs_has_\1\2/g<CR>

A couple of other variants were also used, and the rest touched up
by hand.

$ size -t fs/xfs/built-in.a
text    data     bss     dec     hex filename
before  1127533  311352     484 1439369  15f689 (TOTALS)
after   1125360  311352     484 1437196  15ee0c (TOTALS)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.c           |    4 ++--
 libxfs/xfs_alloc.c        |   12 ++++++------
 libxfs/xfs_alloc.h        |    2 +-
 libxfs/xfs_alloc_btree.c  |    2 +-
 libxfs/xfs_bmap_btree.c   |    2 +-
 libxfs/xfs_btree.c        |    6 +++---
 libxfs/xfs_da_btree.c     |    6 +++---
 libxfs/xfs_dir2.c         |    6 +++---
 libxfs/xfs_dir2_block.c   |    4 ++--
 libxfs/xfs_dir2_data.c    |   10 +++++-----
 libxfs/xfs_dir2_leaf.c    |    4 ++--
 libxfs/xfs_dir2_node.c    |    4 ++--
 libxfs/xfs_dir2_priv.h    |    2 +-
 libxfs/xfs_dir2_sf.c      |   10 +++++-----
 libxfs/xfs_dquot_buf.c    |    2 +-
 libxfs/xfs_ialloc.c       |   30 +++++++++++++++---------------
 libxfs/xfs_ialloc_btree.c |   10 +++++-----
 libxfs/xfs_inode_buf.c    |   10 +++++-----
 libxfs/xfs_log_format.h   |    2 +-
 libxfs/xfs_refcount.c     |    8 ++++----
 libxfs/xfs_sb.c           |    2 +-
 libxfs/xfs_trans_inode.c  |    2 +-
 libxfs/xfs_trans_resv.c   |    6 +++---
 libxfs/xfs_trans_space.h  |    6 ++----
 24 files changed, 75 insertions(+), 77 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 4fc54605..6691ca70 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -607,9 +607,9 @@ xfs_agiblock_init(
 	}
 	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
 		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
-	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+	if (xfs_has_inobtcounts(mp)) {
 		agi->agi_iblocks = cpu_to_be32(1);
-		if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		if (xfs_has_finobt(mp))
 			agi->agi_fblocks = cpu_to_be32(1);
 	}
 }
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index c6159743..c60aeb63 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2260,7 +2260,7 @@ xfs_alloc_min_freelist(
 	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed reverse mapping used space btree */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
 						mp->m_rmap_maxlevels);
 
@@ -2908,7 +2908,7 @@ xfs_agf_verify(
 	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > mp->m_rmap_maxlevels))
 		return __this_address;
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	if (xfs_has_rmapbt(mp) &&
 	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length))
 		return __this_address;
 
@@ -2921,16 +2921,16 @@ xfs_agf_verify(
 	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
 		return __this_address;
 
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
+	if (xfs_has_lazysbcount(mp) &&
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return __this_address;
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	if (xfs_has_reflink(mp) &&
 	    be32_to_cpu(agf->agf_refcount_blocks) >
 	    be32_to_cpu(agf->agf_length))
 		return __this_address;
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	if (xfs_has_reflink(mp) &&
 	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
 	     be32_to_cpu(agf->agf_refcount_level) > mp->m_refc_maxlevels))
 		return __this_address;
@@ -3069,7 +3069,7 @@ xfs_alloc_read_agf(
 		 * counter only tracks non-root blocks.
 		 */
 		allocbt_blks = pag->pagf_btreeblks;
-		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		if (xfs_has_rmapbt(mp))
 			allocbt_blks -= be32_to_cpu(agf->agf_rmap_blocks) - 1;
 		if (allocbt_blks > 0)
 			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index e14c5693..df4aefaf 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -243,7 +243,7 @@ static inline __be32 *
 xfs_buf_to_agfl_bno(
 	struct xfs_buf		*bp)
 {
-	if (xfs_sb_version_hascrc(&bp->b_mount->m_sb))
+	if (xfs_has_crc(bp->b_mount))
 		return bp->b_addr + sizeof(struct xfs_agfl);
 	return bp->b_addr;
 }
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index a8a24fa4..94f2d7b6 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -293,7 +293,7 @@ xfs_allocbt_verify(
 	if (!xfs_verify_magic(bp, block->bb_magic))
 		return __this_address;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		fa = xfs_btree_sblock_v5hdr_verify(bp);
 		if (fa)
 			return fa;
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index f5f228bc..237af83e 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -426,7 +426,7 @@ xfs_bmbt_verify(
 	if (!xfs_verify_magic(bp, block->bb_magic))
 		return __this_address;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		/*
 		 * XXX: need a better way of verifying the owner here. Right now
 		 * just make sure there has been one set.
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index cfa36d5d..8b2459e3 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -270,7 +270,7 @@ xfs_btree_lblock_calc_crc(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	if (!xfs_sb_version_hascrc(&bp->b_mount->m_sb))
+	if (!xfs_has_crc(bp->b_mount))
 		return;
 	if (bip)
 		block->bb_u.l.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
@@ -308,7 +308,7 @@ xfs_btree_sblock_calc_crc(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	if (!xfs_sb_version_hascrc(&bp->b_mount->m_sb))
+	if (!xfs_has_crc(bp->b_mount))
 		return;
 	if (bip)
 		block->bb_u.s.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
@@ -1746,7 +1746,7 @@ xfs_btree_lookup_get_block(
 		return error;
 
 	/* Check the inode owner since the verifiers don't. */
-	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
+	if (xfs_has_crc(cur->bc_mp) &&
 	    !(cur->bc_ino.flags & XFS_BTCUR_BMBT_INVALID_OWNER) &&
 	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
 	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 196f0a9e..d2dec4aa 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -126,7 +126,7 @@ xfs_da3_node_hdr_from_disk(
 	struct xfs_da3_icnode_hdr	*to,
 	struct xfs_da_intnode		*from)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_intnode	*from3 = (struct xfs_da3_intnode *)from;
 
 		to->forw = be32_to_cpu(from3->hdr.info.hdr.forw);
@@ -153,7 +153,7 @@ xfs_da3_node_hdr_to_disk(
 	struct xfs_da_intnode		*to,
 	struct xfs_da3_icnode_hdr	*from)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_da3_intnode	*to3 = (struct xfs_da3_intnode *)to;
 
 		ASSERT(from->magic == XFS_DA3_NODE_MAGIC);
@@ -188,7 +188,7 @@ xfs_da3_blkinfo_verify(
 	if (!xfs_verify_magic16(bp, hdr->magic))
 		return __this_address;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index dff87439..f0721304 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -114,7 +114,7 @@ xfs_da_mount(
 	dageo->fsblog = mp->m_sb.sb_blocklog;
 	dageo->blksize = xfs_dir2_dirblock_bytes(&mp->m_sb);
 	dageo->fsbcount = 1 << mp->m_sb.sb_dirblklog;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		dageo->node_hdr_size = sizeof(struct xfs_da3_node_hdr);
 		dageo->leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr);
 		dageo->free_hdr_size = sizeof(struct xfs_dir3_free_hdr);
@@ -729,7 +729,7 @@ xfs_dir2_hashname(
 	struct xfs_mount	*mp,
 	struct xfs_name		*name)
 {
-	if (unlikely(xfs_sb_version_hasasciici(&mp->m_sb)))
+	if (unlikely(xfs_has_asciici(mp)))
 		return xfs_ascii_ci_hashname(name);
 	return xfs_da_hashname(name->name, name->len);
 }
@@ -740,7 +740,7 @@ xfs_dir2_compname(
 	const unsigned char	*name,
 	int			len)
 {
-	if (unlikely(xfs_sb_version_hasasciici(&args->dp->i_mount->m_sb)))
+	if (unlikely(xfs_has_asciici(args->dp->i_mount)))
 		return xfs_ascii_ci_compname(args, name, len);
 	return xfs_da_compname(args, name, len);
 }
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 4373e819..f5d0f703 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -50,7 +50,7 @@ xfs_dir3_block_verify(
 	if (!xfs_verify_magic(bp, hdr3->magic))
 		return __this_address;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
@@ -118,7 +118,7 @@ xfs_dir3_block_header_check(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 		if (be64_to_cpu(hdr3->owner) != dp->i_ino)
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 76f55736..85cb14d3 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -26,7 +26,7 @@ xfs_dir2_data_bestfree_p(
 	struct xfs_mount		*mp,
 	struct xfs_dir2_data_hdr	*hdr)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_has_crc(mp))
 		return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
 	return hdr->bestfree;
 }
@@ -48,7 +48,7 @@ xfs_dir2_data_get_ftype(
 	struct xfs_mount		*mp,
 	struct xfs_dir2_data_entry	*dep)
 {
-	if (xfs_sb_version_hasftype(&mp->m_sb)) {
+	if (xfs_has_ftype(mp)) {
 		uint8_t			ftype = dep->name[dep->namelen];
 
 		if (likely(ftype < XFS_DIR3_FT_MAX))
@@ -67,7 +67,7 @@ xfs_dir2_data_put_ftype(
 	ASSERT(ftype < XFS_DIR3_FT_MAX);
 	ASSERT(dep->namelen != 0);
 
-	if (xfs_sb_version_hasftype(&mp->m_sb))
+	if (xfs_has_ftype(mp))
 		dep->name[dep->namelen] = ftype;
 }
 
@@ -294,7 +294,7 @@ xfs_dir3_data_verify(
 	if (!xfs_verify_magic(bp, hdr3->magic))
 		return __this_address;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
@@ -398,7 +398,7 @@ xfs_dir3_data_header_check(
 {
 	struct xfs_mount	*mp = dp->i_mount;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
 
 		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index cd63b37e..70b1f083 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -35,7 +35,7 @@ xfs_dir2_leaf_hdr_from_disk(
 	struct xfs_dir3_icleaf_hdr	*to,
 	struct xfs_dir2_leaf		*from)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_leaf *from3 = (struct xfs_dir3_leaf *)from;
 
 		to->forw = be32_to_cpu(from3->hdr.info.hdr.forw);
@@ -66,7 +66,7 @@ xfs_dir2_leaf_hdr_to_disk(
 	struct xfs_dir2_leaf		*to,
 	struct xfs_dir3_icleaf_hdr	*from)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_leaf *to3 = (struct xfs_dir3_leaf *)to;
 
 		ASSERT(from->magic == XFS_DIR3_LEAF1_MAGIC ||
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 2bccabaf..e7ed4b46 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -244,7 +244,7 @@ xfs_dir2_free_hdr_from_disk(
 	struct xfs_dir3_icfree_hdr	*to,
 	struct xfs_dir2_free		*from)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_free	*from3 = (struct xfs_dir3_free *)from;
 
 		to->magic = be32_to_cpu(from3->hdr.hdr.magic);
@@ -271,7 +271,7 @@ xfs_dir2_free_hdr_to_disk(
 	struct xfs_dir2_free		*to,
 	struct xfs_dir3_icfree_hdr	*from)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_free	*to3 = (struct xfs_dir3_free *)to;
 
 		ASSERT(from->magic == XFS_DIR3_FREE_MAGIC);
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 94943ce4..711709a2 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -196,7 +196,7 @@ xfs_dir2_data_entsize(
 
 	len = offsetof(struct xfs_dir2_data_entry, name[0]) + namelen +
 			sizeof(xfs_dir2_data_off_t) /* tag */;
-	if (xfs_sb_version_hasftype(&mp->m_sb))
+	if (xfs_has_ftype(mp))
 		len += sizeof(uint8_t);
 	return round_up(len, XFS_DIR2_DATA_ALIGN);
 }
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 6a57ad27..751b6347 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -48,7 +48,7 @@ xfs_dir2_sf_entsize(
 	count += sizeof(struct xfs_dir2_sf_entry);	/* namelen + offset */
 	count += hdr->i8count ? XFS_INO64_SIZE : XFS_INO32_SIZE; /* ino # */
 
-	if (xfs_sb_version_hasftype(&mp->m_sb))
+	if (xfs_has_ftype(mp))
 		count += sizeof(uint8_t);
 	return count;
 }
@@ -76,7 +76,7 @@ xfs_dir2_sf_get_ino(
 {
 	uint8_t				*from = sfep->name + sfep->namelen;
 
-	if (xfs_sb_version_hasftype(&mp->m_sb))
+	if (xfs_has_ftype(mp))
 		from++;
 
 	if (!hdr->i8count)
@@ -95,7 +95,7 @@ xfs_dir2_sf_put_ino(
 
 	ASSERT(ino <= XFS_MAXINUMBER);
 
-	if (xfs_sb_version_hasftype(&mp->m_sb))
+	if (xfs_has_ftype(mp))
 		to++;
 
 	if (hdr->i8count)
@@ -135,7 +135,7 @@ xfs_dir2_sf_get_ftype(
 	struct xfs_mount		*mp,
 	struct xfs_dir2_sf_entry	*sfep)
 {
-	if (xfs_sb_version_hasftype(&mp->m_sb)) {
+	if (xfs_has_ftype(mp)) {
 		uint8_t			ftype = sfep->name[sfep->namelen];
 
 		if (ftype < XFS_DIR3_FT_MAX)
@@ -153,7 +153,7 @@ xfs_dir2_sf_put_ftype(
 {
 	ASSERT(ftype < XFS_DIR3_FT_MAX);
 
-	if (xfs_sb_version_hasftype(&mp->m_sb))
+	if (xfs_has_ftype(mp))
 		sfep->name[sfep->namelen] = ftype;
 }
 
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index b77f303c..ecb4a002 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -68,7 +68,7 @@ xfs_dquot_verify(
 		return __this_address;
 
 	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) &&
-	    !xfs_sb_version_hasbigtime(&mp->m_sb))
+	    !xfs_has_bigtime(mp))
 		return __this_address;
 
 	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) && !ddq->d_id)
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 7ba6b5e9..cbccc072 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -297,7 +297,7 @@ xfs_ialloc_inode_init(
 	 * That means for v3 inode we log the entire buffer rather than just the
 	 * inode cores.
 	 */
-	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+	if (xfs_has_v3inodes(mp)) {
 		version = 3;
 		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
 
@@ -630,7 +630,7 @@ xfs_ialloc_ag_alloc(
 
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
-	if (xfs_sb_version_hassparseinodes(&tp->t_mountp->m_sb) &&
+	if (xfs_has_sparseinodes(tp->t_mountp) &&
 	    igeo->ialloc_min_blks < igeo->ialloc_blks)
 		do_sparse = prandom_u32() & 1;
 #endif
@@ -749,7 +749,7 @@ xfs_ialloc_ag_alloc(
 	 * Finally, try a sparse allocation if the filesystem supports it and
 	 * the sparse allocation length is smaller than a full chunk.
 	 */
-	if (xfs_sb_version_hassparseinodes(&args.mp->m_sb) &&
+	if (xfs_has_sparseinodes(args.mp) &&
 	    igeo->ialloc_min_blks < igeo->ialloc_blks &&
 	    args.fsbno == NULLFSBLOCK) {
 sparse_alloc:
@@ -851,7 +851,7 @@ xfs_ialloc_ag_alloc(
 		 * from the previous call. Set merge false to replace any
 		 * existing record with this one.
 		 */
-		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
+		if (xfs_has_finobt(args.mp)) {
 			error = xfs_inobt_insert_sprec(args.mp, tp, agbp, pag,
 				       XFS_BTNUM_FINO, &rec, false);
 			if (error)
@@ -864,7 +864,7 @@ xfs_ialloc_ag_alloc(
 		if (error)
 			return error;
 
-		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
+		if (xfs_has_finobt(args.mp)) {
 			error = xfs_inobt_insert(args.mp, tp, agbp, pag, newino,
 						 newlen, XFS_BTNUM_FINO);
 			if (error)
@@ -1443,7 +1443,7 @@ xfs_dialloc_ag(
 	int				offset;
 	int				i;
 
-	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (!xfs_has_finobt(mp))
 		return xfs_dialloc_ag_inobt(tp, agbp, pag, parent, inop);
 
 	/*
@@ -2182,7 +2182,7 @@ xfs_difree(
 	/*
 	 * Fix up the free inode btree.
 	 */
-	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+	if (xfs_has_finobt(mp)) {
 		error = xfs_difree_finobt(mp, tp, agbp, pag, agino, &rec);
 		if (error)
 			goto error0;
@@ -2766,7 +2766,7 @@ xfs_ialloc_setup_geometry(
 	uint			inodes;
 
 	igeo->new_diflags2 = 0;
-	if (xfs_sb_version_hasbigtime(&mp->m_sb))
+	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
 
 	/* Compute inode btree geometry. */
@@ -2821,7 +2821,7 @@ xfs_ialloc_setup_geometry(
 	 * cannot change the behavior.
 	 */
 	igeo->inode_cluster_size_raw = XFS_INODE_BIG_CLUSTER_SIZE;
-	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
+	if (xfs_has_v3inodes(mp)) {
 		int	new_size = igeo->inode_cluster_size_raw;
 
 		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
@@ -2839,7 +2839,7 @@ xfs_ialloc_setup_geometry(
 	igeo->inodes_per_cluster = XFS_FSB_TO_INO(mp, igeo->blocks_per_cluster);
 
 	/* Calculate inode cluster alignment. */
-	if (xfs_sb_version_hasalign(&mp->m_sb) &&
+	if (xfs_has_align(mp) &&
 	    mp->m_sb.sb_inoalignmt >= igeo->blocks_per_cluster)
 		igeo->cluster_align = mp->m_sb.sb_inoalignmt;
 	else
@@ -2887,15 +2887,15 @@ xfs_ialloc_calc_rootino(
 	first_bno += xfs_alloc_min_freelist(mp, NULL);
 
 	/* ...the free inode btree root... */
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+	if (xfs_has_finobt(mp))
 		first_bno++;
 
 	/* ...the reverse mapping btree root... */
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+	if (xfs_has_rmapbt(mp))
 		first_bno++;
 
 	/* ...the reference count btree... */
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_has_reflink(mp))
 		first_bno++;
 
 	/*
@@ -2913,9 +2913,9 @@ xfs_ialloc_calc_rootino(
 	 * Now round first_bno up to whatever allocation alignment is given
 	 * by the filesystem or was passed in.
 	 */
-	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0)
+	if (xfs_has_dalign(mp) && igeo->ialloc_align > 0)
 		first_bno = roundup(first_bno, sunit);
-	else if (xfs_sb_version_hasalign(&mp->m_sb) &&
+	else if (xfs_has_align(mp) &&
 			mp->m_sb.sb_inoalignmt > 1)
 		first_bno = roundup(first_bno, mp->m_sb.sb_inoalignmt);
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 5fb96203..14b5918b 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -75,7 +75,7 @@ xfs_inobt_mod_blockcount(
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agi		*agi = agbp->b_addr;
 
-	if (!xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb))
+	if (!xfs_has_inobtcounts(cur->bc_mp))
 		return;
 
 	if (cur->bc_btnum == XFS_BTNUM_FINO)
@@ -291,7 +291,7 @@ xfs_inobt_verify(
 	 * but beware of the landmine (i.e. need to check pag->pagi_init) if we
 	 * ever do.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_has_crc(mp)) {
 		fa = xfs_btree_sblock_v5hdr_verify(bp);
 		if (fa)
 			return fa;
@@ -510,7 +510,7 @@ xfs_inobt_commit_staged_btree(
 		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
 		agi->agi_root = cpu_to_be32(afake->af_root);
 		agi->agi_level = cpu_to_be32(afake->af_levels);
-		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
+		if (xfs_has_inobtcounts(cur->bc_mp)) {
 			agi->agi_iblocks = cpu_to_be32(afake->af_blocks);
 			fields |= XFS_AGI_IBLOCKS;
 		}
@@ -520,7 +520,7 @@ xfs_inobt_commit_staged_btree(
 		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
 		agi->agi_free_root = cpu_to_be32(afake->af_root);
 		agi->agi_free_level = cpu_to_be32(afake->af_levels);
-		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
+		if (xfs_has_inobtcounts(cur->bc_mp)) {
 			agi->agi_fblocks = cpu_to_be32(afake->af_blocks);
 			fields |= XFS_AGI_IBLOCKS;
 		}
@@ -739,7 +739,7 @@ xfs_finobt_calc_reserves(
 	if (!xfs_has_finobt(mp))
 		return 0;
 
-	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
+	if (xfs_has_inobtcounts(mp))
 		error = xfs_finobt_read_blocks(mp, tp, pag, &tree_len);
 	else
 		error = xfs_inobt_count_blocks(mp, tp, pag, XFS_BTNUM_FINO,
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 946261cd..2638e515 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -189,7 +189,7 @@ xfs_inode_from_disk(
 	 * inode. If the inode is unused, mode is zero and we shouldn't mess
 	 * with the uninitialized part of it.
 	 */
-	if (!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb))
+	if (!xfs_has_v3inodes(ip->i_mount))
 		ip->i_flushiter = be16_to_cpu(from->di_flushiter);
 	inode->i_generation = be32_to_cpu(from->di_gen);
 	inode->i_mode = be16_to_cpu(from->di_mode);
@@ -232,7 +232,7 @@ xfs_inode_from_disk(
 	if (from->di_dmevmask || from->di_dmstate)
 		xfs_iflags_set(ip, XFS_IPRESERVE_DM_FIELDS);
 
-	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+	if (xfs_has_v3inodes(ip->i_mount)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
 		ip->i_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
@@ -310,7 +310,7 @@ xfs_inode_to_disk(
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
 
-	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+	if (xfs_has_v3inodes(ip->i_mount)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
 		to->di_crtime = xfs_inode_to_disk_ts(ip, ip->i_crtime);
@@ -410,7 +410,7 @@ xfs_dinode_verify(
 
 	/* Verify v3 integrity information first */
 	if (dip->di_version >= 3) {
-		if (!xfs_sb_version_has_v3inode(&mp->m_sb))
+		if (!xfs_has_v3inodes(mp))
 			return __this_address;
 		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 				      XFS_DINODE_CRC_OFF))
@@ -531,7 +531,7 @@ xfs_dinode_verify(
 
 	/* bigtime iflag can only happen on bigtime filesystems */
 	if (xfs_dinode_has_bigtime(dip) &&
-	    !xfs_sb_version_hasbigtime(&mp->m_sb))
+	    !xfs_has_bigtime(mp))
 		return __this_address;
 
 	return NULL;
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 28c02047..b322db52 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -434,7 +434,7 @@ struct xfs_log_dinode {
 };
 
 #define xfs_log_dinode_size(mp)						\
-	(xfs_sb_version_has_v3inode(&(mp)->m_sb) ?			\
+	(xfs_has_v3inodes((mp)) ?					\
 		sizeof(struct xfs_log_dinode) :				\
 		offsetof(struct xfs_log_dinode, di_next_unlinked))
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 1c9e7722..2aa64d3e 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1252,7 +1252,7 @@ xfs_refcount_increase_extent(
 	struct xfs_trans		*tp,
 	struct xfs_bmbt_irec		*PREV)
 {
-	if (!xfs_sb_version_hasreflink(&tp->t_mountp->m_sb))
+	if (!xfs_has_reflink(tp->t_mountp))
 		return;
 
 	__xfs_refcount_add(tp, XFS_REFCOUNT_INCREASE, PREV->br_startblock,
@@ -1267,7 +1267,7 @@ xfs_refcount_decrease_extent(
 	struct xfs_trans		*tp,
 	struct xfs_bmbt_irec		*PREV)
 {
-	if (!xfs_sb_version_hasreflink(&tp->t_mountp->m_sb))
+	if (!xfs_has_reflink(tp->t_mountp))
 		return;
 
 	__xfs_refcount_add(tp, XFS_REFCOUNT_DECREASE, PREV->br_startblock,
@@ -1616,7 +1616,7 @@ xfs_refcount_alloc_cow_extent(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return;
 
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
@@ -1635,7 +1635,7 @@ xfs_refcount_free_cow_extent(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_has_reflink(mp))
 		return;
 
 	/* Remove rmap entry */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index a2ad1516..18be9164 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -909,7 +909,7 @@ xfs_log_sb(
 	 * unclean shutdown, this will be corrected by log recovery rebuilding
 	 * the counters from the AGF block counts.
 	 */
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
 		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 06d11a5c..276d57cf 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -133,7 +133,7 @@ xfs_trans_log_inode(
 	 * to upgrade this inode to bigtime format, do so now.
 	 */
 	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
-	    xfs_sb_version_hasbigtime(&ip->i_mount->m_sb) &&
+	    xfs_has_bigtime(ip->i_mount) &&
 	    !xfs_inode_has_bigtime(ip)) {
 		ip->i_diflags2 |= XFS_DIFLAG2_BIGTIME;
 		flags |= XFS_ILOG_CORE;
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index ea57e810..d383528d 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -186,7 +186,7 @@ xfs_calc_inode_chunk_res(
 			       XFS_FSB_TO_B(mp, 1));
 	if (alloc) {
 		/* icreate tx uses ordered buffers */
-		if (xfs_sb_version_has_v3inode(&mp->m_sb))
+		if (xfs_has_v3inodes(mp))
 			return res;
 		size = XFS_FSB_TO_B(mp, 1);
 	}
@@ -267,7 +267,7 @@ xfs_calc_write_reservation(
 	     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
 	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
 
-	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
+	if (xfs_has_realtime(mp)) {
 		t2 = xfs_calc_inode_res(mp, 1) +
 		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
 				     blksz) +
@@ -316,7 +316,7 @@ xfs_calc_itruncate_reservation(
 	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
 	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
 
-	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
+	if (xfs_has_realtime(mp)) {
 		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
 		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
 		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 7ad3659c..50332be3 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -57,8 +57,7 @@
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
 	(M_IGEO(mp)->ialloc_blks + \
-	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
-	  M_IGEO(mp)->inobt_maxlevels))
+	 ((xfs_has_finobt(mp) ? 2 : 1) * M_IGEO(mp)->inobt_maxlevels))
 
 /*
  * Space reservation values for various transactions.
@@ -94,8 +93,7 @@
 #define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
-	(xfs_sb_version_hasfinobt(&mp->m_sb) ? \
-			M_IGEO(mp)->inobt_maxlevels : 0)
+	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
 
 #endif	/* __XFS_TRANS_SPACE_H__ */

