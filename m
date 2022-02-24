Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F08FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiBXNEz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234755AbiBXNEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:04:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF455253BCB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:24 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYSTB023288;
        Thu, 24 Feb 2022 13:04:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=bbnVSjWQ5vIZjv/Kmci+CR6uVPV4wwbcoX7gQnj0lyo=;
 b=wuZWTzxw6/SC2vo62pQos89AMuCb82C0O4DuM39Bpg8CLJWTeEocf/H4Cvk5w05a8U7C
 IrlW5xKFVnRBUskw6sdQocESnlGxUsM8fUa0Bo3koPC78cStknlSi/TpInCwj0kbeGwv
 FOqbvZncc8DTHY/Uroll9xDGlv/6tHRUzJwMlU7NggQKwzyZHqFdIuI1uHqXPCfknZF+
 QA7Id9Nxrb8h3fTHqCJjMIMEqWzeINpRU+H5fMH+sSgyiUlyaKwtp/dCnGf5IttwlsTT
 o9m2KtussnJiw0cmRbertWHRh8Uys9oYb8+yyH7tIvTuoZ/PDP72yP0CNyPnPi7XS/s3 xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfaxmk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0wJV002441;
        Thu, 24 Feb 2022 13:04:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 3eapkk43r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIE2ZEwyIOKcSRCW1zy2VWW+d5Q3ozAb+g3J4yJMUVGDMuv9uRwHAxfE8cDCR81KMjLP7fgtHJFZ1Flr0arr9xXmwUJqg5zWzKjtVhF5o2LgBv3qDJWGbxBWkBG+UF8dI/V6tw9rbxxPoajSwkqXaQkSJ4aSpS3X+61ffWWdufxY14l6rTYfy9It/T10GL0LqiCuS957ZrDdywmtqXL5WYgNRjXnNZRbX7eDFPiVQ93HTSsmaa9GYfSHFMHnnP61kUi1R8DSFEC0ze81vub3LE8GgRaZcsYw/6kM9tfo2somG5s5jBw5YOmphmK9XE57X8+KIDgMU+kcPp07OFei6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbnVSjWQ5vIZjv/Kmci+CR6uVPV4wwbcoX7gQnj0lyo=;
 b=NsBjyu8YZ2up5lYHq9Z0n9/uO1suzIWh8hfvhMApRpy40An+8MgV2oLViAGxZp9tM5k6bbJwW1m3KLFbIbrtJp20GG8KeN2/zr0bKEhkuEuG/ZOcgm/cSMBKvzDmp8EnkV0hXK0tu2RgR/JOIh0wEorYM0iGZl2ZdluGVYXmM+VMH0ABV9pbksWfRAfpIzoMIpV+0BIq46jKwHm745VwmXSKAHLnw9yVEeGSqrVICHnU++eYM/QY2oWhUDkZKRUZodwwXyuAO6ZR0noaNa9RVfQU5af9S05UJl7vaxqSNACFw/Z4ZPCCIYF2WVc6r+kBy9Brfq92qyUrJwbEmrOceg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbnVSjWQ5vIZjv/Kmci+CR6uVPV4wwbcoX7gQnj0lyo=;
 b=cAMnXwM54Ulwrtvc3PjzAPHqnjGd670UUBg+lcjs/csra593amxHrBNpSTv4Z8mk7jaGAjg/mPg01nGCpZhmPdvwufe1lI9HjlsD/aK5G7Em5l+VOEmV+qNqz8kRPT0f2xl01WSD1QtPoqAhIZfhxrd9rXdjAgvxKv5QZjxbgEU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:04:15 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:15 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 08/19] xfsprogs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
