Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 746097CB0
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2016 07:03:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 47B588F8040
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2016 05:03:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YUTUjn0ucKWa3mJE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jul 2016 05:03:19 -0700 (PDT)
Date: Tue, 12 Jul 2016 08:03:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: add readahead bufs to lru early to prevent
	post-unmount panic
Message-ID: <20160712120315.GA4311@bfoster.bfoster>
References: <1467291229-13548-1-git-send-email-bfoster@redhat.com>
	<20160630224457.GT12670@dastard>
	<20160701223011.GA28130@bfoster.bfoster>
	<20160705164552.GA6317@bfoster.bfoster>
	<20160711052057.GE1922@dastard>
	<20160711135251.GA32896@bfoster.bfoster>
	<20160711152921.GB32896@bfoster.bfoster>
	<20160711224451.GF1922@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160711224451.GF1922@dastard>
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

On Tue, Jul 12, 2016 at 08:44:51AM +1000, Dave Chinner wrote:
> On Mon, Jul 11, 2016 at 11:29:22AM -0400, Brian Foster wrote:
> > On Mon, Jul 11, 2016 at 09:52:52AM -0400, Brian Foster wrote:
> > ...
> > > So what is your preference out of the possible approaches here? AFAICS,
> > > we have the following options:
> > > 
> > > 1.) The original "add readahead to LRU early" approach.
> > > 	Pros: simple one-liner
> > > 	Cons: bit of a hack, only covers readahead scenario
> > > 2.) Defer I/O count decrement to buffer release (this patch).
> > > 	Pros: should cover all cases (reads/writes)
> > > 	Cons: more complex (requires per-buffer accounting, etc.)
> > > 3.) Raw (buffer or bio?) I/O count (no defer to buffer release)
> > > 	Pros: eliminates some complexity from #2
> > > 	Cons: still more complex than #1, racy in that decrement does
> > > 	not serialize against LRU addition (requires drain_workqueue(),
> > > 	which still doesn't cover error conditions)
> > > 
> > > As noted above, option #3 also allows for either a buffer based count or
> > > bio based count, the latter of which might simplify things a bit further
> > > (TBD). Thoughts?
> 
> Pretty good summary :P
> 
> > FWIW, the following is a slightly cleaned up version of my initial
> > approach (option #3 above). Note that the flag is used to help deal with
> > varying ioend behavior. E.g., xfs_buf_ioend() is called once for some
> > buffers, multiple times for others with an iodone callback, that
> > behavior changes in some cases when an error is set, etc. (I'll add
> > comments before an official post.)
> 
> The approach looks good - I think there's a couple of things we can
> do to clean it up and make it robust. Comments inline.
> 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 4665ff6..45d3ddd 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1018,7 +1018,10 @@ xfs_buf_ioend(
> >  
> >  	trace_xfs_buf_iodone(bp, _RET_IP_);
> >  
> > -	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
> > +	if (bp->b_flags & XBF_IN_FLIGHT)
> > +		percpu_counter_dec(&bp->b_target->bt_io_count);
> > +
> > +	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD | XBF_IN_FLIGHT);
> >  
> >  	/*
> >  	 * Pull in IO completion errors now. We are guaranteed to be running
> 
> I think the XBF_IN_FLIGHT can be moved to the final xfs_buf_rele()
> processing if:
> 
> > @@ -1341,6 +1344,11 @@ xfs_buf_submit(
> >  	 * xfs_buf_ioend too early.
> >  	 */
> >  	atomic_set(&bp->b_io_remaining, 1);
> > +	if (bp->b_flags & XBF_ASYNC) {
> > +		percpu_counter_inc(&bp->b_target->bt_io_count);
> > +		bp->b_flags |= XBF_IN_FLIGHT;
> > +	}
> 
> You change this to:
> 
> 	if (!(bp->b_flags & XBF_IN_FLIGHT)) {
> 		percpu_counter_inc(&bp->b_target->bt_io_count);
> 		bp->b_flags |= XBF_IN_FLIGHT;
> 	}
> 

Ok, so use the flag to cap the I/O count and defer the decrement to
release. I think that should work and addresses the raciness issue. I'll
give it a try.

> We shouldn't have to check for XBF_ASYNC in xfs_buf_submit() - it is
> the path taken for async IO submission, so we should probably
> ASSERT(bp->b_flags & XBF_ASYNC) in this function to ensure that is
> the case.
> 

Yeah, that's unnecessary. There's already such an assert in
xfs_buf_submit(), actually.

> [Thinking aloud - __test_and_set_bit() might make this code a bit
> cleaner]
> 

On a quick try, this complains about b_flags being an unsigned int. I
think I'll leave the set bit as is and use a helper for the release,
which also provides a location to explain how the count works.

> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index 8bfb974..e1f95e0 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -43,6 +43,7 @@ typedef enum {
> >  #define XBF_READ	 (1 << 0) /* buffer intended for reading from device */
> >  #define XBF_WRITE	 (1 << 1) /* buffer intended for writing to device */
> >  #define XBF_READ_AHEAD	 (1 << 2) /* asynchronous read-ahead */
> > +#define XBF_IN_FLIGHT	 (1 << 3)
> 
> Hmmm - it's an internal flag, so probably should be prefixed with an
> "_" and moved down to the section with _XBF_KMEM and friends.
> 

Indeed, thanks.

Brian

> Thoughts?
> 
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
