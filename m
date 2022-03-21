Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007C4C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344390AbiCUFWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344395AbiCUFWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2743B556
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:13 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L3N2TW019264;
        Mon, 21 Mar 2022 05:21:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=LZ0Ew3N88WgfzdBIAZqc+mQ5qoZt25OTUy32PI7AJHg=;
 b=I/o1TZzjl2HpdYlbaD2V5vhmJxDCn/KzoSfHHVAM1Lzq03+Vm4tOkNSy/It3yaHKrtwh
 2L8Xu7DsGu1M1BM7nQUyUtZ7kY/Vvnzi6A6AtQ6C9XBgQyh+EFJM6o+3jl+t1sUizJ3U
 kY9MPe6w3XrA4SsKoEPGEMmamq+uKhmodVYbFlCkkH7DpdS3ncLCPrB6W2ApSHvpF6L/
 MOO1qDtAuS/e8p6b8OCnJ/yV8EmA+7cLMx+hP6p2geOq0hWq1ujzQfOyJ1DahMMybfou
 iQ0fxUrTYy4pah7pqXfziBaZ/h0dO0dCKI+/eTFu1x2J1sS5EbzdU/4NZW8VJK+rrBYK Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcj4tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5FvcF057867;
        Mon, 21 Mar 2022 05:21:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3020.oracle.com with ESMTP id 3exawgevv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaodYIclXDVU7MnsqDdgq33fHCntk9A0vV189oZAFpgU/ZdOMb/sZzVcgKZWUjlDiaikhXqFWMwT2Nh6AO3SAkLBDzCQxTXKnVy6+ShcYS+5jkBMAs3iK9ybLi9keveDwwzv5Zx45lB04nJaYl3HSav/umSlywUybh7WRLhdRQpRroL1d+CXSBVx2AgqS+ipGVw10YLMiojrB7mJ6idF6UJ5MZf0J6MdnR/X2YeDRc10uEn8ZT3bYSvCgSXPcWP+vleBcmgvHN0cJq5lFKbCOw/ZfAZ1ybBgvch8kMxLW497sdmPN9riuaugLsFGCcmqT87C2HyGW2HrSarAi4KHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZ0Ew3N88WgfzdBIAZqc+mQ5qoZt25OTUy32PI7AJHg=;
 b=GCNqdPOOE1u0PAB8Xa0Zmbkn8kcy16dK8mCvC5kUJfuP+CTcd13J8h0WlBIkoOkqIJsc9nbzGiLK4YAa3+PhToDfCtQMRupUeRTT+2FRODmr51LmPXQKlyhXNIBN3pPd8Jw3imb6aNLSLn0yAy0Zbfar3fkYKlcmsU2zI2tlwxC7GOBRmJOzXBYy/zG/tnUr2o1iKbTOLwoAjh9RkZg5AE2rJN1o1XeWI/pBWWmes2LGP4FMSQyYNazBC/MuUqRpslUQS/K4ZdmzO0VnQBW59HcPMmDAmlG/hI6jWk5lNgbP8ntHfpTV6gs7oycsQrNns8ioI4GJjs/XeaWfmW7afA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZ0Ew3N88WgfzdBIAZqc+mQ5qoZt25OTUy32PI7AJHg=;
 b=xvf3WK2fjfIXBfTYCtSVmPMN1UOo3gfFSfYOP35w/EHIqx79h8StW0rAOmMYwv1cp3CVvHNZukKLsJrOg0w8ylByphoBavEbsbCIo0ySthq3xTVTU6zwxFVTLP+jYzW4axV560776AxVjkK4ZZVMoAqMhyE3kHRjz0LA/GKkNps=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:21:07 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:21:06 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 12/18] xfsprogs: Introduce macros to represent new maximum extent counts for data/attr forks
