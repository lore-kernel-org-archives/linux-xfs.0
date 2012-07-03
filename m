Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q630RbAw030319 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 19:27:38 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ABENPsURRLCy1iSo for <xfs@oss.sgi.com>;
	Mon, 02 Jul 2012 17:27:36 -0700 (PDT)
Date: Tue, 3 Jul 2012 10:27:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: prevent recursion in xfs_buf_iorequest
Message-ID: <20120703002716.GX19223@dastard>
References: <20120702100003.960640484@bombadil.infradead.org>
	<20120702100034.627510436@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120702100034.627510436@bombadil.infradead.org>
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

On Mon, Jul 02, 2012 at 06:00:04AM -0400, Christoph Hellwig wrote:
> If the b_iodone handler is run in calling context in xfs_buf_iorequest we
> can run into a recursion where xfs_buf_iodone_callbacks keeps calling back
> into xfs_buf_iorequest because an I/O error happened, which keeps calling
> back into xfs_buf_iorequest.  This chain will usually not take long
> because the filesystem gets shut down because of log I/O errors, but even
> over a short time it can cause stack overflows if run on the same context.
> 
> As a short term workaround make sure we always call the iodone handler in
> workqueue context.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine - final completion from io submission is a rare case so
this shouldn't cause issues....

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
