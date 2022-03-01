Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D59C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiCAKlK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiCAKlJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:09 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6C390CF3
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:28 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22186SJU010133;
        Tue, 1 Mar 2022 10:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=iBkB3G2ooHws3WDfByQpf1jydXHxTW0N9ij7xAGoHhc=;
 b=RVg38XXxq6jB3PCLkUoclwVMFE03d+MG+0svtlecI6KafAivDeI4LAZ4m2a7rRsOvgkr
 Gph0yyaoDglfFRXXqP6ITyI5GbIu+0/H1IgJhbe8Q0BHJLG87Y/xiE+hthX0HITRV31b
 RQ8ZHoSm6e2q0gTZ3I1yj6XWjx3mmBg/FdIXl65K+01kxyHKXcFYjcQUGh6VnUEZ3p9p
 pvuYXKQswEkeMzVpTflr4aN3NPhsXDR02nqTP0sc54SWZmF5GLvOWuYfqLpSf9t9YVoJ
 fSK9qdLeHKIqXXRj3buTKPk0aqwV5awyxSRNghe2LTsS73WUfBr9G0ckglgvzzp9YipG 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k42b40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZwPi029982;
        Tue, 1 Mar 2022 10:40:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3ef9awyrud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmON6r5MZMLX8UYWIfDXga2DeEV5FB2iokqiqUmJ4JHids4tGW3zMUc20mUxgcuFLcNWhLG/qCcXMGOU6tjq8AQpswFneSyVDGGOymUZDLud5XqaU8/R5ijr1k196X8Xrqpj2iD8jFAkE/y0+epkBtX5Wn0hswe9JiJVCW7Wd/jKBeGy15zOkfeG1RH2hD43tfoiW91NMjK0S6Hh0iI7+RXGGgDi6QvEKnfGyXM00gC8EHZJNXOOVOnFZ2H9gotE5236WHbF7ilo/BM62iCQSriSkPiGq8v6rtt5iOUI8U/Fb713/Djz1C0jK4W8/9Nug5Cx10q7WiYrV6FKkffwsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBkB3G2ooHws3WDfByQpf1jydXHxTW0N9ij7xAGoHhc=;
 b=SeDXjud/KL8s082Jd3PZ5wzAjDNc6CtHA1DXW9w6Wky7PqBkeOYW194M3IaljKryP9jBXvMMpO0qJ+S4jsZUx9qzLCEU2fACXv34FPrIv7H2eXvT4XoGqA4Z3IheAVLPsxj9j1FFouDaSgxiDPgHrSqhstA/fJYBkrnB4ShgbfqMYsCXfRzsLX5A84CneLkY71UbwaFOT3fUgUXWdEYfuEHvTxgcDRqgQ4Npr6Bnu93oXlq2LC0VyQ2v2VL5hY+rhPP4PW/rDqRDbAzPAUq5bQo/zogvvQGhVm2BpGb24/P3pZ5dkWaePnWUOqPO1eFtpchIobV2aQ9KSq0EVH9cyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBkB3G2ooHws3WDfByQpf1jydXHxTW0N9ij7xAGoHhc=;
 b=cgQdjcR3WQnBEg093iEAZyr54E+FyMoEZcA9HLxUyT0QX9/C2ce8vQe9sPCh+fXCiYXJOWgiB9ylKnSM+FAwtwfBsmFUAHse69Werir2EO9fhxHc9WpMxIdN05KIlIGG/5y5aXYbKHmgiXD5U9hq7DLfpsu6VpJhaUgfakG+XOE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:22 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 09/17] xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
