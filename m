Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 18:45:59 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m751jvJT026383
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 18:45:57 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28FEF1984A45
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 18:47:11 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id aETbBvkt52A5KW5u for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 18:47:11 -0700 (PDT)
Date: Tue, 5 Aug 2008 03:47:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 24/26] implement generic xfs_btree_getrec
Message-ID: <20080805014713.GB6465@lst.de>
References: <20080804013556.GY8819@lst.de> <20080805014306.GO6119@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805014306.GO6119@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Aug 05, 2008 at 11:43:06AM +1000, Dave Chinner wrote:
> On Mon, Aug 04, 2008 at 03:35:56AM +0200, Christoph Hellwig wrote:
> > Not really much reason to make it generic given that it's so small,
> > but this is the last non-method in xfs_alloc_btree.c and xfs_ialloc_btree.c,
> > so it makes the whole btree implementation more structured.
> ....
> > +int					/* error */
> > +xfs_btree_getrec(
> > +	struct xfs_btree_cur	*cur,	/* btree cursor */
> > +	union xfs_btree_rec	**recp,	/* output: btree record */
> > +	int			*stat)	/* output: success/failure */
> > +{
> > +	struct xfs_btree_block	*block;	/* btree block */
> > +	int			ptr;	/* record number */
> > +#ifdef DEBUG
> > +	int			error;	/* error return value */
> > +#endif
> > +
> > +	ptr = cur->bc_ptrs[0];
> > +	block = XFS_BUF_TO_BLOCK(cur->bc_bufs[0]);
> 
> Would it make more sense to use:
> 
> 	block = xfs_btree_get_block(cur, 0, &bp);
> 
> > +
> > +#ifdef DEBUG
> > +	error = xfs_btree_check_block(cur, block, 0, cur->bc_bufs[0]);
> 
> and then pass bp here? I'd rather use the helpers to do this than
> open code it like everything else does....

Thanks, updated.
