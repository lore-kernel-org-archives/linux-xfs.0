Return-Path: <SRS0=tkuD=5U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9ACC2BA18
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Apr 2020 08:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7274A20737
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Apr 2020 08:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgDDItl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 4 Apr 2020 04:49:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbgDDItk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Apr 2020 04:49:40 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0348VfRX111621;
        Sat, 4 Apr 2020 04:49:36 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 306mcptn75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Apr 2020 04:49:36 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0348naqD143854;
        Sat, 4 Apr 2020 04:49:36 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 306mcptn6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Apr 2020 04:49:36 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 0348jiGQ011314;
        Sat, 4 Apr 2020 08:49:35 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 306hv5hp5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Apr 2020 08:49:35 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0348nYHE62718432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 4 Apr 2020 08:49:34 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CBC6BE054;
        Sat,  4 Apr 2020 08:49:34 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11127BE04F;
        Sat,  4 Apr 2020 08:49:32 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.87.225])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat,  4 Apr 2020 08:49:31 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH 1/2] xfsprogs: Fix log reservation calculation for xattr insert operation
Date:   Sat,  4 Apr 2020 14:22:28 +0530
Message-Id: <20200404085229.2034-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200404085229.2034-1-chandanrlinux@gmail.com>
References: <20200404085229.2034-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-04_04:2020-04-03,2020-04-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 clxscore=1034 bulkscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 suspectscore=1
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004040075
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Log space reservation for xattr insert operation is divided into two
parts,
1. Mount time
   - Inode
   - Superblock for accounting space allocations
   - AGF for accounting space used by count, block number, rmap and refcnt
     btrees.

2. The remaining log space can only be calculated at run time because,
   - A local xattr can be large enough to cause a double split of the da
     btree.
   - The value of the xattr can be large enough to be stored in remote
     blocks. The contents of the remote blocks are not logged.

   The log space reservation could be,
   - (XFS_DA_NODE_MAXDEPTH + 1) number of blocks. The "+ 1" is required in
     case xattr is large enough to cause another split of the da btree path.
   - BMBT blocks for storing (XFS_DA_NODE_MAXDEPTH + 1) record
     entries.
   - Space for logging blocks of count, block number, rmap and refcnt btrees.

At present, mount time log reservation includes block count required for a
single split of the dabtree. The dabtree block count is also taken into
account by xfs_attr_calc_size().

Also, AGF log space reservation isn't accounted for.

Due to the reasons mentioned above, log reservation calculation for xattr
insert operation gives an incorrect value.

Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.

The above mentioned inconsistencies were discoverd when trying to mount a
modified XFS filesystem which uses a 32-bit value as xattr extent counter
caused the following warning messages to be printed on the console,

XFS (loop0): Mounting V4 Filesystem
XFS (loop0): Log size 2560 blocks too small, minimum size is 4035 blocks
XFS (loop0): Log size out of supported range.
XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
XFS (loop0): Ending clean mount

To fix the inconsistencies described above, this commit replaces 'mount'
and 'runtime' components with just one static reservation. The new
reservation calculates the log space for the worst case possible i.e. it
considers,
1. Double split of the da btree.
   This happens for large local xattrs.
2. Bmbt blocks required for mapping the contents of a maximum
   sized (i.e. XATTR_SIZE_MAX bytes in size) remote attribute.

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c        |  6 +---
 libxfs/xfs_log_rlimit.c  | 29 -------------------
 libxfs/xfs_trans_resv.c  | 60 ++++++++++++++++++----------------------
 libxfs/xfs_trans_resv.h  |  5 +---
 libxfs/xfs_trans_space.h |  8 +++++-
 5 files changed, 36 insertions(+), 72 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b57c7080..00cdf529 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -337,11 +337,7 @@ xfs_attr_set(
 				return error;
 		}
 
-		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres *
-					args->total;
-		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		tres = M_RES(mp)->tr_attrset;
 		total = args->total;
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index c8398b7d..69e8e40c 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -15,27 +15,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 
-/*
- * Calculate the maximum length in bytes that would be required for a local
- * attribute value as large attributes out of line are not logged.
- */
-STATIC int
-xfs_log_calc_max_attrsetm_res(
-	struct xfs_mount	*mp)
-{
-	int			size;
-	int			nblks;
-
-	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
-	       MAXNAMELEN - 1;
-	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
-	nblks += XFS_B_TO_FSB(mp, size);
-	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
-
-	return  M_RES(mp)->tr_attrsetm.tr_logres +
-		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
-}
-
 /*
  * Iterate over the log space reservation table to figure out and return
  * the maximum one in terms of the pre-calculated values which were done
@@ -49,9 +28,6 @@ xfs_log_get_max_trans_res(
 	struct xfs_trans_res	*resp;
 	struct xfs_trans_res	*end_resp;
 	int			log_space = 0;
-	int			attr_space;
-
-	attr_space = xfs_log_calc_max_attrsetm_res(mp);
 
 	resp = (struct xfs_trans_res *)M_RES(mp);
 	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
@@ -64,11 +40,6 @@ xfs_log_get_max_trans_res(
 			*max_resp = *resp;		/* struct copy */
 		}
 	}
