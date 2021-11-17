Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D3D3C43219
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57F7761B64
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhKQET3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:29 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35096 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232680AbhKQETY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:24 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH21HAT030389
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=CRtaHDno6i6rXoyBQ1MYcApguD9WwabFyLUXilNdRJw=;
 b=gjHNn7myAPU6ivCgBriEXrRBkcnj7JpJQ58/3LB9+/hQZh/GH1TFR3nE4npDexbSW1Up
 J7neXlGG0SJNV7yv2HnL2qe0aXEqwp0PfBpVluPdU3Cr4o9mUb+aTxexTzhX5K3DBqgl
 tQwG4/VXb60Mir57S2h1pXTCirt87c7QmNV6ydEuv3gH2mMKHtCeLQyRkQOa/KWxj0NT
 T2VB6laD+diPRAMfqK4blYOQ+wnAe2th9fF/IyB9WQEXBbgWQQwtvxtYIEDah6rxy5DV
 57MNwd/V6xNpEUC2MeOytAl1ddz9vhGTIxhekEK0BBZhqaSFkVQf9VoVtqLeSl1uJMFR 3A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhmnwx82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEKl180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3ca2fx6ayv-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hc9sSMP+95QbBsRXpdZM1QtivBnPb5xKdHGCzwaIume3IQD64KeJD6pmm8SBEJ1g3b4I8E5C+nJxBYWqByBlgpgFMTnXX7sjOyuMDOJ+hjwqt6/iZpw0JJ+uVH3XC6u1GDEY6ZbH85/1dG4vzm83A3eiZm4A7uaOaIZeB23SwebZFNKDYgO9sX1BdKGSXY0Uk5yrqlnK5NrfmbfSqXEAYzNdqw+w7BicL39721vWVLyfX0UCQKFoDUcOMOnY7QHuEhjhMWtlrSv0Y7U2oXoCTpc+c9z1MekwsP6xNxT1ftNQbWw7v/mCBY7NnXgR3PtJTSjt70ZbZwt14QN/7bBuzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRtaHDno6i6rXoyBQ1MYcApguD9WwabFyLUXilNdRJw=;
 b=ZFAemHYEocMNvXxfTre0cPomzq8q4GGendvyVKP/k67o9eomjL9A8OTRH4wVYwzl162FEOaD8aPui5AsJrxL4r/W1WFgadJJD24GBmaalbjdbTe9N6kvLR5Q8OU5a7KDch9UbcQDZspS96Vqu3fmfGPpmwD1zN7uF8Y3/kaIFCjcIBJRXeUrwJYdmsXGe47X7gItK0ji94EZe5XA3dD949JWN9Bj5ODdRxgF2eExt2oVghg5XnAaHvmgz96Yo1SoF6Nw+28UIrowoGNz72/MFNJu6qT+UdL6c6qJoCf5VTRbn7K08dsNVpvqUQ6L36+aVFYpUbU4pxpdMBTCFHMW8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRtaHDno6i6rXoyBQ1MYcApguD9WwabFyLUXilNdRJw=;
 b=fY4B8O6ZTEZToOKom7tFNAAGmuwC7sMMpG9Elsi+HorhSLBqwH7f+w2cnK8je0fuX5tyKbKWZ791Khyr/os/7kGr/c398HFGnxMUHFdCMYQ5kgqZtc6xDL3AI3TiRy2p3X6gG25UvNJ1aLqCCygSz0BC4yKnrQpGeUb1TAWnJ/0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 04:16:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:21 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 06/14] xfsprogs: Set up infrastructure for log attribute replay
