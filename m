Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD5DC38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiJXEys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiJXEyq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:54:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354F71F9F1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:54:40 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2eWiR025813;
        Mon, 24 Oct 2022 04:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Qdo1j+XhqOhePIqxw0PJ40VRhxr/J46ku9YdCesCiT4=;
 b=P51Zrv+FsGfZ7Q0osGFPXUp34icZLzBVnziXrrFIgKp9M75XDQcjl9ZQwaKeD8DLBeUY
 5JPzgO4gH1kxBHsAlYR0qUIwMjCO+HSJWB4Qr6T3qUe6kanE2SlkVVVd5g39z0BCNEyG
 EvUGj1DbV1k9503DlNUFrexWOHRXTSBHpDfrcZ160LOY2U+JaoLog9xZ5QFVmB3KV4BA
 ixsJr+ie92nZpL1raOIrqYJT8PMZ8xJmev16/5Tjeh9MMhunwkZLYrVvFpLxc4RwztnM
 pE9eLIeOVRcj7Sz4W1AfBcRlwWj4ENkWA6BY88xcszzeLMt68xHnC9peUvA5pPvrpelD EA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xdtn49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O0MAYd040872;
        Mon, 24 Oct 2022 04:54:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y944x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=essLLg7AEwB7n45axWBotnbKAd5+5VQzDlJt5UKJJU5ZHTzTCeFSiHKnnmzw7el7rtRWGyC5MmL6s9IatDvrORRbZHWDNIZSMWoPt0WIZtONhG+VVUtrKjrI0J1XITGe711DSIaOqsIY9JjNF0Y+KiE6yU2fV7iJVOpw/Mia+bSA4ZUjVQ+QbIAR8CA+wlCftQqjrO6HT5vqc4aXDV9y0Cg52jXAfy0db3hy0vdBVQLPM5VmDb46g8d5pGx1ywhrz5v6xyKxcZxY4fPQSkTefBhPJbwpRflpDE/RWMTX+RH8s1w/BQqvCXD871Kl+8sBWWIPSr+krUaDo0GET05iPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qdo1j+XhqOhePIqxw0PJ40VRhxr/J46ku9YdCesCiT4=;
 b=DML6m4OFE912SKsAhcrqRxB/GWa2ctF4cr3PC5/K9di7HZldJuUydUMPH5e9AFfnk03+whjv4yctFeUjG1S0b7eNWJHQkylASrObySo5CGdUsTu3DyTbk2zHttpDRHCDwQzHrdMz0FT6EOTo5viHQPcNDL6L5OdyoBRGjwPb0xEixC613XP24z/rwcRkzKhFUkZcbGoSWI/EPnqjsqz1+i/wcRlTwTfYSbzc745Iu1VPOoa7iZwuk11AxN/0d8OurEQSmhkyBOW5UhExwSSbZEt49u46vJ1g+hGrH5K9r+8aiOysrA7xgKXMaIA18m3AgfYqpzNQ25h5X6sodFmRyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qdo1j+XhqOhePIqxw0PJ40VRhxr/J46ku9YdCesCiT4=;
 b=zCCs6QTQ8ozxTvA78s8ou+mZaqcq3rokrv708LHbblfNzvD4KDAKCUOfxWg3LNy1mGuPhXUt1bw0O/iAKN0gwfnlJ32fc75kOkLaPIJDLeTQS/i330us4c3Kdj2FwyC4XykZVTqTDTLwNU5imoYJK+CRDvx7Q1Gc60mN0c/2Hrw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:54:33 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:54:33 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 10/26] xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
