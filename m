Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C3CC48BCF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 05:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 061E36120F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 05:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhFGF3z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 01:29:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56700 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGF3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 01:29:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1575POG2165358
        for <linux-xfs@vger.kernel.org>; Mon, 7 Jun 2021 05:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=RIOafJpcx6WkdTHytKo1zW5QlHVnE6R+PNXLaX5+rXs=;
 b=mjBAVERq6TM/Bq/4cAQjsIOwZxaW+8pHOdftfJUNldtwe7WsAW+ziwuXz9gQV4IigVfc
 EEZEjJYh2+ETgz59eAQq0wXOiBv6PNxJ0srRa65d1XQczOs1XiX9PnvQqRn5pbB2YtNl
 ydQfEO+0FxWnqJL65Trcq+Be0qohcRY+/DHNArP/jf/yckEwMWMGhsnxyWCLixg2PWKg
 4PzFgx7k1WpTvkZkKNvLvYvdxkvDV7G6o/OR80c3IBn+76TNXf/Y/FZcOcWn7K7u8z6B
 4PLahpDa3NeVBx1wNSRB+9LlekggJEU5ERpznZAmTFjpCKcqiHVqUYfRWQLcDwXq9hib Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3900ps1ttx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 05:28:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1575PmCn178624
        for <linux-xfs@vger.kernel.org>; Mon, 7 Jun 2021 05:28:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 3906snnq3j-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 05:28:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzbpO9L6ObpYjnpz5dUGviqabkGv9JcejDpnoZcfzwyqAV2DFbAE+tLY5wEjb6MpjahAbuODbhgVHZ+TVjeDeoeavIQSY7qjUI9MTtcLGpZENN+e54fTHNGMC80dCvvX6dRkgimxg45pO1jK6qG4c2wqoL9pylCGk/3l8ZgNklPkfXNmWzxKEN0bIPHFVo11RAR215iAg0GJOLqgoSznXGWVuzbFyTT9Kl7/eaBmUDaASAv5hEtfKaMMPOhr2LPTenjk39wBHhcb30EdaU8AAGoFc/OcWV6kBcTeVfEyp/3GXoNGPqE+MTzhAlXpJa4h/GkjPoio4VKvFqU6thZQpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIOafJpcx6WkdTHytKo1zW5QlHVnE6R+PNXLaX5+rXs=;
 b=CljuyL4ih8eIhP7hjn2dRz9FFBj7aOxhSoiN0xNfWxGcoIAc8gom1kIYdU1ujmQ3COzJPVvqFdpd4kBMONxlOr7JhXJdwg8M02+jC/BEwMV8JsyN+4wyXJyPDyto+DPvI93YPwdVWr34B1CzgxdgBPRu4EGxWW0eCZELbVMQKFLDJIRhljZc9NK/0Q/vj0CxYW7D6zY2YEIaxEYAimrmtOXE3d5O7Z2+sx6T8boLxCd+7qHTdUqs3ededqbndvj1MdZDaELbR0BgOF268BPahE9xsNIpBqpasyFZk8pC5y4Rt0Qp/eZ5CkBmRp377HCIodzkHCcKnxtC6dq58loDAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIOafJpcx6WkdTHytKo1zW5QlHVnE6R+PNXLaX5+rXs=;
 b=mHTvga5ztzR14/2xvu41sPhXOdjn/fgK0Y9N+1NdhOvAsMRdX+xSj6mIrqVQVvjJHC+h3etIpiyqDwVDBSIKBHUwu0NAAX+7GunpsF+OKOoYYp9JenoLAwpgtP4uEYe4PkurhqWbckQQ8i9qfAnHMgCwmkks8PK1FvxufjIgR34=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4687.namprd10.prod.outlook.com (2603:10b6:a03:2d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 05:28:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 05:28:00 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v20 14/14] xfs: Make attr name schemes consistent
