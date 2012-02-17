Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1H2jOHZ044437 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 20:45:25 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	45zl0STDGQwKX0Pn for <xfs@oss.sgi.com>;
	Thu, 16 Feb 2012 18:45:23 -0800 (PST)
Date: Fri, 17 Feb 2012 13:45:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: only take the ILOCK in xfs_reclaim_inode()
Message-ID: <20120217024521.GG14132@dastard>
References: <1329429660.16207.19.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1329429660.16207.19.camel@doink>
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
To: Alex Elder <elder@dreamhost.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 16, 2012 at 04:01:00PM -0600, Alex Elder wrote:
> At the end of xfs_reclaim_inode(), the inode is locked in order to
> we wait for a possible concurrent lookup to complete before the
> inode is freed.  This synchronization step was taking both the ILOCK
> and the IOLOCK, but the latter was causing lockdep to produce
> reports of the possibility of deadlock.
> 
> It turns out that there's no need to acquire the IOLOCK at this
> point anyway.  It may have been required in some earlier version of
> the code, but there should be no need to take the IOLOCK in
> xfs_iget(), so there's no (longer) any need to get it here for
> synchronization.  Add an assertion in xfs_iget() as a reminder
> of this assumption.
> 
> Dave Chinner diagnosed this on IRC, and Christoph Hellwig suggested
> no longer including the IOLOCK.  I just put together the patch.
> 
> Signed-off-by: Alex Elder <elder@dreamhost.com>

The code and comments is almost identical to the patch I've been
testing over the past day, so consider it

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
