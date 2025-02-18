Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3614F1BC9EE
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 20:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739909153; cv=none; b=l1VmknBsRNQAJSJ6+U3cTMnuZ6pZ+HBuOTtSfE2qpWwriajXXdoHXQ+w+LfS2fdv540DbMOxEuMp2utsSsChGjUqL1p9nkFWtuFAV86ZZmSy20PSpXVOiuubZ+I6WYs3jMwSJsCXwFvDL0na/ov0D1P7dx99YZI8E0oFbe3avaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739909153; c=relaxed/simple;
	bh=9WFI1ZccIDnvZQYlaQWcAWg3jh0G4VIUDdS1VVd1ESE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GMLmgeR7LWHPL410VC7/h+O2l4lV7H8G8i4TQqOI+iUhUyFt+i/OfNA3BU/0p8Q5WlshWXKBBdAS11tzQfOrVOCgAsh2mxscUQJ2GX9HOh8Xui5Oj3rYbEe52wPoOOcruasFX3tA2RmAJJiHOLuxoxsQVkvhxVcygfBgBsx95ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQsnQQzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQsnQQzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B3AC4CEE2;
	Tue, 18 Feb 2025 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739909151;
	bh=9WFI1ZccIDnvZQYlaQWcAWg3jh0G4VIUDdS1VVd1ESE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kQsnQQzyS588RsBSzHwwoB/JUIaMZ2TgoNRmZ0dDy167G2CVKQT0sRyFcbZ2cbxzK
	 wJ4bmRPW1sQvWsCd0I1ABbqMt9GW9bgjwsdK4I0o0P2XyKgmC4YAzhwhmigQt4xUkC
	 FbUfMr8qJzZfsmMfQUOmojKcQjWaW0Sc3zvO5OjMeooDAh79TwMPxmy9Ikf3yTUOvK
	 sbU34zL4bmcIa17Fe/3butco4yy+VNpouYQh5/hh+QEqC/30h1zWIctRHYli9WWOxJ
	 H4z+5p5EkA3ua3oIESFQQsrVSamYyT0BI6JhAr34O5yz+jMSzhYI6Nf63Ya9wKhoFX
	 HiGXglA03JWkQ==
Date: Tue, 18 Feb 2025 12:05:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: reduce context switches for synchronous
 buffered I/O
Message-ID: <20250218200551.GG21808@frogsfrogsfrogs>
References: <20250217093207.3769550-1-hch@lst.de>
 <20250217093207.3769550-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217093207.3769550-2-hch@lst.de>

On Mon, Feb 17, 2025 at 10:31:26AM +0100, Christoph Hellwig wrote:
> Currently all metadata I/O completions happen in the m_buf_workqueue
> workqueue.  But for synchronous I/O (i.e. all buffer reads) there is no
> need for that, as there always is a called in process context that is
> waiting for the I/O.  Factor out the guts of xfs_buf_ioend into a
> separate helper and call it from xfs_buf_iowait to avoid a double
> an extra context switch to the workqueue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 42 ++++++++++++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 15bb790359f8..050f2c2f6a40 100644
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
> @@ -1355,8 +1356,8 @@ xfs_buf_ioend_handle_error(
>  	return false;
>  }
>  
> -static void
> -xfs_buf_ioend(
> +static bool
> +__xfs_buf_ioend(

What does the return value here indicate?  I /think/ it's true if the IO
is really complete, or false if we're going to retry?  But maybe it
actually means true if the bp reference is still live?  A comment would
be really helpful here.

--D

>  	struct xfs_buf	*bp)
>  {
>  	trace_xfs_buf_iodone(bp, _RET_IP_);
> @@ -1376,7 +1377,7 @@ xfs_buf_ioend(
>  		}
>  
>  		if (unlikely(bp->b_error) && xfs_buf_ioend_handle_error(bp))
> -			return;
> +			return false;
>  
>  		/* clear the retry state */
>  		bp->b_last_error = 0;
> @@ -1397,7 +1398,15 @@ xfs_buf_ioend(
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
> @@ -1411,15 +1420,8 @@ xfs_buf_ioend_work(
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
> @@ -1491,7 +1493,13 @@ xfs_buf_bio_end_io(
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
> @@ -1568,9 +1576,11 @@ xfs_buf_iowait(
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
