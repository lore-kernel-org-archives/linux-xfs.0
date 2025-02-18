Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8511AF0AE
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739909430; cv=none; b=dKKAM5CW97qtgQdxleyBrxToO9SCGzjsPJkhUPsP8qTbOgN9SYk5oMjalHiNdzIvm2gO3Iu2CJKRDiDkMOfDur2ZRJSFzZzz2HR4UhKLnL14C9FstK/B8YIuHLMGpWmME5V1hC6YJyx1GL/A4SZKuuhO5e/USG1MfOcNCpUCHWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739909430; c=relaxed/simple;
	bh=kZShngn9jIbUZIaugn8hZzNQS9PC2VZpOMBNIyeWg5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIP1jdD9MEaffUGZmahISwKF8uZ/57mCCu7WaaNyF+3jD0D1YICA6fm30IBdp0dumytteZC1rgkFhANBifCKR9ED3zJjaHjYZY3FvlDId+K/TEGdi2+HsX0YGigV3VQty27KGdHlmFW30ojMehZQzOAQ6rg+4vdXDtj+ONbAh04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWiqJpF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWiqJpF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59413C4CEE2;
	Tue, 18 Feb 2025 20:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739909430;
	bh=kZShngn9jIbUZIaugn8hZzNQS9PC2VZpOMBNIyeWg5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JWiqJpF5kok0WnaqvUloameKqtk1bJ1i/4URys5yWA78vHu4+YLmio0C9+2fkrwpu
	 pnqka2JnBhpzS77DeTJseLkMAAdRgTSHQ2UASL5r1RNZpL6laAYW6CDZOCDKmtNh2a
	 LORhzEg/yRCHn1+NaGtnAwJJoww8RpiHdh7swQdNkEat7koD9Q0C1UI4IjpB5Absgi
	 bO+EfpDLd5fXBgNMVJOJaZuB+GC4nokPZJ6WgiJMBeh2wLvPvdJLHpyfVyEWD5ChWj
	 xY/b45DuK1M8UWlIXcP3Ncop517zElIB4QT0mwREtwWLP+mUOo2D8eEXijfixgho0x
	 1RpaOcfuxydzQ==
Date: Tue, 18 Feb 2025 12:10:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: decouple buffer readahead from the normal
 buffer read path
Message-ID: <20250218201029.GH21808@frogsfrogsfrogs>
References: <20250217093207.3769550-1-hch@lst.de>
 <20250217093207.3769550-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217093207.3769550-3-hch@lst.de>

On Mon, Feb 17, 2025 at 10:31:27AM +0100, Christoph Hellwig wrote:
> xfs_buf_readahead_map is the only caller of xfs_buf_read_map and thus
> _xfs_buf_read that is not synchronous.  Split it from xfs_buf_read_map
> so that the asynchronous path is self-contained and the now purely
> synchronous xfs_buf_read_map / _xfs_buf_read implementation can be
> simplified.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for adding the ASSERT as a guardrail against misuse of
xfs_buf_read.

