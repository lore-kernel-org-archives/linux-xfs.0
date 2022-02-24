Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D509C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbiBXNEx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234755AbiBXNEw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:04:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE91737B591
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:21 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYb9F016953;
        Thu, 24 Feb 2022 13:04:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=2kHdSxkmY1lrmuT1Y3/bdHeXXn+4XDn6wjCnZ6Lc5j0=;
 b=ovL3DMNkUm8Lc4EqEviJvzqLTpC+ggFuvlT1VZeQIiQkSEwcLBDMcBUcpq97QYHQw4GH
 CJZO2Ws0FEut/DWO19uY45+fkALWCxYV7sIwUlgaP3NAw4yB5SH7yS60uAsFz+sHtM+8
 GeDivgNUsZld2+lUR5xGyDY/nhkSENDfrbq4N+Y88xvtA+U1YsBNBKetEORkScoizog+
 2pAqPSNkrvgASfyAyuyOsVQMOmdpROQIQRoL52vhjk7pgvQY2+dt1mZkNMNVTXTCDdZ/
 TPHjepz7oE7xW/vOI6GFmuLOBh6RamIMFZntwu+PN+xTSyx+REbRLAX+dbtPRKaHEISQ lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cq4fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0YKk120588;
        Thu, 24 Feb 2022 13:04:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3020.oracle.com with ESMTP id 3eb483k8ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKbxZ5uA/DJrDc1yzEi+++10kTxCS/D8jiwf+7tDgcdR/t1jr7mBj0I3VI+HGBkU7z4xe3tsHK0ShpaRVSsPptKw6NPHp+jOtBLnI11wzLi5lLUzGS3T/GwxqfnNpbhBKxAujzYLW/jufi0QYg1lCA2Mhv/3DIZD7u2wkrramL7P8ta9BEWL94OGohYjdx3DQ/P9TLC6nxsG/cuQHurHRekUZaXGo4If0cfo8SCST4iSJwXZnB3TmrgmW+iubdzsUuCSq+Wyai2SuxBJHsAvSKTMPRPzZO4EkpfxlSr2jHOJ8oe4aczqI4ZwUM+IR1N89ivqXqk2B9v04K6hOT4qCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2kHdSxkmY1lrmuT1Y3/bdHeXXn+4XDn6wjCnZ6Lc5j0=;
 b=TB+mBkX0+dEjiF1kBqL094SNXKSxbbsOhWSs0OuoEL4x8i7Efl3Z6cQO3J9R9SbB3VmMR9vz8p+Tde2g1RVqe6o7M7CqJcvPSh+u1/YIsYlJgIu4M9feR0sLBJ9ybsA4OnYoTBf4lv7qikLfpQ8kfd1nbDJI8A+RlwcEfDIfUeJhq01KMnsDMZcgzn9jq9Ce3z7+yn8hWLEHA1UDXw7HJWl4PC0tIU2A3fcS5tqNemXNaml32BoeBD332AWUAOO9z6uc7ZpsHpei1CM6QK/Dnae6mbDeBw1lrW+l9En4YEIVJMkzyKN3Wz1tNfqiongsB6RgfP0zOvAhpl5ec7OSVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kHdSxkmY1lrmuT1Y3/bdHeXXn+4XDn6wjCnZ6Lc5j0=;
 b=ONsUlYU0CbaGyKV8T18xYLbwsPJr90YEVXXqOmRFaAnCOBh2m6Nzxp9zzps5IrpPxu1dVYVQOMJJQm9FcvEs9zbjtu2FoiTLL4PqXkppSOmgCAl0/cnGcngzfDpeygre5xLvTTxepCEe/O7ZJbcqhRK/3t2wsLlJYujcAYubY+4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:04:12 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 07/19] xfsprogs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Thu, 24 Feb 2022 18:33:28 +0530
