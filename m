Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164CDC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiERAMq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiERAMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7DE49CAC
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:41 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKV6Po019293
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=gT4z/dlKcefMxCVPjbOGob1ZVpzAe/GYx8+A9tJE7/k=;
 b=TmsYcZj0oV5L4kmETUQkJmkwO1r97oGkUzj8nMgotqZWe0TF5CS3tODQv+8l7rGfvWuM
 mQ8ylPtXRwugCiQ3EuBzyg4RGwa2YtM37lABEwcLW2c8BRQCeFC0cYCphLQHMKCaZ7tU
 58W72mq4Mbvp1JQOkBug3XH8zUcER2RrZCKIITwLcOYN1C1zopDYooo+Nnsw8PtLaG01
 dK/Ko+a+sACR/esHa+0W6HgeOv0fWWgjppp4WTDGaiUj4AIk1Y2AfKyiXhsqvO9CNN+u
 RtoAiEqvBQMVImXhkXcRcTykrV6LOggRNkhVmH4vDWknwzTRShsS2L3LfWnK7MfESOAf tw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2371ywdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0A1O8021321
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v3nd6n-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsJ/bazfXp1GIioT22AwCFe4GKAJ2vK5jsJp6OO+vVU9mmM65dZwkB7oTXeQIyO83AXRdgd7bwcw0ECk7uqnsFhiAlCUyqninoP12dg61VfQpKJ/VdVct4W1AwH5XCn7UgK9zBWY+AIvhbPXakSGHZv0l6xgefqBa65m8qB3LKXr/TGGTW6BdgFdfCNqXdugufOJsiCJ3z1JqZKOA9TVQ6MWtVbbkrkkoP9ksWmpMPeY3DLikZKj/NXxyhLgsQ0lYzOwj45ISwDMm7usZjLJgyRV32FqjTjKx+9srK9XeH4gaqf07ECapE1DZxLz0Ah6rKQMtwhI/M4xMVQ1YTSusw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gT4z/dlKcefMxCVPjbOGob1ZVpzAe/GYx8+A9tJE7/k=;
 b=OoHG7DBBAmnq1RoFv4lrJU6N+NQki0dAMVW2BZy4LKxsngeigKKsodjo1Q2P4THanhHb1ZtcTILQbXj2YOr0fhCZhdFjZLyEAn0Tj6M98ZE4QwiJMVX0DL8kONe6I5UfPPPe1Za0LqV91IDs8cEZ/MnZ1Mi2DO2wqPgIV4maJ5HmyKpiT6QSZ/DH24eI0MVXvCRs/XODE1MiFvf2S5gnTsnbUn0Zg7McApneeF+uCG4W1rM4eKbLuXIRmG/T8BpCyfKCrDHvkroQX4fci96+rgGjXJ57ba7DElD7JMdAP/fTVx2ZU3lGhk+0SjJL/GRFKK30zS7nLaYVfFV5opm/Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gT4z/dlKcefMxCVPjbOGob1ZVpzAe/GYx8+A9tJE7/k=;
 b=G65yEN/2dGtjq1Y2Ng7PRUAdfzOp0E59qnh0ixEO91a3YjSnVJZVjx9Zg9wTLCMKUGCIBtOT36/VDM9+Xuv1Iq1CGEUAPi3/RuQXAjIjhQfH4c9vrRQra3KvsqtVPwEV1j8XyIit8Ha2lR8/rZhr+8Ei1wKcCSN1WGJtv+WEu4I=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:35 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/18] xfsprogs: don't commit the first deferred transaction without intents
