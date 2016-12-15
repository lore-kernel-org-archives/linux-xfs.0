Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20671 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753628AbcLOEQo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2016 23:16:44 -0500
Date: Thu, 15 Dec 2016 15:16:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 4.10-rc1
Message-ID: <20161215041639.GU4219@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, djwong@djwong.org

Hi Linus,

Can you please pull the XFS update from the tag below? There is
quite a varied bunch of stuff in this update, and some of it
you will have already merged through the ext4 tree which imported
the dax-4.10-iomap-pmd topic branch from the XFS tree.

There is also a new direct IO implementation that uses the iomap
infrastructure. It's much simpler, faster, and has lower IO latency
than the existing direct IO infrastructure. However, there were
dependencies on the block tree and dax-4.10-iomap-pmd changes (both
of which you've already merged) so there's some merge issues that
you need to be aware of. The linux-next patch from Stephen here:

https://lkml.org/lkml/2016/12/13/755

addresses the block tree merge issues, whilst the resolution of the
include/linux/iomap.h conflict for the IOMAP_DIRECT flag addition
is obvious.

In other news you need to know about, this is likely the last pull
request you'll see from me for some time. I'm about to go on
extended leave at xmas time and won't be back until July next year.
While I'm gone, Darrick is going to be taking over the job of
feeding the XFS kernel tree and sending you pull requests. The
location of the XFS tree will also change - I've already set up a
new tree at fs/xfs/xfs-linux on kernel.org. Once everything for this
merge window is sorted out, we'll get linux-next pointed at the new
tree and all future will be done against that tree.

Darrick is currently planning to send you a MAINTAINER file update
pull request some time around -rc3/-rc4 to make sure he's familiar
with the process before the next merge window rolls around.

-Dave.

The following changes since commit 9484ab1bf4464faae695321dd4fa66365beda74e:

  dax: Introduce IOMAP_FAULT flag (2016-11-10 10:26:50 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.10-rc1

for you to fetch changes up to 9807b773dad4555665931d57065d7f8adab58e0f:

  Merge branch 'xfs-4.10-misc-fixes-4' into for-next (2016-12-09 16:56:26 +1100)

----------------------------------------------------------------
xfs: updates for 4.10-rc1

Contained in this update:
- DAX PMD vaults via iomap infrastructure
- Direct-io support in iomap infrastructure
- removal of now-redundant XFS inode iolock, replaced with VFS i_rwsem
- synchronisation with fixes and changes in userspace libxfs code
- extent tree lookup helpers
- lots of little corruption detection improvements to verifiers
- optimised CRC calculations
- faster buffer cache lookups
- deprecation of barrier/nobarrier mount options - we always use
  REQ_FUA/REQ_FLUSH where appropriate for data integrity now
- cleanups to speculative preallocation
- miscellaneous minor bug fixes and cleanups

----------------------------------------------------------------
Bhumika Goyal (2):
      fs: xfs: xfs_icreate_item: constify xfs_item_ops structure
      fs: xfs: libxfs: constify xfs_nameops structures

Brian Foster (6):
      xfs: don't skip cow forks w/ delalloc blocks in cowblocks scan
      xfs: don't BUG() on mixed direct and mapped I/O
      xfs: fix unbalanced inode reclaim flush locking
      xfs: track preallocation separately in xfs_bmapi_reserve_delalloc()
      xfs: clean up cow fork reservation and tag inodes correctly
      xfs: pass post-eof speculative prealloc blocks to bmapi

Christoph Hellwig (18):
      xfs: new inode extent list lookup helpers
      xfs: cleanup xfs_bmap_last_before
      xfs: use new extent lookup helpers in xfs_bmapi_read
      xfs: use new extent lookup helpers in xfs_bmapi_write
      xfs: use new extent lookup helpers in __xfs_bunmapi
      xfs: remove prev argument to xfs_bmapi_reserve_delalloc
      xfs: use new extent lookup helpers xfs_file_iomap_begin_delay
      xfs: use new extent lookup helpers in __xfs_reflink_reserve_cow
      xfs: cleanup xfs_reflink_find_cow_mapping
      xfs: use new extent lookup helpers in xfs_reflink_trim_irec_to_next_cow
      xfs: use new extent lookup helpers in xfs_reflink_cancel_cow_blocks
      xfs: use new extent lookup helpers in xfs_reflink_end_cow
      xfs: remove xfs_bmap_search_extents
      xfs: remove NULLEXTNUM
      xfs: remove i_iolock and use i_rwsem in the VFS inode instead
      fs: make sb_init_dio_done_wq available outside of direct-io.c
      iomap: implement direct I/O
      xfs: use iomap_dio_rw

Darrick J. Wong (18):
      libxfs: convert ushort to unsigned short
      libxfs: synchronize dinode_verify with userspace
      libxfs: fix whitespace problems
      libxfs: fix xfs_attr_shortform_bytesfit declaration
      libxfs: clean up _dir2_data_freescan
      xfs: move dir_ino_validate declaration per xfsprogs
      xfs: check return value of _trans_reserve_quota_nblks
      xfs: check minimum block size for CRC filesystems
      xfs: factor rmap btree size into the indlen calculations
      xfs: always succeed when deduping zero bytes
      xfs: forbid AG btrees with level == 0
      xfs: check for bogus values in btree block headers
      xfs: complain if we don't get nextents bmap records
      xfs: don't crash if reading a directory results in an unexpected hole
      xfs: error out if trying to add attrs and anextents > 0
      xfs: don't allow di_size with high bit set
      xfs: don't cap maximum dedupe request length
      xfs: use GPF_NOFS when allocating btree cursors

Dave Chinner (13):
      Merge branch 'dax-4.10-iomap-pmd' into for-next
      Merge branch 'xfs-4.10-libxfs-cleanups' into for-next
      Merge branch 'xfs-4.10-misc-fixes-1' into for-next
      Merge branch 'xfs-4.10-extent-lookup' into for-next
      Merge branch 'xfs-4.10-misc-fixes-2' into for-next
      Merge branch 'xfs-4.10-misc-fixes-2' into iomap-4.10-directio
      Merge branch 'iomap-4.10-directio' into for-next
      xfs: make xfs btree stats less huge
      xfs: optimise CRC updates
      Merge branch 'xfs-4.10-misc-fixes-3' into for-next
      xfs: Always flush caches when integrity is required
      xfs: deprecate barrier/nobarrier mount option
      Merge branch 'xfs-4.10-misc-fixes-4' into for-next

Eric Sandeen (11):
      xfs: don't call xfs_sb_quota_from_disk twice
      xfs: fix up xfs_swap_extent_forks inline extent handling
      xfs: provide helper for counting extents from if_bytes
      xfs: add XBF_XBF_NO_IOACCT to buf trace output
      xfs: set AGI buffer type in xlog_recover_clear_agi_bucket
      xfs: Move AGI buffer type setting to xfs_read_agi
      xfs: pass state not whichfork to trace_xfs_extlist
      xfs: handle cow fork in xfs_bmap_trace_exlist
      xfs: several xattr functions can be void
      xfs: ignore leaf attr ichdr.count in verifier during log replay
      xfs: nuke unused tracepoint definitions

Eryu Guan (1):
      xfs: use xfs_vn_setattr_size to check on new size

Kent Overstreet (1):
      block: add bio_iov_iter_get_pages()

Lucas Stach (1):
      xfs: use rhashtable to track buffer cache

Peter Zijlstra (1):
      locking/lockdep: Provide a type check for lock_is_held

 Documentation/filesystems/xfs.txt  |  12 +-
 block/bio.c                        |  49 +++
 fs/direct-io.c                     |   2 +-
 fs/internal.h                      |   3 +
 fs/iomap.c                         | 378 ++++++++++++++++++-
 fs/xfs/libxfs/xfs_alloc.c          |  10 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |   6 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |   8 +-
 fs/xfs/libxfs/xfs_attr_leaf.h      |   4 +-
 fs/xfs/libxfs/xfs_bmap.c           | 748 +++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_bmap.h           |  17 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |   3 +-
 fs/xfs/libxfs/xfs_btree.c          |  22 +-
 fs/xfs/libxfs/xfs_btree.h          |  43 +--
 fs/xfs/libxfs/xfs_cksum.h          |  26 +-
 fs/xfs/libxfs/xfs_defer.c          |  17 +-
 fs/xfs/libxfs/xfs_dir2.c           |   2 +-
 fs/xfs/libxfs/xfs_dir2.h           |   5 +
 fs/xfs/libxfs/xfs_dir2_data.c      |  26 +-
 fs/xfs/libxfs/xfs_dir2_priv.h      |   1 -
 fs/xfs/libxfs/xfs_dquot_buf.c      |   3 +-
 fs/xfs/libxfs/xfs_format.h         |   1 -
 fs/xfs/libxfs/xfs_ialloc.c         |  18 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |  29 +-
 fs/xfs/libxfs/xfs_inode_buf.h      |   6 +-
 fs/xfs/libxfs/xfs_inode_fork.c     |  77 +++-
 fs/xfs/libxfs/xfs_inode_fork.h     |   7 +
 fs/xfs/libxfs/xfs_log_format.h     |   4 +-
 fs/xfs/libxfs/xfs_log_recover.h    |   2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   1 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |   1 +
 fs/xfs/libxfs/xfs_rtbitmap.c       |   1 -
 fs/xfs/libxfs/xfs_sb.c             |  13 +-
 fs/xfs/libxfs/xfs_types.h          |   4 +-
 fs/xfs/xfs_aops.c                  | 286 +-------------
 fs/xfs/xfs_aops.h                  |   6 -
 fs/xfs/xfs_attr.h                  |   4 +-
 fs/xfs/xfs_attr_list.c             |  59 ++-
 fs/xfs/xfs_bmap_util.c             |  45 +--
 fs/xfs/xfs_buf.c                   | 123 +++---
 fs/xfs/xfs_buf.h                   |   3 +-
 fs/xfs/xfs_dir2_readdir.c          |   2 -
 fs/xfs/xfs_file.c                  | 460 ++++++-----------------
 fs/xfs/xfs_icache.c                |  48 +--
 fs/xfs/xfs_icreate_item.c          |   2 +-
 fs/xfs/xfs_inode.c                 |  84 ++---
 fs/xfs/xfs_inode.h                 |  18 +-
 fs/xfs/xfs_inode_item.c            |   4 +-
 fs/xfs/xfs_ioctl.c                 |   8 +-
 fs/xfs/xfs_iomap.c                 | 149 +++++---
 fs/xfs/xfs_iops.c                  |  14 +-
 fs/xfs/xfs_linux.h                 |   1 +
 fs/xfs/xfs_log.c                   |  41 +-
 fs/xfs/xfs_log_recover.c           |  16 +-
 fs/xfs/xfs_mount.c                 |   8 +-
 fs/xfs/xfs_mount.h                 |   7 +-
 fs/xfs/xfs_pnfs.c                  |   7 +-
 fs/xfs/xfs_pnfs.h                  |   4 +-
 fs/xfs/xfs_qm.c                    |   2 +-
 fs/xfs/xfs_reflink.c               | 628 +++++++++++++++----------------
 fs/xfs/xfs_reflink.h               |  17 +-
 fs/xfs/xfs_stats.c                 |  10 +-
 fs/xfs/xfs_stats.h                 | 200 ++++------
 fs/xfs/xfs_super.c                 |  27 +-
 fs/xfs/xfs_symlink.c               |   7 +-
 fs/xfs/xfs_sysfs.c                 |   4 +-
 fs/xfs/xfs_trace.h                 | 113 +-----
 fs/xfs/xfs_xattr.c                 |  23 +-
 include/linux/bio.h                |   1 +
 include/linux/iomap.h              |  28 +-
 include/linux/lockdep.h            |  25 +-
 kernel/locking/lockdep.c           |  20 +-
 73 files changed, 1994 insertions(+), 2063 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
