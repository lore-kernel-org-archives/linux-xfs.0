Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B579CC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C8961357
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhHXWpg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 18:45:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47624 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230388AbhHXWpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 18:45:35 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OLngIf000895
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=Fr8oDlcw9bUSh+DcCl4JR7UZiAUvVmGrJpqhT2uXtO4=;
 b=POBb6QZEuqeil/CCvMZD1/XyUq1QQWmQRrU47Sy2wd3N3pbwr/B9IAG0S8z8kTt06Cad
 FTFY5kywlZd0G17x4xu5uPo9MyIC8jMODvyxpLmnFqyG7Hv8S0Lcp40wbKKB+D521OzW
 idirWeVcCovnlm02WIdcz4clqSJoG9LRJyQnK9gZmYVhidh0FLpA2XPhlWNTggY0UTr1
 ynoLhHswO31YcF8z9wPeLQ3iEH+u+nw1D4FxosP/7BewsEbzChB3xKl0LTlRj5nXO5jh
 wmwl+EyPmkEUNAvonJUnwlg3UM7PRhsPjb7A0M1EWBHEN76p01+P3Q/BK43Twpi1xkij 7g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=Fr8oDlcw9bUSh+DcCl4JR7UZiAUvVmGrJpqhT2uXtO4=;
 b=c5AD5PrRpnlGoRjs5HUYZmKRWGw8WOIOvmDaWYsWuW/7o5u5R4dr00xWAmZ/vGVuKBUZ
 r8+yofyDIPzhO63+iUCUm/EKuuXkP+Gy13Ff+k8PerzqlrMn9GAhbaAqvEzFh/S+rumy
 YvI1fNBghYmdkP1Kq1Ixu7e2Pp+h0ONXD0h6fdCsmiDHqMyD5FhlnipMwZ4xsBGNlrji
 6QOFCLMmwMwQ1BNgOKYiyQARDeIdmhl4+NVR4eIbuJVRXQnRRTOKxgMKx8mZ7Z4CWq5t
 ws5JLLC3GeXFCUYXFQdozV673cT5n+vnGAtpJ0Y3d9N3U6ZZZ0CGyIEPNm2sPY6/4X9m +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amwpd9wfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMfYQ2025324
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3ajpky4yms-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gaCmI2rQ4m71gqBaFThKfzYqW4HMnIW2wn6RFYPq8BRV0q3eW4pp5vEfR3LEOQ9lrmNiQZxtfUbA6HjhDF4jKFGWhlzp6CJwuIQYwZ+Ap+z18w10mamS+TS1Q0BnvyENwNM6gC+7wtEVe+NPhMOI3ZKmc3pKiGQJ3LlbDBedlL9BltiSVYRczo4Z/mWpmvtZ3jrdhttku7y+he3Xq/cDfrwrovgL76yZmOx2GEOuCXVN1H/xQ2OwQYnohdpK9bdQ+y5Yl7Zjiv0d2NkmhPNmZPF4tYSiDsADG4FJr/IZC+bz8bXyDvr1WD8B+Ydpb0jMSBDEWT3ONUicLV913sk7RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr8oDlcw9bUSh+DcCl4JR7UZiAUvVmGrJpqhT2uXtO4=;
 b=M/yoX0OTR7wFbzxQUm8GiLBGSMTjhWRqm3Dm+lCblKymGqEIjuIivVGWijwgiY1Ly1LFu65mspJAHKk4oucCrcHC4FVCQYdE6X7gODVecXJy9TnNRJmq1EXQcDg4hVF9JspWFsIMOZClUKwDdzA2ynx/kVSKwslq+HhPMegfNBiaJ+mL/5qCmV/QlEWprklbM8BV3PGT18jpZyaMKDPyuGAp8aEhUoqgg012QoHvPl43mVsqcJTlKeqfcw2UKv3iCeF7HkTdoBolTjAzivLHNnhVwUHwxD7N4nQDbHMQUS0sgcwTIIgxSANfktw09Wa2qsX/M6AnXgqn6WuNdananw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr8oDlcw9bUSh+DcCl4JR7UZiAUvVmGrJpqhT2uXtO4=;
 b=YhwjQoaRZ6JjoCSD+8JwHTgL5uIGXvIP1/Vr4jA0yrpbxrbn3QrvhVUXzkMQ5WpvHgAByOw8yMSerAE8AqHEw12mKCKnCrB8ibasg8R8gHT/BFACmDH4A/f32XFWwQQZvhNbNsK7FG9wnblvbnd6zdKAGAArH4rP38dm487d7dw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 22:44:46 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:44:46 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v24 05/11] RFC xfs: Skip flip flags for delayed attrs
