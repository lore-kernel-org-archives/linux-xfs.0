Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CD4C43217
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344123AbiCUFWW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbiCUFWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC5C3B3FD
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:20:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KJYA1I000642;
        Mon, 21 Mar 2022 05:20:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=qXT+OByLTsUysx6foIVDQsvHBABvJrDMTO8JqE1m67M=;
 b=fG/wCRL2yt19FBt+C5Khvd8paWYhg8h2g0MsKQDzXb2CHRk8M8GT97fyWq9c1w4yIVfg
 5cifo4oYiuSL8ChZRjfeBP7V3NYLvLYls95lcSW9Rv1NweR9/82GULoJxdlZ6fhEqPtv
 WX8baoAIAZ1M0Y1bE7j1DdU4styZUcvLfK/MzxJze7En9Bnt5Y5xzEkeiNXecIk8RCxU
 6MiH205+UcFI2f83YXZVOGsgoCHSx0eFqmR2huIfMe9G9w2rO9Aaj79av7naG3mnrOam
 F2aCgy8LyJkUegvU/VdhpIBU9ycgbgNSRRgvJvp2RotklHzhPlv1owBJN73ZOCUG5b2+ WQ== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72aa3n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5Kp6B125200;
        Mon, 21 Mar 2022 05:20:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 3ew578rnv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCJ7bPENPE07Bn0d06sWNzuMZ6JW1xRrX+8/1lB9bFPgD2Z9E8qsn4DQjzKpagjDZQgNyurYAEElbWgXNEswRC+kwPGjPCvafPjQmFpPyCIUq2BJizfi7BD0roSRiF1JCS0bkaQA/RgTkouP1YLOhOd99scxn1c6QBSJ2ypL6+gqXyB74qNSJ5hQ7Wkg4pzqNZfhvxTjLRkwFqYpE2HlaEcOM2Dvmoz+0ZAcqn3jEKpD8REs/bov0zuBZleRqRtko2Irm8cRw1SYR5lqtjUqXPpJYWXmBHjYjafMHoQxSK0VPCVnZELBdH/OF+6csHYavhbpUPHaPxvcQ8yR9GKedQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXT+OByLTsUysx6foIVDQsvHBABvJrDMTO8JqE1m67M=;
 b=UnvJ6vAZdq4/RL1XfrWb3rd516J4UbIZQ+qn+2JCudklDmquw3cUB8hZ2cbNam/Nz9sXEZLwMUrtMBcCWtpwHcc9f5LWdM/3ZyYJVtiW5qSmNC/KdISZaczQFI5bdiz5GO8VkgVrxp/MdgBuVYxtaRMG/y0dF+3NtRo9UUNJNDDhciRXjSaZMrCpmQPeOAwtTqjdmWLyFwtio+GG5Cq1C5jkStSj4634yj4RKDDdiDCBpUEQ+MCPg++T8vaX+c5gvtIPN3vo59OeEotzJ3TEACVVuOuzOWw0rLiLQNjc2tuFrzVqS+AkXDp/S/hu6CjsEsoFraF9HBRgRV6yzmFtUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXT+OByLTsUysx6foIVDQsvHBABvJrDMTO8JqE1m67M=;
 b=afI2BK8CXrR8KCbvBA0yL0j9RyfxpW/QLZwDm2VGwxzdHZz9HJUGWBE8CKqXGeAkGaxtQoLFcoOcsetNcng5LYXGf2DTAESkv6BrIgXN4LoDw0MTk/vZPVZcSTKHA0gVXn376MvElIbQ2sZ3XNsLoKoW8aAhtXk11qfwxpcdI0s=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:20:50 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:20:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 04/18] xfsprogs: Use xfs_extnum_t instead of basic data types
