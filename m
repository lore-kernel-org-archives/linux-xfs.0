Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55256 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbeIZQ3e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:29:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QAE1Un065206
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:19 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2mnd5thhq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:19 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAHIqO009651
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:18 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAHHas019479
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:17:17 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v9 00/28] Parent Pointers v9
Date: Wed, 26 Sep 2018 03:14:39 -0700
Message-Id: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is the 9th version of parent pointer attributes for xfs. The goal of
this patch set is to add a parent pointer attribute to each inode.  The
attribute name containing the parent inode, generation, and directory offset,
while the  attribute value contains the file name.  This feature will enable
future optimizations for online scrub, or any other feature that could make
use of quickly deriving an inodes path from  the mount point.  

Some points of interest since v8:
I've integrated the feed back from v8 and reworked the xfs_parent_add routine
in patch 20 which is used in the corresponding xfsprogs set.  I try to push all
three sets at once since sometimes changes in one set can affect the others.  
Most of the activity this time is in xfsprogs and xfstests.  So feedback
there appreciated!  As usual folks are welcome to go through any part of it, but
I know it's a lot.  Thanks again everyone!

Allison

Allison Henderson (19):
  xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
  xfs: Add helper function xfs_attr_try_sf_addname
  xfs: Add attibute set and helper functions
  xfs: Add attibute remove and helper functions
  xfs: Hold inode locks in xfs_ialloc
  xfs: Add trans toggle to attr routines
  xfs: Set up infastructure for deferred attribute operations
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Add xfs_has_attr and subroutines
  xfs: Add attr context to log item
  xfs: Roll delayed attr operations by returning EAGAIN
  xfs: Remove roll_trans boolean
  xfs: Remove all strlen calls in all xfs_attr_* functions for attr
    names.
  xfs: Add parent pointers to rename
  xfs: Add the parent pointer support to the superblock version 5.
  xfs: Add helper function xfs_attr_list_context_init
  xfs: Increase  XFS_DEFER_OPS_NR_INODES to 4
  xfs: Add parent pointer ioctl
  xfs: Add delayed attributes error tag

Dave Chinner (5):
  xfs: define parent pointer xattr format
  xfs: extent transaction reservations for parent attributes
  xfs: parent pointer attribute creation
  xfs: add parent attributes to link
  xfs: remove parent pointers in unlink

Mark Tinguely (4):
  xfs: get directory offset when adding directory name
  xfs: get directory offset when removing directory name
  xfs: get directory offset when replacing a directory name
  xfs: add parent pointer support to attribute code

 fs/xfs/Makefile                 |   4 +
 fs/xfs/libxfs/xfs_attr.c        | 495 ++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_attr.h        | 205 ++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |  48 +++-
 fs/xfs/libxfs/xfs_attr_leaf.h   |   3 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  20 --
 fs/xfs/libxfs/xfs_bmap.c        |  49 ++--
 fs/xfs/libxfs/xfs_bmap.h        |   1 +
 fs/xfs/libxfs/xfs_da_btree.h    |   1 +
 fs/xfs/libxfs/xfs_da_format.h   |  37 ++-
 fs/xfs/libxfs/xfs_defer.h       |   1 +
 fs/xfs/libxfs/xfs_dir2.c        |  21 +-
 fs/xfs/libxfs/xfs_dir2.h        |   7 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c   |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |   6 +
 fs/xfs/libxfs/xfs_errortag.h    |   4 +-
 fs/xfs/libxfs/xfs_format.h      |  10 +-
 fs/xfs/libxfs/xfs_fs.h          |  46 ++++
 fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
 fs/xfs/libxfs/xfs_parent.c      | 197 +++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  37 +++
 fs/xfs/libxfs/xfs_sb.c          |   2 +
 fs/xfs/libxfs/xfs_trans_resv.c  | 111 ++++++--
 fs/xfs/libxfs/xfs_trans_resv.h  |   1 +
 fs/xfs/libxfs/xfs_types.h       |   1 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_acl.c                |  14 +-
 fs/xfs/xfs_attr.h               | 148 ----------
 fs/xfs/xfs_attr_item.c          | 598 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          | 114 ++++++++
 fs/xfs/xfs_attr_list.c          |  75 +++--
 fs/xfs/xfs_error.c              |   3 +
 fs/xfs/xfs_inode.c              | 150 +++++++---
 fs/xfs/xfs_ioctl.c              | 101 ++++++-
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   7 +-
 fs/xfs/xfs_log_recover.c        | 172 ++++++++++++
 fs/xfs/xfs_ondisk.h             |   6 +
 fs/xfs/xfs_parent_utils.c       | 154 +++++++++++
 fs/xfs/xfs_parent_utils.h       |  32 +++
 fs/xfs/xfs_qm.c                 |   1 +
 fs/xfs/xfs_super.c              |   5 +
 fs/xfs/xfs_symlink.c            |   6 +-
 fs/xfs/xfs_trans.h              |  16 +-
 fs/xfs/xfs_trans_attr.c         | 275 ++++++++++++++++++
 fs/xfs/xfs_xattr.c              |  11 +-
 48 files changed, 2781 insertions(+), 487 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_attr.h
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 delete mode 100644 fs/xfs/xfs_attr.h
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h
 create mode 100644 fs/xfs/xfs_trans_attr.c

-- 
2.7.4
