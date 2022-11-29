Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B334DC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbiK2VOQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236976AbiK2VNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:13:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C057B71182
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 13:13:28 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATInY8C013730
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=vQs9XXYmDpZXUpLX/hCvupqotMNxhEWa4ZzauQi2gEKTelBBLPg3Pcpmx3gFz5CoTuh0
 Yb7lsW12QVTDFJpIqUTkAXUrJjLxR5aDYL4445bVglEcokn6Yf98jtgZ6jtW6NGTo7Kk
 yfwNSrfCmcs3bYSsSxEpkCG7VZ0sv4sHU6iMr3gXJRdef49Od5DhEpFSHFkv5wgzyGkT
 5E14ziRE5aPpFUeAQElXkYS2m96zOOtTUy2YPXzZ296rm1dR1npyN4MqRlYOvSVjuNH5
 u1wY86lL6dsG29sn8NXzr4UFCRmfNRaHddQN7iDAGJQbIBwcPFY6W2dXtBSYJhmr9ctV jw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt88c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATKR6KD026793
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m3c1w1wes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 21:13:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzMfTPW/uwIdoIxCD4BjmMkWvvgc9lYHPCZy3biuzSvOuAiw9aTnwbFPsym6bxBCxTfY3fBEy8o55uEechobIjJvxap607dNHsV5oD26hVkguM9fZNYix4ObQAXtnFEAmd7HzAwwMWtbn+3QaHR5jdfSDesPHM5CqgiUSFGGewFPTzmMtMSaLC3R3LRjh94+t9GRkr8leWTEXZcm36tjJcfYoAI1kZEVaT0aP8rxTXew48js1RyTv8snOd2n07a8Q76lc6QfGR8YHoQC9EK3MSl3a0kegKCMhMfVsaG31FPfbjUiaw/s/5dgwuMwydOWkvETEiN88oMdb3sCqJ3cuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=k2Pv8pHtw/8DzlJEYPGWgc+ZGUMekPEImhJXy9ANnkqq8sbC3Qisz4u8Fr4WT4+pH7ne0ATkNfv95sCZyPjNKbYKhBt16HSJgTVm1Q1Hn229LZQAm4CreHB7GPAKd4bIGfoWRltXaVnvhB54yNqpBZOMUjh+faIoe6TAdQUl/9ySHg0qZ2WT5ex5uzS1VZ0OZcR1oRfUW0ihStuJFrB1ySH20wuY613Ml/+BplZftIOj7kHpvu2OrlaOWxF2KiJVAJxjDncIGqDOoXJOr9orDU5oxxNkCk80AFAy7EfLQgSvcIt0Qu7l9vZckraL08ujm3O33lHv+wIpbHGMhzXnqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=OSZ3LUqWe/UoyZhqjgaAhB8jmdV+CV/9952/gV3/aVcCO8btne4GpSxj/KLQm5qlVHFNIUEMxyGAVvP68R3S4qZv6vPLeOurImRaTMT7U+rf7B3NPDdJRYYarpuVdeO92b94Vx8oeRhuteUAbIdBUigRYOlBGf9e+7S0P9rpTY4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB6205.namprd10.prod.outlook.com (2603:10b6:8:88::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 21:13:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 21:13:25 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 26/27] xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
Date:   Tue, 29 Nov 2022 14:12:41 -0700
Message-Id: <20221129211242.2689855-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129211242.2689855-1-allison.henderson@oracle.com>
References: <20221129211242.2689855-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DM4PR10MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: fca4a82f-ea65-4717-99b1-08dad24e8d93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yTvOgDE3bdecWrncst1QmlYHR5VVBpawnS5+asKjtfaNAu3meHW2zXq+ZTYn+AFch+sfTVodKSVqyaWOrss/+l2ZZj1C5tmnTEeNbveQUmoRjJilsuloP/p8sHjD+Qws0kpVJdb4TVbp9+oAeaI0+R/gAYRDLvwvOmWd2BBEwiWXHU27AB556IqnW+WbRG1Iiou3GaO4sXRQkDmGrhLDKgQ95AuKoSx1tiyCtqwPMDdWWMmRDS72MguosV5x+8yNtM3wXcMpiSpSEt8JK8cp9o0Jyj0q+IO7KaDrh+3l8qbIRkihlAtxpdKriv/89CqS6igEGte9Ze1egw1NXeboKd8rlqzl/gADAzbdBHxlLy0unT8Vx8O8FB9NoaGf2y8H20/y6B9c7Ljel3bkoyPDMt7ljELgrLpB3N6IJ/28cIHSq/cqMNlCSVAMvFW+EsC21W41tfT5XDvOz+fm8xmX68pg3nPvPg1CuYkp1AwARyza7PoVcHGVdAfkde961lgjnQ6BicZndZ2nJ0w5cQARrRsBaeZ//f6lWsZDW0sYrFyxlStEEtnwmiAl9gcjeaPOMGHNnJmM2zJOKXvmXFur1KjzREphquw/uADzfT0B6Riy79i/PhVs5ZE3Ho1ojOEB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(316002)(36756003)(83380400001)(6486002)(6916009)(1076003)(2616005)(186003)(2906002)(41300700001)(66556008)(66946007)(8676002)(66476007)(86362001)(8936002)(38100700002)(6512007)(5660300002)(9686003)(26005)(6666004)(6506007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0drWTx2YjQu+fS9O7nJwydvr93KmVS/Y27UyA8xQhrkT8lZs6axT9TMWmh8A?=
 =?us-ascii?Q?10oYsRHwX+KZP1H3QgA8TNHFiaXsBO/+5fcFvjlDMnCwCGrMra8l17UD+WdI?=
 =?us-ascii?Q?OmYzz6Kvcy7FZuO6m1xufbi5QgIQdoi/2a1SaYpKXhbCeW46VboK5J+H6tpe?=
 =?us-ascii?Q?WSAMSWIkRq6XZ5fuZYUHc9YzlgLvMaom1ZyiRGCmjsbNyJmkuStenAeGweR4?=
 =?us-ascii?Q?sVKkE7hzqySjDV+x/mQXREoCHOV73TQX4hTDQqkaJQG4w2mG1PqWrdehNgN+?=
 =?us-ascii?Q?m+Q9bcybdnALB4aTh4xIQBFz2LeDoj4w8SkFQt0465UzcWy1gIqakaLOnhV8?=
 =?us-ascii?Q?JDA9/xTureYdhNhzPOftGPVCXiH1GcCSEvBIcfc715wF4ur8W/WbXELe40YC?=
 =?us-ascii?Q?yJ7ao4CJLtYpxKJUIu/JJbLEGilRCzBX+FK27es8ZV/hVA9/MuLNPVmuVGb5?=
 =?us-ascii?Q?y9Bpt9q9G5WYPPw/uYnUMWkxGyaIUY/JUaDDEBu7TGONxrTCcC4+cx71VreD?=
 =?us-ascii?Q?Wnd2Fo5GpoIlxVqFl0IOb9vDAlZ437QLsLEnUOey9ANwryHlKd1WsqiNhlBa?=
 =?us-ascii?Q?+yIqAmQFAeeXeA6CmuEpnwUWPahvb5PrLZ5MBF3ZrLHgxajzdaP8Ad2Ud19C?=
 =?us-ascii?Q?KEhuRN5Ho+ZNOY/+ZNIPZvSsWnK2QIi+8IkbF8GN36vgKtDJuoOcwk9zmS4y?=
 =?us-ascii?Q?MSRZpY6O+T2zVamIUtPvXYB4bZmRXMKMlpiXLrk7nQxMKN4tdZBxVQKHSPBK?=
 =?us-ascii?Q?J+b3FwbFFJvJIzqanUl5UdtTmQDVAD74dGY2vpX0lLq/pP8p+zdV7X0CPiZr?=
 =?us-ascii?Q?VQ9RXDMO9jWNLoQZ4nL9LaqFGjUwsfs90HhzboJw/8zWPiMoPz42Yc3AjUvT?=
 =?us-ascii?Q?qpeXgTWlexzDnwkZ7/hui25hlpz4sfk8kL9xBqAxs0D3sDavBz1uby4hCohF?=
 =?us-ascii?Q?ISL/ccg5e/KcCUcqkWPtygXaOsHM3/DDyfqoCDlj+37aKaT2h0fns/qwtA9A?=
 =?us-ascii?Q?EnTQVwRPGbK4+8FqgLj3C/PMQscituacyaQrg5Ru5yfmI+r+eK/+RtiYbXFq?=
 =?us-ascii?Q?JRPVXabgPHoBdkqc4s+HMRlTW1GCr7CErtM3sSu15O3zfF4p0P4zB3IvNp96?=
 =?us-ascii?Q?0Ue98VflxQ1jgNpgsJ/6ks+80Zss15Q2tP6o/0XVxQsi++3fLC0YG+bvNxz7?=
 =?us-ascii?Q?/ibUQTW9HWj7rWv08Lu9EaARGfr74PIcDEh8avB0bztc5RnUNH9RnrquQokL?=
 =?us-ascii?Q?PARvwIuzBuRrLAYZguwYrrho1ety+3Bh/YdzGRcCiRK/h1qMRj2i7eUn0+Gc?=
 =?us-ascii?Q?1/oTVcRKMz+3uLfkmEJQJqpb6TgwOJH5vlTB/9y+Bm/OGqAqD/k7p6Q+hw/l?=
 =?us-ascii?Q?e+IYEQp8M+fIgn0tDDJf5uxMVZ6K5fGr1/FFVeWeH/5KWcJUbSpJTXz14ZMK?=
 =?us-ascii?Q?v2CrUZPLYYIkselBzLkIhVOJ7h7EjgU/893sgo66kjjiKfpN0rqbefTvpMps?=
 =?us-ascii?Q?WLxuQDZ8gpVoYfO1X/w3eXJac5lb1xvlaGTuplRsT+LhOgLCiMoWEVJmC+27?=
 =?us-ascii?Q?pJoU5/Vwbg4CQ4OvoPm3DIjWaFQ2LylcRCQWivomxj5JD/c1Qte24ZE7N7ne?=
 =?us-ascii?Q?mA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2gu0S7qppOpMC3mVVj2Clcup6/U4Y5jZl8vSHcgwRnqZdG/yRx8ZO65KvFfzU6kEBswm9YDrCefSWbLR0G2I1yoNTv3XDtB6nNXDvtaBJuibf6757c48nX3yxMnCeFnO23wucSdZfHGJpSG1PsFCOEqGLEYjDEC1byZ252eRcqGcBSsJiFLkBuNNYclf2dwpnWhlQkvInyR3OnxpCnSmUHBq2Bji9e2pxJVsaWpWIcYcKysEQMFjNWaBYX8yi+qfDofFot9q1+4kp3VI5tRRZqqeNKyHNL77LFfgKxoKr6BgSJElHGcGiDIl4gXGRKlVaH/x/QNi9WPEaaVHgdZ6Y5j18jtqgemd2STtSE0eo6HRLXa4NMNEDq0SJFD7QVWNt+oY4Bm8EvbvN3M+G3J9QBTCyqSNfgc39MELKrS1TWG7tHNhHVL1Fgkgtt8b+ZU4YPoQYY9rbyaF8oHBw+j/WpCHv3qN2He3mEyhrvmpM8rKC50PhBALNOpi01u3s1IdJockSwFCf9ptnfdYprj93uhI4FA/D2TCJ4dQAgwF5k7KM0Gl+PslQWGrOGVUdKCdDanMhfEjCpOXtFIjXozZoclU0yZ6sOLu239ywHfsklPYrsc0rATYlJLSnA535BWP06MTtFLPLxuk10TTjAMid0iz6FTuntExygt8OamruLCdsE3+1hUy+OUC4fbQ8Wh1WVUOW3KHWMHqW/J3w4peCWcGRSGh59Pp6jLkYS3YI2K9Mz+mIs0Mji45cTrtchq0x5tMADpDdeQlP39F8DNqRg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fca4a82f-ea65-4717-99b1-08dad24e8d93
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:13:25.2295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aNaNQQqv6zcgJvkxyZzsseLsa6Yxy39UeTuzRfCF9mJcD93xcov74A3TPzRsr/NMGez4iAqocmmgbc90Fbn05MUsXdWN0M39JlQVf+f1FFE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_12,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290125
X-Proofpoint-ORIG-GUID: ohHq5UjKzAXrTszlA3bE5XHfraklr8Id
X-Proofpoint-GUID: ohHq5UjKzAXrTszlA3bE5XHfraklr8Id
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

