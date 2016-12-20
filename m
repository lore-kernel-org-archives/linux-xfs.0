Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46653 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932479AbcLTX3E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2016 18:29:04 -0500
Date: Tue, 20 Dec 2016 15:28:29 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: use the actual AG length when reserving blocks
Message-ID: <20161220232828.GD9865@birch.djwong.org>
References: <20161217061920.GJ5357@birch.djwong.org>
 <20161220082000.GA14758@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161220082000.GA14758@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Dec 20, 2016 at 12:20:00AM -0800, Christoph Hellwig wrote:
> On Fri, Dec 16, 2016 at 10:19:20PM -0800, Darrick J. Wong wrote:
> > We need to use the actual AG length when making per-AG reservations,
> > since we could otherwise end up reserving more blocks out of the last
> > AG than there are actual blocks.
> > 
> > Complained-about-by: Brian Foster <bfoster@redhat.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag_resv.c        |    4 ++++
> >  fs/xfs/libxfs/xfs_refcount_btree.c |    9 ++++++---
> >  fs/xfs/libxfs/xfs_refcount_btree.h |    3 ++-
> >  fs/xfs/libxfs/xfs_rmap_btree.c     |   14 ++++++++------
> >  fs/xfs/libxfs/xfs_rmap_btree.h     |    3 ++-
> >  fs/xfs/xfs_fsops.c                 |   14 ++++++++++++++
> >  6 files changed, 36 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> > index e5ebc37..fac3430 100644
> > --- a/fs/xfs/libxfs/xfs_ag_resv.c
> > +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> > @@ -225,6 +225,7 @@ xfs_ag_resv_init(
> >  {
> >  	xfs_extlen_t			ask;
> >  	xfs_extlen_t			used;
> > +	xfs_extlen_t			reserved;
> >  	int				error = 0;
> >  
> >  	/* Create the metadata reservation. */
> > @@ -256,6 +257,9 @@ xfs_ag_resv_init(
> >  			goto out;
> >  	}
> >  
> > +	reserved = xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> > +		   xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->ar_reserved;
> > +	ASSERT(reserved <= pag->pagf_freeblks + pag->pagf_flcount);
> 
> This will create a warning for non-debug builds due to the unused
> reserved variable.
> 
> > +	/* Reserve 1% of the AG or enough for 1 block per record. */
> > +	*ask += pool_len = max(agblocks / 100,
> > +			xfs_rmapbt_max_size(mp, agblocks));
> >  	*used += tree_len;
> >  
> >  	return error;
> 
> pool_len is initialized but not used.
> 
> Otherwise this looks fine to me.

Ok, will respin patch.

> But while looking at this patch and my current minleft "project" I've
> started to wonder how the XFS_AG_RESV_METADATA reservations are
> supposed to work: they are reserved out of the fs-wide pool, but
> the user of XFS_AG_RESV_METADATA really needs a block in this particular
> AG.

For XFS_AG_RESV_METADATA, we hide enough free space in each AG to cover
the absolute maximum size that we're ever going to need for the refcount
btree, then deduct the sum of all AG reservations from the fs-wide pool.
There's nothing tying a transaction to any specific chunk of the per-AG
reservation; we simply reserve all blocks that we'll (hopefully) ever
need, and only let the allocator release them to callers possessing the
magic key^W^W^W^Wasking specifically for XFS_AG_RESV_METADATA blocks.
For the refcount btree this was only 0.3% of the AG space.

--D
