Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B97C43217
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240992AbiCWVJL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344868AbiCWVJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:09:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B2C8CD8D
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:28 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKY4qi001345
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=rpBcAdx5gg2KlHJmYIOadoaD5bgqFlNSqAf5qmB/CHY=;
 b=zZ6fMX3Kv0cgqlSjUdl0yVlLxeyO/W9B8VYdfrbphpkP7oJumsMvo+xFwEEK74v304uW
 CmcBkTz+0ktDJTtA5vqTtIPE7g7kGkvt9buMNXk84IJQCjJhemQad63BkBN3oWU5uNQd
 QLLmrh/W7Z0xSrOs+WItz9JtBb7vtbnFe92CvJETHIdO2ZePsUT25NhzOK5otlYmEL4l
 tWFb/u9BiAjrpFqwLmDWmm+e2g7CAbRK7NWVnarkiJnC08rRhNzAjGV8o4yYYu0ONzxQ
 83lrmnGMws/K8zidMxctSOBYhH6iWOJwxIVjFTbFnP+UtqWDP2KuBA2VYjsPQbznDlA+ wQ== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ssaqng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6LdC082870
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3030.oracle.com with ESMTP id 3ew578y1wr-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1bYM7CbGCcLVJJQFXE4tAVqF/T7qKEO5U/kU0lj5SUx32m3t5+v6JjLuIKLUSOb0pmh5qUkU1Z9AC0s6KzG+w8NVl6Gh22aIQWSkSfflz3YNWPYGHH2RDPtIaaA2eOts+BUoWpThB03iUO2vfce/TbNIT+nwwgJAOFJJDhi9GbzrGscCpu0h7vX9//J8wqXfLIN6zx8MQntMEYGfSmW3ryhpzEwV/loRN10mWiiTDFjXw4u0eOiI8Oeybi7AVZ4goQV6/YFcAahcE3OaVyWkpEtAJcJH1l8cpbJ0FS8ejBdSWDjJNDYhvX8CVN97a9vFkNQY6H83dQCAcBtpsngVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rpBcAdx5gg2KlHJmYIOadoaD5bgqFlNSqAf5qmB/CHY=;
 b=MFwkr/VLjhdDtLu3gK8HC9Icw39nSzvZeVlhuOEMqa/PzU89FqsynqHPvOIFNtdkp6TGAavbUgFymGCxdiNNAxjhef4GkJmKB1QuE9qBIDmlnZx6jnnd6wpuQ84uPUhzasUc8B/T4413Le/+pwqj/Ml9RSsXeuDs1+53f8Hyvg8UxN/NSoWeCsLKjzxjrNZzsfhHCGogjmpQeKYNKDA2GtLI+73c2NkWbDuybRsvRBuk7VuiHQA/CPPCVnLMLOh02yJeH91az3y4FWQI2T0ZtrnCiTJ9UmpCOMo6CPMUzS7JpZC5VDZBmT+8fBixjXCKPxP+QsISpe/JSIdVEQDIug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpBcAdx5gg2KlHJmYIOadoaD5bgqFlNSqAf5qmB/CHY=;
 b=wC0hvjR8YMk7EK+9llGdL+C8tqN3o5A20kqQwMf+GUeMLamqGvWcF6sP63+6jbZLC2SDm95xxxHShhgDtEFkAnvGfU0Mg4IspHN3eNpbNww/BfR+kX/SjjGx97vsjptzK8spQLp6877NloHps/mcY/Hpw6PIvoRhN3adTYA0vso=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 21:07:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 05/15] xfs: Implement attr logging and replay
