Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:11784 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751439AbeDFAwy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 20:52:54 -0400
Date: Fri, 6 Apr 2018 10:52:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/21] xfs: add helper routines for the repair code
Message-ID: <20180406005251.GO23861@dastard>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269903810.16346.11410639151264264247.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152269903810.16346.11410639151264264247.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 02, 2018 at 12:57:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add some helper functions for repair functions that will help us to
> allocate and initialize new metadata blocks for btrees that we're
> rebuilding.

This is more than "helper functions" - my replay is almost 700 lines
long!

i.e. This is a stack of extent invalidation, freeing and rmap/free
space rebuild code. Needs a lot more description and context than
"helper functions".

.....
> @@ -574,7 +575,10 @@ xfs_scrub_setup_fs(
>  	struct xfs_scrub_context	*sc,
>  	struct xfs_inode		*ip)
>  {
> -	return xfs_scrub_trans_alloc(sc->sm, sc->mp, &sc->tp);
> +	uint				resblks;
> +
> +	resblks = xfs_repair_calc_ag_resblks(sc);
> +	return xfs_scrub_trans_alloc(sc->sm, sc->mp, resblks, &sc->tp);
>  }

What's the block reservation for?

> +/*
> + * Roll a transaction, keeping the AG headers locked and reinitializing
> + * the btree cursors.
> + */
> +int
> +xfs_repair_roll_ag_trans(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_trans		*tp;
> +	int				error;
> +
> +	/* Keep the AG header buffers locked so we can keep going. */
> +	xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
> +	xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
> +	xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
> +
> +	/* Roll the transaction. */
> +	tp = sc->tp;
> +	error = xfs_trans_roll(&sc->tp);
> +	if (error)
> +		return error;

Who releases those buffers if we get an error here?

> +
> +	/* Join the buffer to the new transaction or release the hold. */
> +	if (sc->tp != tp) {

When does xfs_trans_roll() return successfully without allocating a
new transaction?

> +		xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
> +		xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
> +		xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
> +	} else {
> +		xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
> +		xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
> +		xfs_trans_bhold_release(sc->tp, sc->sa.agfl_bp);
> +	}
> +
> +	return error;
> +}
.....

> +/* Allocate a block in an AG. */
> +int
> +xfs_repair_alloc_ag_block(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_owner_info		*oinfo,
> +	xfs_fsblock_t			*fsbno,
> +	enum xfs_ag_resv_type		resv)
> +{
> +	struct xfs_alloc_arg		args = {0};
> +	xfs_agblock_t			bno;
> +	int				error;
> +
> +	if (resv == XFS_AG_RESV_AGFL) {
> +		error = xfs_alloc_get_freelist(sc->tp, sc->sa.agf_bp, &bno, 1);
> +		if (error)
> +			return error;
> +		if (bno == NULLAGBLOCK)
> +			return -ENOSPC;
> +		xfs_extent_busy_reuse(sc->mp, sc->sa.agno, bno,
> +				1, false);
> +		*fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, bno);
> +		return 0;
> +	}
> +
> +	args.tp = sc->tp;
> +	args.mp = sc->mp;
> +	args.oinfo = *oinfo;
> +	args.fsbno = XFS_AGB_TO_FSB(args.mp, sc->sa.agno, 0);

So our target BNO is the start of the AG.

> +	args.minlen = 1;
> +	args.maxlen = 1;
> +	args.prod = 1;
> +	args.type = XFS_ALLOCTYPE_NEAR_BNO;

And we do a "near" search" for a single block. i.e. we are looking
for a single block near to the start of the AG. Basically, we are
looking for the extent at the left edge of the by-bno tree, which
may not be a single block.

Would it be better to do a XFS_ALLOCTYPE_THIS_AG allocation here so
we look up the by-size btree for a single block extent? The left
edge of that tree will always be the smallest free extent closest to
the start of the AG, and so using THIS_AG will tend to fill
small freespace holes rather than tear up larger free spaces for
single block allocations.....

