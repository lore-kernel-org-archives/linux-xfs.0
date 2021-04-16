Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B708C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F32C361006
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239914AbhDPJTK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:19:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48322 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240975AbhDPJTC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:19:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AnBB166977
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=wQExIpxlrPbOXVkePj9CC9uGZt+ZgNQxY7HaEDpUTyc=;
 b=F7wOcL1VXv+ppDUhoNrMg4JlcoWJRNs/I1eXSeYuMCw+p47tjqf6/9rxVR5TODtbn9xj
 gLSDmEedf0JFCdWwXSOzoz5Sp6S+q5phEiHqkoJKKoXqg/8ypkjEqT0W0KBSo4nt+JWn
 qJithwNtdrfetEOYAWUkjc4oqm1dk+3O6Y1j9VU3W/+UE3wYJD85InChhwHo5Gv1atdc
 PRdwcbgFiitW7AoaPFugsrbxGUH4dYfWX7o5AqdDCbBYr5E9ZF3AdmXhy8GHPLLbdrnG
 JjQecbmnWF972JUZ94jqJLXO8n5t5ol0lYYxFWHtiY6eYYHKXJkWnF7CMEf1jT0/xzAN 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37u3errkfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99dBP182009
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 37unswy4uk-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=micc5vxriHwFfqkKGvQyAoBW67bStefTBtEVgmvhKn2aPSNWAMl8ShWmOuFPBS4elfKx+ndq6NrA1yo6yLASwa681jLkQ4OXHPPprlBWKNkCg9ZhV1Ck/uIijkCEjpZxCI8nJUB5GqdPB6LJOgspv2zkMJVtcVUFc5qS5WsoAEaflgWQ3gAYYUJs/vvGupn8TJ8Paj/pxWKccT04pjl7i9JS8kUBiNz8ESka5OgB16Z8oMJ7AdDmi/cjuAzYD4rWI/Kt0MLM3obbgM7bZh6i6u81SSb1bgZuw0wdOhblzmIEAZFf2614Ca5udd3v2HIMAhUpiKLEsW5sHyTYwc37jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQExIpxlrPbOXVkePj9CC9uGZt+ZgNQxY7HaEDpUTyc=;
 b=E+vrQB2i4UdanJ5PhN/8nAJaZrWzpO9tcIDbJT63bzHychXAktC56wwVvtOrOj9WhMMhSINKrQKURNLrn0lltjM5qkU16oysh/HwbkCZoGR9RcEPbgfab0+LQ4QMpLKnqZ+YEjUwb9HhxK5dV794IzX++ncku1Kq/cGlYdEb5fplB4QFd7ajtguzhTfKwrYoF2rZGV65MCAA2BYSu/JhDmH7erStyVZpIAUW12fQfrpjwyoy230o3jyzPtZYG9mQ3PH6mJNNTsyLnr4E8VdSNkx7j99NEPlosDiwefR/3K69803Z7/XN8hytXg5oduI+fIaNHjZfLqIT/0rtgHI4JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQExIpxlrPbOXVkePj9CC9uGZt+ZgNQxY7HaEDpUTyc=;
 b=S2rZjBjAP47uNB6zVLSod6TJ5maxTFllVQEepBQy2X5yLWogaJksnnvpTAI/3gBUu1sGCSKCHiNQo4LJ80RncsCnu8m+IgHgXULNfGiz5T7UglpNDbWIj4gPra8cJAp+423fqJzcGozYkF5xcwfPEx3EUIJnYkT5JdBqIYF8O0M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4800.namprd10.prod.outlook.com (2603:10b6:a03:2da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 16 Apr
 2021 09:18:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:18:32 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 04/12] xfsprogs: Hoist xfs_attr_set_shortform
