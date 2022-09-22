Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9391C6FA90
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiIVFpJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiIVFpI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BC65B071
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:07 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3EAwt000711
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=W3FpxOO9g6Y7MM/XllFa1xVvqeAaBcbh1CSUGhEyiBc=;
 b=GqubKtO2d9SOO3o0xxF259iHjnXjSEiiHQRbZnNv6FRcC4UPH6sy1XD0+Ucr9q4Uwxtr
 tGm24VwOlvMOlpvRYVtwvBZWJIxpVkqp7kUT4zY1EzzumuwOEIxRPG9QYpTqlbca0Fa6
 4x82hG5um4xhR787bNHFEwfrB0Kcx3FFTQt4fePvj8bI7DO8uuPu+NI3AnWDX0j5sJ0V
 HVZ69pNEWs1I/9dXe5nyKuasJWgHvk8GipR1wiIP5fTjnWBsTBqS1GjnzsNTINrXh8eu
 qGH8ix/wv+HzVzMSqpV3F2IhgVg33DpquB59beT18x0Y8XwVN3QP9S/4oRpaa5PvnsKT KQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0kypf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M1PcJK037617
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39sd8r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXB2ZGeQOTXMC/tjdBncgfzAOIitzfvp6ZHB1ltfjL2q/R+Clw4rdjvUhSdTmoG/aPGIBleq51FqcIP6b365QPzTYb8iahjLhqPej1624HeDcmTxq7XzLvplG+SALIheroQ7YAPo1VJlJ2Xgefo1wBIpEPrccWmrkeWp3k07aJdtQAqVQbBJgjRtKiL5LwG56lA8ScYICXw6MqSoVAG1B0yS5FaLGcram1uGuE74Lf5122gtWrYS7roN7r+Da8np0xoNLHDyg8AP+d/ZaFb79ckfmoI8AO2aIyBXEVcox+bLBj8ll4evgXgDbDkJA8xklaC4duT5Z7ys594BMYQYzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3FpxOO9g6Y7MM/XllFa1xVvqeAaBcbh1CSUGhEyiBc=;
 b=Z+R6x6T7pJ5vlhEax9lNM4eubGKi0Mbjiyn3nLjBoczPjZo8MH0EvpGxC1gccnR/tNLnlxqmtkbf0vUf28ZsLUKqaixYgvOUtlBNzWnOeiGqo9ldZxheLZCa7K8iP5o+voz+MhuMRYrQkNdHlpuqM+vomL9uakyTNguBoYoowwqlEsvgDaXk1dVrSGfvMnhAQ8FC66076aAJdsDrmaQTmsjmkRaLQu8KPCbNyEZ+xit7puXMDWLXRuzPqvoNdNpnvLBdZ4fI8+RBLrCY4XorlxzUgVE6GjU83J6QfEsRUm/ixoW5YBB8EHCNrd3tmYkCIZtST20zOTYUJxQ+BDuqCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3FpxOO9g6Y7MM/XllFa1xVvqeAaBcbh1CSUGhEyiBc=;
 b=oiJLtTl05vUBs4GKvGREwJZc84vQMSj4vMfcvnIxlRbN2flTsHRoh+9oumqw7uGbpNPNrE8Fq9EqlXrBHmQ4tb/nkjt+aMep8XxbXPm9iSHHIRAo5SUQKR+5P5VJejl34PI1s9az2mhE1aCtlmWFr5vhiabcu6EYpR3a17Bby6A=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH7PR10MB6627.namprd10.prod.outlook.com (2603:10b6:510:20a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Thu, 22 Sep
 2022 05:45:04 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:04 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 02/26] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Date:   Wed, 21 Sep 2022 22:44:34 -0700
