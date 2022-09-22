Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EC7C6FA90
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiIVFpm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiIVFpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7EB876AF
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3E6iW022056
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=2Q7tJDIHCHqrY2M24mdG/IA8ylulJQxLH7yRjxo39Dg=;
 b=K8Teoz4MAga/aVccNV28fVyc/dmDvCTbG5PoaGoyR1IyugRD/mFiL6TaZaN+bNVYIYa+
 9CABO4y5Dy7GgsWqiZQN8lq2NfPjFUHUBhlGBnJ2qmT8JgyWPKwfXSe0ubW3KLuSBJ6E
 bp/zdfjJ6paMcYfby7h2ztnUZM3Lhj/JLLIcN1q9K65/yMBwzdMrvF7i8keXbsmbkMXj
 CVnbgj1U4K9vL38ZW/VTMkGuTm3CchkIUwDlk6/WhIgLS48rk245k8cacaLr115VhPZa
 JYmBeRUb2dVHkPge6kCYNi1sdLk3Cpkwdkb1nZ3GZ1M5d4MJfsH82Z9JiM071BjVI/D2 5w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688kv57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M59ZJS032487
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d46yc7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrFU5biljb6jD0b+fBqCy/gkwKlox2Vu3gKlJUp7qhhTRx4QOXNBfNAQCeB911v+rEHCwZErilXxf2zstTEUIW4/e8G/KFtz4ek2DtAyhkaGKdLgVEd84LG7beFd8G+S2bTXaQndMQ0WivbgAYdXj3AXEufguM0NC/vkEqElB/IiNOxQqwN0/sihkIsFgKeMOl5RqLPYF+V8A3i9B0kQwNBoMM/TLCoYUsX7mV+j0nsV1yeCtWY9aiF1hyXGmmNd/MoeNBET9tq5BBbV2b16GyOWC1Rlzh+e5Gh+KDhoV2BQ/WuPYnKW+65w8UCpb82HlK9L5S1nEC3Gl1p5nnlblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Q7tJDIHCHqrY2M24mdG/IA8ylulJQxLH7yRjxo39Dg=;
 b=YFIiEOsPhjLn6NpcQ1Vc2jUjqKFCO0VIWFbby2ruf47moJqV2Yw3WU2arujvHtwhce9uhjjiniVbxvkuoIkgYSgE2gM7fNaVoQE4g4MwYTt/zg7/cKEP6TDOPqb7C+Xfoe66mtEOQqwI1txG9PuvP4PjGMqZJdi/Y4UIhB/Ai0duk5XG6FhPxrM0NwlhsDKImQleTjOzMCezc++XVf7tFN5iU/w+kI2qgkgpN7nforUjrb+mz1Qfwg+JfVFf4bk+3mDdBwXJNoUlM5S0bkotaWG5TejakMe0XUju9pkOA252BSm0YdQbXvIEA9RlSNG6Qo4KgUDungoUiVB3r971iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q7tJDIHCHqrY2M24mdG/IA8ylulJQxLH7yRjxo39Dg=;
 b=PDYPhEd6qNPO8vd4rp6CHM32qXt02He0HY3YoouWwdA0t6r/zTb81J7+bVlP+tVreO9i0bT3bEhMQ2tKJH5mRGnHR5QSP64/ysWcfn/MkzSuWK+NnVhAzmCiJWedL3V0bTaN4wyiCzjdsCJUksWRvC5vn+d1hDymcJTUbf+kKyI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:30 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 21/26] xfs: Add the parent pointer support to the  superblock version 5.
