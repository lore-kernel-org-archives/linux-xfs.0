Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04B14AD7F5
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791211611; cv=none; b=YijC5xjnuhfd8gjtatP0swBXVxiBDWII6AuwcuqcfwqohjirhVY68KQZV3qL7vr2P2ycSrC4svB/SgcFNHipDutnLtrcP4IBPd6iTlSpBizdigpV4TYZAL4OQtu6jQrNAlwP1jToKr9HLoLTfJRMEX0weHmdR3s1AMbFGuh3Ijs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791211611; c=relaxed/simple;
	bh=gQjW3CHhc5pfmVm7wiQYN8CzfmJG+nXr8GRnANeYKCY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tH74nlQW7oajfaif0MdqwlIjT1gh9P4yXypGxdQc6msLqBTNXfPh1TCsWU60YcxPDTN8LTlHcgVe99b3UfPe6i86k6lQQGiu4+sLTEqq+717+yidC2G0fC8XjXJr7hfZOOkUmgxignaKdTamnEyYYMQb6zqmB8DmlQ9VDfhOHh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QrqDsb+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QrqDsb+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF931F000FF
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 14:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791211602;
	bh=tuJTBlbfHduhNueHJw815hbzW0xp71Jymq1yiYRoWvM=;
	h=Date:From:To:Subject;
	b=QrqDsb+AdeKcsBxpXIwIhvvmIA1361wahShHbNyJZk7eYAyY+cL+LfRtz45pGoE4p
	 wMMvuZEjtvPnfamQHqUmJtChffP5N5nsMYfhlHZOkP+4zeytMyMbghISd/WHPF+lly
	 QjbQbX+fKxcf+GKhW/R+xv0thN0Dtpd91Vy7N3Pj7xzWl6pjfXXjhcu8OFhuKTCoBs
	 TtDESZUdU5b6wUMdhfip6xvSTzDPxGwM/ftvs+vuHcskHLZQlHoUqvRUDRHoFgljvP
	 IZqtILAmW9gmBJQyi+/BilWM4qsvyJ0XOvFhElMmIe/p8fOH2JVUj4gsK0TAjOjBfC
	 aUevRdBEiGJKA==
Date: Mon, 5 Oct 2026 16:46:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next rebased to b942c6919ac3
Message-ID: <asO3upNDsKsUWqQW@nidhogg.toxiclabs.cc>
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

	gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

Patches included on the previous update are untouched, the main reason
for the rebase is to rebase it against 7.3-rc6 to make work for 7.4
easier for a few developers.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

b942c6919ac3 xfs: calculate end_fsb later in xfs_zoned_fill_srcmap

99 new commits:

Aditya Prakash Srivastava (1):
      [aa5dba2d217f] xfs: prevent close() from hanging on frozen filesystems

Carlos Maiolino (4):
      [9feae68a2934] Merge remote-tracking branch 'linux-axboe/for-7.4/lazy-bounce-buffering' into xfs-7.4-merge
      [b3837dc0c731] xfs: add xfs_error_report the ability to display an error code
      [f4922f6fb12b] xfs: introduce xfs_trans_cancel_error()
      [90c4dd2fa8fc] xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel

