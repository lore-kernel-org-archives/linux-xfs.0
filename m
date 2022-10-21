Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76732FA3744
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiJUWaS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJUWaR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE81251F67
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:15 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDxKp010167
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=S4IhvrrdRRyLAvYHnuh6i4B4gg81GDwu8VW8fTqyaNc=;
 b=dcfRxl3/IzPYUSVzBuRUB9Zj4GU9KnRVQQrTCA2Dg/qd9HdZtTYAsHXIYyyVyJWU6Hy3
 4EJwcK9oA2dp1eBJGAxN7vNvmlsxu08DnCbxDHCGCL8RQnIPVCfkpHrg9RInwPoZRMNi
 /kaPghKUtRJyNwapEcscIZk9qkYKqhJ1pLtNtjY65yf2MYNSCPryDeqjNuvFFg8swN7Y
 BviyS+IS0D/9J2biakMKuqKCtjVyiB2TMsGWQlA5w/OBWayboXrHNKimkLCSOqhzPEh6
 jrH5rXLoTTw2iTEZKWjHI10zA8IjEwAxN0nvyO3jw0Rw29mstNoUk4Zok7NDYS1bnbP6 +g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k99ntpm1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLP4mv027423
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htm00vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqiVEUbZYrZFOLO7Y8yJvmqp3GYAh7FRlDkd8hNJoTc8CoebXAKmHZnESy5HGfKgjTy562ERtMvdR0A8O3en+T4EnXDXqpZPgJVJZIYZVi6j8IwbKzzuvXJY+w0/iL/Ux55sHkeWoyaKRkOKxk36Uz+XobnNqjpXy8ewYdllX7foP8ORLJMF8meg0UYKpx1OgEFFnodQg8hzOkRGpjS184QsOPiWTHrHWLO1+0KYTBmV9SbwyVeXcSCeUZmRUdUynHj/tCa1DB5T8LiV18QA5XVtazaiBewU/lMXQRoMvrW9JXbDdF2F/w5gCK+WS08XaBfp/z2J0eF81MNuXr8iOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S4IhvrrdRRyLAvYHnuh6i4B4gg81GDwu8VW8fTqyaNc=;
 b=lk3W62/1ZvEU8OwJhegL1YfDZg+ZZ4Cx3YIkpyqkqnd1SRCYx9APpabh1YhvyxdwN2Eh75cuGI1bUX8+9ShF1gkhX4ek4Bh6v1+628mQJUoLnmdU4A5aMUvFmLPS3sdckQDnDF3zH45m+FvqQ/W6V3DRF1KpczQCP77LNcbn8EafPFT2NzSoDsHKMPaPEAaXrJon6oysWZaijKyp3UiuEAwWg8AGZya5iTyBCkgarla5QkL2qxoM5/MUY7nVNY7hmi4HixsDihyp8yVkRAFUw2POEn1SJjdBlmKUwvDGn4jEjaiAZOt+Jhr23HnHT1wi/iVXm+XxATzScBmnjgSixA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4IhvrrdRRyLAvYHnuh6i4B4gg81GDwu8VW8fTqyaNc=;
 b=jbrxNoTWeR6ID99oRokaGVt4UgbR7YylaZ2HGUeWr9CihvY+c1c8Bv+GPB/fSDVSKiBNAcxNdlpcHT55J//hgcQ2b4bsXIRmqSMRXheBckmA+hY0HVH/f4VJk5wm1N5KcfjSE9ADN3c754xIuPPHbreM2EyWWqDgglYYb+Yk9f8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:11 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 21/27] xfs: Add parent pointers to rename
