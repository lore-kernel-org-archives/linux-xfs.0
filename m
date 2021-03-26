Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD83C4345D
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8417E61A02
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhCZAcK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56936 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhCZAbz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OvIb057506
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=nhV9lN3X3ItZNmzS1556SsoDOv3m55MMX3cA0E0Wn+g=;
 b=oHF+MbJ2Yp51QnhUxcNPKoHSesXBtdXZumQqLnSopPEGm/nZVvCB9vamZYQxcuPJDrND
 K4k8vLelHdTKjNmqPAEN//oW5eTuLDJlbmSo+vs4ouVlko9JsAmvXEmHbVxyTG7gfVZ5
 j79+FUUA4BzYdISKfQ4ei3UFB4QsoxpNX5+C392+qqXBLoC7F4tBJDh0a35B6mxiBlpm
 Bib/ONTjXdRlOgEzHrVBuY8/uJZMyv/j2bxnDQkIIf753f4OwNGBKHVPbhCYRJqBDo/b
 gJSDmLnN9keh2EQ/kalGP8y5lpS2Ycwfs3ViB6cD4FU0+Tben0fJX5DfP+ilo340VUdc lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37h13e8h4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0Omuw009664
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 37h14mft65-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGvAqYZRQD/PaPMxhNg4/op/usgEnh5l2O2VAHbFogQfmSgqhN2eScUrGnLqkrNL5wsiipE1O9Z1l7d4mocHlJ7HuHCnHgS+ZJhqPP7K+qLeb85jlkbrMwffVDwfFFSIbN5npQjMdZSi9+auXUfrA4SYHY7TWsLqQrSCgC66UeHQF9PweBBMY9D+NUzs2eYNZhGTL/NfNbi3je0cGA/qFfSlqlt08hgBf9d0VBN4Im5EpE1y+lkCdRk1XIIDSHPiUpOvqnauPSIJUc0FwjrcXNiCmGCdCG5U/mvpQPAcfDM2HXYv2nfSljfFe8LdEQvccouGaduT2O1Vz7UEIlyOJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhV9lN3X3ItZNmzS1556SsoDOv3m55MMX3cA0E0Wn+g=;
 b=ecl7CT13IyWYO0vdvsJFLzdnHi0tq2/ZC8GCWToYTjH33Qiw7LM48K4jwiUJ+VIDP3zyTPxN27DdwQ+JQWdiolMxY0M/2mDGGYARnwQx2w2MZiW6NDdcFYv4o/oHhQygp0oaVm1+VOxRbKG+kgyMn0RGqcW/YZwJa7QPJTAoZecFpYMo6K6iCdSvQDU5ZFGJLDw5IiONVXGdiSI4GAxq7gjb0tyR9Kuah07Ntim70cjfN8uFzh9V7y/uBaDAOl3T3FmGaRr9MBoKFFBvSqdbLgF8BUn61RmiZy0zD7zH9PHU93wP25Fz+wVocKxh7upK4+FZGQSXyvgARPBMlVKh1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhV9lN3X3ItZNmzS1556SsoDOv3m55MMX3cA0E0Wn+g=;
 b=VdE7e7WRG/PzAmXLrLFkQCWUkDDrST1TfrPbDSzlDjDgRsO9UQ9LmZyWiYEyJ3liub2pvfj8VKqJch/Zc1a0bw8XF9AJ6J2JLfbqdAbzIv7cpfTSOO81+3VkXZDRpGA3Pqfg+u/2twoppqnRXUhvy79dMvoGqzRRp12Sa8zFGG8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2709.namprd10.prod.outlook.com (2603:10b6:a02:b7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 00:31:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:51 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 25/28] xfsprogs: Hoist xfs_attr_leaf_addname
