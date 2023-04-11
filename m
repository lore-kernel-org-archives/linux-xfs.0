Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34606C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjDKDgU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjDKDgS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:36:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E7A172C
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:36:17 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJcCrh030581;
        Tue, 11 Apr 2023 03:36:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PKYW+PPQiWfNpO60834+JpIHyqyImqmCoRMRZVwuTq8=;
 b=J+axr97Sow83gDgpUOvN8zZkdbiWnOBpnViHmhrZSGouLAwux2a84jnx1lmRm0kMigOs
 8XUOl4Npwi6FJYYagCXROfYD80/AvDoTN8io8cOwJUTEydqYzepldesogHC3aNnr/sfp
 XIr6UDBxGQu3Bf0npdBoKCUQ5cIrQDMpta96bQLLGogB6N5+CbALxtllUx3o3J0WmbGi
 fy8nEYEA4L72mrLlGwShb7o3cSKfgEaAQLaJISZs6D/0IoKA6Tx94G1UQI1iAJ0lvp5G
 yZUBD8VPQIT3HXwc6UF6U/KiR/Mc2fvvXZDJwIJfoxFN3fJmXAlI0c5ocLGO1y1N2FxI Pw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bvvam5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33B3Hrox001866;
        Tue, 11 Apr 2023 03:36:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe699y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 03:36:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWctoUnV5U6fgg9l29baUuhQWWk9UvRiqyd5r7lBuiShlPVyBBtOIHr9F0t6SHERGs/B5GfWn5p8E3+vbBvVA5ELElU5eSWPW9UJWobeRTcxYbKOumoyPnTeT8omjWDbmNA2mVFfjOTKLQmYG6gTIe44sbMFu6rsgUH2IweGTSj8WDhJ3fmURGnldGbLvF4ZxwzuXH9ogYH1LMoK2hYj3COy+hkhm0tK/UqGx7hCS91tu/nGEOOZHKXAqxOTCTtfxEuCiq5JwLM3LGStJ2SIJItUxT7PLmo3lVl4LlzELURdacZH9vYiddbqoVT601Nz9QS/jCbJEQAMwYLJnHEquA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKYW+PPQiWfNpO60834+JpIHyqyImqmCoRMRZVwuTq8=;
 b=IiuAs/lBYwObCS+w/p8qB7R2X4t8wGK4PHFsd+31r/2PnBk16kf2LS3LGBaaJfABwBM0Fg7WsRdNasmiCqLpEQMVrHFXeKnNoYPeTvUjcPMsGadH3bKCexRzi86qE7kkJx24Lc+352NjEOhQkZR+njzwmiOKPMzFUInaIp/7BF1RUqByBqnb6iSWOzNSheJWqY35yKTS8i33JgxJKbYcxiVs9c22vOSNI0Gs5pok4xWvNSsfY8wpUqlXeYxL58jCF7eT8sm+ubKCKyxQnV69jdh2Y3a4MfyA/kV389sgtcx8O/I7OEt6c4EhrL3e1g/prQoVcH7Xu5M7rE10B9tNOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKYW+PPQiWfNpO60834+JpIHyqyImqmCoRMRZVwuTq8=;
 b=DHHnh106jAc49B5FyhBXyaw4XY93fCa7jisXRshXITmJTSTaDmWclRiVgJ1WO9a/aKbjgxNXTSU/g+V5rRdbAsxKOQLF0bIWTYmzTDC86agxA4nhLKQ0BV2QGO3eFxT8AO/TMo8WVY96NeAWGzIJ+y87IFgYw0QJAyTXx8ANXzw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BY5PR10MB4338.namprd10.prod.outlook.com (2603:10b6:a03:207::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 03:36:10 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 03:36:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 06/17] xfs: add a new xfs_sb_version_has_v3inode helper
