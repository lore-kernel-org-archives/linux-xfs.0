Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32C4C7EE29
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbjEWJBP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236245AbjEWJBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F35A121
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:11 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6E7fg024604;
        Tue, 23 May 2023 09:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=HVj0Vur7L3aHcILUSMuz4/pjMpNEnP1voyfXidwocOQ=;
 b=nAQ9Pa+0RsY5jDOQjnV7fb3zUOVfar4qpwmNmqsLPHNHcDlh7GeeKKEZOJ5INg6un16Z
 DwZWQp1pSGXgNC2ei2u9wZsTT1Aldv4APhjnn847VYxi7aWCmjIbpBrSwfVwlSoNGw8N
 dmc0kVqY8sTIRz15+0jPldV3RrUkGn/73FgEEo+k06uN2t5vaVIiimEXstHn06ikqgeZ
 qnU4ob9Y9nB0GeYqt8BDNMXMjcKb9iX+dwiLV2zmFCvVn0yACq6oV85zJMi3TJqeDAgc
 1fZejLxwIelfCgMMJOX/jrAUwloFWFdT0xHFgfNmEwTKTvs1xqUbd+LnloRVr1WIg4OV yw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp7yvkwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:08 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8l5Qq028926;
        Tue, 23 May 2023 09:01:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:07 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrV007681;
        Tue, 23 May 2023 09:01:07 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-5;
        Tue, 23 May 2023 09:01:06 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 04/24] metadump: Add initialization and release functions
Date:   Tue, 23 May 2023 14:30:30 +0530
Message-Id: <20230523090050.373545-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230523090050.373545-1-chandan.babu@oracle.com>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_05,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=831 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230074
X-Proofpoint-ORIG-GUID: YGgPNYVj0rdZ3M6MBgyp7x5awJeEwhaI
X-Proofpoint-GUID: YGgPNYVj0rdZ3M6MBgyp7x5awJeEwhaI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move metadump initialization and release functionality into corresponding
functions.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 88 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 36 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 806cdfd68..e7a433c21 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2984,6 +2984,54 @@ done:
 	return !write_buf(iocur_top);
 }
 
+static int
+init_metadump(void)
+{
+	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
+	if (metadump.metablock == NULL) {
+		print_warning("memory allocation failure");
+		return -1;
+	}
+	metadump.metablock->mb_blocklog = BBSHIFT;
+	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
+
+	/* Set flags about state of metadump */
+	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
+	if (metadump.obfuscate)
+		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
+	if (!metadump.zero_stale_data)
+		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
+	if (metadump.dirty_log)
+		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
+
+	metadump.block_index = (__be64 *)((char *)metadump.metablock +
+				sizeof(xfs_metablock_t));
+	metadump.block_buffer = (char *)(metadump.metablock) + BBSIZE;
+	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
+
+	/*
+	 * A metadump block can hold at most num_indices of BBSIZE sectors;
+	 * do not try to dump a filesystem with a sector size which does not
+	 * fit within num_indices (i.e. within a single metablock).
+	 */
+	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
+		print_warning("Cannot dump filesystem with sector size %u",
+			      mp->m_sb.sb_sectsize);
+		free(metadump.metablock);
+		return -1;
+	}
+
+	metadump.cur_index = 0;
+
+        return 0;
+}
+
+static void
+release_metadump(void)
+{
+	free(metadump.metablock);
+}
+
 static int
 metadump_f(
 	int 		argc,
@@ -3076,48 +3124,16 @@ metadump_f(
 		pop_cur();
 	}
 
-	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
-	if (metadump.metablock == NULL) {
-		print_warning("memory allocation failure");
-		return -1;
-	}
-	metadump.metablock->mb_blocklog = BBSHIFT;
-	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
-
-	/* Set flags about state of metadump */
-	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
-	if (metadump.obfuscate)
-		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
-	if (!metadump.zero_stale_data)
-		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
-	if (metadump.dirty_log)
-		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
-
-	metadump.block_index = (__be64 *)((char *)metadump.metablock +
-					sizeof(xfs_metablock_t));
-	metadump.block_buffer = (char *)metadump.metablock + BBSIZE;
-	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) /
-		sizeof(__be64);
-
-	/*
-	 * A metadump block can hold at most num_indices of BBSIZE sectors;
-	 * do not try to dump a filesystem with a sector size which does not
-	 * fit within num_indices (i.e. within a single metablock).
-	 */
-	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
-		print_warning("Cannot dump filesystem with sector size %u",
-			      mp->m_sb.sb_sectsize);
-		free(metadump.metablock);
+	ret = init_metadump();
+	if (ret)
 		return 0;
-	}
 
 	start_iocur_sp = iocur_sp;
 
 	if (strcmp(argv[optind], "-") == 0) {
 		if (isatty(fileno(stdout))) {
 			print_warning("cannot write to a terminal");
-			free(metadump.metablock);
-			return 0;
+			goto out;
 		}
 		/*
 		 * Redirect stdout to stderr for the duration of the
@@ -3194,7 +3210,7 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 out:
-	free(metadump.metablock);
+	release_metadump();
 
 	return 0;
 }
-- 
2.39.1

