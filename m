Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63A9C433F8
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EC6461A3C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhCZAcI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58122 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhCZAby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OvTd111381
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=rD1FVs6j5zXIXsGlS4ZKFpBdgge4iKQpsHOyS+Y3K20=;
 b=tDRmJiSgFEiOipRBeK61lXLqGRBdb8YGJAR5E+3YfNZ7CMwi9DAuZsLHoSgAn2VsaQto
 badCc2ZBlPQaPy6UzG1qq7Z2u/lsPs4VVN669A4fRkELndf47fARf6iMOYvQVSrSghln
 IivTnqv4nUiRn/JahCZ49m4JPgySKO6pLpcp8Xbf+5WfnOv/LoOp4QYNXXQYYldpzKeo
 jhkbU5Aj2RYwdG6Yr9ekx42t9uiFF2HtPcdm5oXPeyWqSQqFqAk45QEhemI2D+kfk1rn
 myX8THLbijaxgHA5DJdUc200AEythpZUwdbHUCe17WTlEs6i+BUNe512mbx+MJtT9UjK gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37h1420h6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Omuu009664
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 37h14mft65-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bANBYizHUv4gnHRHZ0CNweupKY3a/OHWC6NuTLbjTJ0Z592nizx7Z5wz57g8E1ek0KJD3qv/HN6dzaYVLCm4ZELa3dVQhUv0NA0N9vyWQecEMFtigHxXABi1GtJw/u7hXO8FDfUoqa1OCBLk/ajrrWNOuuS2bPHf6pBJa/fsvaGUSDLlGsQV+2nRH+kgPXCoRtH/4RYvenFr12KOzb3RgaB3MGVBAu+1UUmUbDD4dWmZBp9qApHqCvEGUXaFzhDHo6RuZAoO9EDDCtDBE/z+yMQSKUVMxO7uQOvdGidtehtU31gNorAaxv9BAxiNFQvtbqxVr2kViytY7GUsz66hyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rD1FVs6j5zXIXsGlS4ZKFpBdgge4iKQpsHOyS+Y3K20=;
 b=L3Fwczb4jrTZlm/hrTelBkcJaiMkqOgAhexbMupILwWvfCFWR8Kh4U8mbYh98mfBWOIKVKaXW1tM+paye0jVQsHDt0VBei3YjyII/H81xvAPjpzyt3LtUUyJGWYqJnYqDjCZJ2ZoR705K/yHPX6CUSZcuTv4RqgbbHQuCVqe7uEeNLdLtPWKRsN0mWJjaUnsOjVVjdBfszkl3yw2HkKFTgxBE5FvQd6LGT7Ag8PpCJYOb6t/AfqfZfLcVcEvnTKc0twQHkJv8aE9lT7y3iRwWSHvnQFUNBuYti2FK22Nld9yjCmIrUqRbjR5KK4q51q6bvslUh5QlAIfyNo6SYkLHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rD1FVs6j5zXIXsGlS4ZKFpBdgge4iKQpsHOyS+Y3K20=;
 b=0Uyh/XqIivCLBt5OzDhqji1zubw02mmctNK2w0ltwSymduVCRiaPEcSSqzd2zbiyOmCyLmxJdxXIsg3tjCyxHBSllqNThK4p6enJYqMK5FSdGeA2hZaJl3TJwGVQ0QfOM2EgvH0BmmiFOSWxo/ke94nRjguDqPIuFKIcxE3mDbA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 00:31:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:50 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 23/28] xfsprogs: Add helper xfs_attr_node_addname_find_attr
