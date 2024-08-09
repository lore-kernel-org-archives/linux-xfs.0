Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E1A1917F7
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 13:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723208521; cv=none; b=RAbBaW3dYTKQxZMDUjHbQMD9pq7yTMlk59CQwvQ4ThouYvAo/tXbAAX8VAR+00T8IAH7cbuRKpXCwg0B4/xwc7s5x2xWE1/V7eU9ZtTe7/r5hcRnChVSMXHAtpTZOhcJOBekZXrrvJ8txqkQ6KQxnFME5v1+F1Zn/1J7JL5flOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723208521; c=relaxed/simple;
	bh=XiMItzWDT+Spkq6keOdPYi78Wl36I+v1ld/cJjDi4oo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Nm9QpBEVXQY8HH3diS8qWEY5RUBjwL1e9gRHukrDs7Uvuq+urWs+5/UQOxQV7Wj2h1d14ph+iyh2L1fhu6Dnywg5Z6npeoNCeTUTsOOS6gw8orDPYJZ3H2o10ysVwjCuwl/EsewBZVJXhIXZORp9P3SOS8B3CRimxv4i6eT5nB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R3ceO0q/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R3ceO0q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E36C32782
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 13:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723208521;
	bh=XiMItzWDT+Spkq6keOdPYi78Wl36I+v1ld/cJjDi4oo=;
	h=Date:From:To:Subject:From;
	b=R3ceO0q/pPGcvqlcf9GS4RfOUZik5jF2DHIBRqq+J2AOBZWglIlOfIpNxjout9REv
	 lBUQ2qjk+dkNdmgoXBdRRoTA2yodJTzhdk9GhXqR6P/qTzAID8skFDIcg3CNAMU3bh
	 1acsdlpHFzLk8gIKkoj+/GGGW7QNOpE/If/gbz5HddWPAmRIDo/piN1rRLq9xE9GEO
	 KUXMaHLYLzuuFJFComvB+YNCre3BOhgnwQNuth4f07pCt/hEyYXfQa8Jp8grDyCWox
	 p85LbdmkvcDLsQsGglBtDzTdcB1lnHtXavk6RNyv6coMV4Hdm1FybRDBczEKfZtrAi
	 kfNwrMVKINMdg==
Date: Fri, 9 Aug 2024 15:01:57 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to ac1f1c2b2
Message-ID: <wbxrjr3ukro7ttx6znwxmupbsc5lyea56bpdbu736wnb2zxhap@xen4okng6rwz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

ac1f1c2b24dc7b1b769025e5b42f277fdfc57ac1

310 new commits:

Allison Henderson (18):
      [28fa72416] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
      [fbc92bd19] xfs: add parent pointer support to attribute code
      [1f15687aa] xfs: define parent pointer ondisk extended attribute format
      [564c22ccb] xfs: add parent pointer validator functions
      [22e2e5e5a] xfs: extend transaction reservations for parent attributes
      [4bba3a077] xfs: parent pointer attribute creation
      [530cb331c] xfs: add parent attributes to link
      [7d501bc89] xfs: add parent attributes to symlink
      [112c475cd] xfs: remove parent pointers in unlink
      [8b0afc59e] xfs: Add parent pointers to rename
      [7aa234805] xfs: don't return XFS_ATTR_PARENT attributes via listxattr
      [41cf5d033] xfs: pass the attr value to put_listent when possible
      [4e0128ac2] xfs: don't remove the attr fork when parent pointers are enabled
      [89a6faedb] xfs: add a incompat feature bit for parent pointers
      [36770bef6] xfs_io: Add i, n and f flags to parent command
      [6a3ecdaeb] xfs_logprint: decode parent pointers in ATTRI items fully
      [77b39b176] mkfs: Add parent pointers during protofile creation
      [b2677fa4f] mkfs: enable formatting with parent pointers

Carlos Maiolino (25):
      [cf11de780] Merge tag 'libxfs-6.9-fixes_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [57b814018] Merge tag 'libxfs-sync-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [19e60c10c] Merge tag 'atomic-file-updates-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [9a11b6777] Merge tag 'dirattr-validate-owners-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [abe789fb9] Merge tag 'inode-repair-improvements-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [0ab4613d3] Merge tag 'scrub-repair-fixes-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [80a327fc2] Merge tag 'scrub-better-repair-warnings-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [680c6f3a4] Merge tag 'scrub-repair-data-deps-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [e1d04345a] Merge tag 'scrub-object-tracking-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [aaf930f51] Merge tag 'scrub-repair-scheduling-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [8dfca6229] Merge tag 'scrub-detect-deceptive-extensions-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [3dab1af58] Merge tag 'scrub-fstrim-phase-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [cc4a2d4ee] Merge tag 'scrub-fstrim-minlen-freesp-histogram-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [aa9a4293b] Merge tag 'scrub-service-security-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [673f24ec8] Merge tag 'scrub-media-scan-service-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [97570c976] Merge tag 'scrub-all-improve-systemd-handling-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [7a3563ea8] Merge tag 'improve-attr-validation-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [00b2fff3f] Merge tag 'pptrs-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [edce07cc5] Merge tag 'scrub-pptrs-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [34052f31e] Merge tag 'repair-pptrs-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [faa07d835] Merge tag 'scrub-directory-tree-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [7df134231] Merge tag 'vectorized-scrub-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [0cc863935] Merge tag 'repair-fixes-6.10_2024-07-29' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [8b70d7a07] Merge tag 'autofsck-6.10_2024-08-08' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [ac1f1c2b2] Merge tag 'debian-autofsck-6.10_2024-08-08' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next

