Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5667C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A33A860F26
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhKKAUQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 19:20:16 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3424 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230311AbhKKAUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Nov 2021 19:20:13 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AANNOZv032063
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=DjqRkCGtO88+b9IuCw+d+LMJccJT78yfWL3XsmbJMnQ=;
 b=bleIjyeSYyD/ww/vJnyl+Uxvv3+K0k8o94aTMtSisyBhzHz3pxa956+XO6xu8l7x1DM0
 x9DDycdumrQX7Dr2uTeVw4h9u8MgYXqNZGLQU4xB0UDe3V3uVc9ejQOT5WsajMLERo+c
 E1MLelIHC89kQOHYZunwv4OWKxrJufAsvppDSH0LLBdiXqjyDBC7ABv01eoXAEpByYHj
 UvsLG8R8a0tEh0xdt0qvctCWFVDWyibvgVdZESTS9FoWQAY3K5qzRR1XhO3Pb9R3HqQi
 qaFeMQ7UUNnV3aHgBZTbMQR+okLHZWt/beOFyBhxdl+TcxFR1CAjfwkT0ahEfB/7H8Kx nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c89bqenec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AB0ALjN178474
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 3c5hh638b2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jii4qI5UZH7riH5zCx5LQmGJuIRlJOd/JDgxJyusQ6VcVk+XBGOzW45x+mHh9NpJmgSrS3z9Iolw9K8ilND2HBb4DRKjXimpdfSoY9aHukc3fo1m3aGBlXf+qYA3zXPDJijH2RDFkDMHB+880MJ4WqdKlzyRv1lzK0lV1bwHTfiokcYW85P86N3WYFYesJWNgjjzi9RTqplLNhS2pdJU1wox4fREVaxIBd8gT9DodYMepOW8n0vZbN28tYeX6P9ZHgAIzIe1jlpYyVQIoNWrnSExJjTBZ+XLwvni7G7gllbjkVaGGPOt0/9CLulw0XUy/FZj3tbqM62NP/Pet7XANw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DjqRkCGtO88+b9IuCw+d+LMJccJT78yfWL3XsmbJMnQ=;
 b=E8hdSx0JSIOLwmKrCH5z6pMe8MhR2nmlZ3ZyIk0LBqTpdrS8xiAnqv88S/fJythYVMlF182VcuvrYWX09E0aU6EjkFQlqBCapDV6N0LWTusLW0H9k6fJFqYAeClbKJ4E3n8N/00KF3kKuN0zzUDRwfZ3tmyPAcV3MhLLU1YbpGuEcwXyZ9hZlJc3h0S6tzPo2RTodV7HWpHQQ+DnUi2we8p+s8Zxttvtguiww4MfSYKJM7K+RfCV/XysAm9gtK4vTK4tL5PKetTCs/RQEGPTv0ulUV09SaZ4PrHua15obfx6yh8oq0FM2W2JRcU/s5VtoPusFphR31NUmKU/MvcV+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjqRkCGtO88+b9IuCw+d+LMJccJT78yfWL3XsmbJMnQ=;
 b=MOWKAUKulEvgPlD/tuMgHcvtjNEPdCyaWCXJPFj7Okbw7L/W/cMg1NLrXSwcqia6Nn2p0E3y3mCZsi4Qvj24AO2avC2jLyTD6zYZRta6riUB+XFT40x4ELA6z535I7o8osn4dnsAOVgWdi5nWooVE2ATcl3MK+5dVi4dXQ1WpXg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM6PR10MB2889.namprd10.prod.outlook.com (2603:10b6:5:64::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Thu, 11 Nov 2021 00:17:22 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 00:17:22 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 1/2] xfs: add leaf split error tag
