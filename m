Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B16C07E9E
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4A1C61CD3
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhGGWYQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23844 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230371AbhGGWYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:11 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MKH6n024043
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=p7d2ntq/qZPEA/B4SqLEdLhQYeaAf7Ubu2LF9n6MZhQ=;
 b=QNEjSBIXlgsC9ubwgiZqibcumRjBbhHfSzEpVRV6dxSkJm24MMUDdW84J6aP8AE5pe2Q
 /eC23q27gVViv6/Vpm1PZCDxwztXdJZko0ldPCDdatqyRSEi943Tc4fbiOPUFHWySovq
 C48vL/1hGzwgsAdX1tsGPYIqPTjUTA6zTP4pEZSiiAFcSZD2LMyq//wTmVU3zBFVPvr5
 1s1tDGTsSBhPB6iruU/+dNe+sHX9PcXFozC+IcG9VEpBBVf2u3rBcsnUxRPar94QAU7Y
 LBOTOAcuxH+EwNPr/RblqH2SRBe1A805QPskrUAi5roio2DTv82dFxgYBcd5ffWimA9p kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39m3mhd4f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKYSk092507
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 39k1ny0hp5-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvBbHew8Hu5t2A7cZAxYeVcaAFmbA7gB//12bg+HtRmbhRRXGcedfU3Rw65/bZ/T/QYwabKIo9BbuI4rzIxoMokED2v7zFgR20pJZxAze/eUjJ0akeqOegMTJGtluE5jU4F7N0irle5ToQCzTK6qp0czRIgzkdMM9l+O0eJEw6WRV5sA1as2BKV2bDl/LAPO0sMcS0rLo9QZlmP8OJ741pfvQ+YXAz7j31vfVJyhKDiMdo/gy4qEaaNtP16ndnYhrx9wjtQ7UxfwCinMLHLU5jxzco8InU/6O9hRWXXGOnuP9sGAyv1Ti3P6F1+vatm9AZ/JpKPbufhTqFPUdVGUZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7d2ntq/qZPEA/B4SqLEdLhQYeaAf7Ubu2LF9n6MZhQ=;
 b=KjMAdRv1nCk8mEPq88AKJvhc/UbcboKbzYkpEDdCzod3tprB9iD6wkIiF/bzKnWQFDTtB2h6PWzmnRpMtByUbQeXqLKdKRpmmC1d2iaudCQ2uqs8H4J8mI6Ul+kYCZziea/hH4Nn/PgH3XtC183+Mp3QCwJPEYExwG43xzCKE+4C61sx1qoiZARanqjfYyrCTQXqA1mR9PcFbrxdnIXLJq7eHRpMquulwkulT8Qo3FavsyrVy4+WRhcYmkSXUSGsxlrYtx5sDzq4EqoRmiJjR5YtwN84iMHhDQJM89cPSFZZ3mDEA58ACQeYYsbTmVyfapce1+o2JZ2SxkrHle9B2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7d2ntq/qZPEA/B4SqLEdLhQYeaAf7Ubu2LF9n6MZhQ=;
 b=wwiLYFFjATzfOcOf60GUDyqzBbMwqFtjf20Qlscwm7G1Vv3xZaQmkA7esdYuDEamG6ICZzoEa82+6u+Sfv0emrZfxxX+HKGfRHEdSXPfbx72d4uqQ1sZ0UAFcTDyCAqD94HcbRISlBKHRgM1rc+xOBmLWif+5FJCYBtlhS8wm8c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2760.namprd10.prod.outlook.com (2603:10b6:a02:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Wed, 7 Jul
 2021 22:21:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:27 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 10/13] xfs: Add delayed attributes error tag
