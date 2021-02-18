Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25CDC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8395F64EB8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhBRSqQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41038 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGT1iB155656
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=CmuggLDTPcWwH+SAzOLZFOqPvKdE22xP1sMEYp2vRYo=;
 b=MFF/LzE0mgs8rgOwsMVpF40a0eoWy2K3eLeXsaSrdNUr6spPqovdHihU7mTZ9B4ALwLc
 mDJXehAlXhCQmxadxHrhCDG3JUudaP9XFDHK6fyobtOl3lBj1xWdfBucBx5F1974yQND
 J5kEG3C71Y+ce3jp25ol40QUycSwkjyYpA+FTGNyigA2HVHzUDf0Dus3qh16uhZIUDAO
 kRkcsNi+GDEm0LdMaMaR2382rLo41bW6ZPWoT+g7r0wVdV8d9am/Ta+JRL8xc/0z8fNR
 XECMYisGBdRL+hLXup60IEDArKOAJCfdHQziZw8AKwSsPs/uEF13UAL2gG6Ll17DZo1K ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36p66r6m4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTffr074752
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 36prhuf43k-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfvZYkWC27gcJwp63O5ehbrWTQMFMRttf0B+MjR/Gc+W29d/WcxvvHRCVaPIF36tL3/wmFwlN5seZZRF1KoDd/COBBRg5LHoWAdcNM+xjSICZkGzRr7SMeCBusRRCllECysQplA1/KU0wJ5ZIhdmQCBHA7nwqlCq9MexlD9graEK3hnxxyUcfC62veluhqNCRt1HDPAUEuCh7F5sARP3lDmYZ3pq+ag3CdjqwdTBCwL9TwQJFO2CON5yezaZOwKZKcfEraItbNu92e0ejUULYl6Y3n0Ws2oVxu9dsYczaTj37MLZ584C8HazpRvsJJH11M7iLKMhH+ljlaCgzL2psA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CmuggLDTPcWwH+SAzOLZFOqPvKdE22xP1sMEYp2vRYo=;
 b=Z9ZIc5h5ppMBlqsUFUOF2CZoSjiu+eGIkcin9p4RczogodvoEZRwWRkM3biPiNTC1VpVjhRTvK0gK2qvwjJX9jbI39rPgkujxI9Xb7OHm7POiFXEr7w+GxuS1qg1jmuonYCzGaPWcKIG5JthwHiRAn2V1wTHMWIXmOaTo7YrQY+MH0zwLclP4IX+3dUiL2lA3kn/MWhmQK28XLsX6aaoEng6az1K0q2+slbwcYVyig6inhQ/0N8o15RMpG1zuHeqx3wZ176h9SXw19OtgJmBAzE3pjHlUVvGf2d8mYKrnErnS9meAtbXmYU4i5dZ0kThYp7lGQWpdS3qvJJ3wDpwlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CmuggLDTPcWwH+SAzOLZFOqPvKdE22xP1sMEYp2vRYo=;
 b=Lc/8lewVTs2DKFsc8XpifY2IUWSHwzG8BapJN8VUjBSnnp6obu3OQn5+QvKks4mPaC/6Jx/vhsb6llL0U77UC9vhw7PuYDP1dzLYRpM9Foy39Cp1C5v2w8d+neMoVUKzDbfURqVaYK53xfe4R30+1z3DyEQEWY3WY6PVou3q9UE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4495.namprd10.prod.outlook.com (2603:10b6:a03:2d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:45:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:41 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 22/37] xfsprogs: Add helper xfs_attr_set_fmt
