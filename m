Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TLATua183612 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 16:10:29 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XrG9MGFgIfX1JHB6 for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 14:10:27 -0700 (PDT)
Date: Fri, 30 Mar 2012 08:10:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] xfs: check for buffer errors before waiting
Message-ID: <20120329211025.GD692@dastard>
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
	<1333023835-12856-2-git-send-email-david@fromorbit.com>
	<4F74B229.6030707@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F74B229.6030707@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 29, 2012 at 02:04:09PM -0500, Mark Tinguely wrote:
> On 03/29/12 07:23, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >If we call xfs_buf_iowait() on a buffer that failed dispatch due to
> >an IO error, it will wait forever for an Io that does not exist.
> >This is hndled in xfs_buf_read, but there is other code that calls
> >xfs_buf_iowait directly that doesn't.
> >
> >Rather than make the call sites have to handle checking for dispatch
> >errors and then checking for completion errors, make
> >xfs_buf_iowait() check for dispatch errors on the buffer before
> >waiting. This means we handle both dispatch and completion errors
> >with one set of error handling at the caller sites.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> >diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> >index 396e3bf..64ed6ff 100644
> >--- a/fs/xfs/xfs_log_recover.c
> >+++ b/fs/xfs/xfs_log_recover.c
> >@@ -179,6 +179,7 @@ xlog_bread_noalign(
> >  	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
> >  	XFS_BUF_READ(bp);
> >  	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
> >+	bp->b_error = 0;
> >
> >  	xfsbdstrat(log->l_mp, bp);
> >  	error = xfs_buf_iowait(bp);
> >@@ -266,6 +267,7 @@ xlog_bwrite(
> >  	xfs_buf_hold(bp);
> >  	xfs_buf_lock(bp);
> >  	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
> >+	bp->b_error = 0;
> >
> >  	error = xfs_bwrite(bp);
> >  	if (error)
> 
> Just curious, were these needed for a particular reason?

If the previous user of the buffer got an error, it is not
guaranteed to be cleared because the buffer is not re-initialised.
i.e. it's an uncached buffer that we control completely and reuse
from IO to IO with just a reset of the bno and length. If b_error is
non zero here, then the IO can fail because nothing else clears the
error in the dispatch path....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
