Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF7AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbiBXNFJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbiBXNFI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:05:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C699253BCB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:38 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYKAt000960;
        Thu, 24 Feb 2022 13:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=WEavS/qhVHpasuGt81QWPC9x5tjMVGCSrPmtpGPoij0=;
 b=KAHntMuOejynbajyfSJFTSqq6PG+3teZg3nRBb7BCeU/qTpZTLx5Pqo4sN5/bwTIxnm5
 lomsFNYuRbBx+ChUmkSnlMQSn3qiupMj2jzw3+9uXpWgSBiw5VggpT+henlJOgWLzAax
 ZRHiZWW6BnlpIS1OcPZ0XE+hO1WQFm1dLBayGE2EeSrvkbbjkcjND0qJBq7b0SL2lf8U
 gvdBzbMHNzdHmYgY+CzowjzltIZSDiu25TrEEhsWJsbow4ZwEWFNbSrm122TlyeySJbq
 2zWGGkzFNP05M39QSq1U/f7Kjv/h3rJwojctjoh/mIUcFEnq34ku6epMIV3unjTnfyAN aA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7aqac5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD1upP040492;
        Thu, 24 Feb 2022 13:04:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3030.oracle.com with ESMTP id 3eannxdfak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pd/LFxWARlN8+cxaUQyMxDL7X/M4/mek7n7Bfu72EleZSD7vXstLU96lBMFWzIwHaY8LTlXZiOYb48dJgxk/gGRxhmFzE80UIYmtVZwQzF56/WCQfkCXT6JAH4Julag6y2ivjRB5qwsmxzaJ8Ol5eD3Rdbdnoz3SVzMaA6ki+fUEEb9nVQZQ5Dl7vZLm0xczf/cDaazlI68nWalmaeCvck+XGXDbk9xg+6107AsBzr0kNXTF5Nu9f18JkWW7nbB6hCVWhBFy9Fw8gnTXzmhoNtNPOzrdIaDTsSAW7UIK/8+uwND/INID0xwYqjlFUalN47YBe0CSoF0P1o2UfGruaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WEavS/qhVHpasuGt81QWPC9x5tjMVGCSrPmtpGPoij0=;
 b=RuuGhpZGMiPD4ZFPoy3GO7z9zz5Az1LGQUb3mFiKsj6sgDNBcVyf/Gcn/gU51hqaFeTLNUd0dF7JzgSHOnvCI9VNVn1u/81w1/fp+oEdESQyQZ+iK7W8Goyah8ZfHI1O/WSQ2zwAmHy7+zTXwbdImPuNlFFN7j7cirpxPYBQsqYH3pTvHoYSWqcHCoWkaQD58fgQl3ZGO+jSYtsSRgkqegOZV50PnUEYA+OMh8bGNkskK+uNDCZ9T+C/cnWGZiHTYEYjqUKuZCq3tKc7cZtdxxslyziNTqtm6QRDqeEC3Xbc54JcTEOxrpfQ2q9NlPWQSuGti65xvsQIEFqrEZAbXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEavS/qhVHpasuGt81QWPC9x5tjMVGCSrPmtpGPoij0=;
 b=eurhaJxVS3Vi3ixvLfDIIX2JMLlo7t5Wt5sv5XdxOxo6IvcopmvxxBwP1qMfqwE2ye0h7Crc+TUizuPh1RqM2eFscH12qhrrYMDHzo7Qsaeh6JI4kGuputec7AJpW99mb9MIZ+V3sUdwKWP4IphegF1uk1GfqA3zP0E+HLo5g6w=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2172.namprd10.prod.outlook.com (2603:10b6:4:30::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:04:28 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V6 13/19] xfsprogs: Introduce per-inode 64-bit extent counters
