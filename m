Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032E5C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344387AbiCUFW2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344390AbiCUFW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6096F3B3FD
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:02 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KJNiEv019422;
        Mon, 21 Mar 2022 05:20:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=zIV5Rpot0/nRfLYok0GQXX9Gm4GaVXPIO4Jps0RyjHA=;
 b=ARr2lNJC/D9+PR8zWk5Ym7eZEFaZUQiT7eomDVp7Sz3CThAIzH6ZRykkUN9qj3p/Dbxs
 XzIisKl5EqDhDxpkI1bApiSC7K+7dhJemO4TqovWDqTR94eerFVa4IGWVEMGb6uqs6Ks
 w3c4PqtHHnGR4vXfCBteMQ2yIRLQaxI4Paw1JiNvhN/ADWfvAxG3v/FFfVaBjXy9hUb2
 SslX1s7rl2qM9JAx3mKfFu2yYOYbTLcTEL3F0auTKmQEc6O2lVKvT9o/hUiC29qdF3nF
 32C3WUDfmroPCsj6rtGtT1TiFd+hWxcin1uvckCzlRJ8ZdBBmHOLCakk9XytADueIXe+ LQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss23jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5KMSa163191;
        Mon, 21 Mar 2022 05:20:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3020.oracle.com with ESMTP id 3ew7009772-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naEldaPpLIBLm9hGKsbJLOtZHutttFOwMVb8sVB+0CNIFsOH2o6XvUH7SZSIjDuwzc38rJnrIAk389mqXBuZSgEx6FewS0lvQH8GW95mUl8a1WwIEuVSra97WzfLLhJV7z27D++B3IrIqnccLf7N2LvV7jNvIAaoofzfaYDx0jYOWzeZEhSYIUL+2lZAExFZrkCqAn9QKpNmD/DdU8ECMiKki3+lA4cBrwml/UFysABv/FRWlu9sdKcDHeTArSK8xxeU5anDcpnq4sqtrp8Ai3i5xc7Ys8ENkZ4/F9VrdZoV/STKKCyLk0AF2pOxvlk5tbTlnSOAhwGCb1k7xFWY2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zIV5Rpot0/nRfLYok0GQXX9Gm4GaVXPIO4Jps0RyjHA=;
 b=RbAZAfkScbdEZNs2Mb+wVvuyxQos0JB1xy29rZ50Pv9y7eVM6kBaUeTVpxPTn4DzEtWhAhgkojkEqA6eRVV8O71unZIgS1sgd3gBoogNVAzFa0rEKRdWsTgbow3diMGQeJn0kpS8z8XTNX6T+nmQRmPxGzJMrgD5nMy0zlowPt2jtfPSQUADM4Olo/vb2Trpav/2GW8+utRmx4VED30LP3knGGlzQzjzEJF76tclzMC/35RGs0obFdMCh+DfC5qC0LMItF8h390Sgamew6bBFUhSio0HbmbQePm28Ym1HLAgoY85Qj66mshJrD+aENsBT7was0Z1T4yeQIXG9+cmhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIV5Rpot0/nRfLYok0GQXX9Gm4GaVXPIO4Jps0RyjHA=;
 b=BiJHjC6bDxtnID/MXcyIqm/I4gVJ3VjKyLCU81QuFuaazCy2YaBE5fEgQGw6B6jvk2h8hDgFoDjuK4wOAN3Su6hvhP5y4+RJFvnpxLHJulRdZijfc/514DkTRYvthr34vk96+LA6qU8EPvZEt8rICuJMZGL8/qSTR7MX9UoHPNc=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:20:56 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:20:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 07/18] xfsprogs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Mon, 21 Mar 2022 10:50:16 +0530
