Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC132C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbiGRUUj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiGRUUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911C12CCB0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:34 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHZ5Gm026736
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=vUNoEHIXvRmyE8mLt6L0pqlEJ3EHdz4j/x1ZNJ2JPFA=;
 b=LHxoGmo4eoxfuGoysfwBt0UBQBQmdZ0K70kbAR37Fh1fe947m+z4SvG9V4O6xnjBkoPf
 v+fb36e4KbNuQEnSei3qX3e9+6l4f6411xgLmcJwmha4KILGYmAQ093tvCv2zLMKZAwC
 VS5L0uM7IvAoFiUONV6wd1bddCqUGBVwgXXBO+MtdqQwlsAf/H6tWdigrJPobxhUgcYu
 mNddjnHJDLm+1NJcQLf7aDuz3Izzk2g21u8kkLkm7+hI6lapdtv+s5P08YHYjr5EBPu8
 7azXY9KFdW5NmGxDaUB2FKZ4SA8sxymXdkvvtWZfHOtt2nJ4xAHxIiN6pqGw4ijekTkC Zg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbn7a4cfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4t7001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6hBsHtGpDFzV56YxFWJ8LCNryHIIyPlap4aEWC9e/P/d4JFtm9klfDM9LKPWlT5+FBhO0gyd1t0q3cB6nFr9GOhoAy3j9LoP393X6yiBZkYojH2Qrkai9srhG0A3g2Dtuy7dCnAhueb6tk7wJ9nhtESh4GMXBIha78KC83/IsmjIc3blkvmYLuiP5lY42RdcypG1tjvhfMAu6bohMu3TpZh6kRFQRwRyr6olgPEnHWjGQaaK+ArHIKGxjJClR3LIFEpK9Flv+CjpfOcjeHqWgVEc7m4Xtgi0/wvVpZuMR6Vos+j1Mtj0ZDbURkEhhIPiT8h0YCKg93Qyg5HLArVOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUNoEHIXvRmyE8mLt6L0pqlEJ3EHdz4j/x1ZNJ2JPFA=;
 b=Qmlk9vRfDbUSKlReavGEIhWuSCvTL8cEDrPajBXX+rmqGqSKOrQa9qnGzE3s7n//zuIqNRTjFZ0l5tyQg4YZRwV2evjVJkqzFh88L9OltGkyz49MztrVJ6b2ekNAPhKei4dZY4O8BSOb7zQnLNRc5NYRjXjXP1bjwvTMoHn0qkzwZTd4OyyJA88WtmWrV1lNGZsEpM6UfjP1h55cv0vKYuRVA5AsJVHf8TQZ4tsd12pCLvBMrMDJyUsxiwEfHs2fLtWQA8QNsm7+VpjlNrWaQqoUusFoZb8QO1jux4OLRehMp+104SHKKVqCpp1gmOOc9eTUawhOv8uMZ6+anBnxBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUNoEHIXvRmyE8mLt6L0pqlEJ3EHdz4j/x1ZNJ2JPFA=;
 b=fFTO56s+bhuYuHT5/3WGjELGnOeqnf3/k6dGrMgK3UezQrBAVKkPHcsPnWcbiQwf8gD2/1pjfoQ96GcAWeXkK6Ag4cawQqq1Idzp/sAdML4aeMRcCuN5a+k1G2yeCKR2j4ocfpvKkyJ/90Wt5zTYw4DTT70cVE3Em3wvFSQX5N4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:30 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 04/18] xfs: Hold inode locks in xfs_trans_alloc_dir
