Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbeJCRvJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 13:51:09 -0400
Date: Wed, 3 Oct 2018 07:03:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: fix buffer state management in
 xrep_findroot_block
Message-ID: <20181003110312.GA61462@bfoster>
References: <153843409576.24414.14199833763423874927.stgit@magnolia>
 <153843410841.24414.2317164703479198891.stgit@magnolia>
 <20181002123640.GB55077@bfoster>
 <20181002195617.GA19324@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002195617.GA19324@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Oct 02, 2018 at 12:56:17PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 02, 2018 at 08:36:41AM -0400, Brian Foster wrote:
> > On Mon, Oct 01, 2018 at 03:48:28PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > We don't quite handle buffer state properly in online repair's findroot
> > > routine.  If the buffer is already in-core we don't want to trash its
> > > b_ops and state, but we /do/ want to read the contents in from disk if
> > > the buffer wasn't already in memory.
> > > 
> > > Therefore, introduce the ONESHOT_OPS buffer flag.  If the buffer had to
> > > be read in from disk, the buf_ops supplied to read_buf will be used once
> > > to verify the buffer contents, but they will not be attached to the
> > > buffer itself.
> > > 
> > > With this change, xrep_findroot_block's buffer handling can be
> > > simplified -- if b_ops is null, we know that it was freshly read (and
> > > verified), we can set b_ops, and proceed.  If b_ops is not null, the
> > > buffer was already in memory and we need to do some more structure
> > > checks.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/scrub/repair.c |   76 ++++++++++++++++++++++++++++++++++++++-----------
> > >  fs/xfs/xfs_buf.c      |    7 ++++-
> > >  fs/xfs/xfs_buf.h      |    2 +
> > >  3 files changed, 67 insertions(+), 18 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > > index 6eb66b3543ff..8e1dfa5752b4 100644
> > > --- a/fs/xfs/scrub/repair.c
> > > +++ b/fs/xfs/scrub/repair.c
> > ...
> > > @@ -718,28 +721,67 @@ xrep_findroot_block(
> > >  			return error;
> > >  	}
> > >  
> > > +	/*
> > > +	 * Read the buffer into memory with ONESHOT_OPS.  We can tell if we
> > > +	 * had to go to disk by whether or not b_ops is set.
> > > +	 */
> > >  	error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp, daddr,
> > > -			mp->m_bsize, 0, &bp, NULL);
> > > +			mp->m_bsize, XBF_ONESHOT_OPS, &bp, fab->buf_ops);
> > >  	if (error)
> > >  		return error;
> > >  
> > > -	/*
> > > -	 * Does this look like a block matching our fs and higher than any
> > > -	 * other block we've found so far?  If so, reattach buffer verifiers
> > > -	 * so the AIL won't complain if the buffer is also dirty.
> > > -	 */
> > >  	btblock = XFS_BUF_TO_BLOCK(bp);
> > > -	if (be32_to_cpu(btblock->bb_magic) != fab->magic)
> > > -		goto out;
> > > -	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> > > -	    !uuid_equal(&btblock->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
> > > -		goto out;
> > > -	bp->b_ops = fab->buf_ops;
> > > +	if (bp->b_ops == NULL) {
> > > +		/*
> > > +		 * The buffer came back with NULL b_ops, which means that the
> > > +		 * buffer was not in memory, we had to read it off disk, and
> > > +		 * the verifier has run.
> > > +		 *
> > > +		 * If b_error == 0, the block matches the magic, the uuid, and
> > > +		 * ->verify_struct of the btree type and we can proceed.  Set
> > > +		 * b_ops to the btree type's buf_ops so that we don't have a
> > > +		 * buffer in memory with no verifiers.
> > > +		 *
> > > +		 * Otherwise, the block doesn't match the btree type so we
> > > +		 * mark it oneshot so it doesn't stick around, and move on.
> > > +		 */
> > 
> > Hmm, the fact that this interface still requires looking at internal
> > buffer state to process what happened suggests to me it may not be the
> > best approach.
> 
> Aha!  Having recollected more of my marbles, now I remember why the
> previous iteration of this patch did the weird dance with get_buf and
> read_buf.  At a high level, we want to do:
> 
>   1. If the buffer is already in memory, we want to grab it, check the
>   magic, uuid, and structure, and if it doesn't matches our btree type
>   then we move on.
> 
>   2. If the buffer is /not/ in memory (i.e. !XBF_DONE), then we want to
>   read it off the disk and run the verifier to see if it matches our
>   btree type.  If not, we move on.
> 
> However, the buffer state management doesn't /quite/ work that way.  In
> particular, if we call _trans_read_buf on a !DONE buffer and fail
> ->verify_read, it will log the verifier error and stale the buffer,
> which means that a subsequent call of xrep_findroot_block with the same
> buffer will have to reread the disk and may very well log a verifier
> error too.  This is obnoxious since we're wasting resources and logging
> non-errors.
> 
> That's why the previous patch called _trans_read_buf with NULL ops.  In
> the first case we'd get back our DONE buffer and proceed with checks.
> In the !DONE case, _trans_read_buf would read the metadata off disk into
> the buffer, set DONE, and return it to us unchecked.  Then we'd call
> ->verify_read ourselves; if it succeeds we attach the ops and use the
> buffer, or else we release the buffer (which would still have null ops).
> In theory if anyone ever tried to write the buffer without attaching ops
> the log code will complain.
> 
> However, there /is/ a bug -- if none of the find_ag_btree profiles match
> the buffer, the xrep code will never attach any buf ops.  A subsequent
> _trans_read_buf call from some other part of XFS will see the DONE state
> and decline to attach the passed in ops, which later leads to a log
> splat on the NULL b_ops.
> 

Right, that's my understanding of the original problem. And IIRC, one of
the tradeoffs with the previous approach (and this one) was that in
attempting to fix that problem, we'd introduce behavior where the buffer
had to be re-read from disk each time.

> I think the solution here is to modify xfs_buf_read_map to handle a
> (DONE buffer with NULL b_ops and !NULL passed-in ops) to call
> ->verify_read on the buffer and set b_ops if successful.
> 
> (please keep reading)
> 
> > IIUC, a buffer that's already in-core is just going to
> > return with the existing b_ops (the else branch below). Otherwise,
> > ->b_ops is NULL to indicate that we read it from disk and ran the passed
> > in (prospective) verifier...
> > 
> > > +		if (bp->b_error) {
> > > +			xfs_buf_oneshot(bp);
> > > +			goto out;
> > > +		}
> > 
> > ... which means that this can't happen, because if we ran the passed in
> > verifier and it fails the xfs_trans_read_buf() call invalidates the
> > buffer and returns an error. I think that also means we'd abort the scan
> > if we don't filter out -EFSCORRUPTED returns so long as we pass a
> > potentially incorrect verifier.
> 
> Correct.  Good catch! :)
> 
> > Also note that I think this still means that each failure to match a
> > verifier has to re-read the buffer from disk, but we can deal with that
> > separately.
> > 
> > > +		bp->b_ops = fab->buf_ops;
> > 
> > Therefore, a successful return with a NULL ->b_ops means we ran the
> > verifier, it passed, and we're going to attach it. Am I missing
> > something, or is this a roundabout way to just do what the buffer read
> > mechanism already does without the flag?
> 
> Yes, it's roundabout.
> 
> > I could easily be missing some of the verification intricacies that are
> > required from scrub context,
> 
> I think I've explained it above, now that I finally remember what I was
> trying to accomplish. :)
> 
> > but is this logic roughly equivalent to the following (without any
> > special control flags)? We'd repeat some checks in the event the
> > buffer was read from disk, but perhaps that can also be optimized out
> > separately if it really matters. Hm?
> 
> How about something like this?
> 