Date:   Thu, 11 Nov 2021 00:17:15 +0000
Message-Id: <20211111001716.77336-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211111001716.77336-1-catherine.hoang@oracle.com>
References: <20211111001716.77336-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:208:91::39) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BL0PR05CA0029.namprd05.prod.outlook.com (2603:10b6:208:91::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.7 via Frontend Transport; Thu, 11 Nov 2021 00:17:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8213a85-32b4-44ba-e0b8-08d9a4a8a19e
X-MS-TrafficTypeDiagnostic: DM6PR10MB2889:
X-Microsoft-Antispam-PRVS: <DM6PR10MB288965D9A2BFE28251746E8A89949@DM6PR10MB2889.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nUs1Q819UkPgiU/L3uHdjeVQO3HWVAuy+LOzyvtIvAUWQ5MOpUrtIsO2siABxU6azcp04+jw/EMLuPxcwh99KOZqBfBbNK+X0goWpk9tn+7K6y8z1FTTguQOHvKkpK8SXwyvI+nuQV1CCdrOklUxV0ZLJl2ZOWO1llNvvRP3B6d8gm2w0eLNdX4EuRZ/FZDHBfDdcsEsfL9VEwoQvimOfqfZWK0LkiLssEUx1xGRoDF8kaCx9ktjIwaVzlM/P2DvIeunnwdrIsAFCOxYukbUbaMhIDso9yuUvBE/c86yrKv4zqGCkR/TEbfKgS0TFhxhYAeRIJSJpipZfjQXIfc1QfxECzLDOfg9cNchYoqPU6+fh9HenbUZMn7lESqAI2UoABHn8CJjHFieiCO8P80kablOdRrB5puwjN8vJiyOlTpM9D55qWNwJHQqh/Pbc41+KL2WJ9j+55jGJX/ssDRNob51Kj3YdWyEEnl+rqjl1MIjPx97hi5m6VrBxtJx77NTfopF5MzHJG7ubEtVfpG5mP5cW6HJ+AXQcmKnPjAmnrfiYJCNY6VO7wE+iEOLYMA/AmmrKgx49uyvaHu9mA/IDOb+TFpJWLh6qKQ0ZYQ1b9CWqoe1WY+/LuD7GYHM0icQO7OPzzzhHKJOfZbu3jWhuT9cG/OwHLyG8CMeywlxpXYCn9jFqNoA2siG0babYBdpnwbxrbha2II8rZCBnw75Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(66476007)(8676002)(6486002)(36756003)(66946007)(1076003)(66556008)(6512007)(5660300002)(186003)(38100700002)(38350700002)(86362001)(508600001)(2906002)(52116002)(6916009)(6506007)(956004)(44832011)(316002)(6666004)(8936002)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+/SwY+59PShcZl1K0hytKkbrfMAm01TulXezibTClzAJzj+jSAgSZHO5CdJO?=
 =?us-ascii?Q?auRonN5OXlFRl/hFUrgT5LP4JidhskAc267OlDHNgC6GENHoSrZ3iEbLJx55?=
 =?us-ascii?Q?isspKxZZ8BiuQo6jUMolOnil/9ANxJ6WadhIHfkD+kMa3K1W0q2naWX+NmFs?=
 =?us-ascii?Q?Ii5EKhGE92qQeY5/cu6i3hU7T827Q2nodIZ9HAz6Yzk3A2oq2Hjs1CgH7Ha/?=
 =?us-ascii?Q?m3dqWCHKzYeFUUap4EPDuEE0McWGIjHdWHZt5hNrBCy8/VGZ8DfHbkz0sQiS?=
 =?us-ascii?Q?XLv+8q1YUIRa2k8gHgtSpx9KUvLn7BnV0LtoV0sT0JrRMsj44QkDvQxCuovl?=
 =?us-ascii?Q?rvz+8mNATRAjhjPqlV8bmzDR1UYzYNm7AZc0IWX7ZwEkn+jsVjYMH/YI/5ni?=
 =?us-ascii?Q?xRPHx3y4kMe4be5fZa1jjVV3YOMw6qdiHRXatfPLT0tV0FCMjVfouUwy8tPP?=
 =?us-ascii?Q?BnXA8PHDS1kZrN3G4WFpYpzfbXYLfS72msVBdCF/G6QGmjuLDpBOgLoeTdfV?=
 =?us-ascii?Q?LkQJ6bkxh/aJPBaDlS1v5w6syad9omd7FQKLzIrSLLY+yb+GMzJ4ePrYpls5?=
 =?us-ascii?Q?vvt82B8QcL0HfJZ/K4Z1cd1h/KpS6HyoLS56tiLEgplYGHsnWTDSnckv+4M9?=
 =?us-ascii?Q?/5vAKbMXrmjMww01Pa5WAgFff+IE3oNM4U0uhFG4LYVXI8nvaDy67xW2GuyQ?=
 =?us-ascii?Q?BDHayTbCyiZYC5GUQEruW4JXHcRFFsszjaSNuGcKsXC8i5UlEYMd7vDxhh4C?=
 =?us-ascii?Q?YRPjALkvu6mAv9WOGZSiiXRRI50ipNqaq+wiQkjmFbpvKzyDA7G+kyLmnTyg?=
 =?us-ascii?Q?hzgTIjIgesS/sqacAVz6nFKh+MAQgLU56Ty04EJUKhPVKLzJiUo0nWEFNa3o?=
 =?us-ascii?Q?R9ptVL0LdFZuEsN/gtB5NETT/4D3RqKMTZDqe864dTylDYT1APclSgQF1+rr?=
 =?us-ascii?Q?TdBCTzk/AJLO1cyXZZOmJboBCf4eGkGG/w/xykR/o6Bvewynl7Ld0GkrlThZ?=
 =?us-ascii?Q?FxbztU6DlO+dtfMcCbQcr1goj1IwxxApCeq+e68WTD7FJWw1hjrLBNnbWbzw?=
 =?us-ascii?Q?H4KHn7Z9HcMA9iFMwY3GvsWItJ/D9HgHyQhd4WHQ0+DXd4o7E7jZp2I3O7bh?=
 =?us-ascii?Q?SODr+DkDjhpvPXkCerKitBCPZosKjqFuJSarvPYHO3aOfdD+1hRifVIOkYHH?=
 =?us-ascii?Q?+bX9ZVaFODVec/DB8lnQAn9+GVNBSmy6CaQK4cg4Pj8mxo6IDF2k3EFytgZY?=
 =?us-ascii?Q?EkPk8359A0PNs6KdOBVA6cchi2zKhXJmCx81qll9IlqrbvvtQDCKvpmq8FR7?=
 =?us-ascii?Q?ZeDeDbvgvb0RODckB2erJE+rjtF5yWLO9ZHqu0sXk8wJNzvp9273G7RMvYh+?=
 =?us-ascii?Q?8wq6NIsZWAfKVD279kG/fI61/DxGi1bdfWbNVRmneEopSvJvBSpB5ONJ0+3S?=
 =?us-ascii?Q?unwAjBz3eKRwMgfS6Jq0ruxLE7TDQDl2BcE8TiquZdvMw6GTEjUeJ6cQmlDX?=
 =?us-ascii?Q?Tz7JZKckIFNKATgZOaxejA6XaXVDH3kooGAkQs0+kRfs+Y8ijcYm3ZMlKZSg?=
 =?us-ascii?Q?El7rA3s84zvMwo8MVaBWPPoJvwlPROcpzL2AiXeYjhuKh5r5wXZJ7YdP7PX6?=
 =?us-ascii?Q?XEYgXDTOMaNchEVu9gZjUTXxcWujUdCOfRK8b9/gfSIu5KufmVpGLreUYcHi?=
 =?us-ascii?Q?1CC6oA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8213a85-32b4-44ba-e0b8-08d9a4a8a19e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 00:17:22.3630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1enIPw4YmjzOeqDI3PrJIowOqVAzCUdJBhnXSaMss+SpU2SkERfsZ+XUvZqQ4PQBaHfodkgj0gt/hjO3g5dOm1GtuxEV65/3UvBLvsZXUpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2889
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111100117
X-Proofpoint-GUID: 9lqjey6nK2JIYmwgwvVHEhe_chj6Pu4p
X-Proofpoint-ORIG-GUID: 9lqjey6nK2JIYmwgwvVHEhe_chj6Pu4p
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 6 ++++++
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index dd7a2dbce1d1..000101783648 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_errortag.h"
 
 /*
  * xfs_da_btree.c
@@ -482,6 +483,11 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_LEAF_SPLIT)) {
+		error = -EIO;
+		return error;
+	}
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index c15d2340220c..31aeeb94dd5b 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -60,7 +60,8 @@
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
-#define XFS_ERRTAG_MAX					40
+#define XFS_ERRTAG_LEAF_SPLIT				40
+#define XFS_ERRTAG_MAX					41
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -105,5 +106,6 @@
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
+#define XFS_RANDOM_LEAF_SPLIT				1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index d4b2256ba00b..732cb66236c1 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
+	XFS_RANDOM_LEAF_SPLIT,
 };
 
 struct xfs_errortag_attr {
@@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
+XFS_ERRORTAG_ATTR_RW(leaf_split,	XFS_ERRTAG_LEAF_SPLIT);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
+	XFS_ERRORTAG_ATTR_LIST(leaf_split),
 	NULL,
 };
 
-- 
2.25.1

