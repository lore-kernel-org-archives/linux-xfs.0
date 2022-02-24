Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824FEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiBXNEg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbiBXNEg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:04:36 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379D937B591
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:06 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYFnn007314;
        Thu, 24 Feb 2022 13:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=nw4tqk8CLBGJ4fVJU3m6EZdSHmd4C5VV9CBy1hKy0s0=;
 b=hHkoVbHU3/q4jiZJD+jrrFy97NU5zNU9OUD+bB7sZcVXdlcruwqfMTCMPMhn3ryIqACW
 MB8lFsCrlBdVv8Zj0BX8UV1JXkXY3fL1lT8iOY5AeNLVejIscsQkU8Crvgx2ZuQYYKXi
 Zc9HJV7jp7iCQ1AOyJFDDPDCpkAcX81ArJRTFIzNqif6SfRLfj2FZkWC/Sq4RCCLD35+
 B12hs2WEH9EbHTfy5+//hgwpk8l1yqzeMj8ES0NemlFyHkLEi1P89ba6ZTCe5XKAl/4V
 kNuJr/s9Q2Dvwi+3dTkxpY6VHc2Y0/TbhxcCuJ3o915cCEu1AgSZwZrBiuCpe4AUbrOH RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx7b4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0Xl4120527;
        Thu, 24 Feb 2022 13:04:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3020.oracle.com with ESMTP id 3eb483k856-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/5AQUgjz0z3lY+lLs6ZFqOBaYa3WjNKQHY4hLRmOCyniecjRX7N+fwSeYotRrQ0t6Au+3NcD38ND/jWoMs9PYE72Hdw9ikWMK7EUFswiOmcrk3yQo7p9nqG7Fz/BxHlkCGBYXxGsreLLnRh2lW3P1JFwcpXV6n8BHzGnTfaYmcgrqARmgn6pmRf1y+6jVFCH/rdn1v75CpytTPn8f1KVLZ/hlSHA36SWpzhh4N8CQhLwvVzFs+L4ogSZjOglY/gqoiUeNIhb2V3kaGnC3OC5fF4O9darvglKwmXaz3fXI7mRYTO1R2agGGVnr5PmZmV+3rNDJ5TAVmt+IWYL1cX/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nw4tqk8CLBGJ4fVJU3m6EZdSHmd4C5VV9CBy1hKy0s0=;
 b=KMXmYmSLF3ke8ErBZcEizBLMfwbcvvy0Zgt5oSwN9E7rd/en68WdIXJozqtW0ph9XWwCFD0OMQ961wuYggIWaf1nlwF9lTz5QWc1bzBKtDlNghMi9In1Gij8wCxH1BqvOxQt2EpMhoT/+DAlFWwsx8Ge/39KMmhuAQT+5sIL+xd/eJPtdeqAK/5Qsf5AlARztw6js1vuNjY2Hdx9wy/1zzvMlqt3MZ2r1lo8n22CZueM6RvCFQUiJOkWXtZlg0nisQsLBgGWCb9qNq9ZE9xD8QE0ngTGAYxqAbW9yz17EUOmFs8woyLpye4nVTi5sJBA/uKYRZCgwpqlIeFNu/pN2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nw4tqk8CLBGJ4fVJU3m6EZdSHmd4C5VV9CBy1hKy0s0=;
 b=xLdN4AsUAtO43XBfpMZ3dcbxrXnXbk4CLQsmwXVkafmnkfucOlduUMtCel/aNBGBTXAQa2AppObJaXvgLwkNRdl5iwD4qrs0toNWba8OzxqNNi9sEKIdI55T6tENA/jUWtITBhPJjgPqT7H/7OoDFFZeaXh4/uvmeKVwJ8GMFUk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:03:58 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:03:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>, david@fromorbit.com,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH V6 01/19] xfs_repair: check filesystem geometry before allowing upgrades
