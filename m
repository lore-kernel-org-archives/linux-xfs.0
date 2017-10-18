Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28160 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbdJRXAH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 19:00:07 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9IN06IS011835
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 23:00:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9IN06aa030519
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 23:00:06 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9IN06pJ006454
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 23:00:06 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 00/17] Parent Pointers V3
Date: Wed, 18 Oct 2017 15:55:16 -0700
Message-Id: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

Hi all,

This is the third version of parent pointer attributes for xfs.
I've integrated the suggestions made since v2, mostly moving the
attr buffers in the xfs_attr_log_item to pointers that point to
xfs_attr_item. I've also implementing the recovery routines for
the xfs_attr_log_format.  If I missed anything please point it
out.  As always, comments and feedback are appreciated.  Thank
you!

Allison Henderson (7):
  Add helper functions xfs_attr_set_args and xfs_attr_remove_args
  Set up infastructure for deferred attribute operations
  Add xfs_attr_set_defered and xfs_attr_remove_defered
  Remove all strlen calls in all xfs_attr_* functions for attr names.
  Add the extra space requirements for parent pointer attributes when
    calculating the minimum log size during mkfs
  Add parent pointers to rename
  Add the parent pointer support to the superblock version 5.

Brian Foster (1):
  xfs_bmap_add_attrfork(): re-add error handling from set_attrforkoff()
    call

Dave Chinner (5):
  xfs: define parent pointer xattr format
  :xfs: extent transaction reservations for parent attributes
  xfs: parent pointer attribute creation
  xfs: add parent attributes to link
  xfs: remove parent pointers in unlink

Mark Tinguely (4):
  xfs: get directory offset when adding directory name
  xfs: get directory offset when removing directory name
  xfs: get directory offset when replacing a directory name
  xfs: add parent pointer support to attribute code

 fs/xfs/Makefile                |   3 +
 fs/xfs/libxfs/xfs_attr.c       | 476 +++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_bmap.c       |  51 ++--
 fs/xfs/libxfs/xfs_bmap.h       |   1 +
 fs/xfs/libxfs/xfs_da_btree.h   |   1 +
 fs/xfs/libxfs/xfs_da_format.h  |  12 +-
 fs/xfs/libxfs/xfs_defer.h      |   1 +
 fs/xfs/libxfs/xfs_dir2.c       |  41 ++--
 fs/xfs/libxfs/xfs_dir2.h       |  10 +-
 fs/xfs/libxfs/xfs_dir2_block.c |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   6 +
 fs/xfs/libxfs/xfs_format.h     |  37 ++-
 fs/xfs/libxfs/xfs_fs.h         |   1 +
 fs/xfs/libxfs/xfs_log_format.h |  36 ++-
 fs/xfs/libxfs/xfs_log_rlimit.c |  34 +++
 fs/xfs/libxfs/xfs_parent.c     | 163 +++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.c | 103 +++++++--
 fs/xfs/libxfs/xfs_types.h      |   1 +
 fs/xfs/xfs_acl.c               |  12 +-
 fs/xfs/xfs_attr.h              |  68 +++++-
 fs/xfs/xfs_attr_item.c         | 512 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h         | 111 +++++++++
 fs/xfs/xfs_fsops.c             |   4 +-
 fs/xfs/xfs_inode.c             | 146 +++++++++---
 fs/xfs/xfs_ioctl.c             |  13 +-
 fs/xfs/xfs_iops.c              |   6 +-
 fs/xfs/xfs_log_recover.c       | 140 +++++++++++
 fs/xfs/xfs_qm.c                |   2 +-
 fs/xfs/xfs_qm.h                |   1 +
 fs/xfs/xfs_super.c             |   1 +
 fs/xfs/xfs_symlink.c           |   2 +-
 fs/xfs/xfs_trans.h             |  13 ++
 fs/xfs/xfs_trans_attr.c        | 286 +++++++++++++++++++++++
 fs/xfs/xfs_xattr.c             |  10 +-
 36 files changed, 2064 insertions(+), 265 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h
 create mode 100644 fs/xfs/xfs_trans_attr.c

-- 
2.7.4

