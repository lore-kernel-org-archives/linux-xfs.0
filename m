Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2F4C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215C86128A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhHXWpl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 18:45:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51930 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230506AbhHXWpk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 18:45:40 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OLKH1k021196
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=HBfdz4ihB0iDtd2wOQAcDOXCt6f5arWP6TdO132htxM=;
 b=Pbk/URS2QddDhqueXAxW0evC+Qy7+hkb1czsgp4lzcBMjNH+EPBRxLkUlJkGSSgduuOa
 DwE8wdaTPAeb3iAhib/xVjLZmw02mJLEuE6UZn0dCf3b+LuwLASWW8sfuA3UuNjgh1Kl
 B7bJFF1igegbmkoXdg1WyEs9xTZzRytYQH0DQfHLEbgb9MQDxqKX0UbXv+V6/iV+uHEo
 who6ly2YzHJ+IGEWHrB3w9o8bc2n1Ks2dUohHxKulVz5Z+TN0AFM1EvOA+n+ESspCkCs
 T2ibA1xwzxbxWI++ELgDoT8FvxMz09No+zvKBsAdQBUBp8r8/w99mPfMjb7187rt6Zen VQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=HBfdz4ihB0iDtd2wOQAcDOXCt6f5arWP6TdO132htxM=;
 b=TlZgrCtiOnkziJgnhJJSMLKeY/95v2ubD1VmSAE0RpXBc+UvG6gYKNnNfI3bxz1OsR9h
 /whzWY20H9xbasAOJnNixFmi4DYHg0XqX3hl+ct+q5U/UJ1dArgKGVwd1dc6iCI6B62U
 uXmOPF43+zBFWUbkN7hPvtWvAQdn06Gg9fpKMIdec76+//CPPKKHzKu6ab3nM1LRsT//
 VXn4nUoNa5UZlN3I+JZoiKg1kpfENQUt9ymiyCipBfxyac1fruWeAnv1wKybAOvgVXU6
 Wk+p7zF1G7ey+QAxqySVI3SBBbEF4QgKx2ekB3KOlmoNEuSOpBcB/344ctrBWPFDXyYe 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amwmva069-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMfYQC025324
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3ajpky4yms-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIC0oEFmOp587qR3GIZ6BRxegXjGQNDH6RChNKIzAsgWVPx529sEICoqOQOYPejH6C41cSxIt86hONDluz2lKzQrbHCbXRGV/hOJ7UPxen4Jyr31HvmGZdY+kCGqhztT/IUZID4bKaox9KUNPjrHjnFay3NQmeJq0Vj39cUUZ3yT41TT3/FRfQ9IlRPSwf5fRNlqPbd1miA9+vgIT8GEeM5KUsdIgGL2cBA8ai+V1m6J2kFDhgpKUWyRElak/yGzxlS8RtOzdi5dRGol5mu67lBA202xelE/bRhM68gvjl0TfciEE9KbfBMeKFxdrRB0SRAjGVjVwdhLQjlqAtVX+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBfdz4ihB0iDtd2wOQAcDOXCt6f5arWP6TdO132htxM=;
 b=OsGDbJ/EicibHE/c8nj2R4/9tZ5+QjtBdyLkWz1oxBR3tpt7Riv8kL5In5y9ofHQW8vbmci3xtEEU7IVOjPOnnqToFxjd8m72TT7G4Lb6NzX75DgAz8zfxAo04iOXocAU14CdqtCnJzufLGBx8pfNWOoENy1rweRvh2qGd5YoNFgzL2XBloLVeP3iy9xWeAUkbVvrAjYhbPFjfN/6IDRD+pDXDNoqW/nqiZ0ZOjy0tihgXhTLSafmQbk59j28DIBQWUmNdoTJE0+50P7x4hejNOrj2aXoBirtXskqp9tk+qsum98xbEuiKj3t/BH2boPk8xpV++FRNHmFkkDQL5f2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBfdz4ihB0iDtd2wOQAcDOXCt6f5arWP6TdO132htxM=;
 b=mVwwkIVfB3jxRWXbDsMv3KxvtsPFXDfkNdiY60T5kURUPfeblNJGfo40vaodrK7WSVpzzsHP5uTsTfpg1tDdYVJ0yfoXm6aHLz/GwIexklXVExGvH3qbdjfiXNz87D/gVNURtlElbLoEBcct9jnMskhZdIGKPJeYtMLuspbxPTI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 22:44:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:44:50 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v24 11/11] xfs: Add helper function xfs_attr_leaf_addname
