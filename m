Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B128EC43600
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 735AF61077
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbhEFHWF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 03:22:05 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:51128 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233389AbhEFHWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 03:22:01 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 4A9C9108862
        for <linux-xfs@vger.kernel.org>; Thu,  6 May 2021 17:20:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-005loi-R6
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-001982-J4
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 22/22] xfs: use perag through unlink processing
Date:   Thu,  6 May 2021 17:20:54 +1000
Message-Id: <20210506072054.271157-23-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210506072054.271157-1-david@fromorbit.com>
References: <20210506072054.271157-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=FVwgZaIRJyQcPvafxqcA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Unlinked lists are held in the perag, and freeing of inodes needs to
be passed a perag, too, so look up the perag early in the unlink
processing and use it throughout.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |  23 +++----
 fs/xfs/libxfs/xfs_ialloc.h |  13 +---
 fs/xfs/xfs_inode.c         | 131 +++++++++++++++++++++----------------
 3 files changed, 87 insertions(+), 80 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 340bb95d7bc1..be84820588c6 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2133,35 +2133,33 @@ xfs_difree_finobt(
  */
 int
 xfs_difree(
-	struct xfs_trans	*tp,		/* transaction pointer */
-	xfs_ino_t		inode,		/* inode to be freed */
-	struct xfs_icluster	*xic)	/* cluster info if deleted */
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	xfs_ino_t		inode,
+	struct xfs_icluster	*xic)
 {
 	/* REFERENCED */
 	xfs_agblock_t		agbno;	/* block number containing inode */
 	struct xfs_buf		*agbp;	/* buffer for allocation group header */
 	xfs_agino_t		agino;	/* allocation group inode number */
-	xfs_agnumber_t		agno;	/* allocation group number */
 	int			error;	/* error return value */
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_inobt_rec_incore rec;/* btree record */
-	struct xfs_perag	*pag;
 
 	/*
 	 * Break up inode number into its components.
 	 */
-	agno = XFS_INO_TO_AGNO(mp, inode);
-	if (agno >= mp->m_sb.sb_agcount) {
-		xfs_warn(mp, "%s: agno >= mp->m_sb.sb_agcount (%d >= %d).",
-			__func__, agno, mp->m_sb.sb_agcount);
+	if (pag->pag_agno != XFS_INO_TO_AGNO(mp, inode)) {
+		xfs_warn(mp, "%s: agno != pag->pag_agno (%d != %d).",
+			__func__, XFS_INO_TO_AGNO(mp, inode), pag->pag_agno);
 		ASSERT(0);
 		return -EINVAL;
 	}
 	agino = XFS_INO_TO_AGINO(mp, inode);
-	if (inode != XFS_AGINO_TO_INO(mp, agno, agino))  {
+	if (inode != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino))  {
 		xfs_warn(mp, "%s: inode != XFS_AGINO_TO_INO() (%llu != %llu).",
 			__func__, (unsigned long long)inode,
-			(unsigned long long)XFS_AGINO_TO_INO(mp, agno, agino));
+			(unsigned long long)XFS_AGINO_TO_INO(mp, pag->pag_agno, agino));
 		ASSERT(0);
 		return -EINVAL;
 	}
@@ -2175,7 +2173,7 @@ xfs_difree(
 	/*
 	 * Get the allocation group header.
 	 */
-	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, &agbp);
 	if (error) {
 		xfs_warn(mp, "%s: xfs_ialloc_read_agi() returned error %d.",
 			__func__, error);
@@ -2185,7 +2183,6 @@ xfs_difree(
 	/*
 	 * Fix up the inode allocation btree.
 	 */
-	pag = agbp->b_pag;
 	error = xfs_difree_inobt(mp, tp, agbp, pag, agino, xic, &rec);
 	if (error)
 		goto error0;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 886f6748fb22..9df7c80408ff 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -39,17 +39,8 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 int xfs_dialloc(struct xfs_trans **tpp, xfs_ino_t parent, umode_t mode,
 		xfs_ino_t *new_ino);
 
-/*
- * Free disk inode.  Carefully avoids touching the incore inode, all
- * manipulations incore are the caller's responsibility.
- * The on-disk inode is not changed by this operation, only the
- * btree (free inode mask) is changed.
- */
-int					/* error */
-xfs_difree(
-	struct xfs_trans *tp,		/* transaction pointer */
-	xfs_ino_t	inode,		/* inode to be freed */
-	struct xfs_icluster *ifree);	/* cluster info if deleted */
+int xfs_difree(struct xfs_trans *tp, struct xfs_perag *pag,
+		xfs_ino_t ino, struct xfs_icluster *ifree);
 
 /*
  * Return the location of the inode in imap, for mapping it into a buffer.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 26668b6846e2..aad98a982382 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -45,7 +45,8 @@ kmem_zone_t *xfs_inode_zone;
 #define	XFS_ITRUNC_MAX_EXTENTS	2
 
 STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
-STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
+STATIC int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
+	struct xfs_inode *);
 
 /*
  * helper function to extract extent size hint from inode
@@ -1241,7 +1242,11 @@ xfs_link(
 	 * Handle initial link state of O_TMPFILE inode
 	 */
 	if (VFS_I(sip)->i_nlink == 0) {
-		error = xfs_iunlink_remove(tp, sip);
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, sip->i_ino));
+		error = xfs_iunlink_remove(tp, pag, sip);
+		xfs_perag_put(pag);
 		if (error)
 			goto error_return;
 	}
@@ -1934,7 +1939,7 @@ xfs_iunlink_destroy(
 STATIC int
 xfs_iunlink_update_bucket(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	struct xfs_buf		*agibp,
 	unsigned int		bucket_index,
 	xfs_agino_t		new_agino)
@@ -1943,10 +1948,10 @@ xfs_iunlink_update_bucket(
 	xfs_agino_t		old_value;
 	int			offset;
 
-	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, agno, new_agino));
+	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, pag->pag_agno, new_agino));
 
 	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	trace_xfs_iunlink_update_bucket(tp->t_mountp, agno, bucket_index,
+	trace_xfs_iunlink_update_bucket(tp->t_mountp, pag->pag_agno, bucket_index,
 			old_value, new_agino);
 
 	/*
@@ -1970,7 +1975,7 @@ xfs_iunlink_update_bucket(
 STATIC void
 xfs_iunlink_update_dinode(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_agino_t		agino,
 	struct xfs_buf		*ibp,
 	struct xfs_dinode	*dip,
@@ -1980,9 +1985,9 @@ xfs_iunlink_update_dinode(
 	struct xfs_mount	*mp = tp->t_mountp;
 	int			offset;
 
-	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
+	ASSERT(xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino));
 
-	trace_xfs_iunlink_update_dinode(mp, agno, agino,
+	trace_xfs_iunlink_update_dinode(mp, pag->pag_agno, agino,
 			be32_to_cpu(dip->di_next_unlinked), next_agino);
 
 	dip->di_next_unlinked = cpu_to_be32(next_agino);
@@ -2000,7 +2005,7 @@ STATIC int
 xfs_iunlink_update_inode(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_agino_t		next_agino,
 	xfs_agino_t		*old_next_agino)
 {
@@ -2010,7 +2015,7 @@ xfs_iunlink_update_inode(
 	xfs_agino_t		old_value;
 	int			error;
 
-	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
+	ASSERT(xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino));
 
 	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
 	if (error)
@@ -2019,7 +2024,7 @@ xfs_iunlink_update_inode(
 
 	/* Make sure the old pointer isn't garbage. */
 	old_value = be32_to_cpu(dip->di_next_unlinked);
-	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
+	if (!xfs_verify_agino_or_null(mp, pag->pag_agno, old_value)) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
 				sizeof(*dip), __this_address);
 		error = -EFSCORRUPTED;
