Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E17120100C
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191236; cv=none; b=lVhx+zLyWqqvbFh9Wff6R3fVbM+XzVPltP52RGZeASEUjySlyHapCg/gy4ADKUDXE1grspfFIeF2rmWIciECOky5lmdxzhXsu/u5xnEQ3pMVDymwn9AU/XfSoGaQUuWhFYVfLXq5b7E4JYZQRZ0Q6IUY262d87/O3T5PuvVgJTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191236; c=relaxed/simple;
	bh=xYqLe/sSkIJ3roKNq7zFH7Re3vWqhKbhsn6EzLYIo64=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qU77wo4ZhOu7YgarbYXh8LNvQVgp1dgEXbBQr7SN8cLCm/4byjzztRkTY1NvY6CXchIod8QEDboFpnuCeutQExfM93CrOWBw1YyBLHuYNlbzqTfHJZSHxvmDmLShmPpIfZaLS2eCtJEUroBtpsosvHPG0PETc0BQlHOXo4DZcbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WhpI6svR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhpI6svR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A07C4CECD;
	Thu, 17 Oct 2024 18:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191236;
	bh=xYqLe/sSkIJ3roKNq7zFH7Re3vWqhKbhsn6EzLYIo64=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WhpI6svRNXk1mknbiKWidT25UGCm1WeNqeWznWFgvJqlI/JCrNkbiQ+vAoFWFfGPJ
	 AR3A8OJUEHzUk2WcsaIVE2Pb2QplA7pP3PL0bCWZlo+tyhRze2qBrNVoNEM9vct4mS
	 NIi3HC61enq5HUV8RM4P15hsyLQ1lLnPGoMGdk0euWux9EYE+HMYC8pojDdbeoZIsk
	 RHimGgRkCvv2jO63A/Xrayf9tvC3tbU8eWTtouAury0IAX3auDbYh/Gb5CfjF80D+T
	 WYBH+th2tkleAtwrpMiS6U7/QbCsOQGcHNn+XEB7oENFX2dXWbm/17/1jQanhNBofw
	 oyy70urVwM3lQ==
Date: Thu, 17 Oct 2024 11:53:55 -0700
Subject: [PATCH 12/16] xfs: add a generic group pointer to the btree cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068884.3450737.11055093651508256448.stgit@frogsfrogsfrogs>
In-Reply-To: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
References: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Replace the pag pointers in the type specific union with a generic
xfs_group pointer.  This prepares for adding realtime group support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c          |    8 ++++----
 fs/xfs/libxfs/xfs_alloc_btree.c    |   28 ++++++++++++++--------------
 fs/xfs/libxfs/xfs_btree.c          |   35 ++++++++++++-----------------------
 fs/xfs/libxfs/xfs_btree.h          |    3 +--
 fs/xfs/libxfs/xfs_btree_mem.c      |    6 ++----
 fs/xfs/libxfs/xfs_ialloc.c         |   12 +++++++-----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   15 ++++++++-------
 fs/xfs/libxfs/xfs_refcount.c       |   17 +++++++++--------
 fs/xfs/libxfs/xfs_refcount_btree.c |   10 +++++-----
 fs/xfs/libxfs/xfs_rmap.c           |    8 +++-----
 fs/xfs/libxfs/xfs_rmap_btree.c     |   19 ++++++++++---------
 fs/xfs/scrub/alloc.c               |    2 +-
 fs/xfs/scrub/bmap.c                |    3 ++-
 fs/xfs/scrub/bmap_repair.c         |    4 ++--
 fs/xfs/scrub/cow_repair.c          |    9 ++++++---
 fs/xfs/scrub/health.c              |    2 +-
 fs/xfs/scrub/ialloc.c              |   14 +++++++-------
 fs/xfs/scrub/refcount.c            |    3 ++-
 fs/xfs/scrub/rmap.c                |    2 +-
 fs/xfs/scrub/rmap_repair.c         |    2 +-
 fs/xfs/xfs_fsmap.c                 |    6 ++++--
 fs/xfs/xfs_health.c                |   23 ++++++-----------------
 fs/xfs/xfs_trace.h                 |   28 ++++++++++++++--------------
 23 files changed, 122 insertions(+), 137 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9359814339a5b3..67892665a20452 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -275,7 +275,7 @@ xfs_alloc_complain_bad_rec(
 
 	xfs_warn(mp,
 		"%sbt record corruption in AG %d detected at %pS!",
-		cur->bc_ops->name, pag_agno(cur->bc_ag.pag), fa);
+		cur->bc_ops->name, cur->bc_group->xg_gno, fa);
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", irec->ar_startblock,
 		irec->ar_blockcount);
