Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58824 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeJEFLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 01:11:12 -0400
Date: Thu, 4 Oct 2018 15:15:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] xfs: fix buffer state management in
 xrep_findroot_block
Message-ID: <20181004221538.GK19324@magnolia>
References: <153843409576.24414.14199833763423874927.stgit@magnolia>
 <153843410841.24414.2317164703479198891.stgit@magnolia>
 <20181003020211.GC19324@magnolia>
 <20181003110526.GB61462@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003110526.GB61462@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Oct 03, 2018 at 07:05:27AM -0400, Brian Foster wrote:
> On Tue, Oct 02, 2018 at 07:02:11PM -0700, Darrick J. Wong wrote:
> > We don't handle buffer state properly in online repair's findroot
> > routine.  If a buffer already has b_ops set, we don't ever want to touch
> > that, and we don't want to call the read verifiers on a buffer that
> > could be dirty (CRCs are only recomputed during log checkpoints).
> > 
> > Therefore, be more careful about what we do with a buffer -- if someone
> > else already attached ops that are not the ones for this btree type,
> > just ignore the buffer.  We only attach our btree type's buf ops if it
> > matches the magic/uuid and structure checks.
> > 
> > We also modify xfs_buf_read_map to allow callers to set buffer ops on a
> > DONE buffer with NULL ops so that repair doesn't leave behind buffers
> > which won't have buffers attached to them.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/repair.c  |   63 +++++++++++++++++++++++++++++++++++++-----------
> >  fs/xfs/xfs_buf.c       |   12 +++++++++
> >  fs/xfs/xfs_trans.h     |    1 +
> >  fs/xfs/xfs_trans_buf.c |   13 ++++++++++
> >  4 files changed, 75 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index 63786341ac2a..cebaebb26566 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> > @@ -29,6 +29,8 @@
> >  #include "xfs_ag_resv.h"
> >  #include "xfs_trans_space.h"
> >  #include "xfs_quota.h"
> > +#include "xfs_attr.h"
> > +#include "xfs_reflink.h"
> >  #include "scrub/xfs_scrub.h"
> >  #include "scrub/scrub.h"
> >  #include "scrub/common.h"
> > @@ -699,7 +701,7 @@ xrep_findroot_block(
> >  	struct xfs_btree_block		*btblock;
> >  	xfs_daddr_t			daddr;
> >  	int				block_level;
> > -	int				error;
> > +	int				error = 0;
> >  
> >  	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.agno, agbno);
> >  
> > @@ -718,28 +720,61 @@ xrep_findroot_block(
> >  			return error;
> >  	}
> >  
> > +	/*
> > +	 * Read the buffer into memory so that we can see if it's a match for
> > +	 * our btree type.  We have no clue if it is beforehand, and we want to
> > +	 * avoid xfs_trans_read_buf's behavior of dumping the DONE state (which
> > +	 * will cause needless disk reads in subsequent calls to this function)
> > +	 * and logging metadata verifier failures.
> > +	 *
> > +	 * Therefore, pass in NULL buffer ops.  If the buffer was already in
> > +	 * memory from some other caller it will already have b_ops assigned.
> > +	 * If it was in memory from a previous unsuccessful findroot_block
> > +	 * call, the buffer won't have b_ops but it should be clean and ready
> > +	 * for us to try to verify if the read call succeeds.  The same applies
> > +	 * if the buffer wasn't in memory at all.
> > +	 *
> > +	 * Note: If we never match a btree type with this buffer, it will be
> > +	 * left in memory with NULL b_ops.  This shouldn't be a problem unless
> > +	 * the buffer gets written.
> > +	 */
> >  	error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp, daddr,
> >  			mp->m_bsize, 0, &bp, NULL);
> >  	if (error)
> >  		return error;
> >  
> > -	/*
> > -	 * Does this look like a block matching our fs and higher than any
> > -	 * other block we've found so far?  If so, reattach buffer verifiers
> > -	 * so the AIL won't complain if the buffer is also dirty.
> > -	 */
> > +	/* Ensure the block magic matches the btree type we're looking for. */
> >  	btblock = XFS_BUF_TO_BLOCK(bp);
> >  	if (be32_to_cpu(btblock->bb_magic) != fab->magic)
> >  		goto out;
> > -	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> > -	    !uuid_equal(&btblock->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
> > -		goto out;
> > -	bp->b_ops = fab->buf_ops;
> >  
> > -	/* Make sure we pass the verifiers. */
> > -	bp->b_ops->verify_read(bp);
> > -	if (bp->b_error)
> > -		goto out;
> > +	/*
> > +	 * If the buffer already has ops applied and they're not the ones for
> > +	 * this btree type, we know this block doesn't match the btree and we
> > +	 * can bail out.
> > +	 *
> > +	 * If the buffer ops match ours, someone else has already validated
> > +	 * the block for us, so we can move on to checking if this is a root
> > +	 * block candidate.
> > +	 *
> > +	 * If the buffer does not have ops, nobody has successfully validated
> > +	 * the contents and the buffer cannot be dirty.  If the magic, uuid,
> > +	 * and structure match this btree type then we'll move on to checking
> > +	 * if it's a root block candidate.  If there is no match, bail out.
> > +	 */
> > +	if (bp->b_ops) {
> > +		if (bp->b_ops != fab->buf_ops)
> > +			goto out;
> > +	} else {
> > +		ASSERT(!xfs_trans_buf_is_dirty(bp));
> > +		if (!uuid_equal(&btblock->bb_u.s.bb_uuid,
> > +				&mp->m_sb.sb_meta_uuid))
> > +			goto out;
> > +		fab->buf_ops->verify_read(bp);
> > +		if (bp->b_error)
> > +			goto out;
> > +		bp->b_ops = fab->buf_ops;
> > +	}
> >  
> >  	/*
> >  	 * This block passes the magic/uuid and verifier tests for this btree
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index e839907e8492..7aa78cef9c3a 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> 
> Separate patch for the core buffer changes please. :)

Ok, sorry about that.

> > @@ -777,6 +777,18 @@ xfs_buf_read_map(
> >  			xfs_buf_relse(bp);
> >  			return NULL;
> >  		} else {
> > +			/*
> > +			 * Online repair can leave done buffers in memory with
> > +			 * no b_ops assigned.  If the caller passed in an ops
> > +			 * structure, see if the buffer passes the verifier.
> > +			 * If successful, assign the ops to the buffer.
> > +			 */
> > +			if (!bp->b_ops && ops) {
> > +				ops->verify_read(bp);
> > +				if (!bp->b_error)
> > +					bp->b_ops = ops;
> 
> Why the conditional assignment? The read branch above looks like all
> current ops != NULL callers essentially force attach ->b_ops. E.g., a
> verification failure is an unconditional I/O error in this context, so
> ops is not considered "prospective" at this layer like it is in the
> scrub context.

You're right.  If the caller gave us an *ops that means they want to
take ownership of the buffer, and that implies setting b_ops.

> Not that it matters that much, but I think it's strange to attach
> ->b_ops (on failure) based on whether the buffer had already been read
> unverified or not.
> 
> Another quirk to consider here is that we currently don't set XBF_DONE
> on read verifier failure. Should we clear XBF_DONE in the event of
> deferred verification failure so a follow on read can retry?

Yes.  Originally I thought that we'd leave the NULL b_ops on verifier
failure so that a future caller might succeed with its own ops, but I
realize that doing so means the caller passes in ops and we'd pass back
a corrupt buffer with NULL ops.  Oops.

> > +			}
> > +
> 
> And since this is a core infrastructure change, I also think we need to
> step back and think about how this could be used in a variety of cases
> going forward (not just our current scrub use case). For one (and nobody
> does this right now), but it looks like an xfs_trans_read_buf(..., NULL)
> caller followed by an xfs_trans_read_buf(..., ops) caller would still
> never verify the buffer because it can be looked up in the transaction
> without hitting the read path.

I don't think I quite agree with you here.  Normally we require callers
of xfs_trans_read_buf to provide an ops structure so that we don't play
with obviously corrupt data.  Upon receipt of the buffer, the caller
needs to decide if it's truly interested in that buffer.

If so, the caller needs to set the b_ops manually before moving
on, in which case a subsequent _trans_read_buf on the same transaction
and buffer will be fine.  The existing caller (quotacheck) does this,
as will repair.

If the caller doesn't want the buffer, it should release the buffer
immediately and let a subsequent reader try its own read verifier.
Currently we don't try the read verifier again, which is what this part
of the patch aims to fix.

That said, we could be a little more defensive in regular operation.  If
someone tries a _trans_read_buf of a buffer that's already joined to the
transaction but has no ops we'll complain but only shut down if the
buffer fails verification.

> Also, it may be technically Ok to defer verification in the readahead
> case of a previously unverified buffer, but I _think_ I'm of the opinion
> that we should verify the buffer ASAP when the caller has provided a
> non-NULL ops. So if verification currently happens on read-ahead in some
> particular workload (in combination with scrub), we should preserve that
> behavior. At minimum, doing so ensures we don't lose potential
> verification failures if a particular readahead buffer never otherwise
> ends up being read "for real."

Agreed.

> Hmm, I'm wondering if it might be a good idea to factor some combination
> of the current ->verify_read() call and ->b_error handling into a small
> helper, make sure we call it in all the right places and conditionalize
> the error handling to callers that aren't in ioend context. I dunno,
> maybe there's a cleaner way to do that. I also think we could use some
> asserts to (for example) make sure we always return a ->b_ops != NULL
> buffer if the caller passed a buf_ops. FWIW, I'm also not against the
> XBF_VERIFIED thing to facilitate that, if that's cleaner than just
> checking ->b_ops everywhere.

Yes, I think we can share that in a xfs_buf_ensure_ops helper.

--D

> Brian
> 
> >  			/* We do not want read in the flags */
> >  			bp->b_flags &= ~XBF_READ;
> >  		}
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index c3d278e96ad1..a0c5dbda18aa 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -220,6 +220,7 @@ void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
> >  void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
> >  				  uint);
> >  void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
> > +bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
> >  void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
> >  
> >  void		xfs_extent_free_init_defer_op(void);
> > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > index 15919f67a88f..bdc5be4d0210 100644
> > --- a/fs/xfs/xfs_trans_buf.c
> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -321,6 +321,19 @@ xfs_trans_read_buf_map(
> >  
> >  }
> >  
> > +/* Has this buffer been dirtied by anyone? */
> > +bool
> > +xfs_trans_buf_is_dirty(
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> > +
> > +	if (!bip)
> > +		return false;
> > +	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
> > +	return test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
> > +}
> > +
> >  /*
> >   * Release the buffer bp which was previously acquired with one of the
> >   * xfs_trans_... buffer allocation routines if the buffer has not
