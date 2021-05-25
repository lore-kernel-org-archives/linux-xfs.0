Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F98CC4707F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6708461358
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhEYT5H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34190 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbhEYT5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnY9c184912
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Rl5hjkbSu6ah9woombt7OArvqyhdXA1UKTGp09QgR08=;
 b=uvKeNyAHcSWL/HTRzJoiifHzjssx6W4KGYyHYilZkACAQEUae5d3PVQrQdRZk5foLJ7+
 us0TCc7Wmxg3bTSE3LP5uXuwrJjI3RXPWfLz07hkobXoZJPlKpiaqnC+kCkYHLC3Ujtw
 7cdjMSc7Yob6BVohAVFQgWZBlzu4DXZL4g7j3jLek51GYt3Yjmj6awOJ0FZQ8t7od0S1
 E7AVBRj5HjLQNUmchKyBHQ5D5BE1TVL7iu89MZZ0Q3BIP0vWCRinITpcqxZOs6eZ8oKt
 OOShDwTQnl6hnuqP/u/s/vTdCYq5kM6+NGmqmPql2Rjsxmut0AKn5x73MgtESE+TYYGK YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ptkp736m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJoDid188864
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 38qbqsjk0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVyEyYbnRgX7nJPcwEA6evdx58COCAAMblxaJubuXxgY/j/b1WUe240bwPK3O9RzzPnPZzZI9TJdDY4l1jWvQUg720768a/kDFjnETrC7CtN8SCkXadxzhzj30FIaYo4qL1KlpUF78CwbH3jVYQAdAJHONsDkrGPuT34pWxCUtuZ1CnzgvW7+3RL6Bh8KuA+LycSPtJ8ve3yTEnUdQaXi2I/H/s5mVBKKeltVFvePSTKFRuAJQv3vBM66bFz0N6knJ+zTWg0RYM/H6DlbGnO+saFvLMKVz4x0VYfMNOOIoA2B2CjdVozdCigKzXOuvtB0tIhT0MZsC2q0JYrfg8iOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rl5hjkbSu6ah9woombt7OArvqyhdXA1UKTGp09QgR08=;
 b=VHkgLVk480nh20jV6uJbhRrMm0nt8pOfpJh4yBJ9CHBjDQTGsrK3Tomkxety9Kd+fBI3Ben38LKOPFXK/fIEzXBzwhOprAgU6cZnzjxlJHuwfrgK0PZo7gJbtWqNAW8arRRYp8WEGaGLZfcI+YEWCNUlyDs/9hIN0v+SXNVafiKTaBp2zuZ6fVmd8eSLCd6nuMqOOntQ/M1KzJico77B4PP9RmrnSoW80qG/olHr7u822D05c0ghS+t+wNPQIVqCENGeU5Lmil9eDA7E6nVlbtPTpqcl4yK/2UEKtDN/Pw0+uhxdvNifKhhtIWjv9YjVyW4cM7n82P0fHVS1uPniIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rl5hjkbSu6ah9woombt7OArvqyhdXA1UKTGp09QgR08=;
 b=d4Fk75VyHMLnUpgm4spjTFl31+u0eezHkBHoYmkcxQmyev4Mu12caGanJ+ThoP4sCgWOK4GP1egYUVr7a4ELYB6YIiVAnDVbsSTpA+Pgq0FrLAgPsC1tFCZy/yM3AEHk+WWdkuN01XUBRqC04doIdtfv/Xf+0KOSTEpE1YIXmqw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4544.namprd10.prod.outlook.com (2603:10b6:a03:2ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 19:55:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:29 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 08/14] xfs: Hoist node transaction handling
