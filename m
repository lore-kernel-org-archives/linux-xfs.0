Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778ECC46467
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiLRKDm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiLRKDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308825F79
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:35 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI8tY8u027000
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=Jd0hWVbByU4V5w5WG+gKmIYE4aeq7M8v0EcUQ1NtWjw=;
 b=jXNgI+fOiJ6tOQ649/YqK4T3c08ht3nK7nbJPoh/DKBLWBKPyib0eShaQKuzI+TIvvHI
 RyIS1FzPfXZJNxT1956lbJC4rIqPwwBaSqOu2uhBfivmPvTFpQg+JQMMNYhFAJBk2h3h
 pHe3YYz1G0rmhUhjBVGxHU+qzI4aG+q81Uj1a+z8u/b6W/DtuCb3Gu4cEpPXFVggj70N
 BUNN9tCWnJ8AL8lGPhPYfguED6Ac6hI35RWcD5OBDokVWn3R7bE12/F0NJD7cGfrJ8L9
 TV87j3YBKXnjKxAuxvpMRbI3KMzRmE4pwvsfkLARhWzLgBes0+jA/9S9K58wyXJWMUZ3 KA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tph924-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8VBBA024761
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478mxp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhMUSOzcY32ZDVCkLEQPTWD57ozCDdHXkwYjsRSVtMPfLiI4BtTspSgaQUio8vQwB9z6O2TyJwfa9b16keBl/yHYwIEWH0SBYLFbEITZb6QugDDlUIo54e6TtCNhifAK0zCRG6WRTgr4ga6H9AgUfcUdTBvjU4stWkV5umC8Nco6suE76N5k0ivrXvBn+WTKYZJH2V0cQU8RXb0eLfVSe8Fi0/VIS0evOCsfX7HgzDjMdtRplOCq7NsX0rXLnttBMGbtA3EJ+TF3XjlGlyFAPm+pnkE7xwT2zIJjFcJqDp0ZxcAWGcSnGz8uPCsgFlWc1CaS2o+8CycjkJAXOoIAIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jd0hWVbByU4V5w5WG+gKmIYE4aeq7M8v0EcUQ1NtWjw=;
 b=AslHCB8duJi/3g0gEjpaoBU5DozGM/XWAPa931dP+lxHTyX5sz/pZWdzFxbMxR2bCX5hk/3C7r2gvJUE8mXaYFAw3XpXgtbYODSBqwXqK+2oJpEfxO5ETI3FefjcDKiVcxBe9W50rthgnhM3TN0znUdG1/nj0gvUjKVgejLqvU5OEGPEQskeuMXe/RVwbVu4F8/oxx9t+W/lyRb8q168I0ABD6UI9YbotioUOPzvajslrHfcXwA5AnE8s/jMkaSWKD/6gRDb8zH06/X/oOe7749rOxXqk8gLz0aaOXqulIs5H0sYep9UJMmpDEvdP/0Q5ic07HNYxcKMm2YGaPoRvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jd0hWVbByU4V5w5WG+gKmIYE4aeq7M8v0EcUQ1NtWjw=;
 b=e3Kw839v9IUhl8U5z4Zke6WrUmy2lZ7EPy/ydZEvaAGogZvljltiFbIEPbIb7o5wAVzeDy91zEL8OGTVoEhl24XmViSbXYgvKrGYDXwnhTxNO2zBfGzD4dUbzIb2DYWFPpLbrZg4LU6QUIyiwUZgBDdXBR+e5GO3356fXGHiX98=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:31 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 15/27] xfs: parent pointer attribute creation
