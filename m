Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18192 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbdJFSaw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 14:30:52 -0400
Date: Fri, 6 Oct 2017 11:30:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/25] xfs: scrub directory/attribute btrees
Message-ID: <20171006183046.GK7122@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706336266.19351.1168091901339738103.stgit@magnolia>
 <20171006050734.GR3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171006050734.GR3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>

On Fri, Oct 06, 2017 at 04:07:34PM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 01:42:42PM -0700, Darrick J. Wong wrote:
> > +/* Find an entry at a certain level in a da btree. */
> > +STATIC void *
> > +xfs_scrub_da_btree_entry(
> > +	struct xfs_scrub_da_btree	*ds,
> > +	int				level,
> > +	int				rec)
> > +{
> > +	char				*ents;
> > +	void				*(*fn)(void *);
> > +	size_t				sz;
> > +	struct xfs_da_state_blk		*blk;
> > +
> > +	/* Dispatch the entry finding function. */
> > +	blk = &ds->state->path.blk[level];
> > +	switch (blk->magic) {
> > +	case XFS_ATTR_LEAF_MAGIC:
> > +	case XFS_ATTR3_LEAF_MAGIC:
> > +		fn = (xfs_da_leaf_ents_fn)xfs_attr3_leaf_entryp;
> > +		sz = sizeof(struct xfs_attr_leaf_entry);
> > +		break;
> > +	case XFS_DIR2_LEAFN_MAGIC:
> > +	case XFS_DIR3_LEAFN_MAGIC:
> > +		fn = (xfs_da_leaf_ents_fn)ds->dargs.dp->d_ops->leaf_ents_p;
> > +		sz = sizeof(struct xfs_dir2_leaf_entry);
> > +		break;
> > +	case XFS_DIR2_LEAF1_MAGIC:
> > +	case XFS_DIR3_LEAF1_MAGIC:
> > +		fn = (xfs_da_leaf_ents_fn)ds->dargs.dp->d_ops->leaf_ents_p;
> > +		sz = sizeof(struct xfs_dir2_leaf_entry);
> > +		break;
> > +	case XFS_DA_NODE_MAGIC:
> > +	case XFS_DA3_NODE_MAGIC:
> > +		fn = (xfs_da_leaf_ents_fn)ds->dargs.dp->d_ops->node_tree_p;
> > +		sz = sizeof(struct xfs_da_node_entry);
> > +		break;
> > +	default:
> > +		return NULL;
> > +	}
> > +
> > +	ents = fn(blk->bp->b_addr);
> > +	return ents + (sz * rec);
> > +}
> 
> This looks kinda unnecesarily abstracted.
> 
> 	case XFS_ATTR_LEAF_MAGIC:
> 	case XFS_ATTR3_LEAF_MAGIC:
> 		ents = xfs_attr3_leaf_entryp(blk->bp->b_addr);
> 		return ents + (rec * sizeof(struct xfs_attr_leaf_entry));
> 
> 	case XFS_DIR2_LEAF1_MAGIC:
> 	case XFS_DIR3_LEAF1_MAGIC:
> 	case XFS_DIR2_LEAFN_MAGIC:
> 	case XFS_DIR3_LEAFN_MAGIC:
> 		ents = ds->dargs.dp->d_ops->leaf_ents_p(blk->bp->b_addr);
> 		return ents + (rec * sizeof(struct xfs_dir2_leaf_entry));
> 
> 	case XFS_DA_NODE_MAGIC:
> 	case XFS_DA3_NODE_MAGIC:
> 		ents = ds->dargs.dp->d_ops->node_tree_p(blk->bp->b_addr)
> 		return ents + (rec * sizeof(struct xfs_da_node_entry));
> 

Ok.

