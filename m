Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2090AC77B72
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 18:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjDKScF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 14:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjDKScE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 14:32:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF533BD
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 11:32:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AAB362AB3
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 18:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF3FC433EF;
        Tue, 11 Apr 2023 18:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681237920;
        bh=uL+hJFYYfq9dxqu5rP1kLeuF6MhYT7EMGb8aScRR3zw=;
        h=Date:From:To:Cc:Subject:From;
        b=XopLxlsod2i1HHIbnI+UnBWyRbgrcRdxQ3LeKdCgfxUDVAVveVgg3IaAFKKY1PVWm
         UHsNiCLhu1Bf7l7qpIv/IukvFAgbkvt1ZeL/8zPThRkJbZWZd9lQVBCplWSXCzGJNp
         1G8uAjMZ2DXPLWLRnCFIDGYkSgxe0+wKBkqeT2RR7z+QjI64ZtyAnLKJNiDtKYTC8R
         Mv9zhVXvgSBsKWNXG4Wxb597MVcsW38NwIEvBDF+/j/+Ka8OxrKSXsTG0egt4eFgjO
         5LLzR2Qm3pbTXwBDceZdBUtImyyE2gHMrDr7FIiVywjoPl9aMbhbE50fG+/z2sCv44
         FUceLJ6S3XI3A==
Date:   Tue, 11 Apr 2023 11:32:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE online fsck 2/2] xfs-linux: inode-repair-improvements
 updated to e1f4597ca7e7
Message-ID: <168123761864.4118338.5520569121826367529.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks (mostly Dave),

The inode-repair-improvements branch of the xfs-linux repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git

has just been updated for your review.  This is all the online repair
code, plus the new scrub functions that are enabled by infrastructure
originally built for repair.  This drop encompasses all of part 1 of
online repair and sets us up for merging parent pointers as part 2.

This code snapshot has been rebased against recent upstream, freshly
QA'd, and is ready for people to examine.  For veteran readers, the new
snapshot can be diffed against the previous snapshot; and for new
readers, this is a reasonable place to begin reading.  For the best
experience, it is recommended to pull this branch and walk the commits
instead of trying to read any patch deluge.  The only major changes here
are the last few patches, which pin inode link counts to avoid integer
overflows.

The new head of the inode-repair-improvements branch is commit:

e1f4597ca7e7 xfs: pin inodes that would otherwise overflow link count

184 new commits:

