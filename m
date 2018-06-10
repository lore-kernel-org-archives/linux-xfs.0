Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45748 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753662AbeFJDP0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jun 2018 23:15:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A3AkHj078321
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 03:15:26 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2jgecx90u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 03:15:26 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5A3FPrr011759
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 03:15:25 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A3FPmF028362
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 03:15:25 GMT
Date: Sat, 9 Jun 2018 20:15:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to ad2cd25e42b8
Message-ID: <20180610031525.GT25007@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

0703a8e1c17e xfs: replace do_mod with native operations

New Commits:

Arnd Bergmann (1):
      [4bb8b65a0427] xfs: fix string handling in label get/set functions

Darrick J. Wong (14):
      [aaacdd257fd0] xfs: don't forbid setting dax flag on directories if device doesn't dax
      [17ba2cc7b5b9] xfs: don't assert when reporting on-disk corruption while loading btree
      [b3986010cea5] xfs: remove redundant ASSERT on insufficient bestfree length in _leaf_addname
      [a37f7b127ed3] xfs: xfs_alloc_get_rec should return EFSCORRUPTED for obvious bnobt corruption
      [eeee0d6a9bc9] xfs: btree lookup shouldn't ASSERT on empty btree nodes
      [1f5c071d19ae] xfs: don't ASSERT on short form btree root pointer of zero
      [924cade4df49] xfs: don't return garbage buffers in xfs_da3_node_read
      [e4f45eff86fd] xfs: check directory bestfree information in the verifier
      [4cbae4b816fd] xfs: introduce xfs_btree_debug_check_ptr
      [e63a1008ee08] xfs: strengthen btree pointer checks before use
      [85ae01098c1a] xfs: don't assert when on-disk btree pointers are garbage
      [2551a53053de] xfs: explicitly pass buffer size to xfs_corruption_error
      [d2e736654247] xfs: don't assert on corrupted unlinked inode list
      [117a148ffe00] iomap: fsync swap files before iterating mappings

Dave Chinner (13):
      [9f96cc958e8a] xfs: verify AGI unlinked list contains valid blocks
      [fa4ca9c55746] xfs: catch bad stripe alignment configurations
      [7d71a671a2d9] xfs: verify extent size hint is valid in inode verifier
      [02a0fda875c8] xfs: verify COW extent size hint is valid in inode verifier
      [541b5acc8591] xfs: verify root inode more thoroughly
      [29cad0b3edaf] xfs: push corruption -> ESTALE conversion to xfs_nfs_get_inode()
      [9e6c08d4a8fc] xfs: validate btree records on retrieval
      [0b61f8a4079d] xfs: convert to SPDX license tags
      [ef215e394eeb] xfs: setup VFS i_rwsem lockdep state correctly
      [4a2d01b076d2] xfs: xfs_reflink_convert_cow() memory allocation deadlock
      [86210fbebae6] xfs: move various type verifiers to common file
      [9bb54cb56ae8] xfs: clean up MIN/MAX
      [0703a8e1c17e] xfs: replace do_mod with native operations

Eric Sandeen (2):
      [89c2e71123ba] xfs: use xfs_trans_getsb in xfs_sync_sb_buf
      [bb3d48dcf86a] xfs: don't call xfs_da_shrink_inode with NULL bp


