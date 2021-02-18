Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C824FC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7985F64EB9
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhBRSsM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbhBRQzU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:55:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGnmL8069815
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=TOwoeObWJ9z2ho1E/rIafwpVLwYdfNvTldIK5IKUT9g=;
 b=Cmyj59KqbRcpFYV/4b93u2rGPUV1xJlzmRgm9l/L9X/lXsZ6GwsPvam/7+fvkDS2i0o0
 AheHwXmtW4YTMxRCMai7XH0XTo5SfNjRjo8ZS2plAFClznBT5Ych96V+coq8EGmcHi6o
 aVfBoLdH2tBEGBszBxvK99IjV1jyPxED0H2v6/mmRBnF6b8eehbJXo5wG8q3dLocmuq/
 kmEwEJa1RZEqEc8VaCf6FMLQLLRwB1PrkE3uypkJt5ZO4KvJ/gXpW4kQoVka6icAY0Id
 W7On/3HOdAA8twmYrijEoQiKNIdhOX1GFHHX9Zfeir3g76e20wW7e4ULzx7+GtWeUOM0 qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9ae4qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoALK119728
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 36prq0qeh7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOlfyB3qria9jqQ9ScaXmSVejFf+T6VCSAuHuVBRWqUcZG+tUL8oWy539fHG2HwnO/bJe2bgWZiBxx78eGX5llqfunceBt6rbfk2hVCs3qsFALTJ1oqwpXqQ5mNv1+fRrdXkcjdCIHyvvOiV7/Z5zvA1D15PnJaGVGGLduD1OAfhFnMeUPH7RevacxpGd4HKEnmSSjB25lFO8ADkGzptUoi14Rgw1SZBPUsmAm3BK+kvZd4M0I2jRJfKuLU/oW30VgBB0GnEjreO3UFVHQBUAF4/lxMzY9aaFOMBV2lhDy1sr8AxKB55IfBC2gFKfiPO0jVnxr/cgo3ZelAGv2zHrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOwoeObWJ9z2ho1E/rIafwpVLwYdfNvTldIK5IKUT9g=;
 b=PY/xTcdcsdPtxbxzSe2NTNab+QbN8+pk9POfOQmc61JeRSH90xm9vM5Mj+mmYBm7J7znEaULOSUuL5R4cwbJ7+4yhgRw/55D62A4Y2WQuJ6kHX5l3lp0n1U/h+0OscBGaMz4lmvG0xNZYyf0UGVenrOVXflCHIRMiu4yVFsuJPwx1aYu0FzA5pc2ANMy1FaYMBarDrlyLhWDUnmNjOUQWwO+Y37g6+bG6G3YqNtrZM8pvVoQi8yWU4b9MJ235xo/wioogwknH/Y8mk7gY7Zho4H0vwgZGuND/CJrDaKGdP8pja2G5p1YYNhj5dKA7r89/V78dHODmGIw0dhjsY6j5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOwoeObWJ9z2ho1E/rIafwpVLwYdfNvTldIK5IKUT9g=;
 b=qkYHVMUdtgQjtLchsdnFVW7HZmGQklWU5qe5SSs67dp7sCZ9IO72Dc8naxGhgDhSwurx3gwnJO9vWEX/1ZL74+3FugBnmxnOO9g/LoGTPYyIGF1Zac7/FoH9kRVfELvQ/kF5pWD78NPS1spAP9cG9bBv+AdSDVUpmYW92O9EcSU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3605.namprd10.prod.outlook.com (2603:10b6:a03:129::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:54:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:13 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 19/22] xfs: Remove unused xfs_attr_*_args
