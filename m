Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3351C1AB1
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 15:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255524; cv=none; b=Nnr50MIgSW60on+U2eK30+Mcqy1BiRC3NHruLqYEPKY2mv9KruzOTTD9HGnTYfby/bSUWEtj3mJXkg0uNVB1M7pZX7I2JoUEHChQucf9y1FdY3W4tw6vL2YTk6GjjHACmVRiyK0hC5e48Xb7cEjwev1eKK5li2VYt4jjoF37F5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255524; c=relaxed/simple;
	bh=hHvYwxiEXR4exLEWTtI7nnzNUoEqtOh5wDlpvItV7vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKGTz9P2LeFk/e+5Db//wMFe+wUvEB37VNQNmk7oOq9dvl0zPb6Y+9/8V92CeMxyocfzKNIry96jVYwSdp36Ug2IdGoCIAHLhTqkqV/24sbFCKX3lV4uf5t3SY0TdUYBqv0rXP7joN2hPNyimQBt95LEwUm1WyZq+DK8+A3qRvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=twaZp7UN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="twaZp7UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44634C32781;
	Wed, 21 Aug 2024 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724255524;
	bh=hHvYwxiEXR4exLEWTtI7nnzNUoEqtOh5wDlpvItV7vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=twaZp7UNKA7qvt81TonA49pWvHudnZXCEx1SJpIVQfjDCFfhEPysjC2QxHToXwD0p
	 L5McMg5HKCTOEt2c+QzJC8LQ9LUY46oDZQlbO7VFuyxeN+JGyHn0XClNt88mJsOX7c
	 Y65GmdJ1i3YC1X8BwkK9+P9jP6x0PvwqQDIuvP/MYM89zE3X5krgFa5/RFRxVUKV30
	 W7CCsLzpNUcjVG3n1PAFWDSeY2bgLBZ+9bNeExlAsbM2/5TRXggOaMNtfCiaBwEbaV
	 //LJPPtYt2fa+J9kEdkP14MXWxQKCmDoEN8Anw/1l9K36SYhZVILwVGh2yuTaHjMgJ
	 ouIKPzN2Fwjeg==
Date: Wed, 21 Aug 2024 08:52:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: merge xfs_attr_leaf_try_add into
 xfs_attr_leaf_addname
Message-ID: <20240821155203.GV865349@frogsfrogsfrogs>
References: <20240820170517.528181-1-hch@lst.de>
 <20240820170517.528181-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820170517.528181-2-hch@lst.de>

