Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FC0280A58
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 20:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175956; cv=none; b=GJpHnPc4fUcZJvFOkSVY43pe8j024KlUIq+FTanwyQZ3GIwXS9pwT7yvnYlC69gzlrhmxBhkAncfC7skKQ6qUl4m9uwvUsqMS97by/J3knzphtSSv8pMSqzsNbUVFC+xLs4srWBZ8pIPes/5Iv1CQn6rKi/d+uKp6KqPv9Vv4lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175956; c=relaxed/simple;
	bh=/lrH3ivhiQu3seo7b2A44qX5uPNJbIqm66BRy3gAWOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V3AJ1zKLfU5/ZpKy/SzUZjP34sBgCChWAu6SN023cmJXK6kpIVFiGi1hScwaWzw4OVdkeRxDZjg1YCa5RIflezJWNlV14+XHQEUyKxUYcMQFTXpOIAgldgwjO4azswcyM10m8xRvwk1XFRAwdZ+iM3aueAxmGfgLWap3ikwSmzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xm/IXV9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xm/IXV9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4F8C19423;
	Tue, 10 Mar 2026 20:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773175955;
	bh=/lrH3ivhiQu3seo7b2A44qX5uPNJbIqm66BRy3gAWOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xm/IXV9rtQT1TevVLInr30Z90Lp191MF3fkkIXSxtjSS4MloZ8s0G0g/rEMU4gEQ0
	 BOkOHgWfHUaDBV6MGVdcI7ZNKYjGc+eQ8wpVDPV2T94xUTZA912StvSBap7SzzLPzt
	 M915VvElRiUEFdV2Xj21jWhY8/6z9L6BjBaxpIzycXPrP7rFqUJ/7ulmyfBSBHB6g/
	 58/e9EtIDHIUiT/wpPpQR1PTgLT4697TfQLINnif8O7LQKmk24Foa2O/2cGZPjVItT
	 6IqvctdaugkeGO221gicR2h5ceBXHksRs02Otp5aOhAa6HeDfMDhah+NlVW5UruqDg
	 0CNT4YLGPS06A==
Date: Tue, 10 Mar 2026 13:52:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org,
	pankaj.raghav@linux.dev, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v12 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
Message-ID: <20260310205235.GA1105363@frogsfrogsfrogs>
References: <20260310194245.848034-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310194245.848034-2-lukas@herbolt.com>

On Tue, Mar 10, 2026 at 08:42:46PM +0100, Lukas Herbolt wrote:
> Add support for FALLOC_FL_WRITE_ZEROES if the underlying device
> enable the unmap write zeroes operation.
> 
> Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  v12 changes:
> 	split from xfs_falloc_zero_range() into separate function
>  fs/xfs/xfs_file.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 48 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index fd049a1fc9c6..ede7be05d83e 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1318,6 +1318,49 @@ xfs_falloc_zero_range(
>  	return xfs_falloc_setsize(file, new_size);
>  }
>  
> +static int
> +xfs_falloc_write_zero_range(
> +	struct file		*file,
> +	int			mode,
> +	loff_t			offset,
> +	loff_t			len,
> +	struct xfs_zone_alloc_ctx *ac)
> +{
> +	struct inode		*inode = file_inode(file);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	unsigned int		blksize = i_blocksize(inode);
> +	loff_t			new_size = 0;
> +	int			error;
> +
> +	if (xfs_is_always_cow_inode(ip) ||
> +	    !bdev_write_zeroes_unmap_sectors(
> +		    xfs_inode_buftarg(ip)->bt_bdev))
> +		return -EOPNOTSUPP;
> +
> +	trace_xfs_zero_file_space(ip);

I think we want to have a separate tracepoint for write-zeroes, but TBH
the fallocate tracepoints all kinda suck in that we don't record the
range or any of the flags so... there's a minor cleanup to be done
separately.

In the meantime this looks ok provided it doesn't break fsx/fsstress?
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
> +	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
> +	if (error)
> +		return error;
> +
> +	error = xfs_free_file_space(ip, offset, len, ac);
> +	if (error)
> +		return error;
> +
> +	len = round_up(offset + len, blksize) - round_down(offset, blksize);
> +	offset = round_down(offset, blksize);
> +	error = xfs_alloc_file_space(ip, offset, len, XFS_BMAPI_PREALLOC);
> +	if (error)
> +		return error;
> +
> +	error = xfs_falloc_setsize(file, new_size);
> +	if (error)
> +		return error;
> +
> +	return xfs_alloc_file_space(ip, offset, len,
> +			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO);
> +}
> +
>  static int
>  xfs_falloc_unshare_range(
>  	struct file		*file,
> @@ -1377,7 +1420,7 @@ xfs_falloc_allocate_range(
>  		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
>  		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
>  		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
> -		 FALLOC_FL_UNSHARE_RANGE)
> +		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
>  
>  STATIC long
>  __xfs_file_fallocate(
> @@ -1423,6 +1466,10 @@ __xfs_file_fallocate(
>  	case FALLOC_FL_ZERO_RANGE:
>  		error = xfs_falloc_zero_range(file, mode, offset, len, ac);
>  		break;
> +	case FALLOC_FL_WRITE_ZEROES:
> +		error = xfs_falloc_write_zero_range(file, mode, offset,
> +				len, ac);
> +		break;
>  	case FALLOC_FL_UNSHARE_RANGE:
>  		error = xfs_falloc_unshare_range(file, mode, offset, len);
>  		break;
> -- 
> 2.53.0
> 
> 
