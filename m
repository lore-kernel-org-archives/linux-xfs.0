Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF36C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241372AbiCUFUN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344376AbiCUFUM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4295A344C4
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:46 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L3mJKJ027331;
        Mon, 21 Mar 2022 05:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=PlDRDpV4Ca0ybP85a8jLFUO6INlovw4duX+aQN3HEUg=;
 b=e3XiFbHXTrQ5fz0/+9nIC+94U1rkm+K7yxBLWqh16jleaMw2MkAJZmgHjxruBF/HHh+g
 zQVa48ZOs1i7J/rqVYJEJEObacxoBXlWzodNzeZE+SAkamo+gDX4NSIYPLVGUfiOqZcz
 t/01js45YY4c995AUsaXXJI34uG2/xCOb82O9iJRMjwLemRzN1MkyNTefuyPmyUVmFc/
 xjwlfJ803c+fnxndro/44fQ2M2KgfJa+QGNUS1hWW6krbUT5EWsrcUrjiASbCSmAUa6S
 Yf/m/jZ0xWCghiac4IWhxPmq8W357DIny35kNGbjFqOJjmte3jXuVM7zfHjxSRRkoIvL Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72aa3je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5G0ih057967;
        Mon, 21 Mar 2022 05:18:39 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by userp3020.oracle.com with ESMTP id 3exawgev37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXB+6bWzrT+VKd28nsOrKwyfrqc7SDhz/wMjEYBmieQPOBYk8Zs+prgxR3w37yB75zXvStjsveEGcTngauErVK/wQxSxYy90v6eb2CHb8i3GiCl+kRntNOWHoDJton6XD1WQZBfrFiXkdCihjcUMtKnpz93vFHRzst32BSSJUb7EkZjX+NxiyPw/0vd+fxowizXxDD5r75wXTjwY1Qm2mZtDmJxxghe4Wue4/pGDcYyOM1AtVl7OQ+5c7wiNgOmFf5h/UnVAsU84qfkoAkb7AM9ExNVJP/bN7o1RsYPxUJSbgOma07dLCxwWVqZGHphKEtTgZCjiNQdumOnZCFRnIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlDRDpV4Ca0ybP85a8jLFUO6INlovw4duX+aQN3HEUg=;
 b=cfnP7yhd5E1m0oJJUEYuLrsYLufDJ9LcYkr4rARkhs2Ei18w8j0CTg6vLIJU6TkgLf7NpqYC8lETlHlvFYWEB49pBZFBmaioN+w3Layu8GZODLTnKy2/Dzvz9j4T5vBZg9LLc2wYFWybOBmf+tasPpkQacXzKYB/2bvJQyffYUlaaZtKZIyfVjn69utcHixnnk8kLkvH/d7rN9E1vm60tdPZSkpxD08pfmNNjQGy5K9tC54B9YJOR7M/mgmhoVonh0M6GUqTEc5BADpKrk/tTlxqMpdrTzDKrEKvQuWTAnjTkvS1KqsTP8Ttp1KBfxjLWwEyFH1XNtqZ3xsOclcXvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlDRDpV4Ca0ybP85a8jLFUO6INlovw4duX+aQN3HEUg=;
 b=kJMW2sAxMjhpMtprK19vSYh8L3vbhwHpOpoq/V360clx6XtUIxW+f3rLOLMJ1W08qltEsMAJkQ6j3a64a2r9JYL9ZroZ5cXljCKsiVz2uLqCYPddbGGED0xWOXW/7zh646NiPvHJINFKfTtKc0LvbXEbHj0/zJMw+MskbxqW7z8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:37 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:37 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V8 12/19] xfs: Introduce macros to represent new maximum extent counts for data/attr forks
