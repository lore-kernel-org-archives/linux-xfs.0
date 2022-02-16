Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0DFC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245531AbiBPBhr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245525AbiBPBhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2F619C29
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:35 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FN8ikr028773
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=yluYH/y/nDVVHizcZZ9R5ja+IfwuIadclopKpGEkWOg=;
 b=cktDmsZbBFgoeF8qR15iL2/UNx7/fKDZ/Pdi9mzJuGm2zIrTPINfniMo0GYwIlTK2RAu
 2touCKAsXwcZUJ7+4nvhfr2ZIorn2DZgmNtJbgz5Za/OQ3uK05CzawM9kcmwZGBcVtqo
 OR3XrysvptUhfgqA29TSON/ABYnqGhaeNkHT+eg5w7HLY/900xhnGkatyYnzuB6GBti3
 g6Q8W9+P13E+mgS1wMSK6OuCOPK+x176wZ37gGu7siF/ZEiEB8f8gzW3e55RZa+8bYNB
 MErBUoajxaA6w4BuvcQafzIUd0HMypHnuLM0fUT/kCZ5yv44BIKlXhvdjrqcpA/durfk Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nkdg6kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1VQ5W138923
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3030.oracle.com with ESMTP id 3e8nkxj2tr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NplVZuqduAlP3a+g2BgmIx9uoY2H28iMDQ0KRS4/R1D8M/uZoAkobKwxApKC3ba8PQUM1KinTsTfpuuo9jqB6y/JQCBkXEMCL2sUJ19F8JAuPTe7uiz2LZuzxccewduQMermoAqZuxYr0RGebpGNFR1mnvpfRaE8Knma8TJ9Am3nfhOuhEGpAYpVrKKcN/8ELq8TvwvFgzGFUtMe8LBCZmisPxTQcRcRGXW4bt2DEsah9VUetXTceX26cln9c7tde0WQ82/Qrp9hToC3BVz3DINXXVaP0Oonkve9PjumSIi5QMgTtGRUKkebPKV1cygzIV8w00b/+upL3nzoGY11Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yluYH/y/nDVVHizcZZ9R5ja+IfwuIadclopKpGEkWOg=;
 b=VpN4i3lod5a/5iyAZDhLGonsG7WGchHe0uWUjw60zgYC4nRN/MtVsc7BD+sZUhxTJXHQYKXw1TgHd8GHWYUKJKoToBZqEut/W0UwhGbdVsMFQXii9Zyf+P6hEvh8yJAoAFEfMFGemjoV1SmoVoG5rdk9XD0nQdWg+rQwVHeXEWrfJxb14zXGMLculvP9QqTOHy7IW0iAWTSTovVatoQdcK7EcnBHyNj8pfS2ZJnrkg+kc41Wzns2O3TX4kN1y72IYDe2pv+u9xHfLshuIeb/FDxURUd9Usgad76XQypoBo3ttyP9RpNeG+rGM7W1CoSXJzepBLnUJ/vf3/uP/abz8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yluYH/y/nDVVHizcZZ9R5ja+IfwuIadclopKpGEkWOg=;
 b=FMMsPhJZrk+QRSHqytC5xLRIvnocNK+ZM4PbS5++yRGYajR7o7E3zDHfu05vgwc71uGiATamVUyAybOLhtIN+dSy/JMtRXkdiwrvKIvi37GTAt2J1M1L3CzItNap1C16FJMfaKhcwBnhnUNcB2XKGujVG5oSGAcFtx5KIKfm0Hw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB2802.namprd10.prod.outlook.com (2603:10b6:208:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 01:37:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 12/15] xfs: Add helper function xfs_attr_leaf_addname
