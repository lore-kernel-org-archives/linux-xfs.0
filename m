Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6K85udc008783 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 03:05:57 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1C64BEB18D
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 01:15:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	xh2dWV6LTGMs3qqt for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 01:15:36 -0700 (PDT)
Date: Tue, 20 Jul 2010 18:08:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs simplify and speed up direct I/O completions
Message-ID: <20100720080852.GN32635@dastard>
References: <20100718211708.327705876@bombadil.infradead.org>
	<20100718211820.739557136@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100718211820.739557136@bombadil.infradead.org>
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

On Sun, Jul 18, 2010 at 05:17:11PM -0400, Christoph Hellwig wrote:
> Our current handling of direct I/O completions is rather suboptimal,
> because we defer it to a workqueue more often than needed, and we
> perform a much to aggressive flush of the workqueue in case unwritten
> extent conversions happen.
> 
> This patch changes the direct I/O reads to not even use a completion
> handler, as we don't bother to use it at all, and to perform the unwritten
> extent conversions in caller context for synchronous direct I/O.
> 
> For a small I/O size direct I/O workload on a consumer grade SSD, such as
> the untar of a kernel tree inside qemu this patch gives speedups of
> about 5%.  Getting us much closer to the speed of a native block device,
> or a fully allocated XFS file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks a lot saner - getting rid of the workqueue flushes is a good
thing.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
