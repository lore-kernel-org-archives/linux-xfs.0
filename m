Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D1FC636D4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 22:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjBAWwY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 17:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjBAWwX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 17:52:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFB959E5B
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 14:52:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 912656195A
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 22:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF086C433D2;
        Wed,  1 Feb 2023 22:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675291940;
        bh=Yw4zWNCSkbB6EVbMyfmXQBh00lk4s6QGhDthDy44XZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AawjjC1g1xJmpgupm1fRn6LGXCzedZ/zOK+zr9qvLabV8kCr6j0F0Nr14UFyGTcLD
         IJMj3gDQO8eWkqfyMGxYaZIdcbq+qS4WEMpfHeaExo51550i5dEjpJjZQv/zYe1gC+
         2NOtHDzm38R1mGnX0oGG1uWHbjGt1ttgr96wOKqAX9IzW3S6xR7eANA1ZY21CDL5Yx
         sZk8d1H60cm68xoXR7QKIzQiaJ0S4ABWiDsCNicD5oWC2PKVU3ZAevfhizNHVfdYlD
         mPo5IrWXjNh2QP/A9iHpji8wCTyeWMmmr9TBOveQjDUlg8P+mrLbsMPC+k9H8Djqql
         YLjWsseitfGyA==
Date:   Wed, 1 Feb 2023 14:52:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/42] xfs: introduce xfs_alloc_vextent_near_bno()
Message-ID: <Y9rtI9LNEyJobU1K@magnolia>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-23-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118224505.1964941-23-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 09:44:45AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The remaining callers of xfs_alloc_vextent() are all doing NEAR_BNO
> allocations. We can replace that function with a new
> xfs_alloc_vextent_near_bno() function that does this explicitly.
> 
> We also multiplex NEAR_BNO allocations through
> xfs_alloc_vextent_this_ag via args->type. Replace all of these with
> direct calls to xfs_alloc_vextent_near_bno(), too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          | 50 ++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_alloc.h          | 14 ++++-----
>  fs/xfs/libxfs/xfs_bmap.c           |  6 ++--
>  fs/xfs/libxfs/xfs_ialloc.c         | 27 ++++++----------
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |  5 ++-
>  fs/xfs/libxfs/xfs_refcount_btree.c |  7 ++---
>  6 files changed, 55 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 294f80d596d9..485a73eab9d9 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3479,35 +3479,47 @@ int
>  }
>  
>  /*
> - * Allocate an extent (variable-size).
> - * Depending on the allocation type, we either look in a single allocation
> - * group or loop over the allocation groups to find the result.
> + * Allocate an extent as close to the target as possible. If there are not
> + * viable candidates in the AG, then fail the allocation.
>   */
>  int
> -xfs_alloc_vextent(
> -	struct xfs_alloc_arg	*args)
> +xfs_alloc_vextent_near_bno(
> +	struct xfs_alloc_arg	*args,
> +	xfs_rfsblock_t		target)

xfs_rfsblock_t vs. xfs_fsblock_t here too...

--D

