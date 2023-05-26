Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8D2C77B73
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 15:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbjEZPQM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 11:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243786AbjEZPQL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 11:16:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F8DE7
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 08:16:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FA456152F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 15:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF94C433D2;
        Fri, 26 May 2023 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685114168;
        bh=g/xwlVfCtimU6IAATKP0aRqsn7XPSuToKGaX6CobDLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WSmlEtIzZRdZygIPkAFVe7qpX90nTIJS0MI/IQuiHUGDE5K+EIh8qQybixvQwXOjM
         bKbt6IC5Nx8Hqw964BvfWSiSiNBS9GhRJdDaiKQjRV25PKXa0V8h2YkPPV0VN51lD3
         Or1rpO58l1PJ8lODiAKiJWosTtFD0FGoNSIdu+Q51R7N2znPpcsWqRoaySLbAXQxRq
         U7mT5sPWteZ6T60v6znMPFTPq2qShiHbjwADZ2P9P1fSh4Pa3DDm3UAGGib45/hUNl
         ZFmLA3W9A37vAxw+JtUl73JdBnz2+A7uXKXKcfC6ejBOT5j9WRNGiYnCqUX50IjbgQ
         KUcVeKAtmX7MQ==
Date:   Fri, 26 May 2023 08:16:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: Finish renaming xfs_extent_item variables
Message-ID: <20230526151608.GL11620@frogsfrogsfrogs>
References: <20230526131338.114548-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526131338.114548-1-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 26, 2023 at 03:13:38PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Finish renaming xfs_extent_free_item variables to xefi on file
> libxfs/defer_item.c, because the maintainer overlooked this file while
> pulling changes from kernel commit 578c714b215d474c52949e65a914dae67924f0fe.
> 
> Signed-off-by: Carlos Maiolino <cem@kernel.org>

Looks a lot like mine; so easy to review!! :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

(Thx for taking care of this)

--D

> ---
>  libxfs/defer_item.c | 36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
> index b95b54e52..285dc9a35 100644
> --- a/libxfs/defer_item.c
> +++ b/libxfs/defer_item.c
> @@ -80,18 +80,18 @@ xfs_extent_free_finish_item(
>  	struct xfs_btree_cur		**state)
>  {
>  	struct xfs_owner_info		oinfo = { };
> -	struct xfs_extent_free_item	*free;
> +	struct xfs_extent_free_item	*xefi;
>  	int				error;
>  
> -	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> -	oinfo.oi_owner = free->xefi_owner;
> -	if (free->xefi_flags & XFS_EFI_ATTR_FORK)
> +	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
> +	oinfo.oi_owner = xefi->xefi_owner;
> +	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
>  		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
> -	if (free->xefi_flags & XFS_EFI_BMBT_BLOCK)
> +	if (xefi->xefi_flags & XFS_EFI_BMBT_BLOCK)
>  		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
> -	error = xfs_free_extent(tp, free->xefi_startblock,
> -		free->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE);
> -	kmem_cache_free(xfs_extfree_item_cache, free);
> +	error = xfs_free_extent(tp, xefi->xefi_startblock,
> +		xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE);
> +	kmem_cache_free(xfs_extfree_item_cache, xefi);
>  	return error;
>  }
>  
> @@ -107,10 +107,10 @@ STATIC void
>  xfs_extent_free_cancel_item(
>  	struct list_head		*item)
>  {
> -	struct xfs_extent_free_item	*free;
> +	struct xfs_extent_free_item	*xefi;
>  
> -	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> -	kmem_cache_free(xfs_extfree_item_cache, free);
> +	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
> +	kmem_cache_free(xfs_extfree_item_cache, xefi);
>  }
>  
>  const struct xfs_defer_op_type xfs_extent_free_defer_type = {
> @@ -134,25 +134,25 @@ xfs_agfl_free_finish_item(
>  {
>  	struct xfs_owner_info		oinfo = { };
>  	struct xfs_mount		*mp = tp->t_mountp;
> -	struct xfs_extent_free_item	*free;
> +	struct xfs_extent_free_item	*xefi;
>  	struct xfs_buf			*agbp;
>  	struct xfs_perag		*pag;
>  	int				error;
>  	xfs_agnumber_t			agno;
>  	xfs_agblock_t			agbno;
>  
> -	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> -	ASSERT(free->xefi_blockcount == 1);
> -	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
> -	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
> -	oinfo.oi_owner = free->xefi_owner;
> +	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
> +	ASSERT(xefi->xefi_blockcount == 1);
> +	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
> +	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
> +	oinfo.oi_owner = xefi->xefi_owner;
>  
>  	pag = libxfs_perag_get(mp, agno);
>  	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
>  	if (!error)
>  		error = xfs_free_agfl_block(tp, agno, agbno, agbp, &oinfo);
>  	libxfs_perag_put(pag);
> -	kmem_cache_free(xfs_extfree_item_cache, free);
> +	kmem_cache_free(xfs_extfree_item_cache, xefi);
>  	return error;
>  }
>  
> -- 
> 2.30.2
> 
