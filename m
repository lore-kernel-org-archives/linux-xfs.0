Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB43212F85
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528160; cv=none; b=pi/WtO5f/P+VcY4QbyeKtFtVbKCLlcYMann4ow+kVSJKxVyFzqVFogWM3VQg4s3H97DyrEMtvdxrf0mIrwoU6sz1uwKMEA43/Hr59Gp5P3G/nbyLEJdJ5e9NISfUefQEO2cSU94jgpukJGuEcUGuomn74eLbj4ant8PPB/qmuHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528160; c=relaxed/simple;
	bh=SSVr6MODEMUQtVReEtFLLyP/5pSmIDisojFW++NBR+U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WqdbLfjxmNZAqjd5EPUpJh+bIDsbmoOGoLHyIR+epxAUy1V2tuA3DDkIoUiQ0M3nob+bo7lS7tjJjqb7jFjCPVhukt0bFSI9HWnIq3/u3AGxpJJiUYUdIgNpyuNAK8OPG9OONnkv5NZmffzxyOzol+u0PsfWcCVsFPupRQHqY7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b2S867sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2S867sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52207C4CED1;
	Fri,  6 Dec 2024 23:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528160;
	bh=SSVr6MODEMUQtVReEtFLLyP/5pSmIDisojFW++NBR+U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b2S867sfrHnNu9uhzXUmJMkOGUEYZ1gUWuOBTjDsSPxMjyezkK9hVfLKWECe7hWG3
	 Ra2gnFpMQyyX1V3FeVAEpu/bAOsqir5PMctMKMITzZL7S0kUrV1Gb8+7oAAcllOa4I
	 KGgHgDndGrkJz64bUY27rxZm9vMS3LTxw0275QFV8PL4xO/xUqhu+kwc3w2NVwMSRE
	 jotY/2NMx7zrQ1VhltHue4QbWsIsHr0HVvoJdv4hYcYhzqMAAxY23XwrF2LFmDY7Qh
	 zD5ul+diP2sbGHN+juvoVdTd0ZXsB0YWfxivi8ncFTKjkPCZ7QQ1mk5gKubowU1gXy
	 IFY8taDv6FKyQ==
Date: Fri, 06 Dec 2024 15:35:59 -0800
Subject: [PATCH 22/36] xfs: add a generic group pointer to the btree cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747211.121772.6490104857306106223.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 77a530e6c49d22bd4a221d2f059db24fc30094db

Replace the pag pointers in the type specific union with a generic
xfs_group pointer.  This prepares for adding realtime group support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c          |    8 ++++----
 libxfs/xfs_alloc_btree.c    |   28 ++++++++++++++--------------
 libxfs/xfs_btree.c          |   35 ++++++++++++-----------------------
 libxfs/xfs_btree.h          |    3 +--
 libxfs/xfs_btree_mem.c      |    6 ++----
 libxfs/xfs_ialloc.c         |   12 +++++++-----
 libxfs/xfs_ialloc_btree.c   |   15 ++++++++-------
 libxfs/xfs_refcount.c       |   17 +++++++++--------
 libxfs/xfs_refcount_btree.c |   10 +++++-----
 libxfs/xfs_rmap.c           |    8 +++-----
 libxfs/xfs_rmap_btree.c     |   19 ++++++++++---------
 repair/agbtree.c            |    6 +++---
 repair/bmap_repair.c        |    4 ++--
 13 files changed, 80 insertions(+), 91 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 1c50358a8be7ae..c449285743534d 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -271,7 +271,7 @@ xfs_alloc_complain_bad_rec(
 
 	xfs_warn(mp,
 		"%sbt record corruption in AG %d detected at %pS!",
-		cur->bc_ops->name, pag_agno(cur->bc_ag.pag), fa);
+		cur->bc_ops->name, cur->bc_group->xg_gno, fa);
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", irec->ar_startblock,
 		irec->ar_blockcount);
