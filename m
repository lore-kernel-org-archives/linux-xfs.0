Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D779C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbiCWVJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344858AbiCWVJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:09:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6A28CDB5
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYRLM007704
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=jyBWlsAAoUdphRnovHJ1XpDiH45isDpg/XR9NlNv5BA=;
 b=uYaN9+ZoiSdKr9tv4yhP1uonlURFqJ7S39UWF+gTeUATF5TvXqvsAUPwFHvm05tLwMQa
 oDsZa5t69NZJC2E5xnYT+S+XsLK8Le1n2vSNDXUJVZuWEB7N6dbWMUZPGkE4xjLYehQJ
 1fcxylGyMYHMfY2dtq5AGpJ/UPlRjNSJ9QY77KvtosONCqWov6/nwCuaRcwEYQ6Kimam
 uhVFh70ixu1kAw/OMWVPSId6pQ3EcJ7zuH0OJpq9gr2i0Hug1lr6mxn7mjujH7/UFSLe
 V9MMdNurVwQ5izBwnjgILwTtKO7uZhcUFPgvLSZMmh4ybjUngjxQBofJJyYhFe4iz7el rg== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qtawtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6LdE082870
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3ew578y1wr-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayhjxiUDvHUP7vkRDxaqzp7iqvertQj3tqBnjfFXBrF4hsubOR0Nv37kF+oRQuZ++MWj8FfCGFctLB9DaxVPiu1FgyW7OC/oBH91HGSllXinQlXgPiLWDfl2No/ooi+5vBA6CX4roFRmTxHIfZNPI1LTogWIy80zY45UmSdQBYWuvzLLbCLoGxXFa9lU/T2ieYL0ULa9P4p2Mh0nMw9DmWvkJHwvOEHECorumxmqkt+odhnI7tnZpI0uE+VLsdTwW0qJb84YnLXqkuN6cx7kMGepXxxoz/3AlY3ACKU4GaMQRyXx0CGr0MMfTaGns/zDE5R1QIKo3HUixMnzW323Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jyBWlsAAoUdphRnovHJ1XpDiH45isDpg/XR9NlNv5BA=;
 b=Mxk4faPtYS9amlQso6WsZZCny9bziUT6S6tr3Uy9EcMpCbQ01a3yIyMa5DNxyjnUKkxbV+aBBFLlugJDwpvwMyWFwdMeAMZvbwBDC0bGtPVj54e5OPVAQ8hq9lnVc8FqQQwOUURTtNrvYaE6F7yO+L6X4mqVFIMpw+jw68WylPiWvL/iD8U/IiikA4xN6eYyALaV3K6Aw1zrPMn5wvVdiGWr1+CsMZ4NuSVbUImLRH71FvDr/si6uJbhHieTOmNGLuKEwbr4egxrxLXwOzR1+0SwuFb+0Q2iUzPG7K7UZf/f3zmyaSqAFWy07XkxJnYOpQuqnjlA3L/cJJ0r++uheg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyBWlsAAoUdphRnovHJ1XpDiH45isDpg/XR9NlNv5BA=;
 b=jtpDbS1yiJRKKrop+sfN2TeRsAT3kHz6iEq7Mvload1J6XYKPPF1lDBiuXgPBUhobFQ51mZbJiyPojquyjPTaIzNI0s/5WSIC4ytFR+ONtQFHEx4hNgt/qP05X8ZUwI+lsISanDYCLuzXpMThcyWY+lkx6lmuBfnJpNbDAzRXeg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 21:07:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 07/15] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Wed, 23 Mar 2022 14:07:07 -0700