Date:   Fri, 21 Oct 2022 15:29:30 -0700
Message-Id: <20221021222936.934426-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d2edf50-8411-4d7c-efb3-08dab3b3d109
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E08E1FQB1DfHWpIusc2262iWF8KZWwSJ6jMmcWEM4J5ySTX5Zu5DnuaSfkMf19HK3LfjXZRbfTOOLmi1CyRYBwb44XXmPaI+uaUNMWUmsPaaQ0v7p6I3P2a7cNrfq6YAl/E17M6+YZQij8pmoc4Sk7OiruptBHPCpjEY7BjhbqZArbo+NXpLIsj55pvj3Dt6vEDllZxTSu3FCV+ly+3kuNTLVW2IiRWBdWYTyP0LBqdj9n3uv8kP9wOppau1R2XMMciwmxehO8zgnfr7S3jieZgfHDBLhOXD05zsPtxQUYzk5D47Bw4lHBMdctN2890hHT7iNcFpqQhISvviG7upbp/5KWhc4+nt5kjJTWA7wfkqZXKxITJ9T7SZew/ozfOMSM1yopYCYL8IpJoMo7mKU7rloygNn0yROLhGGd1XAWJC9O+nVVhotZO6shhT56qTa0v/4WNRcjjrQD5PKtwbrDEKcA2eVtf6I8DyDbCiOfLgGlBW3ZfTqBZrref45YKyiU4LaLPNuSsmVFfTm1cXUvFHxt2yvmn6qsuu0LHP++Ufec6mBD4Vub8eoCSKUHcC8QW4AgVVmM1C82IZ0iuKKzVov95rKOlbsEKdo530vYENzFAQdzA/6l9f1nx2zI40Awu3dHmzPd0r1q8cWT6eooGtf+gKbQ2zCbmisXRg+iEDD5Vig4fDb+ztcOm9GRD9DStOalasJewb+gUsxOOxVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HrnWqwJ92MuajBySN77GjWfd1yTEYXOzpc5W6kCrxfUAy+NJygW9eZfGIDDc?=
 =?us-ascii?Q?krBUC1OniDSPvvl08AKrTY5VLIujqkkHXqjXcwUiQI9sRZ4k3J4JgOUBCzuW?=
 =?us-ascii?Q?0Gi05f0QjgfzyspK5VEEOZ0hMgFsV77Ilabwe/FLttGnnBZhL1Vj8PtLkMz7?=
 =?us-ascii?Q?6r4TdHDKEGlXnMV6THK21Q6m4QnpNhYtTB0YeI4iSyDIok5ZDpluoPUZKAp+?=
 =?us-ascii?Q?Z9/4Aotk8v2qpifWGm0nq471dMmEwvSQhoF5lZlrG+kNiBpG2amWL3IleyLV?=
 =?us-ascii?Q?K7fuIkt/G/mt7Va3O6lXgWV8XL1Us9sUGIeTHMw/rVuIp+tVMAp5TI0tArqm?=
 =?us-ascii?Q?+8FAW4psocfToH5r1wWtIqW8ZVrKoYMrfEWzNs3EHhCpbjPHPKx9SaJiacXj?=
 =?us-ascii?Q?k/6VJlVLQIdO5ZJ7bgbsgErdNFq0sVqG+jUckNvJqAtRdsb1m+mZhnPS8k4z?=
 =?us-ascii?Q?fByjNW2EPQIRMRaF4Kan/yPmn+sED1LbuwN8+ZWNjI4atmZs2oU6/DiUSQVV?=
 =?us-ascii?Q?Wvnr3ZGV8ZEgnhhmQkzJ0s2yYqyRX384DH/osEXrpkeajVbC9HL6oDJ5M5x8?=
 =?us-ascii?Q?YE0NRk6hIfeMNWNHWq94gBRiq5JRXq1Bct2hP/R4zb6j0dE2Yx6oi86j1sGH?=
 =?us-ascii?Q?YDL7yyd6wGhaiSPFUKvuMbe17OflwE3z6Rno7RRn4sZqB40m4yrBCVr0xBZy?=
 =?us-ascii?Q?PApEVeaXdtFY2pXsTNezhXky9y0zv9Au9O65H7NnKXidsj72C2bliXvQfxf9?=
 =?us-ascii?Q?TwTFnTUNMR0sHb8p1AzZjMqgSBv/Ir0zB9Q897uwNsu93QvaiAusRfaAV1OC?=
 =?us-ascii?Q?9L4tvdiq+MCLwO8mqEVkGDp6vx0Y/b5aM1BXQiFMFVaW5+nEGEyrZXWr149r?=
 =?us-ascii?Q?JRXckHPIA7zsApf3s+QXR3HRcyO80apGDlomOHacv/1RKvHGNmrsrVOZ8fPE?=
 =?us-ascii?Q?BSTMGARYgqKGpiQUCjtLus19cDUV9izAYLppbUKzt9B3qyoo8W7/Dekva1X+?=
 =?us-ascii?Q?zkOY3AnfffEabYvQfdXlgalevEb/l68AQewSKVdT9S4rw7jlRdDGMlOtnacC?=
 =?us-ascii?Q?YhLh6iBQForK+mnHPcMvblv7WI1Z2ct3Oxc1ItsGIdyjZVRtveoWrQHyFh0f?=
 =?us-ascii?Q?aJsW5WPwJ3sVBJP2lLqVe1yUSp5jYCofX2/jLZQ7yD4poj8/qh84104Wgcb6?=
 =?us-ascii?Q?QKHPG5uaIN2o8B6LXqbvkYovrQA+RT+TiIQvuMv0jBTcfCB9E9Z387YPJgiG?=
 =?us-ascii?Q?oi7bToCvcklDP9f4opXNlN6xBfY0prqlfnznpek/6z7ae3pRL1UYT9OcJuSc?=
 =?us-ascii?Q?xCbcY7mTzpAY1Syg+00ZzOTHb3BwggctL4rewHBW6G5t/Uzp6bdWNS5xeD46?=
 =?us-ascii?Q?7p0CHsfUWcdZ16HspjnyZ3tHZueElsO9kXJn6n8fyrDXQd1Daz4Rzm5qL3FH?=
 =?us-ascii?Q?gQ525jrsRe+/YY4BW78UdXbaCtXAzGxUork0PchGpmxRFqCLy1liUFPeN8PK?=
 =?us-ascii?Q?EKCNBUUomEqKTWOafi8uzBoSp24BSWDAwFShulUrMgbkjvkW5GtRusaVWd8N?=
 =?us-ascii?Q?3I1PlERHG3gocwvbaT/LQU1JmR2ZjzAVC0u4XWBet9ufZ5WWVFmDh3TK4eVm?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d2edf50-8411-4d7c-efb3-08dab3b3d109
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:11.7859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dIHslyBW/WxFiRymgtPCh9Q6W6fvaeEPAKnxZQfRZuMgcYM+qu4scVaNLo43JQcMHn145X0iXyE50Tf583U8TxlGzj783fc9FpDz7hmzXT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: oQ7cbLPQkl8l4y8uTBRtJpwl12NXBH3N
X-Proofpoint-GUID: oQ7cbLPQkl8l4y8uTBRtJpwl12NXBH3N
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch removes the old parent pointer attribute during the rename
operation, and re-adds the updated parent pointer.  In the case of
xfs_cross_rename, we modify the routine not to roll the transaction just
yet.  We will do this after the parent pointer is added in the calling
xfs_rename function.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c   |  2 +-
 fs/xfs/libxfs/xfs_attr.h   |  1 +
 fs/xfs/libxfs/xfs_parent.c | 31 ++++++++++++
 fs/xfs/libxfs/xfs_parent.h |  7 +++
 fs/xfs/xfs_inode.c         | 96 +++++++++++++++++++++++++++++++++++---
 5 files changed, 130 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e967728d1ee7..3f9bd8401f33 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -923,7 +923,7 @@ xfs_attr_defer_add(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 033005542b9e..985761264d1f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -546,6 +546,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_defer_remove(struct xfs_da_args *args);
+int xfs_attr_defer_replace(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index c09f49b7c241..49ac95a301c4 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -142,6 +142,37 @@ xfs_parent_defer_remove(
 	return xfs_attr_defer_remove(args);
 }
 
+
+int
+xfs_parent_defer_replace(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*old_ip,
+	struct xfs_parent_defer	*old_parent,
+	xfs_dir2_dataptr_t	old_diroffset,
+	struct xfs_name		*parent_name,
+	struct xfs_inode	*new_ip,
+	struct xfs_parent_defer	*new_parent,
+	xfs_dir2_dataptr_t	new_diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &new_parent->args;
+
+	xfs_init_parent_name_rec(&old_parent->rec, old_ip, old_diroffset);
+	xfs_init_parent_name_rec(&new_parent->rec, new_ip, new_diroffset);
+	new_parent->args.name = (const uint8_t *)&old_parent->rec;
+	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
+	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
+	args->trans = tp;
+	args->dp = child;
+	if (parent_name) {
+		new_parent->args.value = (void *)parent_name->name;
+		new_parent->args.valuelen = parent_name->len;
+	}
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_replace(args);
+}
+
 void
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 1c506532c624..5d8966a12084 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -27,6 +27,13 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_replace(struct xfs_trans *tp, struct xfs_inode *old_ip,
+			 struct xfs_parent_defer *old_parent,
+			 xfs_dir2_dataptr_t old_diroffset,
+			 struct xfs_name *parent_name, struct xfs_inode *new_ip,
+			 struct xfs_parent_defer *new_parent,
+			 xfs_dir2_dataptr_t new_diroffset,
+			 struct xfs_inode *child);
 int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
 			    struct xfs_parent_defer *parent,
 			    xfs_dir2_dataptr_t diroffset,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b6b805ea30e5..a882daaeaf63 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2915,7 +2915,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+				   xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
@@ -2941,6 +2941,31 @@ xfs_rename_alloc_whiteout(
 	return 0;
 }
 
+unsigned int
+xfs_rename_space_res(
+	struct xfs_mount	*mp,
+	struct xfs_name		*src_name,
+	struct xfs_parent_defer	*target_parent_ptr,
+	struct xfs_name		*target_name,
+	struct xfs_parent_defer	*new_parent_ptr,
+	struct xfs_inode	*wip)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRREMOVE_SPACE_RES(mp) +
+			XFS_DIRENTER_SPACE_RES(mp, target_name->len);
+
+	if (new_parent_ptr) {
+		if (wip)
+			ret += xfs_pptr_calc_space_res(mp, src_name->len);
+		ret += 2 * xfs_pptr_calc_space_res(mp, target_name->len);
+	}
+	if (target_parent_ptr)
+		ret += xfs_pptr_calc_space_res(mp, target_name->len);
+
+	return ret;
+}
+
 /*
  * xfs_rename
  */
@@ -2967,6 +2992,12 @@ xfs_rename(
 	int				spaceres;
 	bool				retried = false;
 	int				error, nospace_error = 0;
+	xfs_dir2_dataptr_t		new_diroffset;
+	xfs_dir2_dataptr_t		old_diroffset;
+	struct xfs_parent_defer		*old_parent_ptr = NULL;
+	struct xfs_parent_defer		*new_parent_ptr = NULL;
+	struct xfs_parent_defer		*target_parent_ptr = NULL;
+	struct xfs_parent_defer		*wip_parent_ptr = NULL;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2990,10 +3021,29 @@ xfs_rename(
 
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &old_parent_ptr);
+		if (error)
+			goto out_release_wip;
+		error = xfs_parent_init(mp, &new_parent_ptr);
+		if (error)
+			goto out_release_wip;
+		if (wip) {
+			error = xfs_parent_init(mp, &wip_parent_ptr);
+			if (error)
+				goto out_release_wip;
+		}
+		if (target_ip != NULL) {
+			error = xfs_parent_init(mp, &target_parent_ptr);
+			if (error)
+				goto out_release_wip;
+		}
+	}
 
 retry:
 	nospace_error = 0;
-	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
+	spaceres = xfs_rename_space_res(mp, src_name, target_parent_ptr,
+			target_name, new_parent_ptr, wip);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		nospace_error = error;
@@ -3165,7 +3215,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3186,7 +3236,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3259,14 +3309,39 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres, NULL);
+					spaceres, &old_diroffset);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres, NULL);
+					   spaceres, &old_diroffset);
 
 	if (error)
 		goto out_trans_cancel;
 
