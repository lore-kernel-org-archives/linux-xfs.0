Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E07C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FF3E6117A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239944AbhDPJTN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:19:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45238 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241585AbhDPJTC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:19:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G98c71036469
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ijzmIM75l1GEP/KQzuWXYnkvA/MOZkxZ10rbTiwsBv8=;
 b=DO3kalcAF7LrszL3siUd0NXT+gOjKMpKO7dTKM8YvZWGLScztVCxyC2PdmxZukJfQYD7
 QHaGuLxexCpNlWkrSI0guWs4H9AN9N8rcOXyHKL4rxlV06CdoxIQutJ9ppbUu3JQ8rGa
 MnKHGNH1bxEsi/HDsyAGe+0Bzjn9Wya4ubNT8n/twBpR7eAWX1QCz7qTDqXm3mq9x97n
 hlU4yZ+UvoXQwRfnrp30MEN4iavzUDIKst3QIv0zdvHNWWqPpTdJ8yS5PQW7wL1sIF0f
 /rlg0LzB1s+NBMwiizT/GMZToZgz1ZxsPMgVqUN6zUZhfggqYK6CzPl4SlqL257fzDm0 HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37u3ymrj48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXpX077087
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 37uny2cbx1-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNqEs7olqT8rrpUrC+aUDFyLtCsZnds5OpYSPPwEaEgcQuwq9NLQTWU2pm2zW6utmgEsCWZkuNxe2jwk3CTo+Z7oPzl7kS4pMhxr59VP8OTN8MJcz0ZR4eaJ3Gio1oUS10TVqnDxizTuG5Ii2T2I3zs8u22xmtRh5fkWchFhL68IHkEvm01OJaV8wrlJKlD06Y+UohWrVUELb9FcAzTP5u3i6mroAGGjU63enJHEfoZscg19gZkAQstF4Ea+TUxhohdxmyUoP1MNjgL6jdS7+bK5QmatB17pcIr9BZtjp01/bN6dFNIZz8un15xgZ8Iegg+8mhaEKgVkH+ng4Q4DDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijzmIM75l1GEP/KQzuWXYnkvA/MOZkxZ10rbTiwsBv8=;
 b=cM7aGOZY5+jD1JuEOqhBF2yp/NW1XQr86ZeKdLv2eKxl0RSgKMcvgTKJs9u10wWl3Jx1MXpZuvc5QlkS8MdjeJsl0d63injwW96gR/bv7ObtxIsgbeDzWSZ2aci45qxtJzxi+u+kMaE5sjm8iNFLQ53VPwVARI53Vpc1nOASd0Ct13RTkQzDrqYsKXwzG0TM9qir2MUQDMjaRk7iggmXidIhrLd972BNdYxjAUUoyZVtk+1pMgq8ROCT1pWRTDc8TJAL+yUaCDDcq6mKwjLKsFPnNJ2vOvZqhE/BhlhdSEyYCbMkZX766FdKjK9HZnD8B9o70VreuraTwgl1So00UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijzmIM75l1GEP/KQzuWXYnkvA/MOZkxZ10rbTiwsBv8=;
 b=prg86xEmEBn1oVQyHcEppuk7B2/Q51nzGK/smMpOW68wtl+Vnc/3osK6XxQSk4nrIQtXYQaBfREXwHXFVKG4KZKor3hoizLyJ7nXczLCUUbrp+QaiRgmOmHjdfDtRKiyXj08OEqvUyRFyUHfz6dfUcDUfCQlIvUK8Txo4xS74U0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2486.namprd10.prod.outlook.com (2603:10b6:a02:b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 16 Apr
 2021 09:18:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:18:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 08/12] xfsprogs: Hoist xfs_attr_node_addname
