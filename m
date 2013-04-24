Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6A917F37
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 19:33:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48946AC00E
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 17:33:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aRSa96FGyC6LmFCH for <xfs@oss.sgi.com>;
	Tue, 23 Apr 2013 17:33:21 -0700 (PDT)
Date: Wed, 24 Apr 2013 10:33:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/22] xfs: add CRCs to dir2/da node blocks
Message-ID: <20130424003317.GO10481@dastard>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<1364965892-19623-16-git-send-email-david@fromorbit.com>
	<20130422185550.GA29359@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130422185550.GA29359@sgi.com>
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
Cc: Dave Chinner <davidatfromorbit.com@sgi.com>, xfs@oss.sgi.com

On Mon, Apr 22, 2013 at 01:55:50PM -0500, Ben Myers wrote:
> On Wed, Apr 03, 2013 at 04:11:25PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner at redhat.com>
> > 
> > Signed-off-by: Dave Chinner <dchinner at redhat.com>
....
> > @@ -25,6 +24,7 @@
> >  #include "xfs_sb.h"
> >  #include "xfs_ag.h"
> >  #include "xfs_mount.h"
> > +#include "xfs_error.h"
> >  #include "xfs_da_btree.h"
> >  #include "xfs_bmap_btree.h"
> >  #include "xfs_attr_sf.h"
> > @@ -35,7 +35,6 @@
> >  #include "xfs_bmap.h"
> >  #include "xfs_attr.h"
> >  #include "xfs_attr_leaf.h"
> > -#include "xfs_error.h"
> 
> Why did xfs_error.h need to be moved?

Most likely it got moved during debugging when I put stuff in static
inline functions and I forgot to revert it when removing the
debug. Fixed.

> > @@ -935,16 +936,16 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
> >  	/*
> >  	 * Set up the new root node.
> >  	 */
> > -	error = xfs_da_node_create(args, 0, 1, &bp1, XFS_ATTR_FORK);
> > +	error = xfs_da3_node_create(args, 0, 1, &bp1, XFS_ATTR_FORK);
> >  	if (error)
> >  		goto out;
> >  	node = bp1->b_addr;
> >  	leaf = bp2->b_addr;
> >  	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
> >  	/* both on-disk, don't endian-flip twice */
> > -	node->btree[0].hashval =
> > -		leaf->entries[be16_to_cpu(leaf->hdr.count)-1 ].hashval;
> > -	node->btree[0].before = cpu_to_be32(blkno);
> > +	btree = xfs_da3_node_tree_p(node);
> > +	btree[0].hashval = leaf->entries[be16_to_cpu(leaf->hdr.count)-1 ].hashval;
> 
> Extra space.

Sure, but it is in part of the expression that I wasn't modifying in
this patch set. I convert the leaf->hdr stuff in the next patch -
the space is removed there....

> > +	if (ichdr.count > mp->m_dir_node_ents &&
> > +	    ichdr.count > mp->m_attr_node_ents)
> > +		return false;
> > +
> > +	/* XXX: hash order check? */
> 
> Still planning to add that in a subsequent patch?

Not in this patch set - all the "we should add more checks" comments
are things that need to be added, but are not needed for the CRC
conversions to work correctly. I intend to address these things once
the initial patch set is sorted out....