Date:   Tue, 11 Apr 2023 09:05:03 +0530
Message-Id: <20230411033514.58024-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411033514.58024-1-chandan.babu@oracle.com>
References: <20230411033514.58024-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BY5PR10MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: 54133c81-1f7d-48d9-c445-08db3a3de47b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GuxYxlG/27ZLvyjIOcOKm9RXiouWGrADrZOWiAQK0VVN22dkNoUqvQm8cUpNTwpTzkhcbdahnTbJ3+G6vvGoyTZsmERuji/Qq1EBnC6ZhqoNzjI9kPR3qi1ZvOxfSpzElnWE564+dhwDmmGqdPKrV/c8btqtqq2/tj7auVFw1OJYgVD8rb0bpNG1luHwpzHAxUFSlXmxDmGcxYz26jWgXL/kff4fA9YBmaPi7tnWdbpZZiIT4T+BTiDfCrhEitVc3NkmybLLN2mmUQTyJ73ZYP1dGUwVUxvBDrZULw7OpCLoW5uw9kcedEnzqDeE8FFV7/0bKeZIQJYCSEW2pMjhER8k8/CQyH+Pmm+kY77Q1bg7QDWIoFFuzyS3Cdz5k5S8BqK6Qrlhp4zMfqqoHZWaT1psbq0hDqnkJ+S0Y/5JzoN+7JgeTaIEa1N7FIeHAnsUh2sTCYHQLog+v0zEFFq3UTXWKKiZ+UMB0LLshhvTTOr1JsrGgEEO00v/6V6St3aIE9u6yMEUc37cHFPZdc0yl1dtj545RaZjTZlGpdzfHajtgLQTpuzrQSE17a1N8H0/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(478600001)(1076003)(6512007)(316002)(26005)(6506007)(186003)(6666004)(6486002)(2906002)(5660300002)(4326008)(66946007)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(38100700002)(86362001)(83380400001)(36756003)(2616005)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5w1az+PWMyngWA+4Xy/EanKbxXy0Tg0ZQ3DMd/9Wn4Hs0lgQUBuTGu8fjzV8?=
 =?us-ascii?Q?HFCzN4N3ogx1IUUcsn07ItI/Xj/5CB5cabGr2j2ba+ir95Q5jLvnOuBbd9mB?=
 =?us-ascii?Q?IWZj10WAABnRUc3dtxvSpivOOUP+t68+OQe6DZ73R7sa6CCd2fRxMb0NG+6v?=
 =?us-ascii?Q?OHXEdp++SOdkVdrMviXwkOu0y4AXvdZZjCuxDRI0viisomEK5puct5g2Tad7?=
 =?us-ascii?Q?VGfOHi/OM9TnjHa3TQcAlWNKF+DJ5lx6Md2xMmLBGxcW5kmVM9b5IoJ7YarZ?=
 =?us-ascii?Q?TAZ3qw8+bwVIFQhRKScpEwb3XSreHiMcSlLxrle8YYBDPoXwgca0oldPeEEP?=
 =?us-ascii?Q?6LoD4iTXZVEKUmTdoniwZWErIr83JbjNtc1MbDajNPW4LDgYXGo3A4WfVaxT?=
 =?us-ascii?Q?NDKOESYxtyY+940NxJn71SnBSz/Baujch8XoUSpB1+Iy+czc+X8aQWX/+C/J?=
 =?us-ascii?Q?eM31hTA8xdJgWh1mGA6LmJdtbtX9V4apMLgVORLUX7ewmaT+VvsS69R1nE5J?=
 =?us-ascii?Q?wNBp/YLdy+P2Ih7zQfIa71H+CR2RyMiYi9y2wgIBqVhs/FNA+0nEIp3cVNym?=
 =?us-ascii?Q?5/JHAGwCPemoongf+1Ax+2Q30Q5V0XZya05lsbdlanfehOzML74VwuLWDwBS?=
 =?us-ascii?Q?7W0SvglJ4zwc/DZ9yYlpHIYcMD9BdRYM0mVGwJxvf4wU2kXHL1E1ExRit8PJ?=
 =?us-ascii?Q?7Cetc0qMcGFMX7iwT7LNKR/rBtUYNa456NSSp4yzjMFlFXnXM3Wk87X8Ie4q?=
 =?us-ascii?Q?7goS3NYxLDiG0d1tYvuYPevSOPnuuBiR8nP1tbPZYh6UInuz2iqd9SllDzPg?=
 =?us-ascii?Q?9Vg0hGSEuB0UF+0tDZbxHVrwbYf2/gm7/rXji0c0FyDC0ut3HvYhcRoWKZV9?=
 =?us-ascii?Q?VnbwnGdrBx5aKd8yJ9YlapzjqLVWuznSOn8oxqnSN8wg6mGWWHcYuMdZ8NH7?=
 =?us-ascii?Q?jphv+eux2pBRjn8dJEBnsKO6915XOWhTLuc28liga2kmIcuPDwOBxI26kvyt?=
 =?us-ascii?Q?NcWwnfilf/fXARfwwwcCOWGqgw3ktDftneP3ETZZiZ8rh+RBlpgNLLPh9sIX?=
 =?us-ascii?Q?soHuMmtBR4URwiMXGHhL48CGbVP+IlIMa27q7FO9679JiKpelhHfHVatJ4mb?=
 =?us-ascii?Q?OcIsdTascG4JyCprT1o/xXzr3p9U52KyEtRH5oIPC8CEeIljB6mQa+S9nb3j?=
 =?us-ascii?Q?X7TDxga9rGvzZFnHYiU+U40ZQnmVs5ZxAnqjBwujJGIhXBih3XV0Zi7daWNH?=
 =?us-ascii?Q?RDQsz5BE4mHHi7mUlOVJVbzrACdGNvqmCMU9LfVF/SJcfMNCXbZ5rzOGbKqN?=
 =?us-ascii?Q?uCwSScC6xaOicmo8OHreR15VscyC6sRjAwqvphNMR/QXpRrBL/eF9pzRiv9s?=
 =?us-ascii?Q?ysuvkeE0NqzF8hFoRDDHNhrOhvEFZbfd99Fu33nrUBXWQAh3FKBGNK6Lwvnq?=
 =?us-ascii?Q?1cqunoUVPfWNVe3fI1CgG2dwET+zXeKJmzu4wFj5/QvD7+NJxCsFLC+tp5wA?=
 =?us-ascii?Q?BJ0F02iqd3Gwkt3axIvFuRfEu44T81uW0FSh5z7qiJgWHl+fapLqxjP+V6ux?=
 =?us-ascii?Q?dDpumGCRc++zQpuVPIl/kbuAaXXsDBBPm/0i226R?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mOpDQPu1e8FTHMVYVFsu1TPKS845zkIyNS6vkh73P4GJczVKUFyeJlNBp3Wypsz4t/8fFQors9aI4Jy3zMmaRU3nNoBrAOct4wpPB+JnDe6xZnAbzJxr5oOShpA+DEM1ug3UWkXYBSHGxvJ6gDX1QwHyfK6jaT11oSBFgE6huDgjQCAZyon81fExZGTaXkEN8k+6n6EQdyQsvlXQFBaq/XchvnusaKUroxyj4yZh6N6gCpz8QAq26bR6u03sUGzjmPOlubPq7vcwZHOOlDFCEdCl5W9KK1p2hDHaRxD5to8gSsval3tkAieGydG/7ZSbYD55foS6UH/fHqPbJ+JRYbqjQCJQXOU6qlvzJ7imut+dV0kYjFQ9QpkvpDL0YGG5bP555WMR/Kyvzyr854CS/uLePndxYaHw0jXRbEIjw6Kpd+MMztzB49RsuJQNKvfqdgsEBXTb60lsvQ1ybCkchh4D7mbEL0N7M3fYh80yAcWiNOPdjCbQ6XyJYZYMrgDkbZ4ire49cRjoLdNbjqYNlOm502+knoOwl152XPFrCxZRQZk7AoiTY1UX4wuqwh5IlJM40dKWGs6lIjPTopGenhPxObNPQjJCTrQ3D/J0iKPUJJo9AWhe8TzLY+6kR2QBE/Zoy8Nf6X//v23O5bX8FEF7UJepFiiclRj8KuKtqFB8BaxEeIS6q5w5su1qWrPmo3ZKx7EhtXyq+PQcLkKFKJ5Ddh0iihoPzFlsdV1wELagDeNPtEBToUtDCqjDnGL6YVPIkqfOXTpd8scFjwlzRaWaN0cq4FeEJGkDqzhNGz/9yX5HEKJWDlo88pkxBvIi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54133c81-1f7d-48d9-c445-08db3a3de47b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 03:36:10.6499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rpK9/p83dIjmCdCh9SJ+EMttibkk+Ik0BMpoiizSzgf3S6cnjG3H7KQVcMpiYPUy9sCyD4EzO4K6HSxkto+Ztw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110032
