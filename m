Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C35C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344400AbiCUFWq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242087AbiCUFWo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DD13B556
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:18 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KIsrEK027768;
        Mon, 21 Mar 2022 05:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=mBB4126DBIwNC5+JWghDYY4/Iixpi49tmwSHtRR+i7A=;
 b=VLkUKuo6SL8KDkEikspdXy7rGPDYC9Ah1QnBnIgkjD/lQsPuYk9EDpp0J9OKJUpPq1h3
 KxE/Y6PCYHyXzlHbWHn2IQkYIJ6GuWvqKVhyPlJxKnqfktxuryUEwBb9C+XPAjB9kNTq
 lFiNFj3sWS3yhF0v7KgyEVSXN3FLJXUStn6MQfNjdp/mY2TAFmpwxDcWrVLdQhQ07+OL
 avbNGNEWxfeXatyGZvZnS+3Twgt0tDKah9RR2i2pumk6bejx01TEgZ8m2Hr0YKHuSg+k
 Uoc58LjS2MfXv/xy1WAa2uR+sSZZY4PmciHDRn/2cZhU+Bgw6iN8+/PH9ISOsCx3ru4K +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y1t4t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5LBLe096794;
        Mon, 21 Mar 2022 05:21:11 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3030.oracle.com with ESMTP id 3ew49r2h3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0Vv1bRZ0IjQlYM2xZFMpBa4j6fK6owF2rp/3kn5PVdbebyXDbBZ900d4L/trvxBLbi/WV/DYuMB5orApArCGG4EYPsEtU/b1fUHJmLg+qsYqE7OKVGb5zBxT2dhYYtUpDZztssyU75IzSP5TwnxsPmE+LSv1PRlLzjRi1Fc5grDX2Z+NxiN/B1V6G+26+pBtYeqzNG8MOpEIc/DMNhbNPcvt85schDP2apM2QPYXCuKebn+pjXrAdvBIKB5o9uHh4O3rDAGrk3+a2nOMP8t9IUMY/hXayadMknGMhjfWPEuRm/ai/pkuVVzAKyNOqJ+qP3v7LVtEdfknbbu104Gmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBB4126DBIwNC5+JWghDYY4/Iixpi49tmwSHtRR+i7A=;
 b=Ka+93qeEmlbEq4z1LYqok5fFzjcsNVKChkKoXYeUrtp37GhFsZ9ivB67Xf/utgCP8xPADhfse8SQWK9FXEyxRYSjMoh5rU0iY6ddxqWiyYSKtDzuroDM/4Rne8AAzMZxV7kTwPl5dbE6rDpPJ9x5UYVb8Kb+NRzWFwO+wgaLmZr5vmNqCwD23QzzfurFnAsExnSY5A4Ol1529M+MO/m2An5SLi72Ry8UscRHGNAYTKoSbUQWuPhpb6UUnylgzbdXTyuwX8LNXazK/e5FRU9/59fJNaMPz4QNF6wSsj1eky9YlNojhnlDySSfW8q4zPaSRCNUCNvwsJPzjWM6KgpCrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBB4126DBIwNC5+JWghDYY4/Iixpi49tmwSHtRR+i7A=;
 b=x9T/71duLNERKg+u72KkieGPmNSWmpZfMFJmYpQxfyHsNVaY+5uD+oxZsqC0+EU54Zy82PyhUkgY9IYisIptqZgQXNexlDnGJEirDnFyS9vLhPZst/Gt9wr61CNp2g212QM9DiDe2c6+WP6DG6ekGUzWckVJLg5BtTd24dGGQaE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:21:09 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:21:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V7 13/18] xfsprogs: Introduce per-inode 64-bit extent counters
