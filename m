Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D18CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 509FF21D71
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:15:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TJNdVAa4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392719AbfJYFPd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:15:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45992 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbfJYFPc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 01:15:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5DkuW123733
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=29Emh+6IE9zmBtHbYpXVNvNVyqQ4YhzjXpXVoGROuCo=;
 b=TJNdVAa48mSLSBCA4IgyC5P4uRA5RRs+H/S/HrrDS4X+/SBEiZ+YXG87/Dl5OvBv+Yza
 Ql9RQq0uT0SUNW9jdWfBX3Ujnvr0LW1LcEMSgv+q3Oe9ut1bIxih0qlW7jZiBcoz+QnQ
 tlqmYT0uWRumV6J4iIdEiCoLwpyViZQhfLpsiRu1X66zV+YzBJhv7TAc2tWQ4dlGLPqi
 pcdOORSxugxRCr10KakxypHY4DyDC1RgVB/mNyUjiOeQKx0ZM10qs1qsDXT5/S3Co4Vk
 qulpfOa2FFRimMdgDdKhyTyZPTIhgBCIFQIwXAfh5lvNerXo37zWg236SiYCiXK50vNh 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vqswu08pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5Dm1G073603
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vu0fqsckc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9P5FSrR019204
        for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2019 05:15:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 05:15:28 +0000
Subject: [PATCH 2/2] xfs: refactor xfs_iread_extents to use
 xfs_btree_visit_blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 24 Oct 2019 22:15:27 -0700
Message-ID: <157198052776.2873576.12691586684307027826.stgit@magnolia>
In-Reply-To: <157198051549.2873576.10430329078588571923.stgit@magnolia>
References: <157198051549.2873576.10430329078588571923.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250050
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_iread_extents open-codes everything in xfs_btree_visit_blocks, so
refactor the btree helper to be able to iterate only the records on
level 0, then port iread_extents to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c  |  191 ++++++++++++++++++---------------------------
 fs/xfs/libxfs/xfs_btree.c |    8 +-
 fs/xfs/libxfs/xfs_btree.h |    4 +
 fs/xfs/scrub/bitmap.c     |    3 -
 4 files changed, 88 insertions(+), 118 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 587889585a23..31a7c7768ea0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1154,6 +1154,65 @@ xfs_bmap_add_attrfork(
  * Internal and external extent tree search functions.
  */
 
+struct xfs_iread_state {
+	struct xfs_iext_cursor	icur;
+	struct xfs_ifork	*ifp;
+	xfs_extnum_t		loaded;
+	xfs_extnum_t		nextents;
+	int			state;
+};
+
+/* Stuff every bmbt record from this block into the incore extent map. */
+static int
+xfs_iread_bmbt_block(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	void			*priv)
+{
+	struct xfs_iread_state	*ir = priv;
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	struct xfs_btree_block	*block;
+	struct xfs_buf		*bp;
+	struct xfs_bmbt_rec	*frp;
+	xfs_extnum_t		num_recs;
+	xfs_extnum_t		j;
+	int			whichfork = cur->bc_private.b.whichfork;
+
+	block = xfs_btree_get_block(cur, level, &bp);
+
+	/* Abort if we find more records than nextents. */
+	num_recs = xfs_btree_get_numrecs(block);
+	if (unlikely(ir->loaded + num_recs > ir->nextents)) {
+		xfs_warn(ip->i_mount, "corrupt dinode %llu, (btree extents).",
+				(unsigned long long)ip->i_ino);
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, block,
+				sizeof(*block), __this_address);
+		return -EFSCORRUPTED;
+	}
+
+	/* Copy records into the incore cache. */
+	frp = XFS_BMBT_REC_ADDR(mp, block, 1);
+	for (j = 0; j < num_recs; j++, frp++, ir->loaded++) {
+		struct xfs_bmbt_irec	new;
+		xfs_failaddr_t		fa;
+
+		xfs_bmbt_disk_get_all(frp, &new);
+		fa = xfs_bmap_validate_extent(ip, whichfork, &new);
+		if (fa) {
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED,
+					"xfs_iread_extents(2)", frp,
+					sizeof(*frp), fa);
+			return -EFSCORRUPTED;
+		}
+		xfs_iext_insert(ip, &ir->icur, &new, ir->state);
+		trace_xfs_read_extent(ip, &ir->icur, ir->state, _THIS_IP_);
+		xfs_iext_next(ir->ifp, &ir->icur);
+	}
+
+	return 0;
+}
+
 /*
  * Read in extents from a btree-format inode.
  */
