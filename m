Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00081C6379F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjBIIC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBIICZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817632E0ED
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:24 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PePF003345
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=Ubv9KfwwPBg00mJ7DbZY/cTUoJeDp8HC1BJELHqsjwg=;
 b=qaFUBtKhZ+5suFeEiXqWd5qzNAwRUXytMqefz7x6AO8OKfeLy/LVeTMacM6mabWp1OZw
 MZ2xDAsbzv+mngnaaUlsqJE+rAMJu+cG88RDIWH3zneVMv9Sz7oQdLFzGxnnEPu8Lk5K
 sxdoGcRQ5g7JNcgRZFqD1n5Qs/pV6nyp6yM/P3Ks5KLCdJra1REqIjFaA8lmWQN8TR1C
 HHnnQLPK/JcG71ZswT7NdXVTRZta+szTarIZQRghgpm2Vx5HIimMvj0jsYj0V6QmIzLf
 mHsptjchw0IscopXZ259lsfjJXhx9VJDE2c1u6fH0o1dxgOKyNFcQLXgut7yGGTmvGc9 YA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhf8aa44j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196VLoi028396
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdteyg2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8+alAKFt4hYCScqS3YJXujfnaK8BlZeshEZ8QYQ9knc8Iw2YM+1Pf4ESnHBI12m5xnfospazkYEa+RQVhKGfYd/ldHyk+9giiflYXl9JCI/Gux2k6+oZn7vgS2CwPAQxxyO0wSbh1mHIblSZ/oHhk2cbj6844ZoWNml4oKHHOlMuC8jvWJHxLF/FwgzjCpCsuADQ5vsm1Ie8hobf1WXw4hN4w1HThon/jG5Xj8jvM5RoVHCz61tt0aTWrKv8V7fFVbka1YGF779bPbIeKMDZAinTXbWnEC7AR/ERCah8GLP6VjQVB7KtLJFiZcYfkif9PoC3Ft0mxguYUPjhFxGbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ubv9KfwwPBg00mJ7DbZY/cTUoJeDp8HC1BJELHqsjwg=;
 b=fcwCkbW+oilhue+oZ/B4hCa1iExfC86yQkkaAoueKqLxT/KFvSXuKfKde8qFGKqleP0+edVAtkwOceSO45oGDFlN5TOkW+xDpeWgSu/gRk8ZxAlOa1fODGoG/yp9ELKcKzTSJNpIYlaChGVBEYArYPHgLvEmwRNg4RJd5UyjjahN0Cm7sc1fEngdmqd+FDbiCtqSip2dd+vx7/LBeMnZCFLrB05qjYvr7nzK7QYrc5teRhD79l6u3MzGFSt7WQJs3bLSsFRvxXqHl/Jgu1C6enExN+aUO7rUdY/mkw/FC9bAQtKdsbrpcpoaUj4ROP2dAPhHIfOB4OQpOb/9mIDEkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ubv9KfwwPBg00mJ7DbZY/cTUoJeDp8HC1BJELHqsjwg=;
 b=uim4lwSvhCvP0j295MozWKzVUwR3qqQ03aNoskPLL+uL4jis52jqGkCo1BmwKFFqs2y+n9YG3HXt2raQw3BzLOCksi3V5zCmuelfp9GYttdrE3+d1D/CmPLz+GCs10G2p66SuUSIdLML9JFhFjs6fAH8Abp1VBzaWu7OxXKBB7A=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:21 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 17/28] xfs: add parent attributes to symlink
