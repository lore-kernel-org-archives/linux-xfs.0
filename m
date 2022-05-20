Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6286CC4321E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353189AbiETTBH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353142AbiETTAx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D324D1
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIoCuN004434
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=h4Ibu70qyZQeOyA3M64Nm8bNnH4zHPAmwCpK3K3bjfA=;
 b=YsXtXNFj4/28xw72zZaNLbzGj0oZn2T5ConAbLf5gm8T1iPF4j3xMsapkicA9k/L2qN8
 QfmI1tfvav/e2bS0NhhzDzBv4b37pT9rWwC8P0POTCeki+ZvtIygfCIlKXnAzDV0sVy+
 336WePE1ibfRY+ZMpTanSzJxYeVkhOb5H7gf3dvzo1M+oc0pYRVJJHWgtKB6T+FjFTXs
 08w3G71P+ETfBStZ32eQwfbVqO1zPBY60x9Qz2S/twQ2Eur2InFq/0+dh0zh15gRDKzZ
 CIJogqIHXbvKerh5N2Q21AW+AwGh5NMDdejFQvwAwDB5Z3xjSZ/+yO2D4u5aTD/QWn6r aA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucfe43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIoAPC034622
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:50 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6mhj7-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGbqZFGr7oEK+L7rqthRZsmpncwYqB5LGxKoj9tsSRPP/bvUzFEUnQpPOpq1xANj3lzTQFc3mxv4QSitOL3CdbCKnPqz1L+JOyOaUYxkbPuyOvw4Uj0LhaMZT9++Nb/Z7uM6Lq3tj1eJvjYfjTk3zdndZsM36a8ucIKDvLA1tmgwj8WeuBIiM3wH8k9ztgMYIrwFTbzxZNykJ27+TJIwWoo8J/8A/qnXmComD/UYOx1u2Anq5uSQw6BCUOBup/pVbRx/hcBAeMeTyrf3B0BqMa5rC0G9WG9p5nM0UksGrSXEyR6lCkSvq9ruDWxnFdpbldEhgrPOMfVxhAYD1dPCQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4Ibu70qyZQeOyA3M64Nm8bNnH4zHPAmwCpK3K3bjfA=;
 b=j2kGGGUrMGFWaUjUgXb7azndISSwekYWXkcuDLTn2EwuCrHoe2TX+cz8v3Tx6rk3zCpmOTmI8oX7LUs8ZgPS2Z8yobuyTCgFSWqUHxFm6GDZzlMI+bXdTbzq6iQ6rVgw8M8W11E7xzKyv3VO49MGdY9tlKkZNdR5rTVbLLmDKe5yaTGlpLfl8NfIOCnhQVFlIfQll921fAmxN7tGEsHo3mKnK26Q4pe/wXEc75KNeE0nqBapWCEAmvCXS/Pz7jfPpAvmAg4DXrAL9TG8pHg4ZFeeii/HxSQbFKW/sLKfZ7sLjg71u/3GfMdLiiEQ/UTA1v5zb3OsI6ryycejV+7C/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4Ibu70qyZQeOyA3M64Nm8bNnH4zHPAmwCpK3K3bjfA=;
 b=vHGi1dmkgAyP49oPXc8QXHLVZEzGZ1j3Q9J9U6/0xwwvxNmSdCLjCa61IwgdV8aFXovKSYa8CaW7KWc+02hX5Gdt/COKnqaCnEjVlTBO91Wbnz46d7mbzYk2g2Nh20WP7Nhm+tEWifsOAWWOuoprEiyDDjnPCNrXuZhQeFVoDL0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:48 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 17/18] xfsprogs: add leaf to node error tag