Date:   Tue, 17 May 2022 17:12:12 -0700
Message-Id: <20220518001227.1779324-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6326e39f-1bca-49fa-2a3d-08da38631c16
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1528961F3148E4885E3B02A895D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lWCF2ZL96545oiJEG+Dct7aPRE6Va9A2T71Hy4Td8Z/aOoLj78pZdHjDXajnZHuNRBnw/irvZApIfFfNKqCYqHonhnUS4RaKNExjQ6R0zMVPdncjBx76VRzBCM1Wz5bAw7b0zi05hDu2va7MPcmVLlvyEw7hmO+izsPW1evC16VRtbC2EvTEFid9ZFa71aHjPZleNygyufd7DleNy8jPzrP6sI6qkbheIJGklMEVOoAZOjcSvJ0MP9rMlBTcN/MOJym311purPSIH5RFC/mI7FHbi98mUxq3pwGSteehnbReSjjXq55uO7FL05ZOdzZdTOL3QpADaykIXVs0tkWtmyPez80zwDaO1yHHZAL3BbFnRxBGzzNuFEh55DQ5JlTACFEEjk98i+kZY1YBq4sHO0b/auUtHbv56sfnYnP6LP391U/bYrDkw7VSM9vesHspFCKP5ic4ooC/FqnlP2+vq2QlUbi2IguS62Et7VcYPPfeClvzTqhoMNvY/e3J50ffayrInrRYpgBuW9PZBNcecZzEDYtqRV9540OxkoGz+oejGsVKTYoNsPBGaJ2LZ9mHL2Sn5JQwv5/ikJ0HeK4sHJgYE35M9l0+EOGM3b/z745GnwTYyKrzacFZIaFArMjkBI/f/a7y0fv3816E5Os2e2YwPuiZqblebrufJ0Hiabrfxcg0RO2K0angIkIwiy6pc6oXSg2knmNugWP0lQndNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HONTyu0mAzIVD+OLSFdYk/lwc0i22jysRFqq8z1dw2jNM62Gmvthv8cCBe3o?=
 =?us-ascii?Q?XsUp+7MKdAxyrZ+6phrVX5bSpuuoTI7rO38C0Xz8wPNb8zmgMpiljD4pfg4C?=
 =?us-ascii?Q?TjGNQDX4pEn2AWS+58TKv+eaVZpdXqq38YSQuf3UL1qU402ZHYwwSFti9DRF?=
 =?us-ascii?Q?ze6kwVsruS3KBmmnqF51FF6NOBjeEDBpsA8/WnYRsft0U9lEABkyQ156AVkX?=
 =?us-ascii?Q?+TPRxCC2FqogiaB/1Ryj2tJmxRje5qddvVQgwubWaNxWBgjIgHzrGOC0w1HF?=
 =?us-ascii?Q?LQQ8HW98GM0FPxJkEtFvrcItLmpp5HZnrRPprWN/50fZxOdEgzCujdP1V+QN?=
 =?us-ascii?Q?EL0+UDCauOuHPnbkzyN2M+VNq5NnKun7g596DJlgQ2f8uULP6pN4x9iXywTw?=
 =?us-ascii?Q?5WkBgD/pIYqxyJZHOoGPVtSkKYP/pqzN7L8HWwdH6ZjABz5eEH8pcpWtlTen?=
 =?us-ascii?Q?K5Aorc4wFMhitbMRj33OAAK2rNbcu/EjxO1qCYbx+sZcM1oA0N1DSiuVfnJs?=
 =?us-ascii?Q?LIbZBiBXs4mjSxFftQSb4AFZCGt3YY61lcT4U8peeTtTHgg0jib3A0P60mOy?=
 =?us-ascii?Q?1Sx66/CZ+/6yOV/bt76eriSvHN38b5wJS4QH0StZT0Llj0KSGFLVdxH2q+ib?=
 =?us-ascii?Q?2il9318Q4gKNr4Shq94qpX8h0eRrgeQGoK0TMnjZ7fW2GvYjgoOgC5LJK1x4?=
 =?us-ascii?Q?QsNIUcoSEQFNMhQJ1doPNCpclLYr+gSLBE8BPs2ZtrkFtbgsZTliFSpnTUoX?=
 =?us-ascii?Q?G7y1Kbge0x8REuSiaL7+fpdtjb+f0qmIdvkusEsXGOzW/idrYwAewRrmAu6a?=
 =?us-ascii?Q?fwlAGbCEvW+2yV0zKMWQzpYlFtDl6Yv1fzSxuZ+clkqGznOaOglNxRCt6bWW?=
 =?us-ascii?Q?6M24RTpWg5UvZtCkOoiyY3oDW75/YREPkDXBiSf/+hQW1maVsdO3lt0VO++Z?=
 =?us-ascii?Q?b3IBDYDCZeSPA/B/7phXA1xQRjDYnktkV9Ap9cEb2vMaza9NFmrooQw32LyI?=
 =?us-ascii?Q?HxdovZOUrla7K/r9OH+ZU7VkhKiNo/OG5/ahx6dak/Pnlqw7UJQ5UrDFwTfw?=
 =?us-ascii?Q?ADGCQW5uhsX7vU0Lca2V/Tg4BTtxVi3hBL/iw3KlNS6KhxrZqmd0dlwBCrBr?=
 =?us-ascii?Q?uPtWnRNF+ELPwKJEYxDFYgv/Biy3YrIyHanXHqxGqSe/iCFhryMjNRxdF0+8?=
 =?us-ascii?Q?bHxCT9C4P1ZLtlLwa9UBW4fJ0WA2ubXb1cep0Nv0VCxtb0YKQzSBhi1K4azq?=
 =?us-ascii?Q?ZW59WNqzJlLs8coXLqSwckHSaGi94C6Q5An9Lm31+fc6T4DmCrqWPUdedSma?=
 =?us-ascii?Q?dj6kYtRMBXDTTENkhsPRlRMiy2Iju+i31kAxcw+IO903X0Q/JwhErZ8jsDRb?=
 =?us-ascii?Q?DSFYgQyc61S5Vy/ZXLoD0UtbYzfQsm38MJRjCIg21HjGyXtcBSGRAu+2fXsW?=
 =?us-ascii?Q?PnnenL3uWXSxU5ahKnXfBSQRpyl+6YsQyi9k3sJBOq3xkU9ae9fbv9N3pLwr?=
 =?us-ascii?Q?BQYoJuDlVfXZKoRG8OfLkykVF7nOI1XmRH/k2noKXMcQKou6/nH1gfG2G3vQ?=
 =?us-ascii?Q?b262oWAKS71QZ5tXQH30/9e8ybTL27rj72z8shKC1NvEn9kS1R58ZfiUbnLL?=
 =?us-ascii?Q?HNDaPrQnhbsEoyLOpbWYso/YmWDQ6YNjc/qKNOXaM7WqKUgFFtP7U38tPMrK?=
 =?us-ascii?Q?jafsrjxhWkyvDKxk1LGJr+g7gHMhO5PmuJg1xBlBvBtrEFV0WjGTTSo8b2LD?=
 =?us-ascii?Q?ivl2/eo/79R+uaeT7eUKt8aammtAZq4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6326e39f-1bca-49fa-2a3d-08da38631c16
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:35.2822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pt/pbTxWY8NpZjtCU2o/QRUndQ+9n8KFJU+/UEbSOoP9c198JaSgEkLhDqiukxxA6bBKfdnhJpw+eoW/+98CfNwvK3/7lXuht8fEs35mBhc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170143
X-Proofpoint-GUID: IlpYRs3ROF4WWP74lqH47kxi4kAt-7-M
X-Proofpoint-ORIG-GUID: IlpYRs3ROF4WWP74lqH47kxi4kAt-7-M
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 5ddd658ea878f8dbae5ec33dba6cfdabb5056916

