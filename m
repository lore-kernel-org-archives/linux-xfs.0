Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933912AbeFLWAg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 18:00:36 -0400
Date: Tue, 12 Jun 2018 15:00:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: 4.18 merge, part 2
Message-ID: <20180612220035.GL22045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's the second round of patches for XFS for 4.18.  Most of the
commits are small cleanups, bug fixes, and continued strengthening of
metadata verifiers; the bulk of the diff is the conversion of the
fs/xfs/ tree to use SPDX tags.

This series has been run through a full xfstests run over the weekend
and through a quick xfstests run against this morning's master, with no
major failures reported.

--D

The following changes since commit afd9d6a1df75807684fa40dab77c52e104e5c74b:

  fs: use ->is_partially_uptodate in page_cache_seek_hole_data (2018-06-01 18:37:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.18-merge-10

for you to fetch changes up to 89e9b5c0915aaeaf673a14e794c559768eda5534:

  xfs: update incore per-AG inode count (2018-06-11 21:53:52 -0700)

----------------------------------------------------------------
Changes since last update:
- Strengthen metadata checking to avoid ASSERTing on bad disk contents
- Validate btree records that are being retrieved for clients
- Strengthen root inode verification
- Convert license blurbs to SPDX tags
- Enable changing DAX flag on directories
- Fix some writeback deadlocks in reflink
- Refactor out some old xfs helpers
- Move type verifiers to a separate file
- Fix some fuzzer crashes
- Various other bug fixes

----------------------------------------------------------------
Arnd Bergmann (1):
      xfs: fix string handling in label get/set functions

Darrick J. Wong (15):
      xfs: don't forbid setting dax flag on directories if device doesn't dax
      xfs: don't assert when reporting on-disk corruption while loading btree
      xfs: remove redundant ASSERT on insufficient bestfree length in _leaf_addname
      xfs: xfs_alloc_get_rec should return EFSCORRUPTED for obvious bnobt corruption
      xfs: btree lookup shouldn't ASSERT on empty btree nodes
      xfs: don't ASSERT on short form btree root pointer of zero
      xfs: don't return garbage buffers in xfs_da3_node_read
      xfs: check directory bestfree information in the verifier
      xfs: introduce xfs_btree_debug_check_ptr
      xfs: strengthen btree pointer checks before use
      xfs: don't assert when on-disk btree pointers are garbage
      xfs: explicitly pass buffer size to xfs_corruption_error
      xfs: don't assert on corrupted unlinked inode list
      iomap: fsync swap files before iterating mappings
      xfs: update incore per-AG inode count

Dave Chinner (13):
      xfs: verify AGI unlinked list contains valid blocks
      xfs: catch bad stripe alignment configurations
      xfs: verify extent size hint is valid in inode verifier
      xfs: verify COW extent size hint is valid in inode verifier
      xfs: verify root inode more thoroughly
      xfs: push corruption -> ESTALE conversion to xfs_nfs_get_inode()
      xfs: validate btree records on retrieval
      xfs: convert to SPDX license tags
      xfs: setup VFS i_rwsem lockdep state correctly
      xfs: xfs_reflink_convert_cow() memory allocation deadlock
      xfs: move various type verifiers to common file
      xfs: clean up MIN/MAX
      xfs: replace do_mod with native operations

Eric Sandeen (2):
      xfs: use xfs_trans_getsb in xfs_sync_sb_buf
      xfs: don't call xfs_da_shrink_inode with NULL bp

 fs/iomap.c                         |   6 +-
 fs/xfs/Makefile                    |  15 +---
 fs/xfs/kmem.c                      |  14 +--
 fs/xfs/kmem.h                      |  14 +--
 fs/xfs/libxfs/xfs_ag_resv.c        |  16 +---
 fs/xfs/libxfs/xfs_ag_resv.h        |  16 +---
 fs/xfs/libxfs/xfs_alloc.c          |  95 ++++++--------------
 fs/xfs/libxfs/xfs_alloc.h          |  18 +---
 fs/xfs/libxfs/xfs_alloc_btree.c    |  15 +---
 fs/xfs/libxfs/xfs_alloc_btree.h    |  14 +--
 fs/xfs/libxfs/xfs_attr.c           |  14 +--
 fs/xfs/libxfs/xfs_attr_leaf.c      |  21 +----
 fs/xfs/libxfs/xfs_attr_leaf.h      |  14 +--
 fs/xfs/libxfs/xfs_attr_remote.c    |  14 +--
 fs/xfs/libxfs/xfs_attr_remote.h    |  14 +--
 fs/xfs/libxfs/xfs_attr_sf.h        |  14 +--
 fs/xfs/libxfs/xfs_bit.c            |  14 +--
 fs/xfs/libxfs/xfs_bit.h            |  14 +--
 fs/xfs/libxfs/xfs_bmap.c           |  54 ++++++------
 fs/xfs/libxfs/xfs_bmap.h           |  14 +--
 fs/xfs/libxfs/xfs_bmap_btree.c     |  14 +--
 fs/xfs/libxfs/xfs_bmap_btree.h     |  14 +--
 fs/xfs/libxfs/xfs_btree.c          | 171 ++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_btree.h          |  14 +--
 fs/xfs/libxfs/xfs_da_btree.c       |  24 ++---
 fs/xfs/libxfs/xfs_da_btree.h       |  14 +--
 fs/xfs/libxfs/xfs_da_format.c      |  14 +--
 fs/xfs/libxfs/xfs_da_format.h      |  14 +--
 fs/xfs/libxfs/xfs_defer.c          |  16 +---
 fs/xfs/libxfs/xfs_defer.h          |  16 +---
 fs/xfs/libxfs/xfs_dir2.c           |  14 +--
 fs/xfs/libxfs/xfs_dir2.h           |  14 +--
 fs/xfs/libxfs/xfs_dir2_block.c     |  22 ++---
 fs/xfs/libxfs/xfs_dir2_data.c      | 122 +++++++++++++++-----------
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  26 ++----
 fs/xfs/libxfs/xfs_dir2_node.c      |  17 +---
 fs/xfs/libxfs/xfs_dir2_priv.h      |  14 +--
 fs/xfs/libxfs/xfs_dir2_sf.c        |  14 +--
 fs/xfs/libxfs/xfs_dquot_buf.c      |  14 +--
 fs/xfs/libxfs/xfs_errortag.h       |  15 +---
 fs/xfs/libxfs/xfs_format.h         |  14 +--
 fs/xfs/libxfs/xfs_fs.h             |  14 +--
 fs/xfs/libxfs/xfs_ialloc.c         | 160 +++++++++-------------------------
 fs/xfs/libxfs/xfs_ialloc.h         |  21 +----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  14 +--
 fs/xfs/libxfs/xfs_ialloc_btree.h   |  14 +--
 fs/xfs/libxfs/xfs_iext_tree.c      |  10 +--
 fs/xfs/libxfs/xfs_inode_buf.c      |  34 ++++----
 fs/xfs/libxfs/xfs_inode_buf.h      |  14 +--
 fs/xfs/libxfs/xfs_inode_fork.c     |  14 +--
 fs/xfs/libxfs/xfs_inode_fork.h     |  14 +--
 fs/xfs/libxfs/xfs_log_format.h     |  14 +--
 fs/xfs/libxfs/xfs_log_recover.h    |  14 +--
 fs/xfs/libxfs/xfs_log_rlimit.c     |  14 +--
 fs/xfs/libxfs/xfs_quota_defs.h     |  14 +--
 fs/xfs/libxfs/xfs_refcount.c       |  63 +++++++++-----
 fs/xfs/libxfs/xfs_refcount.h       |  16 +---
 fs/xfs/libxfs/xfs_refcount_btree.c |  17 +---
 fs/xfs/libxfs/xfs_refcount_btree.h |  16 +---
 fs/xfs/libxfs/xfs_rmap.c           |  55 +++++++++---
 fs/xfs/libxfs/xfs_rmap.h           |  16 +---
 fs/xfs/libxfs/xfs_rmap_btree.c     |  15 +---
 fs/xfs/libxfs/xfs_rmap_btree.h     |  14 +--
 fs/xfs/libxfs/xfs_rtbitmap.c       |  26 +-----
 fs/xfs/libxfs/xfs_sb.c             |  40 +++++----
 fs/xfs/libxfs/xfs_sb.h             |  14 +--
 fs/xfs/libxfs/xfs_shared.h         |  14 +--
 fs/xfs/libxfs/xfs_symlink_remote.c |  14 +--
 fs/xfs/libxfs/xfs_trans_resv.c     |  30 ++-----
 fs/xfs/libxfs/xfs_trans_resv.h     |  14 +--
 fs/xfs/libxfs/xfs_trans_space.h    |  14 +--
 fs/xfs/libxfs/xfs_types.c          | 173 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h          |  33 ++++---
 fs/xfs/mrlock.h                    |  14 +--
 fs/xfs/scrub/agheader.c            |  18 +---
 fs/xfs/scrub/agheader_repair.c     |  16 +---
 fs/xfs/scrub/alloc.c               |  16 +---
 fs/xfs/scrub/attr.c                |  16 +---
 fs/xfs/scrub/bmap.c                |  16 +---
 fs/xfs/scrub/btree.c               |  16 +---
 fs/xfs/scrub/btree.h               |  16 +---
 fs/xfs/scrub/common.c              |  16 +---
 fs/xfs/scrub/common.h              |  16 +---
 fs/xfs/scrub/dabtree.c             |  16 +---
 fs/xfs/scrub/dabtree.h             |  16 +---
 fs/xfs/scrub/dir.c                 |  16 +---
 fs/xfs/scrub/ialloc.c              |  16 +---
 fs/xfs/scrub/inode.c               |  16 +---
 fs/xfs/scrub/parent.c              |  16 +---
 fs/xfs/scrub/quota.c               |  16 +---
 fs/xfs/scrub/refcount.c            |  16 +---
 fs/xfs/scrub/repair.c              |  16 +---
 fs/xfs/scrub/repair.h              |  16 +---
 fs/xfs/scrub/rmap.c                |  16 +---
 fs/xfs/scrub/rtbitmap.c            |  16 +---
 fs/xfs/scrub/scrub.c               |  16 +---
 fs/xfs/scrub/scrub.h               |  16 +---
 fs/xfs/scrub/symlink.c             |  16 +---
 fs/xfs/scrub/trace.c               |  16 +---
 fs/xfs/scrub/trace.h               |  16 +---
 fs/xfs/scrub/xfs_scrub.h           |  16 +---
 fs/xfs/xfs.h                       |  14 +--
 fs/xfs/xfs_acl.c                   |  14 +--
 fs/xfs/xfs_acl.h                   |  14 +--
 fs/xfs/xfs_aops.c                  |  25 +++---
 fs/xfs/xfs_aops.h                  |  14 +--
 fs/xfs/xfs_attr.h                  |  14 +--
 fs/xfs/xfs_attr_inactive.c         |  14 +--
 fs/xfs/xfs_attr_list.c             |  19 +---
 fs/xfs/xfs_bmap_item.c             |  16 +---
 fs/xfs/xfs_bmap_item.h             |  16 +---
 fs/xfs/xfs_bmap_util.c             |  26 ++----
 fs/xfs/xfs_bmap_util.h             |  14 +--
 fs/xfs/xfs_buf.c                   |  15 +---
 fs/xfs/xfs_buf.h                   |  14 +--
 fs/xfs/xfs_buf_item.c              |  16 +---
 fs/xfs/xfs_buf_item.h              |  14 +--
 fs/xfs/xfs_dir2_readdir.c          |  14 +--
 fs/xfs/xfs_discard.c               |  14 +--
 fs/xfs/xfs_dquot.c                 |  14 +--
 fs/xfs/xfs_dquot.h                 |  14 +--
 fs/xfs/xfs_dquot_item.c            |  14 +--
 fs/xfs/xfs_dquot_item.h            |  14 +--
 fs/xfs/xfs_error.c                 |  19 +---
 fs/xfs/xfs_error.h                 |  23 ++---
 fs/xfs/xfs_export.c                |  29 +++----
 fs/xfs/xfs_export.h                |  14 +--
 fs/xfs/xfs_extent_busy.c           |  14 +--
 fs/xfs/xfs_extent_busy.h           |  14 +--
 fs/xfs/xfs_extfree_item.c          |  14 +--
 fs/xfs/xfs_extfree_item.h          |  14 +--
 fs/xfs/xfs_file.c                  |  14 +--
 fs/xfs/xfs_filestream.c            |  14 +--
 fs/xfs/xfs_filestream.h            |  14 +--
 fs/xfs/xfs_fsmap.c                 |  16 +---
 fs/xfs/xfs_fsmap.h                 |  16 +---
 fs/xfs/xfs_fsops.c                 |  14 +--
 fs/xfs/xfs_fsops.h                 |  14 +--
 fs/xfs/xfs_globals.c               |  14 +--
 fs/xfs/xfs_icache.c                |  14 +--
 fs/xfs/xfs_icache.h                |  14 +--
 fs/xfs/xfs_icreate_item.c          |  14 +--
 fs/xfs/xfs_icreate_item.h          |  14 +--
 fs/xfs/xfs_inode.c                 |  35 ++++----
 fs/xfs/xfs_inode.h                 |  14 +--
 fs/xfs/xfs_inode_item.c            |  14 +--
 fs/xfs/xfs_inode_item.h            |  14 +--
 fs/xfs/xfs_ioctl.c                 |  33 +++----
 fs/xfs/xfs_ioctl.h                 |  14 +--
 fs/xfs/xfs_ioctl32.c               |  14 +--
 fs/xfs/xfs_ioctl32.h               |  14 +--
 fs/xfs/xfs_iomap.c                 |  20 +----
 fs/xfs/xfs_iomap.h                 |  18 +---
 fs/xfs/xfs_iops.c                  |  22 ++---
 fs/xfs/xfs_iops.h                  |  14 +--
 fs/xfs/xfs_itable.c                |  16 +---
 fs/xfs/xfs_itable.h                |  14 +--
 fs/xfs/xfs_linux.h                 |  36 +-------
 fs/xfs/xfs_log.c                   |  18 +---
 fs/xfs/xfs_log.h                   |  14 +--
 fs/xfs/xfs_log_cil.c               |  14 +--
 fs/xfs/xfs_log_priv.h              |  14 +--
 fs/xfs/xfs_log_recover.c           |  67 ++++++++------
 fs/xfs/xfs_message.c               |  14 +--
 fs/xfs/xfs_mount.c                 |  21 ++---
 fs/xfs/xfs_mount.h                 |  16 +---
 fs/xfs/xfs_mru_cache.c             |  14 +--
 fs/xfs/xfs_mru_cache.h             |  14 +--
 fs/xfs/xfs_ondisk.h                |  14 +--
 fs/xfs/xfs_qm.c                    |  14 +--
 fs/xfs/xfs_qm.h                    |  14 +--
 fs/xfs/xfs_qm_bhv.c                |  14 +--
 fs/xfs/xfs_qm_syscalls.c           |  14 +--
 fs/xfs/xfs_quota.h                 |  14 +--
 fs/xfs/xfs_quotaops.c              |  14 +--
 fs/xfs/xfs_refcount_item.c         |  16 +---
 fs/xfs/xfs_refcount_item.h         |  16 +---
 fs/xfs/xfs_reflink.c               |  16 +---
 fs/xfs/xfs_reflink.h               |  16 +---
 fs/xfs/xfs_rmap_item.c             |  16 +---
 fs/xfs/xfs_rmap_item.h             |  16 +---
 fs/xfs/xfs_rtalloc.c               |  24 ++---
 fs/xfs/xfs_rtalloc.h               |  14 +--
 fs/xfs/xfs_stats.c                 |  14 +--
 fs/xfs/xfs_stats.h                 |  14 +--
 fs/xfs/xfs_super.c                 |  16 +---
 fs/xfs/xfs_super.h                 |  14 +--
 fs/xfs/xfs_symlink.c               |  14 +--
 fs/xfs/xfs_symlink.h               |  14 +--
 fs/xfs/xfs_sysctl.c                |  14 +--
 fs/xfs/xfs_sysctl.h                |  14 +--
 fs/xfs/xfs_sysfs.c                 |  14 +--
 fs/xfs/xfs_sysfs.h                 |  14 +--
 fs/xfs/xfs_trace.c                 |  14 +--
 fs/xfs/xfs_trace.h                 |  14 +--
 fs/xfs/xfs_trans.c                 |  14 +--
 fs/xfs/xfs_trans.h                 |  14 +--
 fs/xfs/xfs_trans_ail.c             |  14 +--
 fs/xfs/xfs_trans_bmap.c            |  16 +---
 fs/xfs/xfs_trans_buf.c             |  14 +--
 fs/xfs/xfs_trans_dquot.c           |  14 +--
 fs/xfs/xfs_trans_extfree.c         |  14 +--
 fs/xfs/xfs_trans_inode.c           |  14 +--
 fs/xfs/xfs_trans_priv.h            |  14 +--
 fs/xfs/xfs_trans_refcount.c        |  16 +---
 fs/xfs/xfs_trans_rmap.c            |  16 +---
 fs/xfs/xfs_xattr.c                 |  14 +--
 207 files changed, 939 insertions(+), 3195 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_types.c
