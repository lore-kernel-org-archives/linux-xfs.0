Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336381E50B
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735477474; cv=none; b=lodHOlnUeFADMZ3gX2tbi7qFcjNb1Pum2JFOTvPQoyyabANaJGpMwDE1AxyYiGYvibwDiCiwiWllBBd3XcesiSgvvEPL/okTmOmRc6Ia9svRGwfb0QYdD566KG9ECGDQ86CFPu+xHD1BSL81LOOVmNwCsoIT12me9DsZLsNcDys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735477474; c=relaxed/simple;
	bh=lJgYST+QoDH+qyejhawaRHhq/mTkBKaDjTAzq/2UXOc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XpB54rb2aL1+yxHep6FxFH1G/kgJDJk6q3/7txN56P+6miNNNZc/lLMj1bEotP07h0ru7HlbCyXNH/aW9Nunr8cQgyBtA2NuDibwPBBtrA+0q8U9PbQL3v59NGMVZW489BiCcyZ2Xdwdpy9K7ZHjEByBrvEiGvGTtn30uW2iVMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFbmPwg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFbmPwg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30167C4CED1
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735477473;
	bh=lJgYST+QoDH+qyejhawaRHhq/mTkBKaDjTAzq/2UXOc=;
	h=Date:From:To:Subject:From;
	b=gFbmPwg+GkPCS3p/cHHsTiZsV1pcpzrz6FZOD8jVfFxyzxm3/oTQ2RM2NNegtfvUD
	 W53xAImsFbxzq//ABCcIVfASlQUi69zhrePn6omU3Kd5Wphs7teNTmeBS+1XbujhGg
	 gVlLie0c208CNwdvhISYdgDcD6HVMx0UHRpwmrJLq+ptj1aAiF6ylW8Pc+B00BnH5c
	 ss2qKdybRUWVgRuuMqRV/b/P+0zeBRJvRIF5ocEk0GdA1BasaAI6/5PuQ7ur7Vm0fU
	 0BaJCx+RdM1tu120y2reqZTmcU5RFFyF5/7tQYX+Zex8cl2XUOaSDwV0FpvQgYpG5n
	 3kR0UHkVO1Kmw==
Date: Sun, 29 Dec 2024 14:04:30 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 19bca351dcdf
Message-ID: <fi4y72n5jkm3qq6zfmh5da5f2ycat52vmfldl3kimyc3fnwq33@ffbey64fhsbg>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

19bca351dcdfef4a63ede08bcc9f7bdeec10c453

199 new commits:

Christoph Hellwig (38):
      [969625bf3c64] xfs: remove the unused pagb_count field in struct xfs_perag
      [e6205866b11e] xfs: remove the unused pag_active_wq field in struct xfs_perag
      [b3cdbd924f3e] xfs: pass a pag to xfs_difree_inode_chunk
      [bf91bd162fde] xfs: remove the agno argument to xfs_free_ag_extent
      [25e0d55968c7] xfs: add xfs_agbno_to_fsb and xfs_agbno_to_daddr helpers
      [ef7499e4a071] xfs: add a xfs_agino_to_ino helper
      [88e008a183cf] xfs: pass a pag to xfs_extent_busy_{search,reuse}
      [50fe5d5393e0] xfs: pass a perag structure to the xfs_ag_resv_init_error trace point
      [0601845b215f] xfs: pass objects to the xfs_irec_merge_{pre,post} trace points
      [ffae013ef77b] xfs: convert remaining trace points to pass pag structures
      [d74a561fdec4] xfs: split xfs_initialize_perag
      [b61c38ce0381] xfs: insert the pag structures into the xarray later
      [6a271c73058f] xfs: factor out a generic xfs_group structure
      [4a384bc53d5a] xfs: add a xfs_group_next_range helper
      [4f87efa3a68d] xfs: switch perag iteration from the for_each macros to a while based iterator
      [8e80c83ece3b] xfs: move metadata health tracking to the generic group structure
      [b744c034a290] xfs: move draining of deferred operations to the generic group structure
      [21cc7c27882b] xfs: move the online repair rmap hooks to the generic group structure
      [63db770a4cd2] xfs: convert busy extent tracking to the generic group structure
      [1fa5e300cb25] xfs: add a generic group pointer to the btree cursor
      [5214e3c43682] xfs: add group based bno conversion helpers
      [0cf510a91e3f] xfs: store a generic group structure in the intents
      [3c5ff15d106f] xfs_repair: refactor generate_rtinfo
      [7ac3ad4cb4a1] xfs: add a xfs_bmap_free_rtblocks helper
      [55ed4049350e] xfs: move RT bitmap and summary information to the rtgroup
      [884acdc480c9] xfs: support creating per-RTG files in growfs
      [b3d80952d04d] xfs: refactor xfs_rtbitmap_blockcount
      [3241cd2c17ae] xfs: refactor xfs_rtsummary_blockcount
      [49e1064f0169] xfs: make RT extent numbers relative to the rtgroup
      [15fb060e4e9b] xfs: add a helper to prevent bmap merges across rtgroup boundaries
      [9f09e4e0f14b] xfs: make the RT allocator rtgroup aware
      [2d1ca729a96d] xfs: don't call xfs_bmap_same_rtgroup in xfs_bmap_add_extent_hole_delay
      [0b64a342dbfc] man: document rgextents geom field
      [88a387f8f05a] xfs_repair: refactor phase4
      [4933b7fa4d42] xfs_repair: simplify rt_lock handling
      [92ba3b0d5a54] xfs_repair: add a real per-AG bitmap abstraction
      [6ba6f3933ee6] xfs_db: metadump metadir rt bitmap and summary files
      [04c339138706] xfs_scrub: cleanup fsmap keys initialization

