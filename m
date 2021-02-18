Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C14C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0F8864EC2
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhBRSsX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:48:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53764 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbhBRQzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:55:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGmxiE185321
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7osTyVSwmEXRzaykOoUMW48UxjSqojrJKBLI/sROYa0=;
 b=TsbNTmahba/DxCZ6Fv+GtIW1l0BI6n+2v0Dg8H43TBC0fxqFoDjQYReMcWdk4I+UdDY0
 75B9t3j6iseOry+sZ/jNepihzOczdiKM9mOTa0A0+QpKmClZsvOWsl7hF9ctCBw9xofz
 i+3iJpI4ZgHy1R2CTnxY43bTxQomJSS+3m/xCGLnljmvEGWJ4ynJCf19Tsm6tJjDQ7NT
 K9Ewm014fpPx6qPfY6G55R5zMXeV52OMU8PZX0E0JgdxKNbGM7Kd+/YSawubuRshseg+
 8ht9wZeijjuB1MCpPONcuJBkxKXpyJ5IP033qrfylgk1gKUdk49WPqalGS/B9BWWmQM2 BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r6n9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoALN119728
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 36prq0qeh7-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxtc5n4soUs6WLOhphXebVkRac5M3N+cBuLzuQqdLBe6bGzLRKE+8nm2psuG2czwo1jwr0QlkQ2AAJzEkz87twWqZE4cXvm9QbbkBkgDE5lqm1fIQ8aj68Vr4CtlsKnIWPhfhSSUT+NcOntzRHXOmOLijgwkoUgJ4ldA5K2dEUFVH/nwG0CLih5NIDmOU0aI4nALKLYIunOdR6pIhplVYXSGWvSS+Ulj/ej9/XA+OyEM3oWi6trJ93pRYPLSSsXxRTd5nowaK1s4zlzdnUNkiLYjHtWCZ0RkMhsZOAfcGMhoyRoA4KC8c612IA1eBrS5/7bMOlk+9a3jIZYjp0N0TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7osTyVSwmEXRzaykOoUMW48UxjSqojrJKBLI/sROYa0=;
 b=b9vmbniQhadm24+0P08/5qUqhhQrHbc/TNy6TWUP8k8oGl5WDnvRzqWA3oYGIal4dG+6z8IfIZIbC2rbPFQ0j87+3mx9aUrkalA5m4Vmo1FUNazALRU9VliqitGMqWaaZ4lShbuxTF63/1cVcGEw2TaGpK8s9nRxcx6fHvC5VdaxRFdw/t+qpoBDNdmYiLYOXy8EIjdDNNRIvXKuJPD0FqRIk9W7b0mmDA0jl7nTBjFxXf39XRl3k0/EkNySiVEIZrBicP46RsDQqBN8EkTyC9VJPGkehO1Ybr1YCYL3OZJjfDB7zEBpBqBO3R4XBt+eVEEZVf88pt2ShBZQ+afTig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7osTyVSwmEXRzaykOoUMW48UxjSqojrJKBLI/sROYa0=;
 b=pRLYLgqr97v2/l9ZzfgWSgdEM1ZveVmd2G4Auwv9WpJKzyDjKf9eE2URl0SkcGG9qjB0USKYKhFgz30eN5wWZUpHbH5BioPLR5mP9Em9TA03yNztxJHe2CBy9rudweGxWPsa2PdsUElSw4MiTUM5v3GgHmrd6LlKE8l9pJkPMw4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3605.namprd10.prod.outlook.com (2603:10b6:a03:129::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:54:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:14 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 22/22] xfs: Merge xfs_delattr_context into xfs_attr_item
