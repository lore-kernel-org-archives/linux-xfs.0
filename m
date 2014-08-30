Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93AFA7FAF
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 19:05:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21A17AC001
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 17:05:51 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4wgSd8smx6vkSpAJ for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 17:05:49 -0700 (PDT)
Date: Sat, 30 Aug 2014 10:05:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/9] xfs: kill xfs_bioerror_relse
Message-ID: <20140830000547.GG20518@dastard>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-7-git-send-email-david@fromorbit.com>
	<20140829003257.GF17502@infradead.org>
	<20140829011236.GB20518@dastard>
	<20140829182610.GA28670@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140829182610.GA28670@infradead.org>
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

On Fri, Aug 29, 2014 at 11:26:10AM -0700, Christoph Hellwig wrote:
> On Fri, Aug 29, 2014 at 11:12:36AM +1000, Dave Chinner wrote:
> > > This is a large change of behavior as it doesn't hit the error
> > > path after the xfs_buf_iowait anymore.  While I don't think that
> > > that path was entirely correct this version seems to be even less so
> > > by not releasing the buffer reference or forcing the shutdown.
> > 
> > The IO is synchronous, so the previous behaviour did not release
> > the buffer here. But, yes, it needs to because we're not running the
> > io wait on it anymore. And this happens only during a shutdown, so i
> > don't see any need to trigger a shutdown ;)
> > 
> > As it is, I think this gets properly fixed by the next patch....
> 
> Do you have any scenario that might actually exercise this path?  I
> enabled xfs_trans_read_buf_io trace events and run xfstests as well
> as a few other workloads and couldn't hit it at all.  And when you
> think of it: when would be do a trans_get_buf, then not actually
> updating it with data and then recurse into a trans_read_buf in
> the same transaction?

*nod*. This path has been there is the Irix days, and I suspect that
it was there to handle some wierd corner case to do with async
buffer reads which IIRC, could once be done through this code...

> Maybe it's just time do a bit more of an audit and put this whole
> code path to rest.

Perhaps so.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
