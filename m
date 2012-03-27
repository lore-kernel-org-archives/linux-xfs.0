Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2R68fln205856 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 01:08:41 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	I0CjTXwG2eQpQfJs for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 23:08:39 -0700 (PDT)
Date: Tue, 27 Mar 2012 17:08:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] reduce exclusive ilock hold times
Message-ID: <20120327060837.GX5091@dastard>
References: <20120326211421.518374058@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120326211421.518374058@bombadil.infradead.org>
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

On Mon, Mar 26, 2012 at 05:14:21PM -0400, Christoph Hellwig wrote:
> This series tries to reduce the amount we hold the ilock exclusively,
> especially during direct I/O writes where they currently hurt us.
> 
> Dave showed that his earlier version which is less aggressive than this
> one can already provide magnitudes of better throughput and iops for
> parallel direct I/O workloads, and this one should be even better.

Shows the same results for the recent sysbench testing as my patch,
but that is CPU bound and so there is little scope for improvement.
It is showing about 4.9GB/s as the maximum write rate with 16k IOs.

I get similar results from the rrtest code that was previously used
to demonstrate this problem - it's showing about about 1.2 million
4k IOPS, which is about 4.8GB/s as well. I think that must be the
limit of what the ramdisk code can handle on my setup.

So the performance side of this works just fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
