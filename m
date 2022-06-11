Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34518C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiFKJmd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiFKJmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A7EC50
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B3C0D0023173
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=EkLDzWt6YOPCgdNwBARtT49CQv5M92i0s6Lr1s1oCvo=;
 b=Fqz47goBvx864S2HExYxLxSZBbl7kggENPMotilDplM02EXVMCasYaFk/eU/3ZXHBvUq
 aHHBzNZ6uLt7FPn6QzqUt38984VZzf2F69XgoFROzBJpfgtuXWUU8qVV0zUX5zDeiH10
 ZQbzK4KT3N0H+y6GKsm5oQvw7EeuwmcWzbP2qh/HtZpqj0xqANf3ut6n/Q3pkbwoNREm
 ziJImKYHJX44pShuiyum9bHXbR4gVKNjjALb8BtlbamChz0A2bl/cFS4G5hsZ7uftCnw
 P7dKH5XQq5rolB3H9oQbZReALgHYetUgidVh9RpfdciytHLNNVhGl5mvabuVTA4ahdtZ ag== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx98am4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9ZMQE025527
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gmhg6urjp-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGFhIijgzcp/jv2vjFrJ6uYuyss46abibczlfK0MvAbun2MecMGwJfxjrTcSocpwkl1UzDC5SYPWoEZh0Y71LUS42Vx4msSQBRLdRglylM+OpeM0JVxFD0EKHGGLs543qm08cnwEmr8L9TwSrYK4Axa2alI/OxD0/XxZp6T7kX72zD9XptFP9hKQjL3I6fs0XzthdTY51+h+/jYkmdcH9ehP2Rnhr/rXINXPIZFkGpT9k1I2FAaqNJ18gx8svnGLuXDKnjik/OUcDSH5sHQWrHnHWFvP4ihH6Fi8dYi03RMDXFVZSutFve70xlPLLlMDkYb/nKGKcnfVv6LhiduqDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EkLDzWt6YOPCgdNwBARtT49CQv5M92i0s6Lr1s1oCvo=;
 b=H6EMtmYbSgWblcI1OBatzXtnaavBX4EVGncPuFRSmsuWcA8t+wfQgxduTyHVnFbSIzDXvCrxuUBFFs8PFU5Auc79Pban88GWNAwlYjyXfjkycx/ToHt3LytOl7vuwqXO7Yb78NMM4fMvHLemS1h7r3b7QAP0tZOr3dcq74xx7mEDPd0hcIc6iTkJK6qG+sPrPEWEzjnpm9/+4MRq0JD709XhfO39d34VW/Eqk5W8sKomUax458YAvxzkf6yN+inTqVAdJPLi1JKxOcwYzFUKbZImU5hShlA6Q6UI2D08IrQ2XRp68u2a4+fvce4rN2aq5oJF+E8gcP4UlSl8yY6Q3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkLDzWt6YOPCgdNwBARtT49CQv5M92i0s6Lr1s1oCvo=;
 b=PVW7cIBiea0B3Ulunu+vHoA8r3gPewVfnFf13Dw5wYpCFr63kKuMiTjNh8FZ+lk7KnDXfbAGawqZmNIXQc8XmVDjQ+8JOj9z35fdnpn1lm+HH+MJEi4zY6iHmwwX7O/fHswt69RYGLn3lwDvUZkLy81LxAiDKcIDh/RcOUYv2Qc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:09 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 10/17] xfs: parent pointer attribute creation
