Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77700C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbiAUFU7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:20:59 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60722 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234079AbiAUFUu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:50 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L03xs8018700;
        Fri, 21 Jan 2022 05:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xgpJtorF7E/B8/O/fMRUNfkjIaEOZCENh6qFIlx53yk=;
 b=t5TlGSvnaCpKR1ROHrZqUHvfOi9s4frLZ1l7S4+YmOZ3eYT/Oi38jSdo1KpcfP52L189
 KinmNBV9+6Pq3tHpYmtl87XKsNUGLiEPPwmfibz6NUV+iY1CtHO53PEIfC7nA79v9lcd
 NOgfeuxXY9DlxVMIm9XAPP3RC8F3G1jbgdLLarDdYu1v/7sL88C2N/sfrdqJuAQexRTD
 1VikK+3wSprNBzGzkN1jzSw4Zsc2tP6umCS8GMm+Z7YqJnSQuIg+MJFZPhrhl0zzUDM/
 Frzh0D954qE41wvvOGXv67O4AABgymI+RUl6+OXLex7KnXos52RQXVMsJWXjOUuOXjcX Rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhyb8cnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KA7u170253;
        Fri, 21 Jan 2022 05:20:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 3dqj0maw2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oa9oq4sTjr6ejoTH2ffCmomPCtcHlPnXRDkueX3tn5n+HFhjI/CUULyuCxa+PgYskTXvxl4HBlnTeeMsmSNL27+4gfgN9RFYD4yrUpHu+7pv2O2pUaGsrbFPq/wP4YJ1WE6nDLndOBB8QD4fVMP8TUCDwx/w0PRy+yaQJOGAu0xVtHr7opITJqW2e0ICBh+aTfcMcbsJd20ovIltpY7o+8cqkFOThOJnk5v5tOm/9gTwCsqwaQ7tc56QsQgzQ4i4+68aJP/QSgB3lBPKscaV5XcBAOPR/DKC/HKUX9uhI004Q29QCWJA2cmPdnMJ20p/rYrBwN0xUtb+uGWP8r6K8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgpJtorF7E/B8/O/fMRUNfkjIaEOZCENh6qFIlx53yk=;
 b=ESLtRxL3k/kyZCz/Ul5onnfTi4AMjYPsJD5D1v8fcQnnT+RZHp9LNmffWkVj1c5B3B7vHSUYmCOjjvedC1p1eZXmmtVXNiIHEEZCBh6Lq5ZPbch0JwEIiRjkzEgCIwQvQFqqoA0cw9WKhu3kW1b1DxiZs6vmME2gcZyyuQZ1Pjcw1+Rt3h4cItsq1WEtdvWTeJW9LUhtjiQWk+aJAGG523+9qyT1MQ1CP1mroBJf/RE4XTsiFHW3YG2f3LKOIPBE+BZ7p3JsMkB9E48F5fKDfBR0L2UbUJxY4Hs5Nx4kCMUQB5LxBMuk4HTq6kgl4ZEG9T65rnxyCsL12WuhQrQmIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgpJtorF7E/B8/O/fMRUNfkjIaEOZCENh6qFIlx53yk=;
 b=qcMkDb6DjXszXQ/yBbdB1J33Dozurzc7yZ2zInT31dCeSgA3h3ai8QjoUyktrsV8LLuW5xPssyhUViwyJB/Ws1aBfZZvn5oGiKqYjfUpwa+Qnvp5BMlxATwIwg86KxZDEvvRg7zY3jiQNPEHXHcdUOx+griPMJbfz+O2SjCa1QQ=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:20:44 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:44 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 03/20] xfsprogs: Introduce xfs_iext_max_nextents() helper
