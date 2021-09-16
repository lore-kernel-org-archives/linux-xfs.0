Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A30C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AA6561185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbhIPKKV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14802 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236222AbhIPKKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:20 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xk7W012704;
        Thu, 16 Sep 2021 10:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=pGs2eno+xT9WHlLB6qsqeG1XzlmIhgDUvnTshm3syY8=;
 b=WbsYXl12yiao7H24uGew2qaqc5XA50Nr0yyZBmPY7T9AubUJHS0hLZ7UP02An5f1nTKi
 kzRz1Yda+MSkJMdrw9qQoKAxw1rvyDql0lOLe0uzsEW1UnEafes24xPHwAePz+4q/pX4
 kIOdSslDv5Y4U8wsijdFsvXS1vkfcYu0nX72/aKpQb9m69o08ezfL9cgvEmHS98HJXLQ
 SbdRs0g0QJ5jqhERMvoc8c1uLz056L0bBvAEo5y855lqvVqbuhYhgo08j9eKJu0/wwcR
 iKS7MhK04i/vO1aRL3vMEPaIBRrO1HVc8M5CVrNdJYPazXnLfX/IpDemtk09jXbz791c vg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=pGs2eno+xT9WHlLB6qsqeG1XzlmIhgDUvnTshm3syY8=;
 b=FNe5zX72tu/O4MWrGmCrkFSQXC0CJUeXXeiRCDkDzz7Ijfvl+Xz4y9O8MyKQwh5zVI4t
 tIJMHhhSy2Afmmxa8xuu7nild8U6O1bYLgWJf27Gs4CjPRUlLcHOvRb8rFLHXJ/Vwzj7
 QcJ3kLPSTfCutJ9GSIY54YIy6BA63ememv560HwjTXlc4i2z1MSEQ/YzyjhyMXcH3tYk
 swksJR4MavHk28HQXgdTRqjmFgwL+pz8/it9ohj5rey4E7nibmdHTtlyVw5JFtE2VdVZ
 uxF1RlUkeEmQHb43lEIFR/iEuaYV30uhgR1kvIJawgoMiv1z79f326GQ4dip2GuiNfuC HQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3s74hgqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:08:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6d4b160629;
        Thu, 16 Sep 2021 10:08:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3b0jgfv5pn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:08:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XjRZj49GS6xaMij2K/5L3NVzvzp7nJVPOQ6GXaBoPhk+93BoaW3cI7NQu0DjoZkroEMF2YRXvKSefvVF28KT2Ut8JZLV91uWzBbm9kLKh7BwTFWjqHI0Arqa9mcg7rbNGR7NvPxzPnTeqtVT8r6A9gGj0XBD9VFk/3rWpWR8ui6cAFOEfei5kaGmlkbHlXCxeZD6RjqLUt/IF4Uv/FppIjdfhU2DV3NEjGgNiczJh+C3T+xn6U55DvvF9eu+HlMHFtREIEDbcIQVjSuoCfV8io2gOhnqZ/sxw4+YsOasz7WgetW1DB5NECxt9ejgtOgKzXZQb516T36FjDTVXQ8ppw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pGs2eno+xT9WHlLB6qsqeG1XzlmIhgDUvnTshm3syY8=;
 b=BH5BPgKXPpYbxlzC/Y6r7eAps+MYkGMHauTplwePJF3p2ksoWg8tT7V0N1LUZE210aucozjRy4rqOY9gY5QwdePWo5ErlUZ+z5DT9ypuZ3CYLdcwWHVasj7WQKpEE/0nEHtao+09iY9G2sg3zruLaWid1u8N0uIRzSabtCFXrwf2WB09+A+1i8rtIXFjx0niCoVb5Gba5XQyPHK7g5TRyxRgpkyFLyf6fD1smXcSIsmYfDBqeD91BTttPX8+zT/6cjG9a8sLtKS4tNEI4lCUG6hxKZuKRqGGOVGmJ4ZreogKsgZHDm8I/p7KqfjD98cG8U5HNYmgwAdx8BGNQKLDzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGs2eno+xT9WHlLB6qsqeG1XzlmIhgDUvnTshm3syY8=;
 b=vFQjtx3f5Kra5rlZmf0Z9P9uMYsvivEVtuEZV6vZTLucz3TlzlzDxFMzVRoZillktnZck5LiriW59sJM+l3cGICXXcejYONe4FqqBuVAGplTqXQ1zPO41xRSAzI4rb47G3m6E/nGwXvox7PT3t5q/6/mwOhOmCNi6crKXF4Rm3U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:08:56 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:08:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 03/16] xfsprogs: Introduce xfs_iext_max_nextents() helper
