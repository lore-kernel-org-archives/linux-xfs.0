Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B40E92FE7
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 05:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjJFF7H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 01:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjJFF7H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 01:59:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583BFCE
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 22:59:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86ECC433C8;
        Fri,  6 Oct 2023 05:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696571946;
        bh=s3PRU8FjrLGHIZGk/Vxz21khgcL0CQm2mdI50ytWeAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t2pbmmhTPD2u/7lSm2otloyb9KTSU75YMrwCDLvR3tSWq6gduioDULHe5zsvFFTx4
         h0quPUr6HcJXYGN9tDEmWqQL3CbX2/BtDRKnDeGnpeIw36XZyHZptr9Ua3bqH6NIiN
         jJ3G8bNBIWF7kE2jnxxZ6+1DvtdfTSIVhcYAktYEh+wpBr/F2KM3IXkCO7gSk1qmTT
         aTCe68wntcdtPJxnH0vFLP5mrPUqR+W8cbwGho4MCD0Li/Dtky7CUnwBOh6JKI5hXd
         wlsqdUw1Miv+k9QdvGUe0ISWOWmkNKfFLpLI+XRvWAyebevJYNVKZOMPX3Qddj6tzo
         g4l+nZO2j1BBA==
Date:   Thu, 5 Oct 2023 22:59:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 7/9] xfs: caller perag always supplied to
 xfs_alloc_vextent_near_bno
Message-ID: <20231006055905.GW21298@frogsfrogsfrogs>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2023 at 11:19:41AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So we don't need to conditionally grab the perag anymore.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 289b54911b05..3190c8204903 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3686,7 +3686,7 @@ xfs_alloc_vextent_exact_bno(
>   * Allocate an extent as close to the target as possible. If there are not
>   * viable candidates in the AG, then fail the allocation.
>   *
> - * Caller may or may not have a per-ag reference in args->pag.
> + * Caller is expected to hold a per-ag reference in args->pag.

"Caller must hold..." ?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>   */
>  int
>  xfs_alloc_vextent_near_bno(
> @@ -3695,14 +3695,12 @@ xfs_alloc_vextent_near_bno(
>  {
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_agnumber_t		minimum_agno;
> -	bool			needs_perag = args->pag == NULL;
>  	uint32_t		alloc_flags = 0;
>  	int			error;
>  
> -	if (!needs_perag)
> -		ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
> +	ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
>  
> -	args->agno = XFS_FSB_TO_AGNO(mp, target);
> +	args->agno = args->pag->pag_agno;
>  	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
>  
>  	trace_xfs_alloc_vextent_near_bno(args);
> @@ -3715,14 +3713,11 @@ xfs_alloc_vextent_near_bno(
>  		return error;
>  	}
>  
> -	if (needs_perag)
> -		args->pag = xfs_perag_grab(mp, args->agno);
> -
>  	error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
>  	if (!error && args->agbp)
>  		error = xfs_alloc_ag_vextent_near(args, alloc_flags);
>  
> -	return xfs_alloc_vextent_finish(args, minimum_agno, error, needs_perag);
> +	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
>  }
>  
>  /* Ensure that the freelist is at full capacity. */
> -- 
> 2.40.1
> 
