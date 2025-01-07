Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA032594AB
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 02:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215342; cv=none; b=GfXt7Uqv4c14oTC6yiu3F3hAnwFa8ld0riCC4sK9dkBlXlOwt6tdk3YQw4OSjFHy4O1cpyPEHFGo3TqiK9z5JHLP6FdnuMFHA01idaZEY8PeMt2V8myM6NI9FLK7baVGMAD4slL7Z/lEjAocmd3ATOto7obRo+BtcM6j2hyYaDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215342; c=relaxed/simple;
	bh=MWlPsW9zlgRtyAC/QFD3V4UwFeOdY12frSkjpRggU5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PiXnVAzcG8uLpfoIsSKHnyiZGXjVlONiGfACLTSMCihnaBWxT95VN7XFN8o+tHhylIl7E1ImPRw1KNzAUX2W8qA7dDMAEfNpXPMbkz4N7vSiSI+kkXWdeUTZa5Duz4PWJ+mLqYDKvOQuUPqhUXSRpLIfmys5S2Sanfcxl1Jb80Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNgkTRFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNgkTRFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AF6C4CED2;
	Tue,  7 Jan 2025 02:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736215342;
	bh=MWlPsW9zlgRtyAC/QFD3V4UwFeOdY12frSkjpRggU5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DNgkTRFjM8JLm7YsymB7I0BK2O/zcMwSCl6hLyZlEsKwUUauaQFSijBhuC3dmLgDq
	 eMI23EcMLALca0iH3/VMbCzv6RXgiMwD1i76sY21d84TRp8ZHflFGlgJCVdb0KOi0u
	 6zUiYWGkGrwNDxIhZbKwL7iCQ9O0oUVfD8eKvoBYvhtvm2mXOl17z/5lIc2KFneBKl
	 Xto712QGI26K282jPAiQ3pK4Ns0cp4QRJ54yhIH5Q6CdbVEA8o/G1qbgQ1YRbWQvcT
	 ja2awvMT+z9HxMs+kkMNSGEgZYKwhuHFaSms3I/wF4vgfgX6Wzr0ZlHPsZq02vg0rI
	 7S/BPLqTOu8MA==
Date: Mon, 6 Jan 2025 18:02:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/15] xfs: move xfs_buf_iowait out of (__)xfs_buf_submit
Message-ID: <20250107020221.GV6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-5-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:41AM +0100, Christoph Hellwig wrote:
> There is no good reason to pass a bool argument to wait for a buffer when
> the callers that want that can easily just wait themselves.
> 
> This means the wait moves out of the extra hold of the buffer, but as the
> callers of synchronous buffer I/O need to hold a reference anyway that is
> perfectly fine.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That's much cleaner...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1927655fed13..a3484421a6d8 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -52,14 +52,8 @@ struct kmem_cache *xfs_buf_cache;
>   *	  b_lock (trylock due to inversion)
>   */
>  
> -static int __xfs_buf_submit(struct xfs_buf *bp, bool wait);
> -
> -static inline int
> -xfs_buf_submit(
> -	struct xfs_buf		*bp)
> -{
> -	return __xfs_buf_submit(bp, !(bp->b_flags & XBF_ASYNC));
> -}
> +static int xfs_buf_submit(struct xfs_buf *bp);
> +static int xfs_buf_iowait(struct xfs_buf *bp);
>  
>  static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
>  {
> @@ -797,13 +791,18 @@ _xfs_buf_read(
>  	struct xfs_buf		*bp,
>  	xfs_buf_flags_t		flags)
>  {
> +	int			error;
> +
>  	ASSERT(!(flags & XBF_WRITE));
>  	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
>  
>  	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
>  	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
>  
> -	return xfs_buf_submit(bp);
> +	error = xfs_buf_submit(bp);
> +	if (!error && !(flags & XBF_ASYNC))
> +		error = xfs_buf_iowait(bp);
> +	return error;
>  }
>  
>  /*
> @@ -978,9 +977,10 @@ xfs_buf_read_uncached(
>  	bp->b_flags |= XBF_READ;
>  	bp->b_ops = ops;
>  
> -	xfs_buf_submit(bp);
> -	if (bp->b_error) {
> -		error = bp->b_error;
> +	error = xfs_buf_submit(bp);
> +	if (!error)
> +		error = xfs_buf_iowait(bp);
> +	if (error) {
>  		xfs_buf_relse(bp);
>  		return error;
>  	}
> @@ -1483,6 +1483,8 @@ xfs_bwrite(
>  			 XBF_DONE);
>  
>  	error = xfs_buf_submit(bp);
> +	if (!error)
> +		error = xfs_buf_iowait(bp);
>  	if (error)
>  		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
>  	return error;
> @@ -1698,9 +1700,8 @@ xfs_buf_iowait(
>   * holds an additional reference itself.
>   */
>  static int
> -__xfs_buf_submit(
> -	struct xfs_buf	*bp,
> -	bool		wait)
> +xfs_buf_submit(
> +	struct xfs_buf	*bp)
>  {
>  	int		error = 0;
>  
> @@ -1764,9 +1765,6 @@ __xfs_buf_submit(
>  			xfs_buf_ioend_async(bp);
>  	}
>  
> -	if (wait)
> -		error = xfs_buf_iowait(bp);
> -
>  	/*
>  	 * Release the hold that keeps the buffer referenced for the entire
>  	 * I/O. Note that if the buffer is async, it is not safe to reference
> @@ -2322,7 +2320,7 @@ xfs_buf_delwri_submit_buffers(
>  			bp->b_flags |= XBF_ASYNC;
>  			xfs_buf_list_del(bp);
>  		}
> -		__xfs_buf_submit(bp, false);
> +		xfs_buf_submit(bp);
>  	}
>  	blk_finish_plug(&plug);
>  
> -- 
> 2.45.2
> 
> 
