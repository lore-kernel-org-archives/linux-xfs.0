Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5G0U4nC106608 for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 19:30:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5485C1D5C5C2
	for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 17:32:39 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	iEm1tEAunQUkevcE for <xfs@oss.sgi.com>;
	Tue, 15 Jun 2010 17:32:39 -0700 (PDT)
Date: Wed, 16 Jun 2010 10:32:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid synchronous transaction in xfs_fs_write_inode
Message-ID: <20100616003235.GU6590@dastard>
References: <20100608195905.GA577@infradead.org>
	<20100609072911.GI7869@dastard>
	<20100615112051.GA25064@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100615112051.GA25064@infradead.org>
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

On Tue, Jun 15, 2010 at 07:20:51AM -0400, Christoph Hellwig wrote:
> On Wed, Jun 09, 2010 at 05:29:11PM +1000, Dave Chinner wrote:
> > All great - I attempted this myself - but it breaks bulkstat. See
> > xfstest 183:
> 
> I can't reproduce the failure.  And then I don't think we should
> prioritize bulkstate over metadata performance.  The only major users
> of bulkstat on XFS in the mainline kernel is xfsdump, and metadata
> performance during normal loads is a lot more important.  And the
> difference when using LVM/MD will be even larger with this as barriers
> are a lot more expensive there.
> 
> What do you think about adding something like the patch below which
> always makes bulkstat always use the iget version which doesn't show
> this sort of problems.

<snip patch>

The big advantage of the non-coherent bulkstat (apart from the order
of magnitude performance increase it afforded) is that it doesn't
cause the inode cache to grow and cause memory pressure.

I was thinking that what I'd like a coherent bulkstat to do is if it
causes a cache miss immediately mark the inode as reclaimable so
that it gets turfed back out of the cache within a few seconds of
bulkstat using it. This will keep the cache growth under control,
and keep the speed of cache lookups fairly consistent. It also means
we don't need to set up the VFS side of the inode, as this will be
done anyway if we get a cache hit on a normal lookup of a
reclaimable inode. If we convert back to coherent bulkstat, at
minimum I'd like to make this change during the conversion to keep
the per-inode CPU overhead at a minimum.

The other thing I was thinking is a "bulk inode read" where we
insert the entire cluster of inodes into the cache in a single
operation. that way we don't have to keep calling the inode read
code on every cache miss. With the above "insert as reclaimable
inodes" it would significantly reduce the CPU overhead of populating
the cache just for bulkstat. With this being done by a prefetch
thread or two, we can leave the ioctl thread simply doing cache
lookups and formatting....

The big question is what the SGI guys think of this - removing
the non-cohenerent modes that are there for optimising specific DMF
operations that are otherwise rather costly (i.e. BULKSTAT_FG_INLINE
replaces bulkstat/open-by-handle/read xattr/close) and cause cache
pollution. Are there ways to do this with coherent bulkstats?

However, this raises the same issue with the removal of the
remaining DMAPI hooks (that Alex wants more discussion on), so to me
the big question is now this: how much of the XFS code that is there
specifically for supporting SGI's proprietry applications should be
maintained in mainline given that SGI already supports and maintains
a separate XFS tree with the significant additional functionality
necessary for those applications that is not in mainline....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
