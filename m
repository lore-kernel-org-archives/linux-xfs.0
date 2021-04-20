Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAF3C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BC9B613C9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhDTRNT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232473AbhDTRNT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 13:13:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF57C61076;
        Tue, 20 Apr 2021 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618938767;
        bh=44L92S5lDyimrL1nyEdscqqX2UrzmnXHIii5II/jJN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jJOSDzvH8AhgQ2mcro8T/TBpb0mIywds4R+S1nmyHjoaZNHr+jlbee2U1E6yUhpU7
         rc9pZnfceUA2k9WUD3YuVE/JylnWapXpWCl2vKMzasEfI0zb5ivTrR4oz4bpMLXxNQ
         I3mG6WYqeLvYWv80Gj8cY4rm/UsfTfgETiFlL+GEuzjYesJJ2rt0sJ93csY33EYKsl
         kkyYtvUWuZNG3SzKqQYb6dZwaE0mHbevAUjt5dxuUL6WvptT+Gxgt7wj3X4xFB5zD+
         lyYnYrHhxHtVQcgxrmVKGGOlECEAA3DR9RSRd3z1R7rhsfPiVoXtccbJJ1lLUxlv9K
         pjyXQ2dTAYIJg==
Date:   Tue, 20 Apr 2021 10:12:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH 6/7] xfs: add a xfs_efd_item_sizeof helper
Message-ID: <20210420171247.GL3122264@magnolia>
References: <20210419082804.2076124-1-hch@lst.de>
 <20210419082804.2076124-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419082804.2076124-7-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 19, 2021 at 10:28:03AM +0200, Christoph Hellwig wrote:
> Add a helper to calculate the size of an xfs_efd_log_item structure
> the specified number of extents.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Questions about function names notwithstanding,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_extfree_item.c | 10 +++-------
>  fs/xfs/xfs_extfree_item.h |  6 ++++++
>  fs/xfs/xfs_super.c        |  6 ++----
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index afd568d426c1f1..a2abdfd3d076bf 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -268,15 +268,11 @@ xfs_trans_get_efd(
>  	struct xfs_efd_log_item		*efdp;
>  
>  	ASSERT(nextents > 0);
> -
> -	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> -		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> -				(nextents - 1) * sizeof(struct xfs_extent),
> -				0);
> -	} else {
> +	if (nextents > XFS_EFD_MAX_FAST_EXTENTS)
> +		efdp = kmem_zalloc(xfs_efd_item_sizeof(nextents), 0);
> +	else
>  		efdp = kmem_cache_zalloc(xfs_efd_zone,
>  					GFP_KERNEL | __GFP_NOFAIL);
> -	}
>  
>  	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
>  			  &xfs_efd_item_ops);
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index d2577d872de771..3bb62ef525f2e0 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -70,6 +70,12 @@ struct xfs_efd_log_item {
>  	struct xfs_efd_log_format efd_format;
>  };
>  
> +static inline int xfs_efd_item_sizeof(unsigned int nextents)
> +{
> +	return sizeof(struct xfs_efd_log_item) +
> +		(nextents - 1) * sizeof(struct xfs_extent);
> +}
> +
>  /*
>   * Max number of extents in fast allocation path.
>   */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index c93710cb5ce3f0..f7f70438d98703 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1953,10 +1953,8 @@ xfs_init_zones(void)
>  		goto out_destroy_trans_zone;
>  
>  	xfs_efd_zone = kmem_cache_create("xfs_efd_item",
> -					(sizeof(struct xfs_efd_log_item) +
> -					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
> -					sizeof(struct xfs_extent)),
> -					0, 0, NULL);
> +			xfs_efd_item_sizeof(XFS_EFD_MAX_FAST_EXTENTS),
> +			0, 0, NULL);
>  	if (!xfs_efd_zone)
>  		goto out_destroy_buf_item_zone;
>  
> -- 
> 2.30.1
> 
