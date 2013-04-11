Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 58AD77F51
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 11:16:58 -0500 (CDT)
Date: Thu, 11 Apr 2013 11:16:54 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 13/22] xfs: add CRC checking to dir2 leaf blocks
Message-ID: <20130411161654.GT30652@sgi.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<1364965892-19623-14-git-send-email-david@fromorbit.com>
	<20130410174639.GG22182@sgi.com> <20130411020606.GE10481@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130411020606.GE10481@dastard>
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

Hey,

On Thu, Apr 11, 2013 at 12:06:06PM +1000, Dave Chinner wrote:
> On Wed, Apr 10, 2013 at 12:46:39PM -0500, Ben Myers wrote:
> > > @@ -396,11 +397,18 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
> > >  		size = (int)((char *)&oldroot->btree[be16_to_cpu(oldroot->hdr.count)] -
> > >  			     (char *)oldroot);
> > >  	} else {
> > > -		ASSERT(oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> > > +		struct xfs_dir3_icleaf_hdr leafhdr;
> > > +		struct xfs_dir2_leaf_entry *ents;
> > > +
> > >  		leaf = (xfs_dir2_leaf_t *)oldroot;
> > > -		size = (int)((char *)&leaf->ents[be16_to_cpu(leaf->hdr.count)] -
> > > -			     (char *)leaf);
> > > +		xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
> > > +		ents = xfs_dir3_leaf_ents_p(leaf);
> > > +
> > > +		ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
> > > +		       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
> > > +		size = (int)((char *)&ents[leafhdr.count] - (char *)leaf);
> > >  	}
> > > +	/* XXX: can't just copy CRC headers from one block to another */
> > 
> > What is your plan for resolving that?
> 
> It's fixed in a later patch when the da btree nodes have CRCs
> added to them.

I'll keep my eyes peeled for it.

> > > @@ -2281,10 +2299,17 @@ xfs_da_read_buf(
> > >  		    XFS_TEST_ERROR((magic != XFS_DA_NODE_MAGIC) &&
> > >  				   (magic != XFS_ATTR_LEAF_MAGIC) &&
> > >  				   (magic != XFS_DIR2_LEAF1_MAGIC) &&
> > > +				   (magic != XFS_DIR3_LEAF1_MAGIC) &&
> > >  				   (magic != XFS_DIR2_LEAFN_MAGIC) &&
> > > +				   (magic != XFS_DIR3_LEAFN_MAGIC) &&
> > >  				   (magic1 != XFS_DIR2_BLOCK_MAGIC) &&
> > > +				   (magic1 != XFS_DIR3_BLOCK_MAGIC) &&
> > 
> > Did this DIR3_BLOCK_MAGIC change sneak in from another patch?
> ...
> > Do DIRx_DATA_MAGIC and DIRx_FREE_MAGIC belong in a different patch?
> 
> Probably, though given that at this point in the series they'll
> never be set, it isn't actually a bug or anything that will break a
> bisection. Do I really need to move these back into 3 previous
> patches?

Nah, I just want to make sure I understand what happened there.

> Kind in mind that means I also need to do all these changes in the
> userspace patch series as well...
>
> > > +static bool
> > > +xfs_dir3_leaf_verify(
> > >  	struct xfs_buf		*bp,
> > > -	__be16			magic)
> > > +	__uint16_t		magic)
> > > +{
> > > +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > > +	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> > > +	struct xfs_dir3_icleaf_hdr leafhdr;
> > > +
> > > +	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
> > 
> > Using v2 magics to choose between leaf1 and leafn is ok, but not as clear as
> > using a non-version-specific #define or enum might be for this purpose.
> 
> The magic number passed in is actually used to validate the
> magic number in the block being verified. I don't see any point in
> inventing a new LEAF1/LEAFN identifier and then have to use that to
> determine what the correct magic number is when we can just pass in
> the magic number we expect....
> 
> Besides, we already use the magic numbers in this manner to identify
> block types in the struct xfs_da_state_blk that is passed through
> the da btree code, this is a pattern that is already well
> established.

*nod*

> > > @@ -169,27 +432,34 @@ xfs_dir2_block_to_leaf(
> > >  	/*
> > >  	 * Initialize the leaf block, get a buffer for it.
> > >  	 */
> > > -	if ((error = xfs_dir2_leaf_init(args, ldb, &lbp, XFS_DIR2_LEAF1_MAGIC))) {
> > > +	error = xfs_dir3_leaf_get_buf(args, ldb, &lbp, XFS_DIR2_LEAF1_MAGIC);
> > > +	if (error)
> > >  		return error;
> > > -	}
> > > -	ASSERT(lbp != NULL);
> > > +
> > >  	leaf = lbp->b_addr;
> > >  	hdr = dbp->b_addr;
> > >  	xfs_dir3_data_check(dp, dbp);
> > >  	btp = xfs_dir2_block_tail_p(mp, hdr);
> > >  	blp = xfs_dir2_block_leaf_p(btp);
> > >  	bf = xfs_dir3_data_bestfree_p(hdr);
> > > +	ents = xfs_dir3_leaf_ents_p(leaf);
> > > +
> > >  	/*
> > >  	 * Set the counts in the leaf header.
> > > +	 *
> > > +	 * XXX: are these actually logged, or just gathered by chance?
> > 
> > Nice find.  I'm not seeing where that header is being logged.  Worth a separate
> > patch.
> 
> I haven't fixed anything. I just added the comment as something to
> come back to.  As it is, I can answer that question directly right
> now: they are gathered by chance by the xfs_dir2_leaf_log_ents()
> call a few lines below due to the fact that the first dirent is in
> the range covered by the first dirty bit of the logging regions
> (i.e. 0-127 bytes into the buffer).
> 
> So there isn't a bug here, and the header is logged implicity rather
> than explicitly. As such, I don't think there's anything that needs
> to be put in a separate patch because there is no bug being fixed
> here.
> 
> I have, however, removed the comment and put an explicit call to
> xfs_dir3_leaf_log_header() in there.

Thanks for adding the call.  I prefer that it be done explicitly.  I'll spin up
a patch for it if you don't want to.

> > >  void
> > > -xfs_dir2_leaf_log_header(
> > > +xfs_dir3_leaf_log_header(
> > >  	struct xfs_trans	*tp,
> > >  	struct xfs_buf		*bp)
> > >  {
> > > -	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
> > > +	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> > >  
> > > -	leaf = bp->b_addr;
> > >  	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAF1_MAGIC) ||
> > > -	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> > > +	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
> > > +	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
> > > +	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
> > > +
> > >  	xfs_trans_log_buf(tp, bp, (uint)((char *)&leaf->hdr - (char *)leaf),
> > > -		(uint)(sizeof(leaf->hdr) - 1));
> > > +			  xfs_dir3_leaf_hdr_size(leaf));
> > 			  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > Should be xfs_dir3_leaf_hdr_size(leaf) - 1, I think.
> 
> Good catch. Fixed.
> 
> (Not a bug, though, because of the 128 byte resolution of the dirty
> bit tracking. The dir2/dir3 leaf header size is 16/64 bytes, so we
> are always logging 128 bytes here regardless of the off-by-one.)

Depends upon your definition of bug.  When using this interface I'm not sure
what assumptions one should be allowed to make about the resolution of dirty
bit tracking underneath.

> > > @@ -1374,10 +1423,12 @@ xfs_dir2_leafn_toosmall(
> > >  	 */
> > >  	blk = &state->path.blk[state->path.active - 1];
> > >  	info = blk->bp->b_addr;
> > > -	ASSERT(info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> > 
> > Another assert that is more specific than it's replacement.
> 
> added a xfs_dir3_leaf_check() call.
...

> > > @@ -1481,34 +1536,52 @@ xfs_dir2_leafn_unbalance(
...
> > >  	args = state->args;
> > >  	ASSERT(drop_blk->magic == XFS_DIR2_LEAFN_MAGIC);
> > >  	ASSERT(save_blk->magic == XFS_DIR2_LEAFN_MAGIC);
> > >  	drop_leaf = drop_blk->bp->b_addr;
> > >  	save_leaf = save_blk->bp->b_addr;
> > > -	ASSERT(drop_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> > > -	ASSERT(save_leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC));
> > 
> > More specific assert than its replacement.
> 
> At the end, save_leaf is fully checked. And drop_leaf is now fully
> validated by the preivous call to xfs_dir2_leafn_toosmall().
> So the asserts are redundant...

Ah, because you just added a dir3_leaf_check to dir2_leafn_toosmall.  Works for me.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
