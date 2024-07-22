Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FC325763
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 09:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721639956; cv=none; b=MNXi4/jeelrpj51ALSzW2RACjYLMUuM6HqyWIPzeUZemluMbl06XShI1l01XsjI/sftZVdYhdon9PYqaBb5SPfHHCyS/EO1GTpN2iigcjpSQAAfwaNjYc4SWcyl/Xs2/lQonIuDNdyc9txrSP06QYDxKIYLuJ0rQuySDO/Kkjno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721639956; c=relaxed/simple;
	bh=XN4AD9hSxJuUYtarDNFID7qPSACBtZ48puH5KxhUSFQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Fpx/DtzfZZZrYTuMCu0uUeKEAQw2wCIDqKUgPewNbrX0/9fywNUTzFAvqjmvghln/duMhgdXAVkGyrQ0wbsbaE1gcWqXIltWzWi3dMSbGzzQgM/zWWa4lZ8iKCQ2uyIxE08pNyyBLqQsIl0kUZza5UjhoKr14VaEK28m1IJsBEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MobNHLtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MobNHLtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595E0C4AF0D
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 09:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721639956;
	bh=XN4AD9hSxJuUYtarDNFID7qPSACBtZ48puH5KxhUSFQ=;
	h=Date:From:To:Subject:From;
	b=MobNHLtB3pr0OZtwhJFSQDU66b73SLvNyONVyVlNTuJ/ffSJ+IrnxwykKfpE02ozc
	 Olyog3sYHO0nuaYZ2D9fDGV+vyESquCZymydCvqR7bwvjnjFEyXjDnNU8K3ZALeHPQ
	 tOV7ZRjBeUhIQQxgqMvF+cckXZ1NxK4AHtrJ+i9aM5QlDsH9SHhLFn6WCQIhe0TnqK
	 HYwp/8sOXlqukOo1511Feejn5fj0yTtOci6ddPga1ne4y5gAYjQgVcw3oeSR++4/Sq
	 vViDkdXCRI99da69VJD6Q/nrZmLujtarz/ehGrkeca50wE6eamVP+d5KNuvTmbndtm
	 ECdUa1QplGh9w==
Date: Mon, 22 Jul 2024 11:19:12 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs v6.9.0 released
Message-ID: <5b7byte6jzpdb7jwkt62iohdoilv3azivlezcagzh6fuplivuz@7y6ksphk3ium>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the master branch is commit:

42fc61ebd061ffc63a0302a8422ed21f67e38b5f

New commits:

Bastian Germann (1):
      [256c69312] xfs_io: make MADV_SOFT_OFFLINE conditional

Bill O'Donnell (4):
      [0e95efd2f] mkfs.xfs: avoid potential overflowing expression in xfs_mkfs.c
      [281cc2103] xfs_db: fix unitialized automatic struct ifake to 0.
      [7edddf34e] xfs_fsr: correct type in fsrprintf() call
      [b6ae0d862] xfs_repair: correct type of variable global_msgs.interval to time_t

Carlos Maiolino (11):
      [8c54844de] Merge tag 'libxfs-6.9-sync-prep_2024-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [6df6598b7] Merge tag 'libxfs-sync-6.9_2024-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [e9e234148] Merge tag 'bmap-intent-cleanups-6.9_2024-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [f985005f2] Merge tag 'realtime-bmap-intents-6.9_2024-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [ff80a1988] Merge tag 'spaceman-updates-6.9_2024-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [8af5a511a] Merge tag 'scrub-fixes-6.9_2024-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [08850db08] Merge tag 'repair-fixes-6.9_2024-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [bd4ea54f7] Merge tag 'repair-use-in-memory-btrees-6.9_2024-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [883afe0d6] Merge tag 'repair-refcount-scalability-6.9_2024-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [d59827b78] Merge tag 'mkfs-cleanups-6.9_2024-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [42fc61ebd] xfsprogs: Release v6.9.0

