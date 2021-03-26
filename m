Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BEABC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AF9E61A46
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhCZAWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhCZAVt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C6E6619F3;
        Fri, 26 Mar 2021 00:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718109;
        bh=EKfq3xyQOGkgBrft6QCkl/9zx5fT4fR+tMcXA/nQYLI=;
        h=Subject:From:To:Cc:Date:From;
        b=UYjr9TkN6kcTmGOzHfBdP4gkvgAWuQJ1HJf6xyAbqEetvCM0B/K8R0lMIh8r9ddbS
         dGkBUpGFwL6uC+QmZ8NxbVhHxVIIwpU5NgnBDdW6GmhsSQ7PFYXpJOkwMN7Hea2bxG
         wSJtQfjeFO5XHoLRits6vfQlPjRNPDFG62y5Hw+wcVsBMESA8c+b/lsiL51olRQgT9
         GMtLrxThJ+uYr5BG0rscuShb8j3EJoauNsYBbxTncVYaPalLrqjCo07GVMqk8or18e
         jKD4vcHgpgboLYqBBF5pmk61kRZTmymGsLuhNwqE6lLKZi+6f/g/ybIPljlT4O4xhT
         gVQ7Xp/SLD2oA==
Subject: [PATCHSET v5 0/9] xfs: deferred inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:21:48 -0700
Message-ID: <161671810866.622901.16520335819131743716.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch series implements deferred inode inactivation.  Inactivation
is what happens when an open file loses its last incore reference: if
the file has speculative preallocations, they must be freed, and if the
file is unlinked, all forks must be truncated, and the inode marked
freed in the inode chunk and the inode btrees.

Currently, all of this activity is performed in frontend threads when
the last in-memory reference is lost and/or the vfs decides to drop the
inode.  Three complaints stem from this behavior: first, that the time
to unlink (in the worst case) depends on both the complexity of the
directory as well as the the number of extents in that file; second,
that deleting a directory tree is inefficient and seeky because we free
the inodes in readdir order, not disk order; and third, the upcoming
online repair feature needs to be able to xfs_irele while scanning a
filesystem in transaction context.  It cannot perform inode inactivation
in this context because xfs does not support nested transactions.

The implementation will be familiar to those who have studied how XFS
scans for reclaimable in-core inodes -- we create a couple more inode
state flags to mark an inode as needing inactivation and being in the
middle of inactivation.  When inodes need inactivation, we set
NEED_INACTIVE in iflags, set the INACTIVE radix tree tag, and schedule a
deferred work item.  The deferred worker runs in an unbounded workqueue,
scanning the inode radix tree for tagged inodes to inactivate, and
performing all the on-disk metadata updates.  Once the inode has been
inactivated, it is left in the reclaim state and the background reclaim
worker (or direct reclaim) will get to it eventually.

Doing the inactivations from kernel threads solves the first problem by
constraining the amount of work done by the unlink() call to removing
the directory entry.  It solves the third problem by moving inactivation
to a separate process.  Because the inactivations are done in order of
inode number, we solve the second problem by performing updates in (we
hope) disk order.  This also decreases the amount of time it takes to
let go of an inode cluster if we're deleting entire directory trees.

There are three big warts I can think of in this series: first, because
the actual freeing of nlink==0 inodes is now done in the background,
this means that the system will be busy making metadata updates for some
time after the unlink() call returns.  This temporarily reduces
available iops.  Second, in order to retain the behavior that deleting
100TB of unshared data should result in a free space gain of 100TB, the
statvfs and quota reporting ioctls wait for inactivation to finish,
which increases the long tail latency of those calls.  This behavior is,
unfortunately, key to not introducing regressions in fstests.  The third
problem is that the deferrals keep memory usage higher for longer,
reduce opportunities to throttle the frontend when metadata load is
heavy, and the unbounded workqueues can create transaction storms.

For v5 there are some serious changes against the older versions of this
patchset -- we no longer cycle an inode's dquots to avoid fights with
quotaoff, and we actually shut down the background gc threads when the
filesystem is frozen.

v1-v2: NYE patchbombs
v3: rebase against 5.12-rc2 for submission.
v4: combine the can/has eofblocks predicates, clean up incore inode tree
    walks, fix inobt deadlock
v5: actually freeze the inode gc threads when we freeze the filesystem,
    consolidate the code that deals with inode tagging, and use
    foreground inactivation during quotaoff to avoid cycling dquots

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation-5.13
---
 Documentation/admin-guide/xfs.rst |   10 +
 fs/xfs/libxfs/xfs_fs.h            |    7 
 fs/xfs/scrub/common.c             |    2 
 fs/xfs/xfs_bmap_util.c            |   44 +++
 fs/xfs/xfs_fsops.c                |    4 
 fs/xfs/xfs_globals.c              |    3 
 fs/xfs/xfs_icache.c               |  550 ++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_icache.h               |   39 ++-
 fs/xfs/xfs_inode.c                |   60 ++++
 fs/xfs/xfs_inode.h                |   15 +
 fs/xfs/xfs_ioctl.c                |    9 -
 fs/xfs/xfs_linux.h                |    2 
 fs/xfs/xfs_log_recover.c          |    7 
 fs/xfs/xfs_mount.c                |   29 ++
 fs/xfs/xfs_mount.h                |   19 +
 fs/xfs/xfs_qm_syscalls.c          |   22 +
 fs/xfs/xfs_super.c                |   86 +++++-
 fs/xfs/xfs_sysctl.c               |    9 +
 fs/xfs/xfs_sysctl.h               |    1 
 fs/xfs/xfs_trace.h                |   14 +
 20 files changed, 832 insertions(+), 100 deletions(-)

