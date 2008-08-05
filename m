Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 19:19:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m752Jorh029537
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 19:19:50 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89C5635C1A4
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 19:21:04 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id XyWtGGADmrJG4jkG for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 19:21:04 -0700 (PDT)
Date: Tue, 5 Aug 2008 12:18:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 23/26] implement generic xfs_btree_delete/delrec
Message-ID: <20080805021834.GS6119@disturbed>
References: <20080804013550.GX8819@lst.de> <20080805013625.GN6119@disturbed> <20080805014524.GA6465@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805014524.GA6465@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Aug 05, 2008 at 03:45:24AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 05, 2008 at 11:36:25AM +1000, Dave Chinner wrote:
> > > +#ifdef DEBUG
> > > +	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_CNT) {
> > > +		struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> > > +		struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> > > +
> > > +		ASSERT(be32_to_cpu(agf->agf_roots[cur->bc_btnum]) ==
> > > +		       XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp)));
> > > +	} else if (cur->bc_btnum == XFS_BTNUM_INO) {
> > > +		struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> > > +		struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
> > > +		xfs_fsblock_t		fsbno;
> > > +
> > > +		fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
> > > +				       be32_to_cpu(agi->agi_root));
> > > +
> > > +		ASSERT(fsbno == XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)));
> > > +	}
> > > +#endif
> > 
> > That's kind of messy - can it be pushed out to a separate debug only
> > function? Also, why do we check the inobt against a long pointer,
> > and the allocbt against a short pointer? both are short pointer
> > btrees, so it doesn't really make sense to me to have different
> > checks on them...
> 
> The old inobt code built a long pointer to pass it to xfs_free_extent,
> and this assert validates we get the same block.  The right thing to
> do here is to just remove this crap, it was just there to make sure
> I didn't add a really bad thinko.
> 
> > Otherwise looks pretty good.
> 
> Unfortunately it's buggy, though.  The cur->bc_bufs[level] = NULL; vs
> xfs_btree_setbuf(cur, level, NULL); does make an enormous difference
> for 512byte block size filesystems.

I was going to come back to that - I'd noticed that difference but
hadn't looked deeply into the change that it would cause.

It looks like:

	a) it releases the old buffer
	b) clears the readahead status in the cursor

a) will increase CPU overhead, but if the buffer is dirty won't
affect behaviour at all as it will be held till transaction commit.
b) will have a significant impact on the performance of btree
traversals. That will show up most in small block size
filesystems...

So it shouldn't be a corruption causing change, only a performance
degrading change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
