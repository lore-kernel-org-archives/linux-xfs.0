Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AC1C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 00:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C51626056C
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 00:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhHKApB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 20:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236047AbhHKApB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Aug 2021 20:45:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 627FE6056C;
        Wed, 11 Aug 2021 00:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628642678;
        bh=JUSmiMdb/Src8V7CRxnpxdXnRWQwe7RV5Mbc5FzHgFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BsRHkQTaP28aqBgJnLy2XYiJHyK2gSIs0KvN/KvtqGIwNYeOIkG4NgegrKJ85nrm+
         j/m/fo0sSJ9uyHwV8Id+r+4mK/U+MvdeCe8hGZmj0Xx22mVOTPzhKT+G4q3egOjmAg
         ae2iK7z5kwXneAOKRrdVSoJKU+jIXNzkcLwa1rZlSOnwoszSqy0mgotef8EMCaUmiW
         P0skJIjRgrT3Eix0P16yN7eIju0fnIH2Nbuz++1KnMB4VOYUEcsT/BB3cl/6Z4LF6N
         WofepuRYv3pHcb0yQjldPDSZbWMraRLSbK2p+CMOWRfsobSjrqqVtw2X8Ma84ohCbB
         iXLH7jY+LEJYw==
Date:   Tue, 10 Aug 2021 17:44:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: convert bp->b_bn references to xfs_buf_daddr()
Message-ID: <20210811004437.GZ3601443@magnolia>
References: <20210810052851.42312-1-david@fromorbit.com>
 <20210810052851.42312-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052851.42312-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 10, 2021 at 03:28:50PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Stop directly referencing b_bn in code outside the buffer cache, as
> b_bn is supposed to be used only as an internal cache index.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c             |  1 -
>  fs/xfs/libxfs/xfs_attr_leaf.c      |  4 ++--
>  fs/xfs/libxfs/xfs_attr_remote.c    |  8 ++++----
>  fs/xfs/libxfs/xfs_bmap.c           |  2 +-
>  fs/xfs/libxfs/xfs_btree.c          | 25 +++++++++++++------------
>  fs/xfs/libxfs/xfs_da_btree.c       |  8 ++++----
>  fs/xfs/libxfs/xfs_dir2_block.c     |  4 ++--
>  fs/xfs/libxfs/xfs_dir2_data.c      |  4 ++--
>  fs/xfs/libxfs/xfs_dir2_leaf.c      |  4 ++--
>  fs/xfs/libxfs/xfs_dir2_node.c      |  6 +++---
>  fs/xfs/libxfs/xfs_inode_buf.c      |  2 +-
>  fs/xfs/libxfs/xfs_sb.c             |  2 +-
>  fs/xfs/libxfs/xfs_symlink_remote.c |  4 ++--
>  fs/xfs/scrub/bitmap.c              |  4 ++--
>  fs/xfs/scrub/common.c              |  8 ++++----
>  fs/xfs/scrub/trace.c               |  8 ++++----
>  fs/xfs/xfs_attr_inactive.c         |  4 ++--
>  fs/xfs/xfs_buf_item.c              |  2 +-
>  fs/xfs/xfs_buf_item_recover.c      |  2 +-
>  fs/xfs/xfs_error.c                 |  4 ++--
>  fs/xfs/xfs_trace.h                 | 13 +++++--------
>  21 files changed, 58 insertions(+), 61 deletions(-)
> 

<snip>

> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index dc704c2b22cb..00f631b1d4e9 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c

<snip>

