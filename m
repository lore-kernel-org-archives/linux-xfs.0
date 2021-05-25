Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F53C47086
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA31961279
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhEYT5H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34194 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhEYT5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJo0uN185068
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=QftG14Ie9+hiiNeRtV7kTMEXLO4BuF0eUx9rNA/vsjY=;
 b=xMaw6ERO4y+EWipHxT0WotBtU0F2eF7Y2sEaBU0QJQ7zLF6wnBMXFrsCt68SXWCVAg1L
 wl+DC8th3IQiNDHijwwz3NcYxBUmCpNdWC+kq6dSZcr790GbIYJuLymNKhrauPYNzhks
 p8QiXLFUHeq4b4cfovGpI+PdKQGmaLZEDeGXNnXCH5kgdW7XW1ZNcFZiztGGhAj5eZ2M
 wgEOs8c6GcF23rwQmmRbww5lGzVRuGfqaB1wfdWH3I82Dkx9IS6MCM18ZDlIcR7FQpwn
 QGHSKwj3RBZtfc9sP2s6kfqPNYqJa5Csw4z7RI8tmnuSTemS98q2xDNpDReLQcV925gr Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ptkp736n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJoDie188864
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 38qbqsjk0g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKRbH4MTPdZq1iXSjpgUSkdGi6FO18ocrYLK8CGbKxtkUsWRVLrDvvKG8+rFiLnwx2xTCepXhCQ7tS87sRgVaVj2dF+vhSFggexRugEGHZnorC3VOop3+HtBeJT3ZX3byqKhrFtxPgRA+cF1Xp/MMn/dnZaAjqfKqlIkJ1CLsoAhjnJqZzR+LSqYyWYyGkLw6aNmh71z59m3NB7zD3ZAdY3kzPFNW47Srp+PfTU/fxq4sP+TXmkCF3GwJTdAm0sW4SPfbzwkfTX6bVkmVLX0NV4P7g1vHY87kYh7TFzXXhzC8L3YAxBBDJy3JRJJrmWQ7cmkMPGozaa2m5JUqBHwoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QftG14Ie9+hiiNeRtV7kTMEXLO4BuF0eUx9rNA/vsjY=;
 b=H+HKaQk95i0qMw4VeDJBYitMMM5afvImMw8owcY8pIIXYNIzyWqXJ/Er+NzygFQGLNRm/G2iYNqHJ0F6LJvuUkPj3muhuLndOVbZBiq40XtoB/h2D1QFnmvMKWqr42Zk7nHUp84ZIE07TbZjm+XC0GU8qMapNNk3tNRrKx3hc/NTLN5QW6Icp8N/fSSp+ObRMpJEqwrCciv+WJ8BqbVaVrZVWJrCOwUswrLSUFgwVAvsOMM/22X6r7iIgxvn4Xw2BYhg62SmhnGzsHamVot4KGyBltDcYZncbhcwqI6eCipAIZ0RtNKWeEJ1W6dEEB5iLdMnCgNfIQrdhXUF3eshDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QftG14Ie9+hiiNeRtV7kTMEXLO4BuF0eUx9rNA/vsjY=;
 b=RWBnhHO4PugLG9NQT1w5yYgefX99/IOCW2Y9EU4Tmc7yZRPC3mysdv9ED4CfmpuTJ+fGKbFLSOBovHPta2th9uq6+6b7TOLPpPNKRXGgnD2ZY6JcBFO9rzNu021S4u2r29XvLhlc38QsiD6179A0vmqa0H9L6rBgrEWc8vp6IJk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4544.namprd10.prod.outlook.com (2603:10b6:a03:2ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Tue, 25 May
 2021 19:55:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:28 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 07/14] xfs: Hoist xfs_attr_leaf_addname
