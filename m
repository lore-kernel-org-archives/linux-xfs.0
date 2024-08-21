Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986DE14E2D7
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 15:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255778; cv=none; b=dSbrh2ZyOHel851jXO7EC5Rmm1889RL25Kc7DuC112cES+i9oA3JCFVigtYACQviOMDN3tr/+kcFiF6uCmggkUo77TGrJdQcBZzfiiuLtqxL9YjZV+Mro3NWqpNVfF3kqGpn/kI0NOG28Xu5IQyea5AhiYMHbgRPKkABOvoDx8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255778; c=relaxed/simple;
	bh=Hz7knz0AAEKjTE7vWPJ/5ygtlYJ8RP3/SKSCV49Rj7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f5JtA1a8h+8bL9Ia1+ATcMduyqP6HaYtigORVJl+P1W3CMjrxor3N+KK8HEau0AIr6aokMWVHvvr5HnMXYqaRYoxTwbIlPAupag+6W/b4yFJCZK/wdVXYqcZHxnDUmxysl+0iWkyGwAvi/cQp0RRZtPZIr1dhW0gEqjOinAgxNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YsCN2+0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YsCN2+0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F671C32781;
	Wed, 21 Aug 2024 15:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724255778;
	bh=Hz7knz0AAEKjTE7vWPJ/5ygtlYJ8RP3/SKSCV49Rj7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YsCN2+0WkPfHkFK4aES8ODj6H5diKf0mZtFW9SW20q5SO4MBi6ASaC0a7sfmMtU5y
	 kmyIJK/6xAk3EsGwo1OihHFyXDOh4AO91lmrO1tN8fN6UbmcUwWZMBp0ntypRHE2kp
	 +lJitGMOVYyOW/6RLoaHeuEqkOD8s1JndjdK3i6Cqv/zaNXvadxVNccU9G8PDJSSqu
	 SsJrkpvr6Zk3KNsNGDIAiWOOkatGaLv3HylEDk0iS+RNrOI2/AviLmGBnIULoEipyE
	 h7msJ8Efp/otCpEzaofRemGzrv3Hlfqh/8uA7qVGkY4NT14QkWwLJX2rFDrw9jXfkY
	 d6sn2H35f4/1g==
Date: Wed, 21 Aug 2024 08:56:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: return bool from xfs_attr3_leaf_add
Message-ID: <20240821155617.GW865349@frogsfrogsfrogs>
References: <20240820170517.528181-1-hch@lst.de>
 <20240820170517.528181-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820170517.528181-3-hch@lst.de>

