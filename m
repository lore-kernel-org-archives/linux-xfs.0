Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656ED560ACD
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 21:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791928793; cv=none; b=kbkRnSVpkxkZcAZvBCkVvu4ABfWTD/R+MKY3Px09yULeQ6Hgq/Z+WIYAWfSvGQH41s+wwmgtVuWQmcG2wMFeFEdl5PvAS46r833w5rvq6dBpI24vb0ICeKtkTKz1iW/DGlJD7/Jz37qbIiZotBABswj5a3Ba9T2G2pmBrT54WHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791928793; c=relaxed/simple;
	bh=KEQNruBm48VpqqauMkRZQdbfB9OmQRy3kZPMwDb6GHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WuBgvWUiTWUPyI2r2INslXAQVFNEHL9qnu8lZC+Ga0iJWnYFbAWAhRIUQFWYQ6vYtdDFzJEG+axG/isKZuhdo8j96yrfOBc01vZRsZVkT2Rmgnh5pEhINzK3t+hlemysYKr3y1WFWWAe+Mk+E5YTNiK7lW5f9q9SctFSpeNybNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CqzH89ts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CqzH89ts"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DEC001F000FF;
	Tue, 13 Oct 2026 21:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791928792;
	bh=s+UILuXd4ImizJjjte+C3piODQF3Lnzrqb0DkP8vnOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CqzH89tsvFDF/fj9ZMAKh3i4dWzi4Z6mIDjczjdo4Yqssc4TQjdulAYqXX2flWKpe
	 GSezua1Q6GZSz+ZiLNvk20eRIfXkXqCxjQQ55oQRgSMzZxNIMWfQvKZ5rrg3eOwPC7
	 Sb7aTgIkCu7T2ZDkb9vY8bEA3N0PafEmJ//1vZ6rBqE9jDqCnwWlvCCOES0CBeiZsu
	 YO8m/ZFv7tnYgjWLAloVLKCSMB5Xv1YyS6yt/OOI34h7oIydvdEN+1zX6EqK3pHrTs
	 Q+3t1XFYVrFHYr3j7YHqb3UUoICBaCENBw3IrR/jn82BODknl3H9sUv1EPeV9m7WmH
	 En/IM/ZyFgozA==
Date: Tue, 13 Oct 2026 14:59:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: add missing cursor stat checks after
 xfs_btree_delete
Message-ID: <20261013215951.GG2705364@frogsfrogsfrogs>
References: <20261013211851.641256-1-sandeen@redhat.com>
 <20261013211851.641256-3-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013211851.641256-3-sandeen@redhat.com>

On Tue, Oct 13, 2026 at 04:07:47PM -0500, Eric Sandeen wrote:
> Three xfs_btree_delete() calls in xfs_ialloc.c fail to check the status
> returns indicating whether a record was actually deleted. If the cursor
> was pointing to something that couldn't be deleted or didn't exist,
> something has gone wrong, so mark the fs as sick and return
> EFSCORRUPTED.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good too!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 17699f7c009f..bb6e684f5467 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1626,12 +1626,20 @@ xfs_dialloc_ag(
>  	 */
>  	rec.ir_free &= ~XFS_INOBT_MASK(offset);
>  	rec.ir_freecount--;
> -	if (rec.ir_freecount)
> +	if (rec.ir_freecount) {
>  		error = xfs_inobt_update(cur, &rec);
> -	else
> +		if (error)
> +			goto error_cur;
> +	} else {
>  		error = xfs_btree_delete(cur, &i);
> -	if (error)
> -		goto error_cur;
> +		if (error)
> +			goto error_cur;
> +		if (XFS_IS_CORRUPT(mp, i != 1)) {
> +			xfs_btree_mark_sick(cur);
> +			error = -EFSCORRUPTED;
> +			goto error_cur;
> +		}
> +	}
>  
>  	/*
>  	 * The finobt has now been updated appropriately. We haven't updated the
> @@ -2164,6 +2172,11 @@ xfs_difree_inobt(
>  				__func__, error);
>  			goto error0;
>  		}
> +		if (XFS_IS_CORRUPT(mp, i != 1)) {
> +			xfs_btree_mark_sick(cur);
> +			error = -EFSCORRUPTED;
> +			goto error0;
> +		}
>  
>  		error = xfs_difree_inode_chunk(tp, pag, &rec);
>  		if (error)
> @@ -2290,7 +2303,11 @@ xfs_difree_finobt(
>  		error = xfs_btree_delete(cur, &i);
>  		if (error)
>  			goto error;
> -		ASSERT(i == 1);
> +		if (XFS_IS_CORRUPT(mp, i != 1)) {
> +			xfs_btree_mark_sick(cur);
> +			error = -EFSCORRUPTED;
> +			goto error;
> +		}
>  	} else {
>  		error = xfs_inobt_update(cur, &rec);
>  		if (error)
> -- 
> 2.55.0
> 
> 
