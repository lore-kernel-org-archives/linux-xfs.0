Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90862C6FD19
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCHWiq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCHWil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E60F3D902
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:33 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jxuqi026675
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=XRZP0/EZTRxSM1aJCideZZf+Koqs7S6Dw49Pwjjg+Vw=;
 b=fxpJN0ztDQXvSbPMqZTietqa4SSj+72ABu6RRhQq/2aDqMcKv1/wzrtirt1NK7nBtjok
 FnjqPZjxt8NO95T9AMzp/bWbywC01jLbgGts2OGDWKhVQs55T2w4PI690vCf83JmPfjc
 mGDYzS1XmSBw51tGCF5Ax5oJlZUBGa8afQ/ph/HGq1Rvl0YMpRaZTZN4/rd98lHI73BQ
 18TVloxUTyXTBNmUCiOhvJPxVHODPg5nd1dD0h5fMp5LOK+iVPzUFspFA+A6gDmhUrCa
 ouwfAu6Mp5kMdm18TP5T5wXhMooEuORwTHdT+6JlfBuXzWn2m/pCOe/YvQwht3B/dNN0 TA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn95qes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MCXhP007128
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4gd1sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Befu4yp4X+ohT8ER8eqR0F4QAJK43gS+rpxerCXI1oc1/Y+bLpkB+uhj3H5MEbaMl1QJqh1/Gq0wZzAB9jhiLSGZO/Dl4NQ8dd+zUzboItYG3DdshoEG5aSApIxGLZl7Eu7ftAHNkmJVAZKNPhAI2RJo7WkSQ/QLiQUldAywpYsilqVLcwtaYFdGTSAKB/dS1mDrmZeLBMMCoiR08Zl7IMiyi4l7buYJZ6F+Mt1iUZlnIqolvq7KKviVXk4zXcme3lUoQUInzOZJoFL+5AIZKsHEIraUQW3Enw2ObZTbyqc0u8OJYCmpQ+W0ZpT/nIqFqRH2JmC4hyVjgSgqqA/s4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRZP0/EZTRxSM1aJCideZZf+Koqs7S6Dw49Pwjjg+Vw=;
 b=P6aKm9Ak2l6hwWTN2/VnKiBkty1XLUXWPgjSq8CzJBPKlPGs8YosIbeFMhGrJkTUe0wHDDNB0Jk7Lwv3mAT4ZbEEZUU1lZZSZ90sxowDfIXg+9hOoCOELcbAEogrZa+mdFAAAp0xsowsky9202CFKNJUMXGsJ19gu26b+YwA2XMmxXiKX6HzE29X6y++ivMHOy3Mjh+53BnyBm8s8A6OGDiQxPd3GOvn+hoYXWVq9nBgKPMIGW5qx79kzPINb8K3zsMxThAP/YVnEAHA9FagmXXO4QI6UndQlY6EfvQ6FVXROAu98IhZo96FrjddRxxoKhkrQzoYnoIHEkP4hA+CHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRZP0/EZTRxSM1aJCideZZf+Koqs7S6Dw49Pwjjg+Vw=;
 b=UchPDepwQ6NU7zVBC7ui1RoL0n2bbzLgxKVxSMnT8TGJ5D/+zI67VqvvJU8DGXi3KJeZFl6/7+w52C94pUhT0oZ3h4MXwR0wDqf6N3aUbQUgdFaQVbejNkbNrWsHn+8bxsp3PEQWAFIRdjdcKzoOuX62pX3JCKCrwuXkxtz2o/4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:38:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:30 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 19/32] xfs: Indent xfs_rename
