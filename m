Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Sep 2008 17:58:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8H0wcEU022221
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 17:58:39 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8FA044AEF3
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 18:00:10 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id HhtFI3rRef8UmDTe for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 18:00:10 -0700 (PDT)
Date: Wed, 17 Sep 2008 10:59:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] always use struct xfs_btree_block instead of short
	/ longform structures
Message-ID: <20080917005955.GH5811@disturbed>
References: <20080915004657.GF12213@lst.de> <20080916062616.GY5811@disturbed> <20080916173107.GB26187@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916173107.GB26187@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Sep 16, 2008 at 07:31:07PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 16, 2008 at 04:26:16PM +1000, Dave Chinner wrote:
> > On Mon, Sep 15, 2008 at 02:46:57AM +0200, Christoph Hellwig wrote:
> > > Always use the generic xfs_btree_block type instead of the short / long
> > > structures.  Add XFS_BTREE_SBLOCK_LEN / XFS_BTREE_LBLOCK_LEN defines for
> > > the length of a short / long form block.  The rationale for this is that
> > > we will grow more btree block header variants to support CRCs and other
> > > RAS information, and always accessing them through the same datatype
> > > with unions for the short / long form pointers makes implementing this
> > > much easier.
> > .......
> > > @@ -382,16 +382,16 @@ xfs_alloc_fixup_trees(
> > >  	}
> > >  #ifdef DEBUG
> > >  	{
> > > -		xfs_alloc_block_t	*bnoblock;
> > > -		xfs_alloc_block_t	*cntblock;
> > > +		struct xfs_btree_block		*bnoblock;
> > > +		struct xfs_btree_block		*cntblock;
> > 
> > Only need one tab there?
> 
> I think this was aligning to something, but I don't really care.
> 
> > > -			bnoblock = XFS_BUF_TO_ALLOC_BLOCK(bno_cur->bc_bufs[0]);
> > > -			cntblock = XFS_BUF_TO_ALLOC_BLOCK(cnt_cur->bc_bufs[0]);
> > >  			XFS_WANT_CORRUPTED_RETURN(
> > > -				be16_to_cpu(bnoblock->bb_numrecs) ==
> > > -				be16_to_cpu(cntblock->bb_numrecs));
> > > +				bnoblock->bb_numrecs ==
> > > +				cntblock->bb_numrecs);
> > 
> > The comparison could probably be made one line....
> 
> That would be far over 80 characters.

I meant:
			XFS_WANT_CORRUPTED_RETURN(
				bnoblock->bb_numrecs == cntblock->bb_numrecs);

Which doesn't go over 80 chars.

Doesn't really matter, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
