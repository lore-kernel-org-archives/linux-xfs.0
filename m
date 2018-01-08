Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56730 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752011AbeAIAJM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 19:09:12 -0500
Date: Mon, 8 Jan 2018 15:59:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/21] xfs: introduce scrubber cross-referencing stubs
Message-ID: <20180108235900.GA5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398985228.18741.6364419677377927534.stgit@magnolia>
 <20180108233640.GF16421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180108233640.GF16421@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 10:36:40AM +1100, Dave Chinner wrote:
> On Fri, Dec 22, 2017 at 04:44:12PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create some stubs that will be used to cross-reference metadata records.
> > The actual cross-referencing will be filled in by subsequent patches.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/agheader.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/scrub/alloc.c    |   14 ++++++++++
> >  fs/xfs/scrub/bmap.c     |   28 ++++++++++++++++++++
> >  fs/xfs/scrub/ialloc.c   |   17 ++++++++++++
> >  fs/xfs/scrub/inode.c    |   13 +++++++++
> >  fs/xfs/scrub/refcount.c |   15 +++++++++++
> >  fs/xfs/scrub/rmap.c     |   13 +++++++++
> >  7 files changed, 163 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index 97beb47..5be9059 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -37,7 +37,10 @@
> >  #include "scrub/common.h"
> >  #include "scrub/trace.h"
> >  
> > -/* Walk all the blocks in the AGFL. */
> > +/*
> > + * Walk all the blocks in the AGFL.  The fn function can return any negative
> > + * error code or XFS_BTREE_QUERY_RANGE_ABORT.
> > + */
> >  int
> >  xfs_scrub_walk_agfl(
> >  	struct xfs_scrub_context	*sc,
> > @@ -98,6 +101,14 @@ xfs_scrub_walk_agfl(
> >  
> >  /* Superblock */
> >  
> > +/* Cross-reference with the other btrees. */
> > +STATIC void
> > +xfs_scrub_superblock_xref(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_buf			*bp)
> > +{
> > +}
> > +
> >  /*
> >   * Scrub the filesystem superblock.
> >   *
> > @@ -386,11 +397,23 @@ xfs_scrub_superblock(
> >  			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))
> >  		xfs_scrub_block_set_corrupt(sc, bp);
> >  
> > +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > +		goto out;
> > +
> > +	xfs_scrub_superblock_xref(sc, bp);
> > +out:
> 
> I know this is just a set of stubs, but why isn't the "skip xref
> because it's already marked corrupt" check inside the xref
> functions?
> 
> That gets rid of all these gotos and makes the code simpler....

Done.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
