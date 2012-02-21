Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1L4x6WW144681 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 22:59:07 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pkMoMTASY5YVukDp for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 20:59:05 -0800 (PST)
Date: Tue, 21 Feb 2012 15:58:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20120221045811.GJ3592@dastard>
References: <20120221003824.415885674@bombadil.infradead.org>
	<20120221003906.124899527@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120221003906.124899527@bombadil.infradead.org>
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

On Mon, Feb 20, 2012 at 07:38:25PM -0500, Christoph Hellwig wrote:
> The new concurrency managed workqueues are cheap enough that we can create
> per-filesystem instead of global workqueues.  This allows us to remove the
> trylock or defer scheme on the ilock, which is not helpful once we have
> outstanding log reservations until finishing a size update.
> 
> Also allow the default concurrency on this workqueues so that I/O completions
> blocking on the ilock for one inode do not block process for another inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