> > +xfs_da3_node_create(
> > +	struct xfs_da_args	*args,
> > +	xfs_dablk_t		blkno,
> > +	int			level,
> > +	struct xfs_buf		**bpp,
> > +	int			whichfork)
> >  {
> > -	xfs_da_intnode_t *node;
> > -	struct xfs_buf *bp;
> > -	int error;
> > -	xfs_trans_t *tp;
> > +	struct xfs_da_intnode	*node;
> > +	struct xfs_trans	*tp = args->trans;
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_da3_icnode_hdr ichdr = {0};
> > +	struct xfs_buf		*bp;
> > +	int			error;
> >  
> >  	trace_xfs_da_node_create(args);
> > +	ASSERT(level <= XFS_DA_NODE_MAXDEPTH);
> >  
> > -	tp = args->trans;
> >  	error = xfs_da_get_buf(tp, args->dp, blkno, -1, &bp, whichfork);
> 
> Looks like this function can return 0 with a null bp.  We should probably check
> for that.

It will only return 0 with a null bp if mappedbno == -2. In this
case it is -1, so it will return EFSCORRUPTED rather than zero for
the case where we land incorrectly a hole in the mapping.

> > @@ -320,8 +474,10 @@ xfs_da_split(xfs_da_state_t *state)
> >  	 * just got bumped because of the addition of a new root node.
> >  	 * There might be three blocks involved if a double split occurred,
> >  	 * and the original block 0 could be at any position in the list.
> > +	 *
> > +	 * Note: the info structures being modified here for both v2 and v3 da
> > +	 * headers, so we can do this linkage just using the v2 structures.
> 
> I had a hard time parsing that the first few times.  How about something like:
> 
> Note:  The xfs_da_blkinfo fields being modified here are shared by both
> xfs_da_node_hdr and xfs_da3_intnode, and occur before the additional fields
> added in xfs_da3_intnode, so this linkage can be done using just the v2
> structures.

That's probably just as unclear. Changed to:

Note: the magic numbers and sibling pointers are in the same
physical place for both v2 and v3 headers (by design). Hence it
doesn't matter which version of the xfs_da_intnode structure we use
here as the result will be the same using either structure.

> 
> > @@ -591,12 +801,12 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
> >  		 * Move the req'd B-tree elements from high in node1 to
> >  		 * low in node2.
> >  		 */
> > -		be16_add_cpu(&node2->hdr.count, count);
> > +		nodehdr2.count += count;
> >  		tmp = count * (uint)sizeof(xfs_da_node_entry_t);
> > -		btree_s = &node1->btree[be16_to_cpu(node1->hdr.count) - count];
> > -		btree_d = &node2->btree[0];
> > +		btree_s = &btree1[nodehdr1.count- count];
> 						^ 
> Add a space.

Fixed.

> >  /*
> > - * Unbalance the btree elements between two intermediate nodes,
> > + * Unbalance the elements between two intermediate nodes,
> >   * move all Btree elements from one node into another.
> >   */
> >  STATIC void
> > -xfs_da_node_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
> > -				     xfs_da_state_blk_t *save_blk)
> > +xfs_da3_node_unbalance(
> > +	struct xfs_da_state	*state,
> > +	struct xfs_da_state_blk	*drop_blk,
> > +	struct xfs_da_state_blk	*save_blk)
> >  {
> > -	xfs_da_intnode_t *drop_node, *save_node;
> > -	xfs_da_node_entry_t *btree;
> > -	int tmp;
> > -	xfs_trans_t *tp;
> > +	struct xfs_da_intnode	*drop_node;
> > +	struct xfs_da_intnode	*save_node;
> > +	struct xfs_da_node_entry *dbtree;
> > +	struct xfs_da_node_entry *sbtree;
> > +	struct xfs_da3_icnode_hdr dhdr;
> > +	struct xfs_da3_icnode_hdr shdr;
> 
> Would be better as drop and save.
> Extra spaces.

Fixed.

> > +	    (be32_to_cpu(dbtree[dhdr.count - 1].hashval) <
> > +				be32_to_cpu(sbtree[shdr.count - 1].hashval))) {
> > +		/* XXX: check this - is memmove dst correct? */
> > +		tmp = shdr.count * (uint)sizeof(xfs_da_node_entry_t);
> > +		memmove(&sbtree[dhdr.count], &sbtree[0], tmp);
> 
> I believe the destination in this memmove is correct.  We're moving items from
> the beginning of the save_node toward the end of save_node so that later we can
> copy from drop_node into the beginning of save_node.  Making room.
> 
> > +
> > +		sindex = 0;
> >  		xfs_trans_log_buf(tp, save_blk->bp,
> > -			XFS_DA_LOGRANGE(save_node, btree,
> > -				(be16_to_cpu(save_node->hdr.count) + be16_to_cpu(drop_node->hdr.count)) *
> > -				sizeof(xfs_da_node_entry_t)));
> > +			XFS_DA_LOGRANGE(save_node, &sbtree[0],
> > +				(shdr.count + dhdr.count) *
> > +						sizeof(xfs_da_node_entry_t)));
> 
> Seems like here we are logging more of the node than is strictly necessary.  So
> far we have only modified save_node at shdr.count up to shdr.count +
> dhdr.count, there is no need to log the beginning of save_node until after
> we've copied from drop_node into it.  Not a big deal I guess.

