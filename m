Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAT1pr7N242846 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 19:51:53 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZaF7aw9vZ4rHG5qV for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 17:54:09 -0800 (PST)
Date: Thu, 29 Nov 2012 12:54:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: byte range granularity for XFS_IOC_ZERO_RANGE
Message-ID: <20121129015406.GX6434@dastard>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-3-git-send-email-david@fromorbit.com>
	<20121128133305.GA7426@infradead.org>
	<20121129000655.GA6673@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121129000655.GA6673@infradead.org>
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

On Wed, Nov 28, 2012 at 07:06:55PM -0500, Christoph Hellwig wrote:
> Actually this seems to trip up an assert in xfstests 290 for me:
> 
> 290 0s ...[   45.997814] XFS: Assertion failed: offset + len <= start_boundary || offset == start_boundary, file: fs/xfs/xfs_vnodeops.c, line: 2153

Yes, i got that in one of my overnight QA runs. Haven't had a chance
to debug it yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
