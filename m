Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D1A2107
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832176; cv=none; b=OGrixa2my0zsGUJeKHfzfMKyIgg+aO1/YOgBF4MWLhWSkxrwsnHJwicmE/KAoFOejtx5KFaPyo61hZm2jGEV6WfLBbdp2G8ELZc7VBQgUw2sPQ5bX2Unmo1XkjrwBzmqY2SHfMhE609wBXh65tBPTl5Y9Y5WxPkT5ymKgRb8gYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832176; c=relaxed/simple;
	bh=PfzU4c3WTTTkMltgvSsEKTI4CZGRz9F6O14Rp5Jv3Z4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p3nRTiRAPlj8kPnLJ54uOPmCjIdak5drpPUCUjbvynJjnLnlGzF8KH/zS8HP3Bc3jumN05PjRV085wduPOb2UHXQuov4s6XYbkje3PW/XlM9eUCP9Qwp0XJZJEof0VgOQKzSCECc9esdWJHDJYylMPOVD+OiRjRRP34HJxNTXUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSOLVT0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSOLVT0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20030C4CEC6;
	Wed,  2 Oct 2024 01:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832176;
	bh=PfzU4c3WTTTkMltgvSsEKTI4CZGRz9F6O14Rp5Jv3Z4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oSOLVT0bMfuTKmiD8pGSfKkhoPZpz9zHYFyBkrmdVG2cUOc+VqSdfQc7wV40vqCar
	 gBQ0kmlTaq47MrXhw6auyHmpXnSzFCt44lyMgTz5k3k5dN5x9BtgatunwDv6CFpIt2
	 gTwiSIRd0Z+5n1Wi2TWqQq5zJE1ZF9rQrzeaACUXk7dOIRuJxlSsyL97HDJqYcTtHr
	 oOiydTGlIikMlNIhIMdhoNw0fFbw0L/mkwqLETtdZvgBFdPRYPAyF+7iqwRwi1jEOu
	 5Qjb9N+F3eDUDU6fDDiqOreWZhCuo7lzIYaCyusHOP582ZAO8aY4EOD/8gbb5jpktu
	 nWDRR11l5aLOw==
Date: Tue, 01 Oct 2024 18:22:55 -0700
Subject: [PATCH 58/64] xfs: Avoid races with cnt_btree lastrec updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Zizhi Wo <wozizhi@huawei.com>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172783102655.4036371.3340351997367697729.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Zizhi Wo <wozizhi@huawei.com>

Source kernel commit: 94a0333b9212a114d19096a77903f76d0d5bca26

A concurrent file creation and little writing could unexpectedly return
-ENOSPC error since there is a race window that the allocator could get
the wrong agf->agf_longest.

Write file process steps:
1) Find the entry that best meets the conditions, then calculate the start
address and length of the remaining part of the entry after allocation.
2) Delete this entry and update the -current- agf->agf_longest.
3) Insert the remaining unused parts of this entry based on the
calculations in 1), and update the agf->agf_longest again if necessary.

Create file process steps:
1) Check whether there are free inodes in the inode chunk.
2) If there is no free inode, check whether there has space for creating
inode chunks, perform the no-lock judgment first.
3) If the judgment succeeds, the judgment is performed again with agf lock
held. Otherwire, an error is returned directly.

If the write process is in step 2) but not go to 3) yet, the create file
process goes to 2) at this time, it may be mistaken for no space,
resulting in the file system still has space but the file creation fails.

We have sent two different commits to the community in order to fix this
problem[1][2]. Unfortunately, both solutions have flaws. In [2], I
discussed with Dave and Darrick, realized that a better solution to this
problem requires the "last cnt record tracking" to be ripped out of the
generic btree code. And surprisingly, Dave directly provided his fix code.
This patch includes appropriate modifications based on his tmp-code to
address this issue.

The entire fix can be roughly divided into two parts:
1) Delete the code related to lastrec-update in the generic btree code.
2) Place the process of updating longest freespace with cntbt separately
to the end of the cntbt modifications. Move the cursor to the rightmost
firstly, and update the longest free extent based on the record.

Note that we can not update the longest with xfs_alloc_get_rec() after
find the longest record, as xfs_verify_agbno() may not pass because
pag->block_count is updated on the outside. Therefore, use
xfs_btree_get_rec() as a replacement.

[1] https://lore.kernel.org/all/20240419061848.1032366-2-yebin10@huawei.com
[2] https://lore.kernel.org/all/20240604071121.3981686-1-wozizhi@huawei.com

