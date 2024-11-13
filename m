Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C877C1C9EC2
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 09:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731489312; cv=none; b=jETRvVeJDymjKOgU9BIfiNJzXtqRGeqLHddgHEysZylDhY+2wa870TPPomqvcp/jFouPs0tArLnUfhv8vfhm/nPGbRU9zaqhqj3x7zfnSTCZ2q0MfzGgmCZ9ZCDjV64I3FzhK7MjokuTWpLH/jlG3GwKT4244AcawMbFlbR0gsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731489312; c=relaxed/simple;
	bh=bkmrAXS+7HC31jSbPMQqkm9/z1VDo0aAchthSbxJzp4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FcDW8OcFNPtdjZNwQzOkJbtBhRaVJbsdeqw2ylnNxAO5r+vAEhilhqZ57BJszPt4/I55Yb0LvzWfAyA5nE0qXKIBOgKw0cp5Rx2G34f1po8KERzE8qFAdwbDENUOLLRUNKUOZwe7lC54ByyXQyK1bh7x0L9hk5C5KdWbTKS1F+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dw3T6wtq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dw3T6wtq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E761C4CED0
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 09:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731489312;
	bh=bkmrAXS+7HC31jSbPMQqkm9/z1VDo0aAchthSbxJzp4=;
	h=Date:From:To:Subject:From;
	b=Dw3T6wtqAMWDPVQRU6ByvFl5HJxEG8u54dWejiM6pgY5fmlAr9zSErZ7+3e9mckfK
	 nqnrctd2UVDSmhMYQe7MXAhkGClkVBe84Cref+mISSK6PrfiEBgnwMR1svZ3QE6ZI5
	 X2z2kzGA1OLBrBnantx5xGa1EE8/pK6iZbpCTcnnXO7VbKjnfCMSB1UjQ2po2UbLOW
	 yWFmK6LP9s2eLGoIvOC+C3mlbvKr+IlwFYW388Ic/Ev95BeHDzlZ+mE3dtvGfpuCrs
	 gCcZcUH13vpprLlw4v1Fcc2hWQmg64B4HrIesl/YxCZ1Fo6y47KaCitU+h2yDfzXec
	 f6UIO9+e0G5kw==
Date: Wed, 13 Nov 2024 10:15:07 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 5877dc24be5d
Message-ID: <grsskitl3kmvdjhyntyxpxpmjwe26ilgmqptwfgdwjz6z6crhe@o4s5naa3j6iy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

5877dc24be5d Merge tag 'better-ondisk-6.13_2024-11-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into staging-merge

156 new commits:

Carlos Maiolino (10):
      [131ffe5e695a] Merge tag 'perag-xarray-6.13_2024-11-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into staging-merge
      [28cf0d1a34b2] Merge tag 'generic-groups-6.13_2024-11-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into staging-merge
      [d7a5b69bf07e] Merge tag 'metadata-directory-tree-6.13_2024-11-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into staging-merge
      [6b3582aca371] Merge tag 'incore-rtgroups-6.13_2024-11-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into staging-merge
      [cb288c9fb2ab] Merge tag 'rtgroups-prep-6.13_2024-11-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into staging-merge
      [b939bcdca375] Merge tag 'realtime-groups-6.13_2024-11-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into staging-merge
      [93c0f79edf1c] Merge tag 'metadir-quotas-6.13_2024-11-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into staging-merge
      [8ca118e17a61] Merge tag 'realtime-quotas-6.13_2024-11-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into staging-merge
      [052378aef8b9] Merge tag 'metadir-6.13_2024-11-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into staging-merge
      [5877dc24be5d] Merge tag 'better-ondisk-6.13_2024-11-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into staging-merge

