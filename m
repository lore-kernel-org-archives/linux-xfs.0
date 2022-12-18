Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7722C4167B
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiLRKD3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiLRKDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861CE6352
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:19 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BHNmi7G019280
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=p+ajdmAuPHTwwdKb6mU8U+6ouxowBIzJiTCTb8Z9cOE=;
 b=2Ao3SECmG1oFPO6yQSoeHgs59i5/24E5peyzri9Jp1MMt2hZlGOY4Ol91TFAaHiuuZ2d
 P0DgVO8smVjTFzDI+RCZwGN9NUISFyrYwrPN/MFF6J2mmZa5S+5xZwqKxPuKeMttpVVp
 ONAgxtFKjUMfFFebCAqYp8p9rYJTZOLAd7oOu5jS3UeTECyZSzD5JJ0ep3hfQh65/N2M
 zqjA36+D9L1nupMMv+hL5zJTLg7Zdf8sGwghlLAYuIvVZlKiBF+cvQJ+CShdoK2InCAh
 4kXUFSIT1KIdIGB27h7qX5OeFMsZZ4IIThEWpRcqAB98SU+U45F1SNng/pZ4jOcfshMR Tg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tn196q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI7ween024738
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478mxj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XA/U7EQPaFFMh6wurqxmawsNXJGcUder+6rYLB2cadOZ09a+0HSMt2tRe03HiCkmilb20tyXguPvlS7zYG9mQnmU68/Yy3s6+lVxKLvtZC30Q1g2we2gWivu29xlhPzVB7ZonOa7jUdGZOLZWvwWqfyxQqpPvSMd/C0dK6TX9s7sqn0GYXZyavqvkcelVp8N89BUwYhRvsvEtOOJuO86ndLTWg3Czs7TZU1fKAWFjCZWg/oZdZ3XmRzA51ycKk0COqb0cZzcaZr+TmZ5yCrRonAndYmSceCzByfGEIHw8hMmnJ7SOX6ZlT5XJdo8l77d7MnTahjRG/StZtR3HylB+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+ajdmAuPHTwwdKb6mU8U+6ouxowBIzJiTCTb8Z9cOE=;
 b=Wska4W1y7ak73aQB2gOecV325zNYUMs5f1qJL2ZdEYLart96KdU03rB/88RkJofOjnCR4pAh6mN85oj4vjx69wQ0k6akvmlLe5HcNdiKlC2POLc7xIL3YSPKP2irXxvVWYREmjESoOYwNK1cLTCs32eVSzyyfqk+OKy3hIX/OBjknTdkd+LfU+s/Rm3IDrhqFaSpJBWs9SG1w9AX/2kj68BHbOBc/JbzhNBVGSrkjJEQOruUpOyAtvnhu+10abRb+UklWmeI/s+CJHC+3GGq3a7I94z4zbERzkNybFjKF8e3LA/7/Lp8yZmj9j6ymuf3lRtrvzGARbAYNAbzbcjkzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+ajdmAuPHTwwdKb6mU8U+6ouxowBIzJiTCTb8Z9cOE=;
 b=YbGWKa73EkMVNtvc+SdDsC2EeWbfRLaUv+pq+vJser5ypifryxBz0Sn2YAprDaGRT9KJ3hQ4wkSmM56sAIBNVtgaYaLuqXpTrfieSPrT4PhgwigbocD1JMgebvNVDW9MSz9cbGXcRZdAI53IJcafHB/mr3VSobBcDWxgFSRKk9g=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:16 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 05/27] xfs: Hold inode locks in xfs_trans_alloc_dir
