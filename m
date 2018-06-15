Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755650AbeFOLxJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jun 2018 07:53:09 -0400
Date: Fri, 15 Jun 2018 07:53:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 1/2] xfs: refactor buffer submission into a common
 helper
Message-ID: <20180615115305.GB2857@bfoster>
References: <20180613110516.65494-2-bfoster@redhat.com>
 <20180614134307.26868-1-bfoster@redhat.com>
 <20180615112414.GA3230@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615112414.GA3230@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 15, 2018 at 04:24:14AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 14, 2018 at 09:43:07AM -0400, Brian Foster wrote:
> > Sync and async buffer submission both do generally similar things
> > with a couple odd exceptions. Refactor the core buffer submission
> > code into a common helper to isolate buffer submission from
> > completion handling of synchronous buffer I/O.
> > 
> > This patch does not change behavior. It is a step towards support
> > for using synchronous buffer I/O via synchronous delwri queue
> > submission.
> > 
> > Designed-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > v3:
> > - Leave tracepoint in __xfs_buf_submit and kill
> >   trace_xfs_buf_submit_wait().
> > 
> >  fs/xfs/xfs_buf.c   | 85 ++++++++++++++++++++--------------------------
> >  fs/xfs/xfs_trace.h |  1 -
> >  2 files changed, 37 insertions(+), 49 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index e9c058e3761c..7b0f7c79cd62 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1458,22 +1458,20 @@ _xfs_buf_ioapply(
> >   * a call to this function unless the caller holds an additional reference
> >   * itself.
> >   */
> > -void
> > -xfs_buf_submit(
> > +static int
> > +__xfs_buf_submit(
> >  	struct xfs_buf	*bp)
> >  {
> >  	trace_xfs_buf_submit(bp, _RET_IP_);
> >  
> >  	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
> > -	ASSERT(bp->b_flags & XBF_ASYNC);
> >  
> >  	/* on shutdown we stale and complete the buffer immediately */
> >  	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> >  		xfs_buf_ioerror(bp, -EIO);
> >  		bp->b_flags &= ~XBF_DONE;
> >  		xfs_buf_stale(bp);
> > -		xfs_buf_ioend(bp);
> > -		return;
> > +		return -EIO;
> >  	}
> >  
> >  	if (bp->b_flags & XBF_WRITE)
> > @@ -1482,23 +1480,14 @@ xfs_buf_submit(
> >  	/* clear the internal error state to avoid spurious errors */
> >  	bp->b_io_error = 0;
> >  
> > -	/*
> > -	 * The caller's reference is released during I/O completion.
> > -	 * This occurs some time after the last b_io_remaining reference is
> > -	 * released, so after we drop our Io reference we have to have some
> > -	 * other reference to ensure the buffer doesn't go away from underneath
> > -	 * us. Take a direct reference to ensure we have safe access to the
> > -	 * buffer until we are finished with it.
> > -	 */
> > -	xfs_buf_hold(bp);
> > -
> >  	/*
> >  	 * Set the count to 1 initially, this will stop an I/O completion
> >  	 * callout which happens before we have started all the I/O from calling
> >  	 * xfs_buf_ioend too early.
> >  	 */
> >  	atomic_set(&bp->b_io_remaining, 1);
> > -	xfs_buf_ioacct_inc(bp);
> > +	if (bp->b_flags & XBF_ASYNC)
> > +		xfs_buf_ioacct_inc(bp);
> >  	_xfs_buf_ioapply(bp);
> >  
> >  	/*
> > @@ -1507,14 +1496,39 @@ xfs_buf_submit(
> >  	 * that we don't return to the caller with completion still pending.
> >  	 */
> >  	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
> > -		if (bp->b_error)
> > +		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
> >  			xfs_buf_ioend(bp);
> >  		else
> >  			xfs_buf_ioend_async(bp);
> >  	}
> >  
> > -	xfs_buf_rele(bp);
> > +	return 0;
> > +}
> > +
> > +void
> > +xfs_buf_submit(
> > +	struct xfs_buf	*bp)
> > +{
> > +	int		error;
> > +
> > +	ASSERT(bp->b_flags & XBF_ASYNC);
> > +
> > +	/*
> > +	 * The caller's reference is released during I/O completion.
> > +	 * This occurs some time after the last b_io_remaining reference is
> > +	 * released, so after we drop our Io reference we have to have some
> > +	 * other reference to ensure the buffer doesn't go away from underneath
> > +	 * us. Take a direct reference to ensure we have safe access to the
> > +	 * buffer until we are finished with it.
> > +	 */
> > +	xfs_buf_hold(bp);
> > +
> > +	error = __xfs_buf_submit(bp);
> > +	if (error)
> > +		xfs_buf_ioend(bp);
> > +
> 
> It seems like we could simple throw in a:
> 
> 	if (!(bp->b_flags & XBF_ASYNC)) {
> 		trace_xfs_buf_iowait(bp, _RET_IP_);
> 		wait_for_completion(&bp->b_iowait);
> 		trace_xfs_buf_iowait_done(bp, _RET_IP_);
> 		error = bp->b_error;;
> 	}
> 
> here and get ret rid of the separate xfs_buf_submit_wait function
> entirely.  Or even factor the above out into a nice little helper.
> 

As you already noted in patch 2, we need this code split up to support
fixing the delwri queue thing..

> Otherwise this looks fine to me:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks. I assume you mean Reviewed-by... ;)

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
