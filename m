Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CADC6FA82
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 07:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiIWHWN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 03:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiIWHWL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 03:22:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E8112B4A0
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 00:22:11 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28N5eN3K015039;
        Fri, 23 Sep 2022 07:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=KQZ8qcY2L/RfA0vZtJuvwGzG2jCJFEyfsG43CLdKR6s=;
 b=26RIRobofPm4PH4RyietVSBGUUp8okreztmREzLzmmxYqPfODGyCAuPWZvf+eEQD5bfY
 OEVxGYz52Xbu4q+H0aOjqts9J556UDU2gBjZHoLDNIx86QaMzZqwGy8H0gwUHSE7jJDh
 t+RZ2N1KiCxIp66N2uFb3TVXaoQSKx0KmZyNWONvqMzfKlOWc4Uvoro4Iki8PYkigRaQ
 kvt4LdqXpiajNUSARDFVY1wUqLgQUnYt4Vgv6EFWJy6VNQuC7n0z5Cc67EGPS3gJBZZ5
 IQB2KfjZ6imzzorO3XNTAI70xuZmFcMC5ndeCwmwpcAQZjFqKWJ/WPfFsRKX0I/lrYXS kA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kysjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 07:22:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28N7Ektx032427;
        Fri, 23 Sep 2022 07:22:05 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39gvc3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 07:22:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/zgt18qtLgncySIddu3/Nx03nC7W7tPlMKwuLBup6GMOuH7iC/rdRxupxN9gkhYFaXruKJnQ56O0lnGEVdWbukR2UJptNzmnRExXijSoI3hAXFDcvVO7CrNIoKDfyLgt6evL2cdorKQs2+UXTtQS6aKX1v8HVGGlKknzLZPE+olv0FdX7S0d9o9xI3B9cJcOMG2Bc5RbOg5hMWTLQULjwLAUPMIwTjWl7Gw1tPqKw554IZXyO5JjotpPE0VrJAald4Cr0TBoswf6GLajd6QSYUyUOUnu786pAsOhOApMWsGFIoeLSv7o6B8ELiUH2YDZr4N58e5XdaO2ZJaNsJ6RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQZ8qcY2L/RfA0vZtJuvwGzG2jCJFEyfsG43CLdKR6s=;
 b=IgQQidaXSDp7txRzA/rU3ALV/ZWh6YiDY3swMRMNjy7bRS53qXc8mTAJIdyB5qd7hiwB30g9lV5TnKSxgVXeHROvBwueZg/FX1JYdmOugdFmoNLSTdXW+K32qkclRLB96189VDvFers/WFkFw2THFndKV9+IEn5LedRNH4BF0dWzXUuzGi+kJSqLGwYQZbRBLnucvXsuPYx6y6v/T/MpsbckGgqzMQwzhIbpIGbBSUpJ5qCydBdcZF5UZlAPlMAEbsloLoCILrZFRqTgeKNY1WOgYya+Kd+7IAGFl+VPXxwzXyMsvU8+Psg2+cGotT1SREGKqwbLEI86t0xlx3niwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQZ8qcY2L/RfA0vZtJuvwGzG2jCJFEyfsG43CLdKR6s=;
 b=xkAdi8zvwAHhQe1qOhPpCkhy78Lp47nIa/pR1itKDdB8zrUT/7DivW1LcQPnvAftcRB1xVHWIaY/U2wUWhIZZCTbfK2C8kK6POgeCp/R7JHRpAz7bvAMGLpVNXZLBAkXwsAIFAd0wr1+fHjxH94A/TOvE1nEEcMYJ4l3zq3FcxI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5264.namprd10.prod.outlook.com (2603:10b6:5:3a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 07:22:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Fri, 23 Sep 2022
 07:22:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 1/2] xfs: fix an ABBA deadlock in xfs_rename
