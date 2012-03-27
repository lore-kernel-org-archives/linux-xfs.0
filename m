Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2R1dHLn145802 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 20:39:17 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	j2cGBffJ1iHquXTL for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 18:39:15 -0700 (PDT)
Date: Tue, 27 Mar 2012 12:39:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: use shared ilock mode for direct IO writes by
	default
Message-ID: <20120327013913.GU5091@dastard>
References: <20120326211421.518374058@bombadil.infradead.org>
	<20120326211603.856796827@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120326211603.856796827@bombadil.infradead.org>
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

On Mon, Mar 26, 2012 at 05:14:26PM -0400, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For the direct IO write path, we only really need the ilock to be taken in
> exclusive mode during IO submission if we need to do extent allocation
> instaled of all the time.
> 
> Change the block mapping code to take the ilock in shared mode for the
> initial block mapping, and only retake it exclusively when we actually
> have to perform extent allocations.  We were already dropping the ilock
> for the transaction allocation, so this doesn't introduce new race windows.
> 
> Based on an earlier patch from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_aops.c  |   21 +++++++++++++++++----
>  fs/xfs/xfs_iomap.c |   45 +++++++++++++++++++--------------------------
>  2 files changed, 36 insertions(+), 30 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_aops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_aops.c	2012-03-26 21:06:52.184213212 +0200
> +++ xfs/fs/xfs/xfs_aops.c	2012-03-26 21:16:40.744358040 +0200
> @@ -1146,7 +1146,14 @@ __xfs_get_blocks(
>  	if (!create && direct && offset >= i_size_read(inode))
>  		return 0;
>  
> -	if (create) {
> +	/*
> +	 * Direct I/O is usually done on preallocated files, so try getting
> +	 * a block mapping without an exclusive lock first.  For buffer
                                                                 buffered

.....
> @@ -1169,22 +1176,28 @@ __xfs_get_blocks(
>  	     (imap.br_startblock == HOLESTARTBLOCK ||
>  	      imap.br_startblock == DELAYSTARTBLOCK))) {
>  		if (direct) {
> +			xfs_iunlock(ip, lockmode);
> +
>  			error = xfs_iomap_write_direct(ip, offset, size,
>  						       &imap, nimaps);
> +			if (error)
> +				return -error;
>  		} else {
>  			error = xfs_iomap_write_delay(ip, offset, size, &imap);
> +			if (error)
> +				goto out_unlock;
> +
> +			xfs_iunlock(ip, lockmode);

I'm not sure that I like the implicit different lock semantics here.
One function drops the lock first, the other requires the lock to be
held. Perhaps a comment is in order, such that direct IO requires
transactions for allocation here and hence will drop the lock to do
so and this avoids a needless lock round-trip?

Actually, when would we *ever* take the direct IO path when we have
imap.br_startblock == DELAYSTARTBLOCK? Buffered write regions are
supposed to have been flushed before the DIO write gets here.
Perhaps there should be an ASSERT(imap.br_startblock ==
HOLESTARTBLOCK) in the direct IO path.

Otherwise it looks OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
