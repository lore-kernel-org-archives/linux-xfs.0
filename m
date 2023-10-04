Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8504FE936EC
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 23:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbjJDXlU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Oct 2023 19:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238556AbjJDXlU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2023 19:41:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331C4CE
        for <linux-xfs@vger.kernel.org>; Wed,  4 Oct 2023 16:41:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80DBC433C7;
        Wed,  4 Oct 2023 23:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696462875;
        bh=+TkUjN/LXG7qqbcj1+HXhb3Z66roNhKGzDmGi8w9XWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AVXwLAKGtewXNitwc//Dde3YKi/kBH4KGIElkBqw8iahZlzmPFcouqKXF7n9J1dOP
         lYBqtCuOJUjUlPW+XTh/PHEO9zHHiiZ0tQ9VJYBixSG+EgQhO1sW0dHbh/BX/RE/UF
         x4QxIkPJkLaqH9b6M/nPxlz435MC89i2yjz5BYZFXWypqg5MfHgd4h9pcxkYiTA/eY
         ndaLu3GUnbe1JoGZQ1rSyMqzOdqaJuUu4IliOHUFXB+wwOjdhOZP+I/CSINb7nyZfc
         57bVgCuIIdVz3rhvarPEfa1RcllKQ1jI1OfPiUcWgHgTcYC7Qe+9UIQZi43KUz0O+D
         sVkh74TGd5oKQ==
