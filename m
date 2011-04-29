Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3T0bS9o030389 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 19:37:29 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4627B1558B7F
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 17:41:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LNRohMXE21IozwXI for <xfs@oss.sgi.com>;
	Thu, 28 Apr 2011 17:41:01 -0700 (PDT)
Date: Fri, 29 Apr 2011 10:40:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] use write_cache_pages
Message-ID: <20110429004058.GT12436@dastard>
References: <20110428125546.696493391@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110428125546.696493391@bombadil.infradead.org>
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

On Thu, Apr 28, 2011 at 08:55:46AM -0400, Christoph Hellwig wrote:
> Replace our own handcrafted I/O clustering with the generic write_cache_pages
> helper.  While the old code would add any additional page in an existing
> mapping, the new code iterates over the pages, either adding them to
> a previous mapping if it fits or otherwise gets a new one.
> 
> This has survived xfsqa for small and 4k blocksize on x86.

I've had a quick look at the patches, and I can't see anything
obvious that jumps out at me with a big red flag. It look slike a
very neat optimisation and simplification. I'll do some testing on
them before doing a more robust review, though....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
