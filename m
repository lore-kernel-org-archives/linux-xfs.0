Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbeEDPxG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 May 2018 11:53:06 -0400
Date: Fri, 4 May 2018 08:52:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0.1/13] xfs: release new dquot buffer on defer_finish
 error
Message-ID: <20180504155236.GK4141@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
 <20180503175343.GF4127@magnolia>
 <20180504113157.GA26217@bfoster.bfoster>
 <20180504151247.GH26569@magnolia>
 <20180504154121.GC26217@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180504154121.GC26217@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Fri, May 04, 2018 at 11:41:21AM -0400, Brian Foster wrote:
> On Fri, May 04, 2018 at 08:12:47AM -0700, Darrick J. Wong wrote:
> > On Fri, May 04, 2018 at 07:31:58AM -0400, Brian Foster wrote:
> > > On Thu, May 03, 2018 at 10:53:43AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > In commit efa092f3d4c6 "[XFS] Fixes a bug in the quota code when
> > > > allocating a new dquot record", we allocate a new dquot block, grab a
> > > > buffer to initialize it, and return the locked initialized dquot buffer
> > > > to the caller for further in-core dquot initialization.  Unfortunately,
> > > > if the _bmap_finish errored out, _qm_dqalloc would also error out
> > > > without bothering to free the (locked) buffer.  Leaking a locked buffer
> > > > caused hangs in generic/388 when quotas are enabled.
> > > > 
> > > > Furthermore, the _bmap_finish -> _defer_finish conversion in
> > > > 310a75a3c6c747 ("xfs: change xfs_bmap_{finish,cancel,init,free} ->
> > > > xfs_defer_*") failed to observe that the buffer was held going into
> > > > _defer_finish and therefore failed to notice that the buffer lock is
> > > > /not/ maintained afterwards.  Now that we can bjoin a buffer to a
> > > > defer_ops, use this mechanism to ensure that the buffer stays locked
> > > > across the _defer_finish.  Release the holds and locks on the buffer as
> > > > appropriate if we have to error out.
> > > > 
> > > > There is a subtlety here for the caller in that the buffer emerges
> > > > locked and held to the transaction, so if the _trans_commit fails we
> > > > have to release the buffer explicitly.  This fixes the unmount hang
> > > > in generic/388 when quotas are enabled.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/xfs_dquot.c |   48 +++++++++++++++++++++++++++---------------------
> > > >  1 file changed, 27 insertions(+), 21 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > > > index a7daef9e16bf..4c39d8632230 100644
> > > > --- a/fs/xfs/xfs_dquot.c
> > > > +++ b/fs/xfs/xfs_dquot.c
> > > > @@ -362,33 +362,39 @@ xfs_qm_dqalloc(
> > > >  			      dqp->dq_flags & XFS_DQ_ALLTYPES, bp);
> > > >  
> > > >  	/*
> > > > -	 * xfs_defer_finish() may commit the current transaction and
> > > > -	 * start a second transaction if the freelist is not empty.
> > > > +	 * Hold the buffer and join it to the dfops so that we'll still own
> > > > +	 * the buffer when we return to the caller.  The buffer disposal on
> > > > +	 * error must be paid attention to very carefully, as it has been
> > > > +	 * broken since commit efa092f3d4c6 "[XFS] Fixes a bug in the quota
> > > > +	 * code when allocating a new dquot record" in 2005, and the later
> > > > +	 * conversion to xfs_defer_ops in commit 310a75a3c6c747 failed to keep
> > > > +	 * the buffer locked across the _defer_finish call.  We can now do
> > > > +	 * this correctly with xfs_defer_bjoin.
> > > >  	 *
> > > > -	 * Since we still want to modify this buffer, we need to
> > > > -	 * ensure that the buffer is not released on commit of
> > > > -	 * the first transaction and ensure the buffer is added to the
> > > > -	 * second transaction.
> > > > +	 * Above, we allocated a disk block for the dquot information and
> > > > +	 * used get_buf to initialize the dquot.  If the _defer_bjoin fails,
> > > > +	 * the buffer is still locked to *tpp, so we must _bhold_release and
> > > > +	 * then _trans_brelse the buffer.  If the _defer_finish fails, the old
> > > > +	 * transaction is gone but the new buffer is not joined or held to any
> > > > +	 * transaction, so we must _buf_relse it.
> > > >  	 *
> > > > -	 * If there is only one transaction then don't stop the buffer
> > > > -	 * from being released when it commits later on.
> > > > +	 * If everything succeeds, the caller of this function is returned a
> > > > +	 * buffer that is locked, held, and joined to the transaction.  If the
> > > > +	 * transaction commit fails (in the caller) the caller must unlock the
> > > > +	 * buffer manually.
> > > 
> > > If the buffer is held due to the xfs_defer_bjoin(), doesn't that mean
> > > that the caller has to ultimately release it even after successful
> > > transaction commit (assuming we don't roll the transaction again
> > > somewhere)? I see we have an xfs_trans_brelse() up in xfs_qm_dqread(),
> > > but it looks like that only clears the hold if the buffer isn't logged
> > > in the tx. Hm?
> > 
> > Correct.  The buffer is initialized in the same transaction as the dquot
> > block allocation and committed in xfs_defer_finish.  After
> > initialization (which is to say when we return to xfs_qm_dqtobp), the
> > buffer is held, joined, and not logged to the transaction, and nothing
> > else is supposed to dirty the buffer.  Both buffer and transaction are
> > then returned in this state to _dqread, which the in-core dquot state
> > out of the dquot buffer and _trans_brelse's the (still clean) buffer,
> > which breaks the hold and unlocks the buffer.
> > 
> 
> Ok that makes sense, but doesn't that depend on having a deferred
> operation? Is that always guaranteed here?

Assuming you meant the case where we _trans_read_buf'd the dquot buffer
in from disk, we return a buffer that's clean, locked, and joined to the
transaction.  The only difference is that the buffer isn't held, but
_trans_brelse clears the hold unconditionally.

--D

> Brian
> 
> > After the refactor we guarantee that the buffer is locked, clean, and
> > not attached to a transaction by the time we get to calling
> > xfs_dquot_from_disk rather than returning transaction and buffer up the
> > call stack and having to reason up the stack about what state they're in.
> > 
> > --D
> > 
> > > Brian
> > > 
> > > >  	 */
> > > > -
> > > > -	xfs_trans_bhold(tp, bp);
> > > > -
> > > > +	xfs_trans_bhold(*tpp, bp);
> > > > +	error = xfs_defer_bjoin(&dfops, bp);
> > > > +	if (error) {
> > > > +		xfs_trans_bhold_release(*tpp, bp);
> > > > +		xfs_trans_brelse(*tpp, bp);
> > > > +		goto error1;
> > > > +	}
> > > >  	error = xfs_defer_finish(tpp, &dfops);
> > > > -	if (error)
> > > > +	if (error) {
> > > > +		xfs_buf_relse(bp);
> > > >  		goto error1;
> > > > -
> > > > -	/* Transaction was committed? */
> > > > -	if (*tpp != tp) {
> > > > -		tp = *tpp;
> > > > -		xfs_trans_bjoin(tp, bp);
> > > > -	} else {
> > > > -		xfs_trans_bhold_release(tp, bp);
> > > >  	}
> > > > -
> > > > -	*O_bpp = bp;
> > > >  	return 0;
> > > >  
> > > >  error1:
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
