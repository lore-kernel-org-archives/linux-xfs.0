Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D15C433FB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E53F61A40
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhCZAcG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33298 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbhCZAby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PMEh040744
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=g9qIbIQUNHwWlS7Zujre4FbfOQJ0y679jg8pkGr60U4=;
 b=Twr9gnrLHN3TM8cOcyOhZoGHgPF9LT9XwZiSUsGs3gChUYWq7LdLMqR1WMiK2yaKsOOc
 03cRnBLvozq82PPrNx6+xnr622XzjnibWDSafKtQijvQjdkk5gkXqaIJGw0KrCipxoMc
 eH+rax9uCADdBchctgx2hBdolb1IA+RtYf2M4WKAlI6p4tnEgYYjukP+gmrkkB5PeM1r
 4m2tw0SMZ6kUVvfDz2VxaJNcg/HUqcUQ0987tj7r6QH8KKkf4KObIdCZ+JLwCUIdrHyN
 Ggn27dNY+xqzXa3grhpcrKSCmSphUbiG5qWDmdMdFXhLI/ojVfEftcBZCnfc7jPagM9l 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37h13rrh8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PKkW155633
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 37h13x047t-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hho7FPOQ6YsFEwKHtU2Bo2I+VPKu9jM9QHdizZsUWJBOTdAO3nQDpbAi2xPqazTBdqfzzdMq4IObCl7V9W4AUCrHmYfp5OW7C13GsItKAso/MCmjzqjDc5Hga43JGAMoxW7JxO9TjJoh0nUZN8cWPstB2yffgnNyGm6fm5Ev7Sjs6fuiS7H1rI7/9EbZ/r859UFkGjXq0JEh94ydEbr0u+8T2pH52FfJf9j5y9+HbSZwk5ftFC/4dk9yis+EUZOYBzTCQtEb/w+MhCmn1SYpMP3+CsT+OrzcUe30umYCyM/wBvzk1AuqVlmW5aXjE0/JzvF42fFI+I7KNk83u9LZ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9qIbIQUNHwWlS7Zujre4FbfOQJ0y679jg8pkGr60U4=;
 b=hbALwFH0W5IPFedTJlhoms440PFmziTBsoggznfTkUXE5TEquziv7ilntUABnldn0S6n+i1bDUYXPtRCYAcUk96v1/4AZWtvDn7AbCuwZoAOvneykMUlefQN3/V0bFbV48iRQHvKqZsG5X9iqYM0Qxkj3ZO/+cPOlup8mcZ9RFPkB4iBduWAQNEpK7fPOq6KXhNo3r/41Yx3MzEOHyv29sADyW0ptpefTl37CdW5jvWFp0SZ0Tj4hYp3A7lUgk1TnAZEDFlXJ2URkln2z2nRb82e86RduVr72ucuHrZpRnGx1V1apf8n3La1Mbzky9KenjkKACTm22pKRsE9X4i0pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9qIbIQUNHwWlS7Zujre4FbfOQJ0y679jg8pkGr60U4=;
 b=IraT3FYVP4S46K9Y2nnv/hq8DUCRFDe8NeQ8AoYmvogF/e+NfqaR8vm1pAQzw3nvO9gs4Vv358PxwarOPpvPprMiIJBHLr1NW9vcvJHOhv7lUJw49egtTRuVXA8vxu6PChQ3MsKE21TCOoe+E76Z8aBGlzuvq0qWqzXZi1P/kQU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3924.namprd10.prod.outlook.com (2603:10b6:a03:1b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Fri, 26 Mar
 2021 00:31:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 20/28] xfsprogs: Hoist xfs_attr_set_shortform
