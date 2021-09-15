Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA87FC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD33D610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhIOXJz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232774AbhIOXJy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:09:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 157E5600D4;
        Wed, 15 Sep 2021 23:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747315;
        bh=gHqS9h2IKMtSsalCTEZ5rtcKpyqrhj6L8COfbVw2fu8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W6PgTxthxdea8m/7KwS5ZB+tt4Dof98eIcHfs3DMxby941noEG5DXwFL0PEKvdCEy
         v23OZkvd2ISeLpOoujqu8iIev/Md5n1fQIagFRPZAS/V2giz2iWBdqodY8DVQpL3Zj
         zrkCDLOQYhsbKIO39QtvhoeURcDXzPAaVp5/JxvSxMj6QFfCwo8v/I0V/3kh3+41GJ
         89Oa1+75ppCiE1t8IceYn0dWprlzV5JLAcH8ORdGwD7X/yG1Uvt9NC4khDvudvea5m
         MpUBKSFy9v+mljf1wyL1UyKA+Muk2iAPMW5fvw0aNyqZbjn6kDLC86syUCn3szE3tu
         c4a5ejkOtL1vQ==
Subject: [PATCH 22/61] xfs: move xfs_perag_get/put to xfs_ag.[ch]
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:08:34 -0700
Message-ID: <163174731479.350433.9205532969441344322.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 9bbafc71919adfdf83fafd2ce909853b493e7d86

They are AG functions, not superblock functions, so move them to the
appropriate location.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.c             |  135 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ag.h             |   10 +++
 libxfs/xfs_ag_resv.c        |    2 -
 libxfs/xfs_alloc.c          |    2 -
 libxfs/xfs_alloc_btree.c    |    2 -
 libxfs/xfs_attr_leaf.c      |    1 
 libxfs/xfs_bmap.c           |    1 
 libxfs/xfs_ialloc.c         |    2 -
 libxfs/xfs_refcount_btree.c |    2 -
 libxfs/xfs_rmap.c           |    1 
 libxfs/xfs_rmap_btree.c     |    2 -
 libxfs/xfs_sb.c             |  133 ------------------------------------------
 libxfs/xfs_sb.h             |    9 ---
 13 files changed, 154 insertions(+), 148 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index b94ad5c3..46e78b0e 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -26,6 +26,141 @@
 #include "xfs_defer.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
