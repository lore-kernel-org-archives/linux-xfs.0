Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B33D249F9
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 18:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739990488; cv=none; b=tJc5TtcEr6mIHXJ+QVAl796Ks5q8G6IeNSL1FRkxfSXns8leyG4HgOtD2dAEDTIPo3rwJV6GrlIqY8tCkjqQl1+QUgO43NTjhF5xMGQFnCrKkgvZ1pSNVdS7dEoRT1n1GkHSXTU7quhUAkNm5Hm9tqJAgQC9p0RWUJBjDvA1kO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739990488; c=relaxed/simple;
	bh=TEbixI16FPasUmzVdVGqhxA+bLbbNR5MfDcoU82h+fE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iQHwIj9BuQGRRmYtzPwqWeLYTXRwCQ6qsk70fOKWLTTt3kn+HWlVCwtQntB5rUayB2zPHZPIcMjB0GhiymgFkbReto+W2OOANMQZ030Dro/nmBl9PUGedB9H3Kinu8z2HBzo/jqfuDIZ356q+WSWTOYfW7IAjRBaPYNaMWMrBHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HywpZ65/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HywpZ65/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7AFC4CED1;
	Wed, 19 Feb 2025 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739990487;
	bh=TEbixI16FPasUmzVdVGqhxA+bLbbNR5MfDcoU82h+fE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HywpZ65/sGDTTHt/t6owTNEatq7RP3kkSNSQxIPnwIOi8PEADoEhOnSIJlrzkDq8W
	 kyMHk216k95M1K7T0y0bGwKMcQCZdSdwVV28UFzWqiNEwk2Z2gb/D0IQxWCZ2k9X+V
	 SSukAccFX+mMIwRdXNgpp50anBwpJQhxWcvWptjWi3/psrQ/Chgu6PCflOcc8qHEFw
	 YIYK3wQBDRfFvx6WgSjiFHvrQu5i4cBHtLM4sYp8IXyH9xwbDDzr2+NEjoe0e3vXAa
	 qZEfT0V5dahyK3EidcsijfTU9lw/WJDBmgG0xwn5vUiggi9gE+FSYAGpR7KvefHpRB
	 KDfnhZtklxrlQ==
Date: Wed, 19 Feb 2025 10:41:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/45] xfs: fixup the metabtree reservation in
 xrep_reap_metadir_fsblocks
Message-ID: <20250219184126.GS21808@frogsfrogsfrogs>
References: <20250218081153.3889537-1-hch@lst.de>
 <20250218081153.3889537-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218081153.3889537-7-hch@lst.de>

On Tue, Feb 18, 2025 at 09:10:09AM +0100, Christoph Hellwig wrote:
> All callers of xrep_reap_metadir_fsblocks need to fix up the metabtree
> reservation, otherwise they'd leave the reservations in an incoherent
> state.  Move the call to xrep_reset_metafile_resv into
> xrep_reap_metadir_fsblocks so it always is taken care of, and remove
> now superfluous helper functions in the callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/reap.c              |  9 ++++++---
>  fs/xfs/scrub/rtrefcount_repair.c | 34 ++++++--------------------------
>  fs/xfs/scrub/rtrmap_repair.c     | 29 +++++----------------------
>  3 files changed, 17 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> index b32fb233cf84..8703897c0a9c 100644
> --- a/fs/xfs/scrub/reap.c
> +++ b/fs/xfs/scrub/reap.c
> @@ -935,10 +935,13 @@ xrep_reap_metadir_fsblocks(
>  	if (error)
>  		return error;
>  
> -	if (xreap_dirty(&rs))
> -		return xrep_defer_finish(sc);
> +	if (xreap_dirty(&rs)) {
> +		error = xrep_defer_finish(sc);
> +		if (error)
> +			return error;
> +	}
>  
> -	return 0;
> +	return xrep_reset_metafile_resv(sc);
>  }
>  
>  /*
> diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
> index 257cfb24beb4..983362447826 100644
> --- a/fs/xfs/scrub/rtrefcount_repair.c
> +++ b/fs/xfs/scrub/rtrefcount_repair.c
> @@ -697,32 +697,6 @@ xrep_rtrefc_build_new_tree(
>  	return error;
>  }
>  
> -/*
> - * Now that we've logged the roots of the new btrees, invalidate all of the
> - * old blocks and free them.
> - */
> -STATIC int
> -xrep_rtrefc_remove_old_tree(
> -	struct xrep_rtrefc	*rr)
> -{
> -	int			error;
> -
> -	/*
> -	 * Free all the extents that were allocated to the former rtrefcountbt
> -	 * and aren't cross-linked with something else.
> -	 */
> -	error = xrep_reap_metadir_fsblocks(rr->sc,
> -			&rr->old_rtrefcountbt_blocks);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Ensure the proper reservation for the rtrefcount inode so that we
> -	 * don't fail to expand the btree.
> -	 */
> -	return xrep_reset_metafile_resv(rr->sc);
> -}
> -
>  /* Rebuild the rt refcount btree. */
>  int
>  xrep_rtrefcountbt(
> @@ -769,8 +743,12 @@ xrep_rtrefcountbt(
>  	if (error)
>  		goto out_bitmap;
>  
> -	/* Kill the old tree. */
> -	error = xrep_rtrefc_remove_old_tree(rr);
> +	/*
> +	 * Free all the extents that were allocated to the former rtrefcountbt
> +	 * and aren't cross-linked with something else.
> +	 */
> +	error = xrep_reap_metadir_fsblocks(rr->sc,
> +			&rr->old_rtrefcountbt_blocks);
>  	if (error)
>  		goto out_bitmap;
>  
> diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
> index f2fdd7a9fc24..fc2592c53af5 100644
> --- a/fs/xfs/scrub/rtrmap_repair.c
> +++ b/fs/xfs/scrub/rtrmap_repair.c
> @@ -810,28 +810,6 @@ xrep_rtrmap_build_new_tree(
>  
>  /* Reaping the old btree. */
>  
> -/* Reap the old rtrmapbt blocks. */
> -STATIC int
> -xrep_rtrmap_remove_old_tree(
> -	struct xrep_rtrmap	*rr)
> -{
> -	int			error;
> -
> -	/*
> -	 * Free all the extents that were allocated to the former rtrmapbt and
> -	 * aren't cross-linked with something else.
> -	 */
> -	error = xrep_reap_metadir_fsblocks(rr->sc, &rr->old_rtrmapbt_blocks);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Ensure the proper reservation for the rtrmap inode so that we don't
> -	 * fail to expand the new btree.
> -	 */
> -	return xrep_reset_metafile_resv(rr->sc);
> -}
> -
>  static inline bool
>  xrep_rtrmapbt_want_live_update(
>  	struct xchk_iscan		*iscan,
> @@ -995,8 +973,11 @@ xrep_rtrmapbt(
>  	if (error)
>  		goto out_records;
>  
> -	/* Kill the old tree. */
> -	error = xrep_rtrmap_remove_old_tree(rr);
> +	/*
> +	 * Free all the extents that were allocated to the former rtrmapbt and
> +	 * aren't cross-linked with something else.
> +	 */
> +	error = xrep_reap_metadir_fsblocks(rr->sc, &rr->old_rtrmapbt_blocks);
>  	if (error)
>  		goto out_records;
>  
> -- 
> 2.45.2
> 
> 