Darrick J. Wong (152):
      [d49bd00aee5e] xfs_repair: fix maximum file offset comparison
      [98bf9c3b811b] man: document the -n parent mkfs option
      [bbfcbe40e6ea] xfs: constify the xfs_sb predicates
      [ffcb97b2320b] xfs: rename metadata inode predicates
      [65713c2c2ec3] xfs: define the on-disk format for the metadir feature
      [3c2daed21627] xfs: iget for metadata inodes
      [5889f16f1cd8] xfs: enforce metadata inode flag
      [1be54c612170] xfs: read and write metadata inode directory tree
      [da7865a2310a] xfs: disable the agi rotor for metadata inodes
      [9e6f3dd96757] xfs: advertise metadata directory feature
      [428684e8467a] xfs: allow bulkstat to return metadata directories
      [52d695723abd] xfs: adjust xfs_bmap_add_attrfork for metadir
      [261690fea209] xfs: record health problems with the metadata directory
      [bfc916d8ef51] xfs: check metadata directory file path connectivity
      [b99309ee42d6] libxfs: constify the xfs_inode predicates
      [1540262661e6] libxfs: load metadata directory root at mount time
      [e864cf06c21c] libxfs: enforce metadata inode flag
      [c62845d6d32c] man2: document metadata directory flag in fsgeom ioctl
      [81abb915afd4] man: update scrub ioctl documentation for metadir
      [50d69630adb9] libfrog: report metadata directories in the geometry report
      [da3e1d69b0ca] libfrog: allow METADIR in xfrog_bulkstat_single5
      [5e48ae670011] xfs_io: support scrubbing metadata directory paths
      [d9e3a0008ef0] xfs_db: disable xfs_check when metadir is enabled
      [5d14b7288b75] xfs_db: report metadir support for version command
      [b0a7c44df0ca] xfs_db: don't obfuscate metadata directories and attributes
      [ca4b24df1e05] xfs_db: support metadata directories in the path command
      [720eb8752fdd] xfs_db: show the metadata root directory when dumping superblocks
      [e2d3445361ff] xfs_db: display di_metatype
      [19346fffd815] xfs_db: drop the metadata checking code from blockget
      [82c8718724df] xfs_io: support flag for limited bulkstat of the metadata directory
      [aa9cb1bd5f01] xfs_io: support scrubbing metadata directory paths
      [b480672f1fa1] xfs_spaceman: report health of metadir inodes too
      [a6e089903f2f] xfs_scrub: tread zero-length read verify as an IO error
      [cd9d49b326ef] xfs_scrub: scan metadata directories during phase 3
      [de00cd47384b] xfs_scrub: re-run metafile scrubbers during phase 5
      [93f4922c92b8] xfs_repair: handle sb_metadirino correctly when zeroing supers
      [92657514ddfd] xfs_repair: dont check metadata directory dirent inumbers
      [4041da53acc0] xfs_repair: refactor fixing dotdot
      [66a0ebc3c5de] xfs_repair: refactor marking of metadata inodes
      [58e7dc339dc2] xfs_repair: refactor root directory initialization
      [0032c19e192f] xfs_repair: refactor grabbing realtime metadata inodes
      [34a4618b7597] xfs_repair: check metadata inode flag
      [62087e193116] xfs_repair: use libxfs_metafile_iget for quota/rt inodes
      [529a5b4e9cef] xfs_repair: rebuild the metadata directory
      [920e4cc6c91a] xfs_repair: don't let metadata and regular files mix
      [1bd352339960] xfs_repair: update incore metadata state whenever we create new files
      [750afdf6989d] xfs_repair: pass private data pointer to scan_lbtree
      [e3cbc6358ac9] xfs_repair: mark space used by metadata files
      [2797f8a41636] xfs_repair: adjust keep_fsinos to handle metadata directories
      [f1184d8d28c5] xfs_repair: metadata dirs are never plausible root dirs
      [03e7de0cb18e] xfs_repair: drop all the metadata directory files during pass 4
      [278d707272d9] xfs_repair: truncate and unmark orphaned metadata inodes
      [089c1e7d5b69] xfs_repair: do not count metadata directory files when doing quotacheck
      [9d4c07124e57] mkfs.xfs: enable metadata directories
      [b48164b8cd76] libxfs: resync libxfs_alloc_file_space interface with the kernel
      [73fb78e5ee89] mkfs: support copying in large or sparse files
      [51bf422aa4bb] mkfs: support copying in xattrs
      [6aace700b7b8] mkfs: add a utility to generate protofiles
      [001b79f0b7fc] xfs: create incore realtime group structures
      [5a96f6eed331] xfs: define locking primitives for realtime groups
      [abb0172a9a34] xfs: add a lockdep class key for rtgroup inodes
      [15c6dada7cb7] xfs: support caching rtgroup metadata inodes
      [16ddcc41229c] libfrog: add memchr_inv
      [1278e817a799] xfs: define the format of rt groups
      [96867b5dd9f8] xfs: update realtime super every time we update the primary fs super
      [4215af60f6d3] xfs: export realtime group geometry via XFS_FSOP_GEOM
      [74dd0d11a449] xfs: check that rtblock extents do not break rtsupers or rtgroups
      [6fae9d99d9c8] xfs: add frextents to the lazysbcounters when rtgroups enabled
      [2342f2c03c97] xfs: record rt group metadata errors in the health system
      [b69571adb79e] xfs: export the geometry of realtime groups to userspace
      [06fb4ab27d62] xfs: add block headers to realtime bitmap and summary blocks
      [5d1ceb55d570] xfs: encode the rtbitmap in big endian format
      [af4bcc58f7ea] xfs: encode the rtsummary in big endian format
      [c643e707d311] xfs: grow the realtime section when realtime groups are enabled
      [2f8a0a5a02af] xfs: support logging EFIs for realtime extents
      [e200799d5bbd] xfs: support error injection when freeing rt extents
      [f95f8a062de9] xfs: use realtime EFI to free extents when rtgroups are enabled
      [5b4cdd7bae76] xfs: don't merge ioends across RTGs
      [5397ae40aa84] xfs: scrub the realtime group superblock
      [70c4fd2bc463] xfs: scrub metadir paths for rtgroup metadata
      [86e2966742f9] xfs: mask off the rtbitmap and summary inodes when metadir in use
      [6fd224bcfdbe] xfs: create helpers to deal with rounding xfs_fileoff_t to rtx boundaries
      [7901a592698c] xfs: create helpers to deal with rounding xfs_filblks_t to rtx boundaries
      [606a37448e30] xfs: make xfs_rtblock_t a segmented address like xfs_fsblock_t
      [6713ab810c4e] xfs: adjust min_block usage in xfs_verify_agbno
      [fdaaa0cb7a0c] xfs: move the min and max group block numbers to xfs_group
      [84daa9bd1b59] xfs: implement busy extent tracking for rtgroups
      [adf9494338ae] xfs: use metadir for quota inodes
      [29a6df5a4112] xfs: scrub quota file metapaths
      [7f45426fd4fe] xfs: enable metadata directory feature
      [8a4045cbe17a] xfs: convert struct typedefs in xfs_ondisk.h
      [f20309e8a094] xfs: separate space btree structures in xfs_ondisk.h
      [318c294dcb53] xfs: port ondisk structure checks from xfs/122 to the kernel
      [6af3957ea58a] xfs: return a 64-bit block count from xfs_btree_count_blocks
      [372aa942c32c] xfs: fix error bailout in xfs_rtginode_create
      [22f727e766f4] xfs: update btree keys correctly when _insrec splits an inode root block
      [2af08a75e4d1] xfs: fix sb_spino_align checks for large fsblock sizes
      [3e8a2c473d88] xfs: return from xfs_symlink_verify early on V4 filesystems
      [d4d205f82842] libxfs: remove XFS_ILOCK_RT*
      [762043aee95d] libxfs: adjust xfs_fsb_to_db to handle segmented rtblocks
      [595b5cecf6b2] xfs_repair,mkfs: port to libxfs_rt{bitmap,summary}_create
      [b15a12d42050] libxfs: use correct rtx count to block count conversion
      [f018c3eb2277] libfrog: scrub the realtime group superblock
      [a9330b7fb3c0] man: document the rt group geometry ioctl
      [f2d61c12f4e5] libxfs: port userspace deferred log item to handle rtgroups
      [8ea12bc87e16] libxfs: implement some sanity checking for enormous rgcount
      [57e5eb6d1dc2] libfrog: support scrubbing rtgroup metadata paths
      [6351c6b3fb36] libfrog: report rt groups in output
      [3516c7fe892e] libfrog: add bitmap_clear
      [61f5d4a4a5c8] xfs_logprint: report realtime EFIs
      [840194be7872] xfs_repair: adjust rtbitmap/rtsummary word updates to handle big endian values
      [607b7197c021] xfs_repair: refactor offsetof+sizeof to offsetofend
      [9fe5aa9c9c23] xfs_repair: improve rtbitmap discrepancy reporting
      [7c541c90fd77] xfs_repair: support realtime groups
      [b1803dc7b63b] xfs_repair: find and clobber rtgroup bitmap and summary files
      [76507468b265] xfs_repair: support realtime superblocks
      [5ef84567a5f9] xfs_repair: repair rtbitmap and rtsummary block headers
      [cffeab562105] xfs_db: enable the rtblock and rtextent commands for segmented rt block numbers
      [903072467481] xfs_db: enable rtconvert to handle segmented rtblocks
      [627513cabdcd] xfs_db: listify the definition of enum typnm
      [ef420536009d] xfs_db: support dumping realtime group data and superblocks
      [03101e4578ab] xfs_db: support changing the label and uuid of rt superblocks
      [47ead87bff83] xfs_db: enable conversion of rt space units
      [6bc20c5edbab] xfs_db: metadump realtime devices
      [2be091fb5314] xfs_db: dump rt bitmap blocks
      [e5bd3d74aa02] xfs_db: dump rt summary blocks
      [bd76dc340f67] xfs_db: report rt group and block number in the bmap command
      [6e7d726d6fe2] xfs_io: support scrubbing rtgroup metadata
      [18e3b756d550] xfs_io: support scrubbing rtgroup metadata paths
      [b15ffb571150] xfs_io: add a command to display allocation group information
      [39adf908f930] xfs_io: add a command to display realtime group information
      [1bb785d57404] xfs_io: display rt group in verbose bmap output
      [06f8edf3e634] xfs_io: display rt group in verbose fsmap output
      [c1464833d94d] xfs_mdrestore: refactor open-coded fd/is_file into a structure
      [32432bbff943] xfs_mdrestore: restore rt group superblocks to realtime device
      [a3c38eecc97b] xfs_spaceman: report on realtime group health
      [241d915d69d4] xfs_scrub: scrub realtime allocation group metadata
      [816f973a8ff6] xfs_scrub: check rtgroup metadata directory connections
      [a68eb7c7fde1] xfs_scrub: call GETFSMAP for each rt group in parallel
      [d464c9cfb583] xfs_scrub: trim realtime volumes too
      [1fc3de707fc5] xfs_scrub: use histograms to speed up phase 8 on the realtime volume
      [aaf86f87ea58] mkfs: add headers to realtime bitmap blocks
      [0d7c490474e5] mkfs: format realtime groups
      [a1474f1b8509] libfrog: scrub quota file metapaths
      [ff7a96372378] xfs_db: support metadir quotas
      [8cb45fdf6de1] xfs_repair: refactor quota inumber handling
      [8b41e9bb3f0f] xfs_repair: hoist the secondary sb qflags handling
      [b790ab2a303d] xfs_repair: support quota inodes in the metadata directory
      [d6aa9b80f482] xfs_repair: try not to trash qflags on metadir filesystems
      [525f826429a8] mkfs: add quota flags when setting up filesystem
      [0ef6ac32d3ca] xfs_quota: report warning limits for realtime space quotas
      [b921f97bcf43] mkfs: enable rt quota options