Date:   Thu, 16 Sep 2021 15:38:09 +0530
Message-Id: <20210916100822.176306-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:08:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e6bbe4a-4608-4776-19d5-08d978f9fe92
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2878F6B936C119FFBD879171F6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ubsTQCVFFomX00FdsZKPpCRCunU4xEHSa8dKG/aBehChUgZyVN3EwjqLyeTsjwfzN3yKKOfgaBKsgL78Gev8+I7iLMNLVm8ral7YtUa0ihKmtM6QgVoYcs/sM0W/w0OCJqYZkp/46oHtiIB38Ves6CDkwxJtxhTBzzfzNqFkG/m9k4X646R5r/qecgD6IQ8agO8yTvEIybz/rLFUtploW+z/pSIAhWz+YAdAA3c07JWqKpkSCwCuKISfv9kjYMb04TexxDYSijRU7v1Zwml/DJI4o1P2AQLpECUwDQ8KGmRgPwIKqv3Jv99Ixg3Pm8/ExHwo+TJXbjkHrOKw4M+DX4ST48xft3sxUr8DYFML0l2YLgLOpfjO0kmzpVRaTB2Hmo4gQWMhS38YZgxpGv6E8CAIJD/KMqP2iKwyIQiFxxZ+2rGncIpIjltguXwizczML6xqFHmCHJsjEwyokkk6ucpyVeK94XY/Num2E/37lohbjcXYTB8o2sYQF+b/dt1hRbd/TWiB6KYpFQTXmZpRznJnrKQQnT9ei2Uyi8VC/WWYUu7P0zqPer3EtrOKN2u0n+J5NOKMv3Wq9SLfHILI1AFI8YhU9txZQVGRWsotSepUEnT/8g/UxHI+CzK+7hjU/8Yf5Ppu/C5RLx5vg3VfnH3Nh3lefeI0TmSiHHfRjZuYMykLu3pdKjPwHNmZnzYMk7D1u6ScOoZntGft46mafg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WryCMaZ3B74pn3NQYsAvvN5YWilSnixjIOSvPwB4jtjaQTbIPhU436r4s9vk?=
 =?us-ascii?Q?vhGefGiNbDhBU4+P+tezntFbFAPAsM0IIReoIinyUTBDURPdBn/MPWvLS4A9?=
 =?us-ascii?Q?qtMxSbln41+JctRoRsa2/OS6gTHAqyGNi2z2k4yThb9MwJPVVTCnzfPpdh0p?=
 =?us-ascii?Q?vTvBgezIv79r8JFk2RfRlEaCHeLN8v6UL8yTLiHMjspvbnqDJo6KgcjtCE5j?=
 =?us-ascii?Q?I806WhMpZlJsM0Q6MIB9QU7P8j00TVImf776dwuXs8c849wL+O1eFQK2+JLT?=
 =?us-ascii?Q?GXBz8CmV9qsqY0MN+HYivVOl1tJ+v7pR3LOIfupdNo/qMlbY1lRJlV7U0WAn?=
 =?us-ascii?Q?w5EfnAK5GUQyboHHzLqe7GeMRBGvHwM/t/NzsH4Kj/j5Zcha6BodiUirSsAR?=
 =?us-ascii?Q?r8sGq9WMl08BhJ7vT6sTSPJ4zo9I5Pk9TRmgNnn9m8DVjI66UC2X6DcFBtKl?=
 =?us-ascii?Q?XJI44F5iBFdZHjYLI3udEOv/aI+DJrzvHBPGQLuVxeo0mXQAui/2NVgrp28X?=
 =?us-ascii?Q?hjHlna3lHEX1h/fsZWNutAwky7GdStGQBuVRs7E4aCu4GMJiB2GxnqdtOEDm?=
 =?us-ascii?Q?GmP3wq9WVSEion6E9O0cmKp+W5oBV363bI5ejGdBRXAAg+//DnGSDrspHReR?=
 =?us-ascii?Q?Yrp7blhxQnuAvv/KMZK0BKLihhdClB0rKptR/sYSfPqejfyKXkKu7+WzyuXu?=
 =?us-ascii?Q?r6qvGAF8w6M3VkZFq4Cx7ZXOzm/fyw42FeHw2Ft63hahD4UYfpI4bl6j+PZj?=
 =?us-ascii?Q?fkE4I1I6A8Zfhkso4LfI81y0E6L3ixAYgwl3eoDDVSmMFlZdDYlmUc9pBzKM?=
 =?us-ascii?Q?nhJiEZQ6qC0u672mWBmaM1L8hIhxA84KRgesh/2Z2uiT1aq00jS+dlHisiln?=
 =?us-ascii?Q?Y6zKEJiDjkqpJGEs+5xXptBs7+aHNIuqnI8m3g1K0Q/FLNO6lvhrF7Pwg+Dy?=
 =?us-ascii?Q?2ZUBUDeJnRQ78hFrHteDpTpRC4eyG/A9WqXXQx/my4+76fqmoVqLT99zZfU6?=
 =?us-ascii?Q?Z3YWWL0MkK1/jOb4D8yEW2Ax/hUR9JQqJwc+rTu/iJk0vzW/7ZaloIJW6swx?=
 =?us-ascii?Q?1zpseRGSnq7rz8dggTpUhsJK9PMcz4daIKFeiZOQITg+r+g905yX/DRnNAt0?=
 =?us-ascii?Q?xDk3WYSRvBxpCcJ0KUWEe+TIARKe+HVYGNcvzDRTwmC5XdjELnphXgagAFU9?=
 =?us-ascii?Q?h02ggL1feIkQkVJek/4mWv0V63LAZ/lkV2dY3+HF2yuij/9y2l5BSfpqeGT6?=
 =?us-ascii?Q?FBt3AMzIydm0Ad9Yw99BCR+Gb52Xb/Nyz+BbT2YduzCbpfdXq67e4SRRVM0O?=
 =?us-ascii?Q?bc5GXZJTWCg3SxoYYOpXW/IC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6bbe4a-4608-4776-19d5-08d978f9fe92
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:08:56.6188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rC6DUcv2mcBb609gSuD24aocw8w2zqD4RyD1hNJYBD4fug5m2Rv9CkWep7+pqhX3PCbCArZwGde4dQYyyzVqXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: w_zC8AQSkZroaWPYn16eHLaqlNJhmp_u
X-Proofpoint-GUID: w_zC8AQSkZroaWPYn16eHLaqlNJhmp_u
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
 libxfs/xfs_inode_fork.c | 5 +++--
 libxfs/xfs_inode_fork.h | 9 +++++++++
 repair/dinode.c         | 7 ++++---
 5 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c8932f17..cb34c768 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -69,13 +69,12 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	if (whichfork == XFS_DATA_FORK) {
-		maxleafents = MAXEXTNUM;
+	maxleafents = xfs_iext_max_nextents(mp, whichfork);
+	if (whichfork == XFS_DATA_FORK)
 		sz = xfs_bmdr_space_calc(MINDBTPTRS);
-	} else {
-		maxleafents = MAXAEXTNUM;
+	else
 		sz = xfs_bmdr_space_calc(MINABTPTRS);
-	}
+
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 59e9a814..fb271ef1 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -340,6 +340,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -361,12 +362,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (whichfork == XFS_ATTR_FORK) {
-			if (di_nextents > MAXAEXTNUM)
-				return __this_address;
-		} else if (di_nextents > MAXEXTNUM) {
+		max_extents = xfs_iext_max_nextents(mp, whichfork);
+		if (di_nextents > max_extents)
 			return __this_address;
-		}
 		break;
 	default:
 		return __this_address;
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index e3979cee..c943aeb2 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -727,6 +727,7 @@ xfs_iext_count_may_overflow(
 	int			whichfork,
 	int			nr_to_add)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	uint64_t		max_exts;
 	uint64_t		nr_exts;
