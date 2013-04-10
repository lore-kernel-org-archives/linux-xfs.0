Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 989DD7FB3
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 12:46:43 -0500 (CDT)
Date: Wed, 10 Apr 2013 12:46:39 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 13/22] xfs: add CRC checking to dir2 leaf blocks
Message-ID: <20130410174639.GG22182@sgi.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<1364965892-19623-14-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364965892-19623-14-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

Comments below.  Basically just some nits about asserts, comments, variable
names, and looks like an off-by-one in xfs_dir3_leaf_log_header.  I would like
to know your plan for xfs_da_root_split and xfs_dir3_leaf_check_int.  

Nice find in xfs_dir2_block_to_leaf!  That should be a separate patch.

Regards,
Ben

On Wed, Apr 03, 2013 at 04:11:23PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This addition follows the same pattern as the dir2 block CRCs.
> Seeing as both LEAF1 and LEAFN types need to changed at the same
> time, this is a pretty large amount of change. leaf block headers
> neeed to be abstracted away from the on-disk structures (struct

need

> xfs_dir3_icleaf_hdr), as do the base leaf entry locations.
> 
> This header abstract allows the in-core header and leaf entry
> location to be passed around instead of the leaf block itself. This
> saves a lot of converting individual variables from on-disk format
> to host format where they are used, so there's a good chance that
> the compiler will be able to produce much more optimal code as it's
> not having to byteswap variables all over the place.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

...

