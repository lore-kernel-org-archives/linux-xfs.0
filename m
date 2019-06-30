Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbfF3QhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jun 2019 12:37:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5UGXm85138721
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2019 16:37:06 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2te61dt7yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2019 16:37:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5UGXRXX096495
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2019 16:37:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tebktbq4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2019 16:37:04 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5UGb3pk021420
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2019 16:37:04 GMT
Date: Sun, 30 Jun 2019 09:37:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 332b9caf2d7b
Message-ID: <20190630163700.GH1404256@magnolia>
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

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

This branch now includes the vfs and iomap changes that I'm proposing
for 5.3.

The new head of the for-next branch is commit:

332b9caf2d7b Merge remote-tracking branch 'korg/vfs-5.3-merge' into for-next-5.3

New Commits:

Amir Goldstein (7):
      [a31713517dac] vfs: introduce generic_file_rw_checks()
      [646955cd5425] vfs: remove redundant checks from generic_remap_checks()
      [96e6e8f4a68d] vfs: add missing checks to copy_file_range
      [e38f7f53c352] vfs: introduce file_modified() helper
      [8c3f406c097b] xfs: use file_modified() helper
      [5dae222a5ff0] vfs: allow copy_file_range to copy across devices
      [fe0da9c09b2d] fuse: copy_file_range needs to strip setuid bits and update timestamps

Andreas Gruenbacher (2):
      [8d3e72a180b4] iomap: don't mark the inode dirty in iomap_write_end
      [36a7347de097] iomap: fix page_done callback for short writes

Brian Foster (4):
      [2a4f35f984f0] xfs: clean up small allocation helper
      [c63cdd4fc9cc] xfs: move small allocation helper
      [6691cd9267c1] xfs: skip small alloc cntbt logic on NULL cursor
      [7e36a3a63d3e] xfs: always update params on small allocation

