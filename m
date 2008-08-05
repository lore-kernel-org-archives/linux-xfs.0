Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 18:13:55 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m751Dr31022427
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 18:13:53 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B00F919845CF
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 18:15:06 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id LX5t736CKaSJDPct for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 18:15:06 -0700 (PDT)
Date: Tue, 5 Aug 2008 11:14:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 22/26] move xfs_bmbt_killroot to common code
Message-ID: <20080805011437.GM6119@disturbed>
References: <20080804013542.GW8819@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804013542.GW8819@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 03:35:42AM +0200, Christoph Hellwig wrote:
> xfs_bmbt_killroot is a mostly generic implementation of moving from
> a real block based root to an inode based root.  So move it to xfs_btree.c
> where it can use all the nice infrastructure there and make it pointer
> size agnostic
> 
> The new name for it is xfs_btree_root_to_iroot which is not very
> nice but at least slightly more descriptive than the old name.
.....
> +
> +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> +	level = cur->bc_nlevels - 1;
> +	ASSERT(level >= 1);

probably should assert root in inode is set here.

> +	cblock = xfs_btree_get_block(cur, level - 1, &cbp);
> +	numrecs = xfs_btree_get_numrecs(cblock);
> +
> +	if (numrecs > cur->bc_ops->get_dmaxrecs(cur, level))
> +	    	goto out0;
        ^^^^
Stray whitespace.

> +
> +	XFS_BTREE_STATS_INC(cur, killroot);
> +
> +#ifdef DEBUG
> +	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_LEFTSIB);
> +	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
> +	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
> +	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
> +
> +	// XXX(hch): this assert is bmap btree specific
> + 	ASSERT(cur->bc_ops->get_maxrecs(cur, level) ==
   ^
> +	       XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes));

Stray whitespace. As to the assert - what is it really trying to
check? That the btree root space in the inode is large enough to
fit the max number of records? If so, does it really need to be
checked here (i.e. could the caller do it?)

Otherwise looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
