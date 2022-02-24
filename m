Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52567C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbiBXND3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234739AbiBXND3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37C42325CB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:02:58 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYJix000938;
        Thu, 24 Feb 2022 13:02:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6kQ768hsebW/CP/T66O0BO07Aa4mOY83l0g/6vPvftg=;
 b=KH9xeCDxynJ0jW8v8/oVHHiNLKjJrOfGa4hYe7UUFhLyiZwN5seFmfGSjrVTGdJwD5lD
 myDxhhfSoYaRBOtAeg2yLGR5QW5XtKpC2iUdh1FJDiVGcyyUBtiAsfto26Mu7/+eMY9A
 PQwPDaBE+cvn4olo/GUN6AEDR4lv39InbhtCIv5RdO+DSmIw2EOCl23pb4Q2DF4jm6GN
 9+YUoV1Rz25MX54T3U5MNP2suo3w5EmYZtnitJEKcNW7lEuUlGAomvKNGQYP0OOEGYr5
 r1ZTTIRdmYVd6C3ZndXvCmbsMQfCvBoCxamlfCyMgAHea8mgp563+Nwyaf5b88VwAZGy AQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7aqa7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD1gQM039588;
        Thu, 24 Feb 2022 13:02:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3030.oracle.com with ESMTP id 3eannxddan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGWXy38mQcwDwXpCSIA/xVbW9PNq7CB98jSOfBMyo7QXb/11gbC/Ek/X43rBRsuFiECzgJ5GTVojbNwA2YoDs4o+Ea8KV/6iY9eFfMHGMqs5JvTvcKoXTh2a6mpdg3ZYav96e81ECjUbwnykWfl66eDDFEExES3yGgZpANi6OXqYolYF0bkhvW0egNX+Mvbt0xkbLmgSjyMdpjPqDoltONtrbbjz730g4gJFwvBzl5HXr4TyOB27/RCiff4xOmfiG4wiwM71Xtioxy1JPkEISKGCVakTuOmmiPjR5z0lusz7SpOYY9ENTLqmQJqyuOoRQJCIFvXzVissEaIAFoklqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6kQ768hsebW/CP/T66O0BO07Aa4mOY83l0g/6vPvftg=;
 b=oGiTm+482Z/v4EvQyKDOvxzTfjqv5tDaT8MhseeJc9UOqhO84iTAEgV8y1DPd3vxTzNCCFhZG1G5m4fd+qR1DNW+0cg0Y+AQOAF2FPkLu+p9833BCjBdhpPRo89a/IRsbpF3CfUOfK0hoc7U6TlJ/K8qWi/98u1ZWt3ptkjxXkWEGaanFO60aVoKJaQMKx6iEcnqWHXZ+fN6tJhev6Ocwsws5uoEZ+y7Qabd6UcJKkf+jlzJ8Zd3FZxM9flyea8bIwrxran8tLoMv9o1lL0nreFAscZjWHSzQxvbBHgwi6i0lSYkqCpKpHf5p+yCnKE/g8C3zOCzzcAFXkAm9BYRfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kQ768hsebW/CP/T66O0BO07Aa4mOY83l0g/6vPvftg=;
 b=XW/FJeBkaGFXmSRY02L/CmOemCA2ktPWu/ywU7+2dNtnB1ItLgWBo7MgTEatrpvv6NuotuGMx9Pxl9A4CgESazM7z45/LYUE3kixilyFH+m0Ejrr0mc8NgpYWJL6gAhUK74CPpqPMiaNh+vkqBuLwnupxd1TKlsTTD+lj39q2Mo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3665.namprd10.prod.outlook.com (2603:10b6:408:ba::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:02:51 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:02:51 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 07/17] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
