Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47556 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752537AbdKQSYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 13:24:03 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAHIO2WS005163
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 18:24:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAHIO2GW007273
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 18:24:02 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAHIO2Gl031266
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 18:24:02 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 00/17] Parent Pointers v4
Date: Fri, 17 Nov 2017 11:21:28 -0700
Message-Id: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

Hi all,

This is the fourth version of parent pointer attributes for xfs. The goal of
this patch set is to add a parent pointer attribute to each inode.  The
attribute name containing the parent inode, generation, and directory offset,
while the  attribute value contains the file name.  This feature will enable
future optimizations for online scrub, or any other feature that could make
use of quickly deriving an inodes path from  the mount point.  This set also
introduces deferred attribute operations, though it is currently only used by
 the new parent pointer code.

I've integrated the suggestions made since v3, the biggest of which I think
was reducing the size of xfs_attr_log_item so that they didn't take up quite
so much space, as well as merging the deferred attribute set and create code
paths.  I've also added a patch that implements a new ioctl interface to return
the parent pointer to user space. I know Darrick already had some suggestions
for the new ioctl code that I still need to add, but I wanted to keep the rest
of the folks out here updated as to where I am with it now.

I'm still working on setting up some new xfstests for this patch set. I'll need
to get the appropriate changes mapped to xfsprogs first, but I will keep folks
updated as I go.

As always, comments and feedback are appreciated.  Thank you!

Allison Henderson

Allison Henderson (8):
  Add helper functions xfs_attr_set_args and xfs_attr_remove_args
  Set up infastructure for deferred attribute operations
  Add xfs_attr_set_defered and xfs_attr_remove_defered
  Remove all strlen calls in all xfs_attr_* functions for attr names.
  Add the extra space requirements for parent pointer attributes when
    calculating the minimum log size during mkfs
  Add parent pointers to rename
  Add the parent pointer support to the superblock version 5.
  Add parent pointer ioctl

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

 fs/xfs/Makefile                |   3 +
 fs/xfs/libxfs/xfs_attr.c       | 481 +++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_bmap.c       |  55 +++--
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
 fs/xfs/libxfs/xfs_fs.h         |   2 +
 fs/xfs/libxfs/xfs_log_format.h |  37 ++-
 fs/xfs/libxfs/xfs_log_rlimit.c |  34 +++
 fs/xfs/libxfs/xfs_parent.c     | 113 +++++++++
 fs/xfs/libxfs/xfs_trans_resv.c | 103 +++++++--
 fs/xfs/libxfs/xfs_types.h      |   1 +
 fs/xfs/xfs_acl.c               |  12 +-
 fs/xfs/xfs_attr.h              |  58 ++++-
 fs/xfs/xfs_attr_item.c         | 513 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h         | 117 ++++++++++
 fs/xfs/xfs_attr_list.c         |   3 +
 fs/xfs/xfs_fsops.c             |   4 +-
 fs/xfs/xfs_inode.c             | 141 ++++++++---
 fs/xfs/xfs_ioctl.c             |  61 ++++-
 fs/xfs/xfs_iops.c              |   6 +-
 fs/xfs/xfs_log_recover.c       | 140 +++++++++++
 fs/xfs/xfs_super.c             |   5 +
 fs/xfs/xfs_symlink.c           |   2 +-
 fs/xfs/xfs_trans.h             |  13 ++
 fs/xfs/xfs_trans_attr.c        | 288 +++++++++++++++++++++++
 fs/xfs/xfs_xattr.c             |  10 +-
 35 files changed, 2062 insertions(+), 274 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h
 create mode 100644 fs/xfs/xfs_trans_attr.c

-- 
2.7.4

