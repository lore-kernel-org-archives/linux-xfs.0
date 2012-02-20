Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1KLXRqd110801 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 15:33:28 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iZqCV166c3mbMaKB for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 13:33:25 -0800 (PST)
Date: Tue, 21 Feb 2012 08:33:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8] xfs: use common code for quota statistics
Message-ID: <20120220213322.GC3592@dastard>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.060961294@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120220022904.060961294@bombadil.infradead.org>
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

On Sun, Feb 19, 2012 at 09:28:19PM -0500, Christoph Hellwig wrote:
> Switch the quota code over to use the generic XFS statistics infrastructure.
> While the legacy /proc/fs/xfs/xqm and /proc/fs/xfs/xqmstats interfaces are
> preserved for now the statistics that still have a meaning with the current
> code are now also available from /proc/fs/xfs/stats.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK. Just one question/observation, though. This will make the
quota proc files show up even even quota is not compiled in. Are
there any applications out there that make use of the presence of
these files to determine if quota is configured into the kernel or
not?

I think I just answered my own question - xfstests does exactly this
proc file test in _require_quota(). So I think their presence needs
to be conditional on CONFIG_XFS_QUOTA....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
