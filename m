Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01CDC6FA91
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiIVFpi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiIVFpa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63F57EFFC
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:27 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3E6iU022056
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=d7JFupQgtYzKjtHPf0s6L59qD9QiNXV+bZlENYvXQGU=;
 b=lum1b6InLqDtM6K0YjgJ0OXYDAivuT/puyooM86sJXWJfwS84H7T9AAt+DxB0jrzGZvK
 NLMU9VfLAeG5dI7STLBJVBUGYNQIrKnV8q9AMMFY4ppuCBXZANoWJr121lGfZBfbNppj
 MH7JxiVBawk9UPMl51xbq3GCqhVqxdYzr8NJ6jy1gqYQ2hEfG4p4P1jFF6iMIrlJgWE4
 dcOWKdFeoZyomeUGcMSmyd/G6VYQSATpRgJ7ZlHiE3mH5fCusOYTrjtf6qCVkw4aHIfi
 LMvRxrIKoeneAaWHu+TmHazrCNA9IYtUE32Mvg0QBdaCq4MbMVFzUUBAN3xy/tJ6LhTj xw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688kv50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M23Wj8007081
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cq70bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1zVxdy/RggcDcxU4MKwIJC+RN+CfBmFcVhNC1LKdWxqIGumCERis9GeqaQXZw0N61koB3m4xfP8nOSgCSNr4AQVa9Uy/B50+wKxB8GTKfJ4pqMrXbwJv65o90idOt2vcRe2qI5n1ol4t67kVNGjnT5FC07sARIKE/M0hztOuGHL1xIBvrlzf74vNGJB/WMa6XOgSgHqIHqPCyVp+6zwhp3MdKRDjXB20mkmLRQTEEaTRgqDTesPdAV5gVAjBHjvzXJRQVy4r3TTHpl0DR4BvD6zmQkjxhcKw9dXoofu6QNTIvD4noB8aiv8nis7HrZJdhCeytpngLjcCg3ZJ5gdOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7JFupQgtYzKjtHPf0s6L59qD9QiNXV+bZlENYvXQGU=;
 b=ONeUZcxc8KX7plcm/LZAftkiZy7Za0qwvwfnCa74o/DNFvb6r69/enK1F50uc7yVZvKb4arGV97lgd/IPIPMhci7RFxmJkfDHjslbJZ7YDuD9Y4DNVeEJRnSc1Udm2FkozY0tA51NnCnHMMam5PXcTKPDtvYKvvZ7h7ocNtoXOrwyV+rPcSTX2V+pzzcacVUSLkEJWwlvByJbPTouigcvGxQLsxMot3s5Cat3gl1spByH5Q5atfA+FGl1ukOi+sJOUuVuJwiLn45VAYHqbktZ1H91HyBm7xcfla2ev6ZtEyjD4URrSdy5tUb6e5lO2m/lDchrdcRbSoaJqNMuGJTpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7JFupQgtYzKjtHPf0s6L59qD9QiNXV+bZlENYvXQGU=;
 b=NefOUJjGXHbxIBVJ5WeLX48tzEdqhU00K8dJR6BcMA+/HoigC/j9xXY2hButXSSlsP1KFGer94Tf9OyreiYXrzDMqd3LxKHH/y4ujzc8Sup2ijp3xCfUfmLhOLKeX4cHAn7HyHQn6DlA1xFM7Jsv/0xuVl0jzGdl3vAqmNfCljA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:24 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 16/26] xfs: add parent attributes to symlink
