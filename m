Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 633607CF8
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 03:09:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 144AF304032
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 01:09:27 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id o5JdcCD8iBuxnF6p (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Jul 2016 01:09:19 -0700 (PDT)
Date: Wed, 6 Jul 2016 01:09:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 013/119] xfs: support btrees with overlapping intervals
	for keys
Message-ID: <20160706080911.GE18951@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612635526.12839.13865365567940815077.stgit@birch.djwong.org>
	<20160706045941.GC12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160706045941.GC12670@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Wed, Jul 06, 2016 at 02:59:41PM +1000, Dave Chinner wrote:
> On Thu, Jun 16, 2016 at 06:19:15PM -0700, Darrick J. Wong wrote:
> > On a filesystem with both reflink and reverse mapping enabled, it's
> > possible to have multiple rmap records referring to the same blocks on
> > disk.  When overlapping intervals are possible, querying a classic
> > btree to find all records intersecting a given interval is inefficient
> > because we cannot use the left side of the search interval to filter
> > out non-matching records the same way that we can use the existing
> > btree key to filter out records coming after the right side of the
> > search interval.  This will become important once we want to use the
> > rmap btree to rebuild BMBTs, or implement the (future) fsmap ioctl.
> 
> I thought I didn't hav emuch to say about this, but then I started
> writing down all my questions.....

I'd have been surprised if you didn't have much to say--

*I* certainly had plenty to say about this code when I dug back into it
last week to make XFS_BTREE_ROOT_IN_INODE work for level == 0 roots.
Most of it was unprintable. :P

> > @@ -445,6 +474,17 @@ static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
> >  	return XFS_BTREE_SBLOCK_LEN;
> >  }
> >  
> > +/* Return size of btree block keys for this btree instance. */
> > +static inline size_t xfs_btree_key_len(struct xfs_btree_cur *cur)
> > +{
> > +	size_t			len;
> > +
> > +	len = cur->bc_ops->key_len;
> > +	if (cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING)
> > +		len *= 2;
> > +	return len;
> > +}
> 
> So there's magic here. Why can't the cur->bc_ops->key_len be set
> appropriately when it isi initialised?
> 
> >  /*
> >   * Return size of btree block pointers for this btree instance.
> >   */
> > @@ -475,7 +515,19 @@ xfs_btree_key_offset(
> >  	int			n)
> >  {
> >  	return xfs_btree_block_len(cur) +
> > -		(n - 1) * cur->bc_ops->key_len;
> > +		(n - 1) * xfs_btree_key_len(cur);
> > +}
> 
> because this effectively means the key length and offsets for
> a btree with the XFS_BTREE_OPS_OVERLAPPING flag set is *always*
> cur->bc_ops->key_len * 2.

I designed the code around the idea that in going from a regular btree
to an overlapped btree, the key_len stays the same but the number of
keys doubles.  I can change everything such that key_len doubles but
the number of keys stays the same.  For the few places where we
actually update the low and high keys separately (basically updkeys)
we'll have to be a little careful with key_len.

> > +
> > +/*
> > + * Calculate offset of the n-th high key in a btree block.
> > + */
> > +STATIC size_t
> > +xfs_btree_high_key_offset(
> > +	struct xfs_btree_cur	*cur,
> > +	int			n)
> > +{
> > +	return xfs_btree_block_len(cur) +
> > +		(n - 1) * xfs_btree_key_len(cur) + cur->bc_ops->key_len;
> >  }
> 
> And this is the only case where we use a "half key" length to pull
> the offset of the high key. Wouldn't it be better to be explicit
> about the high key offset rather than encode magic numbers to infer
> that the "overlapping key is really two key lengths with the high
> key at plus one key len". IMO, this is better:
> 
> xfs_btree_high_key_offset(
> 	struct xfs_btree_cur	*cur,
> 	int			n)
> {
> 	ASSERT(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING);
> 	return xfs_btree_block_len(cur) +
> 		 (n - 1) * cur->bc_ops->key_len +
> 		 offset_of(struct xfs_btree_double_key, high);
> }
> 
> It means there are much fewer code changes needed for supporting
> the XFS_BTREE_OPS_OVERLAPPING flag, too.

Sure.

