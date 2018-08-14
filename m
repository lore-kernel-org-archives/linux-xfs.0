Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbeHNSAj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Aug 2018 14:00:39 -0400
Date: Tue, 14 Aug 2018 08:13:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: 4.19 merge, part 2
Message-ID: <20180814151304.GG11750@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, agruenba@redhat.com, Christoph Hellwig <hch@infradead.org>

Hi Linus,

This is the second part of the XFS changes for 4.19.  The biggest
changes are the removal of buffer heads frm XFS, a massive reworking of
the deferred transaction operations handling code, the removal of the
long defunct barrier/nobarrier mount options, and the addition of a
few more online repair functions.

I started by merging the iomap-4.19-merge branch atop v4.18-rc4 and then
merging in all the development branches as they came ready.  I hope that
won't mess up the pull process (it seemed to work fine with the current
master) but please let us know if there are any problems.

(FWIW I also sustained an eye injury last week so it may take a day to
respond.)

--D

The following changes since commit c2efdfc100af42cc04525ef0db74b176da59e1a4:

  Merge branch 'iomap-4.19-merge' into xfs-4.19-merge (2018-07-11 22:24:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.19-merge-6

for you to fetch changes up to 01239d77b9dd978863d1a75f0d095ab942a1fe66:

  xfs: fix a null pointer dereference in xfs_bmap_extents_to_btree (2018-08-12 08:37:31 -0700)

----------------------------------------------------------------
Changes for 4.19:
- Use extent maps to track pagecache page status instead of bufferhead
  state.
- Refactor pagecache read and write paths to use the new iomap library
  functions, which enable us to drop the old bufferhead code for
  pagesize == blocksize filesystems.
- Set up parallel per-block-per-page metadata to track subpage
  information that was tracked by buffer heads, which enables us to drop
  the old bufferhead code for pagesize > blocksize filesystems.
- Tie a deferred ops control structure to a transaction so that we can
  take advantage of an upper-level dfops without having to plumb pointer
  passing through the code.
- Refactor the deferred ops code to track deferred ops as part of the
  transaction structure (instead of as a separate data structure) so
  that we can simplify the scoping rules around defer_ops.
- Refactor twisty delwri buffer submission code to avoid deadlocks.
- Shorten and fix indenting problems in the scrub code.
- Detect obviously bad summary counts at mount and fix them.
- Directly associate deferred ops control structure with a transaction
  so that callers no longer have to manage it themselves.
- Remove a couple of IRIX-era inode macros.
- Remove the long-deprecated 'barrier' and 'nobarrier' mount options.
- Clean up the inode fork structure a bit.
- Check for bad fs summary counter values in the superblock.
- Reduce COW fork lookups during writeback.
- Refactor the deferred ops control structures into the transaction
  structure, thereby eliminating the need for transaction users to
  handle the deferred ops as a separate data structure.
- Add the ability to repair AG headers online.
- Fix a crash due to insufficient return value checking.
- Various fixes and cleanups.

----------------------------------------------------------------
Andreas Gruenbacher (1):
      iomap: Switch to offset_in_page for clarity

Bill O'Donnell (1):
      libxfs: add more bounds checking to sb sanity checks

Brian Foster (84):
      xfs: cow unwritten conversion uses uninitialized dfops
      xfs: rename xfs_trans ->t_agfl_dfops to ->t_dfops
      xfs: remove dfops parameter from ifree call stack
      xfs: remove dfops param from high level dirname calls
      xfs: use ->t_dfops for recovery of [b|c]ui log items
      xfs: use ->t_dfops for attr set/remove operations
      xfs: remove dfops param in attr fork add path
      xfs: use ->t_dfops in extent split tx and remove param
      xfs: replace xfs_da_args->dfops accesses with ->t_dfops and remove
      xfs: use ->t_dfops in dqalloc transaction
      xfs: use ->t_dfops for all xfs_bmapi_write() callers
      xfs: remove xfs_bmapi_write() dfops param
      xfs: use ->t_dfops for all xfs_bunmapi() callers
      xfs: remove xfs_bunmapi() dfops param
      xfs: remove xfs_bmapi_remap() dfops param
      xfs: remove struct xfs_bmalloca dfops field
      xfs: use ->t_dfops for collapse/insert range operations
      xfs: remove dfops param from internal bmap extent helpers
      xfs: remove xfs_btree_cur bmbt dfops field
      xfs: remove unused btree cursor bc_private.a.dfops field
      xfs: use ->t_dfops for rmap extent swap operations
      xfs: use ->t_dfops in cancel cow blocks operation
      xfs: use ->t_dfops in reflink cow recover path
      xfs: refactor dfops init to attach to transaction
      xfs: allow null firstblock in xfs_bmapi_write() when tp is null
      xfs: add firstblock field to xfs_trans
      xfs: use ->t_firstblock in dir ops
      xfs: remove firstblock param from xfs dir ops
      xfs: use ->t_firstblock in attrfork add
      xfs: use ->t_firstblock in xattr ops
      xfs: use ->t_firstblock for all xfs_bmapi_write() callers
      xfs: use ->t_firstblock for all xfs_bunmapi() callers
      xfs: use ->t_firstblock in xfs_bmapi_remap()
      xfs: use ->t_firstblock in insert/collapse range
      xfs: remove xfs_bmapi_write() firstblock param
      xfs: remove xfs_bunmapi() firstblock param
      xfs: remove bmap insert/collapse firstblock param
      xfs: use ->t_firstblock in bmap extent split
      xfs: remove xfs_bmalloca firstblock field
      xfs: remove bmap extent add helper firstblock params
      xfs: remove bmap format helpers firstblock params
      xfs: remove xfs_btree_cur private firstblock field
      xfs: remove xfs_alloc_arg firstblock field
      xfs: use ->t_firstblock in dq alloc
      xfs: replace no-op firstblock init with ->t_firstblock
      xfs: use ->t_firstblock in reflink cow block cancel
      xfs: use ->t_firstblock in extent swap
      xfs: use ->t_firstblock in inode inactivate
      xfs: remove xfs_defer_init() firstblock param
      xfs: refactor buffer submission into a common helper
      xfs: use sync buffer I/O for sync delwri queue submission
      xfs: combine [a]sync buffer submission apis
      xfs: kill __xfs_buf_submit_common()
      xfs: pull up dfops from xfs_itruncate_extents()
      xfs: use ->t_dfops in log recovery intent processing
      xfs: fix transaction leak on remote attr set/remove failure
      xfs: make deferred processing safe for embedded dfops
      xfs: remove unused deferred ops committed field
      xfs: reset dfops to initial state after finish
      xfs: pack holes in xfs_defer_ops and xfs_trans
      xfs: support embedded dfops in transaction
      xfs: use internal dfops in cow blocks cancel
      xfs: use internal dfops in attr code
      xfs: use internal dfops during [b|c]ui recovery
      xfs: remove all boilerplate defer init/finish code
      xfs: remove unnecessary dfops init calls in xattr code
      xfs: drop unnecessary xfs_defer_finish() dfops parameter
      xfs: bypass final dfops roll in trans commit path
      xfs: refactor internal dfops initialization
      xfs: use transaction for intent recovery instead of raw dfops
      xfs: remove unused __xfs_defer_cancel() internal helper
      xfs: pass transaction to dfops reset/move helpers
      xfs: replace dop_low with transaction flag
      xfs: add missing defer ijoins for held inodes
      xfs: automatic dfops buffer relogging
      xfs: automatic dfops inode relogging
      xfs: drop dop param from xfs_defer_op_type ->finish_item() callback
      xfs: clean out superfluous dfops dop params/vars
      xfs: cancel dfops on xfs_defer_finish() error
      xfs: replace xfs_defer_ops ->dop_pending with on-stack list
      xfs: pass transaction to xfs_defer_add()
      xfs: always defer agfl block frees
      xfs: fold dfops into the transaction
      xfs: remove dead error handling code in xfs_dquot_disk_alloc()

Carlos Maiolino (2):
      xfs: Initialize variables in xfs_alloc_get_rec before using them
      libxfs: Fix a couple of sparse complaintis

Christoph Hellwig (28):
      xfs: use iomap for blocksize == PAGE_SIZE readpage and readpages
      xfs: simplify xfs_aops_discard_page
      xfs: move locking into xfs_bmap_punch_delalloc_range
      xfs: do not set the page uptodate in xfs_writepage_map
      xfs: don't clear imap_valid for a non-uptodate buffers
      xfs: don't use XFS_BMAPI_IGSTATE in xfs_map_blocks
      xfs: remove xfs_reflink_trim_irec_to_next_cow
      xfs: remove xfs_map_cow
      xfs: rename the offset variable in xfs_writepage_map
      xfs: remove the now unused XFS_BMAPI_IGSTATE flag
      xfs: remove xfs_reflink_find_cow_mapping
      xfs: simplify xfs_map_blocks by using xfs_iext_lookup_extent directly
      xfs: remove the imap_valid flag
      xfs: don't look at buffer heads in xfs_add_to_ioend
      xfs: move all writeback buffer_head manipulation into xfs_map_at_offset
      xfs: remove xfs_start_page_writeback
      xfs: refactor the tail of xfs_writepage_map
      xfs: allow writeback on pages without buffer heads
      iomap: add support for sub-pagesize buffered I/O without buffer heads
      xfs: add support for sub-pagesize writeback without buffer_heads
      xfs: update my copyrights for the writeback and iomap code
      xfs: remove if_real_bytes
      xfs: simplify xfs_idata_realloc
      xfs: remove the xfs_ifork_t typedef
      xfs: introduce a new xfs_inode_has_cow_data helper
      xfs: maintain a sequence count for inode fork manipulations
      xfs: avoid COW fork extent lookups in writeback if the fork didn't change
      xfs: use WRITE_ONCE to update if_seq

Darrick J. Wong (28):
      xfs: don't assume a left rmap when allocating a new rmap
      xfs: check leaf attribute block freemap in verifier
      xfs: return from _defer_finish with a clean transaction
      xfs: trivial xfs_btree_del_cursor cleanups
      xfs: clean up xfs_btree_del_cursor callers
      xfs: shorten xfs_scrub_ prefix
      xfs: shorten xfs_repair_ prefix to xrep_
      xfs: shorten struct xfs_scrub_context to struct xfs_scrub
      xfs: fix indentation and other whitespace problems in scrub/repair
      xfs: detect and fix bad summary counts at mount
      xfs: refactor unmount record write
      xfs: force summary counter recalc at next mount
      xfs: kill IHOLD
      xfs: clean up IRELE/iput callsites
      xfs: pass transaction lock while setting up agresv on cyclic metadata
      xfs: move the repair extent list into its own file
      xfs: refactor the xrep_extent_list into xfs_bitmap
      xfs: refactor superblock verifiers
      xfs: verify icount in superblock write
      xfs: check for unknown v5 feature bits in superblock write verifier
      xfs: move extent busy tree initialization to xfs_initialize_perag
      xfs: refactor log recovery check
      xfs: use a local variable for magic number in xfs_da3_node_lookup_int
      xfs: check da node magic in _node_lookup_int
      xfs: only validate summary counts on primary superblock
      xfs: repair the AGF
      xfs: repair the AGFL
      xfs: repair the AGI

Dave Chinner (1):
      xfs: make xfs_writepage_map extent map centric

Dave Jiang (1):
      xfs: Close race between direct IO and xfs_break_layouts()

Eric Sandeen (3):
      xfs: remove unused iolock arg from xfs_break_dax_layouts
      xfs: remove deprecated barrier/nobarrier mount
      xfs: remove b_last_holder & associated macros

Gustavo A. R. Silva (3):
      xfs_attr_leaf: use swap macro in xfs_attr3_leaf_rebalance
      xfs_bmap_util: use swap macro
      xfs: use swap macro in xfs_dir2_leafn_rebalance

Huang Chong (1):
      xfs: fix a comment in xfs_log_reserve

Shan Hai (1):
      xfs: fix a null pointer dereference in xfs_bmap_extents_to_btree

Thomas Bianchi (1):
      xfs: substitute spaces with tabs

 Documentation/filesystems/xfs.txt  |    4 +-
 fs/iomap.c                         |  292 ++++++++++-
 fs/xfs/Makefile                    |    1 +
 fs/xfs/libxfs/xfs_ag_resv.c        |   13 +-
 fs/xfs/libxfs/xfs_ag_resv.h        |    4 +-
 fs/xfs/libxfs/xfs_alloc.c          |   46 +-
 fs/xfs/libxfs/xfs_alloc.h          |    1 -
 fs/xfs/libxfs/xfs_attr.c           |  120 ++---
 fs/xfs/libxfs/xfs_attr_leaf.c      |   70 +--
 fs/xfs/libxfs/xfs_attr_remote.c    |   26 +-
 fs/xfs/libxfs/xfs_bmap.c           |  444 ++++++----------
 fs/xfs/libxfs/xfs_bmap.h           |   48 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |   22 +-
 fs/xfs/libxfs/xfs_btree.h          |    4 -
 fs/xfs/libxfs/xfs_da_btree.c       |   37 +-
 fs/xfs/libxfs/xfs_da_btree.h       |    3 -
 fs/xfs/libxfs/xfs_defer.c          |  323 ++++++------
 fs/xfs/libxfs/xfs_defer.h          |   41 +-
 fs/xfs/libxfs/xfs_dir2.c           |   74 ++-
 fs/xfs/libxfs/xfs_dir2.h           |   10 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |   17 +-
 fs/xfs/libxfs/xfs_errortag.h       |    4 +-
 fs/xfs/libxfs/xfs_ialloc.c         |   33 +-
 fs/xfs/libxfs/xfs_ialloc.h         |    1 -
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   12 +-
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    4 +-
 fs/xfs/libxfs/xfs_iext_tree.c      |   20 +
 fs/xfs/libxfs/xfs_inode_fork.c     |   74 +--
 fs/xfs/libxfs/xfs_inode_fork.h     |    6 +-
 fs/xfs/libxfs/xfs_log_format.h     |   13 +
 fs/xfs/libxfs/xfs_refcount.c       |  107 ++--
 fs/xfs/libxfs/xfs_refcount.h       |   25 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   13 +-
 fs/xfs/libxfs/xfs_refcount_btree.h |    7 +-
 fs/xfs/libxfs/xfs_rmap.c           |   99 ++--
 fs/xfs/libxfs/xfs_rmap.h           |   22 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |    5 +-
 fs/xfs/libxfs/xfs_rmap_btree.h     |    2 +-
 fs/xfs/libxfs/xfs_sb.c             |  278 ++++++----
 fs/xfs/libxfs/xfs_shared.h         |   12 +
 fs/xfs/libxfs/xfs_types.c          |   34 ++
 fs/xfs/libxfs/xfs_types.h          |    1 +
 fs/xfs/scrub/agheader.c            |  518 +++++++++----------
 fs/xfs/scrub/agheader_repair.c     |  889 ++++++++++++++++++++++++++++++-
 fs/xfs/scrub/alloc.c               |  116 ++---
 fs/xfs/scrub/attr.c                |  130 ++---
 fs/xfs/scrub/bitmap.c              |  303 +++++++++++
 fs/xfs/scrub/bitmap.h              |   36 ++
 fs/xfs/scrub/bmap.c                |  331 ++++++------
 fs/xfs/scrub/btree.c               |  334 ++++++------
 fs/xfs/scrub/btree.h               |   45 +-
 fs/xfs/scrub/common.c              |  394 +++++++-------
 fs/xfs/scrub/common.h              |  115 ++--
 fs/xfs/scrub/dabtree.c             |  170 +++---
 fs/xfs/scrub/dabtree.h             |   33 +-
 fs/xfs/scrub/dir.c                 |  264 +++++-----
 fs/xfs/scrub/ialloc.c              |  214 ++++----
 fs/xfs/scrub/inode.c               |  282 +++++-----
 fs/xfs/scrub/parent.c              |  132 ++---
 fs/xfs/scrub/quota.c               |  140 ++---
 fs/xfs/scrub/refcount.c            |  194 +++----
 fs/xfs/scrub/repair.c              |  519 ++++++-------------
 fs/xfs/scrub/repair.h              |   95 ++--
 fs/xfs/scrub/rmap.c                |  172 +++---
 fs/xfs/scrub/rtbitmap.c            |   78 +--
 fs/xfs/scrub/scrub.c               |  210 ++++----
 fs/xfs/scrub/scrub.h               |  134 +++--
 fs/xfs/scrub/symlink.c             |   28 +-
 fs/xfs/scrub/trace.c               |    6 +-
 fs/xfs/scrub/trace.h               |  141 +++--
 fs/xfs/xfs.h                       |    1 -
 fs/xfs/xfs_aops.c                  | 1007 ++++++++++--------------------------
 fs/xfs/xfs_aops.h                  |    4 +-
 fs/xfs/xfs_attr_inactive.c         |    1 +
 fs/xfs/xfs_attr_list.c             |    2 +-
 fs/xfs/xfs_bmap_item.c             |   25 +-
 fs/xfs/xfs_bmap_item.h             |    3 +-
 fs/xfs/xfs_bmap_util.c             |  118 ++---
 fs/xfs/xfs_buf.c                   |  212 +++-----
 fs/xfs/xfs_buf.h                   |   15 +-
 fs/xfs/xfs_discard.c               |    2 +-
 fs/xfs/xfs_dquot.c                 |   49 +-
 fs/xfs/xfs_error.c                 |    3 +
 fs/xfs/xfs_export.c                |    2 +-
 fs/xfs/xfs_file.c                  |   12 +-
 fs/xfs/xfs_filestream.c            |    8 +-
 fs/xfs/xfs_fsmap.c                 |    4 +-
 fs/xfs/xfs_fsops.c                 |    2 +-
 fs/xfs/xfs_icache.c                |   16 +-
 fs/xfs/xfs_inode.c                 |  177 ++-----
 fs/xfs/xfs_inode.h                 |   32 +-
 fs/xfs/xfs_inode_item.c            |    4 -
 fs/xfs/xfs_iomap.c                 |   54 +-
 fs/xfs/xfs_iomap.h                 |    2 +-
 fs/xfs/xfs_iops.c                  |    5 +-
 fs/xfs/xfs_itable.c                |    8 +-
 fs/xfs/xfs_log.c                   |  156 +++---
 fs/xfs/xfs_log.h                   |    1 +
 fs/xfs/xfs_log_recover.c           |   68 +--
 fs/xfs/xfs_mount.c                 |  100 +++-
 fs/xfs/xfs_mount.h                 |    3 +-
 fs/xfs/xfs_qm.c                    |   22 +-
 fs/xfs/xfs_qm_syscalls.c           |    9 +-
 fs/xfs/xfs_quotaops.c              |    2 +-
 fs/xfs/xfs_refcount_item.c         |   28 +-
 fs/xfs/xfs_refcount_item.h         |    3 +-
 fs/xfs/xfs_reflink.c               |  173 ++-----
 fs/xfs/xfs_reflink.h               |    4 -
 fs/xfs/xfs_rtalloc.c               |   20 +-
 fs/xfs/xfs_super.c                 |   38 +-
 fs/xfs/xfs_symlink.c               |   51 +-
 fs/xfs/xfs_trace.h                 |   78 +--
 fs/xfs/xfs_trans.c                 |   26 +-
 fs/xfs/xfs_trans.h                 |   21 +-
 fs/xfs/xfs_trans_bmap.c            |    6 +-
 fs/xfs/xfs_trans_extfree.c         |    2 -
 fs/xfs/xfs_trans_refcount.c        |    6 +-
 fs/xfs/xfs_trans_rmap.c            |    1 -
 include/linux/iomap.h              |   31 ++
 119 files changed, 5676 insertions(+), 5336 deletions(-)
 create mode 100644 fs/xfs/scrub/bitmap.c
 create mode 100644 fs/xfs/scrub/bitmap.h