Date:   Mon, 24 Oct 2022 10:22:58 +0530
Message-Id: <20221024045314.110453-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0058.apcprd02.prod.outlook.com
 (2603:1096:404:e2::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: aa705503-7759-4882-89c3-08dab57bd7c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BEXaM8r3TOg0NB+ywqthZewj28CuiYNz2m8McwqO/Fgwon0EVQFHCxU6duVdqTEMJ87MEGZClKQGtLEptyJNgr+baxhTjbsEL9GlrI2gFMeFa4orrhE/GvLEFCCJQgL8Iq8L1gEpAHeiiAJFA2F/lj6dRxPkugZt9R/f+wvL0qPm1kzcD/m1fPKA8AlUE3lJonXtM2Dkb0NxfclnqFx+cA9oXkgIPLZni4Ad8QlPDmBujg1+kzn72w83LXpYJ6LwLo06v5qBVz0WT2TnGwsE99eAEG2gZb8CCv0+X3cuLR/BJW5DPkV6utgAIBAXntmixd3IhcbtIoGbjkhmLFHr6ITxslsukoE9/n67Oo993QzUNWz1bVq+BBwy4k0E3nmQelqNDGnqzb/sPbP1RmOjM9nTl/RIroUdlf6ys0oXU2yscrcBmXrVekpcnUu+bZ8VDaCmQ/TH4QZHepRvtKYDtSzrUd/DQf7kvvqwu6bfcb89fLrVeNqtxPTNMBsU2EYCpBT+QyJGqPn5Zd+0WgYxtXFcUJwKvrq+OTV/hT3pVIhhns8aWmKLHwLn7a/QptxM8Dd/crYt5EJxW6qoYUU/wugafowt+Ty8LNvYJA4aCdkHDRToB82fijrWtFsaNtEZW9yUuokINfERYXI7sdKAjKyfe+f1BCJYln1UgX6SSVyMc73SZmQsgkFRfeAfbRQaw6lNLEzHAz/CLLzYo+u+uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(34290500002)(4326008)(8676002)(8936002)(30864003)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xg1ec8ueh0Rn0LGjl0QCa5Ck6ToZ++C41SFZOU1ADPGM7/0wEUDIAl52eP6o?=
 =?us-ascii?Q?cknCv29JoN4jpCugsH1vE/W3bLk/xgLDLXBCTtZK2PcAe9vgp4SSZ23g8H6j?=
 =?us-ascii?Q?3stbc2GbiHyB4xEFrsKg7EtSApc0mKrFJ55IfpdinrwoSXUQqDbXITgps8lt?=
 =?us-ascii?Q?1Zteg48CsQmxrJbItTFYr707LM0gum0geuJg8Wj3hlyMp0yjRSswCWa7uGqJ?=
 =?us-ascii?Q?sVrzNy7QDRtzlm36NAFTVm4OSEkemCoeh66ppBo2N8oBBAZ7jC4sQ0YcdSct?=
 =?us-ascii?Q?WOGkFs7YRcQXhBHUMQ6IvlG1jtEyMgv5ZoSwt1Fli4e/MyQcHzNesHrvQZLl?=
 =?us-ascii?Q?TT/sfGa4xF8IdefCvJCf6j5cLEBuM2RAPvhNKCNd8d85EMoI+Juh04Sah7er?=
 =?us-ascii?Q?znLK2SGFlp0uGKnSfLE83BYzklro3QcZI02syVnqpMa9qS9v2cp0V94SllmW?=
 =?us-ascii?Q?oeKdUXIWSpSN7dZWQXBeDG+lCWUwpWx6X9l8X0/joDuK6KU2wPLP6wBXMegg?=
 =?us-ascii?Q?jAeO4teNDrw1Ev8XeQlNi2R2ItQq70ImxxQ/me7DCh3Llz06zlkQYpGw2w4U?=
 =?us-ascii?Q?XFWwlDnrkLd1S28EpdpwuEEXP0uGZ060PB8W7UuX6OEO0mBA12QTGCbP4XOC?=
 =?us-ascii?Q?E4yjCcPm7Si6gYKvAdOkm/XO6F/qB4pdk2kIQwXkrW5IRwxKpl87tFUpNnc3?=
 =?us-ascii?Q?YZOCRDlEbPDO71KY1XJxa/LWS14Sc6kh2/e9MVXgdR24snf18Vlpwo5O1zx+?=
 =?us-ascii?Q?5gGgqWeCKUvUdFuNHuXIY1yrrBWt2U4pee/GzUyZcs0tcl42gjrF4eYLRafh?=
 =?us-ascii?Q?pchX15+Ay9iQFl2LRlSMTTfbZ4LIoW0eV3KRwxa0BW830uP6YQLzt6X+vN6x?=
 =?us-ascii?Q?6nXx/bBFyduavxqdXuF95Lw/7Yx/ge5G90sbb/qOhgxHjsK31Rpz1cZOmlAb?=
 =?us-ascii?Q?i/Kd2O9Pe3ycUpfo0euBre3LldP/K3ZU7etyxBGu3obM7atnvCPmW4gTlmEi?=
 =?us-ascii?Q?HaipnTm64YQW7yRB/gJP8cVh4/hih2KVGnALDG8gu4pmV96SI9BfsYhYyRbH?=
 =?us-ascii?Q?lUlsH9qYPHEUTvks8M8VTgcY1TErlNN/7aMZuKyJor/dyLHrFu/8xS/dh83b?=
 =?us-ascii?Q?frKH3Bmt9/pZSfw3l6cPSYGAbfCGJ44wfKSEe26g5HWaBHx+f9qwY1JTwQ3y?=
 =?us-ascii?Q?JOKHo7bQZvdHQ5SGQmBb54e6ah1uhReW5SmNeSHOmVUl0c0Ygo0zAQjyfauo?=
 =?us-ascii?Q?ZsY/y6tporaaCjQ2agYNymG9dp5sAq0c/E9v30mJu5sBsDVzOyGx7jV7v9Yr?=
 =?us-ascii?Q?jJaccE3sRKNFSSbslN4ICTxsHEEFB0uV2GbM2XApbUDsZzDx6PN2lASboo/r?=
 =?us-ascii?Q?T5gnRbQPaPxV4eenmWb4g9BiBfOholtHU29a2nBJREDdQucd0kE2UWyGqrze?=
 =?us-ascii?Q?f5vnd1upELeeOR93jni3h/LMRfa9ladlyHSMiYyZDyo7alV6IT/ixoNGtFAu?=
 =?us-ascii?Q?FxBRKwOu3qO8H+2L3I/Xeh/4JB9GP+6hs2clWe2cKVm1ens4JkOZ0cuby/Rk?=
 =?us-ascii?Q?4Bkfz1dV7zRQg8w564/ukOSVzZGU/eLgaLt+atPmsHrTejhD/IdUtWDeEzoj?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa705503-7759-4882-89c3-08dab57bd7c1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:54:33.5485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEVKsK2/ytRAyPpiU70jxVLVlGB727I/w5pMQYSCHFwczfMXrCmLn+Fa8vS2sXKSsFUAu/GQ4N/n5JhrqY/Wgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: achvEsRTrbT9GFsicuclIk40-eGxmDxn
X-Proofpoint-ORIG-GUID: achvEsRTrbT9GFsicuclIk40-eGxmDxn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Pavel Reichl <preichl@redhat.com>

commit aefe69a45d84901c702f87672ec1e93de1d03f73 upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix some of the comments]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |  8 +--
 fs/xfs/libxfs/xfs_format.h     | 10 ++--
 fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
 fs/xfs/xfs_dquot.c             | 18 +++----
 fs/xfs/xfs_dquot.h             | 98 +++++++++++++++++-----------------
 fs/xfs/xfs_log_recover.c       |  5 +-
 fs/xfs/xfs_qm.c                | 30 +++++------
 fs/xfs/xfs_qm_bhv.c            |  6 +--
 fs/xfs/xfs_trans_dquot.c       | 42 +++++++--------
 9 files changed, 111 insertions(+), 108 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index e8bd688a4073..bedc1e752b60 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -35,10 +35,10 @@ xfs_calc_dquots_per_chunk(
 
 xfs_failaddr_t
 xfs_dquot_verify(
-	struct xfs_mount *mp,
-	xfs_disk_dquot_t *ddq,
-	xfs_dqid_t	 id,
-	uint		 type)	  /* used only during quotacheck */
+	struct xfs_mount	*mp,
+	struct xfs_disk_dquot	*ddq,
+	xfs_dqid_t		id,
+	uint			type)	/* used only during quotacheck */
 {
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 28203b626f6a..1f24473121f0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1144,11 +1144,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 
 /*
  * This is the main portion of the on-disk representation of quota
- * information for a user. This is the q_core of the xfs_dquot_t that
+ * information for a user. This is the q_core of the struct xfs_dquot that
  * is kept in kernel memory. We pad this with some more expansion room
  * to construct the on disk structure.
  */
-typedef struct	xfs_disk_dquot {
+struct xfs_disk_dquot {
 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
 	__u8		d_version;	/* dquot version */
 	__u8		d_flags;	/* XFS_DQ_USER/PROJ/GROUP */
@@ -1171,15 +1171,15 @@ typedef struct	xfs_disk_dquot {
 	__be32		d_rtbtimer;	/* similar to above; for RT disk blocks */
 	__be16		d_rtbwarns;	/* warnings issued wrt RT disk blocks */
 	__be16		d_pad;
-} xfs_disk_dquot_t;
+};
 
 /*
  * This is what goes on disk. This is separated from the xfs_disk_dquot because
  * carrying the unnecessary padding would be a waste of memory.
  */
 typedef struct xfs_dqblk {
-	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
-	char		  dd_fill[4];	/* filling for posterity */
+	struct xfs_disk_dquot	dd_diskdq; /* portion living incore as well */
+	char			dd_fill[4];/* filling for posterity */
 
 	/*
 	 * These two are only present on filesystems with the CRC bits set.
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index b3584cd2cc16..f7e87b90c7e5 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -776,7 +776,7 @@ xfs_calc_clear_agi_bucket_reservation(
 
 /*
  * Adjusting quota limits.
- *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
+ *    the disk quota buffer: sizeof(struct xfs_disk_dquot)
  */
 STATIC uint
 xfs_calc_qm_setqlim_reservation(void)
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index aa5084180270..193a7d3353f4 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -48,7 +48,7 @@ static struct lock_class_key xfs_dquot_project_class;
  */
 void
 xfs_qm_dqdestroy(
-	xfs_dquot_t	*dqp)
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(list_empty(&dqp->q_lru));
 
@@ -113,8 +113,8 @@ xfs_qm_adjust_dqlimits(
  */
 void
 xfs_qm_adjust_dqtimers(
-	xfs_mount_t		*mp,
-	xfs_disk_dquot_t	*d)
+	struct xfs_mount	*mp,
+	struct xfs_disk_dquot	*d)
 {
 	ASSERT(d->d_id);
 
@@ -497,7 +497,7 @@ xfs_dquot_from_disk(
 	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
 
 	/* copy everything from disk dquot to the incore dquot */
-	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
+	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
 
 	/*
 	 * Reservation counters are defined as reservation plus current usage
@@ -989,7 +989,7 @@ xfs_qm_dqput(
  */
 void
 xfs_qm_dqrele(
-	xfs_dquot_t	*dqp)
+	struct xfs_dquot	*dqp)
 {
 	if (!dqp)
 		return;
@@ -1019,7 +1019,7 @@ xfs_qm_dqflush_done(
 	struct xfs_log_item	*lip)
 {
 	xfs_dq_logitem_t	*qip = (struct xfs_dq_logitem *)lip;
-	xfs_dquot_t		*dqp = qip->qli_dquot;
+	struct xfs_dquot	*dqp = qip->qli_dquot;
 	struct xfs_ail		*ailp = lip->li_ailp;
 
 	/*
@@ -1129,7 +1129,7 @@ xfs_qm_dqflush(
 	}
 
 	/* This is the only portion of data that needs to persist */
-	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
+	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
 
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
@@ -1187,8 +1187,8 @@ xfs_qm_dqflush(
  */
 void
 xfs_dqlock2(
-	xfs_dquot_t	*d1,
-	xfs_dquot_t	*d2)
+	struct xfs_dquot	*d1,
+	struct xfs_dquot	*d2)
 {
 	if (d1 && d2) {
 		ASSERT(d1 != d2);
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 4fe85709d55d..831e4270cf65 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -30,33 +30,36 @@ enum {
 /*
  * The incore dquot structure
  */
-typedef struct xfs_dquot {
-	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
-	struct list_head q_lru;		/* global free list of dquots */
-	struct xfs_mount*q_mount;	/* filesystem this relates to */
-	uint		 q_nrefs;	/* # active refs from inodes */
-	xfs_daddr_t	 q_blkno;	/* blkno of dquot buffer */
-	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
-	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
-
-	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
-	xfs_dq_logitem_t q_logitem;	/* dquot log item */
-	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
-	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
-	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
-	xfs_qcnt_t	 q_prealloc_lo_wmark;/* prealloc throttle wmark */
-	xfs_qcnt_t	 q_prealloc_hi_wmark;/* prealloc disabled wmark */
-	int64_t		 q_low_space[XFS_QLOWSP_MAX];
-	struct mutex	 q_qlock;	/* quota lock */
-	struct completion q_flush;	/* flush completion queue */
-	atomic_t          q_pincount;	/* dquot pin count */
-	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
-} xfs_dquot_t;
+struct xfs_dquot {
+	uint			dq_flags;
+	struct list_head	q_lru;
+	struct xfs_mount	*q_mount;
+	uint			q_nrefs;
+	xfs_daddr_t		q_blkno;
+	int			q_bufoffset;
+	xfs_fileoff_t		q_fileoffset;
+
+	struct xfs_disk_dquot	q_core;
+	xfs_dq_logitem_t	q_logitem;
+	/* total regular nblks used+reserved */
+	xfs_qcnt_t		q_res_bcount;
+	/* total inos allocd+reserved */
+	xfs_qcnt_t		q_res_icount;
+	/* total realtime blks used+reserved */
+	xfs_qcnt_t		q_res_rtbcount;
+	xfs_qcnt_t		q_prealloc_lo_wmark;
+	xfs_qcnt_t		q_prealloc_hi_wmark;
+	int64_t			q_low_space[XFS_QLOWSP_MAX];
+	struct mutex		q_qlock;
+	struct completion	q_flush;
+	atomic_t		q_pincount;
+	struct wait_queue_head	q_pinwait;
+};
 
 /*
  * Lock hierarchy for q_qlock:
  *	XFS_QLOCK_NORMAL is the implicit default,
- * 	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
+ *	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
  */
 enum {
 	XFS_QLOCK_NORMAL = 0,
@@ -64,21 +67,21 @@ enum {
 };
 
 /*
- * Manage the q_flush completion queue embedded in the dquot.  This completion
+ * Manage the q_flush completion queue embedded in the dquot. This completion
  * queue synchronizes processes attempting to flush the in-core dquot back to
  * disk.
  */
-static inline void xfs_dqflock(xfs_dquot_t *dqp)
+static inline void xfs_dqflock(struct xfs_dquot *dqp)
 {
 	wait_for_completion(&dqp->q_flush);
 }
 
-static inline bool xfs_dqflock_nowait(xfs_dquot_t *dqp)
+static inline bool xfs_dqflock_nowait(struct xfs_dquot *dqp)
 {
 	return try_wait_for_completion(&dqp->q_flush);
 }
 
-static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
+static inline void xfs_dqfunlock(struct xfs_dquot *dqp)
 {
 	complete(&dqp->q_flush);
 }
@@ -112,7 +115,7 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
 	}
 }
 
-static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
+static inline struct xfs_dquot *xfs_inode_dquot(struct xfs_inode *ip, int type)
 {
 	switch (type & XFS_DQ_ALLTYPES) {
 	case XFS_DQ_USER:
@@ -147,31 +150,30 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
 #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
 
-extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
-extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
-extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
-extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
-					xfs_disk_dquot_t *);
-extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
-					       struct xfs_dquot *);
-extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
-					uint type);
-extern int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
+void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
+int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
+void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
+void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
+						struct xfs_disk_dquot *d);
+void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
+						struct xfs_dquot *d);
+xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
+int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
 					uint type, bool can_alloc,
 					struct xfs_dquot **dqpp);
-extern int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
-					bool can_alloc,
-					struct xfs_dquot **dqpp);
-extern int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
+int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
+						bool can_alloc,
+						struct xfs_dquot **dqpp);
+int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
 					uint type, struct xfs_dquot **dqpp);
-extern int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
-					xfs_dqid_t id, uint type,
-					struct xfs_dquot **dqpp);
-extern void		xfs_qm_dqput(xfs_dquot_t *);
+int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
+						xfs_dqid_t id, uint type,
+						struct xfs_dquot **dqpp);
+void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
-extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
+void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
 