Reported by: Ye Bin <yebin10@huawei.com>

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_alloc.c       |  114 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_alloc_btree.c |   64 --------------------------
 libxfs/xfs_btree.c       |   51 ---------------------
 libxfs/xfs_btree.h       |   16 ------
 4 files changed, 115 insertions(+), 130 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 063ac1973..3806a6bc0 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -462,6 +462,97 @@ xfs_alloc_fix_len(
 	args->len = rlen;
 }
 
+/*
+ * Determine if the cursor points to the block that contains the right-most
+ * block of records in the by-count btree. This block contains the largest
+ * contiguous free extent in the AG, so if we modify a record in this block we
+ * need to call xfs_alloc_fixup_longest() once the modifications are done to
+ * ensure the agf->agf_longest field is kept up to date with the longest free
+ * extent tracked by the by-count btree.
+ */
+static bool
+xfs_alloc_cursor_at_lastrec(
+	struct xfs_btree_cur	*cnt_cur)
+{
+	struct xfs_btree_block	*block;
+	union xfs_btree_ptr	ptr;
+	struct xfs_buf		*bp;
+
+	block = xfs_btree_get_block(cnt_cur, 0, &bp);
+
+	xfs_btree_get_sibling(cnt_cur, block, &ptr, XFS_BB_RIGHTSIB);
+	return xfs_btree_ptr_is_null(cnt_cur, &ptr);
+}
+
+/*
+ * Find the rightmost record of the cntbt, and return the longest free space
+ * recorded in it. Simply set both the block number and the length to their
+ * maximum values before searching.
+ */
+static int
+xfs_cntbt_longest(
+	struct xfs_btree_cur	*cnt_cur,
+	xfs_extlen_t		*longest)
+{
+	struct xfs_alloc_rec_incore irec;
+	union xfs_btree_rec	    *rec;
+	int			    stat = 0;
+	int			    error;
+
+	memset(&cnt_cur->bc_rec, 0xFF, sizeof(cnt_cur->bc_rec));
+	error = xfs_btree_lookup(cnt_cur, XFS_LOOKUP_LE, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		/* totally empty tree */
+		*longest = 0;
+		return 0;
+	}
+
+	error = xfs_btree_get_rec(cnt_cur, &rec, &stat);
+	if (error)
+		return error;
+	if (XFS_IS_CORRUPT(cnt_cur->bc_mp, !stat)) {
+		xfs_btree_mark_sick(cnt_cur);
+		return -EFSCORRUPTED;
+	}
+
+	xfs_alloc_btrec_to_irec(rec, &irec);
+	*longest = irec.ar_blockcount;
+	return 0;
+}
+
+/*
+ * Update the longest contiguous free extent in the AG from the by-count cursor
+ * that is passed to us. This should be done at the end of any allocation or
+ * freeing operation that touches the longest extent in the btree.
+ *
+ * Needing to update the longest extent can be determined by calling
+ * xfs_alloc_cursor_at_lastrec() after the cursor is positioned for record
+ * modification but before the modification begins.
+ */
+static int
+xfs_alloc_fixup_longest(
+	struct xfs_btree_cur	*cnt_cur)
+{
+	struct xfs_perag	*pag = cnt_cur->bc_ag.pag;
+	struct xfs_buf		*bp = cnt_cur->bc_ag.agbp;
+	struct xfs_agf		*agf = bp->b_addr;
+	xfs_extlen_t		longest = 0;
+	int			error;
+
+	/* Lookup last rec in order to update AGF. */
+	error = xfs_cntbt_longest(cnt_cur, &longest);
+	if (error)
+		return error;
+
+	pag->pagf_longest = longest;
+	agf->agf_longest = cpu_to_be32(pag->pagf_longest);
+	xfs_alloc_log_agf(cnt_cur->bc_tp, bp, XFS_AGF_LONGEST);
+
+	return 0;
+}
+
 /*
  * Update the two btrees, logically removing from freespace the extent
  * starting at rbno, rlen blocks.  The extent is contained within the
@@ -486,6 +577,7 @@ xfs_alloc_fixup_trees(
 	xfs_extlen_t	nflen1=0;	/* first new free length */
 	xfs_extlen_t	nflen2=0;	/* second new free length */
 	struct xfs_mount *mp;
+	bool		fixup_longest = false;
 
 	mp = cnt_cur->bc_mp;
 
@@ -574,6 +666,10 @@ xfs_alloc_fixup_trees(
 		nfbno2 = rbno + rlen;
 		nflen2 = (fbno + flen) - nfbno2;
 	}
