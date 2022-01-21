Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94180C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbiAUFVE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:21:04 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:2808 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235453AbiAUFU5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:57 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04TlN018499;
        Fri, 21 Jan 2022 05:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=FH7qW8uToFPySZmBHjMUAUD0ZerDqw5dJwpvXkcfF+k=;
 b=S6YJebozMADwBDR8dFk6uoWV1g/wXQdMrzq7OSCnDIqyEeQfV9AU3BEhs/VW9m0/njqv
 ys+Yjkr/gGW9eVsybUsvPZbQq6v8cv+Id733mqjd7yeKCf4F9OOe4Mohaurv53V7HVdk
 uQQk+aab+tKKT6GxYWAbYor/ZetAlMH1MNIWC6MuApfQUX7vixXZT6IDB5qBBH+Nmywl
 A2rqOgnk5cJTYdOT89TocvGY4Uh3nJosYLp0t3Kw3F40eCrsdBx/+27wItj3RAHwOpB9
 y95TkV+39LXsQ/A9Sg9v6EGIn8+EWjESiSwlPDbVYwU2adkPKkvmAKAqIAh3X6Ol+tB5 eQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhycgcrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5H000018723;
        Fri, 21 Jan 2022 05:20:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 3dqj05h3r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bb+BqHz0qS/RcHk7WSYwvT066T7bBTH/jOAul+1FfO54qvZPijb1ddQ+rWpHHzYIE8T7KOtuCd250wbhbgvMsd7CTDt9RWlyDI1hKh+Pm9qlGBfdQiCLBjrTJFE8N38Cl2c2U44AYUnMW0ZWWaPylAc/hsTBd/PzwUAUBA7NL0UG4Jt9PYPhzDHp6okodeUDGViamAIc5b327E/4PCbeD6QZ/MqyLEDQfsgWWKudMRx762U7TVIEI/3OdGVWR0njMYBf/z4y8ZZrsWQvyuB10DUeZbC8WV/WJBbAe7HWepyVISl8jtMpw3aU6RS47t4vJ8ksgNcB535AsimnvyIO5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FH7qW8uToFPySZmBHjMUAUD0ZerDqw5dJwpvXkcfF+k=;
 b=ix6ph0jawSwFSWxrXEG7mghvMTEeX9UcJwHCIRlaxBDIjFqwTV2yDR6w+Ucnb5Qp8/qe4YRDcEhBzJfx8eBSnaimkOChY7yN0CTy24rUQK8Dq1BH9VUep7SUCdvX0b2WdlLI70sfPm4FfQUBtmAtKFIP9Q/0zD2Y/Qrb8Qj2KGmzW1tBO89+Ex0xsMTwDiRv7PF9BwzagHfhTM+TSzRIlFHuOHNHu8fdVoUsj3DoaJdCuA+xGxLhLm72xNv1oziHPED07cqq9FYGUsUGZMluH2M+pOxZtATqw0vXFNIFrr0s6LsfIX38dDJ3jVNVDkhOqAQH7N+Cg5x0KW36FVIWsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FH7qW8uToFPySZmBHjMUAUD0ZerDqw5dJwpvXkcfF+k=;
 b=ctdWYIlnTwGChSX+zLOhMnqA07yR/MoE3A7O5rO+yEOY6/9iy1JhMxh48z/lrY50CJegWq+fubYc6/v07oKr7YMJ4GPV4AEzzD5KkCVOAnUxGJFpCr8tbm7yANHsWkdYskF0VxTVtdNaIN5Sx2RBwICXzTIktfKZDYOeJcyyxg4=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:20:49 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:49 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 05/20] xfsprogs: Introduce xfs_dfork_nextents() helper
