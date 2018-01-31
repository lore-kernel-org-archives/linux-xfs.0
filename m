Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753741AbeAaSNM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jan 2018 13:13:12 -0500
Date: Wed, 31 Jan 2018 10:13:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: great scads of new stuff for 4.16
Message-ID: <20180131181311.GC4860@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

This merge cycle, we're again some substantive changes to XFS.  Metadata
verifiers have been restructured to provide more detail about which part
of a metadata structure failed checks, and we've enhanced the new online
fsck feature to cross-reference extent allocation information with the
other metadata structures.  With this pull, the metadata verification
part of online fsck is more or less finished, though the feature is
still experimental and still disabled by default.

We're also preparing to remove the EXPERIMENTAL tag from a couple of
features this cycle.  This week we're committing a bunch of space
accounting fixes for reflink and removing the EXPERIMENTAL tag from
reflink; I anticipate that we'll be ready to do the same for the reverse
mapping feature next week.   (I don't have any pending fixes for rmap;
however I wish to remove the tags one at a time.)

This giant pile of patches has been run through a full xfstests run over
the weekend and through a quick xfstests run against this morning's
master, with no major failures reported.  Let me know if there's any
merge problems -- git merge reported that one of our patches touched the
same function as the i_version series, but it resolved things cleanly.

--D

