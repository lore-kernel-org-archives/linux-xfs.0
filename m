Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53BCCC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D7F613C9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhDTRGB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232473AbhDTRGB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 13:06:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 915DE6100A;
        Tue, 20 Apr 2021 17:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618938329;
        bh=/8D7bUxVVQR0+8wk6Sfh6EcB4VGarFkTgaj6ewOvpXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gJx3ezrHRqFDxGGRo15KiYkcpjTBU4NyBSum11YeqJt/cufok6T6JfR/+Xg/MQu/2
         qfEf2mpI9GoHHaJL3L5axNiXZzYyhq4khIQPMNnjfqhZxNap0JVi+J3qOOLyLLN8C4
         bDt9cVh+A5tk2EiOwntTnc7mImL2aHVpQVkyQY1gyXgTfUGql5ngPM8dnUqmVGl/3B
         KkoS3XLWabzCYsfNWsaKROUXUSZYkPzbjLsC03mCNooFIhFbV2RbPpjU54TRYX03eU
         1Qi6mAqXYtFBYgQCOSmWADWwwdSI/QcuPRws+MtFhj5zJsQLeNoGg5p2k7XhX/Rdx0
         wtS6KqVJdhNGA==
Date:   Tue, 20 Apr 2021 10:05:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH 2/7] xfs: clean up the EFI and EFD log format handling
Message-ID: <20210420170529.GH3122264@magnolia>
References: <20210419082804.2076124-1-hch@lst.de>
 <20210419082804.2076124-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419082804.2076124-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 19, 2021 at 10:27:59AM +0200, Christoph Hellwig wrote:
> The extent structure embedded into the EFI and EFD items was originally
> defined as a structure with implicit padding, which makes it a mess
> to handle between 32-bit and 64-bit kernels as the 32-bit ABI packs them
> tight, while the 64-bit ABI implicitly adds an implicit 4-bye padding.
> Log recovery has been able to deal with both formats for a long time,
> although in a rather messy way where the default definition varies
> between the ABIs, but log recovery has two extra special cases for
> padded or unpadded variants.
> 
> Change this to always write the properly fully padded EFI and EFD
> structures to the log, and only special case the unpadded one during
> recovery.

Hmm... so the behavior change here is that 32-bit kernels will start
logging 16-byte xfs_extent structures (like 64-bit kernels)?  I see that
xfs_extent_32 was added for 2.6.18; won't this break recovery on
everything from before that?

