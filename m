Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754978AbeDCEuq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Apr 2018 00:50:46 -0400
Date: Mon, 2 Apr 2018 21:49:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: new features for 4.17
Message-ID: <20180403044906.GI13552@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's the first round of fixes for XFS for 4.17.  The biggest new
features this time around are the addition of lazytime support, further
enhancement of the on-disk inode metadata verifiers, and a patch to
smooth over some of the AGFL padding problems that have intermittently
plagued users since 4.5.  I forsee sending a second pull request next
week with further bug fixes and speedups in the online scrub code and
elsewhere.

This series has been run through a full xfstests run over the weekend
and through a quick xfstests run against this morning's master, with no
major failures reported.  Let me know if there's any merge problems.

--D

The following changes since commit 0c8efd610b58cb23cefdfa12015799079aef94ae:

  Linux 4.16-rc5 (2018-03-11 17:25:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.17-merge-1

for you to fetch changes up to dc1baa715bbfbb1902da942d06497e79b40e7bc7:

  xfs: do not log/recover swapext extent owner changes for deleted inodes (2018-03-29 10:19:15 -0700)

----------------------------------------------------------------
Changes for this release:
- Various cleanups and code fixes
- Implement lazytime as a mount option
- Convert various on-disk metadata checks from asserts to -EFSCORRUPTED
- Fix accounting problems with the rmap per-ag reservations
- Refactorings and cleanups for xfs_log_force
- Various bugfixes for the reflink code
- Work around v5 AGFL padding problems to prevent fs shutdowns
- Establish inode fork verifiers to inspect on-disk metadata correctness
- Various online scrub fixes
- Fix v5 swapext blowing up on deleted inodes

----------------------------------------------------------------
Brian Foster (6):
      xfs: shutdown if block allocation overruns tx reservation
      xfs: account format bouncing into rmapbt swapext tx reservation
      xfs: rename agfl perag res type to rmapbt
      xfs: account only rmapbt-used blocks against rmapbt perag res
      xfs: detect agfl count corruption and reset agfl
      xfs: clean up xfs_mount allocation and dynamic initializers

Carlos Maiolino (1):
      Cleanup old XFS_BTREE_* traces

Christoph Hellwig (16):
      fs: don't clear I_DIRTY_TIME before calling mark_inode_dirty_sync
      xfs: implement the lazytime mount option
      xfs: remove misleading comment text on xfs_inode_item_unlock
      xfs: remove an outdated comment for xfs_inode_item_committing
      xfs: remove the unused log_flushed variable in xfs_extent_busy_flush
      xfs: merge _xfs_log_force and xfs_log_force
      xfs: merge _xfs_log_force_lsn and xfs_log_force_lsn
      xfs: refactor xfs_log_force
      xfs: fix the check for COW extents in xfs_swap_extents
      xfs: don't use XFS_BMAPI_ENTRIRE in xfs_get_blocks
      xfs: assert that xfs_reflink_allocate_cow is called with XFS_ILOCK_EXCL
      xfs: remove xfs_zero_range
      xfs: minor cleanup for xfs_get_blocks
      xfs: minor cleanup for xfs_reflink_end_cow
      xfs: refactor xfs_log_force_lsn
      xfs: unwind the try_again loop in xfs_log_force

Darrick J. Wong (15):
      xfs: don't iunlock the quota ip when quota block
      xfs: convert a few more directory asserts to corruption
      xfs: check for cow blocks before trying to clear them
      xfs: sanity-check the unused space before trying to use it
      xfs: refactor bmap record validation
      xfs: refactor inode verifier error logging
      xfs: refactor inode buffer verifier error logging
      xfs: bmap scrubber should do rmap xref with bmap for sparse files
      xfs: inode scrubber shouldn't bother with raw checks
      xfs: remove xfs_buf parameter from inode scrub methods
      xfs: record inode buf errors as a xref error in inobt scrubber
      xfs: move inode extent size hint validation to libxfs
      xfs: don't accept inode buffers with suspicious unlinked chains
      xfs: flag inode corruption if parent ptr doesn't get us a real inode
      xfs: xfs_scrub_iallocbt_xref_rmap_inodes should use xref_set_corrupt

Dave Chinner (6):
      xfs: fall back to vmalloc when allocation log vector buffers
      xfs: fix transaction allocation deadlock in IO path
      xfs: convert XFS_AGFL_SIZE to a helper function
      inode: don't memset the inode address space twice
      xfs: catch inode allocation state mismatch corruption
      xfs: remove dead inode version setting code

Eric Sandeen (2):
      xfs: remove unused m_dmevmask from xfs_mount struct
      xfs: do not log/recover swapext extent owner changes for deleted inodes

Matthew Wilcox (1):
      xfs: Rename xa_ elements to ail_

Nikolay Borisov (1):
      xfs: Remove dead code from inode recover function

Vratislav Bendel (1):
      xfs: Correctly invert xfs_buftarg LRU isolation logic

 fs/inode.c                         |  12 ++++--
 fs/sync.c                          |   6 +--
 fs/xfs/kmem.c                      |   6 +--
 fs/xfs/kmem.h                      |   8 +++-
 fs/xfs/libxfs/xfs_ag_resv.c        |  39 ++++++++++--------
 fs/xfs/libxfs/xfs_ag_resv.h        |  31 ++++++++++++++
 fs/xfs/libxfs/xfs_alloc.c          | 139 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_alloc.h          |   2 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |   8 +---
 fs/xfs/libxfs/xfs_bmap.c           |  51 ++++++++++++++++++++---
 fs/xfs/libxfs/xfs_bmap.h           |   3 ++
 fs/xfs/libxfs/xfs_bmap_btree.c     |   4 +-
 fs/xfs/libxfs/xfs_bmap_btree.h     |  14 -------
 fs/xfs/libxfs/xfs_btree.c          | 125 ++++----------------------------------------------------
 fs/xfs/libxfs/xfs_btree.h          |  19 ---------
 fs/xfs/libxfs/xfs_dir2.h           |   2 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |  59 ++++++++++++++++-----------
 fs/xfs/libxfs/xfs_dir2_data.c      |  78 +++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  13 ++++--
 fs/xfs/libxfs/xfs_dir2_node.c      |  16 +++++---
 fs/xfs/libxfs/xfs_format.h         |  13 +-----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   9 +---
 fs/xfs/libxfs/xfs_inode_buf.c      | 124 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_inode_buf.h      |   5 +++
 fs/xfs/libxfs/xfs_inode_fork.c     |  27 +++++++-----
 fs/xfs/libxfs/xfs_refcount_btree.c |   5 ---
 fs/xfs/libxfs/xfs_rmap_btree.c     |  12 +++---
 fs/xfs/libxfs/xfs_sb.c             |   1 -
 fs/xfs/scrub/agheader.c            |   6 +--
 fs/xfs/scrub/attr.c                |   2 +-
 fs/xfs/scrub/bmap.c                | 174 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/common.c              |  24 ++++-------
 fs/xfs/scrub/common.h              |  13 +++---
 fs/xfs/scrub/dir.c                 |   2 +-
 fs/xfs/scrub/ialloc.c              |   5 ++-
 fs/xfs/scrub/inode.c               | 298 +++++++++++++++++++++++++++++++-----------------------------------------------------------------------------------------------------
 fs/xfs/scrub/parent.c              |  12 +++++-
 fs/xfs/scrub/quota.c               |   2 +-
 fs/xfs/scrub/rtbitmap.c            |   3 +-
 fs/xfs/scrub/trace.h               |  31 +++-----------
 fs/xfs/xfs_aops.c                  |  20 ++++-----
 fs/xfs/xfs_bmap_util.c             |  44 ++++++++++++--------
 fs/xfs/xfs_buf.c                   |   2 +-
 fs/xfs/xfs_buf_item.c              |  10 ++---
 fs/xfs/xfs_dquot.c                 |   6 +--
 fs/xfs/xfs_dquot_item.c            |  11 ++---
 fs/xfs/xfs_error.c                 |  29 ++++++++++---
 fs/xfs/xfs_error.h                 |   3 ++
 fs/xfs/xfs_export.c                |   2 +-
 fs/xfs/xfs_extent_busy.c           |   5 +--
 fs/xfs/xfs_file.c                  |  52 ++++-------------------
 fs/xfs/xfs_fsops.c                 |   2 +-
 fs/xfs/xfs_icache.c                |  23 ++++++++++-
 fs/xfs/xfs_inode.c                 |  11 ++++-
 fs/xfs/xfs_inode.h                 |   4 --
 fs/xfs/xfs_inode_item.c            |  29 +++++--------
 fs/xfs/xfs_iops.c                  |  17 +++++++-
 fs/xfs/xfs_log.c                   | 376 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------------------------------
 fs/xfs/xfs_log.h                   |  15 ++-----
 fs/xfs/xfs_log_cil.c               |   2 +-
 fs/xfs/xfs_log_recover.c           | 100 +++++++++++++++++++--------------------------
 fs/xfs/xfs_mount.c                 |   4 --
 fs/xfs/xfs_mount.h                 |  13 +++---
 fs/xfs/xfs_reflink.c               |  25 ++++++------
 fs/xfs/xfs_super.c                 |  71 +++++++++++++++++++++++---------
 fs/xfs/xfs_trace.h                 |   9 +++-
 fs/xfs/xfs_trans.c                 |  32 ++++++++-------
 fs/xfs/xfs_trans_ail.c             | 152 ++++++++++++++++++++++++++++++++++----------------------------------
 fs/xfs/xfs_trans_buf.c             |   4 +-
 fs/xfs/xfs_trans_inode.c           |  14 +++++++
 fs/xfs/xfs_trans_priv.h            |  42 +++++++++----------
 71 files changed, 1365 insertions(+), 1167 deletions(-)
