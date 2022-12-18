Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6DBC4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiLRKD7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiLRKD4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:56 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5FD9FE0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:55 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI5xtWw012952
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=X4vRhx0gklUDC2Z9Zalg72jVwP+Fbu7HxQ+hTNk2yX5TBbLXg1bQqdxkyz8+VzzjuqEZ
 rCtn75a7N0uZklPG9qd0JR6R/YWpoZKaoyQY1gzKZwEI8PfjzxGc0P8F0VqQziTQHjEd
 8egyN9tiWwP2nqbKmNlyYpCtwNqMh1GSnNDYZJAQT4gAMkZXzziExDtDRv3+qG/6WCob
 +oRLNdzOA+EsRjky/jWr62IJw5HxYUjwJWCp6ta2hqYFpZJNaX+6TTKqts0XR6RbbjEF
 hSegNrPSWRLH3pgln0QqsmNCsfRxe77m8QTKeezMkEQwC2q1c/gJpNtMNETS6Q6yjjle gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tms9bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8JeXJ024870
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478mxs8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJ5+ZXSNMfXiKQo4+RoPivt6lIfb0Istv6SNCJuUaXwKOJEPIocALXH5J0k2jGS+0+e8zwxMezcJKxDaMPbHU6ejMyP3NCTDhoPtFhbPgpVU2/ingAx/X3YQX1bwroxRuRIC+DSDEsDvATmD3UeN3PO9tcXxyPFCSsdG5Ne6FS59azIF0zZ1nj3a/7ox4gm8a3o3RYP7jwGH8+N9afq+j5IlWU0mvRYPcI9HY0kT13xmrOG0lARqs8cbbTntuDjbkewA3agQwWnj2gs+LrDpYZHk+NAMuvVwfRUPjbSIlJ4Mi+NiE1ogz3lySPGRqMgJxyhS/jPm71AxUS/+8cJpgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=lwzRnOoO+dqQIqnhZzlQ1jotfncV6sWWdx1MMds/xgMQrTLeuQfPwshleUTMMLkNLyC/21vTUWmVsr7aUY1m88dO9hmWLUxk5smWJN12gQTonQ8AI/SIlZtNskRkARNHjzKm5ao1JY6CZa1b3Jkllhaepuo9iXwbbdlsk5zxs65DKQCFEaV50w4fZ3nilV1xir6NIl1UeP41zCRORjGISWyD/RzeXIZMPD/q0wvNVldpFnGARgCkuCaemqTMu74/HxHZDj341O6UrHg6QV/xH8aL/LulBqWBx74cwdCGKZYV0Oj+JSIYXu4S8ghTsraWOPteIuDDI5/oliy/troeAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=WIllfz2Tkj+mRW+tPWzgUL726yObNyM0kRAZ+41w25mBuTrYTqM01OM/xLYn0XOrlkmaoFHvwiAVyR35M55gBtduf+Pg9493I4G72ITlpznkF+U/GJxs/0m6eGZ1qQNZRD2wt6BYLrb6YWWoXkvFjE3Xo6EbGhfv9AJwfSz/P6o=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by IA0PR10MB7181.namprd10.prod.outlook.com (2603:10b6:208:400::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:47 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 26/27] xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
Date:   Sun, 18 Dec 2022 03:03:05 -0700
Message-Id: <20221218100306.76408-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0389.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::34) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|IA0PR10MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: c501fe9b-2597-4c71-bb7c-08dae0df27cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x/gt+hkf42PvyhGn2IaTOT6KtR23O+ZzvvGgY16FbxPCdqv4vsZoJzIYqte8ym9mdsBZeUft2Wp91AZKjBTnNg1OHEWyC0oD1XSYv1/MvaY9NGnPjXsSLUUdm45K5w1B7C0QeyXqYNrctuAyuaEfyM5PW7zgR9/Ofsq4FtDl4oDZiJ83RgVjiXndTZ8dmXW84zG5h6nd27Tq7D1WWCvZ6B2noORQTWpWqMnEUnqV2f+m1dU8iqPIRb0Ygt2lBMhbZFcyub4UjU80J5b5HydoIY635jDPp0sefMFnzIc0xWRw0fkf2aL/0rClsBLrodk3ox9hDtqz8R/ZjIiVkNVuCA+NkPvECcb0w5Nbg+1aAqpMScFjhX/nE8pmaWVC9TsMD88VpaVxF20nv3/VtFG1+pYKNXKcrfpElHGuur1CTFnXO04Bnxlbq/bcwAPgNBRQj4leeOQt+zlpwmnTDo1eLuXdREuPMgHPiZ4xzgT8s1EFu5Et8auVEuxkFqWOu/jI68sOiTRW4tvnLK1EPZIYjnIqVn7KQzec5f4t5h6G72YOZCBrdzls/k3BanS+HsFo3BIpEmmaH6deVEsltR91f5bu+mLtcUnbg9bmkYedHJyy+SKtUsCxjbFZ/zg19ni3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(83380400001)(2906002)(41300700001)(8936002)(5660300002)(86362001)(38100700002)(36756003)(316002)(6506007)(6916009)(478600001)(6486002)(186003)(26005)(6512007)(66946007)(9686003)(2616005)(66476007)(8676002)(6666004)(66556008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xwiuze93jYRrvy3DLc2XufFpVk5XvgwNr4xp9fxZGq76/9JCZX6JZjcuuJSr?=
 =?us-ascii?Q?FV4ECFWXEOaL7RHACPIt7ts62mnjJs9fegCDNEtmP6B1Jltu1TaI0Uik+7kp?=
 =?us-ascii?Q?30erM1/2btA/+PHbp4l2IVTSAq1Efw7dqbBI18AHIcS9kqa2oKvl5QXQgHSH?=
 =?us-ascii?Q?0dEQekBpVdvByMoWxyMGMrn4nA53YFj2pbR81/D4uWJHqyEzQ1OE9Vy/uetD?=
 =?us-ascii?Q?ybVjbA8UvYs/9/z2cQIGCCIcyqL2/5WyZObi40C8dQwAnRaS/N3w3Gw5s9aM?=
 =?us-ascii?Q?IA/iYY96U6x6geIH05AlMwiE7w5J0MsOZYB0gdtMgBO+VgJvM8muzZND0t17?=
 =?us-ascii?Q?BzUvtORSPurnXvvf8luVn175Ual3urVgEROpJyz0rgwZAqaLyErBfa/JvH90?=
 =?us-ascii?Q?0h+pssvUIK0C0IcB/afGD8MKfx2wCFP6ShodpMLUaWLxo/O59mq95yz0CVaR?=
 =?us-ascii?Q?P8cdIUkHlVsX9LwX7cqHj8zR2wMZeHvB9B1lU2+ERSYGq0F10N249bTAER7w?=
 =?us-ascii?Q?D7TfjAQ8pxgARy3vDzTBhsnE6xHg6aokge3/oGB70+uXMzVRXR7C+f0P2/35?=
 =?us-ascii?Q?ddpgjx801+S7L6WedMwCP6KimSTifDlstPvkJKpCkklLVmCgyEvbo3GbvHiE?=
 =?us-ascii?Q?4jwyhoANgzyu/f1JUs+RpuTwnwW7dWE3HA8dJLGE9Irj1MPCMbLyTIWzT9bk?=
 =?us-ascii?Q?4p3R3qaA1GIEn2nJ2qQxEHNkALJcX7GvPsTAa3M+e3yCwk2S1R7ZFR9+uCg6?=
 =?us-ascii?Q?kadEPXBOnRo2c+Xl1X1JAwpFIAiKpMbvkkg/cfzfVWeAKS1mF5bHNG/7Scfs?=
 =?us-ascii?Q?cj1bJBry6dOb5JCWiuO5chWwHv21sVHDVTG5V6Y1M3NOrj626UezX8TKy0ws?=
 =?us-ascii?Q?sYHN5w+bKLGIPX91RdINVoeT1IwFiLPOLuUrBVTEHBqIrWQaEn+DyXdWvhPW?=
 =?us-ascii?Q?LK98t2l+yLYgmmAGLWnwDjUCfnc+HnKmxK3X0furryuIlCb6yZzEqIxumkTg?=
 =?us-ascii?Q?vaUqhfPauehh+LKumae8jUgvA00zQE9uKv1QQnYRuj64njA37l8K+xqcyIKD?=
 =?us-ascii?Q?03eU74shGx2z/FE/owTNZX4JmIgW2ioO+KgGltk1r2zwEOM/WGgpkonpBSnv?=
 =?us-ascii?Q?DgpYNhIA/nIZqWnWu3/X1GjI2WVuearTOHKmZzRrhAusHYr1QiGYe5fyPxjT?=
 =?us-ascii?Q?juxcRt3w4alRdi5T0fx0GSUZzRHi5VBAtMgyvLAeoGJkkYZ0Q2QlQpppT2bO?=
 =?us-ascii?Q?KMXZou4sivVkQdiL0aCLu73MZvr0XSnW7M+RaU8O7ByE56z/jDqFt7upGt6I?=
 =?us-ascii?Q?SJw8l4od3eSBVqs6hM9tb4438NCzmVrJy6YkHUesNkrCP62JsRvweeo5X49E?=
 =?us-ascii?Q?cKtx2RtSbp4Ezi6wQssp/Njkdm4q+opK6SimFTgrASdYCcDTW4aolTLfylpQ?=
 =?us-ascii?Q?EgEgCxmHhg8k2ejOrdGC9NLcQz9TlzXyY52x9vdXr+F5tTHx8hwshomOlIK+?=
 =?us-ascii?Q?IfTnJ7eGxz0NJpXvyYAWzSXKDuLZGuSrpQ4oXj5RS3+mdfHJT2ngD3qTYiwD?=
 =?us-ascii?Q?qWy1mlgHLXdvES/mrnFjvBKhCiOs8xYicSqo8ME7mNL3tsQm12+52Gi8DfMz?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c501fe9b-2597-4c71-bb7c-08dae0df27cc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:47.7028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pL2UrKjKAADBhRZihWgfvIDXTjXgEYXcjcKaLs23PlutV88VX1qdnPArnd9zwWB6HJTeDhcAxy7YWnBkD8gQWNDDs7bgeU1ZUCzumqe6fmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: ENVuVMGjXcUSWQMsNjVeCiO78ie_ZjsI
X-Proofpoint-GUID: ENVuVMGjXcUSWQMsNjVeCiO78ie_ZjsI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Dave and I were discussing some recent test regressions as a result of
me turning on nrext64=1 on realtime filesystems, when we noticed that
the minimum log size of a 32M filesystem jumped from 954 blocks to 4287
blocks.

Digging through xfs_log_calc_max_attrsetm_res, Dave noticed that @size
contains the maximum estimated amount of space needed for a local format
xattr, in bytes, but we feed this quantity to XFS_NEXTENTADD_SPACE_RES,
which requires units of blocks.  This has resulted in an overestimation
of the minimum log size over the years.

We should nominally correct this, but there's a backwards compatibility
problem -- if we enable it now, the minimum log size will decrease.  If
a corrected mkfs formats a filesystem with this new smaller log size, a
user will encounter mount failures on an uncorrected kernel due to the
larger minimum log size computations there.

However, the large extent counters feature is still EXPERIMENTAL, so we
can gate the correction on that feature (or any features that get added
after that) being enabled.  Any filesystem with nrext64 or any of the
as-yet-undefined feature bits turned on will be rejected by old
uncorrected kernels, so this should be safe even in the upgrade case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 9975b93a7412..e5c606fb7a6a 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -16,6 +16,39 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trace.h"
 
+/*
+ * Decide if the filesystem has the parent pointer feature or any feature
+ * added after that.
+ */
+static inline bool
+xfs_has_parent_or_newer_feature(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_is_v5(&mp->m_sb))
+		return false;
+
+	if (xfs_sb_has_compat_feature(&mp->m_sb, ~0))
+		return true;
+
+	if (xfs_sb_has_ro_compat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_RO_COMPAT_FINOBT |
+				 XFS_SB_FEAT_RO_COMPAT_RMAPBT |
+				 XFS_SB_FEAT_RO_COMPAT_REFLINK |
+				 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)))
+		return true;
+
+	if (xfs_sb_has_incompat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_INCOMPAT_FTYPE |
+				 XFS_SB_FEAT_INCOMPAT_SPINODES |
+				 XFS_SB_FEAT_INCOMPAT_META_UUID |
+				 XFS_SB_FEAT_INCOMPAT_BIGTIME |
+				 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+				 XFS_SB_FEAT_INCOMPAT_NREXT64)))
+		return true;
+
+	return false;
+}
+
 /*
  * Calculate the maximum length in bytes that would be required for a local
  * attribute value as large attributes out of line are not logged.
@@ -31,6 +64,16 @@ xfs_log_calc_max_attrsetm_res(
 	       MAXNAMELEN - 1;
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	nblks += XFS_B_TO_FSB(mp, size);
+
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * corrects a unit conversion error in the xattr transaction
+	 * reservation code that resulted in oversized minimum log size
+	 * computations.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp))
+		size = XFS_B_TO_FSB(mp, size);
+
 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
 
 	return  M_RES(mp)->tr_attrsetm.tr_logres +
-- 
2.25.1