Christoph Hellwig (54):
      [f9a196ee5ab5] xfs: merge xfs_buf_zero and xfs_buf_iomove
      [76dee76921e1] xfs: remove the debug-only q_transp field from struct xfs_dquot
      [8af54f291e5c] fs: fold __generic_write_end back into generic_write_end
      [1e85a3670db2] xfs: remove the no-op spinlock_destroy stub
      [153fd7b57ca9] xfs: remove the never used _XBF_COMPOUND flag
      [ce89755cdfea] xfs: renumber XBF_WRITE_FAIL
      [72945d86ddec] xfs: make mem_to_page available outside of xfs_buf.c
      [76ce9823acf3] xfs: remove the l_iclog_size_log field from struct xlog
      [4f62282a3696] xfs: cleanup xlog_get_iclog_buffer_size
      [9bff313253eb] xfs: reformat xlog_get_lowest_lsn
      [366fc4b898b3] xfs: remove XLOG_STATE_IOABORT
      [1f9489be0257] xfs: don't use REQ_PREFLUSH for split log writes
      [94860a301b75] xfs: factor out log buffer writing from xlog_sync
      [5693384805ab] xfs: factor out splitting of an iclog from xlog_sync
      [db0a6faf938e] xfs: factor out iclog size calculation from xlog_sync
      [9b0489c1d191] xfs: update both stat counters together in xlog_sync
      [abca1f33f869] xfs: remove the syncing argument from xlog_verify_iclog
      [2d15d2c0e0f7] xfs: make use of the l_targ field in struct xlog
      [79b54d9bfcdc] xfs: use bios directly to write log buffers
      [1058d0f5eeb4] xfs: move the log ioend workqueue to struct xlog
      [18ffb8c3f0bf] xfs: return an offset instead of a pointer from xlog_align
      [6ad5b3255b9e] xfs: use bios directly to read and write the log recovery buffers
      [6e9b3dd80f9c] xfs: stop using bp naming for log recovery buffers
      [0564501ff5e7] xfs: remove unused buffer cache APIs
      [e99b4bd0cb04] xfs: properly type the b_log_item field in struct xfs_buf
      [8124b9b6011d] xfs: remove the b_io_length field in struct xfs_buf
      [dbd329f1e44e] xfs: add struct xfs_mount pointer to struct xfs_buf
      [086252c34bc2] xfs: fix a trivial comment typo in xfs_trans_committed_bulk
      [d15cbf2f38b2] xfs: stop using XFS_LI_ABORTED as a parameter flag
      [e8b78db77d48] xfs: don't require log items to implement optional methods
      [8e4b20ea83c2] xfs: remove the dummy iop_push implementation for inode creation items
      [195cd83d1b88] xfs: don't use xfs_trans_free_items in the commit path
      [ddf92053e45c] xfs: split iop_unlock
      [9ce632a28a41] xfs: add a flag to release log items on commit
      [b3b14aacc676] xfs: don't cast inode_log_items to get the log_item
      [efe2330fdc24] xfs: remove the xfs_log_item_t typedef
      [89ae379d564c] xfs: use a list_head for iclog callbacks
      [95cf0e4a0ddc] xfs: remove a pointless comment duplicated above all xfs_item_ops instances
      [9c5e7c2ae34b] xfs: merge xfs_efd_init into xfs_trans_get_efd
      [ebeb8e062906] xfs: merge xfs_cud_init into xfs_trans_get_cud
      [60883447f452] xfs: merge xfs_rud_init into xfs_trans_get_rud
      [73f0d23633c1] xfs: merge xfs_bud_init into xfs_trans_get_bud
      [81f400417351] xfs: merge xfs_trans_extfree.c into xfs_extfree_item.c
      [effd5e96e7d5] xfs: merge xfs_trans_refcount.c into xfs_refcount_item.c
      [3cfce1e3ce8e] xfs: merge xfs_trans_rmap.c into xfs_rmap_item.c
      [caeaea985832] xfs: merge xfs_trans_bmap.c into xfs_bmap_item.c
      [a24737359667] xfs: simplify xfs_chain_bio
      [adfb5fb46af0] xfs: implement cgroup aware writeback
      [89b171acb222] xfs: fix iclog allocation size
      [1fdafce55c2c] xfs: remove the unused xfs_count_page_state declaration
      [0290d9c1e56f] xfs: fix a comment typo in xfs_submit_ioend
      [7dbae9fbde8a] xfs: allow merging ioends over append boundaries
      [fe64e0d26b1c] xfs: simplify xfs_ioend_can_merge
      [73d30d48749f] xfs: remove XFS_TRANS_NOFS

Darrick J. Wong (16):
      [ef325959993e] xfs: separate inode geometry
      [494dba7b276e] xfs: refactor inode geometry setup routines
      [490d451fa518] xfs: fix inode_cluster_size rounding mayhem
      [4b4d98cca320] xfs: finish converting to inodes_per_cluster
      [6dba88870c23] xfs: claim maintainership of loose files
      [5467b34bd1e8] xfs: move xfs_ino_geometry to xfs_shared.h
      [8d90857cff44] xfs: refactor free space btree record initialization
      [f327a00745ff] xfs: account for log space when formatting new AGs
      [de2baa49bbae] vfs: create a generic checking and prep function for FS_IOC_SETFLAGS
      [3dd3ba36a8ee] vfs: create a generic checking function for FS_IOC_FSSETXATTR
      [0e9441bc8f9a] vfs: teach vfs_ioc_fssetxattr_check to check project id info
      [3437d21bc130] vfs: teach vfs_ioc_fssetxattr_check to check extent size hints
      [8af74d044d73] vfs: only allow FSSETXATTR to set DAX flag on files and dirs
      [875e1b258e17] mm/fs: don't allow writes to immutable files
      [345df584ff3e] Merge remote-tracking branch 'korg/iomap-5.3-merge' into for-next-5.3
      [332b9caf2d7b] Merge remote-tracking branch 'korg/vfs-5.3-merge' into for-next-5.3

Dave Chinner (2):
      [f16acc9d9b37] vfs: introduce generic_copy_file_range()
      [64bf5ff58dff] vfs: no fallback for ->copy_file_range

Eric Sandeen (4):
      [d03a2f1b9fa8] xfs: include WARN, REPAIR build options in XFS_BUILD_OPTIONS
      [8c9ce2f707a1] xfs: remove unused flags arg from getsb interfaces
      [f5b999c03f4c] xfs: remove unused flag arguments
      [250d4b4c4097] xfs: remove unused header files


