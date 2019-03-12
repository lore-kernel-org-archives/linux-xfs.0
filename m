Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40602 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfCLSSm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Mar 2019 14:18:42 -0400
Date: Tue, 12 Mar 2019 11:18:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: xlog_grant_head_wait deadlocks on high-rolling transactions?
Message-ID: <20190312181825.GH4359@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>

Hi all,

Does anyone /else/ occasionally see fstests hang with a hojillion
threads stuck in xlog_grant_head_wait?  I periodically see xfs/347 hang
with a hojillion threads stuck in:

kworker/0:214   D13120 26117      2 0x80000000
Workqueue: xfs-conv/sdf xfs_end_io [xfs]
Call Trace:
 schedule+0x36/0x90
 xlog_grant_head_wait+0x66/0x450 [xfs]
 xlog_grant_head_check+0xf0/0x170 [xfs]
 xfs_log_reserve+0x166/0x500 [xfs]
 xfs_trans_reserve+0x1ac/0x2b0 [xfs]
 xfs_trans_alloc+0xda/0x220 [xfs]
 xfs_reflink_end_cow_extent+0xda/0x3a0 [xfs]
 xfs_reflink_end_cow+0x92/0x2a0 [xfs]
 xfs_end_io+0xd0/0x120 [xfs]
 process_one_work+0x252/0x600
 worker_thread+0x3d/0x390
 kthread+0x11f/0x140
 ret_from_fork+0x24/0x30

Which is the end io worker stalled under xfs_trans_alloc trying to
reserve log space to remap extents from the COW fork to the data fork.
I also observe one thread stuck here:

kworker/0:215   D13120 26118      2 0x80000000
Workqueue: xfs-conv/sdf xfs_end_io [xfs]
Call Trace:
 schedule+0x36/0x90
 xlog_grant_head_wait+0x66/0x450 [xfs]
 xlog_grant_head_check+0xf0/0x170 [xfs]
 xfs_log_regrant+0x155/0x3b0 [xfs]
 xfs_trans_reserve+0xa5/0x2b0 [xfs]
 xfs_trans_roll+0x9c/0x190 [xfs]
 xfs_defer_trans_roll+0x16e/0x5b0 [xfs]
 xfs_defer_finish_noroll+0xf1/0x7e0 [xfs]
 __xfs_trans_commit+0x1c3/0x630 [xfs]
 xfs_reflink_end_cow_extent+0x285/0x3a0 [xfs]
 xfs_reflink_end_cow+0x92/0x2a0 [xfs]
 xfs_end_io+0xd0/0x120 [xfs]
 process_one_work+0x252/0x600
 worker_thread+0x3d/0x390
 kthread+0x11f/0x140
 ret_from_fork+0x24/0x30

This thread is stalled under xfs_trans_roll trying to reserve more log
space because it rolled more times than tr_write.tr_logcount
anticipated.  logcount = 8, but (having added a patch to trace log
tickets that roll more than logcount guessed) we actually roll these
end_cow transactions 10 times.

I think the problem was introduced when we added the deferred AGFL log
item, because the bunmapi of the old data fork extent and the map_extent
of the new extent can both add separate deferred AGFL log items to the
defer chain.  It's also possible that I underestimated
XFS_WRITE_LOG_COUNT_REFLINK way back when.

Either way, the xfs_trans_roll transaction wants (logres) more space,
and the xfs_trans_alloc transactions want (logres * logcount) space.
Unfortunately, the alloc transactions got to the grant waiter list
first, and there's not enough space for them, so the entire list waits.
There seems to be enough space to grant the rolling transaction its
smaller amount of space, so at least in theory that transaction could
finish (and release a lot of space) if it could be bumped to the head of
the waiter list.

Another way to solve this problem of course is to increase tr_logcount
from 8 to 10, though this could cause some user heartburn for small
filesystems because the minimum log size would increase.  However, I'm
not sure about the relative merits of either approach, so I'm kicking
this to the list for further input (while I go have lunch :P)

The second problem I noticed is that the reflink cancel cow and reflink
remap functions follow the pattern of allocating one transaction and
rolling it for every extent it encounters.  This results in /very/ high
roll counts for the transaction, which (on a very busy system with a
smallish log) seems like it could land us right back in this deadlock.
I think the answer is to split those up to run one transaction per
extent (like I did for reflink end_cow), though I'd have to ensure that
we can drop the ILOCK safely to get a new transaction.

Thoughts?

--D