Date:   Thu, 18 Feb 2021 09:44:57 -0700
Message-Id: <20210218164512.4659-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9db9ec64-f84a-41bd-bf9d-08d8d42ca0a9
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4495:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB449517496695877234B4743295859@SJ0PR10MB4495.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: neCjIj5gu/wFmAlJloVpzTkbzMee8azEj2z/yVGuz4W4wLJUvupNaag9zBbvfcF7y5TJ219acHVHjT+gYX7ORCwF/KQ5Xs8N69tFWboq/8dg9TBFJ8tOsl4siFN0r3RmEtqyl2i8gIQiQMOxSgTND5f2T54btRZVkucedLkKyXQz6yL3BeKQEZjU1aAtJK+ks76evApnGddWq4D9lHe4iv/FffijTpkWjuFx2eWx77m7sv15j0E7qKIdWXzNXJSY2nkDb6a3bkxcRoMy75wLrSYEVsTC4ItC5xsXdXUHR1GSAamzfCxz6oX/HIJAdglcNdRy6kRd0jXElVA68z/SHbq+wgDfSIk8m4ELCvHOufm/fQ+brvgSp4MAbS50J3ww0ZndIcuhGGrjQGx1uTnpqshy8i5butGfdmubTFtoRXbBrvLA+8u4eac7NjcwVq86HWAqnQda0ZfVRXCSkiReJA32Bt3ji4SNk2Z/PLAm3vxXYMbr+VXzsHs9LcCNZKk4/PDWMKO1fOJ6rD7HLarb3ZEFRwB0uyrp0qg8w+6d/QzGm5fJ6iCoPkiuhcjTjNg022bDCLkBsgSjdWqg/cpLhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(478600001)(86362001)(6506007)(44832011)(2616005)(956004)(83380400001)(16526019)(52116002)(26005)(6916009)(186003)(2906002)(6486002)(8676002)(6666004)(316002)(6512007)(1076003)(36756003)(8936002)(5660300002)(69590400012)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yyyuCFjEH4F23iwVaVnAs+vrU87ijf27D3Nd4KowZ3OQhSBumRdiems1WWWq?=
 =?us-ascii?Q?8cDIdQIwdNzpkTn5f2P8mS52Nx7+aFwQG6Hpb+Tx2/qgPOUF4upCDVDLYGwD?=
 =?us-ascii?Q?7Kx0wROWSCD/ZOPYEtg/nTbWLzFTSbqA0BQ1BEGLVyNe9ziOwdLiHSTMgV1Y?=
 =?us-ascii?Q?0wkaSunyc9J4qv9tDLIxd4QgqUuYsC3F4G+PMFkEQPt8jvCcBTwARQXMb1GD?=
 =?us-ascii?Q?+LMI8VkAMST7EY9YXvQJZ0TevzA9a6vMQt69QgRuJbIuwMROSoWvW3z2quev?=
 =?us-ascii?Q?gZRY6e77380fOto9pQRKymyw3SCa8XVkqbg1iB+PDk69djQRzKagdCk9Dlqy?=
 =?us-ascii?Q?pf6dJPALI1IYsllWwbkOXvDWwNcWI4NwVsbvxgaftX48DfRZxhNhgfUzacIE?=
 =?us-ascii?Q?lLjLv8MNVsuVZ+wd8o2n1As/h5EGRrXDOjIVGVEEQ2By6mKb1DM8+rqaPZ3F?=
 =?us-ascii?Q?Nou8jUB+bpGOl15jDQZ4NqR3w4bKt16Q9suA/OlezuSiu7AWcVErNmtaq6Cb?=
 =?us-ascii?Q?1icQLx8rnXXWF89r4xflWVO3nMRH1bke3zpgOqXlkQgpTMtvwQRD8Gx3+Dox?=
 =?us-ascii?Q?kxXfVq3DqAOrS2OZATvmqLW8qObZCpDsLPts5yV/UwZHm0+mORMXKsoVAZ8C?=
 =?us-ascii?Q?mGlIsnwiZIY1XpxPC/fMCNGvEkZmzjO41GIiTMWQwaYQzPMQ9t4WaYuphXCU?=
 =?us-ascii?Q?bRqg8SN1lDAmjCADNgxh5/KIauuhoODVkLt3SlNlX4WyXR/gwoo0dAMCIWUY?=
 =?us-ascii?Q?nGJOKgEZAxKzO4MKYLn6SRWhAlebzeEfCBvjMgjdWWXgXBMWPEo6zoKCdO2R?=
 =?us-ascii?Q?xHkApNES59+YSzy8uKX90IadaMbErReEXUUeiFh+Da8MlVrjboVhXn5Spl+V?=
 =?us-ascii?Q?sbb2IFaEVpvVzMCkxG+1/G8JHWf14y73m+AoDL6I8p8W7YEE49QeuqdT39gq?=
 =?us-ascii?Q?L3Mbo3HFimtD07J8q3F90S5h18N40UH1pj5l9KkR9TEbJIX8WP7O2+8mpAFL?=
 =?us-ascii?Q?zFt0X9tLgBAOF7Hpo4S7Z0+oTk+QrgBwSv6zMk0z+G9JE5rl+cauq9VgHTwb?=
 =?us-ascii?Q?92QTP3WxH8JTm9Dv0x5lnnGqz3z8mcJjQsYWabnlggtlNUmvloGfIgmqAk4U?=
 =?us-ascii?Q?RRTA5S3nP7Dbe3IsGcIwQ8FUm+oOs3FO29SSevqP7v90jtTX8x6jstORuzSr?=
 =?us-ascii?Q?1SSLlXfTl/GCiiBJtZfO+4KJy4SlPmo24OOedXZD/CQeBOA8KuOOiK0Vx3W9?=
 =?us-ascii?Q?TTPA+gEloaEFxzTbFQF5fmFjJbE+78BHhcBzZ6rhxpI0XEfttyegDnzpro3D?=
 =?us-ascii?Q?+nLsjc4Nh3ItfxHviAJNxbef?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db9ec64-f84a-41bd-bf9d-08d8d42ca0a9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:41.3527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/0I5H/1ZH+Drxbdti7HZDY/6GdN2no50ucr/idUAfg0VPHHzgc6k7p6L2XlFkiv6J11wVISb8QGBLp1ckB4brMA0OO6QaxqUjPoS1BmHHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4495
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 45b71a4f3fd8bc8d47adcbdfd859ed736a54e66b

