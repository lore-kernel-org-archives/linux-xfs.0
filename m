Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E87C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbiCAKlR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbiCAKlR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850E690CF4
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:36 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22180THa010124;
        Tue, 1 Mar 2022 10:40:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=np4vEouUBcKDYiEXIJB9NXe2liiMbuFLFivNEnKYSmo=;
 b=CxSK+wdB2ZrWge05r11OthkyotiAhPLP5Dd7X8mAGhZU90RLlfbcM2e0xgK6OBb+EPCS
 lacdVQ9ppDy1Lj8i0RdDr6ilR/70bcB70b+v09VcacHiCJsusYrNNN5wdXm4DnjqOsry
 yJATd6iho3Jr5SisqE3H0ub+wOPotGjLQLtd85XiJ4gmTjSD7sqTQKu3PEclDfqrY2Ht
 ieRMj6qHiQpd2WQ8bKWdg1oOZedeT9e0175Lz18i/CMXIRv/3Yoeas/13sgA2DZ+0Qw1
 av69faR+Yy2b7Igo9MCh1wTUysT1NgUMl8OgbqmWNa6INAGLm2qsYMETQD4+ScHh0Qy8 gA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k42b49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZNGV043003;
        Tue, 1 Mar 2022 10:40:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3efa8dp6w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hyNGGXP/aGiHcDTnML1t9uTBn25YMBOKBhSIzvU2IroB47TP6Jm1UkR7C0uMdbl52MOImZxFJ3BLEBuu2rzSXyTNPybQ/5ExBR4XoW3Rkda5c4yJIqL9xf07Qi86W1ZefmzfzZHuIgc0ZiDB3f90UqnjxWUjdCWARkmP6aokjXIr9jE7tBSbpzP9ISycxT+t3Zb3LzbTS3jN81Ml+dmTzcGWJ6grqnv63MMgtb7aTvGF/dWsasdYXxatgnWK348WnLw0O7WwscdZqLOc1d4TI8EBP0lZ3+PrhwvwAd9+oefSgJv1uQRFUZ2B4SqtIJKrxPdQuLcflJXyXqgBTLCYHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=np4vEouUBcKDYiEXIJB9NXe2liiMbuFLFivNEnKYSmo=;
 b=KvV1zQS9x+MCq45LHadeP/ANwMvqI21Awdczz3zdGm0JGO4MJNmbXYl+vDj14qFULZFbFtrx6CuogChsW6XiFxFF8ReqUmCwLcs26vBGzivOigEMJOzVhhw8T7H/OOcZWZaZao3Delo27KnoKV6fVrq2gQTannptS7cnBa6ixRVdwGbweYrhR+iUBSTOuVqXpgkCmAhhxQtMCeM6S0F6cedVSCws7AcbCMdvStJVUoEgzELO1HuV7d7iUxdsDLU7VpIAHJVg+ZC5/KPNVyk7/9jEaPlxkb2yWaYxlC4mySVztyKnSqwM5CpXlH6D1H2BIhtawq2u5fxMH8GmIC4oDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=np4vEouUBcKDYiEXIJB9NXe2liiMbuFLFivNEnKYSmo=;
 b=FbRMxv0njO+Ce9poEItHU38QuIi7gUc5u+YYqCD0LPgsYgs/pWNpyR1boECrLXZqVOz++lf+b7gb1sDSDbrtiDWWs1Aya/xGOWHbILbodFUOzDoq7H4Pmk54VESBuzuUIYv2Qsb2YifzyNjxgPV1eZEx4FIV12WBdDSBsaR0tvs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:27 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:27 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 11/17] xfs: Introduce macros to represent new maximum extent counts for data/attr forks
