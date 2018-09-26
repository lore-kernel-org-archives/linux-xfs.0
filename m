Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33470 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbeIZQiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QAO2LO073338
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:43 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2mnd5thjrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:43 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPhNP012866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:43 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPgBP032112
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:42 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 00/30]  xfsprogs: parent pointers v2
Date: Wed, 26 Sep 2018 03:23:03 -0700
Message-Id: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is the 3rd revision of the parent pointer patch set for xfsprogs.  The
goal of the set is to enable use of the parent pointer feature on the kernel
side, and provide basic user space utilities.

The first 22 patches synchronize libxfs with changes seen the kernel space
patch. I will pick up the reviews from the kernel side series and mirror them
here.

Some points of interest since v2:
I've updated the series with feedback from the last revisions and also
synchronized the changes from v9 of the kernel side series.  Patches 25 and 
and 29 are new, so some attention there would be appreciated.  Patch 29 adds
flags to the parent command to filter the output based on a particular inode or
filename, which helped to reduce the run time of the xfstests set.

As always, comments and feedback are appreciated.  Thank you!

Allison

Allison Henderson (30):
  xfsprogs: Move xfs_attr.h to libxfs
  xfsprogs: Add helper function xfs_attr_try_sf_addname
  xfsprogs: Add attibute set and helper functions
  xfsprogs: Add attibute remove and helper functions
  xfsprogs: Add trans toggle to attr routines
  xfsprogs: Set up infastructure for deferred attribute operations
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfsprogs: Add xfs_has_attr and subroutines
  xfs: Add attr context to log item
  xfsprogs: Roll delayed attr operations by returning EAGAIN
  xfsprogs: Remove roll_trans boolean
  xfsprogs: Remove all strlen calls in all xfs_attr_* functions for attr
    names
  xfsprogs: get directory offset when adding directory name
  xfsprogs: get directory offset when removing directory name
  xfsprogs: get directory offset when replacing a directory name
  xfsprogs: add parent pointer support to attribute code
  xfsprogs: define parent pointer xattr format
  xfsprogs: extent transaction reservations for parent attributes
  xfsprogs: parent pointer attribute creation
  xfsprogs: Add the parent pointer support to the superblock version 5.
  xfsprogs: Add helper function xfs_attr_list_context_init
  xfsprogs: Add parent pointer ioctl
  xfsprogs: Add delayed attributes error tag
  xfsprogs: Add parent pointer flag to cmd
  xfsprogs: Add log item printing for ATTRI and ATTRD
  xfsprogs: Add xfs_verify_pptr
  xfsprogs: Add parent pointers to recreated inodes
  xfsprogs: Add parent pointers during protofile creation
  xfsprogs: implement the upper half of parent pointers
  xfsprogs: Add i, n and f flags to parent command

 include/handle.h         |   2 +
 include/parent.h         |  25 +++
 include/path.h           |  19 ++
 io/inject.c              |   1 +
 io/parent.c              | 506 +++++++++++++++--------------------------------
 libfrog/paths.c          | 136 +++++++++++++
 libhandle/Makefile       |   2 +-
 libhandle/handle.c       |   7 +-
 libhandle/parent.c       | 361 +++++++++++++++++++++++++++++++++
 libxfs/Makefile          |   3 +
 libxfs/libxfs_api_defs.h |   1 +
 libxfs/xfs_attr.c        | 495 +++++++++++++++++++++++++++++++---------------
 libxfs/xfs_attr.h        | 202 +++++++++++++++++++
 libxfs/xfs_attr_leaf.c   |  49 +++--
 libxfs/xfs_attr_leaf.h   |   3 +-
 libxfs/xfs_attr_remote.c |  20 --
 libxfs/xfs_bmap.c        |  49 +++--
 libxfs/xfs_bmap.h        |   1 +
 libxfs/xfs_da_btree.h    |   1 +
 libxfs/xfs_da_format.h   |  37 +++-
 libxfs/xfs_defer.h       |   1 +
 libxfs/xfs_dir2.c        |  21 +-
 libxfs/xfs_dir2.h        |   7 +-
 libxfs/xfs_dir2_block.c  |   9 +-
 libxfs/xfs_dir2_leaf.c   |   8 +-
 libxfs/xfs_dir2_node.c   |   8 +-
 libxfs/xfs_dir2_sf.c     |   6 +
 libxfs/xfs_errortag.h    |   4 +-
 libxfs/xfs_format.h      |  10 +-
 libxfs/xfs_fs.h          |  46 +++++
 libxfs/xfs_log_format.h  |  44 ++++-
 libxfs/xfs_parent.c      | 207 +++++++++++++++++++
 libxfs/xfs_parent.h      |  37 ++++
 libxfs/xfs_sb.c          |   2 +
 libxfs/xfs_trans_resv.c  | 111 ++++++++---
 libxfs/xfs_trans_resv.h  |   1 +
 libxfs/xfs_types.h       |   1 +
 logprint/log_misc.c      |  11 ++
 logprint/log_print_all.c |  12 ++
 logprint/log_redo.c      | 262 ++++++++++++++++++++++++
 logprint/logprint.h      |   6 +
 mkfs/proto.c             |  41 ++--
 mkfs/xfs_mkfs.c          |  23 ++-
 repair/attr_repair.c     |  21 +-
 repair/da_util.c         |  43 ++++
 repair/da_util.h         |  12 ++
 repair/phase6.c          |  52 +++--
 scrub/inodes.c           |  26 +++
 scrub/inodes.h           |   2 +
 scrub/phase5.c           |   9 +-
 50 files changed, 2298 insertions(+), 665 deletions(-)
 create mode 100644 libhandle/parent.c
 create mode 100644 libxfs/xfs_attr.h
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h

-- 
2.7.4
