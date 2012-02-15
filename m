Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FNxYQB213426 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 17:59:34 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	eV5MkOcRyosLIkID for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 15:59:32 -0800 (PST)
Date: Thu, 16 Feb 2012 10:59:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/9] xfs: use per-CPU data for the quota statistics
Message-ID: <20120215235929.GP14132@dastard>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023147.414783335@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215023147.414783335@bombadil.infradead.org>
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

On Tue, Feb 14, 2012 at 09:29:30PM -0500, Christoph Hellwig wrote:
> Use the same per-CPU scheme used in the main XFS statistics, as well as
> the VFS inode and dcache statistics for the quota code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

.....

> -struct xqmstats xqmstats;
> +DEFINE_PER_CPU(struct xqmstats, xqmstats);
> +
> +static int xqmstats_sum(int idx)
> +{
> +	int val = 0, cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		val += *(((__u32 *)&per_cpu(xqmstats, cpu) + idx));
> +	return max(val, 0);
> +}

Why not just make val a 64bit value so overflow is simply not an
issue?

Otherwise, all looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
