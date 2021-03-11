Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CEFC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2561964EDB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhCKDGD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCKDFl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:05:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCC2B64EDB;
        Thu, 11 Mar 2021 03:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615431940;
        bh=6hm66mlQTib785hPn2DF6bFu7IxZApFwowebBETta9A=;
        h=Subject:From:To:Cc:Date:From;
        b=BLl2PpDs7cp8B7ByN5dQMOutyDI5q5Lt9+Eg/jsc5ZEFkJesjOAQSHuTEQtevvstY
         M2LyZtdScSOmyyIiKpqpmM6DaDVKEY47zYQU7qri040Wn5l+OFPpz6ZRS/2tYXbE6J
         XTvI5pjor49w83zhRydTdXeyrxmmGVYhalLzRiq4oTwhUuQILMaD4crUyuSECDnM6x
         1HgOuD27yni/O91WcvZ0vw4mOtgbfGlcNnciX3tUdBEgSzkqsrgPn0jBOkk5yu9m+f
         ZjgPnsInbGjtVGa6pYVj8IMzvp1vJWpx8dCULYbLwxAmFA5RsyeDdaTPuFdW2Do6UC
         16lcHpktQahAw==
Subject: [PATCHSET v3 00/11] xfs: deferred inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Mar 2021 19:05:40 -0800
Message-ID: <161543194009.1947934.9910987247994410125.stgit@magnolia>
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

The first patch prohibits automatic inactivation of metadata files.
This has been the source of subtle fs corruption problems in the past,
either due to growfs bugs or nlink incorrectly being set to zero.

The next four patches in the set perform prep work, refactoring
predicates and changing dquot behavior slightly to handle what comes
next.

The four patches after that shift the inactivation call paths over to
the background workqueue, and fix a few places where it was found to be
advantageous to force frontend threads to push and wait for inactivation
before making allocation decisions.

The final two patches improve the performance of inactivation by
enabling parallelization of the work and playing more nicely with vfs
callers who hold locks.

v1-v2: NYE patchbombs
v3: rebase against 5.12-rc2 for submission.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation-5.13
---
 Documentation/admin-guide/xfs.rst |   14 +
 fs/xfs/libxfs/xfs_iext_tree.c     |    2 
 fs/xfs/scrub/common.c             |    2 
 fs/xfs/xfs_bmap_util.c            |  173 +++++++++----
 fs/xfs/xfs_bmap_util.h            |    1 
 fs/xfs/xfs_fsops.c                |    9 +
 fs/xfs/xfs_globals.c              |    3 
 fs/xfs/xfs_icache.c               |  512 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h               |   11 +
 fs/xfs/xfs_inode.c                |  112 ++++++++
 fs/xfs/xfs_inode.h                |   24 ++
 fs/xfs/xfs_linux.h                |    1 
 fs/xfs/xfs_log_recover.c          |    7 +
 fs/xfs/xfs_mount.c                |   16 +
 fs/xfs/xfs_mount.h                |   13 +
 fs/xfs/xfs_qm.c                   |   29 ++
 fs/xfs/xfs_qm.h                   |   17 +
 fs/xfs/xfs_qm_syscalls.c          |   20 +
 fs/xfs/xfs_super.c                |   61 ++++
 fs/xfs/xfs_sysctl.c               |    9 +
 fs/xfs/xfs_sysctl.h               |    1 
 fs/xfs/xfs_trace.h                |   15 +
 fs/xfs/xfs_xattr.c                |    2 
 23 files changed, 960 insertions(+), 94 deletions(-)

