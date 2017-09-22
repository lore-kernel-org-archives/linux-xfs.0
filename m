Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24103 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752125AbdIVUOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 16:14:45 -0400
Date: Fri, 22 Sep 2017 13:14:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/27] xfs: scrub the shape of a metadata btree
Message-ID: <20170922201439.GL5728@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
 <150595310675.18473.3213689888370264086.stgit@magnolia>
 <20170922152233.GA63820@bfoster.bfoster>
 <20170922172207.GI5728@magnolia>
 <20170922191319.GC63820@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922191319.GC63820@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 22, 2017 at 03:13:20PM -0400, Brian Foster wrote:
> On Fri, Sep 22, 2017 at 10:22:07AM -0700, Darrick J. Wong wrote:
> > On Fri, Sep 22, 2017 at 11:22:33AM -0400, Brian Foster wrote:
> > > On Wed, Sep 20, 2017 at 05:18:26PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Create a function that can check the shape of a btree -- each block
> > > > passes basic inspection and all the pointers look ok.  In the next patch
> > > > we'll add the ability to check the actual keys and records stored within
> > > > the btree.  Add some helper functions so that we report detailed scrub
> > > > errors in a uniform manner in dmesg.  These are helper functions for
> > > > subsequent patches.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_btree.c |   16 +++
> > > >  fs/xfs/libxfs/xfs_btree.h |    7 +
> > > >  fs/xfs/scrub/btree.c      |  236 +++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/scrub/common.h     |   13 ++
> > > >  4 files changed, 268 insertions(+), 4 deletions(-)
> > > > 
> > > > 
> > > ...
> > > > diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> > > > index adf5d09..a9c2bf3 100644
> > > > --- a/fs/xfs/scrub/btree.c
> > > > +++ b/fs/xfs/scrub/btree.c
> > > ...
> > > > @@ -109,6 +255,92 @@ xfs_scrub_btree(
> > > >  	struct xfs_owner_info		*oinfo,
> > > >  	void				*private)
> > > >  {
> > > > -	xfs_scrub_btree_op_ok(sc, cur, 0, false);
> > > > -	return -EOPNOTSUPP;
> > > > +	struct xfs_scrub_btree		bs = {0};
> > > > +	union xfs_btree_ptr		ptr;
> > > > +	union xfs_btree_ptr		*pp;
> > > > +	struct xfs_btree_block		*block;
> > > > +	int				level;
> > > > +	struct xfs_buf			*bp;
> > > > +	int				i;
> > > > +	int				error = 0;
> > > > +
> > > > +	/* Initialize scrub state */
> > > > +	bs.cur = cur;
> > > > +	bs.scrub_rec = scrub_fn;
> > > > +	bs.oinfo = oinfo;
> > > > +	bs.firstrec = true;
> > > > +	bs.private = private;
> > > > +	bs.sc = sc;
> > > > +	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
> > > > +		bs.firstkey[i] = true;
> > > > +	INIT_LIST_HEAD(&bs.to_check);
> > > > +
> > > > +	/* Don't try to check a tree with a height we can't handle. */
> > > > +	if (!xfs_scrub_btree_check_ok(sc, cur, 0, cur->bc_nlevels > 0 &&
> > > > +			cur->bc_nlevels <= XFS_BTREE_MAXLEVELS))
> > > > +		goto out;
> > > > +
> > > > +	/* Make sure the root isn't in the superblock. */
> > > > +	if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)) {
> > > > +		cur->bc_ops->init_ptr_from_cur(cur, &ptr);
> > > > +		error = xfs_scrub_btree_ptr(&bs, cur->bc_nlevels, &ptr);
> > > > +		if (!xfs_scrub_btree_op_ok(sc, cur, cur->bc_nlevels - 1, &error))
> > > > +			goto out;
> > > > +	}
> > > > +
> > > 
> > > This is kind of in line with Dave's comments on the previous patch that
> > > introduce some of these helpers. I just glanced over them for now
> > > because I didn't have enough context to grok the error processing.
> > 
> > (That's been a struggle with this patchset -- some of these helpers
> > don't get used until much further in the patchset.  I could have
> > sprinkled them into whichever patch uses them first, but now the hunks
> > are all over the series, I'd have to do more dependency tracking to make
> > sure bisect continues to work, and the frequency of auto-merge failures
> > as I push and pop the stack increase dramatically.)
> > 
> > > FWIW, the btree_op_ok()/btree_check_ok() stuff kind of makes my eyes
> > > cross a bit because I can't easily see the logic checks or distinguish
> > > between those and error code checks. This is also a bit confusing
> > > because it looks like we overload return codes for various things. E.g.,
> > > we generate -EFSCORRUPTED in some cases just so the caller can set the
> > > state on the context and clear it, but then we still use the fact that
> > > an error _was_ set to control the flow of the task via the op_ok()
> > > return value. This makes some of the code flow/decision making logic
> > > hard to follow, particularly since some of that state looks like it can
> > > be lost.
> > > 
> > > Case in point.. what happens if say xfs_btree_increment() returns
> > > -EFSCORRUPTED back to xfs_scrub_btree_block_check_sibling()? It looks to
> > > me that the latter calls btree_op_ok() to set the corrupt state, clears
> > > the error code and skips out appropriately.
> > > xfs_scrub_btree_block_check_sibling() now returns zero, which
> > > potentially bubbles up to xfs_scrub_btree() where we check the error
> > > code again. Is it expected that error == 0 here? What is supposed to
> > > happen here?
> > 
> > Yes, error == 0 is intended here.  Given a block B, we want to check
> > that B->rightsib->leftsib (if the sibling exists at all) point back to
> > B.  If the btree_increment operation returns EFSCORRUPTED we don't know
> > if that's because the B->rightsib points at something it's not supposed
> > to, or if B->rightsib points at a btree block, but that sibling block is
> > corrupt.  Therefore we set the corrupt flag and bubble error == 0 up the
> > call stack so that we can check the other records in the btree.   This
> > enables those following with ftrace to see everything that scrub thinks
> > is wrong with that piece of metadata.
> > 
> > IOWs, we only use error code returns for "runtime error, abort the whole
> > operation immediately".
> > 
> 
> Ok, so we intentionally have to consume the error here because it
> doesn't necessarily reflect the corrupted state of the scrubbed block.

