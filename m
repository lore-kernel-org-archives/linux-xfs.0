Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1FEDC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344287AbiCUFUC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344376AbiCUFUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E97344CA
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KL409h012459;
        Mon, 21 Mar 2022 05:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ZFdypuEB4RaPAAnqyb1cr2a4tcpFwv2bZU95gk0DLjY=;
 b=l1sidCNMLYN6ujYPq5pG1WOswp1gSqTpSQtiB1GUq05TBAiz7JMcH0Lgi3rZNcvgGhre
 4yTmgfQfSzvlilBBrqIBcaXHXFZQ5mYsvfOUlpseV+M+JvYfZ0wu13TJi0SoffffS4y3
 qK5oEvIj1LkBSNCp4rCe7vzM5qOH/XfnPIsqvA6lvzmYv5JVokvA3MhyfZI/H3o/L8d7
 DAVYWS8FKl2TMWMTlhV7eM9FkjK1v1+elV9gv75+J6bUgk7C54WLYiqxhgvaJddS8r1o
 c1XBCkg9XYRGW7n67k0/ym9kfFRb3WfpItjfy56ylflsEntyympiPiPf8Rpwc/m217V3 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss23gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5IS4S092668;
        Mon, 21 Mar 2022 05:18:28 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by userp3030.oracle.com with ESMTP id 3ew49r2gyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibB5LdNxWuUmkvI1Zrrn+jPBtc7kh3IlstW6Bzqvs454dWcjPH9wjDkKGwO1pKnXHFyPvk9KCyxu4LZJvu85b4V7GJqP6wziGAVYAN10PhLXXszo4NTpj95x4b53sjOs6rIz7tmnJOa2G5F7e50jCz9WX6LyXVu8QETrfa+uYFt6Y9/pO6xXUSrtVwUsIauq59louJLgWPxi8WB2sg1kC2+MfVXoSdB1I9nvkVf/5E24LEFA9MvIUgkmtafZyY78nTSD16WKzZsBMirVenSZmuoos0EYFLddRGChKuByIDMsDdoyz7vN8X/XNPM1iE19PXSjeAZy8vk1aeXE6x+1nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFdypuEB4RaPAAnqyb1cr2a4tcpFwv2bZU95gk0DLjY=;
 b=Shxlpzh10ISfL3XiQJM+9i+uL6OyHy2DQorRmtVjBhOQpnPOzS9ounv4Ym/pK7zJCg00DEoTEgVhrv5uBkcCS/+CCsNrhzMBUqZyM1STGQGxUkuKqPMvJgspN7zg3Z2CKAnltNndbBjwwbAhXPkFRjL6ohOo50FQXl2zLfaULNNNaD/a6yzZitCaJJbV7DqnoQU/sAc4pa1T0x6cpYmXYEMaCBV/LRcLL9Oy18IhTJXedd5j5Rm3/Ai0+fPrskvtg90ZAlUQwc3/xTxZkA59DRCfGys3XdP0Pj2do2ET6EbWNXXOoNzZtdHGcXcr1IUEiejsjJ3mR6cpuidmpJFr9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFdypuEB4RaPAAnqyb1cr2a4tcpFwv2bZU95gk0DLjY=;
 b=MDihO6IiyyxdWCVJdfFTsQqS/ESiRXr0rbIJZ8uU3o7xy1Kg3jDMdlfVsaWD44ImOD4KHHxVy1hGgmsjf0MJZE+yWhNbTFEOXtlooTKLJyaNdrI0NIgOFPLReo4kij5Om6DlwCG7xMI6r+YVwebLlicbgUu8rGDdoFHxMt9I3SI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:26 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:26 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, kernel test robot <lkp@intel.com>
