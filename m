Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A00247F3F
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 09:16:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E75E304066
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 07:16:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HPNsAWT1ZBwcqsuc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Aug 2014 07:16:00 -0700 (PDT)
Date: Mon, 18 Aug 2014 10:15:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/9] xfs: xfs_buf_ioend and xfs_buf_iodone_work duplicate
	functionality
Message-ID: <20140818141553.GB30093@bfoster.bfoster>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-3-git-send-email-david@fromorbit.com>
	<20140815131820.GB4096@laptop.bfoster>
	<20140815232135.GU26465@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815232135.GU26465@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Aug 16, 2014 at 09:21:35AM +1000, Dave Chinner wrote:
> On Fri, Aug 15, 2014 at 09:18:21AM -0400, Brian Foster wrote:
> > On Fri, Aug 15, 2014 at 04:39:00PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > We do some work in xfs_buf_ioend, and some work in
> > > xfs_buf_iodone_work, but much of that functionality is the same.
> > > This work can all be done in a single function, leaving
> > > xfs_buf_iodone just a wrapper to determine if we should execute it
> > > by workqueue or directly. hence rename xfs_buf_iodone_work to
> > > xfs_buf_ioend(), and add a new xfs_buf_ioend_async() for places that
> > > need async processing.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_buf.c         | 79 +++++++++++++++++++++---------------------------
> > >  fs/xfs/xfs_buf.h         |  2 +-
> > >  fs/xfs/xfs_buf_item.c    |  4 +--
> > >  fs/xfs/xfs_inode.c       |  2 +-
> > >  fs/xfs/xfs_log.c         |  2 +-
> > >  fs/xfs/xfs_log_recover.c |  2 +-
> > >  6 files changed, 40 insertions(+), 51 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index 5d86bbd..1b7f0bc 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -999,54 +999,49 @@ xfs_buf_wait_unpin(
> > >   */
> > >  
> > >  STATIC void
> > > -xfs_buf_iodone_work(
> > > -	struct work_struct	*work)
> > > +xfs_buf_ioend(
> > > +	struct xfs_buf	*bp)
> > 
> > Compile failure here due to STATIC.
> > 
> > >  {
> > > -	struct xfs_buf		*bp =
> > > -		container_of(work, xfs_buf_t, b_iodone_work);
> > > -	bool			read = !!(bp->b_flags & XBF_READ);
> > > +	bool		read = !!(bp->b_flags & XBF_READ);
> > > +
> > > +	trace_xfs_buf_iodone(bp, _RET_IP_);
> > >  
> > >  	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
> > >  
> > > -	/* only validate buffers that were read without errors */
> > > -	if (read && bp->b_ops && !bp->b_error && (bp->b_flags & XBF_DONE))
> > > -		bp->b_ops->verify_read(bp);
> > > +	if (!bp->b_error) {
> > > +		bp->b_flags |= XBF_DONE;
> > > +
> > > +		/* only validate buffers that were read without errors */
> > > +		if (read && bp->b_ops)
> > > +			bp->b_ops->verify_read(bp);
> > > +	}
> > 
> > Probably not a cause of errors, but this code is now executed twice for
> > I/O with b_iodone callbacks.
> 
> reads don't have b_iodone callbacks.
> 

Ah, Ok.

> > Once for the initial call from bio_end_io,
> > again from the callback via the b_iodone handler. The flags bits are
> > probably fine, but we don't want to be running the verifiers multiple
> > times unnecessarily.
> 
> Which we don't ;)
> 

Good point, but that's still a landmine IMO. It looks like the previous
code would avoid it for sync I/O, but not for async. You could probably
avoid it generally via a new flag or just by going off of XBF_DONE. The
latter seems logical to me. A comment wouldn't hurt either.

> > > @@ -1425,10 +1412,12 @@ xfs_buf_iorequest(
> > >  	 * waiting, and in the synchronous IO case it avoids unnecessary context
> > >  	 * switches an latency for high-peformance devices.
> > >  	 */
> > > -	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
> > > -		_xfs_buf_ioend(bp, 0);
> > > -	else
> > > -		_xfs_buf_ioend(bp, 1);
> > > +	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
> > > +		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
> > > +			xfs_buf_ioend(bp);
> > > +		else
> > > +			xfs_buf_ioend_async(bp);
> > > +	}
> > 
> > This looks cleaner, but the comment is out of whack at this point.
> 
> The code is functionally identical, so the comment didn't get
> changed. As it is, the behaviour that exists in this patch goes away
> in later patches, so it's mostly irrelevant that a comment is
> absoultely correct in an intermediate point within the patch set.
> 

This was just a minor point that the comment refers to _xfs_buf_ioend().
That obviously no longer exists but the comment is still around at the
end of the series.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
