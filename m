Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Sep 2008 10:40:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8GHe5qC027123
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 10:40:05 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6566512A55AA
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 10:41:36 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id aWAX4HHj72BzZ8zr for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 10:41:36 -0700 (PDT)
Date: Tue, 16 Sep 2008 19:41:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] cleanup btree record / key / ptr addressing macros
Message-ID: <20080916174136.GC26187@lst.de>
References: <20080915004653.GE12213@lst.de> <20080916055333.GW5811@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916055333.GW5811@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Sep 16, 2008 at 03:53:33PM +1000, Dave Chinner wrote:
> On Mon, Sep 15, 2008 at 02:46:53AM +0200, Christoph Hellwig wrote:
> > Replace the generic record / key / ptr addressing macros that use cpp token
> > pasting with simpler macros that do the job for just one given btree type.
> > The new macros lose the cur argument and thus can be used outside the core
> > btree code, but also gain an xfs_mount * argument to allow for checking the
> > CRC flag in the near future.  Note that many of these macros aren't actually
> > used in the kernel code, but only in userspace (mostly in xfs_repair).
> ......
> > @@ -85,9 +84,9 @@ xfs_bmdr_to_bmbt(
> >  	rblock->bb_leftsib = cpu_to_be64(NULLDFSBNO);
> >  	rblock->bb_rightsib = cpu_to_be64(NULLDFSBNO);
> >  	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
> > -	fkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
> > -	tkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
> > -	fpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
> > +	fkp = XFS_BMDR_KEY_ADDR(dblock, 1);
> > +	tkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
> > +	fpp = XFS_BMDR_PTR_ADDR(dblock, 1, dmxr);
> >  	tpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
> 
> Why did you change XFS_BMAP_BROOT_KEY_ADDR and not
> XFS_BMAP_BROOT_PTR_ADDR?

Because XFS_BMAP_BROOT_KEY_ADDR was just another name for
XFS_BMBT_KEY_ADDR, while XFS_BMAP_BROOT_PTR_ADDR actually adds some
value (a call to xfs_bmbt_maxrecs).

> > -#define	XFS_ALLOC_REC_ADDR(bb,i,cur)	\
> > -	XFS_BTREE_REC_ADDR(xfs_alloc, bb, i)
> > +#define XFS_ALLOC_REC_ADDR(mp, block, index) \
> > +	((xfs_alloc_rec_t *) \
> > +		((char *)(block) + \
> > +		 sizeof(struct xfs_btree_sblock) + \
> > +		 (((index) - 1) * sizeof(xfs_alloc_rec_t))))
> 
> Shouldn't these become inline functions rather than macros now
> that the token substitution is gone? Same for rest as well?
> That would remove a bunch of shouting that you're changing
> anyway....

Inlines don't work due to header ordering problems.  I tried to move
them out of line, but it actually increased the code size.

> > +		if (root)
> >  			pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, i, sz);
> > +		else
> > +			pp = XFS_BMBT_PTR_ADDR(mp, block, i, dmxr);
> 
> Why the assymetry in the interfaces for key and ptr?

The only real difference is that the ptr needs the maxrecs value passed
because it's used in the calculation, while the key address calculation
doesn't need it and thus doesn't get it passed.

> > +#define XFS_BMAP_BROOT_PTR_ADDR(mp, bb, i, sz) \
> > +	XFS_BMBT_PTR_ADDR(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, 0))
> 
> Ah, that explains why that macro didn't change. Why keep just this
> one?

It seems borderline useful, but if you care strongly I can kill it.
