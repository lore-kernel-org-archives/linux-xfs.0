Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26758C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0831361166
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241632AbhDPJV3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241666AbhDPJV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99J3d026165
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=rbRZmaNFpljFnLnx50Yl/6U5y5cIb1rcn5Th9pKxh5k=;
 b=mUyG6p5BPneTF4lYBP/6Zs/z/3xYugHtZEmj2+GgKwCdZu1kdiRRbJ4L3U+XrCzpkpbD
 +TImDofSTsI3iNU13Rt39cfzdmeCLq0W7wW/VF7OkDSquH+/1X/T3EnkmtzYG265sp+Y
 13BMAfOKVgbwE/uc66gndfOXfn2tQcw0x2HNBgYDzYX2T/XTv6SwIA2ddza8EdR3K7mb
 nNZodKs+pp8M5aN82g+p1W7RTcTZgSpv2HqRzBF3hDq6iquymYsGPDYzecR0L7NxwR4O
 nL5wmnPqV/FkaOOHRy/1vOg5kMm2zf9ljUNFfxKIfNruib3lTGU7dlBXMb6vJeegLqDa vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nnrhem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXT2077147
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37uny2cegt-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvUis7xgjgNP5ZUZDMz21Bwj0+2QWfZoMuRGvY/32KxOcAnTP20zpKsGMcUKW1vgGqwmXIHkfuhMZw5RpXf6EypH6dxBbZnt+nq/p4aVAIJy7mHAUTAZoCAq2ies/cRyqXKa3fQqspZIzGKGg8hmPL7w9F4lBkZc+obxisNf+I323qTXV8g30XiWPlGBt4fpbLUn/SItt+K6NJg6iyxIX8b+/TBh5o9zKtnmXj//0vXizNddcAzXM2W6D04gsXQcTF8CUzKoAq3YSPxajZwPklbY0jRa290sGF/uITGFKrSIC4aVUjwIMpjqbde3NWW+7/AsxaiEQHlDCcQKABlFZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbRZmaNFpljFnLnx50Yl/6U5y5cIb1rcn5Th9pKxh5k=;
 b=MY3foYkO39QrN+oEarWL7TAgxCEimHp08gU8rJPwJ0fPGKB3W6YvVRmT5xv6inrNLiWx1Ny27WgVwUPZtOXpNHuQq8wDct8NvGpowk8ZYe53//flCIdaD9TdkD+VqWpfxJJGWU2XPsWl7uWH8ulbJ84Sl5q5Ez//XD4MBvAwrWaDtwE9CXuXAM+1nQNK5VHtzlll1ZqrrT3UbPGPSoziF7bbw+Kqa5M26kyCu7PVVcJAEpns0hlG9a8qpb/SDJamm5+yIRqDW1VJh71PIsMaqgy377v4TjY+wnZYvJGU724Hl6SOa3m47W6pZAuhH5pypUugqJEVuB1YXa9en4xurg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbRZmaNFpljFnLnx50Yl/6U5y5cIb1rcn5Th9pKxh5k=;
 b=oWM1zuuBUwTozGiQ7dXhf+S+58oT7xGreS+3Y7gtCMPzyscWAC78JhLY2m/baPIDH3uoociVW3ezlKfiZOc3TcYFMw3r5z44t+RmMxzH2QKSFJ0oNZPWHM4G37f4TeDpTb22Y/r5U9Q0452sjANegyHU2B3kdYJn1g1qs3GYk8o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2567.namprd10.prod.outlook.com (2603:10b6:a02:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 16 Apr
 2021 09:20:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:20:59 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 04/11] xfs: Add helper xfs_attr_set_fmt
