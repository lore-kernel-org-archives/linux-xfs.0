Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEE13009E2
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 12:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782130925; cv=none; b=LVZF0b5Uq54RSc80m2h/HQdRBa30HH/v7hhGECr9Mpc8xyeC8VwW9BKfUbca/OV2RrOWH5z1G/l3dd8nN6CihENEQtzXyWkvbG8xrIy3vWqL19rasDLQB2bBRvw2/9n3ywiYGdr8Kg1FNVVLAWkU0c0TVfNQZiM3SAtIfBV0qrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782130925; c=relaxed/simple;
	bh=bwfbAQ/fs+WGRkTDrCNsVDcnR/jFyeaC6KY6QOFGezQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MqjraazzqlMkamoKbk1V5rNM7acnWnmxo0G0zYofDsXjK6Qyd+19afxpf/+uY8hDyr1eOgD96LGcG2F/CjcA/19gD+eCUX/1M6474ZQWwQXHdlbncs5ySwWYtTed8HkqIOh29iWFOCsz9IOLsCUFf7CVKu/UPGlN+/Y3IlnrJZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JkbjZWA7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JkbjZWA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD26F1F000E9;
	Mon, 22 Jun 2026 12:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782130924;
	bh=+faxlx4iMms7Y88qegrpSgi4tHdu2/Vs4MXQDbSsBPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JkbjZWA7HaQH2uu96vzIIyrahkgPuxxhKoGlGWhwRq0LreDv6QdOPww+w+FpsTGe+
	 GKQvK0ftcu0lsZz+IG7i5zj/m6nUVEnPyneKBddPd8XDL6ao8ASwLXH63yxHUFLnvL
	 uaSkrJVkE4A81wkwIoNERwLm/VX99oy1J2CLz7DMkMwcySrMJwqSLLV0fjLAY17Yks
	 bLTYY4v6Jwke3mk+LruEocVJKkV17iSi2SV5D4Nyl8hZT/lQ1gHJew5vfOwHNKoFPi
	 mM6N5DyLyPQ2z7TtVlYBrt0EEd6SWfjyaBXdS816O+zjaqxldrrZ6jZO6dDyQGajoJ
	 +Us1Ii4Dp4Y2g==
Date: Mon, 22 Jun 2026 14:22:01 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: lift setting __GFP_NOFAIL from
 xfs_buf_alloc_kmem to the caller
Message-ID: <ajkovp0zXKBfEON_@nidhogg.toxiclabs.cc>
References: <20260617055814.3842058-1-hch@lst.de>
 <20260617055814.3842058-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617055814.3842058-3-hch@lst.de>

On Wed, Jun 17, 2026 at 07:58:03AM +0200, Christoph Hellwig wrote:
> The current __GFP_NOFAIL setting is wrong in some cases.  Prepare
> for fixing that by giving control to the caller.

Looks good, but would be nice to have at least one of those 'some cases'
documented here.

Independent on that:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d3d44e3ff001..dce398337ad0 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -145,7 +145,7 @@ xfs_buf_alloc_kmem(
>  	ASSERT(is_power_of_2(size));
>  	ASSERT(size < PAGE_SIZE);
>  
> -	bp->b_addr = kmalloc(size, gfp_mask | __GFP_NOFAIL);
> +	bp->b_addr = kmalloc(size, gfp_mask);
>  	if (!bp->b_addr)
>  		return -ENOMEM;
>  
> @@ -230,7 +230,7 @@ xfs_buf_alloc_backing_mem(
>  	 * smaller than PAGE_SIZE buffers used by XFS.
>  	 */
>  	if (size < PAGE_SIZE && is_power_of_2(size))
> -		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
> +		return xfs_buf_alloc_kmem(bp, size, gfp_mask | __GFP_NOFAIL);
>  
>  	/*
>  	 * Don't bother with the retry loop for single PAGE allocations: vmalloc
> -- 
> 2.53.0
> 