Code Diffstat:

 .../filesystems/xfs-self-describing-metadata.txt   |   8 +-
 MAINTAINERS                                        |   6 +
 fs/attr.c                                          |  13 +-
 fs/btrfs/ioctl.c                                   |  30 +-
 fs/buffer.c                                        |  62 +-
 fs/ceph/file.c                                     |  23 +-
 fs/cifs/cifsfs.c                                   |   4 +
 fs/efivarfs/file.c                                 |  26 +-
 fs/ext2/ioctl.c                                    |  16 +-
 fs/ext4/ioctl.c                                    |  51 +-
 fs/f2fs/file.c                                     |  53 +-
 fs/fuse/file.c                                     |  29 +-
 fs/gfs2/bmap.c                                     |   2 +
 fs/gfs2/file.c                                     |  42 +-
 fs/hfsplus/ioctl.c                                 |  21 +-
 fs/inode.c                                         | 106 ++++
 fs/internal.h                                      |   2 -
 fs/iomap.c                                         |  17 +-
 fs/jfs/ioctl.c                                     |  22 +-
 fs/nfs/nfs4file.c                                  |  23 +-
 fs/nilfs2/ioctl.c                                  |   9 +-
 fs/ocfs2/ioctl.c                                   |  13 +-
 fs/orangefs/file.c                                 |  35 +-
 fs/read_write.c                                    | 124 ++--
 fs/reiserfs/ioctl.c                                |  10 +-
 fs/ubifs/ioctl.c                                   |  13 +-
 fs/xfs/Makefile                                    |   7 +-
 fs/xfs/kmem.c                                      |   5 -
 fs/xfs/kmem.h                                      |   8 +
 fs/xfs/libxfs/xfs_ag.c                             | 100 +++-
 fs/xfs/libxfs/xfs_ag_resv.c                        |   8 -
 fs/xfs/libxfs/xfs_alloc.c                          | 225 ++++----
 fs/xfs/libxfs/xfs_alloc_btree.c                    |   3 +-
 fs/xfs/libxfs/xfs_attr.c                           |   5 -
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  15 +-
 fs/xfs/libxfs/xfs_attr_remote.c                    |  14 +-
 fs/xfs/libxfs/xfs_bit.c                            |   1 -
 fs/xfs/libxfs/xfs_bmap.c                           |  19 +-
 fs/xfs/libxfs/xfs_bmap_btree.c                     |   5 +-
 fs/xfs/libxfs/xfs_btree.c                          |  49 +-
 fs/xfs/libxfs/xfs_btree.h                          |  10 +-
 fs/xfs/libxfs/xfs_da_btree.c                       |  12 +-
 fs/xfs/libxfs/xfs_da_format.c                      |   3 -
 fs/xfs/libxfs/xfs_defer.c                          |   2 -
 fs/xfs/libxfs/xfs_dir2.c                           |   6 +-
 fs/xfs/libxfs/xfs_dir2_block.c                     |  11 +-
 fs/xfs/libxfs/xfs_dir2_data.c                      |  14 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c                      |  11 +-
 fs/xfs/libxfs/xfs_dir2_node.c                      |  10 +-
 fs/xfs/libxfs/xfs_dir2_sf.c                        |   5 +-
 fs/xfs/libxfs/xfs_dquot_buf.c                      |  10 +-
 fs/xfs/libxfs/xfs_format.h                         |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c                         | 245 +++++---
 fs/xfs/libxfs/xfs_ialloc.h                         |  18 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |  19 +-
 fs/xfs/libxfs/xfs_iext_tree.c                      |   6 +-
 fs/xfs/libxfs/xfs_inode_buf.c                      |   9 +-
 fs/xfs/libxfs/xfs_inode_fork.c                     |   4 +-
 fs/xfs/libxfs/xfs_log_rlimit.c                     |   2 -
 fs/xfs/libxfs/xfs_refcount.c                       |   2 -
 fs/xfs/libxfs/xfs_refcount_btree.c                 |   4 +-
 fs/xfs/libxfs/xfs_rmap.c                           |   7 -
 fs/xfs/libxfs/xfs_rmap_btree.c                     |   6 +-
 fs/xfs/libxfs/xfs_rtbitmap.c                       |   8 -
 fs/xfs/libxfs/xfs_sb.c                             |  39 +-
 fs/xfs/libxfs/xfs_shared.h                         |  43 +-
 fs/xfs/libxfs/xfs_symlink_remote.c                 |  10 +-
 fs/xfs/libxfs/xfs_trans_resv.c                     |  17 +-
 fs/xfs/libxfs/xfs_trans_space.h                    |   7 +-
 fs/xfs/libxfs/xfs_types.c                          |  13 +-
 fs/xfs/scrub/agheader.c                            |   7 -
 fs/xfs/scrub/agheader_repair.c                     |   5 -
 fs/xfs/scrub/alloc.c                               |   7 -
 fs/xfs/scrub/attr.c                                |  10 -
 fs/xfs/scrub/bitmap.c                              |   5 -
 fs/xfs/scrub/bmap.c                                |   8 -
 fs/xfs/scrub/btree.c                               |   7 -
 fs/xfs/scrub/common.c                              |   8 -
 fs/xfs/scrub/dabtree.c                             |   8 -
 fs/xfs/scrub/dir.c                                 |  10 -
 fs/xfs/scrub/fscounters.c                          |  12 -
 fs/xfs/scrub/health.c                              |   8 -
 fs/xfs/scrub/ialloc.c                              |  28 +-
 fs/xfs/scrub/inode.c                               |  10 -
 fs/xfs/scrub/parent.c                              |   8 -
 fs/xfs/scrub/quota.c                               |  13 +-
 fs/xfs/scrub/refcount.c                            |  10 -
 fs/xfs/scrub/repair.c                              |  10 +-
 fs/xfs/scrub/rmap.c                                |   9 -
 fs/xfs/scrub/rtbitmap.c                            |   7 -
 fs/xfs/scrub/scrub.c                               |  20 -
 fs/xfs/scrub/symlink.c                             |   8 -
 fs/xfs/scrub/trace.c                               |   6 -
 fs/xfs/xfs_acl.c                                   |   4 +-
 fs/xfs/xfs_aops.c                                  | 121 ++--
 fs/xfs/xfs_aops.h                                  |   1 -
 fs/xfs/xfs_attr_inactive.c                         |   7 +-
 fs/xfs/xfs_attr_list.c                             |   7 +-
 fs/xfs/xfs_bio_io.c                                |  61 ++
 fs/xfs/xfs_bmap_item.c                             | 350 +++++++-----
 fs/xfs/xfs_bmap_item.h                             |   2 -
 fs/xfs/xfs_bmap_util.c                             |  11 +-
 fs/xfs/xfs_buf.c                                   | 171 +-----
 fs/xfs/xfs_buf.h                                   |  53 +-
 fs/xfs/xfs_buf_item.c                              |  40 +-
 fs/xfs/xfs_buf_item.h                              |   6 +-
 fs/xfs/xfs_dir2_readdir.c                          |   5 +-
 fs/xfs/xfs_discard.c                               |   4 +-
 fs/xfs/xfs_dquot.c                                 |   4 -
 fs/xfs/xfs_dquot.h                                 |   1 -
 fs/xfs/xfs_dquot_item.c                            | 118 +---
 fs/xfs/xfs_dquot_item.h                            |   4 +-
 fs/xfs/xfs_error.c                                 |   3 +-
 fs/xfs/xfs_export.c                                |   4 +-
 fs/xfs/xfs_extfree_item.c                          | 410 ++++++++-----
 fs/xfs/xfs_extfree_item.h                          |   6 +-
 fs/xfs/xfs_file.c                                  |  38 +-
 fs/xfs/xfs_filestream.c                            |   5 +-
 fs/xfs/xfs_fsmap.c                                 |   4 -
 fs/xfs/xfs_fsops.c                                 |   8 +-
 fs/xfs/xfs_globals.c                               |   1 -
 fs/xfs/xfs_health.c                                |   4 -
 fs/xfs/xfs_icache.c                                |   4 +-
 fs/xfs/xfs_icreate_item.c                          |  75 +--
 fs/xfs/xfs_inode.c                                 |  42 +-
 fs/xfs/xfs_inode_item.c                            |  16 +-
 fs/xfs/xfs_inode_item.h                            |   2 +-
 fs/xfs/xfs_ioctl.c                                 | 163 +++---
 fs/xfs/xfs_ioctl32.c                               |   7 +-
 fs/xfs/xfs_iomap.c                                 |   5 +-
 fs/xfs/xfs_iops.c                                  |  10 -
 fs/xfs/xfs_itable.c                                |  12 +-
 fs/xfs/xfs_linux.h                                 |   5 +-
 fs/xfs/xfs_log.c                                   | 636 +++++++++------------
 fs/xfs/xfs_log.h                                   |  15 +-
 fs/xfs/xfs_log_cil.c                               |  51 +-
 fs/xfs/xfs_log_priv.h                              |  34 +-
 fs/xfs/xfs_log_recover.c                           | 451 ++++++---------
 fs/xfs/xfs_message.c                               |   2 +-
 fs/xfs/xfs_mount.c                                 | 102 +---
 fs/xfs/xfs_mount.h                                 |  22 +-
 fs/xfs/xfs_pnfs.c                                  |   9 +-
 fs/xfs/xfs_qm.c                                    |   4 -
 fs/xfs/xfs_qm_bhv.c                                |   2 +-
 fs/xfs/xfs_qm_syscalls.c                           |   5 -
 fs/xfs/xfs_quotaops.c                              |   3 +-
 fs/xfs/xfs_refcount_item.c                         | 357 +++++++-----
 fs/xfs/xfs_refcount_item.h                         |   2 -
 fs/xfs/xfs_reflink.c                               |  15 +-
 fs/xfs/xfs_rmap_item.c                             | 380 +++++++-----
 fs/xfs/xfs_rmap_item.h                             |   2 -
 fs/xfs/xfs_rtalloc.c                               |   6 -
 fs/xfs/xfs_stats.c                                 |   1 -
 fs/xfs/xfs_super.c                                 |  32 +-
 fs/xfs/xfs_super.h                                 |  14 +
 fs/xfs/xfs_symlink.c                               |   9 -
 fs/xfs/xfs_sysctl.c                                |   3 -
 fs/xfs/xfs_sysfs.c                                 |   2 -
 fs/xfs/xfs_trace.c                                 |   8 -
 fs/xfs/xfs_trace.h                                 |   3 +-
 fs/xfs/xfs_trans.c                                 |  43 +-
 fs/xfs/xfs_trans.h                                 |  70 +--
 fs/xfs/xfs_trans_ail.c                             |  53 +-
 fs/xfs/xfs_trans_bmap.c                            | 232 --------
 fs/xfs/xfs_trans_buf.c                             |  11 +-
 fs/xfs/xfs_trans_dquot.c                           |  11 -
 fs/xfs/xfs_trans_extfree.c                         | 286 ---------
 fs/xfs/xfs_trans_inode.c                           |   3 -
 fs/xfs/xfs_trans_priv.h                            |   4 +-
 fs/xfs/xfs_trans_refcount.c                        | 240 --------
 fs/xfs/xfs_trans_rmap.c                            | 257 ---------
 fs/xfs/xfs_xattr.c                                 |   5 +-
 include/linux/fs.h                                 |  21 +
 include/linux/iomap.h                              |   1 +
 mm/filemap.c                                       | 113 +++-
 mm/memory.c                                        |   4 +
 mm/mmap.c                                          |   8 +-
 177 files changed, 2970 insertions(+), 4359 deletions(-)
 create mode 100644 fs/xfs/xfs_bio_io.c
 delete mode 100644 fs/xfs/xfs_trans_bmap.c
 delete mode 100644 fs/xfs/xfs_trans_extfree.c
 delete mode 100644 fs/xfs/xfs_trans_refcount.c
 delete mode 100644 fs/xfs/xfs_trans_rmap.c
