Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02BA2C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 23:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377853AbhLFX7N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 18:59:13 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24244 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355866AbhLFX7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 18:59:10 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5M7r016268
        for <linux-xfs@vger.kernel.org>; Mon, 6 Dec 2021 23:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=JYaMeqwzhq2D/4Q9fcuvcxFxVadRxmdIwuW3Zo/iT+I=;
 b=o6b/oSFc83nzE3dr3jqjvA26+Mcqb61mDI86byOgZMxEbqemDYk34U4t1xODSrDmj3Tm
 BZSTN69vGpqHyFb53Piv8HeOHopxnDi+qdVpkJx0v0u4T4ox56QLXxQiXy/i66tDZvzz
 C8pzhYNKRvlERUY9Pe7WKCpO1zStCuIiVo0XPNq6ITx3aGDQkFHugzKitU8YVLUhpmti
 P1+BonicOgm+NFmGefO+0o6YhSN7XSbnwa9ZFqXfX9grj/oYa0kYogEBnq2s4N+vYyoN
 yQtzhFBEMp6ppDa/BOJvqRRsRs5vZwvu5+kwEjdSgI0wwSEi7gJWPPw/y6u3ZJGutkIA pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csctwkv7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 06 Dec 2021 23:55:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B6Nk4oR068205
        for <linux-xfs@vger.kernel.org>; Mon, 6 Dec 2021 23:55:39 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3020.oracle.com with ESMTP id 3cr05459d2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 06 Dec 2021 23:55:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfErw7/GJJXGpg/V/ZZ3kH5NfzzxTXIM2nN1EEepMWsqlQ3FChsfkck11AUHSvbUKZ/mJtZQoiTwwS0iO89CY45MC3g1IyrLTVP53FGD2O82nx+7H3/TPooJsGFHJaKMM6B2PbIgE9jlRRl9SUVrCDG8px2Hra0NvSDQ/Zxe+37lRkWXL8aI77Vr9dLTolYtPgUY8qYWePH3TL1DDRkpxwcyvPsqBEh3MdzlByIOHIgcT0GaDzSovrx853qByx0P1L37g0cedulyHDxBTfNciM0YxM1HDNNYnRptXFisOeH8CldVelIM59IuvftVEqWPLSraNY2RGWL+ruC3s3UEFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JYaMeqwzhq2D/4Q9fcuvcxFxVadRxmdIwuW3Zo/iT+I=;
 b=aKp38s4jK3E1hnDMkyYFdwEGLt5yodGhmDEnyJYq4EFP2b1LtIZm9YtMuWeFbyHnwdpTrklOvWnIwUEPyYA/AfeOZXd5AF1hhxHWVxaVRZJ9c8SBi0UrvIDwsLDblOsQGWCwro2gHCjMJyU/06OGEngk2meo3FTkuh4u6ElFymi+HbXHOmyop4JT01eUVHZzBOGUgv1uOQCV2LlUqz/mMPxp1hpu2HJA+oajFA9zB5hCNfwTsQAUHrUhKdxztsLeK/uNVy7UM/jYXFRimazoIUBjgjZdmA1sXXnTPKxRBhMn/xmopZX1H79OLOeRzOwdMHtjyai0YypKBdSiXdpMlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYaMeqwzhq2D/4Q9fcuvcxFxVadRxmdIwuW3Zo/iT+I=;
 b=CAqw7KiKazg/nyMeYJpGQ1ZQ8nAyC1hE2a6aU5baIx9nX887/kb6+Kd3JLHWacvgDz4Ia3IzRN9XjBRjn+tAJvs25ZoUTTC5X9+eBi/QVf5ICA/EsI4Dw3nFZXiN9vPCuDf2Pbc/ZZzTNuT7BNEXIbN4q9nDJZvOlbke0jn7ses=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2250.namprd10.prod.outlook.com (2603:10b6:4:2b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Mon, 6 Dec 2021 23:55:38 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%4]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 23:55:38 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 1/2] xfs: add leaf split error tag
