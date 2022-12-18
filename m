Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4C6C4167B
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiLRKDl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiLRKDi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A336559
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:37 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI4ovMu007685
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=/ZHnu17wX0EAsrcsvCpkMDiXHfRRSu/Q4x3Y74OEdMM=;
 b=VZj2JwOcoalk3cMDghe5TXjn2cZ3Rp6hH+ZoqrDaXxE4HElRJHWjEiADNRpUR/6zxZcn
 J5DuoZGSox05HYkKkygCSxtFvcCaTI56m0jzOU4hq+ignvCkqjD+4viVZpFjNYARqjBV
 Cutpvk86fICiHwEtf7YI/sdHENiR8HTDoWpcrc64BqJJGqRYTiMxySRKY/PjncC+sJa3
 MgzLvxnZQp5aZ6nxw7kT5b4sDhwGLfS29gUwYVlRC5D9gdN4LJsNgYtWKs2CSg4fP+1r
 A5k5Xeb9lGH+wExmQOLFh3Xx+jpZPDg3TYpFK+s132ZyW026hb4PrKyAxQary7XIe1B6 +A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tn99gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8B7Es006852
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478n3v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/ljt9390a81SOZ4j6il71AVuo9FV/VAfQ6STN+rNh1cXETbAkPQzndHWDC3yuzc92GcxKgQaQx8wpwfWOqPfBKXFmN13rJFCc7yT54MxA5jaYUOkmcKCB01y59JMRu2oXrEEhYQln8WTyk0KVEnMfWOP/LEtssppKjUlICTrTpCjgvwwjsfuJd0fccw+XNhWD202194/l3W/Gu86hFcAY9o+mSVuKpaWGjbDK1rm4695Cxv5+T6qKVRUF4je28U3ugMVEiNnrkAF/5I2MuY7dG/bEHwfNf5RuuotXI1q9mbfXsH6tLDb/DGHP1FqFnWXGbWB4J3BVSRSqSnsLgaZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZHnu17wX0EAsrcsvCpkMDiXHfRRSu/Q4x3Y74OEdMM=;
 b=XFJXWOpeXTOxsm1TJFvoH3LANFFCAZ55KVgvyucL6gRXeVi04ovk3lm6AHQbTb0dD2AOpvwQ48C+FxgqyQa2JLg51kwsMph0Yhu82piShBcRBOAlVJwBnn/cHZ/F9iqir5MVJUO6eKz5Mue0e0LAirQbcGiSBRbZlgoqyEJHb6HYTgQM7tVCNjaiixwhXFGBBwrhxmQmW4O8aDzvcfo6/Ola6VoiuAkQdsFH/YJjFC3khFEJYSVzeiVQSHtb1YFNS8nUeGGuhy55g/pkOMw6GmmVG/QVDYi5SQnbzNmqmW9R+Cnr7b5nXhwHgdopmILisPsGbUt4KE/oPk+ydVrnFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZHnu17wX0EAsrcsvCpkMDiXHfRRSu/Q4x3Y74OEdMM=;
 b=sgO9REMBBZsa0/xRHi+l5aDrcrFHggPbZi99UPLzoxvToRzXI4dtPlngO/EstHx9NhqoXdrbJ4kXLPB4WxS72QWlWEoPzjs9GIGdi0pAxURHNzbth3lOzfbANxuFAfSJJN/WRLWHTlGFMf1zeQihaQPYAXeQZbEhAASbBeUitrc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:33 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 17/27] xfs: add parent attributes to symlink
