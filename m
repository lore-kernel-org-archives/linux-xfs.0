Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0EE647CA4
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 11:30:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A904D8F8039
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 09:30:00 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id vAeias3JX7PCLeaY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 09:29:56 -0700 (PDT)
Date: Tue, 28 Jun 2016 09:29:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 014/119] xfs: introduce interval queries on btrees
Message-ID: <20160628162951.GA16181@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612636170.12839.675596870201079078.stgit@birch.djwong.org>
	<20160622151800.GC5423@bfoster.bfoster>
	<20160627210746.GB4921@birch.djwong.org>
	<20160628123218.GC4212@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160628123218.GC4212@bfoster.bfoster>
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

On Tue, Jun 28, 2016 at 08:32:19AM -0400, Brian Foster wrote:
> On Mon, Jun 27, 2016 at 02:07:46PM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 22, 2016 at 11:18:00AM -0400, Brian Foster wrote:
> > > On Thu, Jun 16, 2016 at 06:19:21PM -0700, Darrick J. Wong wrote:
> > > > Create a function to enable querying of btree records mapping to a
> > > > range of keys.  This will be used in subsequent patches to allow
> > > > querying the reverse mapping btree to find the extents mapped to a
> > > > range of physical blocks, though the generic code can be used for
> > > > any range query.
> > > > 
> > > > v2: add some shortcuts so that we can jump out of processing once
> > > > we know there won't be any more records to find.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_btree.c |  249 +++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_btree.h |   22 +++-
> > > >  fs/xfs/xfs_trace.h        |    1 
> > > >  3 files changed, 267 insertions(+), 5 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > > index afcafd6..5f5cf23 100644
> > > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > > @@ -4509,3 +4509,252 @@ xfs_btree_calc_size(
> > > >  	}
> > > >  	return rval;
> > > >  }
> > > > +
> > > > +/* Query a regular btree for all records overlapping a given interval. */
> > > 
> > > Can you elaborate on the search algorithm used? (More for reference
> > > against the overlapped query, as that one is more complex).
> > 
> > Ok.  Both query_range functions aim to return all records intersecting the
> > given range.
> > 
> > For non-overlapped btrees, we start with a LE lookup of the low key and
> > return each record we find a the record with a key greater than the
> > high key.
> > 
> > For overlapped btrees, we follow the procedure in the "Interval trees"
> > section of _Introduction to Algorithms_, which is 14.3 in the 2nd and
> > 3rd editions.  The query algorithm is roughly as follows:
> > 
> > For any leaf btree node, generate the low and high keys for the record.
> > If there's a range overlap with the query's low and high keys, pass the
> > record to the iterator function.
> > 
> > For any internal btree node, compare the low and high keys for each pointer
> > against the query's low and high keys.  If there's an overlap, follow the
> > pointer downwards in the tree.
> > 
> > (I could render the figures in the book as ASCII art if anyone wants.)
> > 
> 
> Thanks. I meant more to update the comments above each function. :) No
> need to go as far as ASCII art I don't think (the external reference
> might be good though). I was really just looking for something that says
> "this function is supposed to do <whatever>" so somebody reading through
> it has a starting point of reference.

Ok, I pasted a (somewhat reworded) version of the above in the comments.

