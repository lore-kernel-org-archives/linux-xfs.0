Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44352 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfFYSGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 14:06:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PI4aKI161101
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 18:06:07 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t9cyqdxrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 18:06:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PI5rXr151225
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 18:06:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t99f418b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 18:06:06 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5PI663s008287
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 18:06:06 GMT
Date: Tue, 25 Jun 2019 11:06:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 51e5b03c638c
Message-ID: <20190625180604.GD2230847@magnolia>
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
the next update.  I'm still processing patches, but here's an
intermediate update with Christoph's huge log rework.

The new head of the for-next branch is commit:

51e5b03c638c xfs: always update params on small allocation

New Commits:

Brian Foster (4):
      [607d6a8b71d7] xfs: clean up small allocation helper
      [55e6bea2cf45] xfs: move small allocation helper
      [973c566e2979] xfs: skip small alloc cntbt logic on NULL cursor
      [51e5b03c638c] xfs: always update params on small allocation

Christoph Hellwig (43):
      [79dbb509bd9d] xfs: remove the no-op spinlock_destroy stub
      [ce63ec752502] xfs: remove the never used _XBF_COMPOUND flag
      [abe7ba628554] xfs: renumber XBF_WRITE_FAIL
      [8638681a5959] xfs: make mem_to_page available outside of xfs_buf.c
      [057e42629d7e] xfs: remove the l_iclog_size_log field from struct xlog
      [db834153a802] xfs: cleanup xlog_get_iclog_buffer_size
      [03f6a6e2c404] xfs: reformat xlog_get_lowest_lsn
      [0c953217d2c8] xfs: remove XLOG_STATE_IOABORT
      [f21c95458883] xfs: don't use REQ_PREFLUSH for split log writes
      [f855a253fc58] xfs: factor out log buffer writing from xlog_sync
      [f2e27fe1cb8d] xfs: factor out splitting of an iclog from xlog_sync
      [042c915a7def] xfs: factor out iclog size calculation from xlog_sync
      [437d733c353b] xfs: update both stat counters together in xlog_sync
      [ad675dd010a9] xfs: remove the syncing argument from xlog_verify_iclog
      [4436e5ea23b4] xfs: make use of the l_targ field in struct xlog
      [991fc1d2e65e] xfs: use bios directly to write log buffers
      [87b57226fbb1] xfs: move the log ioend workqueue to struct xlog
      [73f9303f75a6] xfs: return an offset instead of a pointer from xlog_align
      [34b63ea5fbb9] xfs: use bios directly to read and write the log recovery buffers
      [1574fe9d3acb] xfs: stop using bp naming for log recovery buffers
      [1fe4e876776e] xfs: remove unused buffer cache APIs
      [8449fb6c7bc0] xfs: properly type the b_log_item field in struct xfs_buf
      [0abcce43173d] xfs: remove the b_io_length field in struct xfs_buf
      [f786cc1941c9] xfs: add struct xfs_mount pointer to struct xfs_buf
      [59a47237f460] xfs: fix a trivial comment typo in xfs_trans_committed_bulk
      [2ba694b183a9] xfs: stop using XFS_LI_ABORTED as a parameter flag
      [21e6d72e79ac] xfs: don't require log items to implement optional methods
      [7d8457cfb985] xfs: remove the dummy iop_push implementation for inode creation items
      [3e090ad30cab] xfs: don't use xfs_trans_free_items in the commit path
      [9e1ec270f04e] xfs: split iop_unlock
      [39e4c1956418] xfs: add a flag to release log items on commit
      [c40a409ce757] xfs: don't cast inode_log_items to get the log_item
      [d4f4a956c1c6] xfs: remove the xfs_log_item_t typedef
      [a3f9ea57dfc6] xfs: use a list_head for iclog callbacks
      [a97f5a011f18] xfs: remove a pointless comment duplicated above all xfs_item_ops instances
      [82f36a3eabfb] xfs: merge xfs_efd_init into xfs_trans_get_efd
      [febd67b9df1a] xfs: merge xfs_cud_init into xfs_trans_get_cud
      [86a5ee2fb4cc] xfs: merge xfs_rud_init into xfs_trans_get_rud
      [a9bf4634536a] xfs: merge xfs_bud_init into xfs_trans_get_bud
      [ba6526844a15] xfs: merge xfs_trans_extfree.c into xfs_extfree_item.c
      [fa8dae390b78] xfs: merge xfs_trans_refcount.c into xfs_refcount_item.c
      [d8935d8504c1] xfs: merge xfs_trans_rmap.c into xfs_rmap_item.c
      [c3641fa71cc2] xfs: merge xfs_trans_bmap.c into xfs_bmap_item.c

Darrick J. Wong (2):
      [6bab14e56855] xfs: claim maintainership of loose files
      [5f36924d9d6a] xfs: move xfs_ino_geometry to xfs_shared.h