Date:   Wed,  8 Mar 2023 15:37:41 -0700
Message-Id: <20230308223754.1455051-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:a03:255::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e30fa0c-dacc-4903-2e5b-08db2025d75a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0dgfiKX4bGkxSekvcOIX2IyH+6+kWIt9woYBWtMVcr/LEgN58Us7hpDha9vIA8f3BkTxgEQjiuIGA9hBLOGEb6X/Tl2m+QsyQDr9k50xSCNjYozznTsMj3EWXDHs95M/kqmJlSAFn68tvHkNL0SJ3XSsko+cPsIyPLJRMEVTf8ETGJMLelOqK0G+xXG5cxetIyfNAoLXbXdzb+/8CvBjdsbBgEgmSamOuOReMBQNepHw0nSg/0t67xasWu2FAN2++U7oDey0OzDFUdJxhFVwUQ8ldwokoD76hRrAwGSn1teidDGAiC4YFQQyGrqM51nu6nLNm+Bzt3QyXd5CeEKCmOF6KGx3rH53IwkgWgMWy7OQeGcqrrvVw1ylW18ay5sUhBdNVZ9C/xs7eCHcaijWtuDqjnu3pxV+U2yiS8ra2Hvwdmd9pNXvaDcoa6olvmxzXcmR4PkYeb2XmEYNfVznVJ1iwFVsJrW+lcIB+5Q/MBWEbaZPqh9xKUjfgrQNXMGQfxzWlfanpmN8eBTm9k8S8FeIBqzTkbJFcVym7DsF8bKqr2anBC/pcJ7P3RSZxmZNl2PiNPDIcu6JZzfdw4HSTuW2zKxGzUlfXAOz37T6KlHuU0bLpYjrccMxFJIpfxcGrbtWVbr7ZkHfZn1Z4m5eyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kGfcUtR4vJYEh799IyrWYgSr1rA9rsxsQs272z3Bx5p/uCqBMcB6eYG2bia2?=
 =?us-ascii?Q?tsQUCxGLc/6tvTfSANmTVEP9tIDTuhagZzx2ocZgmk+wZiJbCV45LudM0ZYt?=
 =?us-ascii?Q?mcfW1os2l3gUmgwXEuOYf330p9e7Zb+RC5LEHnbGISa9iAGkNyjTO+PlheDC?=
 =?us-ascii?Q?lwOc5/Rg5Oo1c8iklUUZLB7DT8krEZwTNJC/OyNyQ1XhbNj3KAZZPT5yctWU?=
 =?us-ascii?Q?z17jUcEjeyZHAp+VVgBD8Iv07Jz1XOVy8mjRcRfLMvSJ/ZD/I49A1cQNX72C?=
 =?us-ascii?Q?G8Rf4qoO/VZWBYeQCFhZpH6HdDBfeWyt8eOdAapyBcxL5/51HaHlG5G2ILhh?=
 =?us-ascii?Q?hSRBa1QnK3ByCQONxJhz3Tg8moeHWCSfJomkJuaiNmWDpP+HvxaD2sW1bCrg?=
 =?us-ascii?Q?Hepo7XbSSmf4W2qibw90/mRsJUPvUHi237m0+i4cQh8FpkcGYtST6bRXicpY?=
 =?us-ascii?Q?Sub+iWz+HifCzIZaSi54pxJJy4Y9g8wthutSefNKTleuSvKkHuZFcUDfLEhN?=
 =?us-ascii?Q?YaWk3ztJoF2nLTI6gFcyyRHLuxXLxOzj8LiRvH6vdhetn75tYsC3Bu9M5845?=
 =?us-ascii?Q?8OjgrhPohxpShTl+yrIQnK1h4ugnObSzReUY3KGH8v2wUJc6qq+4mYpZbyHp?=
 =?us-ascii?Q?hTNfvXnKzh1uHp6Tc747pR1VutPkwYjxpmxLOILszBUo2AlOQnPlW3vc7LJ8?=
 =?us-ascii?Q?ukeGFeWAB3tZnX/fj/qkqXzi1zYbaM6TIKPLhHY4fVV3WwxhSq2VR1D58DmJ?=
 =?us-ascii?Q?tD3OR6gxqUzXXp52zOvFHbaAaIuiNiE4fNyLkmKPPqH7qBQA927fdY0Ch4io?=
 =?us-ascii?Q?g9im5oUBeaSkbPaIxHWyMQz+nN+rVu7ko95Sgla8f2MgdsOaDX0Vz7iGtQn9?=
 =?us-ascii?Q?jczAasILjcxzVfQDpMyP9wLiVudSq2LlSMG1mEmtt947/MpCo5MaXyZ8Ydjg?=
 =?us-ascii?Q?7smEYEEk0Usm8WFz3UAGRXxGSlE+tBerlvihWUEwVVVGvD3quaHbzECpFln5?=
 =?us-ascii?Q?idLTSgr0nNH9xGxrdBn9GVn8SrbWpkjh3gmmpn2C1QXtAINfg2Tjfoy1FAXN?=
 =?us-ascii?Q?SG83Thvn/MuBJ+FTnzjiePAqA388P8Wagr2BqkkNPFWVjYrTxhM1H8OMNDhm?=
 =?us-ascii?Q?kdk+tM87om55pO0AGgpyaTDMGYPpFOs2csk6LSH4kj0o+NBUL8CuANblrLjI?=
 =?us-ascii?Q?igyJqVOk1cYIvx1DYPNNpLdfO5GXUoe2jf4vy2G3SAGxi5NnhoSlTegDdGzA?=
 =?us-ascii?Q?s5HqPLcuPNXZJsJFDfyv9gTR4uT9Zwu3pOif0sjHxekZg3QQ+Evh582Yhxhp?=
 =?us-ascii?Q?rBKuju3mty82DJXHxEi0zMi4uI30VFcyTwnkvrtYSOzOSSa+3y86m36Em1Qe?=
 =?us-ascii?Q?yERdAuTZeoiVgtCUxW3Zy7TUmtBLzw/DC7ZtwcyEWEY1KuUi0Z0vJjUGGf5X?=
 =?us-ascii?Q?ClP+mxbySGJhs9+8QcbCaschfB78acZYxWos2bERsSO9bZkTJfWupktJebNn?=
 =?us-ascii?Q?bzRoRF0S1Ac09CDB8kPNUzNm+MQK7KQ4z8rQLkZjoMVUEemDBXj5ZkF2amQb?=
 =?us-ascii?Q?Or70FQdHZFI/R2imXy2b8/U76Ug6LACe7z8E2bbPSMuEvLExDJ3wV66zjXGZ?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Wrd1Dhyf/p4nmfFqk0vBPLIK4AzYVyn4GD5CUnGez6zhMHzXqn9/1zLVknxwGPl4UrLL3NuDADYE1Ho7xki6VsBt6eVSGj0BMCqdKdfUpVNMMCuiYbLD5RFSk+dy/Kvmq8oiZUjPpgTbRW1F0zTn4y7tW53E9AmCRQtIn3E2f8Y7JA77QjwhK0vumLMqAghDQRnBS4dgXf3cRKIvmEffVaf0iwzduRBixM0DFOsyVTwL6TVbyJU1KuMyO8do3zY5MzgV2bSh/mZYGRQqPD8eTW3JeZ2VuFW3bQsif5Ot/rFki42PCaT+QFsF/JTi12xpLqF7/vLK0NNLfDIQSBfQs+TiwSIGPbRf/rtJrarn7s6AYz8Ueuy6b0qeJPQep9umjv6C+/G6f80Mt/gMGfASiW+iz5viXOBzaJE/h2Xu85v8duYbbvK6peIrxam/VyMNdZKyhAbdcGVVPsX4ZyancKe6khs41RDcsxKzEP3wY5TqsuTP2A6q/arXZOhKLi0iq74tmPXVUiZ8ub8yVbLrESDerWO6BmpLzLNUO74IYvNJW4Do0iphRngMRqghC0dUYjtwdkutdCe3nI9ZtubS8I6T+0qoeq9QDP9qexpiP4YXmUB1jXAkL7Cb9fNx62FQl/BhnHkAejC/Xt4wz27qXH9mX21ECrVuQEP0thkg63axhnyJqyAmE+4OcScxsdOZynj88Z0pWH/j2Rn3BEDSJhqV6SNOM8zBKAyxBpC9m/k5YCjf3pgm5b0U/FD4+tKOG9G2Fkqokur8J3LBdzuZDg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e30fa0c-dacc-4903-2e5b-08db2025d75a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:30.3209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EzwR7mVhECp1xXJe0zb1TqAJeArsxZuGLrhE8d5WL9SFenilFMPStX9lpLBOIFD1IMH+G3u+89ynlhXi8hnlIKWTeyI3zj8ShTKjV4TekCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: p8QhS2h7BYIspx_Hueu1Gd_DVQ7vGCjc
