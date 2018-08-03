Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60620 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbeHCVPL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Aug 2018 17:15:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w73JDmUp159144
        for <linux-xfs@vger.kernel.org>; Fri, 3 Aug 2018 19:17:32 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2kma04bjvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Aug 2018 19:17:32 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w73JHV39013532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 3 Aug 2018 19:17:31 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w73JHVpt000957
        for <linux-xfs@vger.kernel.org>; Fri, 3 Aug 2018 19:17:31 GMT
Date: Fri, 3 Aug 2018 12:17:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to a0e336ba3e3d
Message-ID: <20180803191730.GX30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.  We're a week away from the merge
window opening, so it's not too late for patches yet.

The new head of the for-next branch is commit:

a0e336ba3e3d xfs: fix a comment in xfs_log_reserve

New Commits:

Andreas Gruenbacher (6):
      [3d7b6b21f6c5] iomap: mark newly allocated buffer heads as new
      [ebf00be37de3] iomap: complete partial direct I/O writes synchronously
      [19e0c58f6552] iomap: generic inline data handling
      [e184fde6f3f5] iomap: add private pointer to struct iomap
      [ec181f6782d8] iomap: support direct I/O to inline data
      [806a1477b10a] iomap: add inline data support to iomap_readpage_actor

Bill O'Donnell (1):
      [8756a5af1819] libxfs: add more bounds checking to sb sanity checks

