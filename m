Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38920 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdJDEVp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 00:21:45 -0400
Date: Tue, 3 Oct 2017 21:21:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/25] xfs: scrub AGF and AGFL
Message-ID: <20171004042140.GN6503@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706331250.19351.3004733994525860282.stgit@magnolia>
 <20171004013148.GW3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004013148.GW3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2017 at 12:31:48PM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 01:41:52PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Check the block references in the AGF and AGFL headers to make sure
> > they make sense.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_fs.h  |    4 +
> >  fs/xfs/scrub/agheader.c |  220 +++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/common.c   |   60 +++++++++++++
> >  fs/xfs/scrub/common.h   |    6 +
> >  fs/xfs/scrub/scrub.c    |    8 ++
> >  fs/xfs/scrub/scrub.h    |    2 
> >  6 files changed, 299 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 8543cbb..aeb2a66 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -485,9 +485,11 @@ struct xfs_scrub_metadata {
> >  /* Scrub subcommands. */
> >  #define XFS_SCRUB_TYPE_PROBE	0	/* presence test ioctl */
> >  #define XFS_SCRUB_TYPE_SB	1	/* superblock */
> > +#define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
> > +#define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
> >  
> >  /* Number of scrub subcommands. */
> > -#define XFS_SCRUB_TYPE_NR	2
> > +#define XFS_SCRUB_TYPE_NR	4
> >  
> >  /* i: Repair this metadata. */
> >  #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index 487c4f4..7fe6630 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -49,6 +49,72 @@ xfs_scrub_setup_ag_header(
> >  	return xfs_scrub_setup_fs(sc, ip);
> >  }
> >  
> > +/* Find the size of the AG, in blocks. */
> > +static inline xfs_agblock_t
> > +xfs_scrub_ag_blocks(
> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno)
> > +{
> > +	ASSERT(agno < mp->m_sb.sb_agcount);
> > +
> > +	if (agno < mp->m_sb.sb_agcount - 1)
> > +		return mp->m_sb.sb_agblocks;
> > +	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
> > +}
> 
> Can you make this a generic libxfs function, say xfs_get_ag_blocks()?
> This same calculation is repeated in quite a few places, especially
> in userspace...

Ok.

> > +
> > +/* Walk all the blocks in the AGFL. */
> > +int
> > +xfs_scrub_walk_agfl(
> > +	struct xfs_scrub_context	*sc,
> > +	int				(*fn)(struct xfs_scrub_context *,
> > +					      xfs_agblock_t bno, void *),
> > +	void				*priv)
> > +{
> > +	struct xfs_agf			*agf;
> > +	__be32				*agfl_bno;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	unsigned int			flfirst;
> > +	unsigned int			fllast;
> > +	int				i;
> > +	int				error;
> > +
> > +	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> > +	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, sc->sa.agfl_bp);
> > +	flfirst = be32_to_cpu(agf->agf_flfirst);
> > +	fllast = be32_to_cpu(agf->agf_fllast);
> > +
> > +	/* Skip an empty AGFL. */
> > +	if (agf->agf_flcount == cpu_to_be32(0))
> > +		return 0;
> 
> Check flfirst -> fllast == flcount.

<nod>

