Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB551C4167B
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiLRKDt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiLRKDq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:46 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E5755B0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:42 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI4w3de017492
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=ffc5bc1QySHFyRSNnA6bj3jfBI6UpYpnn8MFEsc6vlM=;
 b=f6tkY/Za8ptPsYmRc/FTJHZb5extTTQYC3lNsCddi5bQt1BTZtkI8i3iS+dENnEunW37
 XAA1Eqo4UhILj1P+j24m9fR0UgtjhMn698LJe2NlWqNrbmmSrFPzZan3x8ncBLfrf0Af
 2VnnmKpHHl4OosTJW/iUCEv5lrqqaS5Db2If034iFkZBYg4fApSVSZNwLEOLBIQDXCOm
 8lcKybdPCYtfMFOjWptJii60pEG04B4Qyr1EeNd0g826dKldzvFLEN42pGHUxscioFsu
 hKwV9FuGe5LM7rGbVbcijndFtPZJ3v+BhO+xM+lTTNkKwT/bYBVXy9Lh2grveeTIlzUz BA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tm19a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI87lfO007145
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh479cbr1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVbuS+4OnTQNscXrcHJx+QhCDVpUnSWoXYKoSpZKcD124IApwjV5NAIfQPDC3qvMjWcxO5GdmgPgKWkrRS9p01ZDB/QJirFGeCZg+rzCpkZlm/3pJFORCv/xfw+Kh1KcETmONIa1oNwuT9bfF8AGJbB5NaMl+aC5oaCjgUsI42rfaVbj0lK5d8HYSexAGL4nixK0/BFnW1AQp286cDBJqqm8mZHiBzfheEN5GD3aLYh5kwL8xpEJgaJ/oBYvIGt0LHJCvoE7L/VDf3rgfq4vWK84v5+OtxE2CfultlPjOxdgledBcvW09ndg6+P8kevGVntieXSnvHmBSQI5siwWFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffc5bc1QySHFyRSNnA6bj3jfBI6UpYpnn8MFEsc6vlM=;
 b=Az1B0/dLKKmejB+FZT6MuXkkL+nIAX+AH9yFqISCN6++kGtF0b8HjSw6NhcL3O83mp6oAZTPnP0tbqzN07ASfVnr70fVN/luXFS2SjyqMkaX4Q1WJ2WaAuF76iGk1g4oCyQdUd2zm/0eSlYR61xSiwOL3CF/xzw52SmHceOviRFf+VD1B+JHx9RQzzTcHuFi/6kTN75k9ij6TMcjU6HosJq8OGdIt+v9J4pYmi6bYklpyqSiGEpsQhP+pxLucPbl7dz7uvfqhFzJ0pxwxNK0yyFb5SZGDO7ijuJCBJb8xgGSEk1CbIpEMa/edbNJ5xSbiZvn2dW56YsI3F7WDb/OmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffc5bc1QySHFyRSNnA6bj3jfBI6UpYpnn8MFEsc6vlM=;
 b=nDRjZjbss8JP1Ex50mioQvLPZwvez0SDIZlvt8GzTsjyghBwVtV7rxl6iTJ7uf/gnyB3Jp8WgFLiCLv5eBJ4AS/gHx5lQA2KIGwLXGWzC/FHBcwzDFOoaouoxnPwXarVkB3pN8FJk/gBvVteORRJk3iplYd3O+YMhWww/YRHORc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by IA0PR10MB7181.namprd10.prod.outlook.com (2603:10b6:208:400::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:38 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 20/27] xfs: Add parent pointers to rename
