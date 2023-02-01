Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E370DC05027
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 23:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBAXPd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 18:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjBAXPb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 18:15:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE8B66024
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 15:15:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DEC96199D
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 23:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684C4C433EF;
        Wed,  1 Feb 2023 23:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675293194;
        bh=HgvQbzWtVUs73cD0/6G5M8Mbc725n+SiJ7KVrhQH53U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AWw0InYDVKKKd3185i7OkI1+NovZeHClWfSPfcmaSi/BEMKX9FAFZSLcrH3puQIOU
         4rMB/YUWFgEh/s4MQ7qRD/vrbY/TOFAFs+RW94cBWOc+0Yz0bk01vHMQ6K1RLfCI88
         ovYA3nRMgj6aBPzdt0CANnXz5UQ3xMqzfZsWbHTtY/8Q3arM0ylti0O27KEhypW4uw
         gHz8lxdTXUU6rjbwF+dK164VEOp8fPTI+kE9XfqxDwrntn34Hh7/DR6D+ZRTnnUFKD
         AP8wQF0M0gPantJf40e4Ei0tlAUMTxVG26V0R9f8lmz2l8Hj92yOx+NyeIw061iWqp
         WlmKqNt8j+5Kg==
Date:   Wed, 1 Feb 2023 15:13:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/42] xfs: convert xfs_alloc_vextent_iterate_ags() to
 use perag walker
