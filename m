Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7Q0ISPW261646 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 19:18:28 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C7C0192CE1C
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 17:18:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zTiDAbUZ0xAcqjZs for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2011 17:18:27 -0700 (PDT)
Date: Fri, 26 Aug 2011 10:18:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: convert xfsbufd to use a workqueue
Message-ID: <20110826001824.GV3162@dastard>
References: <1314256626-11136-1-git-send-email-david@fromorbit.com>
	<1314256626-11136-7-git-send-email-david@fromorbit.com>
	<1314305839.3136.104.camel@doink> <20110825234656.GS3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110825234656.GS3162@dastard>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 26, 2011 at 09:46:56AM +1000, Dave Chinner wrote:
> On Thu, Aug 25, 2011 at 03:57:19PM -0500, Alex Elder wrote:
> > On Thu, 2011-08-25 at 17:17 +1000, Dave Chinner wrote:
> > > +/*
> > > + * Flush all the queued buffer work, then flush any remaining dirty buffers
> > > + * and wait for them to complete. If there are buffers remaining on the delwri
> > > + * queue, then they were pinned so couldn't be flushed. Return a value of 1 to
> > > + * indicate that there were pinned buffers and the caller needs to retry the
> > > + * flush.
> > > + */
> > > +int
> > > +xfs_flush_buftarg(
> > > +	xfs_buftarg_t	*target,
> > > +	int		wait)
> > 
> > Since this function now ignores its "wait" argument,
> > you could eliminate it, and perhaps get rid of the
> > one (first) call in xfs_quiesce_fs() that passes 0.
> 
> I'll leave that to a another patch.

Actually, I'll re-instate the existing wait semantics here.

In looking at this again I realised there is a race condition in the
flushing code - if work is already in progress, then the wq flush
won't start new work and hence won't see the force flag at all. So
the code needs changing anyway and the only time we need to set the
FORCE_FLUSH flag is when we are supposed to be waiting. Hence I'll
change it back to doing a non-blocking flush when the wait flag is
not set.

If we want to go to just a blocking flush, then we can change
everything in the one patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
