Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B296DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbiBXNDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiBXNDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758761B0BE4
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:02:46 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYEEL007287;
        Thu, 24 Feb 2022 13:02:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=tiQXeV/AGmvj81nE4g7YeVFELsqsjeSUFa0dvyNV+ic=;
 b=W0JmG7ozeBdfagTzJdEzo+jgl2TtRsodQYiHX2tSD3FCmW3zIUjzyE6HxD5DBsWE2zJl
 c7OMqzVQvkHsr998AVtWbyh0rSKWnNCD/KCwESnCEf5acA7F36m+quqrYxPyyvPT9CgH
 5eDBe2QEz8I43lcAbmtRvYqd5KyunGtcEX5Icw4lvX3ImwsH/ZaGGKJTxX3I1iqDiKXQ
 hlewuS0qvXLD1cSGXuHImPHxdrFID8a5zYFSDUftJZv1bBUTgYvvfs8EFzq95AuxzHWo
 HT8H6eO7znMAXlQ5zS7J8J4gljZ8ByN7ilF+Yg4TUwAeQzXe7KUaJB36RJBSvphd+gmJ Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx7b27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0vTN169758;
        Thu, 24 Feb 2022 13:02:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3020.oracle.com with ESMTP id 3eat0qs2nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDFhXUd37ZLCp6iy+UycZ+MHlP878VoN7YOLulHzKa3NlJLEjfoEn2iA9E5n1a8jABAO/pILoSJzXph2hwO5gvp1zxra/vZopTbkkrrq5qWU0bc0SaWGGfjTw+86UwfFmhpQ+IW20DGZQeZFpKtWuQAix5EhVpsNY/6dRvjgeYYuD+syifiW9Tv6Ag/CDYyRz88riQGCqu4Jp67uw5zJ0x50sIsE5e0sH07Lmzt0H2E9p7fA2oaEEFVILuVTdmmeHN7ntLZ0J8t3PVC1rD9Od7JhfJEaGZI2DcHU1m9nX5IiycH9XBnpu5BEqmTTckvBqsIlKJF5xwnwPnm5SQLeZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiQXeV/AGmvj81nE4g7YeVFELsqsjeSUFa0dvyNV+ic=;
 b=lrGYsFO6FCR0cmhTpame8gY5BhA1y98bSX682BNK9yDFlz9j2eUdGaJG+Z3Mg3LM4QJLEGOozjWTLRsbMwlZbAQo3n2s4PsRACARzu5gVt1j8qVtSZzzZQVmB3+fvvGJy6r3So5J2R6SLCkGTmQOgzaAC79BBMMfuBpuAAV3p4d+AjXTj65bYeE0chdGjgwFMCCAtEj23v9vw36K3AatBi0NJrsmoPQ0l1S6rd0Vmp/U20N23lcbEcDVF2VGtJ3SQeNogQ1bvTtgJFljEzvLhTCf5Pnx/8sEDNdIYeIt8PpEg8VKtZshE6ibawTJLtIeeuiHu3JOJH3RMyn88POjeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiQXeV/AGmvj81nE4g7YeVFELsqsjeSUFa0dvyNV+ic=;
 b=GrbtbghZEBqVd9bNEiPFfdLgpcnR/LV9yaitiKmcnH6TPGHKMmTiuEQObtTdP8p91ucs2FcSVQS9cKf2w6wizbVpqB/F/z0DdeqYfWPdV0EpQh4DWbZvvb/n4wXr1Hk07p0BE+ZVJK0zQAv0oJWyeTxEbCPDc1GZuLhCkHU8PJs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3665.namprd10.prod.outlook.com (2603:10b6:408:ba::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:02:39 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:02:39 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 02/17] xfs: Introduce xfs_iext_max_nextents() helper