Date:   Tue, 25 May 2021 12:54:57 -0700
Message-Id: <20210525195504.7332-8-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 431d06b8-c786-4384-5ba6-08d91fb70bcb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4544:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB454492D7851A61DAD475902395259@SJ0PR10MB4544.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d7VhrIE5MU29JUUH+YjYWHcW/dVRPWUP5QfjaJDDr00mHrR7xBsn1rAlR/Nq6d0J14Kxed+aVQSTJiShOhLF8M9FAVFVPX8rmCPiQkL6QC5EPvaMBQMGyYejvs0an89HEl/pDItcWTW1iY0sr5GaugqeS5blr15ryj4trHKQ4ivraisUmil2j49lMz6iIrZ+eTSh1cTeRzJR8OQNr6mHlF6Tc+5BAjDDFUbEQXjYXcQQsJmBLqcxkFAw2Z7mrfG8FF0YnFMhG42Z9NljP/kqR/HzMCLysOEis+DvFTs/NaCJDSZFYEi+Sdkz1FcuTmdoaLOXwlpmX8FeJQT6S8R+jpzZahIxS9FU3iugxivnQ/5mWX9IzoF08l5PoRmMJB32YDAwgiUoBhWUX3pGLTEKSeRlkdvxq02T03BDs3U7JmBhfEy7MQxCkQUR+ePucm0OOmmQJ6akeKAC5PmUu6KkUPXK7VflxqmUo4AAxAT6dqsWHX7zdQzvGkXP45FWWw7pTOnMAshSuQYBJ1DPMOkByqWcKaLEaexHzVHeXffZ1fJWPiLfvgyPIolaTUQZ7iyGCE5NLq6ruudnAvpgsbPJ82dqlwGwwH/F7S/RReQV05lepMiAgj59NtIm3MaHoXhW03kGCP/UlUKSUNGv/nSTkSAHWB7ohcV0/8WgdY/3qoQ4XNXZvHF9nhvH/L+Rcy8t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(346002)(396003)(136003)(376002)(2616005)(52116002)(5660300002)(956004)(478600001)(186003)(83380400001)(6486002)(66476007)(36756003)(2906002)(44832011)(38350700002)(66556008)(66946007)(26005)(6916009)(86362001)(38100700002)(1076003)(16526019)(6506007)(6666004)(8676002)(8936002)(6512007)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Lz0BFCpfBwF9GRDnABPeRV9fvLoLO7dvir+yrau/A5dIvP8tHWbkSRFKyn0D?=
 =?us-ascii?Q?G2UEa3Crp0BM+eTRcjTlSzGbnn0BkZr8GjouZOtibVv3UOSrnwg30ZT6VHSs?=
 =?us-ascii?Q?ZBD7pK//Z3+SpYre0ALQha1VhyG5IAJZFdWkDBVWCXNzLM6fdiwUxNH6Uc3K?=
 =?us-ascii?Q?ETs9nWPuS6yofoPHzjoAcMwePu4RWy1jwtreCA+Uv4zL9VHgLShud2/TetAt?=
 =?us-ascii?Q?9bM5kw07i1NzRx3tbuFQi5ZeXpHI2pBC5gGealefcyO0VpIUeLXuOTBMlbyl?=
 =?us-ascii?Q?Hdhin3/IVpWKRjrso1dlpuOSM1bJhgrsrE/SOSMDAbUdE5LYstRtn2U1/nnT?=
 =?us-ascii?Q?cYPigaIhuZdFpexkCbBgI3OzOclrTyNF7inyjR9KPOHXQ2n64MVGB2klW/ca?=
 =?us-ascii?Q?adQngzIyNUKH6HbHYpC2v+da/AOOJWDkA25lTR7po+GFtQgz0BDLVqYSQbxk?=
 =?us-ascii?Q?6RxKh35ynGk8eSPROJXGh2wOvclOmEf9tm/voFDIqRF/QvnI20Ur1UgroOTR?=
 =?us-ascii?Q?Ssavegjfgwa6m+5wrb5shxaydi6P4vik4uWLlhiKdAJaO58+TKxpv6wyG/jV?=
 =?us-ascii?Q?VJQiTzHDqAd9CkKeewh14yYjzX6p2i835i42rTwZNqgw+OQIWXIr3LF2PIP3?=
 =?us-ascii?Q?x2XSHdc5kJ4WED3+KkzaLaSbMyJexZQ+1MsLWRzZ/Guv91GvzP9L982GsMDW?=
 =?us-ascii?Q?dnyVTzCoFxU8w4lF2xSPQjC4N2RlvvCi1WW6DOXTtB3otTqgGMOuWRNhufNG?=
 =?us-ascii?Q?rfKYcRYhxQwHJtik7mT0ahpPW9WgvlT1UK/49ZezE0R3nUjgMBaYmE5GYsbJ?=
 =?us-ascii?Q?UnHAZZdh+JSOyxVMG/VG4+QXnU2m/coZhzuMTxSfIq7xfr1LwlYUPug3zn1C?=
 =?us-ascii?Q?OKKA1lJrwsT5qW/Jx9GxHSKQWLvkj25khN/YVa4u31cF2U999FneeRxzZBkb?=
 =?us-ascii?Q?SxpimgJc5Va7G3dADdUQVuL4H3HHe97gv1DqRm21W3KxqUI9JkVPR8yskOxn?=
 =?us-ascii?Q?m/8p1DVpfuUIn+SHOnq0C1zmAiUVRH0BvoH3V9rfIkNj5PlTON5xXs/HSHfK?=
 =?us-ascii?Q?N9JvFhp27n2sL6ysrKx17SeJRJ5hQrfhdpJ61N19XXzSUFm9ISsVI9Vcvrqp?=
 =?us-ascii?Q?NRhJ5z4cyB/f0zvaPyyaQsLG/DFbf1mq4HQ0wVf4IzjaZ770RyQIyDG0KQiI?=
 =?us-ascii?Q?50CSolg2f0lZ7CY0d/u1TRlHDO3YQpTPaXeuKrn8UgpMDRzNtXznxgE3EwUv?=
 =?us-ascii?Q?eXw16ieTheFvFF4WD5I107wwRsBMXOGVVi5IQ1ViKzsSgSJImJeYWTgnu2uI?=
 =?us-ascii?Q?qlqIaclrgAGjjpJYKtHKBtyI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 431d06b8-c786-4384-5ba6-08d91fb70bcb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:28.8417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNhJwXCrLkQZVOc0la0+O1XHiijJiuQ2NwyO05OBBOAOG1sFQoKVBgi8gDU/MUTr7kq7X35iWUcB1LzyyraO1hXGuuWIysFnCpjocLiGm/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4544
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-GUID: 2ndw9-IWxoexWlnZ3CZ3ZahWvK7_5bBg
X-Proofpoint-ORIG-GUID: 2ndw9-IWxoexWlnZ3CZ3ZahWvK7_5bBg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_leaf_addname into the calling function.  The
goal being to get all the code that will require state management into
the same scope. This isn't particularly aesthetic right away, but it is a
preliminary step to merging in the state machine code.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
 fs/xfs/xfs_trace.h       |   1 -
 2 files changed, 96 insertions(+), 114 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b35c742..4bbf34c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -44,9 +44,9 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  * Internal routines when attribute list is one block.
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -291,8 +291,9 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp = NULL;
 	struct xfs_da_state     *state = NULL;