Message-Id: <20220922054458.40826-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0041.namprd02.prod.outlook.com
 (2603:10b6:a03:54::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH7PR10MB6627:EE_
X-MS-Office365-Filtering-Correlation-Id: d73536cc-696c-447b-0448-08da9c5d9955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k5NMAhal0+pFAM+Et23jFoax9G51yfGfNHumya0btIGXzmjsdQU0rXApxLEfqFTRL3nmR2d/9BD9l6FYc3gIINu7B7p1VkcUrdH27QAQzJegBZr5f05pfFnPE7ezivDRPOU0ySDw4jkq/gOnS1XAYCukNtpq95wFR9FYha1DuOh5YkSAZZPQ3anJ3+ms5wEVtFUCA9xvhfl6jOdAmGodBn/vLIPnHlsgByeGOlHQLclRRs2xU8hFk13Txkp77Bi16NS87zcWO3h9c5bOcDc+AUpqJ2tGvSt2exI6StdC5EpvhMsey9jjAjTJBHN9oD5Ne73bV346wew8RaLYzC1Yl7bD0gKGVcRfEZhwG8RRqqd6c/d95TnqR0KqLA0RKUzvj183xvcKnH5jJ7k7VHMYYnShAFZNnpzZB1odRpNkyXGzXFDRd6F5w32FcEdWt97gfSA4C5AhyKrd22SDhROYzUQXfmfWwnnjZAy47A1Q9psXIQI1LUD+FLO6Bj9fmLvsD0mb3zH3UL37K4N5NuLvYLyICG6eg8rQjWWeck+hBpBxLR/B5+eWzpFxFjsQg//u5HAlCfvHQ3uPk2cgtfKcB2q6iRvt5p/VWjbiAGeFfPoJWgV3xwEwQ89ipAPvHEq8e8Yf7SYBOoG5SNlcrG9tqy/70iUx+7FGCNEFQsqnEfKh4JYrez22ulOOTHbEKcOHdwbwe+5Vy0QmZskOnd+cAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199015)(316002)(83380400001)(38100700002)(66946007)(36756003)(66476007)(86362001)(2906002)(66556008)(8676002)(6486002)(478600001)(6512007)(26005)(2616005)(6916009)(186003)(6666004)(1076003)(41300700001)(5660300002)(8936002)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lRUZZciSPR7w3rVvENlLAe5bJZwdxQ067zpmYpDvl95Dk87+A614ZNdqaV9L?=
 =?us-ascii?Q?AYCbpTzpi/3py20hkayYd/NbTG9UvJw0YLCBZpdmfm9vYGynsYpEQlS664bO?=
 =?us-ascii?Q?8zfc6uDZnHjNABavxAcJjkH1F6rc5bvQD7wlIEeN5+wG4V1HznZk5rVaxsGb?=
 =?us-ascii?Q?NkrAAtH0BJw6eJMyWeRQAvJkUqDuUYW7KoMUqBISGP/I6F/kyaXzMv5pvNwl?=
 =?us-ascii?Q?PloTGRpoFS0SSaQy6QO3vfNyfEODS6o4LubI2m/YNl9lxNFN1gYG+V2utopn?=
 =?us-ascii?Q?YynCcNzCyZyFriGIxKuCIB/bjvVgbnB0qxfAoRj3gVSSoLXjo1ulK2Zn5BWM?=
 =?us-ascii?Q?quhFfm6IN/z3f8pINPITb982UwxHa+HvjgpsE5ov/TFTmZN1ouPHjY3Rjozj?=
 =?us-ascii?Q?+Vvs0yM8Y3oHXFZ0gBmb4XxaAlRM6btxkRk78eFvAGOmQucFtB7UCmvw6udc?=
 =?us-ascii?Q?SxBRKYkHa/XCJ/Acy5A6F5pflg71zLrtVtmON04IJHIdSnqLiAV68w/HEga+?=
 =?us-ascii?Q?Znmli+Z/r4dxsqZHp47wpA+F+5GSPGubrCMN8PZSfPg5lrTXHFS5hvEVQWnk?=
 =?us-ascii?Q?dUZnFldEvqqRa34DK5OGdL7cP2szFAC+74Obusr0q1wBzTr1zxPD9AFlQp7i?=
 =?us-ascii?Q?FM/hu6YhiRfxUF5rkFJgEy3lqHUD6zif9MsV6Llc5Hc9We8tEo/3nEcijpn7?=
 =?us-ascii?Q?xPE/oDK9WRgmXcbH2+X8MowFvwwTLSHWEL1sS1J3+rQJsU+VjPic263khf9P?=
 =?us-ascii?Q?EcuCodyZGJSkQeATJQVvDiL1aqFL7e8u5eBYP1d9pPmS1p0JQEtHEGE2Yyvm?=
 =?us-ascii?Q?IT5i8kYEoPnC/JS3pXd1uqBdgNZyEp/MPyd8lwRMqRqVX0R52iXkW2a0YJL7?=
 =?us-ascii?Q?1sq65mGkpFOUk0Yt4nnzQLV6zdc1+b7KNKbOUlVukpRGrha3dpB+Em6ZJX/l?=
 =?us-ascii?Q?6o/abP90HIN+10z//myjGwQkhxwJXuZDi1yBe4lxYl5DI91bzO3Mc29twrNq?=
 =?us-ascii?Q?vs0nUjzJZkICkQ1pkrqrkRku8FrRIEsFIdV0ndq/PimZEY9UjP5pog6TyGIm?=
 =?us-ascii?Q?jtCJ3NttyQxetRMkS+1MQzMp3vDEoxWgmlE0Ihe/U///3SgxhB7IvCVSYwGT?=
 =?us-ascii?Q?cumpDksGa5sYVY9uvSGCQs9Ctq2eZumYr+WBivCtwWyE2jLrp5nb5IlPrFI0?=
 =?us-ascii?Q?BPIuOGM77J4Xc6z2FLO13FW20wNWnROSyhfzUSEqwfhgpuySr5cQ9bmkHCPf?=
 =?us-ascii?Q?OgnnJjz0RZMgg2wBhT6jGvUuPEq/9Kn/edDNVyvwU6T8soF72vORFVKUnVS5?=
 =?us-ascii?Q?D64blfPzmlKyIC9oMCtooEPVEJJr1bRrMwmtinwf+nEbWeUfw3DagUj4SOK/?=
 =?us-ascii?Q?YI9hhvXSXoTYGpoO2/Cyxtrd8PVac5BtqMUXHH5kg1caTG5b/6/ctyuW6VKX?=
 =?us-ascii?Q?QUWr9zno5ZSy7w6cuiQ9kAv/xIzzrATPk8c43Ps9dcFnY5waeLTWjVHsWLpY?=
 =?us-ascii?Q?DsClvkiS5YD2RxDtlWqLRayOhimwK6LYiNM5oL5WnuFpAS8A80GpyPNcEAe+?=
 =?us-ascii?Q?gbrlWwAMPto6xM/svUNnPuyfO+N/395sGzOAC+7xVyrjfNCyw7H/cnhimh1r?=
 =?us-ascii?Q?iw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d73536cc-696c-447b-0448-08da9c5d9955
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:04.5505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e7WB3v6TaF254o7ga1XQMhHX/ITimAgEDN+oCccFqVTlZ4Du5xn7Gj6uXM8PjvFXayTIVV4QH48BCGRE6k+71oT1V6xFh7Yo/IB+HRTA3DE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220037
X-Proofpoint-GUID: T-q2d03VjXfRiKludbm759aKqrmADWWB
X-Proofpoint-ORIG-GUID: T-q2d03VjXfRiKludbm759aKqrmADWWB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
 fs/xfs/xfs_inode.c        |  2 +-
 fs/xfs/xfs_inode.h        |  1 +
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5a321b783398..c0279b57e51d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -820,13 +820,37 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
-	unsigned int			i;
+	unsigned int			i, j;
+	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_inode		*temp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		/*
+		 * Renames with parent pointer updates can lock up to 5 inodes,
+		 * sorted by their inode number.  So we need to make sure they
+		 * are relocked in the same way.
+		 */
+		memset(sips, 0, sizeof(sips));
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+			sips[i] = dfc->dfc_held.dr_ip[i];
+
+		/* Bubble sort of at most 5 inodes */
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
+				if (sips[j]->i_ino < sips[j-1]->i_ino) {
+					temp = sips[j];
+					sips[j] = sips[j-1];
+					sips[j-1] = temp;
+				}
+			}
+		}
+
+		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..3e4029d2ce41 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with defered ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c000b74dd203..5ebbfceb1ada 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -447,7 +447,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa780f08dc89..2eaed98af814 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -574,5 +574,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 
 #endif	/* __XFS_INODE_H__ */
-- 
2.25.1

