Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8A2C6FA83
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiILN22 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiILN21 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:28:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80483303FF
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:28:26 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEDPJ020711;
        Mon, 12 Sep 2022 13:28:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=boO7476nGASw6PzfN/bGFNQ0PIE/yWiCllMQ6xCvedA=;
 b=GOv5gMVSRUr0x4h0hTajod17JSO+SNQ/M8npeVTzU10zEm1T5ZSwEMPcevrOzq5GbB01
 Fh9Jt6sqsWrS3iVZh92wMTCru5yuoMLz7u5HJxy+psxN7+7IE2rN7kvXWm/x4DP1Ssjx
 OJW4FK7IWUA8FojifIWO1me/dskuCohSKmq8PT5GKg5kJUDFc0JcdkxW1T8vQd+M/MP5
 KFUmjPfee8g8BoJ0/fUJtx59VTAmYt71/hIduj2sGMeO/6T7ENOT6s0/l/7vV9+2grhj
 Rs435SvjrR15uU5MAHpw7jtLFwzDGn5zSlFIAkN7Y/1CXzEKcW6BiW/zqxj5A+M5Lkra XQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgj6skf7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEgGD020370;
        Mon, 12 Sep 2022 13:28:21 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgj5b146t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UV+iI0Ryq7hbhgHOrkEU3fPsb19eE9yHgPzSdfKym7HM5Wyc/+NOdF5NfIDPyR6ALFRD1bmmLATONWueCBp83/UTAxCPvSvMCBJa/yDdpIE4MAqtc6UY5SPNPQ/e5GlVw9Dwp5Act/ENqIgK+jEwbSkBeDhynzjezQ+mWch7lw206yG0u53hc36JlDsh5qD5HqTm4EOSsTXgkVM9/4ygVOCmIXw7diPLC+deNPmERuruB7GKQhWNoPE4GUXDyjhahvi3bthQlRwHQi03d4Ymg/GftSBTDwIyAMeocJMsfo+9Pe6BQykNx92FwiOlSnh0EMrSCgWJxoudL2vA0/0f+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=boO7476nGASw6PzfN/bGFNQ0PIE/yWiCllMQ6xCvedA=;
 b=T/zVTIteVL8TcmY14yR72NIYHzuCFn78KRQuRcFWh/TG2mpLSe4AMgjyMhwqkB5Xry2KL7+1Ip5lmbT6FqaF0xKo7V/ae/XIK3VVsGO1rdTC/ac6jGGPskLQ842vK1Agyh3FQ8r8QBBjhuLzoseGmu6vFAp+Lp9+4WzKbknV/spmGBLXj1+USVMQXiYB9yc6Ij/W1dkSDfLRbLic2ulcA0dxwQu/gOXKCWU5VHHLN5GoKiLc7LgVBVEeMNXdooE298boD/4qejps2PWOT9I9Xtf+o6yv+PFfeDBQuA8kbahEel0w/nTmH9WaZoI8U8moruAKK34nO3K1rVtQN93QYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boO7476nGASw6PzfN/bGFNQ0PIE/yWiCllMQ6xCvedA=;
 b=BE8UrXkQ0jtXtu4DPJkdpuyZIe4eOWPosjz4nFRvm5zO0vNlsC+6Udaq34NLHuZqEpIENqECd88OvbcG5l+ao92QHzFuBbji2A7wsskIRnMDLE3/4pcRfGVJh1BXlBDYAutC/dghzmaNymfPxxu+gM2Tx7eJfXiZHAYnM/93AhE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5888.namprd10.prod.outlook.com (2603:10b6:806:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 13:28:20 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:28:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 04/18] xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
