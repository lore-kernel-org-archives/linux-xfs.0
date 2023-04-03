Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2D4C76196
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Apr 2023 17:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbjDCR52 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Apr 2023 13:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjDCR5S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2023 13:57:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194283A8B
        for <linux-xfs@vger.kernel.org>; Mon,  3 Apr 2023 10:57:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5867E6247A
        for <linux-xfs@vger.kernel.org>; Mon,  3 Apr 2023 17:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2356C433EF;
        Mon,  3 Apr 2023 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680544625;
        bh=ttJpHh/YJ9wuHtrDDYXm8dnNlXS2p3QcRS8EDvr95L4=;
        h=Date:From:To:Cc:Subject:From;
        b=DDe6jWXJhqxnkx/66017GjkPMBScPmtlYNmeMbT35s5wj5QF6NXYoB2bfDJb2fb+v
         Vjp9xz7i7DUcgVlc4P1KMNlzJVPNQ/SsyLvEqH1RYd63De78fBI8OlpCL+ZLyUy77x
         UwA2QoI4AN92Hzi8PJVj/YwPE26r1LaMMRmyYebaheNmpJOzxMfaUirbmQTH38f4hP
         3HzijeSldu/zlWcTfb6NQjfbiwp7kB9HIgDPvSm68Oua+cmev8kvRGdJvzuBzLQrzp
         A/xmO4troTwGuDBotOpAkX415HwfSYnSf+DwQZ0z9t5VY7j390/ED8RqBuxoIAl2db
         WWiFg10CSykzg==
Date:   Mon, 3 Apr 2023 10:57:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE 2/2] xfs-linux: xfile-page-caching updated to 7645630a8125
Message-ID: <168054443139.1440442.11283371172805608801.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The xfile-page-caching branch of the xfs-linux repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git

has just been updated for your review.

This code snapshot has been rebased against recent upstream, freshly
QA'd, and is ready for people to examine.  For veteran readers, the new
snapshot can be diffed against the previous snapshot; and for new
readers, this is a reasonable place to begin reading.  For the best
experience, it is recommended to pull this branch and walk the commits
instead of trying to read any patch deluge.

This is the 6.3-rc5 rebase of all the online repair code, all the way to
the end of part 1.  This contains fixes for the low-hanging fruit that
Dave mentioned on #xfs last week.

The new head of the xfile-page-caching branch is commit:

7645630a8125 xfile: implement write caching

181 new commits:

