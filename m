Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725294AbeLSIa6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 03:30:58 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBJ8SZML003403
        for <linux-xfs@vger.kernel.org>; Wed, 19 Dec 2018 03:30:56 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2pfgqavr58-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 19 Dec 2018 03:30:55 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 19 Dec 2018 08:30:53 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] xfs: clean up the inode cluster checking in the inobt scrub
Date: Wed, 19 Dec 2018 14:01:03 +0530
In-Reply-To: <154344765606.3835.11202701585574726944.stgit@magnolia>
References: <154344761877.3835.7785580513047409388.stgit@magnolia> <154344765606.3835.11202701585574726944.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2152902.OoUIS8QQca@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi Darrick,

Trivial review comments inlined below,

On Thursday, November 29, 2018 4:57:36 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The code to check inobt records against inode clusters is a mess of
> poorly named variables and unnecessary parameters.  Clean the
> unnecessary inode number parameters out of _check_cluster_freemask in
> favor of computing them inside the function instead of making the caller
> do it.  In xchk_iallocbt_check_cluster, rename the variables to make it
> more obvious just what chunk_ino and cluster_ino represent.
> 
> Add a tracepoint to make it easier to track each inode cluster as we
> scrub it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/ialloc.c |  162 ++++++++++++++++++++++++++++++++-----------------
>  fs/xfs/scrub/trace.h  |   45 ++++++++++++++
>  2 files changed, 151 insertions(+), 56 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 475f930e0daa..1d79f12dfce5 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -134,41 +134,70 @@ xchk_iallocbt_freecount(
>  	return hweight64(freemask);
>  }
> 
> -/* Check a particular inode with ir_free. */
> +/*
> + * Check that an inode's allocation status matches ir_free in the inobt
> + * record.  First we try querying the in-core inode state, and if the inode
> + * isn't loaded we examine the on-disk inode directly.
> + *
> + * Since there can be 1:M and M:1 mappings between inobt records and inode
> + * clusters, we pass in the inode location information as an inobt record;
> + * the index of an inode cluster within the inobt record (as well as the
> + * cluster buffer itself); and the index of the inode within the cluster.
> + *
> + * @irec is the inobt record.
> + * @cluster_base is the inode offset of the cluster within the @irec.
> + * @cluster_bp is the cluster buffer.
> + * @cluster_index is the inode offset within the inode cluster.
> + */
>  STATIC int
> -xchk_iallocbt_check_cluster_freemask(
> +xchk_iallocbt_check_cluster_ifree(
>  	struct xchk_btree		*bs,
> -	xfs_ino_t			fsino,
> -	xfs_agino_t			chunkino,
> -	xfs_agino_t			clusterino,
>  	struct xfs_inobt_rec_incore	*irec,
> -	struct xfs_buf			*bp)
> +	unsigned int			cluster_base,
> +	struct xfs_buf			*cluster_bp,
> +	unsigned int			cluster_index)
>  {
> -	struct xfs_dinode		*dip;
>  	struct xfs_mount		*mp = bs->cur->bc_mp;
> -	bool				inode_is_free = false;
> +	struct xfs_dinode		*dip;
> +	xfs_ino_t			fsino;
> +	xfs_agino_t			agino;
> +	unsigned int			offset;
> +	bool				irec_free;
> +	bool				ino_inuse;
>  	bool				freemask_ok;
> -	bool				inuse;
> -	int				error = 0;
> +	int				error;
> 
>  	if (xchk_should_terminate(bs->sc, &error))
>  		return error;
> 
> -	dip = xfs_buf_offset(bp, clusterino * mp->m_sb.sb_inodesize);
> +	/*
> +	 * Given an inobt record, an offset of a cluster within the record,
> +	 * and an offset of an inode within a cluster, compute which fs inode
> +	 * we're talking about and the offset of the inode record within the
> +	 * inode buffer.
> +	 */
> +	agino = irec->ir_startino + cluster_base + cluster_index;
> +	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
> +	offset = cluster_index * mp->m_sb.sb_inodesize;

I noticed that the 64k block size case has been fixed in the next patch.

> +	if (offset >= BBTOB(cluster_bp->b_length)) {
> +		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> +		goto out;
> +	}
> +	dip = xfs_buf_offset(cluster_bp, offset);
> +	irec_free = (irec->ir_free & XFS_INOBT_MASK(cluster_base +
> +						    cluster_index));
> +
>  	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC ||
> -	    (dip->di_version >= 3 &&
> -	     be64_to_cpu(dip->di_ino) != fsino + clusterino)) {
> +	    (dip->di_version >= 3 && be64_to_cpu(dip->di_ino) != fsino)) {
>  		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
>  		goto out;
>  	}
> 
> -	if (irec->ir_free & XFS_INOBT_MASK(chunkino + clusterino))
> -		inode_is_free = true;
> -	error = xfs_icache_inode_is_allocated(mp, bs->cur->bc_tp,
> -			fsino + clusterino, &inuse);
> +	error = xfs_icache_inode_is_allocated(mp, bs->cur->bc_tp, fsino,
> +			&ino_inuse);
>  	if (error == -ENODATA) {
>  		/* Not cached, just read the disk buffer */
> -		freemask_ok = inode_is_free ^ !!(dip->di_mode);
> +		freemask_ok = irec_free ^ !!(dip->di_mode);
>  		if (!bs->sc->try_harder && !freemask_ok)
>  			return -EDEADLOCK;
>  	} else if (error < 0) {
> @@ -180,7 +209,7 @@ xchk_iallocbt_check_cluster_freemask(
>  		goto out;
>  	} else {
>  		/* Inode is all there. */
> -		freemask_ok = inode_is_free ^ inuse;
> +		freemask_ok = irec_free ^ ino_inuse;
>  	}
>  	if (!freemask_ok)
>  		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> @@ -188,43 +217,57 @@ xchk_iallocbt_check_cluster_freemask(
>  	return 0;
>  }
> 
> -/* Check an inode cluster. */
> +/*
> + * Check that the holemask and freemask of a hypothetical inode cluster match
> + * what's actually on disk.  If sparse inodes are enabled, the cluster does
> + * not actually have to map to inodes if the corresponding holemask bit is set.
> + *
> + * @cluster_base is the first inode in the cluster within the @irec.
> + */
>  STATIC int
>  xchk_iallocbt_check_cluster(
>  	struct xchk_btree		*bs,
>  	struct xfs_inobt_rec_incore	*irec,
> -	xfs_agino_t			agino)
> +	unsigned int			cluster_base)
>  {
>  	struct xfs_imap			imap;
>  	struct xfs_mount		*mp = bs->cur->bc_mp;
>  	struct xfs_dinode		*dip;
> -	struct xfs_buf			*bp;
> -	xfs_ino_t			fsino;
> +	struct xfs_buf			*cluster_bp;
>  	unsigned int			nr_inodes;
> -	xfs_agino_t			chunkino;
> -	xfs_agino_t			clusterino;
> +	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
>  	xfs_agblock_t			agbno;
> -	uint16_t			holemask;
> +	unsigned int			cluster_index;
> +	uint16_t			cluster_mask = 0;
>  	uint16_t			ir_holemask;
>  	int				error = 0;
> 
> -	/* Make sure the freemask matches the inode records. */
>  	nr_inodes = min_t(unsigned int, XFS_INODES_PER_CHUNK,
>  			mp->m_inodes_per_cluster);
> 
> -	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
> -	chunkino = agino - irec->ir_startino;
> -	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
> +	/* Map this inode cluster */
> +	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino + cluster_base);
> 
> -	/* Compute the holemask mask for this cluster. */
> -	for (clusterino = 0, holemask = 0; clusterino < nr_inodes;
> -	     clusterino += XFS_INODES_PER_HOLEMASK_BIT)
> -		holemask |= XFS_INOBT_MASK((chunkino + clusterino) /
> +	/* Compute a bitmask for this cluster that can be used for holemask. */
> +	for (cluster_index = 0;
> +	     cluster_index < nr_inodes;
> +	     cluster_index += XFS_INODES_PER_HOLEMASK_BIT)
> +		cluster_mask |= XFS_INOBT_MASK((cluster_base + cluster_index) /
>  				XFS_INODES_PER_HOLEMASK_BIT);
> 
> +	ir_holemask = (irec->ir_holemask & cluster_mask);
> +	imap.im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
> +	imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
> +	imap.im_boffset = 0;
> +
> +	trace_xchk_iallocbt_check_cluster(mp, agno, irec->ir_startino,
> +			imap.im_blkno, imap.im_len, cluster_base, nr_inodes,
> +			cluster_mask, ir_holemask,
> +			XFS_INO_TO_OFFSET(mp, irec->ir_startino +
> +					  cluster_base));
> +
>  	/* The whole cluster must be a hole or not a hole. */

IMHO, "The whole cluster must be a hole or not *have* a hole in it" probably
conveys the meaning clearly.

> -	ir_holemask = (irec->ir_holemask & holemask);
> -	if (ir_holemask != holemask && ir_holemask != 0) {
> +	if (ir_holemask != cluster_mask && ir_holemask != 0) {
>  		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
>  		return 0;
>  	}
> @@ -241,40 +284,47 @@ xchk_iallocbt_check_cluster(
>  			&XFS_RMAP_OINFO_INODES);
> 
>  	/* Grab the inode cluster buffer. */
> -	imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno, agbno);
> -	imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
> -	imap.im_boffset = 0;
> -
> -	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &dip, &bp, 0, 0);
> +	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &dip, &cluster_bp,
> +			0, 0);
>  	if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0, &error))
> -		return 0;
> +		return error;
> 
> -	/* Which inodes are free? */
> -	for (clusterino = 0; clusterino < nr_inodes; clusterino++) {
> -		error = xchk_iallocbt_check_cluster_freemask(bs, fsino,
> -				chunkino, clusterino, irec, bp);
> +	/* Check free status of each inode within this cluster. */
> +	for (cluster_index = 0; cluster_index < nr_inodes; cluster_index++) {
> +		error = xchk_iallocbt_check_cluster_ifree(bs, irec,
> +				cluster_base, cluster_bp, cluster_index);
>  		if (error)
>  			break;
>  	}
> 
> -	xfs_trans_brelse(bs->cur->bc_tp, bp);
> +	xfs_trans_brelse(bs->cur->bc_tp, cluster_bp);
>  	return error;
>  }
> 
> -/* Make sure the free mask is consistent with what the inodes think. */
> +/*
> + * For all the inode clusters that could map to this inobt record, make sure
> + * that the holemask makes sense and that the allocation status of each inode
> + * matches the freemask.
> + */
>  STATIC int
> -xchk_iallocbt_check_freemask(
> +xchk_iallocbt_check_clusters(
>  	struct xchk_btree		*bs,
>  	struct xfs_inobt_rec_incore	*irec)
>  {
> -	struct xfs_mount		*mp = bs->cur->bc_mp;
> -	xfs_agino_t			agino;
> +	unsigned int			cluster_base;
>  	int				error = 0;
> 
> -	for (agino = irec->ir_startino;
> -	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
> -	     agino += mp->m_blocks_per_cluster * mp->m_sb.sb_inopblock) {
> -		error = xchk_iallocbt_check_cluster(bs, irec, agino);
> +	/*
> +	 * For the common case where this inobt record maps to multiple inode
> +	 * clusters this will call _check_cluster for each cluster.
> +	 *
> +	 * For the case that multiple inobt records map to a single cluster,
> +	 * this will call _check_cluster once.
> +	 */
> +	for (cluster_base = 0;
> +	     cluster_base < XFS_INODES_PER_CHUNK;
> +	     cluster_base += bs->sc->mp->m_inodes_per_cluster) {
> +		error = xchk_iallocbt_check_cluster(bs, irec, cluster_base);
>  		if (error)
>  			break;
>  	}
> @@ -417,7 +467,7 @@ xchk_iallocbt_rec(
>  		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> 
>  check_freemask:

May be the above label should be renamed to "check_clusters".

> -	error = xchk_iallocbt_check_freemask(bs, &irec);
> +	error = xchk_iallocbt_check_clusters(bs, &irec);
>  	if (error)
>  		goto out;
> 

-- 
chandan
