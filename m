Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458D3C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhLNIrO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:14 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2692 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230007AbhLNIrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:14 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7LE7F022068;
        Tue, 14 Dec 2021 08:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=5mzyRsL3zvWPGRI9Sgsef9p2C1woS1yhCh9lMKrPteI=;
 b=Oudhw98XyQhwd6C2CnIYIqHNnYCsyx0qmZkCgEXdCUmZEe2UYlp/LIBCzMLxCQX+E9rz
 N0okVNwMZVEGBbFEe85gt5SYmvs6WXdAQrOg/LjtjR3+MDKu+GCsBrvPLJLbDDCkAMga
 sW3IJiTeL1oI1vSghXs+ZUEk9O8CFZkTiAdG5xHLwDbRoKSaz1QgAz/hV8RLlEQEcHn8
 QcuD3hWQWiEaAkQw0bwkYzYajF5SLV6424SbSgmkLhqqD1GxsHUEkKyyx2gClY1S7U8X
 2fOno+8B1ApbCmRU8uVEsBFLJjmehAuYGeqBcEpIGlPNzh9SxRkP7cQxwtFfMVSXtNQp hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfb6cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8eRAa074131;
        Tue, 14 Dec 2021 08:47:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3020.oracle.com with ESMTP id 3cxmr9yg8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivynTpkDsjaSVOis9o2F1MATl5abCjwI001nN3ZIcx246bdbd+V6dV1xj+g7Fm+dkQjubO+d980Wl8KLNq00rERGATkszE5zKpMF+gvD4uU/0gEGPJB4+l+sUehmLX6MJRYU+SeRBggeT+6lB09NH63TOmtuGjr2+L1kgcVu9hNya68hE+Q+lklBwFxGanYTCFOMXhEEkl4W/ZvvBD5QYNBQLnuE4xka9TPnwMsDQr06fC+QH4CLgVOxfnGXX93EMKvNyRGU+PCGEzL7GOkaJ9+1RIQY408oENlEuWrBoXxqM7hNx4ch+92/GQaJfxAxtNBOWFQuuZEXFBNNWK921g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mzyRsL3zvWPGRI9Sgsef9p2C1woS1yhCh9lMKrPteI=;
 b=ZLYXiQqKvIbYV4HvzEFkHv/wfTkFvPSXZJJltBXmeaS/OgXiuQuc4eQwxAvbXoDTWe6QErQc+c7GevIh0RRKiZnCPxA76He2nng1Y2DPZK6uIM0wIDlLbI4obspcFNfIgsaOYAtXMrroybDLoDR3fvNq4lLHNCOJRmjmQCQE+mI/jf09J8SLq1YqvT3ynPhT11U6cby5Jgf3aKyXIVDsXgMAFkUTYK3d0tHMxyhuJlMh9aQgXL/3KnTOQHK6pAwAsGKNxMAsdaUOCAwsruPYnY9MryrgDO8ToNH/xhVN+bRxXy1v691GSzLR3q7TzCQj2CT/KXqdo8w9Ss46OZR84g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mzyRsL3zvWPGRI9Sgsef9p2C1woS1yhCh9lMKrPteI=;
 b=Y2SUANGRc9RLpXzGCuo9IgCzCwEfPSRZJMG7NZjpOTYWm2ujJRPqFZm2nHV2MIoVwncrRg01gwDzFI7qXleqvBl4tjT3954M2jpxIceFOisascLLEIwZl+FJz0jSMv0UVmckifSGXEcX2fjx89cn3EBAeoeX4a4sQlC/mSGrMvU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:09 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 06/16] xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Tue, 14 Dec 2021 14:15:09 +0530
