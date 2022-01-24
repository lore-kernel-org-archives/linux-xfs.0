Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A030C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240965AbiAXF1Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:25 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37550 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240948AbiAXF1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:23 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20NL5x5e010082
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=NgASYlGXeCI2OjdBzTPcOoAwcBW1hYgdU7d7rd86Q+g=;
 b=UQhD5DfEGEw9UM3yOUsHq2NOpj/nYjjtLePBtyx3kQlQGJ5NozT8Jw/GYdqCy/5dZhJI
 hMTJKVCkQoRvMZBUQWF7Q9/U1dFTacz8srtw4MyaI69Wcr/9MisNIryJ79ETm2gbapSI
 +PUgeoXDNlu0JKgOe5UUkj4VEmcpPBbW0XVybwOidSQzhMSH5o2PN12rR2tH5IKxgfIq
 N5It+4IpOYKt+PkhODultQOMBaRcP1DhjXQLnCGcWF9wVrTf2f6BB9Z7QJaFYnTyYSUa
 i3ZFYeOXd6vavIZ/ISNvqPhWEcyIjKbHA/OZiSbBZS4gKEFzYaxJBIz43jPacgXIeBEg PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dr8q3b6q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5QKJD012201
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 3drbcjr27k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZ0xiJITcKO46uU4H+0DmXF109luEmN0cwbQ/FQ/OArqjx+ILkvqhkFFtlzzBAhubxyz0aVqqanVYpWNBAS6X5aNJNvj5dkFU7T9rabUnLB0+ZeHsL/plJZAKHUkUB/P6sjZUCZtoFxstMPUQrod6F5TRSW784YTI5CqnMlatQPDDwlQpW2EuFnSMWNsS0eH00JlsGxS44Ahm4P8YfRuwaCDHTd4zg6o6Eis6mo+6T0PAIF392NSdrfewyCCUcQS1REt7hD6MgQzP9HsolXFg0CqCjCQh2VTmP/FLtzK+eI7TAn7+9B81RNHzF1eluDv6YCmmekAIIxiq6n6g7w/qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgASYlGXeCI2OjdBzTPcOoAwcBW1hYgdU7d7rd86Q+g=;
 b=G38XU56Ft4KtRn0fE4yklT0JYqOO/+vIV6vFEe8qDq6gS3R7VuFeSHKjGcnmF7xepCOvb55DgMv81Ch/LAzlqrHbcAyoUeq8TgSsrPzhpdVzyxmodjabf150lysMa/68xvz3CoQXd1ILp1Y+sfPR/0hCsSn+MYKktdTgozZBmKe+RTJ7VxIzXxtf2dXfbOKYdVzt5lhE4j+INGhCCiRoh/86Twmjw7cn27VML52sCDlTLKiS9blcm5jfQw5l2rbJPBPSE1LAFAJOLHLUpN6vxvwxr1MGEefJuCKNgNgDJ5MgsaRXZLLr1KOJ7ioyetI1C7sru959TTxGOx5aX1xi5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgASYlGXeCI2OjdBzTPcOoAwcBW1hYgdU7d7rd86Q+g=;
 b=jJFyN3yx3XV3LBFHjIZZVkDTiNWTnJleRocF7hI/G+Pg5kGtgtPGYCMEYyhxkHzgV6vnq52WrHe8ABTH46UQ+FTHmPumhn2PZn+MuoqeId9ofAY0A5v38nrTWIOzd4GeiEdqfmF33O3N1YpiGGhbJToQxEBu58+XFgQNm3gugs0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN8PR10MB3523.namprd10.prod.outlook.com (2603:10b6:408:ba::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Mon, 24 Jan
 2022 05:27:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:19 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 07/12] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Sun, 23 Jan 2022 22:27:03 -0700
