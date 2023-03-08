Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C85C64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCHWiP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCHWiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636323251E
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:12 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Jwkds018341
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=P5j7BgTQAGPsNo5QbGjw47KSh+ZHu1/KgUNMIr02vNI=;
 b=JzK5LqCjpAzE9Vx8iBFj2ilRjVc+WNfjR7UzihHx+uszRZH7Ct4swE/FbiSIcH2vOmxg
 S3KUREIWOSulPwATTUNDFgqyLZoX5pb3bYt/1ZclneuE8+iuGMOsZfJupSohGfbI3fHT
 gzvFtGDykAZ9VNf9IPcYOl5Lb5b64LIise435OQxSvQRwy/nkp28ilGBaNObmMRLKIfq
 0Rd/r/s6G/CGNoUya/rmyyvUWeubSLXptZdUzAwey0Q4qI+wXr5bwv1Dr/5vyDpSYCEa
 6TEi26v7B38G4KmOdqO/VjZNUosWC8kkZzdz6D7R3a5bDNNRxFPzVR7whiQ3HyJIXZ3E Jw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417chcww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328MAF4p036499
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g464w1m-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yw19OkiBcs/2x7WCoHf8QoLFkgn9ndwDnHL5ZL+qU+p0nQMvlTWg1EZhFShtD60cZ49c7LscXzY++8T4Xe6I/ik3A3TJ/agQzEv6EgXofaQsMFaq89X+Ovv3yj7IRhe5yWQpP/SQT6//OEB4zTmd8YmPBTKu11m4wnNQtRNHttsezdJCM07ybabor/1nnLfY9+En4YGK3GCAHOU5gqlM17CbjQN8cTIhGZwdC3McKqCZDHwygDZGlIOVCffi69uAVp/aCfStyoi1hGjd7b1E224cIlHQ5/N8kTBlkBPYQ98ApJvmffYl6CiPqmwyE5ZeL7NrUCyHY8XxJra5veehVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5j7BgTQAGPsNo5QbGjw47KSh+ZHu1/KgUNMIr02vNI=;
 b=TyuqbGSgR6+ymvsXinRAp6lqcMsCr+xXP61+Ag2WAEaglf3yTEaANQUVgYq63qu7GafE8Hn7JVmV9c9MrI9AFUPKd4ccm72sf7BFIvis0WuL97NmaXvWrpcmGc5PwIgtuC6wwsVWJHVtDAYqQm+0Qz0GoFyg/ALdTEfxjNLRS8bvdav2Wk+A/bntzYf62Ag9dtYtqdv0f4HxCmmV5M/wxcMiHOkdT/8QpW8SE00CULR//Rqow4FuKfGv9AsTEiHCCvrFkp5RRiu9/jXDrJc67hYKgkmyLx+MitrxPcZJRkcNgNF/7W4WeGCNzqLoakLPIAYVYh0cIx6Lluld8K+hZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5j7BgTQAGPsNo5QbGjw47KSh+ZHu1/KgUNMIr02vNI=;
 b=xxvEO0vJ0BwuKcS0MMaTDSQqldCymcdK0XhJkHxYZU615QRwVWWPCrk4G9tEkVsSNTl8stGOMCthrkl7W9UELp5u9XMm0cZF5POKPvaOW7mpOeSzhaC5q7D7sJO1sfHl4z+H8cqGEHQEukh0XjojReVRXEQolynid9nMpoOoIrI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:38:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:03 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 04/32] xfs: Hold inode locks in xfs_rename
