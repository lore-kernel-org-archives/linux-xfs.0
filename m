Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1L4fUWF143944 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 22:41:31 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	l3qUjt4tppi2QcGl for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 20:41:28 -0800 (PST)
Date: Tue, 21 Feb 2012 15:41:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8 v2] xfs: use common code for quota statistics
Message-ID: <20120221044124.GH3592@dastard>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.060961294@bombadil.infradead.org>
	<20120221014809.GA18227@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120221014809.GA18227@infradead.org>
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

On Mon, Feb 20, 2012 at 08:48:09PM -0500, Christoph Hellwig wrote:
> Switch the quota code over to use the generic XFS statistics infrastructure.
> While the legacy /proc/fs/xfs/xqm and /proc/fs/xfs/xqmstats interfaces are
> preserved for now the statistics that still have a meaning with the current
> code are now also available from /proc/fs/xfs/stats.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