Chris Hofstaedtler (1):
      [91e361f12] [PATCH v3] Remove support for split-/usr installs

Christoph Hellwig (28):
      [1ac2403fe] libxfs: remove duplicate rtalloc declarations in libxfs.h
      [30aef7811] repair: btree blocks are never on the RT subvolume
      [5ee532ce1] xfs: make XFS_TRANS_LOWMODE match the other XFS_TRANS_ definitions
      [b402af256] xfs: refactor realtime inode locking
      [4bcaa9094] xfs: free RT extents after updating the bmap btree
      [28a151b9d] xfs: move RT inode locking out of __xfs_bunmapi
      [de959abb0] xfs: split xfs_mod_freecounter
      [497b0097b] xfs: reinstate RT support in xfs_bmapi_reserve_delalloc
      [15f2811c8] xfs: cleanup fdblock/frextent accounting in xfs_bmap_del_extent_delay
      [ac315eafc] xfs: support RT inodes in xfs_mod_delalloc
      [0eec27507] xfs: rework splitting of indirect block reservations
      [9336c2e00] xfs: stop the steal (of data blocks for RT indirect blocks)
      [f79cc2d67] xfs: check the flags earlier in xfs_attr_match
      [7ae5bcb23] xfs: factor out a xfs_dir_lookup_args helper
      [c201c18fa] xfs: factor out a xfs_dir_createname_args helper
      [b649719d5] xfs: factor out a xfs_dir_removename_args helper
      [fcdabef87] xfs: factor out a xfs_dir_replace_args helper
      [3cedb37ab] xfs: refactor dir format helpers
      [4372cf658] xfs: fix error returns from xfs_bmapi_write
      [06efd1488] xfs: remove the unusued tmp_logflags variable in xfs_bmapi_allocate
      [32b91c2a1] xfs: lift a xfs_valid_startblock into xfs_bmapi_allocate
      [ae85a9c8c] xfs: don't open code XFS_FILBLKS_MIN in xfs_bmapi_write
      [3c9133f8a] xfs: pass the actual offset and len to allocate to xfs_bmapi_allocate
      [c17f37e2c] xfs: remove the xfs_iext_peek_prev_extent call in xfs_bmapi_allocate
      [2c4e8ce71] xfs: fix xfs_bmap_add_extent_delay_real for partial conversions
      [884c87996] xfs: do not allocate the entire delalloc extent in xfs_bmapi_write
      [d0348eb2d] xfs: xfs_quota_unreserve_blkres can't fail
      [7163cfcd7] xfs: simplify iext overflow checking and upgrade