This patch adds a helper function xfs_attr_set_fmt.  This will help
isolate the code that will require state management from the portions
that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
no further action is needed.  It returns -EAGAIN when shortform has been
transformed to leaf, and the calling function should proceed the set the
attr in leaf form.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 77 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 92eb8fa..cf19c44 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -216,6 +216,46 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
+STATIC int
+xfs_attr_set_fmt(
+	struct xfs_da_args	*args)
+{
+	struct xfs_buf          *leaf_bp = NULL;
+	struct xfs_inode	*dp = args->dp;
+	int			error2, error = 0;
+
+	/*
+	 * Try to add the attr to the attribute list in the inode.
+	 */
+	error = xfs_attr_try_sf_addname(dp, args);
+	if (error != -ENOSPC) {
+		error2 = xfs_trans_commit(args->trans);
+		args->trans = NULL;
+		return error ? error : error2;
+	}
+
+	/*
+	 * It won't fit in the shortform, transform to a leaf block.
+	 * GROT: another possible req'mt for a double-split btree op.
+	 */
+	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+	if (error)
+		return error;
+
+	/*
+	 * Prevent the leaf buffer from being unlocked so that a
+	 * concurrent AIL push cannot grab the half-baked leaf buffer
+	 * and run into problems with the write verifier.
+	 */
+	xfs_trans_bhold(args->trans, leaf_bp);
+	error = xfs_defer_finish(&args->trans);
+	xfs_trans_bhold_release(args->trans, leaf_bp);
+	if (error)
+		xfs_trans_brelse(args->trans, leaf_bp);
+
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  */
@@ -224,8 +264,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error2, error = 0;
+	int			error;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -234,36 +273,9 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
-		/*
-		 * Try to add the attr to the attribute list in the inode.
-		 */
-		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC) {
-			error2 = xfs_trans_commit(args->trans);
-			args->trans = NULL;
-			return error ? error : error2;
-		}
-
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
-		if (error)
+		error = xfs_attr_set_fmt(args);
+		if (error != -EAGAIN)
 			return error;
-
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf buffer
-		 * and run into problems with the write verifier.
-		 */
-		xfs_trans_bhold(args->trans, leaf_bp);
-		error = xfs_defer_finish(&args->trans);
-		xfs_trans_bhold_release(args->trans, leaf_bp);
-		if (error) {
-			xfs_trans_brelse(args->trans, leaf_bp);
-			return error;
-		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
@@ -297,8 +309,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	return xfs_attr_node_addname(args);
 }
 
 /*
-- 
2.7.4