+#include "xfs_trace.h"
+
+/*
+ * Passive reference counting access wrappers to the perag structures.  If the
+ * per-ag structure is to be freed, the freeing code is responsible for cleaning
+ * up objects with passive references before freeing the structure. This is
+ * things like cached buffers.
+ */
+struct xfs_perag *
+xfs_perag_get(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_perag	*pag;
+	int			ref = 0;
+
+	rcu_read_lock();
+	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
+	if (pag) {
+		ASSERT(atomic_read(&pag->pag_ref) >= 0);
+		ref = atomic_inc_return(&pag->pag_ref);
+	}
+	rcu_read_unlock();
+	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
+	return pag;
+}
+
+/*
+ * search from @first to find the next perag with the given tag set.
+ */
+struct xfs_perag *
+xfs_perag_get_tag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		first,
+	int			tag)
+{
+	struct xfs_perag	*pag;
+	int			found;
+	int			ref;
+
+	rcu_read_lock();
+	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
+					(void **)&pag, first, 1, tag);
+	if (found <= 0) {
+		rcu_read_unlock();
+		return NULL;
+	}
+	ref = atomic_inc_return(&pag->pag_ref);
+	rcu_read_unlock();
+	trace_xfs_perag_get_tag(mp, pag->pag_agno, ref, _RET_IP_);
+	return pag;
+}
+
+void
+xfs_perag_put(
+	struct xfs_perag	*pag)
+{
+	int	ref;
+
+	ASSERT(atomic_read(&pag->pag_ref) > 0);
+	ref = atomic_dec_return(&pag->pag_ref);
+	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
+}
+
+/*
+ * xfs_initialize_perag_data
+ *
+ * Read in each per-ag structure so we can count up the number of
+ * allocated inodes, free inodes and used filesystem blocks as this
+ * information is no longer persistent in the superblock. Once we have
+ * this information, write it into the in-core superblock structure.
+ */
+int
+xfs_initialize_perag_data(
+	struct xfs_mount *mp,
+	xfs_agnumber_t	agcount)
+{
+	xfs_agnumber_t	index;
+	xfs_perag_t	*pag;
+	xfs_sb_t	*sbp = &mp->m_sb;
+	uint64_t	ifree = 0;
+	uint64_t	ialloc = 0;
+	uint64_t	bfree = 0;
+	uint64_t	bfreelst = 0;
+	uint64_t	btree = 0;
+	uint64_t	fdblocks;
+	int		error = 0;
+
+	for (index = 0; index < agcount; index++) {
+		/*
+		 * read the agf, then the agi. This gets us
+		 * all the information we need and populates the
+		 * per-ag structures for us.
+		 */
+		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
+		if (error)
+			return error;
+
+		error = xfs_ialloc_pagi_init(mp, NULL, index);
+		if (error)
+			return error;
+		pag = xfs_perag_get(mp, index);
+		ifree += pag->pagi_freecount;
+		ialloc += pag->pagi_count;
+		bfree += pag->pagf_freeblks;
+		bfreelst += pag->pagf_flcount;
+		btree += pag->pagf_btreeblks;
+		xfs_perag_put(pag);
+	}
+	fdblocks = bfree + bfreelst + btree;
+
+	/*
+	 * If the new summary counts are obviously incorrect, fail the
+	 * mount operation because that implies the AGFs are also corrupt.
+	 * Clear FS_COUNTERS so that we don't unmount with a dirty log, which
+	 * will prevent xfs_repair from fixing anything.
+	 */
+	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
+		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	/* Overwrite incore superblock counters with just-read data */
+	spin_lock(&mp->m_sb_lock);
+	sbp->sb_ifree = ifree;
+	sbp->sb_icount = ialloc;
+	sbp->sb_fdblocks = fdblocks;
+	spin_unlock(&mp->m_sb_lock);
+
+	xfs_reinit_percpu_counters(mp);
+out:
+	xfs_fs_mark_healthy(mp, XFS_SICK_FS_COUNTERS);
+	return error;
+}
 
 static int
 xfs_get_aghdr_buf(
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 4535de1d..cb1bd1c0 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -9,6 +9,16 @@
 
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_perag;
+
+/*
+ * perag get/put wrappers for ref counting
+ */
+int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
+struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
+struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
+				   int tag);
+void	xfs_perag_put(struct xfs_perag *pag);
 
 struct aghdr_init_data {
 	/* per ag data */
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 7d426d08..34ab68c0 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -18,7 +18,7 @@
 #include "xfs_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_ialloc_btree.h"
-#include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
 /*
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 300a91f8..37f10751 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -10,7 +10,6 @@
 #include "xfs_shared.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_btree.h"
@@ -20,6 +19,7 @@
 #include "xfs_errortag.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 4611ed0f..fa1d3a0f 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -9,7 +9,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
@@ -17,6 +16,7 @@
 #include "xfs_alloc.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_ag.h"
 
 
 STATIC struct xfs_btree_cur *
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 08600ea8..1df9d63f 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -24,6 +24,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_trace.h"
 #include "xfs_dir2.h"
+#include "xfs_ag.h"
 
 
 /*
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1c8706a7..0809922e 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -26,6 +26,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_quota_defs.h"
 #include "xfs_rmap.h"
+#include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b1646a35..745daafb 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -10,7 +10,6 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
@@ -22,6 +21,7 @@
 #include "xfs_trans.h"
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
+#include "xfs_ag.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index eb48197b..5344b282 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -9,7 +9,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
@@ -19,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_bit.h"
 #include "xfs_rmap.h"
+#include "xfs_ag.h"
 
 static struct xfs_btree_cur *
 xfs_refcountbt_dup_cursor(
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 263ef27b..631c62c0 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -20,6 +20,7 @@
 #include "xfs_trace.h"
 #include "xfs_errortag.h"
 #include "xfs_inode.h"
+#include "xfs_ag.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 9e9858e6..bcbe9833 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -9,7 +9,6 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
-#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
@@ -18,6 +17,7 @@
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_trace.h"
+#include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
 /*
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 345635aa..ec08fd13 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -27,67 +27,6 @@
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
  */
 
-/*
- * Reference counting access wrappers to the perag structures.
- * Because we never free per-ag structures, the only thing we
- * have to protect against changes is the tree structure itself.
- */
-struct xfs_perag *
-xfs_perag_get(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	struct xfs_perag	*pag;
-	int			ref = 0;
-
-	rcu_read_lock();
-	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
-	if (pag) {
-		ASSERT(atomic_read(&pag->pag_ref) >= 0);
-		ref = atomic_inc_return(&pag->pag_ref);
-	}
-	rcu_read_unlock();
-	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
-	return pag;
-}
-
-/*
- * search from @first to find the next perag with the given tag set.
- */
-struct xfs_perag *
-xfs_perag_get_tag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		first,
-	int			tag)
-{
-	struct xfs_perag	*pag;
-	int			found;
-	int			ref;
-
-	rcu_read_lock();
-	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
-					(void **)&pag, first, 1, tag);
-	if (found <= 0) {
-		rcu_read_unlock();
-		return NULL;
-	}
-	ref = atomic_inc_return(&pag->pag_ref);
-	rcu_read_unlock();
-	trace_xfs_perag_get_tag(mp, pag->pag_agno, ref, _RET_IP_);
-	return pag;
-}
-
-void
-xfs_perag_put(
-	struct xfs_perag	*pag)
-{
-	int	ref;
-
-	ASSERT(atomic_read(&pag->pag_ref) > 0);
-	ref = atomic_dec_return(&pag->pag_ref);
-	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
-}
-
 /* Check all the superblock fields we care about when reading one in. */
 STATIC int
 xfs_validate_sb_read(
@@ -838,78 +777,6 @@ xfs_sb_mount_common(
 	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
 }
 
-/*
- * xfs_initialize_perag_data
- *
- * Read in each per-ag structure so we can count up the number of
- * allocated inodes, free inodes and used filesystem blocks as this
- * information is no longer persistent in the superblock. Once we have
- * this information, write it into the in-core superblock structure.
- */
-int
-xfs_initialize_perag_data(
-	struct xfs_mount *mp,
-	xfs_agnumber_t	agcount)
-{
-	xfs_agnumber_t	index;
-	xfs_perag_t	*pag;
-	xfs_sb_t	*sbp = &mp->m_sb;
-	uint64_t	ifree = 0;
-	uint64_t	ialloc = 0;
-	uint64_t	bfree = 0;
-	uint64_t	bfreelst = 0;
-	uint64_t	btree = 0;
-	uint64_t	fdblocks;
-	int		error = 0;
-
-	for (index = 0; index < agcount; index++) {
-		/*
-		 * read the agf, then the agi. This gets us
-		 * all the information we need and populates the
-		 * per-ag structures for us.
-		 */
-		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
-		if (error)
-			return error;
-
-		error = xfs_ialloc_pagi_init(mp, NULL, index);
-		if (error)
-			return error;
-		pag = xfs_perag_get(mp, index);
-		ifree += pag->pagi_freecount;
-		ialloc += pag->pagi_count;
-		bfree += pag->pagf_freeblks;
-		bfreelst += pag->pagf_flcount;
-		btree += pag->pagf_btreeblks;
-		xfs_perag_put(pag);
-	}
-	fdblocks = bfree + bfreelst + btree;
-
-	/*
-	 * If the new summary counts are obviously incorrect, fail the
-	 * mount operation because that implies the AGFs are also corrupt.
-	 * Clear FS_COUNTERS so that we don't unmount with a dirty log, which
-	 * will prevent xfs_repair from fixing anything.
-	 */
-	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
-		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
-		error = -EFSCORRUPTED;
-		goto out;
-	}
-
-	/* Overwrite incore superblock counters with just-read data */
-	spin_lock(&mp->m_sb_lock);
-	sbp->sb_ifree = ifree;
-	sbp->sb_icount = ialloc;
-	sbp->sb_fdblocks = fdblocks;
-	spin_unlock(&mp->m_sb_lock);
-
-	xfs_reinit_percpu_counters(mp);
-out:
-	xfs_fs_mark_healthy(mp, XFS_SICK_FS_COUNTERS);
-	return error;
-}
-
 /*
  * xfs_log_sb() can be used to copy arbitrary changes to the in-core superblock
  * into the superblock buffer to be logged.  It does not provide the higher
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index f79f9dc6..0c1602d9 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -13,15 +13,6 @@ struct xfs_trans;
 struct xfs_fsop_geom;
 struct xfs_perag;
 
-/*
- * perag get/put wrappers for ref counting
- */
-extern struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
-extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
-					   int tag);
-extern void	xfs_perag_put(struct xfs_perag *pag);
-extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
-
 extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
 extern int	xfs_sync_sb_buf(struct xfs_mount *mp);