On Tue, Aug 20, 2024 at 07:04:52PM +0200, Christoph Hellwig wrote:
> xfs_attr_leaf_try_add is only called by xfs_attr_leaf_addname, and
> merging the two will simplify a following error handling fix.
> 
> To facilitate this move the remote block state save/restore helpers up in
> the file so that they don't need forward declarations now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 176 ++++++++++++++++-----------------------
>  1 file changed, 74 insertions(+), 102 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f30bcc64100d56..b9df7a6b1f9d61 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -51,7 +51,6 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> -STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args);
>  
>  /*
>   * Internal routines when attribute list is more than one block.
> @@ -437,6 +436,33 @@ xfs_attr_hashval(
>  	return xfs_attr_hashname(name, namelen);
>  }
>  
> +/* Save the current remote block info and clear the current pointers. */
> +static void
> +xfs_attr_save_rmt_blk(
> +	struct xfs_da_args	*args)
> +{
> +	args->blkno2 = args->blkno;
> +	args->index2 = args->index;
> +	args->rmtblkno2 = args->rmtblkno;
> +	args->rmtblkcnt2 = args->rmtblkcnt;
> +	args->rmtvaluelen2 = args->rmtvaluelen;
> +	args->rmtblkno = 0;
> +	args->rmtblkcnt = 0;
> +	args->rmtvaluelen = 0;
> +}
> +
> +/* Set stored info about a remote block */
> +static void
> +xfs_attr_restore_rmt_blk(
> +	struct xfs_da_args	*args)
> +{
> +	args->blkno = args->blkno2;
> +	args->index = args->index2;
> +	args->rmtblkno = args->rmtblkno2;
> +	args->rmtblkcnt = args->rmtblkcnt2;
> +	args->rmtvaluelen = args->rmtvaluelen2;
> +}
> +
>  /*
>   * PPTR_REPLACE operations require the caller to set the old and new names and
>   * values explicitly.  Update the canonical fields to the new name and value
> @@ -482,49 +508,77 @@ xfs_attr_complete_op(
>  	return replace_state;
>  }
>  
> +/*
> + * Try to add an attribute to an inode in leaf form.
> + */
>  static int
>  xfs_attr_leaf_addname(
>  	struct xfs_attr_intent	*attr)
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
> +	struct xfs_buf		*bp;
>  	int			error;
>  
>  	ASSERT(xfs_attr_is_leaf(args->dp));
>  
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
> +	if (error)
> +		return error;
> +
>  	/*
> -	 * Use the leaf buffer we may already hold locked as a result of
> -	 * a sf-to-leaf conversion.
> +	 * Look up the xattr name to set the insertion point for the new xattr.
>  	 */
> -	error = xfs_attr_leaf_try_add(args);
> -
> -	if (error == -ENOSPC) {
> -		error = xfs_attr3_leaf_to_node(args);
> -		if (error)
> -			return error;
> +	error = xfs_attr3_leaf_lookup_int(bp, args);
> +	switch (error) {
> +	case -ENOATTR:
> +		if (args->op_flags & XFS_DA_OP_REPLACE)
> +			goto out_brelse;
> +		break;
> +	case -EEXIST:
> +		if (!(args->op_flags & XFS_DA_OP_REPLACE))
> +			goto out_brelse;
>  
> +		trace_xfs_attr_leaf_replace(args);
>  		/*
> -		 * We're not in leaf format anymore, so roll the transaction and
> -		 * retry the add to the newly allocated node block.
> +		 * Save the existing remote attr state so that the current
> +		 * values reflect the state of the new attribute we are about to
> +		 * add, not the attribute we just found and will remove later.
>  		 */
> -		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
> -		goto out;
> +		xfs_attr_save_rmt_blk(args);
> +		break;
> +	case 0:
> +		break;
> +	default:
> +		goto out_brelse;
>  	}
> -	if (error)
> -		return error;
>  
>  	/*
>  	 * We need to commit and roll if we need to allocate remote xattr blocks
>  	 * or perform more xattr manipulations. Otherwise there is nothing more
>  	 * to do and we can return success.
>  	 */
> -	if (args->rmtblkno)
> +	error = xfs_attr3_leaf_add(bp, args);
> +	if (error) {
> +		if (error != -ENOSPC)
> +			return error;
> +		error = xfs_attr3_leaf_to_node(args);
> +		if (error)
> +			return error;
> +
> +		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
> +	} else if (args->rmtblkno) {
>  		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
> -	else
> -		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> -							XFS_DAS_LEAF_REPLACE);
> -out:
> +	} else {
> +		attr->xattri_dela_state =
> +			xfs_attr_complete_op(attr, XFS_DAS_LEAF_REPLACE);
> +	}
> +
>  	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
>  	return error;
> +
> +out_brelse:
> +	xfs_trans_brelse(args->trans, bp);
> +	return error;
>  }
>  
>  /*
> @@ -1170,88 +1224,6 @@ xfs_attr_shortform_addname(
>   * External routines when attribute list is one block
>   *========================================================================*/
>  
> -/* Save the current remote block info and clear the current pointers. */
> -static void
> -xfs_attr_save_rmt_blk(
> -	struct xfs_da_args	*args)
> -{
> -	args->blkno2 = args->blkno;
> -	args->index2 = args->index;
> -	args->rmtblkno2 = args->rmtblkno;
> -	args->rmtblkcnt2 = args->rmtblkcnt;
> -	args->rmtvaluelen2 = args->rmtvaluelen;
> -	args->rmtblkno = 0;
> -	args->rmtblkcnt = 0;
> -	args->rmtvaluelen = 0;
> -}
> -
> -/* Set stored info about a remote block */
> -static void
> -xfs_attr_restore_rmt_blk(
> -	struct xfs_da_args	*args)
> -{
> -	args->blkno = args->blkno2;
> -	args->index = args->index2;
> -	args->rmtblkno = args->rmtblkno2;
> -	args->rmtblkcnt = args->rmtblkcnt2;
> -	args->rmtvaluelen = args->rmtvaluelen2;
> -}
> -
> -/*
> - * Tries to add an attribute to an inode in leaf form
> - *
> - * This function is meant to execute as part of a delayed operation and leaves
> - * the transaction handling to the caller.  On success the attribute is added
> - * and the inode and transaction are left dirty.  If there is not enough space,
> - * the attr data is converted to node format and -ENOSPC is returned. Caller is
> - * responsible for handling the dirty inode and transaction or adding the attr
> - * in node format.
> - */
> -STATIC int
> -xfs_attr_leaf_try_add(
> -	struct xfs_da_args	*args)
> -{
> -	struct xfs_buf		*bp;
> -	int			error;
> -
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner, 0, &bp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Look up the xattr name to set the insertion point for the new xattr.
> -	 */
> -	error = xfs_attr3_leaf_lookup_int(bp, args);
> -	switch (error) {
> -	case -ENOATTR:
> -		if (args->op_flags & XFS_DA_OP_REPLACE)
> -			goto out_brelse;
> -		break;
> -	case -EEXIST:
> -		if (!(args->op_flags & XFS_DA_OP_REPLACE))
> -			goto out_brelse;
> -
> -		trace_xfs_attr_leaf_replace(args);
> -		/*
> -		 * Save the existing remote attr state so that the current
> -		 * values reflect the state of the new attribute we are about to
> -		 * add, not the attribute we just found and will remove later.
> -		 */
> -		xfs_attr_save_rmt_blk(args);
> -		break;
> -	case 0:
> -		break;
> -	default:
> -		goto out_brelse;
> -	}
> -
> -	return xfs_attr3_leaf_add(bp, args);
> -
> -out_brelse:
> -	xfs_trans_brelse(args->trans, bp);
> -	return error;
> -}
> -
>  /*
>   * Return EEXIST if attr is found, or ENOATTR if not
>   */
> -- 
> 2.43.0
> 
> 