Christoph Hellwig (60):
      [792ef2745d12] xfs: simplify sector number calculation in xfs_zero_extent
      [1171de329692] xfs: split the page fault trace event
      [1eb6fc044752] xfs: split write fault handling out of __xfs_filemap_fault
      [a7fd3327d3ba] xfs: remove __xfs_filemap_fault
      [fe4e0faac931] xfs: remove xfs_page_mkwrite_iomap_ops
      [cd8ae42a82d2] xfs: fix superfluous clearing of info->low in __xfs_getfsmap_datadev
      [4e071d79e477] xfs: remove the unused pagb_count field in struct xfs_perag
      [9943b4573290] xfs: remove the unused pag_active_wq field in struct xfs_perag
      [67ce5ba57535] xfs: pass a pag to xfs_difree_inode_chunk
      [db129fa01113] xfs: remove the agno argument to xfs_free_ag_extent
      [856a920ac2bb] xfs: add xfs_agbno_to_fsb and xfs_agbno_to_daddr helpers
      [6abd82ab6ea4] xfs: add a xfs_agino_to_ino helper
      [b6dc8c6dd2d3] xfs: pass a pag to xfs_extent_busy_{search,reuse}
      [4a137e09151e] xfs: keep a reference to the pag for busy extents
      [8dcf5e617f0e] xfs: remove the mount field from struct xfs_busy_extents
      [c896fb44f6ee] xfs: remove the unused trace_xfs_iwalk_ag trace point
      [3c39444939da] xfs: remove the unused xrep_bmap_walk_rmap trace point
      [2337ac79e933] xfs: constify pag arguments to trace points
      [835ddb592fab] xfs: pass a perag structure to the xfs_ag_resv_init_error trace point
      [487092ceaa72] xfs: pass objects to the xfs_irec_merge_{pre,post} trace points
      [1209d360eb7a] xfs: pass the iunlink item to the xfs_iunlink_update_dinode trace point
      [618a27a94d06] xfs: pass objects to the xrep_ibt_walk_rmap tracepoint
      [934dde65b202] xfs: pass the pag to the trace_xrep_calc_ag_resblks{,_btsize} trace points
      [dc8df7e3826e] xfs: pass the pag to the xrep_newbt_extent_class tracepoints
      [0a4d79741d6f] xfs: factor out a xfs_iwalk_args helper
      [c4ae021bcb6b] xfs: convert remaining trace points to pass pag structures
      [e9c4d8bfb26c] xfs: factor out a generic xfs_group structure
      [201c5fa342af] xfs: split xfs_initialize_perag
      [819928770bd9] xfs: add a xfs_group_next_range helper
      [d66496578b2a] xfs: insert the pag structures into the xarray later
      [86437e6abbd2] xfs: switch perag iteration from the for_each macros to a while based iterator
      [5c8483cec3fe] xfs: move metadata health tracking to the generic group structure
      [2ed27a546415] xfs: mark xfs_perag_intent_{hold,rele} static
      [34cf3a6f3952] xfs: move draining of deferred operations to the generic group structure
      [eb4a84a3c2bd] xfs: move the online repair rmap hooks to the generic group structure
      [6af1300d47d9] xfs: return the busy generation from xfs_extent_busy_list_empty
      [0e10cb98f149] xfs: convert extent busy tracepoints to the generic group structure
      [adbc76aa0fed] xfs: convert busy extent tracking to the generic group structure
      [77a530e6c49d] xfs: add a generic group pointer to the btree cursor
      [198febb9fe65] xfs: store a generic xfs_group pointer in xfs_getfsmap_info
      [759cc1989a53] xfs: add group based bno conversion helpers
      [ba102a682d93] xfs: remove xfs_group_intent_hold and xfs_group_intent_rele
      [e5e5cae05b71] xfs: store a generic group structure in the intents
      [dcfc65befb76] xfs: clean up xfs_getfsmap_helper arguments
      [9c3cfb9c96ee] xfs: add a xfs_bmap_free_rtblocks helper
      [cd8d0490825c] xfs: add a xfs_qm_unmount_rt helper
      [9154b5008c03] xfs: factor out a xfs_growfs_rt_alloc_blocks helper
      [d6d5c90adacc] xfs: cleanup xfs_getfsmap_rtdev_rtbitmap
      [c8edf1cbef7e] xfs: split xfs_trim_rtdev_extents
      [e3088ae2dcae] xfs: move RT bitmap and summary information to the rtgroup
      [ae897e0bed0f] xfs: support creating per-RTG files in growfs
      [cb9cd6e56e48] xfs: calculate RT bitmap and summary blocks based on sb_rextents
      [fc233f1fb058] xfs: use xfs_growfs_rt_alloc_fake_mount in xfs_growfs_rt_alloc_blocks
      [bde86b42d282] xfs: factor out a xfs_growfs_check_rtgeom helper
      [5a7566c8d6b9] xfs: refactor xfs_rtbitmap_blockcount
      [f8c5a8415f6e] xfs: refactor xfs_rtsummary_blockcount
      [f220f6da5f4a] xfs: make RT extent numbers relative to the rtgroup
      [64c58d7c9934] iomap: add a merge boundary flag
      [8458c4944e10] xfs: add a helper to prevent bmap merges across rtgroup boundaries
      [d162491c5459] xfs: make the RT allocator rtgroup aware

