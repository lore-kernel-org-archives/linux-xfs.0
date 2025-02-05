Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21481FCCE1
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 18:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779813; cv=none; b=pdozCluZ9njwwQZyoqaSeSAQmk9vt/fyOdpHGr+cPcav0VuXrCFAPSi5JrNy/7IPPqvBFOQa285QpNtsuVujknBBfAH/atT4oUk2PDy3RUS3z03Bvio+DbXWbmCJg5kacMMWST8/kMgKjlLGnzR4TZbI68/FIb6oosZIv8OpzLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779813; c=relaxed/simple;
	bh=UFo15ljysLl6ba9+zHk5Y3ULIsWoDjyaySLFjC23Jao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JwDrzBxye3EHUiAXRbLUH6YDuEh+iPaJ6EaSyjx5EIvGC0mmye2KJycaCn4bOdYq1cPVaZGkn/kPg4F/NUIaLzrz63wHpwE2Q2vEP9mNOswaGov6ySiUsGLn6B57xdqgUy2B0L0hWcm3C0Oyz9l7Dy9brObwnjCORIslGMwTVrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+Wigz6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+Wigz6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99061C4CED1;
	Wed,  5 Feb 2025 18:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738779813;
	bh=UFo15ljysLl6ba9+zHk5Y3ULIsWoDjyaySLFjC23Jao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j+Wigz6w2fnbMBRBmGsDmAGJ5zNcZkoLQp4huBdrqm1oQwm9FahenCj7M0ZyM3ema
	 71O1quXV2Y1R2NeeqEzbqhk7QuGO3tT4NXCvArVYjwklhy8fXu00+8r/vk1MdM78Yf
	 Py/dCJ/2o7LcqgK/aGVkH6Mx0/NvTQTes9EsYC7TrSxo0nOjv1U2Dn8INhDLmQvDMI
	 dBUiUcdAqKtXfV747XCna3NJArFzo+bIhBTGIpQFsNV8QDWx4f3+njBOzLcQnVx9m/
	 gP2DCUqLVj1R2NwTJfCO4PIjChGNTm+P44VUpWTWiJMcJcuMNeTvD6+/Zq6kalPf8p
	 BkbYpeatuNNpg==
Date: Wed, 5 Feb 2025 10:23:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: flush inodegc before swapon
Message-ID: <20250205182333.GJ21808@frogsfrogsfrogs>
References: <20250205162813.2249154-1-hch@lst.de>
 <20250205162813.2249154-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205162813.2249154-2-hch@lst.de>

On Wed, Feb 05, 2025 at 05:28:00PM +0100, Christoph Hellwig wrote:
> Fix the brand new xfstest that tries to swapon on a recently unshared
> file and use the chance to document the other bit of magic in this
> function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Cc: <stable@vger.kernel.org> # v5.19
Fixes: 5e672cd69f0a53 ("xfs: introduce xfs_inodegc_push()")

Perhaps?  This isn't really a hard brokenness, but it could surprise a
user somewhere.

> ---
>  fs/xfs/xfs_aops.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 69b8c2d1937d..c792297aa0a3 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -21,6 +21,7 @@
>  #include "xfs_error.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_rtgroup.h"
> +#include "xfs_icache.h"
>  
>  struct xfs_writepage_ctx {
>  	struct iomap_writepage_ctx ctx;
> @@ -685,7 +686,22 @@ xfs_iomap_swapfile_activate(
>  	struct file			*swap_file,
>  	sector_t			*span)
>  {
> -	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
> +	struct xfs_inode		*ip = XFS_I(file_inode(swap_file));
> +
> +	/*
> +	 * Ensure inode GC has finished to remove unmapped extents, as the
> +	 * reflink bit is only cleared once all previously shared extents
> +	 * are unmapped.  Otherwise swapon could incorrectly fail on a
> +	 * very recently unshare file.

                         unshared

> +	 */
> +	xfs_inodegc_flush(ip->i_mount);
> +
> +	/*
> +	 * Direct the swap code to the correct block device when this file
> +	 * sits on the RT device.
> +	 */
> +	sis->bdev = xfs_inode_buftarg(ip)->bt_bdev;

With all that amended,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
>  	return iomap_swapfile_activate(sis, swap_file, span,
>  			&xfs_read_iomap_ops);
>  }
> -- 
> 2.45.2
> 
> 
