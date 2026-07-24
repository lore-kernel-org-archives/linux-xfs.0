Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C645447800
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784911474; cv=none; b=U53kL1LAFf/RL+QilxED0x2ImpFO3mBAwriiRGH+M2la70GioPWJWHNv/qyMnLCthNhTg7Q4QF/ZzZE3owd5uVeu8origQbvaNA6pyTQ/LKCoru40Us+AixtXwS1Ws4HUK/k2+asNeyBGfSOtlluly977AstshqcdVa6eZMmXLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784911474; c=relaxed/simple;
	bh=uTIYQRSxs3eXvVOtb1prcKxT7CaObqNhmtZCdkHibdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckCWVyLF5lazPXz3W0qsecH15yMxKLLve3AM989+zUq5R7xX44BPHqtU6/cWtsp4KrjogJFstCzH0VDangdxTNR4oBhpCOj57uManfBgPamD3ce54cIYh3tRj1A7lZJVm/L8/RgQaVT1F0kK6R62fNEEJ+2HpPpp6BWHfoUOD98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3akmvUa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3akmvUa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C058F1F000E9;
	Fri, 24 Jul 2026 16:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784911467;
	bh=Edm/hG8e1YEuWROsWq67y442mwSa4nL17eTrwJMlSi4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y3akmvUa7ZVEVxxFwo1hRX3XgOEU9B2JR830uij35/sCgRUSZ1PzPS49b0OZHCo4m
	 vmtoaLuzQ1R81JLpI+ylzROkewc9nfrcXfjQK2hJ+/C4XqR1zyjL5tWTH/bYDr82xz
	 bQqc6vhcqcDhuaoCsFABKc4LUBSoYf0OW+MOR6ad15kGanpbmIEopKtrtpmv6/OjQx
	 /HxkHpIJ4jOlh6W2iJkfBzyEK8qJvJjjYEHP/nqhYe8HZqfhvRtisXYpesf4rDNYr/
	 JnB0i1SspMaHfdsWJvZpPFlUrtpTq9IZ9Tbo9+vKqE7C+qtEpaJ1fQs2YtCBIPcCCm
	 vngzbSjhADeGQ==
Date: Fri, 24 Jul 2026 09:44:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: split out a lower-level xfs_buf_get_map
 helper from xfs_find_get_buf
Message-ID: <20260724164427.GQ2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-4-hch@lst.de>

On Wed, Jul 15, 2026 at 04:50:56PM +0200, Christoph Hellwig wrote:
> xfs_buf_get_map is currently reused to implement xfs_buf_read_map and
> xfs_buf_readahead_map.  This causes double accounting of buf_get stat
> and leads to some ugly overload of the flags.
> 
> Split out a slightly lower-level xfs_find_get_buf helper and use that to
> implement xfs_buf_get_map, xfs_buf_read_map and xfs_buf_readahead_map.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 41 +++++++++++++++++++++++++++++------------
>  1 file changed, 29 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e56d4b8b0771..2cf359b4c446 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -514,8 +514,8 @@ xfs_buf_find_insert(
>   * cache hits, as metadata intensive workloads will see 3 orders of magnitude
>   * more hits than misses.
>   */
> -int
> -xfs_buf_get_map(
> +static int
> +xfs_find_get_buf(

I like the idea of factoring this out, but I can't tell from the names
what's the difference between xfs_find_get_buf and xfs_buf_get_map.

I might have called the inner function __xfs_buf_get or something.
Dunno, don't care to bikeshed this.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map,
>  	int			nmaps,
> @@ -552,16 +552,33 @@ xfs_buf_get_map(
>  		return error;
>  	}
>  
> +	*bpp = bp;
> +	return 0;
> +}
> +
> +int
> +xfs_buf_get_map(
> +	struct xfs_buftarg	*btp,
> +	struct xfs_buf_map	*map,
> +	int			nmaps,
> +	xfs_buf_flags_t		flags,
> +	struct xfs_buf		**bpp)
> +{
> +	int			error;
> +
> +	ASSERT(!(flags & ~(XBF_TRYLOCK | XBF_INCORE | XBF_LIVESCAN)));
> +	ASSERT(!(flags & XBF_LIVESCAN) || (flags & XBF_INCORE));
> +
>  	/*
> -	 * Clear b_error if this is a lookup from a caller that doesn't expect
> -	 * valid data to be found in the buffer.
> +	 * Zero the buffer and clear b_error as xfs_buf_get_map callers don't
> +	 * expect valid data to be found in the buffer.
>  	 */
> -	if (!(flags & XBF_READ))
> -		xfs_buf_ioerror(bp, 0);
> -
> +	error = xfs_find_get_buf(btp, map, nmaps, flags, bpp);
> +	if (error)
> +		return error;
>  	XFS_STATS_INC(btp->bt_mount, xb_get);
> -	trace_xfs_buf_get(bp, flags, _RET_IP_);
> -	*bpp = bp;
> +	trace_xfs_buf_get(*bpp, flags, _RET_IP_);
> +	xfs_buf_ioerror(*bpp, 0);
>  	return 0;
>  }
>  
> @@ -625,12 +642,12 @@ xfs_buf_read_map(
>  	struct xfs_buf		*bp;
>  	int			error;
>  
> -	ASSERT(!(flags & (XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD)));
> +	ASSERT(!(flags & ~XBF_TRYLOCK));
>  
>  	flags |= XBF_READ;
>  	*bpp = NULL;
>  
> -	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
> +	error = xfs_find_get_buf(target, map, nmaps, flags, &bp);
>  	if (error)
>  		return error;
>  
> @@ -706,7 +723,7 @@ xfs_buf_readahead_map(
>  	if (xfs_buftarg_is_mem(target))
>  		return;
>  
> -	if (xfs_buf_get_map(target, map, nmaps, flags | XBF_TRYLOCK, &bp))
> +	if (xfs_find_get_buf(target, map, nmaps, flags | XBF_TRYLOCK, &bp))
>  		return;
>  	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
>  
> -- 
> 2.53.0
> 
> 
