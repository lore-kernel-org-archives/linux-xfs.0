Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655B9C43459
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43A0961A49
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhCZAcJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33302 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhCZAbz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Pwbg041111
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ekCc4wEDKfzX624S75DC8n6dUEbGcSmZgZqzkon73zo=;
 b=W3Wz7u7BF3ROKCcF+AOt0n+qDBHDom0ioMd48Gy0FErmcsvyTJ1pVuKLKK7GA9lEmHMO
 fHA7tj49GSC/4U4BB3V+ZSbwGA03j6fq4RyqcUhrVW/12fEQ1eJL//5XJq6Akma0TgLU
 9laVr4BGwm6BQF3TeSEdq006P0fWYahnZyZQ4shUm2b66XPSFcwQ0tHyoxM4t9gXR/uE
 p2axv3XUrmsatKGMC5G6FC1HAnEhBAyx44CQc+FPQIaIGcpY0U9luwIbRDtRh0hrciX9
 cHG9A93WR0FyV6DW1cAhmDjFFFE+wkQ+GMfnUsvzMtVVA0HQfIHOKdWOdigQCGslAYBx 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37h13rrh8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Omuv009664
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 37h14mft65-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivE+lZNApZKYeFWKXPcAr+u7+ERMZ5doH5wxeHuEh6Um6MV28a3FRYSY27jxFAdyCXOOtqfMd05NXK8pRVypzOOsXfhDvvQHBdjmqojRo9/9V/SbrBhs5wG9YEO5r3EjWvqTNZMK3HP+lRJvgB+5Du4NmNF7fKAgVyFtbUWXRPW2CZUSTL9jprmSLseqOFUjAirTauoDnVhjz2EV2q3yNpP6VVMw8SVu4kQuEM4/NhvPewBE0wM0XeBvxyaQovAQfe6h6UcaTy5Lxey0Bjy3VdxESSmb6nTfwbVhdW4R2F4Us7HEbet5v3UW3jcvue7lb/Sooo93tDJNjyQRQSplrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekCc4wEDKfzX624S75DC8n6dUEbGcSmZgZqzkon73zo=;
 b=I9P6N6+R70qktbDHLyR0Z1ktFV+99zJIr0B1UNQjAkE/D2BmDV0tOzRJwdNUeKSGBBgzT9uehnQ3ObvH07ZhFtvVFneXvcyn7i8QHJ8awOhy2fzFXeILYy5Tq5gzhpB6uOsgl5kmxJGvgdptmXjL3TtR5HrSdOAumiLK7bfUdCOL4WuuDArjH3f4VYgRJwFiGdywIVAwR1VuNmF+lMxn6dgrx7gPrChDxj2FzLZ70M1M3szkg0XKlGBvZEJsobX9oqZlPVoMj0Iucy6R3o38bxcuabESsCUNW8ZVdvr8BtSldNHiuTb9iKzVd7AewxT2duBuXKkCZd+H7LVkwSDifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekCc4wEDKfzX624S75DC8n6dUEbGcSmZgZqzkon73zo=;
 b=UR9s7WNBSwpnCjZsArK/mmA0AwnbDQkq4+6tsCG8ibGynYKC8jfBGXIieWHJzrPejtyAtRDaLzDNsMkCmXiQGhKxPKxWUimPoxmtmKKmIiwckIwm5E3d7HNZFnVlopjx+71q5e3n+EOehrQ6yKSZ92v4cdx0mzwhQgXfzH8ykVI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 00:31:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:51 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 24/28] xfsprogs: Hoist xfs_attr_node_addname
