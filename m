Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59854 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbeH1XR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 19:17:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7SJJDlI080917
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:51 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2m2yrq5th6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:51 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJOoHV012531
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:50 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7SJOoZj002955
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:50 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v8 00/28] Parent Pointers v8
Date: Tue, 28 Aug 2018 12:22:13 -0700
Message-Id: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is the 8th version of parent pointer attributes for xfs. The goal of
this patch set is to add a parent pointer attribute to each inode.  The
attribute name containing the parent inode, generation, and directory offset,
while the  attribute value contains the file name.  This feature will enable
future optimizations for online scrub, or any other feature that could make
use of quickly deriving an inodes path from  the mount point.  This set also
introduces deferred attribute operations, though it is currently only used by
 the new parent pointer code.


Some points of interest since v7:
I've integrated most of the feedback provided on v7 and done a lot of
stabilizing.  In the last version, I had plumbed in a "roll_trans" boolean 
into the attribute routines to prevent transactions from being rolled during the
defer finish.  Some concerns were raised in the reviews because this caused 
attribute operations to become one large transaction.  The new proposal 
was to have the attribute code periodically return EAGAIN to get the defer
finish routine to cycle out the transaction.

So in this solution setting an attribute is broken into 3 transactions.
I'm thinking that ideally it should send back the EAGAIN where ever the 
existing code used to roll the transaction, but that gets more complex 
since they're nested in sub functions.  So I wanted to see what people
thought of this implementation first before proceeding any further.


This design has the following complexities that I think should be considered:

The attribute routines tend to pass around structures like xfs_da_args, and
xfs_buf (for holding and releasing leaf buffers).  These structures need to 
remain instantiated across the EAGAIN returns until the entire attribute 
operation is complete.  Additionally, this solution adds a state machine to 
keep track of where to resume executing before we bailed out with the EAGAIN. 
At the moment, I've put these items in the xfs_attr_item structure (patch 10).
Since the defer finish routine passes it back through through the 
*_finish_item callback, xfs_attr_finish_item can plumb them back in from there
(patch 11).  This works for now though maybe not the most appropriate place to 
put it?  Maybe we can move it if people have opinions about it.

Also, since this solution alters the behavior of the attribute set and remove 
sub-routines, normal attribute operations have been made to use delayed
operations the same way parent pointers do.  However, since delayed operations 
cant return error codes, we need to take care of any condition that would 
normally return an error to the user.  For example ENOATTR if trying to remove 
a non existent attribute.  For this reason, all such error conditions need to 
be resolved before calling the delayed operation.  So I've added some extra 
routines to check for that in xfs_attr_remove (added in patch 9).  

I struggled a little with how to present this set in a way that broke the logic 
down into manageable sized patches.  In this solution, I chose to keep the 
roll_trans boolean temporarily (patch 6), and then remove it later (in patch 12) 
after all the code paths have been made to pass a false value.  I thought this 
helped to break up the changes into smaller patches without having to deal with 
all affected code paths at once.  Maybe if people are comfortable with the 
changes going on in 6 though 12, we could consider collapsing them together
later.

For the most part I would appreciate review focus on patches 6 though 12,
since that is where most of the activity has been this for the revision.
Folks are certainly welcome to pour through the rest of it, but I know
it's a lot.  I've tried to arrange the set such that 1-12 sets up delayed 
attributes, and 13-28 adds the parent pointers.  I don't have the xfsprogs 
side just yet because this set is sitting a little upstream from where 
xfsprogs is ATM and it had quite a few conflicts trying to sync it with 
xfsprogs.  So I'm just going to wait a bit for now until that catches up.  

As always, comments and feedback are appreciated.  Thank you!

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
 fs/xfs/libxfs/xfs_attr.c        | 496 ++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_attr.h        | 203 ++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c   |  49 +++-
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
 fs/xfs/libxfs/xfs_fs.h          |  43 +++
 fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
 fs/xfs/libxfs/xfs_parent.c      | 111 ++++++++
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
 fs/xfs/xfs_inode.c              | 159 ++++++++---
 fs/xfs/xfs_ioctl.c              | 101 ++++++-
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   7 +-
 fs/xfs/xfs_log_recover.c        | 172 ++++++++++++
 fs/xfs/xfs_ondisk.h             |   6 +
 fs/xfs/xfs_parent_utils.c       | 152 ++++++++++
 fs/xfs/xfs_parent_utils.h       |  32 +++
 fs/xfs/xfs_qm.c                 |   1 +
 fs/xfs/xfs_super.c              |   5 +
 fs/xfs/xfs_symlink.c            |   6 +-
 fs/xfs/xfs_trans.h              |  16 +-
 fs/xfs/xfs_trans_attr.c         | 275 ++++++++++++++++++
 fs/xfs/xfs_xattr.c              |  11 +-
 48 files changed, 2700 insertions(+), 486 deletions(-)
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
