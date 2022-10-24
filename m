Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB4FC38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 05:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJXFI5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 01:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiJXFIy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 01:08:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBE0696DC
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 22:08:44 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29NMxxdw018071;
        Mon, 24 Oct 2022 05:08:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=67SclDSyOl53qlb5HAuzZ1Dg4JH781pQgWDDkgbscSs=;
 b=bAuJoqtyxUJiRoFVF7FMDiYIRLrRA8x+2ms86lRfRERNckrs4MJSe6UT8ZL7WnFUaKyD
 GK4lF9Dmh9pUQn7RxNKXyPKGOzdAnR2wr+2k+cVNfAnDEdwKcYRMeMtfybk/Q8teIeH4
 OMuFzDaKywmR+yQ8u68P8WCK3BLH2EeJHzA64kKdc4t562qfOmxmzWvin9Ci6GK4mDCZ
 4BTtNkMMBdNnuuGfXHgHVhMGotEYj/oCUV9Eqlb7R7Ya/6ewu9Y2Vm32r6zKARqTY9Wa
 oBpltjKZ6BK9mqdH3XKjqSoZDApqnrZQJOZHo0+aMUZhcvdUYx3S/XNHuupH9Y8qGcLN gQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741jwmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 05:08:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O02FXi003884;
        Mon, 24 Oct 2022 04:56:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y9bpnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:56:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpDPXDJTYJtP924p61rdVEJdgC9ogiBX3Qc2ptnP0lN1qvFtKW/3Lrovxp1LnfmBTvxudLoQHJbw/dAT2be7QjQiwREjMY2T0qn14KacZfJMgVsNSeq0YWCpL1nE8H2ztcGFAenUfDMbxeU0fUoGCqRxiVWr1sThcQaSDxcGlmhC8GiQBOxfrJxOhpMHzTW9pLJB6BjdvuUZy0jfsDfKW5XHqN6NqkLV+139gp6EoWP8NxLdnwq5VHnd05Ed+zf/cDlumjRXqmmthu0J4PXY7yZRV3yXCHh9+6K+PBHDV9gbLG/f09M9siJiEmKt5SmhWvwIdcpZjQ+NgtEJ4/MEOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67SclDSyOl53qlb5HAuzZ1Dg4JH781pQgWDDkgbscSs=;
 b=BWpV0QlJpNX568gq72IKMwJvjMgZ0iP8wqlg5Q/l3ofNutwAeqluH/qRLM+j9FMGYZ51Bt+5XJgfPbVwjrGol1lf+Aik1mmq09+QfYqIVFqGjNHWQvyw5A/nH94p5bfmZ0AMRughfNvGyur3dcFHHNH+i2zeJQNoB6aewzCjOUx2pUW1DdSOBYiIvVBA1gj6ltPWA6/L0aXvkL6HAMGGzaR6bl7y9fomu16SBDEksLhlLlqH1i1xgAchDxTDV+GXcXGWrjEXmjOX3E2gKDqVX5szmbbyzYnrC9wuTU0cuev3AM857bSMLCkbEH7I8b/WaAhYF++h9Qy9HK0nkSt0Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67SclDSyOl53qlb5HAuzZ1Dg4JH781pQgWDDkgbscSs=;
 b=PiJBJ8yY6fqTp5DurtI+1JgrRZZVKJa2kIyqtjimGDx3OZUgT+SFFE6GNp91roMHqRuXehKs5ZWojoBP3PgcTkQBpmYbJ67lYfAw7BEYjnz5QSfqB1KzBB1q4wD4vZUT8evUjovnp8ALf5hTrxx6fKzo3R3u7nvOXImiAJT18ME=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4906.namprd10.prod.outlook.com (2603:10b6:610:c6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:56:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:56:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 23/26] xfs: factor out a new xfs_log_force_inode helper
