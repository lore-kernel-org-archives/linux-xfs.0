Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D57FA3728
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 15:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9051F21848
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 15:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394104AbfJPP0w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:26:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54885 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394077AbfJPP0v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Oct 2019 11:26:51 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1E8392A09AC;
        Wed, 16 Oct 2019 15:26:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92E2D60856;
        Wed, 16 Oct 2019 15:26:50 +0000 (UTC)
Date:   Wed, 16 Oct 2019 11:26:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: support bulk loading of staged btrees
Message-ID: <20191016152648.GC41077@bfoster>
References: <157063967800.2912204.4012307770844087647.stgit@magnolia>
 <157063969861.2912204.17896220944927257559.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157063969861.2912204.17896220944927257559.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 16 Oct 2019 15:26:51 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:48:18AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new btree function that enables us to bulk load a btree cursor.
> This will be used by the upcoming online repair patches to generate new
> btrees.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c |  566 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_btree.h |   43 +++
>  fs/xfs/xfs_trace.c        |    1 
>  fs/xfs/xfs_trace.h        |   85 +++++++
>  4 files changed, 694 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 4b06d5d86834..17b0fdb87729 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
...
> @@ -5104,3 +5104,567 @@ xfs_btree_commit_ifakeroot(
>  	cur->bc_ops = ops;
>  	cur->bc_flags &= ~XFS_BTREE_STAGING;
>  }
> +
> +/*
> + * Bulk Loading of Staged Btrees
> + * =============================
> + *
> + * This interface is used with a staged btree cursor to create a totally new
> + * btree with a large number of records (i.e. more than what would fit in a
> + * single block).  When the creation is complete, the new root can be linked
> + * atomically into the filesystem by committing the staged cursor.
> + *

Thanks for the documentation. So what is the purpose behind the whole
bulk loading thing as opposed to something like faking up an AG
structure (i.e. AGF) somewhere and using the existing cursor mechanisms
(or something closer to it) to copy records from one place to another?
Is it purely a performance/efficiency tradeoff? Bulk block allocation
issues? Transactional/atomicity issues? All (or none :P) of the above?

This is my first pass through this so I'm mostly looking at big picture
until I get to a point to see how these bits are used. The mechanism
itself seems reasonable in principle, but the reason I ask is it also
seems like there's inherent value in using more of same infrastructure
to reconstruct a tree that we use to create one in the first place. We
also already have primitives for things like fork swapping via the
extent swap mechanism, etc.

Brian

> + * The first step for the caller is to construct a fake btree root structure
> + * and a staged btree cursor.  A staging cursor contains all the geometry
> + * information for the btree type but will fail all operations that could have
> + * side effects in the filesystem (e.g. btree shape changes).  Regular
> + * operations will not work unless the staging cursor is committed and becomes
> + * a regular cursor.
> + *
> + * For a btree rooted in an AG header, use an xbtree_afakeroot structure.
> + * This should be initialized to zero.  For a btree rooted in an inode fork,
> + * use an xbtree_ifakeroot structure.  @if_fork_size field should be set to
> + * the number of bytes available to the fork in the inode; @if_fork should
> + * point to a freshly allocated xfs_inode_fork; and @if_format should be set
> + * to the appropriate fork type (e.g. XFS_DINODE_FMT_BTREE).
> + *
> + * The next step for the caller is to initialize a struct xfs_btree_bload
> + * context.  The @nr_records field is the number of records that are to be
> + * loaded into the btree.  The @leaf_slack and @node_slack fields are the
> + * number of records (or key/ptr) slots to leave empty in new btree blocks.
> + * If a caller sets a slack value to -1, the slack value will be computed to
> + * fill the block halfway between minrecs and maxrecs items per block.
> + *
> + * The number of items placed in each btree block is computed via the following
> + * algorithm: For leaf levels, the number of items for the level is nr_records.
> + * For node levels, the number of items for the level is the number of blocks
> + * in the next lower level of the tree.  For each level, the desired number of
> + * items per block is defined as:
> + *
> + * desired = max(minrecs, maxrecs - slack factor)
> + *
> + * The number of blocks for the level is defined to be:
> + *
> + * blocks = nr_items / desired
> + *
> + * Note this is rounded down so that the npb calculation below will never fall
> + * below minrecs.  The number of items that will actually be loaded into each
> + * btree block is defined as:
> + *
> + * npb =  nr_items / blocks
> + *
> + * Some of the leftmost blocks in the level will contain one extra record as
> + * needed to handle uneven division.  If the number of records in any block
> + * would exceed maxrecs for that level, blocks is incremented and npb is
> + * recalculated.
> + *
> + * In other words, we compute the number of blocks needed to satisfy a given
> + * loading level, then spread the items as evenly as possible.
> + *
> + * To complete this step, call xfs_btree_bload_compute_geometry, which uses
> + * those settings to compute the height of the btree and the number of blocks
> + * that will be needed to construct the btree.  These values are stored in the
> + * @btree_height and @nr_blocks fields.
> + *
> + * At this point, the caller must allocate @nr_blocks blocks and save them for
> + * later.  If space is to be allocated transactionally, the staging cursor
> + * must be deleted before and recreated after, which is why computing the
> + * geometry is a separate step.
> + *
> + * The fourth step in the bulk loading process is to set the function pointers
> + * in the bload context structure.  @get_data will be called for each record
> + * that will be loaded into the btree; it should set the cursor's bc_rec
> + * field, which will be converted to on-disk format and copied into the
> + * appropriate record slot.  @alloc_block should supply one of the blocks
> + * allocated in the previous step.  For btrees which are rooted in an inode
> + * fork, @iroot_size is called to compute the size of the incore btree root
> + * block.  Call xfs_btree_bload to start constructing the btree.
> + *
> + * The final step is to commit the staging cursor, which logs the new btree
> + * root and turns the btree into a regular btree cursor, and free the fake
> + * roots.
> + */
> +
> +/*
> + * Put a btree block that we're loading onto the ordered list and release it.
> + * The btree blocks will be written when the final transaction swapping the
> + * btree roots is committed.
> + */
> +static void
> +xfs_btree_bload_drop_buf(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		**bpp)
> +{
> +	if (*bpp == NULL)
> +		return;
> +
> +	xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_BTREE_BUF);
> +	xfs_trans_ordered_buf(tp, *bpp);
> +	xfs_trans_brelse(tp, *bpp);
> +	*bpp = NULL;
> +}
> +
> +/* Allocate and initialize one btree block for bulk loading. */
> +STATIC int
> +xfs_btree_bload_prep_block(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_btree_bload		*bbl,
> +	unsigned int			level,
> +	unsigned int			nr_this_block,
> +	union xfs_btree_ptr		*ptrp,
> +	struct xfs_buf			**bpp,
> +	struct xfs_btree_block		**blockp,
> +	void				*priv)
> +{
> +	union xfs_btree_ptr		new_ptr;
> +	struct xfs_buf			*new_bp;
> +	struct xfs_btree_block		*new_block;
> +	int				ret;
> +
> +	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> +	    level == cur->bc_nlevels - 1) {
> +		struct xfs_ifork	*ifp = cur->bc_private.b.ifake->if_fork;
> +		size_t			new_size;
> +
> +		/* Allocate a new incore btree root block. */
> +		new_size = bbl->iroot_size(cur, nr_this_block, priv);
> +		ifp->if_broot = kmem_zalloc(new_size, 0);
> +		ifp->if_broot_bytes = (int)new_size;
> +		ifp->if_flags |= XFS_IFBROOT;
> +
> +		/* Initialize it and send it out. */
> +		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
> +				XFS_BUF_DADDR_NULL, cur->bc_btnum, level,
> +				nr_this_block, cur->bc_private.b.ip->i_ino,
> +				cur->bc_flags);
> +
> +		*bpp = NULL;
> +		*blockp = ifp->if_broot;
> +		xfs_btree_set_ptr_null(cur, ptrp);
> +		return 0;
> +	}
> +
> +	/* Allocate a new leaf block. */
> +	ret = bbl->alloc_block(cur, &new_ptr, priv);
> +	if (ret)
> +		return ret;
> +
> +	ASSERT(!xfs_btree_ptr_is_null(cur, &new_ptr));
> +
> +	ret = xfs_btree_get_buf_block(cur, &new_ptr, &new_block, &new_bp);
> +	if (ret)
> +		return ret;
> +
> +	/* Initialize the btree block. */
> +	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);
> +	if (*blockp)
> +		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
> +	xfs_btree_set_sibling(cur, new_block, ptrp, XFS_BB_LEFTSIB);
> +	xfs_btree_set_numrecs(new_block, nr_this_block);
> +
> +	/* Release the old block and set the out parameters. */
> +	xfs_btree_bload_drop_buf(cur->bc_tp, bpp);
> +	*blockp = new_block;
> +	*bpp = new_bp;
> +	xfs_btree_copy_ptrs(cur, ptrp, &new_ptr, 1);
> +	return 0;
> +}
> +
> +/* Load one leaf block. */
> +STATIC int
> +xfs_btree_bload_leaf(
> +	struct xfs_btree_cur		*cur,
> +	unsigned int			recs_this_block,
> +	xfs_btree_bload_get_fn		get_data,
> +	struct xfs_btree_block		*block,
> +	void				*priv)
> +{
> +	unsigned int			j;
> +	int				ret;
> +
> +	/* Fill the leaf block with records. */
> +	for (j = 1; j <= recs_this_block; j++) {
> +		union xfs_btree_rec	*block_recs;
> +
> +		ret = get_data(cur, priv);
> +		if (ret)
> +			return ret;
> +		block_recs = xfs_btree_rec_addr(cur, j, block);
> +		cur->bc_ops->init_rec_from_cur(cur, block_recs);
> +	}
> +
> +	return 0;
> +}
> +
> +/* Load one node block. */
> +STATIC int
> +xfs_btree_bload_node(
> +	struct xfs_btree_cur	*cur,
> +	unsigned int		recs_this_block,
> +	union xfs_btree_ptr	*child_ptr,
> +	struct xfs_btree_block	*block)
> +{
> +	unsigned int		j;
> +	int			ret;
> +
> +	/* Fill the node block with keys and pointers. */
> +	for (j = 1; j <= recs_this_block; j++) {
> +		union xfs_btree_key	child_key;
> +		union xfs_btree_ptr	*block_ptr;
> +		union xfs_btree_key	*block_key;
> +		struct xfs_btree_block	*child_block;
> +		struct xfs_buf		*child_bp;
> +
> +		ASSERT(!xfs_btree_ptr_is_null(cur, child_ptr));
> +
> +		ret = xfs_btree_get_buf_block(cur, child_ptr, &child_block,
> +				&child_bp);
> +		if (ret)
> +			return ret;
> +
> +		xfs_btree_get_keys(cur, child_block, &child_key);
> +
> +		block_ptr = xfs_btree_ptr_addr(cur, j, block);
> +		xfs_btree_copy_ptrs(cur, block_ptr, child_ptr, 1);
> +
> +		block_key = xfs_btree_key_addr(cur, j, block);
> +		xfs_btree_copy_keys(cur, block_key, &child_key, 1);
> +
> +		xfs_btree_get_sibling(cur, child_block, child_ptr,
> +				XFS_BB_RIGHTSIB);
> +		xfs_trans_brelse(cur->bc_tp, child_bp);
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Compute the maximum number of records (or keyptrs) per block that we want to
> + * install at this level in the btree.  Caller is responsible for having set
> + * @cur->bc_private.b.forksize to the desired fork size, if appropriate.
> + */
> +STATIC unsigned int
> +xfs_btree_bload_max_npb(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_btree_bload	*bbl,
> +	unsigned int		level)
> +{
> +	unsigned int		ret;
> +
> +	if (level == cur->bc_nlevels - 1 && cur->bc_ops->get_dmaxrecs)
> +		return cur->bc_ops->get_dmaxrecs(cur, level);
> +
> +	ret = cur->bc_ops->get_maxrecs(cur, level);
> +	if (level == 0)
> +		ret -= bbl->leaf_slack;
> +	else
> +		ret -= bbl->node_slack;
> +	return ret;
> +}
> +
> +/*
> + * Compute the desired number of records (or keyptrs) per block that we want to
> + * install at this level in the btree, which must be somewhere between minrecs
> + * and max_npb.  The caller is free to install fewer records per block.
> + */
> +STATIC unsigned int
> +xfs_btree_bload_desired_npb(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_btree_bload	*bbl,
> +	unsigned int		level)
> +{
> +	unsigned int		npb = xfs_btree_bload_max_npb(cur, bbl, level);
> +
> +	/* Root blocks are not subject to minrecs rules. */
> +	if (level == cur->bc_nlevels - 1)
> +		return max(1U, npb);
> +
> +	return max_t(unsigned int, cur->bc_ops->get_minrecs(cur, level), npb);
> +}
> +
> +/*
> + * Compute the number of records to be stored in each block at this level and
> + * the number of blocks for this level.  For leaf levels, we must populate an
> + * empty root block even if there are no records, so we have to have at least
> + * one block.
> + */
> +STATIC void
> +xfs_btree_bload_level_geometry(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_btree_bload	*bbl,
> +	unsigned int		level,
> +	uint64_t		nr_this_level,
> +	unsigned int		*avg_per_block,
> +	uint64_t		*blocks,
> +	uint64_t		*blocks_with_extra)
> +{
> +	uint64_t		npb;
> +	uint64_t		dontcare;
> +	unsigned int		desired_npb;
> +	unsigned int		maxnr;
> +
> +	maxnr = cur->bc_ops->get_maxrecs(cur, level);
> +
> +	/*
> +	 * Compute the number of blocks we need to fill each block with the
> +	 * desired number of records/keyptrs per block.  Because desired_npb
> +	 * could be minrecs, we use regular integer division (which rounds
> +	 * the block count down) so that in the next step the effective # of
> +	 * items per block will never be less than desired_npb.
> +	 */
> +	desired_npb = xfs_btree_bload_desired_npb(cur, bbl, level);
> +	*blocks = div64_u64_rem(nr_this_level, desired_npb, &dontcare);
> +	*blocks = max(1ULL, *blocks);
> +
> +	/*
> +	 * Compute the number of records that we will actually put in each
> +	 * block, assuming that we want to spread the records evenly between
> +	 * the blocks.  Take care that the effective # of items per block (npb)
> +	 * won't exceed maxrecs even for the blocks that get an extra record,
> +	 * since desired_npb could be maxrecs, and in the previous step we
> +	 * rounded the block count down.
> +	 */
> +	npb = div64_u64_rem(nr_this_level, *blocks, blocks_with_extra);
> +	if (npb > maxnr || (npb == maxnr && *blocks_with_extra > 0)) {
> +		(*blocks)++;
> +		npb = div64_u64_rem(nr_this_level, *blocks, blocks_with_extra);
> +	}
> +
> +	*avg_per_block = min_t(uint64_t, npb, nr_this_level);
> +
> +	trace_xfs_btree_bload_level_geometry(cur, level, nr_this_level,
> +			*avg_per_block, desired_npb, *blocks,
> +			*blocks_with_extra);
> +}
> +
> +/*
> + * Ensure a slack value is appropriate for the btree.
> + *
> + * If the slack value is negative, set slack so that we fill the block to
> + * halfway between minrecs and maxrecs.  Make sure the slack is never so large
> + * that we can underflow minrecs.
> + */
> +static void
> +xfs_btree_bload_ensure_slack(
> +	struct xfs_btree_cur	*cur,
> +	int			*slack,
> +	int			level)
> +{
> +	int			maxr;
> +	int			minr;
> +
> +	/*
> +	 * We only care about slack for btree blocks, so set the btree nlevels
> +	 * to 3 so that level 0 is a leaf block and level 1 is a node block.
> +	 * Avoid straying into inode roots, since we don't do slack there.
> +	 */
> +	cur->bc_nlevels = 3;
> +	maxr = cur->bc_ops->get_maxrecs(cur, level);
> +	minr = cur->bc_ops->get_minrecs(cur, level);
> +
> +	/*
> +	 * If slack is negative, automatically set slack so that we load the
> +	 * btree block approximately halfway between minrecs and maxrecs.
> +	 * Generally, this will net us 75% loading.
> +	 */
> +	if (*slack < 0)
> +		*slack = maxr - ((maxr + minr) >> 1);
> +
> +	*slack = min(*slack, maxr - minr);
> +}
> +
> +/*
> + * Prepare a btree cursor for a bulk load operation by computing the geometry
> + * fields in @bbl.  Caller must ensure that the btree cursor is a staging
> + * cursor.  This function can be called multiple times.
> + */
> +int
> +xfs_btree_bload_compute_geometry(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_btree_bload	*bbl,
> +	uint64_t		nr_records)
> +{
> +	uint64_t		nr_blocks = 0;
> +	uint64_t		nr_this_level;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	xfs_btree_bload_ensure_slack(cur, &bbl->leaf_slack, 0);
> +	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
> +
> +	bbl->nr_records = nr_this_level = nr_records;
> +	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
> +		uint64_t	level_blocks;
> +		uint64_t	dontcare64;
> +		unsigned int	level = cur->bc_nlevels - 1;
> +		unsigned int	avg_per_block;
> +
> +		/*
> +		 * If all the things we want to store at this level would fit
> +		 * in a single root block, then we have our btree root and are
> +		 * done.  Note that bmap btrees do not allow records in the
> +		 * root.
> +		 */
> +		if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) || level != 0) {
> +			xfs_btree_bload_level_geometry(cur, bbl, level,
> +					nr_this_level, &avg_per_block,
> +					&level_blocks, &dontcare64);
> +			if (nr_this_level <= avg_per_block) {
> +				nr_blocks++;
> +				break;
> +			}
> +		}
> +
> +		/*
> +		 * Otherwise, we have to store all the records for this level
> +		 * in blocks and therefore need another level of btree to point
> +		 * to those blocks.  Increase the number of levels and
> +		 * recompute the number of records we can store at this level
> +		 * because that can change depending on whether or not a level
> +		 * is the root level.
> +		 */
> +		cur->bc_nlevels++;
> +		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> +				&avg_per_block, &level_blocks, &dontcare64);
> +		nr_blocks += level_blocks;
> +		nr_this_level = level_blocks;
> +	}
> +
> +	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
> +		return -EOVERFLOW;
> +
> +	bbl->btree_height = cur->bc_nlevels;
> +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> +		bbl->nr_blocks = nr_blocks - 1;
> +	else
> +		bbl->nr_blocks = nr_blocks;
> +	return 0;
> +}
> +
> +/*
> + * Bulk load a btree.
> + *
> + * Load @bbl->nr_records quantity of records into a btree using the supplied
> + * empty and staging btree cursor @cur and a @bbl that has been filled out by
> + * the xfs_btree_bload_compute_geometry function.
> + *
> + * The @bbl->get_data function must populate the cursor's bc_rec every time it
> + * is called.  The @bbl->alloc_block function will be used to allocate new
> + * btree blocks.  @priv is passed to both functions.
> + *
> + * Caller must ensure that @cur is a staging cursor.  Any existing btree rooted
> + * in the fakeroot will be lost, so do not call this function twice.
> + */
> +int
> +xfs_btree_bload(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_btree_bload		*bbl,
> +	void				*priv)
> +{
> +	union xfs_btree_ptr		child_ptr;
> +	union xfs_btree_ptr		ptr;
> +	struct xfs_buf			*bp = NULL;
> +	struct xfs_btree_block		*block = NULL;
> +	uint64_t			nr_this_level = bbl->nr_records;
> +	uint64_t			blocks;
> +	uint64_t			i;
> +	uint64_t			blocks_with_extra;
> +	uint64_t			total_blocks = 0;
> +	unsigned int			avg_per_block;
> +	unsigned int			level = 0;
> +	int				ret;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	cur->bc_nlevels = bbl->btree_height;
> +	xfs_btree_set_ptr_null(cur, &child_ptr);
> +	xfs_btree_set_ptr_null(cur, &ptr);
> +
> +	xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> +			&avg_per_block, &blocks, &blocks_with_extra);
> +
> +	/* Load each leaf block. */
> +	for (i = 0; i < blocks; i++) {
> +		unsigned int		nr_this_block = avg_per_block;
> +
> +		if (i < blocks_with_extra)
> +			nr_this_block++;
> +
> +		ret = xfs_btree_bload_prep_block(cur, bbl, level,
> +				nr_this_block, &ptr, &bp, &block, priv);
> +		if (ret)
> +			return ret;
> +
> +		trace_xfs_btree_bload_block(cur, level, i, blocks, &ptr,
> +				nr_this_block);
> +
> +		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_data,
> +				block, priv);
> +		if (ret)
> +			goto out;
> +
> +		/* Record the leftmost pointer to start the next level. */
> +		if (i == 0)
> +			xfs_btree_copy_ptrs(cur, &child_ptr, &ptr, 1);
> +	}
> +	total_blocks += blocks;
> +	xfs_btree_bload_drop_buf(cur->bc_tp, &bp);
> +
> +	/* Populate the internal btree nodes. */
> +	for (level = 1; level < cur->bc_nlevels; level++) {
> +		union xfs_btree_ptr	first_ptr;
> +
> +		nr_this_level = blocks;
> +		block = NULL;
> +		xfs_btree_set_ptr_null(cur, &ptr);
> +
> +		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> +				&avg_per_block, &blocks, &blocks_with_extra);
> +
> +		/* Load each node block. */
> +		for (i = 0; i < blocks; i++) {
> +			unsigned int	nr_this_block = avg_per_block;
> +
> +			if (i < blocks_with_extra)
> +				nr_this_block++;
> +
> +			ret = xfs_btree_bload_prep_block(cur, bbl, level,
> +					nr_this_block, &ptr, &bp, &block,
> +					priv);
> +			if (ret)
> +				return ret;
> +
> +			trace_xfs_btree_bload_block(cur, level, i, blocks,
> +					&ptr, nr_this_block);
> +
> +			ret = xfs_btree_bload_node(cur, nr_this_block,
> +					&child_ptr, block);
> +			if (ret)
> +				goto out;
> +
> +			/*
> +			 * Record the leftmost pointer to start the next level.
> +			 */
> +			if (i == 0)
> +				xfs_btree_copy_ptrs(cur, &first_ptr, &ptr, 1);
> +		}
> +		total_blocks += blocks;
> +		xfs_btree_bload_drop_buf(cur->bc_tp, &bp);
> +		xfs_btree_copy_ptrs(cur, &child_ptr, &first_ptr, 1);
> +	}
> +
> +	/* Initialize the new root. */
> +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
> +		ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
> +		cur->bc_private.b.ifake->if_levels = cur->bc_nlevels;
> +		cur->bc_private.b.ifake->if_blocks = total_blocks - 1;
> +	} else {
> +		cur->bc_private.a.afake->af_root = be32_to_cpu(ptr.s);
> +		cur->bc_private.a.afake->af_levels = cur->bc_nlevels;
> +		cur->bc_private.a.afake->af_blocks = total_blocks;
> +	}
> +out:
> +	if (bp)
> +		xfs_trans_brelse(cur->bc_tp, bp);
> +	return ret;
> +}
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index a17becb72ab8..5c6992a04ea2 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -582,4 +582,47 @@ void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
>  void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, int whichfork,
>  		const struct xfs_btree_ops *ops);
>  
> +typedef int (*xfs_btree_bload_get_fn)(struct xfs_btree_cur *cur, void *priv);
> +typedef int (*xfs_btree_bload_alloc_block_fn)(struct xfs_btree_cur *cur,
> +		union xfs_btree_ptr *ptr, void *priv);
> +typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
> +		unsigned int nr_this_level, void *priv);
> +
> +/* Bulk loading of staged btrees. */
> +struct xfs_btree_bload {
> +	/* Function to store a record in the cursor. */
> +	xfs_btree_bload_get_fn		get_data;
> +
> +	/* Function to allocate a block for the btree. */
> +	xfs_btree_bload_alloc_block_fn	alloc_block;
> +
> +	/* Function to compute the size of the in-core btree root block. */
> +	xfs_btree_bload_iroot_size_fn	iroot_size;
> +
> +	/* Number of records the caller wants to store. */
> +	uint64_t			nr_records;
> +
> +	/* Number of btree blocks needed to store those records. */
> +	uint64_t			nr_blocks;
> +
> +	/*
> +	 * Number of free records to leave in each leaf block.  If this (or
> +	 * any of the slack values) are negative, this will be computed to
> +	 * be halfway between maxrecs and minrecs.  This typically leaves the
> +	 * block 75% full.
> +	 */
> +	int				leaf_slack;
> +
> +	/* Number of free keyptrs to leave in each node block. */
> +	int				node_slack;
> +
> +	/* Computed btree height. */
> +	unsigned int			btree_height;
> +};
> +
> +int xfs_btree_bload_compute_geometry(struct xfs_btree_cur *cur,
> +		struct xfs_btree_bload *bbl, uint64_t nr_records);
> +int xfs_btree_bload(struct xfs_btree_cur *cur, struct xfs_btree_bload *bbl,
> +		void *priv);
> +
>  #endif	/* __XFS_BTREE_H__ */
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index bc85b89f88ca..9b5e58a92381 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -6,6 +6,7 @@
>  #include "xfs.h"
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
> +#include "xfs_bit.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a78055521fcd..6d7ba64b7a0f 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -35,6 +35,7 @@ struct xfs_icreate_log;
>  struct xfs_owner_info;
>  struct xfs_trans_res;
>  struct xfs_inobt_rec_incore;
> +union xfs_btree_ptr;
>  
>  DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  	TP_PROTO(struct xfs_attr_list_context *ctx),
> @@ -3670,6 +3671,90 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
>  		  __entry->blocks)
>  )
>  
> +TRACE_EVENT(xfs_btree_bload_level_geometry,
> +	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
> +		 uint64_t nr_this_level, unsigned int nr_per_block,
> +		 unsigned int desired_npb, uint64_t blocks,
> +		 uint64_t blocks_with_extra),
> +	TP_ARGS(cur, level, nr_this_level, nr_per_block, desired_npb, blocks,
> +		blocks_with_extra),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_btnum_t, btnum)
> +		__field(unsigned int, level)
> +		__field(unsigned int, nlevels)
> +		__field(uint64_t, nr_this_level)
> +		__field(unsigned int, nr_per_block)
> +		__field(unsigned int, desired_npb)
> +		__field(unsigned long long, blocks)
> +		__field(unsigned long long, blocks_with_extra)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = cur->bc_mp->m_super->s_dev;
> +		__entry->btnum = cur->bc_btnum;
> +		__entry->level = level;
> +		__entry->nlevels = cur->bc_nlevels;
> +		__entry->nr_this_level = nr_this_level;
> +		__entry->nr_per_block = nr_per_block;
> +		__entry->desired_npb = desired_npb;
> +		__entry->blocks = blocks;
> +		__entry->blocks_with_extra = blocks_with_extra;
> +	),
> +	TP_printk("dev %d:%d btree %s level %u/%u nr_this_level %llu nr_per_block %u desired_npb %u blocks %llu blocks_with_extra %llu",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> +		  __entry->level,
> +		  __entry->nlevels,
> +		  __entry->nr_this_level,
> +		  __entry->nr_per_block,
> +		  __entry->desired_npb,
> +		  __entry->blocks,
> +		  __entry->blocks_with_extra)
> +)
> +
> +TRACE_EVENT(xfs_btree_bload_block,
> +	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
> +		 uint64_t block_idx, uint64_t nr_blocks,
> +		 union xfs_btree_ptr *ptr, unsigned int nr_records),
> +	TP_ARGS(cur, level, block_idx, nr_blocks, ptr, nr_records),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_btnum_t, btnum)
> +		__field(unsigned int, level)
> +		__field(unsigned long long, block_idx)
> +		__field(unsigned long long, nr_blocks)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agblock_t, agbno)
> +		__field(unsigned int, nr_records)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = cur->bc_mp->m_super->s_dev;
> +		__entry->btnum = cur->bc_btnum;
> +		__entry->level = level;
> +		__entry->block_idx = block_idx;
> +		__entry->nr_blocks = nr_blocks;
> +		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> +			xfs_fsblock_t	fsb = be64_to_cpu(ptr->l);
> +
> +			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);
> +			__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsb);
> +		} else {
> +			__entry->agno = cur->bc_private.a.agno;
> +			__entry->agbno = be32_to_cpu(ptr->s);
> +		}
> +		__entry->nr_records = nr_records;
> +	),
> +	TP_printk("dev %d:%d btree %s level %u block %llu/%llu fsb (%u/%u) recs %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> +		  __entry->level,
> +		  __entry->block_idx,
> +		  __entry->nr_blocks,
> +		  __entry->agno,
> +		  __entry->agbno,
> +		  __entry->nr_records)
> +)
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 
