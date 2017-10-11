Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46524 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932406AbdJKCiU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2017 22:38:20 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.21/8.16.0.21) with SMTP id v9B2b2kS026368
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 19:38:20 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2dh1h62y71-4
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 19:38:20 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v6 0/3] XFS realtime device tweaks
Date: Tue, 10 Oct 2017 19:37:49 -0700
Message-ID: <20171011023752.1373259-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org

Sorry for the delay on turning this around, I believe addressed the various
points folks made from the last review:

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

Patch set based off Linux 4.12 (commit
6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c) located @
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
 fs/xfs/xfs_inode.c                | 18 +++++---
 fs/xfs/xfs_iomap.c                | 19 +++++++--
 fs/xfs/xfs_linux.h                |  2 +
 fs/xfs/xfs_mount.c                | 24 +++++++++++
 fs/xfs/xfs_mount.h                |  8 ++++
 fs/xfs/xfs_rtalloc.c              | 90 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h              |  2 +
 fs/xfs/xfs_super.c                |  8 ++++
 fs/xfs/xfs_sysfs.c                | 80 ++++++++++++++++++++++++++++++++++
 14 files changed, 311 insertions(+), 10 deletions(-)

-- 
2.9.5

