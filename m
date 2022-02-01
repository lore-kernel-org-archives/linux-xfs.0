Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9A7C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 17:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbiBAROm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:14:42 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7776 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240260AbiBAROl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 12:14:41 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211HEBeE029388
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:14:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=8bF3S+9oU7jLOfP+rSrigneQJdDIWLsAM0Ce7LnA1A4=;
 b=aridFXYcqxxto+Rx9+WA13wz7nyO06y/iei5FCbkTP1K9AffaVVA0BDhG/c5uuHcOCTL
 RxZwxMWU98KK11fa4zzSrJa1Zwnixp5ww/DJsUSdQP125/M5JKYLHjUeyD6t0tv7tEhN
 szTArZG1phhg/q7gMnELQ6GRfldrCXP0OkdPJrWNec4gJmdcv8PLC2hG7Dq6CC3pMvpp
 iFquE36mYCDc5F+JWCxvkdq/QTS46jhhJSoxRCL3MCekCrJWp0wlOIP0EsDzB+6qpcCa
 duoaTYehtKoTOTZmX7+O1pnjWdmUGuFkpRPriG+f2HYBqJTdRnIpzagNgOI5jwnL5dgl Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxnk2k0ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:14:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211HBSuA156543
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:14:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3020.oracle.com with ESMTP id 3dvwd6k4tu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:14:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvOStiA5jDRZswdAT6yz9eUJy9mp/8Ky2Xl22BSrv0j7dLHjLwG2bEoNnqbDtCtv0Ci/FPFAGep3NujSOFfenKelTwNlUeQkTInPUI5B9NHKG7qciDVLqa2AuGvE69whC7ieoi9qgc6G2N3v30o8ZBdaC2fPqtSW8kSjZMB24vOZjjk/wTefGHQbUMFVt/yY6KzLqA2h9U7gofUSoQ5QfLivJPdbMCXwR8sjzJTH/NHkheMGTHzouYB2YE5m1hD1+yCCE7EJa3fjudWraRyy9li39mYe0WPcWaZZwLDnbJxAjUGUmwR2tluQZbPftJp0Ts0z4MChRVIK7yI5z+vAuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bF3S+9oU7jLOfP+rSrigneQJdDIWLsAM0Ce7LnA1A4=;
 b=CDbeBQj932QGcHLtvY+OQ4zIXb92fT5j/trUGl3goMROnl3kxcjalOczcKFfwg5E00erh+usKKTAg2gx5NYW5Bc183xscYoUO/8YkjSEmN5SFcYVWk/+MFsJpu0P91VzIbUkNAP+80QzgvAEdOZF3PVBQJnCwSxBldpltvsIbwnbXf2w+lQAmKUHkZSjc3Q+dI0XDtJHQVUQAIkm+fvv2+aIOHgpkhRzk814os0xppAxLwsxmTUNVqFE/YKvxDgT7GOoHkrTs+dkqWwGK9NqCyAF/tVU0wyc9Yr1tnTybevOzYZxMixwMOQdX4Za4znyoGyOGTErSJbS3huiUF7IKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bF3S+9oU7jLOfP+rSrigneQJdDIWLsAM0Ce7LnA1A4=;
 b=OAWO1FJ1cgTHK7WgEwsZm40jmEQEnLQJElr7wO+4wXI+D+VSq7QiPYrQY1AkzuInwcHD9MSvMIOiPAVgQiTcpSiob47kbFPq+84sUUXNcaUYM+dNNq7W8rS+jDZJU8JM6YZpt8sS5WRdca5cVelm6PmpkzCtVVHBQNkZ8viWFPs=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 SJ0PR10MB4735.namprd10.prod.outlook.com (2603:10b6:a03:2d1::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.19; Tue, 1 Feb 2022 17:14:38 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b%3]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 17:14:38 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v3 2/2] xfs: add leaf to node error tag