Date:   Mon, 21 Mar 2022 10:47:43 +0530
Message-Id: <20220321051750.400056-13-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: c1e33d31-64f5-49e7-25aa-08da0afa40ee
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5537E9A27F69472FC184959CF6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6r6dvsJ/yeLHJkir7rkk4G0WYTNTGghX4vdzZVKvpNhwyLcqwHHjGzui9BZZkUS62ar1Hfgww2Yc+pwvkyzsJ2OeyfpBej8rvwLXqN7xvhU8xpZ80RzFuFg8UjKy07Fjgdz0PiYx4mHmhMxdDSyZncJPgMcbs0B2fnG7bGVPA6/RfTxTxM2q+9Vb+CteO4ivQ23GLsWJSnAJnKNS2tJwfgzhDzmHwCcbgbvbrQUf52xtXbyI5ueR7Dn9AIaSXi3RnJ3MbRP1d4SDhuhazFBYlJ6Z7GUtxYzY0aRlrQilxiUCRdfQFkbDiXDQ6PV4F4Lp+EEy6cNgZiSoUt4DiU5dM8AzH4XHsup0OXiMjkOagaFMEQn7nLUsW53vlYiRM4sfwXP4gF4DwNmhu4VXcjv1ncr3Kgpf/p3sq0/f8KIOHXTXj+QKIUbnPgqDs2bxd6IfGet30dzryAPclrOz9wDJueviHFnPoPsZj3nRvldtzdgyQgrR6nVFRXxvwe7RTHoMmO4XBnV4tcWRVuWXcXKerCDgpDfyZzfFdebPjkKuf2jVxRDpMH4fzvM66bjIKFYt/F/mHkTyAt638w/Nl+JnjQvnfKLx2uIkB0WMlhOaWroePKhbKcKIXKEoab112tbHB3NidDWtPHA4vLnsaznK/9FmMAr2w41L4Cs3V/QpGmUh9fOyx3T/s0ZgR2+TS36y8K8WbEl/J4mrtV/9P81lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cgXGaQ1kWoHZdaY09AWqdArtv/fPeDWSftRN59/LYSUUmvERkE0OE2v9C6Yh?=
 =?us-ascii?Q?z7tpqSLPDsC0RnNpkbncw8IwL1GC3hAfzULfhE+IWZZi57klMOw+XG+itT8H?=
 =?us-ascii?Q?nMOgeEuHFOhgdzSMspN4/3PkgP8Eu8lGBo94ZwDehGDqDKBWa0D3wgddRbvU?=
 =?us-ascii?Q?hd+7vXXPHJnAiCnpviUOV2T4vaS4tXXrhhrj3oUfAE33VQQKN8NHZ/8uNWYN?=
 =?us-ascii?Q?dFG6mbEhSEqxNEC4SfKWpwdbNtW1ChNFTA5RTL5zbdsn1d8CFUG5uA8BU2Ow?=
 =?us-ascii?Q?Ad6rBuLWpIdxhBw5D8i18LyOSKSDpxBHLzAgeW6CVm6eq0yN9Vh9cqMIrQCJ?=
 =?us-ascii?Q?Me/1y2Tmj0UZQMpQ7CrW4HSG/ALI5Te7uKVvjIA2uz/aY8QA3lR0lsvBhhSr?=
 =?us-ascii?Q?QvM0myE2JTwPpzcOOPk6Uf32g4uXiHp+2yWOHJ7kRAup2mXwD6Q9Pnj848JH?=
 =?us-ascii?Q?5pslqWmrtlWEkI+PwbOt99cXeKmVRStymYQCsGqLxX3/wNleLeusPthOxK0M?=
 =?us-ascii?Q?4TjL81tbxwqru+TeJjrxP9XbZsasnB8MSsjDeENdi4wO5UxP4h5MIMEDi9aT?=
 =?us-ascii?Q?i+O9V9Nq9z/m8VtDjKeo+XBNdAczeOaynmwaAhujYKhMrftYsa5dOyWWsLDa?=
 =?us-ascii?Q?OLxV1uVsyy9K/oGbWgvZoyM5YDdDPmghES8PujG/2WevDhbTtTICBu2VHDF+?=
 =?us-ascii?Q?ywXwk1uDJjUjymf1Ndnf13nu/SHynT2DFVk2jRyzqNqruDG/F86OhMcrozoi?=
 =?us-ascii?Q?7ScA9OaUa4L6N+ZrCZrIvGyo9ci0QLQdj6/+L7wfXxIsisLqsmwd8reSXuiQ?=
 =?us-ascii?Q?S8Y6ysHFye+H2X5gnVAnc75WBlYFWGpcAOu/87NiCg3AKjBLr9kuJHs57PzL?=
 =?us-ascii?Q?FUZNRBUEUp/MlCRUguOcWejOftbEk1Z9arVX5MwW5UWmiQROVZd99EmoN+Ga?=
 =?us-ascii?Q?EQOt6OlGONp9h6RaWK5JD3osvhy4uzfjCNVf+41cwboGv5pcforZpiw0htud?=
 =?us-ascii?Q?PbXDk/+SOWEdOVXcBN4M4XzbH03DC7rccU2+RIiKL0InKpU5fqsd31fwUx8c?=
 =?us-ascii?Q?lCFEquJeTZuGCt2wYbIkA7aH2uGpZyC7hVpNmUKkGl09PqF6KLCR5AsjludM?=
 =?us-ascii?Q?OA5q6L86TnB1qdqCxmasxLqOEB61sswGyajYzazlKh3GNQ4sZKhKOXA7YfwH?=
 =?us-ascii?Q?0wVBiyeNdgrNhKpWJsOSXmBDJZQqdTKDE8fE0D9P16R/PZbhzq3AHcYTm4/D?=
 =?us-ascii?Q?GLY0cBZ3Cxxu/sJTo2RUVVUBAkyqLztiVE4XTxxJ7EiM529omnR6VmmfUbA1?=
 =?us-ascii?Q?clVeXVSOBaTIcAx+gumG/DquknpaIZGvf0GjTbm3ke9gasOwpEHgKdq8NIHO?=
 =?us-ascii?Q?dAP7FCsXOVGcrZ38h/Ypm26sJtMc5qVdV7ePKzLUR5TxA1SbTYNPrFnBVbUL?=
 =?us-ascii?Q?QyCvaQ4ROlCY3q0vCKMlDY32BiIgD+cij/kWZClfPmDeu/tC9qATRQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e33d31-64f5-49e7-25aa-08da0afa40ee
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:37.5672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0l51I8IOmb0trTUK/UmK+01ZlHDA9K5vq0BKxFKRvYkOj+eNLvkiGS2KSSWKhtk1YL7GMGTzyDF+Wrt99RAWXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210033
X-Proofpoint-GUID: x3uNlDdx0zhmN7F0-S2ar0NAieKkNA9z
X-Proofpoint-ORIG-GUID: x3uNlDdx0zhmN7F0-S2ar0NAieKkNA9z
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit defines new macros to represent maximum extent counts allowed by
filesystems which have support for large per-inode extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |  9 ++++-----
 fs/xfs/libxfs/xfs_bmap_btree.c |  3 ++-
 fs/xfs/libxfs/xfs_format.h     | 24 ++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c  |  4 +++-
 fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
 fs/xfs/libxfs/xfs_inode_fork.h | 21 +++++++++++++++++----
 6 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b317226fb4ba..1254d4d4821e 100644
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
@@ -74,7 +72,8 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	maxleafents = xfs_iext_max_nextents(whichfork);
+	maxleafents = xfs_iext_max_nextents(xfs_has_large_extent_counts(mp),
+				whichfork);
 	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 	else
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 453309fc85f2..7aabeccea9ab 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -611,7 +611,8 @@ xfs_bmbt_maxlevels_ondisk(void)
 	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
 
 	/* One extra level for the inode root. */
