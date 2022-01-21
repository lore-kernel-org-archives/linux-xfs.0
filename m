Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D05C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348547AbiAUFV2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:21:28 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9620 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234018AbiAUFVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:02 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L042Lj017777;
        Fri, 21 Jan 2022 05:20:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=2kHdSxkmY1lrmuT1Y3/bdHeXXn+4XDn6wjCnZ6Lc5j0=;
 b=P4kgdL8MnQBGll4E55c7Bfu2ikguyKQ31ocjpGyA1anxUrhsXb8gQjje5hGGTj/Oiuvo
 7v728TSOGCdkA30jtwm/v3fDK+/MkR2lLl21ztIWvwu5BkO0qlWwSD1t1/xQygqoKFWW
 d/Lrm7EMmP1yYD/HlZqdvHQ2QfR7fnyfaGZD8bQj3c7UUISPNuMd/F7Z01r8+aTeZbH7
 WTNCygW3DykV0IQ3GXLGaZyQDG+SpaqQ1G60t9XMt/CWMGdXbR5CEnUq3dZz+N2vUbgj
 ip6ZZhWdP1L7A0r2fILJxcbXTddVGUlJDD6Xj1/gwtaKSKkGFhLXSivjZhqG6lepZ0bM ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhyc0d3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5Khlt094579;
        Fri, 21 Jan 2022 05:20:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 3dqj0vbm37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQHOxRX3mQm3cGSFedfHjA/geZtjzHMT20qGVjV6/GqAdSgQ7ePIYUVonmX9JclqlQtgxw8LWNzojRRGRXSVVQfTHOnQE2mb+IryvgQzyW4ke1s+HEQ7M/NuNM8cRFLhT1ucQiaIvXbjBdDtePg+UpMH02BWmd6ezDkJq7+lEtwo+r50t9oIghNxzhjRD4K5E1FQJ1mSqa8ZpWdZvRbn7qZwCjwr+3KCL3f6ZdfoGkbLQP4e3GG3decw+f0oOEvpDSR4BKrSwZZq0MKUGHVR+flzSQf0ruV+A9v551DfrLLqIzMPT57cYkUUqu+51rPhCxgPiQlptcRdXogqI4YhNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2kHdSxkmY1lrmuT1Y3/bdHeXXn+4XDn6wjCnZ6Lc5j0=;
 b=Eu6mpw1kyBBtTjwTdy3uorIue9dsGStyCSZ+1vzxo+h34FQZzKQSksEf0VyQ8YwgWDvMtc+n/uVQWlif9wRvtHoP+ZRACtGUn8AaBz/4eY00pfYOi4/aOA9N93acevfuXrsqJNLTcFuo+3dqNF8ShCos2ewwzQY4qCO1CwhlhH6mnaAgIfXmXU/vUzyfJSBo2ejcT2jkUn6VXrxZsIeWWY6n6OFbS4DGT4+23OIrdWfQlae1HV/irR6XL5HFu/HHh4bvWfJBkO5yv6xvJeZcwXub8QUCjJsh2tiEaYRfhH9J1DIItD8AggldNYPyU5vntqE2/jyMrfkxFfdPEjUXAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kHdSxkmY1lrmuT1Y3/bdHeXXn+4XDn6wjCnZ6Lc5j0=;
 b=rUrDpvXM/aoYGGhCoi8IVbqW2XDcXRtNoHimBdsCRTph7Li+WiMBWY/c5HzM+nw+La5FOeKLN9nL2OOkaqz1QW8+L5kZtV6PStx0JdgIeszhCM7BeGBAOermcnVsimtJnTsglr/9whkxSfBuO21hiI3ZBpAQfTyKQc3zWNnRF/o=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:20:55 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:53 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 07/20] xfsprogs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Fri, 21 Jan 2022 10:50:06 +0530
