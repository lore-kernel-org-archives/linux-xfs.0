Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F8BC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbiCAKl2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiCAKl0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE7590CE6
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:45 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2219JMUm002254;
        Tue, 1 Mar 2022 10:40:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Dw4tkqyZbm6BLuh2GhjWbC2A1+FMAT1JJ3nnkKdhv9w=;
 b=gS0y52ARj0fuBMEc5Uim/x5YuHO35ctGRiXxuFBW7dS6kvOnH8Md3KEYloXQdF6cy66n
 6LbX6nnTS3Yh2aZ32FkgcSiR9x7++P4kslrD1tXaaBB5SAON2rCTb+P1FQzEnOjSliZM
 S3186P+JbwzDpYDVqXUzJYM14vpS9rH2Pq4hwk27c0eSsnco+xE9MaT0fwkcP3sreWhQ
 5ebfPdr5C9V8hAJJ+Cd+6fI+QVPwrCJKd7KQtmhLBb3lWXIW/S898JgU/P38T78HMRMt
 yhk3BPcEwQNyEwBohttDalW1aqabxL+auksIvCBxIl9LydQDgjiSeJYju/8Tdrg+U5Bn bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehdayrpmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZFNY042812;
        Tue, 1 Mar 2022 10:40:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 3efa8dp7bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ur1skMgDaKjLc76pvhfWv/QGCqpUGktKc6hzPCPzGwzJbVbC0882jfMHqy8Nzygmd2RORQrpPPM+oSEDI73rWFT9Lw5Af5Yqy8P6ncsjumudL1P+mXQ6qReSN0nuEbbWwokWMcmuJDs6852pAmeDkO+NiUCFNpfq/81Qd7NT6lGvSmh1FOs2tiNHwBtvcwJA5Vp0golTVDK5kC8JPdJ35eVfgNNosxlEikzylXTKzYSE3o6vTi2uHXSP3SO1LQWa47alMyUIS+vUW77IaxZOt4wigHOaKRj1susFOczHWFrCRxgcYvdkNQOMKDJaxccegackngXYBfsONsM0PkoZsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dw4tkqyZbm6BLuh2GhjWbC2A1+FMAT1JJ3nnkKdhv9w=;
 b=PBedouirY3d708x+J+8ogVD+qEg6nnyipQKGoUERwj9xfdZiv9qIKDbqL0WgKLjnelmBa6g/+3hvL28iZkzoSNZKc5PBxAEqmitPAncb4imh5dnI+2fuyCudfo4Olz8SP4D7r9HNnZ7eAUQOcH8PkBxPiKljg9fPNO5yukPcFnVG15Ih07/QHaVcixKEF0tguYdfsJ8ndRVBOym4+l9hObNh8YKLzYPWrC8BZJ/cHvXzwzewknppdomtfqdnJz/RSeFKJsBGsVs6bH94wPWuszvvOYhZPdAywsjchKKHual3OAlPx5iFMmXT1Mfs2WJh0jOSKIFNUY8RQ7rEZGzrzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dw4tkqyZbm6BLuh2GhjWbC2A1+FMAT1JJ3nnkKdhv9w=;
 b=hl4N7VXXzDhXmCOU8W9mCxLQJmnqJjK7vaVVguMo8oVMc/VLoHJy2yWrlzyEJLtimQtvEdxJbxAYoGoJfbjkNT67qNbYmlxByxN5Emu0hF4mCc9jtBtVObzLcbEnGXzcHt1A7nQzt2qObjTyDhFGzGOOWCRz61zV5qO0teiSUVU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:39 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:39 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 15/17] xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
