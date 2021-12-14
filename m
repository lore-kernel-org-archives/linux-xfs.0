Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3221EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhLNItr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:49:47 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:34228 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNItr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:49:47 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7Av5n004564;
        Tue, 14 Dec 2021 08:49:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=uW5Tcv6KUj0LF9j+5A7cvELDYMBgM7IBvzj+0jyLk3w=;
 b=Gz3qwfzeZibivIavRvNAGrfdBpRuAagcTtPRA3y4wAQwUGbqSsA06WZ6KEL5hN0FkoRK
 oxQl2dR70+EtnwrCHLnVDun26nR/fwNCdvcEbt+cVA8lhgb9TY42bV5HssMsL4V9K++l
 1ixKcQDceopDH1d39lLfZW40V46eFPYKY2q+ogabmpxaQDMrjH9L5q+HhArE1XqqBB+2
 /KKM6s0GYx578OE4ZGsV6DiLx4jYWL6+RGBjxyVanCEfa5zLd3QcT8/kVD604Pr2Iwys
 Lqw+KyUKzZwBxTkyZnBmoNtEDxx5vsL7BSb0n8psymFHiH08ULQmLounE0iHzVSzGBlL 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3mru62e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8eSm3074163;
        Tue, 14 Dec 2021 08:49:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3cxmr9yjda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=md4HhFTa1GwBJtaiMaswFP9HRd/ZD21nnannlS0wpf8AwT9w8C3cBqdxwxCq5LGEzNv2KPGJkqqeRLuVNo0x/Bk47t3QXkYztz1ZKUK+QBnIdIFJAA0q/yhj6R1JoZpHpIPwzIY247dw70jGTJjN/qQ49q/DJuFmpB1FidrPPZvapAsZU0bf3+FWXmsFpv2YHriDMWXGgqiH9AxT1YkgRTtrKkSeMJc7KVYwhMbhGjWfCSvxYwOCNYUHdiVMtyzKhdrT+0t2tgZDLPHZuMSKKnPmn8B1H9Pp5y1tCaAqMpD77CjwiXyxCYwIpmOivL0qDRdjKauziJ6/dzhbUCCtew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uW5Tcv6KUj0LF9j+5A7cvELDYMBgM7IBvzj+0jyLk3w=;
 b=J15O0QyKpc4QSVebaXZcAmgfanxhDso0d/q5g4WQVaLI0r7xtLqPeuOyCOxgXBqgh1h/0+Z9oOdV+W8JPb12k9JwjE7gFxMIs4FdQLOnvXiKDhDdknqVF0hvyTJJMLNsQywLXUwq+xjW/+sOubSGe35RkMEu3WnkWXNSuSd0mRT1gU0DkmndvKugKaktTPkSvlxmG3WfvlsoZNyFyFimiOScwYRAaBSiRLv9wzcLVk1yADwoyy5rpFsTgm5p+E8hWp9OjuQaUmUKQYEDM7ngf1aNqPTD1PUZUkBqjMoAqevZ2a7v3vaJPqt3yjZA5ig4pwbjnoS6J2Pjp6i7uIdWzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uW5Tcv6KUj0LF9j+5A7cvELDYMBgM7IBvzj+0jyLk3w=;
 b=LWdKCGk5tb4387DlyoiUUzN7OpuzhcHa/x01MfH6UPJ57aV4UFv6GhH/1b4Ky7eG9edRyJFDPaB7l2fBunXVcZ+LZDWcPUcMc0jPK/WQjOzuM4o8C6Pb6wkZQ1aP/SAWHxiWyevdZPLOHmAxbnvVyHFXEebk6K8ykmbLH5l6OxA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:41 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 03/20] xfsprogs: Introduce xfs_iext_max_nextents() helper
