Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44188 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbfDLWws (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 18:52:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3CMd48I014826
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:46 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2rphmf0yp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3CMqb05076140
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2rtqnpaknc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:45 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3CMqitd002524
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 22:52:44 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 0/9] xfs: Delayed Attributes
Date: Fri, 12 Apr 2019 15:50:27 -0700
Message-Id: <20190412225036.22939-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series for parent pointers (v9). 
Delayed attributes allow attribute operations (set and remove) to be 
logged and committed in the same way that other delayed operations do.
This will help break up more complex operations when we later introduce
parent pointers which can be used in a number of optimizations.  Since
delayed attributes can be implemented as a stand alone feature, I've
decided to subdivide the set to help make it more manageable.

Changes since parent pointers v9:
This is mostly to update the set onto more recent code.  Some time
during v8, concerns were raised about the transaction becoming too
large, and we discussed breaking up the set operation by periodically
returning EAGAIN to cycle out the transaction during the finish routine. 
This is done in patches 7 and 8, but I dont recall them getting feedback 
as people were quite busy at the time.

Questions, comments, feedback appreciated!

Thanks all!
Allion

Allison Henderson (9):
  xfs: Remove all strlen in all xfs_attr_* functions for attr names.
  xfs: Hold inode locks in xfs_ialloc
  xfs: Add trans toggle to attr routines
  xfs: Set up infastructure for deferred attribute operations
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Add xfs_has_attr and subroutines
  xfs: Add attr context to log item
  xfs: Roll delayed attr operations by returning EAGAIN
  xfs: Remove roll_trans boolean

 fs/xfs/Makefile                 |   2 +
 fs/xfs/libxfs/xfs_attr.c        | 316 ++++++++++++++-------
 fs/xfs/libxfs/xfs_attr.h        |  61 ++++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |  48 +++-
 fs/xfs/libxfs/xfs_attr_leaf.h   |   3 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  20 --
 fs/xfs/libxfs/xfs_defer.c       |   1 +
 fs/xfs/libxfs/xfs_defer.h       |   3 +
 fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
 fs/xfs/libxfs/xfs_types.h       |   1 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_acl.c                |  14 +-
 fs/xfs/xfs_attr_item.c          | 587 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          | 103 +++++++
 fs/xfs/xfs_inode.c              |   6 +-
 fs/xfs/xfs_ioctl.c              |  15 +-
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   7 +-
 fs/xfs/xfs_log_recover.c        | 172 ++++++++++++
 fs/xfs/xfs_ondisk.h             |   2 +
 fs/xfs/xfs_qm.c                 |   1 +
 fs/xfs/xfs_symlink.c            |   3 +
 fs/xfs/xfs_trans.h              |  12 +
 fs/xfs/xfs_trans_attr.c         | 250 +++++++++++++++++
 fs/xfs/xfs_xattr.c              |  11 +-
 25 files changed, 1535 insertions(+), 151 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h
 create mode 100644 fs/xfs/xfs_trans_attr.c

-- 
2.7.4
