Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75F72641FB
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 14:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919965; cv=none; b=Agkhz3ghWe/Hl3d65KzTGfCxU0tEiCBVt/aAIqE5NgeClekXtrCcLAJbr42fZlcTlatbqgr0TVPYGuGfZXmd65/VEpdyB/isYi56/NL1sRI6VA5dQA2465Y3afh4fbICZSTyJrgydnuLjC/tZ59GbMjUNrxiqWDO9R2urtxEjog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919965; c=relaxed/simple;
	bh=jfIsSFWJHnpcmVB81tLvGYNJolSi7DjUqLZvwajRBT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+osVIGUDe8tJHYPqDBl4xdHfgyNA/GizBw6hRNJiEASnyatuRKJigAUh3ahQxXU/6CIOnw96LWD8AYbUVhIunj2vlvgkyvDhGjQzYSSbTXTCNSDiQOhV/m+pBNU49P0f6qd41kuWsAZIEerFyVsz5IqT1pGwCJmF04YvQ+MjG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjDk2IiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjDk2IiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A18C4CEE7;
	Fri, 31 Oct 2025 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761919965;
	bh=jfIsSFWJHnpcmVB81tLvGYNJolSi7DjUqLZvwajRBT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WjDk2IiFGn85jCWRy4gWEiL6jqswcD/bSEtl+ZUrgywhPb45t3e3pFRJHl5btGErt
	 V26p6PH9MONirzcVgk5hPHjVdJKlXypK4JxYb9WCR4R31fJZps43k5zJDPaj0gcKW0
	 Ugs5FoiHg7GzoYYQG6w8n+652y/pufi2kIDOowS3KXeF7qMd3Q9zXNAb7ObtiLfEuO
	 bhGHNGzMHiZdzPIvyAXfBWnvmRVNKFAtbTf1ZmBLVwfMyThcJRokyutX3K90Xz1p3o
	 eQeDe/9GFFUGqrvRiNFKCFDrN6H+Gkezs1SWu83aAUXb6oSw8kXJP8aMJFhKYE3mBK
	 JiDyJJ8+GMZ6w==
Date: Fri, 31 Oct 2025 15:12:41 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 6/9] xfs: remove xlog_in_core_2_t
Message-ID: <hw3mchhycpolms3xa4giv5ka7gqvbkug5ys4egqizzqbzxf57e@lfrflc4nmuuy>
References: <20251027070610.729960-1-hch@lst.de>
 <Wj9dSffsmpCnFMQyP6EXvgJO-0ViR49p2M4n6XTG0WQc_W-ly9pzJ4g70Og6--Sc2b_At1UZlWoIFs_36-PERw==@protonmail.internalid>
 <20251027070610.729960-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027070610.729960-7-hch@lst.de>