Brian Foster (83):
      [8a7493864983] xfs: cow unwritten conversion uses uninitialized dfops
      [6aa6718439ac] xfs: rename xfs_trans ->t_agfl_dfops to ->t_dfops
      [0e0417f3e546] xfs: remove dfops parameter from ifree call stack
      [c9cfdb381172] xfs: remove dfops param from high level dirname calls
      [813d08cb6de0] xfs: use ->t_dfops for recovery of [b|c]ui log items
      [40d03ac6aa2b] xfs: use ->t_dfops for attr set/remove operations
      [0bd6207f8364] xfs: remove dfops param in attr fork add path
      [d76e6ce8ed69] xfs: use ->t_dfops in extent split tx and remove param
      [32a9b7c65cfc] xfs: replace xfs_da_args->dfops accesses with ->t_dfops and remove
      [2ba13721257e] xfs: use ->t_dfops in dqalloc transaction
      [175d1a013eaf] xfs: use ->t_dfops for all xfs_bmapi_write() callers
      [6e702a5dcbe1] xfs: remove xfs_bmapi_write() dfops param
      [4bcfa613a058] xfs: use ->t_dfops for all xfs_bunmapi() callers
      [ccd9d9114878] xfs: remove xfs_bunmapi() dfops param
      [ff3edf255da7] xfs: remove xfs_bmapi_remap() dfops param
      [3e3673e3029c] xfs: remove struct xfs_bmalloca dfops field
      [f4a9cf97faf4] xfs: use ->t_dfops for collapse/insert range operations
      [81ba8f3e947c] xfs: remove dfops param from internal bmap extent helpers
      [42b394a92562] xfs: remove xfs_btree_cur bmbt dfops field
      [ed7ef8e55c6f] xfs: remove unused btree cursor bc_private.a.dfops field
      [7a7943c7e095] xfs: use ->t_dfops for rmap extent swap operations
      [27356a063a85] xfs: use ->t_dfops in cancel cow blocks operation
      [d5669ed58175] xfs: use ->t_dfops in reflink cow recover path
      [bcd2c9f33559] xfs: refactor dfops init to attach to transaction
      [3ae2d89174e4] xfs: allow null firstblock in xfs_bmapi_write() when tp is null
      [bba59c5e4b38] xfs: add firstblock field to xfs_trans
      [f16dea54b789] xfs: use ->t_firstblock in dir ops
      [381eee69f862] xfs: remove firstblock param from xfs dir ops
      [825d75cd8c1b] xfs: use ->t_firstblock in attrfork add
      [766139032f95] xfs: use ->t_firstblock in xattr ops
      [650919f13182] xfs: use ->t_firstblock for all xfs_bmapi_write() callers
      [372837978d90] xfs: use ->t_firstblock for all xfs_bunmapi() callers
      [580c4ff9484a] xfs: use ->t_firstblock in xfs_bmapi_remap()
      [d0a9d7957299] xfs: use ->t_firstblock in insert/collapse range
      [a7beabeae221] xfs: remove xfs_bmapi_write() firstblock param
      [2af528425342] xfs: remove xfs_bunmapi() firstblock param
      [333f950c89a1] xfs: remove bmap insert/collapse firstblock param
      [4b77a088d781] xfs: use ->t_firstblock in bmap extent split
      [94c07b4dba01] xfs: remove xfs_bmalloca firstblock field
      [92f9da30f57b] xfs: remove bmap extent add helper firstblock params
      [280253d213fb] xfs: remove bmap format helpers firstblock params
      [cf612de732cb] xfs: remove xfs_btree_cur private firstblock field
      [64396ff2c25b] xfs: remove xfs_alloc_arg firstblock field
      [058529c5f51c] xfs: use ->t_firstblock in dq alloc
      [fb91f4b5d618] xfs: replace no-op firstblock init with ->t_firstblock
      [381d59284872] xfs: use ->t_firstblock in reflink cow block cancel
      [f53753892187] xfs: use ->t_firstblock in extent swap
      [9c3bf5da80ef] xfs: use ->t_firstblock in inode inactivate
      [5fdd97944ee5] xfs: remove xfs_defer_init() firstblock param
      [eaebb515f1a4] xfs: refactor buffer submission into a common helper
      [e339dd8d8b04] xfs: use sync buffer I/O for sync delwri queue submission
      [6af88cda0076] xfs: combine [a]sync buffer submission apis
      [bb00b6f1e2b9] xfs: kill __xfs_buf_submit_common()
      [02dff7bf8168] xfs: pull up dfops from xfs_itruncate_extents()
      [a61acc3c78df] xfs: use ->t_dfops in log recovery intent processing
      [dcbd44f79986] xfs: fix transaction leak on remote attr set/remove failure
      [03f4e4b26cd5] xfs: make deferred processing safe for embedded dfops
      [83200bfac608] xfs: remove unused deferred ops committed field
      [509308b413c9] xfs: reset dfops to initial state after finish
      [44fd294681de] xfs: pack holes in xfs_defer_ops and xfs_trans
      [e021a2e5fc52] xfs: support embedded dfops in transaction
      [1e5ae1995a44] xfs: use internal dfops in cow blocks cancel
      [9c6bb0cf7ba3] xfs: use internal dfops in attr code
      [91ef75b65724] xfs: use internal dfops during [b|c]ui recovery
      [c8eac49ef798] xfs: remove all boilerplate defer init/finish code
      [d5cca7eb244d] xfs: remove unnecessary dfops init calls in xattr code
      [9e28a242be65] xfs: drop unnecessary xfs_defer_finish() dfops parameter
      [b277c37f43dd] xfs: bypass final dfops roll in trans commit path
      [98719051e75c] xfs: refactor internal dfops initialization
      [fbfa977d25dc] xfs: use transaction for intent recovery instead of raw dfops
      [7279aa13b8fb] xfs: remove unused __xfs_defer_cancel() internal helper
      [ce356d64772f] xfs: pass transaction to dfops reset/move helpers
      [1214f1cf663b] xfs: replace dop_low with transaction flag
      [488c919a5bec] xfs: add missing defer ijoins for held inodes
      [82ff27bc52a8] xfs: automatic dfops buffer relogging
      [a8198666fb75] xfs: automatic dfops inode relogging
      [7dbddbaccd18] xfs: drop dop param from xfs_defer_op_type ->finish_item() callback
      [60f31a609ed3] xfs: clean out superfluous dfops dop params/vars
      [9b1f4e9831df] xfs: cancel dfops on xfs_defer_finish() error
      [1ae093cbea3d] xfs: replace xfs_defer_ops ->dop_pending with on-stack list
      [0f37d1780c3d] xfs: pass transaction to xfs_defer_add()
      [c03edc9e49b6] xfs: always defer agfl block frees
      [9d9e62338597] xfs: fold dfops into the transaction

Carlos Maiolino (2):
      [efe803277364] xfs: Initialize variables in xfs_alloc_get_rec before using them
      [5089eafffba2] libxfs: Fix a couple of sparse complaintis

