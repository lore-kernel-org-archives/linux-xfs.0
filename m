Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1718C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbiCAKk5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbiCAKkz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:40:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12316E793
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:14 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2218UkhQ018833;
        Tue, 1 Mar 2022 10:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=C/wcOAprfm06ym0WC8Is8oCMFpGNiIJSVgv1SgxdZjE=;
 b=GDj0sS8qiJ9WX/tttPWougZ6NXTdWnfEWFoFBK+GkOjFcNkoDUxiD5Kv3ovdtmtnR1p+
 k0T9g2K7DmCxRJcYdNjVUCGNsj6KxE81td9z4iN7LDTolCNll19MtMlR6frNCpQsP5kC
 o8XMWly2mYsyQat/d3vAfPzv8biWSpEx7IHEjz6lSDomfzr8QtUg6HawRuJog93WiV5A
 iiXlg9sWtCvTb6hzReIBqkBD9DOCvrpL8gRvmjQZRTkkcjpCX0Ofc0vmvPsQ16yiSIzD
 Bn9jzJeQVMEfYhr14hO6TDFhq40qyCz+CfFkrygLI3uU22AXanU9VdDk9SkGbIAG68fy PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15ajak1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZMDX134266;
        Tue, 1 Mar 2022 10:40:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3020.oracle.com with ESMTP id 3efdnm9qtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7R7JLfghW/2N1Q9nFHKOakvrUI0Royxnhb1qzTxe/tGxjM+I9oO8AhnDUyqgbvUvBfcWQawM08sD+vgn+vpuMp4CYquccLXEKM1lsKhOMdr2kXnYHOWKPuaBBehztXnp8SfD0LZqHKffVeMbinzNYhk/8SS5vXmaMEZZ+sv/cpBzr4hTpxEbP2koITJkVHh9Foydc86Hiw5RrAJKUeXeBSONaT5tXDYjYQ+X3PmL/VF+6H8wGkx/o12DXeE1isDplYZW4RrdWs0+AJ3fFqnq7ms5mmmfg0why/Ol2W5/TnTlKLHrWr9hOmLRmHPqzGmikqT+SEKK3YPH1nAGzBVcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/wcOAprfm06ym0WC8Is8oCMFpGNiIJSVgv1SgxdZjE=;
 b=NK7o7MPSzuPUJkG2XeDKW+a6jmaBRUir/AKjb+FY9wKJqSrT2xw93xaqlCgR8+fCacqwlsJV48mCBCBiPB+FA+bfCC0qO7xyMSMGqHONvW4Q9E6edVh+QqtMBOYfR9m1lYHl7g/j6pSjdTLi12vShEuGNwX0FAzFjrZ96CRqHq1jy09yFURFauh/EGhlIV3C2HV0wAn3GcbUwJezGK48DfbKIfCvKFgJgzRlaQVmTQyhgWGYPsfk7tD6qOSaaNDqmUx9TKQtEAQYoIPlhOpWuir49Q4YbX85sMev0prCbZHtFyw612Eh4YYJh+Owp9WR0JCRFAr5DB+kSq+yA07bcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/wcOAprfm06ym0WC8Is8oCMFpGNiIJSVgv1SgxdZjE=;
 b=nMhNq7RQV5KSw2CDfZ53QYLuIHooABz0A5flyxNUk9Vz6r14Ab6scXQejlqiOWaw7Sl1d2xjktFmDH+pMcWShwZUFbcNSAgtpZdC1FezE5mYRAkE5LtK72J2PWpISUpvJDCmvU+lkif3zEN5C4J87BOl53yjOOFNc/DPn10uDNI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:05 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:05 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 03/17] xfs: Use xfs_extnum_t instead of basic data types
