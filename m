Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E7DC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbiAUFUu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:20:50 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:56564 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234051AbiAUFUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:47 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L03xs5018700;
        Fri, 21 Jan 2022 05:20:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=nw4tqk8CLBGJ4fVJU3m6EZdSHmd4C5VV9CBy1hKy0s0=;
 b=dXWBJItYhCGNGnWEnTPWGNmBOnOOL2o9qTEKjmEyFnksng3/OMuCcl8QABvv6w4Firl3
 j23HysWlb1PsyVquJhcgV56rY0D4jNP7ch83NRSE8eJkKeIh37VA90LODP8y7DSD+NHX
 gzi9vLH6kxy1P6JQbU4FwnKPRRPLjnp5zzaOGNYEAG/tMJqTrPeF0mYjBh+LXCNdUBQR
 FZnYxJDHk0hjvqWvbJJi1EZN+ik2RoQ4NI33tZNtQ6r6b5+GVUBpnK4+FQ438wzkLn+a
 i2MTmG5kliaIo1ed7zcsv0Wou4PzdV0ct2MWEHcy3O67BIiLXHfQIrEUOg9JCR6Bm4IW 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhyb8cnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5H1P6018806;
        Fri, 21 Jan 2022 05:20:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 3dqj05h3ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6DO9JlJLBTvUbZYvKn+VmTNVfDuvKIaVbkG4PeMG1b4q/uJLAAtZEoucOTxIzDYs0TLTV2hJudRVfuc/63Ze8jDGQRDHonJn/wXHlIgcAlp2H2GqxVrQERmvqZQ7SPWBCFIjNBCkT0KKaBU+V60iOR+T8a1FcAbaU0Ln263t8Xry4rAY9C9dlyilq4fNt0r0bMW7j0ajH8yK+IVNIniuXisehVUsXAo4wpQeF14ozIS+SHR8qBSpmKRWyobQOs1y7b4X1hpd2uIAMi0OFavzTb4uK2xZ/I3gJPJo0KsPxhDK6iOyMhtjeUOAg/gBkeYrCLgYPDG3Wm2lXNOLRM77w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nw4tqk8CLBGJ4fVJU3m6EZdSHmd4C5VV9CBy1hKy0s0=;
 b=R98BBHvTEdy0Z+1Ixtmc5MmptQRRDXac04nThxKbatT9hx1pFMHwwzU9sSvLB8/fWtJSNahQhnnhn6aoU0f1kYp28kRdQdHgtWae+JKfWHWc/686vbIz03naV0YLwx6h3pIT1jUFKScTaoS37v+7+jhlLja1wXUNqgdZu7pLsEpR1ha5SZquBDqWUQ4ZLhVJhhnRASSzUjWoClhKjXmmVHpZhOZaOSHhXv0DSwxOICr0x+0wnR8ZTt5ymNUBMoAxu9yi060egAJN3HRK9BrHhFYK9jntfPgfFInGwSnmJUY5eRvuHXm55c7IBMKDf01d2Tce+txp+MqQZ5ptEe4KmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nw4tqk8CLBGJ4fVJU3m6EZdSHmd4C5VV9CBy1hKy0s0=;
 b=H6Aoy3pdJEAUFG3PTf6Ga51Xloaau6eqnRh/LV7LRnGmI3i/6+V8t2Nh15HtH4f84ojaqPYm5FxZ6SsktuOlL2qyGw5FTJzXWkDtoBbn8ctm6kQuDfzVwDYlTn9PjSsExY3/TIpdeiWsxzuVNOAcZeG14w+RoyVKX/vy9a9oN7I=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:20:40 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:40 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>, david@fromorbit.com,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH V5 01/20] xfs_repair: check filesystem geometry before allowing upgrades
