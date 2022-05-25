Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63630C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 05:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbiEYFhG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 01:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244010AbiEYFhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 01:37:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655F62B1A0
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 22:37:03 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ONo5sd018277;
        Wed, 25 May 2022 05:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=VsIW5PY4qMQZU2XhUEhn+gwqF1TmKOdnwPzfVw70PQQ=;
 b=NxOBD2mb2HtKuFJ3DbCNSrd4cQIJwGHi1YBbYe+biy/QE6sV4gIuj5pnY3QwLOnx/+PX
 DM2sRl3mz1KN/ZSASeFKE1abn5Za8nVR+ji8T+aq1Gt4/ZQuMO4BzVKC9cxnjx+NdkT5
 gKSEAj16+V8b54m3ycwYEPthqabbFFgA9h5viQvGSqGPYDdsEDFH8eBsOvYpSsN+0ut/
 wqSaXf/a1ypFVyvRifE4/kZxgT9hGhMAb8sDgX48dIdsttzB48Uk5ucKdag61+2Yrvgf
 EuH/aoFk3zhsk00Jno/rdrECxP6Jl7YEpiG2iJRBDHixR3TEmxKY2FWee+U1fO52wfl8 Hw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tas47g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:36:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24P5a5sS034931;
        Wed, 25 May 2022 05:36:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93wux642-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 05:36:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yg3rNWwKMbz5tRmaHJINXwSaUmyfAE7kCAbrFa/gS6JPoZksGjkk13dhwzuSYgx/eL6HTgnOnA/ApvsJzUaZHpJW/INePy9l/L670meSYUfQSTgvyP4rInBdzvJCNftKg8W4rJvKnz/V/6f79tg11n3SiH+6OjSGHwTHlSKA0IXAct71MmarglLVNsRJh63thCDXN/E64/UMjARbnUGOGECZZhCgSTkVfiprX95RMB5EXByYhlSElKAkamDM8LVaji8C7pyV7WeJQefUWWuDrmKg5wAshZiGtQ+OlH4kXVZG6JMse++MmGCP7h5DKDO0TBRroThxeAH7lWIaVGLQUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsIW5PY4qMQZU2XhUEhn+gwqF1TmKOdnwPzfVw70PQQ=;
 b=Z243o3IhrwFviF1Q60aji8gAjleLNMmdPGFzPyK6d9wcd6ROSh9xgwuBmdSImO7dg7tle2po4SycWeitkYLQyByHTJvGqP4F0f0375E9vStNfGcjxo8IND4SQzOG1P/cKnX1YSrDtV/BMAoPCYlZZJvoHWdPluXr6Lhsxzpap74EaMTL1XiK9HmHfFBslTA9dsOCJvV5FMQ08815PhdcHaOgGfYJr939ZTR/M48KnRU2aoGvoCbl5KWtuPSd4DqwfUF9/QNp/wd/n6qk6ZVM4WxraPLFDvRtsUNCH7B+WXSCoIFLGmK/XUeG30UXFCRYWrfWHD9la6EK9GFXvzftWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsIW5PY4qMQZU2XhUEhn+gwqF1TmKOdnwPzfVw70PQQ=;
 b=puaOAhOmb1JZ0rs/y9Glj28FwKBYQ+HIrrsGfcv2oS7Yc04mdJY41tbOzs7HVv194uGwnVy2hEnQrdxmpbi9Gxe+t9cSgVU7A3OyqHP4SZ5KKdlGbI0RXdewocO3OFmRuLW48/Bq2YGEk4QztHozZ6qDM4UT9RClMA8RV6dYUNg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BLAPR10MB4817.namprd10.prod.outlook.com (2603:10b6:208:321::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 05:36:54 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 05:36:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>, david@fromorbit.com,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 1/5] xfs_repair: check filesystem geometry before allowing upgrades
