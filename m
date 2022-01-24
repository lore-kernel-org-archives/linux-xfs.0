Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501FEC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbiAXF12 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:28 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38956 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239492AbiAXF1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:25 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20NLrdwN006335
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=e/gUDsOrz75ZNYNmXMahMlupVkhhNI2vJ/91sx7pCIg=;
 b=er4+IqA5fSpJBGxn3izy4lom+/81SNv67+zarWQHE1Yg6RUSggwHdVrSe5fbbadmQr3d
 phGnCavLO/Ik7d5YEEOaR7PrkdrvQbWn5luQcqWAElsPIGTV5xGrYMXowzjRz0DF35nX
 h1/gyCW6lGy9sEawFG/jToQJqVJTrmoA4KQeYhsf4soM3pO+r6B0KRxb1/b1q/ZUyqXQ
 te6dZPbT3l/fP/0Lvj08XCDhSW/8yZlz5W7Yag0RaM8AwXU3kWcqXEQOVDhzCgfch0kg
 VGnpfnrFyDqiwUriN1/x7RPKnAsvZbSTVYvTcp1mU4cnFbwz/n4cJTAqvhUqyN5XDdgd NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dr9hsk339-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5REW8139905
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3030.oracle.com with ESMTP id 3dr7yd4xn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dT1L2CpIUrOhilYDANSy5GM3WGB4UxHmzKk5DoOoxiudpIoYCiwVzJrWnarCPvAZJB93h3j2g3egXpFy4KZdHPX1up91MBTyAK98fkR9JHJ4o/zV8L6wevL2/BU10VtlK/3RBE1SvgN4ETlXg2hshBr1AxBYfYjexruASMjJN84AGB3Uftl0hhZswREr8apH3V3uf9lSjndOny/aJfFmpG1TMhfNOHiHDjkGhvF2GrPMAub9HAc9rvFDocdZvMrBUE1cM+x6u6Ii2pZs4ETyN+t2iUXy1y1hi6Igb39DfNuRvaVSzjg/w20Y6FK6xWHIyuXBbHbaGXCZ7t9jF7G5xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e/gUDsOrz75ZNYNmXMahMlupVkhhNI2vJ/91sx7pCIg=;
 b=TIRSN9sup3wFal95bKe+Nuqlt3EMzc/zhLsRcizDVzpyht5tU1Iyk5Zm4c8FOx6Ih+Ul4E76iGLAR6JIJqn+VRiZlav/QnaJwNKdPokpoahhZ3IzXz6B2oC+TxIXEahlzVgpaZEM/PmxyMfc/uljo4xlqFzdMODu562pQp0IXY4zaTu9gf+lmylbITvEKexhHyUwFfKaRMq/cAzPXIhWzB+iBHYj1JGhY5eaxPmsp9QgWLhfTiKAXa4MDuKYesoxxIX9opNx3tsS7kRNqLQVoEyDnemGbptdNCZvlbCT9OIsY2RFoB5H5BOZfglR/2B+yDXSSf+H49bVjmNbBP+XPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/gUDsOrz75ZNYNmXMahMlupVkhhNI2vJ/91sx7pCIg=;
 b=WGxYW0xLYgW+A31WPGMy8eKlA45Pml3Qm5YPCS/BNBrA2YiHvmApK3AHl5Kwsda0tZE6rW7xgLDnvOzY2BFgo8cbr5MO3ZyYEaydMkrFL/dgzAwC1jwvl5F489a+PK1zNERCosGqY8VFkGgqCE3XzmoNDLoFiMy5TatPcgPG+w4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB4821.namprd10.prod.outlook.com (2603:10b6:408:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 24 Jan
 2022 05:27:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:21 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 09/12] xfs: Add log attribute error tag