Date:   Tue, 25 May 2021 12:54:58 -0700
Message-Id: <20210525195504.7332-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210525195504.7332-1-allison.henderson@oracle.com>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e70f6b8e-85f5-4f0e-406e-08d91fb70bfe
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4544:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45440DD6636A8CCEBAE399FB95259@SJ0PR10MB4544.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LHRz435O34LimeFWtHZ6D+YQpUKmrnR2su1IJbD3Lze5HTnkB+dLt6O/2LYgdwCC+TWHizyw+542e97Us6qIYk0A7PzSvDOrJyHo4dB+tzZ3UIo7bTB1nOg1KaqrbSFpxpFi8WmwYk4D3poIfRsm/DszRoBmxXYLc+Jm/wppnEoacK8talYzm8cAC/7sv8uLiFBryF6rqUhqAL9X2l4feaQuEXnTF/cLEnlt1LpFeOKhFTlhGNGLbL/oXEhWdyHxdR0YZ8kJETIOKEUkVCSbk8HPM8FxGFvqppMXMhfzO41ORaiPPt4jCn+dHjYHYXHIhvqSjgVxUruTlDrW5aUoOJje5BTTwRJhkRI4X1ShvxXDAByr/Xuo7SeDm435VjQwrwwz69bZqLYUym/1zvWh+rcKxPuThSZnhSXD8rwumzpix0PwqIeBRRLrBcJ55QskWzbfoKxQI2xzeHfyE9tU7xlLXvKV20CZi2rjKQq3rzUXcUtNNs60FqZG/84cEGFE7Pfe2V5vbH+hfZyBXiAnGcKzrRhJbv3Pzm+VxTmXuOp+QM9/X9K8tF8nSYlzY/fso6fjcLJ12kfjLZWzKf5ZKZH7ea4fwagGlJGKxYdNYnOZ79JjbDKtwcZwSjjCeDYtRnMeaa6jYosDm4jJ60tPZltcqlsIMWHFZ/B+e7QXAJVpBPS4HkRVwA2thQAPLChp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(346002)(396003)(136003)(376002)(2616005)(52116002)(5660300002)(956004)(478600001)(186003)(83380400001)(6486002)(66476007)(36756003)(2906002)(44832011)(38350700002)(66556008)(66946007)(26005)(6916009)(86362001)(38100700002)(1076003)(16526019)(6506007)(6666004)(8676002)(8936002)(6512007)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OljN4yqrzT7/Aw2Mdp3eIgZ8YLTCLLRCm+tczMY2gH6AVci2LxayllOELQ6K?=
 =?us-ascii?Q?NYCn8ruAYphdSmkWkGKry0MXLt1DVYIR4HQuSgyg/ygg3cT7L5kMAtXNvLu3?=
 =?us-ascii?Q?Ozq5BzIScAgKlgzI+pZWaskhJH5HqRsf+oucCOJxg9kum/Dz46DD1j7gK26R?=
 =?us-ascii?Q?a9txIePwnp4bJVE4CrnB1fhMIpJgSrfe5lI30zVYqFvS9kUxPnDnthEDgTqe?=
 =?us-ascii?Q?xA2HOwAtJeAuV/mstqWUfzTH4B0cGA5jJaMDWgrbGGKrsmOao15bBRA9wINB?=
 =?us-ascii?Q?GlZYWMpp3TflAXw93bW0FEMATNBf+uQEFVJ0GvuLN5STloo1YOAIfjxOQ/rm?=
 =?us-ascii?Q?z4porVqogBgCFLVsSnvX0l1LDcqY3zm2H2Re8Wpn9FKp5UPJNm3/cQS70D7X?=
 =?us-ascii?Q?nLyaeetYSKybc+fa5zhaxVI3/OqaDp0+LT6bPG3jPcbojoVq9Azx/s/GrZIA?=
 =?us-ascii?Q?j81IBDbCIoYB4hYu02Glh9oB2QdTP5oblHkwpts1H25M0HLmKz5WbVQqrWJv?=
 =?us-ascii?Q?zMOyzmPY/lWUn6s8WRh5LUolFlCUIFCyKZevkRbKPR9+bcGzxwB5jwMnRgfX?=
 =?us-ascii?Q?xZ9PM9HZKsBDcoWk92r6u93TpjSreIvzf6r2MBfIw+evrPlUL4VBuUTz2114?=
 =?us-ascii?Q?jKyLXzHcpNeJdfziV/31YIQ/QfZsNtk2sgvWIpICKCaKSUjJ4KD4e6FAN1Aa?=
 =?us-ascii?Q?ZiDhIRg0W/tjg8dwY6paxqy2+73hjsz6lH7iqSkSVbyeTyeqRqBeygH79TKd?=
 =?us-ascii?Q?DtuTEimfAZTIYTYf9EuQzJjYzQXJ8QmZRrHR8Mh+Uj+hHlZw6UV/nnWilQmn?=
 =?us-ascii?Q?cHImXAveU3yPEwB8mVsmiPPLBaTQbQ4KWOiKq6ROpkMvYCiThULNwyKXZj/X?=
 =?us-ascii?Q?BbTghhPSwOXa/ZvBDk5Ly2fj86pcquatNZwWvTHPKyBbw+ZoAYcxhuol7bEx?=
 =?us-ascii?Q?bCXBHgc5hAhdhAjK63oK/fZUcMotIZzJIT7HqVVfGE+QoBBgUu+xLejBmwAD?=
 =?us-ascii?Q?4laoLbQzEVmR9LQRjVY8XxUPn9ZRBEhOy3toXHx1+k43ttjXCldQTYgRvvaK?=
 =?us-ascii?Q?0q2YFkOokpaYie4XPVlLgs7icyAKm4hg1nYksFbJ+B6H3MTSGkBOts3P9z5x?=
 =?us-ascii?Q?hM1xfPyMO3Jo+pyEUtk36nXKevFAGB7nSq4JwA7t2mMKW7Pq3vK7pjTNgUVi?=
 =?us-ascii?Q?Iawdgw4ByE4ENlsZcl4aFZ+WQrsD2DphX/dotInvs/HN9JVsae5Vjmc3Bdq3?=
 =?us-ascii?Q?Q2wJJzCyCH4GL14Cr8Uw3dp0a+MWRNhDPkY2fz+Zsl9QEcfb/2WB8Uum+5DV?=
 =?us-ascii?Q?CWBIYcEGzoUTrPdEpYFdUWmg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e70f6b8e-85f5-4f0e-406e-08d91fb70bfe
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:29.1837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2SKhlZQMaiP+2LmwO1IU5o6DePkSIJ7JeDx/K1Vx1wvyK9AxTK58wGzbziH2bTQu+gNAzEybRJjTxwayDUzYhqp0yHkp881jtzb79sYogo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4544
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-GUID: fkZp8ItkS6PXw6s3KFYe4PSzfXCjaCA8
X-Proofpoint-ORIG-GUID: fkZp8ItkS6PXw6s3KFYe4PSzfXCjaCA8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250121
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

