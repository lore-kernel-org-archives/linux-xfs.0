Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22905 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbdHJBnl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2017 21:43:41 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7A1heZ6010013
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1heu7028805
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:40 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hduK016389
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:40 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [RFC PATCH 00/13] Add parent pointer attributes
Date: Wed,  9 Aug 2017 18:41:20 -0700
Message-Id: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is my first pass at parent pointer attributes for xfs.  It's also
my first patch set for xfs in general, so I would very much appreciate
the feedback.  I got in touch with Brian Foster a while back, who was 
gracious enough to give me what he had done thus far with it.  From 
there I've finished out the remove and rename routines.  This 
implementation uses the following on disk format:

name={parent inode, parent inode gen, dirent offset}
value={dirent filename}

I know folks have a lot of opinions about the format, so I'd
like to get peoples thoughts on it now that we have some code
to look at and discuss.  Thanks!

Questions, comments and feedback are welcome!

Allison Henderson


Allison Henderson (3):
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

 fs/xfs/Makefile                |   1 +
 fs/xfs/libxfs/xfs_attr.c       | 382 +++++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_bmap.c       |  51 +++---
 fs/xfs/libxfs/xfs_bmap.h       |   1 +
 fs/xfs/libxfs/xfs_da_btree.h   |   1 +
 fs/xfs/libxfs/xfs_da_format.h  |  12 +-
 fs/xfs/libxfs/xfs_dir2.c       |  41 +++--
 fs/xfs/libxfs/xfs_dir2.h       |   9 +-
 fs/xfs/libxfs/xfs_dir2_block.c |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   6 +
 fs/xfs/libxfs/xfs_format.h     |  43 ++++-
 fs/xfs/libxfs/xfs_fs.h         |   1 +
 fs/xfs/libxfs/xfs_log_rlimit.c |  34 ++++
 fs/xfs/libxfs/xfs_parent.c     | 163 ++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.c | 103 ++++++++---
 fs/xfs/xfs_attr.h              |  30 ++++
 fs/xfs/xfs_fsops.c             |   4 +-
 fs/xfs/xfs_inode.c             | 146 ++++++++++++----
 fs/xfs/xfs_qm.c                |   2 +-
 fs/xfs/xfs_qm.h                |   1 +
 fs/xfs/xfs_symlink.c           |   2 +-
 23 files changed, 850 insertions(+), 208 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c

-- 
2.7.4