> > > 
> > > > +STATIC int
> > > > +xfs_btree_simple_query_range(
> > > > +	struct xfs_btree_cur		*cur,
> > > > +	union xfs_btree_irec		*low_rec,
> > > > +	union xfs_btree_irec		*high_rec,
> > > > +	xfs_btree_query_range_fn	fn,
> > > > +	void				*priv)
> > > > +{
> > > > +	union xfs_btree_rec		*recp;
> > > > +	union xfs_btree_rec		rec;
> > > > +	union xfs_btree_key		low_key;
> > > > +	union xfs_btree_key		high_key;
> > > > +	union xfs_btree_key		rec_key;
> > > > +	__int64_t			diff;
> > > > +	int				stat;
> > > > +	bool				firstrec = true;
> > > > +	int				error;
> > > > +
> > > > +	ASSERT(cur->bc_ops->init_high_key_from_rec);
> > > > +
> > > > +	/* Find the keys of both ends of the interval. */
> > > > +	cur->bc_rec = *high_rec;
> > > > +	cur->bc_ops->init_rec_from_cur(cur, &rec);
> > > > +	cur->bc_ops->init_key_from_rec(&high_key, &rec);
> > > > +
> > > > +	cur->bc_rec = *low_rec;
> > > > +	cur->bc_ops->init_rec_from_cur(cur, &rec);
> > > > +	cur->bc_ops->init_key_from_rec(&low_key, &rec);
> > > > +
> > > > +	/* Find the leftmost record. */
> > > > +	stat = 0;
> > > > +	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, &stat);
> > > > +	if (error)
> > > > +		goto out;
> > > > +
> > > > +	while (stat) {
> > > > +		/* Find the record. */
> > > > +		error = xfs_btree_get_rec(cur, &recp, &stat);
> > > > +		if (error || !stat)
> > > > +			break;
> > > > +
> > > > +		/* Can we tell if this record is too low? */
> > > > +		if (firstrec) {
> > > > +			cur->bc_rec = *low_rec;
> > > > +			cur->bc_ops->init_high_key_from_rec(&rec_key, recp);
> > > > +			diff = cur->bc_ops->key_diff(cur, &rec_key);
> > > > +			if (diff < 0)
> > > > +				goto advloop;
> > > > +		}
> > > > +		firstrec = false;
> > > 
> > > This could move up into the if block.
> > 
> > Ok.
> > 
> > > > +
> > > > +		/* Have we gone past the end? */
> > > > +		cur->bc_rec = *high_rec;
> > > > +		cur->bc_ops->init_key_from_rec(&rec_key, recp);
> > > 
> > > I'd move this up to immediately after the xfs_btree_get_rec() call and
> > > eliminate the duplicate in the 'if (firstrec)' block above.
> > 
> > Ok.  That key ought to be named rec_hkey too.
> > 
> > > > +		diff = cur->bc_ops->key_diff(cur, &rec_key);
> > > > +		if (diff > 0)
> > > > +			break;
> > > > +
> > > > +		/* Callback */
> > > > +		error = fn(cur, recp, priv);
> > > > +		if (error < 0 || error == XFS_BTREE_QUERY_RANGE_ABORT)
> > > > +			break;
> > > > +
> > > > +advloop:
> > > > +		/* Move on to the next record. */
> > > > +		error = xfs_btree_increment(cur, 0, &stat);
> > > > +		if (error)
> > > > +			break;
> > > > +	}
> > > > +
> > > > +out:
> > > > +	return error;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Query an overlapped interval btree for all records overlapping a given
> > > > + * interval.
> > > > + */
> > > 
> > > Same comment here, can you elaborate on the search algorithm? Also, I
> > > think an example or generic description of the rules around what records
> > > this query returns (e.g., low_rec/high_rec vs. record low/high keys)
> > > would be useful, particularly since I, at least, don't have much context
> > > on the rmap+reflink scenarios quite yet.
> > 
> > Let's say you have a bunch of (overlapped) rmap records:
> > 
> > 1: +- file A startblock B offset C length D -----------+
> > 2:      +- file E startblock F offset G length H --------------+
> > 3:      +- file I startblock F offset J length K --+
> > 4:                                                        +- file L... --+
> > 
> > Now say we want to map block (B+D) into file A at offset (C+D).  Ideally, we'd
> > simply increment the length of record 1.  But how do we find that record that
> > ends at (B+D-1)?  A LE lookup of (B+D-1) would return record 3 because the
> > keys are ordered first by startblock.  An interval query would return records
> > 1 and 2 because they both overlap (B+D-1), and from that we can pick out
> > record 1 as the appropriate left neighbor.
> > 
> 
> Great, thanks.. can you include this content in the comment above the
> function as well?

Added this to the comments as well, since it documents the only justification
for any of this overlapped interval btree stuff. :)

--D