-	int			error = 0;
+	int			forkoff, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -307,10 +308,101 @@ xfs_attr_set_args(
 	}
 
 	if (xfs_attr_is_leaf(dp)) {
-		error = xfs_attr_leaf_addname(args);
-		if (error != -ENOSPC)
+		error = xfs_attr_leaf_try_add(args, bp);
+		if (error == -ENOSPC)
+			goto node;
+		else if (error)
+			return error;
+
+		/*
+		 * Commit the transaction that added the attr name so that
+		 * later routines can manage their own transactions.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			return error;
+
+		/*
+		 * If there was an out-of-line value, allocate the blocks we
+		 * identified for its storage and copy the value.  This is done
+		 * after we create the attribute so that we don't overflow the
+		 * maximum size of a transaction and/or hit a deadlock.
+		 */
+		if (args->rmtblkno > 0) {
+			error = xfs_attr_rmtval_set(args);
+			if (error)
+				return error;
+		}
+
+		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			/*
+			 * Added a "remote" value, just clear the incomplete
+			 *flag.
+			 */
+			if (args->rmtblkno > 0)
+				error = xfs_attr3_leaf_clearflag(args);
+
+			return error;
+		}
+
+		/*
+		 * If this is an atomic rename operation, we must "flip" the
+		 * incomplete flags on the "new" and "old" attribute/value pairs
+		 * so that one disappears and one appears atomically.  Then we
+		 * must remove the "old" attribute/value pair.
+		 *
+		 * In a separate transaction, set the incomplete flag on the
+		 * "old" attr and clear the incomplete flag on the "new" attr.
+		 */
+
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			return error;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			return error;
+
+		/*
+		 * Dismantle the "old" attribute/value pair by removing a
+		 * "remote" value (if it exists).
+		 */
+		xfs_attr_restore_rmt_blk(args);
+
+		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_invalidate(args);
+			if (error)
+				return error;
+
+			error = xfs_attr_rmtval_remove(args);
+			if (error)
+				return error;
+		}
+
+		/*
+		 * Read in the block containing the "old" attr, then remove the
+		 * "old" attr from that block (neat, huh!)
+		 */
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+					   &bp);
+		if (error)
 			return error;
 
