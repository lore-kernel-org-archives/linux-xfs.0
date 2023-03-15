Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D61C6FD1F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 01:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjCOBUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 21:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCOBUH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 21:20:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0EF1A67F
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 18:20:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBAC8B81C34
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 01:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F46C433EF;
        Wed, 15 Mar 2023 01:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678843201;
        bh=pFxZ3MysXGpah9y2cbYWlkRNTH88p5eHJJbElzQskkU=;
        h=Date:From:To:Cc:Subject:From;
        b=Q78FR6+NcBJnA+LwVtWAOYGRrJbbZKGxaCOB2yed51m4zdtMFwJE2wv6EuSibjSHY
         bCwg1Vl2kGs5Qzl4HEx5YskDYXxm2jr6p+kzHtfmuh78IgOERnmwtJSMhlDyofqmGs
         4Jz3mIWXf246g8l2LV7J7SmtOGdxB7VzCkQqOqESKWOo2BNCh5AoVCUWwInc+/7OfD
         PXy5IeSZM9iPzTc/ysBs5kHemVFQfL/G7mKTbmMfMMiCf3SdI7IvlIa8tzq4jPNQjc
         AAP0T8IzModSzgCs4Vapc2G1SDX3MolTZay0p3HK7TupTI0XT4aaU58WS6/r7E6Zc4
         2YYMYXcy5PFVQ==
Date:   Tue, 14 Mar 2023 18:20:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org,
        Allison Henderson <allison.henderson@oracle.com>
Subject: [PIEDAY DELUGE 2/2] xfs: online repair in its entirety
Message-ID: <167884232919.2505918.11923885383986638383.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave, et. al.,

This is the 6.3-rc2 rebase of all the online repair code, all the way to
the end of part 1.  Since the 6.2 deluge, I've incorporated the bits of
feedback I've already received.  Initial QA of these two deluges
completed last Friday, though there are some lingering reclaim hangs in
6.3 ... oddly *after* the VM has unmounted the filesystem.

I have also restructured the directory and parent pointer repair code to
match more closely the fully-fleshed versions that will appear as part 2
of online repair, in the parent pointers patchset.  This enables me to
use this branch to QA all the stuff around directory rebuilding (atomic
extent swapping, reaping, etc.) and my fork of Allison's branch to QA
the directory scanning part without having to port even more of part 1.

Speaking of which, I've finished rebasing my fork of the parent pointers
patchset, and it is undergoing testing as we speak.

--D

The following changes since commit 5023db0fd78213c4d9a5e6c027c6f9b55dc1fdc9:

