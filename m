Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39455C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E78F61209
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236521AbhIPKKr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26654 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236263AbhIPKKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:46 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xtCS010930;
        Thu, 16 Sep 2021 10:09:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=nO7JsFMuI3+MQ+KJ7gkYlms3ZxIczS7uvk7WfIvggMU=;
 b=qvsh64Jjb93wl5pXAAsVlFvV9GzjVA0pNK6PGtMcGy2f1KH6/rHCOPlcQwVSM5e5GHqJ
 S/Hhypxmouu8krqoUlC9fiKLtyEbegM+oh2V0Tk949p5Hw6RrQVOoJ3v539iodmTGO1e
 SfMZORKKS/pkynr8MpIO85hcFcYGeZkgalf6EP7RGBg7ibDWXaWU02Y58h0A2bHaM0Sj
 ChLYSAfwsmOWiV+Vq50ylaqWQ+Iv08YuqCzTYw7IL9RoDkeQv18nev0wWOy+vMfUtrW4
 eLeMJC4QdFkhgcijIbYPt+W6KbCeqUW8ILWmYaUXmxQfi9SAEZAMrx5O4IjP0ziLDPMC dw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=nO7JsFMuI3+MQ+KJ7gkYlms3ZxIczS7uvk7WfIvggMU=;
 b=RYlfXZvn/dVzDRL64muFgFkVmzHvMDtMixyVDbI35jxluOCSG8QQoE2+JtJ7szHVMIGI
 w0xnZrVC61TJ2SH5QEbcK5pQwFnMRVmwZjebOSeq2wCfeBr4KDRP8kT/gh4yTTh2Apva
 tv9QhEKGpMVJIa6AZoNuQ9QRdf4j7fYTAn8wwjfFaR6jC8561AExPXfmYKecGKJlwjvG
 DB8ctGFOIZ7SIzRRx8Ud78z9RXC7jqkON/XUeJ3XrMDwzjLk5rE7rWzFEs4nI8MrW9q6
 DOf8qU7sGmcFh559TxNeSuroAAkAwGRjr7zaBfnCgaYSmMHD9jELDz+nYwXKNWdlPelO HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jysjvf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6dsK160469;
        Thu, 16 Sep 2021 10:09:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3030.oracle.com with ESMTP id 3b0jgfv64w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:09:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmermsMRhr77uZqQyLKM36tC6n2vqMlzvWJq+cr3ePN8sEz2wsEjYRnb6g/uVlG3vd2qPc+nxIMstB9ssdgqB8StlAh2x1sQt1XWmKVObORWhlpXIz3JTsfnedJEcilAYNSUHHDwWOErpPhp9gamdTm0qLQWhN3nuiqzhE/2evGmk9us/a+6xsUC/qL7jYlgQ2YAuzL3NG5bGVdk4TznKfvYdcTUmnyG6UxbA3sTE93oUa2jc2372YYBaAAeGf8VA5BeBJoW6VrCSKfH56y+poVntgl3du3Ahu0IGLP/CMZSBSAky40BtK4iO3A1hdlUSRnSkUhwQWe+jGPleys8mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nO7JsFMuI3+MQ+KJ7gkYlms3ZxIczS7uvk7WfIvggMU=;
 b=OrGVkkqetKnOlsI1yjJdl0aRUD9UpuKEYe+NkBoh0/uyyDQmo9ax+he4kVcJfk75Gf743sKByxSxglsd6S9SD+9na2NOX9fXpSsGGEc9kQHjucKnSO7j4zu0Fx0Njig4s/gRNo7iasgoZWgfxqAcaF7rUFD9MLjhFXe4mroF728PrebibYueFqQbnvgEfyOXchE0udg+cgxV0h0o2XkiA3U4QElPwZiP8jjqnjQocechufWovuxbubq43TbvibXXl8naTTdZEftQbjkD4tm4KgbJsQn4Y6koRttF9c4vhsm0yXUlEmTPjHlZED6r5EPJPUQLp3u+UIsxE78y9C62yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nO7JsFMuI3+MQ+KJ7gkYlms3ZxIczS7uvk7WfIvggMU=;
 b=PFQ8PT9Bs8ZpKjXupIkYuXVZ61o7PfXLsdMAEdS+9QLhuHVev1P6T4jFTAMHOBjUZ18iKslB7oizFt43CqRt5y3XEspK+ZkYS8z55I5Z7Zluvf4Mgu0WeJcLb+7aXJnY62aMWb5cxvvIFb8ld0NsQcRk4nwvZsdF2pHDkXrk2Mw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:09:21 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:09:21 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 14/16] xfsprogs: Add nrext64 mkfs option
