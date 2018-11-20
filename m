Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50998 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbeKUDB1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 22:01:27 -0500
Date: Tue, 20 Nov 2018 08:31:23 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/5] xfs: add a block to inode count converter
Message-ID: <20181120163123.GC6792@magnolia>
References: <154171920164.30818.2178553842722589349.stgit@magnolia>
 <154171922714.30818.15104071877694646829.stgit@magnolia>
 <20181120162105.GC48509@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120162105.GC48509@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 11:21:06AM -0500, Brian Foster wrote:
> On Thu, Nov 08, 2018 at 03:20:27PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add new helpers to convert units of fs blocks into inodes, and AG blocks
> > into AG inodes, respectively.  Convert all the open-coded conversions
> > and XFS_OFFBNO_TO_AGINO(, , 0) calls to use them, as appropriate.  The
> > OFFBNO_TO_AGINO macro is retained for xfs_repair.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |    2 ++
> >  fs/xfs/libxfs/xfs_ialloc.c |   17 ++++++++---------
> >  fs/xfs/libxfs/xfs_types.c  |    4 ++--
> >  fs/xfs/scrub/ialloc.c      |    2 +-
> >  fs/xfs/xfs_fsops.c         |    2 +-
> >  fs/xfs/xfs_inode.c         |    2 +-
> >  fs/xfs/xfs_itable.c        |    2 +-
> >  fs/xfs/xfs_super.c         |    4 ++--
> >  8 files changed, 18 insertions(+), 17 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 9995d5ae380b..52cf83986936 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -1083,6 +1083,8 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
> >  	((i) & XFS_INO_MASK(XFS_INO_OFFSET_BITS(mp)))
> >  #define	XFS_OFFBNO_TO_AGINO(mp,b,o)	\
> >  	((xfs_agino_t)(((b) << XFS_INO_OFFSET_BITS(mp)) | (o)))
> > +#define	XFS_FSB_TO_INO(mp, b)	((xfs_ino_t)((b) << (mp)->m_sb.sb_inopblog))
> > +#define	XFS_AGB_TO_AGINO(mp, b)	((xfs_agino_t)((b) << (mp)->m_sb.sb_inopblog))
> 
> Any reason not to use XFS_INO_OFFSET_BITS() like the other macros do in
> place of sb_inopblog?

Dislike of nested macros. :)

> >  
> >  #define	XFS_MAXINUMBER		((xfs_ino_t)((1ULL << 56) - 1ULL))
> >  #define	XFS_MAXINUMBER_32	((xfs_ino_t)((1ULL << 32) - 1ULL))
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index fcf0d17405d8..cb46141f9d15 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> ...
> > @@ -825,7 +824,7 @@ xfs_ialloc_ag_alloc(
> >  	/*
> >  	 * Convert the results.
> >  	 */
> > -	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
> > +	newino = XFS_FSB_TO_INO(args.mp, args.agbno);
> 
> Looks like this should be the AG variant.

Fixed.  Thanks for catching that. :)

--D

> Otherwise looks fine:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  
> >  	if (xfs_inobt_issparse(~allocmask)) {
> >  		/*
> > @@ -2724,8 +2723,8 @@ xfs_ialloc_has_inodes_at_extent(
> >  	xfs_agino_t		low;
> >  	xfs_agino_t		high;
> >  
> > -	low = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno, 0);
> > -	high = XFS_OFFBNO_TO_AGINO(cur->bc_mp, bno + len, 0) - 1;
> > +	low = XFS_AGB_TO_AGINO(cur->bc_mp, bno);
> > +	high = XFS_AGB_TO_AGINO(cur->bc_mp, bno + len) - 1;
> >  
> >  	return xfs_ialloc_has_inode_record(cur, low, high, exists);
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> > index 33a5ca346baf..895c232d63b7 100644
> > --- a/fs/xfs/libxfs/xfs_types.c
> > +++ b/fs/xfs/libxfs/xfs_types.c
> > @@ -89,14 +89,14 @@ xfs_agino_range(
> >  	 */
> >  	bno = round_up(XFS_AGFL_BLOCK(mp) + 1,
> >  			xfs_ialloc_cluster_alignment(mp));
> > -	*first = XFS_OFFBNO_TO_AGINO(mp, bno, 0);
> > +	*first = XFS_AGB_TO_AGINO(mp, bno);
> >  
> >  	/*
> >  	 * Calculate the last inode, which will be at the end of the
> >  	 * last (aligned) cluster that can be allocated in the AG.
> >  	 */
> >  	bno = round_down(eoag, xfs_ialloc_cluster_alignment(mp));
> > -	*last = XFS_OFFBNO_TO_AGINO(mp, bno, 0) - 1;
> > +	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > index 72f45b298fa5..426eb1a5503c 100644
> > --- a/fs/xfs/scrub/ialloc.c
> > +++ b/fs/xfs/scrub/ialloc.c
> > @@ -200,7 +200,7 @@ xchk_iallocbt_check_freemask(
> >  
> >  	/* Make sure the freemask matches the inode records. */
> >  	blks_per_cluster = xfs_icluster_size_fsb(mp);
> > -	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
> > +	nr_inodes = XFS_FSB_TO_INO(mp, blks_per_cluster);
> >  
> >  	for (agino = irec->ir_startino;
> >  	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 093c2b8d7e20..ec2e63a7963b 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -252,7 +252,7 @@ xfs_growfs_data(
> >  	if (mp->m_sb.sb_imax_pct) {
> >  		uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
> >  		do_div(icount, 100);
> > -		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
> > +		mp->m_maxicount = XFS_FSB_TO_INO(mp, icount);
> >  	} else
> >  		mp->m_maxicount = 0;
> >  
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 05db9540e459..55b865dadfaa 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2200,7 +2200,7 @@ xfs_ifree_cluster(
> >  	inum = xic->first_ino;
> >  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
> >  	blks_per_cluster = xfs_icluster_size_fsb(mp);
> > -	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
> > +	inodes_per_cluster = XFS_FSB_TO_INO(mp, blks_per_cluster);
> >  	nbufs = mp->m_ialloc_blks / blks_per_cluster;
> >  
> >  	for (j = 0; j < nbufs; j++, inum += inodes_per_cluster) {
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index e9508ba01ed1..18d8d3b812a7 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -173,7 +173,7 @@ xfs_bulkstat_ichunk_ra(
> >  
> >  	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
> >  	blks_per_cluster = xfs_icluster_size_fsb(mp);
> > -	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
> > +	inodes_per_cluster = XFS_FSB_TO_INO(mp, blks_per_cluster);
> >  
> >  	blk_start_plug(&plug);
> >  	for (i = 0; i < XFS_INODES_PER_CHUNK;
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index a2e944b80d2a..c9097cb0b955 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -608,7 +608,7 @@ xfs_set_inode_alloc(
> >  	}
> >  
> >  	/* Get the last possible inode in the filesystem */
> > -	agino =	XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
> > +	agino =	XFS_AGB_TO_AGINO(mp, sbp->sb_agblocks - 1);
> >  	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
> >  
> >  	/*
> > @@ -1150,7 +1150,7 @@ xfs_fs_statfs(
> >  	statp->f_bfree = fdblocks - mp->m_alloc_set_aside;
> >  	statp->f_bavail = statp->f_bfree;
> >  
> > -	fakeinos = statp->f_bfree << sbp->sb_inopblog;
> > +	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
> >  	statp->f_files = min(icount + fakeinos, (uint64_t)XFS_MAXINUMBER);
> >  	if (mp->m_maxicount)
> >  		statp->f_files = min_t(typeof(statp->f_files),
> > 
