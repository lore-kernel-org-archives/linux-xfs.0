Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751920AbeFES7K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Jun 2018 14:59:10 -0400
Date: Tue, 5 Jun 2018 11:59:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: 4.18 merge, part 1
Message-ID: <20180605185909.GN9437@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's the first round of patches for XFS for 4.18.  New features this
cycle include the ability to relabel mounted filesystems, support for
fallocated swapfiles, and using FUA for pure data O_DSYNC directio
writes.  With this cycle we begin to integrate online filesystem repair
and refactor the growfs code in preparation for eventual subvolume
support, though the road ahead for both features is quite long.

There are also numerous refactorings of the iomap code to remove
unnecessary log overhead, to disentangle some of the quota code, and to
prepare for buffer head removal in a future upstream kernel.

Metadata validation continues to improve, both in the hot path veifiers
and the online filesystem check code.  I anticipate sending a second
pull request in a few days with more metadata validation improvements.

This series has been run through a full xfstests run over the weekend
and through a quick xfstests run against this morning's master, with no
major failures reported.

There's a merge conflict between one of the iomap refactorings and the
gfs2 changes in your master branch.  The file in question is
fs/gfs2/bmap.c.  I resolved the conflict and pushed the result as a
branch[1] into my git tree, and the resolved file should look like[2].
Let me know if things get hairy enough that you want me to take another
look at that.

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-4.18-merge-conflicts
[2] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/diff/fs/gfs2/bmap.c?h=xfs-4.18-merge-conflicts&id=54195b796f10860d1778dc09a9e9b1543a70301e