Date:   Fri, 23 Sep 2022 12:51:48 +0530
Message-Id: <20220923072149.928439-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220923072149.928439-1-chandan.babu@oracle.com>
References: <20220923072149.928439-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0130.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5264:EE_
X-MS-Office365-Filtering-Correlation-Id: d72d5db9-d887-4d62-0472-08da9d345016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mIGfQogRNr0tWedMSR2jo+SbYJv6i5+8VDIB1t/5Gi3bAiso2RoNDmsL3bhiUOiecq6wZJluUykLH6l4NwjnVLUmAn1b72L+tOBuD7HkOhqPaE6FWXr5G/qT6zXwW6n/HH+uLvVm7Zm93jab8+TLR9pnu8Gt78WBfMtZzrwJpZ4gwUEVc24CRz1gDC8U2njxOjX9cX6W+2uuKiICTRAKBOGoHhwIvQ2ZIiuF9sLRamPmXutZ45mdMKRHGDh2QI9fZXbjJwRf4YQt7pSitqfqgg1irgPcUFOsazkHxokfo7QMqpokA8FmpmCDQUNfdbM034m9IKWkR36Qi/b5uvrlfH7X0qN+VOxP2eUWxLFLhJMWQmyr973d71HHVFE4eTlb5YDjmTYgHqQuyQtcEhgHACNJiQI+RrL64iS2ZaLGkHWo7eh33wl6FcHEgPj7Lv/53Ilfa1z8nhbyjMuvUXAdJnwy60HlSJhG5oLMdtRzcXdMzRNeG24UPbUye8fUwh4ag3R4LLTHeaxcSnMm7MhoV9+SOYL2yBz7blKHy87U4tu3go5uFR/pPfdrFPRMKPe5DrjKmHgpMYiRm0jlfGoYzBT7oBfCBhJcRsRV4CWtDfPjWnigN8K160oMD6D3o+vYVerkiLefHntzECaesmpqulqdNs0iq6nVI9riVNfHujpZ2neneojzGp+cR+vfjFW+SRVpc6MSC301L3DdMTPEyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199015)(4326008)(8936002)(66556008)(66476007)(66946007)(38100700002)(36756003)(86362001)(5660300002)(2906002)(6506007)(186003)(83380400001)(6512007)(6666004)(6486002)(26005)(478600001)(1076003)(2616005)(8676002)(41300700001)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TYkNnlw4vNqid4PNAwb2CNWBUNEa9pNR3qjB0eAdi1cjEeAMojHbYdKlN4GA?=
 =?us-ascii?Q?9fkPPOBeqP8Pe7wLsAH9L5nShYzj3nhlEORZgGIXVYaM67ajT7sWcS7wtnZh?=
 =?us-ascii?Q?8WWRYOzofMfUW52TLKCCECper9obq6Qnjoq50qtZsvziEzx0OkZrt6ytH/B+?=
 =?us-ascii?Q?ky4kAK5qFjCx5XPaDwIhsi6+TVXxypcz4EyWhXaKTp/RnpgaPt4tJngwQjcY?=
 =?us-ascii?Q?PPRUL8Ix6nOaMaIeSQGzkFYE2lmBPvllh+5H4HZg5hidvYVctq1o+zN9SF65?=
 =?us-ascii?Q?nLJmlOZXDTCTH8gG+U8UuISMmpLaUlKJfQwjTsy+TVYK2bhZR5x3bBnuSq7Q?=
 =?us-ascii?Q?3CZmi/jxY5/tT6TB9ImODRfXXzBSiinY6pRvCNV3x1cO4qN2OfVRaPnWpPmR?=
 =?us-ascii?Q?h1o/DicCqunB8T+WnwDzKN/+V+axwVySqJSvpom2jNcTliJS0jLn5/Jx7L06?=
 =?us-ascii?Q?BI1dlwL/9nFkSll+oMhiAhjmlCP+I+0Ewcsg0UWIPyR1WcuNel9zWjnB8pzz?=
 =?us-ascii?Q?N+aoAmOsQeElJqMzrvb6yziXHxPZ7KwUTjRmPjBJujn+f71+gAaWvcp4v35/?=
 =?us-ascii?Q?tvPlR+2xAWgBpz68xK1LxmstQhRmu8At6DqymR9H76XXRkIfi/4LAoxDaj2e?=
 =?us-ascii?Q?DOSjt+JfpMeplHqGShQX8/IOmTWVMZw1M3utyHYPFl5nsngQhvRyW0P4GBdJ?=
 =?us-ascii?Q?kRu6Og3HEu0CYUIZbC0LE7ggHagPXlGuf2EXnjk1oAtjmmRlrxwwWsxR2oAF?=
 =?us-ascii?Q?BR/B7UBmsh5WB6CAuXNKvFqUcdzu1poZE99pY5b6+Gna4rtVlS1xclw0rdjV?=
 =?us-ascii?Q?/dfGg0HmdvW0yrugeNHE48uHfagU1LDiK38lScl6ZYvCGaqg6vyZMJcXSgZ0?=
 =?us-ascii?Q?7FdEe+cNdxuCNvLPLv6l8ppAGZJ8FcZIUcp5YixT+wRLRHrUjaJvwir4QzkZ?=
 =?us-ascii?Q?KHa4m3KvE9spi9JpvEdI1zXgtQhc8nTwV9QFw/E/+NaqTzy+doDqnU5KLZ+j?=
 =?us-ascii?Q?p7CLSQxUXefgtM6cY3lGHRT3hsBDd9RdH6Ln8E3jy/rmlibUN9pg29zPjUZh?=
 =?us-ascii?Q?KF54JnYyBdd/smTY5qgMIfeX06JjAh/xgBHeiJM7fbr8/GdXJHUlXBJcyZAo?=
 =?us-ascii?Q?0coKM+Xvrzt0bdH0bljWU4xFJINV5NKyINKvjmrKzaE2xY6s4UFbhajwCb/d?=
 =?us-ascii?Q?Q+LILDLr2LTLsCkAc3mnb1o195+BfBymkB7P4mXaNmHAUpVIGu3gIBIxfrPq?=
 =?us-ascii?Q?dJhHCbpB/8T8QIyMgEQpMMqFK7XL42JGJbgueQS5C2pXNmSwzoM3rxLNBEJg?=
 =?us-ascii?Q?bV1cvenHWXyJ0+LhLXAzd478os0IN/cMIGpfJv7eurevCkN4sjV7MGDaWWOp?=
 =?us-ascii?Q?hVvpHCYrLIzqlTjxRipIW5aRlY4LdV9XAF0XbXVg1IT6mbpb2rVj9uzw/HIT?=
 =?us-ascii?Q?Y5PySwukYKcm2qtKidF4Qi4JTQU3vEM1DDCj3iDjyS7cP8dlMJ9UTP0WAZBH?=
 =?us-ascii?Q?sUN7+k5c9yRCje9w63peE0Foj1n/SodBjlSSNf9PHUzuzFCfFQLuuAb9+mCe?=
 =?us-ascii?Q?7Kt9M1eA/0Kw2Ockze7Fstt4QbTAR4lZCdwpQwmQ87+ruhLQ26Cau7d7GTSC?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d72d5db9-d887-4d62-0472-08da9d345016
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 07:22:03.5871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CyF1j9mGHWZlvlzbkgrqntniVHnDDycoEEtvS9Pt/mxrM5l7Rb/jlumOD4rop487K9LJFgkiemYu86qprlam/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5264
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_02,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209230046
X-Proofpoint-ORIG-GUID: zF4MPerKvljdvLsGDdvR2BEzxXf66zOG
X-Proofpoint-GUID: zF4MPerKvljdvLsGDdvR2BEzxXf66zOG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 6da1b4b1ab36d80a3994fd4811c8381de10af604 upstream.