Date:   Tue,  1 Mar 2022 16:09:32 +0530
Message-Id: <20220301103938.1106808-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 221ff7b1-db99-487d-4156-08d9fb6fe612
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB41600DFE845B994B521A0900F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4nUJ0GLXztAcf9CldRQx+6pxwlWZxbFSAjo4d1WcQHPgsUaYM6u/bIfvDo3oCsBAhR+WbxTBLg9KAqByzZ9OQaaSb+UYcUkienwmMIb3hUai0i098c806wGYVdO7iF6fK3l35GHadQ2PAhazOlzJ+Ay03bfmxIRddyLvEMq55v5bbkqE9DgGl64KOy4N5NSCXPhmHMbyUsoWhsTePTxWD0Rht0DwOl7XwC1T9J+Zda3ofohBz/GC8TuiS0no2HYx/8ZDJijpRvxypdsL8BrTTepGRpmp8bafam4syIItNVHhpqY4MilyiEASIiYq0SImAYzziY4aH4SjfSjSKy3cRKLYv6M5erSbuSZKSoex2/avs9bg+nrA6x6LYyHdRg8m0q+EaheFP482M2z0yHb4IEl200L/MlYvxM3xsjsF3MSSxKtztbVPNSie0M2yHAs51h+M/4Zm4o3xZkStNlbCgNc7KBABr3A3NlCxY19kTdGw3VA05vgj9m+osTgfel6/byB7c08IjtOP+rH532MjEJx0jy6J16AV28xuHK2jwMMwjAwS+1Fdzm869IJcPs+Y1kRvsBj2mveEZBbp6d4MV1RO7c4ESSJEyK+wKam3yDkSKZa9UC8QMV31lpyCkDH4x56xW/85txwuOm1x0Qo2Zj+CSsqpoSK3t+AF3+ZFlD3WgyjhdNN3yKCJUPdyxZ0LdxXZR3lqsrH6qGdz1l3H5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?35jnrudgsivIoTqL1mscx0U/qSI85XOkxfxMSEStgCV2omgKXAyc5Z6K5k6j?=
 =?us-ascii?Q?CJoEpmPm+HgWzJLqbqsF/WWWWBqoKnkyQNsgu6HLq8uGij84ZvXIPLOMKhAs?=
 =?us-ascii?Q?gFhL3MiwW3OGtgWCBEG2xwRcZ6YYiCmseagE7GYQa6IQ98LDP3zDO+axFMxo?=
 =?us-ascii?Q?/CCYAd+yCLD/ktJUaQzg8k2Po/ghuFm1ydSQBbQOMuGDuvMWf30Ftokk/XrO?=
 =?us-ascii?Q?G0yAWrQKtTY1GMDl1POh1PbdECG/CweaylNfrAjFyPx2DJ1t5pjUzqadAXgV?=
 =?us-ascii?Q?d7/5J7HCnP+RyD1uwZrKlEyrL3wVU8EchSUv2ud957gH51amBsbEEi0QovEE?=
 =?us-ascii?Q?lHNIMGMczo/+fMxrqHU5HcGHifu6Ko7nw2bpLlpjvDjxwvcU5uDvhPiQ/rKg?=
 =?us-ascii?Q?qJd8sSn/J2gien5e9o69f9afbrdL8St71w/M8/vOh563p5jRs6EM8kYr2IfJ?=
 =?us-ascii?Q?Kwgz7OGGJk+x54qo+E5+X6f84ekTvWsuEcMGFVj2Z4Z2JUVC4F3X86kRzaau?=
 =?us-ascii?Q?8vjYHvfojHYZz0vMFDuSjcNChagVvA3l7qthCTE/SmGA4ed75yJp2eX/UYMT?=
 =?us-ascii?Q?kpzlbxV1WTVdLNuHFc5ZsE78EqJ+7UI2//S+HBuu/TdIvExJd/iqytMiv8cz?=
 =?us-ascii?Q?chTkyksCRdFiPka30KV48kRPXNjcQ8/tb+JziTOS5RVLyU1bHNcq302S91eN?=
 =?us-ascii?Q?yIUnYkzQpvwYJigVCP8mtczq0pp3SFCTZFMs+Fsni0Ictm/0393ybSRNgBVW?=
 =?us-ascii?Q?RlE9wJJBLSIk43H9bMQDIR+wjAhpTQR+dRrJuskXF/ZRT0Wh5qwbd+xJ0RHP?=
 =?us-ascii?Q?y1gOWaCAhkyiCYQsGw2QFjpUIzIDCr5B+U006iaZuk1xCc3/jKvjOFV9duOs?=
 =?us-ascii?Q?OkFxXyXb1caYOIU4hj4OYPllkQZPiD8ofAMHF2mBz8OmeQs4spDia7c9R8Jt?=
 =?us-ascii?Q?QECX8WTnOh1PM07YjbTjxlN5iTi3lXZPAfJL2Kkuxi3FtNlo7CDjttvoQYkl?=
 =?us-ascii?Q?mqd2qaObTXr0zQgbvx9kQD5LQ4rr0sLLAwB9DH5nPXQmG3AF7EOIH7SFA9BS?=
 =?us-ascii?Q?3PWwlft6PNIQ8g/ch1wHnqruLnb2YobQ0Hnp60QenejNz1HKcJQ4aFW8WbAd?=
 =?us-ascii?Q?s61cWyHpSULV9O++J+7FYbravLFoZ0RGjqPSFRy4hwr0g13844N1tzjgk46V?=
 =?us-ascii?Q?TvcX6SO8rgIx7QdLdt7Onjm5NeYH7hjfzGOj9iYcTAjr3aonb0E5OXreTrZU?=
 =?us-ascii?Q?Yxv0/Hv6sJ/2ROUdDyIlT6PUsaYw3tMpLiMLEYCBrRYxrE1X7fVK9V+aSMlo?=
 =?us-ascii?Q?rxAU8n4k6VGIVhv96Z5bNmAxH32Edpw/Xkes3flv0ewGxby3/dbImaygAs2u?=
 =?us-ascii?Q?r1n9gEfO4W0yBjS41gsfa84xXUpGCGf/5AmDwAznCpP84aN7uLhClPTndJld?=
 =?us-ascii?Q?gDCfjy9JWm/T5uqkHsPKB1oeqj/fLZ/0E/tXEbk8hyaHexY8WfYPOdhkkVP6?=
 =?us-ascii?Q?DaaNRcmK6FOKmc7zLDseqKfhjkS6t+BxkwK0AITVnp3N5d6VKazfDxaijwXc?=
 =?us-ascii?Q?dNboMbwh4YPFA4IB/HHx3wnZPYRQCWdmM54vAoHbukuG61klQUGyZABO/rAh?=
 =?us-ascii?Q?LpDY1pa+lb8cirKUb6046Yw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 221ff7b1-db99-487d-4156-08d9fb6fe612
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:27.3751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AbPv4F9vppDd4/W4WgxTlow9ecKcVdpI406a6kVekPTSIGyUBgcR4fTtWAKljBKdbzpGdwa4Gb/FSDMkv4bYqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: z81VPD1CKdiClHOTVPdwnpwpvAZMRC9Q
X-Proofpoint-GUID: z81VPD1CKdiClHOTVPdwnpwpvAZMRC9Q
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit defines new macros to represent maximum extent counts allowed by
filesystems which have support for large per-inode extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |  8 +++-----
 fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
 fs/xfs/libxfs/xfs_format.h     | 20 ++++++++++++++++----
 fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++-
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 19 +++++++++++++++----
 6 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a01d9a9225ae..be7f8ebe3cd5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
 	int		sz;		/* root block size */
 
 	/*
-	 * The maximum number of extents in a file, hence the maximum number of
-	 * leaf entries, is controlled by the size of the on-disk extent count,
-	 * either a signed 32-bit number for the data fork, or a signed 16-bit
-	 * number for the attr fork.
+	 * The maximum number of extents in a fork, hence the maximum number of
+	 * leaf entries, is controlled by the size of the on-disk extent count.
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that the
 	 * fork offset of all the inodes will be
@@ -74,7 +72,7 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	maxleafents = xfs_iext_max_nextents(whichfork);
+	maxleafents = xfs_iext_max_nextents(xfs_has_nrext64(mp), whichfork);
 	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 	else
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 453309fc85f2..e8d21d69b9ff 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -611,7 +611,7 @@ xfs_bmbt_maxlevels_ondisk(void)
 	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
 
 	/* One extra level for the inode root. */