Date:   Wed,  8 Mar 2023 15:37:26 -0700
Message-Id: <20230308223754.1455051-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: f9baa40c-2b17-41f3-6c03-08db2025c78b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gxCioSksLgL7G2jaxyXOYzG2op2DQvi8rktkGjG/CdOAhA6v65hI0vxh9mPJDI1FAXDVm+O4gMvHFP2NjgXAYQ731gCajHt4XErd/7hIlyQ08Gh7jk+jTlbpPmlju6LPCdzufGTe7aMpOvLq6ANBrZnf+pwOYlYVHcXIHD4IReEC6Yeyvdl8WGVkL1MBSnHkbdZ0nEJoIWs0iQp0jhB/iF8GkrHqqWg8OdFkoEO/ZWaZxavQs4tJ0Jjl1N971b9WgZa6KnF9bx+/BEn7qPfoI9a2I6ZvhxXWRZl7nWoIxUF11WuhabqGfVgbwsW2nH9tIdUNisAfGRTaQCKbEa89WhLUHskcAikES4M/H8hOWtLDOfCfx0aYcLT+YCrV6VodMr7Rm5TOhLo0oeM0ErXjfWscCJN+KU/Gujdx1I7PhmI+zI9ycA25YYG8NDdLzejOWRXKS4qhtytaXNuv0q0AmsL1AZ7RmQ5A/jGLUFy8muqiLQgXWDT8ZLeULAcpo4CSIMRXMY885+6qzGXUudDx/uA1xICyyKX8T+67/AXBjUOULo8wj5QIM+Tq0BZ8vofyU2GM6Azequse6IACaNtLsy+8aRgSJ/scOtEUnmXUP9Yv9g/KW3mVzh++7XqwkkJJ+5F5zSdX6umyjZjBrZBiIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fR+ECWr3br7CgO6Yk33VEEAvuMknk/Exblbbk30bd5dVBDplrQc/ZudeyCaQ?=
 =?us-ascii?Q?dEO2MAUgPUOeX3EW+lIiWcW143G+9DrKxJ80jzedmifjlawgJKjSHvnlnEH+?=
 =?us-ascii?Q?uEm8T7V/k7hTZH322UxK7zqXWzchqHnty17+omqNvfHr8nEuD62iKl3+wkLi?=
 =?us-ascii?Q?8J6lpub/H6Jz/wCyypl3vuWkvMGXEc/gKPsRqjhrJbNFSahKpqtdhjD0YcZJ?=
 =?us-ascii?Q?fAMBYqiRZDvHBpEY5iJt3ajuAW/J0EspYLZTDHVP7yFsbS3nVjmDFPxq+5YL?=
 =?us-ascii?Q?FjmJEXB61MBHLE07Tn8sBR8Gn3U2exq/JJra1DhutO/Gx/8Dkzb3Z2RQEwj6?=
 =?us-ascii?Q?pyZR17cYHqWF9kdT0z96OtTNYu6Hdq5BKP4dK11cop+yzyOoc12ANWFlNO4p?=
 =?us-ascii?Q?vWvq5nUYO69+LiacqdQrfKl1Ja/1foDOt0tsfkfmTdnoI1aBari5RgBoPi0u?=
 =?us-ascii?Q?RRzQdo8oXtgXzsU8bPO1cCDhP8mgzsMvpxz2XLUDW2tDB3AEpNU+DvRxmDIZ?=
 =?us-ascii?Q?GomL3fn/tITtsvij4XPWlACBwTdAI90kbu+Nlakq1O3VMzh5CVWl5kdgsgyH?=
 =?us-ascii?Q?bRAIqcVgUVrQUNiUx1hyL5+NL+c3ZZFS/kkgtBQ6oC+8nrLTmq90YwupBcIq?=
 =?us-ascii?Q?yT1dVmo/nDVGvKO952X/omDRZmlRyy65rZoqMUhFL+jbiyLNsgUF8oP05bZo?=
 =?us-ascii?Q?gqHyQzklwyb7RX+9teOiR5bX9hzvKY2zcJYO5tSEXQnc2wD0RXM5wNoCMkg3?=
 =?us-ascii?Q?0GZhnivqQ5NsbiW310khz2c1wVISJMJyeXJf/GIpFIalRCUlxYD++iTKDJBu?=
 =?us-ascii?Q?O9A+jiGdR9zmcEK5VgUJ/IdUlKZoT70hwjq8sPOhd9FzWn1UzQ3fBix7MU21?=
 =?us-ascii?Q?L1zKT+971axA1qm6NCG5+dLqPk12npKQCEkSjz5SWCc37iHmF455i1uScfF+?=
 =?us-ascii?Q?XDTeiwADk52o2KBdNmhllS8d+FyPnWph0EFC9XTwhkSI7XAUVTdXOqcmDiIz?=
 =?us-ascii?Q?PxBZANRyn5gs2JoSzK6+fieN4bBv8UhydRavPLAK/CX6fMXQCHINdiSgqMzm?=
 =?us-ascii?Q?aLvmLuzkP+bsUId8+GObItQ9LCgbqyd6zQPO9IjFwFRPNRvSx0y01KvdEfJv?=
 =?us-ascii?Q?Q0ZehBJuh/53cvvFjKaeKT1c7YI10kXuPm7Ikxntg1rsBCdEmi7i9kuOs3HW?=
 =?us-ascii?Q?qIsU3iIafS56VkoEiSHQdRUg102fcelzfSxhYxFb6vYy1PrwF/wfyD/rYfLQ?=
 =?us-ascii?Q?WKoPmXU7zNME5fUXtIdYZgJ8TbkZIyyzlFtuha6qdojRqGOEvvxhETf6zkzN?=
 =?us-ascii?Q?LedACgW1vhgI2shIY7knLt09vd3c2KvsQLXjCDJa/j4yGcP0sA3nTdERfvpt?=
 =?us-ascii?Q?Jwb6fCYDerY71n8wDExtWGoGoSimdXYarRwCYNnVg/E1qxNY1ZWXUaWOF2y2?=
 =?us-ascii?Q?SD3sUBPVuzXVL16zKj3UI5LkE8ODoes9Uw/yw2N9i1KZRcpfIhmfV0GdiqiD?=
 =?us-ascii?Q?w5FQhCAiYpm49UM8dH+reIBieXvp4lnYoDWE7EIm2kgzrB4ZqteIJJfzlBub?=
 =?us-ascii?Q?rcDIUbToXSC7FkeNkrkkXOvkqkTDEYRYrPuRsIwAxG75tmHMBPQ8w2Ky67NA?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dDgBq7JxWonboqL/Q9Jg9o+oWE1ghNlRAhEPfuAU7j0HFFMhSPCqpwzrrPtFDacSPDvzN6kyZiPt0PrpBfUR4EkVLYeiPdx4spv4jquZJ8FigkGvCRn18q1Q1xDWRFaQvj6eZaQj66sZooH33//niPwm6o6QpepCxrJ0AWvVnPPeUIvgbW8KVBCQTKaZd0MKguBEBVwSAnAWl8ccCwTwrXSj+RYgjaLNmxZofXRhhf0/02AG6c67LiH/ZJCMrs/PHPVtIIYEktyCNuabh3Qq1GT4qfWu76frTFe8SJvCT0/rsv6bqs46YyljGZcaOEYQ5m4ENBcjXGLaR92GeaTB5oFD8LUSSmstFSziD19xWL7nHUpmlv0pt4jH9rU9NKv6aiZBzFo6+1OLLMZLBeSyLkqwujZNgnc72ek2r8uUSEfkvMfiSCV4OZPydWAmWcVNLnCriJlLo7bhi4519mM88gCJagJMRynt95ayHy9fv6WS05ivpi9W+LsHZQQyJqrPLh6Av+wXpq1TA+6FSF7ikMUAKCgvcw6+6idkCtxF6VYQfH1LsXt2X0n32H9NuMTdKqLEvoEIJQP6JmooxpSjSWdOB2Q3tFVlYEMwaZ+8I+0GQTZnjIEva60EwLOe2PrSnP5+j+DKpG0RbYS3Gi4GF/BWh/L5eo73WWFB9BXmSXkb8W1ptoaGWHNueFWVRAeGiKDjDVsJir4u0tDKFwfaTo9zVfrgCak+2xzPC7O49b/8B8pklqTqCEtchiojuPgKnMBFrnmMENCjR63it6SOvw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9baa40c-2b17-41f3-6c03-08db2025c78b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:03.8301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79VSBMk7oRGPGjUwtbywTRgfvg2REPaow3uSMYcMvSyPjoOKXHVHWrZZ5ZCwpYdSKhgwAoKYAClSIy0IxjE4uK6s1Ai5LjgYBJNqjEWJPmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: BUz0ZVDDP1Kr_Hw0f0wJosNduxitXK59
