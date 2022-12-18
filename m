Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4434CC10F1E
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiLRKDa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiLRKDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401C155B2
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:22 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI1wOWE029115
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=geWvvCvoKwcsR4SdXeW16FAlpfW3zsKn6xVsjg6OarA=;
 b=2+tUEL7/WIT76gVIhcakF03uXItUcb7WkiZUg4/zjfx8NkjOoSro4WuNOwCVS0s2qI2d
 V0uactHYX7nU4Jj5wQMZL7m6fd9EdxG/S0SuKikXyzmdg1CsY2MZ+J6ZNJQMcLjy8if2
 wmYaca92CuqQ4FmirUST5an5QTncNQFlVoBnYpxU5m5iwK4WWjImqZxEpiZEdYsbWv+w
 l8W8Qh5rQpMNe3xnDhIIra/TGbPpKGX16OdEym+sxGVupOybP1xbr6m4MIkYosU4c4rt
 DLgAVJqY4tE0lg37dtfFZwNVnR9+jDK70bGHIJxZceHn9xrC0ePMbzcXu9l5x8LKTvgZ ow== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tn99gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI6oEpL006541
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh472m2yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvsBpppHXLME0NA7B2DksGwO+SxmBqKei7rJDj9mfWmTuBD2XQFRV/x19RIO2o6pymVooq7G6x6HyNIeHZ5pxlTrlGekJ9fAlNFsn72Oz6h4GuiCW+ywWWReql0Gb0ZXokEOe4OETmDFjAWRJphcenheSiEx9JzhBXJPO7n+uMs9AnpDRhs7hog6u27uX+U191E5LD/m9ROu0sawyBby1N8v811V9cly0L2MqWacqBN0bBOr9UuREfsp1kMx0T0oyYO3RrzgGG7rgNtGsCozShW6cCylohPQBSsylOhK9dNxZHIc3AhPQMNje2n67601TQk4WXj+gPaHT8bXwVkoJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=geWvvCvoKwcsR4SdXeW16FAlpfW3zsKn6xVsjg6OarA=;
 b=RfahmQQ0EhhQ2ruzN4HMSoQxHDQQGN2Sz4m6uIaxP7himNi8E0KxChLyFpTpbVzEuWUlJhJ1INOnU4kcF3lwhcP3/O9S3pThz1BS0VOWRX9XrmkU7PGRJOd6rcQjAgJqrPKL/h2xX38ntRPpmdzePZtcfzwHqM8FIeu0YAmv1ksDfTm60x3wCzv1li4YIraD9UtyeETpN2FHREpHr4oBfuCaeBkOaRvNyuWiZQTpLlfhBd8Y/ZK93pHb0ZgkkBWaavEiV1BhBUwN5B5m2yR0p+v2JPJdCok4WktYgt5av0gHM2PwzTTd7qeR1v7p7Z041w51pHyONiZfAPWC/VyB3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geWvvCvoKwcsR4SdXeW16FAlpfW3zsKn6xVsjg6OarA=;
 b=z8BxAELRdsdYswr9AWTblCCdqNQ6S1A2xvrGA8bYKYxVQte9F4GkDPjrqdFODiCjVHhc18MALDApAItVpKzVWkrz/1WuSvE8xanboTaNM1m5QWnnExXzmFet/rIPxv5/JdItGz1A3JCKJeP3wALWotrNYW538WAMe7lNNhkIu08=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:18 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:18 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 06/27] xfs: Hold inode locks in xfs_rename
