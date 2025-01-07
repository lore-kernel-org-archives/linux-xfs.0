Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABB21DF987
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736232405; cv=none; b=qX9iz4aTb1U9hYcLq0RytXYCsAtInqghWYUh0ef2Vl2Cv2WS9YOcwYSLKYLOmTqqM6FT9TR4UkQ/dzdiRwX/ttfkjp5q7KEaQ854kuIFwr9zUnEfzWNyy4v+4fZkV9E2KjmOav4vdApBJzLsyQ8T7itptIFK3TD4LEh+lj4zPds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736232405; c=relaxed/simple;
	bh=lnP6axu83OLDzxbABQzvFg/FRkK3ggzkqopm84vDthU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fONNRYVLoBHupJpRvMVR12ts/lRnoaoKc5efbqAbt/ZFP1rAWG19dM0lpb3bqJYvIaNm5vlDjrXl/3+0FUvPdYgLCaxvi4v9lb/wTUYVRJHtxv6/35iZmV3MOY2uZoCvqPfnhnfAUvCXB8Y+TvvWvxvnsT147dnixZAs0SOICtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aoxqMI1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aoxqMI1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347D3C4CEDE;
	Tue,  7 Jan 2025 06:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736232405;
	bh=lnP6axu83OLDzxbABQzvFg/FRkK3ggzkqopm84vDthU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aoxqMI1iKBOqEX0ZMxixWTcnARLX2kL9MlHsvQMAwTKr959qqw+VbWBDH/dN0iEEQ
	 ugYxntetfyBsnpyOzUbPAmM1s0eYk4jeR2nJ61KdH2zFJtQjzsnKkG4Q0M2pUrs+G2
	 PE1qgqgydS200NMPOhhdq59+lmrQ4dnWFs1n1GwOz7zoZ3KctARAgE46JQbS4odx3g
	 bpuasXdJxWxxcRsvw4R3NLbs9eqU+sBletDgoGBIcEXatGiPdDoZqewq0J3C2dCBYf
	 3kpY0kPzt+CeGHxl5cnDu8/rgE15km+0j41sGDZWhVDgu4ZlNBhfQpAtG61s5tgV3g
	 0or3lTHxbbIhw==
Date: Mon, 6 Jan 2025 22:46:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/15] xfs: always complete the buffer inline in
 xfs_buf_submit
Message-ID: <20250107064644.GC6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-13-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:49AM +0100, Christoph Hellwig wrote:
> xfs_buf_submit now only completes a buffer on error, or for in-memory
> buftargs.  There is no point in using a workqueue for the latter as
> the completion will just wake up the caller.  Optimize this case by
> avoiding the workqueue roundtrip.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This all seems simpler now...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 352cc50aeea5..0ad3cacfdba1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1670,10 +1670,7 @@ xfs_buf_submit(
>  	xfs_buf_submit_bio(bp);
>  	return 0;
>  done:
> -	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
> -		xfs_buf_ioend(bp);
> -	else
> -		xfs_buf_ioend_async(bp);
> +	xfs_buf_ioend(bp);
>  	return 0;
>  }
>  
> -- 
> 2.45.2
> 
> 