@@ -2042,7 +2047,7 @@ xfs_iunlink_update_inode(
 	}
 
 	/* Ok, update the new pointer. */
-	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
+	xfs_iunlink_update_dinode(tp, pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
 			ibp, dip, &ip->i_imap, next_agino);
 	return 0;
 out:
@@ -2063,10 +2068,10 @@ xfs_iunlink(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_perag	*pag;
 	struct xfs_agi		*agi;
 	struct xfs_buf		*agibp;
 	xfs_agino_t		next_agino;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
@@ -2075,10 +2080,12 @@ xfs_iunlink(
 	ASSERT(VFS_I(ip)->i_mode != 0);
 	trace_xfs_iunlink(ip);
 
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
+	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
 	if (error)
-		return error;
+		goto out;
 	agi = agibp->b_addr;
 
 	/*
@@ -2088,9 +2095,10 @@ xfs_iunlink(
 	 */
 	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	if (next_agino == agino ||
-	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
+	    !xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino)) {
 		xfs_buf_mark_corrupt(agibp);
-		return -EFSCORRUPTED;
+		error = -EFSCORRUPTED;
+		goto out;
 	}
 
 	if (next_agino != NULLAGINO) {
@@ -2100,23 +2108,26 @@ xfs_iunlink(
 		 * There is already another inode in the bucket, so point this
 		 * inode to the current head of the list.
 		 */
-		error = xfs_iunlink_update_inode(tp, ip, agno, next_agino,
+		error = xfs_iunlink_update_inode(tp, ip, pag, next_agino,
 				&old_agino);
 		if (error)
-			return error;
+			goto out;
 		ASSERT(old_agino == NULLAGINO);
 
 		/*
 		 * agino has been unlinked, add a backref from the next inode
 		 * back to agino.
 		 */
-		error = xfs_iunlink_add_backref(agibp->b_pag, agino, next_agino);
+		error = xfs_iunlink_add_backref(pag, agino, next_agino);
 		if (error)
-			return error;
+			goto out;
 	}
 
 	/* Point the head of the list to point to this inode. */
-	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
+	error = xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
+out:
+	xfs_perag_put(pag);
+	return error;
 }
 
 /* Return the imap, dinode pointer, and buffer for an inode. */
@@ -2164,14 +2175,13 @@ xfs_iunlink_map_ino(
 STATIC int
 xfs_iunlink_map_prev(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_agino_t		head_agino,
 	xfs_agino_t		target_agino,
 	xfs_agino_t		*agino,
 	struct xfs_imap		*imap,
 	struct xfs_dinode	**dipp,
-	struct xfs_buf		**bpp,
-	struct xfs_perag	*pag)
+	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	xfs_agino_t		next_agino;
@@ -2183,7 +2193,8 @@ xfs_iunlink_map_prev(
 	/* See if our backref cache can find it faster. */
 	*agino = xfs_iunlink_lookup_backref(pag, target_agino);
 	if (*agino != NULLAGINO) {
-		error = xfs_iunlink_map_ino(tp, agno, *agino, imap, dipp, bpp);
+		error = xfs_iunlink_map_ino(tp, pag->pag_agno, *agino, imap,
+				dipp, bpp);
 		if (error)
 			return error;
 
@@ -2199,7 +2210,7 @@ xfs_iunlink_map_prev(
 		WARN_ON_ONCE(1);
 	}
 
-	trace_xfs_iunlink_map_prev_fallback(mp, agno);
+	trace_xfs_iunlink_map_prev_fallback(mp, pag->pag_agno);
 
 	/* Otherwise, walk the entire bucket until we find it. */
 	next_agino = head_agino;
@@ -2210,8 +2221,8 @@ xfs_iunlink_map_prev(
 			xfs_trans_brelse(tp, *bpp);
 
 		*agino = next_agino;
-		error = xfs_iunlink_map_ino(tp, agno, next_agino, imap, dipp,
-				bpp);
+		error = xfs_iunlink_map_ino(tp, pag->pag_agno, next_agino, imap,
+				dipp, bpp);
 		if (error)
 			return error;
 
@@ -2220,7 +2231,7 @@ xfs_iunlink_map_prev(
 		 * Make sure this pointer is valid and isn't an obvious
 		 * infinite loop.
 		 */
-		if (!xfs_verify_agino(mp, agno, unlinked_agino) ||
+		if (!xfs_verify_agino(mp, pag->pag_agno, unlinked_agino) ||
 		    next_agino == unlinked_agino) {
 			XFS_CORRUPTION_ERROR(__func__,
 					XFS_ERRLEVEL_LOW, mp,
@@ -2240,6 +2251,7 @@ xfs_iunlink_map_prev(
 STATIC int
 xfs_iunlink_remove(
 	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
@@ -2247,7 +2259,6 @@ xfs_iunlink_remove(
 	struct xfs_buf		*agibp;
 	struct xfs_buf		*last_ibp;
 	struct xfs_dinode	*last_dip = NULL;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
 	xfs_agino_t		head_agino;
@@ -2257,7 +2268,7 @@ xfs_iunlink_remove(
 	trace_xfs_iunlink_remove(ip);
 
 	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
+	error = xfs_read_agi(mp, tp, pag->pag_agno, &agibp);
 	if (error)
 		return error;
 	agi = agibp->b_addr;
@@ -2267,7 +2278,7 @@ xfs_iunlink_remove(
 	 * go on.  Make sure the head pointer isn't garbage.
 	 */
 	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	if (!xfs_verify_agino(mp, agno, head_agino)) {
+	if (!xfs_verify_agino(mp, pag->pag_agno, head_agino)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				agi, sizeof(*agi));
 		return -EFSCORRUPTED;
@@ -2278,7 +2289,7 @@ xfs_iunlink_remove(
 	 * the old pointer value so that we can update whatever was previous
 	 * to us in the list to point to whatever was next in the list.
 	 */
-	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO, &next_agino);
+	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO, &next_agino);
 	if (error)
 		return error;
 
@@ -2290,8 +2301,7 @@ xfs_iunlink_remove(
 	 * this inode's backref to point from the next inode.
 	 */
 	if (next_agino != NULLAGINO) {
-		error = xfs_iunlink_change_backref(agibp->b_pag, next_agino,
-				NULLAGINO);
+		error = xfs_iunlink_change_backref(pag, next_agino, NULLAGINO);
 		if (error)
 			return error;
 	}
@@ -2301,14 +2311,13 @@ xfs_iunlink_remove(
 		xfs_agino_t	prev_agino;
 
 		/* We need to search the list for the inode being freed. */
-		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
-				&prev_agino, &imap, &last_dip, &last_ibp,
-				agibp->b_pag);
+		error = xfs_iunlink_map_prev(tp, pag, head_agino, agino,
+				&prev_agino, &imap, &last_dip, &last_ibp);
 		if (error)
 			return error;
 
 		/* Point the previous inode on the list to the next inode. */
-		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
+		xfs_iunlink_update_dinode(tp, pag, prev_agino, last_ibp,
 				last_dip, &imap, next_agino);
 
 		/*
@@ -2324,7 +2333,7 @@ xfs_iunlink_remove(
 	}
 
 	/* Point the head of the list to the next unlinked inode. */
-	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
+	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index,
 			next_agino);
 }
 
@@ -2335,12 +2344,11 @@ xfs_iunlink_remove(
  */
 static void
 xfs_ifree_mark_inode_stale(
-	struct xfs_buf		*bp,
+	struct xfs_perag	*pag,
 	struct xfs_inode	*free_ip,
 	xfs_ino_t		inum)
 {
-	struct xfs_mount	*mp = bp->b_mount;
-	struct xfs_perag	*pag = bp->b_pag;
+	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_inode_log_item *iip;
 	struct xfs_inode	*ip;
 
@@ -2430,10 +2438,11 @@ xfs_ifree_mark_inode_stale(
  * inodes that are in memory - they all must be marked stale and attached to
  * the cluster buffer.
  */
-STATIC int
+static int
 xfs_ifree_cluster(
-	struct xfs_inode	*free_ip,
 	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*free_ip,
 	struct xfs_icluster	*xic)
 {
 	struct xfs_mount	*mp = free_ip->i_mount;
@@ -2495,7 +2504,7 @@ xfs_ifree_cluster(
 		 * already marked XFS_ISTALE.
 		 */
 		for (i = 0; i < igeo->inodes_per_cluster; i++)
-			xfs_ifree_mark_inode_stale(bp, free_ip, inum + i);
+			xfs_ifree_mark_inode_stale(pag, free_ip, inum + i);
 
 		xfs_trans_stale_inode_buf(tp, bp);
 		xfs_trans_binval(tp, bp);
@@ -2518,9 +2527,11 @@ xfs_ifree(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip)
 {
-	int			error;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
 	struct xfs_icluster	xic = { 0 };
 	struct xfs_inode_log_item *iip = ip->i_itemp;
+	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(VFS_I(ip)->i_nlink == 0);
@@ -2528,16 +2539,18 @@ xfs_ifree(
 	ASSERT(ip->i_disk_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
 	ASSERT(ip->i_nblocks == 0);
 
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
 	/*
 	 * Pull the on-disk inode from the AGI unlinked list.
 	 */
-	error = xfs_iunlink_remove(tp, ip);
+	error = xfs_iunlink_remove(tp, pag, ip);
 	if (error)
-		return error;
+		goto out;
 
-	error = xfs_difree(tp, ip->i_ino, &xic);
+	error = xfs_difree(tp, pag, ip->i_ino, &xic);
 	if (error)
-		return error;
+		goto out;
 
 	/*
 	 * Free any local-format data sitting around before we reset the
@@ -2552,7 +2565,7 @@ xfs_ifree(
 
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
 	ip->i_diflags = 0;
-	ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
+	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
 	ip->i_forkoff = 0;		/* mark the attr fork not in use */
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 	if (xfs_iflags_test(ip, XFS_IPRESERVE_DM_FIELDS))
@@ -2571,8 +2584,9 @@ xfs_ifree(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (xic.deleted)
-		error = xfs_ifree_cluster(ip, tp, &xic);
-
+		error = xfs_ifree_cluster(tp, pag, ip, &xic);
+out:
+	xfs_perag_put(pag);
 	return error;
 }
 
@@ -3176,8 +3190,13 @@ xfs_rename(
 	 * in future.
 	 */
 	if (wip) {
+		struct xfs_perag	*pag;
+
 		ASSERT(VFS_I(wip)->i_nlink == 0);
-		error = xfs_iunlink_remove(tp, wip);
+
+		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, wip->i_ino));
+		error = xfs_iunlink_remove(tp, pag, wip);
+		xfs_perag_put(pag);
 		if (error)
 			goto out_trans_cancel;
 
-- 
2.31.1

