Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51298 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753338AbdKVWkN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 17:40:13 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAMMc3lB020980
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 14:40:12 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2edf4h0pdy-3
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 14:40:12 -0800
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH RESEND v6 0/3] XFS realtime device tweaks
Date: Wed, 22 Nov 2017 14:40:06 -0800
Message-ID: <20171122224009.3533341-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org

Re-sending patch; re-based to 4.14-rc8 (& re-tested).  Patch 1 in this series
is reviewed and is ready to be merged independent of the others.

====

1. Inode flag now correctly set when locks are held via XFS_BMAPI_RTDATA
   flag.
2. Realtime flag is honored when set by user via ioctl or inherit flag on
   directory.
3. Misc changes around formatting & bounds checks on sysfs options.

See individual patches for more details.

Please pay close attention to the change in xfs_file_iomap_begin (patch 2),
the new version of the patch by-passes the xfs_file_iomap_begin_delay function
in the "realtime" case, since the realtime code here is not reachable/dead
(see assert in this function).  Instead, we by-pass this, hit
xfs_iomap_write_direct where the XFS_BMAPI_RTDATA will be passed on to the
xfs_bmapi_write function where it's set.

I'm curious if there is a better approach, and/or verification this is
sane/safe.

Patch set based off Linux 4.14-rc8 (commit
39dae59d66acd86d1de24294bd2f343fd5e7a625) located @
https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git .


Richard Wareing (3):
  xfs: Show realtime device stats on statfs calls if inherit flag set
  xfs: Set realtime flag based on initial allocation size
  xfs: Add realtime fallback if data device full

 Documentation/filesystems/xfs.txt | 27 +++++++++++-
 fs/xfs/libxfs/xfs_bmap.c          | 35 +++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h          |  3 ++
 fs/xfs/xfs_bmap_util.c            |  3 ++
 fs/xfs/xfs_fsops.c                |  2 +
 fs/xfs/xfs_inode.c                |  6 +++
 fs/xfs/xfs_iomap.c                | 18 +++++++-
 fs/xfs/xfs_linux.h                |  2 +
 fs/xfs/xfs_mount.c                | 24 +++++++++++
 fs/xfs/xfs_mount.h                |  8 ++++
 fs/xfs/xfs_rtalloc.c              | 90 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h              |  2 +
 fs/xfs/xfs_super.c                |  8 ++++
 fs/xfs/xfs_sysfs.c                | 80 ++++++++++++++++++++++++++++++++++
 14 files changed, 305 insertions(+), 3 deletions(-)

-- 
2.9.5

