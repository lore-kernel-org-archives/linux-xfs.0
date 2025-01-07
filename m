Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2113A1DED66
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736231510; cv=none; b=D57yl10/UL4o8gAgTZzVXL33b2TtyWgw85K5CCC45djw+yTeBpr59E7/icSrH6wNPELVj6JT1k8+B8xtUJBsvUIbXJ8wq+l6STbzdNz6A3OiHCq2m5tHyJxw3HnXUFe/opkmKYRfjLA9HgouNIK+GHhCPajXtLCaqaPDYxnSwYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736231510; c=relaxed/simple;
	bh=2RHo27qkpPyrl4n3jlKmGulEHkH5BFY2aXsGTkwYlS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBpLsOoeYXIMeCXPFKv9KcDRojRqTOczo6Ky0b6xiCHquyYzB3l25IXvweeYqawcLhYW9YV26Ev7jCu2oWHbibzKYLxIQRIg2mn9PlyDaSbOhq7pkJFE4o1m4dftTkJkDEx1NepCMX35AcUuodKIqIMdpwz8j+PGq/1xp6UuQA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oTui7VjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oTui7VjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6663FC4CEDE;
	Tue,  7 Jan 2025 06:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736231509;
	bh=2RHo27qkpPyrl4n3jlKmGulEHkH5BFY2aXsGTkwYlS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oTui7VjFrXhdEgpbOyhlTedu1SsHOxpFhDD3+Jyf68+fadCzdlUPpM8g1wgDyEuox
	 YUxxwCDmCPwCQEu/uMvKDaPq9+mvkfh5XQby2lCJNDBTREFFqyW+CfqOCCqvDGdr2x
	 +XxzbqsOPEaDSuESyRPDgaxecz0TNQ+5lRWJila6zwqv40sflZTr/bCgOHCSg06GdH
	 M36u3aOKJkVlyvFrFoIIAke/6E1uBwgozTr+QP5nxnxRiuZucAJ2qMSy+Vw5salp8J
	 LTA3neyal7PKyMxyTmtv8IO95Uj0PRc8XmWF/viFClvGQZrKp1xqQ40AKAoqJl6Ow3
	 H4aqEXy4J2fLg==
Date: Mon, 6 Jan 2025 22:31:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/15] xfs: remove xfs_buf_delwri_submit_buffers
Message-ID: <20250107063148.GX6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-7-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:43AM +0100, Christoph Hellwig wrote:
> xfs_buf_delwri_submit_buffers has two callers for synchronous and
> asynchronous writes that share very little logic.  Split out a helper for
> the shared per-buffer loop and otherwise open code the submission in the
> two callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 121 +++++++++++++++++++++--------------------------
>  1 file changed, 55 insertions(+), 66 deletions(-)