@@ -299,7 +299,7 @@ xfs_alloc_get_rec(
 		return error;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
-	fa = xfs_alloc_check_irec(cur->bc_ag.pag, &irec);
+	fa = xfs_alloc_check_irec(to_perag(cur->bc_group), &irec);
 	if (fa)
 		return xfs_alloc_complain_bad_rec(cur, fa, &irec);
 
@@ -536,7 +536,7 @@ static int
 xfs_alloc_fixup_longest(
 	struct xfs_btree_cur	*cnt_cur)
 {
-	struct xfs_perag	*pag = cnt_cur->bc_ag.pag;
+	struct xfs_perag	*pag = to_perag(cnt_cur->bc_group);
 	struct xfs_buf		*bp = cnt_cur->bc_ag.agbp;
 	struct xfs_agf		*agf = bp->b_addr;
 	xfs_extlen_t		longest = 0;
@@ -4038,7 +4038,7 @@ xfs_alloc_query_range_helper(
 	xfs_failaddr_t				fa;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
-	fa = xfs_alloc_check_irec(cur->bc_ag.pag, &irec);
+	fa = xfs_alloc_check_irec(to_perag(cur->bc_group), &irec);
 	if (fa)
 		return xfs_alloc_complain_bad_rec(cur, fa, &irec);
 
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index bf906aeb2f8a9e..63b8db4ed01350 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -26,7 +26,7 @@ xfs_bnobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_bnobt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ag.agbp,
-			cur->bc_ag.pag);
+			to_perag(cur->bc_group));
 }
 
 STATIC struct xfs_btree_cur *
