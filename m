Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D9514A627
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 21:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734038994; cv=none; b=ZV+Q/ZlQ1BaGFu8Y167Wyo2XhFyDfThxqrP1cSbR6IJ9OHgw3poNgW8jfLPm1GDdtg8waxaPGPgIFmIhvrSMAEakOw5NRHKk1zTY3m4ZeeHPx/txAJU58416d+HciXTTDDuJnwjPdKsJEGdUkO5WC4au2UkGN4Q53cQ4iNYFLH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734038994; c=relaxed/simple;
	bh=ZbjGiVoOAevnIQ4/7wbAk7b4RvngYHZtZTskRz0ZP8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EEpihNHReICrQzp34XvXzbM2NE3WXTvWrvIkvSS+/Hf5Tcge7/wGYRn5D6zjmUTPp7zyGtq+iRE6FjW2A65ky/I8WKzZ7h90WwWYJ0P5WWjCRCrJGBacETHtdwJdXdqaTWzgvrrd3UjQRu21rDNb/rKYeIJZ49Irwpcw/3N1HoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRc0Z8qB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRc0Z8qB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC88C4CECE;
	Thu, 12 Dec 2024 21:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734038993;
	bh=ZbjGiVoOAevnIQ4/7wbAk7b4RvngYHZtZTskRz0ZP8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JRc0Z8qBG2VSu4yLpdzj/jtNFwowbcLEO1hkWlBf/SkjMcKJneDlpofyuapgzHwMH
	 Y4YSIL4dKt7PQJO0HLWtP1EcNaml63GG4UwagOGJzvjXP6kb4rNUs8yHtB5eYZSA9q
	 QBx1mEA3xmGFdc3PrLAUj8HXO6yFKuFs+0YoT5Qq6/neaFA+fX5DA6pLn+aK5/10o4
	 cGS5oIYfcE8FKmPIUFPXlKaetwK68A4JzR2zWdAA2a4G7iscMZUpefS2Cu4fdSBKHg
	 TdY1OzXO0gZ7w9v6PH+JRUMUH9ES5IaahM7lxlhjzk41Rg0xv9kLpRTr+k1EqVZu1c
	 VA+onYI5gVHlw==
Date: Thu, 12 Dec 2024 13:29:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/43] xfs: report the correct dio alignment for COW
 inodes
Message-ID: <20241212212953.GT6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-9-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:33AM +0100, Christoph Hellwig wrote:
> For I/O to reflinked blocks we always need to write an entire new
> file system block, and the code enforces the file system block alignment
> for the entire file if it has any reflinked blocks.
> 
> Unfortunately the reported dio alignment can only report a single value
> for reads and writes, so unless we want to trigger these read-modify
> write cycles all the time, we need to increase both limits.
> 
> Without this zoned xfs triggers the warnings about failed page cache
> invalidation in kiocb_invalidate_post_direct_write all the time when
> running generic/551 when running on a 512 byte sector device, and
> eventually fails the test due to miscompares.
> 
> Hopefully we can add a separate read alignment to statx eventually.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c |  6 +++++-
>  fs/xfs/xfs_iops.c  | 15 ++++++++++++++-
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 726282e74d54..de8ba5345e17 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1213,7 +1213,11 @@ xfs_file_ioctl(
>  		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
>  		struct dioattr		da;
>  
> -		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
> +		da.d_mem = target->bt_logical_sectorsize;
> +		if (xfs_is_cow_inode(ip))
> +			da.d_miniosz = mp->m_sb.sb_blocksize;
> +		else
> +			da.d_miniosz = target->bt_logical_sectorsize;
>  		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
>  
>  		if (copy_to_user(arg, &da, sizeof(da)))
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 6b0228a21617..990df072ba35 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -582,7 +582,20 @@ xfs_report_dioalign(
>  
>  	stat->result_mask |= STATX_DIOALIGN;
>  	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
> -	stat->dio_offset_align = bdev_logical_block_size(bdev);
> +
> +	/*
> +	 * On COW inodes we are forced to always rewrite an entire file system
> +	 * block.

That's not quite accurate -- we're always forced to write an entire file
allocation unit so that the rest of the bmap code doesn't have to deal
with a file range that's mapped to multiple different space extents.
For all the existing reflink scenarios the allocation unit is always an
fsblock so this is a trifling difference.

However, once we start adding reflink to the rt device then there comes
the question of needing to handle allocation unit > fsblock, and all
these bits would have to change.

IOWs, I'm saying that this should be:

	if (xfs_is_cow_inode(ip))
		stat->dio_offset_align = xfs_inode_alloc_unitsize(ip);
	else
		...

Though ATM this is a distinction that doesn't make a difference.

--D

> +	 *
> +	 * Because applications assume they can do sector sized direct writes
> +	 * on XFS we provide an emulation by doing a read-modify-write cycle
> +	 * through the cache, but that is highly inefficient.  Thus report the
> +	 * natively supported size here.
> +	 */
> +	if (xfs_is_cow_inode(ip))
> +		stat->dio_offset_align = ip->i_mount->m_sb.sb_blocksize;
> +	else
> +		stat->dio_offset_align = bdev_logical_block_size(bdev);
>  }
>  
>  static void
> -- 
> 2.45.2
> 
> 