xfs: cross-reference rmap records with refcount btrees (2023-03-14 17:44:07 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/xfile-page-caching_2023-03-14

for you to examine changes up to 67bb67e9a9941400f950d75d77991bf99c54ed05:

xfile: implement write caching (2023-03-14 17:44:26 -0700)

----------------------------------------------------------------
xfs: cache xfile pages for better performance

This patchset improves the performance of xfile-backed btrees by
teaching the buffer cache to directly map pages from the xfile.  It also
speeds up xfarray operations substantially by implementing a small page
cache to avoid repeated kmap/kunmap calls.  Collectively, these can
reduce the runtime of online repair functions by twenty percent or so.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (177):
xfs: cull repair code that will never get used
xfs: move the post-repair block reaping code to a separate file
xfs: only invalidate blocks if we're going to free them
xfs: only allow reaping of per-AG blocks in xrep_reap_extents
xfs: use deferred frees to reap old btree blocks
xfs: rearrange xrep_reap_block to make future code flow easier
xfs: ignore stale buffers when scanning the buffer cache
xfs: reap large AG metadata extents when possible
xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair
xfs: force all buffers to be written during btree bulk load
xfs: implement block reservation accounting for btrees we're staging
xfs: log EFIs for all btree blocks being used to stage a btree
xfs: add debug knobs to control btree bulk load slack factors
xfs: move btree bulkload record initialization to ->get_record implementations
xfs: constrain dirty buffers while formatting a staged btree
xfs: create a big array data structure
xfs: enable sorting of xfile-backed arrays
xfs: convert xfarray insertion sort to heapsort using scratchpad memory
xfs: teach xfile to pass back direct-map pages to caller
xfs: speed up xfarray sort by sorting xfile page contents directly
xfs: cache pages used for xfarray quicksort convergence
xfs: improve xfarray quicksort pivot
xfs: get our own reference to inodes that we want to scrub
xfs: wrap ilock/iunlock operations on sc->ip
xfs: move the realtime summary file scrubber to a separate source file
xfs: implement online scrubbing of rtsummary info
xfs: always rescan allegedly healthy per-ag metadata after repair
xfs: allow the user to cancel repairs before we start writing
xfs: don't complain about unfixed metadata when repairs were injected
xfs: allow userspace to rebuild metadata structures
xfs: clear pagf_agflreset when repairing the AGFL
xfs: repair free space btrees
xfs: rewrite xfs_icache_inode_is_allocated
xfs: repair inode btrees
xfs: repair refcount btrees
xfs: disable online repair quota helpers when quota not enabled
xfs: try to attach dquots to files before repairing them
xfs: repair inode records
xfs: zap broken inode forks
xfs: abort directory parent scrub scans if we encounter a zapped directory
xfs: repair obviously broken inode modes
xfs: reintroduce reaping of file metadata blocks to xrep_reap_extents
xfs: repair inode fork block mapping data structures
xfs: refactor repair forcing tests into a repair.c helper
xfs: create a ranged query function for refcount btrees
xfs: repair problems in CoW forks
xfs: repair the inode core and forks of a metadata inode
xfs: create a new inode fork block unmap helper
xfs: online repair of realtime bitmaps
xfs: repair quotas
xfs: speed up xfs_iwalk_adjust_start a little bit
xfs: implement live inode scan for scrub
xfs: allow scrub to hook metadata updates in other writers
xfs: allow blocking notifier chains with filesystem hooks
xfs: report the health of quota counts
xfs: implement live quotacheck inode scan
xfs: track quota updates during live quotacheck
xfs: repair cannot update the summary counters when logging quota flags
xfs: repair dquots based on live quotacheck results
xfs: report health of inode link counts
xfs: teach scrub to check file nlinks
xfs: track directory entry updates during live nlinks fsck
xfs: teach repair to fix file nlinks
xfs: separate the marking of sick and checked metadata
xfs: report fs corruption errors to the health tracking system
xfs: report ag header corruption errors to the health tracking system
xfs: report block map corruption errors to the health tracking system
xfs: report btree block corruption errors to the health system
xfs: report dir/attr block corruption errors to the health system
xfs: report symlink block corruption errors to the health system
xfs: report inode corruption errors to the health system
xfs: report quota block corruption errors to the health system
xfs: report realtime metadata corruption errors to the health system
xfs: report XFS_IS_CORRUPT errors to the health system
xfs: add secondary and indirect classes to the health tracking system
xfs: remember sick inodes that get inactivated
xfs: update health status if we get a clean bill of health
xfs: stabilize fs summary counters for online fsck
xfs: remove XCHK_REAPING_DISABLED from scrub
xfs: repair summary counters
xfs: dump xfiles for debugging purposes
xfs: teach buftargs to maintain their own buffer hashtable
xfs: create buftarg helpers to abstract block_device operations
xfs: make GFP_ usage consistent when allocating buftargs
xfs: support in-memory buffer cache targets
xfs: consolidate btree block freeing tracepoints
xfs: consolidate btree block allocation tracepoints
xfs: support in-memory btrees
xfs: connect in-memory btrees to xfiles
xfs: create a helper to decide if a file mapping targets the rt volume
xfs: repair the rmapbt
xfs: create a shadow rmap btree during rmap repair
xfs: hook live rmap operations during a repair operation
xfs: set the btree cursor bc_ops in xfs_btree_alloc_cursor
xfs: encode the default bc_flags in the btree ops structure
xfs: export some of the btree ops structures
xfs: initialize btree blocks using btree_ops structure
xfs: rename btree block/buffer init functions
xfs: btree convert xfs_btree_init_block to xfs_btree_init_buf calls
xfs: remove the unnecessary daddr paramter to _init_block
xfs: set btree block buffer ops in _init_buf
xfs: remove unnecessary fields in xfbtree_config
xfs: move lru refs to the btree ops structure
xfs: define an in-memory btree for storing refcount bag info during repairs
xfs: create refcount bag structure for btree repairs
xfs: port refcount repair to the new refcount bag structure
xfs: split tracepoint classes for deferred items
xfs: clean up bmap log intent item tracepoint callsites
xfs: remove xfs_trans_set_bmap_flags
xfs: fix xfs_bunmapi to allow unmapping of partial rt extents
xfs: hoist freeing of rt data fork extent mappings
xfs: add a realtime flag to the bmap update log redo items
xfs: support recovering bmap intent items targetting realtime extents
xfs: support deferred bmap updates on the attr fork
xfs: xfs_bmap_finish_one should map unwritten extents properly
xfs: move xfs_symlink_remote.c declarations to xfs_symlink_remote.h
xfs: move remote symlink target read function to libxfs
xfs: move symlink target write function to libxfs
xfs: add a libxfs header file for staging new ioctls
xfs: introduce new file range exchange ioctl
xfs: create a new helper to return a file's allocation unit
xfs: refactor non-power-of-two alignment checks
xfs: parameterize all the incompat log feature helpers
xfs: create a log incompat flag for atomic extent swapping
xfs: introduce a swap-extent log intent item
xfs: create deferred log items for extent swapping
xfs: enable xlog users to toggle atomic extent swapping
xfs: bind the xfs-specific extent swape code to the vfs-generic file exchange code
xfs: add error injection to test swapext recovery
xfs: port xfs_swap_extents_rmap to our new code
xfs: consolidate all of the xfs_swap_extent_forks code
xfs: port xfs_swap_extent_forks to use xfs_swapext_req
xfs: allow xfs_swap_range to use older extent swap algorithms
xfs: remove old swap extents implementation
xfs: condense extended attributes after an atomic swap
xfs: condense directories after an atomic swap
xfs: condense symbolic links after an atomic swap
xfs: make atomic extent swapping support realtime files
xfs: support non-power-of-two rtextsize with exchange-range
xfs: enable atomic swapext feature
xfs: hide private inodes from bulkstat and handle functions
xfs: create temporary files and directories for online repair
xfs: refactor stale buffer scanning for repairs
xfs: add the ability to reap entire inode forks
xfs: support preallocating and copying content into temporary files
xfs: teach the tempfile to support atomic extent swapping
xfs: online repair of realtime summaries
xfs: add an explicit owner field to xfs_da_args
xfs: use the xfs_da_args owner field to set new dir/attr block owner
xfs: validate attr leaf buffer owners
xfs: validate attr remote value buffer owners
xfs: validate dabtree node buffer owners
xfs: validate directory leaf buffer owners
xfs: validate explicit directory data buffer owners
xfs: validate explicit directory block buffer owners
xfs: validate explicit directory free block owners
xfs: create a blob array data structure
xfs: use atomic extent swapping to fix user file fork data
xfs: repair extended attributes
xfs: scrub should set preen if attr leaf has holes
xfs: flag empty xattr leaf blocks for optimization
xfs: use i_prev_unlinked to distinguish inodes that are not on the unlinked list
xfs: online repair of directories
xfs: scan the filesystem to repair a directory dotdot entry
xfs: online repair of parent pointers
xfs: ask the dentry cache if it knows the parent of a directory
xfs: move orphan files to the orphanage
xfs: move files to orphanage instead of letting nlinks drop to zero
xfs: ensure dentry consistency when the orphanage adopts a file
xfs: online repair of symbolic links
xfs: create an xattr iteration function for scrub
xfs: check AGI unlinked inode buckets
xfs: hoist AGI repair context to a heap object
xfs: repair AGI unlinked inode bucket lists
xfs: map xfile pages directly into xfs_buf
xfs: use b_offset to support direct-mapping pages when blocksize < pagesize
xfile: implement write caching

fs/read_write.c                    |    2 +
fs/remap_range.c                   |    4 +-
fs/xfs/Kconfig                     |   46 +
fs/xfs/Makefile                    |   53 +-
fs/xfs/libxfs/xfs_ag.c             |   45 +-
fs/xfs/libxfs/xfs_ag.h             |   19 +-
fs/xfs/libxfs/xfs_ag_resv.c        |    2 +
fs/xfs/libxfs/xfs_alloc.c          |  123 ++-
fs/xfs/libxfs/xfs_alloc.h          |    2 +
fs/xfs/libxfs/xfs_alloc_btree.c    |   36 +-
fs/xfs/libxfs/xfs_attr.c           |   12 +-
fs/xfs/libxfs/xfs_attr.h           |    2 +
fs/xfs/libxfs/xfs_attr_leaf.c      |   95 +-
fs/xfs/libxfs/xfs_attr_leaf.h      |    6 +-
fs/xfs/libxfs/xfs_attr_remote.c    |   46 +-
fs/xfs/libxfs/xfs_bmap.c           |  339 +++++--
fs/xfs/libxfs/xfs_bmap.h           |   28 +-
fs/xfs/libxfs/xfs_bmap_btree.c     |  129 ++-
fs/xfs/libxfs/xfs_bmap_btree.h     |    5 +
fs/xfs/libxfs/xfs_btree.c          |  330 ++++--
fs/xfs/libxfs/xfs_btree.h          |   62 +-
fs/xfs/libxfs/xfs_btree_mem.h      |  125 +++
fs/xfs/libxfs/xfs_btree_staging.c  |   84 +-
fs/xfs/libxfs/xfs_btree_staging.h  |   34 +-
fs/xfs/libxfs/xfs_da_btree.c       |  205 +++-
fs/xfs/libxfs/xfs_da_btree.h       |    3 +
fs/xfs/libxfs/xfs_da_format.h      |   16 +
fs/xfs/libxfs/xfs_defer.c          |    7 +
fs/xfs/libxfs/xfs_defer.h          |    3 +-
fs/xfs/libxfs/xfs_dir2.c           |   16 +-
fs/xfs/libxfs/xfs_dir2.h           |    5 +
fs/xfs/libxfs/xfs_dir2_block.c     |   46 +-
fs/xfs/libxfs/xfs_dir2_data.c      |   20 +-
fs/xfs/libxfs/xfs_dir2_leaf.c      |  102 +-
fs/xfs/libxfs/xfs_dir2_node.c      |   51 +-
fs/xfs/libxfs/xfs_dir2_priv.h      |   13 +-
fs/xfs/libxfs/xfs_dir2_sf.c        |   29 +-
fs/xfs/libxfs/xfs_errortag.h       |    4 +-
fs/xfs/libxfs/xfs_format.h         |   18 +-
fs/xfs/libxfs/xfs_fs.h             |   16 +-
fs/xfs/libxfs/xfs_fs_staging.h     |  105 ++
fs/xfs/libxfs/xfs_health.h         |   86 +-
fs/xfs/libxfs/xfs_ialloc.c         |   98 +-
fs/xfs/libxfs/xfs_ialloc.h         |    3 +
fs/xfs/libxfs/xfs_ialloc_btree.c   |   19 +-
fs/xfs/libxfs/xfs_iext_tree.c      |   23 +-
fs/xfs/libxfs/xfs_inode_buf.c      |   12 +-
fs/xfs/libxfs/xfs_inode_fork.c     |   19 +
fs/xfs/libxfs/xfs_inode_fork.h     |    4 +
fs/xfs/libxfs/xfs_log_format.h     |   84 +-
fs/xfs/libxfs/xfs_log_recover.h    |    2 +
fs/xfs/libxfs/xfs_refcount.c       |  102 +-
fs/xfs/libxfs/xfs_refcount.h       |   12 +
fs/xfs/libxfs/xfs_refcount_btree.c |   26 +-
fs/xfs/libxfs/xfs_rmap.c           |  275 +++--
fs/xfs/libxfs/xfs_rmap.h           |   30 +
fs/xfs/libxfs/xfs_rmap_btree.c     |  149 ++-
fs/xfs/libxfs/xfs_rmap_btree.h     |    9 +
fs/xfs/libxfs/xfs_rtbitmap.c       |   42 +-
fs/xfs/libxfs/xfs_sb.c             |    5 +
fs/xfs/libxfs/xfs_shared.h         |   22 +-
fs/xfs/libxfs/xfs_swapext.c        | 1261 +++++++++++++++++++++++
fs/xfs/libxfs/xfs_swapext.h        |  171 ++++
fs/xfs/libxfs/xfs_symlink_remote.c |  226 ++++-
fs/xfs/libxfs/xfs_symlink_remote.h |   42 +
fs/xfs/libxfs/xfs_trans_space.h    |    4 +
fs/xfs/libxfs/xfs_types.h          |   13 +-
fs/xfs/scrub/agheader.c            |   40 +
fs/xfs/scrub/agheader_repair.c     |  673 +++++++++++--
fs/xfs/scrub/alloc.c               |   16 +-
fs/xfs/scrub/alloc_repair.c        |  910 +++++++++++++++++
fs/xfs/scrub/attr.c                |  157 ++-
fs/xfs/scrub/attr.h                |    7 +
fs/xfs/scrub/attr_repair.c         | 1154 +++++++++++++++++++++
fs/xfs/scrub/bitmap.c              |  120 +--
fs/xfs/scrub/bitmap.h              |   46 +-
fs/xfs/scrub/bmap.c                |   33 +-
fs/xfs/scrub/bmap_repair.c         |  785 +++++++++++++++
fs/xfs/scrub/common.c              |  173 +++-
fs/xfs/scrub/common.h              |   64 +-
fs/xfs/scrub/cow_repair.c          |  660 ++++++++++++
fs/xfs/scrub/dabtree.c             |   24 +
fs/xfs/scrub/dabtree.h             |    3 +
fs/xfs/scrub/dir.c                 |   53 +-
fs/xfs/scrub/dir_repair.c          | 1389 +++++++++++++++++++++++++
fs/xfs/scrub/findparent.c          |  449 +++++++++
fs/xfs/scrub/findparent.h          |   50 +
fs/xfs/scrub/fscounters.c          |  264 ++++-
fs/xfs/scrub/fscounters.h          |   20 +
fs/xfs/scrub/fscounters_repair.c   |   72 ++
fs/xfs/scrub/health.c              |  108 +-
fs/xfs/scrub/health.h              |    1 +
fs/xfs/scrub/ialloc_repair.c       |  872 ++++++++++++++++
fs/xfs/scrub/inode.c               |   25 +-
fs/xfs/scrub/inode_repair.c        | 1592 +++++++++++++++++++++++++++++
fs/xfs/scrub/iscan.c               |  494 +++++++++
fs/xfs/scrub/iscan.h               |   63 ++
fs/xfs/scrub/listxattr.c           |  310 ++++++
fs/xfs/scrub/listxattr.h           |   17 +
fs/xfs/scrub/newbt.c               |  662 ++++++++++++
fs/xfs/scrub/newbt.h               |   79 ++
fs/xfs/scrub/nlinks.c              |  962 ++++++++++++++++++
fs/xfs/scrub/nlinks.h              |  105 ++
fs/xfs/scrub/nlinks_repair.c       |  473 +++++++++
fs/xfs/scrub/orphanage.c           |  504 ++++++++++
fs/xfs/scrub/orphanage.h           |   79 ++
fs/xfs/scrub/parent.c              |   28 +-
fs/xfs/scrub/parent_repair.c       |  308 ++++++
fs/xfs/scrub/quota.c               |   24 +-
fs/xfs/scrub/quota.h               |   11 +
fs/xfs/scrub/quota_repair.c        |  405 ++++++++
fs/xfs/scrub/quotacheck.c          |  846 ++++++++++++++++
fs/xfs/scrub/quotacheck.h          |   76 ++
fs/xfs/scrub/quotacheck_repair.c   |  254 +++++
fs/xfs/scrub/rcbag.c               |  331 ++++++
fs/xfs/scrub/rcbag.h               |   28 +
fs/xfs/scrub/rcbag_btree.c         |  373 +++++++
fs/xfs/scrub/rcbag_btree.h         |   83 ++
fs/xfs/scrub/readdir.c             |    6 +-
fs/xfs/scrub/reap.c                | 1026 +++++++++++++++++++
fs/xfs/scrub/reap.h                |   35 +
fs/xfs/scrub/refcount.c            |   16 +-
fs/xfs/scrub/refcount_repair.c     |  745 ++++++++++++++
fs/xfs/scrub/repair.c              |  938 +++++++++++------
fs/xfs/scrub/repair.h              |  179 +++-
fs/xfs/scrub/rmap.c                |    9 +
fs/xfs/scrub/rmap_repair.c         | 1688 +++++++++++++++++++++++++++++++
fs/xfs/scrub/rtbitmap.c            |   60 +-
fs/xfs/scrub/rtbitmap_repair.c     |   56 ++
fs/xfs/scrub/rtsummary.c           |  274 +++++
fs/xfs/scrub/rtsummary.h           |   14 +
fs/xfs/scrub/rtsummary_repair.c    |  169 ++++
fs/xfs/scrub/scrub.c               |  147 ++-
fs/xfs/scrub/scrub.h               |   48 +-
fs/xfs/scrub/symlink.c             |   16 +-
fs/xfs/scrub/symlink_repair.c      |  452 +++++++++
fs/xfs/scrub/tempfile.c            |  815 +++++++++++++++
fs/xfs/scrub/tempfile.h            |   46 +
fs/xfs/scrub/tempswap.h            |   23 +
fs/xfs/scrub/trace.c               |   24 +-
fs/xfs/scrub/trace.h               | 1953 ++++++++++++++++++++++++++++++++++--
fs/xfs/scrub/xfarray.c             | 1108 ++++++++++++++++++++
fs/xfs/scrub/xfarray.h             |  185 ++++
fs/xfs/scrub/xfblob.c              |  176 ++++
fs/xfs/scrub/xfblob.h              |   27 +
fs/xfs/scrub/xfbtree.c             |  827 +++++++++++++++
fs/xfs/scrub/xfbtree.h             |   57 ++
fs/xfs/scrub/xfile.c               |  690 +++++++++++++
fs/xfs/scrub/xfile.h               |  165 +++
fs/xfs/xfs_acl.c                   |    2 +
fs/xfs/xfs_aops.c                  |    5 +-
fs/xfs/xfs_attr_inactive.c         |    4 +
fs/xfs/xfs_attr_item.c             |    1 +
fs/xfs/xfs_attr_list.c             |   53 +-
fs/xfs/xfs_bmap_item.c             |   58 +-
fs/xfs/xfs_bmap_util.c             |  628 +-----------
fs/xfs/xfs_bmap_util.h             |    3 -
fs/xfs/xfs_buf.c                   |  352 +++++--
fs/xfs/xfs_buf.h                   |  109 +-
fs/xfs/xfs_buf_xfile.c             |  251 +++++
fs/xfs/xfs_buf_xfile.h             |   31 +
fs/xfs/xfs_dir2_readdir.c          |   13 +-
fs/xfs/xfs_discard.c               |   10 +-
fs/xfs/xfs_dquot.c                 |   30 +
fs/xfs/xfs_error.c                 |    3 +
fs/xfs/xfs_export.c                |    2 +-
fs/xfs/xfs_extent_busy.c           |   13 +
fs/xfs/xfs_extent_busy.h           |    2 +
fs/xfs/xfs_file.c                  |   30 +-
fs/xfs/xfs_globals.c               |   12 +
fs/xfs/xfs_health.c                |  202 +++-
fs/xfs/xfs_hooks.c                 |   94 ++
fs/xfs/xfs_hooks.h                 |   72 ++
fs/xfs/xfs_icache.c                |  138 ++-
fs/xfs/xfs_inode.c                 |  406 +++++++-
fs/xfs/xfs_inode.h                 |   65 +-
fs/xfs/xfs_ioctl.c                 |  137 ++-
fs/xfs/xfs_ioctl.h                 |    4 +-
fs/xfs/xfs_ioctl32.c               |   11 +-
fs/xfs/xfs_iomap.c                 |   19 +-
fs/xfs/xfs_iops.c                  |    1 +
fs/xfs/xfs_itable.c                |    8 +
fs/xfs/xfs_iwalk.c                 |   18 +-
fs/xfs/xfs_linux.h                 |    7 +
fs/xfs/xfs_log.c                   |   51 +-
fs/xfs/xfs_log.h                   |   10 +-
fs/xfs/xfs_log_cil.c               |    3 +-
fs/xfs/xfs_log_priv.h              |    3 +-
fs/xfs/xfs_log_recover.c           |    8 +-
fs/xfs/xfs_mount.c                 |   16 +-
fs/xfs/xfs_mount.h                 |   12 +-
fs/xfs/xfs_qm.c                    |   31 +-
fs/xfs/xfs_qm.h                    |   16 +
fs/xfs/xfs_qm_bhv.c                |    1 +
fs/xfs/xfs_quota.h                 |   45 +
fs/xfs/xfs_reflink.c               |   14 +-
fs/xfs/xfs_rtalloc.c               |  165 +++
fs/xfs/xfs_rtalloc.h               |    8 +
fs/xfs/xfs_super.c                 |   35 +-
fs/xfs/xfs_swapext_item.c          |  657 ++++++++++++
fs/xfs/xfs_swapext_item.h          |   56 ++
fs/xfs/xfs_symlink.c               |  200 +---
fs/xfs/xfs_symlink.h               |    1 -
fs/xfs/xfs_sysctl.h                |    2 +
fs/xfs/xfs_sysfs.c                 |   54 +
fs/xfs/xfs_trace.c                 |    6 +
fs/xfs/xfs_trace.h                 |  752 +++++++++++---
fs/xfs/xfs_trans.c                 |   95 ++
fs/xfs/xfs_trans.h                 |    5 +
fs/xfs/xfs_trans_buf.c             |   42 +
fs/xfs/xfs_trans_dquot.c           |  158 ++-
fs/xfs/xfs_xattr.c                 |    8 +-
fs/xfs/xfs_xchgrange.c             | 1364 +++++++++++++++++++++++++
fs/xfs/xfs_xchgrange.h             |   56 ++
include/linux/fs.h                 |    1 +
215 files changed, 37142 insertions(+), 2803 deletions(-)
create mode 100644 fs/xfs/libxfs/xfs_btree_mem.h
create mode 100644 fs/xfs/libxfs/xfs_fs_staging.h
create mode 100644 fs/xfs/libxfs/xfs_swapext.c
create mode 100644 fs/xfs/libxfs/xfs_swapext.h
create mode 100644 fs/xfs/libxfs/xfs_symlink_remote.h
create mode 100644 fs/xfs/scrub/alloc_repair.c
create mode 100644 fs/xfs/scrub/attr_repair.c
create mode 100644 fs/xfs/scrub/bmap_repair.c
create mode 100644 fs/xfs/scrub/cow_repair.c
create mode 100644 fs/xfs/scrub/dir_repair.c
create mode 100644 fs/xfs/scrub/findparent.c
create mode 100644 fs/xfs/scrub/findparent.h
create mode 100644 fs/xfs/scrub/fscounters.h
create mode 100644 fs/xfs/scrub/fscounters_repair.c
create mode 100644 fs/xfs/scrub/ialloc_repair.c
create mode 100644 fs/xfs/scrub/inode_repair.c
create mode 100644 fs/xfs/scrub/iscan.c
create mode 100644 fs/xfs/scrub/iscan.h
create mode 100644 fs/xfs/scrub/listxattr.c
create mode 100644 fs/xfs/scrub/listxattr.h
create mode 100644 fs/xfs/scrub/newbt.c
create mode 100644 fs/xfs/scrub/newbt.h
create mode 100644 fs/xfs/scrub/nlinks.c
create mode 100644 fs/xfs/scrub/nlinks.h
create mode 100644 fs/xfs/scrub/nlinks_repair.c
create mode 100644 fs/xfs/scrub/orphanage.c
create mode 100644 fs/xfs/scrub/orphanage.h
create mode 100644 fs/xfs/scrub/parent_repair.c
create mode 100644 fs/xfs/scrub/quota.h
create mode 100644 fs/xfs/scrub/quota_repair.c
create mode 100644 fs/xfs/scrub/quotacheck.c
create mode 100644 fs/xfs/scrub/quotacheck.h
create mode 100644 fs/xfs/scrub/quotacheck_repair.c
create mode 100644 fs/xfs/scrub/rcbag.c
create mode 100644 fs/xfs/scrub/rcbag.h
create mode 100644 fs/xfs/scrub/rcbag_btree.c
create mode 100644 fs/xfs/scrub/rcbag_btree.h
create mode 100644 fs/xfs/scrub/reap.c
create mode 100644 fs/xfs/scrub/reap.h
create mode 100644 fs/xfs/scrub/refcount_repair.c
create mode 100644 fs/xfs/scrub/rmap_repair.c
create mode 100644 fs/xfs/scrub/rtbitmap_repair.c
create mode 100644 fs/xfs/scrub/rtsummary.c
create mode 100644 fs/xfs/scrub/rtsummary.h
create mode 100644 fs/xfs/scrub/rtsummary_repair.c
create mode 100644 fs/xfs/scrub/symlink_repair.c
create mode 100644 fs/xfs/scrub/tempfile.c
create mode 100644 fs/xfs/scrub/tempfile.h
create mode 100644 fs/xfs/scrub/tempswap.h
create mode 100644 fs/xfs/scrub/xfarray.c
create mode 100644 fs/xfs/scrub/xfarray.h
create mode 100644 fs/xfs/scrub/xfblob.c
create mode 100644 fs/xfs/scrub/xfblob.h
create mode 100644 fs/xfs/scrub/xfbtree.c
create mode 100644 fs/xfs/scrub/xfbtree.h
create mode 100644 fs/xfs/scrub/xfile.c
create mode 100644 fs/xfs/scrub/xfile.h
create mode 100644 fs/xfs/xfs_buf_xfile.c
create mode 100644 fs/xfs/xfs_buf_xfile.h
create mode 100644 fs/xfs/xfs_hooks.c
create mode 100644 fs/xfs/xfs_hooks.h
create mode 100644 fs/xfs/xfs_swapext_item.c
create mode 100644 fs/xfs/xfs_swapext_item.h
create mode 100644 fs/xfs/xfs_xchgrange.c
create mode 100644 fs/xfs/xfs_xchgrange.h