> @@ -396,11 +397,18 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
>  		size = (int)((char *)&oldroot->btree[be16_to_cpu(oldroot->hdr.count)] -
>  			     (char *)oldroot);
>  	} else {
> -		ASSERT(oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> +		struct xfs_dir3_icleaf_hdr leafhdr;
> +		struct xfs_dir2_leaf_entry *ents;
> +
>  		leaf = (xfs_dir2_leaf_t *)oldroot;
> -		size = (int)((char *)&leaf->ents[be16_to_cpu(leaf->hdr.count)] -
> -			     (char *)leaf);
> +		xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
> +		ents = xfs_dir3_leaf_ents_p(leaf);
> +
> +		ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
> +		       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
> +		size = (int)((char *)&ents[leafhdr.count] - (char *)leaf);
>  	}
> +	/* XXX: can't just copy CRC headers from one block to another */

What is your plan for resolving that?

> @@ -2281,10 +2299,17 @@ xfs_da_read_buf(
>  		    XFS_TEST_ERROR((magic != XFS_DA_NODE_MAGIC) &&
>  				   (magic != XFS_ATTR_LEAF_MAGIC) &&
>  				   (magic != XFS_DIR2_LEAF1_MAGIC) &&
> +				   (magic != XFS_DIR3_LEAF1_MAGIC) &&
>  				   (magic != XFS_DIR2_LEAFN_MAGIC) &&
> +				   (magic != XFS_DIR3_LEAFN_MAGIC) &&
>  				   (magic1 != XFS_DIR2_BLOCK_MAGIC) &&
> +				   (magic1 != XFS_DIR3_BLOCK_MAGIC) &&

Did this DIR3_BLOCK_MAGIC change sneak in from another patch?

>  				   (magic1 != XFS_DIR2_DATA_MAGIC) &&
> -				   (free->hdr.magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC)),
> +				   (magic1 != XFS_DIR3_DATA_MAGIC) &&
> +				   (free->hdr.magic !=
> +					cpu_to_be32(XFS_DIR2_FREE_MAGIC)) &&
> +				   (free->hdr.magic !=
> +					cpu_to_be32(XFS_DIR3_FREE_MAGIC)),

Do DIRx_DATA_MAGIC and DIRx_FREE_MAGIC belong in a different patch?

>  /*
>   * Get address of the bestcount field in the single-leaf block.
>   */
> +static inline struct xfs_dir2_leaf_entry *
> +xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
> +{
> +	if (lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
> +	    lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
> +		struct xfs_dir3_leaf *lp3 = (struct xfs_dir3_leaf *)lp;
> +		return lp3->__ents;
> +	}
> +	return lp->__ents;
> +}
> +
> +/*
> + * Get address of the bestcount field in the single-leaf block.
> + */

I appreciate the addition of the comment.

> +bool
> +xfs_dir3_leaf_check_int(
> +	struct xfs_mount	*mp,
> +	struct xfs_dir3_icleaf_hdr *hdr,
> +	struct xfs_dir2_leaf	*leaf)
> +{
> +	struct xfs_dir2_leaf_entry *ents;
> +	xfs_dir2_leaf_tail_t	*ltp;
> +	int			stale;
> +	int			i;
> +
> +	ents = xfs_dir3_leaf_ents_p(leaf);
> +	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
> +
> +	/*
> +	 * This value is not restrictive enough.
> +	 * Should factor in the size of the bests table as well.
> +	 * We can deduce a value for that from di_size.
> +	 */
		^^^^^
That should probably be marked with a TODO.

> +static bool
> +xfs_dir3_leaf_verify(
>  	struct xfs_buf		*bp,
> -	__be16			magic)
> +	__uint16_t		magic)
> +{
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> +	struct xfs_dir3_icleaf_hdr leafhdr;
> +
> +	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);

Using v2 magics to choose between leaf1 and leafn is ok, but not as clear as
using a non-version-specific #define or enum might be for this purpose.

> @@ -169,27 +432,34 @@ xfs_dir2_block_to_leaf(
>  	/*
>  	 * Initialize the leaf block, get a buffer for it.
>  	 */
> -	if ((error = xfs_dir2_leaf_init(args, ldb, &lbp, XFS_DIR2_LEAF1_MAGIC))) {
> +	error = xfs_dir3_leaf_get_buf(args, ldb, &lbp, XFS_DIR2_LEAF1_MAGIC);
> +	if (error)
>  		return error;
> -	}
> -	ASSERT(lbp != NULL);
> +
>  	leaf = lbp->b_addr;
>  	hdr = dbp->b_addr;
>  	xfs_dir3_data_check(dp, dbp);
>  	btp = xfs_dir2_block_tail_p(mp, hdr);
>  	blp = xfs_dir2_block_leaf_p(btp);
>  	bf = xfs_dir3_data_bestfree_p(hdr);
> +	ents = xfs_dir3_leaf_ents_p(leaf);
> +
>  	/*
>  	 * Set the counts in the leaf header.
> +	 *
> +	 * XXX: are these actually logged, or just gathered by chance?

Nice find.  I'm not seeing where that header is being logged.  Worth a separate
patch.

>  void
> -xfs_dir2_leaf_log_header(
> +xfs_dir3_leaf_log_header(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*bp)
>  {
> -	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
> +	struct xfs_dir2_leaf	*leaf = bp->b_addr;
>  
> -	leaf = bp->b_addr;
>  	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
> -	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> +	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
> +	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
> +	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
> +
>  	xfs_trans_log_buf(tp, bp, (uint)((char *)&leaf->hdr - (char *)leaf),
> -		(uint)(sizeof(leaf->hdr) - 1));
> +			  xfs_dir3_leaf_hdr_size(leaf));
			  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Should be xfs_dir3_leaf_hdr_size(leaf) - 1, I think.

> @@ -1958,36 +2171,40 @@ xfs_dir2_node_to_leaf(
>  	 * Now see if the leafn and free data will fit in a leaf1.
>  	 * If not, release the buffer and give up.
>  	 */
> -	if (xfs_dir2_leaf_size(&leaf->hdr, freehdr.nvalid) > mp->m_dirblksize) {
> +	if (xfs_dir3_leaf_size(&leafhdr, freehdr.nvalid) > mp->m_dirblksize) {
>  		xfs_trans_brelse(tp, fbp);
>  		return 0;
>  	}
>  
>  	/*
>  	 * If the leaf has any stale entries in it, compress them out.
> -	 * The compact routine will log the header.
>  	 */
> -	if (be16_to_cpu(leaf->hdr.stale))
> -		xfs_dir2_leaf_compact(args, lbp);
> -	else
> -		xfs_dir2_leaf_log_header(tp, lbp);
> +	if (leafhdr.stale)
> +		xfs_dir3_leaf_compact(args, &leafhdr, lbp);
>  
> -	lbp->b_ops = &xfs_dir2_leaf1_buf_ops;
> -	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAF1_MAGIC);
> +	lbp->b_ops = &xfs_dir3_leaf1_buf_ops;
> +	leafhdr.magic = (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC)
> +					? XFS_DIR2_LEAF1_MAGIC
> +					: XFS_DIR3_LEAF1_MAGIC;

An assert might be nice here:

	if (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC)
		leafhdr.magic = XFS_DIR2_LEAF1_MAGIC;
	else {
		ASSERT(leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
		leafhdr.magic = XFS_DIR3_LEAF1_MAGIC;
	}

>  static bool
>  xfs_dir3_free_verify(
>  	struct xfs_buf		*bp)
> @@ -360,11 +385,19 @@ xfs_dir2_leaf_to_node(
>  	xfs_dir2_free_log_bests(tp, fbp, 0, freehdr.nvalid - 1);
>  	xfs_dir2_free_log_header(tp, fbp);
>  
> -	/* convert the leaf to a leafnode */
> -	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAFN_MAGIC);
> -	lbp->b_ops = &xfs_dir2_leafn_buf_ops;
> -	xfs_dir2_leaf_log_header(tp, lbp);
> -	xfs_dir2_leafn_check(dp, lbp);
> +	/*
> +	 * Converting the leaf to a leafnode is just a matter of changing the
> +	 * magic number and the ops. Do the change directly to the buffer as
> +	 * it's less work (and less code) than decoding the header to host
> +	 * format and back again.
> +	 */
> +	if (leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC))
> +		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAFN_MAGIC);
> +	else
> +		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);

Here too might be a good spot for an assert in the else.

>  static void
>  xfs_dir2_free_hdr_check(
>  	struct xfs_mount *mp,
> @@ -510,15 +520,18 @@ xfs_dir2_leafn_lasthash(
>  	struct xfs_buf	*bp,			/* leaf buffer */
>  	int		*count)			/* count of entries in leaf */
>  {
> -	xfs_dir2_leaf_t	*leaf;			/* leaf structure */
> +	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> +	struct xfs_dir2_leaf_entry *ents;
> +	struct xfs_dir3_icleaf_hdr leafhdr;
> +
> +	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
> +	ents = xfs_dir3_leaf_ents_p(leaf);
>  
> -	leaf = bp->b_addr;
> -	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));

Looks like this assert has gone missing.  It was intentionally more specific
than the one in xfs_dir3_leaf_hdr_from_disk, right?

> @@ -547,16 +560,19 @@ xfs_dir2_leafn_lookup_for_addname(
>  	xfs_dir2_db_t		newdb;		/* new data block number */
>  	xfs_dir2_db_t		newfdb;		/* new free block number */
>  	xfs_trans_t		*tp;		/* transaction pointer */
> +	struct xfs_dir2_leaf_entry *ents;
> +	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	dp = args->dp;
>  	tp = args->trans;
>  	mp = dp->i_mount;
>  	leaf = bp->b_addr;
> -	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));