Granted, 2.6.17 came out 15 years ago and the last 2.6.16 LTS kernel was
released in 2008 so maybe we don't care, but this would seem to be a
breaking change, right?  This seems like a reasonable change for all V5
filesystems (since that format emerged well after 2.6.18), but not so
good for V4.

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_log_format.h |  49 ++++++--------
>  fs/xfs/xfs_extfree_item.c      | 115 ++++++++++++++-------------------
>  fs/xfs/xfs_extfree_item.h      |   2 +-
>  fs/xfs/xfs_ondisk.h            |   5 +-
>  4 files changed, 71 insertions(+), 100 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index ea0fe9f121adff..639035052b4f65 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -542,56 +542,43 @@ xfs_blft_from_flags(struct xfs_buf_log_format *blf)
>  /*
>   * EFI/EFD log format definitions
>   */
> -typedef struct xfs_extent {
> -	xfs_fsblock_t	ext_start;
> -	xfs_extlen_t	ext_len;
> -} xfs_extent_t;
>  
> -/*
> - * Since an xfs_extent_t has types (start:64, len: 32)
> - * there are different alignments on 32 bit and 64 bit kernels.
> - * So we provide the different variants for use by a
> - * conversion routine.
> - */
> -typedef struct xfs_extent_32 {
> -	uint64_t	ext_start;
> -	uint32_t	ext_len;
> -} __attribute__((packed)) xfs_extent_32_t;
> -
> -typedef struct xfs_extent_64 {
> +struct xfs_extent {
>  	uint64_t	ext_start;
>  	uint32_t	ext_len;
>  	uint32_t	ext_pad;
> -} xfs_extent_64_t;
> +};
>  
>  /*
>   * This is the structure used to lay out an efi log item in the
>   * log.  The efi_extents field is a variable size array whose
>   * size is given by efi_nextents.
>   */
> -typedef struct xfs_efi_log_format {
> +struct xfs_efi_log_format {
>  	uint16_t		efi_type;	/* efi log item type */
>  	uint16_t		efi_size;	/* size of this item */
>  	uint32_t		efi_nextents;	/* # extents to free */
>  	uint64_t		efi_id;		/* efi identifier */
> -	xfs_extent_t		efi_extents[1];	/* array of extents to free */
> -} xfs_efi_log_format_t;
> +	struct xfs_extent	efi_extents[1];	/* array of extents to free */
> +};
>  
> -typedef struct xfs_efi_log_format_32 {
> -	uint16_t		efi_type;	/* efi log item type */
> -	uint16_t		efi_size;	/* size of this item */
> -	uint32_t		efi_nextents;	/* # extents to free */
> -	uint64_t		efi_id;		/* efi identifier */
> -	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
> -} __attribute__((packed)) xfs_efi_log_format_32_t;
> +/*
> + * Version of the xfs_extent and xfs_efi_log_format structures that do not
> + * contain padding.  These used to be written to the log by older 32-bit kernels
> + * and will be dealt with transparently by log recovery.
> + */
> +struct xfs_extent_32 {
> +	uint64_t	ext_start;
> +	uint32_t	ext_len;
> +} __attribute__((packed));
>  
> -typedef struct xfs_efi_log_format_64 {
> +struct xfs_efi_log_format_32 {
>  	uint16_t		efi_type;	/* efi log item type */
>  	uint16_t		efi_size;	/* size of this item */
>  	uint32_t		efi_nextents;	/* # extents to free */
>  	uint64_t		efi_id;		/* efi identifier */
> -	xfs_extent_64_t		efi_extents[1];	/* array of extents to free */
> -} xfs_efi_log_format_64_t;
> +	struct xfs_extent_32	efi_extents[1];	/* array of extents to free */
> +} __attribute__((packed));
>  
>  /*
>   * This is the structure used to lay out an efd log item in the
> @@ -603,7 +590,7 @@ struct xfs_efd_log_format {
>  	uint16_t		efd_size;	/* size of this item */
>  	uint32_t		efd_nextents;	/* # of extents freed */
>  	uint64_t		efd_efi_id;	/* id of corresponding efi */
> -	xfs_extent_t		efd_extents[1];	/* array of extents freed */
> +	struct xfs_extent	efd_extents[1];	/* array of extents freed */
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index ac17fdb9283489..ed8d0790908ea7 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -74,7 +74,7 @@ xfs_efi_item_sizeof(
>  	struct xfs_efi_log_item *efip)
>  {
>  	return sizeof(struct xfs_efi_log_format) +
> -	       (efip->efi_format.efi_nextents - 1) * sizeof(xfs_extent_t);
> +	       (efip->efi_format.efi_nextents - 1) * sizeof(struct xfs_extent);
>  }
>  
>  STATIC void
> @@ -158,7 +158,7 @@ xfs_efi_init(
>  	ASSERT(nextents > 0);
>  	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
>  		size = (uint)(sizeof(struct xfs_efi_log_item) +
> -			((nextents - 1) * sizeof(xfs_extent_t)));
> +			((nextents - 1) * sizeof(struct xfs_extent)));
>  		efip = kmem_zalloc(size, 0);
>  	} else {
>  		efip = kmem_cache_zalloc(xfs_efi_zone,
> @@ -174,61 +174,6 @@ xfs_efi_init(
>  	return efip;
>  }
>  
> -/*
> - * Copy an EFI format buffer from the given buf, and into the destination
> - * EFI format structure.
> - * The given buffer can be in 32 bit or 64 bit form (which has different padding),
> - * one of which will be the native format for this kernel.
> - * It will handle the conversion of formats if necessary.
> - */
> -STATIC int
> -xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
> -{
> -	xfs_efi_log_format_t *src_efi_fmt = buf->i_addr;
> -	uint i;
> -	uint len = sizeof(xfs_efi_log_format_t) + 
> -		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_t);  
> -	uint len32 = sizeof(xfs_efi_log_format_32_t) + 
> -		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_32_t);  
> -	uint len64 = sizeof(xfs_efi_log_format_64_t) + 
> -		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_64_t);  
> -
> -	if (buf->i_len == len) {
> -		memcpy((char *)dst_efi_fmt, (char*)src_efi_fmt, len);
> -		return 0;
> -	} else if (buf->i_len == len32) {
> -		xfs_efi_log_format_32_t *src_efi_fmt_32 = buf->i_addr;
> -
> -		dst_efi_fmt->efi_type     = src_efi_fmt_32->efi_type;
> -		dst_efi_fmt->efi_size     = src_efi_fmt_32->efi_size;
> -		dst_efi_fmt->efi_nextents = src_efi_fmt_32->efi_nextents;
> -		dst_efi_fmt->efi_id       = src_efi_fmt_32->efi_id;
> -		for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
> -			dst_efi_fmt->efi_extents[i].ext_start =
> -				src_efi_fmt_32->efi_extents[i].ext_start;
> -			dst_efi_fmt->efi_extents[i].ext_len =
> -				src_efi_fmt_32->efi_extents[i].ext_len;
> -		}
> -		return 0;
> -	} else if (buf->i_len == len64) {
> -		xfs_efi_log_format_64_t *src_efi_fmt_64 = buf->i_addr;
> -
> -		dst_efi_fmt->efi_type     = src_efi_fmt_64->efi_type;
> -		dst_efi_fmt->efi_size     = src_efi_fmt_64->efi_size;
> -		dst_efi_fmt->efi_nextents = src_efi_fmt_64->efi_nextents;
> -		dst_efi_fmt->efi_id       = src_efi_fmt_64->efi_id;
> -		for (i = 0; i < dst_efi_fmt->efi_nextents; i++) {
> -			dst_efi_fmt->efi_extents[i].ext_start =
> -				src_efi_fmt_64->efi_extents[i].ext_start;
> -			dst_efi_fmt->efi_extents[i].ext_len =
> -				src_efi_fmt_64->efi_extents[i].ext_len;
> -		}
> -		return 0;
> -	}
> -	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> -	return -EFSCORRUPTED;
> -}
> -
>  static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
>  {
>  	return container_of(lip, struct xfs_efd_log_item, efd_item);
> @@ -254,7 +199,7 @@ xfs_efd_item_sizeof(
>  	struct xfs_efd_log_item *efdp)
>  {
>  	return sizeof(struct xfs_efd_log_format) +
> -	       (efdp->efd_format.efd_nextents - 1) * sizeof(xfs_extent_t);
> +	       (efdp->efd_format.efd_nextents - 1) * sizeof(struct xfs_extent);
>  }
>  
>  STATIC void
> @@ -687,6 +632,36 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
>  	.iop_relog	= xfs_efi_item_relog,
>  };
>  
> +/*
> + * Convert from an unpadded EFI log item written by old 32-bit kernels to the
> + * proper format.
> + */
> +static int
> +xfs_efi_copy_format_32(
> +	struct xfs_efi_log_format	*dst,
> +	struct xfs_log_iovec		*buf)
> +{
> +	struct xfs_efi_log_format_32	*src = buf->i_addr;
> +	unsigned int			i;
> +
> +	if (buf->i_len != sizeof(*src) +
> +	    (src->efi_nextents - 1) * sizeof(struct xfs_extent_32)) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	dst->efi_type = src->efi_type;
> +	dst->efi_size = src->efi_size;
> +	dst->efi_nextents = src->efi_nextents;
> +	dst->efi_id = src->efi_id;
> +	for (i = 0; i < dst->efi_nextents; i++) {
> +		dst->efi_extents[i].ext_start = src->efi_extents[i].ext_start;
> +		dst->efi_extents[i].ext_len = src->efi_extents[i].ext_len;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * This routine is called to create an in-core extent free intent
>   * item from the efi format structure which was logged on disk.
> @@ -703,18 +678,22 @@ xlog_recover_efi_commit_pass2(
>  {
>  	struct xfs_mount		*mp = log->l_mp;
>  	struct xfs_efi_log_item		*efip;
> -	struct xfs_efi_log_format	*efi_formatp;
> +	struct xfs_log_iovec		*buf = &item->ri_buf[0];
> +	struct xfs_efi_log_format	*src = buf->i_addr;
>  	int				error;
>  
> -	efi_formatp = item->ri_buf[0].i_addr;
> +	efip = xfs_efi_init(mp, src->efi_nextents);
>  
> -	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
> -	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
> -	if (error) {
> -		xfs_efi_item_free(efip);
> -		return error;
> +	if (buf->i_len != sizeof(*src) +
> +	    (src->efi_nextents - 1) * sizeof(struct xfs_extent)) {
> +		error = xfs_efi_copy_format_32(&efip->efi_format, buf);
> +		if (error)
> +			goto out_free_efi;
> +	} else {
> +		memcpy(&efip->efi_format, src, buf->i_len);
>  	}
> -	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
> +
> +	atomic_set(&efip->efi_next_extent, efip->efi_format.efi_nextents);
>  	/*
>  	 * Insert the intent into the AIL directly and drop one reference so
>  	 * that finishing or canceling the work will drop the other.
> @@ -722,6 +701,10 @@ xlog_recover_efi_commit_pass2(
>  	xfs_trans_ail_insert(log->l_ailp, &efip->efi_item, lsn);
>  	xfs_efi_release(efip);
>  	return 0;
> +
> +out_free_efi:
> +	xfs_efi_item_free(efip);
> +	return error;
>  }
>  
>  const struct xlog_recover_item_ops xlog_efi_item_ops = {
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index 6b80452ad2a71b..e09afd0f63ff59 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -49,7 +49,7 @@ struct xfs_efi_log_item {
>  	struct xfs_log_item	efi_item;
>  	atomic_t		efi_refcount;
>  	atomic_t		efi_next_extent;
> -	xfs_efi_log_format_t	efi_format;
> +	struct xfs_efi_log_format efi_format;
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 7328ff92e0ee8a..739476f7dffa21 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -118,10 +118,11 @@ xfs_check_ondisk_structs(void)
>  	/* log structures */
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format,	32);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format,	32);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	28);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	32);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_extent,		16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
>  	XFS_CHECK_STRUCT_SIZE(xfs_ictimestamp_t,		8);
> -- 
> 2.30.1
> 