+		xfs_attr3_leaf_remove(bp, args);
+
+		/*
+		 * If the result is small enough, shrink it all into the inode.
+		 */
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff)
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+			/* bp is gone due to xfs_da_shrink_inode */
+
+		return error;
+node:
 		/*
 		 * Promote the attribute list to the Btree format.
 		 */
@@ -737,115 +829,6 @@ xfs_attr_leaf_try_add(
 	return retval;
 }
 
-
-/*
- * Add a name to the leaf attribute list structure
- *
- * This leaf block cannot have a "remote" value, we only call this routine
- * if bmap_one_block() says there is only one block (ie: no remote blks).
- */
-STATIC int
-xfs_attr_leaf_addname(
-	struct xfs_da_args	*args)
-{
-	int			error, forkoff;
-	struct xfs_buf		*bp = NULL;
-	struct xfs_inode	*dp = args->dp;
-
-	trace_xfs_attr_leaf_addname(args);
-
-	error = xfs_attr_leaf_try_add(args, bp);
-	if (error)
-		return error;
-
-	/*
-	 * Commit the transaction that added the attr name so that
-	 * later routines can manage their own transactions.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		return error;
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
-
-		return error;
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
-
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		return error;
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		return error;
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
-	/*
-	 * Read in the block containing the "old" attr, then remove the "old"
-	 * attr from that block (neat, huh!)
-	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-				   &bp);
-	if (error)
-		return error;
-
-	xfs_attr3_leaf_remove(bp, args);
-
-	/*
-	 * If the result is small enough, shrink it all into the inode.
-	 */
-	forkoff = xfs_attr_shortform_allfit(bp, dp);
-	if (forkoff)
-		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-		/* bp is gone due to xfs_da_shrink_inode */
-
-	return error;
-}
-
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 808ae33..3c1c830 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1914,7 +1914,6 @@ DEFINE_ATTR_EVENT(xfs_attr_leaf_add);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add_old);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add_new);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_add_work);
-DEFINE_ATTR_EVENT(xfs_attr_leaf_addname);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_create);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_compact);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_get);
-- 
2.7.4