-extern void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
+void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
 
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 248101876e1e..46b1e255f55f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2577,6 +2577,7 @@ xlog_recover_do_reg_buffer(
 	int			bit;
 	int			nbits;
 	xfs_failaddr_t		fa;
+	const size_t		size_disk_dquot = sizeof(struct xfs_disk_dquot);
 
 	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
 
@@ -2619,7 +2620,7 @@ xlog_recover_do_reg_buffer(
 					"XFS: NULL dquot in %s.", __func__);
 				goto next;
 			}
-			if (item->ri_buf[i].i_len < sizeof(xfs_disk_dquot_t)) {
+			if (item->ri_buf[i].i_len < size_disk_dquot) {
 				xfs_alert(mp,
 					"XFS: dquot too small (%d) in %s.",
 					item->ri_buf[i].i_len, __func__);
@@ -3250,7 +3251,7 @@ xlog_recover_dquot_pass2(
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
 		return -EFSCORRUPTED;
 	}
-	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
+	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
 		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 66ea8e4fca86..035930a4f0dd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -244,14 +244,14 @@ xfs_qm_unmount_quotas(
 
 STATIC int
 xfs_qm_dqattach_one(
-	xfs_inode_t	*ip,
-	xfs_dqid_t	id,
-	uint		type,
-	bool		doalloc,
-	xfs_dquot_t	**IO_idqpp)
+	struct xfs_inode	*ip,
+	xfs_dqid_t		id,
+	uint			type,
+	bool			doalloc,
+	struct xfs_dquot	**IO_idqpp)
 {
-	xfs_dquot_t	*dqp;
-	int		error;
+	struct xfs_dquot	*dqp;
+	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	error = 0;
@@ -544,8 +544,8 @@ xfs_qm_set_defquota(
 	uint		type,
 	xfs_quotainfo_t	*qinf)
 {
-	xfs_dquot_t		*dqp;
-	struct xfs_def_quota    *defq;
+	struct xfs_dquot	*dqp;
+	struct xfs_def_quota	*defq;
 	struct xfs_disk_dquot	*ddqp;
 	int			error;
 
@@ -1746,14 +1746,14 @@ xfs_qm_vop_dqalloc(
  * Actually transfer ownership, and do dquot modifications.
  * These were already reserved.
  */
-xfs_dquot_t *
+struct xfs_dquot *
 xfs_qm_vop_chown(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	xfs_dquot_t	**IO_olddq,
-	xfs_dquot_t	*newdq)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_dquot	**IO_olddq,
+	struct xfs_dquot	*newdq)
 {
-	xfs_dquot_t	*prevdq;
+	struct xfs_dquot	*prevdq;
 	uint		bfield = XFS_IS_REALTIME_INODE(ip) ?
 				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
 
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 5d72e88598b4..b784a3751fe2 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -54,11 +54,11 @@ xfs_fill_statvfs_from_dquot(
  */
 void
 xfs_qm_statvfs(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	struct kstatfs		*statp)
 {
-	xfs_mount_t		*mp = ip->i_mount;
-	xfs_dquot_t		*dqp;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_dquot	*dqp;
 
 	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 904780dd74aa..b6c8ee0dd39f 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -25,8 +25,8 @@ STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
  */
 void
 xfs_trans_dqjoin(
-	xfs_trans_t	*tp,
-	xfs_dquot_t	*dqp)
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	ASSERT(dqp->q_logitem.qli_dquot == dqp);
@@ -49,8 +49,8 @@ xfs_trans_dqjoin(
  */
 void
 xfs_trans_log_dquot(
-	xfs_trans_t	*tp,
-	xfs_dquot_t	*dqp)
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
@@ -486,12 +486,12 @@ xfs_trans_apply_dquot_deltas(
  */
 void
 xfs_trans_unreserve_and_mod_dquots(
-	xfs_trans_t		*tp)
+	struct xfs_trans	*tp)
 {
 	int			i, j;
-	xfs_dquot_t		*dqp;
+	struct xfs_dquot	*dqp;
 	struct xfs_dqtrx	*qtrx, *qa;
-	bool                    locked;
+	bool			locked;
 
 	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
 		return;
@@ -571,21 +571,21 @@ xfs_quota_warn(
  */
 STATIC int
 xfs_trans_dqresv(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dquot_t	*dqp,
-	int64_t		nblks,
-	long		ninos,
-	uint		flags)
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*dqp,
+	int64_t			nblks,
+	long			ninos,
+	uint			flags)
 {
-	xfs_qcnt_t	hardlimit;
-	xfs_qcnt_t	softlimit;
-	time_t		timer;
-	xfs_qwarncnt_t	warns;
-	xfs_qwarncnt_t	warnlimit;
-	xfs_qcnt_t	total_count;
-	xfs_qcnt_t	*resbcountp;
-	xfs_quotainfo_t	*q = mp->m_quotainfo;
+	xfs_qcnt_t		hardlimit;
+	xfs_qcnt_t		softlimit;
+	time_t			timer;
+	xfs_qwarncnt_t		warns;
+	xfs_qwarncnt_t		warnlimit;
+	xfs_qcnt_t		total_count;
+	xfs_qcnt_t		*resbcountp;
+	xfs_quotainfo_t		*q = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
 
 
-- 
2.35.1

