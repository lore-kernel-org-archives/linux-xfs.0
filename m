Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01AC1C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E251E61B5F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhKQET3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:29 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64936 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233023AbhKQETY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:24 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4C1SF032037
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=bdaYttU5zKADtZoeJlODrhsr/rVdtU8cv4nfOX0sfEs=;
 b=vCHFBZaAFLN1WZM0yhx3XpETJJPGUlOMTu2yfrZO00twm3w5fFa+Wc5bbvquH+106yQK
 ukAAfwalByYdrR2G1OGMtPbx2TytTyJHYbMgHIDdfHyzibtEB2EjOHvDcdH9AVK509n5
 vmkJBS9fR7CuqaDmUfK7aIa2c+aMdowtmWu1gFikKeBEZ0BSpRjXlngUQ0URAhuMIFXb
 2frtUQx3DoodZMi+6KAmz1dRc7vVCNvpxXCIEbS0cu4vjpIUywaCT9eS4CGZOQyP24S6
 ocbibzv3RD0s2zhMu9V3AYAR4QrrIpqR7i4T25ItVlfNW8ItbNHajMAyxA0g2h4pP/+w RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv86ery-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4Aehe037362
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3ca566dagu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrMGEqCABd2TpAiSSvWdFt2w/cifMNZZvQPeuzig3MO2RqQb9UOgM2vJ8w35ASv4lhCZm/DMdYNHM5ipJ4rIGOvCuRmoOhelaJsOqB22EvM3OIjO6uqv6HCFKJWWSFsJpHDnaSSUCQw7GNgiXnuXbkkvtJ/+zE2DBZTn/FblAY7RZmBRLcb0AHcnWc3+SxEOxRnLo4LO8otvzPeqCywLPXXtl4g8BPEBFYGK3qHoGw/oMYZVomQ4+22h95m4z3NIubnMkUpR6L1JnJ+G7q39RAe7UaqPzI2xcVvPxFUYDi7140jL3qTchwMUXxmz+2N+fSrRB9zHygmbFo5uIpY2BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdaYttU5zKADtZoeJlODrhsr/rVdtU8cv4nfOX0sfEs=;
 b=QwgRX7y3O7j/+WQk59qYDcWP/IfKkYAZ7GkDgiYlzTBFJDYOG0B0/qVXeWwTDzPOmXZ2wJcvLdGrEeTwG3qFYqPytoo9xzIqrAPUV1ihCnXqt37zBNaKmjvtUIIE5VAyRll3gEm6qJdylI5i0pUNUjkGb7ltdm1lRmbvLC4WVvyGmEb6NvOBwwlXDbY5SL1shcjB0y1mibN6S/0e32MdRCipt/SIKFk+KhZ8nHyL69Lcf2Jg9J+OYtUKbpEWowUujMt/zEG6C4jCqEs7RHdbaZ1HfDJWgimHvRpoBVnrycOwdsewYS/DKCD7byGGRAj7Bq8ipc+NdrSe908Yuj72/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdaYttU5zKADtZoeJlODrhsr/rVdtU8cv4nfOX0sfEs=;
 b=CAkXk/UE5i8ICbxj3mMjwuY81uA5e2aHP/0/+j7R83mvH4yeWLkT/u+ttzNRJzJ2JAvdp1wYsalQwQAvuK5wCa8guSXTubaNooWJNtp4r0RpvY3fXoWnZKEI/SPxwmFGhbAAe8hFAJ0XNAidzUUgH1wjnbvzbUZ+V+Me2OE6QVo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4446.namprd10.prod.outlook.com (2603:10b6:a03:2d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:16:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 11/14] xfsprogs: Add log attribute error tag
