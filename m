Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:51485 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753162AbcJRUVW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Oct 2016 16:21:22 -0400
From: Lucas Stach <dev@lynxeye.de>
Subject: [PATCH 0/2] XFS buffer cache scalability improvements
Date: Tue, 18 Oct 2016 22:14:11 +0200
Message-Id: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi all,

this series scratches my own small itch with XFS, namely scalability of the buffer
cache in metadata intensive workloads. With a large number of cached buffers those
workloads are CPU bound with a significant amount of time spent searching the cache.

The first commit replaces the rbtree used to index the cache with an rhashtable. The
rbtree is a bottleneck in scalability, as the data structure itself is pretty CPU
cache unfriendly. For larger numbers of cached buffers over 80% of the CPU time
is spent waiting on cache misses resulting from the inherent pointer chasing.

rhashtables provide a fast lookup with the ability to have lookups proceed while the
hashtable is being resized. This seems to match the read dominated workload of the
buffer cache index structure pretty well.

The second patch is logical follow up. The rhashtable cache index is protected by
RCU and does not need any additional locking. By switching the buffer cache entries
over to RCU freeing the buffer cache can be operated in a completely lock-free
manner. This should help scalability in the long run.

This series survives at least a xfstests auto group run (though with the scratch
device being a ramdisk) with no regressions and didn't show any problems in my
real world testing (using the patched FS with multiple large git trees) so far.

Regards,
Lucas

Lucas Stach (2):
  xfs: use rhashtable to track buffer cache
  xfs: switch buffer cache entries to RCU freeing

 fs/xfs/xfs_buf.c   | 155 ++++++++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_buf.h   |   4 +-
 fs/xfs/xfs_linux.h |   1 +
 fs/xfs/xfs_mount.c |   7 ++-
 fs/xfs/xfs_mount.h |   6 ++-
 5 files changed, 114 insertions(+), 59 deletions(-)

-- 
2.7.4

