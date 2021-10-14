Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC83C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6EF56105A
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhJNUUG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhJNUUG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:20:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38A0061027;
        Thu, 14 Oct 2021 20:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242681;
        bh=wRwvTgt+dCzmNLHMeDlXOgOvhl26M8ahr/XaCGu9Fsw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PEzs9xh0lYd/hpmvdYsSJFk487FBiL8a3d8MpI3cGxFDqIk+G1/p1insSsC9Pcja0
         JAA0HnHgrZvt23/C0JtibqXEC901PosJxTbnds0qS2//NyiGcBMp6K4GT+VS0X1QHq
         Y6ZY0zgTD4hjeShgxW8/nwuWMv5twtRPhlrm8najHB8FQonz90X3LDaf/w+aWWQodi
         dsNICmnzwlIeUeOudkwIwtZ5yhJnyHegNN3iAq1Yj6N/dzvt5tfr2KaoQmIIawu1Lz
         t3+HNeh65tZqjVa60MeG1a9TtJVfo20f81QlY7fhTs38IfueSX0ZxriPndE+iGYRzd
         ixqYvPj+Htkkg==
Subject: [PATCH 12/17] xfs: compute maximum AG btree height for critical
 reservation calculation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:18:00 -0700
Message-ID: <163424268093.756780.1167437160420772989.stgit@magnolia>
In-Reply-To: <163424261462.756780.16294781570977242370.stgit@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Compute the actual maximum AG btree height for deciding if a per-AG
block reservation is critically low.  This only affects the sanity check
condition, since we /generally/ will trigger on the 10% threshold.  This
is a long-winded way of saying that we're removing one more usage of
XFS_BTREE_MAXLEVELS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag_resv.c |    3 ++-
 fs/xfs/xfs_mount.c          |   14 ++++++++++++++
 fs/xfs/xfs_mount.h          |    1 +
 3 files changed, 17 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 2aa2b3484c28..fe94058d4e9e 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -91,7 +91,8 @@ xfs_ag_resv_critical(
 	trace_xfs_ag_resv_critical(pag, type, avail);
 
 	/* Critically low if less than 10% or max btree height remains. */
-	return XFS_TEST_ERROR(avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS,
+	return XFS_TEST_ERROR(avail < orig / 10 ||
+			      avail < pag->pag_mount->m_agbtree_maxlevels,
 			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL);
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 06dac09eddbd..5be1dd63fac5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -567,6 +567,18 @@ xfs_mount_setup_inode_geom(
 	xfs_ialloc_setup_geometry(mp);
 }
 
+/* Compute maximum possible height for per-AG btree types for this fs. */
+static inline void
+xfs_agbtree_compute_maxlevels(
+	struct xfs_mount	*mp)
+{
+	unsigned int		ret;
+
+	ret = max(mp->m_alloc_maxlevels, M_IGEO(mp)->inobt_maxlevels);
+	ret = max(ret, mp->m_rmap_maxlevels);
+	mp->m_agbtree_maxlevels = max(ret, mp->m_refc_maxlevels);
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -638,6 +650,8 @@ xfs_mountfs(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
+	xfs_agbtree_compute_maxlevels(mp);
+
 	/*
 	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
 	 * is NOT aligned turn off m_dalign since allocator alignment is within
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e4b7a8eb0d06..00720a02e761 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -132,6 +132,7 @@ typedef struct xfs_mount {
 	uint			m_bm_maxlevels[2]; /* max bmap btree levels */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_refc_maxlevels; /* max refcount btree level */
+	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */

