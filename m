Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496ADC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E72D9206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rnW7G0Dg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgAABDn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:03:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48816 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgAABDn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:03:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00110HsG084042
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=6cuMkujUBUZXg/9hZvy3Wc1a7IwnKDVW43xtaidOkn8=;
 b=rnW7G0DgnvBRxFAxMaZm5aOTA3k4JSdS4g9OOYVNVQMMuP5gOd/dtppUtLORx1W9EeHb
 Fc3RKzESWxqPgYoTnS88ta2G+EJHNhvGeDIj2Stzab9faXkWqxr5KQsvRx3cPqJsYFH+
 nsBlIZrMUrnwPH0Lo+jCjRLB9rOthF+7fIGo56tnWtHc3p5FgHTdOFjDss3rxjWXBRVF
 V9BkmJlTmJ3IXeDNOQwjeNL6KjlgmLHCLoQ2PCR96CP33bU+AAgMJz0yZraFxhB3z2uB
 wCX31W1R4L67ovX4sFiEClEdwczrjqELn3mZWXpnMreKEveCJkt7N3ITEdVRb95YPl9H mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:03:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010wh0R172169
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrfv04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:03:38 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00113b8I023533
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:38 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:03:37 -0800
Subject: [PATCH 3/4] xfs: repair inode block maps
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:03:35 -0800
Message-ID: <157784061532.1358827.13287941462747200436.stgit@magnolia>
In-Reply-To: <157784059646.1358827.16261069190736091900.stgit@magnolia>
References: <157784059646.1358827.16261069190736091900.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the reverse-mapping btree information to rebuild an inode block map.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_bmap_btree.c |  113 +++++++-
 fs/xfs/libxfs/xfs_bmap_btree.h |    8 +
 fs/xfs/libxfs/xfs_iext_tree.c  |   23 +-
 fs/xfs/libxfs/xfs_inode_fork.c |   23 +-
 fs/xfs/libxfs/xfs_inode_fork.h |    4 
 fs/xfs/scrub/bmap.c            |   22 ++
 fs/xfs/scrub/bmap_repair.c     |  560 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h          |    4 
 fs/xfs/scrub/scrub.c           |    4 
 fs/xfs/scrub/trace.h           |   34 ++
 fs/xfs/xfs_trans.c             |   54 ++++
 fs/xfs/xfs_trans.h             |    2 
 13 files changed, 816 insertions(+), 36 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a66b75625940..933ba41396b0 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -162,6 +162,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   alloc_repair.o \
 				   array.o \
 				   bitmap.o \