Message-Id: <20220121052019.224605-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2da34523-adeb-4f1a-6369-08d9dc9dcba7
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1287550FE2C60C37E58A90B2F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:26;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VxBr4IEAKjjVe7inlTakTJZlLh6CHxObm7mDEFxZTgJ95YafvSbH5mitkg5og/u2lqhGmR+pldFgs9oE6qa++/ZjJNKBFNNvp6SLlUhEWesBHzqPzxyG6l/YECm+M/+wFQ6SMbOxLJjDXea7mTK9Fe8/F/rObpoNmezG//HAEB9Fy1Id1+zkPiFz2YyDf/IirI5yzY4ZHOZhle6VZdaq+7/Saq8Zqf1yPcQh8Spg0IY9TyttE8YdoxOfi50CUNcx9Y5S8CRk5RuU3eSP3zYrJkAyMmEIyIDWx7D4ekUgGoObHtWBnDF0NCd3rcpx7tOhVeckPevbQ4z4cGdsgY2VGbiAL3O0Qt0jMHRwwn5bOv5enrL8JSez4J85PGiQX1egHzgEYIA1ztn76Phf5my9nHAZMnF8LKXbdykQxFn3wjRd1ZBZp3HeM4uaEQXYy2HfEo6skt704MTNYidzjCKNO+bPC4NjZ4O0xVKd8iFypRVOsN/n4xKJIuN4dVXXwwG1giAn7c9ez6NXrJtT7c+F6IzzKf/gJBH6vehXla8ee8PYClTgtes4X+Z1Ib62Qu6SQu+2Rk6KTVxE4uZeTRwrlokyMs7kjQRywRpzewLv/wOT9ZXkfeRBTWDC8OkNcGicdO2gtFnikGZI06xqzzAufCyXkxdWSnax5iC31f9AErKxYvQCgJIDDnFb25R7X6cABtcHbMkMPdgTELpRCqSWoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qFXAibdLxHFqgOictubDOoOrPuIo/kWFG5EY53vfHUZRb9z3zC8D8egv51QJ?=
 =?us-ascii?Q?FCtexbrY3QKlJ2mhbT2dVw9saCABfFCW5r/9IX3RjDMbvNkXvlxrgnrpJxKx?=
 =?us-ascii?Q?LqJzZD3ZZra+jH2usfyYzvaUdE/fladdwUxr+YXold5XnONLgn7q8majgJod?=
 =?us-ascii?Q?x5s2cjAUFYu8LrYtCBBhxuxtt0C0hM0HgzcsF3oFnMoNFXFjoqaONetmWiN1?=
 =?us-ascii?Q?CXsjKa8EsNtILmSxYqNoPJQuKA7vZ3lB8kjN56wSb6EqwNlH41gmROwBVXDC?=
 =?us-ascii?Q?aMv3ByWyu1LLigFa9qcg+6CMdEfWXQyBwAHiJsxMzxNqcNrPW7Z6YHQNUThp?=
 =?us-ascii?Q?CcFSud/RnhOjB4v4ocrTDQnY8+MHLPA6z1IAh1np6yrkWLhF5oncat3QJxLB?=
 =?us-ascii?Q?AoUCsfRBk+m6S3YTI6HBjvondgAIoWLUUPumyDcb9dAYvUvUNobiHGmSvKKp?=
 =?us-ascii?Q?C6uRJo0sQ6nmpaynuZORsDvC90Phe3mGyDYNQMudaHc7DRLj41ZYCAagjQ7i?=
 =?us-ascii?Q?Y30JctKVagxLEWQGDYplEM0BA+Kn5mMG4D53MLtRJbRCTdC9b8PLI4hOirMu?=
 =?us-ascii?Q?BN/04W/+XQU4P0dIVPkPQX2blixFmFzpP3apzUbyWVBnGfIJlwu3bHB07mLz?=
 =?us-ascii?Q?uhveoT+QswwsP0QjP7IhMjrZmynE/CEGMhRGu9qrMzk5EkoOe1FrwebzegXH?=
 =?us-ascii?Q?Os3zceFtig5eOMPr/alQQoG/WWtvfS5yOhfh3PbOIix/ojd+J4ifUCNJBlLH?=
 =?us-ascii?Q?cOmjWl4uG5BOolYv9d9/Gcb9DMjCpsIpPRkRFIudIPqWUFcEw75cTUtpmUTF?=
 =?us-ascii?Q?8Vwb6GBWvljPTFcjRJFHWdv6m85AtFGqPHmq3UhDZEinKqJMF960sIHKu2/c?=
 =?us-ascii?Q?k2zR/3s4RGVvsTYX7Fpmiclzg1hw1gDo11+r5/l+auzSvjR8kPxDjx22TsTW?=
 =?us-ascii?Q?Jc/5uILG8NvJPHrXJa/TwHEJYzlYkAqsqo5NtlzV+pZFOk3q9spEd9VH5kn5?=
 =?us-ascii?Q?eBbvLbEjNFwd6KGRsbEEY14kBOC4ltK2MLhSeBwaEYIOOVlS1snQTzlKSOvD?=
 =?us-ascii?Q?p2EB3lp6dEWHTVK96qwC275z7Vr1hkPX7G7xCR6mAYDDL/J3XVU1N8/nslnt?=
 =?us-ascii?Q?80OsnMovJ4SQ1owSXRemNrR6a2Poc2Fj8ujQTVveX9cJSq7pE2O4PGy9oyOJ?=
 =?us-ascii?Q?5SZFm93EUP4C7YFXWx8KafvbrqOlfihQ4Fqo8ciYQps0Ory2An4S+KAJ4MUM?=
 =?us-ascii?Q?6/t0QzS1d+9IkBjhN90aukFsRrEINtkARCCizd/1jmfHE3BukEg/S8izLygf?=
 =?us-ascii?Q?cY7+3OvvUNACLW2GGUCtuemKJHqIiyQFoliw0KDATXjc3oDiLBgNCBb3qp5j?=
 =?us-ascii?Q?9aoc6DJp63CTG1L4JUjvEIVOk0Y+Tqm4YWQ4bF7cYHhaZ3h0dzGdfdXy1WRR?=
 =?us-ascii?Q?tFA3Myi8L+K/4d8NgpEcFryzIyU8ruHwOQab9spXjp6tPY2ox8bso3rpj+iz?=
 =?us-ascii?Q?KzjjUjsqvIvPZxGjGIYvUFCeNCCGS+3+ribYitNQyexiEYfLNqco3D2DxH2O?=
 =?us-ascii?Q?8hxVI3jWu8cjWTpG0yqVyYlgg9T/1I4S6WBTQ0dhTItKzbr8irMDc0DHCeKW?=
 =?us-ascii?Q?j02iVr1uBpMG6w9ElsRljjw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da34523-adeb-4f1a-6369-08d9dc9dcba7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:53.7637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qK7L7X8g7g8piW29a1kQKtc9YiReMnkXJujumQldV0Pdmw9KkYm7YcNMxOnqHA/aBMhn1WpYFmSIwWYuF4asyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: phDqRRu-jqXWA95KjQ4pHKzrCXj9MR8j
