Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD067A730;
	Tue, 12 Mar 2024 22:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710281578; cv=none; b=W0oyxVzim0r2B1An1LQOFGhldxS/ONrZAWp89n8rkP3Eo8MY29R6ExNt0yZuyNaPQtdSHR5I5sxqzSKo7ZgHj3gLe4AtImSg7i68AkNxMH3Apg2bqYmhs/Rfn1Cp6z3psbm7YS/dd3thFZpvcLxE1h3hjccjSl4HH9YZEMqYZhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710281578; c=relaxed/simple;
	bh=9uq/j3Hgz3Vttrm8luZzODCRNkQqejQaOuzuZQeBZnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMgL34GtXktYBiHPdaDPheyQOto3J6N2MMgYNLsUB6IUx++/mW2D+2GVA2mOyaNfoW9Qj2BszlqYlWk1hvgMXWRmC1nZWEjPCEED7/eQsVJPUV4AiBlilYjg1S+0XxIbfTW8Ckq0/19xO1m0TFbY0PAAsmt/jHvxpml49CHJy+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nT2NL4iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nT2NL4iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549ACC433F1;
	Tue, 12 Mar 2024 22:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710281577;
	bh=9uq/j3Hgz3Vttrm8luZzODCRNkQqejQaOuzuZQeBZnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nT2NL4iyCmA0WNjwMrhLBIK3E4V5hxU/npyfBL3ZpzgemrK+gfAzrwixATP1A9cMm
	 lqfxnfHWZwbnKIE+e9ZzN5u34fAjg1bicAZ4fok8DUBLlUzRN04UQDVR9ydFeJVfQI
	 R2/+op6Tldx3OO5Y+weXXltAsTS1Nsv7mZJ7ARSQ4ZlRUqFj+y2HNovyoChWMprOmw
	 kZBTB4viIZakkq9mCZyoNIFXAFOrrkf7e7OPa4kaEWeMhnTWRry91/oGDEi1dVdUON
	 qpDdN8FWb9ma7yVsUTnESw4SoCeFknMHGAKsRyc2GeCYJteWUSqv4l0shIlmUnt2qw
	 zrfRatW5y/H2g==
Date: Tue, 12 Mar 2024 16:12:54 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] block: move discard checks into the ioctl handler
Message-ID: <ZfDTZpuumZSn6oPp@kbusch-mbp.mynextlight.net>
References: <20240312144532.1044427-1-hch@lst.de>
 <20240312144532.1044427-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312144532.1044427-2-hch@lst.de>

On Tue, Mar 12, 2024 at 08:45:27AM -0600, Christoph Hellwig wrote:
> @@ -95,6 +95,8 @@ static int compat_blkpg_ioctl(struct block_device *bdev,
>  static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
>  		unsigned long arg)
>  {
> +	sector_t bs_mask = (bdev_logical_block_size(bdev) >> SECTOR_SHIFT) - 1;
> +	sector_t sector, nr_sects;
>  	uint64_t range[2];
>  	uint64_t start, len;
>  	struct inode *inode = bdev->bd_inode;
> @@ -105,18 +107,21 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
>  
>  	if (!bdev_max_discard_sectors(bdev))
>  		return -EOPNOTSUPP;
> +	if (bdev_read_only(bdev))
> +		return -EPERM;
>  
>  	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
>  		return -EFAULT;
>  
>  	start = range[0];
>  	len = range[1];
> +	sector = start >> SECTOR_SHIFT;
> +	nr_sects = len >> SECTOR_SHIFT;
>  
> -	if (start & 511)
> +	if (!nr_sects)
>  		return -EINVAL;
> -	if (len & 511)
> +	if ((sector | nr_sects) & bs_mask)
>  		return -EINVAL;
> -
>  	if (start + len > bdev_nr_bytes(bdev))
>  		return -EINVAL;

Maybe you want to shift lower bytes out of consideration, but it is
different, right? For example, if I call this ioctl with start=5 and
len=555, it would return EINVAL, but your change would let it succeed
the same as if start=0, len=512.