This looks reasonable enough to me. I'd just suggest to streamline the
comments a bit...

> 	/*
> 	 * Read the buffer into memory so that we can see if it's a match for
> 	 * our btree type.  We have no clue if it is beforehand, and we want to
> 	 * avoid xfs_trans_read_buf's behavior of dumping the DONE state (which
> 	 * will cause needless disk reads in subsequent calls to this function)
> 	 * and logging metadata verifier failures.
> 	 *
> 	 * Therefore, pass in NULL buffer ops.  If the buffer was already in
> 	 * memory from some other caller it will already have b_ops assigned.
> 	 * If it was in memory from a previous unsuccessful findroot_block
> 	 * call, the buffer won't have b_ops but it should be clean and ready
> 	 * for us to try to verify if the read call succeeds.  The same applies
> 	 * if the buffer wasn't in memory at all.
> 	 *
> 	 * Note: If we never match a btree type with this buffer, it will be
> 	 * left in memory with NULL b_ops.  This shouldn't be a problem unless
> 	 * the buffer gets written.
> 	 */

/*
 * Read an unverified buffer so we can match it to one of the caller's
 * verifiers without generating I/O errors and log noise. If we can't
 * match it, the buffer may remain in-core without a verifier. This is
 * fine because the first reader with a non-NULL buf_ops verifies an
 * unverified buffer regardless of whether it was already in-core.
 */

