Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D91C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E31761BE1
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhKQET2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:28 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34590 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233016AbhKQETY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:24 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH253cA003491
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ZPgBEgt69pho+R1iT+ga/yFvidKEdlrOxrjL+vHTMYg=;
 b=x87zkj3N2XPEKfDgZYmH1Ah04cr/5YPiTr6j8UmSNbhYV/HC27tnhRKDwb5p7wFwB6/i
 j7pIU8w0iYaQD9mfzKYuZROZeCyfWZEs0wq+N2dcp0Yzei93pfmFSpbHQDmX2CtKfwAe
 2mO8aqMOEhCQ3pc82kuAn86TZ7whOt+V8u7+cv/hDcfCbwjNids7uY17eSzjexhX/Loz
 9M+75B34JFf8KdyEb7HQlthZTN+fNeBBbpwwP5XazzUeQ5EuRzcDB39AmN0BD1ONh/9U
 VZEBfX6ZM5BWGLkkUZY1p6oI1eSI6rkr2QzNLWU2+df+hdO8AY9BhgH4HUBOCssZNnKL MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv5dru5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4Aehd037362
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3ca566dagu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsfqJ7Mnutydezcfh5keI+FfdpK+1bfq6yvOTSg7K7Lzb4Zl0I1EnI7P6giQZijjmPk3ifan1qPeVI6JvH2A25OmGEhb+aDa4OhQOuadMkC2mlcX0dnpzB22d19AgTR0ank0/d1Nd8gbIuW6YvWvRUXIE71TcEyoqk4z4Z7J3rTxLBTLeFcZ4oleBRLldGbufmWV2xEYhM6L+bBSq+wThK8g8KxJ29Nt5c0Jo6PvYJEcVEDWNNML/KQyc40IkyOmsxpY6Qlec6FCo2SWONuiz1nbGRtHxFCBbUL3jeJgi4klMvivgOllBmbDI4rHUPTQkWFIWsRC+rLf3GXrmJzbjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPgBEgt69pho+R1iT+ga/yFvidKEdlrOxrjL+vHTMYg=;
 b=a/orGolRex3CsC30adigdn1v8P23TY5dkSk1PmlmtlcFHcJTiqFl54Y5pv6xV0PSYP76sFwt5qkGc5fEra7QCwoRjVHHwg4Xg0gLdV8TDQO7j/EYLJWszuxUArP2JnW/s+BMwS4sxZ+yJKMViEA4l/9ozPtCkpiqwX+/I1XrZe+98YZBn53KK0ySoov/ygohCjddP2zOFMPDqUPOdBxzz7mypspHkbYXsVbbxxYB8wUPdNtGHLf9/2WBV4Pbl9reB1IpKTzhHUaUa13Vy4cvMQL8mHJl1LvMKQ3Ctz8WQTfhuxTIqx+HuDvhs14aZ9R3/lLcYvR4qGDmDo8X14pP8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPgBEgt69pho+R1iT+ga/yFvidKEdlrOxrjL+vHTMYg=;
 b=aeeLjiUaAm8a6ZA2VxFTAB26khK1MO6Aw6si+MRM7bBNGJqibjrqwxvcdqHlw1XcUot5JRPeC5egEPNg6O+MrL0XgBFD/ijFj/jzg7418fDr+PHrCMFpFjfxMTDgTFnid0zasYTXaRWiAwkARMiqjnnpZEEfjopEdX+QWkxd9Kg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4446.namprd10.prod.outlook.com (2603:10b6:a03:2d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:16:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 10/14] xfsprogs: Remove unused xfs_attr_*_args
