Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE6AC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED10460F6F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhG2Sn5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhG2Sn5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:43:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA16260249;
        Thu, 29 Jul 2021 18:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584234;
        bh=jkMkc+712sRhaAAViyPtoNlsKrtYSZ/TZg4ai8+HVp8=;
        h=Subject:From:To:Cc:Date:From;
        b=VT7eU5sFQhwVvkDnIYSLU33UIxex13irPsXQXtzGVP+LKD/BMWr/1yScHrujoOYLy
         lr6lwXfY//NaZiyKDkb2NiHHxtDY5TW2ODuOJPhSzIZ9ClytCBUcbMl5QSZxVHilGI
         V4z3h5mXRYBWJ3o24ITt/G/m5WI7uP/KbIuDfa50KS+4xGlKxNCaPhl6X6iaLklbQ2
         RZpfa9ZuN7XgBIloSxtRuHAoU35QzjmpUiDOiwrqvkuMmfzC4XGrGYGDTw90PT33O2
         XdhxoWWjHoz05/3ECHIoEpwmcRs47Z/cw/yqUVkHjblpHdK+Bf+32gVOpTgzE8SY2o
         xQ8615Esqjj3Q==
Subject: [PATCHSET v8 00/20] xfs: deferred inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:43:53 -0700
Message-ID: <162758423315.332903.16799817941903734904.stgit@magnolia>
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

v1-v2: NYE patchbombs
v3: rebase against 5.12-rc2 for submission.
v4: combine the can/has eofblocks predicates, clean up incore inode tree
    walks, fix inobt deadlock
v5: actually freeze the inode gc threads when we freeze the filesystem,
    consolidate the code that deals with inode tagging, and use
    foreground inactivation during quotaoff to avoid cycling dquots
v6: rebase to 5.13-rc4, fix quotaoff not to require foreground inactivation,
    refactor to use inode walk goals, use atomic bitflags to control the
    scheduling of gc workers
v7: simplify the inodegc worker, which simplifies how flushes work, break
    up the patch into smaller pieces, flush inactive inodes on syncfs to
    simplify freeze/ro-remount handling, separate inode selection filtering
    in iget, refactor inode recycling further, change gc delay to 100ms,
    decrease the gc delay when space or quota are low, move most of the
    destroy_inode logic to mark_reclaimable, get rid of the fallocate flush
    scan thing, get rid of polled flush mode
v8: rebase against 5.14-rc2, hook the memory shrinkers so that we requeue
    inactivation immediately when memory starts to get tight and force
    callers queueing inodes for inactivation to wait for the inactivation
    workers to run (i.e. throttling the frontend) to reduce memory storms,
    add hch's quotaoff removal series as a dependency to shut down arguments
    about quota walks

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation-5.15
---
 Documentation/admin-guide/xfs.rst |   10 
 fs/xfs/libxfs/xfs_ag.c            |   13 +
 fs/xfs/libxfs/xfs_ag.h            |   13 +
 fs/xfs/scrub/common.c             |   10 
 fs/xfs/xfs_dquot.h                |   10 
 fs/xfs/xfs_globals.c              |    5 
 fs/xfs/xfs_icache.c               |  848 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h               |    7 
 fs/xfs/xfs_inode.c                |   53 ++
 fs/xfs/xfs_inode.h                |   21 +
 fs/xfs/xfs_itable.c               |   42 ++
 fs/xfs/xfs_iwalk.c                |   33 +
 fs/xfs/xfs_linux.h                |    1 
 fs/xfs/xfs_log_recover.c          |    7 
 fs/xfs/xfs_mount.c                |   42 ++
 fs/xfs/xfs_mount.h                |   29 +
 fs/xfs/xfs_qm_syscalls.c          |    8 
 fs/xfs/xfs_super.c                |  110 +++--
 fs/xfs/xfs_sysctl.c               |    9 
 fs/xfs/xfs_sysctl.h               |    1 
 fs/xfs/xfs_trace.h                |  295 +++++++++++++
 fs/xfs/xfs_trans.c                |    5 
 22 files changed, 1463 insertions(+), 109 deletions(-)

