Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFD1C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhLNItn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:49:43 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:29738 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNItm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:49:42 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE75Q1G004559;
        Tue, 14 Dec 2021 08:49:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=NVvX1kVHR/aKzuSjnoX2nyn3dQOWqPDM6Z54DEFPN/Y=;
 b=a0gQypvTtTiCu6sgkb+7ltZSrKPvZSMfL0DMhKHjYidKIHIqZsNducCFNbYbjm2XFF+D
 z/0DkolyRMt/Lqs3WJrBqoa2vH7nvT2Kmk20e8kzysdOnUqABMS/xbL9x+wghS2RB92O
 dOR4S82eJ3gik/HU/1nRwYzne1uF7ar6/wTBRm0guHZJXpTC6nMYAgaiJATjMqOIPrd+
 3IsRjZNK5lX/zX9A/rfls/PvHkmycFzjYosngIPwscLK00FhSBmQxfZcOSRc6V0X+XJf
 vCWqfTCO4ao/kWSK+MDB9+hTry6Xi58buONmVRpChJPsl+TKLUxJtF/im1eS2II5c/i5 sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3mru626-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8eS4F074188;
        Tue, 14 Dec 2021 08:49:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 3cxmr9yjbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOfksEG27kHJ9xqE9h+oG0dQMNOiQQdzBx5O1wAka0VqGX6LIf9HSR8pkkF6U31vXbFEkoS9aCIsKOVuRpjHvBua7dgnrH5LNeVJkrfoOheb3N7g84MDADGz4SziYX7kYvYe165Qyxb7qgweaG8kR9P1ntEH6QMHmIb6FvYesFAfzR6bGlSBkRU7BBvwjwyvsjYUNPvEvt75usQhi3JeYLugdrb8yKo0MzRDlKAY9TobHJg5DUWk5gZnTrCcHBEPrH5uOKYGaei5wFvwjnCOMFHe2LApinqYnamvWExYrt3Ee5tQji0EAPAkAYo+rqvds5LTGycNydNDGnrXc1+Acg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NVvX1kVHR/aKzuSjnoX2nyn3dQOWqPDM6Z54DEFPN/Y=;
 b=NZZ/ypubk0qW8odZIwxqW8EUI7jbmSXqY2/CmC+cDarcOAPcs4tEDotaZXSCMed26qzjz9+0Tle/X88t+w878serftOmsOnF9urhOVZEqAcQS+cDmQcwcx5hqQd5xdiAq1O/Q0gcNjNmLNpIldRKalI+huW5UjeekuEc9vCZWaNi/PiwWlO1CYE0t08gPrZY+6TYZy1xHiL4CuEzVb92tBzek77BrqrCAvpuotLY45LQA4uvGflbs7QygEncmP/iCFi0B3uRftpCqRn/Wa3VIQSlQe5O84wKDCRhiMbhHU4c4Rd/5NT76lEDQV6649PuhLnAcg9TVGvKUIfJGfFt/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVvX1kVHR/aKzuSjnoX2nyn3dQOWqPDM6Z54DEFPN/Y=;
 b=GGD2kanoA9GlGSyQ91jq/ykdGcyl2ddxy8XBuAFG7Ni7dwY2T0xY/kNGPqGnQDBrbUjL1T3cRLVaC8Sf1m2KXjXLpDN+JCMB78AMhmg0UVjl14RGDJLsuASEHeSibyVRknOM+VD7xARVkN+napBJalEDGf6IxNZ5ylpUCTmvdTY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:36 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>, david@fromorbit.com,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH V4 01/20] xfsprogs: xfs_repair: allow administrators to add older v5 features