Date:   Thu, 24 Feb 2022 18:33:29 +0530
Message-Id: <20220224130340.1349556-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92fd9955-acfd-4e65-cc28-08d9f796289e
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB463496E916DD50CB6E821D95F63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6YZR7+PDlyxbDZXNNf0/2wmeh0pfUN2sNyalpn84vSwHQcqLu7kygUtVgORryEOf2v18jsTisERBzp7HYoYDZa+EIZDf/JsdftjksremglO5bvvDgFbr6r/+A0lDBDNHmnHtr8N/kFaNvKMb0PJZyn5Buk7/iODMt6fPkwKnZSD6wjOJ+5ysNC1sM04l0T+4EQddg5IwLTc5qWIoJylgzfRyXu4XWHVte4xqm8wFr2xjD1zouM8ZdSVN9i/mM/RWgP2NgeDGZ95coJ5Ce0sbupalWIRjl03Tbd7+N3eRbbLzBY/xRefZgfZsNwiJkdfK4VU601Fhatgf/2/6GvnpnAvq407CDUdIE4Pll+hLXr01f2C+NDWp21t9AG440CzXzLaOap3wP1aIW4r0rPI5jme1RK6aNjI+ocYgtn3jM2RK27C8g5RaekqspjTa9EAkJz3xgC9ZgYezmHWE1RWGtAxJ/OGJNAHOa3N/Sd5dgxWAieppohVlEdifQUNi35ZtJe0rLkx04lFP9vS2Ax7DV8WIbuB+Yw1/Gt7WKrm5H0db8eQ2WixS17KXn5jJD6a6izwuNseFop95Mph3v5ZS3cYs5X6yY3X4gts7ECDAvO3MrV1BulNxOseEaV7ae14uGvAdNfSzPYi4Rkr+tfptDeekQfqry81w/EmYqQBMDyjx49CbMRhwG2SBOSKr/QAgLM0z8s1KPaXkJHC/NWH+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H8O9ydRkKRlm1dNuYcPICkrfYyUmhyglhAYx3ck7b+onxK9JSfY/0k/lt0Dh?=
 =?us-ascii?Q?q5zxxAstOnlLfzWP2FhTFCvJOvibaM9oa3jwOlRAO44PQymstKcvg3O6+2ry?=
 =?us-ascii?Q?PpqnAWm66gumZVpbbFI2acfT2vxUX70dgxLaCaMChgzorlP+Ha0podq+fK2J?=
 =?us-ascii?Q?lXWKUdcFPHH1BQYYDC0nJv6GyK7ZWdm1dx97h1f9WT7i6bNZVAYCLAMHomT6?=
 =?us-ascii?Q?31llxpmDQQqOmh5LdgM6GnYKzx8m0hCRHzVIyzJ1A5SRjxHYRWpJ/wljKKGa?=
 =?us-ascii?Q?XooTk+2s/O9qXmat1/KoKduokP4gICrQxWJiHAqm6vwVu7z244sikXZXUwxu?=
 =?us-ascii?Q?QAURGBx+ExP72zClH5Io1amcmmMf2vl8iRzCHEHIf2fTSAJV43OQ6zeunAeu?=
 =?us-ascii?Q?JGHGIHKxUbCZdWt2EMKATDJPCTNkP+i7rOl9FgxaJ0eu9VgtanEm7xdySeJT?=
 =?us-ascii?Q?KvJsUHL1l+2tB3KUkntHfHAhXrJQRdxNyDoeZ8J5KOBPMLGooMThA+j8Wcls?=
 =?us-ascii?Q?6gumxrTVIP5ifEr1HZk45XF9jXM2ZLPgniiY7NX5bf5nd+cEboa6Y98RL6sg?=
 =?us-ascii?Q?v2Q1I7gpX3aynGJ/crC3R5NJeWXYzjC7+XyijHB2V12hRJaHdRXJh3ydyqkP?=
 =?us-ascii?Q?EAz2qPAAl5aDmyhIYmdd1StcHWOpje9jVweEsoUJY2IvkHoM25T2+qTgUEGm?=
 =?us-ascii?Q?YqgfrpcdVqaPIasnCgMK4W0729xI7GB0BSQhWeCKqFMEhDTTMxP8xY4RLGS6?=
 =?us-ascii?Q?6M1hn1Zms37Gy9qxnZLuIQzCM9V+3i6QH4fMokMoCrfOX4ahkieb84AsG0Oe?=
 =?us-ascii?Q?z+3hM67QjcgOiWNwG52y4NyQimhzu67GmLi8uzdobeEzEPPNIGQ5xvDMnW/E?=
 =?us-ascii?Q?EXeFX6mABlrICs9wMsxydPhPTTgESZW569UC8Wb3T4UBol6UwiXDjaZVn6bz?=
 =?us-ascii?Q?tT+yJFFB9pmo8I9F9sJRrXm6tBfm5JNJxwMmbx2Cu5EsmuEiITdjDFlvp1X5?=
 =?us-ascii?Q?0xts3YGlHYHf6kiXigzBcY33fXt5sPpawotS4MRVqmQI+hPPIUVF01WIolUU?=
 =?us-ascii?Q?xGL5e7KRFKNrf8gtvoAykYhwAy40Vmw3IkNt//wqaZ3W6wxPCFrPZqRHYnAj?=
 =?us-ascii?Q?FL7O3iKMWCwIUhi1y8lubkBBiJcFwDFW7nZBWQ1r7l3JnI52dut/dcRTNejB?=
 =?us-ascii?Q?/uOHxhPZ16WWCN2sDGWYIptWquUuXKl/BcZuipCT+LhysnMPHr4GZM7QXsF/?=
 =?us-ascii?Q?2RtC6WJORLEOIb1EBdPmJ0la9ohFU2WsI7cIPqcY0KCv5Zt335Qft3MfHjB5?=
 =?us-ascii?Q?W2ozSk9cN9LwlpJ5M38BxcXTggAqbAP7v96j8qKwItgz2uh+g90eNI2HPmjt?=
 =?us-ascii?Q?i5iMJenMVs5nMa69ROqdyQ6sXJWw2beRIbZm5hneaOA/6kod5BoHcvqY4ns6?=
 =?us-ascii?Q?MpmlZkcfxVH8Aprjg+Fwek7Tj06a42rqQXvyRb9rav9wwR6cL5hp+ZZ2kWBS?=
 =?us-ascii?Q?BYID3NWQEGRmi0sp+JglZAm+M+UXM70KN8hPep0wbZ8aacr/QlhirNb3BB26?=
 =?us-ascii?Q?pUi15SbIqLRTxYB6nBqSVwKmAJUTPEoO4gp6GRadXJjb0luKl21W2Gf0miWc?=
 =?us-ascii?Q?m+eKvE+VJ4jD6H+6ufx0qQc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92fd9955-acfd-4e65-cc28-08d9f796289e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:15.0942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pV/+z63mPAMQolwr3bhEGvo9PSitTRF3Be10ukGYCWyoDOzOR1Klft3WWJQf2ubExvRxiHOskQQkOUlFmCvVgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: C3X2mpt2SsbsJVIz5LBc6utJoikqoBRG