Here the assert is also missing, but it looks like it is handled below in
xfs_dir3_leaf_check.  Maybe the above is similar.

> -#ifdef __KERNEL__
> -	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
> -#endif
> -	xfs_dir2_leafn_check(dp, bp);
> +	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
> +	ents = xfs_dir3_leaf_ents_p(leaf);
> +
> +	xfs_dir3_leaf_check(mp, bp);
...

> @@ -694,16 +710,19 @@ xfs_dir2_leafn_lookup_for_entry(
>  	xfs_dir2_db_t		newdb;		/* new data block number */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	enum xfs_dacmp		cmp;		/* comparison result */
> +	struct xfs_dir2_leaf_entry *ents;
> +	struct xfs_dir3_icleaf_hdr leafhdr;
>  
>  	dp = args->dp;
>  	tp = args->trans;
>  	mp = dp->i_mount;
>  	leaf = bp->b_addr;
> -	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));

Again.  But you've also got xfs_dir3_leaf_check below, so maybe the first one is
the only issue.

> -#ifdef __KERNEL__
> -	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
> -#endif
> -	xfs_dir2_leafn_check(dp, bp);
> +	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
> +	ents = xfs_dir3_leaf_ents_p(leaf);
> +
> +	xfs_dir3_leaf_check(mp, bp);
...

