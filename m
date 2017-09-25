Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45728 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934449AbdIYToV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 15:44:21 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8PJiKuH011198
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2017 12:44:20 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2d785r00bv-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2017 12:44:20 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v5 0/3] XFS realtime device tweaks
Date: Mon, 25 Sep 2017 12:44:15 -0700
Message-ID: <20170925194418.720146-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org

The patch set has been updated per reviewer suggestions, all changes are
noted in the change log for each patch.  The most notable change is the
addition of xfs_inode_select_target and the refactoring which took place
as a result of this.

This cleaned things up as the policy code could be contained in this function
nicely.  I still kept the two functions for the alloc_min and fallback_pct
tunables in their own functions, as I didn't want to clutter up this function
with the policy logic (however little).

Patch set based off Linux 4.12 (commit
6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c) located @
https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git; I also have a clean
patch set for Linus' tree (@ 4.14-rc2) if that's preferred.

Richard Wareing (3):
  xfs: Show realtime device stats on statfs calls if inherit flag set
  xfs: Set realtime flag based on initial allocation size
  xfs: Add realtime fallback if data device full

 fs/xfs/xfs_bmap_util.c |  2 ++
 fs/xfs/xfs_fsops.c     |  2 ++
 fs/xfs/xfs_inode.c     | 18 +++++++----
 fs/xfs/xfs_iomap.c     |  5 +++
 fs/xfs/xfs_linux.h     |  2 ++
 fs/xfs/xfs_mount.c     | 24 +++++++++++++++
 fs/xfs/xfs_mount.h     |  9 ++++++
 fs/xfs/xfs_rtalloc.c   | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h   |  2 ++
 fs/xfs/xfs_super.c     |  8 +++++
 fs/xfs/xfs_sysfs.c     | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 224 insertions(+), 6 deletions(-)

-- 
2.9.5