Christoph Hellwig (45):
      [d242dfc35] xfs: remove bc_ino.flags
      [601230d07] xfs: consolidate the xfs_alloc_lookup_* helpers
      [6f53a21f9] xfs: turn the allocbt cursor active field into a btree flag
      [6cb918e8b] xfs: move the btree stats offset into struct btree_ops
      [6a091d545] xfs: split out a btree type from the btree ops geometry flags
      [6aba4616e] xfs: split the per-btree union in struct xfs_btree_cur
      [054feadaa] xfs: move comment about two 2 keys per pointer in the rmap btree
      [579ae419f] xfs: add a xfs_btree_init_ptr_from_cur
      [be3ac9b04] xfs: don't override bc_ops for staging btrees
      [19223602e] xfs: fold xfs_allocbt_init_common into xfs_allocbt_init_cursor
      [5d31f1d6a] xfs: remove xfs_allocbt_stage_cursor
      [76578d674] xfs: fold xfs_inobt_init_common into xfs_inobt_init_cursor
      [ac8478e29] xfs: remove xfs_inobt_stage_cursor
      [77b3d809b] xfs: fold xfs_refcountbt_init_common into xfs_refcountbt_init_cursor
      [edc3afa06] xfs: remove xfs_refcountbt_stage_cursor
      [cb79dbfa6] xfs: fold xfs_rmapbt_init_common into xfs_rmapbt_init_cursor
      [521681e7a] xfs: remove xfs_rmapbt_stage_cursor
      [6536c4295] xfs: make full use of xfs_btree_stage_ifakeroot in xfs_bmbt_stage_cursor
      [ec6bbb1e8] xfs: fold xfs_bmbt_init_common into xfs_bmbt_init_cursor
      [23b5c6887] xfs: remove xfs_bmbt_stage_cursor
      [ea3d0c07d] xfs: split the agf_roots and agf_levels arrays
      [b85f26f62] xfs: add a name field to struct xfs_btree_ops
      [c95564630] xfs: add a sick_mask to struct xfs_btree_ops
      [a949c847e] xfs: split xfs_allocbt_init_cursor
      [47cdc8cb8] xfs: remove xfs_inobt_cur
      [d80c08e57] xfs: remove the btnum argument to xfs_inobt_count_blocks
      [9763e8904] xfs: split xfs_inobt_insert_sprec
      [7199f9848] xfs: split xfs_inobt_init_cursor
      [53430ebb1] xfs: pass a 'bool is_finobt' to xfs_inobt_insert
      [1c3eaac0d] xfs: remove xfs_btnum_t
      [a08765247] xfs: simplify xfs_btree_check_sblock_siblings
      [e3073cd78] xfs: simplify xfs_btree_check_lblock_siblings
      [29c1de284] xfs: open code xfs_btree_check_lptr in xfs_bmap_btree_to_extents
      [2e671ebed] xfs: consolidate btree ptr checking
      [978f7fd64] xfs: misc cleanups for __xfs_btree_check_sblock
      [244803ebe] xfs: remove the crc variable in __xfs_btree_check_lblock
      [694ce31a1] xfs: tighten up validation of root block in inode forks
      [a8b77935d] xfs: consolidate btree block verification
      [df73ffba2] xfs: rename btree helpers that depends on the block number representation
      [8fe547421] xfs: factor out a __xfs_btree_check_lblock_hdr helper
      [29cd94fa2] xfs: remove xfs_btree_reada_bufl
      [d2df92754] xfs: remove xfs_btree_reada_bufs
      [b4b20c27f] xfs: move and rename xfs_btree_read_bufl
      [0e94002ff] xfs: add a xfs_btree_ptrs_equal helper
      [b654d1551] libxfs: provide a kernel-compatible kasprintf

