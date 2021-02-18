Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BADEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DF7E61606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhBRSpT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35694 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbhBRQrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTtRJ040624
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=z6LBey5O7R6UxzX0oSM7X12h34GxmHx1LVxVpT+GL/w=;
 b=PJo5u14LQlLM3IyBwlEoKC51KO0jb1MQPVKzwgQN0BphZsNAzxZ15WdkVfAgUMrzuC8z
 DRqlw5+NOUuIP3q3CsJuwLOU0rKs1GssqDpY00W4jN5PN54On1dPcKoUju+6Or3t3ICS
 kglO0EEfPpeDk56hdEaSKndpUe5uNFwXtIY3JcE3FJducvhwos6LNZYOyzdx+CBAu3tg
 3mmwy5LcZjM6WEtl5AZGZM8HNMt3YzpMO2ijY7Evpu4qgPrg4yTTQ5P8mkM0rpm535m/
 SrVJbx975WuswI0S2nYd2PWiP9G/Mu1nS9E5GB2usfObjNMlrsGRZTyNItzAYlT422Y6 Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9ae3hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUBLm032269
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3030.oracle.com with ESMTP id 36prq0q55k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDcOLs/3rQ8cPS3EXROyslTxlwq9xkuEdxrd7y7lU3GjaXuiz1i7eMmcaqWeLdTU50YCJU8HPnYmoOQbWNfGzfFCPeCD5DbmuN7HiwAPcS+lg3aNGTBYhslulDP09E+PGFXuxo5KEJEz+dcWPK1M9JOKaE7gUnPxCRMp7edMOEXZ/6j3xZWvM72ChhRfQLOf3lV7xJbEueFwAJtTEuSRSYI/Ye5jhwN9x3zLuelSgSgbnTmLbn41M7XADRzp5mPbbNQjV900VVH3jSe6xQ5liwSd2gkJqr1fLpwwAQsMmQ5Bw2qUWtFagePtEQJxHSfZDfxHIe1S+rk5/JZx+afKXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6LBey5O7R6UxzX0oSM7X12h34GxmHx1LVxVpT+GL/w=;
 b=TU2Z7K/oYPzFMVweyTczWleJ6pCimUrh/ufD3LAeg0aKtnDxF5k/A4DzJTwMgDuxBR1FmSeGrQTkOqAVvbitYU1IQ3Nk8FUq4re27NpGP2+ozUBSdkn3QTIyVi+phul/cxBO2JhtdLTC+Z8UoiJRSmnd5JpCJLkxobFuZGxO/NKsz5MU5O4Ed/jKGO2rXpHqVlqdjFvZW0czykYmH6D2L7IXjVyLWBCXeUW9PYs43cmkYf5dQzgnjQOHWfS2d2RsYn7I2haXNW4KYnJVgWSDBaLJgcUUr31TMmQqIhEJgR5egrHejgC2fb59dh/G7f+vjP+cQBrrwp4Ox6mZbAo8lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6LBey5O7R6UxzX0oSM7X12h34GxmHx1LVxVpT+GL/w=;
 b=wGrye9S8TaD8p2cvJS3knsQ7E7stP1r5WcVPJY0IkvY2avnAMxCBavZ28A16b/j6iddhqC/2KzMnsL1S7XyRQzUSFxmN4rHus1nx2XK6ggJ49wOt3Lz5dyA1syJDPWdBv60SiZpoHtZf9be/f5BvsH7yyOykkAxmf70owOLNqqw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2965.namprd10.prod.outlook.com (2603:10b6:a03:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:45:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 25/37] xfsprogs: Hoist xfs_attr_node_addname
