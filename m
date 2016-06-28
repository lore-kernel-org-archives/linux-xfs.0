Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA5497CA1
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 07:32:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC08B304032
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 05:32:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MnuLw020ICNQB2hq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 05:32:05 -0700 (PDT)
Date: Tue, 28 Jun 2016 08:32:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 013/119] xfs: support btrees with overlapping intervals
	for keys
Message-ID: <20160628123203.GB4212@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612635526.12839.13865365567940815077.stgit@birch.djwong.org>
	<20160622151706.GB5423@bfoster.bfoster>
	<20160628032621.GB4917@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160628032621.GB4917@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Mon, Jun 27, 2016 at 08:26:21PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 22, 2016 at 11:17:06AM -0400, Brian Foster wrote:
> > On Thu, Jun 16, 2016 at 06:19:15PM -0700, Darrick J. Wong wrote:
> > > On a filesystem with both reflink and reverse mapping enabled, it's
> > > possible to have multiple rmap records referring to the same blocks on
> > > disk.  When overlapping intervals are possible, querying a classic
> > > btree to find all records intersecting a given interval is inefficient
> > > because we cannot use the left side of the search interval to filter
> > > out non-matching records the same way that we can use the existing
> > > btree key to filter out records coming after the right side of the
> > > search interval.  This will become important once we want to use the
> > > rmap btree to rebuild BMBTs, or implement the (future) fsmap ioctl.
> > > 
> > > (For the non-overlapping case, we can perform such queries trivially
> > > by starting at the left side of the interval and walking the tree
> > > until we pass the right side.)
> > > 
> > > Therefore, extend the btree code to come closer to supporting
> > > intervals as a first-class record attribute.  This involves widening
> > > the btree node's key space to store both the lowest key reachable via
> > > the node pointer (as the btree does now) and the highest key reachable
> > > via the same pointer and teaching the btree modifying functions to
> > > keep the highest-key records up to date.
> > > 
> > > This behavior can be turned on via a new btree ops flag so that btrees
> > > that cannot store overlapping intervals don't pay the overhead costs
> > > in terms of extra code and disk format changes.
> > > 
> > > v2: When we're deleting a record in a btree that supports overlapped
> > > interval records and the deletion results in two btree blocks being
> > > joined, we defer updating the high/low keys until after all possible
> > > joining (at higher levels in the tree) have finished.  At this point,
> > > the btree pointers at all levels have been updated to remove the empty
> > > blocks and we can update the low and high keys.
> > > 
> > > When we're doing this, we must be careful to update the keys of all
> > > node pointers up to the root instead of stopping at the first set of
> > > keys that don't need updating.  This is because it's possible for a
> > > single deletion to cause joining of multiple levels of tree, and so
> > > we need to update everything going back to the root.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > I think I get the gist of this and it mostly looks Ok to me. A few
> > questions and minor comments...
> 
> Ok.
> 
> > >  fs/xfs/libxfs/xfs_btree.c |  379 +++++++++++++++++++++++++++++++++++++++++----
> > >  fs/xfs/libxfs/xfs_btree.h |   16 ++
> > >  fs/xfs/xfs_trace.h        |   36 ++++
> > >  3 files changed, 395 insertions(+), 36 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > index a096539..afcafd6 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_btree.c
...
> > > @@ -2149,7 +2392,9 @@ xfs_btree_lshift(
> > >  		rkp = &key;
> > >  	}
> > >  
> > > -	/* Update the parent key values of right. */
> > > +	/* Update the parent key values of left and right. */
> > > +	xfs_btree_sibling_updkeys(cur, level, XFS_BB_LEFTSIB, left, lbp);
> > > +	xfs_btree_updkeys(cur, level);
> > >  	error = xfs_btree_updkey(cur, rkp, level + 1);
> > >  	if (error)
> > >  		goto error0;
> > > @@ -2321,6 +2566,9 @@ xfs_btree_rshift(
> > >  	if (error)
> > >  		goto error1;
> > >  
> > > +	/* Update left and right parent pointers */
> > > +	xfs_btree_updkeys(cur, level);
> > > +	xfs_btree_updkeys(tcur, level);
> > 
> > In this case, we grab the last record of the block, increment from there
> > and update using the cursor. This is much more straightforward, imo.
> > Could we use this approach in the left shift case as well?
> 
> Yes, I think so.  I might have started refactoring btree_sibling_updkeys
> out of existence and got distracted, since there isn't anything that uses
> the RIGHTSIB ptr value.
> 

Ok, I think that would be much cleaner.

> > >  	error = xfs_btree_updkey(tcur, rkp, level + 1);
> > >  	if (error)
> > >  		goto error1;
> > > @@ -2356,7 +2604,7 @@ __xfs_btree_split(
> > >  	struct xfs_btree_cur	*cur,
> > >  	int			level,
> > >  	union xfs_btree_ptr	*ptrp,
> > > -	union xfs_btree_key	*key,
> > > +	struct xfs_btree_double_key	*key,
> > >  	struct xfs_btree_cur	**curp,
> > >  	int			*stat)		/* success/failure */
> > >  {
> > > @@ -2452,9 +2700,6 @@ __xfs_btree_split(
> > >  
> > >  		xfs_btree_log_keys(cur, rbp, 1, rrecs);
> > >  		xfs_btree_log_ptrs(cur, rbp, 1, rrecs);
> > > -
> > > -		/* Grab the keys to the entries moved to the right block */
> > > -		xfs_btree_copy_keys(cur, key, rkp, 1);
> > >  	} else {
> > >  		/* It's a leaf.  Move records.  */
> > >  		union xfs_btree_rec	*lrp;	/* left record pointer */
> > > @@ -2465,12 +2710,8 @@ __xfs_btree_split(
> > >  
> > >  		xfs_btree_copy_recs(cur, rrp, lrp, rrecs);
> > >  		xfs_btree_log_recs(cur, rbp, 1, rrecs);
> > > -
> > > -		cur->bc_ops->init_key_from_rec(key,
> > > -			xfs_btree_rec_addr(cur, 1, right));
> > >  	}
> > >  
> > > -
> > >  	/*
> > >  	 * Find the left block number by looking in the buffer.
> > >  	 * Adjust numrecs, sibling pointers.
> > > @@ -2484,6 +2725,12 @@ __xfs_btree_split(
> > >  	xfs_btree_set_numrecs(left, lrecs);
> > >  	xfs_btree_set_numrecs(right, xfs_btree_get_numrecs(right) + rrecs);
> > >  
> > > +	/* Find the low & high keys for the new block. */
> > > +	if (level > 0)
> > > +		xfs_btree_find_node_keys(cur, right, &key->low, &key->high);
> > > +	else
> > > +		xfs_btree_find_leaf_keys(cur, right, &key->low, &key->high);
> > > +
> > 
> > Why not push these into the above if/else where the previous key
> > copy/init calls were removed from?
> 
> We don't set bb_numrecs on the right block until the line above the new
> hunk, and the btree_find_*_keys functions require numrecs to be set.
> 
> The removed key copy/init calls only looked at keys[1].
> 
> That said, it's trivial to move the set_numrecs calls above the if statement.
> 

Ok, thanks. No need to shuffle it around. I'd suggest a one-liner
comment though so somebody doesn't blindly refactor this down the road.
It also sounds like the find keys functions could use ASSERT() checks
for a sane bb_numrecs.

> > >  	xfs_btree_log_block(cur, rbp, XFS_BB_ALL_BITS);
> > >  	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
> > >  
...
> > > @@ -3095,8 +3365,24 @@ xfs_btree_insrec(
> > >  	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
> > >  
> > >  	/* If we inserted at the start of a block, update the parents' keys. */
> > 
> > This comment is associated with the codeblock that has been pushed
> > further down, no?
> 
> Correct.  I think that got mismerged somewhere along the way.
> 
> > > +	if (ncur && bp->b_bn != old_bn) {
> > > +		/*
> > > +		 * We just inserted into a new tree block, which means that
> > > +		 * the key for the block is in nkey, not the tree.
> > > +		 */
> > > +		if (level == 0)
> > > +			xfs_btree_find_leaf_keys(cur, block, &nkey.low,
> > > +					&nkey.high);
> > > +		else
> > > +			xfs_btree_find_node_keys(cur, block, &nkey.low,
> > > +					&nkey.high);
> > > +	} else {
> > > +		/* Updating the left block, do it the standard way. */
> > > +		xfs_btree_updkeys(cur, level);
> > > +	}
> > > +
> > 
> > Not quite sure I follow the purpose of this hunk. Is this for the case
> > where a btree split occurs, nkey is filled in for the new/right block
> > and then (after nkey is filled in) the new record ends up being added to
> > the new block? If so, what about the case where ncur is not created?
> > (It looks like that's possible from the code, but I could easily be
> > missing some context as to why that's not the case.)
> 
> Yes, the first part of the if-else hunk is to fill out nkey when we've
> split a btree block.  Now that I look at it again, I think that whole
> weird conditional could be replaced with the same xfs_btree_ptr_is_null()
> check later on.  I think it can also be combined with it.
> 

Ok.

> Commentage for now:
> 
> /*
>  * If we just inserted a new tree block, we have to find the low
>  * and high keys for the new block and arrange to pass them back
>  * separately.  If we're just updating a block we can use the
>  * regular tree update mechanism.
>  */
> 

Couldn't you just point out that nkey may not be coherent with the new
block if the new record was inserted therein..?

> > In any event, I think we could elaborate a bit in the comment on why
> > this is necessary. I'd also move it above the top-level if/else.
> > 
> > >  	if (optr == 1) {
> > > -		error = xfs_btree_updkey(cur, key, level + 1);
> > > +		error = xfs_btree_updkey(cur, &key->low, level + 1);
> > >  		if (error)
> > >  			goto error0;
> > >  	}
> > > @@ -3147,7 +3433,7 @@ xfs_btree_insert(
> > >  	union xfs_btree_ptr	nptr;	/* new block number (split result) */
> > >  	struct xfs_btree_cur	*ncur;	/* new cursor (split result) */
> > >  	struct xfs_btree_cur	*pcur;	/* previous level's cursor */
> > > -	union xfs_btree_key	key;	/* key of block to insert */
> > > +	struct xfs_btree_double_key	key;	/* key of block to insert */
> > 
> > Probably should fix up the function param alignment here and the couple
> > other or so places we make this change.
> 
> I changed the name to xfs_btree_bigkey, which avoids the alignment problems.
> 

Sounds good.

Brian

> --D
> 
> > 
> > Brian
> > 
> > >  
> > >  	level = 0;
> > >  	ncur = NULL;
> > > @@ -3552,6 +3838,7 @@ xfs_btree_delrec(
> > >  	 * If we deleted the leftmost entry in the block, update the
> > >  	 * key values above us in the tree.
> > >  	 */
> > > +	xfs_btree_updkeys(cur, level);
> > >  	if (ptr == 1) {
> > >  		error = xfs_btree_updkey(cur, keyp, level + 1);
> > >  		if (error)
> > > @@ -3882,6 +4169,16 @@ xfs_btree_delrec(
> > >  	if (level > 0)
> > >  		cur->bc_ptrs[level]--;
> > >  
> > > +	/*
> > > +	 * We combined blocks, so we have to update the parent keys if the
> > > +	 * btree supports overlapped intervals.  However, bc_ptrs[level + 1]
> > > +	 * points to the old block so that the caller knows which record to
> > > +	 * delete.  Therefore, the caller must be savvy enough to call updkeys
> > > +	 * for us if we return stat == 2.  The other exit points from this
> > > +	 * function don't require deletions further up the tree, so they can
> > > +	 * call updkeys directly.
> > > +	 */
> > > +
> > >  	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
> > >  	/* Return value means the next level up has something to do. */
> > >  	*stat = 2;
> > > @@ -3907,6 +4204,7 @@ xfs_btree_delete(
> > >  	int			error;	/* error return value */
> > >  	int			level;
> > >  	int			i;
> > > +	bool			joined = false;
> > >  
> > >  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > >  
> > > @@ -3920,8 +4218,17 @@ xfs_btree_delete(
> > >  		error = xfs_btree_delrec(cur, level, &i);
> > >  		if (error)
> > >  			goto error0;
> > > +		if (i == 2)
> > > +			joined = true;
> > >  	}
> > >  
> > > +	/*
> > > +	 * If we combined blocks as part of deleting the record, delrec won't
> > > +	 * have updated the parent keys so we have to do that here.
> > > +	 */
> > > +	if (joined)
> > > +		xfs_btree_updkeys_force(cur, 0);
> > > +
> > >  	if (i == 0) {
> > >  		for (level = 1; level < cur->bc_nlevels; level++) {
> > >  			if (cur->bc_ptrs[level] == 0) {
> > > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > > index b99c018..a5ec6c7 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.h
> > > +++ b/fs/xfs/libxfs/xfs_btree.h
> > > @@ -126,6 +126,9 @@ struct xfs_btree_ops {
> > >  	size_t	key_len;
> > >  	size_t	rec_len;
> > >  
> > > +	/* flags */
> > > +	uint	flags;
> > > +
> > >  	/* cursor operations */
> > >  	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
> > >  	void	(*update_cursor)(struct xfs_btree_cur *src,
> > > @@ -162,11 +165,21 @@ struct xfs_btree_ops {
> > >  				     union xfs_btree_rec *rec);
> > >  	void	(*init_ptr_from_cur)(struct xfs_btree_cur *cur,
> > >  				     union xfs_btree_ptr *ptr);
> > > +	void	(*init_high_key_from_rec)(union xfs_btree_key *key,
> > > +					  union xfs_btree_rec *rec);
> > >  
> > >  	/* difference between key value and cursor value */
> > >  	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
> > >  			      union xfs_btree_key *key);
> > >  
> > > +	/*
> > > +	 * Difference between key2 and key1 -- positive if key2 > key1,
> > > +	 * negative if key2 < key1, and zero if equal.
> > > +	 */
> > > +	__int64_t (*diff_two_keys)(struct xfs_btree_cur *cur,
> > > +				   union xfs_btree_key *key1,
> > > +				   union xfs_btree_key *key2);
> > > +
> > >  	const struct xfs_buf_ops	*buf_ops;
> > >  
> > >  #if defined(DEBUG) || defined(XFS_WARN)
> > > @@ -182,6 +195,9 @@ struct xfs_btree_ops {
> > >  #endif
> > >  };
> > >  
> > > +/* btree ops flags */
> > > +#define XFS_BTREE_OPS_OVERLAPPING	(1<<0)	/* overlapping intervals */
> > > +
> > >  /*
> > >   * Reasons for the update_lastrec method to be called.
> > >   */
> > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > index 68f27f7..ffea28c 100644
> > > --- a/fs/xfs/xfs_trace.h
> > > +++ b/fs/xfs/xfs_trace.h
> > > @@ -38,6 +38,7 @@ struct xlog_recover_item;
> > >  struct xfs_buf_log_format;
> > >  struct xfs_inode_log_format;
> > >  struct xfs_bmbt_irec;
> > > +struct xfs_btree_cur;
> > >  
> > >  DECLARE_EVENT_CLASS(xfs_attr_list_class,
> > >  	TP_PROTO(struct xfs_attr_list_context *ctx),
> > > @@ -2183,6 +2184,41 @@ DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
> > >  DEFINE_DISCARD_EVENT(xfs_discard_exclude);
> > >  DEFINE_DISCARD_EVENT(xfs_discard_busy);
> > >  
> > > +/* btree cursor events */
> > > +DECLARE_EVENT_CLASS(xfs_btree_cur_class,
> > > +	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp),
> > > +	TP_ARGS(cur, level, bp),
> > > +	TP_STRUCT__entry(
> > > +		__field(dev_t, dev)
> > > +		__field(xfs_btnum_t, btnum)
> > > +		__field(int, level)
> > > +		__field(int, nlevels)
> > > +		__field(int, ptr)
> > > +		__field(xfs_daddr_t, daddr)
> > > +	),
> > > +	TP_fast_assign(
> > > +		__entry->dev = cur->bc_mp->m_super->s_dev;
> > > +		__entry->btnum = cur->bc_btnum;
> > > +		__entry->level = level;
> > > +		__entry->nlevels = cur->bc_nlevels;
> > > +		__entry->ptr = cur->bc_ptrs[level];
> > > +		__entry->daddr = bp->b_bn;
> > > +	),
> > > +	TP_printk("dev %d:%d btnum %d level %d/%d ptr %d daddr 0x%llx",
> > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > +		  __entry->btnum,
> > > +		  __entry->level,
> > > +		  __entry->nlevels,
> > > +		  __entry->ptr,
> > > +		  (unsigned long long)__entry->daddr)
> > > +)
> > > +
> > > +#define DEFINE_BTREE_CUR_EVENT(name) \
> > > +DEFINE_EVENT(xfs_btree_cur_class, name, \
> > > +	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp), \
> > > +	TP_ARGS(cur, level, bp))
> > > +DEFINE_BTREE_CUR_EVENT(xfs_btree_updkeys);
> > > +
> > >  #endif /* _TRACE_XFS_H */
> > >  
> > >  #undef TRACE_INCLUDE_PATH
> > > 
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
