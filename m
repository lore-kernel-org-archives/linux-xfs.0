Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAC3C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E33C020825
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgEVDui (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:50:38 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:41633 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727914AbgEVDuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:50:37 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id ADBC11A7FF9
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 13:50:33 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-0002Uy-3N
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbyhZ-00CgHC-Qc
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/24] xfs: rework inode flushing to make inode reclaim fully asynchronous
Date:   Fri, 22 May 2020 13:50:05 +1000
Message-Id: <20200522035029.3022405-1-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=IkcTkHD0fZMA:10 a=sTwFKg_x9MkA:10 a=pfZkFLegHasd9hrFUgAA:9
        a=ip8bM0tYPaJAUXX5:21 a=VFjRgYAAaXMoEXme:21 a=QEXdDO2ut3YA:10
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Inode flushing requires that we first lock an inode, then check it,
then lock the underlying buffer, flush the inode to the buffer and
finally add the inode to the buffer to be unlocked on IO completion.
We then walk all the other cached inodes in the buffer range and
optimistically lock and flush them to the buffer without blocking.

This cluster write effectively repeats the same code we do with the
initial inode, except now it has to special case that initial inode
that is already locked. Hence we have multiple copies of very
similar code, and it is a result of inode cluster flushing being
based on a specific inode rather than grabbing the buffer and
flushing all available inodes to it.

The problem with this at the moment is that we we can't look up the
buffer until we have guaranteed that an inode is held exclusively
and it's not going away while we get the buffer through an imap
lookup. Hence we are kinda stuck locking an inode before we can look
up the buffer.

This is also a result of inodes being detached from the cluster
buffer except when IO is being done. This has the further problem
that the cluster buffer can be reclaimed from memory and then the
inode can be dirtied. At this point cleaning the inode requires a
read-modify-write cycle on the cluster buffer. If we then are put
under memory pressure, cleaning that dirty inode to reclaim it
requires allocating memory for the cluster buffer and this leads to
all sorts of problems.

We used synchronous inode writeback in reclaim as a throttle that
provided a forwards progress mechanism when RMW cycles were required
to clean inodes. Async writeback of inodes (e.g. via the AIL) would
immediately exhaust remaining memory reserves trying to allocate
inode cluster after inode cluster. The synchronous writeback of an
inode cluster allowed reclaim to release the inode cluster and have
it freed almost immediately which could then be used to allocate the
next inode cluster buffer. Hence the IO based throttling mechanism
largely guaranteed forwards progress in inode reclaim. By removing
the requirement for require memory allocation for inode writeback
filesystem level, we can issue writeback asynchrnously and not have
to worry about the memory exhaustion anymore.

Another issue is that if we have slow disks, we can build up dirty
inodes in memory that can then take hours for an operation like
unmount to flush. A RMW cycle per inode on a slow RAID6 device can
mean we only clean 50 inodes a second, and when there are hundreds
of thousands of dirty inodes that need to be cleaned this can take a
long time. PInning the cluster buffers will greatly speed up inode
writeback on slow storage systems like this.

These limitations all stem from the same source: inode writeback is
inode centric, And they are largely solved by the same architectural
change: make inode writeback cluster buffer centric.  This series is
makes that architectural change.

Firstly, we start by pinning the inode backing buffer in memory
when an inode is marked dirty (i.e. when it is logged). By tracking
the number of dirty inodes on a buffer as a counter rather than a
flag, we avoid the problem of overlapping inode dirtying and buffer
flushing racing to set/clear the dirty flag. Hence as long as there
is a dirty inode in memory, the buffer will not be able to be
reclaimed. We can safely do this inode cluster buffer lookup when we
dirty an inode as we do not hold the buffer locked - we merely take
a reference to it and then release it - and hence we don't cause any
new lock order issues.

When the inode is finally cleaned, the reference to the buffer can
be removed from the inode log item and the buffer released. This is
done from the inode completion callbacks that are attached to the
buffer when the inode is flushed.

Pinning the cluster buffer in this way immediately avoids the RMW
problem in inode writeback and reclaim contexts by moving the memory
allocation and the blocking buffer read into the transaction context
that dirties the inode.  This inverts our dirty inode throttling
mechanism - we now throttle the rate at which we can dirty inodes to
rate at which we can allocate memory and read inode cluster buffers
into memory rather than via throttling reclaim to rate at which we
can clean dirty inodes.

Hence if we are under memory pressure, we'll block on memory
allocation when trying to dirty the referenced inode, rather than in
the memory reclaim path where we are trying to clean unreferenced
inodes to free memory.  Hence we no longer have to guarantee
forwards progress in inode reclaim as we aren't doing memory
allocation, and that means we can remove inode writeback from the
XFS inode shrinker completely without changing the system tolerance
for low memory operation.

Tracking the buffers via the inode log item also allows us to
completely rework the inode flushing mechanism. While the inode log
item is in the AIL, it is safe for the AIL to access any member of
the log item. Hence the AIL push mechanisms can access the buffer
attached to the inode without first having to lock the inode.

