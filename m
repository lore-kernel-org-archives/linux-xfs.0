Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6C2C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECAD064EB3
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhBRSpJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:09 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60504 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbhBRQrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUVW5059561
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gjicCUJPSW39Nbaop/rqxCOoWcwctNqFkPTnPq4/M3Y=;
 b=twyeXe0yFC5iejTxAvXJeufe9QgxRMUmN0jMrZVKPq/IfPa5VQ4hX4OdlI1wHcbG6Rc1
 KnS5zu4pX2Il7NR131Q+Vn9el3kkaWy3mDPAsdf7WOFeV16Loe3nS2uufIjsVGRVToTo
 ffAQAnRqz+KFqDSLY7MlwVFRnJcL3WAGqvajCLIrzgJHrfrIkDZzqHRPwAZtlmwHwnoW
 U45WS3M+qoWI08RHGpsCBrUaI+1ERWodFCUaZvxDqko8n2qZHZKsWiAM44uaq18V6YBH
 pQuPJPykXFJG7LYK2VxXJUs/0fvSGmru2u3/MckTVFGOx8yTKkluW7TrPooWrSFERwBs ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36p49bersy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTffu074752
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 36prhuf43k-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nii/s9H2gLP8IwlP2/5z+mLZc/McjJ3OWAsAIdHfpA8HqCFnXiysxbjsMvGLjNpSrEIpvpFZKzwpTqgG97ZfXAzD/zK7mmAYrkaSLYeh//xnwbZlipj423B1BrBSZDNMkJmaZyoSXFQ9CTHf/avjDVVjYB4JkTBmeVCM0k3UMx++05VCfCBAIhrakc4AfdnhMiZo5Etttn081Zy35rqSetdKWKYPewWYdCKIgUXLgQ8fL8xLrKehHOX6KrPBT0yE4aXbdrMx1SLBYho3n89pd2wHZG+hoq2ebFFT5kl7r7X4s+5d3WmbnuFISN+7aFu0qenveQ4jxgeED5+B1EJy8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjicCUJPSW39Nbaop/rqxCOoWcwctNqFkPTnPq4/M3Y=;
 b=E2vl7hqRLlB6TqgB1myWLAs9N/UG6OkERswF5Mp0OZQyek9U5CZyVYS+PQpvhcmUvbhhDf+OTL6KjONgXeaW4FgR6bg+9kln19LThzAxtczMThIY0Lb5iLEeCbv/Q9a6qUrqq3U0lzrNXeUPMfm3w0FWV3S2WhXwuVOAATigsliJDJUi42Ud1yq0DWtRSPXyKL/EJdBaHwmhEu5lx/lmvMxnUDMWKOmWu1AI9233tnvh3X7J/ENI1f6di+Rzghrlsr72ZXPs+hSry6sDPySnriPs+nafjQpXJhQBLY4IpMoOmCGRWThsD+UdBEA0LKTnjumWYfcc0VTumd+IU9bLng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjicCUJPSW39Nbaop/rqxCOoWcwctNqFkPTnPq4/M3Y=;
 b=e96FNL4JpJud7NncCD8/qB9ycSr6xrcXVp/i2lT6m7ZR1WqAZUmFbm/ZGBq1B5U4yXZqYbGzRrbP9nZx0STJK20jUuZfuYdebHf8Q3OAG6Mg8OFBKDOQuzRRNG4K1oVqnE8KgrtCimnz82Q/aHvKUE2OrW5Yun/Xg7IScjQ+8rg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4495.namprd10.prod.outlook.com (2603:10b6:a03:2d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:45:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 24/37] xfsprogs: Add helper xfs_attr_node_addname_find_attr
