Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F53C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbiBXNFH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbiBXNFH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:05:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C6037B591
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:37 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYYIf016893;
        Thu, 24 Feb 2022 13:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=TJPvf9FHCUhS8dvgwXKANZkYRRiZxg+QPkmucJ1zvwM=;
 b=BdosnHJpRz9ID6r0UQzT61ZbGhxIXGLnRzSg9vEOWEf9RoJDRk5brrmdY13lH7PB/470
 sMQ0n4o0X2k7CuTOZzQAIhmQKs2ElzwBvoMA5+/Jq3Rl40YyU6LNMF43ZXV2nAskGbyu
 IevKAClg573F/Yk4zs30hGUNXOkcSX6sVys/M9khaZyLhRp9pzNqnxiW+Lu+XIYXAlK8
 n3LtHZWkZ1Gfb1gz8iuwayzAjB700U2vD3ZIAJGCjlrziN15VRsxT+3wVu9v6kqz101O
 XdIcPKmLBh0l0ayoXOP5mqs+anGc1OlmjvNbIMBwR6ljFDXPcQoE5FhAglAkhPYiYazU /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cq4ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0uHH169641;
        Thu, 24 Feb 2022 13:04:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3020.oracle.com with ESMTP id 3eat0qs47y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjXxUSwMX6H+UlUmPL0jhwQNNQ/+5d5FNmwMUfPMoUV2Qo+CgX94zWVLQUOpOZAHXwm/M0kuGJVAr2luHdcl1HW9OsGAazP5sngyp4AmtflVz+M5jF91TcN5HwJw1DSCh5envfLeg945qbNovsMlDrqHkTyPhMoeUb0Tlk8AdiM1f+ScnJ6aj2gOiy5dhdjx4y0RXvxe5DwirueEcLOZ4Nes90+ROqgPEUgzgJrd7CtHqWsi/uzyVYc43+qz8TtDjRAAg3JpKs2VjRuhu0BCJ2xSdjRWb2+BvRtgscLQJrmnDRSnrRtAAFYpVWp7QaJvQjFNsr1bNwIztSSZAwVcEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJPvf9FHCUhS8dvgwXKANZkYRRiZxg+QPkmucJ1zvwM=;
 b=W1u3d8t2uwc8BAH2abgAkzcCmSCd7CINLxwDVQ06Fdau6NbuofGzqznWhQAJo+O1TOZ+N5dY0ndLI2ABRx4E3AxPcV1tyFg18PBhsiJFOmy5JhmHmjLXlWTcy6EMJLYPfvXaLY07EqfbKREDGyAPLOTZgrTNAg6e3cXMf3/WvAebCR9zOQip5AvLc4UrUYtsIbTHv97qTlTziOXoAamglIhMpXJ7GtYrbteLXNG5Kz5pZ/tCnLOGix2E1xmrsyahQRehLFPPcPGTW+YeeaEZFGec9SE8K+OSemL2W4l3sgvzpzRBL15ZXCnD1Wejz3CCAnDpQMNQePDV9sA30Wupiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJPvf9FHCUhS8dvgwXKANZkYRRiZxg+QPkmucJ1zvwM=;
 b=dPr/K0H5wuFZOaIRKa8kUowetq7JAy3dk9Q9Qv3vB4ilqDeTdoxaZ7C7jbydbsucSnPynHjJAgG09TYrpykSAgHHwemCjYcGnfSHXnqJ/N3Tc3fBv+AEEGd4kGUHW0FiKE4zTBzc6lSscsuUeW6yss3mY9xaSVoN2CqHTwkv92I=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:04:20 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 10/19] xfsprogs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