Date:   Fri, 16 Apr 2021 02:18:06 -0700
Message-Id: <20210416091814.2041-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416091814.2041-1-allison.henderson@oracle.com>
References: <20210416091814.2041-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:a03:60::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR07CA0070.namprd07.prod.outlook.com (2603:10b6:a03:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:18:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3182b36-6e1c-4dbd-ff95-08d900b89b1a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4800:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4800EA7B0836857053E194E5954C9@SJ0PR10MB4800.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xNgX0VzOK8S+ChVsT5B6kFnoCpnhZcYHwrJLayqbDhGo3LQaum+wzFQD0YP500rpZLrLRw0EsSzbpRtP8QYwQtxrvGp/no48wSHlFY3ahb1nYAE0zTFyyabK40iiUSw6Kvy6RGzrttGOLnIrCkAp0Z/aSeOtWFmu0xcDF20urecJ/kgaS3gnALvopVdx4qEbk0p1h7NtZjXmDxJTzLKwiP3YDGmo/qB4YipyZrXngq3/eNEke1A+Z6jfwxIa1UufZyohDyUllEyVQWwU68J8pGyMNLyAnCfxwpC7hFQa9pyGumrogq0ZE9+S743KeaQtwc6mS9YKFSl9KNTBYbifpdujZdGE6tamf+O1qRFpAEy5SCiIpSFTJ8nU9DFx3D9GrL896M+MH0AMPyy9vYS3oAeOCZwgJ2aVmiB309LGQs+8edO0iJ38gMskdyWTqbjrfmyJ+e/9JMGcFfDqd/ZAmTkm58NNUqRSOtKK0lodErSygxo1Rey6TFvsN95nehsp8jXx7b4y4+NwZfXMJ9JHC4RMAcnCIVL5ad34cIS+04K3ddxETK24s836PtpG1JZ1sJg/2mWIrsBM1DhUD3mBCJc4qhQp+VX6prHdeEo8s9OSdUYk72ZcEDavarLUV2Y7wQoXHvlxQ7QaMqxJ8gpxAweUpBa+97+OzrF21Gsmu6vWx6TEc5zNBdgoYZxA8Oj/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(136003)(39860400002)(1076003)(83380400001)(6506007)(5660300002)(16526019)(186003)(508600001)(316002)(8676002)(6512007)(36756003)(8936002)(26005)(66556008)(66476007)(69590400012)(44832011)(66946007)(38100700002)(38350700002)(6486002)(956004)(2616005)(6666004)(2906002)(86362001)(52116002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DkmOpixnTE7QyZ+wt3UdwvUNcI4gq6x3v6Vhab5dQLhVO7LdPqk3vZEXUbPL?=
 =?us-ascii?Q?KyDpYtsboASkhZoQzhj1s6RhWZrELzdRFmLZBNKeePm7dV/rU3i4NDC6EUNe?=
 =?us-ascii?Q?0blBhhNTlh2G3SCvzFNxQEIwJCzTAFHnlotWUaaq1y2Wt4naOeEZAIOYXe2R?=
 =?us-ascii?Q?SeEe1BDUhcv6f1AMgyIhWToXUUjAp68ivMssFChOk+a49NmuGpqwWO6rTY92?=
 =?us-ascii?Q?vSwjDl1Aw6jIjip6wGUx4Qa/TUqcQK4HsA5Hy61C9K/7t+hg/cRM0sQU4kPC?=
 =?us-ascii?Q?MoclYDwbJYyND4O7n74ZnP4QkT10rThnvo7LL95cxajXDk9cWMfsZY40UXEy?=
 =?us-ascii?Q?lwQfDWZ7blgoceVB8Ej6yb5EkJbLDs7pxRYW7HrtaZ9AFhp7+l3WFZFB+7sc?=
 =?us-ascii?Q?idfjRwbQzQIgKCNYB/1YWWYfC/GxfNHBXSWACpjrnLabLIZa2FL7MfiwmL7O?=
 =?us-ascii?Q?xN4mxBIVFL6DUIBX62EIOf+rNy6mxgmvNFbFapJzS5alfanMw8McFgHUH3kG?=
 =?us-ascii?Q?DTNCUXypVPiu2sEC3cMy++zWjE7MA3rMwRfpse88VDGFaefRd4oVnO2StBeH?=
 =?us-ascii?Q?MMDvmn+6fv+WgalA2LYObIlsTxGFGmYO7X/lbG+ssutIXKCBc7sKret5HI5/?=
 =?us-ascii?Q?X+8khsPibMXljbSJCUWZU115WqK8+l9f932aJlD7vPes3tlcVQfBhy7yN0LT?=
 =?us-ascii?Q?Sv+Gn020kaY4dSBAQXz7ggiElMRA1eK1z+FQeih5UWd39ys5KBUv2Bc4wcNm?=
 =?us-ascii?Q?P0nxdCE6Ahhn3SDeCGgO10geLqN7NILqbvUb7p+XoTBCByDVXFKCcfuAhBzV?=
 =?us-ascii?Q?o1jxoDQkPxB2YjUyeMT8LH535SJN3D53vvSWy3iL67nirPc45vZrraC0APRc?=
 =?us-ascii?Q?LOkWYw2+MW5ptCWfDM08AEg1oQhshh+Yjw+8Lvk6jEok6uMn4cOzBoIYb4JX?=
 =?us-ascii?Q?6eZr9x9wrWPuII3zwB6gctPTYCqV73rftn3YIhH8tD7yg65AWFHZ9Q9qRB7q?=
 =?us-ascii?Q?ipD2sA2xBpoLHLnF09McJpHkNrpAEvH/R0JkdhQWJbeTopP4l5M5qPNzH1KX?=
 =?us-ascii?Q?UEUUaZaJoBxCU6LicoCJJXfEZDi7R/Almet1b3KNtYAHwz7DRZaIL1kDr0Qj?=
 =?us-ascii?Q?O/Gxs7F3JS+J8bmEFsPdsN3WS9fgP1qriq8S04vzucH7+f7stjiQoyWW8ClI?=
 =?us-ascii?Q?os6SaLCll8IYwekNLc5M5tYzxWlL+tsZDRsj4yWdjO0C7qyl5ab8PlkAJ8Sk?=
 =?us-ascii?Q?FsL3fN7twvr5dKCdLyCyMMo3hS44jl6fL0a96uNQPHHwU0PX4WCc0YzTHATn?=
 =?us-ascii?Q?RXsZntYrYG+aLB+iXcsZR8k9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3182b36-6e1c-4dbd-ff95-08d900b89b1a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:18:32.7230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQGhsTUdQWRYSSABBgexBHtfMoa0r8upwjVf2t+nlu/0er3coEj/8sIxG9GQVosPUnNjuBDiGJHrBsiVA67nQ802DnOm4f8fIvv1CgmwKmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4800
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: rhfrX-XAM8AdBjGxNXa-v9rOYRNnhYiB
X-Proofpoint-GUID: rhfrX-XAM8AdBjGxNXa-v9rOYRNnhYiB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_set_shortform into the calling function. This
will help keep all state management code in the same scope.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 81 +++++++++++++++++++------------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 956a832..30d29eb 100644
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

