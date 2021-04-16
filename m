Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B66C43600
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03E48611AB
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239536AbhDPJVc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36538 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241673AbhDPJV3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99Iwq026159
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=GI0JxQYNq8XrA1vs6XZ7ui++AkkVB61egpSCR8z98qg=;
 b=V1P8d+jd0o11xxlsvos4kJF/YDjYeym4SvdjQJkkmp4+gnzjOc8+aPiyutRPOZ3zeqmo
 v4o1CgfY0TYyOzs1+dCD7076iz6WuAcbQGaXDcPFODX13tobzR21+o9sMsAZ6HgK0xT/
 bp+TNr1g8VIXXQNl9IFPcixVkwUmB4IlmelQCgumuL5J5iTdYavNqKx960eT3r+I/3Uc
 eb/wZnkf32tF6/ONPBxGL606gQwT+i3HE8Lfz53x5Fv2SYozhMjnn/UQ4gsar62KJx3T
 5CupV97WglrCdNkuMOIEQ1RyyFY1eN4V/KV2JIQIRB00umzMAmMtgDXXzdKydgZm9msh TQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nnrher-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXT6077147
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37uny2cegt-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8HCWbOXXR6hm48ehFalf6OeD3c7W/QV/BC31yr62u/3gfACCWgplq729ZM6O506qqEzGr+0thdICDvtacwlkInp/VQy0DtVta/i2kiuIzc7Aw8hNhRznMEKQ5Enl0ahuFI6SghkiaLbciqOR/ukViyxXtkPQ29wotn0s5iuPHLHR2COqe+6mDSt/tGaly++0S1xwl4F8y+IZsouIahj4Onzr8sm6geJWKGkPdm9H290W5c/Ywm0IwWxlIiBbwucvBZXr4ZMNgn+vc9z6b0zLVhQNpLBUU4eOZ+qp+q5ssfF4RmlNSJkxc4oQcOWo49xRlPRVHpJAo6IaCPjhkQt8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GI0JxQYNq8XrA1vs6XZ7ui++AkkVB61egpSCR8z98qg=;
 b=MrgpsGXS6ulsSyxw3JmILB7iSiGf3nLuvzXDUTlTQ21mVQeOmNV9jc/kOSShvH2eGGXNy61dQP5K4lZBI0yPKyZhiF65gUGjqnCWe2h74ltdpy9lW6G7LJiTP+cpmnS01k6SlUeqaJ/zLeFOxTDthK/50c0CxXaAdgHWybgzJ73uPCz15KABK76ya+3uqbl2iY/azsmzfpbGM6tkK+NFn3YIxx00ZDYmXikVnmJ2tmgjD3XAWIMkt+f0oT4+SKrS51ETM844gPdcikTCzgRiRR0W04x2SiZrlpGy72oqtT51yYXWoSiSz2qB2+IkSHzFr7M8ee20bwNEgGWqUax9uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GI0JxQYNq8XrA1vs6XZ7ui++AkkVB61egpSCR8z98qg=;
 b=QNW+ckRL8QMJl69xWBpPU93DnT2YYwGz8SnEJ+X6RSnl5Uy8bGtV5FF5Aeo74ASOvrv/6e1cWMLwDz96Ke5m058Bk2sJ4uRWGYCLO4t44GbzT8MU/GMUNh/khIXIYvJ2XOqYxUCKjwfOud+f3eWF4260E+r4P21E3fM/Dg62qFk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2567.namprd10.prod.outlook.com (2603:10b6:a02:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 16 Apr
 2021 09:21:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:21:00 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 08/11] xfs: Hoist xfs_attr_leaf_addname
