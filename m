Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F85CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbiCAKl2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiCAKl1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBD290CF2
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:47 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2219eCiD013674;
        Tue, 1 Mar 2022 10:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Xq21wiWZIbJtm4gLlr8x4bMKNYQUt4eYtdFcjEJQ0YA=;
 b=v1KCLDUvozJw5HW8YF1Wm9iDbvJrE2oMJzay8fwtHozMnOCmimUGN1DmWyyTxX4u3xBp
 HqvsdA4QPNA0pAsU5HHltjtVsf+IfuYxweeK4m1QMvThKk8kXlhlpEFZeQ+wYT2QvZHs
 +CXe2LDSB0wTWThipNuteR1I2kcP9b6kCeUch8i5hWcedXOaUAW5FtezkMjCxFc99uma
 oJxnRSjr71CshlN9By6HpjWGy1cdHvPdbG3mV9e8l8rpXZMjH3Vmhsvwbb8A9gQUaGGz
 XPt+DxjwOsnBqXPgFvZ2B1BoPPN61ch20FqXTA14IVnoyeDrzve6t4UaJCGyRV3+T+6j Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehh2eg5m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221Aaoku034155;
        Tue, 1 Mar 2022 10:40:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by aserp3020.oracle.com with ESMTP id 3efc1456sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtee6UYGT2qMygmJwxUq4ZpMPXCv6d/32l1a4pReroVRgksW6POLytwAVhGKpqmxMHv7YCJgoBWoeDvFWyMqWYf3DsL7OhvqP1vm5tj0odgV3uS90V4rpq+RhzYI8LyOz9XjG5ZuSZn5AJpCQrcXsJG9sa6KfJeIfZsdd5TElcTW8H20Y03JFkdrxFMIdIJSu3isYn4+oJc323moYOZuxFDnBlEIvYCro1w+QspR8cZ7mRrGdI9uBxFWik10qUgg2D+Ds7D4tzMCzrlzjqV0e39b8Lr1C46ukhxFD/KqC64PbHDFablH/faab9aMY8DK5nJ386VzTpk/W1uL74Mz2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xq21wiWZIbJtm4gLlr8x4bMKNYQUt4eYtdFcjEJQ0YA=;
 b=IofWrholmRfW8wVIms+TfusvUlf+jEoXXMSl9sdJgblWA9UI9O7Ay58r9Rzoe7tVCXwMvvtYKpqq/YK5v598W6BniU0rHeyGXPpfFGQhTqXwhHylwPTy8mffeexUNJZRWFEb/PJDvmukfGL3yP28mXh5AmUuKAVG/W7+WsIuT91an1zNDQd8pKrbtl3M0uNHVQbEAp4UIExmtszLzJw9Aq9SkwzJRGWFLfxMURB/A/WnYZiCJTh8ueK1vZi9UYvnJ0tV1w1wKtvqWAx5TkzC8nNCA32KjgKQwKImmxZ5LPlJLgePaRxK6BL18ffskAnFIBBJfisLLPMKN6qNk6Jstg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xq21wiWZIbJtm4gLlr8x4bMKNYQUt4eYtdFcjEJQ0YA=;
 b=M3zLb4BsvZl4p+uvf1qJ3aaUJ9EBzXMBuhKOAnsu5jUQMoJZpig1QSDaQcnxOr3zLaaorGunMO+qgb1pcYuArqlLc2WXk1gv8kHlBc7Eee6fBebepf3tCG9h+F40ReUvVcReF7855rtGQ2vHny9qPE9SsssFxTo6W/AwVfASsMI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:36 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 14/17] xfs: Conditionally upgrade existing inodes to use 64-bit extent counters
