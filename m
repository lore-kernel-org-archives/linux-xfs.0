Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B948EC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77210206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fcjwDiXI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgAABRn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:17:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56420 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:17:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FwC1093151
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=YVVh800ixx2eMrEwRr1bEvpAD9xcWXj8GvBmn/YlKFA=;
 b=fcjwDiXIv6/pn+hT6NaR8Qzmm4ziClAjVqG9FPTfWEiLA/ZKhYuIiJvp35qToac56C64
 iArDFF0l8vcRGoMUbX1IuUgr6WC6EZk+VBDaNcotlk03MTIsN2oae/VqBt+g/rJh2bQi
 WEqcqUdONtW2r6KcvY3Fsd+cb0+60yFNgiG20ZZEZo8uLCAG52tnIf6VSQPO7txd1l2d
 qF2yXBYWksub64liFFD2ABELpg7WBVmIHmhG7XrkZE9+S28vAafZHZokgh/XdAoLLz5O
 8TGWwfalH3Ud6bmKltYP9plp2yT+5eQL7M2FDT4g5UFV6fM4GGfdZHl7/2+sKtvXJXpY LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118v3O190248
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x8bsrg5bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:38 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011HcWK014481
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:38 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:17:37 -0800
Subject: [PATCH 12/21] xfs: wire up a new inode fork type for the realtime
 rmap
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:17:35 -0800
Message-ID: <157784145531.1368137.16769908469062996020.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb in the pieces we need to embed the root of the realtime rmap
btree in an inode's data fork, complete with new fork type and
on-disk interpretation functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h       |    8 +
 fs/xfs/libxfs/xfs_inode_fork.c   |   47 +++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c |  244 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |   51 ++++++++
 4 files changed, 348 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 6a42c886ecd3..2e386ed7e61d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1622,6 +1622,14 @@ typedef __be32 xfs_rmap_ptr_t;
  */
 #define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
 
+/*
+ * rtrmap root header, on-disk form only.
+ */
+struct xfs_rtrmap_root {
+	__be16		bb_level;	/* 0 is a leaf */
+	__be16		bb_numrecs;	/* current # of data records */
+};
+
 /*
  * Data record structure
  */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 4c99c532693c..758bf44693ba 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -24,12 +24,14 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_health.h"
+#include "xfs_rtrmap_btree.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
 STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
 STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
 STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
+STATIC int xfs_iformat_rmap(struct xfs_inode *ip, struct xfs_dinode *dip);
 
 /*
  * Copy inode type and data and attr format specific information from the
@@ -78,7 +80,7 @@ xfs_iformat_fork(
 		case XFS_DINODE_FMT_RMAP:
 			if (!xfs_sb_version_hasrtrmapbt(&ip->i_mount->m_sb))
 				return -EFSCORRUPTED;
-			/* to be implemented later */
+			error = xfs_iformat_rmap(ip, dip);
 			break;
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
@@ -338,6 +340,37 @@ xfs_iformat_btree(
 	return 0;
 }
 
+/* The file is a reverse mapping tree. */
+STATIC int
+xfs_iformat_rmap(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_rtrmap_root	*dfp;
+	struct xfs_ifork	*ifp;
+	/* REFERENCED */
+	int			size;
+	int			whichfork = XFS_DATA_FORK;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	dfp = (struct xfs_rtrmap_root *)XFS_DFORK_PTR(dip, whichfork);
+	size = XFS_RTRMAP_BROOT_SPACE(dfp);
+
+	ifp->if_broot_bytes = size;
+	ifp->if_broot = kmem_alloc(size, KM_NOFS);
+	ASSERT(ifp->if_broot != NULL);
+	/*
+	 * Copy and convert from the on-disk structure
+	 * to the in-memory structure.
+	 */
+	xfs_rtrmapbt_from_disk(ip, dfp,
+			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
+			ifp->if_broot, size);
+	ifp->if_flags = XFS_IFBROOT;
+
+	return 0;
+}
+
 /*
  * This is called when the amount of space needed for if_data
  * is increased or decreased.  The change in size is indicated by
@@ -552,7 +585,17 @@ xfs_iflush_fork(
 		break;
 
 	case XFS_DINODE_FMT_RMAP:
-		/* to be implemented later */
+		ASSERT(whichfork == XFS_DATA_FORK);
+		if ((iip->ili_fields & brootflag[whichfork]) &&
+		    (ifp->if_broot_bytes > 0)) {
+			ASSERT(ifp->if_broot != NULL);
+			ASSERT(XFS_RTRMAP_ROOT_SPACE(ifp->if_broot) <=
+				XFS_IFORK_SIZE(ip, whichfork));
+			xfs_rtrmapbt_to_disk(mp, ifp->if_broot,
+				ifp->if_broot_bytes,
+				(struct xfs_rtrmap_root *)cp,
+				XFS_DFORK_SIZE(dip, mp, whichfork));
+		}
 		break;
 
 	default:
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 992ebd9ed4d0..647ae157fc98 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -194,6 +194,42 @@ xfs_rtrmapbt_get_maxrecs(
 	return cur->bc_mp->m_rtrmap_mxr[level != 0];
 }
 
