Return-Path: <SRS0=1MH2=27=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B431C33C99
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 04:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E079F20721
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jan 2020 04:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731245AbgAJE2L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 23:28:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52704 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731243AbgAJE2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jan 2020 23:28:11 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00A4R9Fg128877;
        Thu, 9 Jan 2020 23:28:07 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xea2k4r8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jan 2020 23:28:06 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 00A4R9aa128911;
        Thu, 9 Jan 2020 23:28:06 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xea2k4r8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jan 2020 23:28:06 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 00A4RR2P005649;
        Fri, 10 Jan 2020 04:28:05 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 2xajb7kkh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jan 2020 04:28:05 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00A4S2xj62390752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 04:28:02 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80B60BE051;
        Fri, 10 Jan 2020 04:28:02 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DE7FBE053;
        Fri, 10 Jan 2020 04:28:00 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.102.2.21])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 10 Jan 2020 04:27:59 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfsprogs: Fix log reservation calculation for xattr insert operation
Date:   Fri, 10 Jan 2020 10:00:27 +0530
Message-Id: <20200110043027.18661-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200110043027.18661-1-chandanrlinux@gmail.com>
References: <20200110043027.18661-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1034 priorityscore=1501
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100037
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Log space reservation for xattr insert operation can be divided into two
parts,
1. Mount time
   - Inode
   - Superblock for accounting space allocations
   - AGF for accounting space used be count, block number, rmapbt and refcnt
     btrees.

2. The remaining log space can only be calculated at run time because,
   - A local xattr can be large enough to cause a double split of the dabtree.
   - The value of the xattr can be large enough to be stored in remote
     blocks. The contents of the remote blocks are not logged.

   The log space reservation would be,
   - 2 * XFS_DA_NODE_MAXDEPTH number of blocks. Additional XFS_DA_NODE_MAXDEPTH
     number of blocks are required if xattr is large enough to cause another
     split of the dabtree path from root to leaf block.
   - BMBT blocks for storing (2 * XFS_DA_NODE_MAXDEPTH) record
     entries. Additional XFS_DA_NODE_MAXDEPTH number of blocks are required in
     case of a double split of the dabtree path from root to leaf blocks.
   - Space for logging blocks of count, block number, rmap and refcnt btrees.

This commit refactors xfs_attr_calc_size() to calculate the log reservation
space and also the FS reservation space. It then replaces the erroneous
calculation inside xfs_log_calc_max_attrsetm_res() with an invocation of
xfs_attr_calc_size().

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c       | 106 +++++++++++++++++++++++++---------------
 libxfs/xfs_attr.h       |   4 +-
 libxfs/xfs_log_rlimit.c |  13 ++---
 libxfs/xfs_trans_resv.c |  34 +++----------
 libxfs/xfs_trans_resv.h |   2 +
 5 files changed, 84 insertions(+), 75 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2a0050f4..36b3bde4 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -182,43 +182,6 @@ xfs_attr_get(
 	return 0;
 }
 
-/*
- * Calculate how many blocks we need for the new attribute,
- */
-STATIC int
-xfs_attr_calc_size(
-	struct xfs_da_args	*args,
-	int			*local)
-{
-	struct xfs_mount	*mp = args->dp->i_mount;
-	int			size;
-	int			nblks;
-
-	/*
-	 * Determine space new attribute will use, and if it would be
-	 * "local" or "remote" (note: local != inline).
-	 */
-	size = xfs_attr_leaf_newentsize(mp, args->namelen, args->valuelen,
-					local);
-	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
-	if (*local) {
-		if (size > (args->geo->blksize / 2)) {
-			/* Double split possible */
-			nblks *= 2;
-		}
-	} else {
-		/*
-		 * Out of line attribute, cannot double split, but
-		 * make room for the attribute value itself.
-		 */
-		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->valuelen);
-		nblks += dblocks;
-		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
-	}
-
-	return nblks;
-}
-
 STATIC int
 xfs_attr_try_sf_addname(
 	struct xfs_inode	*dp,
@@ -247,6 +210,68 @@ xfs_attr_try_sf_addname(
 	return error ? error : error2;
 }
 
+/*
+ * Calculate how many blocks we need for the new attribute,
+ */
+void
+xfs_attr_calc_size(
+	struct xfs_mount	*mp,
+	int			namelen,
+	int			valuelen,
+	int			*local,
+	unsigned int		*log_blks,
+	unsigned int		*total_blks)
+{
+	unsigned int	blksize;
+	int		dabtree_blks;
+	int		bmbt_blks;
+	int		size;
+	int		dblks;
+
+	blksize = mp->m_dir_geo->blksize;
+	dblks = 0;
+	*log_blks = 0;
+	*total_blks = 0;
+
+	/*
+	 * Determine space new attribute will use, and if it would be
+	 * "local" or "remote" (note: local != inline).
+	 */
+	size = xfs_attr_leaf_newentsize(mp, namelen, valuelen, local);
+	dabtree_blks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
+	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
+
+	*log_blks = xfs_calc_buf_res(2 * dabtree_blks, blksize);
+	*log_blks += xfs_calc_buf_res(2 * bmbt_blks, XFS_FSB_TO_B(mp, 1));
+
+	if (*local) {
+		if (size > (blksize / 2)) {
+			/* Double split possible */
+			*log_blks += xfs_calc_buf_res(dabtree_blks, blksize);
+			*log_blks += xfs_calc_buf_res(bmbt_blks,
+						XFS_FSB_TO_B(mp, 1));
+
+			dabtree_blks *= 2;
+			bmbt_blks *= 2;
+		}
+	} else {
+		/*
+		 * Out of line attribute, cannot double split, but
+		 * make room for the attribute value itself.
+		 */
+		dblks = xfs_attr3_rmt_blocks(mp, valuelen);
+		bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, dblks, XFS_ATTR_FORK);
+		*log_blks += xfs_calc_buf_res(bmbt_blks, XFS_FSB_TO_B(mp, 1));
+	}
+
+	*log_blks += xfs_calc_buf_res(xfs_allocfree_log_count(mp, dabtree_blks),
+				XFS_FSB_TO_B(mp, 1));
+	*log_blks += xfs_calc_buf_res(xfs_allocfree_log_count(mp, dblks),
+				XFS_FSB_TO_B(mp, 1));
+
+	*total_blks = dabtree_blks + bmbt_blks + dblks;
+}
+
 /*
  * Set the attribute specified in @args.
  */
