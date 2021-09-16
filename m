Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673DDC43217
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E3DB61185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbhIPKJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:09:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6078 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236295AbhIPKI4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:08:56 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xcON029263;
        Thu, 16 Sep 2021 10:07:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=tayh3quANFC/XJVPdLh1uJmjW2+uBGZynjjZEcJrgT4=;
 b=au1+tyEKYLewvIKtwJwRRViNO59OQZZ/bRs3NlasRibLcTKdDAMhqcBQHkK23toGdgN/
 V/xGNTqcw6nLK60Q/3Zbegc1XuIPw6aVNRgecHn847IXlTBSO1SR9gRajzXBAyVf3np7
 c/bjiFn1EdOoSHx2G0pD6Rz82F175leQlQiXzcJyHf+mMiVfc+Ghj3nPw2ob6Zu5TiyJ
 5t4YmOZ6GFUjw8aQhRjXHLhAL+RH11U9Ynn9SJvioWnOdMPkc2bV5Irxzj0vsDzg3Mmp
 d00RCCW7BMf0cBZo9GLEpwolHL9GdD2quJTm4w56JXCMbv9tAcoiCHviceDg4T6uCtcc JA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=tayh3quANFC/XJVPdLh1uJmjW2+uBGZynjjZEcJrgT4=;
 b=E4akG8gc2j8//vNE//85Lh29ldyU78KXHPjzhMBcQXJoH+56R7CUQQfloYAgLUhUcPp9
 Xcu3pE/0LoDb/UhfHQtTNME4ng5vrD4Gdi8F/NC4hFC/OBRjyX8Qx0EP3pwUNJDVpqU2
 zG8SaBiWdyZYf0nOaZnwfs7ICMPqGq2AuMmmM+1exUqFt8eV0t3ZFhLEEMCOwsn8LTxW
 YqL3Qmxt0IU/MNEK/wYceWfqKBHaKgqB/ay+TXtcNxkcBuwkPIajmRv15MZ0heeRrESP
 sN+SXBdAWWjNXN4kQAJ7PX23qx8SusFM4UUWlhzXHz2miCZo87dcb6FEWtbX2rZgcwY3 cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3tnhsbhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6Tgw112235;
        Thu, 16 Sep 2021 10:07:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3020.oracle.com with ESMTP id 3b0m992t5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zn4GUpm2kNCHA6uXeEH+xY3Rx1LlJkGiZGYWX9uw/uHNkWWeuKhAjdzZJmyhwY0u+jfOCeVinSs98kD4erCkysqOovSrmAibbK3KpUjhGR//yX+FDK2Xr90VwvFqHSeClEVgrVWAmEFL3zyZuxx5aUX5+cctyte5ASWHobQ8/sCAnPqVvhK/PoB8dER5Ol8hX535sMny7ACX8DagDwl+JfvXKkPM9I/0LvKgZqRBK86zZw3g3mCirSPgCVlX590fj9H4J4BSgaJIWFBndQ0Sv2jhUjKhJUy1hGYgMA36YQdBLW229l3vQFnlwqU+8QEhg6eUYbEoRCwxNKWpG8fdMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=tayh3quANFC/XJVPdLh1uJmjW2+uBGZynjjZEcJrgT4=;
 b=Y1QwCACmWQSwpRzMSujGejJ3kfmc5xRqqL1pSmLJ7fF1s20OcoZtmJUNLRVbkp8irG63vbik5EMo1zve9GrGMoCM9vGm253Z5MkxlegkTG7bFcnsq8jdGbRHV1+TEiBasqIJTur6/EdCfNd5HLO5B/yJWPpuP4j1qYdD4u31b/YoA+vwU/wJK9HBHmfR5eXO2i0lbNSKeDCEEUy2uFuMKrG8dQTngA4mcFYhWrUpgblRxOFzFr4IpV9q5SeW8cCm8Xn5c9nCZIILGoTNsA7lkcn8OMF7bkq1+WuHRv0qCnlpdfL25e3POZNwa49Kz0qxZzwPAXAtt2OUC6XEelCPEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tayh3quANFC/XJVPdLh1uJmjW2+uBGZynjjZEcJrgT4=;
 b=nHLgFfkSKJH320pzKsg4fcUIPzj2yjD1/LHPZpgWRKHQc7U56lX6Xudw7p9FFzWMll56cqZiNexQ5+MtaNTiBGXw4DUv802yqvUcIWM5W4Gp3fs7XTSkNGD85mPKj4BWpkAFGZL4CKlg+Oq8j7mRx8JuaoFyDAp6a7N/ARBoKx0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:07:31 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:31 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 08/12] xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Thu, 16 Sep 2021 15:36:43 +0530