Date:   Fri, 16 Apr 2021 02:18:10 -0700
Message-Id: <20210416091814.2041-9-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.222.141) by BYAPR07CA0070.namprd07.prod.outlook.com (2603:10b6:a03:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:18:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be11860a-a95e-44d9-47d3-08d900b89bf7
X-MS-TrafficTypeDiagnostic: BYAPR10MB2486:
X-Microsoft-Antispam-PRVS: <BYAPR10MB248680BF73144CD32F387680954C9@BYAPR10MB2486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UUu8gafrjAQh3R6vR51hHLkCRtBLlb2Bvi3l12Vx1c7ef8N8bVaN1Dx9BDl0VzlEpnE63ZhLpjJctyTcRoEMnJgHE+XnKY6Q36lbIqw5ETqm5OzaZnM03IXOIWxcKajJy9Q8oYfr9srReMyPr2ycbv9FA4nXGG+pYvTBJGPSaIH2RJac7863CjENirEP66+hLt/YtFVAwyWED0l2DQG3/ngtNDGcaNwi5kOk2HXIPN2+OKtkIm/zb6F325qDIZYO2UuidngCO4v7qCL0oJ+Q3BelUW5pzqFn3IaWzjER0YKXiqe6NAgoiC5Qwab8zMocGPxq+/0fGH/Hgb5XG9Rm7rHG7ThD6Tiz15bS8JtSiasCHfGO0U0W2Ia4KqPy3MKluW2ETZ0pqqcc/ZjztSWfIPe9FH6W0N9anEN1g6TjEbJpMDF2JBBuv6JYFZW//oXAczqj+CCp7dqgFDXwpSbhq5XbcXUgO1WBLWSv1dgQF96Lzfa9MNWinnaGwC2gW4AVxfCI56lB+fgOatDE5WEwPpQokTw/3/r63qbCIHXVxnTsejUfRfDcSIdZKqFwujNrdwO6A9LKxt761Bpp+Xc6UnPsEGxH0I/dw6oKtF396Bk322ZQf+rdkryafG4yGWCtEMiOW533c7A3LhNpOjBgA1J/F+guWv6SN80I29QZMeWFQjk1cNBxudZUrH/nZPjt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(136003)(39860400002)(346002)(8676002)(36756003)(8936002)(38100700002)(508600001)(38350700002)(6486002)(66556008)(66946007)(66476007)(956004)(52116002)(6506007)(6512007)(316002)(86362001)(44832011)(83380400001)(1076003)(26005)(2906002)(6916009)(6666004)(16526019)(186003)(69590400012)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ujsFffIMKSVUDmEq9erMfwVbiV67zYBVw5IAOoejP7mKanUexxm8nZ/WXO4/?=
 =?us-ascii?Q?32w3x6WhMOEN20tWqT/RA0xdqhAznw/n8nRvJtuvJQR71CvvUKK01/ly0B/c?=
 =?us-ascii?Q?0e2ACGWxk37EFpohxRmk2MhNN2NrLWuxjtW6qzv9KLefioSwo29gclujcSWH?=
 =?us-ascii?Q?44J031xJduQlHyvrblM7sgq8hAmRIYe6y2A9+Rgv7SP1ckL5EFkY2jpOSJtt?=
 =?us-ascii?Q?kKzqNwdDh8HcvFCLHXBqS7H1UIpaaI/ULFJF+TISqhBNq4B98PN/t3vn4y6B?=
 =?us-ascii?Q?i80HiIUTuJJIW2bUsQIvBYLoQ75Nod9rR1hKp8VChtdZusXJ+lBK7lOfVQ/G?=
 =?us-ascii?Q?D+rYmiiVy30Q72lOsV3+TwgrbcybzGBIKyLrf9ggx6/pQfavq2sUNJ60GpzJ?=
 =?us-ascii?Q?YrJkrPHOXLyS+pkSo2wt2RubmyI1YBAvqAq40X63/YM7oCMs3rZcGxmXkOoa?=
 =?us-ascii?Q?cJxBBKyrRQn5sO2zSmoKjFTELQxFY1RNCRS4OZU+gmU2rWtKxz1hpsDSsrNS?=
 =?us-ascii?Q?6Ws7CN/SXfyRJW4ixYGTaMpXbe+4ahc3C9ePKpcKPDxhFIT26me//pdG7MZo?=
 =?us-ascii?Q?ueUne/cz7dkhLay5K8zOg8YGBbTeTujeZZHcaTIsRRaXt/JnRsHksN25ZiZs?=
 =?us-ascii?Q?UtH8+wleTWX70e1BPB4VqusjPva7UvS7LSZgFw2F2v/aor3FelDfuCC7wiV7?=
 =?us-ascii?Q?0El4BYCOQe8TvPISsXjG1hIyel3ATscEzPKUBW9tcuKJLcXyKxKENAz3yU+L?=
 =?us-ascii?Q?b85o5gJWGBw6trsVk7hpL/yf4m6qrrSOKMBz5y/QuAjbqrqDM4BvAPSDslEj?=
 =?us-ascii?Q?TO0APgbMfhxMpV/XujgYlLZQhQDbT/340WevSqMWeJLx5/5yicwB5PkydApA?=
 =?us-ascii?Q?1T3UqEL7OogaZC7nDVRYtxjZr0swvtH76jaK4Ku9HMgb49uJrC9pDQeKmZar?=
 =?us-ascii?Q?sW2BS3pDJcljZ7FbW1bucDIKCdA5udqIg483ARD40wvqkdWawj/RjH8ciNpT?=
 =?us-ascii?Q?LcKKSWn2g/JSElTmNdYGcIAe/RLyIJDLA8YZK4q3iubXjC1nj0oHmNn46scP?=
 =?us-ascii?Q?kiPTX+ABubbR18fYtXb9y5BtdmXUFglWfhl3JIIJ2GhyVsi/a8cIFG7bWq57?=
 =?us-ascii?Q?ZC5MEkC4+8UjUPd+1cd2obgXIiE8RAsPwmmILAp3VevwNDSkCGJwxulpCcVH?=
 =?us-ascii?Q?LgKalDO5Ttpc/EL4Is0lzYR1LrLhD8xjWc5fa3pTxZQHov1LiB30HpuTmKvG?=
 =?us-ascii?Q?ACm1FEOlFJSDDyoReBbUTEQia0OEzyzd/L0sevNvjgBSMu7wUgzcNZdOM1N6?=
 =?us-ascii?Q?qB15846eAjGXp010fY+NHDt4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be11860a-a95e-44d9-47d3-08d900b89bf7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:18:34.3239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eboh/Rt0vUg9Q84qixxT2qOItphgvhNPT1RPrb63eRzIXry+IcaxS1oagRNA5VSoE6vxZT5PzmMISjqBWdaV7NsBaseijpFOu0iFAOzEyD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2486
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-GUID: HJLPcwsE9Muj6OcOSTHH61Q5pZYIanch
X-Proofpoint-ORIG-GUID: HJLPcwsE9Muj6OcOSTHH61Q5pZYIanch
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
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
 libxfs/xfs_attr.c | 157 ++++++++++++++++++++++++++----------------------------
 1 file changed, 76 insertions(+), 81 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 82b6c19..95e4875 100644
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
@@ -322,8 +323,77 @@ xfs_attr_set_args(
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
 
+	error = xfs_attr_node_addname_clear_incomplete(args);
+out:
 	return error;
+
 }
 
 /*
@@ -957,7 +1027,7 @@ xfs_attr_node_addname(
 {
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
-	int			retval, error;
+	int			error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -965,8 +1035,8 @@ xfs_attr_node_addname(
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	retval = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (retval == -ENOSPC) {
+	error = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (error == -ENOSPC) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
@@ -1012,85 +1082,10 @@ xfs_attr_node_addname(
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
 	if (state)
 		xfs_da_state_free(state);
-	if (error)
-		return error;
-	return retval;
+	return error;
 }
 
 
-- 
2.7.4