Date:   Tue, 16 Nov 2021 21:16:10 -0700
Message-Id: <20211117041613.3050252-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f5fe846-4921-4653-7b04-08d9a98103fc
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4446:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4446329FC6F1C7BA8943A276959A9@SJ0PR10MB4446.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1NoWQ3c2dd3+M/bIDkXNH4aa3zV5CIf6tHNRXrp79OdlVtIkWLwjGIxdyMUNyWX0yBmCpRp6BW2neMqCumHRa3VTqiXXW8gq15FQ3NZmaC+2nMu1dYvLrAeVMp38YAzIv3rqZKa189qa5+0vnigpH3yotLrCrqU/OBb5qRq+rdUb5hyRTHQ3+iL5DFTOkYWTaefrZk9sfbdNVqnUURgQrgNqnAHuGA/KjrtJsxH1MzdMtGgRxwk4D5R70aNHvJitiBuF67PZgdKGvo6lZUu+q4yL1K+91kft7t00EIsfCf0MZ+w6IylCWwo4YyTvYhT+WwSLsiKrpI4BiIQkuEsobVYx4dyOQ58Eovbg/aATzHRDk2XqOLWAx9ML9sjRHFNgaa4q2ngK8AVIsoFNHZ1fkGzH/AW74v9JGE8hpuDkF8K9S1/adsg2x3C6hZbCVoC8KfJAq4MogmgfqjT4o6Ja4QAcYOTUAV2aLEalBnSRxyGLi7COXmdJMhW49b7M0Uvj5fITDzFbImxc8d8DHFys+5yyc/pRDdQbx7GyNtYt58AF6oTG+8BxLIjydNcQbHdC+0IWcesjRxyfi1WXFi9hReqEefp+G1yNUUMiyBZueBqwxl1JhZxiv969gTFNz656b+NAjkmfvXubtt63tyVMVHAN+/colnOc7uBb7npLKYKSrvAS6SLreyJdVWzYO5AO0I2ua3K7XWddWIiponeRJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(2906002)(956004)(2616005)(83380400001)(38350700002)(38100700002)(26005)(52116002)(5660300002)(316002)(6486002)(6512007)(44832011)(6666004)(8676002)(8936002)(1076003)(66946007)(66476007)(66556008)(6916009)(186003)(508600001)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lKd4NiKtWwIPIKg87Rurs7rAICqQ3P5lRyZ+NW9TSaFEn2Kj9OyOplGmbyrq?=
 =?us-ascii?Q?nt7waWz+F+22LGkuru7J9kUfAp1DVN7NJQGiMYXK2yps6vOAyq69rrh6RpHT?=
 =?us-ascii?Q?52zzXZNJcYFaxXq9taHBZbuM13RixguMrIVvlhoF67Kn4nrrZJq/1xJBeRRv?=
 =?us-ascii?Q?5sobnOQJKuBqrvXJfHg8vxbHZ/1cmctsYdXfYtF3f1Kna1bn96qEW2fbrDwq?=
 =?us-ascii?Q?qtGJ0Lb01PQxAOaTYC1y+s+MET9348/dcLtmg5jose7iFbuN3WgS+hPphdRQ?=
 =?us-ascii?Q?8KNpv3CABBrzGvKcD1N7JNKwpho6JPVNYcLoHtMz8HiTC+0HiCuENxbECtlz?=
 =?us-ascii?Q?YtwUIe+tcCWVOCXqMjaF8EF13GdDgSsFf7p0RpZjzEEbaydrAF2IYPHKlYnW?=
 =?us-ascii?Q?hIUCN5fleIeFDbm9VZT6imo0c23D3BDDTtPykQe4g0MUI6D+xjmbD725Wk6H?=
 =?us-ascii?Q?ugz2eBgZNW2DQwcLMzcRydzUaVUEVAc8/t4dASMoDcm1ntkh+mGujJM7OUsl?=
 =?us-ascii?Q?/OuRKs5oIp/K2O9ml/kdugQIZvVbtmRf6szQAl/l7df9Cy/CeM/qQ/PgkrIB?=
 =?us-ascii?Q?muclIoXcQ7syiRoe/h/rsUnRS1OO9VrS0PqXrvtnT0MVwGwocni7zSOx/+N9?=
 =?us-ascii?Q?DATuhtECbxl0MZ2tmEW/gvsaolzonhQkH+gGOaT9m915wnMsC5+SqAXIVB4o?=
 =?us-ascii?Q?qbJTuib9Nn1l0TBKoCsXIlmaoII6KzJmuTWwTqSrBZqq6eLfUBm0U8Cfzumo?=
 =?us-ascii?Q?oD109vacNOZUJlg6nXtSWHVy7gJLU90S6htaWRjwWL4E9TbuRLgBv/mLaiVt?=
 =?us-ascii?Q?moOUNB+WX/RzLLTWJOivQ0lbWhSg5jxnsGTqmxLB7HuqNMppN3A3oswo50jC?=
 =?us-ascii?Q?fnaIXmvWyICUTZPQllTouEx8L7Iga76VsdMOSpI/ekW1j7WOE4pxEVl2/dhu?=
 =?us-ascii?Q?fAZChL2frjvqIpumHySgKa9wxKCl7YpbsTW60kZn9U0nx2Al7zpbVgG7RXHr?=
 =?us-ascii?Q?yEBcTvoTIJUQ5UTEOu5vHTkIUzRCP5SEw38TXyQrx6H97vZmtoNHDuwNuHWm?=
 =?us-ascii?Q?QBXEwq+/6dnRdWFJsDaI+b6reyAS5gnZGTSswcLlN3QCK0FXxOMdzanbcOOB?=
 =?us-ascii?Q?486kQbxa5U3hKzulMTMSgQPULmfTA6426ZtZowOAI8DqK8hjgnL6oTlWpRQd?=
 =?us-ascii?Q?yAcPa1yO+r/JeCVZqrJWntkaEDzfXDdLAh6hks5sYEeTVgv/+hjTwahIaBxp?=
 =?us-ascii?Q?t/5Ten2jAgog/nkZkfgg5fZENcHh3LvIn5Y5wZDUDrXVEfU/T8YMWV74RyOI?=
 =?us-ascii?Q?QG+BmkXSgtY5OYnaAe1iScMESVZxrzVCyQNuv31B8WkOmz/MxyTOip45Zu96?=
 =?us-ascii?Q?MN32Cvo0a6gupQhNuTlHa8vlqir0ATwEQidUa6QqZmydjS46qGCb6MUCFpLv?=
 =?us-ascii?Q?pOKU+kCAjxNOYfl2WnuR9JSqw95OnnMHvRmuuU/aByCZgvEdujOxQu/7p2mC?=
 =?us-ascii?Q?cLFIDHdspYx12cBUs6n+YeBCKgEihA6nwTpnr4R8E7YN2gES2o/2ab2h7Lrw?=
 =?us-ascii?Q?A796H9eMk8zNhsJNwtTYAyeHl7UECEelimBx0htKFGyQfzuY+QyUovh806f+?=
 =?us-ascii?Q?hAN3yislhm7AD6RcwPpSb72EPURTPOdzxvfmSwPYQlFLBO3h6EwGISIIlwC/?=
 =?us-ascii?Q?5qRzpA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5fe846-4921-4653-7b04-08d9a98103fc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:23.3544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uY6eP/iA2dKwNExPCrSjDRT2sOoR3TzIBXxyLLPjJZIeou9oVq2VBQz7EnJHKZtB+h5+uTIp6FGLXY2xE2gBoozbeUY4jYemx7bAiIz/jdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4446
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: kVLybbf2EeK4MEw1YE2AyLB8dA7yDuyV
X-Proofpoint-ORIG-GUID: kVLybbf2EeK4MEw1YE2AyLB8dA7yDuyV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test log attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 io/inject.c           | 1 +
 libxfs/defer_item.c   | 6 ++++++
 libxfs/xfs_errortag.h | 4 +++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index b8b0977e139e..43b51db5b9cc 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -58,6 +58,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents" },
 		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
+		{ XFS_ERRTAG_LARP,			"larp" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 594f5e92e668..5392a1bcb961 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -131,6 +131,11 @@ xfs_trans_attr_finish_update(
 					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
 	int				error;
 
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
+		error = -EIO;
+		goto out;
+	}
+
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		error = xfs_attr_set_iter(dac);
@@ -144,6 +149,7 @@ xfs_trans_attr_finish_update(
 		break;
 	}
 
+out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index a23a52e643ad..c15d2340220c 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -59,7 +59,8 @@
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
-#define XFS_ERRTAG_MAX					39
+#define XFS_ERRTAG_LARP					39
+#define XFS_ERRTAG_MAX					40
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -103,5 +104,6 @@
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
+#define XFS_RANDOM_LARP					1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

