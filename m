Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3342C43381
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE33161606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhBRSrv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45878 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbhBRQyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:54:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGngwT069595
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=XpQTPeHbjK74SZ8vmljbqNgRJvR74CaIxXa2tn769B4=;
 b=t1IhaOuO3ya/TIE+PETn9U12jlMi/OnW1cNDbCgVEcTmF+Wjk6BjKWKnMd1qyiHPNCpE
 Gf9GY/lYomxpfQlsI+IMSj1ovc2GuQDtFDIxXrfub8/7jDLREQ9N4+5tzKLp6uBBiLTf
 GX4iTzRig1PNvQErvRYnsUsLoOrahrjhRxpjk2Zu9e7YPvrIZoVYldxz5mEgTghL6Mfj
 7TQrNcq26lv9XBncTmFW1rbDy53LrTsQE2r3VzWJpsHDYLhIQB52nCZ1UpRO/TJAjBRg
 DrjQf0cqxKclZy/7Zs26TsY/tTTnPxv/Gfx0wgPp5UrFvOXQt1bBRlV7PHzatmDqcR2M tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ae4pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoG3R155234
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 36prp1ruuc-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFrvgpUoe7n1iOheQVtqRzgdr7duviowTfgAA4gZs8t56+csjeoxJj/Oe5cnhOJI5fVrt07cxlb5F2XRlvTgoJZJ/EU+052lDrC0onnJg7Sw5CPWFKdqLG1kgKl9PEdqSvZPBnvj/+wsZ2t73FmLxuGxRmv/oJrMXoJvoeD3RDtjq7gRUHhWU1Pp4tsBSfaMMWGZUZb52sliM7b7uX3rrU4tGbx+3qERZrzUvzxrLBtqC9TJozrF2TWjTsm9QbWaV/6Rmw8pDXHFnw5wrybUKiFzggtet9BUKiNpYz6PfiWcqRCth4/L9ZpJ7re9JMhseM+oWUJSisReEM26H+mqjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpQTPeHbjK74SZ8vmljbqNgRJvR74CaIxXa2tn769B4=;
 b=RTmTWsm4JJBRNygQc0NPujY4BJR+fxS84Gc+YDsuqoc8CifOJPkULXNfCjzAszxKumXpcMm6l+E01x9p6TWYNvi0K7pN5ao63Afrwcjm/91v0epwF71y7XFJ2rrvAk32tewVTI8BoKWRdIPwX0HvbqsbXQviHOOpDNMDtmlSRyZXkGlW0JfwtEJJinXtpce4zfnihp9aM/HYHh2LAxCgWNkZK1U9jrDQ2hFST0KSKyEOFBtKV64A60UoXy/FPzGB5stJfmVgUqM+gwEXfGjhYruZl9Cggsq+xjgb/AoJi2jfIncBygMfKHVv6mZ2BrEADMHi7hrJdnQmzCTJ6iPGbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpQTPeHbjK74SZ8vmljbqNgRJvR74CaIxXa2tn769B4=;
 b=MixOG35xwhQJ5ACuk0SyL5RkwKdRauAjWHDLWl+uRPX7DuY/d25DqP9earQHlUfREKZ4a1X7rTlVn6ufLUCJDTv4H2vwtsHZ1HfkhPspj1XX3x49HMRF/SoXwad8S4H2cRzLtahuJ+laquvt/vVVeJEUu48ANiAARVenJuxxV7o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:06 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 07/22] xfs: Add helper xfs_attr_node_addname_find_attr