Darrick J. Wong (86):
      [e9add503e] libxfs: actually set m_fsname
      [73cdf0032] libxfs: clean up xfs_da_unmount usage
      [36da3ad5f] xfs: create a static name for the dot entry too
      [493d04e97] libfrog: create a new scrub group for things requiring full inode scans
      [415b61330] xfs: create a predicate to determine if two xfs_names are the same
      [453f3d4a3] xfs: create a macro for decoding ftypes in tracepoints
      [8e5f0af69] xfs: report the health of quota counts
      [f8dfc269d] xfs: implement live quotacheck inode scan
      [06748533d] xfs: report health of inode link counts
      [7b11e9aed] xfs: teach scrub to check file nlinks
      [cbe38cd7c] xfs: separate the marking of sick and checked metadata
      [a2c95f1da] xfs: report fs corruption errors to the health tracking system
      [ad6fabbe2] xfs: report ag header corruption errors to the health tracking system
      [6d5b5846d] xfs: report block map corruption errors to the health tracking system
      [e30bad414] xfs: report btree block corruption errors to the health system
      [bcf1c9673] xfs: report dir/attr block corruption errors to the health system
      [178287f40] xfs: report inode corruption errors to the health system
      [bb9be3f86] xfs: report realtime metadata corruption errors to the health system
      [4467a60ab] xfs: report XFS_IS_CORRUPT errors to the health system
      [4a3f1d827] xfs: add secondary and indirect classes to the health tracking system
      [2d182689b] xfs: remember sick inodes that get inactivated
      [81410363d] xfs: update health status if we get a clean bill of health
      [4f05dd7f1] xfs: consolidate btree block freeing tracepoints
      [600309797] xfs: consolidate btree block allocation tracepoints
      [c75cc5dc5] xfs: set the btree cursor bc_ops in xfs_btree_alloc_cursor
      [68e6ed00e] xfs: drop XFS_BTREE_CRC_BLOCKS
      [9fb37e158] xfs: encode the btree geometry flags in the btree ops structure
      [117783506] xfs: extern some btree ops structures
      [8016d20c0] xfs: initialize btree blocks using btree_ops structure
      [368e46c17] xfs: rename btree block/buffer init functions
      [a29b9f72e] xfs: btree convert xfs_btree_init_block to xfs_btree_init_buf calls
      [2ddc390d1] xfs: remove the unnecessary daddr paramter to _init_block
      [dc987eb38] xfs: set btree block buffer ops in _init_buf
      [9a155aeba] xfs: move lru refs to the btree ops structure
      [9fba69bb4] xfs: factor out a xfs_btree_owner helper
      [c3ba7ebde] xfs: factor out a btree block owner check
      [4584d1d9b] xfs: store the btree pointer length in struct xfs_btree_ops
      [e80dacd42] xfs: create predicate to determine if cursor is at inode root level
      [1ea0233c7] xfs: make staging file forks explicit
      [27d818454] libxfs: teach buftargs to maintain their own buffer hashtable
      [1cb2e3877] libxfs: add xfile support
      [d9bbcebf2] libxfs: partition memfd files to avoid using too many fds
      [b944a0534] xfs: teach buftargs to maintain their own buffer hashtable
      [124b388da] libxfs: support in-memory buffer cache targets
      [d466c8662] xfs: support in-memory btrees
      [daf937d6d] xfs: launder in-memory btree buffers before transaction commit
      [36a933348] xfs: create a helper to decide if a file mapping targets the rt volume
      [048c5321f] xfs: repair the rmapbt
      [9ff7cce74] xfs: create a shadow rmap btree during rmap repair
      [a2fd18b48] xfs: hook live rmap operations during a repair operation
      [588d02914] xfs: clean up bmap log intent item tracepoint callsites
      [9e471add0] xfs: move xfs_bmap_defer_add to xfs_bmap_item.c
      [c2be7e836] xfs: fix xfs_bunmapi to allow unmapping of partial rt extents
      [92ff59310] xfs: add a realtime flag to the bmap update log redo items
      [11900c013] xfs: support deferred bmap updates on the attr fork
      [409e07e51] xfs: xfs_bmap_finish_one should map unwritten extents properly
      [ce160fd93] xfs: move xfs_symlink_remote.c declarations to xfs_symlink_remote.h
      [28e8f78c5] xfs: move remote symlink target read function to libxfs
      [1928c0f71] xfs: move symlink target write function to libxfs
      [bb7854672] libxfs: remove kmem_alloc, kmem_zalloc, and kmem_free
      [9b2a3a3fe] libxfs: add a bi_entry helper
      [b97324b82] libxfs: reuse xfs_bmap_update_cancel_item
      [5afa31d92] xfs_spaceman: report the health of quota counts
      [5ac16998a] libxfs: add a xattr_entry helper
      [a552c62f5] libxfs: add a realtime flag to the bmap update log redo items
      [930669e55] xfs_scrub: implement live quotacheck inode scan
      [6de18ea1b] xfs_repair: convert regular rmap repair to use in-memory btrees
      [18f7a658d] xfs_scrub: check file link counts
      [0a89f4dcc] xfs_repair: verify on-disk rmap btrees with in-memory btree data
      [991d79e88] xfs_repair: define an in-memory btree for storing refcount bag info
      [3ae2c9487] xfs_scrub: update health status if we get a clean bill of health
      [2c8006e00] xfs_repair: compute refcount data from in-memory rmap btrees
      [6bea0d487] xfs_repair: create refcount bag
      [8fb4b4713] xfs_scrub: use multiple threads to run in-kernel metadata scrubs that scan inodes
      [017762cce] xfs_repair: log when buffers fail CRC checks even if we just recompute it
      [52eb64bd2] xfs_repair: reduce rmap bag memory usage when creating refcounts
      [cfba37e11] xfs_repair: port to the new refcount bag structure
      [60cf6755a] xfs_spaceman: report health of inode link counts
      [2025aa7a2] xfs_scrub: upload clean bills of health
      [842676ed9] xfs_repair: check num before bplist[num]
      [47307ecef] xfs_repair: remove the old rmap collection slabs
      [9a51e91a0] xfs_repair: remove the old bag implementation
      [caf4117df] xfs_io: fix gcc complaints about potentially uninitialized variables
      [f969dd586] xfs_io: print sysfs paths of mounted filesystems
      [d1f942f19] mkfs: use libxfs to create symlinks
      [7ccc7965e] xfs_repair: detect null buf passed to duration

