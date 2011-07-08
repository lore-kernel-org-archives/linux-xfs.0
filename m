Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p68AJILw233357 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 05:19:18 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3926517A5260
	for <xfs@oss.sgi.com>; Fri,  8 Jul 2011 03:19:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RSyIOR3AYd6YeL7p for <xfs@oss.sgi.com>;
	Fri, 08 Jul 2011 03:19:17 -0700 (PDT)
Date: Fri, 8 Jul 2011 20:19:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/28] xfs: re-enable non-blocking behaviour in
	xfs_map_blocks
Message-ID: <20110708101915.GK1026@dastard>
References: <20110707110535.205001532@bombadil.infradead.org>
	<20110707110640.863389024@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110707110640.863389024@bombadil.infradead.org>
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
Cc: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com

On Thu, Jul 07, 2011 at 07:05:37AM -0400, Christoph Hellwig wrote:
> The non-blockig behaviour in xfs_vm_writepage currently is conditional on
> having both the WB_SYNC_NONE sync_mode and the nonblocking flag set.
> The latter used to be used by both pdflush, kswapd and a few other places
> in older kernels, but has been fading out starting with the introduction
> of the per-bdi flusher threads.
> 
> Enable the non-blocking behaviour for all WB_SYNC_NONE calls to get back
> the behaviour we want.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Alex Elder <aelder@sgi.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
