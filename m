Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69450C4360C
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36C4C61363
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhELRGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 13:06:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239709AbhELQPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 12:15:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CGATeI028640
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=axtKP2TLLLFxoRvmO7V+X/k/eb6Omt75vxkwITHZwjE=;
 b=D2DjjQqyOt+lv3Ufod85wndEUZBT/sORPrkUWECvP8FYt5DrolI7zNzAbBAuFMYTqYRR
 BXVFF6T1dpm+m22gB0A59kttFsgKmucTrWocKqaY1ROUEEFlZW5iQBouk66FAig3P4JV
 3vT1rNJsriKQ+vHtoTLQ3kYCC/QKiE1uO7SwydpterIKPFVqolljZMb/2nYUIrYwfD38
 9j7DzcKfXr3SAS880XxzQZGx6edvzrboCG+d0gC4Bu9xrKXTsQKYjGsiOX+sjyFLheQV
 p62AhxQZjMU0iSjmKWXyKo1AaceDofkngZjjidN0td2nLe7eS0DUqma4AkJFz3d6zHB3 kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38e285hu9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CGApnm142059
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 38djfc4w78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGUPD+x4Rq7zks4JM0aGjD2+PN9dmaTCcVtHkEJsHWSvqVRNIaeZ8YFQTKEVJ2DuRdEjTOsXTNYxZhDrR1s7y5+/Qnwj0A+eQZaZyDJKRg3v2nuVOY+VXL5SKtZmBeS806LG5aYojrHMyWsqQHt5dR2b+8ZpqDEuaLJ6UdCuiJeW8QJTa9dhEPb8Ul4q/JKppSKY4Xkx3ZjOwxuf4xlznX6eS4qCNrIeNyi4lvodmkiDmOXunW/jDR/xCY3JkzRSBOKtaPdK4fjwEt/oey5RhOi+UYRVnqqfMI4FOb/2EjHuWzNZTz/vdsQFysedlCoJqileoE0E6YXx40GeHoH6Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axtKP2TLLLFxoRvmO7V+X/k/eb6Omt75vxkwITHZwjE=;
 b=TlQIyEg1EaaXyu9lqL2pFG7CzW2MgGEfXoi8QvBx3FhEyTKJcwj1KWcu7FyRnXFp0GNIEdTkiggh7gh4IspSSHxDOP7m9sGCe90+6/Tc0MaEwIO8VyHCIDlZLPb5zbxhvAJleGJTz8X6z/pX7V6IV0uFUWtP0NBoWlY74FOHNWmSsFyCtxHsIhUNHFoj6qNwq+bk8nhTEZiaMG9VqPpkIYPYPf+WoCiAEuPHFhsvn5f64c7FotgUeqnpdwo7QlEUEmKdTs4b6JFl2wXSMdpBai5HLW4qsmciM7vbO1avrfPbYhfh4bq+7/rGcTbEsszq1hfUELZ+uHzgap9Mj+ea5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axtKP2TLLLFxoRvmO7V+X/k/eb6Omt75vxkwITHZwjE=;
 b=PJj7YXumB/HBMGtpgi+zvYXuCyrtJpu3tRFjJnSafDm6ugMCWe2DvF6GGtQjSo7aoGjg6ZrruqrFO3I6u3OgIhIsc3BrRMDKfhBARCfiaZAalN4LIz/XsXfTOUiSohW+KmI+G8RgEvxBSj8bNepMoK2LTerpQusqcQsWSEwl7qc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3336.namprd10.prod.outlook.com (2603:10b6:a03:158::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.29; Wed, 12 May
 2021 16:14:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.027; Wed, 12 May 2021
 16:14:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v18 06/11] xfs: Add helper xfs_attr_node_addname_find_attr
