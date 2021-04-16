Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C7BC433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC6756117A
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241719AbhDPJTJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:19:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35044 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbhDPJTB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:19:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9A3f7026508
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=EV9q4k8AZpweLkPAyxKesluVzWS5H21v1FeXMBiMNN0=;
 b=W/9v3JDo74cQnDYNuAOnw1guMcyQnJ5NXlFwMesAyFV+Om3CBd60GzwM81EeyUro6wKw
 z3BamfIfpuqLJEZb+hoXnpmxfyMDCydkjUz2tsRsgy6HdFYKW8E2KsoZhR/qSAjmaaOx
 D/FmSnzEyNPtw9UYrn8G8jYF5pubVhBXzs6poo/6vV/JET05ug/Oo32MRtmfEkAyEZuC
 lIsi6+1GQoMG/xma6dm0kq3RUQYWmjAdaV39xk+OaSoHYozOuFe/5bXN5lVfLmUjtVQv
 XhfD5LJ02f0aumELuMwzf2wqUXO1eA3xat73aEy1qxHgv4NMNjWWplaLDVGG+1cbWG4x 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nnrh8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99dBO182009
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 37unswy4uk-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/MIpCNLLNN7BPYvG4T3gLOXmNQpMkpHpP5JNSfmR42hL8GP0Kj7ObHd8CEWjZMTGwDBmQwu6EgbwmWk2TvmqiXwfkRV9/UtdGMSYcaCcp8/M1v02YJ4BV9grNLEOl5Mqg48FMy0uIlEn97r7qohc4iyE0A3CkI9UvKUfi4Obd2OGgMAYyiU+GflR5oBlGC+o7iQaahQM2EqhP6SZ/7u0FHvmzaeEBA8HSWfbZoq4jInQz+D3ipoDH/r4D5mjo6+VDQSn4sUWQhI5AsSlM+Krvoq75H8ZvWzgQ3RSExgyGgm66nTch6NkG7oYOARf9xtnmU/hRpf2gOG2o0FjMxMjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EV9q4k8AZpweLkPAyxKesluVzWS5H21v1FeXMBiMNN0=;
 b=SrE7JXvoVjlwR+UHLTEaMqlk/rJlgOWfCqkZWjGNrRBtnZvl+z4SB3hwHMsyDq9POTmvi234nJpuKyUejBMof9cYeyQFm512YyIVF7vFNlNC46Xp6QatIwcfON6Pu0M48ab3k0o+Aw8iRf7VcNRiFHJ2SvLaLHjNtU6pY9KkeQOUPC2Y99kpX/ewOzJKifv9rLBdjzDT43v0rwmU2Aw99u5yXQWeqGNsKwKIGmmPM9rpXYiKZfTzfCPWc6CSMTdEw2WDgtlk0sTkmXMu7t/5PjZaVFm6oD4/hBhJwq+fmtrwkZewOeRLvejcCDcLO9wOJJC0YbooR9FQQ3Z+VslwLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EV9q4k8AZpweLkPAyxKesluVzWS5H21v1FeXMBiMNN0=;
 b=fskzLEuR3sJR8aW5pIwVVHgbavCowySPTYuXvlLXdkDcx/k3F8EBi6awyzqiESzD7EP7l3ISl5Soajoj3OswZx/AKC/XGyb2XTQYHfR0ef4p2ywib7XKkX5uGg3F8n7a6ZNbRNzA6Nq2qpEkeOzdP3WNdrucmceohuZNHSyQnXc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4800.namprd10.prod.outlook.com (2603:10b6:a03:2da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 16 Apr
 2021 09:18:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:18:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 01/12] xfs: add error injection for per-AG resv failure
