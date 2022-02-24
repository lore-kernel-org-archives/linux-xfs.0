Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF20C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbiBXNFF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiBXNFE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:05:04 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3597837B5A9
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:34 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYEa1007293;
        Thu, 24 Feb 2022 13:04:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=DmPZ83LbDU8jG9VBzmyoxITnY7VhCu63+NGew+j59fg=;
 b=RSPhnP+RhW+9mLGclRj23m6i2KAT6pGXk+CgotqZuwO3WwSLeogdUzUQIVYy0yNutIjB
 +76p+uqY/XXk6MtrJlnHWvoeZx2ikBfhGzt7G9EO3viTgyRRLMKJV30QlgPnzOpcIbKS
 Nt4rVCk2DIFQOpyOSJdaE+YvCT8VRyJzZxNJCZNEz76LwNsMx5j0D/3X8rLv0z9/xv1h
 OznOPkviGqMqXl4bVN//H5dtcrPd2GgPdkR+1Wg2aICQfKdaRI3gdYuHNniUy58DOhuV
 QGcNjOgT1+5G18mFo0D5AhB1VaYHWdkxCnFIY+LUS0/uJC6vZsBDoWInHou6dIFU6sJ1 CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx7b5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0t0d169542;
        Thu, 24 Feb 2022 13:04:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 3eat0qs4a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i99EPRSP4HZ6xKuNRavk84HGjnWaAqXFksmWkOpo6yFgA7rlC+1rbtIw3OlpjG1EXPdDBPr6Hiz5jGamGc3MNbKNHZfNCn2Mn87Dc/mzSJSh2jaKvhVeutbjTH+fT/qx26NTNFtaR0T1k81UGZc0De6fv6E0irNa43Xg+DUlDN14a52NRuPHw2BB1eYyxJH5VSStj6CNn3M6wiZzC+rNS9y8nlqb4IxjAl2uPXcmB/j6J8jrL1BgdUxrelT2/4QJmv42smkJAPMJGScR+H6HtxUvPmT1v3wNGIay2THUdiEqB9koAl5P8qoBPa70+j6K2Ez7mzd62UAEjHx8WXan1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmPZ83LbDU8jG9VBzmyoxITnY7VhCu63+NGew+j59fg=;
 b=cH/Hj4gR+JugXa8t8/3PCEQYfjT0WxZ7qqx+v1a7esB0HXqshBVErB0T89DuEdv+LQORlE47ht9r1+SzwBNdbZRzvGZ3H2uxyaq4tmLIvben1v17MM8JEnqO4NPJhRNoZCa9ilTFiIZjW58+KkIemt2ceMMLcavXP9TApSaHj8lBZdFKIR5xcdT/EQdiIvpUf1AEy/cPB+dSsiyuP8kjpxQ4O5DJZ0PMXlGNEtOBBAh7RlFZBOcp/WehBuTgRwBusDSAN+iiK0/+ZSz7gg8JNDzlbwi4ZUDKYVSqWzfG0ec6WHCv2iE8JCkVkJP1GFxENiOpHZbNdLOvJxHAG0PpLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmPZ83LbDU8jG9VBzmyoxITnY7VhCu63+NGew+j59fg=;
 b=so/JSrz1qupxQoyhBECycT/CmVUhIRY6WNrPTzkYZNZmfWGmt9ZxQOiy4vDqQIwW7iKEth9wzFHS54cgIMFoQHKDYXEypYQmlF+PMijBjG4Ge0Kmx+sBIAT/qQazvt3It/1uO0XaEJ7nUi4w46kjkbPaqCgN1JOphX75QC3qhMo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2172.namprd10.prod.outlook.com (2603:10b6:4:30::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:04:25 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 12/19] xfsprogs: Introduce macros to represent new maximum extent counts for data/attr forks
