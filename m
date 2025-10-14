Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA872E7BB5
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 22:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479678; cv=none; b=Mqs/hwz3169a8+A5Itr07+bYGXF96p7lo+wVlGUbzEZ5w7dZ5pROS+asTyZ9IdrfRiCnmUvIsuPNsbohyucjFj8/4lxhVcyIen+JkIzMdBFJu39BzcOewMU1dWhje5Fy6bNgdaDZKagBx8rFCbl67mlMOAiWxWDokEtdNBQ/lo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479678; c=relaxed/simple;
	bh=el4Fpo1GkcQMVhupmxZLSHknSJ/COvHU4KjBvi/XKiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxfcdD48nYX8jv/rOWMi2Kzpm2M2EEsOdrNVCItClR+KFQIKnV+H0EIYCNzHqL86ONSpB4YNmO6jU3/k1rWTfvG+XODfZn0/bwJqQIEEFwhmFUfU4yarhi6pZOGVjlJL2jaa4IJEUPJHkrHD01ippnlKeAsCy0jgZJWkHhfPLBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cc2OurqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cc2OurqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFCAC4CEE7;
	Tue, 14 Oct 2025 22:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760479677;
	bh=el4Fpo1GkcQMVhupmxZLSHknSJ/COvHU4KjBvi/XKiE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cc2OurqYSBIfRMGjimXaEZ1ztf7LApBm8rP+y7WBEIsjXiF5Nk6jue+wQamj68YLA
	 2jxGTPLxdRuc+o7NAR967JjSnmfG396XxPc/lbL5s4aWea0tkZ6Dt+oFJyfwCa2NG8
	 oYXT1V8RqWPD8Qq1yk0eQUHL168HTnRVWdUlGVUeRdG0u922VXyxKgR/pW53ug8rb/
	 c99B1i52c5d70v4DgcGfBXddi9ZlUv/lV1Sl7XB65rUMAja+3HeP/GDNQy7tyCLbtf
	 QB8IY7MopjAv9ijpZWbbDpvzVeSm0fySUjXn/jFy9tES3tSfrGZgX3hMNALy8DOXl/
	 wQeHxA0pLQeQg==
Date: Tue, 14 Oct 2025 15:07:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: remove xlog_in_core_2_t
Message-ID: <20251014220757.GL6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024228.4109032-7-hch@lst.de>

On Mon, Oct 13, 2025 at 11:42:10AM +0900, Christoph Hellwig wrote:
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

Just out of curiosity, why do we reserve so much space at the end of the
extended header?  Wouldn't it have been more efficient to fill all 508
bytes with xh_cycle_data?

Oh well, water under the bridge now.

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

Ok, so you're explicitly padding struct xlog_rec_header and
xlog_rec_ext_header to be 512 bytes now, and making the xlog_rec_header
have a VLA of xlog_rec_ext_header.

The log buffer crc is computed from the start of xlog_rec_header::h_crc
to the end(ish) of the xlog_rec_header; and the first 256 bytes of each
xlog_rec_ext_header, right?

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

That /was/ effin' weird.

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

Is the xfs_has_logv2 still necessary here?

What happens if log->l_iclog_heads > 1 && !logv2?  Or has the kernel
already checked for that and aborted the mount?

(I /think/ the data format changes look ok, but wowee this patch
generated questions :P)

--D

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
> 