> 
> Brian
> 
> > In the non-overlapped case you can do a LE lookup and decrement the cursor
> > because a record's interval must end before the next record.
> > 
> > > > +STATIC int
> > > > +xfs_btree_overlapped_query_range(
> > > > +	struct xfs_btree_cur		*cur,
> > > > +	union xfs_btree_irec		*low_rec,
> > > > +	union xfs_btree_irec		*high_rec,
> > > > +	xfs_btree_query_range_fn	fn,
> > > > +	void				*priv)
> > > > +{
> > > > +	union xfs_btree_ptr		ptr;
> > > > +	union xfs_btree_ptr		*pp;
> > > > +	union xfs_btree_key		rec_key;
> > > > +	union xfs_btree_key		low_key;
> > > > +	union xfs_btree_key		high_key;
> > > > +	union xfs_btree_key		*lkp;
> > > > +	union xfs_btree_key		*hkp;
> > > > +	union xfs_btree_rec		rec;
> > > > +	union xfs_btree_rec		*recp;
> > > > +	struct xfs_btree_block		*block;
> > > > +	__int64_t			ldiff;
> > > > +	__int64_t			hdiff;
> > > > +	int				level;
> > > > +	struct xfs_buf			*bp;
> > > > +	int				i;
> > > > +	int				error;
> > > > +
> > > > +	/* Find the keys of both ends of the interval. */
> > > > +	cur->bc_rec = *high_rec;
> > > > +	cur->bc_ops->init_rec_from_cur(cur, &rec);
> > > > +	cur->bc_ops->init_key_from_rec(&high_key, &rec);
> > > > +
> > > > +	cur->bc_rec = *low_rec;
> > > > +	cur->bc_ops->init_rec_from_cur(cur, &rec);
> > > > +	cur->bc_ops->init_key_from_rec(&low_key, &rec);
> > > > +
> > > > +	/* Load the root of the btree. */
> > > > +	level = cur->bc_nlevels - 1;
> > > > +	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
> > > > +	error = xfs_btree_lookup_get_block(cur, level, &ptr, &block);
> > > > +	if (error)
> > > > +		return error;
> > > > +	xfs_btree_get_block(cur, level, &bp);
> > > > +	trace_xfs_btree_overlapped_query_range(cur, level, bp);
> > > > +#ifdef DEBUG
> > > > +	error = xfs_btree_check_block(cur, block, level, bp);
> > > > +	if (error)
> > > > +		goto out;
> > > > +#endif
> > > > +	cur->bc_ptrs[level] = 1;
> > > > +
> > > > +	while (level < cur->bc_nlevels) {
> > > > +		block = XFS_BUF_TO_BLOCK(cur->bc_bufs[level]);
> > > > +
> > > > +		if (level == 0) {
> > > > +			/* End of leaf, pop back towards the root. */
> > > > +			if (cur->bc_ptrs[level] >
> > > > +			    be16_to_cpu(block->bb_numrecs)) {
> > > > +leaf_pop_up:
> > > > +				if (level < cur->bc_nlevels - 1)
> > > > +					cur->bc_ptrs[level + 1]++;
> > > > +				level++;
> > > > +				continue;
> > > > +			}
> > > > +
> > > > +			recp = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
> > > > +
> > > > +			cur->bc_ops->init_high_key_from_rec(&rec_key, recp);
> > > > +			ldiff = cur->bc_ops->diff_two_keys(cur, &low_key,
> > > > +					&rec_key);
> > > > +
> > > > +			cur->bc_ops->init_key_from_rec(&rec_key, recp);
> > > > +			hdiff = cur->bc_ops->diff_two_keys(cur, &rec_key,
> > > > +					&high_key);
> > > > +
> > > 
> > > This looked a little funny to me because I expected diff_two_keys() to
> > > basically be param1 - param2. Looking ahead at the rmapbt code, it is in
> > > fact the other way around. I'm not sure we have precedent for either
> > > way, tbh. I still have to stare at this some more, but I wonder if a
> > > "does record overlap" helper (with comments) would help clean this up a
> > > bit.
> > 
> > You're correct this is exactly the opposite of the compare functions in
> > the C library and the rest of the kernel.  I'll fix that up.
> > 
> > > > +			/* If the record matches, callback */
> > > > +			if (ldiff >= 0 && hdiff >= 0) {
> > 
> > Ok, I'll make it a little clearer what we're testing here:
> > 
> > /*
> >  * If (record's high key >= query's low key) and
> >  *    (query's high key >= record's low key), then
> >  * this record overlaps the query range, so callback.
> >  */
> > 
> > 
> > > > +				error = fn(cur, recp, priv);
> > > > +				if (error < 0 ||
> > > > +				    error == XFS_BTREE_QUERY_RANGE_ABORT)
> > > > +					break;
> > > > +			} else if (hdiff < 0) {
> > > > +				/* Record is larger than high key; pop. */
> > > > +				goto leaf_pop_up;
> > > > +			}
> > > > +			cur->bc_ptrs[level]++;
> > > > +			continue;
> > > > +		}
> > > > +
> > > > +		/* End of node, pop back towards the root. */
> > > > +		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
> > > > +node_pop_up:
> > > > +			if (level < cur->bc_nlevels - 1)
> > > > +				cur->bc_ptrs[level + 1]++;
> > > > +			level++;
> > > > +			continue;
> > > 
> > > Looks like same code as leaf_pop_up. I wonder if we can bury this at the
> > > end of the loop with a common label.
> > 
> > Yep.
> > 
> > > > +		}
> > > > +
> > > > +		lkp = xfs_btree_key_addr(cur, cur->bc_ptrs[level], block);
> > > > +		hkp = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level], block);
> > > > +		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
> > > > +
> > > > +		ldiff = cur->bc_ops->diff_two_keys(cur, &low_key, hkp);
> > > > +		hdiff = cur->bc_ops->diff_two_keys(cur, lkp, &high_key);
> > > > +
> > > > +		/* If the key matches, drill another level deeper. */
> > > > +		if (ldiff >= 0 && hdiff >= 0) {
> > > > +			level--;
> > > > +			error = xfs_btree_lookup_get_block(cur, level, pp,
> > > > +					&block);
> > > > +			if (error)
> > > > +				goto out;
> > > > +			xfs_btree_get_block(cur, level, &bp);
> > > > +			trace_xfs_btree_overlapped_query_range(cur, level, bp);
> > > > +#ifdef DEBUG
> > > > +			error = xfs_btree_check_block(cur, block, level, bp);
> > > > +			if (error)
> > > > +				goto out;
> > > > +#endif
> > > > +			cur->bc_ptrs[level] = 1;
> > > > +			continue;
> > > > +		} else if (hdiff < 0) {
> > > > +			/* The low key is larger than the upper range; pop. */
> > > > +			goto node_pop_up;
> > > > +		}
> > > > +		cur->bc_ptrs[level]++;
> > > > +	}
> > > > +
> > > > +out:
> > > > +	/*
> > > > +	 * If we don't end this function with the cursor pointing at a record
> > > > +	 * block, a subsequent non-error cursor deletion will not release
> > > > +	 * node-level buffers, causing a buffer leak.  This is quite possible
> > > > +	 * with a zero-results range query, so release the buffers if we
> > > > +	 * failed to return any results.
> > > > +	 */
> > > > +	if (cur->bc_bufs[0] == NULL) {
> > > > +		for (i = 0; i < cur->bc_nlevels; i++) {
> > > > +			if (cur->bc_bufs[i]) {
> > > > +				xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
> > > > +				cur->bc_bufs[i] = NULL;
> > > > +				cur->bc_ptrs[i] = 0;
> > > > +				cur->bc_ra[i] = 0;
> > > > +			}
> > > > +		}
> > > > +	}
> > > > +
> > > > +	return error;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Query a btree for all records overlapping a given interval of keys.  The
> > > > + * supplied function will be called with each record found; return one of the
> > > > + * XFS_BTREE_QUERY_RANGE_{CONTINUE,ABORT} values or the usual negative error
> > > > + * code.  This function returns XFS_BTREE_QUERY_RANGE_ABORT, zero, or a
> > > > + * negative error code.
> > > > + */
> > > > +int
> > > > +xfs_btree_query_range(
> > > > +	struct xfs_btree_cur		*cur,
> > > > +	union xfs_btree_irec		*low_rec,
> > > > +	union xfs_btree_irec		*high_rec,
> > > > +	xfs_btree_query_range_fn	fn,
> > > > +	void				*priv)
> > > > +{
> > > > +	if (!(cur->bc_ops->flags & XFS_BTREE_OPS_OVERLAPPING))
> > > > +		return xfs_btree_simple_query_range(cur, low_rec,
> > > > +				high_rec, fn, priv);
> > > > +	return xfs_btree_overlapped_query_range(cur, low_rec, high_rec,
> > > > +			fn, priv);
> > > > +}
> > > > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > > > index a5ec6c7..898fee5 100644
> > > > --- a/fs/xfs/libxfs/xfs_btree.h
> > > > +++ b/fs/xfs/libxfs/xfs_btree.h
> > > > @@ -206,6 +206,12 @@ struct xfs_btree_ops {
> > > >  #define LASTREC_DELREC	2
> > > >  
> > > >  
> > > > +union xfs_btree_irec {
> > > > +	xfs_alloc_rec_incore_t		a;
> > > > +	xfs_bmbt_irec_t			b;
> > > > +	xfs_inobt_rec_incore_t		i;
> > > > +};
> > > > +
> > > 
> > > We might as well kill off the typedef usage here.
> > 
> > Ok.  Thx for the review!
> > 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > >  /*
> > > >   * Btree cursor structure.
> > > >   * This collects all information needed by the btree code in one place.
> > > > @@ -216,11 +222,7 @@ typedef struct xfs_btree_cur
> > > >  	struct xfs_mount	*bc_mp;	/* file system mount struct */
> > > >  	const struct xfs_btree_ops *bc_ops;
> > > >  	uint			bc_flags; /* btree features - below */
> > > > -	union {
> > > > -		xfs_alloc_rec_incore_t	a;
> > > > -		xfs_bmbt_irec_t		b;
> > > > -		xfs_inobt_rec_incore_t	i;
> > > > -	}		bc_rec;		/* current insert/search record value */
> > > > +	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
> > > >  	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
> > > >  	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
> > > >  	__uint8_t	bc_ra[XFS_BTREE_MAXLEVELS];	/* readahead bits */
> > > > @@ -494,4 +496,14 @@ xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,
> > > >  uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
> > > >  		unsigned long len);
> > > >  
> > > > +/* return codes */
> > > > +#define XFS_BTREE_QUERY_RANGE_CONTINUE	0	/* keep iterating */
> > > > +#define XFS_BTREE_QUERY_RANGE_ABORT	1	/* stop iterating */
> > > > +typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
> > > > +		union xfs_btree_rec *rec, void *priv);
> > > > +
> > > > +int xfs_btree_query_range(struct xfs_btree_cur *cur,
> > > > +		union xfs_btree_irec *low_rec, union xfs_btree_irec *high_rec,
> > > > +		xfs_btree_query_range_fn fn, void *priv);
> > > > +
> > > >  #endif	/* __XFS_BTREE_H__ */
> > > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > > index ffea28c..f0ac9c9 100644
> > > > --- a/fs/xfs/xfs_trace.h
> > > > +++ b/fs/xfs/xfs_trace.h
> > > > @@ -2218,6 +2218,7 @@ DEFINE_EVENT(xfs_btree_cur_class, name, \
> > > >  	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp), \
> > > >  	TP_ARGS(cur, level, bp))
> > > >  DEFINE_BTREE_CUR_EVENT(xfs_btree_updkeys);
> > > > +DEFINE_BTREE_CUR_EVENT(xfs_btree_overlapped_query_range);
> > > >  
> > > >  #endif /* _TRACE_XFS_H */
> > > >  
> > > > 
> > > > _______________________________________________
> > > > xfs mailing list
> > > > xfs@oss.sgi.com
> > > > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
