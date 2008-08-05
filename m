Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 18:25:23 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m751PGU0023270
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 18:25:18 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C275B19848A1
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 18:26:30 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id rVFx9uulCixCSbsr for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 18:26:30 -0700 (PDT)
Date: Mon, 4 Aug 2008 21:26:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/26] move xfs_bmbt_killroot to common code
Message-ID: <20080805012630.GA22147@infradead.org>
References: <20080804013542.GW8819@lst.de> <20080805011437.GM6119@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805011437.GM6119@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Aug 05, 2008 at 11:14:37AM +1000, Dave Chinner wrote:
> On Mon, Aug 04, 2008 at 03:35:42AM +0200, Christoph Hellwig wrote:
> > xfs_bmbt_killroot is a mostly generic implementation of moving from
> > a real block based root to an inode based root.  So move it to xfs_btree.c
> > where it can use all the nice infrastructure there and make it pointer
> > size agnostic
> > 
> > The new name for it is xfs_btree_root_to_iroot which is not very
> > nice but at least slightly more descriptive than the old name.
> .....
> > +
> > +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > +	level = cur->bc_nlevels - 1;
> > +	ASSERT(level >= 1);
> 
> probably should assert root in inode is set here.

We have that check just before the call, so this might be a little
overkill..

> 
> > +	cblock = xfs_btree_get_block(cur, level - 1, &cbp);
> > +	numrecs = xfs_btree_get_numrecs(cblock);
> > +
> > +	if (numrecs > cur->bc_ops->get_dmaxrecs(cur, level))
> > +	    	goto out0;
>         ^^^^
> Stray whitespace.

Already fixed before your mail after I ran checkpatch.pl
over all patches - there were a few spread over the various patches.

> > +	// XXX(hch): this assert is bmap btree specific
> > + 	ASSERT(cur->bc_ops->get_maxrecs(cur, level) ==
>    ^
> > +	       XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes));
> 
> Stray whitespace. As to the assert - what is it really trying to
> check? That the btree root space in the inode is large enough to
> fit the max number of records? If so, does it really need to be
> checked here (i.e. could the caller do it?)

I don't think it makes much sense at all.  My preference would
be to simply kill it.
