Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF72CC7EE22
	for <linux-xfs@archiver.kernel.org>; Thu, 11 May 2023 13:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238238AbjEKNiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 May 2023 09:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237852AbjEKNhp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2023 09:37:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC5BD043
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 06:35:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C29D564D6F
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 13:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750DFC433D2;
        Thu, 11 May 2023 13:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683812132;
        bh=Jv/D2Plf7URJPUiohRGIP2SSez1KBZAC8+FnvFZMzDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S3OZb0Y87On0PbnOXqBoof7thmeuYAJ29jI/eCdrXIg7DOkt0brICuIMs2OWYaiRu
         XiRYaqKYXFzh/nvZYUUoOvXMt7JidZlZDpAFvdSD/VUrHyqrrteJ6eAuKdGSOyB06Y
         +ypxn8t3AGsPiKIgNwPqSkLJpLDzKDDircvU8NWPPD1uHhYLPRCEuSo+ifw4DBAXxx
         wWn3hzQHipzI6qshakvOpGUNtn6sopvVAPBSW6kd552HesD2WODUfDsIEsVtX9jw0L
         irIJZLoEcQ6iwOyhZlrDzWNkT9Uz9InuxYBGvJtFuDPpZAF8Obalu4PfsAdVZtBCos
         0kFbQynNoErHg==
Date:   Thu, 11 May 2023 15:35:28 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: fix confusing xfs_extent_item variable names
Message-ID: <20230511133528.wtunsuolh4hms36b@andromeda>
References: <0kaspVe46GjWH34UplQpBKZYm9TFMd-VCgmBlNr5UbWao_BKBsNdO8xn06_SqVveitqg5wLOXPd-St5SXH5Aag==@protonmail.internalid>
 <20230510195617.GD858799@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510195617.GD858799@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 10, 2023 at 12:56:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Change the name of all pointers to xfs_extent_item structures to "xefi"
> to make the name consistent and because the current selections ("new"
> and "free") mean other things in C.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Sounds good, thanks!
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  libxfs/defer_item.c |   41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
> index b95b54e5..2e9912f8 100644
> --- a/libxfs/defer_item.c
> +++ b/libxfs/defer_item.c
> @@ -80,18 +80,20 @@ xfs_extent_free_finish_item(
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
> +
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
> +			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE);
> +
> +	kmem_cache_free(xfs_extfree_item_cache, xefi);
>  	return error;
>  }
> 
> @@ -107,10 +109,11 @@ STATIC void
>  xfs_extent_free_cancel_item(
>  	struct list_head		*item)
>  {
> -	struct xfs_extent_free_item	*free;
> +	struct xfs_extent_free_item	*xefi;
> 
> -	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> -	kmem_cache_free(xfs_extfree_item_cache, free);
> +	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
> +
> +	kmem_cache_free(xfs_extfree_item_cache, xefi);
>  }
> 
>  const struct xfs_defer_op_type xfs_extent_free_defer_type = {
> @@ -134,25 +137,27 @@ xfs_agfl_free_finish_item(
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
> +
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
> +
> +	kmem_cache_free(xfs_extfree_item_cache, xefi);
>  	return error;
>  }
> 

-- 
Carlos Maiolino