@@ -303,7 +303,7 @@ xfs_alloc_get_rec(
 		return error;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
-	fa = xfs_alloc_check_irec(cur->bc_ag.pag, &irec);
+	fa = xfs_alloc_check_irec(to_perag(cur->bc_group), &irec);
 	if (fa)
 		return xfs_alloc_complain_bad_rec(cur, fa, &irec);
 
@@ -540,7 +540,7 @@ static int
 xfs_alloc_fixup_longest(
 	struct xfs_btree_cur	*cnt_cur)
 {
-	struct xfs_perag	*pag = cnt_cur->bc_ag.pag;
+	struct xfs_perag	*pag = to_perag(cnt_cur->bc_group);
 	struct xfs_buf		*bp = cnt_cur->bc_ag.agbp;
 	struct xfs_agf		*agf = bp->b_addr;
 	xfs_extlen_t		longest = 0;
@@ -4044,7 +4044,7 @@ xfs_alloc_query_range_helper(
 	xfs_failaddr_t				fa;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
-	fa = xfs_alloc_check_irec(cur->bc_ag.pag, &irec);
+	fa = xfs_alloc_check_irec(to_perag(cur->bc_group), &irec);
 	if (fa)
 		return xfs_alloc_complain_bad_rec(cur, fa, &irec);
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index e69a1bb13f7f86..a4ac37ba5d510e 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -28,7 +28,7 @@ xfs_bnobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_bnobt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ag.agbp,
-			cur->bc_ag.pag);
+			to_perag(cur->bc_group));
 }
 
 STATIC struct xfs_btree_cur *
@@ -36,29 +36,29 @@ xfs_cntbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_cntbt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ag.agbp,
-			cur->bc_ag.pag);
+			to_perag(cur->bc_group));
 }
 
