Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A7882D8E
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 16:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708707173; cv=none; b=bdTY79ngZe9wO2B4o7An7MIdJgGh96++NKO0IXIkgKlBh9yK1nYxY2AHDWYlJTz9gUv+chWRBcDYpceFy0opNwtTZEmHOF7gL6S1cgUaKw9/ud9lYGYZbKUv4XAru4/xAsPjGcv5KIVd5eo0UgSEJP71ekMLikgIoRTNYmnjKV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708707173; c=relaxed/simple;
	bh=KHEhlu5lCX33P4rQC4cTtu/5yu/6+sjSGtGea/6LNE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5Q17NappKIbeyz5iMBriiyMR7YUPpIT3WCv+WkMAyss3Qr57eDHa95eb31NtvImzAG1hEvT7Eoyope+vzSef7qQi9kNCwfB+TVZvaVtgN10r6dNOAisiSGBbTiY3WhIK2TutxCNiaw8j/cDeM/SqHf2clKLsXuDPVJNv4Bjz7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZSM1PGUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZSM1PGUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF0AC433C7;
	Fri, 23 Feb 2024 16:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708707172;
	bh=KHEhlu5lCX33P4rQC4cTtu/5yu/6+sjSGtGea/6LNE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZSM1PGUBJ7i3Oa5DrghnpI5sMTI9ehvD0tirsDJoTi11QxxkaAK73vGTM33hufDsp
	 c2iKyIQOKJnNqtCeRjOb1h8hkCTAz5SeMpOFLbrr3lI2F/Uds2mltv4DcNeGnunVet
	 eidyFTJ5Wvj5h6YYNGFUo29rO8qjtRIrND557vZnrK9L88o+KVmeM8WAXuSSWBzNhd
	 Qo1VhgsZ2jLvlNBzAzfoYn9I7bxLcmetiezw/d0J5XyAbLr/mBMes75/PK7dR0YQNo
	 301TP7lGx6Xij5PCMfoyhX1cdEubr92tD+4TuJ8Lxr4fM5iwpXMXg27Nf1bishNCo4
	 ArqWsFHR7rNTw==
Date: Fri, 23 Feb 2024 08:52:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: block deltas in
 xfs_trans_unreserve_and_mod_sb must be positive
Message-ID: <20240223165252.GP616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223071506.3968029-4-hch@lst.de>

On Fri, Feb 23, 2024 at 08:14:59AM +0100, Christoph Hellwig wrote:
> And to make that more clear, rearrange the code a bit and add asserts
> and a comment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I /think/ I grok this... :)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans.c | 38 ++++++++++++++++++++++++--------------
>  1 file changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 12d45e93f07d50..befb508638ca1f 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -594,28 +594,38 @@ xfs_trans_unreserve_and_mod_sb(
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
> -	int64_t			blkdelta = 0;
> -	int64_t			rtxdelta = 0;
> +	int64_t			blkdelta = tp->t_blk_res;
> +	int64_t			rtxdelta = tp->t_rtx_res;
>  	int64_t			idelta = 0;
>  	int64_t			ifreedelta = 0;
>  	int			error;
>  
> -	/* calculate deltas */
> -	if (tp->t_blk_res > 0)
> -		blkdelta = tp->t_blk_res;
> -	if ((tp->t_fdblocks_delta != 0) &&
> -	    (xfs_has_lazysbcount(mp) ||
> -	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
> +	/*
> +	 * Calculate the deltas.
> +	 *
> +	 * t_fdblocks_delta and t_frextents_delta can be positive or negative:
> +	 *
> +	 *  - positive values indicate blocks freed in the transaction.
> +	 *  - negative values indicate blocks allocated in the transaction
> +	 *
> +	 * Negative values can only happen if the transaction has a block
> +	 * reservation that covers the allocated block.  The end result is
> +	 * that the calculated delta values must always be positive and we
> +	 * can only put back previous allocated or reserved blocks here.
> +	 */
> +	ASSERT(tp->t_blk_res || tp->t_fdblocks_delta >= 0);
> +	if (xfs_has_lazysbcount(mp) || (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
>  	        blkdelta += tp->t_fdblocks_delta;
> +		ASSERT(blkdelta >= 0);
> +	}
>  
> -	if (tp->t_rtx_res > 0)
> -		rtxdelta = tp->t_rtx_res;
> -	if ((tp->t_frextents_delta != 0) &&
> -	    (tp->t_flags & XFS_TRANS_SB_DIRTY))
> +	ASSERT(tp->t_rtx_res || tp->t_frextents_delta >= 0);
> +	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
>  		rtxdelta += tp->t_frextents_delta;
> +		ASSERT(rtxdelta >= 0);
> +	}
>  
> -	if (xfs_has_lazysbcount(mp) ||
> -	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
> +	if (xfs_has_lazysbcount(mp) || (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
>  		idelta = tp->t_icount_delta;
>  		ifreedelta = tp->t_ifree_delta;
>  	}
> -- 
> 2.39.2
> 
> 
