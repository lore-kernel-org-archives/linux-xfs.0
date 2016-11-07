Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52950 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753618AbcKGRgZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Nov 2016 12:36:25 -0500
Subject: [PATCH 2/2 V2] xfs: provide helper for counting extents from if_bytes
References: <d279d52e-49f6-6fc2-c78b-0054d7ee0a1e@redhat.com>
 <6191b8d6-4a89-0191-728a-18ebdf9254c6@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cefe1878-7651-e0cc-2ec1-4e445bbb5670@sandeen.net>
Date: Mon, 7 Nov 2016 11:35:17 -0600
MIME-Version: 1.0
In-Reply-To: <6191b8d6-4a89-0191-728a-18ebdf9254c6@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

The open-coded pattern:

ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)

is all over the xfs code; provide a new helper
xfs_iext_count(ifp) to count the number of inline extents
in an inode fork.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---

V2: remove intermediate variable in helper


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c27344c..03e62be 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -515,7 +515,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 		state |= BMAP_ATTRFORK;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT(cnt == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)));
+	ASSERT(cnt == xfs_iext_count(ifp));
 	for (idx = 0; idx < cnt; idx++)
 		trace_xfs_extlist(ip, idx, whichfork, caller_ip);
 }
@@ -811,7 +811,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 				XFS_BTREE_LONG_PTRS);
 
 	arp = XFS_BMBT_REC_ADDR(mp, ablock, 1);
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nextents =  xfs_iext_count(ifp);
 	for (cnt = i = 0; i < nextents; i++) {
 		ep = xfs_iext_get_ext(ifp, i);
 		if (!isnullstartblock(xfs_bmbt_get_startblock(ep))) {
@@ -1296,7 +1296,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	/*
 	 * Here with bp and block set to the leftmost leaf node in the tree.
 	 */
-	room = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	room = xfs_iext_count(ifp);
 	i = 0;
 	/*
 	 * Loop over all leaf nodes.  Copy information to the extent records.
@@ -1361,7 +1361,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 			return error;
 		block = XFS_BUF_TO_BLOCK(bp);
 	}
-	ASSERT(i == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)));
+	ASSERT(i == xfs_iext_count(ifp));
 	ASSERT(i == XFS_IFORK_NEXTENTS(ip, whichfork));
 	XFS_BMAP_TRACE_EXLIST(ip, i, whichfork);
 	return 0;
@@ -1404,7 +1404,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	if (lastx > 0) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx - 1), prevp);
 	}
-	if (lastx < (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
+	if (lastx < xfs_iext_count(ifp)) {
 		xfs_bmbt_get_all(ep, gotp);
 		*eofp = 0;
 	} else {
@@ -1497,7 +1497,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	    (error = xfs_iread_extents(tp, ip, whichfork)))
 		return error;
 	lowest = *first_unused;
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nextents = xfs_iext_count(ifp);
 	for (idx = 0, lastaddr = 0, max = lowest; idx < nextents; idx++) {
 		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, idx);
 		off = xfs_bmbt_get_startoff(ep);
@@ -1582,7 +1582,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 			return error;
 	}
 
-	nextents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
+	nextents = xfs_iext_count(ifp);
 	if (nextents == 0) {
 		*is_empty = 1;
 		return 0;
@@ -1794,7 +1794,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (bma->idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
+	if (bma->idx < xfs_iext_count(ifp) - 1) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx + 1), &RIGHT);
 
@@ -2356,7 +2356,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (*idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
+	if (*idx < xfs_iext_count(&ip->i_df) - 1) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx + 1), &RIGHT);
 		if (isnullstartblock(RIGHT.br_startblock))
@@ -2836,7 +2836,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	 * Check and set flags if the current (right) segment exists.
 	 * If it doesn't exist, we're converting the hole at end-of-file.
 	 */
-	if (*idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+	if (*idx < xfs_iext_count(ifp)) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &right);
 
@@ -2992,7 +2992,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	 * Check and set flags if this segment has a current value.
 	 * Not true if we're inserting into the "hole" at eof.
 	 */
-	if (bma->idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+	if (bma->idx < xfs_iext_count(ifp)) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx), &right);
 		if (isnullstartblock(right.br_startblock))
@@ -4191,7 +4191,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 			break;
 
 		/* Else go on to the next record. */
-		if (++lastx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+		if (++lastx < xfs_iext_count(ifp))
 			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &got);
 		else
 			eof = 1;
@@ -4703,7 +4703,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 
 		/* Else go on to the next record. */
 		bma.prev = bma.got;
-		if (++bma.idx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t)) {
+		if (++bma.idx < xfs_iext_count(ifp)) {
 			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma.idx),
 					 &bma.got);
 		} else
