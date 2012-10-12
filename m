Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9C2R0b6037564 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 21:27:00 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3z8aNTivZhgYyUed for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 19:28:32 -0700 (PDT)
Date: Fri, 12 Oct 2012 13:28:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/19] xfs: uncached buffer reads need to return an error
Message-ID: <20121012022829.GL2739@dastard>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
	<1349754670-32009-4-git-send-email-david@fromorbit.com>
	<20121011213802.GC6346@infradead.org>
	<20121011221137.GJ2739@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121011221137.GJ2739@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Oct 12, 2012 at 09:11:37AM +1100, Dave Chinner wrote:
> On Thu, Oct 11, 2012 at 05:38:02PM -0400, Christoph Hellwig wrote:
> > > index 917e121..dee14eb 100644
> > > --- a/fs/xfs/xfs_fsops.c
> > > +++ b/fs/xfs/xfs_fsops.c
> > > @@ -149,6 +149,11 @@ xfs_growfs_data_private(
> > >  				XFS_FSS_TO_BB(mp, 1), 0, NULL);
> > >  	if (!bp)
> > >  		return EIO;
> > > +	if (bp->b_error) {
> > > +		int	error = bp->b_error;
> > > +		xfs_buf_relse(bp);
> > > +		return error;
> > > +	}
> > >  	xfs_buf_relse(bp);
> > 
> > > +	if (bp->b_error) {
> > > +		error = bp->b_error;
> > > +		if (loud)
> > > +			xfs_warn(mp, "SB validate failed");
> > > +		goto release_buf;
> > > +	}
> > 
> > > +	if (bp->b_error) {
> > > +		error = bp->b_error;
> > > +		xfs_buf_relse(bp);
> > > +		return error;
> > > +	}
> > 
> > > +	if (!bp || bp->b_error) {
> > >  		xfs_warn(mp, "realtime device size check failed");
> > > +		if (bp)
> > > +			xfs_buf_relse(bp);
> > >  		return EIO;
> > >  	}
> > >  	xfs_buf_relse(bp);
> > 
> > It seems like all these callers would be a lot cleaner if we'd just
> > return the error as the return value, and a buffer as an indirect
> > pointer if and only if the read succeeded.
> 
> The number of callers is relatively small, and the knock-on effect
> through the subsequent patches isn't that bad, so changing the
> interface is probably the right thing to do here. I'll rework this
> patch appropriately.

Then again, maybe I won't. I just remembered the main reason for
returning a buffer with an error set on it. That is that there are
circumstances in which we might want to attempt repair of a buffer
that failed verification, and we cannot do that without returning
the buffer.

So even if we return the buffer as an indirect pointer, we'd still
need to return it when particular types of errors are detected on
the buffer (i.e. EFSCORRUPTED from the verifier). Hence the error
handling in xfs_buf_read_uncached() would become more complex and
difficult to get right (e.g. different EIO vs EFSCORRUPTED vs ...
handling) and it wouldn't simplify the error handling at the call
site, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