Date:   Mon, 21 Mar 2022 10:50:13 +0530
Message-Id: <20220321052027.407099-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b102f96-d308-4bbc-0d81-08da0afa8fe9
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55630E75F710B30302C99F56F6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ba9l6TZ0xj1rpX7PXy74B22lZGkGsVVvLJCeFHSUAd1ySyZv8NDOeFHJ0ScbpVwCEvSRCyfzxNMEZqsRvqDjKxWtZHGs2P9UllkbuMuLDqHBdAl1n8hZ1rUu8AGWlbL23YBV4CQsIucNdB9bW2DmgMWwDeXexSO6fJBuNgsXkAkkt9ATq57AQGSbLGlzJXK1LcHLSykWKTG5EfqSsckLhxjfBnHsupjialG/gZAy3VcICYJTlEpOG8eal93BXWcoPoAVT+BfLgOmyEM1reeIm4l80TFAhH2kbxMv0izQPpzSvHck7fKZsZ+K7lGsQlpRGHb+8MVbhiB+8SotSSW17Wx/N6nAZqorNBUqeymb2aIdoT9+9h6rYaqt6hZeLWrL/JzOziOWOi89QLuxa//niFjFF0GpzawNbClnUxwqaieqC3uO6Hd40Iraknc0i/YbEGJK7SlFjPV7X0w4eDG5D98OIdaliMVUhepN6pvJsm2hpPruIUw0E1rDb0VYBZ++UggbGudEK/HNx2mfYTTQFRSLNDVwUFi9AIBJQxpY3gdgWhPF1oWVzPCz+wK+5RtEizZOdNJEEPUXTkBdtoWLJSdYemQJudIffzGCMbq+a+u2Y8bks0Sr9/ZB/w5YcDicjQKJ3tWyB02uCfWC4c+R34WywkmFwZJA0gDRUuUFqqLjKoaE1uXu9XqWMt7zheuTWreJA0kIo831x2QAO0kyvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kDhlgM29cLpQt6t7pNBjv21jJiwyTryIAxb9XWdaJLmuFJSNzc56IxRPC27I?=
 =?us-ascii?Q?xu/O2H9pQY57lbv4Oe4hRXLuiCcj2s1s7m88EwGsjdOYYHKjaSkGGkGYBJB7?=
 =?us-ascii?Q?1TpFanR6B9J1nI+afRgz7ZH6Xk3oJD6XT7aquD5Eh4tlH8cf42dxkxje4miB?=
 =?us-ascii?Q?hVgZT/Mm4md/tileiO7KlYYIMCp9XieI3+tYjLbTvSfT6X2zOrE4G5C7hFEm?=
 =?us-ascii?Q?q/09e5HYIS0QYjWMG1JOsfXJKQtu15o/r+GDzPCm1JGJWYi68+Y8tuW3qO0U?=
 =?us-ascii?Q?kUQQs7KbOO9ZFM9yEUUe5kOyvcJQzEfOyfGzBww2mck06LB1RKM0NUEZ/Dzc?=
 =?us-ascii?Q?UVaoX1nbzcJBx0xKP5zvzyR91L3l1p6MtmzLammzY8A/AA0iSgtMLVA3tjW7?=
 =?us-ascii?Q?NCaUjxUyufG5wp9TUwBRxf5R1xCSRpQZLGh1oyirum9CKK1dsLq/bSHrzH3U?=
 =?us-ascii?Q?hyKyttTgQPRPpHmhFfEpu4RQe1Lf0YHSUWrsdhw/dlAW1rrk3PzWsjTH9zWk?=
 =?us-ascii?Q?LcSS8ipDXmJIrjUgRLdTFPgrgbjmNMJHjS2inw6kceDz1UFTH5KOvVEugflq?=
 =?us-ascii?Q?EPOQEu6Rav640jEciMtoS3Z5xqfXF7iU1ZdvHimFSJA/GePJxDhVVfdEoT8z?=
 =?us-ascii?Q?gGU3hHhOItWO8LMmTMGRF9AEkUKNoUBWMBLqCok2Is7wT7FRXxLoDjGYW/mg?=
 =?us-ascii?Q?gVc7Q/CQKhojuf3yDZRCEXTQmxNY421hDJ0Y5TbdagFqtDAarVpiQojJeJ85?=
 =?us-ascii?Q?AQFBb1uM6WSgYB2zwLAL4rh3rt/Ar4qiC/XfFFomD6CAxKL5SCcLp/6p85u5?=
 =?us-ascii?Q?iSZCQ2n3KdgsewJlMGhfnhJwJ73g9c9KyZ2zSAhhcl1D4lWyVLkX/ZZzEET3?=
 =?us-ascii?Q?KruQ75Cl3th4+up2lkNNeIxwls7jX2Fm8kTwm18eVSTuvBNOZ++3zntd/zrD?=
 =?us-ascii?Q?X/HqcglEMff2eI+Vz285pcCFP2iLu7ef3+wRQkuKBCDSn210swwO+vPvshgM?=
 =?us-ascii?Q?/JIYOcHeIi2akTGPutUvKuWzUvujN+drFazUS7znrLTduJ6b8cTuBLNGn6JR?=
 =?us-ascii?Q?41Hv0zicGxFM3L1Zv9cyINTqa46JKfsACp9AmdWisUsWI0OObQnL3w3TTfR9?=
 =?us-ascii?Q?p6be1fN8dcO1QHF41UTOk3MiUlw0WYmtOqGu7Pful8wMVaN1Og7R/nCYLffO?=
 =?us-ascii?Q?s8qJ5A6XGR1KUmpNXywqjvUcmiHDrUCDOgOvbtvfP7L8mTIRzWJrduG09FC2?=
 =?us-ascii?Q?F848BSuniNnhytEgbieYxre2axt5d24Qk+dXZ7KnaT8Ag3vO4sqpF3myRC2m?=
 =?us-ascii?Q?lqpuNZThex2MMMMoUapQVnCcKHXbHSYPtoDPPN83kLJdtuQmIi+IE71C455o?=
 =?us-ascii?Q?tdRkR+LjoVMpy0AXWT8MsoYiyZdfc8NnKXEmjB4cS5/obGPEtRb7SwFU1lXi?=
 =?us-ascii?Q?ht5qhr17x/7coN+4oUsfMVfaq+gqHtt+vuKxSwzWNFJlpyKgjsqR/Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b102f96-d308-4bbc-0d81-08da0afa8fe9
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:20:49.9488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nDLUdfbc6Gz66364alLIh14BuLqyIl1IqMKQuIz4P1K0uuQqReMA1Y9NpKPk9eY3f1CpxNUI09JwySWaOb7IFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-GUID: WAd0cu8gZAE5i0YhGBHK8cCIJ79Vwo7J
X-Proofpoint-ORIG-GUID: WAd0cu8gZAE5i0YhGBHK8cCIJ79Vwo7J
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/bmap.c               | 2 +-
 db/frag.c               | 2 +-
 libxfs/xfs_bmap.c       | 2 +-
 libxfs/xfs_inode_buf.c  | 2 +-
 libxfs/xfs_inode_fork.c | 2 +-
 repair/dinode.c         | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 43300456..8fa623bc 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -47,7 +47,7 @@ bmap(
 	int			n;
 	int			nex;
 	xfs_fsblock_t		nextbno;
-	int			nextents;
+	xfs_extnum_t		nextents;
 	xfs_bmbt_ptr_t		*pp;
 	xfs_bmdr_block_t	*rblock;
 	typnm_t			typ;
diff --git a/db/frag.c b/db/frag.c
index ea81b349..f30415f6 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -273,7 +273,7 @@ process_fork(
 	int		whichfork)
 {
 	extmap_t	*extmap;
-	int		nex;
+	xfs_extnum_t	nex;
 
 	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	if (!nex)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 64729413..fcd97f68 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -47,7 +47,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 12c117c9..15b03d21 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -333,7 +333,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 625d8173..4d908a7a 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -103,7 +103,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/repair/dinode.c b/repair/dinode.c
index 1c5e71ec..e0b654ab 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -932,7 +932,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 	xfs_fileoff_t		first_key;
 	xfs_fileoff_t		last_key;
-	int32_t			numrecs;
+	xfs_extnum_t		numrecs;
 	int			ret;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-- 
2.30.2

