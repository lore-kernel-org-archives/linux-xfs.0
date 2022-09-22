Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 484FFC6FA82
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiIVFpi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiIVFpa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B19483F38
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:28 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3Dw1t019736
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=bIEAS6JFy8eOzghbJcZK7A4xtwgjf7jQKkUBVoDwG7Y=;
 b=PB2y7ZDnD6a1aUSgr5ZQ+cTVu+qq9G4d5F/Si5VkvPTox8p/iBWSeeeAC5qyh3HUq/Tw
 1ZsNSaBPIO/TwwRXnoEtcPCYidlgF2cmI0dwrw/XeeVA4ccFa8bBs57KQI3uaGuaHWmD
 wHiA0GyBZ7MPIe5ScgzrXvr1Mx6kywID3gLd5LRD+QtomDUFXNaA7JB5S3ca71rluwKV
 KExog4la03FHgjKIJPfqG0m5gPcd3Dqg95kruzK4sS9oB6gC5uu5gc+KojnzIfNDBTON
 egEEiSYiY1k81Z0aLEjDAjccqkPvKZjKpKsMjAcRxtP2iRs5A8mPAnr33tmm/Lye8ALd rg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kvchh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M23Wj9007081
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cq70bt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwEb7Z7qbyGgREmmXwBz7Pd999bb7e6NNIu35yfZS1P2FProyTCZZ0bASv/GkQ/hNnSg6wTUEGN+yeu46nL/LOSG09vM0kyNTepyqFMvc3fFlX8jhtgyBeHj5Kf79XqfmT2Miubjax/kIGhjtDPAPZsmdDmiZB82Lx5EUOaFpCGbyTYnW7JA6q59Zk2zGJ4MrtyO/NUssqvo65tEyaj4ird3YmRWh8LPDYIyfU2ko9G7L7Nf839SXJLPzuWwiks81ugxsZd2xWoeSJYkrf3ipdBXeh9cy6BXBlRBaZ9fm4XxnOWKFQ1IjfPP0yjpxh0s+9jqTK7TpQDp7l2YqczJSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIEAS6JFy8eOzghbJcZK7A4xtwgjf7jQKkUBVoDwG7Y=;
 b=NUcLXbyle6iE2NyWbkAMpfkIADHNcjggr4A8tRJpLtXU9SkV8i5BZLuR4f5mqrl6I+sBZkhcMaMlTDPn+u049/1YvUjWf5Mxu7hbVqSc7mDU5W+HIqISC5cIc8R2KJ25vQDk0M309fuwMBuDAmzBhXBJojWPlga4S4N4R08iYK9AFYESOcGz5ksPTQbK/wag+7MQdCqCCkKXnzhkcERmLyvPo4pF8eVI+PpMgEYuMuniwNaliOm3glwtSxe+FGDf87NGunendG7td53mKvdRHn9DJwaIcoy0ITee9JoRk0hXR1HmzsG+QklmhaY+XoIFzX89q0pyY4o53jugyPfQeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIEAS6JFy8eOzghbJcZK7A4xtwgjf7jQKkUBVoDwG7Y=;
 b=hXL6HnZq3cBwgBhSatYAXPXn6EDaaRIyLiGhFW0TPauh1UTnom2NJDe+jnqdVzpujZc552Vatiwk1B0zAhosMf49+mEu74wLnY7M4nIn7/XdobYHGh314ymzw7KuakrUwcBpp2rfXyVJ6KRgbkBE67FDEXWUlz3Iakd6QXXDyg8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:25 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 17/26] xfs: remove parent pointers in unlink
