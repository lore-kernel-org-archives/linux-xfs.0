Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031B3C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiBXNFQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiBXNFP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:05:15 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D1F253BCB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:46 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYb9N016953;
        Thu, 24 Feb 2022 13:04:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=eylVCA3VWSsmjaQpFBatqWUZSnMbDKNJcdJmAoL1EQc=;
 b=g7F/gYUDs9phBLWR+aEdRbGr9vZzjUwAuCbV6b4eaj2Odomzc6e0Y1qDQFxVwf/KP4j/
 Tfv7jwVXddtDJ9YaHG/HdTjYlsxUw4HKi18bOnqm0qzhm+2fUc2tWn3fuDXIGX8Ed1ed
 zksac7d+ZMSai7jg6a/GlP7dINn7hkcJq8fQ5XtIuVGe11yh4e3FgE4bg4IFkop47G7U
 ifnZ7QTaL4upW+ZpNPLCQZQ+BzarTSsAhQqswQkQwzVqjiIYzimVvyPsdn0wgDGZbBKJ
 St3x22pkfUuec9dmQPIAOvAYBP066sZML1ETpoNbkBZu41TumiOwTt5oNC+LGhwMXh4J 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cq4h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0wGL002419;
        Thu, 24 Feb 2022 13:04:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 3eapkk44e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQPwJnRe7uKOgawEGh4SaU+XN4BZhSFr3DblwEhVp2cv+BA6H74L/aRNEFeiBmOWnzYy1607lERCS8tbg+GbGu/7iXjpDMeyve7FLbYZjte+rN/y9R15jbQnwyRM7Wgsc+cEw+lQ7822IcvB9oQGOhnsJa/9oJ5LiDoYNmxoL4zCnrc50vq/8ltmtkNOho68VbwSWRdz+aUIoIODIRX+LrGjTZNZXA6XjJ5EKT0zLWuKUmp0PnDp1bJnHq9+v9un1PGtHFSUadIOSgwUIO5hhUS1hoHrZJo0iA9XlzgX7PO2+70erruuE+uvyRo5poc9JRnPHV+9RKNLtuMg5K7h5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eylVCA3VWSsmjaQpFBatqWUZSnMbDKNJcdJmAoL1EQc=;
 b=OBjXjtVttiJk/dpUjobblkhKimZz44dm2q8HVc63OPeI8Ae443cbIIlFN3FC3KEzypIVWrpKQIemkrCTJ74PQ9u26pDSsTflzn4iGPwrXGeAKZVTN1LyGZATwxOAmbxLYzhMotTi/mZZWevtYozFry9MwyyjCeX2THgIudMEPGEOzVyAks4BpLPhXA4EHtI2EfF5OWwrWNZUaD5OY93gkLc/neqkjdYnU20hkJetQTYwMaQRMNc+BOEBQx9MEiZUIcrbTPvlBjJn19WFF5DBFRQYjpwnCjUV5WimsD3hSzMM4gunaqMiKWkc1oG7yZleBIADai6RCyIQO/8h6tA1gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eylVCA3VWSsmjaQpFBatqWUZSnMbDKNJcdJmAoL1EQc=;
 b=fbS5a8dkZarUzXX9AQ28RXRTgiymaj8uq7f2v/3mq8J+Ezd7s5rLKsO1LbDRNboebw62IKi0ZxE7XSN5Hw7N6gHzVALGhjqHdBbq447Hq7ftMERRZDaC5NE71PZ/LpDz9GlcRb8w/yg1NlSRSfs8QrqC+uHMKxGe98cK87usLjI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5405.namprd10.prod.outlook.com (2603:10b6:a03:3bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:04:38 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:38 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 17/19] mkfs: add option to create filesystem with large extent counters