Date:   Thu, 25 Mar 2021 17:31:26 -0700
Message-Id: <20210326003131.32642-24-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5dc006c4-0dd1-48bb-97d5-08d8efee8c29
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB270918A71D4BFE446DF8CA0595619@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0+TEhgmLiepsELpVKXnS5ya5eiwkVXr5Y8AODLRlIHdvPgXVnEV7hZI4s0eot6BUOzFrkDR/59NBTWhWMjWBLDUS4aepMPIeEZz6nGCgkwBENmtl2tur5scCZDg59Zjy+2IwPKmFz+pvqiRfix7Uo+CS6tduSfvhPCQYk05QFXjZx/C5tinbOikD80E5VpuMe+0/+Q2IYLmuNYGZ9ZUo02G4kGeciCq7xY99QYMP8D5Ira5SUHNDsEzNDjejO9EtK4OTPL3GYT5F+gllrhbg8FxNyHQRhnFI21QjSenbtwwBxY9Ast+2HvnnV350PlZ3dTEKVDCrL6pr+/2Csk+KD8qWqhh71iuttw/IrvqVriCnVlmoTfphnZ5fO35hdA4f5SZpjIW67Z1PIg4NADeEw4gmQd7eysOiYDnUuUodZ/3ZLd5S17AS+9xFz4mplaCB7vRUHzd8GIeVhZW7vnH3NtFn/p3ako+n2FAof2wPY8D5LX+H5ZSWcT6cO8AoOwgiV3hBAS1PxuFpvHEWLD1IbOK1ENazssfRy8N9hDoUgAu+u2M8aUNZERu8ObiWKAbrXXEBDm5jobKYPfiTgChj85iFfect6FMoY4/QfhIOnsBbzUIHRkhbK1UfXzTxh8Kb8Qqj9suh9HLOfC3RIjDDJKBpTT5Ln6dxG8NZHKDIuov4D0qUtM7DIX79Pohkb0Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(346002)(366004)(1076003)(8936002)(6506007)(2906002)(6512007)(6486002)(52116002)(6916009)(5660300002)(8676002)(83380400001)(36756003)(66476007)(66556008)(69590400012)(86362001)(38100700001)(66946007)(956004)(6666004)(316002)(2616005)(478600001)(44832011)(16526019)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S+Iom9FC2OK21Yn0vkVkbykPb8yH2i5hH2uyEaLJNaTFYc/jrJZywrP3EuzF?=
 =?us-ascii?Q?SUzpz/teDKdz70R6xpbUrbOOENgopRaSyugm1jcEQ7gUYI/H9ivqxOW/iZy0?=
 =?us-ascii?Q?nWGbIhoWQZqicP/7mZCaEzHmAMzPMfKJk92jD6T67d2RM0PPLiLr7YvVkdB/?=
 =?us-ascii?Q?fG/f+iSp5NgPp74CXq3lvGUDAStuf6dyBvJQ9UXNopB15TRcMIuDIj43x4Ap?=
 =?us-ascii?Q?H0GCDgBhm8xtS1yUOG+K3UlrPM/XOTrxiSxQUiRXvUvInFJg8FfbS8e3xO5A?=
 =?us-ascii?Q?1hCcvPJDV6oYBCs48xkPIS9nrn4DlkmV3tp5ySkcEGVlSyxIEZG35cGSYldF?=
 =?us-ascii?Q?pi4CbZABxtJIwDSk5ImA68yG4zFoz5LhiERVgra+XQC/ZtQ0P9j0KdBgL3nv?=
 =?us-ascii?Q?3+IrdDludbsNTkqTZQx2BDqg9y91w0xhYMWoGQIDFnYA9WdB7b3FjRZEVVzM?=
 =?us-ascii?Q?IwPWIJeTIIrNlXLM4WylSfrXIlV9bs8Zkuk79s+SHOXIfWPXbaly9okiZ+ZF?=
 =?us-ascii?Q?m01wxJVxFatSl02mqeLNPPYF5afx4RJ8q+8FrFpfmmFa84Xc4WNQXRP/Y3xw?=
 =?us-ascii?Q?n5INLaam9AzYSAmYvq1mDujLPRtgI/hrxN8Nx7SxkgJ+6Ntr2orKXae2iJrl?=
 =?us-ascii?Q?anBoJ0s62zthzOkRzkcBgAfmX75NLBAD5akRjkafqUGICj76paGFzuFCS4Hf?=
 =?us-ascii?Q?RbKLWQDRpKTAHHUKQ+xzzCnM6qRx5Pj/cm540IGhZyMemP2L/v5FgiBnpdil?=
 =?us-ascii?Q?9PgKdZzaAY0Vw7gFOrLUyzwKiseLgjgNnTttCUGOWZVLJs6Ukecsbgm3jkeM?=
 =?us-ascii?Q?EZ+NNgzP9nzETa/RrH2sOjfqIf+y+qi3mfxeCmhRGN8n0lKUPVkKNKoiVaY9?=
 =?us-ascii?Q?DP6Qbe4/UmyNhSKlXC2PGYcG+5eV0uvJX81UD9HAbhBZV7PYqtTok+ZmriWa?=
 =?us-ascii?Q?TFcodg9dpbPoF0U9yFDeYFN+mc4Of+PkIDZlLE3lMEBtQbznxmeYktV3afwE?=
 =?us-ascii?Q?/9anfAdXlK6li5j8QGM2mnQJa2txMRUfhIwr36l5Hu0CrHIZXWHXEhO4vGqX?=
 =?us-ascii?Q?uzAp4mTqAQ4JQj2599FmQwEIJ1EVK2QXNeKdQFHJu5jsfsjzpwOfvqiUHg6X?=
 =?us-ascii?Q?rTTbC0KtIwuFht8S3KgARddKKYVIbDGVjkalWbghvOTPia9Qm3FMOmUILhEk?=
 =?us-ascii?Q?Pnid2aSbXSZ0cbDuZVyCwiLgVG7Y3qAFkNhNJMXd9JOEPP3TYUCMKzDW+2gu?=
 =?us-ascii?Q?URZTH+lezevEnyLe4pef3EzvZYm4q1qfgr3/CSZuWPPln/eN6wFntHdFp65X?=
 =?us-ascii?Q?wnHvB7CYTyfvEzdrQfuf6EAV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc006c4-0dd1-48bb-97d5-08d8efee8c29
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:50.6940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SjW6bCv5swei5BvoasS6FvcxTJdtqCMJzIXY5xnNHtMRpNpQsNGqpkCNkjDXETWYp27HylW5HO1ziIkpb7sXV40EqVNFLzjdamXQa3ylHdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
X-Proofpoint-GUID: xvnDsKy507tU1vQU_rLd6uIGo9llec6g
X-Proofpoint-ORIG-GUID: xvnDsKy507tU1vQU_rLd6uIGo9llec6g
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c | 86 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 32 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index e1d37f9..88e0502 100644
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
 STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
@@ -267,6 +270,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_da_state     *state;
 	int			error;
 
 	/*
@@ -312,7 +316,14 @@ xfs_attr_set_args(
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
@@ -898,47 +909,26 @@ xfs_attr_node_hasname(
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
 
@@ -956,6 +946,38 @@ restart:
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
@@ -981,7 +1003,7 @@ restart:
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.7.4

