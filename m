Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CA3C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344399AbiCUFXK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344415AbiCUFWw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45EF3BA6D
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KJNiF2019422;
        Mon, 21 Mar 2022 05:21:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=o4U935f7gH6r3v57En2RgwGWLWfAfry0rAB6B8Tn16s=;
 b=poyvqAPlghCOlwyMzl1LeBYW0EFWyum9CMcgPipZufqen4vue8JNKs4xxdsvF3eERVgG
 jvVIt1XTRFWl2zSgk/nM2jNdMRL4I0X0RcmYJVJ3kuYa/TuFLTL621NdyNip6Tqqq7Ed
 5+oy9AL5n1VZuo99Tp7zZ5dHCqTEgAEM+g5a4XkLVCIQVBIM0rFkzK7Hfv6CIFVTTx6C
 z1mWyWNk1pAwFecaD9pbBDHC2lyZbCNDTbmQOPWeYvX9qIvo0fwUuLwpJ7Up0WRseIB7
 x9Ctq5x9qoBjWXZwIPGWJ5zPqXvDecZ/q2RLENpDLMTb7YUMU98AlTrAFnnrNWMCYGPg YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss23k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5KMSc163191;
        Mon, 21 Mar 2022 05:21:21 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3020.oracle.com with ESMTP id 3ew70097a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i136DQwfD/aRRv8OhEWiWZ2K4pKQqWy12RP0n42KjlfNUPKi8SBRWMx1UbDpYA+VhqP6UGhpjJxXMv8FZRWyWPYWhxXj5X8qgpfv0YuUFBtlYytNS/Kq/BVTVwfVmMHCfS0TLWbIs2ZXZgIQDfP/bpPX/nhrj5ppJD1W6eTSJqMueUsHtvsQfNaHCAL04qlgRqNSO62Ii5H2p5P84OnE9jOc10nypUcvyJEzj23Rwm87Ug30cL/mWAZG9PlRRxk5jyqDhcgttElnMLGCLGI0DHsjPAL57Vh62mEPtI2e80VXnoDWvI3KfczSXPe9ajnOn35e5XDTYIsUaTHBb7b+OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4U935f7gH6r3v57En2RgwGWLWfAfry0rAB6B8Tn16s=;
 b=n5KfSVkedgkC1HctdsSF9VZIn6dQ+4Kte4DPmeaXDD22cSQXRdmLTZQJN1SJaTsQJL8S2O8iHp0VNGnBsoZQrQy9kb3wO6RzLIz3mRZo2qbrK/luQ254hNkFVJNhUKtkKTBzGTJ/Xty/06PzAJGGru7hBNJoq96uG4ONoRh14dfxsOTuLixgjxgUZkAb1r3P9EV1GWl8S6o0xyUO2yyN8Q98c+9YQmj6weZRaWphrjfcq0t8zUn9gDBhhTBRG7HKBXbP8+TwB4QTrj9BNvq3joksnmcWaXVl+gN8M5JByczkia8ZG+1bEKjV3GOg0uTmNdGELDwQws3W9vFqD0X2tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4U935f7gH6r3v57En2RgwGWLWfAfry0rAB6B8Tn16s=;
 b=b1tAcOM67hK0f9o0KiSn57/Xz+07/HwbvA6mO1QANyIL4Om49Bxyydv01fC1ZnxRTforeCLzwmAJN7BH1xAIx3udAQm0SjImCobhWg/i6bpJ8NXc1eiehIScmglvKPUmQApFNUFGX4sQmV8L+ExCBEENxrCxJf/jugOxBezqHRg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4473.namprd10.prod.outlook.com (2603:10b6:806:11f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Mon, 21 Mar
 2022 05:21:19 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:21:19 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 18/18] xfsprogs: Add support for upgrading to NREXT64 feature
