Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2A02dmm068752 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 18:02:44 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73D121BD3520
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 16:05:28 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jECpTE4gAMap52JS for <xfs@oss.sgi.com>;
	Wed, 09 Mar 2011 16:05:28 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PxTNc-0002vN-R3
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 11:05:24 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PxTNk-0002t2-O2
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 11:05:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfs: Reduce OOM kill problems under heavy load V2
Date: Thu, 10 Mar 2011 11:05:23 +1100
Message-Id: <1299715529-11026-1-git-send-email-david@fromorbit.com>
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

Chris Mason reported recently that a concurent stress test
(basically copying the linux kernel tree 20 times, verifying md5sums
and deleting it in a loop concurrently) under low memory conditions
was triggering the OOM killer muchmore easily than for btrfs.

Turns out there are two main problems. The first is that unlinked
inodes were not being reclaimed fast enough, leading to the OOM
being declared when there are large numbers of reclaimable inodes
still around. The second was that atime updates due to the verify
step were creating large numbers of dirty inodes at the VFS level
that were not being written back and hence made reclaimable before
the system declared OOM and killed stuff.

The first problem is fixed by making background inode reclaim more
frequent and faster, kicking background reclaim from the inode cache
shrinker so that when memory is low we always have background inode
reclaim in progress, and finally making the shrinker reclaim scan
block waiting on inodes to reclaim. This last step throttles memory
reclaim to the speed at which we can reclaim inodes, a key step
needed to prevent inodes from reclaim declaring OOM while there are
still reclaimable inodes around. The background inode reclaim
prevents this synchronous flush from finding dirty inodes and block
on them in most cases and hence prevents performance regressions in
more common workloads due to reclaim stalls.

To enable this new functionality, the xfssyncd thread is replaced
with a workqueue and the existing xfssyncd work replaced with a
global workqueue.  Hence all filesystems will share the same
workqueue and we remove allt eh xfssyncd threads from the system.
The ENOSPC inode flush is converted to use the workqueue, and
optimised to only allow a single flush at a time. This significant
speeds up ENOSPC processing under concurrent workloads as it removes
all the unnecessary scanning that every single ENOSPC event
currently queues to the xfssyncd. Finally, a new reinode reclaim
worker is added to the workqueue that runs 5x more frequently that
the xfssyncd to do the background inode reclaim scan.

The second problem is could be fixed by making the XFS inode cache
shrinker kick the bdi flusher to write back inodes if the bdi
flusher is not already active.  This, however, causes deadlocks when
the bdi-flusher thread needs to be forked under memory pressure, so
these patches have been dropped for now.

An addition to the series is to push the AIL when we are under
memory stress to speed up the cleaning of dirty metadata. While this
does not avoid the problems with VFS level dirty objects, it does
ensure we don't keep lots of dirty objects that the VFS knows
nothing about pinned in memory when there is a shortage.

By also pushing the AIL doing the periodic syncd work, we ensure
that we always clear out dirty objects from the AIL regularly and
hence allow the filesytem to idle correctly. Conversion of the
xfsaild thread to a workqueue also simplifies the push trigger
mechanism for cleaning the AIL and removes the need for a thread per
filesystem for this work.

Version 2:
- drop writeback_inodes_sb_nr_if_idle() patch
- no need for work_pending checks before queueing - the queuing
  already does this atomically.
- remove xfs_syncd_lock as it is not necessary anymore
- simplify inode reclaim trigger
- add AIL pushing patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
