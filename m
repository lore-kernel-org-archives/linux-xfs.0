Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D1DECDFA1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJUWaO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJUWaL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FDF1A7A3A
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:08 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDjae030003
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=Bs3Ep6A9KlBZJnBX2NFBXEULxHDi+p0Z42dmh61HUNA=;
 b=opvr9x7RzswqyhyH8swXBgPc0pIjrm1U4D3V+BzUzyvjZHfx2mCxnIzXlJTFQ01ahJlo
 tDYNVgYBbaPpFxmr5QrvwqyObIxo1gsv22ts1JZ0SqJfOIbh2aLpERP85a72aPnx3gCu
 kKFs1AoNha9L6kj+V/b/ISlI5aTEOkab/eVij1lcN24mmhBd2AhE13zErVex85Om5kY1
 080O1WoTzI0LkgS3V/dbtrSbYTUb5+78/Y5czWEQyOGGJ0IF2CiQcEgaS/dUpbzQpVPe
 PJi16Va8R4H8LSpPEVYRajAfcJXz6ebjznAXGJ+249IRO/mLL+oQH/dNNqVvLVPOtm6L Ug== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw3tc2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLk91c038663
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr3n271-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4JJMeekYSawB9NRU0KSVmOt2sx6dTkU13F9vcle4U5BWOHqbdpSnovYqdjJMd+qkkPq2xne6WpcwiSd+hSJl+Ce2dWu/VgETJRuDPk7lur7wmUfBwXRchiV2BIqkeET2xP9yo99Q5DZGvgVbJK/ql2WhM544dOxXScHsRqbp5SCdD62KqsjhEZGsMvFdFoM1oTxHpglGfU3PkE86U4P7ivWEH168BsnyrRnsjK6xzpFG+ARqIdlNgW3K3jzauuXN96yGvddqpgGu8yoFS63SE1vlpSF5BJX4xwIi/FBkcSZBv8swdNaByJej90tyudrM2Y68ExT4TZ+mmei7FxFIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bs3Ep6A9KlBZJnBX2NFBXEULxHDi+p0Z42dmh61HUNA=;
 b=jtZlR431Mq4RR5vBaf2ofpuz3z7s9mZY3C3xlBzKz586+nG81E7no8PETEQVbVniXXKw2wMvLPtBgRq+vGdjsfqf63Vb7dR0FfvXMHJrUvcUxlTN+LttPmHxPeC9yZ24UaLmqdCRWBoo1ZHlUAM6AOQ120j4dj4bddRP3lr1qxzd5Vvh0fiPSq8w4ysShDCbipIV9G1nnvknsNMDk38R8X5zVSs0LpxMAAvOPQdHT8SreYwJz+M//ztPgzakQ0nWJfkDaoicFwti3IhYxJuK4W+vwVMqayjCiJrEJk3KtQZsYhc0EMBSMSWW/qmRiCLzvs4jWtW8sEMNTm02oJzvWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bs3Ep6A9KlBZJnBX2NFBXEULxHDi+p0Z42dmh61HUNA=;
 b=xVvJFssWH7p7DFskN/554AWMqBeDBKfNP/CIDvUd0mMJoIQ7RDK+dhkhVNAdW1CkWEF/ztaKVioEdK4SsgaMxGjDN+49UDzOuD/r5LuOIpLHOHAmpsTgPDOLyo80rv6gs2ngEQyL16mchKXslapuTeDtMAisC5C5g7yB/8VzaKQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:05 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 17/27] xfs: add parent attributes to symlink