Date:   Thu, 18 Feb 2021 09:44:59 -0700
Message-Id: <20210218164512.4659-25-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 569d3908-2497-40f9-f26e-08d8d42ca137
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4495:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44951DC00255731CED4C51D295859@SJ0PR10MB4495.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8pD6n0G0d4JKvjWiGWENubDj7zIDMwV8NtbTheLFLRNii4wbBQ2c1oUZbe1N7D2l/O1eQtR8/8P4p02/aFpFWaK0LMl0VdMo4VJAu2hhzsK0GkZVfRSf7ub30R534N7GXMjOCZq3+PYGKyUhRh+XTpgUgHnPrcge9308J2KbGIVovwBpcaDSkDqeuKjiaR80eJPoUMl2v20FkqiVfhZVvwmvTC5VQZrY8XC2hYpc1l+8cFskegBasxjKglhWOc2K4ORjfmBMy3wbvOZ/gXrr4Kjj4hv11phlP3cIhc5r653ca06PZiJN1xw+5WmXvwiAjRhDRPYBmoSFD5PWl4IKg0jiI6+IP5w+TWEUpPR0CP1sqioKnh27gvNqBkiFzFs65NWlTf4ij0/+/Va/T7v5cmyMrFRlrbEPPw8UL/9SoctpciAuiBClF32HgrA5BG150FJMDYkiReQxjfrbzWuNOLNy3DzEwvMkIHfhT1DIRHw45Vcn+FQ1P0OZ4QufypIUXYfBqyZVBpUxwgItxvQX34bNmaU6gS+EAppj3HTCVqMYjwVSiWsZRJn821fnBDvdsbYETUyO++NK4avpGkBj6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(478600001)(86362001)(6506007)(44832011)(2616005)(956004)(83380400001)(16526019)(52116002)(26005)(6916009)(186003)(2906002)(6486002)(8676002)(6666004)(316002)(6512007)(1076003)(36756003)(8936002)(5660300002)(69590400012)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MVWfFHYcLGc/zeYuo3oq0ZBVQWxTLqz9TEP1eazuj+4pl1RatZHv39hzo0/i?=
 =?us-ascii?Q?ciHcqTeXkD1RTjIMaHQK3rffxF7BIu3uqXNrs3tLYB68oLShQvuchk6I9mUB?=
 =?us-ascii?Q?F/XharAxjpfZ3vwUfSTdFtqpDdFOxgmAEK9gxQ1c51yQNNb4llmFhQmDi43w?=
 =?us-ascii?Q?xqwArA9L/N76noTj7+byAfNUdAE293zAZUyCGsMfl8q2CONvVwgonqlmu4ps?=
 =?us-ascii?Q?zjZU1TcpNFb/8rYrCHR57G3Q7oaoaGFKNfnPMRKJA8pHOjxep+hK0PqLL/vf?=
 =?us-ascii?Q?kjv20FiuZVLxL8EUkYwRb6fN+qt30s+rmabkX0zyQUsHXPAgltT9NaIVf8hf?=
 =?us-ascii?Q?3hSeA+wqBjAMdP+i2FUMy0gYmbhZWg7uVa55pbg1ChS4rvn6VlmMOo0rk57L?=
 =?us-ascii?Q?W2KvAmTBfwRwuTartO7k9DgO9m5Y789GCXxOGwU8JzlGPDqA8ziogZki2c8v?=
 =?us-ascii?Q?4qEFlwcKBB70LuTejHFC3/2Q5I4e0MRd1MwLNuDz63mRNYhVAzfT/3EDDaV9?=
 =?us-ascii?Q?xT2MQbvFD3FFw2V+hGdNVXvXjSNE11u1jdzCBpIjKzax+9VuYXPwUbn3e+Gz?=
 =?us-ascii?Q?gjyBpSIyCx49wRjtFRYYhMGNB0eUqCkxbBU4dp820hWxzmZzhpQuqypEkFTY?=
 =?us-ascii?Q?4qXsV9DHrIaugod0n1sAJQGghKRGvDaMBVnduuJdnUIAKmwDCoG58ZnsclmA?=
 =?us-ascii?Q?4cA7IgS5lA+awQ1nD0xRGJqC2PVbNSiVQco58JLPZbizbvOXWzprWTBQS631?=
 =?us-ascii?Q?1a1t/MEee+iCuQ7YxsN+0XjOuYDuJRL9ng5mxuAppu7/+bfvelzmbH1rD/UG?=
 =?us-ascii?Q?rTQJicdEx5W8Vfy+THuizaBADt4/lbpPtc98IRxsNJTPiZU4ZNexlJRrZZqs?=
 =?us-ascii?Q?iAqttH+Nemoa+S5W1WRIG+fTPdXWng1luSpiZTBbqykA/BufrCAQ7TCzReOE?=
 =?us-ascii?Q?rTN1wSsRRcGu0ifPHOipDxeRC+7JNE29c2KHDDy8fG00sJy2d9QyK7UjBuY7?=
 =?us-ascii?Q?PIESC93d/DB1kb3CSSsYKlKuN3Y/kTWkp6lQb/Qlrp//je9SV44ELrSPwJI0?=
 =?us-ascii?Q?mJSgABftMqED5PTuZXYsovLnwkN3C35PWy7bCUYv4Ly30cFkdXXJ16DwViTZ?=
 =?us-ascii?Q?9Jrht5rNnCqejzv+Qof+whQA+H7OCLpiEkxpkqcIZP+vP8l+cjgiR0nPOVRf?=
 =?us-ascii?Q?H9/w2saXFq4Sq+KjYnbRWzWkZsgeWe7BtKYDi+fqkM72mqUGRh8Gny3QvFSr?=
 =?us-ascii?Q?SoIDW4UZQF5Ii4LgttrF1kTQwX6czVQaCSF3P/F8FKETAvmAcQd7ug40sMye?=
 =?us-ascii?Q?4d5TF/z0nFVFvRTSQVSkHjMn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569d3908-2497-40f9-f26e-08d8d42ca137
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:42.2687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s3YiltU32qckUvWBliUaJOgGU8fQkytN0MuDAM8HIbgOB2s9ZhAZWDQELFkOCYh3FBrC2wmIUhnz8n4hycevyWAvAPoYTUbU2I2I69rMc7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4495
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 1aeec98c3f70bff14cc0e65ef898e91c2c554d41

