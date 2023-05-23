Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38613C7EE29
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbjEWJBa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236286AbjEWJBZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3114102
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6EgoW000558;
        Tue, 23 May 2023 09:01:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=SnThpmzanunCluFeNjqPbhi17uDttUC74+5qoCJDqAI=;
 b=ekjxO6/bzooqm8AXWpuAFJnHnR4Ibvw0O1idwUDJkN+2hFhH4g63WWIBS/M71LU8jjH/
 tpWbiNnd+T3wibD+pOVW0mhfBqa5QL3smCAPCFDyBiZnepAYcS4ouXa9bCYalPg0EdZB
 fojs1MGR0EJVrYMw1We9Rl+X5UVu8uBM2bOZfw9wwE0AWTGYOGiB32PZuT2fMGVxvRYV
 erX2a1B9aD49nU9mOXb0Y5mTvhs7NJOEL7ojqCs6ts1b9eeQA+YPSKBMu5aL+PUZ/m/u
 eArIuCFFH/Doodld90T0iLBqobk6zQBV8eFAEtwkNepuEiGOkwL9QzFPwjVGNUsrATCU OQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpprtmkug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8KSVQ029007;
        Tue, 23 May 2023 09:01:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:22 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xws5007681;
        Tue, 23 May 2023 09:01:21 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-22;
        Tue, 23 May 2023 09:01:21 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 21/24] mdrestore: Extract target device size verification into a function
Date:   Tue, 23 May 2023 14:30:47 +0530
Message-Id: <20230523090050.373545-22-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230523090050.373545-1-chandan.babu@oracle.com>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_05,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230074
X-Proofpoint-GUID: 4DbyqoIK9n4aD9N0LS8Rgk3cbMIFFVx5
X-Proofpoint-ORIG-GUID: 4DbyqoIK9n4aD9N0LS8Rgk3cbMIFFVx5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 43 +++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 52081a6ca..615ecdc77 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -86,6 +86,30 @@ open_device(
 	return fd;
 }
 
+static void
+verify_device_size(
+	int		dev_fd,
+	bool		is_file,
+	xfs_rfsblock_t	nr_blocks,
+	uint32_t	blocksize)
+{
+	if (is_file) {
+		/* ensure regular files are correctly sized */
+		if (ftruncate(dev_fd, nr_blocks * blocksize))
+			fatal("cannot set filesystem image size: %s\n",
+				strerror(errno));
+	} else {
+		/* ensure device is sufficiently large enough */
+		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
+		off64_t		off;
+
+		off = nr_blocks * blocksize - sizeof(lb);
+		if (pwrite(dev_fd, lb, sizeof(lb), off) < 0)
+			fatal("failed to write last block, is target too "
+				"small? (error: %s)\n", strerror(errno));
+	}
+}
+
 static int
 read_header_v1(
 	void			*header,
@@ -179,23 +203,8 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	if (is_target_file)  {
-		/* ensure regular files are correctly sized */
-
-		if (ftruncate(data_fd, sb.sb_dblocks * sb.sb_blocksize))
-			fatal("cannot set filesystem image size: %s\n",
-				strerror(errno));
-	} else  {
-		/* ensure device is sufficiently large enough */
-
-		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
-		off64_t		off;
-
-		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-		if (pwrite(data_fd, lb, sizeof(lb), off) < 0)
-			fatal("failed to write last block, is target too "
-				"small? (error: %s)\n", strerror(errno));
-	}
+	verify_device_size(data_fd, is_target_file, sb.sb_dblocks,
+			sb.sb_blocksize);
 
 	bytes_read = 0;
 
-- 
2.39.1

