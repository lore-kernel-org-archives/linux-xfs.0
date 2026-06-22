Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87453B8944
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 14:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782137448; cv=none; b=Kf0Yxn1FGqTIg5+4gS8+00c07auVwfS7JESqoiA+PNwL1ieqqWMcA7tQpEirxG8wrC61jpk4jJs+SxiCuC9dPaVTV2yjqlQNT0f0JjW5/+gc2hJcXBbC2KD+vr6iQGpBUHKsohCsjHE3/7KZZ1y/nKUdELGqB9IRRsvknsP+62E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782137448; c=relaxed/simple;
	bh=5hTOLK18CsMjPRF4uLq68fFU8pKnrnLHWpvDJQS5/78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4ckW2bxJZJgWMJpWMPYIRaSUnviFCW45dJSc6wTyGjuvSj51cab/cqI6bsvnP4aWhWIsQHIg1qPi+UOHACUBEPs6/tT/E19O3fSBhPVTbeQvf96zF7lW/xduLwlmDtL92zsieSGaa68jAb8iL5fY0oKJNY3Ycvx4pWz/57jBlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KSqoU2Az; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSqoU2Az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D562E1F000E9;
	Mon, 22 Jun 2026 14:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782137443;
	bh=kpkYlwJfR73XZ98h+hJNDUlowHN8isUK3SCPjY6sqOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KSqoU2AzgeoLBdBU404CXGvyEkG+SF2v4e1WnKiAMyu7jwOWBKPONRTEpb7XkI3q4
	 6jww1qJwNQn3CgzYtOdRzy1G0gcR1/z/v/aKRvh4OSsU8lTvyNqenVB+katVpr34D1
	 f6odNpr1ASh02TRiie9z/bgYaWq7fBsVSCc3SMQycBCD+jkcqRWRm24DOsqoABh0qa
	 fLH4f7CFrzMQYaXtKFA6FKBRpQqU5TM+H5jHILlnJLuOcg3OoissYI/zE7hK/rJ/my
	 FNwCbP946hj9cZ2rnwDiavE1mbugWlpQvpZX4qiXTTwrKuVOeuyNx3M9qZq187jwVb
	 VzyWM7jKLOXPw==
Date: Mon, 22 Jun 2026 16:10:40 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: simplify __xfs_buf_ioend
Message-ID: <ajlCVW7bsYqnQzGJ@nidhogg.toxiclabs.cc>
References: <20260622073035.1370904-1-hch@lst.de>
 <20260622073035.1370904-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622073035.1370904-7-hch@lst.de>

On Mon, Jun 22, 2026 at 09:30:05AM +0200, Christoph Hellwig wrote:
> __xfs_buf_ioend can only resubmit the buffer for asynchronous
> writes, which means the retry handling xfs_buf_iowait is not needed.
> 
> Because of this can stop returning a value from __xfs_buf_ioend and
> just release the buffer for async I/O that does not require retries.
> 
> Also drop the __-prefix now that the semantics are straight forward.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  fs/xfs/xfs_buf.c | 51 ++++++++++++++++++++++++------------------------
>  1 file changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ffaab0feb230..b66bbcab91aa 100644
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