Logging is just tagging dirty regions - it can be done before or
after the modification is made. The contents of the dirty regions
have meaning at transaction commit time, but not here while the
transactional modifications are being made....

In this case, doing it before just means less branches and less
complex code as we already have the context to make the right
decision just before the modification is done.


> >  	} else {
> > -		btree = &save_node->btree[be16_to_cpu(save_node->hdr.count)];
> > +		sindex = shdr.count;
> >  		xfs_trans_log_buf(tp, save_blk->bp,
> > -			XFS_DA_LOGRANGE(save_node, btree,
> > -				be16_to_cpu(drop_node->hdr.count) *
> > -				sizeof(xfs_da_node_entry_t)));
> > +			XFS_DA_LOGRANGE(save_node, &sbtree[sindex],
> > +				dhdr.count * sizeof(xfs_da_node_entry_t)));
> 
> And here it seems that we're logging save_node before we've made any
> modification to it.  Maybe I'm missing something.

See above...

> > -	tmp = be16_to_cpu(drop_node->hdr.count) * (uint)sizeof(xfs_da_node_entry_t);
> > -	memcpy(btree, &drop_node->btree[0], tmp);
> > -	be16_add_cpu(&save_node->hdr.count, be16_to_cpu(drop_node->hdr.count));
> > +	tmp = dhdr.count * (uint)sizeof(xfs_da_node_entry_t);
> > +	memcpy(&sbtree[sindex], &dbtree[0], tmp);
> > +	shdr.count += dhdr.count;
> > +	xfs_da3_node_hdr_to_disk(save_node, &shdr);
> >  	xfs_trans_log_buf(tp, save_blk->bp,
> >  		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
> > -			sizeof(save_node->hdr)));
> > +				xfs_da3_node_hdr_size(save_node)));
> >  
> 
> And then after modifying save_node by copying stuff in from drop_blk we only
> log the header, and not the entries.  I guess I'd prefer to see the entries
> logged after they've been modified.  It's not a bug, looks like.. just not what
> I'm used to seeing.

Yeah, it's a little unusual, but it's not incorrect, and this is
done in some places simply because it makes the code more concise
and less branch intensive....

> > @@ -1190,66 +1478,73 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
> >  		}
> >  		curr = blk->bp->b_addr;
> >  		blk->magic = be16_to_cpu(curr->magic);
> > -		ASSERT(blk->magic == XFS_DA_NODE_MAGIC ||
> > -		       blk->magic == XFS_DIR2_LEAFN_MAGIC ||
> > -		       blk->magic == XFS_ATTR_LEAF_MAGIC);
> > +
> > +		if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
> > +			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
> > +			break;
> > +		}
> > +
> > +		if (blk->magic == XFS_DIR2_LEAFN_MAGIC ||
> > +		    blk->magic == XFS_DIR3_LEAFN_MAGIC) {
> > +			blk->magic = XFS_DIR2_LEAFN_MAGIC;
> > +			blk->hashval = xfs_dir2_leafn_lasthash(blk->bp, NULL);
> > +			break;
> > +		}
> 
> Something like this would be better for this rearrangement:
> 
> 	if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
> 		...
> 		break;
> 	} else if (blk->magic == XFS_DIR2_LEAFN_MAGIC ||
> 		   blk->magic == XFS_DIR3_LEAFN_MAGIC) {
> 		...
> 		break;
> 	} else if (blk->magic != XFS_DA_NODE_MAGIC) {
> 		return XFS_ERROR(EFSCORRUPTED);
> 	}
> 
> So that we're sure what kind of block we have.

It's not actually determining whether the block is valid or not -
the call to xfs_da3_node_read() will have already checked that for
us. i.e. we already know it is a ATTR/DIR/DA block and so are just
breaking out of the root->leaf walk being done here...

> 
> > +
> > +		blk->magic = XFS_DA_NODE_MAGIC;
> > +
> 
> Why was that assignment necessary?

Because this is the xfs_da_state block type, not the on-disk
version. i.e. the da_state manipulation logic treats
XFS_DA_NODE_MAGIC/XFS_DA3_NODE_MAGIC identically, so it makes no
sense to have all the da_state code have to check for 2 different
magic numbers everywhere. hence if

		blk->magic = be16_to_cpu(curr->magic);