Message-Id: <20210916100647.176018-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b572d06a-83f3-4b36-8c7f-08d978f9cbe9
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2878199750F994ADB8B937AEF6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gEALnKOj24qqFLdMjtYe7O9N100N4yeKeu4qzjxp/dGaehHQc+ADHEfpdpQOw5Y/wKOOIXisx1AiB/BQaaiRt41uXE+MSpFXIheihteXBhe3l7SBfRyTXC2//jAqrHdgWLQRm3bGle/h2RgRLYKBmeZRJlnP5EPleUYwqnwpMDdIsMYt2g8mxTD1Ct93Px+JXhVAIYVMp4WTE7DiZ68jd8eIGUcbEa2oXXOEi/SnLNxku9zROxkGxhmO4KuAO3ESD0+urI2/n3zzEGfNyrnUvwXQWKS3FeuDz216jkpv8lzOlhdaVVz/beokh/YG51BzK5DiPdTDnTnKge4OqLeCSN74McHFYVHxI91WiW75IijjLoMpyd5qu2evSTygV26QrsZNFSXyIiuKmmghm+U9r2vkeBHyTqzs0p9GueUcA2nURsb03IteROp/gmcIwFsTFQwT1LeaAo9rRphFbKvI0gIUL+JjovjXCa11pWiftbxWbyKVxge+cxcyE9FuWeb6KiOmJZauunLSyzNvJcYbQqyhfS9p1OWM0r7qNOFGRcSLAICXwkp1vyRYzoKmbkv6+mEJLG3BOL29xseHeutN4Cx+kYUIQvbj9CT4/LYDGp8GZtO0LONqHqcUqbNxPXloT4QD4JCwxIHQ4ccxfgPSzZ79+rKF1QrO2Dajq4Eu0JKTvBPtabZL+XTUEmVa5wPvxrWbulK9olAwocYK9XiZTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gN7nyCEcX8DmVsWXAlpSBfumFAIiIwVTZE81bStpNlUcrtsJBc30DLR/5mmS?=
 =?us-ascii?Q?c6WvRN5TT+2A+8wo3gWJoOjcdNJ+c/VkKTDiV1fvpGZ8Truxoc55Cd4jYW6x?=
 =?us-ascii?Q?hCdyOGGFyXh3wDIKvXhCd1NmEe3OzzedazoRwt3fpgUL4PJp1kjIpFrsc/DH?=
 =?us-ascii?Q?Pid3/uWsXyy4icc1HOICPtCBzP+UzI83Czk5aY0j7HFruaoAIPxAHb01ngZU?=
 =?us-ascii?Q?ex/Mp5pHeKGDJF95Nv6hSJrI0/td9SOKgkyUvvI/o4NrPgpfqo3ZYej8uQx/?=
 =?us-ascii?Q?QnR9ojkYzCtGZSY9F+CMNZLUUg2IheAj1VSPLfysWKPGC086sX02HLzIVu7I?=
 =?us-ascii?Q?8zgjD2c1J6kWjC5pLuWmXRS654J2OVRnsDvDbHHNvA/5isePRUDr8nGwD912?=
 =?us-ascii?Q?2qMMdBaCfnC9bS1Wa7FyRcXc/3t6HqA8S/M+fAZILTYkzUTJFDFLJq8ocD7V?=
 =?us-ascii?Q?nRNP+S2akYLHaQ/BPkOEErVUULH8HB+MZL/O0stTIXyGEcRTfEnt3rZyLrM5?=
 =?us-ascii?Q?nEM4qLyDf1QcFSPNNebXcRyEp17reNa8HDj1SWaTHEa3KTRZaszJyKOzYRjV?=
 =?us-ascii?Q?yCeJsCLasWTDtlqzZ2HUOihwGVK5gjLlbDGcpk7ZNwC8O76xH2FcpEIZaWwA?=
 =?us-ascii?Q?jchxNGM4aDZu8D4xyjK7+CuT35PyfBkAcZFRLJqwVSsP+L2pSMP5Zn/L+ad1?=
 =?us-ascii?Q?kwdPZsuoM3P2jmqLZGPOwZFDjwki8Lr7tTbCmoTHwNcSBn96S78K/+zGYf+6?=
 =?us-ascii?Q?EZYybH5ZfnbgamsHPOFoCmUdsxC1ocoErBvi+bzKsRqycNt6sZlFQe43aRCg?=
 =?us-ascii?Q?j3jVu4dSvp571Qhp32d2l+Fwg9Yf/zJIZrUMc1JTz6BskwdbU+kSTl0RKRFO?=
 =?us-ascii?Q?BuytKNcTIt8IKOp0R6/kuNOWqji2abHTHueQbbZiTQiFqPEsJRk1e6a8TTVK?=
 =?us-ascii?Q?sC/LRQ4AwYCRVNiysoYtiqCmY4SrO7jTYSD2v81ZkHxguGFnMDKz9vnapgHk?=
 =?us-ascii?Q?AssnNq7TtNeiCl0P7/cIprxBo+UvfxQF5hZMTJRyDQJVPSrOLqSo9tykzU4i?=
 =?us-ascii?Q?bfIyh6jJxePgl0PndHDWtMtMcE0vobYl2Pvpwp0VtbY880VkhkmVIMRs/Byx?=
 =?us-ascii?Q?e7EWAGKvt2t9dQR86TObRzJTXEp8qy0oHvjwr0s6vffCtV5iXL9AUKf+RFJX?=
 =?us-ascii?Q?hy9tYR3xx+PlvNJnLh2b4+7hjLbvR3M/lt/xS53nm2mfzgtjKQaAGaVFJd78?=
 =?us-ascii?Q?LCGminW1oq76tM2jc+FaZZrJn7d0y53uZdvapiSjgBM76kWeJhVL7sLA5kYm?=
 =?us-ascii?Q?t4v0qu1f68cXznHR/vuleB7h?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b572d06a-83f3-4b36-8c7f-08d978f9cbe9
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:31.6211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uu7bmgm+hjy5K/NeMKN4xC88ZsuC+qZwyXQhJ1oNY1o6ZSkMnflGtmMi/xXDxPrgIVYnjrlir+AsPcApglKQGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: cPRNWxzA8ae8p84hTgG4cuB2N_0jbvWZ
X-Proofpoint-ORIG-GUID: cPRNWxzA8ae8p84hTgG4cuB2N_0jbvWZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 2 +-
 fs/xfs/libxfs/xfs_types.h      | 4 ++--
 fs/xfs/scrub/attr_repair.c     | 2 +-
 fs/xfs/scrub/inode_repair.c    | 2 +-
 fs/xfs/scrub/trace.h           | 2 +-
 fs/xfs/xfs_inode.c             | 4 ++--
 fs/xfs/xfs_trace.h             | 4 ++--
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e5485b5c99a0..1a716067901f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -54,9 +54,9 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -473,7 +473,7 @@ xfs_bmap_check_leaf_extents(
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
 		__func__, i);
 	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 435c343612e2..feabe2da63e6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -126,7 +126,7 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