Date:   Tue, 14 Dec 2021 14:17:52 +0530
Message-Id: <20211214084811.764481-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec0a6a5f-776d-44a2-53fa-08d9bedea828
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB26563A2FEA93E4859FA3ABE3F6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /bdC4xbLQQNttUGrN9EPIxOkCAEsj/H25nyqTE04DVenub60Pz5+7MoQaaWHJkSmlWsnjEkN7MJT4RaEzMvLinhukCNUsmi49tkpKWxtMBLNWZgmBWrmXCG0XDPejb0vN2847j3AWiJtEnmxzc4wVyxYTD4q2kcuq3dlArt08ZbGymVMyn7ku+VZGfV+msT04e+OC0/uW6bNx8hLkKV+jJIVKYqOpvG0cAGw0Ol2IIGZ/jbWz261c1I4omfeHpX8OtqFWOBjjff1OImOAP2XSxaKrnMoDy0Wj25LnAx8HYhCE5APzMWlrtq+hul5OVfNaALuPE3L4ZiGQuRty26hdhfEXM0m+U2cd/ghEizt+mKj+Gn7pgm1KULsaYcdJGrdvT4f09MGtlmxaRkeUnbRShm7FP+NNUZrTucK0H0nm/Qw8M2Qza909GgC/6zCeZKLubHVbnBd3ZsTUGudLt2uh2KRHLdZnpny2woQ+l0h3TzxkNkuv39Q/Is+lmpH6BHrqBnJcdYUIQiB+bdfkruBm5RjKT3ykpT3omcgJ6kq4Y2lcgZZaldoxvmJoxdKAp1QIJsStdn611YF21pMOw/JVAPtht/P4X/oKDgxFnGTmavHhY9zng2ldGhaNWByGB1nUk/Jypm55NJt4HsyN3E4F1xM0cDuhEXZ8smimh1iLBjCXpz7+NkOSZF+FQr/Nnh3E9JIeyBFse3mnzSPk2sSoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(54906003)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(30864003)(107886003)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/u+DEvyr/fdAI3Ek4kztwg18XtP3lsp0fRqF6dJuCUle8ygQfnp8WtZFUjuk?=
 =?us-ascii?Q?p2sSuvnBeTzUONLzb5jO+jsG6E8N3k5ZEv6PVreVejnP3ArDEzWLsDz+FmnF?=
 =?us-ascii?Q?3OHUcf5rgyAGQvStTsB3oI78d03ae22F5w7A86fg59jlMPt4nL5mVenYlni7?=
 =?us-ascii?Q?GunhWtLuRPwEoajnaMxB3nT55NjFyrfh5h+D8ln3YZGM2zdF8YWBf0wqE+mq?=
 =?us-ascii?Q?jOF2qaQ+UdC790kQ/OKFyZum7+VML04CQwqbJfgsPf1Ee+WTIpi4krNzPiTh?=
 =?us-ascii?Q?ia0pMdxEMwsKK4fk5vwtgNoQGX0lgvjnVqA/1lT6B9QWY2FIM05nNk+smI3B?=
 =?us-ascii?Q?GKZSXoUpDK+F4HM8/iNehJ0OEwlyvFRLBBtkPKn1SG3Y3N0lc71RbOkBlTQX?=
 =?us-ascii?Q?9HN07ozb5MbSfCq5k0Z+L3xeGW5ik3LQvHUrCOCuJQKZ9dYZGVr/sF6L7K8Z?=
 =?us-ascii?Q?1W5yTFQreYl2IfcVM3d2vCGPph43ptoA0fVPFTo3xbRrYtN6NmAsShXo+ADm?=
 =?us-ascii?Q?SkMHTuAjxCQGwX1Ol47W684pCReEgzHw8ZXUye22osUyaFd5ul0cS1Xm9HX1?=
 =?us-ascii?Q?IoBI3vKdnrV0kuSkpuwAUDFx05596BAi6WK0nGBJP3x37nFAHkKbZwzVPStN?=
 =?us-ascii?Q?iHUtQBhnLtr8uMeJRjSLs5EKTmi7F/cXaBIuHrusR3NUClMvdDUuXb0GKjBn?=
 =?us-ascii?Q?zxocDwdOf24Ie1ooIhb61DxiDMLFmjvF+SKOv7Uc2dVtqJSXOgqRD3qrj2w4?=
 =?us-ascii?Q?wXLwdIbvmMzGR/U7hhRZ9nFr2qtP3/TCJ6GeoW1dd8E/tAtDTFYkOwpTgdBL?=
 =?us-ascii?Q?rta6IRrGJF5QtxMNtIPHcqM0M9AnNfEvniqroFqJv6ypVWPhGHy98kTu1SpN?=
 =?us-ascii?Q?AaSBLnY55gDp7hzJYa2k8vd4eGreQX6WBkpsP4RNFnf694eiW3avg/QPN6fP?=
 =?us-ascii?Q?pcp/WbFaB1Om2MBBUrjrTM7QvnW4Cfsl83NgWZq0F13FdJd94c683O+HuNxT?=
 =?us-ascii?Q?1zpCGfcsR26EIyu0ME0y1kqF/Kkd/9Yw6nuVsKowiJmDETmkbGDsdZqhaX3C?=
 =?us-ascii?Q?GGJgiEIrd1f6H52oXL2T6xTUV1n5TsbUQD3+g4T5KcJT4bLbSxV9qmysPKZH?=
 =?us-ascii?Q?YLlZBt1heYuXcEvJExajowxy4c5tS+UhIsGre/cHRSiHaxTPcY2havghnkX3?=
 =?us-ascii?Q?GW9Fd6eShuzmfb8498mZiBJz79gQkrAzBj0VBr5e9MbK4uzvd4r2V5NZnF7b?=
 =?us-ascii?Q?0GT7N9J1DxIkQK++2DZt02e/g5rUfub6WFFS9w+gpY9HOKHEGbrXpXUlG0my?=
 =?us-ascii?Q?ogEraEFtrvXClMxgNWgOSwBxpgmpr7x53fMjJdGcXYqLLEu45jUOqd8xLHU8?=
 =?us-ascii?Q?Tf0jI7XJxGpCLBkbz6WSqDoRM/lI6bX6x+W4DylihUxuZl0pdMdhDd19TZH9?=
 =?us-ascii?Q?q3Ei0XzW15O7PvhJIe5alByf0i8oQVq4nMO1jQgypisTeVSw+7xsVcmbaIzU?=
 =?us-ascii?Q?aGbcGGfkLdglrX+BbFJXiUyvcz0gHD+ZgvowThi20Gdb1xs4/a+fLMAPDszB?=
 =?us-ascii?Q?0GtdSBVRfiuvyGlh2eflSaPBKjt88UhST/vl+uhQFJpJz+kVbpEJ/yHDWEyi?=
 =?us-ascii?Q?Z/bZyOxy0pplQdPOrD+Jt0k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec0a6a5f-776d-44a2-53fa-08d9bedea828
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:36.6860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8GQtzyeIyNYpj2e1txYLJ0NhkAZ2tBL+Ec8kMnFYEFX8blbTyLbiqBG0Snwmq6l5Lcn13WrjUAQDPTr8NvJ4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: Hh_L1kAY60BEbdQ1PYgw3PcHNuOgbcrq
X-Proofpoint-GUID: Hh_L1kAY60BEbdQ1PYgw3PcHNuOgbcrq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Add to xfs_db the ability to add certain existing features (finobt,
reflink, and rmapbt) to an existing filesystem if it's eligible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 include/libxfs.h         |   1 +
 libxfs/libxfs_api_defs.h |   3 +
 man/man8/xfs_admin.8     |  30 ++++++
 repair/globals.c         |   3 +
 repair/globals.h         |   3 +
 repair/phase2.c          | 221 +++++++++++++++++++++++++++++++++++++--
 repair/rmap.c            |   4 +-
 repair/xfs_repair.c      |  33 ++++++
 8 files changed, 286 insertions(+), 12 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 24424d0e..9ca1ed86 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -77,6 +77,7 @@ struct iomap;
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
+#include "xfs_ag_resv.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b76e6380..c8a4a8a0 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -21,6 +21,8 @@
 
 #define xfs_ag_init_headers		libxfs_ag_init_headers
 #define xfs_ag_block_count		libxfs_ag_block_count
+#define xfs_ag_resv_free		libxfs_ag_resv_free
+#define xfs_ag_resv_init		libxfs_ag_resv_init
 
 #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
 #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
@@ -109,6 +111,7 @@
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
+#define xfs_ialloc_read_agi		libxfs_ialloc_read_agi
 #define xfs_idata_realloc		libxfs_idata_realloc
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index ad28e0f6..4f3c882a 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -149,6 +149,36 @@ Upgrade a filesystem to support larger timestamps up to the year 2486.
 The filesystem cannot be downgraded after this feature is enabled.
 Once enabled, the filesystem will not be mountable by older kernels.
 This feature was added to Linux 5.10.
+.TP 0.4i
+.B finobt
+Track free inodes through a separate free inode btree index to speed up inode
+allocation on old filesystems.
+This upgrade can fail if any AG has less than 1% free space remaining.
+The filesystem cannot be downgraded after this feature is enabled.
+This feature was added to Linux 3.16.
+.TP 0.4i
+.B reflink
+Enable sharing of file data blocks.
+This upgrade can fail if any AG has less than 2% free space remaining.
+The filesystem cannot be downgraded after this feature is enabled.
+This feature was added to Linux 4.9.
+.TP 0.4i
+.B rmapbt
+Store an index of the owners of on-disk blocks.
+This enables much stronger cross-referencing of various metadata structures
+and online repairs to space usage metadata.
+The filesystem cannot be downgraded after this feature is enabled.
+This upgrade can fail if any AG has less than 5% free space remaining.
+This feature was added to Linux 4.8.
+.TP 0.4i
+.B metadir
+Create a directory tree of metadata inodes instead of storing them all in the
+superblock.
+This is required for reverse mapping btrees and reflink support on the realtime
+device.
+The filesystem cannot be downgraded after this feature is enabled.
+This upgrade can fail if any AG has less than 5% free space remaining.
+This feature is not upstream yet.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index 506a4e72..d89507b1 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -50,6 +50,9 @@ int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 int	lazy_count;		/* What to set if to if converting */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
+bool	add_finobt;		/* add free inode btrees */
+bool	add_reflink;		/* add reference count btrees */
+bool	add_rmapbt;		/* add reverse mapping btrees */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 929b82be..53ff2532 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -91,6 +91,9 @@ extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 extern int	lazy_count;		/* What to set if to if converting */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
+extern bool	add_finobt;		/* add free inode btrees */
+extern bool	add_reflink;		/* add reference count btrees */
+extern bool	add_rmapbt;		/* add reverse mapping btrees */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index cb9adf1d..c811ed5d 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -133,7 +133,8 @@ zero_log(
 
 static bool
 set_inobtcount(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
 {
 	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
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
 	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
 		printf(
@@ -174,8 +176,193 @@ set_bigtime(
 	}
 
 	printf(_("Adding large timestamp support to filesystem.\n"));
-	mp->m_sb.sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
-					  XFS_SB_FEAT_INCOMPAT_BIGTIME);
+	new_sb->sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+					 XFS_SB_FEAT_INCOMPAT_BIGTIME);
+	return true;
+}
+
+/* Make sure we can actually upgrade this (v5) filesystem. */
+static void
+check_new_v5_geometry(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	struct xfs_sb		old_sb;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	xfs_ino_t		rootino;
+	int			min_logblocks;
+	int			error;
+
+	/*
+	 * Save the current superblock, then copy in the new one to do log size
+	 * and root inode checks.
+	 */
+	memcpy(&old_sb, &mp->m_sb, sizeof(struct xfs_sb));
+	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
+
+	/* Do we have a big enough log? */
+	min_logblocks = libxfs_log_calc_minimum_size(mp);
+	if (old_sb.sb_logblocks < min_logblocks) {
+		printf(
+	_("Filesystem log too small to upgrade filesystem; need %u blocks, have %u.\n"),
+				min_logblocks, old_sb.sb_logblocks);
+		exit(0);
+	}
+
+	rootino = libxfs_ialloc_calc_rootino(mp, new_sb->sb_unit);
+	if (old_sb.sb_rootino != rootino) {
+		printf(
+	_("Cannot upgrade filesystem, root inode (%llu) cannot be moved to %llu.\n"),
+				(unsigned long long)old_sb.sb_rootino,
+				(unsigned long long)rootino);
+		exit(0);
+	}
+
+	/* Make sure we have enough space for per-AG reservations. */
+	for_each_perag(mp, agno, pag) {
+		struct xfs_trans	*tp;
+		struct xfs_agf		*agf;
+		struct xfs_buf		*agi_bp, *agf_bp;
+		unsigned int		avail, agblocks;
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
+		error = -libxfs_ialloc_read_agi(mp, tp, agno, &agi_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGI %u for upgrade check, err=%d.\n"),
+					agno, error);
+
+		error = -libxfs_alloc_read_agf(mp, tp, agno, 0, &agf_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGF %u for upgrade check, err=%d.\n"),
+					agno, error);
+		agf = agf_bp->b_addr;
+		agblocks = be32_to_cpu(agf->agf_length);
+
+		error = -libxfs_ag_resv_init(pag, tp);
+		if (error == ENOSPC) {
+			printf(
+	_("Not enough free space would remain in AG %u for metadata.\n"),
+					agno);
+			exit(0);
+		}
+		if (error)
+			do_error(
+	_("Error %d while checking AG %u space reservation.\n"),
+					error, agno);
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
+					agno);
+
+		libxfs_ag_resv_free(pag);
+
+		/*
+		 * Mark the per-AG structure as uninitialized so that we don't
+		 * trip over stale cached counters after the upgrade, and
+		 * release all the resources.
+		 */
+		libxfs_trans_cancel(tp);
+		pag->pagf_init = 0;
+		pag->pagi_init = 0;
+	}
+
+	/*
+	 * Put back the old superblock.
+	 */
+	memcpy(&mp->m_sb, &old_sb, sizeof(struct xfs_sb));
+}
+
+static bool
+set_finobt(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		printf(
+	_("Free inode btree feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		printf(_("Filesystem already supports free inode btrees.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding free inode btrees to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_FINOBT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
+static bool
+set_reflink(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		printf(
+	_("Reflink feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		printf(_("Filesystem already supports reflink.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding reflink support to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
+static bool
+set_rmapbt(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		printf(
+	_("Reverse mapping btree feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		printf(
+	_("Reverse mapping btrees cannot be added when reflink is enabled.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		printf(_("Filesystem already supports reverse mapping btrees.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding reverse mapping btrees to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
 	return true;
 }
 
@@ -184,16 +371,30 @@ static void
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
-
-        if (no_modify || !dirty)
+		dirty |= set_bigtime(mp, &new_sb);
+	if (add_finobt)
+		dirty |= set_finobt(mp, &new_sb);
+	if (add_reflink)
+		dirty |= set_reflink(mp, &new_sb);
+	if (add_rmapbt)
+		dirty |= set_rmapbt(mp, &new_sb);
+
+	if (!dirty)
+		return;
+
+	check_new_v5_geometry(mp, &new_sb);
+	memcpy(&mp->m_sb, &new_sb, sizeof(struct xfs_sb));
+	if (no_modify)
                 return;
 
         bp = libxfs_getsb(mp);
diff --git a/repair/rmap.c b/repair/rmap.c
index 12fe7442..1e8948a6 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -49,8 +49,8 @@ bool
 rmap_needs_work(
 	struct xfs_mount	*mp)
 {
-	return xfs_sb_version_hasreflink(&mp->m_sb) ||
-	       xfs_sb_version_hasrmapbt(&mp->m_sb);
+	return xfs_sb_version_hasreflink(&mp->m_sb) || add_reflink ||
+		xfs_sb_version_hasrmapbt(&mp->m_sb) || add_rmapbt;
 }
 
 /*
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 38406eea..e250a5bf 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -67,6 +67,9 @@ enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
 	CONVERT_INOBTCOUNT,
 	CONVERT_BIGTIME,
+	CONVERT_FINOBT,
+	CONVERT_REFLINK,
+	CONVERT_RMAPBT,
 	C_MAX_OPTS,
 };
 
@@ -74,6 +77,9 @@ static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
 	[CONVERT_BIGTIME]	= "bigtime",
+	[CONVERT_FINOBT]	= "finobt",
+	[CONVERT_REFLINK]	= "reflink",
+	[CONVERT_RMAPBT]	= "rmapbt",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -324,6 +330,33 @@ process_args(int argc, char **argv)
 		_("-c bigtime only supports upgrades\n"));
 					add_bigtime = true;
 					break;
+				case CONVERT_FINOBT:
+					if (!val)
+						do_abort(
+		_("-c finobt requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c finobt only supports upgrades\n"));
+					add_finobt = true;
+					break;
+				case CONVERT_REFLINK:
+					if (!val)
+						do_abort(
+		_("-c reflink requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c reflink only supports upgrades\n"));
+					add_reflink = true;
+					break;
+				case CONVERT_RMAPBT:
+					if (!val)
+						do_abort(
+		_("-c rmapbt requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c rmapbt only supports upgrades\n"));
+					add_rmapbt = true;
+					break;
 				default:
 					unknown('c', val);
 					break;
-- 
2.30.2

