Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:42:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JgN2D025847
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:42:25 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76B7EEECE54
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:43:36 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id jyQHmKs3e9O8FkXt for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:43:36 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:43:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/21] implement generic xfs_btree_lookup
Message-ID: <20080801194336.GE1263@lst.de>
References: <20080729193104.GL19104@lst.de> <20080730045937.GL13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730045937.GL13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 30, 2008 at 02:59:37PM +1000, Dave Chinner wrote:
> > +	if (level == 0) {
> > +		union xfs_btree_rec	*krp;
> > +
> > +		krp = cur->bc_ops->rec_addr(cur, keyno, block);
> > +		cur->bc_ops->init_key_from_rec(cur, kp, krp);
> > +		return kp;
> 
> I think the record pointer variable "krp" is confusing with "kp", the key
> pointer. It's a record pointer; 'rp' it should be.

Ok, fixed.

> Can you make the {} consistent here ant move the comment for the
> else? i.e.

Yeah, done.

> > +	/* Return if we succeeded or not. */
> > +	if (keyno == 0 || keyno > xfs_btree_get_numrecs(block))
> > +		*stat = 0;
> > +	else
> > +		*stat = ((dir != XFS_LOOKUP_EQ) || (diff == 0));
> 
> Can probably kill all the extra () in that.

I've turned this into an if else if else with the superflous
braces removed.

> > --- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-07-15 17:46:52.000000000 +0200
> > +++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-07-15 17:51:41.000000000 +0200
> > @@ -90,6 +90,54 @@ STATIC int xfs_alloc_ag_vextent_small(xf
> >   */
> >  
> >  /*
> > + * Lookup the record equal to [bno, len] in the btree given by cur.
> > + */
> > +STATIC int				/* error */
> > +xfs_alloc_lookup_eq(
> 
> Should these be xfs_allocbt_lookup_*() to be consistent
> with all the other allocbt functions (and inobt_lookup/bmbt_lookup)?

Currently only the btree_ops methods are named allocbt.  Comments on
that scheme would be appreciated.
