Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jul 2008 22:32:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6V5Wpr2001949
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 22:32:52 -0700
Date: Thu, 31 Jul 2008 15:33:59 +1000
Subject: [GIT PULL] XFS update for 2.6.27 (Resend)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080731053400.0891D58C4C3F@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

I'm resending this pull request because the last one bounced with dns failures.
Hope this one gets through...

The following changes since commit c9272c4f9fbe2087beb3392f526dc5b19efaa56b:
  Linus Torvalds (1):
        Merge branch 'hotfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6

are available in the git repository at:

  git://oss.sgi.com:8090/xfs/xfs-pull for-linus

Barry Naujok (12):
      [XFS] Split xfs_dir2_leafn_lookup_int into its two pieces of functionality
      [XFS] Name operation vector for hash and compare
      [XFS] Add op_flags field and helpers to xfs_da_args
      dcache: Add case-insensitive support d_ci_add() routine
      [XFS] Return case-insensitive match for dentry cache
      [XFS] XFS: ASCII case-insensitive support
      [XFS] kmem_free and kmem_realloc to use const void *
      [XFS] Remove d_add call for an ENOENT lookup return code
      [XFS] Zero uninitialised xfs_da_args structure in xfs_dir2.c
      [XFS] Invalidate dentry in unlink/rmdir if in case-insensitive mode
      [XFS] Fix returning case-preserved name with CI node form directories
      [XFS] Fix CI lookup in leaf-form directories

Christoph Hellwig (28):
      [XFS] Kill attr_capable checks as already done in xattr_permission.
      [XFS] kill xfs_uuid_unmount
      [XFS] merge xfs_mntupdate into xfs_fs_remount
      [XFS] kill xfs_igrow_start and xfs_igrow_finish
      [XFS] merge xfs_unmount into xfs_fs_put_super / xfs_fs_fill_super
      [XFS] merge xfs_mount into xfs_fs_fill_super
      [XFS] don't call xfs_freesb from xfs_mountfs failure case
      [XFS] sort out opening and closing of the block devices
      [XFS] add xfs_setup_devices helper
      [XFS] allow xfs_args_allocate to fail
      [XFS] kill xfs_mount_init
      [XFS] kill calls to xfs_binval in the mount error path
      [XFS] rename error2 goto label in xfs_fs_fill_super
      [XFS] add missing call to xfs_filestream_unmount on xfs_mountfs failure
      [XFS] Factor out code for whether inode has attributes or not.
      [XFS] Switches xfs_vn_listxattr to set it's put_listent callback directly
      [XFS] Merge xfs_rmdir into xfs_remove
      [XFS] Don't update i_size for directories and special files
      [XFS] Check for invalid flags in xfs_attrlist_by_handle.
      [XFS] attrmulti cleanup
      [XFS] Don't update mtime on rename source
      [XFS] streamline init/exit path
      [XFS] fix mount option parsing in remount
      [XFS] s/XFS_PURGE_INODE/IRELE/g s/VN_HOLD(XFS_ITOV())/IHOLD()/
      [XFS] fix compilation without CONFIG_PROC_FS
      [XFS] xfs_setattr currently doesn't just handle the attributes set through
      [XFS] Now that xfs_setattr is only used for attributes set from ->setattr
      [XFS] Remove vn_revalidate calls in xfs.

David Chinner (1):
      [XFS] Update valid fields in xfs_mount_log_sb()

Denys Vlasenko (3):
      [XFS] Remove unused arg from kmem_free()
      [XFS] Remove unused Falgs parameter from xfs_qm_dqpurge()
      [XFS] Remove unused wbc parameter from xfs_start_page_writeback()

Eric Sandeen (3):
      [XFS]
      [XFS] Pack some shortform dir2 structures for the ARM old ABI
      [XFS] Disable queue flag test in barrier check.

Lachlan McIlroy (11):
      [XFS] Use the generic xattr methods.
      [XFS] make inode reclaim wait for log I/O to complete
      [XFS] fix extent corruption in xfs_iext_irec_compact_full()
      [XFS] Convert ASSERTs to XFS_WANT_CORRUPTED_GOTOs
      [XFS] Always reset btree cursor after an insert
      [XFS] Use the generic xattr methods.
      [XFS] use minleft when allocating in xfs_bmbt_split()
      [XFS] Restore the lowspace extent allocator algorithm
      [XFS] Allow xfs_bmbt_split() to fallback to the lowspace allocator
      [XFS] Don't assert if trying to mount with blocksize > pagesize
      [XFS] fix use after free with external logs or real-time devices

Matthew Wilcox (1):
      [XFS] Convert l_flushsema to a sv_t

Michael Nishimoto (1):
      [XFS] Ensure that 2 GiB xfs logs work properly.