Date:   Sun, 18 Dec 2022 03:02:59 -0700
Message-Id: <20221218100306.76408-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|IA0PR10MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cc20ca8-660c-47d9-e7a1-08dae0df221f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TuI3cfHwfPT9SmZC3j+7L3Z4ZV1uyya0gDM2PE5lvRutjVC+eLJIkcrW2mqfmzDpg1ilQbGt8HXg7fqCBq/FSMTXgsZBdeDMGC2Ma+6xbhUEumgB88LsM11LckIlayGPn73Z7Cov8UKuJTUk9PP8bvsFtIjhkyoDmkQuvJm6uOeyTja4gGhZ3igA7UivxyY3z6F+cgBuU5Yeyw0R9ITwsl3Vys83CitoZiNdy/5+H1gJa7J50t4KCziv+yPZZYRHHiB0eiZPs0GgCqBkoYDvNIxD+szYjRX08ocZIYeER6VIeGSfw9uvNzICsWAscfphcm9tEsnLCXyZHbOyVnG1pejkC9De4YxtIjt5Vpat7QmqNTDwELuXvV3/KCRLOV9o5WSF9/t1+9PfBHG0OmLy/tk2gXyPPsSlOgv/nkOFd9UFY0te4QAmYfeEzzCo/iyzB06bwu/71HpPeBQSq4LNZmjNy65QOYvaH9nwtoeqWup6jMfOoE+B1C8xOzdeavtOCP3YbLsOa1rIUNnZ1l73Tnk0OzkkFwZvPi9E2zR+1Ag7aC3mIK1kKEJRPlsem3oHrjCpayZrlD04eVREUUIP4nBZ0B8AdCZ5EF6gg5GGg7uBpoJv9d5G+H/FT5uw3f12
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(83380400001)(2906002)(41300700001)(8936002)(5660300002)(86362001)(38100700002)(36756003)(316002)(6506007)(6916009)(478600001)(6486002)(186003)(26005)(6512007)(66946007)(9686003)(2616005)(66476007)(8676002)(6666004)(66556008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8b9KAdck4E+5P0YyNGI/O5W0CFTLD5WPYHscdn6JFJ0TPpIXbJWBfKsnbF4C?=
 =?us-ascii?Q?Un+N1iklyL+ifjattxFfJuVoXEP1RWIz9aEv6nbZdnRmnhm0CQ5mEVbcI+I9?=
 =?us-ascii?Q?AetSoHpOpK22pJbyC1D2NeiR36Dk+PjCCN4+s7Ah2ToKEzwAl4UBBy8qW/gS?=
 =?us-ascii?Q?t2rrvLq7tM3zh5pOioLbUxw3z+/zijGsdt+MWdwHWxTTVGjIhhlgwuy8aibk?=
 =?us-ascii?Q?Cs6bo4mqnupy0B5I2tZHwa1OrC1FuhYPZL4le+krVB/wNSXSFAto3Vv/o6f8?=
 =?us-ascii?Q?h2DV5FY+OKJQzPUUtb/sIaK0HAEWdcRc2grQc0d95y/W+deo1y0BKnpdUa8J?=
 =?us-ascii?Q?eHzxYD+bMWzdbE1Q0iqdnwMfbOVqgEI8ljSDIxNiZ3O0pWU1EwRQK6kMcQVV?=
 =?us-ascii?Q?1myB7pcYfoL6bk1yyDivYk62ZenqodW+262jeNsBM7UiM8ED/Yo5OBQXnb+B?=
 =?us-ascii?Q?u374bVQNSVF1jEzrxYD2ctUTQJkxFUq9ekz/WHCJq7vI6bpNpgVZ/WGCEh1p?=
 =?us-ascii?Q?8yqVFiKbLtHxGteNVgdfNl6k4aEOgSND365jLtXu/e2x76lS145+APCL3eOK?=
 =?us-ascii?Q?Wr9VJnpKdBKZ181Y3RWeTCJnlpFkCPycjhQv+mjsjVK7CF3OrFS24L/Fpe/m?=
 =?us-ascii?Q?HpRA8jzyqvSIJ45Z0O2TrdlIWEcD1G95351dWkYnTfRoRo8nJJhPstXzsJBS?=
 =?us-ascii?Q?Vxlppb2yimAG0SpsGB5kPn0RKyE5ibS3v4vtWh7DZvITl6HmaXYHRrRABjNy?=
 =?us-ascii?Q?rKZgcD2JjSG0J5051QADuYl/+92MyewUcg/xyVMch6PUlwgvZzD2QVUFnvI5?=
 =?us-ascii?Q?1VIQT70m7nrKzulziuGAPSCwY6AL5gJsIVdG4ybodtjZkQzT6CNL8VDLhRe3?=
 =?us-ascii?Q?8Iq5BSVBhc04B1LvN9n38nO3pUCwgoB4lfxfw4XaaxA2GnKxXfb3D2Dd2Sty?=
 =?us-ascii?Q?9JnY/NMXP2/tX3NL9jI6DEIPJPP7ACA+QvpeCEw5wO04SC1iA9wx7hPe/CR/?=
 =?us-ascii?Q?gRA8oAE/260m01+Ui38OsLxn3bn7kmOVCUQD5/qaoLyMBhXYQeRBliAyF3iX?=
 =?us-ascii?Q?DcRTeFX4PivxRahVXSPoE5Jw6uOcfaV2SH1Crd79THIjY1xDBWQbgLNeVLKu?=
 =?us-ascii?Q?BnYxDyONBCmBlurTRWft6fFZRKG7uMb1FAmhH9tAf88pdMmzO1GjnUxHMlz2?=
 =?us-ascii?Q?9rWVWCm+Zm89KbVHHNNYeKU4hrexNxyU8ImNNpIZuniNCuk5JUZI/vv2l79A?=
 =?us-ascii?Q?QwUWs7B86jrzOM0AYQTcEGiaZNfU+Sv2cu4y/9L1hnfEeeobB4/coM9AuvzT?=
 =?us-ascii?Q?2hE/fd33UlyyQLaA0PWM0IWd2gdWP50hUBI95JI2mWFEn61ndQ6iXd/5BZjc?=
 =?us-ascii?Q?f+eOV5eFixnumpToJHHxziHAPqyGRpVlPyPSRiHyqf9znFzrzXzn/Cc/DPMD?=
 =?us-ascii?Q?XDN5/432n6qaR0Q7djF6BHwqUNGdCi6gPs5Ny6NicVKswTX/7VBUqnyTp42f?=
 =?us-ascii?Q?s3crAlschnN+eODalrXDwNVJCCEl3CRmD3rgnfnm3H1mRWGIYhMdNNOOJEqL?=
 =?us-ascii?Q?sNU37rYtQHNE3G+Av/uqq3dtGc/0nfEqWFI0VvVOkIDBi/gt+cwIIdRz1k15?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc20ca8-660c-47d9-e7a1-08dae0df221f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:38.2284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dp2lnMqh1xOJT22jYbGw6+vcKGyrgS/OYvEtfi98oR391ZDQVebkEvpfQDTSo4kHkBwYGeJKKqDM8cp5VFpVly0iO4bfzBTIENahLCO8kfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-GUID: JjGxyZwxwlEgSctx13uNGWdZ3ovJAHeO
X-Proofpoint-ORIG-GUID: JjGxyZwxwlEgSctx13uNGWdZ3ovJAHeO
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
 fs/xfs/libxfs/xfs_attr.c        |  2 +-
 fs/xfs/libxfs/xfs_attr.h        |  1 +
 fs/xfs/libxfs/xfs_parent.c      | 31 ++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  6 +++
 fs/xfs/libxfs/xfs_trans_space.h |  2 -
 fs/xfs/xfs_inode.c              | 89 ++++++++++++++++++++++++++++++---
 6 files changed, 122 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a8db44728b11..57080ea4c869 100644
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
index c09f49b7c241..954a52d6be00 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -142,6 +142,37 @@ xfs_parent_defer_remove(
 	return xfs_attr_defer_remove(args);
 }
 
+
+int
+xfs_parent_defer_replace(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*new_parent,
+	struct xfs_inode	*old_dp,
+	xfs_dir2_dataptr_t	old_diroffset,
+	struct xfs_name		*parent_name,
+	struct xfs_inode	*new_dp,
+	xfs_dir2_dataptr_t	new_diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &new_parent->args;
+
+	xfs_init_parent_name_rec(&new_parent->old_rec, old_dp, old_diroffset);
+	xfs_init_parent_name_rec(&new_parent->rec, new_dp, new_diroffset);
+	new_parent->args.name = (const uint8_t *)&new_parent->old_rec;
+	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
+	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
+	args->trans = tp;
+	args->dp = child;
+
+	ASSERT(parent_name != NULL);
+	new_parent->args.value = (void *)parent_name->name;
+	new_parent->args.valuelen = parent_name->len;
+
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return xfs_attr_defer_replace(args);
+}
+
 void
 xfs_parent_cancel(
 	xfs_mount_t		*mp,
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 1c506532c624..9021241ad65b 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -12,6 +12,7 @@
  */
 struct xfs_parent_defer {
 	struct xfs_parent_name_rec	rec;
+	struct xfs_parent_name_rec	old_rec;
 	struct xfs_da_args		args;
 };
 
@@ -27,6 +28,11 @@ int xfs_parent_init(xfs_mount_t *mp, struct xfs_parent_defer **parentp);
 int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 			 struct xfs_inode *dp, struct xfs_name *parent_name,
 			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_defer_replace(struct xfs_trans *tp,
+		struct xfs_parent_defer *new_parent, struct xfs_inode *old_dp,
+		xfs_dir2_dataptr_t old_diroffset, struct xfs_name *parent_name,
+		struct xfs_inode *new_ip, xfs_dir2_dataptr_t new_diroffset,
+		struct xfs_inode *child);
 int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
 			    struct xfs_parent_defer *parent,
 			    xfs_dir2_dataptr_t diroffset,
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index b5ab6701e7fb..810610a14c4d 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -91,8 +91,6 @@
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
 #define	XFS_QM_QINOCREATE_SPACE_RES(mp)	\
 	XFS_IALLOC_SPACE_RES(mp)
-#define	XFS_RENAME_SPACE_RES(mp,nl)	\
-	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 34bc6db0cfd7..713ced7fa87a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2867,7 +2867,7 @@ xfs_rename_alloc_whiteout(
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
-				   false, &tmpfile);
+				   xfs_has_parent(dp->i_mount), &tmpfile);
 	if (error)
 		return error;
 
@@ -2893,6 +2893,31 @@ xfs_rename_alloc_whiteout(
 	return 0;
 }
 
+static unsigned int
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
@@ -2919,6 +2944,11 @@ xfs_rename(
 	int				spaceres;
 	bool				retried = false;
 	int				error, nospace_error = 0;
+	xfs_dir2_dataptr_t		new_diroffset;
+	xfs_dir2_dataptr_t		old_diroffset;
+	struct xfs_parent_defer		*new_parent_ptr = NULL;
+	struct xfs_parent_defer		*target_parent_ptr = NULL;
+	struct xfs_parent_defer		*wip_parent_ptr = NULL;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -2942,10 +2972,26 @@ xfs_rename(
 
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
+	if (xfs_has_parent(mp)) {
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
@@ -3117,7 +3163,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres, NULL);
+					   src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3138,7 +3184,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres, NULL);
+					src_ip->i_ino, spaceres, &new_diroffset);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3211,14 +3257,38 @@ xfs_rename(
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
+		error = xfs_parent_defer_replace(tp, new_parent_ptr, src_dp,
+				old_diroffset, target_name, target_dp,
+				new_diroffset, src_ip);
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
@@ -3233,6 +3303,13 @@ xfs_rename(
 out_unlock:
 	xfs_iunlock_after_rename(inodes, num_inodes);
 out_release_wip:
+	if (new_parent_ptr)
+		xfs_parent_cancel(mp, new_parent_ptr);
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

