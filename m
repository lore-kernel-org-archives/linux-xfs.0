Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 18:44:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m751iBVl025974
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 18:44:11 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67744124399A
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 18:45:24 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id d1Gx5UiBIn5v0nX5 for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 18:45:24 -0700 (PDT)
Date: Tue, 5 Aug 2008 03:45:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 23/26] implement generic xfs_btree_delete/delrec
Message-ID: <20080805014524.GA6465@lst.de>
References: <20080804013550.GX8819@lst.de> <20080805013625.GN6119@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805013625.GN6119@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Aug 05, 2008 at 11:36:25AM +1000, Dave Chinner wrote:
> > +#ifdef DEBUG
> > +	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_CNT) {
> > +		struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> > +		struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> > +
> > +		ASSERT(be32_to_cpu(agf->agf_roots[cur->bc_btnum]) ==
> > +		       XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp)));
> > +	} else if (cur->bc_btnum == XFS_BTNUM_INO) {
> > +		struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> > +		struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
> > +		xfs_fsblock_t		fsbno;
> > +
> > +		fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
> > +				       be32_to_cpu(agi->agi_root));
> > +
> > +		ASSERT(fsbno == XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)));
> > +	}
> > +#endif
> 
> That's kind of messy - can it be pushed out to a separate debug only
> function? Also, why do we check the inobt against a long pointer,
> and the allocbt against a short pointer? both are short pointer
> btrees, so it doesn't really make sense to me to have different
> checks on them...

The old inobt code built a long pointer to pass it to xfs_free_extent,
and this assert validates we get the same block.  The right thing to
do here is to just remove this crap, it was just there to make sure
I didn't add a really bad thinko.

> Otherwise looks pretty good.

Unfortunately it's buggy, though.  The cur->bc_bufs[level] = NULL; vs
xfs_btree_setbuf(cur, level, NULL); does make an enormous difference
for 512byte block size filesystems.  I'll have to find out what's
going on in this area, and to make things worse I remember spotting
a similar different between the ialloc and alloc btrees somewhere
earlier in the series.
