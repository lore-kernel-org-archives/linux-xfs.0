Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B9BC43217
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79A7061501
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhKQEQy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:16:54 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13966 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232994AbhKQEQw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:16:52 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH2u8c9023615
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=M0SKSKIVUUYTRkm4IwhPl96C1U4GypGEsUqHKPCm3Gs=;
 b=NR6sTHo5j/6wR7tBze/DtIueJN11kumHh8w8bEQQkVTHPGOfcJBHtgp+ImEial2ktb5B
 1J1E9obDxaBgGwD3GYWgDC00V/qDjqBx78UuEXn5gO/dEx/isIXj7mnjDl23m65dv2Kh
 gWtCnUoEKoU3X7fPlxcKKhK3Z9O1pS51ydFX/9YksTJNNAMpjFHIm+hI3d6H0IQVjxrj
 UHE2e+NE2ZJCzecf+JYM3AFbo6on5TTqtDxVoczMdk9dKZFVcXeCUJyrBMf26C5NBhNj
 FMigUhK9yx7PcmuYBUqwFZe/I/V7QINs/eHHlRujg/2nKZxR+4UvZzKsT2AhtpvuH6MK 8Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbfjxwwm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEJW180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3ca2fx68vt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXPfglgOx7Esw8bLzb1CVf3MNVnImymk4dtyTGTZDEdJ6+F/GPQ86GkTeO6tFAP0b9KKWOewisY+J3lm1eaPPwRWPWAcN3k31I3Si1KHHflLTbJUoJcuRW5SgNy+ola3q1cs9+c6asQdTJOTHWz7Zv5Jrq28S7SxB1u4IlxFcXPdrm3A4bsHRVTXn/qreUUpjFol7coRO79BzjjMUXaD9vIA6B+Kb9WSSjJ79Ob7OMFmhuQPcokhpA/xJNxTK3xDo+WDFJVE1qKTaViZvjf+Ldb4BDRsRk4IRt9FyY1zHweOa7Gw64zaxXvX8PHMUBAHVS0m/SqdIy/txqSBElz4Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0SKSKIVUUYTRkm4IwhPl96C1U4GypGEsUqHKPCm3Gs=;
 b=I9eZggu7TgSB7ji/6MHS/XZMW5fgWM/bIMqW1/cKxURDOQF+3wGkwUdpy63ksThhtpJ7nMNcXLk9rBrS48tZZgjVnA1p7b/ke/Ci4rfiRyMMQmJ0Ybn26rCUuau7WPjEyrkd5IsYQqqGr0lARsHXg0/RBYD+VNsKXATNgI+wayC+l6Aueg3kdHb/euwooA3o2Elq1eKye3kBZSCRZbc6PKHiPrS17aarKCQpFd6TmX8K+Jp2xxk4Cq+tKYX4UkgrN3nF9Cum19o+l2s4vO4PFR0mqH3EFajIw0Yhlq3Vtx7PCQG/aR4xSTAZ2GIMTXnH3FZ82ceRBcd8X6PqeHGf/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0SKSKIVUUYTRkm4IwhPl96C1U4GypGEsUqHKPCm3Gs=;
 b=Co9glSQtImSnQrEWSGrcQrtyYnTmoOb3qJPChhxk316TJWDE4OrA0zXwts22IjoizlnTY9PxWEm4bHuoiHFkXIcXuqcqB1jHV66H2PtXrcB2Yh9RfpcBVUkYOF//PTnGYCzcMma1Hy/oKzoMUjF7Kd95lLqqyoAUXzToTIe+3b4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3921.namprd10.prod.outlook.com (2603:10b6:a03:1ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:13:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:13:50 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 05/12] xfs: Implement attr logging and replay