Date:   Wed,  7 Jul 2021 15:21:08 -0700
Message-Id: <20210707222111.16339-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ee8933e-c776-4f35-195f-08d941958fc4
X-MS-TrafficTypeDiagnostic: BYAPR10MB2760:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2760C5ED8C8F53AE94FCD086951A9@BYAPR10MB2760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lUacrqI1tg1+upOZc1ew0PQwHXgcWVcAWV9yiKE+s+j9eNo6untcWpP21IAVAsdwkj33Bg8AWEozY3GS+vVYiQIwZupnzqYwa579Be+6E7Rx+lYiLxMK7Q+Mukm5A3Seood2WxRePsBi69BcfjkSGR38CZmAZRNcbARWEpNWbeTg4R/AOsPb+dktMZMfGfwg2VmVhPYuiPVml22HDr4LpOnJ/mI1LJoK/Fpt5tuxEyy9ynJn7UfeiZk/oMJOJq9LP5HZcEt4saK6dJsZHtIwt7coqcU2e0Iw1a5zJ62pK1xi53ncWEYXIT/iOuUyScSXMPWitcV+AtS6nWvHLWVyowwpfjciRMAt8cQlUAhwKCW+Ek7g3QJsq8NKruzDebgJosQPHvfIWOA2zd/JBH1lATMR6dp8n78rMMSRCGuMNsFVMznYn/J1UtefYlmsCNYRaorDFv3XbDujcYIJ7mRUlFrLbBeIbDNZSOQTFZb+1Rzl6aCLj8M1wYxgxf7/CMl+BQi6c53q0MVXB+fgAzwQeOYmJs1z/3YJSBHnmqq54YJtyovfXK+MDmHsQC5dOOQDKgESp6rNdG7FRNttnN0wBJJ2j4PcAws+KjhXWeP8vsZcdNoTzHNn/I6R3T/TRJHaYF5r0EUA6iULp8LTxH9l97L5lkfLuQLhSlQUReyDe1zha6gypWFaRcrT2XzZuc9KDKKwWHO6V9ymPzsFfkQM+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(478600001)(83380400001)(8676002)(2616005)(6512007)(956004)(5660300002)(44832011)(66476007)(66556008)(186003)(2906002)(8936002)(86362001)(6916009)(36756003)(38350700002)(26005)(316002)(1076003)(52116002)(6486002)(66946007)(38100700002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ODd1P7cHo0TlzM5nvhZGWIDgvklFfn3xiClK8liXPlJGWX8Nu57+0BIn2Zvj?=
 =?us-ascii?Q?oGeljPYSId/KWv6+YSdwKPoWyxGEd8k1X0DxUGc7blSvYQGJiE7XcmggGGC0?=
 =?us-ascii?Q?Jtw5A7rKmIi89+bQfD6q0H9U3OkKwvk842kbG+K9qlvSYQpGGl8hMNSW0YLf?=
 =?us-ascii?Q?ItUQi9YGGhT6t4znyPJDRhyvcUz280iDlndAzvogy4LYCM+Vpz7aJONqUUu4?=
 =?us-ascii?Q?OzPIXNft5igWugyPAZ4vcfYehq2FmhTcEY8z9ND1AxCdkvJyOP6+/7XPm/BL?=
 =?us-ascii?Q?xTcWA27OOSWPPTtVsbGIibXIRhPFv8uy2+MahSv+098BQLPx+iywY5y4hbrm?=
 =?us-ascii?Q?/tQMU1roGWyUUjvGmPrpaDBiprhGMG3zdGYty+qFKlQI92f004ff+mEXBIcF?=
 =?us-ascii?Q?6IucVHTUURz6+b/ajkLgfPMSGV19i6AJhpaUCnG9m2n45wp+JLtPX6zMC+Za?=
 =?us-ascii?Q?amz1VNpMORFYh04uL503qGNe8JBkTU++uy6xEoCCPREUQebxYf6K0Ml99zTt?=
 =?us-ascii?Q?LQbGGLCm9ZJCT1nz06KfOjzHM5WAkSweGek++k/lYlaq2zWyvZSXZDjpBRZu?=
 =?us-ascii?Q?pxtPpBJzqO+h9FeuOyWruM3tQxpjGByOMsGvu9fr5J70KKI5ENQ2limRglEJ?=
 =?us-ascii?Q?UntJIso6ScWaxQSdOuBTgSRNj1u6bZfcMuaXBblxG4xNBH647NnNEnrDuulZ?=
 =?us-ascii?Q?ym1je+yOM1tad9FQqLj7VrqEfRM+2o3kfv5HHOjEzks3tddfpMdlP7Qw69Cy?=
 =?us-ascii?Q?SJZfhyQOUfpIF4TEFff6TwOMYlMhvHuZ2qANo08BO8w1AHn/51ZPV/EoZtb3?=
 =?us-ascii?Q?a8ztZM3eFKWpT+hpZnp0BvaFpmAJsZtfnux/iIv0do2VUj9VRf0f3OGFlYig?=
 =?us-ascii?Q?uQqbB2/vJiXduxzXoJSPvkAVaYgrWQtha44xvHZOrH3xQ6HWYKt7OOyfm5KG?=
 =?us-ascii?Q?LcSrx09EipdbwrnMR6YjwopvRLddJccSV40E/YuEeSvxk7ekV7g1f6BT2xdv?=
 =?us-ascii?Q?is4VwQyNC5X0f9a2l+S9qP1aIgRYORyRwxvuUqMRnryr41qFEjxStENB8wee?=
 =?us-ascii?Q?pFa5vWEaPIwpFrbcjiL6s0dYqKKcluFIPGc1h4zAGwsgrBFXpPX0/3Kj0Mzg?=
 =?us-ascii?Q?fDv9bXOpQklZUP7gRSfUKcYGXF40nT5vblLYATVQO3d87bFn5OWYjMLkI26s?=
 =?us-ascii?Q?nirvnjEBis58NhKwXqGNhmjG4C7fGVOepHJZ1qAV7p0wUFSDUtbRLk4sCrPv?=
 =?us-ascii?Q?hyBEziRhlDIbMVVGVOhAKaChjLVTDL99dEeeMn5N6HMFeJ7PdfJ8APnEXpLp?=
 =?us-ascii?Q?KUVEZC3cgojtKBjQEHdKPabu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee8933e-c776-4f35-195f-08d941958fc4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:26.9075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMc+f/Tv2KTuvgcsFUTDdXCzBuQTszKIiH5qdhB8b7GM702doOmIPfgZQeZ9osDKdicLPuT46dGVzSHM2JMQQXefNzGKxuujYufevuBhAxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-GUID: K6tRdJu1XyRlw8DI7GpGmrAX1q7JqEeK
X-Proofpoint-ORIG-GUID: K6tRdJu1XyRlw8DI7GpGmrAX1q7JqEeK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test delayed attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_attr_item.c       | 7 +++++++
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index a23a52e..46f359c 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -59,7 +59,8 @@
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
-#define XFS_ERRTAG_MAX					39
+#define XFS_ERRTAG_DELAYED_ATTR				39
+#define XFS_ERRTAG_MAX					40
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -103,5 +104,6 @@
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
+#define XFS_RANDOM_DELAYED_ATTR				1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index a1ea055..e688ac9 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -38,6 +38,7 @@
 #include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
+#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
@@ -301,6 +302,11 @@ xfs_trans_attr_finish_update(
 	if (error)
 		return error;
 
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_DELAYED_ATTR)) {
+		error = -EIO;
+		goto out;
+	}
+
 	switch (op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
@@ -315,6 +321,7 @@ xfs_trans_attr_finish_update(
 		break;
 	}
 
+out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index ce3bc1b..eca5e34 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -57,6 +57,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
+	XFS_RANDOM_DELAYED_ATTR,
 };
 
 struct xfs_errortag_attr {
@@ -170,6 +171,7 @@ XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
+XFS_ERRORTAG_ATTR_RW(delayed_attr,	XFS_ERRTAG_DELAYED_ATTR);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -211,6 +213,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
+	XFS_ERRORTAG_ATTR_LIST(delayed_attr),
 	NULL,
 };
 
-- 
2.7.4