> +xfs_dir3_leafn_moveents(
> +	xfs_da_args_t			*args,	/* operation arguments */
> +	struct xfs_buf			*bp_s,	/* source */
> +	struct xfs_dir3_icleaf_hdr	*shdr,
> +	struct xfs_dir2_leaf_entry	*sents,
> +	int				start_s,/* source leaf index */
> +	struct xfs_buf			*bp_d,	/* destination */
> +	struct xfs_dir3_icleaf_hdr	*dhdr,
> +	struct xfs_dir2_leaf_entry	*dents,
> +	int				start_d,/* destination leaf index */
> +	int				count)	/* count of leaves to copy */
>  {
> -	xfs_dir2_leaf_t	*leaf_d;		/* destination leaf structure */
> -	xfs_dir2_leaf_t	*leaf_s;		/* source leaf structure */
> -	int		stale;			/* count stale leaves copied */
> -	xfs_trans_t	*tp;			/* transaction pointer */
> +	int		stale;

I agree
						/* transaction pointer */
is a bit overkill but
						/* count stale leaves copied */
does help a new reader of this code.

> @@ -922,21 +936,25 @@ xfs_dir2_leafn_moveents(
>   */
>  int						/* sort order */
>  xfs_dir2_leafn_order(
> -	struct xfs_buf	*leaf1_bp,		/* leaf1 buffer */
> -	struct xfs_buf	*leaf2_bp)		/* leaf2 buffer */
> +	struct xfs_buf		*leaf1_bp,		/* leaf1 buffer */
> +	struct xfs_buf		*leaf2_bp)		/* leaf2 buffer */
>  {
> -	xfs_dir2_leaf_t	*leaf1;			/* leaf1 structure */
> -	xfs_dir2_leaf_t	*leaf2;			/* leaf2 structure */
> -
> -	leaf1 = leaf1_bp->b_addr;
> -	leaf2 = leaf2_bp->b_addr;
> -	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> -	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));

These asserts are more specific than those in xfs_dir3_leaf_hdr_from_disk so
they should probably stay and have dirv3 magic added.

> @@ -1153,6 +1193,8 @@ xfs_dir2_leafn_remove(
>  	int			needscan;	/* need to rescan data frees */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	struct xfs_dir2_data_free *bf;		/* bestfree table */
> +	struct xfs_dir3_icleaf_hdr leafhdr;
> +	struct xfs_dir2_leaf_entry *ents;
>  
>  	trace_xfs_dir2_leafn_remove(args, index);
>  
> @@ -1160,11 +1202,14 @@ xfs_dir2_leafn_remove(
>  	tp = args->trans;
>  	mp = dp->i_mount;
>  	leaf = bp->b_addr;
> -	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));

Another assert that is more specific than what it is replaced with, but you do
have a leafn check, so that's something.