Message-Id: <20220323210715.201009-8-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6e53661e-54de-4673-c431-08da0d11215a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4744F293706F32F089CF575295189@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 46jkzuFnUngQGirI0GpgVk2KFMm4tVGTh54+FRQzi3YyV3q+iI374TWTF3Yk8xX+huJEexPpDzibB1eVwywrdUr4NHvd8ZyxpXac8B7CN2NlQAakbY9f4avmNJvnaAwAwf/FC9Rdx0VOxjqU/pNSeQq8VDCmIPxp7deYtfuuuHUGX2NjZs3CJGfqaa22BalY+tjM116JbC6bEXWjtHIAZYl/PKLaEMxSgJeZQ5JJY6/yp+OkTMhywVIXTUIWZ2tEYs96Euls2tsMXuIGiGNzvgfyQiDGZE+TgG+KgquX+3YVUXByU7GajauyqaICRh/E+xGSdCrwAhHStmEjub/9ubSxfuirZdpmEosEKH3DRuFBTBP1WYCZKtBwele/LJlA4w+xsLOSonlNCgReevHUFi2I7sl7kI17oXP7BnbOsV7+t4BLJF/XO24lE/2A0ll0CYi7qzzfVcR6h/naz//62OZxQOokLB+KOi5gy2G7GAKzaIKVkNmnZhOgBeO3jf1BeZU0s0HRSk6VlQEGJobB5EzpUrNf5S2Sjh8Girzh/uDWhNovhdhw14EplK2eejyrQRRI99pRlWJQMLDdifOHfqHwZ6h5jkN/nvPaz0SEnPo1aLqwmdnJTEy6yhFsW7RlZvGmRwcletVGd39JbsD/7viS2T1bvqLux6nWChMHPb6PRU9SGDXYFHiCMu+iV/qt9zLG7UflnhhWH6jZKOfcFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(44832011)(2906002)(508600001)(26005)(186003)(36756003)(38100700002)(83380400001)(6506007)(38350700002)(6486002)(52116002)(86362001)(6512007)(5660300002)(66946007)(8676002)(66476007)(66556008)(8936002)(6916009)(316002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W2gsPustFihw1fZ2464+vS6cp/ShNgmX/ypcHVyya96CcNLLyGg3Fu2kipaW?=
 =?us-ascii?Q?vgD2M2YdpYlo5MsoFVfm/D89eFdQ4785/ZrtBkzjepqsFJU/lgx/MZqGOssZ?=
 =?us-ascii?Q?hWyMVEX1Ga2198wQ2bAymRyyPdZSJcjnQ26U1lxdKX42f5u3szclVBtKvu58?=
 =?us-ascii?Q?kiAuZJCcy4iFheJUWafSLTzULE9uCB6h/6mT9ZIH18FzlcKNyC1R0Ab6Knx9?=
 =?us-ascii?Q?rwhW2u6JxhNzZmCpl5PtXgK6ykNn+9jLtK6OwoWjXNV1Rel0kGse+V/tyLgY?=
 =?us-ascii?Q?ikdlNF7+hX68usedA3GoNTk2rNV8XBs/gkEVL92BEYx3Dc0VOf1ncOPwVn8a?=
 =?us-ascii?Q?fBpbazPxHR9sYNztKVCGEjbZOvsNg3QagffZtrYSbaRMWafs1gkguJPMbX2k?=
 =?us-ascii?Q?J4zUgqsgzNT+Fj08yTJdrbnwpalgDTIg9lFaDOE/oTDOEJ09RUdX87j/nVsU?=
 =?us-ascii?Q?ZG0IGA/Xs9D2DNg5IhPN4MMuqB97XgrFsvdm45YFNlQ0mkofGt9P4Ua/z1+e?=
 =?us-ascii?Q?gXuaa9O9AL8RBJJOlqQqsyZDVjuaCpLXPX4Kcqj1AFQCQkCMHiqY6zI9GxWC?=
 =?us-ascii?Q?nrukhpjUEuXnj478jICUdGpQtdmE8/oegCCk2KgcCpB5YHNnEKV9ybamyRw2?=
 =?us-ascii?Q?uTTPwRQGHnB3gKk8m0lSl0OWLKZVuD37IMzUNrZvyNBih//VmsPVAXpFCMA/?=
 =?us-ascii?Q?AIBDvChC6q/FRP71uabadZDk2cE/S7+WWeesZINbMC52JpLuEB+c/gtpmZPx?=
 =?us-ascii?Q?k7AtqZZpT4RjRW3b/yuljKIK1Dbz2XsRH0NwFKQlBC4Ub5wSc0RCthxqCLS7?=
 =?us-ascii?Q?51T27n1PjzMTOknPLy9OPGYhyoCOHxG4s22yp2RETTC3Bsx5B6IqK8GDViXn?=
 =?us-ascii?Q?TYzFrQG8ZvHGgw9Conbqiv684JMPBG1sJMAW9e7FAAsMDe/qgQxR1G2E4fyX?=
 =?us-ascii?Q?/9Xa+pulvG7+lXyxsJ41pRhQ3BN1nlY31K6+/JKKtedbM8o4IfFuRgvXH57g?=
 =?us-ascii?Q?7nC/7Tzdaldu5LIZph1nkhDBu+Ruw3I5yAiwyxLW7LFNtL6xoF5mj+OkuoKB?=
 =?us-ascii?Q?3KiAnEeYkN1SdYyW0N0KRHQPDPNJjOJnZLwTxzbaAsFrQkgZrfhrFX4hoyNC?=
 =?us-ascii?Q?7Km0HjPg1gGdFSGQVDm+vomGdBoW8cuJGQrEZkne2AODt01rpij86iJtOB14?=
 =?us-ascii?Q?tmbBzFRfyAuLgPEaka5otfb2rdZLy5rx2hOJZtXJIfhdFYsOnULHkEmBfYQo?=
 =?us-ascii?Q?O0Hdx59ve3umL/wJLYhDCk0QObpypWzMxgYaBfFKTOq2QwKfSXd0SxsRtO4D?=
 =?us-ascii?Q?EnH7DmJXrekKxLOlSgFLvFfuoFWla71AL4RhddRbvBaw5eoxbiC5Y7HW7xbb?=
 =?us-ascii?Q?Y5EYhw8M5FBBNqP39vP9f1fkdfMV6po5xrtfHD8q9b3MhIjSw88XeCF3Cx0f?=
 =?us-ascii?Q?3DTYp0ZcsIDJZlhyH48fpqcS6F3W4lpnQCEx30PN4TNWcKZENn7aiQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e53661e-54de-4673-c431-08da0d11215a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:25.2642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GCrGN2N92LvPAFZa5/gciZ1l27gaXHeknEiYDXCpm9fLDXXFJLwnC0bgoyGOgndSy6CwMl1z7UIe8vGvTFa4QiqTI3rVcCFEsdFjxMyfgac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: y0YMle53bEDF21dBKhZEE_KlMo15qeRh
X-Proofpoint-ORIG-GUID: y0YMle53bEDF21dBKhZEE_KlMo15qeRh
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
index 0b346162d851..09281f064019 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3992,3 +3992,44 @@ xlog_drop_incompat_feat(
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

