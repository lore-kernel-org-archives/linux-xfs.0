Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED0514277
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 17:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710869654; cv=none; b=QJtzs6/kqDubrey7Y6YoE+ohsuqjlRid06YgHlmDSrM/FMuG12rjypsnrzOILW2bIrFQ5qThs7v7Hl1iCiRCUbDR5X0qaNb8svMtyOua1ggTd/y9ECRlZslAUjlyKw4qGaMEuFQNaH3IsPZOvrdB9QK1RTxfTTWX/nfnGH65iYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710869654; c=relaxed/simple;
	bh=Pt9YeXdWt8UZXYu5ukDOrjKiO5Q33RxN7dqc6ZC9EsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UF6tZsqR/CbVwc8wjvEnapHJllNmPMQrafVqpe/DH+WbVxWQOHotUl3zju2Wd3WaPXjKe1txu1MLee975B8LrZbmXmatpv7ilKBLeustcFeqswD8JZ8INm7EZCCf/A/UeQhxxU7n4t/FHl8WdmBm0ihcy/EpN1UhA951V8VYHPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gffF7u83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gffF7u83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F5DC433F1;
	Tue, 19 Mar 2024 17:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710869653;
	bh=Pt9YeXdWt8UZXYu5ukDOrjKiO5Q33RxN7dqc6ZC9EsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gffF7u83R1lJkD+5S7YuiRt/qmg/FDFPdpVLu8Bh0W5RuOIoCoDdQ8zYV8hqStFfl
	 ZEFATDujl6V/JE5JEKnGMrPObvU4TVMhbXdxeIjmSH3UZ1u1JjfQ2nkea7Og+nCoyy
	 7PdkwDYO+wUiHdJ2xpNkdnpaH29sCUeMJp9oiWPxYf4D6zvnOXvZhk5EsIWhA7CGHJ
	 OKD6GjWcp6Ht5dL7MhU5fY+X0AzUVV/9abWpKBb8RuURZ874NBAXUadz9xYexn6d7w
	 EwVEEp/5HUQiH3ulxSXnC1jnca5dnk5wTOFhENQEYYy6foPRF5+1quGcxZ640wRKFo
	 /KbQb2helnJ/g==
Date: Tue, 19 Mar 2024 10:34:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: map buffers in xfs_buf_alloc_folios
Message-ID: <20240319173413.GS1927156@frogsfrogsfrogs>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-7-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318224715.3367463-7-david@fromorbit.com>

On Tue, Mar 19, 2024 at 09:45:57AM +1100, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> With the concept of unmapped buffer gone, there is no reason to not
> vmap the buffer pages directly in xfs_buf_alloc_folios.

"..no reason to not map the buffer pages..."?

I say that mostly because the first dumb thought I had was "wait, we're
going to vm_map_ram everything now??" which of course is not true.

> [dchinner: port to folio-enabled buffers.]
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

With that changed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 37 ++++++-------------------------------
>  1 file changed, 6 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 2cd3671f3ce3..a77e2d8c8107 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -469,18 +469,7 @@ xfs_buf_alloc_folios(
>  		XFS_STATS_INC(bp->b_mount, xb_page_retries);
>  		memalloc_retry_wait(gfp_mask);
>  	}
> -	return 0;
> -}
>  
> -/*
> - *	Map buffer into kernel address-space if necessary.
> - */
> -STATIC int
> -_xfs_buf_map_folios(
> -	struct xfs_buf		*bp,
> -	xfs_buf_flags_t		flags)
> -{
> -	ASSERT(bp->b_flags & _XBF_FOLIOS);
>  	if (bp->b_folio_count == 1) {
>  		/* A single folio buffer is always mappable */
>  		bp->b_addr = folio_address(bp->b_folios[0]);
> @@ -513,8 +502,13 @@ _xfs_buf_map_folios(
>  		} while (retried++ <= 1);
>  		memalloc_nofs_restore(nofs_flag);
>  
> -		if (!bp->b_addr)
> +		if (!bp->b_addr) {
> +			xfs_warn_ratelimited(bp->b_mount,
> +				"%s: failed to map %u folios", __func__,
> +				bp->b_folio_count);
> +			xfs_buf_free_folios(bp);
>  			return -ENOMEM;
> +		}
>  	}
>  
>  	return 0;
> @@ -816,18 +810,6 @@ xfs_buf_get_map(
>  			xfs_perag_put(pag);
>  	}
>  
> -	/* We do not hold a perag reference anymore. */
> -	if (!bp->b_addr) {
> -		error = _xfs_buf_map_folios(bp, flags);
> -		if (unlikely(error)) {
> -			xfs_warn_ratelimited(btp->bt_mount,
> -				"%s: failed to map %u folios", __func__,
> -				bp->b_folio_count);
> -			xfs_buf_relse(bp);
> -			return error;
> -		}
> -	}
> -
>  	/*
>  	 * Clear b_error if this is a lookup from a caller that doesn't expect
>  	 * valid data to be found in the buffer.
> @@ -1068,13 +1050,6 @@ xfs_buf_get_uncached(
>  	if (error)
>  		goto fail_free_buf;
>  
> -	error = _xfs_buf_map_folios(bp, 0);
> -	if (unlikely(error)) {
> -		xfs_warn(target->bt_mount,
> -			"%s: failed to map folios", __func__);
> -		goto fail_free_buf;
> -	}
> -
>  	trace_xfs_buf_get_uncached(bp, _RET_IP_);
>  	*bpp = bp;
>  	return 0;
> -- 
> 2.43.0
> 
> 