Date:   Fri, 21 Oct 2022 15:29:26 -0700
Message-Id: <20221021222936.934426-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c94199c-6ad3-43b4-a611-08dab3b3cd0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kaj3B0bAjVvmSRTV5A/EMDMX1srSfYw5q8TtvVQ2h4Kr9ivqPmsMXi+keEouGjm2BlzRY/BARCZrSb9taiYyWu9bx94gt3E/r9ogcmthKsfDeqfZKmNhZcYTbOv2JXt75cHAgyyO/p5uauasV9xJb2jZPNcxGF4JMILlzGXYWVXxjggKzcThI1lRuysufntvaWFrntKEyn2zGdRFIKEDnNoJleDdJ51ArzhNedJQ/AULe8QdpyWhrmn2dQFK2h/qgrTJT7oowev5Zh5YCtGTSDxWUjtjBlH/i/qtgOUEN8+3Rf6XZv46lsFlOYKmnfhjFeANU6XqeSzTVA+Qt2fKckeqYLwbkyJOFYu9DkC5SWfHrsLasEJuMJ5D16QpkQvU3RNIZce5JSexIOjNd8uVZQrpy4ogFCFrzdqtVNCjjXoOeYYKQG4tmW/d1TEvRV2/L0QFhoRVL3MF92DjkLMTMAwFnQjhFFXnnp5S4S36pr6bdZzl/hXJY2VVzA+XcfzMiraLnbyZa+OOZ+2hkdUYi/41Q68AhjSGWSAMSVPAPcHL20u2ZODoNdfWovRcH05YXwtWcpnilHhpKhW30dXhj3RKHF/2xr4Vs0qs51TXp1ARVash4prapha3o7PMSy7ORUvVOIbY1q/CU8NRMp/F8dlMFjj32VyF9dw0zAHW6nkOFWGBBhAM81D31BQqIF6WLVEeBeo0MbX6UWCwxT197Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8882KJN1uO0UX0N0BjqOwROn2rrPmNl/XYeWhPTFLi6TiSAHQbHzlKoe0xNg?=
 =?us-ascii?Q?HrC5y4s4FLL4iUM+kY7mPG/DJ9JIk2skh2VGaoKwc1ZnLgVx6NxctRfEdKGg?=
 =?us-ascii?Q?PtWB/VNBVvVOGlh37tYc6bc0aUKUjCMbckVduHKtitHObp66QqSH/2RhFLBb?=
 =?us-ascii?Q?rCaBVoNV+cuGL2I+M2099j6lmfBn/n3ctpUZLJFltg6WJl80PWfxk7m5ci9E?=
 =?us-ascii?Q?aFD38HzgwJgHhskMNv4hNPuT6QOvptVGP2bJxNyP6Xzy5ndV4fjZZw9jDPQr?=
 =?us-ascii?Q?5kBj2Gfx+R5lY7DMF0EqLGQC7mQx+cU8btkpQl//JGNiQRfOi6XxBzEIN+Ro?=
 =?us-ascii?Q?wPRFh7Kyz/FEncTRfLe2BJi4Y0S+GW6MVxmtnz+v54g4rwj/c3rCaMv3lxe/?=
 =?us-ascii?Q?dvNxmcMhXZNOgV3if564va6iIXYfzDU/2FLW4nsHgM2DDtFGjqNx20Xs29WU?=
 =?us-ascii?Q?ZPB8U3WCP3+YsuP9yxxYgcHuMZxkjjzA/QYpNjMyFjKyyjIvXg2nqnTybgrj?=
 =?us-ascii?Q?CGGnVPwaO7JtGlXfAs6GpjC6wjoZvp+mfN9HTpjLEUpdLealITS0jAnXk7s2?=
 =?us-ascii?Q?/LCykpVM85l9ibro6tYtV9oc82lQ5LoxeWFNEZUoKWson+5rEPr5uxbw+GlJ?=
 =?us-ascii?Q?cjAk2zhN5KitGkqmvYmPgpr97/KbVcM+et0rIhqYc7N19T/AHL4mjjiyqDua?=
 =?us-ascii?Q?/KdK2H5CBsuWqo8RifEHQxFkKnDyOlACu0k27Rr9tHC1f9niso+dmh0E1LgV?=
 =?us-ascii?Q?6+vWnRybUZ22NRJcb5y2wZI6gTjmoOIjfznBlzDYZbc8UWRSw+wWIBlIDevV?=
 =?us-ascii?Q?ttafjZ4npcfTlQHjKYBFUGKFQKrz1buqEYC4erySsOVmI7SmxPt9FVGwABQr?=
 =?us-ascii?Q?fzSQcsJNt8oG9NIIcEqDGRmDjnym8y4aN+3CwjuI3RlyOLlaqFdvQ2ZcG2DL?=
 =?us-ascii?Q?Xvh8HKLK3Gr/cXxqYcleeJJZkKUFiyW+yle3b7a8HSYSiwftwLyCtLnGSkn3?=
 =?us-ascii?Q?pM3AQPjhPD1OCnYx9kDFA564sX8R2mjc75FczT3fcQ6h0JGEqEOAlbzPQe5D?=
 =?us-ascii?Q?n31W2Zth13vcqttnCyrMhBMYfBTXZUmxsyP9Ct5XZZgBu7le+uog58TtUUHW?=
 =?us-ascii?Q?pXmtq5zrqV7pgMCWcSrYaks0bdYnxQ98VM9ghETFvwqAVe0H2Luib/Lqx5TV?=
 =?us-ascii?Q?8DvBaalD+6klbIKXK7ZP9s8sr7JEOwoVKufUBit7hbSmO181oOq0sfQ2nj2g?=
 =?us-ascii?Q?MHFPvTbPzbC9XVTYVcjQx0Yj2shk8O4LDM6vULNK9YPz2mFCg8KF/mYIaO6p?=
 =?us-ascii?Q?F4Z04gag9ZLKSwoy86tpCKBVsWnsZ4zLziZvIUXDjx+xavGMHm7McOJVUToE?=
 =?us-ascii?Q?zjYutdPNrLhNmbDvt4+0gxq6rsGtJYcpuZyCn9RQo3z4FTUbSUM1fAQ/e5ty?=
 =?us-ascii?Q?P8EWGncTU7vI4Lwy1U+Q4croDn2a8UCVwZY6sHVTSvwM3IptuF/kvR2KE8es?=
 =?us-ascii?Q?ryTfGzii1YiVnyKg9zqH3+v73Wjh6Rj4OSybT58lsmnXEyUKlw55Qj8z8kjh?=
 =?us-ascii?Q?yCqUn2SkKH18IqCjUKOV6S/2IfcRMOaxj80Ki8F3F6Nf42M/jLdoIiNQlHv5?=
 =?us-ascii?Q?Bw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c94199c-6ad3-43b4-a611-08dab3b3cd0a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:05.1736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ihyr+qa5YyLK2DiEgpWi1OOV3qtRpZ/h9KHn0p9M0XYdhX9y19i9bKbKxquyNkh0ZMcC9TOpRMtV8oAuPW049X5z5WEVyn2MSBd4jFL/ZDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: 8ESLgwyHltkRDATzjKwd-aTKAPD8-Cha
X-Proofpoint-GUID: 8ESLgwyHltkRDATzjKwd-aTKAPD8-Cha
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_symlink.c | 50 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 27a7d7c57015..968ca257cd82 100644
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
 
+unsigned int
+xfs_symlink_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen,
+	unsigned int		fsblocks)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen) +
+	      fsblocks;
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
 
@@ -179,10 +200,10 @@ xfs_symlink(
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
-
 	/*
 	 * Check component lengths of the target path name.
 	 */
+
 	pathlen = strlen(target_path);
 	if (pathlen >= XFS_SYMLINK_MAXLEN)      /* total string too long */
 		return -ENAMETOOLONG;
@@ -204,11 +225,17 @@ xfs_symlink(
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
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
@@ -233,7 +260,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -315,12 +342,20 @@ xfs_symlink(
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
@@ -344,6 +379,8 @@ xfs_symlink(
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 out_release_inode:
+	xfs_defer_cancel(tp);
+
 	/*
 	 * Wait until after the current transaction is aborted to finish the
 	 * setup of the inode and release the inode.  This prevents recursive
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