> 
> > +
> > +/* Scrub a da btree hash (key). */
> > +int
> > +xfs_scrub_da_btree_hash(
> > +	struct xfs_scrub_da_btree	*ds,
> > +	int				level,
> > +	__be32				*hashp)
> > +{
> > +	struct xfs_da_state_blk		*blks;
> > +	struct xfs_da_node_entry	*btree;
> 
> *entry?
> 
> > +	xfs_dahash_t			hash;
> > +	xfs_dahash_t			parent_hash;
> > +
> > +	/* Is this hash in order? */
> > +	hash = be32_to_cpu(*hashp);
> > +	if (hash < ds->hashes[level])
> > +		xfs_scrub_da_set_corrupt(ds, level);
> > +	ds->hashes[level] = hash;
> > +
> > +	if (level == 0)
> > +		return 0;
> > +
> > +	/* Is this hash no larger than the parent hash? */
> > +	blks = ds->state->path.blk;
> > +	btree = xfs_scrub_da_btree_entry(ds, level - 1, blks[level - 1].index);
> 
> entry = ?

Makes sense.

> > +	parent_hash = be32_to_cpu(btree->hashval);
> > +	if (parent_hash < hash)
> > +		xfs_scrub_da_set_corrupt(ds, level);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Check a da btree pointer.  Returns true if it's ok to use this
> > + * pointer.
> > + */
> > +STATIC bool
> > +xfs_scrub_da_btree_ptr_ok(
> > +	struct xfs_scrub_da_btree	*ds,
> > +	int				level,
> > +	xfs_dablk_t			blkno)
> > +{
> > +	if (blkno < ds->lowest || (ds->highest != 0 && blkno >= ds->highest)) {
> > +		xfs_scrub_da_set_corrupt(ds, level);
> > +		return false;
> > +	}
> 
> Not sure what lowest and highest are here - the structure definition
> is not commented. I /think/ it's the offset within the dierctory
> address space for the leaf pointers (i.e. XFS_DIR2_LEAF_OFFSET ->
> XFS_DIR2_FREE_OFFSET for directories), but I'm mostly guessing from
> context here...

Correct.  Will add:

/*
 * Lowest and highest directory block address in which we expect
 * to find dir/attr btree node blocks.  For a directory this
 * (presumably) means between LEAF_OFFSET and FREE_OFFSET; for
 * attributes there is no limit.
 */

> > +
> > +	return true;
> > +}
> > +
> > +/*
> > + * The da btree scrubber can handle leaf1 blocks as a degenerate
> > + * form of da btree.  Since the regular da code doesn't handle
> 
> degenerate form of LEAFN blocks?

Oops, corrected.

> > +
> > +/* Check a block's sibling. */
> > +STATIC int
> > +xfs_scrub_da_btree_block_check_sibling(
> > +	struct xfs_scrub_da_btree	*ds,
> > +	int				level,
> > +	int				direction,
> > +	xfs_dablk_t			sibling)
> > +{
> > +	int				retval;
> > +	int				error;
> > +
> > +	if (!sibling)
> > +		return 0;
> > +
> > +	/* Move the alternate cursor back one block. */
> 
> Move the alternate cursor one block in the direction specified?

Yes, corrected.

> > +	memcpy(&ds->state->altpath, &ds->state->path,
> > +			sizeof(ds->state->altpath));
> > +	error = xfs_da3_path_shift(ds->state, &ds->state->altpath,
> > +			direction, false, &retval);
> > +	if (!xfs_scrub_da_op_ok(ds, level, &error))
> > +		return error;
> > +	if (retval) {
> > +		xfs_scrub_da_set_corrupt(ds, level);
> > +		return error;
> > +	}
> > +
> > +	if (ds->state->altpath.blk[level].blkno != sibling)
> > +		xfs_scrub_da_set_corrupt(ds, level);
> > +	xfs_trans_brelse(ds->dargs.trans, ds->state->altpath.blk[level].bp);
> > +	return error;
> > +}
> > +
> > +/* Check a block's sibling pointers. */
> > +STATIC int
> > +xfs_scrub_da_btree_block_check_siblings(
> > +	struct xfs_scrub_da_btree	*ds,
> > +	int				level,
> > +	struct xfs_da_blkinfo		*hdr)
> > +{
> > +	xfs_dablk_t			forw;
> > +	xfs_dablk_t			back;
> > +	int				error = 0;
> > +
> > +	forw = be32_to_cpu(hdr->forw);
> > +	back = be32_to_cpu(hdr->back);
> > +
> > +	/* Top level blocks should not have sibling pointers. */
> > +	if (level == 0) {
> > +		if (forw != 0 || back != 0)
> > +			xfs_scrub_da_set_corrupt(ds, level);
> > +		return error;
> 
> Error is always zero here?

Yes.

> > +	}
> > +
> > +	/*
> > +	 * Check back (left) and forw (right) pointers.  These functions
> > +	 * absorb error codes for us.
> > +	 */
> > +	error = xfs_scrub_da_btree_block_check_sibling(ds, level, 0, back);
> > +	if (error)
> > +		goto out;
> > +	error = xfs_scrub_da_btree_block_check_sibling(ds, level, 1, forw);
> > +
> > +out:
> > +	memset(&ds->state->altpath, 0, sizeof(ds->state->altpath));
> > +	return error;
> > +}
> > +
> > +/* Load a dir/attribute block from a btree. */
> > +STATIC int
> > +xfs_scrub_da_btree_block(
> > +	struct xfs_scrub_da_btree	*ds,
> > +	int				level,
> > +	xfs_dablk_t			blkno)
> > +{
> > +	struct xfs_da_state_blk		*blk;
> > +	struct xfs_da_intnode		*node;
> > +	struct xfs_da_node_entry	*btree;
> > +	struct xfs_da3_blkinfo		*hdr3;
> > +	struct xfs_da_args		*dargs = &ds->dargs;
> > +	struct xfs_inode		*ip = ds->dargs.dp;
> > +	xfs_ino_t			owner;
> > +	int				*pmaxrecs;
> > +	struct xfs_da3_icnode_hdr	nodehdr;
> > +	int				error;
> > +
> > +	blk = &ds->state->path.blk[level];
> > +	ds->state->path.active = level + 1;
> > +
> > +	/* Release old block. */
> > +	if (blk->bp) {
> > +		xfs_trans_brelse(dargs->trans, blk->bp);
> > +		blk->bp = NULL;
> > +	}
> > +
> > +	/* Check the pointer. */
> > +	blk->blkno = blkno;
> > +	if (!xfs_scrub_da_btree_ptr_ok(ds, level, blkno))
> > +		goto out_nobuf;
> > +
> > +	/* Read the buffer. */
> > +	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno, -2,
> > +			&blk->bp, dargs->whichfork,
> > +			&xfs_scrub_da_btree_buf_ops);
> 
> Hmmm - this verifier only special cases LEAF1 blocks, no comments as
> to why it treats everything else as a with the node verifier. DOn't
> we have to special case the attr leaf blocks here as well?

The xfs_da3_node_buf_ops functions already know how to check DA*_NODE,
ATTR*_LEAF, and DIR*_LEAFN blocks; we're only adding DIR*_LEAF1 blocks
to the mix.

Added comment to xfs_scrub_da_btree_{read,write}_verify:

/*
 * xfs_da3_node_buf_ops already know how to handle
 * DA*_NODE, ATTR*_LEAF, and DIR*_LEAFN blocks.
 */

> > +	if (!xfs_scrub_da_op_ok(ds, level, &error))
> > +		goto out_nobuf;
> > +
> > +	/* It's ok for a directory not to have a da btree in it. */
> > +	if (ds->dargs.whichfork == XFS_DATA_FORK && level == 0 &&
> > +			blk->bp == NULL)
> > +		goto out_nobuf;
> 
> What case is that? single block form? Need a magic number check
> here if that's the case?

It's the same case as the "didn't find a dabtree root block so just jump
out of dabtree checking entirely" case below.  Basically,
xfs_scrub_da_btree asks xfs_scrub_da_btree_block first to find it the
block at offset ds.lowest; if _block doesn't find anything mapped there
then it returns a NULL bp, and the outer function sees the NULL bp and
itself jumps out.

Added comment:

/*
 * We didn't find a dir btree root block, which means that
 * there's no LEAF1/LEAFN tree (at least not where it's supposed
 * to be), so jump out now.
 */

> > +/* Visit all nodes and leaves of a da btree. */
> > +int
> > +xfs_scrub_da_btree(
> > +	struct xfs_scrub_context	*sc,
> > +	int				whichfork,
> > +	xfs_scrub_da_btree_rec_fn	scrub_fn)
> > +{
> > +	struct xfs_scrub_da_btree	ds;
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_da_state_blk		*blks;
> > +	struct xfs_da_node_entry	*key;
> > +	void				*rec;
> > +	xfs_dablk_t			blkno;
> > +	bool				is_attr;
> > +	int				level;
> > +	int				error;
> > +
> > +	memset(&ds, 0, sizeof(ds));
> 
> I almost missed this - had to go looking later for why the
> ds.maxrecs[] started off at zero. Can we change this to be
> initialised to zero at declaration like so:
> 
> 	struct xfs_scrub_da_btree	ds = {};

Sure.

> > +	/* Skip short format data structures; no btree to scan. */
> > +	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> > +	    XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE)
> > +		return 0;
> > +
> > +	/* Set up initial da state. */
> > +	is_attr = whichfork == XFS_ATTR_FORK;
> > +	ds.dargs.geo = is_attr ? mp->m_attr_geo : mp->m_dir_geo;
> > +	ds.dargs.dp = sc->ip;
> > +	ds.dargs.whichfork = whichfork;
> > +	ds.dargs.trans = sc->tp;
> > +	ds.dargs.op_flags = XFS_DA_OP_OKNOENT;
> > +	ds.state = xfs_da_state_alloc();
> > +	ds.state->args = &ds.dargs;
> > +	ds.state->mp = mp;
> > +	ds.sc = sc;
> > +	blkno = ds.lowest = is_attr ? 0 : ds.dargs.geo->leafblk;
> > +	ds.highest = is_attr ? 0 : ds.dargs.geo->freeblk;
> > +	level = 0;
> 
> bit hard to read with all the ?: constructs. Can we make this:
> 
> 	if (whichfork == XFS_ATTR_FORK) {
> 		ds.dargs.geo = ...
> 		ds.lowest = ..
> 		ds.highest = ...
> 	} else {
> 		....
> 	}
> 	......
> 
> 	blkno = ds.lowest;

Done.

> > +
> > +	/* Find the root of the da tree, if present. */
> > +	blks = ds.state->path.blk;
> > +	error = xfs_scrub_da_btree_block(&ds, level, blkno);
> > +	if (error)
> > +		goto out_state;
> > +	if (blks[level].bp == NULL)
> > +		goto out_state;
> 
> So for a single block directory, we'll jump out here because it's
> at block zero and there's nothing at mp->m_dir_geo.leafblk.
> That means the loop will only ever handle LEAF1/LEAFN format
> directory structures. Correct? (comment?)

Right.

/*
 * We didn't find a block at ds.lowest, which means that there's
 * no LEAF1/LEAFN tree (at least not where it's supposed to be),
 * so jump out now.
 */

> > +	blks[level].index = 0;
> > +	while (level >= 0 && level < XFS_DA_NODE_MAXDEPTH) {
> > +		/* Handle leaf block. */
> > +		if (blks[level].magic != XFS_DA_NODE_MAGIC) {
> > +			/* End of leaf, pop back towards the root. */
> > +			if (blks[level].index >= ds.maxrecs[level]) {
> > +				if (level > 0)
> > +					blks[level - 1].index++;
> > +				ds.tree_level++;
> > +				level--;
> > +				continue;
> > +			}
> > +
> > +			/* Dispatch record scrubbing. */
> > +			rec = xfs_scrub_da_btree_entry(&ds, level,
> > +					blks[level].index);
> > +			error = scrub_fn(&ds, level, rec);
> > +			if (error < 0 ||
> > +			    error == XFS_BTREE_QUERY_RANGE_ABORT)
> 
> When would we get a XFS_BTREE_QUERY_RANGE_ABORT error?

In theory the scrub_fn could return that to signal a non-error abort.
Between the dabtree and the btree scrubbers none of them actually do that,
so in theory this could be removed.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
