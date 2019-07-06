Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfGFVZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jul 2019 17:25:30 -0400
Date: Sat, 6 Jul 2019 14:25:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't update lastino for FSBULKSTAT_SINGLE
Message-ID: <20190706212517.GH1654093@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>, kernel test robot <rong.a.chen@intel.com>
Cc: Brian Foster <bfoster@redhat.com>, lkp@01.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The kernel test robot found a regression of xfs/054 in the conversion of
bulkstat to use the new iwalk infrastructure -- if a caller set *lastip
= 128 and invoked FSBULKSTAT_SINGLE, the bstat info would be for inode
128, but *lastip would be increased by the kernel to 129.

FSBULKSTAT_SINGLE never incremented lastip before, so it's incorrect to
make such an update to the internal lastino value now.

Fixes: 2810bd6840e463 ("xfs: convert bulkstat to new iwalk infrastructure")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6bf04e71325b..1876461e5104 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -797,7 +797,6 @@ xfs_ioc_fsbulkstat(
 		breq.startino = lastino;
 		breq.icount = 1;
 		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
-		lastino = breq.startino;
 	} else {	/* XFS_IOC_FSBULKSTAT */
 		breq.startino = lastino ? lastino + 1 : 0;
 		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
