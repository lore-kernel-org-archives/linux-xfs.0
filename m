Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCE2C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C5566128A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhHXWpi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 18:45:38 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32980 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230465AbhHXWpi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 18:45:38 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OJA2Fi025080
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=ngfNUC6hmrtrQ8bw+5q0Om5im+vQgjwxgLh8LBPmwrE=;
 b=jLOTnhpPagkJQmfuf6xdezU1+6e2krEOpAITxdequzc6RPKOy+1bJIcpQAnOjpSvea0b
 eQRNyDMcboY9UkY34jqCxfk4ghxiIEnm809+0N+ZU9QoRLIgOe062LXIIp7KQZKTQlo0
 cxS+ShXrkLB9puw2yPTW3RHqyJxQAr2A62w94DGKqEjq6gy5/RBrlc5/DhGLks6pVe/F
 hGHFMZ8uip6pQKHErjLXXMmF1XUBn8JS5Jr403ZjwaB10pKlsHwrIJ8jw4R3bMoM8Nnq
 rAL/pwI3Dxp7um5xx1vcBrUeSdfWcfNJuRzmFfirf0K9p4Osta+wpxwK1uifI+pzBguy vw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=ngfNUC6hmrtrQ8bw+5q0Om5im+vQgjwxgLh8LBPmwrE=;
 b=xJhP2JPM1+zSlfzOCrqt2JisBH/t1kJUNdvDVULo6l5cFULBNRJEdnrOaftgQHSRx/R2
 nCfK6Tcu5hgTOqK4Qam4YdNxVlUjcFNUG/oJqUZzb6jp7YtDGhDY01Luk3R2Svxq5ABL
 mxQphRP8WksHFg2Ep2qCeBmhlH4x3D30I8IO9S5gWxGshDASbqwTy9MGb1sJNUnOcK3e
 EOgkhwkCkaG5lvWRY/QlwxF8kAeZqsVS8zLrt4JVkKa5CqHTDwWcSuXZjWiYUTMcK5Jy
 y8bmrgWn0bHKpiyFex1GD69/k4h/f5bkk/ZJ57KJxx3A/H+0nxQgnPk7N6LzKhUl57dZ rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amu7vtdxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMfYQ9025324
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3ajpky4yms-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+PaLN4tm1BzA7YeD9vc+aNu2UMQrxYgaW3pfLG5B2Tu5s680vKm9Y4tpoNboUVyhqQ6kFgQ0QoqSt3ZUEtojVHgtfpcCaT/QVPlyAZIkHqKXyRJ7V3booqgwU8EP2fb9Pk7TwBw1MH3DnwoULwWXUZGMe/v1+QD4KxuI/X7eQsKWnUuf2z9ZRAnR5dOJRljW6gaDqnneoo9DmKIyxQAuW46KFSre5bGWQrn/EZSADKQVNhCzkOMr1zxRVkaknQ2H8zbDUS6LtZ9DvDKYI6INxA7Y9BVfrnQnAfC1bHpb9nckaOBca4mQJ+n3BgW8t7ecmOmzLkcw5My5nLn+eDLPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngfNUC6hmrtrQ8bw+5q0Om5im+vQgjwxgLh8LBPmwrE=;
 b=ezjGcDiMs1PGVJ9IBug/XNFF0h90lqa02qw1GEIqqoX7Z9Rqdgplf1aj477VPgcaYhofwyTZnXzmTBiYovbcR/NXZ6U2/BI8mF5gqeL2OuXz7U65S3EShTH8hLj6ie7HhhOGjDS0OqtUHhm/gkVPnFy6QtZbVORZ0Z582W9nyKvG4BqzWw2afEvZ6AiVYzZ0hE4DQixEiLp3ZsAJNDWcGCzJTt7/X3I8Wj0QzeOQoW2PQc2BVz6EHrxqV12AjL0iMG78VUzj1oYccbDJzLMWdOkkjoqNKgxSo5ngnRgudT8v04hYehe0TRCa0gHULf3pRkfMijpDTQhCKesN9kW2Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngfNUC6hmrtrQ8bw+5q0Om5im+vQgjwxgLh8LBPmwrE=;
 b=Fy3RhLtd/lMEh0ZnDWe9yfjTjuyFD747yo310VC0SXKSE5jIvwCc7P7lbf9Y0NtgPCMqgkQjFJ8THTZu5h8+NarWgwVez27ebUCDHp9ydP5lWGfjtHzVCgNW8eKkMJuKyEUDtBlLtYwvoSiTDwyWyQZ8vnpFflQQOlYFwy1VvI0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 22:44:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:44:49 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v24 08/11] xfs: Add log attribute error tag