@@ -34,29 +34,29 @@ xfs_cntbt_dup_cursor(
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
@@ -73,7 +73,7 @@ xfs_allocbt_alloc_block(
 	xfs_agblock_t		bno;
 
 	/* Allocate the new block from the freelist. If we can't, give up.  */
-	error = xfs_alloc_get_freelist(cur->bc_ag.pag, cur->bc_tp,
+	error = xfs_alloc_get_freelist(to_perag(cur->bc_group), cur->bc_tp,
 			cur->bc_ag.agbp, &bno, 1);
 	if (error)
 		return error;
@@ -84,7 +84,7 @@ xfs_allocbt_alloc_block(
 	}
 
 	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_reuse(pag_group(cur->bc_ag.pag), bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_group, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 
@@ -102,8 +102,8 @@ xfs_allocbt_free_block(
 	int			error;
 
 	bno = xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp));
-	error = xfs_alloc_put_freelist(cur->bc_ag.pag, cur->bc_tp, agbp, NULL,
-			bno, 1);
+	error = xfs_alloc_put_freelist(to_perag(cur->bc_group), cur->bc_tp,
+			agbp, NULL, bno, 1);
 	if (error)
 		return error;
 
@@ -176,7 +176,7 @@ xfs_allocbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agf->agf_seqno));
 
 	if (xfs_btree_is_bno(cur->bc_ops))
 		ptr->s = agf->agf_bno_root;
@@ -490,7 +490,7 @@ xfs_bnobt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_bnobt_ops,
 			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agf		*agf = agbp->b_addr;
@@ -516,7 +516,7 @@ xfs_cntbt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_cntbt_ops,
 			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agf		*agf = agbp->b_addr;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2b63c18114763c..3d870f3f4a5165 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -223,7 +223,7 @@ __xfs_btree_check_agblock(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_perag	*pag = cur->bc_ag.pag;
+	struct xfs_perag	*pag = to_perag(cur->bc_group);
 	xfs_failaddr_t		fa;
 	xfs_agblock_t		agbno;
 
@@ -329,7 +329,7 @@ __xfs_btree_check_ptr(
 			return -EFSCORRUPTED;
 		break;
 	case XFS_BTREE_TYPE_AG:
-		if (!xfs_verify_agbno(cur->bc_ag.pag,
+		if (!xfs_verify_agbno(to_perag(cur->bc_group),
 				be32_to_cpu((&ptr->s)[index])))
 			return -EFSCORRUPTED;
 		break;
@@ -370,7 +370,7 @@ xfs_btree_check_ptr(
 		case XFS_BTREE_TYPE_AG:
 			xfs_err(cur->bc_mp,
 "AG %u: Corrupt %sbt pointer at level %d index %d.",
-				pag_agno(cur->bc_ag.pag), cur->bc_ops->name,
+				cur->bc_group->xg_gno, cur->bc_ops->name,
 				level, index);
 			break;
 		}
@@ -521,20 +521,8 @@ xfs_btree_del_cursor(
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
 
@@ -1015,21 +1003,22 @@ xfs_btree_readahead_agblock(
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
 
@@ -1088,7 +1077,7 @@ xfs_btree_ptr_to_daddr(
 
 	switch (cur->bc_ops->type) {
 	case XFS_BTREE_TYPE_AG:
-		*daddr = xfs_agbno_to_daddr(cur->bc_ag.pag,
+		*daddr = xfs_agbno_to_daddr(to_perag(cur->bc_group),
 				be32_to_cpu(ptr->s));
 		break;
 	case XFS_BTREE_TYPE_INODE:
@@ -1310,7 +1299,7 @@ xfs_btree_owner(
 	case XFS_BTREE_TYPE_INODE:
 		return cur->bc_ino.ip->i_ino;
 	case XFS_BTREE_TYPE_AG:
-		return pag_agno(cur->bc_ag.pag);
+		return cur->bc_group->xg_gno;
 	default:
 		ASSERT(0);
 		return 0;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 10b7ddc3b2b34e..3b739459ebb0f4 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
 
diff --git a/libxfs/xfs_btree_mem.c b/libxfs/xfs_btree_mem.c
index ae9302b9090f58..8e3efdbccc156a 100644
--- a/libxfs/xfs_btree_mem.c
+++ b/libxfs/xfs_btree_mem.c
@@ -56,10 +56,8 @@ xfbtree_dup_cursor(
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
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index e4b9d3e2fbb5ce..055eff477faceb 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -137,7 +137,7 @@ xfs_inobt_complain_bad_rec(
 
 	xfs_warn(mp,
 		"%sbt record corruption in AG %d detected at %pS!",
-		cur->bc_ops->name, pag_agno(cur->bc_ag.pag), fa);
+		cur->bc_ops->name, cur->bc_group->xg_gno, fa);
 	xfs_warn(mp,
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
@@ -165,7 +165,7 @@ xfs_inobt_get_rec(
 		return error;
 
 	xfs_inobt_btrec_to_irec(mp, rec, irec);
-	fa = xfs_inobt_check_irec(cur->bc_ag.pag, irec);
+	fa = xfs_inobt_check_irec(to_perag(cur->bc_group), irec);
 	if (fa)
 		return xfs_inobt_complain_bad_rec(cur, fa, irec);
 
@@ -270,8 +270,10 @@ xfs_check_agi_freecount(
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
@@ -2875,7 +2877,7 @@ xfs_ialloc_count_inodes_rec(
 	xfs_failaddr_t			fa;
 
 	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, &irec);
-	fa = xfs_inobt_check_irec(cur->bc_ag.pag, &irec);
+	fa = xfs_inobt_check_irec(to_perag(cur->bc_group), &irec);
 	if (fa)
 		return xfs_inobt_complain_bad_rec(cur, fa, &irec);
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 45908cce464dff..4eeea240b0bd89 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -36,7 +36,7 @@ STATIC struct xfs_btree_cur *
 xfs_inobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
-	return xfs_inobt_init_cursor(cur->bc_ag.pag, cur->bc_tp,
+	return xfs_inobt_init_cursor(to_perag(cur->bc_group), cur->bc_tp,
 			cur->bc_ag.agbp);
 }
 
@@ -44,7 +44,7 @@ STATIC struct xfs_btree_cur *
 xfs_finobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
-	return xfs_finobt_init_cursor(cur->bc_ag.pag, cur->bc_tp,
+	return xfs_finobt_init_cursor(to_perag(cur->bc_group), cur->bc_tp,
 			cur->bc_ag.agbp);
 }
 
@@ -111,7 +111,7 @@ __xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	args.pag = cur->bc_ag.pag;
+	args.pag = to_perag(cur->bc_group);
 	args.oinfo = XFS_RMAP_OINFO_INOBT;
 	args.minlen = 1;
 	args.maxlen = 1;
@@ -247,7 +247,7 @@ xfs_inobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agi->agi_seqno));
+	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agi->agi_seqno));
 
 	ptr->s = agi->agi_root;
 }
@@ -259,7 +259,8 @@ xfs_finobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agi->agi_seqno));
+	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agi->agi_seqno));
+
 	ptr->s = agi->agi_free_root;
 }
 
@@ -482,7 +483,7 @@ xfs_inobt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_inobt_ops,
 			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agi		*agi = agbp->b_addr;
@@ -508,7 +509,7 @@ xfs_finobt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_finobt_ops,
 			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agi		*agi = agbp->b_addr;
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 9507cf74578d4f..3eccb998545d6f 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -153,7 +153,7 @@ xfs_refcount_complain_bad_rec(
 
 	xfs_warn(mp,
  "Refcount BTree record corruption in AG %d detected at %pS!",
-				pag_agno(cur->bc_ag.pag), fa);
+				cur->bc_group->xg_gno, fa);
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
@@ -179,7 +179,7 @@ xfs_refcount_get_rec(
 		return error;
 
 	xfs_refcount_btrec_to_irec(rec, irec);
-	fa = xfs_refcount_check_irec(cur->bc_ag.pag, irec);
+	fa = xfs_refcount_check_irec(to_perag(cur->bc_group), irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, irec);
 
@@ -1153,7 +1153,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				}
 			} else {
-				fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag,
+				fsbno = xfs_agbno_to_fsb(to_perag(cur->bc_group),
 						tmp.rc_startblock);
 				error = xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, NULL,
@@ -1215,7 +1215,7 @@ xfs_refcount_adjust_extents(
 			}
 			goto advloop;
 		} else {
-			fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag,
+			fsbno = xfs_agbno_to_fsb(to_perag(cur->bc_group),
 					ext.rc_startblock);
 			error = xfs_free_extent_later(cur->bc_tp, fsbno,
 					ext.rc_blockcount, NULL,
@@ -1309,7 +1309,7 @@ xfs_refcount_continue_op(
 	xfs_agblock_t			new_agbno)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	struct xfs_perag		*pag = cur->bc_ag.pag;
+	struct xfs_perag		*pag = to_perag(cur->bc_group);
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_agbext(pag, new_agbno,
 					ri->ri_blockcount))) {
@@ -1357,7 +1357,7 @@ xfs_refcount_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
+	if (rcur != NULL && to_perag(rcur->bc_group) != ri->ri_pag) {
 		nr_ops = rcur->bc_refc.nr_ops;
 		shape_changes = rcur->bc_refc.shape_changes;
 		xfs_btree_del_cursor(rcur, 0);
@@ -1877,7 +1877,8 @@ xfs_refcount_recover_extent(
 	INIT_LIST_HEAD(&rr->rr_list);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 
-	if (xfs_refcount_check_irec(cur->bc_ag.pag, &rr->rr_rrec) != NULL ||
+	if (xfs_refcount_check_irec(to_perag(cur->bc_group), &rr->rr_rrec) !=
+			NULL ||
 	    XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
 		xfs_btree_mark_sick(cur);
@@ -2025,7 +2026,7 @@ xfs_refcount_query_range_helper(
 	xfs_failaddr_t			fa;
 
 	xfs_refcount_btrec_to_irec(rec, &irec);
-	fa = xfs_refcount_check_irec(cur->bc_ag.pag, &irec);
+	fa = xfs_refcount_check_irec(to_perag(cur->bc_group), &irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, &irec);
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index e9c4fc419a6114..efb9af710f7361 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -29,7 +29,7 @@ xfs_refcountbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_refcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_ag.agbp, cur->bc_ag.pag);
+			cur->bc_ag.agbp, to_perag(cur->bc_group));
 }
 
 STATIC void
@@ -67,7 +67,7 @@ xfs_refcountbt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	args.pag = cur->bc_ag.pag;
+	args.pag = to_perag(cur->bc_group);
 	args.oinfo = XFS_RMAP_OINFO_REFC;
 	args.minlen = args.maxlen = args.prod = 1;
 	args.resv = XFS_AG_RESV_METADATA;
@@ -80,7 +80,7 @@ xfs_refcountbt_alloc_block(
 		*stat = 0;
 		return 0;
 	}
-	ASSERT(args.agno == pag_agno(cur->bc_ag.pag));
+	ASSERT(args.agno == cur->bc_group->xg_gno);
 	ASSERT(args.len == 1);
 
 	new->s = cpu_to_be32(args.agbno);
@@ -168,7 +168,7 @@ xfs_refcountbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_refcount_root;
 }
@@ -364,7 +364,7 @@ xfs_refcountbt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_refcountbt_ops,
 			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_refc.nr_ops = 0;
 	cur->bc_refc.shape_changes = 0;
 	cur->bc_ag.agbp = agbp;
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index e13f4aa7e99538..07bcdf82d10081 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -268,9 +268,7 @@ xfs_rmap_check_btrec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
-	if (xfs_btree_is_mem_rmap(cur->bc_ops))
-		return xfs_rmap_check_irec(cur->bc_mem.pag, irec);
-	return xfs_rmap_check_irec(cur->bc_ag.pag, irec);
+	return xfs_rmap_check_irec(to_perag(cur->bc_group), irec);
 }
 
 static inline int
@@ -287,7 +285,7 @@ xfs_rmap_complain_bad_rec(
 	else
 		xfs_warn(mp,
  "Reverse Mapping BTree record corruption in AG %d detected at %pS!",
-			pag_agno(cur->bc_ag.pag), fa);
+			cur->bc_group->xg_gno, fa);
 	xfs_warn(mp,
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
@@ -2587,7 +2585,7 @@ xfs_rmap_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
+	if (rcur != NULL && to_perag(rcur->bc_group) != ri->ri_pag) {
 		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 5829e68790314a..f4da35050d2635 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -56,7 +56,7 @@ xfs_rmapbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_rmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
-				cur->bc_ag.agbp, cur->bc_ag.pag);
+				cur->bc_ag.agbp, to_perag(cur->bc_group));
 }
 
 STATIC void
@@ -65,14 +65,15 @@ xfs_rmapbt_set_root(
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
@@ -86,7 +87,7 @@ xfs_rmapbt_alloc_block(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_perag	*pag = cur->bc_ag.pag;
+	struct xfs_perag	*pag = to_perag(cur->bc_group);
 	struct xfs_alloc_arg    args = { .len = 1 };
 	int			error;
 	xfs_agblock_t		bno;
@@ -124,7 +125,7 @@ xfs_rmapbt_free_block(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_perag	*pag = cur->bc_ag.pag;
+	struct xfs_perag	*pag = to_perag(cur->bc_group);
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -226,7 +227,7 @@ xfs_rmapbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
+	ASSERT(cur->bc_group->xg_gno == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_rmap_root;
 }
@@ -537,7 +538,7 @@ xfs_rmapbt_init_cursor(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
-	cur->bc_ag.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	cur->bc_ag.agbp = agbp;
 	if (agbp) {
 		struct xfs_agf		*agf = agbp->b_addr;
@@ -652,7 +653,7 @@ xfs_rmapbt_mem_cursor(
 	cur->bc_mem.xfbtree = xfbt;
 	cur->bc_nlevels = xfbt->nlevels;
 
-	cur->bc_mem.pag = xfs_perag_hold(pag);
+	cur->bc_group = xfs_group_hold(pag_group(pag));
 	return cur;
 }
 
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 67baa1acba9907..42bfeee9eafbcb 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -202,7 +202,7 @@ get_bno_rec(
 	struct xfs_btree_cur	*cur,
 	struct extent_tree_node	*prev_value)
 {
-	xfs_agnumber_t		agno = pag_agno(cur->bc_ag.pag);
+	xfs_agnumber_t		agno = cur->bc_group->xg_gno;
 
 	if (xfs_btree_is_bno(cur->bc_ops)) {
 		if (!prev_value)
@@ -376,7 +376,7 @@ get_ino_rec(
 	struct xfs_btree_cur	*cur,
 	struct ino_tree_node	*prev_value)
 {
-	xfs_agnumber_t		agno = pag_agno(cur->bc_ag.pag);
+	xfs_agnumber_t		agno = cur->bc_group->xg_gno;
 
 	if (xfs_btree_is_ino(cur->bc_ops)) {
 		if (!prev_value)
@@ -614,7 +614,7 @@ get_rmapbt_records(
 		if (ret == 0)
 			do_error(
  _("ran out of records while rebuilding AG %u rmap btree\n"),
-					pag_agno(cur->bc_ag.pag));
+					cur->bc_group->xg_gno);
 
 		block_rec = libxfs_btree_rec_addr(cur, idx, block);
 		cur->bc_ops->init_rec_from_cur(cur, block_rec);
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 3a214c85a1de5f..f052b5dcddff08 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -104,7 +104,7 @@ xrep_bmap_check_fork_rmap(
 		return EFSCORRUPTED;
 
 	/* Check that this is within the AG. */
-	if (!xfs_verify_agbext(cur->bc_ag.pag, rec->rm_startblock,
+	if (!xfs_verify_agbext(to_perag(cur->bc_group), rec->rm_startblock,
 				rec->rm_blockcount))
 		return EFSCORRUPTED;
 
@@ -154,7 +154,7 @@ xrep_bmap_walk_rmap(
 	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
 		return 0;
 
-	fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag, rec->rm_startblock);
+	fsbno = xfs_agbno_to_fsb(to_perag(cur->bc_group), rec->rm_startblock);
 
 	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
 		rb->old_bmbt_block_count += rec->rm_blockcount;

