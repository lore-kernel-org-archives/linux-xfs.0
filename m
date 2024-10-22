Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C86F19E833
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729620336; cv=none; b=uSmyvOXuI4wIcF+aq0/yJzFVsT+6r0Vy6FC6DHwbF1La0HAw5teeBjbmSSoUy/3Jv2oYnn78nK+tmtxEwozAE3eIZN1QzDbowdtOvsk7aXFozYs2URzx0o9cH1jwRCG3zErShCzuMBisY1prKAU1Wp3vDIFLdZCfcpEy+cX/wWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729620336; c=relaxed/simple;
	bh=a1Jttxsm7Uh8GzGp6onl5TJ/jXwud0DsEaylUfk2B0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UoTthxom89pR+UFthIfyeDYBkE9SPWD9MFpXxAKBrg2WV+iiYeE3vxLPw8EulKlZ2YrCjj5LEHh2D6TieE2dgm+x1SSugLiPTFiAruwXKFB8HC/u3wU2G8eA9hHJYCa3hDq96VXavkudNITqfiS8aYUI2zq6A+yrIEZ+XzFvTIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RU1htEeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RU1htEeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F40C4CEC3;
	Tue, 22 Oct 2024 18:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729620336;
	bh=a1Jttxsm7Uh8GzGp6onl5TJ/jXwud0DsEaylUfk2B0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RU1htEeGwbRubZHvWq3WZPCEwvglXxA2j5qUfLaZGUwPQyEbLMjbG+OOEP2vATvom
	 PkPqqeVVIVt8n4bzK1NVo25Pr813b+CtGyw0s/3f2o3nF95VwWgr4Jc4PkOJlquPf7
	 B8tpQGXhxhWnCnTY4G5iz+xW74yyYJkH2p5xwpxAAqEBBGkqFukfcPL2pf5Azt02sQ
	 OkhtKHKpGf2an5QNmI3mLr7SwtPZbjuEBp1Toj4HDKLCFpboDOCVgDzPJcNtADXY71
	 HnoFI1WexnKvGex89we3f/TpgCCgcf/tol0G3voE3Tb9aR49Lx0a3y2gNq/1duxVTK
	 0/kGiBn6gxgVw==
Date: Tue, 22 Oct 2024 11:05:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: streamline xfs_filestream_pick_ag
Message-ID: <20241022180535.GF21853@frogsfrogsfrogs>
References: <20241022121355.261836-1-hch@lst.de>
 <20241022121355.261836-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022121355.261836-2-hch@lst.de>

On Tue, Oct 22, 2024 at 02:13:37PM +0200, Christoph Hellwig wrote:
> Directly return the error from xfs_bmap_longest_free_extent instead
> of breaking from the loop and handling it there, and use a done
> label to directly jump to the exist when we found a suitable perag
> structure to reduce the indentation level and pag/max_pag check
> complexity in the tail of the function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

So the key change here is that now the function can exit directly from
the for_each_perag_wrap loop if it finds a suitable perag, and that the
rest of the function has less indentation?

Ok, sounds good to me though the bugfix probably should've come first.

Don't really care either way, so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_filestream.c | 95 ++++++++++++++++++++---------------------
>  1 file changed, 46 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index e3aaa055559781..f523027cc32586 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -67,22 +67,28 @@ xfs_filestream_pick_ag(
>  	xfs_extlen_t		free = 0, minfree, maxfree = 0;
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
> @@ -108,7 +114,9 @@ xfs_filestream_pick_ag(
>  			     (flags & XFS_PICK_LOWSPACE))) {
>  				/* Break out, retaining the reference on the AG. */
>  				free = pag->pagf_freeblks;
> -				break;
> +				if (max_pag)
> +					xfs_perag_rele(max_pag);
> +				goto done;
>  			}
>  		}
>  
> @@ -116,53 +124,42 @@ xfs_filestream_pick_ag(
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
> +	/*
> +	 * We must be low on data space, so run a final lowspace optimised
> +	 * selection pass if we haven't already.
> +	 */
> +	if (!(flags & XFS_PICK_LOWSPACE)) {
> +		flags |= XFS_PICK_LOWSPACE;
> +		goto restart;
> +	}
>  
> -		/*
> -		 * No unassociated AGs are available, so select the AG with the
> -		 * most free space, regardless of whether it's already in use by
> -		 * another filestream. It none suit, just use whatever AG we can
> -		 * grab.
> -		 */
> -		if (!max_pag) {
> -			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
> -				break;
> -			atomic_inc(&args->pag->pagf_fstrms);
> -			*longest = 0;
> -		} else {
> -			pag = max_pag;
> -			free = maxfree;
> -			atomic_inc(&pag->pagf_fstrms);
> -		}
> -	} else if (max_pag) {
> -		xfs_perag_rele(max_pag);
> +	/*
> +	 * No unassociated AGs are available, so select the AG with the most
> +	 * free space, regardless of whether it's already in use by another
> +	 * filestream. It none suit, just use whatever AG we can grab.
> +	 */
> +	if (!max_pag) {
> +		for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
> +			break;
> +		atomic_inc(&args->pag->pagf_fstrms);
> +		*longest = 0;
> +	} else {
> +		pag = max_pag;
> +		free = maxfree;
> +		atomic_inc(&pag->pagf_fstrms);
>  	}
>  
> +done:
>  	trace_xfs_filestream_pick(pag, pino, free);
>  	args->pag = pag;
>  	return 0;
> -- 
> 2.45.2
> 
> 