On Tue, Aug 20, 2024 at 07:04:53PM +0200, Christoph Hellwig wrote:
> xfs_attr3_leaf_add only has two potential return values, indicating if the
> entry could be added or not.  Replace the errno return with a bool so that
> ENOSPC from it can't easily be confused with a real ENOSPC.
> 
> Remove the return value from the xfs_attr3_leaf_add_work helper entirely,
> as it always return 0.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 12 ++++--------
>  fs/xfs/libxfs/xfs_attr_leaf.c | 37 ++++++++++++++++++-----------------
>  fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
>  3 files changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b9df7a6b1f9d61..c3ddea016eac95 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -557,10 +557,7 @@ xfs_attr_leaf_addname(
>  	 * or perform more xattr manipulations. Otherwise there is nothing more
>  	 * to do and we can return success.
>  	 */
> -	error = xfs_attr3_leaf_add(bp, args);
> -	if (error) {
> -		if (error != -ENOSPC)
> -			return error;
> +	if (!xfs_attr3_leaf_add(bp, args)) {
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			return error;
> @@ -574,7 +571,7 @@ xfs_attr_leaf_addname(
>  	}
>  
>  	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
> -	return error;
> +	return 0;
>  
>  out_brelse:
>  	xfs_trans_brelse(args->trans, bp);
> @@ -1399,15 +1396,14 @@ xfs_attr_node_try_addname(
>  {
>  	struct xfs_da_state		*state = attr->xattri_da_state;
>  	struct xfs_da_state_blk		*blk;
> -	int				error;
> +	int				error = 0;
>  
>  	trace_xfs_attr_node_addname(state->args);
>  
>  	blk = &state->path.blk[state->path.active-1];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  
> -	error = xfs_attr3_leaf_add(blk->bp, state->args);
> -	if (error == -ENOSPC) {
> +	if (!xfs_attr3_leaf_add(blk->bp, state->args)) {
>  		if (state->path.active == 1) {
>  			/*
>  			 * Its really a single leaf node, but it had
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b9e98950eb3d81..bcaf28732bfcae 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -47,7 +47,7 @@
>   */
>  STATIC int xfs_attr3_leaf_create(struct xfs_da_args *args,
>  				 xfs_dablk_t which_block, struct xfs_buf **bpp);
> -STATIC int xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
> +STATIC void xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
>  				   struct xfs_attr3_icleaf_hdr *ichdr,
>  				   struct xfs_da_args *args, int freemap_index);
>  STATIC void xfs_attr3_leaf_compact(struct xfs_da_args *args,
> @@ -995,10 +995,8 @@ xfs_attr_shortform_to_leaf(
>  		xfs_attr_sethash(&nargs);
>  		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
>  		ASSERT(error == -ENOATTR);

Huh.  xfs_attr3_leaf_lookup_int can return -EFSCORRUPTED here, but we
just ignore it.  I guess we've never seen the debug assert go off so
it's not a real issue, but it does make my eyes twitch. :P

> -		error = xfs_attr3_leaf_add(bp, &nargs);
> -		ASSERT(error != -ENOSPC);
> -		if (error)
> -			goto out;
> +		if (!xfs_attr3_leaf_add(bp, &nargs))
> +			ASSERT(0);

Cleaner callsites, all right!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		sfe = xfs_attr_sf_nextentry(sfe);
>  	}
>  	error = 0;
> @@ -1343,8 +1341,9 @@ xfs_attr3_leaf_split(
>  	struct xfs_da_state_blk	*oldblk,
>  	struct xfs_da_state_blk	*newblk)
>  {
> -	xfs_dablk_t blkno;
> -	int error;
> +	bool			added;
> +	xfs_dablk_t		blkno;
> +	int			error;
>  
>  	trace_xfs_attr_leaf_split(state->args);
>  
> @@ -1379,10 +1378,10 @@ xfs_attr3_leaf_split(
>  	 */
>  	if (state->inleaf) {
>  		trace_xfs_attr_leaf_add_old(state->args);
> -		error = xfs_attr3_leaf_add(oldblk->bp, state->args);
> +		added = xfs_attr3_leaf_add(oldblk->bp, state->args);
>  	} else {
>  		trace_xfs_attr_leaf_add_new(state->args);
> -		error = xfs_attr3_leaf_add(newblk->bp, state->args);
> +		added = xfs_attr3_leaf_add(newblk->bp, state->args);
>  	}
>  
>  	/*
> @@ -1390,13 +1389,15 @@ xfs_attr3_leaf_split(
>  	 */
>  	oldblk->hashval = xfs_attr_leaf_lasthash(oldblk->bp, NULL);
>  	newblk->hashval = xfs_attr_leaf_lasthash(newblk->bp, NULL);
> -	return error;
> +	if (!added)
> +		return -ENOSPC;
> +	return 0;
>  }
>  
>  /*
>   * Add a name to the leaf attribute list structure.
>   */
> -int
> +bool
>  xfs_attr3_leaf_add(
>  	struct xfs_buf		*bp,
>  	struct xfs_da_args	*args)
> @@ -1405,6 +1406,7 @@ xfs_attr3_leaf_add(
>  	struct xfs_attr3_icleaf_hdr ichdr;
>  	int			tablesize;
>  	int			entsize;
> +	bool			added = true;
>  	int			sum;
>  	int			tmp;
>  	int			i;
> @@ -1433,7 +1435,7 @@ xfs_attr3_leaf_add(
>  		if (ichdr.freemap[i].base < ichdr.firstused)
>  			tmp += sizeof(xfs_attr_leaf_entry_t);
>  		if (ichdr.freemap[i].size >= tmp) {
> -			tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, i);
> +			xfs_attr3_leaf_add_work(bp, &ichdr, args, i);
>  			goto out_log_hdr;
>  		}
>  		sum += ichdr.freemap[i].size;
> @@ -1445,7 +1447,7 @@ xfs_attr3_leaf_add(
>  	 * no good and we should just give up.
>  	 */
>  	if (!ichdr.holes && sum < entsize)
> -		return -ENOSPC;
> +		return false;
>  
>  	/*
>  	 * Compact the entries to coalesce free space.
> @@ -1458,24 +1460,24 @@ xfs_attr3_leaf_add(
>  	 * free region, in freemap[0].  If it is not big enough, give up.
>  	 */
>  	if (ichdr.freemap[0].size < (entsize + sizeof(xfs_attr_leaf_entry_t))) {
> -		tmp = -ENOSPC;
> +		added = false;
>  		goto out_log_hdr;
>  	}
>  
> -	tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
> +	xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
>  
>  out_log_hdr:
>  	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf, &ichdr);
>  	xfs_trans_log_buf(args->trans, bp,
>  		XFS_DA_LOGRANGE(leaf, &leaf->hdr,
>  				xfs_attr3_leaf_hdr_size(leaf)));
> -	return tmp;
> +	return added;
>  }
>  
>  /*
>   * Add a name to a leaf attribute list structure.
>   */
> -STATIC int
> +STATIC void
>  xfs_attr3_leaf_add_work(
>  	struct xfs_buf		*bp,
>  	struct xfs_attr3_icleaf_hdr *ichdr,
> @@ -1593,7 +1595,6 @@ xfs_attr3_leaf_add_work(
>  		}
>  	}
>  	ichdr->usedbytes += xfs_attr_leaf_entsize(leaf, args->index);
> -	return 0;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index bac219589896ad..589f810eedc0d8 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -76,7 +76,7 @@ int	xfs_attr3_leaf_split(struct xfs_da_state *state,
>  int	xfs_attr3_leaf_lookup_int(struct xfs_buf *leaf,
>  					struct xfs_da_args *args);
>  int	xfs_attr3_leaf_getvalue(struct xfs_buf *bp, struct xfs_da_args *args);
> -int	xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
> +bool	xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
>  				 struct xfs_da_args *args);
>  int	xfs_attr3_leaf_remove(struct xfs_buf *leaf_buffer,
>  				    struct xfs_da_args *args);
> -- 
> 2.43.0
> 
> 
