Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:20491 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754484AbcK3FEc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2016 00:04:32 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1cBx4I-0003T6-2P
        for linux-xfs@vger.kernel.org; Wed, 30 Nov 2016 16:04:30 +1100
Date: Wed, 30 Nov 2016 16:04:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 5f1c6d28cfcd
Message-ID: <20161130050430.GG31101@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This is a merge of the new iomap-based direct
IO code, and the conversion of XFS to use it. It also removes the
XFs inode i_iolock and replaces it with the vfs inode i_rwsem, so
simplifying the locking heirarchy used within XFS.

-Dave.

The new head of the for-next branch is commit:

5f1c6d28cfcd Merge branch 'iomap-4.10-directio' into for-next

New Commits:

Christoph Hellwig (4):
      [6552321831dc] xfs: remove i_iolock and use i_rwsem in the VFS inode instead
      [ec1b826097f3] fs: make sb_init_dio_done_wq available outside of direct-io.c
      [ff6a9292e6f6] iomap: implement direct I/O
      [acdda3aae146] xfs: use iomap_dio_rw

Dave Chinner (2):
      [e3df41f97847] Merge branch 'xfs-4.10-misc-fixes-2' into iomap-4.10-directio
      [5f1c6d28cfcd] Merge branch 'iomap-4.10-directio' into for-next

Kent Overstreet (1):
      [3816199506c7] block: add bio_iov_iter_get_pages()

Peter Zijlstra (1):
      [f8319483f57f] locking/lockdep: Provide a type check for lock_is_held


Code Diffstat:

 block/bio.c               |  49 ++++++
 fs/direct-io.c            |   2 +-
 fs/internal.h             |   3 +
 fs/iomap.c                | 373 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_aops.c         | 298 ++----------------------------------
 fs/xfs/xfs_aops.h         |   6 -
 fs/xfs/xfs_bmap_util.c    |  12 +-
 fs/xfs/xfs_dir2_readdir.c |   2 -
 fs/xfs/xfs_file.c         | 226 ++++++++++------------------
 fs/xfs/xfs_icache.c       |   6 +-
 fs/xfs/xfs_inode.c        |  82 ++++------
 fs/xfs/xfs_inode.h        |   7 +-
 fs/xfs/xfs_ioctl.c        |   2 +-
 fs/xfs/xfs_iomap.c        |  50 ++++++-
 fs/xfs/xfs_iops.c         |  14 +-
 fs/xfs/xfs_pnfs.c         |   7 +-
 fs/xfs/xfs_pnfs.h         |   4 +-
 fs/xfs/xfs_reflink.c      |  14 +-
 fs/xfs/xfs_super.c        |   2 +-
 fs/xfs/xfs_symlink.c      |   7 +-
 include/linux/bio.h       |   1 +
 include/linux/iomap.h     |  11 ++
 include/linux/lockdep.h   |  25 +++-
 kernel/locking/lockdep.c  |  20 ++-
 24 files changed, 668 insertions(+), 555 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
