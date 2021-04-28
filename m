Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C55C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D374061431
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbhD1IKX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbhD1IKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S802vQ010510
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=c3GDTrPZMjkfclDu/3E4rkHg41Gf03hUsJQJhqMYAFE=;
 b=TpxWJWSVF+bTaSeEmC2U5JUhEhZULhWZ/IlwE0YZg9+l5BJF4vgDh/y3oMLCn6xK2Xnr
 wM2/5Z+NToybckF5YDgDRU7ulflzccUYTVzZzHyN6erlMk2unPULobyzPzBz3u8zh70D
 vUg3udkO/6E3cJ+q0/y+xXqy+0nuHa5FnIfsIjv7OJFBvN94TJZrjS3jCsT4T8/LTK7e
 y4rgR8sqVAoq/guc0+BW7eVYA/S8pNbfksUp+9YEdca+KopW8VbTo3UfdXPDEgEX+uLD
 947bS7/KZiXPTAF5fNE+cjtTedvuZ8AqKA1NGhknkypmniUyRjjubVU1K33Pb0J9NFeC 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 385afsyw2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80oJg196107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:34 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3030.oracle.com with ESMTP id 3848ey69y1-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIUyfdHAP1BbHWSzqFWGCk11qSQVME+EBSystL9b+sPXh7rs/tsTr9AsnLj/UwNdY3yY6jcZbsAfGJQiRO5Gm1tXbb+WNG3k7PHVC2v6he6rAhxQ6vmfm51w3pneVvEbbOELWZ0Yi4khP3hCJJXTMNDu/Y8W8ZAZYcgjn/l25EPHGxRP0YBZRJd3ssFSDHVnRwf9AU0++r8CkiaVx7vQsv7om641CsMvspCJgR5PTsiwt5zECKs74kVde4mSbBRyrXYxi3OQJlx8y9mnjyQRP6jXZY77YuXpfTxKyMlBBorw22bWjP1tr0scCcDTnzdo4Hm4ZY/L8J5x54CdztquZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3GDTrPZMjkfclDu/3E4rkHg41Gf03hUsJQJhqMYAFE=;
 b=Q2nv3uDyRe+xnTLwAHzY5ojs3mKbb4R4oPMhmziOWpp3zmrUK1rPgYScSDHl34z9h/6fSN4mVa7r0H+1VefNhbGwF11R2QPi3OMUqjdqlpoAAGw0ZDBXweSjIgSNgkIyFylYwuZJ2PETbDGeUf17abTDj4lFfewy8xl+k/otME/Xx6LYuUYevziQQ4dj9W/l8lITV/zfBIy2bitFHU5zDE841iObBQm/FMNzDbSZeQ1RjC+Qa6U4B/s8UPvww5WFLQKHS/MjmJfWBuQDsYNw0Mhjrba8540B6uNx2fiwRSpzArIhPU4x0CfhkZ9zUhG5o9GbtvJTBtIaudSAMZbVkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3GDTrPZMjkfclDu/3E4rkHg41Gf03hUsJQJhqMYAFE=;
 b=pLsI2w4MIQj4b+yHk916Ren1OH+kMGNhx3ZtabLmD9mBhH5x3ESDIgX+/aPyZy+5o6TJfQV305Sivj4vvKKddFXq4QRfrHDXQU9gj26C98vPUTKFxaQyamt/6Sv2jMs1Dx5Qb9mgGMvs/MmFZh49keccHqqj8JYDi2oRvJOwXdU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:09:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:32 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 03/11] xfs: Hoist xfs_attr_set_shortform