Date:   Tue, 16 Nov 2021 21:16:09 -0700
Message-Id: <20211117041613.3050252-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18036009-f54a-4fe4-24e8-08d9a98103ce
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4446:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4446E47AF4F4261CA7B5B360959A9@SJ0PR10MB4446.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9E9ac+T0uuBu838rQcRTTPAbmL70DXUedk/91gHtUeUGYwAfek5cxS4h307MWCIKlER7GgF+GKmRA9+NYf9tXDv1i70uczHjq8Jg3sBjmotTULeVLvnXEmFgNmiZtD4wI5l+YVMYREh8EoDJb+LU5T/ejeuPj8zbaQGYz1iW/UFqPHVUfmIQxxYODq28zZeqAzKt6J8fhzBXpje+AyTphsBxrvnL7owoiXtB1hLJihf0WZ1+e9TvJVvQwhnBd7hqac7T6amNBcvPPTfli1bCsWBDDbtheAdPRzWV9O4mVsaiY6EDqF+O2bFTxJD9LMptpQRzfhvVEw+IwV61gJxGKuMvkCPCdTJ8DobwLjPy+dunXlarpQmLni79yH5/+D/9xGoUXV2EqRARCiSMaouKmveNyJu+LlSwza//KBPPumWCOO+Ys5IpukBt4hzDdVHu6Lv433qPeqkse+QeSxkbh8+5I7fjOVfMDhEF6kQ/esrQEmKcxwz4kqu+LHKdkUvtvMkvggv6cjYfA4GN9NbhERux7PCsS7fXFVOgHQ+WQ5Tx410d0+rD7hivXDJsGn/D0JMbljQJbtGKx00R/05X59jIlYlrcdEGMp0WNcux5dCuAJbICQEo5Ke66Owt75mHqY4nZQW69W8RK22zSDaLmF7fe8bZm8Tp6IT9b2X1ZWXXemX4tro6ULtg6PgEF31RiRH54pgqICn5n9y1evqj4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(2906002)(956004)(2616005)(83380400001)(38350700002)(38100700002)(26005)(52116002)(5660300002)(316002)(6486002)(6512007)(44832011)(6666004)(8676002)(8936002)(1076003)(66946007)(66476007)(66556008)(6916009)(186003)(508600001)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xjwKYDT8C4DbgeBDMobOfmjalV7hTbq7rOvjTuBNpBwt1nXMaqcOTbRQ9ygN?=
 =?us-ascii?Q?eCKSpWeqI7mzCebYuJg9F4bhMxFS+w6nroVSFTqBw89W2YPa/oS3aOYs6mgf?=
 =?us-ascii?Q?Tv+4Dy2KyxK2uHdjVf1qrgNAeI8yANo+fyZeJYwPwm+pNawlrpEKhXYg1Tp3?=
 =?us-ascii?Q?RICAWECrwIEjQHhgMfKuI/QY+GQz+BDq84WXNuJm6bLPtZj5Qge2zAjyfjHa?=
 =?us-ascii?Q?FoZ4Q+molNHZlPc82cvyO4ttvv/FgLnc9ShoMYYwil5+CSq0oph107MCJpuO?=
 =?us-ascii?Q?Z1g6mS3RJFXJ2HJUeNaqHZlwGzjPqcRN5Oh2Z02aLDYZNWTDSRIMiJn3LTKd?=
 =?us-ascii?Q?9/wPFoG586lBid6nroIw/gePsuA9UmN59bAffgjJ/4ow6G6gHn89Wl7rqeMC?=
 =?us-ascii?Q?qH460b3HtHLNFIcmGDOzQnIXqzuVMeS23MWjcVWqhzK3pEgncbm3vtY0zMjT?=
 =?us-ascii?Q?pjU4HvbYCsdwHh6bpW0ZgynlGJaevAvwnfllIy7BcOeQpwKRk+2NM8Op5Dt3?=
 =?us-ascii?Q?6NUkzRGG6PrSk1p+/S2JZC+gL/pqQC57NxdjmYq8mdADksfxfxa1zGfzXnwB?=
 =?us-ascii?Q?jkjpodaUGFM7kH5DOJe5Gmycywf4xp6RwgFlIgvyAp+3l0SXUIOkI/aK1EQh?=
 =?us-ascii?Q?xaYNVcp/thePvdPVmtjucUUVik+vCywdaT20YX/5XSKbgJg7Vf1Mqx238dyS?=
 =?us-ascii?Q?sFjzehzUTztbs+VSEKaLGJ4xE5YBfvvqSKKzcTPLC7QEtOgGrC3aoPqi4XbY?=
 =?us-ascii?Q?1EI6D0dngkj2Ul4aDATw4ULbyVjXsLXkrDXxW/ySeAs/gDSfjo7/05n3wNh2?=
 =?us-ascii?Q?wxicKPVK6VlWdq+6FzyuXL+wNl6mu8NstnOIPKye+Dshk4micYMbYgC/PsTo?=
 =?us-ascii?Q?2AkxWvzGcEj99lXu3cJIaz068C2Jp+eF2VUojVKVCD78VkH0+bSyil0ZXa3o?=
 =?us-ascii?Q?nl/aWCzj824NBYeyuX4x+C16+1S+DYlsaLTZfTsgnvXrVUJGoFYEm2+LxxrU?=
 =?us-ascii?Q?4CKAk9JUjiVICg0mmDXdPy5G6W02p2ZleWWVchWFmbpQtEiE4Ofv/0nAZJgx?=
 =?us-ascii?Q?m0FveoqkgimfAFA2vicJeF6s2cF31mUhhs7+jwZHKnv8W4h6McEv6X3fYsWG?=
 =?us-ascii?Q?JkOPHT6vX7sTtPx+N43hiA4KcEDMOnZ0Pz6kD1xRb8Zbfo17LxuJrS4aYkdQ?=
 =?us-ascii?Q?QZov0TEHrReoz/z/VooiaGGuMbSFefwRa9lPxwI6rz7tAPGnT34HAGc3WmSt?=
 =?us-ascii?Q?WKsT/WfaM6Lk98Hug++I/TXInopZpCDQkaUr3ayQ29J61+XWD29GVDJN4jed?=
 =?us-ascii?Q?3vg03WjnL5QOfOy15Qzexv8wG7As/UpWC8Hns8cb/a15NUKR4w+8NIIZ+fgJ?=
 =?us-ascii?Q?1ippsao16nmTRV4bhhFrjEl2zDDvy3A3Q0cJi9lSiqqyj+3iZHSPXaYM5o8B?=
 =?us-ascii?Q?TaQYwA9du8N4SgcJNgODTplzzTC5kVsmns0PRRPeqt820wT+tTExHBp8tpbj?=
 =?us-ascii?Q?pRdoYf7wK/sobrSFB+Cy2aSY1Q2kEtQZis+VB3wEdXJSTnfw88GiQuSwSrP2?=
 =?us-ascii?Q?b/rxC55xrlBwCgU+jO5ZhNyDVDqo4/tL2/r4BZIhKLyyua33bCxuOEctahPJ?=
 =?us-ascii?Q?gpv5OsZY2K80JE9a0mS60PDZSP1WhEsq8mCxc5x/pLfadTLzpaTmdmZ8ACky?=
 =?us-ascii?Q?w/4sWQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18036009-f54a-4fe4-24e8-08d9a98103ce
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:23.0507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFiQL6lNHXTi9EZhC0eZB5sJiboqP5IhlN6wqxXtHRJ5OD+FX7drh24Oz25Bc58wpwBuVk9o6Z8D+/2dsnsYJxL6QhAROLZNsKh+uhc/hDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4446
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: 6d0OjcAqxNA_qm-BdB0kmul2M_6KbVnm
X-Proofpoint-GUID: 6d0OjcAqxNA_qm-BdB0kmul2M_6KbVnm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
since we only have one caller that passes dac->leaf_bp

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/defer_item.c      |   6 +--
 libxfs/xfs_attr.c        | 106 ++++-----------------------------------
 libxfs/xfs_attr.h        |   8 +--
 libxfs/xfs_attr_remote.c |   1 -
 4 files changed, 13 insertions(+), 108 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 46026084f44b..594f5e92e668 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -124,7 +124,6 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 STATIC int
 xfs_trans_attr_finish_update(
 	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -134,7 +133,7 @@ xfs_trans_attr_finish_update(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -206,8 +205,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_trans_attr_finish_update(dac, &dac->leaf_bp,
-					     attr->xattri_op_flags);
+	error = xfs_trans_attr_finish_update(dac, attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 806272017cb1..7d28914894ce 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -241,64 +241,9 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Checks to see if a delayed attribute transaction should be rolled.  If so,
- * transaction is finished or rolled as needed.
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
-		if (error) {
-			if (leaf_bp)
-				xfs_trans_brelse(args->trans, leaf_bp);
-			return error;
-		}
-	} while (true);
-
-	return error;
-}
-
 STATIC int
 xfs_attr_sf_addname(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -317,7 +262,7 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &dac->leaf_bp);
 	if (error)
 		return error;
 
@@ -326,7 +271,7 @@ xfs_attr_sf_addname(
 	 * push cannot grab the half-baked leaf buffer and run into problems
 	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	xfs_trans_bhold(args->trans, dac->leaf_bp);
 
 	/*
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted
@@ -334,7 +279,6 @@ xfs_attr_sf_addname(
 	 * add.
 	 */
 	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -347,8 +291,7 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args              *args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -367,14 +310,14 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac, leaf_bp);
-		if (*leaf_bp != NULL) {
-			xfs_trans_bhold_release(args->trans, *leaf_bp);
-			*leaf_bp = NULL;
+			return xfs_attr_sf_addname(dac);
+		if (dac->leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans, dac->leaf_bp);
+			dac->leaf_bp = NULL;
 		}
 
 		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args, *leaf_bp);
+			error = xfs_attr_leaf_try_add(args, dac->leaf_bp);
 			if (error == -ENOSPC) {
 				error = xfs_attr3_leaf_to_node(args);
 				if (error)
@@ -393,7 +336,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -684,32 +626,6 @@ xfs_has_attr(
 	return xfs_attr_node_hasname(args, NULL);
 }
 
-/*
- * Remove the attribute specified in @args.
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
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -1273,7 +1189,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1288,7 +1203,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1542,7 +1456,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
@@ -1570,7 +1483,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
 					dac->dela_state, args->dp);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 4c48bd46bb32..60806dcd5e5d 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -457,8 +457,7 @@ enum xfs_delattr_state {
 /*
  * Defines for xfs_delattr_context.flags
  */
-#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
-#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -516,11 +515,8 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
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
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index b781e44d9c5a..42943b3542c4 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -694,7 +694,6 @@ xfs_attr_rmtval_remove(
 	 * the parent
 	 */
 	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
-- 
2.25.1

