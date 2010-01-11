Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BAIx3X129798 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 04:18:59 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B2171C40DDB
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 02:19:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yPdWtCRmfeFQFKl9 for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 02:19:54 -0800 (PST)
Date: Mon, 11 Jan 2010 05:19:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: reclaim all inodes by background tree walks
Message-ID: <20100111101953.GC26465@infradead.org>
References: <1263167508-9346-1-git-send-email-david@fromorbit.com>
	<1263167508-9346-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263167508-9346-4-git-send-email-david@fromorbit.com>
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

On Mon, Jan 11, 2010 at 10:51:47AM +1100, Dave Chinner wrote:
> We cannot do direct inode reclaim without taking the flush lock to
> ensure that we do not reclaim an inode under IO. We check the inode
> is clean before doing direct reclaim, but this is not good enough
> because the inode flush code marks the inode clean once it has
> copied the in-core dirty state to the backing buffer.
> 
> It is the flush lock that determines whether the inode is still
> under IO, even though it is marked clean, and the inode is still
> required at IO completion so we can't reclaim it even though it is
> clean in core. Hence the requirement that we need to take the
> flush lock even on clean inodes because this guarantees that the
> inode writeback IO has completed and it is safe to reclaim the
> inode.
> 
> With delayed write inode flushing, we coul dend up waiting a long
> time on the flush lock even for a clean inode. The background
> reclaim already handles this efficiently, so avoid all the problems
> by killing the direct reclaim path altogether.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
