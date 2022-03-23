Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BF5C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344854AbiCWVJS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344888AbiCWVJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:09:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C8B8CD8A
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:32 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYMjb031979
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=h5DhRca4zryPXrcoZOXKCc0lz+98mokyw5DgOaFMES8=;
 b=xy8XqZOaMBmVzCzTfEVG5pJzNGEU7UW0DT2O7LXjvq1G5KcILwCMsTw9Zx1LdhFIsHdA
 /vNQMWiKcPPPptRC9hfaEMn6MCmy3whPBlYH6vmuJk/7eOQdTdp0fsZhOoTQEfdpO5pf
 BQ/WQWYtXa7/56o93FbF3cujFkNRHjCy8jE4S7AIPwAG69eOzs5IuYEsyuLcKAl6lsvb
 kTVbs8KYXF/peaqIJhJe9trz7LRTD57GBJftl8v7TH/6xUe8a9dQyqwKB13Uq5dxvJTn
 piIXAyk7iHKjpdTuIs1jznpm7pgaW7a13VwiOeMyx5BAHJaTg7II/Hx8J/18KvKGdOsr Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72ajf38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6R9q154749
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 3ew701q88e-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBM238ntxKVGtbrJeQTbbkeOjZiWLkzIFFSDPPIAlhhIkNR2KGftWLuhR4eo01qrPwcmLwbaEg3rZ8IujDmhG3WXT1feUSrZvo73QEWAAmsVuWolbBBhfMUMdEfiE0f4QSxrG2H1qFbz6hN5DxE/dLt1xJ2pxon6uICrYKcwmYrAFLVHRfhitt591c/07xCIa2viX5rHJsuvmYn71aVFTj+Q/OzpTjM7MhUETvamPJ8eo0kDQBZs6L3/4ZwZRK7m2GMwj5CaEyWHu4vPfyS7FRGBnDy1HlfgNdzVE8zXlOBn9Mm6r8OKCmYqUg0Ivt7g1v4DbMXgv5Mwd6Usd6oHbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5DhRca4zryPXrcoZOXKCc0lz+98mokyw5DgOaFMES8=;
 b=AXinGgd+mNK38OSkBg47nTTVAbgMLftGRkQOEGDhiNiKIdHbq8+zPK+1KBCg42gzNUIqNVdfqeE/e4JCIuGKyisdmvaOpIkbFCdU5DsBzDCFQhNdCNCNeFhFyeoYQw3rXBQVKqquHJXVn3HP4wAdU+CEOqfoj3htFlpgZv3Dql/nNa1HXVoc3RBMPxInn8TJyfpoPbkroz8/6IifGi4IU6otiXqSSDu6b7rbGiJesrqYpY8HGwx+DIFnu0RJw+LzLzuoaTxrNmvv+ja3QloKzmWDY2RJoDwDIUGpbhsMVG56w42TEOREUxOX4NZptWohfxAFqIOXs6VqvLJzgIwekQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5DhRca4zryPXrcoZOXKCc0lz+98mokyw5DgOaFMES8=;
 b=oS8fcwYs0HYnBYCMlpmY4bfO+vVlET9Efsrvh0AG0PQHE08Sm7zOv0q06FgB1OKqpyySCLxY1l7Mtc/aOmZGQhbZXZje51ovNH/uhW6pdw27HwiSEtiMJzaw6Lwg6R4k/oRE/eG9YISmJkNaLAefmSTnm+b8Su63Ba5XA4vgGK8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5600.namprd10.prod.outlook.com (2603:10b6:a03:3dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Wed, 23 Mar
 2022 21:07:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:28 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 14/15] xfs: add leaf split error tag