> ....
> 
> > +/* Scrub the AGF. */
> > +int
> > +xfs_scrub_agf(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_agf			*agf;
> > +	xfs_daddr_t			daddr;
> > +	xfs_daddr_t			eofs;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agblock_t			agbno;
> > +	xfs_agblock_t			eoag;
> > +	xfs_agblock_t			agfl_first;
> > +	xfs_agblock_t			agfl_last;
> > +	xfs_agblock_t			agfl_count;
> > +	xfs_agblock_t			fl_count;
> > +	int				level;
> > +	int				error = 0;
> > +
> > +	agno = sc->sm->sm_agno;
> > +	error = xfs_scrub_load_ag_headers(sc, agno, XFS_SCRUB_TYPE_AGF);
> > +	if (!xfs_scrub_op_ok(sc, agno, XFS_AGF_BLOCK(sc->mp), &error))
> > +		goto out;
> > +
> > +	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> > +	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
> > +
> > +	/* Check the AG length */
> > +	eoag = be32_to_cpu(agf->agf_length);
> > +	if (eoag != xfs_scrub_ag_blocks(mp, agno))
> > +		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
> > +
> > +	/* Check the AGF btree roots and levels */
> > +	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
> > +	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
> > +	if (agbno <= XFS_AGI_BLOCK(mp) || agbno >= mp->m_sb.sb_agblocks ||
> 
> I'm assuming that you are checking that the block isn't part of the
> static metadata range with this XFS_AGI_BLOCK() check? Shouldn't it
> actually be agbno <= XFS_AGFL_BLOCK(mp) i.e. the AGFL block address?

D'oh! Yes.

> I think we need a generic "verify agbno" function. These checks seem
> to be open coded throughout the code instead calling a single
> function that does all the checks. The short btree pointers can use
> it as well...
> 
> > +	    agbno >= eoag || daddr >= eofs)
> > +		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
> > +
> > +	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
> > +	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
> > +	if (agbno <= XFS_AGI_BLOCK(mp) || agbno >= mp->m_sb.sb_agblocks ||
> > +	    agbno >= eoag || daddr >= eofs)
> 
> There's another.
> 
> > +		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
> > +
> > +	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
> > +	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> > +		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
> > +
> > +	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
> > +	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> > +		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
> > +
> > +	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > +		agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
> > +		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
> > +		if (agbno <= XFS_AGI_BLOCK(mp) ||
> > +		    agbno >= mp->m_sb.sb_agblocks ||
> > +		    agbno >= eoag ||
> > +		    daddr >= eofs)
> 
> And another.
> 
> > +			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
> > +
> > +		level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
> > +		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> > +			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
> > +	}
> > +
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > +		agbno = be32_to_cpu(agf->agf_refcount_root);
> > +		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
> > +		if (agbno <= XFS_AGI_BLOCK(mp) ||
> > +		    agbno >= mp->m_sb.sb_agblocks ||
> > +		    agbno >= eoag ||
> > +		    daddr >= eofs)
> 
> And another.

Yes I see your point, I'll add some helpers to check that something
hasn't gone off the end of the AG or the FS.

> > +			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
> > +
> > +		level = be32_to_cpu(agf->agf_refcount_level);
> > +		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> > +			xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
> > +	}
> > +
> > +	/* Check the AGFL counters */
> > +	agfl_first = be32_to_cpu(agf->agf_flfirst);
> > +	agfl_last = be32_to_cpu(agf->agf_fllast);
> > +	agfl_count = be32_to_cpu(agf->agf_flcount);
> > +	if (agfl_last > agfl_first)
> > +		fl_count = agfl_last - agfl_first + 1;
> > +	else
> > +		fl_count = XFS_AGFL_SIZE(mp) - agfl_first + agfl_last + 1;
> > +	if (agfl_count != 0 && fl_count != agfl_count)
> > +		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
> 
> Oh, the agfl counts are checked here. Maybe put a comment in
> xfs_scrub_walk_agfl() to mention this?

Ok.