Date:   Mon, 21 Mar 2022 10:50:27 +0530
Message-Id: <20220321052027.407099-19-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8485cfad-f03d-46ad-e06c-08da0afaa19b
X-MS-TrafficTypeDiagnostic: SA2PR10MB4473:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB44734CF1FD123001691B0EC6F6169@SA2PR10MB4473.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kQS3PPpxRrm0PBZX2bBwedWNKYHcd9SUEI8FABLLuBOgyjWJmCLyJG5+hCKk9vl0+dYUr8Hry41VtmNxjSnQ+gOyS4HG1nlvhJjskoa5fNQW81pII7ytpTrdRQerPCgF9ll1us9CpM1KBH6CDb7POyNpn3mhWLfUcMheTquw9sadV844mqGYwlrnqCiJNDOIU3PwqA5gS6wQIC2vw9vmJJbIYMc0GZ7fukT6qnpM3TWs4Hwi+7TVkqSTJXd4g43QIkds8Bs9ClahpCR7bSjOAyPX0gYXByjTn+hvl1+8qhBng+KV7ba9Rlyn7rLNPcTuKDrQYizhfM00JHFKijW499dtmbTannohE7k9Y6uX9nTUmvG7aHt+B+063vDSS3rfDVhI2xd9bFDC56RdQdC8c+JnH4kg/2X7BO8JlprY2MIMJF89WHdpygLFjN1CBs/Zm3kxFzpDnCqQwbd8juUQ52aHw7yeLaEiFauHfYCaHU4mP52lYeR7ZR51jgiAJiS1zBWGQ+AaccYmB/Wjc//OKu5wAAAX8S0djaZY0NHjqhct4Nu47zof7q5VgwArmo07ECBi/gYYzfwMiZ4inOMfhuuH/LBZ6f4VbrFCawjCG7IASOtuTL9VtiwgA6yKM55mlkmRhFHnHVy3faRpJ9gYlhlvvOGOb59waaQqRd3CQZqDwZffdabbBNfHZOTqsUfXmWbb6BolZsMMkMD2GYiy6EBtPjmq7vqQnzkWJpUHfz5mUQJloSPKCCmbCa9fYdh5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(2906002)(508600001)(83380400001)(66946007)(66556008)(66476007)(4326008)(8676002)(316002)(6916009)(86362001)(5660300002)(38100700002)(38350700002)(8936002)(186003)(6666004)(36756003)(26005)(6512007)(52116002)(2616005)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MjCVsqmwYa5597wO697ZJGHz4b5xdz6xKNr/1Sk5Oy5sIcZ3p2N8kzgQFvbw?=
 =?us-ascii?Q?hX5Xb4GDR2jugEPaZrSP1X+ZSaDGkNqWU1VtJ8SIPmq/GlXX9ffN6plvQ31B?=
 =?us-ascii?Q?xRAyFyLmZrfhbbLRdZUV93OzsyvD5qeZu9H0fpa4zxPuUuxhKdtvsnMjX8Fw?=
 =?us-ascii?Q?Bc5D54Sa+IEY+9wtbfiiooZ1bLrCz23tUVQG8SiRsBtIJFGjPg85q/3x9p2O?=
 =?us-ascii?Q?uwYDELHtaO9sdZnK30A087K8RfKq71ls7e3EiB67kkBx5uattR5SP23m2NtV?=
 =?us-ascii?Q?x2FP4ava5B47iGQQwu5ytdwOa0xoy5VGjqJICYAIe/ePO7aOSAKj4nV1fjcx?=
 =?us-ascii?Q?y9uG017Lhc0VN+pvaR5uDWsm+UQpYFELrQiu+2R/8LLYJHBx21GMWsPwf82h?=
 =?us-ascii?Q?9wGqW/CNpweuA8XYinujkXypruPqi4WU/0vRPji/CYHmm4ASALcpz7smOnZs?=
 =?us-ascii?Q?O4hNyJn2peFIkPM+5/V6o2KvGYGdUWqOA4F6FU1HUnwB58+9d67P009qgLkH?=
 =?us-ascii?Q?mI9/3hDSoAjV4j/t+5YgNSf300EWfnZbema4AqZ3QWXKJWB0dShb+1DwjfM+?=
 =?us-ascii?Q?hJmQh71HxbFC5u02G2JBPFrjsBC4wXDZPUi6l8IwygOqvFy8x19fx8RUpGwN?=
 =?us-ascii?Q?sViBsfK9SZvNwbqJmxV9S7Ecm9mOiy5GPmtRZyONiUL4orQdnGUvsHA9DxHh?=
 =?us-ascii?Q?86m8n/ZPwd5jW0tk7gmbWGJ9u1w2fIKuRgZQq4JMY5uda3SAw/SZYxT8M1XN?=
 =?us-ascii?Q?ucmuH/ANdsoHJFpGHmTcCkk4sifMBQcbQdJdnujhq/K64OcHUmrKozPLwyGm?=
 =?us-ascii?Q?9I6QTYByfXplNI9DjFuf2Zt8TEg4zKZ1L9lmJcVC00MF/Bwg6ycHXF7gLncU?=
 =?us-ascii?Q?bdbxP5aRgm//1dLC6tniz2UqbMxTXfOtEcZSvzHwsKI1UKVz6Y+97V10XMsX?=
 =?us-ascii?Q?21HQlSaODAU23V4uOylomp0chpf22SxwHl4WG0JfhzgScdFiD5VzYeFyz1dw?=
 =?us-ascii?Q?5O+oDtelBRbJRU6oKTEvcfZgW6KtTsk3NSk0c4o0TrWLbecV9R6rxBzal/4+?=
 =?us-ascii?Q?DWGG4M2PgbNPxCmR9BA9f7uyqUe8tSXzE0DuRIJUJHDE9g24qB1M9uqgnhqa?=
 =?us-ascii?Q?NfARvaOyBB/KC5+o8mVkAvzDrPQlNMKp3Q9HQ5uNHG4KNO5cmOvnRd0gD5Nc?=
 =?us-ascii?Q?MgQKtwTXUjfj71dtBKbnREN3nS1ys4AsON4ZDanIDfBT0dXYdGKwWzyTxUVA?=
 =?us-ascii?Q?NFgr9rctQCy2kBoUQr+/iQcGnze/3UfmFQdBe/VacfOV0ek5ueKgxbBpDsKH?=
 =?us-ascii?Q?uS6vgeEEjIu29LMnhbxgEdqFUsTFCwZH4wbhsnWKER9G3WCi+ER/tY1OwZSk?=
 =?us-ascii?Q?XVQD7Hsm1OBqJwXupzjyPYu+DI6ufcoxnApeIJAWh9GyUuglZRE6Fpp7Bg24?=
 =?us-ascii?Q?gQEBRsY6rSHIfERszCO1bnuQy8ro00S//l5NXsAJaGjvV+0S9+8xLw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8485cfad-f03d-46ad-e06c-08da0afaa19b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:21:19.7045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WiPDP6LTeor/T/lBJCY5kFRFVIKL2vgY9++aatFuCBCPwictiiCuWvVQCQaBb6//1IB4w+jM8XJQTIjygiUQYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4473
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-ORIG-GUID: Uco6_cfc4A10pJCIeoTX_5UO3mtInWZo
X-Proofpoint-GUID: Uco6_cfc4A10pJCIeoTX_5UO3mtInWZo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds support to xfs_repair to allow upgrading an existing
filesystem to support per-inode large extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/xfs_admin.8 |  7 +++++++
 repair/globals.c     |  1 +
 repair/globals.h     |  1 +
 repair/phase2.c      | 24 ++++++++++++++++++++++++
 repair/xfs_repair.c  | 11 +++++++++++
 5 files changed, 44 insertions(+)

diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index ad28e0f6..481a042e 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -149,6 +149,13 @@ Upgrade a filesystem to support larger timestamps up to the year 2486.
 The filesystem cannot be downgraded after this feature is enabled.
 Once enabled, the filesystem will not be mountable by older kernels.
 This feature was added to Linux 5.10.
+.TP 0.4i
+.B nrext64
+Upgrade a filesystem to support large per-inode extent counters. The maximum
+data fork extent count will be 2^48 while the maximum attribute fork extent
+count will be 2^32. The filesystem cannot be downgraded after this feature is
+enabled. Once enabled, the filesystem will not be mountable by older kernels.
+This feature was added to Linux 5.18.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index f8d4f1e4..c4084985 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -51,6 +51,7 @@ int	lazy_count;		/* What to set if to if converting */
 bool	features_changed;	/* did we change superblock feature bits? */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
+bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 0f98bd2b..b65e4a2d 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -92,6 +92,7 @@ extern int	lazy_count;		/* What to set if to if converting */
 extern bool	features_changed;	/* did we change superblock feature bits? */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
+extern bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 4c315055..2c0b8a7e 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -181,6 +181,28 @@ set_bigtime(
 	return true;
 }
 
+static bool
+set_nrext64(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Nrext64 only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_large_extent_counts(mp)) {
+		printf(_("Filesystem already supports nrext64.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding nrext64 to filesystem.\n"));
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -380,6 +402,8 @@ upgrade_filesystem(
 		dirty |= set_inobtcount(mp, &new_sb);
 	if (add_bigtime)
 		dirty |= set_bigtime(mp, &new_sb);
+	if (add_nrext64)
+		dirty |= set_nrext64(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index de8617ba..c4705cf2 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -67,6 +67,7 @@ enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
 	CONVERT_INOBTCOUNT,
 	CONVERT_BIGTIME,
+	CONVERT_NREXT64,
 	C_MAX_OPTS,
 };
 
@@ -74,6 +75,7 @@ static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
 	[CONVERT_BIGTIME]	= "bigtime",
+	[CONVERT_NREXT64]	= "nrext64",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -324,6 +326,15 @@ process_args(int argc, char **argv)
 		_("-c bigtime only supports upgrades\n"));
 					add_bigtime = true;
 					break;
+				case CONVERT_NREXT64:
+					if (!val)
+						do_abort(
+		_("-c nrext64 requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c nrext64 only supports upgrades\n"));
+					add_nrext64 = true;
+					break;
 				default:
 					unknown('c', val);
 					break;
-- 
2.30.2

