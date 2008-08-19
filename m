Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 06:15:34 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7JDFUT7022736
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:15:31 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04C7D1BC6722
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:16:49 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id mtRIfLrLIZu1wLzd for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:16:49 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KVR4m-0008A0-UQ
	for xfs@oss.sgi.com; Tue, 19 Aug 2008 23:16:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/28] XFS: sync and reclaim rework
Date: Tue, 19 Aug 2008 23:16:16 +1000
Message-Id: <1219151804-30749-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Multiple patch sets, all in one patch bomb against a current
git tree. This includes all outstanding patches I have previously
sent that are not committed plus a bunch more...

---

XFS: replace the mount inode list with radix tree traversals V4

The list of all inodes on a mount is superfluous. We can traverse
all inodes now by walking the per-AG inode radix trees without
needing a separate list. This enables us to remove a bunch of
complex list traversal code and remove another two pointers from
the xfs_inode.

Also, by replacing the sync traversal with an ascending inode
number traversal, we will issue better inode I/O patterns for
writeback triggered by xfssyncd or unmount.

Before we make this change, move all the relevant sync code
into it's own file in the linux-2.6/ directory. This aggregates
VFS specific sync interfacing in the one file and will allow
all the subsequent change history to be associated with this
file so it is easy to find in future.

Version 4:
o revert xfs_syncsub -> xfs_sync change in xfs_quiesce_fs and
  rediff patch series

---

XFS: clean up sync code

xfs_sync and xfs_syncsub are multiplexed interfaces that
shares relatively little code between callers. because it is
a multiplexed interface, it's hard to tell what is executed
in each context it is called.

Factor out the sync code and explicitly call the sync functions
needed rather than the multiplexed interfaces. Once this is
done, we can remove xfs_syncsub and xfs_sync altogether.

---

RFC: Combine Linux and XFS inodes V2

XFS currently has to deal with two separate inode lifecycles
which makes for complexity in inode lookups and reclaim. We
also have the problem of not always having a linux inode around
when it might be useful to have it.

To avoid these lifecycle problems, this series embedѕ the linux
inode inside the struct xfs_inode and changes the way we reference
to two inodes. We can no longer check for a null linux inode -
instead we have to check to see if it is valid or not by checking
either the linux inode or xfs inode state flags. While this means
that inodes waiting for reclaim use more memory, this is not the
commonn state for inodes and the will soon be completely freed so
the additional memeory use in this state is only a temporary issue.

This combining of the inodes simplifies the inode and reclaim logic,
making it possible to do reclaim via radix tree tags (an upcoming
patch series) and to be able to use RCU locking on the radix trees.
The fact that we don't have a simple mechanism to determine the
reclaim state of the inode makes RCU locking very complex, and this
complexity is removed by having a combined inode structure.

This patch series also changes the way XFS caches inodes. It no
longer uses the linux inode cache as the primary lookup cache -
instead we rely solely on the XFS inode caches. This avoids the
inode_lock in lookups that hit the cache - we should get much
better parallelism out of inode lookup than we currently do now.

The patch series also makes use of the slab 'init once' feature
for the XFS inodes. This means we only need to do partial
initialisation of the xfs (and embedded linux inode) whenever
we allocate a new inode.

In future, we should also be able to cull duplicate fields out of
the xfs and linux inodes reducing the overall memory usage of
the active inode cache. This provides scope for continuing to
reduce the memory footprint of the XFS inode cache.

Version 2
o reorder and rework as a result of review comments.

---

XFS: Track reclaimable inodes in inode cache.

Move the tracking of reclaimable inodes
into the inode radix trees. This currently does not replace
the reclaim flags in the inode, rather it allows traversal of
all reclaimable inodes by walking the per-AG inode radix trees without needing
a separate list. This enables us to remove a list and a lock to
remove a point of serialisation during inode reclaim.


Like the matching sync code, this also allows reclaim of inodes
in ascending inode numbers which substantially improves I/O
patterns during reclaim driven inode flushing.

---

Combined diffstat:

 fs/inode.c                     |  205 ++++++----
 fs/xfs/Makefile                |    1
 fs/xfs/linux-2.6/xfs_aops.c    |    2
 fs/xfs/linux-2.6/xfs_iops.c    |   19
 fs/xfs/linux-2.6/xfs_super.c   |  265 +++----------
 fs/xfs/linux-2.6/xfs_super.h   |    3
 fs/xfs/linux-2.6/xfs_sync.c    |  780 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_sync.h    |   55 ++
 fs/xfs/linux-2.6/xfs_vfs.h     |   31 -
 fs/xfs/linux-2.6/xfs_vnode.c   |    6
 fs/xfs/linux-2.6/xfs_vnode.h   |    5
 fs/xfs/quota/xfs_qm.c          |   10
 fs/xfs/quota/xfs_qm_syscalls.c |  137 +++----
 fs/xfs/xfs_ag.h                |    5
 fs/xfs/xfs_iget.c              |  473 +++++++++---------------
 fs/xfs/xfs_inode.c             |  140 ++++---
 fs/xfs/xfs_inode.h             |   22 -
 fs/xfs/xfs_itable.c            |   14
 fs/xfs/xfs_mount.c             |    8
 fs/xfs/xfs_mount.h             |   12
 fs/xfs/xfs_vfsops.c            |  617 --------------------------------
 fs/xfs/xfs_vfsops.h            |    2
 fs/xfs/xfs_vnodeops.c          |  118 ------
 include/linux/fs.h             |    2
 24 files changed, 1391 insertions(+), 1541 deletions(-)