Dave Chinner (2):
      [9c0c39ae9703] xfs: sb_spino_align is not verified
      [12a11a2bfaa2] xfs: fix sparse inode limits on runt AG

Jan Palus (1):
      [acadff195e10] man: fix ioctl_xfs_commit_range man page install

Jeff Layton (1):
      [0319f1600252] xfs: switch to multigrain timestamps

Long Li (2):
      [bc494cfd76a4] xfs: remove the redundant xfs_alloc_log_agf
      [94a12f8aa5d9] xfs: remove unknown compat feature check in superblock write validation

Ojaswin Mujoo (3):
      [1ea8166cdd74] include/linux.h: use linux/magic.h to get XFS_SUPER_MAGIC
      [e6b48f451a5d] xfs_io: allow foreign FSes to show FS_IOC_FSGETXATTR details
      [19bca351dcdf] xfs_io: add extsize command support

Code Diffstat:

 db/Makefile                           |   1 +
 db/block.c                            |  34 +-
 db/block.h                            |  16 -
 db/bmap.c                             |  56 ++-
 db/check.c                            | 292 +-----------
 db/command.c                          |   2 +
 db/convert.c                          | 119 ++++-
 db/dquot.c                            |  59 ++-
 db/faddr.c                            |   1 -
 db/field.c                            |  22 +
 db/field.h                            |  11 +
 db/fsmap.c                            |  10 +-
 db/info.c                             |   7 +-
 db/inode.c                            | 126 ++++-
 db/inode.h                            |   2 +
 db/iunlink.c                          |   6 +-
 db/metadump.c                         | 444 ++++++++++--------
 db/namei.c                            |  71 ++-
 db/rtgroup.c                          | 154 ++++++
 db/rtgroup.h                          |  21 +
 db/sb.c                               | 133 +++++-
 db/type.c                             |  16 +
 db/type.h                             |  32 +-
 db/xfs_metadump.sh                    |   5 +-
 include/libxfs.h                      |  10 +-
 include/linux.h                       |   3 +-
 include/platform_defs.h               |  33 ++
 include/xfs.h                         |  15 +
 include/xfs_inode.h                   |  23 +-
 include/xfs_metadump.h                |   8 +
 include/xfs_mount.h                   |  76 ++-
 include/xfs_trace.h                   |  38 +-
 include/xfs_trans.h                   |   4 +
 include/xqm.h                         |   5 +-
 io/Makefile                           |   1 +
 io/aginfo.c                           | 215 +++++++++
 io/bmap.c                             |  27 +-
 io/bulkstat.c                         |  16 +-
 io/fsmap.c                            |  22 +-
 io/init.c                             |   1 +
 io/io.h                               |   1 +
 io/open.c                             |   2 +-
 io/scrub.c                            | 131 +++++-
 io/stat.c                             |  63 +--
 libfrog/bitmap.c                      |  25 +-
 libfrog/bitmap.h                      |   1 +
 libfrog/bulkstat.c                    |   3 +-
 libfrog/div64.h                       |   6 +
 libfrog/fsgeom.c                      |  30 +-
 libfrog/fsgeom.h                      |  16 +
 libfrog/radix-tree.h                  |   9 +
 libfrog/scrub.c                       |  58 ++-
 libfrog/scrub.h                       |   3 +
 libfrog/util.c                        |  26 ++
 libfrog/util.h                        |   5 +
 libxfs/Makefile                       |   8 +
 libxfs/defer_item.c                   | 102 ++--
 libxfs/init.c                         | 115 ++++-
 libxfs/inode.c                        |  62 +++
 libxfs/iunlink.c                      |  11 +-
 libxfs/libxfs_api_defs.h              |  46 +-
 libxfs/libxfs_io.h                    |   1 +
 libxfs/libxfs_priv.h                  |  52 +--
 libxfs/rdwr.c                         |  17 +
 libxfs/topology.c                     |  42 ++
 libxfs/topology.h                     |   3 +
 libxfs/trans.c                        |  70 ++-
 libxfs/util.c                         | 221 +++++++--
 libxfs/xfs_ag.c                       | 258 ++++------
 libxfs/xfs_ag.h                       | 205 ++++----
 libxfs/xfs_ag_resv.c                  |  22 +-
 libxfs/xfs_alloc.c                    | 119 ++---
 libxfs/xfs_alloc.h                    |  19 +-
 libxfs/xfs_alloc_btree.c              |  30 +-
 libxfs/xfs_attr.c                     |   5 +-
 libxfs/xfs_bmap.c                     | 131 ++++--
 libxfs/xfs_bmap.h                     |   2 +-
 libxfs/xfs_btree.c                    |  71 +--
 libxfs/xfs_btree.h                    |   5 +-
 libxfs/xfs_btree_mem.c                |   6 +-
 libxfs/xfs_defer.c                    |   6 +
 libxfs/xfs_defer.h                    |   1 +
 libxfs/xfs_dquot_buf.c                | 190 ++++++++
 libxfs/xfs_format.h                   | 201 ++++++--
 libxfs/xfs_fs.h                       |  53 ++-
 libxfs/xfs_group.c                    | 223 +++++++++
 libxfs/xfs_group.h                    | 164 +++++++
 libxfs/xfs_health.h                   |  89 ++--
 libxfs/xfs_ialloc.c                   | 191 ++++----
 libxfs/xfs_ialloc_btree.c             |  35 +-
 libxfs/xfs_inode_buf.c                |  90 +++-
 libxfs/xfs_inode_buf.h                |   3 +
 libxfs/xfs_inode_util.c               |   6 +-
 libxfs/xfs_log_format.h               |   8 +-
 libxfs/xfs_metadir.c                  | 480 +++++++++++++++++++
 libxfs/xfs_metadir.h                  |  47 ++
 libxfs/xfs_metafile.c                 |  52 +++
 libxfs/xfs_metafile.h                 |  31 ++
 libxfs/xfs_ondisk.h                   | 186 ++++++--
 libxfs/xfs_quota_defs.h               |  43 ++
 libxfs/xfs_refcount.c                 |  33 +-
 libxfs/xfs_refcount.h                 |   2 +-
 libxfs/xfs_refcount_btree.c           |  17 +-
 libxfs/xfs_rmap.c                     |  42 +-
 libxfs/xfs_rmap.h                     |   6 +-
 libxfs/xfs_rmap_btree.c               |  28 +-
 libxfs/xfs_rtbitmap.c                 | 405 ++++++++++------
 libxfs/xfs_rtbitmap.h                 | 247 ++++++----
 libxfs/xfs_rtgroup.c                  | 694 +++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h                  | 284 +++++++++++
 libxfs/xfs_sb.c                       | 284 +++++++++--
 libxfs/xfs_sb.h                       |   6 +-
 libxfs/xfs_shared.h                   |   4 +
 libxfs/xfs_symlink_remote.c           |   4 +-
 libxfs/xfs_trans_inode.c              |   6 +-
 libxfs/xfs_trans_resv.c               |   2 +-
 libxfs/xfs_types.c                    |  44 +-
 libxfs/xfs_types.h                    |  16 +-
 logprint/log_misc.c                   |   2 +
 logprint/log_print_all.c              |   8 +
 logprint/log_redo.c                   |  57 ++-
 man/man2/ioctl_xfs_commit_range.2     |   2 +-
 man/man2/ioctl_xfs_fsgeometry.2       |   9 +-
 man/man2/ioctl_xfs_rtgroup_geometry.2 |  99 ++++
 man/man2/ioctl_xfs_scrub_metadata.2   |  53 +++
 man/man8/mkfs.xfs.8.in                | 102 ++++
 man/man8/xfs_db.8                     |  69 ++-
 man/man8/xfs_io.8                     |  40 +-
 man/man8/xfs_mdrestore.8              |  10 +
 man/man8/xfs_metadump.8               |  11 +
 man/man8/xfs_protofile.8              |  33 ++
 man/man8/xfs_spaceman.8               |   5 +-
 mdrestore/xfs_mdrestore.c             | 163 ++++---
 mkfs/Makefile                         |  10 +-
 mkfs/lts_4.19.conf                    |   1 +
 mkfs/lts_5.10.conf                    |   1 +
 mkfs/lts_5.15.conf                    |   1 +
 mkfs/lts_5.4.conf                     |   1 +
 mkfs/lts_6.1.conf                     |   1 +
 mkfs/lts_6.12.conf                    |   1 +
 mkfs/lts_6.6.conf                     |   1 +
 mkfs/proto.c                          | 497 +++++++++++++++-----
 mkfs/xfs_mkfs.c                       | 427 ++++++++++++++++-
 mkfs/xfs_protofile.in                 | 152 ++++++
 quota/state.c                         |   1 +
 repair/agbtree.c                      |  27 +-
 repair/agheader.c                     | 183 ++++----
 repair/agheader.h                     |  10 +
 repair/bmap_repair.c                  |  11 +-
 repair/bulkload.c                     |   9 +-
 repair/dino_chunks.c                  | 103 +++-
 repair/dinode.c                       | 380 +++++++++++----
 repair/dinode.h                       |   6 +-
 repair/dir2.c                         |  76 ++-
 repair/globals.c                      | 123 ++++-
 repair/globals.h                      |  30 +-
 repair/incore.c                       | 235 +++++++---
 repair/incore.h                       |  99 +++-
 repair/incore_ext.c                   |   3 +-
 repair/incore_ino.c                   |   1 +
 repair/phase1.c                       |   2 +
 repair/phase2.c                       | 103 ++--
 repair/phase3.c                       |   4 +
 repair/phase4.c                       | 351 ++++++++------
 repair/phase5.c                       |  20 +-
 repair/phase6.c                       | 858 ++++++++++++++++++++++++++--------
 repair/pptr.c                         |  94 ++++
 repair/pptr.h                         |   2 +
 repair/prefetch.c                     |   2 +-
 repair/quotacheck.c                   | 140 +++++-
 repair/quotacheck.h                   |   3 +
 repair/rmap.c                         |  16 +-
 repair/rt.c                           | 601 ++++++++++++++++++++----
 repair/rt.h                           |  35 +-
 repair/sb.c                           |  47 ++
 repair/scan.c                         |  79 +++-
 repair/scan.h                         |   7 +-
 repair/versions.c                     |  16 +-
 repair/xfs_repair.c                   |  88 +++-
 scrub/inodes.c                        |  11 +-
 scrub/inodes.h                        |   5 +-
 scrub/phase2.c                        | 124 +++--
 scrub/phase3.c                        |   7 +-
 scrub/phase5.c                        | 122 ++++-
 scrub/phase6.c                        |  41 +-
 scrub/phase7.c                        |   7 +
 scrub/phase8.c                        |  36 +-
 scrub/read_verify.c                   |   8 +
 scrub/repair.c                        |   1 +
 scrub/scrub.c                         |  25 +
 scrub/scrub.h                         |  18 +
 scrub/spacemap.c                      | 102 +++-
 scrub/xfs_scrub.c                     |   2 +
 scrub/xfs_scrub.h                     |   1 +
 spaceman/health.c                     |  65 ++-
 195 files changed, 11384 insertions(+), 3074 deletions(-)
 create mode 100644 db/rtgroup.c
 create mode 100644 db/rtgroup.h
 create mode 100644 io/aginfo.c
 create mode 100644 libxfs/xfs_group.c
 create mode 100644 libxfs/xfs_group.h
 create mode 100644 libxfs/xfs_metadir.c
 create mode 100644 libxfs/xfs_metadir.h
 create mode 100644 libxfs/xfs_metafile.c
 create mode 100644 libxfs/xfs_metafile.h
 create mode 100644 libxfs/xfs_rtgroup.c
 create mode 100644 libxfs/xfs_rtgroup.h
 create mode 100644 man/man2/ioctl_xfs_rtgroup_geometry.2
 create mode 100644 man/man8/xfs_protofile.8
 create mode 100644 mkfs/xfs_protofile.in

-- 
- Andrey
