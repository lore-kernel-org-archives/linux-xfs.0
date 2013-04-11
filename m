Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4ECBD7FA4
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 21:06:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D35C8F8054
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 19:06:12 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DetGTQwzyXz75m2d for <xfs@oss.sgi.com>;
	Wed, 10 Apr 2013 19:06:09 -0700 (PDT)
Date: Thu, 11 Apr 2013 12:06:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/22] xfs: add CRC checking to dir2 leaf blocks
Message-ID: <20130411020606.GE10481@dastard>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<1364965892-19623-14-git-send-email-david@fromorbit.com>
	<20130410174639.GG22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130410174639.GG22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 10, 2013 at 12:46:39PM -0500, Ben Myers wrote:
> > @@ -396,11 +397,18 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
> >  		size = (int)((char *)&oldroot->btree[be16_to_cpu(oldroot->hdr.count)] -
> >  			     (char *)oldroot);
> >  	} else {
> > -		ASSERT(oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> > +		struct xfs_dir3_icleaf_hdr leafhdr;
> > +		struct xfs_dir2_leaf_entry *ents;
> > +
> >  		leaf = (xfs_dir2_leaf_t *)oldroot;
> > -		size = (int)((char *)&leaf->ents[be16_to_cpu(leaf->hdr.count)] -
> > -			     (char *)leaf);
> > +		xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
> > +		ents = xfs_dir3_leaf_ents_p(leaf);
> > +
> > +		ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
> > +		       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
> > +		size = (int)((char *)&ents[leafhdr.count] - (char *)leaf);
> >  	}
> > +	/* XXX: can't just copy CRC headers from one block to another */
> 
> What is your plan for resolving that?

It's fixed in a later patch when the da btree nodes have CRCs
added to them.

> > @@ -2281,10 +2299,17 @@ xfs_da_read_buf(
> >  		    XFS_TEST_ERROR((magic != XFS_DA_NODE_MAGIC) &&
> >  				   (magic != XFS_ATTR_LEAF_MAGIC) &&
> >  				   (magic != XFS_DIR2_LEAF1_MAGIC) &&
> > +				   (magic != XFS_DIR3_LEAF1_MAGIC) &&
> >  				   (magic != XFS_DIR2_LEAFN_MAGIC) &&
> > +				   (magic != XFS_DIR3_LEAFN_MAGIC) &&
> >  				   (magic1 != XFS_DIR2_BLOCK_MAGIC) &&
> > +				   (magic1 != XFS_DIR3_BLOCK_MAGIC) &&
> 
> Did this DIR3_BLOCK_MAGIC change sneak in from another patch?
...
> Do DIRx_DATA_MAGIC and DIRx_FREE_MAGIC belong in a different patch?

Probably, though given that at this point in the series they'll
never be set, it isn't actually a bug or anything that will break a
bisection. Do I really need to move these back into 3 previous
patches?

Kind in mind that means I also need to do all these changes in the
userspace patch series as well...

> > +static bool
> > +xfs_dir3_leaf_verify(
> >  	struct xfs_buf		*bp,
> > -	__be16			magic)
> > +	__uint16_t		magic)
> > +{
> > +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > +	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> > +	struct xfs_dir3_icleaf_hdr leafhdr;
> > +
> > +	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
> 
> Using v2 magics to choose between leaf1 and leafn is ok, but not as clear as
> using a non-version-specific #define or enum might be for this purpose.

The magic number passed in is actually used to validate the
magic number in the block being verified. I don't see any point in
inventing a new LEAF1/LEAFN identifier and then have to use that to
determine what the correct magic number is when we can just pass in
the magic number we expect....

Besides, we already use the magic numbers in this manner to identify
block types in the struct xfs_da_state_blk that is passed through
the da btree code, this is a pattern that is already well
established.


> 
> > @@ -169,27 +432,34 @@ xfs_dir2_block_to_leaf(
> >  	/*
> >  	 * Initialize the leaf block, get a buffer for it.
> >  	 */
> > -	if ((error = xfs_dir2_leaf_init(args, ldb, &lbp, XFS_DIR2_LEAF1_MAGIC))) {
> > +	error = xfs_dir3_leaf_get_buf(args, ldb, &lbp, XFS_DIR2_LEAF1_MAGIC);
> > +	if (error)
> >  		return error;
> > -	}
> > -	ASSERT(lbp != NULL);
> > +
> >  	leaf = lbp->b_addr;
> >  	hdr = dbp->b_addr;
> >  	xfs_dir3_data_check(dp, dbp);
> >  	btp = xfs_dir2_block_tail_p(mp, hdr);
> >  	blp = xfs_dir2_block_leaf_p(btp);
> >  	bf = xfs_dir3_data_bestfree_p(hdr);
> > +	ents = xfs_dir3_leaf_ents_p(leaf);
> > +
> >  	/*
> >  	 * Set the counts in the leaf header.
> > +	 *
> > +	 * XXX: are these actually logged, or just gathered by chance?
> 
> Nice find.  I'm not seeing where that header is being logged.  Worth a separate
> patch.

I haven't fixed anything. I just added the comment as something to
come back to.  As it is, I can answer that question directly right
now: they are gathered by chance by the xfs_dir2_leaf_log_ents()
call a few lines below due to the fact that the first dirent is in
the range covered by the first dirty bit of the logging regions
(i.e. 0-127 bytes into the buffer).

So there isn't a bug here, and the header is logged implicity rather
than explicitly. As such, I don't think there's anything that needs
to be put in a separate patch because there is no bug being fixed
here.

I have, however, removed the comment and put an explicit call to
xfs_dir3_leaf_log_header() in there.

> >  void
> > -xfs_dir2_leaf_log_header(
> > +xfs_dir3_leaf_log_header(
> >  	struct xfs_trans	*tp,
> >  	struct xfs_buf		*bp)
> >  {
> > -	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
> > +	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> >  
> > -	leaf = bp->b_addr;
> >  	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
> > -	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> > +	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
> > +	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
> > +	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
> > +
> >  	xfs_trans_log_buf(tp, bp, (uint)((char *)&leaf->hdr - (char *)leaf),
> > -		(uint)(sizeof(leaf->hdr) - 1));
> > +			  xfs_dir3_leaf_hdr_size(leaf));
> 			  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Should be xfs_dir3_leaf_hdr_size(leaf) - 1, I think.

Good catch. Fixed.

(Not a bug, though, because of the 128 byte resolution of the dirty
bit tracking. The dir2/dir3 leaf header size is 16/64 bytes, so we
are always logging 128 bytes here regardless of the off-by-one.)


> > @@ -1958,36 +2171,40 @@ xfs_dir2_node_to_leaf(
> >  	 * Now see if the leafn and free data will fit in a leaf1.
> >  	 * If not, release the buffer and give up.
> >  	 */
> > -	if (xfs_dir2_leaf_size(&leaf->hdr, freehdr.nvalid) > mp->m_dirblksize) {
> > +	if (xfs_dir3_leaf_size(&leafhdr, freehdr.nvalid) > mp->m_dirblksize) {
> >  		xfs_trans_brelse(tp, fbp);
> >  		return 0;
> >  	}
> >  
> >  	/*
> >  	 * If the leaf has any stale entries in it, compress them out.
> > -	 * The compact routine will log the header.
> >  	 */
> > -	if (be16_to_cpu(leaf->hdr.stale))
> > -		xfs_dir2_leaf_compact(args, lbp);
> > -	else
> > -		xfs_dir2_leaf_log_header(tp, lbp);
> > +	if (leafhdr.stale)
> > +		xfs_dir3_leaf_compact(args, &leafhdr, lbp);
> >  
> > -	lbp->b_ops = &xfs_dir2_leaf1_buf_ops;
> > -	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAF1_MAGIC);
> > +	lbp->b_ops = &xfs_dir3_leaf1_buf_ops;
> > +	leafhdr.magic = (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC)
> > +					? XFS_DIR2_LEAF1_MAGIC
> > +					: XFS_DIR3_LEAF1_MAGIC;
> 
> An assert might be nice here:
> 
> 	if (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC)
> 		leafhdr.magic = XFS_DIR2_LEAF1_MAGIC;
> 	else {
> 		ASSERT(leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
> 		leafhdr.magic = XFS_DIR3_LEAF1_MAGIC;
> 	}

No need, because 20 lines above is this:

        xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);

        ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
               leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);

Note that the *hdr_from_disk() functions all have asserts that
validate the magic numbers of the blocks that passed to them.
This code has an additional external assert because
xfs_dir3_leaf_hdr_from_disk() converts both LEAF1 and LEAFN format
blocks and hence we need to be explicit here that we expect LEAFN
format.

> >  static bool
> >  xfs_dir3_free_verify(
> >  	struct xfs_buf		*bp)
> > @@ -360,11 +385,19 @@ xfs_dir2_leaf_to_node(
> >  	xfs_dir2_free_log_bests(tp, fbp, 0, freehdr.nvalid - 1);
> >  	xfs_dir2_free_log_header(tp, fbp);
> >  
> > -	/* convert the leaf to a leafnode */
> > -	leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAFN_MAGIC);
> > -	lbp->b_ops = &xfs_dir2_leafn_buf_ops;
> > -	xfs_dir2_leaf_log_header(tp, lbp);
> > -	xfs_dir2_leafn_check(dp, lbp);
> > +	/*
> > +	 * Converting the leaf to a leafnode is just a matter of changing the
> > +	 * magic number and the ops. Do the change directly to the buffer as
> > +	 * it's less work (and less code) than decoding the header to host
> > +	 * format and back again.
> > +	 */
> > +	if (leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC))
> > +		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR2_LEAFN_MAGIC);
> > +	else
> > +		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
> 
> Here too might be a good spot for an assert in the else.

We've already validated that we have a LEAF1 format node, so this
code is just selecting the right LEAFN magic number. Adding an
assert here doesn't add anything extra.

> >  static void
> >  xfs_dir2_free_hdr_check(
> >  	struct xfs_mount *mp,
> > @@ -510,15 +520,18 @@ xfs_dir2_leafn_lasthash(
> >  	struct xfs_buf	*bp,			/* leaf buffer */
> >  	int		*count)			/* count of entries in leaf */
> >  {
> > -	xfs_dir2_leaf_t	*leaf;			/* leaf structure */
> > +	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> > +	struct xfs_dir2_leaf_entry *ents;
> > +	struct xfs_dir3_icleaf_hdr leafhdr;
> > +
> > +	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
> > +	ents = xfs_dir3_leaf_ents_p(leaf);
> >  
> > -	leaf = bp->b_addr;
> > -	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> 
> Looks like this assert has gone missing.  It was intentionally more specific
> than the one in xfs_dir3_leaf_hdr_from_disk, right?

Yup, fixed.

> 
> > @@ -547,16 +560,19 @@ xfs_dir2_leafn_lookup_for_addname(
> >  	xfs_dir2_db_t		newdb;		/* new data block number */
> >  	xfs_dir2_db_t		newfdb;		/* new free block number */
> >  	xfs_trans_t		*tp;		/* transaction pointer */
> > +	struct xfs_dir2_leaf_entry *ents;
> > +	struct xfs_dir3_icleaf_hdr leafhdr;
> >  
> >  	dp = args->dp;
> >  	tp = args->trans;
> >  	mp = dp->i_mount;
> >  	leaf = bp->b_addr;
> > -	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> 
> Here the assert is also missing, but it looks like it is handled below in
> xfs_dir3_leaf_check.  Maybe the above is similar.

Yup, handled by xfs_dir3_leaf_check().

> > @@ -694,16 +710,19 @@ xfs_dir2_leafn_lookup_for_entry(
> >  	xfs_dir2_db_t		newdb;		/* new data block number */
> >  	xfs_trans_t		*tp;		/* transaction pointer */
> >  	enum xfs_dacmp		cmp;		/* comparison result */
> > +	struct xfs_dir2_leaf_entry *ents;
> > +	struct xfs_dir3_icleaf_hdr leafhdr;
> >  
> >  	dp = args->dp;
> >  	tp = args->trans;
> >  	mp = dp->i_mount;
> >  	leaf = bp->b_addr;
> > -	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> 
> Again.  But you've also got xfs_dir3_leaf_check below, so maybe the first one is
> the only issue.

*nod*

> > +xfs_dir3_leafn_moveents(
> > +	xfs_da_args_t			*args,	/* operation arguments */
> > +	struct xfs_buf			*bp_s,	/* source */
> > +	struct xfs_dir3_icleaf_hdr	*shdr,
> > +	struct xfs_dir2_leaf_entry	*sents,
> > +	int				start_s,/* source leaf index */
> > +	struct xfs_buf			*bp_d,	/* destination */
> > +	struct xfs_dir3_icleaf_hdr	*dhdr,
> > +	struct xfs_dir2_leaf_entry	*dents,
> > +	int				start_d,/* destination leaf index */
> > +	int				count)	/* count of leaves to copy */
> >  {
> > -	xfs_dir2_leaf_t	*leaf_d;		/* destination leaf structure */
> > -	xfs_dir2_leaf_t	*leaf_s;		/* source leaf structure */
> > -	int		stale;			/* count stale leaves copied */
> > -	xfs_trans_t	*tp;			/* transaction pointer */
> > +	int		stale;
> 
> I agree
> 						/* transaction pointer */
> is a bit overkill but
> 						/* count stale leaves copied */
> does help a new reader of this code.

I figured it redundant with the comment where stale is counted:

        /*
         * If the source has stale leaves, count the ones in the copy range
         * so we can update the header correctly.
         */

Added it back, anyway.

> 
> > @@ -922,21 +936,25 @@ xfs_dir2_leafn_moveents(
> >   */
> >  int						/* sort order */
> >  xfs_dir2_leafn_order(
> > -	struct xfs_buf	*leaf1_bp,		/* leaf1 buffer */
> > -	struct xfs_buf	*leaf2_bp)		/* leaf2 buffer */
> > +	struct xfs_buf		*leaf1_bp,		/* leaf1 buffer */
> > +	struct xfs_buf		*leaf2_bp)		/* leaf2 buffer */
> >  {
> > -	xfs_dir2_leaf_t	*leaf1;			/* leaf1 structure */
> > -	xfs_dir2_leaf_t	*leaf2;			/* leaf2 structure */
> > -
> > -	leaf1 = leaf1_bp->b_addr;
> > -	leaf2 = leaf2_bp->b_addr;
> > -	ASSERT(leaf1->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> > -	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> 
> These asserts are more specific than those in xfs_dir3_leaf_hdr_from_disk so
> they should probably stay and have dirv3 magic added.

Right, but there's higher layer validation of the magic numbers
via xfs_dir3_leaf_check before/after this function is called, so the
checking here is mostly redundant....

> 
> > @@ -1153,6 +1193,8 @@ xfs_dir2_leafn_remove(
> >  	int			needscan;	/* need to rescan data frees */
> >  	xfs_trans_t		*tp;		/* transaction pointer */
> >  	struct xfs_dir2_data_free *bf;		/* bestfree table */
> > +	struct xfs_dir3_icleaf_hdr leafhdr;
> > +	struct xfs_dir2_leaf_entry *ents;
> >  
> >  	trace_xfs_dir2_leafn_remove(args, index);
> >  
> > @@ -1160,11 +1202,14 @@ xfs_dir2_leafn_remove(
> >  	tp = args->trans;
> >  	mp = dp->i_mount;
> >  	leaf = bp->b_addr;
> > -	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> 
> Another assert that is more specific than what it is replaced with, but you do
> have a leafn check, so that's something.

Right, the leaf block is fully checked in the function, so this is
covered.

> > @@ -1366,6 +1413,8 @@ xfs_dir2_leafn_toosmall(
> >  	xfs_da_blkinfo_t	*info;		/* leaf block header */
> 
> Looks like you can get rid of the info pointer now.

Done.

> 
> > @@ -1374,10 +1423,12 @@ xfs_dir2_leafn_toosmall(
> >  	 */
> >  	blk = &state->path.blk[state->path.active - 1];
> >  	info = blk->bp->b_addr;
> > -	ASSERT(info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> 
> Another assert that is more specific than it's replacement.

added a xfs_dir3_leaf_check() call.

> 
> > @@ -1428,13 +1481,15 @@ xfs_dir2_leafn_toosmall(
> >  		/*
> >  		 * Count bytes in the two blocks combined.
> >  		 */
> > -		leaf = (xfs_dir2_leaf_t *)info;
> > -		count = be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
> > +		count = leafhdr.count - leafhdr.stale;
> >  		bytes = state->blocksize - (state->blocksize >> 2);
> > +
> >  		leaf = bp->b_addr;
> > -		ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> > -		count += be16_to_cpu(leaf->hdr.count) - be16_to_cpu(leaf->hdr.stale);
> > -		bytes -= count * (uint)sizeof(leaf->ents[0]);
> 				 ^^^^^ 
> I wonder why that (uint) was added.

sizeof() returns a size_t. A compiler/lint probably once complained
about type mismatches.

> 
> > @@ -1481,34 +1536,52 @@ xfs_dir2_leafn_unbalance(
> >  	xfs_da_args_t		*args;		/* operation arguments */
> >  	xfs_dir2_leaf_t		*drop_leaf;	/* dead leaf structure */
> >  	xfs_dir2_leaf_t		*save_leaf;	/* surviving leaf structure */
> > +	struct xfs_dir3_icleaf_hdr shdr;
> > +	struct xfs_dir3_icleaf_hdr dhdr;
> > +	struct xfs_dir2_leaf_entry *sents;
> > +	struct xfs_dir2_leaf_entry *dents;
> 
> As I read this I really had a hard time not thinking 'source' and 'dest'
> instead of 'save' and 'drop'.  This would be more readable as the latter.

Fixed.

> 
> >  
> >  	args = state->args;
> >  	ASSERT(drop_blk->magic == XFS_DIR2_LEAFN_MAGIC);
> >  	ASSERT(save_blk->magic == XFS_DIR2_LEAFN_MAGIC);
> >  	drop_leaf = drop_blk->bp->b_addr;
> >  	save_leaf = save_blk->bp->b_addr;
> > -	ASSERT(drop_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> > -	ASSERT(save_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> 
> More specific assert than its replacement.

At the end, save_leaf is fully checked. And drop_leaf is now fully
validated by the preivous call to xfs_dir2_leafn_toosmall().
So the asserts are redundant...

> We used to check it in debug code.  Might as well continue to do so.

And we do ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
