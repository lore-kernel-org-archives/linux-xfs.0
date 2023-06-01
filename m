Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEC3C7EE23
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 14:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbjFAOvy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 10:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbjFAOvy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 10:51:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7533D134
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 07:51:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF1E364634
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 14:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53336C433D2;
        Thu,  1 Jun 2023 14:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685631111;
        bh=cqhboCYa3dVgye6MW8h+O9hzuZV4RBVOPUo7e4KimK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XqcKr6KvRrP0q0IWkXFhBkJNxXDU7ifYFPbEfOPQqByirO76/VF24UlyFl+ZuQGIE
         Y7JXW94kfoUXnYX5P3b2PQVxY3AEj+4YzA8DiIvwembRSr+4wCUt0pJs1UBik2y2sa
         rw7HpiP3XBAFg4Z5t6520/abGoYP0PfU/HsK8wOXocx65M7Pxh47IH7H+xHOhsffLY
         tur1Iy1lOMk1h0iXr9HaB8v46pxwOTHdUKyDDYKnIgwL6VgddfX9neKgznoFqpAq3t
         N7vK7UcBL66qTgaWQe2RCV8jvZdS6ryWNBvE5kjoZHNlTkyQ0UME2zearuu7F6zUmh
         zDQc7PaOTkI1Q==
Date:   Thu, 1 Jun 2023 07:51:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: validate block number being freed before adding
 to xefi
Message-ID: <20230601145150.GE16865@frogsfrogsfrogs>
References: <20230529000825.2325477-1-david@fromorbit.com>
 <20230529000825.2325477-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529000825.2325477-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 29, 2023 at 10:08:25AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Bad things happen in defered extent freeing operations if it is
