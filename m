Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E768431A5F
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784912394; cv=none; b=G++9jnSa5PK7IrTz739cEeDONez1bX45mdE61ZBDiTEhMAjmIYiQWsVkqProdQjuSTUQWgxeoW09myx6Y4mGP7bdVoolf8/ne28N4YP7b+YBt7BLida7Q2x46lWqLdqg0Oo9c5FZVusmXXmTKzEDpbKJIDU3p3GtF4OhNMEyjh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784912394; c=relaxed/simple;
	bh=/ANjgftzzNuP3T2aGgAi8xodb3WGUHshCXrYMqFvuCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F9IpxHOU9T5f91V4vuFKRoQNkcTpg7n6U4pCf+cW3Q8r6cpny17xBr4AcsEA6CNX1VPZg30CP2vxhV6nULgI2zOaoewX7xg6Z27JDbmyBovx17oNRRFvho/eASqFw1iVK8ePmwZmZyvRuJvcWTFjNBuzVHhXpvGITt7eDl1/bGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dX0I73fn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dX0I73fn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7371D1F000E9;
	Fri, 24 Jul 2026 16:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784912392;
	bh=AaLMliQsKLE3G1oSw6KXScOCBg2r/ePU0HaLG8olVkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dX0I73fnwlET+hX5Y3dvl3jtdYaC3aps7dsqYlFhxqB6zSWHVCbDpqNBorRmNxz49
	 Y+kfKc4/3EVZG/LiwruVf3suHrODKAhY++BYQ03inLY1TBKJIqoChwSYhthYULhGUn
	 cn95d98/JPpBmR0qtHTuwVbxn2K5U8mnLgxENhjyzN2rgU4PaKkcicXnGddidK8MsL
	 y0TKkFm+0N35+PCSKEoRqgenHACWbEU/cJhUqcljzKnF72dr1nEfmPWGrn8S/UXOMv
	 fUrM+lb1raYDH7t54XToN+7kNaoqFHts/D38uUeV8oo01gmSyaR+qqiQSmB0lF+/PK
	 sA8hLIDqamVaw==
Date: Fri, 24 Jul 2026 09:59:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs: move buffer locking out of xfs_find_get_buf
Message-ID: <20260724165952.GY2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-12-hch@lst.de>

On Wed, Jul 15, 2026 at 04:51:04PM +0200, Christoph Hellwig wrote:
> To prepare for buffer loookups that don't lock the buffer, move the
> call to xfs_buf_find_lock from xfs_find_get_buf to its callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That makes sense given what I've already seen.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index be3b25ccbea6..f5701f74061f 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -577,12 +577,6 @@ xfs_find_get_buf(
>  			return error;
>  	}
>  
> -	error = xfs_buf_find_lock(bp, flags);
> -	if (error) {
> -		xfs_buf_rele(bp);
> -		return error;
> -	}
> -
>  	*bpp = bp;
>  	return 0;
>  }
> @@ -607,6 +601,12 @@ xfs_buf_get_map(
>  	error = xfs_find_get_buf(btp, map, nmaps, flags, bpp);
>  	if (error)
>  		return error;
> +
> +	error = xfs_buf_find_lock(*bpp, flags);
> +	if (error) {
> +		xfs_buf_rele(*bpp);
> +		return error;
> +	}
>  	XFS_STATS_INC(btp->bt_mount, xb_get);
>  	trace_xfs_buf_get(*bpp, flags, _RET_IP_);
>  	xfs_buf_ioerror(*bpp, 0);
> @@ -647,6 +647,11 @@ xfs_buf_read_map(
>  	error = xfs_find_get_buf(target, map, nmaps, flags, &bp);
>  	if (error)
>  		return error;
> +	error = xfs_buf_find_lock(bp, flags);
> +	if (error) {
> +		xfs_buf_rele(bp);
> +		return error;
> +	}
>  
>  	trace_xfs_buf_read(bp, flags, _RET_IP_);
>  
> @@ -749,20 +754,26 @@ xfs_buf_readahead_map(
>  	if (xfs_buftarg_is_mem(target))
>  		return;
>  
> -	if (xfs_find_get_buf(target, map, nmaps, flags | XBF_TRYLOCK, &bp))
> +	if (xfs_find_get_buf(target, map, nmaps, flags, &bp))
>  		return;
> +	if (xfs_buf_find_lock(bp, XBF_TRYLOCK))
> +		goto out_rele;
> +
>  	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
> +	if (bp->b_flags & XBF_DONE)
> +		goto out_unlock;
>  
> -	if (bp->b_flags & XBF_DONE) {
> -		xfs_buf_relse(bp);
> -		return;
> -	}
>  	XFS_STATS_INC(target->bt_mount, xb_get_read);
>  	bp->b_ops = ops;
>  	xfs_buf_clear_flags(bp, XBF_WRITE | XBF_DONE);
>  	xfs_buf_set_flags(bp, flags);
>  	percpu_counter_inc(&target->bt_readahead_count);
>  	xfs_buf_submit(bp);
> +	return;
> +out_unlock:
> +	xfs_buf_unlock(bp);
> +out_rele:
> +	xfs_buf_rele(bp);
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 