-	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
+	return xfs_btree_compute_maxlevels(minrecs,
+			XFS_MAX_EXTCNT_DATA_FORK_LARGE) + 1;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 57b24744a7c2..eb85bc9b229b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -872,9 +872,29 @@ enum xfs_dinode_fmt {
 
 /*
  * Max values for extnum and aextnum.
+ *
+ * The original on-disk extent counts were held in signed fields, resulting in
+ * maximum extent counts of 2^31 and 2^15 for the data and attr forks
+ * respectively. Similarly the maximum extent length is limited to 2^21 blocks
+ * by the 21-bit wide blockcount field of a BMBT extent record.
+ *
+ * The newly introduced data fork extent counter can hold a 64-bit value,
+ * however the maximum number of extents in a file is also limited to 2^54
+ * extents by the 54-bit wide startoff field of a BMBT extent record.
+ *
+ * It is further limited by the maximum supported file size of 2^63
+ * *bytes*. This leads to a maximum extent count for maximally sized filesystem
+ * blocks (64kB) of:
+ *
+ * 2^63 bytes / 2^16 bytes per block = 2^47 blocks
+ *
+ * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
+ * 2^48 was chosen as the maximum data fork extent count.
  */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+#define XFS_MAX_EXTCNT_DATA_FORK_LARGE	((xfs_extnum_t)((1ULL << 48) - 1))
+#define XFS_MAX_EXTCNT_ATTR_FORK_LARGE	((xfs_extnum_t)((1ULL << 32) - 1))
+#define XFS_MAX_EXTCNT_DATA_FORK_SMALL	((xfs_extnum_t)((1ULL << 31) - 1))
+#define XFS_MAX_EXTCNT_ATTR_FORK_SMALL	((xfs_extnum_t)((1ULL << 15) - 1))
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index f0e063835318..e0d3140c3622 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -361,7 +361,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		max_extents = xfs_iext_max_nextents(whichfork);
+		max_extents = xfs_iext_max_nextents(
+					xfs_dinode_has_large_extent_counts(dip),
+					whichfork);
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 004b205d87b8..bb5d841aac58 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -744,7 +744,8 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(whichfork);
+	max_exts = xfs_iext_max_nextents(xfs_inode_has_large_extent_counts(ip),
+				whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 4a8b77d425df..967837a88860 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -133,12 +133,25 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
-static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+static inline xfs_extnum_t xfs_iext_max_nextents(bool has_large_extent_counts,
+				int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return MAXEXTNUM;
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+	case XFS_COW_FORK:
+		if (has_large_extent_counts)
+			return XFS_MAX_EXTCNT_DATA_FORK_LARGE;
+		return XFS_MAX_EXTCNT_DATA_FORK_SMALL;
+
+	case XFS_ATTR_FORK:
+		if (has_large_extent_counts)
+			return XFS_MAX_EXTCNT_ATTR_FORK_LARGE;
+		return XFS_MAX_EXTCNT_ATTR_FORK_SMALL;
 
-	return MAXAEXTNUM;
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 static inline xfs_extnum_t
-- 
2.30.2

