Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F108C38142
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 19:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjBATjV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 14:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjBATjU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 14:39:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3985326856
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 11:39:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAC31B8228F
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 19:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFD6C433D2;
        Wed,  1 Feb 2023 19:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675280355;
        bh=Uhe2jTIJ+zLzOmFBIERj0qcNCajOG+BHJiLbAItCGR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hvW9IBMHcqUPnLjWEd4gqtOI0MjB3+Go5kirI6y2gyi4y6iymU7TxP9nNALUcGGND
         KxbR8A9ipxAdSLkBL43K8N2nWlLqPAVHuBnqdjpxLocJOCidqYdQF99jcL4y7qkDgr
         5Hzc0OhFo37392CUXGaFhKdZvSiMP8c8VSpC9yQiEOtkyfKlL+xJ8qQGsguAeBXXOa
         s+sqXjiNInYFT7DVrpKhbRp7lRsxITAIa5zYrYEZ1ztngghv2JIf+xeKUZxpFIciKP
         ZIeSqtKcih/MevO1OV7wz5WJfcWgHuq858x7dRa4XbH1DMc0YoZNMXTfbfj7qCoIrx
         U9svRwEoUME7A==
Date:   Wed, 1 Feb 2023 11:39:14 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/42] xfs: rework xfs_alloc_vextent()
Message-ID: <Y9q/4klRODNoHAtb@magnolia>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-16-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118224505.1964941-16-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 09:44:38AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's a multiplexing mess that can be greatly simplified, and really
> needs to be simplified to allow active per-ag references to
> propagate from initial AG selection code the the bmapi code.
> 
> This splits the code out into separate a parameter checking
> function, an iterator function, and allocation completion functions
> and then implements the individual policies using these functions.

This patch was **so** much easier to read once I imported it and
re-exported it with git set to patience diff mode.  With that in hand
it's far easier to see that the diff really does break up an overlong
function and nothing else.

