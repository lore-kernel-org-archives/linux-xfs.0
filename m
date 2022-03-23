Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0222C43217
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240930AbiCWVJS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344861AbiCWVJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:09:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB1E8EB50
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:30 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYRLO007704
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=zqBAj51JLZvrXZKxM0mMKB3s9alfhgk07k0IC6r8FfQ=;
 b=uKYt8wS2BgdCGq6CDHFwIag1dLGrNXch4OBmkvCTjl1nwG+8UPyArhHA1zHkdOmAdD68
 U2qElkJwbAPFXP7FWEkASuvMsKGVU/FuAuZbyxAdJY4etD+dkCPN4xl1LDQ/TO6YmUmL
 fMYqNVVxYl/tNuALs1JqHA501Z6RF0kGddUkH7ytlcodkOczBeyAwkTWbxT4eQBfvJEu
 KAzPgEsXYP9woOPLAxJ4LeqmcsA6s7gYwhP0irn1x8GnlyC6pdz9RyaB3JEfaB5nByGR
 +2LbYZ5JPND+oKOhkxNP8JqokkwH4p4jQ1X5OfQFsn95H3ncXRK7EahL7Ft5spzJVDz4 sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qtawty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6R9o154749
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 3ew701q88e-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/TdZJ9tpYRM7otYVHMJK5m7ZZLOGMFotxDfAo8KwqYwI77DMnLsHLG+0OhSaUFQZ/dYLfTY0FQsuLe4xhZk5bqEfD7PCnN0Vw+CUfcCFtRbWn1xOChmdUoWQYTf21vv7NkXleaDqXBaQh8H1l86SFy/XwF6GS76PrI+fbKGXNux0d9S1Hc77OwrjzkOycxehgrd6e5jcvwG3+bVJA1+v4iyo046S602CofTU+sJSC7ue9sx9fAhDAiRu+/PtyxSLwR/r3nGQFlrpgd4OhZUxNXBBCRNZVoLZLtoCjK7fXUApm/+awjrCAXquYMrwNJelpVPZ+oeaPnSLBlkJjQ7sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqBAj51JLZvrXZKxM0mMKB3s9alfhgk07k0IC6r8FfQ=;
 b=JEs+4IPm/baiQpgwPIb/5KargMTXV4gG6F0LMmrZqGDDaEBlJkmKHOWeqpduM1LGMM9voKJ53i2gSUb0vT76n/I0fbCkc3EeMpIVOL8gaRAG9pN3t9D7BlhvewWZYx6xa+mDjz1cw0kuuMn1ZinNHy2U/AnFGm0TYKZPo/Eu+p91iu7d6gefiQg6gYpNYC0rb8OdH2FcztprHMMF8ghaFhc81M5iyL9lguWVBvEGnSpRlRUDkDZquAYxW7qya9TDLiPu5C2bS9Ap880ixH9b7ckWO1CsGTHRhmbjxpm67d2nWeDrJOJnQP1Dnp7PRLhdIolMroXd2dq91ysI8LXYEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqBAj51JLZvrXZKxM0mMKB3s9alfhgk07k0IC6r8FfQ=;
 b=obyr9rEaZZdYFzQknQLuWq+6oY8fw5iLlaAey4gTD5yoWjNOSGjpKv9e+n+SbWaHqPJRTzFKP6nBGMLubeCXAn9Yhz4n7AaQ/d32sSsHXihvls3FLfHhq8Jj8InTIPcC8x+ZIClMQKl8H8U5aJij1xqkw7ECcOWxryMzRnRKnaY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5600.namprd10.prod.outlook.com (2603:10b6:a03:3dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Wed, 23 Mar
 2022 21:07:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:27 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 12/15] xfs: Add helper function xfs_attr_leaf_addname
