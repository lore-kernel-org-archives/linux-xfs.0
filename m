Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754398AbdGJQjz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jul 2017 12:39:55 -0400
Date: Mon, 10 Jul 2017 09:39:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: updates for 4.13
Message-ID: <20170710163954.GJ4103@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here are some changes for you for 4.13.  For the most part it's fixes
for bugs and deadlock problems, and preparation for online fsck in some
future merge window.  The branch merges against this morning's HEAD
without issue; a quick overnight xfstests run against yesterday's HEAD
came out cleanly.  Let me know if there are any problems.

--Darrick

The following changes since commit 41f1830f5a7af77cf5c86359aba3cbd706687e52:

  Linux 4.12-rc6 (2017-06-19 22:19:37 +0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.13-merge-5

for you to fetch changes up to cd87d867920155911d0d2e6485b769d853547750:

  xfs: don't crash on unexpected holes in dir/attr btrees (2017-07-07 18:55:17 -0700)

----------------------------------------------------------------
Changes for 4.13:
- Avoid quotacheck deadlocks
- Fix transaction overflows when bunmapping fragmented files
- Refactor directory readahead
- Allow admin to configure if ASSERT is fatal
- Improve transaction usage detail logging during overflows
- Minor cleanups
- Don't leak log items when the log shuts down
- Remove double-underscore typedefs
- Various preparation for online scrubbing
- Introduce new error injection configuration sysfs knobs
- Refactor dq_get_next to use extent map directly
- Fix problems with iterating the page cache for unwritten data
- Implement SEEK_{HOLE,DATA} via iomap
- Refactor XFS to use iomap SEEK_HOLE and SEEK_DATA
- Don't use MAXPATHLEN to check on-disk symlink target lengths

----------------------------------------------------------------
Andreas Gruenbacher (2):
      vfs: Add page_cache_seek_hole_data helper
      vfs: Add iomap_seek_hole and iomap_seek_data helpers

Arnd Bergmann (1):
      xfs: avoid harmless gcc-7 warnings

Brian Foster (12):
      xfs: push buffer of flush locked dquot to avoid quotacheck deadlock
      xfs: define bug_on_assert debug mode sysfs tunable
      xfs: define fatal assert build time tunable
      xfs: separate shutdown from ticket reservation print helper
      xfs: refactor xlog_cil_insert_items() to facilitate transaction dump
      xfs: dump transaction usage details on log reservation overrun
      xfs: release bli from transaction properly on fs shutdown
      xfs: remove bli from AIL before release on transaction abort
      xfs: free uncommitted transactions during log recovery
      xfs: replace log_badcrc_factor knob with error injection tag
      xfs: free cowblocks and retry on buffered write ENOSPC
      xfs: fix contiguous dquot chunk iteration livelock

Carlos Maiolino (1):
      xfs: Check for m_errortag initialization in xfs_errortag_test

Christoph Hellwig (4):
      xfs: remove XFS_HSIZE
      xfs: rewrite xfs_dq_get_next_id using xfs_iext_lookup_extent
      xfs: remove a whitespace-only line from xfs_fs_get_nextdqblk
      xfs: Switch to iomap for SEEK_HOLE / SEEK_DATA

Darrick J. Wong (25):
      xfs: refactor dir2 leaf readahead shadow buffer cleverness
      xfs: try to avoid blowing out the transaction reservation when bunmaping a shared extent
      xfs: optimize _btree_query_all
      xfs: remove double-underscore integer types
      xfs: always compile the btree inorder check functions
      xfs: export various function for the online scrubber
      xfs: plumb in needed functions for range querying of various btrees
      xfs: export _inobt_btrec_to_irec and _ialloc_cluster_alignment for scrub
      xfs: check if an inode is cached and allocated
      xfs: reflink find shared should take a transaction
      xfs: separate function to check if inode shares extents
      xfs: make _bmap_count_blocks consistent wrt delalloc extent behavior
      xfs: refactor the ifork block counting function
      xfs: return the hash value of a leaf1 directory block
      xfs: pass along transaction context when reading directory block buffers
      xfs: pass along transaction context when reading xattr block buffers
      xfs: allow reading of already-locked remote symbolic link
      xfs: don't allow bmap on rt files
      xfs: make errortag a per-mountpoint structure
      xfs: expose errortag knobs via sysfs
      xfs: remove unneeded parameter from XFS_TEST_ERROR
      xfs: convert drop_writes to use the errortag mechanism
      xfs: grab dquots without taking the ilock
      xfs: rename MAXPATHLEN to XFS_SYMLINK_MAXLEN
      xfs: don't crash on unexpected holes in dir/attr btrees

Jan Kara (1):
      xfs: Don't clear SGID when inheriting ACLs

Shan Hai (1):
      xfs: remove lsn relevant fields from xfs_trans structure and its users

kbuild test robot (1):
      xfs: fix semicolon.cocci warnings

 fs/buffer.c                        | 124 ++++++++++++
 fs/iomap.c                         |  94 +++++++++
 fs/xfs/Kconfig                     |  13 ++
 fs/xfs/libxfs/xfs_ag_resv.c        |   3 +-
 fs/xfs/libxfs/xfs_alloc.c          |   8 +-
 fs/xfs/libxfs/xfs_alloc.h          |   2 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |  26 +--
 fs/xfs/libxfs/xfs_attr.c           |  26 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c      |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c    |  13 +-
 fs/xfs/libxfs/xfs_attr_sf.h        |  10 +-
 fs/xfs/libxfs/xfs_bit.h            |  24 +--
 fs/xfs/libxfs/xfs_bmap.c           |  51 +++--
 fs/xfs/libxfs/xfs_bmap.h           |   2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |  34 +++-
 fs/xfs/libxfs/xfs_btree.c          |  52 ++---
 fs/xfs/libxfs/xfs_btree.h          |  33 ++--
 fs/xfs/libxfs/xfs_cksum.h          |  16 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  14 +-
 fs/xfs/libxfs/xfs_da_btree.h       |   8 +-
 fs/xfs/libxfs/xfs_da_format.c      |  28 +--
 fs/xfs/libxfs/xfs_da_format.h      |  64 +++----
 fs/xfs/libxfs/xfs_dir2.c           |   3 +-
 fs/xfs/libxfs/xfs_dir2.h           |   8 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |   2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  18 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |  10 +-
 fs/xfs/libxfs/xfs_dir2_priv.h      |  10 +-
 fs/xfs/libxfs/xfs_dir2_sf.c        |   2 +-
 fs/xfs/libxfs/xfs_format.h         | 113 +++++------
 fs/xfs/libxfs/xfs_fs.h             |  16 +-
 fs/xfs/libxfs/xfs_ialloc.c         |  53 +++---
 fs/xfs/libxfs/xfs_ialloc.h         |   5 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  36 +++-
 fs/xfs/libxfs/xfs_inode_buf.c      |   7 +-
 fs/xfs/libxfs/xfs_inode_buf.h      |  31 +--
 fs/xfs/libxfs/xfs_log_format.h     | 256 ++++++++++++-------------
 fs/xfs/libxfs/xfs_log_recover.h    |   2 +-
 fs/xfs/libxfs/xfs_quota_defs.h     |   6 +-
 fs/xfs/libxfs/xfs_refcount.c       |  16 +-
 fs/xfs/libxfs/xfs_refcount.h       |  16 ++
 fs/xfs/libxfs/xfs_refcount_btree.c |  12 +-
 fs/xfs/libxfs/xfs_rmap.c           |  14 +-
 fs/xfs/libxfs/xfs_rmap.h           |  11 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  34 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c       |   4 +-
 fs/xfs/libxfs/xfs_sb.c             |   4 +-
 fs/xfs/libxfs/xfs_symlink_remote.c |   2 +-
 fs/xfs/libxfs/xfs_trans_resv.c     |   4 +-
 fs/xfs/libxfs/xfs_types.h          |  46 ++---
 fs/xfs/xfs.h                       |   4 +
 fs/xfs/xfs_acl.c                   |   6 +-
 fs/xfs/xfs_acl.h                   |   1 +
 fs/xfs/xfs_aops.c                  |  11 +-
 fs/xfs/xfs_attr.h                  |   3 +
 fs/xfs/xfs_attr_list.c             |  61 +++---
 fs/xfs/xfs_bmap_item.c             |  17 +-
 fs/xfs/xfs_bmap_util.c             | 164 +++++++++-------
 fs/xfs/xfs_bmap_util.h             |   4 +
 fs/xfs/xfs_buf.c                   |  62 +++++-
 fs/xfs/xfs_buf.h                   |   1 +
 fs/xfs/xfs_buf_item.c              |  21 ++-
 fs/xfs/xfs_dir2_readdir.c          | 341 ++++++++++-----------------------
 fs/xfs/xfs_discard.c               |   4 +-
 fs/xfs/xfs_dquot.c                 |  85 ++++-----
 fs/xfs/xfs_error.c                 | 319 ++++++++++++++++++++++++-------
 fs/xfs/xfs_error.h                 |  44 +++--
 fs/xfs/xfs_file.c                  | 378 ++-----------------------------------
 fs/xfs/xfs_fsops.c                 |  16 +-
 fs/xfs/xfs_fsops.h                 |   4 +-
 fs/xfs/xfs_globals.c               |   5 +
 fs/xfs/xfs_icache.c                |  52 ++++-
 fs/xfs/xfs_icache.h                |   4 +
 fs/xfs/xfs_inode.c                 |  17 +-
 fs/xfs/xfs_inode.h                 |   7 +-
 fs/xfs/xfs_ioctl.c                 |  27 ++-
 fs/xfs/xfs_ioctl.h                 |  10 +-
 fs/xfs/xfs_ioctl32.h               |   6 +-
 fs/xfs/xfs_iomap.c                 |   4 +-
 fs/xfs/xfs_iops.c                  |   6 +-
 fs/xfs/xfs_itable.c                |   2 +-
 fs/xfs/xfs_itable.h                |   2 +
 fs/xfs/xfs_linux.h                 |  21 +--
 fs/xfs/xfs_log.c                   |  87 ++++++---
 fs/xfs/xfs_log.h                   |   2 +-
 fs/xfs/xfs_log_cil.c               |  91 +++++----
 fs/xfs/xfs_log_priv.h              |   3 +-
 fs/xfs/xfs_log_recover.c           |  49 +++--
 fs/xfs/xfs_message.c               |   5 +-
 fs/xfs/xfs_mount.c                 |  26 ++-
 fs/xfs/xfs_mount.h                 |  60 +++---
 fs/xfs/xfs_qm.c                    |  28 ++-
 fs/xfs/xfs_qm_bhv.c                |   2 +-
 fs/xfs/xfs_quotaops.c              |   1 -
 fs/xfs/xfs_reflink.c               | 101 +++++-----
 fs/xfs/xfs_reflink.h               |   8 +-
 fs/xfs/xfs_rtalloc.c               |   8 +-
 fs/xfs/xfs_rtalloc.h               |   3 +
 fs/xfs/xfs_stats.c                 |   8 +-
 fs/xfs/xfs_stats.h                 | 190 +++++++++----------
 fs/xfs/xfs_super.c                 |  26 +--
 fs/xfs/xfs_symlink.c               |  12 +-
 fs/xfs/xfs_symlink.h               |   1 +
 fs/xfs/xfs_sysctl.h                |   1 +
 fs/xfs/xfs_sysfs.c                 |  81 ++------
 fs/xfs/xfs_trace.h                 |  40 ++--
 fs/xfs/xfs_trans.h                 |   8 +-
 fs/xfs/xfs_trans_bmap.c            |  11 +-
 fs/xfs/xfs_trans_buf.c             |  21 ++-
 fs/xfs/xfs_trans_rmap.c            |   2 +-
 include/linux/buffer_head.h        |   2 +
 include/linux/iomap.h              |   4 +
 112 files changed, 2121 insertions(+), 1857 deletions(-)
