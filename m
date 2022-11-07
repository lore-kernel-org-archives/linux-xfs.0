Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91CE8C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiKGJDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiKGJDN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96AD1659A
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:11 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75U5rq015656
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=emG4/FDtdxjOFCvM2+MStfC0/QV7EuaCJpmwP7TZA6g=;
 b=SoLwFGbEAOZZ9YMBXE1xEV7jrzO2O9ASF2eAcNdCIPQ8+iOeFZShFcemmVZ9ybV+tgdP
 s7BZ4MeVLhQoi3AszzSFamrZf2kA6TEeBCWwEr/J2Qb6LL6BLIKgBRKioqfz4ot4HayH
 15+wcLKdQjaKwLZMAuT49MnE5Es1oGLUvRb4dqgFkxoeVPU6UN7+lRp+Vv+9+FpThxQ3
 o+zojWHpInGrdouphkNsAYk7vMauRhHAoFvIpdjbptkBY/pGXtgD17XJvJEh2rhloszz
 ehe3T+DX3vRpdny+MOlS+/dSrnOqagy1X5QIz1TNpeKoUoy2a40/KshzIgQD/q4B7tzT bA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkw339w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77atQ6001448
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:09 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq0jm01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0wZ72WHuZ+MsbTOONaqmVvzJGSee4spqVppjJRKpTeyb0mnRUf1PwgkhxV+sQCkHJ9qveCGaFYkXpBvwjxn8MVfgh/PXri6IpfjwcI99E8gZ4TV470j/aESIdgITxnmTv1dbDpxIiHpU/XbVyukZepTCdLsZPE0jwwE8u/4fv+pjarUjaDhuNpAU6jblEp28Udnm40yTnKC9PdpIwg7ln6Uxn9dHiiDfx3HWy1iPpyFEleWCidGIlo38pYAW2vpzLBs06tZadzBSv1+PyTjmWSqStBAZnqZakA7aNg/FhyDG7q5X9SZ0bQaZO9hoMPrTw9LnEVLC1Z6uMzeHPqYSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emG4/FDtdxjOFCvM2+MStfC0/QV7EuaCJpmwP7TZA6g=;
 b=Rl49TESRQ2BBW7ubpoowJJtErbt2jClWtiVOAJmHU5l0pe+T6XLE471GSOee8TtmOc1f6GVxi29e/PVv7avUcZ2lWZ0eygMx5g+n3Nbx4pIGULhvffdGbzIf0WkiYa2Q6ONnPBVplWDhPhkxIDgwZJviH8QqHvx2U/XRY2HXnoeLnMNTn2rP82lePyj7DGvauzqg3JljFq5SMszZbKgtEToC2ujpdg+y7A5C3/VotptPRFDIyb7I+xwhAuueFeb4fVvgTB4LeZ3wPbPdpMGUYBX2vvMX9t9kknkn4YZnCxpmofOpODn0vbX5XLoIiptaqQ69iAt9zjk/K4A0xvzI7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emG4/FDtdxjOFCvM2+MStfC0/QV7EuaCJpmwP7TZA6g=;
 b=lYLolK7cFDwRYSNiKbbtnDC3+jvsnEQJhybyBZ39iqdCj/XIF7JazucwsgcSDHfIALGb0YQ7g5zpcM1C/t/JtscZW1JYx/hnPcYG49R/iM/SqWn6LOhllyhu6VUv8qdoFtEAkg3Bzmi7VcNoSPd3C3mRq26h+Ta2oOD9ySbch48=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:03:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:07 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 14/26] xfs: parent pointer attribute creation
