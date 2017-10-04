Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:56017 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750866AbdJDG3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 02:29:01 -0400
Date: Wed, 4 Oct 2017 17:28:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/25] xfs: scrub AGF and AGFL
Message-ID: <20171004062840.GC3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706331250.19351.3004733994525860282.stgit@magnolia>
 <20171004013148.GW3666@dastard>
 <20171004042140.GN6503@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004042140.GN6503@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 09:21:40PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 04, 2017 at 12:31:48PM +1100, Dave Chinner wrote:
> > On Tue, Oct 03, 2017 at 01:41:52PM -0700, Darrick J. Wong wrote:
> > > +/*
> > > + * Load as many of the AG headers and btree cursors as we can for an
> > > + * examination and cross-reference of an AG header.
> > > + */
> > > +int
> > > +xfs_scrub_load_ag_headers(
> > > +	struct xfs_scrub_context	*sc,
> > > +	xfs_agnumber_t			agno,
> > > +	unsigned int			type)
> > > +{
> > > +	struct xfs_mount		*mp = sc->mp;
> > > +	int				error;
> > > +
> > > +	ASSERT(type == XFS_SCRUB_TYPE_AGF || type == XFS_SCRUB_TYPE_AGFL);
> > > +	memset(&sc->sa, 0, sizeof(sc->sa));
> > > +	sc->sa.agno = agno;
> > > +
> > > +	error = xfs_scrub_load_ag_header(sc, XFS_AGI_DADDR(mp),
> > > +			&sc->sa.agi_bp, &xfs_agi_buf_ops, false);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	error = xfs_scrub_load_ag_header(sc, XFS_AGF_DADDR(mp),
> > > +			&sc->sa.agf_bp, &xfs_agf_buf_ops,
> > > +			type == XFS_SCRUB_TYPE_AGF);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	error = xfs_scrub_load_ag_header(sc, XFS_AGFL_DADDR(mp),
> > > +			&sc->sa.agfl_bp, &xfs_agfl_buf_ops,
> > > +			type == XFS_SCRUB_TYPE_AGFL);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	return 0;
> > > +}
> > 
> > This should probably be combined with xfs_scrub_ag_read_headers().
> > They essentially do the same thing, the only difference is the
> > "target" error reporting.
> 
> It's quite different -- this function ignores verifier errors for
> the two headers that don't match 'type'  In other words, if we're
> checking the AGF (for example) we'll try to grab the AGI and the AGFL.
> Verifier errors on the AGI/AGFL don't matter, but we /do/ want to hear
> the results if the AGF verifier fails.

What they do is quite different. The implementation is /almost/
identical. type is just an error masking variable and ....

> xfs_scrub_ag_read_headers on the other hand will fail if /any/ of the
> three verifiers fail. 

.... if no type is set, then we don't mask any errors at all and
we bail if any of the three verifiers fail. i.e.:

	error = xfs_ialloc_read_agi(mp, sc->tp, agno, agi);
	if (error && (!type || type == XFS_SCRUB_TYPE_AGI)
		return error;

        error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, agf);
	if (error && (!type || type == XFS_SCRUB_TYPE_AGF)
                return error;

        error = xfs_alloc_read_agfl(mp, sc->tp, agno, agfl);
	if (error && (!type || type == XFS_SCRUB_TYPE_AGFL)
                return error;

It's also much simpler to understand because we are using the proper
functions for reading these headers....

> The two functions /could/ be combined, though the 'type' test becomes
> trickier.  Maybe it'd be better just to enhance the comments for the two
> header loader functions to spell out how they differ in usage.

Again, I'd much prefer similar functionality is combined into
common helpers if it's simple enough to do...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