Date:   Thu, 24 Feb 2022 18:33:33 +0530
Message-Id: <20220224130340.1349556-13-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: b6f3e9e3-2e69-40e6-98a9-08d9f7962e87
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2172:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2172EDF8AAA00C43B1043753F63D9@DM5PR1001MB2172.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4nEFqeFO47+dH4ApseBD7mG9CYrfYdcvrYv9CbqBL7zqsRJobP5hI2ijM+pKfIv4NE+j9Xl67W6sivyBJnEgy5vwRvd016lApBdX2SMJ8pWT+uJYoLU2dQMh2hR02pGRIGRwR6nlveUmycuxkwrMxhmorVtiJNs1ciyJZYE/fQnGeRRku1UPqdm/08nunZtq6Ipy3zL+jesHpxpEd2W2ax1KPEDc/ky1TTd2mlp9KYcJ/I68CYGn8k3uyrMHcxKvbqmBYL6Ivk9V8qjjhytsxIlEeB8uNaauLCuYxAh8GS8D4NsgXIlvoFqjmHK7viXvgZIr3vUrVJmYgl9zg0HtLjgW0U/Zat4kVWR7xf/hJBRvivDg0JHbQ9ii/2JsWMZ6JuTXbgXhXjZJe2IRx6UUyfaWOj4mrWQoY78FF/RTcUTkZnobtNSd3cmjQbAFFjEeTjw/am5PoMxCYxoRM+xvoFd+j/0tIDXYVljJEAGRym9FnRJgRvw+UZMj4mFiOhx5xSpieVnKiSr0XNAVITyhxhBdEAU3WLAtnedVW1MjguMf3h9fLaPB8rDP9il/eb2xBcfX1Mh+7Quvu/HrmIUVANNenIJgAutbMP2RdVmUo+ib7KKt3w932ILlWGExGeytkDith+LU8Ma/lzQjtafeWawHL9/++qBMF4mQWoFljT6vhXWU/sbK1/0ztzpHimmK/L7IyibdvGfwTcS508qdjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(4326008)(508600001)(6512007)(316002)(66946007)(66556008)(38100700002)(8676002)(66476007)(5660300002)(38350700002)(6666004)(6506007)(52116002)(86362001)(36756003)(2616005)(1076003)(83380400001)(26005)(186003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dmy4l6lZhSa8rL+pc2w0SHbyO2fzPWrf8uMgo8+jibVHN6QD/+sjsSP2d2XL?=
 =?us-ascii?Q?o/8hkNkor0Ru4gBvmSBUi6Kt9mQC3Mk2rYmhtlSN7kxa1LwWL7YdnzhRGZ7m?=
 =?us-ascii?Q?cfbkS6RDYOTuC01Oip/AhaDaqcTPYmyL5ICYwVa3EcjC89CRLurJkMROkttU?=
 =?us-ascii?Q?hfFtDAkPUejSm21992/+64MNFocAmhHKuUPabkF3zKgSUPyNasr3Mb+b+qd0?=
 =?us-ascii?Q?D7Io0wAgpEW9m5aFXc9DJrWaJsMN88zK7lYh9QKXswxJvmi4II4LWjqkgVEO?=
 =?us-ascii?Q?hZU1cTBwbRRcX2cpS79lWqAnzyO0XONy2u8m7xIFlb7snCW7+lBj9OcxgjjL?=
 =?us-ascii?Q?l1cVLp5L0ytUbYF8+RUCIz7oKVVlm5Deg8i0KYVYKkBCo/X7q4mzBregdw/n?=
 =?us-ascii?Q?3ITjYk0rb6nAPJ69YVY85/9avfpx9SIM0uEd2lXlq+iVkGcxibSsmS9aRKTq?=
 =?us-ascii?Q?hgsMRffs718/l6MMSY5U4TXapBr+MeQ0oZ9LWYHZhXn3ayXVeu6j11cBonvA?=
 =?us-ascii?Q?dLd/lR+XkXNX01uwnCi8MheYPXEcdT9AouwpgPSs+lPWpD4QApQJGgt5dKBv?=
 =?us-ascii?Q?+Psw/NbRoBQQyRUFTYq4H3YJRP3aBEijKE9TeL30V/9qJfP+TB9Ja9+vjDMj?=
 =?us-ascii?Q?Cbm6d3pv2uTcIlZRuB9PeN2jivcaTbYgeAWQeRxaT8cWw+a2fs/0RzwVKQXr?=
 =?us-ascii?Q?ZO20KB9/faCJZsRi6pbGBMxlxcOcyIanjIBcWRh170ZQquKZ8getbTwv9Dc8?=
 =?us-ascii?Q?A/ksx94RSXRaRyDWqc1l/nxPD3w04/q/GkEy5lE9dk5/cuVjUF2EN0KbHDU0?=
 =?us-ascii?Q?3H6pWlXVjpjlVnaR5ZjF20ZypA5wnRZyUV6gdOvCX4AA5XO6yKQAvDZOMpnF?=
 =?us-ascii?Q?dC5HdxJmpUJdE9w10AJSQ56RuvDih2NUNH1NnN9S3o0s8PGQduSfydsc7TSP?=
 =?us-ascii?Q?zko4Yn6cGpBBnmVyHcLz0aa/NgYzlaWBl/IoG5cQMKXSM0p8bxG9R/t3zg+b?=
 =?us-ascii?Q?c6nyVORuEkPjzENWInkDnaSIA25Mt8mpa11U5qWdWsJhnmMYmhRjGrFLqSAL?=
 =?us-ascii?Q?LMF6F6SbSOZRgOPbsTCssXSpAq2RvTaM4UOEJIiTsfi6/W/NfjQ19nO2YqOt?=
 =?us-ascii?Q?l/3BLc7IeCQOA92ehQIUkUyWM6myAotCInDiXsSmbVK3VgijG3Vuc9OQApDu?=
 =?us-ascii?Q?xEGuby4gIWU9hdS26NeeFVtfg32BWH7/sT1A11b0X1to62ngS4rw9kOvjB5W?=
 =?us-ascii?Q?JHRsrNcR9sPXJjVyMr67jRPKV/lbpSYsyIKX4yZzK2zI2z0KiYugbSKXqJO3?=
 =?us-ascii?Q?Wy551GFf1v9ehvKYwIk8fCRcRiISevFi2K06R4uJ1hrpxKEj3rvjk5aR7iLf?=
 =?us-ascii?Q?qvOPt0ZCogirlUDeFVuj3mLx6C1/F5iC2OwhMI17rPc7cEADafJ2o8PoxsLP?=
 =?us-ascii?Q?bhcXU1eDMp0hhddmacseU6iFapLjz9V0X6neyEE1kZqvrsU8mGaWTyjz8wTw?=
 =?us-ascii?Q?2mz4k4Z7bHKnWiZXkHmEKT+o9QzqR83vFKEwcJ3arJmlHA9BZS14v+4GStN0?=
 =?us-ascii?Q?nkajyKCCd3exDcQ5VOR+jiOTxPfgDfmd8586Afke9nTZspwl2CjdjR9Ka+Q0?=
 =?us-ascii?Q?t5FVS4v6yyDHGQ4b9iDGcI8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f3e9e3-2e69-40e6-98a9-08d9f7962e87
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:25.0397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 84+xDLx/TusPu12LGOzYzSUFw3zti6QoZWzf7QQoumT1CiuvGBIonfZEce+aGc15xfRWjw/eLJTY+RjVAiUScw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2172
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: p6msp1KfGb8OC24lpzZnK2q_QDQb9Uri
X-Proofpoint-GUID: p6msp1KfGb8OC24lpzZnK2q_QDQb9Uri
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit defines new macros to represent maximum extent counts allowed by
filesystems which have support for large per-inode extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c       |  9 ++++-----
 libxfs/xfs_bmap_btree.c |  2 +-
 libxfs/xfs_format.h     | 20 ++++++++++++++++----
 libxfs/xfs_inode_buf.c  |  3 ++-
 libxfs/xfs_inode_fork.c |  2 +-
 libxfs/xfs_inode_fork.h | 19 +++++++++++++++----
 repair/dinode.c         |  6 ++++--
 7 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 51e9b6ce..8dd084b9 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -54,10 +54,8 @@ xfs_bmap_compute_maxlevels(
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
@@ -67,7 +65,8 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	maxleafents = xfs_iext_max_nextents(whichfork);
+	maxleafents = xfs_iext_max_nextents(xfs_has_nrext64(mp),
+				whichfork);
 	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 	else
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index ba239d6e..02b36620 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -609,7 +609,7 @@ xfs_bmbt_maxlevels_ondisk(void)
 	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
 
 	/* One extra level for the inode root. */
-	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_EXTCNT_DATA_FORK) + 1;
 }
 
 /*
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 9934c320..d3dfd45c 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 29204e4a..b3f6be93 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -358,7 +358,8 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		max_extents = xfs_iext_max_nextents(whichfork);
+		max_extents = xfs_iext_max_nextents(xfs_dinode_has_nrext64(dip),
+						whichfork);
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index f7fa0af5..9e80396a 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -743,7 +743,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(whichfork);
+	max_exts = xfs_iext_max_nextents(xfs_inode_has_nrext64(ip), whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 4a8b77d4..e5680343 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
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
diff --git a/repair/dinode.c b/repair/dinode.c
index 4cfc6352..54efe571 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1804,7 +1804,8 @@ _("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (nextents > xfs_iext_max_nextents(XFS_DATA_FORK)) {
+	if (nextents > xfs_iext_max_nextents(xfs_dinode_has_nrext64(dino),
+				XFS_DATA_FORK)) {
 		do_warn(
 _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
@@ -1826,7 +1827,8 @@ _("bad nextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (anextents > xfs_iext_max_nextents(XFS_ATTR_FORK))  {
+	if (anextents > xfs_iext_max_nextents(xfs_dinode_has_nrext64(dino),
+				XFS_ATTR_FORK))  {
 		do_warn(
 _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
-- 
2.30.2

