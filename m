Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D02EC43331
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 502FB61606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhBRSsI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53494 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbhBRQzU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:55:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGsCvs016465
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=oPQa1+7sybLIQmDPJ0z39bQTtxT344ZVosAGSEjeWP8=;
 b=BENLhD4ucOw+2n8uF6wllQm2Jl+n3WW1rYPA3B1k7bd4Ks39erXz3Xfe0/wIFNfXsVnC
 1Wh8ghv8UyjFtXuBDVlWgO2Mnoq+a8xh8agbMkxsAnZI50qVfql7wFNydsuYfYzByQ9N
 RJtn2jKV+wcJ3F+iyP0xdu1m+Jx/6tdh8biDnNsaFAmTMOdNgZbOgK81KMLBkq34IMbA
 MITcl7sMncSz18HrAoQQrKrFvUJY8gIphdntq6SJe/z3mP9pNPrljL33cJ0IXlpz0i1f
 ZwjqCOYOO/HIB2mw+yOvO8QqNsWXKEDWHMU9+oqXSWmBvcQqn0kQx/fXXmOGrHO5CXNG Tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36p7dnpj6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoG3N155234
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 36prp1ruuc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPTTJ3BJ1gXavfJBwtC7UiQMKw8v3YzG22MAsCl0iK7VAGTEJSLjGTydlwPZcvqFMe4urWsifvly8nwyxQE8PJYjNNdUr08qWQc6Yg5XQex46HawWanZvU6XtnaAW030kjPrBBhakc9R5jvgxJ2IPsROzbDiJvZg4wAULTAxhkGjDi4+IoVeTuTcUclOIsz9FSTrGSZydh1UKSQTng18TpLJMZpKYh3/un6dQVhoqiq4qAEfjx4SkD5yXjFVuRfUaLUyeUil4bYSDxKcQDicsIBRofq/ZJ+9/BWZLiZ/+7FZiaCmB0VjG0FMJViPzUvjzngo9H75osv69opK7n8NXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPQa1+7sybLIQmDPJ0z39bQTtxT344ZVosAGSEjeWP8=;
 b=RWCbUUhHSUSOlT3VIoolUdjiyOZ/ml6oFWn22UjymasEtRuGfhaIiCa+qjMUjp7APuqpaDz6lwFFH8dFvoiEYopnfL7/kvp4KYfTPvK1yJaVvjAKsqT3AB2BgSVZnIGtehBjHUETOrXqDv5Ll7osB6IO6Cs2BG+qLDkNVkWTI0lWcvxt1JFn5vSLW/Tv1PpocvSORtn1OtiO7j6Gb0SusH3mXMQqyXsCO8qMEZVppxt7YJNWqanJqA/H/Q+qU9AgqSUpRxaUM7SDJbEU2VieMtWbvvxtNN/4v0BrG/eVCuUUbuwKhwbJM+JFGduEUNN7lPleljcmGbkOTdagqwevnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPQa1+7sybLIQmDPJ0z39bQTtxT344ZVosAGSEjeWP8=;
 b=kkn1dpYYuGB5HDl/Z4MUEruQpsvWJGgmZnq4qpB1LT0jeoDjAtlU0YbronxMYcC/Z25Axkn2AYSfhv8DsYi60oUPmADtrhtfb5lhAiIxlMfZrZCrZH+AkL1b8vaZXWKhkZuiiAFQN+OxORwY0HbcGNZOAGozYPwikseSN0e7RJg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:04 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:04 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 04/22] xfs: Hoist xfs_attr_set_shortform
