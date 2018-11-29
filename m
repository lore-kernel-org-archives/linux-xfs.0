Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729410AbeK3CGF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Nov 2018 21:06:05 -0500
Date: Thu, 29 Nov 2018 10:00:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: precalculate inodes and blocks per inode cluster
Message-ID: <20181129150024.GB22294@bfoster>
References: <154344757198.3700.16167533135011546878.stgit@magnolia>
 <154344759118.3700.6267447494975241717.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154344759118.3700.6267447494975241717.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 28, 2018 at 03:26:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Store the number of inodes and blocks per inode cluster in the mount
> data so that we don't have to keep recalculating them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ialloc.c |   23 ++++++++++-------------
>  fs/xfs/scrub/ialloc.c      |   14 ++++++--------
>  fs/xfs/xfs_inode.c         |   14 +++++---------
>  fs/xfs/xfs_itable.c        |   14 ++++++--------
>  fs/xfs/xfs_log_recover.c   |    8 +++-----
>  fs/xfs/xfs_mount.c         |    2 ++
>  fs/xfs/xfs_mount.h         |    2 ++
>  7 files changed, 34 insertions(+), 43 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 3ac4a836428d..c7b2579a8e73 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -288,7 +288,7 @@ xfs_ialloc_inode_init(
>  {
>  	struct xfs_buf		*fbuf;
>  	struct xfs_dinode	*free;
> -	int			nbufs, blks_per_cluster, inodes_per_cluster;
> +	int			nbufs;
>  	int			version;
>  	int			i, j;
>  	xfs_daddr_t		d;
> @@ -299,9 +299,7 @@ xfs_ialloc_inode_init(
>  	 * sizes, manipulate the inodes in buffers  which are multiples of the
>  	 * blocks size.
>  	 */
> -	blks_per_cluster = xfs_icluster_size_fsb(mp);
> -	inodes_per_cluster = XFS_FSB_TO_INO(mp, blks_per_cluster);
> -	nbufs = length / blks_per_cluster;
> +	nbufs = length / mp->m_blocks_per_cluster;
>  
>  	/*
>  	 * Figure out what version number to use in the inodes we create.  If
> @@ -344,9 +342,10 @@ xfs_ialloc_inode_init(
>  		/*
>  		 * Get the block.
>  		 */
> -		d = XFS_AGB_TO_DADDR(mp, agno, agbno + (j * blks_per_cluster));
> +		d = XFS_AGB_TO_DADDR(mp, agno, agbno +
> +				(j * mp->m_blocks_per_cluster));
>  		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
> -					 mp->m_bsize * blks_per_cluster,
> +					 mp->m_bsize * mp->m_blocks_per_cluster,
>  					 XBF_UNMAPPED);
>  		if (!fbuf)
>  			return -ENOMEM;
> @@ -354,7 +353,7 @@ xfs_ialloc_inode_init(
>  		/* Initialize the inode buffers and log them appropriately. */
>  		fbuf->b_ops = &xfs_inode_buf_ops;
>  		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
> -		for (i = 0; i < inodes_per_cluster; i++) {
> +		for (i = 0; i < mp->m_inodes_per_cluster; i++) {
>  			int	ioffset = i << mp->m_sb.sb_inodelog;
>  			uint	isize = xfs_dinode_size(version);
>  
> @@ -2289,7 +2288,6 @@ xfs_imap(
>  	xfs_agblock_t	agbno;	/* block number of inode in the alloc group */
>  	xfs_agino_t	agino;	/* inode number within alloc group */
>  	xfs_agnumber_t	agno;	/* allocation group number */
> -	int		blks_per_cluster; /* num blocks per inode cluster */
>  	xfs_agblock_t	chunk_agbno;	/* first block in inode chunk */
>  	xfs_agblock_t	cluster_agbno;	/* first block in inode cluster */
>  	int		error;	/* error code */
> @@ -2335,8 +2333,6 @@ xfs_imap(
>  		return -EINVAL;
>  	}
>  
> -	blks_per_cluster = xfs_icluster_size_fsb(mp);
> -
>  	/*
>  	 * For bulkstat and handle lookups, we have an untrusted inode number
>  	 * that we have to verify is valid. We cannot do this just by reading
> @@ -2356,7 +2352,7 @@ xfs_imap(
>  	 * If the inode cluster size is the same as the blocksize or
>  	 * smaller we get to the buffer by simple arithmetics.
>  	 */
> -	if (blks_per_cluster == 1) {
> +	if (mp->m_blocks_per_cluster == 1) {
>  		offset = XFS_INO_TO_OFFSET(mp, ino);
>  		ASSERT(offset < mp->m_sb.sb_inopblock);
>  
> @@ -2385,12 +2381,13 @@ xfs_imap(
>  out_map:
>  	ASSERT(agbno >= chunk_agbno);
>  	cluster_agbno = chunk_agbno +
> -		((offset_agbno / blks_per_cluster) * blks_per_cluster);
> +		((offset_agbno / mp->m_blocks_per_cluster) *
> +		 mp->m_blocks_per_cluster);
>  	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
>  		XFS_INO_TO_OFFSET(mp, ino);
>  
>  	imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, cluster_agbno);
> -	imap->im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
> +	imap->im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
>  	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
>  
>  	/*
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 426eb1a5503c..596a02b8efdc 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -193,18 +193,16 @@ xchk_iallocbt_check_freemask(
>  	xfs_agino_t			chunkino;
>  	xfs_agino_t			clusterino;
>  	xfs_agblock_t			agbno;
> -	int				blks_per_cluster;
>  	uint16_t			holemask;
>  	uint16_t			ir_holemask;
>  	int				error = 0;
>  
>  	/* Make sure the freemask matches the inode records. */
> -	blks_per_cluster = xfs_icluster_size_fsb(mp);
> -	nr_inodes = XFS_FSB_TO_INO(mp, blks_per_cluster);
> +	nr_inodes = mp->m_inodes_per_cluster;
>  
>  	for (agino = irec->ir_startino;
>  	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
> -	     agino += blks_per_cluster * mp->m_sb.sb_inopblock) {
> +	     agino += mp->m_inodes_per_cluster) {
>  		fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
>  		chunkino = agino - irec->ir_startino;
>  		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
> @@ -225,18 +223,18 @@ xchk_iallocbt_check_freemask(
>  		/* If any part of this is a hole, skip it. */
>  		if (ir_holemask) {
>  			xchk_xref_is_not_owned_by(bs->sc, agbno,
> -					blks_per_cluster,
> +					mp->m_blocks_per_cluster,
>  					&XFS_RMAP_OINFO_INODES);
>  			continue;
>  		}
>  
> -		xchk_xref_is_owned_by(bs->sc, agbno, blks_per_cluster,
> +		xchk_xref_is_owned_by(bs->sc, agbno, mp->m_blocks_per_cluster,
>  				&XFS_RMAP_OINFO_INODES);
>  
>  		/* Grab the inode cluster buffer. */
>  		imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno,
>  				agbno);
> -		imap.im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
> +		imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
>  		imap.im_boffset = 0;
>  
>  		error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap,
> @@ -303,7 +301,7 @@ xchk_iallocbt_rec(
>  	/* Make sure this record is aligned to cluster and inoalignmnt size. */
>  	agbno = XFS_AGINO_TO_AGBNO(mp, irec.ir_startino);
>  	if ((agbno & (xfs_ialloc_cluster_alignment(mp) - 1)) ||
> -	    (agbno & (xfs_icluster_size_fsb(mp) - 1)))
> +	    (agbno & (mp->m_blocks_per_cluster - 1)))
>  		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
>  
>  	*inode_blocks += XFS_B_TO_FSB(mp,
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 801eb891d0fd..ae667ba74a1c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2184,8 +2184,6 @@ xfs_ifree_cluster(
>  	struct xfs_icluster	*xic)
>  {
>  	xfs_mount_t		*mp = free_ip->i_mount;
> -	int			blks_per_cluster;
> -	int			inodes_per_cluster;
>  	int			nbufs;
>  	int			i, j;
>  	int			ioffset;
> @@ -2199,11 +2197,9 @@ xfs_ifree_cluster(
>  
>  	inum = xic->first_ino;
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
> -	blks_per_cluster = xfs_icluster_size_fsb(mp);
> -	inodes_per_cluster = XFS_FSB_TO_INO(mp, blks_per_cluster);
> -	nbufs = mp->m_ialloc_blks / blks_per_cluster;
> +	nbufs = mp->m_ialloc_blks / mp->m_blocks_per_cluster;
>  
> -	for (j = 0; j < nbufs; j++, inum += inodes_per_cluster) {
> +	for (j = 0; j < nbufs; j++, inum += mp->m_inodes_per_cluster) {
>  		/*
>  		 * The allocation bitmap tells us which inodes of the chunk were
>  		 * physically allocated. Skip the cluster if an inode falls into
> @@ -2211,7 +2207,7 @@ xfs_ifree_cluster(
>  		 */
>  		ioffset = inum - xic->first_ino;
>  		if ((xic->alloc & XFS_INOBT_MASK(ioffset)) == 0) {
> -			ASSERT(ioffset % inodes_per_cluster == 0);
> +			ASSERT(ioffset % mp->m_inodes_per_cluster == 0);
>  			continue;
>  		}
>  
> @@ -2227,7 +2223,7 @@ xfs_ifree_cluster(
>  		 * to mark all the active inodes on the buffer stale.
>  		 */
>  		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
> -					mp->m_bsize * blks_per_cluster,
> +					mp->m_bsize * mp->m_blocks_per_cluster,
>  					XBF_UNMAPPED);
>  
>  		if (!bp)
> @@ -2274,7 +2270,7 @@ xfs_ifree_cluster(
>  		 * transaction stale above, which means there is no point in
>  		 * even trying to lock them.
>  		 */
> -		for (i = 0; i < inodes_per_cluster; i++) {
> +		for (i = 0; i < mp->m_inodes_per_cluster; i++) {
>  retry:
>  			rcu_read_lock();
>  			ip = radix_tree_lookup(&pag->pag_ici_root,
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 18d8d3b812a7..942e4aa5e729 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -167,20 +167,18 @@ xfs_bulkstat_ichunk_ra(
>  {
>  	xfs_agblock_t			agbno;
>  	struct blk_plug			plug;
> -	int				blks_per_cluster;
> -	int				inodes_per_cluster;
>  	int				i;	/* inode chunk index */
>  
>  	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
> -	blks_per_cluster = xfs_icluster_size_fsb(mp);
> -	inodes_per_cluster = XFS_FSB_TO_INO(mp, blks_per_cluster);
>  
>  	blk_start_plug(&plug);
>  	for (i = 0; i < XFS_INODES_PER_CHUNK;
> -	     i += inodes_per_cluster, agbno += blks_per_cluster) {
> -		if (xfs_inobt_maskn(i, inodes_per_cluster) & ~irec->ir_free) {
> -			xfs_btree_reada_bufs(mp, agno, agbno, blks_per_cluster,
> -					     &xfs_inode_buf_ops);
> +	     i += mp->m_inodes_per_cluster, agbno += mp->m_blocks_per_cluster) {
> +		if (xfs_inobt_maskn(i, mp->m_inodes_per_cluster) &
> +		    ~irec->ir_free) {
> +			xfs_btree_reada_bufs(mp, agno, agbno,
> +					mp->m_blocks_per_cluster,
> +					&xfs_inode_buf_ops);
>  		}
>  	}
>  	blk_finish_plug(&plug);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1fc9e9042e0e..9fe88d125f0a 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3850,7 +3850,6 @@ xlog_recover_do_icreate_pass2(
>  	unsigned int		count;
>  	unsigned int		isize;
>  	xfs_agblock_t		length;
> -	int			blks_per_cluster;
>  	int			bb_per_cluster;
>  	int			cancel_count;
>  	int			nbufs;
> @@ -3918,14 +3917,13 @@ xlog_recover_do_icreate_pass2(
>  	 * buffers for cancellation so we don't overwrite anything written after
>  	 * a cancellation.
>  	 */
> -	blks_per_cluster = xfs_icluster_size_fsb(mp);
> -	bb_per_cluster = XFS_FSB_TO_BB(mp, blks_per_cluster);
> -	nbufs = length / blks_per_cluster;
> +	bb_per_cluster = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
> +	nbufs = length / mp->m_blocks_per_cluster;
>  	for (i = 0, cancel_count = 0; i < nbufs; i++) {
>  		xfs_daddr_t	daddr;
>  
>  		daddr = XFS_AGB_TO_DADDR(mp, agno,
> -					 agbno + i * blks_per_cluster);
> +					 agbno + i * mp->m_blocks_per_cluster);
>  		if (xlog_check_buffer_cancelled(log, daddr, bb_per_cluster, 0))
>  			cancel_count++;
>  	}
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 02d15098dbee..56d374675fd5 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -798,6 +798,8 @@ xfs_mountfs(
>  		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
>  			mp->m_inode_cluster_size = new_size;
>  	}
> +	mp->m_blocks_per_cluster = xfs_icluster_size_fsb(mp);
> +	mp->m_inodes_per_cluster = XFS_FSB_TO_INO(mp, mp->m_blocks_per_cluster);
>  
>  	/*
>  	 * If enabled, sparse inode chunk alignment is expected to match the
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 7964513c3128..58a037bfac22 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -101,6 +101,8 @@ typedef struct xfs_mount {
>  	uint8_t			m_agno_log;	/* log #ag's */
>  	uint8_t			m_agino_log;	/* #bits for agino in inum */
>  	uint			m_inode_cluster_size;/* min inode buf size */
> +	unsigned int		m_inodes_per_cluster;
> +	unsigned int		m_blocks_per_cluster;
>  	uint			m_blockmask;	/* sb_blocksize-1 */
>  	uint			m_blockwsize;	/* sb_blocksize in words */
>  	uint			m_blockwmask;	/* blockwsize-1 */
> 
