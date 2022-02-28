Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A32C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiB1TxL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiB1Twn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1057CA71F
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:52:01 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJIAt010136
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=NgASYlGXeCI2OjdBzTPcOoAwcBW1hYgdU7d7rd86Q+g=;
 b=Mg/fNVMN/A9qvgRJ5pZz9zMBSqum+Tbkq7eDkf3BYL2rdEtO97x57YxAgrEt69GnD648
 1yzElGTKVACYiBkIYEMGLzgnNGx+ZEOILagmLd2YwbepnEeiBDa4pzOHR1BLuBrlluD2
 Lpjg9wXgR9UgoJaQo97YEul7nLAWE92IhRNAgv8epzEGWwzlsvK5NSjkdlaPWFlXiD9C
 0O6dne2t3YTMG9BrUzef2ZYcy0E84p6S0FD1D8gHvv0f65Fgp8sCNqo6gKotCNPyJOtK
 d4tFSgOelAtH3cUCyeNRTWw4L2PFCT7nGtDS1UVPzypwNUIJLUjVlf8WCq3fwxe+abtH Lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k40pqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJkltn076550
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3efc13e3fr-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYb0mJJc04e19qqTFsoJX2g/0+/HxO/qtYlThpzUgxYu8+jZynjeQHbUsAot1WqgxoAIvbEjTNUYdUZBNqqHNCu9JE2hko/JgGPaaHJSmMrTPr7OFmHXcR35HrP+zYHasepjii2ZpvS+Bjvvvf9TZ+zqvPah0f4t8e+B0/Lebf2iH8/N6U0uWZHcl+Jo0Q+WYl28W7ly2p77FNju3ecOF/gyNWRuBqYxUiU/tZxIEruY4dgldOXFiqDiwlP79rKJIccFY1kxtmuO7t+SjrhpmYcn4IuIb5nkhMAtW3lI15iDsgf8JHI3SpgbyjObAVw+ohNn7De9uExl+ff6gs5v6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgASYlGXeCI2OjdBzTPcOoAwcBW1hYgdU7d7rd86Q+g=;
 b=Z3zjbLlrPgHxAXqA9Own6xHspwhe/oB9tYLK6N5oBEXGmH4glxA4dZoJ/CZOw2Sk8EznxqO5kPgQZasXRzUIXik7XVbnY67kvNswFgeLYBZY6Mgwfxv2fs8UBdH2uWJ+VHz0OukUHeEy3oxewv9UVH3Mvj6AaZnFxw/zZ/s9siufxbYp53nbFelTw5fwngcx59R55qrKZ1yfdzzXDxQCY1jRcKqDPlARoM8I8omHOda7l4/xFI/GvfAlYg3ZxAVHLMiEN4ebXfTfy3U62DsUwo5pXkbeOER0QJ7+stuDEMF+BKHWhksNg8+tkHy7EVxDb6rtKm6MrHPHYWMhXTd2NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgASYlGXeCI2OjdBzTPcOoAwcBW1hYgdU7d7rd86Q+g=;
 b=T5xSiXhyRo1m4Q4u9jQlAp+qQGkkG3uiPSffcDPRqvZC3K53SvzXp4XSn9N5wvZCVSdw+hY9Dbq08F9coTF7KFWE4PVHcc/fDD6cmrATOIHNyvA5j4w66jCDJMLSiHDpD30boHxvljSat0k3jAOV9kdzm8ZEBZhiEYnaB11gi6I=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 19:51:56 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:56 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 07/15] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Mon, 28 Feb 2022 12:51:39 -0700