Code Diffstat:

 fs/iomap.c                         |   6 +-
 fs/xfs/Makefile                    |  15 +---
 fs/xfs/kmem.c                      |  14 +--
 fs/xfs/kmem.h                      |  14 +--
 fs/xfs/libxfs/xfs_ag_resv.c        |  16 +---
 fs/xfs/libxfs/xfs_ag_resv.h        |  16 +---
 fs/xfs/libxfs/xfs_alloc.c          |  95 ++++++--------------
 fs/xfs/libxfs/xfs_alloc.h          |  18 +---
 fs/xfs/libxfs/xfs_alloc_btree.c    |  15 +---
 fs/xfs/libxfs/xfs_alloc_btree.h    |  14 +--
 fs/xfs/libxfs/xfs_attr.c           |  14 +--
 fs/xfs/libxfs/xfs_attr_leaf.c      |  21 +----
 fs/xfs/libxfs/xfs_attr_leaf.h      |  14 +--
 fs/xfs/libxfs/xfs_attr_remote.c    |  14 +--
 fs/xfs/libxfs/xfs_attr_remote.h    |  14 +--
 fs/xfs/libxfs/xfs_attr_sf.h        |  14 +--
 fs/xfs/libxfs/xfs_bit.c            |  14 +--
 fs/xfs/libxfs/xfs_bit.h            |  14 +--
 fs/xfs/libxfs/xfs_bmap.c           |  54 ++++++------
 fs/xfs/libxfs/xfs_bmap.h           |  14 +--
 fs/xfs/libxfs/xfs_bmap_btree.c     |  14 +--
 fs/xfs/libxfs/xfs_bmap_btree.h     |  14 +--
 fs/xfs/libxfs/xfs_btree.c          | 171 ++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_btree.h          |  14 +--
 fs/xfs/libxfs/xfs_da_btree.c       |  24 ++---
 fs/xfs/libxfs/xfs_da_btree.h       |  14 +--
 fs/xfs/libxfs/xfs_da_format.c      |  14 +--
 fs/xfs/libxfs/xfs_da_format.h      |  14 +--
 fs/xfs/libxfs/xfs_defer.c          |  16 +---
 fs/xfs/libxfs/xfs_defer.h          |  16 +---
 fs/xfs/libxfs/xfs_dir2.c           |  14 +--
 fs/xfs/libxfs/xfs_dir2.h           |  14 +--
 fs/xfs/libxfs/xfs_dir2_block.c     |  22 ++---
 fs/xfs/libxfs/xfs_dir2_data.c      | 122 +++++++++++++++-----------
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  26 ++----
 fs/xfs/libxfs/xfs_dir2_node.c      |  17 +---
 fs/xfs/libxfs/xfs_dir2_priv.h      |  14 +--
 fs/xfs/libxfs/xfs_dir2_sf.c        |  14 +--
 fs/xfs/libxfs/xfs_dquot_buf.c      |  14 +--
 fs/xfs/libxfs/xfs_errortag.h       |  15 +---
 fs/xfs/libxfs/xfs_format.h         |  14 +--
 fs/xfs/libxfs/xfs_fs.h             |  14 +--
 fs/xfs/libxfs/xfs_ialloc.c         | 158 +++++++++------------------------
 fs/xfs/libxfs/xfs_ialloc.h         |  21 +----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  14 +--
 fs/xfs/libxfs/xfs_ialloc_btree.h   |  14 +--
 fs/xfs/libxfs/xfs_iext_tree.c      |  10 +--
 fs/xfs/libxfs/xfs_inode_buf.c      |  34 ++++----
 fs/xfs/libxfs/xfs_inode_buf.h      |  14 +--
 fs/xfs/libxfs/xfs_inode_fork.c     |  14 +--
 fs/xfs/libxfs/xfs_inode_fork.h     |  14 +--
 fs/xfs/libxfs/xfs_log_format.h     |  14 +--
 fs/xfs/libxfs/xfs_log_recover.h    |  14 +--
 fs/xfs/libxfs/xfs_log_rlimit.c     |  14 +--
 fs/xfs/libxfs/xfs_quota_defs.h     |  14 +--
 fs/xfs/libxfs/xfs_refcount.c       |  63 +++++++++-----
 fs/xfs/libxfs/xfs_refcount.h       |  16 +---
 fs/xfs/libxfs/xfs_refcount_btree.c |  17 +---
 fs/xfs/libxfs/xfs_refcount_btree.h |  16 +---
 fs/xfs/libxfs/xfs_rmap.c           |  55 +++++++++---
 fs/xfs/libxfs/xfs_rmap.h           |  16 +---
 fs/xfs/libxfs/xfs_rmap_btree.c     |  15 +---
 fs/xfs/libxfs/xfs_rmap_btree.h     |  14 +--
 fs/xfs/libxfs/xfs_rtbitmap.c       |  26 +-----
 fs/xfs/libxfs/xfs_sb.c             |  40 +++++----
 fs/xfs/libxfs/xfs_sb.h             |  14 +--
 fs/xfs/libxfs/xfs_shared.h         |  14 +--
 fs/xfs/libxfs/xfs_symlink_remote.c |  14 +--
 fs/xfs/libxfs/xfs_trans_resv.c     |  30 ++-----
 fs/xfs/libxfs/xfs_trans_resv.h     |  14 +--
 fs/xfs/libxfs/xfs_trans_space.h    |  14 +--
 fs/xfs/libxfs/xfs_types.c          | 173 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h          |  33 ++++---
 fs/xfs/mrlock.h                    |  14 +--
 fs/xfs/scrub/agheader.c            |  18 +---
 fs/xfs/scrub/agheader_repair.c     |  16 +---
 fs/xfs/scrub/alloc.c               |  16 +---
 fs/xfs/scrub/attr.c                |  16 +---
 fs/xfs/scrub/bmap.c                |  16 +---
 fs/xfs/scrub/btree.c               |  16 +---
 fs/xfs/scrub/btree.h               |  16 +---
 fs/xfs/scrub/common.c              |  16 +---
 fs/xfs/scrub/common.h              |  16 +---
 fs/xfs/scrub/dabtree.c             |  16 +---
 fs/xfs/scrub/dabtree.h             |  16 +---
 fs/xfs/scrub/dir.c                 |  16 +---
 fs/xfs/scrub/ialloc.c              |  16 +---
 fs/xfs/scrub/inode.c               |  16 +---
 fs/xfs/scrub/parent.c              |  16 +---
 fs/xfs/scrub/quota.c               |  16 +---
 fs/xfs/scrub/refcount.c            |  16 +---
 fs/xfs/scrub/repair.c              |  16 +---
 fs/xfs/scrub/repair.h              |  16 +---
 fs/xfs/scrub/rmap.c                |  16 +---
 fs/xfs/scrub/rtbitmap.c            |  16 +---
 fs/xfs/scrub/scrub.c               |  16 +---
 fs/xfs/scrub/scrub.h               |  16 +---
 fs/xfs/scrub/symlink.c             |  16 +---
 fs/xfs/scrub/trace.c               |  16 +---
 fs/xfs/scrub/trace.h               |  16 +---
 fs/xfs/scrub/xfs_scrub.h           |  16 +---
 fs/xfs/xfs.h                       |  14 +--
 fs/xfs/xfs_acl.c                   |  14 +--
 fs/xfs/xfs_acl.h                   |  14 +--
 fs/xfs/xfs_aops.c                  |  25 +++---
 fs/xfs/xfs_aops.h                  |  14 +--
 fs/xfs/xfs_attr.h                  |  14 +--
 fs/xfs/xfs_attr_inactive.c         |  14 +--
 fs/xfs/xfs_attr_list.c             |  19 +---
 fs/xfs/xfs_bmap_item.c             |  16 +---
 fs/xfs/xfs_bmap_item.h             |  16 +---
 fs/xfs/xfs_bmap_util.c             |  26 ++----
 fs/xfs/xfs_bmap_util.h             |  14 +--
 fs/xfs/xfs_buf.c                   |  15 +---
 fs/xfs/xfs_buf.h                   |  14 +--
 fs/xfs/xfs_buf_item.c              |  16 +---
 fs/xfs/xfs_buf_item.h              |  14 +--
 fs/xfs/xfs_dir2_readdir.c          |  14 +--
 fs/xfs/xfs_discard.c               |  14 +--
 fs/xfs/xfs_dquot.c                 |  14 +--
 fs/xfs/xfs_dquot.h                 |  14 +--
 fs/xfs/xfs_dquot_item.c            |  14 +--
 fs/xfs/xfs_dquot_item.h            |  14 +--
 fs/xfs/xfs_error.c                 |  19 +---
 fs/xfs/xfs_error.h                 |  23 ++---
 fs/xfs/xfs_export.c                |  29 +++----
 fs/xfs/xfs_export.h                |  14 +--
 fs/xfs/xfs_extent_busy.c           |  14 +--
 fs/xfs/xfs_extent_busy.h           |  14 +--
 fs/xfs/xfs_extfree_item.c          |  14 +--
 fs/xfs/xfs_extfree_item.h          |  14 +--
 fs/xfs/xfs_file.c                  |  14 +--
 fs/xfs/xfs_filestream.c            |  14 +--
 fs/xfs/xfs_filestream.h            |  14 +--
 fs/xfs/xfs_fsmap.c                 |  16 +---
 fs/xfs/xfs_fsmap.h                 |  16 +---
 fs/xfs/xfs_fsops.c                 |  14 +--
 fs/xfs/xfs_fsops.h                 |  14 +--
 fs/xfs/xfs_globals.c               |  14 +--
 fs/xfs/xfs_icache.c                |  14 +--
 fs/xfs/xfs_icache.h                |  14 +--
 fs/xfs/xfs_icreate_item.c          |  14 +--
 fs/xfs/xfs_icreate_item.h          |  14 +--
 fs/xfs/xfs_inode.c                 |  35 ++++----
 fs/xfs/xfs_inode.h                 |  14 +--
 fs/xfs/xfs_inode_item.c            |  14 +--
 fs/xfs/xfs_inode_item.h            |  14 +--
 fs/xfs/xfs_ioctl.c                 |  33 +++----
 fs/xfs/xfs_ioctl.h                 |  14 +--
 fs/xfs/xfs_ioctl32.c               |  14 +--
 fs/xfs/xfs_ioctl32.h               |  14 +--
 fs/xfs/xfs_iomap.c                 |  20 +----
 fs/xfs/xfs_iomap.h                 |  18 +---
 fs/xfs/xfs_iops.c                  |  22 ++---
 fs/xfs/xfs_iops.h                  |  14 +--
 fs/xfs/xfs_itable.c                |  16 +---
 fs/xfs/xfs_itable.h                |  14 +--
 fs/xfs/xfs_linux.h                 |  36 +-------
 fs/xfs/xfs_log.c                   |  18 +---
 fs/xfs/xfs_log.h                   |  14 +--
 fs/xfs/xfs_log_cil.c               |  14 +--
 fs/xfs/xfs_log_priv.h              |  14 +--
 fs/xfs/xfs_log_recover.c           |  67 ++++++++------
 fs/xfs/xfs_message.c               |  14 +--
 fs/xfs/xfs_mount.c                 |  21 ++---
 fs/xfs/xfs_mount.h                 |  16 +---
 fs/xfs/xfs_mru_cache.c             |  14 +--
 fs/xfs/xfs_mru_cache.h             |  14 +--
 fs/xfs/xfs_ondisk.h                |  14 +--
 fs/xfs/xfs_qm.c                    |  14 +--
 fs/xfs/xfs_qm.h                    |  14 +--
 fs/xfs/xfs_qm_bhv.c                |  14 +--
 fs/xfs/xfs_qm_syscalls.c           |  14 +--
 fs/xfs/xfs_quota.h                 |  14 +--
 fs/xfs/xfs_quotaops.c              |  14 +--
 fs/xfs/xfs_refcount_item.c         |  16 +---
 fs/xfs/xfs_refcount_item.h         |  16 +---
 fs/xfs/xfs_reflink.c               |  16 +---
 fs/xfs/xfs_reflink.h               |  16 +---
 fs/xfs/xfs_rmap_item.c             |  16 +---
 fs/xfs/xfs_rmap_item.h             |  16 +---
 fs/xfs/xfs_rtalloc.c               |  24 ++---
 fs/xfs/xfs_rtalloc.h               |  14 +--
 fs/xfs/xfs_stats.c                 |  14 +--
 fs/xfs/xfs_stats.h                 |  14 +--
 fs/xfs/xfs_super.c                 |  16 +---
 fs/xfs/xfs_super.h                 |  14 +--
 fs/xfs/xfs_symlink.c               |  14 +--
 fs/xfs/xfs_symlink.h               |  14 +--
 fs/xfs/xfs_sysctl.c                |  14 +--
 fs/xfs/xfs_sysctl.h                |  14 +--
 fs/xfs/xfs_sysfs.c                 |  14 +--
 fs/xfs/xfs_sysfs.h                 |  14 +--
 fs/xfs/xfs_trace.c                 |  14 +--
 fs/xfs/xfs_trace.h                 |  14 +--
 fs/xfs/xfs_trans.c                 |  14 +--
 fs/xfs/xfs_trans.h                 |  14 +--
 fs/xfs/xfs_trans_ail.c             |  14 +--
 fs/xfs/xfs_trans_bmap.c            |  16 +---
 fs/xfs/xfs_trans_buf.c             |  14 +--
 fs/xfs/xfs_trans_dquot.c           |  14 +--
 fs/xfs/xfs_trans_extfree.c         |  14 +--
 fs/xfs/xfs_trans_inode.c           |  14 +--
 fs/xfs/xfs_trans_priv.h            |  14 +--
 fs/xfs/xfs_trans_refcount.c        |  16 +---
 fs/xfs/xfs_trans_rmap.c            |  16 +---
 fs/xfs/xfs_xattr.c                 |  14 +--
 207 files changed, 937 insertions(+), 3195 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_types.c
