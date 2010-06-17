Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5HNmdOk197530 for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 18:48:40 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 004CF14F7DCE
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 16:51:16 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	cSIVaneNMIdCSlTW for <xfs@oss.sgi.com>;
	Thu, 17 Jun 2010 16:51:16 -0700 (PDT)
Date: Fri, 18 Jun 2010 09:51:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid synchronous transaction in xfs_fs_write_inode
Message-ID: <20100617235113.GY6590@dastard>
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
> 
> ---
> 
> From: Christoph Hellwig <hch@lst.de>
> Subject: xfs: always use iget in bulkstat
> 
> The non-coherent bulkstat versionsthat look directly at the inode
> buffers causes various problems with performance optimizations that
> make increased use of just logging inodes.  This patch makes bulkstat
> always use iget, which should be fast enough for normal use with the
> radix-tree based inode cache introduced a while ago.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

An important note: I think this patch is necessary to avoid bulkstat
returning unlinked inodes when cache thrashing is occurring. The
current non-coherent lookup will incorrectly return unlinked inodes
if the inode cluster is marked stale, reclaimed and turfed from
memory due to an unlink and memory pressure between the ialloc btree
lookup and the cluster buffer read.

The only way to avoid this is to ensure that the ialloc btree lookup
and the formatting of the inode into the user buffer is atomic, which
means we have to do a coherent lookup that returns a locked into....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