Date:   Wed, 25 May 2022 11:06:26 +0530
Message-Id: <20220525053630.734938-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220525053630.734938-1-chandan.babu@oracle.com>
References: <20220525053630.734938-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0047.apcprd06.prod.outlook.com
 (2603:1096:404:2e::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c79376fc-947b-4f3b-9156-08da3e109358
X-MS-TrafficTypeDiagnostic: BLAPR10MB4817:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB4817B12493B2A32C78469A11F6D69@BLAPR10MB4817.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VOVURN2IanvxTdfHReJJIBQpH7zejapcC9IDo7dEFzx+FslosJPlpB7ciSrWksoQ0PxvHVP9lgNGJ27gRhFi4xXt4PWCMEVh8YCKUtX3SSLXnD0rusXhBDFdf35XruvaoyFtUqS/kLTtjHGzU3ECudfAbYRsAlHYs0W6Q8jK3sc/OvNEdQ35jdCu2KshHjiOjCGNsL2QvbBwHJFzwIy7YBLK37wCqL792suw+jQoNniKkowBs1Pxkwbgfi+eZFHaVb+0gsfTGZIJlbx2RaDf499QPPh0ngHh7ojlIa8P0c8p5I9OZaIV0QzzNUVZpCkM8/Z2Gb3nQ46ijSmm6pU13dqjNjKAP+1HwQlVmm9rQ+IjscvbouaWjVuFPJ3hYhYLyguGd3+NiKeZf8Q4YPmwg4yq9RhEeDDoPmdtprolrfqxAWHsUq3UAjh/aO9atC+LVZ86bPC5oSaJhSK41GiGGstpqWWUEtViAzOq2KjEWNUSYh2ka0+Wft7pB4IZ7I12Xspy83fN9/xkHghrQRJf+BqEWWcaQ41pFKUhls6vLx38Ve0WXnpyFKsSjIymUfukG4xjMJuo+vx/a+Yvk6q88Tn9bLDNqV3z58EvPyMHKWU0q3DtEONSK4rPG6JMKglEAB55BWVT3u/ETen998gG7t6fynEk5ZCALO+DYdOU1fGHkJ6s6EcimNI8IUhGSgkbC29YI2P5xrniPxhi1JUDAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66946007)(66556008)(6512007)(4326008)(8676002)(66476007)(83380400001)(8936002)(508600001)(6486002)(6506007)(1076003)(316002)(38100700002)(6666004)(52116002)(86362001)(6916009)(186003)(54906003)(36756003)(2906002)(26005)(30864003)(38350700002)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HO39mHyyXmTD2ZJJ1LGmWyxqMsQAlbcEs2yc1YG3UNNcWr9c+f+x9oSk0W/2?=
 =?us-ascii?Q?/Te3UQBdTVVv9zET7HtGxFFHD/sAim+mMAeLhNeibJajrWi0ScsXhRsIsLVn?=
 =?us-ascii?Q?QR63oKQtPRYFJVRglNzEWTwd/UTRdGFGhYuKNXDrjjaYkzeiY6Umyhn1LQOo?=
 =?us-ascii?Q?iSS3VItSLO1lzbTjPOJtzuMgji5BaF8Z+QH7hkwLig7OOucNexts3sg8mWyC?=
 =?us-ascii?Q?S7g4IObNPIFiAKonk4UwRXlygyJLkSuw7G6bq6PXj5s57xAvf9BbNz12Msry?=
 =?us-ascii?Q?brVUK6g0gOnNh3WFEsDw4LGHaa2gmWK4TG7h8Z8vHXURx2tGaAe4nO6S1Jys?=
 =?us-ascii?Q?txn8kKH5XV8HB+nUN1hX8Fml4DBdKQU9zP+f1jlokI5uAQDPoZ5+6TLwNCUA?=
 =?us-ascii?Q?H94rBlq04r1XoC2HhQmx8FMsbf2zW+B/5C8q3XjpqYc+BH4okJTUBQe5h0+/?=
 =?us-ascii?Q?CT71jBq/APPHqUmH86CTDd2hzeColiTa5JLXe+Bssk6gFo8Xu4M7uLfLZ4Nc?=
 =?us-ascii?Q?wMezbTc1MsqhvchlZNlIZLHSdLaHBzRxOZCq9q8oWT1al9WGbc8ycxj/9e6h?=
 =?us-ascii?Q?864G2VEngIzaRH7J0M7oDwVKnWtDYp7i9UmSkp64DXvxhmQrGLG2wvKAhZbX?=
 =?us-ascii?Q?ecgGXbtHUAORhFlsIZl/vvTMp6skEwSG2m11361TgUD6oJpGgAfOR3wbwScY?=
 =?us-ascii?Q?I/mSeVDsHxnpxLVW6R65ZUVT44gm5micLF7HvcATliHbwSz0tOz4jvMmByI0?=
 =?us-ascii?Q?sklgTQvcKPgx+HMzhfToDeKJX+OktJQ/TrV6KoqwYXqJ35trDXKAAV8Hcesx?=
 =?us-ascii?Q?m7RA5KH0olKY+dHXhMbpr/XZpLr9BG1Xgsy0bfmCxne25W5ohzBRsUGjQ+yZ?=
 =?us-ascii?Q?NcUB2MczBxacjqcgPq7kDJM5oJGczP9NGFQzERh1jKRA5aGn9XQrAJcYNCdj?=
 =?us-ascii?Q?rs9nsop6NaQBmXtDPL8oNLlNCkhyc43M+5PtIeEDK4oiLmg9vRs9jNjMnqQF?=
 =?us-ascii?Q?45bLtAkBCe2iirs2sWsncjGx8HWvofB8MkEUnykEFEQ6GS7dg2Un9SUC7yoP?=
 =?us-ascii?Q?6Zifql7nBiVTcBr0lbwJ4tmmnKf5K/Ao8MtPuagiceI3Cm9Crs2veFPR56Zf?=
 =?us-ascii?Q?iX83EE4MDbnwQhlVB2aUI3NfdDYZVGseSsXp3DNbcG8O4sKHVmqpMxc8qt8f?=
 =?us-ascii?Q?WtrT0YVUbwDIHFYU0JKhndBQep75eGqGK/h8hYgFElOVekw0KiR3bgz7KmF2?=
 =?us-ascii?Q?inrT5NekUZ+Hq0I0qCse5xrf7YhxeRCYCeYOk5YhI7KFe08G37VKukqG/Ol5?=
 =?us-ascii?Q?jN/2XpxH7BrCRInxL2M0Qe8GVtlxDJi0nfYtaEoJd4Q/K57UxZ0KTVTMXu8H?=
 =?us-ascii?Q?jvV6fo8T6SYg1vWIRQXkZjAi/u2246rNRfr3z7d8U0F58gCd5ASAr9iewtuK?=
 =?us-ascii?Q?9+UaA57eqZae0vhnZ+P6VkHxT5dv2sjkQ2liRVFKLAAMt50jj5WOVX0Px7BO?=
 =?us-ascii?Q?o40B17NyjUu6f9IjXnbwFBVU+DVFTyN7cFTwmE4HsYQH71WHyS5vYoGyH6m3?=
 =?us-ascii?Q?VidkG55dRVcpEz8TrFPaUbkqOIfjuQh6WJ4NOSqbDK+ri+gCSHvbOcAuyDGW?=
 =?us-ascii?Q?aO4X60WK7KlPVBdMNWz37IBmOKtUKzLvAFST27jx5WRQzNSmOifi5Rxh5hyd?=
 =?us-ascii?Q?TKUkm2D5mjEAj8lSOFOhK1XKr8kIBTPdM7ODMN2WNJxkpb3eXq05GeOHTo6H?=
 =?us-ascii?Q?5pTwhRWv4HCz4x0QUwtXcD86NWFcHtM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c79376fc-947b-4f3b-9156-08da3e109358
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 05:36:54.0518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WgxlK6wPXVxNVz0FNEICBBUEfAdCpbjObs1fljiYIO0zW4Gg4/LvLjrLGfyG+lr1osN6y3RFKa4KEtkAYipY7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4817
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-25_01:2022-05-23,2022-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250029
X-Proofpoint-GUID: 38jRrQmityFauYdglNsxidLiDtkWW2jJ
X-Proofpoint-ORIG-GUID: 38jRrQmityFauYdglNsxidLiDtkWW2jJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Currently, the two V5 feature upgrades permitted by xfs_repair do not
affect filesystem space usage, so we haven't needed to verify the
geometry.

