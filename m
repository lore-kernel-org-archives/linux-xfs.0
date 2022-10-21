Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF09C38A2D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiJUWaK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiJUWaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D8B170B5D
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:04 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDxKn010167
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=hzEFHlK3zVOqcx6LZlgABQvd+BH0xUcmLjDtFulbmNM=;
 b=J2iJV3RRCrdEQby4BnEgGBt1jOMzdTvVCYxM4DDOixIa4CF+xzcQfg4BTlUNmR7CY1k7
 nbjH2jyfBKm27bibaDY2IqWoMhiovUALy3wUzhmzQh8VqY1fvLQlvM6XnFKHTq/DJT11
 mRlxAwm0V2sCvgvi3pPpW+7y1iQBydhnfUTlXhbCpaTIGj1FmtDwdawcn+NgltAd0Vuf
 G/uwehVQC+O4BJyzcoPKIGllFIuCuvbb9iT9bpiHLneAs/9pm5VZEae+yO0gJu6fBMnS
 RjRaf6mic2gl4ZvMaJDgj8iKA4DrAcs43f3L/DiXPNCXkFqWP85COxohfbtK4IoQ7WP6 /A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k99ntpm1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:03 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLP4mu027423
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htm00mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7XEHk98lZJ5d8D7jZzEByVfTWTOyk5Gqyh7iPVuWYu3dGnCd5iaqxMhTdMBZ6+UKYDTBPJgD4hYl/WFGhnQd8oTMODWsQqEZ9gmfhwp1DATMTCl1DciRM/nxXbWGIpgLPQHLvajq/4PoIIc3VH/2r52oUXmzACq7w0aZ2Y7MbDc7gAiR7V/E5s9c+TAlzckypLueTW+8iMrhpmJsX6EAQCRBt5NsE1TJz3hsR4ZQDe7AdnSl2lifPg00KttQfnDoSWxKQoHUtNkoxP2R7UfiyY4uPDpTOkGWEnRMNZJ2VBLpboGUyUAcf7zxIj9zsl5eJ04HuIY03MlH/1nCgd4Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzEFHlK3zVOqcx6LZlgABQvd+BH0xUcmLjDtFulbmNM=;
 b=KwpZhvxSitmqrLePFxRjeoiK2UWyecZDfGQ1K0ykjdPBBcwYrMsy3HZW5HS1Zc7+FkopoUEqCQJh5Rc/4Hx+NZemlGuRxW8SABnHLKNAjwg4LQC9JCjUjDF8LaXgoXnI4ur3hApQDiE1CCg/IMlcwh5M5SoAFGs3rmO/nCXRbRWUfGRIXCODklNDzMusWk+93tlXOmHLbOBI31dC02XVfPUh+MJV8BEfMXk/bO7rYEWJ8i9PAukMXHu446rktxVIfOWWrvkA+US6zrPxJD/Ie9x5Jq/9TcY/CEpmmPvE6ld5ByxGSvFFxl3tO9WBqPY99NFcF34dy0HYL8nFxZaE4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzEFHlK3zVOqcx6LZlgABQvd+BH0xUcmLjDtFulbmNM=;
 b=CcANp0O/aAtCqF1XyhiYuvxYJxZJQZAvRSLScmiw17KMe4vq25gUb8zMHILCvDJoC/t5l1ZM+Ut15GDWxrl156J5VWMq4CI5yR3rLObuVs/Y86tC0cFxekWCUA2gMOqkhiokUqLRp3S4HFKqEF8fJU44R3HLaB38/76KpCe0bfE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:00 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 15/27] xfs: parent pointer attribute creation