+
+	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
+		fixup_longest = true;
+
 	/*
 	 * Delete the entry from the by-size btree.
 	 */
@@ -651,6 +747,10 @@ xfs_alloc_fixup_trees(
 			return -EFSCORRUPTED;
 		}
 	}
+
+	if (fixup_longest)
+		return xfs_alloc_fixup_longest(cnt_cur);
+
 	return 0;
 }
 
@@ -1953,6 +2053,7 @@ xfs_free_ag_extent(
 	int				i;
 	int				error;
 	struct xfs_perag		*pag = agbp->b_pag;
+	bool				fixup_longest = false;
 
 	bno_cur = cnt_cur = NULL;
 	mp = tp->t_mountp;
@@ -2216,8 +2317,13 @@ xfs_free_ag_extent(
 	}
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
 	bno_cur = NULL;
+
 	/*
 	 * In all cases we need to insert the new freespace in the by-size tree.
+	 *
+	 * If this new freespace is being inserted in the block that contains
+	 * the largest free space in the btree, make sure we also fix up the
+	 * agf->agf-longest tracker field.
 	 */
 	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
 		goto error0;
@@ -2226,6 +2332,8 @@ xfs_free_ag_extent(
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
+	if (xfs_alloc_cursor_at_lastrec(cnt_cur))
+		fixup_longest = true;
 	if ((error = xfs_btree_insert(cnt_cur, &i)))
 		goto error0;
 	if (XFS_IS_CORRUPT(mp, i != 1)) {
@@ -2233,6 +2341,12 @@ xfs_free_ag_extent(
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
+	if (fixup_longest) {
+		error = xfs_alloc_fixup_longest(cnt_cur);
+		if (error)
+			goto error0;
+	}
+
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 	cnt_cur = NULL;
 
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 949eb02cd..9140dec00 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -113,67 +113,6 @@ xfs_allocbt_free_block(
 	return 0;
 }
 
-/*
- * Update the longest extent in the AGF
- */
-STATIC void
-xfs_allocbt_update_lastrec(
-	struct xfs_btree_cur		*cur,
-	const struct xfs_btree_block	*block,
-	const union xfs_btree_rec	*rec,
-	int				ptr,
-	int				reason)
-{
-	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
-	struct xfs_perag	*pag;
-	__be32			len;
-	int			numrecs;
-
-	ASSERT(!xfs_btree_is_bno(cur->bc_ops));
-
-	switch (reason) {
-	case LASTREC_UPDATE:
-		/*
-		 * If this is the last leaf block and it's the last record,
-		 * then update the size of the longest extent in the AG.
-		 */
-		if (ptr != xfs_btree_get_numrecs(block))
-			return;
-		len = rec->alloc.ar_blockcount;
-		break;
-	case LASTREC_INSREC:
-		if (be32_to_cpu(rec->alloc.ar_blockcount) <=
-		    be32_to_cpu(agf->agf_longest))
-			return;
-		len = rec->alloc.ar_blockcount;
-		break;
-	case LASTREC_DELREC:
-		numrecs = xfs_btree_get_numrecs(block);
-		if (ptr <= numrecs)
-			return;
-		ASSERT(ptr == numrecs + 1);
-
-		if (numrecs) {
-			xfs_alloc_rec_t *rrp;
-
-			rrp = XFS_ALLOC_REC_ADDR(cur->bc_mp, block, numrecs);
-			len = rrp->ar_blockcount;
-		} else {
-			len = 0;
-		}
-
-		break;
-	default:
-		ASSERT(0);
-		return;
-	}
-
-	agf->agf_longest = len;
-	pag = cur->bc_ag.agbp->b_pag;
-	pag->pagf_longest = be32_to_cpu(len);
-	xfs_alloc_log_agf(cur->bc_tp, cur->bc_ag.agbp, XFS_AGF_LONGEST);
-}
-
 STATIC int
 xfs_allocbt_get_minrecs(
 	struct xfs_btree_cur	*cur,
@@ -491,7 +430,6 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.free_block		= xfs_allocbt_free_block,
-	.update_lastrec		= xfs_allocbt_update_lastrec,
 	.get_minrecs		= xfs_allocbt_get_minrecs,
 	.get_maxrecs		= xfs_allocbt_get_maxrecs,
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
@@ -509,7 +447,6 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 const struct xfs_btree_ops xfs_cntbt_ops = {
 	.name			= "cnt",
 	.type			= XFS_BTREE_TYPE_AG,
-	.geom_flags		= XFS_BTGEO_LASTREC_UPDATE,
 
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
@@ -523,7 +460,6 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
 	.free_block		= xfs_allocbt_free_block,
-	.update_lastrec		= xfs_allocbt_update_lastrec,
 	.get_minrecs		= xfs_allocbt_get_minrecs,
 	.get_maxrecs		= xfs_allocbt_get_maxrecs,
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a91441b46..bb53b6d7a 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1329,30 +1329,6 @@ xfs_btree_init_block_cur(
 			xfs_btree_owner(cur));
 }
 
-/*
- * Return true if ptr is the last record in the btree and
- * we need to track updates to this record.  The decision
- * will be further refined in the update_lastrec method.
- */
-STATIC int
-xfs_btree_is_lastrec(
-	struct xfs_btree_cur	*cur,
-	struct xfs_btree_block	*block,
-	int			level)
-{
-	union xfs_btree_ptr	ptr;
-
-	if (level > 0)
-		return 0;
-	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_LASTREC_UPDATE))
-		return 0;
-
-	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
-	if (!xfs_btree_ptr_is_null(cur, &ptr))
-		return 0;
-	return 1;
-}
-
 STATIC void
 xfs_btree_buf_to_ptr(
 	struct xfs_btree_cur	*cur,
@@ -2418,15 +2394,6 @@ xfs_btree_update(
 	xfs_btree_copy_recs(cur, rp, rec, 1);
 	xfs_btree_log_recs(cur, bp, ptr, ptr);
 
-	/*
-	 * If we are tracking the last record in the tree and
-	 * we are at the far right edge of the tree, update it.
-	 */
-	if (xfs_btree_is_lastrec(cur, block, 0)) {
-		cur->bc_ops->update_lastrec(cur, block, rec,
-					    ptr, LASTREC_UPDATE);
-	}
-
 	/* Pass new key value up to our parent. */
 	if (xfs_btree_needs_key_update(cur, ptr)) {
 		error = xfs_btree_update_keys(cur, 0);
@@ -3615,15 +3582,6 @@ xfs_btree_insrec(
 			goto error0;
 	}
 
-	/*
-	 * If we are tracking the last record in the tree and
-	 * we are at the far right edge of the tree, update it.
-	 */
-	if (xfs_btree_is_lastrec(cur, block, level)) {
-		cur->bc_ops->update_lastrec(cur, block, rec,
-					    ptr, LASTREC_INSREC);
-	}
-
 	/*
 	 * Return the new block number, if any.
 	 * If there is one, give back a record value and a cursor too.
@@ -3981,15 +3939,6 @@ xfs_btree_delrec(
 	xfs_btree_set_numrecs(block, --numrecs);
 	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
 
-	/*
-	 * If we are tracking the last record in the tree and
-	 * we are at the far right edge of the tree, update it.
-	 */
-	if (xfs_btree_is_lastrec(cur, block, level)) {
-		cur->bc_ops->update_lastrec(cur, block, NULL,
-					    ptr, LASTREC_DELREC);
-	}
-
 	/*
 	 * We're at the root level.  First, shrink the root block in-memory.
 	 * Try to get rid of the next level down.  If we can't then there's
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index f93374278..10b7ddc3b 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -154,12 +154,6 @@ struct xfs_btree_ops {
 			       int *stat);
 	int	(*free_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp);
 
-	/* update last record information */
-	void	(*update_lastrec)(struct xfs_btree_cur *cur,
-				  const struct xfs_btree_block *block,
-				  const union xfs_btree_rec *rec,
-				  int ptr, int reason);
-
 	/* records in block/level */
 	int	(*get_minrecs)(struct xfs_btree_cur *cur, int level);
 	int	(*get_maxrecs)(struct xfs_btree_cur *cur, int level);
@@ -222,15 +216,7 @@ struct xfs_btree_ops {
 };
 
 /* btree geometry flags */
-#define XFS_BTGEO_LASTREC_UPDATE	(1U << 0) /* track last rec externally */
-#define XFS_BTGEO_OVERLAPPING		(1U << 1) /* overlapping intervals */
-
-/*
- * Reasons for the update_lastrec method to be called.
- */
-#define LASTREC_UPDATE	0
-#define LASTREC_INSREC	1
-#define LASTREC_DELREC	2
+#define XFS_BTGEO_OVERLAPPING		(1U << 0) /* overlapping intervals */
 
 
 union xfs_btree_irec {

