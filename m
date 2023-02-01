Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31ACC05027
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 22:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBAWZl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 17:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBAWZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 17:25:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF836303C1
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 14:25:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCE4D6183C
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 22:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF52C433D2;
        Wed,  1 Feb 2023 22:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675290333;
        bh=Nuux9iy4Q0CvoaiyU8Bqv+TjB4Q93DF9sbnLYj+qtIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dx8+OkA9bzkKjH7uAs+YZECKSUvHUCcaVvRlUTdOC8Fju7AqTQGw3UsGjLt7iZw4v
         d7+bk9Ghwc0WiEc71xLwSlu94NqbATnIOg9F/o3PKbUlQ4iwiBzkmtISXy/fERRRzS
         lMDx3oa9wZgM4S1XnUWecSzODilaoPlKgc4hp6JVdJ7bgLDrvIHx9P8HGbp2b773lU
         yfHEBRhmlhaK6UsMBbldJjZTPhfIHaJdLPlVzkByzwkRjPIA7PnQWQGyWd/RWZiwgK
         dnR7YYB+iyJwLrdc5hXIVKOQsl+PBeeHu4BaLK91iFTPVlL2xRT3i+kGLGMJITiJvk
         /QF6Hhv48AazQ==
Date:   Wed, 1 Feb 2023 14:25:32 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/42] xfs: combine __xfs_alloc_vextent_this_ag and
  xfs_alloc_ag_vextent
Message-ID: <Y9rm3K72WcTu2I/D@magnolia>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-18-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118224505.1964941-18-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 09:44:40AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There's a bit of a recursive conundrum around
> xfs_alloc_ag_vextent(). We can't first call xfs_alloc_ag_vextent()
> without preparing the AGFL for the allocation, and preparing the
> AGFL calls xfs_alloc_ag_vextent() to prepare the AGFL for the
> allocation. This "double allocation" requirement is not really clear
> from the current xfs_alloc_fix_freelist() calls that are sprinkled
> through the allocation code.
> 
> It's not helped that xfs_alloc_ag_vextent() can actually allocate
> from the AGFL itself, but there's special code to prevent AGFL prep
> allocations from allocating from the free list it's trying to prep.
> The naming is also not consistent: args->wasfromfl is true when we
> allocated _from_ the free list, but the indication that we are
> allocating _for_ the free list is via checking that (args->resv ==
> XFS_AG_RESV_AGFL).
> 
> So, lets make this "allocation required for allocation" situation
> clear by moving it all inside xfs_alloc_ag_vextent(). The freelist
> allocation is a specific XFS_ALLOCTYPE_THIS_AG allocation, which
> translated directly to xfs_alloc_ag_vextent_size() allocation.
> 
> This enables us to replace __xfs_alloc_vextent_this_ag() with a call
> to xfs_alloc_ag_vextent(), and we drive the freelist fixing further
> into the per-ag allocation algorithm.

Hmm.  My first reaction to all this was "why do I care about all this
slicing and dicing?" and "uugh what confuusing".  Then I skipped to the
end of the book and observed that the end goal seems to be the
elimination of:

	args.type = XFS_ALLOC_TYPE_START_AG;
	args.fsbno = sometarget;
	/* fill out other fields mysteriously */

by turning them all into explicit functions!

	error = xfs_alloc_vextent_start_ag(&args, sometarget);

So I looked at all the replacements and noticed that it's quite a bit
easier to understand what each variant on allocation does.