+	if (new_parent_ptr) {
+		if (wip) {
+			error = xfs_parent_defer_add(tp, wip_parent_ptr,
+						     src_dp, src_name,
+						     old_diroffset, wip);
+			if (error)
+				goto out_trans_cancel;
+		}
+
+		error = xfs_parent_defer_replace(tp, src_dp, old_parent_ptr,
+						 old_diroffset, target_name,
+						 target_dp, new_parent_ptr,
+						 new_diroffset, src_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (target_parent_ptr) {
+		error = xfs_parent_defer_remove(tp, target_dp,
+						target_parent_ptr,
+						new_diroffset, target_ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
@@ -3281,6 +3356,15 @@ xfs_rename(
 out_unlock:
 	xfs_iunlock_after_rename(inodes, num_inodes);
 out_release_wip:
+	if (new_parent_ptr)
+		xfs_parent_cancel(mp, new_parent_ptr);
+	if (old_parent_ptr)
+		xfs_parent_cancel(mp, old_parent_ptr);
+	if (target_parent_ptr)
+		xfs_parent_cancel(mp, target_parent_ptr);
+	if (wip_parent_ptr)
+		xfs_parent_cancel(mp, wip_parent_ptr);
+
 	if (wip)
 		xfs_irele(wip);
 	if (error == -ENOSPC && nospace_error)
-- 
2.25.1

