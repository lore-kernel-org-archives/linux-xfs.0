Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEB8C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60BBB60E05
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhIOXNG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXNF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:13:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A32060E94;
        Wed, 15 Sep 2021 23:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747506;
        bh=mkPmqEU6QASmCeP4gcDgTLL7POsMBTp/F4JxFKP1oHo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kIxg33ZX41y0Wy3AsDQrHH4gzUfBExMhjwoBBJIVtyplVcKChBZLlNNra1LuSbvuj
         afnnsQEkcqy6zhtiCDxS3oH2fPm8GHklsyW43ISMEzaqIRUx6b/XjxFy5wKVXRuFw6
         dubyDWDGHOZriGYGfIDgQ8DkkzoDOXyVqtUSGnwvUTZn1A9+bS0uqFrBqvCKg4kmhY
         fH1lbXT1G/THJNGGf2Ljw2uqqnGH+nd3zeqslFc0hzMhG5zTSSV076ZByAbCyvEwe8
         UMztGBXN2mqNq2jQO6Bl+euDxksbcFR46ysbBtuTVRw0Rs55HmTg4V2xW6e8iUSyry
         jbuoqvovSeERg==
Subject: [PATCH 57/61] xfs: check for sparse inode clusters that cross new
 EOAG when shrinking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:11:46 -0700
Message-ID: <163174750598.350433.11459974162471296201.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: da062d16a897c0759ae907e786bc0bea950c0c9d

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
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.c     |    8 +++++++
 libxfs/xfs_ialloc.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ialloc.h |    3 +++
 3 files changed, 66 insertions(+)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 3e78d253..9eda6eba 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -801,6 +801,14 @@ xfs_ag_shrink_space(
 
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
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 4d297a90..570349b8 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2923,3 +2923,58 @@ xfs_ialloc_calc_rootino(
 
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
+	struct xfs_perag	*pag;
+	xfs_agino_t		agino = XFS_AGB_TO_AGINO(mp, new_length);
+	int			has;
+	int			error;
+
+	if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
+		return 0;
+
+	pag = xfs_perag_get(mp, agno);
+	cur = xfs_inobt_init_cursor(mp, tp, agibp, pag, XFS_BTNUM_INO);
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
+	xfs_perag_put(pag);
+	return error;
+}
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 9df7c804..9a2112b4 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -122,4 +122,7 @@ int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
 xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
 
+int xfs_ialloc_check_shrink(struct xfs_trans *tp, xfs_agnumber_t agno,
+		struct xfs_buf *agibp, xfs_agblock_t new_length);
+
 #endif	/* __XFS_IALLOC_H__ */

