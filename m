Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfAIQhv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Jan 2019 11:37:51 -0500
Date: Wed, 9 Jan 2019 08:37:44 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/7] xfs: check the ir_startino alignment directly
Message-ID: <20190109163744.GX12689@magnolia>
References: <154697955494.2494.5221420762912855354.stgit@magnolia>
 <154697956749.2494.10156686086778734160.stgit@magnolia>
 <20190109133226.GA13613@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190109133226.GA13613@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 09, 2019 at 08:32:26AM -0500, Brian Foster wrote:
> On Tue, Jan 08, 2019 at 12:32:47PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xchk_iallocbt_rec, check the alignment of ir_startino by converting
> > the inode cluster block alignment into units of inodes instead of the
> > other way around (converting ir_startino to blocks).  This prevents us
> > from tripping over off-by-one errors in ir_startino which are obscured
> > by the inode -> block conversion.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/ialloc.c |   56 ++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 50 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > index fd431682db0b..1c6fef9b3799 100644
> > --- a/fs/xfs/scrub/ialloc.c
> > +++ b/fs/xfs/scrub/ialloc.c
> > @@ -265,6 +265,53 @@ xchk_iallocbt_check_freemask(
> >  	return error;
> >  }
> >  
> > +/*
> > + * Make sure this inode btree record is aligned properly.  Because a fs block
> > + * contains multiple inodes, we check that the inobt record is aligned to the
> > + * correct inode, not just the correct block on disk.  This results in a finer
> > + * grained corruption check.
> > + */
> > +STATIC void
> > +xchk_iallocbt_rec_alignment(
> > +	struct xchk_btree		*bs,
> > +	struct xfs_inobt_rec_incore	*irec)
> > +{
> > +	struct xfs_mount		*mp = bs->sc->mp;
> > +
> > +	/*
> > +	 * finobt records have different positioning requirements than inobt
> > +	 * records: each finobt record must have a corresponding inobt record.
> > +	 * That is checked in the xref function, so for now we only catch the
> > +	 * obvious case where the record isn't at all aligned properly.
> > +	 *
> > +	 * Note that if a fs block contains more than a single chunk of inodes,
> > +	 * we will have finobt records only for those chunks containing free
> > +	 * inodes, and therefore expect chunk alignment of finobt records.
> > +	 * Otherwise, we expect that the finobt record is aligned to the
> > +	 * cluster alignment as told by the superblock.
> > +	 */
> > +	if (bs->cur->bc_btnum == XFS_BTNUM_FINO) {
> > +		unsigned int	imask;
> > +
> > +		imask = min_t(unsigned int, XFS_INODES_PER_CHUNK,
> > +				mp->m_cluster_align_inodes) - 1;
> > +		if (irec->ir_startino & imask)
> > +			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> > +		return;
> > +	}
> > +
> 
> Don't we also need this large FSB alignment fixup for inobt records, or
> am I still confused? :/ I.e., if ->m_cluster_align_inodes is 128 and
> irec is the second inobt record in a block..

The logic added in the next patch checks that either an inobt record is
aligned to m_cluster_align_inodes, or that the record covers inodes that
are immediately after the previous inobt record.  In theory that should
fix our handling of the large FSB case, though I've only tested it on
qemu arm boxen.

--D

> Brian
> 
> > +	/* inobt records must be aligned to cluster and inoalignmnt size. */
> > +	if (irec->ir_startino & (mp->m_cluster_align_inodes - 1)) {
> > +		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> > +		return;
> > +	}
> > +
> > +	if (irec->ir_startino & (mp->m_inodes_per_cluster - 1)) {
> > +		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> > +		return;
> > +	}
> > +}
> > +
> >  /* Scrub an inobt/finobt record. */
> >  STATIC int
> >  xchk_iallocbt_rec(
> > @@ -277,7 +324,6 @@ xchk_iallocbt_rec(
> >  	uint64_t			holes;
> >  	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
> >  	xfs_agino_t			agino;
> > -	xfs_agblock_t			agbno;
> >  	xfs_extlen_t			len;
> >  	int				holecount;
> >  	int				i;
> > @@ -304,11 +350,9 @@ xchk_iallocbt_rec(
> >  		goto out;
> >  	}
> >  
> > -	/* Make sure this record is aligned to cluster and inoalignmnt size. */
> > -	agbno = XFS_AGINO_TO_AGBNO(mp, irec.ir_startino);
> > -	if ((agbno & (mp->m_cluster_align - 1)) ||
> > -	    (agbno & (mp->m_blocks_per_cluster - 1)))
> > -		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> > +	xchk_iallocbt_rec_alignment(bs, &irec);
> > +	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > +		goto out;
> >  
> >  	iabt->inodes += irec.ir_count;
> >  
> > 
