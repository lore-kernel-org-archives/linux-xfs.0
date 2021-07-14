Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E787C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C1A600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhGNXWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230525AbhGNXWp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52DF9613B9;
        Wed, 14 Jul 2021 23:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626304793;
        bh=L9nDs4xC595yHth9MYEBuqPSc0RFNo1hc1picFfy2Hg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GNDE+hzaqyp1QKboH538PXVO+WP1ykAd8gznw5ut9jQqifDOEFfWwpTwlLIKiUCTe
         jxbEBTgsFvr2LT7Mzs0GvIvbTGuZaFE9OJcUXi1TRxzZKEk0w/KrQw9RwsS1Jr+B2i
         1Pk5aPAg4QCgMrxKzr0eAJu1TVv2EKr7EXOkQ6G6r6OtBJxpHn5ipAF0vSjj9R6vy1
         phjUtmUTD6ZcAX4D/vOAU0gzy+JwRS9jt5wM0lmhc5DIzpSNLqLckP8uKVoru9moZL
         4cOQy8I/P2jkwvirIcF83KJgKy+Z9AaNkiJXbbO4GfYfvukMlrF815LQ5nQYV1R8Q/
         zMqJUjhK7nePA==
Date:   Wed, 14 Jul 2021 16:19:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/16] xfs: convert xfs_sb_version_has checks to use
 mount features