Sheesh, splitting a function into two reduces line count by 11??
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 7edd7a1e9dae..e48d796c786b 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2259,72 +2259,26 @@ xfs_buf_cmp(
>  	return 0;
>  }
>  
> -/*
> - * Submit buffers for write. If wait_list is specified, the buffers are
> - * submitted using sync I/O and placed on the wait list such that the caller can
> - * iowait each buffer. Otherwise async I/O is used and the buffers are released
> - * at I/O completion time. In either case, buffers remain locked until I/O
> - * completes and the buffer is released from the queue.
> - */
> -static int
> -xfs_buf_delwri_submit_buffers(
> -	struct list_head	*buffer_list,
> -	struct list_head	*wait_list)
> +static bool
> +xfs_buf_delwri_submit_prep(
> +	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf		*bp, *n;
> -	int			pinned = 0;
> -	struct blk_plug		plug;
> -
> -	list_sort(NULL, buffer_list, xfs_buf_cmp);
> -
> -	blk_start_plug(&plug);
> -	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
> -		if (!wait_list) {
> -			if (!xfs_buf_trylock(bp))
> -				continue;
> -			if (xfs_buf_ispinned(bp)) {
> -				xfs_buf_unlock(bp);
> -				pinned++;
> -				continue;
> -			}
> -		} else {
> -			xfs_buf_lock(bp);
> -		}
> -
> -		/*
> -		 * Someone else might have written the buffer synchronously or
> -		 * marked it stale in the meantime.  In that case only the
> -		 * _XBF_DELWRI_Q flag got cleared, and we have to drop the
> -		 * reference and remove it from the list here.
> -		 */
> -		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
> -			xfs_buf_list_del(bp);
> -			xfs_buf_relse(bp);
> -			continue;
> -		}
> -
> -		trace_xfs_buf_delwri_split(bp, _RET_IP_);
> -
> -		/*
> -		 * If we have a wait list, each buffer (and associated delwri
> -		 * queue reference) transfers to it and is submitted
> -		 * synchronously. Otherwise, drop the buffer from the delwri
> -		 * queue and submit async.
> -		 */
> -		bp->b_flags &= ~_XBF_DELWRI_Q;
> -		bp->b_flags |= XBF_WRITE;
> -		if (wait_list) {
> -			bp->b_flags &= ~XBF_ASYNC;
> -			list_move_tail(&bp->b_list, wait_list);
> -		} else {
> -			bp->b_flags |= XBF_ASYNC;
> -			xfs_buf_list_del(bp);
> -		}
> -		xfs_buf_submit(bp);
> +	/*
> +	 * Someone else might have written the buffer synchronously or marked it
> +	 * stale in the meantime.  In that case only the _XBF_DELWRI_Q flag got
> +	 * cleared, and we have to drop the reference and remove it from the
> +	 * list here.
> +	 */
> +	if (!(bp->b_flags & _XBF_DELWRI_Q)) {
> +		xfs_buf_list_del(bp);
> +		xfs_buf_relse(bp);
> +		return false;
>  	}
> -	blk_finish_plug(&plug);
>  
> -	return pinned;
> +	trace_xfs_buf_delwri_split(bp, _RET_IP_);
> +	bp->b_flags &= ~_XBF_DELWRI_Q;
> +	bp->b_flags |= XBF_WRITE;
> +	return true;
>  }
>  
>  /*
> @@ -2347,7 +2301,30 @@ int
>  xfs_buf_delwri_submit_nowait(
>  	struct list_head	*buffer_list)
>  {
> -	return xfs_buf_delwri_submit_buffers(buffer_list, NULL);
> +	struct xfs_buf		*bp, *n;
> +	int			pinned = 0;
> +	struct blk_plug		plug;
> +
> +	list_sort(NULL, buffer_list, xfs_buf_cmp);
> +
> +	blk_start_plug(&plug);
> +	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
> +		if (!xfs_buf_trylock(bp))
> +			continue;
> +		if (xfs_buf_ispinned(bp)) {
> +			xfs_buf_unlock(bp);
> +			pinned++;
> +			continue;
> +		}
> +		if (!xfs_buf_delwri_submit_prep(bp))
> +			continue;
> +		bp->b_flags |= XBF_ASYNC;
> +		xfs_buf_list_del(bp);
> +		xfs_buf_submit(bp);
> +	}
> +	blk_finish_plug(&plug);
> +
> +	return pinned;
>  }
>  
>  /*
> @@ -2364,9 +2341,21 @@ xfs_buf_delwri_submit(
>  {
>  	LIST_HEAD		(wait_list);
>  	int			error = 0, error2;
> -	struct xfs_buf		*bp;
> +	struct xfs_buf		*bp, *n;
> +	struct blk_plug		plug;
>  
> -	xfs_buf_delwri_submit_buffers(buffer_list, &wait_list);
> +	list_sort(NULL, buffer_list, xfs_buf_cmp);
> +
> +	blk_start_plug(&plug);
> +	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
> +		xfs_buf_lock(bp);
> +		if (!xfs_buf_delwri_submit_prep(bp))
> +			continue;
> +		bp->b_flags &= ~XBF_ASYNC;
> +		list_move_tail(&bp->b_list, &wait_list);
> +		xfs_buf_submit(bp);
> +	}
> +	blk_finish_plug(&plug);
>  
>  	/* Wait for IO to complete. */
>  	while (!list_empty(&wait_list)) {
> -- 
> 2.45.2
> 
> 
