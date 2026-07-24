Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9D443C045
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784912338; cv=none; b=lnz+GCO+yj59JOn3CGMR77rKh6FN4UyFso9zlu3UT79DX72W0H8vSRcXYkuXQOr1RWpkCkrBVMoIvJsBRD4bmg8J/Y7gXwm1JOTzZXMxGBvzqJjiSYv81f5Lm23tIXKjzlrKVHjWni5FNH+tnE0F+U8aMG+fZlBRlmfcq/KAO/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784912338; c=relaxed/simple;
	bh=Eof9SiKOiM32REEKoqduDMt+GHrcUsk+T6VLehyJ9Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWGLaBkHalPYk4mQ2Lk1e0CwlCHMccnjjZ3RSvDikETL6a71Llv4Dx/DRByjHXsnmZvOk7I4/jQ8SOCS89yQzh4d4Jm+zbjYpr1VjAyJwCJxg1dWTubmr46aYOc0X+P9Jkqdhqhh+VJ3umZ1vuU/2lrJn3RmhZ19XsyPPz24vPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oIQWcpOl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oIQWcpOl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8F6541F000E9;
	Fri, 24 Jul 2026 16:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784912334;
	bh=HmDfxBBdgiQ0I5WzBSAKxVUBUHBQCexUiQYmPWxl8ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oIQWcpOlEcsoH6lXXpKBFw71DsNLOB6M3BwATCvwIv6SwNWs0YASivHjPzLUt4hJN
	 Bh0TWNxIhCZN28dYejVUBMbAvcuLbvRryDaWDmAYZmYw/5UI+EmM4PZ+Nmw7trBK0y
	 tB98RN3ttsqHPdlpOZ2bnswVB9Pi5N7h9ZDUbOqrKaAk/hjqjXuWFysdxOvXxTyFZu
	 I7p1IJXZ7U9U9VZCO92Ba0ocER5OrQy/51zzOKoTacHOLGfDbwPbr6+N5B3fpSJPjD
	 3v1XWMaUuKth9gLpKBfNSXcRAk1pettRX0I9ZGO0YcSTvYjXJcFOrsRUyw0iwloj2e
	 ppNjVRY2au7aw==
Date: Fri, 24 Jul 2026 09:58:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: merge xfs_buf_reverify into xfs_buf_read_map
Message-ID: <20260724165854.GX2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-11-hch@lst.de>

On Wed, Jul 15, 2026 at 04:51:03PM +0200, Christoph Hellwig wrote:
> xfs_buf_read_map is the only caller of xfs_buf_reverify that is left.
> Merge it into that so that the comments can be moved closer to the
> logic, and redundant asserts can be removed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 79 ++++++++++++++++++++++--------------------------
>  1 file changed, 36 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 21c21491d72e..be3b25ccbea6 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -626,41 +626,6 @@ _xfs_buf_read(
>  	return xfs_buf_iowait(bp);
>  }
>  
> -/*
> - * Reverify a buffer found in cache without an attached ->b_ops.
> - *
> - * If the caller passed an ops structure and the buffer doesn't have ops
> - * assigned, set the ops and use it to verify the contents. If verification
> - * fails, clear XBF_DONE. We assume the buffer has no recorded errors and is
> - * already in XBF_DONE state on entry.
> - *
> - * Under normal operations, every in-core buffer is verified on read I/O
> - * completion. There are two scenarios that can lead to in-core buffers without
> - * an assigned ->b_ops. The first is during log recovery of buffers on a V4
> - * filesystem, though these buffers are purged at the end of recovery. The
> - * other is online repair, which intentionally reads with a NULL buffer ops to
> - * run several verifiers across an in-core buffer in order to establish buffer
> - * type.  If repair can't establish that, the buffer will be left in memory
> - * with NULL buffer ops.
> - */
> -static int
> -xfs_buf_reverify(
> -	struct xfs_buf		*bp,
> -	const struct xfs_buf_ops *ops)
> -{
> -	ASSERT(bp->b_flags & XBF_DONE);
> -	ASSERT(bp->b_error == 0);
> -
> -	if (!ops || bp->b_ops)
> -		return 0;
> -
> -	bp->b_ops = ops;
> -	bp->b_ops->verify_read(bp);
> -	if (bp->b_error)
> -		xfs_buf_clear_flags(bp, XBF_DONE);
> -	return bp->b_error;
> -}
> -
>  int
>  xfs_buf_read_map(
>  	struct xfs_buftarg	*target,
> @@ -685,18 +650,46 @@ xfs_buf_read_map(
>  
>  	trace_xfs_buf_read(bp, flags, _RET_IP_);
>  
> -	if (!(bp->b_flags & XBF_DONE)) {
> +	if (bp->b_flags & XBF_DONE) {
> +		ASSERT(bp->b_error == 0);
> +
> +		/*
> +		 * If the caller passed an ops structure and the buffer doesn't
> +		 * have ops assigned yet, set the ops and use them to verify the
> +		 * buffer contents.
> +		 *
> +		 * Under normal operations, every in-core buffer is verified on
> +		 * read I/O completion, but there are two scenarios that can
> +		 * lead to in-core buffers without an assigned ->b_ops:
> +		 *
> +		 *   1) During log recovery of buffers on a V4 filesystem.
> +		 *	These buffers are purged at the end of recovery, though.
> +		 *   2) Oonline repair intentionally reads with a NULL buffer

s/Oonline/Online/ like bfoster said.

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +		 *	ops to run several verifiers across an in-core buffer in
> +		 *	order to establish buffer type.  If repair can't
> +		 *	establish that, the buffer will be left in memory with
> +		 *	NULL buffer ops.
> +		 */
> +		if (ops && !bp->b_ops) {
> +			bp->b_ops = ops;
> +			bp->b_ops->verify_read(bp);
> +			/*
> +			 * If verification failed, clear XBF_DONE as we assume
> +			 * that buffers have no recorded errors when in XBF_DONE
> +			 * state.
> +			 */
> +			error = bp->b_error;
> +			if (error)
> +				xfs_buf_clear_flags(bp, XBF_DONE);
> +		}
> +
> +		/* We do not want read in the flags */
> +		xfs_buf_clear_flags(bp, XBF_READ);
> +	} else {
>  		/* Initiate the buffer read and wait. */
>  		XFS_STATS_INC(target->bt_mount, xb_get_read);
>  		bp->b_ops = ops;
>  		error = _xfs_buf_read(bp);
> -	} else {
> -		/* Buffer already read; all we need to do is check it. */
> -		error = xfs_buf_reverify(bp, ops);
> -
> -		/* We do not want read in the flags */
> -		xfs_buf_clear_flags(bp, XBF_READ);
> -		ASSERT(bp->b_ops != NULL || ops == NULL);
>  	}
>  
>  	if (error)
> -- 
> 2.53.0
> 
> 