@@ -734,9 +735,9 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+	max_exts = xfs_iext_max_nextents(mp, whichfork);
 
-	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
 
 	nr_exts = ifp->if_nextents + nr_to_add;
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index cf82be26..6ba38c15 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -133,6 +133,15 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
+static inline xfs_extnum_t xfs_iext_max_nextents(struct xfs_mount *mp,
+		int whichfork)
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
index 0ffb3e6e..7b472a54 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1808,6 +1808,7 @@ _("bad attr fork offset %d in inode %" PRIu64 ", max=%zu\n"),
  */
 static int
 process_inode_blocks_and_extents(
+	struct xfs_mount *mp,
 	xfs_dinode_t	*dino,
 	xfs_rfsblock_t	nblocks,
 	uint64_t	nextents,
@@ -1831,7 +1832,7 @@ _("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (nextents > MAXEXTNUM)  {
+	if (nextents > xfs_iext_max_nextents(mp, XFS_DATA_FORK)) {
 		do_warn(
 _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
@@ -1854,7 +1855,7 @@ _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (anextents > MAXAEXTNUM)  {
+	if (anextents > xfs_iext_max_nextents(mp, XFS_ATTR_FORK))  {
 		do_warn(
 _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
@@ -2969,7 +2970,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	/*
 	 * correct space counters if required
 	 */
-	if (process_inode_blocks_and_extents(dino, totblocks + atotblocks,
+	if (process_inode_blocks_and_extents(mp, dino, totblocks + atotblocks,
 			nextents, anextents, lino, dirty) != 0)
 		goto clear_bad_out;
 
-- 
2.30.2