Date:   Thu, 25 Mar 2021 17:31:27 -0700
Message-Id: <20210326003131.32642-25-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10f7e5bd-61ae-47cd-7ca2-08d8efee8c5c
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB270963B3DD67E766EED8CF2895619@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYlLDxKRlid56EzpGxK8AVTZHWxaUl1VKtuGkX/leI8yRCv8xYzZ9ZSGGhir9fMGH2INakn69OBGP5K3UjNrC4Hw2CPgVlFdhgM35PocQfwkIsvqvnSIqSxIL1IvXkGPL64oygwiUgVKELQO+AWDnyhY9xO19nojtzGy1u4sLDW4XPGMyAnpyNspzhD9tBQfVXIvd5IqgKRvMLZxDz2XfEtJs6wHwTb/OwliPdi/G/XnkC9yUKHkdtb7Fdfy7iGdJxWXUxik73vHHzPupgTu/hAugOsHd+J2eCZ0c6vLplx/lSXvogv7newyOscq5G8hsgynaCxus0stPd+9EG7OG7ESXpEiPBHzniCCiz7PUU5HjcaUnc+3Guq5d5mmAb73AIoPTw3t7qs6iVacLnoJanXeu2/6E3nIzjXRDOV2qiFztdQ0YOhdo9wONw3ofGF7YO8Hc3oNb3/j39AOg/faAd5S6JQXC3Yb3ufOCL13LyvAnfCWDFOAIR5Xpv9EH4ZHbrehQHv/f3fXDpxZQd6Wp35PM3gvAi1kZJSG36swPYIc81zhIxEbGr72bD80gXv0lRrZCVqhspHGVNdGfQr3K0SfowEj3LP0Q4YhOhstFhWABQ+haz3C+dgiV4cQRLVtoHUX4m62zQmTSF8ltpDp+/se7geY7QtMJIysOxr6oi1lNlX9u3EDSddUSjk4TW65
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(346002)(366004)(1076003)(8936002)(6506007)(2906002)(6512007)(6486002)(52116002)(6916009)(5660300002)(8676002)(83380400001)(36756003)(66476007)(66556008)(69590400012)(86362001)(38100700001)(66946007)(956004)(6666004)(316002)(2616005)(478600001)(44832011)(16526019)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?93dW3K8PfhDGipK/SNk6YMxQH9FSbClVIWqnd7W4c3joO6zYpvbB5hEBIWma?=
 =?us-ascii?Q?qLggog14h73SyofNb3sn+p4c1vcxpyZk/T7vWAzKEceyEjUg+ds2UCUtfhx3?=
 =?us-ascii?Q?ApiXbZi+5zHvb1/1yL5vyXKbijHLWpM/SrnAxj+RqFhn2Xdr1wWZarDC0/O/?=
 =?us-ascii?Q?Dv8C/4z0oAeW9Rbzh1LSoAfAKd9a+cQ/trZ5TQDNInGB3+V/iPBBP5PzlZrQ?=
 =?us-ascii?Q?kIONO7g7PDX9sNFbmjAw5rIkpNhIaH3kBhHyV/Dz4XXkkSe+1gErtSQch8C5?=
 =?us-ascii?Q?Y+dHaPai2hpipEGTbxhtuUfm//capg+CE9xGfpD+ZA5mAI85ZHjS3IxxVljD?=
 =?us-ascii?Q?SQpEmcy88d/zjaXH4XKexl7+laELfPCdIrowh2AEQWu1ibtOXxzV8Gwhguta?=
 =?us-ascii?Q?5gVdj41tbDQ24QicHn0/lTgYgZYscBzvCWOQnMWMaqw5WTbwoQS/mB4ifdIk?=
 =?us-ascii?Q?suA0DURs4CwN2g/iTeKg/xMW9HRsyo5XT1Uh22JYMomKl3ca+wz3UMnAWR2R?=
 =?us-ascii?Q?zH56UrC+N9lZwW+xNzK+M41o1FWBa6HNBVbguGRtRlWWwyaD8NtohR1xLQKu?=
 =?us-ascii?Q?ypEMZ+SYJmqaJGVw2C4tKNWquc7d55X1a+GyInXvq7lwHhMSDUBnYLbrYOi+?=
 =?us-ascii?Q?kx7KHFCsGqOs70bWSJm43/H/Q/bEIcJql/lbT5vW0EQWAUbTEdzjdChs+6bU?=
 =?us-ascii?Q?PQlzpR6otN9/ZzUaEzWnj0HxkohMYpCIR0LpR7dJvHQLM0BniR+fMBEQAHjE?=
 =?us-ascii?Q?dmmI3Xi6wPvICCOkHizr8vRGGBXRdWByMReYZ0sgFoKYPqSSdm/BjQ5NEFvh?=
 =?us-ascii?Q?eLFXYJdVVe6OvKdP5PDyjWVFU8NORyCYXM3u4VVyxdj0o+PoKuEWRe2p4DLq?=
 =?us-ascii?Q?7BxCyDkzJ6Fi01nYGf38Utbg3pJTOiwJb7Z1yEksCUeKY9c56I+YDypnYfN6?=
 =?us-ascii?Q?eqvSxHjW5H0vsiLewHVNN4uJ+wjToZC0mDjvQ6XYqmsqfa47AGPKsIwGowKg?=
 =?us-ascii?Q?aeCpYJh7jdwnkSsa7SGKFtNCZHL1LmrsRp38ceAb3eDsoPj34VnEWNeKtKai?=
 =?us-ascii?Q?c4x/tnWBgNFbj4epFNjtVeZCTeh5JZA0uT8gRheiFt2yxtkl6Ut/9KP3ZoOH?=
 =?us-ascii?Q?2gDI6GIxvR5eQWDHVl4AM5IssqZI/hACsfQ8m+dXxk4Rju85BT9xPqLq5Nwm?=
 =?us-ascii?Q?j7BiIJLx+yfob8NQkeA9yzUTgy4y13JXY4ayZJ4TO3208ugKoD8u5+vqKRnc?=
 =?us-ascii?Q?Y015MwXtLeprTyX+qtyvu3GerN70GbCSwWnGpWt3GddyyF3JS0LvrLLpc6aX?=
 =?us-ascii?Q?ISjYMDDAY3XguKWa0FT6WqZH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10f7e5bd-61ae-47cd-7ca2-08d8efee8c5c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:51.0495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHx3ZCXP+LbuMXrZzvhLBpiP7Kh2k3QsU+owc9/SGrDzQJlk5THOmfr5BLSubdcPRDmL+gKIzZp6qMfzXQo06/JtOkScdwnDihS44YWTXpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: dTPL1hsBSs6sTh4i8Da6jvwZhN7WF3M1
