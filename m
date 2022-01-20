Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E922C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345290AbiATAZL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345343AbiATAZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:25:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE96C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:25:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0C6361518
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEF7C004E1;
        Thu, 20 Jan 2022 00:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638308;
        bh=zfIjo2AYK3h2apZJv7sKGAeIJpwLOPVFWfVYLpStuaw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ojs2jSi6vxIJ7opnT7sOpTY+7i4NndURL1sBWV7P2q56YzAw41y1VtoDLxNPESQnk
         CN/GA+fVDejHzZ3+zerBO/niUFsf0sqWBZC3/sQrHEhAEamec46BbRLhKNe5C40KRj
         qSLrLSvW2FMVtI+V94VZcUTU6XDY3J/VoCWZqqnEHBWCE/9rIjk8wMnwe9DgFZrPaO
         ijsqSlHeV8X7NpPbDMzeWw4wnMhthO2Vhuezw9m7jogh9asBFMvSvOG9pAlctSa852
         VXilVxZtzgCSHJW3E8k6vAWg2aVrPsLHdULf+uWB8e8HYdAvZxZ+sp2YY2Z9E0esvE
         svjndjqmOLgvw==
Subject: [PATCH 21/48] xfs: compute maximum AG btree height for critical
 reservation calculation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:25:07 -0800
Message-ID: <164263830791.865554.9300818337239981326.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: b74e15d720d0764345934ebb599a99a077c52533

Compute the actual maximum AG btree height for deciding if a per-AG
block reservation is critically low.  This only affects the sanity check
condition, since we /generally/ will trigger on the 10% threshold.  This
is a long-winded way of saying that we're removing one more usage of
XFS_BTREE_MAXLEVELS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h  |    1 +
 libxfs/init.c        |   14 ++++++++++++++
 libxfs/xfs_ag_resv.c |    3 ++-
 3 files changed, 17 insertions(+), 1 deletion(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 308ceff0..bd464fbb 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -75,6 +75,7 @@ typedef struct xfs_mount {
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_refc_maxlevels; /* max refc btree levels */
+	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
diff --git a/libxfs/init.c b/libxfs/init.c
index f59444ab..12e25379 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -703,6 +703,18 @@ libxfs_buftarg_init(
 	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev, rfail);
 }
 
+/* Compute maximum possible height for per-AG btree types for this fs. */
+static inline void
+xfs_agbtree_compute_maxlevels(
+	struct xfs_mount	*mp)
+{
+	unsigned int		levels;
+
+	levels = max(mp->m_alloc_maxlevels, M_IGEO(mp)->inobt_maxlevels);
+	levels = max(levels, mp->m_rmap_maxlevels);
+	mp->m_agbtree_maxlevels = max(levels, mp->m_refc_maxlevels);
+}
+
 /*
  * Mount structure initialization, provides a filled-in xfs_mount_t
  * such that the numerous XFS_* macros can be used.  If dev is zero,
@@ -754,6 +766,8 @@ libxfs_mount(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
+	xfs_agbtree_compute_maxlevels(mp);
+
 	/*
 	 * Check that the data (and log if separate) are an ok size.
 	 */
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index b1392cda..546f34e8 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -90,7 +90,8 @@ xfs_ag_resv_critical(
 	trace_xfs_ag_resv_critical(pag, type, avail);
 
 	/* Critically low if less than 10% or max btree height remains. */
-	return XFS_TEST_ERROR(avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS,
+	return XFS_TEST_ERROR(avail < orig / 10 ||
+			      avail < pag->pag_mount->m_agbtree_maxlevels,
 			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL);
 }
 