Date:   Wed, 12 May 2021 09:14:03 -0700
Message-Id: <20210512161408.5516-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512161408.5516-1-allison.henderson@oracle.com>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR05CA0200.namprd05.prod.outlook.com
 (2603:10b6:a03:330::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:14:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66f3928f-4624-43b8-41b2-08d915610245
X-MS-TrafficTypeDiagnostic: BYAPR10MB3336:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3336B1339F04E62820FAAA5195529@BYAPR10MB3336.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g9lKKwW7mODFodfl046hRQlwNomg2G9/FjwN3HWcLn79JT7TmcPzPQj85gxF5yuQdaJUVVfatDER/S+emRoiPvaC2ZtL0AvGzmz9M+nTbBzIfLCjcZ1ntZLfE41Ff8OlxK7F/IdKkPOR0wzhtBCk4D6oc+A2l42B23s+VB2ZWiwpYkC9m+glzYq0LymROYCovDppm8ENRx/sxxIBWz9jCbA6f6HUrCMcqI0GK2bP7OTbGK+A/UG/03TgZQYlH44kgHfMZaXNTZCfYHcvC2fIBZZ5Wt7Fp30QTbtlC1wa+MLZUH+uvs+dbbIQwVWBW85Lc/ECTH4ShjVcN7fcBQwiyWZQttiaE8Peq1Lre8jLe7Vms5KovrwNTcNOeL6wkDub5l4OWVTRsgU2H9ULWTANKKHa/vBeKDZH8fsA1r/Z0F3yMu3HcaZ1KFgpfe3JsSiFfiiuF3p4bU1TqwjZcNeRUaVekvc21I3/GCvMScY71Cswk5AzK/FsSwQqTYrjdKHfRqCe8csY4bYlSouqyi6dlzKe4x7iyw9y94udcwuE6394Q6eh3k0VH51Vxb+WSOgXYbrmBJ1bcYj2W3mEiBGEVHsBgS26XImORV1KB+SaOnjtGUbLsi+JUOV/nYvCEwnNXzUCVkTegrN84DlALmbmgN5zaAuB9IVrWuqFP+4OjEA+Y4YXTINYZK1CbhJQwDhu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(396003)(366004)(2616005)(66946007)(1076003)(66476007)(6916009)(16526019)(26005)(6512007)(956004)(36756003)(83380400001)(38350700002)(6486002)(478600001)(8676002)(38100700002)(2906002)(6666004)(316002)(186003)(8936002)(44832011)(6506007)(86362001)(5660300002)(66556008)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ItnX09LgnUFQj09B5GO0P6Icmdwg9eVMTwyasmNo1i5qmgbuojpRdWyJJUzk?=
 =?us-ascii?Q?0dCK9TnuiagXDkUSokf9MFjmROMkYi9fVX+0zrzSRuhR5an6dHieBG/EQ+1x?=
 =?us-ascii?Q?wKAISxiA21TsD+o/4lafmir7rhu8cVhgF9BSVvJJ/z5I9QwODO0Ji34uzKvF?=
 =?us-ascii?Q?aYPLIpgQsQyFFmo8zIRDSdmXzK+I5rCYVUD1zRfoOXWJOL3CmodeUjYmkmh0?=
 =?us-ascii?Q?6nmijqUtL+Z9DZu/RgTGt4XgHiHCDz62zQ39PcL1vbGFHtA8HggfsrKO2+KB?=
 =?us-ascii?Q?g8+mzvewyOC96bLIoQUMQUbylkqSLOFD4hL5XIzDxXDPSg/Ch+gu6BAspJom?=
 =?us-ascii?Q?2fk1k0iM207xeKfVDT4PYUrLzqM0AAcpUG3MZMcGezxbvDoviY0L6uAcV2Fi?=
 =?us-ascii?Q?PH6QBN/6Fom2uQSCyG96z74AlKtI34vIz9+AJ6JqKqFWluXDuPyVPsfnWalB?=
 =?us-ascii?Q?yNHtQQN1/+cKFuHINd2m6YlqKfa1b3/7bjvFt9C777UZJt1bhl1DS9hkrdBm?=
 =?us-ascii?Q?BseZLEHiELF8rbxv6QXv/I+e1lCRzl+j8sqXPresms2Px1nbxp7PzZ+rElr8?=
 =?us-ascii?Q?xWQTGDVfPRVhOwzGiluOs8OZGjjtzw08FqexrcAIXJpsyxaJU9EJxFAkXjxZ?=
 =?us-ascii?Q?0BJiQG0KPALt8Tbayd3SMx2dNN1HdBq2hOvLTf3FhrgzUQFLGuFnYoegadLg?=
 =?us-ascii?Q?GP5mZfvIde5MbJNS86nj/389MRzXbUvRZxIaohHrWWOtn8gcSB4ko4O+Jo9a?=
 =?us-ascii?Q?+57c6+GzAEMGeKZnIk//blCTFgZF9R15yT1s5Quk1bH50ysgrkfi72w1dUBc?=
 =?us-ascii?Q?+ua0aaT/VaK5S4UBsH9CC6BaWDjT/D6He/Ce4a/vFM7XgJRAUZ69SqcZLj17?=
 =?us-ascii?Q?dY9XjvV7NA3/Akd4kaUkifTh+Jb3s4ZI1L4B4i4vsshYkNrRjy9M/ETJqMJH?=
 =?us-ascii?Q?NMYKswZZBKaEJUMYUfaUea2WMOSTPzbsR/TLOeT/NJx0zC6noY8Iiv9Q9FP0?=
 =?us-ascii?Q?e00JDOJ4PYWLfzgKM7QtPjfZeUeywrqzftRra4QLyC6VewuWiJh+QtQq0JBa?=
 =?us-ascii?Q?W+nwK28oMrupBOFvCDHhJZ2ski226cqqhwL8uWBlMvj/22y8jByP+2j6uEUn?=
 =?us-ascii?Q?zmHgvOaC8v4M+IJh4Vsa/jX8p6XETa8z9erACg9rJux8jGcClBUCufdKMfoL?=
 =?us-ascii?Q?uYJVfyUZukVY1U2ZQMuYti7rC5xVTFi7NYbYY5t2f33IAZtO3lNU0cB651LE?=
 =?us-ascii?Q?Qw5PxH6Y4c4YlLNwThAevzn54iSV3bBz1ls33JFgxAA2PBw2ZrPDbKLWrM93?=
 =?us-ascii?Q?gsR0Qwdi1u/2heXvTAinsCzU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f3928f-4624-43b8-41b2-08d915610245
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:14:24.5392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFloea9TzfDr55ZcyqbZbQkNba9Lqxp7f9SHeOvlAbkvxT3MQSLd6XJp/yERUUXljVj+5D5kISY0ot8BUH51BReEaf5xOlvrrV/J2OZjZQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3336
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
X-Proofpoint-GUID: _tJsFfxHE-hLenqGiZRqpvIyps9922wA
X-Proofpoint-ORIG-GUID: _tJsFfxHE-hLenqGiZRqpvIyps9922wA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch separates the first half of xfs_attr_node_addname into a
helper function xfs_attr_node_addname_find_attr.  It also replaces the
restart goto with an EAGAIN return code driven by a loop in the calling
function.  This looks odd now, but will clean up nicly once we introduce
the state machine.  It will also enable hoisting the last state out of
xfs_attr_node_addname with out having to plumb in a "done" parameter to
know if we need to move to the next state or not.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 87 ++++++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5cf2e71..8a60534 100644
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
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
@@ -287,6 +290,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_state     *state;
 	int			error;
 
 	/*
@@ -332,7 +336,14 @@ xfs_attr_set_args(
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
@@ -896,48 +907,26 @@ xfs_attr_node_hasname(
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
-	error = 0;
-	retval = xfs_attr_node_hasname(args, &state);
+	retval = xfs_attr_node_hasname(args, state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		goto out;
+		goto error;
 
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
-		goto out;
+		goto error;
 	if (retval == -EEXIST) {
 		if (args->attr_flags & XATTR_CREATE)
-			goto out;
+			goto error;
 
 		trace_xfs_attr_node_replace(args);
 
@@ -955,6 +944,38 @@ xfs_attr_node_addname(
 		args->rmtvaluelen = 0;
 	}
 
+	return 0;
+error:
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
@@ -980,7 +1001,7 @@ xfs_attr_node_addname(
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.7.4

