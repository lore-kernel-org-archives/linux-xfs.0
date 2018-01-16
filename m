Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43122 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbeAPU04 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 15:26:56 -0500
Date: Tue, 16 Jan 2018 12:26:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 19/21] xfs: cross-reference refcount btree during scrub
Message-ID: <20180116202652.GU5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398988926.18741.14757152372859283463.stgit@magnolia>
 <20180109212547.GN5602@magnolia>
 <20180116024447.GE16421@dastard>
 <20180116065244.GJ5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116065244.GJ5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 15, 2018 at 10:52:44PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 16, 2018 at 01:44:47PM +1100, Dave Chinner wrote:
> > On Tue, Jan 09, 2018 at 01:25:47PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > During metadata btree scrub, we should cross-reference with the
> > > reference counts.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v2: streamline scrubber arguments, remove stack allocated objects
> > > ---
> > 
> > ....
> > 
> > > +/* Make sure the refcount records match this data fork extent. */
> > > +STATIC void
> > > +xfs_scrub_bmap_xref_refcount_data(
> > > +	struct xfs_scrub_bmap_info	*info,
> > > +	struct xfs_bmbt_irec		*irec,
> > > +	xfs_fsblock_t			bno)
> > 
> > What's in the irec if it's not the block number of the extent we
> > are looking up?
> > 
> > Actually, I may have just answered that myself: bno is actually
> > an agbno, not an fsbno. So that should be:
> > 
> > 	xfs_agblock_t			agbno)
> 
> Er... Yes.  Oops, will fix (all of the agbno).
> > 
> > > +{
> > > +	xfs_agblock_t			fbno;
> > > +	xfs_extlen_t			flen;
> > > +	int				error;
> > > +
> > > +	if (!info->sc->sa.refc_cur)
> > > +		return;
> > > +
> > > +	/* If this is shared, the inode flag must be set. */
> > > +	error = xfs_refcount_find_shared(info->sc->sa.refc_cur, bno,
> > > +			irec->br_blockcount, &fbno, &flen, false);
> > > +	if (!xfs_scrub_should_check_xref(info->sc, &error,
> > > +			&info->sc->sa.refc_cur))
> > > +		return;
> > > +
> > > +	if (flen != 0 && !xfs_is_reflink_inode(info->sc->ip))
> > > +		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
> > > +				irec->br_startoff);
> > 
> > So is the block corrupt or is the inode flags corrupt? What
> > determines the object we mark as corrupt/needing fixing here?
> 
> Hmm.  The reflink iflag is broken here, because the iflag is only supposed
> to represent a shortcut for "might any of the data fork blocks shared?"
> Will change to the ino_xref_set_corrupt helper.

Thinking about these three functions a little more--

For the data fork, we only care that a non-reflink inode doesn't have shared
extents.

For the attr fork, we can call xfs_scrub_xref_is_not_shared directly.

For the cow fork, we can call xfs_scrub_xref_is_cow_staging directly.

The inode scrubber should be checking the reflink iflag, not the bmap
scrubber, so that should be refactored a bit too.

--D