X-Proofpoint-ORIG-GUID: p8QhS2h7BYIspx_Hueu1Gd_DVQ7vGCjc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Indent variables and parameters in xfs_rename in preparation for
parent pointer modifications.  White space only, no functional
changes.  This will make reviewing new code easier on reviewers.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f12966224005..66d83bef4352 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2902,26 +2902,27 @@ xfs_rename_alloc_whiteout(
  */
 int
 xfs_rename(
-	struct mnt_idmap	*idmap,
-	struct xfs_inode	*src_dp,
-	struct xfs_name		*src_name,
-	struct xfs_inode	*src_ip,
-	struct xfs_inode	*target_dp,
-	struct xfs_name		*target_name,
-	struct xfs_inode	*target_ip,
-	unsigned int		flags)
-{
-	struct xfs_mount	*mp = src_dp->i_mount;
-	struct xfs_trans	*tp;
-	struct xfs_inode	*wip = NULL;		/* whiteout inode */
-	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	int			i;
-	int			num_inodes = __XFS_SORT_INODES;
-	bool			new_parent = (src_dp != target_dp);
-	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
-	int			spaceres;
-	bool			retried = false;
-	int			error, nospace_error = 0;
+	struct mnt_idmap		*idmap,
+	struct xfs_inode		*src_dp,
+	struct xfs_name			*src_name,
+	struct xfs_inode		*src_ip,
+	struct xfs_inode		*target_dp,
+	struct xfs_name			*target_name,
+	struct xfs_inode		*target_ip,
+	unsigned int			flags)
+{
+	struct xfs_mount		*mp = src_dp->i_mount;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*wip = NULL;	/* whiteout inode */
+	struct xfs_inode		*inodes[__XFS_SORT_INODES];
+	int				i;
+	int				num_inodes = __XFS_SORT_INODES;
+	bool				new_parent = (src_dp != target_dp);
+	bool				src_is_directory =
+						S_ISDIR(VFS_I(src_ip)->i_mode);
+	int				spaceres;
+	bool				retried = false;
+	int				error, nospace_error = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
-- 
2.25.1