@@ -1163,136 +1222,40 @@ xfs_iread_extents(
 	struct xfs_inode	*ip,
 	int			whichfork)
 {
+	struct xfs_iread_state	ir = {
+		.state		= xfs_bmap_fork_to_state(whichfork),
+		.ifp		= XFS_IFORK_PTR(ip, whichfork),
+		.nextents	= XFS_IFORK_NEXTENTS(ip, whichfork),
+	};
 	struct xfs_mount	*mp = ip->i_mount;
-	int			state = xfs_bmap_fork_to_state(whichfork);
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
-	xfs_extnum_t		nextents = XFS_IFORK_NEXTENTS(ip, whichfork);
-	struct xfs_btree_block	*block = ifp->if_broot;
-	struct xfs_iext_cursor	icur;
-	struct xfs_bmbt_irec	new;
-	xfs_fsblock_t		bno;
-	struct xfs_buf		*bp;
-	xfs_extnum_t		i, j;
-	int			level;
-	__be64			*pp;
+	struct xfs_btree_cur	*cur;
 	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (unlikely(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
-	 */
-	level = be16_to_cpu(block->bb_level);
-	if (unlikely(level == 0)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
-		return -EFSCORRUPTED;
-	}
-	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
-	bno = be64_to_cpu(*pp);
-
-	/*
-	 * Go down the tree until leaf level is reached, following the first
-	 * pointer (leftmost) at each level.
-	 */
-	while (level-- > 0) {
-		error = xfs_btree_read_bufl(mp, tp, bno, &bp,
-				XFS_BMAP_BTREE_REF, &xfs_bmbt_buf_ops);
-		if (error)
-			goto out;
-		block = XFS_BUF_TO_BLOCK(bp);
-		if (level == 0)
-			break;
-		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
-		bno = be64_to_cpu(*pp);
-		XFS_WANT_CORRUPTED_GOTO(mp,
-			xfs_verify_fsbno(mp, bno), out_brelse);
-		xfs_trans_brelse(tp, bp);
+		error = -EFSCORRUPTED;
+		goto out;
 	}
 
-	/*
-	 * Here with bp and block set to the leftmost leaf node in the tree.
-	 */
-	i = 0;
-	xfs_iext_first(ifp, &icur);
-
-	/*
-	 * Loop over all leaf nodes.  Copy information to the extent records.
-	 */
-	for (;;) {
-		xfs_bmbt_rec_t	*frp;
-		xfs_fsblock_t	nextbno;
-		xfs_extnum_t	num_recs;
-
-		num_recs = xfs_btree_get_numrecs(block);
-		if (unlikely(i + num_recs > nextents)) {
-			xfs_warn(ip->i_mount,
-				"corrupt dinode %Lu, (btree extents).",
-				(unsigned long long) ip->i_ino);
-			xfs_inode_verifier_error(ip, -EFSCORRUPTED,
-					__func__, block, sizeof(*block),
-					__this_address);
-			error = -EFSCORRUPTED;
-			goto out_brelse;
-		}
-		/*
-		 * Read-ahead the next leaf block, if any.
-		 */
-		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
-		if (nextbno != NULLFSBLOCK)
-			xfs_btree_reada_bufl(mp, nextbno, 1,
-					     &xfs_bmbt_buf_ops);
-		/*
-		 * Copy records into the extent records.
-		 */
-		frp = XFS_BMBT_REC_ADDR(mp, block, 1);
-		for (j = 0; j < num_recs; j++, frp++, i++) {
-			xfs_failaddr_t	fa;
-
-			xfs_bmbt_disk_get_all(frp, &new);
-			fa = xfs_bmap_validate_extent(ip, whichfork, &new);
-			if (fa) {
-				error = -EFSCORRUPTED;
-				xfs_inode_verifier_error(ip, error,
-						"xfs_iread_extents(2)",
-						frp, sizeof(*frp), fa);
-				goto out_brelse;
-			}
-			xfs_iext_insert(ip, &icur, &new, state);
-			trace_xfs_read_extent(ip, &icur, state, _THIS_IP_);
-			xfs_iext_next(ifp, &icur);
-		}
-		xfs_trans_brelse(tp, bp);
-		bno = nextbno;
-		/*
-		 * If we've reached the end, stop.
-		 */
-		if (bno == NULLFSBLOCK)
-			break;
-		error = xfs_btree_read_bufl(mp, tp, bno, &bp,
-				XFS_BMAP_BTREE_REF, &xfs_bmbt_buf_ops);
-		if (error)
-			goto out;
-		block = XFS_BUF_TO_BLOCK(bp);
-	}
+	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
+	error = xfs_btree_visit_blocks(cur, xfs_iread_bmbt_block,
+			XFS_BTREE_VISIT_RECORDS_ONLY, &ir);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out;
 
-	if (i != XFS_IFORK_NEXTENTS(ip, whichfork)) {
+	if (ir.loaded != ir.nextents) {
 		error = -EFSCORRUPTED;
 		goto out;
 	}
-	ASSERT(i == xfs_iext_count(ifp));
+	ASSERT(ir.loaded == xfs_iext_count(ir.ifp));
 
-	ifp->if_flags |= XFS_IFEXTENTS;
+	ir.ifp->if_flags |= XFS_IFEXTENTS;
 	return 0;
-
-out_brelse:
-	xfs_trans_brelse(tp, bp);
 out:
-	xfs_iext_destroy(ifp);
+	xfs_iext_destroy(ir.ifp);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 71de937f9e64..8f2c151b543a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4286,6 +4286,7 @@ int
 xfs_btree_visit_blocks(
 	struct xfs_btree_cur		*cur,
 	xfs_btree_visit_blocks_fn	fn,
+	unsigned int			flags,
 	void				*data)
 {
 	union xfs_btree_ptr		lptr;
@@ -4313,6 +4314,9 @@ xfs_btree_visit_blocks(
 			xfs_btree_copy_ptrs(cur, &lptr, ptr, 1);
 		}
 
+		if ((flags & XFS_BTREE_VISIT_RECORDS_ONLY) && level > 0)
+			continue;
+
 		/* for each buffer in the level */
 		do {
 			error = xfs_btree_visit_block(cur, level, fn, data);
@@ -4412,7 +4416,7 @@ xfs_btree_change_owner(
 	bbcoi.new_owner = new_owner;
 	bbcoi.buffer_list = buffer_list;
 
-	return xfs_btree_visit_blocks(cur, xfs_btree_block_change_owner,
+	return xfs_btree_visit_blocks(cur, xfs_btree_block_change_owner, 0,
 			&bbcoi);
 }
 
@@ -4864,7 +4868,7 @@ xfs_btree_count_blocks(
 	xfs_extlen_t		*blocks)
 {
 	*blocks = 0;
-	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper,
+	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper, 0,
 			blocks);
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index ced1e65d1483..d2fc17f84d9b 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -482,8 +482,10 @@ int xfs_btree_query_all(struct xfs_btree_cur *cur, xfs_btree_query_range_fn fn,
 
 typedef int (*xfs_btree_visit_blocks_fn)(struct xfs_btree_cur *cur, int level,
 		void *data);
+/* Only visit record blocks. */
+#define XFS_BTREE_VISIT_RECORDS_ONLY	(0x1)
 int xfs_btree_visit_blocks(struct xfs_btree_cur *cur,
-		xfs_btree_visit_blocks_fn fn, void *data);
+		xfs_btree_visit_blocks_fn fn, unsigned int flags, void *data);
 
 int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_extlen_t *blocks);
 
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 3d47d111be5a..6e5e28fcdd4a 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -294,5 +294,6 @@ xfs_bitmap_set_btblocks(
 	struct xfs_bitmap	*bitmap,
 	struct xfs_btree_cur	*cur)
 {
-	return xfs_btree_visit_blocks(cur, xfs_bitmap_collect_btblock, bitmap);
+	return xfs_btree_visit_blocks(cur, xfs_bitmap_collect_btblock, 0,
+			bitmap);
 }

