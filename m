Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E7421C9E9
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 17:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740589218; cv=none; b=Rz9gvJ4TdvJxmq8jfB2sdtnhm+SOg46l2lKjSJcVrF8WF/QBUHOKbWreIhaGIl3GbjfW3Ghm2i0KU9hmYdTK9PtrhJYeIUfYr0q4LgqOVEO2tgJVfudYWU1+dj2160cjbOg60oRAYDGiJvp2retScZQ78PKMFALEzbxFCcOxcKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740589218; c=relaxed/simple;
	bh=XTX9mCPDKoUfFWRntaEhP7z1+TnTyLP8Fa96jl6ov64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8dT2leoZvK6tPX5YgElxMmIBKwiqNoYGqmubQIOxzogYopZ5sWfr3wNtNS8p2QIywUgy0DlMrHMBkB3/VyzsWk8aGkfAqPr44LfjIASqZypFywnk0GWTA5kUjGvpxC1q4AZoLUHxMy+tgrpgGpryN7kxX/7gk7651tjWM++6o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8+Oo3p8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8+Oo3p8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6AFC4CED6;
	Wed, 26 Feb 2025 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740589218;
	bh=XTX9mCPDKoUfFWRntaEhP7z1+TnTyLP8Fa96jl6ov64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i8+Oo3p8TSsBZp2kPErYaoG+qh680uDRy2QCbDAQ4OxeLujJuAUIgEVSQOg3jnjAc
	 O9/kpxR5yatdSDilKmB3vN1mLarEzq2RHd9iJVUkFYv1YaIwayCv+QFW2/W9VTs53l
	 yWCaW8ydFqMnIuV6eBg7JLaAQJgISBynkGJU/lHGVDxjX655JkcGFcRDNX5Q5FEJwj
	 Hy0fjTkzT2Ky4AphXdvwdoWZ2bth6hlPaL06RUJOtN7DfL0VNJAO9TwUFZ3asd1hxF
	 N8ngeVt8Khrpk/xLtiXMlIgsLwuqKZlV0rT2AjZE7IPpKp1fT/MVN0Rb8lH3Yft4rB
	 XVDXKI0n/Wr4w==
Date: Wed, 26 Feb 2025 09:00:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: remove xfs_buf.b_offset
Message-ID: <20250226170017.GN6242@frogsfrogsfrogs>
References: <20250226155245.513494-1-hch@lst.de>
 <20250226155245.513494-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226155245.513494-4-hch@lst.de>

On Wed, Feb 26, 2025 at 07:51:31AM -0800, Christoph Hellwig wrote:
> b_offset is only set for slab backed buffers and always set to
> offset_in_page(bp->b_addr), which can be done just as easily in the only
> user of b_offset.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Wooo space savings!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 3 +--
>  fs/xfs/xfs_buf.h | 2 --
>  2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9e0c64511936..ee678e13d9bd 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -336,7 +336,6 @@ xfs_buf_alloc_kmem(
>  		bp->b_addr = NULL;
>  		return -ENOMEM;
>  	}
> -	bp->b_offset = offset_in_page(bp->b_addr);
>  	bp->b_pages = bp->b_page_array;
>  	bp->b_pages[0] = kmem_to_page(bp->b_addr);
>  	bp->b_page_count = 1;
> @@ -1528,7 +1527,7 @@ xfs_buf_submit_bio(
>  
>  	if (bp->b_flags & _XBF_KMEM) {
>  		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
> -				bp->b_offset);
> +				offset_in_page(bp->b_addr));
>  	} else {
>  		for (p = 0; p < bp->b_page_count; p++)
>  			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 3b4ed42e11c0..dc41b617b067 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -197,8 +197,6 @@ struct xfs_buf {
>  	int			b_map_count;
>  	atomic_t		b_pin_count;	/* pin count */
>  	unsigned int		b_page_count;	/* size of page array */
> -	unsigned int		b_offset;	/* page offset of b_addr,
> -						   only for _XBF_KMEM buffers */
>  	int			b_error;	/* error code on I/O */
>  	void			(*b_iodone)(struct xfs_buf *bp);
>  
> -- 
> 2.45.2
> 
> 