Date:   Sat, 11 Jun 2022 02:41:53 -0700
Message-Id: <20220611094200.129502-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eebc37dc-4c3b-43a5-fc07-08da4b8ea71c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4606257D5D4C3AB93BF86FFD95A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZoouofFo4CC2tlLXbOA/8jYzCtRpRVusykJ391zLUIOp+lM6bPFECokoXGLKlgjCkKP85G3Pk2IFbdCEXul3U72CSMyD6lBywk7nW25azDMerQdI+Btd+MHDSH4Q41OpCAHAXXvs62dxUf9+tjtLtPyNuQHhaN7omI0NvkP89lU3+9H9RL3OmBPz70fe+V8BrQJFZxx6KY8/ujrzugWmauO0uAcGgUO/bphvP4+/QAIaAp7klW9glSC6xhgS0Sz58+VRYYFwuWEGwh1bdOaw0LQBSckFaT43kLFPsYMr/Ocm4GhYrEGRdv6He38rWif2fz4o6C8z+ABjX7YEhnNGEamnz9Z5LoQ0gyG8CnwBn/ryC6AoiB7I+hU+S5IxaBgtKrrzoLXlF9WvaJFnzmTN2iiRjiCfjPqsVvs5DJk5PUN0gOGFGfhu5Smpl73lfxD8mKaEiQ1Srfom7zpZR9xy8UGxor30uva/AZYp/XllTdKB7NW7bGVCOe21oeuhczAuemCKjHhXv0euzxMUOe1OKC3Ebi/J+u+EBf8tuhqPxeLkNITkNOJDRuZKQDxsyqkf7o2ABsEtzVWWl4e34N1+Av8edeEtwJEb+4MyQ3mzTVK2u5jNSY2AgCmBzZa7ikQ58XLuQXnoAlj++Dd3bbIOb69qxB67ftbgv1L4w7Cn+Yf4t5wn7JQ17558QlUKINsfwQYl2Cy/RQyH1j8AnGMYtCX0G5RAe2eBSyZyhUlpRNw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(30864003)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002)(2004002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L48M4ZTI3dODqVeIqe+OM/fhtDqBD8QTI072jcS3aCsBcY+2Cu2wTASXXZZ3?=
 =?us-ascii?Q?FpwvuJvhdAz4AWdSc7Zahs3sk8zSILawEWOxqlPVNses2v8oqnN9waSUDASW?=
 =?us-ascii?Q?rfuXse/IIQG7a1yviHzu428JZKQ2ssmtD6AshkFv9CiS3JAfEmHcelG/pMi5?=
 =?us-ascii?Q?m9Dd5orpLwM/vTBGlR7eobBo/FVI7RRL80fcxoU47Zm9THfPFBuOUKe/ahkD?=
 =?us-ascii?Q?deZoHA9F220B/3mplP9A0EYMMKNNvStv2tgwqdWRAlQqLWaDxuU84L8yvPiC?=
 =?us-ascii?Q?uDCG8qfJewOXRc/nH7nxGBqtY3lOO4BtmdNBnxVEwclswnawWF/XckdXIVwq?=
 =?us-ascii?Q?Yijbkzz2i+XhgCZh/z7sve88JJRsp/o8VoLPlHzDhdkqO670H5ThsIvhJ9nd?=
 =?us-ascii?Q?7NyckdalgMYnNmUHfAA9XnyR5uSXWg/tLixpwxILQd7fYCuBs6cmfc5iZgrY?=
 =?us-ascii?Q?AcxnI05YhNC4L1mzOuNLxEpVXU8zeYgvTq+3jRgYWyfS0yOIEHqsUr1ayVc9?=
 =?us-ascii?Q?SS8SXTTLgL8GkFpzAPfp91u98rZ0gcPbQIMDl00EH+gOC4tTsJZh1d8Ir3tk?=
 =?us-ascii?Q?/6v3GUvmg+bQYuB4e+YGhk5II63Cp/+Fs2oaVOHofbs9WTUcELUDzTy/0xFw?=
 =?us-ascii?Q?vDv56LdiDIqY0V0lcNQ0joURKJxg4US/EkUd2l7Yr6flDIzhLZ3s/RXvmJe/?=
 =?us-ascii?Q?yRJKOAfD2DgKa3OzX5Li+m7FnfTLhnLA0h3JNqDpg2NPTKnSMvqkBTfC5pKn?=
 =?us-ascii?Q?5zaQJMihF3CUT6ZA9QH5Um/aAc/VVpA18fIRbzs947CVulI3jQtyYhoe/sOs?=
 =?us-ascii?Q?asEumZTVH5tKcfqHDsvvNeVo9uQhHWdaW03d10s1VEntUDIF4tzu45swMzV3?=
 =?us-ascii?Q?uHuEZms49wqxDORE+8s3JdnRHDjtsjAnBRYCZ+nANKNo9JEwJQKyydXWddGb?=
 =?us-ascii?Q?/GVZUOPVwQdkEMdkKS1UKPgAOV/do1SsfqCWEqeqwoi8Bmhc4wu8vQpVyvcP?=
 =?us-ascii?Q?nIJFUZssPtPvhNR9RGbCvFTPyxwmCMOVRHoHZYfdx1BuKLTIJmY9KTBbxgnf?=
 =?us-ascii?Q?/H9FIVvp69fvczpbF+ZmQdcbO1BIXjL0MyjWMwohHTytdc1ZmX5ig6cGXjjE?=
 =?us-ascii?Q?vCp+ULvYVbEmwkEFJI0z0w8PR3vnQZU6ltyNLLtaJ9CDykAJXRd+7FeyVUzv?=
 =?us-ascii?Q?4XEWbaT4dcoOvYqEOhoS9XJjZ3mNr1t5yB1C5df18GQNpuRA/Qlbp9fmHbEu?=
 =?us-ascii?Q?2yyXKzluHXakBjxiMXSHhWtkjM6kcYAy3AekKOGZ/9fwiFokOQvJd1WIc7wN?=
 =?us-ascii?Q?CZSsf544z6iatylTFqTDPPumn6rSO8c4IzPdSIi0Fx+KiObSr3+bwq6fAQtE?=
 =?us-ascii?Q?Ma8gDTgR9EKjUlFIdZOuLrPka4UMfdFmA9HjvmYKpAUyEsphZhR39nowWlkq?=
 =?us-ascii?Q?OcOyaZqWBbn37Va7ZQOGr4frcv7gGLKwNiS+s3CFeOKRHjIih93C3rC82h6b?=
 =?us-ascii?Q?+puHvtl31j9nl2mm/F8xLEr3O6DriGifgxxVSjTRjcPT2CWtFMRcsg5j+gwt?=
 =?us-ascii?Q?Y2n5qn2NRII/UovPGVp1yzukRsMx9ZSSj+2iebzapMid+A4PCbb5eqaBByP5?=
 =?us-ascii?Q?Ww5Q4BVi2Si2y/WD3nWjkzW3O095OhYr2aXnkywMNcM7fg6zpJLe54DhVQ8z?=
 =?us-ascii?Q?dcK3cWvV4puM6U0Sqd9gRdq9LnuCvvuSsXC9vwVIyTM2FjjVI0YNHxhsgIYH?=
 =?us-ascii?Q?XJdyx1tLGRexdnPPdODsbiJD7rR8Ae8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eebc37dc-4c3b-43a5-fc07-08da4b8ea71c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:08.8730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: afO/yKe+jpaRI9bYdQsVqqqE8G9G1I8NDYzHWmJcAsv9BylrhlR8lQjR1f7LjXFvFwz1vkv2l8rjia492fZG8sgK+8HA60k+EE1jzp97hX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-ORIG-GUID: XOHGv3GVSSRyKIgMauKdjP2cxnObWc08
X-Proofpoint-GUID: XOHGv3GVSSRyKIgMauKdjP2cxnObWc08
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           fixed some null pointer bugs,
           merged error handling patch,
           added subroutines to handle attribute initialization,
           remove unnecessary ENOSPC handling in xfs_attr_set_first_parent]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |  1 +
 fs/xfs/libxfs/xfs_attr.c   |  2 +-
 fs/xfs/libxfs/xfs_attr.h   |  1 +
 fs/xfs/libxfs/xfs_parent.c | 77 +++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h | 31 ++++++++++++++
 fs/xfs/xfs_inode.c         | 88 +++++++++++++++++++++++++++-----------
 fs/xfs/xfs_xattr.c         |  2 +-
 fs/xfs/xfs_xattr.h         |  1 +
 8 files changed, 177 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b056cfc6398e..fc717dc3470c 100644
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
index 30c8d9e9c2f1..f814a9177237 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -926,7 +926,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index a87bc503976b..576062e37d11 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -559,6 +559,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..cb546652bde9
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c) 2015 Red Hat, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation
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
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..10dc576ce693
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2018 Oracle, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation Inc.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+#include "xfs_da_format.h"
+#include "xfs_format.h"
+
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+			      struct xfs_inode *ip,
+			      uint32_t p_diroffset);
+void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
+			       struct xfs_parent_name_rec *rec);
+#endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b2dfd84e1f62..6b1e4cb11b5c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -36,6 +36,8 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -962,27 +964,40 @@ xfs_bumplink(
 
 int
 xfs_create(
-	struct user_namespace	*mnt_userns,
-	xfs_inode_t		*dp,
-	struct xfs_name		*name,
-	umode_t			mode,
-	dev_t			rdev,
-	bool			init_xattrs,
-	xfs_inode_t		**ipp)
-{
-	int			is_dir = S_ISDIR(mode);
-	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_inode	*ip = NULL;
-	struct xfs_trans	*tp = NULL;
-	int			error;
-	bool                    unlock_dp_on_error = false;
-	prid_t			prid;
-	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
-	struct xfs_dquot	*pdqp = NULL;
-	struct xfs_trans_res	*tres;
-	uint			resblks;
-	xfs_ino_t		ino;
+	struct user_namespace		*mnt_userns,
+	xfs_inode_t			*dp,
+	struct xfs_name			*name,
+	umode_t				mode,
+	dev_t				rdev,
+	bool				init_xattrs,
+	xfs_inode_t			**ipp)
+{
+	int				is_dir = S_ISDIR(mode);
+	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_trans		*tp = NULL;
+	int				error;
+	bool				unlock_dp_on_error = false;
+	prid_t				prid;
+	struct xfs_dquot		*udqp = NULL;
+	struct xfs_dquot		*gdqp = NULL;
+	struct xfs_dquot		*pdqp = NULL;
+	struct xfs_trans_res		*tres;
+	uint				resblks;
+	xfs_ino_t			ino;
+	xfs_dir2_dataptr_t		diroffset;
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args = {
+		.dp		= dp,
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.attr_filter	= XFS_ATTR_PARENT,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.name		= (const uint8_t *)&rec,
+		.namelen	= sizeof(rec),
+		.value		= (void *)name->name,
+		.valuelen	= name->len,
+	};
 
 	trace_xfs_create(dp, name);
 
@@ -1009,6 +1024,12 @@ xfs_create(
 		tres = &M_RES(mp)->tr_create;
 	}
 
+	if (xfs_has_larp(mp)) {
+		error = xfs_attr_grab_log_assist(mp);
+		if (error)
+			goto out_release_dquots;
+	}
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1024,7 +1045,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto drop_incompat;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1048,11 +1069,12 @@ xfs_create(
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
@@ -1068,6 +1090,20 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		xfs_init_parent_name_rec(&rec, dp, diroffset);
+		args.dp	= ip;
+		args.trans = tp;
+		args.hashval = xfs_da_hashname(args.name, args.namelen);
+		error =  xfs_attr_defer_add(&args);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1093,6 +1129,7 @@ xfs_create(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	return 0;
 
  out_trans_cancel:
@@ -1107,6 +1144,9 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
+ drop_incompat:
+	if (xfs_has_larp(mp))
+		xlog_drop_incompat_feat(mp->m_log);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 35e13e125ec6..6012a6ba512c 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -27,7 +27,7 @@
  * they must release the permission by calling xlog_drop_incompat_feat
  * when they're done.
  */
-static inline int
+inline int
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