This appears to be a straightforward split, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c         | 41 ++++++++++++++++++++--------------------
>  fs/xfs/xfs_buf.h         |  2 +-
>  fs/xfs/xfs_log_recover.c |  2 +-
>  fs/xfs/xfs_trace.h       |  1 +
>  4 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 050f2c2f6a40..52fb85c42e94 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -794,18 +794,13 @@ xfs_buf_get_map(
>  
>  int
>  _xfs_buf_read(
> -	struct xfs_buf		*bp,
> -	xfs_buf_flags_t		flags)
> +	struct xfs_buf		*bp)
>  {
> -	ASSERT(!(flags & XBF_WRITE));
>  	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
>  
>  	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
> -	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
> -
> +	bp->b_flags |= XBF_READ;
>  	xfs_buf_submit(bp);
> -	if (flags & XBF_ASYNC)
> -		return 0;
>  	return xfs_buf_iowait(bp);
>  }
>  
> @@ -857,6 +852,8 @@ xfs_buf_read_map(
>  	struct xfs_buf		*bp;
>  	int			error;
>  
> +	ASSERT(!(flags & (XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD)));
> +
>  	flags |= XBF_READ;
>  	*bpp = NULL;
>  
> @@ -870,21 +867,11 @@ xfs_buf_read_map(
>  		/* Initiate the buffer read and wait. */
>  		XFS_STATS_INC(target->bt_mount, xb_get_read);
>  		bp->b_ops = ops;
> -		error = _xfs_buf_read(bp, flags);
> -
> -		/* Readahead iodone already dropped the buffer, so exit. */
> -		if (flags & XBF_ASYNC)
> -			return 0;
> +		error = _xfs_buf_read(bp);
>  	} else {
>  		/* Buffer already read; all we need to do is check it. */
>  		error = xfs_buf_reverify(bp, ops);
>  
> -		/* Readahead already finished; drop the buffer and exit. */
> -		if (flags & XBF_ASYNC) {
> -			xfs_buf_relse(bp);
> -			return 0;
> -		}
> -
>  		/* We do not want read in the flags */
>  		bp->b_flags &= ~XBF_READ;
>  		ASSERT(bp->b_ops != NULL || ops == NULL);
> @@ -936,6 +923,7 @@ xfs_buf_readahead_map(
>  	int			nmaps,
>  	const struct xfs_buf_ops *ops)
>  {
> +	const xfs_buf_flags_t	flags = XBF_READ | XBF_ASYNC | XBF_READ_AHEAD;
>  	struct xfs_buf		*bp;
>  
>  	/*
> @@ -945,9 +933,20 @@ xfs_buf_readahead_map(
>  	if (xfs_buftarg_is_mem(target))
>  		return;
>  
> -	xfs_buf_read_map(target, map, nmaps,
> -		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
> -		     __this_address);
> +	if (xfs_buf_get_map(target, map, nmaps, flags | XBF_TRYLOCK, &bp))
> +		return;
> +	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
> +
> +	if (bp->b_flags & XBF_DONE) {
> +		xfs_buf_reverify(bp, ops);
> +		xfs_buf_relse(bp);
> +		return;
> +	}
> +	XFS_STATS_INC(target->bt_mount, xb_get_read);
> +	bp->b_ops = ops;
> +	bp->b_flags &= ~(XBF_WRITE | XBF_DONE);
> +	bp->b_flags |= flags;
> +	xfs_buf_submit(bp);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 3b4ed42e11c0..2e747555ad3f 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -291,7 +291,7 @@ int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
>  int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
>  		size_t numblks, xfs_buf_flags_t flags, struct xfs_buf **bpp,
>  		const struct xfs_buf_ops *ops);
> -int _xfs_buf_read(struct xfs_buf *bp, xfs_buf_flags_t flags);
> +int _xfs_buf_read(struct xfs_buf *bp);
>  void xfs_buf_hold(struct xfs_buf *bp);
>  
>  /* Releasing Buffers */
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b3c27dbccce8..2f76531842f8 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3380,7 +3380,7 @@ xlog_do_recover(
>  	 */
>  	xfs_buf_lock(bp);
>  	xfs_buf_hold(bp);
> -	error = _xfs_buf_read(bp, XBF_READ);
> +	error = _xfs_buf_read(bp);
>  	if (error) {
>  		if (!xlog_is_shutdown(log)) {
>  			xfs_buf_ioerror_alert(bp, __this_address);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index b29462363b81..bfc2f1249022 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -593,6 +593,7 @@ DEFINE_EVENT(xfs_buf_flags_class, name, \
>  DEFINE_BUF_FLAGS_EVENT(xfs_buf_find);
>  DEFINE_BUF_FLAGS_EVENT(xfs_buf_get);
>  DEFINE_BUF_FLAGS_EVENT(xfs_buf_read);
> +DEFINE_BUF_FLAGS_EVENT(xfs_buf_readahead);
>  
>  TRACE_EVENT(xfs_buf_ioerror,
>  	TP_PROTO(struct xfs_buf *bp, int error, xfs_failaddr_t caller_ip),
> -- 
> 2.45.2
> 
> 