Date:   Tue, 24 Aug 2021 15:44:34 -0700
Message-Id: <20210824224434.968720-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824224434.968720-1-allison.henderson@oracle.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:44:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5e5c250-ddbc-4974-16f9-08d96750c59e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB465364A189445B75C9DD111195C59@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bIEvpEbmjaAcAtewczrqsUtpw5GEYGzNIUfFw/xvJFsob2BIyciVBSaiB9yrXw7O3X2ESvqA9jEwJYc9xnvYvATM57yZaZDYIHf1Ph2+BUD5KEt5aZkr/afPFP/2Jy5fSHNZX/7f8KqdpJ3OH9X8xDx6kHa/WeA1TCd96K4C3grH3BLRn3ET2DMdf9wzDJjDRdQ/JIZ8uSjSAWWsPalCaQiMN0Xme7yGu8xc4M14nq1Un8RC3wh7dA155sFAFP6t+mOr+Ak2aCw5FCYAiF+wZZkr9uc4c8ECQMdD3698ZZnuMSVsaQQHTtBiPoSMqiu306eVZ80JGXecr2BN9kOjp7efGoaJ1CH/IW2u+Hnb7oAcLmnuni+TdarKTi0v0C1R4+b1B8GGLREetFTrjH5OWp1PSQ5Tud0qtPdBFXcAXAOaG6EZzON2kDcMAtjpG+vcfKwh+pWsJKioa7SE62pBFv4fsOm17Cta6dADeVFldeIUNhUTJiYzZVvw5/yR83vBkz3mADmFZCuBpBM4yDau3MRwP64omejjzGsMmFo1ssGLQv2IAveXgc+FlkyF0HagoPNLMcsko7Bn28qI4E6pqks8WQ9bI6gkz+c6pos+ABeiFpxb5p+eoylSBHAlJXk/v2PIn/K7R0bn/NoB0FJqbYV0jP3tJTS1RzKjknKl+OxH9oHAYX1QqzSRC9UwtYrC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(86362001)(66946007)(83380400001)(6486002)(6512007)(2906002)(52116002)(186003)(6506007)(66556008)(508600001)(8676002)(316002)(956004)(8936002)(36756003)(26005)(44832011)(5660300002)(2616005)(38100700002)(38350700002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KKAwkqodEc8wIChdYXmvtmMg2ZLxF/mhdVMVdajvvg27bYL1yINQAWwi7dIH?=
 =?us-ascii?Q?lXti+TDIEXf+9GFYxEBGw85QOVIRBEM4GuBfajAkmSuMGSYMhdbKgGIguII2?=
 =?us-ascii?Q?cXk2L2hfwcUKtHGhu8DH4BhPIYZj4V/w7/jMja4Yaq2WCND2nYDlpRyKa1/0?=
 =?us-ascii?Q?NRdGA8L7ujcpCgJHkK+w1KaDz2O2bXUj7EbG8U0NW3s2neJ+vjLwgpxgTf7L?=
 =?us-ascii?Q?EwLn9NZYtU4VGqg7bMiAaLPkm0LG8XSOu7gNGTLjzo1tdRfmsIy+5EP6aD+g?=
 =?us-ascii?Q?fxotuEh5xuCDrY4EbhwHCXEszU7SCXL3DVab+I62e9Dg2RE8iuV2VYkrwm5E?=
 =?us-ascii?Q?RV7/bF0tgSb7FE79wkBZvx4J2Y1RikDmunLXqpbs3S8u8Y3NSY/HejNeSFNX?=
 =?us-ascii?Q?dDcNgUR0aSsinJ2Rela0FGAU6ypcrCNbC6D8Fb4gec5P7HZr5+g0ssX6N3b0?=
 =?us-ascii?Q?nvacs5X7icJIi85QvCPUj2p2d7kB3MTmsAdq93N90F+CDTw8LoDfxQf54P5P?=
 =?us-ascii?Q?GbckB4Es/TS9M398Q4CaTIazCKTlzIy71du8gTJ6mDzmG7jMKlyCywdVRKC6?=
 =?us-ascii?Q?YGnQtxKD0ZvEh9+XILrb1sEBqQMY8hDay0cAAd2AwhwGaZJAYF9qwLzewJRE?=
 =?us-ascii?Q?DXqFYA8LzOTv4SVdRNN7cTxbbdJCHCDuYS7NvlvGd48lkbxWblWmQ+yLwdep?=
 =?us-ascii?Q?Zo8if80G6Ot5ZG5o4wjLheyrdDzAgLgqhtQ5hnFiGmWQHDbe+KPbRPWUjzeu?=
 =?us-ascii?Q?80gxqk/KkHcv1uhYjlOLwDgK0yM5vFzNMKEJq03l1JDXWjLnjgAgyTKuj+Ct?=
 =?us-ascii?Q?8f9OsH7Nn526jbDCk9OeGnqYa1yJOxQYsrbI56UWV6M+bkj5UHRdtbVD4lnz?=
 =?us-ascii?Q?KQayeHF+jk5yj7d/m5E9y3hAr28+gAGXyWRM9NGnGziEKwPcKk4Re3PcgEyu?=
 =?us-ascii?Q?ynMwGKMvNwNaju8iD3+vYY+M5XHADSIZGqIXhkCJVfT7f0VXITG2e/O1Q8EP?=
 =?us-ascii?Q?j6iI8aO8Y1a6lyarzgiOfSlC/ZeYsudg367Oud18Zz9mwoy6UXu4/YCuEHD2?=
 =?us-ascii?Q?/JYLtFL0Lncvtr2yaw28K+xk3zH0ASSlmNYiADzvq+/RhxhbBAO/LJnqfngW?=
 =?us-ascii?Q?3NC/u2L0xyvN7CLazO+cfst0Gq2FEHAHo54DBu+19aF91dFzoi3VICMV8vHF?=
 =?us-ascii?Q?NapRCxkxckjFis/1k1gnTWCHuInkjZwKY1AEfJm4YrEFh1UaueXuCNj7Cu7m?=
 =?us-ascii?Q?9CxhTtqhdZ99Sp9FylKPU7cMEoBZxSSwxKfBmydVMUuQrddDYXjiSjhSlHOM?=
 =?us-ascii?Q?4ECdouQOVjY/uWn7l6wiNR69?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e5c250-ddbc-4974-16f9-08d96750c59e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:44:46.1974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQg9opeKo0M/wmfhOU4jC/D0ptMKlAFQDNRhWiIAvxdS7/HbfbOWUYtf7ADT3/me/tjqAyTshcGG6gYFjHS/G4Wvszk5fCt8bXLeqvgpy0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240141
X-Proofpoint-GUID: 7M8kRxsiwyDFqa_lnVmXIHG76h7mpOqY
X-Proofpoint-ORIG-GUID: 7M8kRxsiwyDFqa_lnVmXIHG76h7mpOqY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_leaf_addname.  While this
does help to break down xfs_attr_set_iter, it does also hoist out some
of the state management.  This patch has been moved to the end of the
clean up series for further discussion.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 110 +++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h       |   1 +
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c3fdf232cd51..7150f0e051a0 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -284,6 +284,65 @@ xfs_attr_sf_addname(
 	return -EAGAIN;
 }
 
+STATIC int
+xfs_attr_leaf_addname(
+	struct xfs_attr_item	*attr)
+{
+	struct xfs_da_args	*args = attr->xattri_da_args;
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	if (xfs_attr_is_leaf(dp)) {
+		error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
+		if (error == -ENOSPC) {
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the
+			 * transaction once more.  The goal here is to call
+			 * node_addname with the inode and transaction in the
+			 * same state (inode locked and joined, transaction
+			 * clean) no matter how we got to this step.
+			 *
+			 * At this point, we are still in XFS_DAS_UNINIT, but
+			 * when we come back, we'll be a node, so we'll fall
+			 * down into the node handling code below
+			 */
+			trace_xfs_attr_set_iter_return(
+				attr->xattri_dela_state, args->dp);
+			return -EAGAIN;
+		}
+
+		if (error)
+			return error;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+	} else {
+		error = xfs_attr_node_addname_find_attr(attr);
+		if (error)
+			return error;
+
+		error = xfs_attr_node_addname(attr);
+		if (error)
+			return error;
+
+		/*
+		 * If addname was successful, and we dont need to alloc or
+		 * remove anymore blks, we're done.
+		 */
+		if (!args->rmtblkno &&
+		    !(args->op_flags & XFS_DA_OP_RENAME))
+			return 0;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	}
+
+	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  * This routine is meant to function as a delayed operation, and may return
@@ -319,57 +378,8 @@ xfs_attr_set_iter(
 			attr->xattri_leaf_bp = NULL;
 		}
 
-		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args,
-						      attr->xattri_leaf_bp);
-			if (error == -ENOSPC) {
-				error = xfs_attr3_leaf_to_node(args);
-				if (error)
-					return error;
-
-				/*
-				 * Finish any deferred work items and roll the
-				 * transaction once more.  The goal here is to
-				 * call node_addname with the inode and
-				 * transaction in the same state (inode locked
-				 * and joined, transaction clean) no matter how
-				 * we got to this step.
-				 *
-				 * At this point, we are still in
-				 * XFS_DAS_UNINIT, but when we come back, we'll
-				 * be a node, so we'll fall down into the node
-				 * handling code below
-				 */
-				trace_xfs_attr_set_iter_return(
-					attr->xattri_dela_state, args->dp);
-				return -EAGAIN;
-			} else if (error) {
-				return error;
-			}
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
-		} else {
-			error = xfs_attr_node_addname_find_attr(attr);
-			if (error)
-				return error;
+		return xfs_attr_leaf_addname(attr);
 
-			error = xfs_attr_node_addname(attr);
-			if (error)
-				return error;
-
-			/*
-			 * If addname was successful, and we dont need to alloc
-			 * or remove anymore blks, we're done.
-			 */
-			if (!args->rmtblkno &&
-			    !(args->op_flags & XFS_DA_OP_RENAME))
-				return 0;
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
-		}
-		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-					       args->dp);
-		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1033a95fbf8e..77a78b5b1a29 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4132,6 +4132,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
 	TP_ARGS(das, ip))
 DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
-- 
2.25.1

