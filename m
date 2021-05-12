Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C48C43616
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 494CF61363
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 17:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbhELRGL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 13:06:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60190 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239719AbhELQPj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 12:15:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CGAREe005168
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=lWTj+lTZidiJiPK4WClnpscjlQicWH8NOxdMwtp5Tcs=;
 b=KyIifu2QUkNS22rKbPoLXXFLsN+v7HvdM/wqUIYMPxDrCktl8I/hD2nc+X9Si9rSxZfc
 x6BDfv51JUARffwFA8BwN1Ig0QNg5h9ZfsTaMRQ4w1jcOQMGrRErhGfGHuFZ6GZLiYYn
 Nb3KRunpopN6dEXBeYBikfCj4Ukpzi4CxdMBp9eNqjpe8zNRYPa+f9Bjb5es6dGQj+re
 SZ0J6Jx5qaL/Hr275PMDBQ0xw/a52b+SzbD9779kO6ntNgG+kyFz5kzbGl9aSZzzlO9a
 zjlPwYxfE5Zi1bOfrYFXq43xjxF/b7AJ03iy5P+ZI02dpcfJ3jNR10xzMOm8QeH2nPcx 1g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38djkmjjn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CG9swp194902
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3030.oracle.com with ESMTP id 38e5q026eb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 16:14:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/wtdFRVto/wasV6vk1HXdex3VSRDpKXRy3GAxVEyIj4U5FLxTjtQU3W9QOC0g8QOqbdthv+efMme6R3fKYE68hWHGr68qGNVQ5YLu6AbGu9Z5aCd9qoU/onv7M5wp7EnUHfh2PR7OHdWRjv/54liXXphdtDnkWebZEceBSqx9sPcqjENrnHTZb7HaBRuemtMoC4nIOrp2XtA9Kcdmrn3XD67IfuIfOqHdo71uogUmAqF4BJ0g9dc10w0zOV5tt8l1q3AMHKVy5xdeYCN0Qj4fVJi47gk4goDl0B0hsVW9VGLyJPZHYqpWIqfSa/CbQTNoNwOgZYqNDhPM8ImC7+IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWTj+lTZidiJiPK4WClnpscjlQicWH8NOxdMwtp5Tcs=;
 b=U/vkB15OPz0oQPd30/8+LamN+X8lmgmgvksDjPtQALYiPJXe+pRXzQZXhc9G2+BrOvWEm+RRRn93FhUZm+UwpB9yNo2DuXSUJVY8R/YvSHpsVCNHnnTBMRAXlzHONcukf4j1s+vOXIqSjm8TNu/HNRvefmDUbSm0xB8V3xkb8nn1PNI50Fn6clUGoR1F//sQMLMB10B/B4aRYvL+TRpndPNjmkoQCJz5BBPhYpfkrYB7KTRTCMJHOYeAQDKEWSCoHYxxoW0b8Mr521NBtzymsKv9sfRV0VPZg+uPpcQZivQ6UKY2lMyhv0olcbO043FOhut2+vEj492ceACvSdOwOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWTj+lTZidiJiPK4WClnpscjlQicWH8NOxdMwtp5Tcs=;
 b=tKnbJMnVCaQ3BI0AB3d4nzo9dnEwosD8hB8pdsdGZhu/EQ4CWMvh8yZwl8i9OAoaZPhhcYH5b940YTFret5+rf2KvOV4niV+pVdRX059ZU6bX2w4x4V9ax0Ez/jOGw+L2FGvF0D5+DVTBOatnjLttNGWuGqFaCvGUmvXGFMUCb4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3112.namprd10.prod.outlook.com (2603:10b6:a03:157::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 12 May
 2021 16:14:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4129.027; Wed, 12 May 2021
 16:14:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v18 09/11] xfs: Hoist node transaction handling