> @@ -2923,10 +2923,11 @@ xfs_btree_new_iroot(
>  	 */
>  	memcpy(cblock, block, xfs_btree_block_len(cur));
>  	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
> +		xfs_daddr_t bno = cpu_to_be64(xfs_buf_daddr(cbp));

Shouldn't the type of @bno be __be64?

--D

>  		if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> -			cblock->bb_u.l.bb_blkno = cpu_to_be64(cbp->b_bn);
> +			cblock->bb_u.l.bb_blkno = bno;
>  		else
> -			cblock->bb_u.s.bb_blkno = cpu_to_be64(cbp->b_bn);
> +			cblock->bb_u.s.bb_blkno = bno;
>  	}
>  
>  	be16_add_cpu(&block->bb_level, 1);
> @@ -3225,7 +3226,7 @@ xfs_btree_insrec(
>  
>  	/* Get pointers to the btree buffer and block. */
>  	block = xfs_btree_get_block(cur, level, &bp);
> -	old_bn = bp ? bp->b_bn : XFS_BUF_DADDR_NULL;
> +	old_bn = bp ? xfs_buf_daddr(bp) : XFS_BUF_DADDR_NULL;
>  	numrecs = xfs_btree_get_numrecs(block);
>  
>  #ifdef DEBUG
> @@ -3341,7 +3342,7 @@ xfs_btree_insrec(
>  	 * some records into the new tree block), so use the regular key
>  	 * update mechanism.
>  	 */
> -	if (bp && bp->b_bn != old_bn) {
> +	if (bp && xfs_buf_daddr(bp) != old_bn) {
>  		xfs_btree_get_keys(cur, block, lkey);
>  	} else if (xfs_btree_needs_key_update(cur, optr)) {
>  		error = xfs_btree_update_keys(cur, level);
> @@ -4422,7 +4423,7 @@ xfs_btree_lblock_v5hdr_verify(
>  		return __this_address;
>  	if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
>  		return __this_address;
> -	if (block->bb_u.l.bb_blkno != cpu_to_be64(bp->b_bn))
> +	if (block->bb_u.l.bb_blkno != cpu_to_be64(xfs_buf_daddr(bp)))
>  		return __this_address;
>  	if (owner != XFS_RMAP_OWN_UNKNOWN &&
>  	    be64_to_cpu(block->bb_u.l.bb_owner) != owner)
> @@ -4472,7 +4473,7 @@ xfs_btree_sblock_v5hdr_verify(
>  		return __this_address;
>  	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
>  		return __this_address;
> -	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
> +	if (block->bb_u.s.bb_blkno != cpu_to_be64(xfs_buf_daddr(bp)))
>  		return __this_address;
>  	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
>  		return __this_address;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 99f81f6bb306..c062e2c85178 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -194,7 +194,7 @@ xfs_da3_blkinfo_verify(
>  	if (xfs_has_crc(mp)) {
>  		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
>  			return __this_address;
> -		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
> +		if (be64_to_cpu(hdr3->blkno) != xfs_buf_daddr(bp))
>  			return __this_address;
>  		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
>  			return __this_address;
> @@ -447,7 +447,7 @@ xfs_da3_node_create(
>  
>  		memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr));
>  		ichdr.magic = XFS_DA3_NODE_MAGIC;
> -		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
> +		hdr3->info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
>  		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
>  		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid);
>  	} else {
> @@ -711,7 +711,7 @@ xfs_da3_root_split(
>  	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
>  		struct xfs_da3_intnode *node3 = (struct xfs_da3_intnode *)node;
>  
> -		node3->hdr.info.blkno = cpu_to_be64(bp->b_bn);
> +		node3->hdr.info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
>  	}
>  	xfs_trans_log_buf(tp, bp, 0, size - 1);
>  
> @@ -1219,7 +1219,7 @@ xfs_da3_root_join(
>  	xfs_trans_buf_copy_type(root_blk->bp, bp);
>  	if (oldroothdr.magic == XFS_DA3_NODE_MAGIC) {
>  		struct xfs_da3_blkinfo *da3 = root_blk->bp->b_addr;
> -		da3->blkno = cpu_to_be64(root_blk->bp->b_bn);
> +		da3->blkno = cpu_to_be64(xfs_buf_daddr(root_blk->bp));
>  	}
>  	xfs_trans_log_buf(args->trans, root_blk->bp, 0,
>  			  args->geo->blksize - 1);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 41e406067f91..df0869bba275 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -56,7 +56,7 @@ xfs_dir3_block_verify(
>  	if (xfs_has_crc(mp)) {
>  		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
>  			return __this_address;
> -		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
> +		if (be64_to_cpu(hdr3->blkno) != xfs_buf_daddr(bp))
>  			return __this_address;
>  		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
>  			return __this_address;
> @@ -174,7 +174,7 @@ xfs_dir3_block_init(
>  	if (xfs_has_crc(mp)) {
>  		memset(hdr3, 0, sizeof(*hdr3));
>  		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
> -		hdr3->blkno = cpu_to_be64(bp->b_bn);
> +		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
>  		hdr3->owner = cpu_to_be64(dp->i_ino);
>  		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
>  		return;
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index c90180f2ba5c..dbcf58979a59 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -300,7 +300,7 @@ xfs_dir3_data_verify(
>  	if (xfs_has_crc(mp)) {
>  		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
>  			return __this_address;
> -		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
> +		if (be64_to_cpu(hdr3->blkno) != xfs_buf_daddr(bp))
>  			return __this_address;
>  		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
>  			return __this_address;
> @@ -722,7 +722,7 @@ xfs_dir3_data_init(
>  
>  		memset(hdr3, 0, sizeof(*hdr3));
>  		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
> -		hdr3->blkno = cpu_to_be64(bp->b_bn);
> +		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
>  		hdr3->owner = cpu_to_be64(dp->i_ino);
>  		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index d03db9cde271..d9b66306a9a7 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -108,7 +108,7 @@ xfs_dir3_leaf1_check(
>  
>  	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
>  		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
> -		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
> +		if (be64_to_cpu(leaf3->info.blkno) != xfs_buf_daddr(bp))
>  			return __this_address;
>  	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
>  		return __this_address;
> @@ -316,7 +316,7 @@ xfs_dir3_leaf_init(
>  		leaf3->info.hdr.magic = (type == XFS_DIR2_LEAF1_MAGIC)
>  					 ? cpu_to_be16(XFS_DIR3_LEAF1_MAGIC)
>  					 : cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
> -		leaf3->info.blkno = cpu_to_be64(bp->b_bn);
> +		leaf3->info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
>  		leaf3->info.owner = cpu_to_be64(owner);
>  		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid);
>  	} else {
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index fbd2de8b3cf2..7a03aeb9f4c9 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -68,7 +68,7 @@ xfs_dir3_leafn_check(
>  
>  	if (leafhdr.magic == XFS_DIR3_LEAFN_MAGIC) {
>  		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
> -		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
> +		if (be64_to_cpu(leaf3->info.blkno) != xfs_buf_daddr(bp))
>  			return __this_address;
>  	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
>  		return __this_address;
> @@ -110,7 +110,7 @@ xfs_dir3_free_verify(
>  
>  		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
>  			return __this_address;
> -		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
> +		if (be64_to_cpu(hdr3->blkno) != xfs_buf_daddr(bp))
>  			return __this_address;
>  		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
>  			return __this_address;
> @@ -346,7 +346,7 @@ xfs_dir3_free_get_buf(
>  
>  		hdr.magic = XFS_DIR3_FREE_MAGIC;
>  
> -		hdr3->hdr.blkno = cpu_to_be64(bp->b_bn);
> +		hdr3->hdr.blkno = cpu_to_be64(xfs_buf_daddr(bp));
>  		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
>  		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
>  	} else
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 83ba63b4ace4..3932b4ebf903 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -71,7 +71,7 @@ xfs_inode_buf_verify(
>  #ifdef DEBUG
>  			xfs_alert(mp,
>  				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
> -				(unsigned long long)bp->b_bn, i,
> +				(unsigned long long)xfs_buf_daddr(bp), i,
>  				be16_to_cpu(dip->di_magic));
>  #endif
>  			xfs_buf_verifier_error(bp, -EFSCORRUPTED,
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index b1c5ec1bd200..e58349be78bd 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -747,7 +747,7 @@ xfs_sb_read_verify(
>  
>  		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
>  			/* Only fail bad secondaries on a known V5 filesystem */
> -			if (bp->b_maps[0].bm_bn == XFS_SB_DADDR ||
> +			if (xfs_buf_daddr(bp) == XFS_SB_DADDR ||
>  			    xfs_has_crc(mp)) {
>  				error = -EFSBADCRC;
>  				goto out_error;
> diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> index 98b2b6804657..f0b38f4aba80 100644
> --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> @@ -51,7 +51,7 @@ xfs_symlink_hdr_set(
>  	dsl->sl_bytes = cpu_to_be32(size);
>  	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid);
>  	dsl->sl_owner = cpu_to_be64(ino);
> -	dsl->sl_blkno = cpu_to_be64(bp->b_bn);
> +	dsl->sl_blkno = cpu_to_be64(xfs_buf_daddr(bp));
>  	bp->b_ops = &xfs_symlink_buf_ops;
>  
>  	return sizeof(struct xfs_dsymlink_hdr);
> @@ -95,7 +95,7 @@ xfs_symlink_verify(
>  		return __this_address;
>  	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
>  		return __this_address;
> -	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
> +	if (xfs_buf_daddr(bp) != be64_to_cpu(dsl->sl_blkno))
>  		return __this_address;
>  	if (be32_to_cpu(dsl->sl_offset) +
>  				be32_to_cpu(dsl->sl_bytes) >= XFS_SYMLINK_MAXLEN)
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> index 813b5f219113..d6d24c866bc4 100644
> --- a/fs/xfs/scrub/bitmap.c
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -260,7 +260,7 @@ xbitmap_set_btcur_path(
>  		xfs_btree_get_block(cur, i, &bp);
>  		if (!bp)
>  			continue;
> -		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
> +		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
>  		error = xbitmap_set(bitmap, fsb, 1);
>  		if (error)
>  			return error;
> @@ -284,7 +284,7 @@ xbitmap_collect_btblock(
>  	if (!bp)
>  		return 0;
>  
> -	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
> +	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
>  	return xbitmap_set(bitmap, fsbno, 1);
>  }
>  
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 74a442bc7e14..38f8852d9837 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -186,7 +186,7 @@ xchk_block_set_preen(
>  	struct xfs_buf		*bp)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
> -	trace_xchk_block_preen(sc, bp->b_bn, __return_address);
> +	trace_xchk_block_preen(sc, xfs_buf_daddr(bp), __return_address);
>  }
>  
>  /*
> @@ -219,7 +219,7 @@ xchk_block_set_corrupt(
>  	struct xfs_buf		*bp)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> -	trace_xchk_block_error(sc, bp->b_bn, __return_address);
> +	trace_xchk_block_error(sc, xfs_buf_daddr(bp), __return_address);
>  }
>  
>  /* Record a corruption while cross-referencing. */
> @@ -229,7 +229,7 @@ xchk_block_xref_set_corrupt(
>  	struct xfs_buf		*bp)
>  {
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
> -	trace_xchk_block_error(sc, bp->b_bn, __return_address);
> +	trace_xchk_block_error(sc, xfs_buf_daddr(bp), __return_address);
>  }
>  
>  /*
> @@ -787,7 +787,7 @@ xchk_buffer_recheck(
>  	if (!fa)
>  		return;
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> -	trace_xchk_block_error(sc, bp->b_bn, fa);
> +	trace_xchk_block_error(sc, xfs_buf_daddr(bp), fa);
>  }
>  
>  /*
> diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> index 03882a605a3c..c0ef53fe6611 100644
> --- a/fs/xfs/scrub/trace.c
> +++ b/fs/xfs/scrub/trace.c
> @@ -22,11 +22,11 @@ xchk_btree_cur_fsbno(
>  	int			level)
>  {
>  	if (level < cur->bc_nlevels && cur->bc_bufs[level])
> -		return XFS_DADDR_TO_FSB(cur->bc_mp, cur->bc_bufs[level]->b_bn);
> -	else if (level == cur->bc_nlevels - 1 &&
> -		 cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +		return XFS_DADDR_TO_FSB(cur->bc_mp,
> +				xfs_buf_daddr(cur->bc_bufs[level]));
> +	if (level == cur->bc_nlevels - 1 && cur->bc_flags & XFS_BTREE_LONG_PTRS)
>  		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
> -	else if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
> +	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
>  		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno, 0);
>  	return NULLFSBLOCK;
>  }
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index d8fdde206867..2b5da6218977 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -151,7 +151,7 @@ xfs_attr3_node_inactive(
>  	}
>  
>  	xfs_da3_node_hdr_from_disk(dp->i_mount, &ichdr, bp->b_addr);
> -	parent_blkno = bp->b_bn;
> +	parent_blkno = xfs_buf_daddr(bp);
>  	if (!ichdr.count) {
>  		xfs_trans_brelse(*trans, bp);
>  		return 0;
> @@ -271,7 +271,7 @@ xfs_attr3_root_inactive(
>  	error = xfs_da3_node_read(*trans, dp, 0, &bp, XFS_ATTR_FORK);
>  	if (error)
>  		return error;
> -	blkno = bp->b_bn;
> +	blkno = xfs_buf_daddr(bp);
>  
>  	/*
>  	 * Invalidate the tree, even if the "tree" is only a single leaf block.
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index d81b0c5e6e9c..b1ab100c09e1 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -581,7 +581,7 @@ xfs_buf_item_push(
>  	if (bp->b_flags & XBF_WRITE_FAIL) {
>  		xfs_buf_alert_ratelimited(bp, "XFS: Failing async write",
>  	    "Failing async write on buffer block 0x%llx. Retrying async write.",
> -					  (long long)bp->b_bn);
> +					  (long long)xfs_buf_daddr(bp));
>  	}
>  
>  	if (!xfs_buf_delwri_queue(bp, buffer_list))
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index a14f7039d346..a476c7ef5d53 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -497,7 +497,7 @@ xlog_recover_do_reg_buffer(
>  			if (fa) {
>  				xfs_alert(mp,
>  	"dquot corrupt at %pS trying to replay into block 0x%llx",
> -					fa, bp->b_bn);
> +					fa, xfs_buf_daddr(bp));
>  				goto next;
>  			}
>  		}
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index ce3bc1b291a1..81c445e9489b 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -371,7 +371,7 @@ xfs_buf_corruption_error(
>  
>  	xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR,
>  		  "Metadata corruption detected at %pS, %s block 0x%llx",
> -		  fa, bp->b_ops->name, bp->b_bn);
> +		  fa, bp->b_ops->name, xfs_buf_daddr(bp));
>  
>  	xfs_alert(mp, "Unmount and run xfs_repair");
>  
> @@ -402,7 +402,7 @@ xfs_buf_verifier_error(
>  	xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR,
>  		  "Metadata %s detected at %pS, %s block 0x%llx %s",
>  		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
> -		  fa, bp->b_ops->name, bp->b_bn, name);
> +		  fa, bp->b_ops->name, xfs_buf_daddr(bp), name);
>  
>  	xfs_alert(mp, "Unmount and run xfs_repair");
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 5bb974c468e8..2fc51985a59e 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -386,10 +386,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = bp->b_target->bt_dev;
> -		if (bp->b_bn == XFS_BUF_DADDR_NULL)
> -			__entry->bno = bp->b_maps[0].bm_bn;
> -		else
> -			__entry->bno = bp->b_bn;
> +		__entry->bno = xfs_buf_daddr(bp);
>  		__entry->nblks = bp->b_length;
>  		__entry->hold = atomic_read(&bp->b_hold);
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
> @@ -457,7 +454,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = bp->b_target->bt_dev;
> -		__entry->bno = bp->b_bn;
> +		__entry->bno = xfs_buf_daddr(bp);
>  		__entry->buffer_length = BBTOB(bp->b_length);
>  		__entry->flags = flags;
>  		__entry->hold = atomic_read(&bp->b_hold);
> @@ -501,7 +498,7 @@ TRACE_EVENT(xfs_buf_ioerror,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = bp->b_target->bt_dev;
> -		__entry->bno = bp->b_bn;
> +		__entry->bno = xfs_buf_daddr(bp);
>  		__entry->buffer_length = BBTOB(bp->b_length);
>  		__entry->hold = atomic_read(&bp->b_hold);
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
> @@ -544,7 +541,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  		__entry->bli_flags = bip->bli_flags;
>  		__entry->bli_recur = bip->bli_recur;
>  		__entry->bli_refcount = atomic_read(&bip->bli_refcount);
> -		__entry->buf_bno = bip->bli_buf->b_bn;
> +		__entry->buf_bno = xfs_buf_daddr(bip->bli_buf);
>  		__entry->buf_len = BBTOB(bip->bli_buf->b_length);
>  		__entry->buf_flags = bip->bli_buf->b_flags;
>  		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
> @@ -2435,7 +2432,7 @@ DECLARE_EVENT_CLASS(xfs_btree_cur_class,
>  		__entry->level = level;
>  		__entry->nlevels = cur->bc_nlevels;
>  		__entry->ptr = cur->bc_ptrs[level];
> -		__entry->daddr = bp ? bp->b_bn : -1;
> +		__entry->daddr = bp ? xfs_buf_daddr(bp) : -1;
>  	),
>  	TP_printk("dev %d:%d btree %s level %d/%d ptr %d daddr 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> -- 
> 2.31.1
> 