Date:   Tue, 24 Aug 2021 15:44:31 -0700
Message-Id: <20210824224434.968720-9-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.112.125) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:44:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae7371aa-8136-4a71-c270-08d96750c49a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB465374FEFE920D1170C008BB95C59@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Smjz34EFB/mPnOy9alfTk58HdxJCxX0X6VWBgQDt1EyiIsmqxRrGfZbW4RSH3lm/gUupfs7iUFa9FvbQF/gVGiUOae/6dFxGrVf8ZPrSTm7flgEQfaUVBWoZelK9rdSNZkBSgHHypYxFwarsfP0+6IOzVIC2myp5ua/bY6USyGu3IUdf/gUyQHIlkbD+d1ai+C2SFl3O+xpITN3fjjeRkdY86Zj6YZn7QQ0c7gBJuhwq1a6ZMODd9uC/Ou+urnU2i8cwbbsFkyGSHCIoC//9k41UKgQxSQ+q1Uny8HR4GGETmomAX2tIw6UQQMMOUj+RWCI1CAgGkf8MgcBBoKH2OMjAGC0ZWGrXogXwyRJnw29nKta6oe5Ym9GTPEf7/R9hV0c0BtE3hQKr2TkdRQ37Njdn/OUrLeFoR0V4TmxyiuYF1WziClAhTPAa1UacWnY+3H7ndrbU7T2Iy/nNQLyocj7NFniFeu99wedr982oSNd+8UMlxZ/aFadoV/MxzDNtSaCYJsyIwkpqnPY5TnKZT3k0etW+DMKRcP5sYTwKpwhCtkVAVCWUPWLsqkJHhxp20pKW20Yu65tgbapVfHVLEqW5G48xKJ3wvPemaUxvfAMuKp3V94yWXmxmdQh9A9o0eWdGIAhnt4EhIlewy/ge5fT52zG6E0Lmkj5mI81UnULOEywruLIG23v0ipDB1pP1Ww5KRb0kC8qLKpmV0Jeifg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(86362001)(66946007)(83380400001)(6486002)(6512007)(2906002)(52116002)(186003)(6506007)(66556008)(508600001)(8676002)(316002)(956004)(8936002)(36756003)(26005)(44832011)(5660300002)(2616005)(38100700002)(38350700002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jKg2Vn0TAAunGN2Gpk4Cdi84qIe2D/rFGAPElUab//JeNsvSwB//wSN6gqJo?=
 =?us-ascii?Q?6aC5qVpduWnvYn1hGBOLJqmNVxmbyvY99XWQEOfpZCLovI+GOzsHPT43x7Rn?=
 =?us-ascii?Q?GEmclQ7QBVaa7huFGrY39ObiznrDtVzPMGQSyFSVd3QWHYI3+W8jHlWHVtcJ?=
 =?us-ascii?Q?AfUaEfGInfP0fKLg3tIJkT45ntJjf/XKNo+X6hUsf0uq/oLr5mD4pkP8EqR8?=
 =?us-ascii?Q?r06jrcJx0Pi4szL5MqZ/VAoWpLm8QwoakwM7gMmJ8g1IDs5p0VeFH3BcP3hi?=
 =?us-ascii?Q?klmf1ZuKjyNCw2lb1Uq/uW77pSxK6WY1Va2B5tTr3cnNTE/l0wwKl4cns34o?=
 =?us-ascii?Q?PYc3bD34stBJUGdGcx4Hg3nrWpPsTZWPdVpPYPx+kJjlyAbXxTtQEh4KU4kj?=
 =?us-ascii?Q?BJLtkK8F7RzEM7nADUkPFpc8KfktB0e+uRJ/F7l0147DVlaZ3Bt5Vz08aLdZ?=
 =?us-ascii?Q?CvsdGKX4jfNKFKQW2EigLKXXHcMx7MtA1MN7HZRxqIAvNkg2aViKEoUTibhX?=
 =?us-ascii?Q?AYd8WM/jZderUFigszLNwi4cflrLCW9g8FftgWUAyda23LdbW1b0nTSd/NOQ?=
 =?us-ascii?Q?9KoqeKecogLptXY2r4JdaJgejgDTWJELV0yTlVVXGVFrQlyADGNCOkAsvb6W?=
 =?us-ascii?Q?BAildVkfIwYuNOQ/lRgeK/iRzVz0cgLMXF7SbkWQ0WMKA7xueu2VvBp46Ies?=
 =?us-ascii?Q?SSr6DecqR1NoAmwC5zNY9hZ5QmQu8gc+M6u3v1ui+ThowyXwJFVRU4Q+n0Zb?=
 =?us-ascii?Q?TnNE7L1OSINshox6rRcAzlSQlaTkegrLFewbfA7BG3wAipccCQpEW5da8hYO?=
 =?us-ascii?Q?K8+lJHSUS8bQE9dfuX2kGEnTtUOOEQFKkJfzpdYsS8JfY8TQnIXoQo5FMz7A?=
 =?us-ascii?Q?a27YB9oTABdzWaIhIL/Do+lJ3jTs2gIwWRgeMeyhSqPh26WZ58y4WkIVmcvW?=
 =?us-ascii?Q?FIKdZZzFw7m9CaaQu6nzKAnEAgEAPNvDeL7MQmvGGoQDTnG+Y4A4dRTvY7sd?=
 =?us-ascii?Q?aRlzNjuqBM7sEkwTpewn2b3TGIYWIMApmzsX+uwzXwECVW4HB4SX7m3RZXTV?=
 =?us-ascii?Q?wRbXPunxB0CbdklkZbCU+DoUGsSLbzlN5Y5wN35t32i9RdNUEup18QzBA+px?=
 =?us-ascii?Q?E49rrpMzVZ1OcKSETDytpSixdS34eTDHzdtY+vmFjkI7M8xT0aDriaLSkIbp?=
 =?us-ascii?Q?kvAc7RoEPSzmbOllRHFbpQpqWw9riDL6j22382TurH1cIzcvS2w5z8M5T0xF?=
 =?us-ascii?Q?8zPx3KDkMHU5boQJdPeh1RBYgLmrA2Qm2X/s0Sp49wM6YNH++GhUHy0/oBuG?=
 =?us-ascii?Q?9GTGhal+IfEZlH2jZHTtLKD4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae7371aa-8136-4a71-c270-08d96750c49a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:44:44.4740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nVhfX2GuM812mQnRdFpbWNPRikh4cxFZr89Oj2cS9qlOhcgNENz8E4CoKduAfpO90nmgti4+3NnnWsX9oxCR7a/kOm7LM7nMP2Qw1j8JjNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240141