Darrick J. Wong (181):
[e50e32baba88] xfs: cull repair code that will never get used
[05f44dc1ee07] xfs: move the post-repair block reaping code to a separate file
[42a7e88cb62c] xfs: only invalidate blocks if we're going to free them
[b29dd93d431a] xfs: only allow reaping of per-AG blocks in xrep_reap_extents
[f3a1a6c9c314] xfs: use deferred frees to reap old btree blocks
[1f370adf64c3] xfs: rearrange xrep_reap_block to make future code flow easier
[8d3b97296c4c] xfs: ignore stale buffers when scanning the buffer cache
[382e8233c6f7] xfs: reap large AG metadata extents when possible
[c5d9bd68bf01] xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair
[4ac83af6283e] xfs: force all buffers to be written during btree bulk load
[f1a0050ea3db] xfs: implement block reservation accounting for btrees we're staging
[94249cf00ecd] xfs: log EFIs for all btree blocks being used to stage a btree
[a5912a189636] xfs: add debug knobs to control btree bulk load slack factors
[00c2140738eb] xfs: move btree bulkload record initialization to ->get_record implementations
[6d1e6525feb9] xfs: constrain dirty buffers while formatting a staged btree
[ba62a2be9fbd] xfs: create a big array data structure
[fe58b2ee26bf] xfs: enable sorting of xfile-backed arrays
[d87aea74fd5d] xfs: convert xfarray insertion sort to heapsort using scratchpad memory
[9c3f4fcd0ea2] xfs: teach xfile to pass back direct-map pages to caller
[a35f6954ea7a] xfs: speed up xfarray sort by sorting xfile page contents directly
[f4d738f5b69c] xfs: cache pages used for xfarray quicksort convergence
[8b2ab4514840] xfs: improve xfarray quicksort pivot
[d60e0702a433] xfs: get our own reference to inodes that we want to scrub
[7d39a836abb1] xfs: wrap ilock/iunlock operations on sc->ip
[8ea893eff418] xfs: move the realtime summary file scrubber to a separate source file
[402dd5e2bfc1] xfs: implement online scrubbing of rtsummary info
[4ed075b8ed28] xfs: always rescan allegedly healthy per-ag metadata after repair
[0adcfa541db2] xfs: allow the user to cancel repairs before we start writing
[28be0a39d308] xfs: don't complain about unfixed metadata when repairs were injected
[a7ca420a3d6b] xfs: allow userspace to rebuild metadata structures
[2470c95bb703] xfs: clear pagf_agflreset when repairing the AGFL
[fb16f2648543] xfs: repair free space btrees
[2aefeef55ffd] xfs: rewrite xfs_icache_inode_is_allocated
[a2594325c225] xfs: repair inode btrees
[b0229cd2c5ef] xfs: repair refcount btrees
[968b13fb12f0] xfs: disable online repair quota helpers when quota not enabled
[d8cc56f2865d] xfs: try to attach dquots to files before repairing them
[d3200b180026] xfs: repair inode records
[3f48930471c6] xfs: zap broken inode forks
[251c09c228ae] xfs: abort directory parent scrub scans if we encounter a zapped directory
[63aea9f247fe] xfs: repair obviously broken inode modes
[6ecd34330ab2] xfs: reintroduce reaping of file metadata blocks to xrep_reap_extents
[1f29398479b3] xfs: repair inode fork block mapping data structures
[6f59cbd80918] xfs: refactor repair forcing tests into a repair.c helper
[dd4d6fb08da6] xfs: create a ranged query function for refcount btrees
[4cf2f834cf7a] xfs: repair problems in CoW forks
[e4a615b51363] xfs: repair the inode core and forks of a metadata inode
[e3df260b87b6] xfs: create a new inode fork block unmap helper
[d816ce5c2c35] xfs: online repair of realtime bitmaps
[b6fca41391ab] xfs: repair quotas
[4377dd0cee4f] xfs: speed up xfs_iwalk_adjust_start a little bit
[060eae513f67] xfs: implement live inode scan for scrub
[ca738ab61221] xfs: allow scrub to hook metadata updates in other writers
[795d86725cc5] xfs: allow blocking notifier chains with filesystem hooks
[0939410d8148] xfs: stagger the starting AG of scrub iscans to reduce contention
[b11452ed4bbe] xfs: cache a bunch of inodes for repair scans
[b7f744cde0cf] xfs: report the health of quota counts
[3c957c1b0ab8] xfs: implement live quotacheck inode scan
[d6bb5d35517f] xfs: track quota updates during live quotacheck
[b8697ae651e5] xfs: repair cannot update the summary counters when logging quota flags
[a05b05313676] xfs: repair dquots based on live quotacheck results
[e603e3880df5] xfs: report health of inode link counts
[22b3d1145f1e] xfs: teach scrub to check file nlinks
[d09e94a91243] xfs: track directory entry updates during live nlinks fsck
[7487d6bd52a6] xfs: teach repair to fix file nlinks
[052e86bd2948] xfs: separate the marking of sick and checked metadata
[bb717a0a03f1] xfs: report fs corruption errors to the health tracking system
[8e0b397ccf76] xfs: report ag header corruption errors to the health tracking system
[1e34542606ba] xfs: report block map corruption errors to the health tracking system
[ee16d7034c55] xfs: report btree block corruption errors to the health system
[5bcc3b1416f1] xfs: report dir/attr block corruption errors to the health system
[71345106d69c] xfs: report symlink block corruption errors to the health system
[421e82ac28da] xfs: report inode corruption errors to the health system
[83edf52ae0c7] xfs: report quota block corruption errors to the health system
[566eae1493a6] xfs: report realtime metadata corruption errors to the health system
[31112488ef45] xfs: report XFS_IS_CORRUPT errors to the health system
[efd7bfeaceea] xfs: add secondary and indirect classes to the health tracking system
[84ab30772b17] xfs: remember sick inodes that get inactivated
[6f9d45c4455f] xfs: update health status if we get a clean bill of health
[0843711cbc7b] xfs: stabilize fs summary counters for online fsck
[445b177d5919] xfs: remove XCHK_REAPING_DISABLED from scrub
[3efa08786ecd] xfs: repair summary counters
[de3bf0375fa0] xfs: dump xfiles for debugging purposes
[11dae6306cbf] xfs: teach buftargs to maintain their own buffer hashtable
[bd006efe39ac] xfs: create buftarg helpers to abstract block_device operations
[864df1ac3ead] xfs: make GFP_ usage consistent when allocating buftargs
[402c743108ab] xfs: support in-memory buffer cache targets
[197dc430f879] xfs: consolidate btree block freeing tracepoints
[fefcb2c81f7b] xfs: consolidate btree block allocation tracepoints
[bd14e185a296] xfs: support in-memory btrees
[98a577e92987] xfs: connect in-memory btrees to xfiles
[828ef95494d1] xfs: create a helper to decide if a file mapping targets the rt volume
[f171c81c4978] xfs: repair the rmapbt
[c5bc64410225] xfs: create a shadow rmap btree during rmap repair
[1bc87b33dd7c] xfs: hook live rmap operations during a repair operation
[f71b52be1f9a] xfs: set the btree cursor bc_ops in xfs_btree_alloc_cursor
[7f5e4bc312b4] xfs: encode the default bc_flags in the btree ops structure
[44ed0ac60c59] xfs: export some of the btree ops structures
[3880cc0c9cc0] xfs: initialize btree blocks using btree_ops structure
[c9a1bfbbd982] xfs: rename btree block/buffer init functions
[352d144583e0] xfs: btree convert xfs_btree_init_block to xfs_btree_init_buf calls
[181a9c6a5cc0] xfs: remove the unnecessary daddr paramter to _init_block
[d9b35e5617fc] xfs: set btree block buffer ops in _init_buf
[f058fe75d11c] xfs: remove unnecessary fields in xfbtree_config
[67fd3b7f82fb] xfs: move lru refs to the btree ops structure
[3db839ef5d33] xfs: define an in-memory btree for storing refcount bag info during repairs
[bf55af297ca1] xfs: create refcount bag structure for btree repairs
[0cd1b6742df7] xfs: port refcount repair to the new refcount bag structure
[ec72ee03296f] xfs: split tracepoint classes for deferred items
[ad73debd2ed2] xfs: clean up bmap log intent item tracepoint callsites
[fe0d8ab83c2a] xfs: remove xfs_trans_set_bmap_flags
[03fc9f7551e2] xfs: fix xfs_bunmapi to allow unmapping of partial rt extents
[92bbb831db23] xfs: hoist freeing of rt data fork extent mappings
[7ba8d425d67b] xfs: add a realtime flag to the bmap update log redo items
[396c631437c1] xfs: support recovering bmap intent items targetting realtime extents
[a2a43eec31c9] xfs: support deferred bmap updates on the attr fork
[2a42bd92ded2] xfs: xfs_bmap_finish_one should map unwritten extents properly
[68668f8db7e8] xfs: move xfs_symlink_remote.c declarations to xfs_symlink_remote.h
[e7be6e1baf22] xfs: move remote symlink target read function to libxfs
[a406f78baa94] xfs: move symlink target write function to libxfs
[ce02a1172c09] xfs: add a libxfs header file for staging new ioctls
[cc16df2f2365] xfs: introduce new file range exchange ioctl
[d9813bb44a12] xfs: create a new helper to return a file's allocation unit
[d008d1dc472d] xfs: refactor non-power-of-two alignment checks
[0bdda07c3444] xfs: parameterize all the incompat log feature helpers
[c6ff5eda7612] xfs: create a log incompat flag for atomic extent swapping
[bc7fb950d0d9] xfs: introduce a swap-extent log intent item
[0fc6a0ec9e0b] xfs: create deferred log items for extent swapping
[8e1f7db49cca] xfs: enable xlog users to toggle atomic extent swapping
[e7275c5dec8c] xfs: bind the xfs-specific extent swape code to the vfs-generic file exchange code
[0d0107fe0eb5] xfs: add error injection to test swapext recovery
[3c05c0ef7927] xfs: port xfs_swap_extents_rmap to our new code
[73d5cabc455a] xfs: consolidate all of the xfs_swap_extent_forks code
[2d8ef325768d] xfs: port xfs_swap_extent_forks to use xfs_swapext_req
[6e7c8821f329] xfs: allow xfs_swap_range to use older extent swap algorithms
[53b6176cfe2a] xfs: remove old swap extents implementation
[843bd728ce85] xfs: condense extended attributes after an atomic swap
[f921b65e87a1] xfs: condense directories after an atomic swap
[521905092f42] xfs: condense symbolic links after an atomic swap
[79bbca4f643d] xfs: make atomic extent swapping support realtime files
[9026727129f0] xfs: support non-power-of-two rtextsize with exchange-range
[cfce1261586b] xfs: enable atomic swapext feature
[29402061f391] xfs: hide private inodes from bulkstat and handle functions
[3698dfe4fbbc] xfs: create temporary files and directories for online repair
[f3f8ceb0fdfe] xfs: refactor stale buffer scanning for repairs
[16649bf5471f] xfs: add the ability to reap entire inode forks
[b1efba097df0] xfs: support preallocating and copying content into temporary files
[8a9ffaf7a3a0] xfs: teach the tempfile to support atomic extent swapping
[ba1d3974c24f] xfs: online repair of realtime summaries
[7e1160f97e87] xfs: add an explicit owner field to xfs_da_args
[6ad0dfa7877d] xfs: use the xfs_da_args owner field to set new dir/attr block owner
[5614bf446357] xfs: validate attr leaf buffer owners
[f52a368dc444] xfs: validate attr remote value buffer owners
[bd25262256c7] xfs: validate dabtree node buffer owners
[9a876ea14cb5] xfs: validate directory leaf buffer owners
[4931b603848f] xfs: validate explicit directory data buffer owners
[aa3127a7be04] xfs: validate explicit directory block buffer owners
[dcbfa1200a7d] xfs: validate explicit directory free block owners
[a51c2066034f] xfs: create a blob array data structure
[edd5e464e0e3] xfs: use atomic extent swapping to fix user file fork data
[50f24451b321] xfs: repair extended attributes
[b7f9686239a3] xfs: scrub should set preen if attr leaf has holes
[63e3f2911ac4] xfs: flag empty xattr leaf blocks for optimization
[35541a047e60] xfs: use i_prev_unlinked to distinguish inodes that are not on the unlinked list
[f939334f1fe2] xfs: ensure unlinked list state is consistent with nlink during scrub
[a4b190aed5cb] xfs: update the unlinked list when repairing link counts
[a18cb9bc4719] xfs: online repair of directories
[40509a6a364e] xfs: scan the filesystem to repair a directory dotdot entry
[1ad49ff681e0] xfs: online repair of parent pointers
[b4c1b2d5fb44] xfs: ask the dentry cache if it knows the parent of a directory
[3435ca1410d9] xfs: move orphan files to the orphanage
[14bed339a237] xfs: move files to orphanage instead of letting nlinks drop to zero
[4ee90951ca7d] xfs: ensure dentry consistency when the orphanage adopts a file
[f99f852e67a1] xfs: online repair of symbolic links
[059ff98c9e1d] xfs: create an xattr iteration function for scrub
[754fd1903107] xfs: check AGI unlinked inode buckets
[4b6ffc7d623f] xfs: hoist AGI repair context to a heap object
[69a4b596c001] xfs: repair AGI unlinked inode bucket lists
[442907cb496e] xfs: map xfile pages directly into xfs_buf
[761b6a5d5e7c] xfs: use b_offset to support direct-mapping pages when blocksize < pagesize
[7645630a8125] xfile: implement write caching