Date:   Fri, 16 Apr 2021 02:20:38 -0700
Message-Id: <20210416092045.2215-5-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:20:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fe0b32c-dca3-45ed-97fb-08d900b8f243
X-MS-TrafficTypeDiagnostic: BYAPR10MB2567:
X-Microsoft-Antispam-PRVS: <BYAPR10MB25671FD115D8A99289B299AB954C9@BYAPR10MB2567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +LeJWd29GvazpAZPNVDjoICQ/l54BuK78Qml+MbX5MxH7ayrzjstfmz5o0zY3858QIhCc3Eh3P42ORmDp9Z0o42/A77GWD+jPS7Nzuqj94sSsXTViaJJt6qTp0uBvIGNktSCc8LLmzbfrkytRev/l30OfLaOR1NWgM+solgtuRU3tuCOUXLY2225/H23Kz6soDI7B2BzU22NW9989tdIZmH5veuS5ibrRrZqGa5YffBxsHp4nW8avtbH3CncZMoBH17nauLyB5t8mCr+NxYPF1D8YdLQbbzKr4qg4ybet+1WkHI0oa0PRhHzdlycUZfA9P6+clMFMRkKL5ACfxqmha9MarL5neGS+OoUX7FMhEeZ97SbuhaFa3HLCQjZsaoRkt06KICRmwrHcK2GKAPk5bHdP5r/ThdRcd+Hu+UK+o7Ozndcq/jAWgatRQyXGpCK5u3fsyHLUOrm6Kg/jJ8EkEH2HFqpEYK4I34SmPZsyqljzUG7FanR0GKDQQ3QtZjIhmjOnuVr29v1bwtW4PgcV4vN5tXhZVwo3TzcOJHNS33WsXGhuilKAnaoMbQHsm51fmL7aKd8XFn8lU7OIoDJ6Ce28OggwQuTGkWDXZx9buXLlSdMioJu46zZaEFDOnDn1zM+Pw4Vr0p+XrHzKXoQ/AYTLRGVmLPxpIhhwAWZcK6t43kdFmzJJ9Aamfld1bQu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(16526019)(8676002)(36756003)(44832011)(8936002)(38350700002)(52116002)(6666004)(69590400012)(83380400001)(2616005)(86362001)(66556008)(26005)(6512007)(6486002)(316002)(186003)(2906002)(1076003)(38100700002)(6506007)(66476007)(6916009)(5660300002)(956004)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UfrD9xENsnpusMPqRDce2vsVS+rlXgcGcs9IYN+pJ1g9opmmkEw/+kLVbZhm?=
 =?us-ascii?Q?ujt37HIiPhq/PpdqgErf+IhyTzGDFj2tGxITjL0JgrDIFMvy+GhZhx1Epiky?=
 =?us-ascii?Q?jVPPszo+yEFX0dv/LmcuAaBYqRSjAISAanyTfX5qERjsTZfoci7dlVTxQfkK?=
 =?us-ascii?Q?rlu0Pk0a6GZQ0N8ok9gkYu8WIGeqH8Omoo9arpzp64T4UPsRZ69GSYLz8yBB?=
 =?us-ascii?Q?T/AWcRgQiaAdFQOTlBe3uUIGBayEZ1ACdeYdvpohbHX+IDuvwfie1ZaoXyaO?=
 =?us-ascii?Q?tHBvh8pwP3ZMp0JGijTbEmLX6MTIfJieuxWnCfo1WvJO0A9creCUWnrySZzq?=
 =?us-ascii?Q?t41qrCqpzAN8FyU+V2cYEmGLZ277p2cjyvu5q99+tZq5bX/OXIUCa9ZVRWEX?=
 =?us-ascii?Q?1tVv9ZVXhh58SB4jE55vInSo5kqEAFhjJokHvYjhRagpRcIJgLoIwfkgxqCZ?=
 =?us-ascii?Q?+h9gzaI5WnYxyqykcaA7cRclBCHgaFJ1z6CwGpLwOByuxxMdgGptsajeZxiC?=
 =?us-ascii?Q?+O1ZBrILV1aL0s26EVh94JoGRo62+Lg7gulOMOIeo+GxqZHvoeL68NlW4Lu2?=
 =?us-ascii?Q?I0IPrjd0Jw6nt5Jsb/0S9ma51ataDAY24ovGB5ktRwd3n0gvOjyfgT3NCYz9?=
 =?us-ascii?Q?Do3kAcfcByFXLqwgsmb9rtey+Qt1Ye725AkwapgglVvVuGcCgBUBHJRanrYP?=
 =?us-ascii?Q?AGCKXFJOB1GlBFssCus1PGBeqrDkwAHtIl/FfTuJ+6uCz6f7iu4VipnLwV5I?=
 =?us-ascii?Q?xXZF4pSz5VCgjQLwAQC/4SL3LP3iV10u5utXhOcHRgd8E0W7yKdvYg1Xy7xX?=
 =?us-ascii?Q?pJ3shL2ngZqK6wdzUpAr6IcO+Nc361/ZYL7e/xPU9PltIA8eYOfFAYP37tsr?=
 =?us-ascii?Q?JdGJA2jAske0jjYTlxMSG6/x7gVi0q/+5ch4OI4iQFcB09KeGHFhyxRCpL2l?=
 =?us-ascii?Q?GtmtXPdTmoupUpC1/Y68h30Fygq80ljMWExEsyP3/922rd+jjCGF6rEITH0D?=
 =?us-ascii?Q?NM/yYCo9pEullJ3VzR35DP56ApTzecnrpXl0u4WtTif6jmRDD30UeoqEn1Hj?=
 =?us-ascii?Q?pEMfx/A13vsV8tTzWFu/2zKldXcMu4cQR7zdDt5eSeYmkr4NY1JwHbOZrdFu?=
 =?us-ascii?Q?wA/08Ehy+G0Q+3YnuQGsvozm1dWxzFU9RHuB+TYgXcIpipQbUdtc10wIfxhK?=
 =?us-ascii?Q?/AaadRcKuhM4YAHE9wZ9y8de4CNpgvamStcsaAW1lojEZgYYi4f3rFlKX5OR?=
 =?us-ascii?Q?GOcYN0dXVP0+7IfK46uCOUYfmCc/4timZdsuHYr0M9wgt184LntjqBFoMSmP?=
 =?us-ascii?Q?tDHZAaCG53vd6d+Bf5ERjrCX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe0b32c-dca3-45ed-97fb-08d900b8f243
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:20:58.9747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zVm+/diCabm3vmOyKqIqfJCISbcbo0TGtDwOgerWEE/IeK3ktKjGUPjPEc8tKgL8dyuD8FKgWDJuVsl50Z2rVdj5LLBm5pUQBvl15Di/hrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: TysKMRIrPgbV_3nHinqQLdRF6bGPy1Q5
X-Proofpoint-GUID: TysKMRIrPgbV_3nHinqQLdRF6bGPy1Q5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_set_fmt.  This will help
isolate the code that will require state management from the portions
that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
no further action is needed.  It returns -EAGAIN when shortform has been
transformed to leaf, and the calling function should proceed the set the
attr in leaf form.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 6987ee5..fff1c6f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -216,6 +216,48 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
+STATIC int
+xfs_attr_set_fmt(
+	struct xfs_da_args	*args)
+{
+	struct xfs_buf          *leaf_bp = NULL;
+	struct xfs_inode	*dp = args->dp;
+	int			error2, error = 0;
+
+	/*
+	 * Try to add the attr to the attribute list in the inode.
+	 */
+	error = xfs_attr_try_sf_addname(dp, args);
+	if (error != -ENOSPC) {
+		error2 = xfs_trans_commit(args->trans);
+		args->trans = NULL;
+		return error ? error : error2;
+	}
+
+	/*
+	 * It won't fit in the shortform, transform to a leaf block.
+	 * GROT: another possible req'mt for a double-split btree op.
+	 */
+	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+	if (error)
+		return error;
+
+	/*
+	 * Prevent the leaf buffer from being unlocked so that a
+	 * concurrent AIL push cannot grab the half-baked leaf buffer
+	 * and run into problems with the write verifier.
+	 */
+	xfs_trans_bhold(args->trans, leaf_bp);
+	error = xfs_defer_finish(&args->trans);
+	xfs_trans_bhold_release(args->trans, leaf_bp);
+	if (error) {
+		xfs_trans_brelse(args->trans, leaf_bp);
+		return error;
+	}
+
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  */
@@ -224,8 +266,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error2, error = 0;
+	int			error;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -234,36 +275,9 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
-		/*
-		 * Try to add the attr to the attribute list in the inode.
-		 */
-		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC) {
-			error2 = xfs_trans_commit(args->trans);
-			args->trans = NULL;
-			return error ? error : error2;
-		}
-
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
-		if (error)
-			return error;
-
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf buffer
-		 * and run into problems with the write verifier.
-		 */
-		xfs_trans_bhold(args->trans, leaf_bp);
-		error = xfs_defer_finish(&args->trans);
-		xfs_trans_bhold_release(args->trans, leaf_bp);
-		if (error) {
-			xfs_trans_brelse(args->trans, leaf_bp);
+		error = xfs_attr_set_fmt(args);
+		if (error != -EAGAIN)
 			return error;
-		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
@@ -297,8 +311,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	return xfs_attr_node_addname(args);
 }
 
 /*
-- 
2.7.4

