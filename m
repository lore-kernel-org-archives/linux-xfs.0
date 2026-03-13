Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1C221770B
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773414073; cv=none; b=k3MbJQxm153OdvLwLo9YbqP+th+37WlHqJTwkoXXELoLIsa1HDy4D9VEuHFFiH5dXUV08dfHHD50MQySmNKME/vF2/ddaTgHPCxUXqFrw407lFa53E5r2kL8sndvXtDyqJzRWXZWPDUfAfiy3neVmuZazq0EJ56ykMDjHUNygRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773414073; c=relaxed/simple;
	bh=5RXUKClFDre4NjMRKGwpZY0Wm2L4SS9sn/Eu54bMaPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLbHE4xGfj5TZ8KuN6++bEmba7/D74NlIrVKHSzosM6ggebMFDvcyyhBeoome46YlIwrqpe1sjMQIl8Muv/we/hXfGwJsEwC6cjRWG/Ga4Smd0XhXQZ/qrDpkxLEKEz75TAWnOh6kPgk0DzRSOP9b6hUBA+bb/dF8dh83H+LMmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t9J+D4G2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t9J+D4G2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3843FC19421;
	Fri, 13 Mar 2026 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773414073;
	bh=5RXUKClFDre4NjMRKGwpZY0Wm2L4SS9sn/Eu54bMaPQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t9J+D4G2hmIstbFWL33HT/Oiz/R143QdKcEUrpFo3ZBOCZCA1GhstrWUBYJDI9yK3
	 CdaDtqd39zPrm3U4rzJvh2xuG+X2WugY93WH0TOJRYOGQUPq33IgQ4AQYqNfN/62gF
	 RNNsedJlilOvEUbkLj/8zu0iqRChu+SXRb9kXNrN4rxcf5bbOuaSH8tYCJvAeox4Gr
	 +ErQUYWcEFGOjM9aThUFdxz2SajHb2qzNKaOgYHPk6rCmQSd7uPZb+9QFao+sIcIC6
	 atVhDhGJ3/UJgbK7gMCZ/hu6l8SC5Vl1CG9TmDMat9NgAFgV4+fXOw/9ehOZEagrMK
	 vhYQHBrR6hdgw==
Date: Fri, 13 Mar 2026 08:01:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH v2 2/4] xfs: factor out xfs_attr3_node_entry_remove
Message-ID: <20260313150112.GP1770774@frogsfrogsfrogs>
References: <20260312085800.1213919-1-leo.lilong@huawei.com>
 <20260312085800.1213919-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312085800.1213919-3-leo.lilong@huawei.com>

On Thu, Mar 12, 2026 at 04:57:58PM +0800, Long Li wrote:
> Factor out wrapper xfs_attr3_node_entry_remove function, which
> exported for external use.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 54 ++++++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_da_btree.h |  2 ++
>  2 files changed, 45 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 766631f0562e..0b9fe3e4370d 100644
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
> +
> +	__xfs_da3_node_remove(state->args->trans, state->args->dp,
> +			state->args->geo, drop_blk);
> +}
> +
> +/*
> + * Remove an entry from a node at the specified index, this is an exported
> + * wrapper for removing entries from intermediate nodes.

"exported" is confusing since in kernel-land that usually implies
EXPORT_SYMBOL_GPL(), which this clearly isn't.  You could trim this to

/*
 * Remove an entry from an intermediate attr node at the specified
 * index.
 */

With that touched up,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> + */
> +void
> +xfs_attr3_node_entry_remove(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	struct xfs_buf		*bp,
> +	int			index)
> +{
> +	struct xfs_da_state_blk blk = {
> +		.index		= index,
> +		.bp		= bp,
> +	};
> +
> +	__xfs_da3_node_remove(tp, dp, dp->i_mount->m_attr_geo, &blk);
> +}
> +
>  /*
>   * Unbalance the elements between two intermediate nodes,
>   * move all Btree elements from one node into another.
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 354d5d65043e..afcf2d3c7a21 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -184,6 +184,8 @@ int	xfs_da3_split(xfs_da_state_t *state);
>  int	xfs_da3_join(xfs_da_state_t *state);
>  void	xfs_da3_fixhashpath(struct xfs_da_state *state,
>  			    struct xfs_da_state_path *path_to_to_fix);
> +void	xfs_attr3_node_entry_remove(struct xfs_trans *tp, struct xfs_inode *dp,
> +			    struct xfs_buf *bp, int index);
>  
>  /*
>   * Routines used for finding things in the Btree.
> -- 
> 2.39.2
> 
> 
