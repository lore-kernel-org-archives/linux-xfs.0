Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A60C4743E
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AEC3613F4
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 23:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhFDXoh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 19:44:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhFDXog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 19:44:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154NgnXg041770
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Rl5hjkbSu6ah9woombt7OArvqyhdXA1UKTGp09QgR08=;
 b=dNFs1OfT6j9iBPwxlCmR4g4fAJ5znCcnuctY+MMBXHFNt972+PWIJRnf0wN+wO6mKKHp
 dM9BaI6q0ya8iPD9M7tzWQDKPQCIlrBeJfuOT9TUgVrbrqmlYWCjhQunHUu4NiIEWLRJ
 nF/1RXa7X1CBt0D06Jw/D4gmAIOI9hP8lNtDhjYCsOSuiCWPSGCClgh3Xa0VurGFVqux
 J0svCWBH4V3nZ0nupeYK7wHmuuiYmoigjXK+VHMwzD9QEDglHWORpCcRVLkCxTwwc1Si
 5sqZwT/FM2wUmtSLzqII2jq+D9NTCW1E+Iq9spPZOdaRfoSiFl3KGWEoBNkWrr19qayj BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38udjmy0w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154NdeCJ039021
        for <linux-xfs@vger.kernel.org>; Fri, 4 Jun 2021 23:42:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3020.oracle.com with ESMTP id 38xyn50rsa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 23:42:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJSt0VRcwbLiFZWElCqJ0MYyOZkd57wsDOuI/ybpMMouE1TDSZG0I4uWJxG0FD2UEgeUy52/9TPaj0cfMIjzf+JrR0mZSUXi0mzEhf3YxyQCf1wOJ04Ax4lF250daafxLA6IqjCwZoQPBDtjRdD+obECuZu99ipYZrd1xBv2jWrl58Or432dVP6hFNQ2SgcA3jPbiIQGZILj6H5nMM3Cnzqz1L8/HaEBYwx3kRyBxWRbrcErTcwxtvSR/yS6XxKGUKcFA7W19yZuhki9oGn3dOQsgdmfPUXwyJ++tgljTmD60RMdqrZgU5LFSIrpw92Q+kqAiKxr6tnvcRgObwHKIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rl5hjkbSu6ah9woombt7OArvqyhdXA1UKTGp09QgR08=;
 b=VOtQVHbudOIiBk4Lnfq4+I5bbtQk9/9rrDSnoYewRcHOXqFMNa0+QM2WzolKmbbCkCbev82uPp6xlVgkd0UhPDYroik2WwdK36xzWtgAgvEI4Oa4s6VtLAVMLzC1dI1Kf4Dth2X9a8wZ6tt/hivYJyEUT9vcrYuGFuowIJxEsbCnGnrfl3uXpBRXimKdhVeAfbOVLUypPs5XlNWd3QRweZOACnRw2/OEYar1PsSIOl6WwH/jJmhESo7I8UyCCWHiKtwcPAOJ+bNQeF83pxEz+OoUaNOWlD5tblb/x9BnaWBJXCkoeVwNd9E6at3iE+k7hhDU/JsGwJjWEr2T1GK2bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rl5hjkbSu6ah9woombt7OArvqyhdXA1UKTGp09QgR08=;
 b=IgKXklMauU0Yc4hBr7vxm9akGIC5VBSO3F/uOLzvZXpBm1oCkXCjFz7QxcZXLrGkbMOxjBp6iAzpNtHiR7hzLf+b849mLeDsCzAJEQcQkfmnADmrdpjEX8ppCQ2CFLsCV40zqP/fraNIBemCP4fXM6SEq+10eYUA4cLr2yPxaNI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 23:42:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 23:42:47 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 08/14] xfs: Hoist node transaction handling
