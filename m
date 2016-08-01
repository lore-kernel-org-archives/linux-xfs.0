Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C3BBF7D26
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 14:18:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 97B838F8035
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 12:18:34 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id B8TuqWgjalSRK294 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 12:18:30 -0700 (PDT)
Date: Mon, 1 Aug 2016 12:18:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/47] xfs: support btrees with overlapping intervals for
	keys
Message-ID: <20160801191825.GF8590@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<146907701258.25461.18255100969448497359.stgit@birch.djwong.org>
	<20160801174719.GB64218@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801174719.GB64218@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Mon, Aug 01, 2016 at 01:47:19PM -0400, Brian Foster wrote:
> On Wed, Jul 20, 2016 at 09:56:52PM -0700, Darrick J. Wong wrote:
> > On a filesystem with both reflink and reverse mapping enabled, it's
> > possible to have multiple rmap records referring to the same blocks on
> > disk.  When overlapping intervals are possible, querying a classic
> > btree to find all records intersecting a given interval is inefficient
> > because we cannot use the left side of the search interval to filter
> > out non-matching records the same way that we can use the existing
> > btree key to filter out records coming after the right side of the
> > search interval.  This will become important once we want to use the
> > rmap btree to rebuild BMBTs, or implement the (future) fsmap ioctl.
> > 
> > (For the non-overlapping case, we can perform such queries trivially
> > by starting at the left side of the interval and walking the tree
> > until we pass the right side.)
> > 
> > Therefore, extend the btree code to come closer to supporting
> > intervals as a first-class record attribute.  This involves widening
> > the btree node's key space to store both the lowest key reachable via
> > the node pointer (as the btree does now) and the highest key reachable
> > via the same pointer and teaching the btree modifying functions to
> > keep the highest-key records up to date.
> > 
> > This behavior can be turned on via a new btree ops flag so that btrees
> > that cannot store overlapping intervals don't pay the overhead costs
> > in terms of extra code and disk format changes.
> > 
> > v2: When we're deleting a record in a btree that supports overlapped
> > interval records and the deletion results in two btree blocks being
> > joined, we defer updating the high/low keys until after all possible
> > joining (at higher levels in the tree) have finished.  At this point,
> > the btree pointers at all levels have been updated to remove the empty
> > blocks and we can update the low and high keys.
> > 
> > When we're doing this, we must be careful to update the keys of all
> > node pointers up to the root instead of stopping at the first set of
> > keys that don't need updating.  This is because it's possible for a
> > single deletion to cause joining of multiple levels of tree, and so
> > we need to update everything going back to the root.
> > 
> > v3: Make diff_two_keys return < 0, 0, or > 0 if key1 is less than,
> > equal to, or greater than key2, respectively.  This is consistent
> > with the rest of the kernel and the C library.  Clarify some comments
> > and refactor the sibling_update function out of existence.  Check the
> > return value of btree_updkeys().
> > 
> > v4: In btree_updkeys(), evaluate the force_all parameter before
> > running the key diff to avoid reading uninitialized memory when we're
> > forcing a key update.  This happens when we've allocated an empty slot
> > at level N + 1 to point to a new block at level N and we're in the
> > process of filling out the new keys.
> > 
> > v5: Move the overlapping flag to bc_flags, refactor the get/update keys
> > code, and let client btrees set a doublewide key length.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.c |  339 +++++++++++++++++++++++++++++++++++++++++++--
> >  fs/xfs/libxfs/xfs_btree.h |   30 ++++
> >  fs/xfs/xfs_trace.h        |   36 +++++
> >  3 files changed, 392 insertions(+), 13 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 70d1c60..1881536 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> ...
> > @@ -1918,14 +2053,107 @@ xfs_btree_get_keys(
> >  /*
> >   * Decide if we need to update the parent keys of a btree block.  For
> >   * a standard btree this is only necessary if we're updating the first
> > - * record/key.
> > + * record/key.  For an overlapping btree, we must always update the
> > + * keys because the highest key can be in any of the records or keys
> > + * in the block.
> >   */
> >  static inline bool
> >  xfs_btree_needs_key_update(
> >  	struct xfs_btree_cur	*cur,
> >  	int			ptr)
> >  {
> > -	return ptr == 1;
> > +	return (cur->bc_flags & XFS_BTREE_OVERLAPPING) || ptr == 1;
> > +}
> > +
> > +/*
> > + * Update the low and high parent keys of the given level, progressing
> > + * towards the root.  If force_all is false, stop if the keys for a given
> > + * level do not need updating.
> > + */
> > +STATIC int
> > +__xfs_btree_updkeys(
> > +	struct xfs_btree_cur	*cur,
> > +	int			level,
> > +	struct xfs_btree_block	*block,
> > +	struct xfs_buf		*bp0,
> > +	bool			force_all)
> > +{
> > +	union xfs_btree_bigkey	key;	/* keys from current level */
> > +	union xfs_btree_key	*lkey;	/* keys from the next level up */
> > +	union xfs_btree_key	*hkey;
> > +	union xfs_btree_key	*nlkey;	/* keys from the next level up */
> > +	union xfs_btree_key	*nhkey;
> > +	struct xfs_buf		*bp;
> > +	int			ptr;
> > +
> > +	ASSERT(cur->bc_flags & XFS_BTREE_OVERLAPPING);
> > +
> > +	/* Exit if there aren't any parent levels to update. */
> > +	if (level + 1 >= cur->bc_nlevels)
> > +		return 0;
> > +
> > +	trace_xfs_btree_updkeys(cur, level, bp0);
> > +
> > +	lkey = (union xfs_btree_key *)&key;
> > +	hkey = xfs_btree_high_key_from_key(cur, lkey);
> 
> So we create a bigkey object on the stack which presumably will contain
> storage for both keys for overlapping trees, then cast and pass down the
> normal xfs_btree_key structure throughout btree infrastructure.
> 
> This seems slightly hairy/unfortunate in that we treat in-memory objects
> sort of like a buffer pointer. As hch points out, it is also kind of
> confusing (I had to skip forward to where the bigkey union was filled in
> to get an idea of what was going on). I'm not a huge fan, though I
> suppose the alternative might involve changing xfs_btree_key and
> possibly a bunch of other code to accommodate the dual keys model.
> Perhaps this is in fact the better option.. but have you considered any
> options enough to comment on that at all?

I did, and braindumped my notes in a reply to hch's email.  Please see that.

> > +	xfs_btree_get_keys(cur, block, lkey);
> > +	for (level++; level < cur->bc_nlevels; level++) {
> > +#ifdef DEBUG
> > +		int		error;
> > +#endif
> > +		block = xfs_btree_get_block(cur, level, &bp);
> > +		trace_xfs_btree_updkeys(cur, level, bp);
> > +#ifdef DEBUG
> > +		error = xfs_btree_check_block(cur, block, level, bp);
> > +		if (error) {
> > +			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > +			return error;
> > +		}
> > +#endif
> > +		ptr = cur->bc_ptrs[level];
> > +		nlkey = xfs_btree_key_addr(cur, ptr, block);
> > +		nhkey = xfs_btree_high_key_addr(cur, ptr, block);
> > +		if (!force_all &&
> > +		    !(cur->bc_ops->diff_two_keys(cur, nlkey, lkey) != 0 ||
> > +		      cur->bc_ops->diff_two_keys(cur, nhkey, hkey) != 0))
> > +			break;
> > +		xfs_btree_copy_keys(cur, nlkey, lkey, 1);
> > +		xfs_btree_log_keys(cur, bp, ptr, ptr);
> > +		if (level + 1 >= cur->bc_nlevels)
> > +			break;
> > +		cur->bc_ops->get_node_keys(cur, block, lkey);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> ...
> >  }
> >  
> >  /*
> ...
> > @@ -2197,10 +2429,33 @@ xfs_btree_lshift(
> >  		rkp = &key;
> >  	}
> >  
> > +	/*
> > +	 * Using a temporary cursor, update the parent key values of the
> > +	 * block on the left.
> > +	 */
> > +	error = xfs_btree_dup_cursor(cur, &tcur);
> > +	if (error)
> > +		goto error0;
> > +	i = xfs_btree_firstrec(tcur, level);
> > +	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
> 
> Nit:				tcur

Will fix this and the same problem in rshift.

> > +
> > +	error = xfs_btree_decrement(tcur, level, &i);
> > +	if (error)
> > +		goto error1;
> > +
> 
> Can we conditionalize tcur creation/processing against the overlapping
> flag as well and combine the two associated hunks?

Yes, I think so.

--D

> Brian
> 
> >  	/* Update the parent keys of the right block. */
> >  	error = cur->bc_ops->update_keys(cur, level);
> >  	if (error)
> > -		goto error0;
> > +		goto error1;
> > +
> > +	/* Update the parent high keys of the left block, if needed. */
> > +	if (tcur->bc_flags & XFS_BTREE_OVERLAPPING) {
> > +		error = tcur->bc_ops->update_keys(tcur, level);
> > +		if (error)
> > +			goto error1;
> > +	}
> > +
> > +	xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
> >  
> >  	/* Slide the cursor value left one. */
> >  	cur->bc_ptrs[level]--;
> > @@ -2217,6 +2472,11 @@ out0:
> >  error0:
> >  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> >  	return error;
> > +
> > +error1:
> > +	XFS_BTREE_TRACE_CURSOR(tcur, XBT_ERROR);
> > +	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
> > +	return error;
> >  }
> >  
> >  /*
> > @@ -2369,6 +2629,13 @@ xfs_btree_rshift(
> >  	if (error)
> >  		goto error1;
> >  
> > +	/* Update the parent high keys of the left block, if needed. */
> > +	if (cur->bc_flags & XFS_BTREE_OVERLAPPING) {
> > +		error = cur->bc_ops->update_keys(cur, level);
> > +		if (error)
> > +			goto error1;
> > +	}
> > +
> >  	/* Update the parent keys of the right block. */
> >  	error = cur->bc_ops->update_keys(tcur, level);
> >  	if (error)
> > @@ -2549,6 +2816,14 @@ __xfs_btree_split(
> >  		xfs_btree_set_sibling(cur, rrblock, &rptr, XFS_BB_LEFTSIB);
> >  		xfs_btree_log_block(cur, rrbp, XFS_BB_LEFTSIB);
> >  	}
> > +
> > +	/* Update the parent high keys of the left block, if needed. */
> > +	if (cur->bc_flags & XFS_BTREE_OVERLAPPING) {
> > +		error = cur->bc_ops->update_keys(cur, level);
> > +		if (error)
> > +			goto error0;
> > +	}
> > +
> >  	/*
> >  	 * If the cursor is really in the right block, move it there.
> >  	 * If it's just pointing past the last entry in left, then we'll
> > @@ -2989,7 +3264,8 @@ xfs_btree_insrec(
> >  	struct xfs_buf		*bp;	/* buffer for block */
> >  	union xfs_btree_ptr	nptr;	/* new block ptr */
> >  	struct xfs_btree_cur	*ncur;	/* new btree cursor */
> > -	union xfs_btree_key	nkey;	/* new block key */
> > +	union xfs_btree_bigkey	nkey;	/* new block key */
> > +	union xfs_btree_key	*lkey;
> >  	int			optr;	/* old key/record index */
> >  	int			ptr;	/* key/record index */
> >  	int			numrecs;/* number of records */
> > @@ -2997,11 +3273,13 @@ xfs_btree_insrec(
> >  #ifdef DEBUG
> >  	int			i;
> >  #endif
> > +	xfs_daddr_t		old_bn;
> >  
> >  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> >  	XFS_BTREE_TRACE_ARGIPR(cur, level, *ptrp, &rec);
> >  
> >  	ncur = NULL;
> > +	lkey = (union xfs_btree_key *)&nkey;
> >  
> >  	/*
> >  	 * If we have an external root pointer, and we've made it to the
> > @@ -3030,6 +3308,7 @@ xfs_btree_insrec(
> >  
> >  	/* Get pointers to the btree buffer and block. */
> >  	block = xfs_btree_get_block(cur, level, &bp);
> > +	old_bn = bp ? bp->b_bn : XFS_BUF_DADDR_NULL;
> >  	numrecs = xfs_btree_get_numrecs(block);
> >  
> >  #ifdef DEBUG
> > @@ -3056,7 +3335,7 @@ xfs_btree_insrec(
> >  	xfs_btree_set_ptr_null(cur, &nptr);
> >  	if (numrecs == cur->bc_ops->get_maxrecs(cur, level)) {
> >  		error = xfs_btree_make_block_unfull(cur, level, numrecs,
> > -					&optr, &ptr, &nptr, &ncur, &nkey, stat);
> > +					&optr, &ptr, &nptr, &ncur, lkey, stat);
> >  		if (error || *stat == 0)
> >  			goto error0;
> >  	}
> > @@ -3141,8 +3420,17 @@ xfs_btree_insrec(
> >  	/* Log the new number of records in the btree header. */
> >  	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
> >  
> > -	/* If we inserted at the start of a block, update the parents' keys. */
> > -	if (xfs_btree_needs_key_update(cur, optr)) {
> > +	/*
> > +	 * If we just inserted into a new tree block, we have to
> > +	 * recalculate nkey here because nkey is out of date.
> > +	 *
> > +	 * Otherwise we're just updating an existing block (having shoved
> > +	 * some records into the new tree block), so use the regular key
> > +	 * update mechanism.
> > +	 */
> > +	if (bp && bp->b_bn != old_bn) {
> > +		xfs_btree_get_keys(cur, block, lkey);
> > +	} else if (xfs_btree_needs_key_update(cur, optr)) {
> >  		error = cur->bc_ops->update_keys(cur, level);
> >  		if (error)
> >  			goto error0;
> > @@ -3163,7 +3451,7 @@ xfs_btree_insrec(
> >  	 */
> >  	*ptrp = nptr;
> >  	if (!xfs_btree_ptr_is_null(cur, &nptr)) {
> > -		xfs_btree_copy_keys(cur, key, &nkey, 1);
> > +		xfs_btree_copy_keys(cur, key, lkey, 1);
> >  		*curp = ncur;
> >  	}
> >  
> > @@ -3194,18 +3482,20 @@ xfs_btree_insert(
> >  	union xfs_btree_ptr	nptr;	/* new block number (split result) */
> >  	struct xfs_btree_cur	*ncur;	/* new cursor (split result) */
> >  	struct xfs_btree_cur	*pcur;	/* previous level's cursor */
> > -	union xfs_btree_key	key;	/* key of block to insert */
> > +	union xfs_btree_bigkey	bkey;	/* key of block to insert */
> > +	union xfs_btree_key	*key;
> >  	union xfs_btree_rec	rec;	/* record to insert */
> >  
> >  	level = 0;
> >  	ncur = NULL;
> >  	pcur = cur;
> > +	key = (union xfs_btree_key *)&bkey;
> >  
> >  	xfs_btree_set_ptr_null(cur, &nptr);
> >  
> >  	/* Make a key out of the record data to be inserted, and save it. */
> >  	cur->bc_ops->init_rec_from_cur(cur, &rec);
> > -	cur->bc_ops->init_key_from_rec(&key, &rec);
> > +	cur->bc_ops->init_key_from_rec(key, &rec);
> >  
> >  	/*
> >  	 * Loop going up the tree, starting at the leaf level.
> > @@ -3217,7 +3507,7 @@ xfs_btree_insert(
> >  		 * Insert nrec/nptr into this level of the tree.
> >  		 * Note if we fail, nptr will be null.
> >  		 */
> > -		error = xfs_btree_insrec(pcur, level, &nptr, &rec, &key,
> > +		error = xfs_btree_insrec(pcur, level, &nptr, &rec, key,
> >  				&ncur, &i);
> >  		if (error) {
> >  			if (pcur != cur)
> > @@ -3916,6 +4206,16 @@ xfs_btree_delrec(
> >  	if (level > 0)
> >  		cur->bc_ptrs[level]--;
> >  
> > +	/*
> > +	 * We combined blocks, so we have to update the parent keys if the
> > +	 * btree supports overlapped intervals.  However, bc_ptrs[level + 1]
> > +	 * points to the old block so that the caller knows which record to
> > +	 * delete.  Therefore, the caller must be savvy enough to call updkeys
> > +	 * for us if we return stat == 2.  The other exit points from this
> > +	 * function don't require deletions further up the tree, so they can
> > +	 * call updkeys directly.
> > +	 */
> > +
> >  	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> >  	/* Return value means the next level up has something to do. */
> >  	*stat = 2;
> > @@ -3941,6 +4241,7 @@ xfs_btree_delete(
> >  	int			error;	/* error return value */
> >  	int			level;
> >  	int			i;
> > +	bool			joined = false;
> >  
> >  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> >  
> > @@ -3954,6 +4255,18 @@ xfs_btree_delete(
> >  		error = xfs_btree_delrec(cur, level, &i);
> >  		if (error)
> >  			goto error0;
> > +		if (i == 2)
> > +			joined = true;
> > +	}
> > +
> > +	/*
> > +	 * If we combined blocks as part of deleting the record, delrec won't
> > +	 * have updated the parent high keys so we have to do that here.
> > +	 */
> > +	if (joined && (cur->bc_flags & XFS_BTREE_OVERLAPPING)) {
> > +		error = xfs_btree_updkeys_force(cur, 0);
> > +		if (error)
> > +			goto error0;
> >  	}
> >  
> >  	if (i == 0) {
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index bb40457..3645d91 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -44,6 +44,20 @@ union xfs_btree_key {
> >  	xfs_inobt_key_t		inobt;
> >  };
> >  
> > +/*
> > + * In-core key that holds both low and high keys for overlapped btrees.
> > + * The two keys are packed next to each other on disk, so do the same
> > + * in memory.  Preserve the existing xfs_btree_key as a single key to
> > + * avoid the mental model breakage that would happen if we passed a
> > + * bigkey into a function that operates on a single key.
> > + */
> > +union xfs_btree_bigkey {
> > +	struct xfs_bmbt_key		bmbt;
> > +	xfs_bmdr_key_t			bmbr;	/* bmbt root block */
> > +	xfs_alloc_key_t			alloc;
> > +	struct xfs_inobt_key		inobt;
> > +};
> > +
> >  union xfs_btree_rec {
> >  	xfs_bmbt_rec_t		bmbt;
> >  	xfs_bmdr_rec_t		bmbr;	/* bmbt root block */
> > @@ -162,11 +176,21 @@ struct xfs_btree_ops {
> >  				     union xfs_btree_rec *rec);
> >  	void	(*init_ptr_from_cur)(struct xfs_btree_cur *cur,
> >  				     union xfs_btree_ptr *ptr);
> > +	void	(*init_high_key_from_rec)(union xfs_btree_key *key,
> > +					  union xfs_btree_rec *rec);
> >  
> >  	/* difference between key value and cursor value */
> >  	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
> >  			      union xfs_btree_key *key);
> >  
> > +	/*
> > +	 * Difference between key2 and key1 -- positive if key1 > key2,
> > +	 * negative if key1 < key2, and zero if equal.
> > +	 */
> > +	__int64_t (*diff_two_keys)(struct xfs_btree_cur *cur,
> > +				   union xfs_btree_key *key1,
> > +				   union xfs_btree_key *key2);
> > +
> >  	const struct xfs_buf_ops	*buf_ops;
> >  
> >  #if defined(DEBUG) || defined(XFS_WARN)
> > @@ -249,6 +273,7 @@ typedef struct xfs_btree_cur
> >  #define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
> >  #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
> >  #define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
> > +#define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
> >  
> >  
> >  #define	XFS_BTREE_NOERROR	0
> > @@ -493,5 +518,10 @@ void xfs_btree_get_leaf_keys(struct xfs_btree_cur *cur,
> >  void xfs_btree_get_node_keys(struct xfs_btree_cur *cur,
> >  		struct xfs_btree_block *block, union xfs_btree_key *key);
> >  int xfs_btree_update_keys(struct xfs_btree_cur *cur, int level);
> > +void xfs_btree_get_leaf_keys_overlapped(struct xfs_btree_cur *cur,
> > +		struct xfs_btree_block *block, union xfs_btree_key *key);
> > +void xfs_btree_get_node_keys_overlapped(struct xfs_btree_cur *cur,
> > +		struct xfs_btree_block *block, union xfs_btree_key *key);
> > +int xfs_btree_update_keys_overlapped(struct xfs_btree_cur *cur, int level);
> >  
> >  #endif	/* __XFS_BTREE_H__ */
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 1451690..8fb59e6 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -38,6 +38,7 @@ struct xlog_recover_item;
> >  struct xfs_buf_log_format;
> >  struct xfs_inode_log_format;
> >  struct xfs_bmbt_irec;
> > +struct xfs_btree_cur;
> >  
> >  DECLARE_EVENT_CLASS(xfs_attr_list_class,
> >  	TP_PROTO(struct xfs_attr_list_context *ctx),
> > @@ -2185,6 +2186,41 @@ DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
> >  DEFINE_DISCARD_EVENT(xfs_discard_exclude);
> >  DEFINE_DISCARD_EVENT(xfs_discard_busy);
> >  
> > +/* btree cursor events */
> > +DECLARE_EVENT_CLASS(xfs_btree_cur_class,
> > +	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp),
> > +	TP_ARGS(cur, level, bp),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_btnum_t, btnum)
> > +		__field(int, level)
> > +		__field(int, nlevels)
> > +		__field(int, ptr)
> > +		__field(xfs_daddr_t, daddr)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = cur->bc_mp->m_super->s_dev;
> > +		__entry->btnum = cur->bc_btnum;
> > +		__entry->level = level;
> > +		__entry->nlevels = cur->bc_nlevels;
> > +		__entry->ptr = cur->bc_ptrs[level];
> > +		__entry->daddr = bp ? bp->b_bn : -1;
> > +	),
> > +	TP_printk("dev %d:%d btnum %d level %d/%d ptr %d daddr 0x%llx",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->btnum,
> > +		  __entry->level,
> > +		  __entry->nlevels,
> > +		  __entry->ptr,
> > +		  (unsigned long long)__entry->daddr)
> > +)
> > +
> > +#define DEFINE_BTREE_CUR_EVENT(name) \
> > +DEFINE_EVENT(xfs_btree_cur_class, name, \
> > +	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp), \
> > +	TP_ARGS(cur, level, bp))
> > +DEFINE_BTREE_CUR_EVENT(xfs_btree_updkeys);
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