On Mon, Oct 27, 2025 at 08:05:53AM +0100, Christoph Hellwig wrote:
> xlog_in_core_2_t is a really odd type, not only is it grossly
> misnamed because it actually is an on-disk structure, but it also
> reprents the actual on-disk structure in a rather odd way.
> 
> A v1 or small v2 log header look like:
> 
> 	+-----------------------+
> 	|      xlog_record      |
> 	+-----------------------+
> 
> while larger v2 log headers look like:
> 
> 	+-----------------------+
> 	|      xlog_record      |
> 	+-----------------------+
> 	|  xlog_rec_ext_header  |
> 	+-------------------+---+
> 	|         .....         |
> 	+-----------------------+
> 	|  xlog_rec_ext_header  |
> 	+-----------------------+
> 
> I.e., the ext headers are a variable sized array at the end of the
> header.  So instead of declaring a union of xlog_rec_header,
> xlog_rec_ext_header and padding to BBSIZE, add the proper padding to
> struct struct xlog_rec_header and struct xlog_rec_ext_header, and
> add a variable sized array of the latter to the former.  This also
> exposes the somewhat unusual scope of the log checksums, which is
> made explicitly now by adding proper padding and macro designating
> the actual payload length.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_log_format.h | 31 +++++++++++++++----------------
>  fs/xfs/libxfs/xfs_ondisk.h     |  6 ++++--
>  fs/xfs/xfs_log.c               | 21 ++++++---------------
>  fs/xfs/xfs_log_priv.h          |  3 +--
>  4 files changed, 26 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 91a841ea5bb3..4cb69bd285ca 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -126,6 +126,16 @@ struct xlog_op_header {
>  #define XLOG_FMT XLOG_FMT_LINUX_LE
>  #endif
> 
> +struct xlog_rec_ext_header {
> +	__be32		xh_cycle;	/* write cycle of log */
> +	__be32		xh_cycle_data[XLOG_CYCLE_DATA_SIZE];
> +	__u8		xh_reserved[252];
> +};
> +
> +/* actual ext header payload size for checksumming */
> +#define XLOG_REC_EXT_SIZE \
> +	offsetofend(struct xlog_rec_ext_header, xh_cycle_data)
> +
>  typedef struct xlog_rec_header {
>  	__be32	  h_magicno;	/* log record (LR) identifier		:  4 */
>  	__be32	  h_cycle;	/* write cycle of log			:  4 */
> @@ -161,30 +171,19 @@ typedef struct xlog_rec_header {
>  	 * (little-endian) architectures.
>  	 */
>  	__u32	  h_pad0;
> +
> +	__u8	  h_reserved[184];
> +	struct xlog_rec_ext_header h_ext[];
>  } xlog_rec_header_t;
> 
>  #ifdef __i386__
>  #define XLOG_REC_SIZE		offsetofend(struct xlog_rec_header, h_size)
> -#define XLOG_REC_SIZE_OTHER	sizeof(struct xlog_rec_header)
> +#define XLOG_REC_SIZE_OTHER	offsetofend(struct xlog_rec_header, h_pad0)
>  #else
> -#define XLOG_REC_SIZE		sizeof(struct xlog_rec_header)
> +#define XLOG_REC_SIZE		offsetofend(struct xlog_rec_header, h_pad0)
>  #define XLOG_REC_SIZE_OTHER	offsetofend(struct xlog_rec_header, h_size)
>  #endif /* __i386__ */
> 
> -typedef struct xlog_rec_ext_header {
> -	__be32	  xh_cycle;	/* write cycle of log			: 4 */
> -	__be32	  xh_cycle_data[XLOG_CYCLE_DATA_SIZE];		/*	: 256 */
> -} xlog_rec_ext_header_t;
> -
> -/*
> - * Quite misnamed, because this union lays out the actual on-disk log buffer.
> - */
> -typedef union xlog_in_core2 {
> -	xlog_rec_header_t	hic_header;
> -	xlog_rec_ext_header_t	hic_xheader;
> -	char			hic_sector[XLOG_HEADER_SIZE];
> -} xlog_in_core_2_t;
> -
>  /* not an on-disk structure, but needed by log recovery in userspace */
>  struct xfs_log_iovec {
>  	void		*i_addr;	/* beginning address of region */
> diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
> index 7bfa3242e2c5..2e9715cc1641 100644
> --- a/fs/xfs/libxfs/xfs_ondisk.h
> +++ b/fs/xfs/libxfs/xfs_ondisk.h
> @@ -174,9 +174,11 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_rud_log_format,	16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
> -	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_header,		328);
> -	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_ext_header,	260);
> +	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_header,		512);
> +	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_ext_header,	512);
> 
> +	XFS_CHECK_OFFSET(struct xlog_rec_header, h_reserved,		328);
> +	XFS_CHECK_OFFSET(struct xlog_rec_ext_header, xh_reserved,	260);
>  	XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
>  	XFS_CHECK_OFFSET(struct xfs_cui_log_format, cui_extents,	16);
>  	XFS_CHECK_OFFSET(struct xfs_rui_log_format, rui_extents,	16);
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index acddab467b77..1fe3abbd3d36 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1526,12 +1526,8 @@ xlog_pack_data(
>  		dp += BBSIZE;
>  	}
> 
> -	if (xfs_has_logv2(log->l_mp)) {
> -		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)iclog->ic_header;
> -
> -		for (i = 1; i < log->l_iclog_heads; i++)
> -			xhdr[i].hic_xheader.xh_cycle = cycle_lsn;
> -	}
> +	for (i = 0; i < log->l_iclog_heads - 1; i++)
> +		rhead->h_ext[i].xh_cycle = cycle_lsn;
>  }
> 
>  /*
> @@ -1556,16 +1552,11 @@ xlog_cksum(
> 
>  	/* ... then for additional cycle data for v2 logs ... */
>  	if (xfs_has_logv2(log->l_mp)) {
> -		union xlog_in_core2 *xhdr = (union xlog_in_core2 *)rhead;
> -		int		i;
> -		int		xheads;
> +		int		xheads, i;
> 
> -		xheads = DIV_ROUND_UP(size, XLOG_HEADER_CYCLE_SIZE);
> -
> -		for (i = 1; i < xheads; i++) {
> -			crc = crc32c(crc, &xhdr[i].hic_xheader,
> -				     sizeof(struct xlog_rec_ext_header));
> -		}
> +		xheads = DIV_ROUND_UP(size, XLOG_HEADER_CYCLE_SIZE) - 1;
> +		for (i = 0; i < xheads; i++)
> +			crc = crc32c(crc, &rhead->h_ext[i], XLOG_REC_EXT_SIZE);
>  	}
> 
>  	/* ... and finally for the payload */
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index f1aed6e8f747..ac98ac71152d 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -716,11 +716,10 @@ xlog_item_space(
>  static inline __be32 *xlog_cycle_data(struct xlog_rec_header *rhead, unsigned i)
>  {
>  	if (i >= XLOG_CYCLE_DATA_SIZE) {
> -		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
>  		unsigned	j = i / XLOG_CYCLE_DATA_SIZE;
>  		unsigned	k = i % XLOG_CYCLE_DATA_SIZE;
> 
> -		return &xhdr[j].hic_xheader.xh_cycle_data[k];
> +		return &rhead->h_ext[j - 1].xh_cycle_data[k];
>  	}
> 
>  	return &rhead->h_cycle_data[i];
> --
> 2.47.3
> 
