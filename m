Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBE5rgSY189645 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 23:53:42 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A155C121BAEA
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 15:28:19 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dEiEnhZagOvBZHim for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 15:28:19 -0800 (PST)
Date: Wed, 14 Dec 2011 10:28:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/11] xfs: cleanup xfs_file_aio_write
Message-ID: <20111213232817.GI3179@dastard>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155919.391725161@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111208155919.391725161@bombadil.infradead.org>
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

On Thu, Dec 08, 2011 at 10:58:06AM -0500, Christoph Hellwig wrote:
> With all the size field updates out of the way xfs_file_aio_write can
> be further simplified by pushing all iolock handling into
> xfs_file_dio_aio_write and xfs_file_buffered_aio_write and using
> the generic generic_write_sync helper for synchronous writes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me. The whole series cleans up the IO path nicely.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
