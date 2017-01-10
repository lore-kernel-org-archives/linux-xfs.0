Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35084 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758301AbdAJNxv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 08:53:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 202/206] xfs: use the actual AG length when reserving blocks
Date: Tue, 10 Jan 2017 14:38:05 +0100
Message-Id: <20170110131512.359843124@linuxfoundation.org>
In-Reply-To: <20170110131502.767555407@linuxfoundation.org>
References: <20170110131502.767555407@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 20e73b000bcded44a91b79429d8fa743247602ad upstream.

We need to use the actual AG length when making per-AG reservations,
since we could otherwise end up reserving more blocks out of the last
AG than there are actual blocks.

Complained-about-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag_resv.c        |    3 +++
 fs/xfs/libxfs/xfs_refcount_btree.c |    9 ++++++---
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 ++-
 fs/xfs/libxfs/xfs_rmap_btree.c     |   14 +++++++-------
 fs/xfs/libxfs/xfs_rmap_btree.h     |    3 ++-
 fs/xfs/xfs_fsops.c                 |   14 ++++++++++++++
 6 files changed, 34 insertions(+), 12 deletions(-)

--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -256,6 +256,9 @@ xfs_ag_resv_init(
 			goto out;
 	}
 
+	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
+	       xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->ar_reserved <=
+	       pag->pagf_freeblks + pag->pagf_flcount);
 out:
 	return error;
 }
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -408,13 +408,14 @@ xfs_refcountbt_calc_size(
  */
 xfs_extlen_t
 xfs_refcountbt_max_size(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	xfs_agblock_t		agblocks)
 {
 	/* Bail out if we're uninitialized, which can happen in mkfs. */
 	if (mp->m_refc_mxr[0] == 0)
 		return 0;
 
-	return xfs_refcountbt_calc_size(mp, mp->m_sb.sb_agblocks);
+	return xfs_refcountbt_calc_size(mp, agblocks);
 }
 
 /*
@@ -429,22 +430,24 @@ xfs_refcountbt_calc_reserves(
 {
 	struct xfs_buf		*agbp;
 	struct xfs_agf		*agf;
+	xfs_agblock_t		agblocks;
 	xfs_extlen_t		tree_len;
 	int			error;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return 0;
 
-	*ask += xfs_refcountbt_max_size(mp);
 
 	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
 	if (error)
 		return error;
 
 	agf = XFS_BUF_TO_AGF(agbp);
+	agblocks = be32_to_cpu(agf->agf_length);
 	tree_len = be32_to_cpu(agf->agf_refcount_blocks);
 	xfs_buf_relse(agbp);
 
+	*ask += xfs_refcountbt_max_size(mp, agblocks);
 	*used += tree_len;
 
 	return error;
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -66,7 +66,8 @@ extern void xfs_refcountbt_compute_maxle
 
 extern xfs_extlen_t xfs_refcountbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
-extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp);
+extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp,
+		xfs_agblock_t agblocks);
 
 extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
 		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -549,13 +549,14 @@ xfs_rmapbt_calc_size(
  */
 xfs_extlen_t
 xfs_rmapbt_max_size(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	xfs_agblock_t		agblocks)
 {
 	/* Bail out if we're uninitialized, which can happen in mkfs. */
 	if (mp->m_rmap_mxr[0] == 0)
 		return 0;
 
-	return xfs_rmapbt_calc_size(mp, mp->m_sb.sb_agblocks);
+	return xfs_rmapbt_calc_size(mp, agblocks);
 }
 
 /*
@@ -570,25 +571,24 @@ xfs_rmapbt_calc_reserves(
 {
 	struct xfs_buf		*agbp;
 	struct xfs_agf		*agf;
-	xfs_extlen_t		pool_len;
+	xfs_agblock_t		agblocks;
 	xfs_extlen_t		tree_len;
 	int			error;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	/* Reserve 1% of the AG or enough for 1 block per record. */
-	pool_len = max(mp->m_sb.sb_agblocks / 100, xfs_rmapbt_max_size(mp));
-	*ask += pool_len;
-
 	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
 	if (error)
 		return error;
 
 	agf = XFS_BUF_TO_AGF(agbp);
+	agblocks = be32_to_cpu(agf->agf_length);
 	tree_len = be32_to_cpu(agf->agf_rmap_blocks);
 	xfs_buf_relse(agbp);
 
+	/* Reserve 1% of the AG or enough for 1 block per record. */
+	*ask += max(agblocks / 100, xfs_rmapbt_max_size(mp, agblocks));
 	*used += tree_len;
 
 	return error;
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -60,7 +60,8 @@ extern void xfs_rmapbt_compute_maxlevels
 
 extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
-extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp);
+extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp,
+		xfs_agblock_t agblocks);
 
 extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp,
 		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -631,6 +631,20 @@ xfs_growfs_data_private(
 	xfs_set_low_space_thresholds(mp);
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
+	/*
+	 * If we expanded the last AG, free the per-AG reservation
+	 * so we can reinitialize it with the new size.
+	 */
+	if (new) {
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, agno);
+		error = xfs_ag_resv_free(pag);
+		xfs_perag_put(pag);
+		if (error)
+			goto out;
+	}
+
 	/* Reserve AG metadata blocks. */
 	error = xfs_fs_reserve_ag_blocks(mp);
 	if (error && error != -ENOSPC)


