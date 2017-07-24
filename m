Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31422 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751482AbdGXV6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 17:58:15 -0400
Date: Mon, 24 Jul 2017 14:58:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/22] xfs: generic functions to scrub metadata and btrees
Message-ID: <20170724215810.GJ4352@magnolia>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061193407.14732.9644386359653380682.stgit@magnolia>
 <20170724010549.GB17762@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724010549.GB17762@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2017 at 11:05:49AM +1000, Dave Chinner wrote:
> On Thu, Jul 20, 2017 at 09:38:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a function that walks a btree, checking the integrity of each
> > btree block (headers, keys, records) and calling back to the caller
> > to perform further checks on the records.  Add some helper functions
> > so that we report detailed scrub errors in a uniform manner in dmesg.
> > These are helper functions for subsequent patches.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Makefile       |    1 
> >  fs/xfs/scrub/btree.c  |  658 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/btree.h  |   95 +++++++
> >  fs/xfs/scrub/common.c |  169 +++++++++++++
> >  fs/xfs/scrub/common.h |   30 ++
> >  5 files changed, 953 insertions(+)
> >  create mode 100644 fs/xfs/scrub/btree.c
> >  create mode 100644 fs/xfs/scrub/btree.h
> .....
> > +/* btree scrubbing */
> > +
> > +const char * const btree_types[] = {
> > +	[XFS_BTNUM_BNO]		= "bnobt",
> > +	[XFS_BTNUM_CNT]		= "cntbt",
> > +	[XFS_BTNUM_RMAP]	= "rmapbt",
> > +	[XFS_BTNUM_BMAP]	= "bmapbt",
> > +	[XFS_BTNUM_INO]		= "inobt",
> > +	[XFS_BTNUM_FINO]	= "finobt",
> > +	[XFS_BTNUM_REFC]	= "refcountbt",
> > +};
> 
> Don't we already have that already defined somewhere?

No...?  I can't find anything.