The following changes since commit 75bc37fefc4471e718ba8e651aa74673d4e0a9eb:

  Linux 4.17-rc4 (2018-05-06 16:57:38 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.18-merge-3

for you to fetch changes up to afd9d6a1df75807684fa40dab77c52e104e5c74b:

  fs: use ->is_partially_uptodate in page_cache_seek_hole_data (2018-06-01 18:37:33 -0700)

----------------------------------------------------------------
Changes for 4.18:
- Strengthen inode number and structure validation when allocating inodes.
- Reduce pointless buffer allocations during cache miss
- Use FUA for pure data O_DSYNC directio writes
- Various iomap refactorings
- Strengthen quota metadata verification to avoid unfixable broken quota
- Make AGFL block freeing a deferred operation to avoid blowing out
  transaction reservations when running complex operations
- Get rid of the log item descriptors to reduce log overhead
- Fix various reflink bugs where inodes were double-joined to
  transactions
- Don't issue discards when trimming unwritten extents
- Refactor incore dquot initialization and retrieval interfaces
- Fix some locking problmes in the quota scrub code
- Strengthen btree structure checks in scrub code
- Rewrite swapfile activation to use iomap and support unwritten extents
- Make scrub exit to userspace sooner when corruptions or
  cross-referencing problems are found
- Make scrub invoke the data fork scrubber directly on metadata inodes
- Don't do background reclamation of post-eof and cow blocks when the fs
  is suspended
- Fix secondary superblock buffer lifespan hinting
- Refactor growfs to use table-dispatched functions instead of long
  stringy functions
- Move growfs code to libxfs
- Implement online fs label getting and setting
- Introduce online filesystem repair (in a very limited capacity)
- Fix unit conversion problems in the realtime freemap iteration
  functions
- Various refactorings and cleanups in preparation to remove buffer
  heads in a future release
- Reimplement the old bmap call with iomap
- Remove direct buffer head accesses from seek hole/data
- Various bug fixes

----------------------------------------------------------------
Brian Foster (10):
      xfs: create agfl block free helper function
      xfs: defer agfl block frees when dfops is available
      xfs: defer agfl block frees from deferred ops processing context
      xfs: defer agfl frees from inode inactivation
      xfs: defer frees from common inode allocation paths
      xfs: defer agfl frees from directory op transactions
      xfs: add bmapi nodiscard flag
      xfs: skip online discard during eofblocks trims
      xfs: don't discard on free of unwritten extents
      xfs: factor out nodiscard helpers

Christoph Hellwig (14):
      block: add a lower-level bio_add_page interface
      mm: give the 'ret' variable a better name __do_page_cache_readahead
      mm: return an unsigned int from __do_page_cache_readahead
      mm: split ->readpages calls to avoid non-contiguous pages lists
      iomap: inline data should be an iomap type, not a flag
      iomap: fix the comment describing IOMAP_NOWAIT
      iomap: move IOMAP_F_BOUNDARY to gfs2
      iomap: use __bio_add_page in iomap_dio_zero
      iomap: add a iomap_sector helper
      iomap: add an iomap-based bmap implementation
      xfs: use iomap_bmap
      fs: move page_cache_seek_hole_data to iomap.c
      fs: remove the buffer_unwritten check in page_seek_hole_data
      fs: use ->is_partially_uptodate in page_cache_seek_hole_data

Darrick J. Wong (54):
      xfs: bmap debugging should never panic the system
      xfs: add missing rmap error return
      xfs: release new dquot buffer on defer_finish error
      xfs: don't spray logs when dquot flush/purge fail
      xfs: refactor XFS_QMOPT_DQNEXT out of existence
      xfs: refactor dquot cache handling
      xfs: delegate dqget input checks to helper function
      xfs: remove unnecessary xfs_qm_dqattach parameter
      xfs: split out dqget for inodes from regular dqget
      xfs: fetch dquots directly during quotacheck
      xfs: refactor incore dquot initialization functions
      xfs: refactor xfs_qm_dqtobp and xfs_qm_dqalloc
      xfs: remove direct calls to _qm_dqread
      xfs: replace XFS_QMOPT_DQALLOC with a simple boolean
      xfs: rename on-disk dquot counter zap functions
      xfs: refactor dquot iteration
      xfs: avoid ilock games in the quota scrubber
      xfs: clean up scrub usage of KM_NOFS
      xfs: btree scrub should check minrecs
      xfs: refactor scrub transaction allocation function
      xfs: add helpers to calculate btree size
      xfs: expose various functions to repair code
      xfs: add repair helpers for the reverse mapping btree
      xfs: add repair helpers for the reference count btree
      xfs: add BMAPI_NORMAP flag to perform block remapping without updating rmapbt
      xfs: halt auto-reclamation activities while rebuilding rmap
      iomap: add a swapfile activation function
      xfs: skip scrub xref if corruption already noted
      xfs: superblock scrub should use short-lived buffers
      xfs: refactor quota limits initialization
      xfs: don't continue scrub if already corrupt
      xfs: quota scrub should use bmapbtd scrubber
      xfs: scrub the data fork of the realtime inodes
      xfs: avoid ABBA deadlock when scrubbing parent pointers
      xfs: hoist xfs_scrub_agfl_walk to libxfs as xfs_agfl_walk
      xfs: make xfs_bmapi_remapi work with attribute forks
      xfs: teach xfs_bmapi_remap to accept some bmapi flags
      xfs: create tracepoints for online repair
      xfs: implement the metadata repair ioctl flag
      fs: clear writeback errors in inode_init_always
      xfs: fix inobt magic number check
      xfs: grab the per-ag structure whenever relevant
      xfs: add helpers to deal with transaction allocation and rolling
      xfs: add helpers to allocate and initialize fresh btree roots
      xfs: add helpers to collect and sift btree block pointers during repair
      xfs: add helpers to dispose of old btree blocks after a repair
      xfs: recover AG btree roots from rmap data
      xfs: add helpers to attach quotas to inodes
      xfs: repair superblocks
      fs: allow per-device dax status checking for filesystems
      xfs: xfs_rtword_t should be unsigned, not signed
      xfs: xfs_rtbuf_get should check the bmapi_read results
      xfs: strengthen rtalloc query range checks
      xfs: fix xfs_rtalloc_rec units

Dave Chinner (31):
      xfs: validate cached inodes are free when allocated
      xfs: validate allocated inode number
      xfs: make xfs_buf_incore out of line
      xfs: don't retry xfs_buf_find on XBF_TRYLOCK failure
      xfs: move generic_write_sync calls inwards
      iomap: iomap_dio_rw() handles all sync writes
      iomap: Use FUA for pure data O_DSYNC DIO writes
      xfs: simplify xfs_file_iomap_begin() logic
      xfs: clean up locking in xfs_file_iomap_begin
      xfs: log item flags are racy
      xfs: add tracing to high level transaction operations
      xfs: adder caller IP to xfs_defer* tracepoints
      xfs: don't assert fail with AIL lock held
      xfs: fix double ijoin in xfs_inactive_symlink_rmt()
      xfs: fix double ijoin in xfs_reflink_cancel_cow_range
      xfs: fix double ijoin in xfs_reflink_clear_inode_flag()
      xfs: add some more debug checks to buffer log item reuse
      xfs: get rid of the log item descriptor
      xfs: add mount delay debug option
      xfs: clear sb->s_fs_info on mount failure
      xfs: one-shot cached buffers
      xfs: factor out AG header initialisation from growfs core
      xfs: convert growfs AG header init to use buffer lists
      xfs: factor ag btree root block initialisation
      xfs: turn ag header initialisation into a table driven operation
      xfs: make imaxpct changes in growfs separate
      xfs: separate secondary sb update in growfs
      xfs: rework secondary superblock updates in growfs
      xfs: move growfs core to libxfs
      xfs: factor the ag length extension code into libxfs
      xfs: fix error handling in xfs_refcount_insert()

Dave Jiang (1):
      dax: change bdev_dax_supported() to support boolean returns

Eric Sandeen (8):
      xfs: trace ATTR flags in xattr tracepoints
      xfs: remove unused flags arg from xfs_dquot_verify
      xfs: check type in quota verifier during quotacheck
      xfs: pass full xfs_dqblk to repair during quotacheck
      xfs: add full xfs_dqblk verifier
      xfs: print specific dqblk that failed verifiers
      fs: copy BTRFS_IOC_[SG]ET_FSLABEL to vfs
      xfs: implement online get/set fs label

Omar Sandoval (2):
      iomap: provide more useful errors for invalid swap files
      iomap: don't allow holes in swapfiles

Souptick Joarder (1):
      fs: xfs: Change return type to vm_fault_t

 Documentation/ioctl/ioctl-number.txt |    3 +-
 block/bio.c                          |   96 +--
 drivers/dax/super.c                  |   40 +-
 fs/buffer.c                          |  114 ----
 fs/ext2/super.c                      |    3 +-
 fs/ext4/inline.c                     |    4 +-
 fs/ext4/super.c                      |    3 +-
 fs/gfs2/bmap.c                       |   11 +-
 fs/inode.c                           |    1 +
 fs/iomap.c                           |  408 ++++++++++++-
 fs/xfs/Kconfig                       |   18 +
 fs/xfs/Makefile                      |    9 +
 fs/xfs/libxfs/xfs_ag.c               |  464 +++++++++++++++
 fs/xfs/libxfs/xfs_ag.h               |   30 +
 fs/xfs/libxfs/xfs_alloc.c            |  129 +++-
 fs/xfs/libxfs/xfs_alloc.h            |   23 +-
 fs/xfs/libxfs/xfs_alloc_btree.c      |    9 +
 fs/xfs/libxfs/xfs_alloc_btree.h      |    2 +
 fs/xfs/libxfs/xfs_attr.c             |    4 +-
 fs/xfs/libxfs/xfs_attr_remote.c      |    2 +-
 fs/xfs/libxfs/xfs_bmap.c             |   92 +--
 fs/xfs/libxfs/xfs_bmap.h             |   30 +-
 fs/xfs/libxfs/xfs_bmap_btree.c       |    9 +
 fs/xfs/libxfs/xfs_bmap_btree.h       |    3 +
 fs/xfs/libxfs/xfs_btree.c            |   25 +-
 fs/xfs/libxfs/xfs_btree.h            |    3 +-
 fs/xfs/libxfs/xfs_defer.c            |   24 +-
 fs/xfs/libxfs/xfs_defer.h            |    1 +
 fs/xfs/libxfs/xfs_dquot_buf.c        |   94 +--
 fs/xfs/libxfs/xfs_errortag.h         |    4 +-
 fs/xfs/libxfs/xfs_format.h           |    7 +-
 fs/xfs/libxfs/xfs_fs.h               |    9 +-
 fs/xfs/libxfs/xfs_ialloc.c           |    2 +-
 fs/xfs/libxfs/xfs_ialloc.h           |    3 +
 fs/xfs/libxfs/xfs_ialloc_btree.c     |   11 +-
 fs/xfs/libxfs/xfs_ialloc_btree.h     |    2 +
 fs/xfs/libxfs/xfs_quota_defs.h       |    9 +-
 fs/xfs/libxfs/xfs_refcount.c         |   24 +-
 fs/xfs/libxfs/xfs_refcount.h         |    7 +
 fs/xfs/libxfs/xfs_rmap.c             |   83 +++
 fs/xfs/libxfs/xfs_rmap.h             |    4 +
 fs/xfs/libxfs/xfs_rtbitmap.c         |   26 +-
 fs/xfs/libxfs/xfs_sb.c               |  147 +++++
 fs/xfs/libxfs/xfs_sb.h               |   16 +
 fs/xfs/libxfs/xfs_shared.h           |   16 +-
 fs/xfs/libxfs/xfs_types.h            |    2 +-
 fs/xfs/scrub/agheader.c              |   85 +--
 fs/xfs/scrub/agheader_repair.c       |   70 +++
 fs/xfs/scrub/alloc.c                 |    4 +-
 fs/xfs/scrub/attr.c                  |    3 +-
 fs/xfs/scrub/bmap.c                  |    8 +-
 fs/xfs/scrub/btree.c                 |   42 +-
 fs/xfs/scrub/common.c                |  131 +++-
 fs/xfs/scrub/common.h                |   32 +-
 fs/xfs/scrub/dir.c                   |   35 +-
 fs/xfs/scrub/ialloc.c                |    7 +-
 fs/xfs/scrub/inode.c                 |   10 +-
 fs/xfs/scrub/parent.c                |   19 +-
 fs/xfs/scrub/quota.c                 |  181 +++---
 fs/xfs/scrub/refcount.c              |   10 +-
 fs/xfs/scrub/repair.c                | 1089 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h                |  132 +++++
 fs/xfs/scrub/rmap.c                  |    6 +-
 fs/xfs/scrub/rtbitmap.c              |   60 +-
 fs/xfs/scrub/scrub.c                 |  142 ++++-
 fs/xfs/scrub/scrub.h                 |    5 +
 fs/xfs/scrub/trace.h                 |  258 ++++++++
 fs/xfs/xfs_aops.c                    |   21 +-
 fs/xfs/xfs_bmap_item.c               |    4 +-
 fs/xfs/xfs_bmap_util.c               |   10 +-
 fs/xfs/xfs_buf.c                     |  100 +++-
 fs/xfs/xfs_buf.h                     |   29 +-
 fs/xfs/xfs_buf_item.c                |   10 +-
 fs/xfs/xfs_dquot.c                   |  780 ++++++++++++++----------
 fs/xfs/xfs_dquot.h                   |   22 +-
 fs/xfs/xfs_dquot_item.c              |    7 +-
 fs/xfs/xfs_error.c                   |    3 +
 fs/xfs/xfs_extfree_item.c            |    6 +-
 fs/xfs/xfs_file.c                    |   55 +-
 fs/xfs/xfs_fsmap.c                   |   14 +-
 fs/xfs/xfs_fsops.c                   |  587 ++++--------------
 fs/xfs/xfs_globals.c                 |    1 +
 fs/xfs/xfs_icache.c                  |   94 ++-
 fs/xfs/xfs_icache.h                  |    3 +
 fs/xfs/xfs_icreate_item.c            |    4 +-
 fs/xfs/xfs_inode.c                   |   47 +-
 fs/xfs/xfs_inode.h                   |   14 +-
 fs/xfs/xfs_inode_item.c              |    8 +-
 fs/xfs/xfs_ioctl.c                   |   89 ++-
 fs/xfs/xfs_iomap.c                   |  186 +++---
 fs/xfs/xfs_iops.c                    |   32 +-
 fs/xfs/xfs_log.c                     |   12 +-
 fs/xfs/xfs_log_cil.c                 |   22 +-
 fs/xfs/xfs_log_recover.c             |    4 +-
 fs/xfs/xfs_mount.c                   |    4 +-
 fs/xfs/xfs_qm.c                      |  254 ++++----
 fs/xfs/xfs_qm.h                      |    6 +-
 fs/xfs/xfs_qm_bhv.c                  |    2 +-
 fs/xfs/xfs_qm_syscalls.c             |   97 ++-
 fs/xfs/xfs_quota.h                   |   22 +-
 fs/xfs/xfs_quotaops.c                |    8 +-
 fs/xfs/xfs_refcount_item.c           |    4 +-
 fs/xfs/xfs_reflink.c                 |   18 +-
 fs/xfs/xfs_rmap_item.c               |    4 +-
 fs/xfs/xfs_rtalloc.h                 |    9 +-
 fs/xfs/xfs_super.c                   |   59 +-
 fs/xfs/xfs_symlink.c                 |   10 +-
 fs/xfs/xfs_sysctl.h                  |    1 +
 fs/xfs/xfs_sysfs.c                   |   31 +
 fs/xfs/xfs_trace.h                   |   72 ++-
 fs/xfs/xfs_trans.c                   |   89 ++-
 fs/xfs/xfs_trans.h                   |   29 +-
 fs/xfs/xfs_trans_ail.c               |   50 +-
 fs/xfs/xfs_trans_bmap.c              |    4 +-
 fs/xfs/xfs_trans_buf.c               |   24 +-
 fs/xfs/xfs_trans_dquot.c             |    4 +-
 fs/xfs/xfs_trans_extfree.c           |   84 ++-
 fs/xfs/xfs_trans_inode.c             |    3 +-
 fs/xfs/xfs_trans_priv.h              |   11 +-
 fs/xfs/xfs_trans_refcount.c          |    4 +-
 fs/xfs/xfs_trans_rmap.c              |    4 +-
 include/linux/bio.h                  |    9 +
 include/linux/buffer_head.h          |    2 -
 include/linux/dax.h                  |   11 +-
 include/linux/iomap.h                |   27 +-
 include/uapi/linux/fs.h              |    8 +-
 mm/internal.h                        |    2 +-
 mm/readahead.c                       |   39 +-
 128 files changed, 5544 insertions(+), 1980 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_ag.c
 create mode 100644 fs/xfs/libxfs/xfs_ag.h
 create mode 100644 fs/xfs/scrub/agheader_repair.c
 create mode 100644 fs/xfs/scrub/repair.c
 create mode 100644 fs/xfs/scrub/repair.h