Date:   Mon, 21 Mar 2022 10:50:21 +0530
Message-Id: <20220321052027.407099-13-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8fd66f16-681e-4362-02a0-08da0afa99fd
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55637667E1BD573311C77B3AF6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kz5QY5wvhipwyjPDAdTFtiwW5FqMhik9yfoBSwNgoMQE1Y26TKPqbddbKcXVQS8VhTFON2702ACKrK0KmTTJGdocXFFW0kPikhSgKPPkJGecpHpAxfs8mhOK7jTUY5tWPOPrE7RGoLbjG1DYhNCcQHQXrNMbwZzY6+Szn8nUN/v9ujA+pSwqAIEGVUnclu2YhdS8WDrv0pqFYh2q6wKyZtPINYLGXSWtUzfPzLK6CCQtQlcv6v4g+YXAz+HVSrQ9rXhSuGe4+ktxGGCOR7ka4BEpi2mQwoBK+pw76kTolTD9RhiMyCukVWTwi6Md+QZxigl3WOzTJV8f1Sj9nBkWKnFJfVBQb91bL7fL8PCFXUh9ffg1n1h2+Yv71W1DDk/UjcX8VM5e9N3Fh3/lT/PqdhdOWRU9yjpk5J25IdGOkTpyUFAidY86RDHiYQfwp9/EiYtq46VkHfD0Fm4aDMcQLe/U878l7Zq6DC1pkNHORvAs4JaOhuKjF6nwHm4Pxg2j2P8e032I97doE5tm8Xl5ZMBSvZBI+i/SVaON+pFgGCB2qJSGn2z3flUbqzsmpOMs3fpi0/B6L/t1QWT1MMQsx1jPESAiw+wSmUmxckY1mhIDVeaHbEa8P1Lk7Au1frrd/bZWwBmS3DhLz2gVKTuVqWyQo65cMIJbjq5WTMbOALD9RRCrJByFQ7EgYxsBF6VnNg5Y47L1JQM5Mf2rkRYqaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+LeJltfrmAh4Gv5LTtKoN2ELsnTkLRZ/leaZcud+Mbrq5yctU/4yMV07eiSX?=
 =?us-ascii?Q?fJJLNcuitah8uMKYW3EuYKZpU2EesFbRcOWlsZkH6DV7ss4SoVLmAO5jvHYj?=
 =?us-ascii?Q?/KtyrNnZjDj4gkn8RrpgUel8gcHKQ31fVhGel6U4wiK8FD9t9HOs9ekjN6gE?=
 =?us-ascii?Q?Dq3atn3zSAIOYbPEd6aWyiLLbNIGqBUrHlxXwCt2X05GH3iQGu5yJtiuGNzT?=
 =?us-ascii?Q?JkwEj1H0ajj2Lc4q7ioF5WbmOMnH0CxdGo92sYtHAKDIdHbbej1nL59O16D0?=
 =?us-ascii?Q?hUX9OrRLSiJqO+QwLjsSm666PYln+CyxDr3rNuWAu+mxYtKwUrpzXbMInJZ/?=
 =?us-ascii?Q?8YdvHIxqpZopoqKbo8+M2JvgMgVXhKLNKi1HEQhcrTQA48hYSVXenbdxAZJN?=
 =?us-ascii?Q?yQWxmsOPMe1zOLMRIHtBWyaRHyTyyEVrJEIC/7gn3fYB51Zsc8w+yYEA4zI1?=
 =?us-ascii?Q?uLUuSCwlnZYixYJAFCflGN4BTrD0/7c3XU1ms8C2yMFsPHLGf4Ad66787OvW?=
 =?us-ascii?Q?KuiMxuyveXS9lZq6bIee8Czg+o/S86y2AipMEyIUPHB0/XgTls/u3A18R1/6?=
 =?us-ascii?Q?Yk2M3cCA8triHhKh+ZmAfbAOP4NqZJictF2BmN1WIN8aW44Nyr2WOje/ovAl?=
 =?us-ascii?Q?k4ElgHfWJ+wSDHFM/IuJzkXD+6kxJOPrMiVfTZeiBolU3VH44DEqt3/3vHdm?=
 =?us-ascii?Q?m8cEOmAxD0kWY1WySek7yqSV/gkO0bX/8Tb1sY4Qemf8claD9fm8sFYPW3ZE?=
 =?us-ascii?Q?QnmGdqFphZPMxvJu1rYVoVD9LRPJu+6iSc7qsX5o6f50vaEFIYR1YNtfmRLz?=
 =?us-ascii?Q?+d8ujAke+Mv4FR9vzRh/JOUyeWhXjx1RjbdjKc2a9EYiwIZgEuJ5ufEbo935?=
 =?us-ascii?Q?goxKkFMwZXvJVSprWqEGR6Jt6wlt/3BfWIwVbQrtAaBrIT4eF10DwhwFcabV?=
 =?us-ascii?Q?mjHnay8+YZSJlrPDQEg83r6NNtLxRvGJX9W0BHckqN0lUUAfCZeBpp4N1/5j?=
 =?us-ascii?Q?dwGfTagwVy9w75o45vfd6WwxtRtwsU1Pp1x07YsNQyCmb1l2R5OnY5eAYzM5?=
 =?us-ascii?Q?vGsjfZAOKoNyeTK7rcuO5GkNCefEoIz+e7AL25qISBLb2KOoI0sb/WVlf30x?=
 =?us-ascii?Q?qLnTZQU8Z81MXqFK3YL37nZgqXOjUYiAQvNtxm8Pq2BZfQrAfVk62v5pRJGi?=
 =?us-ascii?Q?ddKa+PofsenrE8sKfKe9A/KyvFcLH2joNukUX6D1AkX8hcygA5Z3tG0Kvo6t?=
 =?us-ascii?Q?5FVvF846pwuI8Q8dMbGBhpqCjogIQ8uDw0NQ98Ox/WpAWAxBxbBuPaYRTMIH?=
 =?us-ascii?Q?A4jJXcG+0gVwgug6gp0Pj4M6dmzvtcV2BwCtw/a50AC32QghTiTrBfm3lRJU?=
 =?us-ascii?Q?AHfYm17dfY/Xxzxsh/dsJKRoJsaw/+aeHaCXs3Fh5LoTeoolVtePI5t/sXIj?=
 =?us-ascii?Q?4zZm34cK6oY+HvKCzPL4tSx2YUZ6tgGFSimhwSJaUSWkF6I40lJRtQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd66f16-681e-4362-02a0-08da0afa99fd
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:21:06.8568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cToepjunIjIUtOwJx0jF0D09plIbnDYNp/20/dt1lJN/yWuxwia4CoelhtawHNZMFBVrTexNg2Dv7gj8LJnIsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210033
X-Proofpoint-GUID: sUeT1Io1Ju6jwuyHv1pNfJ7DWrTR9FHK
X-Proofpoint-ORIG-GUID: sUeT1Io1Ju6jwuyHv1pNfJ7DWrTR9FHK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit defines new macros to represent maximum extent counts allowed by
filesystems which have support for large per-inode extent counters.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c       |  9 ++++-----
 libxfs/xfs_bmap_btree.c |  3 ++-
 libxfs/xfs_format.h     | 24 ++++++++++++++++++++++--
 libxfs/xfs_inode_buf.c  |  4 +++-
 libxfs/xfs_inode_fork.c |  3 ++-
 libxfs/xfs_inode_fork.h | 19 +++++++++++++++----
 repair/dinode.c         |  8 ++++++--
 7 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 88c0ccc4..ce2e78ed 100644
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
+	maxleafents = xfs_iext_max_nextents(xfs_has_large_extent_counts(mp),
+				whichfork);
 	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 	else
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index ba239d6e..da771e06 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -609,7 +609,8 @@ xfs_bmbt_maxlevels_ondisk(void)
 	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
 
 	/* One extra level for the inode root. */