Date:   Thu, 18 Feb 2021 09:53:45 -0700
Message-Id: <20210218165348.4754-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80ebc6e6-df20-4854-53ca-08d8d42dd110
X-MS-TrafficTypeDiagnostic: BYAPR10MB3605:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3605EA5025C62AD8722B1DE895859@BYAPR10MB3605.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9IdwGqUp6ZDAkPmYaTJId19jup49LTCNOhzW0ABzbmWYepcwiNWp3kiR2fV0tBkyvYncSyodgOwC+VfOHWpHLS7LPy47BbqYHb+3ZRU+xj6jVcznGj0nyG+TnOjtH81CwZ5mI41WCnO25YxhbyNZA3WYaw1TbkadDDQj9r8IYoloBt/b4JIVEmoAwT2kStzipW3qd8XaoqCplYOQv6kh+A4NDaNGoFwWrVHyUtFkzlupuCYKsXCB2yjjge5T9knnjYkFmFVTwBQvbJkt6dbYOrDP8Vcg5/QeKf7fIN0kKpr/b5LxoiNG2AYvwstIsXmPWmgghsZQYbgc3R9xI3lHCr8lL9CQqOxaq2S6SldjKKb0WtOijAbreIYJ1H3cEuZKlMnLFKRn7VQKefTj5f2ejfiMS0ENhCuX/zwAdfm+U96sOe+gXB367VPZ58/5ptOOp+ZVKq133kUSHVJXB8J4g0e3TZeGUMsFnJbLZBfeqO67w+DtXRZ/SjYGY47dC5HAK1m75i8Ds1RbWDMeReXevsBtIXFxNQdJyR/Z1sGx74+yAfW/lAJsqRVZTp4gbsrbHy9XtdQObEqsD3p3qma5lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(136003)(376002)(396003)(5660300002)(52116002)(8936002)(6916009)(69590400012)(1076003)(478600001)(956004)(6512007)(26005)(16526019)(6486002)(186003)(2906002)(6506007)(2616005)(36756003)(83380400001)(66946007)(86362001)(44832011)(6666004)(66476007)(66556008)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?x/nVBL7DJnvmkzBV6c1v4R4d/G3azZACeLDcGhf+xTwjFvfYLhHMgLByUokb?=
 =?us-ascii?Q?fh4Ji2379lumd/yZNo1lXqFi/+GSK0uR3gq/IO/8cUV94SaV1GYVLF/cbxpy?=
 =?us-ascii?Q?velRwWUwzioDo47tK3/Lphb0dJ3JIM5Nkng2hnw0LEBUPde+FsmRhBg+C/Kx?=
 =?us-ascii?Q?y3+ZwlNJPa3NUxoBBLILmOuhc8VRIV+rXFAC62ru4zj1ZIMyhAfLJ4n567iK?=
 =?us-ascii?Q?4a+9AzlmGznNXr6/IcNwohCiZZkPsLOSwW7JmukqhYeL2xAJ9V0uQniHOweK?=
 =?us-ascii?Q?OXzuOWKWcdCZzGTd7mQcuo6yiPbVKpvZyfV9vpccFtadgT3fZp+imS+OB+F4?=
 =?us-ascii?Q?mwS0gURqZSapngoxs7anXKCl7HPkt9TIeE/o0d3NUzVqMAFBwx22uz68HSPp?=
 =?us-ascii?Q?LUS3cj0F16sV7QiqnK2drYA6ECZ4eLRCXOjo8gBzkfVNw0cjuNay00c1IfYa?=
 =?us-ascii?Q?HUnJ3bJogffL/nnDJi92j3oYR7BZ1RFaKCQ1PW9QZ6wUmRpfI6svB/3MRYI3?=
 =?us-ascii?Q?NBYWI7sEVhMGPf9I0XetrAV7ZntzB/U9Ufy/w21/poeefVAdgqjTUHkutTP0?=
 =?us-ascii?Q?fC8O8tKvqTD1p6l8/GGmb6qSJNoouUNbWDnlTM5dmnltkLH7TPJrULqf8mHC?=
 =?us-ascii?Q?mo1AQ9bvp+EGBieI2ujAbnO5o0H9zomlmlxoE5TVLsxcv6GkgaD3OgCL1qi0?=
 =?us-ascii?Q?1Ier8qw51pYqXwv59wvIHl1Z1ltJikFuRVGx2v7FJtgr+7SYZibxM5pVRok0?=
 =?us-ascii?Q?xZGrJHCqvarm9C9CgTu2drIEG+2qFIhss2aPhkoJlXs1RBIRbavtNIUsd/Z/?=
 =?us-ascii?Q?ANdXGTnzLyUyv/g59Dul04886WSY6RNzGCgH05+0qZLnsgzPmHMEST3OwQNU?=
 =?us-ascii?Q?1qED10smowXzezU4+R45W8vNUD5sOWdDaykU7/QLr8kwjl4ZMt6vFoq8xvxt?=
 =?us-ascii?Q?spaKVljXK6a4f1eEl1EWzNVc1mDxmh20zuzrJ/l/l1OVs/IuyKW8Kolg3vbW?=
 =?us-ascii?Q?becez/PAi77xJIquSN6y3KssYGPlRDIjQ0nD3eQI4kizVM/ol/H5d75yzic5?=
 =?us-ascii?Q?qM93jAiTi0vqdaSJovaQDqQo4mRa+pEGYRoZDZYpext6rLJ7GIT98Ndy86cB?=
 =?us-ascii?Q?tVU7RgIBpgKnr4hr6LJL7jxskmN5Y3qNkbMgadKIqXE5p9Q1cp4VYLeQrcbr?=
 =?us-ascii?Q?qoMDZEnigr/BrZ37FBqCCr8XX9VNertvQ6ixkXzA3WXupGQgkxylaIXDv5r2?=
 =?us-ascii?Q?bvBvYIwJjr5eGuN+Q49mlIauTbffN/ldzYniTTeWIYgP1meoNSKinIVqDXd7?=
 =?us-ascii?Q?OO9DWNBeZDk8ZzrGt08pDMgC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ebc6e6-df20-4854-53ca-08d8d42dd110
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:12.0702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xI8ACv6IGc5E+Xy5YPtuMgqYVi+2nucP9VJbkAObrOgbxgJthcrWHt9K8V5WJ0RBhlKtyVX98V+DBnvOPZWPFr33WxI55yqXVdIu++raUkw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3605
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
since we only have one caller that passes dac->leaf_bp

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 97 +++--------------------------------------
 fs/xfs/libxfs/xfs_attr.h        | 10 ++---
 fs/xfs/libxfs/xfs_attr_remote.c |  1 -
 fs/xfs/xfs_attr_item.c          |  8 ++--
 4 files changed, 11 insertions(+), 105 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index cec861e..8b62447 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -63,8 +63,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-		      struct xfs_buf **leaf_bp);
 
 int
 xfs_inode_hasattr(
@@ -223,67 +221,13 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Checks to see if a delayed attribute transaction should be rolled.  If so,
- * also checks for a defer finish.  Transaction is finished and rolled as
- * needed, and returns true of false if the delayed operation should continue.
- */
-STATIC int
-xfs_attr_trans_roll(
-	struct xfs_delattr_context	*dac)
-{
-	struct xfs_da_args		*args = dac->da_args;
-	int				error;
-
-	if (dac->flags & XFS_DAC_DEFER_FINISH) {
-		/*
-		 * The caller wants us to finish all the deferred ops so that we
-		 * avoid pinning the log tail with a large number of deferred
-		 * ops.
-		 */
-		dac->flags &= ~XFS_DAC_DEFER_FINISH;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-	} else
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-
-	return error;
-}
-
-/*
- * Set the attribute specified in @args.
- */
-int
-xfs_attr_set_args(
-	struct xfs_da_args		*args)
-{
-	struct xfs_buf			*leaf_bp = NULL;
-	int				error = 0;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_set_iter(&dac, &leaf_bp);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-	} while (true);
-
-	return error;
-}
-
 STATIC int
 xfs_attr_set_fmt(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
+	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
 	int				error = 0;
 
 	/*
@@ -316,7 +260,6 @@ xfs_attr_set_fmt(
 	 * add.
 	 */
 	trace_xfs_attr_set_fmt_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -329,10 +272,10 @@ xfs_attr_set_fmt(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args              *args = dac->da_args;
+	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	struct xfs_da_state		*state = NULL;
@@ -344,7 +287,7 @@ xfs_attr_set_iter(
 	switch (dac->dela_state) {
 	case XFS_DAS_UNINIT:
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_set_fmt(dac, leaf_bp);
+			return xfs_attr_set_fmt(dac);
 
 		/*
 		 * After a shortform to leaf conversion, we need to hold the
@@ -381,7 +324,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -687,32 +629,6 @@ xfs_has_attr(
 
 /*
  * Remove the attribute specified in @args.
- */
-int
-xfs_attr_remove_args(
-	struct xfs_da_args	*args)
-{
-	int				error;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_remove_iter(&dac);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-
-	} while (true);
-
-	return error;
-}
-
-/*
- * Remove the attribute specified in @args.
  *
  * This function may return -EAGAIN to signal that the transaction needs to be
  * rolled.  Callers should continue calling this function until they receive a
@@ -1297,7 +1213,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1312,7 +1227,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1599,7 +1513,6 @@ xfs_attr_node_removename_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_node_removename_iter_return(
 					dac->dela_state, args->dp);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 4abf02c..f82c0b1 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -393,9 +393,8 @@ enum xfs_delattr_state {
 /*
  * Defines for xfs_delattr_context.flags
  */
-#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
-#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
-#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -452,11 +451,8 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-		      struct xfs_buf **leaf_bp);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index b6554a3..78bb552 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -762,7 +762,6 @@ xfs_attr_rmtval_remove(
 	 * by the parent
 	 */
 	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 8c8f72d..13b289b 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -291,7 +291,6 @@ int
 xfs_trans_attr(
 	struct xfs_delattr_context	*dac,
 	struct xfs_attrd_log_item	*attrdp,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -304,7 +303,7 @@ xfs_trans_attr(
 	switch (op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -428,8 +427,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_trans_attr(dac, done_item, &dac->leaf_bp,
-			       attr->xattri_op_flags);
+	error = xfs_trans_attr(dac, done_item, attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
@@ -625,7 +623,7 @@ xfs_attri_item_recover(
 	xfs_trans_ijoin(args.trans, ip, 0);
 
 	error = xfs_trans_attr(&attr.xattri_dac, done_item,
-			       &attr.xattri_dac.leaf_bp, attrp->alfi_op_flags);
+			       attrp->alfi_op_flags);
 	if (error == -EAGAIN) {
 		/*
 		 * There's more work to do, so make a new xfs_attr_item and add
-- 
2.7.4

