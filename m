Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996C044C76
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 03:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712115823; cv=none; b=lB00KFa1y3fMxJnk5MPkyxDTrFHRvaF+suitHOvHDf0c/NrCvLnLkj3WJ/ziTcDrKu08+FIH11NhSILpTkD5nAbIva/OMCLBiWZveGug+D57/xX0WZ8z8Bv0Zm84I7sK8GpfDXJFkvGBE3AG2tMvBEnLBC8WKSK4Ph91i/3U3Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712115823; c=relaxed/simple;
	bh=cATqwhSHueV6eyasvN/vgcaMsyA+u+DbJ7N1Pzmt94c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ug3jZZ0LAoDl8M7M+S5QnmZBftPXBXdmunbTefZWpkeEuj+VCt3H18Kimhr5F/2gt+PozaIMt4GFbHwnG8MQKFfLxpm+VTOUmPIg3KRUITDoDxh/iPFmbP1jqKro1zAAgEjRo6PsseP7pIAj9DwGEGB0sbEtB+CXjkz7FFL5mh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdK2+Gry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdK2+Gry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B3CC43399;
	Wed,  3 Apr 2024 03:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712115823;
	bh=cATqwhSHueV6eyasvN/vgcaMsyA+u+DbJ7N1Pzmt94c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gdK2+Gryb85A4pZvetC2yIZESQEiF2hhe7aF483Ji9gaWC4Wgpf9HCY3kom7TSE8X
	 scimjLwclx80IuSwu1x8+UkWRs5o4mEiqoWRU5Sbzrp7rEf+Rw8cLVLCQ+93CA6NBx
	 KtjmO7ujUykTzt+dhkvyib8b3Cfb8U1GjoBlHv3R1UuaqrRzETT7jQI69RD9QfBh0A
	 lTzb3Gb3MOYXLJx6sID0uCFb7d6De+E3cBqlZ9WTccJGUmXzgzc3JOf9aQ1csXxpx1
	 7kpdHncPqkHvAh8e5+MzTzKhJ9Mtfcua0H+L7wKMyvCM/j/0niKkYMXGpOK4br28Af
	 eHyF+PITMtHYw==
Date: Tue, 2 Apr 2024 20:43:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 1/4] xfs: use kvmalloc for xattr buffers
Message-ID: <20240403034342.GI6390@frogsfrogsfrogs>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402221127.1200501-2-david@fromorbit.com>

On Wed, Apr 03, 2024 at 08:38:16AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Pankaj Raghav reported that when filesystem block size is larger
> than page size, the xattr code can use kmalloc() for high order
> allocations. This triggers a useless warning in the allocator as it
> is a __GFP_NOFAIL allocation here:
> 
> static inline
> struct page *rmqueue(struct zone *preferred_zone,
>                         struct zone *zone, unsigned int order,
>                         gfp_t gfp_flags, unsigned int alloc_flags,
>                         int migratetype)
> {
>         struct page *page;
> 
>         /*
>          * We most definitely don't want callers attempting to
>          * allocate greater than order-1 page units with __GFP_NOFAIL.
>          */
> >>>>    WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
> ...
> 
> Fix this by changing all these call sites to use kvmalloc(), which
> will strip the NOFAIL from the kmalloc attempt and if that fails
> will do a __GFP_NOFAIL vmalloc().
> 
> This is not an issue that productions systems will see as
> filesystems with block size > page size cannot be mounted by the
> kernel; Pankaj is developing this functionality right now.
> 
> Reported-by: Pankaj Raghav <kernel@pankajraghav.com>
> Fixes: f078d4ea8276 ("xfs: convert kmem_alloc() to kmalloc()")
> Signed-off-be: Dave Chinner <dchinner@redhat.com>

Looks fine to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index ac904cc1a97b..969abc6efd70 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1059,10 +1059,7 @@ xfs_attr3_leaf_to_shortform(
>  
>  	trace_xfs_attr_leaf_to_sf(args);
>  
> -	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
> -	if (!tmpbuffer)
> -		return -ENOMEM;
> -
> +	tmpbuffer = kvmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
>  
>  	leaf = (xfs_attr_leafblock_t *)tmpbuffer;
> @@ -1125,7 +1122,7 @@ xfs_attr3_leaf_to_shortform(
>  	error = 0;
>  
>  out:
> -	kfree(tmpbuffer);
> +	kvfree(tmpbuffer);
>  	return error;
>  }
>  
> @@ -1533,7 +1530,7 @@ xfs_attr3_leaf_compact(
>  
>  	trace_xfs_attr_leaf_compact(args);
>  
> -	tmpbuffer = kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
> +	tmpbuffer = kvmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
>  	memset(bp->b_addr, 0, args->geo->blksize);
>  	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
> @@ -1571,7 +1568,7 @@ xfs_attr3_leaf_compact(
>  	 */
>  	xfs_trans_log_buf(trans, bp, 0, args->geo->blksize - 1);
>  
> -	kfree(tmpbuffer);
> +	kvfree(tmpbuffer);
>  }
>  
>  /*
> @@ -2250,7 +2247,7 @@ xfs_attr3_leaf_unbalance(
>  		struct xfs_attr_leafblock *tmp_leaf;
>  		struct xfs_attr3_icleaf_hdr tmphdr;
>  
> -		tmp_leaf = kzalloc(state->args->geo->blksize,
> +		tmp_leaf = kvzalloc(state->args->geo->blksize,
>  				GFP_KERNEL | __GFP_NOFAIL);
>  
>  		/*
> @@ -2291,7 +2288,7 @@ xfs_attr3_leaf_unbalance(
>  		}
>  		memcpy(save_leaf, tmp_leaf, state->args->geo->blksize);
>  		savehdr = tmphdr; /* struct copy */
> -		kfree(tmp_leaf);
> +		kvfree(tmp_leaf);
>  	}
>  
>  	xfs_attr3_leaf_hdr_to_disk(state->args->geo, save_leaf, &savehdr);
> -- 
> 2.43.0
> 
> 