Date:   Sun, 18 Dec 2022 03:02:56 -0700
Message-Id: <20221218100306.76408-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0004.prod.exchangelabs.com (2603:10b6:a02:80::17)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 117ea4da-b5d1-4ce3-529a-08dae0df1f90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7y9dDz9Kzhj2yT8UO5ZE3Sqojvps4a+LIB5mCTlTgON2DzYXaYokVZNCbI6bhb6uSccEVaeZndPj0nBWeV0Z5m5f7DeiEjffzyidjlf4Wkqn+BnlxgK4pcMjM0byQzAaQyOYBl0iDKl7CYZ7ajX2pCUq+hvyyERDbN1ffkTs/dlahL+BogNLqJPFg0D1LZICXCeMoM9HVIuFyV0sR2ZGCFxNNfDXzRtx63YGJK9Zt1wCaHgiYf0JMgkOt13OklSwnHB+j6Q4Kj4x/PmQnKQf1b+5qxAGQrfTcV6x8Awi+Ne9+BCFNrn03zRQWKqPpeBiLQ0S2XUz2PMpee6b0F2+6MecMOSn16/BN5V35hzhFVHl05QMEGTaOJzhRywUiWiilcf67TEbS8PE8DyirYnS61R6D++jptWWz52Bp1uzErZUk7I5sl1HVEwTBKy0wlgwBHNxF4HaT1J2jVLBBAM31vlHsmq/1xYSu21OMZufXTrAUuYF/yWk9xEN2VbAqUjvzhiMcN1BzSmEYwvU1MaH7CSFXc9oYxKdOx38B6mYBMcIXDWV57PQtZpwrcF5ECeKyzOAhsRHtl8JWuPTgnQOM/ak4Lf8kYjhPtvU1N3eSgKf4rLK/6dT1vW6WmavykBwS0HJuVqVcynT+OjaP7HUEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6D/BfThLJIT5DrqDi86KpuZZ+MNYsfVnXFRrob7XmvwgwtXqKlu5RDFSjqxP?=
 =?us-ascii?Q?maQGlCrjjQueZqgaVHVYGu8Ehzk5sdu6VGn1DEue3JfdAH2kQWYDPELMzjCa?=
 =?us-ascii?Q?1SZFWvrwG1M4hvLXVD9SP+gLhrQ7ELB+kwE570nGHuYbEr+OlvgOGsjbL9xX?=
 =?us-ascii?Q?vyN56AgR/4LrgGqX1QR8CaSK8LXMs0rY7s4eg9B14a+tP3Lh4NfKq/Te+Yxn?=
 =?us-ascii?Q?lT5b5MntuLEioRTuCpEUUrO5NSwJZdST3dp/j0lwyO1TEx/l4ioZSLaumag+?=
 =?us-ascii?Q?KKN1mxozH8rah0uIZ+fwmugmcVaFJZR+HDCkiHBXWpBgGPXFRj1BdwxZ0MFh?=
 =?us-ascii?Q?6GLHBWnXyS5JleQev8jg3g5bgFYJVpXAI5ziiXVQGxKW7l2phrKL/o0zW0BE?=
 =?us-ascii?Q?lEtpMnAHdWCJBiDdtYcD1MDRpD1PpK5RG6hZhpiVWSzoEZ1KYt3v9mA3kGtQ?=
 =?us-ascii?Q?pS2BRBFFFyq2ZA3X8dotMcjTv+BOhq4UARZZnJzNQo4Ex5rRjs5ci/GoEr21?=
 =?us-ascii?Q?L/uSbkSI5DqikF4NEdsdlh+6KVVZ36sgZAC0JoGoE03CpZ0xhQ4ea+2mfhiV?=
 =?us-ascii?Q?rS74pYiNExl2iPOnRzyybAPuJrA+kUto4BbwKJfKp2je2qsBXyrBJiWRnExv?=
 =?us-ascii?Q?R97CU93Keq90Jv0VNc+6Mrnt2hphwT7tv+lffLCMpNzC+FSSeUs7bbF9AwRX?=
 =?us-ascii?Q?4Z4wnQ9OwOwfz2q1XPVhQQELm4uwSEUzbtAayQdwEyO2hzadtFoPUeEHxog8?=
 =?us-ascii?Q?3kQ7YrzFXeD8nkbSO1LeRriDlcgwqItA/mlX6u2eBTm5JXlQ7BW0NAk6VIJs?=
 =?us-ascii?Q?wbmXjVbCJCfu/JX7FsEI131jeHJBDuWrFUGIOKauKJ6XFKBbuEwvqOqvM8bC?=
 =?us-ascii?Q?aG/cgHSO1i54/qvmjugQtEA4w0A2mpJXQ3lZFok5Z9cqKU/+XtTJSmdwoqy5?=
 =?us-ascii?Q?aNskPe7Ha2U5U0bmXEdyfPvuZ9R651N3TDf+iW88AgjrLcrUJWFMDTZA3rPa?=
 =?us-ascii?Q?zHlYSBdJ9mADEEvAMOVs9S9Oo2n60cHQWTEM9io3PyVpHCoEoD4TgNjJBpo6?=
 =?us-ascii?Q?p1e3AH2obsVWF3b8ma6Xnn92f8TOKL3LKMz8RRzk/SiWOA4jZvFPetlVSLT4?=
 =?us-ascii?Q?aetfCUFpb7exEQ7bwKAp2CaTGEzMRs7zngX6ggxUC3Stu+8tBCg9o9l5Pm/+?=
 =?us-ascii?Q?O9vnttYDZoiGBdd5pIgxVcTMuXT15rv9QW9A4eFsYkjTciH9p7CCWjeYPO/I?=
 =?us-ascii?Q?Qj8961CIxbT9jtPVwE1Fcu/6Da79dOlQI6ApJgg1IHKpgDIrAZID+BT/U+gM?=
 =?us-ascii?Q?hZrOUCW+W2BnZ9hf3KQ5wCYX/Ljnhp2Vrd5Dx7zQb2Wqz0dKdzoJ9a991CVy?=
 =?us-ascii?Q?VhDnzm95ZczJ2MRQxb2KV+iYLdD2RF/ruoI4HPbNbo8K4VbxQ4dd5QZU8IUG?=
 =?us-ascii?Q?55xCQRRWYjmZQtu2fK2zlNvggcpOlaZwfth1q1LeJYXTACp0Cb5ERLYeTW+W?=
 =?us-ascii?Q?F9NPhk9gK48Yym+bxoCOQi/GmSHHEYhPQI5rGVVkrTgFe7QWcU/ME4CCJhQx?=
 =?us-ascii?Q?iin3qTO6NbokSnzpCBmLeynnc2HTKDbZS1lMNcpw41zeL/ohbPuc96mV7KXH?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 117ea4da-b5d1-4ce3-529a-08dae0df1f90
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:33.9008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgzRVTBgzWtBwVmTIilwx3dE3XhMQ3PQHFUzQs1EnhveYN+giWUNYxXD4M6HicKtMR40EIxglNWTFdgzFsegZNioS5Lg9urg+cy7fqtF9vU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: cIakoNF-4qGiSJOLz7RsrOeWHr7fU0n8
X-Proofpoint-GUID: cIakoNF-4qGiSJOLz7RsrOeWHr7fU0n8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_symlink.c            | 54 ++++++++++++++++++++++++++++-----
 2 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index f72207923ec2..25a55650baf4 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -95,8 +95,6 @@
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
-#define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 27a7d7c57015..92d69b3ca28d 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -23,6 +23,8 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_parent.h"
+#include "xfs_defer.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -142,6 +144,23 @@ xfs_readlink(
 	return error;
 }
 