Date:   Mon,  6 Dec 2021 23:55:28 +0000
Message-Id: <20211206235529.65673-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206235529.65673-1-catherine.hoang@oracle.com>
References: <20211206235529.65673-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0169.namprd03.prod.outlook.com
 (2603:10b6:a03:338::24) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by SJ0PR03CA0169.namprd03.prod.outlook.com (2603:10b6:a03:338::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Mon, 6 Dec 2021 23:55:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60376e2d-56ec-4056-5c7d-08d9b913e6f4
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2250:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB225097CE9A495B3BAD720D80896D9@DM5PR1001MB2250.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 50zSKMaTi46A8kF1is1Kdw9+6X+XVjZ75j9OJBNcDzgFKhb4JSrp6Im3jV6wkr59sSfOiFKRyoXK01dUXtK81iarB1Scd3dB+s8VQ2Ue4jYMwBLZAjqzQsQZau6Kw8pdNUGAbhDsPAOTSvjnJj0hcuDqEdj9Ms0v5ilgrb5/Zj4oGPYcEuWr0gxdGw79tI6cgafaQych6wnh2J650+5JKUZ70ju0r7ZFGlkKBA0UA2UGWXX6N82k880n8RWjRVjY1u7LqRvlZs5FnuBANyNr+3ma0nrx1WNziK/2QpIppxPhWBhpcOA//+1WQtGYQ8OXiFIs7b4NwsnZPM4UjI04dkHC6kBSCGCDxWdVcc/fkfXfaobvmf4W9RYJd8XpLcFsOHnw3nPdaX6CZ2KRYY/xOL6wirbAUC+eUcZtIVsZjSyME5FeadQp72CEhKIYq+ee0yt/X1AJ7/5dkhq2JFHbEXmBMAkDZ7oDIdSJUthcAzqHV21WENHdnwxRJAocZYhbo1KxgmjSGRoN36QlJGNeG91UBV7JkpfHMuskfKwpXnFCYxD0LoY2W3v0v/TBsr50SL2nRpMZ7UzvgejR6pFQYskzpAt3JHWtXm2jJ/ZEkO/3c2LvWEuyb0nVHeybaJrhikGe+V8bC9Q2kI1/jBL+5cjM1YqPkpZGe6ez3LxLiZbNBzG/mmqeaNp3Rdh8weCm3wTEyuQhrTlFtgC/xnxlsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(66556008)(66476007)(6916009)(66946007)(2906002)(6666004)(36756003)(8936002)(8676002)(52116002)(186003)(956004)(5660300002)(44832011)(2616005)(6486002)(316002)(1076003)(508600001)(83380400001)(86362001)(6512007)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JEaE6jx5KgxNWxgz0nXh9xhltXdY3E6+sEJgl4FO/i2T4duiwF63kbH3/RBh?=
 =?us-ascii?Q?7O+FsC8ENKxyXWMX5/Zi7kx/LRKzkGF4knY9nl1TPha+xxrxO8mpzb5TKdr+?=
 =?us-ascii?Q?9qw+vtu71cSoC2mIYpxT+TVFNpPvsCiOR+6HlQENb6Khw1Qru+zlina2SqQD?=
 =?us-ascii?Q?fSNWy7UcxFeDkIVrt+BEr4Mn6cTvfWB0jvSnY/j53knhuaRxq6sybysVlKTR?=
 =?us-ascii?Q?euby87DSXeMRE/+BfeTaU5J3p4SPNbu2200bS6dMQ6XZMc/7sz8QVtqCGnmV?=
 =?us-ascii?Q?P8I469HOHYQ20u+KiJH5QbhQL77S4T7G9cSVYUFWm6WmnNrp1YvZJQ5eQrEl?=
 =?us-ascii?Q?NvT+1L9vP1ytHyuBSQ6T0TJlUHu5XE6JXx+tvgEORggYFcfd4g+TFD5fDGYH?=
 =?us-ascii?Q?tW1s8JckH3xzGAABYU8TNdHgkc/Qdw6UR72IVorU6OvdNDq7pwg8iOzX+z2Z?=
 =?us-ascii?Q?kTBXXXgd+tVzEW8Ruk2KBF9DuWfMw9nFf4mdUq5W5DGGvz6VJUtAzp10ocpM?=
 =?us-ascii?Q?kSbEVJCpZVo3gaFnZ2amkJku58YLB60xMhQ0L33myUyv55AXaSqX5cA/VHBc?=
 =?us-ascii?Q?QZ+oJ9h71WUuFs92CdQ8OXSjlRj4yi9LXwYcuKNVXvaZLWCC+1RjavJnZDX0?=
 =?us-ascii?Q?9HsNHDQdZWGdd57aHQVV/1MFeLGbumxzvRJfyzLChHYLYigdssotVskT8TMu?=
 =?us-ascii?Q?F9Br9fCd4a6unYRY8ZrdwZXm1RbFJoLpEdrZsc13Q9/wO8eTSrf/xH6syPMI?=
 =?us-ascii?Q?X+0dHsmUgu0e6rremilaBk7RHpvpDUqrNFf4y04yLlSRYatZtva+i8S3Qivl?=
 =?us-ascii?Q?yTiL5moArO0KZi2YnzC9gtotInzVE6lTOdoA9zAQgBJMMiYa07BFCwVKBIdF?=
 =?us-ascii?Q?G7I+NCzUsARVs887msHYdXzVl7OH+pWlF8t2yel+AeUy5V7DC57PyHz1d9a5?=
 =?us-ascii?Q?uxoGuiUkuuyb8Amg/kO1oJ+EZCxKIOx75wx/JE8w9d+5lseIhQd52Op2J11W?=
 =?us-ascii?Q?J37zBnBvK0csWmSm8v8OlVE3syoNJOQap+I2GBaqR/lf/e6pLy1ds5Q/WXq7?=
 =?us-ascii?Q?4rFu8w4MJgOMMAAE4WWK06OKD8Suu+Ug6XK0IQGC6FbxkkwZYbbAMrFoKllJ?=
 =?us-ascii?Q?dav1ShC24ZiBhvL/x1qQwnH29ELgw7nNSfrwYD5rn77nVV//1LwdrCcxCP4r?=
 =?us-ascii?Q?qbzRYCz2WQaMMLhtalcT66IGldamQnlV7XPj1MgOBzmkHOaB3+cP6RilTL/s?=
 =?us-ascii?Q?A3FmK2KsWNPevAsOGi3jDtC90ZlKVSeYvow/UGQuq6T7t1F5BbE2N+06eeKy?=
 =?us-ascii?Q?I3yFydd8dbraizbYUi7hEAcrlSlleBGXZf2wYSD30xRGL99rOb8T6jyh5TKE?=
 =?us-ascii?Q?zQNJg/s/GtIyDRy1z/6ZMYiQjLkP350s0tImu4oATbDCFzms7eZNf0s0n3A8?=
 =?us-ascii?Q?Y1jHBf3WaXzI/JrRKJWYBzq/Yq2O0TJq7rqRtFUxwOGQf5Gtzs27kWyHc+zo?=
 =?us-ascii?Q?Np/dvBZJnDXnSb7seuyH63rl+KaF5ubXtRjQEdnOK1JW+qPhX2SPww0IG2HN?=
 =?us-ascii?Q?aYe2BTPiDBe7CevFOsbVKep+StQkD+y5Hixo4TijOUupBfe0IWZFd80LKTg+?=
 =?us-ascii?Q?yMNne4aO8z8yYVVHywlyKtD0XMAFSFIsZnbT2coBjD5lD/vV2LwMJNT9x1nW?=
 =?us-ascii?Q?dkAh6A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60376e2d-56ec-4056-5c7d-08d9b913e6f4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 23:55:38.1316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6N9liWh/3MtfH+qFa87JzYak+IUMJCoMbpDy3kIrToHrYhXrsgczxwJ6mG7VfXhQ9BsPpTbPr4p2MD4oGlqfOBESfTdjG3u42fSGT/4S9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2250
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112060143
X-Proofpoint-ORIG-GUID: Kphg3KC6zvqhAqJZbFHIsy9oKFZ4tMeT
X-Proofpoint-GUID: Kphg3KC6zvqhAqJZbFHIsy9oKFZ4tMeT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 5 +++++
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index dd7a2dbce1d1..258a5fef64b2 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_errortag.h"
 
 /*
  * xfs_da_btree.c
@@ -482,6 +483,10 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_LARP_LEAF_SPLIT)) {
+		return -EIO;
+	}
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index c15d2340220c..970f3a3f3750 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -60,7 +60,8 @@
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
-#define XFS_ERRTAG_MAX					40
+#define XFS_ERRTAG_LARP_LEAF_SPLIT			40
+#define XFS_ERRTAG_MAX					41
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -105,5 +106,6 @@
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
+#define XFS_RANDOM_LARP_LEAF_SPLIT			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index d4b2256ba00b..9cb6743a5ae3 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
+	XFS_RANDOM_LARP_LEAF_SPLIT,
 };
 
 struct xfs_errortag_attr {
@@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
+XFS_ERRORTAG_ATTR_RW(larp_leaf_split,	XFS_ERRTAG_LARP_LEAF_SPLIT);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
+	XFS_ERRORTAG_ATTR_LIST(larp_leaf_split),
 	NULL,
 };
 
-- 
2.25.1