Message-Id: <20220228195147.1913281-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228195147.1913281-1-allison.henderson@oracle.com>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8439ad23-1f5e-49c6-1ec7-08d9faf3c676
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5612A486DE2DC909214F76B095019@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OAxfIuxgFbAeAc9o1hR2IKN9cqhVlsPjgR03/J0M5xEKKFur/o7+0xi5sknxv96t9vgoONV/8R3mCVkNMWuDWN3ld73kHNENir6cxAUamQRVhXdCVT+aofSqsks7h7mhpE/YRneOdFvF+XiWTQ5g5KL9+bncqztSaOIAq2aeEBm8Xc5rsr5cpjGkLV+Le24rbIfzaS0RUhf47ueR3947+Rzt1lp2GCuJ5uHGuOx5C7EoD2cO8/Np52rAic09E3yO9mxCyAAUh7azeeIK7MPABRBQdh/p2fWPWaiA8NydRiZwSXz66yYymSsgp8PApqLxH/FkVizD/1sd63mrKt6L0Ubvcq1XxzAwmN6CxdsbbhjohDKuFF7HbcnU4LuBFLtC5L9TSxyLwXWprULIafS9qyA5Ex7e0ojZrTVAyrJorahgvIsmDk9Krr5w0hKCnZrGZTqjmTctx6xLd8u0VXub9tEyTVZFFAUatV4TjNTybK8EJNaEdWNBiTgtJlnk+hivqaVq8kE8u0EHyLxstlifZQj5Ofbiwh0oSmDew+d7vgIC58W1CeCgCSgB246tgC5i85v5bGVzKziD4Q9QojtTMBTO3tMtxYjuF4Gi9qYAnJCIQ7eA3ixjJz0aDBLnyZVrnHuZqBdxKx/0Bn3OxZw3kfGO879q5aWUTkDyiCm0LQyAHCO4+HP8QJm1wAKyLhX3rvXOdJ3DYQNZaMi9FY0ILA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(86362001)(186003)(8676002)(6916009)(1076003)(316002)(66946007)(66476007)(66556008)(2906002)(2616005)(6486002)(6666004)(6512007)(52116002)(8936002)(508600001)(5660300002)(38350700002)(44832011)(83380400001)(38100700002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XJU5tOdGgcrfjFF+8SGnoT0REtnsWTYOtH0Ddma2EACMHNltnPBg2oFwSI4H?=
 =?us-ascii?Q?SafJUz/vUORg2gUg3wkNp95sbL6N2590xxmkh4u2wJTRmV3yt8ihnKU1qQsp?=
 =?us-ascii?Q?HSsBrEE6mbN1pdi2nQ74e7geOnvf6Aii9rC1XjeALvk0MKGTO30R032NV2Pe?=
 =?us-ascii?Q?WYynRNik6yKdZ74ROsRUpajShMChUDGuGJi055x2xsXYRR4Sn7/di96zD8d+?=
 =?us-ascii?Q?iIcDiQfsEA5HSworGGNTDVVJxni9VEJfqPvbf9OD5x5ng0tLwBdTc+zhhJGr?=
 =?us-ascii?Q?/gVUj+HN6NqG82C90NHmoifkOXRK1vjBAf4GiuD1nnNPzhc/ITtFODeUxon3?=
 =?us-ascii?Q?Hx6n+dUPiXl0JMOguuFBEJyFIIYFoFF6mKvlSU15313lNrJhMCkey08hLRLh?=
 =?us-ascii?Q?uIuI7WVIqh7ggoWClixY88+FmO/8sDNvVnmu7On9A8AGF1YN9ZJkPgjdvWAi?=
 =?us-ascii?Q?T/lZptTDQivff9zcAZkDHkBcUz0soj5PiGzkaqs8Yx/hYsiQVBpGsuoQ5xM2?=
 =?us-ascii?Q?0jWjRmKW8WXa3eoHfFXNb3tq+QVL3vcnLap4+lujIv9F47p50XYcyalSqFcQ?=
 =?us-ascii?Q?/EKdRU/EbyfSF3S1mkGN/hc/8MeSzvkqoHvptVlDMzhU3NnzWlCtfNVtmKsI?=
 =?us-ascii?Q?sMmqtAUVJsMQTMMYP37H+mPwf8QxTSJE3XZPTjmMoDSiqI4NZOQto2qBXB5Q?=
 =?us-ascii?Q?QITPXwS+rHadNDO5ppOF4SxOf0Vs/muKwG6/9DPwjk0h5ZYRS+gd36nMMXy5?=
 =?us-ascii?Q?kbib2Sb42oO1lOVYGcMHS08BXSlCOtvsfLDr0pG46atR3SoY1+iFbpsCoR3D?=
 =?us-ascii?Q?kzj6RKyRf0fhHC3h5PWSCQyXgTNvOjK5o4w9tyJ+QILzdCPD2kvx/qw453Dm?=
 =?us-ascii?Q?3K25b1e+nRF6de+Aj8zsVLWVVFE1l87s7wGwnWnVYPqrRPCXWHlleYMw0eo7?=
 =?us-ascii?Q?CF3zqfbl2VaoUSJiROJUHhXHPz4b2Tf3G88vY/nmp04NpTBOnXGPMRoCriK0?=
 =?us-ascii?Q?Zuu1M0PvznhcZzrIgpsj1cUfFZFaG0Rc93P5Sy6o/IEltlswYPzzg/3/1XZZ?=
 =?us-ascii?Q?dY5aeIUfUOvXHnhcWasof1fcdGKYbIZJZ33TsMWirbiqoalOHYnfTB9fPnI/?=
 =?us-ascii?Q?6PK1tvsgBThODxnJa/6RJT354fTrROfBtAOdQXt1rOxriJLo3fT6FurMvOQP?=
 =?us-ascii?Q?p9R3LKqmgpHnLomMf6CBeKtbiySifwS7n1RrDwK26wk64L/Qbqwnd31sZwwF?=
 =?us-ascii?Q?+vUxIzU6p1hc228js0nh9x99EXvoVp5DKvhmzuqwZVhDA0MBLXdRGa2unnQb?=
 =?us-ascii?Q?p2iw2gyYrRRKKqlHsBFybdGR+gvKDCpUH4sORUDsorymUrYElYvyl1Sp85o2?=
 =?us-ascii?Q?gvZMC3rUFOY5sGV8Et7QnmmPTzxYiWFyHX8Ix0jkgD6up99n71wfRcOGqXHW?=
 =?us-ascii?Q?qJOAbRVTHl/KksollMJnWMxuNuKx+IAx6Lk4TppjzbsXLxIDE6SoqhdhttZk?=
 =?us-ascii?Q?rwAJCxBsk3alJtUsv4NDQpSC7bTrD7mgDCUxkRAEx6Fw3Vkn6VbKeJQT1I0o?=
 =?us-ascii?Q?2/IJ6GjZa83lawFX6VRW2T7NkLiZLVv77poBM38fvTyXtPB2EXYOu9xdk9qL?=
 =?us-ascii?Q?3Y5t1rTaYI70Sbp2AGAc4xWfRrcD91RSpg1UCJTZxzMKD0bK29h92EgKzJyL?=
 =?us-ascii?Q?Az5Nag=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8439ad23-1f5e-49c6-1ec7-08d9faf3c676
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:56.5280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKoreB6rqJXoKM5Wt0BkSLryDzaW71F00UwNt5Ly9nuefDJyT8QVXl7oPjySmRGXmQrPwpNyIW6lcNXjjYR8ppmqbdBS/PXJdnhmkf8bAd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: 8_A54Dfw6_hFNBO_qbwm5tqOwLfegXWx
X-Proofpoint-GUID: 8_A54Dfw6_hFNBO_qbwm5tqOwLfegXWx
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