Date:   Fri, 20 May 2022 12:00:30 -0700
Message-Id: <20220520190031.2198236-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50238036-f962-41e1-c6a5-08da3a9309d7
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3658112D3EAB5EF19662104A95D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 28YOew08F8L5qeVMcY1xpIDUdbj2U8MUCutJBLTLAyiTZDm9kboFfs65GkoRyXbL4UEVlL8muFia+8SxVtZ+NSZRrwmalMRoNOQMVVYaQzy9jjV2FlloyfAgs4T966NyMp+fVeOk+om97+BG7YDkth6U0Rbf009ASEB7NClgcqiJzThgSrhag/aA1VuNBBCSdM/9lrS+QYjO9b8O4+znfPEfLtusxgy9V/3avPo05g3GrwjBxZ9mf5BHKDQluTLiA1qlTXdo60h7puiqIL1hQ7kaTIxHjDJYrdTEfUu0DjsVMricSURsnrMAg6OS1gNcqYodens9qPhXPr1LUz0j9UTXdbCprpZElOU3XXkcD6uINZcveV4565ao7qDRgHrdRzvzSh4lkbmLYkRiAeDivlywLpPGJ2Caf8BMlJZhWr9VF/7pGD255unFsoIeNFaiACDeIKeUUMFRXCO/hhobTbHorY4v2lQi9Hh1si5oq0+nD+QDtCZJSZUZhoWig6dbGVtIAtjZDNv08Ap9XdiyRjLNUVsNmRCcycejE4bWTgwoF/REpfBUEDCfQpEZxpeMqlC45cY2y5Mc+XBvxpH5IXGIM/5nN2S0xcUywYsogeXlqrzzwWidprkfpxzbpUEajY6tLadt6tGYZrYibZHl74HpYZCwwVkHOVqGW6hYNb3o9OExaI6SbkgHjtFbeodoYfIUM9OCilkmEpC2WZDs2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Huxc73VrGxzyYsEUTDQ9UM7T3feb7VETJ1CAjoRID5l5oGSqttjU1BtE8xXr?=
 =?us-ascii?Q?8scH/q82Lugqb+oA/S3fqcU0R+VeuBYyqbR6mAUndFxgzORgtEoeipyG/SjM?=
 =?us-ascii?Q?4TZ8bUAW56syHjpxzo9AwAa0df2HedkHPHkiGx20qWpr/k+muz0k+j7L9zvA?=
 =?us-ascii?Q?v55RS17Fk1tPeir1y6QtEcfbl3w5IhpVbTLhTfRLoLW7aefQ8AT8ex95Dr49?=
 =?us-ascii?Q?0BKgCWD/l8zA/Zr9DtT2TSo0AjyuJYyWJ1Hv4pN6dJUS7jsG4cmWJtoBrENL?=
 =?us-ascii?Q?Cq/7rQU688rud8IPMWbjxofV+HMPzfBwa9KA9PST+A+2DHs0h0QcJoS0hicH?=
 =?us-ascii?Q?0h6tTOEdErxMYM2lsAbtvGqo6cEwUaOYffwG3rSuBjEVy6UbiH8xnZQU5TSw?=
 =?us-ascii?Q?B/PY0+DTUhcqA9ryAxAd+5Mib78jNLqWWh3ovoa/R5zZwWzxZ6P8cE2OxJ5Z?=
 =?us-ascii?Q?NVZ/UO/N1Wep4KOlbtOYwms6Cw3vh2XNvF4ZSPGRV+wR49kqeBqgGGKpls7E?=
 =?us-ascii?Q?MVpGO6ooIkjQsAIWu8ALJr5codjtCd3GEc2iOj4VOXMc4wwMyku76eUunRm2?=
 =?us-ascii?Q?z2SZiD73m5FmZT5Sutmy/EjeXV8X9XmEqwSJkHwlLsCex601DG1ZfUaQldvd?=
 =?us-ascii?Q?knfh1bPeq4b18h4HzQ/H06qmeBtjbprMBUzGOz5+/nWi0BlVj9F6T+dvpbbH?=
 =?us-ascii?Q?dcKZnyQRxhWCwEmmrKVCRapIFn6unL2UTcljARVi1m4o4wQBuRJ/KMESuTA+?=
 =?us-ascii?Q?pi6Q5H2Uqgmc/z2yZqgyxxvAxOMVUgEVpmSR48bOMJOdtgaKjCcY2NIUU0H1?=
 =?us-ascii?Q?9bts9mjSUc4jwFVrTFA4x7Hwp8oQxvCEZLXxyhSpZ7+afunTZYTPLJnQMBOI?=
 =?us-ascii?Q?7CiCV+htPNbyip8RqMKxkXSwxze97fhz3TBkvw4w9Uzver/DzaJ76ExVXwRY?=
 =?us-ascii?Q?ijbwqbBz5iJEt1bZd1lHvzvR2Rqu6uN89K2pdq3QcWae5Fmi/4zou+IvpyaG?=
 =?us-ascii?Q?2sn4IgrpudGHGrVahLwZYxv/0c9ufzSo7bpxHd0kBIIg+4jkUTGsJgzTYVwe?=
 =?us-ascii?Q?lpC26nuYirHS6/xrwUA1RTyDpMS3BJRfNta/VA3Aq4cgzYvq4THrGDzBfIMF?=
 =?us-ascii?Q?aQ2iUTyxjS1hCNhLqY7Rmv5USWMPqQBM9P1BaoLfnELTrqMhbVffyuUv+uj6?=
 =?us-ascii?Q?h5EeUj237/L2SI4f4e2cV7kAuLlUGOgw4KBfQmhhjBAknjd0uqDDOVPKjoxV?=
 =?us-ascii?Q?XvFqtMuG609LrcIjaPWhx2HX9tJqdoQpsEfHi13km4m83fjPwO+vW+7ZWc0O?=
 =?us-ascii?Q?DnT2WPHTuSfd7hJNxpday3+7v0AJ6R6bYjQAU4P2PpITF/urocgbDz3bDMQi?=
 =?us-ascii?Q?pBxSsqAIBkxgxqhRyi8FhS0A4ojovYxnUP8qhExedhu0ab7BOS9qCD79O086?=
 =?us-ascii?Q?w3Hjs8tjtpxdl815CDxKRk5JiqSmIpISgExSVP96wqyUj8GuhiGtEW5tawFT?=
 =?us-ascii?Q?ebv3SqeZJrBTrqTi3XRI7X+7uSmwr7wSmQRHA8MJ+zcCs0pFAGqygYXzUosz?=
 =?us-ascii?Q?6HYrosUneh8Jrkxm3RmnlLn/jVekDDwdrvPrOuOXmOJ328NFRKLivW9oc/sQ?=
 =?us-ascii?Q?+5XkQ5FtvW5KkVSuOIoPwnv739yurHS+3CT0RRAI2IRTUHzFUZrg9ymwYAv/?=
 =?us-ascii?Q?SiKhhgpaXzMVnQMU9fIUs+kCmvkhAdZcKr10eQu39fC7cMPL/Yzpt7gonPC+?=
 =?us-ascii?Q?EF3B+ojtEgpXIyZJzQ6LjdIsNzrZoEc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50238036-f962-41e1-c6a5-08da3a9309d7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:42.7023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5F+mgXAvKUsEG97gyu44Wz8ANd/R08sHLZuLPufUITfA99uhQffuY9zMy7n01x6ynWgaHLzibtWxhn2bQPy1a0yau8PVu0LKS3Zix0ipLx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-GUID: jb8Q3Teqv_0WZD73ijAGIbk7H_5qFsIa
