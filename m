Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF8E4AEBDA;
	Thu, 24 Sep 2026 21:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790286224; cv=none; b=C8Ijfjpg+DzwwOL4BmYTUV8mlctNdFSGBfvjmEVP3Z2tATGdsDRf0S3fCyAi+7hzGfD/ikf+DyOPMHyHndCQiV352g1Uy24SjFkPRLB330K37uYKpMgdZsLOu7lks/4ayNO6o5yDvfWYxT5c7xFxqIiT4eg2OrVJJV00IIB/KGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790286224; c=relaxed/simple;
	bh=D+r7JR0WuzkTrgT7B30txmcg35qPAKlD5Z628GNczw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FbMGoTFEFnREaAktLtYmQ25qr1XcO0n0zfRp/k7xk0wrY/UHEX33WkszSVsfHAmoIlQPJ+0Q3dOzXjgxkUx9RiSZisJehJ3Qtd2jcVtw8/+i1nG8wG19MyQHCD8+VLTfQbGj092CgU1ciH5eeLkKVDExT7g3/zdhOXZ/2QVHMEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jAKCMcC3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jAKCMcC3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0EA3E1F000FF;
	Thu, 24 Sep 2026 21:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790286223;
	bh=yaxTFXgOCa87AdAV/iz+9hS0ki+Pl2AoDqma4rLd9Dc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jAKCMcC3ycRApEGG8/u0NX0EPLtaHqo/G/4UjP9z0Ydjx/WJ/LaXWfQv5cMRdiwLY
	 3bXk7NhgBD25cRCrISKNTzGOcWuo3ONS1+IMDcQd//bUTEKetz82QnyJ9rVAFnIaKo
	 U3gzV6IUbSWzJHDD08F/qBMoiUHsn9D8PjKT/X7MwAXmvFFUqI/zI5iKU8nP8GsbGQ
	 gN4fxtQbLZvGyS1CKGXG4/+5pqBVl/4t+1QcCt3Q9PHLmI9NxErqzDG3H7Vb510nsL
	 SGRvshoq2qgBS6W9pZ8yYFn8nfZP+NHOAlAAjfZdaxqqCmaz6+GBcWreKM5PYlZANf
	 HRXAlDq6fgrcw==
Date: Thu, 24 Sep 2026 14:43:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/21] xfs: add a xfs_buf_read_async buffer cache API
Message-ID: <20260924214341.GE2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-4-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:35AM +0200, Christoph Hellwig wrote:
> Add a new helper that reads a buffer asynchronously.  This is similar
> to readahead, but doesn't become a no-op under memory or I/O congestion
> and returns the buffer to be read.
> 
> The intended use is to kick off a read of data checksum buffers at
> roughly the same time as the data read so that they are available
> in the I/O completion handler.

