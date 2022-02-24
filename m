Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E3B4C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiBXNFQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiBXNFQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:05:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1778230E67
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:46 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYKB1000960;
        Thu, 24 Feb 2022 13:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=USK7kctBPSWO1cMW834q2kAJyUwc0W9IctdF+uquaGY=;
 b=Kqku5lZTkT5ZlIKQjRvbdPhkWeipW+VMcCw0xBDo113GECU6/N+lTEF8m1gCzERwMZk0
 0c5plkPUVdE3D59HxQHl8HqRBhwJdIQehtFWI1TXz7GnXhMX3w50vC1uKplO2XqVZQ2V
 XP4aQAQsuT+wbHZaBy8qrYKMKjdyopXI5vF+MYbSonxF6AjcW1pNuaeGIhFzVG+Cy5SG
 87AzLb+oaG2tI0p707uXvIGISp1VvEhB3J3P/Fl0reTCnw/ToAm4A6SncCkqEcOOfvwh
 WzBZHwHUpReoqDwbFTe9txPROfQfy/BhJltxkRJ9GIqHlGUAPH1/HXGh0scO0QlltEVm JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7aqacu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0wGM002419;
        Thu, 24 Feb 2022 13:04:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 3eapkk44e2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7bJi4Lj1IjCsV5bDFGIB5dudtB9LKimm6Gb7nTCldHQjmbPAR4agHGLiyvYyTC++eOsefQdFyr1yH3SRVOzDW/uEXme0p7742tTppVR/iKriSUhynQpQ6k2+rbMsjTKsUJxjiFNXJlAfLSKi9owN9nGKNhPiLUY7U5pZYZ1Jtjgi5UBH6zpk6vRCgMtDab/f+tgINKQo8buOHOaovztbb06iF3RV/H9r+IgUf4iD/32K10gAgjoe5rLVpuBh8Imiz4NuwM9igtvFi3eEmlQHVLbMFugNw0Itt7KWAg8oSFWowXzH6O4k/UGyrK4xGKJmG9NXAsDG86XNsynUAyNGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=USK7kctBPSWO1cMW834q2kAJyUwc0W9IctdF+uquaGY=;
 b=N5eD7gWP6WPOdwCneIDeP9xMHRb9Hnw2smHp2MIZDkPYhjf+wMUDV84QiZrb4/ro7cXM8OSrh0MOpnnQavfRz7SG1PXYuAq0cVw778Yii4IpRvVy/xMaJHNFs8WMz3DNQtxB0MhWtcyIfLxw9Cp4Fjiaafbbdyb7+ECh+lHuFl9rphlr7XvjZ3U2VTMCeFAuI59XWv/87dRHOR+U+HcOYBGNamKnl+TZpjKALzHHBJ7ROvUNVYUUtEzqEgUbB0lShCVukdgQFg8xUFZm1wVMuRdsRT/4jVMx5chbFgXyB5E1fL8tF7Amt8MfwTNmNv+IC5Nu4fs6Y1a/uMBclIK3VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USK7kctBPSWO1cMW834q2kAJyUwc0W9IctdF+uquaGY=;
 b=i1l/EqAeOT4NBf13tiAV1aR/1TkAaWkG/QD+h+cUlu12TECen4epY3pkAyOCRw7U1dpaHnf0PXtED0CdDMo00jozqunuNqvhiMLtvu+b0KzOoYx7rDUdo1iKTvGG/IahrTO8AGiakYo2MA+DHSjqygxvTBP2iZ/LzbEfqqn8NY0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5405.namprd10.prod.outlook.com (2603:10b6:a03:3bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:04:41 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 18/19] xfsprogs: Add support for upgrading to NREXT64 feature