X-Proofpoint-ORIG-GUID: jb8Q3Teqv_0WZD73ijAGIbk7H_5qFsIa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: c5218a7cd97349c53bc64e447778a07e49364d40

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c            | 1 +
 libxfs/xfs_attr_leaf.c | 5 +++++
 libxfs/xfs_errortag.h  | 4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index a7ad4df44503..4f7c6fff4cd6 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -60,6 +60,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
 		{ XFS_ERRTAG_LARP,			"larp" },
 		{ XFS_ERRTAG_DA_LEAF_SPLIT,		"da_leaf_split" },
+		{ XFS_ERRTAG_ATTR_LEAF_TO_NODE,		"attr_leaf_to_node" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 45d1b0634db4..6bd324844f32 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1186,6 +1186,11 @@ xfs_attr3_leaf_to_node(
 
 	trace_xfs_attr_leaf_to_node(args);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_ATTR_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 6d06a502bbdf..5362908164b0 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -61,7 +61,8 @@
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
 #define XFS_ERRTAG_DA_LEAF_SPLIT			40
-#define XFS_ERRTAG_MAX					41
+#define XFS_ERRTAG_ATTR_LEAF_TO_NODE			41
+#define XFS_ERRTAG_MAX					42
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -107,5 +108,6 @@
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
 #define XFS_RANDOM_DA_LEAF_SPLIT			1
+#define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

