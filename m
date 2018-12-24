Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34736 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbeLXA05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Dec 2018 19:26:57 -0500
Date: Sun, 23 Dec 2018 16:26:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: updates for v4.21
Message-ID: <20181224002649.GJ27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net

Hi Linus,

Here are a number of bug fixes for 4.21-rc1.  It has undergone the usual
testing regimen and merges cleanly with 4.20 final.  Let me know if you
encounter any problems with the merge.

--D

The following changes since commit 40e020c129cfc991e8ab4736d2665351ffd1468d:

  Linux 4.20-rc6 (2018-12-09 15:31:00 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.21-merge-2

for you to fetch changes up to 65eed012d1f2d0f0bf0ffc036826d58147de77b8:

  xfs: reallocate realtime summary cache on growfs (2018-12-21 18:45:18 -0800)

----------------------------------------------------------------
XFS changes for 4.21:
- Fix CoW remapping of extremely fragmented file areas
- Fix a zero-length symlink verifier error
- Constify some of the rmap owner structures for per-AG metadata
- Precalculate inode geometry for later use
- Fix scrub counting problems
- Don't crash when rtsummary inode is null
- Fix x32 ioctl operation
- Fix enum->string mappings for ftrace output
- Cache realtime summary information in memory

----------------------------------------------------------------
Colin Ian King (1):
      xfs: clean up indentation issues, remove an unwanted space

Darrick J. Wong (16):
      xfs: split up the xfs_reflink_end_cow work into smaller transactions
      xfs: idiotproof defer op type configuration
      xfs: streamline defer op type handling
      xfs: const-ify xfs_owner_info arguments
      xfs: remove xfs_rmap_ag_owner and friends
      xfs: add a block to inode count converter
      xfs: precalculate inodes and blocks per inode cluster
      xfs: precalculate cluster alignment in inodes and blocks
      xfs: count inode blocks correctly in inobt scrub
      xfs: require both realtime inodes to mount
      xfs: fix function pointer type in ftrace format
      xfs: fix symbolic enum printing in ftrace output
      xfs: move XFS_AG_BTREE_CMP_FORMAT_STR mappings to libxfs
      xfs: move XFS_INODE_FORMAT_STR mappings to libxfs
      xfs: stringify btree cursor types in ftrace output
      xfs: stringify scrub types in ftrace output

Dave Chinner (1):
      xfs: zero length symlinks are not valid

Nick Bowler (3):
      xfs: Align compat attrlist_by_handle with native implementation.
      xfs: Fix bulkstat compat ioctls on x32 userspace.
      xfs: Fix x32 ioctls when cmd numbers differ from ia32.

Omar Sandoval (2):
      xfs: cache minimum realtime summary level
      xfs: reallocate realtime summary cache on growfs

Pan Bian (1):
      xfs: libxfs: move xfs_perag_put late

 fs/xfs/libxfs/xfs_ag.c             |   9 +-
 fs/xfs/libxfs/xfs_alloc.c          |  79 ++++++------
 fs/xfs/libxfs/xfs_alloc.h          |   4 +-
 fs/xfs/libxfs/xfs_bmap.c           |   6 +-
 fs/xfs/libxfs/xfs_bmap.h           |   4 +-
 fs/xfs/libxfs/xfs_defer.c          |  67 ++++++-----
 fs/xfs/libxfs/xfs_defer.h          |  37 +++---
 fs/xfs/libxfs/xfs_format.h         |  12 ++
 fs/xfs/libxfs/xfs_ialloc.c         |  54 ++++-----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   7 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   6 +-
 fs/xfs/libxfs/xfs_rmap.c           | 240 +++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_rmap.h           |  54 ++++-----
 fs/xfs/libxfs/xfs_rtbitmap.c       |   6 +
 fs/xfs/libxfs/xfs_symlink_remote.c |  14 ++-
 fs/xfs/libxfs/xfs_types.c          |   9 +-
 fs/xfs/libxfs/xfs_types.h          |  22 ++++
 fs/xfs/scrub/agheader.c            |  25 ++--
 fs/xfs/scrub/agheader_repair.c     |   5 +-
 fs/xfs/scrub/alloc.c               |   4 +-
 fs/xfs/scrub/btree.c               |  45 +++----
 fs/xfs/scrub/btree.h               |  22 ++--
 fs/xfs/scrub/common.c              |  14 +--
 fs/xfs/scrub/common.h              |   2 +-
 fs/xfs/scrub/ialloc.c              |  64 +++++-----
 fs/xfs/scrub/inode.c               |   4 +-
 fs/xfs/scrub/refcount.c            |  16 +--
 fs/xfs/scrub/repair.c              |  54 ++++-----
 fs/xfs/scrub/repair.h              |   7 +-
 fs/xfs/scrub/rmap.c                |  35 +++---
 fs/xfs/scrub/scrub.h               |   4 +-
 fs/xfs/scrub/trace.h               | 131 +++++++++++++++-----
 fs/xfs/xfs_aops.h                  |   3 +
 fs/xfs/xfs_extfree_item.c          |   5 +-
 fs/xfs/xfs_fsops.c                 |   2 +-
 fs/xfs/xfs_inode.c                 |  16 +--
 fs/xfs/xfs_ioctl32.c               |  58 +++++++--
 fs/xfs/xfs_itable.c                |  14 +--
 fs/xfs/xfs_log_recover.c           |   8 +-
 fs/xfs/xfs_mount.c                 |   4 +
 fs/xfs/xfs_mount.h                 |  11 ++
 fs/xfs/xfs_reflink.c               | 232 ++++++++++++++++++++---------------
 fs/xfs/xfs_rtalloc.c               |  57 +++++++--
 fs/xfs/xfs_super.c                 |  10 +-
 fs/xfs/xfs_symlink.c               |  33 ++---
 fs/xfs/xfs_trace.h                 |  51 +++++---
 fs/xfs/xfs_trans.h                 |   7 +-
 fs/xfs/xfs_trans_bmap.c            |  11 +-
 fs/xfs/xfs_trans_extfree.c         |  40 +++----
 fs/xfs/xfs_trans_refcount.c        |  11 +-
 fs/xfs/xfs_trans_rmap.c            |  11 +-
 51 files changed, 932 insertions(+), 714 deletions(-)
