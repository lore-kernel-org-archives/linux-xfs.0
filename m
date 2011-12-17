Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBHNUnVT133155 for <xfs@oss.sgi.com>; Sat, 17 Dec 2011 17:30:49 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3XPs4yCJ4FmuYhZ9 for <xfs@oss.sgi.com>;
	Sat, 17 Dec 2011 15:30:48 -0800 (PST)
Date: Sat, 17 Dec 2011 18:30:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/12] xfs: remove struct xfs_dabuf and infrastructure
Message-ID: <20111217233047.GC2383@infradead.org>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
	<1323238703-13198-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323238703-13198-12-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>  	ASSERT(bp != NULL);
> -	leaf = bp->data;
> +	leaf = bp->b_addr;
>  	if (unlikely(leaf->hdr.info.magic != cpu_to_be16(XFS_ATTR_LEAF_MAGIC))) {
>  		XFS_CORRUPTION_ERROR("xfs_attr_leaf_list", XFS_ERRLEVEL_LOW,
>  				     context->dp->i_mount, leaf);
> -		xfs_da_brelse(NULL, bp);
> +		xfs_trans_brelse(NULL, bp);

Wouldn't a direct call to xfs_buf_relse be the more logical replacement
for a call to xfs_da_brelse with a constant NULL transaction argument?

>  int
> -xfs_attr_shortform_allfit(xfs_dabuf_t *bp, xfs_inode_t *dp)
> +xfs_attr_shortform_allfit(
> +	struct xfs_buf	*bp,
> +	struct xfs_inode *dp)

If you'd use one more tab all arguments would be full aligned.  This
also happens in a few more places.

> -xfs_attr_leaf_to_shortform(xfs_dabuf_t *bp, xfs_da_args_t *args, int forkoff)
> +xfs_attr_leaf_to_shortform(
> +	struct xfs_buf	*bp,
> +	xfs_da_args_t	*args,

Also if you touch the argument list anyway please replace xfs_da_args_t
with struct xfs_da_args.

>  void
>  xfs_da_state_free(xfs_da_state_t *state)
>  {
> -	int	i;
> -
>  	xfs_da_state_kill_altpath(state);
> -	for (i = 0; i < state->path.active; i++) {
> -		if (state->path.blk[i].bp)
> -			xfs_da_buf_done(state->path.blk[i].bp);
> -	}
> -	if (state->extravalid && state->extrablk.bp)
> -		xfs_da_buf_done(state->extrablk.bp);
>  #ifdef DEBUG
>  	memset((char *)state, 0, sizeof(*state));
>  #endif /* DEBUG */
>  	kmem_zone_free(xfs_da_state_zone, state);

We really should kill that memset, which only defeats slab poisoning.
Not in this patch, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