It took me a minute to realize that the additional call to
xfs_rmap_should_skip_owner_update is because _alloc_fix_freelist doesn't
call what becomes the _vextent_finish function.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 65 +++++++++++++++++++++------------------
>  1 file changed, 35 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 2dec95f35562..011baace7e9d 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1140,22 +1140,38 @@ xfs_alloc_ag_vextent_small(
>   * and of the form k * prod + mod unless there's nothing that large.
>   * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
>   */
> -STATIC int			/* error */
> +static int
>  xfs_alloc_ag_vextent(
> -	xfs_alloc_arg_t	*args)	/* argument structure for allocation */
> +	struct xfs_alloc_arg	*args)
>  {
> -	int		error=0;
> +	struct xfs_mount	*mp = args->mp;
> +	int			error = 0;
>  
>  	ASSERT(args->minlen > 0);
>  	ASSERT(args->maxlen > 0);
>  	ASSERT(args->minlen <= args->maxlen);
>  	ASSERT(args->mod < args->prod);
>  	ASSERT(args->alignment > 0);
> +	ASSERT(args->resv != XFS_AG_RESV_AGFL);
> +
> +
> +	error = xfs_alloc_fix_freelist(args, 0);
> +	if (error) {
> +		trace_xfs_alloc_vextent_nofix(args);
> +		return error;
> +	}
> +	if (!args->agbp) {
> +		/* cannot allocate in this AG at all */
> +		trace_xfs_alloc_vextent_noagbp(args);
> +		args->agbno = NULLAGBLOCK;
> +		return 0;
> +	}
> +	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
> +	args->wasfromfl = 0;
>  
>  	/*
>  	 * Branch to correct routine based on the type.
>  	 */
> -	args->wasfromfl = 0;
>  	switch (args->type) {
>  	case XFS_ALLOCTYPE_THIS_AG:
>  		error = xfs_alloc_ag_vextent_size(args);
> @@ -1176,7 +1192,6 @@ xfs_alloc_ag_vextent(
>  
>  	ASSERT(args->len >= args->minlen);
>  	ASSERT(args->len <= args->maxlen);
> -	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_AGFL);
>  	ASSERT(args->agbno % args->alignment == 0);
>  
>  	/* if not file data, insert new block into the reverse map btree */
> @@ -2721,7 +2736,7 @@ xfs_alloc_fix_freelist(
>  		targs.resv = XFS_AG_RESV_AGFL;
>  
>  		/* Allocate as many blocks as possible at once. */
> -		error = xfs_alloc_ag_vextent(&targs);
> +		error = xfs_alloc_ag_vextent_size(&targs);
>  		if (error)
>  			goto out_agflbp_relse;
>  
> @@ -2735,6 +2750,18 @@ xfs_alloc_fix_freelist(
>  				break;
>  			goto out_agflbp_relse;
>  		}
> +
> +		if (!xfs_rmap_should_skip_owner_update(&targs.oinfo)) {
> +			error = xfs_rmap_alloc(tp, agbp, pag,
> +				       targs.agbno, targs.len, &targs.oinfo);
> +			if (error)
> +				goto out_agflbp_relse;
> +		}
> +		error = xfs_alloc_update_counters(tp, agbp,
> +						  -((long)(targs.len)));
> +		if (error)
> +			goto out_agflbp_relse;
> +
>  		/*
>  		 * Put each allocated block on the list.
>  		 */
> @@ -3244,28 +3271,6 @@ xfs_alloc_vextent_set_fsbno(
>  /*
>   * Allocate within a single AG only.
>   */
> -static int
> -__xfs_alloc_vextent_this_ag(
> -	struct xfs_alloc_arg	*args)
> -{
> -	struct xfs_mount	*mp = args->mp;
> -	int			error;
> -
> -	error = xfs_alloc_fix_freelist(args, 0);
> -	if (error) {
> -		trace_xfs_alloc_vextent_nofix(args);
> -		return error;
> -	}
> -	if (!args->agbp) {
> -		/* cannot allocate in this AG at all */
> -		trace_xfs_alloc_vextent_noagbp(args);
> -		args->agbno = NULLAGBLOCK;
> -		return 0;
> -	}
> -	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
> -	return xfs_alloc_ag_vextent(args);
> -}
> -
>  static int
>  xfs_alloc_vextent_this_ag(
>  	struct xfs_alloc_arg	*args,
> @@ -3289,7 +3294,7 @@ xfs_alloc_vextent_this_ag(
>  	}
>  
>  	args->pag = xfs_perag_get(mp, args->agno);
> -	error = __xfs_alloc_vextent_this_ag(args);
> +	error = xfs_alloc_ag_vextent(args);
>  
>  	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
>  	xfs_perag_put(args->pag);
> @@ -3329,7 +3334,7 @@ xfs_alloc_vextent_iterate_ags(
>  	args->agno = start_agno;
>  	for (;;) {
>  		args->pag = xfs_perag_get(mp, args->agno);
> -		error = __xfs_alloc_vextent_this_ag(args);
> +		error = xfs_alloc_ag_vextent(args);
>  		if (error) {
>  			args->agbno = NULLAGBLOCK;
>  			break;
> -- 
> 2.39.0
> 
