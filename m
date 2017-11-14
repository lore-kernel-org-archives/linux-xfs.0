Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752298AbdKNBuA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Nov 2017 20:50:00 -0500
Date: Mon, 13 Nov 2017 17:49:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: great scads of new stuff for 4.15
Message-ID: <20171114014954.GF25227@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

This merge cycle, we're making some substantive changes to XFS.  The
in-core extent mappings have been refactored to use proper iterators and
a btree to handle heavily fragmented files without needing high-order
memory allocations; some important log recovery bug fixes; and the first
part of the online fsck functionality.  (The online fsck feature is
disabled by default and more pieces of it will be coming in future
release cycles.)

This giant pile of patches has been run through a full xfstests run over
the weekend and through a quick xfstests run against this morning's
master, with no major failures reported.  Let me know if there's any
merge problems.

--D

The following changes since commit 15f859ae5c43c7f0a064ed92d33f7a5bc5de6de0:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma (2017-10-26 23:04:14 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.15-merge-1

for you to fetch changes up to 2d1d1da3d9cc387262193e83f0a96d753b040720:

  xfs: on failed mount, force-reclaim inodes after unmounting quota controls (2017-11-09 19:27:33 -0800)

----------------------------------------------------------------
New in this version:
- Refactor the incore extent map manipulations to use a cursor instead of
  directly modifying extent data.
- Refactor the incore extent map cursor to use an in-memory btree instead
  of a single high-order allocation.  This eliminates a major source of
  complaints about insufficient memory when opening a heavily fragmented
  file into a system whose memory is also heavily fragmented.
- Fix a longstanding bug where deleting a file with a complex extended
  attribute btree incorrectly handled memory pointers, which could lead
  to memory corruption.
- Improve metadata validation to eliminate crashing problems found while
  fuzzing xfs.
- Move the error injection tag definitions into libxfs to be shared with
  userspace components.
- Fix some log recovery bugs where we'd underflow log block position
  vector and incorrectly fail log recovery.
- Drain the buffer lru after log recovery to force recovered buffers back
  through the verifiers after mount.  On a v4 filesystem the log never
  attaches verifiers during log replay (v5 does), so we could end up with
  buffers marked verified but without having ever been verified.
- Fix various other bugs.
- Introduce the first part of a new online fsck tool.  The new fsck tool
  will be able to iterate every piece of metadata in the filesystem to
  look for obvious errors and corruptions.  In the next release cycle
  the checking will be extended to cross-reference with the other fs
  metadata, so this feature should only be used by the developers in the
  mean time.

----------------------------------------------------------------
Brian Foster (6):
      xfs: fail if xattr inactivation hits a hole
      xfs: buffer lru reference count error injection tag
      xfs: more robust recovery xlog buffer validation
      xfs: fix log block underflow during recovery cycle verification
      xfs: drain the buffer LRU on mount
      xfs: fix unused variable warning in xfs_buf_set_ref()

Christoph Hellwig (74):
      xfs: rewrite getbmap using the xfs_iext_* helpers
      xfs: simplify the xfs_getbmap interface
      xfs: fix incorrect extent state in xfs_bmap_add_extent_unwritten_real
      xfs: use xfs_iext_get_extent instead of open coding it
      xfs: don't set XFS_BTCUR_BPRV_WASDEL in xfs_bunmapi
      xfs: rename bno to end in __xfs_bunmapi
      xfs: use xfs_bmap_del_extent_delay for the data fork as well
      xfs: move some more code into xfs_bmap_del_extent_real
      xfs: use correct state defines in xfs_bmap_del_extent_{cow,delay}
      xfs: use the state defines in xfs_bmap_del_extent_real
      xfs: refactor xfs_del_extent_real
      xfs: refactor xfs_bmap_add_extent_hole_delay
      xfs: refactor xfs_bmap_add_extent_hole_real
      xfs: refactor xfs_bmap_add_extent_delay_real
      xfs: refactor delalloc accounting in xfs_bmap_add_extent_delay_real
      xfs: refactor xfs_bmap_add_extent_unwritten_real
      xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_update
      xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_lookup_eq
      xfs: replace xfs_bmbt_lookup_ge with xfs_bmbt_lookup_first
      xfs: remove all xfs_bmbt_set_* helpers except for xfs_bmbt_set_all
      xfs: remove xfs_bmbt_get_state
      xfs: add a xfs_bmap_fork_to_state helper
      xfs: make better use of the 'state' variable in xfs_bmap_del_extent_real
      xfs: remove post-bmap tracing in xfs_bmap_local_to_extents
      xfs: move pre/post-bmap tracing into xfs_iext_update_extent
      xfs: remove XFS_BMAP_TRACE_EXLIST
      xfs: remove the never fully implemented UUID fork format
      xfs: remove if_rdev
      xfs: inline xfs_shift_file_space into callers
      xfs: remove XFS_BMAP_MAX_SHIFT_EXTENTS
      xfs: split xfs_bmap_shift_extents
      xfs: remove xfs_bmse_shift_one
      xfs: update got in xfs_bmap_shift_update_extent
      xfs: don't rely on extent indices in xfs_bmap_collapse_extents
      xfs: don't rely on extent indices in xfs_bmap_insert_extents
      xfs: rewrite xfs_bmap_first_unused to make better use of xfs_iext_get_extent
      xfs: add asserts for the mmap lock in xfs_{insert,collapse}_file_space
      xfs: merge xfs_bmap_read_extents into xfs_iread_extents
      xfs: add a new xfs_iext_lookup_extent_before helper
      xfs: don't create overlapping extents in xfs_bmap_add_extent_delay_real
      xfs: remove a duplicate assignment in xfs_bmap_add_extent_delay_real
      xfs: treat idx as a cursor in xfs_bmap_add_extent_delay_real
      xfs: treat idx as a cursor in xfs_bmap_add_extent_hole_delay
      xfs: treat idx as a cursor in xfs_bmap_add_extent_hole_real
      xfs: treat idx as a cursor in xfs_bmap_add_extent_unwritten_real
      xfs: treat idx as a cursor in xfs_bmap_del_extent_*
      xfs: treat idx as a cursor in xfs_bmap_collapse_extents
      xfs: pass an on-disk extent to xfs_bmbt_validate_extent
      xfs: iterate over extents in xfs_iextents_copy
      xfs: iterate over extents in xfs_bmap_extents_to_btree
      xfs: introduce the xfs_iext_cursor abstraction
      xfs: iterate backwards in xfs_reflink_cancel_cow_blocks
      xfs: simplify xfs_reflink_convert_cow
      xfs: remove support for inlining data/extents into the inode fork
      xfs: allow unaligned extent records in xfs_bmbt_disk_set_all
      xfs: use a b+tree for the in-core extent list
      xfs: remove the nr_extents argument to xfs_iext_insert
      xfs: remove the nr_extents argument to xfs_iext_remove
      xfs: pass struct xfs_bmbt_irec to xfs_bmbt_validate_extent
      xfs: move xfs_bmbt_irec and xfs_exntst_t to xfs_types.h
      xfs: always define STATIC to static noinline
      xfs: trivial sparse fixes for the new scrub code
      xfs: mark xfs_errortag_ktype static
      xfs: remove unused debug counts for xfs_lock_inodes
      xfs: remove unreachable error injection code in xfs_qm_dqget
      xfs: mark xfs_btree_check_lblock and xfs_btree_check_ptr static
      xfs: mark xlog_recover_check_summary STATIC
      xfs: mark xlog_verify_dest_ptr STATIC
      xfs: fix number of records handling in xfs_iext_split_leaf
      xfs: add some comments to xfs_iext_insert/xfs_iext_insert_node
      xfs: remove a superflous assignment in xfs_iext_remove_node
      xfs: trivial indentation fixup for xfs_iext_remove_node
      xfs: add comments documenting the rebalance algorithm
      xfs: handle zero entries case in xfs_iext_rebalance_leaf

Colin Ian King (1):
      xfs: remove redundant assignment to variable bit

Darrick J. Wong (46):
      xfs: return a distinct error code value for IGET_INCORE cache misses
      xfs: create block pointer check functions
      xfs: refactor btree pointer checks
      xfs: refactor btree block header checking functions
      xfs: create inode pointer verifiers
      xfs: create an ioctl to scrub AG metadata
      xfs: dispatch metadata scrub subcommands
      xfs: probe the scrub ioctl
      xfs: create helpers to record and deal with scrub problems
      xfs: create helpers to scrub a metadata btree
      xfs: scrub the shape of a metadata btree
      xfs: scrub btree keys and records
      xfs: create helpers to scan an allocation group
      xfs: scrub the secondary superblocks
      xfs: scrub AGF and AGFL
      xfs: scrub the AGI
      xfs: scrub free space btrees
      xfs: scrub inode btrees
      xfs: scrub rmap btrees
      xfs: scrub refcount btrees
      xfs: scrub inodes
      xfs: scrub inode block mappings
      xfs: scrub directory/attribute btrees
      xfs: scrub directory metadata
      xfs: scrub directory freespace
      xfs: scrub extended attributes
      xfs: scrub symbolic links
      xfs: scrub directory parent pointers
      xfs: scrub realtime bitmap/summary
      xfs: scrub quota information
      xfs: validate sb_logsunit is a multiple of the fs blocksize
      xfs: refactor extended attribute list operation
      xfs: abort dir/attr btree operation if btree is obviously weird
      xfs: compare btree block keys to parent block's keys during scrub
      xfs: remove inode log format typedef
      xfs: move error injection tags into their own file
      xfs: scrub extended attribute leaf space
      xfs: scrub: avoid uninitialized return code
      xfs: refactor the directory data block bestfree checks
      xfs: pass inode number to xfs_scrub_ino_set_{preen,warning}
      xfs: fix uninitialized return values in scrub code
      xfs: fix btree scrub deref check
      xfs: only check da node header padding on v5 filesystems
      xfs: remove u_int* type usage
      xfs: check the uniqueness of the AGFL entries
      xfs: on failed mount, force-reclaim inodes after unmounting quota controls

Dave Chinner (1):
      xfs: convert remaining xfs_sb_version_... checks to bool

Eryu Guan (1):
      xfs: truncate pagecache before writeback in xfs_setattr_size()

Hou Tao (1):
      xfs: check kthread_should_stop() after the setting of task state

Tim Hansen (1):
      fs/xfs: Remove NULL check before kmem_cache_destroy

 fs/xfs/Kconfig                 |   17 +
 fs/xfs/Makefile                |   29 +
 fs/xfs/kmem.h                  |    3 +-
 fs/xfs/libxfs/xfs_ag_resv.c    |    1 +
 fs/xfs/libxfs/xfs_alloc.c      |   50 +
 fs/xfs/libxfs/xfs_alloc.h      |    4 +
 fs/xfs/libxfs/xfs_attr_leaf.c  |    6 +-
 fs/xfs/libxfs/xfs_bmap.c       | 2061 ++++++++++++++++------------------------
 fs/xfs/libxfs/xfs_bmap.h       |   66 +-
 fs/xfs/libxfs/xfs_bmap_btree.c |  250 +----
 fs/xfs/libxfs/xfs_bmap_btree.h |   22 +-
 fs/xfs/libxfs/xfs_btree.c      |  259 ++---
 fs/xfs/libxfs/xfs_btree.h      |   32 +-
 fs/xfs/libxfs/xfs_da_btree.c   |   22 +-
 fs/xfs/libxfs/xfs_dir2.c       |   24 +-
 fs/xfs/libxfs/xfs_dir2.h       |   17 +
 fs/xfs/libxfs/xfs_errortag.h   |  106 +++
 fs/xfs/libxfs/xfs_format.h     |   37 +-
 fs/xfs/libxfs/xfs_fs.h         |   77 ++
 fs/xfs/libxfs/xfs_ialloc.c     |   91 ++
 fs/xfs/libxfs/xfs_ialloc.h     |    7 +
 fs/xfs/libxfs/xfs_iext_tree.c  | 1043 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.c  |    1 +
 fs/xfs/libxfs/xfs_inode_fork.c | 1333 ++------------------------
 fs/xfs/libxfs/xfs_inode_fork.h |  138 ++-
 fs/xfs/libxfs/xfs_log_format.h |   24 +-
 fs/xfs/libxfs/xfs_refcount.c   |    1 +
 fs/xfs/libxfs/xfs_rmap.c       |    1 +
 fs/xfs/libxfs/xfs_rtbitmap.c   |   13 +-
 fs/xfs/libxfs/xfs_types.h      |   22 +
 fs/xfs/scrub/agheader.c        |  658 +++++++++++++
 fs/xfs/scrub/alloc.c           |  102 ++
 fs/xfs/scrub/attr.c            |  471 +++++++++
 fs/xfs/scrub/bmap.c            |  363 +++++++
 fs/xfs/scrub/btree.c           |  516 ++++++++++
 fs/xfs/scrub/btree.h           |   57 ++
 fs/xfs/scrub/common.c          |  574 +++++++++++
 fs/xfs/scrub/common.h          |  144 +++
 fs/xfs/scrub/dabtree.c         |  591 ++++++++++++
 fs/xfs/scrub/dabtree.h         |   59 ++
 fs/xfs/scrub/dir.c             |  816 ++++++++++++++++
 fs/xfs/scrub/ialloc.c          |  337 +++++++
 fs/xfs/scrub/inode.c           |  611 ++++++++++++
 fs/xfs/scrub/parent.c          |  317 ++++++
 fs/xfs/scrub/quota.c           |  304 ++++++
 fs/xfs/scrub/refcount.c        |   99 ++
 fs/xfs/scrub/rmap.c            |  138 +++
 fs/xfs/scrub/rtbitmap.c        |  108 +++
 fs/xfs/scrub/scrub.c           |  392 ++++++++
 fs/xfs/scrub/scrub.h           |  115 +++
 fs/xfs/scrub/symlink.c         |   92 ++
 fs/xfs/scrub/trace.c           |   59 ++
 fs/xfs/scrub/trace.h           |  499 ++++++++++
 fs/xfs/scrub/xfs_scrub.h       |   29 +
 fs/xfs/xfs.h                   |    1 -
 fs/xfs/xfs_attr.h              |    5 +-
 fs/xfs/xfs_attr_inactive.c     |   69 +-
 fs/xfs/xfs_attr_list.c         |  161 ++--
 fs/xfs/xfs_bmap_util.c         |  746 ++++++---------
 fs/xfs/xfs_bmap_util.h         |   10 +-
 fs/xfs/xfs_buf.c               |   16 +
 fs/xfs/xfs_buf.h               |    5 +-
 fs/xfs/xfs_dir2_readdir.c      |   10 +-
 fs/xfs/xfs_dquot.c             |   21 +-
 fs/xfs/xfs_error.c             |    6 +-
 fs/xfs/xfs_error.h             |   81 --
 fs/xfs/xfs_file.c              |    2 +-
 fs/xfs/xfs_icache.c            |    2 +-
 fs/xfs/xfs_inode.c             |   33 +-
 fs/xfs/xfs_inode.h             |    4 +-
 fs/xfs/xfs_inode_item.c        |   29 +-
 fs/xfs/xfs_inode_item.h        |    2 +-
 fs/xfs/xfs_ioctl.c             |  158 +--
 fs/xfs/xfs_ioctl.h             |    4 +-
 fs/xfs/xfs_ioctl32.c           |    1 +
 fs/xfs/xfs_iomap.c             |   15 +-
 fs/xfs/xfs_iops.c              |   52 +-
 fs/xfs/xfs_itable.c            |   13 +-
 fs/xfs/xfs_itable.h            |    2 -
 fs/xfs/xfs_linux.h             |   21 +-
 fs/xfs/xfs_log.c               |   33 +-
 fs/xfs/xfs_log_recover.c       |   62 +-
 fs/xfs/xfs_mount.c             |   15 +-
 fs/xfs/xfs_reflink.c           |  108 +--
 fs/xfs/xfs_rtalloc.h           |    2 +
 fs/xfs/xfs_trace.h             |   64 +-
 fs/xfs/xfs_trans_ail.c         |   22 +-
 87 files changed, 10972 insertions(+), 4011 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_errortag.h
 create mode 100644 fs/xfs/libxfs/xfs_iext_tree.c
 create mode 100644 fs/xfs/scrub/agheader.c
 create mode 100644 fs/xfs/scrub/alloc.c
 create mode 100644 fs/xfs/scrub/attr.c
 create mode 100644 fs/xfs/scrub/bmap.c
 create mode 100644 fs/xfs/scrub/btree.c
 create mode 100644 fs/xfs/scrub/btree.h
 create mode 100644 fs/xfs/scrub/common.c
 create mode 100644 fs/xfs/scrub/common.h
 create mode 100644 fs/xfs/scrub/dabtree.c
 create mode 100644 fs/xfs/scrub/dabtree.h
 create mode 100644 fs/xfs/scrub/dir.c
 create mode 100644 fs/xfs/scrub/ialloc.c
 create mode 100644 fs/xfs/scrub/inode.c
 create mode 100644 fs/xfs/scrub/parent.c
 create mode 100644 fs/xfs/scrub/quota.c
 create mode 100644 fs/xfs/scrub/refcount.c
 create mode 100644 fs/xfs/scrub/rmap.c
 create mode 100644 fs/xfs/scrub/rtbitmap.c
 create mode 100644 fs/xfs/scrub/scrub.c
 create mode 100644 fs/xfs/scrub/scrub.h
 create mode 100644 fs/xfs/scrub/symlink.c
 create mode 100644 fs/xfs/scrub/trace.c
 create mode 100644 fs/xfs/scrub/trace.h
 create mode 100644 fs/xfs/scrub/xfs_scrub.h
