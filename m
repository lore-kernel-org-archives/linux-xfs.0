Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567651EC01B
	for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729792734; cv=none; b=TmSHBAUj+5n1Ry3cfpTMUpRuhv5qCce5JVnbN/spHmphYahJ40mhv5iGekqBe4CZMyD4HTD/HV17Y9po+QeQycPQAn4xFSWHippFl3tIosaxxZh6QABUjdAEihQy5VbcWt6PdaUyUJBBAuz9rlAOuuohrxLHQhCsXBeMoT/fXB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729792734; c=relaxed/simple;
	bh=4yzqTC/dVAQXsd2eSqeQsdEha5P6ueeeR5TU4SSFClY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQFS/73LHQSp0phtV8SCOzAQtWeVlSfmxTCx28e6Rss8Z1oy1UaWFEZnYiErUyXVjhB70i/YZW7tfkbiPKvTGN73PhYdcb283D1L+Jwjqpso4qaNrap2IKrzXns69NVTEqaEgRkxy+2laavSBnhztrCle/A1ICrvo3V/6JvRJiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocUUj9CI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocUUj9CI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4143C4CEC7;
	Thu, 24 Oct 2024 17:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729792733;
	bh=4yzqTC/dVAQXsd2eSqeQsdEha5P6ueeeR5TU4SSFClY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ocUUj9CIUlpBLBaC8+iKt9l0fIJm2rBCmZB2aKA3rlVSCJ1h5g+0mPj+eSfgsERvE
	 SNx/ld+b0brt322X9ChTCV3bw8NlVnVcVT2SN/Hi/3XG3Hx4aULVXbOv1CFPWCxgjR
	 leOEEZuphHYqYFyMa9ZxqDgmVMlnUeKQ6cU8JiTsBj/w+9w9FYEztFmabcsEKZ+/PQ
	 hDIB2W7hC7rcrv1QGk69/+/b2T48u5On/nDhxp45fcSWUrcewZ7gx10bb+iVy2hcmk
	 TqskWu2PzIk3aXXCkhXxtf2vByi/7nXJ4fN675E78JsNN7+RRKJOlAQXUE72ihCkQv
	 K8wGuGaonqGlQ==
Date: Thu, 24 Oct 2024 10:58:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: streamline xfs_filestream_pick_ag
Message-ID: <20241024175853.GB2386201@frogsfrogsfrogs>
References: <20241023133755.524345-1-hch@lst.de>
 <20241023133755.524345-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023133755.524345-3-hch@lst.de>

On Wed, Oct 23, 2024 at 03:37:23PM +0200, Christoph Hellwig wrote:
> Directly return the error from xfs_bmap_longest_free_extent instead
> of breaking from the loop and handling it there, and use a done
> label to directly jump to the exist when we found a suitable perag
> structure to reduce the indentation level and pag/max_pag check
> complexity in the tail of the function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_filestream.c | 96 ++++++++++++++++++++---------------------
>  1 file changed, 46 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 88bd23ce74cd..290ba8887d29 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -67,22 +67,28 @@ xfs_filestream_pick_ag(
>  	xfs_extlen_t		minfree, maxfree = 0;
>  	xfs_agnumber_t		agno;
>  	bool			first_pass = true;
> -	int			err;
>  
>  	/* 2% of an AG's blocks must be free for it to be chosen. */
>  	minfree = mp->m_sb.sb_agblocks / 50;
>  
>  restart:
>  	for_each_perag_wrap(mp, start_agno, agno, pag) {
> +		int		err;
> +
>  		trace_xfs_filestream_scan(pag, pino);
> +
>  		*longest = 0;
>  		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
>  		if (err) {
> -			if (err != -EAGAIN)
> -				break;
> -			/* Couldn't lock the AGF, skip this AG. */
> -			err = 0;
> -			continue;
> +			if (err == -EAGAIN) {
> +				/* Couldn't lock the AGF, skip this AG. */
> +				err = 0;
> +				continue;
> +			}
> +			xfs_perag_rele(pag);
> +			if (max_pag)
> +				xfs_perag_rele(max_pag);
> +			return err;
>  		}
>  
>  		/* Keep track of the AG with the most free blocks. */
> @@ -107,7 +113,9 @@ xfs_filestream_pick_ag(
>  			     !(flags & XFS_PICK_USERDATA) ||
>  			     (flags & XFS_PICK_LOWSPACE))) {
>  				/* Break out, retaining the reference on the AG. */
> -				break;
> +				if (max_pag)
> +					xfs_perag_rele(max_pag);
> +				goto done;
>  			}
>  		}
>  
> @@ -115,56 +123,44 @@ xfs_filestream_pick_ag(
>  		atomic_dec(&pag->pagf_fstrms);
>  	}
>  
> -	if (err) {
> -		xfs_perag_rele(pag);
> -		if (max_pag)
> -			xfs_perag_rele(max_pag);
> -		return err;
> +	/*
> +	 * Allow a second pass to give xfs_bmap_longest_free_extent() another
> +	 * attempt at locking AGFs that it might have skipped over before we
> +	 * fail.
> +	 */
> +	if (first_pass) {
> +		first_pass = false;
> +		goto restart;
>  	}
>  
> -	if (!pag) {
> -		/*
> -		 * Allow a second pass to give xfs_bmap_longest_free_extent()
> -		 * another attempt at locking AGFs that it might have skipped
> -		 * over before we fail.
> -		 */
> -		if (first_pass) {
> -			first_pass = false;
> -			goto restart;
> -		}
> -
> -		/*
> -		 * We must be low on data space, so run a final lowspace
> -		 * optimised selection pass if we haven't already.
> -		 */
> -		if (!(flags & XFS_PICK_LOWSPACE)) {
> -			flags |= XFS_PICK_LOWSPACE;
> -			goto restart;
> -		}
> -
> -		/*
> -		 * No unassociated AGs are available, so select the AG with the
> -		 * most free space, regardless of whether it's already in use by
> -		 * another filestream. It none suit, just use whatever AG we can
> -		 * grab.
> -		 */
> -		if (!max_pag) {
> -			for_each_perag_wrap(args->mp, 0, start_agno, pag) {
> -				max_pag = pag;
> -				break;
> -			}
> +	/*
> +	 * We must be low on data space, so run a final lowspace optimised
> +	 * selection pass if we haven't already.
> +	 */
> +	if (!(flags & XFS_PICK_LOWSPACE)) {
> +		flags |= XFS_PICK_LOWSPACE;
> +		goto restart;
> +	}
>  
> -			/* Bail if there are no AGs at all to select from. */
> -			if (!max_pag)
> -				return -ENOSPC;
> +	/*
> +	 * No unassociated AGs are available, so select the AG with the most
> +	 * free space, regardless of whether it's already in use by another
> +	 * filestream. It none suit, just use whatever AG we can grab.
> +	 */
> +	if (!max_pag) {
> +		for_each_perag_wrap(args->mp, 0, start_agno, pag) {
> +			max_pag = pag;
> +			break;
>  		}
>  
> -		pag = max_pag;
> -		atomic_inc(&pag->pagf_fstrms);
> -	} else if (max_pag) {
> -		xfs_perag_rele(max_pag);
> +		/* Bail if there are no AGs at all to select from. */
> +		if (!max_pag)
> +			return -ENOSPC;
>  	}
>  
> +	pag = max_pag;
> +	atomic_inc(&pag->pagf_fstrms);
> +done:
>  	trace_xfs_filestream_pick(pag, pino);
>  	args->pag = pag;
>  	return 0;
> -- 
> 2.45.2
> 
> 