-
 STATIC void
 xfs_allocbt_set_root(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_ptr	*ptr,
 	int				inc)
 {
-	struct xfs_buf		*agbp = cur->bc_ag.agbp;
-	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_perag		*pag = to_perag(cur->bc_group);
+	struct xfs_buf			*agbp = cur->bc_ag.agbp;
+	struct xfs_agf			*agf = agbp->b_addr;
 
 	ASSERT(ptr->s != 0);
 
 	if (xfs_btree_is_bno(cur->bc_ops)) {
 		agf->agf_bno_root = ptr->s;
 		be32_add_cpu(&agf->agf_bno_level, inc);
-		cur->bc_ag.pag->pagf_bno_level += inc;
+		pag->pagf_bno_level += inc;
 	} else {
 		agf->agf_cnt_root = ptr->s;
 		be32_add_cpu(&agf->agf_cnt_level, inc);
-		cur->bc_ag.pag->pagf_cnt_level += inc;
+		pag->pagf_cnt_level += inc;
 	}
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
@@ -75,7 +75,7 @@ xfs_allocbt_alloc_block(
 	xfs_agblock_t		bno;
 
 	/* Allocate the new block from the freelist. If we can't, give up.  */
-	error = xfs_alloc_get_freelist(cur->bc_ag.pag, cur->bc_tp,
+	error = xfs_alloc_get_freelist(to_perag(cur->bc_group), cur->bc_tp,
 			cur->bc_ag.agbp, &bno, 1);
 	if (error)
 		return error;
@@ -86,7 +86,7 @@ xfs_allocbt_alloc_block(
 	}
 
 	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_reuse(pag_group(cur->bc_ag.pag), bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_group, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 
@@ -104,8 +104,8 @@ xfs_allocbt_free_block(
 	int			error;
 
 	bno = xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp));
-	error = xfs_alloc_put_freelist(cur->bc_ag.pag, cur->bc_tp, agbp, NULL,
-			bno, 1);
+	error = xfs_alloc_put_freelist(to_perag(cur->bc_group), cur->bc_tp,
+			agbp, NULL, bno, 1);
 	if (error)
 		return error;
 
@@ -178,7 +178,7 @@ xfs_allocbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agf->agf_seqno));
 
 	if (xfs_btree_is_bno(cur->bc_ops))
 		ptr->s = agf->agf_bno_root;
@@ -492,7 +492,7 @@ xfs_bnobt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_bnobt_ops,
 			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agf		*agf = agbp->b_addr;
@@ -518,7 +518,7 @@ xfs_cntbt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_cntbt_ops,
 			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agf		*agf = agbp->b_addr;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 9a13dbf5f54a33..2b5fc5fd16435d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -225,7 +225,7 @@ __xfs_btree_check_agblock(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_perag	*pag = cur->bc_ag.pag;
+	struct xfs_perag	*pag = to_perag(cur->bc_group);
 	xfs_failaddr_t		fa;
 	xfs_agblock_t		agbno;
 
@@ -331,7 +331,7 @@ __xfs_btree_check_ptr(
 			return -EFSCORRUPTED;
 		break;
 	case XFS_BTREE_TYPE_AG:
-		if (!xfs_verify_agbno(cur->bc_ag.pag,
+		if (!xfs_verify_agbno(to_perag(cur->bc_group),
 				be32_to_cpu((&ptr->s)[index])))
 			return -EFSCORRUPTED;
 		break;
@@ -372,7 +372,7 @@ xfs_btree_check_ptr(
 		case XFS_BTREE_TYPE_AG:
 			xfs_err(cur->bc_mp,
 "AG %u: Corrupt %sbt pointer at level %d index %d.",
-				pag_agno(cur->bc_ag.pag), cur->bc_ops->name,
+				cur->bc_group->xg_gno, cur->bc_ops->name,
 				level, index);
 			break;
 		}
@@ -523,20 +523,8 @@ xfs_btree_del_cursor(
 	ASSERT(!xfs_btree_is_bmap(cur->bc_ops) || cur->bc_bmap.allocated == 0 ||
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 
-	switch (cur->bc_ops->type) {
-	case XFS_BTREE_TYPE_AG:
-		if (cur->bc_ag.pag)
-			xfs_perag_put(cur->bc_ag.pag);
-		break;
-	case XFS_BTREE_TYPE_INODE:
-		/* nothing to do */
-		break;
-	case XFS_BTREE_TYPE_MEM:
-		if (cur->bc_mem.pag)
-			xfs_perag_put(cur->bc_mem.pag);
-		break;
-	}
-
+	if (cur->bc_group)
+		xfs_group_put(cur->bc_group);
 	kmem_cache_free(cur->bc_cache, cur);
 }
 
@@ -1017,21 +1005,22 @@ xfs_btree_readahead_agblock(
 	struct xfs_btree_block	*block)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_perag	*pag = to_perag(cur->bc_group);
 	xfs_agblock_t		left = be32_to_cpu(block->bb_u.s.bb_leftsib);
 	xfs_agblock_t		right = be32_to_cpu(block->bb_u.s.bb_rightsib);
 	int			rval = 0;
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
 		xfs_buf_readahead(mp->m_ddev_targp,
-				xfs_agbno_to_daddr(cur->bc_ag.pag, left),
-				mp->m_bsize, cur->bc_ops->buf_ops);
+				xfs_agbno_to_daddr(pag, left), mp->m_bsize,
+				cur->bc_ops->buf_ops);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLAGBLOCK) {
 		xfs_buf_readahead(mp->m_ddev_targp,
-				xfs_agbno_to_daddr(cur->bc_ag.pag, right),
-				mp->m_bsize, cur->bc_ops->buf_ops);
+				xfs_agbno_to_daddr(pag, right), mp->m_bsize,
+				cur->bc_ops->buf_ops);
 		rval++;
 	}
 
@@ -1090,7 +1079,7 @@ xfs_btree_ptr_to_daddr(
 
 	switch (cur->bc_ops->type) {
 	case XFS_BTREE_TYPE_AG:
-		*daddr = xfs_agbno_to_daddr(cur->bc_ag.pag,
+		*daddr = xfs_agbno_to_daddr(to_perag(cur->bc_group),
 				be32_to_cpu(ptr->s));
 		break;
 	case XFS_BTREE_TYPE_INODE:
@@ -1312,7 +1301,7 @@ xfs_btree_owner(
 	case XFS_BTREE_TYPE_INODE:
 		return cur->bc_ino.ip->i_ino;
 	case XFS_BTREE_TYPE_AG:
-		return pag_agno(cur->bc_ag.pag);
+		return cur->bc_group->xg_gno;
 	default:
 		ASSERT(0);
 		return 0;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 10b7ddc3b2b34e..3b739459ebb0f4 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -254,6 +254,7 @@ struct xfs_btree_cur
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
 	uint8_t			bc_nlevels; /* number of levels in the tree */
 	uint8_t			bc_maxlevels; /* maximum levels for this btree type */
+	struct xfs_group	*bc_group;
 
 	/* per-type information */
 	union {
@@ -264,13 +265,11 @@ struct xfs_btree_cur
 			struct xbtree_ifakeroot	*ifake;	/* for staging cursor */
 		} bc_ino;
 		struct {
-			struct xfs_perag	*pag;
 			struct xfs_buf		*agbp;
 			struct xbtree_afakeroot	*afake;	/* for staging cursor */
 		} bc_ag;
 		struct {
 			struct xfbtree		*xfbtree;
-			struct xfs_perag	*pag;
 		} bc_mem;
 	};
 
diff --git a/fs/xfs/libxfs/xfs_btree_mem.c b/fs/xfs/libxfs/xfs_btree_mem.c
index 036061fe32cc90..df3d613675a15a 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.c
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -57,10 +57,8 @@ xfbtree_dup_cursor(
 	ncur->bc_flags = cur->bc_flags;
 	ncur->bc_nlevels = cur->bc_nlevels;
 	ncur->bc_mem.xfbtree = cur->bc_mem.xfbtree;
-
-	if (cur->bc_mem.pag)
-		ncur->bc_mem.pag = xfs_perag_hold(cur->bc_mem.pag);
-
+	if (cur->bc_group)
+		ncur->bc_group = xfs_group_hold(cur->bc_group);
 	return ncur;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 78e1920c1ff964..f0261c4d91061c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -142,7 +142,7 @@ xfs_inobt_complain_bad_rec(
 
 	xfs_warn(mp,
 		"%sbt record corruption in AG %d detected at %pS!",
-		cur->bc_ops->name, pag_agno(cur->bc_ag.pag), fa);
+		cur->bc_ops->name, cur->bc_group->xg_gno, fa);
 	xfs_warn(mp,
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
@@ -170,7 +170,7 @@ xfs_inobt_get_rec(
 		return error;
 
 	xfs_inobt_btrec_to_irec(mp, rec, irec);
-	fa = xfs_inobt_check_irec(cur->bc_ag.pag, irec);
+	fa = xfs_inobt_check_irec(to_perag(cur->bc_group), irec);
 	if (fa)
 		return xfs_inobt_complain_bad_rec(cur, fa, irec);
 
@@ -275,8 +275,10 @@ xfs_check_agi_freecount(
 			}
 		} while (i == 1);
 
-		if (!xfs_is_shutdown(cur->bc_mp))
-			ASSERT(freecount == cur->bc_ag.pag->pagi_freecount);
+		if (!xfs_is_shutdown(cur->bc_mp)) {
+			ASSERT(freecount ==
+				to_perag(cur->bc_group)->pagi_freecount);
+		}
 	}
 	return 0;
 }
@@ -2880,7 +2882,7 @@ xfs_ialloc_count_inodes_rec(
 	xfs_failaddr_t			fa;
 
 	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, &irec);
-	fa = xfs_inobt_check_irec(cur->bc_ag.pag, &irec);
+	fa = xfs_inobt_check_irec(to_perag(cur->bc_group), &irec);
 	if (fa)
 		return xfs_inobt_complain_bad_rec(cur, fa, &irec);
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 91d44be2ce48bc..4c28deb3e9881d 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -37,7 +37,7 @@ STATIC struct xfs_btree_cur *
 xfs_inobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
-	return xfs_inobt_init_cursor(cur->bc_ag.pag, cur->bc_tp,
+	return xfs_inobt_init_cursor(to_perag(cur->bc_group), cur->bc_tp,
 			cur->bc_ag.agbp);
 }
 
@@ -45,7 +45,7 @@ STATIC struct xfs_btree_cur *
 xfs_finobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
-	return xfs_finobt_init_cursor(cur->bc_ag.pag, cur->bc_tp,
+	return xfs_finobt_init_cursor(to_perag(cur->bc_group), cur->bc_tp,
 			cur->bc_ag.agbp);
 }
 
@@ -112,7 +112,7 @@ __xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	args.pag = cur->bc_ag.pag;
+	args.pag = to_perag(cur->bc_group);
 	args.oinfo = XFS_RMAP_OINFO_INOBT;
 	args.minlen = 1;
 	args.maxlen = 1;
@@ -248,7 +248,7 @@ xfs_inobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agi->agi_seqno));
+	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agi->agi_seqno));
 
 	ptr->s = agi->agi_root;
 }
@@ -260,7 +260,8 @@ xfs_finobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agi->agi_seqno));
+	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agi->agi_seqno));
+
 	ptr->s = agi->agi_free_root;
 }
 