-	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_EXTCNT_DATA_FORK) + 1;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9934c320bf01..d3dfd45c39e0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -872,10 +872,22 @@ enum xfs_dinode_fmt {
 
 /*
  * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+ *
+ * The newly introduced data fork extent counter is a 64-bit field. However, the
+ * maximum number of extents in a file is limited to 2^54 extents (assuming one
+ * blocks per extent) by the 54-bit wide startoff field of an extent record.
+ *
+ * A further limitation applies as shown below,
+ * 2^63 (max file size) / 64k (max block size) = 2^47
+ *
+ * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
+ * 2^48 was chosen as the maximum data fork extent count.
+ */
+#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1)) /* 21 bits */
+#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1)) /* Unsigned 48-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1)) /* Unsigned 32-bits */
+#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1)) /* Signed 32-bits */
+#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_extnum_t)((1ULL << 15) - 1)) /* Signed 16-bits */
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 860d32816909..34f360a38603 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -361,7 +361,8 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		max_extents = xfs_iext_max_nextents(whichfork);
+		max_extents = xfs_iext_max_nextents(xfs_dinode_has_nrext64(dip),
+					whichfork);
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ce690abe5dce..a3a3b54f9c55 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -746,7 +746,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(whichfork);
+	max_exts = xfs_iext_max_nextents(xfs_inode_has_nrext64(ip), whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 4a8b77d425df..e56803436c61 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -133,12 +133,23 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
-static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+static inline xfs_extnum_t xfs_iext_max_nextents(bool has_nrext64,
+				int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return MAXEXTNUM;
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+	case XFS_COW_FORK:
+		return has_nrext64 ? XFS_MAX_EXTCNT_DATA_FORK
+			: XFS_MAX_EXTCNT_DATA_FORK_OLD;
+
+	case XFS_ATTR_FORK:
+		return has_nrext64 ? XFS_MAX_EXTCNT_ATTR_FORK
+			: XFS_MAX_EXTCNT_ATTR_FORK_OLD;
 
-	return MAXAEXTNUM;
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 static inline xfs_extnum_t
-- 
2.30.2