Date:   Tue,  1 Mar 2022 16:09:24 +0530
Message-Id: <20220301103938.1106808-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f954253-ea52-41ea-dca0-08d9fb6fd93a
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB416082DA5315901829D99CCEF6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VFXjtGKQVeoPmFjaWcZ3MOTgVKO9N5zQTm327ax0/5ofMJ/1uIKgWFWqT9iQ2+VxrBa/B3YCZCLwcNB//cu8B4berWOYqEKirgYHTaAB+94zY9vg40LDHZD0tBDMVvOnqUIOt2/WsWgDwK81KFFwnxVmA9H/+qgDw8qrnS4fvTWC8D0yJ6MTvWu76qF7ov6bYnpHpYX9i764/1uceYKfBGSkGVTATriKcY07m1lDV3K17Q/h6ZqTRl0SiT1OR5kY2FTlw7GamqopYVs9Qb898tLb1JEhuHoYBXaY/knHrcEbFsIrXwx8UZbRjXqNrhwPYY9PDqRsTCQnTMMj3q0miv8UkmFHZO52F/nisPbr7+pIWCdin9nH02w20lCahvdrWO7oFwq8SQmB3GMvAvnYnWL33bPQMtAMYbt7jHQWGn2Dg1rMyApYSpqRmF102soirfgfVvYmQAizBkUOuRv3BkCdALnivzMNLMFE7XgvTYRKE8E46Wxtoiz/rGYVE42F6xoQvi6stzMAdG5nwigRFKowp5afxuCMzcWd/jCTi00kVJhwshMGN8/bxdkQLWJEd6F+jKuiuNLHetH5TQ7Df/PLufUplZy6xHnICJDTEJsUa/qgY47vp1VqNswZKg1kouFB6EiBeajhdpaIwVo8Iudv0cx6pWFsPQ/R18R6l6LSqiBIjKGKFamdwCp+OC66v877nCQokyC47uTeJbxnfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VXCTUCDyUzysiUvJsAnhsBvCvyAXn/90PMK1uoJMCbzQxz37+mgSnYeb7ABZ?=
 =?us-ascii?Q?hrfnP/l7+G/f/JlsKrK/bF91dvxW7CzkrNhmzpOwppAqm13+lUs6rGO9S7cQ?=
 =?us-ascii?Q?QsP1lu0bpxmZfK8m2psF/jO/YbBYwcun+wd/J9DKbNeQnSYaqdMb3FXXkgoj?=
 =?us-ascii?Q?+beLUgumbWePpLQ6TNn6v0S2gwz58gUHiNiBhCn9D/OmMJBAjI4VRks+FpUX?=
 =?us-ascii?Q?bC/NOLblVJPo4wL/BsoV+PlfuPR1/qpwFfwj5fisAqcQZvCdD53YgNwh+nL3?=
 =?us-ascii?Q?gZTTX3pI9kmmyfg3O4hsasN/ZkSbd5QBR0hydio7RSgoBA87rYIQ71C34IeR?=
 =?us-ascii?Q?H+ejGVDw7/CTelTsZlo/JEgRw/BhM4r0ey3zjDm0R+2LzKPn2nqXcpuLTdJ+?=
 =?us-ascii?Q?+h4UoLNgyGdH0DGwAMpTjYBNhHM85H60VGSXPQY9YEvxZ97H5xnwsawwdVri?=
 =?us-ascii?Q?+7MvR4eVsC41DwEOMc36w/Q7J092chSkg5FT26v3URT9kLJxxsQ0e6ejg1o4?=
 =?us-ascii?Q?S5ybcKJGb99qUSA5bJ91P1MZ/mE5LzRvwR+ESIcAG/RvcWrveC4Xl8a4ts09?=
 =?us-ascii?Q?uOz0YC7dyiZ43HI4GNKSLfHEQa5sYC/2X9eEmX9f0iKPVvYb0r7I68y2WB+Z?=
 =?us-ascii?Q?0yJoIsP1ajgJcjGfszy64Wk/G3824spSC0gBL68L8hdtQP4CSOZfuGECuLHl?=
 =?us-ascii?Q?4fPrQUWzl8UprH9qjWMzep1w7rX1ScFJbnps4oZlUBne/WcieiUpQqbJGJiq?=
 =?us-ascii?Q?2gf0fH6CHvFBmq9gyJOpKubv/+CmbL7vLmiUlJbCMDEz9onS2Xx51IE4qmoX?=
 =?us-ascii?Q?fCnM+2Gv8PXl0Uwvh8R8d5D54hHb02kLa5wk5RJ5Hv9Pjj1Cymfvp0wMem6o?=
 =?us-ascii?Q?j9GDQnn95bJN691L/O0SbQz/umymiQ55AhN+nvzPcxiZZtaPNWdUQvHblbrw?=
 =?us-ascii?Q?CSLWogRQffvSp3FLc+BMcwsvWcY9duGITJhb80cocXmIz21sihED6a5ClTwv?=
 =?us-ascii?Q?/0nDfrD0d2/7DM/IMtJ7FlCK2qTK4FN57CL9Hh4utmo/2+19F+3HNEuHV3xc?=
 =?us-ascii?Q?Hcs/CuteuC2hGt7jlfngIjCcZAtQXwJJJBbGbQFcLsyCGPlqw4o8QDQwMH9j?=
 =?us-ascii?Q?ghL2k/CxZPAsfDq4JCAzM0TQwfMhED9hS8uytlHTLDvA7DVid0IozJQFYm6m?=
 =?us-ascii?Q?wnCpZNBVUwrgEIiDrCFHwzwSXFlycBxCuGah7JBhqdpTSX4KwE/c1QgwHCjN?=
 =?us-ascii?Q?8KLkjp/5wMlhO1jrAe8hMbJ7/SP5X0sQJuKxXYHGdzUwze04MNTd2DPpSL/o?=
 =?us-ascii?Q?6jtJ8Ha/A2j9LJ+m/mBVKUYmvmLq93rCJO1d5m7qsULCZTExq98xcGpDLntu?=
 =?us-ascii?Q?nBLHqnSrMJ7tLGieQ3BQ75+AJr2ekPQp/e7R4mO0SIOw/9MZXFYG23DkyLuy?=
 =?us-ascii?Q?l40c/rmGYRsdenH+rDg0Iby3u5a5r9DB2IyhURwVRsOh5qJvQGoZAY5ky2B1?=
 =?us-ascii?Q?RgExnI0mvF/f4O89zF2oVP2VulWi0BHPW6ZPb7V/WMpc2CPkzi00fbwgrvRo?=
 =?us-ascii?Q?GFrhHLjjsPuXGJbK2aKKmNVhrO2dCJv8jInckKU7rMUfpdUo7P3o0w4JSWRN?=
 =?us-ascii?Q?P5wLtc93m8QoIHGMgN+j1Ic=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f954253-ea52-41ea-dca0-08d9fb6fd93a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:05.7527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DDQ0P+1Cr4PYnOZp4r4OMIIuBAjn0bEyh3LSm06kNPJbIXEslN7hVVbfF0oURFXTb+gIYToPo6eHzDjkw5ucTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: D8alrRYX5RTGBI4_IdoF7GV6x8cdC4T2
X-Proofpoint-GUID: D8alrRYX5RTGBI4_IdoF7GV6x8cdC4T2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/scrub/inode.c           | 2 +-
 fs/xfs/xfs_trace.h             | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 703ab9a84530..98541be873d8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -54,7 +54,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e6f9bdc4558f..5c95a5428fc7 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -336,7 +336,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e136c29a0ec1..a17c4d87520a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index eac15af7b08c..87925761e174 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -232,7 +232,7 @@ xchk_dinode(
 	size_t			fork_recs;
 	unsigned long long	isize;
 	uint64_t		flags2;
-	uint32_t		nextents;
+	xfs_extnum_t		nextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a8076ef8cb4..3153db29de40 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2169,7 +2169,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__field(int, which)
 		__field(xfs_ino_t, ino)
 		__field(int, format)
-		__field(int, nex)
+		__field(xfs_extnum_t, nex)
 		__field(int, broot_size)
 		__field(int, fork_off)
 	),
-- 
2.30.2