Christoph Hellwig (37):
      [d457743d0055] iomap: add a IOMAP_IOEND_INTEGRITY flag
      [d3f30d94f1d9] iomap,xfs: move T10 PI handling for direct I/O into ->submit_io
      [793875070ab1] xfs: move PI generation into xfs_submit_zoned_bio
      [b69e24b7507c] xfs: use BIO_COMPLETE_IN_TASK for bounce buffered read I/Os
      [85fa731672d1] iomap,xfs: move integrity verification to the file system
      [a9a7b9e8686d] xfs: add support for lazy direct read bounce buffering
      [c7bfe2427953] xfs: add error injection for lazy bounce buffering
      [9fae7cbc54a5] xfs: log a message at mount time when using integrity protection
      [cfde1b04ead8] xfs: convert all !XFS_RT stubs to inline functions
      [c8394b07a534] xfs: remove an outdated comment above xfs_file_ioctl
      [aa8ac8bd7c18] xfs: rename xfs_ioc_swapext to xfs_swapext
      [1520a0f399c0] xfs: rename xfs_ioctl_fs_counts to xfs_ioc_fs_counts
      [bf3935662d5b] xfs: rename xfs_ioctl_getset_resblocks to xfs_ioc_getset_resblocks
      [a0e6888bbce2] xfs: split out the handler for XFS_IOC_DIOINFO
      [6b7fe7fb9123] xfs: split out the handlers for XFS_IOC_.*HANDLE
      [eae65218e571] xfs: split out the handler for XFS_IOC_SWAPEXT
      [74aed426ad16] xfs: split out the handlers for XFS_IOC_FSGROWFS*
      [df33e313c20b] xfs: split out the handler for XFS_IOC_GOINGDOWN
      [86eede9385a3] xfs: split out the handler for XFS_IOC_ERROR_INJECTION
      [3483bf12f74e] xfs: split out the handler for XFS_IOC_FREE_EOFBLOCKS
      [88879b56264f] xfs: split out the handlers for XFS_IOC_FSGROWFS_*_32
      [9deaf8c5f3fe] xfs: cleanup XFS_IOC_GETVERSION_32 handling
      [b547092c957e] xfs: split out the handlers for XFS_IOC_SWAPEXT_32
      [325506469b64] xfs: split out the handlers for XFS_IOC_*_BY_HANDLE_32
      [c1aa78769100] xfs: remove an extra cast in xfs_file_compat_ioctl
      [5ed6d84e9dfe] xfs: clean up xfs_fsync_flush_log a bit
      [fe8b1951cd81] xfs: optimize cache flushing for CIL commits on multi-device file systems
      [ac81739a869c] xfs: flush multiple device caches in parallel in xlog_write_iclog
      [c110639a1c9f] xfs: centralize setting of buf_ops/buf_type/magic for rtblocks
      [724b5e3a5492] xfs: factor out a xfs_rtfile_initialize_buf helper
      [46db7dec8bae] xfs: add a xfs_rtblock_payload helper
      [dfe2d2d92df3] xfs: cleanup xfs_verify_media_error
      [89572b7fdc7b] xfs: use bdev_rw_virt in xfs_verify_media
      [b5a96a9877a5] xfs: lift setting the NOFS context to xfs_end_io
      [0c94f5499d69] xfs: split xfs_end_ioend_write
      [b74d34fa3cc7] xfs: factor out a xfs_zoned_fill_srcmap helper
      [b942c6919ac3] xfs: calculate end_fsb later in xfs_zoned_fill_srcmap

Darrick J. Wong (25):
      [da483b8a9c2c] xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair
      [244425cf63d7] xfs: online quotacheck must dirty dquot if enforcement adjustments needed
      [0b9081a774ee] xfs: fix buffer overruns in xfs_ioc_attr_list
      [07c73d1f0be6] xfs: clean up after failed metafile relinking
      [035d27cb2ae7] xfs: pass xfs_trans_resv object to reservation calculation helpers
      [a800b926346c] xfs: fix xfs_rename_space_res for non-pptr filesystems
      [aafe21c23ad8] xfs: fix ondisk symlink target validation in xrep_dinode_check_dfork
      [23067b4f98f5] xfs: add missing healthmon trace strings
      [329750292e9d] xfarray: don't crash when sorting if array element crosses a folio
      [3a94b91aef22] xfarray: don't allow users to unset in the middle of an array
      [76ac15cafb29] xfs: don't allow sorting sparse arrays
      [ebd528d1987e] xfs: simply the free space btree repair code
      [ddeb5fe2d8a8] xfarray: warn against sorting arrays with identical elements
      [f98d007017ac] xfs: compute the correct fdblocks/frextents for repair when they're negative
      [2ffc0619c9c2] xfs: mark cow extents bad if there's no rmap mapping for them
      [f8d0d90f2e24] xfs: clear the symlink zapped flag if inline symlink is ok
      [faa9aa9e8463] xfs: reinitialize dquot block if non-first dquot can't load
      [65b89ac3e8c2] xfs: fix inode btree repair when a cluster is larger than a chunk
      [7e55f84434f3] xfs: fix integer overflow problem when setting large free areas
      [017dd7a84ff4] xfs: fix buffer overflow in corrupt inline attr structure
      [b339cc253019] xfs: actually report corrupt xattrs as XFAIL during cross-referencing
      [559c9d4259aa] xfs: improve dir block reporting when cross-referencing dirents to pptrs
      [f60a2ef8d8a7] xfs: fix unnecessary dapos truncation in xchk_dir_walk
      [e53c620b3670] xfs: actually lock the metafile reservation when adjusting after repair
      [d7c204d4ea7e] xfs: avoid cross-rtgroup reaping after a repair