-	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
+	return xfs_btree_compute_maxlevels(minrecs,
+			XFS_MAX_EXTCNT_DATA_FORK_LARGE) + 1;
 }
 
 /*
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 7b08e07c..da3cd6e7 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 06e7aaaa..d4b969c6 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -358,7 +358,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		max_extents = xfs_iext_max_nextents(whichfork);
+		max_extents = xfs_iext_max_nextents(
+				xfs_dinode_has_large_extent_counts(dip),
+				whichfork);
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index dbaff8ba..1f04ad06 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -742,7 +742,8 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(whichfork);
+	max_exts = xfs_iext_max_nextents(xfs_inode_has_large_extent_counts(ip),
+				whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 4a8b77d4..623049ac 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -133,12 +133,23 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
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
+		return has_large_extent_counts ? XFS_MAX_EXTCNT_DATA_FORK_LARGE
+			: XFS_MAX_EXTCNT_DATA_FORK_SMALL;
+
+	case XFS_ATTR_FORK:
+		return has_large_extent_counts ? XFS_MAX_EXTCNT_ATTR_FORK_LARGE
+			: XFS_MAX_EXTCNT_ATTR_FORK_SMALL;
 
-	return MAXAEXTNUM;
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 static inline xfs_extnum_t
diff --git a/repair/dinode.c b/repair/dinode.c
index 4cfc6352..f0a2b32a 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1804,7 +1804,9 @@ _("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (nextents > xfs_iext_max_nextents(XFS_DATA_FORK)) {
+	if (nextents > xfs_iext_max_nextents(
+				xfs_dinode_has_large_extent_counts(dino),
+				XFS_DATA_FORK)) {
 		do_warn(
 _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
@@ -1826,7 +1828,9 @@ _("bad nextents %lu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (anextents > xfs_iext_max_nextents(XFS_ATTR_FORK))  {
+	if (anextents > xfs_iext_max_nextents(
+				xfs_dinode_has_large_extent_counts(dino),
+				XFS_ATTR_FORK))  {
 		do_warn(
 _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
-- 
2.30.2