Date:   Sun, 18 Dec 2022 03:02:45 -0700
Message-Id: <20221218100306.76408-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 893d7058-2236-4244-0858-08dae0df161e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOV6ZVfDpGqHQvu2e9LOfKsuTJTLP5ZOgTv4jN00MZbZpPeENGCmSFHg2+9Q2KaKhwghm5vOY1J9SS+aO3TjK1SJSaJAmwHd8kqNfkJPbGqTMv3ZHbRuANU9OlbkGZbBSfEvdGOL/mUDuCcZNITkqDFqxjS+5YJaI+Ip71jAekBSNFoc8ztWyjUBVvHuzdzJGf0CLcxl69MbtKB525llX4m73AAzp5fh0eDTSpA4CvpNdHce12ZHviwk7McIhO1xIeVfd+xoNZ71I1fd/Q5kT0aXULGe4yOdGObyXu0yMsmzKpq4eLF9XA6+GIgtE3Q4/Tu0sxwSpeO6iywLjcqP26L7tlN+DwuRrLauo+CLEktHGqQTPJX5lUkxmKnXYjIPtaDDyhQIsbGXZb4gXRIMGFPfIhNe3TdWi5v6zQomf4Uq7oXZ2WyawEAmrV9/e8QmPVHe2fBAVhxpYBmDnhTlaIr1+e6GxAXVDGQL1GYvF5jczSRkED4H/AXD0GIhqtP10Q3ZUV6zeBnHdXvglgS0T3TXLrUpkLtpknZNft2pzYtToq5ukz2SQD57SKIDZxHWy77DSL6Jo32+HklRnspsj6C63O4zbYgtTmAOMLRqGe55c6Z/94WXmauS9P6U0z3sr4i26Bj6QpqHjubeZNuNaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mfV5O1kbEPXedZu6owWvv7mzJCbvBOO67MnGBmJoLZB4hdDYjfi+begeFs6F?=
 =?us-ascii?Q?CqKHqFy+z41+IXUBUSc4PcAPCKX0To3coueEomJGa5ooawbzKqD1f+qfB6uA?=
 =?us-ascii?Q?jfziclI8ybfJ6iu41iZgbi9CjtODK1yc506rjEq7mljBvmugo0TiSNKP8nJX?=
 =?us-ascii?Q?KiwX0QnVqRM8CQv5gVrj9GTZBZ+sl8bbMfMY/8zEzE2fCSWY4uORLZySL2lL?=
 =?us-ascii?Q?PxqQydWN/Zjd3xNn9ICf7EfvX7YeZDRriT2qPvgOfaHQUlCJWRUMH/r/7Ejs?=
 =?us-ascii?Q?bazIEYzSpaAdE5ihqysOg2WcwW6hjD/hCgZj3Jq532rYHKh7tEom/VKPldTH?=
 =?us-ascii?Q?0ixhfQ1TAwghikLIWt/hFuo0NvB6eMpAt2F4Zr+06wYz0gvisctoW/2JFChF?=
 =?us-ascii?Q?+hEFZhQirv7R6l1gcMzRJj0uEER+pO9A8edlVBbbuvNXVdxtls4WEtZnibcH?=
 =?us-ascii?Q?iPTJxcXZQaVqZhVQJXYrmM9E3Qa+CGdb/2luCDeyrAAiz7ILusRDBo5rdXW3?=
 =?us-ascii?Q?DWP+eviCJh6SvXmPcBmzjCvaITPJbFp7oUkIL+x33LPSW922X7MfUiMiTfS7?=
 =?us-ascii?Q?76gr0CxgZkQoTGazVWrUqPBcyDBT6Wko9EHnT0zVvP0/dhosVkHibBWW+dT7?=
 =?us-ascii?Q?zEXTAmgsG1FAbKEKAr0yaLqvFv8fcUjlEEqz8RhwPB42HMpRh+SbxfF7My/r?=
 =?us-ascii?Q?kSLIKaZ/pIKfmY6YS5yie75P983n5NGv/PTsUODxtavCrnhSTFAPsPImCtcS?=
 =?us-ascii?Q?XKEv3NYrNnTsrD5el4T5zpkmLWVQDxYn2KBgp3i61MZQ+qAaggxw9qZtzyUY?=
 =?us-ascii?Q?F5QGpsCtfmGqg5rRvulbI7b6QGvMDUU/SyGV+vYKFeNRfSe7k2G9+3Nrpx3l?=
 =?us-ascii?Q?u5ThEdipmzItqf//0ThWJyvJxx1N2E8FmET6/YzcwCNHfPjM+bkJumeDdM9s?=
 =?us-ascii?Q?hXnSDsFu2NbA2mrX+p1waMc6EB0rov1K8I/xm5Mty0qV6dK1FqXBN74XC7Pe?=
 =?us-ascii?Q?FNTh4jveMiZJdljwbf2AvOfdpi01g+ubRqdKJd1uxYt2BRPkau3utqUmTcZP?=
 =?us-ascii?Q?bSvwBQTSHFy8wklCv2725hXZwekpFfKMf40/LfFit5mHNFhhfjP/UQ4wzzJp?=
 =?us-ascii?Q?gx90FIvBFPYw1L3InnaFvI4naHI8cyT1pDQOyzjjRjIjQhAejWgJPQ9A/Kvm?=
 =?us-ascii?Q?ctjdlghmpxgPUcBpjsRMewYdHMuqVbtcEW7poSFkgISV5qtXBOtAZ3g4n6Uq?=
 =?us-ascii?Q?9ECCv2a/OGNwNbB/EO6ehk3T1oCSzppSi13m0tBYw+3O9CDEeaurEKl7BFDN?=
 =?us-ascii?Q?Jx+yyFJ175Gdo5lFJuDP3h+PXvrHV/QxS5q/Bz7IVigBVqPy4M9KTSq7/TQz?=
 =?us-ascii?Q?NVvclw2KfqjnHT6lZ5lp/8CSmav9aAkbl5gTGJ2Oy2okc/ucWkSrTS90T4yw?=
 =?us-ascii?Q?DC5wb5bM4PtR+n4wS5DpXn/rf/Q/uBNqXGSzc6vrMVZ9VfIx37CzUmQLBlYA?=
 =?us-ascii?Q?katjAEI33RMLIARWiLxmKUWyyHHFJd5cm1nDAWWrz5MdneG/X31jLBEAwmuO?=
 =?us-ascii?Q?G8ZFg+/2Mn/RU/K/lhj7/elPtdvv1/i/mPnPKX2ksbpNGZOFq/Sko6lbFdRy?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 893d7058-2236-4244-0858-08dae0df161e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:18.0209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lt+Y9qaYeoIQoYaAYgEOJZx/BTqUTcSQf6SQ6iSPEqVzVHV1zLNmAJRrGXP2sTnHDXr0RbbL5VXKGu0lIfB59Fb7OwyasMtlHBxqb0dyrXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: D04P1qfG0pDQDzNVWeRx4hP_hJLn1rs1
