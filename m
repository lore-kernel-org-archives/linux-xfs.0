Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A10BC43470
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DCB061184
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241670AbhDPJVd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241677AbhDPJVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99Ifu026156
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=OuE0LzcuFI5GB5AmuMHSJcqpK6JWUVPAl/AE3Nd1Vu0=;
 b=i649wPlWOrioZBrHoItPoGg+f3UYAViiTCnEgKtnlehkhZWHkslsfO8bwukvrt7A5VGd
 mBsWx0HZAp7gozwCo56GzrytieBrZdM1uCkSMhx0WxCxVwhQOek4R0/IfhQxFRgCfOIj
 jZomoXvAUvuOFP8KS7OOXPUUWeRAlN0cAkt/BwHrtjdlrzzu0k/6RW8W/wSKlj+hXBwx
 kU6WTXnh7bZwhILek30/9P3/9Mak/NRdzFqZmUU4mIvKeVNMfWmQNDkd+/9cSCACje+0
 DHaNAMrj55VXQMxK5gvEgAOh0+oZAmMLwV3Ik92pXxz3mIY3nihwr6PUYCFItLi3iwbQ XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nnrhet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99eLU182118
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 37unswy7h9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCW7pd/I1WtkE2KlMYEIizGMd9J+4y+sPFQb1T7q3eOFyYZdZbOco0B1KLaPNk5q6YXXkax1/vaoDA1IVheBCJvuVSDKFRWPTAt10HVQZuTNZOb2WA5moQqC5YmDcHrdvi+RvSM/mj8OcxdwNvTWnfztBgkWN3Ngrn8Fhyl28+6q0PnI4neD6BhCVeNw5R/c6jrPbSM0gBVsxdV4cHbrrp0xUMHoOc5Gyz2fnmFdDIrOwOqB5urAhDMWtZEbGr4S3xG/M1pXg9Id6J4NIiusHvcqoDUNZ5hAzApp+LZjqAeLJWZgCF6oxeaiGbO75D7PbA9LHsusxi5r2C748MmhnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuE0LzcuFI5GB5AmuMHSJcqpK6JWUVPAl/AE3Nd1Vu0=;
 b=R5WTZtsF7DK+GVZE07oUX2TB+h8C7OZmSdUk9N/c0HPS5jWRW4Y3rQQgHb8itUqJOoqMTOa89aVYZIikKMNK+MgdS/srW5rZK/Omo9za0vWL9xx4avsTqLPWpf4SSrZ/SDjMWtgfv5CtA8IvqkAgxj40JCbYqdyFy0OEtRtbCsLufZBiHvj+U+Bd/X0BTb2iNt3VdwOfNleplwWJBXlcB+dGLePe1bDye6VWIpGWDMnTRPhK6m/lXkcZ5RuNbjNVPZzaPMYjTIfnE3PBnfUVhPkgECI+xQRV3FQnn2E1mmoO77EATVeKhsogw5uuE4xqg7gRtqRS3pb5LgSbW/Befw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OuE0LzcuFI5GB5AmuMHSJcqpK6JWUVPAl/AE3Nd1Vu0=;
 b=r8CCRH3XjoMGXRX7EtE6XD3lBn5T0hcmgbTbmS/7Kd02CNN8Gtdn9NgAr+CrILTfhAZ0JaRAf26w+ihBviJ5i6Cpef3z1VXhoc+3j8EAT3mKCsEYbRcXfvDyVaeEDSs2HUYdMf+1BDGWJ2zdpvYwXlF3+blwHKHQsQxBHwK656E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2567.namprd10.prod.outlook.com (2603:10b6:a02:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 16 Apr
 2021 09:21:01 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:21:01 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 09/11] xfs: Hoist node transaction handling