Date:   Wed, 21 Sep 2022 22:44:48 -0700
Message-Id: <20220922054458.40826-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::34) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: d8c952d0-6bf9-4e82-3353-08da9c5da4ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a83txQIRMyuA0Ks+GeWhgfQGQtZSO2Sfv8VTshxgOG37P4pl2yfLiQETj8d07BFc7d2/FUf3ktVtYApIH7FF5+YqW/hWt9zbyLlW4oQwmZWlJ6aanUasvFhDLYGYsR/W8jKO8yTYgQMAALYHD3TediAYOFgZMPk/dNBNIhR2rQZ78MIrvtHPLm2KXY5eDvSVhqGg4El/WPOlrLsvYsD9pDHpEki2rTS1thIaqGjhT+siG3w1FrSV1QXx+w9MZkK9Z+cQ0fbUwNZUOeN6adHucIDTaA5gx4lmNgGl6s2hZJ6MUlvenNQctTM6C96zQ5MmoaGUj9fccA+RTlAatvCOtsAon8ceHC2zJJtfrl1fJUHn4HXVFnRmCXJLX6A2J6Ax5PWYd7nqg1jHu+77+I+6YiWjOBp93tqq1wZQAXxFCN+iIVleRC50JYcdzwm2hmq8Jehpc3QSRfcblkmMc6vyhKTUowOumc6RnAvlGdJn3NDW6DoQx9wTy5hlFPxTW2RwibreePw3uhg5c+Qzp70NYPSuvV3UCv3NIF9W1d9SK1Lyts+jILySI9/uW8rdyggFsIUsRTfbexqeybU5B6LvyIxbE1mJi0CCfeMUGbe9Ao6mtS0MWMnJyIVzo0aHkOEtydkYt8rsa/GUJeJtv5KgDt+KEjLbtgbIdaHoIAM8uAxK6uSnlxkjW0c2pvC/f6Id0fAgVqVPhPyLbprDyIzoeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zEnnKeRSHaE8P7YLt15QnsJprIvGD5ym+9y/vbx8/MRI4KnmSc24mYJVqzq2?=
 =?us-ascii?Q?WqQnzSBFup4iDMjA4EPY0/tgQkGoZ/2QZxH55Uw1dn2OFOOpJZg3D7btHlVh?=
 =?us-ascii?Q?zrrrxQiZfZdScHU1dZvduUeE9aKDuqQalV1RVBDBrosDwY5SKsZE8GILmwXm?=
 =?us-ascii?Q?lN0tZGLfIN3GdzGbSDEzurQUmUq+arzSFmw+MhrBCdDBYLSobyBAgKK1wif0?=
 =?us-ascii?Q?hh7a3QPaNn9q3J8XN2c7+tccGJ9yO/JRfpu61SsUsmBPNM4e9NBl1ZXSZzng?=
 =?us-ascii?Q?913ubhzWn5ePrN8tDZI4efOlYqlixAOEqSaEzpXF3TSHK0TQle7vxcXbqpQe?=
 =?us-ascii?Q?k8/D9iAZOY3C83TfkNYUsTX81iPAiHYNzZLqd32glU2QursL+RLFb/duAHYv?=
 =?us-ascii?Q?qWAIua880ve/aXlM4HjIJy4FPZnDLo0K5qL3YprNAJXAv7RC3Qsm3B29rnWf?=
 =?us-ascii?Q?AABO7WN4z45lLWRCbyQWicYirawVLkiYDas2IoE8wehJA10of6gCSl33rIIE?=
 =?us-ascii?Q?hx/DhqFwXpE9/+z8QT/9Bg5/yk5NRvg0AF1FlJvkIoSRnrZgFqQ1w2JZTRjZ?=
 =?us-ascii?Q?b6SabldjqBA/ByhTvDC0RdykaDO57HujzqOp+ypDv3XWnGfKAJb3T4Z6AlIG?=
 =?us-ascii?Q?Z1BEEQwCbPAp2Sf5uzdabyAmUtKQrdmCl5Vul0v0K8klPRaKi/sIIGxeN5Wz?=
 =?us-ascii?Q?nhehXbVHVaFxMGZijRwTw+qrb8g1jIqTRC6yPGZ+xWetHfh+nwUMSU7t5UKT?=
 =?us-ascii?Q?6kb0vSw0MCXjjcD8mZIIXULrJVV4vWKpDeE8M6mCxpH0Gr2NzzMCOyesIAaG?=
 =?us-ascii?Q?D0+9Zy2nNLTvUPZGutEbPeY6h80Ba0SRNCwGIGSWcEjJRU1u0Zg2HuHMFoMn?=
 =?us-ascii?Q?ZyDP6e/gPoOZjD+nhG3cVHvwib6ujIFeFjnC71abarIjbMvjYLNvWbBXWKF7?=
 =?us-ascii?Q?HkM7EUhyjPAStNNQKBAY+uWbGAKqQ3SiP8O/gcg6/xs0ytXU5wFnNshWvMlp?=
 =?us-ascii?Q?KP/SqAuCKnF5CP6qTUjTnDNpi/tZNwzqsJHosMIMLkTSAzr/YKilQzDJq+73?=
 =?us-ascii?Q?13BVESyL4rCh0YMmAGu/XSN9XUDkalRnhOSU46CQQ2FUArSn1ku+u/+DwjdC?=
 =?us-ascii?Q?7Dw6Xo6DBx97qU51KIcodOl8Q09BWjTYp8KUrApOjjoh33M24Q+StywlaL/E?=
 =?us-ascii?Q?z3SR8JILlJoYDetQD5/S80egkD7mJp8nC/OsDQZTdLl4z/FoksmDVwS/ATpf?=
 =?us-ascii?Q?koQ8bB3wTMhJjReA4pNoyJq9+bNnn+wTM5gWiv0FeD40E2KO0KI6H3ALSJze?=
 =?us-ascii?Q?JBu6DoYeorz6YvkSj9+CIj8PF2T6w00F6IftDcDPRVx90qpXkVkANxYxm/jJ?=
 =?us-ascii?Q?D7cwYESuvulzZUJZMPk6kYwo6hzkRoJ6yGlqJ6k6bYrt3GtIh8AvXWlWrBcE?=
 =?us-ascii?Q?W19I397KMXOCLML7TRyU49uP97nRUkjYbReKd/Tyl5RmFHlFCY3Sj8FAG5G6?=
 =?us-ascii?Q?ZYmPzpWWpLiQU9/sIsznRDhsBTD9LIX6ctmrKue2T20aK7Rv/B8eS59FhDf3?=
 =?us-ascii?Q?OW3CN92TJmbhxmyxDrFSjrnMGiJcU7gskfgi8MINNB28n4vq1cgl2EH9bZ4q?=
 =?us-ascii?Q?xA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c952d0-6bf9-4e82-3353-08da9c5da4ee
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:23.9937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6OBT/IsIxFk45/ryU8aOAh5lH6X5rae+m3J07rEX/VUFdPXLicMER8KF4YQCYQnuBDLWQ7aHbiZIiJLde55rxyHvCdh9X/T7EABQQ8ElcsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220037
X-Proofpoint-GUID: POjtdHz-h2I3IK1YbxKLUGPcsSKMyayy
X-Proofpoint-ORIG-GUID: POjtdHz-h2I3IK1YbxKLUGPcsSKMyayy
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_symlink.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 27a7d7c57015..14079367335b 100644
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
@@ -172,6 +174,8 @@ xfs_symlink(
 	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t      diroffset;
+	struct xfs_parent_defer *parent = NULL;
 
 	*ipp = NULL;
 
@@ -179,10 +183,10 @@ xfs_symlink(
 
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
@@ -204,12 +208,18 @@ xfs_symlink(
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
 	 */
-	if (pathlen <= XFS_LITINO(mp))
+	if (pathlen <= XFS_LITINO(mp) && !xfs_has_parent(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
 	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			return error;
+	}
+
 	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
 			pdqp, resblks, &tp);
 	if (error)
@@ -233,7 +243,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -315,12 +325,20 @@ xfs_symlink(
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
@@ -344,6 +362,8 @@ xfs_symlink(
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 out_release_inode:
+	xfs_defer_cancel(tp);
+
 	/*
 	 * Wait until after the current transaction is aborted to finish the
 	 * setup of the inode and release the inode.  This prevents recursive
@@ -362,6 +382,9 @@ xfs_symlink(
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