Christoph Hellwig (32):
      [a6d639da63ae] fs: factor out a __generic_write_end helper
      [63899c6f8851] iomap: add a page_done callback
      [72b4daa24129] iomap: add an iomap-based readpage and readpages implementation
      [c03cea42149d] iomap: add initial support for writes without buffer heads
      [09230435dffd] iomap: refactor iomap_dio_actor
      [8b2e77c16349] xfs: use iomap for blocksize == PAGE_SIZE readpage and readpages
      [036257213836] xfs: simplify xfs_aops_discard_page
      [d43801775766] xfs: move locking into xfs_bmap_punch_delalloc_range
      [91cdfd176165] xfs: do not set the page uptodate in xfs_writepage_map
      [c57371a16d07] xfs: don't clear imap_valid for a non-uptodate buffers
      [a7b28f72ab90] xfs: don't use XFS_BMAPI_IGSTATE in xfs_map_blocks
      [fca8c805425c] xfs: remove xfs_reflink_trim_irec_to_next_cow
      [5c665e5b5af6] xfs: remove xfs_map_cow
      [6a4c95013608] xfs: rename the offset variable in xfs_writepage_map
      [c3a2f9fff1bb] xfs: remove the now unused XFS_BMAPI_IGSTATE flag
      [060d4eaa0bf3] xfs: remove xfs_reflink_find_cow_mapping
      [3345746ef38b] xfs: simplify xfs_map_blocks by using xfs_iext_lookup_extent directly
      [889c65b3f60a] xfs: remove the imap_valid flag
      [3faed667644d] xfs: don't look at buffer heads in xfs_add_to_ioend
      [6d465e895343] xfs: move all writeback buffer_head manipulation into xfs_map_at_offset
      [1b65d3dd2d5e] xfs: remove xfs_start_page_writeback
      [8e1f065bea1b] xfs: refactor the tail of xfs_writepage_map
      [ac8ee54669c0] xfs: allow writeback on pages without buffer heads
      [9dc55f1389f9] iomap: add support for sub-pagesize buffered I/O without buffer heads
      [82cb14175e7d] xfs: add support for sub-pagesize writeback without buffer_heads
      [98c1a7c0ece3] xfs: update my copyrights for the writeback and iomap code
      [fcacbc3f5113] xfs: remove if_real_bytes
      [1216b58b353f] xfs: simplify xfs_idata_realloc
      [3ba738df2523] xfs: remove the xfs_ifork_t typedef
      [51d626903083] xfs: introduce a new xfs_inode_has_cow_data helper
      [745b3f76d1c8] xfs: maintain a sequence count for inode fork manipulations
      [e666aa37f433] xfs: avoid COW fork extent lookups in writeback if the fork didn't change

Darrick J. Wong (26):
      [c2efdfc100af] Merge branch 'iomap-4.19-merge' into for-next
      [fa248de98a6b] xfs: don't assume a left rmap when allocating a new rmap
      [65cfcc3897d7] xfs: check leaf attribute block freemap in verifier
      [81b549aa626b] xfs: return from _defer_finish with a clean transaction
      [0b04b6b875b3] xfs: trivial xfs_btree_del_cursor cleanups
      [ef97ef26d263] xfs: clean up xfs_btree_del_cursor callers
      [c517b3aa02cf] xfs: shorten xfs_scrub_ prefix
      [b5e2196e9c72] xfs: shorten xfs_repair_ prefix to xrep_
      [1d8a748a8aa9] xfs: shorten struct xfs_scrub_context to struct xfs_scrub
      [032d91f9820f] xfs: fix indentation and other whitespace problems in scrub/repair
      [2e9e6481e2a7] xfs: detect and fix bad summary counts at mount
      [53235f22151e] xfs: refactor unmount record write
      [f467cad95f5e] xfs: force summary counter recalc at next mount
      [89c3e8cf3c26] xfs: kill IHOLD
      [44a8736bd20a] xfs: clean up IRELE/iput callsites
      [ebcbef3a61a6] xfs: pass transaction lock while setting up agresv on cyclic metadata
      [bc270b53e6aa] xfs: move the repair extent list into its own file
      [86d969b425d7] xfs: refactor the xrep_extent_list into xfs_bitmap
      [eca383fcd63b] xfs: refactor superblock verifiers
      [69775fd15dc7] xfs: verify icount in superblock write
      [9e037cb7972f] xfs: check for unknown v5 feature bits in superblock write verifier
      [ff23f4af7efd] xfs: move extent busy tree initialization to xfs_initialize_perag
      [0c60d3aa0e2d] xfs: refactor log recovery check
      [611995db2ce2] xfs: use a local variable for magic number in xfs_da3_node_lookup_int
      [56830d6cc114] xfs: check da node magic in _node_lookup_int
      [1f31c98d650c] xfs: only validate summary counts on primary superblock