> +/* Put a block back on the AGFL. */
> +int
> +xfs_repair_put_freelist(
> +	struct xfs_scrub_context	*sc,
> +	xfs_agblock_t			agbno)
> +{
> +	struct xfs_owner_info		oinfo;
> +	int				error;
> +
> +	/*
> +	 * Since we're "freeing" a lost block onto the AGFL, we have to
> +	 * create an rmap for the block prior to merging it or else other
> +	 * parts will break.
> +	 */
> +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> +	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
> +			&oinfo);
> +	if (error)
> +		return error;
> +
> +	/* Put the block on the AGFL. */
> +	error = xfs_alloc_put_freelist(sc->tp, sc->sa.agf_bp, sc->sa.agfl_bp,
> +			agbno, 0);

At what point do we check there's actually room in the AGFL for this
block?

> +	if (error)
> +		return error;
> +	xfs_extent_busy_insert(sc->tp, sc->sa.agno, agbno, 1,
> +			XFS_EXTENT_BUSY_SKIP_DISCARD);
> +
> +	/* Make sure the AGFL doesn't overfill. */
> +	return xfs_repair_fix_freelist(sc, true);

i.e. shouldn't this be done first?

> +}
> +
> +/*
> + * For a given metadata extent and owner, delete the associated rmap.
> + * If the block has no other owners, free it.
> + */
> +STATIC int
> +xfs_repair_free_or_unmap_extent(
> +	struct xfs_scrub_context	*sc,
> +	xfs_fsblock_t			fsbno,
> +	xfs_extlen_t			len,
> +	struct xfs_owner_info		*oinfo,
> +	enum xfs_ag_resv_type		resv)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_btree_cur		*rmap_cur;
> +	struct xfs_buf			*agf_bp = NULL;
> +	xfs_agnumber_t			agno;
> +	xfs_agblock_t			agbno;
> +	bool				has_other_rmap;
> +	int				error = 0;
> +
> +	ASSERT(xfs_sb_version_hasrmapbt(&mp->m_sb));
> +	agno = XFS_FSB_TO_AGNO(mp, fsbno);
> +	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
> +
> +	trace_xfs_repair_free_or_unmap_extent(mp, agno, agbno, len);
> +
> +	for (; len > 0 && !error; len--, agbno++, fsbno++) {
> +		ASSERT(sc->ip != NULL || agno == sc->sa.agno);
> +
> +		/* Can we find any other rmappings? */
> +		if (sc->ip) {
> +			error = xfs_alloc_read_agf(mp, sc->tp, agno, 0,
> +					&agf_bp);
> +			if (error)
> +				break;
> +			if (!agf_bp) {
> +				error = -ENOMEM;
> +				break;
> +			}
> +		}
> +		rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp,
> +				agf_bp ? agf_bp : sc->sa.agf_bp, agno);

Why is the inode case treated differently here - why do we have a
special reference to agf_bp here rather than using sc->sa.agf_bp?


> +		error = xfs_rmap_has_other_keys(rmap_cur, agbno, 1, oinfo,
> +				&has_other_rmap);
> +		if (error)
> +			goto out_cur;
> +		xfs_btree_del_cursor(rmap_cur, XFS_BTREE_NOERROR);
> +		if (agf_bp)
> +			xfs_trans_brelse(sc->tp, agf_bp);

agf_bp released here.

> +
> +		/*
> +		 * If there are other rmappings, this block is cross
> +		 * linked and must not be freed.  Remove the reverse
> +		 * mapping and move on.  Otherwise, we were the only
> +		 * owner of the block, so free the extent, which will
> +		 * also remove the rmap.
> +		 */
> +		if (has_other_rmap)
> +			error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1,
> +					oinfo);

And then used here. Use-after-free?