X-Proofpoint-GUID: phDqRRu-jqXWA95KjQ4pHKzrCXj9MR8j
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c       |  6 +++---
 libxfs/xfs_inode_fork.c |  2 +-
 libxfs/xfs_inode_fork.h |  2 +-
 libxfs/xfs_types.h      |  4 ++--
 repair/dinode.c         | 20 ++++++++++----------
 repair/dinode.h         |  4 ++--
 repair/scan.c           |  6 +++---
 7 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8da8aaab..42694956 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -45,9 +45,9 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -76,7 +76,7 @@ xfs_bmap_compute_maxlevels(
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
-	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
+	maxblocks = howmany_64(maxleafents, minleafrecs);
 	for (level = 1; maxblocks > 1; level++) {
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
@@ -460,7 +460,7 @@ error0:
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
 		__func__, i);
 	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 14b29722..f7fa0af5 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -115,7 +115,7 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
+		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %llu).",
 			(unsigned long long) ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 7ed2ecb5..4a8b77d4 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -21,9 +21,9 @@ struct xfs_ifork {
 		void		*if_root;	/* extent tree root */
 		char		*if_data;	/* inline file data */
 	} if_u1;
+	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
-	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 };
 
 /*
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 794a54cb..373f64a4 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
-typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
-typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
+typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
diff --git a/repair/dinode.c b/repair/dinode.c
index 386c39f6..4cfc6352 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -342,7 +342,7 @@ static int
 process_bmbt_reclist_int(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -645,7 +645,7 @@ int
 process_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -666,7 +666,7 @@ int
 scan_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
@@ -1045,7 +1045,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	 */
 	if (numrecs > max_symlink_blocks)  {
 		do_warn(
-_("bad number of extents (%d) in symlink %" PRIu64 " data fork\n"),
+_("bad number of extents (%lu) in symlink %" PRIu64 " data fork\n"),
 			numrecs, lino);
 		return(1);
 	}
