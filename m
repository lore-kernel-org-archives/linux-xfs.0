Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0070D7CAF
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 00:00:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C221030404E
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 22:00:19 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	nu0GywUOBVfGVzpU for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2016 22:00:15 -0700 (PDT)
Date: Wed, 6 Jul 2016 14:59:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 013/119] xfs: support btrees with overlapping intervals
	for keys
Message-ID: <20160706045941.GC12670@dastard>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612635526.12839.13865365567940815077.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612635526.12839.13865365567940815077.stgit@birch.djwong.org>
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

On Thu, Jun 16, 2016 at 06:19:15PM -0700, Darrick J. Wong wrote:
> On a filesystem with both reflink and reverse mapping enabled, it's
> possible to have multiple rmap records referring to the same blocks on
> disk.  When overlapping intervals are possible, querying a classic
> btree to find all records intersecting a given interval is inefficient
> because we cannot use the left side of the search interval to filter
> out non-matching records the same way that we can use the existing
> btree key to filter out records coming after the right side of the
> search interval.  This will become important once we want to use the
> rmap btree to rebuild BMBTs, or implement the (future) fsmap ioctl.

I thought I didn't hav emuch to say about this, but then I started
writing down all my questions.....

> @@ -445,6 +474,17 @@ static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
>  	return XFS_BTREE_SBLOCK_LEN;
>  }
>  
> +/* Return size of btree block keys for this btree instance. */
> +static inline size_t xfs_btree_key_len(struct xfs_btree_cur *cur)
> +{
> +	size_t			len;
> +
> +	len = cur->bc_ops->key_len;
> +	if (cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING)
> +		len *= 2;
> +	return len;
> +}

So there's magic here. Why can't the cur->bc_ops->key_len be set
appropriately when it isi initialised?

>  /*
>   * Return size of btree block pointers for this btree instance.
>   */
> @@ -475,7 +515,19 @@ xfs_btree_key_offset(
>  	int			n)
>  {
>  	return xfs_btree_block_len(cur) +
> -		(n - 1) * cur->bc_ops->key_len;
> +		(n - 1) * xfs_btree_key_len(cur);
> +}

because this effectively means the key length and offsets for
a btree with the XFS_BTREE_OPS_OVERLAPPING flag set is *always*
cur->bc_ops->key_len * 2.

> +
> +/*
> + * Calculate offset of the n-th high key in a btree block.
> + */
> +STATIC size_t
> +xfs_btree_high_key_offset(
> +	struct xfs_btree_cur	*cur,
> +	int			n)
> +{
> +	return xfs_btree_block_len(cur) +
> +		(n - 1) * xfs_btree_key_len(cur) + cur->bc_ops->key_len;
>  }

And this is the only case where we use a "half key" length to pull
the offset of the high key. Wouldn't it be better to be explicit
about the high key offset rather than encode magic numbers to infer
that the "overlapping key is really two key lengths with the high
key at plus one key len". IMO, this is better:

xfs_btree_high_key_offset(
	struct xfs_btree_cur	*cur,
	int			n)
{
	ASSERT(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING);
	return xfs_btree_block_len(cur) +
		 (n - 1) * cur->bc_ops->key_len +
		 offset_of(struct xfs_btree_double_key, high);
}

It means there are much fewer code changes needed for supporting
the XFS_BTREE_OPS_OVERLAPPING flag, too.

