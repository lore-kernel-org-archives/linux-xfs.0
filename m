Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E9DC43217
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiB1TxN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiB1Twm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF983F407E
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:51:59 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJHV5010129
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=R5DCLNvwvumpCBIyl6hbHekNKdA/OXUU9yNoYpD0DxE=;
 b=OOnl5LFzVsm7zA/XpBd+mM2NyvE4rtmKoYA4zxBrHRY2/L9OjywdvcN0iwMzDQGw4+dz
 XUXvb3W01qxJ4yfwPFXhgnKIbCrI8KW7pTT/iLWjrRWjBnQTV3BBwim7oTnly5hYT2KN
 KXDG6yOABlXhxKN7U4VuuWerl6S/ezaBrGJcvyRUDeR4nstKN1sjS1V/QtViPJO6PWmn
 Q1goO9WxCsrZ4xIXjnJAm3dZ/WlQ6cwK/YsIFpaHL/ttoYgy6u3EvOsRV3kq5Ko0kXAc
 T0pp3ky8RwQJMwp3bzz5Zd20YZIMGW3i8xR0//22QZHPeD5XNm9qCEcGjEptTVTrGW5J rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k40pq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJkltl076550
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3efc13e3fr-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zv8hO4ND5V7GnH5l27smOEOXdjBz4TB4p54xoOnxa+UFhuv/ZVEvmkQOEfrqav0dqO5CHahHVCwusYk2PDg7qPWpTaCAvj+2a7c+BhVLz1qg0klJqUDMQjABHDyp6aBhjWrJLxC5UypUSU6g9qL9ls5we343HhK+a+RjaDywn6+Ezy6QYY9wNarQlD4vMjFifVo61Fpvn+EddmqtEg9NesWE5114yShTZM6nTGamq4GPYmJIP/gh1Qlj1nckDf0ZogXkBXzBrEiEtKRFbApaBKMrMVbFymtEIJPs5Y6oWi9Uf0n1v2jnIyNaTx+2Nh8SqpZ3Ew50tZ0FM0YpAOTWTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5DCLNvwvumpCBIyl6hbHekNKdA/OXUU9yNoYpD0DxE=;
 b=R61WBnX3NWr6XSaVo3vgNZD2nCIGEg6//xYeAjHi4LkPAvGmU4h+VaA45d6ykX2LizxbYQ4iQe4irQVNMKggewMy5hQ3nYl5g9IIU4dfBXK0x2rqSRvtz3q4xzTuTaWoECtcye+Yi4Lr7YNIDtoGuKurPppr/J/+qq3Wo1goTg2WW5sWxJoDxUutDrMQMVkPld0ghO7MFHllWFACQQSXagB26T8gUrx32g3xs58FzTGxMAxSMv71S73obpP4/Pr9DKISRxaitZ59IgHvUlGy/kas65P01r1+PYGKwjHZwhdopKxxj0pxpIuwqRECttMMSEQaxRlaELIJs6kpnIFBXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5DCLNvwvumpCBIyl6hbHekNKdA/OXUU9yNoYpD0DxE=;
 b=eP8Cmvoro7zEa7S0D52PxsaAkBpoesSQygaPZ1T3Hw/42FQzGhjtVhZycFH8gUSdWLB2N4JLQ10e7g78/EqxycXkAEpR96+VPDhAFy/6sICOu9I0EBad8G7g0JdmjEy3XJ17aLRv230DsEtDklQvM9pcUN553vXTLefc8kTSCz8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 19:51:55 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:55 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 05/15] xfs: Implement attr logging and replay
