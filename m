Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D63BC636D4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBIIC2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBIICU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:20 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10481352E
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:18 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197ProD016215
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=xbFkwo+zBUSz7MXZmDpmql+4vIa04RNqs3jayeN8qfwS9TnxhhtIqGAZgfbdOFlg1cpz
 3BM+4AexM4U/kWHojlcogORaC4u6h3JVLmgo1c0AHBhx8JJ29ASB2NG1zqnpYcgqZZ2w
 Cbnf8NdMXzdgpZqkm9bR2IGxMms6rFFNhWqtYXJa6vkITs6/d1ZBlbGuotl+qE7DjJzA
 /bFAZzOL0FLDRqz3IVMCtUgdfFVLw/tuJiEbn8bmMesgxzEgewEHP/llwkOB2ELfBRVP
 pABNQYAE0B+en6gTQBSHnD+tIe1Zf50i4Hsge2zErY7McnOVdMVkeX927XOlBPivR1Vu 9g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe9nj4du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196eBvH021294
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dv71-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fpu66uOXbJQn4eZexV5bPmNJh3G34Feu1FOXJxjVYX0ZngwFNc2s5P6PgQ+3oNaso5FeGsumFb2zYDwUg1gzNhEp4cVbQqwd4SZ0ECETGLr+djqdPmIle4+5Kp7z+eXW+LARv+g+BQ339iicvjQZ27KgWsA5tQOEvup77zQ+RZbU16RedjAbmpmp9wKS+I31Pt41hTBiIIi7PenFChCVSlsrtYuWSox66HuH6a4ubYobIk9wwoBUWKIOvd3YsKDjUjVfLqD5zowDL93v5cwqDhFENMFFUHX0/PsQWoRWw3ErwK87t4wWPT007HvkAP+D/jRdXQlxWHdi0H2NDxXyqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=gdgH22st9VCNkAR7KKadWhuz7YAzcLnjOOKMt64R6p1B4595mmJQNX9b5k+UBvVm55zNiDVFX7NZnPzwfHS+K08XU/euWaBOvfs0mvXAVDYQDSov+zXb/CyYqBQ5hT1baipvzADVAUtc4nWTte+tqBL4p4dGMUujOUbzSRDmk7st00uiP99n5AwthNq33TjfgE+P1DyrUhhSftbT+WliWSy+wGhzveyErObyuYgxbWd4kL9DNRCqQuOSAR+Ke5/2e2UE58idMSHZER0OMAtC41ighkVEsWgURgDg9w+7eZkmAkt7HoIlDJ8lFwGdiT2ttgrDlj+uaoi6ZkG5R/Ylhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tYSEWWb1wiKYWw2+XP6sFmWvJlNNBn4jDtZsPv6VNo=;
 b=cAidFhvzGxosuRIcwFQXap93/R2QB6h4u1rmtUKwe61NVsH2rlI6WLTfyVu1lSVthQcYP3QhBwluG3qTXcVVG1BcJYiDDGcFEedKpxS/MsM+ddfEfkyXQH0vC5fn3V0ZAvXSzUX6ztVZuHOEKUkV5aFiTflfpdt3k92K1w6eqc4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:13 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 14/28] xfs: extend transaction reservations for parent attributes
