Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B42BF7F62
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 19:39:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 422B9AC003
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:39:53 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id KcnnbWyS12kceJiQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 17:39:52 -0700 (PDT)
Date: Thu, 28 Aug 2014 17:39:51 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] xfs: don't zero partial page cache pages during
	O_DIRECT writes
Message-ID: <20140829003951.GC30463@infradead.org>
References: <1409226551-16570-1-git-send-email-david@fromorbit.com>
	<1409226551-16570-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409226551-16570-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 28, 2014 at 09:49:07PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Similar to direct IO reads, direct IO writes are using
> truncate_pagecache_range to invalidate the page cache. This is
> incorrect due to the sub-block zeroing in the page cache that
> truncate_pagecache_range() triggers.
> 
> This patch fixes things by using invalidate_inode_pages2_range
> instead.  It preserves the page cache invalidation, but won't zero
> any pages.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