Code Diffstat:

 .../filesystems/xfs-self-describing-metadata.txt   |   8 +-
 MAINTAINERS                                        |   6 +
 fs/xfs/Makefile                                    |   7 +-
 fs/xfs/kmem.h                                      |   8 +
 fs/xfs/libxfs/xfs_alloc.c                          | 221 ++++----
 fs/xfs/libxfs/xfs_alloc_btree.c                    |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  12 +-
 fs/xfs/libxfs/xfs_attr_remote.c                    |   4 +-
 fs/xfs/libxfs/xfs_bmap_btree.c                     |   2 +-
 fs/xfs/libxfs/xfs_btree.c                          |  16 +-
 fs/xfs/libxfs/xfs_da_btree.c                       |   6 +-
 fs/xfs/libxfs/xfs_dir2.c                           |   1 +
 fs/xfs/libxfs/xfs_dir2_block.c                     |   7 +-
 fs/xfs/libxfs/xfs_dir2_data.c                      |  10 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c                      |   7 +-
 fs/xfs/libxfs/xfs_dir2_node.c                      |   7 +-
 fs/xfs/libxfs/xfs_dir2_sf.c                        |   1 +
 fs/xfs/libxfs/xfs_dquot_buf.c                      |   8 +-
 fs/xfs/libxfs/xfs_format.h                         |  41 --
 fs/xfs/libxfs/xfs_ialloc.c                         |   6 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |   2 +-
 fs/xfs/libxfs/xfs_iext_tree.c                      |   1 +
 fs/xfs/libxfs/xfs_inode_buf.c                      |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.c                     |   1 +
 fs/xfs/libxfs/xfs_refcount_btree.c                 |   2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                     |   2 +-
 fs/xfs/libxfs/xfs_sb.c                             |   4 +-
 fs/xfs/libxfs/xfs_shared.h                         |  42 ++
 fs/xfs/libxfs/xfs_symlink_remote.c                 |   6 +-
 fs/xfs/xfs_acl.c                                   |   1 +
 fs/xfs/xfs_attr_inactive.c                         |   2 +-
 fs/xfs/xfs_attr_list.c                             |   1 +
 fs/xfs/xfs_bio_io.c                                |  61 ++
 fs/xfs/xfs_bmap_item.c                             | 348 +++++++-----
 fs/xfs/xfs_bmap_item.h                             |   2 -
 fs/xfs/xfs_buf.c                                   | 130 +----
 fs/xfs/xfs_buf.h                                   |  37 +-
 fs/xfs/xfs_buf_item.c                              |  37 +-
 fs/xfs/xfs_buf_item.h                              |   6 +-
 fs/xfs/xfs_dir2_readdir.c                          |   1 +
 fs/xfs/xfs_discard.c                               |   1 +
 fs/xfs/xfs_dquot_item.c                            | 112 +---
 fs/xfs/xfs_dquot_item.h                            |   4 +-
 fs/xfs/xfs_error.c                                 |   3 +-
 fs/xfs/xfs_export.c                                |   1 +
 fs/xfs/xfs_extfree_item.c                          | 410 ++++++++-----
 fs/xfs/xfs_extfree_item.h                          |   6 +-
 fs/xfs/xfs_filestream.c                            |   1 +
 fs/xfs/xfs_icache.c                                |   1 +
 fs/xfs/xfs_icreate_item.c                          |  70 +--
 fs/xfs/xfs_inode.c                                 |  16 +-
 fs/xfs/xfs_inode_item.c                            |  15 +-
 fs/xfs/xfs_inode_item.h                            |   2 +-
 fs/xfs/xfs_ioctl32.c                               |   1 +
 fs/xfs/xfs_linux.h                                 |   5 +-
 fs/xfs/xfs_log.c                                   | 631 +++++++++------------
 fs/xfs/xfs_log.h                                   |  15 +-
 fs/xfs/xfs_log_cil.c                               |  48 +-
 fs/xfs/xfs_log_priv.h                              |  34 +-
 fs/xfs/xfs_log_recover.c                           | 426 ++++++--------
 fs/xfs/xfs_message.c                               |   1 +
 fs/xfs/xfs_mount.h                                 |   1 -
 fs/xfs/xfs_pnfs.c                                  |   1 +
 fs/xfs/xfs_qm_bhv.c                                |   1 +
 fs/xfs/xfs_quotaops.c                              |   1 +
 fs/xfs/xfs_refcount_item.c                         | 356 +++++++-----
 fs/xfs/xfs_refcount_item.h                         |   2 -
 fs/xfs/xfs_rmap_item.c                             | 379 ++++++++-----
 fs/xfs/xfs_rmap_item.h                             |   2 -
 fs/xfs/xfs_super.c                                 |  11 +-
 fs/xfs/xfs_trace.h                                 |   3 +-
 fs/xfs/xfs_trans.c                                 |  36 +-
 fs/xfs/xfs_trans.h                                 |  68 +--
 fs/xfs/xfs_trans_ail.c                             |  53 +-
 fs/xfs/xfs_trans_bmap.c                            | 232 --------
 fs/xfs/xfs_trans_buf.c                             |   2 +-
 fs/xfs/xfs_trans_extfree.c                         | 286 ----------
 fs/xfs/xfs_trans_priv.h                            |   4 +-
 fs/xfs/xfs_trans_refcount.c                        | 240 --------
 fs/xfs/xfs_trans_rmap.c                            | 257 ---------
 fs/xfs/xfs_xattr.c                                 |   1 +
 81 files changed, 1857 insertions(+), 2950 deletions(-)
 create mode 100644 fs/xfs/xfs_bio_io.c
 delete mode 100644 fs/xfs/xfs_trans_bmap.c
 delete mode 100644 fs/xfs/xfs_trans_extfree.c
 delete mode 100644 fs/xfs/xfs_trans_refcount.c
 delete mode 100644 fs/xfs/xfs_trans_rmap.c
