Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A34919A2A3
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734129659; cv=none; b=OaDfctacVxXKh0sE/tol7HLZF0Ddc0Fm3Y2B5ol5cgrMugV/JbOAzOB8WKSiCwP1HX7+mM2vJ3sbtDjLb7n7lt/tP5bRVmGqclUNiqnbElgYZ9HjlTixj/oWQxkf7Qa7QlvQzNFZMu6xwGTGHqZmexnl4vorFqe4WkBWi5C8vew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734129659; c=relaxed/simple;
	bh=F5CS9IzVKCjBCeP1zdy52frYXPQ6AJEme5gT58PqOhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQ1/7W9gMpoik9ZuPKIUiW6oO5tydpva+v4EUsVKL0RjgB6FeG1QrjvVLC26I/lUvfHDMyEMKLbFS/jSDqOmdFhQhv7ES4bbkME6dsh0cJUM9Q2uS4Ri8H/rh+EQiBY2D475usouR9+sZIDqOlLKU2uPZBwYo0MlWFN2mwYMOnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mjcoil6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mjcoil6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8739FC4CED0;
	Fri, 13 Dec 2024 22:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734129658;
	bh=F5CS9IzVKCjBCeP1zdy52frYXPQ6AJEme5gT58PqOhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mjcoil6uIUcgwpOL9k1tX7MP8qIn10EP+MlYVSqyPAq0Q4miaHGgdqEEXCImmtH2c
	 av348u1RRPmJr3Zr2+lp6kq3MY//UCvn+qAEMyS7TV3EgodnnzjeNusEANRqmLEvl1
	 TFugeeJPb9glYCW0E9cbOXLkEzxJxy/Bp7QFAAcOnKzQ7FbA55mZg89sio+lum2iwF
	 nB45AIiZOMg6UhJle7hDjDKWcM4B31kinD/G6K3bqJSIkTkBIQJ/4fQdS+TUwGcvqz
	 bIgoErBnGBKpRVsPb3LORPgRaTivUiAmDLzQmCOVI/aE0X98gDS6n8TnSZGFEqHgzq
	 oBexcaURazd0Q==
Date: Fri, 13 Dec 2024 14:40:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/43] xfs: wire up zoned block freeing in
 xfs_rtextent_free_finish_item
Message-ID: <20241213224057.GS6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-30-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-30-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:54AM +0100, Christoph Hellwig wrote:
> Make xfs_rtextent_free_finish_item call into the zoned allocator to free
> blocks on zoned RT devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_extfree_item.c | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index a25c713ff888..777438b853da 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -29,6 +29,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_rtbitmap.h"
>  #include "xfs_rtgroup.h"
> +#include "xfs_zone_alloc.h"
>  
>  struct kmem_cache	*xfs_efi_cache;
>  struct kmem_cache	*xfs_efd_cache;
> @@ -767,21 +768,35 @@ xfs_rtextent_free_finish_item(
>  
>  	trace_xfs_extent_free_deferred(mp, xefi);
>  
> -	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED)) {
> -		if (*rtgp != to_rtg(xefi->xefi_group)) {
> -			*rtgp = to_rtg(xefi->xefi_group);
> -			xfs_rtgroup_lock(*rtgp, XFS_RTGLOCK_BITMAP);
> -			xfs_rtgroup_trans_join(tp, *rtgp,
> -					XFS_RTGLOCK_BITMAP);
> -		}
> -		error = xfs_rtfree_blocks(tp, *rtgp,
> -				xefi->xefi_startblock, xefi->xefi_blockcount);
> +	if (xefi->xefi_flags & XFS_EFI_CANCELLED)
> +		goto done;
> +
> +	if (*rtgp != to_rtg(xefi->xefi_group)) {
> +		unsigned int		lock_flags;
> +
> +		if (xfs_has_zoned(mp))
> +			lock_flags = XFS_RTGLOCK_RMAP;
> +		else
> +			lock_flags = XFS_RTGLOCK_BITMAP;
> +
> +		*rtgp = to_rtg(xefi->xefi_group);
> +		xfs_rtgroup_lock(*rtgp, lock_flags);
> +		xfs_rtgroup_trans_join(tp, *rtgp, lock_flags);
>  	}
> +
> +	if (xfs_has_zoned(mp)) {
> +		error = xfs_zone_free_blocks(tp, *rtgp, xefi->xefi_startblock,
> +				xefi->xefi_blockcount);
> +	} else {
> +		error = xfs_rtfree_blocks(tp, *rtgp, xefi->xefi_startblock,
> +				xefi->xefi_blockcount);
> +	}
> +
>  	if (error == -EAGAIN) {
>  		xfs_efd_from_efi(efdp);
>  		return error;
>  	}
> -
> +done:
>  	xfs_efd_add_extent(efdp, xefi);
>  	xfs_extent_free_cancel_item(item);
>  	return error;
> -- 
> 2.45.2
> 
> 