Darrick J. Wong (184):
[b85e22316e3d] xfs: cull repair code that will never get used
[6b6ea2fd1ff9] xfs: move the post-repair block reaping code to a separate file
[3bffd36edad6] xfs: only invalidate blocks if we're going to free them
[364372a9faf2] xfs: only allow reaping of per-AG blocks in xrep_reap_extents
[c70cd1e5277f] xfs: use deferred frees to reap old btree blocks
[ce74586e7fbd] xfs: rearrange xrep_reap_block to make future code flow easier
[de562a5b841f] xfs: ignore stale buffers when scanning the buffer cache
[f64f1273c20b] xfs: reap large AG metadata extents when possible
[015567445a0d] xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair
[cb873553eca8] xfs: force all buffers to be written during btree bulk load
[1adf084b2bd1] xfs: implement block reservation accounting for btrees we're staging
[a7a99e2c546f] xfs: log EFIs for all btree blocks being used to stage a btree
[3868e34580ee] xfs: add debug knobs to control btree bulk load slack factors
[6e74a8162b40] xfs: move btree bulkload record initialization to ->get_record implementations
[317ad1705c08] xfs: constrain dirty buffers while formatting a staged btree
[4416938d29cb] xfs: create a big array data structure
[f92c72b58953] xfs: enable sorting of xfile-backed arrays
[fb0aec84a864] xfs: convert xfarray insertion sort to heapsort using scratchpad memory
[c9e7678a1f4d] xfs: teach xfile to pass back direct-map pages to caller
[c494c9d7b630] xfs: speed up xfarray sort by sorting xfile page contents directly
[1df6f16bf49f] xfs: cache pages used for xfarray quicksort convergence
[83b25eeac93a] xfs: improve xfarray quicksort pivot
[a2470c767ee2] xfs: get our own reference to inodes that we want to scrub
[0e5b6f9c3cb8] xfs: wrap ilock/iunlock operations on sc->ip
[19d30a209ab8] xfs: move the realtime summary file scrubber to a separate source file
[6081309a932b] xfs: implement online scrubbing of rtsummary info
[0e7c32b1f76b] xfs: always rescan allegedly healthy per-ag metadata after repair
[b45f3739fdca] xfs: allow the user to cancel repairs before we start writing
[7dbdae2db4c2] xfs: don't complain about unfixed metadata when repairs were injected
[7b2b04981368] xfs: allow userspace to rebuild metadata structures
[ed9fff4dc093] xfs: clear pagf_agflreset when repairing the AGFL
[bcd45fc9f030] xfs: repair free space btrees
[c66598d4a477] xfs: rewrite xfs_icache_inode_is_allocated
[7aa5da53785e] xfs: repair inode btrees
[2ed3f95300bf] xfs: repair refcount btrees
[157229c5e853] xfs: disable online repair quota helpers when quota not enabled
[c92a55337ab9] xfs: try to attach dquots to files before repairing them
[6fc9307fb7ec] xfs: repair inode records
[25680e7ec420] xfs: zap broken inode forks
[cb2c5e4e2e52] xfs: abort directory parent scrub scans if we encounter a zapped directory
[5df8b85cfc01] xfs: repair obviously broken inode modes
[b90bacb85045] xfs: reintroduce reaping of file metadata blocks to xrep_reap_extents
[38ff38c0338a] xfs: repair inode fork block mapping data structures
[90050177b39c] xfs: refactor repair forcing tests into a repair.c helper
[f74b19d5c3c8] xfs: create a ranged query function for refcount btrees
[aa3d5019aee6] xfs: repair problems in CoW forks
[957b30b2bc93] xfs: repair the inode core and forks of a metadata inode
[33d6a3287d06] xfs: create a new inode fork block unmap helper
[7065de2a9896] xfs: online repair of realtime bitmaps
[6761bcaffbed] xfs: repair quotas
[45ff60f3c88f] xfs: speed up xfs_iwalk_adjust_start a little bit
[b81386010246] xfs: implement live inode scan for scrub
[33c153ae381f] xfs: allow scrub to hook metadata updates in other writers
[4dd00180ebba] xfs: allow blocking notifier chains with filesystem hooks
[2537c4d3484a] xfs: stagger the starting AG of scrub iscans to reduce contention
[08222a5f2a75] xfs: cache a bunch of inodes for repair scans
[e76ee033ddcf] xfs: report the health of quota counts
[a34a93a52832] xfs: implement live quotacheck inode scan
[ffd4b10d96df] xfs: track quota updates during live quotacheck
[389ec1c31010] xfs: repair cannot update the summary counters when logging quota flags
[8ed89106798e] xfs: repair dquots based on live quotacheck results
[5bfc4c521cff] xfs: report health of inode link counts
[1e6de26ae9be] xfs: teach scrub to check file nlinks
[d0b4af37a001] xfs: track directory entry updates during live nlinks fsck
[aef3a32b3339] xfs: teach repair to fix file nlinks
[75f9dfa670d2] xfs: separate the marking of sick and checked metadata
[bf6372f78987] xfs: report fs corruption errors to the health tracking system
[04b32a839f16] xfs: report ag header corruption errors to the health tracking system
[9bd8b50a5625] xfs: report block map corruption errors to the health tracking system
[4b0c5cdf27b9] xfs: report btree block corruption errors to the health system
[814267ac2344] xfs: report dir/attr block corruption errors to the health system
[04054958e3d8] xfs: report symlink block corruption errors to the health system
[838769ff9e0d] xfs: report inode corruption errors to the health system
[31e38b3aa92b] xfs: report quota block corruption errors to the health system
[6187b33db7ad] xfs: report realtime metadata corruption errors to the health system
[da43714963d8] xfs: report XFS_IS_CORRUPT errors to the health system
[4a6eb3916ff0] xfs: add secondary and indirect classes to the health tracking system
[1ddb0ef069d0] xfs: remember sick inodes that get inactivated
[1a9d04936260] xfs: update health status if we get a clean bill of health
[c3a0d1de4d54] xfs: stabilize fs summary counters for online fsck
[b87f7fc56cd5] xfs: remove XCHK_REAPING_DISABLED from scrub
[50abc60f6537] xfs: repair summary counters
[c8f3f4db6630] xfs: dump xfiles for debugging purposes
[63e200a169d9] xfs: teach buftargs to maintain their own buffer hashtable
[9bc69facab59] xfs: create buftarg helpers to abstract block_device operations
[7e313dc5cd0f] xfs: make GFP_ usage consistent when allocating buftargs
[10b4a6076fb4] xfs: support in-memory buffer cache targets
[b0a840353323] xfs: consolidate btree block freeing tracepoints
[38dafd065849] xfs: consolidate btree block allocation tracepoints
[db12f7502dcf] xfs: support in-memory btrees
[0116c0c4a6e2] xfs: connect in-memory btrees to xfiles
[e3411d975b46] xfs: create a helper to decide if a file mapping targets the rt volume
[77bdb46657dc] xfs: repair the rmapbt
[a5274d159672] xfs: create a shadow rmap btree during rmap repair
[c396c75a5455] xfs: hook live rmap operations during a repair operation
[1d4473143068] xfs: set the btree cursor bc_ops in xfs_btree_alloc_cursor
[73aef98dc312] xfs: encode the default bc_flags in the btree ops structure
[278eca2afd91] xfs: export some of the btree ops structures
[afb94d8d6f8d] xfs: initialize btree blocks using btree_ops structure
[6216e6afc65a] xfs: rename btree block/buffer init functions
[248b5f160478] xfs: btree convert xfs_btree_init_block to xfs_btree_init_buf calls
[37079831c99f] xfs: remove the unnecessary daddr paramter to _init_block
[31a833f3dce3] xfs: set btree block buffer ops in _init_buf
[cb9aac219bb4] xfs: remove unnecessary fields in xfbtree_config
[f60c597862f0] xfs: move lru refs to the btree ops structure
[7ea2388b3d0a] xfs: define an in-memory btree for storing refcount bag info during repairs
[922689f6c4d7] xfs: create refcount bag structure for btree repairs
[693a3a12c388] xfs: port refcount repair to the new refcount bag structure
[cafecbf9f597] xfs: split tracepoint classes for deferred items
[750587223ed5] xfs: clean up bmap log intent item tracepoint callsites
[8e3a8f7dc78c] xfs: remove xfs_trans_set_bmap_flags
[6273fe89ea90] xfs: fix xfs_bunmapi to allow unmapping of partial rt extents
[16254d885e33] xfs: hoist freeing of rt data fork extent mappings
[2a67b0b9472a] xfs: add a realtime flag to the bmap update log redo items
[6e58e6e2cfca] xfs: support recovering bmap intent items targetting realtime extents
[654debfe7474] xfs: support deferred bmap updates on the attr fork
[c4ac84ac3017] xfs: xfs_bmap_finish_one should map unwritten extents properly
[bfb0aeb3be89] xfs: move xfs_symlink_remote.c declarations to xfs_symlink_remote.h
[b9f12c104313] xfs: move remote symlink target read function to libxfs
[4fa9121a6f6f] xfs: move symlink target write function to libxfs
[32124a3e1a80] xfs: add a libxfs header file for staging new ioctls
[eb0531ec9925] xfs: introduce new file range exchange ioctl
[92678b0a2b3b] xfs: create a new helper to return a file's allocation unit
[24dac8bc3674] xfs: refactor non-power-of-two alignment checks
[2a82c652b832] xfs: parameterize all the incompat log feature helpers
[3f850f0cc0a6] xfs: create a log incompat flag for atomic extent swapping
[ce4572cdd826] xfs: introduce a swap-extent log intent item
[c7c5a16bdd82] xfs: create deferred log items for extent swapping
[071f31e7ddca] xfs: enable xlog users to toggle atomic extent swapping
[133600954440] xfs: bind the xfs-specific extent swape code to the vfs-generic file exchange code
[ecd6ec0a4551] xfs: add error injection to test swapext recovery
[85b416b7928f] xfs: port xfs_swap_extents_rmap to our new code
[56ff21e19e12] xfs: consolidate all of the xfs_swap_extent_forks code
[f5030b8b99a6] xfs: port xfs_swap_extent_forks to use xfs_swapext_req
[186754f33583] xfs: allow xfs_swap_range to use older extent swap algorithms
[5513712ac7cf] xfs: remove old swap extents implementation
[66246521a0b2] xfs: condense extended attributes after an atomic swap
[41b43dcce947] xfs: condense directories after an atomic swap
[86d37168b0a8] xfs: condense symbolic links after an atomic swap
[9be9f814741c] xfs: make atomic extent swapping support realtime files
[ab3f80cf2908] xfs: support non-power-of-two rtextsize with exchange-range
[6c347089405b] xfs: enable atomic swapext feature
[1d680ce31582] xfs: hide private inodes from bulkstat and handle functions
[c760509d788d] xfs: create temporary files and directories for online repair
[998fbe0b4c51] xfs: refactor stale buffer scanning for repairs
[8eb89edb2ed7] xfs: add the ability to reap entire inode forks
[956ef09f3245] xfs: support preallocating and copying content into temporary files
[7fa3ee5e0278] xfs: teach the tempfile to support atomic extent swapping
[1fa0e81b053a] xfs: online repair of realtime summaries
[37fddb49d97c] xfs: add an explicit owner field to xfs_da_args
[d907e45c291f] xfs: use the xfs_da_args owner field to set new dir/attr block owner
[d5118ab62c53] xfs: validate attr leaf buffer owners
[7de3f41a6688] xfs: validate attr remote value buffer owners
[041c77bd30e8] xfs: validate dabtree node buffer owners
[c20721dc9e4d] xfs: validate directory leaf buffer owners
[027cae5537ca] xfs: validate explicit directory data buffer owners
[aa55cc95adc7] xfs: validate explicit directory block buffer owners
[b58faabfc3cc] xfs: validate explicit directory free block owners
[07da922f5f93] xfs: create a blob array data structure
[dba8fc0aefc2] xfs: use atomic extent swapping to fix user file fork data
[bd96c279b1ec] xfs: repair extended attributes
[f0dcc15849e5] xfs: scrub should set preen if attr leaf has holes
[0cc1d06aeefd] xfs: flag empty xattr leaf blocks for optimization
[20ada7c39291] xfs: use i_prev_unlinked to distinguish inodes that are not on the unlinked list
[bf1fbde7baea] xfs: ensure unlinked list state is consistent with nlink during scrub
[fc381da4050b] xfs: update the unlinked list when repairing link counts
[5288faa2b319] xfs: online repair of directories
[7c480f4a3f4b] xfs: scan the filesystem to repair a directory dotdot entry
[0823e6d16ebc] xfs: online repair of parent pointers
[8fb91b80cea2] xfs: ask the dentry cache if it knows the parent of a directory
[27e315f2ce2a] xfs: move orphan files to the orphanage
[857aaf90fe32] xfs: move files to orphanage instead of letting nlinks drop to zero
[92562d234c5d] xfs: ensure dentry consistency when the orphanage adopts a file
[1f0d8c391112] xfs: online repair of symbolic links
[4caa8d7f112d] xfs: create an xattr iteration function for scrub
[1363447d741e] xfs: check AGI unlinked inode buckets
[3c13a0e8bb33] xfs: hoist AGI repair context to a heap object
[1b1cedf6888c] xfs: repair AGI unlinked inode bucket lists
[7942ac3f0fdd] xfs: map xfile pages directly into xfs_buf
[a4a8220ee018] xfs: use b_offset to support direct-mapping pages when blocksize < pagesize
[1f0a88ec8648] xfile: implement write caching
[e91ac6dfa137] xfs: check unused nlink fields in the ondisk inode
[a17ad65671c8] xfs: try to avoid allocating from sick inode clusters
[e1f4597ca7e7] xfs: pin inodes that would otherwise overflow link count

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
fs/xfs/libxfs/xfs_format.h         |   24 +-
fs/xfs/libxfs/xfs_fs.h             |   16 +-
fs/xfs/libxfs/xfs_fs_staging.h     |  105 ++
fs/xfs/libxfs/xfs_health.h         |   86 +-
fs/xfs/libxfs/xfs_ialloc.c         |  138 ++-
fs/xfs/libxfs/xfs_ialloc.h         |    3 +
fs/xfs/libxfs/xfs_ialloc_btree.c   |   19 +-
fs/xfs/libxfs/xfs_iext_tree.c      |   23 +-
fs/xfs/libxfs/xfs_inode_buf.c      |   20 +-
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
fs/xfs/scrub/inode_repair.c        | 1643 ++++++++++++++++++++++++++++
fs/xfs/scrub/iscan.c               |  678 ++++++++++++
fs/xfs/scrub/iscan.h               |   78 ++
fs/xfs/scrub/listxattr.c           |  309 ++++++
fs/xfs/scrub/listxattr.h           |   17 +
fs/xfs/scrub/newbt.c               |  662 ++++++++++++
fs/xfs/scrub/newbt.h               |   79 ++
fs/xfs/scrub/nlinks.c              | 1005 ++++++++++++++++++
fs/xfs/scrub/nlinks.h              |  105 ++
fs/xfs/scrub/nlinks_repair.c       |  455 ++++++++
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
fs/xfs/scrub/repair.c              |  969 +++++++++++------
fs/xfs/scrub/repair.h              |  180 +++-
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
fs/xfs/xfs_file.c                  |   43 +-
fs/xfs/xfs_globals.c               |   12 +
fs/xfs/xfs_health.c                |  202 +++-
fs/xfs/xfs_hooks.c                 |   94 ++
fs/xfs/xfs_hooks.h                 |   72 ++
fs/xfs/xfs_icache.c                |  138 ++-
fs/xfs/xfs_inode.c                 |  441 +++++++-
fs/xfs/xfs_inode.h                 |   72 +-
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
215 files changed, 37887 insertions(+), 2827 deletions(-)
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
