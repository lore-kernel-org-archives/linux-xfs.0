Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7CFC38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJXE4e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiJXE4c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:56:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED74279EEA
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:56:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O35jre031201;
        Mon, 24 Oct 2022 04:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mLCqb/TQimUiFdzIFi2rySXY1WWuSdRHBA6vfGNnYm0=;
 b=bVym6aVsHHrEWVp4q/ThdScAwQmqrlvnALjUFKh64gpbUS5V2DpinuBXT3aNValBpv+C
 WIxCW1Iw8TRZjn2YyOE1TQmNTBeMalQ/ItGIjWEWixXB8s7I5+s+oFJPlCK8FF0Yce1D
 vaB6CIO2FyjOcI4YD8MMpNXhI1AWvG2rsylZYqcLzUsDNtrMRauvRqRKZpDaB/+6MWq3
 kPFhNMl7LSeAW5q92VlhhabemQT1nDFgS7CExFqNWIysH9VzrWecAuv6BE8O7Tq0jl13
 GtF2Yrxb74dIzmghhgvT27pqzZB44RlMRh9a7URIZgbtR1TfpXjhvGvWI52vJcQAUrVD pA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2tnsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:56:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29NMDgnd015300;
        Mon, 24 Oct 2022 04:56:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y3379d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:56:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVz0KSBbs6P0i/KTRAp3y0rN1J95mJK2nJfn9kDkmQJCfvjYJhuQu9AWUO6R/m9a3mkyRGJEF/SmecWBCF85ZlESsfYCq3OhJujPVfyggcAzU9CBpdwDUr2Ypsw5vUSiv3tpswsmD14wmnWEusI80BHX9wAKvcXdEaZ/rrt3WQGtd5csnanK0bu2N0Ki6Zn+yafNKevkwev+MnJ+Wh4KryOJVaZAQTy6ty/mMIAWZ4N2UdkZe7nSU9SLZmp5Lhprxs07N12VCKkR0kJhHjzN9+YAJWBcIhb4HL2XNE0UdVxLCizVvnIcht7z4u/jVvK1MwAyXp6UBOS974B60WvLOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLCqb/TQimUiFdzIFi2rySXY1WWuSdRHBA6vfGNnYm0=;
 b=a9DJw0Zd7AuiErw9d5Ryl02MUPM30USKVyUtusAPPuBu3ybTiMyWhtqAcWPYKATQSOUTtBGM5AmLbHBCizt7865J1iVQDA5+j1wGia1rJFl0MxY5lyLBwSIrgHglP0riQlUfC8Am4SUWSRYSkUt9KSwRthi7KtdAJ8dwZ1VckXvBaVToOEk4sbBb8eqWIliAW36XYSLnVHj/V6SN7UCzC1I51Nt91fwfAa0UfWtsyyliVqoj9SHe+aDC1trDp9BSKZEXfqSjWvS+7pC6M7P30YywKapW/4Nwlza4K59pUDXn4lE95rgOE2uLhmBoZwnlgGZrZMVjGYCvt9NgRSNvfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLCqb/TQimUiFdzIFi2rySXY1WWuSdRHBA6vfGNnYm0=;
 b=fqCh6OkC5ZYEwhTZgzgckPfnbL5BNP4iQQzf31yWrlqfqzKBOyrsIUdcv5w7w2VoR5tUEJ7bQq+y50SrJVVupZCWWvs9J+CgWRfbvMLbfDHEqRic94F+MYHzWVEdbqJDPZJPpfdpvgebXJDo89uATC1MfjMR6QlXuSxhyQlvlRI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4906.namprd10.prod.outlook.com (2603:10b6:610:c6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:56:25 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:56:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 25/26] xfs: move inode flush to the sync workqueue
Date:   Mon, 24 Oct 2022 10:23:13 +0530
Message-Id: <20221024045314.110453-26-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:195::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: e8bfa8db-c58f-4f9e-1034-08dab57c1a5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S+gXEExwCyKnKWGl6W1dTzcaL0NAEn7iPGvjG2VDQYFhtu7MGCBnCNrknG5fI0NI5bHJqnPmcvYb0AhzcQEhl5VPNprUNvLNtlvkl3O29Hihexpqa5XpjrXYG2nMlmH93ZKQiKAyAn45PUiFSeJ3cfV1J8HEj9YA+nMMG72IsZlbXO1954MJInVoxe1W+jqwDefOlAtLeWDtU9SGLnt5/NUMGsnYWFxGHzQ1I1nzoHmo5L4/yPbBegRA5MbPdtxRcb+ebJFTJVihLAFPe0v8uWtkrnrVlV+MykbrGD8fi4+xQdogLByCpzB+r7WdaXdow5rKMBh/aiHCNQTBTFW4UTqbOECS+9hpGensCVafLX6cxwhKmCkwoDrLTAtcWVW9OsNJvm9ICkPilf8RcHJqmPz3dS2as0QD2FYcw6F/GmjAuLCx/9FIojQVkx2h0HivRMN/I04LPgG5pxd77iDSrKX97hpB8m4KXLfhEEFzEiltMLNZpMOdjRQ8MqVAWJ+WCNFJek9ICB/J4nkKcCgTz7MO/qya8kv+agVUbik9GWpuY+x7RkFajujVquc94nhVwbbQAy5Q/86yW9IyIWf8qxC+Xc+wrFru+HbcKW3RZzN77Yk4q84+Bcn+omvOSpLu+6vm8c3/Ne+gY2VB0rvd45C2DyVXZzmzj1I49Qlf8BoW91Yq9JxRcZVXZrGXGUQv6VAJ+zpD2+oejmU1cS09vA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(2616005)(1076003)(66556008)(66946007)(66476007)(5660300002)(6506007)(186003)(6666004)(83380400001)(36756003)(6486002)(4326008)(478600001)(8676002)(38100700002)(86362001)(41300700001)(8936002)(6916009)(2906002)(26005)(6512007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vJioBq7P43SHZkjkmcKPHFmgR7F7ENW3NOcZj8YN/Q/Ph3drv/JXu5B4TU9z?=
 =?us-ascii?Q?lX8pzgEyD3gQCVMJkdHL9RD41C/I+MXF6NUpqTC4vr83EzKd7/o/ltgnMl5+?=
 =?us-ascii?Q?J5IO3PaFli6qiFszYygJQyVZJIIrhtwJR1bFlNjRRx7lhDBZdOoRyX8rwNYK?=
 =?us-ascii?Q?ahG5fAJEvfSl6op1lFPSfwHfDHtr/Hxe5GaEFiUcMnwUK+WxETdCgX5RAC0l?=
 =?us-ascii?Q?e78S7bGCRVveSLM9mNn4fbzJANT5fCsP454CXXBPI1Isi7+zdgQ/jy50MJEH?=
 =?us-ascii?Q?4mui9fHE34NAIzIakvgqyC9EQFU2Q9lai1QZVDC2s7JsavOydXsokOvdxK39?=
 =?us-ascii?Q?WgBJul+nwrVemSwmLqbAHBgKdGPnVxnrH0Z3efyotwPWDlXFaclfkALBIcFP?=
 =?us-ascii?Q?cIX1C2jRInJE1szaHKrW/20TvWYljufDDzECK7PYe+5JOvBgHpG2v3ja65YC?=
 =?us-ascii?Q?PiaBriw6oZ280qpM7A9ugdhtnjPvwF+jvt4SH14tpBR786qWdqHDfFK+LcE1?=
 =?us-ascii?Q?+jvD1VFMB8WHDxGiq2RhiSiMqQRXvupRmLz1VfcAN/HBDK4xDezDL7Fi0/Wq?=
 =?us-ascii?Q?3Phv1c8iYEX6kE58lNjtKJT0sp4PqQq1loO9yaTp7GQHu9rTbiK5o9M28Q7a?=
 =?us-ascii?Q?j63abHR1pxljjoq4aEr0P2zwKp72ECvVZ4ahdqpqoFoUOepDB7GUCufFxMRi?=
 =?us-ascii?Q?zFRVjsSFM7RyGszyt7rUWkkBBQq0wX4YNNN247ZBOd8jNQkvI/19oZWcTcsV?=
 =?us-ascii?Q?Jz4FhIWzmot7YoLK9cueWKTxg+8bHHGmKkfE4qkp1mrkENxC1cZac5HOnrOI?=
 =?us-ascii?Q?DfVXCe+2l3jPUMd5vMd5gqSPAdN4fJSQ8vdMcZ6nAlfkjqy4Rzue9kwHIC1g?=
 =?us-ascii?Q?OQrv0B0VFLnwfmrGnAjn9GeD6+/nN95JSVyIBX5Go1qvkOBSN5DfTYSrwFBJ?=
 =?us-ascii?Q?Pkr1rBHnCm0T+SLJiOSS0VkA6UA+QdXMv06T/UnAdXhzVSjJTLlhquSm0vo1?=
 =?us-ascii?Q?wUnZE4xF6vD797sFVbLkyCDfG3AIEEL6X0TKfGpcTcDE1cHDxP34sd1vEucM?=
 =?us-ascii?Q?0wOnFxBjtEcNm502RgOgAcsYN1VwVkPHlN7j9DrvlADuATxp6xtCT7I3/M63?=
 =?us-ascii?Q?WIIdD9vYaKsZu4Pu0U9HQfcJ/4dF3iJd/aYKJPMgzzGiafgFYgBRch4dI8qA?=
 =?us-ascii?Q?EBcXNvOpWwPF0F+8/vhNlKtSGe57M70OpKUwPcSqdqx8bD7eJE9D+H8hCGW4?=
 =?us-ascii?Q?7UJ91OaZyNB6gZ/zyVs4ZkKVPpOUwuYxJbGUf0uOqcYuYsxcAkEdENgdMd7s?=
 =?us-ascii?Q?EW40qFrHiAtPzgll146qaYPeTf40BW2M4py+k819gOL3TZK3z1+o1wFSpWt7?=
 =?us-ascii?Q?ho3KBSHTUnchDlvpq7tIm1SwYUdCOwlSbmea4PqrjH7owOS82ranF8JOj6S2?=
 =?us-ascii?Q?fI7Gz5Tz2dEun+8CjZ6BXcduJErGdXuOa46ccbomFlbbN7E2byRi/bv3L0p6?=
 =?us-ascii?Q?niiwxk8gqpWBGeUT6npvdJwnkWSshSzd6EKa84/RLe+Yhm32UYIhJAEuMj5Y?=
 =?us-ascii?Q?gELX/8tUyRd67lRswqKX0Y+Un+X9WC4H+Xi+RGLcQpEjgMRT8naxJJknEP8z?=
 =?us-ascii?Q?Ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8bfa8db-c58f-4f9e-1034-08dab57c1a5b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:56:25.1905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hSGfVftdmZgLMpxkCgufYXq3qqX9cRr8tvwwrknl82cBmzFv5GGVCY75Uo9+6dfvtVvWu9/OwrqM0iB2vInxxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240031
X-Proofpoint-GUID: bRGCDDjTv6jN20tFssIzUpiJRiXPR_SF
X-Proofpoint-ORIG-GUID: bRGCDDjTv6jN20tFssIzUpiJRiXPR_SF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit f0f7a674d4df1510d8ca050a669e1420cf7d7fab upstream.

[ Modify fs/xfs/xfs_super.c to include the changes at locations suitable for
 5.4-lts kernel ]

Move the inode dirty data flushing to a workqueue so that multiple
threads can take advantage of a single thread's flushing work.  The
ratelimiting technique used in bdd4ee4 was not successful, because
threads that skipped the inode flush scan due to ratelimiting would
ENOSPC early, which caused occasional (but noticeable) changes in
behavior and sporadic fstest regressions.

Therefore, make all the writer threads wait on a single inode flush,
which eliminates both the stampeding hordes of flushers and the small
window in which a write could fail with ENOSPC because it lost the
ratelimit race after even another thread freed space.

Fixes: c6425702f21e ("xfs: ratelimit inode flush on buffered write ENOSPC")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_mount.h |  5 +++++
 fs/xfs/xfs_super.c | 28 +++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fdb60e09a9c5..ca7e0c656cee 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -179,6 +179,11 @@ typedef struct xfs_mount {
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
 
+	/*
+	 * Workqueue item so that we can coalesce multiple inode flush attempts
+	 * into a single flush.
+	 */
+	struct work_struct	m_flush_inodes_work;
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a3a54a0fbffe..2429acbfb132 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -840,6 +840,20 @@ xfs_destroy_mount_workqueues(
 	destroy_workqueue(mp->m_buf_workqueue);
 }
 
+static void
+xfs_flush_inodes_worker(
+	struct work_struct	*work)
+{
+	struct xfs_mount	*mp = container_of(work, struct xfs_mount,
+						   m_flush_inodes_work);
+	struct super_block	*sb = mp->m_super;
+
+	if (down_read_trylock(&sb->s_umount)) {
+		sync_inodes_sb(sb);
+		up_read(&sb->s_umount);
+	}
+}
+
 /*
  * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
  * or a page lock. We use sync_inodes_sb() here to ensure we block while waiting
@@ -850,12 +864,15 @@ void
 xfs_flush_inodes(
 	struct xfs_mount	*mp)
 {
-	struct super_block	*sb = mp->m_super;
+	/*
+	 * If flush_work() returns true then that means we waited for a flush
+	 * which was already in progress.  Don't bother running another scan.
+	 */
+	if (flush_work(&mp->m_flush_inodes_work))
+		return;
 
-	if (down_read_trylock(&sb->s_umount)) {
-		sync_inodes_sb(sb);
-		up_read(&sb->s_umount);
-	}
+	queue_work(mp->m_sync_workqueue, &mp->m_flush_inodes_work);
+	flush_work(&mp->m_flush_inodes_work);
 }
 
 /* Catch misguided souls that try to use this interface on XFS */
@@ -1532,6 +1549,7 @@ xfs_mount_alloc(
 	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
+	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
-- 
2.35.1

