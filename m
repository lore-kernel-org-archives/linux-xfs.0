Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QMG2Bp103114 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 17:16:02 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1MssztmTxkXU7vpz for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 15:16:01 -0700 (PDT)
Date: Tue, 27 Mar 2012 09:15:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: reduce ilock hold times in
	xfs_file_aio_write_checks
Message-ID: <20120326221559.GQ5091@dastard>
References: <20120326211421.518374058@bombadil.infradead.org>
	<20120326211603.268269812@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120326211603.268269812@bombadil.infradead.org>
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

On Mon, Mar 26, 2012 at 05:14:23PM -0400, Christoph Hellwig wrote:
> We do not need the ilock for generic_write_checks and the i_size read,
> which are protected by i_mutex and/or iolock, so reduce the ilock
> critical section to just the call to xfs_zero_eof.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That answers one of the open questions I had about my patch -
whether we needed to hold the ilock at all over
generic_write_checks(). I wasn't 100% sure, but this patch confirms
my thinking on it.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
