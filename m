Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbfAGNpd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jan 2019 08:45:33 -0500
Date: Mon, 7 Jan 2019 08:45:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/8] xfs: check the ir_startino alignment directly
Message-ID: <20190107134530.GA2853@bfoster>
References: <154630850739.14372.14000129432637481206.stgit@magnolia>
 <154630851978.14372.12986942629611980027.stgit@magnolia>
 <20190104183104.GD16751@bfoster>
 <20190104205906.GB12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104205906.GB12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 04, 2019 at 12:59:06PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 04, 2019 at 01:31:04PM -0500, Brian Foster wrote:
> > On Mon, Dec 31, 2018 at 06:08:39PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > In xchk_iallocbt_rec, check the alignment of ir_startino by converting
> > > the inode cluster block alignment into units of inodes instead of the
> > > other way around (converting ir_startino to blocks).  This prevents us
> > > from tripping over off-by-one errors in ir_startino which are obscured
> > > by the inode -> block conversion.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/scrub/ialloc.c |   45 +++++++++++++++++++++++++++++++++++++++------
> > >  1 file changed, 39 insertions(+), 6 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > > index fd431682db0b..5082331d6c03 100644
> > > --- a/fs/xfs/scrub/ialloc.c
> > > +++ b/fs/xfs/scrub/ialloc.c
> > > @@ -265,6 +265,42 @@ xchk_iallocbt_check_freemask(
> > >  	return error;
> > >  }
> > >  
> > > +/* Make sure this inode btree record is aligned properly. */
> > > +STATIC void
> > > +xchk_iallocbt_rec_alignment(
> > > +	struct xchk_btree		*bs,
> > > +	struct xfs_inobt_rec_incore	*irec)
> > > +{
> > > +	struct xfs_mount		*mp = bs->sc->mp;
> > > +
> > > +	/*
> > > +	 * finobt records have different positioning requirements than inobt
> > > +	 * records: each finobt record must have a corresponding inobt record.
> > > +	 * That is checked in the xref function, so for now we only catch the
> > > +	 * obvious case where the record isn't even chunk-aligned.
> > > +	 *
> > > +	 * Note also that if a fs block contains more than a single chunk of
> > > +	 * inodes, we will have finobt records only for those chunks containing
> > > +	 * free inodes.
> > > +	 */
> > > +	if (bs->cur->bc_btnum == XFS_BTNUM_FINO) {
> > > +		if (irec->ir_startino & (XFS_INODES_PER_CHUNK - 1))
> > > +			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> > > +		return;
> > > +	}
> > 
> > Is the above really a finobt only check? Couldn't we run this
> > sanity check against all records and skip the following for finobt?
> 
> Uhoh, it occurs to me that in the 4kblock !spinodes case we can have
> inobt records (and therefore finobt records) that are aligned to
> m_cluster_align_inodes, and that value can be less than 64.  So I think
> this has to be something along the lines of:
> 

Er, yeah. IIRC spinodes required slightly larger inode chunk alignment
than traditionally required in order to ensure we don't create
conflicting/overlapping sparse records. A quick look at mkfs shows that
the cluster size basically defines the sparse chunk size and the chunk
alignment == chunk size.

> imask = min(XFS_INODES_PER_CHUNK, mp->m_cluster_align_inodes) - 1;
> if (irec->ir_startino & imask)
> 	/* set corrupt... */
> 
> Hmm, and testing seems to bear this out.  New patch forthcoming.
> 

Ok, I take it the min() is required because m_cluster_align_inodes can
be multiple records in the large FSB case. If so, I wonder if it would
be more simple to use m_cluster_align, but otherwise a one-liner comment
couldn't hurt.

> > Otherwise seems fine:
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> I've wondered in recent days if this is even necessary at all -- when
> we're asked to check the inobt we check the ir_startino alignment of all
> those records, so really the only thing we need is the existing check
> that for each finobt record there's also an inobt record with the same
> ir_startino.  OTOH I guess we shouldn't really assume that the calling
> process already checked the inobt or that it didn't change between calls.
> 

I guess it makes sense to verify the applicable records match, but in
general I agree that "1. verify the inobt 2. verify the finobt is a
subset of the inobt" is probably sufficient (and more elegant logic).

Brian

> --D
> 
> > > +
> > > +	/* inobt records must be aligned to cluster and inoalignmnt size. */
> > > +	if (irec->ir_startino & (mp->m_cluster_align_inodes - 1)) {
> > > +		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> > > +		return;
> > > +	}
> > > +
> > > +	if (irec->ir_startino & (mp->m_inodes_per_cluster - 1)) {
> > > +		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> > > +		return;
> > > +	}
> > > +}
> > > +
> > >  /* Scrub an inobt/finobt record. */
> > >  STATIC int
> > >  xchk_iallocbt_rec(
> > > @@ -277,7 +313,6 @@ xchk_iallocbt_rec(
> > >  	uint64_t			holes;
> > >  	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
> > >  	xfs_agino_t			agino;
> > > -	xfs_agblock_t			agbno;
> > >  	xfs_extlen_t			len;
> > >  	int				holecount;
> > >  	int				i;
> > > @@ -304,11 +339,9 @@ xchk_iallocbt_rec(
> > >  		goto out;
> > >  	}
> > >  
> > > -	/* Make sure this record is aligned to cluster and inoalignmnt size. */
> > > -	agbno = XFS_AGINO_TO_AGBNO(mp, irec.ir_startino);
> > > -	if ((agbno & (mp->m_cluster_align - 1)) ||
> > > -	    (agbno & (mp->m_blocks_per_cluster - 1)))
> > > -		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> > > +	xchk_iallocbt_rec_alignment(bs, &irec);
> > > +	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > > +		goto out;
> > >  
> > >  	iabt->inodes += irec.ir_count;
> > >  
> > > 
