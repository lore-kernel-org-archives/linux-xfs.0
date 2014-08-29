Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F05977F86
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 20:12:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D07AF304051
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 18:12:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	K6BLmZ5yXJ8Rqp28 for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 18:12:38 -0700 (PDT)
Date: Fri, 29 Aug 2014 11:12:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/9] xfs: kill xfs_bioerror_relse
Message-ID: <20140829011236.GB20518@dastard>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-7-git-send-email-david@fromorbit.com>
	<20140829003257.GF17502@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140829003257.GF17502@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Aug 28, 2014 at 05:32:57PM -0700, Christoph Hellwig wrote:
> > index 96c898e..758c07d 100644
> > --- a/fs/xfs/xfs_trans_buf.c
> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -324,11 +324,13 @@ xfs_trans_read_buf_map(
> >  			 */
> >  			if (XFS_FORCED_SHUTDOWN(mp)) {
> >  				trace_xfs_bdstrat_shut(bp, _RET_IP_);
> > -				xfs_bioerror_relse(bp);
> > -			} else {
> > -				xfs_buf_iorequest(bp);
> > +				bp->b_flags &= ~(XBF_READ | XBF_DONE);
> > +				xfs_buf_ioerror(bp, -EIO);
> > +				xfs_buf_stale(bp);
> > +				return -EIO;
> >  			}
> 
> This is a large change of behavior as it doesn't hit the error
> path after the xfs_buf_iowait anymore.  While I don't think that
> that path was entirely correct this version seems to be even less so
> by not releasing the buffer reference or forcing the shutdown.

The IO is synchronous, so the previous behaviour did not release
the buffer here. But, yes, it needs to because we're not running the
io wait on it anymore. And this happens only during a shutdown, so i
don't see any need to trigger a shutdown ;)

As it is, I think this gets properly fixed by the next patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
