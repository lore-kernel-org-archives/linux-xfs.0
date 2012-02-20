Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1KMFCHx113499 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 16:15:12 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dkJMlFt7Nhvq1Q8Q for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 14:15:11 -0800 (PST)
Date: Tue, 21 Feb 2012 09:15:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/8] xfs: remove the per-filesystem list of dquots
Message-ID: <20120220221509.GE3592@dastard>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.615605871@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120220022904.615605871@bombadil.infradead.org>
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

On Sun, Feb 19, 2012 at 09:28:22PM -0500, Christoph Hellwig wrote:
> Instead of keeping a separate per-filesystem list of dquots we can walk
> the radix tree for the two places where we need to iterate all quota
> structures.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Still a bit of a lookup vs iterate hold-off remaining, but I think
we can live with the reduction now. If it proves to be a noticable
problem then we can look towards RCU based lookups, I think.
Otherwise it looks OK to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
