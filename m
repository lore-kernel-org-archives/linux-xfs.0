Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NLee0G108358 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 16:40:40 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	UjHENqArHRGc2fkK for <xfs@oss.sgi.com>;
	Tue, 23 Oct 2012 14:42:23 -0700 (PDT)
Date: Wed, 24 Oct 2012 08:42:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 24/23] xfs: convert buffer verifiers to an ops structure.
Message-ID: <20121023214215.GP4291@dastard>
References: <1350020669-19504-1-git-send-email-david@fromorbit.com>
	<1350020669-19504-23-git-send-email-david@fromorbit.com>
	<20121013160212.GA24337@infradead.org>
	<20121014001219.GR2739@dastard> <20121018045028.GQ2739@dastard>
	<20121023123646.GJ7341@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121023123646.GJ7341@infradead.org>
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

On Tue, Oct 23, 2012 at 08:36:47AM -0400, Christoph Hellwig wrote:
> On Thu, Oct 18, 2012 at 03:50:28PM +1100, Dave Chinner wrote:
> > Here's a patch that does this. It adds on top of the series, and
> > points out more changes needed to growfs to support CRC checking
> > properly.
> 
> I like this a lot, and I'm fine with having this at the end of the
> series if it makes your life easier.

Ok, cool, I'll keep it this way for the moment, then. If, for some
reason, I decide I need to rework the series again, I'll reorder it
then, but for now I don't see that happening.

> > -xfs_agfl_write_verify(
> > +xfs_agfl_read_verify(
> >  	struct xfs_buf	*bp)
> >  {
> >  	xfs_agfl_verify(bp);
> >  }
> >  
> >  static void
> > -xfs_agfl_read_verify(
> > +xfs_agfl_write_verify(
> >  	struct xfs_buf	*bp)
> >  {
> >  	xfs_agfl_verify(bp);
> > -	bp->b_pre_io = xfs_agfl_write_verify;
> > -	bp->b_iodone = NULL;
> > -	xfs_buf_ioend(bp, 0);
> >  }
> 
> Any good reason to keep all these no-op wrappers?

I can remove them, but I'd just have to re-introduce them when CRC
checking is added. i.e. read will need to verify the CRC, write will
need to calculate it and inserting the value.

I don't mind either way at this point - I already had them so I kept
them in place, but it's relatively easy to remove them from this
patch and reapply them later (i.e. just add a temporary patch to the
series to remove them, copy it away, fold the temp patch into this
one so that this patch removes them, then later on reverse apply the
tmp patch to re-introduce the wrappers).

Either way, the read/write verifier functions will be there in the
end. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
