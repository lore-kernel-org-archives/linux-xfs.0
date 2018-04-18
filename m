Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34776 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752308AbeDRWNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 18:13:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3IMCW5h099120
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 22:13:47 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2hdrxp4u37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 22:13:47 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3IMDksv006960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 22:13:47 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3IMDkGR005613
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 22:13:46 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 00/18] Parent Pointers v5
Date: Wed, 18 Apr 2018 15:11:08 -0700
Message-Id: <1524089486-22922-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is the fifth version of parent pointer attributes for xfs. The goal of
this patch set is to add a parent pointer attribute to each inode.  The
attribute name containing the parent inode, generation, and directory offset,
while the  attribute value contains the file name.  This feature will enable
future optimizations for online scrub, or any other feature that could make
use of quickly deriving an inodes path from  the mount point.  This set also
introduces deferred attribute operations, though it is currently only used by
 the new parent pointer code.

My apologies for the delays on the set, but I do intend to resume moving
forward with it.  I've updated the set from the comments made since v4, and 
have also done some work to separate out the code that needs to be shared
with xfsprogs in libxfs.  The set is not quite ready yet.  In working on the
tests, I have identified some bugs that still need to be resolved.  But I
wanted to put out what I have at the moment to keep people updated with
where things are right now.  Thanks everyone!

As always, comments and feedback are appreciated.  Thank you!

Allison Henderson (9):
  xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
  xfs: Add attibute set and remove helper functions
  xfs: Set up infastructure for deferred attribute operations
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Remove all strlen calls in all xfs_attr_* functions for attr
    names.
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
 fs/xfs/libxfs/xfs_attr.c       | 448 +++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_attr.h       | 196 +++++++++++++++
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
 fs/xfs/libxfs/xfs_parent.c     | 142 +++++++++++
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
 fs/xfs/xfs_inode.c             | 137 ++++++++---
 fs/xfs/xfs_ioctl.c             |  74 +++++-
 fs/xfs/xfs_iops.c              |   6 +-
 fs/xfs/xfs_log_recover.c       | 122 ++++++++++
 fs/xfs/xfs_parent_utils.c      | 136 +++++++++++
 fs/xfs/xfs_parent_utils.h      |  32 +++
 fs/xfs/xfs_super.c             |   5 +
 fs/xfs/xfs_symlink.c           |   2 +-
 fs/xfs/xfs_trans.h             |  13 +
 fs/xfs/xfs_trans_attr.c        | 294 +++++++++++++++++++++++
 fs/xfs/xfs_xattr.c             |  10 +-
 41 files changed, 2444 insertions(+), 427 deletions(-)
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

