Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 18:07:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7517G3d021799
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 18:07:16 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3502A1984588
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 18:08:30 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id APzhMdqwHf0AUDk9 for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 18:08:30 -0700 (PDT)
Date: Tue, 5 Aug 2008 11:05:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 21/26] implement =?utf-8?Q?gene?=
	=?utf-8?Q?ric_xfs=5Fbtree=5Fin=D1=95ert=2Finsrec?=
Message-ID: <20080805010557.GL6119@disturbed>
References: <20080804013535.GV8819@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804013535.GV8819@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 03:35:35AM +0200, Christoph Hellwig wrote:
> Make the btree insert code generic.  Based on a patch from David Chinner
> with lots of changes to follow the original btree implementations more
> closely.  While this loses some of the generic helper routines for
> inserting/moving/removing records it also solves some of the one off
> bugs in the original code and makes it easier to verify.
....
> +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
> +		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
> +			/* A resizeable root block that can be made bigger. */
> +			cur->bc_ops->realloc_root(cur, 1);
> +			return 0;
> +		}

I think that ->get_dmaxrecs is probably badly named. I called it
that originally because it matched the macro name it was wrapping.
Realisitically it should be ->get_root_maxrecs....

> +	/* Make a key out of the record data to be inserted, and save it. */
> +	cur->bc_ops->init_key_from_rec(cur, &key, recp);
> +
> +	/* If we're off the left edge, return failure. */
> +	ptr = cur->bc_ptrs[level];
> +	if (ptr == 0) {
> +		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> +		*stat = 0;
> +		return 0;
> +	}

You can probably move the key initialisation till after then initial
'in this block' checks.

> +	/*
> +	 * If the block is full, we can't insert the new entry until we
> +	 * make the block un-full.
> +	 */
> +	xfs_btree_set_ptr_null(cur, &nptr);
> +	if (numrecs == cur->bc_ops->get_maxrecs(cur, level)) {
> +		error = xfs_btree_make_block_unfull(cur, level, numrecs,
> +					&optr, &ptr, &nptr, &ncur, &nrec, stat);
> +		if (error || *stat == 0)
> +			goto error0;
> +	}
> +
> +	/* The current block may have changed during the split. */
> +	block = xfs_btree_get_block(cur, level, &bp);
> +	numrecs = xfs_btree_get_numrecs(block);

The comment here should probably refer to the unfull call, not a
'split'. i.e.:

	/*
	 * the current block may have changed if the block was
	 * previously full and we have just made space in it.
	 */


Otherwise looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
