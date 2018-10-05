Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbeJER0H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 13:26:07 -0400
Date: Fri, 5 Oct 2018 06:27:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 2/2] xfs: fix buffer state management in
 xrep_findroot_block
Message-ID: <20181005102755.GA54400@bfoster>
References: <153843409576.24414.14199833763423874927.stgit@magnolia>
 <153843410841.24414.2317164703479198891.stgit@magnolia>
 <20181003020211.GC19324@magnolia>
 <20181003110526.GB61462@bfoster>
 <20181004221538.GK19324@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004221538.GK19324@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Thu, Oct 04, 2018 at 03:15:38PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 03, 2018 at 07:05:27AM -0400, Brian Foster wrote:
> > On Tue, Oct 02, 2018 at 07:02:11PM -0700, Darrick J. Wong wrote:
> > > We don't handle buffer state properly in online repair's findroot
> > > routine.  If a buffer already has b_ops set, we don't ever want to touch
> > > that, and we don't want to call the read verifiers on a buffer that
> > > could be dirty (CRCs are only recomputed during log checkpoints).
> > > 
> > > Therefore, be more careful about what we do with a buffer -- if someone
> > > else already attached ops that are not the ones for this btree type,
> > > just ignore the buffer.  We only attach our btree type's buf ops if it
> > > matches the magic/uuid and structure checks.
> > > 
> > > We also modify xfs_buf_read_map to allow callers to set buffer ops on a
> > > DONE buffer with NULL ops so that repair doesn't leave behind buffers
> > > which won't have buffers attached to them.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/scrub/repair.c  |   63 +++++++++++++++++++++++++++++++++++++-----------
> > >  fs/xfs/xfs_buf.c       |   12 +++++++++
> > >  fs/xfs/xfs_trans.h     |    1 +
> > >  fs/xfs/xfs_trans_buf.c |   13 ++++++++++
> > >  4 files changed, 75 insertions(+), 14 deletions(-)
> > > 
..
> > 
> > And since this is a core infrastructure change, I also think we need to
> > step back and think about how this could be used in a variety of cases
> > going forward (not just our current scrub use case). For one (and nobody
> > does this right now), but it looks like an xfs_trans_read_buf(..., NULL)
> > caller followed by an xfs_trans_read_buf(..., ops) caller would still
> > never verify the buffer because it can be looked up in the transaction
> > without hitting the read path.
> 
> I don't think I quite agree with you here.  Normally we require callers
> of xfs_trans_read_buf to provide an ops structure so that we don't play
> with obviously corrupt data.  Upon receipt of the buffer, the caller
> needs to decide if it's truly interested in that buffer.
> 
> If so, the caller needs to set the b_ops manually before moving
> on, in which case a subsequent _trans_read_buf on the same transaction
> and buffer will be fine.  The existing caller (quotacheck) does this,
> as will repair.
> 
> If the caller doesn't want the buffer, it should release the buffer
> immediately and let a subsequent reader try its own read verifier.
> Currently we don't try the read verifier again, which is what this part
> of the patch aims to fix.
> 

That all sounds reasonable. My point is not necessarily to say that we
have to support this case. The concern is that nothing in the interface
prevents it and thus it's a landmine at best. The point is basically
that we should never return an unverified buffer to a caller that passes
a non-NULL ops...

> That said, we could be a little more defensive in regular operation.  If
> someone tries a _trans_read_buf of a buffer that's already joined to the
> transaction but has no ops we'll complain but only shut down if the
> buffer fails verification.
> 

... which doesn't preclude returning an error (or some sufficiently loud
combination of assert/warning or whatever..) in the case where an
unverified buffer was found in the current transaction, if that's what
you prefer. ;)

Brian

> > Also, it may be technically Ok to defer verification in the readahead
> > case of a previously unverified buffer, but I _think_ I'm of the opinion
> > that we should verify the buffer ASAP when the caller has provided a
> > non-NULL ops. So if verification currently happens on read-ahead in some
> > particular workload (in combination with scrub), we should preserve that
> > behavior. At minimum, doing so ensures we don't lose potential
> > verification failures if a particular readahead buffer never otherwise
> > ends up being read "for real."
> 
> Agreed.
> 
> > Hmm, I'm wondering if it might be a good idea to factor some combination
> > of the current ->verify_read() call and ->b_error handling into a small
> > helper, make sure we call it in all the right places and conditionalize
> > the error handling to callers that aren't in ioend context. I dunno,
> > maybe there's a cleaner way to do that. I also think we could use some
> > asserts to (for example) make sure we always return a ->b_ops != NULL
> > buffer if the caller passed a buf_ops. FWIW, I'm also not against the
> > XBF_VERIFIED thing to facilitate that, if that's cleaner than just
> > checking ->b_ops everywhere.
> 
> Yes, I think we can share that in a xfs_buf_ensure_ops helper.
> 
> --D
> 
> > Brian
> > 
> > >  			/* We do not want read in the flags */
> > >  			bp->b_flags &= ~XBF_READ;
> > >  		}
> > > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > > index c3d278e96ad1..a0c5dbda18aa 100644
> > > --- a/fs/xfs/xfs_trans.h
> > > +++ b/fs/xfs/xfs_trans.h
> > > @@ -220,6 +220,7 @@ void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
> > >  void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
> > >  				  uint);
> > >  void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
> > > +bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
> > >  void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
> > >  
> > >  void		xfs_extent_free_init_defer_op(void);
> > > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > > index 15919f67a88f..bdc5be4d0210 100644
> > > --- a/fs/xfs/xfs_trans_buf.c
> > > +++ b/fs/xfs/xfs_trans_buf.c
> > > @@ -321,6 +321,19 @@ xfs_trans_read_buf_map(
> > >  
> > >  }
> > >  
> > > +/* Has this buffer been dirtied by anyone? */
> > > +bool
> > > +xfs_trans_buf_is_dirty(
> > > +	struct xfs_buf		*bp)
> > > +{
> > > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> > > +
> > > +	if (!bip)
> > > +		return false;
> > > +	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
> > > +	return test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
> > > +}
> > > +
> > >  /*
> > >   * Release the buffer bp which was previously acquired with one of the
> > >   * xfs_trans_... buffer allocation routines if the buffer has not