@@ -4876,8 +4876,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 		state |= BMAP_COWFORK;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT((*idx >= 0) && (*idx < ifp->if_bytes /
-		(uint)sizeof(xfs_bmbt_rec_t)));
+	ASSERT((*idx >= 0) && (*idx < xfs_iext_count(ifp)));
 	ASSERT(del->br_blockcount > 0);
 	ep = xfs_iext_get_ext(ifp, *idx);
 	xfs_bmbt_get_all(ep, &got);
@@ -5205,8 +5204,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 			&eidx, &got, &new);
 
 	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK); ifp = ifp;
-	ASSERT((eidx >= 0) && (eidx < ifp->if_bytes /
-		(uint)sizeof(xfs_bmbt_rec_t)));
+	ASSERT((eidx >= 0) && (eidx < xfs_iext_count(ifp)));
 	ASSERT(del->br_blockcount > 0);
 	ASSERT(got.br_startoff <= del->br_startoff);
 	del_endoff = del->br_startoff + del->br_blockcount;
@@ -5371,7 +5369,6 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	int			logflags;	/* transaction logging flags */
 	xfs_extlen_t		mod;		/* rt extent offset */
 	xfs_mount_t		*mp;		/* mount structure */
-	xfs_extnum_t		nextents;	/* number of file extents */
 	xfs_bmbt_irec_t		prev;		/* previous extent record */
 	xfs_fileoff_t		start;		/* first file offset deleted */
 	int			tmp_logflags;	/* partial logging flags */
