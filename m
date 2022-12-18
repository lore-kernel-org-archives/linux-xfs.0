Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC02C10F1E
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiLRKDk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiLRKDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889CA65ED
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:35 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BIA11Yl012981
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=4tiIiFg2GkzN4wyQ3W7YSGo1tSeK6JVT5I3pzAPY87M=;
 b=pQIjhcCDgG+nui2pFd6NmELyNowROJGRom0AlrgMh4aP6+z951lnEP86EnnkSVcBm+sm
 mVgdFFCfELpVJnF1VXaA/kLjXaMX9OnNwi2070gSDbT0JI9dLwMoHr0OYbyBsRhznHug
 W2G9ziuwikQ+os35LRtDZ7SA1XzDucyVSXjeSFMceEeha7jbURs2S4h651Mzubv61MG1
 nH0ZHU52I/yMpN/s8pdvdzJLSdMEr4Rerlk0k5X61PbzJSqdPm9Xhlvy5JZbvCRoPgVS
 90wqzdO0X3qcycndAr24FyYgM+2RZcPVRx/edknJwtLkdki1LA/gSevM338H+vVF1zAd DA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tp1917-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8VBBB024761
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478mxp2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VYL6/fAM1Mb3J8UkDwlDFjUO5eZeL5m+pzugLVnFrkI+Tuf7QV9idMib3wq9ZGxLPUzmlii+D9CqlQL31/wCQIftre2ZviL8lYsD9hM5g297AJXT7ywr+vNgEWqSUxQ1x2HE51NsS9u3PTSoMg/KPokOyfWf4XEtY4TjRlSZWOWrdr2vjPHfDEjBb/E1eMV8rhIgLBFMOWHo8RV7mHO+tU+IqNKlKZ9L5D2V2p/DsbobgMfpdYY5bQez/eoOwkW2+oHoC6JrQDh/5+us2k6DmRnDGxPsVSdpapKC9WJffaeVYDPYnidPv04Zu5H8o9jw8U3qbC97wfFsQ1r+U1uTkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tiIiFg2GkzN4wyQ3W7YSGo1tSeK6JVT5I3pzAPY87M=;
 b=hV79hxRNnaRGEZxA4DFVho2BE852e+nx9Fx/oXyHLdsdDkNr/F3Q117JGyjwm8ByO/x25NTo2p8YClyW0Gp4JIY5VsNp5pmFaoZY7LStDbPucKM2hmDjqchN4YijyJc0KpYxiGf2nzqXedtcjHo5wCKHRI+ASngCgcU33gXyIYoN8zYwm1ewCUUPXvlT+/yrgic/Hv4ZWsqT4NLl/a/bme2tKxjU9gKQrg9wU9PCQG9ffwDwVIcyF492BjKzkArC1ozaoHhmVmN5kuusLsyLjcg9cuZuaMf8Q0q/PvndekTt5/nEKGrtyS0dRyQ5awOCIr7cK3MpUmu7WwQGKa0nBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tiIiFg2GkzN4wyQ3W7YSGo1tSeK6JVT5I3pzAPY87M=;
 b=TuXL6eXe22tmdLKwRcdmTdVo98oG7idXkBLCYJ4KrJnLp/M/DQJ+5x/tGcDAyukBGcKkP0/ZWUUrPWYPgQFP0VufhT4pCG7/PmQis2iROFR5wnb6mXu7/ON7m2Hy5G+QS4PPLE8oQnP6hs3Qfy0QSwNX8U4DzaNSvkdU0hFXb70=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:32 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 16/27] xfs: add parent attributes to link
