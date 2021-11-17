Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB30C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52A5E608FE
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhKQEQ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:16:57 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48318 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233004AbhKQEQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:16:54 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH253b8003491
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=zNBnGl/0UjqgqDWRsjbwCAzkslDA2qAE3hnn1uxjLwE=;
 b=KrwoIbkGfPOx0l8+t3QRk6nqunYuxV0NQdzAVV+4WFMjAjvzENIY8vIlDrKkDg1/6lBB
 UpqGVpLEHYgYFACFVqTXIrbwZth90freiSBYxJLkHS9esgSPbW76DCkoU0MQTZJRb3EK
 AvKN5A24cG5U0B4QcVUvrbhS/IU3hDkhWf5Pcjh6Ilx6sDEhWMbNaBdYl3y6prMojCMj
 a46WrTeC/IcWXTjzh8P/Qz9ItOU0x7c030J1RQSa7tjADkzawQ45XDU2j86ZnE5y7UUA
 aYxv790F4TouHt169e0Kc0080GwHbFRYF7YL1pmkqwhxmlxdYloP3URqmkJCciHlWCe+ HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhv5drkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEJZ180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:55 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3ca2fx68vt-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6y5+w+rZrG947kyY7XjDfNOxHoKCsDMNYphaO6CQZgC2k8wJrCgQFyNIVvRFuDAg9quifkRXSYJGTp+cHBVlL6dw+l3V32CNoMk/j1qASUtB48iNJAtE4yJ10paLC4bBRh2WBbO3g7D86TBw9CwjW+MpXSK82R4Y41B7r24ngCws+TKil3I+Uh0n9glb79d4I/VdDt6ToK1pxRCfejE7oFoKR5MNyUaL/TxDaXgVPEmRIH0Wn1kNx1E68iQeOmXmZLzavKy+PVYbJ9GgTpLl4abVOBc8ujrJEanuN5ANW6FrO4CN++tPFwLqBzVhbQtIwRf2bls+66bY1bwmFVV5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNBnGl/0UjqgqDWRsjbwCAzkslDA2qAE3hnn1uxjLwE=;
 b=jlcYS/5uHFGDW/pU9Ldg2RRGf4i6WvdzwmYpY5atmGwFkz1AuDnpLcxVDxsvZdxtUVsuY7SvBmyw5YBSWiMSacXQOCk220XE3WUqqrpC9QiFxnGXCxFYx7w7TSlhHNhU38dMY8Im+jRrTRtDuQs+aLuw5ylRe3LwxRXjR/lur9nezNZ+Ha/TkZscxfhPApxGqTVlVLBGjYUd+zZ9PA7W2PkUFhERhILzyd7gN4Jh48evHAujtKiKTKgoHvzBSNtUtnTanUdLrLZ/zE5UBL1UoppnaHuhGn+diH42aW2hT1R1ASa3j7ZoKQwcr20Ar9OmwkqoJndJgrQJcfmxgG+YuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNBnGl/0UjqgqDWRsjbwCAzkslDA2qAE3hnn1uxjLwE=;
 b=vOMFKs+flpnG5tNz3yPN9yrBM3o0a3Ts8ZXw1lg46hPRS3zwXzVqXYRiCIRbnKBRzjMwpoRRFUTEpLTWeLToYeH9AEjKMPfaCEEJglLOrbBwlN4vUqiblCD68jq7JOJj51s/N8YwyHDKV+Z+VwPaXgewDbN1oWiqv2h4z0+YLLc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3921.namprd10.prod.outlook.com (2603:10b6:a03:1ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:13:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:13:51 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 09/12] xfs: Add log attribute error tag
