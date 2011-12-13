Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBD2ZIrL133619 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 20:35:18 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A00E82BA1F5
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 18:35:16 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	feMscZo4RR3FGIdW for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 18:35:16 -0800 (PST)
Date: Tue, 13 Dec 2011 13:35:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/12] repair: fix another ABBA deadlock in inode
	prefetching
Message-ID: <20111213023514.GA14273@dastard>
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174742.307774458@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202174742.307774458@bombadil.infradead.org>
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

On Fri, Dec 02, 2011 at 12:46:26PM -0500, Christoph Hellwig wrote:
> The inode prefetching code has a fixed limit of inodes that might are
> submitted at a time.  Unfortunately the buffers for them get locked
> once the prefetching starts.  That way the threads processing the inode
> might get stuck on buffer locked, but not submitted for reading yet.
> 
> Fix this by kicking the queue as soon as we would have to wait on the
> ra_count semaphore.
> 
> Reported-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
> Tested-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks safe - I can't think up a scenario that would deadlock on
the second sem_wait call...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