Dave Chinner (1):
      [e2f6ad4624df] xfs: make xfs_writepage_map extent map centric

Eric Sandeen (2):
      [a4722a643fbb] xfs: remove unused iolock arg from xfs_break_dax_layouts
      [1c02d502c208] xfs: remove deprecated barrier/nobarrier mount

Gustavo A. R. Silva (3):
      [1d5bebbafc73] xfs_attr_leaf: use swap macro in xfs_attr3_leaf_rebalance
      [897992b7e350] xfs_bmap_util: use swap macro
      [e4e542a683c1] xfs: use swap macro in xfs_dir2_leafn_rebalance

Huang Chong (1):
      [a0e336ba3e3d] xfs: fix a comment in xfs_log_reserve

Thomas Bianchi (1):
      [c2b6e1591b6b] xfs: substitute spaces with tabs


Code Diffstat:

 Documentation/filesystems/xfs.txt  |    4 +-
 fs/buffer.c                        |   76 +--
 fs/internal.h                      |    2 +
 fs/iomap.c                         |  770 ++++++++++++++++++++++++---
 fs/xfs/Makefile                    |    1 +
 fs/xfs/libxfs/xfs_ag_resv.c        |   13 +-
 fs/xfs/libxfs/xfs_ag_resv.h        |    4 +-
 fs/xfs/libxfs/xfs_alloc.c          |   46 +-
 fs/xfs/libxfs/xfs_alloc.h          |    1 -
 fs/xfs/libxfs/xfs_attr.c           |  120 ++---
 fs/xfs/libxfs/xfs_attr_leaf.c      |   70 +--
 fs/xfs/libxfs/xfs_attr_remote.c    |   26 +-
 fs/xfs/libxfs/xfs_bmap.c           |  420 ++++++---------
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
 fs/xfs/libxfs/xfs_iext_tree.c      |    6 +
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
 fs/xfs/scrub/agheader_repair.c     |   12 +-
 fs/xfs/scrub/alloc.c               |  116 ++---
 fs/xfs/scrub/attr.c                |  130 ++---
 fs/xfs/scrub/bitmap.c              |  211 ++++++++
 fs/xfs/scrub/bitmap.h              |   32 ++
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
 fs/xfs/scrub/repair.c              |  492 ++++++------------
 fs/xfs/scrub/repair.h              |   89 ++--
 fs/xfs/scrub/rmap.c                |  172 +++---
 fs/xfs/scrub/rtbitmap.c            |   78 +--
 fs/xfs/scrub/scrub.c               |  210 ++++----
 fs/xfs/scrub/scrub.h               |  134 +++--
 fs/xfs/scrub/symlink.c             |   28 +-
 fs/xfs/scrub/trace.c               |    6 +-
 fs/xfs/scrub/trace.h               |  141 +++--
 fs/xfs/xfs_aops.c                  | 1007 ++++++++++--------------------------
 fs/xfs/xfs_aops.h                  |    4 +-
 fs/xfs/xfs_attr_inactive.c         |    1 +
 fs/xfs/xfs_attr_list.c             |    2 +-
 fs/xfs/xfs_bmap_item.c             |   25 +-
 fs/xfs/xfs_bmap_item.h             |    3 +-
 fs/xfs/xfs_bmap_util.c             |  118 ++---
 fs/xfs/xfs_buf.c                   |  192 +++----
 fs/xfs/xfs_buf.h                   |   11 +-
 fs/xfs/xfs_discard.c               |    2 +-
 fs/xfs/xfs_dquot.c                 |   31 +-
 fs/xfs/xfs_error.c                 |    3 +
 fs/xfs/xfs_export.c                |    2 +-
 fs/xfs/xfs_file.c                  |    3 +-
 fs/xfs/xfs_filestream.c            |    8 +-
 fs/xfs/xfs_fsmap.c                 |    4 +-
 fs/xfs/xfs_fsops.c                 |    2 +-
 fs/xfs/xfs_icache.c                |   16 +-
 fs/xfs/xfs_inode.c                 |  177 ++-----
 fs/xfs/xfs_inode.h                 |   32 +-
 fs/xfs/xfs_inode_item.c            |    4 -
 fs/xfs/xfs_iomap.c                 |   55 +-
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
 include/linux/iomap.h              |   47 ++
 120 files changed, 5147 insertions(+), 5342 deletions(-)
 create mode 100644 fs/xfs/scrub/bitmap.c
 create mode 100644 fs/xfs/scrub/bitmap.h