Date:   Tue,  1 Mar 2022 16:09:30 +0530
Message-Id: <20220301103938.1106808-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a477f132-9082-4625-c9a8-08d9fb6fe2e2
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4160296660EDE32A8CB4F655F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8MAVq8HgrVMIB0tHpAa5hxDE23rXN4gNTsISMU+tDvexnYufy5sehnHlfsQ7JMXIj4xoH1ekS8Nq3dkb8cGPQ3H9iXpZLNPAV2ziJmndXGpO/X7dkCQh6AFkIbONcTXaaMRGUtS7CnTZkYd4Y5jbmh8qj8kKLvV4cw6PviYRZ9BoSi4l2H9oegEEtdVTljuRbbxeNcOP0AXrZoOjI2iYbp4gYHRoeaUUlpivEm2AV+qTCgWsq7J+JkwYaUFkXGN8LcacaFkeZGmDPWN5NptW7AtJvjg6linbrIAK+3GE5GIeXC+0Nz/9Tfjy8Pz+9xwbEbD0e6jsk80HyMHFsaorYkiMNMyRDYRNouxM4KbnyQWABbihKyW39MlI4svk8xFAbCErBCdj0UVtQaIJ9+V7gRWeNyPhX90hcvZZcZb68wvda1pgB0irlz6a6eC9+9Daz7vWubxqcm7aNXI20DJvM0/EkgSW/hvofZ2cYuRNEeAaTS9wO0c+LHVU1kpBzKyoXkVuy1TgFTEh5vTRBo7yCVidYI76IYN8ryMjx/CzM9X7DWDIMqrD+gBgHXhemX2hhdd2xTWNK1GUw26cyHloeDwijFfq7Xv1U/lVOEawFoGksVj6aDW5A8A30uQI6ouT0GzSaf9Nbfo2vz6gLyBPdUkI2bR/iDc62b3r2hyisEAommfJyiy+6XvREyQnoLEzHnkD3dfvpX2PRAyiFMdhVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U0ghlrVv04F5xIiY1rfK3J8MOJ0js9EzNoSl25k2PyWGUmnZE1ocnnfJaIa3?=
 =?us-ascii?Q?F5aNvr1kxEA5If7G7h5ozBu4rGMNEHt+whVOPdvDQ5YYXOP0Gh9JHtZmaVjb?=
 =?us-ascii?Q?Ghg+Y8ASJloQuKnwKGMKwyJ+LsLxiYNSVGeFlELdHBusAIpTobtDcal3QGwX?=
 =?us-ascii?Q?8JPeeaC47Z+pTkZRUQAIMSZCUvSbF1nmWPFPP75tAdj0WntVnsV0f+p2bT87?=
 =?us-ascii?Q?ZKNqlsUv+H/7xFF76t2N7RcbPgISXsrdvh6aqGPJpfBwpE3ih7g+kJhFmO9E?=
 =?us-ascii?Q?nDenEBigY9ihD2eU50AZm/MGIuuhERxJLvCxG+WlXfw/6+ucXxJR4/8K2/y+?=
 =?us-ascii?Q?UOKIzaS2z+WQf75sv7tIKBDWQ+uNQkcoNbN64sF8IUeoFPWm6DgqZatVaFyO?=
 =?us-ascii?Q?6Tat3L0gQR6XiEYo7fFgQP5W8M0dchEI6UeVBGQZSvnL6GmtzThGpsgobzqE?=
 =?us-ascii?Q?PQ9rPy3LFMDXI89Z3M5Ug1q/RlXCdIgPC99IjcA0Xcw2hBuMJEHLYDInwVvH?=
 =?us-ascii?Q?xOE+6QWs9spVxznZefBGGY0AalBwPsBWrK/w6okxzXohM+m1aJ4E53I74DqO?=
 =?us-ascii?Q?UbbBl4NEYVkhCFY9M5tKifEDuZ5pl5gkM6VHQuftlT54rbdTuvTBmL5vlDXM?=
 =?us-ascii?Q?2aZG1elraM1vf+dx0Xadgr9sCgtkTn9TixygAxQz/dVHWDJ67x/H+vka0eS9?=
 =?us-ascii?Q?8TfLZeTf3lRsX+D9qbhyCqomuubVwLFZxvRDZwuQy3b0BVJKbusSG/aW84t0?=
 =?us-ascii?Q?CflVQQKNhxQTwuMoNYcCr+j5zQc3EjyIO4WXZWl3WPoQVQeBoaBcqibqTJ8Q?=
 =?us-ascii?Q?9pV9DAHD35eYfn0K2VgcraVg9CdA0w61HZK5tF2b3nN6N5hnhXdfpeqcjpn9?=
 =?us-ascii?Q?4AB9oXb1P98JBTVZe+uYpoI+7raaj0Y+g1lvh2q7DuF3UXovyy/DefewkcNX?=
 =?us-ascii?Q?k2qTZ1G2kkRLU/SotCBflvU2yxZQlpf5HCeR861Po88Woal5cJSMAoAyG5PI?=
 =?us-ascii?Q?ERKWeO7rnDT+U+RCuZy4oZ3zZmSE32cFPnqTZzr32HelnL3n+sLPIF/nclvl?=
 =?us-ascii?Q?+FpJOwJKINcMdKE3O7rJwNAx/Nr1oPfN/FrdKDnJDcV4QRW0Hnh5aGaoBGG2?=
 =?us-ascii?Q?Lfx8YCtNUhYb+3QONuyG6lIxo8aRP0ILsAss71IL10ize4B5/8rhDXPiPllN?=
 =?us-ascii?Q?Ft/hOpf5V0eR7puy3tRtBOI19wZxHjc2uWQyP2zRCl0aOwO4EBgD2pDqyagL?=
 =?us-ascii?Q?E4WSAyvnGLx+BdzvV+8glv0P5MA6v1i5+V3xBdh8DbzKOQHVzrxEh/i5dtYs?=
 =?us-ascii?Q?CGvWN/NHOdCOMLDnN9xpuX396YxvGDbqZ8QfCDLl5hbmt2bURjEfj2M/6ClG?=
 =?us-ascii?Q?m1ffVhBDI7XvA0R/rulRh8Vc96+JhefkUQzIvbxzAU12UNzahn9DTzoaqnA5?=
 =?us-ascii?Q?rQFcZkXItslzB3iVVJFBNFFWOD6761dB/zJ1IdiuGHiBr/G4I9zusBdJnMuv?=
 =?us-ascii?Q?P2O6TO0eBhMmAw+cMv4DaG5E2CSp8TTsTfMoXhwvaN3Q7Ub8XXSKuuFbV6KB?=
 =?us-ascii?Q?DX0GsQ819w7NA+V+R/JRwTbSqeaWy9vELCyFOsOat3+x88mbQzKDtBJBwSn9?=
 =?us-ascii?Q?I5iCL1vz7oobzrSCkf5Yafk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a477f132-9082-4625-c9a8-08d9fb6fe2e2
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:22.0633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ck+Exw8q3a4rCOU5Q8ZIOfHuM4x5P8I52aphSdpIzGzJCEoWtcoqI/hY3k8rdpI/uklc1OQUTUHsb9hvy019ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: nvZ-5CBTn7b0JzbBtRvhGsx0V9j3lwaI
X-Proofpoint-GUID: nvZ-5CBTn7b0JzbBtRvhGsx0V9j3lwaI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
an inode supports 64-bit extent counters. This flag is also enabled by default
on newly created inodes when the corresponding filesystem has large extent
counter feature bit (i.e. XFS_FEAT_NREXT64) set.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h      | 10 +++++++++-
 fs/xfs/libxfs/xfs_ialloc.c      |  2 ++
 fs/xfs/xfs_inode.h              |  5 +++++
 fs/xfs/xfs_inode_item_recover.c |  6 ++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7972cbc22608..9934c320bf01 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b418fe0c0679..1d2ba51483ec 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2772,6 +2772,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_has_nrext64(mp))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b7e8f14d9fca..ee54a775a340 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -218,6 +218,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
+static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 239dd2e3384e..767a551816a0 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -142,6 +142,12 @@ xfs_log_dinode_to_disk_ts(
 	return ts;
 }
 
+static inline bool xfs_log_dinode_has_nrext64(const struct xfs_log_dinode *ld)
+{
+	return ld->di_version >= 3 &&
+	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
-- 
2.30.2

