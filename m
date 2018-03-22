Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50418 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751674AbeCVRf0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 13:35:26 -0400
Date: Thu, 22 Mar 2018 10:35:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 5/9] xfs: bmap scrubber should do rmap xref with bmap
 for sparse files
Message-ID: <20180322173520.GX4818@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <152107380082.19571.10988218532838802248.stgit@magnolia>
 <20180322060218.GR4818@magnolia>
 <20180322143357.GC16617@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180322143357.GC16617@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 22, 2018 at 10:33:58AM -0400, Brian Foster wrote:
> On Wed, Mar 21, 2018 at 11:02:18PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're scanning an extent mapping inode fork, ensure that every rmap
> > record for this ifork has a corresponding bmbt record too.  This
> > (mostly) provides the ability to cross-reference rmap records with bmap
> > data.  The rmap scrubber cannot do the xref on its own because that
> > requires taking an ilock with the agf lock held, which violates our
> > locking order rules (inode, then agf).
> > 
> > Note that we only do this for forks that are in btree format due to the
> > increased complexity; or forks that should have data but suspiciously
> > have zero extents because the inode could have just had its iforks
> > zapped by the inode repair code and now we need to reclaim the old
> > extents.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: enhance comments, fix XFS_BTREE_ERROR usage
> > ---
> >  fs/xfs/scrub/bmap.c |  170 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 169 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > index d002821..75ea2d6 100644
> > --- a/fs/xfs/scrub/bmap.c
> > +++ b/fs/xfs/scrub/bmap.c
> > @@ -37,6 +37,7 @@
> >  #include "xfs_bmap_util.h"
> >  #include "xfs_bmap_btree.h"
> >  #include "xfs_rmap.h"
> > +#include "xfs_rmap_btree.h"
> >  #include "xfs_refcount.h"
> >  #include "scrub/xfs_scrub.h"
> >  #include "scrub/scrub.h"
> > @@ -423,6 +424,169 @@ xfs_scrub_bmap_btree(
> >  	return error;
> >  }
> >  
> ...
> > +/* Make sure each rmap has a corresponding bmbt entry. */
> > +STATIC int
> > +xfs_scrub_bmap_check_ag_rmaps(
> > +	struct xfs_scrub_context	*sc,
> > +	int				whichfork,
> > +	xfs_agnumber_t			agno)
> > +{
> > +	struct xfs_scrub_bmap_check_rmap_info	sbcri;
> > +	struct xfs_btree_cur		*cur;
> > +	struct xfs_buf			*agf;
> > +	int				error;
> > +
> > +	error = xfs_alloc_read_agf(sc->mp, sc->tp, agno, 0, &agf);
> > +	if (error)
> > +		return error;
> > +
> > +	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, agno);
> > +	if (!cur) {
> > +		error = -ENOMEM;
> > +		goto out_agf;
> > +	}
> > +
> > +	sbcri.sc = sc;
> > +	sbcri.whichfork = whichfork;
> > +	error = xfs_rmap_query_all(cur, xfs_scrub_bmap_check_rmap, &sbcri);
> > +	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
> > +		error = 0;
> > +
> > +	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> 
> So I assume it's intentional that we don't care about _QUERY_RANGE_ABORT
> here? Otherwise looks fine.

Yes.  The only difference between XFS_BTREE_ERROR and XFS_BTREE_NOERROR
is that _ERROR forces _del_cursor to scan every bc_bufs entry for
buffers to release, whereas _NOERROR stops after the first NULL it finds
while going from level 0 to level n.  I've had half a mind to remove
that parameter since it clutters up the callsites and most of the time
all the btree pointers fit in a single cacheline.

That said, the btree query_range/query_all functions only return
_QUERY_RANGE_ABORT if the helper function (i.e. xfs_scrub_bmap_check_rmap)
returns _ABORT.  The helper only gets called if we find a record in the
btree which means that we can use _NOERROR since bc_bufs[0] is set.

--D

> Brian
> 
> > +out_agf:
> > +	xfs_trans_brelse(sc->tp, agf);
> > +	return error;
> > +}
> > +
> > +/* Make sure each rmap has a corresponding bmbt entry. */
> > +STATIC int
> > +xfs_scrub_bmap_check_rmaps(
> > +	struct xfs_scrub_context	*sc,
> > +	int				whichfork)
> > +{
> > +	loff_t				size;
> > +	xfs_agnumber_t			agno;
> > +	int				error;
> > +
> > +	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb) ||
> > +	    whichfork == XFS_COW_FORK ||
> > +	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> > +		return 0;
> > +
> > +	/* Don't support realtime rmap checks yet. */
> > +	if (XFS_IS_REALTIME_INODE(sc->ip) && whichfork == XFS_DATA_FORK)
> > +		return 0;
> > +
> > +	/*
> > +	 * Only do this for complex maps that are in btree format, or for
> > +	 * situations where we would seem to have a size but zero extents.
> > +	 * The inode repair code can zap broken iforks, which means we have
> > +	 * to flag this bmap as corrupt if there are rmaps that need to be
> > +	 * reattached.
> > +	 */
> > +	switch (whichfork) {
> > +	case XFS_DATA_FORK:
> > +		size = i_size_read(VFS_I(sc->ip));
> > +		break;
> > +	case XFS_ATTR_FORK:
> > +		size = XFS_IFORK_Q(sc->ip);
> > +		break;
> > +	default:
> > +		size = 0;
> > +		break;
> > +	}
> > +	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE &&
> > +	    (size == 0 || XFS_IFORK_NEXTENTS(sc->ip, whichfork) > 0))
> > +		return 0;
> > +
> > +	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
> > +		error = xfs_scrub_bmap_check_ag_rmaps(sc, whichfork, agno);
> > +		if (error)
> > +			return error;
> > +		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > +			break;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Scrub an inode fork's block mappings.
> >   *
> > @@ -463,7 +627,7 @@ xfs_scrub_bmap(
> >  		break;
> >  	case XFS_ATTR_FORK:
> >  		if (!ifp)
> > -			goto out;
> > +			goto out_check_rmap;
> >  		if (!xfs_sb_version_hasattr(&mp->m_sb) &&
> >  		    !xfs_sb_version_hasattr2(&mp->m_sb))
> >  			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino, NULL);
> > @@ -534,6 +698,10 @@ xfs_scrub_bmap(
> >  			goto out;
> >  	}
> >  
> > +out_check_rmap:
> > +	error = xfs_scrub_bmap_check_rmaps(sc, whichfork);
> > +	if (!xfs_scrub_fblock_xref_process_error(sc, whichfork, 0, &error))
> > +		goto out;
> >  out:
> >  	return error;
> >  }
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
