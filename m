Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4A3C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CABBF61606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbhBRSpv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:45:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44156 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhBRQrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCsK180357
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=CjI+abj50WR1Jpub8g/BG7jETIgA4+It8y8CxQ3v/Gg=;
 b=ZC3oW1PyrKm35Hzq5JKO0Kbi3OF3D6AE8Ek3khZBE2axYIZvyAey+3aEvwsXFRgQ9kTH
 HKQrnAd1azlHp4nzAroJ63OiYBQ/FD/CmBH5KNtNKH/9wyGCLDb8Kx9W2vfcuwNrpMqD
 eqL60kQNcQo9e/nMVmCwqQ199nVA0b9KjiwqauFHIDQG0O6MafyZ0J3UowvJ9SFfVFxb
 Wr20yykwlMoE+ZPXfwAqbayRAhMgap3xbG/IS2wxq5cuDY+2LU8UM8Hh8GWLdJ6o8eOe
 BUtOhGYz/U6jG86/NaZ3NtvU3xIeBkcCTfQk3YFZesIDK7G2hZd9slmAqSnU4I6ebeF4 kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36p7dnph1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUCaA032333
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 36prq0q51j-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:45:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCj5nJ46YkHOn/I8t/PIbH1VtwT5RgxtY/vzTKvntEfYc18in6acfLegedQiSPDw5qNQh5QYQD2h6y+YRLWdxgOUUIVdZSuMl+C1Q2+4FEaE/2WabgNXa/kzrxDi/TL2jEmpCZfT4PRcmZOv1/4fhLXDnwbV1tQgSlKYcIhze/l2v6dmveahZ9ByvNrdlmpJwjfcKIigxUOlERQNCbFBQpzHgQ1xwm3DHUMxyqvYgRKdWlWLCYTp81b4BQ7ZvIIfQ4yf6pvIxnmnmOH8aReLeQw0VZRlS6v/ZeT4cyvIwjbC1Qm77rv6nNnCXNGveFz3hIdlWM93Whrgp66AiZuzIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjI+abj50WR1Jpub8g/BG7jETIgA4+It8y8CxQ3v/Gg=;
 b=UnsBkPramaCZc9Lr4g2XUSbvMruDORWWZi18JMLvTl5V1oq04JDZL0TNYyJjR5x7LeVG4EmTDMn5eHH0Ek2cFVGLvAA+AthzKO7OrWLM7h+VvhVzMvodYskEstzXJD65jg0vbW3S170z5VtdPAzJ2jyNRiM1UIKXmHz7TVIfPsfo82fNp3cY8B+CiTMftmhZq7yqJ6b0aA7lTggjDLZwM4MBnjx01lKFkrYp0yM/R4xJGGAlXsBDQpvTCkUgJLS2XbYYOFoMcHfZPj8rcszVgD8CrvIB/OLY3wSX4pJY4D7JRqs+QiqbZCfgAYf4QCC6d4H6omlYE0GVUK3yDAInfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjI+abj50WR1Jpub8g/BG7jETIgA4+It8y8CxQ3v/Gg=;
 b=LshPJNvm9TmvvSczDCADaQhIk+KdNFe1TOUF6iUf4H9y/bwtHV0t0YOaXpGvzjuYi4wdSLcVU5mLFU78WSh9b+A/+lSD/N6qvF8wVCSFMpQ3emwqxd0Pvx3aoodo2iR4/4HX9rU0l5PSM9liSBocR2TuUT32YI/BixD51MTs2oo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 18 Feb
 2021 16:45:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:45:36 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 12/37] xfsprogs: Introduce error injection to reduce maximum inode fork extent count