Date:   Fri, 16 Apr 2021 02:20:42 -0700
Message-Id: <20210416092045.2215-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416092045.2215-1-allison.henderson@oracle.com>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:21:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb59cc05-aaaf-4672-bd51-08d900b8f31f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2567:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2567079D149A3B5E4139BABF954C9@BYAPR10MB2567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EexGKhzaF8koJ0hqcUB/QSqkalXyGRZC3QWgBgPLR6epjapwMaam32pfzvBHB0LrT/v4y5LhilwnU1xjHxh0Of6EJG/iIrQ+QJ/2+bavfDsWkCIr9rrZsOVaG5FnacbylQh+ww1JdYKHVWu3J/NkPwHbrQZ3//EA/jsiJQ1ETHnFhb0wZgK+HjNGyDk2PK6fWhody78Iq6gshHApozCAMQOYPjG2G0qFApw+3YRWp6oLemo6ehNfQGBszQufFQwnoHdRLiCtjakv+Y/rKW7Yrr1+V02GnnqGC6PIPdDk4iIxI0UUHNRNLCIHIWENNiI9paVTd+PbP11QTeJfz5MwmJffJGnqd55YwcDLGJu30t5BZaMdgAk83SzpbGSZ72JSwqCjf8iTloU/QyV+WF9NGYFL2w82mk9Sm0Hz7oJ9O6VsgHKrKXYa4WH/O0E3QrocimNQgrtbRESum6SSZcfFbShq26We7koyNVqG4k6cMu4xil1HlEMS1MrfBWPvP7AYTChSIaBLFaXVm7qghetTY9cA1KC7DANZD52TNJx2Euskbtr1HuMnbyPmVkPmDlKXYHYcG773f4Cvbrrq8WTaZTzJgx/6hfZ6uj+EH2es30nQV1lovUB8B771SAiWD5tftxhDap4khSOjMzk1lpq7WAIkIBmlIcTFMHT2ojwQHXE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(16526019)(8676002)(36756003)(44832011)(8936002)(38350700002)(52116002)(6666004)(69590400012)(83380400001)(2616005)(86362001)(66556008)(26005)(6512007)(6486002)(316002)(186003)(2906002)(1076003)(38100700002)(6506007)(66476007)(6916009)(5660300002)(956004)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?d14suktAhpLJJrFnD+F2IBFQBfROxomJUVM/wNerf1QNnpZmLf8XWZNUwsz2?=
 =?us-ascii?Q?+dBUDJN+N1vnOgCwWSrU45gX5qLXTgYTUsNtOr0yOS72EOuCTwYtCBUO8VRO?=
 =?us-ascii?Q?NqKCeLv7TtJdbiMnXv3pod6lfZVYKOgCDAtY/DzRjVTK4pagD/l0AOfzNuYr?=
 =?us-ascii?Q?NxsoQdbJAaeEeUuvw7sFt2ZPcPYvI5vfKl/++Tr81IfmRWl6F1z9hzOhhOnM?=
 =?us-ascii?Q?OeSL+1d1zLoYCN5BRLUyZj8OJAXPDiBCNMn3B4/kxA5kyiYNPQdI2MZMd7Cu?=
 =?us-ascii?Q?HZNqyIbBWjTMTrqSR7HwzpCFxkvVKDo5ibEheVdk1SPcfW/zKcE2dbvcRWHp?=
 =?us-ascii?Q?k6iaFZLYDA1zBqmjHeT5w/BK11WVLqBi1Qv47pm/u1/g/viuKsFLcWKrKJpN?=
 =?us-ascii?Q?AmXOS/+d9bOGsT6wlWHFyxwCIGBI/NAUERCWkuwGCqFg1AMRRmca6Z/MT5O1?=
 =?us-ascii?Q?ugtKb0ZSgkDL4G7GuwvVJ1nB9SsRWFxobil9Rv5Bu7/IrYsjxMPDdau4hAfX?=
 =?us-ascii?Q?o6ucoC1dHVLpKSno0i0sXwCqXu0DZmtbX35ggbd5ii1yaRdcf8GlXEjiQi7v?=
 =?us-ascii?Q?Vql1ifHkoJ2aVsFASxe8NHw6b7Fdm1ncquL38PTRnOtxshDuez73e0nyKaub?=
 =?us-ascii?Q?Ho72xlChK8QMig60uQ+UvSMKrwkZiv7aoUWUuTGaUsEWC86MmtpWYR153vjZ?=
 =?us-ascii?Q?Ygei4+ahStvo6WM/efw0Eckkq4L4qU851LJrQ27J61zWaQzdbNamgW3gYhQ+?=
 =?us-ascii?Q?VAMrKUckEUmtSXjI1hzB3mlDVhiXEJQK/jUcaE5qlVqJkr0rYxrE0JSlFONg?=
 =?us-ascii?Q?kErUSW7RAugzHhfnoTvCtsUPSfHZCLv6v0q7fibZ9TeM/yYQOsNiMG0y4ED0?=
 =?us-ascii?Q?RDSqSAMrN1cH/8jm3Rg7zOem6IDe8FUCYPo680SfoNjt6pkqtYvGd63zFbU7?=
 =?us-ascii?Q?oqTOHqUVTPQqLU7MwvEpERMpiItNl6moAiQVvvhZ6NsvxK69JS0zqf6vpoyz?=
 =?us-ascii?Q?KZCTq0N3TbYnF38+KtMC/xMfTfonRlFd2ksmJlV0v3G9ObYnX8tYzf+aGS49?=
 =?us-ascii?Q?9V2p5G7VQW67Gpm6wiA7kh1t7U7kdru02RMEybyXBsMvkcF/FxfnKTxXxlho?=
 =?us-ascii?Q?PKhGevu1WVvD0YeIAyvLgLbdoLWKXDo9hGLkl4A88DPUeNU70vm7i7MoU8ZP?=
 =?us-ascii?Q?hi6NEtofu00QwnxkAS3T5KAz73f2pQVijMPyryo58PYWaQVxlZRqbyPdyDwL?=
 =?us-ascii?Q?jECrlOtWv8DYmS2OPxY5Q6OSXZ7gLmS6dAutyDxKhFZb0fTtCyP57kH+jeo1?=
 =?us-ascii?Q?FufTeI96z3YoeZlz5ExQo5fC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb59cc05-aaaf-4672-bd51-08d900b8f31f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:21:00.4204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RihLwD6fzOCB90KoOKsYZwtCcIj6oVttpX7Xbhnzl/4kyAb0VK5ElzQpUnvOgcrPJ5tqvu/iapqcGUOoEbwBDwKpoLcT/4ka4rIFRPmADtU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: xXLuTV2QdiwiGr-SYekSU0VAq7NV-y1b
X-Proofpoint-GUID: xXLuTV2QdiwiGr-SYekSU0VAq7NV-y1b
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
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
---
 fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
 fs/xfs/xfs_trace.h       |   1 -
 2 files changed, 96 insertions(+), 114 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 80212d2..5740127 100644
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
@@ -271,8 +271,9 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp = NULL;
 	struct xfs_da_state     *state = NULL;
-	int			error = 0;
+	int			forkoff, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -287,10 +288,101 @@ xfs_attr_set_args(
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
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
@@ -727,115 +819,6 @@ xfs_attr_leaf_try_add(
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

