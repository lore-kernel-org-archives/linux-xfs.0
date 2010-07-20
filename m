Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6K7uF9T008425 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 02:56:16 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D040615EE301
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 00:59:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	JoDNMgXWsI8Ws1oK for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 00:59:14 -0700 (PDT)
Date: Tue, 20 Jul 2010 17:59:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: move aio completion after unwritten extent
	conversion
Message-ID: <20100720075911.GM32635@dastard>
References: <20100718211708.327705876@bombadil.infradead.org>
	<20100718211820.396601078@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100718211820.396601078@bombadil.infradead.org>
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

On Sun, Jul 18, 2010 at 05:17:10PM -0400, Christoph Hellwig wrote:
> If we write into an unwritten extent using AIO we need to complete the AIO
> request after the extent conversion has finished.  Without that a read could
> race to see see the extent still unwritten and return zeros.   For synchronous
> I/O we already take care of that by flushing the xfsconvertd workqueue (which
> might be a bit of overkill).
> 
> To do that add iocb and result fields to struct xfs_ioend, so that we can
> call aio_complete from xfs_end_io after the extent conversion has happened.
> Note that we need a new result field as io_error is used for positive errno
> values, while the AIO code can return negative error values and positive
> transfer sizes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