X-Proofpoint-GUID: D04P1qfG0pDQDzNVWeRx4hP_hJLn1rs1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_rename to hold all inode locks across a rename operation
We will need this later when we add parent pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e292688ee608..4b39ec7fa5f0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2541,6 +2541,21 @@ xfs_remove(
 	return error;
 }
 
+static inline void
+xfs_iunlock_after_rename(
+	struct xfs_inode	**i_tab,
+	int			num_inodes)
+{
+	int			i;
+
+	for (i = num_inodes - 1; i >= 0; i--) {
+		/* Skip duplicate inodes if src and target dps are the same */
+		if (!i_tab[i] || (i > 0 && i_tab[i] == i_tab[i - 1]))
+			continue;
+		xfs_iunlock(i_tab[i], XFS_ILOCK_EXCL);
+	}
+}
+
 /*
  * Enter all inodes for a rename transaction into a sorted array.
  */
@@ -2839,18 +2854,16 @@ xfs_rename(
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
-	 * Join all the inodes to the transaction. From this point on,
-	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.
+	 * Join all the inodes to the transaction.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -2864,10 +2877,12 @@ xfs_rename(
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
+		goto out_unlock;
+	}
 
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
@@ -3092,12 +3107,13 @@ xfs_rename(
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
-	if (wip)
-		xfs_irele(wip);
-	return error;
+
+	goto out_unlock;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock_after_rename(inodes, num_inodes);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