Date:   Tue, 16 Nov 2021 21:16:05 -0700
Message-Id: <20211117041613.3050252-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42b04aaf-7084-41b1-0fef-08d9a9810306
X-MS-TrafficTypeDiagnostic: BY5PR10MB4036:
X-Microsoft-Antispam-PRVS: <BY5PR10MB40365C00E9391510539217B9959A9@BY5PR10MB4036.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r3sZW5GNlx0iIDFi607RvX8dyvj72137R3QFapPutgWveOQLOdhf9W+uUvFHBTIiEB1NAK/Y6Zkpg6c9gumdEUNvSoA9hKSzO+GgQVVBuJSDBuisLDI2SZYfFK2SE3HlNChiuWKbT8uGaZ+dXnDa2Vhf3e9m/0U6L6fPLVeSVzmqbNJZlW9B5ygTyxIbvn0UIoM04KQcObrJCKZPS/4nplnFZqkjbMIr2dCiz3y7Sfh9+B0hrnX5oUsi5d1QrF3wTLPnqM29fI4NCq5bjUcGVt44aFWFx6r3IUf5LrW3aBK4snKUXt1JwODpuFb0QGKxXjQHrY2jVC5XlZYAeACYswoCVGCz+nhZURUVDfnWM1tpsDDQxjEzcPS6yf/elAJxe9GOHUZU9yRg65vi1ekIvRyw/CoB0L7fQvxxBXcnWYUFkZZkwo6d9/8BQlNNYx36uPg471jVZFOjsjc/GjbcGrCyVp5a+Uw/J/fe/UGl8CMY/8E1dwtMMyyVCrYQgvCGTwMPzMC+dlWp5OLSPanDz9lwYNDcLSo3uoLcS5m1PD7+7dUW/SyMP4d2QZtQPDXWm8pZBX+NJAYUKw9ui9tSYhYLGwqicmCd0eBPIRZ9SmTmPSrHCAGMhqE7/7XaiheHVE+NQOzEKVxKQF1rb9MfTFHYzJapDWNTvTe9SzaBUATvno4ec/WbUW0SwV65N3os1/GzfXlrrJqIhjyDeXghAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(6916009)(956004)(8936002)(6486002)(26005)(44832011)(186003)(83380400001)(6506007)(8676002)(66946007)(1076003)(36756003)(2906002)(52116002)(6666004)(6512007)(38350700002)(38100700002)(5660300002)(316002)(508600001)(86362001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I/xGtJVo59z3703FeCyaYv/eeJClenRpiCY5fFw57Q44k4t2F2EIkrxiR6ho?=
 =?us-ascii?Q?vShAbj8z2KkXPRm4hj3TfwBLFGlpHWWawf9Q6H8dGvPN0SsqV5Rb99WGT3gv?=
 =?us-ascii?Q?z50xxj1nxaAVtYmsZMrXsw1nQipfQNZHkLXOthwzsweetIi5t2ekwCfprBjq?=
 =?us-ascii?Q?qIWzyU2p1V/Sw9F/n43PKiIsn43OcD00vRnjNRl9RYP9BZUACnCqGLEH8PT+?=
 =?us-ascii?Q?UG43IW7KEkKA6kzj+mca5i+P1gMS+/31QwDFisRHQk6FR4b9/IXnNWvqap8E?=
 =?us-ascii?Q?3wYq2JyCrWKtC4BKJwqxkmhe4hdqkqDiZ8mOIA3TXdNE02O98O1cvuHJfHHB?=
 =?us-ascii?Q?hT493ahIzqbkkU/W6QvZhd+SfL1HZn1bKqDgbq1iZh85M/exEqtZXqxhILZe?=
 =?us-ascii?Q?E6tQA0LeLxecUW0TZDEDs2BCKEhNbrLTZ98YPdC2dni3GVA96WXV5ROLeXwB?=
 =?us-ascii?Q?0GNlX7mRkjCU/nkqFD8MiSDmIDkd1bx4Pgtu0Fu+C7MK+J8/fvltRPZh+n3B?=
 =?us-ascii?Q?nWwRxZSbfMzQxugwKJzTN9Lm3YXAcdGLrxbI107jsmB5iJYObjUgRLO6US+6?=
 =?us-ascii?Q?H08yHCCTzi0SoFRb6P35Y58A9AEQ0Yx+lDyA4TJPeXAix8ePBpAOfxgaoo4C?=
 =?us-ascii?Q?TNkgWaTScSWN1/OHQW6vOXqUS7/oZ1Yi6hVSY9GHZi9+3ybDKN9f0ni4yCBY?=
 =?us-ascii?Q?HGiuZw86GumIdjqrmoCSFSBbdWf54LQwdotrSaj2M77jfyPifOv873L5xKfz?=
 =?us-ascii?Q?Pnht0lEcl+w7hKyt0uC0+QsGd8sshp7fOCzxqljAwwtX+QxHLrnLa7gTfZqJ?=
 =?us-ascii?Q?5fr/3Xva/WGEBUx8nH+80HU4MRqGr4vGIAPmSHVKCBvFp39FQDnJYXDq0umJ?=
 =?us-ascii?Q?8AEbxT3895dVu4mTbm0b8/L/PXv1DMGbIxEU63m8ybqd83HnJBunrJtP7Rf4?=
 =?us-ascii?Q?ndjGDRY2F77ocFPB0VPj6x5/Uyq6ycruia6sEevpryl85cdSXA0c3GnFM8FW?=
 =?us-ascii?Q?Vs1edizLRgFJHa5nSY5tXDO7jb8rvx6S5f59eqIkz1H4vPjwUQduiIAQCxmN?=
 =?us-ascii?Q?h4a5uN+qAfOyexmqJ2gLo7ceeXl0fiZMQKmv8xu6NnnozTiNjOdMBcgoe062?=
 =?us-ascii?Q?zpGDo3kb/8TmLTBS+yAP04w9dA9c5N00d16k8aih50vLFyS+mpAC03JBUrVB?=
 =?us-ascii?Q?yx5pE+1/L5clC9h/Y3z3H4mcF1YBdN/Ug0l/G2Ca4iwS35rDzbK8WIgRxzfE?=
 =?us-ascii?Q?bEpI+hdm5GtzLY9Jc0zCHRSnW+9VRZZK/IHghjw7/5pnKKY/y6IeIpUolVzL?=
 =?us-ascii?Q?SL7ZNGx8iqTA6jth0qqeRM1Gjf6jqY6Smf9bFKCrOFT3WE09VT2ciBrFMrcK?=
 =?us-ascii?Q?nWuVHuUWHL0wqulPGRTJKqdl7RvFQPaj8ybTGWPVQ/yiIx6vew3fIC9jOD/y?=
 =?us-ascii?Q?E8nTK7LA1R69bbC4XAFEi14Aw3q5vdNHjTQsJhC+NyCxALMxOwNGFknJO40h?=
 =?us-ascii?Q?593XTZuNhF2krdiPOtmD/U673p20+kMihmwpZfV3YppnuCO4CQN16rdcJ54r?=
 =?us-ascii?Q?7pp5TFUTqor2A/uTtoLQ0cqJsDaY+sciPhh7aAFW7EOihqAmowNbnvXfctvt?=
 =?us-ascii?Q?o/AJ28Rer1om2kna5Zn/Rsg1mR4wmLvL/z3kIDYe+ERhf88fswVZXChsBVAc?=
 =?us-ascii?Q?rMZUcQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42b04aaf-7084-41b1-0fef-08d9a9810306
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:21.7624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ML9MijpE5MFdoxbmFU4CWbFXDzyIdS2F4fCdCGRfbh1bsMswgRjekkSVUf84xkjuAPwRhwRTQe3n0yV17I9rHD9LHzd4Kk7OXQxUE43ooCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: TX-NKNMNgSVA9KJtghXaKJBaxrg2qUf9
X-Proofpoint-GUID: TX-NKNMNgSVA9KJtghXaKJBaxrg2qUf9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently attributes are modified directly across one or more
transactions. But they are not logged or replayed in the event of an
error. The goal of log attr replay is to enable logging and replaying
of attribute operations using the existing delayed operations
infrastructure.  This will later enable the attributes to become part of
larger multi part operations that also must first be recorded to the
log.  This is mostly of interest in the scheme of parent pointers which
would need to maintain an attribute containing parent inode information
any time an inode is moved, created, or removed.  Parent pointers would
then be of interest to any feature that would need to quickly derive an
inode path from the mount point. Online scrub, nfs lookups and fs grow
or shrink operations are all features that could take advantage of this.

This patch adds two new log item types for setting or removing
attributes as deferred operations.  The xfs_attri_log_item will log an
intent to set or remove an attribute.  The corresponding
xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
freed once the transaction is done.  Both log items use a generic
xfs_attr_log_format structure that contains the attribute name, value,
flags, inode, and an op_flag that indicates if the operations is a set
or remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/defer_item.c     |  3 +++
 libxfs/xfs_attr.c       |  4 +---
 libxfs/xfs_attr.h       | 30 ++++++++++++++++++++++++++++
 libxfs/xfs_defer.h      |  1 +
 libxfs/xfs_log_format.h | 43 +++++++++++++++++++++++++++++++++++++++--
 5 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index b18182e95ac8..a1f0d7e52ff3 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -20,6 +20,9 @@
 #include "xfs_refcount.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 53f4d546ed6e..61cb7ea9ff5b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -61,8 +61,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
-STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-			     struct xfs_buf **leaf_bp);
 STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
 				    struct xfs_da_state *state);
 