Date:   Sun,  6 Jun 2021 22:27:47 -0700
Message-Id: <20210607052747.31422-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210607052747.31422-1-allison.henderson@oracle.com>
References: <20210607052747.31422-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:a03:100::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR08CA0019.namprd08.prod.outlook.com (2603:10b6:a03:100::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Mon, 7 Jun 2021 05:28:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 841919ed-0bdf-4fb1-190e-08d9297503dd
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4687:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46877DF5046D013D4F76BA0C95389@SJ0PR10MB4687.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C2QAo9hQqkzIPDaKzwVIux1y+UgefjDFrAbdnbqJedfgMMcl4N7mRQ7Pt3GN4vH+Ub8Ysz6xcfpxJxqawTDnZqL6cWt+ZiYMjG7KhW0AmE5C/Oa89oQQbB/qSAFtnwsxsn5V2MRglJYrvhlcT2xx6ldYS9GnU4wyaujpUD9VQgr2yJ90dsd03BOZ0cg/2RsKuYaSM5LySgShq98/6ocBneOCAfiYSIQA2SdUT+AbwtxLBtJ+lnYF7odvc0EjivA6vXiuoqDqvXIhqLnUxcJauRpcRTfY/IWW2odyOqY7cXq8/F/eqLGaeApLdwWqOu9xt0EkxInJ8q+tU2eT65VheIirdZF0QFfz5L2FSO5WxENhufFNxxvZmUIx3F1jD7NGgd31pp/LON1qi/ZT/KJUBQMAmTeZ4cNOHJSG/LXLnTTb8sA2DywG7cxDYLUVvDSIx6TxzgPp3uIu3oHYuuvXG5Kehf3XZR+EsQGmH9uo5aJlWgcgoVmGvAgHlrqIliAiOzBLDW1E9rVBpeAhB26MnJfguUr8fx2kLJg2+WFmoaRacQntSAYwQWpV621jXXrSqYYacxXNQQ71QTSBFAqLmPW8eXpPMjRGJL4dTnCW58M33wFd2oE+hqh7qee32+3+tkJhZqCYuuu4MJtOzM4nbNZrmMusLXTvNbhL8xa7hBpDEqGK3P0ByLPt+xiQC9NQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(136003)(396003)(366004)(186003)(16526019)(1076003)(316002)(6512007)(6666004)(8676002)(8936002)(38350700002)(6486002)(26005)(83380400001)(44832011)(66476007)(66556008)(66946007)(36756003)(86362001)(5660300002)(956004)(52116002)(478600001)(38100700002)(6916009)(2616005)(2906002)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SsULyKyAtStW4UqM3yOkV95n7GYDI/GG5BQA+cFa+pqNfyqQqUTNQyzLDnUE?=
 =?us-ascii?Q?foWIn/0yTpL6Nfu++gelgfbVkR2+/NwFaL3Zu4QFDAJhLfI9kv5Reevs+Rtk?=
 =?us-ascii?Q?A9srbMzK86plKu4GqSGDQMUPHYLGc98sTBofPdLNXdNlztnAYji0VhPhiZOy?=
 =?us-ascii?Q?g/nTtvrDI0B8lxHmV/PApjkHt4EO5WNXQDIStR4SsUO0hw0SeoyXjTBtfSZF?=
 =?us-ascii?Q?SVnXVq+BND0lwpDL+YG0+vm/EROOBYXi0tuWfS0eV78ueIfXjWFvYUQdCsHM?=
 =?us-ascii?Q?4WjoihkWIosNQZy8l0j0D8NRbKWq0dDk9WHaQlZNdY96c0sm6SgTiw57I8ko?=
 =?us-ascii?Q?YtxgX2iEl2qewb/cx+SFNw1D6+VvGz8HuXv7TP4Cm+3azuph6V7HaUhFmfgp?=
 =?us-ascii?Q?FIokvbvSySFYeQn8tjBlzMY8VVjj7WJ6BFEKl1gxE6vX3eey4565sH3ngkcO?=
 =?us-ascii?Q?QdRSu3tZI9XMzk2y1SGv1ZOnxM372dgAB8i0kpD3rYo1+kUYRfmSZ/Mq1zaD?=
 =?us-ascii?Q?5WqbS5eem4HpLjdrNeeSnDzzRb01c9rTcQcI9GjZzsHL3EVGkDuv74gsPr5x?=
 =?us-ascii?Q?0M0uuNXOH5DC5+QiC0KF1EtOOEa1wfD7IvXKgOA738GH9/7VuqWAIu8eoH86?=
 =?us-ascii?Q?VuxkzVZkz0F8sKRrfoLfPaz5AvBge7RxXpSgIaqIrm1w6s1zC+E2KdFtSrbv?=
 =?us-ascii?Q?a9FdrkKWQIWHt1adFvW+Q/vW2/Bt+l1dcMgv1YOrEhEj4OHu5l4NZc0vaioc?=
 =?us-ascii?Q?R3E+UBhIeiKxPI+V+nMcObnNLc80IUyDBJycJeoavtHjFcTVwNlACuE6nbJ6?=
 =?us-ascii?Q?SgjWUsqSFcT6DEf9SzajKqwv7bdsfp1/l2L9miFy/uK3Pxu4SlV0XT6RikGv?=
 =?us-ascii?Q?KMbFWlQ/saQGdDkR8IpsJRhEuPvo/QYr1gvhA0FzkSjgMVyMA6XnBV1eibqh?=
 =?us-ascii?Q?9BUyJisYJ1OSax+Af2u/FOrk5UqVxigziuYc1yC4DJSa9GgJOwDXBmboMEzl?=
 =?us-ascii?Q?m17DIRywvKXugF2kiPb829U2AFZtiQhaqQf2JH10UiebjwDSgAatDqOKul60?=
 =?us-ascii?Q?1GdUiCLemWy+9ngKd84PW84lqwTkkbTgnB5Y9z74TZDLMkbhKrX+Sgza27LB?=
 =?us-ascii?Q?IsT07IoaDoB4iZxqZb3g9Y14fGnZzWnZfiK3AaxzK0r9W7LfOhVO1jzekKmv?=
 =?us-ascii?Q?QdZoMMR9YqZIq8+gaeLlKv4hKbehZ0N03QkEdHveIMVheSpRAfF+0Ftx6591?=
 =?us-ascii?Q?HF7qwgMObeIqwDnAHlft3TWFusDovyB4huwv2yJXhAPsLKx/0CVZohEMtg0B?=
 =?us-ascii?Q?y97BY7OaKqFJg0B16tCHe8BI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 841919ed-0bdf-4fb1-190e-08d9297503dd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 05:28:00.3574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGyQi6o9eOHpCnDL8g+NiXDmsHKW3f4vdliVzbWJRuZb+S4mFotAbaoBb6uQ4j2n26tTM4sbvVJjG9gRb0QgZT8uSQV1+E53Gr5fJ3Imkhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4687
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10007 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070041
X-Proofpoint-GUID: raIyEY1mMXTAopyqZitdr1m-Z2Aqtzz1
X-Proofpoint-ORIG-GUID: raIyEY1mMXTAopyqZitdr1m-Z2Aqtzz1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10007 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070041
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch renames the following functions to make the nameing scheme more consistent:
xfs_attr_shortform_remove -> xfs_attr_sf_removename
xfs_attr_node_remove_name -> xfs_attr_node_removename
xfs_attr_set_fmt -> xfs_attr_sf_addname

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 18 +++++++++---------
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a0edebc..611dc67 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -63,8 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
 			     struct xfs_buf **leaf_bp);
-STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
-				     struct xfs_da_state *state);
+STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
+				    struct xfs_da_state *state);
 
 int
 xfs_inode_hasattr(
@@ -298,7 +298,7 @@ xfs_attr_set_args(
 }
 
 STATIC int
-xfs_attr_set_fmt(
+xfs_attr_sf_addname(
 	struct xfs_delattr_context	*dac,
 	struct xfs_buf			**leaf_bp)
 {
@@ -367,7 +367,7 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_set_fmt(dac, leaf_bp);
+			return xfs_attr_sf_addname(dac, leaf_bp);
 		if (*leaf_bp != NULL) {
 			xfs_trans_bhold_release(args->trans, *leaf_bp);
 			*leaf_bp = NULL;
@@ -840,7 +840,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	if (retval == -EEXIST) {
 		if (args->attr_flags & XATTR_CREATE)
 			return retval;
-		retval = xfs_attr_shortform_remove(args);
+		retval = xfs_attr_sf_removename(args);
 		if (retval)
 			return retval;
 		/*
@@ -1223,7 +1223,7 @@ xfs_attr_node_addname_clear_incomplete(
 	if (error)
 		goto out;
 
-	error = xfs_attr_node_remove_name(args, state);
+	error = xfs_attr_node_removename(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
@@ -1339,7 +1339,7 @@ int xfs_attr_node_removename_setup(
 }
 
 STATIC int
-xfs_attr_node_remove_name(
+xfs_attr_node_removename(
 	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
@@ -1390,7 +1390,7 @@ xfs_attr_remove_iter(
 		 * thus state transitions. Call the right helper and return.
 		 */
 		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
-			return xfs_attr_shortform_remove(args);
+			return xfs_attr_sf_removename(args);
 
 		if (xfs_attr_is_leaf(dp))
 			return xfs_attr_leaf_removename(args);
@@ -1453,7 +1453,7 @@ xfs_attr_remove_iter(
 				goto out;
 		}
 
-		retval = xfs_attr_node_remove_name(args, state);
+		retval = xfs_attr_node_removename(args, state);
 
 		/*
 		 * Check to see if the tree needs to be collapsed. If so, roll
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d97de20..5a3d261 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -773,7 +773,7 @@ xfs_attr_fork_remove(
  * Remove an attribute from the shortform attribute list structure.
  */
 int
-xfs_attr_shortform_remove(
+xfs_attr_sf_removename(
 	struct xfs_da_args		*args)
 {
 	struct xfs_attr_shortform	*sf;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 9b1c59f..efa757f 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -51,7 +51,7 @@ int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 			struct xfs_buf **leaf_bp);
-int	xfs_attr_shortform_remove(struct xfs_da_args *args);
+int	xfs_attr_sf_removename(struct xfs_da_args *args);
 int	xfs_attr_sf_findname(struct xfs_da_args *args,
 			     struct xfs_attr_sf_entry **sfep,
 			     unsigned int *basep);
-- 
2.7.4