If the first operation in a string of defer ops has no intents,
then there is no reason to commit it before running the first call
to xfs_defer_finish_one(). This allows the defer ops to be used
effectively for non-intent based operations without requiring an
unnecessary extra transaction commit when first called.

This fixes a regression in per-attribute modification transaction
count when delayed attributes are not being used.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_defer.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index ece446926916..d654a7d9af82 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -182,7 +182,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 };
 
-static void
+static bool
 xfs_defer_create_intent(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp,
@@ -193,6 +193,7 @@ xfs_defer_create_intent(
 	if (!dfp->dfp_intent)
 		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
 						     dfp->dfp_count, sort);
+	return dfp->dfp_intent != NULL;
 }
 
 /*
@@ -200,16 +201,18 @@ xfs_defer_create_intent(
  * associated extents, then add the entire intake list to the end of
  * the pending list.
  */
-STATIC void
+static bool
 xfs_defer_create_intents(
 	struct xfs_trans		*tp)
 {
 	struct xfs_defer_pending	*dfp;
+	bool				ret = false;
 
 	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
 		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
-		xfs_defer_create_intent(tp, dfp, true);
+		ret |= xfs_defer_create_intent(tp, dfp, true);
 	}
+	return ret;
 }
 
 /* Abort all the intents that were committed. */
@@ -483,7 +486,7 @@ int
 xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
-	struct xfs_defer_pending	*dfp;
+	struct xfs_defer_pending	*dfp = NULL;
 	int				error = 0;
 	LIST_HEAD(dop_pending);
 
@@ -502,17 +505,20 @@ xfs_defer_finish_noroll(
 		 * of time that any one intent item can stick around in memory,
 		 * pinning the log tail.
 		 */
-		xfs_defer_create_intents(*tp);
+		bool has_intents = xfs_defer_create_intents(*tp);
+
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
-		error = xfs_defer_trans_roll(tp);
-		if (error)
-			goto out_shutdown;
+		if (has_intents || dfp) {
+			error = xfs_defer_trans_roll(tp);
+			if (error)
+				goto out_shutdown;
 
-		/* Possibly relog intent items to keep the log moving. */
-		error = xfs_defer_relog(tp, &dop_pending);
-		if (error)
-			goto out_shutdown;
+			/* Relog intent items to keep the log moving. */
+			error = xfs_defer_relog(tp, &dop_pending);
+			if (error)
+				goto out_shutdown;
+		}
 
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
-- 
2.25.1

