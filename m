Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9EB6C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF97D613C9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhDTRQ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232473AbhDTRQ0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 13:16:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C12961076;
        Tue, 20 Apr 2021 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618938954;
        bh=atGiaCZK9C/q65dVM3NNHizFjfWvAUixgI5nL1VYVsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pQqa/nnhCrrROgTOKMbSghIY3KYGK2aPNaEZwoq0JufZNLgFTOmmk7gtMOJH1J5M0
         C89VhSVmMD8MbuMAe263gpIMkTJBCv5vzErwQ9VfTKHHR/IDZQ1Rg2H2zLhVjs6qsE
         v2k6TTOL4oahRGn+RfQaBrpPegwuHhRms0zjAcc7r7RUuRzM15GnGUfWiG+LGhVrdT
         CGswcHKKAMERAKjC+s+2JYx6+42IIBXOnACVwW4MfOQ0IuoCubsU19z5S9XLZnPxU9
         LVd1xxxRWFrwyvjhKjPg3yNOmyT/zv55GHNky3OT67Q/CV7Udf+5OhZL7NVM7H3XUD
         1tAkBn+5aPohw==
Date:   Tue, 20 Apr 2021 10:15:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH 7/7] xfs: Replace one-element arrays with flexible-array
 members
Message-ID: <20210420171553.GM3122264@magnolia>
References: <20210419082804.2076124-1-hch@lst.de>
 <20210419082804.2076124-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210419082804.2076124-8-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 19, 2021 at 10:28:04AM +0200, Christoph Hellwig wrote:
> From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> 
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of flexible-array members in
> multiple structures, instead of one-element arrays. Also, make use of
> the new struct_size() helper to properly calculate the size of some
> structures that contain flexible-array members.
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.9/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> [hch: rebased on top of the previous cleanups]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me besides the naming thing; with those resolved,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_log_format.h | 6 +++---
>  fs/xfs/xfs_extfree_item.c      | 9 +++------
>  fs/xfs/xfs_extfree_item.h      | 4 ++--
>  fs/xfs/xfs_ondisk.h            | 6 +++---
>  4 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 639035052b4f65..9b218c30659ad7 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -559,7 +559,7 @@ struct xfs_efi_log_format {
>  	uint16_t		efi_size;	/* size of this item */
>  	uint32_t		efi_nextents;	/* # extents to free */
>  	uint64_t		efi_id;		/* efi identifier */
> -	struct xfs_extent	efi_extents[1];	/* array of extents to free */
> +	struct xfs_extent	efi_extents[];	/* array of extents to free */
>  };
>  
>  /*
> @@ -577,7 +577,7 @@ struct xfs_efi_log_format_32 {
>  	uint16_t		efi_size;	/* size of this item */
>  	uint32_t		efi_nextents;	/* # extents to free */
>  	uint64_t		efi_id;		/* efi identifier */
> -	struct xfs_extent_32	efi_extents[1];	/* array of extents to free */
> +	struct xfs_extent_32	efi_extents[];	/* array of extents to free */
>  } __attribute__((packed));
>  
>  /*
> @@ -590,7 +590,7 @@ struct xfs_efd_log_format {
>  	uint16_t		efd_size;	/* size of this item */
>  	uint32_t		efd_nextents;	/* # of extents freed */
>  	uint64_t		efd_efi_id;	/* id of corresponding efi */
> -	struct xfs_extent	efd_extents[1];	/* array of extents freed */
> +	struct xfs_extent	efd_extents[];	/* array of extents freed */
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index a2abdfd3d076bf..8bea9c9ecf2042 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -73,8 +73,7 @@ static inline int
>  xfs_efi_log_item_sizeof(
>  	struct xfs_efi_log_format *elf)
>  {
> -	return sizeof(*elf) +
> -	       (elf->efi_nextents - 1) * sizeof(struct xfs_extent);
> +	return struct_size(elf, efi_extents, elf->efi_nextents);
>  }
>  
>  STATIC void
> @@ -194,8 +193,7 @@ static inline int
>  xfs_efd_log_item_sizeof(
>  	struct xfs_efd_log_format *elf)
>  {
> -	return sizeof(struct xfs_efd_log_format) +
> -	       (elf->efd_nextents - 1) * sizeof(struct xfs_extent);
> +	return struct_size(elf, efd_extents, elf->efd_nextents);
>  }
>  
>  STATIC void
> @@ -636,8 +634,7 @@ xfs_efi_copy_format_32(
>  	struct xfs_efi_log_format_32	*src = buf->i_addr;
>  	unsigned int			i;
>  
> -	if (buf->i_len != sizeof(*src) +
> -	    (src->efi_nextents - 1) * sizeof(struct xfs_extent_32)) {
> +	if (buf->i_len != struct_size(src, efi_extents, src->efi_nextents)) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>  		return -EFSCORRUPTED;
>  	}
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index 3bb62ef525f2e0..a01ce86145bb64 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -55,7 +55,7 @@ struct xfs_efi_log_item {
>  static inline int xfs_efi_item_sizeof(unsigned int nextents)
>  {
>  	return sizeof(struct xfs_efi_log_item) +
> -		(nextents - 1) * sizeof(struct xfs_extent);
> +		nextents * sizeof(struct xfs_extent);
>  }
>  
>  /*
> @@ -73,7 +73,7 @@ struct xfs_efd_log_item {
>  static inline int xfs_efd_item_sizeof(unsigned int nextents)
>  {
>  	return sizeof(struct xfs_efd_log_item) +
> -		(nextents - 1) * sizeof(struct xfs_extent);
> +		nextents * sizeof(struct xfs_extent);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 739476f7dffa21..fa4b590671bf58 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -118,9 +118,9 @@ xfs_check_ondisk_structs(void)
>  	/* log structures */
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format,	32);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format,	32);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format,	16);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent,		16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
> -- 
> 2.30.1
> 
