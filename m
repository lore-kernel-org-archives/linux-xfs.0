Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E20C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245219AbiAUFVp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:21:45 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:18372 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348658AbiAUFVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:10 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04X3C009028;
        Fri, 21 Jan 2022 05:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=DmPZ83LbDU8jG9VBzmyoxITnY7VhCu63+NGew+j59fg=;
 b=kLQEXrNTkoxgq3ZLcC7SQROUXk6jo1TjktT7eCkf0SnRLXx2RbAhk+c0JYLVS6PaNF3i
 emFiPvI3ztNEJHSWlt0PQHfxU0rFEwLs1NePruG1DFOQracxAzyjlxwC8eO6lGYB724o
 qZ0NkZeuVAnIvLNleMZPvdxn7JQiZ8I3yzQiGlAE3wjNizn6cfpfGRnWShtd4J/War7c
 0+bomFtldPhnKyuG5grYKiC7p6BP9KzcVsEcTpO9HKiG6PRZnG+SGzBGcuzUv6T0KXzI
 cwXZew1z0WmtX0xjGg+DFtXeKOA1mDEAtDwmDFd5qMvkFAKH1M2z3wcwahOo36/rjkaM ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhykrcqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KWc8007182;
        Fri, 21 Jan 2022 05:21:06 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh17d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDTwXovb09vYwnyYY9/Gsf7gm5P0xOQ8NS72u5hn5dgudRPwNJtl3MXocuR1HUMQcG1fqi2wacJ5vo9Y0uXlgOT9BbJSKbgWAmZFn0ah8/AMrQ2+Ryk781B0v9hyDBBrJ8XCbu2q/qc98xclCKL9XuuO/Y5BjxMg98hDOUbULItR8V1VsZpBUHSbX0eoBDiXBU37CO6ztD7xzD0flszkdlFMyqlFkuOM7OU9ZtmWN4NhWBnn7kMlpph+bjxG4K2wJbzGhxbvZ8XpnLNyKCh5bPOH11+bjJgAXnUKbHSbs1JtqD+gXCIF19Jiz4ewq8bMTTAcMkW8ml/hWqfVvN0j+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmPZ83LbDU8jG9VBzmyoxITnY7VhCu63+NGew+j59fg=;
 b=G7RAoNVcUhkq19tqHGLoJi49jK4SWQN448AUvODB8yNeQ+1+fe7exvLqRfNwDNEpFX5yrZo39CM4zHg4VzBf9eHikn3VD9vH6u2Zo0FC6aJEDlKw8Gey0BnT9R4ni6gLl/IDWPBrvmkn8GXlTQ9KVizcTyeUk5x9LiywDMJvhM+9OQHwZWOGmC6NDgyUSpt3+96ueXvLM9pmaH169p8U5//EE19XMsQSl5qOVosGvlWn+5LpKPAXYqVdLoFQYSUBIJaMA4CYgeJ1OGBvkK2t6NEZ5g5ULu/YksAwUL4pjjdnmZDb3NrlvICUQuApNlv/16mRJzK2tMtNnBWVBFhf5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmPZ83LbDU8jG9VBzmyoxITnY7VhCu63+NGew+j59fg=;
 b=GJIYfsDkM5As/UQw1CETkie4ktwTyqpMgBMWqgeLkjCMC1EnLuuW2LYDCs5Bpvg6xBC0IRS4J1sqfD/HpZYoJFWaZyr06KD3R7tlyjYO3AJSukA2stoDJiepAytVb0WauDyglVON1UrWldXTDOTC/lTXR/+qPlMAtV7CmXDPa94=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1477.namprd10.prod.outlook.com (2603:10b6:903:2b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Fri, 21 Jan
 2022 05:21:05 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:21:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 12/20] xfsprogs: Introduce macros to represent new maximum extent counts for data/attr forks
