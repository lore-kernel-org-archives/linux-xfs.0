Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29030 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933024AbdC3Rh2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Mar 2017 13:37:28 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v2UHbQsj013331
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Mar 2017 17:37:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v2UHbPhe020806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Mar 2017 17:37:26 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v2UHbP0f016050
        for <linux-xfs@vger.kernel.org>; Thu, 30 Mar 2017 17:37:25 GMT
Date: Thu, 30 Mar 2017 10:37:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 0cbf8c9
Message-ID: <20170330173724.GE4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.  I intend to try to put in Eric Sandeen's patches
to perform unlinked inode cleanup during ro mount and my own GETFSMAP
patches for 4.12, so I put them in along with the other fixes and
cleanups to get further testing.

If either of the two bigger changes break things I'm open to fixing or
removing them before the merge window opens.  I did just post a v8
GETFSMAP patchset; the only changes in that posting are in the ext4
patch, which isn't going in via the XFS tree.  FWIW I've been beating on
the patches in this branch since the end of Vault and haven't noticed
any new breakage.  I based the patch stack off -rc4 because that's the
first kernel I've gotten to boot reliably across my test farm.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

0cbf8c9 xfs: report realtime space information via the rtbitmap

New Commits:

Brian Foster (1):
      [607604d] xfs: use dedicated log worker wq to avoid deadlock with cil wq

Christoph Hellwig (2):
      [350baac] xfs: factor out a xfs_bmap_is_real_extent helper
      [71892b3] xfs: remove the ISUNWRITTEN macro

Darrick J. Wong (9):
      [3784d1c] xfs: move the inline directory verifiers
      [273cc87] vfs: add common GETFSMAP ioctl definitions
      [267a741] xfs: plumb in needed functions for range querying of the freespace btrees
      [eaf588b] xfs: provide a query_range function for freespace btrees
      [70601a4] xfs: create a function to query all records in a btree
      [46eec30] xfs: add a couple of queries to iterate free extents in the rtbitmap
      [5ff0447] xfs: implement the GETFSMAP ioctl
      [7db07c5] xfs: have getfsmap fall back to the freesp btrees when rmap is not present
      [0cbf8c9] xfs: report realtime space information via the rtbitmap

Eric Sandeen (3):
      [98c7eb0] xfs: write unmount record for ro mounts
      [8acfb78] xfs: toggle readonly state around xfs_log_mount_finish
      [405aa1f] xfs: fix up inode validation failure message

Nikolay Borisov (1):
      [4d1e0d8] xfs: Remove obsolete declaration of xfs_buf_get_empty


Code Diffstat:

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_alloc.c       |  57 +++
 fs/xfs/libxfs/xfs_alloc.h       |  12 +
 fs/xfs/libxfs/xfs_alloc_btree.c | 172 ++++++--
 fs/xfs/libxfs/xfs_bmap.h        |  12 +
 fs/xfs/libxfs/xfs_bmap_btree.h  |   1 -
 fs/xfs/libxfs/xfs_btree.c       |  15 +
 fs/xfs/libxfs/xfs_btree.h       |   2 +
 fs/xfs/libxfs/xfs_dir2_priv.h   |   3 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |  63 ++-
 fs/xfs/libxfs/xfs_fs.h          |  13 +
 fs/xfs/libxfs/xfs_inode_buf.c   |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |  35 +-
 fs/xfs/libxfs/xfs_inode_fork.h  |   2 +-
 fs/xfs/libxfs/xfs_rmap.c        |  56 ++-
 fs/xfs/libxfs/xfs_rmap.h        |   4 +
 fs/xfs/libxfs/xfs_rtbitmap.c    |  70 +++
 fs/xfs/xfs_aops.c               |   8 +-
 fs/xfs/xfs_bmap_util.c          |   7 +-
 fs/xfs/xfs_buf.h                |   1 -
 fs/xfs/xfs_fsmap.c              | 940 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsmap.h              |  53 +++
 fs/xfs/xfs_inode.c              |  19 +-
 fs/xfs/xfs_ioctl.c              |  84 ++++
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iomap.c              |   4 +-
 fs/xfs/xfs_log.c                |  16 +-
 fs/xfs/xfs_mount.h              |   1 +
 fs/xfs/xfs_reflink.c            |  21 +-
 fs/xfs/xfs_rtalloc.h            |  22 +-
 fs/xfs/xfs_super.c              |   8 +
 fs/xfs/xfs_trace.c              |   1 +
 fs/xfs/xfs_trace.h              |  84 ++++
 fs/xfs/xfs_trans.c              |  22 +
 fs/xfs/xfs_trans.h              |   2 +
 include/uapi/linux/fsmap.h      | 112 +++++
 36 files changed, 1785 insertions(+), 142 deletions(-)
 create mode 100644 fs/xfs/xfs_fsmap.c
 create mode 100644 fs/xfs/xfs_fsmap.h
 create mode 100644 include/uapi/linux/fsmap.h
