Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AB1C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhLNIrF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:05 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50632 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229914AbhLNIrF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:05 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7WtoZ005529;
        Tue, 14 Dec 2021 08:47:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=/xwsJYSO7D74Tgx1cp1A6TvvzpXzx/zfZFIbNffZl/w=;
 b=x+iJZIxyqMEcvm73jWsJ1HFV4oDHYFvinagfK3d9nCq0xq7AWAnBEDUNAV0ttY0gW1hw
 b611AyIPXZGigbQqFAx+Cu6cpCb514buVfgHvxoFJib/0DPFcJc7icmQxoCQDjLuiUwk
 ANcpeYSFYOiJUqMIdWqrs7qjz5plomOh0mAGmKoFhNKBisI6fYceXXXec9z9xFuRKdsP
 GcG+qdylubwN3M682Igpw8saEhcIMPdxJhcN/DHjIkItrtQ9Ux6oLGYpUi4nnkP6scx+
 HS3Yp1oCofwR2c8aOMoMYsAimBUZyb5/1Djo6mXVaK0pv6osULSRMPtDjyvA8BSj7ih+ RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u2sqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8f6In107818;
        Tue, 14 Dec 2021 08:47:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 3cvnepkymp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqAHvTw6pvd2T61O6kpv4/dRf+vprkPSixYz9lXvJ3M8TMwwK/JSjf/YLY27CuMwXL9CM0nLfMwhVfvOQSK0nqD8mU8Wmq9lBkJ2O6qlXZpa7wc+UsaUQcB0TLuVw8oyhdIhysPJcElejJ+BwOlFd4cJd5opRwKJZkuZ7lwQkwzHHfbN6yg/8Pah2agiF96+eE6jCgWAmh0XONRvJcA38rmL66X8wWCAKOLyGl5YoHNceGSemn0AAWflf1kzZnOSVFRw6W9c7HUSti+dHWdPG5U4XNg3OB/4pzO+2mlmKF6C+ogCOEJahfKfy6+ow4KonZid5uZleG5Rn5Vqrsyx+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/xwsJYSO7D74Tgx1cp1A6TvvzpXzx/zfZFIbNffZl/w=;
 b=IV0Hau6qIp0udln8Py8M6KcfJKu2B6YDMfxWfzJZaN+TQGBTmWyvoal7UXnOg4EnK/1TkAWyDioaWXg2Vvw1bFtQNMSJyk4H0rLJeg7R7+QmnZIms+ChkxaEGN+sZXOEfquXdsZC/WkelWPDSigHTWdiUEF+TXUrxPc21vCafqMXwjLAhsz9G8UuBzn0rdL/AoxP/5KV8XSEEt+eSg0E1G2JwqhOxO4O4TmlNwtvLRW0Uks5KofBEujntDwkz749NSFS8QpBMuU69TS1GV7Gb7vodGoOvrkNovCZg6kYqGNSXOjYAvoHAKTIVvVR9WcliMSf2UUrYqsccKY1EsU1ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xwsJYSO7D74Tgx1cp1A6TvvzpXzx/zfZFIbNffZl/w=;
 b=NUU3PpAZokdRWYPzWJGiH6bwCaetZAOsHORHJsZrrysYaWPmFG1K5fsjXwoeWOTqMl5hUcKMkHsIrJRAtoU0J2/7RB8HVHWi4LMpSDMM/WB5suRUb7YN/qvNpBnDJNh3uTCbXYLM2ma0rWY7fiLklTfZx3gm41wQe74OFdxTSs0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:46:59 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:46:59 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 02/16] xfs: Introduce xfs_iext_max_nextents() helper