Date:   Fri, 16 Apr 2021 02:20:43 -0700
Message-Id: <20210416092045.2215-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416092045.2215-1-allison.henderson@oracle.com>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:21:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1ab0fd5-79ea-4d4d-5eec-08d900b8f355
X-MS-TrafficTypeDiagnostic: BYAPR10MB2567:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2567E1901DEDC3C22A16B288954C9@BYAPR10MB2567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SsBgK/ZNBxXvBpx0Gjfik0l0/Wkyyey6Tl0yhRgPBnTCL8FDPfjh6BICfbgKKzC6Utb9f6PAD8TEdD8j60M7m2KpUfkcik0Y72xkvKYEqYeAVSQHs3N0a8muNh8I9ZzZ4O45pbbdxcqVRhM/Ww9TYYmoVdpJnV3REAPgylFIRjH1deY09/m+IFqK3z7j5CrAiuCdAX/XpKeOIXkDY++pKee7aWFnrkElW3hRw9ddm1ZMTHMnnuK8kXh0/C+zKWAAfvTMe/hTwSuPyKIClmaFxfpb81jrXlJldnCaN7PQjMf72HOaZxnq+pqqfoJmsvFr6RGF9fEIXvaLY3iqHa5CABGvzIJzZ82COifU4vr/UI8qJZ0Gr389wC2+Xkk/jEwgEbiWbKDWKK4L5hin+WABRcac7l6NJiD+Rr8tB+O8asCvY0ZZ7LBr35jfBSnuW2mVB7iRMlBISmnP0GPOzeaHuUtY0w/aQL5ShRa3I/NXhNppiL1SbmdGVAPvZZ/g6Yoh4uLX22tE8EhQ7dH3eN/5B3xHUi8Rx04iuh+7d/h+XSiwTVxJvr1+rVYiJjVVUdyZroaB30cPKtKCic58Hv/2ReR5ovwo/brhP78ocplHYTYMNjvgD1i+eHPanLSlBXy2VQCZ0wglmINV8dbas+ulVc+iu85koV89NsvjQ0RjjGKQIClyezhvtRL427mlf5f1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(16526019)(8676002)(36756003)(44832011)(8936002)(38350700002)(52116002)(6666004)(69590400012)(83380400001)(2616005)(86362001)(66556008)(26005)(6512007)(6486002)(316002)(186003)(2906002)(1076003)(38100700002)(6506007)(66476007)(6916009)(5660300002)(956004)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?71Xgbtrrac9GfS56uecHrRmUvEzfsw8i0SkRYLd7TLDB2tICcAkS9eM9tzwp?=
 =?us-ascii?Q?MYBtqVzdb245qn8GN9M0tCvuOYgBsYv5EuIZSHbr4kMQm1qgDSAkFvRSLjja?=
 =?us-ascii?Q?DpqfwzQ83mfnJA+kBXlfVnH/809x9FyPM5tqeDYv1Aeb2yt+C9cMrz0yiUH5?=
 =?us-ascii?Q?hzBEiRwT/uY8oDkBlRZCB6B0EvMakLk7l+oHXhrf+22gZW1QS11D6aKfc3hb?=
 =?us-ascii?Q?XOpckEB4fPD7nsAt760TxnE+BDbpl+oAq4ANQXjkNn0O1H0DL31uEFjnOoGM?=
 =?us-ascii?Q?7CJ1kxzvU1+69xqcxCApFFsvwEhYyy4VJUwz796CPHz/v/hnmRL9aqsi4C2E?=
 =?us-ascii?Q?AbbFydQIQLpVj0oR7YKhPzcSeyLpJ9ABYn+7qdULRlkh/nHPD6SqUmhIcAfB?=
 =?us-ascii?Q?KH+OUducstY89UfvMgAC1r+4CILDEeKdLuUQTDj0G7UjzWeWqd1PxNdfa4f3?=
 =?us-ascii?Q?O5x/uiiO66XU2j8bz53y0YzPGi+G+0MgvMLU3fkK+foXZMGF/HGr6sgLyUt9?=
 =?us-ascii?Q?rYpnNJ+Nq75gmncLgFQJbE7GVw/zoZle687AQcsnDF6hEWwAYv4mBXNmRill?=
 =?us-ascii?Q?hhDwm32jfIponOpNCrjDY8fwfraQXalmVI5sLNrKduhHpAUNfofVETn7RKe5?=
 =?us-ascii?Q?zVRQr7MRGjvnereg0TH0pLSp5Ncmiy7XFLt3O9k8tCCVlKPAAE/ciMiRfwnw?=
 =?us-ascii?Q?B9dleeeEdFRMzDorGn88MfRlTD29dfIFnOt7DVVULrgfhyGsKp3evfK5voRA?=
 =?us-ascii?Q?0lpOtGcpu51LDulbhEaAvGNMgBUwZM1+jdA/Kc6CRwK2Be/K91U0YKL2GEHX?=
 =?us-ascii?Q?iU4YCRrI0nED8r9VKF/n6x70GJxYRsWdIh0UTladTS9Qo2KMf7GFaRlv0bhu?=
 =?us-ascii?Q?riW/LI33SkrYfKSKNtjMiC81+hTin+yFx6cXpW50hlGl2e63Q9k0OtXSfp9j?=
 =?us-ascii?Q?maXR0kB3hQ1HAWvOG1PL/25Nf1tE3GClarSS9r6TOiE1FQW1Qbil5u1m3OE2?=
 =?us-ascii?Q?plMX6fTTXrh4Ufl56WPKLIZZ4TLaZM5oOE68rmgNcM7fVa4x8VcYG77sRU3l?=
 =?us-ascii?Q?7IxLeIknhwM4FFswFdtG3HjQkCjdMWm91NFCy0rEVfUZ2V+ehX7KlKTK+GM1?=
 =?us-ascii?Q?4jy6ilgXaxAT4GmTFuR5UvwqN3JD7Pkiha6FQhaYo08yRZW/iud4Gsj51OGy?=
 =?us-ascii?Q?g7PGU6SCigHNJGCVIeQ0Oj+2L/c8pZ1N1YfgqBRZ8X2/2XJwm8Alae2feG/O?=
 =?us-ascii?Q?KILg67ydxEFFNLbmmRjuO8yZzchXffQldKBE4PhecAsq+7SpiUKSWMc+V+4l?=
 =?us-ascii?Q?g0vSah0182RO6hadRWvRU0cU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ab0fd5-79ea-4d4d-5eec-08d900b8f355
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:21:00.7470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IMmgHJiz9sZACLcdLVJroSPnTNAIdzgZ79t8AK7HG6crFFMgB8yjYRxZpTkdh/WyTlAcjT9zqxujy6GdWeY5wvReCLLnIWsLMUiz8hPIf3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: XwV6CIxBsgEizGR9v3WaE7RveB6uQCe5
X-Proofpoint-GUID: XwV6CIxBsgEizGR9v3WaE7RveB6uQCe5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
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
index 5740127..ed06b60 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -289,10 +289,36 @@ xfs_attr_set_args(
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
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
@@ -382,32 +408,9 @@ xfs_attr_set_args(
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

