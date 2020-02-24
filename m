Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D85C35641
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B68AF20675
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 03:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgBXD6P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 22:58:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12520 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727168AbgBXD6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 22:58:15 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01O3wC6t092613;
        Sun, 23 Feb 2020 22:58:12 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb008stwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:11 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01O3wBLn092572;
        Sun, 23 Feb 2020 22:58:11 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb008stv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:58:11 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01O3tL2I000347;
        Mon, 24 Feb 2020 03:58:04 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 2yaux6cbuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 03:58:03 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01O3w26E55574954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 03:58:02 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8487C6A054;
        Mon, 24 Feb 2020 03:58:02 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A07D56A047;
        Mon, 24 Feb 2020 03:57:59 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.91.136])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 03:57:59 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com,
        amir73il@gmail.com
Subject: [PATCH V4 RESEND 1/7] xfs: Pass xattr name and value length explicitly to xfs_attr_leaf_newentsize
Date:   Mon, 24 Feb 2020 09:30:38 +0530
Message-Id: <20200224040044.30923-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200224040044.30923-1-chandanrlinux@gmail.com>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-23_07:2020-02-21,2020-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1034 impostorscore=0
 suspectscore=1 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit changes xfs_attr_leaf_newentsize() to explicitly accept name and
value length instead of a pointer to struct xfs_da_args. A future commit will
need to invoke xfs_attr_leaf_newentsize() from functions that do not have
a struct xfs_da_args to pass in.

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c      |  3 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c | 39 +++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 23e0d8ce39f8c..1875210cc8e40 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -149,7 +149,8 @@ xfs_attr_calc_size(
 	 * Determine space new attribute will use, and if it would be
 	 * "local" or "remote" (note: local != inline).
 	 */
-	size = xfs_attr_leaf_newentsize(args, local);
+	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
+			args->valuelen, local);
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	if (*local) {
 		if (size > (args->geo->blksize / 2)) {
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index fae322105457a..65a3bf40c4f9d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1330,7 +1330,8 @@ xfs_attr3_leaf_add(
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	ASSERT(args->index >= 0 && args->index <= ichdr.count);
-	entsize = xfs_attr_leaf_newentsize(args, NULL);
+	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
+			args->valuelen, NULL);
 
 	/*
 	 * Search through freemap for first-fit on new name length.
@@ -1403,6 +1404,7 @@ xfs_attr3_leaf_add_work(
 	struct xfs_attr_leaf_name_local *name_loc;
 	struct xfs_attr_leaf_name_remote *name_rmt;
 	struct xfs_mount	*mp;
+	int			entsize;
 	int			tmp;
 	int			i;
 
@@ -1432,11 +1434,14 @@ xfs_attr3_leaf_add_work(
 	ASSERT(ichdr->freemap[mapindex].base < args->geo->blksize);
 	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
 	ASSERT(ichdr->freemap[mapindex].size >=
-		xfs_attr_leaf_newentsize(args, NULL));
+		xfs_attr_leaf_newentsize(args->geo, args->namelen,
+				args->valuelen, NULL));
 	ASSERT(ichdr->freemap[mapindex].size < args->geo->blksize);
 	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
 
-	ichdr->freemap[mapindex].size -= xfs_attr_leaf_newentsize(args, &tmp);
+	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
+			args->valuelen, &tmp);
+	ichdr->freemap[mapindex].size -= entsize;
 
 	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
 				     ichdr->freemap[mapindex].size);
@@ -1824,6 +1829,8 @@ xfs_attr3_leaf_figure_balance(
 	struct xfs_attr_leafblock	*leaf1 = blk1->bp->b_addr;
 	struct xfs_attr_leafblock	*leaf2 = blk2->bp->b_addr;
 	struct xfs_attr_leaf_entry	*entry;
+	struct xfs_da_args		*args;
+	int				entsize;
 	int				count;
 	int				max;
 	int				index;
@@ -1833,14 +1840,16 @@ xfs_attr3_leaf_figure_balance(
 	int				foundit = 0;
 	int				tmp;
 
+	args = state->args;
 	/*
 	 * Examine entries until we reduce the absolute difference in
 	 * byte usage between the two blocks to a minimum.
 	 */
 	max = ichdr1->count + ichdr2->count;
 	half = (max + 1) * sizeof(*entry);
-	half += ichdr1->usedbytes + ichdr2->usedbytes +
-			xfs_attr_leaf_newentsize(state->args, NULL);
+	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
+			args->valuelen, NULL);
+	half += ichdr1->usedbytes + ichdr2->usedbytes + entsize;
 	half /= 2;
 	lastdelta = state->args->geo->blksize;
 	entry = xfs_attr3_leaf_entryp(leaf1);
@@ -1851,8 +1860,9 @@ xfs_attr3_leaf_figure_balance(
 		 * The new entry is in the first block, account for it.
 		 */
 		if (count == blk1->index) {
-			tmp = totallen + sizeof(*entry) +
-				xfs_attr_leaf_newentsize(state->args, NULL);
+			entsize = xfs_attr_leaf_newentsize(args->geo,
+					args->namelen, args->valuelen, NULL);
+			tmp = totallen + sizeof(*entry) + entsize;
 			if (XFS_ATTR_ABS(half - tmp) > lastdelta)
 				break;
 			lastdelta = XFS_ATTR_ABS(half - tmp);
@@ -1887,8 +1897,9 @@ xfs_attr3_leaf_figure_balance(
 	 */
 	totallen -= count * sizeof(*entry);
 	if (foundit) {
-		totallen -= sizeof(*entry) +
-				xfs_attr_leaf_newentsize(state->args, NULL);
+		entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
+				args->valuelen, NULL);
+		totallen -= sizeof(*entry) + entsize;
 	}
 
 	*countarg = count;
@@ -2664,20 +2675,22 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
  */
 int
 xfs_attr_leaf_newentsize(
-	struct xfs_da_args	*args,
+	struct xfs_da_geometry	*geo,
+	int			namelen,
+	int			valuelen,
 	int			*local)
 {
 	int			size;
 
-	size = xfs_attr_leaf_entsize_local(args->namelen, args->valuelen);
-	if (size < xfs_attr_leaf_entsize_local_max(args->geo->blksize)) {
+	size = xfs_attr_leaf_entsize_local(namelen, valuelen);
+	if (size < xfs_attr_leaf_entsize_local_max(geo->blksize)) {
 		if (local)
 			*local = 1;
 		return size;
 	}
 	if (local)
 		*local = 0;
-	return xfs_attr_leaf_entsize_remote(args->namelen);
+	return xfs_attr_leaf_entsize_remote(namelen);
 }
 
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 6dd2d937a42a3..7bc5dd6c4d66a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -96,7 +96,8 @@ void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
 xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_buf *bp, int *count);
 int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
 				   struct xfs_buf *leaf2_bp);
-int	xfs_attr_leaf_newentsize(struct xfs_da_args *args, int *local);
+int	xfs_attr_leaf_newentsize(struct xfs_da_geometry	*geo, int namelen,
+			int valuelen, int *local);
 int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			xfs_dablk_t bno, struct xfs_buf **bpp);
 void	xfs_attr3_leaf_hdr_from_disk(struct xfs_da_geometry *geo,
-- 
2.19.1