Date:   Mon,  7 Nov 2022 02:01:44 -0700
Message-Id: <20221107090156.299319-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0104.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: d4044a72-f5dd-4f8e-e365-08dac09ee34c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ii58tyZychuap/xhdeGvWbuMdUo/C2uXO1LZe4aWMGq/+yohC+hqhvKn/ro7y0eraPq0M0lY7YWZwIZjkQ7P/KbKTLz1Odqu8iZh7DsJ2+mlhEfTnR/Dqi3qvlgfwK/Gh3InzY8j0YpBLR6HCgsuVlbdXFWjXjhuiYJKv5D8veb6p25BE9cex2z1bJT38vo+aPH64S+a6Wjg8iD+2JoZ5mrT7uuKpXrk4Ajf+wA48L40qc2fOsvGogIWWxhL/i7oTT34dENc986pHlVgpUU3g9+I53GST5nuZFzefJfLt6hlrnxq7ML7ei5w3+/+pzU3Ft8Ks2UqGaqolVzY9vuGZN6mMDDluZDKntXtJLeIkWmuoeOr624JRrJYTrF1HVRMm3aa5jR5SiVFOFc26CdChvAEB+k63GTV0z8XHXXVejDD6qbRCXPacgLFiNHe6fbtYGENbORg4HfiKiIjKovaIKhrswYFFDba694u3TrPdRDX+usQRdcXr6zFrZc/W9DS5HZc2bKd6A7cEjC6h5zCKNq0DBL9Mszqw7e4YI66/c8B8QTRjllnr9JlMI085T9OPkwKrEOrWldbC2p5tmujZAWOaqIndT4ofPK4H1V4pw8ph8Mip/A9oT7mHevPoIRx3dBYHioOqJ4rd8tIvSO5uC6JVvvzcx/XTXnEzcpF7wJF2L0TSJGBNVynKBbFbKEtzvohRv7I78/0NV452P20ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(30864003)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a4CEJfYPBGebAjfaKNcgDIerPOGvlvIs2BDVUt795ejRG8XnxAu97rP9CRQv?=
 =?us-ascii?Q?K+V4iwhgvd2CrgcI9SGVX6hoiVDk0dLF9hPQz626BgbymZ2zVu8XD6WYN48A?=
 =?us-ascii?Q?9kjCqjTlkzj6xl64J+mNXecwCOorCG+a2Juou8lmM/rfhOXOtD0qGrWGP9TB?=
 =?us-ascii?Q?BqHEtU0nQYTHoAG7w9AxaX81KuxKf/KbCEAfdm69x1WuYQgp7mUYVQasAslf?=
 =?us-ascii?Q?tt0g5Ts2PE5KHJzH9pDA5iPW9pFDKtiCAokE0k+BFdrZ1ChNzYvsEZnBc9yc?=
 =?us-ascii?Q?twWwUcS0/cNvTb/OwYd3Mr19UkxnQV0lcqnDv2KkvAHv9cDc9T4V4rkd90MI?=
 =?us-ascii?Q?M+7vyWKDButwy9R/ylQY5+X/nuyWIpvJrKszwVzQIMeiK7ID7TZpJ3Hfbdz7?=
 =?us-ascii?Q?dyNBZtFNqxl/X9bRQf6LJOb71NBLUps6ecDh8KhYlqDobKGs0jtw6IezxXTf?=
 =?us-ascii?Q?5PMvf61DGwEwbyq0h+vaBLly/FgTf16Sw+B5QszcuDvez3NiK4FYLVb79kAV?=
 =?us-ascii?Q?RFm6xHY+OlMwVzRQ9eaR37sZODf4TtXXwDymPBDRnBNSKSvZoRKWL6znnvZb?=
 =?us-ascii?Q?0YBQuhqkSTu7Dd7AUEk9JeCf87tiBznQGjwT4oGSVb+qEs/I2vBd9fMrRA85?=
 =?us-ascii?Q?l2CS8/TXJ6Z5WKQvgQojsaikTaYKCYzaF3zH52TFebJLeDUITfqptZmt2H66?=
 =?us-ascii?Q?gAIJj4TfaPSjsLkG52yVCK6wf8hBjp4qwDZ6hzf3B1HOZAB34Y2NRywj4c4i?=
 =?us-ascii?Q?BHWA/klwm0HWjUKWB+AosS3KBS03bhSOoGLFuW7iMorgnercoSO7Wpp79RJ7?=
 =?us-ascii?Q?KM0eA7oFp2ceqL+nhvzzyAU5lhHQFnYEYvdvjgqIIMCW55S8IYzPMGqniD3Z?=
 =?us-ascii?Q?QcPgVkwtoCXV5ixEaLYXLwUBwsu1iJW1CxAMDXB/W38SSgu4E31AdDJ6wZmX?=
 =?us-ascii?Q?m8TgcjwnQxcdc3zog8j7yvSsB9XUOUJVapy1bITlas8M45ugXTWsFA5h9fO+?=
 =?us-ascii?Q?8aKBubutMGtmvYV9CUB1w4UblRH2876qStquN6NRbVeTybGFK3GTLjLGq0j3?=
 =?us-ascii?Q?roI1SRz3vVdpcAAC9puVUtAU8imZInbxiPelVN0VF6u2fZgv/P9o6/hhCNUe?=
 =?us-ascii?Q?VD80XMACPN405+Asjhazs+WWeGbOZ3AsaN2WTgkbAB5yya6LMliml7nzOKUO?=
 =?us-ascii?Q?W3kjjvFDYBaAS4lt2vkL8KVCf3ZwJSH3x5tmkpYfVa6Sfv5C8DCQtbSEAtlW?=
 =?us-ascii?Q?s2CKtSPINDrW87Z0lCt+rpacl3eev9Ewu8DfyGOA0znlneIHUBgA4XtDKSvM?=
 =?us-ascii?Q?AnZTPdUf4dadbXPhRZRejGIGJnZMg4sA2ODQdeh0KoWB9YANbU7vC+BQamwm?=
 =?us-ascii?Q?DwrlFAAYhLgI9O9TDVm84VIUCoY8Ox+O2sRl3wcMuKWtQRXQTD7jzn7E/vaE?=
 =?us-ascii?Q?yYA3pUqkd+nmmtfqzSRuxqUUcbWFGQw1p8O+sWLulgaiweJ0OfyLpn0LnzsN?=
 =?us-ascii?Q?pziezl53LC/IbJeV/2dMB433Rwm9ujDIcFdb6a8f3tmPpdIdXpqMsYI3dDWI?=
 =?us-ascii?Q?XY4C+goIdwNvfpmOM/kcJIbkV1B8LpN6XalRKxCdH81irsF8sZAj7YEnKH2f?=
 =?us-ascii?Q?Rg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4044a72-f5dd-4f8e-e365-08dac09ee34c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:07.7960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qwYeTU3g8MRW5bRhx+3KqJ74n3exmxZivlFX+MBNQI0CaLcw4sQGrK8gRNFrFxyiFL56hFaOD8DN2qnGwVgH2W3qlxHZNwstJ8nYiB/jfkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: 46Wbyqj2tu-33LVU-5Og3VT02IvYnxuV
