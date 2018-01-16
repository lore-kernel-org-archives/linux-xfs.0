Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33886 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbeAPGzk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 01:55:40 -0500
Date: Mon, 15 Jan 2018 22:55:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 20/21] xfs: cross-reference the realtime bitmap
Message-ID: <20180116065536.GK5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398989544.18741.8012375240764840486.stgit@magnolia>
 <20180109212609.GO5602@magnolia>
 <20180116025746.GF16421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116025746.GF16421@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 01:57:46PM +1100, Dave Chinner wrote:
> On Tue, Jan 09, 2018 at 01:26:09PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > While we're scrubbing various btrees, cross-reference the records
> > with the other metadata.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: streamline scrubber arguments, remove stack allocated objects
> > ---
> >  fs/xfs/libxfs/xfs_rtbitmap.c |   30 ++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/bmap.c          |    3 +++
> >  fs/xfs/scrub/rtbitmap.c      |   20 ++++++++++++++++++++
> >  fs/xfs/scrub/scrub.h         |    6 ++++++
> >  fs/xfs/xfs_rtalloc.h         |    4 ++++
> >  5 files changed, 63 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> > index 3fb29a5..a3f25a2 100644
> > --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> > +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> > @@ -1097,3 +1097,33 @@ xfs_verify_rtbno(
> >  {
> >  	return rtbno < mp->m_sb.sb_rblocks;
> >  }
> > +
> > +/* Is the given extent all free? */
> > +int
> > +xfs_rtalloc_extent_is_free(
> > +	struct xfs_mount		*mp,
> > +	struct xfs_trans		*tp,
> > +	xfs_rtblock_t			start,
> > +	xfs_rtblock_t			len,
> 
> shouldn't that be a xfs_extlen_t?
> 
> > +	bool				*is_free)
> > +{
> > +	xfs_rtblock_t			end;
> > +	xfs_extlen_t			clen;
> 
> clen? Not sure what that is shorthand for.

Clamped length, and it ought to be xfs_extlen_t as you point out.

> 
> > +	int				matches;
> > +	int				error;
> > +
> > +	*is_free = false;
> > +	while (len) {
> > +		clen = len > ~0U ? ~0U : len;
> 
> So we're checking for a len > UINT_MAX and clamping it here because
> the rt code uses 32 bit extent lengths internally? If we actually
> need 64 bit extent lengths, then isn't using UINT_MAX more obvious
> as to the purpose? i.e
> 
> 	if (len > UINT_MAX)
> 		clen = UINT_MAX;
> 	else
> 		clen = len;

Yes.
> 
> > +		error = xfs_rtcheck_range(mp, tp, start, clen, 1, &end,
> > +				&matches);
> > +		if (error || !matches || end < start + clen)
> > +			return error;
> > +
> > +		len -= end - start;
> > +		start = end + 1;
> > +	}
> > +
> > +	*is_free = true;
> > +	return error;
> > +}
> > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > index 5c34e025..2908a1b 100644
> > --- a/fs/xfs/scrub/bmap.c
> > +++ b/fs/xfs/scrub/bmap.c
> > @@ -278,6 +278,9 @@ xfs_scrub_bmap_rt_extent_xref(
> >  {
> >  	if (info->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> >  		return;
> > +
> > +	xfs_scrub_xref_not_rtfree(info->sc, irec->br_startblock,
> > +			irec->br_blockcount);
> 
> So, irec->br_blockcount is a xfs_extlen, which is 32 bits....
> 
> >  }
> >  
> >  /* Cross-reference a single datadev extent record. */
> > diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> > index 6860d5d..1828b17 100644
> > --- a/fs/xfs/scrub/rtbitmap.c
> > +++ b/fs/xfs/scrub/rtbitmap.c
> > @@ -98,3 +98,23 @@ xfs_scrub_rtsummary(
> >  	/* XXX: implement this some day */
> >  	return -ENOENT;
> >  }
> > +
> > +
> > +/* xref check that the extent is not free in the rtbitmap */
> > +void
> > +xfs_scrub_xref_not_rtfree(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_fsblock_t			fsbno,
> > +	xfs_fsblock_t			len)
> 
> So we're quietly converting it to a 64 bit length here. ANd not even
> using xfs_rtblock_t as you'd expect for a realtime block...
> 
> What caller needs/uses a 64 bit extent length? All the rt allocation
> code uses xfs_extlen_t for lengths, so I'm a bit confused as to why
> it's needed here.

I think I confused myself when wandering through the rt code... will fix.

--D

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