Date:   Fri, 21 Jan 2022 10:50:02 +0530
Message-Id: <20220121052019.224605-4-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1eb99a65-c23d-4ad4-2938-08d9dc9dc640
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB128729546987F3A976697DA8F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m5ebnqkuhqUBqR3XRCAZHWFjgyjheW3BbYUyMxDuQ/tC1RmdvBPsCdniD9DpROSZYmf+bNwJnefIBwpd/Xxiy0BrDLDKdXedayQFHwz1chOrw9JlfnoXDON/7kXg1FCPbcHxeOVfvlcZ91kqsYdN7IA0jn6iJsHVrubE8z3v4Lfa/7lkvSbPSp7hl6J+Wby8dvFs4LhMKyLtp6bJ3YCpG6la27fop+WqcxlTIPmzwb3TXFnA4i2Ogq5FGXw1t2f1LTZjpOxtbb8YiB3KvBOfUtXvAQ2gVnwK7uj9BLqLt7+nM+08V5tkvvv5BlDd6LrF0HUp7jdNvNr3FDP02LDY79hXBR+V+R6etGnfn0/ZwVl/8E96uJfjSlg9TdOHYITyleDuZFss9JEfLmzA7DwAWUEs8xl1OS9ToXIxqHjzmu7Uj/bmBrno0l8P1kftC/b/gu7txzzQO8NtiJuAWsm0S4Wp8gJhfSAARDrqQNNnJ0ySTxOUxP9khIsKqgTHG8GR8VC+M0+mxDYz/S3k2g5dOxeXGI2NRcGeCOheYf+Q4t+lCgxN42VYlPwhcXRxsoDQOMU+uJNlcxT/UUGYDICKxa6mr1zgDp3L4fuXHx5DdKSowIrfW57Wp6FKcBz6f/vRvW/jV+0u/1QwI3tHXhuUQbpbi2mzgWnOJkCnAs1JBYQgnXOfUNSPWnP/30VnI9Rmm71xF45i4TJ2gi2jWzZX5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kbuVd+AUhjQaPWFP56iCgC2MLI2fuGszwFu1VU6642+m8ozzXgKOpApkpQUA?=
 =?us-ascii?Q?3sRU4Yw5L3o5J360mUDb8bDWhkotp8mgojXdnTBEZxoCI8GXvVVcUNpcCqlm?=
 =?us-ascii?Q?ReNM5LmqrD5dLTx2Sz+TSVsXaMSVK1g3lWSihc1baRVJxffdgqJ2wJwUdnSW?=
 =?us-ascii?Q?xyJANGe1VtzMda/KH+3W3lkpjYKkyumqcicQ3WBI6rBulXXu0WflxyXXphrF?=
 =?us-ascii?Q?ldkO8Doxkq+QgS+Jv3I/c4DN9MBfqXfYCQMIY8ODrg9XlMBJoB9NnUKPsP/O?=
 =?us-ascii?Q?Cz36pOrK3YE0VgVevvMDwexiTeOKapzAml0asunZTuLm0q1ryrtdIjumyaxE?=
 =?us-ascii?Q?bhUAAN5usRCa0krn9zO2qGKi0WcLDm1jG8qtdRAjFk8+3WX+l0SEvpf38eOO?=
 =?us-ascii?Q?MB8GIHP1mTL7k0gO3D1Ntenb3XcoycaFp8aUS+m1FbPjS2/6+osg9SEbZ4ZZ?=
 =?us-ascii?Q?lho4muu5fy4h7LwyQeIFbBmPa6cMSKbsEt8CQHlcU6+CrTvvfa1nxIfVWZa4?=
 =?us-ascii?Q?p5pkQmKiC8ijL8b46Rj840GT6sDOhnB/Zj/guOw21pvWj8C43plrYBsP8sVE?=
 =?us-ascii?Q?yp4sHnm+BIZDajBqyTyj45x3P+GkqLR4GdHb4PFQ9u8y9k0Yh2JVZZbm1GR7?=
 =?us-ascii?Q?ZN8vKnkv64NpaKDmdWBqveHqUHXPaRqlMGKoQ/YVoqrdmgA0cqKlo6z34x7O?=
 =?us-ascii?Q?ZlxgouebnfFcovEvGOeDHzZXfrXNadSlHNlvzh6UJxtHjF52aKlCaJYMUGDs?=
 =?us-ascii?Q?u3YBc+EcB2xUYsvMKJpzXCVgTEO4lgAjccd9lVmG/kREBYhW9rR0nyPF/6pJ?=
 =?us-ascii?Q?XuX7qGeGfFseTNvnA/4dxPE93oNAha2ZVCzpVn2tL0nq3GfVYzjhJOvyRtJh?=
 =?us-ascii?Q?kTwnzRbjOdJapId+o1YEz/Dp25wsCGt5RrGxqx0Z8Pp6PVL/zkYLigFZ90P7?=
 =?us-ascii?Q?9KWqZkeHDH8z8E/IXmu5R5U7ImrAq8oNTyZWGYTpWN1e/9bsLQHvlmn/P+4t?=
 =?us-ascii?Q?txfT3Mo4Hh+Gz9BySrgHeGULJU6730gzm70e5+HZlr9ZruvqruT+EVQ9Coxg?=
 =?us-ascii?Q?5UVkkZF5lb+79m3hwYi9ShZvcOK1ThR5QIA5cZ+VfM+S9a7TM4zJVOEFhiAr?=
 =?us-ascii?Q?8wLdAxH0fthXZLHlyPxLaRqxhsAjVfK0Y+1MFK2rgr6TVWnJTmzR+XdhLLT1?=
 =?us-ascii?Q?15H1Oh2r+q2lRY0VFjr/nPVC6o24hFLg0B8snnSngHjGGeeZQtk6yxIdm6ZC?=
 =?us-ascii?Q?u7/5y+hodokS/XuIC+SAWMZDrV7X+13sC6ByFuMO/NmG+oNSGDxf8E3SG84S?=
 =?us-ascii?Q?oMwzTxlp5FAMTJyNPaCD2DT/M76LTdngGi8JdrqdKFuSTxWdHsVBdxxDT9r4?=
 =?us-ascii?Q?qrnwBjy/R5IoWddNe4HQZa3zoopvP8QcB1Ef7qzUYAwuD7oM7xrc45vgPDMe?=
 =?us-ascii?Q?OGfroJHZmjc4trP3powpWSnwGIz288Xp/BPGB4tIuK2DYlC568R8BZq8jOB6?=
 =?us-ascii?Q?rDtwy/DuiEj2VlPCMC3HRafClpxcmCqlEwZNg+qorrXUaB3TovIl/FyS3716?=
 =?us-ascii?Q?ux1Hl3Pt9n8EDqheMVZ8HFUdtPVXEDr6kaEo/eMLB9g7Oo5rPJ6tZs1IJyCW?=
 =?us-ascii?Q?LMdioP9gHd4VLIYSkerpozY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb99a65-c23d-4ad4-2938-08d9dc9dc640
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:44.6374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O9utAOuqPBxBTLRPGIuNGoUq9geOU5+k4h76k1FLgHFhA93IvA4ezwFj/ThUfedScjk2tSz/3VNCFyeeu99WPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: QZ_N15UiW9pfBwlx_MpU8ppSvS-umy7S
X-Proofpoint-GUID: QZ_N15UiW9pfBwlx_MpU8ppSvS-umy7S
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iext_max_nextents() returns the maximum number of extents possible for one
of data, cow or attribute fork. This helper will be extended further in a
future commit when maximum extent counts associated with data/attribute forks
are increased.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c       | 9 ++++-----
 libxfs/xfs_inode_buf.c  | 8 +++-----
 libxfs/xfs_inode_fork.c | 2 +-
 libxfs/xfs_inode_fork.h | 8 ++++++++
 repair/dinode.c         | 4 ++--
 5 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8906265a..d6c672d2 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -67,13 +67,12 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	if (whichfork == XFS_DATA_FORK) {
-		maxleafents = MAXEXTNUM;
+	maxleafents = xfs_iext_max_nextents(whichfork);
+	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
-	} else {
-		maxleafents = MAXAEXTNUM;
+	else
 		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	}
