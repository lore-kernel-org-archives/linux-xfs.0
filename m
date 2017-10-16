Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27028 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755727AbdJPTqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 15:46:30 -0400
Date: Mon, 16 Oct 2017 12:46:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/30] xfs: create block pointer check functions
Message-ID: <20171016194625.GF4703@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777245581.1724.14031376814151145502.stgit@magnolia>
 <20171012052852.GQ15067@dastard>
 <20171012054856.GR15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012054856.GR15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2017 at 04:48:56PM +1100, Dave Chinner wrote:
> On Thu, Oct 12, 2017 at 04:28:52PM +1100, Dave Chinner wrote:
> > On Wed, Oct 11, 2017 at 06:40:55PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Create some helper functions to check that a block pointer points
> > > within the filesystem (or AG) and doesn't point at static metadata.
> > > We will use this for scrub.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Look fine
> 
> now that I think about it and seen a bit more code....
> 
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > 
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c    |   49 ++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_alloc.h    |    4 +++
> > >  fs/xfs/libxfs/xfs_rtbitmap.c |   12 ++++++++++
> > >  fs/xfs/xfs_rtalloc.h         |    2 ++
> > >  4 files changed, 67 insertions(+)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index 744dcae..bd3a943 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -2923,3 +2923,52 @@ xfs_alloc_query_all(
> > >  	query.fn = fn;
> > >  	return xfs_btree_query_all(cur, xfs_alloc_query_range_helper, &query);
> > >  }
> > > +
> > > +/* Find the size of the AG, in blocks. */
> > > +xfs_agblock_t
> > > +xfs_ag_block_count(
> > > +	struct xfs_mount	*mp,
> > > +	xfs_agnumber_t		agno)
> > > +{
> > > +	ASSERT(agno < mp->m_sb.sb_agcount);
> > > +
> > > +	if (agno < mp->m_sb.sb_agcount - 1)
> > > +		return mp->m_sb.sb_agblocks;
> > > +	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
> > > +}
> > > +
> > > +/*
> > > + * Verify that an AG block number pointer neither points outside the AG
> > > + * nor points at static metadata.
> > > + */
> > > +bool
> > > +xfs_verify_agbno_ptr(
> 
> You can probably drop the "_ptr" prefix from these because I don't
> think we every try to check/validate the agbno/fsbno of the static
> metadata....
> 
> Some of the code just reads a bit weird with the "_ptr" suffix
> in it...

I wrangled with the name for a while too -- a generic block number could
refer to any part of the AG, whereas a block number in a metadata
structure is a pointer and should never point to static metadata, hence
the _ptr suffix.  On the other hand, some of the block pointers can be
NULL{FS,AG}BLOCK and others can't, and we don't check that here so it's
not quite a pointer check either.

Meh.

xfs_verify_agbno() it is.  Anyone reading the comments will figure out
why xfs_verify_agbno(mp, agno, XFS_AGFL_BLOCK(mp)) == false.

> Still consider it reviewed....

Ok.

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