Date:   Tue, 15 Feb 2022 18:37:10 -0700
Message-Id: <20220216013713.1191082-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216013713.1191082-1-allison.henderson@oracle.com>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6644ee7d-54a6-4f24-f070-08d9f0ece1db
X-MS-TrafficTypeDiagnostic: BL0PR10MB2802:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2802FC31B02348877D127CF695359@BL0PR10MB2802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: he4/DPGWrgkoEdJzGfT/I379dQkKb4/6gp9qpaw1ElhzGrVmZhhmyo+KGm73mqhdQpUThfmGTrar3VSJ15v1ek8eteikJr3fwAAcK8M6jg1YUe0SzxUZaUqKn0pNcunMwo/2Fw8iaaV1innaXEwkgiaopBHbM9LABp0WvzkOrhAVSZnfLZQdhnyCFCfyXTP8A7gmf5npAwvJ6ywbZypH35YUgj/dptjmZGkcz6GtSQcwKoqgwjCrrmLRtoDfGZ5ChkglDcntd7qLzadB0R6x3fBcIxw9jKoX+6nYO3RSnebZDwfP28fxwfUCuDhOVD4FnEsu+Er4xUki4j88Fr+kGUNK0+bLCJCwH3MVC8znvBKrpLIOCRlYg0F8KMTTDCmcYGAfFFaPKTBYf6eOwY9TCWS+/O4+prLMsEKtDp+/+k5o3gNbnFYHR1ICTJXgsv70lJYXMF1M1XDrH44a2RnJFBzOg8frq3j587ttthG3efQvSIV//M9z4jke1lRxrIdyjlcfJ1HFztdKmzvB/6plTexe7gMs1bvIJJLZd5gaQAQqIxD+vis7Zzzp08VrejzzDVAU+qy4+eEmtgMs+xpL8qVNdQoXfudwalidhOeyvnxrCjr0pevWjS42lnPNrlBgL9bfujBekvFbOshbb6sIwDNHQo9Ss23j1XeMOrM+m2I9PgMe36kbgq5Tb2j92W6KHTN/BD2LhiYOsxAJD558OQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(26005)(1076003)(6512007)(508600001)(2616005)(6666004)(66946007)(5660300002)(44832011)(38350700002)(38100700002)(6916009)(6486002)(66476007)(52116002)(36756003)(316002)(8936002)(86362001)(2906002)(8676002)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LlygHyTyUVlwabgo/PAnYGOkIxiOGajQMT+oUUDhboXRuzC9QJySZpWWS94q?=
 =?us-ascii?Q?V0TcEW3LjM/Rv8H/LilWz+VK05e/r19C7tYk1hQKXZDykIES5cMbmL2lVvoT?=
 =?us-ascii?Q?1VObqKorIE4tMSCQTYdcsZkZ1cAGcBdzd/c+nRryNpxtFT5HM0aRztSt6pFo?=
 =?us-ascii?Q?KzuIjrjgXrEz8sMfOp3yqmFy6Fuw2xAoCHRx8aQU2TalZhhWXXI4ZF367oVZ?=
 =?us-ascii?Q?MtChZsBvSvu1cLiAshOrPJYhMYZ3jbq4JZyjWryZZ0gvyL8B9tcEvGcPviA5?=
 =?us-ascii?Q?bSJUqMD7pbcqnAGE1ucZdWpSELpAutPBIhHe3eM9a0hq3JlnJiNRLn7BvWCJ?=
 =?us-ascii?Q?CvMm/FFrybPJ3D4Bi46UADOTsTdx2mOITATrghhskKML/bPdOfqxInm3i3Ej?=
 =?us-ascii?Q?HiUvzpxhZYttADXztK+67JQbo/S3+jhe52O6SsvjxUhofoxnzMp0gjSRppje?=
 =?us-ascii?Q?R6GxtaBqoTZchOjlnuoUHdhhtUgyDRFuBjrjvliqkuiaDFTGrfHqoXEni1/n?=
 =?us-ascii?Q?XrFkEJcL1ppwoZE7m1sS7sj4D5GD/5S16xROj/+BW59edL/0OLU8dnw08Cze?=
 =?us-ascii?Q?GTDp6JU6x1tZgL0IbDqPjt6ZL3b5NeC7uPoIf5YU+G10T2RQLrbtSqxxzS03?=
 =?us-ascii?Q?12thCzrDZmnrYYcLKxWq35gtvb3gzbYCdxgM+42tpMXsvTUqRfKX6TqNlY0L?=
 =?us-ascii?Q?BXXRALaz+sMnOmHzlV8tujnVxBcX19F8jKAcrDgyxl9PRF2G5R3R8X0th6FT?=
 =?us-ascii?Q?qw+6cqgogpnD+kW33ox9CQjxb4wQkSDsuo/Sjg5o2mUVHjXiGWwAnfubIGYa?=
 =?us-ascii?Q?5H8CMe1KxAv7jpjIOw2zn7SwAp5R0/aaO7JZmbjyfWP6LU9Hz1w35t3obSMR?=
 =?us-ascii?Q?b3Lg2n99uAsmAvya8ieAn0F+FS0Rch8TWQym3hgJYrs30mRQE4W3cSnT1dUc?=
 =?us-ascii?Q?iBH/Zug6AAmVTVRih1XHq/0FgwWpcqawR+442mZXaQjJb1XFQ1HSuFoR4lGB?=
 =?us-ascii?Q?T29BA62Jer6YEPA7UnnSHDKAKb4XhqtA/gMXuGLgQvhqPmp4WkiDfCOMds8F?=
 =?us-ascii?Q?Z9UOxSxmQNTnu+G3Gy9ikLJ7oJyHZSddt1y5HFMmgUqC3Xvryftus18f0sWP?=
 =?us-ascii?Q?/k+e9EySiHSKkYZBQfpyZSjPxtCuoIViIxayllRtkA7H6R9rVRBKXZap23p9?=
 =?us-ascii?Q?DPqfayUBhyK3OSUpBWoxDKMhgwycAF93q8y7P8nTK7wxbwS+dKZ5UHYLmjcc?=
 =?us-ascii?Q?ARdyEm938zaJ6e4zk/hA5/BD8BG5zOyK+aXd104ZcgvtxDHf6RKw4tAc5/rG?=
 =?us-ascii?Q?tGqV0NS2qt0ZRV2GGznXaqM8iOLH3CdB9YcF03ranYd7RGOBPd04JH8msQFM?=
 =?us-ascii?Q?dyJCMNfZuhIpTp9nYNx+kGho9Q38D7fI9POdE7ytHp9khFcv6eMx95+19QQn?=
 =?us-ascii?Q?qpzQOWK82leMjl9lhWbMfUwcFd+1lCrNDg9TZQ3nhNDVyytsTNhn4Ez99xfc?=
 =?us-ascii?Q?+5KUFyM6vZ+qjkP/6LWAohf9Z/Q68ShOngmFcxxpEkDa0GQ0nL8okeNfRuV1?=
 =?us-ascii?Q?qvddKTnaTMArXn6WTeES78lrG7SEi8ZLAUMfbyrnMbfQw6Gt9TgJZxk4BowP?=
 =?us-ascii?Q?in9XpiaI36OPryPW9ZhgdAjRNVzhF2RV2znnbi98yNsH/+Y7CJUakK/LZqiW?=
 =?us-ascii?Q?zlnivw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6644ee7d-54a6-4f24-f070-08d9f0ece1db
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:24.2496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cKC4zjFFTs5ZURF8yZlTIQrIdckhh86xRewoC83+2cRu3nPGd0X3fLFbl6X/L3ORsVScUNTN4gGiMMgtB1tvLWWawGrmi06ZDwHo8hgNOng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2802
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-ORIG-GUID: un68w1TLD3aDgw0wAQGguyuu8LH5EVlN
X-Proofpoint-GUID: un68w1TLD3aDgw0wAQGguyuu8LH5EVlN
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
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 110 +++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h       |   1 +
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1b1aa3079469..7d6ad1d0e10b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -287,6 +287,65 @@ xfs_attr_sf_addname(
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
@@ -322,57 +381,8 @@ xfs_attr_set_iter(
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
index 4a8076ef8cb4..aa80f02b4459 100644
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

