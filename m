Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEEE157476
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 23:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704845; cv=none; b=dUlZhlLo+Sf8UJQz3heS5f4oodiWPd1pFqLHCPpO7v//2RyUxjps7KU8XIYhts8XBhDeLQKP3Q6Ao9/rhbt31P+YRuCHCPNq0IuOj5baXHKLzroDrDe3/Js8x5SbA3KVwMoqlE1GFWvCZdPtF1wZPnG3pY+LmaecNYKZts4O8gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704845; c=relaxed/simple;
	bh=WO12SLAxNQulhBlZ6QdYrQtuijR7N0ymgjL4qLQxvKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxrH1s7w/VDvOWSBPHOc+R4IXHyPfPr56e4ohtp7I7y5zmo8DRAr8cVQWHi2pSSdCDJ9mGHlyhleudpH1fIidnHfwY3XCDUW2ia8yJeh5AHLC07ZK+waNxNdFzsDCxDx+nIfmigue4V33xt/D54N+1D0RuJzwDGQyOFgUCS1WBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sNQsPVn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sNQsPVn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB961C433F1;
	Tue,  9 Apr 2024 23:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712704844;
	bh=WO12SLAxNQulhBlZ6QdYrQtuijR7N0ymgjL4qLQxvKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sNQsPVn50s2xIei1AJXaANXu4tR2Llscx3IRoNER3jJ559MJb6iIKFkELSOS0+H0x
	 uPe7ZsYQpujLFkoD0sDmIYv+MKgForRTZJckmZttnzQ7nhJLnmsKhY85BBojvdHkLM
	 mLxxM2yFZQWJwlu/R8eIO5MKV4kKAd8LERmpBNXl00+kHI0uwqeM6bE0wra9Qr4XTD
	 SFfH4Tku38KhnxDTBUmFtAtirOHEVgDEEIYr/pMOIJSDCvcyUMwemZ8C2oeSScEf6n
	 NG4/vxy9OIwtNg1Wyfw8PAbAWWcJUjNJW7dC+oXb+flnvFzpWSdR7Iv4JmWXffAL98
	 xiBTUjLq+kPJQ==
Date: Tue, 9 Apr 2024 16:20:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5/8] xfs: pass the actual offset and len to allocate to
 xfs_bmapi_allocate
Message-ID: <20240409232044.GQ6390@frogsfrogsfrogs>
References: <20240408145454.718047-1-hch@lst.de>
 <20240408145454.718047-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408145454.718047-6-hch@lst.de>

On Mon, Apr 08, 2024 at 04:54:51PM +0200, Christoph Hellwig wrote:
> xfs_bmapi_allocate currently overwrites offset and len when converting
> delayed allocations, and duplicates the length cap done for non-delalloc
> allocations.  Move all that logic into the callers to avoid duplication
> and to make the calling conventions more obvious.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index f2e934c2fb423c..aa182937de4641 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4194,21 +4194,11 @@ xfs_bmapi_allocate(
>  	int			error;
>  
>  	ASSERT(bma->length > 0);
> +	ASSERT(bma->length <= XFS_MAX_BMBT_EXTLEN);
>  
> -	/*
> -	 * For the wasdelay case, we could also just allocate the stuff asked
> -	 * for in this bmap call but that wouldn't be as good.
> -	 */
>  	if (bma->wasdel) {
> -		bma->length = (xfs_extlen_t)bma->got.br_blockcount;
> -		bma->offset = bma->got.br_startoff;
>  		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
>  			bma->prev.br_startoff = NULLFILEOFF;
> -	} else {
> -		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_BMBT_EXTLEN);
> -		if (!bma->eof)
> -			bma->length = XFS_FILBLKS_MIN(bma->length,
> -					bma->got.br_startoff - bma->offset);
>  	}
>  
>  	if (bma->flags & XFS_BMAPI_CONTIG)
> @@ -4542,6 +4532,15 @@ xfs_bmapi_write(
>  			 */
>  			bma.length = XFS_FILBLKS_MIN(len, XFS_MAX_BMBT_EXTLEN);
>  
> +			if (wasdelay) {
> +				bma.offset = bma.got.br_startoff;
> +				bma.length = bma.got.br_blockcount;

This read funny since we'd previously set bma.{offset,length} above, but
I guess that preserves the "convert all the delalloc" behavior; and you
turn it off in patch 8, right?

--D

> +			} else {
> +				if (!eof)
> +					bma.length = XFS_FILBLKS_MIN(bma.length,
> +						bma.got.br_startoff - bno);
> +			}
> +
>  			ASSERT(bma.length > 0);
>  			error = xfs_bmapi_allocate(&bma);
>  			if (error) {
> @@ -4694,11 +4693,16 @@ xfs_bmapi_convert_delalloc(
>  	bma.tp = tp;
>  	bma.ip = ip;
>  	bma.wasdel = true;
> -	bma.offset = bma.got.br_startoff;
> -	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
> -			XFS_MAX_BMBT_EXTLEN);
>  	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
>  
> +	/*
> +	 * Always allocate convert from the start of the delalloc extent even if
> +	 * that is outside the passed in range to create large contiguous
> +	 * extents on disk.
> +	 */
> +	bma.offset = bma.got.br_startoff;
> +	bma.length = bma.got.br_blockcount;
> +
>  	/*
>  	 * When we're converting the delalloc reservations backing dirty pages
>  	 * in the page cache, we must be careful about how we create the new
> -- 
> 2.39.2
> 
> 