> +		else if (resv == XFS_AG_RESV_AGFL)
> +			error = xfs_repair_put_freelist(sc, agbno);
> +		else
> +			error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
> +		if (error)
> +			break;
> +
> +		if (sc->ip)
> +			error = xfs_trans_roll_inode(&sc->tp, sc->ip);
> +		else
> +			error = xfs_repair_roll_ag_trans(sc);

why don't we break on error here?

> +	}
> +
> +	return error;
> +out_cur:
> +	xfs_btree_del_cursor(rmap_cur, XFS_BTREE_ERROR);
> +	if (agf_bp)
> +		xfs_trans_brelse(sc->tp, agf_bp);
> +	return error;

Can you put a blank line preceeding the out label so there is clear
separation between the normal return code and error handling stack?

> +}
> +
> +/* Collect a dead btree extent for later disposal. */
> +int
> +xfs_repair_collect_btree_extent(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_repair_extent_list	*exlist,
> +	xfs_fsblock_t			fsbno,
> +	xfs_extlen_t			len)
> +{
> +	struct xfs_repair_extent	*rae;

What's "rae" short for? "rex" I'd understand, but I can't work out
what the "a" in rae means :/

> +
> +	trace_xfs_repair_collect_btree_extent(sc->mp,
> +			XFS_FSB_TO_AGNO(sc->mp, fsbno),
> +			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
> +
> +	rae = kmem_alloc(sizeof(struct xfs_repair_extent),
> +			KM_MAYFAIL | KM_NOFS);

Why KM_NOFS?

> +	if (!rae)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&rae->list);
> +	rae->fsbno = fsbno;
> +	rae->len = len;
> +	list_add_tail(&rae->list, &exlist->list);
> +
> +	return 0;
> +}
> +
> +/* Invalidate buffers for blocks we're dumping. */
> +int
> +xfs_repair_invalidate_blocks(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_repair_extent_list	*exlist)
> +{
> +	struct xfs_repair_extent	*rae;
> +	struct xfs_repair_extent	*n;
> +	struct xfs_buf			*bp;
> +	xfs_agnumber_t			agno;
> +	xfs_agblock_t			agbno;
> +	xfs_agblock_t			i;
> +
> +	for_each_xfs_repair_extent_safe(rae, n, exlist) {
> +		agno = XFS_FSB_TO_AGNO(sc->mp, rae->fsbno);
> +		agbno = XFS_FSB_TO_AGBNO(sc->mp, rae->fsbno);
> +		for (i = 0; i < rae->len; i++) {
> +			bp = xfs_btree_get_bufs(sc->mp, sc->tp, agno,
> +					agbno + i, 0);
> +			xfs_trans_binval(sc->tp, bp);
> +		}
> +	}

What if they are data blocks we are dumping? xfs_trans_binval is
fine for metadata blocks, but creating a stale metadata buffer and
logging a buffer cancel for user data blocks doesn't make any sense
to me....

> +/* Dispose of dead btree extents.  If oinfo is NULL, just delete the list. */
> +int
> +xfs_repair_reap_btree_extents(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_repair_extent_list	*exlist,
> +	struct xfs_owner_info		*oinfo,
> +	enum xfs_ag_resv_type		type)
> +{
> +	struct xfs_repair_extent	*rae;
> +	struct xfs_repair_extent	*n;
> +	int				error = 0;
> +
> +	for_each_xfs_repair_extent_safe(rae, n, exlist) {
> +		if (oinfo) {
> +			error = xfs_repair_free_or_unmap_extent(sc, rae->fsbno,
> +					rae->len, oinfo, type);
> +			if (error)
> +				oinfo = NULL;
> +		}
> +		list_del(&rae->list);
> +		kmem_free(rae);
> +	}
> +
> +	return error;
> +}

So does this happen before or after the extent list invalidation?

> +/* Errors happened, just delete the dead btree extent list. */
> +void
> +xfs_repair_cancel_btree_extents(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_repair_extent_list	*exlist)
> +{
> +	xfs_repair_reap_btree_extents(sc, exlist, NULL, XFS_AG_RESV_NONE);
> +}

So if an error happened durign rebuild, we just trash whatever we
were trying to rebuild?

> +/* Compare two btree extents. */
> +static int
> +xfs_repair_btree_extent_cmp(
> +	void				*priv,
> +	struct list_head		*a,
> +	struct list_head		*b)
> +{
> +	struct xfs_repair_extent	*ap;
> +	struct xfs_repair_extent	*bp;
> +
> +	ap = container_of(a, struct xfs_repair_extent, list);
> +	bp = container_of(b, struct xfs_repair_extent, list);
> +
> +	if (ap->fsbno > bp->fsbno)
> +		return 1;
> +	else if (ap->fsbno < bp->fsbno)
> +		return -1;
> +	return 0;
> +}
> +
> +/* Remove all the blocks in sublist from exlist. */
> +#define LEFT_CONTIG	(1 << 0)
> +#define RIGHT_CONTIG	(1 << 1)

Namespace, please.

> +int
> +xfs_repair_subtract_extents(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_repair_extent_list	*exlist,
> +	struct xfs_repair_extent_list	*sublist)

What is this function supposed to do? I can't really review the code
(looks complex) because I don't know what it's function is supposed
to be.

> +struct xfs_repair_find_ag_btree_roots_info {
> +	struct xfs_buf			*agfl_bp;
> +	struct xfs_repair_find_ag_btree	*btree_info;
> +};
> +
> +/* Is this an OWN_AG block in the AGFL? */
> +STATIC bool
> +xfs_repair_is_block_in_agfl(
> +	struct xfs_mount		*mp,
> +	uint64_t			rmap_owner,
> +	xfs_agblock_t			agbno,
> +	struct xfs_buf			*agf_bp,
> +	struct xfs_buf			*agfl_bp)
> +{
> +	struct xfs_agf			*agf;
> +	__be32				*agfl_bno;
> +	unsigned int			flfirst;
> +	unsigned int			fllast;
> +	int				i;
> +
> +	if (rmap_owner != XFS_RMAP_OWN_AG)
> +		return false;
> +
> +	agf = XFS_BUF_TO_AGF(agf_bp);
> +	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
> +	flfirst = be32_to_cpu(agf->agf_flfirst);
> +	fllast = be32_to_cpu(agf->agf_fllast);
> +
> +	/* Skip an empty AGFL. */
> +	if (agf->agf_flcount == cpu_to_be32(0))
> +		return false;
> +
> +	/* first to last is a consecutive list. */
> +	if (fllast >= flfirst) {
> +		for (i = flfirst; i <= fllast; i++) {
> +			if (be32_to_cpu(agfl_bno[i]) == agbno)
> +				return true;
> +		}
> +
> +		return false;
> +	}
> +
> +	/* first to the end */
> +	for (i = flfirst; i < xfs_agfl_size(mp); i++) {
> +		if (be32_to_cpu(agfl_bno[i]) == agbno)
> +			return true;
> +	}
> +
> +	/* the start to last. */
> +	for (i = 0; i <= fllast; i++) {
> +		if (be32_to_cpu(agfl_bno[i]) == agbno)
> +			return true;
> +	}
> +
> +	return false;

Didn't you just create a generic agfl walk function for this?

> +}
> +
> +/* Find btree roots from the AGF. */
> +STATIC int
> +xfs_repair_find_ag_btree_roots_helper(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_rmap_irec		*rec,
> +	void				*priv)

Again, I'm not sure exactly what this function is doing. It look
slike it's trying to tell if a freed block is a btree block,
but I'm not sure of that, nor the context in which we'd be searching
free blocks for a specific metadata contents.

> +/* Find the roots of the given btrees from the rmap info. */
> +int
> +xfs_repair_find_ag_btree_roots(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_buf			*agf_bp,
> +	struct xfs_repair_find_ag_btree	*btree_info,
> +	struct xfs_buf			*agfl_bp)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_repair_find_ag_btree_roots_info	ri;
> +	struct xfs_repair_find_ag_btree	*fab;
> +	struct xfs_btree_cur		*cur;
> +	int				error;
> +
> +	ri.btree_info = btree_info;
> +	ri.agfl_bp = agfl_bp;
> +	for (fab = btree_info; fab->buf_ops; fab++) {
> +		ASSERT(agfl_bp || fab->rmap_owner != XFS_RMAP_OWN_AG);
> +		fab->root = NULLAGBLOCK;
> +		fab->level = 0;
> +	}
> +
> +	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
> +	error = xfs_rmap_query_all(cur, xfs_repair_find_ag_btree_roots_helper,
> +			&ri);
> +	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +
> +	for (fab = btree_info; !error && fab->buf_ops; fab++)
> +		if (fab->root != NULLAGBLOCK)
> +			fab->level++;
> +
> +	return error;
> +}
> +
> +/* Reset the superblock counters from the AGF/AGI. */
> +int
> +xfs_repair_reset_counters(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_trans	*tp;
> +	struct xfs_buf		*agi_bp;
> +	struct xfs_buf		*agf_bp;
> +	struct xfs_agi		*agi;
> +	struct xfs_agf		*agf;
> +	xfs_agnumber_t		agno;
> +	xfs_ino_t		icount = 0;
> +	xfs_ino_t		ifree = 0;
> +	xfs_filblks_t		fdblocks = 0;
> +	int64_t			delta_icount;
> +	int64_t			delta_ifree;
> +	int64_t			delta_fdblocks;
> +	int			error;
> +
> +	trace_xfs_repair_reset_counters(mp);
> +
> +	error = xfs_trans_alloc_empty(mp, &tp);
> +	if (error)
> +		return error;
> +
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		/* Count all the inodes... */
> +		error = xfs_ialloc_read_agi(mp, tp, agno, &agi_bp);
> +		if (error)
> +			goto out;
> +		agi = XFS_BUF_TO_AGI(agi_bp);
> +		icount += be32_to_cpu(agi->agi_count);
> +		ifree += be32_to_cpu(agi->agi_freecount);
> +
> +		/* Add up the free/freelist/bnobt/cntbt blocks... */
> +		error = xfs_alloc_read_agf(mp, tp, agno, 0, &agf_bp);
> +		if (error)
> +			goto out;
> +		if (!agf_bp) {
> +			error = -ENOMEM;
> +			goto out;
> +		}
> +		agf = XFS_BUF_TO_AGF(agf_bp);
> +		fdblocks += be32_to_cpu(agf->agf_freeblks);
> +		fdblocks += be32_to_cpu(agf->agf_flcount);
> +		fdblocks += be32_to_cpu(agf->agf_btreeblks);
> +	}
> +
> +	/*
> +	 * Reinitialize the counters.  The on-disk and in-core counters
> +	 * differ by the number of inodes/blocks reserved by the admin,
> +	 * the per-AG reservation, and any transactions in progress, so
> +	 * we have to account for that.
> +	 */
> +	spin_lock(&mp->m_sb_lock);
> +	delta_icount = (int64_t)mp->m_sb.sb_icount - icount;
> +	delta_ifree = (int64_t)mp->m_sb.sb_ifree - ifree;
> +	delta_fdblocks = (int64_t)mp->m_sb.sb_fdblocks - fdblocks;
> +	mp->m_sb.sb_icount = icount;
> +	mp->m_sb.sb_ifree = ifree;
> +	mp->m_sb.sb_fdblocks = fdblocks;
> +	spin_unlock(&mp->m_sb_lock);

