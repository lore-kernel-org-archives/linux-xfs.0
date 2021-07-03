Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D61C07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 03:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEEDB61416
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 03:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhGCDEa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhGCDEa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96C5D61416
        for <linux-xfs@vger.kernel.org>; Sat,  3 Jul 2021 03:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281317;
        bh=rQrObjOgMFM8RrohrVEnRyyX7wUq4Kjy6JtRyI7DpTo=;
        h=Date:From:To:Subject:From;
        b=JAZRAfxzQA+3QtPX47RUEPNu7ybJ7NX6HDtmoFd7F89P1LN3B53tDJmt8CJrBNis5
         kuZJllkRWtn/9FKfAgCg+PI2q8G/df9RRi0apYdteI9gIx0PLcmScBwsIMgW1lyNi1
         BFQy+vujF/3FQ17h6rS4w/nPpHaJbhX+nU/ZFmYyiKJxTZzqhc5zw4n4WBo/S6m6cz
         IduPIVG4qd9aDCDocIEsXjZHhOyplxnvTiTJMcplRoYofILfD1BrFbU+PypuBmfJfE
         rnvKAbgcJQfo9rH7e17w1zCs9Xa67pHe+qwM5iktM5hEY7yndZSdycwPLsTPPS7kAm
         mzeEsipprOzwA==
Date:   Fri, 2 Jul 2021 20:01:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: check for sparse inode clusters that cross new EOAG
 when shrinking
Message-ID: <20210703030157.GC24788@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running xfs/168, I noticed occasional write verifier shutdowns
involving inodes at the very end of the filesystem.  Existing inode
btree validation code checks that all inode clusters are fully contained
within the filesystem.

However, due to inadequate checking in the fs shrink code, it's possible
that there could be a sparse inode cluster at the end of the filesystem
where the upper inodes of the cluster are marked as holes and the
corresponding blocks are free.  In this case, the last blocks in the AG
are listed in the bnobt.  This enables the shrink to proceed but results
in a filesystem that trips the inode verifiers.  Fix this by disallowing
the shrink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c     |    8 +++++++
 fs/xfs/libxfs/xfs_ialloc.c |   52 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |    3 +++
 3 files changed, 63 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index dcd8c8f7cd4a..376e4bb0e4ec 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -815,6 +815,14 @@ xfs_ag_shrink_space(
 
 	args.fsbno = XFS_AGB_TO_FSB(mp, agno, aglen - delta);
 
+	/*
+	 * Make sure that the last inode cluster cannot overlap with the new
+	 * end of the AG, even if it's sparse.
+	 */
+	error = xfs_ialloc_check_shrink(*tpp, agno, agibp, aglen - delta);
+	if (error)
+		return error;
+
 	/*
 	 * Disable perag reservations so it doesn't cause the allocation request
 	 * to fail. We'll reestablish reservation before we return.
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 57d9cb632983..90c4afecf7ba 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2928,3 +2928,55 @@ xfs_ialloc_calc_rootino(
 
 	return XFS_AGINO_TO_INO(mp, 0, XFS_AGB_TO_AGINO(mp, first_bno));
 }
+
+/*
+ * Ensure there are not sparse inode clusters that cross the new EOAG.
+ *
+ * This is a no-op for non-spinode filesystems since clusters are always fully
+ * allocated and checking the bnobt suffices.  However, a spinode filesystem
+ * could have a record where the upper inodes are free blocks.  If those blocks
+ * were removed from the filesystem, the inode record would extend beyond EOAG,
+ * which will be flagged as corruption.
+ */
+int
+xfs_ialloc_check_shrink(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		*agibp,
+	xfs_agblock_t		new_length)
+{
+	struct xfs_inobt_rec_incore rec;
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_agino_t		agino = XFS_AGB_TO_AGINO(mp, new_length);
+	int			has;
+	int			error;
+
+	if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
+		return 0;
+
+	cur = xfs_inobt_init_cursor(mp, tp, agibp, agno, XFS_BTNUM_INO);
+
+	/* Look up the inobt record that would correspond to the new EOFS. */
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has);
+	if (error || !has)
+		goto out;
+
+	error = xfs_inobt_get_rec(cur, &rec, &has);
+	if (error)
+		goto out;
+
+	if (!has) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	/* If the record covers inodes that would be beyond EOFS, bail out. */
+	if (rec.ir_startino + XFS_INODES_PER_CHUNK > agino) {
+		error = -ENOSPC;
+		goto out;
+	}
+out:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 9df7c80408ff..9a2112b4ad5e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -122,4 +122,7 @@ int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
 xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
 
+int xfs_ialloc_check_shrink(struct xfs_trans *tp, xfs_agnumber_t agno,
+		struct xfs_buf *agibp, xfs_agblock_t new_length);
+
 #endif	/* __XFS_IALLOC_H__ */