Message-ID: <Y9ryCao6vEySwgOR@magnolia>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-29-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118224505.1964941-29-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 09:44:51AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the AG iteration code in the core allocation code has been
> cleaned up, we can easily convert it to use a for_each_perag..()
> variant to use active references and skip AGs that it can't get
> active references on.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.h    | 22 ++++++---
>  fs/xfs/libxfs/xfs_alloc.c | 98 ++++++++++++++++++---------------------
>  2 files changed, 60 insertions(+), 60 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 8f43b91d4cf3..5e18536dfdce 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -253,6 +253,7 @@ xfs_perag_next_wrap(
>  	struct xfs_perag	*pag,
>  	xfs_agnumber_t		*agno,
>  	xfs_agnumber_t		stop_agno,
> +	xfs_agnumber_t		restart_agno,
>  	xfs_agnumber_t		wrap_agno)
>  {
>  	struct xfs_mount	*mp = pag->pag_mount;
> @@ -260,10 +261,11 @@ xfs_perag_next_wrap(
>  	*agno = pag->pag_agno + 1;
>  	xfs_perag_rele(pag);
>  	while (*agno != stop_agno) {
> -		if (*agno >= wrap_agno)
> -			*agno = 0;
> -		if (*agno == stop_agno)
> -			break;
> +		if (*agno >= wrap_agno) {
> +			if (restart_agno >= stop_agno)
> +				break;
> +			*agno = restart_agno;
> +		}
>  
>  		pag = xfs_perag_grab(mp, *agno);
>  		if (pag)
> @@ -274,14 +276,20 @@ xfs_perag_next_wrap(
>  }
>  
>  /*
> - * Iterate all AGs from start_agno through wrap_agno, then 0 through
> + * Iterate all AGs from start_agno through wrap_agno, then restart_agno through
>   * (start_agno - 1).
>   */
> -#define for_each_perag_wrap_at(mp, start_agno, wrap_agno, agno, pag) \
> +#define for_each_perag_wrap_range(mp, start_agno, restart_agno, wrap_agno, agno, pag) \
>  	for ((agno) = (start_agno), (pag) = xfs_perag_grab((mp), (agno)); \
>  		(pag) != NULL; \
>  		(pag) = xfs_perag_next_wrap((pag), &(agno), (start_agno), \
> -				(wrap_agno)))
> +				(restart_agno), (wrap_agno)))
> +/*
> + * Iterate all AGs from start_agno through wrap_agno, then 0 through
> + * (start_agno - 1).
> + */
> +#define for_each_perag_wrap_at(mp, start_agno, wrap_agno, agno, pag) \
> +	for_each_perag_wrap_range((mp), (start_agno), 0, (wrap_agno), (agno), (pag))
>  
>  /*
>   * Iterate all AGs from start_agno through to the end of the filesystem, then 0
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 43a054002da3..39f3e76efcab 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3156,6 +3156,7 @@ xfs_alloc_vextent_prepare_ag(
>  	if (need_pag)
>  		args->pag = xfs_perag_get(args->mp, args->agno);
>  
> +	args->agbp = NULL;
>  	error = xfs_alloc_fix_freelist(args, 0);
>  	if (error) {
>  		trace_xfs_alloc_vextent_nofix(args);
> @@ -3255,8 +3256,8 @@ xfs_alloc_vextent_finish(
>  	XFS_STATS_ADD(mp, xs_allocb, args->len);
>  
>  out_drop_perag:
> -	if (drop_perag) {
> -		xfs_perag_put(args->pag);
> +	if (drop_perag && args->pag) {
> +		xfs_perag_rele(args->pag);
>  		args->pag = NULL;
>  	}
>  	return error;
> @@ -3304,6 +3305,10 @@ xfs_alloc_vextent_this_ag(
>   * we attempt to allocation in as there is no locality optimisation possible for
>   * those allocations.
>   *
> + * On return, args->pag may be left referenced if we finish before the "all
> + * failed" return point. The allocation finish still needs the perag, and
> + * so the caller will release it once they've finished the allocation.
> + *
>   * When we wrap the AG iteration at the end of the filesystem, we have to be
>   * careful not to wrap into AGs below ones we already have locked in the
>   * transaction if we are doing a blocking iteration. This will result in an
> @@ -3318,72 +3323,59 @@ xfs_alloc_vextent_iterate_ags(
>  	uint32_t		flags)
>  {
>  	struct xfs_mount	*mp = args->mp;
> +	xfs_agnumber_t		agno;
>  	int			error = 0;
>  
> -	ASSERT(start_agno >= minimum_agno);
> +restart:
> +	for_each_perag_wrap_range(mp, start_agno, minimum_agno,
> +			mp->m_sb.sb_agcount, agno, args->pag) {
> +		args->agno = agno;
> +		trace_printk("sag %u minag %u agno %u pag %u, agbno %u, agcnt %u",
> +			start_agno, minimum_agno, agno, args->pag->pag_agno,
> +			target_agbno, mp->m_sb.sb_agcount);

Please remove the debugging statement or (if it's useful) convert this
to a static tracepoint.

--D

>  
> -	/*
> -	 * Loop over allocation groups twice; first time with
> -	 * trylock set, second time without.
> -	 */
> -	args->agno = start_agno;
> -	for (;;) {
> -		args->pag = xfs_perag_get(mp, args->agno);
>  		error = xfs_alloc_vextent_prepare_ag(args);
>  		if (error)
>  			break;
> -
> -		if (args->agbp) {
> -			/*
> -			 * Allocation is supposed to succeed now, so break out
> -			 * of the loop regardless of whether we succeed or not.
> -			 */
> -			if (args->agno == start_agno && target_agbno) {
> -				args->agbno = target_agbno;
> -				error = xfs_alloc_ag_vextent_near(args);
> -			} else {
> -				args->agbno = 0;
> -				error = xfs_alloc_ag_vextent_size(args);
> -			}
> -			break;
> +		if (!args->agbp) {
> +			trace_xfs_alloc_vextent_loopfailed(args);
> +			continue;
>  		}
>  
> -		trace_xfs_alloc_vextent_loopfailed(args);
> -
>  		/*
> -		 * If we are try-locking, we can't deadlock on AGF locks so we
> -		 * can wrap all the way back to the first AG. Otherwise, wrap
> -		 * back to the start AG so we can't deadlock and let the end of
> -		 * scan handler decide what to do next.
> +		 * Allocation is supposed to succeed now, so break out of the
> +		 * loop regardless of whether we succeed or not.
>  		 */
> -		if (++(args->agno) == mp->m_sb.sb_agcount) {
> -			if (flags & XFS_ALLOC_FLAG_TRYLOCK)
> -				args->agno = 0;
> -			else
> -				args->agno = minimum_agno;
> -		}
> -
> -		/*
> -		 * Reached the starting a.g., must either be done
> -		 * or switch to non-trylock mode.
> -		 */
> -		if (args->agno == start_agno) {
> -			if (flags == 0) {
> -				args->agbno = NULLAGBLOCK;
> -				trace_xfs_alloc_vextent_allfailed(args);
> -				break;
> -			}
> +		if (args->agno == start_agno && target_agbno) {
>  			args->agbno = target_agbno;
> -			flags = 0;
> +			error = xfs_alloc_ag_vextent_near(args);
> +		} else {
> +			args->agbno = 0;
> +			error = xfs_alloc_ag_vextent_size(args);
>  		}
> -		xfs_perag_put(args->pag);
> +		break;
> +	}
> +	if (error) {
> +		xfs_perag_rele(args->pag);
>  		args->pag = NULL;
> +		return error;
>  	}
> +	if (args->agbp)
> +		return 0;
> +
>  	/*
> -	 * The perag is left referenced in args for the caller to clean
> -	 * up after they've finished the allocation.
> +	 * We didn't find an AG we can alloation from. If we were given
> +	 * constraining flags by the caller, drop them and retry the allocation
> +	 * without any constraints being set.
>  	 */
> -	return error;
> +	if (flags) {
> +		flags = 0;
> +		goto restart;
> +	}
> +
> +	ASSERT(args->pag == NULL);
> +	trace_xfs_alloc_vextent_allfailed(args);
> +	return 0;
>  }
>  
>  /*
> @@ -3524,7 +3516,7 @@ xfs_alloc_vextent_near_bno(
>  	}
>  
>  	if (needs_perag)
> -		args->pag = xfs_perag_get(mp, args->agno);
> +		args->pag = xfs_perag_grab(mp, args->agno);
>  
>  	error = xfs_alloc_vextent_prepare_ag(args);
>  	if (!error && args->agbp)
> -- 
> 2.39.0
> 