Date:   Wed, 23 Mar 2022 14:07:14 -0700
Message-Id: <20220323210715.201009-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220323210715.201009-1-allison.henderson@oracle.com>
References: <20220323210715.201009-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0084.namprd07.prod.outlook.com
 (2603:10b6:510:f::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08b8d182-aba2-4b6a-ef4b-08da0d112307
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5600:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5600881D128A274313075CD795189@SJ0PR10MB5600.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nf+Usf+Ju3m2bE3jfm1Ws5wMOvGcxu69Y5SIVOOqc9ew7g2YIky4EYxxT0luvCvrw+10j1SpyUoOAMFYIgY0dtheGJdYRSCY0DZV2RLMjG/rSFrVl8NT0cbHn16LyJ+Dq+lNjZKPPsTFPQH4CZxtN2bDd9PuGtEvJJISwLXOLXZGM+/eR3B7sFysJtld0k0bT3MKfpHGanFeqk9G81FASR6GUMPU6Rrj7yi34V3VdZTP6SSafCRn7lRvD+/XrXeGsFLXSNUebPfxOEibsyTjAnj1MwiAcM7Fgwkimrl6EKysN7pJTNo30BOmi3fpkln1SqKuxq4/fcx7GPdgKuwbkFNwX5qmqHSqiS60dBeXPT7bohYyXxoHeq7lLMXaVPhEm3yZT5wzGPR9B7AmqLgJQavHbPSSha5skNvY0CH/657Xl6N+YM183JO+TqgI5lRUpmAD+55neFC4kXt/up/1I3Z1+xeZ5xXam5/FXoKGA6fwoLYZq7SnusUF4tyS/+Z5JUyZmVW6Wgwp68ttP/iTbErwu8nwJfp5LFsLPv0UUoCXQWFS6bS+kxs6MyRUleKNS2FP2ys2hfnp+w1B7Mk4/xllsHjjeeuXCwSYNrC7A72UpM9QmG0+hRsje1yS8L+L8lvvQt4l8haJ1OBeBoWpiD0RS51ttYxLKYE6XFq8LymrYFUyYwUXEHtXF7WSW15MPfaH4gxiBgKVFFZmLcWOjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66476007)(66946007)(44832011)(8676002)(6512007)(83380400001)(86362001)(52116002)(6486002)(6506007)(508600001)(6666004)(2906002)(6916009)(2616005)(36756003)(316002)(5660300002)(1076003)(186003)(8936002)(26005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+R1tHXWaTgqnWRGR1qP/GTkI38jTZoVin4mXhimflRKH8vCqPTc7h0DPb92C?=
 =?us-ascii?Q?9nSFEMEKOWz6+VMC23NENl4IzjzRFxugjAQ47YW74+N1GsOd64h/ZX1bvmuL?=
 =?us-ascii?Q?pRNa/FHq/ou4zWc95a1Rg87A/vLsUKa/gtmyH9zGmg9O9k9Y4/1x0+gl2xdL?=
 =?us-ascii?Q?vR9MM8AE5CZKVt9fSi6FxOray+/Hx9BSb/3h8afJ++pIAfRc3e30oj26CNBW?=
 =?us-ascii?Q?IRqhydV2iD0w+Eiyt2QBi2lyOrmZG6mWbeA2EQAjPZ/Nh2RwVo/Suge3evHM?=
 =?us-ascii?Q?dDmPjM323hqcxmRXO868o89FS/26hzDB3TuutFefM2R2itOzMWX23TQeh2RH?=
 =?us-ascii?Q?fVAA09gIZWD+G4JShyqEpARaYymKDr9yPn8Fe65Le06r5EaYZ2a6WYkxziIs?=
 =?us-ascii?Q?LoCw1ZzOYa7vMdlps51JgbiHETQHehgHv8vdURZC+On0ZuhUZ0N+SCp0I2r4?=
 =?us-ascii?Q?/02Q/2vUeBp6KiAb5mam3nuum0zJqOZgwIcCdDG0qiFk+EqwjQsLcAd5NSVN?=
 =?us-ascii?Q?Ga2CilYsZeFyj3UOPr5cwKooiYg4M6691lrdp9wECZgCnH8jnJTf8Zadwlds?=
 =?us-ascii?Q?Fekd1dWHcG8LwYO8sJ0yiOJcfZjHqMHs2zKtfdK8sIV5SR1dgglTQDJUVyjE?=
 =?us-ascii?Q?qetUQj9c7yqoJxe9nQ6xEZKb4rIujJZHBOgkPPnuhrtCqzHVxyqfYiBW4BjQ?=
 =?us-ascii?Q?qfQ0u00aF/ODvPmBELEYyDhSwiwbrU9S5L5quoly9U3v2S+duo0cOKOCT0iq?=
 =?us-ascii?Q?IGjY0WjK01sjTnMTSS4vihN0yOtnziIOt0CRMjvZfDszlYMMNVo68X6TMkF1?=
 =?us-ascii?Q?/XgKKtDdQa2hcDzZBSQGoTU4RPKUeenkuELWSWrzue4r2I7WL1IuoiikNV/n?=
 =?us-ascii?Q?6IeRWNXLRkQmzIIFeY8ufZuyJ2dUMMUhCRrOZVN0J1rf7pDHxky688kx5tUo?=
 =?us-ascii?Q?dkKegwuDb6S923uhJcHxgMKSfkrGecIFNBwkdkaSoPlJKjYuDn/SBxrhwwiS?=
 =?us-ascii?Q?rEdhx2AkiPfBk4WH8FXu52beXjW+XXrFO4dMdKqma5K9VnIaxVhEw+iKTtf1?=
 =?us-ascii?Q?txly1m7//9RP/p/uMpb2LHQtUZkNiVouSguJKAkeSGVIDfflmjE0C+c4H6bz?=
 =?us-ascii?Q?vAQwOPkT0zDdWMBADYMQwBda3jKo/di/vhWlrsZkgKW1drbzV6EDH3SgPpOY?=
 =?us-ascii?Q?xg9sjudfoUBD2FMfn42+50lvJ8uaHC73sgpTB2R9QPWJAa//Ksb+UHgKPtYl?=
 =?us-ascii?Q?g72y+rl0Iq/1Z7GbwHaYFDz7zLxNpiYoBok8L7MtSJmSvFqOWyO2rJ7ln6QL?=
 =?us-ascii?Q?yVCj/sa6yzPudolB8hLwsYRX894MkZNmG3D7ESukVQEK3mIITIp7BtX1z6zl?=
 =?us-ascii?Q?7gLdfdgM+YBWRdApIwbnkEGJT45SlAsVON1Qwhy4TMU7b6XSowlJ8U6gbpCX?=
 =?us-ascii?Q?Bv0WHY/rdbNCpNeP1nKvfTNhUhpKCWLYK4xoZFWpqHCOLz/fj3WQYw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b8d182-aba2-4b6a-ef4b-08da0d112307
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:28.1237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3xHxU9gwpd0KnvXdvet7olTiYW5KJRa6dWMAio211TdxXZPZDYJWjQqAsMFbGGBh+vdZLhcYMgBuH7lMVVSkMyrMJCk7tgyspu+CsMSkqH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5600
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: wvnbrS7FkWB2QbOqGfCB8anod1_38ata
X-Proofpoint-ORIG-GUID: wvnbrS7FkWB2QbOqGfCB8anod1_38ata
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 4 ++++
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9dc1ecb9713d..aa74f3fdb571 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_errortag.h"
 
 /*
  * xfs_da_btree.c
@@ -482,6 +483,9 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_DA_LEAF_SPLIT))
+		return -EIO;
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index c15d2340220c..6d06a502bbdf 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -60,7 +60,8 @@
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
-#define XFS_ERRTAG_MAX					40
+#define XFS_ERRTAG_DA_LEAF_SPLIT			40
+#define XFS_ERRTAG_MAX					41
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -105,5 +106,6 @@
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
+#define XFS_RANDOM_DA_LEAF_SPLIT			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 666f4837b1e1..2aa5d4d2b30a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
+	XFS_RANDOM_DA_LEAF_SPLIT,
 };
 
 struct xfs_errortag_attr {
@@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
+XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
+	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.25.1

