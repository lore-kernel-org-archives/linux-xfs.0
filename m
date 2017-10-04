Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19928 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdJDSCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 14:02:08 -0400
Date: Wed, 4 Oct 2017 11:02:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/25] xfs: scrub the AGI
Message-ID: <20171004180204.GU6503@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706331918.19351.1010060377239825093.stgit@magnolia>
 <20171004014347.GX3666@dastard>
 <20171004042501.GO6503@magnolia>
 <20171004064333.GD3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004064333.GD3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2017 at 05:43:33PM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 09:25:01PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 04, 2017 at 12:43:47PM +1100, Dave Chinner wrote:
> > > On Tue, Oct 03, 2017 at 01:41:59PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Add a forgotten check to the AGI verifier, then wire up the scrub
> > > > infrastructure to check the AGI contents.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_fs.h  |    3 +-
> > > >  fs/xfs/scrub/agheader.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/scrub/common.c   |    6 ++-
> > > >  fs/xfs/scrub/scrub.c    |    4 ++
> > > >  fs/xfs/scrub/scrub.h    |    1 +
> > > >  5 files changed, 99 insertions(+), 3 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > > > index aeb2a66..1e326dd 100644
> > > > --- a/fs/xfs/libxfs/xfs_fs.h
> > > > +++ b/fs/xfs/libxfs/xfs_fs.h
> > > > @@ -487,9 +487,10 @@ struct xfs_scrub_metadata {
> > > >  #define XFS_SCRUB_TYPE_SB	1	/* superblock */
> > > >  #define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
> > > >  #define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
> > > > +#define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
> > > >  
> > > >  /* Number of scrub subcommands. */
> > > > -#define XFS_SCRUB_TYPE_NR	4
> > > > +#define XFS_SCRUB_TYPE_NR	5
> > > >  
> > > >  /* i: Repair this metadata. */
> > > >  #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
> > > > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > > > index 7fe6630..3d269c2 100644
> > > > --- a/fs/xfs/scrub/agheader.c
> > > > +++ b/fs/xfs/scrub/agheader.c
> > > > @@ -535,3 +535,91 @@ xfs_scrub_agfl(
> > > >  out:
> > > >  	return error;
> > > >  }
> > > > +
> > > > +/* AGI */
> > > > +
> > > > +/* Scrub the AGI. */
> > > > +int
> > > > +xfs_scrub_agi(
> > > > +	struct xfs_scrub_context	*sc)
> > > > +{
> > > > +	struct xfs_mount		*mp = sc->mp;
> > > > +	struct xfs_agi			*agi;
> > > > +	xfs_daddr_t			daddr;
> > > > +	xfs_daddr_t			eofs;
> > > > +	xfs_agnumber_t			agno;
> > > > +	xfs_agblock_t			agbno;
> > > > +	xfs_agblock_t			eoag;
> > > > +	xfs_agino_t			agino;
> > > > +	xfs_agino_t			first_agino;
> > > > +	xfs_agino_t			last_agino;
> > > > +	int				i;
> > > > +	int				level;
> > > > +	int				error = 0;
> > > > +
> > > > +	agno = sc->sm->sm_agno;
> > > > +	error = xfs_scrub_load_ag_headers(sc, agno, XFS_SCRUB_TYPE_AGI);
> > > > +	if (!xfs_scrub_op_ok(sc, agno, XFS_AGI_BLOCK(sc->mp), &error))
> > > > +		goto out;
> > > > +
> > > > +	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
> > > > +	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
> > > > +
> > > > +	/* Check the AG length */
> > > > +	eoag = be32_to_cpu(agi->agi_length);
> > > > +	if (eoag != xfs_scrub_ag_blocks(mp, agno))
> > > > +		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
> > > 
> > > Should we be cross checking that the AGI and AGF both have
> > > the same length here?
> > 
> > Isn't that what this does?  Albeit indirectly?
> 
> I was kinda thinking of explicit checks, but you are right, it's
> indirectly verified....
> 
> > xfs_scrub_ag_blocks returns sb_agcount for every AG except the last one.
> > For the last AG it returns (sb_dblocks - (all blocks in the other AGs))
> > which should be the same as agf->agf_length, right?
> 
> ... which assumes we've validated sb_agblocks and sb_dblocks in some
> way, which we haven't really done in the superblock scrubber.

Yes.

> It seems to me that we're using the superblock 0 values as the
> golden master because it's a mounted filesystem, and then comparing
> everything else against it. Maybe we should at least check a couple
> of secondary superblocks to see that they match the primary
> superblock - that way we'll have some confidence that at least
> things like agcount, agblocks, dblocks, etc are valid before we go
> any further...

xfs_scrub_superblock does check the secondary superblock geometry
against whatever's in mp->m_sb, which came from sb 0.

> BUt maybe all we need is comment in the overall scrub description -
> that we're pretty much assuming that sb 0 is intact because we write
> what is in memory back to it and so we can simply validate
> everything else against the primary superblock contents...

Correct.  Since scrub is run against a mounted live filesystem we assume
that the mount code fully validated sb 0 and therefore we can rely on it
not being wrong.

If OTOH sb 0 *is* wrong then the admin is better off running xfs_repair
because there's too much whirring machinery to go changing fundamental
geometry.

Ok more comments are coming.

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
