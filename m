Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:25988 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbeKGHjD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 02:39:03 -0500
Date: Wed, 7 Nov 2018 09:11:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/8] xfs: clean up the inode cluster checking in the
 inobt scrub
Message-ID: <20181106221135.GT19305@dastard>
References: <154147728649.32496.4515247239602322709.stgit@magnolia>
 <154147732686.32496.17362148568991301258.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154147732686.32496.17362148568991301258.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 08:08:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The code to check inobt records against inode clusters is a mess of
> poorly named variables and unnecessary parameters.  Clean the
> unnecessary inode number parameters out of _check_cluster_freemask in
> favor of computing them inside the function instead of making the caller
> do it.  In xchk_iallocbt_check_cluster, rename the variables to make it
> more obvious just what chunk_ino and cluster_ino represent.

Comment about new trace point? (used to debug change?)

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/ialloc.c |  130 ++++++++++++++++++++++++++++++-------------------
>  fs/xfs/scrub/trace.h  |   45 +++++++++++++++++
>  2 files changed, 125 insertions(+), 50 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 12158ed8ad29..645b248faa80 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -147,41 +147,63 @@ xchk_iallocbt_freecount(
>  	return hweight64(freemask);
>  }
>  
> -/* Check a particular inode with ir_free. */
> +/*
> + * Given the number of an inode within an inode cluster, check that the inode's
> + * allocation status matches ir_free in the inobt record.
> + *
> + * @chunk_ioff is the inode offset of the cluster within the @irec.
> + * @irec is the inobt record.
> + * @bp is the cluster buffer.
> + * @loop_ioff is the inode offset within the inode cluster.
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
> +	unsigned int			chunk_ioff,
> +	struct xfs_buf			*bp,
> +	unsigned int			loop_ioff)

"loop_ioff" really isn't very descriptive. I've got no idea what it
means in the context of this function. More below.

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
> +	agino = irec->ir_startino + chunk_ioff + loop_ioff;
> +	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
> +	offset = loop_ioff * mp->m_sb.sb_inodesize;
> +	if (offset >= BBTOB(bp->b_length)) {
> +		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> +		goto out;
> +	}

New check...

> +	dip = xfs_buf_offset(bp, offset);
> +	irec_free = (irec->ir_free & XFS_INOBT_MASK(chunk_ioff + loop_ioff));

And after 15 minutes of trying to work out if this is safe, I can
say that the new code isn't much clearer than the old code.

chunk_ioff is actually the first inode in the current cluster,
and loop_ioff is the current of the inode in the cluster.

They are indexes, not offsets. i.e. chunk_ioff is cluster_base,
and loop_ioff is cluster_index. (or something similar).


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
> @@ -193,7 +215,7 @@ xchk_iallocbt_check_cluster_freemask(
>  		goto out;
>  	} else {
>  		/* Inode is all there. */
> -		freemask_ok = inode_is_free ^ inuse;
> +		freemask_ok = irec_free ^ ino_inuse;
>  	}
>  	if (!freemask_ok)
>  		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> @@ -201,44 +223,57 @@ xchk_iallocbt_check_cluster_freemask(
>  	return 0;
>  }
>  
> -/* Check an inode cluster. */
> +/*
> + * Check that the holemask and freemask of a hypothetical inode cluster match
> + * what's actually on disk.  If sparse inodes are enabled, the cluster does
> + * not actually have to map to inodes if the corresponding holemask bit is set.
> + *
> + * @chunk_ioff is the inode offset of the cluster within the @irec.
> + */
>  STATIC int
>  xchk_iallocbt_check_cluster(
>  	struct xchk_btree		*bs,
>  	struct xchk_iallocbt		*iabt,
>  	struct xfs_inobt_rec_incore	*irec,
> -	xfs_agino_t			agino)
> +	unsigned int			chunk_ioff)

cluster_base

>  {
>  	struct xfs_imap			imap;
>  	struct xfs_mount		*mp = bs->cur->bc_mp;
>  	struct xfs_dinode		*dip;
>  	struct xfs_buf			*bp;
> -	xfs_ino_t			fsino;
>  	unsigned int			nr_inodes;
> -	xfs_agino_t			chunkino;
> -	xfs_agino_t			clusterino;
> +	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
>  	xfs_agblock_t			agbno;
> -	uint16_t			holemask;
> +	unsigned int			loop_ioff;

cluster_index

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