Date:   Mon, 12 Sep 2022 18:57:28 +0530
Message-Id: <20220912132742.1793276-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0099.apcprd02.prod.outlook.com
 (2603:1096:4:92::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b25ee75-4336-4f0d-42eb-08da94c2a899
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n/Skpe9dbQhwJ/peu+JB9gXqGEdg4OBcAbYbCWr29kRA3zX12+PHJrvqNLxvpPb2+eWj7iDWo3Lxk93pvxiFp6psCbuAc9Mxtv4xh4yAhkT/tMxK870CgFef8G1f4m2lSMHGmA307ijQPPA/3PGve1zw7xMtWL5J1w44V86mVprReZ4AQfQh//fdOZQFIbJ9JWFPxnR0ieT0P+CSJxzpl7j2QGaTdGgkYf5pnPPojX5yTQQy1eBtbPD7Q7YcCqzoJ7/vGd7reJ9o6I423Lxfvv8wWMAMTXCw/68DXB4SWJzhlG6+sRxwgntpmnCZkTZ3DRVmsZnfN7f/hX/1kU1QBCPOk88fekzyt2ywYGhlslrG+aG9nFhJ/xf5sI8j/NnV6z/PRUCzwl+frABUbuBp476h5UlVJF4yaN16v/c1LHmyvBw1jfZIVG5qbHnoOWGKQeXNu2bJiH4UMbpg5Kefmddkc7cmnCNNBnh6D9ddDoOehCk1BMOp0O6Us/wQLyZSuFHzEmQ+57zNuFD4rvvxL0Ld/7K0PNUxYo4bLrptOrT9Z140C6VjzuCojGlLlMYu09C28Df50pKlS9OM3PfIOlXIUwxVkA+f2B6lUUpTmMrLVze9B3SZj6V2xVgTUBKYeq/P1ZZbdgfqoIQnz3nbC1ZRxG9k6CoZrz1Wwwso/mkcOdY1EW9d8El2SnbM44BrlsJF6+9XS1KcqkfEeROG+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(136003)(39860400002)(6486002)(36756003)(316002)(8936002)(6916009)(6506007)(83380400001)(478600001)(41300700001)(186003)(2906002)(1076003)(2616005)(38100700002)(66556008)(26005)(6512007)(66476007)(8676002)(4326008)(66946007)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UU5dJz0nWRvNuMsXEgnHEon4wMpWTyTa3GYmhGUgp/Sxe5lzvVT+JrGKA2qv?=
 =?us-ascii?Q?G+gTM3gmv3b+SW//q7LKnlt6ZSkvjxeLAKTQHN8WVLs5zwskaw3ndECkbmXx?=
 =?us-ascii?Q?KJGZAGtQ+HLVq624ZOspfg/fSIDJntEwBoeVwBoBdcQtyOflLQB7nYPqnBiv?=
 =?us-ascii?Q?vKNIRiI95fWZEXmo2jAwtrJTEgmA5xsOPY5s8bNg91xb7oykfxUnWmTRW90n?=
 =?us-ascii?Q?zkFHVKbxuBj80ucYte1mXy7keaV4k9W88u4qHtAK6uJAPcJdnMCQUL1IuAgL?=
 =?us-ascii?Q?dH7VG8sXaloZNusD+lvthF81/toY40t4nPkfUgeU69DqCWagfbNeOpfC6842?=
 =?us-ascii?Q?rB7ezIvBBJ3fZXTnAmxrNMwhRVTdl51IPNhlSd8DLiCPPUd/YXzcjStcdBge?=
 =?us-ascii?Q?w5MypT1beb53SeqQ88TRCrngFpyoNs+5QBN8kYqo2FtS64c5ok8fYrHiGv/B?=
 =?us-ascii?Q?XRv5ueukbPbXgTDhhUVu5E7psGfogBZVczwwKTGN3Gj4LCcuWL20gztgfMw1?=
 =?us-ascii?Q?p3m6SY8zy+QjKcqeopULZ5cbDD4AtC6zOxAS5KQI73ckAHUNjMbqp9kjqd/X?=
 =?us-ascii?Q?OcZ5v9+zGlQohdq11b1aisB5wH9RaT30+Rr07IX/Lt9h3AveZ0OkXD73dXmW?=
 =?us-ascii?Q?jlY6RCdrJqQ9ZXXyvA5iL5kqRt27QNr2yJCEy/Up7ma0FYIOOoq1YxU7tjul?=
 =?us-ascii?Q?YqBfojf5ntBmVvy5OFd58eRSJ/iOxmQNWDlG+0uQh6nZ9jLiTAqI+pM59+kF?=
 =?us-ascii?Q?UyxHnKitVpGjpiwob7BVdXri67/OvoOMH5zXUeHOi3sxO9/+Lks5U1kmtACx?=
 =?us-ascii?Q?BLPbd9XWrKnmlSiXxOnSbmd/r25ywj/T9ubFK8KyWdg8SqMeNBkcmjaVWw+C?=
 =?us-ascii?Q?Nl85bJuTN06ejZl68YH8Z5d19oG5URg4Y8W9l7OAR8GqhM3xmnLhZ40DmeZz?=
 =?us-ascii?Q?fIkowxTOO/cI9i0re1CIEvtVahcqEQk//lE8uucaKACNjY+H80g6WA1wN+7u?=
 =?us-ascii?Q?bp6YzmJ8izn+SbB+p4gGm+/NIZbYVXYCl7n9XXbW7aIzpJw+f8jePWNeQXHd?=
 =?us-ascii?Q?SX+P/8HUc7a4Q86VFpdTRaJ7C6N+NFnouu5uh8YkSYuvfo0+qJpAchbKpUKY?=
 =?us-ascii?Q?9pusHMA1K5XeQjHeze0yTrUkcsArikPCQjtZwkfcCpmpHK52TsTgJByAuaBl?=
 =?us-ascii?Q?A1HlGqjKO9rPwVZyH6yybW6PKZy56AnGu8hp7z+GHcibaN65zkDWQeDtDwKm?=
 =?us-ascii?Q?YcwJIYsQV2B9nHY3B05kRGwPUro14JYStHZbW5MkRUyUYDm5XBlHdrmGlYOM?=
 =?us-ascii?Q?NHRbnahAnnWbYUUzkF5pblm/Kgym2/AQ7M5N08fBlDs1yD5hP+kyBK7WYpGh?=
 =?us-ascii?Q?/gvUj4W6ZE2sCfZIEzBVEE356e4fiZZd30O5S/zHJCOLBoTkhvDea0mmZzrq?=
 =?us-ascii?Q?fvLCaQW9FIeikP9ijM463bUJ7jQTF8/hWuK7DY3gCIywJ0zpGm3Y0t1BtiEM?=
 =?us-ascii?Q?awSDqFnhRiJvDuIyGTl6p/bItxxe5uu+WnezJDPwbZTRpxtbAgX/nb9iLn79?=
 =?us-ascii?Q?78Y/XjYu1+Wj9AhQebKmSeFoLTpEkhoDMyfW258bLA4ocTkt3eIbck5CI5WL?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b25ee75-4336-4f0d-42eb-08da94c2a899
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:28:20.2341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KE7/1GBYuAghEryl4jlaYluZhJ4BSw2GD+wUGJdL6BAQZ+lFVtAtbc4yKc2Fr4WJ2EfFkDf+n/GmO5CK4khWsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_09,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-GUID: SQ7gW4y_zF8WmUrty9otmoDLSi1GvMtX
X-Proofpoint-ORIG-GUID: SQ7gW4y_zF8WmUrty9otmoDLSi1GvMtX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit c2414ad6e66ab96b867309454498f7fb29b7e855 upstream.

There are a few places where we return -EIO instead of -EFSCORRUPTED
when we find corrupt metadata.  Fix those places.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c   | 6 +++---
 fs/xfs/xfs_attr_inactive.c | 6 +++---
 fs/xfs/xfs_dquot.c         | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c114d24be619..de4e71725b2c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1374,7 +1374,7 @@ xfs_bmap_last_before(
 	case XFS_DINODE_FMT_EXTENTS:
 		break;
 	default:
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
@@ -1475,7 +1475,7 @@ xfs_bmap_last_offset(
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-	       return -EIO;
+		return -EFSCORRUPTED;
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
 	if (error || is_empty)
@@ -5872,7 +5872,7 @@ xfs_bmap_insert_extents(
 				del_cursor);
 
 	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
-		error = -EIO;
+		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index a640a285cc52..f83f11d929e4 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -209,7 +209,7 @@ xfs_attr3_node_inactive(
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	node = bp->b_addr;
@@ -258,7 +258,7 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			xfs_trans_brelse(*trans, child_bp);
 			break;
 		}
@@ -341,7 +341,7 @@ xfs_attr3_root_inactive(
 		error = xfs_attr3_leaf_inactive(trans, dp, bp);
 		break;
 	default:
-		error = -EIO;
+		error = -EFSCORRUPTED;
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 3cbf248af51f..aa5084180270 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1125,7 +1125,7 @@ xfs_qm_dqflush(
 		xfs_buf_relse(bp);
 		xfs_dqfunlock(dqp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/* This is the only portion of data that needs to persist */
-- 
2.35.1