Date:   Thu, 24 Feb 2022 18:33:22 +0530
Message-Id: <20220224130340.1349556-2-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 33534e60-6d0d-4154-00c2-08d9f7961ebd
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB46349D150E782FEB1AC95B03F63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Im6byZGxbQhBjvgNZeiqUvCyN3YjkahyKP7UCDE9kS9vQnUnF/UFb2WycAdmt4qlVOiosrLW4TEHaeqf+2U7vamnoRlAV6XM+0Yx1LWbnMbHN0O5j3cLJb8gHLTTpUJ4sEzMvKKSJtFXWf0HsL1Chs6LAWFUmKSgjvMkBtVmgEgmxixOJAknoEGSUa344uOd9CZDfRpa0/9TwSC0+48zRYKsMGP1Se1A9O9Ecxq7LQJLV/dPhkzwtPgU4P87BDCr9RhG07m8K8AFGS6BCPgArofDEGxqyjoZnoLCal8u6ZhVDWNv/SPkL3Z00eo4YTxRhud66cF9GMSPorPttpZE8QerVxhL1panQAdSDWbm2ssWsKjqr1AIKImw4rgCSi9ey/Fsl180zikh5WytYzQlQMGDnAxOXDXtBrgNLi1tMyJJe4NxlSQ6hEYmnNp+DPkNJHS/qr0O/WOMxlh76zR9IOcKTLj3N2jBPR+AnryYEYvb96f0PYzBZjhUWegqcPAjkFOa/TxJII0bFNwEw8VTiIKaiR2jD+DN77geQ/A6LADUWMRsKiAWarCfZMFDMgClPYlZWFkdxy9Kd4/ZqTDXpYwOJbujlbVVV3ClE5nvFqS5zKVB/vHM89Uip3u3U6ss4tsOC4PDLWdM37DRELQd5KTqu4gTKYVKMR+UfrI9yUd84p8DC//0zq5/B04ZGVKCAu754Usu94TxZdnMo+sC7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(107886003)(2616005)(186003)(26005)(6506007)(6512007)(52116002)(54906003)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P4qeA9WPaRFEmswdY+qJIVeQ/HbnhcCY1C5Dw+4RlO3ADk2X1L99jSVA5qIU?=
 =?us-ascii?Q?HKtRtzO33qZ+N9svc0iliNoEFNybA207v+Q0IXs8LdhRnja7RxUH9uT/QxJH?=
 =?us-ascii?Q?fs05WLzRZzIOch3pCNTWH+hyGp7n96UoKcMPGwI4wn1jeJF3dprfpff+BGhi?=
 =?us-ascii?Q?xI+koC0OizhVGQgsXzZc/2PYZ3n1oj0mWRV6shkRV28+ATOfZ7dKlq4xLlYC?=
 =?us-ascii?Q?Ma/jHe0GoMYGyQwTfvpj5Urw5C3usfHL87ymaRi8mLn2YrFmZudFUCBcM6+b?=
 =?us-ascii?Q?UOx/4Mf24GhFPqM4D6VhqEJ+ZobJFpwVZy4yG54YhzmqJdxV7P1fQprVTeeP?=
 =?us-ascii?Q?g7ApLRwHC+CISgWqaEHOVdwFol4oj7+k2Q5wKpPRchDEvUdSwk/nzUxyLgDx?=
 =?us-ascii?Q?9xn/FK5cli6uU4yxF3IStq7hfpz8H7TuyMzfW2UpSpM6XdST+kvM2V7Hcj9I?=
 =?us-ascii?Q?XGWRsO6w8M1W2ypYiwQCQLDoaE669D8z/FcTpD0C5/Lc4jgH8RjaHOgIUZG2?=
 =?us-ascii?Q?IG+AHebAYR2dLCjCE+e5BLO/+ZcXjk82aFH1D5Jixja8cYoV4O1elJJS2Cn/?=
 =?us-ascii?Q?1WUi21Oak/JQhii4lvuKfp0SF1skBStXP3Ki2reclCLoJ5glEjz3DfP7Yg/9?=
 =?us-ascii?Q?2w6lzg4oVi/q2qyLhV8NWZrtVD1iIYSzB8z59eikUO/ofLWKiH6zYEn4cMA2?=
 =?us-ascii?Q?eBMnVjEdrLN/XOcwtmFyiQ3qP5CqJ2qvFjilmAMKmNxkkwC1fpMKL+mbNo6z?=
 =?us-ascii?Q?TLMttQUddsIphcDnL/Vo8VKN2XZ6FyzwO72cLfnWlXSi29lo1jJ8vpW0X0Oq?=
 =?us-ascii?Q?i2usvnmiSSTFeI/IbespOU5jVZXRAUItP7JwVFg1ZXFyIWNUgANbfSyvif4c?=
 =?us-ascii?Q?z2NF+N8flDWhiqirDrKTzXi01/O+FyKSDkyXkRcMlOTbMVkpzcnBAXUlWiUt?=
 =?us-ascii?Q?LCEYiUYza8rMPKqMq6/WIhuMSlHaUcOG9XCSCSrCaKKpK4F/D9miBhtPct3N?=
 =?us-ascii?Q?liFqi7PrHs2dpJLbGpwPHSWKMJv8Nce4m8JX0m/dW+7gmRVCdv9Ym09VCXU3?=
 =?us-ascii?Q?qkeFK3SaSGneOg/YkqqUbKZ6RDVxe8zh29VT1ExSGz2repWaXUOH0S3ipE0Z?=
 =?us-ascii?Q?G2u7WPggYuPjQ7fpX84oqAq3Q9iDe23BN4sgZlzU3jggbzlk+CXZZKUsjrDj?=
 =?us-ascii?Q?hCgY3KW6+7p1TzgaB7GtQrxMGW1UvC3cpnnpEbkYam0dXMr9LZPCR9RW84Ga?=
 =?us-ascii?Q?9KH+1I1J+hd9PNkbU9yIfetjZNh2RAW3uy6EFvR2wzU27JOI763h0dZF7HGa?=
 =?us-ascii?Q?4hDJk6NkuHpsl37/1jAaBlP5rk2Jy8ZnS5y1UM6r8hHtpvl8TC6t6dN/auqd?=
 =?us-ascii?Q?deJG2frDAFa3umA8puxAyUHrf4yykiRyMRphg6OdW0svqsmm76gM3oe0dUKc?=
 =?us-ascii?Q?Dtwj9ZWTJbqC656rbDgtFBy4a7dXjQJOsncBjGqAz+EIIPZkLvXJerXGWYyO?=
 =?us-ascii?Q?wCa0pae3M8p+SolUuVIKDs6/rj46dY5ZANoYwuQ5i8Kgbvs/aVjZUFBEZgZS?=
 =?us-ascii?Q?Zd6KPUA0M1er5KwztjMTMOegUFTGutPNdbJE9kLVSgZ6rCSN08Z9zj8OZ1zr?=
 =?us-ascii?Q?NYbFDT8vxCA/9TfL64to89o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33534e60-6d0d-4154-00c2-08d9f7961ebd
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:03:58.5199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +XzVvlQyjgCLLRX0Bgt/d2hGn/86gXJQPoi/zahVwy/FFkoE8Kv5JSosSyHtraeRnOJ4+/fDPyN/3bPXl3xQGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: P8ABpYJYElKflFzjJR_IddHURxr8dJ5f
X-Proofpoint-GUID: P8ABpYJYElKflFzjJR_IddHURxr8dJ5f
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

