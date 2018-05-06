Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43988 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbeEFR1E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 May 2018 13:27:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w46HR4Ka128348
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:04 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2hs426a11a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 06 May 2018 17:27:03 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w46HR3ve014655
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:03 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w46HR3Lx005827
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:03 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 00/21] Parent Pointers v6
Date: Sun,  6 May 2018 10:24:33 -0700
Message-Id: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is the 6th version of parent pointer attributes for xfs. The goal of
this patch set is to add a parent pointer attribute to each inode.  The
attribute name containing the parent inode, generation, and directory offset,
while the  attribute value contains the file name.  This feature will enable
future optimizations for online scrub, or any other feature that could make
use of quickly deriving an inodes path from  the mount point.  This set also
introduces deferred attribute operations, though it is currently only used by
 the new parent pointer code.

Some points of interest since v5:
Patches 2 and 14 are new, so I would appreciate some focus on those.
They lay the ground work for delaying transaction rolls until
the entire operation is finished.  Patches 15 through 18 have been 
adjusted to hold locks across create, link, remove and rename operations.

Corresponding userspace and test cases are enroute.
As always, comments and feedback are appreciated.  Thank you!


Allison Henderson (12):
  xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
  Add trans toggle to attr routines
  xfs: Add attibute set and helper functions
  xfs: Add attibute remove and helper functions
  xfs: Set up infastructure for deferred attribute operations
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Remove all strlen calls in all xfs_attr_* functions for attr
    names.
  Add lock_flags to xfs_ialloc and xfs_dir_ialloc
  xfs: Add parent pointers to rename
  xfs: Add the parent pointer support to the superblock version 5.
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

 fs/xfs/Makefile                |   4 +
 fs/xfs/libxfs/xfs_attr.c       | 480 ++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_attr.h       | 196 +++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c  |  12 +-
 fs/xfs/libxfs/xfs_attr_leaf.h  |   8 +-
 fs/xfs/libxfs/xfs_bmap.c       |  49 ++--
 fs/xfs/libxfs/xfs_bmap.h       |   1 +
 fs/xfs/libxfs/xfs_da_btree.h   |   1 +
 fs/xfs/libxfs/xfs_da_format.h  |  38 ++-
 fs/xfs/libxfs/xfs_defer.h      |   1 +
 fs/xfs/libxfs/xfs_dir2.c       |  41 ++--
 fs/xfs/libxfs/xfs_dir2.h       |  10 +-
 fs/xfs/libxfs/xfs_dir2_block.c |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   6 +
 fs/xfs/libxfs/xfs_errortag.h   |   5 +-
 fs/xfs/libxfs/xfs_format.h     |  10 +-
 fs/xfs/libxfs/xfs_fs.h         |  39 +++
 fs/xfs/libxfs/xfs_log_format.h |  44 +++-
 fs/xfs/libxfs/xfs_parent.c     | 168 +++++++++++++
 fs/xfs/libxfs/xfs_parent.h     |  38 +++
 fs/xfs/libxfs/xfs_sb.c         |   2 +
 fs/xfs/libxfs/xfs_trans_resv.c | 111 +++++++--
 fs/xfs/libxfs/xfs_trans_resv.h |   1 +
 fs/xfs/libxfs/xfs_types.h      |   1 +
 fs/xfs/xfs_acl.c               |  12 +-
 fs/xfs/xfs_attr.h              | 160 -------------
 fs/xfs/xfs_attr_item.c         | 530 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h         | 119 +++++++++
 fs/xfs/xfs_attr_list.c         |   3 +
 fs/xfs/xfs_error.c             |   3 +
 fs/xfs/xfs_inode.c             | 220 ++++++++++++-----
 fs/xfs/xfs_inode.h             |   2 +-
 fs/xfs/xfs_ioctl.c             |  74 +++++-
 fs/xfs/xfs_iops.c              |   6 +-
 fs/xfs/xfs_log_recover.c       | 122 ++++++++++
 fs/xfs/xfs_parent_utils.c      | 136 +++++++++++
 fs/xfs/xfs_parent_utils.h      |  32 +++
 fs/xfs/xfs_qm.c                |   2 +-
 fs/xfs/xfs_super.c             |   5 +
 fs/xfs/xfs_symlink.c           |   4 +-
 fs/xfs/xfs_trans.h             |  13 +
 fs/xfs/xfs_trans_attr.c        | 291 ++++++++++++++++++++++
 fs/xfs/xfs_xattr.c             |  10 +-
 45 files changed, 2552 insertions(+), 483 deletions(-)
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