Eric Sandeen (16):
      [85057d98b37d] xfs: remove unused args argument from xfs_attr_node_lookup()
      [fddd62f65bee] xfs: remove unused rsvd argument from xfs_bmap_add_attrfork()
      [ff772b005836] xfs: remove unused mp and ops arguments from xfbtree_rec_bytes()
      [eae899c91e67] xfs: remove unused mp argument from xfs_exchmaps_check_forks()
      [43ded2832aad] xfs: remove unused mp argument from xfs_inobt_rec_check_count()
      [047721292292] xfs: remove unused mp argument from xfs_parent_finish()
      [de8ddee448b8] xfs: remove unused tp argument from xfs_rmap_update_hook()
      [b68d2e88b930] xfs: remove unused mp argument from xfs_rtrefcount_broot_space_calc()
      [7d67c917ec5a] xfs: remove unused mp argument from xfs_rtrefcount_broot_space()
      [29a4e6856da7] xfs: remove unused mp argument from xfs_rtrmap_broot_space_calc()
      [560e444e6194] xfs: remove unused mp argument from xfs_calc_default_atomic_ioend_reservation()
      [c06c1e1b886a] xfs: remove unused mp argument from xfs_verify_dablk()
      [00139cc68ac3] xfs: remove unused mp argument from xfs_verify_fileoff()
      [f0dd4f4d989e] xfs: remove unused mp argument from xfs_verify_fileext()
      [81caec132128] xfs: share the AG rmap btree with the rt rmap btree
      [8439f269aae2] xfs: share the AG refcount btree with the rt refcount btree

Kefeng Wang (1):
      [23f91a51425e] xfs: fix NOFS state corruption in btree split worker

Yun Zhou (1):
      [6654fca702b2] xfs: move xfs_sync_sb_buf() out of libxfs into xfs_ioctl.c

