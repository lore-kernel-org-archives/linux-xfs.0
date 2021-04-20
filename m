Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D20C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B522613CD
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhDTRMI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231549AbhDTRMI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 13:12:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A981C613AF;
        Tue, 20 Apr 2021 17:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618938696;
        bh=OCEOZAJbjv3xNGcLmLB4grBMoFIYzyVitNvLhh2weDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a9sIfu4dwc09/XWlwAu7DEDgbnMNKcv3bKe14jn3WkaVhaxsjDiHddnM9c07LHX3b
         nxUs9+cXZQSCjyJLugC9DpHs3FgI+c/sBgXWc8dLm62jCLJTa3pMn+8JS7FZVPLM5U
         ZTtM2x040xz06fdi3wvjDMQnZ8LBjkfZHgjPCJWJ1CTLMSJbh3Ujivatkp1/UTiki6
         zAPq060tZ+g/wKbTp21WhZZIqx/0VA0zxFDnTeG60VCipg6l8Gm2qxfalG7Xv4MBYq
         cunGOl8du+SoLIh56qeMoaEpPQq/9KfyGbLeuNiMufpMxMhPY729sK9bWNnkd/nHbc
         tHQtvOMOOaw3Q==
Date:   Tue, 20 Apr 2021 10:11:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH 5/7] xfs: add a xfs_efi_item_sizeof helper
Message-ID: <20210420171136.GK3122264@magnolia>
References: <20210419082804.2076124-1-hch@lst.de>
 <20210419082804.2076124-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419082804.2076124-6-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 19, 2021 at 10:28:02AM +0200, Christoph Hellwig wrote:
> Add a helper to calculate the size of an xfs_efi_log_item structure
> the specified number of extents.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Function name questions notwithstanding, this is a nice cleanup.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_extfree_item.c | 10 +++-------
>  fs/xfs/xfs_extfree_item.h |  6 ++++++
>  fs/xfs/xfs_super.c        |  6 ++----
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index f15d6cfca6e2f1..afd568d426c1f1 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -153,17 +153,13 @@ xfs_efi_init(
>  
>  {
>  	struct xfs_efi_log_item	*efip;
> -	uint			size;
>  
>  	ASSERT(nextents > 0);
> -	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
> -		size = (uint)(sizeof(struct xfs_efi_log_item) +
> -			((nextents - 1) * sizeof(struct xfs_extent)));
> -		efip = kmem_zalloc(size, 0);
> -	} else {
> +	if (nextents > XFS_EFI_MAX_FAST_EXTENTS)
> +		efip = kmem_zalloc(xfs_efi_item_sizeof(nextents), 0);
> +	else
>  		efip = kmem_cache_zalloc(xfs_efi_zone,
>  					 GFP_KERNEL | __GFP_NOFAIL);
> -	}
>  
>  	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
>  	efip->efi_format.efi_nextents = nextents;
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index e09afd0f63ff59..d2577d872de771 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -52,6 +52,12 @@ struct xfs_efi_log_item {
>  	struct xfs_efi_log_format efi_format;
>  };
>  
> +static inline int xfs_efi_item_sizeof(unsigned int nextents)
> +{
> +	return sizeof(struct xfs_efi_log_item) +
> +		(nextents - 1) * sizeof(struct xfs_extent);
> +}
> +
>  /*
>   * This is the "extent free done" log item.  It is used to log
>   * the fact that some extents earlier mentioned in an efi item
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a2dab05332ac27..c93710cb5ce3f0 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1961,10 +1961,8 @@ xfs_init_zones(void)
>  		goto out_destroy_buf_item_zone;
>  
>  	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
> -					 (sizeof(struct xfs_efi_log_item) +
> -					 (XFS_EFI_MAX_FAST_EXTENTS - 1) *
> -					 sizeof(struct xfs_extent)),
> -					 0, 0, NULL);
> +			xfs_efi_item_sizeof(XFS_EFI_MAX_FAST_EXTENTS),
> +			0, 0, NULL);
>  	if (!xfs_efi_zone)
>  		goto out_destroy_efd_zone;
>  
> -- 
> 2.30.1
> 