+		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
 			(unsigned long long) ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index e8fe5b477b50..4b9df10e8eea 100644
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
index dbe5bb56f31f..a3af29b7d9f2 100644
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
 
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index d7f7afb71a70..02983d037d3b 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -770,7 +770,7 @@ xrep_xattr_fork_remove(
 		unsigned int		i = 0;
 
 		xfs_emerg(sc->mp,
-	"inode 0x%llx attr fork still has %u attr extents, format %d?!",
+	"inode 0x%llx attr fork still has %llu attr extents, format %d?!",
 				ip->i_ino, ifp->if_nextents, ifp->if_format);
 		for_each_xfs_iext(ifp, &icur, &irec) {
 			xfs_err(sc->mp, "[%u]: startoff %llu startblock %llu blockcount %llu state %u", i++, irec.br_startoff, irec.br_startblock, irec.br_blockcount, irec.br_state);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 19ea86aa9fd0..133109d84b98 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -601,9 +601,9 @@ xrep_dinode_bad_extents_fork(
 {
 	struct xfs_bmbt_irec	new;
 	struct xfs_bmbt_rec	*dp;
+	xfs_extnum_t		nex;
 	bool			isrt;
 	int			i;
-	xfs_extnum_t		nex;
 	int			fork_size;
 
 	if (xfs_dfork_nextents(dip, whichfork, &nex))
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 92888a6a6e51..14e4ac8eebce 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1372,7 +1372,7 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 		__entry->attr_extents = attr_extents;
 		__entry->block0 = block0;
 	),
-	TP_printk("dev %d:%d ino 0x%llx dblocks 0x%llx rtblocks 0x%llx ablocks 0x%llx dextents %u rtextents %u aextents %u startblock0 0x%llx",
+	TP_printk("dev %d:%d ino 0x%llx dblocks 0x%llx rtblocks 0x%llx ablocks 0x%llx dextents %llu rtextents %llu aextents %u startblock0 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->data_blocks,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4875d5e843f6..6338a93b975c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2538,8 +2538,8 @@ xfs_iflush(
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
index fb1033de7003..dde8c98ac195 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2196,7 +2196,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->broot_size = ip->i_df.if_broot_bytes;
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
 	),
-	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
+	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %llu, "
 		  "broot size %d, forkoff 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
@@ -4557,7 +4557,7 @@ TRACE_EVENT(xfs_swapext_delta_nextents,
 		__entry->d_nexts1 = d_nexts1;
 		__entry->d_nexts2 = d_nexts2;
 	),
-	TP_printk("dev %d:%d ino1 0x%llx nexts %u ino2 0x%llx nexts %u delta1 %lld delta2 %lld",
+	TP_printk("dev %d:%d ino1 0x%llx nexts %llu ino2 0x%llx nexts %llu delta1 %lld delta2 %lld",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino1, __entry->nexts1,
 		  __entry->ino2, __entry->nexts2,
-- 
2.30.2

