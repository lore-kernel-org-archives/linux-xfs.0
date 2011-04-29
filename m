Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3T0cc88030449 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 19:38:38 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDDA741F116
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 17:42:11 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	C7rkVwCoChhYqmEH for <xfs@oss.sgi.com>;
	Thu, 28 Apr 2011 17:42:11 -0700 (PDT)
Date: Fri, 29 Apr 2011 10:41:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: optimize AGFL refills
Message-ID: <20110429004153.GU12436@dastard>
References: <20110424190613.404786382@bombadil.infradead.org>
	<20110424190656.644950888@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110424190656.644950888@bombadil.infradead.org>
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

On Sun, Apr 24, 2011 at 03:06:14PM -0400, Christoph Hellwig wrote:
> While we need to make sure we do not reuse busy extents, there is no need
> to force out busy extents when moving them between the AGFL and the
> freespace btree as we still take care of that when doing the real allocation.
> 
> To avoid the log force when just moving extents from the different free
> space tracking structures, move the busy search out of
> xfs_alloc_get_freelist into the callers that need it, and move the busy
> list insert from xfs_free_ag_extent which is used both by AGFL refills
> and real allocation to xfs_free_extent, which is only used by the latter.
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
