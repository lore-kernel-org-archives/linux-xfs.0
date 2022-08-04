Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFD6C19F2A
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238723AbiHDTkd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238778AbiHDTk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA18BC19
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:26 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbkbP018690
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=vUNoEHIXvRmyE8mLt6L0pqlEJ3EHdz4j/x1ZNJ2JPFA=;
 b=iECP5maGydyweMOQ3GrHmihBt9LCyF3/cbNptvxLLQ4j9YrtnKcA6u9xLzTvi+MOjJEW
 EfERc+MRoobR9LYxMWavEXGhMTzbstiwQH863xN9KmvEbgHdV0EbgLDtl7lO2bg0wwvY
 UmJXT8M9/h61yFbAB/N20BnwMA9Wxzv6HqJYrAJhH4yqw/Mt4OSJ31xcIf1nZ/Y2PBQ1
 I5NCueEtxRDeZk9bpwZZKeVU/qKqMWpIkhb2TOLZxUoNlv7Ti8pTbZ9bIRQCMRkVF0wm
 cYDVCuV6inLY69iajecKKPBpoq9+TVCNc1VtOEnV1epobkXNN8xVg7daXAzBUVc4Fmq5 Dg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9wmyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274IEkVo003021
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34n716-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5se/Lblu1pJwBjD3IvfhklH5jf6pnBuQYLmU1pwo5uXmYF/XNEtzAqSMbHVpRyXu3bO7etRlDN7zwlZI1hhX+nZhGXvAWM2ndLI9XmYDmdcVwI+ZQsASSRGAcChU9fT66vrnkKMNKeHHpwPVjV7MacgmHWdSTCVuURJBCBCD1gTAZC18JyXmyiCuEGjB65db5XKkJT+IfDw2GGlYy0WvBUgJeJV0DwoMaY/unAT6fY2BhvfSN7C5Jl9pJSl+Dir5McJdhxn/7G0U6PcmLD1pPKj658LIB6LH80dToC8qIDlqtJL46JxyN1uPQLuWt8FzQ5faffvWk+M6KbsLeJejQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUNoEHIXvRmyE8mLt6L0pqlEJ3EHdz4j/x1ZNJ2JPFA=;
 b=S5ouVkNS7UnI05nClU4DJb/V+IrFz6RBnEjZG/R/5rrhHXO4/LCDFX2X8JHqKOiv1IMFA6BDBgSEyykLZRKWKWq6Fdarc1MSzPk2AaoILwwRLdCOpz/4tS/+bDC6B5efWRXvD419+KViNKYkcmqr5Bmv0b+tdz70IILYepuh/OR6INcgpPR3Iz1qfU3qpRj/GanKwhEBRXHTk1AkJufj+wIz+AK0Sw360xy2zNOb1PiWHj2HMqhEEJ2hRczoxf4f4BBB29QwjPlwoHwvS7nmi62Ao3Va0x19X1e/jFFXNKIFZEijdc2A70QlsdfW5YXMuaIRmLlf5nfvLiLIiIs9+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUNoEHIXvRmyE8mLt6L0pqlEJ3EHdz4j/x1ZNJ2JPFA=;
 b=XLjanTgj3s49+l7TUm/41olhdri2it9IYbWTprWhLUGgreGD9zJpH3M2edtX0NL2tQus6pvnGFEkJUmnw+auVm098YWyRVJ53TjBRY7yDl6kEc6aI1EWkvO9tmjF3Ymwuup12gUylokYwdTQNUn6DUDfcpOE5q2hS17U9ZAuF9Y=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1368.namprd10.prod.outlook.com (2603:10b6:903:22::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Thu, 4 Aug
 2022 19:40:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 04/18] xfs: Hold inode locks in xfs_trans_alloc_dir
