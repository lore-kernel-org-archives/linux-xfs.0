Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732531AbeHBQpj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Aug 2018 12:45:39 -0400
Date: Thu, 2 Aug 2018 10:54:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/14] xfs: repair inode btrees
Message-ID: <20180802145403.GC65267@bfoster>
References: <153292966714.24509.15809693393247424274.stgit@magnolia>
 <153292970836.24509.597298447307205186.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153292970836.24509.597298447307205186.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Sun, Jul 29, 2018 at 10:48:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the rmapbt to find inode chunks, query the chunks to compute
> hole and free masks, and with that information rebuild the inobt
> and finobt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Makefile              |    1 
>  fs/xfs/scrub/common.c        |    2 
>  fs/xfs/scrub/ialloc_repair.c |  673 ++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/repair.c        |   20 +
>  fs/xfs/scrub/repair.h        |   11 +
>  fs/xfs/scrub/scrub.c         |    4 
>  fs/xfs/scrub/scrub.h         |    1 
>  fs/xfs/scrub/trace.h         |    4 
>  8 files changed, 712 insertions(+), 4 deletions(-)
>  create mode 100644 fs/xfs/scrub/ialloc_repair.c
> 
> 
...
> diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
> new file mode 100644
> index 000000000000..126135c1a147
> --- /dev/null
> +++ b/fs/xfs/scrub/ialloc_repair.c
> @@ -0,0 +1,673 @@
...
> +
> +/*
> + * Inode Btree Repair
> + * ==================
> + *
> + * A quick refresher of inode btrees on a v5 filesystem:
> + *
> + * - Each inode btree record can describe a single 'inode chunk'.  The chunk
> + *   size is defined to be 64 inodes.  If sparse inodes are enabled, every
> + *   inobt record must be aligned to the chunk size.  A chunk can be smaller
> + *   than a fs block.  One must be careful with 64k-block filesystems whose
> + *   inodes are smaller than 1k.
> + *
> + * - Inode buffers are read into memory in units of 'inode clusters'.  However
> + *   many inodes fit in a cluster buffer is the smallest number of inodes that
> + *   can be allocated or freed.  Clusters are never larger than a chunk and
> + *   never smaller than a fs block.  If sparse inodes are not enabled, then
> + *   records can be aligned to a cluster.
> + *

I find the wording around alignment in the above two sections a little
confusing. We distinguish between sparse=0/1 on some points but not
others, like the cluster buffer being the smallest possible allocation
unit of inodes, but IIUC that is only the case with sparse=1.

My general understanding is that inode records should always be aligned
to sb_inoalignmt, regardless of sparse inodes. For non-sparse
filesystems, this value can be smaller than the chunk size. For sparse
filesystems, it must match the chunk size and sb_spino_align defines the
sparse chunk allocation alignment, which must match the cluster size.

> + * - If sparse inodes are enabled, the holemask field will be active.  Each
> + *   bit of the holemask represents 4 potential inodes; if set, the
> + *   corresponding space does *not* contain inodes and must be left alone.
> + *
> + * So what's the rebuild algorithm?
> + *
> + * Iterate the reverse mapping records looking for OWN_INODES and OWN_INOBT
> + * records.  The OWN_INOBT records are the old inode btree blocks and will be
> + * cleared out after we've rebuilt the tree.  Each possible inode chunk within
> + * an OWN_INODES record will be read in and the freemask calculated from the
> + * i_mode data in the inode chunk.  For sparse inodes the holemask will be
> + * calculated by creating the properly aligned inobt record and punching out
> + * any chunk that's missing.  Inode allocations and frees grab the AGI first,
> + * so repair protects itself from concurrent access by locking the AGI.
> + *
> + * Once we've reconstructed all the inode records, we can create new inode
> + * btree roots and reload the btrees.  We rebuild both inode trees at the same
> + * time because they have the same rmap owner and it would be more complex to
> + * figure out if the other tree isn't in need of a rebuild and which OWN_INOBT
> + * blocks it owns.  We have all the data we need to build both, so dump
> + * everything and start over.
> + *
> + * We use the prefix 'xrep_ibt' because we rebuild both inode btrees.
> + */
> +
> +struct xrep_ibt_extent {
> +	struct list_head	list;
> +	xfs_inofree_t		freemask;
> +	xfs_agino_t		startino;
> +	unsigned int		count;
> +	unsigned int		usedcount;
> +	uint16_t		holemask;

I'm curious why we wouldn't just reuse xfs_inobt_rec_incore here.

> +};
> +
...
> +
> +/*
> + * For each inode cluster covering the physical extent recorded by the rmapbt,
> + * we must calculate the properly aligned startino of that cluster, then
> + * iterate each cluster to fill in used and filled masks appropriately.  We
> + * then use the (startino, used, filled) information to construct the
> + * appropriate inode records.
> + */
> +STATIC int
> +xrep_ibt_process_cluster(
> +	struct xrep_ibt		*ri,
> +	xfs_agblock_t		agbno,
> +	int			blks_per_cluster,
> +	xfs_agino_t		rec_agino)
> +{
> +	struct xfs_imap		imap;
> +	struct xrep_ibt_extent	*rie;
> +	struct xfs_dinode	*dip;
> +	struct xfs_buf		*bp;
> +	struct xfs_scrub	*sc = ri->sc;
> +	struct xfs_mount	*mp = sc->mp;
> +	xfs_ino_t		fsino;
> +	xfs_inofree_t		usedmask;
> +	xfs_agino_t		nr_inodes;
> +	xfs_agino_t		startino;
> +	xfs_agino_t		clusterino;
> +	xfs_agino_t		clusteroff;
> +	xfs_agino_t		agino;
> +	uint16_t		fillmask;
> +	bool			inuse;
> +	int			usedcount;
> +	int			error;
> +
> +	/* The per-AG inum of this inode cluster. */
> +	agino = XFS_OFFBNO_TO_AGINO(mp, agbno, 0);
> +
> +	/* The per-AG inum of the inobt record. */
> +	startino = rec_agino + rounddown(agino - rec_agino,
> +			XFS_INODES_PER_CHUNK);

Hmm, I'm not following what this does. When does startino != rec_agino
here? Is this related to the multi-chunk-per-block case on large block
sizes, since I'm not quite following how we handle that case either...?
Don't we need to factor in inodes_per_block somewhere in here to cover
the multi-chunk case?

BTW, that second line could use another indent or two to clarify it's
part of the rounddown() call.

> +
> +	/* The per-AG inum of the cluster within the inobt record. */
> +	clusteroff = agino - startino;
> +
> +	/* Every inode in this holemask slot is filled. */
> +	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
> +	fillmask = xfs_inobt_maskn(clusteroff / XFS_INODES_PER_HOLEMASK_BIT,
> +			nr_inodes / XFS_INODES_PER_HOLEMASK_BIT);
> +
> +	/*
> +	 * Grab the inode cluster buffer.  This is safe to do with a broken
> +	 * inobt because imap_to_bp directly maps the buffer without touching
> +	 * either inode btree.
> +	 */
> +	imap.im_blkno = XFS_AGB_TO_DADDR(mp, sc->sa.agno, agbno);
> +	imap.im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
> +	imap.im_boffset = 0;
> +	error = xfs_imap_to_bp(mp, sc->tp, &imap, &dip, &bp, 0,
> +			XFS_IGET_UNTRUSTED);
> +	if (error)
> +		return error;
> +
> +	usedmask = 0;
> +	usedcount = 0;
> +	/* Which inodes within this cluster are free? */
> +	for (clusterino = 0; clusterino < nr_inodes; clusterino++) {
> +		fsino = XFS_AGINO_TO_INO(mp, sc->sa.agno, agino + clusterino);
> +		error = xrep_ibt_check_free(sc, bp, fsino,
> +				clusterino, &inuse);
> +		if (error) {
> +			xfs_trans_brelse(sc->tp, bp);
> +			return error;
> +		}
> +		if (inuse) {
> +			usedcount++;
> +			usedmask |= XFS_INOBT_MASK(clusteroff + clusterino);
> +		}
> +	}
> +	xfs_trans_brelse(sc->tp, bp);
> +
> +	/*
> +	 * If the last item in the list is our chunk record,
> +	 * update that.
> +	 */
> +	if (!list_empty(ri->extlist)) {
> +		rie = list_last_entry(ri->extlist, struct xrep_ibt_extent,
> +				list);
> +		if (rie->startino + XFS_INODES_PER_CHUNK > startino) {
> +			rie->freemask &= ~usedmask;
> +			rie->holemask &= ~fillmask;
> +			rie->count += nr_inodes;
> +			rie->usedcount += usedcount;
> +			return 0;
> +		}

And I think if we used the existing in-core record data structure we
could also reuse existing helpers like __xfs_inobt_rec_merge().

Alternatively, could we allocate/lookup the xrep_ibt_extent earlier and
update the associated fields directly rather than via the indirection of
the various local vars?

BTW, I initially thought this was a sparse inode thing but I see a bit
further down that we process a cluster at a time regardless. That seems
Ok, but I do wonder if some of this list hackery and whatnot could be
simplified by walking the clusters here. I guess we'd still need to
account for separate rmapbt records for sparse chunks, however.

> +	}
> +
> +	/* New inode chunk; add to the list. */
> +	rie = kmem_alloc(sizeof(struct xrep_ibt_extent), KM_MAYFAIL);
> +	if (!rie)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&rie->list);
> +	rie->startino = startino;
> +	rie->freemask = XFS_INOBT_ALL_FREE & ~usedmask;
> +	rie->holemask = XFS_INOBT_ALL_FREE & ~fillmask;