Darrick J. Wong (84):
      [62027820eb44] xfs: fix simplify extent lookup in xfs_can_free_eofblocks
      [8d939f4bd7b2] xfs: constify the xfs_sb predicates
      [fdf5703b6110] xfs: constify the xfs_inode predicates
      [4d272929a525] xfs: rename metadata inode predicates
      [ecc8065dfa18] xfs: standardize EXPERIMENTAL warning generation
      [4f3d4dd1b04b] xfs: define the on-disk format for the metadir feature
      [dcf606914334] xfs: iget for metadata inodes
      [c555dd9b8c2d] xfs: load metadata directory root at mount time
      [7297fd0bebbd] xfs: enforce metadata inode flag
      [5d9b54a4ef34] xfs: read and write metadata inode directory tree
      [8651b410ae78] xfs: disable the agi rotor for metadata inodes
      [bb6cdd5529ff] xfs: hide metadata inodes from everyone because they are special
      [688828d8f8cd] xfs: advertise metadata directory feature
      [df866c538ff0] xfs: allow bulkstat to return metadata directories
      [382e275f0e8d] xfs: don't count metadata directory files to quota
      [cc0cf84aa7fe] xfs: mark quota inodes as metadata files
      [61b6bdb30a4b] xfs: adjust xfs_bmap_add_attrfork for metadir
      [be42fc1393d6] xfs: record health problems with the metadata directory
      [679b098b59cf] xfs: refactor directory tree root predicates
      [13af229ee0dc] xfs: do not count metadata directory files when doing online quotacheck
      [91fb4232be87] xfs: metadata files can have xattrs if metadir is enabled
      [aec2eb7da8f7] xfs: adjust parent pointer scrubber for sb-rooted metadata files
      [5dab2daa8aa1] xfs: fix di_metatype field of inodes that won't load
      [3d2c34111144] xfs: scrub metadata directories
      [dcde94bdeeb9] xfs: check the metadata directory inumber in superblocks
      [9dc31acb01a1] xfs: move repair temporary files to the metadata directory tree
      [b3c03efa5972] xfs: check metadata directory file path connectivity
      [87b7c205da8a] xfs: confirm dotdot target before replacing it during a repair
      [87fe4c34a383] xfs: create incore realtime group structures
      [0e4875b3fb24] xfs: define locking primitives for realtime groups
      [c29237a65c8d] xfs: add a lockdep class key for rtgroup inodes
      [65b1231b8cea] xfs: support caching rtgroup metadata inodes
      [0d2c636e489c] xfs: repair metadata directory file path connectivity
      [cd5b26f0c099] xfs: add rtgroup-based realtime scrubbing context management
      [c1442d22a02a] xfs: remove XFS_ILOCK_RT*
      [1029f08dc539] xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
      [dca94251f617] xfs: fix rt device offset calculations for FITRIM
      [96768e91511b] xfs: define the format of rt groups
      [18618e7100dd] xfs: check the realtime superblock at mount time
      [76d3be00df91] xfs: update realtime super every time we update the primary fs super
      [8edde94d6401] xfs: export realtime group geometry via XFS_FSOP_GEOM
      [9bb512734722] xfs: check that rtblock extents do not break rtsupers or rtgroups
      [35537f25d236] xfs: add frextents to the lazysbcounters when rtgroups enabled
      [21e62bddf0ef] xfs: convert sick_map loops to use ARRAY_SIZE
      [ab7bd650e17a] xfs: record rt group metadata errors in the health system
      [3fa7a6d0c7eb] xfs: export the geometry of realtime groups to userspace
      [118895aa9513] xfs: add block headers to realtime bitmap and summary blocks
      [eba42c2c53c8] xfs: encode the rtbitmap in big endian format
      [a2c28367396a] xfs: encode the rtsummary in big endian format
      [ee321351487a] xfs: grow the realtime section when realtime groups are enabled
      [e464d8e8bb02] xfs: store rtgroup information with a bmap intent
      [b57283e1a0e9] xfs: force swapext to a realtime file to use the file content exchange ioctl
      [4c8900bbf106] xfs: support logging EFIs for realtime extents
      [fc91d9430e5d] xfs: support error injection when freeing rt extents
      [44e69c9af159] xfs: use realtime EFI to free extents when rtgroups are enabled
      [b91afef72471] xfs: don't merge ioends across RTGs
      [7333c948c2bc] xfs: don't coalesce file mappings that cross rtgroup boundaries in scrub
      [3f1bdf50ab1b] xfs: scrub the realtime group superblock
      [1433f8f9cead] xfs: repair realtime group superblock
      [a74923333d9c] xfs: scrub metadir paths for rtgroup metadata
      [ea99122b18ca] xfs: mask off the rtbitmap and summary inodes when metadir in use
      [fd7588fa6475] xfs: create helpers to deal with rounding xfs_fileoff_t to rtx boundaries
      [3f0205ebe71f] xfs: create helpers to deal with rounding xfs_filblks_t to rtx boundaries
      [7195f240c657] xfs: make xfs_rtblock_t a segmented address like xfs_fsblock_t
      [ceaa0bd773e2] xfs: adjust min_block usage in xfs_verify_agbno
      [e0b5b97dde8e] xfs: move the min and max group block numbers to xfs_group
      [0c271d906ebc] xfs: port the perag discard code to handle generic groups
      [7e85fc239411] xfs: implement busy extent tracking for rtgroups
      [a3315d11305f] xfs: use rtgroup busy extent list for FITRIM
      [fc23a426ce6e] xfs: refactor xfs_qm_destroy_quotainos
      [e80fbe1ad8ef] xfs: use metadir for quota inodes
      [b28564cae1e4] xfs: fix chown with rt quota
      [128a055291eb] xfs: scrub quota file metapaths
      [184c619f5543] xfs: advertise realtime quota support in the xqm stat files
      [d5d9dd5b3026] xfs: persist quota flags with metadir
      [9a17ebfea9d0] xfs: report realtime block quota limits on realtime directories
      [5dd70852b039] xfs: create quota preallocation watermarks for realtime quota
      [b7020ba86acc] xfs: reserve quota for realtime files correctly
      [28d756d4d562] xfs: update sb field checks when metadir is turned on
      [edc038f7f386] xfs: enable realtime quota again
      [ea079efd365e] xfs: enable metadata directory feature
      [89b38282d1b0] xfs: convert struct typedefs in xfs_ondisk.h
      [131a883fffb1] xfs: separate space btree structures in xfs_ondisk.h
      [13877bc79d81] xfs: port ondisk structure checks from xfs/122 to the kernel