Date:   Wed, 21 Sep 2022 22:44:49 -0700
Message-Id: <20220922054458.40826-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0170.namprd05.prod.outlook.com
 (2603:10b6:a03:339::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: a7581ef4-2c7e-40b8-0532-08da9c5da59a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z69l5l6PJQfPFLao0vD08QtdnTQUXpQBoIYu0UQv50QTeb7LU1BUTupvJhsWu+5ZigRHUn87xj+4reGb90CpcuveV33akMYIm8RXWhoD6AdyWjmtFgQfHIY33XSWzb7/6iBmgIyGXcSgVRhUfE7IgjDEaI/N/D/OFhgRt/w5E6kVnE6fuiujzZfSnsVg3eiHLmwGJSAk/2p1Nq2vhRuGFZT4+1LfJPlZsQN1uAoRYMSMN0JexR6yj6P/lTggZB4jSBi5bN3Fv4lxPoqip3Eo4UKMGpMK7CUbwzV/opV6Iii3JU7fnLzWtk9bhlekXRhx53DOpmO+rY/DFZ8M5q1kSCH5d4nAMd2zenIDu90NnoZ0mx5jdfZ2B4J7GoQfWEArnXRXCTPlzQu50kjB5zp4aNhEu86f1HJIiRijsqE7/LagTLb26w/S7YrBUtsh9EjPXlNEUtE+AqfkzJ/X1Io0BKzuXPRpK8B5ZB+MmaZGFHFPt+d97l2YhE1GpDWvFV8oSEOsOfLCoNomKlLcourgRKP+S/QUQX+Ip2r/6nFSqBk2k+bXwvZVjhDQ2yUK5Y/YAWysb9FTUdYgvQV/SuFxLTCaqHSVy91EPU3enBPc/V4HNaqJqgGH6E9DeRttTFwwc2mOj7v6nTyCpkqnVaZ5ouXKhW4uNc4qZ27YHC96xVCX0dT0KNsATiEm+z32N/ifKri8nGKch67Fvp3sGGoh0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p7hV4aikCPnmYscQgM1KEvuSXJ228GrsoF8LFaBmBCUQ6IjcamiIr6G2pH+7?=
 =?us-ascii?Q?ap8QwcDHNt+jDo6bvYqXgDeW7D1jjGr5GxxeaysLPym586z6hyVyJvU1lWZI?=
 =?us-ascii?Q?adQND0xR7TGDn1Z5ehcMMBLtfrETe2BJUhgUA7k/ptlmqtsx1qgfDOAcnPzx?=
 =?us-ascii?Q?lzY3m3iQ1zLamh4iaCQYWhUkyHXK5r7+TDUmkrDLYloVY7tjkeACmPH5Slu4?=
 =?us-ascii?Q?jQasWtQydcfYh46YSEmFWfHH7+xqiVOAGqzim7/y1tDcWzPlQ7uGDXMt1LS+?=
 =?us-ascii?Q?YubrV3SLfrZlfw6rNHMy8ECubEiwVwctYiA6PUd3Ac0/rB54ZYNLIug+z3pI?=
 =?us-ascii?Q?6fCiHtiDSCYH72kvfmFhotOjiWKRfwTQOk25z35SUVEKkfS1lQ+Cqvc8eF1N?=
 =?us-ascii?Q?i65CSZ0CNuUvagd/ocHuqb3WZ5TMuIhKALRUgsptzKsxKmdGgtEAWiE12Du7?=
 =?us-ascii?Q?HBwLGitHexi7S72RRPZEBM1nztsLKnAbB0cjXBLL8PGI7dFupb75jEwqfOpx?=
 =?us-ascii?Q?iviwQpOBEH4BblC35QvODU0EmLXSTO7rDWYeGSoNhZx0AgkB0fcRHbUBHt1R?=
 =?us-ascii?Q?OjuHyh7BmigJSM/Q9eMAcTC4SsnlLnlh7TvUU2WqPlURJkQ5SlAQEcbTA7k1?=
 =?us-ascii?Q?1EeC15Xt/F5TrmpkoljnyMzDpVYZeSVXGkkJJp6OeZozZsiTGySh/BybEWeZ?=
 =?us-ascii?Q?ul2i1OGv7wiEiri5kyruF+wUNbzjtwz7V6lRslGSeTKzfuMTnQsMSyYwlUH4?=
 =?us-ascii?Q?pkUxa8+7QfDij/Zr0TkQ/NnpFBf5QMQTtjmH/P+RLMgYWZvpT8MklKd7RhDP?=
 =?us-ascii?Q?1raKFs2TOJL2umUCQ+yS/cRmX2Z2XyXmeXhAAdV/MBNh8esPu9+aWCV8V89k?=
 =?us-ascii?Q?YEl4glFprnjUVjr/P7WFnZuEqAQgo69bC7uoYd+jcmpjBpNgs3dk6qvg5n5H?=
 =?us-ascii?Q?+O06pYHKMkcuduMPeGssDn14PZAoxI3MJbWmUne6M8ciRmgb97Mjq2Oq849E?=
 =?us-ascii?Q?8q2t4l96yn2O0WTSVXm8pazTvVe8ikTZcY+vDbTdzXUmRlxg5dd0fyMlfl+x?=
 =?us-ascii?Q?duZ5EnfDnQWta3yf60ESZSZtcJTja3bQMn7ZQZx5UsGn2NWlFPfPWghFmhIr?=
 =?us-ascii?Q?9R50PUZfkp2+CXLZTpqE1JGctmMnKnwdzTFD9kHkhT2g5HNW8W9HgdU9k5R9?=
 =?us-ascii?Q?Lgoh4KMVCtdSTpkSwLUjJQUzuJtHa5A7ADs4EeVNdFcncflHLUTOAGF3+avO?=
 =?us-ascii?Q?z7dntAAbFPFx7Rv1jVF/CIXhnZMmBgbGpemu+0RJ3FrBSNNVfLXCHmjIto5d?=
 =?us-ascii?Q?SuoaCgEzV6ynvOghR4Vvkn8QNlE7ftrOqMC5fbYLKY7igsxpRsf7zyuPO2so?=
 =?us-ascii?Q?9dlnwObzKFLqtZQf/PfPK+zE21M7sMa6/BLi17+dAVH38Ox3fekXiN6HCCtC?=
 =?us-ascii?Q?8k82W3TSjCqdOVSPbM/4YvoPBMwJs/4Z13awjoS+NwJa/Ig3MmEXcFoW3rVz?=
 =?us-ascii?Q?dN5YcE7ciGhy3vJBxs+PphTVcNvQL2KB+bpl+RcwJQXk60zFCsxg78tskHLU?=
 =?us-ascii?Q?lWbL8wjfux8y9GmFQSZt+91WaOoD88mM4ZZkCQkqFoNzw3wyvk6eNGdw6XsI?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7581ef4-2c7e-40b8-0532-08da9c5da59a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:25.1666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHPxEGmSFwbeTTQp+0E2Hg/MVby4AycCOzSKAPFIOc7ODbMoSMMPLh8dZmWZonKe2EHoyuqpLxCeZIk7m4pMKBfa4j3irh1yGz2ZLPerZ7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220037
X-Proofpoint-ORIG-GUID: QJ2sL-dO4LAgtMe43zZSIXz7WYrUg2Wq
X-Proofpoint-GUID: QJ2sL-dO4LAgtMe43zZSIXz7WYrUg2Wq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the parent pointer attribute during unlink

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c   |  2 +-
 fs/xfs/libxfs/xfs_attr.h   |  1 +
 fs/xfs/libxfs/xfs_parent.c | 17 +++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  4 ++++
 fs/xfs/xfs_inode.c         | 29 +++++++++++++++++++++++------
 5 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 805aaa5639d2..e967728d1ee7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -946,7 +946,7 @@ xfs_attr_defer_replace(
 }
 
 /* Removes an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_remove(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0cf23f5117ad..033005542b9e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -545,6 +545,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
+int xfs_attr_defer_remove(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index dddbf096a4b5..378fa227b87f 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -124,6 +124,23 @@ xfs_parent_defer_add(
 	return xfs_attr_defer_add(args);
 }
 
+int
+xfs_parent_defer_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_parent_defer	*parent,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->trans = tp;
+	args->dp = child;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_remove(args);
+}
+
 void
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 971044458f8a..79d3fabb5e56 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -27,6 +27,10 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+			    struct xfs_parent_defer *parent,
+			    xfs_dir2_dataptr_t diroffset,
+			    struct xfs_inode *child);
 void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer *parent);
 
 #endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index af3f5edb7319..1a35dc972d4d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2465,16 +2465,18 @@ xfs_iunpin_wait(
  */
 int
 xfs_remove(
-	xfs_inode_t             *dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
-	xfs_inode_t		*ip)
+	struct xfs_inode	*ip)
 {
-	xfs_mount_t		*mp = dp->i_mount;
-	xfs_trans_t             *tp = NULL;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_trans	*tp = NULL;
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
 	int			dontcare;
 	int                     error = 0;
 	uint			resblks;
+	xfs_dir2_dataptr_t	dir_offset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_remove(dp, name);
 
@@ -2489,6 +2491,12 @@ xfs_remove(
 	if (error)
 		goto std_return;
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto std_return;
+	}
+
 	/*
 	 * We try to get the real space reservation first, allowing for
 	 * directory btree deletion(s) implying possible bmap insert(s).  If we
@@ -2505,7 +2513,7 @@ xfs_remove(
 			&tp, &dontcare);
 	if (error) {
 		ASSERT(error != -ENOSPC);
-		goto std_return;
+		goto drop_incompat;
 	}
 
 	/*
@@ -2559,12 +2567,18 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
 	}
 
+	if (parent) {
+		error = xfs_parent_defer_remove(tp, dp, parent, dir_offset, ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2589,6 +2603,9 @@ xfs_remove(
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  std_return:
 	return error;
 }
-- 
2.25.1