Date:   Thu,  9 Feb 2023 01:01:35 -0700
Message-Id: <20230209080146.378973-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:254::12) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: d5038ed0-cb99-4886-d20f-08db0a73f88a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 98HoU3wJRvIlHFfQklOQh6WVc1mutvzN7aTm37jLhXvqpxHh/YbMl0a6T7hwGrFICpGOcIZwM6acWB+f2h6TnYOGHV4K6HYynaGhF6fF0ro+OoPiE1fItFg7P0npfBqcbDyClR1bgROPlvhUFHF3StW7dQ953byqvmPowGQZS0WgKKdgJyPM45wBaMRbbrPCCGfz0VUEMLzXUUZz1H9AefgMaienJYDRNAt0PHe+poWFsOWexmdeT0aB9Jun1dWVoV+1vCdZyxZfol775net0NmFkI1wdbE3JkoT2XQi62GOcJrjQ4PUU5GfnwQwIlma9WvfddFmNKzzb+eNyWhmETXqwAh9G759XKvucmdWSqeMdEh2PJJHG4s5OAQMDXBcGQHAU+k6EjB3S+Wgl8rzi9fLcrlhMbU0M2yA/LNmcrfRMHZ44s4IpLwEg9Jv5opUyiOeAWBZfohenqhbcONEbcSx8qgED+2pLg3pDcBXJgecj8iAvwVJOBh9O5loUUcnDZnXq4ljC3gXUK8XO4/npwTXJBseNEXKYkW5g34KbyjegYZfdBCpmjb1mvkfQWVTgzJA4mQqKOV+PB5ktA/BZTHvh/7onxVXuxrZvYyBs1TUL85hu8KImVGyHZJ7kDPUI/nAMUa6rVYGxXQMT8xlrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zgyqRQ67tFtqBno/m+3zp7HMhxkucLX6lpUDfFTl8PqADeU3Io7MZENZdeMZ?=
 =?us-ascii?Q?uCXt6Vy3jVYi2LDZHmEcUfFZ9NB3swZ1kXskwXSt7MRGa7VZ3nLffUoEaQSK?=
 =?us-ascii?Q?ppz/2jNsBDIZTch6EksQkyIDWqNgMF1FPS7fjRxEhZMFNU6kPkKeOH/MVDTG?=
 =?us-ascii?Q?PojqQ1QEBWhkPP3PcGhyOypJxQVx7y+qqet7wRobGN3udnnxxcyqQ+tQe3Q/?=
 =?us-ascii?Q?M62VpZLkEW1DPxMB2uUI54O4XW+Rqz+QKHf6VzTt4BOQ6V+i08OCdPxlT/VN?=
 =?us-ascii?Q?soogCEIoSA3ERqbACS841lEURLegWpda6Z0d25aDtkVts53GGg8cuiw9eskM?=
 =?us-ascii?Q?eAjI8F1h9nriAnN0ojTOrxfYw42/qKN2AaePoH9ymD5pINvELfUTYcDSI/wT?=
 =?us-ascii?Q?2XH6tQYUz4zZ+sHrVhNgeyPwqyjtKFzHqqJc+nTJmDpFPq9U8/7B4o0gPl1E?=
 =?us-ascii?Q?D+kAz0Uh5rSfJ1SKy5Jp926mK8BTEQRmUu8V5PYz2+yYK9X4NOJKXtMDiqaq?=
 =?us-ascii?Q?1mA9VklHjMcEx7x2qGr6Dnm8g84g4tuusB0m8wPSQlya+a0uqIpzZbxlYli7?=
 =?us-ascii?Q?+rzix31z74xMSX2iQ3m/VjOYpkI4+IZqsp0G3cur7HNHDbgnPy/4jwuCU3op?=
 =?us-ascii?Q?uqadPzn9a72yAOvlMwAglNw2n3Bvo6zonbN/Kc+ZEmt1rtkyuR3kpgcjYsxx?=
 =?us-ascii?Q?i8HgJxq+KYlF3yNlE3TTmW6ySoYfyJnMFRN7LDwfc+mgYENfUDP7Tqt+fnkI?=
 =?us-ascii?Q?XKP/MiJXQYnkA110XMRus4D+FtBAccrEeJfoQNv9cVlMwBOOo6rBG8aihTW0?=
 =?us-ascii?Q?w6d7GRL3Fu5abt/LPKGE8Rcu3Khj71HpBU45lbExK2wXlfeaF0/s/ElMpxt9?=
 =?us-ascii?Q?orD+svHNgrzGGHccD6Cj4QScYGiSF9gBKH+zmYy78wL69q0FBIrEfEsIKfjM?=
 =?us-ascii?Q?X6LME7+KjnPFkXLhBPDNtsV4usDsZjaQrjL/1/niVOO6RJ70tzvvx7/y+6rB?=
 =?us-ascii?Q?hTPXwX9pl88pSOpvNuOKBIhsm5oMOAnRuHSqj26Dl+T88ciPCrqmU9xAdJJt?=
 =?us-ascii?Q?4+pzC3Om2I4Z/n44ArO8si2btM1gvlm5sOVd7iL4sL01c5OEm/wHEd5cQW3l?=
 =?us-ascii?Q?xX6tyrkD34Puyvd80uFc/6sYuMGH1k0qqACzBixTg69oOPyw1IcyLxwvlk3e?=
 =?us-ascii?Q?pQF2jstEtcEfqQuq96EfPBHKeeF+BVw1Nod/ec0RvC9/5j+r0nJySanque55?=
 =?us-ascii?Q?ELtv7y/1itGVJ26BaMQYcFLfWutLX1YuP5kEQHl5k7yIgLD1I1Qwrc8fyR4U?=
 =?us-ascii?Q?JyhDR2KXwkLET2m5mhbsT54iz/Nw9nfjJtzB/+7GMXcOmmZngMY7EqyGVtV5?=
 =?us-ascii?Q?5wLXhXiXo2G8+cN+oC2N9Fy2PP0td220gQrVltEVBBlGDm6k9FxDIymuD4S8?=
 =?us-ascii?Q?G1i3MCQ0aaaRb6Aas5js5IiqjIz6f3u3ZwGIRPKO4J4Y1PKsN+AggQzJ4UYQ?=
 =?us-ascii?Q?yBN5f/+shnXOR9zw7uRxCQsshcBdNEcFmF2dU0HiEwXWNjJNnOFcJ8J264z1?=
 =?us-ascii?Q?/HpvIA4c53wuOncH+fnbh1TDLmKY1IfUiSFfk139/xJogzSH85zKM23lB/kj?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gj+ybWcmGievfR26rjqN5nlzqB6kuHN17L7bOkubfidhU8DaD58E418svsM6c61pcWhUOPtcdVLUUiV3F5p9aBY2iCrDwfcsMgDEhUxP9XAGDLeSc8hs2ZRjeQIJM+RN/n46wFfJdC+zs4gnBv/CpTs3V6RBinofK3STxRsx4eWDfZJPXx2b3nQIfUW9Dw4GL5Kgvn+XeKP5A8/Sx9ZSW/iDUJObqCgs4BEhIb+KmxplZmm7p/Ivt7XzU4f8ThoqSsgCvnf5HnFgTK1I2/1olgwdT1EUUSoJ/LeRbr2cemRMZh9+WxDt6gsd0XEVZugLen1Ra2FQYpknQKZZJ+8uJLq3YTM5MK61JChdh1zvTxRANV/fzF6yIAjbG6YYbtBaI8L2ovx24gq3iWR5BzYLb0tPUvdYu7Kqodd5Aymo3DWoXKJf4YDKKk91eN9vXfljRiX5xWhzwWtqrtp05zj84A5rAiWSKfMfiw2aQ636XGF+eT10EojjAY6dhcL0dGWTrOpw1IAhCpGQzpkI6YK73lvo4sUTO6mbelwB2EBkczuq8GZ/Tr7eX9SFo/AMqOkyQYF9seuAm9RNL3dyISheXvJ0wFKHrBhfG6PTcUITJKBYya2Jz/i7b1QgQCdzUlnfXQ5KvqZMpERveZYT+WsiX7vZWZQ8/FX1HQW1y3939LH3MiZrC4uHr4csU/q4NOcbna1uOsBp4pkezNIcu2JEP6DGOLXSaxxWvJBkxiV2G8W0bCG79Oqjxzl7Y/b7TUwM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5038ed0-cb99-4886-d20f-08db0a73f88a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:21.2608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1aAgQmfj8TxOuWYvVgNtIsVj+DM4L/VKxGoaK02mpUpevADIhjM7csZmoLgv7ppKFAzVNDqgR3xTk+o64qBerWFkeAJR6nIGCsmwkCy0vCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: v11u1n0yMqT0RcSDZ4tJ4KHSvseVVl3J
X-Proofpoint-GUID: v11u1n0yMqT0RcSDZ4tJ4KHSvseVVl3J
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_symlink.c            | 58 +++++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 12 deletions(-)

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
index 27a7d7c57015..f305226109f0 100644
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
+	struct xfs_parent_defer *parent;
 
 	*ipp = NULL;
 
@@ -202,18 +223,24 @@ xfs_symlink(
 
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
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto out_release_dquots;
 
 	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
 			pdqp, resblks, &tp);
 	if (error)
-		goto out_release_dquots;
+		goto out_parent;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -233,7 +260,7 @@ xfs_symlink(
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
 				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
-				false, &ip);
+				xfs_has_parent(mp), &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -244,8 +271,7 @@ xfs_symlink(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
@@ -315,12 +341,20 @@ xfs_symlink(
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
@@ -339,6 +373,8 @@ xfs_symlink(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return 0;
 
 out_trans_cancel:
@@ -350,9 +386,12 @@ xfs_symlink(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+out_parent:
+	xfs_parent_finish(mp, parent);
 out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
@@ -360,8 +399,7 @@ xfs_symlink(
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	if (ip)
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
 	return error;
 }
 
-- 
2.25.1