X-Proofpoint-ORIG-GUID: 46Wbyqj2tu-33LVU-5Og3VT02IvYnxuV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/libxfs/xfs_attr.c   |   4 +-
 fs/xfs/libxfs/xfs_attr.h   |   4 +-
 fs/xfs/libxfs/xfs_parent.c | 149 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  34 +++++++++
 fs/xfs/xfs_inode.c         |  63 ++++++++++++++--
 fs/xfs/xfs_xattr.c         |   2 +-
 fs/xfs/xfs_xattr.h         |   1 +
 8 files changed, 247 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 03135a1c31b6..e2b2cf50ffcf 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -40,6 +40,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_parent.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 711022742e34..f68d41f0f998 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -886,7 +886,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -904,7 +904,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b79dae788cfb..0cf23f5117ad 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
@@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-
+int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int op_flags,
+			 struct xfs_attr_intent  **attr);
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..cf5ea8ce8bd3
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
+#include "xfs_parent.h"
+#include "xfs_trans_space.h"
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute value is a filename component, it will never be longer
+ * than 255 bytes. This means the attribute will always be a local format
+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
+ * always be larger than this (max is 75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behavior is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+
+/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
+void
+xfs_init_parent_name_rec(
+	struct xfs_parent_name_rec	*rec,
+	struct xfs_inode		*ip,
+	uint32_t			p_diroffset)
+{
+	xfs_ino_t			p_ino = ip->i_ino;
+	uint32_t			p_gen = VFS_I(ip)->i_generation;
+
+	rec->p_ino = cpu_to_be64(p_ino);
+	rec->p_gen = cpu_to_be32(p_gen);
+	rec->p_diroffset = cpu_to_be32(p_diroffset);
+}
+
+/* Initializes a xfs_parent_name_irec from an xfs_parent_name_rec */
+void
+xfs_init_parent_name_irec(
+	struct xfs_parent_name_irec	*irec,
+	struct xfs_parent_name_rec	*rec)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
+int
+xfs_parent_init(
+	struct xfs_mount		*mp,
+	struct xfs_parent_defer		**parentp)
+{
+	struct xfs_parent_defer		*parent;
+	int				error;
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	error = xfs_attr_grab_log_assist(mp);
+	if (error)
+		return error;
+
+	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
+	if (!parent)
+		return -ENOMEM;
+
+	/* init parent da_args */
+	parent->args.geo = mp->m_attr_geo;
+	parent->args.whichfork = XFS_ATTR_FORK;
+	parent->args.attr_filter = XFS_ATTR_PARENT;
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
+	parent->args.name = (const uint8_t *)&parent->rec;
+	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+
+	*parentp = parent;
+	return 0;
+}
+
+int
+xfs_parent_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*parent,
+	struct xfs_inode	*dp,
+	struct xfs_name		*parent_name,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+
+	args->trans = tp;
+	args->dp = child;
+	if (parent_name) {
+		parent->args.value = (void *)parent_name->name;
+		parent->args.valuelen = parent_name->len;
+	}
+
+	return xfs_attr_defer_add(args);
+}
+
+void
+xfs_parent_cancel(
+	xfs_mount_t		*mp,
+	struct xfs_parent_defer *parent)
+{
+	xlog_drop_incompat_feat(mp->m_log);
+	kfree(parent);
+}
+
+unsigned int
+xfs_pptr_calc_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	/*
+	 * Pptrs are always the first attr in an attr tree, and never larger
+	 * than a block
+	 */
+	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
+	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
+}
+
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..9b8d0764aad6
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+/*
+ * Dynamically allocd structure used to wrap the needed data to pass around
+ * the defer ops machinery
+ */
+struct xfs_parent_defer {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+			      struct xfs_inode *ip,
+			      uint32_t p_diroffset);
+void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
+			       struct xfs_parent_name_rec *rec);
+int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
+int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
+			 struct xfs_inode *dp, struct xfs_name *parent_name,
+			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
+unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
+				     unsigned int namelen);
+
+#endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ea7aeab839c2..ae6604f51ce8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,8 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -946,10 +948,32 @@ xfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
+unsigned int
+xfs_create_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
+unsigned int
+xfs_mkdir_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	return xfs_create_space_res(mp, namelen);
+}
+
 int
 xfs_create(
 	struct user_namespace	*mnt_userns,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -961,7 +985,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -969,6 +993,8 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_create(dp, name);
 
@@ -988,13 +1014,19 @@ xfs_create(
 		return error;
 
 	if (is_dir) {
-		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
+		resblks = xfs_mkdir_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_mkdir;
 	} else {
-		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
+		resblks = xfs_create_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_create;
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto out_release_dquots;
+	}
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1010,7 +1042,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto drop_incompat;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1020,6 +1052,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
+	init_xattrs = init_xattrs || xfs_has_parent(mp);
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
@@ -1034,11 +1067,12 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
+				   resblks - XFS_IALLOC_SPACE_RES(mp),
+				   &diroffset);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1054,6 +1088,17 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, dp, name, diroffset,
+					     ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1079,6 +1124,7 @@ xfs_create(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	return 0;
 
  out_trans_cancel:
@@ -1093,6 +1139,9 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c325a28b89a8..d9067c5f6bd6 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -27,7 +27,7 @@
  * they must release the permission by calling xlog_drop_incompat_feat
  * when they're done.
  */
-static inline int
+int
 xfs_attr_grab_log_assist(
 	struct xfs_mount	*mp)
 {
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index 2b09133b1b9b..3fd6520a4d69 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -7,6 +7,7 @@
 #define __XFS_XATTR_H__
 
 int xfs_attr_change(struct xfs_da_args *args);
+int xfs_attr_grab_log_assist(struct xfs_mount *mp);
 
 extern const struct xattr_handler *xfs_xattr_handlers[];
 
-- 
2.25.1