Date:   Thu,  4 Aug 2022 12:39:59 -0700
Message-Id: <20220804194013.99237-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d29c2c8c-e2f1-4ffd-d4ad-08da76512b93
X-MS-TrafficTypeDiagnostic: CY4PR10MB1368:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tevHLwIfG2t0hBQdSd1f/+qh1esnjYJIm45jM7vSB+X4JvGeX4cCuwjHhERwUKddCPy8cikngAJUbNl8wxUOqPq/D0CdIiB+SziZpuC48O9l3zzgutG20KghQX+A/awuJagGInGTp56EgSx/RJTPmf4JuBEdy2BNLGIefGe/6X7U+ivBTXCzYOMiIvT9jIpdjC10UrQjuSaVqEWREYhiSeI64yd7JtMe1cCKjIJ5ZzMZx6Hk9RJB+mdLDo7+O1S/oo6V5Lp9kK+EX/xl15ggaNnxyFAsBaq1ecBZxdO6kPieaLQ3FeryVzoSeMSEyYQz8b4oObOW4UhCptIYaGsScedpNK59RA2oBKHeucexJNO6HB8vPg/OpmwdTCS0ix8M/RE6hUFdrbdqkoZu2vUU7C6oQ6IiUcdP3QN6lkRfSfXcm77EUEkYM9khbls2t8Gzbw+d+pZrAvJr+a45UyB700Ke/BHqTBqSRL0nCDApaEGusYBz8tkyoGc2aEMSAuYPfWInF+w7IHpF9H82TjxXqglqTAougo91Y1wKQmw8VR87lc2Erk3KxFCZRBxoWmCYu3irclfB2MY0xL6XRhln4eiUja+XLct8JaMKZD9ezaUwRo3puYFzNcMKbmwKA2gAhIJFNtaO7lEsirLJWvDofRswFQ9VGqHBbfwXXPU2NrWV4cdNjXibk0j4dhZjLkVThJiHAbwAU90TjyM97bJjbx3f8gr0QXlkIYfyNua2ohha91q3aSTpD/ZDD8rCRxWuCRBlp94aiTPLCQftHKwau+EQ5buJWC+3Hb1EL2hiv9s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(366004)(396003)(39860400002)(376002)(6512007)(6506007)(6486002)(316002)(6916009)(478600001)(41300700001)(52116002)(6666004)(38100700002)(26005)(1076003)(83380400001)(36756003)(44832011)(38350700002)(2906002)(66476007)(66946007)(186003)(8676002)(66556008)(86362001)(8936002)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9OeI9H/6i8MocW4jfbS1eCZOuQH8qjCFhrYCLhfDsZjYV95jn1f0fOB4dO20?=
 =?us-ascii?Q?IUIJDedvpRYw9kqcRK9IAyZIoUXMOWm+LRoF1xlrgICeC6AR5VQk+V3CUTgR?=
 =?us-ascii?Q?aOUjfsMOHH8T3H2ESkeIjiHRKTP0ToBe4wKCplnAwn+EB47Fm6TwWGcSJQZG?=
 =?us-ascii?Q?4sgJPoV+yn1ngaIeJdCcVjJYIB94PePamOo93socymeRvZJlBnlvnskfmoMz?=
 =?us-ascii?Q?dCbChSrUGMZwtMK8JBnWinH6wnj1J0wpTuY7wT5Bntg2gReJN0MAYNsoPs4/?=
 =?us-ascii?Q?6CR3CXIi9HxwHhYyyySaxAsbLDngeytLFtSnoqfnBHR6u/wSjLHdtinDo7Bp?=
 =?us-ascii?Q?HwdTt+OMTnLRN1/WFwJ3n0QiM5AsesKWb5iQhGCtBXJ01jSx2vmq8AsNCG90?=
 =?us-ascii?Q?hNOjZ7myOE0KGiOKtbcKdSadCBJrR/NhwdOM9kyinAzE+112YhLQieiIHufj?=
 =?us-ascii?Q?e3mlRCoKJh92jdv7fD/DcVjQYyHxHcA+7F3tcJaFkMml6gG6WLJeEUuRVNe6?=
 =?us-ascii?Q?N7Ks0hDmcmAh+jbAuv0pfw0pbknxhdRie91VgQIUkHJtZoKXSPDng99a+mkw?=
 =?us-ascii?Q?UVOVG7jz60TAACyqjnaYLmTuiACRb5OXwmkuSaX6pkA4QIRIfplVDRTUTkVL?=
 =?us-ascii?Q?zwX8OcDrhlRtuhWWxP5xgeTLM4mHnZg+Zomr+FumTo75Cy0Q1QJiks4bIqkD?=
 =?us-ascii?Q?E8aOcUMhRBfJSMf4gvR0wpsOclItPCiQ1t2NlZNT5SrwXxZqYmugPsLL1Y9Q?=
 =?us-ascii?Q?dztnFXfcPLYLxuHFqGkgYyPhqzg4eyL5nKWB+XWrgqCuzghkKyE/iZn3ml6f?=
 =?us-ascii?Q?/QTGJRle/zZRHfqpC13qRW70L0ySB5BtYkbX63BBguzj7XkRRN2A3HIwkdbh?=
 =?us-ascii?Q?JCZJk+tPtnp7ct4uHl8uS8k78MdG6N95s9vsHZkSxBwXPi+Fzzp/r9Ipq39P?=
 =?us-ascii?Q?2ssKAX7EhAHstpnORXoW6qcNKMGZ11oFwzmFJM2g9if/QSEcaIcPHShzbIeP?=
 =?us-ascii?Q?Mq6hV4AX0fOeoFsKjDOEMXIm+78C9rFjhMN3vS8zdOey3KPr0k09DxCDtNad?=
 =?us-ascii?Q?xTSpgaKxE3JBxWeaAzaJfURkAiTwcfUieO+i19A8nLSpsr0cUeOmtkaHSM2o?=
 =?us-ascii?Q?eg4RuF6g4Pz3c25xCL635iK8EnKbBLHBq8EyXeuCVIMFiecU5L/4e2BBlm7Z?=
 =?us-ascii?Q?MXE6wWA2ROFzAkCgxBx2eeVzHY5EJDzx1eNRrCwipNNWL+8c4WqXA58qp950?=
 =?us-ascii?Q?7XCfD3CzGgM73IobHL0oNKP4gR2pR3IkIyGTR5W3RFTYSNoWT+kQC/afg2yH?=
 =?us-ascii?Q?mkuGLDjozoCZ/WULsqmk14jE3n8ScAHuYegKQj7nFfW/NJ3Bu7qCrbyQhE2E?=
 =?us-ascii?Q?c8xHgIplJHdPQ+pZxlPXOJliKDeFBKy9yZfyThLyCawV9K9cS3pvVWvp+Ayq?=
 =?us-ascii?Q?tm+x6xthhMZVqG4sSjycT7MFA6ZZIev7YRuMbRHnlu5y8nUMFCnbFc7Z65Lf?=
 =?us-ascii?Q?9Q4tb/xM0LVqS2cjm2Abj99SpJ/aUKl0xAYl4KFHWJ6/zB9fHNgV/T5eFjl/?=
 =?us-ascii?Q?NgP/JPl6e2hffTCyjSibYlNlGs0w03GoRCKB9T2fqo2GoEtuHUrIwjAw2SMD?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d29c2c8c-e2f1-4ffd-d4ad-08da76512b93
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:22.3445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TkCzdHU+wQkKZoNwWIT7gOUt2m2q3wo+fSNx6NQuMLl5AIM9R5eXbgGc8PRBnjrgFxKGRYLJY4RQjTbtkqmY/DB2sjrscZZ0Un+dNs2tHPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040085
X-Proofpoint-ORIG-GUID: wXuaVm3WTXiIeR9plLmlCKnRpTbwTuPq
X-Proofpoint-GUID: wXuaVm3WTXiIeR9plLmlCKnRpTbwTuPq
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

