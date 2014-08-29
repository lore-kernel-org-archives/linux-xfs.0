Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D22687F62
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 19:39:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A4C4AC001
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:39:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id OrD8m00d5PGvERlp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 17:39:34 -0700 (PDT)
Date: Thu, 28 Aug 2014 17:39:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] xfs: don't zero partial page cache pages during
	O_DIRECT writes
Message-ID: <20140829003934.GB30463@infradead.org>
References: <1409226551-16570-1-git-send-email-david@fromorbit.com>
	<1409226551-16570-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409226551-16570-3-git-send-email-david@fromorbit.com>
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

On Thu, Aug 28, 2014 at 09:49:06PM +1000, Dave Chinner wrote:
> From: Chris Mason <clm@fb.com>
> 
> xfs is using truncate_pagecache_range to invalidate the page cache
> during DIO reads.  This is different from the other filesystems who
> only invalidate pages during DIO writes.
> 
> truncate_pagecache_range is meant to be used when we are freeing the
> underlying data structs from disk, so it will zero any partial
> ranges in the page.  This means a DIO read can zero out part of the
> page cache page, and it is possible the page will stay in cache.
> 
> buffered reads will find an up to date page with zeros instead of
> the data actually on disk.
> 
> This patch fixes things by using invalidate_inode_pages2_range
> instead.  It preserves the page cache invalidation, but won't zero
> any pages.
> 
> [dchinner: catch error and warn if it fails. Comment.]

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
