Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A719C433F1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1449861A40
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhCZAcE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhCZAbw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OaYo111335
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7iRM33BsY/NjjvjomNMIp1CjUrXUdg14KDJF+JczEBg=;
 b=MExHSqLjLGCp1zFxZOjttibYM8cQ35JLE1MBOUbrvb7crNHnfaZyBaILTFKQd0zIM0B0
 0hMCoQ3JqWiq2B7yOclCfqz6VQC99DSVuwgUCqNjlGo022MnCTclOuJE1N4oeBRcuRTt
 /97+rwSxp+nJF082SyNT6nos6se4laOZVodKGvp7N7MX3s/FwZNDyPbutdWYYLk9Tgr2
 UXdQQo25xklqvHKifY1xJGJ+tW3uc6ErFA/mHmipPeZ7EvOzFdXcfLAbF/s7tGt73YXn
 ZloOiQqMzO734bLwyn5OnJsH6VOsKg5nf6KTrZzSe+RjhyjNO6iu5+6ngVxOyyoN26up 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37h1420h6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PKkQ155633
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 37h13x047t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehlEOs/Xm0XSw96GIBr0UvmWMtE/o100HzTn7dJgaHyhS0tkmru7hdpRO34qTePdjpH1fS+Ld/QJGhscak25FSurg6kg/LC7WBWzit3L7g6xTVM7RwEHLoa5VCbsBfI5dkDIoMFnQsOQulUjIgSRlHf3FVmS7YNLjz0EhiJdhKylTM+6fOMi4clj/Ck65uQgtybY5Aj1a3VSIp4cbKM9grj0V01YCVi9wmjV94gRk7IrdKlxl3Yq29wcsUI6/Y1NdhGdEo9KhxzRy1IwC3LGKbDSYRWlx4b5GPrCNqpcOapDLA+TWoc9V8gQWYd/YQ0tVhUT7iRhvhx8UtQoQxpRTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iRM33BsY/NjjvjomNMIp1CjUrXUdg14KDJF+JczEBg=;
 b=jkJI2FKfabKLci0xxUVRqZEO2ypumKD75sR/Gq5vHiLN2VwfBrb2o723QotpU7KS4bdB+sPUta/e+dqB5kWdVUky+vXGLE3UkiaH4g4C49fv9zjBU1oh0/3ziXpm4mEaCFybSVUkI+xtqL8sB41jaBtdKuZ7Vj6rcqfoFzm7GiBorqXD9hCTX46ar/+vjEXvluBoAtuhWEkqJdv2ydcofI1vel1Yw0hNPRqys3P5805tWPFvGJElLU6TCGXXnsogFmz1kUM/TqHHtfrQyzRj+N8FV4MzvT+XZ4rzZtAU6K1NQIrMro3XfJLnhX+0+G20RbSjbGO36cg81CnJqC0+ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iRM33BsY/NjjvjomNMIp1CjUrXUdg14KDJF+JczEBg=;
 b=Hb7cCbo9xaHRcHTl0fKHznf1p5iUtawTZ5dwklCWeoo6+UCxs+lPQB+0jUbwc7DdXdy8aKf3ej5fjdLL+QWV8OBsyKU8dJdgmEywCu+bhDHQG5p84yaH+ROX/SZBotzl9wW4kekZsZh5ozFobPofZoVeoS5XUvxBP3gA4q1VTD0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3924.namprd10.prod.outlook.com (2603:10b6:a03:1b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Fri, 26 Mar
 2021 00:31:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:48 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 17/28] libxfs: expose inobtcount in xfs geometry