Date:   Thu, 18 Feb 2021 09:44:47 -0700
Message-Id: <20210218164512.4659-13-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1e12cdc-aef4-45af-ea21-08d8d42c9db7
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-Microsoft-Antispam-PRVS: <BY5PR10MB42901FADCBF7ECA889F9891495859@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:168;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8zZDutKKhgwUBczUyGbtZdSaDQbGtLk+NBkCBWRhs2zs8M2X++FjVuVeImp7Lvh24CsezRCeFhfiZMBLSRTBmPjHtPkqZmHrLXBt9MGcJgW7fdeH+tu5mMwW8icj+bQIdij43O8yA1UcdbpwnKt84a0q7FnDsJajr8LmklzJQHB4pF0b4Dz1WemLr+vji4K6ngCqV+NCvQF1N/nn3mmjOs2qc/HuRjcZJ6JlGQNcmY+Eq53dDxm4Ms6rdZjBjlsFzISjUfctmOCW7y/OhM35itSeT1Y5W5yFW29Q2v0ub6Fyypf77+MFPCbQqpx+rOYfwUPWUgCK71EIAi9Cdx1ZSXEumAJJ7i7KG+uHwBEBQ0KEFEZiCy5zCzvnu+Wu3KF91qZFDL+ySJRxmTiLopcS9CM9el5BNSDFujf4XhCklooLWCfL2sM3+m6ve3T7eRT9rHiiP0jQMUX6tFtK+xI3XIOK8Oj8smdirgf54R6SOV3uKcDZhWgKoTpXaxeaMS6Xd/9oZzhWESk4SDgt/CxKXIFMiKFDrXePvVfLIzTyytIxT21YRWYyLfu2UpIRoty4HwdMscLiC4MBtMjSuhcIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(6512007)(52116002)(6916009)(1076003)(2906002)(316002)(26005)(6666004)(86362001)(8936002)(478600001)(8676002)(44832011)(6506007)(36756003)(66946007)(66476007)(186003)(66556008)(69590400012)(2616005)(5660300002)(83380400001)(956004)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?s3K+0x+32tsFAYx90RhwnXccdcMot++utGjGM1wIhJ/wKNI11aN3dIdeAooP?=
 =?us-ascii?Q?fld9gtZtSPfPdSgy+clXkh1lckGnWnZ7GQz6CpepmwpuzS6DLJqg1NECZ0+i?=
 =?us-ascii?Q?aQ80580J0HN1UibcMP+WAkdtIgJ5KzQkp8HGIxWpArxNOhhjROFoIzL2m/02?=
 =?us-ascii?Q?sO+ErDji837GzFRa6MCg8jRoXhChygcWcaFvpLzw4PrQOtjhPKosYbyTMCPJ?=
 =?us-ascii?Q?cOz1gqc0q0JTbv37rZoV4HEh49k7EF0wQDqyYy6NISvolJdExEL9hScL8Xa0?=
 =?us-ascii?Q?B84OJeUoVM/1mZC+sG7EScHYJsxwwKRCLxIUu7bVh6KMBBClGXh0NkShffzJ?=
 =?us-ascii?Q?mu3YGfvbmTtpe5AXPpr5SoMbRPp0SQs2ji26/9wZjyY3wf4kVAJkkbe4dHp0?=
 =?us-ascii?Q?c3ANJ+NNBUH2nuz2GfX6Lb5awJXLD4gdoAG4KYhExhTtLZijbrAackimcE4D?=
 =?us-ascii?Q?ZkJO9YzVK+f3GNTHyKRspZILAwlJcE2u+RTaCzQeMhImaSZBgctbgcWerd1g?=
 =?us-ascii?Q?V+3+Ndm2gYvIvOfXaQqmUAAterDrzOxFvkuDigHYp5aZDASuopTlhktWCkeC?=
 =?us-ascii?Q?e09EKBJXkZsEZ/nyQvkfCLqFlQ4flUaeQlZ9mX9HdqTbE2OQc8KhbmAdh9qK?=
 =?us-ascii?Q?B02TWvGiOThnCpnu2C2zzKKE6fA5ZY3jGsY8y75VmEX/8q0k8oAtCdcdA8Zj?=
 =?us-ascii?Q?Yzgz1H+T8773kgV1hZOE0TZijmMZeHRcbUGK4mGQbgkt+d1Ty5EGShZmL1Uq?=
 =?us-ascii?Q?q593GLV48TaAW7jW9p7N5pQnhOhxHq8dusGcSK9CHWnDPBKWKXgzG65uxQBi?=
 =?us-ascii?Q?d3F05rgJ0cYoisGxtXyQCLlRHgyoriacXrtkIDYUiNBZRmjU6Mr/ChghoxqM?=
 =?us-ascii?Q?0Q30IUkUSt9fwzqTKMZqpDuWhCsG7qL5GXPECZe9I2eutdRUvnImT9oXh8cB?=
 =?us-ascii?Q?zV+sC0Sy9RqFl9R2J7qQvh7CbsLfaooCyKkj3fgENcTBYJjvP2jWe5CcTeS+?=
 =?us-ascii?Q?NGqgO9cYF8Z9kna5ZOtRehcWdswj8Y3RF2APNOYzN+z/WYIqYDUlzn0VzlKr?=
 =?us-ascii?Q?oaKE+KHWwZ74ztI+HO/CF0TB/jNgP+/QVv9pxWNc9LwDpxIYBAHEAuHOCzQG?=
 =?us-ascii?Q?067epiplau2upTvLiTrPt1q59B5EKqsUntAuYsg0+98P/D3+/w6jppvdSzYA?=
 =?us-ascii?Q?ULd3vn/JfxIFY8ImJ3G7TIfJbDQ+IlDR58E8tjyXPUWPKxHx5/lrgdTgU/6D?=
 =?us-ascii?Q?gBQTe0NSYTVbEjQRex6KIFacuW/91Xj0azDC23OPHndmlyL5hMT/6HeH0ond?=
 =?us-ascii?Q?zB/qjA8XfPC6USmiulmuagHo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e12cdc-aef4-45af-ea21-08d8d42c9db7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:36.4602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 38z1CCoZWeLoIoiaHkml1M7IVWRVyqSZtAWFIjEsSZEOom72OREWjf/VVBCblWTDVHtQoqf1//pqy486UOo+7HwBzG0ZrkrDuTtD5BPXvKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

Source kernel commit: f9fa87169d2bc1bf55ab42bb6085114378c53b86

This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
userspace programs to test "Inode fork extent count overflow detection"
by reducing maximum possible inode fork extent count to 10.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

achender:
	Amended io/inject.c with error tag name to avoid compiler errors

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c             | 1 +
 libxfs/xfs_errortag.h   | 4 +++-
 libxfs/xfs_inode_fork.c | 4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 352d27c..ff66b41 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -55,6 +55,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
 		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
 		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
+		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents"},
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 53b305d..1c56fcc 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -56,7 +56,8 @@
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
 #define XFS_ERRTAG_BUF_IOERROR				35
-#define XFS_ERRTAG_MAX					36
+#define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
+#define XFS_ERRTAG_MAX					37
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -97,5 +98,6 @@
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
+#define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 83866cd..1802586 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -22,6 +22,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_types.h"
+#include "xfs_errortag.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
@@ -743,6 +744,9 @@ xfs_iext_count_may_overflow(
 
 	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
 
+	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+		max_exts = 10;
+
 	nr_exts = ifp->if_nextents + nr_to_add;
 	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
 		return -EFBIG;
-- 
2.7.4

