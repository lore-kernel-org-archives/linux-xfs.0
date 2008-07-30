Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 21:58:34 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U4wTaT031062
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:58:29 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55A631950AC2
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:59:41 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id QziVnpyF2DJJxDRp for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:59:41 -0700 (PDT)
Date: Wed, 30 Jul 2008 14:59:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/21] implement generic xfs_btree_lookup
Message-ID: <20080730045937.GL13395@disturbed>
References: <20080729193104.GL19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193104.GL19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:31:04PM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dgc@sgi.com>
> 
> [hch: split out from bigger patch and minor adaptions]
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....

> +
> +/*
> + * Get current search key.  For level 0 we don't actually have a key
> + * structure so we make one up from the record.  For all other levels
> + * we just return the right key.
> + */
> +STATIC union xfs_btree_key *
> +xfs_lookup_get_search_key(
> +	struct xfs_btree_cur	*cur,
> +	int			level,
> +	int			keyno,
> +	struct xfs_btree_block	*block,
> +	union xfs_btree_key	*kp)
> +{
> +	if (level == 0) {
> +		union xfs_btree_rec	*krp;
> +
> +		krp = cur->bc_ops->rec_addr(cur, keyno, block);
> +		cur->bc_ops->init_key_from_rec(cur, kp, krp);
> +		return kp;

I think the record pointer variable "krp" is confusing with "kp", the key
pointer. It's a record pointer; 'rp' it should be.

> +	/*
> +	 * Iterate over each level in the btree, starting at the root.
> +	 * For each level above the leaves, find the key we need, based
> +	 * on the lookup record, then follow the corresponding block
> +	 * pointer down to the next level.
> +	 */
> +	for (level = cur->bc_nlevels - 1, diff = 1; level >= 0; level--) {
> +		/* Get the block we need to do the lookup on. */
> +		error = xfs_btree_lookup_get_block(cur, level, pp, &block);
> +		if (error)
> +			goto error0;
> +
> +		/*
> +		 * If we already had a key match at a higher level, we know
> +		 * we need to use the first entry in this block.
> +		 */
> +		if (diff == 0)
> +			keyno = 1;
> +
> +		/* Otherwise search this block. Do a binary search. */
> +		else {

Can you make the {} consistent here ant move the comment for the
else? i.e.

		if (diff == 0) {
			keyno = 1;
		} else {
			/* Otherwise search this block. Do a binary search. */

> +			int	high;	/* high entry number */
> +			int	low;	/* low entry number */
> +
> +			/* Set low and high entry numbers, 1-based. */
> +			low = 1;
> +			high = xfs_btree_get_numrecs(block);
> +			if (!high) {
> +				/* Block is empty, must be an empty leaf. */
> +				ASSERT(level == 0 && cur->bc_nlevels == 1);
> +				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
> +				XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> +				*stat = 0;
> +				return 0;
> +			}
> +			/* Binary search the block. */

Can we add a couple of empty lines there to break up that code a
bit?

			high = xfs_btree_get_numrecs(block);
			if (!high) {
				/* Block is empty, must be an empty leaf. */
				ASSERT(level == 0 && cur->bc_nlevels == 1);

				cur->bc_ptrs[0] = dir != XFS_LOOKUP_LE;
				XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
				*stat = 0;
				return 0;
			}

			/* Binary search the block. */

> +	/* Return if we succeeded or not. */
> +	if (keyno == 0 || keyno > xfs_btree_get_numrecs(block))
> +		*stat = 0;
> +	else
> +		*stat = ((dir != XFS_LOOKUP_EQ) || (diff == 0));

Can probably kill all the extra () in that.

> --- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-07-15 17:46:52.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-07-15 17:51:41.000000000 +0200
> @@ -90,6 +90,54 @@ STATIC int xfs_alloc_ag_vextent_small(xf
>   */
>  
>  /*
> + * Lookup the record equal to [bno, len] in the btree given by cur.
> + */
> +STATIC int				/* error */
> +xfs_alloc_lookup_eq(

Should these be xfs_allocbt_lookup_*() to be consistent
with all the other allocbt functions (and inobt_lookup/bmbt_lookup)?

Otherwise look sane.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