+static unsigned int
+xfs_symlink_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen,
+	unsigned int		fsblocks)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen) +
+			fsblocks;
+
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_symlink(
 	struct user_namespace	*mnt_userns,
@@ -172,6 +191,8 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t      diroffset;
+	struct xfs_parent_defer *parent = NULL;
 
 	*ipp = NULL;
 
@@ -202,13 +223,21 @@ xfs_symlink(
 
 	/*
 	 * The symlink will fit into the inode data fork?
-	 * There can't be any attributes so we get the whole variable part.
+	 * If there are no parent pointers, then there wont't be any attributes.
+	 * So we get the whole variable part, and do not need to reserve extra
+	 * blocks.  Otherwise, we need to reserve the blocks.
 	 */
-	if (pathlen <= XFS_LITINO(mp))
+	if (pathlen <= XFS_LITINO(mp) && !xfs_has_parent(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
-	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
+	resblks = xfs_symlink_space_res(mp, link_name->len, fs_blocks);
+
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			return error;
+	}
 
 	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
 			pdqp, resblks, &tp);
@@ -233,7 +262,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -244,8 +273,7 @@ xfs_symlink(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
@@ -315,12 +343,20 @@ xfs_symlink(
 	 * Create the directory entry for the symlink.
 	 */
 	error = xfs_dir_createname(tp, dp, link_name,
-			ip->i_ino, resblks, NULL);
+			ip->i_ino, resblks, &diroffset);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, dp, link_name,
+					     diroffset, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * symlink transaction goes to disk before returning to
@@ -339,6 +375,7 @@ xfs_symlink(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
 out_trans_cancel:
@@ -362,6 +399,9 @@ xfs_symlink(
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	if (ip)
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (parent)
+		xfs_parent_cancel(mp, parent);
+
 	return error;
 }
 
-- 
2.25.1

