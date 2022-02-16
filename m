Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04417C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245524AbiBPBhn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245516AbiBPBhl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:41 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D96C19C30
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:30 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMpMG0008456
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=NgASYlGXeCI2OjdBzTPcOoAwcBW1hYgdU7d7rd86Q+g=;
 b=Fhysm06tUCuCPkEjNFIWasoXzW4oLtMcKGAgDwPlxcUVhlOWaog4IpN9lryqkQp05jyL
 zyJk/nF/W0RgtYb6K9VWJZ6a2XSGDLG1vg0cYH/X4ovSre8Lss0hXnCTgLqpPDl6onnk
 FaFSmzF0OLIx36BpnfEVpjZugkKCLtf4CRY/Wkd8e02YUUK1MZEo8CMyDk2euSKx1BJh
 wkab7SJ5Y4CFhm9zYH5Hzc07CrXEK+RongG4OJxUO23PoKW3dZEMHbE0X6CdBh5ngpPt
 IKfhgfPSF2VCeWbhiTkmxm5v7zVN4wlawnWJjUnNwevJQIrRKujYLNRTAwvXoMm9fWz2 mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nb3g7a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1UZxL165528
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 3e8n4tuxvp-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSwNc7ncXHUuLLikRxUMbqwJZ4eWtMryHJOF0sdNHu6W7BGe+zMwewnXm5D5EYEecfY5MWY4457PsbylY3qddFox9VlqPHYH6NxBPoxwQYkcZ5Fvwova4auEh5oImC3PvbGN8xumTtZ5yb7QGpHylqVH907OOjxFo0ZlRn5vmjctsUYmBNtL9GOcQLr53YpvBP0wtSUbxIta8Xcc/MJnnfOUSEeYMPrGhY6KOO9pMBew4ge4r7cIjx9MRUSfCZj+lm7IOaHplKxt1qxZgXgSXTle+qPOW02CxAjAd6RTHXFg7zRzwq0SDJFjP3AZHN+11bHN+Frliqh2LYBG5T9voA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgASYlGXeCI2OjdBzTPcOoAwcBW1hYgdU7d7rd86Q+g=;
 b=YmO0zqIZFF3mYbNOVaE0x5RbjpOabbzrloMYm6Cr60/6orszzP/+zPhb6G4v3dMQLy4PZA2Kxj/s69GQ6ruPi0XiUSFntkk9TursV9LR07HkyVTI+4KtWgoCaC7kc13+3cZgYAaQ5L18paYz7cUnFXPHsv4UvQgEqqS/w46DxvhHXYPz7a3D4t1X6V7qHcDQ+fHotAnNd/hhjZp/csqLrC4qMlyUG9HPsXW1y52S4RbQhAG8HlkGN5vKgFrvOgWkYf6zcGNcv/Thv7jf7XS3p/A6kKD3NtGJrqsxGoy6mZ+X2ufeCubKTGECNbBxZHYyNxmW5nTjJpAO8+1jcn3X6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgASYlGXeCI2OjdBzTPcOoAwcBW1hYgdU7d7rd86Q+g=;
 b=OK779/03Js5psCybUZ0MHM+C7m4h1emipvBRaNX0t595N+echPiLLuHsqKKSrUF9wPO6WCsAF4pASRYclDPA8C+FZK4nKuXZQqX4P/c8B65PbkOESxO5v5zCwY13eEUOi84NulZ1Uz0KzTiHrmKBmKXtdYj/bg65cV7FOF5BOpk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB2802.namprd10.prod.outlook.com (2603:10b6:208:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 01:37:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 07/15] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Tue, 15 Feb 2022 18:37:05 -0700
