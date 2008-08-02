Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 17:34:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m720Xv7a019133
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 17:33:57 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09D5B2FF491
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 17:35:10 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id mrCcq1W0WvGEFFte for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 17:35:10 -0700 (PDT)
Date: Sat, 2 Aug 2008 10:35:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/21] implement generic xfs_btree_increment
Message-ID: <20080802003506.GJ6201@disturbed>
References: <20080729193053.GJ19104@lst.de> <20080730020645.GJ13395@disturbed> <20080801194000.GC1263@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801194000.GC1263@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Aug 01, 2008 at 09:40:00PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 30, 2008 at 12:06:45PM +1000, Dave Chinner wrote:
> > > +int xfs_btree_increment(struct xfs_btree_cur *, int, int *);
> > 
> > I think for these interfaces it woul dbe better to include
> > variable names in the prototypes. i.e.:
> > 
> > int xfs_btree_increment(struct xfs_btree_cur *cur, int level, int *stat);
> 
> Well, all this and much more is documented at the implementation site,
> so I'd avoid this churn.  If there are strong feelings for it I
> can change the prototypes.

Not a big deal, really. I was just looking at consistency with the
other prototypes around this one....

> > Would it be better here to explicitly test this rather than assert?
> > ie.:
> > 
> > 	if (lev == cur->bc_nlevels) {
> > 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> > 			goto out0;
> > 		ASSERT(0);
> > 		error = EFSCORRUPTED;
> > 		goto error0;
> > 	}
> > 
> > So that we get an explicit error reported in the production systems
> > rather than carrying on and dying a horrible death somewhere else....
> 
> Yes, this is much better.  But we're getting on a slipperly slope here
> to introduce too many improvements. For the initial patches I'd like
> to stay as close as possible to the old btree implementations.

Sure, but this particular piece of code is different to wthe original
btree anyway because it has to handle two different cases. better
to get it right first time, IMO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