Date:   Thu, 24 Feb 2022 18:33:38 +0530
Message-Id: <20220224130340.1349556-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9759044c-8613-4067-bf98-08d9f79636ca
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5405:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB54052547D3492FA7B83F194DF63D9@SJ0PR10MB5405.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPbTXH+aAR1dsp7xsoUhB/7zQZPi0IKrwSRahiC1iFZJKNajM0zZLfz0f44JT3cTjwIRWlnjJU9A7wZRFc/KPibhkvlHCcXlaT94nI2g635ZpuioE7uVSidqJnOaAAvyHEBTTNIOYteCFYbBpuPpT3prsNU9PbzVxcLgDFuGBkGP08ysxE2fXlWMmku0N+VtJTY6XKFIGDrDjAVLQZqW5J51SmJaw/9QYk0dJMFhuktJ5SbEsZMVvSCJXWqmU5GS5WocmOnQ7J2wF7JugTIL1xv8jBGPEPSi+GuQex5FRsPb+KdBPPvhD5YmFBxvvUAiGuE+9xmTSZM65yKpHFcPzO2BPabrDkKuIC2tx6IZZR8v5SNbNWC4uzYEBCuVZlnp0wD7AJqBYT+pML4cmF4ou1f9EziWWInJHeJN/U0O53oe34GknyVYG6Wc5dYQcpvCQL09g/vYrTpi6SMa5VwheoQqqJ+J4dZz+0dbMkPum1fZvsHx9E0UuEdC2tHfwvjq+QH7hycSKzCG9hZUhWf/fC0Sm61sIc4dqoy0YUYBCyYvIggE8d1So+O+QKodX9DUokYy8NnaGCo9alkK5zOazgDZxxlfFmKcCB39htfsl02gco4I9ajN+02ZvL8FoW7+kd5s7udoBAZDhKhslWHZmBEdOo3MR0BXWK8F8t+xmTNfIKhe2ZITx4eJ4TZcYzarppOL4KX1aKHTO5SNUk5x8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(36756003)(6916009)(38350700002)(2906002)(86362001)(508600001)(6486002)(316002)(52116002)(186003)(26005)(4326008)(66946007)(6506007)(8676002)(66556008)(66476007)(6512007)(5660300002)(8936002)(1076003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JnOVILQuqTf08lgmMN9mvrM8XZt0ynWqgl2fcvUngyqsqS8OZcwgv+EwFWw7?=
 =?us-ascii?Q?WDVTyLLS1U4VjXSii147+eV3DmrxLGtX3JyIFSql7vYYBMfkhu20RheFO6Wx?=
 =?us-ascii?Q?Nfu6g/ml2jFOiy3yTb4GNhgoE77xfR++qR7bHdgBUtTqI26tDTnrvgFV12aK?=
 =?us-ascii?Q?Sj92gnI9ar9JiFg1L1FDOCV237c2AitP6a8NGy3p3um6mnKAVepZY5WzZDPK?=
 =?us-ascii?Q?qRTmNkp27EHINRu3aEZiJffwJsZdB+jSlEt1/ikgJyWZhf24A1FUjByAOk5R?=
 =?us-ascii?Q?CGbdajhF3LAYbFCo47sF/RrjIkkwiRIgLyi064aoIQ4FHhnX5Y0BCtvtD2qK?=
 =?us-ascii?Q?EOOZ2apuuqm70vXbBn5uKQmU/X22/3sKkQCgQf5u3OyCZLYceJtLg23J0uvC?=
 =?us-ascii?Q?cM5jYV5F9tpGuflE7QIRZvV8PHtng7VoDN9rvbHTp0I/hFTB1D2o+w+vrtdh?=
 =?us-ascii?Q?MJunHB+W+OgMYtMiDQAjR51KBJyMpilUDFq7/r8qFBtegyt8ztyG8cr9g/WK?=
 =?us-ascii?Q?MaBKyBEkjg4ES3tRi5DfNNZ4G0gYgr0XKS7VmV4dcZJWmIU7r/wEfj/hUJc5?=
 =?us-ascii?Q?o8fjhrvfy0w9bvdyOOgyCw1MpgGM501Ci6rV/mEwm/v4i2+mNQmrTrkK2esD?=
 =?us-ascii?Q?nvfrT70lS9IGNZ6ZLCMRxI/aq0SJClYbjaTrOixM7dGU4/QadVtfZ+FZq8+F?=
 =?us-ascii?Q?7jsthlmIwqS4rafUBE7/p+/AZhfzdfrr7CScLGfGQsT8Jv6MUi7GCeB4RNp9?=
 =?us-ascii?Q?m8w9EWfwiMuOjpAtE/FUZt9u0YqfXNYRqDbo94gPdYSNJ05EqS8E380p1epX?=
 =?us-ascii?Q?vnjl2wW4VaXIJfby+xpgo6gT9szxn2dtssroLKLozlnbIYiscRPu+T/YnNH8?=
 =?us-ascii?Q?zbEzfccOpwzG2B1QOELmOpCeyo7JiKwwKSRjS8a7I3Ft3w6fcN1U6T2ljnAQ?=
 =?us-ascii?Q?7xAnzNEBigNGbT6HmhTaG13i1YvzaqzY5t7C8nr7Gxs5zGa5vzE0m56P+z0d?=
 =?us-ascii?Q?LkBTBf1qczW7k03qwA/cYMxHS4/DGJvfL2yIrNDk4HRkfpsjN9mZgiLm6pmZ?=
 =?us-ascii?Q?YlEgWQVXkYmofC/wYp7AEpioEsdA5LX1jqGvC47ntuHX9VcJ60fCJ0CpH4Mm?=
 =?us-ascii?Q?2jo1aDfAVZH1zfoNwddVOwtXCZJZbv4ABbJhPvCJs8El8WalTeGa/gAugTOA?=
 =?us-ascii?Q?+veE23XI1thf1GkrlnaEaSSpiae2TnhspYOP7+dJ/KJA4POvW0YQbJTk9VLH?=
 =?us-ascii?Q?9jZYSJZ6oRGSgDQylxWvcodC1YlGtTrd/ahpfs6SJnrE6AfzKkAduS5bx3fF?=
 =?us-ascii?Q?/B/+LeEX7KPX8QPVS9Ee38QLTmvbufruezVluq80vaC821AvtCuUFba2WJdu?=
 =?us-ascii?Q?+IebREbseXWB7c/1Y8oOQrkI4sHssnYXnWC9eOJ+m5aOscAqIeXinPitVLGq?=
 =?us-ascii?Q?Isd98/XCXUAqNuLo7t8kZO9vE+awSYYPV65uILF1kBcaKABS3ilChOmvzBLZ?=
 =?us-ascii?Q?KwrVF3+YTEcYq5/zUpjDyglAeXCRv0Db91bJQajLBeulkm5B95RsB2FimpHa?=
 =?us-ascii?Q?u1vcCjqvNDWvw4y9Bjps+Rq02P5wV9e6PzEQ6Uc2cx+ZhbtGwLjJ/F5vpeQu?=
 =?us-ascii?Q?DRjtDct7mOlAulWLz6mrX6Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9759044c-8613-4067-bf98-08d9f79636ca
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:38.8703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yM3r9hqbkGcfNSB2nqWxCdH5TwIjebuG0hqcIar4QEarWiVWDyFY0WS8LDuevMlOh9ZmJ/Wa91tU28jJjx+l3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5405
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: 9lnB6m7dB-E1fpgJ6YFRck0X16XPXat5
X-Proofpoint-GUID: 9lnB6m7dB-E1fpgJ6YFRck0X16XPXat5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Enabling nrext64 option on mkfs.xfs command line extends the maximum values of
inode data and attr fork extent counters to 2^48 - 1 and 2^32 - 1
respectively.  This also sets the XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag
on the superblock preventing older kernels from mounting such a filesystem.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/mkfs.xfs.8.in |  7 +++++++
 mkfs/lts_4.19.conf     |  1 +
 mkfs/lts_5.10.conf     |  1 +
 mkfs/lts_5.15.conf     |  1 +
 mkfs/lts_5.4.conf      |  1 +
 mkfs/xfs_mkfs.c        | 23 +++++++++++++++++++++++
 6 files changed, 34 insertions(+)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index a3526753..7d764f19 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -647,6 +647,13 @@ space over time such that no free extents are large enough to
 accommodate a chunk of 64 inodes. Without this feature enabled, inode
 allocations can fail with out of space errors under severe fragmented
 free space conditions.
+.TP
+.BI nrext64[= value]
+Extend maximum values of inode data and attr fork extent counters from 2^31 -
+1 and 2^15 - 1 to 2^48 - 1 and 2^32 - 1 respectively. If the value is
+omitted, 1 is assumed. This feature is disabled by default. This feature is
+only available for filesystems formatted with -m crc=1.
+.TP
 .RE
 .PP
 .PD 0
diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
index d21fcb7e..751be45e 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2018.
 
 [metadata]
+nrext64=0
 bigtime=0
 crc=1
 finobt=1
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index ac00960e..a1c991ce 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2020.
 
 [metadata]
+nrext64=0
 bigtime=0
 crc=1
 finobt=1
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index 32082958..d751f4c4 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2021.
 
 [metadata]
+nrext64=0
 bigtime=1
 crc=1
 finobt=1
diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
index dd60b9f1..7e8a0ff0 100644
--- a/mkfs/lts_5.4.conf
+++ b/mkfs/lts_5.4.conf
@@ -2,6 +2,7 @@
 # kernel was released at the end of 2019.
 
 [metadata]
+nrext64=0
 bigtime=0
 crc=1
 finobt=1
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 96682f9a..89d38a04 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -79,6 +79,7 @@ enum {
 	I_ATTR,
 	I_PROJID32BIT,
 	I_SPINODES,
+	I_NREXT64,
 	I_MAX_OPTS,
 };
 
@@ -433,6 +434,7 @@ static struct opt_params iopts = {
 		[I_ATTR] = "attr",
 		[I_PROJID32BIT] = "projid32bit",
 		[I_SPINODES] = "sparse",
+		[I_NREXT64] = "nrext64",
 	},
 	.subopt_params = {
 		{ .index = I_ALIGN,
@@ -481,6 +483,12 @@ static struct opt_params iopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = I_NREXT64,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		}
 	},
 };
 
@@ -805,6 +813,7 @@ struct sb_feat_args {
 	bool	bigtime;		/* XFS_SB_FEAT_INCOMPAT_BIGTIME */
 	bool	nodalign;
 	bool	nortalign;
+	bool	nrext64;
 };
 
 struct cli_params {
@@ -1595,6 +1604,9 @@ inode_opts_parser(
 	case I_SPINODES:
 		cli->sb_feat.spinodes = getnum(value, opts, subopt);
 		break;
+	case I_NREXT64:
+		cli->sb_feat.nrext64 = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2172,6 +2184,14 @@ _("timestamps later than 2038 not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.bigtime = false;
+
+		if (cli->sb_feat.nrext64 &&
+		    cli_opt_set(&iopts, I_NREXT64)) {
+			fprintf(stderr,
+_("64 bit extent count not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.nrext64 = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -3164,6 +3184,8 @@ sb_set_features(
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
 	}
 
+	if (fp->nrext64)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
 }
 
 /*
@@ -3875,6 +3897,7 @@ main(
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = true,
+			.nrext64 = false,
 			/*
 			 * When we decide to enable a new feature by default,
 			 * please remember to update the mkfs conf files.
-- 
2.30.2