Message-Id: <20220321052027.407099-8-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: e79a5175-2a3b-4e92-14bf-08da0afa938d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5563EE429FD402C56C57B4FBF6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j2tNd/nKfTf6/zYDz4Dx4jbV1HOcndFx3v7irySIjFS9Gy+nHYQjcwToDVNo09OUG9n1q0IVGLhItOlIDNSpB0ulTtdYyPgitoNzQTplVsjviWK2289CUiXFyf+0+3syPvd36PpkNfubOJAm/NCafl6qmcARv1nao0AdE5FsM7tr64wzlaVYov0Liv9GyZ7D95+MaAaNhkOGNTONXjXysbdUtXjf5XIlimpY5kUe2/MKNBgko7jR9UGEiUTtzeRWsL5akBmEue+tU53/3I/XXl7ia70VCbEjhvLdkwwMZUf6B1kdnUrbTIprS9n7X15gfmhIbhC5vRFWHhotiD4wY4wbGSplMEZL51k5BLiSpQxQoYUuya+e06kiB/KWH+kRD0TPwmaYOdAZcMUKLBVz90Rfsum74tF5He1hxQLK+EqYecDil7KJJPk6xC6Hx3PsfGq320xOWiboMNBeFaQCR+ELqorgC0KZgTGGUeWMzzAMvHTNpXE147r6Jgd+5hE+XoqBX2ViX+mFm1ioY4w6MQ/FbDHXDURPznmwB046YFab5kPFIs0JgWVFkZdj39Samkh5ZgbMLlnkC+/UnQST0mmBGH7xmFamTBgJxwGGp4E1nWTvqumf4XuazuMpaoqy2AI4jBW17oZDnSNALqCxnCU38Jbm3NSkV0U78AzAgN7TtIPBYvhkn4NhQjEjq1XySczb3P+LnrnyRXsmuPTljg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D5cM5Km0Ra+9IvIVbgwmc6121ePG3XQ1ixvQoljPL5M8/K0Bm0qTAL8a5nqC?=
 =?us-ascii?Q?RQljqlidvhmkm7VhdISXJz/+akZJHl70WNuDGqIdYGVhv+3qm9aBjc4DNgVq?=
 =?us-ascii?Q?1VBWmPbpiefP4z4sn7zO7OZtGgm0gPlCCIpI1aaWTGLojgAEh+OVnvJ1C+Ck?=
 =?us-ascii?Q?UXhO3AH03T1kYx80huCCfl7kgWJw6cIyD3LIODFBf19CUxDUTimQXKA/xd72?=
 =?us-ascii?Q?nnrI0a8i2RdVVAsMxHxA3fjGfKKrVWf/VfAscZP4D4gcWN1y3gk23B5SgXbQ?=
 =?us-ascii?Q?G1CDdpKVLdVHrKv3OCa8isipZCu7AZjDlxGqPx55lUgtyKDEc2mV84CuCvMA?=
 =?us-ascii?Q?9H1Nva4K5gYlXcFpKpEdt0EJR6AqvmXeEOsoF2F34+ADm919r8Zj306FKxlh?=
 =?us-ascii?Q?U6BVVIS+TQZE6FQKFNm+fCmH+KIO0F7UMw+btfFI4FRJYz3klwEKb0v/map0?=
 =?us-ascii?Q?ueB1AQZyyzNUJg+mOxs5tYyvv3mLmLDmYCZQzNmFVcRP5zWNSpIlPOwJHyD8?=
 =?us-ascii?Q?T/5cy3XpPHgOWhyvyr6Qf8yq3WZSb9f2cV6BGuHfRhJC8nMftbQXFyHrm4sI?=
 =?us-ascii?Q?6vFgC2Vv6GyjiSVLfYFYeNSeQZnEWjuuvKDIe0SwWFSjuoiMcqA0w6cEUmlD?=
 =?us-ascii?Q?dtTnOTRd68KZ3TmOdVZikqFSD23+BjRBXyko9hSOEJouzm8l7F0KN/NXeyeh?=
 =?us-ascii?Q?Rxl+eB0QgU8naqS7hfPTwgw/NdCNKHJ15rUE3EDZzT30juEa1asDxCmbFRWs?=
 =?us-ascii?Q?j3FJ6fRZT7JWb26Tipc7tFmXPgNj0pqcAziIU0HM8njs3leshGUNTEPBtRFa?=
 =?us-ascii?Q?d5f1FEbLIhCdc3qG2RBfK1nnW8VMOJMUbAY6s2O1uN1E2hYCNC9+BlgX9oMi?=
 =?us-ascii?Q?vnd5ff62F8AuLfnW5OZu0q0n6QgsZQ8DuX+ic4kw3xOwFaT2Y+LIs5/mIUdR?=
 =?us-ascii?Q?KTMQ01yGb0NlgZYQdUH1fxltluZup/nVSKArkbCYTaP5W5wYyPiL5CgbkgdU?=
 =?us-ascii?Q?3CGNMLCLd19xNPV9cLVTRP0/p4ke4mGg3kkdlkeKRfOc7yP3db0adZ9rMY2i?=
 =?us-ascii?Q?fKNdQGG0pqUXsO4ab6PmuK+ZdoWVVuzHmwFD5pNeNeEV9n2BVNG2ST15ldeC?=
 =?us-ascii?Q?Pcoi+DaqNrDHemcKAZT+DxVhXlqyOrLaACWa3HafODL5CjkNBinzlDNtcDLR?=
 =?us-ascii?Q?q1J7XnEgS6xzja+L1xdF5I4QP0EekA+vdzzXpBjh1nx61PXMrMifQhWmv6vK?=
 =?us-ascii?Q?z1Bwr5vUx6JXE7AOhHpDsGpIus2vbvvTRgHTgJcFRwkA7q64l2+TuQtcsUof?=
 =?us-ascii?Q?AQf2OF1l5/P2zXhib+G0leK3S9O17Wtrd35MeR71xh8vtfn0oM8NwFyRL7f/?=
 =?us-ascii?Q?tSX6LwF3RHEhRCbzPtjoeRqJU/1XB3a8B6A6pNQrmWLCIXtOKO+5HkklngXC?=
 =?us-ascii?Q?H6Qh4Su6QacYqiJly8WJcLxbcLCKYM3NQHrpzYo8xRHTHJ8GPtTcNw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79a5175-2a3b-4e92-14bf-08da0afa938d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:20:56.2769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ickVhO1mpCzYOBDv4n1lcubHH5c3cvDlChv6m9xIUz752C7PyjYNWW8uZFQ3HeW9j1SS4+85hSauzIwncJWEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-ORIG-GUID: x4j-vxrKjXeyfPVhysbdWBnExmPvfueJ
X-Proofpoint-GUID: x4j-vxrKjXeyfPVhysbdWBnExmPvfueJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c       |  4 ++--
 libxfs/xfs_inode_fork.c |  4 ++--
 libxfs/xfs_inode_fork.h |  2 +-
 libxfs/xfs_types.h      |  4 ++--
 repair/dinode.c         | 20 ++++++++++----------
 repair/dinode.h         |  4 ++--
 repair/scan.c           |  6 +++---
 7 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index fcd97f68..1e131c4d 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
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
index 0530c698..dbaff8ba 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -115,8 +115,8 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
-			(unsigned long long) ip->i_ino, nex);
+		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
+			 ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
 				__this_address);
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

