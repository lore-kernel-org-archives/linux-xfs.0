Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47868 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753529AbeFJFKF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:05 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A57EGm007095
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:05 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2jg4dkt26n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:05 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5A46V003960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:05 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A5A4CM030363
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:04 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 00/27] xfsprogs: parent pointers v2
Date: Sat,  9 Jun 2018 22:07:25 -0700
Message-Id: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is the 2nd revision of the parent pointer patch set for xfsprogs.  The
goal of the set is to enable use of the parent pointer feature on the kernel
side, and provide basic user space utilities.

The first 19 patches synchronize libxfs with changes seen the kernel space patch.
I will pick up the reviews from the kernel side series and mirror them here.  

Some points of interest since v1:
I've updated the series with feedback from the last revisions.  Patches 23, 24
and 25 have split out from a previously larger patch, and patches 22 and 27 are
new.  So they could use some attention.

As always, comments and feedback are appreciated.  Thank you!

Allison Henderson (26):
  xfsprogs: Move xfs_attr.h to libxfs
  xfsprogs: Add helper function xfs_attr_try_sf_addname
  xfsprogs: Add trans toggle to attr routines
  xfsprogs: Add attibute set and helper functions
  xfsprogs: Add attibute remove and helper functions
  xfsprogs: Set up infastructure for deferred attribute operations
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
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
  xfsprogs: Remove single byte array from struct parent
  xfsprogs: Add log item printing for ATTRI and ATTRD
  xfsprogs: Do not use namechecks on parent pointers
  xfsprogs: Add parent pointers to recreated inodes
  xfsprogs: Add parent pointers during protofile creation
  xfsprogs: Clean up old parent pointer definitions

Darrick J. Wong (1):
  xfsprogs: implement the upper half of parent pointers

 include/handle.h         |   2 +
 include/parent.h         |  25 ++-
 include/path.h           |  19 ++
 io/inject.c              |   1 +
 io/parent.c              | 468 +++++++++++--------------------------------
 libfrog/paths.c          | 136 +++++++++++++
 libhandle/Makefile       |   2 +-
 libhandle/handle.c       |  33 +---
 libhandle/jdm.c          |  20 --
 libhandle/parent.c       | 325 ++++++++++++++++++++++++++++++
 libxfs/Makefile          |   3 +
 libxfs/libxfs_api_defs.h |   1 +
 libxfs/xfs_attr.c        | 505 ++++++++++++++++++++++++++++++++---------------
 libxfs/xfs_attr.h        | 194 ++++++++++++++++++
 libxfs/xfs_attr_leaf.c   |  14 +-
 libxfs/xfs_attr_leaf.h   |  10 +-
 libxfs/xfs_bmap.c        |  49 +++--
 libxfs/xfs_bmap.h        |   1 +
 libxfs/xfs_da_btree.h    |   1 +
 libxfs/xfs_da_format.h   |  37 +++-
 libxfs/xfs_defer.h       |   1 +
 libxfs/xfs_dir2.c        |  41 ++--
 libxfs/xfs_dir2.h        |  10 +-
 libxfs/xfs_dir2_block.c  |   9 +-
 libxfs/xfs_dir2_leaf.c   |   8 +-
 libxfs/xfs_dir2_node.c   |   8 +-
 libxfs/xfs_dir2_sf.c     |   6 +
 libxfs/xfs_errortag.h    |   5 +-
 libxfs/xfs_format.h      |  10 +-
 libxfs/xfs_fs.h          |  43 ++++
 libxfs/xfs_log_format.h  |  44 ++++-
 libxfs/xfs_parent.c      | 178 +++++++++++++++++
 libxfs/xfs_parent.h      |  38 ++++
 libxfs/xfs_sb.c          |   2 +
 libxfs/xfs_trans_resv.c  | 111 ++++++++---
 libxfs/xfs_trans_resv.h  |   1 +
 libxfs/xfs_types.h       |   1 +
 logprint/log_misc.c      |  11 ++
 logprint/log_print_all.c |  12 ++
 logprint/log_redo.c      | 262 ++++++++++++++++++++++++
 logprint/logprint.h      |   6 +
 mkfs/proto.c             |  54 +++--
 mkfs/xfs_mkfs.c          |  15 +-
 repair/attr_repair.c     |  18 +-
 repair/phase6.c          |  57 ++++--
 scrub/inodes.c           |  26 +++
 scrub/inodes.h           |   2 +
 scrub/phase5.c           |   9 +-
 48 files changed, 2122 insertions(+), 712 deletions(-)
 create mode 100644 libhandle/parent.c
 create mode 100644 libxfs/xfs_attr.h
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h

-- 
2.7.4

