Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 618837F50
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 18:21:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D792EAC003
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 16:21:51 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3murMwwpWhBlfYLu for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 16:21:49 -0700 (PDT)
Date: Sat, 16 Aug 2014 09:21:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: xfs_buf_ioend and xfs_buf_iodone_work duplicate
	functionality
Message-ID: <20140815232135.GU26465@dastard>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-3-git-send-email-david@fromorbit.com>
	<20140815131820.GB4096@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815131820.GB4096@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 15, 2014 at 09:18:21AM -0400, Brian Foster wrote:
> On Fri, Aug 15, 2014 at 04:39:00PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We do some work in xfs_buf_ioend, and some work in
> > xfs_buf_iodone_work, but much of that functionality is the same.
> > This work can all be done in a single function, leaving
> > xfs_buf_iodone just a wrapper to determine if we should execute it
> > by workqueue or directly. hence rename xfs_buf_iodone_work to
> > xfs_buf_ioend(), and add a new xfs_buf_ioend_async() for places that
> > need async processing.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c         | 79 +++++++++++++++++++++---------------------------
> >  fs/xfs/xfs_buf.h         |  2 +-
> >  fs/xfs/xfs_buf_item.c    |  4 +--
> >  fs/xfs/xfs_inode.c       |  2 +-
> >  fs/xfs/xfs_log.c         |  2 +-
> >  fs/xfs/xfs_log_recover.c |  2 +-
> >  6 files changed, 40 insertions(+), 51 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 5d86bbd..1b7f0bc 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -999,54 +999,49 @@ xfs_buf_wait_unpin(
> >   */
> >  
> >  STATIC void
> > -xfs_buf_iodone_work(
> > -	struct work_struct	*work)
> > +xfs_buf_ioend(
> > +	struct xfs_buf	*bp)
> 
> Compile failure here due to STATIC.
> 
> >  {
> > -	struct xfs_buf		*bp =
> > -		container_of(work, xfs_buf_t, b_iodone_work);
> > -	bool			read = !!(bp->b_flags & XBF_READ);
> > +	bool		read = !!(bp->b_flags & XBF_READ);
> > +
> > +	trace_xfs_buf_iodone(bp, _RET_IP_);
> >  
> >  	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
> >  
> > -	/* only validate buffers that were read without errors */
> > -	if (read && bp->b_ops && !bp->b_error && (bp->b_flags & XBF_DONE))
> > -		bp->b_ops->verify_read(bp);
> > +	if (!bp->b_error) {
> > +		bp->b_flags |= XBF_DONE;
> > +
> > +		/* only validate buffers that were read without errors */
> > +		if (read && bp->b_ops)
> > +			bp->b_ops->verify_read(bp);
> > +	}
> 
> Probably not a cause of errors, but this code is now executed twice for
> I/O with b_iodone callbacks.

reads don't have b_iodone callbacks.

> Once for the initial call from bio_end_io,
> again from the callback via the b_iodone handler. The flags bits are
> probably fine, but we don't want to be running the verifiers multiple
> times unnecessarily.

Which we don't ;)

> > @@ -1425,10 +1412,12 @@ xfs_buf_iorequest(
> >  	 * waiting, and in the synchronous IO case it avoids unnecessary context
> >  	 * switches an latency for high-peformance devices.
> >  	 */
> > -	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
> > -		_xfs_buf_ioend(bp, 0);
> > -	else
> > -		_xfs_buf_ioend(bp, 1);
> > +	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
> > +		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
> > +			xfs_buf_ioend(bp);
> > +		else
> > +			xfs_buf_ioend_async(bp);
> > +	}
> 
> This looks cleaner, but the comment is out of whack at this point.

The code is functionally identical, so the comment didn't get
changed. As it is, the behaviour that exists in this patch goes away
in later patches, so it's mostly irrelevant that a comment is
absoultely correct in an intermediate point within the patch set.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