Date:   Fri, 21 Oct 2022 15:29:24 -0700
Message-Id: <20221021222936.934426-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0298.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: c45bbbf2-a099-43b4-6f37-08dab3b3ca79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VOjTaRFwVWUs7KfpR/W+Eh2/ITSp85lzIxQfirv+qWLAMXv2VeZUDRxHbfR6gxo8QtimRyLrJTgsRirCsx+u6oSqqaZT21L7hw3K8EnXjbhjY+FoNA3kCmwCTlg7nhqf6rWpxzc70V741/IvbHMh2GTkgcONWvWrCU04+n4Qsj1VXwpXkqm2/kmJvXoMWc+N5HBOCr7nNY2vh3stC9bsTFQpizdlr8IDlpfe/F4OOjP6FWrGLi83SrDHfBYDNsQHqP6cTU6fmN25yTVIoocqIsh8MAFgBX6WmwkfgXVv+GX2O3Q0RiX2mT2NA4QmIJS4Phu4gTwWfyBD+VcvlFS4gYmlBdt7EkPo7oWf1nOPagCMeMfKxaDcXp7lqheqZerfXkH9CZTv8OE/0FoJnTzCuJuajWkIcRzitEwxDoKOkVjGIdFo5juYv8RlYVdDP+O3d4aFk1ApUOS2u9M69hOBwUyDQ3QpIJeeYKl8mHJQE0OHgRIAtvgkog3EC35olFRNEA05bfm0tYZocYJ5oHYEhPNZwNY63eCyi/r811i9Bs81NOuAbJbhnCborzpVZdPyHbMOACUQTA9YHbluGNy4sX59M+LWuIdYu0bIh5A+ZqttrCZXdq7cdyZfHk6MyQkWJq6qnhKtgxqLKkOoufE4O/PdtgOOt3gLi27MniVwmMTFALCSgJJrKXBFvk96VWqy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(30864003)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VTHTUmI8XEXrH0sL8iL4rtwrDKaR9OHNGy4slDkAS1WLuMLDNTBs1fmMjgs/?=
 =?us-ascii?Q?IrPm+PFj/N88h391EB6qzQJKWlic0ur1H5rsDxvzklBh20w8VgkKIlAb0er0?=
 =?us-ascii?Q?QsodJCZy79vPJKApyJ72YYfZ/6w4xIZAqGgz3j1Z156i2c5AlrihrZkDVOc3?=
 =?us-ascii?Q?B5P25C7h24GfJ8LGVrCyAnkTtiYf3XUP0IYjUbh6t4FylYAqkFn68NiQ3HjC?=
 =?us-ascii?Q?BBH1+sOQNXgYOev2VywphFRqpmN+zni+ZG9YR0EJhHzX5FeGbfV92wyskZs3?=
 =?us-ascii?Q?7hGdE6NklGvX3WxEr201vhdhEF5rORxuftSuTkd3DJLkiELSe4OO3fkNHXxg?=
 =?us-ascii?Q?Ih97+ymmgTF+gecxvmJlXIbuza2PqaXxqSAPcb954ewlOkM6MfvO6FpKeGOT?=
 =?us-ascii?Q?mNavHed4ThCb73Epblel7ipZ0jZO6/eqqeimKE0yzz0pS1kAElEXfmE091UB?=
 =?us-ascii?Q?77aovrh59tpJASXSHvx5zNBoLj8fekBBZFUaaJEUgDKAIu0iayDRhDRKfs6Y?=
 =?us-ascii?Q?9Y1iAc3k+pRbgEB2vXbGP9msplpW+fEJ9fC7f4lEoCMQz4e+h6kJ/tzbqBai?=
 =?us-ascii?Q?V8Zac2jZS6f1Z34WaYcq2mjY9FuvhZe5ilSwEc9+E7FOVFi5GhOXNOmM0Iad?=
 =?us-ascii?Q?gqMMQcJonmwHEF6eoBwizaOnItKui7aRXV3BU7X5BXmABkz6fdUNDPmQYJ4e?=
 =?us-ascii?Q?fouWbFUJOafulQnewqySJohQgwSWKGxIWPFA0Uyj2S9YxPBxir4ep+kN+kIV?=
 =?us-ascii?Q?haMOWyMYqvVse09u69g9exXo+zZO8fY7kWGUHGhznT3rQVKaqJ3nwsJnRL3q?=
 =?us-ascii?Q?hQzSTEHoZl806oUT3RYuwmPdBDxXI1cAMCXWCwuPRSiTgYZ4u5RhtwOlZ5a1?=
 =?us-ascii?Q?8qRl/n8KA1wzVJ8EQX7t9/f0lW8zrGFkD8mqB3Bq5qBAjojEiddftyB3Y1yw?=
 =?us-ascii?Q?2RYuuFBiJ/TRuGmSWdlFnnNodYo25ucntWtIZXRH/iu+w3l1cC7TSrHMEpaM?=
 =?us-ascii?Q?qdOmYTmDjiPc2mwz8JwEnO6Z5Kx8Uf7hW+0BMgjNjvseSSQwuHFNwQcaIzEZ?=
 =?us-ascii?Q?iNFwWLR4aCmxHS4aCpz2hlBEyCrH57dH1Qd2Kil0gJdT4WDuseidXjolEr5G?=
 =?us-ascii?Q?iQ4MdzndXeJM/0Yyi54eyNzeqFR48b3U0LPXJj4YbyX/uDgBplhPyu5Tm7jj?=
 =?us-ascii?Q?IxLoHlDfvGaaPcpUtwEcMuIs+2wsS78BO2t8XRHHdjTh2C8cRZ+kKvh28tkf?=
 =?us-ascii?Q?Ns2JsqVBgjknTagtfG7PAFI0vW02CCCz1nFTqq6nq+e65qZFnZ6kLZXG90/8?=
 =?us-ascii?Q?eunWEjjCFloxEr+qFkWLlO7uITwS716WMZWIBxCkoRehMWuCIyiQ0BFiJTQl?=
 =?us-ascii?Q?+unyK56BgKx/gCbSPG7M3ZbtQE18ekfj8L1yYXO8E8i5WxcwqxWMf8FhPFAg?=
 =?us-ascii?Q?WtThYma06WXQmf7yqWDjk0zGMEL/kklupqncgoPmWaqIXIMnmAkGwbOKiJiQ?=
 =?us-ascii?Q?QeF4wFP2At4aYTLEx5ze6WwbOK1i+96q7ddPyvDXmmYX5fEnC5ZK8vYvBZda?=
 =?us-ascii?Q?k8G86bJa8B9nx6UjD0HY7hprT/3f+oJrskVyS7IORs3JfWwRETDja0Lv654X?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c45bbbf2-a099-43b4-6f37-08dab3b3ca79
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:00.5226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5tykV5B5EVowg/vNU2soyM7ckrD+ryHM0XOruSY6EpbxNaqajzFMtartlqVdlBKpAEIPgJnTSF2LLpZ3KqOcPPmLGUh0MdQKXyR1A0ns0js=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: iiJYgC8L6Zpupyu4MnKmXVEQn4Tx1UhX
X-Proofpoint-GUID: iiJYgC8L6Zpupyu4MnKmXVEQn4Tx1UhX
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
index 0c9589261990..805aaa5639d2 100644
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

