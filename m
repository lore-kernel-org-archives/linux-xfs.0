Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7246DC43461
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C6D161006
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhDPJTJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:19:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45234 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239914AbhDPJTC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:19:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99rMl037127
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ESFhEwEl+zY/uYIHjl4R9VBJBVImfapxGFD6GPtKby4=;
 b=mdm7/JeTZzCZWZixfZJYtzsdIoknlZJfZPpIgvWIejgwQg8blun3YDnZe6sEpqOzA6Gi
 I23p/GAknaQGRmNc5Sxvy4I/tBemIZRnYb3vyWKJWPmOUA5lnsjTXDnip74auLRvSTWc
 grSto9QsxqwwYy+9jcpjnP7z5SxK09+opM22CZSJIRavHmErsUsYOBE10GVqzaGAIZGN
 sXuq86a9kQkmdCSVsi/bvXcGr9NfIZAAZCbzhOvSt98Pj+ParB2OWtcDrvsdWBIf2j2d
 DLNFjlmOwTMxIwu1SigM27GGZ1hbGgJTm8XgATQbABprHx4RsVNWibTpD/tdDUdSrWxC FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37u3ymrj47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXpW077087
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 37uny2cbx1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePEzL0HCCmiMV+MQ5Fr9yNzQa3XNAYwTJhSvNtSjIDR8OtzsufrwlovqhuT8UcR+pZj/n22DlprcWuo6mMhBnCbWcpHHMT/Vb7SsfY2Dohz7g8SlGSKJ/OR2QUznG2d1KbkT+ddtYl8gY4yYXeYAz/4SH0Yd683h4NnC+Qp09DnHbBd2HbYiO0LzLUrkTbaCP7PRavmBqLOpgx/L2uMRLAPoY2PVJgjBL4F9FjRvdwXVfaEiiDd5qnI8Yfh2P5FwvxYK63ui3iUBEa1AVWFDoxfhzDSTdooWF5zFS6/LkVJGdD9ZQ3F6WwrCan6viGxoUCaEJNjiu9LhPzTtjHaf4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESFhEwEl+zY/uYIHjl4R9VBJBVImfapxGFD6GPtKby4=;
 b=IpINnvw9NQivnBv6He0mcFL/ltTE+We3ciA7kRoTq8uYw/HZmYw7faeLbEkHX7HjqPA7ycqL2YtvztVcvlksp39DYFSmpeDhtKNvWfl9RWSzd1gsPsjznJRBeA9tfYgiwFIvxA7qUSSf7WbF5NtLwJ50/g96DwoBQ0WT22ucy7r/oPUhT0nLLRmca8pRPG4SKYmeUJI6M4MqloH0wPnMIar0muuRH+ThcTcSDmJcb+yw/2GG/BS59YmgNn0scd7fAskvbYdn1CBD74sjwHN0uQp/roohKSqPcYqwIOeLp+AzlI9e/afPZQg1FKEUtX8QKyTsMSflXh1S0CXLUJ9A9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESFhEwEl+zY/uYIHjl4R9VBJBVImfapxGFD6GPtKby4=;
 b=TG4rDbXCbF6KeFd656mWtPPgoC9SgrMZbDAehS+40wJzAsYl99X3MDMf9OTTgJ9PaIH3slkoeHnxfMzmQB7wDQl8RrGDCP5oCtvY8eSZnL+NI7qytWaR5vAMigFsHvgCxMFOFXWO8/mJUfbd2ubklOAFbLe+KD+5ZaiePz/uSo4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2486.namprd10.prod.outlook.com (2603:10b6:a02:b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 16 Apr
 2021 09:18:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:18:33 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 07/12] xfsprogs: Add helper xfs_attr_node_addname_find_attr
