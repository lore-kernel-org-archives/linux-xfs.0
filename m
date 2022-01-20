Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2A4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357757AbiATATz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357758AbiATATy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:19:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDD5C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:19:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ABE0B81AD5
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C94C004E1;
        Thu, 20 Jan 2022 00:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637991;
        bh=aqSFEWx9HH3IZ1A7D0A/OGTsl2D4hJBg8JITe88PnmI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fxN+thUIPZ6Y2a2S6llW+iLNsxsDAvdvTssjTCiC0oSc1HDq2iODBzN12gCzT9jTu
         FnEwsRcWestWHRg+woJbjL7GrT/LqYe5J6hq2O2krKJYGmvrfnbLlYkBbS6iQMopjs
         wz5wI1SAH1SGj63BP5wLd8G0E8p6JyiOZPcirwt3/6+esmSiNzDR13gu9hvmxfMcPe
         q2Vn8qp7otD17/diS+LZr8xyVHUi+AbwfJ5578BfWX6UO8odasXxPnSGnWgZAJUkP6
         wSkeceJMP7w1s5GCkB995FBaphMKf2k76zEb2+hlPe96XFdvQpKrsZJH2mWKpsKlUM
         sYGV2AdZgGI0A==
Subject: [PATCH 27/45] xfs: convert remaining mount flags to state flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:19:51 -0800
Message-ID: <164263799158.860211.16914496965938971659.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
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
 include/xfs_mount.h |   34 ++++++++++++++++++++++++++++++++++
 libxfs/init.c       |   12 ++++++++----
 libxfs/xfs_alloc.c  |    2 +-
 libxfs/xfs_sb.c     |    2 +-
 4 files changed, 44 insertions(+), 6 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index d4b4ccdc..97a1a808 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -81,6 +81,7 @@ typedef struct xfs_mount {
 	struct radix_tree_root	m_perag_tree;
 	uint			m_flags;	/* global mount flags */
 	uint64_t		m_features;	/* active filesystem features */
+	unsigned long		m_opstate;	/* dynamic state flags */
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	uint			m_qflags;	/* quota status flags */
 	uint			m_attroffset;	/* inode attribute offset */
@@ -207,6 +208,39 @@ __XFS_UNSUPP_FEAT(wsync)
 __XFS_UNSUPP_FEAT(noattr2)
 __XFS_UNSUPP_FEAT(ikeep)
 __XFS_UNSUPP_FEAT(swalloc)
+__XFS_UNSUPP_FEAT(readonly)
+
+/* Operational mount state flags */
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
index 7d94b721..adee90d5 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -540,10 +540,13 @@ xfs_set_inode_alloc(
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
@@ -552,7 +555,7 @@ xfs_set_inode_alloc(
 
 		pag = xfs_perag_get(mp, index);
 
-		if (mp->m_flags & XFS_MOUNT_32BITINODES) {
+		if (xfs_is_inode32(mp)) {
 			if (ino > XFS_MAXINUMBER_32) {
 				pag->pagi_inodeok = 0;
 				pag->pagf_metadata = 0;
@@ -572,7 +575,7 @@ xfs_set_inode_alloc(
 		xfs_perag_put(pag);
 	}
 
-	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
+	return xfs_is_inode32(mp) ? maxagi : agcount;
 }
 
 static struct xfs_buftarg *
@@ -728,6 +731,7 @@ libxfs_mount(
 
 	mp->m_finobt_nores = true;
 	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
+	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
 	sbp = &mp->m_sb;
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