Date:   Wed, 4 Oct 2023 16:41:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 1/9] xfs: split xfs_bmap_btalloc_at_eof()
Message-ID: <20231004234115.GL21298@frogsfrogsfrogs>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2023 at 11:19:35AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This function is really implementing two policies. The first is
> trying to create contiguous extents at file extension. Failing that,
> it attempts to perform aligned allocation. These are really two
> separate policies, and it is further complicated by filestream
> allocation having different aligned allocation constraints than
> the normal bmap allocation.
> 
> Split xfs_bmap_btalloc_at_eof() into two parts so we can start to
> align the two different allocator policies more closely.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 147 +++++++++++++++++++++------------------
>  1 file changed, 80 insertions(+), 67 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 30c931b38853..e14671414afb 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3451,81 +3451,81 @@ xfs_bmap_exact_minlen_extent_alloc(
>  
>  #endif
>  
> -/*
> - * If we are not low on available data blocks and we are allocating at
> - * EOF, optimise allocation for contiguous file extension and/or stripe
> - * alignment of the new extent.
> - *
> - * NOTE: ap->aeof is only set if the allocation length is >= the
> - * stripe unit and the allocation offset is at the end of file.
> - */
> + /*
> + * Attempt contiguous allocation for file extension.
> +  */
> + static int
> + xfs_bmap_btalloc_at_eof(
> +	struct xfs_bmalloca	*ap,
> +	struct xfs_alloc_arg	*args,
> +	xfs_extlen_t		blen,
> +	int			stripe_align)
> +{
> +	struct xfs_mount	*mp = args->mp;
> +	struct xfs_perag        *caller_pag = args->pag;
> +	xfs_extlen_t		nextminlen = 0;
> +	int			error;
> +
> +	/*
> +	 * Compute the minlen+alignment for the next case.  Set slop so
> +	 * that the value of minlen+alignment+slop doesn't go up between
> +	 * the calls.
> +	 */
> +	args->alignment = 1;
> +	if (blen > stripe_align && blen <= args->maxlen)
> +		nextminlen = blen - stripe_align;
> +	else
> +		nextminlen = args->minlen;
> +	if (nextminlen + stripe_align > args->minlen + 1)
> +		args->minalignslop = nextminlen + stripe_align -
> +				args->minlen - 1;
> +	else
> +		args->minalignslop = 0;
> +
> +	if (!caller_pag)
> +		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
> +	error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
> +	if (!caller_pag) {
> +		xfs_perag_put(args->pag);
> +		args->pag = NULL;

Splitting these two if cases into two less ambitious functions makes it
easier for me to regrok what this code was doing.  Thank you,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	}
> +	if (error)
> +		return error;
> +
> +	if (args->fsbno != NULLFSBLOCK)
> +		return 0;
> +	/*
> +	 * Exact allocation failed. Reset to try an aligned allocation
> +	 * according to the original allocation specification.
> +	 */
> +	args->minlen = nextminlen;
> +	return 0;
> +}
> +
>  static int
> -xfs_bmap_btalloc_at_eof(
> +xfs_bmap_btalloc_aligned(
>  	struct xfs_bmalloca	*ap,
>  	struct xfs_alloc_arg	*args,
>  	xfs_extlen_t		blen,
>  	int			stripe_align,
>  	bool			ag_only)
>  {
> -	struct xfs_mount	*mp = args->mp;
> -	struct xfs_perag	*caller_pag = args->pag;
> +	struct xfs_perag        *caller_pag = args->pag;
>  	int			error;
>  
>  	/*
> -	 * If there are already extents in the file, try an exact EOF block
> -	 * allocation to extend the file as a contiguous extent. If that fails,
> -	 * or it's the first allocation in a file, just try for a stripe aligned
> -	 * allocation.
> +	 * If we failed an exact EOF allocation already, stripe
> +	 * alignment will have already been taken into account in
> +	 * args->minlen. Hence we only adjust minlen to try to preserve
> +	 * alignment if no slop has been reserved for alignment
>  	 */
> -	if (ap->offset) {
> -		xfs_extlen_t	nextminlen = 0;
> -
> -		/*
> -		 * Compute the minlen+alignment for the next case.  Set slop so
> -		 * that the value of minlen+alignment+slop doesn't go up between
> -		 * the calls.
> -		 */
> -		args->alignment = 1;
> -		if (blen > stripe_align && blen <= args->maxlen)
> -			nextminlen = blen - stripe_align;
> -		else
> -			nextminlen = args->minlen;
> -		if (nextminlen + stripe_align > args->minlen + 1)
> -			args->minalignslop = nextminlen + stripe_align -
> -					args->minlen - 1;
> -		else
> -			args->minalignslop = 0;
> -
> -		if (!caller_pag)
> -			args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
> -		error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
> -		if (!caller_pag) {
> -			xfs_perag_put(args->pag);
> -			args->pag = NULL;
> -		}
> -		if (error)
> -			return error;
> -
> -		if (args->fsbno != NULLFSBLOCK)
> -			return 0;
> -		/*
> -		 * Exact allocation failed. Reset to try an aligned allocation
> -		 * according to the original allocation specification.
> -		 */
> -		args->alignment = stripe_align;
> -		args->minlen = nextminlen;
> -		args->minalignslop = 0;
> -	} else {
> -		/*
> -		 * Adjust minlen to try and preserve alignment if we
> -		 * can't guarantee an aligned maxlen extent.
> -		 */
> -		args->alignment = stripe_align;
> -		if (blen > args->alignment &&
> -		    blen <= args->maxlen + args->alignment)
> -			args->minlen = blen - args->alignment;
> -		args->minalignslop = 0;
> +	if (args->minalignslop == 0) {
> +		if (blen > stripe_align &&
> +		    blen <= args->maxlen + stripe_align)
> +			args->minlen = blen - stripe_align;
>  	}
> +	args->alignment = stripe_align;
> +	args->minalignslop = 0;
>  
>  	if (ag_only) {
>  		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
> @@ -3612,8 +3612,14 @@ xfs_bmap_btalloc_filestreams(
>  	}
>  
>  	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
> +	if (ap->aeof && ap->offset)
> +		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
> +
> +	if (error || args->fsbno != NULLFSBLOCK)
> +		goto out_low_space;
> +
>  	if (ap->aeof)
> -		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
> +		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
>  				true);
>  
>  	if (!error && args->fsbno == NULLFSBLOCK)
> @@ -3662,13 +3668,20 @@ xfs_bmap_btalloc_best_length(
>  	 * optimal or even aligned allocations in this case, so don't waste time
>  	 * trying.
>  	 */
> -	if (ap->aeof && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
> -		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
> -				false);
> +	if (ap->aeof && ap->offset && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
> +		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
>  		if (error || args->fsbno != NULLFSBLOCK)
>  			return error;
>  	}
>  
> +	/* attempt aligned allocation for new EOF extents */
> +	if (ap->aeof)
> +		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
> +				false);
> +	if (error || args->fsbno != NULLFSBLOCK)
> +		return error;
> +
> +	/* attempt unaligned allocation */
>  	error = xfs_alloc_vextent_start_ag(args, ap->blkno);
>  	if (error || args->fsbno != NULLFSBLOCK)
>  		return error;
> -- 
> 2.40.1
> 