> passed a bad block number in the xefi. This can come from a bogus
> agno/agbno pair from deferred agfl freeing, or just a bad fsbno
> being passed to __xfs_free_extent_later(). Either way, it's very
> difficult to diagnose where a null perag oops in EFI creation
> is coming from when the operation that queued the xefi has already
> been completed and there's no longer any trace of it around....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c         |  5 ++++-
>  fs/xfs/libxfs/xfs_alloc.c      | 16 +++++++++++++---
>  fs/xfs/libxfs/xfs_alloc.h      |  6 +++---
>  fs/xfs/libxfs/xfs_bmap.c       | 10 ++++++++--
>  fs/xfs/libxfs/xfs_bmap_btree.c |  7 +++++--
>  fs/xfs/libxfs/xfs_ialloc.c     | 24 ++++++++++++++++--------
>  fs/xfs/libxfs/xfs_refcount.c   | 13 ++++++++++---
>  fs/xfs/xfs_reflink.c           |  4 +++-
>  8 files changed, 62 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 9b373a0c7aaf..ee84835ebc66 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -984,7 +984,10 @@ xfs_ag_shrink_space(
>  		if (err2 != -ENOSPC)
>  			goto resv_err;
>  
> -		__xfs_free_extent_later(*tpp, args.fsbno, delta, NULL, true);
> +		err2 = __xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
> +				true);
> +		if (err2)
> +			goto resv_err;
>  
>  		/*
>  		 * Roll the transaction before trying to re-init the per-ag
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 643d17877832..c20fe99405d8 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2431,7 +2431,7 @@ xfs_agfl_reset(
>   * the real allocation can proceed. Deferring the free disconnects freeing up
>   * the AGFL slot from freeing the block.
>   */
> -STATIC void
> +static int
>  xfs_defer_agfl_block(
>  	struct xfs_trans		*tp,
>  	xfs_agnumber_t			agno,
> @@ -2450,17 +2450,21 @@ xfs_defer_agfl_block(
>  	xefi->xefi_blockcount = 1;
>  	xefi->xefi_owner = oinfo->oi_owner;
>  
> +	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, xefi->xefi_startblock)))
> +		return -EFSCORRUPTED;
> +
>  	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
>  
>  	xfs_extent_free_get_group(mp, xefi);
>  	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &xefi->xefi_list);
> +	return 0;
>  }
>  
>  /*
>   * Add the extent to the list of extents to be free at transaction end.
>   * The list is maintained sorted (by block number).
>   */
> -void
> +int
>  __xfs_free_extent_later(
>  	struct xfs_trans		*tp,
>  	xfs_fsblock_t			bno,
> @@ -2487,6 +2491,9 @@ __xfs_free_extent_later(
>  #endif
>  	ASSERT(xfs_extfree_item_cache != NULL);
>  
> +	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
> +		return -EFSCORRUPTED;
> +
>  	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
>  			       GFP_KERNEL | __GFP_NOFAIL);
>  	xefi->xefi_startblock = bno;
> @@ -2510,6 +2517,7 @@ __xfs_free_extent_later(
>  
>  	xfs_extent_free_get_group(mp, xefi);
>  	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
> +	return 0;
>  }
>  
>  #ifdef DEBUG
> @@ -2670,7 +2678,9 @@ xfs_alloc_fix_freelist(
>  			goto out_agbp_relse;
>  
>  		/* defer agfl frees */
> -		xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
> +		error = xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
> +		if (error)
> +			goto out_agbp_relse;
>  	}
>  
>  	targs.tp = tp;
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 5dbb25546d0b..85ac470be0da 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -230,7 +230,7 @@ xfs_buf_to_agfl_bno(
>  	return bp->b_addr;
>  }
>  
> -void __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
> +int __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
>  		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
>  		bool skip_discard);
>  
> @@ -254,14 +254,14 @@ void xfs_extent_free_get_group(struct xfs_mount *mp,
>  #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
>  #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
>  
> -static inline void
> +static inline int
>  xfs_free_extent_later(
>  	struct xfs_trans		*tp,
>  	xfs_fsblock_t			bno,
>  	xfs_filblks_t			len,
>  	const struct xfs_owner_info	*oinfo)
>  {
> -	__xfs_free_extent_later(tp, bno, len, oinfo, false);
> +	return __xfs_free_extent_later(tp, bno, len, oinfo, false);
>  }
>  
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index cd8870a16fd1..fef35696adb7 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -572,8 +572,12 @@ xfs_bmap_btree_to_extents(
>  	cblock = XFS_BUF_TO_BLOCK(cbp);
>  	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
>  		return error;
> +
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
> -	xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
> +	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
> +	if (error)
> +		return error;
> +
>  	ip->i_nblocks--;
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
>  	xfs_trans_binval(tp, cbp);
> @@ -5230,10 +5234,12 @@ xfs_bmap_del_extent_real(
>  		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
>  			xfs_refcount_decrease_extent(tp, del);
>  		} else {
> -			__xfs_free_extent_later(tp, del->br_startblock,
> +			error = __xfs_free_extent_later(tp, del->br_startblock,
>  					del->br_blockcount, NULL,
>  					(bflags & XFS_BMAPI_NODISCARD) ||
>  					del->br_state == XFS_EXT_UNWRITTEN);
> +			if (error)
> +				goto done;
>  		}
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 1b40e5f8b1ec..36564ae3084f 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -268,11 +268,14 @@ xfs_bmbt_free_block(
>  	struct xfs_trans	*tp = cur->bc_tp;
>  	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
>  	struct xfs_owner_info	oinfo;
> +	int			error;
>  
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
> -	xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
> +	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
> +	if (error)
> +		return error;
> +
>  	ip->i_nblocks--;
> -
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
>  	return 0;
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index a16d5de16933..34600f94c2f4 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1834,7 +1834,7 @@ xfs_dialloc(
>   * might be sparse and only free the regions that are allocated as part of the
>   * chunk.
>   */
> -STATIC void
> +static int
>  xfs_difree_inode_chunk(
>  	struct xfs_trans		*tp,
>  	xfs_agnumber_t			agno,
> @@ -1851,10 +1851,10 @@ xfs_difree_inode_chunk(
>  
>  	if (!xfs_inobt_issparse(rec->ir_holemask)) {
>  		/* not sparse, calculate extent info directly */
> -		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
> -				  M_IGEO(mp)->ialloc_blks,
> -				  &XFS_RMAP_OINFO_INODES);
> -		return;
> +		return xfs_free_extent_later(tp,
> +				XFS_AGB_TO_FSB(mp, agno, sagbno),
> +				M_IGEO(mp)->ialloc_blks,
> +				&XFS_RMAP_OINFO_INODES);
>  	}
>  
>  	/* holemask is only 16-bits (fits in an unsigned long) */
> @@ -1871,6 +1871,8 @@ xfs_difree_inode_chunk(
>  						XFS_INOBT_HOLEMASK_BITS);
>  	nextbit = startidx + 1;
>  	while (startidx < XFS_INOBT_HOLEMASK_BITS) {
> +		int error;
> +
>  		nextbit = find_next_zero_bit(holemask, XFS_INOBT_HOLEMASK_BITS,
>  					     nextbit);
>  		/*
> @@ -1896,8 +1898,11 @@ xfs_difree_inode_chunk(
>  
>  		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
>  		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
> -		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
> -				  contigblk, &XFS_RMAP_OINFO_INODES);
> +		error = xfs_free_extent_later(tp,
> +				XFS_AGB_TO_FSB(mp, agno, agbno),
> +				contigblk, &XFS_RMAP_OINFO_INODES);
> +		if (error)
> +			return error;
>  
>  		/* reset range to current bit and carry on... */
>  		startidx = endidx = nextbit;
> @@ -1905,6 +1910,7 @@ xfs_difree_inode_chunk(
>  next:
>  		nextbit++;
>  	}
> +	return 0;
>  }
>  
>  STATIC int
> @@ -2003,7 +2009,9 @@ xfs_difree_inobt(
>  			goto error0;
>  		}
>  
> -		xfs_difree_inode_chunk(tp, pag->pag_agno, &rec);
> +		error = xfs_difree_inode_chunk(tp, pag->pag_agno, &rec);
> +		if (error)
> +			goto error0;
>  	} else {
>  		xic->deleted = false;
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index c1c65774dcc2..b6e21433925c 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1151,8 +1151,10 @@ xfs_refcount_adjust_extents(
>  				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
>  						cur->bc_ag.pag->pag_agno,
>  						tmp.rc_startblock);
> -				xfs_free_extent_later(cur->bc_tp, fsbno,
> +				error = xfs_free_extent_later(cur->bc_tp, fsbno,
>  						  tmp.rc_blockcount, NULL);
> +				if (error)
> +					goto out_error;
>  			}
>  
>  			(*agbno) += tmp.rc_blockcount;
> @@ -1210,8 +1212,10 @@ xfs_refcount_adjust_extents(
>  			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
>  					cur->bc_ag.pag->pag_agno,
>  					ext.rc_startblock);
> -			xfs_free_extent_later(cur->bc_tp, fsbno,
> +			error = xfs_free_extent_later(cur->bc_tp, fsbno,
>  					ext.rc_blockcount, NULL);
> +			if (error)
> +				goto out_error;
>  		}
>  
>  skip:
> @@ -1976,7 +1980,10 @@ xfs_refcount_recover_cow_leftovers(
>  				rr->rr_rrec.rc_blockcount);
>  
>  		/* Free the block. */
> -		xfs_free_extent_later(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
> +		error = xfs_free_extent_later(tp, fsb,
> +				rr->rr_rrec.rc_blockcount, NULL);
> +		if (error)
> +			goto out_trans;
>  
>  		error = xfs_trans_commit(tp);
>  		if (error)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index f5dc46ce9803..abcc559f3c64 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -616,8 +616,10 @@ xfs_reflink_cancel_cow_blocks(
>  			xfs_refcount_free_cow_extent(*tpp, del.br_startblock,
>  					del.br_blockcount);
>  
> -			xfs_free_extent_later(*tpp, del.br_startblock,
> +			error = xfs_free_extent_later(*tpp, del.br_startblock,
>  					  del.br_blockcount, NULL);
> +			if (error)
> +				break;
>  
>  			/* Roll the transaction */
>  			error = xfs_defer_finish(tpp);
> -- 
> 2.40.1
> 
