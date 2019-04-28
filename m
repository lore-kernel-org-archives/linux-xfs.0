Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35390 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbfD1Pl1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Apr 2019 11:41:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3SFYjP6163746
        for <linux-xfs@vger.kernel.org>; Sun, 28 Apr 2019 15:41:26 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2s4egt345m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 28 Apr 2019 15:41:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3SFefYc068183
        for <linux-xfs@vger.kernel.org>; Sun, 28 Apr 2019 15:41:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2s4d49mwts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 28 Apr 2019 15:41:25 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3SFfJ8X010961
        for <linux-xfs@vger.kernel.org>; Sun, 28 Apr 2019 15:41:24 GMT
Date: Sun, 28 Apr 2019 08:41:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 7aef96d18066
Message-ID: <20190428154120.GD5207@magnolia>
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

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  There will definitely be another update in a few days
to pick up the patches that have trickled in over the past few days.

The new head of the for-next branch is commit:

7aef96d18066 xfs: always rejoin held resources during defer roll

New Commits:

Brian Foster (7):
      [4d09807f2046] xfs: fix use after free in buf log item unlock assert
      [545aa41f5cba] xfs: wake commit waiters on CIL abort before log item abort
      [22fedd80b652] xfs: shutdown after buf release in iflush cluster abort path
      [1ca89fbc48e1] xfs: don't account extra agfl blocks as available
      [945c941fcd82] xfs: make tr_growdata a permanent transaction
      [362f5e745ae2] xfs: assert that we don't enter agfl freeing with a non-permanent transaction
      [ba456c00d85e] xfs: add missing error check in xfs_prepare_shift()

Darrick J. Wong (26):
      [6772c1f11206] xfs: track metadata health status
      [39353ff6e96f] xfs: replace the BAD_SUMMARY mount flag with the equivalent health code
      [519841c207de] xfs: clear BAD_SUMMARY if unmounting an unhealthy filesystem
      [7cd5006bdb6f] xfs: add a new ioctl to describe allocation group geometry
      [c23232d40935] xfs: report fs and rt health via geometry structure
      [1302c6a24fd9] xfs: report AG health via AG geometry ioctl
      [89d139d5ad46] xfs: report inode health via bulkstat
      [9d71e15586fd] xfs: refactor scrub context initialization
      [f8c2a2257ca1] xfs: collapse scrub bool state flags into a single unsigned int
      [160b5a784525] xfs: hoist the already_fixed variable to the scrub context
      [4860a05d2475] xfs: scrub/repair should update filesystem metadata health
      [4fb7951fde64] xfs: scrub should only cross-reference with healthy btrees
      [cb357bf3d105] xfs: implement per-inode writeback completion queues
      [28408243706e] xfs: remove unused m_data_workqueue
      [3994fc489575] xfs: merge adjacent io completions of the same type
      [1fdeaea4d92c] xfs: abort unaligned nowait directio early
      [903b1fc2737f] xfs: widen quota block counters to 64-bit integers
      [394aafdc15da] xfs: widen inode delalloc block counter to 64-bits
      [078f4a7d3109] xfs: kill the xfs_dqtrx_t typedef
      [3de5eab3fde1] xfs: unlock inode when xfs_ioctl_setattr_get_trans can't get transaction
      [f60be90fc9a9] xfs: fix broken bhold behavior in xrep_roll_ag_trans
      [9fe82b8c422b] xfs: track delayed allocation reservations across the filesystem
      [ed30dcbd901c] xfs: rename the speculative block allocation reclaim toggle functions
      [9a1f3049f473] xfs: allow scrubbers to pause background reclaim
      [47cd97b5b239] xfs: scrub should check incore counters against ondisk headers
      [7aef96d18066] xfs: always rejoin held resources during defer roll

Dave Chinner (1):
      [1b6d968de22b] xfs: bump XFS_IOC_FSGEOMETRY to v5 structures

Wang Shilong (1):
      [2bf9d264efed] xfs,fstrim: fix to return correct minlen


Code Diffstat:

 fs/xfs/Makefile                |   2 +
 fs/xfs/libxfs/xfs_ag.c         |  54 ++++++
 fs/xfs/libxfs/xfs_ag.h         |   2 +
 fs/xfs/libxfs/xfs_alloc.c      |  13 +-
 fs/xfs/libxfs/xfs_attr.c       |  35 ++--
 fs/xfs/libxfs/xfs_attr.h       |   2 +-
 fs/xfs/libxfs/xfs_bmap.c       |  17 +-
 fs/xfs/libxfs/xfs_defer.c      |  14 +-
 fs/xfs/libxfs/xfs_fs.h         | 136 +++++++++++---
 fs/xfs/libxfs/xfs_health.h     | 190 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c         |  10 +-
 fs/xfs/libxfs/xfs_trans_resv.c |   6 +-
 fs/xfs/scrub/agheader.c        |  20 +++
 fs/xfs/scrub/common.c          |  38 +++-
 fs/xfs/scrub/common.h          |   2 +
 fs/xfs/scrub/health.c          | 236 +++++++++++++++++++++++++
 fs/xfs/scrub/health.h          |  14 ++
 fs/xfs/scrub/ialloc.c          |   4 +-
 fs/xfs/scrub/parent.c          |   2 +-
 fs/xfs/scrub/quota.c           |   2 +-
 fs/xfs/scrub/repair.c          |  34 ++--
 fs/xfs/scrub/repair.h          |   5 +-
 fs/xfs/scrub/scrub.c           |  43 +++--
 fs/xfs/scrub/scrub.h           |  18 +-
 fs/xfs/xfs_aops.c              | 135 ++++++++++++--
 fs/xfs/xfs_aops.h              |   1 -
 fs/xfs/xfs_bmap_util.c         |   2 +
 fs/xfs/xfs_buf_item.c          |   4 +-
 fs/xfs/xfs_discard.c           |   3 +-
 fs/xfs/xfs_dquot.c             |  17 +-
 fs/xfs/xfs_file.c              |   6 +-
 fs/xfs/xfs_health.c            | 392 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c            |  11 +-
 fs/xfs/xfs_icache.h            |   4 +-
 fs/xfs/xfs_inode.c             |   4 +-
 fs/xfs/xfs_inode.h             |  17 +-
 fs/xfs/xfs_ioctl.c             |  55 +++---
 fs/xfs/xfs_ioctl32.c           |   4 +-
 fs/xfs/xfs_itable.c            |   2 +
 fs/xfs/xfs_log.c               |   3 +-
 fs/xfs/xfs_log_cil.c           |  21 ++-
 fs/xfs/xfs_mount.c             |  35 +++-
 fs/xfs/xfs_mount.h             |  32 +++-
 fs/xfs/xfs_qm.c                |   3 +-
 fs/xfs/xfs_qm.h                |   8 +-
 fs/xfs/xfs_quota.h             |  37 ++--
 fs/xfs/xfs_super.c             |  27 +--
 fs/xfs/xfs_trace.h             |  76 ++++++++
 fs/xfs/xfs_trans_dquot.c       |  52 +++---
 49 files changed, 1600 insertions(+), 250 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_health.h
 create mode 100644 fs/xfs/scrub/health.c
 create mode 100644 fs/xfs/scrub/health.h
 create mode 100644 fs/xfs/xfs_health.c
