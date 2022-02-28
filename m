Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF40BC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiB1TxM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiB1Twn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B19BE00B
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:52:02 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJHox010124
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=O+6Y00U7BLZAyS8UvwlS2YOYLgiyr3B3vi5cG63Sy5U=;
 b=Opr/Kee26wdgY0MD1fmp3d04wCS26srrUOZfDexSant7W8GydR6nQP4+u2pWyteHS3Hd
 JVZOvDxujBocUS9giQi68vTLUjkZBVpfat5J5ewN5Dcf3xZQ8cmwtLiQDZX/HClUQ5nm
 r+VJeaIXO2+Dp/HWAoSiSXwfaa9pFfBVBSJ1xupkGpdnKh763dMN1DA5m7ii1Q0tF3Xm
 JfCsmE6RFGdIQiWiHffCPXcuDDsyy1HyP96rMHI6De55Z/w8/hOLZNi58ILSXOICcPJP
 CCytjiv0BH/YLIY/dimjlvrEaJPUnfakF9wePDJ/wNMeu1SWnIYOgDAdN5UJkSCf5GF+ CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k40pqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJkltp076550
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3efc13e3fr-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+cRuaxEY82GYV3UErTu6QpNgAsd0+WcLwM3WHQqGCf0oAIPdfQcR5JQIeXhEut7LEzmkxBHNW1XvuIDLyHt/O/n4pBedVaE2QnLQZceu6HgHRtuQBF3XYQc9RfSDsfc9x5Ht2JMSaV0FKmDdCUP+pW3rXVczniDOv77H9Qyze6CLBZq15znP1JCAw71jHPbeCabdt/nGfuwGi9/XwPb0G/Mext6ARngkH5JQbXVlEvpt1IDmWqhsHXYNkufLuIZfVOsHNcPZ5EHqSuTsq3zX2tAQ6f4U/VOkoIvSRV/Sby1tN/TlZwERIyRZT3tma7hW0Tq9yiCz2E8kaVLRgh4TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+6Y00U7BLZAyS8UvwlS2YOYLgiyr3B3vi5cG63Sy5U=;
 b=S60SIvRZT3sBI7NSoJz4H2TmkK/XlQp4fKeTmAaK8Kiwx4G3MGOI2XGiiGC+qW0cDmIvxdgDv3sGuuHhooPEKu3z2YwTbwcqp4tpns0QgQZt3g4gIH0BQftKsGJDEzodlpt3Vv2D8saQYskwkFniSSSGGCEVry09V2/iLYuoBDVmpNwCnBbB/ZtOZQZmjpDapx5HJ94tvZ6iVMNP5E3h4SVe3emLMZdZcVb+cSaru92J7cXv7Af0P4Ch/AgNCZQjvkJ1KE8m6490qcMEcVwxZKnk3tt+eExGO6PJQj04/vxNrULDqrhX4mhbTRfuKu2betNdWrHguQpYGlbcqwu3fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+6Y00U7BLZAyS8UvwlS2YOYLgiyr3B3vi5cG63Sy5U=;
 b=cG3udgdN69TMAVNLY37kBITpO0iJLu5RpbSo04edknbfwcLKtKPRHNGINtE4awKM4xaWL8FleXcsAxLW3RkF2G7sdFHneMpWlduC771b/0wejESzEx7PMxzPwWZiax6lvO9JA0nKBcHHUaG6SLGG4fjkUFO5a4BCP9aOL6cd1tA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 19:51:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:57 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 09/15] xfs: Add log attribute error tag
Date:   Mon, 28 Feb 2022 12:51:41 -0700
Message-Id: <20220228195147.1913281-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228195147.1913281-1-allison.henderson@oracle.com>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f08aba81-bcc0-4c96-6944-08d9faf3c6fb
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB56127260987EC0EA11FF940495019@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HiMPcXLUwfyNe/7eXFhwTXCN/kTWQ/7lxJuQGchoF72uQUfGJz77TX3rl/Y5eAeDDGwVMaGD/p9kon+Bs0HFEEJpQqn/gkXXdLNnQ5yYW+nJgHGYI7ZggsmGJKFuFPKcqZ/jSHcz4w1EBslA4svT6KbG+NEeRwWHZGtYoZzcs8GWMLvhwS7bTag2ZFdDAJodaClgEmwWlIYCNnYabnpo+UJ2gSwxbf8p3tf54KTEV+umhTRopoxqYsO2wFNuFVBAm+ChGWK9oUv099qS1aiNI50IA2Mgw8eS5kPX53tnVRAvy/I7mcopj+vljwrCth9kOGsdP3Uw1qPK8HxZCiB1DWKvItvCPrCiauRdM6wQPoFSJq3FUA7xqXRMrUS5woohFV/+/ZaXIZyOEfGIRogAh/Xap6pWpw39caV0YYB7pQPN4ILCSrSiex8z0kFCjb6bpeD8Vblu/TBhMZNzEwGPt664DSg4wx0VS93ny+k+lL+yQZg0Y2e+F2FZaPT4Jg+pIzasfkaff75UwvCR8IfawSZ3ZYgdZd1WKvars/WDdQiz3R0xW9xf7+ZcYDWxPLq+j5JeCO1UJ5Ef2qeT2V9ILccCPXErTH/1O4KcB2BypDdtsJbbuLBnZJznu5IEbJb/g1ovrXhCiHi4WLk0IPzA2S7hdGS/zwLliP298tf1vmhagRhpgVLaj6ugW4Pv5cCHq7gEMsZPbyqZ701bLg/Wig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(86362001)(186003)(8676002)(6916009)(1076003)(316002)(66946007)(66476007)(66556008)(2906002)(2616005)(6486002)(6666004)(6512007)(52116002)(8936002)(508600001)(5660300002)(38350700002)(44832011)(83380400001)(38100700002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XQOEDSPVajRO9FGTSeDajI/EnoafH2a+EtHVIR3saYvVYuiakrTg3xt2k3kH?=
 =?us-ascii?Q?EdAqeMa5sm09BcYe1b3aJb7fkIAOGWqew0K/gpeZVaetiomz+z0PBLYLAGcz?=
 =?us-ascii?Q?VKK2FEhjnngswJa2dhHoy6InN+6ScuYtb+YWZpb5yQ8JZwq86hWsphd2fpf6?=
 =?us-ascii?Q?yozyrg5Ua+JkmtxURn0O9vZfUKcVLpMQeDb75POheX1Tn8YqLaDqZvchOyPy?=
 =?us-ascii?Q?OGnoNVUIOylrTksZYkyzyMz7BS91GWaHnFRuGa4MiW2LBoW+03l2Km0C/jqh?=
 =?us-ascii?Q?d3bZQdyTIPf/DFh8z3KxxcYX2t2kRJCyDAUT0yJxB319jv/9GXS6IlYCweHJ?=
 =?us-ascii?Q?0S5uu5sPo8DJtTf+PmEqSf34tlOBqsJatpAWTzIC5QXHH1qykEcwbep8U1ue?=
 =?us-ascii?Q?N5YBpjuxoDCX5pxJYIVHvXWf8bv8UIVq5sJxvslVDRz+OFI60IaXtiHowq5N?=
 =?us-ascii?Q?hdMgZWhiKlrBd9QPNSTJVUspHPfTqBsqCjOrb2ItSEOz/YyGQh2j8M2dRWc+?=
 =?us-ascii?Q?NyysWC51sknhokN4dN6sVBeWvp0LDJ7ZIjTUmYjaZ62fIy1lnP3pPHou3WvW?=
 =?us-ascii?Q?L7zrWgXlMBXZcorXgjS6soLHqE/i0dCVD/CFEnN5dXFOJ1WaE3FMkDvQd1xn?=
 =?us-ascii?Q?Y76ePwQPO1peFL+eSMqt7Ra0v1wYjaNBGlKAqERn8XMwROnBI0Wz7O1pCOPn?=
 =?us-ascii?Q?VTawDscKUbMqUemuu7gXaFMEfmk5a/r3lG2GpJKNj4VtlABWNCRRQYmIu2Pi?=
 =?us-ascii?Q?E9sHeMZJU2Yvr8kx/vDZ5NC1Ud/0yCHP2v4FjY1YmkdFENnX86wh3WjpQT0K?=
 =?us-ascii?Q?+aNaVHBlOgnfFH5IFmdYhgLDOGkzl/6Ibq4ztHkEoRXSRihAlNMFrKp/Q/El?=
 =?us-ascii?Q?YP10bduTZkkqO1urJPbO7iqNdXP8cT6tqSekYmp5Hb5+SlI+CCpB8go4t3/F?=
 =?us-ascii?Q?Fm+PBdj41dfHz3OOntEHscNVp7a391V+aCc3baw2ul+omj3f4aRaHU1ZgVqe?=
 =?us-ascii?Q?P43yhMp5o4dfBciVHNjYNf331EproY7cF8GI3ICTPYZmPgbM/f7mJ0yawhOb?=
 =?us-ascii?Q?WOxxDCgAumXsFJc5hmr5L3OE0XCjnRYW4RhrECs1b70T/uI6gp4kIAvUvcDe?=
 =?us-ascii?Q?QSUPQy5qTpPibWh3+osKC4qBJjpgNSpelmafMYB6kd6Q/lKbDNy28VcaCgSf?=
 =?us-ascii?Q?HBGS7H3dfihuVIyX9ema6w47j8SWVt1meAx8M3hQ2SK2ohaCeWmWYf08qbZa?=
 =?us-ascii?Q?EHW6hyCQB0JV0+v+RPi8OCQPRjXehZfCQDZSC8A03ul8zvNzNHeGe1XvcS7K?=
 =?us-ascii?Q?wD2MIopgCL60rPQ5ZxkbUZ0sRer1DCJ40JPlmLlh8kj9t7OmQOzOX6vOfsox?=
 =?us-ascii?Q?9t21Sb/SAp/Kob7/RQLkvr4/1sKMHUW3V8c/Xsh4ovAY5udWaKFHlqwdmOgn?=
 =?us-ascii?Q?ay9blKlbBrma4Xrp7ZLfBfngRocWdAGfbIdRuaBh2+RMJGApQVhFCT+0bjJl?=
 =?us-ascii?Q?IazD4w9ufS8c7vOau9r9u/Nog+4ZiQZHhP1kSp+tRttF3VY1pHPAkCo0occX?=
 =?us-ascii?Q?HSDAhQPftZk1zYeFsp1eDYKh7kpRQ15WKRq6aUzI45lclX7cufJhobUVLcIp?=
 =?us-ascii?Q?Hl0o7t1zANQac6mNApjtnB0YqIhLSJ6F6BQ66mH1MzjRovIYu9iM2qbnn+p3?=
 =?us-ascii?Q?th3jHA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f08aba81-bcc0-4c96-6944-08d9faf3c6fb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:57.3560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1HbmSUloLzfJLPMmL+P0tuWPJRCVz47r4t790Kkcb/sePvjc8HIeesp0OV0eAON+UwFAtTmUpyHbrE2XpwLzy4ou9gf6aZAoApk4QGrc1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: BxCsLhPMQqCbz5pdlaTZYXCdT6tGeoOq
X-Proofpoint-GUID: BxCsLhPMQqCbz5pdlaTZYXCdT6tGeoOq
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
index 468358f44a8f..71567ec42dfc 100644
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

