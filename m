Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932645AbcI3L7F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 07:59:05 -0400
Date: Fri, 30 Sep 2016 07:59:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/63] xfs: adjust refcount of an extent of blocks in
 refcount btree
Message-ID: <20160930115902.GA27528@bfoster.bfoster>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503128663.30303.5434783254366223475.stgit@birch.djwong.org>
 <20160929144432.GA52207@bfoster.bfoster>
 <20160929190345.GA14092@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929190345.GA14092@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 12:03:45PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 29, 2016 at 10:44:33AM -0400, Brian Foster wrote:
> > On Tue, Sep 27, 2016 at 07:54:46PM -0700, Darrick J. Wong wrote:
> > > Provide functions to adjust the reference counts for an extent of
> > > physical blocks stored in the refcount btree.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v2: Refactor the left/right split code into a single function.  Track
> > > the number of btree shape changes and record updates during a refcount
> > > update so that we can decide if we need to get a fresh transaction to
> > > continue.
> > > ---
> > >  fs/xfs/libxfs/xfs_refcount.c |  783 ++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_error.h           |    4 
> > >  2 files changed, 786 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > > index de13406..4f82651 100644
> > > --- a/fs/xfs/libxfs/xfs_refcount.c
> > > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > > @@ -37,6 +37,12 @@
> > >  #include "xfs_bit.h"
> > >  #include "xfs_refcount.h"
> > >  
> > > +/* Allowable refcount adjustment amounts. */
> > > +enum xfs_refc_adjust_op {
> > > +	XFS_REFCOUNT_ADJUST_INCREASE	= 1,
> > > +	XFS_REFCOUNT_ADJUST_DECREASE	= -1,
> > > +};
> > > +
> > >  /*
> > >   * Look up the first record less than or equal to [bno, len] in the btree
> > >   * given by cur.
> > > @@ -175,3 +181,780 @@ xfs_refcount_delete(
> > >  				cur->bc_private.a.agno, error, _RET_IP_);
> > >  	return error;
> > >  }
> > > +
> > > +/*
> > > + * Adjusting the Reference Count
> > > + *
> > > + * As stated elsewhere, the reference count btree (refcbt) stores
> > > + * >1 reference counts for extents of physical blocks.  In this
> > > + * operation, we're either raising or lowering the reference count of
> > > + * some subrange stored in the tree:
> > > + *
> > > + *      <------ adjustment range ------>
> > > + * ----+   +---+-----+ +--+--------+---------
> > > + *  2  |   | 3 |  4  | |17|   55   |   10
> > > + * ----+   +---+-----+ +--+--------+---------
> > > + * X axis is physical blocks number;
> > > + * reference counts are the numbers inside the rectangles
> > > + *
> > > + * The first thing we need to do is to ensure that there are no
> > > + * refcount extents crossing either boundary of the range to be
> > > + * adjusted.  For any extent that does cross a boundary, split it into
> > > + * two extents so that we can increment the refcount of one of the
> > > + * pieces later:
> > > + *
> > > + *      <------ adjustment range ------>
> > > + * ----+   +---+-----+ +--+--------+----+----
> > > + *  2  |   | 3 |  2  | |17|   55   | 10 | 10
> > > + * ----+   +---+-----+ +--+--------+----+----
> > > + *
> > > + * For this next step, let's assume that all the physical blocks in
> > > + * the adjustment range are mapped to a file and are therefore in use
> > > + * at least once.  Therefore, we can infer that any gap in the
> > > + * refcount tree within the adjustment range represents a physical
> > > + * extent with refcount == 1:
> > > + *
> > > + *      <------ adjustment range ------>
> > > + * ----+---+---+-----+-+--+--------+----+----
> > > + *  2  |"1"| 3 |  2  |1|17|   55   | 10 | 10
> > > + * ----+---+---+-----+-+--+--------+----+----
> > > + *      ^
> > > + *
> > > + * For each extent that falls within the interval range, figure out
> > > + * which extent is to the left or the right of that extent.  Now we
> > > + * have a left, current, and right extent.  If the new reference count
> > > + * of the center extent enables us to merge left, center, and right
> > > + * into one record covering all three, do so.  If the center extent is
> > > + * at the left end of the range, abuts the left extent, and its new
> > > + * reference count matches the left extent's record, then merge them.
> > > + * If the center extent is at the right end of the range, abuts the
> > > + * right extent, and the reference counts match, merge those.  In the
> > > + * example, we can left merge (assuming an increment operation):
> > > + *
> > > + *      <------ adjustment range ------>
> > > + * --------+---+-----+-+--+--------+----+----
> > > + *    2    | 3 |  2  |1|17|   55   | 10 | 10
> > > + * --------+---+-----+-+--+--------+----+----
> > > + *          ^
> > > + *
> > > + * For all other extents within the range, adjust the reference count
> > > + * or delete it if the refcount falls below 2.  If we were
> > > + * incrementing, the end result looks like this:
> > > + *
> > > + *      <------ adjustment range ------>
> > > + * --------+---+-----+-+--+--------+----+----
> > > + *    2    | 4 |  3  |2|18|   56   | 11 | 10
> > > + * --------+---+-----+-+--+--------+----+----
> > > + *
> > > + * The result of a decrement operation looks as such:
> > > + *
> > > + *      <------ adjustment range ------>
> > > + * ----+   +---+       +--+--------+----+----
> > > + *  2  |   | 2 |       |16|   54   |  9 | 10
> > > + * ----+   +---+       +--+--------+----+----
> > > + *      DDDD    111111DD
> > > + *
> > > + * The blocks marked "D" are freed; the blocks marked "1" are only
> > > + * referenced once and therefore the record is removed from the
> > > + * refcount btree.
> > > + */
> > > +
> > 
> > Thanks for the big comment. It makes this much easier to follow.
> 
> NP. :)
> 
> > > +#define RCNEXT(rc)	((rc).rc_startblock + (rc).rc_blockcount)
> > ...
> > > +/*
> > > + * Merge the left, center, and right extents.
> > > + */
> > > +STATIC int
> > > +xfs_refcount_merge_center_extent(
> > > +	struct xfs_btree_cur		*cur,
> > > +	struct xfs_refcount_irec	*left,
> > > +	struct xfs_refcount_irec	*center,
> > > +	unsigned long long		extlen,
> > > +	xfs_agblock_t			*agbno,
> > > +	xfs_extlen_t			*aglen)
> > > +{
> > > +	int				error;
> > > +	int				found_rec;
> > > +
> > > +	error = xfs_refcount_lookup_ge(cur, center->rc_startblock,
> > > +			&found_rec);
> > > +	if (error)
> > > +		goto out_error;
> > > +	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
> > > +
> > > +	error = xfs_refcount_delete(cur, &found_rec);
> > > +	if (error)
> > > +		goto out_error;
> > > +	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
> > > +
> > > +	if (center->rc_refcount > 1) {
> >  
> > Comment please :) (what is special about refcount == 1?).
> 
> /*
>  * If the center extent wasn't synthesized, remove it.  See the comments
>  * in _reflink_find_left_extents explaining when this is possible.
>  */
> 

I get the idea, but that doesn't exactly sound like what the code is
doing. If the center extent wasn't synthesized, we've deleted it in the
call above.

> and updated comments in _reflink_find_{left,right}_extents:
> 
> /*
>  * There's a gap in the refcntbt at the start of the range we're
>  * interested in (refcount == 1) so synthesize the implied extent and
>  * pass it back.  We assume here that the agbno/aglen range was passed
>  * in from a data fork extent mapping and therefore is allocated to
>  * exactly one owner.
>  */
> 

Sounds good, thanks.

> > > +		error = xfs_refcount_delete(cur, &found_rec);
> > > +		if (error)
> > > +			goto out_error;
> > > +		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
> > > +				out_error);
> > > +	}
> > > +
> > > +	error = xfs_refcount_lookup_le(cur, left->rc_startblock,
> > > +			&found_rec);
> > > +	if (error)
> > > +		goto out_error;
> > > +	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
> > > +
> > > +	left->rc_blockcount = extlen;
> > 
> > Is extlen valid if the (refcount > 1) condition above fails? Digging
> > further, I suppose so as the refcount == 1 case appears to be a
> > filler/non-existent extent..?
> 
> Right.
> 
> > > +	error = xfs_refcount_update(cur, left);
> > > +	if (error)
> > > +		goto out_error;
> > > +
> > > +	*aglen = 0;
> > > +	return error;
> > > +
> > > +out_error:
> > > +	trace_xfs_refcount_merge_center_extents_error(cur->bc_mp,
> > > +			cur->bc_private.a.agno, error, _RET_IP_);
> > > +	return error;
> > > +}
> > > +
> > ...
> > > +/*
> > > + * Try to merge with any extents on the boundaries of the adjustment range.
> > > + */
> > > +STATIC int
> > > +xfs_refcount_merge_extents(
> > > +	struct xfs_btree_cur	*cur,
> > > +	xfs_agblock_t		*agbno,
> > > +	xfs_extlen_t		*aglen,
> > > +	enum xfs_refc_adjust_op adjust,
> > > +	bool			*shape_changed)
> > > +{
> > > +	struct xfs_refcount_irec	left = {0}, cleft = {0};
> > > +	struct xfs_refcount_irec	cright = {0}, right = {0};
> > > +	int				error;
> > > +	unsigned long long		ulen;
> > > +	bool				cequal;
> > > +
> > > +	*shape_changed = false;
> > > +	/*
> > > +	 * Find the extent just below agbno [left], just above agbno [cleft],
> > > +	 * just below (agbno + aglen) [cright], and just above (agbno + aglen)
> > > +	 * [right].
> > > +	 */
> > > +	error = xfs_refcount_find_left_extents(cur, &left, &cleft, *agbno,
> > > +			*aglen);
> > > +	if (error)
> > > +		return error;
> > > +	error = xfs_refcount_find_right_extents(cur, &right, &cright, *agbno,
> > > +			*aglen);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	/* No left or right extent to merge; exit. */
> > > +	if (left.rc_blockcount == 0 && right.rc_blockcount == 0)
> > > +		return 0;
> > 
> > Can we use start block and NULLAGBLOCK in the find helpers to identify
> > the no extent case rather than blockcount == 0?
> 
> Yes, that makes more sense.
> 
> > > +
> > > +	*shape_changed = true;
> > 
> > Why is this true already if we haven't actually merged extents yet? This
> > could use some explanation...
> 
> Overly conservative estimate of whether or not refcount extents got
> inserted or deleted.  This will get moved to just prior to the
> _refcount_merge_*_extents calls.
> 

Ok.

> > > +	cequal = (cleft.rc_startblock == cright.rc_startblock) &&
> > > +		 (cleft.rc_blockcount == cright.rc_blockcount);
> > > +
> > > +	/* Try to merge left, cleft, and right.  cleft must == cright. */
> > > +	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount +
> > > +			right.rc_blockcount;
> > > +	if (left.rc_blockcount != 0 && right.rc_blockcount != 0 &&
> > > +	    cleft.rc_blockcount != 0 && cright.rc_blockcount != 0 &&
> > > +	    cequal &&
> > > +	    left.rc_refcount == cleft.rc_refcount + adjust &&
> > > +	    right.rc_refcount == cleft.rc_refcount + adjust &&
> > > +	    ulen < MAXREFCEXTLEN) {
> > > +		trace_xfs_refcount_merge_center_extents(cur->bc_mp,
> > > +				cur->bc_private.a.agno, &left, &cleft, &right);
> > 
> > I'd suggest to bury tracepoints such as this (generally speaking, those
> > that match a function name) down into the start of the associated
> > function rather than at the call site. That seems more consistent with
> > the rest of XFS.
> 
> Ok.  I should've moved them when I refactored all those bits into
> separate functions long ago.
> 
> > 
> > > +		return xfs_refcount_merge_center_extent(cur, &left, &cleft,
> > > +				ulen, agbno, aglen);
> > > +	}
> > > +
> > > +	/* Try to merge left and cleft. */
> > > +	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount;
> > > +	if (left.rc_blockcount != 0 && cleft.rc_blockcount != 0 &&
> > > +	    left.rc_refcount == cleft.rc_refcount + adjust &&
> > > +	    ulen < MAXREFCEXTLEN) {
> > > +		trace_xfs_refcount_merge_left_extent(cur->bc_mp,
> > > +				cur->bc_private.a.agno, &left, &cleft);
> > > +		error = xfs_refcount_merge_left_extent(cur, &left, &cleft,
> > > +				agbno, aglen);
> > > +		if (error)
> > > +			return error;
> > > +
> > > +		/*
> > > +		 * If we just merged left + cleft and cleft == cright,
> > > +		 * we no longer have a cright to merge with right.  We're done.
> > > +		 */
> > > +		if (cequal)
> > > +			return 0;
> > > +	}
> > > +
> > > +	/* Try to merge cright and right. */
> > > +	ulen = (unsigned long long)right.rc_blockcount + cright.rc_blockcount;
> > > +	if (right.rc_blockcount != 0 && cright.rc_blockcount != 0 &&
> > > +	    right.rc_refcount == cright.rc_refcount + adjust &&
> > > +	    ulen < MAXREFCEXTLEN) {
> > > +		trace_xfs_refcount_merge_right_extent(cur->bc_mp,
> > > +				cur->bc_private.a.agno, &cright, &right);
> > > +		return xfs_refcount_merge_right_extent(cur, &right, &cright,
> > > +				agbno, aglen);
> > > +	}
> > > +
> > > +	return error;
> > > +}
> > > +
> > ...
> > > +/*
> > > + * Adjust the refcounts of middle extents.  At this point we should have
> > > + * split extents that crossed the adjustment range; merged with adjacent
> > > + * extents; and updated agbno/aglen to reflect the merges.  Therefore,
> > > + * all we have to do is update the extents inside [agbno, agbno + aglen].
> > > + */
> > > +STATIC int
> > > +xfs_refcount_adjust_extents(
> > > +	struct xfs_btree_cur	*cur,
> > > +	xfs_agblock_t		agbno,
> > > +	xfs_extlen_t		aglen,
> > > +	xfs_extlen_t		*adjusted,
> > > +	enum xfs_refc_adjust_op	adj,
> > > +	struct xfs_defer_ops	*dfops,
> > > +	struct xfs_owner_info	*oinfo)
> > > +{
> > > +	struct xfs_refcount_irec	ext, tmp;
> > > +	int				error;
> > > +	int				found_rec, found_tmp;
> > > +	xfs_fsblock_t			fsbno;
> > > +
> > > +	/* Merging did all the work already. */
> > > +	if (aglen == 0)
> > > +		return 0;
> > > +
> > > +	error = xfs_refcount_lookup_ge(cur, agbno, &found_rec);
> > > +	if (error)
> > > +		goto out_error;
> > > +
> > > +	while (aglen > 0 && xfs_refcount_still_have_space(cur)) {
> > > +		error = xfs_refcount_get_rec(cur, &ext, &found_rec);
> > > +		if (error)
> > > +			goto out_error;
> > > +		if (!found_rec) {
> > > +			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
> > > +			ext.rc_blockcount = 0;
> > > +			ext.rc_refcount = 0;
> > > +		}
> > > +
> > > +		/*
> > > +		 * Deal with a hole in the refcount tree; if a file maps to
> > > +		 * these blocks and there's no refcountbt recourd, pretend that
> > 
> > Typo:							  record
> 
> Fixed.
> 
> > > +		 * there is one with refcount == 1.
> > > +		 */
> > 
> > Also, what actually confirms that the blocks are file mapped?
> 
> There's no explicit check that the (agbno/aglen) range is actually file
> mapped.  However, the only way into this function is via the refcount
> deferred ops mechanism, and the only way into that is via
> _refcount_{in,de}crease_extent, which both take xfs_bmbt_irec
> parameters.  The only callers of those two functions are
> _reflink_remap_extent and _bmap_del_extent, both of which operate on
> file extents.
> 
> So, the only way that unshareable blocks (xattrs, metadata, etc.) can
> end up in the refcount mechanism is malicious code, bugs, or corrupt
> metadata.
> 
> > Couldn't blocks absent from the refcbt also reside in the allocbt?
> 
> Yes, but if they're in the freespace btrees, they ought not also be
> mapped into a file.
> 
> > (I guess the broader question is what are the rules/expectations for
> > handling sparse files..?).
> 
> Holes should never get reflinked or bunmapi'd.
> 

Ok, thanks for the explanation.

> > > +		if (ext.rc_startblock != agbno) {
> > > +			tmp.rc_startblock = agbno;
> > > +			tmp.rc_blockcount = min(aglen,
> > > +					ext.rc_startblock - agbno);
> > > +			tmp.rc_refcount = 1 + adj;
> > > +			trace_xfs_refcount_modify_extent(cur->bc_mp,
> > > +					cur->bc_private.a.agno, &tmp);
> > > +
> > > +			/*
> > > +			 * Either cover the hole (increment) or
> > > +			 * delete the range (decrement).
> > > +			 */
> > > +			if (tmp.rc_refcount) {
> > > +				error = xfs_refcount_insert(cur, &tmp,
> > > +						&found_tmp);
> > > +				if (error)
> > > +					goto out_error;
> > > +				XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
> > > +						found_tmp == 1, out_error);
> > > +				cur->bc_private.a.priv.refc.nr_ops++;
> > > +			} else {
> > > +				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
> > > +						cur->bc_private.a.agno,
> > > +						tmp.rc_startblock);
> > > +				xfs_bmap_add_free(cur->bc_mp, dfops, fsbno,
> > > +						tmp.rc_blockcount, oinfo);
> > > +			}
> > > +
> > > +			(*adjusted) += tmp.rc_blockcount;
> > > +			agbno += tmp.rc_blockcount;
> > > +			aglen -= tmp.rc_blockcount;
> > > +
> > > +			error = xfs_refcount_lookup_ge(cur, agbno,
> > > +					&found_rec);
> > > +			if (error)
> > > +				goto out_error;
> > > +		}
> > > +
> > > +		/* Stop if there's nothing left to modify */
> > > +		if (aglen == 0 || !xfs_refcount_still_have_space(cur))
> > > +			break;
> > > +
> > > +		/*
> > > +		 * Adjust the reference count and either update the tree
> > > +		 * (incr) or free the blocks (decr).
> > > +		 */
> > > +		if (ext.rc_refcount == MAXREFCOUNT)
> > > +			goto skip;
> > > +		ext.rc_refcount += adj;
> > > +		trace_xfs_refcount_modify_extent(cur->bc_mp,
> > > +				cur->bc_private.a.agno, &ext);
> > > +		if (ext.rc_refcount > 1) {
> > > +			error = xfs_refcount_update(cur, &ext);
> > > +			if (error)
> > > +				goto out_error;
> > > +			cur->bc_private.a.priv.refc.nr_ops++;
> > > +		} else if (ext.rc_refcount == 1) {
> > > +			error = xfs_refcount_delete(cur, &found_rec);
> > > +			if (error)
> > > +				goto out_error;
> > > +			XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
> > > +					found_rec == 1, out_error);
> > > +			cur->bc_private.a.priv.refc.nr_ops++;
> > > +			goto advloop;
> > > +		} else {
> > > +			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
> > > +					cur->bc_private.a.agno,
> > > +					ext.rc_startblock);
> > > +			xfs_bmap_add_free(cur->bc_mp, dfops, fsbno,
> > > +					ext.rc_blockcount, oinfo);
> > > +		}
> > > +
> > > +skip:
> > > +		error = xfs_btree_increment(cur, 0, &found_rec);
> > > +		if (error)
> > > +			goto out_error;
> > > +
> > > +advloop:
> > > +		(*adjusted) += ext.rc_blockcount;
> > > +		agbno += ext.rc_blockcount;
> > > +		aglen -= ext.rc_blockcount;
> > > +	}
> > > +
> > > +	return error;
> > > +out_error:
> > > +	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
> > > +			cur->bc_private.a.agno, error, _RET_IP_);
> > > +	return error;
> > > +}
> > > +
> > > +/* Adjust the reference count of a range of AG blocks. */
> > > +STATIC int
> > > +xfs_refcount_adjust(
> > > +	struct xfs_btree_cur	*cur,
> > > +	xfs_agblock_t		agbno,
> > > +	xfs_extlen_t		aglen,
> > > +	xfs_extlen_t		*adjusted,
> > > +	enum xfs_refc_adjust_op	adj,
> > > +	struct xfs_defer_ops	*dfops,
> > > +	struct xfs_owner_info	*oinfo)
> > > +{
> > > +	xfs_extlen_t		orig_aglen;
> > > +	bool			shape_changed;
> > > +	int			shape_changes = 0;
> > > +	int			error;
> > > +
> > > +	*adjusted = 0;
> > > +	switch (adj) {
> > > +	case XFS_REFCOUNT_ADJUST_INCREASE:
> > > +		trace_xfs_refcount_increase(cur->bc_mp, cur->bc_private.a.agno,
> > > +				agbno, aglen);
> > > +		break;
> > > +	case XFS_REFCOUNT_ADJUST_DECREASE:
> > > +		trace_xfs_refcount_decrease(cur->bc_mp, cur->bc_private.a.agno,
> > > +				agbno, aglen);
> > > +		break;
> > > +	default:
> > > +		ASSERT(0);
> > > +	}
> > > +
> > 
> > Seems like slight overkill... how about a single
> > trace_xfs_refcount_adjust() call that also takes adj as a parameter? We
> > should be able to even print an "inc" or "dec" string or some such if we
> > want for easier filtering.
> 
> I prefer to leave the two tracepoints so that I can filter at the
> trace-cmd level:
> 
> # trace-cmd record -e xfs_refcount_decrease -F xfs_io...
> 
> That said, you're right about the switch being overkill since the enum
> is private to the file.  I'll collapse it to an if statement.
> 

Sounds fine.

Brian

> Thank you for the review!
> 
> --D
> 
> > 
> > Brian
> > 
> > > +	/*
> > > +	 * Ensure that no rcextents cross the boundary of the adjustment range.
> > > +	 */
> > > +	error = xfs_refcount_split_extent(cur, agbno, &shape_changed);
> > > +	if (error)
> > > +		goto out_error;
> > > +	if (shape_changed)
> > > +		shape_changes++;
> > > +
> > > +	error = xfs_refcount_split_extent(cur, agbno + aglen, &shape_changed);
> > > +	if (error)
> > > +		goto out_error;
> > > +	if (shape_changed)
> > > +		shape_changes++;
> > > +
> > > +	/*
> > > +	 * Try to merge with the left or right extents of the range.
> > > +	 */
> > > +	orig_aglen = aglen;
> > > +	error = xfs_refcount_merge_extents(cur, &agbno, &aglen, adj,
> > > +			&shape_changed);
> > > +	if (error)
> > > +		goto out_error;
> > > +	if (shape_changed)
> > > +		shape_changes++;
> > > +	(*adjusted) += orig_aglen - aglen;
> > > +	if (shape_changes)
> > > +		cur->bc_private.a.priv.refc.shape_changes++;
> > > +
> > > +	/* Now that we've taken care of the ends, adjust the middle extents */
> > > +	error = xfs_refcount_adjust_extents(cur, agbno, aglen, adjusted, adj,
> > > +			dfops, oinfo);
> > > +	if (error)
> > > +		goto out_error;
> > > +
> > > +	return 0;
> > > +
> > > +out_error:
> > > +	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_private.a.agno,
> > > +			error, _RET_IP_);
> > > +	return error;
> > > +}
> > > diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> > > index 3d22470..d9675c64 100644
> > > --- a/fs/xfs/xfs_error.h
> > > +++ b/fs/xfs/xfs_error.h
> > > @@ -92,7 +92,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
> > >  #define XFS_ERRTAG_BMAPIFORMAT				21
> > >  #define XFS_ERRTAG_FREE_EXTENT				22
> > >  #define XFS_ERRTAG_RMAP_FINISH_ONE			23
> > > -#define XFS_ERRTAG_MAX					24
> > > +#define XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE		24
> > > +#define XFS_ERRTAG_MAX					25
> > >  
> > >  /*
> > >   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> > > @@ -121,6 +122,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
> > >  #define	XFS_RANDOM_BMAPIFORMAT				XFS_RANDOM_DEFAULT
> > >  #define XFS_RANDOM_FREE_EXTENT				1
> > >  #define XFS_RANDOM_RMAP_FINISH_ONE			1
> > > +#define XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE		1
> > >  
> > >  #ifdef DEBUG
> > >  extern int xfs_error_test_active;
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