When overlayfs is running on top of xfs and the user unlinks a file in
the overlay, overlayfs will create a whiteout inode and ask xfs to
"rename" the whiteout file atop the one being unlinked.  If the file
being unlinked loses its one nlink, we then have to put the inode on the
unlinked list.

This requires us to grab the AGI buffer of the whiteout inode to take it
off the unlinked list (which is where whiteouts are created) and to grab
the AGI buffer of the file being deleted.  If the whiteout was created
in a higher numbered AG than the file being deleted, we'll lock the AGIs
in the wrong order and deadlock.

Therefore, grab all the AGI locks we think we'll need ahead of time, and
in order of increasing AG number per the locking rules.

Reported-by: wenli xie <wlxie7296@gmail.com>
Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.h    |  2 --
 fs/xfs/libxfs/xfs_dir2_sf.c |  2 +-
 fs/xfs/xfs_inode.c          | 42 ++++++++++++++++++++++---------------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 01b1722333a9..f54244779492 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -124,8 +124,6 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
-extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
-				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 90eff6c2de7e..f980c3f3d2f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -947,7 +947,7 @@ xfs_dir2_sf_removename(
 /*
  * Check whether the sf dir replace operation need more blocks.
  */
-bool
+static bool
 xfs_dir2_sf_replace_needblock(
 	struct xfs_inode	*dp,
 	xfs_ino_t		inum)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 70c5050463a6..7b72c189cff0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3224,7 +3224,7 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	struct xfs_buf		*agibp;
+	int			i;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
@@ -3336,6 +3336,30 @@ xfs_rename(
 		}
 	}
 
+	/*
+	 * Lock the AGI buffers we need to handle bumping the nlink of the
+	 * whiteout inode off the unlinked list and to handle dropping the
+	 * nlink of the target inode.  Per locking order rules, do this in
+	 * increasing AG order and before directory block allocation tries to
+	 * grab AGFs because we grab AGIs before AGFs.
+	 *
+	 * The (vfs) caller must ensure that if src is a directory then
+	 * target_ip is either null or an empty directory.
+	 */
+	for (i = 0; i < num_inodes && inodes[i] != NULL; i++) {
+		if (inodes[i] == wip ||
+		    (inodes[i] == target_ip &&
+		     (VFS_I(target_ip)->i_nlink == 1 || src_is_directory))) {
+			struct xfs_buf	*bp;
+			xfs_agnumber_t	agno;
+
+			agno = XFS_INO_TO_AGNO(mp, inodes[i]->i_ino);
+			error = xfs_read_agi(mp, tp, agno, &bp);
+			if (error)
+				goto out_trans_cancel;
+		}
+	}
+
 	/*
 	 * Directory entry creation below may acquire the AGF. Remove
 	 * the whiteout from the unlinked list first to preserve correct
@@ -3389,22 +3413,6 @@ xfs_rename(
 		 * In case there is already an entry with the same
 		 * name at the destination directory, remove it first.
 		 */
-
-		/*
-		 * Check whether the replace operation will need to allocate
-		 * blocks.  This happens when the shortform directory lacks
-		 * space and we have to convert it to a block format directory.
-		 * When more blocks are necessary, we must lock the AGI first
-		 * to preserve locking order (AGI -> AGF).
-		 */
-		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
-			error = xfs_read_agi(mp, tp,
-					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
-					&agibp);
-			if (error)
-				goto out_trans_cancel;
-		}
-
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
 		if (error)
-- 
2.35.1