X-Proofpoint-ORIG-GUID: C3X2mpt2SsbsJVIz5LBc6utJoikqoBRG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
which support large per-inode extent counters. This commit defines the new
incompat feature bit and the corresponding per-fs feature bit (along with
inline functions to work on it).

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/sb.c             | 2 ++
 include/xfs_mount.h | 2 ++
 libxfs/xfs_format.h | 1 +
 libxfs/xfs_sb.c     | 3 +++
 4 files changed, 8 insertions(+)

diff --git a/db/sb.c b/db/sb.c
index 7510e00f..7f83052c 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -704,6 +704,8 @@ version_string(
 		strcat(s, ",BIGTIME");
 	if (xfs_has_needsrepair(mp))
 		strcat(s, ",NEEDSREPAIR");
+	if (xfs_has_nrext64(mp))
+		strcat(s, ",NREXT64");
 	return s;
 }
 
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 8139831b..b253d1c8 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -154,6 +154,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
+#define XFS_FEAT_NREXT64	(1ULL << 26)	/* 64-bit inode extent counters */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -197,6 +198,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
 __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
+__XFS_HAS_FEAT(nrext64, NREXT64)
 
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index e5654b57..7972cbc2 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* 64-bit data fork extent counter */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 986f9466..7ab13e07 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -122,6 +122,9 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_BIGTIME;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
 		features |= XFS_FEAT_NEEDSREPAIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
+		features |= XFS_FEAT_NREXT64;
+
 	return features;
 }
 
-- 
2.30.2