gives us blk->magic == XFS_DA3_NODE_MAGIC, we need to reset it to
XFS_DA_NODE_MAGIC so all the existing da_state code works without
modification. The same is done with dir2/dir3 leafn magic numbers,
and in a later patch with the attr3 leaf magic numbers.

> > @@ -1316,9 +1647,6 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
> >  	ASSERT(old_blk->magic == XFS_DA_NODE_MAGIC ||
> >  	       old_blk->magic == XFS_DIR2_LEAFN_MAGIC ||
> >  	       old_blk->magic == XFS_ATTR_LEAF_MAGIC);
> 
> Seems like these asserts need to be updated.

And this is exactly why the above code does what it does. The
da_state code only cares about da_node/dir leaf/attr leaf
distinctions, not what the physical encoding of the structures on
disk are.

> 
> > -	ASSERT(old_blk->magic == be16_to_cpu(old_info->magic));
> > -	ASSERT(new_blk->magic == be16_to_cpu(new_info->magic));
> > -	ASSERT(old_blk->magic == new_blk->magic);
> 
> These seem like good asserts.

But now wrong, because they are asserting that the da_state magic
numbers are the same as the physical structure on disk.

The callouts in the functions based on the magic numbers:

        switch (old_blk->magic) {
        case XFS_ATTR_LEAF_MAGIC:
                before = xfs_attr_leaf_order(old_blk->bp, new_blk->bp);
                break;
        case XFS_DIR2_LEAFN_MAGIC:
                before = xfs_dir2_leafn_order(old_blk->bp, new_blk->bp);
                break;
        case XFS_DA_NODE_MAGIC:
                before = xfs_da3_node_order(old_blk->bp, new_blk->bp);
                break;

Do the correct verification of the physical magic numbers, as does
the higher level calling code....

FWIW, the da_state based code is a good candidate for converting to
an ops based abstraction like the generic btree code uses so that
these sorts of switch statements code go away....

> > @@ -1449,8 +1738,6 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
> >  	ASSERT(save_blk->magic == XFS_DA_NODE_MAGIC ||
> >  	       save_blk->magic == XFS_DIR2_LEAFN_MAGIC ||
> >  	       save_blk->magic == XFS_ATTR_LEAF_MAGIC);
> 		
> Seems like these asserts need to be updated.
> 
> > -	ASSERT(save_blk->magic == be16_to_cpu(save_info->magic));
> > -	ASSERT(drop_blk->magic == be16_to_cpu(drop_info->magic));
> 
> These two seem like useful asserts.

Validated by higher level code, and incorrect because of the above
physical/logical discrimination...

> > @@ -1856,17 +2176,22 @@ xfs_da_swap_lastblock(
> >  		dead_level = 0;
> >  		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
> >  	} else {
> > -		ASSERT(dead_info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
> > +		struct xfs_da3_icnode_hdr deadhdr;
> > +
> > +		ASSERT(dead_info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
> > +		       dead_info->magic == cpu_to_be16(XFS_DA3_NODE_MAGIC));
> 
> I think these are covered by asserts in xfs_da3_node_hdr_from_disk and can be removed.

Fixed.

> > @@ -1912,31 +2237,31 @@ xfs_da_swap_lastblock(
> >  	 * Walk down the tree looking for the parent of the moved block.
> >  	 */
> >  	for (;;) {
> > -		error = xfs_da_node_read(tp, ip, par_blkno, -1, &par_buf, w);
> > +		error = xfs_da3_node_read(tp, ip, par_blkno, -1, &par_buf, w);
> >  		if (error)
> >  			goto done;
> >  		par_node = par_buf->b_addr;
> > -		if (unlikely(par_node->hdr.info.magic !=
> > -		    cpu_to_be16(XFS_DA_NODE_MAGIC) ||
> > -		    (level >= 0 && level != be16_to_cpu(par_node->hdr.level) + 1))) {
> > +		xfs_da3_node_hdr_from_disk(&par_hdr, par_node);
> > +		if (level >= 0 && level != par_hdr.level + 1) {
> 
> Do we need to test par_node magic here like we were before? 

I don't think so, because we validated that it is a node/leaf block
in xfs_da3_node_read(), debug kernels will assert fail in
xfs_da3_node_hdr_from_disk(), and the level checks will catch
problems with leaves being where nodes should be.  Hence I don't
think we lose anything here in terms of corruption detection....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
