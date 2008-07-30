Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 22:08:41 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U58csv032119
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 22:08:39 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8B1019530B8
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 22:09:49 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id GIsPsMn5QOBYpmOZ for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 22:09:49 -0700 (PDT)
Date: Wed, 30 Jul 2008 15:09:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/21] implement generic xfs_btree_updkey
Message-ID: <20080730050936.GM13395@disturbed>
References: <20080729193110.GM19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193110.GM19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:31:10PM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dgc@sgi.com>
> 
> Note that there are many > 80 char lines introduced due to the
> xfs_btree_key casts.  But the places where this happens is throw-away
> code once the whole btree code gets merged into a common implementation.
> 
> The same is true for the temporary xfs_alloc_log_keys define to the new
> name.  All old users will be gone after a few patches.
> 
> [hch: split out from bigger patch and minor adaptions]
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

.....

> +/*
> + * Update keys at all levels from here to the root along the cursor's path.
> + */
> +int
> +xfs_btree_updkey(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_key	*keyp,
> +	int			level)
> +{
> +	struct xfs_btree_block	*block;
> +	struct xfs_buf		*bp;
> +	union xfs_btree_key	*kp;
> +	int			ptr;
> +#ifdef DEBUG
> +	int			error;
> +#endif

This can be scoped inside the for loop.

> +
> +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> +	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);
> +
> +	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) || level >= 1);
> +
> +	/*
> +	 * Go up the tree from this level toward the root.
> +	 * At each level, update the key value to the value input.
> +	 * Stop when we reach a level where the cursor isn't pointing
> +	 * at the first entry in the block.
> +	 */
> +	for (ptr = 1; ptr == 1 && level < cur->bc_nlevels; level++) {
> +		block = xfs_btree_get_block(cur, level, &bp);
> +#ifdef DEBUG
> +		error = xfs_btree_check_block(cur, block, level, bp);
> +		if (error) {
> +			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> +			return error;
> +		}
> +#endif

And even then I think we might not need an error variable - it can
only return EFSCORRUPTED, so:

#ifdef DEBUG
		if (xfs_btree_check_block(cur, block, level, bp)) {
			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
			return EFSCORRUPTED;
		}
#endif

Would remove the need for the error variable.

Otherwise looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
