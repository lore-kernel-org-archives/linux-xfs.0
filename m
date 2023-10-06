Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031B9E92FE7
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 05:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjJFFzJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 01:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjJFFzJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 01:55:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF616BF
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 22:55:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558A3C433C7;
        Fri,  6 Oct 2023 05:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696571707;
        bh=iDvVPjoALKcM02j36kxYwWpTPgOcKC58vEIHmdImRnE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gkk3KiF3qtaih55CIv6EDE+AYcTyjJYZQB9Yd/xB7wI4O2Uje1LwJwf51hO0qyMjD
         bhZxZXK6cNUGQ8vkGoSq1OjvSdtfAi9riRgSrCsCAumL21bazeL16OcvqrGYht/oBG
         9kk9R1DbOBOf9zRxsfxtvBxRVReY9RHX9aXrG6i04QaBhJusXKdxKiERfB36xORrLj
         vd6bXfmmGStWXRgXlXOWXtDx7wnOOSTvKgX/WH1YV1rl1U6Jcy292DPF9M5GpZC50E
         FgGIVr+5STR9D5016bJ7uBeAcyGLnDTnw2oqQYpegMYUREHL/prdzm+3E8KPUjE/65
         K9KVC62qjpxpw==
Date:   Thu, 5 Oct 2023 22:55:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 5/9] xfs: aligned EOF allocations don't need to scan AGs
 anymore
Message-ID: <20231006055506.GU21298@frogsfrogsfrogs>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2023 at 11:19:39AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that contiguous free space selection takes into account stripe
> alignment, we no longer need to do an "all AGs" allocation scan in
> the case the initial AG doesn't have enough contiguous free space
> for a stripe aligned allocation. This cleans up
> xfs_bmap_btalloc_aligned() the same for both filestreams and the
> normal btree allocation code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 40 +++++++++++++---------------------------
>  1 file changed, 13 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 3c250c89f42e..c1e2c0707e20 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3538,10 +3538,8 @@ xfs_bmap_btalloc_aligned(
>  	struct xfs_bmalloca	*ap,
>  	struct xfs_alloc_arg	*args,
>  	xfs_extlen_t		blen,
> -	int			stripe_align,
> -	bool			ag_only)
> +	int			stripe_align)
>  {
> -	struct xfs_perag        *caller_pag = args->pag;
>  	int			error;
>  
>  	/*
> @@ -3558,14 +3556,7 @@ xfs_bmap_btalloc_aligned(
>  	args->alignment = stripe_align;
>  	args->minalignslop = 0;
>  
> -	if (ag_only) {
> -		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
> -	} else {
> -		args->pag = NULL;
> -		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
> -		ASSERT(args->pag == NULL);
> -		args->pag = caller_pag;
> -	}
> +	error = xfs_alloc_vextent_near_bno(args, ap->blkno);
>  	if (error)
>  		return error;
>  
> @@ -3650,8 +3641,7 @@ xfs_bmap_btalloc_filestreams(
>  		goto out_low_space;
>  
>  	if (ap->aeof)
> -		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
> -				true);
> +		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align);
>  
>  	if (!error && args->fsbno == NULLFSBLOCK)
>  		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
> @@ -3715,9 +3705,16 @@ xfs_bmap_btalloc_best_length(
>  		return error;
>  	ASSERT(args->pag);
>  
> -	if (ap->aeof && ap->offset) {
> +	if (ap->aeof && ap->offset)
>  		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
> -	}
> +
> +	if (error || args->fsbno != NULLFSBLOCK)
> +		goto out_perag_rele;
> +
> +

Double blank lines here.  With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

I like the simplifications going on here.

--D


> +	/* attempt aligned allocation for new EOF extents */
> +	if (stripe_align)
> +		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align);
>  
>  	/*
>  	 * We are now done with the perag reference for the optimal allocation
> @@ -3725,24 +3722,13 @@ xfs_bmap_btalloc_best_length(
>  	 * now as we've either succeeded, had a fatal error or we are out of
>  	 * space and need to do a full filesystem scan for free space which will
>  	 * take it's own references.
> -	 *
> -	 * XXX: now that xfs_bmap_btalloc_select_lengths() selects an AG with
> -	 * enough contiguous free space in it for an aligned allocation, we
> -	 * can change the aligned allocation at EOF to just be a single AG
> -	 * allocation.
>  	 */
> +out_perag_rele:
>  	xfs_perag_rele(args->pag);
>  	args->pag = NULL;
>  	if (error || args->fsbno != NULLFSBLOCK)
>  		return error;
>  
> -	/* attempt aligned allocation for new EOF extents */
> -	if (stripe_align)
> -		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
> -				false);
> -	if (error || args->fsbno != NULLFSBLOCK)
> -		return error;
> -
>  	/* attempt unaligned allocation */
>  	error = xfs_alloc_vextent_start_ag(args, ap->blkno);
>  	if (error || args->fsbno != NULLFSBLOCK)
> -- 
> 2.40.1
> 