+				   bmap_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   refcount_repair.o \
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index ffe608d2a2d9..e9c1e2862df5 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -58,7 +58,7 @@ xfs_bmdr_to_bmbt(
 
 void
 xfs_bmbt_disk_get_all(
-	struct xfs_bmbt_rec	*rec,
+	const struct xfs_bmbt_rec *rec,
 	struct xfs_bmbt_irec	*irec)
 {
 	uint64_t		l0 = get_unaligned_be64(&rec->l0);
@@ -300,10 +300,7 @@ xfs_bmbt_get_minrecs(
 	int			level)
 {
 	if (level == cur->bc_nlevels - 1) {
-		struct xfs_ifork	*ifp;
-
-		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
-				    cur->bc_private.b.whichfork);
+		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
 					ifp->if_broot_bytes, level == 0) / 2;
@@ -318,10 +315,7 @@ xfs_bmbt_get_maxrecs(
 	int			level)
 {
 	if (level == cur->bc_nlevels - 1) {
-		struct xfs_ifork	*ifp;
-
-		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
-				    cur->bc_private.b.whichfork);
+		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
 					ifp->if_broot_bytes, level == 0);
@@ -541,40 +535,123 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 /*
  * Allocate a new bmap btree cursor.
  */
-struct xfs_btree_cur *				/* new bmap btree cursor */
-xfs_bmbt_init_cursor(
+static struct xfs_btree_cur *			/* new bmap btree cursor */
+xfs_bmbt_init_common(
 	struct xfs_mount	*mp,		/* file system mount point */
 	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_inode	*ip,		/* inode owning the btree */
-	int			whichfork)	/* data or attr fork */
+	struct xfs_inode	*ip)		/* inode owning the btree */
 {
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_cur	*cur;
-	ASSERT(whichfork != XFS_COW_FORK);
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
-	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 	cur->bc_btnum = XFS_BTNUM_BMAP;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
-	cur->bc_ops = &xfs_bmbt_ops;
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
 	cur->bc_private.b.ip = ip;
 	cur->bc_private.b.allocated = 0;
 	cur->bc_private.b.flags = 0;
+	cur->bc_ops = &xfs_bmbt_ops;
+
+	return cur;
+}
+
+/*
+ * Allocate a new bmap btree cursor.
+ */
+struct xfs_btree_cur *				/* new bmap btree cursor */
+xfs_bmbt_init_cursor(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_inode	*ip,		/* inode owning the btree */
+	int			whichfork)	/* data or attr fork */
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_btree_cur	*cur;
+	ASSERT(whichfork != XFS_COW_FORK);
+
+	cur = xfs_bmbt_init_common(mp, tp, ip);
+
+	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
+	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
 	cur->bc_private.b.whichfork = whichfork;
 
 	return cur;
 }
 
+/*
+ * Allocate a new bmap btree cursor for reloading an inode block mapping data
+ * structure.  Note that callers can use the staged cursor to reload extents
+ * format inode forks if they rebuild the iext tree and commit the staged
+ * cursor immediately.
+ */
+struct xfs_btree_cur *
+xfs_bmbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xbtree_ifakeroot	*ifake)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_btree_ops	*ops;
+
+	cur = xfs_bmbt_init_common(mp, tp, ip);
+	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_private.b.forksize = ifake->if_fork_size;
+	cur->bc_private.b.whichfork = -1;
+	xfs_btree_stage_ifakeroot(cur, ifake, &ops);
+	ops->update_cursor = NULL;
+	return cur;
+}
+
+/*
+ * Swap in the new inode fork root.  Once we pass this point the newly rebuilt
+ * mappings are in place and we have to kill off any old btree blocks.
+ */
+void
+xfs_bmbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	int			whichfork)
+{
+	struct xbtree_ifakeroot	*ifake = cur->bc_private.b.ifake;
+	struct xfs_ifork	*ifp;
+	static const short	brootflag[2] =
+		{ XFS_ILOG_DBROOT, XFS_ILOG_ABROOT };
+	static const short	extflag[2] =
+		{ XFS_ILOG_DEXT, XFS_ILOG_AEXT };
+	int			flags = XFS_ILOG_CORE;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+	ASSERT(whichfork != XFS_COW_FORK);
+
+	ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, whichfork);
+	xfs_ifork_reset(ifp);
+	memcpy(ifp, ifake->if_fork, sizeof(struct xfs_ifork));
+
+	XFS_IFORK_FMT_SET(cur->bc_private.b.ip, whichfork, ifake->if_format);
+	XFS_IFORK_NEXT_SET(cur->bc_private.b.ip, whichfork, ifake->if_extents);
+	switch (ifake->if_format) {
+	case XFS_DINODE_FMT_EXTENTS:
+		flags |= extflag[whichfork];
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		flags |= brootflag[whichfork];
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+	xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip, flags);
+	xfs_btree_commit_ifakeroot(cur, whichfork, &xfs_bmbt_ops);
+}
+
 /*
  * Calculate number of records in a bmap btree block.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 29b407d053b4..0b20736808a3 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -11,6 +11,7 @@ struct xfs_btree_block;
 struct xfs_mount;
 struct xfs_inode;
 struct xfs_trans;
+struct xbtree_ifakeroot;
 
 /*
  * Btree block header size depends on a superblock flag.
@@ -90,7 +91,8 @@ extern void xfs_bmdr_to_bmbt(struct xfs_inode *, xfs_bmdr_block_t *, int,
 void xfs_bmbt_disk_set_all(struct xfs_bmbt_rec *r, struct xfs_bmbt_irec *s);
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
-extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
+extern void xfs_bmbt_disk_get_all(const struct xfs_bmbt_rec *r,
+		struct xfs_bmbt_irec *s);
 
 extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
 			xfs_bmdr_block_t *, int);
@@ -105,6 +107,10 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
 
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
+struct xfs_btree_cur *xfs_bmbt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xfs_inode *ip,
+		struct xbtree_ifakeroot *ifake);
+void xfs_bmbt_commit_staged_btree(struct xfs_btree_cur *cur, int whichfork);
 
 extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 52451809c478..ad56a69c735a 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -622,13 +622,11 @@ static inline void xfs_iext_inc_seq(struct xfs_ifork *ifp)
 }
 
 void
-xfs_iext_insert(
-	struct xfs_inode	*ip,
+xfs_iext_insert_raw(
+	struct xfs_ifork	*ifp,
 	struct xfs_iext_cursor	*cur,
-	struct xfs_bmbt_irec	*irec,
-	int			state)
+	struct xfs_bmbt_irec	*irec)
 {
-	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
 	xfs_fileoff_t		offset = irec->br_startoff;
 	struct xfs_iext_leaf	*new = NULL;
 	int			nr_entries, i;
@@ -662,12 +660,23 @@ xfs_iext_insert(
 	xfs_iext_set(cur_rec(cur), irec);
 	ifp->if_bytes += sizeof(struct xfs_iext_rec);
 
-	trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
-
 	if (new)
 		xfs_iext_insert_node(ifp, xfs_iext_leaf_key(new, 0), new, 2);
 }
 
+void
+xfs_iext_insert(
+	struct xfs_inode	*ip,
+	struct xfs_iext_cursor	*cur,
+	struct xfs_bmbt_irec	*irec,
+	int			state)
+{
+	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
+
+	trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
+	xfs_iext_insert_raw(ifp, cur, irec);
+}
+
 static struct xfs_iext_node *
 xfs_iext_rebalance_node(
 	struct xfs_iext_node	*parent,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ad2b9c313fd2..e8ed4d8551ec 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -502,14 +502,11 @@ xfs_idata_realloc(
 	ifp->if_bytes = new_size;
 }
 
+/* Free all memory and reset a fork back to its initial state. */
 void