Message-Id: <20220224130340.1349556-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cc3d570-20ba-4f54-cd5f-08d9f796274e
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB463403A9065DC47DC650009AF63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vBbrATsd63D7S55NFB9s620XTuXQLn54w5hayv8HbHxS0WdaHK37QZY85b9mShpvPW2CmbSYTBVsaYg5UU8PnDHdiNZZxhZgu1LitNRGXm7GVth4BuVu7zcVL2y25DPkgPFBWfhs1obvHuSmokxP9HEHYusoOk4CRHeBKdIL1JyYZGvQvXU/6lwVU2cQOFXb451y4qs1kgS4vBUY2UbsPYodI1sUFw9SaKWy3ywdTgvkL7KzoOPR6JHgFNXc7I4K9ROWripuS4MoxhiQjV/OJxX15SG0djGzq4JRTfhZer1ZCTZTYAhFzweeRa1y74rAdWcAbAExvcuYMFCw+tspUBFQ4E+Yu2jyEeHD/Wi7ApfDTRelZSTeui3Tcw9dmub6G73VlxLd3yy1/kFFqByffVcRKkGpXWSA0DMW6+Uk8c8k5SrFd63Bb9O2Y1lPfBCw9MA5dlSimczGmidF7xUxA6b6WyxXb4ON2yf4DIEzDaj8lZCJ+BAYX/D9jD4dFVbrMOgmLWwDnhltU8ULayX/7bsjMp2me9tlxQn1xeHBExZVcX5UXCXaPdz2pG+DqtSOeROQvNHbSNfZczNqrWJFrzZMOU/Ur96EK33+lo+FoOT2S5QlMXxN4AHBwE9kSg6EMri/a887x1b2msgsWS1deGRcxGqF81OZpblX+Ve2tgHYwwZWgF1DC62qeisWvf4qA0yDwgYxt1QJaFVCBGZhpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MM9gw62rhdSIMgsvgcK9R17Vlc4W1L1bgK+9/Cv6HaTqHrd3wbK4h+hYKUnG?=
 =?us-ascii?Q?G2+IM6+oY3dH36cSwhhvvCUsossH/9DAPazt64J4BeWXenPymZ7xviTr6WOy?=
 =?us-ascii?Q?fLMpsHEC2mZua/TMXx0TE/UDJs8WOG+o+O8DLGdvODzQSc8LBMWnCqSMUcQ6?=
 =?us-ascii?Q?PbmUNPf7qPB/O0HRdtC9IXRlHIYamiUmAchOr++TUM+N++N0eeiDi5aEkb7X?=
 =?us-ascii?Q?o3ofUs1pxIGb8lCmNT6MUh4wC1c6axLFrPMPmPYZGK07djAzA0H71lfhG1of?=
 =?us-ascii?Q?JjjWPZdlNnJCBSqaEQTgv3T4gp4yllIaiR/fg6l+3yaxCoNNaQalrztOXJkH?=
 =?us-ascii?Q?bLE/lp+DMJgrj/z7wCef9rnVjIkrqy0KTEykUCGczTy19mWNleOapLwWGHt+?=
 =?us-ascii?Q?hAZwkTVK7tJQGrUwIFOyhB/sXYyjoGbTEFlgyhlbNLsI6SjCba8xF+kY2zKF?=
 =?us-ascii?Q?HaI7VbhcuNoejP7d8RxmcX5eD83achfcEWXgc6Nvkf4h4nVjNaqUfTaXnbdY?=
 =?us-ascii?Q?JhVPxrR8Gv4eKKSRHwMAgdPB4pZ+Omi/BQCDvDbpil3M9LHr+3MuDPSuAEZZ?=
 =?us-ascii?Q?scK8LJBlaVYhR8iDbnE4DRYhl2tUZBH5sivnWea0UT7+XN3yyHZHW1J1265J?=
 =?us-ascii?Q?voACqKusjy1C2wtcV+pwpJASVQn0WHdNtv10awmxZAnfX/7rKDIK72ww805F?=
 =?us-ascii?Q?xMNbSqNgZ5Lfwm9stk3ss4w8P/cTshcQEK1aVz+a/kzzDBFLvlAe26sD+Hf5?=
 =?us-ascii?Q?kHGSDbwgBhEDJ5t581ZjPT5pXoX61fuRfXTvbXgvItQBeoUl2JbT+j4Lrj89?=
 =?us-ascii?Q?ifoZfDtjl2R56wMYcFwSfpdwvjg6qRM4ZZSQbJqd1WCMl0tuaRl7wpeLgYI5?=
 =?us-ascii?Q?Fy50vaytYaQOq8upMU/wGAcOnO5NeCywn7zpBnJv5lGi1rJs3Eku/0sl/vTh?=
 =?us-ascii?Q?mhFZB+fdBVUz79dSy4va7jrk4OuRRxz7irs31JZOPzY1WvsVBYflc249TRfA?=
 =?us-ascii?Q?MgDJLGYkx+9BgDC5d/VNscvGPhHqHQmQCGUjQ+e/cCmULEf9jlGxjFuuzWDr?=
 =?us-ascii?Q?Iy1L+HJjDX0/AJoCdpLI5mB6BeNAIa01j1sxp+1f477SL5q0HEujOEFOBVHO?=
 =?us-ascii?Q?ylzoKYAqpKbZjvyVwP3pREFwleopvwR3npD4Ho22cGSQM/w1uMQZrP935QED?=
 =?us-ascii?Q?O6SvcZwQgBZzTPrXCAvSBYR3DRglAiDCs8oXTOilgPzl3HG7cgvIxcyBdsgn?=
 =?us-ascii?Q?09N7965qdmqjSMgryWDcfSFKVeOGz7Vd4ZG0WaMxen9M4o96czUcOjxJMB4b?=
 =?us-ascii?Q?ph/vteu1jLIE/zgcACaBpdv9/ctzRn3HKYu9BxLgNlGItB0ZPf/hxO2nwpfa?=
 =?us-ascii?Q?OHIKoZqxYU+sjyahjaCdoDO+x/p6g5uw6Wc7l3rrNoLEwSi4OPNAQelj2P3f?=
 =?us-ascii?Q?t+KoSZ5EXkM8qNCgd/ZaoO+dkmjX0MVnlTLydJAMeCod6fmTC/6DI51Tj/Qe?=
 =?us-ascii?Q?KwHyW+t4KP7uD+bN1RDdlBItnqyirMu+jlXgbrAmfg48mGHZij8QF7HdjSnx?=
 =?us-ascii?Q?5mDiOmSHVmIOYyPjKd+SDwb55178BZAgO95TCqYi7zB+IospZoHGx6rLSmtf?=
 =?us-ascii?Q?BIMr2j6GNXqcdS9xoFEWDew=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cc3d570-20ba-4f54-cd5f-08d9f796274e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:12.8922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jruAQoZLmT0JSZ80wQ/gNacu+UzVvwy08MU3HyU4j8YymtWt/Fn1m9TeDaDwrJAacWMVE6690znQTXSeCUTZNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: griH1FGag_EgFuA_Zo0zQDbQklVPMxgj
X-Proofpoint-GUID: griH1FGag_EgFuA_Zo0zQDbQklVPMxgj
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