Date:   Mon, 21 Mar 2022 10:50:22 +0530
Message-Id: <20220321052027.407099-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c63ae33-4249-402d-572b-08da0afa9b46
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55634F453C7A2745FDD77044F6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k9wuKgY+7jy28xFOWU0og4jkIDIS80S1imR8tieT3WJbU+bP4KDaCUCK4QEtATkMWmMy9Q4FMwZqLwje9EEZOyiwkIO7sYFgmNM0+fF1/8d9RHMgDYG5+ySLem6JqHHDO712jDHx6IZxGlFVnOpOKR4ZVCrsHiTY842maHfn+w/116kzAF1Ok2EUlXdvlAXGZ8nshMyjyYmeMMOBC2mcWvt0YXLv+DI/ZdzaZlmyWuqnYybs2txi29HKMo6nRqR9ba+6vab9W2BGi3Ydv+7zUbVm/CZYgCrNpriKf4HZ3lX/H0TafjxW4S2UuevAMYiX7kFhuJ99C6/dDblgwoLrsjEmbgvsq6l7I4HGlwGf7FfsQoDB57xo2EcdkgQHmbfMlAlRT83hu0Q6/4NfuaLgLyLfh4hvQarV7DE+EukvT1Aheq+kzTp3n5YsytJEViqjjt56aZzDPK8TuaDS4HVYvsYS55mevZarwIwRPkFgEcMekhsBAFhboTTF7CyAYOeMwFhDsKfLTc45lXGmV6Z6ny0yEYA/lXG8JmEcy93cOlnQj1RpoNwcVYYGAkDGYNGyZA4YbOuI15zK6kSeLIVgR5yU3vm6SmtyIUlAqIbmQ2hE3uh+lNCx6IrlkMxzDjPCPBgAPXn0Owo6v2veYBzVbzem3hDaHa2rSwh7699OG+1gWe8Gx4DDTjPrhHx6/QstN4iTMTpEVsm8tWnq/1s6Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(54906003)(5660300002)(8936002)(508600001)(8676002)(4326008)(30864003)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tvUXOTeoROMys9xCEjrhi0uMYhb+uSl8tDjXQvQ8zX74UCDtpSZakcMQzPZ2?=
 =?us-ascii?Q?6507TBGAB8oC4kC0kqdnNA9e2ZcU7+5+JvsvKVGbBQAl7YSM+MAmFpPhU59T?=
 =?us-ascii?Q?lclpdNeHg8pWdcGkd2+KDYTPAoyuZ3jy7yhT0maWMpn594MpDdrfCd8FIZm5?=
 =?us-ascii?Q?LZHOIkr2FZHBSYA8IF1yopCyG2KVov2ik4QkK3wlmQ5hXgqzM/soirLE7BIf?=
 =?us-ascii?Q?h6ui4IHn2Y3on8IvHqrtpkPrEQRwL0Fy4Ec2WQ7YlSxHd3psygXCWA2T5m2y?=
 =?us-ascii?Q?gHBk/RgS5ZZsQ4cOFRaiREOlAEaZIpvBy62rFDplJgk4NpAShN+OXfdjH3D2?=
 =?us-ascii?Q?aBAQWZl7ansCOV3UBkrcuzfUNvGk59wYWZde7Cp35Y4siqXoURSGyhRnP5tJ?=
 =?us-ascii?Q?UGuj5ZLAgbHG72GZEpFgBNd1OrsIkRXE1ZuevsVXOJ8oD3Hti17IkJxJXUbz?=
 =?us-ascii?Q?J4npSv+bie5/cJ66LeNYBW7MlX3vHKlaEtf2hJqhtFNSuWYsKGQG06MaV3ry?=
 =?us-ascii?Q?zuAQTeROqs93+VopE9irKkpC4H43DH8dmO2/KQz9XdQJlaeCVBOyAD3Kd90J?=
 =?us-ascii?Q?3UtpXASrpbIeROVlqWonEQ/kePHOi0NXZ+UKT+jIY06Zd5hItU6Zh6fieWYg?=
 =?us-ascii?Q?ZWMiTPFWkr7cM4rfT6qFA1MWW/DpnheNqfmxtcUz/myujZ5/fhFwUW/xL+Pu?=
 =?us-ascii?Q?OhYc+kRo7f1htoM45rE5YUC/UaxXiP+nyr+m7HQXXQrOCLJp6LuF+kmClFq5?=
 =?us-ascii?Q?bxn2kWWhk+tmnedEV6He9neVPherzCTt+++p6O+Hqgm7KRdO/dCxkxJqRPn7?=
 =?us-ascii?Q?9KWjiMwzkYUXS46b5Y7YSNRkFKgX4RM94llS0CX8glrWAGMdwSD7ntjD1mPu?=
 =?us-ascii?Q?5nKxJpO3eVJjtBa0wjhVGtqsJVCViuFJYuFvm/TUrmqnjR9HIUDt0+PjHVQw?=
 =?us-ascii?Q?JmCVxObOwwVIqP9uags/1/7CBTZ3slE+ELXNnzOnBKhzRQCpHLYHgNpI2IZR?=
 =?us-ascii?Q?v6rGXRFLzfHNA6mMo5FSyIZ5RnkQomP/F5iutisgnVxmLIjdJZVWOwtAjrFj?=
 =?us-ascii?Q?R1873AiZS/Mf38tjAb07cBuQlHXONb8uM9rR+fECchdjQp0vVGZUHd2urFFg?=
 =?us-ascii?Q?q4b3bf3wDR8qgZeDDwK/I9q5m6kbLPCgJl1XULjkppxdSUU9i/E0R8YRIZNE?=
 =?us-ascii?Q?VESaH5w58k9XeNGphHFCwbGUCK7cFKfhquqS+3ZPQZVYvjM03AY8Qi/L2vDv?=
 =?us-ascii?Q?gycUC41J0x0IijKHkC1Lz5ljRWXzrpB/D3XHb1ebl6VsS6XNj35ZLtqZmasC?=
 =?us-ascii?Q?BVyXkYxgC2bm7V9m30cOHYwdq49KlsCFUoKv5nFreb7y+LOsLRCmTXQVi5Fj?=
 =?us-ascii?Q?IMNWSj0B1DBBtgSrf7X6mQvhC8BCyFybjdIrTMDE9VpdVocgyCnc0U8qFZ68?=
 =?us-ascii?Q?fRZ7F/XbpKhyHXD1BTjpeucpVuaGa5GqdYj2KE4oB9UK6l4EYakBBg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c63ae33-4249-402d-572b-08da0afa9b46
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:21:09.2026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lr4KADjoHEeBX9DUqglTH+JwaH3iVo1xVdRzu2ttQMy6oyk1HGSD1lWbAlz0aXqtUYn5cfTQ72IrT6eO1DFycQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-GUID: f7Fj2sofZnNsbLGFyl7b9j7Cx5JPfaXs
X-Proofpoint-ORIG-GUID: f7Fj2sofZnNsbLGFyl7b9j7Cx5JPfaXs
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
index a9e6cc70..a152bec5 100644
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
+	if (xfs_dinode_has_large_extent_counts(dic))
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
+	if (xfs_dinode_has_large_extent_counts(dic))
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
+	if (xfs_dinode_has_large_extent_counts(dic))
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
+	if (xfs_dinode_has_large_extent_counts(dic))
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
+	if (xfs_dinode_has_large_extent_counts(dic))
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
+	if (xfs_dinode_has_large_extent_counts(dic))
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
+	if (xfs_dinode_has_large_extent_counts(dic))
+		return 1;
+
+	return 0;
+}
+
 static int
 inode_f(
 	int		argc,
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index da3cd6e7..3a8359cf 100644
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
index d4b969c6..8159a3f4 100644
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
+	if (xfs_inode_has_large_extent_counts(ip)) {
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
@@ -395,6 +414,24 @@ xfs_dinode_verify_forkoff(
 	return NULL;
 }
 
+static xfs_failaddr_t
+xfs_dinode_verify_nrext64(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	if (xfs_dinode_has_large_extent_counts(dip)) {
+		if (!xfs_has_large_extent_counts(mp))
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
@@ -439,6 +476,10 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	fa = xfs_dinode_verify_nrext64(mp, dip);
+	if (fa)
+		return fa;
+
 	nextents = xfs_dfork_data_extents(dip);
 	naextents = xfs_dfork_attr_extents(dip);
 	nblocks = be64_to_cpu(dip->di_nblocks);
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 623049ac..5f2d701c 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -156,6 +156,9 @@ static inline xfs_extnum_t
 xfs_dfork_data_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_large_extent_counts(dip))
+		return be64_to_cpu(dip->di_big_nextents);
+
 	return be32_to_cpu(dip->di_nextents);
 }
 
@@ -163,6 +166,9 @@ static inline xfs_extnum_t
 xfs_dfork_attr_extents(
 	struct xfs_dinode	*dip)
 {
+	if (xfs_dinode_has_large_extent_counts(dip))
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
index f0a2b32a..06784dc6 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -71,7 +71,12 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	if (xfs_dfork_attr_extents(dino) != 0) {
 		if (no_modify)
 			return(1);
-		dino->di_anextents = cpu_to_be16(0);
+
+		if (xfs_dinode_has_large_extent_counts(dino))
+			dino->di_big_anextents = 0;
+		else
+			dino->di_anextents = 0;
+
 	}
 
 	if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS)  {
@@ -1819,7 +1824,10 @@ _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting nextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, nextents);
-			dino->di_nextents = cpu_to_be32(nextents);
+			if (xfs_dinode_has_large_extent_counts(dino))
+				dino->di_big_nextents = cpu_to_be64(nextents);
+			else
+				dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
 			do_warn(
@@ -1843,7 +1851,11 @@ _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			do_warn(
 _("correcting anextents for inode %" PRIu64 ", was %lu - counted %" PRIu64 "\n"),
 				lino, dnextents, anextents);
-			dino->di_anextents = cpu_to_be16(anextents);
+			if (xfs_dinode_has_large_extent_counts(dino))
+				dino->di_big_anextents = cpu_to_be32(anextents);
+			else
+				dino->di_anextents = cpu_to_be16(anextents);
+
 			*dirty = 1;
 		} else  {
 			do_warn(
-- 
2.30.2