Date:   Thu, 18 Feb 2021 09:53:48 -0700
Message-Id: <20210218165348.4754-23-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f8dcbf5-22f7-4e43-86d8-08d8d42dd1f9
X-MS-TrafficTypeDiagnostic: BYAPR10MB3605:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3605C9EEA87D05FC090578AD95859@BYAPR10MB3605.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:230;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iuEChGLwUIqJLumwApsoFzylJYe3f0bvfc+uChUoyr3bGumBmyL7M827Vvd6ujrTLyrz+lXsT13QZZFuISrr4PjbAle1JU8RKio4eJ4gLfSiL6tEBD7dY6s2hwKrlzj+TTlwHcngXg7xzcax4EcLoTrOW/lopz89HAC12TVgdiV7pIWmo+wIs9rXI6O5rDKHICjYdj/q0GnV97f2ps92x0P99haV++WSSIHWl5f8acv7fAQHyHDbjgRrVUSBY1akYigOP4KXIoc87Kpw8nRpZ05caCFFXzg8tYpTlJlzC9smwDvCKUefKVh7QwIQIeRO9BfzYFk6D/nRBbe2ymGxCDFpQQq6QCC9AhktSeXIdtoAgTiRb9JAuyGtyyOL3WxZpz9QI1pto0+LUpKxQVuahDsKEq+67gsJrxu81J4RR4DiSS56ZE6IP0AJGBYyE6leY8bZeRUUqbvORbENWvCDzdl/uVfGRGZamCAo7jeEdcpUlZJRD59w1DuffYLfG3WH3xRecPHLGcl8WLAUfeP6e6LVDzij+CXqVusoURRfoHoUwxfC9rsI0D1C3zqOHds5i3azhsD16EqxcDLilTcuYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(136003)(376002)(396003)(5660300002)(52116002)(8936002)(6916009)(69590400012)(1076003)(478600001)(956004)(6512007)(26005)(16526019)(6486002)(186003)(2906002)(6506007)(2616005)(36756003)(83380400001)(66946007)(86362001)(44832011)(6666004)(66476007)(66556008)(8676002)(316002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jDi8xWnkzQRV8Nf3LUyxjfh2JgbBYWTbSuhNQnJuVUCxo6AwHRnzGQouasM/?=
 =?us-ascii?Q?KI3SLvQ69jkYHZowBLfh0bSTKZ4oetn8Bv4Eg3vSWvF5p1zcWamPT16Hrimc?=
 =?us-ascii?Q?IdOZ6en0Dmgx/0q9YGwou+UtB1pijy9v47uMu0REMsB59bNoV6dPhQ4GiuZ9?=
 =?us-ascii?Q?/keETQ8QT5ObMI6ZYEMhWSDKagiMhPRpcr1wBu3TsP508KBys8zFmdxVtiPC?=
 =?us-ascii?Q?fv8hgK90CIr54C4xW4Imp+MVeM1cdfMSmNYlLURVJK4P5UhyofBgUh09Luaa?=
 =?us-ascii?Q?hBxWzig5mPs3AKRQ7T6GS2oMciT3z4pNcwFPL60/ai/JLyyIbwXqQpnMiQF1?=
 =?us-ascii?Q?w52qdfMUh835wwOHw2piW7RmzcZOd8X1GkW568H0JyUxdAm9m1N1Pe+Wm8p2?=
 =?us-ascii?Q?mEXmAnv0+t7Docw2CN4jaFWY5E43pYeU3DdLQHhnuUfkqLUJfUCKpR5sIRP6?=
 =?us-ascii?Q?dkwdLuAIoGvIa3cvFKFbiujJsxiKVx2zDN5G1OmYoTWBFPArsb8AK5eQJAQ2?=
 =?us-ascii?Q?UvwXgVxy/Rynw1thhWipOqxRsyz1ap2Kk176Wu6ky8sjOBjQ4ZViZhNYUGbi?=
 =?us-ascii?Q?RgLoYLuEu6GEIFt8sKhgSufIXZCpWfYDULUz8f7EX8ecOMZ1kAHhb16zZK57?=
 =?us-ascii?Q?EIssUFGQeSiGl41gsTkEGH0i8w6klkTjvP0oxSgNGRadkWTj6Csi2hlPrRxC?=
 =?us-ascii?Q?2GEbay00IkSox5bUkWzkvC/Z4+dj+k627FEYUXTZMgrRUSKaP3DxNAIMgxPT?=
 =?us-ascii?Q?E66Nl6m3PFmQ2ieqpQlZSqBrR89+JDwX2zStGEF1E0zrlFrO04kXfkptGfhf?=
 =?us-ascii?Q?pDg6rIWDCrJb5H+sPVdXmDqcBxlSdJJZ0/ooxQpjTSgNqUlHcQN3qdCsmnwd?=
 =?us-ascii?Q?W1tt85NGtXpyGtTAXQ/U6d2DdzjjDDLry5ZHig9Sr26rSFD02WaZ5IAXV6D9?=
 =?us-ascii?Q?TFbUCQzGmQo7U/MQ7kAf+XJWLpqzwFHCcRgqJGIa+1y1hOmctpNhaDxogezk?=
 =?us-ascii?Q?FigAeZ6zhiwtW1fo9IjS2gOSCoF1Tf+iMqwODJG3BAw2gpwNu6Re2sILrbmk?=
 =?us-ascii?Q?1qxhDKQgPasG9FFiXHyWSH+XdeeLsHJ5vBCZlK27fhp5JjXfhrthzFpqXC/5?=
 =?us-ascii?Q?MTJbXjNDrRKe5iG1UuM6GJRFw5utgFUpJdj8v9i9O9hh/7ukNzhZpTrQGNfQ?=
 =?us-ascii?Q?p3I3beb1PfKWptRza6zOXsZDB02KfUfpHom9LOEVclsEbiic8xbtL/jZTH+L?=
 =?us-ascii?Q?DY2NFbRhbQnkbZRgnmcsZIKc5/jTJkalltU0emDDfhuZ4snrkOIagFvKufLw?=
 =?us-ascii?Q?idOMMrLTdP+ELnvF3CkRMrkk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8dcbf5-22f7-4e43-86d8-08d8d42dd1f9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:13.6493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a1TI2/AMos5DOd9rh6QPplrNcwWvQWbob3avihTy0lrtug8kXELUA7+U42EOPH+5RremW8UjZYs3WcV0uj/fabdq5YchrLroxQIfIW+G08Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3605
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that merges xfs_delattr_context into
xfs_attr_item.  Now that the refactoring is complete and the delayed
operation infastructure is in place, we can combine these to eliminate
the extra struct

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 159 ++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_attr.h        |  40 +++++-----
 fs/xfs/libxfs/xfs_attr_remote.c |  35 ++++-----
 fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
 fs/xfs/xfs_attr_item.c          |  46 ++++++------
 5 files changed, 139 insertions(+), 147 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8b62447..76ad617 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -55,10 +55,10 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
-STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_addname_find_attr(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_addname_work(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_addname_work(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_removename_iter(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -223,11 +223,11 @@ xfs_attr_is_shortform(
 
 STATIC int
 xfs_attr_set_fmt(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
-	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
+	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
 	int				error = 0;
 
 	/*
@@ -272,10 +272,10 @@ xfs_attr_set_fmt(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args              *args = dac->da_args;
-	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
+	struct xfs_da_args              *args = attr->xattri_da_args;
+	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	struct xfs_da_state		*state = NULL;
@@ -284,10 +284,10 @@ xfs_attr_set_iter(
 	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_set_fmt(dac);
+			return xfs_attr_set_fmt(attr);
 
 		/*
 		 * After a shortform to leaf conversion, we need to hold the
@@ -325,18 +325,18 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return -EAGAIN;
 			}
 			else if (error)
 				return error;
 		}
 		else {
-			error = xfs_attr_node_addname_find_attr(dac);
+			error = xfs_attr_node_addname_find_attr(attr);
 			if (error)
 				return error;
 
-			error = xfs_attr_node_addname(dac);
+			error = xfs_attr_node_addname(attr);
 			if (error)
 				return error;
 
@@ -347,14 +347,15 @@ xfs_attr_set_iter(
 			if (!args->rmtblkno && !args->rmtblkno2)
 				return error;
 
-			dac->dela_state = XFS_DAS_FOUND_NBLK;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
 
-		dac->dela_state = XFS_DAS_FOUND_LBLK;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+					       args->dp);
 		return -EAGAIN;
 
         case XFS_DAS_FOUND_LBLK:
@@ -366,10 +367,10 @@ xfs_attr_set_iter(
 		 */
 
 		/* Open coded xfs_attr_rmtval_set without trans handling */
-		if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
-			dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
+		if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
+			attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
 			if (args->rmtblkno > 0) {
-				error = xfs_attr_rmtval_find_space(dac);
+				error = xfs_attr_rmtval_find_space(attr);
 				if (error)
 					return error;
 			}
@@ -379,12 +380,12 @@ xfs_attr_set_iter(
 		 * Roll through the "value", allocating blocks on disk as
 		 * required.
 		 */
-		if (dac->blkcnt > 0) {
-			error = xfs_attr_rmtval_set_blk(dac);
+		if (attr->xattri_blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(attr);
 			if (error)
 				return error;
 
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -422,8 +423,8 @@ xfs_attr_set_iter(
 			 * Commit the flag value change and start the next trans
 			 * in series.
 			 */
-			dac->dela_state = XFS_DAS_FLIP_LFLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -441,15 +442,15 @@ xfs_attr_set_iter(
 			return error;
 
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_LBLK;
+		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
 
 		/* fallthrough */
 	case XFS_DAS_RM_LBLK:
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			if (error)
 				return error;
 		}
@@ -487,7 +488,7 @@ xfs_attr_set_iter(
 			 * Open coded xfs_attr_rmtval_set without trans
 			 * handling
 			 */
-			error = xfs_attr_rmtval_find_space(dac);
+			error = xfs_attr_rmtval_find_space(attr);
 			if (error)
 				return error;
 
@@ -496,19 +497,19 @@ xfs_attr_set_iter(
 			 * as required.  Set the state in case of -EAGAIN return
 			 * code
 			 */
-			dac->dela_state = XFS_DAS_ALLOC_NODE;
+			attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
 		}
 
 		/* fallthrough */
 	case XFS_DAS_ALLOC_NODE:
 		if (args->rmtblkno > 0) {
-			if (dac->blkcnt > 0) {
-				error = xfs_attr_rmtval_set_blk(dac);
+			if (attr->xattri_blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(attr);
 				if (error)
 					return error;
 
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -545,8 +546,8 @@ xfs_attr_set_iter(
 			 * Commit the flag value change and start the next trans
 			 * in series
 			 */
-			dac->dela_state = XFS_DAS_FLIP_NFLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -564,21 +565,21 @@ xfs_attr_set_iter(
 			return error;
 
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_NBLK;
+		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
 
 		/* fallthrough */
 	case XFS_DAS_RM_NBLK:
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 
 			if (error)
 				return error;
 		}
 
-		error = xfs_attr_node_addname_work(dac);
+		error = xfs_attr_node_addname_work(attr);
 
 out:
 		if (state)
@@ -588,7 +589,7 @@ xfs_attr_set_iter(
 		return retval;
 
 	default:
-		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
+		ASSERT(attr->xattri_dela_state != XFS_DAS_RM_SHRINK);
 		break;
 	}
 
@@ -636,13 +637,13 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
 
 	/* If we are shrinking a node, resume shrink */
-	if (dac->dela_state == XFS_DAS_RM_SHRINK)
+	if (attr->xattri_dela_state == XFS_DAS_RM_SHRINK)
 		goto node;
 
 	if (!xfs_inode_hasattr(dp))
@@ -657,7 +658,7 @@ xfs_attr_remove_iter(
 		return xfs_attr_leaf_removename(args);
 node:
 	/* If we are not short form or leaf, then proceed to remove node */
-	return  xfs_attr_node_removename_iter(dac);
+	return  xfs_attr_node_removename_iter(attr);
 }
 
 /*
@@ -808,7 +809,7 @@ xfs_attr_item_init(
 
 	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
 	new->xattri_op_flags = op_flags;
-	new->xattri_dac.da_args = args;
+	new->xattri_da_args = args;
 
 	*attr = new;
 	return 0;
@@ -1121,16 +1122,16 @@ xfs_attr_node_hasname(
 
 STATIC int
 xfs_attr_node_addname_find_attr(
-	struct xfs_delattr_context	*dac)
+	 struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				retval;
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	retval = xfs_attr_node_hasname(args, &dac->da_state);
+	retval = xfs_attr_node_hasname(args, &attr->xattri_da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
 		return retval;
 
@@ -1158,8 +1159,8 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 out:
-	if (dac->da_state)
-		xfs_da_state_free(dac->da_state);
+	if (attr->xattri_da_state)
+		xfs_da_state_free(attr->xattri_da_state);
 	return retval;
 }
 
@@ -1180,10 +1181,10 @@ xfs_attr_node_addname_find_attr(
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = attr->xattri_da_state;
 	struct xfs_da_state_blk		*blk;
 	int				error;
 
@@ -1214,7 +1215,7 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			trace_xfs_attr_node_addname_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1243,9 +1244,9 @@ xfs_attr_node_addname(
 
 STATIC
 int xfs_attr_node_addname_work(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
 	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
@@ -1353,10 +1354,10 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		**state = &dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		**state = &attr->xattri_da_state;
 	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
@@ -1384,7 +1385,7 @@ int xfs_attr_node_removename_setup(
 
 STATIC int
 xfs_attr_node_remove_rmt (
-	struct xfs_delattr_context	*dac,
+	struct xfs_attr_item		*attr,
 	struct xfs_da_state		*state)
 {
 	int				error = 0;
@@ -1392,10 +1393,10 @@ xfs_attr_node_remove_rmt (
 	/*
 	 * May return -EAGAIN to request that the caller recall this function
 	 */
-	error = xfs_attr_rmtval_remove(dac);
+	error = xfs_attr_rmtval_remove(attr);
 	if (error == -EAGAIN)
-		trace_xfs_attr_node_remove_rmt_return(dac->dela_state,
-						      dac->da_args->dp);
+		trace_xfs_attr_node_remove_rmt_return(attr->xattri_dela_state,
+						      attr->xattri_da_args->dp);
 	if (error)
 		return error;
 
@@ -1439,10 +1440,10 @@ xfs_attr_node_remove_cleanup(
  */
 STATIC int
 xfs_attr_node_remove_step(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = attr->xattri_da_state;
 	int				error = 0;
 
 	/*
@@ -1454,7 +1455,7 @@ xfs_attr_node_remove_step(
 		/*
 		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
 		 */
-		error = xfs_attr_node_remove_rmt(dac, state);
+		error = xfs_attr_node_remove_rmt(attr, state);
 		if (error)
 			return error;
 	}
@@ -1475,29 +1476,29 @@ xfs_attr_node_remove_step(
  */
 STATIC int
 xfs_attr_node_removename_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
 	int				retval, error;
 	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	if (!dac->da_state) {
-		error = xfs_attr_node_removename_setup(dac);
+	if (!attr->xattri_da_state) {
+		error = xfs_attr_node_removename_setup(attr);
 		if (error)
 			goto out;
 	}
-	state = dac->da_state;
+	state = attr->xattri_da_state;
 
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		/*
 		 * repeatedly remove remote blocks, remove the entry and join.
 		 * returns -EAGAIN or 0 for completion of the step.
 		 */
-		error = xfs_attr_node_remove_step(dac);
+		error = xfs_attr_node_remove_step(attr);
 		if (error)
 			break;
 
@@ -1513,9 +1514,9 @@ xfs_attr_node_removename_iter(
 			if (error)
 				goto out;
 
-			dac->dela_state = XFS_DAS_RM_SHRINK;
+			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_node_removename_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1536,7 +1537,7 @@ xfs_attr_node_removename_iter(
 
 	if (error == -EAGAIN) {
 		trace_xfs_attr_node_removename_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 		return error;
 	}
 out:
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 35f3a53..c0015a4 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -370,7 +370,7 @@ struct xfs_attr_list_context {
  */
 
 /*
- * Enum values for xfs_delattr_context.da_state
+ * Enum values for xfs_attr_item.xattri_da_state
  *
  * These values are used by delayed attribute operations to keep track  of where
  * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
@@ -391,7 +391,7 @@ enum xfs_delattr_state {
 };
 
 /*
- * Defines for xfs_delattr_context.flags
+ * Defines for xfs_attr_item.xattri_flags
  */
 #define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
 #define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
@@ -399,32 +399,25 @@ enum xfs_delattr_state {
 /*
  * Context used for keeping track of delayed attribute operations
  */
-struct xfs_delattr_context {
-	struct xfs_da_args      *da_args;
+struct xfs_attr_item {
+	struct xfs_da_args		*xattri_da_args;
 
 	/*
 	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
 	 */
-	struct xfs_buf		*leaf_bp;
+	struct xfs_buf			*xattri_leaf_bp;
 
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
-	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
+	struct xfs_bmbt_irec		xattri_map;
+	xfs_dablk_t			xattri_lblkno;
+	int				xattri_blkcnt;
 
 	/* Used in xfs_attr_node_removename to roll through removing blocks */
-	struct xfs_da_state     *da_state;
+	struct xfs_da_state		*xattri_da_state;
 
 	/* Used to keep track of current state of delayed operation */
-	unsigned int            flags;
-	enum xfs_delattr_state  dela_state;
-};
-
-/*
- * List of attrs to commit later.
- */
-struct xfs_attr_item {
-	struct xfs_delattr_context	xattri_dac;
+	unsigned int			xattri_flags;
+	enum xfs_delattr_state		xattri_dela_state;
 
 	/*
 	 * Indicates if the attr operation is a set or a remove
@@ -432,7 +425,10 @@ struct xfs_attr_item {
 	 */
 	uint32_t			xattri_op_flags;
 
-	/* used to log this item to an intent */
+	/*
+	 * used to log this item to an intent containing a list of attrs to
+	 * commit later
+	 */
 	struct list_head		xattri_list;
 };
 
@@ -451,12 +447,10 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac);
+int xfs_attr_set_iter(struct xfs_attr_item *attr);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
-void xfs_delattr_context_init(struct xfs_delattr_context *dac,
-			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 78bb552..ad06018 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -634,14 +634,14 @@ xfs_attr_rmtval_set(
  */
 int
 xfs_attr_rmtval_find_space(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int				error;
 
-	dac->lblkno = 0;
-	dac->blkcnt = 0;
+	attr->xattri_lblkno = 0;
+	attr->xattri_blkcnt = 0;
 	args->rmtblkcnt = 0;
 	args->rmtblkno = 0;
 	memset(map, 0, sizeof(struct xfs_bmbt_irec));
@@ -650,8 +650,8 @@ xfs_attr_rmtval_find_space(
 	if (error)
 		return error;
 
-	dac->blkcnt = args->rmtblkcnt;
-	dac->lblkno = args->rmtblkno;
+	attr->xattri_blkcnt = args->rmtblkcnt;
+	attr->xattri_lblkno = args->rmtblkno;
 
 	return 0;
 }
@@ -664,17 +664,17 @@ xfs_attr_rmtval_find_space(
  */
 int
 xfs_attr_rmtval_set_blk(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int nmap;
 	int error;
 
 	nmap = 1;
-	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
-				dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
+	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)attr->xattri_lblkno,
+				attr->xattri_blkcnt, XFS_BMAPI_ATTRFORK, args->total,
 				map, &nmap);
 	if (error)
 		return error;
@@ -684,8 +684,8 @@ xfs_attr_rmtval_set_blk(
 	       (map->br_startblock != HOLESTARTBLOCK));
 
 	/* roll attribute extent map forwards */
-	dac->lblkno += map->br_blockcount;
-	dac->blkcnt -= map->br_blockcount;
+	attr->xattri_lblkno += map->br_blockcount;
+	attr->xattri_blkcnt -= map->br_blockcount;
 
 	return 0;
 }
@@ -738,9 +738,9 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				error, done;
 
 	/*
@@ -762,7 +762,8 @@ xfs_attr_rmtval_remove(
 	 * by the parent
 	 */
 	if (!done) {
-		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
+		trace_xfs_attr_rmtval_remove_return(attr->xattri_dela_state,
+						    args->dp);
 		return -EAGAIN;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 6ae91af..d3aa27d 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -13,9 +13,9 @@ int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_attr_item *attr);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
-int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_set_blk(struct xfs_attr_item *attr);
+int xfs_attr_rmtval_find_space(struct xfs_attr_item *attr);
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 842f84d..b943c20 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -291,11 +291,11 @@ xfs_attrd_item_release(
  */
 int
 xfs_trans_attr(
-	struct xfs_delattr_context	*dac,
+	struct xfs_attr_item		*attr,
 	struct xfs_attrd_log_item	*attrdp,
 	uint32_t			op_flags)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				error;
 
 	error = xfs_qm_dqattach_locked(args->dp, 0);
@@ -310,11 +310,11 @@ xfs_trans_attr(
 	switch (op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		error = xfs_attr_set_iter(dac);
+		error = xfs_attr_set_iter(attr);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
-		error = xfs_attr_remove_iter(dac);
+		error = xfs_attr_remove_iter(attr);
 		break;
 	default:
 		error = -EFSCORRUPTED;
@@ -358,16 +358,16 @@ xfs_attr_log_item(
 	 * structure with fields from this xfs_attr_item
 	 */
 	attrp = &attrip->attri_format;
-	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
+	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
 	attrp->alfi_op_flags = attr->xattri_op_flags;
-	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
-	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
-	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
-
-	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
-	attrip->attri_value = attr->xattri_dac.da_args->value;
-	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
-	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
+	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
+	attrp->alfi_name_len = attr->xattri_da_args->namelen;
+	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
+
+	attrip->attri_name = (void *)attr->xattri_da_args->name;
+	attrip->attri_value = attr->xattri_da_args->value;
+	attrip->attri_name_len = attr->xattri_da_args->namelen;
+	attrip->attri_value_len = attr->xattri_da_args->valuelen;
 }
 
 /* Get an ATTRI. */
@@ -408,10 +408,8 @@ xfs_attr_finish_item(
 	struct xfs_attr_item		*attr;
 	struct xfs_attrd_log_item	*done_item = NULL;
 	int				error;
-	struct xfs_delattr_context	*dac;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	dac = &attr->xattri_dac;
 	if (done)
 		done_item = ATTRD_ITEM(done);
 
@@ -423,19 +421,18 @@ xfs_attr_finish_item(
 	 * in a standard delay op, so we need to catch this here and rejoin the
 	 * leaf to the new transaction
 	 */
-	if (attr->xattri_dac.leaf_bp &&
-	    attr->xattri_dac.leaf_bp->b_transp != tp) {
-		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
-		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
+	if (attr->xattri_leaf_bp && attr->xattri_leaf_bp->b_transp != tp) {
+		xfs_trans_bjoin(tp, attr->xattri_leaf_bp);
+		xfs_trans_bhold(tp, attr->xattri_leaf_bp);
 	}
 
 	/*
 	 * Always reset trans after EAGAIN cycle
 	 * since the transaction is new
 	 */
-	dac->da_args->trans = tp;
+	attr->xattri_da_args->trans = tp;
 
-	error = xfs_trans_attr(dac, done_item, attr->xattri_op_flags);
+	error = xfs_trans_attr(attr, done_item, attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
@@ -570,7 +567,7 @@ xfs_attri_item_recover(
 	struct xfs_attrd_log_item	*done_item = NULL;
 	struct xfs_attr_item		attr = {
 		.xattri_op_flags	= attrip->attri_format.alfi_op_flags,
-		.xattri_dac.da_args	= &args,
+		.xattri_da_args		= &args,
 	};
 
 	/*
@@ -630,8 +627,7 @@ xfs_attri_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(args.trans, ip, 0);
 
-	error = xfs_trans_attr(&attr.xattri_dac, done_item,
-			       attrp->alfi_op_flags);
+	error = xfs_trans_attr(&attr, done_item, attrp->alfi_op_flags);
 	if (error == -EAGAIN) {
 		/*
 		 * There's more work to do, so make a new xfs_attr_item and add
@@ -648,7 +644,7 @@ xfs_attri_item_recover(
 		memcpy(new_args, &args, sizeof(struct xfs_da_args));
 		memcpy(new_attr, &attr, sizeof(struct xfs_attr_item));
 
-		new_attr->xattri_dac.da_args = new_args;
+		new_attr->xattri_da_args = new_args;
 		memset(&new_attr->xattri_list, 0, sizeof(struct list_head));
 
 		xfs_defer_add(args.trans, XFS_DEFER_OPS_TYPE_ATTR,
-- 
2.7.4