This means we can essentially lock the buffer directly and then
call xfs_iflush_cluster() without first going through xfs_iflush()
to find the buffer. Hence we can remove xfs_iflush() altogether,
because the two places that call it - the inode item push code and
inode reclaim - no longer need to flush inodes directly.

This can be further optimised by attaching the inode to the cluster
buffer when the inode is dirtied. i.e. when we add the buffer
reference to the inode log item, we also attach the inode to the
buffer for IO processing. This leads to the dirty inodes always
being attached to the buffer and hence we no longer need to add them
when we flush the inode and remove them when IO completes. Instead
the inodes are attached when the node log item is dirtied, and
removed when the inode log item is cleaned.

With this structure in place, we no longer need to do
lookups to find the dirty inodes in the cache to attach to the
buffer in xfs_iflush_cluster() - they are already attached to the
buffer. Hence when the AIL pushes an inode, we just grab the buffer
from the log item, and then walk the buffer log item list to lock
and flush the dirty inodes attached to the buffer.

This greatly simplifies inode writeback, and removes another memory
allocation from the inode writeback path (the array used for the
radix tree gang lookup). And while the radix tree lookups are fast,
walking the linked list of dirty inodes is faster.

There is followup work I am doing that uses the inode cluster buffer
as a replacement in the AIL for tracking dirty inodes. This part of
the series is not ready yet as it has some intricate locking
requirements. That is an optimisation, so I've left that out because
solving the inode reclaim blocking problems is the important part of
this work.

In short, this series simplifies inode writeback and fixes the long
standing inode reclaim blocking issues without requiring any changes
to the memory reclaim infrastructure.

Note: dquots should probably be converted to cluster flushing in a
similar way, as they have many of the same issues as inode flushing.

Thoughts, comments and improvemnts welcome.

-Dave.



Dave Chinner (24):
  xfs: remove logged flag from inode log item
  xfs: add an inode item lock
  xfs: mark inode buffers in cache
  xfs: mark dquot buffers in cache
  xfs: mark log recovery buffers for completion
  xfs: call xfs_buf_iodone directly
  xfs: clean up whacky buffer log item list reinit
  xfs: fold xfs_istale_done into xfs_iflush_done
  xfs: use direct calls for dquot IO completion
  xfs: clean up the buffer iodone callback functions
  xfs: get rid of log item callbacks
  xfs: pin inode backing buffer to the inode log item
  xfs: make inode reclaim almost non-blocking
  xfs: remove IO submission from xfs_reclaim_inode()
  xfs: allow multiple reclaimers per AG
  xfs: don't block inode reclaim on the ILOCK
  xfs: remove SYNC_TRYLOCK from inode reclaim
  xfs: clean up inode reclaim comments
  xfs: attach inodes to the cluster buffer when dirtied
  xfs: xfs_iflush() is no longer necessary
  xfs: rename xfs_iflush_int()
  xfs: rework xfs_iflush_cluster() dirty inode iteration
  xfs: factor xfs_iflush_done
  xfs: remove xfs_inobp_check()

 fs/xfs/libxfs/xfs_inode_buf.c   |  27 +-
 fs/xfs/libxfs/xfs_inode_buf.h   |   6 -
 fs/xfs/libxfs/xfs_trans_inode.c | 108 +++++--
 fs/xfs/xfs_buf.c                |  44 ++-
 fs/xfs/xfs_buf.h                |  49 +--
 fs/xfs/xfs_buf_item.c           | 205 +++++--------
 fs/xfs/xfs_buf_item.h           |   8 +-
 fs/xfs/xfs_buf_item_recover.c   |   5 +-
 fs/xfs/xfs_dquot.c              |  32 +-
 fs/xfs/xfs_dquot.h              |   1 +
 fs/xfs/xfs_dquot_item_recover.c |   2 +-
 fs/xfs/xfs_file.c               |   9 +-
 fs/xfs/xfs_icache.c             | 293 +++++-------------
 fs/xfs/xfs_inode.c              | 515 +++++++++++---------------------
 fs/xfs/xfs_inode.h              |   2 +-
 fs/xfs/xfs_inode_item.c         | 281 ++++++++---------
 fs/xfs/xfs_inode_item.h         |   9 +-
 fs/xfs/xfs_inode_item_recover.c |   2 +-
 fs/xfs/xfs_log_recover.c        |   5 +-
 fs/xfs/xfs_mount.c              |   4 -
 fs/xfs/xfs_mount.h              |   1 -
 fs/xfs/xfs_trans.h              |   3 -
 fs/xfs/xfs_trans_buf.c          |  15 +-
 fs/xfs/xfs_trans_priv.h         |  12 +-
 24 files changed, 680 insertions(+), 958 deletions(-)

-- 
2.26.2.761.g0e0b3e54be