> > +
> > +/* Format the trace parameters for the tree cursor. */
> > +static inline void
> > +xfs_scrub_btree_format(
> > +	struct xfs_btree_cur		*cur,
> > +	int				level,
> > +	char				*bt_type,
> > +	size_t				type_len,
> > +	char				*bt_ptr,
> > +	size_t				ptr_len,
> > +	xfs_fsblock_t			*fsbno)
> > +{
> > +	char				*type = NULL;
> > +	struct xfs_btree_block		*block;
> > +	struct xfs_buf			*bp;
> 
> hmmm - complex text formatting just for trace point output,
> which are rarely going to be used in production? Not sure how I feel
> about that yet.

I haven't decided if a future version of xfs_scrub will want to capture
check error details from the kernel via ftrace or something.

However, as this function is only called from two places I could just
replace all the string handling bits in favor of directly tracing on
XFS_BTNUM_*/XFS_*_FORK/inode numbers via different tracepoints.

> Also, the function is way too big for being an inline function. I'd
> be tempted to mark it noinline so the compiler doesn't blow out the
> size of the code unnecessarily with automatic inlining of static
> functions.

ok.

> (I haven't reviewed the formatting for sanity).
> 
> > +/* Check for btree corruption. */
> > +bool
> > +xfs_scrub_btree_ok(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_btree_cur		*cur,
> > +	int				level,
> > +	bool				fs_ok,
> > +	const char			*check,
> > +	const char			*func,
> > +	int				line)
> > +{
> > +	char				bt_ptr[24];
> > +	char				bt_type[48];
> > +	xfs_fsblock_t			fsbno;
> > +
> > +	if (fs_ok)
> > +		return fs_ok;
> > +
> > +	sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
> > +	xfs_scrub_btree_format(cur, level, bt_type, 48, bt_ptr, 24, &fsbno);
> 
> Ok, magic numbers for buffer lengths. Please use #defines for these
> with an explanation of why the chosen lengths are sufficient for the
> information they'll be used to hold.
> 
> > +	trace_xfs_scrub_btree_error(cur->bc_mp, bt_type, bt_ptr,
> > +			XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
> > +			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
> > +			check, func, line);
> 
> hmmmm - tracepoints are conditional, but the formatting call isn't.
> Can this formatting be called/run from inside the tracepoint code
> itself?

I don't know of a way to find out if a given set of tracepoint(s) are
enabled.  Fortunately the formatting call only happens if corruption is
detected.

> > +
> > +/*
> > + * Make sure this record is in order and doesn't stray outside of the parent
> > + * keys.
> > + */
> > +STATIC int
> > +xfs_scrub_btree_rec(
> > +	struct xfs_scrub_btree	*bs)
> > +{
> > +	struct xfs_btree_cur	*cur = bs->cur;
> > +	union xfs_btree_rec	*rec;
> > +	union xfs_btree_key	key;
> > +	union xfs_btree_key	hkey;
> > +	union xfs_btree_key	*keyp;
> > +	struct xfs_btree_block	*block;
> > +	struct xfs_btree_block	*keyblock;
> > +	struct xfs_buf		*bp;
> > +
> > +	block = xfs_btree_get_block(cur, 0, &bp);
> > +	rec = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
> > +
> > +	if (bp)
> > +		trace_xfs_scrub_btree_rec(cur->bc_mp,
> > +				XFS_FSB_TO_AGNO(cur->bc_mp,
> > +					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
> > +				XFS_FSB_TO_AGBNO(cur->bc_mp,
> > +					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
> > +				cur->bc_btnum, 0, cur->bc_nlevels,
> > +				cur->bc_ptrs[0]);
> > +	else if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> > +		trace_xfs_scrub_btree_rec(cur->bc_mp,
> > +				XFS_INO_TO_AGNO(cur->bc_mp,
> > +					cur->bc_private.b.ip->i_ino),
> > +				XFS_INO_TO_AGBNO(cur->bc_mp,
> > +					cur->bc_private.b.ip->i_ino),
> > +				cur->bc_btnum, 0, cur->bc_nlevels,
> > +				cur->bc_ptrs[0]);
> > +	else
> > +		trace_xfs_scrub_btree_rec(cur->bc_mp,
> > +				NULLAGNUMBER, NULLAGBLOCK,
> > +				cur->bc_btnum, 0, cur->bc_nlevels,
> > +				cur->bc_ptrs[0]);
> 
> Hmmm - there's more code in the trace calls than there is in the
> scrubbing code. Is this really all necessary? I can see code
> getting changed in future but not the tracepoints, similar to how
> comment updates get missed...

I've found it useful when analyzing the scrub-fuzz xfstests to be able
to pinpoint exactly what record in a btree hit some bug or other.

> > +	/* If this isn't the first record, are they in order? */
> > +	XFS_SCRUB_BTREC_CHECK(bs, bs->firstrec ||
> > +			cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec));
> 
> So, I go look at the macro:
> 
> define XFS_SCRUB_BTREC_CHECK(bs, fs_ok) \
> 	xfs_scrub_btree_ok((bs)->sc, (bs)->cur, 0, (fs_ok), #fs_ok, \
> 			   __func__, __LINE__)
> 
> I find this:
> 
> 	/* If this isn't the first record, are they in order? */
> 	if (!(bs->firstrec &&
> 	     cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec)))
> 		xfs_scrub_btree_error(bs->sc, cur, 0, "Record order", _THIS_IP_)
> 
> A lot easier to read, understand and maintain because I don't have
> to go look at a macro to find out it actually does and what happens
> if the records aren't in order....
> 
> > +/* Check a btree pointer. */
> > +static int
> > +xfs_scrub_btree_ptr(
> > +	struct xfs_scrub_btree		*bs,
> > +	int				level,
> > +	union xfs_btree_ptr		*ptr)
> > +{
> > +	struct xfs_btree_cur		*cur = bs->cur;
> > +	xfs_daddr_t			daddr;
> > +	xfs_daddr_t			eofs;
> > +
> > +	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> > +			level == cur->bc_nlevels) {
> > +		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> > +			XFS_SCRUB_BTKEY_GOTO(bs, level, ptr->l == 0, corrupt);
> > +		} else {
> > +			XFS_SCRUB_BTKEY_GOTO(bs, level, ptr->s == 0, corrupt);
> > +		}
> > +		return 0;
> > +	}
> > +
> > +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> > +		XFS_SCRUB_BTKEY_GOTO(bs, level,
> > +				ptr->l != cpu_to_be64(NULLFSBLOCK), corrupt);
> > +
> > +		daddr = XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
> > +	} else {
> > +		XFS_SCRUB_BTKEY_GOTO(bs, level,
> > +				cur->bc_private.a.agno != NULLAGNUMBER, corrupt);
> > +		XFS_SCRUB_BTKEY_GOTO(bs, level,
> > +				ptr->s != cpu_to_be32(NULLAGBLOCK), corrupt);
> > +
> 
> Need to check the ptr points to an agbno within the AG size.
> 
> Also:
> 	why no tracing on ptr values?
> 	check the ptr points to an agbno within the AG size.
> 	check the ptr points to an agno within agcount
> 
> 
> > +		daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
> > +				be32_to_cpu(ptr->s));
> > +	}
> > +	eofs = XFS_FSB_TO_BB(cur->bc_mp, cur->bc_mp->m_sb.sb_dblocks);
> > +	XFS_SCRUB_BTKEY_GOTO(bs, level, daddr != 0, corrupt);
> > +	XFS_SCRUB_BTKEY_GOTO(bs, level, daddr < eofs, corrupt);
> > +
> > +	return 0;
> > +
> > +corrupt:
> > +	return -EFSCORRUPTED;
> > +}
> > +
> > +/* Check the siblings of a large format btree block. */
> > +STATIC int
> > +xfs_scrub_btree_lblock_check_siblings(
> > +	struct xfs_scrub_btree		*bs,
> > +	struct xfs_btree_block		*block)
> > +{
> > +	struct xfs_btree_block		*pblock;
> > +	struct xfs_buf			*pbp;
> > +	struct xfs_btree_cur		*ncur = NULL;
> > +	union xfs_btree_ptr		*pp;
> > +	xfs_fsblock_t			leftsib;
> > +	xfs_fsblock_t			rightsib;
> > +	xfs_fsblock_t			fsbno;
> > +	int				level;
> > +	int				success;
> > +	int				error = 0;
> > +
> > +	leftsib = be64_to_cpu(block->bb_u.l.bb_leftsib);
> > +	rightsib = be64_to_cpu(block->bb_u.l.bb_rightsib);
> > +	level = xfs_btree_get_level(block);
> > +
> > +	/* Root block should never have siblings. */
> > +	if (level == bs->cur->bc_nlevels - 1) {
> > +		XFS_SCRUB_BTKEY_CHECK(bs, level, leftsib == NULLFSBLOCK);
> > +		XFS_SCRUB_BTKEY_CHECK(bs, level, rightsib == NULLFSBLOCK);
> > +		return error;
> > +	}
> 
> This is where the macros force us into silly patterns and blow out
> the code size.
> 
> 	if (level == bs->cur->bc_nlevels - 1 &&
> 	    (leftsib != NULLFSBLOCK || rightsib != NULLFSBLOCK) {
> 		/* error trace call */
> 		return error;
> 	}

We're also losing information here.  With the previous code you can tell
between leftsib and rightsib which one is corrupt, whereas with the
suggested replacement you can only tell that at least one of them is
broken.

I want to avoid the situation where scrub flags a corruption, the user
runs ftrace to give us __return_address, and we go looking for that only
to find that it points to a line of code that tests two different
fields.

> > +	/* Does the left sibling match the parent level left block? */
> > +	if (leftsib != NULLFSBLOCK) {
> > +		error = xfs_btree_dup_cursor(bs->cur, &ncur);
> > +		if (error)
> > +			return error;
> > +		error = xfs_btree_decrement(ncur, level + 1, &success);
> > +		XFS_SCRUB_BTKEY_OP_ERROR_GOTO(bs, level + 1, &error, out_cur);
> 
> Hmmm - if I read that right, there's a goto out_cur on error hidden
> in this macro....

No more hidden than XFS_WANT_CORRUPTED_GOTO. :)

But ok, I can rework these as:

if (!xfs_scrub_btree_op_ok(bs->sc, bs->cur, level + 1, &error))
	goto out_cur;

> > +		XFS_SCRUB_BTKEY_GOTO(bs, level, success, out_cur);
> > +
> > +		pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
> > +		pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
> > +		if (!xfs_scrub_btree_ptr(bs, level + 1, pp)) {
> > +			fsbno = be64_to_cpu(pp->l);
> > +			XFS_SCRUB_BTKEY_CHECK(bs, level, fsbno == leftsib);
> > +		}
> > +
> > +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> > +		ncur = NULL;
> > +	}
> > +
> > +	/* Does the right sibling match the parent level right block? */
> > +	if (!error && rightsib != NULLFSBLOCK) {
> 
> So when would error ever be non-zero here?
> 
> This is one of the reasons I really don't like all the macros in
> this code - it unnecessarily obfuscates the checks being done and
> the code flow....

It's unnecessary, you're right.

> > +/* Check the siblings of a small format btree block. */
> > +STATIC int
> > +xfs_scrub_btree_sblock_check_siblings(
> > +	struct xfs_scrub_btree		*bs,
> > +	struct xfs_btree_block		*block)
> > +{
> > +	struct xfs_btree_block		*pblock;
> > +	struct xfs_buf			*pbp;
> > +	struct xfs_btree_cur		*ncur = NULL;
> > +	union xfs_btree_ptr		*pp;
> > +	xfs_agblock_t			leftsib;
> > +	xfs_agblock_t			rightsib;
> > +	xfs_agblock_t			agbno;
> > +	int				level;
> > +	int				success;
> > +	int				error = 0;
> > +
> > +	leftsib = be32_to_cpu(block->bb_u.s.bb_leftsib);
> > +	rightsib = be32_to_cpu(block->bb_u.s.bb_rightsib);
> > +	level = xfs_btree_get_level(block);
> > +
> > +	/* Root block should never have siblings. */
> > +	if (level == bs->cur->bc_nlevels - 1) {
> > +		XFS_SCRUB_BTKEY_CHECK(bs, level, leftsib == NULLAGBLOCK);
> > +		XFS_SCRUB_BTKEY_CHECK(bs, level, rightsib == NULLAGBLOCK);
> > +		return error;
> > +	}
> > +
> > +	/* Does the left sibling match the parent level left block? */
> > +	if (leftsib != NULLAGBLOCK) {
> > +		error = xfs_btree_dup_cursor(bs->cur, &ncur);
> > +		if (error)
> > +			return error;
> > +		error = xfs_btree_decrement(ncur, level + 1, &success);
> > +		XFS_SCRUB_BTKEY_OP_ERROR_GOTO(bs, level + 1, &error, out_cur);
> > +		XFS_SCRUB_BTKEY_GOTO(bs, level, success, verify_rightsib);
> 
> Why is this different to the lblock checks?
> 
> FWIW, this is one of the reasons for abstracting the sblock/lblock
> code as much as possible - the core operations should be identical,
> so apart from header decode/encode operations, the rest of the code
> should be shared...

Yeah.

> > +
> > +		pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
> > +		pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
> > +		if (!xfs_scrub_btree_ptr(bs, level + 1, pp)) {
> > +			agbno = be32_to_cpu(pp->s);
> > +			XFS_SCRUB_BTKEY_CHECK(bs, level, agbno == leftsib);
> > +		}
> > +
> > +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> > +		ncur = NULL;
> > +	}
> > +
> > +verify_rightsib:
> > +	if (ncur) {
> > +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> > +		ncur = NULL;
> > +	}
> > +
> > +	/* Does the right sibling match the parent level right block? */
> > +	if (rightsib != NULLAGBLOCK) {
> 
> No "if (!error ...) check here - I'm thinking there's some factoring
> needed here to reduce the code duplication going on here...

Ok, will do.  These two functions can be rewritten as a single function
that uses cur->bc_ops->diff_two_keys.  Then we discard
bs->check_siblings_fn.

> > +/*
> > + * Visit all nodes and leaves of a btree.  Check that all pointers and
> > + * records are in order, that the keys reflect the records, and use a callback
> > + * so that the caller can verify individual records.  The callback is the same
> > + * as the one for xfs_btree_query_range, so therefore this function also
> > + * returns XFS_BTREE_QUERY_RANGE_ABORT, zero, or a negative error code.
> > + */
> > +int
> > +xfs_scrub_btree(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_btree_cur		*cur,
> > +	xfs_scrub_btree_rec_fn		scrub_fn,
> > +	struct xfs_owner_info		*oinfo,
> > +	void				*private)
> > +{
> > +	struct xfs_scrub_btree		bs = {0};
> > +	union xfs_btree_ptr		ptr;
> > +	union xfs_btree_ptr		*pp;
> > +	union xfs_btree_rec		*recp;
> > +	struct xfs_btree_block		*block;
> > +	int				level;
> > +	struct xfs_buf			*bp;
> > +	int				i;
> > +	int				error = 0;
> > +
> > +	/* Finish filling out the scrub state */
> 
> 	/* Initialise the scrub state */
> 
> > +	bs.cur = cur;
> > +	bs.scrub_rec = scrub_fn;
> > +	bs.oinfo = oinfo;
> > +	bs.firstrec = true;
> > +	bs.private = private;
> > +	bs.sc = sc;
> > +	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
> > +		bs.firstkey[i] = true;
> > +	INIT_LIST_HEAD(&bs.to_check);
> > +
> > +	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> > +		bs.check_siblings_fn = xfs_scrub_btree_lblock_check_siblings;
> > +	else
> > +		bs.check_siblings_fn = xfs_scrub_btree_sblock_check_siblings;
> 
> I'm thinking now that maybe a "get sibling from block" is what is
> necessary here, so there can be a shared check function....
> 
> > +	/* Don't try to check a tree with a height we can't handle. */
> > +	XFS_SCRUB_BTREC_GOTO(&bs, cur->bc_nlevels > 0, out_badcursor);
> > +	XFS_SCRUB_BTREC_GOTO(&bs, cur->bc_nlevels <= XFS_BTREE_MAXLEVELS,
> > +			out_badcursor);
> 
> More single checks that are doubled up...
> 
> ....
> > +out:
> > +	/*
> > +	 * If we don't end this function with the cursor pointing at a record
> > +	 * block, a subsequent non-error cursor deletion will not release
> > +	 * node-level buffers, causing a buffer leak.  This is quite possible
> > +	 * with a zero-results scrubbing run, so release the buffers if we
> > +	 * aren't pointing at a record.
> > +	 */
> > +	if (cur->bc_bufs[0] == NULL) {
> > +		for (i = 0; i < cur->bc_nlevels; i++) {
> > +			if (cur->bc_bufs[i]) {
> > +				xfs_trans_brelse(cur->bc_tp, cur->bc_bufs[i]);
> > +				cur->bc_bufs[i] = NULL;
> > +				cur->bc_ptrs[i] = 0;
> > +				cur->bc_ra[i] = 0;
> > +			}
> > +		}
> > +	}
> 
> I think cursor deletion should be made to handle this case, rather
> than special casing it here....

Yeah.  I think it's safe (now) because we have xfs_scrub_ag_btcur_free
which tears down all the cursors in BTREE_ERROR mode.

> > +struct xfs_scrub_btree;
> > +typedef int (*xfs_scrub_btree_rec_fn)(
> > +	struct xfs_scrub_btree	*bs,
> > +	union xfs_btree_rec	*rec);
> > +
> > +struct xfs_scrub_btree {
> > +	/* caller-provided scrub state */
> > +	struct xfs_scrub_context	*sc;
> > +	struct xfs_btree_cur		*cur;
> > +	xfs_scrub_btree_rec_fn		scrub_rec;
> > +	struct xfs_owner_info		*oinfo;
> > +	void				*private;
> > +
> > +	/* internal scrub state */
> > +	union xfs_btree_rec		lastrec;
> > +	bool				firstrec;
> > +	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
> > +	bool				firstkey[XFS_BTREE_MAXLEVELS];
> > +	struct list_head		to_check;
> > +	int				(*check_siblings_fn)(
> > +						struct xfs_scrub_btree *,
> > +						struct xfs_btree_block *);
> > +};
> 
> This looks like maybe another ops style structure should be used. We've
> got a xfs_scrub_btree_rec_fn() and check_siblings_fn() operations -
> maybe these should be pushed into the generic libxfs btree ops
> vectors?
> 
> > +int xfs_scrub_btree(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
> > +		    xfs_scrub_btree_rec_fn scrub_fn,
> > +		    struct xfs_owner_info *oinfo, void *private);
> > +
> > +#endif /* __XFS_REPAIR_BTREE_H__ */
> > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > index 6931793..331aa14 100644
> > --- a/fs/xfs/scrub/common.c
> > +++ b/fs/xfs/scrub/common.c
> > @@ -43,6 +43,7 @@
> >  #include "xfs_rmap_btree.h"
> >  #include "scrub/xfs_scrub.h"
> >  #include "scrub/common.h"
> > +#include "scrub/btree.h"
> >  
> >  /*
> >   * Online Scrub and Repair
> > @@ -367,6 +368,172 @@ xfs_scrub_incomplete(
> >  	return fs_ok;
> >  }
> >  
> > +/* AG scrubbing */
> > +
> 
> All this from here down doesn't seem related to scrubbing a btree?
> It's infrastructure for scanning AGs, but I don't see where it is
> called from - it looks unused at this point. I think it should be
> separated from the btree validation into it's own patchset and put
> before the individual btree verification code...
> 
> I haven't really looked at this AG scrubbing code in depth because I
> can't tell how it fits into the code that is supposed to call it
> yet. I've read it, but without knowing how it's called I can't tell
> if the abstractions are just convoluted or whether they are
> necessary due to the infrastructure eventually ending up with
> multiple different call sites for some of the functions...

Lock AGI/AGF/AGFL, initialize cursors for all AG btree types, pick the
cursor we want and scan the AG, and use the other btree cursors to
cross-reference each record we see during the scan.

I regret now deferring the posting of the cross-referencing patches,
because some of the overdone bits in this patchset are done to avoid
code churn when that part gets added.  That'll make it (I hope) a little
more obvious why some things are the way they are.

--D

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
