Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F58931F983
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 18:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412204; cv=none; b=ZpoLZnecslT3Ug3tF5iWO8b3mVBwBiZDgNDupqWWZvL28yA3hsb/bTkrDovbvsoQPwOt7HePMjGYPzO1ENbxP4uMitqAuZFbv73HCsp9w/g/w9F6TEQxKQ2/Q7c4G/9df1hirB6Hyk3fEQoBSIXXGQ+OR021gwTAC41BT6OLDFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412204; c=relaxed/simple;
	bh=NdfNntnfOawreP92EdrUKHXwSWNiRHv7ElZ0KucX4Sk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvNmpUOZceCYJeBYvm4ukaLT1aa/IjNy73YQ+WbRsSJ2GF6WebhPbjTPoswuy0Yy7rbfhKHo8V1V7/bFU5UFChCFD7fty3fzGX5jznYW+mbbNtIs+vAkBNzRMra0xqx1LZbD38doGGCKfvJtvpwUWkA6VRV2PepBuNikmWSUN0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9aE8JIu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9aE8JIu"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 386F01F000E9;
	Thu, 25 Jun 2026 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412203;
	bh=WZ8mRzWnu9xLxZ4bBzgG6H1128Trmx8uSbzhmqKU1ls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z9aE8JIuGpKjryOV9nniZvYYGcZGBKR1DuUfUbGx/M0NDrkroWvp+oF63A32vJF33
	 o/6tpVu8H+AfKjhiZquX7DcsNupFBMmRKUHSJXnOIcgf6VXItWnBfx0iipBTktLSSc
	 BUGlrMwMV0eQpF5w+jb/B6SQIeKVbz5flGhnwbt0Ih6v6gjdNlbI1ZvYUseTUmB0E9
	 KmddijreUtdSsfsz5OpRh03YitQ4g24ru8RbVUa7ht9PcpEUYW2MFQao3L7vyO5pZC
	 xFjkE2kROry4nTSFOgkAyW43NbUb1Xtfy+8n9Di0FyVR5RFcCi+qxt1Etf1soiK6YS
	 FwJhr9DSp7a5g==
Date: Thu, 25 Jun 2026 11:30:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 6/6] xfs: simplify __xfs_buf_ioend
Message-ID: <20260625183002.GK6078@frogsfrogsfrogs>
References: <20260625135849.2494779-1-hch@lst.de>
 <20260625135849.2494779-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625135849.2494779-7-hch@lst.de>

On Thu, Jun 25, 2026 at 03:58:36PM +0200, Christoph Hellwig wrote:
> __xfs_buf_ioend can only resubmit the buffer for asynchronous
> writes, which means the retry handling xfs_buf_iowait is not needed.
> 
> Because of this can stop returning a value from __xfs_buf_ioend and
> just release the buffer for async I/O that does not require retries.
> 
> Also drop the __-prefix now that the semantics are straight forward.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

This makes sense to me -- only async writes (e.g. logged buffers written
by the ail) get to go through the write retry mechanism; the synchronous
writers are either regular threads and can report errors, or they're
dquot/inode items and a cluster flush just marks the log item as failed.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 51 ++++++++++++++++++++++++------------------------
>  1 file changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 83549573e2cc..f8511c11e017 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1098,11 +1098,17 @@ xfs_buf_ioend_handle_error(
>  	return false;
>  }
>  
> -/* returns false if the caller needs to resubmit the I/O, else true */
> -static bool
> -__xfs_buf_ioend(
> +/*
> + * Complete a buffer read or write.
> + *
> + * Releases the buffer if the I/O was asynchronous.
> + */
> +static void
> +xfs_buf_ioend(
>  	struct xfs_buf	*bp)
>  {
> +	bool		async = bp->b_flags & XBF_ASYNC;
> +
>  	trace_xfs_buf_iodone(bp, _RET_IP_);
>  
>  	if (bp->b_flags & XBF_READ) {
> @@ -1116,14 +1122,16 @@ __xfs_buf_ioend(
>  		if (bp->b_flags & XBF_READ_AHEAD)
>  			percpu_counter_dec(&bp->b_target->bt_readahead_count);
>  	} else {
> -		if (!bp->b_error) {
> +		if (unlikely(bp->b_error)) {
> +			if (xfs_buf_ioend_handle_error(bp)) {
> +				ASSERT(async);
> +				return;
> +			}
> +		} else {
>  			bp->b_flags &= ~XBF_WRITE_FAIL;
>  			bp->b_flags |= XBF_DONE;
>  		}
>  
> -		if (unlikely(bp->b_error) && xfs_buf_ioend_handle_error(bp))
> -			return false;
> -
>  		/* clear the retry state */
>  		bp->b_last_error = 0;
>  		bp->b_retries = 0;
> @@ -1143,18 +1151,15 @@ __xfs_buf_ioend(
>  
>  	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD |
>  			 _XBF_LOGRECOVERY);
> -	return true;
> +	if (async)
> +		xfs_buf_relse(bp);
>  }
>  
>  static void
>  xfs_buf_ioend_work(
>  	struct work_struct	*work)
>  {
> -	struct xfs_buf		*bp =
> -		container_of(work, struct xfs_buf, b_ioend_work);
> -
> -	if (__xfs_buf_ioend(bp))
> -		xfs_buf_relse(bp);
> +	xfs_buf_ioend(container_of(work, struct xfs_buf, b_ioend_work));
>  }
>  
>  void
> @@ -1195,8 +1200,7 @@ xfs_buf_fail(
>  	bp->b_flags &= ~XBF_DONE;
>  	xfs_buf_stale(bp);
>  	xfs_buf_ioerror(bp, -EIO);
> -	if (__xfs_buf_ioend(bp))
> -		xfs_buf_relse(bp);
> +	xfs_buf_ioend(bp);
>  }
>  
>  int
> @@ -1305,12 +1309,11 @@ xfs_buf_iowait(
>  {
>  	ASSERT(!(bp->b_flags & XBF_ASYNC));
>  
> -	do {
> -		trace_xfs_buf_iowait(bp, _RET_IP_);
> -		wait_for_completion(&bp->b_iowait);
> -		trace_xfs_buf_iowait_done(bp, _RET_IP_);
> -	} while (!__xfs_buf_ioend(bp));
> +	trace_xfs_buf_iowait(bp, _RET_IP_);
> +	wait_for_completion(&bp->b_iowait);
> +	trace_xfs_buf_iowait_done(bp, _RET_IP_);
>  
> +	xfs_buf_ioend(bp);
>  	return bp->b_error;
>  }
>  
> @@ -1403,12 +1406,10 @@ xfs_buf_submit(
>  	bp->b_flags &= ~XBF_DONE;
>  	xfs_buf_stale(bp);
>  end_io:
> -	if (bp->b_flags & XBF_ASYNC) {
> -		if (__xfs_buf_ioend(bp))
> -			xfs_buf_relse(bp);
> -	} else {
> +	if (bp->b_flags & XBF_ASYNC)
> +		xfs_buf_ioend(bp);
> +	else
>  		complete(&bp->b_iowait);
> -	}
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 
