Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA662C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245534AbiBPBhu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245533AbiBPBhr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B241319C30
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:36 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FN8hX7028765
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=QKRhngz1ig7RfzMJFbuci0mmSGtDzcNvz+nr47s/MiM=;
 b=iG1Uc5CWnkP+ZCrnEixaaDvXiXgVoDa0RZeghV6n4ED9s3SvfJBp5pV/paHdsys82QKU
 GnZZvIq9RDDxt0pORaXbzvXAg9ZVrjNYsDJy00oJr1cyO1io7mY+xnnwC9Za0widrWod
 EAr45vZ7ILTaPzAPW3Yvi+OuLabG4uNR4E31xJomMWLElvwrWkVa737Gi+RxqM3hqk90
 5iQaM866ccSf/15mLLp+LV3b9qr5kkrMvV+vsFbqFCwVCzvxANsT6wGTAWctwjWvCzZz
 HJVJT8QDgW3ysrp81ou9uZOY+oU/08RsfSXSAkjkSus2OY2UH7ZN2zmxa36JkXsuRmMm ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nkdg6kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1VQ5Y138923
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3030.oracle.com with ESMTP id 3e8nkxj2tr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOztVGeR3me5K5pz+VEluyHpaKInpL935W08XpSSfi9wYekzMsbkcVYbdfcyhw0LyinWHBaNt/8j9v9K3aim0g8iiuCC4c5RgJuX7FVNbO4ksmQBW8amTBHemPlQZTi15YZ0bPzaiTiDjxBK4ccSYQAcFcZeNJXuRZrKYSffNKFEF1E3J5eSpbjx3oTBwRG+lSWZu7Izjs871QQQ1tRU+WCBDZaKdDgzBn8+SNhqYK/hf1kTxBghwH+bwF9LATZBka4d3Xch9YL7TCJgd3MYtd2n5N9NcgrgLc84fqfr3P5wE7TTaVgRiUJwsM9kp/alpyTN4klHF1ymZI8dAvAmjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QKRhngz1ig7RfzMJFbuci0mmSGtDzcNvz+nr47s/MiM=;
 b=AS1oqjosrk+en6Xr8X8P8iHgcR2eJPMJaCAFtxXbZFmkeauTunOmkN9aQc5hwv/owfGqJq9smNkeotlUWM4EnZ3/+G08tT0BW1OmCBeofcQHj0f8J5CCgenRr4obX427f9p2d5TigTgq8Thzg59IhH6CtAUrzH4hufGc8jC3Nd9gVJTrVb4uuxV8V344kuYweOJYosJZ9fFcDYCr4pt7ureIrfhY1Qlh0sZm+AZ6oQjqUEkp6JHZg8X4fHDVilkuKo/BW3mPGwbkAYFDwKoEWP/SuCjvsouPgt8uxASCwO3zCbugDzMCL34TGDqfVInWDaneBWLLKByeaVaOrTE2/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKRhngz1ig7RfzMJFbuci0mmSGtDzcNvz+nr47s/MiM=;
 b=r7dAFkslkfHqICig+oVJCQARbBTG7+S6XOFoNGLeSNndGMIfaGuoc4Vtp3meK8ZRunznjeh+ussdx+w+RDnFj1tYMBS1EGBGWWNbyRMJ6tKNjkiPw59vTLJfY0T+VTAaYpxx60EeuBKpFC935rHM3H8791safF1GTE69H10aWnA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB2802.namprd10.prod.outlook.com (2603:10b6:208:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 01:37:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:32 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 14/15] xfs: add leaf split error tag
