Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CB486333
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736231664; cv=none; b=p2f0E3zygN4cH1GVLm5PVAV7vuLdCTYydFalqMVuJ2A54L3lsprhzeBrko2uqQVRt1yIBD9v7+8vJKjwCN4NaZSNipXvWvu6P2VqhHTaAxfd7GVxrAS4ovx/jY1ITGBjRXKuhnz1RGl93jhuEj83Q8zCw0z+tr7h+42kuX2d7gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736231664; c=relaxed/simple;
	bh=F/szLSP3j/jw4eoIxcu10GNBgAvlK8lDI96Syk9zfxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iH+bnoATFWEz8iNdrAIx2rebkR8f+L4MO7W4k4DZFbHztDTBFheB7YwsjURZVjrD/jVzaSY3IaYqJpvDR4geAnA/1/D3RsuwOwZ98EmcBnrOVxBO2c7XvhgjT+oaBFIPbulZWcbb2GdDlJQQcD+C6CLQG/ypMVC5UISxDpSSdUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slkr5KiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slkr5KiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD563C4CED6;
	Tue,  7 Jan 2025 06:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736231663;
	bh=F/szLSP3j/jw4eoIxcu10GNBgAvlK8lDI96Syk9zfxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=slkr5KiBOeJMAw/tE7vp2I9wKYXl/dvtoF5g4O9c9DhLaeIrJs1+/xCIgmhtypTYM
	 2qnfk/s2e+BGdk2S1AiIkI0JgDdfblrKD2bb5ctUuwrxDNNntGmVgOywn2ec1iMDMr
	 Ng1gLpp5BbWXSlVHO/2YCtY0P/In5ceDI08wITsTbzaTnLM0H3HUwIF+JdPkD9A8G0
	 lOIHLACAeffN+GZ/cCCD8rp1Nyltmt0Q1AOaY4O/jRrhluo+tbaU54dOSEJcObKFx6
	 P3be2Oor7+Ztv4a11GcREz7+38an6yFOjeaydMY7K8DdFFHJAK82VlZ/gKVSKvsHjs
	 YRrT9/a/n00tg==
Date: Mon, 6 Jan 2025 22:34:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/15] xfs: move in-memory buftarg handling out of
 _xfs_buf_ioapply
Message-ID: <20250107063423.GZ6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-9-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:45AM +0100, Christoph Hellwig wrote:
> No I/O to apply for in-memory buffers, so skip the function call
> entirely.  Clean up the b_io_error initialization logic to allow
> for this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 18e830c4e990..e886605b5721 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1607,12 +1607,6 @@ _xfs_buf_ioapply(
>  	int		size;
>  	int		i;
>  
> -	/*
> -	 * Make sure we capture only current IO errors rather than stale errors
> -	 * left over from previous use of the buffer (e.g. failed readahead).
> -	 */
> -	bp->b_error = 0;
> -
>  	if (bp->b_flags & XBF_WRITE) {
>  		op = REQ_OP_WRITE;
>  	} else {
> @@ -1624,10 +1618,6 @@ _xfs_buf_ioapply(
>  	/* we only use the buffer cache for meta-data */
>  	op |= REQ_META;
>  
> -	/* in-memory targets are directly mapped, no IO required. */
> -	if (xfs_buftarg_is_mem(bp->b_target))
> -		return;
> -
>  	/*
>  	 * Walk all the vectors issuing IO on them. Set up the initial offset
>  	 * into the buffer and the desired IO size before we start -
> @@ -1740,7 +1730,11 @@ xfs_buf_submit(
>  	if (bp->b_flags & XBF_WRITE)
>  		xfs_buf_wait_unpin(bp);
>  
> -	/* clear the internal error state to avoid spurious errors */
> +	/*
> +	 * Make sure we capture only current IO errors rather than stale errors
> +	 * left over from previous use of the buffer (e.g. failed readahead).
> +	 */
> +	bp->b_error = 0;
>  	bp->b_io_error = 0;
>  
>  	/*
> @@ -1757,6 +1751,10 @@ xfs_buf_submit(
>  		goto done;
>  	}
>  
> +	/* In-memory targets are directly mapped, no I/O required. */
> +	if (xfs_buftarg_is_mem(bp->b_target))
> +		goto done;
> +
>  	_xfs_buf_ioapply(bp);
>  
>  done:
> -- 
> 2.45.2
> 
> 