Date:   Tue, 16 Nov 2021 21:13:40 -0700
Message-Id: <20211117041343.3050202-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041343.3050202-1-allison.henderson@oracle.com>
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY5PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:1d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 04:13:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1e471bb-cf74-42a1-4f1b-08d9a980a997
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:
X-Microsoft-Antispam-PRVS: <BY5PR10MB39211EBAE8B040CFDBD25DBB959A9@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tvQsF4jIpGQ5pVN2jkwsE/vcLNc5V0OwKbFUngDINPrGU4eye1/NOT6vDpn+8wXp5aJ0HsMTMWZk6qbYXLetHHIMesdkN+EoAgO2zZSx6GKyqwoOh5EFNNK7j55SAVs/Va9Zg4zddkZiLNhEDBDEgOuABONzS/DABq/vpf7LMaGU8VV96dVDmmogtmH+IWugyNcStEHE+XQtIR9VAkKMObmkqM7GNpg2KBXoIHzLDiQOBFHhp6O8mOs2Z1wElnUxWKrfuC3s+Kp6FWfyDVXlvabYPdALi7q9pVeTy1XdzYFpykpXkkdSvKFKgqI0j1ThuWAdXhMyTTLzf5Ti+VN5Qu6s7i+8P3TegurWsQWT0Gd1hhGaK26jkgKhOxSjb7VAknrG+DR53rkTvtfc2SlyFVwGgbP3anns1ZucPl0OacCDA+RVgRSkMZ86X2FbFPYHKlXA/X+P2jbWvITHjBLm1JhEDZKReSBnxR84W1Fc1XkfzrWSrjcWpECtshMFFqPY2Ybq0krmTGjW6YAXRq53RkMAEeXK92JwM23a83KCPgHG8YEg7BRglzmjihpl/9naYYSg9etb877m1CwK8Ahnzxaa+tPYctyYeDZ6b0WCvByi2KbKeJGNbPCiakxyTDrNEQBWBG5iw1aJQA3LebVEo8rdMa9jKfjP+c961Eo03NFyvGx96GqdkqBDdQ8/1awhPRcDpJtzIEaReP04lwLNyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(38350700002)(6506007)(2616005)(86362001)(6512007)(5660300002)(8676002)(2906002)(36756003)(83380400001)(508600001)(52116002)(186003)(66946007)(38100700002)(6486002)(316002)(6666004)(44832011)(66556008)(1076003)(66476007)(6916009)(956004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Z6Bnb518ZsklvTjXAV9y8brRqjSTs8Jaedoqw8spDeQKt3ujoW2Jipyw0w6?=
 =?us-ascii?Q?bphaKs+WbxvO2Ho8NKQwMjvuvPDd6E0qM1nLdiM5l4GA65Bd4NePlLIr/L/R?=
 =?us-ascii?Q?lGZR+Nuhryq7XtKIbfTUMETCxt/fvMNVs51v7EVDRIEmD4sstEMlZnkFZO6T?=
 =?us-ascii?Q?W5KHxvUlrCDAnrabYqPPuVfheVDZK5OWzm4FYnrbBU/nB15S7SNxdavM+c8N?=
 =?us-ascii?Q?8z7k52woJoM1GTAU63A0iMUnE146n/B2W2m7KGeCJZdAj5G7o5jUlAez0Lrq?=
 =?us-ascii?Q?tBAYRSDiMoRGo8Hi2pCnr2SVbUnb0reV9bEBzkIBuEj+78TMW4qdqpajnq/F?=
 =?us-ascii?Q?Df8cUGaTB5HKUVqW+H1v3mJj4dTM3DVbiWgggSLuwbgereD8BQi0tH1brJUI?=
 =?us-ascii?Q?+bFSuj3Dxpx+4KEpra8ElhfyQsgLXFiijDA3TUCLrtEZID9AT9yfZIZ2ead9?=
 =?us-ascii?Q?tlVSEnNTPoMKnfGq2X70vbXWjn0gnLuiRTTx6lXmLpJMhXt7z6RZ64EAsEqB?=
 =?us-ascii?Q?NB8yCOcm7bV37rhhIb5eLcGIdrH7OH011XlxX+1JzBr5QzWtSnP2cT97ppT9?=
 =?us-ascii?Q?2o3ky2S513aBqI9/yAO+I5XiB8l6imRIgWVD3cca6sVERWTEcjk5dhwkHTXC?=
 =?us-ascii?Q?rvD53OnedoTSNIlaEHbe+/lU8M/PvFj2Onp+gFN2mTANbrk237oK80+XjPJC?=
 =?us-ascii?Q?qz5DDLqANuOZMU4hwphAO1x/JuNZTwfehdqEKKpxU2AUlaOD3/5MpCbP+9tX?=
 =?us-ascii?Q?HsyRBOY25m+obJ++2gPSGoilfyQ8Mja6tw+YqzeaLgtKkAj47D9Ql8CEke5q?=
 =?us-ascii?Q?WJPYjxGQBWd4rTAUdYD9uDaLgpUaXpCW0Ag5bOzlCF4LVbkn4jDaQ5iVF4VY?=
 =?us-ascii?Q?kuT2dYcFlR4EDvGrCRxy/n07DSvs5E8QiLtxp5ALqhr20b2H80EJiojEBLn6?=
 =?us-ascii?Q?6Lcb5cGdSiQIS4jX3JUD/YvAn1bPkQql6bCvn02Yzz8ceqAxn6Ip7YU8tsYJ?=
 =?us-ascii?Q?s9UaQfSicqkAljxMsWS88oZzk0z6pF0vKR8wbUnxiOOvhuo9P3GzyrtRPV5j?=
 =?us-ascii?Q?ww98ttZ2qC3h2gl4/n7yc5PY+2xHbjBwV3MZYxwcD3uQdqO/Y8N0OQWZn7jI?=
 =?us-ascii?Q?a/VMGEH0ai+pR1lmSzLjhYiyWIdXKejc3d3P+RfwZLvujiQ6e1XoC3m17aMA?=
 =?us-ascii?Q?1xfvjfNteVu+qD+Nx98SSN6LJw9sorSZlelAkyoLRBeNKwfpTY6NPrP7ebrx?=
 =?us-ascii?Q?MJaC/dMgPPqNprt6py7YGAxEcC6mdKD8GSRDB79jS5wcZOyuwy9bgp/ztTSR?=
 =?us-ascii?Q?QmYQAmQsCDKbQEpg5Gn+/Op2yJK/rRR5q2OBomdhHSEYV359V/AdXg6TEyZ6?=
 =?us-ascii?Q?tEzEcLKDWLZigRPrK7C1+KyRcVd67C5n3oadQkXM7kVY1hiz04shoQZntNdw?=
 =?us-ascii?Q?9xf1fW+kFQyrT1yjTTSO7jhw5tv3LcID/wyA9b630Tu/MsIAEX/Ll4faZ8kG?=
 =?us-ascii?Q?Tkm22MsP1d/oBMHs2Xj14TkoaXo52a8ijcEFpJyCLFgyKbtb9JcO5IZ9D20R?=
 =?us-ascii?Q?ZyA6k5v6vhYyMXugcsTEeU8llcD97btNGKReBfbHbqAKZ2alQ+sa8VQoCBY/?=
 =?us-ascii?Q?0ChCNNlMm+na4KbKu/fs/3184GJWFOxR6DdGZfwEfr5N3Gv5dTlZytmInlKZ?=
 =?us-ascii?Q?n3YhCg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e471bb-cf74-42a1-4f1b-08d9a980a997
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:13:51.6695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R9xcCGkQgPh4aSeyDJsxJSbf4hDQkH1HMkWtrQlm+sL7/5y83ojhuzYIHQwUvHRoMFKIEgNkMV8JDWQe9ys4nhvdxzH3y4qLPV46rjvwfVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: XnlcG480QeoK9Ns4lzTOyx0p6hP7x4YK
X-Proofpoint-GUID: XnlcG480QeoK9Ns4lzTOyx0p6hP7x4YK
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
index 950ccbc9918a..6c5a59c87526 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -25,6 +25,7 @@
 #include "libxfs/xfs_da_format.h"
 #include "xfs_inode.h"
 #include "xfs_trans_space.h"
+#include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
@@ -274,6 +275,11 @@ xfs_trans_attr_finish_update(
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
@@ -287,6 +293,7 @@ xfs_trans_attr_finish_update(
 		break;
 	}
 
+out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 81c445e9489b..d4b2256ba00b 100644
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
 
-- 
2.25.1

