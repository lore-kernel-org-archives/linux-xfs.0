Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0080DC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344503AbiCWVJQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240930AbiCWVJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:09:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600958EB53
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYUvw011998
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=Af03T31u2y2ZuaGoP2kTHccW+Eg4gGdVpOz4egX7exA=;
 b=qkefzN9y+9QmwY+QikZP2PvapswsT9jFa3o/1qqvUbIn0Xgvrtx7R7Ufs4KdRx3b+KJS
 XHY91hCV1VMyXsoYdnaWgBndIrfMQ0mLL5enBemwrfHqyAqJLp+hLtWykhTedmT9/XJT
 L1Bv5rHmHYN4sIi2O66DCGajIDHDyWJxhUtr1jPgsMr4R3yfkXcy45QK9KLbLcz+JkHe
 Qmve2yr88Z0+OgU9rHTGdEl0LN/gqWaolrAgLNGBxpHUoripmKJg3BJ6kcGsfunlt3c+
 TABqCCIarA2axskSwrNs007vX3qnLCvRX3J0XqCaLGFYKS5NawKDSpnG8lxZHYHdNxKy bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0tt8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6R9r154749
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 3ew701q88e-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/9DZvArN9eExc0hJVUn2rptRsQS3ypOBHoCgYb+EvTGCx5QXmwVaqjb7KipUq448SyupaxdLiVgZgxCDm/n0l6UuMDF/w6Rx3tz7l9xf9EHuH1Rm7jFrVUdD54gRHGI5Drw4l4qdRXy0zLUsIdcxbaiJ/ExXNp1VbwZyAu2eNipO2s4O3fCAUHSzjx+blrvgnQUaGrmBhnPwWd9E370+2EdYD2VzKwmuDsCZCEZCju81yqFeAY4Jo1yCGm76t1/P8vZnVeU529NS5tGarJ7NpkCqJalFui9DTyKAVxEhNBw9Qm8AvdWCkHB/17K3+uCTeEu4RjPwf0FTKH/W/AfYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Af03T31u2y2ZuaGoP2kTHccW+Eg4gGdVpOz4egX7exA=;
 b=P41efDo2zyT/BPFZ4dCSe+RitTDkflyoo2igvaYCJyYHDrdVf9DQIegfw1XehE1JMlnAoQqmzk3dr4fPFqWzuC+PjIOtkiEKs+XKJ39ea8vtEWCG4VKB85E5AS8neu+iOLhS/7s0yb7MMsdKNQLly+TSzshW4PO3YMkrZl0VtU20FRs1NHSBzrlzGBfdTGZLqZiv4/R3uxx5xCtTzby5LF9xXyoKl9IBuP4ENyxMjO45q+KxgjWfbyL7iNnucOdK2v/l5tQeksU7AWuFevt89Tw6jtCQoLvuXr64Yy2I0vmJOanp+Tz4G6RwKq1tTOZxvzSPaRHHURqPeokCEkQbIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Af03T31u2y2ZuaGoP2kTHccW+Eg4gGdVpOz4egX7exA=;
 b=ZKT2TwzZbt9bryjBbY4ljJf4Fb7qawBJWswkPHjY8V3RGNDk2Rkd3SeerXAKMfAjtLIFw0VqM3oNonRfIrgRLj7xwrY7RkNXa6EtSkd3ouBfUw8ZnNMVMlQ0i6T6nvksKO5do1yXGgf5F5LNWWIJ4qDJPr22DKxcuSFXSGfeXIc=
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
Subject: [PATCH v29 15/15] xfs: add leaf to node error tag
Date:   Wed, 23 Mar 2022 14:07:15 -0700
Message-Id: <20220323210715.201009-16-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5d6fd293-ba56-4caa-1d70-08da0d112346
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5600:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5600D181AF76AD9A9BFE343B95189@SJ0PR10MB5600.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HC0B6GyiNZp3fZkMWIGXEJ7Y97WMv/fVANknMqBo+rCUiKSCPvOpOWz4+9LAeccf9JdtM+939lU6F/AoCYOd8C/dgK8dobhGhKJZqeZKMfJJvqJeipKW/9a09ozOgo1kw97EdgY+EghgxG9W+ntmAZQlCHM3TeGjssO/CYR7Pcn3FybEyLdWWw65SqF5TcmEFFjrs5XQ2fIYhW7l+vGqIX/tHVqwIYUhoRhSMoWdnkGVWlVTQ4CCd6iBSRKoFIGKZgbXqEi0L63+snGLy9VwFryi7Thd7vpdMimIhxEtmJUxvfk38CvCyEwkyt0nyOQrV5lJUOxPdGu/tCPZLuzK3GMjJVNsvL1gnrgKbYNqaaVeI4XjqBwzSPAXG1MNuiOV+ThjqMwQ2XmhXQT0ZLpDAGMo4sLn9i0chFgKQ/0YiUTraHSBuHTdjEamaOzCIKXVXVrgEdI8TbzS+bFcLxxekVe/ooaVPdH7mLwYDvQFf+wULuuUbMjQG9qyLRD1XURqJGUKDh37s6tqSQ4FemNrbir2NhBSO6yMHPozxpaczkUoPjbcBmw9cAkyoqmDQ6R+ONiPS7Ek7JOcgRTZxKamM8xtuTxWdcFXlYOpM7xgFUUQl3SzlS+o++A4zinpXsYlU1qToZ+CRQvhct4TndsUAVEvppvDNi9RNxdYY/JMHiZhzmYP2g0brVp+3SMyJJfRpJzk+iXLfLtYLR5JgfAdaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66476007)(66946007)(44832011)(8676002)(6512007)(83380400001)(86362001)(52116002)(6486002)(6506007)(508600001)(6666004)(2906002)(6916009)(2616005)(36756003)(316002)(5660300002)(1076003)(186003)(8936002)(26005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qKvsj0eVj+KdKJVlj+30ucJQpWisg7Nx0BYGWQqY8q/MV0242jmPCyHb+TfN?=
 =?us-ascii?Q?nEK6kgiDtk0S1XdN7KLe/GPBNoNDvH5IPKntiOnnZHaqTUpsakId8bzruIuR?=
 =?us-ascii?Q?9mEMYAqbtaVCMTAVRXsTzL64xqlsQDxv7GXwKFjX9bjZqGOxlDTnSQXfheJ6?=
 =?us-ascii?Q?y3TQP31wCEn91UL/VL50LLSOhmVpPP+Kr5bTSpNlERJsmtZPX50byMrNwmiV?=
 =?us-ascii?Q?HCSbYXsGlBaAbrAu74HTMQrd0qUJemS7fnOmXC9pjZSSsk+CRpAVgU70tgs/?=
 =?us-ascii?Q?2gf50OXB661IWrZGvrU1oUzu+wntxgi9BWofnCd6QcUH8ACFSkeZjmqUEyYB?=
 =?us-ascii?Q?UnCSVOv0a19dCIjAWQf4nkO4zBdo16tao9zCVryKd/Un5aNQg1VwYaNT6PHV?=
 =?us-ascii?Q?W3AJpmPLHmPIot4uJDq5o70lfdf9jtP4hEb43spiSO69qpJDUUYH/sk58HnD?=
 =?us-ascii?Q?4twYHLBV6thDSRdZE/fpSN88UK4A4utAiaC3MgpQKXrGy4za4HoYpLTdeVnY?=
 =?us-ascii?Q?R2FE5UkE5dY8GhubQqaH95YlkTjWfhXfY8uxwYpVs6DArbbq0DYLHD4kk9yS?=
 =?us-ascii?Q?6d5kK0gBOUiVy3jRjb6GwihaZXfYdD5lbP2vPoj1Q/2OGYNqkJ6PGCF3gKgU?=
 =?us-ascii?Q?ZMx74MGpPUnW/WJhMbDuEG1rZntA7E7CRoVabbe1MD2tkQ7nt1ey+ZM2Mrjd?=
 =?us-ascii?Q?KjY08SnmRSwResN98esyGFwCAisVicaY376G+ahvm+3yu3Gmj26Bjhr4PNOh?=
 =?us-ascii?Q?LYdHrPWwqpKhc5HHfrpEVbX1iJvL3rld3wPnvHs5TrITkclSaGp1hrV64mD6?=
 =?us-ascii?Q?ds+kDh4UR2EcfuW+2RFEy1+MOHi6J6z4Dj08pMq4vhp+q26psLBOrkKgkATS?=
 =?us-ascii?Q?tOdclSGnYeMEHQDJuKs8/rndTo/ZLi5n2Ek6Fp1vR2oSC4UX9cghh8PjlWca?=
 =?us-ascii?Q?a99W0qit7gPbLvRZIznHI6OB5apcfJWT8B+Pj7itflbIFR/O3xNuqzro8N8M?=
 =?us-ascii?Q?6peMVKqHtFb9i2VqNZ0XLLDh8AEgXgjWodXuyBPFk1mrXr0mU+ME7wOmMJco?=
 =?us-ascii?Q?klkukLKZZ2h+B0Wb8GBteVoaEJjsUuhfn4ZNjyw7MpPh1KhBGllY94RohR7w?=
 =?us-ascii?Q?PPqlTMfRybxss9ltAqIni2CjXuIV8kxnlov6eUQniKzFgFnLIVPX5GT6WYXq?=
 =?us-ascii?Q?4mmp6V4XdOKg0QXEfCjet/c97+FdGVA3qNkUXw/CfuXG6nhySTss6z/BP53Y?=
 =?us-ascii?Q?xZ7uH5iC9OFG41bM6t5QBE2p3l8eiBx/cK284YuNj0AaTHsqi+2uiSOkCxjB?=
 =?us-ascii?Q?bGvLvf/MBuQflVoAFvU+Eup+c+3bwVVpa6LZizN2XeYR0AU3kAgJIT92e0Ze?=
 =?us-ascii?Q?YBBCgLsxr7dcl0TGtcRtLvfCKUptyPMnkHCuW2PGEw9L54on7ToGArhxZU8a?=
 =?us-ascii?Q?HbP0ZM4vDt6P+wtxAsH2cIbi/r/sffOzE/BwT48LtJ9Z/aPNVdHj8A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d6fd293-ba56-4caa-1d70-08da0d112346
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:28.5311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HyeLFsSj0VGBlysUmNH+/JHaILSmjSqcf2TzQKQWGVVJRaar30RXNhOUO5oQoMxFgVIafPLaMFFhG1R3gdtza7c+fwyUp6Z52+f6r5PeZfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5600
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: B3FDnb96RsTBx_k1h2aovCYZGxBsd6nO
X-Proofpoint-ORIG-GUID: B3FDnb96RsTBx_k1h2aovCYZGxBsd6nO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
 fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
 fs/xfs/xfs_error.c            | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 74b76b09509f..e90bfd9d7551 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -28,6 +28,7 @@
 #include "xfs_dir2.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_errortag.h"
 
 
 /*
@@ -1189,6 +1190,11 @@ xfs_attr3_leaf_to_node(
 
 	trace_xfs_attr_leaf_to_node(args);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_ATTR_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 6d06a502bbdf..5362908164b0 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
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
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 2aa5d4d2b30a..296faa41d81d 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -59,6 +59,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
 	XFS_RANDOM_DA_LEAF_SPLIT,
+	XFS_RANDOM_ATTR_LEAF_TO_NODE,
 };
 
 struct xfs_errortag_attr {
@@ -174,6 +175,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTE
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
 XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
+XFS_ERRORTAG_ATTR_RW(attr_leaf_to_node,	XFS_ERRTAG_ATTR_LEAF_TO_NODE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -217,6 +219,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
 	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
+	XFS_ERRORTAG_ATTR_LIST(attr_leaf_to_node),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.25.1