> @@ -1366,6 +1413,8 @@ xfs_dir2_leafn_toosmall(
>  	xfs_da_blkinfo_t	*info;		/* leaf block header */

Looks like you can get rid of the info pointer now.

> @@ -1374,10 +1423,12 @@ xfs_dir2_leafn_toosmall(
>  	 */
>  	blk = &state->path.blk[state->path.active - 1];
>  	info = blk->bp->b_addr;
> -	ASSERT(info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));

Another assert that is more specific than it's replacement.

> @@ -1428,13 +1481,15 @@ xfs_dir2_leafn_toosmall(
>  		/*
>  		 * Count bytes in the two blocks combined.
>  		 */
> -		leaf = (xfs_dir2_leaf_t *)info;
> -		count = be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
> +		count = leafhdr.count - leafhdr.stale;
>  		bytes = state->blocksize - (state->blocksize >> 2);
> +
>  		leaf = bp->b_addr;
> -		ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> -		count += be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
> -		bytes -= count * (uint)sizeof(leaf->ents[0]);
				 ^^^^^ 
I wonder why that (uint) was added.

> @@ -1481,34 +1536,52 @@ xfs_dir2_leafn_unbalance(
>  	xfs_da_args_t		*args;		/* operation arguments */
>  	xfs_dir2_leaf_t		*drop_leaf;	/* dead leaf structure */
>  	xfs_dir2_leaf_t		*save_leaf;	/* surviving leaf structure */
> +	struct xfs_dir3_icleaf_hdr shdr;
> +	struct xfs_dir3_icleaf_hdr dhdr;
> +	struct xfs_dir2_leaf_entry *sents;
> +	struct xfs_dir2_leaf_entry *dents;

As I read this I really had a hard time not thinking 'source' and 'dest'
instead of 'save' and 'drop'.  This would be more readable as the latter.

>  
>  	args = state->args;
>  	ASSERT(drop_blk->magic == XFS_DIR2_LEAFN_MAGIC);
>  	ASSERT(save_blk->magic == XFS_DIR2_LEAFN_MAGIC);
>  	drop_leaf = drop_blk->bp->b_addr;
>  	save_leaf = save_blk->bp->b_addr;
> -	ASSERT(drop_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> -	ASSERT(save_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));

More specific assert than its replacement.

> +
> +	xfs_dir3_leaf_hdr_from_disk(&shdr, save_leaf);
> +	xfs_dir3_leaf_hdr_from_disk(&dhdr, drop_leaf);
> +	sents = xfs_dir3_leaf_ents_p(save_leaf);
> +	dents = xfs_dir3_leaf_ents_p(drop_leaf);
> +
>  	/*
>  	 * If there are any stale leaf entries, take this opportunity
>  	 * to purge them.
>  	 */
> -	if (drop_leaf->hdr.stale)
> -		xfs_dir2_leaf_compact(args, drop_blk->bp);
> -	if (save_leaf->hdr.stale)
> -		xfs_dir2_leaf_compact(args, save_blk->bp);
> +	if (dhdr.stale)
> +		xfs_dir3_leaf_compact(args, &dhdr, drop_blk->bp);
> +	if (shdr.stale)
> +		xfs_dir3_leaf_compact(args, &shdr, save_blk->bp);
> +
>  	/*
>  	 * Move the entries from drop to the appropriate end of save.
>  	 */
> -	drop_blk->hashval = be32_to_cpu(drop_leaf->ents[be16_to_cpu(drop_leaf->hdr.count) - 1].hashval);
> +	drop_blk->hashval = be32_to_cpu(dents[dhdr.count - 1].hashval);
>  	if (xfs_dir2_leafn_order(save_blk->bp, drop_blk->bp))
> -		xfs_dir2_leafn_moveents(args, drop_blk->bp, 0, save_blk->bp, 0,
> -			be16_to_cpu(drop_leaf->hdr.count));
> +		xfs_dir3_leafn_moveents(args, drop_blk->bp, &dhdr, dents, 0,
> +					save_blk->bp, &shdr, sents, 0,
> +					dhdr.count);
>  	else
> -		xfs_dir2_leafn_moveents(args, drop_blk->bp, 0, save_blk->bp,
> -			be16_to_cpu(save_leaf->hdr.count), be16_to_cpu(drop_leaf->hdr.count));
> -	save_blk->hashval = be32_to_cpu(save_leaf->ents[be16_to_cpu(save_leaf->hdr.count) - 1].hashval);
> -	xfs_dir2_leafn_check(args->dp, save_blk->bp);
> +		xfs_dir3_leafn_moveents(args, drop_blk->bp, &dhdr, dents, 0,
> +					save_blk->bp, &shdr, sents,
> +					shdr.count, dhdr.count);
> +	save_blk->hashval = be32_to_cpu(sents[shdr.count - 1].hashval);
> +
> +	/* log the changes made when moving the entries */
> +	xfs_dir3_leaf_hdr_to_disk(save_leaf, &shdr);
> +	xfs_dir3_leaf_hdr_to_disk(drop_leaf, &dhdr);
> +	xfs_dir3_leaf_log_header(args->trans, save_blk->bp);
> +	xfs_dir3_leaf_log_header(args->trans, drop_blk->bp);
> +
> +	xfs_dir3_leaf_check(args->dp->i_mount, save_blk->bp);
	xfs_dir3_leaf_check(args->dp->i_mount, drop_block->bp);

We used to check it in debug code.  Might as well continue to do so.




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