> 
> --D
> 
> > > +/* Make sure the refcount records match this attr fork extent. */
> > > +STATIC void
> > > +xfs_scrub_bmap_xref_refcount_attr(
> > > +	struct xfs_scrub_bmap_info	*info,
> > > +	struct xfs_bmbt_irec		*irec,
> > > +	xfs_fsblock_t			bno)
> > 
> > agbno
> > 
> > > +{
> > > +	xfs_agblock_t			fbno;
> > > +	xfs_extlen_t			flen;
> > > +	int				error;
> > > +
> > > +	if (!info->sc->sa.refc_cur)
> > > +		return;
> > > +
> > > +	/* No shared attr fork extents */
> > > +	error = xfs_refcount_find_shared(info->sc->sa.refc_cur, bno,
> > > +			irec->br_blockcount, &fbno, &flen, false);
> > > +	if (!xfs_scrub_should_check_xref(info->sc, &error,
> > > +			&info->sc->sa.refc_cur))
> > > +		return;
> > > +
> > > +	if (flen != 0)
> > > +		xfs_scrub_fblock_xref_set_corrupt(info->sc, info->whichfork,
> > > +				irec->br_startoff);
> > > +}
> > > +
> > > +/* Make sure the refcount records match this CoW fork extent. */
> > > +STATIC void
> > > +xfs_scrub_bmap_xref_refcount_cow(
> > > +	struct xfs_scrub_bmap_info	*info,
> > > +	struct xfs_bmbt_irec		*irec,
> > > +	xfs_fsblock_t			bno)
> > 
> > agbno
> > 
> > > +{
> > > +	if (!info->sc->sa.refc_cur)
> > > +		return;
> > > +
> > > +	xfs_scrub_xref_has_cow_staging(info->sc, bno, irec->br_blockcount);
> > > +}
> > > +
> > >  /* Cross-reference a single rtdev extent record. */
> > >  STATIC void
> > >  xfs_scrub_bmap_rt_extent_xref(
> > > @@ -243,6 +309,17 @@ xfs_scrub_bmap_extent_xref(
> > >  	xfs_scrub_xref_is_used_space(info->sc, agbno, len);
> > >  	xfs_scrub_xref_not_inodes(info->sc, agbno, len);
> > >  	xfs_scrub_bmap_xref_rmap(info, irec, agbno);
> > > +	switch (info->whichfork) {
> > > +	case XFS_DATA_FORK:
> > > +		xfs_scrub_bmap_xref_refcount_data(info, irec, agbno);
> > > +		break;
> > > +	case XFS_ATTR_FORK:
> > > +		xfs_scrub_bmap_xref_refcount_attr(info, irec, agbno);
> > > +		break;
> > > +	case XFS_COW_FORK:
> > > +		xfs_scrub_bmap_xref_refcount_cow(info, irec, agbno);
> > > +		break;
> > 
> > This is where the agbno comes from :P
> > 
> > > +	}
> > >  
> > >  	xfs_scrub_ag_free(info->sc, &info->sc->sa);
> > >  }
> > > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > > index 30603b4..fb16314 100644
> > > --- a/fs/xfs/scrub/ialloc.c
> > > +++ b/fs/xfs/scrub/ialloc.c
> > > @@ -97,6 +97,7 @@ xfs_scrub_iallocbt_chunk_xref(
> > >  
> > >  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
> > >  	xfs_scrub_xref_owned_by(sc, agbno, len, &oinfo);
> > > +	xfs_scrub_xref_not_shared(sc, agbno, len);
> > >  }
> > >  
> > >  /* Is this chunk worth checking? */
> > > diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> > > index fc546f2..f12586c 100644
> > > --- a/fs/xfs/scrub/inode.c
> > > +++ b/fs/xfs/scrub/inode.c
> > > @@ -652,6 +652,7 @@ xfs_scrub_inode_xref(
> > >  	xfs_scrub_inode_xref_finobt(sc, ino);
> > >  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
> > >  	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
> > > +	xfs_scrub_xref_not_shared(sc, agbno, 1);
> > >  
> > >  	xfs_scrub_ag_free(sc, &sc->sa);
> > >  }
> > > diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> > > index df18e47..6e5b12a 100644
> > > --- a/fs/xfs/scrub/refcount.c
> > > +++ b/fs/xfs/scrub/refcount.c
> > > @@ -31,6 +31,7 @@
> > >  #include "xfs_sb.h"
> > >  #include "xfs_alloc.h"
> > >  #include "xfs_rmap.h"
> > > +#include "xfs_refcount.h"
> > >  #include "scrub/xfs_scrub.h"
> > >  #include "scrub/scrub.h"
> > >  #include "scrub/common.h"
> > > @@ -428,3 +429,67 @@ xfs_scrub_refcountbt(
> > >  
> > >  	return error;
> > >  }
> > > +
> > > +/* xref check that a cow staging extent is marked in the refcountbt. */
> > > +void
> > > +xfs_scrub_xref_has_cow_staging(
> > > +	struct xfs_scrub_context	*sc,
> > > +	xfs_agblock_t			bno,
> > 
> > agbno
> > 
> > > +	xfs_extlen_t			len)
> > > +{
> > > +	struct xfs_refcount_irec	rc;
> > > +	bool				has_cowflag;
> > > +	int				has_refcount;
> > > +	int				error;
> > .....
> > > +/*
> > > + * xref check that the extent is not shared.  Only file data blocks
> > > + * can have multiple owners.
> > > + */
> > > +void
> > > +xfs_scrub_xref_not_shared(
> > > +	struct xfs_scrub_context	*sc,
> > > +	xfs_agblock_t			bno,
> > 
> > agbno
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
