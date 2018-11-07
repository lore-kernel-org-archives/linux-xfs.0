Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54134 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbeKGNIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 08:08:49 -0500
Date: Tue, 6 Nov 2018 19:40:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/8] xfs: calculate inode cluster geometry once during
 inobt scrub
Message-ID: <20181107034014.GX4135@magnolia>
References: <154147728649.32496.4515247239602322709.stgit@magnolia>
 <154147729891.32496.12191035015614129432.stgit@magnolia>
 <20181106213218.GP19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106213218.GP19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 07, 2018 at 08:32:18AM +1100, Dave Chinner wrote:
> On Mon, Nov 05, 2018 at 08:08:18PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Hoist all the inode cluster geometry information into struct
> > xchk_iallocbt instead of recomputing them over and over.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/ialloc.c |   42 ++++++++++++++++++++++++++++--------------
> >  1 file changed, 28 insertions(+), 14 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > index 76ae8338a42e..3c12a0fe3b38 100644
> > --- a/fs/xfs/scrub/ialloc.c
> > +++ b/fs/xfs/scrub/ialloc.c
> > @@ -45,8 +45,18 @@ xchk_setup_ag_iallocbt(
> >  /* Inode btree scrubber. */
> >  
> >  struct xchk_iallocbt {
> > +	/* owner info for inode blocks */
> > +	struct xfs_owner_info	oinfo;
> > +
> >  	/* Number of inodes we see while scanning inobt. */
> >  	unsigned long long	inodes;
> > +
> > +	/* Blocks and inodes per inode cluster. */
> > +	unsigned int		blocks_per_cluster;
> > +	unsigned int		inodes_per_cluster;
> > +
> > +	/* Block alignment of inode clusters. */
> > +	unsigned int		cluster_align;
> >  };
> >  
> >  /*
> > @@ -189,32 +199,30 @@ xchk_iallocbt_check_cluster_freemask(
> >  STATIC int
> >  xchk_iallocbt_check_freemask(
> >  	struct xchk_btree		*bs,
> > +	struct xchk_iallocbt		*iabt,
> >  	struct xfs_inobt_rec_incore	*irec)
> >  {
> > -	struct xfs_owner_info		oinfo;
> >  	struct xfs_imap			imap;
> >  	struct xfs_mount		*mp = bs->cur->bc_mp;
> >  	struct xfs_dinode		*dip;
> >  	struct xfs_buf			*bp;
> >  	xfs_ino_t			fsino;
> > -	xfs_agino_t			nr_inodes;
> > +	unsigned int			nr_inodes;
> >  	xfs_agino_t			agino;
> >  	xfs_agino_t			chunkino;
> >  	xfs_agino_t			clusterino;
> >  	xfs_agblock_t			agbno;
> > -	int				blks_per_cluster;
> >  	uint16_t			holemask;
> >  	uint16_t			ir_holemask;
> >  	int				error = 0;
> >  
> >  	/* Make sure the freemask matches the inode records. */
> > -	blks_per_cluster = xfs_icluster_size_fsb(mp);
> > -	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
> > -	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
> > +	nr_inodes = min_t(unsigned int, iabt->inodes_per_cluster,
> > +			XFS_INODES_PER_CHUNK);
> 
> That's a bug fix not just a mechanical change, right? Can you either
> call it out in the commit message, or put it in a separate patch?

I'm pulling this into a separate patch.

> Apart from that, the patch is good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > @@ -440,9 +448,15 @@ xchk_iallocbt(
> >  	struct xfs_owner_info	oinfo;
> >  	struct xchk_iallocbt	iabt = {
> >  		.inodes		= 0,
> > +		.cluster_align	= xfs_ialloc_cluster_alignment(sc->mp),
> > +		.blocks_per_cluster = xfs_icluster_size_fsb(sc->mp),
> >  	};
> >  	int			error;
> >  
> > +	xfs_rmap_ag_owner(&iabt.oinfo, XFS_RMAP_OWN_INODES);
> > +	iabt.inodes_per_cluster = XFS_OFFBNO_TO_AGINO(sc->mp,
> > +			iabt.blocks_per_cluster, 0);
> 
> As an aside, this Seems like an obtuse way to calculate inodes per
> cluster. It is just:
> 
> 	inodes_per_cluster = blocks_per_cluster << mp->m_sb.sb_inopblog;
> 
> I guess that's exactly what the macro degenerates to, but there's
> lots of code with that exact open coded calculation for inodes per
> cluster.
> 
> /me wonders if we should just calculate these two values at mount
> time and stuff them in the struct xfs_mount...

FWIW I went with:

#define	XFS_FSB_TO_INO(mp,b)	(((b) << (mp)->m_sb.sb_inopblog))

and converted the existing XFS_OFFBNO_TO_AGINO(..., 0) callers to use
it.  I'll work on moving all that inode geometry stuff to a separate
structure, but that'll come after this series.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