Date:   Mon, 28 Feb 2022 12:51:37 -0700
Message-Id: <20220228195147.1913281-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228195147.1913281-1-allison.henderson@oracle.com>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5fa0d63-2fda-4b6a-9d78-08d9faf3c5f0
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5612DA2A854D64FCB8DD0D8395019@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 88h/xZ/GLzMQTwEAf8B7sjWWD0zKgn61xbqPi1qylGikqKUXbLF624SJ6lbCHI8cUDf4C7EREEsXBRXeMWccjthrDxAQcx7ztkjwZR/e5Xn9OiaavTEXqozQcfroHdMKNugoLF3We5HrXO+TkX4XX4aobDch/iHYcgtZqEfSCzgMZW+xZC46HMyo/MXpyr8qQwsXf97sQsLAOhguuBvqFugj6rBf1/AST+pChwr/S988EF8ZaWTIa/Zm6ITwMUEoCNvJo0JBTywr+qsKc9OFBjv6/EJhAKwRINFArXSNea4/Uj/IRkywfeDmvsoY3bVM366XsFz6+17m827BVRphQW78mZ7Njbbjmov0y0CNX8RC3xMfj1yk24h1b/b9Ur0M66oyKwmvDJ37zXdqh3Nd92gOxbMocl5sDKcy2eU59aS3suPOWIAd9jcv99HyTL145nOKHo/OKZ0OFgLubnrkzU4zICArQ0EQyxpK8vh6zGF/Wp89d2FdN2KSlHIHIbdFyFgtn0H0sHhP3tkV5xV9AeqyohJHkcWon1TS88sercj/lsvk/2npY53juII6PneWzBY5tQDtUc6jq3eJCb0XcrK+GC8Dd0aT55p4RxntHUOy0EFxl6EU45W3sENRzY+cOiAbEekpztbZxSTZv2Pw/SFrfNnZWW+x+trdmTljxCyJAPvhKR3UZTxVir7vyTCErS/BrP+XyiETHyPhGpT9ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(86362001)(186003)(8676002)(6916009)(1076003)(316002)(66946007)(66476007)(66556008)(2906002)(2616005)(6486002)(6666004)(6512007)(52116002)(30864003)(8936002)(508600001)(5660300002)(38350700002)(44832011)(83380400001)(38100700002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pZIXThK5/iBuxkeYik1mpLVHhH8haFqTe6+r7W0Qb5/yMev848MCuBIebt1C?=
 =?us-ascii?Q?D29J1GTucTaYb0AXcwO8lqgdQtGEmq7lkFuD/umcycxLJ7tvDMZ6KTC8Hz9R?=
 =?us-ascii?Q?i6/+ypqZioiKpJuBaUEYjw8ZmKV4YAWq0aY+LlrSNWx1MKMU1UNeBTWgER6b?=
 =?us-ascii?Q?6vPGfwyOtMsW+AqGAPD0CshZcrwZbAjZS7AzBBPSSp3IevjvutbQCjkahrei?=
 =?us-ascii?Q?5OsEHpsRuG2tKNle64EXi0SPoCOVJaHC+bUGeoWp6aDU5yRoA/gJLZzo6cCG?=
 =?us-ascii?Q?VvLwtSqsHiS6EL0A01derJ/ciUI+ZWnw34UmA+JE12BlSdSa5O+VdPikA2Ms?=
 =?us-ascii?Q?2s4KNbIf73A9DxRXfBf5woV3evRASB7Zcgw7YwndeHWZSgDuijlNv1093IkT?=
 =?us-ascii?Q?JEXDE0gErkPoGFf6tpJOT7qPlJ4T3qtso/c3pUqlD93pSPocITaF8P0QbPfT?=
 =?us-ascii?Q?xkDUsHg8/gBb6DVaSpircgBsVZEygYttBcQnqIVK3+TPlZrjTIaDDRTOrCbv?=
 =?us-ascii?Q?VtKfdJp1iWQM973CsePUqWbibdlbOAGk/j5LXc3T4edfEQgb8dVBJDq0iqb+?=
 =?us-ascii?Q?9UMlc8gYS+lSU0K0o8zd2lel81Oc6vAMiQGa+4oK03AQb/0TQxvStoqG/uer?=
 =?us-ascii?Q?AQlnHQewH54dM2c5eBMpDnW9Tz0IhW2U9WN3dd/nV8YKvjVa8awJGM63HpVq?=
 =?us-ascii?Q?Zjfgb/UZFF/kLiI8DZT5HKCtQxk4qxVJ1suhTwpAUOJh8w9OYLr9AQSxt6Ry?=
 =?us-ascii?Q?7EMrALGtBLkm28DtGURLf7rZycVFItvMnlLCTNeWqJ/QqND6MVnyiv4XHzlO?=
 =?us-ascii?Q?ehKCqdYeSPcouOZTasX/lD1UHKcI7e8olaPNUILfV0aYI1eA4MXm3jIIBYQw?=
 =?us-ascii?Q?iNxxUw+q+S9BXy5iR4960Cr1/kwCBHGAvIxaxpMJ80sSvollM2rOqKDoAVmH?=
 =?us-ascii?Q?f5GkvLIfv0UIUwFQpG5AJDnCR07J5FQ72nmvs0BGHqs6YwlkDszWT+cYuoGA?=
 =?us-ascii?Q?cmYak83HY+xiUBiST5z55mbDQh8H54BnXzDx7ODUz/Oybv/NXrEYef2zKV1W?=
 =?us-ascii?Q?NV3WO4fObFAoOq7+XKKRpwpZGgL1olJ3X7Ku6qf2nkSNe9ECltHOAU5NIxrn?=
 =?us-ascii?Q?7XRWEgvOAViGe4O0t1xlPQf+TqBBS6QYM3Rh4bqAtsJZu3QNEJRVqbadzSDo?=
 =?us-ascii?Q?ecK/8INBZVMoiubLqf7EcDRiXjMVmcH55oIWxCHvzf7YgiGYK5fbqPDxX4Lf?=
 =?us-ascii?Q?EpG/OhaSc0Yi/+WMYV8GOQd2+ZbnS4QeEhIR9nYI6I8vqdIIJ9pxrauNoHyx?=
 =?us-ascii?Q?VzQ3EjcyUJafHKdSCqURSwt9FS2VnqeRkvwInfUosj5WRz3q1mVjX1dOUrkf?=
 =?us-ascii?Q?Km4yB+wlj8kwv3Z4DlLG1e+Pn1m6tUnANeTtXJMkpWoEMAosDi4lVw4lAHij?=
 =?us-ascii?Q?JUzW8rM0CoFQlSj3nNZ8BfL94a6tbg4iy6wFt0vI8DIe2mdyu4CB/V+EKFUm?=
 =?us-ascii?Q?ibMCg1jTRUSV0UgP0gY6Z0lHhM18fORtNA4eQJbMaa4EyPrn3pdgIB2gpbMf?=
 =?us-ascii?Q?hfxhgvbp/YHGCUpZRSypNb7tGh0pxAOgQgmYf/uj/+hw43iw7mpEh9H7xfhG?=
 =?us-ascii?Q?RH5VDGjvybFsj2/fd9tGOvV8WNZ7ANcgENbyqQ2dA1ypypjKpEwWoOi0SAnR?=
 =?us-ascii?Q?nCodog=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5fa0d63-2fda-4b6a-9d78-08d9faf3c5f0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:55.6544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /U4kTRtgMHpfm+jbl0udPPkjPcd8ALURyzynUifMBTL5vFpXVGGbONEK7NJkDtL9ZmY+lF0AYWEOOzs7DWngVzVqtxGh1gFpZeBfMP+Lm3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: SkpFWklF9HCMHrSIWeGJr5bN2XVuawhZ
X-Proofpoint-GUID: SkpFWklF9HCMHrSIWeGJr5bN2XVuawhZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds the needed routines to create, log and recover logged
extended attribute intents.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  |   1 +
 fs/xfs/libxfs/xfs_defer.h  |   1 +
 fs/xfs/libxfs/xfs_format.h |   9 +-
 fs/xfs/xfs_attr_item.c     | 360 +++++++++++++++++++++++++++++++++++++
 4 files changed, 370 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 91adfb01c848..d15c39d21e86 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -186,6 +186,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 static void
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index fcd23e5cf1ee..114a3a4930a3 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d665c04e69dd..302b50bc5830 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -388,7 +388,9 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
+	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
@@ -413,6 +415,11 @@ xfs_sb_add_incompat_log_features(
 	sbp->sb_features_log_incompat |= features;
 }
 
+static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
+{
+	return xfs_sb_is_v5(sbp) && (sbp->sb_features_log_incompat &
+		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
+}
 
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 00ade15cf1eb..6e4c65d82db5 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -13,6 +13,7 @@
 #include "xfs_defer.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
 #include "xfs_inode.h"
@@ -29,6 +30,8 @@
 
 static const struct xfs_item_ops xfs_attri_item_ops;
 static const struct xfs_item_ops xfs_attrd_item_ops;
+static struct xfs_attrd_log_item *xfs_trans_get_attrd(struct xfs_trans *tp,
+					struct xfs_attri_log_item *attrip);
 
 static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
 {
@@ -257,6 +260,163 @@ xfs_attrd_item_release(
 	xfs_attrd_item_free(attrdp);
 }
 
+/*
+ * Performs one step of an attribute update intent and marks the attrd item
+ * dirty..  An attr operation may be a set or a remove.  Note that the
+ * transaction is marked dirty regardless of whether the operation succeeds or
+ * fails to support the ATTRI/ATTRD lifecycle rules.
+ */
+STATIC int
+xfs_xattri_finish_update(
+	struct xfs_delattr_context	*dac,
+	struct xfs_attrd_log_item	*attrdp,
+	struct xfs_buf			**leaf_bp,
+	uint32_t			op_flags)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	unsigned int			op = op_flags &
+					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
+	int				error;
+
+	switch (op) {
+	case XFS_ATTR_OP_FLAGS_SET:
+		error = xfs_attr_set_iter(dac, leaf_bp);
+		break;
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		ASSERT(XFS_IFORK_Q(args->dp));
+		error = xfs_attr_remove_iter(dac);
+		break;
+	default:
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the ATTRI and frees the ATTRD
+	 * 2.) shuts down the filesystem
+	 */
+	args->trans->t_flags |= XFS_TRANS_DIRTY;
+
+	/*
+	 * attr intent/done items are null when logged attributes are disabled
+	 */
+	if (attrdp)
+		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	return error;
+}
+
+/* Log an attr to the intent item. */
+STATIC void
+xfs_attr_log_item(
+	struct xfs_trans		*tp,
+	struct xfs_attri_log_item	*attrip,
+	struct xfs_attr_item		*attr)
+{
+	struct xfs_attri_log_format	*attrp;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
+
+	/*
+	 * At this point the xfs_attr_item has been constructed, and we've
+	 * created the log intent. Fill in the attri log item and log format
+	 * structure with fields from this xfs_attr_item
+	 */
+	attrp = &attrip->attri_format;
+	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
+	attrp->alfi_op_flags = attr->xattri_op_flags;
+	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
+	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
+	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
+
+	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
+	attrip->attri_value = attr->xattri_dac.da_args->value;
+	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
+	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
+}
+
+/* Get an ATTRI. */
+static struct xfs_log_item *
+xfs_attr_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_attri_log_item	*attrip;
+	struct xfs_attr_item		*attr;
+
+	ASSERT(count == 1);
+
+	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return NULL;
+
+	attrip = xfs_attri_init(mp, 0);
+	if (attrip == NULL)
+		return NULL;
+
+	xfs_trans_add_item(tp, &attrip->attri_item);
+	list_for_each_entry(attr, items, xattri_list)
+		xfs_attr_log_item(tp, attrip, attr);
+	return &attrip->attri_item;
+}
+
+/* Process an attr. */
+STATIC int
+xfs_attr_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_attr_item		*attr;
+	struct xfs_attrd_log_item	*done_item = NULL;
+	int				error;
+	struct xfs_delattr_context	*dac;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	dac = &attr->xattri_dac;
+	if (done)
+		done_item = ATTRD_ITEM(done);
+
+	/*
+	 * Always reset trans after EAGAIN cycle
+	 * since the transaction is new
+	 */
+	dac->da_args->trans = tp;
+
+	error = xfs_xattri_finish_update(dac, done_item, &dac->leaf_bp,
+					     attr->xattri_op_flags);
+	if (error != -EAGAIN)
+		kmem_free(attr);
+
+	return error;
+}
+
+/* Abort all pending ATTRs. */
+STATIC void
+xfs_attr_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	xfs_attri_release(ATTRI_ITEM(intent));
+}
+
+/* Cancel an attr */
+STATIC void
+xfs_attr_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_attr_item		*attr;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	kmem_free(attr);
+}
+
 STATIC xfs_lsn_t
 xfs_attri_item_committed(
 	struct xfs_log_item		*lip,
@@ -314,6 +474,160 @@ xfs_attri_validate(
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
+/*
+ * Process an attr intent item that was recovered from the log.  We need to
+ * delete the attr that it describes.
+ */
+STATIC int
+xfs_attri_item_recover(
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+	struct xfs_attr_item		*attr;
+	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_inode		*ip;
+	struct xfs_da_args		*args;
+	struct xfs_trans		*tp;
+	struct xfs_trans_res		tres;
+	struct xfs_attri_log_format	*attrp;
+	int				error, ret = 0;
+	int				total;
+	int				local;
+	struct xfs_attrd_log_item	*done_item = NULL;
+
+	/*
+	 * First check the validity of the attr described by the ATTRI.  If any
+	 * are bad, then assume that all are bad and just toss the ATTRI.
+	 */
+	attrp = &attrip->attri_format;
+	if (!xfs_attri_validate(mp, attrp) ||
+	    !xfs_attr_namecheck(attrip->attri_name, attrip->attri_name_len))
+		return -EFSCORRUPTED;
+
+	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
+	if (error)
+		return error;
+
+	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
+			   sizeof(struct xfs_da_args), KM_NOFS);
+	args = (struct xfs_da_args *)(attr + 1);
+
+	attr->xattri_dac.da_args = args;
+	attr->xattri_op_flags = attrp->alfi_op_flags;
+
+	args->dp = ip;
+	args->geo = mp->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK;
+	args->name = attrip->attri_name;
+	args->namelen = attrp->alfi_name_len;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->attr_filter = attrp->alfi_attr_flags;
+
+	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
+		args->value = attrip->attri_value;
+		args->valuelen = attrp->alfi_value_len;
+		args->total = xfs_attr_calc_size(args, &local);
+
+		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+					args->total;
+		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		total = args->total;
+	} else {
+		tres = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
+	}
+	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
+	if (error)
+		goto out;
+
+	args->trans = tp;
+	done_item = xfs_trans_get_attrd(tp, attrip);
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	ret = xfs_xattri_finish_update(&attr->xattri_dac, done_item,
+					   &attr->xattri_dac.leaf_bp,
+					   attrp->alfi_op_flags);
+	if (ret == -EAGAIN) {
+		/* There's more work to do, so add it to this transaction */
+		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
+	} else
+		error = ret;
+
+	if (error) {
+		xfs_trans_cancel(tp);
+		goto out_unlock;
+	}
+
+	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+
+out_unlock:
+	if (attr->xattri_dac.leaf_bp)
+		xfs_buf_relse(attr->xattri_dac.leaf_bp);
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_irele(ip);
+out:
+	if (ret != -EAGAIN)
+		kmem_free(attr);
+	return error;
+}
+
+/* Re-log an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_attri_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_attrd_log_item	*attrdp;
+	struct xfs_attri_log_item	*old_attrip;
+	struct xfs_attri_log_item	*new_attrip;
+	struct xfs_attri_log_format	*new_attrp;
+	struct xfs_attri_log_format	*old_attrp;
+	int				buffer_size;
+
+	old_attrip = ATTRI_ITEM(intent);
+	old_attrp = &old_attrip->attri_format;
+	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	attrdp = xfs_trans_get_attrd(tp, old_attrip);
+	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
+	new_attrp = &new_attrip->attri_format;
+
+	new_attrp->alfi_ino = old_attrp->alfi_ino;
+	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
+	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
+	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
+
+	new_attrip->attri_name_len = old_attrip->attri_name_len;
+	new_attrip->attri_name = ((char *)new_attrip) +
+				 sizeof(struct xfs_attri_log_item);
+	memcpy(new_attrip->attri_name, old_attrip->attri_name,
+		new_attrip->attri_name_len);
+
+	new_attrip->attri_value_len = old_attrip->attri_value_len;
+	if (new_attrip->attri_value_len > 0) {
+		new_attrip->attri_value = new_attrip->attri_name +
+					  new_attrip->attri_name_len;
+
+		memcpy(new_attrip->attri_value, old_attrip->attri_value,
+		       new_attrip->attri_value_len);
+	}
+
+	xfs_trans_add_item(tp, &new_attrip->attri_item);
+	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
+
+	return &new_attrip->attri_item;
+}
+
 STATIC int
 xlog_recover_attri_commit_pass2(
 	struct xlog                     *log,
@@ -387,6 +701,50 @@ xlog_recover_attri_commit_pass2(
 	return error;
 }
 
+/*
+ * This routine is called to allocate an "attr free done" log item.
+ */
+static struct xfs_attrd_log_item *
+xfs_trans_get_attrd(struct xfs_trans		*tp,
+		  struct xfs_attri_log_item	*attrip)
+{
+	struct xfs_attrd_log_item		*attrdp;
+
+	ASSERT(tp != NULL);
+
+	attrdp = kmem_cache_alloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
+
+	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
+			  &xfs_attrd_item_ops);
+	attrdp->attrd_attrip = attrip;
+	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
+
+	xfs_trans_add_item(tp, &attrdp->attrd_item);
+	return attrdp;
+}
+
+/* Get an ATTRD so we can process all the attrs. */
+static struct xfs_log_item *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	if (!intent)
+		return NULL;
+
+	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
+}
+
+const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.max_items	= 1,
+	.create_intent	= xfs_attr_create_intent,
+	.abort_intent	= xfs_attr_abort_intent,
+	.create_done	= xfs_attr_create_done,
+	.finish_item	= xfs_attr_finish_item,
+	.cancel_item	= xfs_attr_cancel_item,
+};
+
 /*
  * This routine is called when an ATTRD format structure is found in a committed
  * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
@@ -420,7 +778,9 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
 	.iop_unpin	= xfs_attri_item_unpin,
 	.iop_committed	= xfs_attri_item_committed,
 	.iop_release    = xfs_attri_item_release,
+	.iop_recover	= xfs_attri_item_recover,
 	.iop_match	= xfs_attri_item_match,
+	.iop_relog	= xfs_attri_item_relog,
 };
 
 const struct xlog_recover_item_ops xlog_attri_item_ops = {
-- 
2.25.1

