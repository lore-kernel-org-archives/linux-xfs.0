Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEEBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbiL3XiA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbiL3XiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:38:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4531DDDC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:37:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C27861C31
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B30C433D2;
        Fri, 30 Dec 2022 23:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443478;
        bh=Jl3sztrSdKh4ZsARm6QKLBvVQeYjJqVqNdDLRwyZCF0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ozIqflKfTSm2dZTyt4lDkH3FWQmcDLTrFw0SZ+Mz7x5D1fOCvB6x5sAt90giNukTx
         FtOQs48qHcohW6mK26fUabA4fohyn30+6J1JJzu2uFPyl/q3TA+4WfU9QnC29rINTi
         iI2gKHgDvzDwZJYoBdtGjz0f4jiSw2oI0WoSCOQS9vGhk4npI3TFiOxMpBcIvGvzTt
         8rbzbW83RNe1zCQhV2jNNF30uWDyErbMzAh5jBHqhw5t4NDszyvU6pAJADYmMeTlaz
         NrT/WauMWxaVor5l8MxcLrrnuG/87dZ2x/zvm+UcBz2ka1Y09mfMeJUXQCnQtk1VYJ
         nFFtwai7cAqSQ==
Subject: [PATCH 05/11] xfs: report btree block corruption errors to the health
 system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:15 -0800
Message-ID: <167243839531.695999.9653734380586905717.stgit@magnolia>
In-Reply-To: <167243839445.695999.12861421643354894719.stgit@magnolia>
References: <167243839445.695999.12861421643354894719.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 819a38170351..06562746fa75 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -287,6 +287,7 @@ xfs_alloc_complain_bad_rec(
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", irec->ar_startblock,
 		irec->ar_blockcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -2612,6 +2613,7 @@ xfs_exact_minlen_extent_available(
 		goto out;
 
 	if (*stat == 0) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index eb5b766a4d5a..de5d7b842145 100644
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
index b63650a5d690..2f0e8450268f 100644
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
 
@@ -4355,12 +4369,16 @@ xfs_btree_visit_block(
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
@@ -5219,6 +5237,7 @@ xfs_btree_goto_left_edge(
 		return error;
 	if (stat != 0) {
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 8936176c38f1..2ee06af82c5a 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -37,6 +37,7 @@ struct xfs_mount;
 struct xfs_perag;
 struct xfs_inode;
 struct xfs_fsop_geom;
+struct xfs_btree_cur;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -143,6 +144,7 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 
 void xfs_health_unmount(struct xfs_mount *mp);
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
+void xfs_btree_mark_sick(struct xfs_btree_cur *cur);
 
 /* Now some helpers. */
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0f5a4a591775..e93e15153686 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -158,6 +158,7 @@ xfs_inobt_complain_bad_rec(
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
 		irec->ir_free, irec->ir_holemask);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index bd4cd1c65221..e8eda50a1ee1 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -23,6 +23,7 @@
 #include "xfs_refcount.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -164,6 +165,7 @@ xfs_refcount_complain_bad_rec(
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -1891,8 +1893,10 @@ xfs_refcount_recover_extent(
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
index a9f13d877822..0d41d1256fd9 100644
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
index c60decd40e5e..89cd4d21065e 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -14,6 +14,7 @@
 #include "xfs_trace.h"
 #include "xfs_health.h"
 #include "xfs_ag.h"
+#include "xfs_btree.h"
 
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
@@ -487,3 +488,40 @@ xfs_bmap_mark_sick(
 
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

