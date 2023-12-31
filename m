Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC2FB671
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6h+htMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA1FC433C7;
	Sun, 31 Dec 2023 20:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053458;
	bh=ZgnbGE+ktPvNCSrkTEQLzsxYCqdJPbYBxD63mTG7uhk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z6h+htMY+V0GTd3xyOzio7nOdgAXgJOJOBlu6/59GQz0TECrBkjHBTmRP9//0FAzP
	 PAfDOXN/HyBSsfnILvRzujmIWRCo4dTGQWu78e2VKLN6ylJoqEd46yfm4VU5lTvQ08
	 wjbNKDPAnqYhHpGEXAq5Zfqar3BCKmnJ5sMVv/01l7wuFuTJkzUfq9G2UPLLF9PZcy
	 +6mRyzoUSgf0hjhasNA8M53B9a9bJr36me5EyeBUK++Lytz9Z40/f5a94/+RFyztBj
	 psTZZ0mcUb5h8Dui8rbnW+0FxtykZoLCcJfWzqQHfvjE6CVx1BIKLnYBDqEh2epNR4
	 gEe424M8GfA5g==
Date: Sun, 31 Dec 2023 12:10:57 -0800
Subject: [PATCH 05/11] xfs: report btree block corruption errors to the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828360.1748329.15413546748362572852.stgit@frogsfrogsfrogs>
In-Reply-To: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
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

