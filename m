Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53364 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728977AbeKUDDl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 22:03:41 -0500
Date: Tue, 20 Nov 2018 08:33:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] xfs: precalculate inodes and blocks per inode cluster
Message-ID: <20181120163336.GD6792@magnolia>
References: <154171920164.30818.2178553842722589349.stgit@magnolia>
 <154171923320.30818.4183266629971056462.stgit@magnolia>
 <20181120162300.GD48509@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120162300.GD48509@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 11:23:00AM -0500, Brian Foster wrote:
> On Thu, Nov 08, 2018 at 03:20:33PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Store the number of inodes and blocks per inode cluster in the mount
> > data so that we don't have to keep recalculating them.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c |   23 ++++++++++-------------
> >  fs/xfs/scrub/ialloc.c      |   14 ++++++--------
> >  fs/xfs/xfs_inode.c         |   14 +++++---------
> >  fs/xfs/xfs_itable.c        |   14 ++++++--------
> >  fs/xfs/xfs_log_recover.c   |    8 +++-----
> >  fs/xfs/xfs_mount.c         |    2 ++
> >  fs/xfs/xfs_mount.h         |    2 ++
> >  7 files changed, 34 insertions(+), 43 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > index 426eb1a5503c..332ac7b61789 100644
> > --- a/fs/xfs/scrub/ialloc.c
> > +++ b/fs/xfs/scrub/ialloc.c
> > @@ -193,18 +193,16 @@ xchk_iallocbt_check_freemask(
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
> > -	nr_inodes = XFS_FSB_TO_INO(mp, blks_per_cluster);
> > +	nr_inodes = mp->m_inodes_per_cluster;
> 
> Why keep nr_inodes? Doesn't look like it changes anywhere..

IIRC it changes in the inobt scrubber cleanup series that comes later,
because this code is actually broken -- nr_inodes can't exceed inodes
per cluster or inodes per chunk.

> >  
> >  	for (agino = irec->ir_startino;
> >  	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
> > -	     agino += blks_per_cluster * mp->m_sb.sb_inopblock) {
> > +	     agino += mp->m_blocks_per_cluster * mp->m_sb.sb_inopblock) {
> 
> ... and this looks like m_inodes_per_cluster.

Yep.

> >  		fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
> >  		chunkino = agino - irec->ir_startino;
> >  		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
> > @@ -225,18 +223,18 @@ xchk_iallocbt_check_freemask(
> >  		/* If any part of this is a hole, skip it. */
> >  		if (ir_holemask) {
> >  			xchk_xref_is_not_owned_by(bs->sc, agbno,
> > -					blks_per_cluster,
> > +					mp->m_blocks_per_cluster,
> >  					&XFS_RMAP_OINFO_INODES);
> >  			continue;
> >  		}
> >  
> > -		xchk_xref_is_owned_by(bs->sc, agbno, blks_per_cluster,
> > +		xchk_xref_is_owned_by(bs->sc, agbno, mp->m_blocks_per_cluster,
> >  				&XFS_RMAP_OINFO_INODES);
> >  
> >  		/* Grab the inode cluster buffer. */
> >  		imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno,
> >  				agbno);
> > -		imap.im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
> > +		imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
> >  		imap.im_boffset = 0;
> >  
> >  		error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap,
> > @@ -303,7 +301,7 @@ xchk_iallocbt_rec(
> >  	/* Make sure this record is aligned to cluster and inoalignmnt size. */
> >  	agbno = XFS_AGINO_TO_AGBNO(mp, irec.ir_startino);
> >  	if ((agbno & (xfs_ialloc_cluster_alignment(mp) - 1)) ||
> > -	    (agbno & (xfs_icluster_size_fsb(mp) - 1)))
> > +	    (agbno & (mp->m_blocks_per_cluster - 1)))
> >  		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> >  
> >  	*inode_blocks += XFS_B_TO_FSB(mp,
> ...
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index 18d8d3b812a7..00828b57e1f8 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -167,20 +167,18 @@ xfs_bulkstat_ichunk_ra(
> >  {
> >  	xfs_agblock_t			agbno;
> >  	struct blk_plug			plug;
> > -	int				blks_per_cluster;
> > -	int				inodes_per_cluster;
> >  	int				i;	/* inode chunk index */
> >  
> >  	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
> > -	blks_per_cluster = xfs_icluster_size_fsb(mp);
> > -	inodes_per_cluster = XFS_FSB_TO_INO(mp, blks_per_cluster);
> >  
> >  	blk_start_plug(&plug);
> >  	for (i = 0; i < XFS_INODES_PER_CHUNK;
> > -	     i += inodes_per_cluster, agbno += blks_per_cluster) {
> > -		if (xfs_inobt_maskn(i, inodes_per_cluster) & ~irec->ir_free) {
> > -			xfs_btree_reada_bufs(mp, agno, agbno, blks_per_cluster,
> > -					     &xfs_inode_buf_ops);
> > +	     i += mp->m_inodes_per_cluster, agbno += mp->m_blocks_per_cluster) {
> > +		if (xfs_inobt_maskn(i, mp->m_inodes_per_cluster) &
> > +				~irec->ir_free) {
> 
> Just another nit, this should probably be aligned like so:
> 
> 		if (xfs_inobt_maskn(i, mp->m_inodes_per_cluster) &
> 		    ~irec->ir_free) {
> 			...
> 		}
> 
> ... right?

Yes, fixed.

--D

> Brian
> 
> > +			xfs_btree_reada_bufs(mp, agno, agbno,
> > +					mp->m_blocks_per_cluster,
> > +					&xfs_inode_buf_ops);
> >  		}
> >  	}
> >  	blk_finish_plug(&plug);
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 1fc9e9042e0e..9fe88d125f0a 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -3850,7 +3850,6 @@ xlog_recover_do_icreate_pass2(
> >  	unsigned int		count;
> >  	unsigned int		isize;
> >  	xfs_agblock_t		length;
> > -	int			blks_per_cluster;
> >  	int			bb_per_cluster;
> >  	int			cancel_count;
> >  	int			nbufs;
> > @@ -3918,14 +3917,13 @@ xlog_recover_do_icreate_pass2(
> >  	 * buffers for cancellation so we don't overwrite anything written after
> >  	 * a cancellation.
> >  	 */
> > -	blks_per_cluster = xfs_icluster_size_fsb(mp);
> > -	bb_per_cluster = XFS_FSB_TO_BB(mp, blks_per_cluster);
> > -	nbufs = length / blks_per_cluster;
> > +	bb_per_cluster = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
> > +	nbufs = length / mp->m_blocks_per_cluster;
> >  	for (i = 0, cancel_count = 0; i < nbufs; i++) {
> >  		xfs_daddr_t	daddr;
> >  
> >  		daddr = XFS_AGB_TO_DADDR(mp, agno,
> > -					 agbno + i * blks_per_cluster);
> > +					 agbno + i * mp->m_blocks_per_cluster);
> >  		if (xlog_check_buffer_cancelled(log, daddr, bb_per_cluster, 0))
> >  			cancel_count++;
> >  	}
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 02d15098dbee..56d374675fd5 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -798,6 +798,8 @@ xfs_mountfs(
> >  		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
> >  			mp->m_inode_cluster_size = new_size;
> >  	}
> > +	mp->m_blocks_per_cluster = xfs_icluster_size_fsb(mp);
> > +	mp->m_inodes_per_cluster = XFS_FSB_TO_INO(mp, mp->m_blocks_per_cluster);
> >  
> >  	/*
> >  	 * If enabled, sparse inode chunk alignment is expected to match the
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 7964513c3128..58a037bfac22 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -101,6 +101,8 @@ typedef struct xfs_mount {
> >  	uint8_t			m_agno_log;	/* log #ag's */
> >  	uint8_t			m_agino_log;	/* #bits for agino in inum */
> >  	uint			m_inode_cluster_size;/* min inode buf size */
> > +	unsigned int		m_inodes_per_cluster;
> > +	unsigned int		m_blocks_per_cluster;
> >  	uint			m_blockmask;	/* sb_blocksize-1 */
> >  	uint			m_blockwsize;	/* sb_blocksize in words */
> >  	uint			m_blockwmask;	/* blockwsize-1 */
> > 
