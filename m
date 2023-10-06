Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D2AE92FE7
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 06:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjJFGBy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 02:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjJFGBy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 02:01:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C256CA
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 23:01:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC587C433C8;
        Fri,  6 Oct 2023 06:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696572111;
        bh=xXYFw7ZYAEejjRSBOCYYPWCuwx+uEfymyKquVGe1tZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I83xZRNwz1+V4yMzgxtEkUriwJiOpY/0uG9tu1qCX11zPDlJrOc0Rab8OC6Fbtunj
         m6DhJ4PwMTp/fohLhu1cfokHuMiJeVKRtndkdctgZ2OGT1Xq1hlHZAria+Syt6/uJ5
         Dus1+QiIjzAvaqWLzXJqS6aAjQY9I0i8RGIbno4qFMNTMNZzKUCyHKgpkA048GZ5qt
         hR6uGPaZ6Y2pADBtSpiof/rzCYBEVwVIJPtWQWRyv1pHtS8DIgRLM7T1QjY2YBlnI4
         /1x2qK3HXhcfGjaJ1VARL0Kg+zVfqEl4SzNK+yg72pVUkfRKXRoJ3jAm2Gv6myDl9C
         A/x8PTIKtdkaA==
Date:   Thu, 5 Oct 2023 23:01:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 8/9] xfs: collapse near and exact bno allocation
Message-ID: <20231006060151.GX21298@frogsfrogsfrogs>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-9-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2023 at 11:19:42AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> As they are now identical functions exact for the allocation
> function they call.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 84 ++++++++++++++++++---------------------
>  fs/xfs/xfs_trace.h        |  1 +
>  2 files changed, 40 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 3190c8204903..27c62f303488 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3649,6 +3649,43 @@ xfs_alloc_vextent_first_ag(
>  	return xfs_alloc_vextent_finish(args, minimum_agno, error, true);
>  }
>  
> +static int
> +xfs_alloc_vextent_bno(
> +	struct xfs_alloc_arg	*args,
> +	xfs_fsblock_t		target,
> +	bool			exact)
> +{
> +	struct xfs_mount	*mp = args->mp;
> +	xfs_agnumber_t		minimum_agno;
> +	int			error;
> +
> +	ASSERT(args->pag != NULL);
> +	ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
> +
> +	args->agno = args->pag->pag_agno;
> +	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
> +
> +	trace_xfs_alloc_vextent_bno(args);

Not sure why we need this new tracepoint when a tracepoint is triggered
immediately prior to both callsites?

--D

> +
> +	error = xfs_alloc_vextent_check_args(args, args->agno, args->agbno,
> +			&minimum_agno);
> +	if (error) {
> +		if (error == -ENOSPC)
> +			return 0;
> +		return error;
> +	}
> +
> +	error = xfs_alloc_vextent_prepare_ag(args, 0);
> +	if (!error && args->agbp) {
> +		if (exact)
> +			error = xfs_alloc_ag_vextent_exact(args);
> +		else
> +			error = xfs_alloc_ag_vextent_near(args, 0);
> +	}
> +
> +	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
> +}
> +
>  /*
>   * Allocate at the exact block target or fail. Caller is expected to hold a
>   * perag reference in args->pag.
> @@ -3658,28 +3695,8 @@ xfs_alloc_vextent_exact_bno(
>  	struct xfs_alloc_arg	*args,
>  	xfs_fsblock_t		target)
>  {
> -	struct xfs_mount	*mp = args->mp;
> -	xfs_agnumber_t		minimum_agno;
> -	int			error;
> -
> -	args->agno = args->pag->pag_agno;
> -	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
> -
>  	trace_xfs_alloc_vextent_exact_bno(args);
> -
> -	error = xfs_alloc_vextent_check_args(args, args->agno, args->agbno,
> -			&minimum_agno);
> -	if (error) {
> -		if (error == -ENOSPC)
> -			return 0;
> -		return error;
> -	}
> -
> -	error = xfs_alloc_vextent_prepare_ag(args, 0);
> -	if (!error && args->agbp)
> -		error = xfs_alloc_ag_vextent_exact(args);
> -
> -	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
> +	return xfs_alloc_vextent_bno(args, target, true);
>  }
>  
>  /*
> @@ -3693,31 +3710,8 @@ xfs_alloc_vextent_near_bno(
>  	struct xfs_alloc_arg	*args,
>  	xfs_fsblock_t		target)
>  {
> -	struct xfs_mount	*mp = args->mp;
> -	xfs_agnumber_t		minimum_agno;
> -	uint32_t		alloc_flags = 0;
> -	int			error;
> -
> -	ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
> -
> -	args->agno = args->pag->pag_agno;
> -	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
> -
>  	trace_xfs_alloc_vextent_near_bno(args);
> -
> -	error = xfs_alloc_vextent_check_args(args, args->agno, args->agbno,
> -			&minimum_agno);
> -	if (error) {
> -		if (error == -ENOSPC)
> -			return 0;
> -		return error;
> -	}
> -
> -	error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
> -	if (!error && args->agbp)
> -		error = xfs_alloc_ag_vextent_near(args, alloc_flags);
> -
> -	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
> +	return xfs_alloc_vextent_bno(args, target, false);
>  }
>  
>  /* Ensure that the freelist is at full capacity. */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 3926cf7f2a6e..628da36b20b9 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1884,6 +1884,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_start_ag);
>  DEFINE_ALLOC_EVENT(xfs_alloc_vextent_first_ag);
>  DEFINE_ALLOC_EVENT(xfs_alloc_vextent_exact_bno);
>  DEFINE_ALLOC_EVENT(xfs_alloc_vextent_near_bno);
> +DEFINE_ALLOC_EVENT(xfs_alloc_vextent_bno);
>  DEFINE_ALLOC_EVENT(xfs_alloc_vextent_finish);
>  
>  TRACE_EVENT(xfs_alloc_cur_check,
> -- 
> 2.40.1
> 