X-Proofpoint-GUID: dTPL1hsBSs6sTh4i8Da6jvwZhN7WF3M1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 8e7db2a154cf8889319a4d6e5f987998ed21fa1b

This patch hoists the later half of xfs_attr_node_addname into
the calling function.  We do this because it is this area that
will need the most state management, and we want to keep such
code in the same scope as much as possible

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c | 161 ++++++++++++++++++++++++++----------------------------
 1 file changed, 78 insertions(+), 83 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 88e0502..ec93d665 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -52,6 +52,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
+STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
 STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
@@ -270,8 +271,8 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_da_state     *state;
-	int			error;
+	struct xfs_da_state     *state = NULL;
+	int			error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -322,8 +323,79 @@ xfs_attr_set_args(
 			return error;
 		error = xfs_attr_node_addname(args, state);
 	} while (error == -EAGAIN);
+	if (error)
+		return error;
+
+	/*
+	 * Commit the leaf addition or btree split and start the next
+	 * trans in the chain.
+	 */
+	error = xfs_trans_roll_inode(&args->trans, dp);
+	if (error)
+		goto out;
+
+	/*
+	 * If there was an out-of-line value, allocate the blocks we
+	 * identified for its storage and copy the value.  This is done
+	 * after we create the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
+	 */
+	if (args->rmtblkno > 0) {
+		error = xfs_attr_rmtval_set(args);
+		if (error)
+			return error;
+	}
+
+	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+		/*
+		 * Added a "remote" value, just clear the incomplete flag.
+		 */
+		if (args->rmtblkno > 0)
+			error = xfs_attr3_leaf_clearflag(args);
+		goto out;
+	}
+
+	/*
+	 * If this is an atomic rename operation, we must "flip" the incomplete
+	 * flags on the "new" and "old" attribute/value pairs so that one
+	 * disappears and one appears atomically.  Then we must remove the "old"
+	 * attribute/value pair.
+	 *
+	 * In a separate transaction, set the incomplete flag on the "old" attr
+	 * and clear the incomplete flag on the "new" attr.
+	 */
+	error = xfs_attr3_leaf_flipflags(args);
+	if (error)
+		goto out;
+	/*
+	 * Commit the flag value change and start the next trans in series
+	 */
+	error = xfs_trans_roll_inode(&args->trans, args->dp);
+	if (error)
+		goto out;
 
+	/*
+	 * Dismantle the "old" attribute/value pair by removing a "remote" value
+	 * (if it exists).
+	 */
+	xfs_attr_restore_rmt_blk(args);
+
+	if (args->rmtblkno) {
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
+
+		error = xfs_attr_rmtval_remove(args);
+		if (error)
+			return error;
+	}
+
+	error = xfs_attr_node_addname_clear_incomplete(args);
+out:
+	if (state)
+		xfs_da_state_free(state);
 	return error;
+
 }
 
 /*
@@ -970,7 +1042,7 @@ xfs_attr_node_addname(
 {
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
-	int			retval, error;
+	int			error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -978,8 +1050,8 @@ xfs_attr_node_addname(
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	retval = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (retval == -ENOSPC) {
+	error = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (error == -ENOSPC) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
@@ -1025,85 +1097,8 @@ xfs_attr_node_addname(
 		xfs_da3_fixhashpath(state, &state->path);
 	}
 
-	/*
-	 * Kill the state structure, we're done with it and need to
-	 * allow the buffers to come back later.
-	 */
-	xfs_da_state_free(state);
-	state = NULL;
-
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
-
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-		retval = error;
-		goto out;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		goto out;
-	/*
-	 * Commit the flag value change and start the next trans in series
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		goto out;
-
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
-
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
-
-	error = xfs_attr_node_addname_clear_incomplete(args);
 out:
-	if (state)
-		xfs_da_state_free(state);
-	if (error)
-		return error;
-	return retval;
+	return error;
 }
 
 
-- 
2.7.4