Date:   Sun, 18 Dec 2022 03:02:55 -0700
Message-Id: <20221218100306.76408-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:a03:255::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 840b76f6-de0f-44dc-94be-08dae0df1ec5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: naF8MsxbB3FgN6thzi1IhRTjAZxXZieI/shFCV4Qy+O31fvfbtq9+p5PIPcPsp6ej55V9uwbnKQl7JDEbQsfwl+Q910KwI0LQfpdnD3X6Rs9Laz1pjOs6tM3pnTmCIKBB4KdXU3MJBCW/kB+Ujjjh65N94gLrRvRS27YwTYd5CINnI/6swvYWGWYCIgHgSrB6Xh7UZMKNhBAa1G1SkPrwOCAir4ZjYK8VRlv4aYL21kZ1XWKvb6DLwzjcp5AmB2R7s555C9QZ92P+DBVO8p6p1tprKNv8tzpBjkhSYVpW9zf3zFxjG88yh+oTx+DpCH0CWETWxyzzGBOHmZe+MRKHjByHAehO4D5dIwod+FMIN7CyAJcLIHXAq4cEo6mQyxFbI82nWIjY6ZKXz4SL/I1fniQ3L/YGp7ZbZLpSwAzC6Qvy0fHP02e4ZiKTrgYRXxZoR+TpSR1aYKiN2I7VZARfoufc9fsYRqGF5EFXPOcQS2vUHFItcGipLPImvCh9KqYhfr50BDMbRr/hKrXJJqc4+LavQVJHI7u4Qe1F9kD3HSTlP8RPJpVdy0lqRR6nagjLfligftiRc3Vy5csU0QW6ggnFqTty+uVEdq7YqJRezuU/MYk9WCMFhex5y/zZTYM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y3ytiAwAHcMJtNtGpLseHwf9XjVPDmPwD8GB/eADV1WLfFUVvfryGRnduDuL?=
 =?us-ascii?Q?LDvAp/LwGt8zTwBROAGGYF1cWHl3a0uGV5oMy7KUGk8jf0ZyfpzOKrWrg5vn?=
 =?us-ascii?Q?7mMgzl4iUb1eMUuP+5vf3MKojmAPmrArFRgSKYB5w5AoE7MGCJZsxMWx6RW4?=
 =?us-ascii?Q?dLe6s5ephYtno8MfT/7bOVAiYfZo2MV/7bPatIJCjG0Qsy15HDQWpyoko5Xh?=
 =?us-ascii?Q?dKIJ+7zMPIqTrNGr5gTU+dy0S1MJgfDy7j9DOhEnjPlML9KUfgfLkcc/SeiU?=
 =?us-ascii?Q?yRrg734K/ZtxtEUDYSW871xi0lfj70VzHv4ZGfHziEO6MLhVeQIvySWnc4Sd?=
 =?us-ascii?Q?gF5r0vQglSfAs997/cv5/MDIuyMsIGSmHx2+ouYFOhluO+d2QzPslI6f3Bp0?=
 =?us-ascii?Q?iBqcR8b65dffp8tEe/QVhGrXQmBnwTronAT6DJofu4xiKyiFDg2m1MXeHnRK?=
 =?us-ascii?Q?BszG5n/plpbOP6CdpGk4MNxUz5N/Bai9ugEidJKZE0bVViJ2VnuyhnF9CdPL?=
 =?us-ascii?Q?Y0KaKVFMpI4z623q/2bNDB0knSZvZtGel+fX6OWjJwlgZDpgn/RWYy2yRdvq?=
 =?us-ascii?Q?OfJWVm4KBaY5SNAtwFTNCAtjmq826mbntA45qpSa7PragSMeNXUjy3oj+vXp?=
 =?us-ascii?Q?1A/2hKhWbrdu07rJ5h1EjnXgXpjGzdW2rACBYYLJcHidox61TiXISIJPIn1n?=
 =?us-ascii?Q?DaTvaOQ6wBFZ8GvdvBnCYWqkj7jdlbVnCnxrq5ZjBbuDxKrNiOHuP7IXw4mM?=
 =?us-ascii?Q?s+QxeNydEvL17NEQQwl40LhOxrWZE6NaLVS1GA+E/6SVhai6IMs1I7MKCorL?=
 =?us-ascii?Q?uCgbOtsdVzuctnOThPUES42YliH7EtwhB8geW1rhbyhrykHuvpm4rmQh+14s?=
 =?us-ascii?Q?Dz4Q3IFAW448pQXIothsYOhrlmNaxvfWVzOnkYEqLtzoeFqPnprQWzHDaXAz?=
 =?us-ascii?Q?DknIE9Zm9V/RRL7Uakp/FexjV1vhdlxAszTYvOOOyYO77GLl6brXFPseOZBJ?=
 =?us-ascii?Q?F8Qlz9RuqN+GcM+xbsAu1l0rqrmkqgRVfbaXwrnvyQZfp9r+jpcQxs5PcwMY?=
 =?us-ascii?Q?1SW314mDnBQlBexFkbH61OY6nJeoPvi94NtDZN8f9JOWJbc1HSYRKS4Zzr1B?=
 =?us-ascii?Q?Q/0fucYR2wiOn26GanNcFMJi28wr/szzRpRl8okKi6W1Ybo83WB8WU1QsKie?=
 =?us-ascii?Q?dGJBeIfW43IHyEbCd2PSzGbvU4BcjHq+0dLihP/J0KGVepCDZ6qVH6pa4kG+?=
 =?us-ascii?Q?W3X6+RTasj8tay5dXOzJrcWOrmFebP5fp8gY+0uJK006ZlMXTzw4U5zVEury?=
 =?us-ascii?Q?VTwO/rM/V0jCuN6c0n44dTi2Pg2B8rLo0kUKQmb4nFWuJ6XHFVxL3DZjF4LS?=
 =?us-ascii?Q?rLaQXwCglPhIwL0ne8w1/rvT0RS2erJSbIX//S0vTFYzmKzfyKn5PF21Iy0c?=
 =?us-ascii?Q?l4z9/Z48vr8oAS6h5NTHVli93/cT/d5D2IkWzi66hjPzXwFzrA6aAmARgAIo?=
 =?us-ascii?Q?0ajI372iD/gcXJV/Lrj9h90O/kVcTP3c9MmsHIh5BcIYY8f2Xm5J4crC5iz2?=
 =?us-ascii?Q?eVp+3aOxht7f3LJ333eS/xDqnzgSD0AG0gM6VhpV5LafhRhZlTms4N4CCcsT?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 840b76f6-de0f-44dc-94be-08dae0df1ec5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:32.5721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqyDQTYcnUusQs6oqo9jYuewljbuKILtLA4uptvE3j427AiRzKqkcv4dv2205ZROliVvURY1XfY3L490mwRWJHfyl8ijRxITEi51fJN/sk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-GUID: P_YtCfEarU3afR9NSC-EnRYhV7HV9rsh
X-Proofpoint-ORIG-GUID: P_YtCfEarU3afR9NSC-EnRYhV7HV9rsh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_inode.c              | 52 ++++++++++++++++++++++++++++-----
 2 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 87b31c69a773..f72207923ec2 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -84,8 +84,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_MKDIR_SPACE_RES(mp,nl)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 11e0dd16ba94..fbeba9cbf85d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1249,16 +1249,32 @@ xfs_create_tmpfile(
 	return error;
 }
 
+static unsigned int
+xfs_link_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
+	struct xfs_mount	*mp = tdp->i_mount;
+	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1275,11 +1291,17 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto std_return;
+	}
+
+	resblks = xfs_link_space_res(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
 			&tp, &nospace_error);
 	if (error)
-		goto std_return;
+		goto drop_incompat;
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1312,7 +1334,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks, NULL);
+				   resblks, &diroffset);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -1320,6 +1342,19 @@ xfs_link(
 
 	xfs_bumplink(tp, sip);
 
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, tdp, target_name,
+					     diroffset, sip);
+		if (error)
+			goto error_return;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -1337,6 +1372,9 @@ xfs_link(
 	xfs_trans_cancel(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
-- 
2.25.1

