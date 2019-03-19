Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725934AbfCSFJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 01:09:51 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2J552GX089052
        for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2019 01:09:50 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2rasu5rcj2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2019 01:09:50 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Tue, 19 Mar 2019 05:09:47 -0000
From: Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH V2] mkfs: Round down log device size if aligned value is larger than device size
Date: Tue, 19 Mar 2019 10:40:27 +0530
In-Reply-To: <20190318155757.GM4929@magnolia>
References: <20190318155757.GM4929@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20190319051027.27897-1-chandan@linux.ibm.com>
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
Changelog:
v1 -> v2:
1. Remove extraneous parenthesis around conditions.

 mkfs/xfs_mkfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d1387ddf..c9e22560 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2937,8 +2937,9 @@ _("log size %lld is not a multiple of the log stripe unit %d\n"),
 	tmp_logblocks = ((cfg->logblocks + (sunit - 1)) / sunit) * sunit;
 
 	/* If the log is too large, round down instead of round up */
-	if ((tmp_logblocks > XFS_MAX_LOG_BLOCKS) ||
-	    ((tmp_logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES)) {
+	if (tmp_logblocks > XFS_MAX_LOG_BLOCKS ||
+	    tmp_logblocks > cfg->logblocks ||
+	    (tmp_logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES) {
 		tmp_logblocks = (cfg->logblocks / sunit) * sunit;
 	}
 	cfg->logblocks = tmp_logblocks;
-- 
2.19.1