X-Proofpoint-GUID: -8kr4XIC1TZZzB3YclygcLR29zeRK-US
X-Proofpoint-ORIG-GUID: -8kr4XIC1TZZzB3YclygcLR29zeRK-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit b81b79f4eda2ea98ae5695c0b6eb384c8d90b74d upstream.

Add a new wrapper to check if a file system supports the v3 inode format
with a larger dinode core.  Previously we used xfs_sb_version_hascrc for
that, which is technically correct but a little confusing to read.

Also move xfs_dinode_good_version next to xfs_sb_version_has_v3inode
so that we have one place that documents the superblock version to
inode version relationship.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     | 17 +++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c     |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.c  | 17 +++--------------
 fs/xfs/libxfs/xfs_inode_buf.h  |  2 --
 fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
 fs/xfs/xfs_buf_item.c          |  2 +-
 fs/xfs/xfs_log_recover.c       |  2 +-
 7 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1f24473121f0..c20c4dd6e1d3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -497,6 +497,23 @@ static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
+/*
+ * v5 file systems support V3 inodes only, earlier file systems support
+ * v2 and v1 inodes.
+ */
+static inline bool xfs_sb_version_has_v3inode(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
+static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
+		uint8_t version)
+{
+	if (xfs_sb_version_has_v3inode(sbp))
+		return version == 3;
+	return version == 1 || version == 2;
+}
+
 static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c3e0c2f61be4..ddf92b14223a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -303,7 +303,7 @@ xfs_ialloc_inode_init(
 	 * That means for v3 inode we log the entire buffer rather than just the
 	 * inode cores.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		version = 3;
 		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
 
@@ -2818,7 +2818,7 @@ xfs_ialloc_setup_geometry(
 	 * cannot change the behavior.
 	 */
 	igeo->inode_cluster_size_raw = XFS_INODE_BIG_CLUSTER_SIZE;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		int	new_size = igeo->inode_cluster_size_raw;
 
 		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 947c2aac66bd..c4fdb0c012aa 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -44,17 +44,6 @@ xfs_inobp_check(
 }
 #endif
 
-bool
-xfs_dinode_good_version(
-	struct xfs_mount *mp,
-	__u8		version)
-{
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return version == 3;
-
-	return version == 1 || version == 2;
-}
-
 /*
  * If we are doing readahead on an inode buffer, we might be in log recovery
  * reading an inode allocation buffer that hasn't yet been replayed, and hence
@@ -93,7 +82,7 @@ xfs_inode_buf_verify(
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
 		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
-			xfs_dinode_good_version(mp, dip->di_version) &&
+			xfs_dinode_good_version(&mp->m_sb, dip->di_version) &&
 			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP))) {
@@ -454,7 +443,7 @@ xfs_dinode_verify(
 
 	/* Verify v3 integrity information first */
 	if (dip->di_version >= 3) {
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
+		if (!xfs_sb_version_has_v3inode(&mp->m_sb))
 			return __this_address;
 		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 				      XFS_DINODE_CRC_OFF))
@@ -629,7 +618,7 @@ xfs_iread(
 
 	/* shortcut IO on inode allocation if possible */
 	if ((iget_flags & XFS_IGET_CREATE) &&
-	    xfs_sb_version_hascrc(&mp->m_sb) &&
+	    xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 0cb11fcc74b6..f1b73ecb1d82 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -59,8 +59,6 @@ void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
 
-bool	xfs_dinode_good_version(struct xfs_mount *mp, __u8 version);
-
 #if defined(DEBUG)
 void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #else
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 824073a839ac..8ece346def97 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -187,7 +187,7 @@ xfs_calc_inode_chunk_res(
 			       XFS_FSB_TO_B(mp, 1));
 	if (alloc) {
 		/* icreate tx uses ordered buffers */
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_sb_version_has_v3inode(&mp->m_sb))
 			return res;
 		size = XFS_FSB_TO_B(mp, 1);
 	}
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index b1452117e442..f98260ed6d51 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -328,7 +328,7 @@ xfs_buf_item_format(
 	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (xfs_sb_version_hascrc(&lip->li_mountp->m_sb) ||
+		if (xfs_sb_version_has_v3inode(&lip->li_mountp->m_sb) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6c60cdd10d33..598a8c00a082 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3018,7 +3018,7 @@ xlog_recover_inode_pass2(
 	 * superblock flag to determine whether we need to look at di_flushiter
 	 * to skip replay when the on disk inode is newer than the log one
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (!xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
 		/*
 		 * Deal with the wrap case, DI_MAX_FLUSH is less
-- 
2.39.1