Date:   Tue, 14 Dec 2021 14:17:54 +0530
Message-Id: <20211214084811.764481-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d68a2a7-d8bd-430d-a114-08d9bedeaadc
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656EB410883E62DEFA63EA1F6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qOSYKG1RPikt47L6TUtHRZGGpxbghMUkcirMcgXCHYuKxwRjBUKVX4TMaj5oFdzhvi730f4SJosmA2sUe+jzXRHpAYSsoTP9UN1gcCNLJ3fFb2sn8gxHWC3byiJlxFOTceef+GUBpNwUJNYpn1XHEKNcQvMb1dS2SqhjApq9cK10sTfM5SmBauvyLVC1gbWcq8Dnsz5bdsIMA7VKlpHkBhi+mEL25djrDZELsDKARj1JdM4pSZSyf9exdHGPCqVvZoRX6g89+43V5C2aI5pMJ982CzpYlOBQpt5DVZWb01ntGFTmG5NLVZtK3bF7fSufOEcPi0vqFI5rBlqhMhqa3j8wQ0TPpg6Txdd8WtHzFfJnvy6Ylg+56YwSnUhCwmiTf0BvbelCoz0VCc13e8F14KyL4Pv/nfZ9YCrcXBWW9dpqluOyE4cA5loLm8IHGdJzXZelftxMa5+F2GPIMfkGLtXFX5jnOEm0tvT4Jz0fzA7G79iXldV/5eIagKFovvphhSUgIYCuNW/Jc5UywbVd6eecNxJJkVUdkxhoPur6znC4ASunBUAMwfh6cvSFTmLyC5+9GBPaj6khm/4Glny8mbicmZh2WRiRkLlGD8MjoqH1qMVMbxMKJe34ot9x8DMnm0iVE4N7qKdmny2+AkRG6l05ww55zVfF26h5naucci5Kj2LKp3xaE66j4DiOn6TYKfH0WonSLhKxxcfoI9nvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EkWP6N5HSMGLji9BkOuO/eG2/Qw4JbyXW6yGjixkz8+WIU4hC+ZsyNNV14Qs?=
 =?us-ascii?Q?V/2FK5EAkD94picGLRgBMV4qZ5dWP2sfTbQ0Yk3fLFy8e/G8tuEfEm6qRD3u?=
 =?us-ascii?Q?3IMY1cgZpdufesI5wyKovVSzkj3Gr6BIgu5vY+X8b5ZJpf9PMA5vZnW5n1/2?=
 =?us-ascii?Q?lnT8aHDgvKcqx3ZI36MoHjrAhPij918xWij/63xz7D0Fsj6C+oUMXxpezSgQ?=
 =?us-ascii?Q?Ir5Bd6nGVLssAiWqUTcId/UbwAVnORe9LS6SYpVG+vcbDlYF0c5FnJhistpD?=
 =?us-ascii?Q?1062LGxbRJQEnOe6rqjd7uDesdRGTNiiPBrOHCGvWkLJrwbAsI/pu3mW8MpR?=
 =?us-ascii?Q?2wuMCICKTEedrkayXtpIevHZQrWQKdWGefsEvn/vv/jPCzNUaXd+Z3zHmMNj?=
 =?us-ascii?Q?nYXcdokYmx3xh1ERFrS0a569ynhmIcKvP0NRYdYlAdFItvgceD/hdHSC87ZE?=
 =?us-ascii?Q?NIDVwvBQo9kRixVZzxvpZrgKcJwJvXxs66OMeMcIYt1KqJ2DDt5A1+0Gtu7N?=
 =?us-ascii?Q?/jy+iuAsikcemd8grq68TbRFWsMC33YXDjul9r3Mh915hiRjFr+QsYkA9SgG?=
 =?us-ascii?Q?xIYCX5TPpwRmzMiGZTlFhrfgHKINpA8QWsAOjphz69SodhvWYeby2jszkIZI?=
 =?us-ascii?Q?sI6/MEawfLzh2Z3eftoHIm522O1u2txgpIDZ85CaJHGBG1iwNj6yeJzOSh0l?=
 =?us-ascii?Q?xYRtkLQwE+8uvRUI40FXRmOHZrYcVPtK1VK3lF3Tfi6fxVINN22GjQoXtOi4?=
 =?us-ascii?Q?F6oZ9aJ0Qyu5cvt6MHUbnemHFHHrY0xmKe9EwbGgnDPTLhlnwbf2t5POabyP?=
 =?us-ascii?Q?nAWsFEkIOiOznBMtEnIlePUC8iNZBAKePHcdFC/2ZEhlPthoOLryqqDWvc3X?=
 =?us-ascii?Q?z0WkZhj/RumsTF4tMtJz79VPT6JR8pArV/3aj6vMbbAmhjnaj1866paZJnV6?=
 =?us-ascii?Q?JtyT/EOcRUHcbRu8y5UQ12jmqjypfwuIHEa+apXKtWWmohoOaNxscQ9+mP1F?=
 =?us-ascii?Q?wugbaZVmOsO1XJ85/v8tDed51lpHFNHEojSRTxUtfIaxWjmIlCxVPCWPV9dz?=
 =?us-ascii?Q?qWrRNqqkRzhzhYjbRwiy6j1h07wV3V/9feYloeBzo/oez/pOmTI/2SW9+UDm?=
 =?us-ascii?Q?C3YrU7mkJZDo+OBjMTgMuW5eOM5KgaiR1Y7aPWADMmt1kwFy/Hd7HNTuuhf9?=
 =?us-ascii?Q?PSC1v7f6SVDW8xdS8o3ACC1gKcbA0nkQzpvMPqoRyIqb9o5jhj725JdxVlVL?=
 =?us-ascii?Q?qsvjS+0h69nie9nyUNCEzBYg+5o5yrpEQaXaJH7Qq1qusmWOGAV0f5ZTEF84?=
 =?us-ascii?Q?a1N2SDwZz8lmp2SudPhMDqK9Mq2qWuJJ1g+DhLkVKFT7l2BhAmJqu/pwSrIj?=
 =?us-ascii?Q?4p1TBF7u4zEw8RlQI96QCp97tuMFLsJ5ngAqDJXoEd/lMrmDZYpKc4VK78DG?=
 =?us-ascii?Q?m6HBTdu4Y2TL66QnNo8JPEvo8O6tuIoFXdhfvqqoJV+RLOC1hCOCe41i8Qgs?=
 =?us-ascii?Q?VKSLe/vwQBxIMC+OMn0L2e4gMlVUT8d9HYqPv/B0OcEqAQQ1ZXb8U1SMFanQ?=
 =?us-ascii?Q?1VAypFe8J2RMotAWdaLQwDvnVJtxfFk6gBdO6vAoNpgPVTkNTHLVg7FB7pzu?=
 =?us-ascii?Q?+h3/RI5M6IPiQ0naGzVZ2YU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d68a2a7-d8bd-430d-a114-08d9bedeaadc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:41.1663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnHgpluTBnjK9sV/2ZMlouxytG8faCMd80sBbV3YmGW8s1ZTyXyZTdhOngCSMud3Hi6kT6i5FCbFRvptEnQYOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: 9vbPFrVOI1Q6MABDOnoe3GJqJuRkyCU6
X-Proofpoint-GUID: 9vbPFrVOI1Q6MABDOnoe3GJqJuRkyCU6
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
index 318d0c06..e7911a2a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -68,13 +68,12 @@ xfs_bmap_compute_maxlevels(
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
index f98f5c47..46dcfe77 100644
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
index 1a49c41f..9a7c2c91 100644
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
index a6f7897b..370246ee 100644
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
index f39ab2dc..962285d5 100644
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

