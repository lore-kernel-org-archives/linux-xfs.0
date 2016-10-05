Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:48379 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750700AbcJEV32 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2016 17:29:28 -0400
Date: Thu, 6 Oct 2016 08:29:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 4.9-rc1
Message-ID: <20161005212909.GR27872@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

Hi Linus,

Can you please pull the XFS and iomap updates from the tag listed
below? The main things in this update are the iomap-based DAX
infrastructure, an XFS delalloc rework, and a chunk of fixes to how
log recovery schedules writeback to prevent spurious corruption
detections when recovery of certain items was not required.

The other main chunk of code is some preparation for the upcoming
reflink functionality. Most of it is generic and cleanups that stand
alone, but they were ready and reviewed so are in this pull request.

Speaking of reflink, I'm currently planning to send you another pull
request next week containing all the new reflink functionality.  I'm
working through a similar process to the last cycle, where I sent
the reverse mapping code in a separate request because of how large
it was. The reflink code merge is even bigger than reverse mapping,
so I'll be doing the same thing again....

Thanks,

-Dave.

The following changes since commit 32438cf9d54bd53b531f6d98814e84dd278360c1:

  Merge branch 'iomap-fixes-4.8-rc3' into for-next (2016-08-17 11:13:37 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.9-rc1

for you to fetch changes up to 155cd433b516506df065866f3d974661f6473572:

  Merge branch 'xfs-4.9-log-recovery-fixes' into for-next (2016-10-03 09:56:28 +1100)

----------------------------------------------------------------
xfs: updates for 4.9-rc1

Included in this update:
- change of XFS mailing list to linux-xfs@vger.kernel.org
- iomap-based DAX infrastructure w/ XFS and ext2 support
- small iomap fixes and additions
- more efficient XFS delayed allocation infrastructure based on iomap
- a rework of log recovery writeback scheduling to ensure we don't
  fail recovery when trying to replay items that are already on disk
- some preparation patches for upcoming reflink support
- configurable error handling fixes and documentation
- aio access time update race fixes for XFS and generic_file_read_iter

----------------------------------------------------------------
Artem Savkov (1):
      Make __xfs_xattr_put_listen preperly report errors.

Brian Foster (6):
      xfs: prevent dropping ioend completions during buftarg wait
      xfs: rework log recovery to submit buffers on LSN boundaries
      xfs: pass current lsn to log recovery buffer validation
      xfs: don't warn on buffers not being recovered due to LSN
      xfs: update metadata LSN in buffers during log recovery
      xfs: log recovery tracepoints to track current lsn and buffer submission

Carlos Maiolino (1):
      xfs: Document error handlers behavior

Christoph Hellwig (21):
      iomap: don't set FIEMAP_EXTENT_MERGED for extent based filesystems
      fs: add iomap_file_dirty
      xfs: move xfs_bmbt_to_iomap up
      xfs: factor our a helper to calculate the EOF alignment
      xfs: make xfs_inode_set_eofblocks_tag cheaper for the common case
      xfs: rewrite and optimize the delalloc write path
      iomap: add IOMAP_F_NEW flag
      iomap: expose iomap_apply outside iomap.c
      dax: don't pass buffer_head to dax_insert_mapping
      dax: don't pass buffer_head to copy_user_dax
      dax: provide an iomap based dax read/write path
      dax: provide an iomap based fault handler
      xfs: fix locking for DAX writes
      xfs: take the ilock shared if possible in xfs_file_iomap_begin
      xfs: refactor xfs_setfilesize
      xfs: use iomap to implement DAX
      ext2: stop passing buffer_head to ext2_get_blocks
      ext2: use iomap to implement DAX
      ext2: fix possible integer truncation in ext2_iomap_begin
      xfs: update atime before I/O in xfs_file_dio_aio_read
      fs: update atime before I/O in generic_file_read_iter

Darrick J. Wong (13):
      xfs: don't perform lookups on zero-height btrees
      xfs: disallow mounting of realtime + rmap filesystems
      xfs: don't log the entire end of the AGF
      xfs: fix some key handling problems in _btree_simple_query_range
      xfs: simple btree query range should look right if LE lookup fails
      xfs: track log done items directly in the deferred pending work item
      iomap: add a flag to report shared extents
      xfs: convert RUI log formats to use variable length arrays
      xfs: remove xfs_btree_bigkey
      xfs: create a standard btree size calculator code
      xfs: count the blocks in a btree
      xfs: defer should allow ->finish_item to request a new transaction
      xfs: set up per-AG free space reservations

Dave Chinner (9):
      xfs: fix superblock inprogress check
      xfs: change mailing list address
      xfs: remote attribute blocks aren't really userdata
      xfs: quiesce the filesystem after recovery on readonly mount
      Merge branch 'iomap-4.9-misc-fixes-1' into for-next
      Merge branch 'xfs-4.9-reflink-prep' into for-next
      Merge branch 'xfs-4.9-delalloc-rework' into for-next
      Merge branch 'iomap-4.9-dax' into for-next
      Merge branch 'xfs-4.9-log-recovery-fixes' into for-next

Eric Sandeen (1):
      xfs: normalize "infinite" retries in error configs

Eryu Guan (1):
      xfs: undo block reservation correctly in xfs_trans_reserve()

Xie XiuQi (1):
      xfs: fix signed integer overflow

 Documentation/filesystems/xfs.txt | 123 ++++++++++
 MAINTAINERS                       |   7 +-
 fs/dax.c                          | 252 ++++++++++++++++++-
 fs/ext2/Kconfig                   |   1 +
 fs/ext2/ext2.h                    |   1 +
 fs/ext2/file.c                    |  76 +++++-
 fs/ext2/inode.c                   | 100 ++++++--
 fs/internal.h                     |  11 +
 fs/iomap.c                        |  94 +++++++-
 fs/xfs/Makefile                   |   1 +
 fs/xfs/libxfs/xfs_ag_resv.c       | 325 +++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag_resv.h       |  35 +++
 fs/xfs/libxfs/xfs_alloc.c         | 137 +++++++----
 fs/xfs/libxfs/xfs_alloc.h         |  25 +-
 fs/xfs/libxfs/xfs_bmap.c          | 136 +++--------
 fs/xfs/libxfs/xfs_bmap.h          |  12 +-
 fs/xfs/libxfs/xfs_btree.c         |  73 +++++-
 fs/xfs/libxfs/xfs_btree.h         |  28 +--
 fs/xfs/libxfs/xfs_defer.c         |  96 ++++++--
 fs/xfs/libxfs/xfs_defer.h         |   2 +-
 fs/xfs/libxfs/xfs_format.h        |   6 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c  |   2 +-
 fs/xfs/libxfs/xfs_log_format.h    |  10 +-
 fs/xfs/libxfs/xfs_sb.c            |   3 +-
 fs/xfs/xfs_aops.c                 |  31 ++-
 fs/xfs/xfs_aops.h                 |   1 +
 fs/xfs/xfs_bmap_util.c            |   2 +-
 fs/xfs/xfs_buf.c                  |   2 +-
 fs/xfs/xfs_buf_item.c             |   9 +-
 fs/xfs/xfs_extent_busy.c          |   2 +-
 fs/xfs/xfs_file.c                 |  82 ++-----
 fs/xfs/xfs_filestream.c           |  13 +-
 fs/xfs/xfs_fsops.c                |   2 +-
 fs/xfs/xfs_icache.c               |  14 ++
 fs/xfs/xfs_inode.h                |   1 +
 fs/xfs/xfs_iomap.c                | 494 ++++++++++++++++++--------------------
 fs/xfs/xfs_iomap.h                |   2 -
 fs/xfs/xfs_log_priv.h             |   3 +-
 fs/xfs/xfs_log_recover.c          | 191 ++++++++++-----
 fs/xfs/xfs_mount.c                |  14 ++
 fs/xfs/xfs_mount.h                |  44 +++-
 fs/xfs/xfs_rmap_item.c            |  36 +--
 fs/xfs/xfs_rmap_item.h            |   8 +
 fs/xfs/xfs_super.c                |  16 +-
 fs/xfs/xfs_super.h                |   1 +
 fs/xfs/xfs_sysfs.c                |  47 +++-
 fs/xfs/xfs_trace.h                | 116 +++++++--
 fs/xfs/xfs_trans.c                |   3 +-
 fs/xfs/xfs_trans_extfree.c        |   3 +-
 fs/xfs/xfs_xattr.c                |   1 +
 include/linux/dax.h               |   6 +
 include/linux/iomap.h             |  12 +-
 mm/filemap.c                      |  14 +-
 53 files changed, 1989 insertions(+), 737 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_ag_resv.c
 create mode 100644 fs/xfs/libxfs/xfs_ag_resv.h
-- 
Dave Chinner
david@fromorbit.com