Does there need to be a "wait until this async-read buffer reaches
XBF_DONE" function too?  Or how do callers do that?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c   | 130 ++++++++++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_buf.h   |   4 ++
>  fs/xfs/xfs_trace.h |   3 ++
>  3 files changed, 113 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index eee491c01d8c..966c06bffeff 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -627,6 +627,40 @@ _xfs_buf_read(
>  	return xfs_buf_iowait(bp);
>  }
>  
> +/*
> + * If we've had a read error, then the contents of the buffer are invalid and
> + * should not be used.  To ensure that a followup read tries to pull the buffer
> + * from disk again, we clear the XBF_DONE flag and mark the buffer stale.
> + * This ensures that anyone who has a current reference to the buffer will
> + * interpret it's contents correctly and future cache lookups will also treat it
> + * as an empty, uninitialised buffer.
> + */
> +static int
> +xfs_buf_read_error(
> +	struct xfs_buf		*bp,
> +	xfs_failaddr_t		fa,
> +	int			error)
> +{
> +	/*
> +	 * Check against log shutdown for error reporting because metadata
> +	 * writeback may require a read first and we need to report errors in
> +	 * metadata writeback until the log is shut down.
> +	 * High level transaction read functions already check against mount
> +	 * shutdown, anyway, so we only need to be concerned about low level IO
> +	 * interactions here.
> +	 */
> +	if (!xlog_is_shutdown(bp->b_mount->m_log))
> +		xfs_buf_ioerror_alert(bp, fa);
> +	xfs_buf_clear_flags(bp, XBF_DONE);
> +	xfs_buf_stale(bp);
> +	xfs_buf_relse(bp);
> +
> +	/* bad CRC means corrupted metadata */
> +	if (error == -EFSBADCRC)
> +		return -EFSCORRUPTED;
> +	return error;
> +}
> +
>  int
>  xfs_buf_read_map(
>  	struct xfs_buftarg	*target,
> @@ -699,39 +733,87 @@ xfs_buf_read_map(
>  	}
>  
>  	if (error)
> -		goto out_ioerror;
> -
> +		return xfs_buf_read_error(bp, fa, error);
>  	*bpp = bp;
>  	return 0;
> +}
>  
> -out_ioerror:
> +int
> +xfs_buf_read_async_wait(
> +	struct xfs_buf		*bp)
> +{
>  	/*
> -	 * Check against log shutdown for error reporting because metadata
> -	 * writeback may require a read first and we need to report errors in
> -	 * metadata writeback until the log is shut down.  High level
> -	 * transaction read functions already check against mount shutdown, so
> -	 * we only need to be concerned about low level/ IO interactions here.
> +	 * Protect against the case where the checksum read is slower than the
> +	 * data read.
>  	 */
> -	if (!xlog_is_shutdown(target->bt_mount->m_log))
> -		xfs_buf_ioerror_alert(bp, fa);
> +	if ((READ_ONCE(bp->b_flags) & (XBF_DONE | XBF_STALE)) == XBF_DONE &&
> +	    !bp->b_error) {
> +		trace_xfs_buf_read_async_wait(bp, 0, _RET_IP_);
> +		return 0;
> +	}
> +
> +	/* xfs_buf_find_lock can't return an error with 0 flags */
> +	xfs_buf_find_lock(bp, 0);
> +	trace_xfs_buf_read_async_lock(bp, 0, _RET_IP_);
> +	if (bp->b_error)
> +		return xfs_buf_read_error(bp, __builtin_return_address(0),
> +				bp->b_error);
> +	ASSERT(bp->b_ops);
> +	xfs_buf_clear_flags(bp, XBF_READ);
> +	xfs_buf_unlock(bp);
> +	return 0;
> +}
> +
> +/*
> + * Kick off an asynchronous read.  Unlike readahead, this returns a reference
> + * to the buffer, and reliably reads the data instead of skipping the read on
> + * memory pressure.
> + *
> + * The buffer may be locked when I/O is kicked off, but the I/O completion
> + * handler will unlock it.  The caller needs to lock itself if need to prevent
> + * concurrent access or to synchronize with I/O completion.
> + */
> +int
> +xfs_buf_read_async(
> +	struct xfs_buftarg	*btp,
> +	xfs_daddr_t		daddr,
> +	size_t			numblks,
> +	const struct xfs_buf_ops *ops,
> +	struct xfs_buf		**bpp)
> +{
> +	DEFINE_SINGLE_BUF_MAP(map, daddr, numblks);
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	ASSERT(!xfs_buftarg_is_mem(btp));
> +
> +	error = xfs_find_get_buf(btp, &map, 1, XBF_READ, &bp);
> +	if (error)
> +		return error;
>  
>  	/*
> -	 * If we've had a read error, then the contents of the buffer are
> -	 * invalid and should not be used. To ensure that a followup read tries
> -	 * to pull the buffer from disk again, we clear the XBF_DONE flag and
> -	 * mark the buffer stale. This ensures that anyone who has a current
> -	 * reference to the buffer will interpret it's contents correctly and
> -	 * future cache lookups will also treat it as an empty, uninitialised
> -	 * buffer.
> +	 * Do a lockless fast path check for a valid uptodate buffer and avoid
> +	 * locking entirely in this case.
>  	 */
> -	xfs_buf_clear_flags(bp, XBF_DONE);
> -	xfs_buf_stale(bp);
> -	xfs_buf_relse(bp);
> +	if ((READ_ONCE(bp->b_flags) & (XBF_DONE | XBF_STALE)) == XBF_DONE)
> +		goto done;
>  
> -	/* bad CRC means corrupted metadata */
> -	if (error == -EFSBADCRC)
> -		return -EFSCORRUPTED;
> -	return error;
> +	/* xfs_buf_find_lock can't return an error with 0 flags */
> +	xfs_buf_find_lock(bp, 0);
> +	if (bp->b_flags & XBF_DONE) {
> +		xfs_buf_unlock(bp);
> +		goto done;
> +	}
> +	trace_xfs_buf_read_async(bp, 0, _RET_IP_);
> +	XFS_STATS_INC(btp->bt_mount, xb_get_read);
> +	xfs_buf_hold(bp);
> +	bp->b_ops = ops;
> +	xfs_buf_clear_flags(bp, XBF_WRITE);
> +	xfs_buf_set_flags(bp, XBF_READ | XBF_ASYNC);
> +	xfs_buf_submit(bp);
> +done:
> +	*bpp = bp;
> +	return 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index a4729253b56f..1b352ec91aa6 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -255,6 +255,10 @@ xfs_buf_readahead(
>  	return xfs_buf_readahead_map(target, &map, 1, ops);
>  }
>  
> +int xfs_buf_read_async(struct xfs_buftarg *btp, xfs_daddr_t daddr,
> +		size_t numblks, const struct xfs_buf_ops *ops,
> +		struct xfs_buf **bpp);
> +int xfs_buf_read_async_wait(struct xfs_buf *bp);
>  int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
>  		struct xfs_buf **bpp);
>  int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 2af9a1429ae9..afaabd3adc73 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -840,6 +840,9 @@ DEFINE_EVENT(xfs_buf_flags_class, name, \
>  	TP_ARGS(bp, flags, caller_ip))
>  DEFINE_BUF_FLAGS_EVENT(xfs_buf_get);
>  DEFINE_BUF_FLAGS_EVENT(xfs_buf_read);
> +DEFINE_BUF_FLAGS_EVENT(xfs_buf_read_async);
> +DEFINE_BUF_FLAGS_EVENT(xfs_buf_read_async_wait);
> +DEFINE_BUF_FLAGS_EVENT(xfs_buf_read_async_lock);
>  DEFINE_BUF_FLAGS_EVENT(xfs_buf_readahead);
>  
>  TRACE_EVENT(xfs_buf_ioerror,
> -- 
> 2.53.0
> 
> 