@@ -5403,8 +5400,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
 	    (error = xfs_iread_extents(tp, ip, whichfork)))
 		return error;
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
-	if (nextents == 0) {
+	if (xfs_iext_count(ifp) == 0) {
 		*rlen = 0;
 		return 0;
 	}
@@ -5889,7 +5885,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
+	total_extents = xfs_iext_count(ifp);
 
 	xfs_bmbt_get_all(gotp, &got);
 
@@ -6066,7 +6062,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	 * are collapsing out, so we cannot use the count of real extents here.
 	 * Instead we have to calculate it from the incore fork.
 	 */
-	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
+	total_extents = xfs_iext_count(ifp);
 	if (total_extents == 0) {
 		*done = 1;
 		goto del_cursor;
@@ -6126,7 +6122,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 		 * count can change. Update the total and grade the next record.
 		 */
 		if (direction == SHIFT_LEFT) {
-			total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
+			total_extents = xfs_iext_count(ifp);
 			stop_extent = total_extents;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 5dd56d3..5fbe24c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -775,6 +775,13 @@
 	}
 }
 
+/* Count number of incore extents based on if_bytes */
+xfs_extnum_t
+xfs_iext_count(struct xfs_ifork *ifp)
+{
+	return ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+}
+
 /*
  * Convert in-core extents to on-disk form
  *
@@ -803,7 +810,7 @@
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(ifp->if_bytes > 0);
 
-	nrecs = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nrecs = xfs_iext_count(ifp);
 	XFS_BMAP_TRACE_EXLIST(ip, nrecs, whichfork);
 	ASSERT(nrecs > 0);
 
@@ -941,7 +948,7 @@
 	xfs_extnum_t	idx)		/* index of target extent */
 {
 	ASSERT(idx >= 0);
-	ASSERT(idx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t));
+	ASSERT(idx < xfs_iext_count(ifp));
 
 	if ((ifp->if_flags & XFS_IFEXTIREC) && (idx == 0)) {
 		return ifp->if_u1.if_ext_irec->er_extbuf;
@@ -1017,7 +1024,7 @@ struct xfs_ifork *
 	int		new_size;	/* size of extents after adding */
 	xfs_extnum_t	nextents;	/* number of extents in file */
 
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nextents = xfs_iext_count(ifp);
 	ASSERT((idx >= 0) && (idx <= nextents));
 	byte_diff = ext_diff * sizeof(xfs_bmbt_rec_t);
 	new_size = ifp->if_bytes + byte_diff;
@@ -1241,7 +1248,7 @@ struct xfs_ifork *
 	trace_xfs_iext_remove(ip, idx, state, _RET_IP_);
 
 	ASSERT(ext_diff > 0);
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nextents = xfs_iext_count(ifp);
 	new_size = (nextents - ext_diff) * sizeof(xfs_bmbt_rec_t);
 
 	if (new_size == 0) {
@@ -1270,7 +1277,7 @@ struct xfs_ifork *
 
 	ASSERT(!(ifp->if_flags & XFS_IFEXTIREC));
 	ASSERT(idx < XFS_INLINE_EXTS);
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nextents = xfs_iext_count(ifp);
 	ASSERT(((nextents - ext_diff) > 0) &&
 		(nextents - ext_diff) < XFS_INLINE_EXTS);
 
@@ -1309,7 +1316,7 @@ struct xfs_ifork *
 	ASSERT(!(ifp->if_flags & XFS_IFEXTIREC));
 	new_size = ifp->if_bytes -
 		(ext_diff * sizeof(xfs_bmbt_rec_t));
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nextents = xfs_iext_count(ifp);
 
 	if (new_size == 0) {
 		xfs_iext_destroy(ifp);
@@ -1546,7 +1553,7 @@ struct xfs_ifork *
 	int		size;		/* size of file extents */
 
 	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nextents = xfs_iext_count(ifp);
 	ASSERT(nextents <= XFS_LINEAR_EXTS);
 	size = nextents * sizeof(xfs_bmbt_rec_t);
 
@@ -1620,7 +1627,7 @@ struct xfs_ifork *
 	xfs_extnum_t	nextents;	/* number of file extents */
 	xfs_fileoff_t	startoff = 0;	/* start offset of extent */
 
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nextents = xfs_iext_count(ifp);
 	if (nextents == 0) {
 		*idxp = 0;
 		return NULL;
@@ -1733,8 +1740,8 @@ struct xfs_ifork *
 
 	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
 	ASSERT(page_idx >= 0);
-	ASSERT(page_idx <= ifp->if_bytes / sizeof(xfs_bmbt_rec_t));
-	ASSERT(page_idx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t) || realloc);
+	ASSERT(page_idx <= xfs_iext_count(ifp));
+	ASSERT(page_idx < xfs_iext_count(ifp) || realloc);
 
 	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
 	erp_idx = 0;
@@ -1782,7 +1789,7 @@ struct xfs_ifork *
 	xfs_extnum_t	nextents;	/* number of extents in file */
 
 	ASSERT(!(ifp->if_flags & XFS_IFEXTIREC));
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nextents = xfs_iext_count(ifp);
 	ASSERT(nextents <= XFS_LINEAR_EXTS);
 
 	erp = kmem_alloc(sizeof(xfs_ext_irec_t), KM_NOFS);
@@ -1906,7 +1913,7 @@ struct xfs_ifork *
 
 	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
 	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nextents = xfs_iext_count(ifp);
 
 	if (nextents == 0) {
 		xfs_iext_destroy(ifp);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index c9476f5..8bf112e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -152,6 +152,7 @@ int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 
 struct xfs_bmbt_rec_host *
 		xfs_iext_get_ext(struct xfs_ifork *, xfs_extnum_t);
+xfs_extnum_t	xfs_iext_count(struct xfs_ifork *);
 void		xfs_iext_insert(struct xfs_inode *, xfs_extnum_t, xfs_extnum_t,
 				struct xfs_bmbt_irec *, int);
 void		xfs_iext_add(struct xfs_ifork *, xfs_extnum_t, int);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 47074e0..35f0bd1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -359,9 +359,7 @@
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if ( XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ) {
-		xfs_bmap_count_leaves(ifp, 0,
-			ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t),
-			count);
+		xfs_bmap_count_leaves(ifp, 0, xfs_iext_count(ifp), count);
 		return 0;
 	}
 
@@ -426,7 +424,7 @@
 		ifp = XFS_IFORK_PTR(ip, whichfork);
 		if (!moretocome &&
 		    xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
-		   (lastx == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))-1))
+		   (lastx == xfs_iext_count(ifp) - 1))
 			out->bmv_oflags |= BMV_OF_LAST;
 	}
 