Date:   Fri, 16 Apr 2021 02:18:09 -0700
Message-Id: <20210416091814.2041-8-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: fbcd087e-b432-4468-c7b6-08d900b89bc3
X-MS-TrafficTypeDiagnostic: BYAPR10MB2486:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2486BDA5952AF0F51C6E1F52954C9@BYAPR10MB2486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GBkLdwFpA48+lJBLtKaAxdGG04qIgzHzwlGg+RbHR9FODe3VYRiAvAFp8rWpR43U4kYKBL5d5tG1RkYg98RxkF/g/ZD9ZvQqlGjpQg3PfPdng8SLp5U+pRcotN4q782q8Jb0u9AsRNrloagifK2TuIhfDQSbqm64shn1ih4NW/GqExVFXdqygllDbE/q1K66XXs8yJKI4qLcC66jHS8vrvIGUFd9NT1TpwrumlnL0gd9cWkwjhWHAZW9PRpxUlshtgdRkQzgH+gCwPrGd37xXAiXKDSjSFcp1J4y3vrgvmBzv7PILD6RciBV2P5rwAI77vsG2BXbdaGeRa3laKN2pF8A+5pFU6LD5PY2TRuI77vBxBe8pD+NwS1KbKBQNzl2DU233TuptoDPtO3fIoL28NuhF0xPflr2YsnOpqn3Tudg3hgbfo/ApO2fTfyMU0ryNYi0NUpToBL3w+wHLR5EM4rRcCwsGELIjNsnrYY4rFs0R+BVMOTIHBYftk5SgJfui78PHdN0cfS7rec1pb8Lm14NF/ip7Vs5oXQTQu1u2Ph8rh5TeDVl4QXjr5/haNf7VeZW9g/HfTocBErt9ftaFpOwu3wqaxpfs1YRKwu34qpJU7pL2WRo6nQkDnSAXnmnR4jOgJgBdgPtxiFgWEeVMTm1ODmgGKrWEb9H0LMuoup3wm+acgSyPoGyG9zTVi4H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(136003)(39860400002)(346002)(8676002)(36756003)(8936002)(38100700002)(508600001)(38350700002)(6486002)(66556008)(66946007)(66476007)(956004)(52116002)(6506007)(6512007)(316002)(86362001)(44832011)(83380400001)(1076003)(26005)(2906002)(6916009)(6666004)(16526019)(186003)(69590400012)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aHVYSWCLRSJCmSAqsC8O6MDH7LBcR064y269YkUoVcC5NSpAfLEWZWy+c0fS?=
 =?us-ascii?Q?MdGbO34ED1m6BviuOqf0BbRe/FrsGGEb3TVIqpQgv0fyAk9Nigv/v495eylQ?=
 =?us-ascii?Q?6Ie03MuekynNmhJ18zE7RoxDjPHHziQiJEe+/AqgmbnPfPryt4TW5SVhy+0p?=
 =?us-ascii?Q?xLd2nnUuLPPgAp2qZiZ49xmnXUMeCvDVVEpcPewGmz09rTE+hfw7wVVuC+jA?=
 =?us-ascii?Q?KJ05hv5A//QTkK6TYRMJJWcvCArgCgnPG51KdaCSl5YLde9H23jkmuAxMAWp?=
 =?us-ascii?Q?oquXNRAN6026/DnZuKtjO9N8p/gdSH+KJaAKrq4b3cTmoS4rWjyAsNP1MPyn?=
 =?us-ascii?Q?FXNHe7oG2+92IDxcaA0V7qz0qwkWBaBiGmT1lkDjVpt8ExscggUiTpNLciAk?=
 =?us-ascii?Q?0YHqezygDo7DedKgz+cx5M9Ze14an4bKWBRYi+K0C4kMza3LiyO7Gqus3iGo?=
 =?us-ascii?Q?5XescmPGSQQBLtxCLcIAbH1vgYK/nv45KZrJj54DcmqYxBTpxPaDpwHM0vOe?=
 =?us-ascii?Q?t5V3kXPkBRFCiJ6x3wBXDFB+hHIHO3H/ya1kC5BoLIFIWblXbI5NnbqpR+m9?=
 =?us-ascii?Q?a9Ms6tywXJ4I3LRDsgc5Xg1pxN1EFvdhyOgmRsO9A9TlnkhJZhaLFiBmoGWL?=
 =?us-ascii?Q?Z5LjcYASRoA+6mzDU4b7UYQmdaxX8PENTRxTte68XNS3sD5WEDOJVh0bDVSb?=
 =?us-ascii?Q?MRiQafFhdL43eb+8LXmzjwF+J1C/sETAdGHvFofknEVKFg20EA7GHnA510T8?=
 =?us-ascii?Q?YgEoo+tJUHX/iP8F5ABiWcg4RrcpVDAVhcbAt8w+mWd1gjTDQhh55LRoFplO?=
 =?us-ascii?Q?OMUUTaecuR7TyynK8/l9dVK5+LlC2CiY8u/bbaV0OzrYw8d1fSAKn8uE22i5?=
 =?us-ascii?Q?EpFPDNQ8ed0yQ+WL8lE5MgJj3ns5//R7MJfUbVWFPjlTWN16keMifMDI58Em?=
 =?us-ascii?Q?s/Q5FnC3XoKtuMbxDeVjJ7zxSpszHPhW1zFFTw/eSJc169OZVjgCfxTPrOtu?=
 =?us-ascii?Q?YLVbLXN6J4zbgIxYx/xvlp2nWmUY+5nbTGrb4xx/ypLnpGkrDsYttIsasS+H?=
 =?us-ascii?Q?JNQRy1uSEsMz2WKAhwUaIey5RnreNZEMEIc/lLc6wj0JoPECI+ayLZIRw+Po?=
 =?us-ascii?Q?foNiqucgt91aEazS0WQAYPpy8vbuSz6zpGba8xzO6GVz2Zal4PWkQphwWxw6?=
 =?us-ascii?Q?xBPyrWswEwh1z4kxI0W78MZ7vkIp9HvU0Hk1eQAg+PeV/fiOm4/gYgwe/S1m?=
 =?us-ascii?Q?+ZMeaEzks3lyJI758B/HeNO7fmCLEMAYrB4UstUjd8GFF4C9LxJRTfqEvKsD?=
 =?us-ascii?Q?e/HlVXyVe/0k08Xmf1AHZCl9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbcd087e-b432-4468-c7b6-08d900b89bc3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:18:33.8151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNnIXrNnVsSxhjCAH3/jVuUiikwIT7E2UQ0jx/po1LpGtI3d49RGxOEpmix9ZLB/pvUNOzMb8+eer1ifeGeg+smJzs0wPMxBwaraxmt0oFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2486
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-GUID: Ydqyp3qfkGlsmZGRh92d5by88X-8MffI
X-Proofpoint-ORIG-GUID: Ydqyp3qfkGlsmZGRh92d5by88X-8MffI
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 1aeec98c3f70bff14cc0e65ef898e91c2c554d41

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
 libxfs/xfs_attr.c | 86 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 32 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 3666c6c..82b6c19 100644
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
@@ -885,47 +896,26 @@ xfs_attr_node_hasname(
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
 
@@ -943,6 +933,38 @@ restart:
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
@@ -968,7 +990,7 @@ restart:
 			if (error)
 				goto out;
 
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
-- 
2.7.4