Date:   Thu, 25 Mar 2021 17:31:23 -0700
Message-Id: <20210326003131.32642-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7fa182d-6a9b-4570-a3f2-08d8efee8b14
X-MS-TrafficTypeDiagnostic: BY5PR10MB3924:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3924509FB817ECDAC7D11C6495619@BY5PR10MB3924.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9BP3prUT/gAvT33on1/vrqOv5LVJJTnhwimTspGAhGJWkpVXXJR0xEAVTjgj+DSq4jimH+l27qzRvIY6jOHokPRHIIqDc3rT8F1Ttv+QtHx8nIb1ssglCuSApI2okdjHW7omqefWGHq57X1uIpAX0kb2c/tKwIDb5nWgQjYXSqkf68QEWTMkBF4kMls0JR/ey5R61Hz/wMwheHQmFbcCvkig4ztQ9dTF86ytjTO9tvswovj47Y9nXBkegFQkzBwkpt9lOdovPgCh9fM5Mv2Cl7YiMKZs1Ax/eTT/SJZHa+owPmxPdNzZbGxbRcpOVY3Ta++grtaMTfx4TYXHY5Q4VCbGOIA1IvTwb6Q0+anSgdHySLffcBigCulyeE4anm62RINA+DUm+0JmPuukr1LXkFzXqTdve2A1Sy/F6riByuxnj+3R50oNCpl4QnriiZYSMRif0xIAyta/FwS/LtlRpCFxkYsRWB3qJ1+Cn2M4XtKAr3JkevDv/jhQNzj7LDqjeN7KrkvtUeX1LvF8PrPVDsVZERwAHr4f+w37qlqfrKuojV156yb1KfkgKJ9HXOziQv9RTDPRXY0kzAlAgeJBge9rnK+iKoPx7nebhc9GuKrX4gMUyxiDx1jrQL5Nb20a2NleNU64UOxaHCb5z6tDWPcC2/FLxDYZKBdW8doxXQcodxFqwpWql0ci2ZIctlsi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(6512007)(956004)(52116002)(316002)(83380400001)(8676002)(2616005)(8936002)(6506007)(6486002)(1076003)(38100700001)(26005)(186003)(66476007)(69590400012)(44832011)(86362001)(66946007)(66556008)(5660300002)(6666004)(36756003)(478600001)(16526019)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1CHRYackWNz0RNCYeNAd4mXiaxGcLLJWW7IIue9PBCMrRdOmAjxErIltIdJo?=
 =?us-ascii?Q?DUEQTP3fm4zlRPOIrZGOD9w0Ocpa8F63iD/ePy/k4F/PFPuLjIDPEqsUXVzK?=
 =?us-ascii?Q?l6ccUFeEcWOp4DfKYSbEQV+U7uvwjmVWNtZlILP7ukW9+lOon+3ND4LPxh2n?=
 =?us-ascii?Q?Yj3glsdZFbJ3ZpakNc8XJM9z5zCjZqbTxmKH7uVNu57EVGO+A7rFi5Y9AJcA?=
 =?us-ascii?Q?ZORRPLoL7Bpo51WIRTBcT/HnlcRWii+EIs35uyJg7xB/5gFVQOuehDcNxqU6?=
 =?us-ascii?Q?rqNO70Kl7QktZRHn0yTeF+hqRIjKcqBbFEWaUraC99av0FaFcFLF0KzleGr1?=
 =?us-ascii?Q?NLpLnZlAJwDfPpdbf8ypOpxUUBpWg+b/91pQiuhF+4jyglGJYJH6unTxrGIk?=
 =?us-ascii?Q?y4TtYqwrAEBrs0RgqijuZRahVRk/K07af+tBOy9jHvF7E4FQVz9n6YzEZO0E?=
 =?us-ascii?Q?MQMA1oLQph2AN6vCdh7iQyoMG7czhU2+SqsJ06FmeFb+Ha5jZHmdRgD1AdiB?=
 =?us-ascii?Q?BmNvmuFkNqQ9mYKBvI2kaDWTtTuOZuMiCz/ewnH6FVNth5EYI/bq9Nt38IKv?=
 =?us-ascii?Q?xFkj+XvJg1vRB+I7CcSNmDlh0uXpUSiGYKAPIuM2mkxnObFadbeZ47IlMjsk?=
 =?us-ascii?Q?BOiakJgZYRBVbfgs6SKiho8vHkK9OUQmbOZKgj4NPtmUEMPM4pp+7FeBq6Zj?=
 =?us-ascii?Q?rz52AZ+7xtCKIUieI1XkcjS5fTltn7ESYeAU4dMEPUwrTrn/zzpO12E1gnf5?=
 =?us-ascii?Q?T42zAU8nq29/HMtf+Pk6WZswzSF3xoyieOKJE99qTgTIPKNui49isPk1nLNN?=
 =?us-ascii?Q?O0gp347Dk3ogAMXgqp0oYKRhsBPm4br+SI4VYS4+Z7H1KTTd4H78Y+BgN6JN?=
 =?us-ascii?Q?YExXVB0XI4aJ0E2+VbE8/K9EUr2WntuXEwYNE3d+Ae2gADY9c+rJMDhUm4ZD?=
 =?us-ascii?Q?vM/W96ua4av7UrhHgnw1pk1AjScfvHTjEkrb9dep1UYAFxxtN7qX6yNf6Gx8?=
 =?us-ascii?Q?7yUnLBlyeBWhC/KHkTV/mvl/Ffj5clKzOp4e3VM437ZY/Tyf/ca4xnM5SrXE?=
 =?us-ascii?Q?Vaz5iv2Ukg6gjFieqpe3N2hCNm9RZl5BuYxfJhpYGvan3MyD08NZRJX5lCFj?=
 =?us-ascii?Q?2VkFsNZCkvjdk3qE+co5+DjiuY+NM0cYO3GY63by67P6b2amU3LzfMk0OzN9?=
 =?us-ascii?Q?7NWBKhf3PXIH8jMjaSO7YLDpEEWl0IMRoUIpgJ4+Ci0N639KpId1+zFpE30Z?=
 =?us-ascii?Q?82sBVuDJR2nJ22o+Y55wGowfi0wXy/UBJGgz6z3utqvPdGn+fJ9MnIz8WNka?=
 =?us-ascii?Q?lBfC19UJoAmebzfG/IeKnQLp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7fa182d-6a9b-4570-a3f2-08d8efee8b14
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:49.6158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8NZzq12hCAip+OWGmLYu/FY2THTzgQO6sldy0Qu1vR14oCzVJbETsVv8zKu7E9YVPSwLPZN5H61WtTXDQbOY171KElzI6ihxxZDR0OGzgMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3924
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: -7uimacb4iZ5flqRM_R-S6Ag2-edJVeZ
X-Proofpoint-GUID: -7uimacb4iZ5flqRM_R-S6Ag2-edJVeZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_set_shortform into the calling function. This
will help keep all state management code in the same scope.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c | 81 +++++++++++++++++++------------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8f18005..2eca705 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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

