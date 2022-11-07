Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54942C43217
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiKGJDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiKGJDO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26333165A0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:13 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75Zv53025290
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=+4RLOvLGs4IZo/DMVeMJDf+MwYo8LMgO6tdl9c4wy/M=;
 b=kZCvYiMoyoOZgt5ehWEHQj1geXWvZ2Uiqgm0wH7NTClmeYVAI6Mz+lcm0AXHCwB5iF7f
 vzS1EYNAF1Fts8GBirrlRdd6WDcIqSbsj7ZdlA4PVDImuMIk3gmyITzc+IQKxIB6c9Bm
 ZFIurr2EE2bbQJajr5YvhpAQhVgKVepLrLMJaOP4ziumuBw2ke/Xsoc0xvoC5O/siTo2
 rxBK3n/QdVHzgdY76vvF1PoQ6ie0dIdyTkHn+5J+JMdBdV6Yf8XyqtUD1dLW5EwYTyGb
 aGMxKjspk66Ge6Ho4MAyCPxZ8EBpZ2M0rpsOJtlBdLRe2Oktf5RHDlBwDTbj75AJvvjO kg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngmj30jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77YwuQ023880
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:11 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsc2yqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bp/eQdQpcD9izRuPTTxJXdoZ0hWAEpds1WuVz8TOxSHW2hCZV2ilNGFrP3vBH7kf/hVAtK5KMKGaq6WQ37IUrJMdHl+LIODBJXa0t6H6NBfARYVskXUPMia2WkCF0JlpxMh6nmKUfwwJInt/JPUDJXXH+eI96TPkztOm6a2QCTWUCUTNhpqxuqmmguBZHU/3TyVTQKFNwENDXN95JX/aYwMNsDODlOx2cRuN2b0Jbm4VmzRldIlJiw4ivLOPJFWPTyj5NYWek7yq/An2NFjj7u6/49pOBj8fXCGjZYrKINO8D3d7evpSDC5eAgsCG12QqcC5c2wDPI5buWvRIPewXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4RLOvLGs4IZo/DMVeMJDf+MwYo8LMgO6tdl9c4wy/M=;
 b=PQelbZVwm6Rg/TrJv/ukbpdVn5o6L3fvUj+vMnXvBoiy4tibDrGYkc84tMdsic41ln0J+mAFLFJkYwv4bRUjFi+GPNm004LSD1QOrc9A0vvszvJhlQOFFUkyVIKdrSfljaOXFVxx0EZ6os6VfYWQ5fufwIoBx125HDuw4v3jOfziVT0tRKswnzbqM3Zdq93ML1ZD51RSXCfm2V38KbqVyutVuzzvPLbAJ4aWIid6+dzq2kfsEvcKtoCeqOucTqYer+EfFySoue4sRyTJGuvw/SNkjsxfYkNXCw558QPyOYe5O6jHqV1JEgdzXD6CxXKp0l5DhTSWjEnmRIcLZv9QOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4RLOvLGs4IZo/DMVeMJDf+MwYo8LMgO6tdl9c4wy/M=;
 b=FaUV2CWQqeU/9FVvBXPE6A697BPaRjA6eXgv+OoKOOnvedqOqKjnb1s+u0MGG0RcyCkuTEvQUR2ih3G6AZXf/zKQFRB8ux+VgrNNSOGoz8N8l6AafY44C8NR7nq3ZHKVSoqzwSPrdknRZ9pqAAON0Sw5GXg0w0OC8D1hl2/QCdQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:03:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:09 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 16/26] xfs: add parent attributes to symlink
