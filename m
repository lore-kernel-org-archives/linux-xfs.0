Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F9D1D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424018; cv=none; b=T7nBLwaLS0S+wCvtbmyRj36FukepY20K5c8o+3U1hE4H7yFlmbMvvVDd4idECQmCnnMn7zAxOeYO6/KwhEG5LbixfVlYIMNqQ9Y4uNW1VMsDHRYnrDj63F6P6RPiW4eirPeSHDewmmsEgssk8HJFRCElmN8sbzUIbKhz123jE5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424018; c=relaxed/simple;
	bh=Kn4drRUbFODo7jWN3LOfrxgTH5CDcyK//PAbqD0D3Dc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z6x2boaOHt/GVLQXcs3LIuQIy/7nazxX/Go+vPURQ9dHDyl5Qzf9TwTtjA4Gaf/DXDDhnUJTsQX0+BZyJ+x7Zixm3iga8EM5Rg/c/dxhLSRhH3U69i9zpRvAs4CoMJ/2cKQkfGXaO+VBYDcAY0qQxR8BVU9WgbyYLD6qPayKh8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lgLJOIDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lgLJOIDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BF5C433C7;
	Tue, 26 Mar 2024 03:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424018;
	bh=Kn4drRUbFODo7jWN3LOfrxgTH5CDcyK//PAbqD0D3Dc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lgLJOIDAofVddC9u5EYQfeXwQaxfAbeJKwN/02fEpf1kbl+aJs6z61Zb+IP47+VS3
	 iU/NStTe3vztI1xAwTzrhb6sBn0uhEvnTpXr4CDY/MCoeywsCyVNisb7Gm0dj334/8
	 w+nm0U7rweN0ztn0iV6FBbwe+kvdO3a07VHvK4ufEABxYYECGyAs+xbbZUBHe1gpr1
	 UI+qyGCUcVPmKe02DywL8tV+KLNmbIPnxSJu73DTcnL8ID+fgSu4Q3SjOFwd8tTFkG
	 ZZbekw5ftgzkXo3yOEm95mZslS/KPJ2e8r0nABxw6B/sfo5jhc53n3nI2Whm0IP9JS
	 M1TDGlRxEyh5A==
Date: Mon, 25 Mar 2024 20:33:37 -0700
Subject: [PATCH 020/110] xfs: report btree block corruption errors to the
 health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131672.2215168.18019058273039359841.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: a78d10f45b23149f1b23019a4f4fb57dcf852e39

