Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAT4GVMk258986 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 22:16:31 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AyYgVTnf7uuU4F7l for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 20:18:47 -0800 (PST)
Date: Thu, 29 Nov 2012 15:18:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: byte range granularity for XFS_IOC_ZERO_RANGE
Message-ID: <20121129041844.GZ6434@dastard>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-3-git-send-email-david@fromorbit.com>
	<20121128133305.GA7426@infradead.org>
	<20121129000655.GA6673@infradead.org>
	<20121129015406.GX6434@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121129015406.GX6434@dastard>
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

On Thu, Nov 29, 2012 at 12:54:06PM +1100, Dave Chinner wrote:
> On Wed, Nov 28, 2012 at 07:06:55PM -0500, Christoph Hellwig wrote:
> > Actually this seems to trip up an assert in xfstests 290 for me:
> > 
> > 290 0s ...[   45.997814] XFS: Assertion failed: offset + len <= start_boundary || offset == start_boundary, file: fs/xfs/xfs_vnodeops.c, line: 2153
> 
> Yes, i got that in one of my overnight QA runs. Haven't had a chance
> to debug it yet.

Ok, I've decided that the ASSERT is simply bogus. It was there
because I initially thought that this breanch woul dbe taken for
sub-page zeroing. In fact, it's not just sub-page zeroing - the
region can span two sub-pages. i.e.:

	0           4096	  8192
	+------o------+-------------+
	       |----len------|

In this case, offset is 4095, len = 4096, resulting in start/end =
4096. Hence we trigger the pure zeroing branch , and off+len is
clearly greater then start or end....

This is why I put the ASSERT in there, anyway - to validate that my
assumptions that lead to having that branch were correct. Turns out
the assumption was wrong but the code is correct for both cases, so
I'm just going to remove the ASSERT now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
