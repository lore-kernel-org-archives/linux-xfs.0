Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BE4C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7935C6140B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhD1ENX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhD1ENX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:13:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD2F2613FF;
        Wed, 28 Apr 2021 04:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619583159;
        bh=OagB2HyAkOxI3Y+M9T5BvWtnsNSjZpybLoJH92A8HBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VErhNGTRcvpuCmSWQNaDuqDib50ajr/o4KRcyMnotrqGs7y6QlvSGMHiOgYAOy1kf
         CSt/jsBE56HZJDmH/h8osCo2J1b6BoDMQXU2H2NMSsyJn8b51HWvqKvyZRYdGQcZSl
         gR1pLf9tSkQN9x2D5BqTkJRHXGM2ndplHLM739wr3/je1SxS+mIaUM6ZlIES8fD43L
         /TycNkKhbhKCA2RZN/oLZ3OFxAprOeRjLzdlwWBOeNFdvmCY6WA4x/fau2g0fcWYXb
         LTIpdlMd4kIY8FmroM/SxZ9OXJGwcBtIZ0+kjiKdW3WC5WEiNNulTY3Xh+UnjYyaiC
         xqW/i0ciEdWdw==
Date:   Tue, 27 Apr 2021 21:12:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 1/3] xfs: unconditionally read all AGFs on mounts with
 perag reservation
Message-ID: <20210428041238.GF3122264@magnolia>
References: <20210423131050.141140-1-bfoster@redhat.com>
 <20210423131050.141140-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423131050.141140-2-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 23, 2021 at 09:10:48AM -0400, Brian Foster wrote:
> perag reservation is enabled at mount time on a per AG basis. The
> upcoming change to set aside allocbt blocks from block reservation
> requires a populated allocbt counter as soon as possible after mount
> to be fully effective against large perag reservations. Therefore as
> a preparation step, initialize the pagf on all mounts where at least
> one reservation is active. Note that this already occurs to some
> degree on most default format filesystems as reservation requirement
> calculations already depend on the AGF or AGI, depending on the
> reservation type.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good to me too,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag_resv.c | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 6c5f8d10589c..e32a1833d523 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -253,7 +253,8 @@ xfs_ag_resv_init(
>  	xfs_agnumber_t			agno = pag->pag_agno;
>  	xfs_extlen_t			ask;
>  	xfs_extlen_t			used;
> -	int				error = 0;
> +	int				error = 0, error2;
> +	bool				has_resv = false;
>  
>  	/* Create the metadata reservation. */
>  	if (pag->pag_meta_resv.ar_asked == 0) {
> @@ -291,6 +292,8 @@ xfs_ag_resv_init(
>  			if (error)
>  				goto out;
>  		}
> +		if (ask)
> +			has_resv = true;
>  	}
>  
>  	/* Create the RMAPBT metadata reservation */
> @@ -304,19 +307,28 @@ xfs_ag_resv_init(
>  		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_RMAPBT, ask, used);
>  		if (error)
>  			goto out;
> +		if (ask)
> +			has_resv = true;
>  	}
>  
> -#ifdef DEBUG
> -	/* need to read in the AGF for the ASSERT below to work */
> -	error = xfs_alloc_pagf_init(pag->pag_mount, tp, pag->pag_agno, 0);
> -	if (error)
> -		return error;
> -
> -	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> -	       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> -	       pag->pagf_freeblks + pag->pagf_flcount);
> -#endif
>  out:
> +	/*
> +	 * Initialize the pagf if we have at least one active reservation on the
> +	 * AG. This may have occurred already via reservation calculation, but
> +	 * fall back to an explicit init to ensure the in-core allocbt usage
> +	 * counters are initialized as soon as possible. This is important
> +	 * because filesystems with large perag reservations are susceptible to
> +	 * free space reservation problems that the allocbt counter is used to
> +	 * address.
> +	 */
> +	if (has_resv) {
> +		error2 = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, 0);
> +		if (error2)
> +			return error2;
> +		ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> +		       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> +		       pag->pagf_freeblks + pag->pagf_flcount);
> +	}
>  	return error;
>  }
>  
> -- 
> 2.26.3
> 
