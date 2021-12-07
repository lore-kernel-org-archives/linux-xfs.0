Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB6CC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 00:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377957AbhLGAFW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 19:05:22 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10362 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378043AbhLGAFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 19:05:22 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5GGT012529
        for <linux-xfs@vger.kernel.org>; Tue, 7 Dec 2021 00:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=bdBnVpZZfPyS2x+WAhoa/2aLGiPuSxicqPRY6ZzvN+0=;
 b=W4ThxS5tLA1wH7nMChLy6DJARLWfOL8tEEXGcu/bWgUnang1EtHvjL+RfuwkEZNHHka+
 o/Z1sdgGuJv2DHoIPQSjBE/TaLnJyJxs4r7Ra/oG0IVbWFzRQFypVpt8rUECW0l/AP4w
 a5uwqZpf/+ZF+R7yRAl4N4IoPcYVecuGJoxdUeN95V9vMAzk6aOTZg3Nomsfd7ZAUKs7
 JNuoEJJiQxIWlQ6/uwrXLnhHOIYR/n+fXdAbMvhwb7STMQm85laavFLSZDc0YSG/heca
 82LvC6+ptjVfD97dZGVSZlIhQzAxfc2JuTXlvyEkutX0mF/2zcB+YBXj8KM4LB6uydfO sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csc72buxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Dec 2021 00:01:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B6Nv8rF169164
        for <linux-xfs@vger.kernel.org>; Tue, 7 Dec 2021 00:01:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3030.oracle.com with ESMTP id 3cqwewtb25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Dec 2021 00:01:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWVWpsTvUaxvBanrxDf/9w3UhyMGixgqwtm8/6PLGYUIlH/+KVX9TzL8sX/SLFg88vBA5s6lOzIgyb+RLvranxM+y+4fM2w9TVa0XvMAKGs8TJ+ouxdGGQ8bD9Bd6gbIhmq0RXBNTh0JeiZelSCK9/B/lq/Pv4U1jp98dudlND7VNtQy9skLgmjMz27WC0q+sIm6o1WoZy5jO0hOJe3/q+2O6+pJIMNQd3bzjWbEAoMaPcool6dEHacSB8FNeqCucF7ZXOZFLS4rSJ/b2O04+5jK076ODBipypfRCagAwYEwTIv4N9vUo5OwFHXBt5C0mfFibYg4KG0jvihWK2MwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdBnVpZZfPyS2x+WAhoa/2aLGiPuSxicqPRY6ZzvN+0=;
 b=kJF7oDpsd00PHWcHFhlOcVO4PERFVBJzRFABhblY6q7i2Wdk9RmuXaNapgpGWYotYcxaq7uZj90GkbUIG38PJsFZwdq7zuJjiCZvFGIZx2yH20qzZtjyrprNqHlHE2bc/HWHyoj0J04GUmgxmEmBde/KiC95lPdqJOYdvMm1PyCAecLyAfFLcJSTyGbh5kFjp1zxivWUm28QXMRjad54OYvtl06iA/58vzGZOgovDRKwDm6VqGOd000rpbm+wLHcGn9HcdU6P2br1/U6/hKVAS8bWo6aRosudNfgYOGDGA+VnPcKKU+/UxAR54KsyvGpICzR/Rq7gCzs4lgXQmizfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdBnVpZZfPyS2x+WAhoa/2aLGiPuSxicqPRY6ZzvN+0=;
 b=PNi7wYcVCq4Dan+1zEX9bKpag08R1ohmceBfqrDNsaK+0jS6Lcply9ueqW04BsvzkufAozn/RlF4WCg6xDgqPnhi/nAXSbR6ADhots38P8eyffTN23h3OJUZXmBwNhkMnwobHKAdvfTnRi+bR4G1we9UJLA1HckN6hFbYOD7Uz0=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2250.namprd10.prod.outlook.com (2603:10b6:4:2b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Tue, 7 Dec 2021 00:01:44 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%4]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 00:01:44 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 1/2] xfsprogs: add leaf split error tag
