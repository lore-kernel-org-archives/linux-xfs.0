Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DLlfh2074342 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 16:47:42 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Nyy7gwJNFfBcl8JV for <xfs@oss.sgi.com>;
	Tue, 13 Mar 2012 14:47:40 -0700 (PDT)
Date: Wed, 14 Mar 2012 08:47:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: use common code for quota statistics
Message-ID: <20120313214738.GG5091@dastard>
References: <20120313085232.134690907@bombadil.infradead.org>
	<20120313085308.452328219@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313085308.452328219@bombadil.infradead.org>
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

On Tue, Mar 13, 2012 at 04:52:33AM -0400, Christoph Hellwig wrote:
> Switch the quota code over to use the generic XFS statistics infrastructure.
> While the legacy /proc/fs/xfs/xqm and /proc/fs/xfs/xqmstats interfaces are
> preserved for now the statistics that still have a meaning with the current
> code are now also available from /proc/fs/xfs/stats.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