Message-Id: <20211214084519.759272-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c760ccc-1d7f-4535-41d2-08d9bede507f
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3054323A1C98AC1A712238CDF6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0j6dl7iXuVmIBi8ztvPHR/fv2BiNirQqTEWbMODedm+EF2RjCkeg4GQKVusdb5RpDaYEtH9xyHgmCTITN2X0wCd59INWhaZ/xnxoW8gK9S38BePai/D0B83gGZzWDuA8qsMk7R1jvwHDm2cUXlzzVK8iXVZxb/f0wFFu9Zb89mO0BWwzKd/DTc3qf4Ik6RkURwBo7nTONIJh9VXuPkex1OzGZKfrmWkrhXjS9Q+S8P4kCSnaCi8zh7TPOva/v7A49FUZG9FJqjSCQHYgvzB4g2TDC7QRUBHUrgynmRKPG904VGmGenK8b1bxabgSrVQuQwitLTouiFbiyn7zGOk3RG9Rq9vvBC7z4/xnMalB+s6DwbAqQtb5BOuK/Yingoyu/V25cS+tpndWcYQIdj11GZbWiKspoxZmkmxtX/ObMNdIOFqAz/GSmxDmJtRejUMdtw+VZGV9DCS9rLcztFC+2cMtOshHwF1+k5O0joecFsZ7k5AGO5lRLasXQPOH3MYQ+jjP6dFQnQQahhvAL+UNoXAx/VNTkmSeFGAhdsb17GqUJ+Hi+E++I7KG40xZl9Hgsd4Z+FWYCZRuy+pi7WkUD6FV4KPqoa/gsMtmU8PaA6B24aSpH6Hg0x94W6O0vaYzOF9JS5SFtonBbI1Majh4S/0FBRduVtVH6rtHWt9gAQXQYUCBdqLdEODz8CxWe4bJ45zI7UYowZ+emhUMwrS+Dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+4gCKk7nw+n1eAxmrEWdnQuncTtRNxMEYIygttAm1DR2EDsB5sYNzj9yoioh?=
 =?us-ascii?Q?vaRzGR8i2g7OdsdAYR2kLu765SU5I07XJvr3/CQn1x/xwdLYKNDdQoPy7TYE?=
 =?us-ascii?Q?cZjWIgE/7Xm+lsGma/Rrwzsi4J3TwJIEJ0s7jYXyhJFZwsZc2WY/OXGKd0py?=
 =?us-ascii?Q?U9xCx++sos99mpXBDZvIgtezi8CtgeCCJGwt6hkAdiV9mkGwW6KBSjkU6R4H?=
 =?us-ascii?Q?dxPWCLlD39OvJjnKm9w26YgDEsZkW1XYUtT3SmPXhRPCpwJjq0UG1vbTQTTI?=
 =?us-ascii?Q?wcn1+nYjj3Dlp0nwqd1tWi6NcYzLFHjzjT0sDPEwtMZKc9ue+NFzWKXdKaGX?=
 =?us-ascii?Q?5kKRwAYBllzE6WbSoekc+hCvP6YoYjhax/FTuITffJiVQIX+S1NIA8s1x46/?=
 =?us-ascii?Q?xgulBNPU5LMztyzqAdIfEKdXdQ2wyjfbQ4dciuhZj8ohIbRWuF74Bi6MZBUI?=
 =?us-ascii?Q?0+5SBfy6Fve5iyn2cfxC8A2Dzc0SIao96VB6Mun39qPcV64QdeS+zDlRW5FT?=
 =?us-ascii?Q?uY+3IztahWjQiiABGlO2H3JOYyn5dhHvXikcf+KiiXa27f76sXMd6m4Pg7KS?=
 =?us-ascii?Q?5er63lhMkniA5MJ1tXdXP0xF+CapBrBI3iHYu8xU0Q74F3XmcIUoN49KaGLH?=
 =?us-ascii?Q?GHp0OdnxnPQZ12UNmfmJxDZTNhZgPtn8BG9nWKUeJKZCNYYSuUVhAGKHDoXr?=
 =?us-ascii?Q?LCW1ta43Z/10ElL1jSzCU7iy4dSwrtcPVhUHSaMxxBJD3Sg1ra26n0cj/Wh3?=
 =?us-ascii?Q?BTV1ruPJi2AJ1mHB5x3Mgnh9SbOPLhf2PlRVSrM2szUHB72gDzv1VTJwBCAD?=
 =?us-ascii?Q?W860jx/FW9Gv82RZrrbCl0DRRU8fMtbIv/lT7cdMtpR1UxbrkhqJuNaByYKL?=
 =?us-ascii?Q?Ssd0LgCkbTh7Zx7ABzmXQZWVVNUvapTsB1xRtTBR/5JLsk3rjy4SCoSjNaTd?=
 =?us-ascii?Q?Byes+HFtYve50jbjjWj98fT1lfqP6tZuIO8BkwxTNivhT4sgQJzHAcJlmvfm?=
 =?us-ascii?Q?OwJdaSrkal3d6jRcBsdrYLr0NqDsKapoiQGY/ADmbjmiS4H6e6bCMOapMaZm?=
 =?us-ascii?Q?9dLrhTX8iybFdBYuHTolhg3k9vervlsBlM9H01X7ZeW/j2vk/Wf7/mLRj9ka?=
 =?us-ascii?Q?X4336PK2otjrlUbgRFyQr76q0eM9XGGWAMEokEHCZ9af5rKoVvDQ7XE9g2Ss?=
 =?us-ascii?Q?b0kNkeRJGSklliL8vpFcteDPDtq8g/h1/PjZyGvt9tXC3gNGieIQ0LMXWILE?=
 =?us-ascii?Q?umQL8pan5icBYbo39pZzYHsZMJKZqbzZwT8BFtO1Gseh4j6zBhv9/sWcGUGT?=
 =?us-ascii?Q?AY+mcYel3PVCW5ulDdCIn0sjyB8p66qX0zafuKU2LRDjqavZb0nx2Tnz8OJz?=
 =?us-ascii?Q?eAqZ1WeElNLUL78a1C+fBejWEEdLGVaLcbsagCrMbHMa6KacHLn2tNq4iBX1?=
 =?us-ascii?Q?KxUF0UheYIvGxDowNk2EStre7LwkQxgBNaS1pGX2ZbzwdaMrxeDvI4hpu9XO?=
 =?us-ascii?Q?DnSy+vvYV6x7N0NCNSGPyVS5c/A9UxNm1yQUxkTE1unDc+oBpblK51THs4ws?=
 =?us-ascii?Q?ZYB2sppEfkFagLXVP6i4H+VqBFreYCyvAeyo0N394iOIUGWKRIC8n1s4rqmI?=
 =?us-ascii?Q?1uaA39N/P1F7mYAcFPQ4Pvo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c760ccc-1d7f-4535-41d2-08d9bede507f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:09.5575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8H+37owlUaIGe3omGMUMZ3lUddluvCTkMaJph1I0Rju8W80ilzTnjgZZ2RclkKD5IksmdOqMYlIyuMPIPvUyfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: ZIjzvi2j9r7ec-gJgwoJkNafT4PUcfO_
X-Proofpoint-GUID: ZIjzvi2j9r7ec-gJgwoJkNafT4PUcfO_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 2 +-
 fs/xfs/libxfs/xfs_types.h      | 4 ++--
 fs/xfs/xfs_inode.c             | 4 ++--
 fs/xfs/xfs_trace.h             | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6a0da0a2b3fd..4071dee181b1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
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
@@ -467,7 +467,7 @@ xfs_bmap_check_leaf_extents(
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
 		__func__, i);
 	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 829739e249b6..ce690abe5dce 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -117,7 +117,7 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
+		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
 			(unsigned long long) ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7ed2ecb51bca..4a8b77d425df 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
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
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 794a54cbd0de..373f64a492a4 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
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
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 64b9bf334806..b8095634eeb3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3496,8 +3496,8 @@ xfs_iflush(
 	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
 				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: detected corrupt incore inode %Lu, "
-			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
+			"%s: detected corrupt incore inode %llu, "
+			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
 			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
 			ip->i_nblocks, ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3153db29de40..6b4a7f197308 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2182,7 +2182,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->broot_size = ip->i_df.if_broot_bytes;
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
 	),
-	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
+	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %llu, "
 		  "broot size %d, forkoff 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-- 
2.30.2

