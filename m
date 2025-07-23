Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6DA1D6DA9
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 16:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753287648; cv=none; b=lzxxUNCgK8xrXVqUFRel6hGatUL0yy4QC7Bt2igvhy6n+XLeYlceaCe46xcvcq6olcfXMp9ogMsA29NZ1qArMINQYaIBj0aQ8O5r9WcJJoHpFqtUQ6qEoWgIvfmJC/jBwh+UwZqbrf361Sd4RMDEphRT8FtuZtT01tAXTllver8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753287648; c=relaxed/simple;
	bh=ai5W8AmwhlSnd++GaLtGzQ0Spb8x4ePuXTZ+d3nvbzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LnxzC2aV2/yq8a0vflxxtPiA6bHEFqTtgv29Dc7NfMIbv8pETpC/LJqCoyS7/BmPVpiRkFHH0TzTGuHAJAR0CGL6mX1+Sp+vb2G8+dx+1NIiKHtmoYc/IJOXYeJglZG+7y/ro+t/VaUqWsMmTYtz5+iO1QyhUJYSIvWZlCzf+Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZchNuW+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZchNuW+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90439C4CEE7;
	Wed, 23 Jul 2025 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753287647;
	bh=ai5W8AmwhlSnd++GaLtGzQ0Spb8x4ePuXTZ+d3nvbzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZchNuW+ujNvHwxwyR+YFAfxqoYBH68QXBv7FnnAvIW2UxtEumOrkrdRzeg9HjUfhg
	 UbXy+iu0m0PNz2cN66nN6cQ1Pe20z1lvcK5sYZRzFfic9q80WY4GfOIYfXULwA78wP
	 f0wNZbimuTBXgdg44qEd13q8Kbzqe1kiqRc0H5/WvwYbyNCxN0R1E0Uz6mwgLOvE0f
	 pu0xLNrHazIbo3F6sSylcTsL57zPgEi280DQCMNxJNcAMqyCXBCyon0SJOMkXhmohQ
	 J0+UvkvNeXFY4ZOpZ5f+qeVW77FnluyBOO2MaK5STzNVx3xKFSpMB/wrfCB727Be7H
	 YS1/GmFTQ63oA==
Date: Wed, 23 Jul 2025 09:20:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, cen zhang <zzzccc427@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fully decouple XFS_IBULK* flags from XFS_IWALK*
 flags
Message-ID: <20250723162047.GX2672049@frogsfrogsfrogs>
References: <20250723122011.3178474-1-hch@lst.de>
 <20250723122011.3178474-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723122011.3178474-2-hch@lst.de>

On Wed, Jul 23, 2025 at 02:19:44PM +0200, Christoph Hellwig wrote:
> Fix up xfs_inumbers to now pass in the XFS_IBULK* flags into the flags
> argument to xfs_inobt_walk, which expects the XFS_IWALK* flags.
> 
> Currently passing the wrong flags works for non-debug builds because
> the only XFS_IWALK* flag has the same encoding as the corresponding
> XFS_IBULK* flag, but in debug builds it can trigger an assert that no
> incorrect flag is passed.  Instead just extra the relevant flag.
> 
> Fixes: 5b35d922c52798 ("xfs: Decouple XFS_IBULK flags from XFS_IWALK flags")
> Reported-by: cen zhang <zzzccc427@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'd prefer this come with the
Cc: <stable@vger.kernel.org> # v5.19
so that I don't have to manually backport this to 6.12

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_itable.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index c8c9b8d8309f..5116842420b2 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -447,17 +447,21 @@ xfs_inumbers(
>  		.breq		= breq,
>  	};
>  	struct xfs_trans	*tp;
> +	unsigned int		iwalk_flags = 0;
>  	int			error = 0;
>  
>  	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
>  		return 0;
>  
> +	if (breq->flags & XFS_IBULK_SAME_AG)
> +		iwalk_flags |= XFS_IWALK_SAME_AG;
> +
>  	/*
>  	 * Grab an empty transaction so that we can use its recursive buffer
>  	 * locking abilities to detect cycles in the inobt without deadlocking.
>  	 */
>  	tp = xfs_trans_alloc_empty(breq->mp);
> -	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->flags,
> +	error = xfs_inobt_walk(breq->mp, tp, breq->startino, iwalk_flags,
>  			xfs_inumbers_walk, breq->icount, &ic);
>  	xfs_trans_cancel(tp);
>  
> -- 
> 2.47.2
> 
> 