Date:   Thu, 25 Mar 2021 17:31:28 -0700
Message-Id: <20210326003131.32642-26-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77184baf-f009-4776-dff3-08d8efee8c92
X-MS-TrafficTypeDiagnostic: BYAPR10MB2709:
X-Microsoft-Antispam-PRVS: <BYAPR10MB270934002023CEF9D597B41695619@BYAPR10MB2709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VRKL7tL9tKa0InMg0qgzpJdqAP8QMhBK7QdM4tNXXOSmlW9by/DmMTdLOJfdmoQGZqrdRph6vvKJfBjeR1UXCHAZZmnQ/s3SQMc1BSyls3XtN6FXoLj3fM9ibpj9MeJ+kifDU/du89WYa8pp/yiUvT2pTGVpLjKoCuwzMo8GquWISE1rFcr3Dd94HcuKCcpuzq2iwWuzTaWq8szZ6P87ZTTIenJzRj/6qAgh8Mg35Criu950I/25i2zkdrxBrw7ANOodr0aX+oe1mm9VxKAoPz6o9PAAgXOJV1zkLazsiKcHDlmMYuWryXMWy9/Fky0X05gmhk+mlrLpyN03z76rD2yNcf2I+O8oPhKXKWf1/Nc5SNA4YsK+rQt/e1ACROlsuqrxt60XQe+mt3RcX9RGManueKCRHVoAxCqFXSQASuZWek9LBoIOfn+pv+e16CZcOKR5gHGz8TNuLh5x1lkGmrVl1AggKN61Gt1Akhr8wmXxan4As8STmmMX7Qq75RVZ3R5RJLQWGphJsFqrn/H28Qnapqenb+ABRKwxzZlMlW9tg58qNaw2ZMLdf3k9QpyupBgaoAdNy6Gjoi2RA936rdILpIDqTQujk3B60C3d4Chl3nzLU2P/M7zACto3YAnBUhRhKw9vfkgUgNf4A+H3nT55Fk9EesqgREZSNuie3vQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(346002)(366004)(1076003)(8936002)(6506007)(2906002)(6512007)(6486002)(52116002)(6916009)(5660300002)(8676002)(83380400001)(36756003)(66476007)(66556008)(69590400012)(86362001)(38100700001)(66946007)(956004)(6666004)(316002)(2616005)(478600001)(44832011)(16526019)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FpUkOg8SEZWahS+Jc26r+my6ewG1/gwz+NRwehu2Q8t9oeNJqQDvIZ94bpju?=
 =?us-ascii?Q?wFzsjYwdZIc+0inkOxBv8LSPrB826OE9E3LzZygK6XQzkDhqVbLTlRypKsAb?=
 =?us-ascii?Q?i7uwGBWHzWKHtwMuO37XewPmfgETLgqZOOScU7SGPT5aZo7/syheGAmc47Wd?=
 =?us-ascii?Q?F3DM+ABTNaYomLgBPDVTNanWA+w2eCbmppW19tAYG3s2Qvy8so/jT2JtOm8R?=
 =?us-ascii?Q?RuJDMQva+yv+HYEWgbs3G9yaQJ1ZWeK9SStmfsAuXvB1qEsxrz96aOpxYcC7?=
 =?us-ascii?Q?RXvu42sbBN9Rggi+Naxt7mtSFN9OGs5IAPUrKp3pv72rBBHEw5JLYJCmkQVu?=
 =?us-ascii?Q?YxpSZHAVVkAcUykiHkLSFFLo3tsqS5Qnio89GDjWQckox8lJlIZAgPzAzGlW?=
 =?us-ascii?Q?r9lVCbcI8/wAs+0p+9sH3NPrTaoPgnTqBqkpyQG7SsrS0m5zgk0x7meECcQO?=
 =?us-ascii?Q?dJ3bd8r3YxY8jXzzuiMQzGoeqWGyk/VQ2+w4mmXO+PYpLmwh/tcgVj6OnZ/t?=
 =?us-ascii?Q?dm0P4xoM+ZWuYxlpfuuL0LTGFpOnfVMF5v/n3h+Nckk9q8UNOnhIu03L5fn0?=
 =?us-ascii?Q?QK2j5N725nBfDjC0rZ2myQWSK6G8RcHtewNsw0UYxNY8K8zfZolPRHthnFlp?=
 =?us-ascii?Q?4PNGGuiNyCChmIqzuLdZTcVw68QO1fWYZT9af51w7NhHMY2n0YRfdKzXQNqS?=
 =?us-ascii?Q?dom1BxdKDJoezx4fZ1wIVYQzTt1D/riSnvWf8DVgGiZej75E8vGolQ0b6UST?=
 =?us-ascii?Q?pQT4rY73Txe9t/3bFD0tep5NXO2tJVvJw3bkDZpFRrl6oEnoN9Z2G1L6dvJX?=
 =?us-ascii?Q?YHMD44QRXTlmQcWj3256Jci4N4a6X8WOig2Mabcmh4PLdpTkVsHQDYeYtyDD?=
 =?us-ascii?Q?sBS3m8wGLR9x9P8ISUv7JF1JRVlzNQJ9zetHDxRVJn3JbUGcM7JuJ1JG/MWk?=
 =?us-ascii?Q?bE4m1Jd63EJ8IzBVq/wrpi/E9cONFjoa3e87OnKW1XLb4S36f0fWu8FMXE8+?=
 =?us-ascii?Q?598Q/Pn2my+fOkPG5QEkt/1UW/XMo2ccYhWaMbMV+KMp5+xRgLMij/a8dbhH?=
 =?us-ascii?Q?puqnGhV6plgZaOcG4SxB3SR3d29PirN2ltl9hiDzMCcbfUEHcliSY19y9dLf?=
 =?us-ascii?Q?g+r6zU75rr2KhBJZDsiraxAwpDG/dGAhwgomGgrh5D2NJUrAniwp275ZgnEh?=
 =?us-ascii?Q?UZjjw2duf4132D5DqVsNxzqNxI110FWNOQZV2KtBKGHZ37+xQXtcHxL/mC2D?=
 =?us-ascii?Q?3uS5zOcJnNoPlZoQi7ewaWuipEbnDvp0uJcYAUq1/WPcDIPNeDaRZfaVX0aj?=
 =?us-ascii?Q?6g3D2HEPMtWlzwzyjPWN1KSM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77184baf-f009-4776-dff3-08d8efee8c92
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:51.3740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aDPpXkvYKUvpOV69OxIXLDUSpdVHAMTSmARimgJrnRnbYieoUEeDIVqBqo32fiqy79NzpofR2FqcfyqkH//MBRoUz7+1EjUu2KBRqWQzsxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: XhE4suvA-oa50LOoE_MOzsKjPkvC2phx
X-Proofpoint-GUID: XhE4suvA-oa50LOoE_MOzsKjPkvC2phx
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 45adc55591f5d91b9b6c7752fa4253bf3de33886

This patch hoists xfs_attr_leaf_addname into the calling function.  The
goal being to get all the code that will require state management into
the same scope. This isn't particuarly aesthetic right away, but it is a
preliminary step to merging in the state machine code.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c | 209 +++++++++++++++++++++++++-----------------------------
 1 file changed, 96 insertions(+), 113 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ec93d665..a3e2b33 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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
@@ -742,115 +834,6 @@ out_brelse:
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
-- 
2.7.4