+/*
+ * Calculate number of records in a realtime rmap btree inode root.
+ */
+STATIC int
+xfs_rtrmapbt_root_maxrecs(
+	int			blocklen,
+	bool			leaf)
+{
+	blocklen -= sizeof(struct xfs_rtrmap_root);
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rtrmap_rec);
+	return blocklen / (2 * sizeof(struct xfs_rtrmap_key) +
+			sizeof(xfs_rtrmap_ptr_t));
+}
+
+/*
+ * Get the maximum records we could store in the on-disk format.
+ *
+ * For non-root nodes this is equivalent to xfs_bmbt_get_maxrecs, but
+ * for the root node this checks the available space in the dinode fork
+ * so that we can resize the in-memory buffer to match it.  After a
+ * resize to the maximum size this function returns the same value
+ * as xfs_bmbt_get_maxrecs for the root node, too.
+ */
+STATIC int
+xfs_rtrmapbt_get_dmaxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	if (level != cur->bc_nlevels - 1)
+		return cur->bc_mp->m_rtrmap_mxr[level != 0];
+	return xfs_rtrmapbt_root_maxrecs(cur->bc_private.b.forksize,
+			level == 0);
+}
+
 STATIC void
 xfs_rtrmapbt_init_key_from_rec(
 	union xfs_btree_key	*key,
@@ -311,6 +347,123 @@ xfs_rtrmapbt_diff_two_keys(
 	return 0;
 }
 
+/*
+ * Reallocate the space for if_broot based on the number of records
+ * being added or deleted as indicated in rec_diff.  Move the records
+ * and pointers in if_broot to fit the new size.  When shrinking this
+ * will eliminate holes between the records and pointers created by
+ * the caller.  When growing this will create holes to be filled in
+ * by the caller.
+ *
+ * The caller must not request to add more records than would fit in
+ * the on-disk inode root.  If the if_broot is currently NULL, then
+ * if we are adding records, one will be allocated.  The caller must also
+ * not request that the number of records go below zero, although
+ * it can go to zero.
+ */
+STATIC void
+xfs_rtrmapbt_iroot_realloc(
+	struct xfs_btree_cur	*cur,
+	int			rec_diff)
+{
+	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	int			whichfork = cur->bc_private.b.whichfork;
+	int			cur_max;
+	struct xfs_ifork	*ifp;
+	struct xfs_btree_block	*new_broot;
+	struct xfs_btree_block	*broot;
+	int			new_max;
+	size_t			new_size;
+	char			*np;
+	char			*op;
+	int			level;
+
+	/*
+	 * Handle the degenerate case quietly.
+	 */
+	if (rec_diff == 0)
+		return;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (rec_diff > 0) {
+		/*
+		 * If there wasn't any memory allocated before, just
+		 * allocate it now and get out.
+		 */
+		if (ifp->if_broot_bytes == 0) {
+			new_size = XFS_RTRMAP_BROOT_SPACE_CALC(rec_diff,
+					cur->bc_nlevels - 1);
+			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
+			ifp->if_broot_bytes = (int)new_size;
+			return;
+		}
+
+		/*
+		 * If there is already an existing if_broot, then we need
+		 * to realloc() it and shift the pointers to their new
+		 * location.  The records don't change location because
+		 * they are kept butted up against the btree block header.
+		 */
+		broot = (struct xfs_btree_block *)ifp->if_broot;
+		level = be16_to_cpu(broot->bb_level);
+		cur_max = xfs_rtrmapbt_maxrecs(ifp->if_broot_bytes, level == 0);
+		new_max = cur_max + rec_diff;
+		new_size = XFS_RTRMAP_BROOT_SPACE_CALC(new_max, level);
+		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size, KM_NOFS);
+		if (level > 0) {
+			op = (char *)XFS_RTRMAP_BROOT_PTR_ADDR(ifp->if_broot,
+					1, ifp->if_broot_bytes);
+			np = (char *)XFS_RTRMAP_BROOT_PTR_ADDR(ifp->if_broot,
+					1, (int)new_size);
+			memmove(np, op, cur_max * sizeof(xfs_fsblock_t));
+		}
+		ifp->if_broot_bytes = (int)new_size;
+		ASSERT(XFS_RTRMAP_ROOT_SPACE(ifp->if_broot) <=
+				XFS_IFORK_SIZE(ip, whichfork));
+		return;
+	}
+
+	/*
+	 * rec_diff is less than 0.  In this case, we are shrinking the
+	 * if_broot buffer.  It must already exist.  If we go to zero
+	 * records, just get rid of the root and clear the status bit.
+	 */
+	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
+	broot = (struct xfs_btree_block *)ifp->if_broot;
+	level = be16_to_cpu(broot->bb_level);
+	cur_max = xfs_rtrmapbt_maxrecs(ifp->if_broot_bytes, level == 0);
+	new_max = cur_max + rec_diff;
+	if (new_max < 0)
+		new_max = 0;
+	new_size = XFS_RTRMAP_BROOT_SPACE_CALC(new_max, level);
+	new_broot = kmem_alloc(new_size, KM_NOFS);
+	memcpy(new_broot, ifp->if_broot, XFS_RTRMAP_BLOCK_LEN);
+
+	/* Copy the records or keys and pointers. */
+	if (level > 0) {
+		op = (char *)XFS_RTRMAP_KEY_ADDR(ifp->if_broot, 1);
+		np = (char *)XFS_RTRMAP_KEY_ADDR(new_broot, 1);
+		memcpy(np, op, new_max * 2 * sizeof(struct xfs_rtrmap_key));
+
+		op = (char *)XFS_RTRMAP_BROOT_PTR_ADDR(ifp->if_broot, 1,
+				ifp->if_broot_bytes);
+		np = (char *)XFS_RTRMAP_BROOT_PTR_ADDR(new_broot, 1,
+				(int)new_size);
+		memcpy(np, op, new_max * sizeof(xfs_fsblock_t));
+	} else {
+		op = (char *)XFS_RTRMAP_REC_ADDR(ifp->if_broot, 1);
+		np = (char *)XFS_RTRMAP_REC_ADDR(new_broot, 1);
+		memcpy(np, op, new_max * sizeof(struct xfs_rtrmap_rec));
+	}
+
+	kmem_free(ifp->if_broot);
+	ifp->if_broot = new_broot;
+	ifp->if_broot_bytes = (int)new_size;
+	if (ifp->if_broot)
+		ASSERT(XFS_RTRMAP_ROOT_SPACE(ifp->if_broot) <=
+				XFS_IFORK_SIZE(ip, whichfork));
+}
+
 static xfs_failaddr_t
 xfs_rtrmapbt_verify(
 	struct xfs_buf		*bp)