> 
> .....
> 
> > +struct xfs_scrub_agfl {
> > +	xfs_agblock_t			eoag;
> > +	xfs_daddr_t			eofs;
> > +};
> > +
> > +/* Scrub an AGFL block. */
> > +STATIC int
> > +xfs_scrub_agfl_block(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_agblock_t			agbno,
> > +	void				*priv)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	xfs_agnumber_t			agno = sc->sa.agno;
> > +	struct xfs_scrub_agfl		*sagfl = priv;
> > +	int				error = 0;
> > +
> > +	if (agbno <= XFS_AGI_BLOCK(mp) ||
> > +	    agbno >= mp->m_sb.sb_agblocks ||
> > +	    agbno >= sagfl->eoag ||
> > +	    XFS_AGB_TO_DADDR(mp, agno, agbno) >= sagfl->eofs)
> > +		xfs_scrub_block_set_corrupt(sc, sc->sa.agfl_bp);
> > +
> > +	return error;
> > +}
> 
> Oh, look, there's another xfs_agbno_verify() function call :P
> 
> .....
> > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > index b056c9d..ee8e7be 100644
> > --- a/fs/xfs/scrub/common.c
> > +++ b/fs/xfs/scrub/common.c
> > @@ -471,6 +471,66 @@ xfs_scrub_ag_init(
> >  	return xfs_scrub_ag_btcur_init(sc, sa);
> >  }
> >  
> > +/*
> > + * Load and verify an AG header for further AG header examination.
> > + * If this header is not the target of the examination, don't return
> > + * the buffer if a runtime or verifier error occurs.
> > + */
> > +STATIC int
> > +xfs_scrub_load_ag_header(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_daddr_t			daddr,
> > +	struct xfs_buf			**bpp,
> > +	const struct xfs_buf_ops	*ops,
> > +	bool				is_target)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	int				error;
> > +
> > +	*bpp = NULL;
> > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > +			XFS_AG_DADDR(mp, sc->sa.agno, daddr),
> > +			XFS_FSS_TO_BB(mp, 1), 0, bpp, ops);
> > +	return is_target ? error : 0;
> > +}
> > +
> > +/*
> > + * Load as many of the AG headers and btree cursors as we can for an
> > + * examination and cross-reference of an AG header.
> > + */
> > +int
> > +xfs_scrub_load_ag_headers(
> > +	struct xfs_scrub_context	*sc,
> > +	xfs_agnumber_t			agno,
> > +	unsigned int			type)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	int				error;
> > +
> > +	ASSERT(type == XFS_SCRUB_TYPE_AGF || type == XFS_SCRUB_TYPE_AGFL);
> > +	memset(&sc->sa, 0, sizeof(sc->sa));
> > +	sc->sa.agno = agno;
> > +
> > +	error = xfs_scrub_load_ag_header(sc, XFS_AGI_DADDR(mp),
> > +			&sc->sa.agi_bp, &xfs_agi_buf_ops, false);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfs_scrub_load_ag_header(sc, XFS_AGF_DADDR(mp),
> > +			&sc->sa.agf_bp, &xfs_agf_buf_ops,
> > +			type == XFS_SCRUB_TYPE_AGF);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfs_scrub_load_ag_header(sc, XFS_AGFL_DADDR(mp),
> > +			&sc->sa.agfl_bp, &xfs_agfl_buf_ops,
> > +			type == XFS_SCRUB_TYPE_AGFL);
> > +	if (error)
> > +		return error;
> > +
> > +	return 0;
> > +}
> 
> This should probably be combined with xfs_scrub_ag_read_headers().
> They essentially do the same thing, the only difference is the
> "target" error reporting.

It's quite different -- this function ignores verifier errors for
the two headers that don't match 'type'  In other words, if we're
checking the AGF (for example) we'll try to grab the AGI and the AGFL.
Verifier errors on the AGI/AGFL don't matter, but we /do/ want to hear
the results if the AGF verifier fails.

xfs_scrub_ag_read_headers on the other hand will fail if /any/ of the
three verifiers fail.  We want this behavior for the btree scrubbers so
that we can bail out with an operational error if the headers are bad,
but we don't want this behavior for the header scrubbers because an AGI
verifier error can cause the AGF verifier to report corruption.

Later on, repair will want the perag stuff loaded (which
xfs_scrub_load_ag_headers doesn't do), fwiw.

The two functions /could/ be combined, though the 'type' test becomes
trickier.  Maybe it'd be better just to enhance the comments for the two
header loader functions to spell out how they differ in usage.

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
