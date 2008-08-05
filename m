Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 19:08:29 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7528QjO028483
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 19:08:27 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1CE2198487A
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 19:09:40 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id r4anVa9FG52aojV6 for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 19:09:40 -0700 (PDT)
Date: Tue, 5 Aug 2008 12:08:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 22/26] move xfs_bmbt_killroot to common code
Message-ID: <20080805020856.GR6119@disturbed>
References: <20080804013542.GW8819@lst.de> <20080805011437.GM6119@disturbed> <20080805012630.GA22147@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805012630.GA22147@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 09:26:30PM -0400, Christoph Hellwig wrote:
> On Tue, Aug 05, 2008 at 11:14:37AM +1000, Dave Chinner wrote:
> > On Mon, Aug 04, 2008 at 03:35:42AM +0200, Christoph Hellwig wrote:
> > > xfs_bmbt_killroot is a mostly generic implementation of moving from
> > > a real block based root to an inode based root.  So move it to xfs_btree.c
> > > where it can use all the nice infrastructure there and make it pointer
> > > size agnostic
> > > 
> > > The new name for it is xfs_btree_root_to_iroot which is not very
> > > nice but at least slightly more descriptive than the old name.
> > .....
> > > +
> > > +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > > +	level = cur->bc_nlevels - 1;
> > > +	ASSERT(level >= 1);
> > 
> > probably should assert root in inode is set here.
> 
> We have that check just before the call, so this might be a little
> overkill..

Fair enough.

> > > +	// XXX(hch): this assert is bmap btree specific
> > > + 	ASSERT(cur->bc_ops->get_maxrecs(cur, level) ==
> >    ^
> > > +	       XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes));
> > 
> > Stray whitespace. As to the assert - what is it really trying to
> > check? That the btree root space in the inode is large enough to
> > fit the max number of records? If so, does it really need to be
> > checked here (i.e. could the caller do it?)
> 
> I don't think it makes much sense at all.  My preference would
> be to simply kill it.

Agreed. Kill it - I don't think it adds any value.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