Date:   Tue,  1 Feb 2022 17:14:30 +0000
Message-Id: <20220201171430.22586-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220201171430.22586-1-catherine.hoang@oracle.com>
References: <20220201171430.22586-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:208:32a::24) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecea4431-2186-4340-1bb2-08d9e5a6531a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4735:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4735D8097B7C3DDC3148FF5989269@SJ0PR10MB4735.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+c96ba4w0fa4SSmh/FP8pgnzoGBf7T8EwS+t/eZqHu+5SMFsGISXp9l89tua/Ju3eQcDizP20Wl8hVKa06L+kCWGOHLhlPuzkrkKyDvUO5b7fmpZbDMi3Cx/rj5I5liFYVn75zddqXoSvac2kbJw5Upqb+67VnGSdGPznrslE+/M0e5R32SOgn/gZfEHiGxxa5ZueY8BHpuhLWnebDM8ta8oqYvcd4iZN1l3kG0NzMHgjuUy00+ejVloin3Igo9pb7o5merMCiwI3aEIz50KYVGcug/779cdXYKHSxBW9j1SVY8XpUIXpiME/wVHFU8gsvYodFjVp95OtxEAPskpzyIjvwD40ckKfgYz6CzJzuGgl0Mk58qtdScsx+6UxjmVs99BxTfCu7Tf16fsxZ6mnOACn2sH9wSP5MA+zJQ/xkZFOoXInxS62Fp4tg7EZMxH2x/fUU9Ms7jQjDAWhSln5ftcQhMTFlNU66oPXTd4fJ5EZrGq1R41xygbN2qPcZt7SgCSTxAD/bc4ceK8AiD4Aq7vMGD+FCItYP0UjbtVzjKTA8Uzk1bniatq/geVp20dF+YqfXv95ziBWshGd7Q+mp6w5nk/3H0ZAhKV/vbXLF5TlVpVDZOVFrPFHTeYkvbibE+9oA5DG+IpLasL5wIQrBu/A/ShpPP82E4FzBFSbwF/vp1vkfDRvxKBcXxX8Wv4i1oSZP0sFYR6wxbOAsDng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66476007)(66556008)(38350700002)(38100700002)(186003)(508600001)(36756003)(316002)(6916009)(83380400001)(26005)(2616005)(1076003)(86362001)(8676002)(8936002)(5660300002)(44832011)(6512007)(6666004)(6486002)(52116002)(6506007)(2906002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5QoJYrMeAGTuj4PCwEnyAiB/bTzwvSdRt2aEoSC+FjEPVpJ0xQX8DX7Npth1?=
 =?us-ascii?Q?wl83abAruGTjuHoYz7PSYyI+g4Y1k3FGZa11MpCp3BuMKdYPPM0daSOPB39w?=
 =?us-ascii?Q?N3Mwbi1nQtz8jip7GLlTJ+8HP4+GFJjeWYLXtlxSh8I9ioqP+zyzvpcwN0fi?=
 =?us-ascii?Q?YtZyKqyhXPal+FXAysySqv3ppS6KtOmBKhCz4X5pfN63yNOt3JkIVhNLJuJW?=
 =?us-ascii?Q?qSCjEW0lr4spoX8jLn+PkgBOHc5kKtMQxyIY/wtxnbF8NcQ78jRg47OTscad?=
 =?us-ascii?Q?M2RSjiabS6sfM9p+9vKfgiEZQQ9Ph+bZUeU+mRCF0ORwBzfHVD0/KZRFi2pm?=
 =?us-ascii?Q?Lfz4x4TL966SXjPvOwHgP4lJ3bzjARky7C+1ZaWlNE6c1dEswY5tNFsW8Wd0?=
 =?us-ascii?Q?fii01PALegQCuPRPWn2oNOHhqx0xMtFeOB2cr0Xy1QVbZXRWyRVviWEzIa71?=
 =?us-ascii?Q?jI/lC6R3zvR2XGhIGH4JLsiu4gRpGsZGXs+Nah8NmKboJrejYYDAe/IaSLC3?=
 =?us-ascii?Q?hbe0x5EVxgOdyB26tE7rjCvht3UePYDAgbdwxpzTN2keIYNZp0F7fDq3cGnA?=
 =?us-ascii?Q?6DeXBaLlwtRXX5keEdG1bJmzKWip22AulQIaytb4h4XgPgjCx+TStmdOg74E?=
 =?us-ascii?Q?YzND4vWou/SYTiSrU9J7V6sdXABWmgMKiQxgT8LttV9Z+ct1Np/6zyfB00jG?=
 =?us-ascii?Q?EzpxB4AcR43qCywqBRBtCuqbMfZ2GHp09f/47xuZajppjdI63zHpVicm0CQk?=
 =?us-ascii?Q?D//IIyeqMcIfV0vMyZp9Fl9Mm1NiM24RTCU0+mE7a3fFQN+SQcyQSYosAwb9?=
 =?us-ascii?Q?NGq0L3xd0kUFTg/9uDfg7R3FJp9gtA38ezCtP09R9HtrUVk3L/xiiTp9Ve6B?=
 =?us-ascii?Q?0bRd02DL0NyXxhr2mOk21ejN/o7QmVrMMeFnkaVgbC4x439Tg0gaSufV9ujW?=
 =?us-ascii?Q?9uBYhHi4xTa56ThgJvELZByz3P+iI7gYzK/actDdyq3RqwhBOfu4aexviZcP?=
 =?us-ascii?Q?TyHv3/bfl2CRK8lC2dCPxG3z+vInbOpDRIfxPsAYkpbN48ahpozrn622vK8w?=
 =?us-ascii?Q?Rg7LV1+bXEWu4GKnA6nzPgF5AfrPnAc3Vsx5hdOvQDgUlG4/98Ojr9hu9xI1?=
 =?us-ascii?Q?SGWuUZTeLI63wixij2lro/9w1ReTcSogOWBlhT9m57nA3u0FyTJY1rnGGkln?=
 =?us-ascii?Q?iQllQZR9ZhKpwMTU7oacYmFZWiSl5dzfC66KtO3JIqgIL3CZKi56z6osssyW?=
 =?us-ascii?Q?vErq4zakWupJRsrvtK8dREzdA+WV+NbC31qLx5F0WSqLmGukk4cI5LOHpYZv?=
 =?us-ascii?Q?odZ7qAI3J+5jqwZPAGmri3sQ+mj4lzJ6pV/p4beGsp+zKwn4hhfQxHs6/3IT?=
 =?us-ascii?Q?wfPE65i+wmiFMgX9GU8KgDvz8xxbWAWguLkQW5OAOGoceLUU4wY6VlQ0315M?=
 =?us-ascii?Q?p17VsM8Tjet8EyAMmgdE0hA3EPU2rVgfyo1wVVY7eC8/wnB/wi1kv178tUoD?=
 =?us-ascii?Q?FcOA09LW3Jin2v/tMAHsvMz4UWYs4WU2HxE1W1TuM/w5/rUVAAPgAmp7oxC0?=
 =?us-ascii?Q?cG2KV+bNrYyEGSE9SECFHznz4LvkxA7j+4sIZkgjVFZqP/HYTLWmMfBVLnHG?=
 =?us-ascii?Q?Vvt+hS8dSjfexj4+sEXx20Pd4RPAm7BbL/9lm0wozJEWyC2abktKuyHf7CmP?=
 =?us-ascii?Q?NOQUOw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecea4431-2186-4340-1bb2-08d9e5a6531a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:14:37.2281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /u/7/FXk04/QKhrWXNLy49IuJEMppSfmhW0Q55DVi8FzKV/mLISlQR+KMyBsORk6Si81WyoZbIABLBto9AcR7zDKdS64I+lvG8tD116ZYvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4735
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010096
X-Proofpoint-GUID: ivxc2-qFlhqydllZCci2d0by9UWN1SX8
X-Proofpoint-ORIG-GUID: ivxc2-qFlhqydllZCci2d0by9UWN1SX8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
 fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
 fs/xfs/xfs_error.c            | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 74b76b09509f..0fe028d95c77 100644
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
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LARP_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 6d06a502bbdf..74b753194615 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -61,7 +61,8 @@
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
 #define XFS_ERRTAG_DA_LEAF_SPLIT			40
-#define XFS_ERRTAG_MAX					41
+#define XFS_ERRTAG_LARP_LEAF_TO_NODE			41
+#define XFS_ERRTAG_MAX					42
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -107,5 +108,6 @@
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
 #define XFS_RANDOM_DA_LEAF_SPLIT			1
+#define XFS_RANDOM_LARP_LEAF_TO_NODE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 2aa5d4d2b30a..94ae630dc819 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -59,6 +59,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
 	XFS_RANDOM_DA_LEAF_SPLIT,
+	XFS_RANDOM_LARP_LEAF_TO_NODE,
 };
 
 struct xfs_errortag_attr {
@@ -174,6 +175,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTE
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
 XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
+XFS_ERRORTAG_ATTR_RW(larp_leaf_to_node,	XFS_ERRTAG_LARP_LEAF_TO_NODE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -217,6 +219,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
 	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
+	XFS_ERRORTAG_ATTR_LIST(larp_leaf_to_node),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.25.1