Date:   Sun, 18 Dec 2022 03:02:44 -0700
Message-Id: <20221218100306.76408-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0081.namprd03.prod.outlook.com
 (2603:10b6:a03:331::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: dd3ac7ca-3c89-4db3-ce3a-08dae0df1542
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WzsDmtHlAx3zxTcHlvMMbcyo/BbGB90PFU/KAm4rhiMLfKHdTAXL/uPFDk9UIgDHpswm5CTaB8jWmB5484FLjZTFO5Z+pbCGNXdL6s4Q4ORXCdxsYWFt6A00y51Dzl3rbC2Vm7cEZCwhF3JdURFEr7LcfKSu8vV14Uj+n8bbVgaWWfz7sKMVf7wTq58hmL7yt2DH+Xh5ukOAixHLf1b/iK8hHmb2QTVd6F28joGZJ7vBo4oCgyrHoUA3lIT/PnqLAxK46rRQ90bFAF7qBS4gGfTWf9kH+LfEVZ2vBx31i7pT8p7E8vTShcCm1717qSejJj+oC+DUwvFoQSYHny++pDcTeMRMV5/aME7moJXN9xErCBxw11NxkSAXLKOp2FMXYZiwEpwkQzTUx5Bi10VwZtIUwCSG5sLzAQlurPRl8ixQXWZJOIlwXkZIHn2S4wfebxqPk/EDdDdyzbJ0cUofUluqaaI5Ng9fok287YZsfTBl2R/YTD+fKPVrZpX63rJAL5YM3paTk5urLq5hTwDb5py1OG0tskRem1LRlspYBeOsbWFqixyv3Tyyb/NBbztDu081UbP+s5eGRSHuSx4PduwYmJP8TMoY0NdmBy5+pSEO79wdZ+6rRBznFmKN6QUePxYozn1nqBSzXabbMv1C+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FQ0WYD3snetU1QN/WHVRH3j/k8uqEsfMaMu6KY2bhvS8Oev33SMPsb9mrpdh?=
 =?us-ascii?Q?JnsNG3W49ytLz+8uMT0PlrTYi/pKfYWOi20gAwh/1qIVsV0uBgzz3Gb0bzlL?=
 =?us-ascii?Q?h7kX/AMxDi3EG46euZm/yVHf5UrJDzocScnxyI9c7sc+rICyvr1c8yhuUJH6?=
 =?us-ascii?Q?G9o5Ql5xAoZDpKQx0Tht6PwNvYtMliVgDYSQmeAVwzzGU7VeVQQW9q+LEkWQ?=
 =?us-ascii?Q?XG0eHUa/PBDQO041ZSCFJryBPgaKBoD8E8rTAXE1ukQIKPeCBqd3N0/P6aeD?=
 =?us-ascii?Q?uW+X8qw1OwDL5O893CeS3u9Zb4OmsRLsj3w8K88SK/H/ZoSUWFtPfoS6VJUS?=
 =?us-ascii?Q?/XUY6GhCzEGi+/eY9gByD+TJhh2s3Qrn7IdcJ0EqnjPJGuXp3hiAgBgJs7VH?=
 =?us-ascii?Q?xXrKWnIZQ3qeverDaPmL0c4W57fTrCxPNDgquo30DrAvbU3Oy+v6fWetUqhb?=
 =?us-ascii?Q?afqwI3jc+fcTUSqsEeSktAP0mSW97ZfsyK6aSpFu1DcLca0uLQNp3YE5Idmk?=
 =?us-ascii?Q?zINwef6APSF0cXBBJXA/A6muagWnYHbPmTPkBhFhaHq5SjPCPLpQhjKwW7Rm?=
 =?us-ascii?Q?cknT2zCbMo+rl4Sj9MitnV1kK+0zAfvMXXbsd4dIXsLkJcqTQSIwY1VJr8Z3?=
 =?us-ascii?Q?tc/lMZKt/s4pD3AgAeeZcNzj+1zh81jHtiIOYIqK6FwXaZP6UblFeagfKN1q?=
 =?us-ascii?Q?zf3kMd+Tnvi1AW31hQhO4orD+tOmFYcZgqYDCKtked8R+G3DR5mAD4T1HJU/?=
 =?us-ascii?Q?WLKyIIkq87mER+HmxcoHMdwIVFGSGqdtWXdjwj45napsdJSxL7kPkJKoS0yq?=
 =?us-ascii?Q?SS9m8ESg9i5hyAljxbQomg9ShxD5E5dL1nIdaq5Kn/aLsivFBaLrz0Jn0W0I?=
 =?us-ascii?Q?3yHVBUlUcHNvrjodMkVWS3GTJj/R6Qt+5D/LUSHuhPc0hpz7cb8ZGmx1iemS?=
 =?us-ascii?Q?x36GEv8OyhHGj/N0Ob+qaqZO0300+gV/fpdeJgN1pAtjjRHkAP4wOffhfXOU?=
 =?us-ascii?Q?hB1BUyEINfFSPGpynd9IwkwSGFda11//A7JJHHpF/vdzTzm9dNf9FAMUIY+r?=
 =?us-ascii?Q?M+qXWSBHrpjMW/ZUzalem4Eq0RH7gsb8TVuzHtayBbvdkCqvsZd1lmuKTWjW?=
 =?us-ascii?Q?o80f2BcVz2lGBP+n5hP0WqB9c66u/kWCL2gtiWlLXLyb8SH287iGeBZ/rPEA?=
 =?us-ascii?Q?lGoLsp80VrvJChXiQ4syO2UJ3VcUTovDY1oDVNYay4b1XTt29HH9nffecF69?=
 =?us-ascii?Q?q0Z00u1/8wjwzsSHMwd8zCwnSV+2cZp9BREBuTHO/cPSGFHk4IRhFm1lQzlD?=
 =?us-ascii?Q?I+3vw0y6Ln0CZRoh29S3YYn/TpJ/DQEiENLSlxXOTLyMU4QwnQJX1sQU6H3N?=
 =?us-ascii?Q?OlNCwVeGENvTNFAWdHTrLeQefVNw3Gn64sj0fyUo5WDNygoiR6D7tfp9/3Ad?=
 =?us-ascii?Q?fWNVJeMbiNC1AaNLRT6PXL9/juXeQLmtYAMjLV/SSs/QDQmhk75HHv9WVbFq?=
 =?us-ascii?Q?M5FqMRFjGWppjVpe8Dvn27pOfgwOoifnJOshN+IuWlu9iqLHyholGdtNkIHw?=
 =?us-ascii?Q?ibyl1F/QwoH6a7QALjzVaNOwxGZKuyuFxLcCN6j7aYl6k5vM3bJlFa/IjUWv?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd3ac7ca-3c89-4db3-ce3a-08dae0df1542
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:16.6000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrRZwd+3mm2aOVwsmax6VkMxTKtg26DXM+W9LVmm/WdJB59PdSApvFcWI3TONlVjmGyvHaE0LNy+SpuxvjWJsnzuSgKgOUkQBMiqrgJEBN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: Yw6nxHoAV8gNq3_9npuQFo1k_eBLD5r0
X-Proofpoint-GUID: Yw6nxHoAV8gNq3_9npuQFo1k_eBLD5r0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 14 ++++++++++++--
 fs/xfs/xfs_trans.c |  6 ++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 772e3f105b7b..e292688ee608 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1279,10 +1279,15 @@ xfs_link(
 	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
@@ -2518,15 +2523,20 @@ xfs_remove(
 
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto std_return;
+		goto out_unlock;
 
 	if (is_dir && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
 	xfs_trans_cancel(tp);
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  std_return:
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..ac98ff416e54 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1356,6 +1356,8 @@ xfs_trans_alloc_ichange(
  * The caller must ensure that the on-disk dquots attached to this inode have
  * already been allocated and initialized.  The ILOCKs will be dropped when the
  * transaction is committed or cancelled.
+ *
+ * Caller is responsible for unlocking the inodes manually upon return
  */
 int
 xfs_trans_alloc_dir(
@@ -1386,8 +1388,8 @@ xfs_trans_alloc_dir(
 
 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_qm_dqattach_locked(dp, false);
 	if (error) {
-- 
2.25.1