Code Diffstat:

 .../filesystems/xfs/xfs-online-fsck-design.rst     |  13 +-
 fs/xfs/libxfs/xfs_attr.c                           |  14 +-
 fs/xfs/libxfs/xfs_bmap.c                           |   5 +-
 fs/xfs/libxfs/xfs_bmap.h                           |   2 +-
 fs/xfs/libxfs/xfs_btree.c                          |  10 +-
 fs/xfs/libxfs/xfs_btree_mem.c                      |   6 +-
 fs/xfs/libxfs/xfs_dquot_buf.c                      |  13 +-
 fs/xfs/libxfs/xfs_errortag.h                       |   6 +-
 fs/xfs/libxfs/xfs_exchmaps.c                       |   1 -
 fs/xfs/libxfs/xfs_exchmaps.h                       |   3 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |   2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |   1 -
 fs/xfs/libxfs/xfs_ialloc_btree.h                   |   5 +-
 fs/xfs/libxfs/xfs_inode_fork.c                     |   4 +-
 fs/xfs/libxfs/xfs_metadir.c                        |  32 +-
 fs/xfs/libxfs/xfs_metadir.h                        |   5 +-
 fs/xfs/libxfs/xfs_parent.h                         |   1 -
 fs/xfs/libxfs/xfs_refcount_btree.c                 |  16 +-
 fs/xfs/libxfs/xfs_refcount_btree.h                 |  26 ++
 fs/xfs/libxfs/xfs_rmap.c                           |  13 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                     |  16 +-
 fs/xfs/libxfs/xfs_rmap_btree.h                     |  26 ++
 fs/xfs/libxfs/xfs_rtbitmap.c                       |  79 ++--
 fs/xfs/libxfs/xfs_rtbitmap.h                       |  45 +--
 fs/xfs/libxfs/xfs_rtrefcount_btree.c               | 121 +-----
 fs/xfs/libxfs/xfs_rtrefcount_btree.h               |   5 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c                   | 236 +-----------
 fs/xfs/libxfs/xfs_rtrmap_btree.h                   |   3 +-
 fs/xfs/libxfs/xfs_sb.c                             |  40 --
 fs/xfs/libxfs/xfs_sb.h                             |   1 -
 fs/xfs/libxfs/xfs_symlink_remote.c                 |   8 +-
 fs/xfs/libxfs/xfs_symlink_remote.h                 |   2 +-
 fs/xfs/libxfs/xfs_trans_resv.c                     |  45 +--
 fs/xfs/libxfs/xfs_trans_space.c                    |   6 +-
 fs/xfs/libxfs/xfs_types.c                          |   7 +-
 fs/xfs/libxfs/xfs_types.h                          |   7 +-
 fs/xfs/scrub/alloc_repair.c                        |  15 +-
 fs/xfs/scrub/attr.c                                |  11 +-
 fs/xfs/scrub/attr_repair.c                         |   3 +
 fs/xfs/scrub/bmap.c                                |  11 +-
 fs/xfs/scrub/bmap_repair.c                         |   4 +-
 fs/xfs/scrub/cow_repair.c                          |  84 ++--
 fs/xfs/scrub/dir.c                                 |  20 +-
 fs/xfs/scrub/fscounters.c                          |   5 +-
 fs/xfs/scrub/ialloc_repair.c                       |   8 +-
 fs/xfs/scrub/inode_repair.c                        |  32 +-
 fs/xfs/scrub/orphanage.c                           |   2 +-
 fs/xfs/scrub/quota.c                               |   2 +-
 fs/xfs/scrub/quota_repair.c                        |  25 +-
 fs/xfs/scrub/quotacheck_repair.c                   |  54 ++-
 fs/xfs/scrub/readdir.c                             |   2 +-
 fs/xfs/scrub/reap.c                                |  59 ++-
 fs/xfs/scrub/repair.c                              |  18 +-
 fs/xfs/scrub/rtbitmap_repair.c                     |  17 +-
 fs/xfs/scrub/rtrefcount_repair.c                   |   3 +-
 fs/xfs/scrub/rtrmap_repair.c                       |   2 +-
 fs/xfs/scrub/rtsummary_repair.c                    |  15 +-
 fs/xfs/scrub/symlink.c                             |  17 +-
 fs/xfs/scrub/xfarray.c                             | 201 ++++------
 fs/xfs/scrub/xfarray.h                             |   9 +-
 fs/xfs/xfs_aops.c                                  |  13 +-
 fs/xfs/xfs_bmap_item.c                             |   2 +-
 fs/xfs/xfs_buf.c                                   |  11 +
 fs/xfs/xfs_dquot.c                                 |  20 +-
 fs/xfs/xfs_dquot.h                                 |   2 +-
 fs/xfs/xfs_error.c                                 |  16 +-
 fs/xfs/xfs_error.h                                 |   9 +-
 fs/xfs/xfs_exchmaps_item.c                         |  13 +-
 fs/xfs/xfs_exchrange.c                             |   2 +-
 fs/xfs/xfs_file.c                                  |  36 +-
 fs/xfs/xfs_handle.c                                |   2 +-
 fs/xfs/xfs_inode.c                                 |  20 +-
 fs/xfs/xfs_inode_item.c                            |   3 +-
 fs/xfs/xfs_ioctl.c                                 | 425 +++++++++++++--------
 fs/xfs/xfs_ioctl.h                                 |   4 +-
 fs/xfs/xfs_ioctl32.c                               | 188 +++++----
 fs/xfs/xfs_ioend.c                                 | 212 ++++++++--
 fs/xfs/xfs_ioend.h                                 |   2 +
 fs/xfs/xfs_iomap.c                                 |  55 ++-
 fs/xfs/xfs_log.c                                   |  86 ++++-
 fs/xfs/xfs_log_cil.c                               |   9 +-
 fs/xfs/xfs_log_priv.h                              |  10 +-
 fs/xfs/xfs_log_recover.c                           |   3 +-
 fs/xfs/xfs_mount.h                                 |   8 +
 fs/xfs/xfs_qm.c                                    |   6 +-
 fs/xfs/xfs_rmap_item.c                             |   2 +-
 fs/xfs/xfs_rtalloc.h                               |  49 ++-
 fs/xfs/xfs_super.c                                 |   3 +-
 fs/xfs/xfs_symlink.c                               |   4 +-
 fs/xfs/xfs_sysfs.c                                 |  78 +++-
 fs/xfs/xfs_trace.h                                 |  29 +-
 fs/xfs/xfs_trans.c                                 |   8 +-
 fs/xfs/xfs_trans.h                                 |   9 +-
 fs/xfs/xfs_trans_dquot.c                           |   6 +-
 fs/xfs/xfs_verify_media.c                          |  87 ++---
 fs/xfs/xfs_zone_alloc.c                            |   4 +
 96 files changed, 1606 insertions(+), 1274 deletions(-)