Date:   Sun, 18 Dec 2022 03:02:54 -0700
Message-Id: <20221218100306.76408-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:a03:255::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 284bbd3b-cc83-470b-a501-08dae0df1e2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ldxksO5C+bj2qKllUN4PWN9hz2tpVkug6S1UGMk2rstYD5WIGVAM+CuoTMzybrrxbUwUQkc4bylsZyg71KyWqOwpzVfE+qspHmVTaYcmKoD7SNM7HJXzLXBDEIVq1n4yg39VhorH4NOq7rBh0xfdmdxw5iXEKkFwv2FH9nY08z/jV0Z32BxoqBaWZ1IzTzO2bicz3Z9FtQaCzgBaqRfrGAckDJ8H3X3jNw3BSmkauCQpMWWnLeHjy8j7swYhkvlQcOxOxZZ3UuB6xYb4FF9lA6RRr3kpJjQCLQfS1WbMm1BP+JghC3VJ8Fw6MVLB4lP49DJRtCZukxS4HnOP2DnErgwi8DkN/zvTUqnUvnGSGDDtlZJ1zwYXWiDGKgaLkX468I9lL2qqaVb80wYSx8iKlNpUr6GAFulk4iiZ9a1U3ENg4bCK4DqGsbICQS2NW8BS2bax0IXOuT9V4Jcy1PM+P3LWyo5g+rh1iYb4hjfWKl0uJEJMnzahRpCnrpN+kWKkqgr8DTzNWjDLehQxOxFwl/Zg24AmrJawVrW1VZPM0et31ERmpL6H3w8mKG6QA0iDdfC2oj3Sw044FvWnfQH3XvIZewTQ9vb3dttX1WLK1ftM4rgTxc8fwSHbJe+AD1A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(30864003)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+z0AxqrU26imcZM06rZBwIx4m2LdogI9CsvQM4+HhbVj3Sy6LlLfOmp0OMhl?=
 =?us-ascii?Q?QTrr4irfzN7RSVpnHV2yBsPvoGKBAqNreITOl8V0q5Rhm9f5+E4xEUQB3zfK?=
 =?us-ascii?Q?74Mbmtj9Of9EDyI1FAeQjm2V9xubIgQKmo1dXKhqAuRvtRXcieHSK/uUgT0d?=
 =?us-ascii?Q?724rnEJdcWm1WAx6LQOIAzFiAgp0VMg7ITgnNn48Q728EMt9/SUwb2SoUV9M?=
 =?us-ascii?Q?nnrD8DLhspVHTN1pnIQfMyfMbinHKPmYVH6JUkdRzMlOKqDmEA8yZdQEeshW?=
 =?us-ascii?Q?kSewOrud0nM4PkCIajDSb9WJeObc5ijkVvvI1ykFx0dU5kZX5YzgJmbdXpZw?=
 =?us-ascii?Q?aP3sheTLU3tDM7lpE/2MwbVsQ7KczAzKBOBiz3sYJ8Pfrsv3+v4jyT28icb5?=
 =?us-ascii?Q?KRVu9les5+iXMnAZwp2KJsyRCuzkenQrWx4oRsFkyCeMq5Q9uUoq4fphCR1P?=
 =?us-ascii?Q?WJP30jPr+gkiPJDmhrS/M6XZUog3I31mL1Ytu+ktNsv1tCv/KBbnLyro1/Pv?=
 =?us-ascii?Q?oNmIMxSOs17K1jsDVEovBdAbqIc8yIk/V9/cj0mbmMqNl49/lcbTHJvyArmx?=
 =?us-ascii?Q?BWeWx/c7jaAFr9ZUvpnlcEEbgXOCNw4BuDx4ajMIhmqxxVzjyH7q4MzJLwas?=
 =?us-ascii?Q?9iEYUJsNSbtbVus8161cVz1i1g/KeukpfUsneFpnfgoKkkbq7GM4DlvtHQVN?=
 =?us-ascii?Q?u9jcbyo76DEg3IuK3aXu8UjK0y109/BmM6nRYdA7IY8w70rbcTo769+x4GNH?=
 =?us-ascii?Q?FxTn+9eWaRgtWfQC3TZgnR8MrHMOdSpQrgQYBZC02+MwQ1J9U6rBe/ic68u+?=
 =?us-ascii?Q?73v+E4y6y/zq2CbyA3LfQVAWCBptVYEbqUkAOhcNIvmV5w0Fj52iAiiZzuWa?=
 =?us-ascii?Q?zRKGvu++JN3oJ24gyJCfsp0GrLRLZQmFGbMUZQIjLof2M5wNH8uVgKRKFNnd?=
 =?us-ascii?Q?YNmKCSPuoIGHEXsPpB7JkCcRaYvi09BGmiKagc/P4dnWsNPwJATVMvLFTacu?=
 =?us-ascii?Q?e5a6PDwqiIB7cCBkHpCk/L+1svDMWQLG7G3Fyt6f+CQ1D6yMpUGs0liiixh1?=
 =?us-ascii?Q?W59ubKZbtNlrVlpeP1PZmfsjC59ENoryPUb4Iox2WR5Wl1PuE2twDfg5NCSw?=
 =?us-ascii?Q?UXc7XP/DfI0mPrcszVvUftZLjDvtMxroynubQlfu0AN/GOwFLR+esRwp+ngP?=
 =?us-ascii?Q?3rczC3Q/hZxwjQvh5xAofepB5c5q4YiHfr5pGiHnNF5RaspkBB8nzS7WAGhg?=
 =?us-ascii?Q?OiEwnfqMGO4mZwRaudWQ3DpF4f/Y5vpthMyqKmMCnwB/jKDWrevLmmnqSYZU?=
 =?us-ascii?Q?lpjkPIB85BAfv9tVV7u6oovQKNOgBVTlY0NlSLbdqFdo2M4qQSDs2OZUwy2v?=
 =?us-ascii?Q?3ZptlzDaba6pkyDIMM6tNHNr6cnkftLbXMnkAq5IXfAHrUh+DFV5Jxx9hDjX?=
 =?us-ascii?Q?ueOpgzm12GqLGEnIb+M9q2/t3wxV0kygHfAkgzxSJR/GH+/pU7YuhOm2kP8C?=
 =?us-ascii?Q?n4B9LUqCag76r+z4qYMOi8ycuGU3Rx07WBxL0/ld0EMLPb3cdP36WOLNchxS?=
 =?us-ascii?Q?t5RorYbhfi3Mmx0GooCmVegi8UNc5L2USw8U5j3vwARJNs8P4YrO3mc366zf?=
 =?us-ascii?Q?nw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 284bbd3b-cc83-470b-a501-08dae0df1e2a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:31.5723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JED2t+cYcb2J6OoHh1A0nyNDfDapcwUHYSO6G+p/efMUeMiHSxKNnX6aIaM5z5Eqy9mmlc/k9ar3w/9BQtgcibgcVKSw6e3R2/JGL+PflHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: qTOS3axWI96VDCcNFHEITHD1cfV3Ep9F
X-Proofpoint-GUID: qTOS3axWI96VDCcNFHEITHD1cfV3Ep9F
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
 fs/xfs/xfs_inode.c         |  64 ++++++++++++++--
 fs/xfs/xfs_xattr.c         |   2 +-
 fs/xfs/xfs_xattr.h         |   1 +
 8 files changed, 247 insertions(+), 12 deletions(-)

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
index f65085645942..11e0dd16ba94 100644
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
 
+static unsigned int
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
+static unsigned int
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
@@ -1034,11 +1067,11 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
+				   resblks - XFS_IALLOC_SPACE_RES(mp),
+				   &diroffset);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1054,6 +1087,17 @@ xfs_create(
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
@@ -1079,6 +1123,7 @@ xfs_create(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
@@ -1094,6 +1139,9 @@ xfs_create(
 		xfs_irele(ip);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 10aa1fd39d2b..3644c5bcb3c0 100644
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