Not quite -- while we're examining blocks or otherwise operating on the
btree we've been told to scrub, we always want to consume an
EFSCORRUPTED error (and set the CORRUPT flag) because we always want to
try to check everything, even if we find problems midway through a scan.

This is similar to how gcc will keep processing past the first error to
try to report everything that's wrong in the source file instead of
bailing out at the first error like it used to do.

> So IIUC, overloading return codes as such means error handling must
> either return -EFSCORRUPTED for the current object being corrupted,

We /never/ return EFSCORRUPTED to userspace, because we have the
OFLAG_CORRUPT flag to indicate any kind of corruption anywhere in this
data structure we're checking.

Let's say that a 2-level btree looks like this:

           B0
            |
+-----+-----+--------+-----+----------------+-------------------+
|     |     |        |     |                |                   |
|     |     |        V     |                |                   |
|     |     |  someblock   |                |                   |
|     |     |              |                |                   |
V     V     V              V                V                   V
B1 -> B2 -> B3 ----> B4 -> B5 (badmagic) -> B6 (bad records) -> B7

Here we have a bad pointer in B0 that should point to B4 but now points
to something that was never part of B.  In B6 we have some incorrect
records, and in B5 we have a bad checksum.

First we visit B0.  Nothing obviously wrong there, so we proceed with
the depth-first search of B.  We examine B1 and B2 via pointer[1] and
pointer[2], respectively, and find nothing wrong.  Now we try
pointer[3], which we follow to B3.

