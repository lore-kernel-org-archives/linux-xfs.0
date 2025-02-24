Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8B71F78E6
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 19:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424426; cv=none; b=GzXjdcht5Am8MelDT3go/gtw1GoEMEHgQdRgWbYJSi60yzv+lgkshYfjoFo5lMB7KjkHay2T/AFQDRbbMAlDTR+rNVQrPaaNzeDNF5h0PHtz+G9uJuC1RCgWTOTsWCvgcyms4Tr/FPikdTyNafrOyzYHH7Dz08pab2NxuMcYC/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424426; c=relaxed/simple;
	bh=etQI8p2cL5nDJAE2eWoRVCwgozvW2w6+Y0oa+bYaNUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9VK4cf/8N32w6GMTz6Pa9/FSTts45Mp0Gm7wZzPm9qemyhMIhXG0AcEnhkPgeBwdlq3rlkn1ZyrAYwbU0F8VrMBBljECjnMxxBq7P4oTLwPEGPg8uls+dUBvZ/DluH7b8pF6+CBF0FIqJgnT9FJIroVQFdN6M9h7g3J82QVlE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ThTg68DX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ThTg68DX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B0AC4CEE7;
	Mon, 24 Feb 2025 19:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740424425;
	bh=etQI8p2cL5nDJAE2eWoRVCwgozvW2w6+Y0oa+bYaNUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ThTg68DXZlf6qVMxkGNK9EySAl5PBSD+AKCCrGFLkrX/bvonUkigJHRLrcoir7rkQ
	 6rY0npo29X5pHZRFaDuAUhB51krGktDTqMiC9zKFkV879vtiuTMmrrV17Sd7cEuijI
	 RSZJbA5cKGOaLrFmoAK9C7j/udGfm5qgB2j/TqKPyXgRVfIHUK/wmvdVLdMLSygXMg
	 lMB0ytp6GNQrCeYUEJtLXS2/NFIj5sPwfUC7Rx1/YBMzgYSHPgaA9W8M35a1uP33cB
	 Q9RsZmJthp7utCXbzOdT9/OlbQ+fBZgLIMK0WPxPVJj8jnGIL/eOwJ7cHU7UJ78J5X
	 ky74QSrZgOopw==
Date: Mon, 24 Feb 2025 11:13:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: reduce context switches for synchronous
 buffered I/O
Message-ID: <20250224191345.GA21808@frogsfrogsfrogs>
References: <20250224151144.342859-1-hch@lst.de>
 <20250224151144.342859-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224151144.342859-2-hch@lst.de>

On Mon, Feb 24, 2025 at 07:11:35AM -0800, Christoph Hellwig wrote:
> Currently all metadata I/O completions happen in the m_buf_workqueue
> workqueue.  But for synchronous I/O (i.e. all buffer reads) there is no
> need for that, as there always is a called in process context that is
> waiting for the I/O.  Factor out the guts of xfs_buf_ioend into a
> separate helper and call it from xfs_buf_iowait to avoid a double
> an extra context switch to the workqueue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 43 +++++++++++++++++++++++++++----------------
>  1 file changed, 27 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 15bb790359f8..821aa85e2ce5 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1345,6 +1345,7 @@ xfs_buf_ioend_handle_error(
>  resubmit:
>  	xfs_buf_ioerror(bp, 0);
>  	bp->b_flags |= (XBF_DONE | XBF_WRITE_FAIL);
> +	reinit_completion(&bp->b_iowait);
>  	xfs_buf_submit(bp);
>  	return true;
>  out_stale:
> @@ -1355,8 +1356,9 @@ xfs_buf_ioend_handle_error(
>  	return false;
>  }
>  
> -static void
> -xfs_buf_ioend(
> +/* returns false if the caller needs to resubmit the I/O, else false */

"...else true" ?

--D

> +static bool
> +__xfs_buf_ioend(
>  	struct xfs_buf	*bp)
>  {
>  	trace_xfs_buf_iodone(bp, _RET_IP_);
> @@ -1376,7 +1378,7 @@ xfs_buf_ioend(
>  		}
>  
>  		if (unlikely(bp->b_error) && xfs_buf_ioend_handle_error(bp))
> -			return;
> +			return false;
>  
>  		/* clear the retry state */
>  		bp->b_last_error = 0;
> @@ -1397,7 +1399,15 @@ xfs_buf_ioend(
>  
>  	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD |
>  			 _XBF_LOGRECOVERY);
> +	return true;
> +}
>  
> +static void
> +xfs_buf_ioend(
> +	struct xfs_buf	*bp)
> +{
> +	if (!__xfs_buf_ioend(bp))
> +		return;
>  	if (bp->b_flags & XBF_ASYNC)
>  		xfs_buf_relse(bp);
>  	else
> @@ -1411,15 +1421,8 @@ xfs_buf_ioend_work(
>  	struct xfs_buf		*bp =
>  		container_of(work, struct xfs_buf, b_ioend_work);
>  
> -	xfs_buf_ioend(bp);
> -}
> -
> -static void
> -xfs_buf_ioend_async(
> -	struct xfs_buf	*bp)
> -{
> -	INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
> -	queue_work(bp->b_mount->m_buf_workqueue, &bp->b_ioend_work);
> +	if (__xfs_buf_ioend(bp))
> +		xfs_buf_relse(bp);
>  }
>  
>  void
> @@ -1491,7 +1494,13 @@ xfs_buf_bio_end_io(
>  		 XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
>  		xfs_buf_ioerror(bp, -EIO);
>  
> -	xfs_buf_ioend_async(bp);
> +	if (bp->b_flags & XBF_ASYNC) {
> +		INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
> +		queue_work(bp->b_mount->m_buf_workqueue, &bp->b_ioend_work);
> +	} else {
> +		complete(&bp->b_iowait);
> +	}
> +
>  	bio_put(bio);
>  }
>  
> @@ -1568,9 +1577,11 @@ xfs_buf_iowait(
>  {
>  	ASSERT(!(bp->b_flags & XBF_ASYNC));
>  
> -	trace_xfs_buf_iowait(bp, _RET_IP_);
> -	wait_for_completion(&bp->b_iowait);
> -	trace_xfs_buf_iowait_done(bp, _RET_IP_);
> +	do {
> +		trace_xfs_buf_iowait(bp, _RET_IP_);
> +		wait_for_completion(&bp->b_iowait);
> +		trace_xfs_buf_iowait_done(bp, _RET_IP_);
> +	} while (!__xfs_buf_ioend(bp));
>  
>  	return bp->b_error;
>  }
> -- 
> 2.45.2
> 
> 
