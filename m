Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:53:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JrtNe028501
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:53:55 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDFA0EED08C
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:55:07 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id LG5LbHyakmEweHdm for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:55:07 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:55:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/21] implement generic xfs_btree_split
Message-ID: <20080801195507.GK1263@lst.de>
References: <20080729192113.493074843@verein.lst.de> <20080729193137.GR19104@lst.de> <20080730065349.GR13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730065349.GR13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

> This is where I begin to question this approach (i.e. using
> helpers like this rather than specific ops like I did). It's
> taken me 4 ??r 5 patches to put my finger on it.
> 
> The intent of this factorisation is to make implementing new btree
> structures easy, not making the current code better or more
> managable. The first thing we need is is btrees with different
> header blocks (self describing information, CRCs, etc). This above
> function will suddenly have four combinations to deal with - long and
> short, version 1 and version 2 header formats. The more we change,
> the more this complicates these helpers. That is why I pushed
> seemingly trivial stuff out to operations vectors - because of the
> future flexibility it allowed in implementation of new btrees.....
> 
> I don't see this a problem for this patch series, but I can see that
> some of this work will end up being converted back to ops vectors
> as soon as we start modifying between structures....

Maybe.  But even when we convert it to ops vectors it should not
be the btree implementation vector, but a btree_block_ops that's
implemented once instead of duplicated for the alloc vs ialloc
btree.  And for now having all this in xfs_btree.c makes reading
and working on the patch series easier, so..

> > +	/* need to sort out how callers deal with failures first */
> > +	ASSERT(!(flags & XFS_BUF_TRYLOCK));
> > +
> > +	d = xfs_btree_ptr_to_daddr(cur, ptr);
> > +	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
> > +				 mp->m_bsize, flags);
> > +
> > +	ASSERT(*bpp);
> > +	ASSERT(!XFS_BUF_GETERROR(*bpp));
> 
> xfs_trans_get_buf() can return NULL, right?

Only when XFS_BUF_TRYLOCK is set, which it never is for the
btree code, and the assert above makes sure we catch any new caller
early.

> > +	/* block allocation / freeing */
> > +	int	(*alloc_block)(struct xfs_btree_cur *cur,
> > +			       union xfs_btree_ptr *sbno,
> > +			       union xfs_btree_ptr *nbno,
> 
> start_bno, new_bno.

Done.