Date:   Thu, 25 Mar 2021 17:31:20 -0700
Message-Id: <20210326003131.32642-18-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9ad0bab-2dee-4958-73b1-08d8efee8a73
X-MS-TrafficTypeDiagnostic: BY5PR10MB3924:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3924A580CC1393F4680913FB95619@BY5PR10MB3924.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:534;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sH6B2RUqtnxJw5zSivRRHzbMd63M6k1khLOhy75JnuVJlvT90Msebh9usuDSs2CGxFwQHhhcio3adazmi9QvBDYHtXYrlncOvYG7qYOLRfj25TCuuf4KPF5IuIakWKchXcalJY5aRDZ/MwcPZiMTB6XrWY5dotS1885Llg3AREkGvK2BVlGewiz5NF1JnLWMoQkMLCEGjKpV6sBLgHj/9dji5PCJ86VN7agutQ8pvEyC5JtWVG6XBkvQkkbAuwStrqibfY4rrfg4yUKhsPIv/VCQFSfhS1TTS3GjLkJ92mSDpezJ1fzf8OqXwsFisJxVOTwPFeliDQ83/yoDpVHjU9hg4rtLlE3/yYeaaihTkyiJ3142jTfw9Wnb/zMZq5nJm4+Z46eJjeSMLYdV60gW7Y7YcbUAlFnWM8OFHqJYjMFzTGUNHxekSiGC32R65HtSYOGgqLkhIp+/nrRa/xeX2RFo6j/vRG79WH14THhd7TYSwLBwjLgh4WVChgM+9PIAeblI98PbDQOSNRLcC01lXI7bvcVp8NaaTxqArXmV98PFnZtRhIBcZPCX0UhY2eP4svmm+e+8NAV2pv6/1i5NGmV+Hive5sMdkLpvix1yB0Fcg4e49AbHuh9jnswsU48jx9UBjPnSwPZZ22VeZTBRZy0+GtlZOFsQ4UpLYxKRBUJ79gCzONi+akyuxk1wCxlA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(6512007)(956004)(52116002)(316002)(83380400001)(8676002)(2616005)(8936002)(6506007)(6486002)(1076003)(38100700001)(26005)(186003)(66476007)(69590400012)(44832011)(86362001)(66946007)(66556008)(5660300002)(6666004)(36756003)(478600001)(16526019)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZW0gu/F5vyVP6A4pmjsav+BvUsOhyneej+OuRbfdmOA5nsFJsKRh6vfCcEai?=
 =?us-ascii?Q?FERiqY/nZnvzSRDY00bhFt1cKpDpEh4SA4gVZiUyb1y0irGps0JPrKmY7d0j?=
 =?us-ascii?Q?QnMwTLlHE1Z/mg0SxuaLmtg8Hr/AsVad/H+2ZAIa1biIeYWRWHMMcbv/dWzp?=
 =?us-ascii?Q?a7PvbgL4JLbP8V3osXLFhjblBQRUsPjsXwlE/htyl2jpCOKdYrnXoF7YBJFn?=
 =?us-ascii?Q?9eXmoqt9pVNppEHzqj1GL9t6uG8T4KuWefTnjVu8qBsdRFpdqMcHtmHiq79j?=
 =?us-ascii?Q?yJQpiuPDdwksrVHJrceYnxHK0pe+X6SAhOeHizRUgfqpmhO8cmtZSB5vuHmM?=
 =?us-ascii?Q?32F8dUgB9H3aeQnWpbcZ0NaacTG3YHGesNC51fz+kVpp5k+0t2c7wlg8s0kO?=
 =?us-ascii?Q?oUMo/ZA51UleFN+sGh7XwBqvhVWoA9v5MNm1OAr1p9SB9NKdighYKm6/6G6L?=
 =?us-ascii?Q?sI0vCC87PRhSLtmTNzUbUHiyGIj9kC2m/OEt1tO8f+YSlDN33TFoXgfSAI+k?=
 =?us-ascii?Q?kJClwkYOa0bYT1ErdEtpc73tqACos4twX8i0Oo/OaL/LVF4uwyTe2mb8Rw5t?=
 =?us-ascii?Q?TP1iI3tEkFtVgRcfiwMdacEs8QkKPgnZxbpFxbhpzIyi2bts9RVX/zZjeFnP?=
 =?us-ascii?Q?uaVjj8GPj8MDoIiCmLPW2+wAAks9fotFtdWDdyIIWfvBPFlAt+oW3kHloqme?=
 =?us-ascii?Q?EsBRvBrn5n/imyXCFCqageW0rRYq3OU42568U3kqk1fuWKeABIOrHKK+Kkw9?=
 =?us-ascii?Q?fQK0WvIK2XtHPEznD/QkBFgTPiTDAX/l1o7Rft2hg4aNPD5tuQkasS+YRfH/?=
 =?us-ascii?Q?7N+ZZUWhnqVVDN30uhGGBvdIOeHTIV6Gnqq8XPQmt/ImvkjqLrAovPXl9r3j?=
 =?us-ascii?Q?sutbRvCghTwbdo/0SUI85fvnRSMRw2UfgKpB4+RejC7cEvTmrI2BDNqf7mic?=
 =?us-ascii?Q?dDEj2HvISft/t2CDDDV7tjxPRUfn9Su7hsenWwS4ARg24k//hCJF5rIOKdpf?=
 =?us-ascii?Q?gEqykF7Mr7RlzyWOSc/WYHIAlkt1++opCq/k6g3nFT68H1940CJBKo4GZjS9?=
 =?us-ascii?Q?FUL8Fr08UMVno1nZ0IAzZDVXmyVBUqhamo0si3eoDxWi4VP22vTnbUWITE32?=
 =?us-ascii?Q?dTAQsGmwKARl3OKHpT0HM7dhV59u5s7X4eDLcAkvmKMoNhedHV5qMJyqH9K3?=
 =?us-ascii?Q?C779Igj6GXSYkn6IysVZWrXxscYO8cUXO/CdurVj+Sl6F02YHD+esJRC3ILM?=
 =?us-ascii?Q?mZvbo53nk/2Oz+R1GV9nzsfdF+MR7A+Ezpfer09YLwhKRrsxnceBfIXJCxXf?=
 =?us-ascii?Q?EknACjgPBXwavgXO8SoTceax?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ad0bab-2dee-4958-73b1-08d8efee8a73
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:47.8107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NltE45FP7/DB0BrFDO2XtgvXED6DZ9+8zFJtygKYBW9mLsL1eanlDRorFgLzBjKcyQ3A+7aXaWj0MXPdEY0Vzw1yoxXJq9CWmhMqv25sCsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3924
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: hZYM6BycFXqvyI2qUjhMaFtyUFueeDMC
X-Proofpoint-ORIG-GUID: hZYM6BycFXqvyI2qUjhMaFtyUFueeDMC
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Zorro Lang <zlang@redhat.com>

Source kernel commit: bc41fa5321f93ecbabec177f888451cfc17ad66d

As xfs supports the feature of inode btree block counters now, expose
this feature flag in xfs geometry, for userspace can check if the
inobtcnt is enabled or not.

Signed-off-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_fs.h | 1 +
 libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2a2e3cf..6fad140 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
+#define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index f105d2e..8037b36 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1135,6 +1135,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
 	if (xfs_sb_version_hasbigtime(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
+	if (xfs_sb_version_hasinobtcounts(sbp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
 	if (xfs_sb_version_hassector(sbp))
 		geo->logsectsize = sbp->sb_logsectsize;
 	else
-- 
2.7.4