Date:   Wed, 21 Sep 2022 22:44:53 -0700
Message-Id: <20220922054458.40826-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::38) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: 864a37b5-f67e-4cad-859f-08da9c5da8f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xS9TDL/BaaB5ZCJ352J/Z9d4Wi2e4vUTTe2Y8T39ynkF87TgP+ecik/dGbCqdxT+7AjMeFVppjZ47x9iduCGNzkzTHNa7mFrcrNKYU3HJTP4RHRcwhATaBZXt4+xRWmalb83z5jeAXLDkgUQFVGZCmOYvFLGxuLLh5evIrXkUhRUOl/c8NxQKHda4x0bYHbt5jEkqG32liMWe5+zWKCv1gBtjsLjT25VcTjwnz7SYXUDUnj3ssPHe7kQ7IJqhfSXWunKX/bWra1H+kGVAnTPlPs5NFQiyZH9oDvvw+4fzlLZvAAdSxrp8dYldH703MuJtPLKC2a6ky+MQPreKKxOIjtXXMIqvDw5QPXvRF5G5slD33+ePhCMdpzTQy+PoUIvkxtJ9DWCJDyBGkhi6b37hfkZscAw3vhl7QpoeGUjxrzmGx4XYFulH9CvARpaxqL1Xi29ZzfbltnWaGJ1ZDpR3TVi4CtvOsu/4syaIFuqEEm8GqD+Vq2vBUUNOhu7WWFs1zw/rvFb7TFe4CyDLPQnhWBFG4ZIxQW6oJEkTpiI/rRE5g11ZcoEzHwzKDX817TQDHqgTU9Oy55N6goJZIGYNkzl6i6+FSmV7p3JMxDDcbfcemIi5P4iR1T2xIetBsfncg7K0yeQwqqoZj0Nrh2U46Ui0xDykyvXL/ORukn9/45eCIR4qEeWe7qdFfd47cL586sRTmKV1ntK4JTD59rdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O4lI6mEGsGpOTnDWggKoQ8KNQQMSsJcAt7LWAfwsvHCzO/Psx9NZaa4Xzt+8?=
 =?us-ascii?Q?nkwUDV1ylaT1psFhkO1Ww2cTbkbKNh5Tzz/NUzqnk42zOXyetszKNquXYOAv?=
 =?us-ascii?Q?RMdkfJhwZJ9QtUFRVvzZNWgZan+v+7F09s8OAw63OuND3tPtEYAjz4ZPmaHH?=
 =?us-ascii?Q?sFbO4jgt2Dlz3ABGvJsbZz/DrJQFYvU3ggUgT+YvB8u2MKkzNDRYyogpe7AT?=
 =?us-ascii?Q?vBdCwRW7ZfMlJtnkGLZSAlUfY2wuiVBjbar5TSyxxzxGgAz5ktuPvbXorfO1?=
 =?us-ascii?Q?58TPhha7XlbiFhskgrmCU8r1RX50cxTU8S5DVfwsPYMJ6UxpBgGYaHoH/O8A?=
 =?us-ascii?Q?f6tH0pXcYOX9CR6QUicvBBATzXySWJLMKW8Tu0uvl7uS8yvb57I+B1I9Mihn?=
 =?us-ascii?Q?EGdVgG1M59HmDOgQLQMYZREgTlKgfKlOR+cyRaceVEiKcm+byLk2LuB+k8+C?=
 =?us-ascii?Q?sa3XYoU/ckXdVA7xMfQ5LxolnFrUZPbV29WDyDNY4o9RR6xbokyLKIEd2aTx?=
 =?us-ascii?Q?gZzc3aWZ73hH5UjkLU1Lo/MIR6dg9qVYnBAXqipGm7HRzFHo8abXAX0NKeTW?=
 =?us-ascii?Q?ZKkuFt0scrp7QOC05LL8vncwkDPaB2RaJhomaxEAPa3bqUkStrPMiPuPZ5c1?=
 =?us-ascii?Q?UfHGDCCjvsR5MdmQCLMb2z8EnfC/Mkti0f3JWRQdM1e4CEF7/Ci5r0Xw+kU/?=
 =?us-ascii?Q?LvgyeY75c7jT8oGBzUQUmwrl9dktFyVPwqii4W/KRDlNbwC/MN6LcwZvSr8k?=
 =?us-ascii?Q?/RqAXDPnqCvJ6pTyGQoCPSgQPZPcNZW/rZRRHQCk+AJFEr8MRrR9NAa7Qm+j?=
 =?us-ascii?Q?+DjO7xe79Pkqa0sXdEVWusYRlGgqKzUB8U57puq8FFwl03IbXn+VYb9x5Gva?=
 =?us-ascii?Q?9tjd7fiEY+CVYsmMfbo+h60/DEIt1B8DeqktqhzbdXcvpgMsbJ1jG4Bk2yUL?=
 =?us-ascii?Q?k6SsepMy5ARl1uNNgojd108LKANXncPVK7aAxc3prLorqLR8AaVvDwVbFyPN?=
 =?us-ascii?Q?0bsJbBsksRshe9TDCBNtxcFHNRZSt9HpTsfB838Xb2AbnDjoD+5i0Xo4L6Si?=
 =?us-ascii?Q?yvhqWLPGLfVplaHNTH1yU7M0ITZAT44J6ot4/8hfuYDTYUtUUneoVlzy80Gy?=
 =?us-ascii?Q?go+z3AQoef0LT+8ZZNj8ZsK0zjWu8CNx5pp4+xeB/JUlelF38IzjgECu2dl+?=
 =?us-ascii?Q?ZobsfnkEL/OznyJTGjOBfxK/fi+/TFSGrc/lh8Lxm8Z06BVNQZRrH01wYcys?=
 =?us-ascii?Q?wezzIYrrOxeBRu2dIcUFK1D5o1+/Uabp8R588Djr4o64xELDGOpYs+lBKT8g?=
 =?us-ascii?Q?+dYcem21Vrz1fyl9upu+JI/Z33j6afm1/CFTeozZ41sV9YyFmi81Wcwl3l86?=
 =?us-ascii?Q?wdxzfgbCmXmarwFnH7gaLBhnN4gacpYErX1jFwtoMGsPEjL4Jzgpk5tTxmR1?=
 =?us-ascii?Q?AvDicj9TlUJm8UDF9zv2QSpy2jm0LSqkLHadLeazR90oqvLhLFM5jQzzgYQn?=
 =?us-ascii?Q?jHo9EOIQruVC7TzFa4a2jbWR2RbAWtcQSHBByEd/0TQXHovJPhY/npR70lfn?=
 =?us-ascii?Q?1ARx0clh97lhdmmh/Rlz6lW531W4xoOR1GSY2r0AQ8W7CuUavxGZEKI2CHbs?=
 =?us-ascii?Q?5A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 864a37b5-f67e-4cad-859f-08da9c5da8f6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:30.7603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KWX0++XuAXqQ3L6yeQg/E4aps3tFbD8Hvbx1W+Xb8Tup2ztImn/5al5lv3K7+wJ++kgt0dt3St33gHYy7TQblF6uuQeOcOf8yYt2uY2X5Pw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-GUID: 1jz8ssCaL4wVx0Pn4HBbhNadSVXkYkll
X-Proofpoint-ORIG-GUID: 1jz8ssCaL4wVx0Pn4HBbhNadSVXkYkll
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 4 +++-
 fs/xfs/libxfs/xfs_fs.h     | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 4 ++++
 fs/xfs/xfs_super.c         | 4 ++++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b55bdfa9c8a8..0343f8586be3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -373,13 +373,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1cfd5bc6520a..b0b4d7a3aa15 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -237,6 +237,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 24) /* parent pointers 	    */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a20cade590e9..75e893e93629 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -173,6 +173,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1187,6 +1189,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9ac59814bbb6..55957e53526a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1657,6 +1657,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
 
+	if (xfs_has_parent(mp))
+		xfs_alert(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.25.1