Date:   Thu, 24 Feb 2022 18:32:01 +0530
Message-Id: <20220224130211.1346088-8-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5ae9026c-9a49-4604-416a-08d9f795f685
X-MS-TrafficTypeDiagnostic: BN8PR10MB3665:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3665B4623CC5DD60B6BC90B7F63D9@BN8PR10MB3665.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x9XC7TExn3MTkN2hdF4l4pIFeNitmH2Tvs5OM4Prd1EukbBz4VbirDJ4XjjAxS9vqK+C43j0DD9w0mvShpBJfUrOCBVDjmpQgcYCzP52stAn8Z99hHkUpCBmO90h8X5ZYGfIW+AUvbowWMcMITsHAYl3uKIEbOCbOPW++Bql51zjKUxfB40hFc1VsNNXZ5EfAhAbrVAcEFpW817ImZMgDzUWIMiBQE9o/odRODfh9301gLS6X1cRqnMvK54q37mqLnBJr9VWHdDORgTo4GcnzZtTQy8O46ONaR5ydhz3Ik1JyGwvnkQlGN3fCqoOqDPyA5V2uNYhnRa+P6MOw3ckWLqtHAI4xKUKGQKfIcZWP5JrH7VbmU8e6rsotN91wuhXY21MyziuxEBnbWdVhjppYqC6u0TT3j0YE+ilSXv0m0KvwqMKI6Y9tpkSxmLgT35V1ZUeYLqT568tp/Q2/hGPQk1hx32pE6uhbuSeoGSVZUpR/vbSFzQouTt9Dec3ljHwX4UnacSaQiwM8AHOhMgMQDYBxhjg23dQIWogQKR0rO73EmAGrHVJzLXonSThAy9DBq2lnOSvtX70naIymAsMZGwTIdz9NUK9SzPmii4Divp5snDKuQDCB/xdUjUkl05Tq+0ut4/69axvd5XCT7Z/Ox7LCkKFo/0gjw/GvaXaEEd2C06cDzbGuKHHoDMPNpLO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(8676002)(316002)(6486002)(52116002)(508600001)(6666004)(2906002)(8936002)(66946007)(66556008)(66476007)(6506007)(5660300002)(4326008)(83380400001)(1076003)(36756003)(38100700002)(38350700002)(186003)(86362001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A12dXxWi7xwh5e0xnmsNv7GJ7ml5FsFB+je7uNC+ryXWeRR4oJ3EME2xV7i+?=
 =?us-ascii?Q?0MQIQKJscMSvkpNvKPodQ0mIWq6j5wY2gOfvucHklMmY9FOab9lMNsc7agR2?=
 =?us-ascii?Q?QPti82zmENFHRZ6LWGrGuZtjFfUvNUIqVJeblYxNi3U5oFxa12fFfizS/CbF?=
 =?us-ascii?Q?hGhJI12LAwNYspgzTyg2JKBb6Y2Mqn6yaJ0et9j0OSPZdfkg4orQ5CZfFQDN?=
 =?us-ascii?Q?XvXKCrszFsP+PBd3hpiorIA86757cXhMn4ETCLnWxEdbpvvZom1FUyWP1efc?=
 =?us-ascii?Q?8t5VgTuC8awRPgDBq51/jcgdQcJk7oqesD6K/vyU1E0u1iLzwhEMtP/tAOFd?=
 =?us-ascii?Q?R/UUCk+Mw2/T7Tmva4FnctG+dUg4nvLgv8IdQR04s9FjOZCzqY9Cu6/ZCqdo?=
 =?us-ascii?Q?/14EUNHEvxdrjjunLsgKiAwAdVyl4Ly0TMzChIKpQC2hrL7t3Lsriasyxj5R?=
 =?us-ascii?Q?61Zc7j51VKgibz1RI/C+RRZQJkHK+mlzOhwegRj+629EN82FJLEaVGBcM6w9?=
 =?us-ascii?Q?alHt+UqYPRkOloak+nPlUcWsZfuP4CdJZdC5dfxEjIubFAkEmACyDUt8w/0S?=
 =?us-ascii?Q?cnmg9o7Vw2XO7x04A1TawTNs0qKWlYA/7HGFDRqwCFx6zPBYUpyBnCzTf2uF?=
 =?us-ascii?Q?bl2TRuEgQzAf8wNeESFrvJhdJDc0gY9770ByKDy+QvPnYN0AAQgMW49VRe2J?=
 =?us-ascii?Q?cWbYEBIMIfgWgTVFTjXW1XC2K/pSExF0ryDSBb0NJ6Hcwhapq8ie0JMltCXp?=
 =?us-ascii?Q?Qv43AZf+KvaIVYtr5cmp04BEpgU/d2fWllOf5FRqY5lSzd3F8zvGpwVZiIqN?=
 =?us-ascii?Q?eZjy6+PdVQrVDF11La3uxA5o691vSyYqIrvLEw4ZGVNrIc74hGewVSGh9er3?=
 =?us-ascii?Q?+yV8AhELe7LgpWH9Dqcx1BxkNIXYfYL1jUCoaN0XV3ZaqE3W3n/CjmCKXg82?=
 =?us-ascii?Q?JWrRB7muOuPSZnljZKEn4ymIGcVjNcAMAXG5bYvTsKRFgQncxXNKAl/Rc4rv?=
 =?us-ascii?Q?Yi+2zp98jvaG3uOwVYbX/Po3r9nVsF9IPGK6uWpdROJIg9ePnvt4CM+dgRtz?=
 =?us-ascii?Q?p3Gzx6a9C/T1+cePfFohrF3NRweMh7J90RKpjLe845WQVBmv0F8HauNTfVwM?=
 =?us-ascii?Q?EtU5W2meubmg0JwEfuO0OaOKiWYY5dKNnwPss2B44V/fQKahTsj/M9gSLbUD?=
 =?us-ascii?Q?xwNHBAk30V5FdyvdQSVYS2XBKlDBG7ZbaGGAyWba9YIzuv7bEgUSbPWO9kSz?=
 =?us-ascii?Q?W16nWBsZukJiQmHl8if3ZYVmS+G885qEgl1F0lHjC7j7maX5i5ZS47P2eaiF?=
 =?us-ascii?Q?Qg/eo1soM9Yc9SudM2gLZ6DEc8hjkCOnjX3e4ARxfSxg1i2OCcm0aTbtKWdU?=
 =?us-ascii?Q?xttMOvdcf7Ewd5c7NNSM8VtKrBuoEmhhvZQs5qLXIbcpAp6lfc+sXFJBQ50w?=
 =?us-ascii?Q?SDN8SEDGWmn93AHc9aaxfd7r5C+ZEVAtGlpaJgrq+aWriHYIomz3yBWnDe2m?=
 =?us-ascii?Q?VraqdssIjobHXlO3ZwJMV1WceXTUDa73DHSv+y2fCED2z3bKtyoHZ1RegIHe?=
 =?us-ascii?Q?pYeyGzbf7O7UeGe0klntceiJ15muGOk/JeyncpQP/STXMbpsU/7GNsErLERe?=
 =?us-ascii?Q?+wj6MJ+fH1J8xHV5Smi23Yg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae9026c-9a49-4604-416a-08d9f795f685
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:02:51.0407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yIv1nXDOpwdkyp+rO6AS3P9PfX09WDZuufKOQBvg+2p9MT2LlbbcIibAaVcy4sWmR7g0sRKT/gD0D8PsNzQQ2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: wVzDFH-4df7qEk6IylykCL4Hi2usoA_G
X-Proofpoint-ORIG-GUID: wVzDFH-4df7qEk6IylykCL4Hi2usoA_G
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
which support large per-inode extent counters. This commit defines the new
incompat feature bit and the corresponding per-fs feature bit (along with
inline functions to work on it).

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 3 +++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e5654b578ec0..7972cbc22608 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* 64-bit data fork extent counter */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f4e84aa1d50a..bd632389ae92 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -124,6 +124,9 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_BIGTIME;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
 		features |= XFS_FEAT_NEEDSREPAIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
+		features |= XFS_FEAT_NREXT64;
+
 	return features;
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 00720a02e761..10941481f7e6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -276,6 +276,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
+#define XFS_FEAT_NREXT64	(1ULL << 26)	/* 64-bit inode extent counters */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -338,6 +339,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
 __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
+__XFS_HAS_FEAT(nrext64, NREXT64)
 
 /*
  * Mount features
-- 
2.30.2