@@ -424,12 +577,14 @@ static const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.free_block		= xfs_rtrmapbt_free_block,
 	.get_minrecs		= xfs_rtrmapbt_get_minrecs,
 	.get_maxrecs		= xfs_rtrmapbt_get_maxrecs,
+	.get_dmaxrecs		= xfs_rtrmapbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_rtrmapbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_rtrmapbt_init_ptr_from_cur,
 	.key_diff		= xfs_rtrmapbt_key_diff,
 	.buf_ops		= &xfs_rtrmapbt_buf_ops,
+	.iroot_realloc		= xfs_rtrmapbt_iroot_realloc,
 	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
 	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
 	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
@@ -547,3 +702,92 @@ xfs_rtrmapbt_compute_maxlevels(
 			mp->m_sb.sb_rblocks);
 	ASSERT(mp->m_rtrmap_maxlevels <= XFS_BTREE_MAXLEVELS);
 }
+
+/*
+ * Convert on-disk form of btree root to in-memory form.
+ */
+void
+xfs_rtrmapbt_from_disk(
+	struct xfs_inode	*ip,
+	struct xfs_rtrmap_root	*dblock,
+	int			dblocklen,
+	struct xfs_btree_block	*rblock,
+	int			rblocklen)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	int			dmxr;
+	struct xfs_rtrmap_key	*fkp;
+	__be64			*fpp;
+	struct xfs_rtrmap_key	*tkp;
+	__be64			*tpp;
+	struct xfs_rtrmap_rec	*frp;
+	struct xfs_rtrmap_rec	*trp;
+
+	xfs_btree_init_block_int(mp, rblock, XFS_BUF_DADDR_NULL,
+			 XFS_BTNUM_RTRMAP, 0, 0, ip->i_ino,
+			 XFS_BTREE_LONG_PTRS | XFS_BTREE_CRC_BLOCKS);
+
+	rblock->bb_level = dblock->bb_level;
+	rblock->bb_numrecs = dblock->bb_numrecs;
+
+	if (be16_to_cpu(rblock->bb_level) > 0) {
+		dmxr = xfs_rtrmapbt_maxrecs(dblocklen, 0);
+		fkp = XFS_RTRMAP_ROOT_KEY_ADDR(dblock, 1);
+		tkp = XFS_RTRMAP_KEY_ADDR(rblock, 1);
+		fpp = XFS_RTRMAP_ROOT_PTR_ADDR(dblock, 1, dmxr);
+		tpp = XFS_RTRMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
+		dmxr = be16_to_cpu(dblock->bb_numrecs);
+		memcpy(tkp, fkp, 2 * sizeof(*fkp) * dmxr);
+		memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
+	} else {
+		frp = XFS_RTRMAP_ROOT_REC_ADDR(dblock, 1);
+		trp = XFS_RTRMAP_REC_ADDR(rblock, 1);
+		dmxr = be16_to_cpu(dblock->bb_numrecs);
+		memcpy(trp, frp, sizeof(*frp) * dmxr);
+	}
+}
+
+/*
+ * Convert in-memory form of btree root to on-disk form.
+ */
+void
+xfs_rtrmapbt_to_disk(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*rblock,
+	int			rblocklen,
+	struct xfs_rtrmap_root	*dblock,
+	int			dblocklen)
+{
+	int			dmxr;
+	struct xfs_rtrmap_key	*fkp;
+	__be64			*fpp;
+	struct xfs_rtrmap_key	*tkp;
+	__be64			*tpp;
+	struct xfs_rtrmap_rec	*frp;
+	struct xfs_rtrmap_rec	*trp;
+
+	ASSERT(rblock->bb_magic == cpu_to_be32(XFS_RTRMAP_CRC_MAGIC));
+	ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid));
+	ASSERT(rblock->bb_u.l.bb_blkno == cpu_to_be64(XFS_BUF_DADDR_NULL));
+	ASSERT(rblock->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK));
+	ASSERT(rblock->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK));
+
+	dblock->bb_level = rblock->bb_level;
+	dblock->bb_numrecs = rblock->bb_numrecs;
+
+	if (be16_to_cpu(rblock->bb_level) > 0) {
+		dmxr = xfs_rtrmapbt_maxrecs(dblocklen, 0);
+		fkp = XFS_RTRMAP_KEY_ADDR(rblock, 1);
+		tkp = XFS_RTRMAP_ROOT_KEY_ADDR(dblock, 1);
+		fpp = XFS_RTRMAP_BROOT_PTR_ADDR(rblock, 1, rblocklen);
+		tpp = XFS_RTRMAP_ROOT_PTR_ADDR(dblock, 1, dmxr);
+		dmxr = be16_to_cpu(rblock->bb_numrecs);
+		memcpy(tkp, fkp, 2 * sizeof(*fkp) * dmxr);
+		memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
+	} else {
+		frp = XFS_RTRMAP_REC_ADDR(rblock, 1);
+		trp = XFS_RTRMAP_ROOT_REC_ADDR(dblock, 1);
+		dmxr = be16_to_cpu(rblock->bb_numrecs);
+		memcpy(trp, frp, sizeof(*frp) * dmxr);
+	}
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 9d1c80ee6bb8..857b576d5b08 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -41,6 +41,50 @@ struct xbtree_ifakeroot;
 		 (maxrecs) * 2 * sizeof(struct xfs_rtrmap_key) + \
 		 ((index) - 1) * sizeof(xfs_rtrmap_ptr_t)))
 
