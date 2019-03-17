Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45592 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbfCQJTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Mar 2019 05:19:17 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2H9ECro146259
        for <linux-xfs@vger.kernel.org>; Sun, 17 Mar 2019 05:19:16 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2r9ek3fqcm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 17 Mar 2019 05:19:15 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 17 Mar 2019 09:19:14 -0000
From: Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH] mkfs: Round down log device size if aligned value is larger than device size
Date: Sun, 17 Mar 2019 14:49:43 +0530
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20190317091943.18222-1-chandan@linux.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.ibm.com>, darrick.wong@oracle.com, sandeen@sandeen.net

When using a disk of size 798903808 bytes as the log device and when
having a log stripe unit size of 32768, align_log_size() rounds up log
device size to 195048 4k blocks i.e. 798916608. This value is larger
than the device size. Hence the last call to write(2) inside
libxfs_device_zero() would end up returning an error.

To fix this bug, we now round down the log device size if the newly
computed size is larger than the actual log device size.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
---
 mkfs/xfs_mkfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d1387ddf..bd05d071 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2938,7 +2938,8 @@ _("log size %lld is not a multiple of the log stripe unit %d\n"),
 
 	/* If the log is too large, round down instead of round up */
 	if ((tmp_logblocks > XFS_MAX_LOG_BLOCKS) ||
-	    ((tmp_logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES)) {
+		((tmp_logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES) ||
+		(tmp_logblocks > cfg->logblocks)) {
 		tmp_logblocks = (cfg->logblocks / sunit) * sunit;
 	}
 	cfg->logblocks = tmp_logblocks;
-- 
2.19.1