Date:   Thu, 18 Feb 2021 09:53:33 -0700
Message-Id: <20210218165348.4754-8-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95d7c22f-d37c-47ba-fdac-08d8d42dcd8f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3381C3A5220F3F2CF3DA332495859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YeeMBrt4VfeBQRJyFOrCdhnNUyHW5H4gxRTblsR6HTFMiG23BJxZEVhlZoyVZiwI3FGMPt8RhtprJw3AV25lwEucuKX7sc3beJ/voTwSVhyeLzRtzwU39oyruAc4Gdj+Hajrq9yYk3K6pC+YIt7xBzRL5YK75q059PTxzMHgttWfa6HAczNkml/byxGrmEY0LhhPTeiOmUJrZUTIpKsMYnQfhaCVezInl2qc6Cg6F6fNDwWGvTxVypLx1dd48wA+/L6M0PgG98FIeCtD0YRGqH+Lu60nq5ehUK1t5ibQZ6I3OSuuvjpLoxx/dmfYdWwdnAQHEMRRtKhJK3E9EzC5O5gtbN7apIiQuqa+iDkuqn6V7xBsYY0YOUGehwdCHUExrq5pkxi32b4mZcD3i0KR/+wXMGWqxtT7nW7U1+wIXc1f7tvHLMvkbUF39cLyqJulpVeRU1dkhuSJwCiatVaSAi2iGZp0PKTi/O0ip8p2caAipo39ANoTmktcYxFN9Z9xGV3YSmkXVBT0BZF9GNKt7i/Dns6K+VVUBHGptdESmUT6QJLx5pBtXgeqzzNNGqoAQ/i76gsnSnaXBnQNkOtQHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(69590400012)(36756003)(6512007)(66946007)(6916009)(6666004)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(83380400001)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5veJdHyjPVms13Y6M5XiZn4E60cxOyjnxgNsiacN/6TcxSmbvOgSJlAGe1PF?=
 =?us-ascii?Q?sRYH9zsDOGixe0Mu1l2FCP332GwZGZ1ZV4+TFSVQOHI2u2WqEV/Kuh29jDNI?=
 =?us-ascii?Q?9VhWgyW2XdJ/u8sgW1ThdW0pGJyjPhfOXbRViCRf753vl1KsfFpWEAC/R7g8?=
 =?us-ascii?Q?Vdt4CQJim/xCHJQ4OpUQMFYvoBbzNJpbpm8EjNVVU182IGhgUwOtvkW+SYlI?=
 =?us-ascii?Q?F01FDHT2QY6v3vuucYJYkkXZcu8hii3EwFCTRDM3SUmjMnXgqc55UsahLq7/?=
 =?us-ascii?Q?W7Qsg6Sq47Nk71317R26rL5b0Aljq0XQ+wAzqDNpd8seBeUlr4jzH5ZSkEVA?=
 =?us-ascii?Q?ld7LmvPZ8vHsKjsM16uag2oxy8SbIGFugW3WEA7PsmQqqr0jZB2RS+Rebo8u?=
 =?us-ascii?Q?sXJ8CpbIENfA1uhfXf/mqnV/UoxpCIi8+0AJQ4cg/OCT3/TGz9Sdd+h9AFYH?=
 =?us-ascii?Q?NARoaMN2zkv0Hpfd99K8UorOrps6RXglfgy11dD9lwJP/jf7M5r7aR/ovn2n?=
 =?us-ascii?Q?ktdpZi9EM+kG9dHjCvjrNhAs8uTxM0/VTu10r4u95qTUtmImtGUiy013N2ZY?=
 =?us-ascii?Q?j92VCeCxB65n+l8SJKWO6l8cM7ZePWBnJqigiTzLSd4DXigt7ojLRjqv44u4?=
 =?us-ascii?Q?ZpS/+w450Y/WiFMV4ktfRDPSEA46cAt0anqqSy6o1QUXTpDs2vHNSKIE/Kbj?=
 =?us-ascii?Q?u3TyLS3gjhpz4MKmZ77GTNMkyJu9+Xug6ZMp8S9qkyHraoRyWk96se3hl0xL?=
 =?us-ascii?Q?+SxE0273LenPUYTA9wjQl7k3PD1/Tug8jxER8RoPksJ+JRrBA8ZbgxoGaXpQ?=
 =?us-ascii?Q?NZ351u9CXoi9XDyl9J0zUHQY+W1s/jhiz3EexSoD86WKot1nM7yrSWWjMbtW?=
 =?us-ascii?Q?UBDri8KyGbS0NlsSxkT4j6cKq/LJNVem2JfjwA2yN17igvolAVTV+PBDqLaW?=
 =?us-ascii?Q?1tgkiv3r+dCBtTJ3Vjda9q9t/TOi6+jS1JTuWj9WebayyM0ytuxCiXUnTZVF?=
 =?us-ascii?Q?KGarNaXp+99PpP8BxjQhPHtxfcqGW1mMG9eXSCnabgh3Ln0tLBZvAcn+6oeC?=
 =?us-ascii?Q?S5aOCAZbIeCPJlFoBt2H2U9SObpcva7RzG8G8Rh6OLoDchvbD4GN2t+TH+wS?=
 =?us-ascii?Q?q4FzXC5A4A7hT6q6fDR6/KjQZtL/gPRnwPnn/eg1mYqgZZGuKPErMsuFVmqy?=
 =?us-ascii?Q?EcAfZvGJAd8hCevRN+etZm6DB6PPYFYyY/gb/YpGBBJkmzp3ggiYupEs2Zqc?=
 =?us-ascii?Q?4tXTIfCFJT7bLgHqsNNeqiK9vFzoz7vLEg0WfrV2Qc+0ro3EQHk3ggU1lkNR?=
 =?us-ascii?Q?aP4TpDtPRml8xbpnDUPGr7zw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95d7c22f-d37c-47ba-fdac-08d8d42dcd8f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:06.1622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/KHaVp2qmWBxjksWp6egO8O60EtZ+yzuLRmyqurIxw0F1/esfTiZJs/QviTrGHQa+pet07GXLV+3131Ex0397G1XY+iU6lo9at++YJTKHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separates the first half of xfs_attr_node_addname into a
helper function xfs_attr_node_addname_find_attr.  It also replaces the
restart goto with with an EAGAIN return code driven by a loop in the
calling function.  This looks odd now, but will clean up nicly once we
introduce the state machine.  It will also enable hoisting the last
state out of xfs_attr_node_addname with out having to plumb in a "done"
parameter to know if we need to move to the next state or not.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index bee8d3fb..4333b61 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
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
@@ -883,42 +894,21 @@ xfs_attr_node_hasname(
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
@@ -941,6 +931,38 @@ xfs_attr_node_addname(
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
@@ -966,7 +988,7 @@ xfs_attr_node_addname(
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.7.4