Date:   Tue,  7 Dec 2021 00:01:35 +0000
Message-Id: <20211207000136.65748-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207000136.65748-1-catherine.hoang@oracle.com>
References: <20211207000136.65748-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0036.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::49) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BYAPR07CA0036.namprd07.prod.outlook.com (2603:10b6:a02:bc::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 00:01:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d6dbe80-ec12-43e4-da6e-08d9b914c125
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2250:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB22503470AC8530682F0CC76A896E9@DM5PR1001MB2250.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZC6YFpW8gRUbmuHo+eRbjAfO+d0nHBF4B7J6EjaNPNlvL/svoOkKipe+kLAzWv3l9hYbsK+n2MDNFGAXtV/dKD6bA/g7/zle2ZuLSw9+45Jk5mBZKATM/1bTzK/gnD+tH5mUgEwwHPyBVxodhwngDJzM/Zyb/a2HUi6izShOmEFuEbyyuI51Dg0O2hJD0edF2XDc0zkGIfutvhW/lWp3Zo2B+RkjdewNp3JgsicrryfpA1tk9d90xFr99gcCXtYWQsQ0iDMPjKvplXIGwEPmbip0hg6vFQkk6i4HsmlguKtXpzky8H62inU4onKROCTWudd7IlTwctze8eN3A/IdbYPtOUa+8CDd48WCaTmbh7CQiqmyiJwkjyageXOQAQ1OnsQoVGFQ839C4IfLTadT7cj+HZkzH/EMoKrHJ9GdtLhNBo6zcprZdOpEogSBwaTYdCtRjFPOO8X7xe8dIXvdyutE2uF2OdFy2i+ujOhuy60ID+Sw7wZQKLQuMT1Wi4f2k/wE4ct10gXCXT/SaOjl/NRhhSfCCHFLEWA8T4DoK2H4NoEe9e1GL2Zj0yXlRBEJ2hYRTVs4UoAUXesWtFfhcb2kVV6ljozSagilF5U1Dt6/g9h3lVtoT0tPZKwJMtlCfBlxcG8pDuVz0XQ8k3lMXmi9Fn4Gexv3W+fvqQoZI0BpDicXMlAjl25xIzTRS0KMcW+Oc0IqqT40mf5j/Xa2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(66556008)(66476007)(6916009)(66946007)(2906002)(6666004)(36756003)(8936002)(8676002)(52116002)(186003)(956004)(5660300002)(44832011)(2616005)(6486002)(316002)(1076003)(508600001)(83380400001)(86362001)(6512007)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LJ37iy+PIq7/JcwoLujlLWVz3BB022DEtXQN3mVeB75Mxy0/0sx7xSADiaNB?=
 =?us-ascii?Q?aEkKFw8+oRSg2+C6awsjYBICD+u2q8zmhBYG1o9QfNAMdMAn+yeHhMBL2Tmm?=
 =?us-ascii?Q?PVfmCwJZ3c5EAJiyXkHoUdCmuoEgRw0jDRViqO8zRUgZmW2CrVzeFeOU1MJ3?=
 =?us-ascii?Q?2fNDoG/tb7cvqHJOK9lk6jCif/FpvNWglixYdByJ2ul6W3N0GBz5NFLC2/Im?=
 =?us-ascii?Q?Kc0+zbfbUohmmpEFlklaY/eytj3Fag9RqMNJFlGeRpTmJFdJSXW04E5PvwWe?=
 =?us-ascii?Q?yxevGKAUrQj3HlTez6rlQ5wCql09Uvb210CFR3BirNXnViYxdNk2nyUtc/7r?=
 =?us-ascii?Q?ynYS4IwlvFawBXbsms5wtWvLQC7qnS2jivLVawVE2EBGNR8s7LbpHDXkH1yb?=
 =?us-ascii?Q?/++xS6bCmLULG543G4ipALAPI1AWzInslnMmHwfVf5CRRCn0QBZyxM2LoFVW?=
 =?us-ascii?Q?2G+f+Q3p2lMiriVF3S8zDSIMGYF/aU4GVsPW88rETHEqmxDDkAWItBBWhNZ6?=
 =?us-ascii?Q?0KBLZg5gj2hgb3NcO94M5ghpZC/9pLTgdaEQyOpwqrQJRLkYKY6RXSziZ2pk?=
 =?us-ascii?Q?U+aIw3nIY0Lt+dHekK33aKCJQouuDXBQcSgMJJMBwTOvkF43QyMBh3b3Rgzv?=
 =?us-ascii?Q?i8AlQdixrpD0QccTOo0+5mViqckMeZXMvMO3Qo48U9EyMjAndL9zYIys44go?=
 =?us-ascii?Q?ZQID29q2bgVEh6p+BdZGtox/Y/duKT1TLpMXqithZUanlZorlZwSGdV1Ded3?=
 =?us-ascii?Q?lhgGrTNr+qRAhGJ+3rSOG4qp1S9DiUw2+Y4HMS9QwxOCy+QNV3m8AYnW6PWt?=
 =?us-ascii?Q?PM2/VG2dwSRv/T0y6wg19VkYjUnC18MPOlY8ApA2fXL0pF1RA6+pbheSuAAP?=
 =?us-ascii?Q?Yp5LsyOEtegqNygp9ciC/9sqeMyp4S3neqA0VJtKXKqrCKtXF9WGI4qX6ddU?=
 =?us-ascii?Q?FstePt5I5qsfuGRHl0HulNRHHE9Iwo8LFxPkR9/tYeeVkt8n18KWgNzZ1yMT?=
 =?us-ascii?Q?x8UFeriu+9/2zh87mbBA6qVtgw3cgm8nHxaq8pJDpQJ0fHuzl6y6QnHwLFR2?=
 =?us-ascii?Q?V164/YhyBJsTeKr2mVShHRWjzKQKgvqVmNUYJxM6j00fEOPdDoazroy+M5n7?=
 =?us-ascii?Q?kpGiX0DEJnNLfWKIRDbGkQXNP1gnis4G+RD3Kq6e+MN3CTCa6Dr2JaOzhJ/A?=
 =?us-ascii?Q?+rBFFivhtGkb4sAdSFJHs2IyziRj+UGWlev+PXQ9EwEQgaQLzHPWNUK6dAfO?=
 =?us-ascii?Q?+OxWNinQF0ulJfLK+lyXjckhCbIS6np82avyE0+msfI2BM3NUioC+FdFLUPQ?=
 =?us-ascii?Q?JPwB9SkrVmu95hOF2MqOuQMzu5/6gkgkm2jmW/9DVTyUIzs2QVCjXaps7flX?=
 =?us-ascii?Q?ce+Gh846EjV+2MLObAKk/5bEq2+3z1nNcdEgv91YC8TbZnH3jyst5rN4wFL9?=
 =?us-ascii?Q?/nnNjM8+zqBYjJ+4WElypo+xGRARSylOz01crzZ3VgpcgQhgSCwUYxemqDLu?=
 =?us-ascii?Q?L2wjpwfMnoFAghjhrMuE2nFzUzDfQ/WT5tVDYnIM32H5SQVHBz/aIlhIK0La?=
 =?us-ascii?Q?C/NHpypjFNUfWpmpkzkVy3ZpG67qQ9polQbV8qHbNHoacS9NBHLjnlpHGJBZ?=
 =?us-ascii?Q?eV/R2JQdSI4ikFnhQ/vJLpBE5Z/q+x7Bp504+1uRghgA2lJQ8pLSrrPjtRuh?=
 =?us-ascii?Q?xgzFEw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6dbe80-ec12-43e4-da6e-08d9b914c125
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 00:01:44.1853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9EwFIx/SyTxH3YtK8Q2s1fKl4fED211GoOI+C9ey57H10gGu/3m1eo/JInGPmT7ZG+e+1U21++W7n3g9Ajg4bmuzdZTA0EuU4g1BYSj/1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2250
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112060144
X-Proofpoint-ORIG-GUID: ZcPEoj8HiG6BFFXAJfmxBSTOGVAfhcDa
X-Proofpoint-GUID: ZcPEoj8HiG6BFFXAJfmxBSTOGVAfhcDa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_da_btree.c | 4 ++++
 libxfs/xfs_errortag.h | 4 +++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 43b51db5..51f3e2da 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -59,6 +59,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
 		{ XFS_ERRTAG_LARP,			"larp" },
+		{ XFS_ERRTAG_LARP_LEAF_SPLIT,		"larp_leaf_split" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index f4e1fe80..e17354f3 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -479,6 +479,10 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_LARP_LEAF_SPLIT)) {
+		return -EIO;
+	}
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index c15d2340..970f3a3f 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
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
-- 
2.25.1