This patch separates the first half of xfs_attr_node_addname into a
helper function xfs_attr_node_addname_find_attr.  It also replaces the
restart goto with with an EAGAIN return code driven by a loop in the
calling function.  This looks odd now, but will clean up nicly once we
introduce the state machine.  It will also enable hoisting the last
state out of xfs_attr_node_addname with out having to plumb in a "done"
parameter to know if we need to move to the next state or not.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 80 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 29 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d9d7a22..b1a099d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -52,7 +52,10 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
-STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
+				 struct xfs_da_state *state);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
+				 struct xfs_da_state **state);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
@@ -265,6 +268,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_state     *state;
 	int			error;
 
 	/*
@@ -310,7 +314,14 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	return xfs_attr_node_addname(args);
+	do {
+		error = xfs_attr_node_addname_find_attr(args, &state);
+		if (error)
+			return error;
+		error = xfs_attr_node_addname(args, state);
+	} while (error == -EAGAIN);
+
+	return error;
 }
 
 /*
@@ -896,42 +907,21 @@ xfs_attr_node_hasname(
  * External routines when attribute list size > geo->blksize
  *========================================================================*/
 
-/*
- * Add a name to a Btree-format attribute list.
- *
- * This will involve walking down the Btree, and may involve splitting
- * leaf nodes and even splitting intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
- *
- * "Remote" attribute values confuse the issue and atomic rename operations
- * add a whole extra layer of confusion on top of that.
- */
 STATIC int
-xfs_attr_node_addname(
-	struct xfs_da_args	*args)
+xfs_attr_node_addname_find_attr(
+	struct xfs_da_args	*args,
+	struct xfs_da_state     **state)
 {
-	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
-	int			retval, error;
-
-	trace_xfs_attr_node_addname(args);
+	int			retval;
 
 	/*
-	 * Fill in bucket of arguments/results/context to carry around.
-	 */
-	dp = args->dp;
-restart:
-	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	retval = xfs_attr_node_hasname(args, &state);
+	retval = xfs_attr_node_hasname(args, state);
 	if (retval != -ENOATTR && retval != -EEXIST)
 		goto out;
 
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto out;
 	if (retval == -EEXIST) {
@@ -954,6 +944,38 @@ restart:
 		args->rmtvaluelen = 0;
 	}
 
+	return 0;
+out:
+	if (*state)
+		xfs_da_state_free(*state);
+	return retval;
+}
+
+/*
+ * Add a name to a Btree-format attribute list.
+ *
+ * This will involve walking down the Btree, and may involve splitting
+ * leaf nodes and even splitting intermediate nodes up to and including
+ * the root node (a special case of an intermediate node).
+ *
+ * "Remote" attribute values confuse the issue and atomic rename operations
+ * add a whole extra layer of confusion on top of that.
+ */
+STATIC int
+xfs_attr_node_addname(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	struct xfs_inode	*dp;
+	int			retval, error;
+
+	trace_xfs_attr_node_addname(args);
+
+	dp = args->dp;
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+
 	retval = xfs_attr3_leaf_add(blk->bp, state->args);
 	if (retval == -ENOSPC) {
 		if (state->path.active == 1) {
@@ -979,7 +1001,7 @@ restart:
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.7.4