Whenever we encounter corrupt btree blocks, we should report that to the
health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c    |    2 ++
 fs/xfs/libxfs/xfs_bmap.c     |    6 ++++++
 fs/xfs/libxfs/xfs_btree.c    |   25 ++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_health.h   |    2 ++
 fs/xfs/libxfs/xfs_ialloc.c   |    1 +
 fs/xfs/libxfs/xfs_refcount.c |    6 +++++-
 fs/xfs/libxfs/xfs_rmap.c     |    6 +++++-
 fs/xfs/xfs_health.c          |   38 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 81 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1cb2569c43cfc..2464b64b1cb4e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -275,6 +275,7 @@ xfs_alloc_complain_bad_rec(
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", irec->ar_startblock,
 		irec->ar_blockcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -2702,6 +2703,7 @@ xfs_exact_minlen_extent_available(
 		goto out;
 
 	if (*stat == 0) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 752e424600807..61918ca34658b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -368,6 +368,8 @@ xfs_bmap_check_leaf_extents(
 			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
 						XFS_BMAP_BTREE_REF,
 						&xfs_bmbt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(cur);
 			if (error)
 				goto error_norelse;
 		}
@@ -454,6 +456,8 @@ xfs_bmap_check_leaf_extents(
 			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
 						XFS_BMAP_BTREE_REF,
 						&xfs_bmbt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(cur);
 			if (error)
 				goto error_norelse;
 		}
@@ -568,6 +572,8 @@ xfs_bmap_btree_to_extents(
 #endif
 	error = xfs_btree_read_bufl(mp, tp, cbno, &cbp, XFS_BMAP_BTREE_REF,
 				&xfs_bmbt_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_btree_mark_sick(cur);
 	if (error)
 		return error;
 	cblock = XFS_BUF_TO_BLOCK(cbp);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index ea8d3659df208..51d0a569e8216 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -27,6 +27,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_health.h"
 
 /*
  * Btree magic numbers.
@@ -177,6 +178,7 @@ xfs_btree_check_lblock(
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK)) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -243,6 +245,7 @@ xfs_btree_check_sblock(
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_SBLOCK)) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -318,6 +321,7 @@ xfs_btree_check_ptr(
 				level, index);
 	}
 
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -498,6 +502,8 @@ xfs_btree_dup_cursor(
 						   xfs_buf_daddr(bp), mp->m_bsize,
 						   0, &bp,
 						   cur->bc_ops->buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(new);
 			if (error) {
 				xfs_btree_del_cursor(new, error);
 				*ncur = NULL;
@@ -1351,6 +1357,8 @@ xfs_btree_read_buf_block(
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
 				   mp->m_bsize, flags, bpp,
 				   cur->bc_ops->buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_btree_mark_sick(cur);
 	if (error)
 		return error;
 
@@ -1661,6 +1669,7 @@ xfs_btree_increment(
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			goto out0;
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1754,6 +1763,7 @@ xfs_btree_decrement(
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			goto out0;
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1846,6 +1856,7 @@ xfs_btree_lookup_get_block(
 	*blkp = NULL;
 	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -1892,8 +1903,10 @@ xfs_btree_lookup(
 	XFS_BTREE_STATS_INC(cur, lookup);
 
 	/* No such thing as a zero-level tree. */
-	if (XFS_IS_CORRUPT(cur->bc_mp, cur->bc_nlevels == 0))
+	if (XFS_IS_CORRUPT(cur->bc_mp, cur->bc_nlevels == 0)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	block = NULL;
 	keyno = 0;
@@ -1936,6 +1949,7 @@ xfs_btree_lookup(
 							XFS_ERRLEVEL_LOW,
 							cur->bc_mp, block,
 							sizeof(*block));
+					xfs_btree_mark_sick(cur);
 					return -EFSCORRUPTED;
 				}
 
@@ -4369,12 +4383,16 @@ xfs_btree_visit_block(
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
@@ -5233,6 +5251,7 @@ xfs_btree_goto_left_edge(
 		return error;
 	if (stat != 0) {
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 50515920c9578..0876c767d9ddc 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -37,6 +37,7 @@ struct xfs_mount;
 struct xfs_perag;
 struct xfs_inode;
 struct xfs_fsop_geom;
+struct xfs_btree_cur;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -153,6 +154,7 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 
 void xfs_health_unmount(struct xfs_mount *mp);
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
+void xfs_btree_mark_sick(struct xfs_btree_cur *cur);
 
 /* Now some helpers. */
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 2531b4c08915d..91584e96f05f6 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -148,6 +148,7 @@ xfs_inobt_complain_bad_rec(
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
 		irec->ir_free, irec->ir_holemask);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 6709a7f8bad5a..91f1066f408b9 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -23,6 +23,7 @@
 #include "xfs_refcount.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -156,6 +157,7 @@ xfs_refcount_complain_bad_rec(
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -1889,8 +1891,10 @@ xfs_refcount_recover_extent(
 	struct xfs_refcount_recovery	*rr;
 
 	if (XFS_IS_CORRUPT(cur->bc_mp,
-			   be32_to_cpu(rec->refc.rc_refcount) != 1))
+			   be32_to_cpu(rec->refc.rc_refcount) != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	rr = kmalloc(sizeof(struct xfs_refcount_recovery),
 			GFP_KERNEL | __GFP_NOFAIL);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 76bf7f48cb5ac..76a2e47b8a8ee 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -23,6 +23,7 @@
 #include "xfs_error.h"
 #include "xfs_inode.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -56,8 +57,10 @@ xfs_rmap_lookup_le(
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
@@ -277,6 +280,7 @@ xfs_rmap_complain_bad_rec(
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
 		irec->rm_blockcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 9a86c1491e28e..27a27e27a2316 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -14,6 +14,7 @@
 #include "xfs_trace.h"
 #include "xfs_health.h"
 #include "xfs_ag.h"
+#include "xfs_btree.h"
 
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
@@ -491,3 +492,40 @@ xfs_bmap_mark_sick(
 
 	xfs_inode_mark_sick(ip, mask);
 }
+
+/* Record observations of btree corruption with the health tracking system. */
+void
+xfs_btree_mark_sick(
+	struct xfs_btree_cur		*cur)
+{
+	unsigned int			mask;
+
+	switch (cur->bc_btnum) {
+	case XFS_BTNUM_BMAP:
+		xfs_bmap_mark_sick(cur->bc_ino.ip, cur->bc_ino.whichfork);
+		return;
+	case XFS_BTNUM_BNO:
+		mask = XFS_SICK_AG_BNOBT;
+		break;
+	case XFS_BTNUM_CNT:
+		mask = XFS_SICK_AG_CNTBT;
+		break;
+	case XFS_BTNUM_INO:
+		mask = XFS_SICK_AG_INOBT;
+		break;
+	case XFS_BTNUM_FINO:
+		mask = XFS_SICK_AG_FINOBT;
+		break;
+	case XFS_BTNUM_RMAP:
+		mask = XFS_SICK_AG_RMAPBT;
+		break;
+	case XFS_BTNUM_REFC:
+		mask = XFS_SICK_AG_REFCNTBT;
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
+
+	xfs_ag_mark_sick(cur->bc_ag.pag, mask);
+}

