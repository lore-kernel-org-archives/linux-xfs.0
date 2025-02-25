Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F1020766B
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 05:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740461855; cv=none; b=BfRqvT0Hb2VZbs+h0t4oo6uzCPaNJdDxwp6+jvnMmpiyIF50m2SsbsftWqaElDde7FoysYNyyuqa8UhdPr5zuuPAW1S2SqSw11TTIl/JEdrOw9sE4kSgmsGFRQJQagrGqh4RNK3oOx671Kc4GsJjehYLaH2/WvdzNzoGuV5zqSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740461855; c=relaxed/simple;
	bh=91QSIBloCfatjopexa1z3vaKeaVwlUl4DyYpAtn2eLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuAr327lvyBLN6pgj3dZglYbh682LI5J7ZTwExVD+9cyGN27cRC66kbp3ZdOuno9u83fA/MCvAEXZC+KqM7SzKiKodSl+i7jFN2lSE5Ze6QdXzZjqSLvuUxBbVmsMHcbk5PEF3NdvxBTR+QcIZFBD80tWgJgm3N5oKVW9GVJHEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RsKJ7Qg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RsKJ7Qg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E5BC4CEDD;
	Tue, 25 Feb 2025 05:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740461855;
	bh=91QSIBloCfatjopexa1z3vaKeaVwlUl4DyYpAtn2eLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RsKJ7Qg/d0sSWNetigvipi83rcmRkRCmsPy3TIqeR9UOUgZm400tLQg8BdTDYMB1g
	 q4w5s0qlaC+Q15633ObaUhvAFUX8US9W555ys4JiY/ia8volG05Bw2QixgSS+PrL56
	 VWXaRv58BES6jz9eIThQVnEr1h8osbjEEFiFImsYZK/yzL8830393JKre83KvEjzxZ
	 +80BE06o5ya9q8q3ijADltQMYc2rBneWD0mOYV1R9vWHH+CBaOKzDi/THHpUCsjXWQ
	 IQtNtXDa76eORZLtKW5eqbdf1iHSE0d0LqT17En/TRG9iUluwuTqLxaV6fbzCRrbES
	 lzcA8eD7EXpKQ==
Date: Mon, 24 Feb 2025 21:37:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/4] xfs: reduce context switches for synchronous
 buffered I/O
Message-ID: <20250225053734.GA6242@frogsfrogsfrogs>
References: <20250224234903.402657-1-hch@lst.de>
 <20250224234903.402657-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224234903.402657-2-hch@lst.de>

On Mon, Feb 24, 2025 at 03:48:52PM -0800, Christoph Hellwig wrote:
> Currently all metadata I/O completions happen in the m_buf_workqueue
> workqueue.  But for synchronous I/O (i.e. all buffer reads) there is no
> need for that, as there always is a called in process context that is
> waiting for the I/O.  Factor out the guts of xfs_buf_ioend into a
> separate helper and call it from xfs_buf_iowait to avoid a double
> an extra context switch to the workqueue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good now,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 43 +++++++++++++++++++++++++++----------------
>  1 file changed, 27 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 15bb790359f8..dfc1849b3314 100644
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
> +/* returns false if the caller needs to resubmit the I/O, else true */
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