Darrick J. Wong (233):
      [6f28c3b30] xfs_repair: don't leak the rootdir inode when orphanage already exists
      [2dee3eb74] xfile: fix missing error unlock in xfile_fcb_find
      [fd841d7c9] xfs: pass xfs_buf lookup flags to xfs_*read_agi
      [a995c2d7f] xfs: constify xfs_bmap_is_written_extent
      [c352ca6fe] xfs: introduce new file range exchange ioctl
      [8f6bd3bae] xfs: create a incompat flag for atomic file mapping exchanges
      [6bd62a958] xfs: introduce a file mapping exchange log intent item
      [829a235cc] xfs: create deferred log items for file mapping exchanges
      [378be4d0f] xfs: add error injection to test file mapping exchange recovery
      [312142132] xfs: condense extended attributes after a mapping exchange operation
      [fd6e011de] xfs: condense directories after a mapping exchange operation
      [6898c1eb1] xfs: condense symbolic links after a mapping exchange operation
      [378e94fc5] xfs: make file range exchange support realtime files
      [74a284a99] xfs: capture inode generation numbers in the ondisk exchmaps log item
      [794f60a6c] xfile: fix missing error unlock in xfile_fcb_find
      [15fef3f23] xfs: enable logged file mapping exchange feature
      [b67a805cf] xfs_repair: don't leak the rootdir inode when orphanage already exists
      [0e232547f] xfs: add an explicit owner field to xfs_da_args
      [c6438c3e7] xfs_repair: don't crash on -vv
      [da833baeb] xfs: use the xfs_da_args owner field to set new dir/attr block owner
      [b0195029f] xfs: validate attr leaf buffer owners
      [257e726e0] xfs: validate attr remote value buffer owners
      [de04e826c] xfs: validate dabtree node buffer owners
      [17e0d66d9] xfs: validate directory leaf buffer owners
      [72386ff07] xfs: validate explicit directory data buffer owners
      [482abce57] xfs: validate explicit directory block buffer owners
      [92244687a] xfs: validate explicit directory free block owners
      [784d5b7c0] xfs: use atomic extent swapping to fix user file fork data
      [95dfa4b5f] xfs: repair extended attributes
      [7469e993b] xfs: expose xfs_bmap_local_to_extents for online repair
      [a73bb8801] xfs: pass the owner to xfs_symlink_write_target
      [8c7b1e955] xfs: check unused nlink fields in the ondisk inode
      [c9d6544ce] xfs: try to avoid allocating from sick inode clusters
      [7bde36b06] xfs: pin inodes that would otherwise overflow link count
      [894084264] xfs: remove XFS_DA_OP_REMOVE
      [31f958745] xfs: remove XFS_DA_OP_NOTIME
      [d55ab8351] xfs: remove xfs_da_args.attr_flags
      [8f07219cf] xfs: make attr removal an explicit operation
      [f6fbc4686] xfs: rearrange xfs_da_args a bit to use less space
      [f9bd947e1] xfs: attr fork iext must be loaded before calling xfs_attr_is_leaf
      [a62b7d05c] xfs: fix missing check for invalid attr flags
      [fc63a9f25] xfs: restructure xfs_attr_complete_op a bit
      [1bb90def4] xfs: use helpers to extract xattr op from opflags
      [07e3a4586] xfs: enforce one namespace per attribute
      [8c25f2285] xfs: rearrange xfs_attr_match parameters
      [f5e1d0d95] xfs: move xfs_attr_defer_add to xfs_attr_item.c
      [24d677a15] xfs: create a separate hashname function for extended attributes
      [963649523] xfs: allow xattr matching on name and value for parent pointers
      [2b73477cc] xfs: create attr log item opcodes and formats for parent pointers
      [8038116e1] xfs: record inode generation in xattr update log intent items
      [9f45ce92f] xfs: create a hashname function for parent pointers
      [63886a656] xfs: split out handle management helpers a bit
      [08626e30d] xfs: add parent pointer ioctls
      [86bd3beb9] xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
      [bd493b5b3] xfs: drop compatibility minimum log size computations for reflink
      [5398a67b1] xfs: enable parent pointers
      [055af989d] xfs: check dirents have parent pointers
      [ffe71f133] xfs: remove some boilerplate from xfs_attr_set
      [2e5f98e22] xfs: make the reserved block permission flag explicit in xfs_attr_set
      [b813c7e54] xfs: add raw parent pointer apis to support repair
      [1e6d0459b] xfs: remove pointless unlocked assertion
      [c7e819113] xfs: split xfs_bmap_add_attrfork into two pieces
      [5e6ede97e] xfs: actually rebuild the parent pointer xattrs
      [44ecd42fa] xfs: teach online scrub to find directory tree structure problems
      [1560c1bf2] xfs: report directory tree corruption in the health information
      [da229a1f3] xfs: introduce vectored scrub mode
      [f93fdf9f9] xfs: use unsigned ints for non-negative quantities in xfs_attr_remote.c
      [d30f0d3f3] xfs: turn XFS_ATTR3_RMT_BUF_SPACE into a function
      [a5ec4d59c] xfs: create a helper to compute the blockcount of a max sized remote value
      [1d5c15a98] xfs: minor cleanups of xfs_attr3_rmt_blocks
      [c8004ef52] xfs: fix xfs_init_attr_trans not handling explicit operation codes
      [8315de22c] xfs: allow symlinks with short remote targets
      [dec15751a] man: document the exchange-range ioctl
      [bacb88b42] man: document XFS_FSOP_GEOM_FLAGS_EXCHRANGE
      [520bbc7eb] xfs: restrict when we try to align cow fork delalloc to cowextsz hints
      [806c26589] libhandle: add support for bulkstat v5
      [d617d1f5d] xfs: allow unlinked symlinks and dirs with zero size
      [b49cdb6ff] libfrog: add support for exchange range ioctl family
      [7fbf8e036] xfs: fix direction in XFS_IOC_EXCHANGE_RANGE
      [a4bdbcab1] xfs_db: advertise exchange-range in the version command
      [fba219ed7] xfs_logprint: support dumping exchmaps log items
      [3aed066cf] xfs_fsr: convert to bulkstat v5 ioctls
      [63ea34b8f] xfs_fsr: skip the xattr/forkoff levering with the newer swapext implementations
      [8e0a58538] xfs_scrub: remove ALP_* flags namespace
      [8d5f0786c] xfs_io: create exchangerange command to test file range exchange ioctl
      [fc2e087ed] xfs_scrub: move repair functions to repair.c
      [dec7fcd80] libfrog: advertise exchange-range support
      [0dcb7155b] xfs_scrub: log when a repair was unnecessary
      [19a29755b] xfs_scrub: fix missing scrub coverage for broken inodes
      [7fea27240] xfs_repair: add exchange-range to file systems
      [a100cb413] libxfs: port the bumplink function from the kernel
      [c5a7b5500] xfs_scrub: require primary superblock repairs to complete before proceeding
      [0c022e4bb] xfs_scrub: collapse trivial superblock scrub helpers
      [39e346ba5] mkfs: add a formatting option for exchange-range
      [7e74984e6] xfs_{db,repair}: add an explicit owner field to xfs_da_args
      [ebf05a446] mkfs/repair: pin inodes that would otherwise overflow link count
      [4b959abc5] xfs_scrub: actually try to fix summary counters ahead of repairs
      [5f709be98] xfs_scrub: track repair items by principal, not by individual repairs
      [a18f915ce] xfs_scrub: use repair_item to direct repair activities
      [3eaa2f39f] xfs_scrub: remove action lists from phaseX code
      [a4059d8d4] xfs_scrub: get rid of trivial fs metadata scanner helpers
      [ca06c565d] xfs_scrub: remove scrub_metadata_file
      [f6b0923ab] xfs_scrub: split up the mustfix repairs and difficulty assessment functions
      [317d54ea7] xfs_scrub: boost the repair priority of dependencies of damaged items
      [1f43a5be9] xfs_scrub: add missing repair types to the mustfix and difficulty assessment
      [8ec1014d8] xfs_scrub: clean up repair_item_difficulty a little
      [83ffb5b45] xfs_scrub: start tracking scrub state in scrub_item
      [201a08250] xfs_scrub: any inconsistency in metadata should trigger difficulty warnings
      [98c23e977] xfs_scrub: check dependencies of a scrub type before repairing
      [fe1e792f6] xfs_scrub: remove enum check_outcome
      [5e3f991ab] xfs_scrub: warn about difficult repairs to rt and quota metadata
      [ab705daff] xfs_scrub: retry incomplete repairs
      [8b8ac3003] xfs_scrub: refactor scrub_meta_type out of existence
      [bf15d7766] xfs_scrub: enable users to bump information messages to warnings
      [81bfd0ad0] xfs_scrub: remove unused action_list fields
      [bd1b68a52] xfs_scrub: use proper UChar string iterators
      [bdd836c28] xfs_scrub: hoist code that removes ignorable characters
      [8aadd8e0d] xfs_scrub: add a couple of omitted invisible code points
      [dcfea337c] xfs_scrub: avoid potential UAF after freeing a duplicate name entry
      [1072863bf] xfs_scrub: guard against libicu returning negative buffer lengths
      [334024834] xfs_scrub: hoist non-rendering character predicate
      [d43362c78] xfs_scrub: store bad flags with the name entry
      [1c209c458] xfs_scrub: rename UNICRASH_ZERO_WIDTH to UNICRASH_INVISIBLE
      [8990a3d61] xfs_scrub: type-coerce the UNICRASH_* flags
      [278924835] libfrog: enhance ptvar to support initializer functions
      [c37b2f249] xfs_scrub: reduce size of struct name_entry
      [4f4d99615] xfs_scrub: improve thread scheduling repair items during phase 4
      [d066afd72] xfs_scrub: rename struct unicrash.normalizer
      [f48d1bf68] xfs_scrub: hoist repair retry loop to repair_item_class
      [d51fd6368] xfs_scrub: recheck entire metadata objects after corruption repairs
      [b71df4ca3] xfs_scrub: report deceptive file extensions
      [8dd67c8ec] xfs_scrub: hoist scrub retry loop to scrub_item_check_file
      [474ff27d4] xfs_scrub: try to repair space metadata before file metadata
      [044009f98] xfs_scrub: move FITRIM to phase 8
      [c7a71a26f] libfrog: hoist free space histogram code
      [cee0ae9a4] xfs_scrub: ignore phase 8 if the user disabled fstrim
      [993f187f1] libfrog: print wider columns for free space histogram
      [5935bcabe] xfs_scrub: collapse trim_filesystem
      [4032f2879] libfrog: print cdf of free space buckets
      [18104b318] xfs_scrub: allow auxiliary pathnames for sandboxing
      [5a2780124] xfs_scrub: fix the work estimation for phase 8
      [ce619e69f] xfs_scrub: don't close stdout when closing the progress bar
      [4b1ec6e0b] xfs_scrub.service: reduce background CPU usage to less than one core if possible
      [0dc0d5dca] xfs_scrub: report FITRIM errors properly
      [d4dcc156c] xfs_scrub: remove pointless spacemap.c arguments
      [f4481b55c] xfs_scrub: use dynamic users when running as a systemd service
      [232d3db16] xfs_scrub: don't call FITRIM after runtime errors
      [ea35fdea2] xfs_scrub: collect free space histograms during phase 7
      [0109639ee] xfs_scrub: tighten up the security on the background systemd service
      [746ee95b7] xfs_scrub: dump unicode points
      [5ccdd24dc] xfs_scrub: improve responsiveness while trimming the filesystem
      [34bed6054] xfs_scrub: tune fstrim minlen parameter based on free space histograms
      [958e3bf95] xfs_scrub_all: only use the xfs_scrub@ systemd services in service mode
      [dc332e467] xfs_scrub_all: remove journalctl background process
      [a290edcfa] xfs_scrub_all: encapsulate all the subprocess code in an object
      [e17a7b1fe] xfs_scrub_all: fail fast on masked units
      [45ec29cfb] xfs_scrub_all: support metadata+media scans of all filesystems
      [ea2713d43] xfs_scrub_all: encapsulate all the systemctl code in an object
      [588e0462e] xfs_scrub: automatic downgrades to dry-run mode in service mode
      [267ae610a] xfs_scrub_all: enable periodic file data scrubs automatically
      [965df861f] xfs_scrub_all: add CLI option for easier debugging
      [84e248f3e] xfs_scrub: add an optimization-only mode
      [9042fcc08] xfs_scrub_fail: tighten up the security on the background systemd service
      [465cff545] xfs_scrub_all: trigger automatic media scans once per month
      [6d831e770] xfs_scrub_all: convert systemctl calls to dbus
      [1bb554e3b] xfs_repair: check free space requirements before allowing upgrades
      [504113355] xfs_scrub_all: tighten up the security on the background systemd service
      [e040916f6] xfs_scrub_all: failure reporting for the xfs_scrub_all job
      [e46249ec0] xfs_scrub_all: implement retry and backoff for dbus calls
      [2c08c981c] libxfs: create attr log item opcodes and formats for parent pointers
      [6db2bc3d1] xfs_{db,repair}: implement new attr hash value function
      [9132000a5] xfs_logprint: dump new attr log item fields
      [a24294c25] man: document the XFS_IOC_GETPARENTS ioctl
      [540a0a039] libfrog: report parent pointers to userspace
      [56f6ba21e] libfrog: add parent pointer support code
      [17eceafcf] xfs_io: adapt parent command to new parent pointer ioctls
      [764d8cb86] xfs_spaceman: report file paths
      [9a8b09762] xfs_scrub: use parent pointers when possible to report file operations
      [9b5d1349c] xfs_scrub: use parent pointers to report lost file data
      [d5c47fe43] xfs_db: report parent pointers in version command
      [c120c7e6f] xfs_db: report parent bit on xattrs
      [04f06c287] xfs_db: report parent pointers embedded in xattrs
      [fde7ec73d] xfs_repair: enforce one namespace bit per extended attribute
      [295fde6d1] xfs_db: obfuscate dirent and parent pointer names consistently
      [2823d8ed9] xfs_repair: check for unknown flags in attr entries
      [28488a359] xfs_db: remove some boilerplate from xfs_attr_set
      [361af16fc] xfs_db: actually report errors from libxfs_attr_set
      [5d8b51bce] xfs_repair: junk parent pointer attributes when filesystem doesn't support them
      [1962f4e8e] libxfs: export attr3_leaf_hdr_from_disk via libxfs_api_defs.h
      [a0ea90f54] xfs_repair: add parent pointers when messing with /lost+found
      [34d3b1079] xfs_db: add a parents command to list the parents of a file
      [27e639005] xfs_repair: junk duplicate hashtab entries when processing sf dirents
      [e65a67fb4] xfs_db: make attr_set and attr_remove handle parent pointers
      [80763b467] xfs_repair: build a parent pointer index
      [7b3f2025b] xfs_db: add link and unlink expert commands
      [f043df1a0] xfs_repair: move the global dirent name store to a separate object
      [40a59ddd7] xfs_db: compute hashes of parent pointers
      [09c23caae] xfs_repair: deduplicate strings stored in string blob
      [30b4d5d66] libxfs: create new files with attr forks if necessary
      [6eb16ee46] xfs_repair: check parent pointers
      [7bc368927] xfs: create a blob array data structure
      [08e3280cb] xfs_repair: dump garbage parent pointer attributes
      [4b327cc2f] man2: update ioctl_xfs_scrub_metadata.2 for parent pointers
      [1845002e6] man: document vectored scrub mode
      [6ec22c1de] libfrog: support vectored scrub
      [cad03cc6d] xfs_io: support vectored scrub
      [627d5dbd4] xfs_scrub: split the scrub epilogue code into a separate function
      [352f9e462] xfs_scrub: split the repair epilogue code into a separate function
      [ddafc2f7f] libfrog: add directory tree structure scrubber to scrub library
      [c3827cdce] xfs_scrub: convert scrub and repair epilogues to use xfs_scrub_vec
      [9eea3288a] xfs_spaceman: report directory tree corruption in the health information
      [75e2c6556] xfs_scrub: vectorize scrub calls
      [1fe7d5ef7] xfs_scrub: fix erroring out of check_inode_names
      [d275548fd] xfs_scrub: vectorize repair calls
      [258d34543] xfs_repair: update ondisk parent pointer records
      [0300ffbae] xfs_scrub: detect and repair directory tree corruptions
      [a5ea24f0a] xfs_scrub: use scrub barriers to reduce kernel calls
      [7ea215189] xfs_repair: wipe ondisk parent pointers when there are none
      [5a30504f0] xfs_scrub: defer phase5 file scans if dirloop fails
      [df914edee] xfs_scrub: try spot repairs of metadata items to make scrub progress
      [5a43a0043] xfs_repair: allow symlinks with short remote targets
      [47aa17b5a] libfrog: support editing filesystem property sets
      [d194cb818] xfs_io: edit filesystem properties
      [9b4c9c608] xfs_db: improve getting and setting extended attributes
      [a1ae399a5] libxfs: hoist listxattr from xfs_repair
      [6215e8d35] libxfs: pass a transaction context through listxattr
      [dfcdf16cc] xfs_db: add a command to list xattrs
      [7c3bfb6fc] xfs_property: add a new tool to administer fs properties
      [ac69d5ab2] libfrog: define a autofsck filesystem property
      [9451b5ee0] xfs_scrub: allow sysadmin to control background scrubs
      [7da76e274] xfs_scrub: use the autofsck fsproperty to select mode
      [7fd2c79b3] mkfs: set autofsck filesystem property
      [45cc05558] debian: enable xfs_scrub_all systemd timer services by default