Date:   Thu,  9 Feb 2023 01:01:32 -0700
Message-Id: <20230209080146.378973-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 12cc31cb-6b14-4082-f2e4-08db0a73f398
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1t9T4CCI2MgBXJZCSTdjPe2r3qraehg5cw7lKv5dM+ZAKwAQpIwKdsudVlR2QQIWRlBVR7tiKT2vw9x3I2Tqu8fPJM6UvKfl/enFcbs8pypyxP48V9rvdozDjPFi7dRqehJy568EVumU8qROQSIQhpqWuaf4zn10KqryYqsc2X+xPzRR6g65e7MFsaASHtgKBdj5zlM/EuBm9pzy7NrR7H9pIAtyIz0L7gZG8M76woomWiT6LLyD5WrQQ5oQ/+5eVnycIzOyn8a6obRVoKjB0UmfZXob0nxLY+Yb8ltRjwEtBrcRjo3v0XGPec890jZ1WBGvHhlo/deAY5eGiydKKYIx85f+xsUeZAG6tdYJT6fj8LxUpnzuP8oHIk+keseGBYsPsjZbp1M1zoomNZE1TU0zU3m1UWcCsZw5vMLosARkRhTDtNLjiEd22WXs3oYJx8nJDw5Xq2vgyJiVZ2EnaXO+qvNGG7e8EHauW/nRt2thZRtnUd2RY3f5awFj7r8ctXec8b+LU3E62RKrURlzPrez6K41Zibb7FFB10n+ZDj7N91MOFmrKJMihKFUYfpKLo/aGU2DMSsWg6UZVIaxxmkKetweK8sSCXehcTcrnKGw4GywwrqatE1vFfffoe6C+hsYHpyFUFukRTgdVuZSeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(30864003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MCiWva96aPnc0szPjVxJurEdaaKoqjb7/2TE1Ic01eJ/MJEAeBk2Ca8H8IrF?=
 =?us-ascii?Q?y9wpog4p9xW92JYz0GVnXnWf9ySVf1QlSLpmt0C+cYdOby8DFsY+9iNxp8OW?=
 =?us-ascii?Q?Lp6DDIwO3Efp1Ksw8kp0OGKN8kP3GU10mqhU8u92iwijqCACnlZ1ALCDP++C?=
 =?us-ascii?Q?ec9Tb7hvdMJoSNO858tQFCIJ6bLJdfI1CCb9oNnBwG08pxPmftiGS5yISjhy?=
 =?us-ascii?Q?VZiLoLs3BQXiLNiZxTpNVMGgzyf15RIss8MfUr6O5RNMB3vybvwIjP5i3lfE?=
 =?us-ascii?Q?wSQ9dGmr3gb+yQUf2tFMg881cfQ6cmBHBat5HNAPgas8yZd74ksnZGjnGLev?=
 =?us-ascii?Q?BO40LA5lXeKnfKeO7KVTKruAlr8i0j/Gd7bqDsPernWzph3I6XXfavxCnSWM?=
 =?us-ascii?Q?ngPfpu2T0syQYSlvA2XS8DsW1H1s7T8kR8r5HRa+ahvzfA9G7Vv3vbUn2poU?=
 =?us-ascii?Q?gKJOKC7BcrRFDKzn//6M6yHzK8AyrwsiSoqZYsfuhX4xCAGE6mB+BjiMNxAw?=
 =?us-ascii?Q?850WMO1ATybjYzqwxKaMUsAZma/v7Z2tLiYZEFSQEKcC+alW/1nMJvsegWwa?=
 =?us-ascii?Q?9Mb8qzua+XcJvUQZN8zoXlU4poy2a/FKKedVZTAf+0oIsM9eAlTvFIyYQ1m3?=
 =?us-ascii?Q?IRuqBVEx5T7sG+5M3o9uS92qxzGfrno7ZqJ0pY7JMym8w3bT4yReVGOQBO54?=
 =?us-ascii?Q?MsKYW5gQWApBUgC6/YWU2mkcS9A+oPVmzTEowofAiQEeFvllODHHXlcNBPHs?=
 =?us-ascii?Q?mOFs2cK4y6cQFQU3LcWPCgnA+DJD2uPzXglyEUWM6sv2u4bAW1VTwyNhT483?=
 =?us-ascii?Q?siEQopGN4ptVPxQSnUt0QPdT6uLmyRxKgS0PGPT6KEWGRW0eexOJ09DBTPSb?=
 =?us-ascii?Q?REdy2C4JWPQkaWo1L5MVY0E8oNVa8U+5rNiJGsdP48QtZJhDPUNiw9jYpENi?=
 =?us-ascii?Q?eynKU5NJ8Z3z62gmQZODnXy21Hwm0fxNmkBWxsTlcY9sMIZQtwYX+ykXrDwk?=
 =?us-ascii?Q?y3fLDh562WY3tWLdsg92MUuK8knOtKN341w+JjuNol7+0urvPgr5Z2CDC5jw?=
 =?us-ascii?Q?hrrnbigYtZfM+Db3idNG9pLPwkOAjgQsvtj5RGhbqBukGCzcBZKWeHVc5huI?=
 =?us-ascii?Q?eUsXMs5f54kOx/nr43E7NVlU4H1P1f/gqnuD3zNqaKPuD6T+KVWvkXOvI10N?=
 =?us-ascii?Q?ihBRmrTyMCMO4Ys7GUAJIBHwwaWkFpWaK1egegnQ95mjhTT8qB3N4Ez6ituY?=
 =?us-ascii?Q?OduSYEoG+uZSBjBPP/MDreo3DBrI99iiCJPAb5bOFGw+YZKlKkUIHE8GluRS?=
 =?us-ascii?Q?mbEELgBylZdzbNpT6bfq9vxq+46x/DVDCW26fktcV7/1UZZZwkq01MjcqIqk?=
 =?us-ascii?Q?B9q0yhDmXohf6OIpSo/dx9do41j+MuLucxahjTPTVeb5G3NdZeSglNM8+apG?=
 =?us-ascii?Q?Gws2Rb93QPt/BD5SlViLIt/bn00gac5QMNQZmIN8FWeluORmglAUo4omu/FD?=
 =?us-ascii?Q?fxnFw3iSWx7vpenBdaP+hTrJUAOKTVvebSYUCPCF3ZhWONm8dt25vUAc3+Gr?=
 =?us-ascii?Q?TWvfip94OBaQQyvzed1D+ztWOI0JkT2q8mAwGgMXMipxYzGoZy7dZtmpHX5z?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NiSDBsRETpaRkI/bbxV+knyTtoapZTrvsoS5YNTd19mezin1FeqyuQ+rufn66syH/yA3Tm/dVS3+ZHLJ+sk/T72f6FWfJNLVJYLfQTE5oJsT2ztzr6lTEfNzfzVR23FxSL0ZnbHi5/2YXa92t0B73T1tpV8cLao7iVvateKB7M1q00XD6xeUaNoIB23EwlA5OI8OX3L/Wcn1yeZNbfj9PVdHXh/zlRIQPjL45U4ZHccigZ+NW7g0dfxzb45/d5WUEORIvRpIXGpgVwsynhmxMxGmwZiWBt58JtiGOcbUe2QOy15vTIwOlW52A2pDYRuwSdmOThAIqgWHz94CaaqY1DEzV42F7YheOzi3g73To9nPpdLttKN2UBWGNusNUew4dU738fVQXyaFERQGLxAGUl5FLoxRmMIA5vY7Z37s48tOT+Vvk/XeqOokglQ2BWyUoiO4EgsQ+Opbm0VM00uLu1EabZYB8Trug/px52Ap03rayeH2N9aNiXFZumdTpx7LLI90D/a+SAUOvgM2DHOLryB0CSAz3fq/lU5txL161FkzimFWE4qIrsiLc4O0J7Ahu/Jo0TaKpcu70hKQEfJe3jabyMIuQA1YliWriuE5bLfiMAvjaCSxSLz7ySimogHzdmIfdbekNu+LJCgrbvUk5H149f+OAcPTCOdUAPgjC2IV2DLaIoznRGOt9329t2S/eyiCiCvmgUQ5gk40rz4GUpfZKZN307KPFVpUhAWUhfOLj+/kBHuid+piEuRglSnK
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12cc31cb-6b14-4082-f2e4-08db0a73f398
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:12.9804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0bWo4JkOZ9SkCN+R+u7kZ7hppVeZpWCto70PVRG8JHXcpABC+0iFpR3H0FjE0xCl2kNXZUUWsgVYN9rLM/EZk35cOgM6YFglQCx5qi3vr2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: 2RZCLRKJRKhIveypMEc1X1jeat1lz04b
X-Proofpoint-GUID: 2RZCLRKJRKhIveypMEc1X1jeat1lz04b
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to add, remove or modify parent pointer attributes during
create/link/unlink/rename operations atomically with the dirents in the
parent directories being modified. This means they need to be modified
in the same transaction as the parent directories, and so we need to add
the required space for the attribute modifications to the transaction
reservations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 324 +++++++++++++++++++++++++++------
 1 file changed, 272 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5b2f27cbdb80..93419956b9e5 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -19,6 +19,9 @@
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_trans_space.h"
+#include "xfs_attr_item.h"
+#include "xfs_log.h"
+#include "xfs_da_format.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -420,29 +423,108 @@ xfs_calc_itruncate_reservation_minlogsize(
 	return xfs_calc_itruncate_reservation(mp, true);
 }
 
