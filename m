Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3BK8ObH106375 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 15:08:24 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	yIk7O1xvR88NalIW (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Apr 2012 13:08:22 -0700 (PDT)
Date: Wed, 11 Apr 2012 16:08:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] xfs: More xfs_buf cleanups
Message-ID: <20120411200821.GK28816@infradead.org>
References: <1334052213-26870-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1334052213-26870-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 10, 2012 at 08:03:30PM +1000, Dave Chinner wrote:
> These 3 patches sit on top of my recent series titled:
> 
> [PATCH 0/8] xfs: clean up unit usage in xfs_buf V2
> 
> These patches remove bits of the API that are effectively the
> default behaviour used by everything or are redundant. This just
> makes API usage simpler and gives it a smaller footprint to modify
> in future.

If you touch these interfaces any chance you could kill the impliciy
XBF_MAPPED thing we do in various places?  Probably best by reversing
it and only pass in an XBF_UNMAPPED for the inode buffers as that's
the only place where we want them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
