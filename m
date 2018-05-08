Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38978 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbeEHEn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 00:43:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w484hPf2105741
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:25 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2hs5936sm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 04:43:25 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w484hPIj028827
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:25 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w484hPn5025409
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:25 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 00/21] xfsprogs: parent pointers v1
Date: Mon,  7 May 2018 21:40:58 -0700
Message-Id: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is the first revision of the parent pointer patch set for xfsprogs.  The
goal of the set is to enable use of the parent pointer feature on the kernel
side, and provide basic user space utilities.

The first 17 patches synchronize libxfs with changes seen the kernel space patch.
I will pick up the reviews from that series and mirror them here.  Next
three patches plumb in the command line flag and changes to the protofile.  Last
patch I picked up from an earlier series Darrick to print out walk through pptrs
and print them.

As always, comments and feedback are appreciated.  Thank you!


Allison Henderson (20):
  xfsprogs: Move xfs_attr.h to libxfs
  xfsprogs: Add trans toggle to attr routines
  xfsprogs: Add attibute set and helper functions
  xfsprogs: Add attibute remove and helper functions
  xfsprogs: Set up infastructure for deferred attribute operations
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfsprogs: Remove all strlen calls in all xfs_attr_* functions for attr
    names.
  xfsprogs: get directory offset when adding directory name
  xfsprogs: get directory offset when removing directory name
  xfsprogs: get directory offset when replacing a directory name
  xfsprogs: add parent pointer support to attribute code
  xfsprogs: define parent pointer xattr format
  xfsprogs: extent transaction reservations for parent attributes
  xfsprogs: parent pointer attribute creation
  xfsprogs: Add the parent pointer support to the superblock version 5.
  xfsprogs: Add parent pointer ioctl
  xfsprogs: Add delayed attributes error tag
  xfsprogs: Add parent pointer flag to cmd
  xfsprogs: Remove single byte array from struct parent
  xfsprogs: Add parent pointers during protofile creation

Darrick J. Wong (1):
  xfsprogs: implement the upper half of parent pointers

 include/handle.h        |   2 +
 include/parent.h        |  19 +-
 include/path.h          |  19 ++
 io/inject.c             |   1 +
 io/parent.c             | 468 ++++++++++++----------------------------------
 libfrog/paths.c         | 136 ++++++++++++++
 libhandle/Makefile      |   2 +-
 libhandle/handle.c      |   7 +-
 libhandle/parent.c      | 325 ++++++++++++++++++++++++++++++++
 libxfs/Makefile         |   3 +
 libxfs/xfs_attr.c       | 481 ++++++++++++++++++++++++++++++++----------------
 libxfs/xfs_attr.h       | 191 +++++++++++++++++++
 libxfs/xfs_attr_leaf.c  |  13 +-
 libxfs/xfs_attr_leaf.h  |   8 +-
 libxfs/xfs_bmap.c       |  49 +++--
 libxfs/xfs_bmap.h       |   1 +
 libxfs/xfs_da_btree.h   |   1 +
 libxfs/xfs_da_format.h  |  38 +++-
 libxfs/xfs_defer.h      |   1 +
 libxfs/xfs_dir2.c       |  41 +++--
 libxfs/xfs_dir2.h       |  10 +-
 libxfs/xfs_dir2_block.c |   9 +-
 libxfs/xfs_dir2_leaf.c  |   8 +-
 libxfs/xfs_dir2_node.c  |   8 +-
 libxfs/xfs_dir2_sf.c    |   6 +
 libxfs/xfs_errortag.h   |   5 +-
 libxfs/xfs_format.h     |  10 +-
 libxfs/xfs_fs.h         |  47 +++++
 libxfs/xfs_log_format.h |  44 ++++-
 libxfs/xfs_parent.c     | 178 ++++++++++++++++++
 libxfs/xfs_parent.h     |  38 ++++
 libxfs/xfs_sb.c         |   2 +
 libxfs/xfs_trans_resv.c | 111 ++++++++---
 libxfs/xfs_trans_resv.h |   1 +
 libxfs/xfs_types.h      |   1 +
 mkfs/proto.c            |  58 ++++--
 mkfs/xfs_mkfs.c         |  16 +-
 repair/attr_repair.c    |  16 +-
 repair/phase6.c         |  54 +++---
 scrub/inodes.c          |  26 +++
 scrub/inodes.h          |   2 +
 scrub/phase5.c          |   9 +-
 42 files changed, 1802 insertions(+), 663 deletions(-)
 create mode 100644 libhandle/parent.c
 create mode 100644 libxfs/xfs_attr.h
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h

-- 
2.7.4