@@ -1603,7 +1603,7 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 		nextents = xfs_dfork_data_extents(dinoc);
 		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
+_("bad # of extents (%lu) for realtime summary inode %" PRIu64 "\n"),
 				nextents, lino);
 			return 1;
 		}
@@ -1626,7 +1626,7 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 		nextents = xfs_dfork_data_extents(dinoc);
 		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
+_("bad # of extents (%lu) for realtime bitmap inode %" PRIu64 "\n"),
 				nextents, lino);
 			return 1;
 		}
@@ -1815,13 +1815,13 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
-_("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+_("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
 			dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-_("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+_("bad nextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 				dnextents, lino, nextents);
 		}
 	}
@@ -1837,13 +1837,13 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
-_("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+_("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
 			dino->di_anextents = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
-_("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+_("bad anextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 				dnextents, lino, anextents);
 		}
 	}
diff --git a/repair/dinode.h b/repair/dinode.h
index 4ed8b46f..333d96d2 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -20,7 +20,7 @@ convert_extent(
 int
 process_bmbt_reclist(xfs_mount_t	*mp,
 		xfs_bmbt_rec_t		*rp,
-		int			*numrecs,
+		xfs_extnum_t		*numrecs,
 		int			type,
 		xfs_ino_t		ino,
 		xfs_rfsblock_t		*tot,
@@ -33,7 +33,7 @@ int
 scan_bmbt_reclist(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
-	int			*numrecs,
+	xfs_extnum_t		*numrecs,
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
diff --git a/repair/scan.c b/repair/scan.c
index 5a4b8dbd..c8977a02 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -220,7 +220,7 @@ scan_bmapbt(
 	xfs_fileoff_t		first_key;
 	xfs_fileoff_t		last_key;
 	char			*forkname = get_forkname(whichfork);
-	int			numrecs;
+	xfs_extnum_t		numrecs;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	int			state;
@@ -425,7 +425,7 @@ _("couldn't add inode %"PRIu64" bmbt block %"PRIu64" reverse-mapping data."),
 		if (numrecs > mp->m_bmap_dmxr[0] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[0])) {
 				do_warn(
-_("inode %" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode %" PRIu64 " bad # of bmap records (%lu, min - %u, max - %u)\n"),
 					ino, numrecs, mp->m_bmap_dmnr[0],
 					mp->m_bmap_dmxr[0]);
 			return(1);
@@ -476,7 +476,7 @@ _("out-of-order bmap key (file offset) in inode %" PRIu64 ", %s fork, fsbno %" P
 	if (numrecs > mp->m_bmap_dmxr[1] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[1])) {
 		do_warn(
-_("inode %" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode %" PRIu64 " bad # of bmap records (%lu, min - %u, max - %u)\n"),
 			ino, numrecs, mp->m_bmap_dmnr[1], mp->m_bmap_dmxr[1]);
 		return(1);
 	}
-- 
2.30.2