Message-Id: <20220124052708.580016-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124052708.580016-1-allison.henderson@oracle.com>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5db50b39-f5ba-4bf4-7716-08d9defa2fe2
X-MS-TrafficTypeDiagnostic: BN8PR10MB3523:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB352374C8983153D88BD3DBDC955E9@BN8PR10MB3523.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:207;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +kPakJk4ZPIYrfG+xn4f7c5O7dqGjMPjUwvdf6OVg2aXUjfMo/gtcz88l3/l2Vko7GpqqnojrZ6KuYwKySpizVQTRaZRtZw/uOU/apcToRrQC12CshzshcxNfio7NKnMppYCUFDoJgVeAfLQxJq08X6md105xhBawpFpI4D9Sngmo01nFbWSQ+3Z+tXXLGcfatSsqYXPwrIsVNjU1RBZ2Y609m1oez4WBby9KjfegqCR1eWAKFw5Nr9B/EQDzo3N0aR2buckbCUhg60Dw0cojWRXIa6ol/H6QUJzfPs3Idi/SzzWeFg68Wkco1CroHwBI/o4qa3IkNRQmC9IWY1bLfO/lLu6/UAmuyJwz2RT8MSlH7gL21QNHlCaHMOTkoAUWMO7Jum0NQeblIsMtG6874uKbU1nZ1Fk7hASfKi7Xt5+6psEFu6HYJgCuS+TdKLIBEfPMa5qt637WYhJN95kYEZtrF1GI4IQaD5mHCRfBnvCofCJ6jv2OgGD68RB1wwCKRmncobVuKxkMC+wb6b8xjUEFk9yBIIJaoO+rWvMHyL4D2opyqfJbQjZWqasnk3uzq+EM3QiQdflwphz8zEp2nhAJ+F9aGr+mmzLHGMjatvJBtKb+1YjT8fAK4RzgpY4vUvvJ94v83E4nrTPNeo/5wfE211400K4dC4qDmK/UqrKJ8nOHp/2KVHdgS7UDzO1/0BQ5ezpf3WcpWx2ndbe7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(83380400001)(2906002)(26005)(8676002)(86362001)(2616005)(186003)(52116002)(6506007)(44832011)(36756003)(508600001)(316002)(6486002)(6916009)(1076003)(5660300002)(66476007)(8936002)(66946007)(6666004)(66556008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9/Fcho4bNjai0LSCCGXJvYgPUmlsLPDC52V4LgKS6hNDeG0ER1qag5OHJRXc?=
 =?us-ascii?Q?Q+JbDqWXVUjktmODS7WHtcPc2BLJ1Z04JM/HWWQu0Ou0jchvcRaC1nw094aL?=
 =?us-ascii?Q?L+G1+i4T1zicF6KNNjznLtcMn3mtbKMc/8UwtDW95HCBMg/a+OL2t8tbgYIH?=
 =?us-ascii?Q?Rlob88FPx24uVK0ZdFzsrb5bPPkEK0Q/NVoUyCZ3R6+meNkzQ4cqmUfqrPUA?=
 =?us-ascii?Q?Jqz0OxpLgIt+xW5wqQs+dsmxr9km/xW0grjBXrxnVz36OpFAS0FGKK+NJEDl?=
 =?us-ascii?Q?oJ6LDyLngv+YAmuBB69n5RuFts4zSueNZDgk5CRowhy7ZjNLLJoHcOwkmYv0?=
 =?us-ascii?Q?drFsmH4N1TnmPCL+KEII+fSAFAEP3iaO4I79nRkXYMlPjsc76We1Sdyu3Csx?=
 =?us-ascii?Q?KDK3eIrF3OmAq8I0sqSItHq75YyJURTZ1dOxGf2Gg+YiIEJAQbKYr7DzJbEj?=
 =?us-ascii?Q?4f61jKpiBZQDCuLeu9zubNC1+rIR3LmWTPLAvXRo4gl6rh+qLl7sOVjwgOUF?=
 =?us-ascii?Q?OyPo22UFrIE4K2SxQGEKOrfLblyUV9ylw/8mHpsWlFVhjK2aPjGtBW6EEiK9?=
 =?us-ascii?Q?xRnZ1fzDGsoxk1I7TTNid/ceG53CHvu7+JRI0MkNsUPvN39kFi/d2bTJwntP?=
 =?us-ascii?Q?ALO8pTqLs8dwthMYVNTATpkZ2hgimDNpKdmF/yt4psu/r8h7uAk6ZukMtHBO?=
 =?us-ascii?Q?QrsQE6j8JhVQ6zyboSG9LbxgxGL0FGZK48+OuZL7ND25D8crPCSknovRpwdv?=
 =?us-ascii?Q?l/+D8oSJibNZrX2DRJ/PGhv4dyfCXy44FZKCeKA26yz//NZsswKwqkbziWG6?=
 =?us-ascii?Q?KOShJggEDBWZXqA8pVz0Bu53LhvoABBQS5TOid8XY6OiIb31ndiLTwBkE0CX?=
 =?us-ascii?Q?UEqtdMKdDERLC4IG1ydJQDaf4qsTvW4UuMjzthhwHXhV+XJXOLFgxgB+2VPa?=
 =?us-ascii?Q?45x4ZxIjKK1ekKwqsEKbXA8BsKiBRCbFUy7IDbj5dxv5aR4eJKG8Kc+HgEjj?=
 =?us-ascii?Q?/GVO1U+wSqfSdrfDKgyqikr+c1fGNWIdKT9ToBSKP+02AggKspx98edidtc/?=
 =?us-ascii?Q?rUblkSfOcRgJunG4w79Og8KxbLfe4PBdXyAm33e9iT2MQOitiHP5fA2GcoFY?=
 =?us-ascii?Q?NoaGaYQgxus119u8GbOV4sWAV3TqdJMDT/cQJXEqVX8qo+pSguT+89NoMp4r?=
 =?us-ascii?Q?TZqhYPq3+bSjSWUmCW8sg/u/OcZHdWYyMj6IzUkKkv/WVbRCx5armcToR7jw?=
 =?us-ascii?Q?pe4FBWaptgx+SnLplpPFhWTcOVM0yaEp/nj+ZLFAGBs2MJ+/17sZp9kw277d?=
 =?us-ascii?Q?+AeMSiTvL7R1FccDU2j6Z3dkx/wTHwhsdjzAR6t/0InTPcSPRbuc8qcF8CBH?=
 =?us-ascii?Q?kPrIel8b60tTOWr63IGRB4AiVstXzjMWpjuvH4f7OLc1qKCNpr8PaM9AT3eF?=
 =?us-ascii?Q?vQOwuSmsgyzyA5f4Y0Xcr1WXrlWw4F8duL2wfDD5ReVtk4lYAdkweDrP3694?=
 =?us-ascii?Q?R2pBnV5DepTy62hulnGdWpO+vFBrMNfpMFTRSlIPUf44WM/vRC5RXL9frwkB?=
 =?us-ascii?Q?z2yr2BncJyKmchULGlpdX8iYs6Yeifn0TS0fUgKlJ9ZcAvh68Rkb1C+wH8QO?=
 =?us-ascii?Q?pcE5qjfQjOBBGyLMaa3OSZKWKwSowiBGKNH45YJoCytal6d1cURJpYNSsdVF?=
 =?us-ascii?Q?V4LmTg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db50b39-f5ba-4bf4-7716-08d9defa2fe2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:17.7602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K74YttpV0AF3als1QLAkgJ27scM7y/m8keTPTdJi4bhFVDxqpm9+DxT5LiGouWlVdoH92lpYlNbudAaTx8PH/7e80VG4WruLQJateY1y/vw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3523
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240036
X-Proofpoint-ORIG-GUID: siifS7h8mMr5dV1bXlSPkjjVJnJPPGXg
X-Proofpoint-GUID: siifS7h8mMr5dV1bXlSPkjjVJnJPPGXg
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