> > +STATIC void
> > +xfs_btree_find_leaf_keys(
> > +	struct xfs_btree_cur	*cur,
> > +	struct xfs_btree_block	*block,
> > +	union xfs_btree_key	*low,
> > +	union xfs_btree_key	*high)
> > +{
> > +	int			n;
> > +	union xfs_btree_rec	*rec;
> > +	union xfs_btree_key	max_hkey;
> > +	union xfs_btree_key	hkey;
> > +
> > +	rec = xfs_btree_rec_addr(cur, 1, block);
> > +	cur->bc_ops->init_key_from_rec(low, rec);
> > +
> > +	if (!(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING))
> > +		return;
> 
> When I see conditionals like this, it makes me want to add
> a btree specific method. i.e.
> 
> 	bc_ops->find_leaf_keys()
> 	bc_ops->find_node_keys()
> 
> and we hook them up to generic functions that don't require
> checks against feature flags.
> 
> i.e:
> 
> xfs_btree_find_leaf_low_key()
> {
> 	rec = xfs_btree_rec_addr(cur, 1, block);
> 	cur->bc_ops->init_key_from_rec(low, rec);
> }
> 
> xfs_btree_find_leaf_low_high_keys()
> {
> 	xfs_btree_find_leaf_low_key();
> 
> 	/*
> 	 * high key finding code here, which is the same function
> 	 * for both keys and pointers
> 	 */
> }

The thing is, there's nothing in xfs_btree_find_*_keys that's specifc
to a btree.  I rather like only having to set one thing in the
btree_ops to get the overlapped mode, rather than having to remember
to make sure that such-and-such-functions are paired with
such-and-such flags.

Well, maybe it wouldn't be so bad.  I think there's only three
functions that need this treatment.

> .....
> 
> > +/*
> > + * Update parental low & high keys from some block all the way back to the
> > + * root of the btree.
> > + */
> > +STATIC int
> > +__xfs_btree_updkeys(
> 
> I kept getting confused by xfs_btree_updkey() and
> xfs_btree_updkeys(). Can we chose a better name for this parent key
> update?

I /think/ I want to collapse them into a single ->updkeys() function.

And maybe rename to update_parent_keys() ?

> > +	struct xfs_btree_cur	*cur,
> > +	int			level,
> > +	struct xfs_btree_block	*block,
> > +	struct xfs_buf		*bp0,
> > +	bool			force_all)
> > +{
> > +	union xfs_btree_key	lkey;	/* keys from current level */
> > +	union xfs_btree_key	hkey;
> > +	union xfs_btree_key	*nlkey;	/* keys from the next level up */
> > +	union xfs_btree_key	*nhkey;
> > +	struct xfs_buf		*bp;
> > +	int			ptr = -1;
> > +
> > +	if (!(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING))
> > +		return 0;
> 
> And, again, it's a probably better to use a btree op callout for
> this, especially when you've added this to xfs_btree_updkey():
> 
> > @@ -1893,6 +2132,9 @@ xfs_btree_updkey(
> >  	union xfs_btree_key	*kp;
> >  	int			ptr;
> >  
> > +	if (cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING)
> > +		return 0;
> > +
> >  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> >  	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);
> 
> i.e. one or the other "updkey" does something, but not both.
> Extremely confusing to see both called but then only one do
> anything.
> 
> [back to __xfs_btree_updkeys()]
> 
> > +
> > +	if (level + 1 >= cur->bc_nlevels)
> > +		return 0;
> > +
> > +	trace_xfs_btree_updkeys(cur, level, bp0);
> > +
> > +	if (level == 0)
> > +		xfs_btree_find_leaf_keys(cur, block, &lkey, &hkey);
> > +	else
> > +		xfs_btree_find_node_keys(cur, block, &lkey, &hkey);
> 
> And this code fragment is repeated in many places, so i think a
> helper is warranted for this. That also reminds me - the "find" in
> the name is confusing - it's not "finding" as much as it is
> "getting" the low and high key values from the current block.
> 
> It's especially confusing when you do this:
> 
> > @@ -1970,7 +2212,8 @@ xfs_btree_update(
> >  					    ptr, LASTREC_UPDATE);
> >  	}
> >  
> > -	/* Updating first rec in leaf. Pass new key value up to our parent. */
> > +	/* Pass new key value up to our parent. */
> > +	xfs_btree_updkeys(cur, 0);
> >  	if (ptr == 1) {
> >  		union xfs_btree_key	key;
> 
> You're throwing away the error from xfs_btree_updkeys() at, AFAICT,
> all call sites. This update can fail, so I suspect this needs to
> check and handle the update.

Yes, that's a bug, albeit a theoretical one since updkeys can't fail
at the moment.

(I fixed this one already in my djwong-wtf tree.)

> > @@ -2149,7 +2392,9 @@ xfs_btree_lshift(
> >  		rkp = &key;
> >  	}
> >  
> > -	/* Update the parent key values of right. */
> > +	/* Update the parent key values of left and right. */
> > +	xfs_btree_sibling_updkeys(cur, level, XFS_BB_LEFTSIB, left, lbp);
> > +	xfs_btree_updkeys(cur, level);
> >  	error = xfs_btree_updkey(cur, rkp, level + 1);
> >  	if (error)
> >  		goto error0;
> 
> Remember what I said above about xfs_btree_updkeys/xfs_btree_updkey
> being confusing? Here we have 3 different key update functions, all
> doing different stuff, taking different parameters. None of the code
> is consistent in how these updates are done - they are all different
> combinations of these functions, so I'm not sure how we are supposed
> to verify the correct updates are being done now or in the future.
> 
> How can we hide this complexity from the generic btree code?

I refactored this mess after bfoster complained, but even after that
there's still a conditional.  We need to updkeys the right block
regardless, but we only need to updkeys the left block if it's an
overlapped tree, which leads to this:

/*
 * Using a temporary cursor, update the parent key values of
 * the
 * block on the left.
 */
error = xfs_btree_dup_cursor(cur, &tcur);
if (error)
	goto error0;
i = xfs_btree_firstrec(tcur, level);
XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);

error = xfs_btree_decrement(tcur, level, &i);
if (error)
	goto error1;

/* Update left and right parent pointers */
error = xfs_btree_updkeys(cur, level);
if (error)
	goto error1;
error = xfs_btree_updkeys(tcur, level);
if (error)
	goto error1;
error = xfs_btree_updkey(cur, rkp, level + 1);
if (error)
	goto error0;

xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);