@@ -346,6 +371,7 @@ xfs_attr_set(
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
+	unsigned int		log_blks;
 	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
@@ -360,7 +386,8 @@ xfs_attr_set(
 	args.value = value;
 	args.valuelen = valuelen;
 	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
-	args.total = xfs_attr_calc_size(&args, &local);
+	xfs_attr_calc_size(mp, args.namelen, args.valuelen, &local,
+			&log_blks, &args.total);
 
 	error = xfs_qm_dqattach(dp);
 	if (error)
@@ -379,8 +406,7 @@ xfs_attr_set(
 			return error;
 	}
 
-	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres + log_blks;
 	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 94badfa1..9c9b301d 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -154,5 +154,7 @@ int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
-
+void xfs_attr_calc_size(struct xfs_mount *mp, int namelen, int valuelen,
+			int *local, unsigned int *log_blks,
+			unsigned int *total_blks);
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index c8398b7d..2eebbece 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -10,6 +10,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_attr.h"
 #include "xfs_da_format.h"
 #include "xfs_trans_space.h"
 #include "xfs_da_btree.h"
@@ -24,16 +25,16 @@ xfs_log_calc_max_attrsetm_res(
 	struct xfs_mount	*mp)
 {
 	int			size;
-	int			nblks;
+	int			local;
+	unsigned int		total_blks;
+	unsigned int		log_blks;
 
 	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
 	       MAXNAMELEN - 1;
-	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
-	nblks += XFS_B_TO_FSB(mp, size);
-	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
+	xfs_attr_calc_size(mp, size, 0, &local, &log_blks, &total_blks);
+	ASSERT(local == 1);
 
-	return  M_RES(mp)->tr_attrsetm.tr_logres +
-		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
+	return M_RES(mp)->tr_attrsetm.tr_logres + log_blks;
 }
 
 /*
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 270e92a3..dfcc0157 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -28,7 +28,7 @@
  * to a multiple of 128 bytes so that we don't change the historical
  * reservation that has been used for this overhead.
  */
-STATIC uint
+uint
 xfs_buf_log_overhead(void)
 {
 	return round_up(sizeof(struct xlog_op_header) +
@@ -42,7 +42,7 @@ xfs_buf_log_overhead(void)
  * will be changed in a transaction.  size is used to tell how many
  * bytes should be reserved per item.
  */
-STATIC uint
+uint
 xfs_calc_buf_res(
 	uint		nbufs,
 	uint		size)
@@ -641,12 +641,10 @@ xfs_calc_attrinval_reservation(
  * Setting an attribute at mount time.
  *	the inode getting the attribute
  *	the superblock for allocations
- *	the agfs extents are allocated from
- *	the attribute btree * max depth
- *	the inode allocation btree
+ *	the agf extents are allocated from
  * Since attribute transaction space is dependent on the size of the attribute,
  * the calculation is done partially at mount time and partially at runtime(see
- * below).
+ * xfs_attr_calc_size()).
  */
 STATIC uint
 xfs_calc_attrsetm_reservation(
@@ -654,27 +652,7 @@ xfs_calc_attrsetm_reservation(
 {
 	return XFS_DQUOT_LOGRES(mp) +
 		xfs_calc_inode_res(mp, 1) +
-		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
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
-				 XFS_FSB_TO_B(mp, 1));
+		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
 }
 
 /*
@@ -882,7 +860,7 @@ xfs_trans_resv_calc(
 	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
 	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
 	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
-	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
+	resp->tr_attrsetrt.tr_logres = 0;
 	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
 	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 7241ab28..9a7af411 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -91,6 +91,8 @@ struct xfs_trans_resv {
 #define	XFS_ATTRSET_LOG_COUNT		3
 #define	XFS_ATTRRM_LOG_COUNT		3
 
+uint xfs_buf_log_overhead(void);
+uint xfs_calc_buf_res(uint nbufs, uint size);
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
 uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
 
-- 
2.19.1