Date:   Fri,  4 Jun 2021 16:42:00 -0700
Message-Id: <20210604234206.31683-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210604234206.31683-1-allison.henderson@oracle.com>
References: <20210604234206.31683-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR07CA0095.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::36) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR07CA0095.namprd07.prod.outlook.com (2603:10b6:a03:12b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 23:42:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc994ac5-f842-429c-26bb-08d927b274d6
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5485C551866483F6A9AD85BD953B9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: id6kcN3QvRSYadPUGHavqXsesthV1sIRzhLSbENqAa4r/nUkJlRO86xkrDqXi1rVDdWbbsoT7VyI2xMshQXZ6dLemdoxwHH7KbmBnTEKc95+PwtBVTiOFvI3nu6hyn32yUgIj4i/vnsLGGtcw0QYIGscuSBJUpzOvfO2slBELxUv1POr/TvJt6TQDYCFFm02bD7YJHr8aLLiCMY8Wbx0sT9sySUyew+IOkh/s0RGrCsuk2ErRa5EUskpaCrNanbkUUF5MIKIVXw01XEGpfgTJNDZRwRfYyNsC6NvchxnFSGEVlmhq5+pWVpnaqXmQ74JbsAqJ958TgaTpZLWDEveKU3hsZKRCKx3EI0d7dcJ3qrm/L/tmn+/OjBK5WKWyeMaxmmoA8qXsBfMJJ+s+lbaBp4siZgbn6mDoqILYtsc4qbrd8908QNE7Oa8sFVrEE+uAB0gmZBhEmKWVRR5GsldNI3qTpVynbkjkZhwqEMdmDaLPIcsk0EMqn/9fdE9Yd0mbYaoILPJRo4iDChqdmHkEV4O312sfMzhUcs3pnvb1HTekl0oTY4wlTIXU8rdRiRK3m1iJpju7dYO25rz8aQOwyOWkTPrVPu0xk0gPrXP3L/HOe1I2pl08AXT5qSjh8vvQrJCJa/MKSkKXyHY0cS4hwxyRgKI5xQ3/RidmbrnswCRIIqsfOSuBJNT9bFo9ZNs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(346002)(39850400004)(2616005)(66476007)(66556008)(2906002)(66946007)(5660300002)(8676002)(956004)(316002)(186003)(16526019)(6916009)(86362001)(38100700002)(478600001)(38350700002)(8936002)(6666004)(36756003)(26005)(6512007)(1076003)(44832011)(83380400001)(6506007)(52116002)(6486002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aBpGMcUDaZh6QDvL+p13PKkM256BZv6bgEJRbS6ov2Oa82Noyl2XcFPbVO5x?=
 =?us-ascii?Q?g3Ri2FWL6Yd/+c3NQbUbcGy38o1NW7zfJYe/CSnUwaZfBJla7wrbi1CCisyH?=
 =?us-ascii?Q?gQZaiEGAtcV4Tw21sYNOsBeoI5PWEfwskxz9eXg2ZzoMDHi4j3EGC88d+dRM?=
 =?us-ascii?Q?YnKV1NAFWE4YSms48q7e8+3rxDWHaQdFSw+TOzPfYjouTeUceBL7RkMcf+tC?=
 =?us-ascii?Q?PEIxnZjJ3rhZDHq5K6dGiXO/R2oqT2mWDCjp53x1ASQb1RjQilnbQfLX9/Zt?=
 =?us-ascii?Q?/VJQxigzZa/XYMoOn0yy0tUwomhZbCVddOV9pOMFMTB0b44w54B0fPCeLGm0?=
 =?us-ascii?Q?UHDC91o/aDLVryCBQ7PHWj0YzFp5VxjcTS1iXA+zHGY/BiWBc/Z0enHCvVML?=
 =?us-ascii?Q?6Gxw6coOElZwEP+Voq0w/hSYne3m1R6qoc/cMFHoPb3x/Ep887dWHBIfrB0a?=
 =?us-ascii?Q?X2zcUfdEb1i7Vc2QoMxN6PxdXnHRudyW6hvEaLwcQnVmMLsAgnwRedB96Wyq?=
 =?us-ascii?Q?7/TNhrxQK2rAphbEtM0Y+ZWyiY4HIUwdp2mnXR+WUPNVYSwmvzDMubV0A++N?=
 =?us-ascii?Q?uXaZcAx8pNm46aHiZ9rcM0geW7j5kJ+5wEPEoKdlm4UZ9DHE+PJ2TBFNKslQ?=
 =?us-ascii?Q?usl5OLzDFoIVFYSmYVVXgN0RX9I9gSlfGFQ4+oydKYE80erl8tiVouhGW3Af?=
 =?us-ascii?Q?Sfr1PvQ9R6Qo9oY7s99znT+nEAvQ2/FnzrbgptRMNIE3awUgzjSe5JOrFcQd?=
 =?us-ascii?Q?m+Q8Ih/FNF0L1HAJr08fuAM5kJZ6aF8ypp70NCiJ1sxFXik8ScB22/hybim/?=
 =?us-ascii?Q?CuKEl9dL48D9z5sj9PPfWVcS1vOg6unQua0F6RtV3cb7xXdQ1f/UcbjCrVSy?=
 =?us-ascii?Q?yFFlA4qvfqbJWZdzRZ2TLIjK9N4W/xO+x61IqKY6LJi4nYadI6l8ANKx7smO?=
 =?us-ascii?Q?LCMLiOILjbwzz75diFvH53iPm994QueL21zkXgddC5xcxNFwVwNndO6fjZNx?=
 =?us-ascii?Q?MA7dJ6tiM9+vI/nkV3hVe19JOe3uwvuIIB308Zdt2pnQPtdP0mHDr4M+URyH?=
 =?us-ascii?Q?ixkk4pc04UKvApwLOBSXi3dX3n78SOWUrVO8bG2jMQFKchyYhxtxgdV6geLe?=
 =?us-ascii?Q?or1B6aDDUU1iF0G/NzKxi72OpdkJ5jGJlUYSvphyExtn6XM2uyDpJKQvDFYF?=
 =?us-ascii?Q?JrKnrIziG4gxof2x2HfpJZ/hQGAHeSFiYV3f3Rqwviur5/XZhAW7Zvij6xL0?=
 =?us-ascii?Q?Jmr4q58s3sfp+zIDDMKnTe+H5IiaeCl5bRogrYYG9qL+Z4D3KElQBzrPEsmE?=
 =?us-ascii?Q?CVby6gYmlmxtVWVaW9OzMoJo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc994ac5-f842-429c-26bb-08d927b274d6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 23:42:47.2348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFr1fVTx6ifikY8mdDP6ReDgb69UfnMnABFXRVw5kQ2mhMBz0fKktweYmrcsZrwQFY0os54q1nfkHUuMsz91gBBBMg4bgzisCvPlgU7f/+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040162
X-Proofpoint-GUID: cP67WdnOdAjsLwY3PswMrpDRS2DtMRiK
X-Proofpoint-ORIG-GUID: cP67WdnOdAjsLwY3PswMrpDRS2DtMRiK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040162
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch basically hoists the node transaction handling around the
leaf code we just hoisted.  This will helps setup this area for the
state machine since the goto is easily replaced with a state since it
ends with a transaction roll.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 55 +++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4bbf34c..812dd1a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -309,10 +309,36 @@ xfs_attr_set_args(
 
 	if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_try_add(args, bp);
-		if (error == -ENOSPC)
+		if (error == -ENOSPC) {
+			/*
+			 * Promote the attribute list to the Btree format.
+			 */
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the transaction once
+			 * more.  The goal here is to call node_addname with the inode
+			 * and transaction in the same state (inode locked and joined,
+			 * transaction clean) no matter how we got to this step.
+			 */
+			error = xfs_defer_finish(&args->trans);
+			if (error)
+				return error;
+
+			/*
+			 * Commit the current trans (including the inode) and
+			 * start a new one.
+			 */
+			error = xfs_trans_roll_inode(&args->trans, dp);
+			if (error)
+				return error;
+
 			goto node;
-		else if (error)
+		} else if (error) {
 			return error;
+		}
 
 		/*
 		 * Commit the transaction that added the attr name so that
@@ -402,32 +428,9 @@ xfs_attr_set_args(
 			/* bp is gone due to xfs_da_shrink_inode */
 
 		return error;
+	}
 node:
-		/*
-		 * Promote the attribute list to the Btree format.
-		 */
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
-			return error;
-
-		/*
-		 * Finish any deferred work items and roll the transaction once
-		 * more.  The goal here is to call node_addname with the inode
-		 * and transaction in the same state (inode locked and joined,
-		 * transaction clean) no matter how we got to this step.
-		 */
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
 
-		/*
-		 * Commit the current trans (including the inode) and
-		 * start a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
 
 	do {
 		error = xfs_attr_node_addname_find_attr(args, &state);
-- 
2.7.4

