Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AFCE129DF9
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 18:28:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D2968F8078
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 16:28:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	W1CCTfJm4SohxvC2 for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 16:28:06 -0700 (PDT)
Date: Sat, 16 Aug 2014 09:27:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] xfs: xfs_bioerror can die.
Message-ID: <20140815232741.GW26465@dastard>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-6-git-send-email-david@fromorbit.com>
	<20140815143540.GD4096@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815143540.GD4096@laptop.bfoster>
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

On Fri, Aug 15, 2014 at 10:35:41AM -0400, Brian Foster wrote:
> On Fri, Aug 15, 2014 at 04:39:03PM +1000, Dave Chinner wrote:
> > @@ -1149,19 +1119,19 @@ xfs_bwrite(
> >  	ASSERT(xfs_buf_islocked(bp));
> >  
> >  	bp->b_flags |= XBF_WRITE;
> > -	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q | XBF_WRITE_FAIL);
> > +	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
> > +			 XBF_WRITE_FAIL | XBF_DONE);
> >  
> >  	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
> >  		trace_xfs_bdstrat_shut(bp, _RET_IP_);
> >  
> > -		/*
> > -		 * Metadata write that didn't get logged but written anyway.
> > -		 * These aren't associated with a transaction, and can be
> > -		 * ignored.
> > -		 */
> > -		if (!bp->b_iodone)
> > -			return xfs_bioerror_relse(bp);
> > -		return xfs_bioerror(bp);
> > +		xfs_buf_ioerror(bp, -EIO);
> > +		xfs_buf_stale(bp);
> > +
> > +		/* sync IO, xfs_buf_ioend is going to remove a ref here */
> > +		xfs_buf_hold(bp);
> 
> Looks correct, but that's kind of ugly. The reference serves no purpose
> except to appease the error sequence. It gives the impression that the
> reference management should be handled at a higher level (and with truly
> synchronous I/O primitives/mechanisms, it is ;).

Oh, yeah, it's nasty ugly, but that goes away with patch 8. This is
just a temporary state that then gets factored neatly when the new
interfaces are introduced.

> At the very least, can we reorganize the ioend side of things to handle
> this? We already have the duplicate execution issue previously mentioned
> that has to get resolved. Some duplicate code is fine if it improves
> clarity, imo.

patch 8 does that - this is just preparing the code for being easy
to factor.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
