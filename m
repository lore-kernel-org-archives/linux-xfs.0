Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9F9328635
	for <linux-xfs@vger.kernel.org>; Mon,  9 Feb 2026 09:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770629497; cv=none; b=jcrp7TR1isPYy2cd+ZX4KLfvdKUvxDE2qe6nLh0zPhMShqzDLqGgDD75qta0u5DWGKXWCPK7cWr5vIPW0nri0cSwFW6ifji/PrA5pG6DMPYESpYH2wq1ZNFhJTEIs/N8U/5OtZR8+fzS4LfgebOyFhVkTiimkWES590RSJCpkQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770629497; c=relaxed/simple;
	bh=SHbCzEYJwnQpvxa84af+9UoqxoetJQF2+xrtj0jCv1c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=en0ecPFXEH7OUMzTdfrGU/gy+0OXB4+HYMkqkdHa+DFdRsY6MJyX20GRwnV2W82YluY4u/4ABePfkv/QND+pNsM5vdXpp++zgk0pc/jkzjlUobwHg7uH39BtqtHNblg+6JDwyHrHu0rgcK06dwa7dd2TnLqTycVkLH70KP4mUEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dptp2uj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dptp2uj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E28AC116C6;
	Mon,  9 Feb 2026 09:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770629497;
	bh=SHbCzEYJwnQpvxa84af+9UoqxoetJQF2+xrtj0jCv1c=;
	h=Date:From:To:Cc:Subject:From;
	b=dptp2uj1iTo1cZpnzMATCAqv9NJy286fa+3V0KXnYJi9qRA56e3DlRQP87PzVbmtA
	 BditmioNNRDuxwZ6zyqZ60sWOv4YjNx0QNaJ5Qbnfl/RFZPlOzqFPwx4r90atyJ25l
	 KK8tJfurE31u3rMbNSbQSN0Zgs/cCZQLFh/rLUKomvBdiLqSTAJJBOG41/8wx+NDs2
	 gfHni/6a56pjoFufZF77WHp99DmWuriMGcxM00tBrWTh6CTAPnX895nDOikQlLWcGX
	 LxV33dCBGHf8YT5F8PskgWVLIqxgSf/Ew4YOMYRxy3H3TT9v4+X1aWKNTPjovK3IpZ
	 kpeSsadWbFKhw==
Date: Mon, 9 Feb 2026 10:31:33 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: New code for v7.0
Message-ID: <aYXRoLlWgiUYROCK@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

This merge contains several improvements to zoned device support,
performance improvements for the parent pointers, a new health
monitoring feature is also part to this pull request.
There are some improvements in the journaling code too but no
behavior change expected.

Please note the monitoring feature was based on VFS's branch:
vfs-7.0.fserror, so there are some cross-tree patches in here.

There is one patch in this series which belongs to the block layer. The
maintainer is aware (and has provided his RwB) this patch is going
through the XFS tree.

Last but not least, some code refactoring and bug fixes are also
included in this series.

As usual, an attempt merge against your current TOT (05f7e89ab973 v6.19)
has been successful, without any merge conflicts. The diffstat is
provided below.

Thanks,
Carlos