Date:   Wed, 23 Mar 2022 14:07:12 -0700
Message-Id: <20220323210715.201009-13-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: c0e9cea3-0575-4105-3a0f-08da0d112293
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5600:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5600CB2E3DFB480A775A196695189@SJ0PR10MB5600.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZSs+Rgb/EE1Pd9FPAX0Sv4TTf8LXzkEC/hBvwnjQmragL6nOM8SD+1Gavg/ZNAHH+rnYc1sRTelTooddojWSzRtQi5NKLBYwBPoegdTbyROVzq1SOT5+e3Od49rCCJa/AN52+LMDWbFjj/WAPJ3kfDYB5DmOjf1xMdCJY1O4EvuY2Q1+QMquCtOrjkS24lTb5nVUs7FyqTqDUF83BiXMl27jE2bbLO0XtDB8Z2BDfNOqnj+vALdiJGkUPAS+N10mKZEKdGXiSxxdFXg3rJvhOuokWjnEJJHwkNAZ13Twn8eiBabXdu8tl0hF0jSFHSav7P/VLGE/dW/zKrcqUju96Fkv764QBtGiZIAA54fZZkIOBV4C77pDIe+U5cW4dkUsGyNlH5wQ+t7dtlKO+rn8H2oL5XVezc02gqX/jT4kJY2OEkA8nDsghnFnvwuhcRmUmU1LmMecv/O9641wx3UafnDbWuEac3OxF9NhW3IdXpkr3V8KYWaOFkozBUMzP9IR84prnmrw5G2V8AV4eIoKnUg1jK+F3CoNVNYdptf2etggtNjBJmDhB92pHmrVFiCN3/dUH7cnpm5B+G3zPbuPzk80AEIPm/JdAIn+/T01zg7G8KbiU11I0OEmqVfWG0WUGx/zjUPO659FFCejS45KuXODSp0o5QZ4H83XgDZOjbnVRXqa+TCtRidAtJqoOYpuTGLGFgfkyOmablNwymHO8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66476007)(66946007)(44832011)(8676002)(6512007)(83380400001)(86362001)(52116002)(6486002)(6506007)(508600001)(6666004)(2906002)(6916009)(2616005)(36756003)(316002)(5660300002)(1076003)(186003)(8936002)(26005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XS40bDZPoZS6F/xm5JkTQzgFGLLj1TX5AvVIdYbnjTvoVdalXsxE1U3/jG99?=
 =?us-ascii?Q?1UCwcIODKIPsATF44DtLS3XUDWi6TpwyRvLZWWp+qfTfU0s7MR2VXQZ/pris?=
 =?us-ascii?Q?7yUSkft7qFj8zbKVM4bPeFeZqLIqhEe91xNcfet0CxkZ5WYh61jmh9QSVDYr?=
 =?us-ascii?Q?O4hf7T/JJNYYdhUC1r9ehI7f4xOGYOhX+dGw0SyptnJKlAnPa5WMWTWPw+gi?=
 =?us-ascii?Q?URtAzLeR+ALp0Jax9S+YHUy/rReZ+kGhLfSMHfshYBv5QO4jelMcLkg8Lo6r?=
 =?us-ascii?Q?bRsNnJeGw+g45RcoZxYT8MIoYhQLpW1SKU0ygnS+NnmdLIm/uXkTplGhQca+?=
 =?us-ascii?Q?uQl6FpM3j8uEIlUZpHd3MW8LwGIX9ixp3MdqjXHMBZCx/Dwq4F1wHF+bLSug?=
 =?us-ascii?Q?FJHBqEyOafLdcfDo7JTZJeB+KGVa/SZJfXG3WN0QeqMjGe73OPPMWuNwhkRu?=
 =?us-ascii?Q?pN/F4ArYdxSJwmOzUBuAepb0ljxtVS3hFH4zvUbohzsAN0drX1WetfmA5ZG5?=
 =?us-ascii?Q?F+3V3kF882uFYOs8hHGCr0jHio7FWyM1QBFhuuyZP2tVlbhRQn6n44O6JZSX?=
 =?us-ascii?Q?W9+DqS4Jjds5AxH87LmBs83z/sZagI+hUn+mApgCwvn6K8HknCc19bdxOCE5?=
 =?us-ascii?Q?1toAQJzoOhKaTFCj0Pf8cAylXtNjeDaSWI1GECZsbWtBUy1JVWV9nOhQAJvR?=
 =?us-ascii?Q?qjtg0WE9sRn+hDmQGPJfOpNuw6VKSUFOiXcW0w/yGKLNpblc2AGjnw34uoty?=
 =?us-ascii?Q?k08EOW2gKuOQH0cvI8LM4fEzQVC0e5fI9TRw9d2gkdWupYcQj7NeiHKx3PzQ?=
 =?us-ascii?Q?MbKDCSNzVt40mKbL3Va+nFTwN2Wiz0RJ50zwbCtQXhBjJ4uYbwlAJJ364CA/?=
 =?us-ascii?Q?8G7Q9wMhFghDwR36EG5GZo2M0ja3JRCOgKDEGjM5zqX/OCo5dqz5K/KSH9TX?=
 =?us-ascii?Q?gnhDNfUR6a9HHtDrXakwzTtxh/NeVr5187z1dsbXG9gmiPma1zOFWG/OXV+I?=
 =?us-ascii?Q?qeSW7B809dyV/2Y1mJ+RO+TIUFTgT8Sk05KeSgW0e6Q0g7y+Qq07SQbLvOAV?=
 =?us-ascii?Q?OtBi+Jr8tHywM5J8ujJZ0AFFo8JDjsAvoFCb+xqclfwOkyqjR9uoh7JherhQ?=
 =?us-ascii?Q?jsZwMhP2AIQuyaTBHf7b3N/uUuLZ95+TbSd27m12zR0SOcL5G71nrQM1vcY1?=
 =?us-ascii?Q?QSf9YKZt+gANsykT8Az7fMGjr9maP/nVDHbVIhpGhy7Jr3aRT5PNYEwQtAop?=
 =?us-ascii?Q?rDhYUXAXYWr8eFDkXb4NHG/yxT7RKSAkhf57v3xULZKDgL0LSBmDHyBTOcCH?=
 =?us-ascii?Q?q7aliPDRMbu1sTfCTgr3/yrgeHvaSY3ob/4yX6RHaiKIv1EAdtULNVUjk6Wg?=
 =?us-ascii?Q?+LuIDYoMlBN5vKIkuwRHl1hFy9mmOJLLhuTDyZS9avIE7s7lCf6JzIOZOJ9A?=
 =?us-ascii?Q?jR9rV+CBoBt9LOYxFyQ4aU29mF9gXbwry6ER9Pvjpg15cnqJW4lPyw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e9cea3-0575-4105-3a0f-08da0d112293
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:27.3119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/T1J2QSoVsXQe1f2/dGiyMflYldju8qnIpZDrotXc9hOtkGF36w3x7eSe4Ypxw0JjHjkTYxY69tpB7hfBGziN0VlmqWCoFBwEnW3UL4hKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5600
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: pf_JHi1iYWCZbCNMS8O9GFNciBcZFV1j
X-Proofpoint-ORIG-GUID: pf_JHi1iYWCZbCNMS8O9GFNciBcZFV1j
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_leaf_addname.  While this
does help to break down xfs_attr_set_iter, it does also hoist out some
of the state management.  This patch has been moved to the end of the
clean up series for further discussion.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 110 +++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h       |   1 +
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1b1aa3079469..7d6ad1d0e10b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -287,6 +287,65 @@ xfs_attr_sf_addname(
 	return -EAGAIN;
 }
 
+STATIC int
+xfs_attr_leaf_addname(
+	struct xfs_attr_item	*attr)
+{
+	struct xfs_da_args	*args = attr->xattri_da_args;
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	if (xfs_attr_is_leaf(dp)) {
+		error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
+		if (error == -ENOSPC) {
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the
+			 * transaction once more.  The goal here is to call
+			 * node_addname with the inode and transaction in the
+			 * same state (inode locked and joined, transaction
+			 * clean) no matter how we got to this step.
+			 *
+			 * At this point, we are still in XFS_DAS_UNINIT, but
+			 * when we come back, we'll be a node, so we'll fall
+			 * down into the node handling code below
+			 */
+			trace_xfs_attr_set_iter_return(
+				attr->xattri_dela_state, args->dp);
+			return -EAGAIN;
+		}
+
+		if (error)
+			return error;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+	} else {
+		error = xfs_attr_node_addname_find_attr(attr);
+		if (error)
+			return error;
+
+		error = xfs_attr_node_addname(attr);
+		if (error)
+			return error;
+
+		/*
+		 * If addname was successful, and we dont need to alloc or
+		 * remove anymore blks, we're done.
+		 */
+		if (!args->rmtblkno &&
+		    !(args->op_flags & XFS_DA_OP_RENAME))
+			return 0;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	}
+
+	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  * This routine is meant to function as a delayed operation, and may return
@@ -322,57 +381,8 @@ xfs_attr_set_iter(
 			attr->xattri_leaf_bp = NULL;
 		}
 
-		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args,
-						      attr->xattri_leaf_bp);
-			if (error == -ENOSPC) {
-				error = xfs_attr3_leaf_to_node(args);
-				if (error)
-					return error;
-
-				/*
-				 * Finish any deferred work items and roll the
-				 * transaction once more.  The goal here is to
-				 * call node_addname with the inode and
-				 * transaction in the same state (inode locked
-				 * and joined, transaction clean) no matter how
-				 * we got to this step.
-				 *
-				 * At this point, we are still in
-				 * XFS_DAS_UNINIT, but when we come back, we'll
-				 * be a node, so we'll fall down into the node
-				 * handling code below
-				 */
-				trace_xfs_attr_set_iter_return(
-					attr->xattri_dela_state, args->dp);
-				return -EAGAIN;
-			} else if (error) {
-				return error;
-			}
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
-		} else {
-			error = xfs_attr_node_addname_find_attr(attr);
-			if (error)
-				return error;
+		return xfs_attr_leaf_addname(attr);
 
-			error = xfs_attr_node_addname(attr);
-			if (error)
-				return error;
-
-			/*
-			 * If addname was successful, and we dont need to alloc
-			 * or remove anymore blks, we're done.
-			 */
-			if (!args->rmtblkno &&
-			    !(args->op_flags & XFS_DA_OP_RENAME))
-				return 0;
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
-		}
-		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-					       args->dp);
-		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b141ef78c755..40f72db2449f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4132,6 +4132,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
 	TP_ARGS(das, ip))
 DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
-- 
2.25.1