However, this will change once we start to allow the sysadmin to add new
metadata indexes to existing filesystems.  Add all the infrastructure we
need to ensure that the log will still be large enough, that there's
enough space for metadata space reservations, and the root inode will
still be where we expect it to be after the upgrade.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
[Recompute transaction reservation values; Exit with error if upgrade fails]
---
 include/libxfs.h         |   1 +
 include/xfs_mount.h      |   1 +
 libxfs/init.c            |  24 +++--
 libxfs/libxfs_api_defs.h |   3 +
 repair/phase2.c          | 206 +++++++++++++++++++++++++++++++++++++--
 5 files changed, 218 insertions(+), 17 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 915bf511..7d6e9a33 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -77,6 +77,7 @@ struct iomap;
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
+#include "xfs_ag_resv.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index b32ca152..011f395a 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -259,6 +259,7 @@ __XFS_UNSUPP_OPSTATE(shutdown)
 
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
 
+void libxfs_compute_all_maxlevels(struct xfs_mount *mp);
 struct xfs_mount *libxfs_mount(struct xfs_mount *mp, struct xfs_sb *sb,
 		dev_t dev, dev_t logdev, dev_t rtdev, unsigned int flags);
 int libxfs_flush_mount(struct xfs_mount *mp);
diff --git a/libxfs/init.c b/libxfs/init.c
index a01a41b2..15052696 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -728,6 +728,21 @@ xfs_agbtree_compute_maxlevels(
 	mp->m_agbtree_maxlevels = max(levels, mp->m_refc_maxlevels);
 }
 