Date:   Tue,  1 Mar 2022 16:09:36 +0530
Message-Id: <20220301103938.1106808-16-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: e2e0b912-981a-4f8d-6764-08d9fb6fed25
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4160C4C6A8B89283F08C8506F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pN5F41dELREff4MMXeChDOFdULCdD2LdKCeclSY18TOQNv+ASjYRrp5kDtabF2/LjZrtLTEiMEfdml11WBAHliqyd8nxKIOj1CXIUHw22RRdI1K34Bf7auxHczla6Y1VSMvyK2IRJxsZVWHhQqGQxWSnKuhHY7vCtL820JMx5fTKwIVzBuFOrQvIesFgvTmb77Xsyp6uxuJcIUl5rL3LuW4LJ89lO0TVxCm1/iwBXFIaRcgBHR4rRS4jXcEBoubU6OYkVpQB2lVgl1iC+iiK5Vlph76n1F5deaTWB2k23W7UDXlO23fx/IjYb344PyLWPSJ01QFkORtZaNFe7Gq2yosNwFP4HVjNBS7epKVPZHsCHLcsr2SRTBo9y00SRfFiaRydNHxL2vI3ZL5O2n5PcCxruMxI/Ui5lrp9K3ad/96GFTyG/s/SjWnJvRx/P32OPEaKUICfaOUIeBUPZG3j73RKd6ZVBbrnP3EAG5xtPRqNTbZHVquCEZDNlYn8ZizNoFeuSpDowXlka7x+T3WV2FXXIOPVgFA+iqEYJehU4YDSIhfT0DlpNUpZ5DupleG1enp4graGHquR2/9ulaBWrARDVH96IjCQ5xDainH+vgKaSQ8EawN6P9f3hoA5+SL+DZUSW027kmOlEjmmEZAGwWu2STl233G3Taov/EbmG1ShSBYO0SMFPbYu2Zp58uKZ4l5PX6koZfHiVZvWRJJeHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n25TKxtqRYP6Z+L2x26ZWfcEdwjTF4sUTyZUV7ibCDMH/BGr7t5EYVrQQ582?=
 =?us-ascii?Q?z+EgIFyhpW4dqqel80RD+JiywKg44SL2rgR/KeZsOaKaylTFkh1kGOM1FOkZ?=
 =?us-ascii?Q?hkftBYbtKR9zTxlAOvvxPVUn+9RgWOG3MpqQwLXNiWnnXcb0NJ9yUKtISxLp?=
 =?us-ascii?Q?TuPk+YgcbUNUnBd5b1m/C2NjTmk/wtkNuAkowrdMLGsEw/nHBANQ1ceJ0Tmt?=
 =?us-ascii?Q?wQ9Aaj5PKxNuQQ067LJbMabpvHbnlT54Xh0WV5ZPegbA1i5XF56T+IWOIqNc?=
 =?us-ascii?Q?lUk1Mep0JbNcEY3seYIyzLk9ruR2KazNSI/v7Az7H5fRUQuvoN7FUjma/9Rz?=
 =?us-ascii?Q?ykJEIemAKtX6MBpEcnbwBTqWJY/LogOs4WnYNxoOzgQG8orYVMbuVwPNf0cV?=
 =?us-ascii?Q?g3RW8/84QPyYyb24uW7+iLuuFp7RyWsOVR2yY00K1ATlMUu/Y1vqOxSGG8lI?=
 =?us-ascii?Q?Pc7gOo6VhA+aGdy76cq8uiYKj5VfBLWRzg9AYDkb0ISXIkRpqatLhNKKa3Ei?=
 =?us-ascii?Q?5rze9nUnIJzEbkOnMWyKmacr7X8S7dAPrXADpdbrDWiXhWasO9jfda60RVLA?=
 =?us-ascii?Q?FmqQSyIzPoAwgXfL3F7TGPZAnipwLglD+u5+YFaMfDS9sqZ2CEGyKWxwOJZt?=
 =?us-ascii?Q?KbWRA/GysWpqM6f0EnxjN+NhZ+1cqKcXDDwFRJJ4G54dLG6xxJPUn4wnGgbt?=
 =?us-ascii?Q?g8WPvPuF7nrA/aNJTrgrBWYHcs+5Seb6hCAukn5iS5OuBoqdHlrfDYbj8OqZ?=
 =?us-ascii?Q?gWO6P+geQFfiBQF301HDDMTZGidHBRhtHn2JL+6KMMOkMvfxfgm6uR94+DEa?=
 =?us-ascii?Q?sje6Kbgldj4YMcHVXOz8kaZozs9PcOh4llc0yogIz3I7UbQYFBNY8zBdjw2t?=
 =?us-ascii?Q?pqIlKxbfCI8KQG620GmXcxFy4YVUL512uM0uBVI9I7zvK7UnXzOTcNzr82Bf?=
 =?us-ascii?Q?PTfGrhVilbNkh6R8tfFwfW5WmNv6CI5UUTLjx/NIBrvsLjbSV7wlnmBoeE+B?=
 =?us-ascii?Q?m+Z55AW6Za3xrdOrEzNtb0hIL5gIRgVwB8z6GTPdxBH+pLJpvx/TIBs6y8D+?=
 =?us-ascii?Q?ejnicZbM9pZRGrrLx0JIJK0Po+ZRAlPlN5ztMcljlpOUU/YzmaTPE/+01NKX?=
 =?us-ascii?Q?scN2U82ds1wbDf65eu8qwwLumuuOG8MfPZWuK79QqNPl1RhNzUq3Sg0Bs5WG?=
 =?us-ascii?Q?ZYmvGSNzPe+Jy4Wj7jdOo7HkrCrJs4HT3nqIoOihDM0P1hKmDjfks7EIdPVg?=
 =?us-ascii?Q?osTVjBwcgS1SvLkFkzNARuflEVK9tdiTsVyjeypkzzy2+Mxa5tiqTUk8Nyd3?=
 =?us-ascii?Q?hVzjf5yAa87k6RRp6pqEaigzYPnEY8gseeyeaKK4QdGP779LGTSwWY/dh0Gd?=
 =?us-ascii?Q?XdaBFfoZ8Y/S5glHBwgqVuz3aamc24cPdmOzWNY2aH2YPbgYyhG6v6f9OMxA?=
 =?us-ascii?Q?RetrQyUFIqXI9F1Q4wqVsAKhojEH74yGNkuVeE6Nx4b74Fa8Oe4uGuN7pxXa?=
 =?us-ascii?Q?fhNBrQa7CtA+3F5opXePPRSTl+xLv63e3fkC+47thOPTumLb2HuMf7YnodLX?=
 =?us-ascii?Q?jJMT6rrG7tft3x3omfO4AILDKqq/DEMGfW2ukwEeRSaQG2fyazh7LCrcOfqJ?=
 =?us-ascii?Q?opqKjS52OCpkBJcswsQASbI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e0b912-981a-4f8d-6764-08d9fb6fed25
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:39.3384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBQibSXgZO0S9jikY3t4n0oSMdBfsUy35unrKw3hzGNSsjKdbaAAN4NXIMEekSjWbUTHp3XIoO0PWbGFtTXBrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-GUID: A3DqzepzdrJ47GOXEO3MPEiEeDxfzj81
X-Proofpoint-ORIG-GUID: A3DqzepzdrJ47GOXEO3MPEiEeDxfzj81
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following changes are made to enable userspace to obtain 64-bit extent
counters,
1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
   xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
   it is capable of receiving 64-bit extent counters.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 20 ++++++++++++++++----
 fs/xfs/xfs_ioctl.c     |  3 +++
 fs/xfs/xfs_itable.c    | 30 ++++++++++++++++++++++++++++--
 fs/xfs/xfs_itable.h    |  4 +++-
 fs/xfs/xfs_iwalk.h     |  2 +-
 5 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2204d49d0c3a..31ccbff2f16c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -378,7 +378,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -387,8 +387,9 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