Still yucky, will have to meditate on this further...

> > @@ -2321,6 +2566,9 @@ xfs_btree_rshift(
> >  	if (error)
> >  		goto error1;
> >  
> > +	/* Update left and right parent pointers */
> > +	xfs_btree_updkeys(cur, level);
> > +	xfs_btree_updkeys(tcur, level);
> >  	error = xfs_btree_updkey(tcur, rkp, level + 1);
> >  	if (error)
> >  		goto error1;
> 
> Different.
> 
> > @@ -2499,6 +2746,10 @@ __xfs_btree_split(
> >  		xfs_btree_set_sibling(cur, rrblock, &rptr, XFS_BB_LEFTSIB);
> >  		xfs_btree_log_block(cur, rrbp, XFS_BB_LEFTSIB);
> >  	}
> > +
> > +	/* Update the left block's keys... */
> > +	xfs_btree_updkeys(cur, level);
> 
> different...
> 
> > @@ -2806,27 +3057,27 @@ xfs_btree_new_root(
> >  		bp = lbp;
> >  		nptr = 2;
> >  	}
> > +
> >  	/* Fill in the new block's btree header and log it. */
> >  	xfs_btree_init_block_cur(cur, nbp, cur->bc_nlevels, 2);
> >  	xfs_btree_log_block(cur, nbp, XFS_BB_ALL_BITS);
> >  	ASSERT(!xfs_btree_ptr_is_null(cur, &lptr) &&
> >  			!xfs_btree_ptr_is_null(cur, &rptr));
> > -
> >  	/* Fill in the key data in the new root. */
> >  	if (xfs_btree_get_level(left) > 0) {
> > -		xfs_btree_copy_keys(cur,
> > +		xfs_btree_find_node_keys(cur, left,
> >  				xfs_btree_key_addr(cur, 1, new),
> > -				xfs_btree_key_addr(cur, 1, left), 1);
> > -		xfs_btree_copy_keys(cur,
> > +				xfs_btree_high_key_addr(cur, 1, new));
> > +		xfs_btree_find_node_keys(cur, right,
> >  				xfs_btree_key_addr(cur, 2, new),
> > -				xfs_btree_key_addr(cur, 1, right), 1);
> > +				xfs_btree_high_key_addr(cur, 2, new));
> 
> And this took me ages to work out - you replaced
> xfs_btree_copy_keys() with xfs_btree_find_node_keys() which means
> the fact that we are copying a key from one block to antoher has
> been lost.

That's because we're not strictly copying keys from left and right
into the root anymore.  Yes, the low part of the key is a straight
copy, but we have to iterate left and right, respectively, to
calculate the high keys that go in keys 1 & 2 in the root block.
The high key of a given tree node is the maximum of all the keys or
records in that node, or put another way, it's the highest key
reachable in that subtree...

> It wasn't until I realised that
> xfs_btree_find_node_keys() was writing directly into the new block
> record that it was an equivalent operation to a copy.
> 
> This is why I don't like the name xfs_btree_find_*_keys() - when it
> is used like this it badly obfuscates what operation is being
> performed - it's most definitely not a find operation being
> performed. i.e. xfs_btree_copy_keys() documents the operation in
> an obvious and straight forward manner, the new code takes time and
> thought to decipher.
> 
> Perhaps you could move it all to inside xfs_btree_copy_keys(), so
> the complexity is hidden from the higher level  btree manipulation
> functions...

...so it's not a strict copy.

> > +/* Copy a double key into a btree block. */
> > +static void
> > +xfs_btree_copy_double_keys(
> > +	struct xfs_btree_cur	*cur,
> > +	int			ptr,
> > +	struct xfs_btree_block	*block,
> > +	struct xfs_btree_double_key	*key)
> > +{
> > +	memcpy(xfs_btree_key_addr(cur, ptr, block), &key->low,
> > +			cur->bc_ops->key_len);
> > +
> > +	if (cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING)
> > +		memcpy(xfs_btree_high_key_addr(cur, ptr, block), &key->high,
> > +				cur->bc_ops->key_len);
> > +}
> 
> This should be located next to xfs_btree_copy_keys().
> 
> >  	/* If we inserted at the start of a block, update the parents' keys. */

BTW, I replaced the above comment with:

/*
 * If we just inserted into a new tree block, we have to
 * recalculate nkey here because nkey is out of date.
 *
 * Otherwise we're just updating an existing block (having
 * shoved some records into the new tree block), so use the
 * regular key update mechanism.
 */

> > +	if (ncur && bp->b_bn != old_bn) {
> > +		/*
> > +		 * We just inserted into a new tree block, which means that
> > +		 * the key for the block is in nkey, not the tree.
> > +		 */
> > +		if (level == 0)
> > +			xfs_btree_find_leaf_keys(cur, block, &nkey.low,
> > +					&nkey.high);
> > +		else
> > +			xfs_btree_find_node_keys(cur, block, &nkey.low,
> > +					&nkey.high);
> > +	} else {
> > +		/* Updating the left block, do it the standard way. */
> > +		xfs_btree_updkeys(cur, level);
> > +	}
> > +
> >  	if (optr == 1) {
> > -		error = xfs_btree_updkey(cur, key, level + 1);
> > +		error = xfs_btree_updkey(cur, &key->low, level + 1);
> >  		if (error)
> >  			goto error0;
> >  	}
> 
> This is another of those "huh, what" moments I had with all the
> different _updkey functions....

Ditto.  It took me a long time to figure out what the original code
was doing here, and therefore what was the correct thing to do for the
overlapped btree.

> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index b99c018..a5ec6c7 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -126,6 +126,9 @@ struct xfs_btree_ops {
> >  	size_t	key_len;
> >  	size_t	rec_len;
> >  
> > +	/* flags */
> > +	uint	flags;
> > +
> .....
> > @@ -182,6 +195,9 @@ struct xfs_btree_ops {
> >  #endif
> >  };
> >  
> > +/* btree ops flags */
> > +#define XFS_BTREE_OPS_OVERLAPPING	(1<<0)	/* overlapping intervals */
> > +
> 
> why did you put this in the struct btree_ops  and not in the
> btree cursor ->bc_flags field like all the other btree specific
> customisations like:
> 
> /* cursor flags */
> #define XFS_BTREE_LONG_PTRS             (1<<0)  /* pointers are 64bits long */
> #define XFS_BTREE_ROOT_IN_INODE         (1<<1)  /* root may be variable size */
> #define XFS_BTREE_LASTREC_UPDATE        (1<<2)  /* track last rec externally */
> #define XFS_BTREE_CRC_BLOCKS            (1<<3)  /* uses extended btree blocks */
> 
> i.e. we should have all the structural/behavioural flags in the one
> place, not split across different structures....

At the time I thought that it would be a good idea in the long run to
move the btree flags that can't be changed without changes to the
btree_ops into a btree_ops specific flags field.  At the time I didn't
know that I'd end up adding only one flag or that the only btree ops
change I'd need was init_high_key_from_rec, so when I took a second
look last week I put eliminating the flags field on the todo list.

Ok, enough for one night. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