Subject: [PATCH V8 07/19] xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Mon, 21 Mar 2022 10:47:38 +0530
Message-Id: <20220321051750.400056-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9679942-5850-47ef-7d06-08da0afa3a66
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB55377CAAAFE33F2DD6BF7FB2F6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hnTeirEbw2bYYwahslog/8fMIHWKgBcTsb5bB5jp5A5SbEbYWZm2BteoA8Y7DgS9lOsPflLPJl5xrLhUo1SALMTnoL3oAG7sjbnYFUcbWEAFs+7bWPVr5AoljO4WuB3C79Ov+8SUQMBQtrGO5NK5vi0HTj7GD+unpMTM/GU9thu9l1ucEp+IWGeQsdht9bqUl0Y+CQEAqzNstSia4pCZqc4T0UsMEhVcJLhybTV62MKKkHHcksdeJj8oBJsdvIXAEr+utYTY6sewAve81QwcPowGrQApo/0BTLIWNLDYc81sEwlolLzfIEFFYPN08AOcooRlQq0V1RgBCpsB7BfLCA/d4CaiCODfP0jAoE5FmPyQpcijnc4EPpz7KJk3eFNSMmWvObE+IfzMEzeka0hQjkpXi6T+/DvcAIj7Mp7WohvM/CMk8CsA8HqDTdEDuDgCjNItyTCxpAamSmFPwtjCE8Uu8rkyGoBopblHExi8lTAfC6fq2tuKc2QIR2HwftOstgDs6yJ5xICOn41LTfr7dlSNI3ydr6UiLkryEWXJkmtEbc4J1KTfJJse95Q2z3xGVrOK+tGsdHC8DiACTcCttZchxaE40aWuW4uXotDRCgYEm/dhoOqzmOlMuOJ23g6CWspeFjbZj/C24WZfmUSWENL354hTwHEfnQr7gzpzS0x1MAiTXZABuPH46Waj7p8RKessvj8vSa14Qw0riJdEZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(54906003)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2um0cv8oJpUD4P30PfQO46wBCb2mjVOzDlo1hoW3g5XPzQuxpLx9ILj78+xR?=
 =?us-ascii?Q?pVKtMghkrI8dlyZplWPe2ubjLGe3xmBxL587YZwUmNj6ykJmDJXBmlVsWIUf?=
 =?us-ascii?Q?uykNrzFR40jXgDAHuNiInzyQGWI8Bm5Ye42JTPCFw8kZ5b23205yPRdz0GS1?=
 =?us-ascii?Q?3YPULAnCJmVcB/RfCp5X6DriWouD2i3laYH+cb1qp3b5mKvyixtWV2/tNW9u?=
 =?us-ascii?Q?5FIIXH/Oged4RBr7/JaxahtZocZmJTWcVvBBx7tT28Rd9WB4BOmhlEs3zky4?=
 =?us-ascii?Q?JhB0u1GeFU0sQ5mixsvytvjAuK0scQDJLa99B7/Afg88gF4g/DBgwuV5cRSy?=
 =?us-ascii?Q?YAwzyH29/dJTVdRYUSow0EzgNCjqvj3Nc6sgPJHdOFoGTsLy/ZZSDfpO4JNa?=
 =?us-ascii?Q?n/zMVj5HgnMvPYgRG+LejI4DgEQHvBT/S1gAJ0Qn0gG0WvxNpuSvwRvIKUNH?=
 =?us-ascii?Q?Ww6oews72dJ7mS3R6YJB9nbMprgJq0MFqcScHQOU6DEr9pcolkMZucuymQEo?=
 =?us-ascii?Q?+/VmeINJ2o7OxvYsw+6rECwHTAIlY7/OseyqexhoI0GIsWhJ4q7v/NoqZxI5?=
 =?us-ascii?Q?p0aQEd8P9i9cEdHIq7ZMJ8NuTHCgG1rcPELOQZ3pAImSPzgGjO64LHdVHXgp?=
 =?us-ascii?Q?ZX18IF7op5Ej4uKhoJwW3CCBMtxmaesfXHmu6LsaiU3TvnzFNo5Caiiz/UZM?=
 =?us-ascii?Q?Be+o7xz0Xaf5TI/str2vCpMu0Xb5AOFfFq0tqGFByxfY0qsuX85wtrd0iDZq?=
 =?us-ascii?Q?SbrQFy6qKD02WIN7EaB+SVClTWKMS9Tc4YZJfu6GnRkUZoQ7gRTQjpFwwpth?=
 =?us-ascii?Q?RJFm2PlUb7BdT4K46an0KPGA2HGlGQN6D1WfRAajicvaJVjcTe4jyzHJfSZt?=
 =?us-ascii?Q?46ZKwl3/UuQybWum93+fK7hOpYlVRawoyn7KAUGr6GAVJIVc0Q8NNz181zkK?=
 =?us-ascii?Q?ajhZ4hcvlCi8rxpUkVdfCbBkLXScC3NZ2Qm5+14jCT81D80A24umA09JUESc?=
 =?us-ascii?Q?ML0IItF4ztkUs7N2RCnGKTzT9Qbs0oF2uz70W6lZk8nF4hD5gwggMDArEQkh?=
 =?us-ascii?Q?ndA1HZHqPH2IEKXh8UxPJhYbboVsbEnkbuSpZubnKo+rrJ4ZETJLFu9oYkBe?=
 =?us-ascii?Q?sqlK6G15vt4m3/JmrLCtIuSBrzRQO/33fcUCFVYrJz+JmtV0Fk7t2U0/rlYG?=
 =?us-ascii?Q?3N4hdIwwkXIhF0JMgAEDaGjMo+Jxr4OBWd7lgQT1V7G9PNrT3pHZj4iAIkuj?=
 =?us-ascii?Q?OSueQbvIiRt1lRLxkrMRek2wP4bcC5VdrlBBXa3b+caIL1aLj4epNIfxDO+i?=
 =?us-ascii?Q?NM83+7g6OZq8Cjouu0y1HAMHfn2Sgz/Iogih7Y1Rxf82qQJw0EH8H7JgAKTJ?=
 =?us-ascii?Q?PMWL+3z4fh0XGcs1TwRaRbofPjjdeXRhP0svZcCy3PwTYj4AfCui8vOgfio2?=
 =?us-ascii?Q?nNxpA0po6gmif4KKEsEh/8sGe0+VVuK5l8yyQ4C13I3LHvnO3+chlw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9679942-5850-47ef-7d06-08da0afa3a66
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:26.6118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sfgZ3xP3XeZ7KuZ9naPFvLbb9Peb76r65g04nhGf1l8Y37ijONPynzLRfYdrE6JgKHSu26QFRSj9eQu9bYtSAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-ORIG-GUID: cezMDl9bguQKwahvU5i75TKEeOFUHqwQ
X-Proofpoint-GUID: cezMDl9bguQKwahvU5i75TKEeOFUHqwQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
 fs/xfs/libxfs/xfs_inode_fork.c | 4 ++--
 fs/xfs/libxfs/xfs_inode_fork.h | 2 +-
 fs/xfs/libxfs/xfs_types.h      | 4 ++--
 fs/xfs/xfs_inode.c             | 4 ++--
 fs/xfs/xfs_trace.h             | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cc15981b1793..9f38e33d6ce2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -83,7 +83,7 @@ xfs_bmap_compute_maxlevels(
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
-	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
+	maxblocks = howmany_64(maxleafents, minleafrecs);
 	for (level = 1; maxblocks > 1; level++) {
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
@@ -467,7 +467,7 @@ xfs_bmap_check_leaf_extents(
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
 		__func__, i);
 	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1cf48cee45e3..004b205d87b8 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -117,8 +117,8 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
-			(unsigned long long) ip->i_ino, nex);
+		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
+			ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
 				__this_address);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7ed2ecb51bca..4a8b77d425df 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -21,9 +21,9 @@ struct xfs_ifork {
 		void		*if_root;	/* extent tree root */
 		char		*if_data;	/* inline file data */
 	} if_u1;
+	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
-	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 794a54cbd0de..373f64a492a4 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
-typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
-typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
+typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 04bf467b1090..6810c4feaa45 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3495,8 +3495,8 @@ xfs_iflush(
 	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
 				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: detected corrupt incore inode %Lu, "
-			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
+			"%s: detected corrupt incore inode %llu, "
+			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
 			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
 			ip->i_nblocks, ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3153db29de40..6b4a7f197308 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2182,7 +2182,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->broot_size = ip->i_df.if_broot_bytes;
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
 	),
-	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
+	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %llu, "
 		  "broot size %d, forkoff 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-- 
2.30.2