Then we get to B3's sibling pointer check.  Leftsib is ok, but when we
move on to checking rightsib, the xfs_btree_increment returns EFSBADCRC
because the pointer[4] in B0 points to a block that isn't in the btree.
Here we want to consume the EFSBADCRC, so we set OFLAG_CORRUPT and
continue walking the tree.

Next we try to walk pointer[4] in B0 and again hit a EFSBADCRC error.
Again we set OFLAG_CORRUPT and continue walking the tree.

Then we try to walk pointer[5] in B0 and encounter B5.  The CRC matches,
but the magic number is wrong, so we hit EFSCORRUPTED.  The block is
toast, but we still need to keep walking.

Now we walk pointer[6] and encounter B6.  We encounter no operational
errors but then we see some incorrect records so we set OFLAG_CORRUPT
(it's still set) and continue.

Finally we get to pointer[7], where everything is fine again.  If we
haven't encountered any operational problems like ENOMEM then we'll
return to userspace with OFLAG_CORRUPT set, a return value of zero.

The ftrace buffer will have a report about the operational error trying
to walk down pointer[4], another one about B5, record check failures
from B6.

(If instead we run out of memory checking B7 then we'll return the
ENOMEM to userspace.)

> return some other error for an error in the infrastructure, or clear any
> -EFSCORRUPTED error generated by checks that don't necessarily mean the
> current object is corrupted (or too much so to interrupt processing).
> 
> > > I'm wondering if this could all be made more clear by trying to
> > > explicitly separate out operational errors, scrub failures and whatever
> > > we want to call the logic that clears an -EFSCORRUPTED/-EFSBADCRC error
> > > code but still indicates something happened. :P
> > > 
> > > For starters, rather than wrap every logic check with btree_op_check(),
> > > could we use explicit logic and let each function update the context
> > > based on problems it found? For example, something like the following is
> > > much more easy to read for me than the associated logic above:
> > > 
> > > 	/* Don't try to check a tree with a height we can't handle. */
> > > 	if (!(cur->bc_nlevels > 0 &&
> > > 	      cur->bc_nlevels <= XFS_BTREE_MAXLEVELS)) {
> > > 		xfs_scrub_sc_corrupt(...);
> > > 		goto out;
> > > 	}
> > > 
> > > And of course the context update calls could be factored into an
> > > out_corrupt label or something where appropriate.
> > 
> > Yes, that could be done.
> > 
> > > Beyond that, where we need to identify a bit of metadata is busted to
> > > perhaps do something like skip it but not abort (as we may have filtered
> > > out an -EFSCORRUPTED) return code, could we pass a flag down a
> > > particular callchain (i.e., think 'bool *bad' or 'int *stat' a la the
> > > core btree code)? Then we can still transfer that state back up the
> > > chain and the caller(s) can distinguish operational errors from "this
> > > thing is corrupted, act accordingly," regardless of how the corruption
> > > was detected.
> > 
> > So far I haven't needed to distinguish between "no problems encountered"
> > and "this callchain hit a verifier error so we just set _CORRUPT" --
> > scrub always keeps going until it runs out of things to check.
> > 
> 
> Ok. This is partly speculation on the above (trying to wrap my head
> around the error consumption bits as is) and partly to try and see if we
> can make the flow more readable.
> 
> In my mind, this is more clear if return codes are reserved for
> operational/infrastructure errors

Yes, this is true.

> and the corrupted state of a piece of metadata is its own state.

Also true -- this is OFLAG_CORRUPT.

> Using the example above, any -EFSCORRUPTED errors from external calls
> (xfs_btree_check_block(), xfs_btree_increment(), etc.) would always be
> cleared and replaced with a return 0.

<nod>

> The difference between those is the former (check_block()) error sets
> a 'bad = true' state on the currently scrubbed bit of metadata and the
> latter (check_sibling()) does not.

Nothing in the scrub code needs to track badness at that fine-grained of
a level.  When we get to the repair patches you'll see that any kind of
error triggers a complete rebuild of the btree index, with absolutely no
attempt to touch the existing (inconsistent) btree.

We /could/ return to userspace as soon as we hit the first EFSCORRUPTED
or failed check, TBH.

> The latter can of course still set the global corrupted state on the
> context to track that there is an inconsistency in the fs. Thoughts?

I've wondered if it might be clearer if we did something like:

int error;
bool bailout;

error = xfs_btree_increment(...);
bailout = xfs_scrub_op_error(..., &error);
if (bailout)
	return error;

if (ptr->field == BADVAL) {
	xfs_scrub_corrupt(...);
	return error;
}

<shrug>

--D

> 
> Brian
> 
> > (Maybe I'm missing something?)
> > 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > > +	/* Load the root of the btree. */
> > > > +	level = cur->bc_nlevels - 1;
> > > > +	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
> > > > +	error = xfs_scrub_btree_block(&bs, level, &ptr, &block, &bp);
> > > > +	if (!xfs_scrub_btree_op_ok(sc, cur, cur->bc_nlevels - 1, &error))
> > > > +		goto out;
> > > > +
> > > > +	cur->bc_ptrs[level] = 1;
> > > > +
> > > > +	while (level < cur->bc_nlevels) {
> > > > +		block = xfs_btree_get_block(cur, level, &bp);
> > > > +
> > > > +		if (level == 0) {
> > > > +			/* End of leaf, pop back towards the root. */
> > > > +			if (cur->bc_ptrs[level] >
> > > > +			    be16_to_cpu(block->bb_numrecs)) {
> > > > +				if (level < cur->bc_nlevels - 1)
> > > > +					cur->bc_ptrs[level + 1]++;
> > > > +				level++;
> > > > +				continue;
> > > > +			}
> > > > +
> > > > +			if (xfs_scrub_should_terminate(&error))
> > > > +				break;
> > > > +
> > > > +			cur->bc_ptrs[level]++;
> > > > +			continue;
> > > > +		}
> > > > +
> > > > +		/* End of node, pop back towards the root. */
> > > > +		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
> > > > +			if (level < cur->bc_nlevels - 1)
> > > > +				cur->bc_ptrs[level + 1]++;
> > > > +			level++;
> > > > +			continue;
> > > > +		}
> > > > +
> > > > +		/* Drill another level deeper. */
> > > > +		pp = xfs_btree_ptr_addr(cur, cur->bc_ptrs[level], block);
> > > > +		error = xfs_scrub_btree_ptr(&bs, level, pp);
> > > > +		if (error) {
> > > > +			error = 0;
> > > > +			cur->bc_ptrs[level]++;
> > > > +			continue;
> > > > +		}
> > > > +		level--;
> > > > +		error = xfs_scrub_btree_block(&bs, level, pp, &block, &bp);
> > > > +		if (!xfs_scrub_btree_op_ok(sc, cur, level, &error))
> > > > +			goto out;
> > > > +
> > > > +		cur->bc_ptrs[level] = 1;
> > > > +	}
> > > > +
> > > > +out:
> > > > +	return error;
> > > >  }
> > > > diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> > > > index e1bb14b..9920488 100644
> > > > --- a/fs/xfs/scrub/common.h
> > > > +++ b/fs/xfs/scrub/common.h
> > > > @@ -20,6 +20,19 @@
> > > >  #ifndef __XFS_SCRUB_COMMON_H__
> > > >  #define __XFS_SCRUB_COMMON_H__
> > > >  
> > > > +/* Should we end the scrub early? */
> > > > +static inline bool
> > > > +xfs_scrub_should_terminate(
> > > > +	int		*error)
> > > > +{
> > > > +	if (fatal_signal_pending(current)) {
> > > > +		if (*error == 0)
> > > > +			*error = -EAGAIN;
> > > > +		return true;
> > > > +	}
> > > > +	return false;
> > > > +}
> > > > +
> > > >  /*
> > > >   * Grab a transaction.  If we're going to repair something, we need to
> > > >   * ensure there's enough reservation to make all the changes.  If not,
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
