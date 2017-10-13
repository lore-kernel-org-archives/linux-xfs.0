Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45184 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750733AbdJMFWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2017 01:22:24 -0400
Date: Fri, 13 Oct 2017 16:22:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/30] xfs: create inode pointer verifiers
Message-ID: <20171013052220.GX15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777247562.1724.7094279740133124537.stgit@magnolia>
 <20171012202303.GJ7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012202303.GJ7122@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2017 at 01:23:03PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 11, 2017 at 06:41:15PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create some helper functions to check that inode pointers point to
> > somewhere within the filesystem and not at the static AG metadata.
> > Move xfs_internal_inum and create a directory inode check function.
> > We will use these functions in scrub and elsewhere.
....
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 988bb3f..da3652b 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -2664,3 +2664,84 @@ xfs_ialloc_pagi_init(
> >  		xfs_trans_brelse(tp, bp);
> >  	return 0;
> >  }
> > +
> > +/* Calculate the first and last possible inode number in an AG. */
> > +void
> > +xfs_ialloc_aginode_range(

agino_range?

> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno,
> > +	xfs_agino_t		*first,
> > +	xfs_agino_t		*last)
> > +{
> > +	xfs_agblock_t		eoag;
> > +
> > +	eoag = xfs_ag_block_count(mp, agno);
> > +	*first = round_up(XFS_OFFBNO_TO_AGINO(mp, XFS_AGFL_BLOCK(mp) + 1, 0),
> > +			XFS_INODES_PER_CHUNK);
> > +	*last = round_down(XFS_OFFBNO_TO_AGINO(mp, eoag, 0),
> > +			XFS_INODES_PER_CHUNK) - 1;
> 
> This is incorrect; we allocate inode chunks aligned to
> xfs_ialloc_cluster_alignment blocks, which doesn't necessarily result in
> ir_startino being aligned to XFS_INODES_PER_CHUNK.

*nod*

> I think the correct code is this:
> 
> 	/* Calculate the first inode. */
> 	bno = round_up(XFS_AGFL_BLOCK(mp) + 1,
> 			xfs_ialloc_cluster_alignment(mp));
> 	*first = XFS_OFFBNO_TO_AGINO(mp, bno, 0);

*nod*

> 	/* Calculate the last inode. */
> 	bno = round_down(eoag, xfs_ialloc_cluster_alignment(mp));
> 	*last = XFS_OFFBNO_TO_AGINO(mp, bno, 0) - 1;

Bit tricky - I'm not sure that this will give the same inode number
in all cases as rounding down to last valid chunk start offset and
then adding (MAX(XFS_INODES_PER_CHUNK, inodes-per-block) - 1) to
it....

> ...which unfortunately I didn't realize until trying to play with
> nondefault geometry options (1k blocks, no sparse inodes).

Ok, that might explain a bunch of inode noise on my 1k block size
test runs...

> > +/*
> > + * Verify that an AG inode number pointer neither points outside the AG
> > + * nor points at static metadata.
> > + */
> > +bool
> > +xfs_verify_agino_ptr(

Again, I'd probably drop the _ptr suffix here.

> > +	struct xfs_mount	*mp,
> > +	xfs_agnumber_t		agno,
> > +	xfs_agino_t		agino)
> > +{
> > +	xfs_agino_t		first;
> > +	xfs_agino_t		last;
> > +	int			ioff;
> > +
> > +	ioff = XFS_AGINO_TO_OFFSET(mp, agino);
> > +	xfs_ialloc_aginode_range(mp, agno, &first, &last);
> > +	return agino >= first && agino <= last &&
> > +	       ioff < (1 << mp->m_sb.sb_inopblog);

This ioff check will always evaluate as true, yes?

ioff	= XFS_AGINO_TO_OFFSET(i)
	= ((i) & XFS_INO_MASK(XFS_INO_OFFSET_BITS(mp)))
	= (i & XFS_INO_MASK((mp)->m_sb.sb_inopblog))
	= (i & (uint32_t)((1ULL << (mp)->m_sb.sb_inopblog)) - 1)

say sb_inopblog = 8:

ioff	= (i & 0xFF)

And so:

	ioff < (1 << 8)

will always be true.

So I'm not sure this check is needed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