"The following changes since commit 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7:

  Linux 6.19-rc6 (2026-01-18 15:42:45 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.0

for you to fetch changes up to e33839b514a8af27ba03f9f2a414d154aa980320:

  xfs: add sysfs stats for zoned GC (2026-01-30 10:41:42 +0100)

----------------------------------------------------------------
xfs: new patches for Linux 7.0

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Carlos Maiolino (4):
      Merge tag 'health-monitoring-7.0_2026-01-20' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-7.0-merge
      Merge tag 'attr-leaf-freemap-fixes-7.0_2026-01-25' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-7.0-merge
      Merge tag 'attr-pptr-speedup-7.0_2026-01-25' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-7.0-merge
      Merge tag 'scrub-syzbot-fixes-7.0_2026-01-25' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-7.0-merge

Christian Brauner (1):
      Merge patch series "fs: generic file IO error reporting"

Christoph Hellwig (36):
      xfs: add a xlog_write_one_vec helper
      xfs: set lv_bytes in xlog_write_one_vec
      xfs: improve the ->iop_format interface
      xfs: move struct xfs_log_iovec to xfs_log_priv.h
      xfs: move struct xfs_log_vec to xfs_log_priv.h
      xfs: regularize iclog space accounting in xlog_write_partial
      xfs: improve the calling convention for the xlog_write helpers
      xfs: add a xlog_write_space_left helper
      xfs: improve the iclog space assert in xlog_write_iovec
      xfs: factor out a xlog_write_space_advance helper
      xfs: rename xfs_linux.h to xfs_platform.h
      xfs: include global headers first in xfs_platform.h
      xfs: move the remaining content from xfs.h to xfs_platform.h
      xfs: directly include xfs_platform.h
      block: add a bio_reuse helper
      xfs: use bio_reuse in the zone GC code
      xfs: rework zone GC buffer management
      xfs: remove xfs_attr_leaf_hasname
      xfs: add a xfs_rtgroup_raw_size helper
      xfs: pass the write pointer to xfs_init_zone
      xfs: split and refactor zone validation
      xfs: check that used blocks are smaller than the write pointer
      xfs: use blkdev_get_zone_info to simplify zone reporting
      xfs: use a seprate member to track space availabe in the GC scatch buffer
      xfs: remove xfs_zone_gc_space_available
      xfs: fix the errno sign for the xfs_errortag_{add,clearall} stubs
      xfs: allocate m_errortag early
      xfs: don't validate error tags in the I/O path
      xfs: move the guts of XFS_ERRORTAG_DELAY out of line
      xfs: use WRITE_ONCE/READ_ONCE for m_errortag
      xfs: allow setting errortags at mount time
      xfs: don't mark all discard issued by zoned GC as sync
      xfs: refactor zone reset handling
      xfs: add zone reset error injection
      xfs: give the defer_relog stat a xs_ prefix
      xfs: add sysfs stats for zoned GC

Damien Le Moal (1):
      xfs: add missing forward declaration in xfs_zones.h

Darrick J. Wong (32):
      uapi: promote EFSCORRUPTED and EUCLEAN to errno.h
      fs: report filesystem and file I/O errors to fsnotify
      iomap: report file I/O errors to the VFS
      xfs: report fs metadata errors via fsnotify
      xfs: translate fsdax media errors into file "data lost" errors when convenient
      ext4: convert to new fserror helpers
      xfs: start creating infrastructure for health monitoring
      xfs: create event queuing, formatting, and discovery infrastructure
      xfs: convey filesystem unmount events to the health monitor
      xfs: convey metadata health events to the health monitor
      xfs: convey filesystem shutdown events to the health monitor
      xfs: convey externally discovered fsdax media errors to the health monitor
      xfs: convey file I/O errors to the health monitor
      xfs: allow toggling verbose logging on the health monitoring file
      xfs: check if an open file is on the health monitored fs
      xfs: add media verification ioctl
      xfs: mark data structures corrupt on EIO and ENODATA
      xfs: promote metadata directories and large block support
      xfs: delete attr leaf freemap entries when empty
      xfs: fix freemap adjustments when adding xattrs to leaf blocks
      xfs: refactor attr3 leaf table size computation
      xfs: strengthen attr leaf block freemap checking
      xfs: fix the xattr scrub to detect freemap/entries array collisions
      xfs: fix remote xattr valuelblk check
      xfs: reduce xfs_attr_try_sf_addname parameters
      xfs: speed up parent pointer operations when possible
      xfs: add a method to replace shortform attrs
      xfs: get rid of the xchk_xfile_*_descr calls
      xfs: only call xf{array,blob}_destroy if we have a valid pointer
      xfs: check return value of xchk_scrub_create_subord
      xfs: fix UAF in xchk_btree_check_block_owner
      xfs: check for deleted cursors when revalidating two btrees

Hans Holmberg (1):
      xfs: always allocate the free zone with the lowest index

Raphael Pinsonneault-Thibeault (1):
      xfs: validate log record version against superblock log version

Shin Seong-jun (1):
      xfs: fix spacing style issues in xfs_alloc.c

Wenwu Hou (1):
      xfs: fix incorrect context handling in xfs_trans_roll

Documentation/admin-guide/xfs.rst          |    8 +
 arch/alpha/include/uapi/asm/errno.h        |    2 +
 arch/mips/include/uapi/asm/errno.h         |    2 +
 arch/parisc/include/uapi/asm/errno.h       |    2 +
 arch/sparc/include/uapi/asm/errno.h        |    2 +
 block/bio.c                                |   34 ++++
 fs/Makefile                                |    2 +-
 fs/erofs/internal.h                        |    2 -
 fs/ext2/ext2.h                             |    1 -
 fs/ext4/ext4.h                             |    3 -
 fs/ext4/ioctl.c                            |    2 +
 fs/ext4/super.c                            |   13 +-
 fs/f2fs/f2fs.h                             |    3 -
 fs/fserror.c                               |  194 +++++++++++++++++++
 fs/iomap/buffered-io.c                     |   23 ++-
 fs/iomap/direct-io.c                       |   12 ++
 fs/iomap/ioend.c                           |    6 +
 fs/minix/minix.h                           |    2 -
 fs/super.c                                 |    3 +
 fs/udf/udf_sb.h                            |    2 -
 fs/xfs/Makefile                            |    2 +
 fs/xfs/libxfs/xfs_ag.c                     |    2 +-
 fs/xfs/libxfs/xfs_ag_resv.c                |    2 +-
 fs/xfs/libxfs/xfs_alloc.c                  |   10 +-
 fs/xfs/libxfs/xfs_alloc_btree.c            |    2 +-
 fs/xfs/libxfs/xfs_attr.c                   |  191 ++++++++++++------
 fs/xfs/libxfs/xfs_attr.h                   |    6 +-
 fs/xfs/libxfs/xfs_attr_leaf.c              |  197 +++++++++++++++----
 fs/xfs/libxfs/xfs_attr_leaf.h              |    1 +
 fs/xfs/libxfs/xfs_attr_remote.c            |    2 +-
 fs/xfs/libxfs/xfs_bit.c                    |    2 +-
 fs/xfs/libxfs/xfs_bmap.c                   |    2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c             |    2 +-
 fs/xfs/libxfs/xfs_btree.c                  |    2 +-
 fs/xfs/libxfs/xfs_btree_mem.c              |    2 +-
 fs/xfs/libxfs/xfs_btree_staging.c          |    2 +-
 fs/xfs/libxfs/xfs_da_btree.c               |    2 +-
 fs/xfs/libxfs/xfs_da_format.h              |    2 +-
 fs/xfs/libxfs/xfs_defer.c                  |    4 +-
 fs/xfs/libxfs/xfs_dir2.c                   |    2 +-
 fs/xfs/libxfs/xfs_dir2_block.c             |    2 +-
 fs/xfs/libxfs/xfs_dir2_data.c              |    2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c              |    2 +-
 fs/xfs/libxfs/xfs_dir2_node.c              |    2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c                |    2 +-
 fs/xfs/libxfs/xfs_dquot_buf.c              |    2 +-
 fs/xfs/libxfs/xfs_errortag.h               |    8 +-
 fs/xfs/libxfs/xfs_exchmaps.c               |    2 +-
 fs/xfs/libxfs/xfs_fs.h                     |  189 ++++++++++++++++++
 fs/xfs/libxfs/xfs_group.c                  |    2 +-
 fs/xfs/libxfs/xfs_health.h                 |    5 +
 fs/xfs/libxfs/xfs_ialloc.c                 |    2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c           |    2 +-
 fs/xfs/libxfs/xfs_iext_tree.c              |    2 +-
 fs/xfs/libxfs/xfs_inode_buf.c              |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.c             |    2 +-
 fs/xfs/libxfs/xfs_inode_util.c             |    2 +-
 fs/xfs/libxfs/xfs_log_format.h             |    7 -
 fs/xfs/libxfs/xfs_log_rlimit.c             |    2 +-
 fs/xfs/libxfs/xfs_metadir.c                |    2 +-
 fs/xfs/libxfs/xfs_metafile.c               |    2 +-
 fs/xfs/libxfs/xfs_parent.c                 |   16 +-
 fs/xfs/libxfs/xfs_refcount.c               |    2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c         |    2 +-
 fs/xfs/libxfs/xfs_rmap.c                   |    2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c             |    2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c               |    2 +-
 fs/xfs/libxfs/xfs_rtgroup.c                |    2 +-
 fs/xfs/libxfs/xfs_rtgroup.h                |   15 ++
 fs/xfs/libxfs/xfs_rtrefcount_btree.c       |    2 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c           |    2 +-
 fs/xfs/libxfs/xfs_sb.c                     |    2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c         |    2 +-
 fs/xfs/libxfs/xfs_trans_inode.c            |    2 +-
 fs/xfs/libxfs/xfs_trans_resv.c             |    2 +-
 fs/xfs/libxfs/xfs_trans_space.c            |    2 +-
 fs/xfs/libxfs/xfs_types.c                  |    2 +-
 fs/xfs/libxfs/xfs_zones.c                  |  151 ++++-----------
 fs/xfs/libxfs/xfs_zones.h                  |    6 +-
 fs/xfs/scrub/agb_bitmap.c                  |    2 +-
 fs/xfs/scrub/agheader.c                    |    2 +-
 fs/xfs/scrub/agheader_repair.c             |   23 ++-
 fs/xfs/scrub/alloc.c                       |    2 +-
 fs/xfs/scrub/alloc_repair.c                |   22 ++-
 fs/xfs/scrub/attr.c                        |   61 +++---
 fs/xfs/scrub/attr_repair.c                 |   28 +--
 fs/xfs/scrub/bitmap.c                      |    2 +-
 fs/xfs/scrub/bmap.c                        |    2 +-
 fs/xfs/scrub/bmap_repair.c                 |    8 +-
 fs/xfs/scrub/btree.c                       |   11 +-
 fs/xfs/scrub/common.c                      |    9 +-
 fs/xfs/scrub/common.h                      |   25 ---
 fs/xfs/scrub/cow_repair.c                  |    2 +-
 fs/xfs/scrub/dabtree.c                     |    4 +-
 fs/xfs/scrub/dir.c                         |   15 +-
 fs/xfs/scrub/dir_repair.c                  |   21 +-
 fs/xfs/scrub/dirtree.c                     |   21 +-
 fs/xfs/scrub/dirtree_repair.c              |    2 +-
 fs/xfs/scrub/dqiterate.c                   |    2 +-
 fs/xfs/scrub/findparent.c                  |    2 +-
 fs/xfs/scrub/fscounters.c                  |    2 +-
 fs/xfs/scrub/fscounters_repair.c           |    2 +-
 fs/xfs/scrub/health.c                      |    2 +-
 fs/xfs/scrub/ialloc.c                      |    2 +-
 fs/xfs/scrub/ialloc_repair.c               |   27 ++-
 fs/xfs/scrub/inode.c                       |    2 +-
 fs/xfs/scrub/inode_repair.c                |    2 +-
 fs/xfs/scrub/iscan.c                       |    2 +-
 fs/xfs/scrub/listxattr.c                   |    2 +-
 fs/xfs/scrub/metapath.c                    |    2 +-
 fs/xfs/scrub/newbt.c                       |    2 +-
 fs/xfs/scrub/nlinks.c                      |   11 +-
 fs/xfs/scrub/nlinks_repair.c               |    2 +-
 fs/xfs/scrub/orphanage.c                   |    2 +-
 fs/xfs/scrub/parent.c                      |   13 +-
 fs/xfs/scrub/parent_repair.c               |   25 +--
 fs/xfs/scrub/quota.c                       |    2 +-
 fs/xfs/scrub/quota_repair.c                |    2 +-
 fs/xfs/scrub/quotacheck.c                  |   15 +-
 fs/xfs/scrub/quotacheck_repair.c           |    2 +-
 fs/xfs/scrub/rcbag.c                       |    2 +-
 fs/xfs/scrub/rcbag_btree.c                 |    2 +-
 fs/xfs/scrub/readdir.c                     |    2 +-
 fs/xfs/scrub/reap.c                        |    2 +-
 fs/xfs/scrub/refcount.c                    |    2 +-
 fs/xfs/scrub/refcount_repair.c             |   15 +-
 fs/xfs/scrub/repair.c                      |    5 +-
 fs/xfs/scrub/rgsuper.c                     |    2 +-
 fs/xfs/scrub/rmap.c                        |    2 +-
 fs/xfs/scrub/rmap_repair.c                 |    7 +-
 fs/xfs/scrub/rtbitmap.c                    |    2 +-
 fs/xfs/scrub/rtbitmap_repair.c             |    8 +-
 fs/xfs/scrub/rtrefcount.c                  |    2 +-
 fs/xfs/scrub/rtrefcount_repair.c           |   17 +-
 fs/xfs/scrub/rtrmap.c                      |    2 +-
 fs/xfs/scrub/rtrmap_repair.c               |    7 +-
 fs/xfs/scrub/rtsummary.c                   |    9 +-
 fs/xfs/scrub/rtsummary_repair.c            |    2 +-
 fs/xfs/scrub/scrub.c                       |    4 +-
 fs/xfs/scrub/stats.c                       |    2 +-
 fs/xfs/scrub/symlink.c                     |    2 +-
 fs/xfs/scrub/symlink_repair.c              |    2 +-
 fs/xfs/scrub/tempfile.c                    |    2 +-
 fs/xfs/scrub/trace.c                       |    2 +-
 fs/xfs/scrub/xfarray.c                     |    2 +-
 fs/xfs/scrub/xfblob.c                      |    2 +-
 fs/xfs/scrub/xfile.c                       |    2 +-
 fs/xfs/xfs.h                               |   28 ---
 fs/xfs/xfs_acl.c                           |    2 +-
 fs/xfs/xfs_aops.c                          |    2 +-
 fs/xfs/xfs_attr_inactive.c                 |    2 +-
 fs/xfs/xfs_attr_item.c                     |   29 ++-
 fs/xfs/xfs_attr_list.c                     |    2 +-
 fs/xfs/xfs_bio_io.c                        |    2 +-
 fs/xfs/xfs_bmap_item.c                     |   12 +-
 fs/xfs/xfs_bmap_util.c                     |    2 +-
 fs/xfs/xfs_buf.c                           |    2 +-
 fs/xfs/xfs_buf_item.c                      |   21 +-
 fs/xfs/xfs_buf_item_recover.c              |    2 +-
 fs/xfs/xfs_buf_mem.c                       |    2 +-
 fs/xfs/xfs_dahash_test.c                   |    2 +-
 fs/xfs/xfs_dir2_readdir.c                  |    2 +-
 fs/xfs/xfs_discard.c                       |    2 +-
 fs/xfs/xfs_dquot.c                         |    2 +-
 fs/xfs/xfs_dquot_item.c                    |   11 +-
 fs/xfs/xfs_dquot_item_recover.c            |    2 +-
 fs/xfs/xfs_drain.c                         |    2 +-
 fs/xfs/xfs_error.c                         |  144 ++++++++------
 fs/xfs/xfs_error.h                         |   23 +--
 fs/xfs/xfs_exchmaps_item.c                 |   13 +-
 fs/xfs/xfs_exchrange.c                     |    2 +-
 fs/xfs/xfs_export.c                        |    2 +-
 fs/xfs/xfs_extent_busy.c                   |    2 +-
 fs/xfs/xfs_extfree_item.c                  |   12 +-
 fs/xfs/xfs_file.c                          |    2 +-
 fs/xfs/xfs_filestream.c                    |    2 +-
 fs/xfs/xfs_fsmap.c                         |    2 +-
 fs/xfs/xfs_fsops.c                         |    8 +-
 fs/xfs/xfs_globals.c                       |    2 +-
 fs/xfs/xfs_handle.c                        |    2 +-
 fs/xfs/xfs_health.c                        |  140 +++++++++++++-
 fs/xfs/xfs_healthmon.c                     | 1255 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.h                     |  184 ++++++++++++++++++
 fs/xfs/xfs_hooks.c                         |    2 +-
 fs/xfs/xfs_icache.c                        |    2 +-
 fs/xfs/xfs_icreate_item.c                  |    8 +-
 fs/xfs/xfs_inode.c                         |    2 +-
 fs/xfs/xfs_inode_item.c                    |   51 +++--
 fs/xfs/xfs_inode_item_recover.c            |    2 +-
 fs/xfs/xfs_ioctl.c                         |    9 +-
 fs/xfs/xfs_ioctl32.c                       |    2 +-
 fs/xfs/xfs_iomap.c                         |    2 +-
 fs/xfs/xfs_iops.c                          |    2 +-
 fs/xfs/xfs_itable.c                        |    2 +-
 fs/xfs/xfs_iunlink_item.c                  |    2 +-
 fs/xfs/xfs_iwalk.c                         |    2 +-
 fs/xfs/xfs_log.c                           |  294 +++++++++++-----------------
 fs/xfs/xfs_log.h                           |   65 +------
 fs/xfs/xfs_log_cil.c                       |  113 +++++++++--
 fs/xfs/xfs_log_priv.h                      |   20 ++
 fs/xfs/xfs_log_recover.c                   |   29 +--
 fs/xfs/xfs_message.c                       |   10 +-
 fs/xfs/xfs_message.h                       |    2 -
 fs/xfs/xfs_mount.c                         |    4 +-
 fs/xfs/xfs_mount.h                         |    4 +
 fs/xfs/xfs_mru_cache.c                     |    2 +-
 fs/xfs/xfs_notify_failure.c                |   23 ++-
 fs/xfs/{xfs_linux.h => xfs_platform.h}     |   48 +++--
 fs/xfs/xfs_pnfs.c                          |    2 +-
 fs/xfs/xfs_pwork.c                         |    2 +-
 fs/xfs/xfs_qm.c                            |    2 +-
 fs/xfs/xfs_qm_bhv.c                        |    2 +-
 fs/xfs/xfs_qm_syscalls.c                   |    2 +-
 fs/xfs/xfs_quotaops.c                      |    2 +-
 fs/xfs/xfs_refcount_item.c                 |   12 +-
 fs/xfs/xfs_reflink.c                       |    2 +-
 fs/xfs/xfs_rmap_item.c                     |   12 +-
 fs/xfs/xfs_rtalloc.c                       |    2 +-
 fs/xfs/xfs_stats.c                         |   14 +-
 fs/xfs/xfs_stats.h                         |    8 +-
 fs/xfs/xfs_super.c                         |   38 +++-
 fs/xfs/xfs_symlink.c                       |    2 +-
 fs/xfs/xfs_sysctl.c                        |    2 +-
 fs/xfs/xfs_sysfs.c                         |    2 +-
 fs/xfs/xfs_trace.c                         |    7 +-
 fs/xfs/xfs_trace.h                         |  513 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.c                         |   10 +-
 fs/xfs/xfs_trans.h                         |   13 +-
 fs/xfs/xfs_trans_ail.c                     |    2 +-
 fs/xfs/xfs_trans_buf.c                     |    2 +-
 fs/xfs/xfs_trans_dquot.c                   |    2 +-
 fs/xfs/xfs_verify_media.c                  |  445 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_verify_media.h                  |   13 ++
 fs/xfs/xfs_xattr.c                         |    2 +-
 fs/xfs/xfs_zone_alloc.c                    |  220 +++++++++++----------
 fs/xfs/xfs_zone_gc.c                       |  217 +++++++++++----------
 fs/xfs/xfs_zone_info.c                     |    2 +-
 fs/xfs/xfs_zone_priv.h                     |    1 -
 fs/xfs/xfs_zone_space_resv.c               |    2 +-
 include/linux/bio.h                        |    1 +
 include/linux/fs/super_types.h             |    7 +
 include/linux/fserror.h                    |   75 ++++++++
 include/linux/jbd2.h                       |    3 -
 include/uapi/asm-generic/errno.h           |    2 +
 tools/arch/alpha/include/uapi/asm/errno.h  |    2 +
 tools/arch/mips/include/uapi/asm/errno.h   |    2 +
 tools/arch/parisc/include/uapi/asm/errno.h |    2 +
 tools/arch/sparc/include/uapi/asm/errno.h  |    2 +
 tools/include/uapi/asm-generic/errno.h     |    2 +
 249 files changed, 4628 insertions(+), 1366 deletions(-)
 create mode 100644 fs/fserror.c
 delete mode 100644 fs/xfs/xfs.h
 create mode 100644 fs/xfs/xfs_healthmon.c
 create mode 100644 fs/xfs/xfs_healthmon.h
 rename fs/xfs/{xfs_linux.h => xfs_platform.h} (95%)
 create mode 100644 fs/xfs/xfs_verify_media.c
 create mode 100644 fs/xfs/xfs_verify_media.h
 create mode 100644 include/linux/fserror.h
