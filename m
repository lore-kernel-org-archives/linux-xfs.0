Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:25012 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750766AbdJLFs7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 01:48:59 -0400
Date: Thu, 12 Oct 2017 16:48:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/30] xfs: create block pointer check functions
Message-ID: <20171012054856.GR15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777245581.1724.14031376814151145502.stgit@magnolia>
 <20171012052852.GQ15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012052852.GQ15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2017 at 04:28:52PM +1100, Dave Chinner wrote:
> On Wed, Oct 11, 2017 at 06:40:55PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create some helper functions to check that a block pointer points
> > within the filesystem (or AG) and doesn't point at static metadata.
> > We will use this for scrub.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Look fine

now that I think about it and seen a bit more code....

> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c    |   49 ++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_alloc.h    |    4 +++
> >  fs/xfs/libxfs/xfs_rtbitmap.c |   12 ++++++++++
> >  fs/xfs/xfs_rtalloc.h         |    2 ++
> >  4 files changed, 67 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 744dcae..bd3a943 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2923,3 +2923,52 @@ xfs_alloc_query_all(
> >  	query.fn = fn;
> >  	return xfs_btree_query_all(cur, xfs_alloc_query_range_helper, &query);
> >  }
> > +
> > +/* Find the size of the AG, in blocks. */
> > +xfs_agblock_t
> > +xfs_ag_block_count(
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno)
> > +{
> > +	ASSERT(agno < mp->m_sb.sb_agcount);
> > +
> > +	if (agno < mp->m_sb.sb_agcount - 1)
> > +		return mp->m_sb.sb_agblocks;
> > +	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
> > +}
> > +
> > +/*
> > + * Verify that an AG block number pointer neither points outside the AG
> > + * nor points at static metadata.
> > + */
> > +bool
> > +xfs_verify_agbno_ptr(

You can probably drop the "_ptr" prefix from these because I don't
think we every try to check/validate the agbno/fsbno of the static
metadata....

Some of the code just reads a bit weird with the "_ptr" suffix
in it...

Still consider it reviewed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