Date:   Sun, 23 Jan 2022 22:27:05 -0700
Message-Id: <20220124052708.580016-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124052708.580016-1-allison.henderson@oracle.com>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e2b271e-5e05-4f5f-f4c2-08d9defa3048
X-MS-TrafficTypeDiagnostic: BN0PR10MB4821:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB4821F18471C39C42A4CE42F5955E9@BN0PR10MB4821.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1eIU0y0JuhLhqZbbo/MsKgueq4l12o374nl0t2dn/YJk1GcBucM5/J5HHDlnKheDnptBoQs1boLNTwPWbbYnXnXX6QP/ecQ2LrMWjwM/SBHBY2C/DTnAy2+DR2Cyv7tOSnEFLVo1XqBxke7kJ+uoDqWDKfc0Lpc82xVbpZkDq3iTfiEAp8Ad6qJQeNtKAB0z/Qi14qtOlPRrdBHCtJYr3HyBmccqYhbK7aRvElOKxCL6hPed5Rxd1V0223BJFdTYIopDCEGA6Z+Qm2calMAc49dbDAl+8kxX7uujuhA/n0Pd0U8qYi+YtKI4K7LWZIf3Rl8vLPZ7V3zYr0ZQnnt/RFY2/tTXmnqMAgbmGj1jIEcLdGDELOH7GgB9retHDZgA2umpINg26zmlKjto71AHVdAVKu7sO8VhQxnyo5lolgbg5jItmeBQAw0S2euScj2JG/0dH0LRJpP0IOnnl3Gp4o+Dpje32lhrDqovPrrFrKcWxxNbwJ7IoeT1QX7YuFV9dW1d+qCbT2sJwnLrqd8C2g1wSGSpOMNsMRBBbEm9AsSMtaATdYY+JiM4AKz9G2644MbW8LiuWgMQhztB2qns5k8QESu3EOAUbNcMA9xkIIhEZkqrnbOGU8ul053/ayGQN12Y/WzRWQgdLnwrFn4s4YsIOJZxcq82FolKkSXpBAmp6t5nvviKYYUI/eVjazBu+w7Kn3RVuZZAFzS1xtoQmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(186003)(6666004)(52116002)(6512007)(2616005)(83380400001)(66946007)(66476007)(66556008)(38100700002)(5660300002)(26005)(2906002)(36756003)(86362001)(6486002)(1076003)(38350700002)(316002)(44832011)(508600001)(6506007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8KwSUK6hQBiYyqADc5zQtF7LfAqUuD5xzIw3n2Dn1v+9zy2wDfSWPBs/rQia?=
 =?us-ascii?Q?W3enzVEeN+dryEHl5cAvDIGZbO3ObhE96zESDq8CSuFrjNIfskOkqtQ/+jbw?=
 =?us-ascii?Q?x0jEOPKqxbMF7otb4+XhFhW5uKY84xf/+xVdofry26YsS04f474D2R4sEkXd?=
 =?us-ascii?Q?IKM+1af43b/RdwzfFeiSzBuPwsK+MFy7kap/kLmzycaP+JJYEFrXPW0obc+/?=
 =?us-ascii?Q?tNdtTNHzJLQvyNean4/d/pnzRc0wdjlffMhSANbiF2DB7zA4C+4Un9iCV4Hd?=
 =?us-ascii?Q?PEZcqkq9hEsVMYM9nXlgOjwa8/TPfoxZBBzFOA67rhg0d+WS9P64wdKBYLlC?=
 =?us-ascii?Q?LjTWJHcGpjtps74DUi2kPoxFe7lu3HM1UI2ZXOTALzRc1J1mEwNfVZ6IQOQf?=
 =?us-ascii?Q?DJ8iouzfkypGhVH2STxm1eNs40Z7AjzH0s6MgAa6SWEhO/DBd2KG5/H/tkmj?=
 =?us-ascii?Q?YmsucG7RgLehRIOZfW4IgnzbveOam6PfTSpdT26ZeZlUmcJHwTr4sHq4eIO1?=
 =?us-ascii?Q?GNZpw5RtdRSUCwRF/a/IoiyZmGHdlJkCuHDWzLTpeh/ZoR+Jg8Yc3wUN3xk2?=
 =?us-ascii?Q?JlECg2Idz47h/J1aTySMJ5R/X3+GK0zA5LZsAZUwzryvw2jpiigGkseaYLMN?=
 =?us-ascii?Q?Kf4TPc6DthZjCw1vB5R2D2Fr06Y/77QDnxSLpVajw5asm7jNp7LOJ91HrQM+?=
 =?us-ascii?Q?VVvq2IlraZBW44FInp9w9FxPDBpd9LRtrR/5e5yxN4CYe3kwMGfWc/A7csnG?=
 =?us-ascii?Q?0PQJOhLydvTLdUTtfawwPyxSFI7BSPLK2Q/NE95IecpKBhEPFDtJsPvd8dA5?=
 =?us-ascii?Q?13J3Ual1FPWEDuE8NDhFNy46yix/2QfNJRaC+A/h+ASFW7RI6meKXFzlEF+3?=
 =?us-ascii?Q?2aOto7XC2LTZoleChkSMNH/Dh0fAsaLu6vsilc89De0Io2O+oZa2pmUJARsH?=
 =?us-ascii?Q?hVFwupkwxS5RKs+x1Z4iT6F+bEX1C3/+8lstZFKs4WBoKGFu0GDhdiw4+hTY?=
 =?us-ascii?Q?dXYPZ/SRwyMgSBP38tqXzXNtNwDRwua4l26ENby+ZueE8dGpS/U1DDvaOBgo?=
 =?us-ascii?Q?lMKKlDyALz9jGtpYKM+P2IfBBPwBSLHpnSA51WCBpEvju5uFEMS39d3Ft3fN?=
 =?us-ascii?Q?CZ+DNqnZaModFKjLI3sNHmsBJYiB7ZqUQgV2447r8PXUzjfqSbCbJP8EAxxV?=
 =?us-ascii?Q?7nnxlDLhUhUNXxgwq/9mVswG3XRRUsPfR3X1F86ib3neqK6trpgNcfDRJ4pN?=
 =?us-ascii?Q?G4fN6jpe3xri9q+d6J1cPKzpPkT94fH+hox8TtxzoDT5GhRJZG3cT53vddR6?=
 =?us-ascii?Q?jo+9DrbKFAmDJhpl4jZgHKcynPsJJAsTg16RIZbKYYaGeLf7fkcCSL/DB28g?=
 =?us-ascii?Q?qYTRuMHSg22LkyNcQsEqxdaVU090uD4+2UD0KpHXno8gZDlmQO7jsQTQbXto?=
 =?us-ascii?Q?O74spYYT/UEqVqNM85qZTsrlwRt/V5SpfdYRFSme4OVF0hw5RK91Ru+oEogc?=
 =?us-ascii?Q?H4gEprvXbBvuMFiC5GeEdpPt7NsAtOOo9uufH/BW+4rtWc1MLTUEPzLjiYdb?=
 =?us-ascii?Q?2F5rlq6A8hmVmhv+06DTGmDlcmIsOyQ+/Tp/nB9k0V6Utq077WoNpA5yYmGt?=
 =?us-ascii?Q?WHwuw7owSimCGWSRAT9CW5pIINvGkuH11s4N1Q1e7RoWIn0YWpAvq1k7+rCk?=
 =?us-ascii?Q?irWnHg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2b271e-5e05-4f5f-f4c2-08d9defa3048
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:18.5881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dW041SqGsMUcs6GuAF6mUSx8r4qgrP9TXk+y/f84NjKSXZeL1njyqcRK50gd6uQgT/MP3jLjTUkjSYpApj5pMN/5z2T20EBBhg7QIx82f0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240036
X-Proofpoint-GUID: 8afPVl3odGToOB_X0Hh89t2aEJPCB6kt
X-Proofpoint-ORIG-GUID: 8afPVl3odGToOB_X0Hh89t2aEJPCB6kt
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
index da6cd88541cb..98d65d7e891c 100644
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
@@ -277,6 +278,11 @@ xfs_xattri_finish_update(
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
@@ -290,6 +296,7 @@ xfs_xattri_finish_update(
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