Date:   Thu, 18 Feb 2021 09:45:00 -0700
Message-Id: <20210218164512.4659-26-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5e0d1837-7497-461e-086a-08d8d42ca17a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2965:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2965FE92E567B4D49FFC1CC595859@BYAPR10MB2965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oscgz9atJEoaxe4TFPxztOYX1srQhRrSXBEeJbU+sTb+vtIJTAc2hwJgn1gqOtSFTo3cVsft06EW0ACr0YQlJELP+wm6fcMQ9QubMbD6JPAtPedZD2LAcr0HFQCN3i2GgDis8ltKiHUjK6z8UhR631EQMYHo7kP15EVNo2afdRXXVXYetok+X3jl+9FagCpzoKlwTGDF9JpNvTw6TqnBHBV0JMu0pZe/s7SOnVt77KHryR2idzhqBhdvKbJp3kt+K7UJ3NwXvr0KVj7dT0Vg0alg5+t77FOwLys9ifpqX1TMxmKaDuxdu1m3FMgj/DZdv+MvsQcuAYT+7/dUrQnh1h8HLFsxG7jlbyPCHr+BqvKr/C+WQnT8Bw6SVN0Uts7uF/LTAHuqPczCWfLqKmF2iKXIIk1M0gM9ynCSqLAbM5dctfIOIHst98WpvoCDaA29LEHjLK65ACdN7R/6hgQ/EfdR6nLXwC1i6k7jslvUxsyUvi7qSuVyRfYNYiKkL3Pt0tvKozAVCJSYrwaI+8+Olp69AnSWIVmlIKVvdlqw/uX0IP+LJJXZyG7BgRpuD+FNApwDrh5UJlfdS9mwFOyvaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(6512007)(86362001)(69590400012)(36756003)(83380400001)(6916009)(66556008)(8936002)(66476007)(66946007)(478600001)(52116002)(6666004)(6506007)(316002)(44832011)(16526019)(6486002)(1076003)(5660300002)(26005)(2906002)(186003)(2616005)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H6/CrmXAvkyfWTpJ07ebjzMwwl6OMP1kT4Q1JfLspt4Uttzf44zrMpS9J7KY?=
 =?us-ascii?Q?pjZaSQKIWojNHY/5EdHvPd7f76xje1BbtepA5koeM+rdY1sGKzGZkGpVOe4I?=
 =?us-ascii?Q?pGqkEtPlTCMZeDQY1g5IjDdLNO/oV/3bJ/IOv37v9PBEC9IaJSnNvMSaYQR2?=
 =?us-ascii?Q?6kLLokpLaTEz852Pw21jJtwjPHK1cZAQollEpMSSKCdFJzVUIJ2yh1KloDdj?=
 =?us-ascii?Q?/qAwDrcpqgd2O8a/iY109FCW0i/wIgIMe5/+VpB6sTbH3HtFwDTs8ubyUnM1?=
 =?us-ascii?Q?ILsKx+NJLpT9UVudOW3XVZ+RmIdsl7GIeGp6wI+7a6rkUI6AITlGAgHzwzG5?=
 =?us-ascii?Q?VOmEFybQmV7FI4byXbDtZ793DoGrbvs16/gqsxxNGpxErshu0i1sVs7QC1sS?=
 =?us-ascii?Q?FxU7qBGxI46iKvR05QRK0JSVCr+A8wTJQFpplxM6w+qt3w0jiHODdjbKaM5V?=
 =?us-ascii?Q?IKtSJ0klTs0mxt6CDYWEsCLAAdvOo6iGosZA17Q2fy31egmlX03J2twK5X50?=
 =?us-ascii?Q?FV2EkNMf962l9VndEIsvOwFVMqhD9PMP+1XdWCBi+HVKu2lUjvWr84wGeSZR?=
 =?us-ascii?Q?x4nCUpVJSwdLz//+lTCgFAgXXlTOZcaVLeTXJb5gfs5CoZmVzrZIyiwkg0rL?=
 =?us-ascii?Q?OTF5Yoqoisg+H71W6ATq38n2DS0ol3595Noxf3yf/um1aiGi++2J+HZqnV41?=
 =?us-ascii?Q?QAhxraOHn+E4+XKkmQ7L2aSWdonfBe1muq0MahATNUoN/JYXC9Ed0dVFYI/K?=
 =?us-ascii?Q?JGqDptjPgpEtAafXFhB6ungF4EKARArmWLF9cNdjgehSNbW9GywrqyUIDWFD?=
 =?us-ascii?Q?n8V+LlyirFIxlf4qro0v7UsSNBBBSdrtoMyVVmydzURJT7ZKrBReREHnyUhp?=
 =?us-ascii?Q?5h5t1/zJWupmawyGEmoa/NWwn1PAKbaxf+Pyx0YLU0PWkvw6Yo2cwARqVguP?=
 =?us-ascii?Q?+EvVs9RL0FZ0P6QkD5tktp4hYy7TVqSw71ROaVzvvVFLI40t5oD45BeBgrZG?=
 =?us-ascii?Q?HyZcEtQDpMUk0Pr4QpgdW0eURstzy1jIvZhmvaJxF9XEveepT5gsJSnEVSx2?=
 =?us-ascii?Q?3foA+PaKCSksub3AAHIBvEB8v71EyNVV5DvFNTfz2silkPXewzcHa3s+ieTJ?=
 =?us-ascii?Q?AG2QMPU8crwK2zPElZ2+Bbe4FpLzxHs0MF+eANd1kZuLnILctdzlYqJP+2cj?=
 =?us-ascii?Q?dL/aGLiPuYnRtWRklgqj9HV8bWe588MJWxvvVBJZH8DtluzOw/s2R/Teqy4o?=
 =?us-ascii?Q?zKbXT7R02kOh8OW16j7/nK9TMyRtvByakXN83avDSVb03RPWzK4XS8UHtq7I?=
 =?us-ascii?Q?btt2vh57r8B4JhM8j8JtizI6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e0d1837-7497-461e-086a-08d8d42ca17a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:42.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlwIRIEZ6DJ4HGI+8WYsMlG5o7xWxjNhotbE27L2STfKgcZGusczqvW6ttHuGIfIzJfP5mgHPY17GrU5tWomdH40LGC8l+4Qc5+to7hC+4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 8e7db2a154cf8889319a4d6e5f987998ed21fa1b

This patch hoists the later half of xfs_attr_node_addname into
the calling function.  We do this because it is this area that
will need the most state management, and we want to keep such
code in the same scope as much as possible

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 165 +++++++++++++++++++++++++++---------------------------
 1 file changed, 83 insertions(+), 82 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b1a099d..5fadb06 100644
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
@@ -268,8 +269,9 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_da_state     *state;
-	int			error;
+	struct xfs_da_state     *state = NULL;
+	int			error = 0;
+	int			retval = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -320,8 +322,82 @@ xfs_attr_set_args(
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
+		retval = error;
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
+
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
+	error = xfs_attr_node_addname_work(args);
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+	return retval;
 
-	return error;
 }
 
 /*
@@ -968,7 +1044,7 @@ xfs_attr_node_addname(
 {
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
-	int			retval, error;
+	int			error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -976,8 +1052,8 @@ xfs_attr_node_addname(
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	retval = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (retval == -ENOSPC) {
+	error = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (error == -ENOSPC) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
@@ -1023,85 +1099,10 @@ xfs_attr_node_addname(
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
-	error = xfs_attr_node_addname_work(args);
 out:
 	if (state)
 		xfs_da_state_free(state);
-	if (error)
-		return error;
-	return retval;
+	return error;
 }
 
 
-- 
2.7.4