Tim Shimmin (4):
      [XFS] Fix up noattr2 so that it will properly update the versionnum and
      [XFS] Fix up warning for xfs_vn_listxatt's call of list_one_attr() with
      [XFS] Fix up problem when CONFIG_XFS_POSIX_ACL is not set and yet we still
      [XFS] A bug was found in xfs_bmap_add_extent_unwritten_real(). In a

 fs/dcache.c                    |  102 +++++
 fs/xfs/Makefile                |    3 +-
 fs/xfs/linux-2.6/kmem.c        |    6 +-
 fs/xfs/linux-2.6/kmem.h        |    4 +-
 fs/xfs/linux-2.6/xfs_aops.c    |    5 +-
 fs/xfs/linux-2.6/xfs_buf.c     |   14 +-
 fs/xfs/linux-2.6/xfs_buf.h     |    2 +-
 fs/xfs/linux-2.6/xfs_export.c  |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl.c   |  376 ++++++++++++++--
 fs/xfs/linux-2.6/xfs_iops.c    |  345 +++++----------
 fs/xfs/linux-2.6/xfs_iops.h    |    2 +
 fs/xfs/linux-2.6/xfs_linux.h   |    8 +
 fs/xfs/linux-2.6/xfs_stats.c   |   15 +-
 fs/xfs/linux-2.6/xfs_stats.h   |   12 +-
 fs/xfs/linux-2.6/xfs_super.c   |  938 ++++++++++++++++++++++++++++++++++++----
 fs/xfs/linux-2.6/xfs_super.h   |    4 +-
 fs/xfs/linux-2.6/xfs_sysctl.c  |    8 +-
 fs/xfs/linux-2.6/xfs_sysctl.h  |    4 +-
 fs/xfs/linux-2.6/xfs_vnode.c   |   50 ---
 fs/xfs/linux-2.6/xfs_vnode.h   |   89 ----
 fs/xfs/linux-2.6/xfs_xattr.c   |  330 ++++++++++++++
 fs/xfs/quota/xfs_dquot.c       |    3 +-
 fs/xfs/quota/xfs_dquot.h       |    2 +-
 fs/xfs/quota/xfs_dquot_item.c  |    4 +-
 fs/xfs/quota/xfs_qm.c          |   24 +-
 fs/xfs/quota/xfs_qm_syscalls.c |   12 +-
 fs/xfs/quota/xfs_quota_priv.h  |    3 -
 fs/xfs/support/ktrace.c        |    4 +-
 fs/xfs/support/uuid.c          |    8 +-
 fs/xfs/support/uuid.h          |    1 -
 fs/xfs/xfs_acl.c               |   21 +-
 fs/xfs/xfs_acl.h               |    4 +-
 fs/xfs/xfs_attr.c              |  608 ++++----------------------
 fs/xfs/xfs_attr.h              |   90 ++---
 fs/xfs/xfs_attr_leaf.c         |   99 ++---
 fs/xfs/xfs_attr_leaf.h         |   29 +--
 fs/xfs/xfs_attr_sf.h           |   10 +-
 fs/xfs/xfs_bmap.c              |  118 +++---
 fs/xfs/xfs_bmap.h              |   13 +-
 fs/xfs/xfs_bmap_btree.c        |   76 ++--
 fs/xfs/xfs_buf_item.c          |    8 +-
 fs/xfs/xfs_clnt.h              |    1 +
 fs/xfs/xfs_da_btree.c          |   48 ++-
 fs/xfs/xfs_da_btree.h          |   36 ++-
 fs/xfs/xfs_dfrag.c             |    4 +-
 fs/xfs/xfs_dir2.c              |  125 +++++-
 fs/xfs/xfs_dir2.h              |    6 +-
 fs/xfs/xfs_dir2_block.c        |   56 ++-
 fs/xfs/xfs_dir2_data.c         |    5 +-
 fs/xfs/xfs_dir2_leaf.c         |   93 +++--
 fs/xfs/xfs_dir2_node.c         |  402 ++++++++++-------
 fs/xfs/xfs_dir2_sf.c           |   83 ++--
 fs/xfs/xfs_dir2_sf.h           |    6 +-
 fs/xfs/xfs_dir2_trace.c        |   20 +-
 fs/xfs/xfs_dmapi.h             |    2 +-
 fs/xfs/xfs_error.c             |   13 +-
 fs/xfs/xfs_error.h             |    1 -
 fs/xfs/xfs_extfree_item.c      |    6 +-
 fs/xfs/xfs_filestream.c        |    4 +-
 fs/xfs/xfs_fs.h                |    4 +
 fs/xfs/xfs_fsops.c             |    4 +-
 fs/xfs/xfs_inode.c             |  165 +++-----
 fs/xfs/xfs_inode.h             |    3 -
 fs/xfs/xfs_inode_item.c        |    7 +-
 fs/xfs/xfs_iomap.c             |   10 +
 fs/xfs/xfs_itable.c            |    6 +-
 fs/xfs/xfs_log.c               |   49 +-
 fs/xfs/xfs_log_priv.h          |    6 +-
 fs/xfs/xfs_log_recover.c       |   21 +-
 fs/xfs/xfs_mount.c             |  118 ++----
 fs/xfs/xfs_mount.h             |   17 +-
 fs/xfs/xfs_mru_cache.c         |   21 +-
 fs/xfs/xfs_rename.c            |   22 +-
 fs/xfs/xfs_rtalloc.c           |    2 +-
 fs/xfs/xfs_sb.h                |   17 +-
 fs/xfs/xfs_trans.c             |    4 +-
 fs/xfs/xfs_trans_inode.c       |    2 +-
 fs/xfs/xfs_trans_item.c        |    8 +-
 fs/xfs/xfs_vfsops.c            |  610 +--------------------------
 fs/xfs/xfs_vfsops.h            |    5 -
 fs/xfs/xfs_vnodeops.c          |  722 +++++++++----------------------
 fs/xfs/xfs_vnodeops.h          |   12 +-
 include/linux/dcache.h         |    1 +
 83 files changed, 3105 insertions(+), 3098 deletions(-)
 create mode 100644 fs/xfs/linux-2.6/xfs_xattr.c