@@ -166,7 +164,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+int
 xfs_attr_calc_size(
 	struct xfs_da_args	*args,
 	int			*local)
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 8de5d1d2733e..26f67cc79082 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -28,6 +28,11 @@ struct xfs_attr_list_context;
  */
 #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
 
+static inline bool xfs_has_larp(struct xfs_mount *mp)
+{
+	return false;
+}
+
 /*
  * Kernel-internal version of the attrlist cursor.
  */
@@ -461,6 +466,11 @@ enum xfs_delattr_state {
 struct xfs_delattr_context {
 	struct xfs_da_args      *da_args;
 
+	/*
+	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
+	 */
+	struct xfs_buf		*leaf_bp;
+
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
@@ -474,6 +484,23 @@ struct xfs_delattr_context {
 	enum xfs_delattr_state  dela_state;
 };
 
+/*
+ * List of attrs to commit later.
+ */
+struct xfs_attr_item {
+	struct xfs_delattr_context	xattri_dac;
+
+	/*
+	 * Indicates if the attr operation is a set or a remove
+	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
+	 */
+	unsigned int			xattri_op_flags;
+
+	/* used to log this item to an intent */
+	struct list_head		xattri_list;
+};
+
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -490,11 +517,14 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac,
+		      struct xfs_buf **leaf_bp);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
+int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 05472f71fffe..7566f61cd1b3 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -63,6 +63,7 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_attr_defer_type;
 
 /*
  * This structure enables a dfops user to detach the chain of deferred
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 2c5bcbc19264..f2cfa9724448 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -114,7 +114,11 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_CUD_FORMAT	24
 #define XLOG_REG_TYPE_BUI_FORMAT	25
 #define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_MAX		26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME	29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_MAX		30
 
 /*
  * Flags to log operation header
@@ -237,6 +241,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_CUD		0x1243
 #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
 #define	XFS_LI_BUD		0x1245
+#define	XFS_LI_ATTRI		0x1246	/* attr set/remove intent*/
+#define	XFS_LI_ATTRD		0x1247	/* attr set/remove done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -252,7 +258,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
 	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
-	{ XFS_LI_BUD,		"XFS_LI_BUD" }
+	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
+	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -869,4 +877,35 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+/*
+ * Flags for deferred attribute operations.
+ * Upper bits are flags, lower byte is type code
+ */
+#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
+#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
+#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
+
+/*
+ * This is the structure used to lay out an attr log item in the
+ * log.
+ */
+struct xfs_attri_log_format {
+	uint16_t	alfi_type;	/* attri log item type */
+	uint16_t	alfi_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfi_id;	/* attri identifier */
+	uint64_t	alfi_ino;	/* the inode for this attr operation */
+	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
+	uint32_t	alfi_name_len;	/* attr name length */
+	uint32_t	alfi_value_len;	/* attr value length */
+	uint32_t	alfi_attr_flags;/* attr flags */
+};
+
+struct xfs_attrd_log_format {
+	uint16_t	alfd_type;	/* attrd log item type */
+	uint16_t	alfd_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfd_alf_id;	/* id of corresponding attri */
+};
+
 #endif /* __XFS_LOG_FORMAT_H__ */
-- 
2.25.1