The following changes since commit b2cd1df66037e7c4697c7e40496bf7e4a5e16a2d:

  Linux 4.15-rc7 (2018-01-07 14:22:41 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.16-merge-4

for you to fetch changes up to 1e369b0e199bbfbab5218e1c1443d839700d8884:

  xfs: remove experimental tag for reflinks (2018-01-29 07:27:24 -0800)

----------------------------------------------------------------
New in this version:
 - Log faulting code locations when verifiers fail, for improved diagnosis
   of corrupt filesystems.
 - Implement metadata verifiers for local format inode fork data.
 - Online scrub now cross-references metadata records with other metadata.
 - Refactor the fs geometry ioctl generation functions.
 - Harden various metadata verifiers.
 - Fix various accounting problems.
 - Fix uncancelled transactions leaking when xattr functions fail.
 - Prevent the copy-on-write speculative preallocation garbage collector
   from racing with writeback.
 - Emit log reservation type information as trace data so that we can
   compare against xfsprogs.
 - Fix some erroneous asserts in the online scrub code.
 - Clean up the transaction reservation calculations.
 - Fix various minor bugs in online scrub.
 - Log complaints about mixed dio/buffered writes once per day and less
   noisily than before.
 - Refactor buffer log item lists to use list_head.
 - Break PNFS leases before reflinking blocks.
 - Reduce lock contention on reflink source files.
 - Fix some quota accounting problems with reflink.
 - Fix a serious corruption problem in the direct cow write code where we
   fed bad iomaps to the vfs iomap consumers.
 - Various other refactorings.
 - Remove EXPERIMENTAL tag from reflink!

----------------------------------------------------------------
Amir Goldstein (1):
      xfs: preserve i_rdev when recycling a reclaimable inode

Brian Foster (9):
      xfs: print transaction log reservation on overrun
      xfs: include inobt buffers in ifree tx log reservation
      xfs: fix up agi unlinked list reservations
      xfs: truncate transaction does not modify the inobt
      xfs: include an allocfree res for inobt modifications
      xfs: refactor inode chunk alloc/free tx reservation
      xfs: eliminate duplicate icreate tx reservation functions
      xfs: account finobt blocks properly in perag reservation
      xfs: cancel tx on xfs_defer_finish() error during xattr set/remove

Carlos Maiolino (3):
      Get rid of xfs_buf_log_item_t typedef
      Split buffer's b_fspriv field
      Use list_head infra-structure for buffer's log items list

Christoph Hellwig (1):
      xfs: remove experimental tag for reflinks

Colin Ian King (1):
      xfs: fix check on struct_version for versions 4 or greater

Darrick J. Wong (73):
      xfs: scrub inode nsec fields
      iomap: report collisions between directio and buffered writes to userspace
      xfs: ignore agfl read errors when not scrubbing agfl
      xfs: catch a few more error codes when scrubbing secondary sb
      xfs: xfs_scrub_bmap should use for_each_xfs_iext
      xfs: always grab transaction when scrubbing inode
      xfs: distinguish between corrupt inode and invalid inum in xfs_scrub_get_inode
      xfs: remove XFS_FSB_SANITY_CHECK
      xfs: refactor long-format btree header verification routines
      xfs: refactor short form btree pointer verification
      xfs: remove XFS_WANT_CORRUPTED_RETURN from dir3 data verifiers
      xfs: refactor xfs_verifier_error and xfs_buf_ioerror
      xfs: have buffer verifier functions report failing address
      xfs: refactor verifier callers to print address of failing check
      xfs: verify dinode header first
      xfs: move inode fork verifiers to xfs_dinode_verify
      xfs: create structure verifier function for shortform xattrs
      xfs: create structure verifier function for short form symlinks
      xfs: refactor short form directory structure verifier function
      xfs: provide a centralized method for verifying inline fork data
      xfs: fail out of xfs_attr3_leaf_lookup_int if it looks corrupt
      xfs: create a new buf_ops pointer to verify structure metadata
      xfs: separate dquot repair into a separate function
      xfs: standardize quota verification function outputs
      xfs: teach error reporting functions to take xfs_failaddr_t
      xfs: dump the first 128 bytes of any corrupt buffer
      xfs: trace log reservations at mount time
      xfs: hoist xfs_fs_geometry to libxfs
      xfs: refactor the geometry structure filling function
      xfs: harden directory integrity checks some more
      xfs: clarify units in the failed metadata io message
      xfs: change 0x%p -> %p in print messages
      xfs: use %pS printk format for direct instruction addresses
      xfs: use %px for data pointers when debugging
      xfs: add scrub cross-referencing helpers for the free space btrees
      xfs: add scrub cross-referencing helpers for the inode btrees
      xfs: add scrub cross-referencing helpers for the rmap btrees
      xfs: add scrub cross-referencing helpers for the refcount btrees
      xfs: set up scrub cross-referencing helpers
      xfs: fix a few erroneous process_error calls in the scrubbers
      xfs: check btree block ownership with bnobt/rmapbt when scrubbing btree
      xfs: introduce scrubber cross-referencing stubs
      xfs: cross-reference with the bnobt
      xfs: cross-reference bnobt records with cntbt
      xfs: cross-reference inode btrees during scrub
      xfs: cross-reference reverse-mapping btree
      xfs: cross-reference the rmapbt data with the refcountbt
      xfs: cross-reference refcount btree during scrub
      xfs: cross-reference the realtime bitmap
      xfs: cross-reference the block mappings when possible
      xfs: scrub in-core metadata
      xfs: don't iunlock unlocked inodes
      xfs: directory scrubber must walk through data block to offset
      xfs: attr leaf verifier needs to check for obviously bad count
      xfs: btree format ifork loader should check for zero numrecs
      xfs: check that br_blockcount doesn't overflow
      xfs: recheck reflink / dirty page status before freeing CoW reservations
      xfs: check sb_agblocks and sb_agblklog when validating superblock
      xfs: fix non-debug build compiler warnings
      xfs: call xfs_qm_dqattach before performing reflink operations
      xfs: always zero di_flags2 when we free the inode
      xfs: make tracepoint inode number format consistent
      xfs: refactor inode verifier corruption error printing
      xfs: refactor accounting updates out of xfs_bmap_btalloc
      xfs: skip CoW writes past EOF when writeback races with truncate
      xfs: don't clobber inobt/finobt cursors when xref with rmap
      xfs: reflink should break pnfs leases before sharing blocks
      xfs: allow xfs_lock_two_inodes to take different EXCL/SHARED modes
      xfs: only grab shared inode locks for source file during reflink
      xfs: treat CoW fork operations as delalloc for quota accounting
      iomap: warn on zero-length mappings
      xfs: check reflink allocation mappings
      xfs: don't screw up direct writes when freesp is fragmented

Eric Sandeen (3):
      xfs: explicitly initialize meta_scrub_ops array by type
      xfs: factor out scrub input checking
      xfs: move all scrub input checking to xfs_scrub_validate

Richard Wareing (1):
      xfs: Show realtime device stats on statfs calls if realtime flags set

Shan Hai (1):
      xfs: bmap code cleanup

Xiongwei Song (1):
      xfs: destroy mutex pag_ici_reclaim_lock before free

 fs/direct-io.c                     |  24 ++-
 fs/iomap.c                         |  14 +-
 fs/xfs/libxfs/xfs_alloc.c          | 124 +++++++----
 fs/xfs/libxfs/xfs_alloc.h          |  10 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |  47 +++--
 fs/xfs/libxfs/xfs_attr.c           |   4 -
 fs/xfs/libxfs/xfs_attr_leaf.c      | 148 ++++++++++---
 fs/xfs/libxfs/xfs_attr_leaf.h      |   1 +
 fs/xfs/libxfs/xfs_attr_remote.c    | 104 +++++----
 fs/xfs/libxfs/xfs_bmap.c           | 120 +++++++----
 fs/xfs/libxfs/xfs_bmap_btree.c     |  58 +++--
 fs/xfs/libxfs/xfs_btree.c          | 117 +++++++++--
 fs/xfs/libxfs/xfs_btree.h          |  16 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  70 +++++--
 fs/xfs/libxfs/xfs_da_format.h      |   6 +
 fs/xfs/libxfs/xfs_dir2.c           |   5 +-
 fs/xfs/libxfs/xfs_dir2.h           |   2 +
 fs/xfs/libxfs/xfs_dir2_block.c     |  39 ++--
 fs/xfs/libxfs/xfs_dir2_data.c      | 208 ++++++++++--------
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  89 +++++---
 fs/xfs/libxfs/xfs_dir2_node.c      |  89 ++++----
 fs/xfs/libxfs/xfs_dir2_priv.h      |  12 +-
 fs/xfs/libxfs/xfs_dir2_sf.c        |  30 ++-
 fs/xfs/libxfs/xfs_dquot_buf.c      | 174 +++++++--------
 fs/xfs/libxfs/xfs_fs.h             |   7 +
 fs/xfs/libxfs/xfs_ialloc.c         | 143 +++++++++++--
 fs/xfs/libxfs/xfs_ialloc.h         |   6 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  65 ++++--
 fs/xfs/libxfs/xfs_inode_buf.c      | 128 ++++++++---
 fs/xfs/libxfs/xfs_inode_buf.h      |   4 +-
 fs/xfs/libxfs/xfs_inode_fork.c     | 152 ++++----------
 fs/xfs/libxfs/xfs_inode_fork.h     |  14 ++
 fs/xfs/libxfs/xfs_log_rlimit.c     |   2 +-
 fs/xfs/libxfs/xfs_quota_defs.h     |   9 +-
 fs/xfs/libxfs/xfs_refcount.c       |  19 ++
 fs/xfs/libxfs/xfs_refcount.h       |   3 +
 fs/xfs/libxfs/xfs_refcount_btree.c |  40 ++--
 fs/xfs/libxfs/xfs_rmap.c           |  67 ++++++
 fs/xfs/libxfs/xfs_rmap.h           |   5 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |  40 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c       |  21 ++
 fs/xfs/libxfs/xfs_sb.c             | 113 +++++++++-
 fs/xfs/libxfs/xfs_sb.h             |   4 +
 fs/xfs/libxfs/xfs_shared.h         |   4 +
 fs/xfs/libxfs/xfs_symlink_remote.c |  75 +++++--
 fs/xfs/libxfs/xfs_trans_resv.c     | 199 ++++++++----------
 fs/xfs/scrub/agheader.c            | 340 ++++++++++++++++++++++++++++--
 fs/xfs/scrub/alloc.c               |  81 +++++++
 fs/xfs/scrub/bmap.c                | 219 ++++++++++++++++++-
 fs/xfs/scrub/btree.c               | 184 ++++++++++++++--
 fs/xfs/scrub/btree.h               |   9 +
 fs/xfs/scrub/common.c              | 255 +++++++++++++++++++---
 fs/xfs/scrub/common.h              |  23 +-
 fs/xfs/scrub/dabtree.c             |  22 ++
 fs/xfs/scrub/dir.c                 |  44 +++-
 fs/xfs/scrub/ialloc.c              | 194 ++++++++++++++++-
 fs/xfs/scrub/inode.c               | 178 ++++++++++++++--
 fs/xfs/scrub/parent.c              |   8 +-
 fs/xfs/scrub/quota.c               |   7 -
 fs/xfs/scrub/refcount.c            | 420 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/rmap.c                | 123 +++++++++++
 fs/xfs/scrub/rtbitmap.c            |  35 +++-
 fs/xfs/scrub/scrub.c               | 203 ++++++++++++------
 fs/xfs/scrub/scrub.h               |  37 ++++
 fs/xfs/scrub/trace.h               |  44 +++-
 fs/xfs/xfs_aops.c                  |  15 +-
 fs/xfs/xfs_bmap_util.c             |   4 +-
 fs/xfs/xfs_buf.c                   |  22 +-
 fs/xfs/xfs_buf.h                   |   8 +-
 fs/xfs/xfs_buf_item.c              | 156 +++++++-------
 fs/xfs/xfs_buf_item.h              |   7 +-
 fs/xfs/xfs_dir2_readdir.c          |   4 +-
 fs/xfs/xfs_dquot.c                 |  62 +-----
 fs/xfs/xfs_dquot_item.c            |   9 +-
 fs/xfs/xfs_error.c                 |  64 +++++-
 fs/xfs/xfs_error.h                 |  14 +-
 fs/xfs/xfs_fsops.c                 |  79 +------
 fs/xfs/xfs_fsops.h                 |   1 -
 fs/xfs/xfs_icache.c                |  70 +++++--
 fs/xfs/xfs_inode.c                 | 104 ++++++---
 fs/xfs/xfs_inode.h                 |   5 +-
 fs/xfs/xfs_inode_item.c            |  41 ++--
 fs/xfs/xfs_ioctl.c                 |   5 +-
 fs/xfs/xfs_ioctl32.c               |   3 +-
 fs/xfs/xfs_linux.h                 |  14 ++
 fs/xfs/xfs_log.c                   |  17 +-
 fs/xfs/xfs_log_recover.c           |  58 ++---
 fs/xfs/xfs_mount.c                 |   3 +
 fs/xfs/xfs_qm.c                    |  33 ++-
 fs/xfs/xfs_reflink.c               |  95 +++++++--
 fs/xfs/xfs_rtalloc.h               |   4 +
 fs/xfs/xfs_super.c                 |  14 +-
 fs/xfs/xfs_trace.h                 |  68 ++++--
 fs/xfs/xfs_trans.c                 |  22 ++
 fs/xfs/xfs_trans.h                 |   2 +-
 fs/xfs/xfs_trans_buf.c             |  98 ++++-----
 include/linux/fs.h                 |   6 +
 97 files changed, 4606 insertions(+), 1558 deletions(-)
