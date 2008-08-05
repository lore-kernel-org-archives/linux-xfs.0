Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 18:42:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m751gIqv025277
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 18:42:20 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E3FD35BEDB
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 18:43:31 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id DaNr5ezNyXDmdCIG for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 18:43:31 -0700 (PDT)
Date: Tue, 5 Aug 2008 11:43:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 24/26] implement generic xfs_btree_getrec
Message-ID: <20080805014306.GO6119@disturbed>
References: <20080804013556.GY8819@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804013556.GY8819@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 03:35:56AM +0200, Christoph Hellwig wrote:
> Not really much reason to make it generic given that it's so small,
> but this is the last non-method in xfs_alloc_btree.c and xfs_ialloc_btree.c,
> so it makes the whole btree implementation more structured.
....
> +int					/* error */
> +xfs_btree_getrec(
> +	struct xfs_btree_cur	*cur,	/* btree cursor */
> +	union xfs_btree_rec	**recp,	/* output: btree record */
> +	int			*stat)	/* output: success/failure */
> +{
> +	struct xfs_btree_block	*block;	/* btree block */
> +	int			ptr;	/* record number */
> +#ifdef DEBUG
> +	int			error;	/* error return value */
> +#endif
> +
> +	ptr = cur->bc_ptrs[0];
> +	block = XFS_BUF_TO_BLOCK(cur->bc_bufs[0]);

Would it make more sense to use:

	block = xfs_btree_get_block(cur, 0, &bp);

> +
> +#ifdef DEBUG
> +	error = xfs_btree_check_block(cur, block, 0, cur->bc_bufs[0]);

and then pass bp here? I'd rather use the helpers to do this than
open code it like everything else does....

Otherwise it looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
