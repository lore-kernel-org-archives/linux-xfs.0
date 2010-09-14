Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EGT93O135672 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 11:29:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA5B1710A1
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:27:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aZl1CKHgqrGYmTjI for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:27:44 -0700 (PDT)
Date: Tue, 14 Sep 2010 12:27:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/18] xfs: convert inode cache lookups to use RCU locking
Message-ID: <20100914162742.GA18185@infradead.org>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284461777-1496-6-git-send-email-david@fromorbit.com>
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

On Tue, Sep 14, 2010 at 08:56:04PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With delayed logging greatly increasing the sustained parallelism of inode
> operations, the inode cache locking is showing significant read vs write
> contention when inode reclaim runs at the same time as lookups. There is
> also a lot more write lock acquistions than there are read locks (4:1 ratio)
> so the read locking is not really buying us much in the way of parallelism.

That's just for your parallel creates workload, isn't it?  If we'd get
that bad hit rates on normal workloads something is pretty wrong with
the inode cache.

For a workload with 4 times as many writelocks just changing the
rwlock to a spinlock should provide more benefits.  Did you test what
effect this has on other workloads?

In addition to that I feel really uneasy about changes to the inode
cache locking without really heavy NFS server testing - we just had too
many issues in this area in the past.

> To avoid the read vs write contention, change the cache to use RCU locking on
> the read side. To avoid needing to RCU free every single inode, use the built
> in slab RCU freeing mechanism. This requires us to be able to detect lookups of
> freed inodes, so en??ure that ever freed inode has an inode number of zero and
> the XFS_IRECLAIM flag set. We already check the XFS_IRECLAIM flag in cache hit
> lookup path, but also add a check for a zero inode number as well.

How does this interact with slab poisoning?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