Date:   Fri, 16 Apr 2021 02:18:03 -0700
Message-Id: <20210416091814.2041-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416091814.2041-1-allison.henderson@oracle.com>
References: <20210416091814.2041-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:a03:60::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR07CA0070.namprd07.prod.outlook.com (2603:10b6:a03:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:18:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38cde69d-abdd-49a5-b219-08d900b89a64
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4800:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB48000EC427BBB2AE7CBB682E954C9@SJ0PR10MB4800.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:250;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x1Fkb0YA+wlYvD8xGc2CQHdVuH6VKl2X48uyFhdONn2oaWwXCi9QGzJjH0mlvhLRYWl6bMQdQQaq7jS9cVEBkx2Nr33SfesRPoQeHtdQydVRChIfn8NMxhVj46er/5gb4MVqBRWDoU81XXLnN/g4/WzaFX5OGQ3zh+blxPtavRYNHNkOArftGe3uJComKerwD+R6UhuTAhuphSYPrUD5/rBwBs3Ersp/0NleELR5nI5jLha6U2uws3Kxg0m2U4ZchmzgsIaO3FLDsJxuKrbfPRtFEIC47fgsGXIGCgb0xdW3ACaXaAN7KalK7X/ogooyla0GDyxwZz3E4mNuEWqB6ctTvzOXl/B/fuD589pITjP4FmhfttlOsQ1kOXtEr90Vh0C2EaiNUDjX/S09xAvHTEbCtuxIRhwpBtlJ/unLMD2LbA54DgPq6h4VqyqL4AtL6UcLenyMzaYF6oEhwsTJ1PbyOBeHMR5RoELcQqFsEHdOmisFRHBuqkJdXehkMaIIruj5j46wnvXeq4sUvzFj75aXLntSzPeCHVWSPPa3Tiqk9xQD6mMPsC6o+c8qQkaioFfy4YCzCNmuogARiGPo+nTwaKAlVDfLDic6Q433cmWfJ5IqyxyXEpCRE1cXu25CPT6nFCwiDiMRZKK7lRJo0FxgGIDzgXzhRYQppW+GJaKZe5nuZw0IwbgDHBa/6vQk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(136003)(39860400002)(1076003)(83380400001)(6506007)(5660300002)(16526019)(186003)(508600001)(316002)(8676002)(6512007)(36756003)(8936002)(26005)(66556008)(66476007)(69590400012)(44832011)(66946007)(38100700002)(38350700002)(6486002)(956004)(2616005)(6666004)(2906002)(86362001)(52116002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ymulaCMhcS7E0mjj/o92CLPvvjy+dUY//SZFn9ifiSXsVG+Gr8GDa11tS6ke?=
 =?us-ascii?Q?v3gOC0EKYD8pRQFqR6quAc5Q3tgAPrtbzqCrrjYtlxXcxSVMZCoGwThQ0c4h?=
 =?us-ascii?Q?KsQkTqtcrcKZBtWmGVsgbM8xhEIqMJe8OxaXV/+6lKgwJeuQskS4W/xUFT3W?=
 =?us-ascii?Q?C3DHLM6iY8bcpFY/rSCljHltrqOpkU5stfmpof3a3bdyA0M3On0btyxnyTdN?=
 =?us-ascii?Q?r0Sk6nS+Az7QbgHXn0HxRZHCfpCL/wdFvHYJQp6POQ0t1sywFAA5HQH75zlc?=
 =?us-ascii?Q?IsuICSjnGTGF2dfGnMk3swIwFilVxmy0twe0+PvgWZr4tJ/O8IzG5jE0ScpS?=
 =?us-ascii?Q?SIAcfM+q1hOttQBbVwm+m7FtLS8hNTxu2a0m7J9ZALEznazZ2jd/aB3E7odQ?=
 =?us-ascii?Q?1Nk1CUpxkzMMdwydLWqxTAIv/4CUbII2sZKl/K9GmZcstMyoj9SlJrO5u3Y1?=
 =?us-ascii?Q?lYb+xIHVjLYHxn6Uf6EhiUnIHl7Iq8AyKmNpNxGZ4VeIocOeIpB75kgeFVEf?=
 =?us-ascii?Q?krNjBOIs62ZHgw0RpWrFYerl86Bi+HWrWmmS2RJMI2NPfVrUqu5PEZhzYo5a?=
 =?us-ascii?Q?Zs6cwfK9hXogtIvxREQyTYRuEumDqB53GqZtK3TAAO64EJTd8EM0WoM+dxCp?=
 =?us-ascii?Q?xId6YssLPL8sw2BkSW56qWG73WZMb0YkMrLi6SYqG+MS1NDnF4BB/WVsYD29?=
 =?us-ascii?Q?jvCoBk+0e54I3xmG91JJWIYaQT0lLZClWjXeDK2C9wvDGITITxQtbgExwmOd?=
 =?us-ascii?Q?RevLmexN0yA41U9xLUgMfU8sjj2OHw+PoWg3CoBrevLcKoPvF+rQpfyxupPb?=
 =?us-ascii?Q?+k+3D2Rr1Yrnc2kRaBsk52TuuBZyKaPtVeT2OzqYUEvHX20/wAummMkvC7+1?=
 =?us-ascii?Q?I2RLeug5uOPYc9/zFQPWH4mtHN8/eXlFVN6n6sBzn/xDxTytkTOVPFN/aUjK?=
 =?us-ascii?Q?FpF6DirQSX2JgrpXEmuhZUcaQdUcmsdc8FTq39TVA1jZIEQIgzMkl4+Si/G5?=
 =?us-ascii?Q?6nJdwPHxMTFLIvek3R6PFNmYkjnIJJd+ZLZf7jHzXBNYGleNI4YmuRCyiUhW?=
 =?us-ascii?Q?gtdukMEVgKgHCBtDlzEnlZlxeytoCvOc5szY3CXdJoECzhxQ5RxNaRFaVaN3?=
 =?us-ascii?Q?sIr9ssWAgiLjQWETaD/LWuvchNM/HUZDPYUf6jPtjVeC9KFP94xXsXC8jsoa?=
 =?us-ascii?Q?32WxXm5vuMudQOyubDGfwmwbIhTfALtLbMwXNcgYzVWisnSQ9drbbG6OY4Cp?=
 =?us-ascii?Q?8InnP6qFy7iUyOBKCAzT3eBEp4At2cnoK6LIH5aMUzgb7SsGoC9eNSdb+HMI?=
 =?us-ascii?Q?fgCSWpcCjyCPNF7rrtOoO7Aa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38cde69d-abdd-49a5-b219-08d900b89a64
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:18:31.5730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTkumYW4x8ss1JM7r3lZU9IvYqVnNVtv4XP6Nd6v9/gwhPdY6ftuzKr9tvUKiopqu29SUrJ9WioHd2Vsn9MaWY+jrezeR0Nhq5JR1Rtc0Lc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4800
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: DbT2_TqMt8_lO1hDOu-7TaIzWla5697p
X-Proofpoint-GUID: DbT2_TqMt8_lO1hDOu-7TaIzWla5697p
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Source kernel commit: 2b92faed551173f065ee2a8cf087dc76cf40303b

per-AG resv failure after fixing up freespace is hard to test in an
effective way, so directly add an error injection path to observe
such error handling path works as expected.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_ag_resv.c  | 6 +++++-
 libxfs/xfs_errortag.h | 4 +++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/io/inject.c b/io/inject.c
index 9a401a1..0be1fd6 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -57,6 +57,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
 		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents" },
 		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
+		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail"},
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 530455a..9dc5bf2 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -210,7 +210,11 @@ __xfs_ag_resv_init(
 		ASSERT(0);
 		return -EINVAL;
 	}
-	error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
+
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_AG_RESV_FAIL))
+		error = -ENOSPC;
+	else
+		error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
 	if (error) {
 		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
 				error, _RET_IP_);
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 6ca9084..a23a52e 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -58,7 +58,8 @@
 #define XFS_ERRTAG_BUF_IOERROR				35
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
-#define XFS_ERRTAG_MAX					38
+#define XFS_ERRTAG_AG_RESV_FAIL				38
+#define XFS_ERRTAG_MAX					39
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -101,5 +102,6 @@
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
+#define XFS_RANDOM_AG_RESV_FAIL				1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.7.4

