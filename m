Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B91EB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 17:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjF1Rwq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjF1Rwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 13:52:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF17AD8
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 10:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62A126120E
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 17:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB71C433C8;
        Wed, 28 Jun 2023 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687974763;
        bh=A+rnShlW9vhlXloELCGU8ULwkPTao9nOFOwz94kshtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t2Y3m2moSQZBhnjMdeiXipnsl486v1SobPNKjekqP4bqM3HJDo2O//0ZQcmjUawQD
         6YEf4yAu0JpcxkmkGFHPKA5SLLCY1XQRrxzKtMEQhYiqmgZMzzI6NL2MHTOyGebwdz
         4H3ImbXqrliacW+EayasuEGBAhSYERZomhF+jwMp5J3KPLAOl9nqcWbAmRFsqmh+WA
         cQBHdxBvP5GgOAzajaNXijuz5Cn+Ch+LEWEuWcFsnbcsT+Yt0+tQst5y4nuDLsj08d
         +v9NolDEOmMdNBd5LIGAbWGuGhuOHLZ9TlPz9ehzI5GYwMyYFRi+gpxFCtRtt8dL2e
         DU+JFoy1BGcUg==
Date:   Wed, 28 Jun 2023 10:52:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: fix bounds check in xfs_defer_agfl_block()
Message-ID: <20230628175243.GY11441@frogsfrogsfrogs>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627224412.2242198-9-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 08:44:12AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Need to happen before we allocate and then leak the xefi. Found by
> coverity via an xfsprogs libxfs scan.
> 
> Fixes: 7dfee17b13e5 ("xfs: validate block number being freed before adding to xefi")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

LGTM,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 7c86a69354fb..9919fdfe1d7e 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2470,25 +2470,26 @@ static int
>  xfs_defer_agfl_block(
>  	struct xfs_trans		*tp,
>  	xfs_agnumber_t			agno,
> -	xfs_fsblock_t			agbno,
> +	xfs_agblock_t			agbno,
>  	struct xfs_owner_info		*oinfo)
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_extent_free_item	*xefi;
> +	xfs_fsblock_t			fsbno = XFS_AGB_TO_FSB(mp, agno, agbno);
>  
>  	ASSERT(xfs_extfree_item_cache != NULL);
>  	ASSERT(oinfo != NULL);
>  
> +	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, fsbno)))
> +		return -EFSCORRUPTED;
> +
>  	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
>  			       GFP_KERNEL | __GFP_NOFAIL);
> -	xefi->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
> +	xefi->xefi_startblock = fsbno;
>  	xefi->xefi_blockcount = 1;
>  	xefi->xefi_owner = oinfo->oi_owner;
>  	xefi->xefi_type = XFS_AG_RESV_AGFL;
>  
> -	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, xefi->xefi_startblock)))
> -		return -EFSCORRUPTED;
> -
>  	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
>  
>  	xfs_extent_free_get_group(mp, xefi);
> -- 
> 2.40.1
> 