Dave Chinner (10):
      [cdc4e34ca] xfs: convert kmem_zalloc() to kzalloc()
      [522339840] xfs: convert kmem_alloc() to kmalloc()
      [336b689ac] xfs: convert remaining kmem_free() to kfree()
      [c3bf5a1f3] xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS
      [a6cb3f669] xfs: use GFP_KERNEL in pure transaction contexts
      [cf5e9c9d3] xfs: clean up remaining GFP_NOFS users
      [2931f8389] xfs: use xfs_defer_alloc a bit more
      [4c8774532] xfs: xfs_btree_bload_prep_block() should use __GFP_NOFAIL
      [38e1c7117] xfs: shrink failure needs to hold AGI buffer
      [a5974a2d1] xfs: allow sunit mount option to repair bad primary sb stripe values

Eric Biggers (1):
      [7ea701ffc] xfs_io: fix mread with length 1 mod page size

Eric Sandeen (1):
      [b3821ed05] xfsprogs: remove platform_zero_range wrapper

Matthew Wilcox (Oracle) (1):
      [d3d1a2cb2] xfs: Replace xfs_isilocked with xfs_assert_ilocked

Pavel Reichl (1):
      [a3e126d55] xfs_db: Fix uninicialized error variable

Code Diffstat:

 VERSION                             |    2 +-
 configure.ac                        |    2 +-
 copy/xfs_copy.c                     |    4 +-
 db/agf.c                            |   28 +-
 db/bmap_inflate.c                   |   14 +-
 db/check.c                          |   14 +-
 db/freesp.c                         |    8 +-
 db/hash.c                           |    2 +-
 db/metadump.c                       |   12 +-
 debian/changelog                    |    6 +
 doc/CHANGES                         |   21 +
 fsr/xfs_fsr.c                       |    3 +-
 include/kmem.h                      |   18 +-
 include/libxfs.h                    |    7 +-
 include/linux.h                     |   18 -
 include/xfs_mount.h                 |    5 +
 include/xfs_trace.h                 |   17 +-
 include/xfs_trans.h                 |    1 +
 io/bulkstat.c                       |    4 +-
 io/fsuuid.c                         |   68 +++
 io/madvise.c                        |    5 +
 io/mmap.c                           |   20 +-
 io/scrub.c                          |    1 +
 libfrog/scrub.c                     |   15 +
 libfrog/scrub.h                     |    1 +
 libxfs/Makefile                     |    9 +-
 libxfs/buf_mem.c                    |  313 ++++++++++
 libxfs/buf_mem.h                    |   35 ++
 libxfs/defer_item.c                 |   79 ++-
 libxfs/defer_item.h                 |   13 +
 libxfs/init.c                       |   76 +--
 libxfs/kmem.c                       |   39 +-
 libxfs/libxfs_api_defs.h            |   33 ++
 libxfs/libxfs_io.h                  |   42 +-
 libxfs/libxfs_priv.h                |   19 +-
 libxfs/logitem.c                    |    2 +-
 libxfs/rdwr.c                       |   88 +--
 libxfs/trans.c                      |   40 ++
 libxfs/util.c                       |   10 +
 libxfs/xfile.c                      |  393 +++++++++++++
 libxfs/xfile.h                      |   34 ++
 libxfs/xfs_ag.c                     |   79 +--
 libxfs/xfs_ag.h                     |   18 +-
 libxfs/xfs_alloc.c                  |  258 +++++----
 libxfs/xfs_alloc_btree.c            |  191 ++++---
 libxfs/xfs_alloc_btree.h            |   10 +-
 libxfs/xfs_attr.c                   |    5 +-
 libxfs/xfs_attr_leaf.c              |   22 +-
 libxfs/xfs_attr_remote.c            |   37 +-
 libxfs/xfs_bmap.c                   |  365 ++++++++----
 libxfs/xfs_bmap.h                   |   19 +-
 libxfs/xfs_bmap_btree.c             |  152 ++---
 libxfs/xfs_bmap_btree.h             |    5 +-
 libxfs/xfs_btree.c                  | 1079 +++++++++++++++++++++--------------
 libxfs/xfs_btree.h                  |  274 ++++-----
 libxfs/xfs_btree_mem.c              |  346 +++++++++++
 libxfs/xfs_btree_mem.h              |   75 +++
 libxfs/xfs_btree_staging.c          |  133 +----
 libxfs/xfs_btree_staging.h          |   10 +-
 libxfs/xfs_da_btree.c               |   59 +-
 libxfs/xfs_da_format.h              |   11 +
 libxfs/xfs_defer.c                  |   25 +-
 libxfs/xfs_dir2.c                   |   59 +-
 libxfs/xfs_dir2.h                   |   13 +
 libxfs/xfs_dir2_block.c             |    8 +-
 libxfs/xfs_dir2_data.c              |    3 +
 libxfs/xfs_dir2_leaf.c              |    3 +
 libxfs/xfs_dir2_node.c              |    7 +
 libxfs/xfs_dir2_sf.c                |   16 +-
 libxfs/xfs_format.h                 |   21 +-
 libxfs/xfs_fs.h                     |    8 +-
 libxfs/xfs_health.h                 |   95 ++-
 libxfs/xfs_ialloc.c                 |  232 +++++---
 libxfs/xfs_ialloc_btree.c           |  155 +++--
 libxfs/xfs_ialloc_btree.h           |   11 +-
 libxfs/xfs_iext_tree.c              |   26 +-
 libxfs/xfs_inode_buf.c              |   12 +-
 libxfs/xfs_inode_fork.c             |   49 +-
 libxfs/xfs_inode_fork.h             |    1 +
 libxfs/xfs_log_format.h             |    4 +-
 libxfs/xfs_refcount.c               |   69 ++-
 libxfs/xfs_refcount_btree.c         |   78 +--
 libxfs/xfs_refcount_btree.h         |    2 -
 libxfs/xfs_rmap.c                   |  284 +++++++--
 libxfs/xfs_rmap.h                   |   31 +-
 libxfs/xfs_rmap_btree.c             |  232 ++++++--
 libxfs/xfs_rmap_btree.h             |    8 +-
 libxfs/xfs_rtbitmap.c               |   11 +-
 libxfs/xfs_sb.c                     |   42 +-
 libxfs/xfs_sb.h                     |    5 +-
 libxfs/xfs_shared.h                 |   67 ++-
 libxfs/xfs_symlink_remote.c         |  155 ++++-
 libxfs/xfs_symlink_remote.h         |   26 +
 libxfs/xfs_trans_inode.c            |    6 +-
 libxfs/xfs_types.h                  |   26 +-
 libxlog/xfs_log_recover.c           |   19 +-
 logprint/log_misc.c                 |    8 +-
 logprint/log_print_all.c            |    8 +-
 man/man2/ioctl_xfs_fsgeometry.2     |    3 +
 man/man2/ioctl_xfs_scrub_metadata.2 |   10 +
 man/man8/xfs_io.8                   |    7 +
 mkfs/proto.c                        |   72 +--
 mkfs/xfs_mkfs.c                     |   10 +-
 quota/quota.c                       |    2 +
 quota/quota.h                       |   20 +
 quota/util.c                        |   26 +
 repair/Makefile                     |    4 +
 repair/agbtree.c                    |   46 +-
 repair/agbtree.h                    |    1 +
 repair/attr_repair.c                |   15 +-
 repair/bmap_repair.c                |    8 +-
 repair/bulkload.c                   |    2 +-
 repair/da_util.c                    |   12 +-
 repair/dinode.c                     |    9 +-
 repair/dir2.c                       |   28 +-
 repair/phase4.c                     |   25 +-
 repair/phase5.c                     |   30 +-
 repair/phase6.c                     |    4 -
 repair/prefetch.c                   |   14 +-
 repair/prefetch.h                   |    1 +
 repair/progress.c                   |   16 +-
 repair/progress.h                   |    4 +-
 repair/rcbag.c                      |  371 ++++++++++++
 repair/rcbag.h                      |   32 ++
 repair/rcbag_btree.c                |  390 +++++++++++++
 repair/rcbag_btree.h                |   77 +++
 repair/rmap.c                       |  739 ++++++++++++++----------
 repair/rmap.h                       |   25 +-
 repair/scan.c                       |   25 +-
 repair/slab.c                       |  117 ----
 repair/slab.h                       |   19 -
 repair/xfs_repair.c                 |   59 +-
 scrub/phase1.c                      |   38 ++
 scrub/phase4.c                      |   17 +
 scrub/phase5.c                      |  144 ++++-
 scrub/repair.c                      |   18 +
 scrub/repair.h                      |    1 +
 scrub/scrub.c                       |   58 +-
 scrub/scrub.h                       |    4 +
 scrub/xfs_scrub.h                   |    1 +
 spaceman/health.c                   |    8 +
 141 files changed, 6456 insertions(+), 2550 deletions(-)
 create mode 100644 libxfs/buf_mem.c
 create mode 100644 libxfs/buf_mem.h
 create mode 100644 libxfs/defer_item.h
 create mode 100644 libxfs/xfile.c
 create mode 100644 libxfs/xfile.h
 create mode 100644 libxfs/xfs_btree_mem.c
 create mode 100644 libxfs/xfs_btree_mem.h
 create mode 100644 libxfs/xfs_symlink_remote.h
 create mode 100644 repair/rcbag.c
 create mode 100644 repair/rcbag.h
 create mode 100644 repair/rcbag_btree.c
 create mode 100644 repair/rcbag_btree.h
