Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8C939FE6
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ej4tEiHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E282DC433C8;
	Thu, 14 Dec 2023 21:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702588580;
	bh=QUYGZXdhqS5RM9jd7k/CJvF3v2+DXUOuL6X+8O1k5L8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ej4tEiHGCURaNlPp4tLay7SLQSQpJ8DrwoDvJP8JXwHRmTekhgLb6b4diQCilZo1O
	 cF5fys+DjMb1pSlOZRINiVl9aN6ED3Gy3q5lkcQfA54JxkmZZq3oCAR7HemTpJ5php
	 3RtA3valy7Qu+hbrK9CcXgzYgucTYCHGsCeIex/T1WAocmkXhirdRTtq5T4Rsfv7hG
	 lzUkSiKiJeBmAiCJK76bTws2WEakrJjfV9inKUAeidF4qqxRwhtIeylfQGcbR/sN5o
	 L9E7F08FwtHahJ/WrUed/FJM0gsQ/dNonKN+7NC1wxbk2/LOJLRLutjCuPvdtB9MAU
	 1JEYDnhNdxnDA==
Date: Thu, 14 Dec 2023 13:16:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/19] xfs: tidy up xfs_rtallocate_extent_block
Message-ID: <20231214211620.GC361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-13-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:31AM +0100, Christoph Hellwig wrote:
> Share the xfs_rtallocate_range logic by breaking out of the loop
> instead of duplicating it, invert a check so that the early
> return case comes first instead of in an else, and handle the
> successful case in the straight line instead a branch in the tail
> of the function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_rtalloc.c | 63 +++++++++++++++++++++-----------------------
>  1 file changed, 30 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index fbc60658ef24bf..5f42422a976a3e 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -257,13 +257,9 @@ xfs_rtallocate_extent_block(
>  			/*
>  			 * i for maxlen is all free, allocate and return that.
>  			 */
> -			error = xfs_rtallocate_range(args, i, maxlen);
> -			if (error)
> -				return error;
> -
> -			*len = maxlen;
> -			*rtx = i;
> -			return 0;
> +			bestlen = maxlen;
> +			besti = i;
> +			break;

This return->break change gave me pause for a while...

>  		}
>  		/*
>  		 * In the case where we have a variable-sized allocation
> @@ -283,43 +279,44 @@ xfs_rtallocate_extent_block(
>  		/*
>  		 * If not done yet, find the start of the next free space.
>  		 */
> -		if (next < end) {
> -			error = xfs_rtfind_forw(args, next, end, &i);
> -			if (error)
> -				return error;
> -		} else
> +		if (next >= end)
>  			break;
> +		error = xfs_rtfind_forw(args, next, end, &i);
> +		if (error)
> +			return error;
>  	}
> +
>  	/*
>  	 * Searched the whole thing & didn't find a maxlen free extent.
>  	 */
> -	if (minlen <= maxlen && besti != -1) {
> -		xfs_rtxlen_t	p;	/* amount to trim length by */
> -
> +	if (maxlen < minlen || besti == -1) {

...because I was worried about accidentally ending up in this clause
if maxlen < minlen.  I /think/ it's the case that this function never
gets called with that true, right?

(Would this be a good place to add a ebugging assertion?)

--D

>  		/*
> -		 * If size should be a multiple of prod, make that so.
> +		 * Allocation failed.  Set *nextp to the next block to try.
>  		 */
> -		if (prod > 1) {
> -			div_u64_rem(bestlen, prod, &p);
> -			if (p)
> -				bestlen -= p;
> -		}
> +		*nextp = next;
> +		return -ENOSPC;
> +	}
>  
> -		/*
> -		 * Allocate besti for bestlen & return that.
> -		 */
> -		error = xfs_rtallocate_range(args, besti, bestlen);
> -		if (error)
> -			return error;
> -		*len = bestlen;
> -		*rtx = besti;
> -		return 0;
> +	/*
> +	 * If size should be a multiple of prod, make that so.
> +	 */
> +	if (prod > 1) {
> +		xfs_rtxlen_t	p;	/* amount to trim length by */
> +
> +		div_u64_rem(bestlen, prod, &p);
> +		if (p)
> +			bestlen -= p;
>  	}
> +
>  	/*
> -	 * Allocation failed.  Set *nextp to the next block to try.
> +	 * Allocate besti for bestlen & return that.
>  	 */
> -	*nextp = next;
> -	return -ENOSPC;
> +	error = xfs_rtallocate_range(args, besti, bestlen);
> +	if (error)
> +		return error;
> +	*len = bestlen;
> +	*rtx = besti;
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.39.2
> 
> 