+/* Macros for handling the inode root */
+
+#define XFS_RTRMAP_ROOT_REC_ADDR(block, index) \
+	((struct xfs_rtrmap_rec *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_rtrmap_root) + \
+		 ((index) - 1) * sizeof(struct xfs_rtrmap_rec)))
+
+#define XFS_RTRMAP_ROOT_KEY_ADDR(block, index) \
+	((struct xfs_rtrmap_key *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_rtrmap_root) + \
+		 ((index) - 1) * 2 * sizeof(struct xfs_rtrmap_key)))
+
+#define XFS_RTRMAP_ROOT_PTR_ADDR(block, index, maxrecs) \
+	((xfs_rtrmap_ptr_t *) \
+		((char *)(block) + \
+		 sizeof(struct xfs_rtrmap_root) + \
+		 (maxrecs) * 2 * sizeof(struct xfs_rtrmap_key) + \
+		 ((index) - 1) * sizeof(xfs_rtrmap_ptr_t)))
+
+#define XFS_RTRMAP_BROOT_PTR_ADDR(bb, i, sz) \
+	XFS_RTRMAP_PTR_ADDR(bb, i, xfs_rtrmapbt_maxrecs(sz, 0))
+
+#define XFS_RTRMAP_BROOT_SPACE_CALC(nrecs, level) \
+	(int)(XFS_RTRMAP_BLOCK_LEN + ((level) > 0 ? \
+	       ((nrecs) * (2 * sizeof(struct xfs_rtrmap_key) + \
+			   sizeof(xfs_rtrmap_ptr_t))) : \
+	       ((nrecs) * sizeof(struct xfs_rtrmap_rec))))
+
+#define XFS_RTRMAP_BROOT_SPACE(bb) \
+	(XFS_RTRMAP_BROOT_SPACE_CALC(be16_to_cpu((bb)->bb_numrecs), \
+				     be16_to_cpu((bb)->bb_level)))
+
+#define XFS_RTRMAP_ROOT_SPACE_CALC(nrecs, level) \
+	(int)(sizeof(struct xfs_rtrmap_root) + ((level) > 0 ? \
+	       ((nrecs) * (2 * sizeof(struct xfs_rtrmap_key) + \
+			   sizeof(xfs_rtrmap_ptr_t))) : \
+	       ((nrecs) * sizeof(struct xfs_rtrmap_rec))))
+
+#define XFS_RTRMAP_ROOT_SPACE(bb) \
+	(XFS_RTRMAP_ROOT_SPACE_CALC(be16_to_cpu((bb)->bb_numrecs), \
+				    be16_to_cpu((bb)->bb_level)))
+
 struct xfs_btree_cur *xfs_rtrmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_trans *tp, struct xfs_inode *ip);
 struct xfs_btree_cur *xfs_rtrmapbt_stage_cursor(struct xfs_mount *mp,
@@ -50,4 +94,11 @@ void xfs_rtrmapbt_commit_staged_btree(struct xfs_btree_cur *cur);
 int xfs_rtrmapbt_maxrecs(int blocklen, bool leaf);
 void xfs_rtrmapbt_compute_maxlevels(struct xfs_mount *mp);
 
+void xfs_rtrmapbt_from_disk(struct xfs_inode *ip,
+		struct xfs_rtrmap_root *dblock, int dblocklen,
+		struct xfs_btree_block *rblock, int rblocklen);
+void xfs_rtrmapbt_to_disk(struct xfs_mount *mp,
+		struct xfs_btree_block *rblock, int rblocklen,
+		struct xfs_rtrmap_root *dblock, int dblocklen);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */

