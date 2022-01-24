Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E58AC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240967AbiAXF10 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:26 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37422 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240939AbiAXF1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:23 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20NLrdwM006335
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=b3QvAZYdiJCnXPXZMhURwS4p0kc/zPMIpKafS1Q+HdQ=;
 b=P9t5vvartHKrRCAXyFhnDP+46kTSUX/9yLnCv1y9tT2hX7pVhmSMHXzUR8ogVNBho5hZ
 qEh2i5921loW65bAkAJW+hBdYeW0bNmN6XdCMzxk+MzJoNMFrn/2qFMyJMhPgrhAZRIo
 oF+nTYb46fHN48/l0Aa5uPEGStaKhmyut9vd2yxyL6EzLn7Srzzv/Dj7dgFF6PCE7XGf
 Vi9v7XI1kUBEEQouHoOtq2ZXZgaCeJwqSWB5mXvvnxo8iaDIxOQOlmXIMvXiLhy2etp4
 3BHmVwyfaZZJYQ9dU29bUJ6lXZvLOL0FNXLfg2RLYRjNW7WYd198BtJuoN6shRXdkW4w eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dr9hsk336-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5Qrg4087839
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3030.oracle.com with ESMTP id 3dr71up24e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUw3Ln9xl6TqSm4j8eFCs/VrHK8vBysJ3lDfzJ7Y1zWjzcNceY9518Lxx1tJyaRc0dmFB0Da+CS/mUCHhy34NP9oQk9KE92BoyxbGmys8PIUUvns5rrLQ60uPNZ4YKxZpjv6GjJmnKxtvdhOtAnVc2UQakXEj3Ih8oUdSeZ7Ufp+5MhS6IdArq/irme4OOemiQzBEGSIBqGamv8Bz5blJNxeUNPgp6uzQ4r0Gg0C3SNOy7UCLqxWDynlsv3bLL6hWLzd+odVMLV0e3JH/QDqtjwunXX68/BCQRho3/XYQiV6EhrDEhlypVOiSpFwirPOQbwfRedlwB5aQk+ziETGnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3QvAZYdiJCnXPXZMhURwS4p0kc/zPMIpKafS1Q+HdQ=;
 b=lT1kFimj4MgDnj3axyF8HEDGx+ZRzOg3GTn+c6eZjWP8XxZ2TjXPrVRm2DcwQCrNl8wlU+XT+Tuwkwbipqg8MwXw/otCyqwFIWa7SWikexvGur5dGg/vYZbpWXJPInAv9SsZNlSv81LUDXmI1+KJCFqEnuOnE3XWPTJWW5It/9MZifFpbxGDLZCInLVUEL0ZMc/x+57tss26eAqF+oFaX14Dwc+d+Yu5dqGUBlbPgaeVGAAz8b7jx+KKizY9UWDOjvYOqbBf7udbHehgeOzDkGRZ556K6eEs8QFzCOv7vh24o1B/SSTUq6/1qHkaam+qsTXh/do35V+cGkAgygSv3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3QvAZYdiJCnXPXZMhURwS4p0kc/zPMIpKafS1Q+HdQ=;
 b=MX8wdB/cGo4kqK8hwtO1HfUp9Fz9vzjdC33EW9Eq1lPzODa9U+iUWCG1lNp8T9KP0ngZ1TZwgryWUMxbNpI38AK+hznKeqEP8GGY3SRGS4TwSlKTcud6uPMPrbr3VfDlNYtWOA/DkJy31f1XnLvkTFg7wLtb4TA2haF6eGg7B8g=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW5PR10MB5874.namprd10.prod.outlook.com (2603:10b6:303:19c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Mon, 24 Jan
 2022 05:27:18 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:18 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 05/12] xfs: Implement attr logging and replay
Date:   Sun, 23 Jan 2022 22:27:01 -0700
Message-Id: <20220124052708.580016-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124052708.580016-1-allison.henderson@oracle.com>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29fadc19-6d48-493d-8860-08d9defa2f80
X-MS-TrafficTypeDiagnostic: MW5PR10MB5874:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB587491A97CC41325A01AD40D955E9@MW5PR10MB5874.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:231;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZTZQk0puw5jnZLPtVj05bQzcWDOFiStwB2SlFoWQ6RXRrE3rmyzDW8HyHD6Dvvx1Q+z6sc3jDNM9KPZmrPxUa6ibKx56tHa8LfTMn7PcluST8QYnb5XeJ3JXxKfBnWM4KsMnB7ylIHEaJtX8uL8TR9DfP9yRyNMtk+HWkQU/hg/VK1IuO4YL4UcnRt+48UrjNX9glURmsylhUFDP7jEr2Wsb43FB2qvPANNTSYKs67zX743OMdZTqr6bKfu1IhX7Uq6rtBXrS0cec6jJ/gd9Gv0tGOqHey1ppgk2QiHDsu9gBbItrb/Rm5KdjfuU/2SWaDd728gWGJh1fbYAC64MwJUZ0soRMcM3/CFWXuUPd9FXHC7Ft1N53HNGMdBSm7LjbWzFFHADP6YlKp4TgMwhDFENtra4wQP+516cyzHOqbILiTw2F9SwEN9YN2T09i88uLoaUrw1MEwcziUq/Mf9VNK9JCqg4/S2WbL60Y0PVceBk4axD8D47gKoSoxH3R2iGdVHEHDz0rAaM1qcxqiW6Wo19TgBivhU8AUy3MFaFgJvD+2e9U7q99dlUk+J/t3gvfXlNejwY9SqXhaLP42VGwPlwMvVzL0buQl3C5wCN3GhahLXdRsJVxP0RvgTQf3vL12DcOaISXOoUr8SHJVQ5WFU4TGAJARyicRyyBDeXh2jC155GuoB7nI/pDsN5oZ6xq4zkQb1PpVEkG8ZvmIoxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(66476007)(8676002)(6916009)(6506007)(6512007)(66556008)(6486002)(44832011)(1076003)(2906002)(83380400001)(8936002)(38100700002)(38350700002)(2616005)(52116002)(86362001)(508600001)(66946007)(6666004)(316002)(26005)(186003)(30864003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l1H4qRkkm09jnz80OTocNORhnVcY9FU02/HmxQhrBdxni+dt6u/EPXCZprD+?=
 =?us-ascii?Q?t3WhYWail9hDviMHmdb2N03zmKa7BqUlBDqhZR7XbLLgVYxhHYMJg7aZQVN1?=
 =?us-ascii?Q?iYPSaRM8pm0+GLmyDlpx6u06ZMeSOjOqrAe/QzqZlPLqLGXn3Fikbla32pWB?=
 =?us-ascii?Q?2zj3krtnHdQ307vNzTGWqrlirBzj5BX+AzQ9yxGm6deqHGvDNDoAwNjxLcSN?=
 =?us-ascii?Q?VA/Y/jYGe1OBvTN9SZTVc6OM/PvdYB1tZIl8qvqUDORlIp1YG4R+MwcbfBBF?=
 =?us-ascii?Q?sjHx4IliwoMLcNpqNQUyvVAG/yHhde/imtTD/kuBGNJ9dRPeIYeJZdsHqbhK?=
 =?us-ascii?Q?/veOL6NGjZmd+sK0OG7YANx+idNxHFO1c9xzuAMmRrFhY0upm6e8tiY7Qm6S?=
 =?us-ascii?Q?XWvN8T/WN9RbEKEXh9BCSJFP7Jl9tb1Mo0cxIcviFOxgjjb9+sqooOC6fkdF?=
 =?us-ascii?Q?9wxt3H8Oq4A3H3zyimT9TJvdCeTc1YieFnG0XvzQkIi/kYweSKVX2rBeTL0L?=
 =?us-ascii?Q?AelEIytdhHVfA1az4ETgeRkVC2/y/T7aUw272Xmgn8umO2KoY8Wz4kHUXiEb?=
 =?us-ascii?Q?omIm7KK8wZPJsDmyw8zAFHEXF2+N14F6LqHEy7JaD8X/DDMgK6QRmEek6fzu?=
 =?us-ascii?Q?QCKO9P6To9H/R3aIXb47DNX0QCRCwQYk7HKPBgETIlqsf8nJyf0xsISfnt1T?=
 =?us-ascii?Q?2n126YZLW8nUlSyuuN44xFUV2QoaSWbTFYcGHcvVRD/vkp7qk4nNxRX6+gYq?=
 =?us-ascii?Q?T8OpODP2G3xArsz6XfpXtiSRljeKBvjqQ8+kP3rYutjwPlcbQ7z3MVpuuiLP?=
 =?us-ascii?Q?/+noJaHV3BA1NclF6FxX3epwe4OH7lYeKrz21XexrtX37VDrUodyDeQrDBel?=
 =?us-ascii?Q?RA8iP1TRTbvTWMyZm9GpI3fwmtB6pGdbyRmzLgJ3lR0PJD1QWJokKs/1q9Vb?=
 =?us-ascii?Q?7+Qnw8ySAldP4D0cQhvLd8/cEklbNyBPIFZd+Zlh+FKVYeTJ+GvgprP7x8NY?=
 =?us-ascii?Q?ikK2vuYY009XxeKTNvjadJz+2qTIKh2d0fWSHPahVZEPTRQ4VC7W8t7XXu7x?=
 =?us-ascii?Q?Sbd5CGp9uR/I+oUaaB556vuEyGV7Hnc5Q1HZAmG318pE6gZgSkKEmbeIYCKq?=
 =?us-ascii?Q?8nd9HubTxFU1NOZwx3gpH8/7VxyQYNzZK/m1rEHl8IND0gHeWt3o4UFrYGWq?=
 =?us-ascii?Q?9d4oBMzwE5eVdXpj06RZSQ/4Uu74IIiWC+AqmOTxIz2+Cbc+Ehgps/i35CxI?=
 =?us-ascii?Q?6OTmm2M97M+XJYnHkKMwexmKfWBt8kHaIexxRWDP6FX7T433z5j0mT3tvLT8?=
 =?us-ascii?Q?scLXc5anQvsyhiqscAZljATvL7WEHSnL0ZHYzi3EfPJvlNH8kadm36vnilSm?=
 =?us-ascii?Q?uDtGVURPzThn+4HRrmGkYrXo52ZyA7PwadTmjehRN2NT8yw5m/IFSq3GDlmy?=
 =?us-ascii?Q?PUZBXWqZrjbykDFI+z94KihwyeueMr837Xp/nr6dVVO4onwLF0k9pxViFVb9?=
 =?us-ascii?Q?mQ8zH09y53GJn//wbZvPugQe0LAHU1xjsp1RTJQtOWniMGOk4ekZqFET0zUP?=
 =?us-ascii?Q?1d2oyKuGSTsQALNwd2YAHkSCIQeFhYTpOV/VbNKAeP3a3fO/zv2zK3WjD5tR?=
 =?us-ascii?Q?TgMnjaaavCB9MkFH/bOV8rQWCAJG9ySn7Dg44qyMmMpDBitK0mSDN++dRv0X?=
 =?us-ascii?Q?zNXs3A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29fadc19-6d48-493d-8860-08d9defa2f80
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:17.1497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dfn/mAw1/05MDynxI5l7wNUvsFfJHX7TMUcdxBosIaLOY3vM243jdul3GgJfht8wKhqdd0JVVWc436PxY/h/6Ysk9SDUofssLb6NPQXfEzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5874
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240036
X-Proofpoint-GUID: 3IFNPkC1_6AdGnw8bSiOwY7ddfWsanQT
X-Proofpoint-ORIG-GUID: 3IFNPkC1_6AdGnw8bSiOwY7ddfWsanQT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds the needed routines to create, log and recover logged
extended attribute intents.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_defer.c  |   1 +
 fs/xfs/libxfs/xfs_defer.h  |   1 +
 fs/xfs/libxfs/xfs_format.h |   9 +-
 fs/xfs/xfs_attr_item.c     | 361 +++++++++++++++++++++++++++++++++++++
 4 files changed, 371 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 214cad940a22..c618e6a98456 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -186,6 +186,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 static bool
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
index bc22bfdd8a67..3f08be0f107c 100644
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
@@ -314,6 +474,161 @@ xfs_attri_validate(
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
+	args->op_flags = attrp->alfi_op_flags;
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
@@ -386,6 +701,50 @@ xlog_recover_attri_commit_pass2(
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
@@ -419,7 +778,9 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
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