Date:   Wed, 12 May 2021 09:14:06 -0700
Message-Id: <20210512161408.5516-10-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.210.54) by SJ0PR05CA0200.namprd05.prod.outlook.com (2603:10b6:a03:330::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 12 May 2021 16:14:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c84ddf6-1c01-4584-3c46-08d915610309
X-MS-TrafficTypeDiagnostic: BYAPR10MB3112:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3112C213B9562C0C317F60DF95529@BYAPR10MB3112.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hp3g8VaBC0Kf54d1QbH8Vv+tanJ0v2tvGRyepRAl7k/IZGJt4GijGAqbC8YKAHtRyAFBc5HXpO+gnv4x9ph70Sd9zMTD+pxMvFXHZrYjOS0iGW83YSy2P9+o5jSvpTZb8RQ98fee5sIDJVK6XtpNgl7IfO7fkelhT2W+9BJXd2NSKfkY+3VWUEHN4nYrRzlsalkEw9DnhHXGc1Ri7fh7Za6mNA3r9JlzMbCiU+gDUQas+CL76FKFjSnH330aUFEcyPi7LokhStJHKQ8cKrQpzEj5o6LMfHD8KPhheyncVWziJEh+1OSBqF+1WDLHZ8mfqbOeKtoh+zSHwBja2Iw5xPWJ09rge6QPBl9YtgHAIqo24pyuGd8XC34Lb2AoHHpx7flvLRgAK4JnhbhKGbs1uyuDReWM2W02G8Ro0JR6bTUXtDFHX67EfNdMA7oMxWwVW3ZFqH+x0+6ohqkSKjCrPVcfq/Ljo5H+MGQv9cFr2vaeRCUjnyhJxcUIWbySl4zYzpi8IQAGzKovNyh3m9vBS9uLSTJKg0Wgkee+m93zVPGz0VSeLCn1YmgUciISppJJgHDf5DpE3WFfGnchDJOqwPdMU9+BHDe9qL3aGQh7Y5sZBm/ZOrxXncElkW/1605W6U0IMJ5qo+axDcuycOH5YpIiXg+wx9UEAChC5kEw2ycHADhrMzH5Qh60eGwRWem3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(478600001)(316002)(66946007)(38350700002)(1076003)(52116002)(2616005)(5660300002)(36756003)(8676002)(8936002)(66556008)(6486002)(6506007)(83380400001)(44832011)(2906002)(6916009)(186003)(26005)(38100700002)(16526019)(66476007)(6512007)(6666004)(956004)(86362001)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7zvjEgW3TR23o5lfKKgqJ/Qeq6N5J48drAxWlkBIso1jmGSgyxqJQzJxF99U?=
 =?us-ascii?Q?4KEKQ4ffJiUUd0cRF0lFkif9RlMtkNeGcoYBsjDeUlI3egAD6KvTKwxUU0NX?=
 =?us-ascii?Q?J4+a2uePX7iO2M9efzhHDw8xHXBJgxPPRVIIf1LwYLsDvB/86j9VVm7kRk1j?=
 =?us-ascii?Q?J5dTdWB+ThRsjgDprdaRqi3HTteSrIrhxllcMZfeBgCg9X7DmEtGESdruN2w?=
 =?us-ascii?Q?959jbLebxI2Lz9jTHX1c/3cqVEuvL9fwDfFKibiWtJH+X7ljns7jyWjJO+GS?=
 =?us-ascii?Q?hipAwTf9lC9+OAEUym7alglbGm6tbc1yysr4NpPUg/bO2Wsr23X/sf4FoRWF?=
 =?us-ascii?Q?ZCvgLCaLlrX9nSUlv+bgCrynJmSaTkkwbV2nPEi5JbPJfKpsr6jyXtTiIHz7?=
 =?us-ascii?Q?2wb/hqmrDb8IY3ZkkuTfKpETnrMXE1uQUxxPsc1wU3816oPqKP3kb49Tl74v?=
 =?us-ascii?Q?+m4cAyOKrvJs2e31ubb1AZkisuoL5Vs7xFeIYBxNB4Tku4hjSVnrwF6WP4A6?=
 =?us-ascii?Q?AWUCg3DMmTCRO1eLmX2LbMM55l8uPLKmrULBfN3F6gXU/97G91BHVzAMD1BF?=
 =?us-ascii?Q?+yoMIIplMR8hD1ayVKVNi0fukWWyDTudd/ROmrhRM8fV+7POAgrRaLc7WzdD?=
 =?us-ascii?Q?cnQ3m7bS40fmskRF/tbQudr97KX6WTQMBJYr0v9TSQyq8nvapu7+QPGkjoop?=
 =?us-ascii?Q?Fsvw6aBlDehSLO48MdpDiXN62zRTJGCUdkq97FZoumDN5XqG4rrCfW/2F18g?=
 =?us-ascii?Q?Cwm0D+dlG/nOOQp6Lr/WS/Q4hF8lk2cyaVt4hquepjkodMT5/mdLEXmlBqQO?=
 =?us-ascii?Q?uS3/GdM4hCtARU54uxKDy/C/oCmdC6MVM2ltp0chwxIWQPlTmNJ5nT2Q3xGu?=
 =?us-ascii?Q?IvYZmFxWgeF3flSdd1X+xuaOhnq+Vg8SutWGVm2kgF0qYAxEiIdhUfqzpMFK?=
 =?us-ascii?Q?ptMUjNTBxllW8SWOlcHTZpXK4vFLfsHMWo61ZEZyzQJSW4Wduag0Aqz2R9+F?=
 =?us-ascii?Q?T0B0uZO0bL1Lc0jwSrQrTPkJ2cmQzdrH7NcxK5r8ivO90Wc3pyolb6HGA8bR?=
 =?us-ascii?Q?+oSvh78gPEycfC8v0lRe4mWHE73O1cj5jmAeV2Rmd8nxz/YRMIIXQ+CBbYQB?=
 =?us-ascii?Q?op/gN4qSgNoZyaYbAjI02qba1FpGgB+TLk54b2eRuRVACqFK32GFO2FM7sC9?=
 =?us-ascii?Q?Hlog9m4zlvrLGAk07NGJc82di7PmI1J5mZ3l9PwmiLEiCgTvOqaQiXbN1I0/?=
 =?us-ascii?Q?Ay3/FtWWNJBm6iee96WYoD1kzA8GQSLOv1wpAY3tFErjIJdidFG9GfpP1hES?=
 =?us-ascii?Q?aV2Eii0zwbdBOaXBfqUhofh2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c84ddf6-1c01-4584-3c46-08d915610309
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 16:14:25.8584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hO/1e02mloBssV039SiK19KnWR2j54D/eRUe03zSZ4INmIkwq6qhK3W3tg0XVm+ZAqnSooYs5oukvlNeIsd7MzQbZutHuAtN8TgkNqNBwkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
X-Proofpoint-GUID: te1dj7qnbVaAL849rNEjwv_TyTFlt_oB
X-Proofpoint-ORIG-GUID: te1dj7qnbVaAL849rNEjwv_TyTFlt_oB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120102
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
index 6edc3db..21f862e 100644
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