+static inline unsigned int xfs_calc_pptr_link_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+static inline unsigned int xfs_calc_pptr_unlink_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+static inline unsigned int xfs_calc_pptr_replace_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+}
+
 /*
  * In renaming a files we can modify:
  *    the five inodes involved: 5 * inode size
  *    the two directory btrees: 2 * (max depth + v2) * dir block size
  *    the two directory bmap btrees: 2 * max depth * block size
  * And the bmap_finish transaction can free dir and bmap blocks (two sets
- *	of bmap blocks) giving:
+ *	of bmap blocks) giving (t2):
  *    the agf for the ags in which the blocks live: 3 * sector size
  *    the agfl for the ags in which the blocks live: 3 * sector size
  *    the superblock for the free block count: sector size
  *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
+ * If parent pointers are enabled (t3), then each transaction in the chain
+ *    must be capable of setting or removing the extended attribute
+ *    containing the parent information.  It must also be able to handle
+ *    the three xattr intent items that track the progress of the parent
+ *    pointer update.
  */
 STATIC uint
 xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max((xfs_calc_inode_res(mp, 5) +
-		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv	*resp = M_RES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_inode_res(mp, 5) +
+	     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
+			XFS_FSB_TO_B(mp, 1));
+
+	t2 = xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
+			XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		unsigned int	rename_overhead, exchange_overhead;
+
+		t3 = max(resp->tr_attrsetm.tr_logres,
+			 resp->tr_attrrm.tr_logres);
+
+		/*
+		 * For a standard rename, the three xattr intent log items
+		 * are (1) replacing the pptr for the source file; (2)
+		 * removing the pptr on the dest file; and (3) adding a
+		 * pptr for the whiteout file in the src dir.
+		 *
+		 * For an RENAME_EXCHANGE, there are two xattr intent
+		 * items to replace the pptr for both src and dest
+		 * files.  Link counts don't change and there is no
+		 * whiteout.
+		 *
+		 * In the worst case we can end up relogging all log
+		 * intent items to allow the log tail to move ahead, so
+		 * they become overhead added to each transaction in a
+		 * processing chain.
+		 */
+		rename_overhead = xfs_calc_pptr_replace_overhead() +
+				  xfs_calc_pptr_unlink_overhead() +
+				  xfs_calc_pptr_link_overhead();
+		exchange_overhead = 2 * xfs_calc_pptr_replace_overhead();
+
+		overhead += max(rename_overhead, exchange_overhead);
+	}
+
+	return overhead + max3(t1, t2, t3);
+}
+
+static inline unsigned int
+xfs_rename_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	/* One for the rename, one more for freeing blocks */
+	unsigned int		ret = XFS_RENAME_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to remove or add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += max(resp->tr_attrsetm.tr_logcount,
+			   resp->tr_attrrm.tr_logcount);
+
+	return ret;
 }
 
 /*
@@ -459,6 +541,23 @@ xfs_calc_iunlink_remove_reservation(
 	       2 * M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_link_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_LINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For creating a link to an inode:
  *    the parent directory inode: inode size
@@ -475,14 +574,23 @@ STATIC uint
 xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_remove_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int            t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_remove_reservation(mp);
+	t1 = xfs_calc_inode_res(mp, 2) +
+	       xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -497,6 +605,23 @@ xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
 			M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_remove_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_REMOVE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrrm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For removing a directory entry we can modify:
  *    the parent directory inode: inode size
@@ -513,14 +638,24 @@ STATIC uint
 xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_add_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int            t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_add_reservation(mp);
+
+	t1 = xfs_calc_inode_res(mp, 2) +
+	     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrrm.tr_logres;
+		overhead += xfs_calc_pptr_unlink_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -569,12 +704,40 @@ xfs_calc_icreate_resv_alloc(
 		xfs_calc_finobt_res(mp);
 }
 
+static inline unsigned int
+xfs_icreate_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_CREATE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 STATIC uint
-xfs_calc_icreate_reservation(xfs_mount_t *mp)
+xfs_calc_icreate_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max(xfs_calc_icreate_resv_alloc(mp),
-		    xfs_calc_create_resv_modify(mp));
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_icreate_resv_alloc(mp);
+	t2 = xfs_calc_create_resv_modify(mp);
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 STATIC uint
@@ -587,6 +750,23 @@ xfs_calc_create_tmpfile_reservation(
 	return res + xfs_calc_iunlink_add_reservation(mp);
 }
 
+static inline unsigned int
+xfs_mkdir_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_MKDIR_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * Making a new directory is the same as creating a new file.
  */