@@ -469,8 +470,19 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
-				 XFS_BULK_IREQ_SPECIAL)
+/*
+ * Return data fork extent count via xfs_bulkstat->bs_extents64 field and assign
+ * 0 to xfs_bulkstat->bs_extents when the flag is set.  Otherwise, use
+ * xfs_bulkstat->bs_extents for returning data fork extent count and set
+ * xfs_bulkstat->bs_extents64 to 0. In the second case, return -EOVERFLOW and
+ * assign 0 to xfs_bulkstat->bs_extents if data fork extent count is larger than
+ * XFS_MAX_EXTCNT_DATA_FORK_OLD.
+ */
+#define XFS_BULK_IREQ_NREXT64	(1 << 2)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
+				 XFS_BULK_IREQ_SPECIAL | \
+				 XFS_BULK_IREQ_NREXT64)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2515fe8299e1..22947c5ffd34 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -813,6 +813,9 @@ xfs_bulk_ireq_setup(
 	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
 		return -ECANCELED;
 
+	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
+		breq->flags |= XFS_IBULK_NREXT64;
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index c08c79d9e311..0272a3c9d8b1 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -20,6 +20,7 @@
 #include "xfs_icache.h"
 #include "xfs_health.h"
 #include "xfs_trans.h"
+#include "xfs_errortag.h"
 
 /*
  * Bulk Stat
@@ -64,6 +65,7 @@ xfs_bulkstat_one_int(
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
 	struct xfs_bulkstat	*buf = bc->buf;
+	xfs_extnum_t		nextents;
 	int			error = -EINVAL;
 
 	if (xfs_internal_inum(mp, ino))
@@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize_blks = ip->i_extsize;
-	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
+
+	nextents = xfs_ifork_nextents(&ip->i_df);
+	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
+		xfs_extnum_t	max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
+
+		if (unlikely(XFS_TEST_ERROR(false, mp,
+				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
+			max_nextents = 10;
+
+		if (nextents > max_nextents) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_irele(ip);
+			error = -EOVERFLOW;
+			goto out;
+		}
+
+		buf->bs_extents = nextents;
+	} else {
+		buf->bs_extents64 = nextents;
+	}
+
 	xfs_bulkstat_health(ip, buf);
 	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
@@ -256,6 +278,7 @@ xfs_bulkstat(
 		.breq		= breq,
 	};
 	struct xfs_trans	*tp;
+	unsigned int		iwalk_flags = 0;
 	int			error;
 
 	if (breq->mnt_userns != &init_user_ns) {
@@ -279,7 +302,10 @@ xfs_bulkstat(
 	if (error)
 		goto out;
 
-	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
+	if (breq->flags & XFS_IBULK_SAME_AG)
+		iwalk_flags |= XFS_IWALK_SAME_AG;
+
+	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
 			xfs_bulkstat_iwalk, breq->icount, &bc);
 	xfs_trans_cancel(tp);
 out:
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 7078d10c9b12..9223529cd7bd 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -17,7 +17,9 @@ struct xfs_ibulk {
 };
 
 /* Only iterate within the same AG as startino */
-#define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
+#define XFS_IBULK_SAME_AG	(1ULL << 0)
+
+#define XFS_IBULK_NREXT64	(1ULL << 1)
 
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 37a795f03267..3a68766fd909 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -26,7 +26,7 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
 		unsigned int inode_records, bool poll, void *data);
 
 /* Only iterate inodes within the same AG as @startino. */
-#define XFS_IWALK_SAME_AG	(0x1)
+#define XFS_IWALK_SAME_AG	(1 << 0)
 
 #define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
 
-- 
2.30.2