$ cat /etc/gitconfig
[diff]
        algorithm = patience

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 464 +++++++++++++++++++++++---------------
>  1 file changed, 285 insertions(+), 179 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 246c2e7d9e7a..39e34a1bfa31 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3151,29 +3151,20 @@ xfs_alloc_read_agf(
>  }
>  
>  /*
> - * Allocate an extent (variable-size).
> - * Depending on the allocation type, we either look in a single allocation
> - * group or loop over the allocation groups to find the result.
> + * Pre-proces allocation arguments to set initial state that we don't require
> + * callers to set up correctly, as well as bounds check the allocation args
> + * that are set up.
>   */
> -int				/* error */
> -xfs_alloc_vextent(
> -	struct xfs_alloc_arg	*args)	/* allocation argument structure */
> +static int
> +xfs_alloc_vextent_check_args(
> +	struct xfs_alloc_arg	*args)
>  {
> -	xfs_agblock_t		agsize;	/* allocation group size */
> -	int			error;
> -	int			flags;	/* XFS_ALLOC_FLAG_... locking flags */
> -	struct xfs_mount	*mp;	/* mount structure pointer */
> -	xfs_agnumber_t		sagno;	/* starting allocation group number */
> -	xfs_alloctype_t		type;	/* input allocation type */
> -	int			bump_rotor = 0;
> -	xfs_agnumber_t		rotorstep = xfs_rotorstep; /* inode32 agf stepper */
> -	xfs_agnumber_t		minimum_agno = 0;
> +	struct xfs_mount	*mp = args->mp;
> +	xfs_agblock_t		agsize;
>  
> -	mp = args->mp;
> -	type = args->otype = args->type;
> +	args->otype = args->type;
>  	args->agbno = NULLAGBLOCK;
> -	if (args->tp->t_highest_agno != NULLAGNUMBER)
> -		minimum_agno = args->tp->t_highest_agno;
> +
>  	/*
>  	 * Just fix this up, for the case where the last a.g. is shorter
>  	 * (or there's only one a.g.) and the caller couldn't easily figure
> @@ -3195,199 +3186,314 @@ xfs_alloc_vextent(
>  	    args->mod >= args->prod) {
>  		args->fsbno = NULLFSBLOCK;
>  		trace_xfs_alloc_vextent_badargs(args);
> +		return -ENOSPC;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Post-process allocation results to set the allocated block number correctly
> + * for the caller.
> + *
> + * XXX: xfs_alloc_vextent() should really be returning ENOSPC for ENOSPC, not
> + * hiding it behind a "successful" NULLFSBLOCK allocation.
> + */
> +static void
> +xfs_alloc_vextent_set_fsbno(
> +	struct xfs_alloc_arg	*args,
> +	xfs_agnumber_t		minimum_agno)
> +{
> +	struct xfs_mount	*mp = args->mp;
> +
> +	/*
> +	 * We can end up here with a locked AGF. If we failed, the caller is
> +	 * likely going to try to allocate again with different parameters, and
> +	 * that can widen the AGs that are searched for free space. If we have
> +	 * to do BMBT block allocation, we have to do a new allocation.
> +	 *
> +	 * Hence leaving this function with the AGF locked opens up potential
> +	 * ABBA AGF deadlocks because a future allocation attempt in this
> +	 * transaction may attempt to lock a lower number AGF.
> +	 *
> +	 * We can't release the AGF until the transaction is commited, so at
> +	 * this point we must update the "first allocation" tracker to point at
> +	 * this AG if the tracker is empty or points to a lower AG. This allows
> +	 * the next allocation attempt to be modified appropriately to avoid
> +	 * deadlocks.
> +	 */
> +	if (args->agbp &&
> +	    (args->tp->t_highest_agno == NULLAGNUMBER ||
> +	     args->agno > minimum_agno))
> +		args->tp->t_highest_agno = args->agno;
> +
> +	/* Allocation failed with ENOSPC if NULLAGBLOCK was returned. */
> +	if (args->agbno == NULLAGBLOCK) {
> +		args->fsbno = NULLFSBLOCK;
> +		return;
> +	}
> +
> +	args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
> +#ifdef DEBUG
> +	ASSERT(args->len >= args->minlen);
> +	ASSERT(args->len <= args->maxlen);
> +	ASSERT(args->agbno % args->alignment == 0);
> +	XFS_AG_CHECK_DADDR(mp, XFS_FSB_TO_DADDR(mp, args->fsbno), args->len);
> +#endif
> +}
> +
> +/*
> + * Allocate within a single AG only.
> + */
> +static int
> +xfs_alloc_vextent_this_ag(
> +	struct xfs_alloc_arg	*args,
> +	xfs_agnumber_t		minimum_agno)
> +{
> +	struct xfs_mount	*mp = args->mp;
> +	int			error;
> +
> +	error = xfs_alloc_vextent_check_args(args);
> +	if (error) {
> +		if (error == -ENOSPC)
> +			return 0;
> +		return error;
> +	}
> +
> +	args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
> +	if (minimum_agno > args->agno) {
> +		trace_xfs_alloc_vextent_skip_deadlock(args);
> +		args->fsbno = NULLFSBLOCK;
>  		return 0;
>  	}
>  
> -	switch (type) {
> -	case XFS_ALLOCTYPE_THIS_AG:
> -	case XFS_ALLOCTYPE_NEAR_BNO:
> -	case XFS_ALLOCTYPE_THIS_BNO:
> -		/*
> -		 * These three force us into a single a.g.
> -		 */
> -		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
> -		args->pag = xfs_perag_get(mp, args->agno);
> +	args->pag = xfs_perag_get(mp, args->agno);
> +	error = xfs_alloc_fix_freelist(args, 0);
> +	if (error) {
> +		trace_xfs_alloc_vextent_nofix(args);
> +		goto out_error;
> +	}
> +	if (!args->agbp) {
> +		trace_xfs_alloc_vextent_noagbp(args);
> +		args->fsbno = NULLFSBLOCK;
> +		goto out_error;
> +	}
> +	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
> +	error = xfs_alloc_ag_vextent(args);
>  
> -		if (minimum_agno > args->agno) {
> -			trace_xfs_alloc_vextent_skip_deadlock(args);
> -			error = 0;
> -			break;
> -		}
> +	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
> +out_error:
> +	xfs_perag_put(args->pag);
> +	return error;
> +}
> +
> +/*
> + * Iterate all AGs trying to allocate an extent starting from @start_ag.
> + *
> + * If the incoming allocation type is XFS_ALLOCTYPE_NEAR_BNO, it means the
> + * allocation attempts in @start_agno have locality information. If we fail to
> + * allocate in that AG, then we revert to anywhere-in-AG for all the other AGs
> + * we attempt to allocation in as there is no locality optimisation possible for
> + * those allocations.
> + *
> + * When we wrap the AG iteration at the end of the filesystem, we have to be
> + * careful not to wrap into AGs below ones we already have locked in the
> + * transaction if we are doing a blocking iteration. This will result in an
> + * out-of-order locking of AGFs and hence can cause deadlocks.
> + */
> +static int
> +xfs_alloc_vextent_iterate_ags(
> +	struct xfs_alloc_arg	*args,
> +	xfs_agnumber_t		minimum_agno,
> +	xfs_agnumber_t		start_agno,
> +	uint32_t		flags)
> +{
> +	struct xfs_mount	*mp = args->mp;
> +	int			error = 0;
>  
> -		error = xfs_alloc_fix_freelist(args, 0);
> +	ASSERT(start_agno >= minimum_agno);
> +
> +	/*
> +	 * Loop over allocation groups twice; first time with
> +	 * trylock set, second time without.
> +	 */
> +	args->agno = start_agno;
> +	for (;;) {
> +		args->pag = xfs_perag_get(mp, args->agno);
> +		error = xfs_alloc_fix_freelist(args, flags);
>  		if (error) {
>  			trace_xfs_alloc_vextent_nofix(args);
> -			goto error0;
> -		}
> -		if (!args->agbp) {
> -			trace_xfs_alloc_vextent_noagbp(args);
>  			break;
>  		}
> -		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
> -		if ((error = xfs_alloc_ag_vextent(args)))
> -			goto error0;
> -		break;
> -	case XFS_ALLOCTYPE_START_BNO:
>  		/*
> -		 * Try near allocation first, then anywhere-in-ag after
> -		 * the first a.g. fails.
> +		 * If we get a buffer back then the allocation will fly.
>  		 */
> -		if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
> -		    xfs_is_inode32(mp)) {
> -			args->fsbno = XFS_AGB_TO_FSB(mp,
> -					((mp->m_agfrotor / rotorstep) %
> -					mp->m_sb.sb_agcount), 0);
> -			bump_rotor = 1;
> +		if (args->agbp) {
> +			error = xfs_alloc_ag_vextent(args);
> +			break;
>  		}
> -		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
> -		args->type = XFS_ALLOCTYPE_NEAR_BNO;
> -		fallthrough;
> -	case XFS_ALLOCTYPE_FIRST_AG:
> +
> +		trace_xfs_alloc_vextent_loopfailed(args);
> +
>  		/*
> -		 * Rotate through the allocation groups looking for a winner.
> -		 * If we are blocking, we must obey minimum_agno contraints for
> -		 * avoiding ABBA deadlocks on AGF locking.
> +		 * Didn't work, figure out the next iteration.
>  		 */
> -		if (type == XFS_ALLOCTYPE_FIRST_AG) {
> -			/*
> -			 * Start with allocation group given by bno.
> -			 */
> -			args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
> +		if (args->agno == start_agno &&
> +		    args->otype == XFS_ALLOCTYPE_START_BNO)
>  			args->type = XFS_ALLOCTYPE_THIS_AG;
> -			sagno = minimum_agno;
> -			flags = 0;
> -		} else {
> -			/*
> -			 * Start with the given allocation group.
> -			 */
> -			args->agno = sagno = XFS_FSB_TO_AGNO(mp, args->fsbno);
> -			flags = XFS_ALLOC_FLAG_TRYLOCK;
> +
> +		/*
> +		 * If we are try-locking, we can't deadlock on AGF locks so we
> +		 * can wrap all the way back to the first AG. Otherwise, wrap
> +		 * back to the start AG so we can't deadlock and let the end of
> +		 * scan handler decide what to do next.
> +		 */
> +		if (++(args->agno) == mp->m_sb.sb_agcount) {
> +			if (flags & XFS_ALLOC_FLAG_TRYLOCK)
> +				args->agno = 0;
> +			else
> +				args->agno = minimum_agno;
>  		}
>  
>  		/*
> -		 * Loop over allocation groups twice; first time with
> -		 * trylock set, second time without.
> +		 * Reached the starting a.g., must either be done
> +		 * or switch to non-trylock mode.
>  		 */
> -		for (;;) {
> -			args->pag = xfs_perag_get(mp, args->agno);
> -			error = xfs_alloc_fix_freelist(args, flags);
> -			if (error) {
> -				trace_xfs_alloc_vextent_nofix(args);
> -				goto error0;
> -			}
> -			/*
> -			 * If we get a buffer back then the allocation will fly.
> -			 */
> -			if (args->agbp) {
> -				if ((error = xfs_alloc_ag_vextent(args)))
> -					goto error0;
> +		if (args->agno == start_agno) {
> +			if (flags == 0) {
> +				args->agbno = NULLAGBLOCK;
> +				trace_xfs_alloc_vextent_allfailed(args);
>  				break;
>  			}
>  
> -			trace_xfs_alloc_vextent_loopfailed(args);
> +			flags = 0;
> +			if (args->otype == XFS_ALLOCTYPE_START_BNO) {
> +				args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
> +				args->type = XFS_ALLOCTYPE_NEAR_BNO;
> +			}
> +		}
> +		xfs_perag_put(args->pag);
> +		args->pag = NULL;
> +	}
> +	if (args->pag) {
> +		xfs_perag_put(args->pag);
> +		args->pag = NULL;
> +	}
> +	return error;
> +}
>  
> -			/*
> -			 * Didn't work, figure out the next iteration.
> -			 */
> -			if (args->agno == sagno &&
> -			    type == XFS_ALLOCTYPE_START_BNO)
> -				args->type = XFS_ALLOCTYPE_THIS_AG;
> +/*
> + * Iterate from the AGs from the start AG to the end of the filesystem, trying
> + * to allocate blocks. It starts with a near allocation attempt in the initial
> + * AG, then falls back to anywhere-in-ag after the first AG fails. It will wrap
> + * back to zero if allowed by previous allocations in this transaction,
> + * otherwise will wrap back to the start AG and run a second blocking pass to
> + * the end of the filesystem.
> + */
> +static int
> +xfs_alloc_vextent_start_ag(
> +	struct xfs_alloc_arg	*args,
> +	xfs_agnumber_t		minimum_agno)
> +{
> +	struct xfs_mount	*mp = args->mp;
> +	xfs_agnumber_t		start_agno;
> +	xfs_agnumber_t		rotorstep = xfs_rotorstep;
> +	bool			bump_rotor = false;
> +	int			error;
>  
> -			/*
> -			 * If we are try-locking, we can't deadlock on AGF
> -			 * locks, so we can wrap all the way back to the first
> -			 * AG. Otherwise, wrap back to the start AG so we can't
> -			 * deadlock, and let the end of scan handler decide what
> -			 * to do next.
> -			 */
> -			if (++(args->agno) == mp->m_sb.sb_agcount) {
> -				if (flags & XFS_ALLOC_FLAG_TRYLOCK)
> -					args->agno = 0;
> -				else
> -					args->agno = sagno;
> -			}
> +	error = xfs_alloc_vextent_check_args(args);
> +	if (error) {
> +		if (error == -ENOSPC)
> +			return 0;
> +		return error;
> +	}
>  
> -			/*
> -			 * Reached the starting a.g., must either be done
> -			 * or switch to non-trylock mode.
> -			 */
> -			if (args->agno == sagno) {
> -				if (flags == 0) {
> -					args->agbno = NULLAGBLOCK;
> -					trace_xfs_alloc_vextent_allfailed(args);
> -					break;
> -				}
> +	if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
> +	    xfs_is_inode32(mp)) {
> +		args->fsbno = XFS_AGB_TO_FSB(mp,
> +				((mp->m_agfrotor / rotorstep) %
> +				mp->m_sb.sb_agcount), 0);
> +		bump_rotor = 1;
> +	}
> +	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, args->fsbno));
> +	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
> +	args->type = XFS_ALLOCTYPE_NEAR_BNO;
>  
> -				/*
> -				 * Blocking pass next, so we must obey minimum
> -				 * agno constraints to avoid ABBA AGF deadlocks.
> -				 */
> -				flags = 0;
> -				if (minimum_agno > sagno)
> -					sagno = minimum_agno;
> -
> -				if (type == XFS_ALLOCTYPE_START_BNO) {
> -					args->agbno = XFS_FSB_TO_AGBNO(mp,
> -						args->fsbno);
> -					args->type = XFS_ALLOCTYPE_NEAR_BNO;
> -				}
> -			}
> -			xfs_perag_put(args->pag);
> -		}
> -		if (bump_rotor) {
> -			if (args->agno == sagno)
> -				mp->m_agfrotor = (mp->m_agfrotor + 1) %
> -					(mp->m_sb.sb_agcount * rotorstep);
> -			else
> -				mp->m_agfrotor = (args->agno * rotorstep + 1) %
> -					(mp->m_sb.sb_agcount * rotorstep);
> -		}
> -		break;
> -	default:
> -		ASSERT(0);
> -		/* NOTREACHED */
> +	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
> +			XFS_ALLOC_FLAG_TRYLOCK);
> +	if (bump_rotor) {
> +		if (args->agno == start_agno)
> +			mp->m_agfrotor = (mp->m_agfrotor + 1) %
> +				(mp->m_sb.sb_agcount * rotorstep);
> +		else
> +			mp->m_agfrotor = (args->agno * rotorstep + 1) %
> +				(mp->m_sb.sb_agcount * rotorstep);
>  	}
> -	if (args->agbno == NULLAGBLOCK) {
> -		args->fsbno = NULLFSBLOCK;
> -	} else {
> -		args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
> -#ifdef DEBUG
> -		ASSERT(args->len >= args->minlen);
> -		ASSERT(args->len <= args->maxlen);
> -		ASSERT(args->agbno % args->alignment == 0);
> -		XFS_AG_CHECK_DADDR(mp, XFS_FSB_TO_DADDR(mp, args->fsbno),
> -			args->len);
> -#endif
>  
> +	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
> +	return error;
> +}
> +
> +/*
> + * Iterate from the agno indicated from args->fsbno through to the end of the
> + * filesystem attempting blocking allocation. This does not wrap or try a second
> + * pass, so will not recurse into AGs lower than indicated by fsbno.
> + */
> +static int
> +xfs_alloc_vextent_first_ag(
> +	struct xfs_alloc_arg	*args,
> +	xfs_agnumber_t		minimum_agno)
> +{
> +	struct xfs_mount	*mp = args->mp;
> +	xfs_agnumber_t		start_agno;
> +	int			error;
> +
> +	error = xfs_alloc_vextent_check_args(args);
> +	if (error) {
> +		if (error == -ENOSPC)
> +			return 0;
> +		return error;
>  	}
>  
> -	/*
> -	 * We end up here with a locked AGF. If we failed, the caller is likely
> -	 * going to try to allocate again with different parameters, and that
> -	 * can widen the AGs that are searched for free space. If we have to do
> -	 * BMBT block allocation, we have to do a new allocation.
> -	 *
> -	 * Hence leaving this function with the AGF locked opens up potential
> -	 * ABBA AGF deadlocks because a future allocation attempt in this
> -	 * transaction may attempt to lock a lower number AGF.
> -	 *
> -	 * We can't release the AGF until the transaction is commited, so at
> -	 * this point we must update the "firstblock" tracker to point at this
> -	 * AG if the tracker is empty or points to a lower AG. This allows the
> -	 * next allocation attempt to be modified appropriately to avoid
> -	 * deadlocks.
> -	 */
> -	if (args->agbp &&
> -	    (args->tp->t_highest_agno == NULLAGNUMBER ||
> -	     args->pag->pag_agno > minimum_agno))
> -		args->tp->t_highest_agno = args->pag->pag_agno;
> -	xfs_perag_put(args->pag);
> -	return 0;
> -error0:
> -	xfs_perag_put(args->pag);
> +	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, args->fsbno));
> +
> +	args->type = XFS_ALLOCTYPE_THIS_AG;
> +	error =  xfs_alloc_vextent_iterate_ags(args, minimum_agno,
> +			start_agno, 0);
> +	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
>  	return error;
>  }
>  
> +/*
> + * Allocate an extent (variable-size).
> + * Depending on the allocation type, we either look in a single allocation
> + * group or loop over the allocation groups to find the result.
> + */
> +int
> +xfs_alloc_vextent(
> +	struct xfs_alloc_arg	*args)
> +{
> +	xfs_agnumber_t		minimum_agno = 0;
> +
> +	if (args->tp->t_highest_agno != NULLAGNUMBER)
> +		minimum_agno = args->tp->t_highest_agno;
> +
> +	switch (args->type) {
> +	case XFS_ALLOCTYPE_THIS_AG:
> +	case XFS_ALLOCTYPE_NEAR_BNO:
> +	case XFS_ALLOCTYPE_THIS_BNO:
> +		return xfs_alloc_vextent_this_ag(args, minimum_agno);
> +	case XFS_ALLOCTYPE_START_BNO:
> +		return xfs_alloc_vextent_start_ag(args, minimum_agno);
> +	case XFS_ALLOCTYPE_FIRST_AG:
> +		return xfs_alloc_vextent_first_ag(args, minimum_agno);
> +	default:
> +		ASSERT(0);
> +		/* NOTREACHED */
> +	}
> +	/* Should never get here */
> +	return -EFSCORRUPTED;
> +}
> +
>  /* Ensure that the freelist is at full capacity. */
>  int
>  xfs_free_extent_fix_freelist(
> -- 
> 2.39.0
> 