Date:   Tue, 16 Nov 2021 21:13:36 -0700
Message-Id: <20211117041343.3050202-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041343.3050202-1-allison.henderson@oracle.com>
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY5PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:1d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 04:13:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73711fb0-0df3-43cd-acb2-08d9a980a8e2
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:
X-Microsoft-Antispam-PRVS: <BY5PR10MB392103B8FBBC6F98D6AB98EF959A9@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:231;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xqmsNl7dTulBVNIIy8h56GN5HNchgCcbO8avNCq6pMjQeeGmNVJvDhtA3TOqIdKpDlZ2P8QRMQfysKDU0bJ8dqkwcAQhudobzW85HLdDc5YISPo/JhbDkKpqT9rXyjCigflddv7Z86NpixAEvZuinPLkNbjToi4kxW6BTYiAKLeHOgoA9D7gLbD5hv3qvB154UVwMb2Pg+ujoVoqEjd77/qGUlmaZNUG99omo6INexL6f9RF/4hCHQMcxwOPIFZOmRXzLCCjvTiC9IrU8+nOLeu39RMF/FQSFwubKfrkGxMNGweS/lgD9s7+sI7jJL0DOng8e2//gfRgMXTU1s3k02Rl7+J0hM2B6/jzIDT5zrLsLnhXSrE0mgAl/xU5aaf1beTr7XV67FSuo82vn0gSOOfQcnnLTwSGboXtL69/mfMXYjSdkW9IFFspIc6khYBKbMk1ZPp+9QKVgmXUTCxMGgDODC7RRcrLEJbw4WFGeVtFjiT1Vp3HU7XxOnGV2gAdylBzOoDya+8VxhYuy5ttKRStgNCllBb+rd+g/Yb5Fjs32gvrwZNdtg+gUXgik7LvhoRaFP5I/ht2BEyiYrlJweMEuIwdfWAJGZAYi/fDgRXsNsaHBoAq5j07Zx+Fp0NwyVnVYbMNRAfM/BqZaWjBnnFbZK2RasooR3adoE470VkqsgPG3oDqxP3b75+XzEzsEAKemSU44jBDHeAcUGPuig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(38350700002)(6506007)(2616005)(86362001)(30864003)(6512007)(5660300002)(8676002)(2906002)(36756003)(83380400001)(508600001)(52116002)(186003)(66946007)(38100700002)(6486002)(316002)(6666004)(44832011)(66556008)(1076003)(66476007)(6916009)(956004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ExvlJJT01x6EU0iPFkAL41lksZmgWriu0erjfPtoPvL9e6VB55en7w6fB/dz?=
 =?us-ascii?Q?za748XOC/FjJ74PYGzUQOQfWn47A1Dh0olwzs7nps+HvqI3nSAdWSNZyEcPH?=
 =?us-ascii?Q?F+uhkKwlWyudzDmSVNy7wHUd58kuS7ItuvBGneD5geL3YpDbaYl1s5/UTb0R?=
 =?us-ascii?Q?WdumPyZVlmBvrgw3FvAKneoGZDTWXP5U50fENnxaF2kZcSVvsvotyTZ5pCWW?=
 =?us-ascii?Q?pktN80UvO3kWD4igSvPHQcC+F9ZYF6xA1hO2SsWp4Lkd9YsL/GOsEuZ8sJxI?=
 =?us-ascii?Q?ikaydIvQS1V6xnfWyV7FhmxzT7WGdZ9cHcwDby2hV+4CgpPzZywPulgi9ozK?=
 =?us-ascii?Q?bYvK7N6SuIRkwX6RKsVTKhP4rI0EV3l11+/aNBP+E5qQvIzkfmQu2cKtCgxT?=
 =?us-ascii?Q?B9x/CT3gO+Ox7ZuS9F4z4fGof1xjZVBYDDse1MoybBW29ZqteXYnNd4pVtm/?=
 =?us-ascii?Q?/gfVNmZ471VtffVV5nUYgnSvauE7WVHYTd2Yt8qMIx6w+x5GHqR29v4fjGme?=
 =?us-ascii?Q?vg70ge1cBu+nQRSbpkoxOKDjWHzxk6QvAcOEdz3XlZKYO8+ngmbg6r/if+lB?=
 =?us-ascii?Q?iGJba1Xgeyt6kzoBHWg8zOhjnYW+mH9AA/OB2Wjw1dV8+xg+UNwxA9zG5qdH?=
 =?us-ascii?Q?GKKNijneKe99xJrMNqHafmNeXy0lsSU7kdkD7HaMwemn+X8G+OqULMkdsPEk?=
 =?us-ascii?Q?h/JGF8Kd3kJEi3o0tS3RkzrpZyfXfGw103MnuTdo/j0OGFLswZYxVF46173D?=
 =?us-ascii?Q?tECDvP4V32FoRlyCeUFvht9yGbnZ+FKhpfvHAj2jeqRhSXlfVfVL2x51LDq+?=
 =?us-ascii?Q?5bwlaeq0b+qIUW2PpdadpSFBC12rFOdNhln+b1qo4nRYDuCn4Eybadk9zJMu?=
 =?us-ascii?Q?dxW657WA0EBd4f1MO6eUUixHMJUoOCY6NvcdwtOIK9E7ltsO/1J9/8J05qmq?=
 =?us-ascii?Q?kRov177jruwx1YFJdyBrES1YPA6a8f/MSGwYb3PL6i+lhnfW+cOOjcrUuCKw?=
 =?us-ascii?Q?MQxOv5Ec+9gtW3GXkiMbtzQl4R3KKm8klpEcTRL0yfOvkJZE8G4Zm4yvEb1F?=
 =?us-ascii?Q?rwmX2iajfYt9GzrqHZ8PHi5VnYprDT/9n9lx6ejyNLErHqC5wG1AC6yBtku7?=
 =?us-ascii?Q?okj80CGKwJ564egdkmpt2an/VdhEyyxq/nVI38N3AWiw18hDRhONh/zFRyb8?=
 =?us-ascii?Q?yb3hxgFvJ9lv3sJtTSu24BuEj+dwuktcInGQ57IUnX8DY8bNRC6DKBh8WpHZ?=
 =?us-ascii?Q?1PvRabfhQb9jcRlBeAav4+cSJJJ2vRAMKD4COyAzxT3Qs6Nf36tqdSYLoeVF?=
 =?us-ascii?Q?68xfwxv0XJI80/zPMqWS7QZK7xvQQiunw402d+pnvzeU2bILB3I8J6W78VpT?=
 =?us-ascii?Q?PfkdasqfH4wRuUAlAgp4bLOgo9RPPBUbjARQ6uBdXan/wwGrzi6f6EgRDlkv?=
 =?us-ascii?Q?fwacCdp4zXcDDNYMUSRDWLhlCOFY46Q5/gOnGLHZOk5CFeFuU/1ll7sjpBnC?=
 =?us-ascii?Q?8X8fYCu8TSsTUlweoN8kGitHCAnWlz5hypecwl05zoL53xXdMGNJVhnxsY4j?=
 =?us-ascii?Q?1vKYGhPHzHES0REQxoNeTVfbPxlBVv37yPG8E1Q+R1K8PHZSHDtjSBaG0Bg9?=
 =?us-ascii?Q?4p9nKKi7CtZmhbVTe5suuzs7d4KjMWN9Vs4qd+yeFj5nGf6CQtaiznPtIH0Q?=
 =?us-ascii?Q?N2XFYQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73711fb0-0df3-43cd-acb2-08d9a980a8e2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:13:50.5156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VuTqqhs5UeCzgDh+M6UMNk7aVyvAwudAUTBOZmOEdeLQ9hsS36V9qgec1GA8g6/cDXLznWgrSKLlNGzJKA6hELOlPJdmaRtGnBOo4Nf/Jb4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: 1E7xAhaJ1r-GIS92wF49DGrn0DviymU4