Date:   Mon,  7 Nov 2022 02:01:46 -0700
Message-Id: <20221107090156.299319-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0003.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: 756c8d96-b00c-43b2-f023-08dac09ee475
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GY8H9axotvzWZebeIhsAAJXjSTKbc7bjYEi3TgJdgeN/uyN50I1Pz/Wn1U0csKh4e0xgvcb36akzFR6dlVf2H/6pD/CHUezW0baPq1jRYP+9IjqsqzCYfbE0bXD1lnZ6WW7W4bTRIMnqGDLJ1oPu+Aqmdf/TC4Ad2jH6gDpE3buAKCITpM86IAa0PCtgVPsIsD5mjma3fC59tLARxoek7AKHhxakh0oJIssXw5uZDePIu52ONBMjc46xBX3pf00rBdGqtmcOrdO2Qwoj2BYY4zKpNWdnS3Ws4sypWMy+Nqi4Gd/qlOWaAwA/X5mqLkok1Hda3inrmmaZcB3I7wV351D1kFZ/Y/Ql/Rzi7Cqr/XFPaaW+H8ak7ub6AoXjsWXmj5a3Z1DVPz1MnKNySBKEhskQQvYGPK+0duBp2kDbTavl6KKJzxg7dWs1C2zBNSAEXesMAF28wW46LBSS8jn482v0KzoTpH7zSrELtut4y7p76d2EEGFn3/fFAIMluGnO5rMKuwFsTIyDuUNBA+2PEaN+89Gw2HjgHwDuPQtiHDhGeg69ToDHm0Qjp3Kg7yWdKPoHHv3NlsS7GavD83bmFIf8jU62sKa80GYdSgzMtFY2U07GY5wSomUf3c7A7q5ZGIhA+Bzn17IK4XFMc+ZoHqsexaI4fJgMO52uZVnUrqIXF3iCgd0245m5/rrfT7LlsIrNSXDTqGcqe3Cq7+xRMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c8302TisygqDV1XhugNgbLE9Z2DHOcy9DCX9UzywortY8713sJ18DzdmADf/?=
 =?us-ascii?Q?8BqkZmoOKwDWfN5B2NIWneXIAGn9YrVAB9yZyTWbOXo2iRA/kLrnCYPCyJOA?=
 =?us-ascii?Q?Rx3YR3Dzz6TIofGTy31gAr+WC4k0FgsURAx0E7kRmgutcXbVgR2QDKhVgZn1?=
 =?us-ascii?Q?kYeybp6mLe5W3y1EXXDK3cB45Ga5fEmfzdNyOlC1fg+kaXBwQZM4MIe2JOOR?=
 =?us-ascii?Q?hPf5Nhwbt3JBCoQNWkPUgqmtI1LfRUMDt/0cngTcrRSB62+DhwribDbBbRlp?=
 =?us-ascii?Q?TYXbDN/5wjNEw4OtqgUfVl7ulq1HqbXeiUxuiEl9iwVMFuuWarawIJy96oTG?=
 =?us-ascii?Q?Fx7Ip01xPGydJgZrL2UxhjiRf9IbuPD1U5FWsKo0UI6kFmc1TDuzOQV8UU4x?=
 =?us-ascii?Q?9f4Pd5sC/zf3fOg2wAwtxUWIeQmlcruKX5Up91BLNIyzB/m+n4FlTyMnWTsg?=
 =?us-ascii?Q?PsHHmEIT7rGl8o13DCcP1j/fCPpA0fwEbNG+Ans4GRMdGbNMyW33Zu1ERBI0?=
 =?us-ascii?Q?uuF1j5UqmJY4wyFba71t6Tf/uD6IQTn8i729de/a5PdL92uYazZCoVZlTnoN?=
 =?us-ascii?Q?X16U9JbkJ97xOJ4Bt1lWfk7mv3oPfDBTIfIbBnEqz/uJPmtA9p7fP9B6t616?=
 =?us-ascii?Q?iTJZ6ptLsO3FNQJ1oHW4hYDrwfhePrdD96xxLsTpf7ah1Nnrse392fkBd7ea?=
 =?us-ascii?Q?wyFuh3Elw/AybabDQH+JyqvSf4tW+mfM69foEQmrhjYIQdIv+KbjXQhQSAP3?=
 =?us-ascii?Q?fGu2WxzFkmiNJTD2nPBHJqTASMCpm6kfuIBIFvVFCBzcQBmrzi616nsD3twd?=
 =?us-ascii?Q?wKELZJB9Xj7bAR2AKS8zTFGsvioG4zQvP85BsDoLq0tT8vA93wuoDCC/fzTK?=
 =?us-ascii?Q?mZNgLNt6UgaQ/mXRP/RnuQM7AZSP/WLUSMnNoQETDuMysQzUIj+5Lb7uJrXT?=
 =?us-ascii?Q?D16F/JDLUppLHdLXKXxzqH1rAEZCo34M2xXbJqH2FJtoOTtH7JxOxw+iZcjF?=
 =?us-ascii?Q?GeDkBa5uVW2SxkS6qDlZSNsS7eqBXuqv6vdIWLvfHupJbxGjn+hGf7YwUwWM?=
 =?us-ascii?Q?XR5m+7xg5KGuReMiFHfJc9to6MrcDXAFi4uMrbHCGmIgM6DIPS9GJ44sx1gn?=
 =?us-ascii?Q?ztnVKJ6jW7Vy8oBX/ZzUlcF/4C5URKdn5CcWAazv36QahhUOYOxW3YFKcH0V?=
 =?us-ascii?Q?2tu4HOMRFan5rMwo78rneaCGS+jc8GosUP0KSQgTtNOqvndGhAeVDVYkjU6d?=
 =?us-ascii?Q?7TGLY+/+nLrBOfT85WZY0KWqIAfip5Td/R85iALNCXKRrVam9r22f2Q2E6k5?=
 =?us-ascii?Q?pEAbjhb6lEl8Hq3AIb0oQTQ1fK6p8qUGeN2qgQqob6P6PND2fqa3+Pgo5zat?=
 =?us-ascii?Q?J+wdIUGlEiMmpcErSFlR/gB+gmYbZ/vd2PNiLYWEXzVsJp9fwr6k8OTKx7mj?=
 =?us-ascii?Q?VQwvBrQ/VtxHvWoSv4fjD2KbYNCE9Jl/Pd7XHa+yXUuvzNe+pGy24AE08bcp?=
 =?us-ascii?Q?QBXqwSOmVy02nz4C74W6vblt9VADAS1WrDn1EjtQ3lu/ZCnqGjvKd9MbVuZ9?=
 =?us-ascii?Q?rnKln5yLg7oNLqL2+NzDBgy7EGr2MXfwDjrG+uO6epkT/2QGZAWsXEgoTzLj?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 756c8d96-b00c-43b2-f023-08dac09ee475
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:09.7584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 797EmwFfUnmoFq+WjLoZA9pJSHCqTNduGW1hKl68n+eoPxnmW6lCcxJ89kmhjFX3+389b4Sj/f8oNgyrROWufzEIajJ8YSudxJEFl4nDcQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: 5Se06hBWCShhIKPFz-LkcV0uV_0lmNMs
X-Proofpoint-ORIG-GUID: 5Se06hBWCShhIKPFz-LkcV0uV_0lmNMs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_symlink.c            | 50 +++++++++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index f72207923ec2..25a55650baf4 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -95,8 +95,6 @@
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
-#define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 27a7d7c57015..cf7dbd1ca938 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -23,6 +23,8 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_parent.h"
+#include "xfs_defer.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -142,6 +144,23 @@ xfs_readlink(
 	return error;
 }
 
