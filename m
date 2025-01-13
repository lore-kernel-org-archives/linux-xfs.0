Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FC71B4135
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 18:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736791931; cv=none; b=hI/rWWGuXZGm5uzTkrGbGWXvEWbe0j7PtAWob/JXLSBe8Nf6DOliIxi20ESQA2NS/myVhlkTuTIZqt9F1NglwIIg6xxKiN4+waMTPxEtHXucieGMbCb+2NiXMDRvZtzwPENFvsjmVRu7n/aRtHHvg8Sv3OEq+1MufQcW9s4VdnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736791931; c=relaxed/simple;
	bh=2vj09IyEOCNHLuhLcWWgtH2nk7l2PpErwbG3C+oqCZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BgkzIRVsjK9zbUN0JMyEiR85pPZKg/M/dNO+FWglE2z/f/fk55HYchiRQSkpigqJ23bGp2MI1wWGw44aA+bFM3r7hrfN3KcxL9kECCICzfosAmLXCudY3iQmNkGiYB+7Zuu9rED+VHikrfwpHPahJ2qrmTcAQ4qJ0GfEXwMnBhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+FtMJPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+FtMJPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12F8C4CED6;
	Mon, 13 Jan 2025 18:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736791930;
	bh=2vj09IyEOCNHLuhLcWWgtH2nk7l2PpErwbG3C+oqCZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H+FtMJPpA9TPa92LFjABF5+Km5VPqHskaas0FHl4KViulgbOU3fsuMvW7Rr6LOf7o
	 a5ZvfeAKDhd7P3MaSC6iYziK8sIGsz12DjSpZJ9NSyuhT2mZ9+cqRd3TeAQjAvt259
	 pvF1hzuYoZak5HDhlJ5u0zX5IXBEhmUp7HIYGttdkx4r3xXNEUaDm+grRWZTwnejte
	 EHlbBsIWQvGY1MFT/7GslJwIdcPFWQAeFLE8jGraW1WP5eLQINpnvtYtTMCBQLdlbY
	 ZS7wjMfJjwbWHe4Ut6yQfeVCoiPXJClTajS7+x1eJ/20yYlZuHpkWbTqFyeNKj4xz3
	 10AAp69ZWktDQ==
Date: Mon, 13 Jan 2025 10:12:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/15] xfs: move xfs_buf_iowait out of (__)xfs_buf_submit
Message-ID: <20250113181210.GG1306365@frogsfrogsfrogs>
References: <20250113141228.113714-1-hch@lst.de>
 <20250113141228.113714-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113141228.113714-5-hch@lst.de>

On Mon, Jan 13, 2025 at 03:12:08PM +0100, Christoph Hellwig wrote:
> There is no good reason to pass a bool argument to wait for a buffer when
> the callers that want that can easily just wait themselves.
> 
> This means the wait moves out of the extra hold of the buffer, but as the
> callers of synchronous buffer I/O need to hold a reference anyway that is
> perfectly fine.
> 
> Because all async buffer submitters ignore the error return value, and
> the synchronous ones catch the error condition through b_error and
> xfs_buf_iowait this also means the new xfs_buf_submit doesn't have to
> return an error code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me now,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 42 ++++++++++++++++--------------------------
>  1 file changed, 16 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 5702cad9ccc9..5abada2b4a4a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -53,14 +53,8 @@ struct kmem_cache *xfs_buf_cache;
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
> +static void xfs_buf_submit(struct xfs_buf *bp);
> +static int xfs_buf_iowait(struct xfs_buf *bp);
>  
>  static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
>  {
> @@ -804,7 +798,10 @@ _xfs_buf_read(
>  	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
>  	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
>  
> -	return xfs_buf_submit(bp);
> +	xfs_buf_submit(bp);
> +	if (flags & XBF_ASYNC)
> +		return 0;
> +	return xfs_buf_iowait(bp);
>  }
>  
>  /*
> @@ -980,8 +977,8 @@ xfs_buf_read_uncached(
>  	bp->b_ops = ops;
>  
>  	xfs_buf_submit(bp);
> -	if (bp->b_error) {
> -		error = bp->b_error;
> +	error = xfs_buf_iowait(bp);
> +	if (error) {
>  		xfs_buf_relse(bp);
>  		return error;
>  	}
> @@ -1483,7 +1480,8 @@ xfs_bwrite(
>  	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
>  			 XBF_DONE);
>  
> -	error = xfs_buf_submit(bp);
> +	xfs_buf_submit(bp);
> +	error = xfs_buf_iowait(bp);
>  	if (error)
>  		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
>  	return error;
> @@ -1698,13 +1696,10 @@ xfs_buf_iowait(
>   * safe to reference the buffer after a call to this function unless the caller
>   * holds an additional reference itself.
>   */
> -static int
> -__xfs_buf_submit(
> -	struct xfs_buf	*bp,
> -	bool		wait)
> +static void
> +xfs_buf_submit(
> +	struct xfs_buf	*bp)
>  {
> -	int		error = 0;
> -
>  	trace_xfs_buf_submit(bp, _RET_IP_);
>  
>  	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
> @@ -1724,10 +1719,9 @@ __xfs_buf_submit(
>  	 * state here rather than mount state to avoid corrupting the log tail
>  	 * on shutdown.
>  	 */
> -	if (bp->b_mount->m_log &&
> -	    xlog_is_shutdown(bp->b_mount->m_log)) {
> +	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log)) {
>  		xfs_buf_ioend_fail(bp);
> -		return -EIO;
> +		return;
>  	}
>  
>  	/*
> @@ -1765,16 +1759,12 @@ __xfs_buf_submit(
>  			xfs_buf_ioend_async(bp);
>  	}
>  
> -	if (wait)
> -		error = xfs_buf_iowait(bp);
> -
>  	/*
>  	 * Release the hold that keeps the buffer referenced for the entire
>  	 * I/O. Note that if the buffer is async, it is not safe to reference
>  	 * after this release.
>  	 */
>  	xfs_buf_rele(bp);
> -	return error;
>  }
>  
>  void *
> @@ -2323,7 +2313,7 @@ xfs_buf_delwri_submit_buffers(
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