X-Proofpoint-GUID: 1E7xAhaJ1r-GIS92wF49DGrn0DviymU4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds the needed routines to create, log and recover logged
extended attribute intents.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_defer.c  |   1 +
 fs/xfs/libxfs/xfs_defer.h  |   1 +
 fs/xfs/libxfs/xfs_format.h |   9 +-
 fs/xfs/xfs_attr_item.c     | 362 +++++++++++++++++++++++++++++++++++++
 4 files changed, 372 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 51574f0371b5..877c0f7ee557 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -185,6 +185,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 static bool
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index fcd23e5cf1ee..114a3a4930a3 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d665c04e69dd..302b50bc5830 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -388,7 +388,9 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
+	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
@@ -413,6 +415,11 @@ xfs_sb_add_incompat_log_features(
 	sbp->sb_features_log_incompat |= features;
 }
 
+static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
+{
+	return xfs_sb_is_v5(sbp) && (sbp->sb_features_log_incompat &
+		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
+}
 
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 3c0dfb32f2eb..5d0ab9a8504e 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -13,6 +13,7 @@
 #include "xfs_defer.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
 #include "xfs_inode.h"
@@ -30,6 +31,8 @@
 
 static const struct xfs_item_ops xfs_attri_item_ops;
 static const struct xfs_item_ops xfs_attrd_item_ops;
+static struct xfs_attrd_log_item *xfs_trans_get_attrd(struct xfs_trans *tp,
+					struct xfs_attri_log_item *attrip);
 
 static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
 {
@@ -254,6 +257,163 @@ xfs_attrd_item_release(
 	xfs_attrd_item_free(attrdp);
 }
 
+/*
+ * Performs one step of an attribute update intent and marks the attrd item
+ * dirty..  An attr operation may be a set or a remove.  Note that the
+ * transaction is marked dirty regardless of whether the operation succeeds or
+ * fails to support the ATTRI/ATTRD lifecycle rules.
+ */
+STATIC int
+xfs_trans_attr_finish_update(
+	struct xfs_delattr_context	*dac,
+	struct xfs_attrd_log_item	*attrdp,
+	struct xfs_buf			**leaf_bp,
+	uint32_t			op_flags)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	unsigned int			op = op_flags &
+					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
+	int				error;
+
+	switch (op) {
+	case XFS_ATTR_OP_FLAGS_SET:
+		error = xfs_attr_set_iter(dac, leaf_bp);
+		break;
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		ASSERT(XFS_IFORK_Q(args->dp));
+		error = xfs_attr_remove_iter(dac);
+		break;
+	default:
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the ATTRI and frees the ATTRD
+	 * 2.) shuts down the filesystem
+	 */
+	args->trans->t_flags |= XFS_TRANS_DIRTY;
+
+	/*
+	 * attr intent/done items are null when delayed attributes are disabled
+	 */
+	if (attrdp)
+		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	return error;
+}
+
+/* Log an attr to the intent item. */
+STATIC void
+xfs_attr_log_item(
+	struct xfs_trans		*tp,
+	struct xfs_attri_log_item	*attrip,
+	struct xfs_attr_item		*attr)
+{
+	struct xfs_attri_log_format	*attrp;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
+
+	/*
+	 * At this point the xfs_attr_item has been constructed, and we've
+	 * created the log intent. Fill in the attri log item and log format
+	 * structure with fields from this xfs_attr_item
+	 */
+	attrp = &attrip->attri_format;
+	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
+	attrp->alfi_op_flags = attr->xattri_op_flags;
+	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
+	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
+	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
+
+	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
+	attrip->attri_value = attr->xattri_dac.da_args->value;
+	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
+	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
+}
+
+/* Get an ATTRI. */
+static struct xfs_log_item *
+xfs_attr_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_attri_log_item	*attrip;
+	struct xfs_attr_item		*attr;
+
+	ASSERT(count == 1);
+
+	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return NULL;
+
+	attrip = xfs_attri_init(mp, 0);
+	if (attrip == NULL)
+		return NULL;
+
+	xfs_trans_add_item(tp, &attrip->attri_item);
+	list_for_each_entry(attr, items, xattri_list)
+		xfs_attr_log_item(tp, attrip, attr);
+	return &attrip->attri_item;
+}
+
+/* Process an attr. */
+STATIC int
+xfs_attr_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_attr_item		*attr;
+	struct xfs_attrd_log_item	*done_item = NULL;
+	int				error;
+	struct xfs_delattr_context	*dac;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	dac = &attr->xattri_dac;
+	if (done)
+		done_item = ATTRD_ITEM(done);
+
+	/*
+	 * Always reset trans after EAGAIN cycle
+	 * since the transaction is new
+	 */
+	dac->da_args->trans = tp;
+
+	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
+					     attr->xattri_op_flags);
+	if (error != -EAGAIN)
+		kmem_free(attr);
+
+	return error;
+}
+
+/* Abort all pending ATTRs. */
+STATIC void
+xfs_attr_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	xfs_attri_release(ATTRI_ITEM(intent));
+}
+
+/* Cancel an attr */
+STATIC void
+xfs_attr_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_attr_item		*attr;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	kmem_free(attr);
+}
+
 STATIC xfs_lsn_t
 xfs_attri_item_committed(
 	struct xfs_log_item		*lip,
@@ -311,6 +471,160 @@ xfs_attri_validate(
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
+/*
+ * Process an attr intent item that was recovered from the log.  We need to
+ * delete the attr that it describes.
+ */
+STATIC int
+xfs_attri_item_recover(
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+	struct xfs_attr_item		*attr;
+	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_inode		*ip;
+	struct xfs_da_args		*args;
+	struct xfs_trans		*tp;
+	struct xfs_trans_res		tres;
+	struct xfs_attri_log_format	*attrp;
+	int				error, ret = 0;
+	int				total;
+	int				local;
+	struct xfs_attrd_log_item	*done_item = NULL;
+
+	/*
+	 * First check the validity of the attr described by the ATTRI.  If any
+	 * are bad, then assume that all are bad and just toss the ATTRI.
+	 */
+	attrp = &attrip->attri_format;
+	if (!xfs_attri_validate(mp, attrp))
+		return -EFSCORRUPTED;
+
+	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
+	if (error)
+		return error;
+
+	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
+			   sizeof(struct xfs_da_args), KM_NOFS);
+	args = (struct xfs_da_args *)(attr + 1);
+
+	attr->xattri_dac.da_args = args;
+	attr->xattri_op_flags = attrp->alfi_op_flags;
+
+	args->dp = ip;
+	args->geo = mp->m_attr_geo;
+	args->op_flags = attrp->alfi_op_flags;
+	args->whichfork = XFS_ATTR_FORK;
+	args->name = attrip->attri_name;
+	args->namelen = attrp->alfi_name_len;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->attr_filter = attrp->alfi_attr_flags;
+
+	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
+		args->value = attrip->attri_value;
+		args->valuelen = attrp->alfi_value_len;
+		args->total = xfs_attr_calc_size(args, &local);
+
+		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+					args->total;
+		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		total = args->total;
+	} else {
+		tres = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
+	}
+	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
+	if (error)
+		goto out;
+
+	args->trans = tp;
+	done_item = xfs_trans_get_attrd(tp, attrip);
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
+					   &attr->xattri_dac.leaf_bp,
+					   attrp->alfi_op_flags);
+	if (ret == -EAGAIN) {
+		/* There's more work to do, so add it to this transaction */
+		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
+	} else
+		error = ret;
+
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out_unlock;
+	}
+
+	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+
+out_unlock:
+	if (attr->xattri_dac.leaf_bp)
+		xfs_buf_relse(attr->xattri_dac.leaf_bp);
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_irele(ip);
+out:
+	if (ret != -EAGAIN)
+		kmem_free(attr);
+	return error;
+}
+
+/* Re-log an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_attri_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_attrd_log_item	*attrdp;
+	struct xfs_attri_log_item	*old_attrip;
+	struct xfs_attri_log_item	*new_attrip;
+	struct xfs_attri_log_format	*new_attrp;
+	struct xfs_attri_log_format	*old_attrp;
+	int				buffer_size;
+
+	old_attrip = ATTRI_ITEM(intent);
+	old_attrp = &old_attrip->attri_format;
+	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	attrdp = xfs_trans_get_attrd(tp, old_attrip);
+	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
+	new_attrp = &new_attrip->attri_format;
+
+	new_attrp->alfi_ino = old_attrp->alfi_ino;
+	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
+	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
+	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
+
+	new_attrip->attri_name_len = old_attrip->attri_name_len;
+	new_attrip->attri_name = ((char *)new_attrip) +
+				 sizeof(struct xfs_attri_log_item);
+	memcpy(new_attrip->attri_name, old_attrip->attri_name,
+		new_attrip->attri_name_len);
+
+	new_attrip->attri_value_len = old_attrip->attri_value_len;
+	if (new_attrip->attri_value_len > 0) {
+		new_attrip->attri_value = new_attrip->attri_name +
+					  new_attrip->attri_name_len;
+
+		memcpy(new_attrip->attri_value, old_attrip->attri_value,
+		       new_attrip->attri_value_len);
+	}
+
+	xfs_trans_add_item(tp, &new_attrip->attri_item);
+	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
+
+	return &new_attrip->attri_item;
+}
+
 STATIC int
 xlog_recover_attri_commit_pass2(
 	struct xlog                     *log,
@@ -377,6 +691,52 @@ xlog_recover_attri_commit_pass2(
 	return 0;
 }
 
+/*
+ * This routine is called to allocate an "attr free done" log item.
+ */
+static struct xfs_attrd_log_item *
+xfs_trans_get_attrd(struct xfs_trans		*tp,
+		  struct xfs_attri_log_item	*attrip)
+{
+	struct xfs_attrd_log_item		*attrdp;
+	uint					size;
+
+	ASSERT(tp != NULL);
+
+	size = sizeof(struct xfs_attrd_log_item);
+	attrdp = kmem_zalloc(size, 0);
+
+	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
+			  &xfs_attrd_item_ops);
+	attrdp->attrd_attrip = attrip;
+	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
+
+	xfs_trans_add_item(tp, &attrdp->attrd_item);
+	return attrdp;
+}
+
+/* Get an ATTRD so we can process all the attrs. */
+static struct xfs_log_item *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	if (!intent)
+		return NULL;
+
+	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
+}
+
+const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.max_items	= 1,
+	.create_intent	= xfs_attr_create_intent,
+	.abort_intent	= xfs_attr_abort_intent,
+	.create_done	= xfs_attr_create_done,
+	.finish_item	= xfs_attr_finish_item,
+	.cancel_item	= xfs_attr_cancel_item,
+};
+
 /*
  * This routine is called when an ATTRD format structure is found in a committed
  * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
@@ -410,7 +770,9 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
 	.iop_unpin	= xfs_attri_item_unpin,
 	.iop_committed	= xfs_attri_item_committed,
 	.iop_release    = xfs_attri_item_release,
+	.iop_recover	= xfs_attri_item_recover,
 	.iop_match	= xfs_attri_item_match,
+	.iop_relog	= xfs_attri_item_relog,
 };
 
 const struct xlog_recover_item_ops xlog_attri_item_ops = {
-- 
2.25.1

