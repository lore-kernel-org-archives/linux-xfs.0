Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD092EAD10;
	Fri,  9 Jan 2026 12:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960843; cv=none; b=GMmhFOSnoVhgRvWSvKLfoxqWn0rMp0jQoAeZ+sFfHOIB/BXd1ICApgQ+2kUoJOahuVZYp8km47H7RkVuA+UKpR86xdgo00N5xpciB0MSmjP80ml4QZLgHEXUm2dIoRO0Pmxk8IMVMIpr/cQbT7MRVpi/GVhwOgifUDDFXW4GFXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960843; c=relaxed/simple;
	bh=6d5VyKD4I8RNZvyndJtGD0eNCqAjEYUY43WW1qa72Ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XYvDccMdkPrk25wlzl+VI6tb1uhLrnpbCgDMgw9XK+juO+GeB6v4toKxpIFApmzje/DWwT0psRrRqF31p1rYL8rdAgn5V9UYFBAUfg/LMJXAnX16NnPiZ1TbseZo5Pdo7ykxgGOIuXPP8SZskyVD/D1eQXH8bhXJXEzyO2Fr1XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UG35Azhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UG35Azhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43ECDC19421;
	Fri,  9 Jan 2026 12:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767960843;
	bh=6d5VyKD4I8RNZvyndJtGD0eNCqAjEYUY43WW1qa72Ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UG35Azhd6ZbjAvc8ZGovh4GotHDZFj4XhPgA10ra8CakzxJ8jcu5QKJhxHfZz+62Z
	 A8CQigylurur3y7RtJVaiAQBwy3gEimnJRM+7qQn+3uGA7SE9Lswk00n5feUGpYeKV
	 Vd0C9gvXnSIjos6ViLkmiFXjIIjO0ZURiBBDccWjGM4LOWcYaYx83/CcWXNBrlNN7L
	 YWQaxahVh1ZMG6rDtBi7zx9OKwpZGbLP0VBsxbKZITSod734ZIxgslv2g6xBqq7nyJ
	 0quNaXRjsjitb9EnZ9Nt5oDgJs+v32DF6P3PJmMCeXLCuHd3sOa4Cbg8Hqfpee7mB7
	 Mu7Q/NiHnIwYA==
Date: Fri, 9 Jan 2026 13:13:59 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Message-ID: <aWDw-J4kP7UvJW9Y@nidhogg.toxiclabs.cc>
References: <20260106075914.1614368-1-hch@lst.de>
 <20260106075914.1614368-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106075914.1614368-3-hch@lst.de>

On Tue, Jan 06, 2026 at 08:58:53AM +0100, Christoph Hellwig wrote:
> Replace our somewhat fragile code to reuse the bio, which caused a
> regression in the past with the block layer bio_reuse helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  fs/xfs/xfs_zone_gc.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 3c52cc1497d4..40408b1132e0 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -811,8 +811,6 @@ xfs_zone_gc_write_chunk(
>  {
>  	struct xfs_zone_gc_data	*data = chunk->data;
>  	struct xfs_mount	*mp = chunk->ip->i_mount;
> -	phys_addr_t		bvec_paddr =
> -		bvec_phys(bio_first_bvec_all(&chunk->bio));
>  	struct xfs_gc_bio	*split_chunk;
>  
>  	if (chunk->bio.bi_status)
> @@ -825,10 +823,7 @@ xfs_zone_gc_write_chunk(
>  	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
>  	list_move_tail(&chunk->entry, &data->writing);
>  
> -	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
> -	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
> -			offset_in_folio(chunk->scratch->folio, bvec_paddr));
> -
> +	bio_reuse(&chunk->bio);
>  	while ((split_chunk = xfs_zone_gc_split_write(data, chunk)))
>  		xfs_zone_gc_submit_write(data, split_chunk);
>  	xfs_zone_gc_submit_write(data, chunk);
> -- 
> 2.47.3
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