Message-Id: <20220216013713.1191082-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216013713.1191082-1-allison.henderson@oracle.com>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6051c612-695e-435f-1bf5-08d9f0ece0d8
X-MS-TrafficTypeDiagnostic: BL0PR10MB2802:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2802B298516B8549A4E0E05995359@BL0PR10MB2802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:207;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qNVna252lHki57+P4rpKtQG+v0rwdu/eVcQHg8ee1xhFoaWvi0XAGnfhP/p9bKPRNA2209DuPSsF7k+T44eQVOxymVkOT5Jv87+fMcmcqIiQoH28QGl7pDWi0BaZgU2Y4Wfwnzur71rfdFHV+ThuudAb9vAbqavkl8Xc1FwJqBRXXkY7w8tXdwY16GL/c75AeB7XFrfKEh461mdl6VCFBQqZ3GRxWBkdB15KhqsuKV8EZXuRU7lonweILTqE9Xtm3TsEt8ZlDuxYsW9cgrv5vNI0AA0nAOmtTsBOHgE9L1dzrLLiSNOs/O6J5c/gBadD9gxt/6nwv6b7Q/CPn9x/EVPewlnD89pFTEt+/xo+ouKkBEny4nygfg0Y1wDgbVf7ZLNmwg+eL6W0VfV4DaKZJjIYlFeUjdnNvKSf2wjsuQ7MFjrDx6aTsGxRW+1UcWW0/JFnvv4p0dZqkwvTGyBMWfmM1Ys8WbDJLDM4zAuu740lSlYU/itglRDwmGliBVCHYOu7k7jqn3Us6JYagUQOrUFfrHlUS0MStK5fizyU3tGSrcn5ca5xgVmYE4WHRoFLowxf8+nSFGQKLQbwSelnhzvudc49aBe5ravvSsUZT3daCGTUXmGFLkzJ+64tf1Ip7R1oI5wAF1nT41OovamLL4Oku02df0xcgd2x73s51Rg18aCWzJhtVVB5n+vN5c1OZueGBSTFb/Ms9alWD8UpbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(26005)(1076003)(6512007)(508600001)(2616005)(6666004)(66946007)(5660300002)(44832011)(38350700002)(38100700002)(6916009)(6486002)(66476007)(52116002)(36756003)(316002)(8936002)(86362001)(2906002)(8676002)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jBY5YZiOhQfsHN3BvsCoUDAhVajL4Rim8Q7tfTGbBU1mBJRGll96X251Amt8?=
 =?us-ascii?Q?H/ElsdNJOu7YfuK6fGmFCLn+RklxTP+TCpsh2tUM38gr7wPpEWrBazI8Xz5p?=
 =?us-ascii?Q?fndW6kY/ptL31ztoU0lPTNzHGq/9Wun8GX2wSF97Rk1sowwnQZmQ+DpHfTNd?=
 =?us-ascii?Q?Vos+FWM26lpNPZfMUcSFKOY9tu+KjLzvtitCPAQ957CUkNkA90zlP9OHqoYd?=
 =?us-ascii?Q?qmcLk+s9hxtcxIkptPit4LCvbyCy3cixKebQLVpKppj+9x+Kz8zlhprvP1pj?=
 =?us-ascii?Q?dSLOZJS3K2aSuIzbmxqk74eGDDsonl9r1YTs7dHlXcB+0+mJOo8tU22/IIv2?=
 =?us-ascii?Q?5371lxOZDLIcCgZW3rWifYpDIpwuXPVZoL3Had7dFxlN+tItRsXveTYvqtD3?=
 =?us-ascii?Q?DSwj2ZLWLiAAyobir9nkeeIBUeJiDUUQqmBGYEA1JQmFUYTzWOILmIMtabXU?=
 =?us-ascii?Q?i5nzE00OGG1qp6wa/0cyJh4hAMZiU1h+2YnSUqHMw3eczShWZ44QYGKImuDQ?=
 =?us-ascii?Q?Axfr80/ZYXLsoLfS2S35cgnptUX3td4VjG9MnrA8IpvxbwZ2wldI1D5rn3lH?=
 =?us-ascii?Q?cmncj8FgYvWHeer+I7NZ6HPVWbjlfFG0xswj4jVq0tXFjBx2/0yH0UQR5iao?=
 =?us-ascii?Q?u9nm+I2Xtm0uLhDmSNbkHXdRlLvmcigXEdXvYWEXGt7lo1Lm+zyK68bJWnQ6?=
 =?us-ascii?Q?tsJBaIBXJVqhk+2pnL6D0aDR2kBrelPqoDFhPsGGDeifqK6FdpjXzLotbfC5?=
 =?us-ascii?Q?iGd7lmNBgjymSjYStd1ESJwioxiQOAvK/H8X7cVoB4vfzqW9aHTmJ2XMwJNi?=
 =?us-ascii?Q?gdQxHZOXtzFUnPFm7upJrbCbKGMdutj0vZjkqurfGr53h60Gq0QqDe8a4xPh?=
 =?us-ascii?Q?pAMaVQGcZ4qpNT/gIak38GqCdagj3o8Pxcg9Zz4+MNgIvVk1UjRnyaLjAckC?=
 =?us-ascii?Q?4MTlBBEpPY1iOhjrX5nByNjkShPMBmHjlsgLTTkoN3IhuWmhOUTcXIEY0UnE?=
 =?us-ascii?Q?Y04oW1+lbR+saZ/ar9rpr4+4uhZrpAPYye0btq9OVTHqAJosksN6zXJyEbJp?=
 =?us-ascii?Q?7vddo6bK8Zq6TWzS5CMd30FHlfvSg5t4Y6QGJ12GeTA4c3DsnoRLAH1b5CWv?=
 =?us-ascii?Q?4evMMp/JlCQjd3er/9ft4Sdtz1D1bP5ZMmYu1Df0Q9T7VvQ92bBHrZNTwJyO?=
 =?us-ascii?Q?g0Amt2C7pGEJgCFbyvnFNRSY/iUOCHskjKB9ZKpsekVhjIYVBJfELdpZBZ+/?=
 =?us-ascii?Q?KBtXWITewBEzmlrWhaiLoQeNKwP82IKw6XgKO+W2la9gBOzwgsy6IfzoKMht?=
 =?us-ascii?Q?NaPqNo1Q6L3bjIRrhh8nKjQOomL6aD3UqgDCbYBBAQEaN5ZugGc1rTmVEGkx?=
 =?us-ascii?Q?N0VBS2G2IsA3+trjbdx3md79AXcm2XzWM4wlmQfmDL4dgfcF/GvJi1EIXG4n?=
 =?us-ascii?Q?5ntXeXU1pUl18pm7RHAYeyRnWGOnimIf1T+jaqLYVWcsu2IHZioc3/jc7Q4U?=
 =?us-ascii?Q?UU6VgBxxnvQ+TwpsbDmXQbDeO7WQoJxPyR/nfzXEeUdbDYb5dK1dwQEzV1fQ?=
 =?us-ascii?Q?P6wgeye0XzsRucEzh26DXrup8fZMImkGGN4qWO0CLCMTIJQxNEEweX/ZqMF0?=
 =?us-ascii?Q?Tn2jnLnBvBVP5W+0UAj+iUSDzM3C65r4JizaWEmeYgJFMMoRlS6eEu5YYCV5?=
 =?us-ascii?Q?amM4zA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6051c612-695e-435f-1bf5-08d9f0ece0d8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:22.6405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a6j0K95TIvleZq+x7dQtnyd5NQRSXTVj01g1uRX8su/vGMv9TJF/GAZ0my+yCH5YDZZTiX0TBOwEGqPvKc6781fpI+8rdcFCUGsY+PUMiOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2802
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-GUID: 63mNVoU1r91omqzdOaCv_fvKtoKkVR2Z
X-Proofpoint-ORIG-GUID: 63mNVoU1r91omqzdOaCv_fvKtoKkVR2Z
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These routines set up and queue a new deferred attribute operations.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_attr.h |  2 ++
 fs/xfs/xfs_log.c         | 41 +++++++++++++++++++++++
 fs/xfs/xfs_log.h         |  1 +
 4 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index da257ad22f1f..848c19b34809 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -25,6 +25,8 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