This is largely a copy and paste of the code run by mount after log
recovery on an unclean mount. Can you factor this into a single
function?

> +
> +	if (delta_icount) {
> +		error = xfs_mod_icount(mp, delta_icount);
> +		if (error)
> +			goto out;
> +	}
> +	if (delta_ifree) {
> +		error = xfs_mod_ifree(mp, delta_ifree);
> +		if (error)
> +			goto out;
> +	}
> +	if (delta_fdblocks) {
> +		error = xfs_mod_fdblocks(mp, delta_fdblocks, false);
> +		if (error)
> +			goto out;
> +	}
> +
> +out:
> +	xfs_trans_cancel(tp);
> +	return error;

Ummmm - why do we do all this superblock modification work in a
transaction context, and then just cancel it?

> +}
> +
> +/* Figure out how many blocks to reserve for an AG repair. */
> +xfs_extlen_t
> +xfs_repair_calc_ag_resblks(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_scrub_metadata	*sm = sc->sm;
> +	struct xfs_agi			*agi;
> +	struct xfs_agf			*agf;
> +	struct xfs_buf			*bp;
> +	xfs_agino_t			icount;
> +	xfs_extlen_t			aglen;
> +	xfs_extlen_t			usedlen;
> +	xfs_extlen_t			freelen;
> +	xfs_extlen_t			bnobt_sz;
> +	xfs_extlen_t			inobt_sz;
> +	xfs_extlen_t			rmapbt_sz;
> +	xfs_extlen_t			refcbt_sz;
> +	int				error;
> +
> +	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
> +		return 0;
> +
> +	/*
> +	 * Try to get the actual counters from disk; if not, make
> +	 * some worst case assumptions.
> +	 */
> +	error = xfs_read_agi(mp, NULL, sm->sm_agno, &bp);
> +	if (!error) {
> +		agi = XFS_BUF_TO_AGI(bp);
> +		icount = be32_to_cpu(agi->agi_count);
> +		xfs_trans_brelse(NULL, bp);

xfs_buf_relse(bp)?

And, well, why not just use pag->pagi_count rather than having to
read it from the on-disk buffer?

> +	} else {
> +		icount = mp->m_sb.sb_agblocks / mp->m_sb.sb_inopblock;
> +	}
> +
> +	error = xfs_alloc_read_agf(mp, NULL, sm->sm_agno, 0, &bp);
> +	if (!error && bp) {
> +		agf = XFS_BUF_TO_AGF(bp);
> +		aglen = be32_to_cpu(agf->agf_length);
> +		freelen = be32_to_cpu(agf->agf_freeblks);
> +		usedlen = aglen - freelen;
> +		xfs_trans_brelse(NULL, bp);
> +	} else {
> +		aglen = mp->m_sb.sb_agblocks;
> +		freelen = aglen;
> +		usedlen = aglen;
> +	}

ditto for there - it's all in the xfs_perag, right?

> +
> +	trace_xfs_repair_calc_ag_resblks(mp, sm->sm_agno, icount, aglen,
> +			freelen, usedlen);
> +
> +	/*
> +	 * Figure out how many blocks we'd need worst case to rebuild
> +	 * each type of btree.  Note that we can only rebuild the
> +	 * bnobt/cntbt or inobt/finobt as pairs.
> +	 */
> +	bnobt_sz = 2 * xfs_allocbt_calc_size(mp, freelen);
> +	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
> +		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
> +				XFS_INODES_PER_HOLEMASK_BIT);
> +	else
> +		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
> +				XFS_INODES_PER_CHUNK);
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		inobt_sz *= 2;
> +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +		rmapbt_sz = xfs_rmapbt_calc_size(mp, aglen);
> +		refcbt_sz = xfs_refcountbt_calc_size(mp, usedlen);
> +	} else {
> +		rmapbt_sz = xfs_rmapbt_calc_size(mp, usedlen);
> +		refcbt_sz = 0;
> +	}
> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		rmapbt_sz = 0;
> +
> +	trace_xfs_repair_calc_ag_resblks_btsize(mp, sm->sm_agno, bnobt_sz,
> +			inobt_sz, rmapbt_sz, refcbt_sz);
> +
> +	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));

Why are we only returning the resblks for a single tree rebuild?
Shouldn't it return the total blocks require to rebuild all all the
trees?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
