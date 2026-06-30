Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06371A9F97
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 00:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782780775; cv=none; b=q7/i21sA3QutXARaQ5LTiILTDemcNPcjhrBU/DYEIyoWHAgY6fWgw3qRhIE9kArrDBq6vs5gnmQJBKumQXU9LdhgUoRZ6RkSY+KQRxT0r45LwvxBqdXyjMDi/ItR95Rj1pxMRUfe9flk4ps5Jv5b4szqzZLABMxKGQ7QXYR/kkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782780775; c=relaxed/simple;
	bh=E7wrLzl35+ywrodpIjqLbMRv8Ge1xP/rKWw9GPzkX8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=md98/YGdLR9oIVTAkxholmgo1oILB482JQXmxED4PEQ/PcJ5Z5hCeHMzWbkP+SF8/hmFG5LyPIGmW3fdXE/6QwDAEe51j7V0jOCQ4+M03qLHdaqWIXRYCZ8mrH8mOetCR4D3GZ6NvQ/H0wygGknVlkvekNZmEPXQaJyiG0TAVF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ws7kD88Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ws7kD88Y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5195C1F000E9;
	Tue, 30 Jun 2026 00:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782780774;
	bh=SZous8ceJsD1uwlsi7aNCRhst0Gl6rk9JZbmifpXIAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ws7kD88Y4YJejaUrZPthlLNzxkxKEdUrh+yMpIs5mXQ2khmwvdfteu5LfFBXHdhF4
	 ojF0IIIVWLjPkKhtzlkDfQmBO/m2whQwmQp2uF6P1vwob6IRCxr4KtoB8HangwaHiR
	 LyFdJim4KajbEyKIcYzj0PZWSNpEZbl4NuRoYFX6LHJl+5r5HsFjyHACzyAd7Z2Xdt
	 o8N9BvKkKWlRq45JdQJp6hD/GVw6JD610e+pyzu36GhBW9B75xxonfCB57NhSthL1n
	 GXNqYB6oI3sl3tNhr+csvtcwCYIM0hyMMGYMm08cizFWWFMkqNFPUVPzWDU5DZyyxL
	 uaUv5/KqmcbRg==
Date: Mon, 29 Jun 2026 17:52:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: lift setting __GFP_NOFAIL from
 xfs_buf_alloc_kmem to the caller
Message-ID: <20260630005254.GH6078@frogsfrogsfrogs>
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

Simple enough...

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
> 