Date:   Mon, 18 Jul 2022 13:20:08 -0700
Message-Id: <20220718202022.6598-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bf53e1c-5273-44c9-abff-08da68faf5b3
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G/Q/c4JMoWY3l6CG1AUZMRzyS0OG7UyEJ5pKAlwOLv954/3CHQ426tH2MRbs3hj8J39k7dGYKlL/q6ftRD6WPzBqqQMn3g/yME8n+8YTDnj/3BPLuBZllwcUHi/JGoVWLGX9Y+Yltkts8BlYzfeL4rcmKbeQVX0mg29L30MetMWohxhWuIq7B8nB4sUNQwKgwOXVvTyi7LtO/2w2aP0AReSGDNTXE+OSAL/3VrBP0aDlF++dRX/D6hIQZcECwih6KC650qhIynY2wkxQlEIeozZEjwe2IhAyiGgLw1BfGYEg6+w2MnJKFqqJtwkGGAxhXK5f9F+XpfdQ5ehOFZglFZVuDjXADwt9fpi+kbBSXDH5GMekwZQwlyioBqyn+XzEq2c0JhqsPUfxn4fB4xLP28Q6muOg8eF0M8/KYk6gzsktmqGk+Sh6d3F/xeNKG/UiWjNLpPcvWbiOc07jT2W4QUPM5BsAUVHCbbHa2kXJ9m1Okycz1pOJWSJYobDqFbw0gGMRgXT/y/a9e+LzpzxWfvtO4uENAIwtyMhoKDDLudixc6AX+1LtM/ovcJLwrD0uk3h/Uh5IpmgxBV7Ha81Q24Iv23WqAAjle1J26CKMVzwqRKsCyWisuMHMG7Qb+vCIiDDbgf1MKgy1dGZj5HndP6/jTFLs4MG2H+vzGlulH81fZdpkNBDs7C0+YIDHFUs4cPavesNmT+3nDlS5f68m9Vdh1uKsp8sRoEhp1FApXqCA8sfencZD8GZLQT4YeQGM0qhLTE5XN93koxfswBJljle207VzckGUol8Bi31Td58=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5OncxJ/q8EifJZPvt3+XKzXZr6unmxrWdudPWDiBWOqJZJ+lDYZB59N1UHgb?=
 =?us-ascii?Q?UVuCEOEURpCLyLxQh7XX0CyjoqbK3zBLalGJZRvbu5WDscZFV1S6J0PCKCZ7?=
 =?us-ascii?Q?U5HDu+pSGfcyRhDaG0V1neubMP/sud6J17UBG++GiLy/OsOJvlDgbS4zjhRA?=
 =?us-ascii?Q?H7sM1m5Gc1VmWsdg+jkMjWkntBBK9JeLPDBqgtIfYQZbDR8Dw+7xZEiuYTKi?=
 =?us-ascii?Q?fhNFVcZGXOXRl8ANoSGGM4S/FQW1DX8FXQrmnFz4IUbA+7mqG4Tptsg65LWf?=
 =?us-ascii?Q?ABTYVTK6ek7KXpIDiqwk7ZwWG+pRHwqR/VytWEWCf03/qYHW7Knk4AdugcEW?=
 =?us-ascii?Q?h+MP2kgecWUgF0A6wKPBw4KG6nHvCYyQo0ntN9to76FxCXZDz0/UHdxu6Kkf?=
 =?us-ascii?Q?GTDo4IvjCvTZ3nDRWjkTyd2u5DTZucLHOSvBO9pJCJuR8nWjlMatGzoeAXGS?=
 =?us-ascii?Q?z5bZ9qPCyg029Eww8vaWuWyWYJlKkrK8T0u3a25kFbZEUo+A/RjFCqm9Ukse?=
 =?us-ascii?Q?Ao9Rc3B4oh4oDu7qpCbQUR3HsnEnZTxmFA0QbXz06Pv0SFMXiHLY4v1Ff77X?=
 =?us-ascii?Q?q0P1K5TQVFjEzHCosFkQnSLjohuCdbEJGzgBbKuqfuUzwXLUJl4AZJ/G3ahh?=
 =?us-ascii?Q?ITh3TnLOPdsaiOoKGofl5SGIQButBnFRATtf5tKpkmlLjzkM1EJKztKP9zND?=
 =?us-ascii?Q?cGmLYM7NTFscgyyIxel2jcNh50jIxrkB2qwar5T8kQnxSu/+go2OpHvSFLau?=
 =?us-ascii?Q?SEzfjpmSDVO2egnpXOZk2uMKtYu7pR1+GvPNkY3GxeraOm1lK0e0krx51Iv7?=
 =?us-ascii?Q?H/fpWJo4ef37c1d3ZBPNFa2tEnwGL3QETq5oZDOqP+2KuIICytzpRp13ubSO?=
 =?us-ascii?Q?gHaKOLtvRcemNg2ifc3qqr4z1GVa+36aiNoIPug3r35tbC2kc5pW7IWXopXw?=
 =?us-ascii?Q?fcA7FijJ2SmiGkLh6j3WMz6tsVpMG10R8QgnfMdAmaiKRH3/ELHjDZcb/5H2?=
 =?us-ascii?Q?At6/qBvImUlJQFYGoeKmB7rEMEkmV6Cxk5heyKWbowrkizKsW+YOqeOdOa4t?=
 =?us-ascii?Q?jfYZ9wUcevPFvDYnVEGJ/K/ILDR9CBxRCMgA2ehc1xvjq3nGRvC4CtUIZhvi?=
 =?us-ascii?Q?VwlcR2EIF+7CuzRWTnnlM5vu4fmAWgo0N5G2xJr8/KHBEON3RzgsZy1j2bo5?=
 =?us-ascii?Q?P5kcvWBn0y72Q1NB+Wlu+QhM6+isAi5VEXFD5mhPvvO4HEP/PMF+pfuTqPhL?=
 =?us-ascii?Q?5FJwQc8zEjL7GmySqdtD+KMSqkFmXWtyXxm47ZW8XeNNKy8Rc69CgQeqq51V?=
 =?us-ascii?Q?5gB66MiyLPkK90thAbQ4EaWzgyytRoZot19YtRHbP1MVsby1MQF4BU2ul7Q8?=
 =?us-ascii?Q?vOQzNEWMmVPgbFg8WBUWXNuVJscfsTHUHn1u/p92El5Qpqu4jI+Vax0rHfg2?=
 =?us-ascii?Q?mPux/IlRCJ+YTlZJ4tKFcXVz+W8foplQvqXGwmdr1tUiD5QRFiGIA07FBlqz?=
 =?us-ascii?Q?2nvOAxqVnRnGCastV/dLoSZTMMYpOwNmf2w4QEEMvghG4XOA+Bc5b1SFB+79?=
 =?us-ascii?Q?ZdOjaBo0Rrh5TjSx6OHrHxOhQ0hXU8yXMxqSsXMk90engpPOySsfqrNkn0jX?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf53e1c-5273-44c9-abff-08da68faf5b3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:30.1227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0kkHBhhY6yamS4sZcp0K+A7BHrbsvuGApz1X7vS0B+u4T4/7IPj8iX1im3+YANsPyWDrke2aySJZ7ajO2s+a3m9gZpiQYd/mWitfbZZ/n4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-ORIG-GUID: oJMElIpLt4fliFzLnxqxOnHy8ORznrKx
X-Proofpoint-GUID: oJMElIpLt4fliFzLnxqxOnHy8ORznrKx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 14 ++++++++++++--
 fs/xfs/xfs_trans.c |  6 ++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cce5fe7c048e..2703473b13b1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1278,10 +1278,15 @@ xfs_link(
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
@@ -2517,15 +2522,20 @@ xfs_remove(
 
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