X-Proofpoint-ORIG-GUID: BUz0ZVDDP1Kr_Hw0f0wJosNduxitXK59
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_rename to hold all inode locks across a rename operation
We will need this later when we add parent pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fc730c573eca..0ca2f9230afc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2541,6 +2541,21 @@ xfs_remove(
 	return error;
 }
 
+static inline void
+xfs_iunlock_rename(
+	struct xfs_inode	**i_tab,
+	int			num_inodes)
+{
+	int			i;
+
+	for (i = num_inodes - 1; i >= 0; i--) {
+		/* Skip duplicate inodes if src and target dps are the same */
+		if (!i_tab[i] || (i > 0 && i_tab[i] == i_tab[i - 1]))
+			continue;
+		xfs_iunlock(i_tab[i], XFS_ILOCK_EXCL);
+	}
+}
+
 /*
  * Enter all inodes for a rename transaction into a sorted array.
  */
@@ -2839,18 +2854,16 @@ xfs_rename(
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
-	 * Join all the inodes to the transaction. From this point on,
-	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.
+	 * Join all the inodes to the transaction.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -2864,10 +2877,12 @@ xfs_rename(
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
+		goto out_unlock;
+	}
 
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
@@ -2881,6 +2896,7 @@ xfs_rename(
 		if (error == -EDQUOT || error == -ENOSPC) {
 			if (!retried) {
 				xfs_trans_cancel(tp);
+				xfs_iunlock_rename(inodes, num_inodes);
 				xfs_blockgc_free_quota(target_dp, 0);
 				retried = true;
 				goto retry;
@@ -3092,12 +3108,13 @@ xfs_rename(
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
-	if (wip)
-		xfs_irele(wip);
-	return error;
+
+	goto out_unlock;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock_rename(inodes, num_inodes);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