> +STATIC void
> +xfs_btree_find_leaf_keys(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_btree_block	*block,
> +	union xfs_btree_key	*low,
> +	union xfs_btree_key	*high)
> +{
> +	int			n;
> +	union xfs_btree_rec	*rec;
> +	union xfs_btree_key	max_hkey;
> +	union xfs_btree_key	hkey;
> +
> +	rec = xfs_btree_rec_addr(cur, 1, block);
> +	cur->bc_ops->init_key_from_rec(low, rec);
> +
> +	if (!(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING))
> +		return;

When I see conditionals like this, it makes me want to add
a btree specific method. i.e.

	bc_ops->find_leaf_keys()
	bc_ops->find_node_keys()

and we hook them up to generic functions that don't require
checks against feature flags.

i.e:

xfs_btree_find_leaf_low_key()
{
	rec = xfs_btree_rec_addr(cur, 1, block);
	cur->bc_ops->init_key_from_rec(low, rec);
}

xfs_btree_find_leaf_low_high_keys()
{
	xfs_btree_find_leaf_low_key();

	/*
	 * high key finding code here, which is the same function
	 * for both keys and pointers
	 */
}

.....

> +/*
> + * Update parental low & high keys from some block all the way back to the
> + * root of the btree.
> + */
> +STATIC int
> +__xfs_btree_updkeys(

I kept getting confused by xfs_btree_updkey() and
xfs_btree_updkeys(). Can we chose a better name for this parent key
update?


> +	struct xfs_btree_cur	*cur,
> +	int			level,
> +	struct xfs_btree_block	*block,
> +	struct xfs_buf		*bp0,
> +	bool			force_all)
> +{
> +	union xfs_btree_key	lkey;	/* keys from current level */
> +	union xfs_btree_key	hkey;
> +	union xfs_btree_key	*nlkey;	/* keys from the next level up */
> +	union xfs_btree_key	*nhkey;
> +	struct xfs_buf		*bp;
> +	int			ptr = -1;
> +
> +	if (!(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING))
> +		return 0;

And, again, it's a probably better to use a btree op callout for
this, especially when you've added this to xfs_btree_updkey():

> @@ -1893,6 +2132,9 @@ xfs_btree_updkey(
>  	union xfs_btree_key	*kp;
>  	int			ptr;
>  
> +	if (cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING)
> +		return 0;
> +
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
>  	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);

i.e. one or the other "updkey" does something, but not both.
Extremely confusing to see both called but then only one do
anything.

[back to __xfs_btree_updkeys()]

> +
> +	if (level + 1 >= cur->bc_nlevels)
> +		return 0;
> +
> +	trace_xfs_btree_updkeys(cur, level, bp0);
> +
> +	if (level == 0)
> +		xfs_btree_find_leaf_keys(cur, block, &lkey, &hkey);
> +	else
> +		xfs_btree_find_node_keys(cur, block, &lkey, &hkey);

And this code fragment is repeated in many places, so i think a
helper is warranted for this. That also reminds me - the "find" in
the name is confusing - it's not "finding" as much as it is
"getting" the low and high key values from the current block.

It's especially confusing when you do this:

> @@ -1970,7 +2212,8 @@ xfs_btree_update(
>  					    ptr, LASTREC_UPDATE);
>  	}
>  
> -	/* Updating first rec in leaf. Pass new key value up to our parent. */
> +	/* Pass new key value up to our parent. */
> +	xfs_btree_updkeys(cur, 0);
>  	if (ptr == 1) {
>  		union xfs_btree_key	key;

You're throwing away the error from xfs_btree_updkeys() at, AFAICT,
all call sites. This update can fail, so I suspect this needs to
check and handle the update.

>  
> @@ -2149,7 +2392,9 @@ xfs_btree_lshift(
>  		rkp = &key;
>  	}
>  
> -	/* Update the parent key values of right. */
> +	/* Update the parent key values of left and right. */
> +	xfs_btree_sibling_updkeys(cur, level, XFS_BB_LEFTSIB, left, lbp);
> +	xfs_btree_updkeys(cur, level);
>  	error = xfs_btree_updkey(cur, rkp, level + 1);
>  	if (error)
>  		goto error0;

Remember what I said above about xfs_btree_updkeys/xfs_btree_updkey
being confusing? Here we have 3 different key update functions, all
doing different stuff, taking different parameters. None of the code
is consistent in how these updates are done - they are all different
combinations of these functions, so I'm not sure how we are supposed
to verify the correct updates are being done now or in the future.

How can we hide this complexity from the generic btree code?

> @@ -2321,6 +2566,9 @@ xfs_btree_rshift(
>  	if (error)
>  		goto error1;
>  
> +	/* Update left and right parent pointers */
> +	xfs_btree_updkeys(cur, level);
> +	xfs_btree_updkeys(tcur, level);
>  	error = xfs_btree_updkey(tcur, rkp, level + 1);
>  	if (error)
>  		goto error1;

Different.

> @@ -2499,6 +2746,10 @@ __xfs_btree_split(
>  		xfs_btree_set_sibling(cur, rrblock, &rptr, XFS_BB_LEFTSIB);
>  		xfs_btree_log_block(cur, rrbp, XFS_BB_LEFTSIB);
>  	}
> +
> +	/* Update the left block's keys... */
> +	xfs_btree_updkeys(cur, level);

different...

> @@ -2806,27 +3057,27 @@ xfs_btree_new_root(
>  		bp = lbp;
>  		nptr = 2;
>  	}
> +
>  	/* Fill in the new block's btree header and log it. */
>  	xfs_btree_init_block_cur(cur, nbp, cur->bc_nlevels, 2);
>  	xfs_btree_log_block(cur, nbp, XFS_BB_ALL_BITS);
>  	ASSERT(!xfs_btree_ptr_is_null(cur, &lptr) &&
>  			!xfs_btree_ptr_is_null(cur, &rptr));
> -
>  	/* Fill in the key data in the new root. */
>  	if (xfs_btree_get_level(left) > 0) {
> -		xfs_btree_copy_keys(cur,
> +		xfs_btree_find_node_keys(cur, left,
>  				xfs_btree_key_addr(cur, 1, new),
> -				xfs_btree_key_addr(cur, 1, left), 1);
> -		xfs_btree_copy_keys(cur,
> +				xfs_btree_high_key_addr(cur, 1, new));
> +		xfs_btree_find_node_keys(cur, right,
>  				xfs_btree_key_addr(cur, 2, new),
> -				xfs_btree_key_addr(cur, 1, right), 1);
> +				xfs_btree_high_key_addr(cur, 2, new));

And this took me ages to work out - you replaced
xfs_btree_copy_keys() with xfs_btree_find_node_keys() which means
the fact that we are copying a key from one block to antoher has
been lost.  It wasn't until I realised that
xfs_btree_find_node_keys() was writing directly into the new block
record that it was an equivalent operation to a copy.

This is why I don't like the name xfs_btree_find_*_keys() - when it
is used like this it badly obfuscates what operation is being
performed - it's most definitely not a find operation being
performed. i.e. xfs_btree_copy_keys() documents the operation in
an obvious and straight forward manner, the new code takes time and
thought to decipher.

Perhaps you could move it all to inside xfs_btree_copy_keys(), so
the complexity is hidden from the higher level  btree manipulation
functions...

> +/* Copy a double key into a btree block. */
> +static void
> +xfs_btree_copy_double_keys(
> +	struct xfs_btree_cur	*cur,
> +	int			ptr,
> +	struct xfs_btree_block	*block,
> +	struct xfs_btree_double_key	*key)
> +{
> +	memcpy(xfs_btree_key_addr(cur, ptr, block), &key->low,
> +			cur->bc_ops->key_len);
> +
> +	if (cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING)
> +		memcpy(xfs_btree_high_key_addr(cur, ptr, block), &key->high,
> +				cur->bc_ops->key_len);
> +}

This should be located next to xfs_btree_copy_keys().

>  	/* If we inserted at the start of a block, update the parents' keys. */
> +	if (ncur && bp->b_bn != old_bn) {
> +		/*
> +		 * We just inserted into a new tree block, which means that
> +		 * the key for the block is in nkey, not the tree.
> +		 */
> +		if (level == 0)
> +			xfs_btree_find_leaf_keys(cur, block, &nkey.low,
> +					&nkey.high);
> +		else
> +			xfs_btree_find_node_keys(cur, block, &nkey.low,
> +					&nkey.high);
> +	} else {
> +		/* Updating the left block, do it the standard way. */
> +		xfs_btree_updkeys(cur, level);
> +	}
> +
>  	if (optr == 1) {
> -		error = xfs_btree_updkey(cur, key, level + 1);
> +		error = xfs_btree_updkey(cur, &key->low, level + 1);
>  		if (error)
>  			goto error0;
>  	}

This is another of those "huh, what" moments I had with all the
different _updkey functions....

> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index b99c018..a5ec6c7 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -126,6 +126,9 @@ struct xfs_btree_ops {
>  	size_t	key_len;
>  	size_t	rec_len;
>  
> +	/* flags */
> +	uint	flags;
> +
.....
> @@ -182,6 +195,9 @@ struct xfs_btree_ops {
>  #endif
>  };
>  
> +/* btree ops flags */
> +#define XFS_BTREE_OPS_OVERLAPPING	(1<<0)	/* overlapping intervals */
> +

why did you put this in the struct btree_ops  and not in the
btree cursor ->bc_flags field like all the other btree specific
customisations like:

/* cursor flags */
#define XFS_BTREE_LONG_PTRS             (1<<0)  /* pointers are 64bits long */
#define XFS_BTREE_ROOT_IN_INODE         (1<<1)  /* root may be variable size */
#define XFS_BTREE_LASTREC_UPDATE        (1<<2)  /* track last rec externally */
#define XFS_BTREE_CRC_BLOCKS            (1<<3)  /* uses extended btree blocks */

i.e. we should have all the structural/behavioural flags in the one
place, not split across different structures....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