Date:   Thu, 16 Sep 2021 15:38:20 +0530
Message-Id: <20210916100822.176306-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:09:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24aa4d63-b3bb-419c-506c-08d978fa0d58
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB47480E40A24E285EFE281A76F6DC9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gs3Tl6xcbH4hCD2NWQQ1WdZk//13sM7ifFiAVZhAZJ+BD7U3zBre5TYtpwJcpQNpnQySOY/lkY47zMuOHD9UJSvEong6F7ygP4MXKm+dLLucP3HLxSpCi6JH9B9XvF93XTlOYQmADpAq8F1jkvTejwYchPoQts6FcDRJyPFgcX9r6E28n4pDO0D+XwQY+/TCojjtCGaH/K7IJjRLIbiZYHZVE9KMLcQ32wSpGPVjBWSL1OEJKb3I21rPixpJU9g668V5lAEVt8KGFsilKVYNvg8QVnotWKoU0sZOC834FWAzk//BdmLtvGvnd1OnonA6zjl2cHiyTNSMEG8ERZ661k/Xc7NUj+aHDmX9ph5hl+yn+kV7mrE23pbwHc6mouIZk5jcGWu8mCOHVdKzX8iewBuTk5Mv4Wyh8F5FVW7BtwQmjtABPvuHWO2OELCMzY5XHK1qmaPMK1zSAR0cXwA/A+gB5r49rj+VZ8VSezXapeyc0NQujkQ3p6U9n3cfhNclmDyr2aWtO43K/rAvvUeSaKRr5Z8T/fnI7++18ceTSdUOOzWP5J3RzfV5mX2Ivyms
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(66476007)(2616005)(66556008)(66946007)(6916009)(2906002)(1076003)(4326008)(956004)(6506007)(83380400001)(316002)(8676002)(36756003)(478600001)(38100700002)(38350700002)(6666004)(52116002)(6486002)(8936002)(5660300002)(26005)(86362001)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ihZnf1iu5aOhMz3gJXEfwBChaHlnS10oe0T1oggXBg/4oQNtUioW4F00tCRF?=
 =?us-ascii?Q?3CuLZyAg0DLmvc8b+muGnO+ugUPWyUhW7Ba3PRfdhb5xrPFRg0mJf2+0/Bk3?=
 =?us-ascii?Q?oTZr8fHV5iPu6wnymmDXrWWBBHx2qwuqW/4MwpkO0FY/tvZ/DgPXPei09edg?=
 =?us-ascii?Q?LTR/FX4/6jvRhjAvdHoAk1xJQD4S34JUAAoVIAC5zdJZDYmXYkqruuVKmK2u?=
 =?us-ascii?Q?P8F1scApg7NNTpbD/W2S48pheu51ZV3Vb79INgIbz6Y9rjm/f/AoIm6+RBMP?=
 =?us-ascii?Q?r88hqNMwHNWNAc2B9uLfNpdqgzk0Y9XbJE92+Y6mN4JHgviQet60P4cmsY45?=
 =?us-ascii?Q?spSoMbxKrWqy+0fd03CZehUUB1pWKHLQHFj5pIvqNo4RCzL6jSlE5auXLrj9?=
 =?us-ascii?Q?mhv6HTjg07Pj0BIsQWCOnoutpvIejVhiE0FJCHti9EcTMLkVVZ9E/GfVGv6e?=
 =?us-ascii?Q?7RmP2bF1PxN7jVSGSLc7tEfqo8w31pkrLZ4MUsEYuUUwXDo+NZDj8JFS/ND3?=
 =?us-ascii?Q?j3H5SMxFB6qP4b9FbBavQVM8chhw/maknnJOPg4vm9P68IXnwVHkVJ66mozW?=
 =?us-ascii?Q?FT4vJxUOP/+v2HxxNs5RA+2P6JVvN/LEvD3vu62HcuMAW2csOzWRo4YOnlj/?=
 =?us-ascii?Q?z8GyJTh8+bgrSgQs6tCDTfjqyAUtGGtEL7ILaPm8teIfn5AudB0Bng/SscZU?=
 =?us-ascii?Q?Ti5E5xgphMZfXqeNZx+2BKgn7M0Fs0M0uhD2lc3X6kHSrAIp+e0zxWAsu8M8?=
 =?us-ascii?Q?Vm9zDo54/b2OHfbl/YCvvEJh/v3SbGLUaUfEW9G+13obNDLqEixQ9OOW++I6?=
 =?us-ascii?Q?a8NE8rRaFNwOmT5o3F2eOCDGMElPF1azaNHhOsnNY2as5RUDxrmfGvyzWEro?=
 =?us-ascii?Q?QE6/nGfVE9lJuPCZC+aTGAkEqkP0TE1WYubznjISFaGhWWLqkvu+SZWD7A6O?=
 =?us-ascii?Q?0II+UgmFMBacB869opD+0OMl2X1hj2AFWQiO74ZTzy1UuRWg49U+o99opTTL?=
 =?us-ascii?Q?DeVSeyX/drD+iID1XK0JYJ0YTy0E39N4tOIKURw2wbOVCekuxNfDITI0C9VX?=
 =?us-ascii?Q?DZ5KcjAdUYY2mGHld5lucyKWNk9AqtjxPoRxEMQevNfPlmfVrC7F80pl0eLR?=
 =?us-ascii?Q?KwFlmSBmGKdg1go+dA8nJ9r7Zto46zWrJLMhU/PD3r6tqnxGLWibKqdLwUuk?=
 =?us-ascii?Q?9eggTdPTCaXUKufosUA1gvhljsoMINXwdMgc+2SwHXo66SWcLARo1SHC1Bhi?=
 =?us-ascii?Q?ZTXM5En/n+IJUt8JcPX/JWdqo+kBBdYexXJat7C+Mu07OWWTd6BMhGMbJt1w?=
 =?us-ascii?Q?t3J6xyuI9eBNdDVyhGZvgJwK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24aa4d63-b3bb-419c-506c-08d978fa0d58
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:09:21.3990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8fZllXTXwwzXk2xon4UsHAhGIi2A4D0sQnkVqvAky6tmYFHTzc1O67RFjKoa/YgVoF2FfQFX8cIqbEekGQGU9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160064
X-Proofpoint-GUID: lLKMpRkXqokfp_0sdFcCEzof1edCrlDW
X-Proofpoint-ORIG-GUID: lLKMpRkXqokfp_0sdFcCEzof1edCrlDW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Enabling nrext64 option on mkfs.xfs command line extends the maximum values of
inode data and attr fork extent counters to 2^48 - 1 and 2^32 - 1
respectively.  This also sets the XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag
on the superblock preventing older kernels from mounting such a filesystem.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_sb.c     |  2 ++
 man/man8/mkfs.xfs.8 |  7 +++++++
 mkfs/xfs_mkfs.c     | 23 +++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 2489f619..8d066c1c 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -124,6 +124,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
 		features |= XFS_FEAT_METADIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