Date:   Mon, 24 Oct 2022 10:23:11 +0530
Message-Id: <20221024045314.110453-24-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: 36e76c59-b94d-484e-8b07-08dab57c1268
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PasjRfMhJEqPp4luD6OuWA+IVIq0PRxYDQvaYMzA54j2ZOtv4MbGnkbpwqJJQpW/5nL1f+hhfN7UwYrTn+6daupPIquTE//dRijIQt4r/OQ7jm6pf2+5Mhmn3Jtr0L25gXkGzEbB6bHi2xQKPeI98baeN4/p6pdhZjb+1/DJDdsBEktMxvpykHngunSKBuAeBXU1kSegcweo2w1MO4JpKB0x2AjAxlFOg42kq2fUpwBui/cx9vprlZ0axYm+j7Devz8UxFz+XaPUyus3SprEKM4PbgLiMY4Mz7qXKr+4LsWluR+9W3q11QMmznzpTi9Bzf2nXKNT38+duTniCEvfzQWwEIOJpuKc+FKp8gsTK2JfXC1B975XxUXjdHCGjOcR8DI+ByB/RFPpM1rsQiRabpYtKhab+ifqytRe53m1Y42jpsJTb8tohbJ4443mkPDDiLJ6Oshd0OmlXWjRYfLtbFQigfzP7yk1m2P5n1KPzPtuOR3jjXUazM1Aa8rc64/MT2QVn4AXHufO3CtFfYVuL+LBA+IIIWJmCbe+sonlDNo9uAda+YeUD0Z0c6mCND7OXYVctDO3Jb1YEgfas80Q8uUBOxthRos1ohCPepQgpGSnIXDd3hYFIKyEn7eICqPLhxCNZzCldrFKQ7jpYIg7w8KGFbdpabtDJGWZqeMcgDv9DwL6p3xuPyj7L1zfnP6UfBjeyToEgH54PlbeHof2Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(2616005)(1076003)(66556008)(66946007)(66476007)(5660300002)(6506007)(186003)(83380400001)(36756003)(6486002)(4326008)(478600001)(8676002)(38100700002)(86362001)(41300700001)(8936002)(6916009)(2906002)(26005)(6512007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SZU4ki5eFJEsbpJRA3nyZdA2sLhg0ff9bIwuAV9mwyDsQdQTVeEzvGThzlGt?=
 =?us-ascii?Q?9GRisv+ELRlKXh6t9pL5e6jplBnBODNFZQACZ/di3VJCsAAAEb1fPehlVZik?=
 =?us-ascii?Q?tQajpxOl2TxV2UkvMz0wZO3arILM797QZeIDAq7phcjUo+3EkHtKTMQ3+bz7?=
 =?us-ascii?Q?I02bdehbMqwHTpCQpEOWJW5s8NnIcJ9n1WOFQnwb+nOHHxEBQi2Ek/JMOiri?=
 =?us-ascii?Q?sqro8gwzMifl9tU3WzBFReEnKe9jY0iRiaXD4iXo3k3zIrrXoYZBHokE6dla?=
 =?us-ascii?Q?VmZoJbjEKm1mbg+WTUGUS+o3dvqq8uenq9XDvF60QvJLlxol71xIfrdJy9Yg?=
 =?us-ascii?Q?D0M3e9EzoxdYy6AQLXqA+dNtyBGT4BiAbaUhNPPGVVbxUzQqyGBVILMYhHGR?=
 =?us-ascii?Q?nULGy5ZZ55zc35QN+bLDfgXYuF3SUCM+dpu7t4ETqEFPPWBqQ9CfWti6CuLo?=
 =?us-ascii?Q?RgJiRw+npSTfhf1bH7aWdOqR2NrqeVbPo6KThnz5CrWpIQAp1jaBCJW8t5w+?=
 =?us-ascii?Q?VdRC7ujUajSTBV4At+MkM8dQfCTxApsRBJzLHLA9N8WB9u4bWOnH/asVazvt?=
 =?us-ascii?Q?+TalzewzBqbKHdk2zcw/qBruryBLdcXW5p8UeCoEKIu5kBqlV6u8YsOWsSXq?=
 =?us-ascii?Q?oChe/F+FnwvebwT+dGtLITNAIx2k3VJM1n0uM5yDqSjBZwySwz0zpKUxxtOX?=
 =?us-ascii?Q?yvIcM1tZ9UdAZmhEdtAPStwEU8Mb7XDIkEwf5uAlkjoGFGLwhT9jebpQGOte?=
 =?us-ascii?Q?lfsKKBtt/tB10Gm6u00aDo1O1eE5xawz43SbYHr8lIDNqtSmyQGAUPpejaCr?=
 =?us-ascii?Q?pVH2hPbao/Y7GapC6tqLMoZkBrwR2wLmNSZNgLXtRnxhRASTztkOqGKBSqJ9?=
 =?us-ascii?Q?yzFqyg95I3KwfjJ/WprtPYziUdfX0CYyEltgLxCd3FseVQgYL9bpH4oapEqJ?=
 =?us-ascii?Q?2ZENo9sbaDNiH1A0BqObvcQ7RlWJKmsSahVeDv5dlJh55ZJHEcR7K2sdzZP2?=
 =?us-ascii?Q?3LFqsiXcZrWzSQ9OQcOVQcivlVBtd2Hcet3wvRfwpDXkrTF6GVgSTsLLThjU?=
 =?us-ascii?Q?uxQ/Z0sqgyq3kvD7Uw7Kluo8LWEzA5nd35qO6i8nI3bS8M1hRE+ime3QBLXa?=
 =?us-ascii?Q?uE1W++OUfPU3MHrZoQdbJbWqvIIFPvsX8I3ttwZ5Br1KFX1hIsLOuN4AKMW7?=
 =?us-ascii?Q?tN9kGkf6zentTFGG9UVVW4P6BaL1AKILydTq8ZEaLZ0uASkJIz7idA9Pm+oP?=
 =?us-ascii?Q?4ZZZINmvVirt4pFTa1pF1U7T8bVbthvaRB0CqOFhBs4iONVSHfTHv8ODLr0Y?=
 =?us-ascii?Q?563kXVRxx30oC5R5aKbwYG/3yHzFK9f3/End4YpPBELuo4+0uIAflXbQusxZ?=
 =?us-ascii?Q?PUP++3fXJUwgX/M+yd+0zuNxoxXbJQva+jZ6mqFnhUp9/ryCP8JXx907UetJ?=
 =?us-ascii?Q?ROxjGr1tE67tDQongVJiKpgqtzQDmoPQhTbyB6d3OXgTXLZ31dYb6QGNfJXB?=
 =?us-ascii?Q?chQAzJJoeFSntizZBmS3ZLOH6lBpPovcVLlBZ9A8A8Pd36U71kILxPKzl5bp?=
 =?us-ascii?Q?3Vs9kG8QKyusUHqq2N3mPmM4893Iuc3hKU9F/gNafw6r90ZIDhShTvXp76Hf?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e76c59-b94d-484e-8b07-08dab57c1268
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:56:11.7010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j61JwuQTCkYpz3pqNMGlyCagJhn1XzetzcOOibvaGT7TXW4lPdxSRC5JKmGHrgu4y4r+gfNGMbIW8AT59PnDPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: XpB8t3x0oonmvjf12nKFgzbCtnXcmPxL
X-Proofpoint-ORIG-GUID: XpB8t3x0oonmvjf12nKFgzbCtnXcmPxL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 54fbdd1035e3a4e4f4082c335b095426cdefd092 upstream.

