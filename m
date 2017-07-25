Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44500 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755717AbdGYAjt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 20:39:49 -0400
Date: Mon, 24 Jul 2017 17:39:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/22] xfs: generic functions to scrub metadata and btrees
Message-ID: <20170725003944.GM4352@magnolia>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061193407.14732.9644386359653380682.stgit@magnolia>
 <20170724010549.GB17762@dastard>
 <20170724215810.GJ4352@magnolia>
 <20170724231542.GF17762@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724231542.GF17762@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 25, 2017 at 09:15:42AM +1000, Dave Chinner wrote:
> On Mon, Jul 24, 2017 at 02:58:10PM -0700, Darrick J. Wong wrote:
> > On Mon, Jul 24, 2017 at 11:05:49AM +1000, Dave Chinner wrote:
> > > > +	struct xfs_btree_cur		*cur,
> > > > +	int				level,
> > > > +	bool				fs_ok,
> > > > +	const char			*check,
> > > > +	const char			*func,
> > > > +	int				line)
> > > > +{
> > > > +	char				bt_ptr[24];
> > > > +	char				bt_type[48];
> > > > +	xfs_fsblock_t			fsbno;
> > > > +
> > > > +	if (fs_ok)
> > > > +		return fs_ok;
> > > > +
> > > > +	sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
> > > > +	xfs_scrub_btree_format(cur, level, bt_type, 48, bt_ptr, 24, &fsbno);
> > > 
> > > Ok, magic numbers for buffer lengths. Please use #defines for these
> > > with an explanation of why the chosen lengths are sufficient for the
> > > information they'll be used to hold.
> > > 
> > > > +	trace_xfs_scrub_btree_error(cur->bc_mp, bt_type, bt_ptr,
> > > > +			XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
> > > > +			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
> > > > +			check, func, line);
> > > 
> > > hmmmm - tracepoints are conditional, but the formatting call isn't.
> > > Can this formatting be called/run from inside the tracepoint code
> > > itself?
> > 
> > I don't know of a way to find out if a given set of tracepoint(s) are
> > enabled.  Fortunately the formatting call only happens if corruption is
> > detected.
> 
> I was thinking more that the function is called from within the
> tracepoint code itself. Tracepoints can have code embedded in
> them...

Oh.  I'll look into that.

> > 
> > > > +
> > > > +/*
> > > > + * Make sure this record is in order and doesn't stray outside of the parent
> > > > + * keys.
> > > > + */
> > > > +STATIC int
> > > > +xfs_scrub_btree_rec(
> > > > +	struct xfs_scrub_btree	*bs)
> > > > +{
> > > > +	struct xfs_btree_cur	*cur = bs->cur;
> > > > +	union xfs_btree_rec	*rec;
> > > > +	union xfs_btree_key	key;
> > > > +	union xfs_btree_key	hkey;
> > > > +	union xfs_btree_key	*keyp;
> > > > +	struct xfs_btree_block	*block;
> > > > +	struct xfs_btree_block	*keyblock;
> > > > +	struct xfs_buf		*bp;
> > > > +
> > > > +	block = xfs_btree_get_block(cur, 0, &bp);
> > > > +	rec = xfs_btree_rec_addr(cur, cur->bc_ptrs[0], block);
> > > > +
> > > > +	if (bp)
> > > > +		trace_xfs_scrub_btree_rec(cur->bc_mp,
> > > > +				XFS_FSB_TO_AGNO(cur->bc_mp,
> > > > +					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
> > > > +				XFS_FSB_TO_AGBNO(cur->bc_mp,
> > > > +					XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn)),
> > > > +				cur->bc_btnum, 0, cur->bc_nlevels,
> > > > +				cur->bc_ptrs[0]);
> > > > +	else if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> > > > +		trace_xfs_scrub_btree_rec(cur->bc_mp,
> > > > +				XFS_INO_TO_AGNO(cur->bc_mp,
> > > > +					cur->bc_private.b.ip->i_ino),
> > > > +				XFS_INO_TO_AGBNO(cur->bc_mp,
> > > > +					cur->bc_private.b.ip->i_ino),
> > > > +				cur->bc_btnum, 0, cur->bc_nlevels,
> > > > +				cur->bc_ptrs[0]);
> > > > +	else
> > > > +		trace_xfs_scrub_btree_rec(cur->bc_mp,
> > > > +				NULLAGNUMBER, NULLAGBLOCK,
> > > > +				cur->bc_btnum, 0, cur->bc_nlevels,
> > > > +				cur->bc_ptrs[0]);
> > > 
> > > Hmmm - there's more code in the trace calls than there is in the
> > > scrubbing code. Is this really all necessary? I can see code
> > > getting changed in future but not the tracepoints, similar to how
> > > comment updates get missed...
> > 
> > I've found it useful when analyzing the scrub-fuzz xfstests to be able
> > to pinpoint exactly what record in a btree hit some bug or other.
> 
> Sure, I'm not questioning where it has some use, more just pondering
> the complexity required to emit them and whether there's a better
> way. I mean, the onl difference is the agno/agbno pair being traced,
> so wouldn't it make more sense to trace an opaque 64 bit number here
> and do:
> 
> 	if (bp)
> 		num = bp->b_bn;
> 	else if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> 		num = ip->i_ino;
> 	else
> 		num = NULLFSBLOCK;
> 	trace_xfs_scrub_btree_rec(cur->bc_mp, num, cur->bc_btnum, 0,
> 				  cur->bc_nlevels, cur->bc_ptrs[0]);
> 
> That's much simpler and easier to maintain, but provides the same
> info. It's also only one trace event callout, so the code size
> should go down as well...

<nod>

> > > > +	leftsib = be64_to_cpu(block->bb_u.l.bb_leftsib);
> > > > +	rightsib = be64_to_cpu(block->bb_u.l.bb_rightsib);
> > > > +	level = xfs_btree_get_level(block);
> > > > +
> > > > +	/* Root block should never have siblings. */
> > > > +	if (level == bs->cur->bc_nlevels - 1) {
> > > > +		XFS_SCRUB_BTKEY_CHECK(bs, level, leftsib == NULLFSBLOCK);
> > > > +		XFS_SCRUB_BTKEY_CHECK(bs, level, rightsib == NULLFSBLOCK);
> > > > +		return error;
> > > > +	}
> > > 
> > > This is where the macros force us into silly patterns and blow out
> > > the code size.
> > > 
> > > 	if (level == bs->cur->bc_nlevels - 1 &&
> > > 	    (leftsib != NULLFSBLOCK || rightsib != NULLFSBLOCK) {
> > > 		/* error trace call */
> > > 		return error;
> > > 	}
> > 
> > We're also losing information here.  With the previous code you can tell
> > between leftsib and rightsib which one is corrupt, whereas with the
> > suggested replacement you can only tell that at least one of them is
> > broken.
> 
> Sure, but that's mostly irrelevant detail because...
> 
> > I want to avoid the situation where scrub flags a corruption, the user
> > runs ftrace to give us __return_address, and we go looking for that only
> > to find that it points to a line of code that tests two different
> > fields.
> 
> ... the fact is you have to go look at the root block header that is
> corrupt to analyse the extent of the corruption and eventually
> repair it. When it comes to analysing a corruption, you don't just
> look at the one field that has been flagged - you look at all the
> metadata in the block to determine the extent of the corruption.
> 
> If you know a sibling pointer in a root block is corrupt, then the
> moment you look at the block header it's *obvious* which sibling
> pointer is corrupt. i.e. the one that is not NULLFSBLOCK. It really
> doesn't matter what is reported as the error from scrubbing because
> the corrupted items are trivially observable.
> 
> It's all well and good to scan every piece of metadata for validity,
> but that doesn't mean we shouldn't think about what makes sense to
> report/log. It's going to be easy to drown the logs in corruption
> reports and make it impossible to find the needle that first caused
> it.
> 
> All I'm saying is blind verbosity like this is an indication that we
> haven't thought about how to group or classify corruptions
> sufficiently. Yes, we need to be able to detect all corrupted
> fields, but we need to recognise that many corruptions are
> essentially the same problem distributed across multiple fields and
> they'll all be repaired by a single repair action.
> 
> In this case, it doesn't matter if it is left or right sibling corruption
> because the analysis/repair work we need to do to correct either the
> left or right pointer is the same. i.e. we need to walk and validate
> the entire chain from both ends to repair a single bad pointer.
> Hence it doesn't matter if the left or right sibling is bad, the
> action we need to take to repair it is the same because we don't
> know if we're sitting on a wholly disconnected part of the chain
> (i.e. nasty level of tree corruption) or whether just that link got
> stomped on. i.e. bad sibling is an indication that both siblings may
> be invalid, not just the one we detected as bad....
> 
> SO, yeah, "sibling corruption" means we need to check the entire
> sibling chain across all blocks in the btree level, not just in the
> direction of the bad pointer.

On some level it doesn't matter at all, since we return a single bit to
userspace, and repair just nukes the whole data structure and rebuilds
it from scratch...

...so I can go combine adjacent checks when I demacro the code; should
we decide for some reason to hurl floods of trace data back to userspace
we can always re-separate them.

> > > > +	/* Does the left sibling match the parent level left block? */
> > > > +	if (leftsib != NULLFSBLOCK) {
> > > > +		error = xfs_btree_dup_cursor(bs->cur, &ncur);
> > > > +		if (error)
> > > > +			return error;
> > > > +		error = xfs_btree_decrement(ncur, level + 1, &success);
> > > > +		XFS_SCRUB_BTKEY_OP_ERROR_GOTO(bs, level + 1, &error, out_cur);
> > > 
> > > Hmmm - if I read that right, there's a goto out_cur on error hidden
> > > in this macro....
> > 
> > No more hidden than XFS_WANT_CORRUPTED_GOTO. :)
> 
> Right, but I've been wanting to get rid of those XFS_WANT_CORRUPTED
> macros for a long, long time... :/
> 
> > > > +
> > > > +		pblock = xfs_btree_get_block(ncur, level + 1, &pbp);
> > > > +		pp = xfs_btree_ptr_addr(ncur, ncur->bc_ptrs[level + 1], pblock);
> > > > +		if (!xfs_scrub_btree_ptr(bs, level + 1, pp)) {
> > > > +			agbno = be32_to_cpu(pp->s);
> > > > +			XFS_SCRUB_BTKEY_CHECK(bs, level, agbno == leftsib);

FWIW I forgot to mention in my reply that the key pointer scrubber
doesn't actually have to check if the pointer is non-null but valid,
because at some point during scrub we'll try to use the pointer and if
it points somewhere bad we'll notice when we either an io error or a
block that doesn't match the contents we want.

> > > > +		}
> > > > +
> > > > +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> > > > +		ncur = NULL;
> > > > +	}
> > > > +
> > > > +verify_rightsib:
> > > > +	if (ncur) {
> > > > +		xfs_btree_del_cursor(ncur, XFS_BTREE_ERROR);
> > > > +		ncur = NULL;
> > > > +	}
> > > > +
> > > > +	/* Does the right sibling match the parent level right block? */
> > > > +	if (rightsib != NULLAGBLOCK) {
> > > 
> > > No "if (!error ...) check here - I'm thinking there's some factoring
> > > needed here to reduce the code duplication going on here...
> > 
> > Ok, will do.  These two functions can be rewritten as a single function
> > that uses cur->bc_ops->diff_two_keys.  Then we discard
> > bs->check_siblings_fn.
> 
> Excellent!
> 
> > > > +/* AG scrubbing */
> > > > +
> > > 
> > > All this from here down doesn't seem related to scrubbing a btree?
> > > It's infrastructure for scanning AGs, but I don't see where it is
> > > called from - it looks unused at this point. I think it should be
> > > separated from the btree validation into it's own patchset and put
> > > before the individual btree verification code...
> > > 
> > > I haven't really looked at this AG scrubbing code in depth because I
> > > can't tell how it fits into the code that is supposed to call it
> > > yet. I've read it, but without knowing how it's called I can't tell
> > > if the abstractions are just convoluted or whether they are
> > > necessary due to the infrastructure eventually ending up with
> > > multiple different call sites for some of the functions...
> > 
> > Lock AGI/AGF/AGFL, initialize cursors for all AG btree types, pick the
> > cursor we want and scan the AG, and use the other btree cursors to
> > cross-reference each record we see during the scan.
> > 
> > I regret now deferring the posting of the cross-referencing patches,
> > because some of the overdone bits in this patchset are done to avoid
> > code churn when that part gets added.  That'll make it (I hope) a little
> > more obvious why some things are the way they are.
> 
> Yeah, it's not easy to split large chunks of work up and maintain a
> split on a moving codebase.  I don't want you to split these patches
> up into fine grained patches because that's just unmanagable, but I
> think it's worthwhile to do split out the bits that don't obviously
> appear to be related.

Yeah, I might have overreacted some; looking at the tracepoint, helper,
and btree scrub patches I think I only have to add a handful of patches.

> For this case, I don't think the follow on patch series would make
> any difference to my comments here, because going from btree
> verfication code to AG setup infrastructure in a single patch is
> quite a shift in context. Patch splits on context switch boundaries
> really do help reviewing large chunks of new code :P

Yeah, sorry about that.  I got confused by my own code and thought we
were still talking about the helpers patch, not the btree scrub
framework patch.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
