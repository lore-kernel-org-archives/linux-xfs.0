Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DC2jrR036697 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 07:02:45 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PNVcULA3uHGDpiMU for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 05:02:43 -0700 (PDT)
Date: Fri, 13 Apr 2012 22:02:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: More xfs_buf cleanups
Message-ID: <20120413120242.GQ6734@dastard>
References: <1334052213-26870-1-git-send-email-david@fromorbit.com>
	<20120411200821.GK28816@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120411200821.GK28816@infradead.org>
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

On Wed, Apr 11, 2012 at 04:08:22PM -0400, Christoph Hellwig wrote:
> On Tue, Apr 10, 2012 at 08:03:30PM +1000, Dave Chinner wrote:
> > These 3 patches sit on top of my recent series titled:
> > 
> > [PATCH 0/8] xfs: clean up unit usage in xfs_buf V2
> > 
> > These patches remove bits of the API that are effectively the
> > default behaviour used by everything or are redundant. This just
> > makes API usage simpler and gives it a smaller footprint to modify
> > in future.
> 
> If you touch these interfaces any chance you could kill the impliciy
> XBF_MAPPED thing we do in various places?  Probably best by reversing
> it and only pass in an XBF_UNMAPPED for the inode buffers as that's
> the only place where we want them.

Sounds like a good idea. I'll write a patch to do this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
