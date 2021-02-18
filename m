Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC60DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E43764EB7
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBRSqt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:46:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41058 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbhBRQrD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTioP156524
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ZNrVGw7iduRAPh/77UhKHpJ/qrevrAoJS9oLQdgBDM4=;
 b=MyOf4hvpHDxUpEXe4lrmuQkgb6NUDM6IfAN6X9a69RGW1ySVogr3an2fr+mEOVwY36Qu
 6wgmKHq+7enMkmiIcvlarrdlEaF/SQHHWqtPyGwuuDKCZLWHjt26xlGX0VHwRNpG57EH
 hWA+8ODU3kL6QEqDK89sCZP9S+eCikSO7GfS3woQJHGH/6cz9G8biyqh501wtjUroGRV
 U1ttnyhJh1V8L62jNAdmd9QOo365Ev9NVgTB5EFWkhUXEqgVXdVl25jeo09VcwdV2W3W
 6ojDoJI6u6fhD03NPEs0myz/tYCdJxAz4cj+M/sRpK92KJwR1SqZWRXWpc/4/3UVjcsB kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r6m51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUBLn032269
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3030.oracle.com with ESMTP id 36prq0q55k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apLWjys4O+RAHnOQcu4Pv8jQT/x9EqsKGeOw2SA1AAOwOspOsReeuggEvLf5pQRe2JHCJSNm9tYa6zTKOmXeTNy502RTiFFP1dlmPUTch/PVX5YDrPab89r+AMDfuZZV97pglih0QEPlkQfXREqq90XFJJIdc10I+WIO7zSHRGTfMM0d7kkWaKTKaWu8ccPD+XAnbiux2TzcK0/nl8X/UAqNT7rhWYandJlqBZ/ll1OGoEST14ohwyh922OLoJD7ym9qrtFBTBCW5FZ1BLvrLbfP0uZzCpZZyJFfIxE1Nz7xbsN2y9bO1XCHvMKC+Dx7l/XtlIuXBvThOD3YgIS3Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNrVGw7iduRAPh/77UhKHpJ/qrevrAoJS9oLQdgBDM4=;
 b=cTTwM492A02UfMjPUpGfBetb82vkATXBnlXIun6C6n4/pXrKSxDbvE7/MDtCZqMtKCKDbi7VF9eQfzUxJiON4pan8cUxhB5AyPWfABHaBkp2x2LSWiiRbXVbzPAH9trTHqRzsjD6NQhtTCrCYRD0GISieIWoygroZe9f5XEVgt8JKVO56XTFeq4nTk3kxLN0XOVOg9x+8K/ulhuJ9YjTVLm+aepCAAad37mmw6933h9tP6rPdVOnbSzF8cyPCCLXx78IdTx+EKhLbHFbFr2NY3lGTbLX56gycaZn1a6EYGuEdg0p3+ZsrHg+Hkj+n34/PS09vBHuayWh6yLQvL0CcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNrVGw7iduRAPh/77UhKHpJ/qrevrAoJS9oLQdgBDM4=;
 b=aSBnee2xePnLx6tzp6FUqr7n0TKP3Yu2p9mY/KdR8Hvno4H/3jiEXi09OB2vm9Oph4PZT0aAue35RYLpKLVZv/7QLlfOWJMXn7kQwbFQPFqjhs3ElTPzfLLt9JbINStPPkToTMZe3YuF4kNwhLOMHP+v1Gl57c79dBD8ALXsBhw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2965.namprd10.prod.outlook.com (2603:10b6:a03:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:45:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 26/37] xfsprogs: Hoist xfs_attr_leaf_addname