Date:   Thu, 18 Feb 2021 09:53:30 -0700
Message-Id: <20210218165348.4754-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c09c94c-1693-4e80-8726-08d8d42dccb5
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3381B3771A37BD01FE134F9595859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uCvCe4kUjbFDtRVgASCiCPNcIAEd0wus5QJhux/71JpPNDC7+QVGKKXWHgiNC3WGad+674rCCm9oWmsS09GYpA0ZqMRZEDt88SbHEwE3fKCxjzDIABBXAWYNysyhv0z6fChx9g+Irj5UclNz+NwD81Vj2YlrNmG9Hm2lr368Zg1XyNSnsWLLWlaB7cIe1Z9PLZnOxKSWAcP3lDBkibgKQnpCrV/tIjU+CaZS6aTBewQTR36QDURUZGQyNqBykCUXsRS0FgueNYmS7uasdeAP5qF0GTxHpdON0BsdudXu22OEsD15yx/2sD2X4JgltjPCJ7BSQ7sBhmThMjU7YE+c1XKX7LaFw3A+InD5HIKcKH37plaUXQbniW71Q6Afsl4hXKBpl4Sb1+C6PZSVAjuhOd9p/LK5w3JdPIlQygOcmy0JDoLWjqf2lCJsssqo64FmnrrkauUufIWTrouWalYFrLXb9G1wjpXH1ueL9ZAJQqPPnrwv9F7VlCJ1VKpwqUUih5Px+w0E3EWWTmczD5wqnwtF9PVrDU0mwX1lUhz0A3RtIvk5kErzoxmv+l67vN5vWZFgB4trJH6xh2k88gZz3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(69590400012)(36756003)(6512007)(66946007)(6916009)(6666004)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(83380400001)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DZQbKDkMq5p3qpMW/PvndLi/c+CraxheqwPxC4h2D6VwzeR7G9JAmJrEg94f?=
 =?us-ascii?Q?07wOOBuyn646XnS1e9r6DhwscsSxdYqb5Cl5DtqSPGZzWjt0sNpOJcyFS6dL?=
 =?us-ascii?Q?Lo0QxyEqdtl7KJHT5sCgFBYZzCGw+gjquKjvCCnuWUNapCqdGv+D0KM6sqs4?=
 =?us-ascii?Q?wat2bP331LeJk4+9rShF76fSJ4MM9mTtwpGyfVT0JaDX5vFbvnjfoGQctr/U?=
 =?us-ascii?Q?Sqc7/xixOXjnWig0ILeIAHTZxDTXJdFH+A6Po31S579P4JB+Lg8OOd046M86?=
 =?us-ascii?Q?2jdnh86YxQPlsgJ6Y58ytdoClF9CTdZhcHzT/najdE/xgnBnGxBX1A/rHwwm?=
 =?us-ascii?Q?mTewpBr8P9/go/hKmNCm2BkAyxE6bRLAflGENMhPFC+N8QYDvW5guLSSvgU6?=
 =?us-ascii?Q?ZQ+3MYnWl7I9VeurdeZxb3N85193B+1G/vlCNexEO3c7bQUxL8Utahb2kwHW?=
 =?us-ascii?Q?ZuUXE4DWM9G+fPI9rRcKPdtasXN1CFDunTWOSqSDn2afcR2KakqTkP5SxWwI?=
 =?us-ascii?Q?RseWPK8lmdB/3i15KMSQ7oQg0waQUNz9Q0JXWmfKK7DEiFkgNgKsT23+1OVn?=
 =?us-ascii?Q?hxJvsQma/4MuLJOxMOM/jdGZsmHxOdHE63EifmW3OplSGaP/GhLs/CzsvV9l?=
 =?us-ascii?Q?zYNIehxh8NoWG8Eh0Qdr68ZZi5PbIN8L/++6IgNCGvnCanU0oPrPW8sTi5Aw?=
 =?us-ascii?Q?Rpxqm1Q1Kttzd0KeyCGX1G+VuuXP9ypW2uLQ7+Z8j6WCJOmFcb3oYO9M+Yw+?=
 =?us-ascii?Q?tAaK0eWcCh9u+HlK3kSvQnnCpXYBeSrjF9ScpA3yIEB4RllOulRolhhxucXK?=
 =?us-ascii?Q?W+1bXR64p5K1UYWdEF1sON8ALlqxKCGm3bPblicuD7R/scUumrQ2vhB9/+IM?=
 =?us-ascii?Q?5CXwQNU7L+q2iRLhzcqEYvMKBnHNU2oYlAlPJmnHUtfdyynuQ9LmA1MXCS8R?=
 =?us-ascii?Q?FN4Ee2ITRpcTP0gpwIPx2VDn8eSL01GFhocZczQm5GS6hkKWDUCpZvaSrtrJ?=
 =?us-ascii?Q?zolK3nnIBh++Ex1rAMT/5xaVZ0j0KfiYx7nce4VKsr7xrOaQ4MphRbD8SKGU?=
 =?us-ascii?Q?KgZ20HUZ56YnDDZihbbmBWCLbxwc1qjWuywOU0IQztdihnaBfswf5BysjYWX?=
 =?us-ascii?Q?yoSd1f3xgJmkQeO5O9p4LPVOLwrx6yQs4amNSSRbKAikadd3LITkrcXxiLma?=
 =?us-ascii?Q?97UnBaBr7j4C2YWrcYqMfoY8pKvF5iRVFVLphqV9gxUO00H314SOCsTDwnYo?=
 =?us-ascii?Q?ugygp4eGauKrUyyzCsB0QI82o7QoV8lDE5XQXMyuQ7WYPaAhcRuF0YqT5e14?=
 =?us-ascii?Q?gBAwcX0XV00KDghgDvl88gaP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c09c94c-1693-4e80-8726-08d8d42dccb5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:04.7265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SpabC3QzH2/ddkjIw1YPKU1VNNwDgLNANodfQeUMETdXdBgaxnLWfsHgOlxNZBmHIMVgkFaKC85Kk2gAKwUPnAmFD6/Y8E/TuKznqUK72NY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180143
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_set_shortform into the calling function. This
will help keep all state management code in the same scope.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 81 ++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3cf76e2..a064c5b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -217,53 +217,6 @@ xfs_attr_is_shortform(
 }
 
 /*
- * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  If the attr is set, the transaction is committed
- * and set to NULL.
- */
-STATIC int
-xfs_attr_set_shortform(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**leaf_bp)
-{
-	struct xfs_inode	*dp = args->dp;
-	int			error, error2 = 0;
-
-	/*
-	 * Try to add the attr to the attribute list in the inode.
-	 */
-	error = xfs_attr_try_sf_addname(dp, args);
-	if (error != -ENOSPC) {
-		error2 = xfs_trans_commit(args->trans);
-		args->trans = NULL;
-		return error ? error : error2;
-	}
-	/*
-	 * It won't fit in the shortform, transform to a leaf block.  GROT:
-	 * another possible req'mt for a double-split btree op.
-	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
-	if (error)
-		return error;
-
-	/*
-	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
-	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier. Once we're done rolling the transaction we
-	 * can release the hold and add the attr to the leaf.
-	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
-	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, *leaf_bp);
-	if (error) {
-		xfs_trans_brelse(args->trans, *leaf_bp);
-		return error;
-	}
-
-	return 0;
-}
-
-/*
  * Set the attribute specified in @args.
  */
 int
@@ -272,7 +225,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error = 0;
+	int			error2, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -281,16 +234,36 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
+		/*
+		 * Try to add the attr to the attribute list in the inode.
+		 */
+		error = xfs_attr_try_sf_addname(dp, args);
+		if (error != -ENOSPC) {
+			error2 = xfs_trans_commit(args->trans);
+			args->trans = NULL;
+			return error ? error : error2;
+		}
+
+		/*
+		 * It won't fit in the shortform, transform to a leaf block.
+		 * GROT: another possible req'mt for a double-split btree op.
+		 */
+		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+		if (error)
+			return error;
 
 		/*
-		 * If the attr was successfully set in shortform, the
-		 * transaction is committed and set to NULL.  Otherwise, is it
-		 * converted from shortform to leaf, and the transaction is
-		 * retained.
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf buffer
+		 * and run into problems with the write verifier.
 		 */
-		error = xfs_attr_set_shortform(args, &leaf_bp);
-		if (error || !args->trans)
+		xfs_trans_bhold(args->trans, leaf_bp);
+		error = xfs_defer_finish(&args->trans);
+		xfs_trans_bhold_release(args->trans, leaf_bp);
+		if (error) {
+			xfs_trans_brelse(args->trans, leaf_bp);
 			return error;
+		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-- 
2.7.4