Date:   Wed, 23 Mar 2022 14:07:05 -0700
Message-Id: <20220323210715.201009-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220323210715.201009-1-allison.henderson@oracle.com>
References: <20220323210715.201009-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0084.namprd07.prod.outlook.com
 (2603:10b6:510:f::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d41d047f-c5a3-4230-cf85-08da0d1120de
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB47443588CD4FDFFA7F123A7B95189@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hDTdEzuH81jozs1aT0FblUEroJxi4zMV6dJ+f9woG4d6j3vEiZ+iVgATvmZqMyNdZCrPeA852oWycvwyrpPiK9VovlomwN9MXKn6IxZaH8jY3/fUt6VRhD8I/02Qig7D3eAHF6VAqxNYFR7DqHet2Zcz9hbdfp+Asb2fGR4UeIKkxluihwYw52ha4axbn7VzT0Xhquice3zlRENiXv8FgmwLDYG2UBhttdF7rHg8TkUmoDPoEcw7aAmz2Xs2tfdMBKQ2VK6KfvMaJuPdsr6WmbUxJfOnMgYC4JfqyChLMuuFG0Q1UxGrZYbEnq2R5O388XHqYWLP52MJmYfSivBA1ZfSK6dnALml+vxma16aerTQojd1D9hQl36inITLIVMqAkRX+3FatQUP/baJ0Szl60RNnQ1SUcL+x2RZ5iJzyh6qwTDxhA8kaf31RFXitW1z2R5OHfDzkqs5oC5IoSoxkYzG+4eaXngODZ+lOdgmBrarWzDk0EcLHSAqyyytwQ1ddgh2kxCH9wmrkHbULmgoWDtThHj309GU6LkR0jzcY28lCsThDdyvE6dA32i/wHPoVltVG2WaHAeGnTpmN8SPdriAuazjmdxsFkNP+YwuLAJdiqUZ7xbxP2r/gsh541dIOy3r9OjXY3FTWDjH9pJBoGTShTj4xZVQCmdDtTWtiPZhI+DbAPQ0JPZv5YdaeNb7bNQkT4bOgwAt6cWPR+6TVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(44832011)(2906002)(508600001)(26005)(186003)(36756003)(38100700002)(83380400001)(6506007)(30864003)(38350700002)(6486002)(52116002)(86362001)(6512007)(5660300002)(66946007)(8676002)(66476007)(66556008)(8936002)(6916009)(316002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R+R/UbZc+X4871vPNQomRJOOtPx25Wd/hRNSvmBJ1oAcT8PJhoE3iuudI2aI?=
 =?us-ascii?Q?O1/ETQZCYgq/QXMdLR0WS9hLPSujxQnWTFgbdmvg68F53b9eRzHzH/9r6dEY?=
 =?us-ascii?Q?Ks3MCX1wowX+qJc5wgtuAm4LNVOM+vC5VTdQiFe22bh3top9CbKzHsDKa8eq?=
 =?us-ascii?Q?7nfnGl40TNDuhzb4kZZazr/HoH3EzymeV0whzUFpM3FPifCQeVo0qGQa/oAx?=
 =?us-ascii?Q?ldWOPNdDbiHuIqGhHzIziDw3PH9TFYSNl+4tcgWFqFibOE+rdLvZ3eOFdo3+?=
 =?us-ascii?Q?2vXfsmQbnGEExsdeb8wFEub97QvWsmkH2Eyp5DwEWtWAX2N/Xs4gvRwGNUTf?=
 =?us-ascii?Q?95R8Ka86jrE/0/xPH+dZzuvAyAsasNuy3hlfwhTAhK6/YMDJkdnN7ncUm9xg?=
 =?us-ascii?Q?4fOtTWr1fa9map0cD5ZGeBXWl1klkF1kySc0fP6I3U3xgSRx4s3fK4yLygXZ?=
 =?us-ascii?Q?iQAZjQiJFvZePlawAxLyydyGfTqEXpCGG2813MrhcHUW2dUEk46BJtSoLujU?=
 =?us-ascii?Q?xE4sy5swpqXgMBQIiyrQdWFVAUCqnbpvqMFF6nhfRlEyw7uSuusgj5z1bl7v?=
 =?us-ascii?Q?duaXsCIyvxQql4Eedk3kZ5qorw+8F7qL/25VB99nenawb18gyjp5ugO/6uw2?=
 =?us-ascii?Q?3HAQD8kYgqz8bakdXww1L8wSq2XfIalVid4BZPExXFu8KjNf2IUk++NNJQKN?=
 =?us-ascii?Q?v43w3DCWxCPDuCuAVIiQ2zQ2S9IsE+ZrhF6rA+MvVirp7KkjB+VAuZaSNcvF?=
 =?us-ascii?Q?uarviWjHqnn7wVvalzrO6REuuJmT1kzE8kuV2+7NP1iXipaoxacp1FFc/Qkz?=
 =?us-ascii?Q?WyOxQvesUsXP7I0XKDyDPJuSe3Z0lFXB4+0tHJtNNhdp7kd2LrsTkg34Fmw7?=
 =?us-ascii?Q?Vhh41k697D+KCZh7yHONfZvFsb9j3Xluq2w9Pos5Anis/yNabT/DOTahTU9o?=
 =?us-ascii?Q?tpD3olIyv/UZNrzBac+kfs3Yrn7Vabb9kAkCxNnkuJ617PkSZU0pRuUtumJc?=
 =?us-ascii?Q?70Uh6nm81DmYcQReUxpWn9Qjp6J59stoih/TXwf3rk8S1NeX7+x6vWxHq1R5?=
 =?us-ascii?Q?CF9RTKB7AzhHxoVpOsfjPPlR/H8A4hXEdY39UQ7h1LyOELRZAoNLOm2becbp?=
 =?us-ascii?Q?jJqy+I0rOsE/14d7MFbIiktNZsVqIN2Z+UziURzduitENSvcDTDPpNWouNKs?=
 =?us-ascii?Q?gCvA+iT7yDJpV3wuq5V3JisSQDg6ZCFAKgI5QUQEKDQN7Wsz/HFhunhRJMX/?=
 =?us-ascii?Q?3yQ0Lj7Qs9y4wemXAK5PIlCVDvqrafAowTdr8azOs0a7PM+XDUkhUhmt4z4a?=
 =?us-ascii?Q?UNHMTvHouutK8GW4fgIiIy8efyTdAPx1z4+VgBbbVAvp9aFssTr/FClSJg+C?=
 =?us-ascii?Q?/gC0pfDtrEKr7UXWprwNMWyz2BO1wLFPK6UAEnkGweO3ZD8lCW1TfZWPlHPv?=
 =?us-ascii?Q?crnGch3zYfcgy3ZOTCex9uYha3K6eYQHeD42M3XtQYw1+fMFKqYZmw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d41d047f-c5a3-4230-cf85-08da0d1120de
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:24.4830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tzPGBmk55K9eQkM3xoyjRmDx1hD2se9isi6eVEmpDv+cCgA4joeT/jZ1obC7WAq7i/D4nCOMuhVh3FhZwisfMGXULln/OAw3Xofxbc20big=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-ORIG-GUID: USa49l8kSkSNOeaWchmPErqfDbHR5OOm
X-Proofpoint-GUID: USa49l8kSkSNOeaWchmPErqfDbHR5OOm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds the needed routines to create, log and recover logged
extended attribute intents.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  |   1 +
 fs/xfs/libxfs/xfs_defer.h  |   1 +
 fs/xfs/libxfs/xfs_format.h |   9 +-
 fs/xfs/xfs_attr_item.c     | 360 +++++++++++++++++++++++++++++++++++++
 4 files changed, 370 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 91adfb01c848..d15c39d21e86 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -186,6 +186,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 static void
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
index 394ef4497553..1e2fcc9da340 100644
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
@@ -283,6 +286,172 @@ xfs_attrd_item_release(
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
+	memcpy(attrip->attri_name, attr->xattri_dac.da_args->name,
+	       attr->xattri_dac.da_args->namelen);
+	memcpy(attrip->attri_value, attr->xattri_dac.da_args->value,
+	       attr->xattri_dac.da_args->valuelen);
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
+	/*
+	 * Each attr item only performs one attribute operation at a time, so
+	 * this is a list of one
+	 */
+	list_for_each_entry(attr, items, xattri_list) {
+		attrip = xfs_attri_init(mp, attr->xattri_dac.da_args->namelen,
+					attr->xattri_dac.da_args->valuelen);
+		if (attrip == NULL)
+			return NULL;
+
+		xfs_trans_add_item(tp, &attrip->attri_item);
+		xfs_attr_log_item(tp, attrip, attr);
+	}
+
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
@@ -340,6 +509,151 @@ xfs_attri_validate(
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
+	struct xfs_mount		*mp = lip->li_log->l_mp;
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
+
+	old_attrip = ATTRI_ITEM(intent);
+	old_attrp = &old_attrip->attri_format;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	attrdp = xfs_trans_get_attrd(tp, old_attrip);
+	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	new_attrip = xfs_attri_init(tp->t_mountp, old_attrp->alfi_name_len,
+				    old_attrp->alfi_value_len);
+	new_attrp = &new_attrip->attri_format;
+
+	new_attrp->alfi_ino = old_attrp->alfi_ino;
+	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
+	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
+	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
+
+	memcpy(new_attrip->attri_name, old_attrip->attri_name,
+		new_attrip->attri_name_len);
+
+	if (new_attrip->attri_value_len > 0)
+		memcpy(new_attrip->attri_value, old_attrip->attri_value,
+		       new_attrip->attri_value_len);
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
@@ -402,6 +716,50 @@ xlog_recover_attri_commit_pass2(
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
@@ -435,7 +793,9 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
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

