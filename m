Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8872E147C6A
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711552497; cv=none; b=O511EZLoNwhoI9mAYNw9nmQr7LFMFYjnSrAGQtpLzbrThd0fWr+0TiAoYiwYrzde9JOxo/hlDZ8N3/z80YgksZVlOY4AVKAumRqtjLLXvh4hn2r+PZLrzWcbUky6gRlXpKEIMWEIjEcdm3m0wdhDVDMbnNYfZxrDbPQJw5RW0q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711552497; c=relaxed/simple;
	bh=WdmxwoEu1O942LyjnxM1RLfZQG1h6RZIwyz8mZU0uWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QwkB9a59qzo2QxBGpXx3roupKSHo3EPD+VmBsq7aSXg4s4NPyaHsr4qmixTunhGJzJQpK6w0aL6yDpOys1mYio6qREpa8Xai/Gj+9j+++SnfZv5hNTkdnOWDF8O2FAjqPx/X1muXDgzYkjuleOmcm9IXkOIqRDxL562KW6HDArE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxZE2Mbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxZE2Mbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E618C433C7;
	Wed, 27 Mar 2024 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711552497;
	bh=WdmxwoEu1O942LyjnxM1RLfZQG1h6RZIwyz8mZU0uWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UxZE2MbgzN68z7Fg704a62AIosoc9LS6gwNwDzDBhnx6ZJ/4UuS+cqJrcWdRhFW7z
	 Wjhq1kwe3hEJBUFrYPk3fVlFaZARZRpN1bN1Mzj1fZMHKf2erms2D0nczMVhlk7E81
	 W9FsuHEcsMLOY3u+GGvFKaxYwo8iOwfqFqluUXf4lQBFoMXH3VMKQ93cFf4gDKnABG
	 spBuG0SGMjQzEmG6XdiLi5BkLfBVRewuHinEkWUh1jf/FLKrQlucUFj2Clqmi+z102
	 kGfhoP2p+k9NfoFNq+6gS8IyXxJppygebKeN1asE0vqFScA3vBmki0afYsxTH3dO5s
	 aErtD4hI+C1Iw==
Date: Wed, 27 Mar 2024 08:14:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/13] xfs: rework splitting of indirect block
 reservations
Message-ID: <20240327151456.GZ6390@frogsfrogsfrogs>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327110318.2776850-12-hch@lst.de>

On Wed, Mar 27, 2024 at 12:03:16PM +0100, Christoph Hellwig wrote:
> Move the check if we have enough indirect blocks and the stealing of
> the deleted extent blocks out of xfs_bmap_split_indlen and into the
> caller to prepare for handling delayed allocation of RT extents that
> can't easily be stolen.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks correct now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 38 ++++++++++++++++----------------------
>  1 file changed, 16 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 131d4f063b660a..9d0b7caa9a036c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4829,31 +4829,17 @@ xfs_bmapi_remap(
>   * ores == 1). The number of stolen blocks is returned. The availability and
>   * subsequent accounting of stolen blocks is the responsibility of the caller.
>   */
> -static xfs_filblks_t
> +static void
>  xfs_bmap_split_indlen(
>  	xfs_filblks_t			ores,		/* original res. */
>  	xfs_filblks_t			*indlen1,	/* ext1 worst indlen */
> -	xfs_filblks_t			*indlen2,	/* ext2 worst indlen */
> -	xfs_filblks_t			avail)		/* stealable blocks */
> +	xfs_filblks_t			*indlen2)	/* ext2 worst indlen */
>  {
>  	xfs_filblks_t			len1 = *indlen1;
>  	xfs_filblks_t			len2 = *indlen2;
>  	xfs_filblks_t			nres = len1 + len2; /* new total res. */
> -	xfs_filblks_t			stolen = 0;
>  	xfs_filblks_t			resfactor;
>  
> -	/*
> -	 * Steal as many blocks as we can to try and satisfy the worst case
> -	 * indlen for both new extents.
> -	 */
> -	if (ores < nres && avail)
> -		stolen = XFS_FILBLKS_MIN(nres - ores, avail);
> -	ores += stolen;
> -
> -	 /* nothing else to do if we've satisfied the new reservation */
> -	if (ores >= nres)
> -		return stolen;
> -
>  	/*
>  	 * We can't meet the total required reservation for the two extents.
>  	 * Calculate the percent of the overall shortage between both extents
> @@ -4898,8 +4884,6 @@ xfs_bmap_split_indlen(
>  
>  	*indlen1 = len1;
>  	*indlen2 = len2;
> -
> -	return stolen;
>  }
>  
>  int
> @@ -4915,7 +4899,7 @@ xfs_bmap_del_extent_delay(
>  	struct xfs_bmbt_irec	new;
>  	int64_t			da_old, da_new, da_diff = 0;
>  	xfs_fileoff_t		del_endoff, got_endoff;
> -	xfs_filblks_t		got_indlen, new_indlen, stolen;
> +	xfs_filblks_t		got_indlen, new_indlen, stolen = 0;
>  	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
>  	uint64_t		fdblocks;
>  	int			error = 0;
> @@ -4994,8 +4978,19 @@ xfs_bmap_del_extent_delay(
>  		new_indlen = xfs_bmap_worst_indlen(ip, new.br_blockcount);
>  
>  		WARN_ON_ONCE(!got_indlen || !new_indlen);
> -		stolen = xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen,
> -						       del->br_blockcount);
> +		/*
> +		 * Steal as many blocks as we can to try and satisfy the worst
> +		 * case indlen for both new extents.
> +		 */
> +		da_new = got_indlen + new_indlen;
> +		if (da_new > da_old) {
> +			stolen = XFS_FILBLKS_MIN(da_new - da_old,
> +						 del->br_blockcount);
> +			da_old += stolen;
> +		}
> +		if (da_new > da_old)
> +			xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen);
> +		da_new = got_indlen + new_indlen;
>  
>  		got->br_startblock = nullstartblock((int)got_indlen);
>  
> @@ -5007,7 +5002,6 @@ xfs_bmap_del_extent_delay(
>  		xfs_iext_next(ifp, icur);
>  		xfs_iext_insert(ip, icur, &new, state);
>  
> -		da_new = got_indlen + new_indlen - stolen;
>  		del->br_blockcount -= stolen;
>  		break;
>  	}
> -- 
> 2.39.2
> 
> 
