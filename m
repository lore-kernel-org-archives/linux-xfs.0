Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C357C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B28064F59
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhCRWe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:34:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231916AbhCRWd7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DCC064E0C;
        Thu, 18 Mar 2021 22:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106839;
        bh=SwsHJTA4kmkUQKa8WrU7knTgMstSraYvBdRyLrAEnXU=;
        h=Subject:From:To:Cc:Date:From;
        b=TqYVpuxQTZLWaEl1NwmDdysvZ5XzuWDZg3O5KqbQ9pKla/R3ptvYvoRXZtlV/ZqN2
         jguh1ewnlBsfNfPwLXvDZdxA1hMx+JbVdE57ymCIltdvUOdSALVFXx21lfzRetj+pM
         4qeh/jdP6VdlMTomKoLV3ruqCBRCS7zNmWYpCjn2lcQlOjd7ZJjgA9tQ2zBVvcZiZa
         Q5cfAS0u4DROG1W1sXoqR29cKHviSnwLaq7MHrvB/HLyD/t10wO0j6BMeTJpjCjaBj
         9GCl34SOfLp3HH5BVwmvsAOSFartLzpvyDUhjbNKCudzUHI1to00suxF8Ee8U9vGu9
         wi726JXVuyeAg==
Subject: [PATCHSET v4 0/7] xfs: deferred inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:33:58 -0700
Message-ID: <161610683869.1887744.8863884017621115954.stgit@magnolia>
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

The first four patches that shift the inactivation call paths over to
the background workqueue, and fix a few places where it was found to be
advantageous to force frontend threads to push and wait for inactivation
before making allocation decisions.

The next two patches improve the performance of inactivation by
enabling parallelization of the work and playing more nicely with vfs
callers who hold locks.

The last patch fixes a livelock vector that we can hit when walking the
inode btree (if the inode btree contains a cycle) when servicing a
BULKSTAT request.

v1-v2: NYE patchbombs
v3: rebase against 5.12-rc2 for submission.
v4: combine the can/has eofblocks predicates, clean up incore inode tree
    walks, fix inobt deadlock

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation-5.13
---
 Documentation/admin-guide/xfs.rst |   12 +
 fs/xfs/scrub/common.c             |    2 
 fs/xfs/xfs_bmap_util.c            |   44 +++
 fs/xfs/xfs_fsops.c                |    9 +
 fs/xfs/xfs_globals.c              |    3 
 fs/xfs/xfs_icache.c               |  495 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h               |   10 +
 fs/xfs/xfs_inode.c                |   93 +++++++
 fs/xfs/xfs_inode.h                |   16 +
 fs/xfs/xfs_itable.c               |   42 +++
 fs/xfs/xfs_iwalk.c                |   32 ++
 fs/xfs/xfs_linux.h                |    1 
 fs/xfs/xfs_log_recover.c          |    7 +
 fs/xfs/xfs_mount.c                |   16 +
 fs/xfs/xfs_mount.h                |   11 +
 fs/xfs/xfs_qm_syscalls.c          |   20 +
 fs/xfs/xfs_super.c                |   53 +++-
 fs/xfs/xfs_sysctl.c               |    9 +
 fs/xfs/xfs_sysctl.h               |    1 
 fs/xfs/xfs_trace.h                |   16 +
 20 files changed, 856 insertions(+), 36 deletions(-)