Date:   Tue, 14 Dec 2021 14:15:05 +0530
Message-Id: <20211214084519.759272-3-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: fcb8e8f7-e212-41ec-3d79-08d9bede4a7b
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3054856C42846C9FC11B8742F6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eQp8HBRKRk9Rkr+cLyvwyuwbkA9mqQRK/7O+6RyYGBG6LGm0cV53g3HjsATbQBLZ3lQw9IZ/4F4gaqIrfIBBSEhBfpyctywxoPFak6lrRJv3mjDjODiK2l7id8EtAAN3p7BscSTx6zKDQRTWVBD8d09s9+H78BQNpYHrUr5lh9O/wigEWiu25kB0+2EoAR78xz4bTpJ2TZHBBGnrr/fxEGiAxi1TB3hc1bPYSWa92oMX+pT+ol7zePfj/UzcOQDFWw2Z4KAlZB751P6LVlSQHPHqPuS/kqDzKevLdpYGcctU2vIn3XRLKzGrb/if0qMI7J3PJwQSSK0h1Q1JQSYOHJFC63a/mLLbKin9w44KXseRAJLEKYE674WicermALAj/vZEIglIjcy6T5Mcnzt0i9vI0Kev3a/tr8vnsL7b/MRJWyvefinlbdLVZ4iRKGJqSJY8lK9OgG/epO0s53L6tcXDNK1qXJyFC9wQsdGpBxXxLFx+fGQM6/UBWImJXLTF2PqAAj8RY7pkQxlkn4NDhOGuofwclFOD0ilILyUxut5wZnCTIwl62mtmVRfO+BnUbU4+whaVBMBTjDzsLp3fknCXLnoDln1nstqW4GRM5zcAXRWqvpLVc12Tr401fwg6W3WtYfPqg/jHUBQW+9vpUOJikMcLnkSSLBnfmWhJZKCOYlnV538Wj1P+8aCiJi0ry7U1wMHPXmm3sqSyuNu39g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(6666004)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LapVWZ3WDIRP+eA1cHQtMC3hSRaOHx3AnTW3441MTFcy/4X+01d5U9XMX4uE?=
 =?us-ascii?Q?KOC4N+TgttIItwhqNNzQdCSh/YK6ygHhSjZKXK9/zLaCvdNHtESA9ntmk+zo?=
 =?us-ascii?Q?+Z8vq0kKyW1R91gX6wB42NqRZPtSYa210jfvEfGGeK4MA7OPbdcWIf1sGCRA?=
 =?us-ascii?Q?hxcc69i+BbI6ZadiI+RkT2BS+0YXy2pO3+HMDe2gAup6wSlUzph0PRPpSyWI?=
 =?us-ascii?Q?Q76EGNzgxHG+TfKDr32GjUDB5JkLTWs3rp9mWczqvf3hlfdVaP1ZzLk/vUjz?=
 =?us-ascii?Q?Rp+h6zJSNwI3h0r0sd7YVm0aZmy0aDFZkRiqdV9Ud6kD/WJUZcmvy4QW5gwb?=
 =?us-ascii?Q?Z7TSYh4+aNrNBXtLbMeJezculKhYtmhac7gMaCbf/2R2rW3cJRGjan6Yb70O?=
 =?us-ascii?Q?iXW5C2cT1NdjP0bsCmG4MIFbpPFH2yTlUiNZqlYT3N5G85xcSnVj1GU4Jkxp?=
 =?us-ascii?Q?6c7G9qyVSVFJpKUiqj1ZVgCZFSIl7ISEgpX7ie+ZHN5RdAzNdyS+ypfupyLA?=
 =?us-ascii?Q?DhxXqSQaoWAX6ItLehoLuCRIaJr+eKwCwpEeWMlBnCOXwpju+CG7C+yxGXm/?=
 =?us-ascii?Q?40/+zY4PKvPGk2/J59HK4+RAAtUTN5wQ4bgiL5n5LrNsNrpxp4hsTBh87AbX?=
 =?us-ascii?Q?LGQiW8b6hsgNUGFfCMN24VikntXjm1yVHqKySeu2vudrIp2pa/JX6MKMCEWz?=
 =?us-ascii?Q?CacMWXhL8aLubDTJ23nfBGEBLXJyVmxuHI6cHISGJ4/k4qmefO6znxMraaSo?=
 =?us-ascii?Q?mIn6PI7Zb/xbQFNx5d/+McSRuNRj++wqdfcc+owFuV1cD119CaFr8QTaATVr?=
 =?us-ascii?Q?+hN//k2tbVfhjsleKNZG5y5ZwaxD9zrCulbS+sK1CJ7oa0eaaJY+5Kj1y0vS?=
 =?us-ascii?Q?SWtidqtg9w4zRcglQ1F1VBhjDJAJAq7Jv0fCdwZCEn1egwGQQG6KDhPGPwdx?=
 =?us-ascii?Q?WlEXWMN09LbORjgB1kyI4ZeQrbl7LRU9Jay/jokXnijRHHCsxL2p4aFytrZO?=
 =?us-ascii?Q?qyQjZjX4mIel7OqMUVtze6+7AEaFzFdngjD9N8HZ/nbDw8HIOfNDDUGkJFMa?=
 =?us-ascii?Q?aKZ0CiiN8iwZR4JWZO1HJx6gXH1IMR7x77tD7f+1xFQfxJ2KzKZTdMwM0aND?=
 =?us-ascii?Q?sipSjmaXS7nFrM5vUWfQQGNCQJtJRgrBzMRx8XNkbx+h2jBhkcy+YfBeegyc?=
 =?us-ascii?Q?j++dmg+2WOzimVxNbhv7Irql2CNFUwx6rBLAg8rVYH9Ks4Bdp72MxI30dyfL?=
 =?us-ascii?Q?dqmfgP7PHb9OinwdKl3/hE31m6xIo5meyMlxw6pRrUwO+sDtEtKT6fKVynkQ?=
 =?us-ascii?Q?nFYf/TbGA7B6ksZk2NvqDMlIg3kfVf/LvEwKrFDA6aTibn7Zyppel0kWwmVZ?=
 =?us-ascii?Q?kycn+ok90HE3AZIu5u7KR7VHNETGEPK9JVvWWWUoCcL5zn5jkWe+BrERzaWw?=
 =?us-ascii?Q?UDmxUaVafHm2EC0RYEyR7KVO4aQ1oWWLhEkDaheqcWfpI9li4ggL7Hkp2mEM?=
 =?us-ascii?Q?MqzcuQZnwH4ESEKnwNDGwRPz1UbSDf+XgdUYDyIgyCjD6HmHHd1OjfpxD0Ky?=
 =?us-ascii?Q?3zfKFHp53siwd/QJX3CCXu+U5cnYccIhUCr8qI7GiHR2J19z9TA+2OhhpC3C?=
 =?us-ascii?Q?teYMxuclQk0P8TZ5euaT5C8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb8e8f7-e212-41ec-3d79-08d9bede4a7b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:46:59.4708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5JGwU2xX3y8depFwfNc5AnyOG7iCZg1JXJmsfUQ3BvRoxx7H2jT3Qh8qR2buJLI6urktLgPF9xhnU7msbBUJJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: Vamo5UW5y2_slmvqx4bAP_bODMuaAwKE
X-Proofpoint-GUID: Vamo5UW5y2_slmvqx4bAP_bODMuaAwKE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iext_max_nextents() returns the maximum number of extents possible for one
of data, cow or attribute fork. This helper will be extended further in a
future commit when maximum extent counts associated with data/attribute forks
are increased.

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