Message-ID: <20210714231952.GG22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-14-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-14-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This is a conversion of the remaining xfs_sb_version_has..(sbp)
> checks to use xfs_has_..(mp) feature checks.
> 
> This was largely done with a vim replacement macro that did:
> 
> :0,$s/xfs_sb_version_has\(.*\)&\(.*\)->m_sb/xfs_has_\1\2/g<CR>
> 
> A couple of other variants were also used, and the rest touched up
> by hand.
> 
> $ size -t fs/xfs/built-in.a
> 	   text    data     bss     dec     hex filename
> before	1127533  311352     484 1439369  15f689 (TOTALS)
> after	1125360  311352     484 1437196  15ee0c (TOTALS)
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good, tastes great!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c           |  4 ++--
>  fs/xfs/libxfs/xfs_alloc.c        | 12 ++++++------
>  fs/xfs/libxfs/xfs_alloc.h        |  2 +-
>  fs/xfs/libxfs/xfs_alloc_btree.c  |  2 +-
>  fs/xfs/libxfs/xfs_bmap_btree.c   |  2 +-
>  fs/xfs/libxfs/xfs_btree.c        |  6 +++---
>  fs/xfs/libxfs/xfs_da_btree.c     |  6 +++---
>  fs/xfs/libxfs/xfs_dir2.c         |  6 +++---
>  fs/xfs/libxfs/xfs_dir2_block.c   |  4 ++--
>  fs/xfs/libxfs/xfs_dir2_data.c    | 10 +++++-----
>  fs/xfs/libxfs/xfs_dir2_leaf.c    |  4 ++--
>  fs/xfs/libxfs/xfs_dir2_node.c    |  4 ++--
>  fs/xfs/libxfs/xfs_dir2_priv.h    |  2 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c      | 10 +++++-----
>  fs/xfs/libxfs/xfs_dquot_buf.c    |  2 +-
>  fs/xfs/libxfs/xfs_ialloc.c       | 30 +++++++++++++++---------------
>  fs/xfs/libxfs/xfs_ialloc_btree.c | 10 +++++-----
>  fs/xfs/libxfs/xfs_inode_buf.c    | 10 +++++-----
>  fs/xfs/libxfs/xfs_log_format.h   |  2 +-
>  fs/xfs/libxfs/xfs_refcount.c     |  8 ++++----
>  fs/xfs/libxfs/xfs_sb.c           |  2 +-
>  fs/xfs/libxfs/xfs_trans_inode.c  |  2 +-
>  fs/xfs/libxfs/xfs_trans_resv.c   |  6 +++---
>  fs/xfs/libxfs/xfs_trans_space.h  |  6 ++----
>  fs/xfs/scrub/agheader.c          |  6 +++---
>  fs/xfs/scrub/agheader_repair.c   |  5 ++---
>  fs/xfs/scrub/bmap.c              |  3 +--
>  fs/xfs/scrub/common.c            |  6 +++---
>  fs/xfs/scrub/fscounters.c        |  2 +-
>  fs/xfs/scrub/inode.c             |  3 +--
>  fs/xfs/scrub/quota.c             |  2 +-
>  fs/xfs/xfs_reflink.h             |  3 +--
>  fs/xfs/xfs_super.c               |  2 +-
>  33 files changed, 89 insertions(+), 95 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 1eb21912a80c..e3bc40182e16 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -607,9 +607,9 @@ xfs_agiblock_init(
>  	}
>  	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
>  		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
> -	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +	if (xfs_has_inobtcounts(mp)) {
>  		agi->agi_iblocks = cpu_to_be32(1);
> -		if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		if (xfs_has_finobt(mp))
>  			agi->agi_fblocks = cpu_to_be32(1);
>  	}
>  }
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index e40235bc487d..2dd01f034f36 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2264,7 +2264,7 @@ xfs_alloc_min_freelist(
>  	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
>  				       mp->m_ag_maxlevels);
>  	/* space needed reverse mapping used space btree */
> -	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +	if (xfs_has_rmapbt(mp))
>  		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
>  						mp->m_rmap_maxlevels);
>  
> @@ -2912,7 +2912,7 @@ xfs_agf_verify(
>  	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > mp->m_rmap_maxlevels))
>  		return __this_address;
>  
> -	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
> +	if (xfs_has_rmapbt(mp) &&
>  	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length))
>  		return __this_address;
>  
> @@ -2925,16 +2925,16 @@ xfs_agf_verify(
>  	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
>  		return __this_address;
>  
> -	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
> +	if (xfs_has_lazysbcount(mp) &&
>  	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
>  		return __this_address;
>  
> -	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
> +	if (xfs_has_reflink(mp) &&
>  	    be32_to_cpu(agf->agf_refcount_blocks) >
>  	    be32_to_cpu(agf->agf_length))
>  		return __this_address;
>  
> -	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
> +	if (xfs_has_reflink(mp) &&
>  	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
>  	     be32_to_cpu(agf->agf_refcount_level) > mp->m_refc_maxlevels))
>  		return __this_address;
> @@ -3073,7 +3073,7 @@ xfs_alloc_read_agf(
>  		 * counter only tracks non-root blocks.
>  		 */
>  		allocbt_blks = pag->pagf_btreeblks;
> -		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		if (xfs_has_rmapbt(mp))
>  			allocbt_blks -= be32_to_cpu(agf->agf_rmap_blocks) - 1;
>  		if (allocbt_blks > 0)
>  			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index e30900b6f8ba..eb9088aff4e7 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -243,7 +243,7 @@ static inline __be32 *
>  xfs_buf_to_agfl_bno(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_sb_version_hascrc(&bp->b_mount->m_sb))
> +	if (xfs_has_crc(bp->b_mount))
>  		return bp->b_addr + sizeof(struct xfs_agfl);
>  	return bp->b_addr;
>  }
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 6dce6a566926..81a8e1d0cd90 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -295,7 +295,7 @@ xfs_allocbt_verify(
>  	if (!xfs_verify_magic(bp, block->bb_magic))
>  		return __this_address;
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		fa = xfs_btree_sblock_v5hdr_verify(bp);
>  		if (fa)
>  			return fa;
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 4565e471c55e..c04b2a697b29 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -428,7 +428,7 @@ xfs_bmbt_verify(
>  	if (!xfs_verify_magic(bp, block->bb_magic))
>  		return __this_address;
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		/*
>  		 * XXX: need a better way of verifying the owner here. Right now
>  		 * just make sure there has been one set.
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 08b58135b424..393c9438d5a7 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -273,7 +273,7 @@ xfs_btree_lblock_calc_crc(
>  	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  
> -	if (!xfs_sb_version_hascrc(&bp->b_mount->m_sb))
> +	if (!xfs_has_crc(bp->b_mount))
>  		return;
>  	if (bip)
>  		block->bb_u.l.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
> @@ -311,7 +311,7 @@ xfs_btree_sblock_calc_crc(
>  	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  
> -	if (!xfs_sb_version_hascrc(&bp->b_mount->m_sb))
> +	if (!xfs_has_crc(bp->b_mount))
>  		return;
>  	if (bip)
>  		block->bb_u.s.bb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
> @@ -1749,7 +1749,7 @@ xfs_btree_lookup_get_block(
>  		return error;
>  
>  	/* Check the inode owner since the verifiers don't. */
> -	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
> +	if (xfs_has_crc(cur->bc_mp) &&
>  	    !(cur->bc_ino.flags & XFS_BTCUR_BMBT_INVALID_OWNER) &&
>  	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
>  	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 0a8cde1fbe0d..99f81f6bb306 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -129,7 +129,7 @@ xfs_da3_node_hdr_from_disk(
>  	struct xfs_da3_icnode_hdr	*to,
>  	struct xfs_da_intnode		*from)
>  {
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		struct xfs_da3_intnode	*from3 = (struct xfs_da3_intnode *)from;
>  
>  		to->forw = be32_to_cpu(from3->hdr.info.hdr.forw);
> @@ -156,7 +156,7 @@ xfs_da3_node_hdr_to_disk(
>  	struct xfs_da_intnode		*to,
>  	struct xfs_da3_icnode_hdr	*from)
>  {
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		struct xfs_da3_intnode	*to3 = (struct xfs_da3_intnode *)to;
>  
>  		ASSERT(from->magic == XFS_DA3_NODE_MAGIC);
> @@ -191,7 +191,7 @@ xfs_da3_blkinfo_verify(
>  	if (!xfs_verify_magic16(bp, hdr->magic))
>  		return __this_address;
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
>  			return __this_address;
>  		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 050bdcc4fe73..50546eadaae2 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -115,7 +115,7 @@ xfs_da_mount(
>  	dageo->fsblog = mp->m_sb.sb_blocklog;
>  	dageo->blksize = xfs_dir2_dirblock_bytes(&mp->m_sb);
>  	dageo->fsbcount = 1 << mp->m_sb.sb_dirblklog;
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		dageo->node_hdr_size = sizeof(struct xfs_da3_node_hdr);
>  		dageo->leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr);
>  		dageo->free_hdr_size = sizeof(struct xfs_dir3_free_hdr);
> @@ -730,7 +730,7 @@ xfs_dir2_hashname(
>  	struct xfs_mount	*mp,
>  	struct xfs_name		*name)
>  {
> -	if (unlikely(xfs_sb_version_hasasciici(&mp->m_sb)))
> +	if (unlikely(xfs_has_asciici(mp)))
>  		return xfs_ascii_ci_hashname(name);
>  	return xfs_da_hashname(name->name, name->len);
>  }
> @@ -741,7 +741,7 @@ xfs_dir2_compname(
>  	const unsigned char	*name,
>  	int			len)
>  {
> -	if (unlikely(xfs_sb_version_hasasciici(&args->dp->i_mount->m_sb)))
> +	if (unlikely(xfs_has_asciici(args->dp->i_mount)))
>  		return xfs_ascii_ci_compname(args, name, len);
>  	return xfs_da_compname(args, name, len);
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 49e61ca1045b..41e406067f91 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -53,7 +53,7 @@ xfs_dir3_block_verify(
>  	if (!xfs_verify_magic(bp, hdr3->magic))
>  		return __this_address;
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
>  			return __this_address;
>  		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
> @@ -121,7 +121,7 @@ xfs_dir3_block_header_check(
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
>  
>  		if (be64_to_cpu(hdr3->owner) != dp->i_ino)
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 920bd13512a8..c90180f2ba5c 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -29,7 +29,7 @@ xfs_dir2_data_bestfree_p(
>  	struct xfs_mount		*mp,
>  	struct xfs_dir2_data_hdr	*hdr)
>  {
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> +	if (xfs_has_crc(mp))
>  		return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
>  	return hdr->bestfree;
>  }
> @@ -51,7 +51,7 @@ xfs_dir2_data_get_ftype(
>  	struct xfs_mount		*mp,
>  	struct xfs_dir2_data_entry	*dep)
>  {
> -	if (xfs_sb_version_hasftype(&mp->m_sb)) {
> +	if (xfs_has_ftype(mp)) {
>  		uint8_t			ftype = dep->name[dep->namelen];
>  
>  		if (likely(ftype < XFS_DIR3_FT_MAX))
> @@ -70,7 +70,7 @@ xfs_dir2_data_put_ftype(
>  	ASSERT(ftype < XFS_DIR3_FT_MAX);
>  	ASSERT(dep->namelen != 0);
>  
> -	if (xfs_sb_version_hasftype(&mp->m_sb))
> +	if (xfs_has_ftype(mp))
>  		dep->name[dep->namelen] = ftype;
>  }
>  
> @@ -297,7 +297,7 @@ xfs_dir3_data_verify(
>  	if (!xfs_verify_magic(bp, hdr3->magic))
>  		return __this_address;
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
>  			return __this_address;
>  		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
> @@ -401,7 +401,7 @@ xfs_dir3_data_header_check(
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
>  
>  		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 40ac411acf03..d03db9cde271 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -37,7 +37,7 @@ xfs_dir2_leaf_hdr_from_disk(
>  	struct xfs_dir3_icleaf_hdr	*to,
>  	struct xfs_dir2_leaf		*from)
>  {
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		struct xfs_dir3_leaf *from3 = (struct xfs_dir3_leaf *)from;
>  
>  		to->forw = be32_to_cpu(from3->hdr.info.hdr.forw);
> @@ -68,7 +68,7 @@ xfs_dir2_leaf_hdr_to_disk(
>  	struct xfs_dir2_leaf		*to,
>  	struct xfs_dir3_icleaf_hdr	*from)
>  {
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		struct xfs_dir3_leaf *to3 = (struct xfs_dir3_leaf *)to;
>  
>  		ASSERT(from->magic == XFS_DIR3_LEAF1_MAGIC ||
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index a2ee1d48519c..fbd2de8b3cf2 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -247,7 +247,7 @@ xfs_dir2_free_hdr_from_disk(
>  	struct xfs_dir3_icfree_hdr	*to,
>  	struct xfs_dir2_free		*from)
>  {
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		struct xfs_dir3_free	*from3 = (struct xfs_dir3_free *)from;
>  
>  		to->magic = be32_to_cpu(from3->hdr.hdr.magic);
> @@ -274,7 +274,7 @@ xfs_dir2_free_hdr_to_disk(
>  	struct xfs_dir2_free		*to,
>  	struct xfs_dir3_icfree_hdr	*from)
>  {
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		struct xfs_dir3_free	*to3 = (struct xfs_dir3_free *)to;
>  
>  		ASSERT(from->magic == XFS_DIR3_FREE_MAGIC);
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 94943ce49cab..711709a2aa53 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -196,7 +196,7 @@ xfs_dir2_data_entsize(
>  
>  	len = offsetof(struct xfs_dir2_data_entry, name[0]) + namelen +
>  			sizeof(xfs_dir2_data_off_t) /* tag */;
> -	if (xfs_sb_version_hasftype(&mp->m_sb))
> +	if (xfs_has_ftype(mp))
>  		len += sizeof(uint8_t);
>  	return round_up(len, XFS_DIR2_DATA_ALIGN);
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 1afe09910bee..5a97a87eaa20 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -48,7 +48,7 @@ xfs_dir2_sf_entsize(
>  	count += sizeof(struct xfs_dir2_sf_entry);	/* namelen + offset */
>  	count += hdr->i8count ? XFS_INO64_SIZE : XFS_INO32_SIZE; /* ino # */
>  
> -	if (xfs_sb_version_hasftype(&mp->m_sb))
> +	if (xfs_has_ftype(mp))
>  		count += sizeof(uint8_t);
>  	return count;
>  }
> @@ -76,7 +76,7 @@ xfs_dir2_sf_get_ino(
>  {
>  	uint8_t				*from = sfep->name + sfep->namelen;
>  
> -	if (xfs_sb_version_hasftype(&mp->m_sb))
> +	if (xfs_has_ftype(mp))
>  		from++;
>  
>  	if (!hdr->i8count)
> @@ -95,7 +95,7 @@ xfs_dir2_sf_put_ino(
>  
>  	ASSERT(ino <= XFS_MAXINUMBER);
>  
> -	if (xfs_sb_version_hasftype(&mp->m_sb))
> +	if (xfs_has_ftype(mp))
>  		to++;
>  
>  	if (hdr->i8count)
> @@ -135,7 +135,7 @@ xfs_dir2_sf_get_ftype(
>  	struct xfs_mount		*mp,
>  	struct xfs_dir2_sf_entry	*sfep)
>  {
> -	if (xfs_sb_version_hasftype(&mp->m_sb)) {
> +	if (xfs_has_ftype(mp)) {
>  		uint8_t			ftype = sfep->name[sfep->namelen];
>  
>  		if (ftype < XFS_DIR3_FT_MAX)
> @@ -153,7 +153,7 @@ xfs_dir2_sf_put_ftype(
>  {
>  	ASSERT(ftype < XFS_DIR3_FT_MAX);
>  
> -	if (xfs_sb_version_hasftype(&mp->m_sb))
> +	if (xfs_has_ftype(mp))
>  		sfep->name[sfep->namelen] = ftype;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index edd0f413f030..deeb74becabc 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -70,7 +70,7 @@ xfs_dquot_verify(
>  		return __this_address;
>  
>  	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) &&
> -	    !xfs_sb_version_hasbigtime(&mp->m_sb))
> +	    !xfs_has_bigtime(mp))
>  		return __this_address;
>  
>  	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) && !ddq->d_id)
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 41bc382a91ec..51768f8999e5 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -302,7 +302,7 @@ xfs_ialloc_inode_init(
>  	 * That means for v3 inode we log the entire buffer rather than just the
>  	 * inode cores.
>  	 */
> -	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> +	if (xfs_has_v3inodes(mp)) {
>  		version = 3;
>  		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
>  
> @@ -635,7 +635,7 @@ xfs_ialloc_ag_alloc(
>  
>  #ifdef DEBUG
>  	/* randomly do sparse inode allocations */
> -	if (xfs_sb_version_hassparseinodes(&tp->t_mountp->m_sb) &&
> +	if (xfs_has_sparseinodes(tp->t_mountp) &&
>  	    igeo->ialloc_min_blks < igeo->ialloc_blks)
>  		do_sparse = prandom_u32() & 1;
>  #endif
> @@ -754,7 +754,7 @@ xfs_ialloc_ag_alloc(
>  	 * Finally, try a sparse allocation if the filesystem supports it and
>  	 * the sparse allocation length is smaller than a full chunk.
>  	 */
> -	if (xfs_sb_version_hassparseinodes(&args.mp->m_sb) &&
> +	if (xfs_has_sparseinodes(args.mp) &&
>  	    igeo->ialloc_min_blks < igeo->ialloc_blks &&
>  	    args.fsbno == NULLFSBLOCK) {
>  sparse_alloc:
> @@ -856,7 +856,7 @@ xfs_ialloc_ag_alloc(
>  		 * from the previous call. Set merge false to replace any
>  		 * existing record with this one.
>  		 */
> -		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
> +		if (xfs_has_finobt(args.mp)) {
>  			error = xfs_inobt_insert_sprec(args.mp, tp, agbp, pag,
>  				       XFS_BTNUM_FINO, &rec, false);
>  			if (error)
> @@ -869,7 +869,7 @@ xfs_ialloc_ag_alloc(
>  		if (error)
>  			return error;
>  
> -		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
> +		if (xfs_has_finobt(args.mp)) {
>  			error = xfs_inobt_insert(args.mp, tp, agbp, pag, newino,
>  						 newlen, XFS_BTNUM_FINO);
>  			if (error)
> @@ -1448,7 +1448,7 @@ xfs_dialloc_ag(
>  	int				offset;
>  	int				i;
>  
> -	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
> +	if (!xfs_has_finobt(mp))
>  		return xfs_dialloc_ag_inobt(tp, agbp, pag, parent, inop);
>  
>  	/*
> @@ -2187,7 +2187,7 @@ xfs_difree(
>  	/*
>  	 * Fix up the free inode btree.
>  	 */
> -	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
> +	if (xfs_has_finobt(mp)) {
>  		error = xfs_difree_finobt(mp, tp, agbp, pag, agino, &rec);
>  		if (error)
>  			goto error0;
> @@ -2771,7 +2771,7 @@ xfs_ialloc_setup_geometry(
>  	uint			inodes;
>  
>  	igeo->new_diflags2 = 0;
> -	if (xfs_sb_version_hasbigtime(&mp->m_sb))
> +	if (xfs_has_bigtime(mp))
>  		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
>  
>  	/* Compute inode btree geometry. */
> @@ -2826,7 +2826,7 @@ xfs_ialloc_setup_geometry(
>  	 * cannot change the behavior.
>  	 */
>  	igeo->inode_cluster_size_raw = XFS_INODE_BIG_CLUSTER_SIZE;
> -	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> +	if (xfs_has_v3inodes(mp)) {
>  		int	new_size = igeo->inode_cluster_size_raw;
>  
>  		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
> @@ -2844,7 +2844,7 @@ xfs_ialloc_setup_geometry(
>  	igeo->inodes_per_cluster = XFS_FSB_TO_INO(mp, igeo->blocks_per_cluster);
>  
>  	/* Calculate inode cluster alignment. */
> -	if (xfs_sb_version_hasalign(&mp->m_sb) &&
> +	if (xfs_has_align(mp) &&
>  	    mp->m_sb.sb_inoalignmt >= igeo->blocks_per_cluster)
>  		igeo->cluster_align = mp->m_sb.sb_inoalignmt;
>  	else
> @@ -2892,15 +2892,15 @@ xfs_ialloc_calc_rootino(
>  	first_bno += xfs_alloc_min_freelist(mp, NULL);
>  
>  	/* ...the free inode btree root... */
> -	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +	if (xfs_has_finobt(mp))
>  		first_bno++;
>  
>  	/* ...the reverse mapping btree root... */
> -	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +	if (xfs_has_rmapbt(mp))
>  		first_bno++;
>  
>  	/* ...the reference count btree... */
> -	if (xfs_sb_version_hasreflink(&mp->m_sb))
> +	if (xfs_has_reflink(mp))
>  		first_bno++;
>  
>  	/*
> @@ -2918,9 +2918,9 @@ xfs_ialloc_calc_rootino(
>  	 * Now round first_bno up to whatever allocation alignment is given
>  	 * by the filesystem or was passed in.
>  	 */
> -	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0)
> +	if (xfs_has_dalign(mp) && igeo->ialloc_align > 0)
>  		first_bno = roundup(first_bno, sunit);
> -	else if (xfs_sb_version_hasalign(&mp->m_sb) &&
> +	else if (xfs_has_align(mp) &&
>  			mp->m_sb.sb_inoalignmt > 1)
>  		first_bno = roundup(first_bno, mp->m_sb.sb_inoalignmt);
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 4a599c8ca33a..f1384c280059 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -76,7 +76,7 @@ xfs_inobt_mod_blockcount(
>  	struct xfs_buf		*agbp = cur->bc_ag.agbp;
>  	struct xfs_agi		*agi = agbp->b_addr;
>  
> -	if (!xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb))
> +	if (!xfs_has_inobtcounts(cur->bc_mp))
>  		return;
>  
>  	if (cur->bc_btnum == XFS_BTNUM_FINO)
> @@ -292,7 +292,7 @@ xfs_inobt_verify(
>  	 * but beware of the landmine (i.e. need to check pag->pagi_init) if we
>  	 * ever do.
>  	 */
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_has_crc(mp)) {
>  		fa = xfs_btree_sblock_v5hdr_verify(bp);
>  		if (fa)
>  			return fa;
> @@ -511,7 +511,7 @@ xfs_inobt_commit_staged_btree(
>  		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
>  		agi->agi_root = cpu_to_be32(afake->af_root);
>  		agi->agi_level = cpu_to_be32(afake->af_levels);
> -		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
> +		if (xfs_has_inobtcounts(cur->bc_mp)) {
>  			agi->agi_iblocks = cpu_to_be32(afake->af_blocks);
>  			fields |= XFS_AGI_IBLOCKS;
>  		}
> @@ -521,7 +521,7 @@ xfs_inobt_commit_staged_btree(
>  		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
>  		agi->agi_free_root = cpu_to_be32(afake->af_root);
>  		agi->agi_free_level = cpu_to_be32(afake->af_levels);
> -		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
> +		if (xfs_has_inobtcounts(cur->bc_mp)) {
>  			agi->agi_fblocks = cpu_to_be32(afake->af_blocks);
>  			fields |= XFS_AGI_IBLOCKS;
>  		}
> @@ -740,7 +740,7 @@ xfs_finobt_calc_reserves(
>  	if (!xfs_has_finobt(mp))
>  		return 0;
>  
> -	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> +	if (xfs_has_inobtcounts(mp))
>  		error = xfs_finobt_read_blocks(mp, tp, pag, &tree_len);
>  	else
>  		error = xfs_inobt_count_blocks(mp, tp, pag, XFS_BTNUM_FINO,
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 5ae5011b72ab..08b4413d3ac4 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -192,7 +192,7 @@ xfs_inode_from_disk(
>  	 * inode. If the inode is unused, mode is zero and we shouldn't mess
>  	 * with the uninitialized part of it.
>  	 */
> -	if (!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb))
> +	if (!xfs_has_v3inodes(ip->i_mount))
>  		ip->i_flushiter = be16_to_cpu(from->di_flushiter);
>  	inode->i_generation = be32_to_cpu(from->di_gen);
>  	inode->i_mode = be16_to_cpu(from->di_mode);
> @@ -235,7 +235,7 @@ xfs_inode_from_disk(
>  	if (from->di_dmevmask || from->di_dmstate)
>  		xfs_iflags_set(ip, XFS_IPRESERVE_DM_FIELDS);
>  
> -	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
> +	if (xfs_has_v3inodes(ip->i_mount)) {
>  		inode_set_iversion_queried(inode,
>  					   be64_to_cpu(from->di_changecount));
>  		ip->i_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
> @@ -313,7 +313,7 @@ xfs_inode_to_disk(
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_flags = cpu_to_be16(ip->i_diflags);
>  
> -	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
> +	if (xfs_has_v3inodes(ip->i_mount)) {
>  		to->di_version = 3;
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
>  		to->di_crtime = xfs_inode_to_disk_ts(ip, ip->i_crtime);
> @@ -413,7 +413,7 @@ xfs_dinode_verify(
>  
>  	/* Verify v3 integrity information first */
>  	if (dip->di_version >= 3) {
> -		if (!xfs_sb_version_has_v3inode(&mp->m_sb))
> +		if (!xfs_has_v3inodes(mp))
>  			return __this_address;
>  		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
>  				      XFS_DINODE_CRC_OFF))
> @@ -534,7 +534,7 @@ xfs_dinode_verify(
>  
>  	/* bigtime iflag can only happen on bigtime filesystems */
>  	if (xfs_dinode_has_bigtime(dip) &&
> -	    !xfs_sb_version_hasbigtime(&mp->m_sb))
> +	    !xfs_has_bigtime(mp))
>  		return __this_address;
>  
>  	return NULL;
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index c01bd648e5ce..9ffb74ccde79 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -425,7 +425,7 @@ struct xfs_log_dinode {
>  };
>  
>  #define xfs_log_dinode_size(mp)						\
> -	(xfs_sb_version_has_v3inode(&(mp)->m_sb) ?			\
> +	(xfs_has_v3inodes((mp)) ?					\
>  		sizeof(struct xfs_log_dinode) :				\
>  		offsetof(struct xfs_log_dinode, di_next_unlinked))
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 860a0c9801ba..d48fd879d3d9 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1253,7 +1253,7 @@ xfs_refcount_increase_extent(
>  	struct xfs_trans		*tp,
>  	struct xfs_bmbt_irec		*PREV)
>  {
> -	if (!xfs_sb_version_hasreflink(&tp->t_mountp->m_sb))
> +	if (!xfs_has_reflink(tp->t_mountp))
>  		return;
>  
>  	__xfs_refcount_add(tp, XFS_REFCOUNT_INCREASE, PREV->br_startblock,
> @@ -1268,7 +1268,7 @@ xfs_refcount_decrease_extent(
>  	struct xfs_trans		*tp,
>  	struct xfs_bmbt_irec		*PREV)
>  {
> -	if (!xfs_sb_version_hasreflink(&tp->t_mountp->m_sb))
> +	if (!xfs_has_reflink(tp->t_mountp))
>  		return;
>  
>  	__xfs_refcount_add(tp, XFS_REFCOUNT_DECREASE, PREV->br_startblock,
> @@ -1617,7 +1617,7 @@ xfs_refcount_alloc_cow_extent(
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
>  
> -	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> +	if (!xfs_has_reflink(mp))
>  		return;
>  
>  	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
> @@ -1636,7 +1636,7 @@ xfs_refcount_free_cow_extent(
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
>  
> -	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> +	if (!xfs_has_reflink(mp))
>  		return;
>  
>  	/* Remove rmap entry */
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 2a01769b316a..a4ea6e2a38e2 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -912,7 +912,7 @@ xfs_log_sb(
>  	 * unclean shutdown, this will be corrected by log recovery rebuilding
>  	 * the counters from the AGF block counts.
>  	 */
> -	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> +	if (xfs_has_lazysbcount(mp)) {
>  		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
>  		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
>  		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 8d595a5c4abd..6ba554c1e532 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -136,7 +136,7 @@ xfs_trans_log_inode(
>  	 * to upgrade this inode to bigtime format, do so now.
>  	 */
>  	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
> -	    xfs_sb_version_hasbigtime(&ip->i_mount->m_sb) &&
> +	    xfs_has_bigtime(ip->i_mount) &&
>  	    !xfs_inode_has_bigtime(ip)) {
>  		ip->i_diflags2 |= XFS_DIFLAG2_BIGTIME;
>  		flags |= XFS_ILOG_CORE;
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 8bf7bc09bcaa..fa3a855b7e67 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -187,7 +187,7 @@ xfs_calc_inode_chunk_res(
>  			       XFS_FSB_TO_B(mp, 1));
>  	if (alloc) {
>  		/* icreate tx uses ordered buffers */
> -		if (xfs_sb_version_has_v3inode(&mp->m_sb))
> +		if (xfs_has_v3inodes(mp))
>  			return res;
>  		size = XFS_FSB_TO_B(mp, 1);
>  	}
> @@ -268,7 +268,7 @@ xfs_calc_write_reservation(
>  	     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
>  	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
>  
> -	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
> +	if (xfs_has_realtime(mp)) {
>  		t2 = xfs_calc_inode_res(mp, 1) +
>  		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
>  				     blksz) +
> @@ -317,7 +317,7 @@ xfs_calc_itruncate_reservation(
>  	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
>  	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
>  
> -	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
> +	if (xfs_has_realtime(mp)) {
>  		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
>  		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
>  		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index 7ad3659c5d2a..50332be34388 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -57,8 +57,7 @@
>  	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
>  #define	XFS_IALLOC_SPACE_RES(mp)	\
>  	(M_IGEO(mp)->ialloc_blks + \
> -	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
> -	  M_IGEO(mp)->inobt_maxlevels))
> +	 ((xfs_has_finobt(mp) ? 2 : 1) * M_IGEO(mp)->inobt_maxlevels))
>  
>  /*
>   * Space reservation values for various transactions.
> @@ -94,8 +93,7 @@
>  #define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
>  	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
>  #define XFS_IFREE_SPACE_RES(mp)		\
> -	(xfs_sb_version_hasfinobt(&mp->m_sb) ? \
> -			M_IGEO(mp)->inobt_maxlevels : 0)
> +	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
>  
>  
>  #endif	/* __XFS_TRANS_SPACE_H__ */
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 417f07d4dfd0..549e6dda16e6 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -419,7 +419,7 @@ xchk_agf_xref_btreeblks(
>  	int			error;
>  
>  	/* agf_btreeblks didn't exist before lazysbcount */
> -	if (!xfs_sb_version_haslazysbcount(&sc->mp->m_sb))
> +	if (!xfs_has_lazysbcount(sc->mp))
>  		return;
>  
>  	/* Check agf_rmap_blocks; set up for agf_btreeblks check */
> @@ -587,7 +587,7 @@ xchk_agf(
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  	if (pag->pagf_flcount != be32_to_cpu(agf->agf_flcount))
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
> -	if (xfs_sb_version_haslazysbcount(&sc->mp->m_sb) &&
> +	if (xfs_has_lazysbcount(sc->mp) &&
>  	    pag->pagf_btreeblks != be32_to_cpu(agf->agf_btreeblks))
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  	xfs_perag_put(pag);
> @@ -787,7 +787,7 @@ xchk_agi_xref_fiblocks(
>  	xfs_agblock_t		blocks;
>  	int			error = 0;
>  
> -	if (!xfs_sb_version_hasinobtcounts(&sc->mp->m_sb))
> +	if (!xfs_has_inobtcounts(sc->mp))
>  		return;
>  
>  	if (sc->sa.ino_cur) {
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index df594cebb319..ae1e9a47e24c 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -811,7 +811,7 @@ xrep_agi_calc_from_btrees(
>  	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
>  	if (error)
>  		goto err;
> -	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +	if (xfs_has_inobtcounts(mp)) {
>  		xfs_agblock_t	blocks;
>  
>  		error = xfs_btree_count_blocks(cur, &blocks);
> @@ -824,8 +824,7 @@ xrep_agi_calc_from_btrees(
>  	agi->agi_count = cpu_to_be32(count);
>  	agi->agi_freecount = cpu_to_be32(freecount);
>  
> -	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
> -	    xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +	if (xfs_has_finobt(mp) && xfs_has_inobtcounts(mp)) {
>  		xfs_agblock_t	blocks;
>  
>  		cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp,
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 1c7d090f9fd0..aa485b473622 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -659,8 +659,7 @@ xchk_bmap(
>  		}
>  		break;
>  	case XFS_ATTR_FORK:
> -		if (!xfs_sb_version_hasattr(&mp->m_sb) &&
> -		    !xfs_sb_version_hasattr2(&mp->m_sb))
> +		if (!xfs_has_attr(mp) && !xfs_has_attr2(mp))
>  			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
>  		break;
>  	default:
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index d4599a71a5b2..c1e301bdce68 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -484,21 +484,21 @@ xchk_ag_btcur_init(
>  	}
>  
>  	/* Set up a finobt cursor for cross-referencing. */
> -	if (sa->agi_bp && xfs_sb_version_hasfinobt(&mp->m_sb) &&
> +	if (sa->agi_bp && xfs_has_finobt(mp) &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_FINO)) {
>  		sa->fino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
>  				sa->pag, XFS_BTNUM_FINO);
>  	}
>  
>  	/* Set up a rmapbt cursor for cross-referencing. */
> -	if (sa->agf_bp && xfs_sb_version_hasrmapbt(&mp->m_sb) &&
> +	if (sa->agf_bp && xfs_has_rmapbt(mp) &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_RMAP)) {
>  		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
>  				sa->pag);
>  	}
>  
>  	/* Set up a refcountbt cursor for cross-referencing. */
> -	if (sa->agf_bp && xfs_sb_version_hasreflink(&mp->m_sb) &&
> +	if (sa->agf_bp && xfs_has_reflink(mp) &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_REFC)) {
>  		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
>  				sa->agf_bp, sa->pag);
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index fd7941e04ae1..bd3521e7582b 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -207,7 +207,7 @@ xchk_fscount_aggregate_agcounts(
>  		/* Add up the free/freelist/bnobt/cntbt blocks */
>  		fsc->fdblocks += pag->pagf_freeblks;
>  		fsc->fdblocks += pag->pagf_flcount;
> -		if (xfs_sb_version_haslazysbcount(&sc->mp->m_sb)) {
> +		if (xfs_has_lazysbcount(sc->mp)) {
>  			fsc->fdblocks += pag->pagf_btreeblks;
>  		} else {
>  			error = xchk_fscount_btreeblks(sc, fsc, agno);
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 23950e384fda..d4bb36746d22 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -185,8 +185,7 @@ xchk_inode_flags2(
>  		goto bad;
>  
>  	/* no bigtime iflag without the bigtime feature */
> -	if (xfs_dinode_has_bigtime(dip) &&
> -	    !xfs_sb_version_hasbigtime(&mp->m_sb))
> +	if (xfs_dinode_has_bigtime(dip) && !xfs_has_bigtime(mp))
>  		goto bad;
>  
>  	return;
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index acbb9839d42f..c35c8b33fd21 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -127,7 +127,7 @@ xchk_quota_item(
>  	 * a reflink filesystem we're allowed to exceed physical space
>  	 * if there are no quota limits.
>  	 */
> -	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +	if (xfs_has_reflink(mp)) {
>  		if (mp->m_sb.sb_dblocks < dq->q_blk.count)
>  			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
>  					offset);
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 487b00434b96..bea65f2fe657 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -8,8 +8,7 @@
>  
>  static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
>  {
> -	return ip->i_mount->m_always_cow &&
> -		xfs_sb_version_hasreflink(&ip->i_mount->m_sb);
> +	return ip->i_mount->m_always_cow && xfs_has_reflink(ip->i_mount);
>  }
>  
>  static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2463848f92ff..8dd8398846fa 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1444,7 +1444,7 @@ xfs_fs_fill_super(
>  	}
>  
>  	/* Filesystem claims it needs repair, so refuse the mount. */
> -	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> +	if (xfs_has_needsrepair(mp)) {
>  		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
>  		error = -EFSCORRUPTED;
>  		goto out_free_sb;
> -- 
> 2.31.1
> 