Whenever we encounter corrupt btree blocks, we should report that to the
health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c         |    1 +
 libxfs/xfs_alloc.c    |    2 ++
 libxfs/xfs_bmap.c     |    6 ++++++
 libxfs/xfs_btree.c    |   25 ++++++++++++++++++++++---
 libxfs/xfs_health.h   |    2 ++
 libxfs/xfs_ialloc.c   |    1 +
 libxfs/xfs_refcount.c |    6 +++++-
 libxfs/xfs_rmap.c     |    6 +++++-
 8 files changed, 44 insertions(+), 5 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 2403d64b4cc0..b45d670653cf 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -733,3 +733,4 @@ void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask) { }
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask) { }
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork) { }
+void xfs_btree_mark_sick(struct xfs_btree_cur *cur) { }
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 1894a0913807..aa084120c4c3 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -271,6 +271,7 @@ xfs_alloc_complain_bad_rec(
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", irec->ar_startblock,
 		irec->ar_blockcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -2698,6 +2699,7 @@ xfs_exact_minlen_extent_available(
 		goto out;
 
 	if (*stat == 0) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4d21720e9ac6..f15631818b3f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -362,6 +362,8 @@ xfs_bmap_check_leaf_extents(
 			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
 						XFS_BMAP_BTREE_REF,
 						&xfs_bmbt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(cur);
 			if (error)
 				goto error_norelse;
 		}
@@ -448,6 +450,8 @@ xfs_bmap_check_leaf_extents(
 			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
 						XFS_BMAP_BTREE_REF,
 						&xfs_bmbt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(cur);
 			if (error)
 				goto error_norelse;
 		}
@@ -562,6 +566,8 @@ xfs_bmap_btree_to_extents(
 #endif
 	error = xfs_btree_read_bufl(mp, tp, cbno, &cbp, XFS_BMAP_BTREE_REF,
 				&xfs_bmbt_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_btree_mark_sick(cur);
 	if (error)
 		return error;
 	cblock = XFS_BUF_TO_BLOCK(cbp);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 663439ec3e3f..359d3f99ecf3 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -24,6 +24,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_health.h"
 
 /*
  * Btree magic numbers.
@@ -174,6 +175,7 @@ xfs_btree_check_lblock(
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK)) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -240,6 +242,7 @@ xfs_btree_check_sblock(
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_SBLOCK)) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -315,6 +318,7 @@ xfs_btree_check_ptr(
 				level, index);
 	}
 
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -495,6 +499,8 @@ xfs_btree_dup_cursor(
 						   xfs_buf_daddr(bp), mp->m_bsize,
 						   0, &bp,
 						   cur->bc_ops->buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(new);
 			if (error) {
 				xfs_btree_del_cursor(new, error);
 				*ncur = NULL;
@@ -1348,6 +1354,8 @@ xfs_btree_read_buf_block(
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
 				   mp->m_bsize, flags, bpp,
 				   cur->bc_ops->buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_btree_mark_sick(cur);
 	if (error)
 		return error;
 
@@ -1658,6 +1666,7 @@ xfs_btree_increment(
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			goto out0;
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1751,6 +1760,7 @@ xfs_btree_decrement(
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			goto out0;
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1843,6 +1853,7 @@ xfs_btree_lookup_get_block(
 	*blkp = NULL;
 	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -1889,8 +1900,10 @@ xfs_btree_lookup(
 	XFS_BTREE_STATS_INC(cur, lookup);
 
 	/* No such thing as a zero-level tree. */
-	if (XFS_IS_CORRUPT(cur->bc_mp, cur->bc_nlevels == 0))
+	if (XFS_IS_CORRUPT(cur->bc_mp, cur->bc_nlevels == 0)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	block = NULL;
 	keyno = 0;
@@ -1933,6 +1946,7 @@ xfs_btree_lookup(
 							XFS_ERRLEVEL_LOW,
 							cur->bc_mp, block,
 							sizeof(*block));
+					xfs_btree_mark_sick(cur);
 					return -EFSCORRUPTED;
 				}
 
@@ -4366,12 +4380,16 @@ xfs_btree_visit_block(
 	 */
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
-							xfs_buf_daddr(bp)))
+							xfs_buf_daddr(bp))) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 	} else {
 		if (be32_to_cpu(rptr.s) == xfs_daddr_to_agbno(cur->bc_mp,
-							xfs_buf_daddr(bp)))
+							xfs_buf_daddr(bp))) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	return xfs_btree_lookup_get_block(cur, level, &rptr, &block);
 }
@@ -5230,6 +5248,7 @@ xfs_btree_goto_left_edge(
 		return error;
 	if (stat != 0) {
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 3c8fd060744f..8f566a78737f 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -37,6 +37,7 @@ struct xfs_mount;
 struct xfs_perag;
 struct xfs_inode;
 struct xfs_fsop_geom;
+struct xfs_btree_cur;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -160,6 +161,7 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 
 void xfs_health_unmount(struct xfs_mount *mp);
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
+void xfs_btree_mark_sick(struct xfs_btree_cur *cur);
 
 /* Now some helpers. */
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index c801250a33bf..92ca3d460e04 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -143,6 +143,7 @@ xfs_inobt_complain_bad_rec(
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
 		irec->ir_free, irec->ir_holemask);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 36dd06e63887..00df1e64ac6c 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -22,6 +22,7 @@
 #include "xfs_refcount.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -155,6 +156,7 @@ xfs_refcount_complain_bad_rec(
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -1888,8 +1890,10 @@ xfs_refcount_recover_extent(
 	struct xfs_refcount_recovery	*rr;
 
 	if (XFS_IS_CORRUPT(cur->bc_mp,
-			   be32_to_cpu(rec->refc.rc_refcount) != 1))
+			   be32_to_cpu(rec->refc.rc_refcount) != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	rr = kmalloc(sizeof(struct xfs_refcount_recovery),
 			GFP_KERNEL | __GFP_NOFAIL);
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index e7681c7c852d..8fbc9583de74 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -22,6 +22,7 @@
 #include "xfs_errortag.h"
 #include "xfs_inode.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -55,8 +56,10 @@ xfs_rmap_lookup_le(
 	error = xfs_rmap_get_rec(cur, irec, &get_stat);
 	if (error)
 		return error;
-	if (!get_stat)
+	if (!get_stat) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	return 0;
 }
@@ -276,6 +279,7 @@ xfs_rmap_complain_bad_rec(
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
 		irec->rm_blockcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 

