Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80576C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 16:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FC9560FEA
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 16:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhDTQ1S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 12:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232767AbhDTQ1R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 12:27:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 097A7613CE;
        Tue, 20 Apr 2021 16:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618936006;
        bh=PY+pYbLNAsh9Em4iEChYXCtt4DPJd+YJB3YycuvvWGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PT86jEaKS4o4JoOF1B+Oa8BMl/cV6qgWu0RDBIrJjWgXSCHsKJ4t9OHEpzreWzjlt
         5ihMCvgPqQ/jlHfRnI7NtN91GxG9Kc4dYlaFLVBQQfh92U+v8whCfQTLvZd7nzOKlh
         B00tWp0/p/zXNETHGDLeHzFNagMzH7tyVWHu2M/97B93GEdxJ9gVKirxDxJNnonqYf
         086rK5+tjZZHbT6d6P3BBsjxcWpDYuKHBSE3/4UWtPswE0kgI27Cn1hWHXJYi+Hf1w
         BEuKdG4ZJ+hZQ9BoePuw/b73U1Eux9q+4HKSHa/7Nh8VcL+5DiRsw3crN+l7sPq5Gq
         F4kxPwkX+IoqA==
Date:   Tue, 20 Apr 2021 09:26:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH 1/7] xfs: remove the EFD size asserts in
 xlog_recover_efd_commit_pass2
Message-ID: <20210420162645.GF3122264@magnolia>
References: <20210419082804.2076124-1-hch@lst.de>
 <20210419082804.2076124-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210419082804.2076124-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 19, 2021 at 10:27:58AM +0200, Christoph Hellwig wrote:
> We never actually look at the extent array in the efd items, and should
> eventually stop writing them out at all when it is time for a incompat
> log change.  Ѕo don't bother with the asserts at all, and thus with the
> the structures defined just to be used with it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable enough...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_log_format.h | 20 ++------------------
>  fs/xfs/xfs_extfree_item.c      | 10 ++--------
>  fs/xfs/xfs_extfree_item.h      |  2 +-
>  fs/xfs/xfs_ondisk.h            |  2 --
>  4 files changed, 5 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 8bd00da6d2a40f..ea0fe9f121adff 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -598,29 +598,13 @@ typedef struct xfs_efi_log_format_64 {
>   * log.  The efd_extents array is a variable size array whose
>   * size is given by efd_nextents;
>   */
> -typedef struct xfs_efd_log_format {
> +struct xfs_efd_log_format {
>  	uint16_t		efd_type;	/* efd log item type */
>  	uint16_t		efd_size;	/* size of this item */
>  	uint32_t		efd_nextents;	/* # of extents freed */
>  	uint64_t		efd_efi_id;	/* id of corresponding efi */
>  	xfs_extent_t		efd_extents[1];	/* array of extents freed */
> -} xfs_efd_log_format_t;
> -
> -typedef struct xfs_efd_log_format_32 {
> -	uint16_t		efd_type;	/* efd log item type */
> -	uint16_t		efd_size;	/* size of this item */
> -	uint32_t		efd_nextents;	/* # of extents freed */
> -	uint64_t		efd_efi_id;	/* id of corresponding efi */
> -	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
> -} __attribute__((packed)) xfs_efd_log_format_32_t;
> -
> -typedef struct xfs_efd_log_format_64 {
> -	uint16_t		efd_type;	/* efd log item type */
> -	uint16_t		efd_size;	/* size of this item */
> -	uint32_t		efd_nextents;	/* # of extents freed */
> -	uint64_t		efd_efi_id;	/* id of corresponding efi */
> -	xfs_extent_64_t		efd_extents[1];	/* array of extents freed */
> -} xfs_efd_log_format_64_t;
> +};
>  
>  /*
>   * RUI/RUD (reverse mapping) log format definitions
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 93223ebb33721e..ac17fdb9283489 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -253,7 +253,7 @@ static inline int
>  xfs_efd_item_sizeof(
>  	struct xfs_efd_log_item *efdp)
>  {
> -	return sizeof(xfs_efd_log_format_t) +
> +	return sizeof(struct xfs_efd_log_format) +
>  	       (efdp->efd_format.efd_nextents - 1) * sizeof(xfs_extent_t);
>  }
>  
> @@ -743,13 +743,7 @@ xlog_recover_efd_commit_pass2(
>  	struct xlog_recover_item	*item,
>  	xfs_lsn_t			lsn)
>  {
> -	struct xfs_efd_log_format	*efd_formatp;
> -
> -	efd_formatp = item->ri_buf[0].i_addr;
> -	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
> -		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
> -	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
> -		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
> +	struct xfs_efd_log_format	*efd_formatp = item->ri_buf[0].i_addr;
>  
>  	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id);
>  	return 0;
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index cd2860c875bf50..6b80452ad2a71b 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -61,7 +61,7 @@ struct xfs_efd_log_item {
>  	struct xfs_log_item	efd_item;
>  	struct xfs_efi_log_item *efd_efip;
>  	uint			efd_next_extent;
> -	xfs_efd_log_format_t	efd_format;
> +	struct xfs_efd_log_format efd_format;
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 0aa87c2101049c..7328ff92e0ee8a 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -118,8 +118,6 @@ xfs_check_ondisk_structs(void)
>  	/* log structures */
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	28);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	32);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	32);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
> -- 
> 2.30.1
> 
