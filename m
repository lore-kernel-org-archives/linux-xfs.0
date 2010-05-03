Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o43BqYBk151958 for <xfs@oss.sgi.com>; Mon, 3 May 2010 06:52:35 -0500
Received: from anguilla.debian.or.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F95D1551D16
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 04:54:40 -0700 (PDT)
Received: from anguilla.debian.or.at (anguilla.debian.or.at [86.59.21.37]) by
	cuda.sgi.com with ESMTP id K26OKn93kzQZlwfF for
	<xfs@oss.sgi.com>; Mon, 03 May 2010 04:54:40 -0700 (PDT)
Date: Mon, 3 May 2010 13:54:38 +0200
From: Peter Palfrader <peter@palfrader.org>
Subject: [regression,bisected] 2.6.32.12: find(1) on xfs causes OOM
Message-ID: <20100503115438.GA16623@anguilla.noreply.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org, xfs@oss.sgi.com

Hi,

I have an xfs filesystem in a KVM domain with 512megs of memory and 2 gigs of
swap.

The filesystem is 750g in size, of which some 500g are in use in about 6
million files.  (This XFS filesystem is exported via nfs4.  I haven't tested if
this makes any difference.)

Starting in 2.6.32.12 running something like "find | wc -l" on this
filesystem's mountpoint causes the OOM killer to kill off most of the
system.  (See kern.log[1])

With 2.6.32.11 the system does not behave like this.

Bisecting turned up the following commit.  Reverting it in 2.6.32.12
also results in a system that works.

| 9e1e9675fb29c0e94a7c87146138aa2135feba2f is first bad commit
| commit 9e1e9675fb29c0e94a7c87146138aa2135feba2f
| Author: Dave Chinner <david@fromorbit.com>
| Date:   Fri Mar 12 09:42:10 2010 +1100
| 
|     xfs: reclaim all inodes by background tree walks
|     
|     commit 57817c68229984818fea9e614d6f95249c3fb098 upstream
|     
|     We cannot do direct inode reclaim without taking the flush lock to
|     ensure that we do not reclaim an inode under IO. We check the inode
|     is clean before doing direct reclaim, but this is not good enough
|     because the inode flush code marks the inode clean once it has
|     copied the in-core dirty state to the backing buffer.
|     
|     It is the flush lock that determines whether the inode is still
|     under IO, even though it is marked clean, and the inode is still
|     required at IO completion so we can't reclaim it even though it is
|     clean in core. Hence the requirement that we need to take the flush
|     lock even on clean inodes because this guarantees that the inode
|     writeback IO has completed and it is safe to reclaim the inode.
|     
|     With delayed write inode flushing, we could end up waiting a long
|     time on the flush lock even for a clean inode. The background
|     reclaim already handles this efficiently, so avoid all the problems
|     by killing the direct reclaim path altogether.
|     
|     Signed-off-by: Dave Chinner <david@fromorbit.com>
|     Reviewed-by: Christoph Hellwig <hch@lst.de>
|     Signed-off-by: Alex Elder <aelder@sgi.com>
|     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
|
| diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
| index a82a93d..ea7a59a 100644
| --- a/fs/xfs/linux-2.6/xfs_super.c
| +++ b/fs/xfs/linux-2.6/xfs_super.c
| @@ -953,16 +953,14 @@ xfs_fs_destroy_inode(
|         ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
|  
|         /*
| -        * If we have nothing to flush with this inode then complete the
| -        * teardown now, otherwise delay the flush operation.
| +        * We always use background reclaim here because even if the
| +        * inode is clean, it still may be under IO and hence we have
| +        * to take the flush lock. The background reclaim path handles
| +        * this more efficiently than we can here, so simply let background
| +        * reclaim tear down all inodes.
|          */
| -       if (!xfs_inode_clean(ip)) {
| -               xfs_inode_set_reclaim_tag(ip);
| -               return;
| -       }
| -
|  out_reclaim:
| -       xfs_ireclaim(ip);
| +       xfs_inode_set_reclaim_tag(ip);
|  }
|  
|  /*


Cheers,
Peter

1. http://asteria.noreply.org/~weasel/volatile/2010-05-03-Aju29kSrm0A/kern.log
2. http://asteria.noreply.org/~weasel/volatile/2010-05-03-Aju29kSrm0A/config-2.6.32.12-dsa-amd64
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
