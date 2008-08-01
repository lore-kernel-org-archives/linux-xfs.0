Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:38:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JckLP024998
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:38:46 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1390179F96A
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:39:58 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Zr3kXKc4lVE7HkcM for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:39:58 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:40:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/21] implement generic xfs_btree_increment
Message-ID: <20080801194000.GC1263@lst.de>
References: <20080729193053.GJ19104@lst.de> <20080730020645.GJ13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730020645.GJ13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 30, 2008 at 12:06:45PM +1000, Dave Chinner wrote:
> > +int xfs_btree_increment(struct xfs_btree_cur *, int, int *);
> 
> I think for these interfaces it woul dbe better to include
> variable names in the prototypes. i.e.:
> 
> int xfs_btree_increment(struct xfs_btree_cur *cur, int level, int *stat);

Well, all this and much more is documented at the implementation site,
so I'd avoid this churn.  If there are strong feelings for it I
can change the prototypes.

> Can kill the else there:
> 
> 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> 		return be64_to_cpu(ptr->l) == NULLFSBLOCK;
> 	return be32_to_cpu(ptr->s) == NULLAGBLOCK;

Normally I'd agree with you, but for the short/long pointer case the
if else make the symmetry of the code clear and thus is IMHO better
readable.

> > +			ptr->s = block->bb_u.s.bb_rightsib;
> > +		else
> > +			ptr->s = block->bb_u.s.bb_leftsib;
> > +	}
> > +}
> 
> Should we use trinary notation for this? i.e:

I find the if else much easier to read.

> Hmmm - if xfs_btree_check_block() returns an error, we won't release
> the buffer in the error handling path. While this may not be a
> problem right now (as the only error is EFSCORRUPTED) we want to be
> able to recover from errors here in the future so we should really
> exit cleanly form this function....

Fixed.

> Would it be better here to explicitly test this rather than assert?
> ie.:
> 
> 	if (lev == cur->bc_nlevels) {
> 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> 			goto out0;
> 		ASSERT(0);
> 		error = EFSCORRUPTED;
> 		goto error0;
> 	}
> 
> So that we get an explicit error reported in the production systems
> rather than carrying on and dying a horrible death somewhere else....

Yes, this is much better.  But we're getting on a slipperly slope here
to introduce too many improvements.  For the initial patches I'd like
to stay as close as possible to the old btree implementations.

Anyway, this change is trivial enough and I've added it.