@@ -483,7 +484,7 @@ xfs_inobt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_inobt_ops,
 			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agi		*agi = agbp->b_addr;
@@ -509,7 +510,7 @@ xfs_finobt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_finobt_ops,
 			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agi		*agi = agbp->b_addr;
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index b8789c42c230b4..ed943f6e616d96 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -154,7 +154,7 @@ xfs_refcount_complain_bad_rec(
 
 	xfs_warn(mp,
  "Refcount BTree record corruption in AG %d detected at %pS!",
-				pag_agno(cur->bc_ag.pag), fa);
+				cur->bc_group->xg_gno, fa);
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
@@ -180,7 +180,7 @@ xfs_refcount_get_rec(
 		return error;
 
 	xfs_refcount_btrec_to_irec(rec, irec);
-	fa = xfs_refcount_check_irec(cur->bc_ag.pag, irec);
+	fa = xfs_refcount_check_irec(to_perag(cur->bc_group), irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, irec);
 
@@ -1154,7 +1154,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				}
 			} else {
-				fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag,
+				fsbno = xfs_agbno_to_fsb(to_perag(cur->bc_group),
 						tmp.rc_startblock);
 				error = xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, NULL,
@@ -1216,7 +1216,7 @@ xfs_refcount_adjust_extents(
 			}
 			goto advloop;
 		} else {
-			fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag,
+			fsbno = xfs_agbno_to_fsb(to_perag(cur->bc_group),
 					ext.rc_startblock);
 			error = xfs_free_extent_later(cur->bc_tp, fsbno,
 					ext.rc_blockcount, NULL,
@@ -1310,7 +1310,7 @@ xfs_refcount_continue_op(
 	xfs_agblock_t			new_agbno)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	struct xfs_perag		*pag = cur->bc_ag.pag;
+	struct xfs_perag		*pag = to_perag(cur->bc_group);
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_agbext(pag, new_agbno,
 					ri->ri_blockcount))) {
@@ -1358,7 +1358,7 @@ xfs_refcount_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
+	if (rcur != NULL && to_perag(rcur->bc_group) != ri->ri_pag) {
 		nr_ops = rcur->bc_refc.nr_ops;
 		shape_changes = rcur->bc_refc.shape_changes;
 		xfs_btree_del_cursor(rcur, 0);
@@ -1878,7 +1878,8 @@ xfs_refcount_recover_extent(
 	INIT_LIST_HEAD(&rr->rr_list);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 
-	if (xfs_refcount_check_irec(cur->bc_ag.pag, &rr->rr_rrec) != NULL ||
+	if (xfs_refcount_check_irec(to_perag(cur->bc_group), &rr->rr_rrec) !=
+			NULL ||
 	    XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
 		xfs_btree_mark_sick(cur);
@@ -2026,7 +2027,7 @@ xfs_refcount_query_range_helper(
 	xfs_failaddr_t			fa;
 
 	xfs_refcount_btrec_to_irec(rec, &irec);
-	fa = xfs_refcount_check_irec(cur->bc_ag.pag, &irec);
+	fa = xfs_refcount_check_irec(to_perag(cur->bc_group), &irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, &irec);
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index db389fdbd929a4..54505fee185289 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -30,7 +30,7 @@ xfs_refcountbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_refcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_ag.pag);
+			cur->bc_ag.agbp, to_perag(cur->bc_group));
 }
 
 STATIC void
@@ -68,7 +68,7 @@ xfs_refcountbt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	args.pag = cur->bc_ag.pag;
+	args.pag = to_perag(cur->bc_group);
 	args.oinfo = XFS_RMAP_OINFO_REFC;
 	args.minlen = args.maxlen = args.prod = 1;
 	args.resv = XFS_AG_RESV_METADATA;
@@ -81,7 +81,7 @@ xfs_refcountbt_alloc_block(
 		*stat = 0;
 		return 0;
 	}
-	ASSERT(args.agno == pag_agno(cur->bc_ag.pag));
+	ASSERT(args.agno == cur->bc_group->xg_gno);
 	ASSERT(args.len == 1);
 
 	new->s = cpu_to_be32(args.agbno);
@@ -169,7 +169,7 @@ xfs_refcountbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_refcount_root;
 }
@@ -365,7 +365,7 @@ xfs_refcountbt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_refcountbt_ops,
 			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_refc.nr_ops = 0;
 	cur->bc_refc.shape_changes = 0;
 	cur->bc_ag.agbp = agbp;
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 984120b128fb9c..0c404625986163 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -269,9 +269,7 @@ xfs_rmap_check_btrec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
-	if (xfs_btree_is_mem_rmap(cur->bc_ops))
-		return xfs_rmap_check_irec(cur->bc_mem.pag, irec);
-	return xfs_rmap_check_irec(cur->bc_ag.pag, irec);
+	return xfs_rmap_check_irec(to_perag(cur->bc_group), irec);
 }
 
 static inline int
@@ -288,7 +286,7 @@ xfs_rmap_complain_bad_rec(
 	else
 		xfs_warn(mp,
  "Reverse Mapping BTree record corruption in AG %d detected at %pS!",
-			pag_agno(cur->bc_ag.pag), fa);
+			cur->bc_group->xg_gno, fa);
 	xfs_warn(mp,
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
@@ -2588,7 +2586,7 @@ xfs_rmap_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
+	if (rcur != NULL && to_perag(rcur->bc_group) != ri->ri_pag) {
 		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index b37eaf37c7fd2d..2cab694ac58a7a 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -57,7 +57,7 @@ xfs_rmapbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_rmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
-				cur->bc_ag.agbp, cur->bc_ag.pag);
+				cur->bc_ag.agbp, to_perag(cur->bc_group));
 }
 
 STATIC void
