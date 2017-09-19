Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59938 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751284AbdISDwk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 23:52:40 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8J3nb7d015875
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 20:52:40 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2d2t6w0d4k-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 20:52:40 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v4 0/3] XFS realtime device tweaks
Date: Mon, 18 Sep 2017 20:52:35 -0700
Message-ID: <20170919035238.3976871-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org

Re-worked patch-set based on prior feedback & help from Dave Chinner.  See 
change log in each patch for change details.

All code (and setting of sysfs options) in these patches should be safely 
gated behind XFS_IS_REALTIME_* macros. (Please point out any such cases which 
are not!)

Richard Wareing (3):
  xfs: Show realtime device stats on statfs calls if inherit flag set
  xfs: Set realtime flag based on initial allocation size
  xfs: Add realtime fallback if data device full

 fs/xfs/xfs_bmap_util.c |  5 ++++
 fs/xfs/xfs_fsops.c     |  4 +++
 fs/xfs/xfs_inode.c     | 18 ++++++++----
 fs/xfs/xfs_iomap.c     | 12 ++++++++
 fs/xfs/xfs_linux.h     |  2 ++
 fs/xfs/xfs_mount.c     | 27 ++++++++++++++++-
 fs/xfs/xfs_mount.h     |  6 ++++
 fs/xfs/xfs_rtalloc.c   | 40 +++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h   |  5 ++++
 fs/xfs/xfs_super.c     |  8 +++++
 fs/xfs/xfs_sysfs.c     | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 200 insertions(+), 7 deletions(-)

-- 
2.9.5

