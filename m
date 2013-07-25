Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B92967F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 13:58:53 -0500 (CDT)
Date: Thu, 25 Jul 2013 13:58:50 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 14/48] xfs: add CRCs to dir2/da node blocks
Message-ID: <20130725185850.GB3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-15-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-15-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:37AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Corresponds with commit f5ea110044f.

Note we don't have xfs_attr_node_list, xfs_attr_root_inactive,
xfs_attr_node_inactive in userspace.

The check and repair changes look good.

> @@ -299,8 +451,10 @@ xfs_da_split(xfs_da_state_t *state)
>  	 * just got bumped because of the addition of a new root node.
>  	 * There might be three blocks involved if a double split occurred,
>  	 * and the original block 0 could be at any position in the list.
> +	 *
> +	 * Note: the info structures being modified here for both v2 and v3 da
> +	 * headers, so we can do this linkage just using the v2 structures.

The kernel code had additional comments here.  Probably this is synced up in a
subsequent patch.

>  STATIC void
> -xfs_da_node_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
> -				     xfs_da_state_blk_t *save_blk)
> +xfs_da3_node_unbalance(
> +	struct xfs_da_state	*state,
> +	struct xfs_da_state_blk	*drop_blk,
> +	struct xfs_da_state_blk	*save_blk)
>  {
> -	xfs_da_intnode_t *drop_node, *save_node;
> -	xfs_da_node_entry_t *btree;
> -	int tmp;
> -	xfs_trans_t *tp;
> +	struct xfs_da_intnode	*drop_node;
> +	struct xfs_da_intnode	*save_node;
> +	struct xfs_da_node_entry *dbtree;
> +	struct xfs_da_node_entry *sbtree;
> +	struct xfs_da3_icnode_hdr dhdr;
> +	struct xfs_da3_icnode_hdr shdr;

drop and save are named differently in the kernel, probably another one resolved
later in the series.

> +	struct xfs_trans	*tp;
> +	int			sindex;
> +	int			tmp;
>  
>  	trace_xfs_da_node_unbalance(state->args);
>  
>  	drop_node = drop_blk->bp->b_addr;
>  	save_node = save_blk->bp->b_addr;
> -	ASSERT(drop_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
> -	ASSERT(save_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
> +	xfs_da3_node_hdr_from_disk(&dhdr, drop_node);
> +	xfs_da3_node_hdr_from_disk(&shdr, save_node);
> +	dbtree = xfs_da3_node_tree_p(drop_node);
> +	sbtree = xfs_da3_node_tree_p(save_node);
>  	tp = state->args->trans;
>  
>  	/*
>  	 * If the dying block has lower hashvals, then move all the
>  	 * elements in the remaining block up to make a hole.
>  	 */
> -	if ((be32_to_cpu(drop_node->btree[0].hashval) < be32_to_cpu(save_node->btree[ 0 ].hashval)) ||
> -	    (be32_to_cpu(drop_node->btree[be16_to_cpu(drop_node->hdr.count)-1].hashval) <
> -	     be32_to_cpu(save_node->btree[be16_to_cpu(save_node->hdr.count)-1].hashval)))
> -	{
> -		btree = &save_node->btree[be16_to_cpu(drop_node->hdr.count)];
> -		tmp = be16_to_cpu(save_node->hdr.count) * (uint)sizeof(xfs_da_node_entry_t);
> -		memmove(btree, &save_node->btree[0], tmp);
> -		btree = &save_node->btree[0];
> +	if ((be32_to_cpu(dbtree[0].hashval) < be32_to_cpu(sbtree[ 0 ].hashval)) ||
> +	    (be32_to_cpu(dbtree[dhdr.count - 1].hashval) <
> +				be32_to_cpu(sbtree[shdr.count - 1].hashval))) {
> +		/* XXX: check this - is memmove dst correct? */
> +		tmp = shdr.count * (uint)sizeof(xfs_da_node_entry_t);
> +		memmove(&sbtree[dhdr.count], &sbtree[0], tmp);

Mmm.  I don't remember how things came out regarding the question of this
memmove.

> @@ -1835,17 +2153,22 @@ xfs_da_swap_lastblock(
>  		dead_level = 0;
>  		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
>  	} else {
> -		ASSERT(dead_info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
> +		struct xfs_da3_icnode_hdr deadhdr;
> +
> +		ASSERT(dead_info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
> +		       dead_info->magic == cpu_to_be16(XFS_DA3_NODE_MAGIC));

This assert was removed in the kernel.  Not sure if we want to keep it here...

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