Date:   Fri, 21 Jan 2022 10:50:04 +0530
Message-Id: <20220121052019.224605-6-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: acb73b26-bb2d-4b1f-44f5-08d9dc9dc8d7
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB12874BF2352649BAFC4DFA9CF65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M6fiGbFSvMBLsrQO9LT0XJMon4+92WBEYcwvPErRkPRUVSee1KIi1oh9i924Co2ALyNQxcMKo7Sf0fkk8D19p+zqSCi7gdjDuiZyoCojNXppy/qFSriBHWpd5jOx4YQmetDr37heK8kf9dQ8cHL/dsP1RQUHBorWuzmcYIv+RBo50lBzuloH7kkWBDgSZuh5B0HP48uWEY7NTARvcCzRKVizeoJYaqmV4QrcuXKe3PDuo1qO7ASdZQzELQCoYLPxXVOtGXBt02QhibpIX5LzyLy3K3eCrmtk9+3hc5Y8RbAjj9wOoYDvMGE/zrk3Z6cQhQFEzZYkdFz12ibW1chmhAhNMaa+jiWFlc8mvx8bO+WYCibaFKv/7jy9qcIltfH2kXxTPzSjpzgH0ZPKr50b4R0HqLKTk328gvZTbks/fAdbQw/LzWLSFuyskQ6a5HorwF6MgMef96MX7y0It7a5FYH2U8xzVcuwfoQr7Q44WLlhu5xUwRTgoBrLtGkCbkKqAn5suDDgE6VOsY75d05LCseodsuLcAGMyUwWrLt3DL4uuKSa6tL6fQ+ltWIE+EE7Zt1WS7v8sqnMX9PBeY1Gv+HV/dnmRkcMCdwtd5NGApPiHDq1QwaFaULQE/ZKo6+XQJ3OKcC3F9V//UFEcvH67OWYxr4OX9xch1nyznUW3UIYiVtRKP4nkGtIZaMqLA49
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(30864003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TSzBWWXl589KMSY738oCRJrg9Xb/+LUMxuHhJsRWb2iEQSWIpqpvMqtVIOxX?=
 =?us-ascii?Q?zw0vTAH6vF89wiFmWYTDd2ehQWSW6BcmAqoXI/hFULLC4J4susr5gBBiqyd/?=
 =?us-ascii?Q?NDzXoKe8v/aDs3e13r+lgZUZDe292MmKZOjQSxhJcG2uXM0q2M5DmwjVz1bw?=
 =?us-ascii?Q?E589xgpG/zlZeXttftjHCrNMbksGxW/n24G00m6nlI5Kf6k7iIz2XU9dU5Xo?=
 =?us-ascii?Q?T/0RG7xTufCwI+fVbR8hEZ6v7o8jLHRuWFl+t4kkio9LDZ9T+TLjf6wem756?=
 =?us-ascii?Q?KEMCTLBjMOIqSdc9VtGLske+hjxBwfjtQz/Mg+QXr+uXwUtc6O6vusvdzCv4?=
 =?us-ascii?Q?8QyvV+Gyum95GpGhOt5B441On+Eko7a3LJa3hKug9K2X0oYcDkEgAgyBZ86c?=
 =?us-ascii?Q?sDR1y3Albcxy5dHcTmx9tcsz2ZYnYXFzVchb91E1vjAvFiTkJAZY4lLzNW+b?=
 =?us-ascii?Q?xTB1czDtcD0OZg8Y8FKK5i2+GOa01C59xDFUrEagm1Ifn8ehdw7xKo91Ce5b?=
 =?us-ascii?Q?dRrm6v8T4hkr1Zd9xaS//P73VA6k8yOUUvzoIe2Wg+Do4SaovnLWODI+s+HM?=
 =?us-ascii?Q?lPgqZlnb1viVBiapy53oKJnFrb9O2KYWDIT7bL0QfwOPPVX7Je2Nipw8bVhi?=
 =?us-ascii?Q?1Z6dUNeo6du71nYzSJ6//m4upCWWullXdjDQyRPPFvwZM8BdLFpL0IwLg0QV?=
 =?us-ascii?Q?3zhwqtgWhtPd/1FEkXf7wxw+9SMQZIDv53JOaDwNicNEWvR9pmLGLa7z4OKr?=
 =?us-ascii?Q?zAGUeZB5JF+QiXTarVwfI2lap/iq7nV1VTJ17pWr1bP9BwiI/tvJSBa8ZE59?=
 =?us-ascii?Q?esqYB2t+34QxiKowrWKElYMIHaqoY4gQ+3WACTLndVaQdXqMObxEfIpFszwp?=
 =?us-ascii?Q?PJuFiTAtevHv3+KnlNUwTGSE74AXJ2qFCdiZDTgHZ+0tVVs+cKYvDA0sjCDe?=
 =?us-ascii?Q?DjL2Mto8Dxmxv+d9RK9WUBfb3VZlYmB2DIOdypemjdrYPOMPbOrFOws+cpiL?=
 =?us-ascii?Q?T875Ujpvs3rqwHAQaLz9y09A/I5loZokLvs1mAEKsf9pnf1jzmJd2z3vky/o?=
 =?us-ascii?Q?URdqzhZUu/4n4BVtE3UaaHdphNHLKfn2QsHWXNW3PD3mQwT/RdY9kdAXxJdx?=
 =?us-ascii?Q?IvkvUQl55Z3P5mPDmxOQ+AtDb/GlvlqNkSTF7aiHs1IwajvBHlCfmviagHU9?=
 =?us-ascii?Q?uCh9Msdg9ABYN9mHtLwdqEwV3GZETZCGiSuQ//UspzC0MR6+sYtOAa1JNFEL?=
 =?us-ascii?Q?AYIQPRCkKXjLIWQ5PiWt30WuNz+0M5UMgBbY4nfVHEE5Ax/IjgnwKX8ClLKE?=
 =?us-ascii?Q?6c/E+sOi8BY/QC3rBIMJAw+h/DnNmcY83Xxsr/OnFlWWwoElO/UhbxzLLC3+?=
 =?us-ascii?Q?+Qksawa5HZ300kbltvUyHoG17E+BUxcGHNZ4waDnwqN3ocUJWDok8NATeGJY?=
 =?us-ascii?Q?17/PG1vRz0LVBCdnLQ96Nc+iucLjTfeKhVw/s4uZoYrxnB9E9g3SJlcd39Os?=
 =?us-ascii?Q?tIcuyAnkRPegI5UOLZEn1QMEEbBO3rU8Ig2wmYp7vgwCQzGsVYmCIkRnXCjV?=
 =?us-ascii?Q?7TNKON0GAJpSrL0ZT6T6YdlDZwHwFvRIbi+8jsYqEqVCUPNKoP2BLWz6j9/O?=
 =?us-ascii?Q?kJrStegT3AkiQIPQCRmWKVE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb73b26-bb2d-4b1f-44f5-08d9dc9dc8d7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:49.4349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0m2ITQB+ciMajas77uzFHNRtTTS4SGmWiYiMRFA7hh/YIIVKSQMc6Wk4IEbmQWQ+JLVJqMr0lllbmH1mGwb0aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-ORIG-GUID: MAipol1o01tDmTd2Cgn9-fLRr7pukCcA
X-Proofpoint-GUID: MAipol1o01tDmTd2Cgn9-fLRr7pukCcA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
counter fields will add more logic to this helper.

This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
with calls to xfs_dfork_nextents().

No functional changes have been made.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/bmap.c               |  6 ++---
 db/btdump.c             |  4 ++--
 db/check.c              | 28 +++++++++++++---------
 db/frag.c               |  6 +++--
 db/inode.c              | 16 +++++++------
 db/metadump.c           |  4 ++--
 libxfs/xfs_format.h     |  4 ----
 libxfs/xfs_inode_buf.c  | 16 +++++++++----
 libxfs/xfs_inode_fork.c |  9 +++----
 libxfs/xfs_inode_fork.h | 32 +++++++++++++++++++++++++
 repair/attr_repair.c    |  2 +-
 repair/dinode.c         | 53 +++++++++++++++++++++++------------------
 repair/prefetch.c       |  2 +-
 13 files changed, 117 insertions(+), 65 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 8fa623bc..d0c0ebac 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -68,7 +68,7 @@ bmap(
 	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
 		fmt == XFS_DINODE_FMT_BTREE);
 	if (fmt == XFS_DINODE_FMT_EXTENTS) {
-		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+		nextents = xfs_dfork_nextents(dip, whichfork);
 		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
 			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
@@ -158,9 +158,9 @@ bmap_f(
 		push_cur();
 		set_cur_inode(iocur_top->ino);
 		dip = iocur_top->data;
-		if (be32_to_cpu(dip->di_nextents))
+		if (xfs_dfork_data_extents(dip))
 			dfork = 1;
-		if (be16_to_cpu(dip->di_anextents))
+		if (xfs_dfork_attr_extents(dip))
 			afork = 1;
 		pop_cur();
 	}
diff --git a/db/btdump.c b/db/btdump.c
index cb9ca082..81642cde 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -166,13 +166,13 @@ dump_inode(
 
 	dip = iocur_top->data;
 	if (attrfork) {
-		if (!dip->di_anextents ||
+		if (!xfs_dfork_attr_extents(dip) ||
 		    dip->di_aformat != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("attr fork not in btree format\n"));
 			return 0;
 		}
 	} else {
-		if (!dip->di_nextents ||
+		if (!xfs_dfork_data_extents(dip) ||
 		    dip->di_format != XFS_DINODE_FMT_BTREE) {
 			dbprintf(_("data fork not in btree format\n"));
 			return 0;
diff --git a/db/check.c b/db/check.c
index 654631a5..1fdc1817 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2713,7 +2713,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	*nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	*nex = xfs_dfork_nextents(dip, whichfork);
 	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
 						sizeof(xfs_bmbt_rec_t)) {
 		if (!sflag || id->ilist)
@@ -2737,12 +2737,14 @@ process_inode(
 	inodata_t		*id = NULL;
 	xfs_ino_t		ino;
 	xfs_extnum_t		nextents = 0;
+	xfs_extnum_t		dnextents;
 	int			security;
 	xfs_rfsblock_t		totblocks;
 	xfs_rfsblock_t		totdblocks = 0;
 	xfs_rfsblock_t		totiblocks = 0;
 	dbm_t			type;
 	xfs_extnum_t		anextents = 0;
+	xfs_extnum_t		danextents;
 	xfs_rfsblock_t		atotdblocks = 0;
 	xfs_rfsblock_t		atotiblocks = 0;
 	xfs_qcnt_t		bc = 0;
@@ -2871,14 +2873,17 @@ process_inode(
 		error++;
 		return;
 	}
+
+	dnextents = xfs_dfork_data_extents(dip);
+	danextents = xfs_dfork_attr_extents(dip);
+
 	if (verbose || (id && id->ilist) || CHECK_BLIST(bno))
 		dbprintf(_("inode %lld mode %#o fmt %s "
 			 "afmt %s "
 			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
 			id->ino, mode, fmtnames[(int)dip->di_format],
 			fmtnames[(int)dip->di_aformat],
-			be32_to_cpu(dip->di_nextents),
-			be16_to_cpu(dip->di_anextents),
+			dnextents, danextents,
 			be64_to_cpu(dip->di_nblocks), be64_to_cpu(dip->di_size),
 			diflags & XFS_DIFLAG_REALTIME ? " rt" : "",
 			diflags & XFS_DIFLAG_PREALLOC ? " pre" : "",
@@ -2893,25 +2898,26 @@ process_inode(
 		type = DBM_DIR;
 		if (dip->di_format == XFS_DINODE_FMT_LOCAL)
 			break;
-		blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+
+		blkmap = blkmap_alloc(dnextents);
 		break;
 	case S_IFREG:
 		if (diflags & XFS_DIFLAG_REALTIME)
 			type = DBM_RTDATA;
 		else if (id->ino == mp->m_sb.sb_rbmino) {
 			type = DBM_RTBITMAP;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		} else if (id->ino == mp->m_sb.sb_rsumino) {
 			type = DBM_RTSUM;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		}
 		else if (id->ino == mp->m_sb.sb_uquotino ||
 			 id->ino == mp->m_sb.sb_gquotino ||
 			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
-			blkmap = blkmap_alloc(be32_to_cpu(dip->di_nextents));
+			blkmap = blkmap_alloc(dnextents);
 			addlink_inode(id);
 		}
 		else
@@ -2993,17 +2999,17 @@ process_inode(
 				be64_to_cpu(dip->di_nblocks), id->ino, totblocks);
 		error++;
 	}
-	if (nextents != be32_to_cpu(dip->di_nextents)) {
+	if (nextents != dnextents) {
 		if (v)
 			dbprintf(_("bad nextents %d for inode %lld, counted %d\n"),
-				be32_to_cpu(dip->di_nextents), id->ino, nextents);
+				dnextents, id->ino, nextents);
 		error++;
 	}
-	if (anextents != be16_to_cpu(dip->di_anextents)) {
+	if (anextents != danextents) {
 		if (v)
 			dbprintf(_("bad anextents %d for inode %lld, counted "
 				 "%d\n"),
-				be16_to_cpu(dip->di_anextents), id->ino, anextents);
+				danextents, id->ino, anextents);
 		error++;
 	}
 	if (type == DBM_DIR)
diff --git a/db/frag.c b/db/frag.c
index f30415f6..1d013686 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -262,9 +262,11 @@ process_exinode(
 	int			whichfork)
 {
 	xfs_bmbt_rec_t		*rp;
+	xfs_extnum_t		nextents;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
-	process_bmbt_reclist(rp, XFS_DFORK_NEXTENTS(dip, whichfork), extmapp);
+	nextents = xfs_dfork_nextents(dip, whichfork);
+	process_bmbt_reclist(rp, nextents, extmapp);
 }
 
 static void
@@ -275,7 +277,7 @@ process_fork(
 	extmap_t	*extmap;
 	xfs_extnum_t	nex;
 
-	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	nex = xfs_dfork_nextents(dip, whichfork);
 	if (!nex)
 		return;
 	extmap = extmap_alloc(nex);
diff --git a/db/inode.c b/db/inode.c
index 083888d8..57cc127b 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -275,7 +275,7 @@ inode_a_bmx_count(
 		return 0;
 	ASSERT((char *)XFS_DFORK_APTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_aformat == XFS_DINODE_FMT_EXTENTS ?
-		be16_to_cpu(dip->di_anextents) : 0;
+		xfs_dfork_attr_extents(dip) : 0;
 }
 
 static int
@@ -328,7 +328,8 @@ inode_a_size(
 	int				idx)
 {
 	struct xfs_attr_shortform	*asf;
-	struct xfs_dinode			*dip;
+	struct xfs_dinode		*dip;
+	xfs_extnum_t			nextents;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -338,8 +339,8 @@ inode_a_size(
 		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
 		return bitize(be16_to_cpu(asf->hdr.totsize));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be16_to_cpu(dip->di_anextents) *
-							bitsz(xfs_bmbt_rec_t);
+		nextents = xfs_dfork_attr_extents(dip);
+		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_ASIZE(dip, mp));
 	default:
@@ -500,7 +501,7 @@ inode_u_bmx_count(
 	dip = obj;
 	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_format == XFS_DINODE_FMT_EXTENTS ?
-		be32_to_cpu(dip->di_nextents) : 0;
+		xfs_dfork_data_extents(dip) : 0;
 }
 
 static int
@@ -586,6 +587,7 @@ inode_u_size(
 	int		idx)
 {
 	struct xfs_dinode	*dip;
+	xfs_extnum_t		nextents;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -596,8 +598,8 @@ inode_u_size(
 	case XFS_DINODE_FMT_LOCAL:
 		return bitize((int)be64_to_cpu(dip->di_size));
 	case XFS_DINODE_FMT_EXTENTS:
-		return (int)be32_to_cpu(dip->di_nextents) *
-						bitsz(xfs_bmbt_rec_t);
+		nextents = xfs_dfork_data_extents(dip);
+		return nextents * bitsz(struct xfs_bmbt_rec);
 	case XFS_DINODE_FMT_BTREE:
 		return bitize((int)XFS_DFORK_DSIZE(dip, mp));
 	case XFS_DINODE_FMT_UUID:
diff --git a/db/metadump.c b/db/metadump.c
index 2993f06e..90b2979d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2282,7 +2282,7 @@ process_exinode(
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
-	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	nex = xfs_dfork_nextents(dip, whichfork);
 	used = nex * sizeof(xfs_bmbt_rec_t);
 	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		if (show_warnings)
@@ -2335,7 +2335,7 @@ static int
 process_dev_inode(
 	struct xfs_dinode		*dip)
 {
-	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
+	if (xfs_dfork_data_extents(dip)) {
 		if (show_warnings)
 			print_warning("inode %llu has unexpected extents",
 				      (unsigned long long)cur_ino);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d75e5b16..e5654b57 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -925,10 +925,6 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index b15a0166..29204e4a 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -333,9 +333,11 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
+	di_nextents = xfs_dfork_nextents(dip, whichfork);
+
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
@@ -402,6 +404,8 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_rfsblock_t		nblocks;
+	xfs_extnum_t            nextents;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -432,10 +436,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_data_extents(dip);
+	nextents += xfs_dfork_attr_extents(dip);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -492,7 +498,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (xfs_dfork_attr_extents(dip))
 			return __this_address;
 	}
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 4d908a7a..14b29722 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -103,7 +103,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -228,7 +228,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -293,14 +293,15 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents;
 	int			error = 0;
 
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
-				be16_to_cpu(dip->di_anextents));
+	naextents = xfs_dfork_attr_extents(dip);
+	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 2605f7ff..7ed2ecb5 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -141,6 +141,38 @@ static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
 	return MAXAEXTNUM;
 }
 
+static inline xfs_extnum_t
+xfs_dfork_data_extents(
+	struct xfs_dinode	*dip)
+{
+	return be32_to_cpu(dip->di_nextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_attr_extents(
+	struct xfs_dinode	*dip)
+{
+	return be16_to_cpu(dip->di_anextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_nextents(
+	struct xfs_dinode	*dip,
+	int			whichfork)
+{
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		return xfs_dfork_data_extents(dip);
+	case XFS_ATTR_FORK:
+		return xfs_dfork_attr_extents(dip);
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	return 0;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 50c46619..954a2f1e 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1083,7 +1083,7 @@ process_longform_attr(
 	bno = blkmap_get(blkmap, 0);
 	if (bno == NULLFSBLOCK) {
 		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS &&
-				be16_to_cpu(dip->di_anextents) == 0)
+			xfs_dfork_attr_extents(dip) == 0)
 			return(0); /* the kernel can handle this state */
 		do_warn(
 	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
diff --git a/repair/dinode.c b/repair/dinode.c
index e0b654ab..386c39f6 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -68,7 +68,7 @@ _("clearing inode %" PRIu64 " attributes\n"), ino_num);
 		fprintf(stderr,
 _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 
-	if (be16_to_cpu(dino->di_anextents) != 0)  {
+	if (xfs_dfork_attr_extents(dino) != 0) {
 		if (no_modify)
 			return(1);
 		dino->di_anextents = cpu_to_be16(0);
@@ -938,7 +938,7 @@ process_exinode(
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	*tot = 0;
-	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
+	numrecs = xfs_dfork_nextents(dip, whichfork);
 
 	/*
 	 * We've already decided on the maximum number of extents on the inode,
@@ -1015,7 +1015,7 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, struct xfs_dinode *dino
 	xfs_fileoff_t		expected_offset;
 	xfs_bmbt_rec_t		*rp;
 	xfs_bmbt_irec_t		irec;
-	int			numrecs;
+	xfs_extnum_t		numrecs;
 	int			i;
 	int			max_blocks;
 
@@ -1037,7 +1037,7 @@ _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu6
 	}
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino);
-	numrecs = be32_to_cpu(dino->di_nextents);
+	numrecs = xfs_dfork_data_extents(dino);
 
 	/*
 	 * the max # of extents in a symlink inode is equal to the
@@ -1543,6 +1543,8 @@ process_check_sb_inodes(
 	int		*type,
 	int		*dirty)
 {
+	xfs_extnum_t	nextents;
+
 	if (lino == mp->m_sb.sb_rootino) {
 		if (*type != XR_INO_DIR)  {
 			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
@@ -1597,10 +1599,12 @@ _("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+
+		nextents = xfs_dfork_data_extents(dinoc);
+		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime summary inode %" PRIu64 "\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+_("bad # of extents (%d) for realtime summary inode %" PRIu64 "\n"),
+				nextents, lino);
 			return 1;
 		}
 		return 0;
@@ -1618,10 +1622,12 @@ _("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 				do_warn(_("would reset to regular file\n"));
 			}
 		}
-		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
+
+		nextents = xfs_dfork_data_extents(dinoc);
+		if (mp->m_sb.sb_rblocks == 0 && nextents != 0)  {
 			do_warn(
-_("bad # of extents (%u) for realtime bitmap inode %" PRIu64 "\n"),
-				be32_to_cpu(dinoc->di_nextents), lino);
+_("bad # of extents (%d) for realtime bitmap inode %" PRIu64 "\n"),
+				nextents, lino);
 			return 1;
 		}
 		return 0;
@@ -1780,6 +1786,8 @@ process_inode_blocks_and_extents(
 	xfs_ino_t	lino,
 	int		*dirty)
 {
+	xfs_extnum_t		dnextents;
+
 	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
 		if (!no_modify)  {
 			do_warn(
@@ -1802,20 +1810,19 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
 		return 1;
 	}
-	if (nextents != be32_to_cpu(dino->di_nextents))  {
+
+	dnextents = xfs_dfork_data_extents(dino);
+	if (nextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
-				lino,
-				be32_to_cpu(dino->di_nextents),
-				nextents);
+				lino, dnextents, nextents);
 			dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
 _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
-				be32_to_cpu(dino->di_nextents),
-				lino, nextents);
+				dnextents, lino, nextents);
 		}
 	}
 
@@ -1825,19 +1832,19 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
 		return 1;
 	}
-	if (anextents != be16_to_cpu(dino->di_anextents))  {
+
+	dnextents = xfs_dfork_attr_extents(dino);
+	if (anextents != dnextents)  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
-				lino,
-				be16_to_cpu(dino->di_anextents), anextents);
+				lino, dnextents, anextents);
 			dino->di_anextents = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
 _("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
-				be16_to_cpu(dino->di_anextents),
-				lino, anextents);
+				dnextents, lino, anextents);
 		}
 	}
 
@@ -1879,7 +1886,7 @@ process_inode_data_fork(
 	 * uses negative values in memory. hence if we see negative numbers
 	 * here, trash it!
 	 */
-	nex = be32_to_cpu(dino->di_nextents);
+	nex = xfs_dfork_data_extents(dino);
 	if (nex < 0)
 		*nextents = 1;
 	else
@@ -2000,7 +2007,7 @@ process_inode_attr_fork(
 		return 0;
 	}
 
-	*anextents = be16_to_cpu(dino->di_anextents);
+	*anextents = xfs_dfork_attr_extents(dino);
 	if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index a1c69612..1a7a4eab 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -393,7 +393,7 @@ pf_read_exinode(
 	struct xfs_dinode		*dino)
 {
 	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
-			be32_to_cpu(dino->di_nextents));
+			xfs_dfork_data_extents(dino));
 }
 
 static void
-- 
2.30.2