>  {
> +	struct xfs_mount	*mp = args->mp;
> +	bool			need_pag = !args->pag;
>  	xfs_agnumber_t		minimum_agno = 0;
>  	int			error;
>  
>  	if (args->tp->t_highest_agno != NULLAGNUMBER)
>  		minimum_agno = args->tp->t_highest_agno;
>  
> -	switch (args->type) {
> -	case XFS_ALLOCTYPE_THIS_AG:
> -	case XFS_ALLOCTYPE_NEAR_BNO:
> -	case XFS_ALLOCTYPE_THIS_BNO:
> -		args->pag = xfs_perag_get(args->mp,
> -				XFS_FSB_TO_AGNO(args->mp, args->fsbno));
> -		error = xfs_alloc_vextent_this_ag(args);
> -		xfs_perag_put(args->pag);
> -		break;
> -	default:
> -		error = -EFSCORRUPTED;
> -		ASSERT(0);
> -		break;
> +	error = xfs_alloc_vextent_check_args(args, target);
> +	if (error) {
> +		if (error == -ENOSPC)
> +			return 0;
> +		return error;
>  	}
> -	return error;
> +
> +	args->agno = XFS_FSB_TO_AGNO(mp, target);
> +	if (minimum_agno > args->agno) {
> +		trace_xfs_alloc_vextent_skip_deadlock(args);
> +		return 0;
> +	}
> +
> +	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
> +	args->type = XFS_ALLOCTYPE_NEAR_BNO;
> +	if (need_pag)
> +		args->pag = xfs_perag_get(args->mp, args->agno);
> +	error = xfs_alloc_ag_vextent(args);
> +	if (need_pag)
> +		xfs_perag_put(args->pag);
> +	if (error)
> +		return error;
> +
> +	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
> +	return 0;
>  }
>  
>  /* Ensure that the freelist is at full capacity. */
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 5487dff3d68a..f38a2f8e20fb 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -113,19 +113,19 @@ xfs_alloc_log_agf(
>  	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
>  	uint32_t	fields);/* mask of fields to be logged (XFS_AGF_...) */
>  
> -/*
> - * Allocate an extent (variable-size).
> - */
> -int				/* error */
> -xfs_alloc_vextent(
> -	xfs_alloc_arg_t	*args);	/* allocation argument structure */
> -
>  /*
>   * Allocate an extent in the specific AG defined by args->fsbno. If there is no
>   * space in that AG, then the allocation will fail.
>   */
>  int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
>  
> +/*
> + * Allocate an extent as close to the target as possible. If there are not
> + * viable candidates in the AG, then fail the allocation.
> + */
> +int xfs_alloc_vextent_near_bno(struct xfs_alloc_arg *args,
> +		xfs_rfsblock_t target);
> +
>  /*
>   * Best effort full filesystem allocation scan.
>   *
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index aefcdf2bfd57..4446b035eed5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3246,7 +3246,6 @@ xfs_bmap_btalloc_filestreams(
>  	int			notinit = 0;
>  	int			error;
>  
> -	args->type = XFS_ALLOCTYPE_NEAR_BNO;
>  	args->total = ap->total;
>  
>  	start_agno = XFS_FSB_TO_AGNO(mp, ap->blkno);
> @@ -3565,7 +3564,7 @@ xfs_bmap_btalloc_at_eof(
>  	}
>  
>  	if (ag_only)
> -		error = xfs_alloc_vextent(args);
> +		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
>  	else
>  		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
>  	if (error)
> @@ -3612,7 +3611,6 @@ xfs_bmap_btalloc_best_length(
>  		ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
>  	}
>  	xfs_bmap_adjacent(ap);
> -	args->fsbno = ap->blkno;
>  
>  	/*
>  	 * Search for an allocation group with a single extent large enough for
> @@ -3653,7 +3651,7 @@ xfs_bmap_btalloc_best_length(
>  	}
>  
>  	if (is_filestream)
> -		error = xfs_alloc_vextent(args);
> +		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
>  	else
>  		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
>  	if (error)
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 2f3e47cb9332..daa6f7055bba 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -717,23 +717,17 @@ xfs_ialloc_ag_alloc(
>  			isaligned = 1;
>  		} else
>  			args.alignment = igeo->cluster_align;
> -		/*
> -		 * Need to figure out where to allocate the inode blocks.
> -		 * Ideally they should be spaced out through the a.g.
> -		 * For now, just allocate blocks up front.
> -		 */
> -		args.agbno = be32_to_cpu(agi->agi_root);
> -		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
>  		/*
>  		 * Allocate a fixed-size extent of inodes.
>  		 */
> -		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>  		args.prod = 1;
>  		/*
>  		 * Allow space for the inode btree to split.
>  		 */
>  		args.minleft = igeo->inobt_maxlevels;
> -		error = xfs_alloc_vextent_this_ag(&args);
> +		error = xfs_alloc_vextent_near_bno(&args,
> +				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
> +						be32_to_cpu(agi->agi_root)));
>  		if (error)
>  			return error;
>  	}
> @@ -743,11 +737,11 @@ xfs_ialloc_ag_alloc(
>  	 * alignment.
>  	 */
>  	if (isaligned && args.fsbno == NULLFSBLOCK) {
> -		args.type = XFS_ALLOCTYPE_NEAR_BNO;
> -		args.agbno = be32_to_cpu(agi->agi_root);
> -		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
>  		args.alignment = igeo->cluster_align;
> -		if ((error = xfs_alloc_vextent(&args)))
> +		error = xfs_alloc_vextent_near_bno(&args,
> +				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
> +						be32_to_cpu(agi->agi_root)));
> +		if (error)
>  			return error;
>  	}
>  
> @@ -759,9 +753,6 @@ xfs_ialloc_ag_alloc(
>  	    igeo->ialloc_min_blks < igeo->ialloc_blks &&
>  	    args.fsbno == NULLFSBLOCK) {
>  sparse_alloc:
> -		args.type = XFS_ALLOCTYPE_NEAR_BNO;
> -		args.agbno = be32_to_cpu(agi->agi_root);
> -		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
>  		args.alignment = args.mp->m_sb.sb_spino_align;
>  		args.prod = 1;
>  
> @@ -783,7 +774,9 @@ xfs_ialloc_ag_alloc(
>  					    args.mp->m_sb.sb_inoalignmt) -
>  				 igeo->ialloc_blks;
>  
> -		error = xfs_alloc_vextent_this_ag(&args);
> +		error = xfs_alloc_vextent_near_bno(&args,
> +				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
> +						be32_to_cpu(agi->agi_root)));
>  		if (error)
>  			return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index fa6cd2502970..9b28211d5a4c 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -105,14 +105,13 @@ __xfs_inobt_alloc_block(
>  	args.mp = cur->bc_mp;
>  	args.pag = cur->bc_ag.pag;
>  	args.oinfo = XFS_RMAP_OINFO_INOBT;
> -	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.pag->pag_agno, sbno);
>  	args.minlen = 1;
>  	args.maxlen = 1;
>  	args.prod = 1;
> -	args.type = XFS_ALLOCTYPE_NEAR_BNO;
>  	args.resv = resv;
>  
> -	error = xfs_alloc_vextent_this_ag(&args);
> +	error = xfs_alloc_vextent_near_bno(&args,
> +			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno, sbno));
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index a980fb18bde2..f3b860970b26 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -68,14 +68,13 @@ xfs_refcountbt_alloc_block(
>  	args.tp = cur->bc_tp;
>  	args.mp = cur->bc_mp;
>  	args.pag = cur->bc_ag.pag;
> -	args.type = XFS_ALLOCTYPE_NEAR_BNO;
> -	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
> -			xfs_refc_block(args.mp));
>  	args.oinfo = XFS_RMAP_OINFO_REFC;
>  	args.minlen = args.maxlen = args.prod = 1;
>  	args.resv = XFS_AG_RESV_METADATA;
>  
> -	error = xfs_alloc_vextent_this_ag(&args);
> +	error = xfs_alloc_vextent_near_bno(&args,
> +			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno,
> +					xfs_refc_block(args.mp)));
>  	if (error)
>  		goto out_error;
>  	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
> -- 
> 2.39.0
> 