Date:   Fri, 21 Jan 2022 10:50:00 +0530
Message-Id: <20220121052019.224605-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffae67f6-5585-4918-1c77-08d9dc9dc2fb
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB12874C6BBAA0EBAE6C64ABD7F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sgrL4iThKmQvCzs1wAx2ML+AsV9hu6ULI6X5kbmOQNZZpHBDgcuKI6VjgTDSBdJi4qo0xwn/4C6SXT8Ljksrn9+/F5M5kgeARRUwMwDpoF9oKT1/V6S9D3wzTgWjvGF2x/Ze5OhYhpbR8cspxm3HEDytWmsNqO+p/3fd9hc3LOugue21csGoePLdW9biwB3BnMectgGBPmJwbO1ys6Sjfm3Q8bJbNiJmXTDwEGCaPriBEbQNBBX2gMvT51PtY3pvZ/fuxLlSOrhvKoOLlEKtpuXifBzuh4C1E3uqnDIjW2aPtx5CoIVxuADbccPEU3z27pxNig5aNG9UrTc2G+ZQC6ZGatSMN7aGazz83s6b4WrCo8gkXeUBddyCcIUewHcUt1OskHCGCaaOJzXoeOTRFICBzdHUORbfFB+NW8kY3XHjI6klalbLJ3a9DP5EcbEw1DuxGpV5FJb/qejyw4j+3hHl/k5uRpJ8vwd12vqNQ2sQFIY0icxL8g9sjFp2hT9UL5s0S9iJvzEpbHdKWxbt8+FmTjLU9XNTSdqD5AazHd10gvcJpLBuvcje6bTdhfSh5mOY2hgYglxVjfwxMqUPdx4nwCSMttFp/QOMKZgr+0kH8syMyFIYsZJIeuBmw2EsRKRxfJYbRx3c+G8/WFPnCe3jnTa5/pWrCxrir6Q1+uCK+APjQP8oNXijKmScNgb+5w9uxNerw2mS0wfmKv+Qfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(54906003)(6512007)(1076003)(107886003)(30864003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eRnAcErDlm002f8lUj7lGaOzlseuXD81UZyk4hNzBiV65gJm2wNVxnqbrfVq?=
 =?us-ascii?Q?KCREKNOzD8D3J660T7NLPJKfGOnF3js98OZ0fprvwrBygV9jUM7ItBwzU2xp?=
 =?us-ascii?Q?A8hAjrfmbc0VcN8QXliF62TkncT/ZIRcTipJaQaoo2Oq2DEGgak4dup9cqRN?=
 =?us-ascii?Q?B5xQxdKy25L2nX8Cjld+CTkv77r3utGFNkoJgEfXKIcRiHRckJ+bDnrWFF3E?=
 =?us-ascii?Q?njd+z1R33q2OshqJE+Vpx29x2RzSMTa+koSTIsP5T5yrRZoUHgIY4eloie4H?=
 =?us-ascii?Q?qjj4rIlYSg0/HhLG3Qtm0WOAJ3xdyollL33I+Cy6kW/zDfvLN7GCZoK0Q6Rk?=
 =?us-ascii?Q?ijyJeymJHX2UNtBVRYnqoBjRIN1L7+uoztpoRa/k0kYY7YZ8O9dqSOCNq/hk?=
 =?us-ascii?Q?cldDvfmX3cSvMaMXW/gG/ue4mSAgEvTq15xAjUdOolu79h59AZJe7bUnNlLt?=
 =?us-ascii?Q?GimU7ToH0+x4WdGAziKcctqcQ1dmhrgTmNaTeYUFGvQm2lRS8AzH1oRPyjyn?=
 =?us-ascii?Q?/m04NPTT6IABBb/gKdId3/hutOf3i0pJaNQu4TJj8ZBkeAU46aeCuXbcdUa2?=
 =?us-ascii?Q?IBoTlmeak0FlITX5jLcbPaRsmUIukPUaPQS11lQGl4MXDjjGbMP0j46y9iu6?=
 =?us-ascii?Q?o8D/ovSiMkl3ue7CeYufFK9NgOmB0xqvwWaG1nlK1Opg3RTRfHVNT4HxxDxB?=
 =?us-ascii?Q?JKxkKTzfRfPaA84/Mc2s7Qr2jaz7qal7mWdi9KDjNUrO2RrabQremuK+2nEB?=
 =?us-ascii?Q?eIcqT3fU8LAaPpDmVSHTtomLzmokQgSCzomwJjRTDEYIzcsimRn5/9DHLhrm?=
 =?us-ascii?Q?Zahf7WTf1Kd8iIZUhVNMW6t7mVPhKea/U7n0tJ0hPnOOrghmDX0EPlaZ8d17?=
 =?us-ascii?Q?Cjy9+zDjROiqz+xIU9aq+I8bcI8eM/RgDoOPYP6BYW8F5sQtQy0cFinIzY1s?=
 =?us-ascii?Q?6GqyoKRQST3BklcaWuZWC5WjNREM9ik4H/8f5jE3fj/qebd40WHekTPUMoCw?=
 =?us-ascii?Q?xQvIUh89dA4Il5+XZVuP8CcGpsfEEbOfr1m+lTsCSmPHsjfazQvby7QtCMIM?=
 =?us-ascii?Q?szCGP5/ecfqbvABnrsQGj2aJTkmHkxsvy7uYIupCfhHK6IOxi3O5vLeNbI6i?=
 =?us-ascii?Q?D/XaNjwsVEox2kfaG6kfsWBYtvcUA5HrqDfeR+haNPN86LPSsHhTozN2Fjyd?=
 =?us-ascii?Q?3jVaKpmkOnwTiBcN3RfSYbuAsYslA7Xz/l6IhXJhPSiZOftXFvdfs+hJGw+z?=
 =?us-ascii?Q?AFNARzQpjl3GvXvBKdL5BVzOBpkMlD6d3bmjQKg/oEt7eQGn7Edr33rmNHIK?=
 =?us-ascii?Q?lWXaw/6tMGiffo3BuoIXVDWhJmof/Bkjow4SPhDGn6UuzFmpca0hR5VIoDrM?=
 =?us-ascii?Q?a8XTPdkad/FHGLRrm9nMl3Q1ky2574Ehnr1INjKC7aXPTcUF1hQOWR5bfQYy?=
 =?us-ascii?Q?MjeTcItNlpTaGH8OMll46BRuEpYDjgXw4uDQjhlSKpwrsQl0XcbRaGN508BY?=
 =?us-ascii?Q?DP0b4MWzcBz9yTkwGU5yi7wTAxRg43BKWUGX5FTN467PmmXhV9LHS8QAAevs?=
 =?us-ascii?Q?NRI8SfpRMLGfjAQbIdbsszvhK5g37slKMYloYA6M0ni6E/Bb8Xg6c6wrvaO7?=
 =?us-ascii?Q?s2ahxt17vAsR6jPuXGVuAyQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffae67f6-5585-4918-1c77-08d9dc9dc2fb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:40.4795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YcuiXJ1lLD8t7Lbz9Gi/KGEU4F9Y3E3iCo5v7RHX/6sRIKuVuaYwtsXDferbInGs8ddxQCj6zkFvcpkoIzDwuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-ORIG-GUID: bmZfErEu9_J-KgknQX8DA6rbCvF68JNC
X-Proofpoint-GUID: bmZfErEu9_J-KgknQX8DA6rbCvF68JNC
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
index bd464fbb..8139831b 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -256,6 +256,7 @@ __XFS_UNSUPP_OPSTATE(shutdown)
 
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
 
+void libxfs_compute_all_maxlevels(struct xfs_mount *mp);
 struct xfs_mount *libxfs_mount(struct xfs_mount *mp, struct xfs_sb *sb,
 		dev_t dev, dev_t logdev, dev_t rtdev, unsigned int flags);
 int libxfs_flush_mount(struct xfs_mount *mp);
diff --git a/libxfs/init.c b/libxfs/init.c
index 94a80234..c02992a9 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -724,6 +724,21 @@ xfs_agbtree_compute_maxlevels(
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
@@ -768,14 +783,7 @@ libxfs_mount(
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
index 064fb48c..accac5ca 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -21,6 +21,8 @@
 
 #define xfs_ag_init_headers		libxfs_ag_init_headers
 #define xfs_ag_block_count		libxfs_ag_block_count
+#define xfs_ag_resv_init		libxfs_ag_resv_init
+#define xfs_ag_resv_free		libxfs_ag_resv_free
 
 #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
 #define xfs_allocbt_maxlevels_ondisk	libxfs_allocbt_maxlevels_ondisk
@@ -110,6 +112,7 @@
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
+#define xfs_ialloc_read_agi		libxfs_ialloc_read_agi
 #define xfs_iallocbt_maxlevels_ondisk	libxfs_iallocbt_maxlevels_ondisk
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
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
2.30.2