Dave Chinner (1):
      [59e43f5479cc] xfs: sb_spino_align is not verified

Long Li (1):
      [8b9b261594d8] xfs: remove the redundant xfs_alloc_log_agf

Code Diffstat:

 fs/iomap/buffered-io.c             |    6 +
 fs/xfs/Makefile                    |    8 +-
 fs/xfs/libxfs/xfs_ag.c             |  256 ++++-----
 fs/xfs/libxfs/xfs_ag.h             |  205 ++++----
 fs/xfs/libxfs/xfs_ag_resv.c        |   22 +-
 fs/xfs/libxfs/xfs_alloc.c          |  119 +++--
 fs/xfs/libxfs/xfs_alloc.h          |   19 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |   30 +-
 fs/xfs/libxfs/xfs_attr.c           |    5 +-
 fs/xfs/libxfs/xfs_bmap.c           |  137 +++--
 fs/xfs/libxfs/xfs_bmap.h           |    2 +-
 fs/xfs/libxfs/xfs_btree.c          |   38 +-
 fs/xfs/libxfs/xfs_btree.h          |    3 +-
 fs/xfs/libxfs/xfs_btree_mem.c      |    6 +-
 fs/xfs/libxfs/xfs_defer.c          |    6 +
 fs/xfs/libxfs/xfs_defer.h          |    1 +
 fs/xfs/libxfs/xfs_dquot_buf.c      |  190 +++++++
 fs/xfs/libxfs/xfs_format.h         |  199 ++++++-
 fs/xfs/libxfs/xfs_fs.h             |   53 +-
 fs/xfs/libxfs/xfs_group.c          |  225 ++++++++
 fs/xfs/libxfs/xfs_group.h          |  164 ++++++
 fs/xfs/libxfs/xfs_health.h         |   89 ++--
 fs/xfs/libxfs/xfs_ialloc.c         |  175 +++---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   31 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |   90 +++-
 fs/xfs/libxfs/xfs_inode_buf.h      |    3 +
 fs/xfs/libxfs/xfs_inode_util.c     |    6 +-
 fs/xfs/libxfs/xfs_log_format.h     |    8 +-
 fs/xfs/libxfs/xfs_log_recover.h    |    2 +
 fs/xfs/libxfs/xfs_metadir.c        |  481 +++++++++++++++++
 fs/xfs/libxfs/xfs_metadir.h        |   47 ++
 fs/xfs/libxfs/xfs_metafile.c       |   52 ++
 fs/xfs/libxfs/xfs_metafile.h       |   31 ++
 fs/xfs/libxfs/xfs_ondisk.h         |  186 +++++--
 fs/xfs/libxfs/xfs_quota_defs.h     |   43 ++
 fs/xfs/libxfs/xfs_refcount.c       |   33 +-
 fs/xfs/libxfs/xfs_refcount.h       |    2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   17 +-
 fs/xfs/libxfs/xfs_rmap.c           |   42 +-
 fs/xfs/libxfs/xfs_rmap.h           |    6 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |   28 +-
 fs/xfs/libxfs/xfs_rtbitmap.c       |  388 +++++++++-----
 fs/xfs/libxfs/xfs_rtbitmap.h       |  247 ++++++---
 fs/xfs/libxfs/xfs_rtgroup.c        |  697 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h        |  284 ++++++++++
 fs/xfs/libxfs/xfs_sb.c             |  276 +++++++++-
 fs/xfs/libxfs/xfs_sb.h             |    6 +-
 fs/xfs/libxfs/xfs_shared.h         |    4 +
 fs/xfs/libxfs/xfs_trans_resv.c     |    2 +-
 fs/xfs/libxfs/xfs_types.c          |   44 +-
 fs/xfs/libxfs/xfs_types.h          |   16 +-
 fs/xfs/scrub/agheader.c            |   52 +-
 fs/xfs/scrub/agheader_repair.c     |   42 +-
 fs/xfs/scrub/alloc.c               |    2 +-
 fs/xfs/scrub/alloc_repair.c        |   22 +-
 fs/xfs/scrub/bmap.c                |   38 +-
 fs/xfs/scrub/bmap_repair.c         |   11 +-
 fs/xfs/scrub/common.c              |  149 +++++-
 fs/xfs/scrub/common.h              |   40 +-
 fs/xfs/scrub/cow_repair.c          |   21 +-
 fs/xfs/scrub/dir.c                 |   10 +-
 fs/xfs/scrub/dir_repair.c          |   20 +-
 fs/xfs/scrub/dirtree.c             |   32 +-
 fs/xfs/scrub/dirtree.h             |   12 +-
 fs/xfs/scrub/findparent.c          |   28 +-
 fs/xfs/scrub/fscounters.c          |   35 +-
 fs/xfs/scrub/fscounters_repair.c   |    9 +-
 fs/xfs/scrub/health.c              |   54 +-
 fs/xfs/scrub/ialloc.c              |   16 +-
 fs/xfs/scrub/ialloc_repair.c       |   27 +-
 fs/xfs/scrub/inode.c               |   35 +-
 fs/xfs/scrub/inode_repair.c        |   39 +-
 fs/xfs/scrub/iscan.c               |    4 +-
 fs/xfs/scrub/metapath.c            |  689 ++++++++++++++++++++++++
 fs/xfs/scrub/newbt.c               |   52 +-
 fs/xfs/scrub/nlinks.c              |    4 +-
 fs/xfs/scrub/nlinks_repair.c       |    4 +-
 fs/xfs/scrub/orphanage.c           |    4 +-
 fs/xfs/scrub/parent.c              |   39 +-
 fs/xfs/scrub/parent_repair.c       |   37 +-
 fs/xfs/scrub/quotacheck.c          |    7 +-
 fs/xfs/scrub/reap.c                |   10 +-
 fs/xfs/scrub/refcount.c            |    3 +-
 fs/xfs/scrub/refcount_repair.c     |    7 +-
 fs/xfs/scrub/repair.c              |   61 ++-
 fs/xfs/scrub/repair.h              |   13 +
 fs/xfs/scrub/rgsuper.c             |   84 +++
 fs/xfs/scrub/rmap.c                |    4 +-
 fs/xfs/scrub/rmap_repair.c         |   25 +-
 fs/xfs/scrub/rtbitmap.c            |   54 +-
 fs/xfs/scrub/rtsummary.c           |  116 ++--
 fs/xfs/scrub/rtsummary_repair.c    |   22 +-
 fs/xfs/scrub/scrub.c               |   52 +-
 fs/xfs/scrub/scrub.h               |   17 +
 fs/xfs/scrub/stats.c               |    2 +
 fs/xfs/scrub/tempfile.c            |  105 ++++
 fs/xfs/scrub/tempfile.h            |    3 +
 fs/xfs/scrub/trace.c               |    1 +
 fs/xfs/scrub/trace.h               |  247 +++++----
 fs/xfs/xfs_bmap_item.c             |   26 +-
 fs/xfs/xfs_bmap_util.c             |   46 +-
 fs/xfs/xfs_buf_item_recover.c      |   67 ++-
 fs/xfs/xfs_discard.c               |  308 +++++++++--
 fs/xfs/xfs_dquot.c                 |   38 +-
 fs/xfs/xfs_dquot.h                 |   18 +-
 fs/xfs/xfs_drain.c                 |   78 ++-
 fs/xfs/xfs_drain.h                 |   22 +-
 fs/xfs/xfs_exchrange.c             |    2 +-
 fs/xfs/xfs_extent_busy.c           |  214 +++++---
 fs/xfs/xfs_extent_busy.h           |   65 +--
 fs/xfs/xfs_extfree_item.c          |  282 ++++++++--
 fs/xfs/xfs_file.c                  |   66 ++-
 fs/xfs/xfs_filestream.c            |   13 +-
 fs/xfs/xfs_fsmap.c                 |  363 +++++++------
 fs/xfs/xfs_fsmap.h                 |   15 +
 fs/xfs/xfs_fsops.c                 |   14 +-
 fs/xfs/xfs_health.c                |  278 +++++-----
 fs/xfs/xfs_icache.c                |  134 +++--
 fs/xfs/xfs_inode.c                 |   33 +-
 fs/xfs/xfs_inode.h                 |   49 +-
 fs/xfs/xfs_inode_item.c            |    7 +-
 fs/xfs/xfs_inode_item_recover.c    |    2 +-
 fs/xfs/xfs_ioctl.c                 |   46 +-
 fs/xfs/xfs_iomap.c                 |   71 ++-
 fs/xfs/xfs_iomap.h                 |    1 -
 fs/xfs/xfs_iops.c                  |   15 +-
 fs/xfs/xfs_itable.c                |   33 +-
 fs/xfs/xfs_itable.h                |    3 +
 fs/xfs/xfs_iunlink_item.c          |   13 +-
 fs/xfs/xfs_iwalk.c                 |  116 ++--
 fs/xfs/xfs_iwalk.h                 |    7 +-
 fs/xfs/xfs_log_cil.c               |    3 +-
 fs/xfs/xfs_log_recover.c           |   18 +-
 fs/xfs/xfs_message.c               |   51 ++
 fs/xfs/xfs_message.h               |   20 +-
 fs/xfs/xfs_mount.c                 |   61 ++-
 fs/xfs/xfs_mount.h                 |  113 +++-
 fs/xfs/xfs_pnfs.c                  |    3 +-
 fs/xfs/xfs_qm.c                    |  381 +++++++++++---
 fs/xfs/xfs_qm_bhv.c                |   36 +-
 fs/xfs/xfs_quota.h                 |   19 +-
 fs/xfs/xfs_refcount_item.c         |    9 +-
 fs/xfs/xfs_reflink.c               |    7 +-
 fs/xfs/xfs_rmap_item.c             |    9 +-
 fs/xfs/xfs_rtalloc.c               | 1025 ++++++++++++++++++++++++++++--------
 fs/xfs/xfs_rtalloc.h               |    6 +
 fs/xfs/xfs_stats.c                 |    7 +-
 fs/xfs/xfs_super.c                 |   75 ++-
 fs/xfs/xfs_trace.c                 |    5 +
 fs/xfs/xfs_trace.h                 |  687 ++++++++++++++++--------
 fs/xfs/xfs_trans.c                 |   97 +++-
 fs/xfs/xfs_trans.h                 |    2 +
 fs/xfs/xfs_trans_buf.c             |   25 +-
 fs/xfs/xfs_trans_dquot.c           |   17 +
 fs/xfs/xfs_xattr.c                 |    3 +-
 include/linux/iomap.h              |    4 +
 156 files changed, 9572 insertions(+), 2946 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_group.c
 create mode 100644 fs/xfs/libxfs/xfs_group.h
 create mode 100644 fs/xfs/libxfs/xfs_metadir.c
 create mode 100644 fs/xfs/libxfs/xfs_metadir.h
 create mode 100644 fs/xfs/libxfs/xfs_metafile.c
 create mode 100644 fs/xfs/libxfs/xfs_metafile.h
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h
 create mode 100644 fs/xfs/scrub/metapath.c
 create mode 100644 fs/xfs/scrub/rgsuper.c
