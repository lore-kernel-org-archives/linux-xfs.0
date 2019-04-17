Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42076 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbfDQQ3L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 12:29:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HGSXG3037285
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 16:29:10 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2rvwk3v60m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 16:29:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HGSXlb116687
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 16:29:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2rubq71q3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 16:29:09 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3HGT8CE015982
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 16:29:09 GMT
Date: Wed, 17 Apr 2019 09:29:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 3994fc489575
Message-ID: <20190417162907.GJ114154@magnolia>
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
the next update.  I'm still accepting patches for 5.2; this is an
intermediate step to broaden testing.

The new head of the for-next branch is commit:

3994fc489575 xfs: merge adjacent io completions of the same type

New Commits:

Brian Foster (4):
      [4d09807f2046] xfs: fix use after free in buf log item unlock assert
      [545aa41f5cba] xfs: wake commit waiters on CIL abort before log item abort
      [22fedd80b652] xfs: shutdown after buf release in iflush cluster abort path
      [1ca89fbc48e1] xfs: don't account extra agfl blocks as available

Darrick J. Wong (15):
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

Dave Chinner (1):
      [1b6d968de22b] xfs: bump XFS_IOC_FSGEOMETRY to v5 structures

Wang Shilong (1):
      [2bf9d264efed] xfs,fstrim: fix to return correct minlen


Code Diffstat:

 fs/xfs/Makefile            |   2 +
 fs/xfs/libxfs/xfs_ag.c     |  54 +++++++
 fs/xfs/libxfs/xfs_ag.h     |   2 +
 fs/xfs/libxfs/xfs_alloc.c  |  10 +-
 fs/xfs/libxfs/xfs_fs.h     | 136 ++++++++++++----
 fs/xfs/libxfs/xfs_health.h | 190 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c     |  10 +-
 fs/xfs/scrub/common.c      |  20 ++-
 fs/xfs/scrub/health.c      | 236 +++++++++++++++++++++++++++
 fs/xfs/scrub/health.h      |  14 ++
 fs/xfs/scrub/ialloc.c      |   4 +-
 fs/xfs/scrub/parent.c      |   2 +-
 fs/xfs/scrub/quota.c       |   2 +-
 fs/xfs/scrub/repair.c      |   9 +-
 fs/xfs/scrub/repair.h      |   5 +-
 fs/xfs/scrub/scrub.c       |  41 +++--
 fs/xfs/scrub/scrub.h       |  17 +-
 fs/xfs/xfs_aops.c          | 135 ++++++++++++++--
 fs/xfs/xfs_aops.h          |   1 -
 fs/xfs/xfs_buf_item.c      |   4 +-
 fs/xfs/xfs_discard.c       |   3 +-
 fs/xfs/xfs_health.c        | 392 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c        |   7 +
 fs/xfs/xfs_inode.c         |   4 +-
 fs/xfs/xfs_inode.h         |  15 ++
 fs/xfs/xfs_ioctl.c         |  53 +++---
 fs/xfs/xfs_ioctl32.c       |   4 +-
 fs/xfs/xfs_itable.c        |   2 +
 fs/xfs/xfs_log.c           |   3 +-
 fs/xfs/xfs_log_cil.c       |  21 ++-
 fs/xfs/xfs_mount.c         |  12 +-
 fs/xfs/xfs_mount.h         |  25 ++-
 fs/xfs/xfs_super.c         |  10 +-
 fs/xfs/xfs_trace.h         |  76 +++++++++
 34 files changed, 1393 insertions(+), 128 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_health.h
 create mode 100644 fs/xfs/scrub/health.c
 create mode 100644 fs/xfs/scrub/health.h
 create mode 100644 fs/xfs/xfs_health.c