Date:   Thu, 18 Feb 2021 09:45:01 -0700
Message-Id: <20210218164512.4659-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd7ea577-053e-41f2-b087-08d8d42ca1c5
X-MS-TrafficTypeDiagnostic: BYAPR10MB2965:
X-Microsoft-Antispam-PRVS: <BYAPR10MB296502E2FC9A17CFCC6A7B2A95859@BYAPR10MB2965.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cyqnuOOGfp8cAFe/OvNveW3V3gnwUCZosvRkuOYDndT7CwiOLrlyaJ87QbRWYaNmXvRi5FmSMnsmFyuJJkQi8MDo/r3XJdJRnMfXyBrzk1+8OGrw805aiidXrx/7LPS7iTRHnOdm5W69g3/tT7q0xTbAdiMFTTjz4fjTbHvu443CgIRbmbv/IAvr73nI7NmbsbswrOX5OCFL8cu7jFKH++eVSNPajDgw4qyKpFn3OX3kGOVGVupU0WLVSMf0vY3hw9EzHd/l/RbrAit1Ffnmsv8Dfpg1iHnEp20V7PB4jp3/e614xolZcq+HGl7iuXwMwM2kqcxc2Oa1FwQ2e/q6SFb9ryasrINW/yGXf/aBGPD8EY8rzTZZ3J4BIcXqafJ/RuWCKuKt5MibCb1AH3HI3ZxL2SUgUHlAMdaw28OU/APPqihAbDtnjqwB0JqXh9s+G+TfEaOZHiUfhAZZ+ZsHv3rU4sqDSW1bCjNBsB7g3N81ww1zAuIT7USZX7tol4QGlviZsxJQa4GedSvuo91mfe0JaZFOv41I34RO3vN8pH53vTuJvX8QdM4Lk3eXhxS5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(6512007)(86362001)(69590400012)(36756003)(83380400001)(6916009)(66556008)(8936002)(66476007)(66946007)(478600001)(52116002)(6666004)(6506007)(316002)(44832011)(16526019)(6486002)(1076003)(5660300002)(26005)(2906002)(186003)(2616005)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ng7Xzpl9uIGVr9P0JuNNr2JEQs43bUSCQgWpTn9ZsB6fOTWrGYd8eWaWQX6B?=
 =?us-ascii?Q?qOQ8kL93rd7Yrb5rJ5xHRsVXZTuVHqc/Vb0R58ZrR8g1YM62/AA7BGJvMj8Y?=
 =?us-ascii?Q?4OHaXuo79uP1j6X7tF0UaG3lTeXjVssp0HhX0fLKKveXGmhF4rywcfNSnVQm?=
 =?us-ascii?Q?uaPgdrNQNXdODUHl6mApQjBq7vupY1z/D5fBdVevnFS5fm4mMbuh/Be4JTpe?=
 =?us-ascii?Q?KpUB0C8crLKciV94vG+6DlJs/6zcVc5UtOq4GG359ImyAwIKaTcvYJVIgPnb?=
 =?us-ascii?Q?e4UrtrRtcfMAkUrYuBLYhqYY+Xhsae4u35a9sLUpRhvn3n5wzjfjSBpqBu00?=
 =?us-ascii?Q?KOqKi2DLGA0LVocvTkv5ghZR0LNPOW6wS7ra6l7c8odQLpLeBiJlAey6daZM?=
 =?us-ascii?Q?3vBNgfGZXIhMX5HwKaBG9WhJSNSqN7QsHDky4WcBxJJd5q2SJzG5sDuTJiXf?=
 =?us-ascii?Q?/R7QTmVQxq3X/fxftXdRyrkumwXlgG7Zjv81Juz1grLuJXvQ+2s/WXTEroBT?=
 =?us-ascii?Q?E3jcEF342dHs/k1eQIGDTFeTH1aXv+p81+rSXfYWmyU4SmmZ0mWnAtBI0gw4?=
 =?us-ascii?Q?tlpF4sDh0ZPo/NFX/x/UwDwldvOtlTuWGzpSECyDqXQ8yWdofjlEcPXY3Z7J?=
 =?us-ascii?Q?Jik7DkQ14xIH/rYXjizlf3Fpu4EXHHuSQQuJCtmDcgSMwCsLsf1ktVu1sEOA?=
 =?us-ascii?Q?3g9h+jBrevuAccg+QtIg4D8ks2wu9T0oPdqP2GL0lxElSk2X+5l6FSxcbiH9?=
 =?us-ascii?Q?ye9emGYaKd9Ct8rl2rBmygfN2Xj4X/SmLXwBdnxacUCuwVhQC7omcPAfGfh1?=
 =?us-ascii?Q?uqoHkNqqI2JguOY145rTNp6rU5hnldyFCN1iYiSdVE2dJSa8kftRssmLpG4N?=
 =?us-ascii?Q?QOqoRLG1JYhgIx4cGnVob7/n//B9+wwmEaSTo3gUb5lFIoAMuqj2+gEg0qZA?=
 =?us-ascii?Q?To+7rN66m6vaVMJvvnGxZBRF5YwsSgo/MQMfpVSiw+SKmP5gGl5t07Pl94k2?=
 =?us-ascii?Q?QDnDipG77Q03F4OZX0zqe0/+D0sd6qTb5ku17RV0Q3qFpEpw20of4E9aqrDf?=
 =?us-ascii?Q?lN+ADdOjMKTi9qAO2vNergBJtUHd8w3WQHE8OtXwUCQnRYgguEYLl8CmoUvp?=
 =?us-ascii?Q?qNWrijd8SFhM6FAX3YrCgAiUgGQhcJuceo5SCtB3XAeDvjeUYi5Wdr3vZOF0?=
 =?us-ascii?Q?gVYxsw4J8bi/p+zZ65ZhqNMPLSun7tT3QQ43ht+AxhwP4u1ajKtu6xEwMMYy?=
 =?us-ascii?Q?UmUs4m4s7eTPmFbqkDUBfFmOa8859edDh3XnNcPbo81xW0aO2EsgWbRNhA+y?=
 =?us-ascii?Q?yq1oZ8nfEE90Ev/cCmKd6x63?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd7ea577-053e-41f2-b087-08d8d42ca1c5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:43.2096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5IR0vIzdSQF7DIaxU8Wocme73VO4oNhia/59ZFzJlmL2zwXQQiAootnGViz7/gWS5fcPY2kaER35cniDfuYQFrw43Lm9Ju8gqiq3gg+ngM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2965
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 45adc55591f5d91b9b6c7752fa4253bf3de33886

This patch hoists xfs_attr_leaf_addname into the calling function.  The
goal being to get all the code that will require state management into
the same scope. This isn't particuarly asetheic right away, but it is a
preliminary step to to manageing the state machine code.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 209 +++++++++++++++++++++++++-----------------------------
 1 file changed, 96 insertions(+), 113 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5fadb06..6a9d9f2 100644
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
@@ -269,8 +269,9 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp = NULL;
 	struct xfs_da_state     *state = NULL;
-	int			error = 0;
+	int			forkoff, error = 0;
 	int			retval = 0;
 
 	/*
@@ -286,10 +287,101 @@ xfs_attr_set_args(
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
@@ -744,115 +836,6 @@ out_brelse:
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