+#include "xfs_attr.h"
+#include "xfs_log.h"
 
 struct kmem_cache		*xfs_attri_cache;
 struct kmem_cache		*xfs_attrd_cache;
@@ -729,6 +731,7 @@ xfs_attr_set(
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
+	int			delayed = xfs_has_larp(mp);
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
@@ -785,13 +788,19 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
+	if (delayed) {
+		error = xfs_attr_use_log_assist(mp);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
-		return error;
+		goto drop_incompat;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
@@ -809,9 +818,10 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		error = xfs_attr_set_deferred(args);
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -819,7 +829,7 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_remove_deferred(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -841,6 +851,9 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+drop_incompat:
+	if (delayed)
+		xlog_drop_incompat_feat(mp->m_log);
 	return error;
 
 out_trans_cancel:
@@ -883,6 +896,58 @@ xfs_attrd_destroy_cache(void)
 	xfs_attrd_cache = NULL;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_da_args	*args,
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+
+	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new->xattri_op_flags = op_flags;
+	new->xattri_dac.da_args = args;
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_attr_item	*new;
+	int			error;
+
+	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 80b6f28b0d1a..b52156ad8e6e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -525,6 +525,8 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_da_args *args);
+int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 extern struct kmem_cache	*xfs_attri_cache;
 extern struct kmem_cache	*xfs_attrd_cache;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8ba8563114b9..fdfafc7df1dc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3993,3 +3993,44 @@ xlog_drop_incompat_feat(
 {
 	up_read(&log->l_incompat_users);
 }
+
+/*
+ * Get permission to use log-assisted atomic exchange of file extents.
+ *
+ * Callers must not be running any transactions or hold any inode locks, and
+ * they must release the permission by calling xlog_drop_incompat_feat
+ * when they're done.
+ */
+int
+xfs_attr_use_log_assist(
+	struct xfs_mount	*mp)
+{
+	int			error = 0;
+
+	/*
+	 * Protect ourselves from an idle log clearing the logged xattrs log
+	 * incompat feature bit.
+	 */
+	xlog_use_incompat_feat(mp->m_log);
+
+	/*
+	 * If log-assisted xattrs are already enabled, the caller can use the
+	 * log assisted swap functions with the log-incompat reference we got.
+	 */
+	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return 0;
+
+	/* Enable log-assisted xattrs. */
+	error = xfs_add_incompat_log_feature(mp,
+			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
+	if (error)
+		goto drop_incompat;
+
+	xfs_warn_once(mp,
+"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
+
+	return 0;
+drop_incompat:
+	xlog_drop_incompat_feat(mp->m_log);
+	return error;
+}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index fd945eb66c32..053dad8d11a9 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -155,5 +155,6 @@ bool	  xlog_force_shutdown(struct xlog *log, int shutdown_flags);
 
 void xlog_use_incompat_feat(struct xlog *log);
 void xlog_drop_incompat_feat(struct xlog *log);
+int xfs_attr_use_log_assist(struct xfs_mount *mp);
 
 #endif	/* __XFS_LOG_H__ */
-- 
2.25.1