Create a new helper to force the log up to the last LSN touching an
inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_export.c | 14 +-------------
 fs/xfs/xfs_file.c   | 12 +-----------
 fs/xfs/xfs_inode.c  | 19 +++++++++++++++++++
 fs/xfs/xfs_inode.h  |  1 +
 4 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index f1372f9046e3..5a4b0119143a 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -15,7 +15,6 @@
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_icache.h"
-#include "xfs_log.h"
 #include "xfs_pnfs.h"
 
 /*
@@ -221,18 +220,7 @@ STATIC int
 xfs_fs_nfs_commit_metadata(
 	struct inode		*inode)
 {
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_lsn_t		lsn = 0;
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip))
-		lsn = ip->i_itemp->ili_last_lsn;
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	if (!lsn)
-		return 0;
-	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_inode(XFS_I(inode));
 }
 
 const struct export_operations xfs_export_operations = {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e41c13ffa5a4..ec955b18ea50 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -80,19 +80,9 @@ xfs_dir_fsync(
 	int			datasync)
 {
 	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_lsn_t		lsn = 0;
 
 	trace_xfs_dir_fsync(ip);
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip))
-		lsn = ip->i_itemp->ili_last_lsn;
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	if (!lsn)
-		return 0;
-	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_inode(ip);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5f18c5c8c5b8..f8b5a37134f8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3973,3 +3973,22 @@ xfs_irele(
 	trace_xfs_irele(ip, _RET_IP_);
 	iput(VFS_I(ip));
 }
+
+/*
+ * Ensure all commited transactions touching the inode are written to the log.
+ */
+int
+xfs_log_force_inode(
+	struct xfs_inode	*ip)
+{
+	xfs_lsn_t		lsn = 0;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_ipincount(ip))
+		lsn = ip->i_itemp->ili_last_lsn;
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (!lsn)
+		return 0;
+	return xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC, NULL);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 558173f95a03..e493d491b7cc 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -441,6 +441,7 @@ int		xfs_itruncate_extents_flags(struct xfs_trans **,
 				struct xfs_inode *, int, xfs_fsize_t, int);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 
+int		xfs_log_force_inode(struct xfs_inode *ip);
 void		xfs_iunpin_wait(xfs_inode_t *);
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 
-- 
2.35.1

