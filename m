Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F546C33CB3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 12:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65CEF206D7
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 12:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgAOMwV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 07:52:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726088AbgAOMwU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 07:52:20 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00FCqFwB028501;
        Wed, 15 Jan 2020 07:52:18 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xhy3urcv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jan 2020 07:52:17 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 00FCqG2e028642;
        Wed, 15 Jan 2020 07:52:16 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xhy3urcnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jan 2020 07:52:16 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 00FCoLcW019456;
        Wed, 15 Jan 2020 12:52:00 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 2xf74pe5fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jan 2020 12:52:00 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00FCpxZC11010512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 12:51:59 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BECC6AE05F;
        Wed, 15 Jan 2020 12:51:59 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E771AE05C;
        Wed, 15 Jan 2020 12:51:57 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.70.7])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 Jan 2020 12:51:57 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH V2 1/2] xfs: Pass xattr name and value length explicitly to xfs_attr_leaf_newentsize
Date:   Wed, 15 Jan 2020 18:24:20 +0530
Message-Id: <20200115125421.22719-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_02:2020-01-15,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1034
 malwarescore=0 adultscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001150104
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit changes xfs_attr_leaf_newentsize() to explicitly accept name and
value length instead of a pointer to struct xfs_da_args. The next commit will
need to invoke xfs_attr_leaf_newentsize() from functions that do not have
a struct xfs_da_args to pass in.

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
Changelog:
V1 -> V2:
1. Use convenience variables to reduce indentation of code.

 fs/xfs/libxfs/xfs_attr.c      |  3 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c | 41 ++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
 3 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0d7fcc983b3d..1eae1db74f6c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -199,7 +199,8 @@ xfs_attr_calc_size(
 	 * Determine space new attribute will use, and if it would be
 	 * "local" or "remote" (note: local != inline).
 	 */
-	size = xfs_attr_leaf_newentsize(args, local);
+	size = xfs_attr_leaf_newentsize(mp, args->namelen, args->valuelen,
+					local);
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	if (*local) {
 		if (size > (args->geo->blksize / 2)) {
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 08d4b10ae2d5..7cd57e5844d8 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1338,7 +1338,8 @@ xfs_attr3_leaf_add(
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	ASSERT(args->index >= 0 && args->index <= ichdr.count);
-	entsize = xfs_attr_leaf_newentsize(args, NULL);
+	entsize = xfs_attr_leaf_newentsize(args->dp->i_mount, args->namelen,
+					args->valuelen, NULL);
 
 	/*
 	 * Search through freemap for first-fit on new name length.
@@ -1411,6 +1412,7 @@ xfs_attr3_leaf_add_work(
 	struct xfs_attr_leaf_name_local *name_loc;
 	struct xfs_attr_leaf_name_remote *name_rmt;
 	struct xfs_mount	*mp;
+	int			entsize;
 	int			tmp;
 	int			i;
 
@@ -1440,11 +1442,14 @@ xfs_attr3_leaf_add_work(
 	ASSERT(ichdr->freemap[mapindex].base < args->geo->blksize);
 	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
 	ASSERT(ichdr->freemap[mapindex].size >=
-		xfs_attr_leaf_newentsize(args, NULL));
+		xfs_attr_leaf_newentsize(mp, args->namelen,
+					args->valuelen, NULL));
 	ASSERT(ichdr->freemap[mapindex].size < args->geo->blksize);
 	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
 
-	ichdr->freemap[mapindex].size -= xfs_attr_leaf_newentsize(args, &tmp);
+	entsize = xfs_attr_leaf_newentsize(mp, args->namelen, args->valuelen,
+					&tmp);
+	ichdr->freemap[mapindex].size -= entsize;
 
 	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
 				     ichdr->freemap[mapindex].size);
@@ -1831,6 +1836,8 @@ xfs_attr3_leaf_figure_balance(
 	struct xfs_attr_leafblock	*leaf1 = blk1->bp->b_addr;
 	struct xfs_attr_leafblock	*leaf2 = blk2->bp->b_addr;
 	struct xfs_attr_leaf_entry	*entry;
+	struct xfs_da_args		*args;
+	int				entsize;
 	int				count;
 	int				max;
 	int				index;
@@ -1840,14 +1847,16 @@ xfs_attr3_leaf_figure_balance(
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
+	entsize = xfs_attr_leaf_newentsize(state->mp, args->namelen,
+					args->valuelen, NULL);
+	half += ichdr1->usedbytes + ichdr2->usedbytes + entsize;
 	half /= 2;
 	lastdelta = state->args->geo->blksize;
 	entry = xfs_attr3_leaf_entryp(leaf1);
@@ -1858,8 +1867,11 @@ xfs_attr3_leaf_figure_balance(
 		 * The new entry is in the first block, account for it.
 		 */
 		if (count == blk1->index) {
-			tmp = totallen + sizeof(*entry) +
-				xfs_attr_leaf_newentsize(state->args, NULL);
+			entsize = xfs_attr_leaf_newentsize(state->mp,
+							args->namelen,
+							args->valuelen,
+							NULL);
+			tmp = totallen + sizeof(*entry) + entsize;
 			if (XFS_ATTR_ABS(half - tmp) > lastdelta)
 				break;
 			lastdelta = XFS_ATTR_ABS(half - tmp);
@@ -1894,8 +1906,9 @@ xfs_attr3_leaf_figure_balance(
 	 */
 	totallen -= count * sizeof(*entry);
 	if (foundit) {
-		totallen -= sizeof(*entry) +
-				xfs_attr_leaf_newentsize(state->args, NULL);
+		entsize = xfs_attr_leaf_newentsize(state->mp, args->namelen,
+						args->valuelen, NULL);
+		totallen -= sizeof(*entry) + entsize;
 	}
 
 	*countarg = count;
@@ -2687,20 +2700,22 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
  */
 int
 xfs_attr_leaf_newentsize(
-	struct xfs_da_args	*args,
+	struct xfs_mount	*mp,
+	int			namelen,
+	int			valuelen,
 	int			*local)
 {
 	int			size;
 
-	size = xfs_attr_leaf_entsize_local(args->namelen, args->valuelen);
-	if (size < xfs_attr_leaf_entsize_local_max(args->geo->blksize)) {
+	size = xfs_attr_leaf_entsize_local(namelen, valuelen);
+	if (size < xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize)) {
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
index f4a188e28b7b..0ce1f9301157 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -106,7 +106,8 @@ void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
 xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_buf *bp, int *count);
 int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
 				   struct xfs_buf *leaf2_bp);
-int	xfs_attr_leaf_newentsize(struct xfs_da_args *args, int *local);
+int	xfs_attr_leaf_newentsize(struct xfs_mount *mp, int namelen,
+			int valuelen, int *local);
 int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			xfs_dablk_t bno, struct xfs_buf **bpp);
 void	xfs_attr3_leaf_hdr_from_disk(struct xfs_da_geometry *geo,
-- 
2.19.1