Date:   Tue, 15 Feb 2022 18:37:12 -0700
Message-Id: <20220216013713.1191082-15-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 60becd33-50dc-48e9-10f6-08d9f0ece281
X-MS-TrafficTypeDiagnostic: BL0PR10MB2802:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB28025A51C24E896551EEEC6395359@BL0PR10MB2802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o3kbmtla6rzH3T7HKf83yanr44hJxdKli3dkS0+xGH1n4YSViTSIn78tpbeljnj8341U6xA1sYi3hwVhlYJYZieuyNi7v77qTTJCWuJJEylUjwn28zn8jruYfKA0DdtEPmQCh2GnQQG4EYiLgYMqr2F3MVrq3oKBahzT0UZiS5MOptXbJhMb/qm1DYQkh/yvTIxK6GQL6Ax2chqnd3vbxmeo5PCEN9jWVZAB00QkCrXySOuxMBJqEK3V6mHCxV2sHS1yuXjgZlqpXbh98USCjczL7krFtqh9JJe+NbdnnCsw2Q/fJu5FLKRCbJdusF7ZhqGI88TlCqDHLR3EJ9sylCJ0QE5F+bvpLh/hmSgHAdvtFQ/RrH9nTZSemC67bYqOYLmIWnGln0x2tcBr8EEcm+My1S77Pn99F8bj8s7lywQxQXpwjtgg9jR2N0MHM6TJbKYER5rROhytfIgG//QXcCqzIj8CoDwxkvk7hvVyPCGhhhmuTI8BfKS60Tg8uXZVgfvmleGgNj+goVcS3fDLfw470WmhD0QFRYdKhUcxPQKvKMgjeR/fBMo9xBYRrpyUPSHmFWlQ0PuPFm6IDu9MJ32iif1CbS7DLhCTHCggMbcTM429NlKa8w+BwP6E4YyT9C4V7vaZvioo0JZc6vrBJUonItObmvxFdZinH40O6bsSFzZMDjz2bPPeAQjuA91cnigWJZUyzhgi0MMsXo6gOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(26005)(1076003)(6512007)(508600001)(2616005)(6666004)(66946007)(5660300002)(44832011)(38350700002)(38100700002)(6916009)(6486002)(66476007)(52116002)(36756003)(316002)(8936002)(86362001)(2906002)(8676002)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IMnuoA0QTWHACM6O2HoyGwSxNNH8ap2xAa7AGkN9WZg2e5mDdCKXZb9OgCY6?=
 =?us-ascii?Q?yVtpVwcYKOligUlqB2aXaEgBNVP7QHgxsrra6fKFWa7L76wZxqrcd7jmD97W?=
 =?us-ascii?Q?+9SA+tfiUh1wLSZaJFGa0KkhIUl6xqcLEpw4SGQdU5EM+qWWzUkpFeilHTyz?=
 =?us-ascii?Q?1lNRwWnRsH1FAtVRNRjUFQYLGR49PT3oUtv8Uf/NELWBmkiEU4Pqoob7GJWn?=
 =?us-ascii?Q?9UsB/aX6g1XHitVGAqvzRPgsJSQceRaeUw7wO2WLcer14EVGaq9e/WuYY2SU?=
 =?us-ascii?Q?9RUO64G6Cz0ZQeHzWoH1ZSKxeOdNAaHfCLElnXAtMzj6CGs0jR2AvOAaY4dJ?=
 =?us-ascii?Q?msHMe2QPOIm4Byfko8ExVNlgb38KJPza1FEOxkQhFg/saSYjtGb09gH506bs?=
 =?us-ascii?Q?qkJRtknSg3ht8o8+JuThx3dqA7KNoraq2VI4ytuZWswruV+xLQuCcBEbIg9g?=
 =?us-ascii?Q?LM3A4NV+ynSJp7lYEWycndnWOW5F/8i4yArhFQEsf9DjDbRyAgxbVbt1p+Oc?=
 =?us-ascii?Q?cwUK4mOoWj9KfSXjXAUm6vDveoP6iCpeYyC91+73DFi2vThnIgLJZtumYkVw?=
 =?us-ascii?Q?QNcX82xoq+x7zP9VLFlCqYlN7kPJcARveUam0qOVIX9Rq65VyPuGUFt7ISuJ?=
 =?us-ascii?Q?vkHWC4Yeyg2FUxs7xp9zOQ/rUV+ca038Nc1BWoRo23zLMrDe/MTbWEW9QaPr?=
 =?us-ascii?Q?z5EvXEystm/wPRc8o5FghmY96lQ5btmoVpIpmmxj3DhqcwIOqCeiQtSeuH/k?=
 =?us-ascii?Q?ybHPOOIsOaw5F1TmHp3wWqKyowEJb5oRoJE/RlBYGlxb1S49TsuecB083M3w?=
 =?us-ascii?Q?g6N6jWtvT3eQJmYqRrjRr8brGwD4SwX6ZpwxaWRwATVnuT3+ypeYFYwQozHs?=
 =?us-ascii?Q?DoP3Ddm3lddtpNPNAwalf0a8JJbzxBrgrrHEbLklt2A1bmq5D3D0eeeOWAEU?=
 =?us-ascii?Q?ucOIdGqRhgf6IieSA2yY9AoN8/kLD+LzGPHM5IRGYFJAam8d5y4DvTFohrCl?=
 =?us-ascii?Q?DYESat97SAWZCUWdit9ICo0jH4g9Ns64XM1sk6JZ6gdh0Gyem1RGKJWAcIZR?=
 =?us-ascii?Q?Dk5jiPVQf8s5/p3cXOY/wwFmes6KCJ5fA2x585unEt6XxjmG1Cav8XMoMTWP?=
 =?us-ascii?Q?Jb2frQ8m6yokcm3VolA5ZRAg6BQihy7XQVKVhJh6LSAHXbQ+vT6ABHL4eEsl?=
 =?us-ascii?Q?XehS0lCexbqEYbY1CB1SeHgVNYPpO72yMk2ardneexJvrV0unmYwd7Dn+EU6?=
 =?us-ascii?Q?XvjYMaClhLZDs8iog6Q7GL0wkZgssdpKStw0UO+qdxHZpteEzwQoE9eKMNgO?=
 =?us-ascii?Q?UWbx4cK/ezFddfeqNq1rH+tG6KoIjXUbDhITexmjRwyzDr1s++UqchWbhYrW?=
 =?us-ascii?Q?wTLuR5UuAgreGeixLQKIm5gP3BbhgX1TBaKtH2gr8QddaxtF4nLu7lOJmH+8?=
 =?us-ascii?Q?8Off5un+NSBuoJy425oRdujOhnFV9p766T9PJoqSoeHaLahYQz8PAF6pDcSm?=
 =?us-ascii?Q?uoGVXz6vkhYZWk+4hzNTVI6Nj0oUZ6QTuQtIS0Ufx0dDvjKJQ3xOk/kHjxOj?=
 =?us-ascii?Q?O8qVV4IurWxln25lNRWrWg/v5eWNhHp99hBXoJkmpq8TldTqRq3QYxYVYKpe?=
 =?us-ascii?Q?gK3xIyAZKSLY2eNIiwYGZue81xou0HyD5riysasNeQq0cK4NyvJKgokb4Rv+?=
 =?us-ascii?Q?QIqJfQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60becd33-50dc-48e9-10f6-08d9f0ece281
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:25.3943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /fnGwevfXQz573pt+tzWX0FZ7MrIxgVynCjpZxZZADd4lqj4pqFo4R/MTdwhmk86jhX+XKyYhXR3IOOK+/t/VWPVQZOpanS1lbfbGe0SK3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2802
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-ORIG-GUID: NxpxHocL_5si0xuIhfyoifPlHo_wYVeA
X-Proofpoint-GUID: NxpxHocL_5si0xuIhfyoifPlHo_wYVeA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 4 ++++
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9dc1ecb9713d..aa74f3fdb571 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_errortag.h"
 
 /*
  * xfs_da_btree.c
@@ -482,6 +483,9 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_DA_LEAF_SPLIT))
+		return -EIO;
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index c15d2340220c..6d06a502bbdf 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -60,7 +60,8 @@
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
-#define XFS_ERRTAG_MAX					40
+#define XFS_ERRTAG_DA_LEAF_SPLIT			40
+#define XFS_ERRTAG_MAX					41
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -105,5 +106,6 @@
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
+#define XFS_RANDOM_DA_LEAF_SPLIT			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 666f4837b1e1..2aa5d4d2b30a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
+	XFS_RANDOM_DA_LEAF_SPLIT,
 };
 
 struct xfs_errortag_attr {
@@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
+XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
+	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.25.1