+unsigned int
+xfs_symlink_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen,
+	unsigned int		fsblocks)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen) +
+			fsblocks;
+
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_symlink(
 	struct user_namespace	*mnt_userns,
@@ -172,6 +191,8 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t      diroffset;
+	struct xfs_parent_defer *parent = NULL;
 
 	*ipp = NULL;
 
@@ -202,13 +223,21 @@ xfs_symlink(
 
 	/*
 	 * The symlink will fit into the inode data fork?
-	 * There can't be any attributes so we get the whole variable part.
+	 * If there are no parent pointers, then there wont't be any attributes.
+	 * So we get the whole variable part, and do not need to reserve extra
+	 * blocks.  Otherwise, we need to reserve the blocks.
 	 */
-	if (pathlen <= XFS_LITINO(mp))
+	if (pathlen <= XFS_LITINO(mp) && !xfs_has_parent(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
-	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
+	resblks = xfs_symlink_space_res(mp, link_name->len, fs_blocks);
+
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			return error;
+	}
 
 	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
 			pdqp, resblks, &tp);
@@ -233,7 +262,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -315,12 +344,20 @@ xfs_symlink(
 	 * Create the directory entry for the symlink.
 	 */
 	error = xfs_dir_createname(tp, dp, link_name,
-			ip->i_ino, resblks, NULL);
+			ip->i_ino, resblks, &diroffset);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, dp, link_name,
+					     diroffset, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * symlink transaction goes to disk before returning to
@@ -362,6 +399,9 @@ xfs_symlink(
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	if (ip)
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (parent)
+		xfs_parent_cancel(mp, parent);
+
 	return error;
 }
 
-- 
2.25.1