@@ -66,14 +66,15 @@ xfs_rmapbt_set_root(
 	const union xfs_btree_ptr	*ptr,
 	int				inc)
 {
-	struct xfs_buf		*agbp = cur->bc_ag.agbp;
-	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_buf			*agbp = cur->bc_ag.agbp;
+	struct xfs_agf			*agf = agbp->b_addr;
+	struct xfs_perag		*pag = to_perag(cur->bc_group);
 
 	ASSERT(ptr->s != 0);
 
 	agf->agf_rmap_root = ptr->s;
 	be32_add_cpu(&agf->agf_rmap_level, inc);
-	cur->bc_ag.pag->pagf_rmap_level += inc;
+	pag->pagf_rmap_level += inc;
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -87,7 +88,7 @@ xfs_rmapbt_alloc_block(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_perag	*pag = cur->bc_ag.pag;
+	struct xfs_perag	*pag = to_perag(cur->bc_group);
 	struct xfs_alloc_arg    args = { .len = 1 };
 	int			error;
 	xfs_agblock_t		bno;
@@ -125,7 +126,7 @@ xfs_rmapbt_free_block(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_perag	*pag = cur->bc_ag.pag;
+	struct xfs_perag	*pag = to_perag(cur->bc_group);
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -227,7 +228,7 @@ xfs_rmapbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_rmap_root;
 }
@@ -538,7 +539,7 @@ xfs_rmapbt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agf		*agf = agbp->b_addr;
@@ -653,7 +654,7 @@ xfs_rmapbt_mem_cursor(
 	cur->bc_mem.xfbtree = xfbt;
 	cur->bc_nlevels = xfbt->nlevels;
 
-	cur->bc_mem.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	return cur;
 }
 
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index d1b8a4997dd2ce..8b282138097fb8 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -139,7 +139,7 @@ xchk_allocbt_rec(
 	struct xchk_alloc	*ca = bs->private;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
-	if (xfs_alloc_check_irec(bs->cur->bc_ag.pag, &irec) != NULL) {
+	if (xfs_alloc_check_irec(to_perag(bs->cur->bc_group), &irec) != NULL) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return 0;
 	}
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index fb022b403716b1..64168f2e42220a 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -601,7 +601,8 @@ xchk_bmap_check_rmap(
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
 		if (irec.br_startblock !=
-		    xfs_agbno_to_fsb(cur->bc_ag.pag, check_rec.rm_startblock))
+		    xfs_agbno_to_fsb(to_perag(cur->bc_group),
+				check_rec.rm_startblock))
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
 		if (irec.br_blockcount > check_rec.rm_blockcount)
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index be408e50484b54..7c4955482641f7 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -196,7 +196,7 @@ xrep_bmap_check_fork_rmap(
 		return -EFSCORRUPTED;
 
 	/* Check that this is within the AG. */
-	if (!xfs_verify_agbext(cur->bc_ag.pag, rec->rm_startblock,
+	if (!xfs_verify_agbext(to_perag(cur->bc_group), rec->rm_startblock,
 				rec->rm_blockcount))
 		return -EFSCORRUPTED;
 
@@ -268,7 +268,7 @@ xrep_bmap_walk_rmap(
 	if ((rec->rm_flags & XFS_RMAP_UNWRITTEN) && !rb->allow_unwritten)
 		return -EFSCORRUPTED;
 
-	fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag, rec->rm_startblock);
+	fsbno = xfs_agbno_to_fsb(to_perag(cur->bc_group), rec->rm_startblock);
 
 	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
 		rb->old_bmbt_block_count += rec->rm_blockcount;
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index 19bded43c4fe1e..5b6194cef3e5e3 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -145,7 +145,8 @@ xrep_cow_mark_shared_staging(
 	xrep_cow_trim_refcount(xc, &rrec, rec);
 
 	return xrep_cow_mark_file_range(xc,
-			xfs_agbno_to_fsb(cur->bc_ag.pag, rrec.rc_startblock),
+			xfs_agbno_to_fsb(to_perag(cur->bc_group),
+				rrec.rc_startblock),
 			rrec.rc_blockcount);
 }
 
@@ -176,8 +177,9 @@ xrep_cow_mark_missing_staging(
 	if (xc->next_bno >= rrec.rc_startblock)
 		goto next;
 
+
 	error = xrep_cow_mark_file_range(xc,
-			xfs_agbno_to_fsb(cur->bc_ag.pag, xc->next_bno),
+			xfs_agbno_to_fsb(to_perag(cur->bc_group), xc->next_bno),
 			rrec.rc_startblock - xc->next_bno);
 	if (error)
 		return error;
@@ -220,7 +222,8 @@ xrep_cow_mark_missing_staging_rmap(
 	}
 
 	return xrep_cow_mark_file_range(xc,
-			xfs_agbno_to_fsb(cur->bc_ag.pag, rec_bno), rec_len);
+			xfs_agbno_to_fsb(to_perag(cur->bc_group), rec_bno),
+			rec_len);
 }
 
 /*
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index fce04444c37c2a..6ceef3749e3b99 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -276,7 +276,7 @@ xchk_ag_btree_del_cursor_if_sick(
 	    type_to_health_flag[sc->sm->sm_type].group == XHG_AG)
 		mask &= ~sc->sick_mask;
 
-	if (xfs_ag_has_sickness((*curp)->bc_ag.pag, mask)) {
+	if (xfs_group_has_sickness((*curp)->bc_group, mask)) {
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
 		xfs_btree_del_cursor(*curp, XFS_BTREE_NOERROR);
 		*curp = NULL;
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index ee71cf2050b72e..abad54c3621d44 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -258,7 +258,7 @@ xchk_iallocbt_chunk(
 {
 	struct xfs_scrub		*sc = bs->sc;
 	struct xfs_mount		*mp = bs->cur->bc_mp;
-	struct xfs_perag		*pag = bs->cur->bc_ag.pag;
+	struct xfs_perag		*pag = to_perag(bs->cur->bc_group);
 	xfs_agblock_t			agbno;
 	xfs_extlen_t			len;
 
@@ -318,7 +318,7 @@ xchk_iallocbt_check_cluster_ifree(
 	 * the record, compute which fs inode we're talking about.
 	 */
 	agino = irec->ir_startino + irec_ino;
-	fsino = xfs_agino_to_ino(bs->cur->bc_ag.pag, agino);
+	fsino = xfs_agino_to_ino(to_perag(bs->cur->bc_group), agino);
 	irec_free = (irec->ir_free & XFS_INOBT_MASK(irec_ino));
 
 	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC ||
@@ -394,7 +394,7 @@ xchk_iallocbt_check_cluster(
 	 * ir_startino can be large enough to make im_boffset nonzero.
 	 */
 	ir_holemask = (irec->ir_holemask & cluster_mask);
-	imap.im_blkno = xfs_agbno_to_daddr(bs->cur->bc_ag.pag, agbno);
+	imap.im_blkno = xfs_agbno_to_daddr(to_perag(bs->cur->bc_group), agbno);
 	imap.im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino) <<
 			mp->m_sb.sb_inodelog;
@@ -405,9 +405,9 @@ xchk_iallocbt_check_cluster(
 		return 0;
 	}
 
-	trace_xchk_iallocbt_check_cluster(bs->cur->bc_ag.pag, irec->ir_startino,
-			imap.im_blkno, imap.im_len, cluster_base, nr_inodes,
-			cluster_mask, ir_holemask,
+	trace_xchk_iallocbt_check_cluster(to_perag(bs->cur->bc_group),
+			irec->ir_startino, imap.im_blkno, imap.im_len,
+			cluster_base, nr_inodes, cluster_mask, ir_holemask,
 			XFS_INO_TO_OFFSET(mp, irec->ir_startino +
 					  cluster_base));
 
@@ -583,7 +583,7 @@ xchk_iallocbt_rec(
 	uint16_t			holemask;
 
 	xfs_inobt_btrec_to_irec(mp, rec, &irec);
-	if (xfs_inobt_check_irec(bs->cur->bc_ag.pag, &irec) != NULL) {
+	if (xfs_inobt_check_irec(to_perag(bs->cur->bc_group), &irec) != NULL) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return 0;
 	}
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index d0c7d4a29c0feb..2b6be75e942415 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -453,7 +453,8 @@ xchk_refcountbt_rec(
 	struct xchk_refcbt_records *rrc = bs->private;
 
 	xfs_refcount_btrec_to_irec(rec, &irec);
-	if (xfs_refcount_check_irec(bs->cur->bc_ag.pag, &irec) != NULL) {
+	if (xfs_refcount_check_irec(to_perag(bs->cur->bc_group), &irec) !=
+			NULL) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return 0;
 	}
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 26b5c90b3f6aee..39e9ad7cd8aea5 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -358,7 +358,7 @@ xchk_rmapbt_rec(
 	struct xfs_rmap_irec	irec;
 
 	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL ||
-	    xfs_rmap_check_irec(bs->cur->bc_ag.pag, &irec) != NULL) {
+	    xfs_rmap_check_irec(to_perag(bs->cur->bc_group), &irec) != NULL) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return 0;
 	}
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 6c420ec7dacd1b..a0a227d183d28d 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -622,7 +622,7 @@ xrep_rmap_walk_inobt(
 		return error;
 
 	xfs_inobt_btrec_to_irec(mp, rec, &irec);
-	if (xfs_inobt_check_irec(cur->bc_ag.pag, &irec) != NULL)
+	if (xfs_inobt_check_irec(to_perag(cur->bc_group), &irec) != NULL)
 		return -EFSCORRUPTED;
 
 	agino = irec.ir_startino;
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index a26fb054346b68..5d5e54a16f23c8 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -394,7 +394,8 @@ xfs_getfsmap_datadev_helper(
 	struct xfs_getfsmap_info	*info = priv;
 
 	return xfs_getfsmap_helper(cur->bc_tp, info, rec,
-			xfs_agbno_to_daddr(cur->bc_ag.pag, rec->rm_startblock),
+			xfs_agbno_to_daddr(to_perag(cur->bc_group),
+				rec->rm_startblock),
 			0);
 }
 
@@ -415,7 +416,8 @@ xfs_getfsmap_datadev_bnobt_helper(
 	irec.rm_flags = 0;
 
 	return xfs_getfsmap_helper(cur->bc_tp, info, &irec,
-			xfs_agbno_to_daddr(cur->bc_ag.pag, rec->ar_startblock),
+			xfs_agbno_to_daddr(to_perag(cur->bc_group),
+				rec->ar_startblock),
 			0);
 }
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 732246f46680d5..f45f125a669de7 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -531,24 +531,13 @@ void
 xfs_btree_mark_sick(
 	struct xfs_btree_cur		*cur)
 {
-	switch (cur->bc_ops->type) {
-	case XFS_BTREE_TYPE_MEM:
-		/* no health state tracking for ephemeral btrees */
-		return;
-	case XFS_BTREE_TYPE_AG:
+	if (xfs_btree_is_bmap(cur->bc_ops)) {
+		xfs_bmap_mark_sick(cur->bc_ino.ip, cur->bc_ino.whichfork);
+	/* no health state tracking for ephemeral btrees */
+	} else if (cur->bc_ops->type != XFS_BTREE_TYPE_MEM) {
+		ASSERT(cur->bc_group);
 		ASSERT(cur->bc_ops->sick_mask);
-		xfs_ag_mark_sick(cur->bc_ag.pag, cur->bc_ops->sick_mask);
-		return;
-	case XFS_BTREE_TYPE_INODE:
-		if (xfs_btree_is_bmap(cur->bc_ops)) {
-			xfs_bmap_mark_sick(cur->bc_ino.ip,
-					   cur->bc_ino.whichfork);
-			return;
-		}
-		fallthrough;
-	default:
-		ASSERT(0);
-		return;
+		xfs_group_mark_sick(cur->bc_group, cur->bc_ops->sick_mask);
 	}
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 96d94d9085c2d2..93741b24c6949a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2593,7 +2593,7 @@ TRACE_EVENT(xfs_btree_alloc_block,
 			__entry->ino = cur->bc_ino.ip->i_ino;
 			break;
 		case XFS_BTREE_TYPE_AG:
-			__entry->agno = pag_agno(cur->bc_ag.pag);
+			__entry->agno = cur->bc_group->xg_gno;
 			__entry->ino = 0;
 			break;
 		case XFS_BTREE_TYPE_MEM:
@@ -2849,7 +2849,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = pag_agno(cur->bc_ag.pag);
+		__entry->agno = cur->bc_group->xg_gno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->owner = oinfo->oi_owner;
@@ -2894,7 +2894,7 @@ DECLARE_EVENT_CLASS(xfs_btree_error_class,
 			__entry->ino = cur->bc_ino.ip->i_ino;
 			break;
 		case XFS_BTREE_TYPE_AG:
-			__entry->agno = pag_agno(cur->bc_ag.pag);
+			__entry->agno = cur->bc_group->xg_gno;
 			__entry->ino = 0;
 			break;
 		case XFS_BTREE_TYPE_MEM:
@@ -2948,7 +2948,7 @@ TRACE_EVENT(xfs_rmap_convert_state,
 			__entry->ino = cur->bc_ino.ip->i_ino;
 			break;
 		case XFS_BTREE_TYPE_AG:
-			__entry->agno = pag_agno(cur->bc_ag.pag);
+			__entry->agno = cur->bc_group->xg_gno;
 			__entry->ino = 0;
 			break;
 		case XFS_BTREE_TYPE_MEM:
@@ -2983,7 +2983,7 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = pag_agno(cur->bc_ag.pag);
+		__entry->agno = cur->bc_group->xg_gno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->owner = owner;
@@ -3227,7 +3227,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = pag_agno(cur->bc_ag.pag);
+		__entry->agno = cur->bc_group->xg_gno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
@@ -3258,7 +3258,7 @@ TRACE_EVENT(xfs_refcount_lookup,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = pag_agno(cur->bc_ag.pag);
+		__entry->agno = cur->bc_group->xg_gno;
 		__entry->agbno = agbno;
 		__entry->dir = dir;
 	),
@@ -3284,7 +3284,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = pag_agno(cur->bc_ag.pag);
+		__entry->agno = cur->bc_group->xg_gno;
 		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
@@ -3320,7 +3320,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = pag_agno(cur->bc_ag.pag);
+		__entry->agno = cur->bc_group->xg_gno;
 		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
@@ -3362,7 +3362,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = pag_agno(cur->bc_ag.pag);
+		__entry->agno = cur->bc_group->xg_gno;
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3412,7 +3412,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = pag_agno(cur->bc_ag.pag);
+		__entry->agno = cur->bc_group->xg_gno;
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3467,7 +3467,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = pag_agno(cur->bc_ag.pag);
+		__entry->agno = cur->bc_group->xg_gno;
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -4357,7 +4357,7 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
 		__assign_str(name);
-		__entry->agno = pag_agno(cur->bc_ag.pag);
+		__entry->agno = cur->bc_group->xg_gno;
 		__entry->agbno = cur->bc_ag.afake->af_root;
 		__entry->levels = cur->bc_ag.afake->af_levels;
 		__entry->blocks = cur->bc_ag.afake->af_blocks;
@@ -4472,7 +4472,7 @@ TRACE_EVENT(xfs_btree_bload_block,
 			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);
 			__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsb);
 		} else {
-			__entry->agno = pag_agno(cur->bc_ag.pag);
+			__entry->agno = cur->bc_group->xg_gno;
 			__entry->agbno = be32_to_cpu(ptr->s);
 		}
 		__entry->nr_records = nr_records;

