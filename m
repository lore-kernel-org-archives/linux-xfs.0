Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41574 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbeAIAhl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 19:37:41 -0500
Date: Mon, 8 Jan 2018 16:37:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/21] xfs: cross-reference bnobt records with cntbt
Message-ID: <20180109003736.GC5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398986464.18741.745289369411639057.stgit@magnolia>
 <20180108235525.GH16421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180108235525.GH16421@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 10:55:25AM +1100, Dave Chinner wrote:
> On Fri, Dec 22, 2017 at 04:44:24PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Scrub should make sure that each bnobt record has a corresponding
> > cntbt record.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/agheader.c |   26 ++++++++++++++++++++++++++
> >  fs/xfs/scrub/alloc.c    |   37 +++++++++++++++++++++++++++++++++++++
> >  2 files changed, 63 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index 3bb0f96..e87022f 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -444,6 +444,7 @@ xfs_scrub_agf_xref(
> >  	struct xfs_btree_cur		**pcur;
> >  	xfs_agblock_t			bno;
> >  	xfs_extlen_t			blocks;
> > +	int				have;
> >  	int				error;
> >  
> >  	bno = XFS_AGF_BLOCK(mp);
> > @@ -465,6 +466,31 @@ xfs_scrub_agf_xref(
> >  			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
> >  	}
> >  
> > +	/* Cross-reference with the cntbt. */
> > +	pcur = &sc->sa.cnt_cur;
> > +	while (*pcur) {
> > +		xfs_agblock_t		agbno;
> > +
> > +		/* Any freespace at all? */
> > +		error = xfs_alloc_lookup_le(*pcur, 0, -1U, &have);
> > +		if (!xfs_scrub_should_xref(sc, &error, pcur))
> > +			break;
> > +		if (!have) {
> > +			if (agf->agf_freeblks != be32_to_cpu(0))
> 
> No need to endian convert 0.

Fixed.

> > +				xfs_scrub_block_xref_set_corrupt(sc,
> > +						sc->sa.agf_bp);
> > +			break;
> > +		}
> > +
> > +		/* Check agf_longest */
> > +		error = xfs_alloc_get_rec(*pcur, &agbno, &blocks, &have);
> > +		if (!xfs_scrub_should_xref(sc, &error, pcur))
> > +			break;
> > +		if (!have || blocks != be32_to_cpu(agf->agf_longest))
> > +			xfs_scrub_block_xref_set_corrupt(sc, sc->sa.agf_bp);
> > +		break;
> > +	}
> 
> Why is this a while loop? It'll break out at the end of the first
> loop - did you forget to remove that last break statement?

Curious use of while loops to avoid having a goto dontcareaboutcntbt label.

Time to make this (and the other one) its own function....

--D

> > +
> >  	/* scrub teardown will take care of sc->sa for us */
> >  }
> >  
> > diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> > index 3d6f8cc..9a28e3d 100644
> > --- a/fs/xfs/scrub/alloc.c
> > +++ b/fs/xfs/scrub/alloc.c
> > @@ -31,6 +31,7 @@
> >  #include "xfs_sb.h"
> >  #include "xfs_alloc.h"
> >  #include "xfs_rmap.h"
> > +#include "xfs_alloc.h"
> >  #include "scrub/xfs_scrub.h"
> >  #include "scrub/scrub.h"
> >  #include "scrub/common.h"
> > @@ -57,6 +58,42 @@ xfs_scrub_allocbt_xref(
> >  	xfs_agblock_t			bno,
> >  	xfs_extlen_t			len)
> >  {
> > +	struct xfs_btree_cur		**pcur;
> > +	struct xfs_scrub_ag		*psa = &sc->sa;
> > +	xfs_agblock_t			fbno;
> > +	xfs_extlen_t			flen;
> > +	int				has_otherrec;
> > +	int				error;
> > +
> > +	/*
> > +	 * Ensure there's a corresponding cntbt/bnobt record matching
> > +	 * this bnobt/cntbt record, respectively.
> > +	 */
> > +	if (sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
> > +		pcur = &psa->cnt_cur;
> > +	else
> > +		pcur = &psa->bno_cur;
> > +	while (*pcur) {
> > +		error = xfs_alloc_lookup_le(*pcur, bno, len, &has_otherrec);
> > +		if (!xfs_scrub_should_xref(sc, &error, pcur))
> > +			break;
> > +		if (!has_otherrec) {
> > +			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
> > +			break;
> > +		}
> > +
> > +		error = xfs_alloc_get_rec(*pcur, &fbno, &flen, &has_otherrec);
> > +		if (!xfs_scrub_should_xref(sc, &error, pcur))
> > +			break;
> > +		if (!has_otherrec) {
> > +			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
> > +			break;
> > +		}
> > +
> > +		if (fbno != bno || flen != len)
> > +			xfs_scrub_btree_xref_set_corrupt(sc, *pcur, 0);
> > +		break;
> > +	}
> 
> Same again - I don't see why this is a while loop.
> 
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
