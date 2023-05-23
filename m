Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AD6C7EE29
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbjEWJBX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236245AbjEWJBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC88FE
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:19 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6E7KL018830;
        Tue, 23 May 2023 09:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=BRmTfGYqBT84VMTSDOA5n6aX34AoTwePLwN1BvYiyjM=;
 b=QzgwFyzfTOHc00SZqr+0slRYa9vD6JfE2uNmv9Nom3z1nor2/TLQg5i3sCSQMvmiIlaq
 fo6uWuMLFJm5ddOIcWrv8bXlKchLUORXFAsUgyYu6efhnYtjwdz7UNwtD1yr2nFfGgtw
 Enkw5r/UqszijPLMgdebr5Hzy5g4czgob2qImiUlUvYF6fjVdUmvicg/cZPDrosYaePk
 ZZ4BmUhhFgJdEzFvStKrac7N6v/ixIBBrBrnx7st7XvxjaTwr47LI0/apDCCCazb8Lnu
 EdxVcNw7WFNq9WKTTYJelRxOWGO1F2v2Aa/5n82WhWQ019+d9jxWx+QtqgOsJmB7A5Be eA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp3qmkug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6tBgU029028;
        Tue, 23 May 2023 09:01:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:14 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrn007681;
        Tue, 23 May 2023 09:01:14 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-14;
        Tue, 23 May 2023 09:01:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 13/24] metadump: Add support for passing version option
Date:   Tue, 23 May 2023 14:30:39 +0530
Message-Id: <20230523090050.373545-14-chandan.babu@oracle.com>
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
X-Proofpoint-GUID: xQ2x5igoy_vz4vsEfuY2Q0v6Sm8wbJhO
X-Proofpoint-ORIG-GUID: xQ2x5igoy_vz4vsEfuY2Q0v6Sm8wbJhO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The new option allows the user to explicitly specify the version of metadump
to use. However, we will default to using the v1 format.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 627436e68..df508b987 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -37,7 +37,7 @@ static void	metadump_help(void);
 
 static const cmdinfo_t	metadump_cmd =
 	{ "metadump", NULL, metadump_f, 0, -1, 0,
-		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
+		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] [-v 1|2] filename"),
 		N_("dump metadata to a file"), metadump_help };
 
 struct metadump_ops {
@@ -91,6 +91,7 @@ metadump_help(void)
 "   -g -- Display dump progress\n"
 "   -m -- Specify max extent size in blocks to copy (default = %d blocks)\n"
 "   -o -- Don't obfuscate names and extended attributes\n"
+"   -v -- Metadump version to be used\n"
 "   -w -- Show warnings of bad metadata information\n"
 "\n"), DEFAULT_MAX_EXT_SIZE);
 }
@@ -3112,6 +3113,7 @@ metadump_f(
 	int		outfd = -1;
 	int		ret;
 	char		*p;
+	bool		version_opt_set = false;
 
 	exitcode = 1;
 
@@ -3140,7 +3142,7 @@ metadump_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
+	while ((c = getopt(argc, argv, "aegm:ov:w")) != EOF) {
 		switch (c) {
 			case 'a':
 				metadump.zero_stale_data = 0;
@@ -3164,6 +3166,15 @@ metadump_f(
 			case 'o':
 				metadump.obfuscate = 0;
 				break;
+			case 'v':
+				metadump.version = (int)strtol(optarg, &p, 0);
+				if (*p != '\0' || (metadump.version != 1 && metadump.version != 2)) {
+					print_warning("bad metadump version: %s",
+						optarg);
+					return 0;
+				}
+				version_opt_set = true;
+				break;
 			case 'w':
 				metadump.show_warnings = 1;
 				break;
@@ -3178,6 +3189,9 @@ metadump_f(
 		return 0;
 	}
 
+	if (mp->m_logdev_targp != mp->m_ddev_targp && version_opt_set == false)
+		metadump.version = 2;
+
 	/* If we'll copy the log, see if the log is dirty */
 	if (mp->m_logdev_targp == mp->m_ddev_targp || metadump.version == 2) {
 		log_type = TYP_LOG;
-- 
2.39.1