Date:   Tue,  1 Mar 2022 16:09:35 +0530
Message-Id: <20220301103938.1106808-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6be5473-1568-428a-9eda-08d9fb6feb69
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4160A7B99428FF82A9EFC328F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: llJR30sWCs2r7rE1QEWnSu7Yvcct+qkXLOQvvAPSbuWALe4A2xpUPpSa5S9Hb8cGSUdO0NTfHxoRnfUIVQM9SwewC6dGoG4qctU01A2Gibay8QbNADgLv2xe8Wa3tmoFHPK+8poRcLGPnNftL/H6I7wnSNq1IWtcbH3egsNqdN16DdnnRnlKDtNSasb6LolYBZDsWyfgNruIX6e+Muap+r96pMpuncardHeRhWLVMK002T7I6pnoImaEDSeUYY2qkHWHsmHt5pMf5wlibSsQ6wgTCCJpLFTOROV2u+0juHnO7Z2bigTkx8lgPjEwPc49eYnOs2OLZxylOr5fTzVzRypJbf3M6qZGFLeoUiTprZW1Mo0EKBe3h0aWrQVZkc9/kFI3aXoFpzaTJSPNkVaxdxgaJ4FswWMtDD9tOKzxEyZQ+SYYY86LzR/H7DiF6w7E+NSzw9TuTSM3zDlQESk4Iyn6hKNAlxVZsWX8SWml507ZBAUy5X4im/6MxLkCcCFaTSC5/2YvfrFAcnqq8XQBjyo215eV1el7ChdaNXV8lGU7Ae7JnW5x1i1vEfbVKTWvrxtPrNDyn2yzebmARkWDhxRRNmMn2ZRzcIaQyqRqeEwXn0LPkqhhwyd0TH0RaQLLUjPldWEQ93/LQYJqZzeRTTpeKvAKsc5CipR6uVQaeXWsGKXpX6CgQIgZ9GoOzyMIcrRoBFwZeyzKNsM3qSIPSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qa5i5zsd2Hbb7lwLe74Gfn+yRRI4xjzhtfef6fx2hM26d+JhGexUPjzLmcOy?=
 =?us-ascii?Q?Mpggc8YsIPkkOK2oeWs2Lecqrvra6OLCgCqYQz3F8DUKDciBqP+LgKZDig5I?=
 =?us-ascii?Q?GdisLeW9+VRPqMcTPb94BdGrxxFnb/MT8E9KgYm58TK1tqtuZPBZoCh22CxA?=
 =?us-ascii?Q?WQ4T7v2qvXC2zOzGMGE4efRcURPt6o245BHEmKcHoclypseX88lI7yqvswZz?=
 =?us-ascii?Q?nBgSFDsI8uvPwYO/khkW/+kIcY4X+R5xmCSg74rY/ATJEiGy3PcQwUGAiW7B?=
 =?us-ascii?Q?9dWhNrI9cbqpqzoo0wfLgXywZ8exCnFOMez3pvBTOACzJgOpRsz7/nNHo4pu?=
 =?us-ascii?Q?wCGwPUdk/pESJgdCshbCVv/+oF5g8O48i0WeQRbNHbFXd4MT6LEpfZiT44Ic?=
 =?us-ascii?Q?bA8sKSEYtZlK28G3TKEo8QPiIeDJxdXatzv1mnqSSvZK0X5MPPQ7IuNVs8Pj?=
 =?us-ascii?Q?1U9X4EFy+FqIE7J6xT/oMgKU+3WWzhtzG3rPEDpSSv3VARZTvTXJrGQBoBli?=
 =?us-ascii?Q?pZqwUFPnorMNzhLQlqarGZ1ylL2hrAXWS+zOIFWf/rffLHW/y8s4VOZI20Ei?=
 =?us-ascii?Q?YKW4pQdGFu5lTFXvfnwyns49eu1PUNBN8EU/KLoy9iRnQE4fY5IZL7ElEKU1?=
 =?us-ascii?Q?P4ka9YBdOUYIXR8TwM/IPmVySgn49sUOMWQROypQfRmoA4CMSruXJQ5Gh/4z?=
 =?us-ascii?Q?e28zd2qVlyBW0b9fcO29rGVwyHUxZfDAtrJSXjXSozeVv2wbskJm5TxjlQVs?=
 =?us-ascii?Q?334inJQyi1Mta0xypMv8FTGhAqAvxAREC+UEJDP/0ZRaPZ27l5J8b56qRskd?=
 =?us-ascii?Q?KtqfEUEIk03bKpzQsGdX+hmUH1sve51Z59VegwoNWZLpky+GO9XK9vWb9y+A?=
 =?us-ascii?Q?GCu3/3mN1AwABs82TRH+8v8nghobC7o/ix0/qfVcCG6A2GACk4HNGGSY6bz9?=
 =?us-ascii?Q?XFZ2R6nG/U95ht01MIXp2VNQKSvhgDE3RgbauRk9M2Dv387pkzZYuq1pe4aX?=
 =?us-ascii?Q?kzr5r7qjUdVCQVraOYJIg8EuVqbk0YuFZERhUPkKDNcUI09EQ1HQFy8qEjPZ?=
 =?us-ascii?Q?s8eY8/HWh5ZdM3kBiTknmGkLqb4s943ywaBCvz0+MoV2FxmpbY9HgY01katP?=
 =?us-ascii?Q?Tli8KePnL1jhA4G14uE1/R+B82aZAjV7uuRpF0SPI12nQHt5NUu9NuDesRRE?=
 =?us-ascii?Q?o0e3J46fLVpBLDmw3elVJqy6XTtBrFr6ZwJdX5pltxmQBnGrPji1yEDTAGRm?=
 =?us-ascii?Q?JURgcYiqdkTT7jYfHAwFGerLsVeSvr6HqHrQ9/M6cdpuFWeG5m6/e/XEVHZu?=
 =?us-ascii?Q?cGXqTlaggl7Zs0Sx+yMJKNR/0X3xT4K4uhoNhqmyEzD/1q1vjAM0QLz8jT/q?=
 =?us-ascii?Q?N5GTjNmoBEDkofjufplRhgEyw25PflkWVG+WZE66eRZ8zpoXZ5kpe2wSixDR?=
 =?us-ascii?Q?xqOeJht8ylISEK4Fwc3APOvg8vpn4+Bb+m1841P2JWWpnXRHgkhXRdEHybRe?=
 =?us-ascii?Q?ZTJEi3W2YHJvBxHDx8Rzh04zouQ8KpmDCPpZwircJuLiUnfX0u4YqmAaZP8A?=
 =?us-ascii?Q?U2wzyhvryhEAPiIrA+Y/xYfj7daXCrQlFTBrpxriYLJJ4HPnhwKdx/Ro8piN?=
 =?us-ascii?Q?quyp+EPfTHp2MQ6ows4Xamk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6be5473-1568-428a-9eda-08d9fb6feb69
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:36.6344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y26bhqR0pcoqSQ5y7f4seafO6ONrf/lKr8SNKC4CCOe3R+6IEL1uVbIRsFHBLKfkjc2fiBuhv4cKX7c204XbdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: 6cDDb7GGvNKFKaAgwYQH6nQiMDTKobGn
X-Proofpoint-GUID: 6cDDb7GGvNKFKaAgwYQH6nQiMDTKobGn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit upgrades inodes to use 64-bit extent counters when they are read
from disk. Inodes are upgraded only when the filesystem instance has
XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  3 ++-
 fs/xfs/libxfs/xfs_bmap.c       |  5 ++---
 fs/xfs/libxfs/xfs_inode_fork.c | 37 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
 fs/xfs/xfs_bmap_item.c         |  3 ++-
 fs/xfs/xfs_bmap_util.c         | 10 ++++-----
 fs/xfs/xfs_dquot.c             |  2 +-
 fs/xfs/xfs_iomap.c             |  5 +++--
 fs/xfs/xfs_reflink.c           |  5 +++--
 fs/xfs/xfs_rtalloc.c           |  2 +-
 10 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 23523b802539..03a358930d74 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -774,7 +774,8 @@ xfs_attr_set(
 		return error;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
-		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+		error = xfs_trans_inode_ensure_nextents(&args->trans, dp,
+				XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error)
 			goto out_trans_cancel;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index be7f8ebe3cd5..3a3c99ef7f13 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4523,14 +4523,13 @@ xfs_bmapi_convert_delalloc(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, whichfork,
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, whichfork,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_trans_ijoin(tp, ip, 0);
-
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
 	    bma.got.br_startoff > offset_fsb) {
 		/*
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a3a3b54f9c55..d1d065abeac3 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -757,3 +757,40 @@ xfs_iext_count_may_overflow(
 
 	return 0;
 }
+
+/*
+ * Ensure that the inode has the ability to add the specified number of
+ * extents.  Caller must hold ILOCK_EXCL and have joined the inode to
+ * the transaction.  Upon return, the inode will still be in this state
+ * upon return and the transaction will be clean.
+ */
+int
+xfs_trans_inode_ensure_nextents(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	int			nr_to_add)
+{
+	int			error;
+
+	error = xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
+	if (!error)
+		return 0;
+
+	/*
+	 * Try to upgrade if the extent count fields aren't large
+	 * enough.
+	 */
+	if (!xfs_has_nrext64(ip->i_mount) ||
+	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64))
+		return error;
+
+	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+
+	error = xfs_trans_roll(tpp);
+	if (error)
+		return error;
+
+	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 8e6221e32660..65265ca51b0d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -286,6 +286,8 @@ int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
 int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
+int xfs_trans_inode_ensure_nextents(struct xfs_trans **tpp,
+		struct xfs_inode *ip, int whichfork, int nr_to_add);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e1f4d7d5a011..27bc16a2b09b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -505,7 +505,8 @@ xfs_bui_item_recover(
 	else
 		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
 
-	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, whichfork,
+			iext_delta);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index eb2e387ba528..8d86d8d5ad88 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -855,7 +855,7 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto error;
@@ -910,7 +910,7 @@ xfs_unmap_extent(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
@@ -1191,7 +1191,7 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
@@ -1418,7 +1418,7 @@ xfs_swap_extent_rmap(
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
 			if (xfs_bmap_is_real_extent(&uirec)) {
-				error = xfs_iext_count_may_overflow(ip,
+				error = xfs_trans_inode_ensure_nextents(&tp, ip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
@@ -1426,7 +1426,7 @@ xfs_swap_extent_rmap(
 			}
 
 			if (xfs_bmap_is_real_extent(&irec)) {
-				error = xfs_iext_count_may_overflow(tip,
+				error = xfs_trans_inode_ensure_nextents(&tp, tip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5afedcbc78c7..193a2e66efc7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -320,7 +320,7 @@ xfs_dquot_disk_alloc(
 		goto err_cancel;
 	}
 
-	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
+	error = xfs_trans_inode_ensure_nextents(&tp, quotip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto err_cancel;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e552ce541ec2..4078d5324090 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -250,7 +250,8 @@ xfs_iomap_write_direct(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
+			nr_exts);
 	if (error)
 		goto out_trans_cancel;
 
@@ -553,7 +554,7 @@ xfs_iomap_write_unwritten(
 		if (error)
 			return error;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
 		if (error)
 			goto error_on_bmapi_transaction;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index db70060e7bf6..9d4fd2b160ff 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -615,7 +615,7 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
 	if (error)
 		goto out_cancel;
@@ -1117,7 +1117,8 @@ xfs_reflink_remap_extent(
 	if (dmap_written)
 		++iext_delta;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
+			iext_delta);
 	if (error)
 		goto out_cancel;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a70140b35e8b..6d4a16534b1f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -806,7 +806,7 @@ xfs_growfs_rt_alloc(
 		xfs_trans_ijoin(tp, ip, 0);
 		unlock_inode = true;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto out_trans_cancel;
-- 
2.30.2