Date:   Tue, 24 Aug 2021 15:44:28 -0700
Message-Id: <20210824224434.968720-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824224434.968720-1-allison.henderson@oracle.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:44:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8154c4e-dd85-4324-8168-08d96750c3ec
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46532B7A4010BF11F917449795C59@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mtxb4Cs28wF+rhlChNXoxui6Pn0hbh+rGD3L5SR/gSS0ZfYdHvB0db8xdeqzGblE9fJ0mYNzYCZBrloT88DxjB9nLb84v689OxXVVbgwDdtvFl3kTV1xrFWIP3zM2hRk7h3v10hioDE4VGqNfoekiYgcZIv80cqURrvmgJ+4HR0sFbkdI8bVkn2tYpTwFWUVtw0FTxYkHwfhbCP+MGlpjvszhDCWq4WjaYWBjp2ia5DoAFAdqO7xdLn1Fn3ggQdsCXLBTX9f6qTE5/8SzXmiowJGAWCScvAqEYtm/ajtC2Z/cjBVoDN7KhbQE2Ygw0Wu/riRRdYWyDSBnME5plZlLCX3LAhs7zAm3yT/VcGjVfhrMm9XeLvVYu59ZPeDPmc9hqevIjE5UI5ISj1hYyne0Hk5/WMUkEzqD2dJA74xe10IG9ZBHAf1LZ3AuNhh4kUJ7LP4ZBKq6ip2GYutFWDexXPVAkloqtouHZwrHhB7qMCWuDiZbte4OwhzFkAO0ORNLlqUm+UPgh0iJ7j/X6pgB9fbJfgNSjyyarKBvGkIT37GNaCS7knnF486Qtsp+E+yLxyiVZwwz1rfgn0wV6DY0F0gM1ojWctAbB6k2r5x8PynbYWNoYl4sWFlbrKakVkNnPoJOcOU3Ms5ufYyhihZxrICaLDtBZCPlVkFbxLYjYL5bGdFFVKqdrtHcFHdr1aW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(86362001)(66946007)(83380400001)(6486002)(6512007)(2906002)(52116002)(186003)(6506007)(66556008)(508600001)(8676002)(316002)(956004)(8936002)(36756003)(26005)(44832011)(5660300002)(2616005)(38100700002)(38350700002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lIaaISZkIQUwLxvaLJWHBpc5lMc6O4TWkp67JniJvx4Wgd+PlGOLTJbzj301?=
 =?us-ascii?Q?faZo1FEgBoZqEQ1Qb2kFGQBtCNsJQMC6my0jO3SjcxWyUFrjHTD8fdnI6Si4?=
 =?us-ascii?Q?QUz5F1DcJ2YpDSNOtXUraCZMxOTi+6O2UpEL4zmPAdJ/1ey4/QkoSoFJ4OKS?=
 =?us-ascii?Q?5N+DhdHSxDNs6H1BepfWN0+gZz+C4iUv9Um7xzJ9VyEke/RpReZHxXFE59CN?=
 =?us-ascii?Q?Rzz7OeCUN8AYidA4R8d6iWbORhvwtwDPMWv7hQ0i+5FSUrZr552KHHl1W8Rn?=
 =?us-ascii?Q?lhVj/yyQy8m363qNOZtV0hZURaNgCsWaH8qFu1cvTiiu2vmt5zgLdC4raSnz?=
 =?us-ascii?Q?D8IpLH5mPTs+S+3GMehpC6YdcqZ9iH1RIxrUVSs/3SEzAFSnpSwq0zEWcHPE?=
 =?us-ascii?Q?4QkAYi9aS8GDBgFjwAIpPWclWEjGwsIQBaOA65qzP/NrSeyCVhvLqLuZM8Ek?=
 =?us-ascii?Q?I4lAn0ifgvoyIb9fGfLa2/3W+AlLJcZX11KxndzwxabonKHn+f/UpRseDF5h?=
 =?us-ascii?Q?r/HtVfeGob8GYeA4eCCOnZFpQ0+gyqSA2yYOmof7EiMz9sxASSBevFRjTXJ/?=
 =?us-ascii?Q?E5nlm5hSmK+9R3iI9V5SC6hasUTc7+KXivrHdAQgrmZQuK3GECPH6Maxbz1B?=
 =?us-ascii?Q?rAYUIXNWPi7t0efyNx9Wvb8MffxxRX5KSw4Si0RlRDUg0ffxFITwpiV7niy8?=
 =?us-ascii?Q?mzeUChQGP78fqcJSwmj2TanC/cQg69xp+I7GymNwDrkD4RTojEwVL1jgR2dh?=
 =?us-ascii?Q?psl60LjlQPv6iFfC7wIDvqAwooHLqkApB1LaOfefh4UGGySwWn355+09V7es?=
 =?us-ascii?Q?Dvxp4AbSLotIudU/z9IA622UBcqcV7yEBthYjFwouQVsnuuUvFcWnYHFFkNy?=
 =?us-ascii?Q?2Ce6nnuhIRDgYvse1W+bJkh8gb/VYArqllym02DDFSZlZWGuL9Yl1XxhJS5p?=
 =?us-ascii?Q?WBC5baLIgdnfrXa0ig4lWR5gsRZbdZSNswo34chjxtQPMJfO0kiMxdF0oBAz?=
 =?us-ascii?Q?SV3oJzko/gQLnFx+5QvFqI7xykGbThL+xuFBIVPtyLlFe2JIAXT9Xl0t03ME?=
 =?us-ascii?Q?vxv7NCk4pHdOu2CS9r1uiuBiqyG3JmuIYzxbONClyi1uh36lFR6j98eC8/uU?=
 =?us-ascii?Q?v2vkY+KKuXNyGTJV47chNl1vKVUX78FzJ1zb4iu9ta4Qjzq+OQaTuxY8DLU9?=
 =?us-ascii?Q?tkQAofPVe1GdWliniT6LSS3cWbCdwHkuQ8QGdQxCCFXdPQ2JXQ+KWddMKfZA?=
 =?us-ascii?Q?+A/LKk/tvPgY7Q3M7sNBAAPFwqgwM6QOPfwY4rVrGSLUi5a/sqTEwwZGUXS1?=
 =?us-ascii?Q?T79eYmPYJ481JHvccAHB7rtS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8154c4e-dd85-4324-8168-08d96750c3ec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:44:43.3370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Idwdzk1sQgONOXAWokzwGdM56fH9JLWSsHrhyk4EZ0dfTZJa5pjpeciT/bJE+k0HnmOFs6S5J0az8OMsQfiWxJV52VJ0Z640jgJcglKclKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240141
X-Proofpoint-ORIG-GUID: qr_lxR9vI-9qMfZn56_MlmBQU5fzanwo
X-Proofpoint-GUID: qr_lxR9vI-9qMfZn56_MlmBQU5fzanwo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

RFC: In the last review, folks asked for some performance analysis, so I
did a few perf captures with and with out this patch.  What I found was
that there wasnt very much difference at all between having the patch or
not having it.  Of the time we do spend in the affected code, the
percentage is small.  Most of the time we spend about %0.03 of the time
in this function, with or with out the patch.  Occasionally we get a
0.02%, though not often.  So I think this starts to challenge needing
this patch at all. This patch was requested some number of reviews ago,
be perhaps in light of the findings, it may no longer be of interest.

     0.03%     0.00%  fsstress  [xfs]               [k] xfs_attr_set_iter

Keep it or drop it?

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      | 54 +++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_attr_leaf.c |  3 +-
 2 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index dfff81024e46..fce67c717be2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -355,6 +355,7 @@ xfs_attr_set_iter(
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -477,16 +478,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			return error;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		dac->dela_state = XFS_DAS_FLIP_LFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_has_larp(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				return error;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series.
+			 */
+			dac->dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
 	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -589,17 +595,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			goto out;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series
-		 */
-		dac->dela_state = XFS_DAS_FLIP_NFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_has_larp(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				goto out;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series
+			 */
+			dac->dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
 
+		/* fallthrough */
 	case XFS_DAS_FLIP_NFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -1236,6 +1246,7 @@ xfs_attr_node_addname_clear_incomplete(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = NULL;
+	struct xfs_mount		*mp = args->dp->i_mount;
 	int				retval = 0;
 	int				error = 0;
 
@@ -1243,7 +1254,8 @@ xfs_attr_node_addname_clear_incomplete(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
+	if (!xfs_has_larp(mp))
+		args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e1d11e314228..a0a352bdea59 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1487,7 +1487,8 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
-		entry->flags |= XFS_ATTR_INCOMPLETE;
+		if (!xfs_has_larp(mp))
+			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
 			args->index2++;
-- 
2.25.1