+		features |= XFS_FEAT_NREXT64;
 
 	if (sbp->sb_features_log_incompat & XFS_SB_FEAT_INCOMPAT_LOG_ATOMIC_SWAP)
 		features |= XFS_FEAT_ATOMIC_SWAP;
diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 0e06e5be..8e24b8bc 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -650,6 +650,13 @@ space over time such that no free extents are large enough to
 accommodate a chunk of 64 inodes. Without this feature enabled, inode
 allocations can fail with out of space errors under severe fragmented
 free space conditions.
+.TP
+.BI nrext64[= value]
+Extend maximum values of inode data and attr fork extent counters from 2^31 -
+1 and 2^15 - 1 to 2^48 - 1 and 2^32 - 1 respectively. If the value is
+omitted, 1 is assumed. This feature is disabled by default. This feature is
+only available for filesystems formatted with -m crc=1.
+.TP
 .RE
 .PP
 .PD 0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 899da545..37c22277 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -78,6 +78,7 @@ enum {
 	I_ATTR,
 	I_PROJID32BIT,
 	I_SPINODES,
+	I_NREXT64,
 	I_MAX_OPTS,
 };
 
@@ -433,6 +434,7 @@ static struct opt_params iopts = {
 		[I_ATTR] = "attr",
 		[I_PROJID32BIT] = "projid32bit",
 		[I_SPINODES] = "sparse",
+		[I_NREXT64] = "nrext64",
 	},
 	.subopt_params = {
 		{ .index = I_ALIGN,
@@ -481,6 +483,12 @@ static struct opt_params iopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = I_NREXT64,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		}
 	},
 };
 
@@ -813,6 +821,7 @@ struct sb_feat_args {
 	bool	metadir;		/* XFS_SB_FEAT_INCOMPAT_METADIR */
 	bool	nodalign;
 	bool	nortalign;
+	bool	nrext64;
 };
 
 struct cli_params {
@@ -1594,6 +1603,9 @@ inode_opts_parser(
 	case I_SPINODES:
 		cli->sb_feat.spinodes = getnum(value, opts, subopt);
 		break;
+	case I_NREXT64:
+		cli->sb_feat.nrext64 = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2181,6 +2193,14 @@ _("metadata directory not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.metadir = false;
+
+		if (cli->sb_feat.nrext64 &&
+			cli_opt_set(&iopts, I_NREXT64)) {
+			fprintf(stderr,
+_("64 bit extent count not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.nrext64 = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -3175,6 +3195,8 @@ sb_set_features(
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
 	}
 
+	if (fp->nrext64)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
 }
 
 /*
@@ -3887,6 +3909,7 @@ main(
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = false,
+			.nrext64 = false,
 		},
 	};
 
-- 
2.30.2

