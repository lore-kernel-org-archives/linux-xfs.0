Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F5BC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72761606A5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhINCnj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236074AbhINCni (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:43:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 512A4610D1;
        Tue, 14 Sep 2021 02:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587342;
        bh=0w9igD7+2sT+Dd33Aqwe00TVftNyIFMZBSeR+t3hogs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MNsTb89BxrNFrxGqojaPEYBrzLR7lQUiR7ND2GT9ggpotcWPgWw+vqbx4a6Eb2doQ
         eY9EIHA4DyReqZTaMhaEq70GtjMFzTgQPmd6ixYyk9A1cha9ywgE4WvB1+oXeIEbdU
         VMpF5TTxFMEurA3oTlMZWDmUG5/qsNDIGVvw2e8BZ7xSgpu3Q3f5DJtxIsoBV35C6z
         VkxWhf5dD3UnCMUGKROtN2T2WfCBwfDgXVoG0zK21g34xPMB8GwPphAvs7ZbSzWgys
         2LSwOY8Z1s1eydNU1S2AYdC0pIg3ieQTbEMspsZ631oHUV42ZmWKan7NiSRLQVjJ2K
         I/nLFukzA92XQ==
Subject: [PATCH 26/43] xfs: convert remaining mount flags to state flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:42:22 -0700
Message-ID: <163158734206.1604118.14166556549871621918.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 2e973b2cd4cdb993be94cca4c33f532f1ed05316

The remaining mount flags kept in m_flags are actually runtime state
flags. These change dynamically, so they really should be updated
atomically so we don't potentially lose an update due to racing
modifications.

Convert these remaining flags to be stored in m_opstate and use
atomic bitops to set and clear the flags. This also adds a couple of
simple wrappers for common state checks - read only and shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h |   38 ++++++++++++++++++++++++++++++++++++++
 libxfs/init.c       |   12 ++++++++----
 libxfs/xfs_alloc.c  |    2 +-
 libxfs/xfs_sb.c     |    2 +-
 4 files changed, 48 insertions(+), 6 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index aed31404..0f7b9787 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -79,6 +79,7 @@ typedef struct xfs_mount {
 	struct radix_tree_root	m_perag_tree;
 	uint			m_flags;	/* global mount flags */
 	uint64_t		m_features;	/* active filesystem features */
+	unsigned long		m_opstate;	/* dynamic state flags */
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	uint			m_qflags;	/* quota status flags */
 	uint			m_attroffset;	/* inode attribute offset */
@@ -204,6 +205,43 @@ __XFS_UNSUPP_FEAT(wsync)
 __XFS_UNSUPP_FEAT(noattr2)
 __XFS_UNSUPP_FEAT(ikeep)
 __XFS_UNSUPP_FEAT(swalloc)
+__XFS_UNSUPP_FEAT(readonly)
+
+/*
+ * Operational mount state flags
+ *
+ * XXX: need real atomic bit ops!
+ */
+#define XFS_OPSTATE_INODE32		0	/* inode32 allocator active */
+
+#define __XFS_IS_OPSTATE(name, NAME) \
+static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
+{ \
+	return (mp)->m_opstate & (1UL << XFS_OPSTATE_ ## NAME); \
+} \
+static inline bool xfs_clear_ ## name (struct xfs_mount *mp) \
+{ \
+	bool	ret = xfs_is_ ## name(mp); \
+\
+	(mp)->m_opstate &= ~(1UL << XFS_OPSTATE_ ## NAME); \
+	return ret; \
+} \
+static inline bool xfs_set_ ## name (struct xfs_mount *mp) \
+{ \
+	bool	ret = xfs_is_ ## name(mp); \
+\
+	(mp)->m_opstate |= (1UL << XFS_OPSTATE_ ## NAME); \
+	return ret; \
+}
+
+__XFS_IS_OPSTATE(inode32, INODE32)
+
+#define __XFS_UNSUPP_OPSTATE(name) \
+static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
+{ \
+	return false; \
+}
+__XFS_UNSUPP_OPSTATE(readonly)
 
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
 #define LIBXFS_MOUNT_32BITINODES	0x0002
diff --git a/libxfs/init.c b/libxfs/init.c
index b0a6d1fc..e7009a2e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -532,10 +532,13 @@ xfs_set_inode_alloc(
 	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
 	 * the allocator to accommodate the request.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
+	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32) {
+		xfs_set_inode32(mp);
 		mp->m_flags |= XFS_MOUNT_32BITINODES;
-	else
+	} else {
+		xfs_clear_inode32(mp);
 		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
+	}
 
 	for (index = 0; index < agcount; index++) {
 		struct xfs_perag	*pag;
@@ -544,7 +547,7 @@ xfs_set_inode_alloc(
 
 		pag = xfs_perag_get(mp, index);
 
-		if (mp->m_flags & XFS_MOUNT_32BITINODES) {
+		if (xfs_is_inode32(mp)) {
 			if (ino > XFS_MAXINUMBER_32) {
 				pag->pagi_inodeok = 0;
 				pag->pagf_metadata = 0;
@@ -564,7 +567,7 @@ xfs_set_inode_alloc(
 		xfs_perag_put(pag);
 	}
 
-	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
+	return xfs_is_inode32(mp) ? maxagi : agcount;
 }
 
 static struct xfs_buftarg *
@@ -720,6 +723,7 @@ libxfs_mount(
 
 	mp->m_finobt_nores = true;
 	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
+	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
 	sbp = &(mp->m_sb);
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index b8725339..163c726f 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3162,7 +3162,7 @@ xfs_alloc_vextent(
 		 * the first a.g. fails.
 		 */
 		if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
-		    (mp->m_flags & XFS_MOUNT_32BITINODES)) {
+		    xfs_is_inode32(mp)) {
 			args->fsbno = XFS_AGB_TO_FSB(mp,
 					((mp->m_agfrotor / rotorstep) %
 					mp->m_sb.sb_agcount), 0);
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 25a4ffdb..d2de96d1 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -120,7 +120,7 @@ xfs_validate_sb_read(
 "Superblock has unknown read-only compatible features (0x%x) enabled.",
 			(sbp->sb_features_ro_compat &
 					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
-		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		if (!xfs_is_readonly(mp)) {
 			xfs_warn(mp,
 "Attempted to mount read-only compatible filesystem read-write.");
 			xfs_warn(mp,

