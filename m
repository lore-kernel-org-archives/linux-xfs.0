Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C03FC7EE2A
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbjEWJBT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236245AbjEWJBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F846102
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:15 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6EH2I027651;
        Tue, 23 May 2023 09:01:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=5OFkoXsQTRnwt3MwZi2MvSdGy1qxNFC37HDKMj1/AcM=;
 b=OuykondSwfHHk1LCzjB6fKzu/9yv9iAljEqooB16TLHQhvN+kyRkRh83pFmvF2GqSkUE
 ebWRrOmLGP6wyHTkIMYksHowcBVBOC9nnlAhn0emRqYRO3n7ImycLPJvuSCUuamUwOuY
 tRPL437KNH0Kv4q+3qwuD67Zht6IjQwL+rGcLaHq7M6hJy9kObCRDGXAeB1W7ork64gS
 V9ZpnoTK4owZ369gZlLEubZ43VCwWfpgcP5Fiire4jtbAcVK4QA/k0Xod6FJnx/JbTaD
 Z0OuHy8tZkPKm78iBHp08uhkDHpfLzXhYN4HJn5mUkNWg80t8aPvlp0GgL0N1mX0OUda dQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp8ccp8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8ZZVu029026;
        Tue, 23 May 2023 09:01:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:09 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrb007681;
        Tue, 23 May 2023 09:01:09 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-8;
        Tue, 23 May 2023 09:01:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 07/24] metadump: Postpone invocation of init_metadump()
Date:   Tue, 23 May 2023 14:30:33 +0530
Message-Id: <20230523090050.373545-8-chandan.babu@oracle.com>
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
X-Proofpoint-ORIG-GUID: M7_jvOkTnxcIfIsGIymDQ8NEwIlhzwnd
X-Proofpoint-GUID: M7_jvOkTnxcIfIsGIymDQ8NEwIlhzwnd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will require that the metadump file be opened before execution
of init_metadump().

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 62a36427d..212b484a2 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3129,10 +3129,6 @@ metadump_f(
 		pop_cur();
 	}
 
-	ret = init_metadump();
-	if (ret)
-		return 0;
-
 	start_iocur_sp = iocur_sp;
 
 	if (strcmp(argv[optind], "-") == 0) {
@@ -3177,6 +3173,10 @@ metadump_f(
 		}
 	}
 
+	ret = init_metadump();
+	if (ret)
+		return 0;
+
 	exitcode = 0;
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
@@ -3215,8 +3215,9 @@ metadump_f(
 	/* cleanup iocur stack */
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
-out:
+
 	release_metadump();
 
+out:
 	return 0;
 }
-- 
2.39.1