+/* Compute maximum possible height of all btrees. */
+void
+libxfs_compute_all_maxlevels(
+	struct xfs_mount	*mp)
+{
+	xfs_alloc_compute_maxlevels(mp);
+	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
+	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
+	xfs_ialloc_setup_geometry(mp);
+	xfs_rmapbt_compute_maxlevels(mp);
+	xfs_refcountbt_compute_maxlevels(mp);
+
+	xfs_agbtree_compute_maxlevels(mp);
+}
+
 /*
  * Mount structure initialization, provides a filled-in xfs_mount_t
  * such that the numerous XFS_* macros can be used.  If dev is zero,
@@ -772,14 +787,7 @@ libxfs_mount(
 		mp->m_swidth = sbp->sb_width;
 	}
 
-	xfs_alloc_compute_maxlevels(mp);
-	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
-	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
-	xfs_ialloc_setup_geometry(mp);
-	xfs_rmapbt_compute_maxlevels(mp);
-	xfs_refcountbt_compute_maxlevels(mp);
-
-	xfs_agbtree_compute_maxlevels(mp);
+	libxfs_compute_all_maxlevels(mp);
 
 	/*
 	 * Check that the data (and log if separate) are an ok size.
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 370ad8b3..824f2c4d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -21,6 +21,8 @@
 
 #define xfs_ag_init_headers		libxfs_ag_init_headers
 #define xfs_ag_block_count		libxfs_ag_block_count
+#define xfs_ag_resv_init		libxfs_ag_resv_init
+#define xfs_ag_resv_free		libxfs_ag_resv_free
 
 #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
 #define xfs_allocbt_maxlevels_ondisk	libxfs_allocbt_maxlevels_ondisk
@@ -112,6 +114,7 @@
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
 #define xfs_iallocbt_maxlevels_ondisk	libxfs_iallocbt_maxlevels_ondisk
+#define xfs_ialloc_read_agi		libxfs_ialloc_read_agi
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
diff --git a/repair/phase2.c b/repair/phase2.c
index 13832701..4c315055 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -133,7 +133,8 @@ zero_log(
 
 static bool
 set_inobtcount(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
 {
 	if (!xfs_has_crc(mp)) {
 		printf(
@@ -153,14 +154,15 @@ set_inobtcount(
 	}
 
 	printf(_("Adding inode btree counts to filesystem.\n"));
-	mp->m_sb.sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
-	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
 	return true;
 }
 
 static bool
 set_bigtime(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
 {
 	if (!xfs_has_crc(mp)) {
 		printf(
@@ -174,28 +176,214 @@ set_bigtime(
 	}
 
 	printf(_("Adding large timestamp support to filesystem.\n"));
-	mp->m_sb.sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
-					  XFS_SB_FEAT_INCOMPAT_BIGTIME);
+	new_sb->sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+					 XFS_SB_FEAT_INCOMPAT_BIGTIME);
 	return true;
 }
 
+struct check_state {
+	struct xfs_sb		sb;
+	uint64_t		features;
+	bool			finobt_nores;
+};
+
+static inline void
+capture_old_state(
+	struct check_state	*old_state,
+	const struct xfs_mount	*mp)
+{
+	memcpy(&old_state->sb, &mp->m_sb, sizeof(struct xfs_sb));
+	old_state->finobt_nores = mp->m_finobt_nores;
+	old_state->features = mp->m_features;
+}
+
+static inline void
+restore_old_state(
+	struct xfs_mount		*mp,
+	const struct check_state	*old_state)
+{
+	memcpy(&mp->m_sb, &old_state->sb, sizeof(struct xfs_sb));
+	mp->m_finobt_nores = old_state->finobt_nores;
+	mp->m_features = old_state->features;
+	libxfs_compute_all_maxlevels(mp);
+	libxfs_trans_init(mp);
+}
+
+static inline void
+install_new_state(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
+	mp->m_features |= libxfs_sb_version_to_features(new_sb);
+	libxfs_compute_all_maxlevels(mp);
+	libxfs_trans_init(mp);
+}
+
+/*
+ * Make sure we can actually upgrade this (v5) filesystem without running afoul
+ * of root inode or log size requirements that would prevent us from mounting
+ * the filesystem.  If everything checks out, commit the new geometry.
+ */
+static void
+install_new_geometry(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	struct check_state	old;
+	struct xfs_perag	*pag;
+	xfs_ino_t		rootino;
+	xfs_agnumber_t		agno;
+	int			min_logblocks;
+	int			error;
+
+	capture_old_state(&old, mp);
+	install_new_state(mp, new_sb);
+
+	/*
+	 * The existing log must be large enough to satisfy the new minimum log
+	 * size requirements.
+	 */
+	min_logblocks = libxfs_log_calc_minimum_size(mp);
+	if (old.sb.sb_logblocks < min_logblocks) {
+		printf(
+	_("Filesystem log too small to upgrade filesystem; need %u blocks, have %u.\n"),
+				min_logblocks, old.sb.sb_logblocks);
+		exit(1);
+	}
+
+	/*
+	 * The root inode must be where xfs_repair will expect it to be with
+	 * the new geometry.
+	 */
+	rootino = libxfs_ialloc_calc_rootino(mp, new_sb->sb_unit);
+	if (old.sb.sb_rootino != rootino) {
+		printf(
+	_("Cannot upgrade filesystem, root inode (%llu) cannot be moved to %llu.\n"),
+				(unsigned long long)old.sb.sb_rootino,
+				(unsigned long long)rootino);
+		exit(1);
+	}
+
+	/* Make sure we have enough space for per-AG reservations. */
+	for_each_perag(mp, agno, pag) {
+		struct xfs_trans	*tp;
+		struct xfs_agf		*agf;
+		struct xfs_buf		*agi_bp, *agf_bp;
+		unsigned int		avail, agblocks;
+
+		/* Put back the old super so that we can read AG headers. */
+		restore_old_state(mp, &old);
+
+		/*
+		 * Create a dummy transaction so that we can load the AGI and
+		 * AGF buffers in memory with the old fs geometry and pin them
+		 * there while we try to make a per-AG reservation with the new
+		 * geometry.
+		 */
+		error = -libxfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			do_error(
+	_("Cannot reserve resources for upgrade check, err=%d.\n"),
+					error);
+
+		error = -libxfs_ialloc_read_agi(mp, tp, pag->pag_agno,
+				&agi_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGI %u for upgrade check, err=%d.\n"),
+					pag->pag_agno, error);
+
+		error = -libxfs_alloc_read_agf(mp, tp, pag->pag_agno, 0,
+				&agf_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGF %u for upgrade check, err=%d.\n"),
+					pag->pag_agno, error);
+		agf = agf_bp->b_addr;
+		agblocks = be32_to_cpu(agf->agf_length);
+
+		/*
+		 * Install the new superblock and try to make a per-AG space
+		 * reservation with the new geometry.  We pinned the AG header
+		 * buffers to the transaction, so we shouldn't hit any
+		 * corruption errors on account of the new geometry.
+		 */
+		install_new_state(mp, new_sb);
+
+		error = -libxfs_ag_resv_init(pag, tp);
+		if (error == ENOSPC) {
+			printf(
+	_("Not enough free space would remain in AG %u for metadata.\n"),
+					pag->pag_agno);
+			exit(1);
+		}
+		if (error)
+			do_error(
+	_("Error %d while checking AG %u space reservation.\n"),
+					error, pag->pag_agno);
+
+		/*
+		 * Would we have at least 10% free space in this AG after
+		 * making per-AG reservations?
+		 */
+		avail = pag->pagf_freeblks + pag->pagf_flcount;
+		avail -= pag->pag_meta_resv.ar_reserved;
+		avail -= pag->pag_rmapbt_resv.ar_asked;
+		if (avail < agblocks / 10)
+			printf(
+	_("AG %u will be low on space after upgrade.\n"),
+					pag->pag_agno);
+		libxfs_trans_cancel(tp);
+	}
+
+	/*
+	 * Would we have at least 10% free space in the data device after all
+	 * the upgrades?
+	 */
+	if (mp->m_sb.sb_fdblocks < mp->m_sb.sb_dblocks / 10)
+		printf(_("Filesystem will be low on space after upgrade.\n"));
+
+	/*
+	 * Release the per-AG reservations and mark the per-AG structure as
+	 * uninitialized so that we don't trip over stale cached counters
+	 * after the upgrade/
+	 */
+	for_each_perag(mp, agno, pag) {
+		libxfs_ag_resv_free(pag);
+		pag->pagf_init = 0;
+		pag->pagi_init = 0;
+	}
+
+	/*
+	 * Restore the old state to get everything back to a clean state,
+	 * upgrade the featureset one more time, and recompute the btree max
+	 * levels for this filesystem.
+	 */
+	restore_old_state(mp, &old);
+	install_new_state(mp, new_sb);
+}
+
 /* Perform the user's requested upgrades on filesystem. */
 static void
 upgrade_filesystem(
 	struct xfs_mount	*mp)
 {
+	struct xfs_sb		new_sb;
 	struct xfs_buf		*bp;
 	bool			dirty = false;
 	int			error;
 
+	memcpy(&new_sb, &mp->m_sb, sizeof(struct xfs_sb));
+
 	if (add_inobtcount)
-		dirty |= set_inobtcount(mp);
+		dirty |= set_inobtcount(mp, &new_sb);
 	if (add_bigtime)
-		dirty |= set_bigtime(mp);
+		dirty |= set_bigtime(mp, &new_sb);
 	if (!dirty)
 		return;
 
-	mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
+	install_new_geometry(mp, &new_sb);
 	if (no_modify)
 		return;
 
-- 
2.35.1