+
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index e22e49a4..855f1b3d 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -334,6 +334,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -355,12 +356,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (whichfork == XFS_ATTR_FORK) {
-			if (di_nextents > MAXAEXTNUM)
-				return __this_address;
-		} else if (di_nextents > MAXEXTNUM) {
+		max_extents = xfs_iext_max_nextents(whichfork);
+		if (di_nextents > max_extents)
 			return __this_address;
-		}
 		break;
 	default:
 		return __this_address;
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index d6ac13ee..625d8173 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -742,7 +742,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+	max_exts = xfs_iext_max_nextents(whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 3d64a3ac..2605f7ff 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -133,6 +133,14 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
+static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+{
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
+		return MAXEXTNUM;
+
+	return MAXAEXTNUM;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/repair/dinode.c b/repair/dinode.c
index 909fea8e..1c5e71ec 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1796,7 +1796,7 @@ _("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (nextents > MAXEXTNUM)  {
+	if (nextents > xfs_iext_max_nextents(XFS_DATA_FORK)) {
 		do_warn(
 _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
@@ -1819,7 +1819,7 @@ _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (anextents > MAXAEXTNUM)  {
+	if (anextents > xfs_iext_max_nextents(XFS_ATTR_FORK))  {
 		do_warn(
 _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
-- 
2.30.2