Date:   Thu, 24 Feb 2022 18:33:39 +0530
Message-Id: <20220224130340.1349556-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdc3ced2-8401-424d-2df7-08d9f7963822
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5405:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB54054C9543EB6B5A50DA5236F63D9@SJ0PR10MB5405.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xCybrr+C9Dbygd9sCAZVbm5UBpaGvxxczxp29kkyPaXNle5N+4OfsaKGrLAISQsmEGlEchx5YJLRGRD3RXTr6bUsgjx/LC4aMJFd7ih1KivYNl2wbxlMhAoqTaazC9XmodYa+Ft6o4R/mB63mGclYOwXYmnA8sjJ6VLsqzxDzcgu/7JesK4X+G950oF06wpcOU0sz82903YzN2LeJniH0qRwyjhmyfUeUUb9qfmZyl5vIIH58EGoruHTycdMrC90NXHhvKNS8kmHnAdsUQ04lla3Quwqmp+q8HdKhZ7NFAgVX86iGfHvi2hFiOMDsz4v0yoPCDYMJ2UxME5+Z3w9o22TvaVdVlrI2D3mb6w+7qYXGSUZef6SO1+ZXNh7SZ+BDDb1l4h5pzrXUnbi+cpIpIRv32FrkcLie/KvO/grvxVHN3do/YDX/yKFJa7gP/92DG58jk/+Vxf9oshkPkOGM+g6h7ygx0cXDzZJCbZAV50koL2p9BTd4GDuvrSf+Pc7SNUmxlD0/lKSg4K20wspFF5eLCN4iYqb9HajaDnrjdjoh3KUmjmQwF7/GXResXRkaEV2ugS1nWOUbHZ39JjjW6fqibvFHIy2dKlwrnTHNpXVmx/eU4tXPEX0vdh1rPdd1ahuO3Zv2YUnhfvVD9ZkXwKtNUC+we4fRDbQfPsyyNHgOk2dZSeFsr7ym3FVYAVtBijORNsUOTprY67sFkHDAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(36756003)(6916009)(38350700002)(2906002)(86362001)(508600001)(6486002)(316002)(52116002)(186003)(26005)(4326008)(66946007)(6506007)(8676002)(66556008)(66476007)(6512007)(5660300002)(8936002)(1076003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QyiqPUSIIdI7Y+bKxpkGMb+NOeMSzlqlHzrNCeeS9MptcFdFZ8tO+uWRv5b5?=
 =?us-ascii?Q?toJsRRIzjrCdSejyykfPpFpIVLuazgLCAqxz2p0TMu+92O+ghY6ymr3aM/Xw?=
 =?us-ascii?Q?9l/g1/pGAHZTuqLfl3wPKak51nnAhluMGGpm9v22k/qsYysrAquVTchskzwH?=
 =?us-ascii?Q?AFYS2uqhrBCOzT3TNk8oDPv4/ryo/pU0BfcpVRx5ZE63FTptkqb5l/IvyW13?=
 =?us-ascii?Q?0U3+peYP4rdyKh8S/RZENFXxMe4yFfxUHXvz8E2TYdifISOldnT3aMCVlfjz?=
 =?us-ascii?Q?ZQ3Sz+wOuPoqlOkfAbSDdnfLvrrlV/IVrpQFj5glz1vqkE+JsH/6tTvEooYU?=
 =?us-ascii?Q?2mO2HTx+PAyKk5WVI83E5gq4gxfRRpzMsAiHh99ws0CO7kVca52P/brxmfFT?=
 =?us-ascii?Q?dD5wIP6LKvlisN4kV7pW9I1M1czQArtuN/CwqG2iXdPtQEQyx04hqy8RsiNw?=
 =?us-ascii?Q?2uAY6Rrs3Cmhck4M/l6dKrCPO03mTeP3Db0RczRWrGh1d10l0o77AGPMwCQF?=
 =?us-ascii?Q?lrusYaowBvBRhFehziWU9FuyGKm3g1JzPI95/VbIaS+xdZDQ6pmPUXBZIe5i?=
 =?us-ascii?Q?J8M9PPR5qSL2SlylforK/7HqEnEND0pVsSTe7fXf7/YYPi+BjUvaFSikrLdl?=
 =?us-ascii?Q?D/Eu5k/ziFcrA/i2BO5sdzVV2ZmqpAvT9gL2kk/yF3MLwQnOpS7Bxo8pGULK?=
 =?us-ascii?Q?rDIbfVTSXykN8Sy8gurhBwGmUKt69kuOVWoHiXSTuOTc0m246WVu9Xs3mGXv?=
 =?us-ascii?Q?gCp9ZcNqAR814zeEgYhb/cQF8NHkkFsbZ6LLq/3Hm2Tf/1HIXeKmD8Jb7fxQ?=
 =?us-ascii?Q?pjMi2WNmx6PJojWf6GjZ3HvdNim/DE/JYfinXJPP7Q4R2r86Yh8G8/OVSD73?=
 =?us-ascii?Q?g58uQUDr/m4nC8lKzZ1N4j3pEMPOuxy1nsxyHzauXAIsvl9N6ZZHiDv4mZpr?=
 =?us-ascii?Q?kDEBwirMj+5Ohg/QBdoxRNj7MyRdslDnYIoPMmMycONZihCQNwkDqdfM/VTp?=
 =?us-ascii?Q?twjzKwlmCTgr9E7+ZpgE8eT5rNjFuxaPajmy4pSqLtmmCx9NhoB7ewZqubZA?=
 =?us-ascii?Q?SYLgZhD3MeS9sSkPBpnYfSfkf89OfQSFfDvKTT67mMwSdcNHxBXYjr/L/4og?=
 =?us-ascii?Q?8wUfbyHv4MK9U5MPPkaDfM4+MLr4ebVxServTnUIoronQf09eQiuPzBXVe39?=
 =?us-ascii?Q?P0ySlA5PFk7tvFGS7LY/32JwmqCGRvxQxXxILgfVppu4GSGWjAcaczpyP1sU?=
 =?us-ascii?Q?u3zkX2IslboPkbawYcO+MzLhvcxCumJbd+ULuxgbHf4OcQsk4VkrjkeOmW70?=
 =?us-ascii?Q?Az7QpQlYDpKktMwqm1wU1GKlE6VXYn6ZuYGuH+tMNrUYJrt2sjHiqH50Oqdm?=
 =?us-ascii?Q?JkmkaHRnuCxR68IdIpQZw+DBWZALw7y2cfPGjXLRuIdkb4+gXN/jjFrILFX7?=
 =?us-ascii?Q?L3VESxCE71bDYjtx/6EXvG33gKOX5AXWAlNi5JDsDcgO/qITSwl4UYbBMBN4?=
 =?us-ascii?Q?pELa/prtc2t2sm+VAZvUAlM5jioABOp3bGVwC/z0PcV1vOkaF2IwWIF1M9aD?=
 =?us-ascii?Q?9Ptu8YE7q2Umz08UpZwzHUyAKJbgKI6GZMLve/zvRZkBWg/QMnX2FBORs67j?=
 =?us-ascii?Q?gLj2nbwyuyjuzwexx/AhkqA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc3ced2-8401-424d-2df7-08d9f7963822
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:41.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJYdY0Z5dRf1TdfqTwy2Bgqs5/b+JGugtFEl39XaHQCWOEvRWLI2Xeuu/yewS1BmdcEIO3lEj/AdV0R0Uiicrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5405
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: JeflEo5LCl7690TFEd7U2OgiLMhkfxhH
X-Proofpoint-ORIG-GUID: JeflEo5LCl7690TFEd7U2OgiLMhkfxhH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to xfs_repair to allow upgrading an existing
filesystem to support per-inode large extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/xfs_admin.8 |  7 +++++++
 repair/globals.c     |  1 +
 repair/globals.h     |  1 +
 repair/phase2.c      | 24 ++++++++++++++++++++++++
 repair/xfs_repair.c  | 11 +++++++++++
 5 files changed, 44 insertions(+)

diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index ad28e0f6..481a042e 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -149,6 +149,13 @@ Upgrade a filesystem to support larger timestamps up to the year 2486.
 The filesystem cannot be downgraded after this feature is enabled.
 Once enabled, the filesystem will not be mountable by older kernels.
 This feature was added to Linux 5.10.
+.TP 0.4i
+.B nrext64
+Upgrade a filesystem to support large per-inode extent counters. The maximum
+data fork extent count will be 2^48 while the maximum attribute fork extent
+count will be 2^32. The filesystem cannot be downgraded after this feature is
+enabled. Once enabled, the filesystem will not be mountable by older kernels.
+This feature was added to Linux 5.18.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index f8d4f1e4..c4084985 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -51,6 +51,7 @@ int	lazy_count;		/* What to set if to if converting */
 bool	features_changed;	/* did we change superblock feature bits? */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
+bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 0f98bd2b..b65e4a2d 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -92,6 +92,7 @@ extern int	lazy_count;		/* What to set if to if converting */
 extern bool	features_changed;	/* did we change superblock feature bits? */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
+extern bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 4c315055..979e281d 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -181,6 +181,28 @@ set_bigtime(
 	return true;
 }
 
+static bool
+set_nrext64(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Nrext64 only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_nrext64(mp)) {
+		printf(_("Filesystem already supports nrext64.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding nrext64 to filesystem.\n"));
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -380,6 +402,8 @@ upgrade_filesystem(
 		dirty |= set_inobtcount(mp, &new_sb);
 	if (add_bigtime)
 		dirty |= set_bigtime(mp, &new_sb);
+	if (add_nrext64)
+		dirty |= set_nrext64(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index de8617ba..c4705cf2 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -67,6 +67,7 @@ enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
 	CONVERT_INOBTCOUNT,
 	CONVERT_BIGTIME,
+	CONVERT_NREXT64,
 	C_MAX_OPTS,
 };
 
@@ -74,6 +75,7 @@ static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
 	[CONVERT_BIGTIME]	= "bigtime",
+	[CONVERT_NREXT64]	= "nrext64",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -324,6 +326,15 @@ process_args(int argc, char **argv)
 		_("-c bigtime only supports upgrades\n"));
 					add_bigtime = true;
 					break;
+				case CONVERT_NREXT64:
+					if (!val)
+						do_abort(
+		_("-c nrext64 requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c nrext64 only supports upgrades\n"));
+					add_nrext64 = true;
+					break;
 				default:
 					unknown('c', val);
 					break;
-- 
2.30.2