Date:   Wed, 28 Apr 2021 01:09:11 -0700
Message-Id: <20210428080919.20331-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210428080919.20331-1-allison.henderson@oracle.com>
References: <20210428080919.20331-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:74::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3e394f4-7cef-4810-848c-08d90a1cf423
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB4086397225D01DC98C4C168395409@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pI6wBFwmnD5NBxEt/Nsp3h+HPMS1T6cXyb82TBNedvJsB+R5Yp/CafANZVWRRPwq3A2s1iBWamBQc+RyxkLdCA6E4Ib/olI0auoCJe9AaB+gLmERChVsNFLAdzmW2cL7SPjVgtNm5UECctFD3wmm2jncJoJ2ktiLs7+X8sX3HygDnsXYhVmKbyoQI0KB1z6B//+/lW9e9T98KCAaVnEPT2JxfE6VYRtf2Rg5Cclc9JFEyhOJS/xLQShK7gb/ISSC1X3+RiYQ3L1nv+5Y+zlMf0CcOQtti+zL1ToCPv3+1HmoeFuFMW2+d8zF3mhbgo0k6x55L1LYh+WGJQIMG9DWg/cI+9bzDpCFOU1Dpl5XrBpS5jNc6QMpiIFvkPRtP0VmDpadMLwCwO0m+xzuGL3SqfU6S/9ZOq2bXk4oMpWcnjxy9uRhYVIyycEGA+R3OGn8G6Sn1zFzWG43e07VKK+yfMDOROnD1WqxXfjHgYhzLfB9BTN8OwWNSdjkP+L01fjSvN6mKlXBfqcCZkssXKBaGpI8UGKVM0+v1zxN7ulWisa4lcUlhpOOx/Gehqqp+27R4J7z9vDvL7wySygT5e1kOIsigLq6VD/BNskELr/N6fmfzL7IjHrZTGPmVBJA8U+y+M+DoCElkgmgMQ5U/G3/njXKz7E/g/uUbSJM7Wn4kM1dgPIk7GEA2FX9xOsfWu8t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(83380400001)(8936002)(52116002)(6506007)(66946007)(36756003)(316002)(66476007)(26005)(956004)(6916009)(6486002)(2616005)(6666004)(6512007)(8676002)(478600001)(2906002)(86362001)(1076003)(5660300002)(16526019)(66556008)(186003)(38350700002)(44832011)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9i/yH5VEvXsAoC1/CTP3PgJNFNaCNH6Yf6japF8+DlivUpYiNXy3UIc0gCFO?=
 =?us-ascii?Q?2EBEBuEe5CllxUpysZOS9LiW/u0Y06BOMHwTLrGHh2FfmwKWUL9AVsFqjksg?=
 =?us-ascii?Q?1aQ8vXPNbLTpkHmz4rly27GvRXxXb+8fhDegOPzH5nm1WahUoYPniY5z/H3z?=
 =?us-ascii?Q?6ky3C/SD8cS8g9VjJJvNst2L3GX+w1BhFth1WnuBpFJgA+7ILRdZIQol/ChE?=
 =?us-ascii?Q?niBGhNHS0IyOl7BaPvNvpc/0TKriZWEgVZyA6xe8nN7CHWHdmitFN/bdwyOo?=
 =?us-ascii?Q?u1ro/WXWGnCHI6CMwlA4i/5HdvpIbUrtVoYxUsPUx6kFunapfD0IGDpO0fpi?=
 =?us-ascii?Q?lY+CTOk2vuhKroCWnzQuNszcBVFSc0L9We8+SS0db+cF28G0A5wM+qSvzosu?=
 =?us-ascii?Q?vdtylBZrA6jVyooxhSDefQnF7wnVcw3r7u8pMuKvauxv7NsqQYro2OKV3vMw?=
 =?us-ascii?Q?IF41b5BgFi1UmMjGxkdUHi/w0rMLqF5rLqq9y9Gn8QTLVLyZAuyxM8YiUQ7c?=
 =?us-ascii?Q?wKmvOE2aMJsZqvXOO5+1sjGwad8pzdrwoiGY6vZzBXo2+/jadYhMK4zlFiO7?=
 =?us-ascii?Q?iNu+70cUdSy3mqkUdjHNvOWPj+7yXflZOwAvV5rzzap7viJogkSjPqXOfL4t?=
 =?us-ascii?Q?YAsabB0yWArRaxhlZIoE0OQy9S6OCBWAJji14tHBttwxyOo+qQzrNGh5N/GD?=
 =?us-ascii?Q?G3QBaIV2/foJZYIAZYs9MfPWT0thr9tOqHWVepjjVFVpL/wPMwMpfHKRIhaM?=
 =?us-ascii?Q?ijOVV3gW8rPmfTiRHdWUjnEk/wOkI4yE5GomsjLGkWJvOKT77CZcndHKt0r5?=
 =?us-ascii?Q?OvCN7R+EPQZQxqkv6dyQdyOuJ1538iuyMquQHT53EHn1HkY35UQVI3ABO+O3?=
 =?us-ascii?Q?FL/ZrmqYtdq/l/I7hqWMyO11VlMIN4I0WrybvBYP/uVmZCJUaxW6iPRNwEHK?=
 =?us-ascii?Q?1Yi6O8aVG41lP01sDA2k9iRW64C6rW55JHshX7a8kU0YuygDSUrAXd+tTPD5?=
 =?us-ascii?Q?Bl2t+sKQiRwYkjHnPnXbbIAbfYkMmAFeuNwsTZ1kQLHQOpI4WqRfYLSpXuZG?=
 =?us-ascii?Q?vyKhI7pmQLWxg983dod2CyjWMRsy+evhXRc4IbAlZgn+1Bk4Xqrw2vdc6WkZ?=
 =?us-ascii?Q?8Tve4tRcBBYMXB5YKRalg777P1WzDLxfjBZaSBRzlw3XX0wnWu3ydT7YCKNA?=
 =?us-ascii?Q?rYwM6kpiF0g7ISXZIrS4ejOtoOn+i1JPXnsn5veJ5K37Izv9V6vFh2Iqixt5?=
 =?us-ascii?Q?81JkMIJ7WvpSWseeYBVQlIPsPu+rnBg6Xw8bVQXXPgiPch+dnmNztroClCRY?=
 =?us-ascii?Q?p5Ypc5FI7qKo+/u4lqE06tLa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e394f4-7cef-4810-848c-08d90a1cf423
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:32.2828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irzTZuqXab6XQUSAJzrnlskGoUD4TG3bs31D6Qgbpx/J5FuOfBwxV7wo9f+sePH5Zwc3Q1xeszmfGoCvhZNE+sc6qAbnVxha0CD+btpz1yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-GUID: qygYiWIBYT3tGNL91piT-a6FUP3oIhEz
X-Proofpoint-ORIG-GUID: qygYiWIBYT3tGNL91piT-a6FUP3oIhEz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_set_shortform into the calling function. This
will help keep all state management code in the same scope.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 81 ++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8a08d5b..32133a0 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -237,53 +237,6 @@ xfs_attr_is_shortform(
 }
 
 /*
- * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  If the attr is set, the transaction is committed
- * and set to NULL.
- */
-STATIC int
-xfs_attr_set_shortform(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**leaf_bp)
-{
-	struct xfs_inode	*dp = args->dp;
-	int			error, error2 = 0;
-
-	/*
-	 * Try to add the attr to the attribute list in the inode.
-	 */
-	error = xfs_attr_try_sf_addname(dp, args);
-	if (error != -ENOSPC) {
-		error2 = xfs_trans_commit(args->trans);
-		args->trans = NULL;
-		return error ? error : error2;
-	}
-	/*
-	 * It won't fit in the shortform, transform to a leaf block.  GROT:
-	 * another possible req'mt for a double-split btree op.
-	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
-	if (error)
-		return error;
-
-	/*
-	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
-	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier. Once we're done rolling the transaction we
-	 * can release the hold and add the attr to the leaf.
-	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
-	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, *leaf_bp);
-	if (error) {
-		xfs_trans_brelse(args->trans, *leaf_bp);
-		return error;
-	}
-
-	return 0;
-}
-
-/*
  * Set the attribute specified in @args.
  */
 int
@@ -292,7 +245,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error = 0;
+	int			error2, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -301,16 +254,36 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
+		/*
+		 * Try to add the attr to the attribute list in the inode.
+		 */
+		error = xfs_attr_try_sf_addname(dp, args);
+		if (error != -ENOSPC) {
+			error2 = xfs_trans_commit(args->trans);
+			args->trans = NULL;
+			return error ? error : error2;
+		}
+
+		/*
+		 * It won't fit in the shortform, transform to a leaf block.
+		 * GROT: another possible req'mt for a double-split btree op.
+		 */
+		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+		if (error)
+			return error;
 
 		/*
-		 * If the attr was successfully set in shortform, the
-		 * transaction is committed and set to NULL.  Otherwise, is it
-		 * converted from shortform to leaf, and the transaction is
-		 * retained.
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf buffer
+		 * and run into problems with the write verifier.
 		 */
-		error = xfs_attr_set_shortform(args, &leaf_bp);
-		if (error || !args->trans)
+		xfs_trans_bhold(args->trans, leaf_bp);
+		error = xfs_defer_finish(&args->trans);
+		xfs_trans_bhold_release(args->trans, leaf_bp);
+		if (error) {
+			xfs_trans_brelse(args->trans, leaf_bp);
 			return error;
+		}
 	}
 
 	if (xfs_attr_is_leaf(dp)) {
-- 
2.7.4