Date:   Fri, 21 Jan 2022 10:50:11 +0530
Message-Id: <20220121052019.224605-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7044d83-dd33-4ac7-e78a-08d9dc9dd22a
X-MS-TrafficTypeDiagnostic: CY4PR10MB1477:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB14777B66A493FFBE243DB73FF65B9@CY4PR10MB1477.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aoy4GmElJutNyFJY1gOEgEIM6PPEG7Rh5Vu8/4h18q+n+jaTK0wl5b0HG64f4m82pJ/6iczjm5VMzYQYLCiHPfqn+ru84txhwUe0z6AOhjmGl0Atdy1Bx8rr0zC4/cdPRMlUM18LJZTDy+z4LID3mfdj+9ocufXTDK9mWx27R+OO3Fn9RJafbWFuMlkOIH4KMdQ9WE7LYEWzy8OVoQc78tSdWiRwh8dOd2ERR18b7jx85oZBCyXx9k8vfc5Xia+/2rrcZtC6eW5Tc8sfedh4zz6cKtJnuYAA7jPYdu9zCNpsjcXK7G3MkycgJ69FkyKq6e6Zm0WwWjFBXlEG/w3E4KziWmns7fDBYwcmRbYP8MFGHm7vGAMQ39pkKWUqXJVMj++SnRaJcoUrVCnt2LD0qdYFKXHo7GiHZByFVwyZLuvLkQ2dp7QIqYDXeeHL82dR+fDwXKabfXs+FnMvXIznPVRA6qrUJg7JqCCes6B4rjoTsy3RjhsmC7VOcHUA66wNClWZRT5ag0r8Gp9VWpmOXc0OyMpBUl+VPU6RvfvXvWo9TYXsbdCUQ0cBzWWjtvRCBzJsoxH0Q+Cgq9tvhfrWKPVuQ2DaKrrqK98cuKkAT3YFLr0V9E/kNfRIlwhvzvEvnT9+4GOAt1akRuzaYVxcyGizvxrbgOYFWxozjWR75/6+xgQerckIX9SYVx58K7Z/4YHywNotELoiWbI1K+xCKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(1076003)(2906002)(66476007)(6486002)(66946007)(508600001)(52116002)(4326008)(8936002)(86362001)(6666004)(186003)(5660300002)(6916009)(6512007)(83380400001)(38350700002)(2616005)(26005)(66556008)(8676002)(38100700002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ktjAm2XU82OJchOZVVeRK29mejGX97I/8yjYrvGQ38pxs2BTMENHpKzGMOvR?=
 =?us-ascii?Q?p01WlL5lJgycwJmo5Or+o3qvoBZQ8iNpPGgI1dg/WcP/lJk/NFWhRseF7UB8?=
 =?us-ascii?Q?pyI7ysL1Cfe1tjLWauul9C/HJB195aBuFJAKRJNSYVYH9Jt1J4ILpoqcmHsr?=
 =?us-ascii?Q?jw8NpnWdcQZz7Bwd1nxepc5UnJD3nVW6BZJRRoxCKlbZAYvFSgYD80o8REd/?=
 =?us-ascii?Q?TVj/pxAfEXuTb5RUUdIHS2UP1cKSOVg1KmY5uAMBMDDV0bHM8hUSm0nNlMsZ?=
 =?us-ascii?Q?mUAwgMYR+tJHie23V1qxQo57x725Or6CzZpyzNfgQnkGE0IKgJNlvfUmpi+X?=
 =?us-ascii?Q?rgDB4mlB9b+CXNyf6+3Kb1EnS4yfA9oSMSyi7GDoGce3/lrfBrYIcP+CW7gd?=
 =?us-ascii?Q?Jx4CB0FFt+sllDd4NPsA47lDKYODA1EFviq2INnZ1IMc6KKaoBD886+yhqzK?=
 =?us-ascii?Q?LiahZH+Rjn7is7AeMdFfA7VtEosZL2H4O/+tLr2KmWPJG2+HUmqA6SEQ4MjL?=
 =?us-ascii?Q?ZpONQ6C2mlVrS01673V4Jw/yMrtg/exUSDmVaEy3gduhNmOcl62AlwyEkbol?=
 =?us-ascii?Q?yZvLv1wcJXv7ePWEBHczah7EiLf1PziV1FpuEWSHEwU/LdrRx4Foe1Ex14uj?=
 =?us-ascii?Q?cWpXDhg77Nnnvajc8+YPJ6nomnzN/Y4l5DlFokMtQuKZE6MObCCgHR10uitI?=
 =?us-ascii?Q?Xkg03iLYwymLmRLTAQaoin6vFY5ixn3zhZWgIzZ9CUiJEu6DRUgHdLU5ZjAl?=
 =?us-ascii?Q?NaKa7BzUDQTVsRWkHAmwrhsODrEgf5W6NgPX2u87Mk8otSSvV25Ya/WtppWr?=
 =?us-ascii?Q?J3AnA914FPebBqJH6NMTAS5AtTLgzfRiQd2sQhcZn0GVOSFUKGPa9/sR6vp3?=
 =?us-ascii?Q?VkqfPhz+CrVZfEsZmLVC//EABQw0HyG6jOcAskFUawaJIRhBtB67GVR4XPSh?=
 =?us-ascii?Q?RxiQ2ccPPtRaJt45lYeA3cVFPNlaBwrE9p9H+U+S0dkF2wUnEMBXGAKhg5Tb?=
 =?us-ascii?Q?0G88sZ500h2HHbu8/Vh1f2GJnMal+ULO4lRf8IrKDhywpf+oMf9BFFkJfBFN?=
 =?us-ascii?Q?k/Ode34Nn3VDXdme0Il1+TYUjFN60eT1rLvEaXnl116tzLE/XaFen72VBmSe?=
 =?us-ascii?Q?PBUFwRk+QavdS8ynJK7bQnF5kqanKvjyiHpIZHDXagVO3HsE2G+Rcx2Pe6pU?=
 =?us-ascii?Q?EtAG2FY3eSHSMWsy2mkDiXprylk1gmL61LjTJnUBiegegqWhlHCvaciM7OhZ?=
 =?us-ascii?Q?F0pZUsHtW0Rk9UshFs2F4mTa0HNpx+8HWDTFkUJ9ouM9LJz6EbrkzApP1+Bm?=
 =?us-ascii?Q?VEnM3HWMFQe5/tNxHpd/DB2G9bsR6DAKhmSVO2yLffDg9TV+PdipFXEYgk3h?=
 =?us-ascii?Q?kN3hWthhbIk2MLnyeYl/VH1cxNS48N310ydbNrNqLafUmrPu+JT5qwwm9uHy?=
 =?us-ascii?Q?vJqc1dA3rT8QOcj3vEyPUag2idBrAH4nh1VOZI1ZVNc/u05dEQzphhl73U8Q?=
 =?us-ascii?Q?rBdGJd9Hs5ntjAWxXHUc9YJVMSgNAw/O0CJRvjGPSOOIziEuQEHWsnMNDAW3?=
 =?us-ascii?Q?/Khh3zp+E+VUKANwC7Hwf9B5Q2kIbtVxsZAIWEBXdckNN/IBaQRUFRLWBEvg?=
 =?us-ascii?Q?8DFi5lfbSlxmb5rqkks6GuE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7044d83-dd33-4ac7-e78a-08d9dc9dd22a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:21:04.6622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dP3uknrOgHIIVvlPA8igJ6IZ67MX8ApHGzwk3bmQ/IJnI/n8djMC51du0L+ooPo947GioNphDLiD5N2kx9WZHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1477
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: 5ATRJOLF9-i2xLXSHyjAWNE83uxsswsg
X-Proofpoint-GUID: 5ATRJOLF9-i2xLXSHyjAWNE83uxsswsg
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

