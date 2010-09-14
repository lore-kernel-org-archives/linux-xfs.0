Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ENH33x153017 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 18:17:03 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9399A737B5
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 16:17:51 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	2oJkNtbKB48isP3a for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 16:17:51 -0700 (PDT)
Date: Wed, 15 Sep 2010 09:17:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/18] xfs: convert inode cache lookups to use RCU locking
Message-ID: <20100914231748.GE15695@dastard>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-6-git-send-email-david@fromorbit.com>
	<20100914162742.GA18185@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100914162742.GA18185@infradead.org>
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

On Tue, Sep 14, 2010 at 12:27:42PM -0400, Christoph Hellwig wrote:
> On Tue, Sep 14, 2010 at 08:56:04PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > With delayed logging greatly increasing the sustained
> > parallelism of inode operations, the inode cache locking is
> > showing significant read vs write contention when inode reclaim
> > runs at the same time as lookups. There is also a lot more write
> > lock acquistions than there are read locks (4:1 ratio) so the
> > read locking is not really buying us much in the way of
> > parallelism.
> 
> That's just for your parallel creates workload, isn't it?  If we'd
> get that bad hit rates on normal workloads something is pretty
> wrong with the inode cache.

I see it on the unlink workloads, as well as any use-once workload I
care to run (e.g. du, find, grep, xfsdump, xfs_fsr, etc) on a
fileystem with more inodes in it that can fit in the currently
available memory. When we have userspace memory pressure, the amount
of memory available for caching can be pretty low, so this is quite
a common situation.

> For a workload with 4 times as many writelocks just changing the
> rwlock to a spinlock should provide more benefits.  Did you test what
> effect this has on other workloads?

Not yet - I've run it through xfsqa on single CPU, 2p and 4p
machines for the past few days, but I haven't benchmarked it
comparitively on other workloads yet. The whole patchset needs
that....

> In addition to that I feel really uneasy about changes to the inode
> cache locking without really heavy NFS server testing - we just had too
> many issues in this area in the past.

Agreed, and that's something I need to test against.

> > To avoid the read vs write contention, change the cache to use RCU locking on
> > the read side. To avoid needing to RCU free every single inode, use the built
> > in slab RCU freeing mechanism. This requires us to be able to detect lookups of
> > freed inodes, so en??ure that ever freed inode has an inode number of zero and
> > the XFS_IRECLAIM flag set. We already check the XFS_IRECLAIM flag in cache hit
> > lookup path, but also add a check for a zero inode number as well.
> 
> How does this interact with slab poisoning?

mm/slab.c::kmem_cache_create():

        if (!(flags & SLAB_DESTROY_BY_RCU))
                flags |= SLAB_POISON;
#endif
        if (flags & SLAB_DESTROY_BY_RCU)
                BUG_ON(flags & SLAB_POISON);

and SLUB does an equivalent setup where OBJECT_POISON is not set if
SLAB_DESTROY_BY_RCU is set. So it effectively turns off slab
poisoning, but leaves all the other debug checks active.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
