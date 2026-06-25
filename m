Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D23D23E25B
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782406920; cv=none; b=pgQTFsnmC7ZLeFsx6pU5THGvUjh1AXPMnzc7eJ9ieRjsDmWoAc8m3ELnwfTJbyQ9KT1pf8MXlLAFxLbzH3I6mK9rbAz2mDYIC+7C51NzDV65+JmevXVETa2taUk5IWQRtcH7rq2I6FowRj1wyowd+PDw2Ul7Dx/8fhOikjXWWq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782406920; c=relaxed/simple;
	bh=Ai3fBLl5NuYzALOJGbxQ2+BaaAie9IoLilBiFIFKat0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxcPc1IkrTGJfPp/raksWA1ZJW8lCZAo95sFP0yo/DwkgFLNub5+P55SkhSvAyH5DySGAL3jMx06XSNiXNkW2kgs6IEMKnfXW+vw5d2WifyKJ8lKrPhaR8ZRsW3fBgBwjU+N8tsua2k/jlR/jSk/J242yIL3fDa+e6+irVfL79o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NabH8ix0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NabH8ix0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 18D141F00A3A;
	Thu, 25 Jun 2026 17:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782406919;
	bh=tafNYPjoOeo1uXzagWp8Hha2Xx51e4ZciEKk1AmH4Hk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NabH8ix0ZY7HQ7Jl4PsaHL+RG/Gqo3S6djHIn6TRuaA5+CoWmcNqRjprUN4pEqNcs
	 KEpVaNY0v7TRR3QQBfPSpCvTU2tdijekDpybfYuYuo0Pd8gEiPU2h1QlFkGup3FpU5
	 dBBY5oWibufryn9dHI1ry3LZMgCoqjGJPkpTAK8VIKiAfPrSrrL/vvuE+aEC6OJBES
	 ImASuJROZKidl+PROhcFP1ra/KzVEfIhIITKSo8T13zVVKjp4fL/inD75vlnP1V/T3
	 clNUgyulLYe3wVJGlsyKaMwfozeol25cduIpgAuH5m+G8pvEg2kjBuxDEdqMpAVjuR
	 J5tDuI714wyPg==
Date: Thu, 25 Jun 2026 10:01:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	dgc@kernel.org, gost.dev@samsung.com,
	Zhang Yi <yi.zhang@huaweicloud.com>, pankaj.raghav@linux.dev,
	andres@anarazel.de, kundan.kumar@samsung.com, hch@lst.de,
	cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH v8 1/2] xfs: add an allocation mode to
 xfs_alloc_file_space()
Message-ID: <20260625170158.GB6078@frogsfrogsfrogs>
References: <20260625114550.4109104-1-p.raghav@samsung.com>
 <20260625114550.4109104-2-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625114550.4109104-2-p.raghav@samsung.com>

On Thu, Jun 25, 2026 at 01:45:49PM +0200, Pankaj Raghav wrote:
> xfs_alloc_file_space() hardcodes XFS_BMAPI_PREALLOC to preallocate
> unwritten extents across a range.
> 
> In preparation for FALLOC_FL_WRITE_ZEROES, add an explicit allocation
> mode argument, enum xfs_alloc_file_space_mode, and derive the xfs_bmapi
> flags from it. The only mode for now is XFS_ALLOC_FILE_SPACE_PREALLOC,
> which preallocates unwritten extents and marks the inode as preallocated
> exactly as before, so there is no functional change.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

LGTM,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 25 +++++++++++++++++++++----
>  fs/xfs/xfs_bmap_util.h |  6 +++++-
>  fs/xfs/xfs_file.c      |  9 ++++++---
>  3 files changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 3b9f262f8e91..e5424d010a69 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -642,11 +642,19 @@ xfs_free_eofblocks(
>  	return error;
>  }
>  
> +/*
> + * Allocate space for a file according to @mode:
> + *
> + * XFS_ALLOC_FILE_SPACE_PREALLOC:
> + * Preallocate unwritten extents over holes across the range and mark the inode
> + * as preallocated.
> + */
>  int
>  xfs_alloc_file_space(
>  	struct xfs_inode	*ip,
>  	xfs_off_t		offset,
> -	xfs_off_t		len)
> +	xfs_off_t		len,
> +	enum xfs_alloc_file_space_mode mode)
>  {
>  	xfs_mount_t		*mp = ip->i_mount;
>  	xfs_off_t		count;
> @@ -657,6 +665,7 @@ xfs_alloc_file_space(
>  	int			rt;
>  	xfs_trans_t		*tp;
>  	xfs_bmbt_irec_t		imaps[1], *imapp;
> +	uint32_t		bmapi_flags, nr_exts;
>  	int			error;
>  
>  	if (xfs_is_always_cow_inode(ip))
> @@ -674,6 +683,15 @@ xfs_alloc_file_space(
>  	if (len <= 0)
>  		return -EINVAL;
>  
> +	switch (mode) {
> +	case XFS_ALLOC_FILE_SPACE_PREALLOC:
> +		bmapi_flags = XFS_BMAPI_PREALLOC;
> +		nr_exts = XFS_IEXT_ADD_NOSPLIT_CNT;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
>  	rt = XFS_IS_REALTIME_INODE(ip);
>  	extsz = xfs_get_extsz_hint(ip);
>  
> @@ -733,8 +751,7 @@ xfs_alloc_file_space(
>  		if (error)
>  			break;
>  
> -		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
> -				XFS_IEXT_ADD_NOSPLIT_CNT);
> +		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK, nr_exts);
>  		if (error)
>  			goto error;
>  
> @@ -748,7 +765,7 @@ xfs_alloc_file_space(
>  		 * will eventually reach the requested range.
>  		 */
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> +				allocatesize_fsb, bmapi_flags, 0, imapp,
>  				&nimaps);
>  		if (error) {
>  			if (error != -ENOSR)
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index c477b3361630..232b4c48247e 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -55,8 +55,12 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  			     int *is_empty);
>  
>  /* preallocation and hole punch interface */
> +enum xfs_alloc_file_space_mode {
> +	XFS_ALLOC_FILE_SPACE_PREALLOC,
> +};
> +
>  int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
> -		xfs_off_t len);
> +		xfs_off_t len, enum xfs_alloc_file_space_mode mode);
>  int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
>  int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 845a97c9b063..e90ea6ebdc8e 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1406,7 +1406,8 @@ xfs_falloc_zero_range(
>  		len = round_up(offset + len, blksize) -
>  			round_down(offset, blksize);
>  		offset = round_down(offset, blksize);
> -		error = xfs_alloc_file_space(ip, offset, len);
> +		error = xfs_alloc_file_space(ip, offset, len,
> +				XFS_ALLOC_FILE_SPACE_PREALLOC);
>  	}
>  	if (error)
>  		return error;
> @@ -1432,7 +1433,8 @@ xfs_falloc_unshare_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_ALLOC_FILE_SPACE_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> @@ -1460,7 +1462,8 @@ xfs_falloc_allocate_range(
>  	if (error)
>  		return error;
>  
> -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
> +	error = xfs_alloc_file_space(XFS_I(inode), offset, len,
> +			XFS_ALLOC_FILE_SPACE_PREALLOC);
>  	if (error)
>  		return error;
>  	return xfs_falloc_setsize(file, new_size);
> -- 
> 2.51.2
> 
> 
