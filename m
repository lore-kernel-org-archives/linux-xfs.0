Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3T177fg032091 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 20:07:07 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 554181B7F522
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 18:10:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2zWjhG9MtdRDcUuA for <xfs@oss.sgi.com>;
	Thu, 28 Apr 2011 18:10:40 -0700 (PDT)
Date: Fri, 29 Apr 2011 11:10:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: exact busy extent tracking
Message-ID: <20110429011035.GW12436@dastard>
References: <20110424190613.404786382@bombadil.infradead.org>
	<20110424190657.064969622@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110424190657.064969622@bombadil.infradead.org>
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

On Sun, Apr 24, 2011 at 03:06:16PM -0400, Christoph Hellwig wrote:
> Update the extent tree in case we have to reuse a busy extent, so that it
> always is kept uptodate.  This is done by replacing the busy list searches
> with a new xfs_alloc_busy_reuse helper, which updates the busy extent tree
> in case of a reuse.  This allows us to allow reusing metadata extents
> unconditionally, and thus avoid log forces especially for allocation btree
> blocks.

I'd add one comment to this - that this returns to the old way of
clearing busy extents by issuing a sync log force with the AGF
locked. This can cause additional allocation latency, but should be
rare given the occurrence of of metadata->data reallocation.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alex Elder <aelder@sgi.com>

Otherwise,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
