Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54622 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbeFJFHY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:07:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A57EbK071951
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:23 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2jg6b19w5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:23 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5A57MPO001970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:22 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5A57Lgg002694
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:22 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v7 00/23] Parent Pointers v7
Date: Sat,  9 Jun 2018 22:04:45 -0700
Message-Id: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is the 7th version of parent pointer attributes for xfs. The goal of
this patch set is to add a parent pointer attribute to each inode.  The
attribute name containing the parent inode, generation, and directory offset,
while the  attribute value contains the file name.  This feature will enable
future optimizations for online scrub, or any other feature that could make
use of quickly deriving an inodes path from  the mount point.  This set also
introduces deferred attribute operations, though it is currently only used by
 the new parent pointer code.

Some points of interest since v6:
I've integrated most of the feedback provided on v6, and addressed some bugs
I found during the log replay in patch 6.  Patches 2, 7, and 21 are new, so
I would appreciate some focus on those.  I'm still working on an alternate
solution to patch 3, but wanted to give folks an update for where things
are at the moment.

As always, comments and feedback are appreciated.  Thank you!

Allison Henderson (14):
  xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
  xfs: Add helper function xfs_attr_try_sf_addname
  xfs: Add trans toggle to attr routines
  xfs: Add attibute set and helper functions
  xfs: Add attibute remove and helper functions
  xfs: Set up infastructure for deferred attribute operations
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Remove all strlen calls in all xfs_attr_* functions for attr
    names.
  xfs: Hold inode locks in xfs_ialloc
  xfs: Add parent pointers to rename
  xfs: Add the parent pointer support to the superblock version 5.
  xfs: Add helper function xfs_attr_list_context_init
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
 fs/xfs/libxfs/xfs_attr.c       | 504 +++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_attr.h       | 199 +++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c  |  12 +-
 fs/xfs/libxfs/xfs_attr_leaf.h  |  10 +-
 fs/xfs/libxfs/xfs_bmap.c       |  49 ++--
 fs/xfs/libxfs/xfs_bmap.h       |   1 +
 fs/xfs/libxfs/xfs_da_btree.h   |   1 +
 fs/xfs/libxfs/xfs_da_format.h  |  37 ++-
 fs/xfs/libxfs/xfs_defer.h      |   1 +
 fs/xfs/libxfs/xfs_dir2.c       |  41 +--
 fs/xfs/libxfs/xfs_dir2.h       |  10 +-
 fs/xfs/libxfs/xfs_dir2_block.c |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   6 +
 fs/xfs/libxfs/xfs_errortag.h   |   4 +-
 fs/xfs/libxfs/xfs_format.h     |  10 +-
 fs/xfs/libxfs/xfs_fs.h         |  43 ++++
 fs/xfs/libxfs/xfs_log_format.h |  44 +++-
 fs/xfs/libxfs/xfs_parent.c     | 171 +++++++++++++
 fs/xfs/libxfs/xfs_parent.h     |  38 +++
 fs/xfs/libxfs/xfs_sb.c         |   2 +
 fs/xfs/libxfs/xfs_trans_resv.c | 111 ++++++--
 fs/xfs/libxfs/xfs_trans_resv.h |   1 +
 fs/xfs/libxfs/xfs_types.h      |   1 +
 fs/xfs/xfs_acl.c               |  12 +-
 fs/xfs/xfs_attr.h              | 160 ------------
 fs/xfs/xfs_attr_item.c         | 560 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h         | 120 +++++++++
 fs/xfs/xfs_attr_list.c         |  75 ++++--
 fs/xfs/xfs_error.c             |   3 +
 fs/xfs/xfs_inode.c             | 188 ++++++++++----
 fs/xfs/xfs_ioctl.c             |  99 +++++++-
 fs/xfs/xfs_iops.c              |   6 +-
 fs/xfs/xfs_log_recover.c       | 173 +++++++++++++
 fs/xfs/xfs_ondisk.h            |   6 +
 fs/xfs/xfs_parent_utils.c      | 150 +++++++++++
 fs/xfs/xfs_parent_utils.h      |  32 +++
 fs/xfs/xfs_qm.c                |   1 +
 fs/xfs/xfs_super.c             |   5 +
 fs/xfs/xfs_symlink.c           |   2 +-
 fs/xfs/xfs_trans.h             |  14 ++
 fs/xfs/xfs_trans_attr.c        | 293 +++++++++++++++++++++
 fs/xfs/xfs_xattr.c             |  10 +-
 45 files changed, 2733 insertions(+), 501 deletions(-)
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

