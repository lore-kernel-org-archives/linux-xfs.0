Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6F6C43219
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245251AbiCWVJN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344877AbiCWVJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:09:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A528EB4D
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:07:29 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NKYRLN007704
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=Fk5gWWpFoH1MXDV+EGU4PgQkp/9UJaE4Z6KlJD6Biek=;
 b=imFpgmIuHklaJRzrVGE9vl6KwsxRplxaTNUoYC49FfDEWA6+5RQYeoXhwnLtTeS+4l/u
 zSloP31OTWfEWxyFshfx8LsRlmgdI66Bj0pv05zlHKXcRy2wOS8mCro6AVGrGklnoXii
 iG7CD/JyKa8VNXkjgOuEIUGaZUPBc9MAPV8z+jCV1lrzzcov5HjNbHHUb+Z4q7ny9SDA
 SESrgcPR3j3N/Uv+Kj1K85tjr0UWReJNDFkywBwJnJDSbRgBbKmk9901aHF+12TReybd
 VzoJLsT58CsCcFBAplpTUAuj0rKxICyHNtmt8Jw7LmB3hScxp+t2RvL33xmRKkQ7CA8t GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qtawtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22NL6R9l154749
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 3ew701q88e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 21:07:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIaXG6GuSzn00tTFSvryAx4KEPw88EwfbR6dP8N4BIhM/P5reAc064xJCuENeJRbaOxtfJAB+k2tGp504o7iGvB7Mxkmmj0lWOLNkKU0MseoG7412EG/ZNFo0BT2RlouTCwwf2+DHMfclg4LbbOpl6Qln2eXPywZdbRQ51GWVE9wrtfMOiLcIEHEpDJfk7Qfx4hzs4rRQg4Pvs2/s2TbG9xSPMTnBuJFVz1wAYai30Gp4INrwkL4RnyZlwhTRR4OJyDAMqNcd6E1o0BvmtYbBHNS0x2r4bRN5SYseYlbIG1gyPfR63Joo663ga9L929iv4FYnv0M63Jn+aBV7vAf9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fk5gWWpFoH1MXDV+EGU4PgQkp/9UJaE4Z6KlJD6Biek=;
 b=MAyeG+wfLtcnv1FAVv6wOkyvcBPQjNmvwwi95Herg6jXvu6E9p0SruYcnFRB1TX02U3k7s5UBAjRXYeZWuxllb3jZ+U6eneiKSDEA+fWZcPwVY76S+TYur8I6N0JxQeb+dDrQotJgfSTvRnT9d7XtXkXQ5CdLHh5AmN5enFov0Cm99R070E9XbuUnwGKfzWIY1a/r6DWSakqqo1rq8O1w5hvk+DHXgG0PS8uZIpS8DFquUzQON6lPh3aS8+xVE2zx4UZQYgfOMmcB788ZHVaFD/25hnyNH5Xu2B6yHC6f/+z2snqhPVK36P/rTssbpkQfQ3XnxLSaNCCSlKb8+c6xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fk5gWWpFoH1MXDV+EGU4PgQkp/9UJaE4Z6KlJD6Biek=;
 b=NCdw0FMnysXlJwhzy/7zUHtDox2/x2I8p8LMG2vOJIoajAomRX2kjTzaZfxHDKd8BqzY2TFil0ZPIIcYeH4H1YXXyms6sCR5Q1aM2jwZIp9RamFp18WsmCanHgJ1ZqNgzeEiPog7oSynzJkt4qNO7+c+/6ZMXPeICiAufGT8mEg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5600.namprd10.prod.outlook.com (2603:10b6:a03:3dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Wed, 23 Mar
 2022 21:07:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 21:07:26 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v29 09/15] xfs: Add log attribute error tag
