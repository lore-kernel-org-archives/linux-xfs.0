Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBLGhjji057238 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 10:43:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22C04212375
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 08:45:42 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id D8exaVpFcTx078zI for
	<xfs@oss.sgi.com>; Tue, 21 Dec 2010 08:45:42 -0800 (PST)
Date: Tue, 21 Dec 2010 11:45:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/34] xfs: don't truncate prealloc from frequently
	accessed inodes
Message-ID: <20101221164541.GA9093@infradead.org>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
	<1292916570-25015-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292916570-25015-8-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 21, 2010 at 06:29:03PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A long standing problem for streaming write?? through the NFS server
> has been that the NFS server opens and closes file descriptors on an
> inode for every write. The result of this behaviour is that the
> ->release() function is called on every close and that results in
> XFS truncating speculative preallocation beyond the EOF.  This has
> an adverse effect on file layout when multiple files are being
> written at the same time - they interleave their extents and can
> result in severe fragmentation.
> 
> To avoid this problem, keep a count of the number of ->release calls
> made on an inode. For most cases, an inode is only going to be opened
> once for writing and then closed again during it's lifetime in
> cache. Hence if there are multiple ->release calls, there is a good
> chance that the inode is being accessed by the NFS server. Hence
> count up every time ->release is called while there are delalloc
> blocks still outstanding on the inode.
> 
> If this count is non-zero when ->release is next called, then do no
> truncate away the speculative preallocation - leave it there so that
> subsequent writes do not need to reallocate the delalloc space. This
> will prevent interleaving of extents of different inodes written
> concurrently to the same AG.
> 
> If we get this wrong, it is not a big deal as we truncate
> speculative allocation beyond EOF anyway in xfs_inactive() when the
> inode is thrown out of the cache.

Looks good.

> The new counter in the struct xfs_inode fits into a hole in the
> structure on 64 bit machines, so does not grow the size of the inode
> at all.


There's no counter any more. (the text further above could also use some
minor updates for that)

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