@@ -597,6 +777,22 @@ xfs_calc_mkdir_reservation(
 	return xfs_calc_icreate_reservation(mp);
 }
 
+static inline unsigned int
+xfs_symlink_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_SYMLINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
 
 /*
  * Making a new symplink is the same as creating a new file, but
@@ -909,54 +1105,76 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
-void
-xfs_trans_resv_calc(
+/*
+ * Namespace reservations.
+ *
+ * These get tricky when parent pointers are enabled as we have attribute
+ * modifications occurring from within these transactions. Rather than confuse
+ * each of these reservation calculations with the conditional attribute
+ * reservations, add them here in a clear and concise manner. This requires that
+ * the attribute reservations have already been calculated.
+ *
+ * Note that we only include the static attribute reservation here; the runtime
+ * reservation will have to be modified by the size of the attributes being
+ * added/removed/modified. See the comments on the attribute reservation
+ * calculations for more details.
+ */
+STATIC void
+xfs_calc_namespace_reservations(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
-	int			logcount_adj = 0;
-
-	/*
-	 * The following transactions are logged in physical format and
-	 * require a permanent reservation on space.
-	 */
-	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
-	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
-	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
-	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
-	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	ASSERT(resp->tr_attrsetm.tr_logres > 0);
 
 	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
-	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
+	resp->tr_rename.tr_logcount = xfs_rename_log_count(mp, resp);
 	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
-	resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
+	resp->tr_link.tr_logcount = xfs_link_log_count(mp, resp);
 	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
-	resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
+	resp->tr_remove.tr_logcount = xfs_remove_log_count(mp, resp);
 	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
-	resp->tr_symlink.tr_logcount = XFS_SYMLINK_LOG_COUNT;
+	resp->tr_symlink.tr_logcount = xfs_symlink_log_count(mp, resp);
 	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp);
-	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
+	resp->tr_create.tr_logcount = xfs_icreate_log_count(mp, resp);
 	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logcount = xfs_mkdir_log_count(mp, resp);
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+}
+
+void
+xfs_trans_resv_calc(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	int			logcount_adj = 0;
+
+	/*
+	 * The following transactions are logged in physical format and
+	 * require a permanent reservation on space.
+	 */
+	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
+	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
+	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
+	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
+	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	resp->tr_create_tmpfile.tr_logres =
 			xfs_calc_create_tmpfile_reservation(mp);
 	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
 	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
-	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
-	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
 	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
 	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
 	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
@@ -986,6 +1204,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.
-- 
2.25.1