I'm not sure we need the ALL_FREE thing here..? We don't use it in the
update case above. (Though it would make sense if we allocated this
structure earlier and initialized it.)

> +	rie->count = nr_inodes;
> +	rie->usedcount = usedcount;
> +	list_add_tail(&rie->list, ri->extlist);
> +	ri->nr_records++;
> +
> +	return 0;
> +}
> +
> +/* Record extents that belong to inode btrees. */
> +STATIC int
> +xrep_ibt_walk_rmap(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_rmap_irec	*rec,
> +	void			*priv)
> +{
> +	struct xrep_ibt		*ri = priv;
> +	struct xfs_mount	*mp = cur->bc_mp;
> +	xfs_fsblock_t		fsbno;
> +	xfs_agblock_t		agbno = rec->rm_startblock;
> +	xfs_agino_t		inoalign;
> +	xfs_agino_t		agino;
> +	xfs_agino_t		rec_agino;
> +	int			blks_per_cluster;
> +	int			error = 0;
> +
> +	if (xchk_should_terminate(ri->sc, &error))
> +		return error;
> +
> +	/* Fragment of the old btrees; dispose of them later. */
> +	if (rec->rm_owner == XFS_RMAP_OWN_INOBT) {
> +		fsbno = XFS_AGB_TO_FSB(mp, ri->sc->sa.agno, agbno);
> +		return xfs_bitmap_set(ri->btlist, fsbno, rec->rm_blockcount);
> +	}
> +
> +	/* Skip extents which are not owned by this inode and fork. */
> +	if (rec->rm_owner != XFS_RMAP_OWN_INODES)
> +		return 0;
> +
> +	blks_per_cluster = xfs_icluster_size_fsb(mp);
> +
> +	if (agbno % blks_per_cluster != 0)
> +		return -EFSCORRUPTED;
> +

Ok, so we check that agbno is at least cluster aligned...

Shouldn't we verify that blockcount is sane as well?

> +	trace_xrep_ibt_walk_rmap(mp, ri->sc->sa.agno, rec->rm_startblock,
> +			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
> +			rec->rm_flags);
> +
> +	/*
> +	 * Determine the inode block alignment, and where the block
> +	 * ought to start if it's aligned properly.  On a sparse inode
> +	 * system the rmap doesn't have to start on an alignment boundary,
> +	 * but the record does.  On pre-sparse filesystems, we /must/
> +	 * start both rmap and inobt on an alignment boundary.
> +	 */
> +	inoalign = xfs_ialloc_cluster_alignment(mp);
> +	agino = XFS_OFFBNO_TO_AGINO(mp, agbno, 0);
> +	rec_agino = XFS_OFFBNO_TO_AGINO(mp, rounddown(agbno, inoalign), 0);
> +	if (!xfs_sb_version_hassparseinodes(&mp->m_sb) && agino != rec_agino)
> +		return -EFSCORRUPTED;
> +

... then if I follow correctly, verify the block is aligned
appropriately on !sparse. Firstly, isn't the above logically equivalent
to the following? E.g., I'm not sure why we need agino here.

	if (!sparse && (agbno % inoalign != 0))
		return -EFSCORRUPTED;

I take it that since we're walking the rmap, agbno could refer to a
sparse cluster. Perhaps we should also check against sb_spino_align in
the sparse case. FWIW, I think the comment above could be more clear as
well:

/*
 * On a sparse inode fs, agbno could refer to a partial chunk. This
 * should be aligned to the sparse chunk alignment. On a non-sparse fs,
 * agbno must always refer to the first block of an inode chunk and so
 * should be chunk aligned.
 */

> +	/*
> +	 * Set up the free/hole masks for each inode cluster that could be
> +	 * mapped by this rmap record.
> +	 */
> +	for (;
> +	     agbno < rec->rm_startblock + rec->rm_blockcount;
> +	     agbno += blks_per_cluster) {
> +		error = xrep_ibt_process_cluster(ri, agbno, blks_per_cluster,
> +				rec_agino);
> +		if (error)
> +			return error;
> +	}

Hmm, Ok. We're processing inodes a cluster size at a time regardless of
the extent length. That makes sense since we presumably need to read and
process the inode cluster itself.

> +
> +	return 0;
> +}
> +
...
> +/* Build new inode btrees and dispose of the old one. */
> +STATIC int
> +xrep_ibt_rebuild_trees(
> +	struct xfs_scrub	*sc,
> +	struct list_head	*inode_records,
> +	struct xfs_owner_info	*oinfo,
> +	struct xfs_bitmap	*old_iallocbt_blocks)
> +{
> +	struct xrep_ibt_extent	*rie;
> +	struct xrep_ibt_extent	*n;
> +	int			error;
> +
> +	/* Add all records. */
> +	list_sort(NULL, inode_records, xrep_ibt_extent_cmp);
> +	list_for_each_entry_safe(rie, n, inode_records, list) {
> +		error = xrep_ibt_insert_rec(sc, rie);
> +		if (error)
> +			return error;
> +
> +		list_del(&rie->list);
> +		kmem_free(rie);
> +	}

Same general thoughts here around freeing old blocks and whatnot as for
the allocbt repairs. Though I assume if we end up tweaking that behavior
we'll do so across the board.

Brian

> +
> +	/* Free the old inode btree blocks if they're not in use. */
> +	return xrep_reap_extents(sc, old_iallocbt_blocks, oinfo,
> +			XFS_AG_RESV_NONE);
> +}
> +
> +/*
> + * Make our new inode btree roots permanent so that we can start re-adding
> + * inode records back into the AG.
> + */
> +STATIC int
> +xrep_ibt_commit_new(
> +	struct xfs_scrub	*sc,
> +	struct xfs_bitmap	*old_iallocbt_blocks,
> +	int			log_flags)
> +{
> +	int			error;
> +
> +	xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp, log_flags);
> +
> +	/* Invalidate all the inobt/finobt blocks in btlist. */
> +	error = xrep_invalidate_blocks(sc, old_iallocbt_blocks);
> +	if (error)
> +		return error;
> +	error = xrep_roll_ag_trans(sc);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Now that we've succeeded, mark the incore state valid again.  If the
> +	 * finobt is enabled, make sure we reinitialize the per-AG reservations
> +	 * when we're done.
> +	 */
> +	sc->sa.pag->pagi_init = 1;
> +	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb))
> +		sc->reset_perag_resv = true;
> +	return 0;
> +}
> +
> +/* Repair both inode btrees. */
> +int
> +xrep_iallocbt(
> +	struct xfs_scrub	*sc)
> +{
> +	struct xfs_owner_info	oinfo;
> +	struct list_head	inode_records;
> +	struct xfs_bitmap	old_iallocbt_blocks;
> +	struct xfs_mount	*mp = sc->mp;
> +	int			log_flags = 0;
> +	int			error = 0;
> +
> +	/* We require the rmapbt to rebuild anything. */
> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		return -EOPNOTSUPP;
> +
> +	xchk_perag_get(sc->mp, &sc->sa);
> +
> +	/* Collect the free space data and find the old btree blocks. */
> +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
> +	INIT_LIST_HEAD(&inode_records);
> +	xfs_bitmap_init(&old_iallocbt_blocks);
> +	error = xrep_ibt_find_inodes(sc, &inode_records, &old_iallocbt_blocks);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * Blow out the old inode btrees.  This is the point at which
> +	 * we are no longer able to bail out gracefully.
> +	 */
> +	error = xrep_ibt_reset_counters(sc, &inode_records, &log_flags);
> +	if (error)
> +		goto out;
> +	error = xrep_ibt_reset_btrees(sc, &oinfo, &log_flags);
> +	if (error)
> +		goto out;
> +	error = xrep_ibt_commit_new(sc, &old_iallocbt_blocks, log_flags);
> +	if (error)
> +		goto out;
> +
> +	/* Now rebuild the inode information. */
> +	error = xrep_ibt_rebuild_trees(sc, &inode_records, &oinfo,
> +			&old_iallocbt_blocks);
> +	if (error)
> +		goto out;
> +out:
> +	xrep_ibt_cancel_inorecs(&inode_records);
> +	xfs_bitmap_destroy(&old_iallocbt_blocks);
> +	return error;
> +}
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 17cf48564390..a44deb6f06ab 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -880,3 +880,23 @@ xrep_ino_dqattach(
>  
>  	return error;
>  }
> +
> +/*
> + * Reinitialize the per-AG block reservation for the AG we just fixed.
> + */
> +int
> +xrep_reset_perag_resv(
> +	struct xfs_scrub	*sc)
> +{
> +	int			error;
> +
> +	ASSERT(sc->ops->type == ST_PERAG);
> +	ASSERT(sc->tp);
> +
> +	error = xfs_ag_resv_free(sc->sa.pag);
> +	if (error)
> +		goto out;
> +	error = xfs_ag_resv_init(sc->sa.pag, sc->tp);
> +out:
> +	return error;
> +}
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index bc1a5f1cbcdc..0cc53dee3228 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -53,6 +53,7 @@ int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
>  		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
>  void xrep_force_quotacheck(struct xfs_scrub *sc, uint dqtype);
>  int xrep_ino_dqattach(struct xfs_scrub *sc);
> +int xrep_reset_perag_resv(struct xfs_scrub *sc);
>  
>  /* Metadata repairers */
>  
> @@ -62,6 +63,7 @@ int xrep_agf(struct xfs_scrub *sc);
>  int xrep_agfl(struct xfs_scrub *sc);
>  int xrep_agi(struct xfs_scrub *sc);
>  int xrep_allocbt(struct xfs_scrub *sc);
> +int xrep_iallocbt(struct xfs_scrub *sc);
>  
>  #else
>  
> @@ -83,12 +85,21 @@ xrep_calc_ag_resblks(
>  	return 0;
>  }
>  
> +static inline int
> +xrep_reset_perag_resv(
> +	struct xfs_scrub	*sc)
> +{
> +	ASSERT(0);
> +	return -EOPNOTSUPP;
> +}
> +
>  #define xrep_probe			xrep_notsupported
>  #define xrep_superblock			xrep_notsupported
>  #define xrep_agf			xrep_notsupported
>  #define xrep_agfl			xrep_notsupported
>  #define xrep_agi			xrep_notsupported
>  #define xrep_allocbt			xrep_notsupported
> +#define xrep_iallocbt			xrep_notsupported
>  
>  #endif /* CONFIG_XFS_ONLINE_REPAIR */
>  
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 2133a3199372..631b0b06db99 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -244,14 +244,14 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_ag_iallocbt,
>  		.scrub	= xchk_inobt,
> -		.repair	= xrep_notsupported,
> +		.repair	= xrep_iallocbt,
>  	},
>  	[XFS_SCRUB_TYPE_FINOBT] = {	/* finobt */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_ag_iallocbt,
>  		.scrub	= xchk_finobt,
>  		.has	= xfs_sb_version_hasfinobt,
> -		.repair	= xrep_notsupported,
> +		.repair	= xrep_iallocbt,
>  	},
>  	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
>  		.type	= ST_PERAG,
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index af323b229c4b..762db46fd696 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -64,6 +64,7 @@ struct xfs_scrub {
>  	uint				ilock_flags;
>  	bool				try_harder;
>  	bool				has_quotaofflock;
> +	bool				reset_perag_resv;
>  
>  	/* State tracking for single-AG operations. */
>  	struct xchk_ag			sa;
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 26bd5dc68efe..9126dc66f726 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -552,7 +552,7 @@ DEFINE_EVENT(xrep_rmap_class, name, \
>  		 uint64_t owner, uint64_t offset, unsigned int flags), \
>  	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
>  DEFINE_REPAIR_RMAP_EVENT(xrep_abt_walk_rmap);
> -DEFINE_REPAIR_RMAP_EVENT(xrep_ialloc_extent_fn);
> +DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
>  DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
>  DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
>  
> @@ -700,7 +700,7 @@ TRACE_EVENT(xrep_reset_counters,
>  		  MAJOR(__entry->dev), MINOR(__entry->dev))
>  )
>  
> -TRACE_EVENT(xrep_ialloc_insert,
> +TRACE_EVENT(xrep_ibt_insert,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		 xfs_agino_t startino, uint16_t holemask, uint8_t count,
>  		 uint8_t freecount, uint64_t freemask),
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
