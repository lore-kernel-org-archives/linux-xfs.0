Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbfADScm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Jan 2019 13:32:42 -0500
Date: Fri, 4 Jan 2019 13:32:39 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/8] xfs: clean up the inode cluster checking in the
 inobt scrub
Message-ID: <20190104183239.GG16751@bfoster>
References: <154630850739.14372.14000129432637481206.stgit@magnolia>
 <154630853834.14372.13119540305623771045.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630853834.14372.13119540305623771045.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 06:08:58PM -0800, Darrick J. Wong wrote:
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
> index 9af01ea0258d..2f6c2d7fa3fd 100644
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

Do you mean "offset of the inode within the buffer?"

> +	 * inode buffer.
> +	 */
> +	agino = irec->ir_startino + cluster_base + cluster_index;
> +	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
> +	offset = cluster_index * mp->m_sb.sb_inodesize;
> +	if (offset >= BBTOB(cluster_bp->b_length)) {
> +		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> +		goto out;
> +	}
...
> @@ -241,40 +284,47 @@ xchk_iallocbt_check_cluster(
...
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

I see this puts ->m_inodes_per_cluster back here, not sure why it
changed back and forth but Ok.

> +		error = xchk_iallocbt_check_cluster(bs, irec, cluster_base);
>  		if (error)
>  			break;
>  	}
> @@ -431,7 +481,7 @@ xchk_iallocbt_rec(
>  		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
>  
>  check_freemask:

Perhaps we should rename the label as well?

Nits aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -	error = xchk_iallocbt_check_freemask(bs, &irec);
> +	error = xchk_iallocbt_check_clusters(bs, &irec);
>  	if (error)
>  		goto out;
>  
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 8344b14031ef..3c83e8b3b39c 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -545,6 +545,51 @@ TRACE_EVENT(xchk_xref_error,
>  		  __entry->ret_ip)
>  );
>  
> +TRACE_EVENT(xchk_iallocbt_check_cluster,
> +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		 xfs_agino_t startino, xfs_daddr_t map_daddr,
> +		 unsigned short map_len, unsigned int chunk_ino,
> +		 unsigned int nr_inodes, uint16_t cluster_mask,
> +		 uint16_t holemask, unsigned int cluster_ino),
> +	TP_ARGS(mp, agno, startino, map_daddr, map_len, chunk_ino, nr_inodes,
> +		cluster_mask, holemask, cluster_ino),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agino_t, startino)
> +		__field(xfs_daddr_t, map_daddr)
> +		__field(unsigned short, map_len)
> +		__field(unsigned int, chunk_ino)
> +		__field(unsigned int, nr_inodes)
> +		__field(unsigned int, cluster_ino)
> +		__field(uint16_t, cluster_mask)
> +		__field(uint16_t, holemask)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->agno = agno;
> +		__entry->startino = startino;
> +		__entry->map_daddr = map_daddr;
> +		__entry->map_len = map_len;
> +		__entry->chunk_ino = chunk_ino;
> +		__entry->nr_inodes = nr_inodes;
> +		__entry->cluster_mask = cluster_mask;
> +		__entry->holemask = holemask;
> +		__entry->cluster_ino = cluster_ino;
> +	),
> +	TP_printk("dev %d:%d agno %d startino %u daddr 0x%llx len %d chunkino %u nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->agno,
> +		  __entry->startino,
> +		  __entry->map_daddr,
> +		  __entry->map_len,
> +		  __entry->chunk_ino,
> +		  __entry->nr_inodes,
> +		  __entry->cluster_mask,
> +		  __entry->holemask,
> +		  __entry->cluster_ino)
> +)
> +
>  /* repair tracepoints */
>  #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
>  
> 