John Garry (1):
      [c72a686a6] xfs: Stop using __maybe_unused in xfs_alloc.c

Ritesh Harjani (IBM) (1):
      [03a887e40] xfs: Add cond_resched to block unmap range and reflink remap path

Wengang Wang (1):
      [0a0967ddc] xfs: make sure sb_fdblocks is non-negative

Zhang Yi (2):
      [7cd511c5e] xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional
      [44e4bdc65] xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset

Code Diffstat:

 configure.ac                                     |   21 -
 db/attr.c                                        |   35 +-
 db/attrset.c                                     |  690 ++++++++++-
 db/attrshort.c                                   |   27 +
 db/field.c                                       |   10 +
 db/field.h                                       |    3 +
 db/freesp.c                                      |   89 +-
 db/hash.c                                        |   44 +-
 db/iunlink.c                                     |    4 +-
 db/metadump.c                                    |  330 +++++-
 db/namei.c                                       |  725 +++++++++++-
 db/sb.c                                          |    4 +
 debian/Makefile                                  |    4 +-
 debian/control                                   |    2 +-
 debian/local/initramfs.hook                      |    2 +-
 debian/rules                                     |   10 +-
 fsck/Makefile                                    |    4 +-
 fsr/xfs_fsr.c                                    |  167 +--
 include/builddefs.in                             |    5 +-
 include/buildmacros                              |   20 +-
 include/handle.h                                 |    1 +
 include/jdm.h                                    |   23 +
 include/libxfs.h                                 |    7 +-
 include/xfs_inode.h                              |   22 +
 include/xfs_mount.h                              |    2 +
 include/xfs_trace.h                              |   15 +
 io/Makefile                                      |   52 +-
 io/exchrange.c                                   |  156 +++
 io/fsproperties.c                                |  365 ++++++
 io/init.c                                        |    2 +
 io/inject.c                                      |    1 +
 io/io.h                                          |    2 +
 io/parent.c                                      |  539 ++++-----
 io/scrub.c                                       |  332 +++++-
 io/xfs_property                                  |   77 ++
 libfrog/Makefile                                 |   13 +
 libfrog/file_exchange.c                          |   52 +
 libfrog/file_exchange.h                          |   15 +
 libfrog/fsgeom.c                                 |   43 +-
 libfrog/fsgeom.h                                 |    7 +
 libfrog/fsproperties.c                           |   77 ++
 libfrog/fsproperties.h                           |   66 ++
 libfrog/fsprops.c                                |  202 ++++
 libfrog/fsprops.h                                |   34 +
 libfrog/getparents.c                             |  355 ++++++
 libfrog/getparents.h                             |   42 +
 libfrog/histogram.c                              |  270 +++++
 libfrog/histogram.h                              |   77 ++
 libfrog/paths.c                                  |  168 +++
 libfrog/paths.h                                  |   25 +
 libfrog/ptvar.c                                  |    9 +-
 libfrog/ptvar.h                                  |    4 +-
 libfrog/scrub.c                                  |  143 +++
 libfrog/scrub.h                                  |   35 +
 libhandle/handle.c                               |    7 +-
 libhandle/jdm.c                                  |  117 ++
 libxfs/Makefile                                  |    9 +
 libxfs/defer_item.c                              |  156 +++
 libxfs/defer_item.h                              |   13 +
 libxfs/init.c                                    |    7 +
 libxfs/libxfs_api_defs.h                         |   32 +-
 libxfs/libxfs_priv.h                             |   75 +-
 libxfs/listxattr.c                               |  277 +++++
 libxfs/listxattr.h                               |   17 +
 libxfs/util.c                                    |   43 +-
 libxfs/xfblob.c                                  |  156 +++
 libxfs/xfblob.h                                  |   26 +
 libxfs/xfile.c                                   |   17 +-
 libxfs/xfile.h                                   |    1 +
 libxfs/xfs_ag.c                                  |   12 +-
 libxfs/xfs_ag_resv.c                             |   24 +-
 libxfs/xfs_ag_resv.h                             |    2 +-
 libxfs/xfs_alloc.c                               |   10 +-
 libxfs/xfs_attr.c                                |  274 +++--
 libxfs/xfs_attr.h                                |   49 +-
 libxfs/xfs_attr_leaf.c                           |  154 ++-
 libxfs/xfs_attr_leaf.h                           |    4 +-
 libxfs/xfs_attr_remote.c                         |  102 +-
 libxfs/xfs_attr_remote.h                         |    8 +-
 libxfs/xfs_attr_sf.h                             |    1 +
 libxfs/xfs_bmap.c                                |  409 ++++---
 libxfs/xfs_bmap.h                                |   13 +-
 libxfs/xfs_da_btree.c                            |  189 ++-
 libxfs/xfs_da_btree.h                            |   34 +-
 libxfs/xfs_da_format.h                           |   37 +-
 libxfs/xfs_defer.c                               |   12 +-
 libxfs/xfs_defer.h                               |   10 +-
 libxfs/xfs_dir2.c                                |  281 +++--
 libxfs/xfs_dir2.h                                |   23 +-
 libxfs/xfs_dir2_block.c                          |   42 +-
 libxfs/xfs_dir2_data.c                           |   18 +-
 libxfs/xfs_dir2_leaf.c                           |  100 +-
 libxfs/xfs_dir2_node.c                           |   44 +-
 libxfs/xfs_dir2_priv.h                           |   15 +-
 libxfs/xfs_errortag.h                            |    4 +-
 libxfs/xfs_exchmaps.c                            | 1232 ++++++++++++++++++++
 libxfs/xfs_exchmaps.h                            |  124 ++
 libxfs/xfs_format.h                              |   34 +-
 libxfs/xfs_fs.h                                  |  158 ++-
 libxfs/xfs_health.h                              |    4 +-
 libxfs/xfs_ialloc.c                              |   56 +-
 libxfs/xfs_ialloc.h                              |    5 +-
 libxfs/xfs_ialloc_btree.c                        |    4 +-
 libxfs/xfs_inode_buf.c                           |   55 +-
 libxfs/xfs_inode_fork.c                          |   57 +-
 libxfs/xfs_inode_fork.h                          |    6 +-
 libxfs/xfs_log_format.h                          |   89 +-
 libxfs/xfs_log_rlimit.c                          |   46 +
 libxfs/xfs_ondisk.h                              |    6 +
 libxfs/xfs_parent.c                              |  376 ++++++
 libxfs/xfs_parent.h                              |  110 ++
 libxfs/xfs_rtbitmap.c                            |   57 +
 libxfs/xfs_rtbitmap.h                            |   17 +
 libxfs/xfs_sb.c                                  |   15 +-
 libxfs/xfs_shared.h                              |    6 +-
 libxfs/xfs_symlink_remote.c                      |   54 +-
 libxfs/xfs_symlink_remote.h                      |    8 +-
 libxfs/xfs_trans_resv.c                          |  324 +++++-
 libxfs/xfs_trans_space.c                         |  121 ++
 libxfs/xfs_trans_space.h                         |   29 +-
 logprint/log_misc.c                              |   11 +
 logprint/log_print_all.c                         |   12 +
 logprint/log_redo.c                              |  345 +++++-
 logprint/logprint.h                              |   11 +-
 man/man2/ioctl_xfs_bulkstat.2                    |    3 +
 man/man2/ioctl_xfs_exchange_range.2              |  278 +++++
 man/man2/ioctl_xfs_fsbulkstat.2                  |    3 +
 man/man2/ioctl_xfs_fsgeometry.2                  |    3 +
 man/man2/ioctl_xfs_getparents.2                  |  212 ++++
 man/man2/ioctl_xfs_scrub_metadata.2              |   32 +-
 man/man2/ioctl_xfs_scrubv_metadata.2             |  171 +++
 man/man8/Makefile                                |    7 +-
 man/man8/mkfs.xfs.8.in                           |   13 +
 man/man8/xfs_admin.8                             |    7 +
 man/man8/xfs_db.8                                |  123 +-
 man/man8/xfs_io.8                                |  139 ++-
 man/man8/xfs_property.8                          |   69 ++
 man/man8/xfs_scrub.8                             |   94 +-
 man/man8/{xfs_scrub_all.8 => xfs_scrub_all.8.in} |   20 +-
 man/man8/xfs_spaceman.8                          |    7 +-
 mkfs/Makefile                                    |    4 +-
 mkfs/lts_4.19.conf                               |    5 +
 mkfs/lts_5.10.conf                               |    5 +
 mkfs/lts_5.15.conf                               |    5 +
 mkfs/lts_5.4.conf                                |    5 +
 mkfs/lts_6.1.conf                                |    5 +
 mkfs/lts_6.6.conf                                |    5 +
 mkfs/proto.c                                     |   69 +-
 mkfs/xfs_mkfs.c                                  |  193 +++-
 repair/Makefile                                  |    8 +-
 repair/attr_repair.c                             |   91 +-
 repair/dinode.c                                  |    5 +-
 repair/globals.c                                 |    1 +
 repair/globals.h                                 |    1 +
 repair/incore_ino.c                              |   14 +-
 repair/phase2.c                                  |  164 +++
 repair/phase6.c                                  |  176 ++-
 repair/pptr.c                                    | 1336 ++++++++++++++++++++++
 repair/pptr.h                                    |   17 +
 repair/progress.c                                |    2 +-
 repair/scan.c                                    |   21 +-
 repair/strblobs.c                                |  211 ++++
 repair/strblobs.h                                |   24 +
 repair/xfs_repair.c                              |   13 +-
 scrub/Makefile                                   |   30 +-
 scrub/common.c                                   |   43 +-
 scrub/counter.c                                  |    2 +-
 scrub/descr.c                                    |    2 +-
 scrub/phase1.c                                   |  137 ++-
 scrub/phase2.c                                   |  194 +++-
 scrub/phase3.c                                   |  259 +++--
 scrub/phase4.c                                   |  296 +++--
 scrub/phase5.c                                   |  292 ++++-
 scrub/phase6.c                                   |   75 +-
 scrub/phase7.c                                   |   59 +-
 scrub/phase8.c                                   |  232 ++++
 scrub/read_verify.c                              |    2 +-
 scrub/repair.c                                   |  948 ++++++++++++---
 scrub/repair.h                                   |  114 +-
 scrub/scrub.c                                    |  822 ++++++-------
 scrub/scrub.h                                    |  184 ++-
 scrub/scrub_private.h                            |  123 ++
 scrub/spacemap.c                                 |   11 +-
 scrub/system-xfs_scrub.slice                     |   30 +
 scrub/unicrash.c                                 |  532 +++++++--
 scrub/vfs.c                                      |   26 +-
 scrub/vfs.h                                      |    2 +-
 scrub/xfs_scrub.c                                |  144 ++-
 scrub/xfs_scrub.h                                |   36 +-
 scrub/xfs_scrub@.service.in                      |   97 +-
 scrub/xfs_scrub_all.cron.in                      |    2 +-
 scrub/xfs_scrub_all.in                           |  415 +++++--
 scrub/xfs_scrub_all.service.in                   |   71 +-
 scrub/xfs_scrub_all_fail.service.in              |   71 ++
 scrub/xfs_scrub_fail.in                          |   46 +-
 scrub/xfs_scrub_fail@.service.in                 |   61 +-
 scrub/xfs_scrub_media@.service.in                |  100 ++
 scrub/xfs_scrub_media_fail@.service.in           |   76 ++
 spaceman/Makefile                                |   16 +-
 spaceman/file.c                                  |    7 +
 spaceman/freesp.c                                |  101 +-
 spaceman/health.c                                |   57 +-
 spaceman/space.h                                 |    3 +
 203 files changed, 17933 insertions(+), 2971 deletions(-)
 create mode 100644 io/exchrange.c
 create mode 100644 io/fsproperties.c
 create mode 100755 io/xfs_property
 create mode 100644 libfrog/file_exchange.c
 create mode 100644 libfrog/file_exchange.h
 create mode 100644 libfrog/fsproperties.c
 create mode 100644 libfrog/fsproperties.h
 create mode 100644 libfrog/fsprops.c
 create mode 100644 libfrog/fsprops.h
 create mode 100644 libfrog/getparents.c
 create mode 100644 libfrog/getparents.h
 create mode 100644 libfrog/histogram.c
 create mode 100644 libfrog/histogram.h
 create mode 100644 libxfs/listxattr.c
 create mode 100644 libxfs/listxattr.h
 create mode 100644 libxfs/xfblob.c
 create mode 100644 libxfs/xfblob.h
 create mode 100644 libxfs/xfs_exchmaps.c
 create mode 100644 libxfs/xfs_exchmaps.h
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h
 create mode 100644 libxfs/xfs_trans_space.c
 create mode 100644 man/man2/ioctl_xfs_exchange_range.2
 create mode 100644 man/man2/ioctl_xfs_getparents.2
 create mode 100644 man/man2/ioctl_xfs_scrubv_metadata.2
 create mode 100644 man/man8/xfs_property.8
 rename man/man8/{xfs_scrub_all.8 => xfs_scrub_all.8.in} (59%)
 create mode 100644 repair/pptr.c
 create mode 100644 repair/pptr.h
 create mode 100644 repair/strblobs.c
 create mode 100644 repair/strblobs.h
 create mode 100644 scrub/phase8.c
 create mode 100644 scrub/scrub_private.h
 create mode 100644 scrub/system-xfs_scrub.slice
 create mode 100644 scrub/xfs_scrub_all_fail.service.in
 create mode 100644 scrub/xfs_scrub_media@.service.in
 create mode 100644 scrub/xfs_scrub_media_fail@.service.in
