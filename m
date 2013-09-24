Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D4F2E7F37
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 15:32:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C263F304048
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 13:32:39 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	oFF5v6P3BXKpKFiq for <xfs@oss.sgi.com>;
	Tue, 24 Sep 2013 13:32:38 -0700 (PDT)
Date: Wed, 25 Sep 2013 06:32:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: don't try to mark uncached buffers stale on
	error.
Message-ID: <20130924203232.GA26872@dastard>
References: <1380002476-18839-1-git-send-email-david@fromorbit.com>
	<1380002476-18839-2-git-send-email-david@fromorbit.com>
	<20130924153324.GF1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130924153324.GF1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 24, 2013 at 10:33:24AM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Tue, Sep 24, 2013 at 04:01:12PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > fsstress failed during a shutdown with the following assert:
> > 
> > XFS: Assertion failed: xfs_buf_islocked(bp), file: fs/xfs/xfs_buf.c, line: 143
> > .....
> >  xfs_buf_stale+0x3f/0xf0
> >  xfs_bioerror_relse+0x2d/0x90
> >  xfsbdstrat+0x51/0xa0
> 
> Here you're showing an assert reported through an xfsbdstrat codepath...
> 
> >  xfs_zero_remaining_bytes+0x1d1/0x2d0
> >  xfs_free_file_space+0x5d0/0x600
> >  xfs_change_file_space+0x251/0x3a0
> >  xfs_ioc_space+0xcc/0x130
> > .....
> > 
> > xfs_zero_remaining_bytes() works with uncached buffers, and hence if
> > we are preventing IO due to a shutdown, we should not be marking it
> > stale as that is only for cached buffers. Instead, just mark it with
> > an error and make sure it gets to the caller.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c | 31 +++++++++++++++----------------
> >  1 file changed, 15 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 2634700..956685f 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1093,25 +1093,20 @@ xfs_bioerror_relse(
> >  	struct xfs_buf	*bp)
> >  {
> >  	int64_t		fl = bp->b_flags;
> > +
> >  	/*
> > -	 * No need to wait until the buffer is unpinned.
> > -	 * We aren't flushing it.
> > -	 *
> > -	 * chunkhold expects B_DONE to be set, whether
> > -	 * we actually finish the I/O or not. We don't want to
> > -	 * change that interface.
> > +	 * No need to wait until the buffer is unpinned. We aren't flushing it.
> >  	 */
> >  	XFS_BUF_UNREAD(bp);
> >  	XFS_BUF_DONE(bp);
> >  	xfs_buf_stale(bp);
> >  	bp->b_iodone = NULL;
> > +
> > +	/*
> > +	 * There's no reason to mark error for ASYNC buffers as there is no-one
> > +	 * waiting to collect the error.
> > +	 */
> >  	if (!(fl & XBF_ASYNC)) {
> > -		/*
> > -		 * Mark b_error and B_ERROR _both_.
> > -		 * Lot's of chunkcache code assumes that.
> > -		 * There's no reason to mark error for
> > -		 * ASYNC buffers.
> > -		 */
> >  		xfs_buf_ioerror(bp, EIO);
> >  		complete(&bp->b_iowait);
> >  	} else {
> > @@ -1128,11 +1123,15 @@ xfs_bdstrat_cb(
> >  	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> >  		trace_xfs_bdstrat_shut(bp, _RET_IP_);
> >  		/*
> > -		 * Metadata write that didn't get logged but
> > -		 * written delayed anyway. These aren't associated
> > -		 * with a transaction, and can be ignored.
> > +		 * If this is a cached write, then it is likely to be a delayed
> > +		 * write metadata buffer that can be ignored because the
> > +		 * contents are logged. If it's an uncached buffer or a read
> > +		 * operation, then the caller will get the error through the
> > +		 * normal IO completion path. We can tell if the buffer is
> > +		 * cached or not by looking to see if the b_pag field is NULL or
> > +		 * not.
> >  		 */
> > -		if (!bp->b_iodone && !XFS_BUF_ISREAD(bp))
> > +		if (!bp->b_iodone && !XFS_BUF_ISREAD(bp) && bp->b_pag)
> 
> ...but it looks like your fix is in xfs_bdstrat_cb, which wouldn't have been
> involved in the stack you posted above.  What am I missing?

That the first hunk that changes xfs_bioerror_relse() fixes the bug
that caused the assert failure through xfsbdstrat().

However, if we issue the uncached IO through bwrite() rather than
xfsbdstrat() directly, we need to fix xfs_bdstrat_cb() to handle
uncached buffers appropriately.

i.e. there are multiple IO path call-chain and they all need to call
the correct error handler for uncached buffers....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
