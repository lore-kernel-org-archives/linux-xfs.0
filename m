Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TL4sCS183130 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 16:04:54 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZwH4X3lFXeImuGFN for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 14:04:52 -0700 (PDT)
Date: Fri, 30 Mar 2012 08:04:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix buffer lookup race on allocation failure
Message-ID: <20120329210449.GB692@dastard>
References: <1333022846-12697-1-git-send-email-david@fromorbit.com>
	<20120329190759.GA8622@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120329190759.GA8622@infradead.org>
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

On Thu, Mar 29, 2012 at 03:07:59PM -0400, Christoph Hellwig wrote:
> I don't like this solution.  What speaks against building up the page
> array after the first buffer lookup failed, but before linking the
> buffer into the rbtree? That's the the inode cache and all the VFS
> caches do.

That could be done, I think. I always wondered why it was done after
insert, but never knew the reason so I didn't change the logic. I'll
respin it and see what happens.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