@@ -1882,7 +1880,7 @@
 		 * pointer.  Otherwise it's already NULL or
 		 * pointing to the extent.
 		 */
-		nextents = ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+		nextents = xfs_iext_count(&ip->i_df);
 		if (nextents <= XFS_INLINE_EXTS) {
 			ifp->if_u1.if_extents =
 				ifp->if_u2.if_inline_ext;
@@ -1902,7 +1900,7 @@
 		 * pointer.  Otherwise it's already NULL or
 		 * pointing to the extent.
 		 */
-		nextents = tip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+		nextents = xfs_iext_count(&tip->i_df);
 		if (nextents <= XFS_INLINE_EXTS) {
 			tifp->if_u1.if_extents =
 				tifp->if_u2.if_inline_ext;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 9610e9c..d90e781 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -164,7 +164,7 @@
 			struct xfs_bmbt_rec *p;
 
 			ASSERT(ip->i_df.if_u1.if_extents != NULL);
-			ASSERT(ip->i_df.if_bytes / sizeof(xfs_bmbt_rec_t) > 0);
+			ASSERT(xfs_iext_count(&ip->i_df) > 0);
 
 			p = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_IEXT);
 			data_bytes = xfs_iextents_copy(ip, p, XFS_DATA_FORK);
@@ -261,7 +261,7 @@
 		    ip->i_afp->if_bytes > 0) {
 			struct xfs_bmbt_rec *p;
 
-			ASSERT(ip->i_afp->if_bytes / sizeof(xfs_bmbt_rec_t) ==
+			ASSERT(xfs_iext_count(ip->i_afp) ==
 				ip->i_d.di_anextents);
 			ASSERT(ip->i_afp->if_u1.if_extents != NULL);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c245bed..a391975 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -910,16 +910,14 @@ struct dentry *
 	if (attr) {
 		if (ip->i_afp) {
 			if (ip->i_afp->if_flags & XFS_IFEXTENTS)
-				fa.fsx_nextents = ip->i_afp->if_bytes /
-							sizeof(xfs_bmbt_rec_t);
+				fa.fsx_nextents = xfs_iext_count(ip->i_afp);
 			else
 				fa.fsx_nextents = ip->i_d.di_anextents;
 		} else
 			fa.fsx_nextents = 0;
 	} else {
 		if (ip->i_df.if_flags & XFS_IFEXTENTS)
-			fa.fsx_nextents = ip->i_df.if_bytes /
-						sizeof(xfs_bmbt_rec_t);
+			fa.fsx_nextents = xfs_iext_count(&ip->i_df);
 		else
 			fa.fsx_nextents = ip->i_d.di_nextents;
 	}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index a60d9e2..45e50ea 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1135,7 +1135,7 @@ struct xfs_qm_isolate {
 			return error;
 	}
 	rtblks = 0;
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
+	nextents = xfs_iext_count(ifp);
 	for (idx = 0; idx < nextents; idx++)
 		rtblks += xfs_bmbt_get_blockcount(xfs_iext_get_ext(ifp, idx));
 	*O_rtblks = (xfs_qcnt_t)rtblks;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5965e94..63c9e82 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -511,7 +511,7 @@
 	/* This is the extent before; try sliding up one. */
 	if (irec.br_startoff < offset_fsb) {
 		idx++;
-		if (idx >= ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+		if (idx >= xfs_iext_count(ifp))
 			return 0;
 		gotp = xfs_iext_get_ext(ifp, idx);
 		xfs_bmbt_get_all(gotp, &irec);
@@ -1679,7 +1679,7 @@
 
 		/* Roll on... */
 		idx++;
-		if (idx >= ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+		if (idx >= xfs_iext_count(ifp))
 			break;
 		gotp = xfs_iext_get_ext(ifp, idx);
 	}