Date:   Thu, 24 Feb 2022 18:33:34 +0530
Message-Id: <20220224130340.1349556-14-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 250b3293-7a13-4788-6064-08d9f796304c
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2172:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2172369802410E80FE555B37F63D9@DM5PR1001MB2172.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKxOeiGUMDPraDHIQaJehk6ZBK92npzl3IgwJS3BZUHBwk6iOaHMIboM/C7cZ4sSBn6fJR2ljJAuc9HdHzv0hmenDf02fG9OCGoMr+Fp5aolhQ1MnoRuh2HBYIDlHOptDRdAtoifI82zQJXgZTVIhdz8eXTLWkUUpdIKIu4SCr3kyUNqxY2YoWdfSYSNfWkH1otEd2Qba7957ulSqaFq5hoVWTuQu0cRd3E8WF7QnQZfSBd0EObPUae5EdYJrPoWxkEX5BuJvSfPmDAPZ7AoEmhRcjCJvuaBJ+FsvKeerVzq6iD9mUsTHElaq4x9UhGdQDHCMTDhRrqkFiN6TNag7jM9hQPvFdxZTbpy/zNsdNu0RXQjf+2hp5tAC9r6FzA2BnBtWSSs/EHkyr7qrjG71HIx8Fl3zrKYQ97R6BvBdx430hAxrqkebolMKmXPa3be+sq7bKYXZ3qLo3o5ymqxP6+KmcUa7jrZ5v1oTTp/IuOFRdy3B1+YFZCgBQOUFqJmEI/N+sObd0uWtYMr3jgaNE1MJX2H5yAYc1N7B1zw6pArv5gmo5xbiJX7Cw24GmRlAW7DqhD6c8JnzPSQQT9i1S9CeH8fW5hLfSbQBByYqEys5ZVO3JTUDhfo1xvL+498n+wNr9UHj4XUbN93RfudCAbrb+on1ewp99+y1BKajkr9/XMT80nObfTy4Wg3HCwOJ4pMAGOPY8YOX2RrZGX/rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(4326008)(508600001)(54906003)(6512007)(316002)(66946007)(66556008)(38100700002)(8676002)(66476007)(5660300002)(38350700002)(30864003)(6666004)(6506007)(52116002)(86362001)(36756003)(2616005)(1076003)(83380400001)(26005)(186003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ea25vLAXl8YhOMz3BYTsU/4hqBtl+NKac3chHH+MG2l/BkXKf7zdCK2HpI0D?=
 =?us-ascii?Q?7Qy9cA6iDBuMr/D4wMrZBvtnuWncxEemmOPjB2/mHpBB6o7SIsOnduyeKknz?=
 =?us-ascii?Q?dOtat6Bpg+0cR5quknnHZpmdtl+AQxnIwRcL0cuyFDRNmPaHEpccjB0hpz4N?=
 =?us-ascii?Q?xYEoTtuyM9JDRir81Xi4mezUkXmIhguP8EbpSoOrl4EbY90pg0x6G80eUaNU?=
 =?us-ascii?Q?zSde94M+CDYkV06Imhx5wmfxvu+YWRolyi5oArZiYC++/LaIBN5xIvXYLtZU?=
 =?us-ascii?Q?s04oxu1WVW+r9sPYNfidos35Yg6EA9ivotjdFBptxetmiuwsrYfMJL50Ap0l?=
 =?us-ascii?Q?mel9gkpobz2qbTfOYYRzCuwFwPRm3Bxh+tpJD6y/N8f/r1ZmiOQ7XEZC4FCG?=
 =?us-ascii?Q?XXFZqBzWrdqS6cDVuxSJ8qXQOZ9rfCiQ/m2ZMrB166uoVduMNllCpLTXofCE?=
 =?us-ascii?Q?PYjU5du9bQdzgxJM83sgOpTvkgH61ylBE5M5EVry3jbC9GFcxozUZI/Jn1Xa?=
 =?us-ascii?Q?ZBKZWooW3vMoEoYf+X6tiUrSPVhSe0CsXi7+EqMR3SGkMOVLyHta6giwgprt?=
 =?us-ascii?Q?nYcJ57TLAc0j+HhUXxqJCbn8M7r3dcOQRH9NphjX4296cZZBJb3BEPUkFcM5?=
 =?us-ascii?Q?KlDtVr2afB5gPmIdXjiVCCabvvfxnbNzWkCBljZimQd+Xw9vTM61zDCaKaeq?=
 =?us-ascii?Q?lxAHiVwsVMN9XReBUshGWLiHDdLE5JTdr0xKaax2P1D1NtVctiq106fu30m+?=
 =?us-ascii?Q?uX4e0YkIVaMFaR3+VhBWcQKsGPrGyOW9IrwrBoP9QSWn6MZsUMRDrp1Y0Xgp?=
 =?us-ascii?Q?eGD3pOlgkRskYSi9G/gS4CIBkGeZk3pKRKpYpSszX1HmHu9cJ6R8r06C9K2f?=
 =?us-ascii?Q?FrLQ3oddIzLDijkR/f31Krt1l2GA20YUJnr8AVSWVNo/FGCQ+yj3ktsYGokJ?=
 =?us-ascii?Q?LRu6z394lo7vQ8wMjLp8oaENQt7v9zu9fNe1aEbD/2/XLM2G1uMX5eTJpIJa?=
 =?us-ascii?Q?tIhtXRfyYQR37RXwyOnUn++sZXeZ9TZA1MGXfm8dZKo6dC9ww/2A7ziaR4BQ?=
 =?us-ascii?Q?sw+EkLxs/3VKvJNMPQiYoPQr7N3k/dKSIYnqHenzGgGu5F9lKyK3u0Itv+4W?=
 =?us-ascii?Q?ebHyYMxJAbUNLT/dDiUc/B803FvZFqMqJhu0Xp8XpHrHuT5S12v/HMaEVHga?=
 =?us-ascii?Q?VeUOEdlN9phW3mssciUa7axxzEGwlVS93mPfrJM6jij6+aMY5T+s6OYZslpk?=
 =?us-ascii?Q?5m/Sc9dRtTF6FUW2WdbF/AwvWoDwQgR0mpl2IDFRwRG341Q3JuD9sZtF4aDa?=
 =?us-ascii?Q?0RcqDoRsMZoqXXhFNRiWwIQjhTo2b9a3r5Vh+7RPifng5raspzmGo4spJU7u?=
 =?us-ascii?Q?OfLbrewLMnxGP4FeLCiO1FUBOmlFtw0KwFILgHvQErzQ/aPFG/W2kcrSf/JT?=
 =?us-ascii?Q?bXwKcFDDeS05Ii10SR/tOFCr32RtgXTh/QqJdG0LwcerbmoxN+1iK/iuL61V?=
 =?us-ascii?Q?rCVubISML9mT49LhESZzX4kR0Nuu2Fb7+mDX7virw5Iwr3Ae2bFsl5FIH8UQ?=
 =?us-ascii?Q?KbWeEpoAP9PRvcLBWI5VYah5jL7CEV5DonqdJLLlkPjySR4rCs4ki+CNO7qb?=
 =?us-ascii?Q?z9Sya/XKuWt62EXFPNhqby0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 250b3293-7a13-4788-6064-08d9f796304c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:28.8359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0UnGKJ4cCdMIxg3tmQvTPqJuoEWyobDcw0eHu7zNeBwY24tm4nytYEv0kEMUGEOnfmzsy5h0tqerdyuO9h/P3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2172
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: IIIQHQyioOhsRx-xgi8Bf_5Lb1Be725y
X-Proofpoint-ORIG-GUID: IIIQHQyioOhsRx-xgi8Bf_5Lb1Be725y
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces new fields in the on-disk inode format to support
64-bit data fork extent counters and 32-bit attribute fork extent
counters. The new fields will be used only when an inode has
XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
data fork extent counters and 16-bit attribute fork extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 db/field.c               |   4 -
 db/field.h               |   2 -
 db/inode.c               | 205 ++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_format.h      |  33 ++++++-
 libxfs/xfs_inode_buf.c   |  49 +++++++++-
 libxfs/xfs_inode_fork.h  |   6 ++
 libxfs/xfs_log_format.h  |  33 ++++++-
 logprint/log_misc.c      |  20 +++-
 logprint/log_print_all.c |  18 +++-
 repair/dinode.c          |  18 +++-
 10 files changed, 356 insertions(+), 32 deletions(-)

diff --git a/db/field.c b/db/field.c
index 0a089b56..e2da7a6f 100644
--- a/db/field.c
+++ b/db/field.c
@@ -25,8 +25,6 @@
 #include "symlink.h"
 
 const ftattr_t	ftattrtab[] = {
-	{ FLDT_AEXTNUM, "aextnum", fp_num, "%d", SI(bitsz(xfs_aextnum_t)),
-	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_AGBLOCK, "agblock", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
 	  FTARG_DONULL, fa_agblock, NULL },
 	{ FLDT_AGBLOCKNZ, "agblocknz", fp_num, "%u", SI(bitsz(xfs_agblock_t)),
@@ -300,8 +298,6 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_DONULL, fa_drtbno, NULL },
 	{ FLDT_EXTLEN, "extlen", fp_num, "%u", SI(bitsz(xfs_extlen_t)), 0, NULL,
 	  NULL },
-	{ FLDT_EXTNUM, "extnum", fp_num, "%d", SI(bitsz(xfs_extnum_t)),
-	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_FSIZE, "fsize", fp_num, "%lld", SI(bitsz(xfs_fsize_t)),
 	  FTARG_SIGNED, NULL, NULL },
 	{ FLDT_INO, "ino", fp_num, "%llu", SI(bitsz(xfs_ino_t)), FTARG_DONULL,
diff --git a/db/field.h b/db/field.h
index 387c189e..614fd0ab 100644
--- a/db/field.h
+++ b/db/field.h
@@ -5,7 +5,6 @@
  */
 
 typedef enum fldt	{
-	FLDT_AEXTNUM,
 	FLDT_AGBLOCK,
 	FLDT_AGBLOCKNZ,
 	FLDT_AGF,
@@ -143,7 +142,6 @@ typedef enum fldt	{
 	FLDT_DRFSBNO,
 	FLDT_DRTBNO,
 	FLDT_EXTLEN,
-	FLDT_EXTNUM,
 	FLDT_FSIZE,
 	FLDT_INO,
 	FLDT_INOBT,
diff --git a/db/inode.c b/db/inode.c
index a9e6cc70..1717940d 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -27,6 +27,16 @@ static int	inode_core_nlinkv2_count(void *obj, int startoff);
 static int	inode_core_onlink_count(void *obj, int startoff);
 static int	inode_core_projid_count(void *obj, int startoff);
 static int	inode_core_nlinkv1_count(void *obj, int startoff);
+static int	inode_core_v3_pad_count(void *obj, int startoff);
+static int	inode_core_v2_pad_count(void *obj, int startoff);
+static int	inode_core_flushiter_count(void *obj, int startoff);
+static int	inode_core_nrext64_pad_count(void *obj, int startoff);
+static int	inode_core_nextents_offset(void *obj, int startoff, int idx);
+static int	inode_core_nextents32_count(void *obj, int startoff);
+static int	inode_core_nextents64_count(void *obj, int startoff);
+static int	inode_core_anextents_offset(void *obj, int startoff, int idx);
+static int	inode_core_anextents16_count(void *obj, int startoff);
+static int	inode_core_anextents32_count(void *obj, int startoff);
 static int	inode_f(int argc, char **argv);
 static int	inode_u_offset(void *obj, int startoff, int idx);
 static int	inode_u_bmbt_count(void *obj, int startoff);
@@ -90,18 +100,30 @@ const field_t	inode_core_flds[] = {
 	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
 	{ "projid_hi", FLDT_UINT16D, OI(COFF(projid_hi)),
 	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
-	{ "pad", FLDT_UINT8X, OI(OFF(pad)), CI(6), FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
+	{ "v3_pad", FLDT_UINT64D, OI(OFF(v3_pad)),
+	  inode_core_v3_pad_count, FLD_COUNT|FLD_SKIPALL, TYP_NONE },
+	{ "v2_pad", FLDT_UINT8X, OI(OFF(v2_pad)),
+	  inode_core_v2_pad_count, FLD_ARRAY|FLD_COUNT|FLD_SKIPALL, TYP_NONE },
 	{ "uid", FLDT_UINT32D, OI(COFF(uid)), C1, 0, TYP_NONE },
 	{ "gid", FLDT_UINT32D, OI(COFF(gid)), C1, 0, TYP_NONE },
-	{ "flushiter", FLDT_UINT16D, OI(COFF(flushiter)), C1, 0, TYP_NONE },
+	{ "flushiter", FLDT_UINT16D, OI(COFF(flushiter)),
+	  inode_core_flushiter_count, FLD_COUNT, TYP_NONE },
 	{ "atime", FLDT_TIMESTAMP, OI(COFF(atime)), C1, 0, TYP_NONE },
 	{ "mtime", FLDT_TIMESTAMP, OI(COFF(mtime)), C1, 0, TYP_NONE },
 	{ "ctime", FLDT_TIMESTAMP, OI(COFF(ctime)), C1, 0, TYP_NONE },
 	{ "size", FLDT_FSIZE, OI(COFF(size)), C1, 0, TYP_NONE },
 	{ "nblocks", FLDT_DRFSBNO, OI(COFF(nblocks)), C1, 0, TYP_NONE },
 	{ "extsize", FLDT_EXTLEN, OI(COFF(extsize)), C1, 0, TYP_NONE },
-	{ "nextents", FLDT_EXTNUM, OI(COFF(nextents)), C1, 0, TYP_NONE },
-	{ "naextents", FLDT_AEXTNUM, OI(COFF(anextents)), C1, 0, TYP_NONE },
+	{ "nrext64_pad", FLDT_UINT16D, OI(COFF(nrext64_pad)),
+	  inode_core_nrext64_pad_count, FLD_COUNT|FLD_SKIPALL, TYP_NONE },
+	{ "nextents", FLDT_UINT32D, inode_core_nextents_offset,
+	  inode_core_nextents32_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "nextents", FLDT_UINT64D, inode_core_nextents_offset,
+	  inode_core_nextents64_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "naextents", FLDT_UINT16D, inode_core_anextents_offset,
+	  inode_core_anextents16_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ "naextents", FLDT_UINT32D, inode_core_anextents_offset,
+	  inode_core_anextents32_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
 	{ "forkoff", FLDT_UINT8D, OI(COFF(forkoff)), C1, 0, TYP_NONE },
 	{ "aformat", FLDT_DINODE_FMT, OI(COFF(aformat)), C1, 0, TYP_NONE },
 	{ "dmevmask", FLDT_UINT32X, OI(COFF(dmevmask)), C1, 0, TYP_NONE },
@@ -403,6 +425,181 @@ inode_core_projid_count(
 	return dic->di_version >= 2;
 }
 
+static int
+inode_core_v3_pad_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if ((dic->di_version == 3)
+		&& !(dic->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64)))
+		return 1;
+
+	return 0;
+}
+
+static int
+inode_core_v2_pad_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (dic->di_version == 3)
+		return 0;
+
+	return 6;
+}
+
+static int
+inode_core_flushiter_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (dic->di_version == 3)
+		return 0;
+
+	return 1;
+}
+
+static int
+inode_core_nrext64_pad_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return 1;
+
+	return 0;
+}
+
+static int
+inode_core_nextents_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(idx == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return COFF(big_nextents);
+
+	return COFF(nextents);
+}
+
+static int
+inode_core_nextents32_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return 0;
+
+	return 1;
+}
+
+static int
+inode_core_nextents64_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return 1;
+
+	return 0;
+}
+
+static int
+inode_core_anextents_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(idx == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return COFF(big_anextents);
+
+	return COFF(anextents);
+}
+
+static int
+inode_core_anextents16_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return 0;
+
+	return 1;
+}
+
+static int
+inode_core_anextents32_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_dinode	*dic;
+
+	ASSERT(startoff == 0);
+	ASSERT(obj == iocur_top->data);
+	dic = obj;
+
+	if (xfs_dinode_has_nrext64(dic))
+		return 1;
+
+	return 0;
+}
+
 static int
 inode_f(
 	int		argc,
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d3dfd45c..1a5b194d 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -792,16 +792,41 @@ struct xfs_dinode {
 	__be32		di_nlink;	/* number of links to file */
 	__be16		di_projid_lo;	/* lower part of owner's project id */
 	__be16		di_projid_hi;	/* higher part owner's project id */
-	__u8		di_pad[6];	/* unused, zeroed space */
-	__be16		di_flushiter;	/* incremented on flush */
+	union {
+		/* Number of data fork extents if NREXT64 is set */
+		__be64	di_big_nextents;
+
+		/* Padding for V3 inodes without NREXT64 set. */
+		__be64	di_v3_pad;
+
+		/* Padding and inode flush counter for V2 inodes. */
+		struct {
+			__u8	di_v2_pad[6];
+			__be16	di_flushiter;
+		};
+	};
 	xfs_timestamp_t	di_atime;	/* time last accessed */
 	xfs_timestamp_t	di_mtime;	/* time last modified */
 	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
 	__be64		di_size;	/* number of bytes in file */
 	__be64		di_nblocks;	/* # of direct & btree blocks used */
 	__be32		di_extsize;	/* basic/minimum extent size for file */
-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	union {
+		/*
+		 * For V2 inodes and V3 inodes without NREXT64 set, this
+		 * is the number of data and attr fork extents.
+		 */
+		struct {
+			__be32	di_nextents;
+			__be16	di_anextents;
+		} __packed;
+
+		/* Number of attr fork extents if NREXT64 is set. */
+		struct {
+			__be32	di_big_anextents;
+			__be16	di_nrext64_pad;
+		} __packed;
+	} __packed;
 	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	__s8		di_aformat;	/* format of attr fork's data */
 	__be32		di_dmevmask;	/* DMIG event mask */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index b3f6be93..caf42f66 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -276,6 +276,25 @@ xfs_inode_to_disk_ts(
 	return ts;
 }
 
+static inline void
+xfs_inode_to_disk_iext_counters(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*to)
+{
+	if (xfs_inode_has_nrext64(ip)) {
+		to->di_big_nextents = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
+		to->di_big_anextents = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
+		/*
+		 * We might be upgrading the inode to use larger extent counters
+		 * than was previously used. Hence zero the unused field.
+		 */
+		to->di_nrext64_pad = cpu_to_be16(0);
+	} else {
+		to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
+		to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
+	}
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -293,7 +312,6 @@ xfs_inode_to_disk(
 	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
 
-	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
 	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
 	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
@@ -304,8 +322,6 @@ xfs_inode_to_disk(
 	to->di_size = cpu_to_be64(ip->i_disk_size);
 	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
-	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
-	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
@@ -320,11 +336,14 @@ xfs_inode_to_disk(
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
-		to->di_flushiter = 0;
+		to->di_v3_pad = 0;
 	} else {
 		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
+		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
 	}
+
+	xfs_inode_to_disk_iext_counters(ip, to);
 }
 
 static xfs_failaddr_t
@@ -394,6 +413,24 @@ xfs_dinode_verify_forkoff(
 	return NULL;
 }
 
+static xfs_failaddr_t
+xfs_dinode_verify_nrext64(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	if (xfs_dinode_has_nrext64(dip)) {
+		if (!xfs_has_nrext64(mp))
+			return __this_address;
+		if (dip->di_nrext64_pad != 0)
+			return __this_address;
+	} else if (dip->di_version >= 3) {
+		if (dip->di_v3_pad != 0)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 xfs_failaddr_t
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
@@ -437,6 +474,10 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	fa = xfs_dinode_verify_nrext64(mp, dip);
+	if (fa)
+		return fa;
+
 	nextents = xfs_dfork_data_extents(dip);
 	nextents += xfs_dfork_attr_extents(dip);
 	nblocks = be64_to_cpu(dip->di_nblocks);
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index e5680343..8e6221e3 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -156,6 +156,9 @@ static inline xfs_extnum_t
 xfs_dfork_data_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_nrext64(dip))
+		return be64_to_cpu(dip->di_big_nextents);
+
 	return be32_to_cpu(dip->di_nextents);
 }
 
@@ -163,6 +166,9 @@ static inline xfs_extnum_t
 xfs_dfork_attr_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_nrext64(dip))
+		return be32_to_cpu(dip->di_big_anextents);
+
 	return be16_to_cpu(dip->di_anextents);
 }
 
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index fd66e702..12234a88 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -388,16 +388,41 @@ struct xfs_log_dinode {
 	uint32_t	di_nlink;	/* number of links to file */
 	uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	uint16_t	di_projid_hi;	/* higher part of owner's project id */
-	uint8_t		di_pad[6];	/* unused, zeroed space */
-	uint16_t	di_flushiter;	/* incremented on flush */
+	union {
+		/* Number of data fork extents if NREXT64 is set */
+		uint64_t	di_big_nextents;
+
+		/* Padding for V3 inodes without NREXT64 set. */
+		uint64_t	di_v3_pad;
+
+		/* Padding and inode flush counter for V2 inodes. */
+		struct {
+			uint8_t	di_v2_pad[6];	/* V2 inode zeroed space */
+			uint16_t di_flushiter;	/* V2 inode incremented on flush */
+		};
+	};
 	xfs_log_timestamp_t di_atime;	/* time last accessed */
 	xfs_log_timestamp_t di_mtime;	/* time last modified */
 	xfs_log_timestamp_t di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	uint32_t	di_nextents;	/* number of extents in data fork */
-	uint16_t	di_anextents;	/* number of extents in attribute fork*/
+	union {
+		/*
+		 * For V2 inodes and V3 inodes without NREXT64 set, this
+		 * is the number of data and attr fork extents.
+		 */
+		struct {
+			uint32_t  di_nextents;
+			uint16_t  di_anextents;
+		} __packed;
+
+		/* Number of attr fork extents if NREXT64 is set. */
+		struct {
+			uint32_t  di_big_anextents;
+			uint16_t  di_nrext64_pad;
+		} __packed;
+	} __packed;
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 35e926a3..95fb22a6 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -440,6 +440,8 @@ static void
 xlog_print_trans_inode_core(
 	struct xfs_log_dinode	*ip)
 {
+    xfs_extnum_t		nextents;
+
     printf(_("INODE CORE\n"));
     printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
 	   ip->di_magic, ip->di_mode, (int)ip->di_version,
@@ -450,11 +452,21 @@ xlog_print_trans_inode_core(
 		xlog_extract_dinode_ts(ip->di_atime),
 		xlog_extract_dinode_ts(ip->di_mtime),
 		xlog_extract_dinode_ts(ip->di_ctime));
-    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%x\n"),
+
+    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
+	    nextents = ip->di_big_nextents;
+    else
+	    nextents = ip->di_nextents;
+    printf(_("size 0x%llx nblocks 0x%llx extsize 0x%x nextents 0x%lx\n"),
 	   (unsigned long long)ip->di_size, (unsigned long long)ip->di_nblocks,
-	   ip->di_extsize, ip->di_nextents);
-    printf(_("naextents 0x%x forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
-	   ip->di_anextents, (int)ip->di_forkoff, ip->di_dmevmask,
+	   ip->di_extsize, nextents);
+
+    if (ip->di_flags2 & XFS_DIFLAG2_NREXT64)
+	    nextents = ip->di_big_anextents;
+    else
+	    nextents = ip->di_anextents;
+    printf(_("naextents 0x%lx forkoff %d dmevmask 0x%x dmstate 0x%hx\n"),
+	   nextents, (int)ip->di_forkoff, ip->di_dmevmask,
 	   ip->di_dmstate);
     printf(_("flags 0x%x gen 0x%x\n"),
 	   ip->di_flags, ip->di_gen);
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 182b9d53..73ffc2f0 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -240,7 +240,10 @@ STATIC void
 xlog_recover_print_inode_core(
 	struct xfs_log_dinode	*di)
 {
-	printf(_("	CORE inode:\n"));
+	xfs_extnum_t		nextents;
+	xfs_aextnum_t		anextents;
+
+        printf(_("	CORE inode:\n"));
 	if (!print_inode)
 		return;
 	printf(_("		magic:%c%c  mode:0x%x  ver:%d  format:%d\n"),
@@ -254,10 +257,19 @@ xlog_recover_print_inode_core(
 			xlog_extract_dinode_ts(di->di_mtime),
 			xlog_extract_dinode_ts(di->di_ctime));
 	printf(_("		flushiter:%d\n"), di->di_flushiter);
+
+	if (di->di_flags2 & XFS_DIFLAG2_NREXT64) {
+		nextents = di->di_big_nextents;
+		anextents = di->di_big_anextents;
+	} else {
+		nextents = di->di_nextents;
+		anextents = di->di_anextents;
+	}
+
 	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
-	     "nextents:%d  anextents:%d\n"), (unsigned long long)
+	     "nextents:%lu  anextents:%u\n"), (unsigned long long)
 	       di->di_size, (unsigned long long)di->di_nblocks,
-	       di->di_extsize, di->di_nextents, (int)di->di_anextents);
+	       di->di_extsize, nextents, anextents);
 	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "
 	     "gen:%u\n"),
 	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
diff --git a/repair/dinode.c b/repair/dinode.c
index 54efe571..bf1ee26d 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -71,7 +71,12 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	if (xfs_dfork_attr_extents(dino) != 0) {
 		if (no_modify)
 			return(1);
-		dino->di_anextents = cpu_to_be16(0);
+
+		if (xfs_dinode_has_nrext64(dino))
+			dino->di_big_anextents = 0;
+		else
+			dino->di_anextents = 0;
+
 	}
 
 	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
@@ -1818,7 +1823,10 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
-			dino->di_nextents = cpu_to_be32(nextents);
+			if (xfs_dinode_has_nrext64(dino))
+				dino->di_big_nextents = cpu_to_be64(nextents);
+			else
+				dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
@@ -1841,7 +1849,11 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
-			dino->di_anextents = cpu_to_be16(anextents);
+			if (xfs_dinode_has_nrext64(dino))
+				dino->di_big_anextents = cpu_to_be32(anextents);
+			else
+				dino->di_anextents = cpu_to_be16(anextents);
+
 			*dirty = 1;
 		} else  {
 			do_warn(
-- 
2.30.2

