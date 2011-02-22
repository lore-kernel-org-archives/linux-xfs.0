Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1MMDdTS001195 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 16:13:39 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D20F612C8026
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 14:16:21 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	h8jCijOtk4qGIAPu for <xfs@oss.sgi.com>;
	Tue, 22 Feb 2011 14:16:21 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/5] xfs: Reduce OOM kill problems under heavy load
Date: Wed, 23 Feb 2011 09:16:04 +1100
Message-Id: <1298412969-14389-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: chris.mason@oracle.com

Chris Mason reported recently that a concurent stress test (basically copying
the linux kernel tree 20 times, verifying md5sums and deleting it in a loop
concurrently) under low memory conditions was triggering the OOM killer
muchmore easily than for btrfs.

Turns out there are two main problems. The first is that unlinked inodes were
not being reclaimed fast enough, leading to the OOM being declared when there
are large numbers of reclaimable inodes still around. The second was that
atime updates due to the verify step were creating large numbers of dirty
inodes at the VFS level that were not being written back and hence made
reclaimable before the system declared OOM and killed stuff.

The first problem is fixed by making background inode reclaim more frequent and
faster, kicking background reclaim from the inode cache shrinker so that when
memory is low we always have background inode reclaim in progress, and finally
making the shrinker reclaim scan block waiting on inodes to reclaim. This last
step throttles memory reclaim to the speed at which we can reclaim inodes, a
key step needed to prevent inodes from reclaim declaring OOM while there are
still reclaimable inodes around. The background inode reclaim prevents this
synchronous flush from finding dirty inodes and block on them in most cases and
hence prevents performance regressions in more common workloads due to reclaim
stalls.

To enable this new functionality, the xfssyncd thread is replaced with a
workqueue and the existing xfssyncd work replaced with a global workqueue.
Hence all filesystems will share the same workqueue and we remove allt eh
xfssyncd threads from the system. The ENOSPC inode flush is converted to use
the workqueue, and optimised to only allow a single flush at a time. This
significant speeds up ENOSPC processing under concurrent workloads as it
removes all the unnecessary scanning that every single ENOSPC event
currently queues to the xfssyncd. Finally, a new reinode reclaim worker is
added to the workqueue that runs 5x more frequently that the xfssyncd to do the
background inode reclaim scan.

The second problem is fixed simply by making the XFS inode cache shrinker kick
the bdi flusher to write back inodes if the bdi flusher is not already active.
This ensures that in low memory situations we are always actively writing back
inodes that are dirty at the VFS level and hence preventing them from building
up in an unreclaimable state. Once again this does not affect performance in
non-memory constrained situations.

The result is not yet perfect - the stress test still triggers the OOM killer
somewhere between 3-6 hours into the test on a CONFIG_XFS_DEBUG kernel with
lockdep enabled (so inodes consume roughly 2x the memory of a production
kernel), though this is a marked improvement. The OOM kill trigger appears to
be a different one to the above two, so expect more patches to address that
soon.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