Date:   Thu, 24 Feb 2022 18:33:31 +0530
Message-Id: <20220224130340.1349556-11-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 24783977-a0dc-49c5-02d4-08d9f7962bae
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4634F07B6CDDBFFF8F9EF37EF63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BA8tHNUVjZP31B16wznZiVe8CaLWZTR1QfZxDcS7RhGz6ru01n4us6SDhiQLdPSRgDT5p/XOOh07+bxSVd3Uf9ZVjdT+AX1G/GcQ186DIjqZKp3BKa+V06NOLmyru/HO1g14ZqGLizaVTXR5fOsYx6GXXIZIBeVc9wD2sqW4HiIRs8jfUr7F1rkRf/jRoOXQRD1iuU0p+zfwBSwlb1jJufw0MnVztZ3PvEJpieL4bL+juCzDFycbkRCl+bpbV3T2LSlXSsdITqR2+3e8hx6SAAjVWy8c6OsyRfGDUop/j6mRCB9sdogt1UxZDi4eJm7AcGzLSiA8zLDthAHcRP/8e9ka6G9CCByG886Zq5M+2JVvoIqm/cf2GUliwNxiQS168S2jv+PGm6LM+K3F64sjdGH8bXAYVT5e1v7tpvxtO8hKjt6BuOS5wBCCTfXTgMzllA2q85ZNTgDni0YUF8/KIW6lqNI/TEF/r2RbtCFH5FrhC/HZBPAKuPqAmFzPnWvzEAMjXR2IU1m5FkPPkTfc2TrOykQj4Z7GCmwNCO/npQ8sO/w5nizT4LQ6zFleVfX9QFuti10UwdyWeWWiyzq4LQNX7hMYDqG16u5XpldIAeNEuz5XsCrunNRimECN6+1Mr+FezAn2oLYxpvGLQfS9Io7hknuJVlHYYe17w1R74JKBz4LvH/GqlB47flwBqD3dkMoHexHRwvdKn6kAhsjbOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B9snHRD1MAlqnLWiXJMHmfds+8RRxnReeiXiskERwkLpwuH2CwM2vINnTeV3?=
 =?us-ascii?Q?aKWXXVdyyZdKcEMGESOchEaHOn6IU5vrSsFimujnbsfZSZ1NidQYpBrpx1so?=
 =?us-ascii?Q?S4S3cMao1D6jZctiIsigCdERHGTHzbmcHRat+VQ8CC9kq1zApOaRYYi2HOZl?=
 =?us-ascii?Q?/kRCDEflufcpzKZUNK51AagTEQUJuyXGSCh9oNwEeUVkYzK1qL3hRZMowoub?=
 =?us-ascii?Q?0oOWth+iwW201HERhPGQDpZ7gB8iZPZt7TnIQc6LgSD/dH/jPxw6nAQXiKBe?=
 =?us-ascii?Q?iKIhK5g6gCaqlwk/40W67m3FiwP95Ap1n8pzpNMjrqKH1ysKZ4d/8E9uORLG?=
 =?us-ascii?Q?q4X7fEiLa/ICXykVAUSNodliiUAiLi52aksrzaHSD3SJPhDhYJl2d/Sm2c2n?=
 =?us-ascii?Q?1oneMy2a8aUvAsiqg9VbLSDBFUyE1J5qRlY4d3lPIuZJ/sOVetvDLuyBK4G8?=
 =?us-ascii?Q?4S0pWvtZlq7oBnOHDMXAmsq7s3gFBW/KOHOOxPcTpYvbXCichQLN5YJ8mHZq?=
 =?us-ascii?Q?x/aDXP8RUJ3TyT635XxFBxZ8UdEtLG5BaxvC2vmFsRRfJREIgWgyEYMnLw9Y?=
 =?us-ascii?Q?mQKSO7+h2PSu8Pvud93l7jk4XcNoH0lC5frXpdK7yKjC6LtGq6u3Kv1+KNSt?=
 =?us-ascii?Q?0Pz9zR8qifuVoYwbBf8pPianzzqMf9Fbdkluj+vk54y8zw/RP6fVqg0g1KzM?=
 =?us-ascii?Q?YF/rHzvU5u3OoBaTn8ARJixqxjbdDN1aiwV9gEYiY/XNYdAdcQwxvFEPHGqx?=
 =?us-ascii?Q?dpc4YWVp15v4vm2fEH+xwNEsfkyigVMa14cDr9PJPGhIx1S9qO0g36fsoiwa?=
 =?us-ascii?Q?BzcuPP+ZLTDy8Xc7he+h5/v3czQyF1hADyeZFcMmUvy6hq6z8dCd5WavazKq?=
 =?us-ascii?Q?SlazdV64h5ht1hBKeJLx0acXMQ2NxwSKm4PqxzKS+DzYck/AHoUXihD8ndsv?=
 =?us-ascii?Q?TQOqRVDo0m1dY+1Q9hcKndyYsJJnRfesO6D3HI2WUiNbBh/LrphCw7AerisJ?=
 =?us-ascii?Q?J65swpi+JpC99vAybCXWKnXgpTrrcxWJWnfRg5B5SS+78dSvyhpF626pQkYA?=
 =?us-ascii?Q?qZ1EjVLCPOvLyUM2BUUgDZCujKTzs17Oy0c08Kn5JNYbVGe7WdUCyAzYpSLW?=
 =?us-ascii?Q?FZbcYI936cW1YwTVTIsBbiiPZRCIuzZOIG+O0MJM0P/IlfiVAXCg5nBcYWkw?=
 =?us-ascii?Q?x+3HMr8IxnyjufwcP+dTvmr5P4PNDYn4mUUpCeQNcnBWqMELSYyMvVRLaXw0?=
 =?us-ascii?Q?BLQ9h6BxPWQ+XggbaFQ+5YtAkIjYfluKqxTFiqYSBf84P9ZAYviB4YtT3FMg?=
 =?us-ascii?Q?4O5IOvCvmQXugrvSXw4f+vZPVjfdJwKXiOCZAeAcohy1JEH24nQve52s0Jza?=
 =?us-ascii?Q?jJulqMvpJQC/KtO7fvuZUfV3JpG+2gxl+c0K1IQbP06j6dkZQkFyPL5Xl9hL?=
 =?us-ascii?Q?FJtXEG4p1Hzz5jdQFm/6ppN3YrMKsv4M1Jx77YZNPs6dGzgs8BaLfK/mBNay?=
 =?us-ascii?Q?P/9WJ9wFp56vuMJNkevlhXabpQwbojlHYk2ejE2zp7mtNVlgBJewdFfw+X9R?=
 =?us-ascii?Q?3C9Bb9DHSX1eQefU1N4uQrOx0ni71wPbOmT7xY9WWxD9c/EmaJLihBKVVwOc?=
 =?us-ascii?Q?DZDXaGn9xmariCzS+FMva88=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24783977-a0dc-49c5-02d4-08d9f7962bae
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:20.2270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kmZylQlvqOpl+4aIumtvnEmXgxcJjH8LGcFCf6gylPjjves3jRImg92ravGFh+RveJgDK/rE6aTCyKn7M/bDJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: yXX4t5ew7Sd6SsSxl6u1cYqrdxxjFr8R
X-Proofpoint-GUID: yXX4t5ew7Sd6SsSxl6u1cYqrdxxjFr8R
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
an inode supports 64-bit extent counters. This flag is also enabled by default
on newly created inodes when the corresponding filesystem has large extent
counter feature bit (i.e. XFS_FEAT_NREXT64) set.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/inode.c          |  3 +++
 include/xfs_inode.h |  5 +++++
 libxfs/xfs_format.h | 10 +++++++++-
 libxfs/xfs_ialloc.c |  2 ++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/db/inode.c b/db/inode.c
index 57cc127b..a9e6cc70 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -178,6 +178,9 @@ const field_t	inode_v3_flds[] = {
 	{ "bigtime", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_BIGTIME_BIT - 1), C1,
 	  0, TYP_NONE },
+	{ "nrext64", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT - 1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 08a62d83..79a5c526 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -164,6 +164,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
+static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 typedef struct cred {
 	uid_t	cr_uid;
 	gid_t	cr_gid;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 7972cbc2..9934c320 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -992,15 +992,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
+#define XFS_DIFLAG2_NREXT64_BIT 4	/* 64-bit extent counter enabled */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1008,6 +1010,12 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
 }
 
+static inline bool xfs_dinode_has_nrext64(const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 82d6a3e8..1661ebe4 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2767,6 +2767,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_has_nrext64(mp))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-- 
2.30.2

