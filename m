Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48581 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753190AbdKJQrw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2017 11:47:52 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAAGlpeg030927
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2017 16:47:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAAGloQq025419
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2017 16:47:51 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAAGlolG032261
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2017 16:47:50 GMT
Date: Fri, 10 Nov 2017 08:47:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: xfs-4.15-merge updated to 2d1d1da
Message-ID: <20171110164747.GC25227@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfs-4.15-merge branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.  This is what I expect to push for
4.15, barring any major last minute regressions.  I've been testing
these internally for several days now, so I don't anticipate any
problems.

The new head of the xfs-4.15-merge branch is commit:

2d1d1da xfs: on failed mount, force-reclaim inodes after unmounting quota controls

New Commits:

Christoph Hellwig (6):
      [43d193a] xfs: fix number of records handling in xfs_iext_split_leaf
      [fc258f4] xfs: add some comments to xfs_iext_insert/xfs_iext_insert_node
      [f1be313] xfs: remove a superflous assignment in xfs_iext_remove_node
      [b9aee1d] xfs: trivial indentation fixup for xfs_iext_remove_node
      [3e27c41] xfs: add comments documenting the rebalance algorithm
      [ae82968] xfs: handle zero entries case in xfs_iext_rebalance_leaf

Darrick J. Wong (8):
      [35ce852] xfs: refactor the directory data block bestfree checks
      [0a1e156] xfs: pass inode number to xfs_scrub_ino_set_{preen,warning}
      [72f76f7] xfs: fix uninitialized return values in scrub code
      [a605e86] xfs: fix btree scrub deref check
      [4da4b10] xfs: only check da node header padding on v5 filesystems
      [65a7935] xfs: remove u_int* type usage
      [d44b47f] xfs: check the uniqueness of the AGFL entries
      [2d1d1da] xfs: on failed mount, force-reclaim inodes after unmounting quota controls

Tim Hansen (1):
      [478f8da] fs/xfs: Remove NULL check before kmem_cache_destroy


Code Diffstat:

 fs/xfs/kmem.h                 |  3 +-
 fs/xfs/libxfs/xfs_format.h    |  2 +-
 fs/xfs/libxfs/xfs_iext_tree.c | 65 +++++++++++++++++++++++++++++++++----------
 fs/xfs/scrub/agheader.c       | 63 +++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/attr.c           |  2 +-
 fs/xfs/scrub/btree.c          |  2 +-
 fs/xfs/scrub/common.c         |  6 ++--
 fs/xfs/scrub/common.h         |  5 ++--
 fs/xfs/scrub/dabtree.c        |  3 +-
 fs/xfs/scrub/dir.c            | 22 ++++-----------
 fs/xfs/scrub/inode.c          |  8 +++---
 fs/xfs/scrub/parent.c         |  4 +--
 fs/xfs/xfs_attr_list.c        |  4 +--
 fs/xfs/xfs_ioctl.c            |  4 +--
 fs/xfs/xfs_ioctl.h            |  4 +--
 fs/xfs/xfs_mount.c            | 15 ++++++++--
 16 files changed, 156 insertions(+), 56 deletions(-)