-
-	if (attr_space > log_space) {
-		*max_resp = M_RES(mp)->tr_attrsetm;	/* struct copy */
-		max_resp->tr_logres = attr_space;
-	}
 }
 
 /*
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index f0b48a7d..e0c99352 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -16,6 +16,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
+#include "xfs_attr_remote.h"
 #include "xfs_quota_defs.h"
 
 #define _ALLOC	true
@@ -696,42 +697,36 @@ xfs_calc_attrinval_reservation(
 }
 
 /*
- * Setting an attribute at mount time.
- *	the inode getting the attribute
- *	the superblock for allocations
- *	the agfs extents are allocated from
- *	the attribute btree * max depth
- *	the inode allocation btree
- * Since attribute transaction space is dependent on the size of the attribute,
- * the calculation is done partially at mount time and partially at runtime(see
- * below).
+ * Setting an attribute.
+ *      the inode getting the attribute
+ *      the superblock for allocations
+ *      the agf extents are allocated from
+ *      the attribute btree * max depth
+ *      the bmbt entries for da btree blocks
+ *      the bmbt entries for remote blocks (if any)
+ *      the allocation btrees.
  */
 STATIC uint
-xfs_calc_attrsetm_reservation(
+xfs_calc_attrset_reservation(
 	struct xfs_mount	*mp)
 {
+	int			max_rmt_blks;
+	int			bmbt_blks;
+	int			da_blks;
+
+	da_blks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
+	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
+
+	max_rmt_blks = xfs_attr3_rmt_blocks(mp, XATTR_SIZE_MAX);
+	bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, max_rmt_blks, XFS_ATTR_FORK);
+
 	return XFS_DQUOT_LOGRES(mp) +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
-}
-
-/*
- * Setting an attribute at runtime, transaction space unit per block.
- * 	the superblock for allocations: sector size
- *	the inode bmap btree could join or split: max depth * block size
- * Since the runtime attribute transaction space is dependent on the total
- * blocks needed for the 1st bmap, here we calculate out the space unit for
- * one block so that the caller could figure out the total space according
- * to the attibute extent length in blocks by:
- *	ext * M_RES(mp)->tr_attrsetrt.tr_logres
- */
-STATIC uint
-xfs_calc_attrsetrt_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
+		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(da_blks, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(bmbt_blks, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(xfs_allocfree_log_count(mp, da_blks),
 				 XFS_FSB_TO_B(mp, 1));
 }
 
@@ -895,9 +890,9 @@ xfs_trans_resv_calc(
 	resp->tr_attrinval.tr_logcount = XFS_ATTRINVAL_LOG_COUNT;
 	resp->tr_attrinval.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_attrsetm.tr_logres = xfs_calc_attrsetm_reservation(mp);
-	resp->tr_attrsetm.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-	resp->tr_attrsetm.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_attrset.tr_logres = xfs_calc_attrset_reservation(mp);
+	resp->tr_attrset.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+	resp->tr_attrset.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_attrrm.tr_logres = xfs_calc_attrrm_reservation(mp);
 	resp->tr_attrrm.tr_logcount = XFS_ATTRRM_LOG_COUNT;
@@ -940,7 +935,6 @@ xfs_trans_resv_calc(
 	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
 	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
 	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
-	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
 	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
 	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 7241ab28..f50996ae 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -35,10 +35,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_writeid;	/* write setuid/setgid file */
 	struct xfs_trans_res	tr_attrinval;	/* attr fork buffer
 						 * invalidation */
-	struct xfs_trans_res	tr_attrsetm;	/* set/create an attribute at
-						 * mount time */
-	struct xfs_trans_res	tr_attrsetrt;	/* set/create an attribute at
-						 * runtime */
+	struct xfs_trans_res	tr_attrset;	/* set/create an attribute */
 	struct xfs_trans_res	tr_attrrm;	/* remove an attribute */
 	struct xfs_trans_res	tr_clearagi;	/* clear agi unlinked bucket */
 	struct xfs_trans_res	tr_growrtalloc;	/* grow realtime allocations */
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 88221c7a..6a22ad11 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -38,8 +38,14 @@
 
 #define	XFS_DAENTER_1B(mp,w)	\
 	((w) == XFS_DATA_FORK ? (mp)->m_dir_geo->fsbcount : 1)
+/*
+ * xattr set operation can cause the da btree to split twice in the
+ * worst case. The double split is actually an extra leaf node rather
+ * than a complete split of blocks in the path from root to a
+ * leaf. The '1' in the macro below accounts for the extra leaf node.
+ */
 #define	XFS_DAENTER_DBS(mp,w)	\
-	(XFS_DA_NODE_MAXDEPTH + (((w) == XFS_DATA_FORK) ? 2 : 0))
+	(XFS_DA_NODE_MAXDEPTH + (((w) == XFS_DATA_FORK) ? 2 : 1))
 #define	XFS_DAENTER_BLOCKS(mp,w)	\
 	(XFS_DAENTER_1B(mp,w) * XFS_DAENTER_DBS(mp,w))
 #define	XFS_DAENTER_BMAP1B(mp,w)	\
-- 
2.19.1

