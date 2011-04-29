Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3T0stYI031482 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 19:54:56 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 726FE133965F
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 17:58:28 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mE6KkAB5Lw0q248R for <xfs@oss.sgi.com>;
	Thu, 28 Apr 2011 17:58:28 -0700 (PDT)
Date: Fri, 29 Apr 2011 10:58:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: do not immediately reuse busy extent ranges
Message-ID: <20110429005824.GV12436@dastard>
References: <20110424190613.404786382@bombadil.infradead.org>
	<20110424190656.849588824@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110424190656.849588824@bombadil.infradead.org>
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

On Sun, Apr 24, 2011 at 03:06:15PM -0400, Christoph Hellwig wrote:
> Every time we reallocate a busy extent, we cause a synchronous log force
> to occur to ensure the freeing transaction is on disk before we continue
> and use the newly allocated extent.  This is extremely sub-optimal as we
> have to mark every transaction with blocks that get reused as synchronous.
> 
> Instead of searching the busy extent list after deciding on the extent to
> allocate, check each candidate extent during the allocation decisions as
> to whether they are in the busy list.  If they are in the busy list, we
> trim the busy range out of the extent we have found and determine if that
> trimmed range is still OK for allocation. In many cases, this check can
> be incorporated into the allocation extent alignment code which already
> does trimming of the found extent before determining if it is a valid
> candidate for allocation.
> 
> Based on earlier patches from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alex Elder <aelder@sgi.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