X-Proofpoint-GUID: rYuYbRovr7b2wI_yQ5aiYZwdgJqKbUi2
X-Proofpoint-ORIG-GUID: rYuYbRovr7b2wI_yQ5aiYZwdgJqKbUi2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test log attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_attr_item.c       | 7 +++++++
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index a23a52e643ad..c15d2340220c 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -59,7 +59,8 @@
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
-#define XFS_ERRTAG_MAX					39
+#define XFS_ERRTAG_LARP					39
+#define XFS_ERRTAG_MAX					40
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -103,5 +104,6 @@
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
+#define XFS_RANDOM_LARP					1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 928c0076a2fd..69646a8b6e09 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -34,6 +34,7 @@
 #include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
+#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
@@ -292,6 +293,11 @@ xfs_trans_attr_finish_update(
 					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
 	int				error;
 
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
+		error = -EIO;
+		goto out;
+	}
+
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		error = xfs_attr_set_iter(dac);
@@ -305,6 +311,7 @@ xfs_trans_attr_finish_update(
 		break;
 	}
 
+out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 81c445e9489b..d4b2256ba00b 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -57,6 +57,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
+	XFS_RANDOM_LARP,
 };
 
 struct xfs_errortag_attr {
@@ -170,6 +171,7 @@ XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
+XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -211,6 +213,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
+	XFS_ERRORTAG_ATTR_LIST(larp),
 	NULL,
 };
 
-- 
2.25.1