Code Diffstat:

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
fs/xfs/libxfs/xfs_bmap.c           |  339 ++++--
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
fs/xfs/libxfs/xfs_rmap.c           |  275 ++++-
fs/xfs/libxfs/xfs_rmap.h           |   30 +
fs/xfs/libxfs/xfs_rmap_btree.c     |  149 ++-
fs/xfs/libxfs/xfs_rmap_btree.h     |    9 +
fs/xfs/libxfs/xfs_rtbitmap.c       |   42 +-
fs/xfs/libxfs/xfs_sb.c             |    5 +
fs/xfs/libxfs/xfs_shared.h         |   22 +-
fs/xfs/libxfs/xfs_swapext.c        | 1261 ++++++++++++++++++++++
fs/xfs/libxfs/xfs_swapext.h        |  171 +++
fs/xfs/libxfs/xfs_symlink_remote.c |  226 +++-
fs/xfs/libxfs/xfs_symlink_remote.h |   42 +
fs/xfs/libxfs/xfs_trans_space.h    |    4 +
fs/xfs/libxfs/xfs_types.h          |   13 +-
fs/xfs/scrub/agheader.c            |   40 +
fs/xfs/scrub/agheader_repair.c     |  843 +++++++++++++--
fs/xfs/scrub/alloc.c               |   16 +-
fs/xfs/scrub/alloc_repair.c        |  910 ++++++++++++++++
fs/xfs/scrub/attr.c                |  157 ++-
fs/xfs/scrub/attr.h                |    7 +
fs/xfs/scrub/attr_repair.c         | 1154 ++++++++++++++++++++
fs/xfs/scrub/bitmap.c              |  120 +--
fs/xfs/scrub/bitmap.h              |   46 +-
fs/xfs/scrub/bmap.c                |   33 +-
fs/xfs/scrub/bmap_repair.c         |  785 ++++++++++++++
fs/xfs/scrub/common.c              |  173 ++-
fs/xfs/scrub/common.h              |   64 +-
fs/xfs/scrub/cow_repair.c          |  660 ++++++++++++
fs/xfs/scrub/dabtree.c             |   24 +
fs/xfs/scrub/dabtree.h             |    3 +
fs/xfs/scrub/dir.c                 |   53 +-
fs/xfs/scrub/dir_repair.c          | 1389 ++++++++++++++++++++++++
fs/xfs/scrub/findparent.c          |  450 ++++++++
fs/xfs/scrub/findparent.h          |   50 +
fs/xfs/scrub/fscounters.c          |  264 ++++-
fs/xfs/scrub/fscounters.h          |   20 +
fs/xfs/scrub/fscounters_repair.c   |   72 ++
fs/xfs/scrub/health.c              |  108 +-
fs/xfs/scrub/health.h              |    1 +
fs/xfs/scrub/ialloc_repair.c       |  872 +++++++++++++++
fs/xfs/scrub/inode.c               |   44 +-
fs/xfs/scrub/inode_repair.c        | 1632 ++++++++++++++++++++++++++++
fs/xfs/scrub/iscan.c               |  678 ++++++++++++
fs/xfs/scrub/iscan.h               |   78 ++
fs/xfs/scrub/listxattr.c           |  310 ++++++
fs/xfs/scrub/listxattr.h           |   17 +
fs/xfs/scrub/newbt.c               |  662 ++++++++++++
fs/xfs/scrub/newbt.h               |   79 ++
fs/xfs/scrub/nlinks.c              |  964 +++++++++++++++++
fs/xfs/scrub/nlinks.h              |  105 ++
fs/xfs/scrub/nlinks_repair.c       |  421 ++++++++
fs/xfs/scrub/orphanage.c           |  505 +++++++++
fs/xfs/scrub/orphanage.h           |   79 ++
fs/xfs/scrub/parent.c              |   28 +-
fs/xfs/scrub/parent_repair.c       |  308 ++++++
fs/xfs/scrub/quota.c               |   24 +-
fs/xfs/scrub/quota.h               |   11 +
fs/xfs/scrub/quota_repair.c        |  405 +++++++
fs/xfs/scrub/quotacheck.c          |  847 +++++++++++++++
fs/xfs/scrub/quotacheck.h          |   76 ++
fs/xfs/scrub/quotacheck_repair.c   |  254 +++++
fs/xfs/scrub/rcbag.c               |  331 ++++++
fs/xfs/scrub/rcbag.h               |   28 +
fs/xfs/scrub/rcbag_btree.c         |  373 +++++++
fs/xfs/scrub/rcbag_btree.h         |   83 ++
fs/xfs/scrub/readdir.c             |   13 +-
fs/xfs/scrub/reap.c                | 1026 ++++++++++++++++++
fs/xfs/scrub/reap.h                |   35 +
fs/xfs/scrub/refcount.c            |   16 +-
fs/xfs/scrub/refcount_repair.c     |  745 +++++++++++++
fs/xfs/scrub/repair.c              |  932 ++++++++++------
fs/xfs/scrub/repair.h              |  179 +++-
fs/xfs/scrub/rmap.c                |    9 +
fs/xfs/scrub/rmap_repair.c         | 1689 +++++++++++++++++++++++++++++
fs/xfs/scrub/rtbitmap.c            |   60 +-
fs/xfs/scrub/rtbitmap_repair.c     |   56 +
fs/xfs/scrub/rtsummary.c           |  274 +++++
fs/xfs/scrub/rtsummary.h           |   14 +
fs/xfs/scrub/rtsummary_repair.c    |  169 +++
fs/xfs/scrub/scrub.c               |  147 ++-
fs/xfs/scrub/scrub.h               |   48 +-
fs/xfs/scrub/symlink.c             |   16 +-
fs/xfs/scrub/symlink_repair.c      |  452 ++++++++
fs/xfs/scrub/tempfile.c            |  815 ++++++++++++++
fs/xfs/scrub/tempfile.h            |   46 +
fs/xfs/scrub/tempswap.h            |   23 +
fs/xfs/scrub/trace.c               |   24 +-
fs/xfs/scrub/trace.h               | 2068 +++++++++++++++++++++++++++++++++++-
fs/xfs/scrub/xfarray.c             | 1108 +++++++++++++++++++
fs/xfs/scrub/xfarray.h             |  185 ++++
fs/xfs/scrub/xfblob.c              |  176 +++
fs/xfs/scrub/xfblob.h              |   27 +
fs/xfs/scrub/xfbtree.c             |  827 ++++++++++++++
fs/xfs/scrub/xfbtree.h             |   57 +
fs/xfs/scrub/xfile.c               |  702 ++++++++++++
fs/xfs/scrub/xfile.h               |  165 +++
fs/xfs/xfs_acl.c                   |    2 +
fs/xfs/xfs_aops.c                  |    5 +-
fs/xfs/xfs_attr_inactive.c         |    4 +
fs/xfs/xfs_attr_item.c             |    1 +
fs/xfs/xfs_attr_list.c             |   53 +-
fs/xfs/xfs_bmap_item.c             |   58 +-
fs/xfs/xfs_bmap_util.c             |  628 +----------
fs/xfs/xfs_bmap_util.h             |    3 -
fs/xfs/xfs_buf.c                   |  353 ++++--
fs/xfs/xfs_buf.h                   |  110 +-
fs/xfs/xfs_buf_xfile.c             |  270 +++++
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
fs/xfs/xfs_inode.c                 |  406 ++++++-
fs/xfs/xfs_inode.h                 |   70 +-
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
fs/xfs/xfs_swapext_item.h          |   56 +
fs/xfs/xfs_symlink.c               |  206 +---
fs/xfs/xfs_symlink.h               |    1 -
fs/xfs/xfs_sysctl.h                |    2 +
fs/xfs/xfs_sysfs.c                 |   54 +
fs/xfs/xfs_trace.c                 |    6 +
fs/xfs/xfs_trace.h                 |  752 +++++++++++--
fs/xfs/xfs_trans.c                 |   95 ++
fs/xfs/xfs_trans.h                 |    5 +
fs/xfs/xfs_trans_buf.c             |   42 +
fs/xfs/xfs_trans_dquot.c           |  158 ++-
fs/xfs/xfs_xattr.c                 |    8 +-
fs/xfs/xfs_xchgrange.c             | 1364 ++++++++++++++++++++++++
fs/xfs/xfs_xchgrange.h             |   56 +
include/linux/fs.h                 |    1 +
215 files changed, 37680 insertions(+), 2807 deletions(-)
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