-xfs_idestroy_fork(
-	xfs_inode_t	*ip,
-	int		whichfork)
+xfs_ifork_reset(
+	struct xfs_ifork	*ifp)
 {
-	struct xfs_ifork	*ifp;
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (ifp->if_broot != NULL) {
 		kmem_free(ifp->if_broot);
 		ifp->if_broot = NULL;
@@ -521,7 +518,7 @@ xfs_idestroy_fork(
 	 * not local then we may or may not have an extents list,
 	 * so check and free it up if we do.
 	 */
-	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
+	if (ifp->if_flags & XFS_IFINLINE) {
 		if (ifp->if_u1.if_data != NULL) {
 			kmem_free(ifp->if_u1.if_data);
 			ifp->if_u1.if_data = NULL;
@@ -529,6 +526,18 @@ xfs_idestroy_fork(
 	} else if ((ifp->if_flags & XFS_IFEXTENTS) && ifp->if_height) {
 		xfs_iext_destroy(ifp);
 	}
+	ifp->if_flags = 0;
+}
+
+void
+xfs_idestroy_fork(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	xfs_ifork_reset(ifp);
 
 	if (whichfork == XFS_ATTR_FORK) {
 		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 500333d0101e..370ac0b099f0 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -96,6 +96,7 @@ struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
 int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
 void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 				struct xfs_inode_log_item *, int);
+void		xfs_ifork_reset(struct xfs_ifork *ifp);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
 void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
 				int whichfork);
@@ -107,6 +108,9 @@ void		xfs_init_local_fork(struct xfs_inode *ip, int whichfork,
 				const void *data, int64_t size);
 
 xfs_extnum_t	xfs_iext_count(struct xfs_ifork *ifp);
+void		xfs_iext_insert_raw(struct xfs_ifork *ifp,
+			struct xfs_iext_cursor *cur,
+			struct xfs_bmbt_irec *irec);
 void		xfs_iext_insert(struct xfs_inode *, struct xfs_iext_cursor *cur,
 			struct xfs_bmbt_irec *, int);
 void		xfs_iext_remove(struct xfs_inode *, struct xfs_iext_cursor *,
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index fa6ea6407992..d8214f156f03 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -29,6 +29,7 @@ xchk_setup_inode_bmap(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
 {
+	bool			is_repair = false;
 	int			error;
 
 	error = xchk_get_inode(sc, ip);
@@ -38,6 +39,10 @@ xchk_setup_inode_bmap(
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
 
+#ifdef CONFIG_XFS_REPAIR
+	is_repair = (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR);
+#endif
+
 	/*
 	 * We don't want any ephemeral data fork updates sitting around
 	 * while we inspect block mappings, so wait for directio to finish
@@ -45,10 +50,27 @@ xchk_setup_inode_bmap(
 	 */
 	if (S_ISREG(VFS_I(sc->ip)->i_mode) &&
 	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
+		/* Break all our leases, we're going to mess with things. */
+		if (is_repair) {
+			error = xfs_break_layouts(VFS_I(sc->ip),
+					&sc->ilock_flags, BREAK_UNMAP);
+			if (error)
+				goto out;
+		}
+
 		inode_dio_wait(VFS_I(sc->ip));
 		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
 		if (error)
 			goto out;
+
+		/* Drop the page cache if we're repairing block mappings. */
+		if (is_repair) {
+			error = invalidate_inode_pages2(
+					VFS_I(sc->ip)->i_mapping);
+			if (error)
+				goto out;
+		}
+
 	}
 
 	/* Got the inode, lock it and we're ready to go. */
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
new file mode 100644
index 000000000000..187858f0c119
--- /dev/null
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -0,0 +1,560 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_alloc.h"
+#include "xfs_rtalloc.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_quota.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/array.h"
+
+/*
+ * Inode Fork Block Mapping (BMBT) Repair
+ * ======================================
+ *
+ * Gather all the rmap records for the inode and fork we're fixing, reset the
+ * incore fork, then recreate the btree.
+ */
+struct xrep_bmap {
+	/* Old bmbt blocks */
+	struct xbitmap		old_bmbt_blocks;
+
+	/* New fork. */
+	struct xrep_newbt	new_fork_info;
+	struct xfs_btree_bload	bmap_bload;
+
+	/* List of new bmap records. */
+	struct xfbma		*bmap_records;
+
+	struct xfs_scrub	*sc;
+
+	/* How many blocks did we find allocated to this file? */
+	xfs_rfsblock_t		nblocks;
+
+	/* How many bmbt blocks did we find for this fork? */
+	xfs_rfsblock_t		old_bmbt_block_count;
+
+	/* get_data()'s position in the free space record array. */
+	uint64_t		iter;
+
+	/* Which fork are we fixing? */
+	int			whichfork;
+};
+
+/* Record extents that belong to this inode's fork. */
+STATIC int
+xrep_bmap_walk_rmap(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv)
+{
+	struct xrep_bmap	*rb = priv;
+	struct xfs_bmbt_rec	rbe;
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_fsblock_t		fsbno;
+	int			error = 0;
+
+	if (xchk_should_terminate(rb->sc, &error))
+		return error;
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != rb->sc->ip->i_ino)
+		return 0;
+
+	rb->nblocks += rec->rm_blockcount;
+
+	/* If this rmap isn't for the fork we want, we're done. */
+	if (rb->whichfork == XFS_DATA_FORK &&
+	    (rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+	if (rb->whichfork == XFS_ATTR_FORK &&
+	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+
+	/* Remember any old bmbt blocks we find so we can delete them later. */
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
+		fsbno = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
+				rec->rm_startblock);
+		rb->old_bmbt_block_count += rec->rm_blockcount;
+		return xbitmap_set(&rb->old_bmbt_blocks, fsbno,
+				rec->rm_blockcount);
+	}
+
+	/* Remember this rmap as a series of bmap records. */
+	irec.br_startoff = rec->rm_offset;
+	irec.br_startblock = XFS_AGB_TO_FSB(mp, cur->bc_private.a.agno,
+					rec->rm_startblock);
+	if (rec->rm_flags & XFS_RMAP_UNWRITTEN)
+		irec.br_state = XFS_EXT_UNWRITTEN;
+	else
+		irec.br_state = XFS_EXT_NORM;
+
+	do {
+		xfs_extlen_t len = min_t(xfs_filblks_t, rec->rm_blockcount,
+					 MAXEXTLEN);
+
+		irec.br_blockcount = len;
+		xfs_bmbt_disk_set_all(&rbe, &irec);
+
+		trace_xrep_bmap_found(rb->sc->ip, rb->whichfork, &irec);
+
+		if (xchk_should_terminate(rb->sc, &error))
+			break;
+
+		error = xfbma_append(rb->bmap_records, &rbe);
+		if (error)
+			break;
+
+		irec.br_startblock += len;
+		irec.br_startoff += len;
+		rec->rm_blockcount -= len;
+	} while (rec->rm_blockcount > 0);
+
+	return error;
+}
+
+/* Compare two bmap extents. */
+static int
+xrep_bmap_extent_cmp(
+	const void			*a,
+	const void			*b)
+{
+	xfs_fileoff_t			ao;
+	xfs_fileoff_t			bo;
+
+	ao = xfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)a);
+	bo = xfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)b);
+
+	if (ao > bo)
+		return 1;
+	else if (ao < bo)
+		return -1;
+	return 0;
+}
+
+/* Scan one AG for reverse mappings that we can turn into extent maps. */
+STATIC int
+xrep_bmap_scan_ag(
+	struct xrep_bmap	*rb,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*agf_bp = NULL;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
+	if (error)
+		return error;
+	if (!agf_bp)
+		return -ENOMEM;
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, agno);
+	error = xfs_rmap_query_all(cur, xrep_bmap_walk_rmap, rb);
+	xfs_btree_del_cursor(cur, error);
+	xfs_trans_brelse(sc->tp, agf_bp);
+	return error;
+}
+
+/*
+ * Collect block mappings for this fork of this inode and decide if we have
+ * enough space to rebuild.  Caller is responsible for cleaning up the list if
+ * anything goes wrong.
+ */
+STATIC int
+xrep_bmap_find_mappings(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	xfs_agnumber_t		agno;
+	int			error = 0;
+
+	/* Iterate the rmaps for extents. */
+	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
+		error = xrep_bmap_scan_ag(rb, agno);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Retrieve bmap data for bulk load. */
+STATIC int
+xrep_bmap_get_data(
+	struct xfs_btree_cur	*cur,
+	void			*priv)
+{
+	struct xfs_bmbt_rec	rec;
+	struct xfs_bmbt_irec	*irec = &cur->bc_rec.b;
+	struct xrep_bmap	*rb = priv;
+	int			error;
+
+	error = xfbma_get_data(rb->bmap_records, &rb->iter, &rec);
+	if (error)
+		return error;
+
+	xfs_bmbt_disk_get_all(&rec, irec);
+	return 0;
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+STATIC int
+xrep_bmap_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_bmap        *rb = priv;
+
+	return xrep_newbt_claim_block(cur, &rb->new_fork_info, ptr);
+}
+
+/* Figure out how much space we need to create the incore btree root block. */
+STATIC size_t
+xrep_bmap_iroot_size(
+	struct xfs_btree_cur	*cur,
+	unsigned int		nr_this_level,
+	void			*priv)
+{
+	return XFS_BMAP_BROOT_SPACE_CALC(cur->bc_mp, nr_this_level);
+}
+
+/* Update the inode counters. */
+STATIC int
+xrep_bmap_reset_counters(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	struct xbtree_ifakeroot	*ifake = &rb->new_fork_info.ifake;
+	int64_t			delta;
+	int			error;
+
+	/*
+	 * Update the inode block counts to reflect the extents we found in the
+	 * rmapbt.
+	 */
+	delta = ifake->if_blocks - rb->old_bmbt_block_count;
+	sc->ip->i_d.di_nblocks = rb->nblocks + delta;
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+
+	/*
+	 * Adjust the quota counts by the difference in size between the old
+	 * and new bmbt.
+	 */
+	if (delta == 0 || !XFS_IS_QUOTA_ON(sc->mp))
+		return 0;
+
+	error = xrep_ino_dqattach(sc);
+	if (error)
+		return error;
+
+	xfs_trans_mod_dquot_byino(sc->tp, sc->ip, XFS_TRANS_DQ_BCOUNT, delta);
+	return 0;
+}
+
+/* Create a new iext tree and load it with block mappings. */
+STATIC int
+xrep_bmap_extents_load(
+	struct xrep_bmap	*rb,
+	struct xfs_btree_cur	*bmap_cur)
+{
+	struct xfs_iext_cursor	icur;
+	struct xbtree_ifakeroot	*ifake = &rb->new_fork_info.ifake;
+	struct xfs_ifork	*ifp = ifake->if_fork;
+	unsigned int		i;
+	int			error;
+
+	ASSERT(ifp->if_bytes == 0);
+
+	/* Add all the records to the incore extent tree. */
+	rb->iter = 0;
+	xfs_iext_first(ifp, &icur);
+	for (i = 0; i < ifake->if_extents; i++) {
+		error = xrep_bmap_get_data(bmap_cur, rb);
+		if (error)
+			return error;
+		xfs_iext_insert_raw(ifp, &icur, &bmap_cur->bc_rec.b);
+		xfs_iext_next(ifp, &icur);
+	}
+	ifp->if_flags = XFS_IFEXTENTS;
+
+	return 0;
+}
+
+/* Reserve new btree blocks and bulk load all the bmap records. */
+STATIC int
+xrep_bmap_btree_load(
+	struct xrep_bmap	*rb,
+	struct xfs_btree_cur	**bmap_curp)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	struct xbtree_ifakeroot	*ifake = &rb->new_fork_info.ifake;
+	int			error;
+
+	rb->bmap_bload.get_data = xrep_bmap_get_data;
+	rb->bmap_bload.alloc_block = xrep_bmap_alloc_block;
+	rb->bmap_bload.iroot_size = xrep_bmap_iroot_size;
+	xrep_bload_estimate_slack(sc, &rb->bmap_bload);
+
+	/* Compute how many blocks we'll need. */
+	error = xfs_btree_bload_compute_geometry(*bmap_curp, &rb->bmap_bload,
+			ifake->if_extents);
+	if (error)
+		return error;
+	xfs_btree_del_cursor(*bmap_curp, error);
+	*bmap_curp = NULL;
+
+	/*
+	 * Guess how many blocks we're going to need to rebuild an entire bmap
+	 * from the number of extents we found, and pump up our transaction to
+	 * have sufficient block reservation.
+	 */
+	error = xfs_trans_reserve_more(sc->tp, rb->bmap_bload.nr_blocks, 0);
+	if (error)
+		return error;
+
+	/*
+	 * Reserve the space we'll need for the new btree.  Drop the cursor
+	 * while we do this because that can roll the transaction and cursors
+	 * can't handle that.
+	 */
+	error = xrep_newbt_alloc_blocks(&rb->new_fork_info,
+			rb->bmap_bload.nr_blocks);
+	if (error)
+		return error;
+
+	/* Add all observed bmap records. */
+	rb->iter = 0;
+	*bmap_curp = xfs_bmbt_stage_cursor(sc->mp, sc->tp, sc->ip, ifake);
+	return xfs_btree_bload(*bmap_curp, &rb->bmap_bload, rb);
+}
+
+/*
+ * Use the collected bmap information to stage a new bmap fork.  If this is
+ * successful we'll return with the new fork information logged to the repair
+ * transaction but not yet committed.
+ */
+STATIC int
+xrep_bmap_build_new_fork(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_owner_info	oinfo;
+	struct xfs_scrub	*sc = rb->sc;
+	struct xfs_btree_cur	*bmap_cur;
+	struct xbtree_ifakeroot	*ifake = &rb->new_fork_info.ifake;
+	int			error;
+
+	/*
+	 * Sort the bmap extents by startblock to avoid btree splits when we
+	 * rebuild the bmbt btree.
+	 */
+	error = xfbma_sort(rb->bmap_records, xrep_bmap_extent_cmp);
+	if (error)
+		return error;
+
+	/*
+	 * Prepare to construct the new fork by initializing the new btree
+	 * structure and creating a fake ifork in the ifakeroot structure.
+	 */
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
+	xrep_newbt_init_inode(&rb->new_fork_info, sc, rb->whichfork, &oinfo);
+	bmap_cur = xfs_bmbt_stage_cursor(sc->mp, sc->tp, sc->ip, ifake);
+
+	/*
+	 * Figure out the size and format of the new fork, then fill it with
+	 * all the bmap records we've found.  Join the inode to the transaction
+	 * so that we can roll the transaction while holding the inode locked.
+	 */
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	ifake->if_extents = xfbma_length(rb->bmap_records);
+	if (XFS_BMDR_SPACE_CALC(ifake->if_extents) <=
+	    XFS_DFORK_SIZE(&sc->ip->i_d, sc->mp, rb->whichfork)) {
+		ifake->if_format = XFS_DINODE_FMT_EXTENTS;
+		error = xrep_bmap_extents_load(rb, bmap_cur);
+	} else {
+		ifake->if_format = XFS_DINODE_FMT_BTREE;
+		error = xrep_bmap_btree_load(rb, &bmap_cur);
+	}
+	if (error)
+		goto err_cur;
+
+	/*
+	 * Install the new fork in the inode.  After this point the old mapping
+	 * data are no longer accessible and the new tree is live.  We delete
+	 * the cursor immediately after committing the staged root because the
+	 * staged fork might be in extents format.
+	 */
+	xfs_bmbt_commit_staged_btree(bmap_cur, rb->whichfork);
+	xfs_btree_del_cursor(bmap_cur, 0);
+
+	/* Reset the inode counters now that we've changed the fork. */
+	error = xrep_bmap_reset_counters(rb);
+	if (error)
+		goto err_newbt;
+
+	/* Dispose of any unused blocks and the accounting information. */
+	xrep_newbt_destroy(&rb->new_fork_info, error);
+
+	return xfs_trans_roll_inode(&sc->tp, sc->ip);
+err_cur:
+	if (bmap_cur)
+		xfs_btree_del_cursor(bmap_cur, error);
+err_newbt:
+	xrep_newbt_destroy(&rb->new_fork_info, error);
+	return error;
+}
+
+/*
+ * Now that we've logged the new inode btree, invalidate all of the old blocks
+ * and free them, if there were any.
+ */
+STATIC int
+xrep_bmap_remove_old_tree(
+	struct xrep_bmap	*rb)
+{
+	struct xfs_scrub	*sc = rb->sc;
+	struct xfs_owner_info	oinfo;
+
+	/* Free the old bmbt blocks if they're not in use. */
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
+	return xrep_reap_extents(sc, &rb->old_bmbt_blocks, &oinfo,
+			XFS_AG_RESV_NONE);
+}
+
+/* Check for garbage inputs. */
+STATIC int
+xrep_bmap_check_inputs(
+	struct xfs_scrub	*sc,
+	int			whichfork)
+{
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	/* Don't know how to repair the other fork formats. */
+	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE)
+		return -EOPNOTSUPP;
+
+	/*
+	 * If there's no attr fork area in the inode, there's no attr fork to
+	 * rebuild.
+	 */
+	if (whichfork == XFS_ATTR_FORK) {
+		if (!XFS_IFORK_Q(sc->ip))
+			return -ENOENT;
+		return 0;
+	}
+
+	/* Only files, symlinks, and directories get to have data forks. */
+	switch (VFS_I(sc->ip)->i_mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFDIR:
+	case S_IFLNK:
+		/* ok */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* If we somehow have delalloc extents, forget it. */
+	if (sc->ip->i_delayed_blks)
+		return -EBUSY;
+
+	/* Don't know how to rebuild realtime data forks. */
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/* Repair an inode fork. */
+STATIC int
+xrep_bmap(
+	struct xfs_scrub	*sc,
+	int			whichfork)
+{
+	struct xrep_bmap	*rb;
+	int			error = 0;
+
+	error = xrep_bmap_check_inputs(sc, whichfork);
+	if (error)
+		return error;
+
+	rb = kmem_zalloc(sizeof(struct xrep_bmap), KM_NOFS | KM_MAYFAIL);
+	if (!rb)
+		return -ENOMEM;
+	rb->sc = sc;
+	rb->whichfork = whichfork;
+
+	/* Set up some storage */
+	rb->bmap_records = xfbma_init(sizeof(struct xfs_bmbt_rec));
+	if (IS_ERR(rb->bmap_records)) {
+		error = PTR_ERR(rb->bmap_records);
+		goto out_rb;
+	}
+
+	/* Collect all reverse mappings for this fork's extents. */
+	xbitmap_init(&rb->old_bmbt_blocks);
+	error = xrep_bmap_find_mappings(rb);
+	if (error)
+		goto out_bitmap;
+
+	/* Rebuild the bmap information. */
+	error = xrep_bmap_build_new_fork(rb);
+	if (error)
+		goto out_bitmap;
+
+	/* Kill the old tree. */
+	error = xrep_bmap_remove_old_tree(rb);
+
+out_bitmap:
+	xbitmap_destroy(&rb->old_bmbt_blocks);
+	xfbma_destroy(rb->bmap_records);
+out_rb:
+	kmem_free(rb);
+	return error;
+}
+
+/* Repair an inode's data fork. */
+int
+xrep_bmap_data(
+	struct xfs_scrub	*sc)
+{
+	return xrep_bmap(sc, XFS_DATA_FORK);
+}
+
+/* Repair an inode's attr fork. */
+int
+xrep_bmap_attr(
+	struct xfs_scrub	*sc)
+{
+	return xrep_bmap(sc, XFS_ATTR_FORK);
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index dfb4fe77fae8..84ea16f410bb 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -72,6 +72,8 @@ int xrep_allocbt(struct xfs_scrub *sc);
 int xrep_iallocbt(struct xfs_scrub *sc);
 int xrep_refcountbt(struct xfs_scrub *sc);
 int xrep_inode(struct xfs_scrub *sc);
+int xrep_bmap_data(struct xfs_scrub *sc);
+int xrep_bmap_attr(struct xfs_scrub *sc);
 
 struct xrep_newbt_resv {
 	/* Link to list of extents that we've reserved. */
@@ -171,6 +173,8 @@ xrep_reset_perag_resv(
 #define xrep_iallocbt			xrep_notsupported
 #define xrep_refcountbt			xrep_notsupported
 #define xrep_inode			xrep_notsupported
+#define xrep_bmap_data			xrep_notsupported
+#define xrep_bmap_attr			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index ee2b77b4350b..f5b6184f609b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -267,13 +267,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_inode_bmap,
 		.scrub	= xchk_bmap_data,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_bmap_data,
 	},
 	[XFS_SCRUB_TYPE_BMBTA] = {	/* inode attr fork */
 		.type	= ST_INODE,
 		.setup	= xchk_setup_inode_bmap,
 		.scrub	= xchk_bmap_attr,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_bmap_attr,
 	},
 	[XFS_SCRUB_TYPE_BMBTC] = {	/* inode CoW fork */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index ed9484de80fe..592f9512115c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -724,7 +724,7 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
 DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
 DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
-DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_walk_rmap);
 
 TRACE_EVENT(xrep_abt_found,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -809,6 +809,38 @@ TRACE_EVENT(xrep_refc_found,
 		  __entry->refcount)
 )
 
+TRACE_EVENT(xrep_bmap_found,
+	TP_PROTO(struct xfs_inode *ip, int whichfork,
+		 struct xfs_bmbt_irec *irec),
+	TP_ARGS(ip, whichfork, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, lblk)
+		__field(xfs_extlen_t, len)
+		__field(xfs_fsblock_t, pblk)
+		__field(int, state)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->whichfork = whichfork;
+		__entry->lblk = irec->br_startoff;
+		__entry->len = irec->br_blockcount;
+		__entry->pblk = irec->br_startblock;
+		__entry->state = irec->br_state;
+	),
+	TP_printk("dev %d:%d ino 0x%llx whichfork %s lblk 0x%llx len 0x%x pblk %llu st %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
+		  __entry->lblk,
+		  __entry->len,
+		  __entry->pblk,
+		  __entry->state)
+);
+
 TRACE_EVENT(xrep_init_btblock,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
 		 xfs_btnum_t btnum),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3b208f9a865c..3a0e0a6d1a0d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -129,6 +129,60 @@ xfs_trans_dup(
 	return ntp;
 }
 
+/*
+ * Try to reserve more blocks for a transaction.  The single use case we
+ * support is for online repair -- use a transaction to gather data without
+ * fear of btree cycle deadlocks; calculate how many blocks we really need
+ * from that data; and only then start modifying data.  This can fail due to
+ * ENOSPC, so we have to be able to cancel the transaction.
+ */
+int
+xfs_trans_reserve_more(
+	struct xfs_trans	*tp,
+	uint			blocks,
+	uint			rtextents)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
+	int			error = 0;
+
+	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+
+	/*
+	 * Attempt to reserve the needed disk blocks by decrementing
+	 * the number needed from the number available.  This will
+	 * fail if the count would go below zero.
+	 */
+	if (blocks > 0) {
+		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
+		if (error)
+			return -ENOSPC;
+		tp->t_blk_res += blocks;
+	}
+
+	/*
+	 * Attempt to reserve the needed realtime extents by decrementing
+	 * the number needed from the number available.  This will
+	 * fail if the count would go below zero.
+	 */
+	if (rtextents > 0) {
+		error = xfs_mod_frextents(mp, -((int64_t)rtextents));
+		if (error) {
+			error = -ENOSPC;
+			goto out_blocks;
+		}
+		tp->t_rtx_res += rtextents;
+	}
+
+	return 0;
+out_blocks:
+	if (blocks > 0) {
+		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
+		tp->t_blk_res -= blocks;
+	}
+	return error;
+}
+
 /*
  * This is called to reserve free disk blocks and log space for the
  * given transaction.  This must be done before allocating any resources
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 64d7f171ebd3..982d53eb2853 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -165,6 +165,8 @@ typedef struct xfs_trans {
 int		xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 			uint blocks, uint rtextents, uint flags,
 			struct xfs_trans **tpp);
+int		xfs_trans_reserve_more(struct xfs_trans *tp, uint blocks,
+			uint rtextents);
 int		xfs_trans_alloc_empty(struct xfs_mount *mp,
 			struct xfs_trans **tpp);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);

