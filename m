Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FD3C43219
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiAUFTk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:40 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34882 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232204AbiAUFTh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:37 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04vTR017314;
        Fri, 21 Jan 2022 05:19:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=QMo1SCQBxZ86ZoXdkJlmuLxVGcV/RdAme/gxwC8qTOo=;
 b=pc7JaErXVHcJiXnBiWq2XXLvzkPx82/teZssCamZfXaT9IqXjsaiqNgRZwXwD9IAWyZN
 /FDF5eCFSJv+2IyN13EXdT/SpBUqy/oXD/o3eH8Zg0OiDWD8kVWUMUq+5uaKz7Tro2+b
 gdcS0PGGwT1jLdFY13lIkithenG7Rqly1wg20gfI4+EdRHGz0Vy8pYqnAgdnXgvFwQ/g
 mRsAdloWcRW+nj5uxQGxizXZxP6g1RKHny8R8+V8DOMrd8n6vE/bKWro1iDHuHY0U4tZ
 Av9Lh2XeqZ1apUB+f6dInrhrw1B8Fe80hHJ5Isc4t+dpgxVxOMxVIBbyMapYR9vFt4k1 tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhydrc6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5GUE1190235;
        Fri, 21 Jan 2022 05:19:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh01y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haqyKKjt2xgQL43Pj3zMzI/JC6mIoeH5yEna/CFGOYwxbp6Wz55MP+yNPoJCI+steKj7j3ofNwIr7F3HGLsN2rwbnUa554IPlZmVSKxpdh0nA8H0gXJ6Ez1GyaAqgPpee6c3jGONh92muCLxu5Q8s1IsxKqsE731/B8LePEFo50ZiNRBImQOQzz43bLAfIrCbSWlQTdrplMw75iHqllAMknLCiUOq05jEmDlU3fRnghFCAyUsAC7y/mqtxSpR1gyi3pc+V5Rr6GPLtK6r1/M577YJcbCmfuDiCUykQqVVEaSw3gFG1whhhRz+i37H/Q2ike8uoaD5aY1ufOTiKWW7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMo1SCQBxZ86ZoXdkJlmuLxVGcV/RdAme/gxwC8qTOo=;
 b=ei1Np2dMpZlHfoiAj7idyf/aoXzD7EWsM28gVtwlA4GGWq4nBs9CiZ/9pcBM6aO3q+VOsBnleFWG2xeK9uevDvDvNiZ/FGh1xYMpWkWwvjMoEAjTAe/T1FbRV9q3JrBTFIMvg7r2YlPlXR+wHyYN1bpmoR0xEBW5ZRO40yAB5UTQza4dirMVK6RWv3JYhTFPMg8f5ocj5qMRjNXgcPXI7gFeJMS9P13Lm/cklHmaK7pUCEHL5gF/S7DEGp2QXW048D0kETnSPKWYDcsqFFNhIgL8WifW7RAkHCK2lqOUuREr0G//J2QsThoeNP6FZ8ZwGRSNeYdAoJ5uMt+oA7w1yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMo1SCQBxZ86ZoXdkJlmuLxVGcV/RdAme/gxwC8qTOo=;
 b=L4H9OYdDSe/xT4TwyI/nuExFkMv2lBiJO5Lq+MCBF8pz4mQx4h5N8wxmLjpylnPKLkivIYiuyKdby0JTNpi0JfoU6BL9+OJLJeFQt4ZE6PQNKwlPZKvwyI5EPURAe1jnTclcbjr9F33XJgc0uD1iuMOzRmNMvvnP7sScTtZbA0Y=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Fri, 21 Jan
 2022 05:19:30 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 02/16] xfs: Introduce xfs_iext_max_nextents() helper
Date:   Fri, 21 Jan 2022 10:48:43 +0530
Message-Id: <20220121051857.221105-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121051857.221105-1-chandan.babu@oracle.com>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 296b17a8-660a-4751-a493-08d9dc9d9a2d
X-MS-TrafficTypeDiagnostic: BN6PR10MB1236:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12366A0E8017925A4CAD905FF65B9@BN6PR10MB1236.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2nBLhRduwmlPKQDykdMu19qkHADyLFf36IcfGNZCHgRkN7FYP6Sa/VbGMF9KNuN3i1szxnggYdZl4J9oIFiavFZ5uJLmWiQU012yFpLWeT7P7jOYc/9IJNoF4ujGYRkkjf5jVrFPYu0hl68MYdamhnMMZJpw6AEqWOJYkiIFx8yzwUV0+3fBorG2y01UCGjgT/J8ATkZvpoi9oVYioP9wfxbUZX/4BlG6Lvej8KxIL8lkG+PedXCE2VcoRDA+kRuBc2AnJGPYEB+RIb6BNZWAfkzOrLkRIt8XtNiqgMT18lHK9DBbQg39CO2Hw3Hy2OPCqNHLIaNzfzNmHADsrcAt+2K8QhF/bwgbUx6Q1yh6s+q+M0bPFuFYJUlnPV3zvluAgcsiEnR+HYWDAU3Gcm02XymEJs/GAZOWrYUGk6FXxLADTqkzCjCUaz2Qo4fW400quxq1GSCDFNr5RL7/OodM2fyyBk0B7TVBdUddLuFndOpxQyf4be0t3YrML3Dhk7p2czAgwaeS+j6+uKZODGXdDriV4YpCzlUNPMCHt4tczRI5mPLiUswz+GSBGNEtvPDyiGmVaYXK5YaYZU237VCqMtK45atfGQT43GyPU7KUI7H2+kTXlEeaI9JPj2K5qb0SHElL7x7meyE1STgy123828HsB6Za8naX9KIS04n4sfMXOID6Yb1lpxtu+jDR+1PF0lPsAUUravvRcZlVu17xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(2616005)(6506007)(186003)(508600001)(36756003)(26005)(83380400001)(6486002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(2906002)(66946007)(66556008)(66476007)(8936002)(316002)(6512007)(1076003)(4326008)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vZ5fi6ROFhWdBEOUi8Y6BO9NcT5TiupJlNs/lJGBtF7LDqzsnnJTObyiyuCp?=
 =?us-ascii?Q?3GJJpOlqB5EwpKdAX42QPKAEUhCl6A+1UlO7wraWYq5dOEKrR+Hvj4k637oT?=
 =?us-ascii?Q?VLWupXsCwVhcuPpeK9RQDfo6RzgEeGh1KPUBcOXSERNAJYyjJUfYa2TeFWoZ?=
 =?us-ascii?Q?YqpJEzschuvEoNHzfOSLJmvw0pfPEkEVMSZb8WyGSyDwClipdeefTLxL9Rwz?=
 =?us-ascii?Q?4GEEmQdq+dR917R9YgaSqN8trIJx7gCrnM8hd6hv4EWbGIyYXrh9H+uCBPrC?=
 =?us-ascii?Q?njvxHhRJbAElSVD9l0iLUSruc/cnjaZT3YhMM7YQ0grdXlwR0ZKjNzFIo7nP?=
 =?us-ascii?Q?xcOLIo3njZt/ZZ3aH+secSKSJ+Ceyki1zZmJh71yuEyYjMuR4RzEv6akmASh?=
 =?us-ascii?Q?kanl0Y9e/VePGNCsvrYY6y1oH8ojc9xUwxZBtuR252IIkU58i+ufESqJym5a?=
 =?us-ascii?Q?ZtA5aEGJFfEI1vXd8KAncNsZJtj7foWZ4yTAYPMd+eYJCePdx9iOIVftUZdn?=
 =?us-ascii?Q?IlVQ2XqyWnL4TdEjXPgUx4xtYnsr4SunAS3ZDhZ97XW7YEiWikNDZmlpqM3E?=
 =?us-ascii?Q?Qy1JnCYYtrrJSYQxn/4dMr+k94xQSkMuRUvkfA//LIhcu7N81irv9kPzYMj1?=
 =?us-ascii?Q?9ZxnCJq9vdxFa+HYrOEK4PMybns1fKzbw87c712XNCeaWKsG+c2SXITg27Ho?=
 =?us-ascii?Q?uKkWQPNvliINz6WyCXSZSZgsk8X1ft/+HILsOFG2S4np8u2hWU7n09dv16AX?=
 =?us-ascii?Q?DGo0DxBb8qrw9NCZjviDDjCKgc4FtlCAaw8bXwnz7oc7EPW9RgE8Bchxprrf?=
 =?us-ascii?Q?SkOU0y+U0WMHenNJTG2OmYM9vXIoD+4+8OtqeJ6mcbccKoaiy9X8v91A6sYD?=
 =?us-ascii?Q?CTchu+OWSYumC9sT9eb0IdTmwyWeWDc706muHxALdhaHehYanUsZmJVuXyd6?=
 =?us-ascii?Q?BQ9QcOsENt77ILKyQzKs9+jbwEQRsuL5eRmFf+IjwhCopv2QLkfRRp1I0nfW?=
 =?us-ascii?Q?WtJsC3eySrGxGsHxa+4adEy5nH4fFEMZ7LzWXYanlja/1XZ2x0VQJHUzYFwb?=
 =?us-ascii?Q?UGGJDUsdPWTn2ijqEvlzb2CqG3EwJ+sWnfMdtP4cd21q8MbN5jOebKqNZl3m?=
 =?us-ascii?Q?CAwsSJ/IJ1aY9CFfczON6hDHYktISgTR8xu3URGUeESoddjr+N2FALanLLue?=
 =?us-ascii?Q?6MDR2VY83tp9YtNtAGYKUX/0Ec6coN0320OtSvvGhUOzOQQsjIAQhKwzxuwK?=
 =?us-ascii?Q?BnwzLi+lHoSDMJ+qkuiSUl+pURuCNnEGjOlciCrnry31D0ndRxFBmTLltX/M?=
 =?us-ascii?Q?htajjzNxLQntaaMgC9Kvgp/9GyS7AfKlxRv90Rg8MU2oN/eH79JKcHsKboZM?=
 =?us-ascii?Q?uhEUNVRZ79k904p1zZZObJlkmmkYTMCt+n3/IYwVgeKPg6URn3qjNoSzVVxZ?=
 =?us-ascii?Q?x64Rm7O/Tm15m68Hwr5igAq1X4y9kVgaCWs0q9Gz2O+H/2321kJDA51oUHiY?=
 =?us-ascii?Q?llHw9r3jKSloQiJ6XC1o/rfmDeH7DQ8Dgu8Sq7b3axkMxzY8OnFdD3FuePab?=
 =?us-ascii?Q?MEQFnUQAeBGwiBMlN4VH5n8uG9kZIhLBbWT5NeANiDOSgA4T+tMFqJr00PMd?=
 =?us-ascii?Q?R2fHhjPeaBg9L1iJ8fl4G5s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 296b17a8-660a-4751-a493-08d9dc9d9a2d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:30.6950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EDifFVhDhCiF6j1JMuxDPwVuUOrQXPIEYu+OGyko67vzQFSK4jllnwP3Lt9sY0Di/BNO0gO6PLXht6XPTJiB6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1236
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210037
X-Proofpoint-GUID: KJwDqnxrZvPmU6i77n43shiG4zOfXvMi
X-Proofpoint-ORIG-GUID: KJwDqnxrZvPmU6i77n43shiG4zOfXvMi
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iext_max_nextents() returns the maximum number of extents possible for one
of data, cow or attribute fork. This helper will be extended further in a
future commit when maximum extent counts associated with data/attribute forks
are increased.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 9 ++++-----
 fs/xfs/libxfs/xfs_inode_buf.c  | 8 +++-----
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 8 ++++++++
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4dccd4d90622..75e8e8a97568 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -74,13 +74,12 @@ xfs_bmap_compute_maxlevels(
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
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index cae9708c8587..e6f9bdc4558f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -337,6 +337,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -358,12 +359,9 @@ xfs_dinode_verify_fork(
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 9149f4f796fc..e136c29a0ec1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -744,7 +744,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+	max_exts = xfs_iext_max_nextents(whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 3d64a3acb0ed..2605f7ff8fc1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
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
-- 
2.30.2