Date:   Wed, 23 Mar 2022 14:07:09 -0700
Message-Id: <20220323210715.201009-10-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: a57d360c-1440-47d3-3000-08da0d1121cd
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5600:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5600071C1432E20415BC6EC095189@SJ0PR10MB5600.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ib3Q+AtOvQPljZSkQoKrkVc+o+r3Leq07b5zriwiaXm/qGYUtbEJIQXZcf27bNAbXJ1bGWMAtplM+qIYxWllSx9CLiG9niloIOUWkrOAlAhI/yCX6ddRJLvZ81mMd+yMjTpUwGUWuZM0LCS1L5JNqrUJ5on2ZNMUXE04vyli6KoJPlFaURWHbhGvNTRX+9l4ExrFOxi0DJcvw009EcOhAM4MRMBI0HGfqTTUYHwFn02qxBGkvJUs/X+PHmiyocJzElvD5yCifKLhX0SXr5gMJ32mT9UeWdZdhDOekOZf3wphPRc2fsatX03M1j7kMuKXexxJAXOV+X2VK597h58BCivIIgCDrWSFcSZPhYngPWlM8moxzwX6mEnCoi1FS2qXbJnoacIAJgqhjvRhBt674wFTjKngCIe5ocNuf/i881bMnQlc9ObMSrh+LrwphBeOk2nR3hL8wMf41DmwNHTeQYqxkvGy5hWZcL3XMiYUDv2OJ+fH5Emil0r+Jn6NG09FFefFmhV8EX6AgTLfBoqP3Ac62f9m4N5gOr3dJb6qyWSEVhZMA3OWqWI50wYaKqDzWgLC2TmtCWhUh3Q30z+anQdTCMWMur5NWNuPhfBNOqNxbFQXIrDmZqQBkFxysQeToC31DrlN1/fQJgSRptx/NjQ4uFZmJ1SAO9Ct235J7LLejw/09dVQTNWLVFIht7Pw7OCeH4PeDSmgkeTq5+cELg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66476007)(66946007)(44832011)(8676002)(6512007)(83380400001)(86362001)(52116002)(6486002)(6506007)(508600001)(6666004)(2906002)(6916009)(2616005)(36756003)(316002)(5660300002)(1076003)(186003)(8936002)(26005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SrZoRsomfgI9JL+jkPtUxrFfnTZejhPZSuW0vkg3dNbbaNZeTEZGsREtPQaq?=
 =?us-ascii?Q?M1RAGTrqjFvWQUaWu577E8UqokVe2bqsldqA+a6VM8RdhA7upmcL+QFPKX9D?=
 =?us-ascii?Q?RdDEuS30OoQqS43/emQHCytzYQwJ0nmWJhhLgzc6LiD3eljpFl1E3jZOrJth?=
 =?us-ascii?Q?49sIYrcKGaRfsftAZegpcGix7/soX1+NO9rTSJ56b+ugGIDx91BMvLuTcNjX?=
 =?us-ascii?Q?3Gfgtfg5x0Lie3rVX9n4PhQDCt7GL2kEw5/OSs6iyU+Zb5nhAWmZdIsAiB5w?=
 =?us-ascii?Q?iXdT3ITfK9jyZtuuZMhK7YwUSHTadFMIMfGRYH/0nFYiLejYMYL9ZZ9QDbGg?=
 =?us-ascii?Q?ZtpoZ1PZYW6do6Njsczogp3SgWfnh8QYXnYlKuxf71PT02z5pVMAnnsGu18u?=
 =?us-ascii?Q?lsqgDg/85tzv5at57V25mDfDv/W+h3FLfj2i68FFQtA8Pv4NoDbevR38v2cD?=
 =?us-ascii?Q?i+cyYTEohO4lAw+nLn9DSJC3h6v99eERkc0ZrAmYSFI495cFNUBDl2N+dn/K?=
 =?us-ascii?Q?Mi4xzNu0ISFuVs3ZVyT/u6KBIrJG66PHYZTVZRmSu3gVGnINXatMgamueA+H?=
 =?us-ascii?Q?GR9G+3dmP2urqKZ+905CHPX3bcaJ+q8ZZqQ/griKrWuGlF+o1sJsJLtUGos6?=
 =?us-ascii?Q?+TA4R2A2ILlb2kAZydJ5QqU5pYIkdxvocD5hmSdx11lrrOoBW/N2MnWS8A+R?=
 =?us-ascii?Q?I/5RxiR4aB8fREhiqb3fJIU/y7XoAF9P35DwkXeXe3zb/+fUUh7sKqKN4Cn7?=
 =?us-ascii?Q?SIg8qq51+J+eflNsEuXJ2ggUAGulv/bV/FQR1rGtalMHtoYpNxp/HnyolX6K?=
 =?us-ascii?Q?mXBAecxMh4dkhk25Pk1iyMVXD+qY+CYRZyGCb7cuyEnN5jHilufJQiAWloZt?=
 =?us-ascii?Q?8QEGBKZjh/GuIGSf7tebLFEID5gbw0+3T+X9Xr/vK2dKzPijWKtFreDho7rX?=
 =?us-ascii?Q?ol3SEii42QkEnNqsmKBGy0eB/kQlYYrYH8EdU9/TwI0K2XtYvs57xpb8/Wbh?=
 =?us-ascii?Q?HxftY03lbsTsD/80+ZvmP+XLaoMLDMVfpVIxsyYVXUiXufRSVmuxNYB7B958?=
 =?us-ascii?Q?TsNTwGY3myb9Z4jY1wKJYvMMMWiqIqpTmB6B2mvD3j/SsrLRVkH9CYAgyLVw?=
 =?us-ascii?Q?nfwcTfvkxp6676UobKI2u2bXtZXjPcfD1p9qSuWEKc+v1x+oC2hSImDIbGkf?=
 =?us-ascii?Q?bsshDaq03GRm0wXDuOkRovTNfCFGpoSAbNKY3dYRjGtXu3PGcCIDdisvG8yx?=
 =?us-ascii?Q?qU6YU7aKpZGfwBFpk7SkEOMM8zVGj+cjF0mzON+HdscXMEU2g0sFbHqPpN/2?=
 =?us-ascii?Q?dj1mBmlRlhDOymek67a+VP2hhU+6AzkQXhWt7jCHTvyJ5b5Q3rY37/3+nunz?=
 =?us-ascii?Q?OaeYMO3lC7FpojNm1vUeqgsnTaRrEool2UYj4qzZ15LReqBeIGJYhkN2i5Aw?=
 =?us-ascii?Q?jT4aTIAm+rO1pvpp4/tix/eZUgLYKT8nb8r0eQ5RXGvUIEz+TWzutQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a57d360c-1440-47d3-3000-08da0d1121cd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 21:07:26.0452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AbfMsOOfjGFOjLkcklokS5X68AsgRCtlZ3f71pnuW9laOcbun0OGZI+vZ0u8Hu3egSiBSDyAMQ3LOKwMcZbfHBJDNG+0wMk9Y/xL3lNSRH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5600
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230111
X-Proofpoint-GUID: Q4Pd4X3f1FYTf39LSuQ-7lKwHueDWAgZ
X-Proofpoint-ORIG-GUID: Q4Pd4X3f1FYTf39LSuQ-7lKwHueDWAgZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test log attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_attr_item.c       | 7 +++++++
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index a23a52e643ad..c15d2340220c 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
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
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index e10202c4e299..5255d0550078 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -24,6 +24,7 @@
 #include "xfs_trace.h"
 #include "xfs_inode.h"
 #include "xfs_trans_space.h"
+#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
@@ -303,6 +304,11 @@ xfs_xattri_finish_update(
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
@@ -316,6 +322,7 @@ xfs_xattri_finish_update(
 		break;
 	}
 
+out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 749fd18c4f32..666f4837b1e1 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -57,6 +57,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
+	XFS_RANDOM_LARP,
 };
 
 struct xfs_errortag_attr {
@@ -170,6 +171,7 @@ XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
+XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -211,6 +213,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
+	XFS_ERRORTAG_ATTR_LIST(larp),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.25.1

