Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57093BD629
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 16:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773074550; cv=none; b=V/XOmlq/gloasBCYBwYmACzkqcX/aOoRh4izTQKCUa2k8UuP6duegt1ogLcOhKcSxfmT9IFkV00QVMO5IXVz+f2DOR5ITzbkYVyx8FkDsYl7McP+4+pqis+eERU+CcCNyQDEnC1bvTl/HhpuCYmuQMtLC5xXpifvd4A3UQ1KEN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773074550; c=relaxed/simple;
	bh=hezl34anqmRnMxIdQnfHCiHsCwmzSXoGvItBKf6TrLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0FoR/v9k0cIl3B2Pz6ZgVUJ0mYZcXiUwj1pvHruRKrinPaDwLxMkeJwQnCI5VT2a6flWBdv9Y2W9yXJUcQPbfiEoItLvkTNn8xEwjqgqBNYAmrreqbY6Imc8Gn21KKWvS61mI5znAEWjnC6lp/UVwURYsggDhDvFA8C81zbKGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4lVlkM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4lVlkM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745C4C2BC86;
	Mon,  9 Mar 2026 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773074550;
	bh=hezl34anqmRnMxIdQnfHCiHsCwmzSXoGvItBKf6TrLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j4lVlkM9KHf8lUaeMHmq61o6n52C9bA2/gDV93bkXNkvk2xbQkXYtwLQU+du4dCZJ
	 /dtaDDHweM0c86ePdks6lrCVFYquzQtFjhLNMLnpGmS207i/gwo+8dagZEGFEW08Tc
	 Xv6Xl1py7WpRETNBjPf1hcfd9N43OocSkqvvDeGdmLYJ1LDsKGxzttoez786mCQc+D
	 lZ0pYGGYNPvnMefHk+m+pdRV/RsHa3S1t1NvZDm4PfUWDnEXG0T7UDJ3Td6Wm5er3c
	 W7ghox6zCwwFEY9gWChu79M2qexMmno0tBJo5CqyKf+kF5JKSHGRCZU2g98y0YyX1o
	 4/1YNDrKU8w6g==
Date: Mon, 9 Mar 2026 09:42:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 2/4] xfs: factor out xfs_da3_node_entry_remove
Message-ID: <20260309164229.GI6033@frogsfrogsfrogs>
References: <20260309082752.2039861-1-leo.lilong@huawei.com>
 <20260309082752.2039861-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309082752.2039861-3-leo.lilong@huawei.com>

On Mon, Mar 09, 2026 at 04:27:50PM +0800, Long Li wrote:
> Factor out wrapper xfs_da3_node_entry_remove function, which
> exported for external use.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 54 ++++++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_da_btree.h |  2 ++
>  2 files changed, 45 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 766631f0562e..466c43098768 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -1506,21 +1506,20 @@ xfs_da3_fixhashpath(
>  }
>  
>  /*
> - * Remove an entry from an intermediate node.
> + * Internal implementation to remove an entry from an intermediate node.
>   */
>  STATIC void
> -xfs_da3_node_remove(
> -	struct xfs_da_state	*state,
> -	struct xfs_da_state_blk	*drop_blk)
> +__xfs_da3_node_remove(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	struct xfs_da_geometry  *geo,
> +	struct xfs_da_state_blk *drop_blk)
>  {
>  	struct xfs_da_intnode	*node;
>  	struct xfs_da3_icnode_hdr nodehdr;
>  	struct xfs_da_node_entry *btree;
>  	int			index;
>  	int			tmp;
> -	struct xfs_inode	*dp = state->args->dp;
> -
> -	trace_xfs_da_node_remove(state->args);
>  
>  	node = drop_blk->bp->b_addr;
>  	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
> @@ -1536,17 +1535,17 @@ xfs_da3_node_remove(
>  		tmp  = nodehdr.count - index - 1;
>  		tmp *= (uint)sizeof(xfs_da_node_entry_t);
>  		memmove(&btree[index], &btree[index + 1], tmp);
> -		xfs_trans_log_buf(state->args->trans, drop_blk->bp,
> +		xfs_trans_log_buf(tp, drop_blk->bp,
>  		    XFS_DA_LOGRANGE(node, &btree[index], tmp));
>  		index = nodehdr.count - 1;
>  	}
>  	memset(&btree[index], 0, sizeof(xfs_da_node_entry_t));
> -	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
> +	xfs_trans_log_buf(tp, drop_blk->bp,
>  	    XFS_DA_LOGRANGE(node, &btree[index], sizeof(btree[index])));
>  	nodehdr.count -= 1;
>  	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
> -	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
> -	    XFS_DA_LOGRANGE(node, &node->hdr, state->args->geo->node_hdr_size));
> +	xfs_trans_log_buf(tp, drop_blk->bp,
> +	    XFS_DA_LOGRANGE(node, &node->hdr, geo->node_hdr_size));
>  
>  	/*
>  	 * Copy the last hash value from the block to propagate upwards.
> @@ -1554,6 +1553,39 @@ xfs_da3_node_remove(
>  	drop_blk->hashval = be32_to_cpu(btree[index - 1].hashval);
>  }
>  
> +/*
> + * Remove an entry from an intermediate node.
> + */
> +STATIC void
> +xfs_da3_node_remove(
> +	struct xfs_da_state	*state,
> +	struct xfs_da_state_blk	*drop_blk)
> +{
> +	trace_xfs_da_node_remove(state->args);

Style nit: blank line after the tracepoint.

> +	__xfs_da3_node_remove(state->args->trans, state->args->dp,
> +			state->args->geo, drop_blk);
> +}
> +
> +/*
> + * Remove an entry from a node at the specified index, this is an exported
> + * wrapper for removing entries from intermediate nodes.
> + */
> +void
> +xfs_da3_node_entry_remove(

This only applies to attr(ibute) structures, as evidenced by m_attr_geo
below.  I think this ought to be named xfs_attr3_node_entry_remove.

> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	struct xfs_buf		*bp,
> +	int			index)
> +{
> +	struct xfs_da_state_blk blk;

	struct xfs_da_state_blk blk = {
		.index		= index,
		.bp		= bp,
	};

Otherwise this looks ok to me.

--D

> +
> +	memset(&blk, 0, sizeof(blk));
> +	blk.index = index;
> +	blk.bp = bp;
> +
> +	__xfs_da3_node_remove(tp, dp, dp->i_mount->m_attr_geo, &blk);
> +}
> +
>  /*
>   * Unbalance the elements between two intermediate nodes,
>   * move all Btree elements from one node into another.
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 354d5d65043e..6cec4313c83c 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -184,6 +184,8 @@ int	xfs_da3_split(xfs_da_state_t *state);
>  int	xfs_da3_join(xfs_da_state_t *state);
>  void	xfs_da3_fixhashpath(struct xfs_da_state *state,
>  			    struct xfs_da_state_path *path_to_to_fix);
> +void	xfs_da3_node_entry_remove(struct xfs_trans *tp, struct xfs_inode *dp,
> +				struct xfs_buf *bp, int index);
>  
>  /*
>   * Routines used for finding things in the Btree.
> -- 
> 2.39.2
> 
> 
