Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52442C77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 01:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbjEQBLq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 21:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjEQBLp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 21:11:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FD9469A
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 18:11:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 376AC62F55
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 01:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB7BC433EF;
        Wed, 17 May 2023 01:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684285903;
        bh=ZcINzf+q8+kF9NORIv2xoCUvKPgM7JqYpdyPmnX3MXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WkeRbUY6jc0wbUDkWwAKGdJpsRihSBrI2E99vySfPjwURi6HSiyDD7kYeoBDYyJhS
         v9+/hZed0KsqQltACU2Crx5gP9mXnJOU+Vnixh77RK1fcZg2BoRjx7xe91RvnTjx9C
         WcH/fe2/4JrF1uv5AOrG4DkE7dldbg7UTJ3Va35zPT2lPuV60HpKonPAZAD4GkvIp9
         zWPE7W2sUw2C9wWE69wXfVmw2IDL4fKrD4DmIU4FJp9AKeDHqN5VU0XEZ+TstEBFer
         4/EtvqesI48tyr4SP6SoNNuLrX85Cuj/jt0XgANDqehtbhZE+9XfSAUSDZKC221kSz
         Tu78ulkmKGRyA==
Date:   Tue, 16 May 2023 18:11:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: restore allocation trylock iteration
Message-ID: <20230517011142.GN858799@frogsfrogsfrogs>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517000449.3997582-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 10:04:47AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It was accidentally dropped when refactoring the allocation code,
> resulting in the AG iteration always doing blocking AG iteration.
> This results in a small performance regression for a specific fsmark
> test that runs more user data writer threads than there are AGs.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Fixes: 2edf06a50f5b ("xfs: factor xfs_alloc_vextent_this_ag() for _iterate_ags()")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Heh, this is exactly what I was thinking from that thread...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index fdfa08cbf4db..61eb65be17f3 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3187,7 +3187,8 @@ xfs_alloc_vextent_check_args(
>   */
>  static int
>  xfs_alloc_vextent_prepare_ag(
> -	struct xfs_alloc_arg	*args)
> +	struct xfs_alloc_arg	*args,
> +	uint32_t		flags)
>  {
>  	bool			need_pag = !args->pag;
>  	int			error;
> @@ -3196,7 +3197,7 @@ xfs_alloc_vextent_prepare_ag(
>  		args->pag = xfs_perag_get(args->mp, args->agno);
>  
>  	args->agbp = NULL;
> -	error = xfs_alloc_fix_freelist(args, 0);
> +	error = xfs_alloc_fix_freelist(args, flags);
>  	if (error) {
>  		trace_xfs_alloc_vextent_nofix(args);
>  		if (need_pag)
> @@ -3336,7 +3337,7 @@ xfs_alloc_vextent_this_ag(
>  		return error;
>  	}
>  
> -	error = xfs_alloc_vextent_prepare_ag(args);
> +	error = xfs_alloc_vextent_prepare_ag(args, 0);
>  	if (!error && args->agbp)
>  		error = xfs_alloc_ag_vextent_size(args);
>  
> @@ -3380,7 +3381,7 @@ xfs_alloc_vextent_iterate_ags(
>  	for_each_perag_wrap_range(mp, start_agno, restart_agno,
>  			mp->m_sb.sb_agcount, agno, args->pag) {
>  		args->agno = agno;
> -		error = xfs_alloc_vextent_prepare_ag(args);
> +		error = xfs_alloc_vextent_prepare_ag(args, flags);
>  		if (error)
>  			break;
>  		if (!args->agbp) {
> @@ -3546,7 +3547,7 @@ xfs_alloc_vextent_exact_bno(
>  		return error;
>  	}
>  
> -	error = xfs_alloc_vextent_prepare_ag(args);
> +	error = xfs_alloc_vextent_prepare_ag(args, 0);
>  	if (!error && args->agbp)
>  		error = xfs_alloc_ag_vextent_exact(args);
>  
> @@ -3587,7 +3588,7 @@ xfs_alloc_vextent_near_bno(
>  	if (needs_perag)
>  		args->pag = xfs_perag_grab(mp, args->agno);
>  
> -	error = xfs_alloc_vextent_prepare_ag(args);
> +	error = xfs_alloc_vextent_prepare_ag(args, 0);
>  	if (!error && args->agbp)
>  		error = xfs_alloc_ag_vextent_near(args);
>  
> -- 
> 2.40.1
> 
