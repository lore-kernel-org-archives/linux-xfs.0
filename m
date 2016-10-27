Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:53709 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934542AbcJ0Nzg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2016 09:55:36 -0400
Date: Fri, 28 Oct 2016 00:09:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for 4.9-rc3
Message-ID: <20161027130918.GC22126@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

Hi Linus,

Can you please pull the fixes from the tag below? This update
contains fixes for most of the outstanding regressions introduced
with the 4.9-rc1 XFS merge. There is also a fix for an iomap bug,
too.

This is a quite a bit larger than I'd prefer for a -rc3, but most of
the change comes from cleaning up the new reflink copy on write
code; it's much simpler and easier to understand now. These changes
fixed several bugs in the new code, and it wasn't clear that
there was an easier/simpler way to fix them.  The rest of the fixes
are the usual size you'd expect at this stage.

I've left the commits to soak in linux-next for a some extra time
because of the size before asking you to pull, no new problems with
them have been reported so I think it's all OK. Let me if you
disagree and want me to do this differently.

-Dave.

The following changes since commit 1001354ca34179f3db924eb66672442a173147dc:

  Linux 4.9-rc1 (2016-10-15 12:17:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-fixes-for-linus-4.9-rc3

for you to fetch changes up to c17a8ef43d6b80ed3519b828c37d18645445949f:

  xfs: clear cowblocks tag when cow fork is emptied (2016-10-24 14:21:08 +1100)

----------------------------------------------------------------
xfs: updates for 4.9-rc3

Changes in this update:
o iomap page offset masking fix for page faults
o add IOMAP_REPORT to distinguish between read and fiemap map requests
o cleanups to new shared data extent code
o fix mount active status on failed log recovery
o fix broken dquots in a buffer calculation
o fix locking order issues and merge xfs_reflink_remap_range and
  xfs_file_share_range
o rework unmapping of CoW extents and remove now unused functions
o clean state when CoW is done.

----------------------------------------------------------------
Brian Foster (2):
      xfs: fix up inode cowblocks tracking tracepoints
      xfs: clear cowblocks tag when cow fork is emptied

Christoph Hellwig (14):
      xfs: don't take the IOLOCK exclusive for direct I/O page invalidation
      xfs: remove the same fs check from xfs_file_share_range
      xfs: fix the same_inode check in xfs_file_share_range
      xfs: move inode locking from xfs_reflink_remap_range to xfs_file_share_range
      xfs: remove xfs_file_wait_for_io
      xfs: merge xfs_reflink_remap_range and xfs_file_share_range
      iomap: add IOMAP_REPORT
      xfs: handle "raw" delayed extents xfs_reflink_trim_around_shared
      xfs: don't bother looking at the refcount tree for reads
      xfs: optimize writes to reflink files
      xfs: refactor xfs_bunmapi_cow
      xfs: optimize xfs_reflink_cancel_cow_blocks
      xfs: optimize xfs_reflink_end_cow
      xfs: remove xfs_bunmapi_cow

Colin Ian King (1):
      xfs: remove redundant assignment of ifp

Darrick J. Wong (3):
      xfs: unset MS_ACTIVE if mount fails
      libxfs: clean up _calc_dquots_per_chunk
      xfs: add xfs_trim_extent

Eric Biggers (1):
      xfs: add some 'static' annotations

Eric Sandeen (1):
      xfs: remove pointless error goto in xfs_bmap_remap_alloc

Geert Uytterhoeven (1):
      xfs: Fix uninitialized variable in xfs_reflink_reserve_cow_range()

Jan Kara (1):
      fs: Do to trim high file position bits in iomap_page_mkwrite_actor

Roger Willcocks (1):
      libxfs: v3 inodes are only valid on crc-enabled filesystems

 fs/iomap.c                    |   5 +-
 fs/xfs/libxfs/xfs_bmap.c      | 418 ++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_bmap.h      |   8 +-
 fs/xfs/libxfs/xfs_btree.c     |   2 +-
 fs/xfs/libxfs/xfs_dquot_buf.c |   3 +-
 fs/xfs/libxfs/xfs_format.h    |   1 -
 fs/xfs/libxfs/xfs_inode_buf.c |  13 +-
 fs/xfs/libxfs/xfs_inode_buf.h |   2 +
 fs/xfs/xfs_file.c             | 232 +++-----------------
 fs/xfs/xfs_icache.c           |   8 +-
 fs/xfs/xfs_iomap.c            |  57 +++--
 fs/xfs/xfs_mount.c            |   1 +
 fs/xfs/xfs_reflink.c          | 499 +++++++++++++++++++++++-------------------
 fs/xfs/xfs_reflink.h          |  11 +-
 fs/xfs/xfs_sysfs.c            |   4 +-
 fs/xfs/xfs_trace.h            |   4 +-
 include/linux/iomap.h         |  17 +-
 17 files changed, 640 insertions(+), 645 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
