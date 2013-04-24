Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8894C7F37
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 20:18:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E78DFAC002
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 18:18:00 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Rq3oHSABB28GTsKq for <xfs@oss.sgi.com>;
	Tue, 23 Apr 2013 18:17:57 -0700 (PDT)
Date: Wed, 24 Apr 2013 11:17:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/22] xfs: add CRCs to attr leaf blocks
Message-ID: <20130424011721.GP10481@dastard>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<1364965892-19623-17-git-send-email-david@fromorbit.com>
	<20130423230245.GC29359@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130423230245.GC29359@sgi.com>
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

On Tue, Apr 23, 2013 at 06:02:45PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Wed, Apr 03, 2013 at 04:11:26PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Comments below.
....
> > +	if (ichdr.count == 0)
> > +		return false;
> > +
> > +	/* XXX: need to range check rest of attr header values */
> > +	/* XXX: hash order check? */
> 
> Seems reasonable for debug code.  Is that coming along in a subsequent patch?

Same as for the last patch - not in this patch set, but in future
work.

> >  int
> > -xfs_attr_leaf_to_shortform(
> > -	struct xfs_buf	*bp,
> > -	xfs_da_args_t	*args,
> > -	int		forkoff)
> > +xfs_attr3_leaf_to_shortform(
> > +	struct xfs_buf		*bp,
> > +	struct xfs_da_args	*args,
> > +	int			forkoff)
> >  {
> > -	xfs_attr_leafblock_t *leaf;
> > -	xfs_attr_leaf_entry_t *entry;
> > -	xfs_attr_leaf_name_local_t *name_loc;
> > -	xfs_da_args_t nargs;
> > -	xfs_inode_t *dp;
> > -	char *tmpbuffer;
> > -	int error, i;
> > +	struct xfs_attr_leafblock *leaf;
> > +	struct xfs_attr3_icleaf_hdr ichdr;
> > +	struct xfs_attr_leaf_entry *entry;
> > +	struct xfs_attr_leaf_name_local *name_loc;
> > +	struct xfs_da_args	nargs;
> > +	struct xfs_inode	*dp = args->dp;
> > +	char			*tmpbuffer;
> > +	int			error;
> > +	int			i;
> >  
> >  	trace_xfs_attr_leaf_to_sf(args);
> >  
> > -	dp = args->dp;
> >  	tmpbuffer = kmem_alloc(XFS_LBSIZE(dp->i_mount), KM_SLEEP);
> > -	ASSERT(tmpbuffer != NULL);
> > +	if (!tmpbuffer)
> > +		return ENOMEM;
> >  
> > -	ASSERT(bp != NULL);
> >  	memcpy(tmpbuffer, bp->b_addr, XFS_LBSIZE(dp->i_mount));
> > +
> >  	leaf = (xfs_attr_leafblock_t *)tmpbuffer;
> > -	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
> > +	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
> > +	entry = xfs_attr3_leaf_entryp(leaf);
> > +
> > +	/* XXX (dgc): buffer is about to be marked stale - why zero it? */
> >  	memset(bp->b_addr, 0, XFS_LBSIZE(dp->i_mount));
> 
> Good point.  Why do we need a temporary buffer here?  It seems like we could
> keep the leaf around long enough to copy from it directly into shortform.

Right. I suspect that this dates back to a long time ago when we
didn't have busy extents preventing stale metadata exposure to
userspace and attributes used sync IO to avoid problems. There are
other grotty bits in the attribute code (e.g. remote attrs are
written synchronously rather than logged), so I'd say this is where
it came from. It's another thing that we can clean up later...

> > @@ -963,52 +1120,62 @@ out:
> >   * or a leaf in a node attribute list.
> >   */
> >  STATIC int
> > -xfs_attr_leaf_create(
> > -	xfs_da_args_t	*args,
> > -	xfs_dablk_t	blkno,
> > -	struct xfs_buf	**bpp)
> > +xfs_attr3_leaf_create(
> > +	struct xfs_da_args	*args,
> > +	xfs_dablk_t		blkno,
> > +	struct xfs_buf		**bpp)
> >  {
> > -	xfs_attr_leafblock_t *leaf;
> > -	xfs_attr_leaf_hdr_t *hdr;
> > -	xfs_inode_t *dp;
> > -	struct xfs_buf *bp;
> > -	int error;
> > +	struct xfs_attr_leafblock *leaf;
> > +	struct xfs_attr3_icleaf_hdr ichdr;
> > +	struct xfs_inode	*dp = args->dp;
> > +	struct xfs_mount	*mp = dp->i_mount;
> > +	struct xfs_buf		*bp;
> > +	int			error;
> >  
> >  	trace_xfs_attr_leaf_create(args);
> >  
> > -	dp = args->dp;
> > -	ASSERT(dp != NULL);
> >  	error = xfs_da_get_buf(args->trans, args->dp, blkno, -1, &bp,
> >  					    XFS_ATTR_FORK);
> >  	if (error)
> > -		return(error);
> > -	bp->b_ops = &xfs_attr_leaf_buf_ops;
> > +		return error;
> > +	bp->b_ops = &xfs_attr3_leaf_buf_ops;
> >  	leaf = bp->b_addr;
> > -	memset((char *)leaf, 0, XFS_LBSIZE(dp->i_mount));
> > -	hdr = &leaf->hdr;
> > -	hdr->info.magic = cpu_to_be16(XFS_ATTR_LEAF_MAGIC);
> > -	hdr->firstused = cpu_to_be16(XFS_LBSIZE(dp->i_mount));
> > -	if (!hdr->firstused) {
> > -		hdr->firstused = cpu_to_be16(
> > -			XFS_LBSIZE(dp->i_mount) - XFS_ATTR_LEAF_NAME_ALIGN);
> > -	}
> 
> Saw this several times in review.  I don't understand why that code would be
> there, given that we just set firstused to be XFS_LBSIZE, the blocksize of the
> filesystem.  It's dead code now, so it's fine to remove... There must be some
> history there.  Any idea?

It's in the initial commit for the attribute code way back in 1995.
It didn't make sense then, either, because there's code right around
it such as memory allocations that use XFS_LBSIZE(dp->i_mount) as
the size of the buffer to allocate. Hence I think it's been dead
code ever since it was written...

> > @@ -1113,82 +1279,90 @@ xfs_attr_leaf_add(
> >  	 * and we don't have enough freespace, then compaction will do us
> >  	 * no good and we should just give up.
> >  	 */
> > -	if (!hdr->holes && (sum < entsize))
> > -		return(XFS_ERROR(ENOSPC));
> > +	if (!ichdr.holes && sum < entsize)
> > +		return XFS_ERROR(ENOSPC);
> >  
> >  	/*
> >  	 * Compact the entries to coalesce free space.
> >  	 * This may change the hdr->count via dropping INCOMPLETE entries.
> >  	 */
> > -	xfs_attr_leaf_compact(args, bp);
> > +	xfs_attr3_leaf_compact(args, &ichdr, bp);
> >  
> >  	/*
> >  	 * After compaction, the block is guaranteed to have only one
> >  	 * free region, in freemap[0].  If it is not big enough, give up.
> >  	 */
> > -	if (be16_to_cpu(hdr->freemap[0].size)
> > -				< (entsize + sizeof(xfs_attr_leaf_entry_t)))
> > -		return(XFS_ERROR(ENOSPC));
> > +	if (ichdr.freemap[0].size < (entsize + sizeof(xfs_attr_leaf_entry_t))) {
> > +		tmp = ENOSPC;
> > +		goto out_log_hdr;
> 
> That represents a change in behavior that I'm not sure about... Before if we
> had ENOSPC here we would simply return and xfs_addr3_leaf_add_work would not
> have a chance to log the header.  Now...

The difference is that hte header used to be logged in
xfs_attr_leaf_compact(). Now it is not logged in
xfs_attr3_leaf_compact() because the in-core header is modified.
Hence on an enospc error we now have to write back and log the
header. Hence there is no change in behaviour here...

> 
> > +	}
> > +
> > +	tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
> >  
> > -	return(xfs_attr_leaf_add_work(bp, args, 0));
> > +out_log_hdr:
> > +	xfs_attr3_leaf_hdr_to_disk(leaf, &ichdr);
> > +	xfs_trans_log_buf(args->trans, bp,
> > +		XFS_DA_LOGRANGE(leaf, &leaf->hdr,
> > +				xfs_attr3_leaf_hdr_size(leaf)));
> 
> We're logging the header here instead of in xfs_attr_leaf_add_work

Right, for the same reason as the above enospc branch - we passed
the ichdr to xfs_attr3_leaf_compact() so the header modifications
are made to the ichdr, not the buffer. The same is done here,
because it means we don't repeatedly convert to/from ichdr and
on-disk header and log it every time. Instead, we read it from disk
once in this function and pass the ichdr around to collect all the
modifications and then write it back to the disk buffer once and log
it only once....

> > +	return tmp;
> >  }
> 
> and then returning.  I think this would be better with a second goto so that we
> don't log the header in keeping with the old behavior.

The way it is done with these modifications gives an identical dirty
range on the buffer as the old code; it is just more efficient as we
do a lot less endian swapping and logging calls...

> >  	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; map++, i++) {
> 
> Looks like you can get rid of map.

Good catch. Fixed.

> > @@ -1286,34 +1457,69 @@ xfs_attr_leaf_compact(
> >  	 */
> >  	leaf_s = (xfs_attr_leafblock_t *)tmpbuffer;
> >  	leaf_d = bp->b_addr;
> > -	hdr_s = &leaf_s->hdr;
> > -	hdr_d = &leaf_d->hdr;
> > -	hdr_d->info = hdr_s->info;	/* struct copy */
> > -	hdr_d->firstused = cpu_to_be16(XFS_LBSIZE(mp));
> > -	/* handle truncation gracefully */
> > -	if (!hdr_d->firstused) {
> > -		hdr_d->firstused = cpu_to_be16(
> > -				XFS_LBSIZE(mp) - XFS_ATTR_LEAF_NAME_ALIGN);
> > -	}
> 
> Another one.  Weird.
> 
> > -	hdr_d->usedbytes = 0;
> > -	hdr_d->count = 0;
> > -	hdr_d->holes = 0;
> > -	hdr_d->freemap[0].base = cpu_to_be16(sizeof(xfs_attr_leaf_hdr_t));
> > -	hdr_d->freemap[0].size = cpu_to_be16(be16_to_cpu(hdr_d->firstused) -
> > -					     sizeof(xfs_attr_leaf_hdr_t));
> > +	ichdr_s = *ichdr_d;	/* struct copy */
> 
> ichdr_s should be initialized from the copy we have in the temporary buffer
> rather than from a struct copy of ichdr_d.  I understand that what you have
> here probably works fine, but it is not very obvious, or clear that it was
> an intentional deviation from the struct copy up above.

I disagree: the canonical source of the ichdr information being
passed in is in ichdr_d, not in the on disk buffer. That is the
reason ichdr_d is passed into the function - because modifications
to the ichdr may have been made and not written back to the backing
buffer before the function was called.

If you check the code above and the various explanations of it,
you'll see that this is the that is the exact situation in which
xfs_attr3_leaf_compact() is called. Hence reading ichdr_s out of the
on-disk buffer is the wrong thing to do and would likely result in
corruptions caused by compacting blocks...


> > +	xfs_attr3_leaf_moveents(leaf_s, &ichdr_s, 0, leaf_d, ichdr_d, 0,
> > +				ichdr_s.count, mp);
> > +	/*
> > +	 * this logs the entire buffer, but the caller must write the header
> > +	 * back to the buffer when it is finished modifying it.
> > +	 */
> >  	xfs_trans_log_buf(trans, bp, 0, XFS_LBSIZE(mp) - 1);
> 
> Maybe better to just log the entries here, someday.

*nod*

> 
> > @@ -2201,45 +2425,41 @@ xfs_attr_leaf_moveents(xfs_attr_leafblock_t *leaf_s, int start_s,
> >  	/*
> >  	 * Set up environment.
> >  	 */
> > -	ASSERT(leaf_s->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
> > -	ASSERT(leaf_d->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
> > -	hdr_s = &leaf_s->hdr;
> > -	hdr_d = &leaf_d->hdr;
> > -	ASSERT((be16_to_cpu(hdr_s->count) > 0) &&
> > -	       (be16_to_cpu(hdr_s->count) < (XFS_LBSIZE(mp)/8)));
> > -	ASSERT(be16_to_cpu(hdr_s->firstused) >=
> > -		((be16_to_cpu(hdr_s->count)
> > -					* sizeof(*entry_s))+sizeof(*hdr_s)));
> > -	ASSERT(be16_to_cpu(hdr_d->count) < (XFS_LBSIZE(mp)/8));
> > -	ASSERT(be16_to_cpu(hdr_d->firstused) >=
> > -		((be16_to_cpu(hdr_d->count)
> > -					* sizeof(*entry_d))+sizeof(*hdr_d)));
> > -
> > -	ASSERT(start_s < be16_to_cpu(hdr_s->count));
> > -	ASSERT(start_d <= be16_to_cpu(hdr_d->count));
> > -	ASSERT(count <= be16_to_cpu(hdr_s->count));
> > +	ASSERT(ichdr_s->magic == XFS_ATTR_LEAF_MAGIC ||
> > +	       ichdr_s->magic == XFS_ATTR3_LEAF_MAGIC);
> 
> This assert might be unnecessary due to the asserts in hdr_from_disk.

might be, but given the number of interesting callers of this
function I decided that specifically ensuring the ichdr magic
numbers were valid was a good idea....

> 
> > @@ -2286,71 +2504,40 @@ xfs_attr_leaf_moveents(xfs_attr_leafblock_t *leaf_s, int start_s,
> >  	/*
> >  	 * Zero out the entries we just copied.
> >  	 */
> > -	if (start_s == be16_to_cpu(hdr_s->count)) {
> > +	if (start_s == ichdr_s->count) {
> >  		tmp = count * sizeof(xfs_attr_leaf_entry_t);
> > -		entry_s = &leaf_s->entries[start_s];
> > +		entry_s = &xfs_attr3_leaf_entryp(leaf_s)[start_s];
> >  		ASSERT(((char *)entry_s + tmp) <=
> >  		       ((char *)leaf_s + XFS_LBSIZE(mp)));
> > -		memset((char *)entry_s, 0, tmp);
> > +		memset(entry_s, 0, tmp);
> >  	} else {
> >  		/*
> >  		 * Move the remaining entries down to fill the hole,
> >  		 * then zero the entries at the top.
> >  		 */
> > -		tmp  = be16_to_cpu(hdr_s->count) - count;
> > -		tmp *= sizeof(xfs_attr_leaf_entry_t);
> > -		entry_s = &leaf_s->entries[start_s + count];
> > -		entry_d = &leaf_s->entries[start_s];
> > -		memmove((char *)entry_d, (char *)entry_s, tmp);
> > +		tmp  = (ichdr_s->count - count) - sizeof(xfs_attr_leaf_entry_t);
> 						*
> Multiply.

Fine catch. Fixed.

> 
> > @@ -2379,20 +2567,21 @@ xfs_attr_leaf_lasthash(
> >  STATIC int
> >  xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
> >  {
> > +	struct xfs_attr_leaf_entry *entries;
> >  	xfs_attr_leaf_name_local_t *name_loc;
> >  	xfs_attr_leaf_name_remote_t *name_rmt;
> >  	int size;
> >  
> > -	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
> 
> I don't see a replacement for this assert.

It's only ever called from places that have already validated the
magic numbers.

> > @@ -2786,38 +3003,44 @@ xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
> >  	 */
> >  	error = xfs_da3_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
> >  	if (error)
> > -		return(error);
> > -	blkno = XFS_BUF_ADDR(bp);
> > +		return error;
> > +	blkno = bp->b_bn;
> 
> I'm a little concerned about the switch from XFS_BUF_ADDR to bp->b_bn here, but
> have not looked into it yet.  If you have a quick explanation, that's great.
> Otherwise I'll come back to it.

XFS_BUF_ADDR should die. bp->b_bn is the block number of the buffer
that is returned, and the attribute code does not deal with
discontiguous buffers so it should always be the correct block
number for further operations...


> > @@ -1479,7 +1480,9 @@ xfs_da3_node_lookup_int(
> >  		curr = blk->bp->b_addr;
> >  		blk->magic = be16_to_cpu(curr->magic);
> >  
> > -		if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
> > +		if (blk->magic == XFS_ATTR_LEAF_MAGIC ||
> > +		    blk->magic == XFS_ATTR3_LEAF_MAGIC) {
> > +			blk->magic = XFS_ATTR_LEAF_MAGIC;
> 			^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> I'm still a little confused by these assignments.  I understand you're
> squashing them down from a comment, and that the correct magic is still in the
> buffer... I need to find who is looking at blk->magic.  Any hints?

It's basically an entry in the cursor passed through all the
xfs_da_btree.c code - node/leaf/attr/dir types matter to the code
that uses it, not the physical encoding of the block on disk....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