> 	error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp, daddr,
> 			mp->m_bsize, 0, &bp, NULL);
> 	if (error)
> 		return error;
> 
> 	/*
> 	 * If the buffer already has ops applied and they're not the ones for
> 	 * this btree type, we know this block doesn't match the btree and we
> 	 * can bail out.
> 	 *
> 	 * If the buffer ops match ours, someone else has already validated
> 	 * the block for us, so we can move on to checking if this is a root
> 	 * block candidate.
> 	 *
> 	 * If the buffer does not have ops, nobody has successfully validated
> 	 * the contents and the buffer cannot be dirty.  If the magic, uuid,
> 	 * and structure match this btree type then we'll move on to checking
> 	 * if it's a root block candidate.  If there is no match, bail out.
> 	 */
> 	if (bp->b_ops) {
> 		if (b->b_ops != fab->buf_ops)
> 			goto out;
> 	} else {
> 		if (be32_to_cpu(btblock->bb_magic) != fab->magic)
> 			goto out;
> 		if (xfs_sb_version_hascrc(&mp->m_sb) &&
> 		    !uuid_equal(&btblock->bb_u.s.bb_uuid,
> 				&mp->m_sb.sb_meta_uuid))
> 			goto out;
> 		fa = fab->buf_ops->verify_struct(bp);
> 		if (fa)
> 			goto out;
> 		b->b_ops = fab->buf_ops;
> 	}
> 

... and then maybe reorder that logic:

	/*
	 * Verify the buffer against fab->buf_ops. If it's a match,
	 * attach buf_ops and proceed. If not, ->b_ops remains NULL
	 * until we find a match or another reader attaches the
	 * appropriate buf_ops.
	 */
	if (!bp->b_ops) {
		...
		b->b_ops = fab->buf_ops;
	}

	/*
	 * If the buffer was in-core and already verified with a
	 * different buf_ops, we know it's not a match.
	 */
	if (bp->b_ops != fab->buf_ops)
		goto out;

> and then xfs_buf_read_map can be taught to call the read verifier if it
> ever encounters an XBF_DONE buffer with b_ops == NULL and ops != NULL.
> 

Yep, but I think the higher level buffer behavior change should be an
independent patch rather than be buried in a scrub bug fix.

Brian