Date:   Thu, 24 Feb 2022 18:31:56 +0530
Message-Id: <20220224130211.1346088-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88acc5a0-d3e8-4ca7-87d3-08d9f795ef56
X-MS-TrafficTypeDiagnostic: BN8PR10MB3665:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3665C1CBF6F1DB8261079288F63D9@BN8PR10MB3665.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EB2tZoDML00KCTb+o60pB+VJPaQwgbRjt2J0v8TZVIBM/OEB2aGrx+EbuHg/FLljCx56yr6jjAzXjjKm+3CBxIofQLh8ALOCr97b8UrG7zLqSNCTssl3YzBO0C0b0YIixG+IXHKGJEXLCl+ZT3PCyfFx2bEmdxAimLMknkxQ4CI/wpPIdlnFKxyxppuXJZvxHb1OnS/r5hXahTBiy4tj+qDV6UBm8P6JVgWn+quV8h9kJ5evrvMlf80lmSnqwBSz58AtkBaILVVa61Abg8bKrGwBR3+3sOZ3t02awcxRGf2E38U8NBxCmT+HQqvMFHqrEzAQnPmNKD2A8eXD/KhujzaA4LE3m0GHOEmx/xjDG9aq+iJxyc0f9IoCqoF/ukjesQRGIHV1gBuiFsDmPO880rgm7amfiszWBtb38MgC0D7vt9ABNGBKkIWsDib3UV0MZ6IYLH6BYVjdgFuXEvBp+Vun5aQI53se91vZCnSzAC6zTst4+T+4US5RMPA0tE4bYgD+OctPJD4oPCVY44gsPLr3IxE/Dd7BTUoEtSpcfwVAhCxemitXYyTR2X5SjWUzor6I3pUoFkFBGYc1qysjIHFB5nwK9YmLgnY9U7qwjd6SPRwOqekVwJF3lwDwZln02uljmphpZKoZsSmzqLZPfy/qKe5D3zu2i+MZOQRmPOaBzyt1tUNJwaasbKZ1hwOgF5mk49IJ7dRWNm7hnwAEzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(8676002)(316002)(6486002)(52116002)(508600001)(6666004)(2906002)(8936002)(66946007)(66556008)(66476007)(6506007)(5660300002)(4326008)(83380400001)(1076003)(36756003)(38100700002)(38350700002)(186003)(86362001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?asCduiBuWmlejHYW/ECCRr6k8O+iO1rWjBy44ayGv2P886F2AvSmKhqYIpH8?=
 =?us-ascii?Q?SdbCqiD//6AEcah1pWX6SY2pyD/36yfwNJ/keqctyxdcjH6wdLN6UX7kR0fE?=
 =?us-ascii?Q?3ynDh8LSsnUtwGnkOY/6IhLbBpW+SliwRNXv5G4MoQSrSk3KVhezD8MehQXh?=
 =?us-ascii?Q?YPex+WH85i28rV/VTvVWjO4ThlXagJQ4vgNzIGRnLjyBM3WewCmKWK4Szu2O?=
 =?us-ascii?Q?7fBDwERTGzTLhFrEQP3qTWspzQznw8qMf7GI+LjhDAOkRXP32Q6l7NTo3j25?=
 =?us-ascii?Q?SV1b/I9djYnbnN/I0Oua4pT2eNTPw2jVN3M1JpAiBXSZWVMfQpzidLZCyioC?=
 =?us-ascii?Q?TBYTKk+W+skFYphLMGDEcCFH9FmepUdy7SZf2iCVwaLh4p3jnLCIzglo0SBS?=
 =?us-ascii?Q?Tg56WoHdb2KWOm8AKphvXZbyiLGRziZomBOHUF1YzYXuA+/FER502W2Bb17J?=
 =?us-ascii?Q?HyqFI4hT5zzU6TQwihLeBm0DTNGrHM/vyIDclLKJChlxTGALq/GLUnajInbh?=
 =?us-ascii?Q?TXrytzi9uGndXZUYfcDhVh6J/U0YX7VzVyuh9QL8JsHLFfv+rofzyB7+rZ3A?=
 =?us-ascii?Q?L/fgal1sF18r0G/KZ7MJIYP9o0I8loiq9PnmnBs22+blgKEiMWXmYP8KnKHP?=
 =?us-ascii?Q?vjdbIGv4uvo2pBIuT3YrTdH+azOeKhnQSWzluiZ2b5JQXt3+ilqvEeg5Ek+h?=
 =?us-ascii?Q?9fv6m9hZwD3zUxZfkg9ALfLn657IcnuAAQHWYEQdAFqbD2xDbiCUfpwohwxH?=
 =?us-ascii?Q?tZCaKw9zc9j1ceR/0DtImK7I7+7ZL9W1Y1VMvmk5JoUHlOFAUoy/lYQJKKw2?=
 =?us-ascii?Q?pCceKbtQzhAObYXWeFODEStlZ0lw+lZzcP6IUp975HWkNxijfKj9UX2vJ9u9?=
 =?us-ascii?Q?P2qdRpLqetqKPq8v9lSUE5OBGmNU0hEfTZsWZq8thVRsVKzEaJ+QLgwljP3R?=
 =?us-ascii?Q?W6u38md9UZWiLy5oq4k7XejdVoCHAZbQoNDrqJ44STYP8tNSX4CmyBze8Jfv?=
 =?us-ascii?Q?dRLRwnmCp/DtSJQaRIzP5ff5VM01uD7CA4dcgbri7gMT5JGp+Jqna8mhvfRr?=
 =?us-ascii?Q?TmN9vgyzQ2k3KOci8EzHBzbVDZNuP1NpTAQePAfJ+3Lyy33Xs9w8NiT7G9zM?=
 =?us-ascii?Q?W/5KBj46pGXJPJGIVNS7DEf4Kp/mrWONfdzhXlZiZY39gtAb5UWGFO9wguZ6?=
 =?us-ascii?Q?7kpbeh1s/tp29mB6yzo5bg0ZHY6cNrgziYl00bD3FFlvMGkC/fT/FnvDbUeK?=
 =?us-ascii?Q?lwYYbdhsSQWrVxv9fneg6KCQge/nc91Ai/EYJgVHpOYp8RLG3iRZLI0dzpyE?=
 =?us-ascii?Q?FSkniubGT0OAXhvga/GO5g01ppQgt1I6QSCKcaJWDy2O1NKCo8hRyVbxV7ov?=
 =?us-ascii?Q?wpnJJmT+W3ZXAhHfJQ4DDbHAhETZhFigC9g6pJQO0Mm+1Mp/At7wryzcJiYm?=
 =?us-ascii?Q?7MnLfpEEmdvAe/WBEshCi9kuXlxH6vBl5/d5Ps6DZqsPUy4jHvYXSh3pUxzn?=
 =?us-ascii?Q?7mAl42ZCWEqCncqtVyecdYty8+OVNC5pEPIW1OrcPRjyPea3OX8SAuMaizSl?=
 =?us-ascii?Q?+f9p9cO+Z6sZGAUSsG1R8LxWEuUdqsExPG38t+2POrjpNcBSq1bFXXc7u0ym?=
 =?us-ascii?Q?e5J7MtRBLAI9zdZTFV7wGls=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88acc5a0-d3e8-4ca7-87d3-08d9f795ef56
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:02:38.9904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omBQWO0NuiN6YXe31KSX1pMY1byqwojgmjY5hgSKrxTZiWt6xGDRZxo/Y9F+o8ctfUvpVvvgan82G8m1WoXZGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: I28eVM4fZpC4AnJEhA5iTXtD_d4pPiGe
X-Proofpoint-GUID: I28eVM4fZpC4AnJEhA5iTXtD_d4pPiGe
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
index 74198dd82b03..703ab9a84530 100644
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