> --D
> 
> > 
> > 	...
> >         error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp, daddr,
> >                         mp->m_bsize, 0, &bp, fab->buf_ops);
> >         if (error == -EFSCORRUPTED)
> >                 goto out;
> >         else if (error)
> >                 return error;
> > 
> >         /*
> >          * If b_ops doesn't match fab, the buffer was already in-core with a
> >          * different verifier. We know it doesn't match in that case.
> >          */
> >         if (bp->b_ops != fab->buf_ops)
> >                 goto out;
> > 
> >         /*
> >          * The verifier matches but the buffer may have already been in-core
> >          * with this verifier. Sanity check the latest content before we
> >          * proceed. Don't check the CRC because CRCs aren't updated until
> >          * writeback.
> >          */
> >         btblock = XFS_BUF_TO_BLOCK(bp);
> >         if (be32_to_cpu(btblock->bb_magic) != fab->magic)
> >                 goto out;
> >         if (xfs_sb_version_hascrc(&mp->m_sb) &&
> >             !uuid_equal(&btblock->bb_u.s.bb_uuid,
> >                         &mp->m_sb.sb_meta_uuid))
> >                 goto out;
> >         fa = bp->b_ops->verify_struct(bp);
> >         if (fa)
> >                 goto out;
> > 	...
> > 
> > Brian
> > 
> > > +	} else {
> > > +		/*
> > > +		 * The buffer came back with b_ops set, which means that the
> > > +		 * buffer was already in memory.  We'll run the magic, uuid,
> > > +		 * and ->verify_struct checks by hand to see if we want to
> > > +		 * examine it further.
> > > +		 */
> > > +		if (be32_to_cpu(btblock->bb_magic) != fab->magic)
> > > +			goto out;
> > > +		if (xfs_sb_version_hascrc(&mp->m_sb) &&
> > > +		    !uuid_equal(&btblock->bb_u.s.bb_uuid,
> > > +				&mp->m_sb.sb_meta_uuid))
> > > +			goto out;
> > >  
> > > -	/* Make sure we pass the verifiers. */
> > > -	bp->b_ops->verify_read(bp);
> > > -	if (bp->b_error)
> > > -		goto out;
> > > +		/*
> > > +		 * If b_ops do not match fab->buf_ops even though the magic
> > > +		 * does, something is seriously wrong here and we'd rather
> > > +		 * abort the entire repair than risk screwing things up.
> > > +		 */
> > > +		if (bp->b_ops != fab->buf_ops)
> > > +			goto out;
> > > +
> > > +		/*
> > > +		 * If the buffer was already incore (on a v5 fs) then it should
> > > +		 * already have had b_ops assigned.  Call ->verify_struct to
> > > +		 * check the structure.  Avoid checking the CRC because we
> > > +		 * don't calculate CRCs until the buffer is written by the log.
> > > +		 */
> > > +		fa = bp->b_ops->verify_struct(bp);
> > > +		if (fa)
> > > +			goto out;
> > > +	}
> > >  
> > >  	/*
> > >  	 * This block passes the magic/uuid and verifier tests for this btree
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index e839907e8492..139d35f6da64 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -206,7 +206,8 @@ _xfs_buf_alloc(
> > >  	 * We don't want certain flags to appear in b_flags unless they are
> > >  	 * specifically set by later operations on the buffer.
> > >  	 */
> > > -	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
> > > +	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD |
> > > +		   XBF_ONESHOT_OPS);
> > >  
> > >  	atomic_set(&bp->b_hold, 1);
> > >  	atomic_set(&bp->b_lru_ref, 1);
> > > @@ -758,6 +759,7 @@ xfs_buf_read_map(
> > >  	const struct xfs_buf_ops *ops)
> > >  {
> > >  	struct xfs_buf		*bp;
> > > +	const struct xfs_buf_ops *orig_ops;
> > >  
> > >  	flags |= XBF_READ;
> > >  
> > > @@ -767,8 +769,11 @@ xfs_buf_read_map(
> > >  
> > >  		if (!(bp->b_flags & XBF_DONE)) {
> > >  			XFS_STATS_INC(target->bt_mount, xb_get_read);
> > > +			orig_ops = bp->b_ops;
> > >  			bp->b_ops = ops;
> > >  			_xfs_buf_read(bp, flags);
> > > +			if (flags & XBF_ONESHOT_OPS)
> > > +				bp->b_ops = orig_ops;
> > >  		} else if (flags & XBF_ASYNC) {
> > >  			/*
> > >  			 * Read ahead call which is already satisfied,
> > > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > > index 4e3171acd0f8..62139d3ad349 100644
> > > --- a/fs/xfs/xfs_buf.h
> > > +++ b/fs/xfs/xfs_buf.h
> > > @@ -34,6 +34,7 @@ typedef enum {
> > >  #define XBF_ASYNC	 (1 << 4) /* initiator will not wait for completion */
> > >  #define XBF_DONE	 (1 << 5) /* all pages in the buffer uptodate */
> > >  #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
> > > +#define XBF_ONESHOT_OPS	 (1 << 7) /* only use ops if we read in the buf */
> > >  #define XBF_WRITE_FAIL	 (1 << 24)/* async writes have failed on this buffer */
> > >  
> > >  /* I/O hints for the BIO layer */
> > > @@ -61,6 +62,7 @@ typedef unsigned int xfs_buf_flags_t;
> > >  	{ XBF_ASYNC,		"ASYNC" }, \
> > >  	{ XBF_DONE,		"DONE" }, \
> > >  	{ XBF_STALE,		"STALE" }, \
> > > +	{ XBF_ONESHOT_OPS,	"ONESHOT_OPS" }, /* should never be set */ \
> > >  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
> > >  	{ XBF_SYNCIO,		"SYNCIO" }, \
> > >  	{ XBF_FUA,		"FUA" }, \
> > > 
