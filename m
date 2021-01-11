Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98932C4321A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B3E22DFA
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391782AbhALAZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404046AbhAKXXV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:23:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3776122D07;
        Mon, 11 Jan 2021 23:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407360;
        bh=HczYHZ5rTJaHZ6ewxi1jMfolPppXO8ad4OOisGl1np8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FvWCDyRH7yi/sxKsnnesxUWtKe65isFoMoFqVHdSk9B9pRpi8XoiHn+lNIVT1BHHo
         HX9hrLOoLcPvRMA+u4d7fxU13GCAZn+xyN412N7fwcoRmu4g3q/JlE0DAcUHgvvltN
         frcKJqjLaHwrAteu9fKJENm7ed/67Xx4kTx/yPeU811UP/jrXJa1sR10ntlFzM7A4z
         XubN2hQbqw6iYAcgtO20weuD7W4roDyDxTWvIpJH5Cf9Ol0NdQ+3WdHJd5vESVtx7/
         i3BtrXo0c4y3o5g400vNxm/+HNCeNdHRPJkSw2tBGJtaFrNPbC/zYylHfpedTDcYSC
         yh/WYaahGlRAw==
Subject: [PATCH 1/6] xfs: hide most of the incore inode walk interface
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:22:40 -0800
Message-ID: <161040736028.1582114.17043927663737160536.stgit@magnolia>
In-Reply-To: <161040735389.1582114.15084485390769234805.stgit@magnolia>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Hide the incore inode walk interface because callers outside of the
icache code don't need to know about iter_flags and radix tags and other
implementation details of the incore inode cache.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c      |   27 +++++++++++++++++++++++----
 fs/xfs/xfs_icache.h      |    9 ++-------
 fs/xfs/xfs_qm_syscalls.c |    3 +--
 3 files changed, 26 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index deb99300d171..e6d704a30b29 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,6 +26,11 @@
 
 #include <linux/iversion.h>
 
+/*
+ * flags for incore inode iterator
+ */
+#define XFS_INODE_WALK_INEW_WAIT	0x1	/* wait on new inodes */
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -888,8 +893,8 @@ xfs_inode_walk_get_perag(
  * Call the @execute function on all incore inodes matching the radix tree
  * @tag.
  */
-int
-xfs_inode_walk(
+STATIC int
+__xfs_inode_walk(
 	struct xfs_mount	*mp,
 	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
@@ -915,6 +920,20 @@ xfs_inode_walk(
 	return last_error;
 }
 
+/*
+ * Walk all incore inodes in the filesystem.  Knowledge of radix tree tags
+ * is hidden and we always wait for INEW inodes.
+ */
+int
+xfs_inode_walk(
+	struct xfs_mount	*mp,
+	int			(*execute)(struct xfs_inode *ip, void *args),
+	void			*args)
+{
+	return __xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, execute, args,
+			XFS_ICI_NO_TAG);
+}
+
 /*
  * Background scanning to trim post-EOF preallocated space. This is queued
  * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
@@ -1392,7 +1411,7 @@ xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
+	return __xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
 			XFS_ICI_EOFBLOCKS_TAG);
 }
 
@@ -1642,7 +1661,7 @@ xfs_icache_free_cowblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
+	return __xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
 			XFS_ICI_COWBLOCKS_TAG);
 }
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 3a4c8b382cd0..0d9f1b5d112c 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -34,11 +34,6 @@ struct xfs_eofblocks {
 #define XFS_IGET_DONTCACHE	0x4
 #define XFS_IGET_INCORE		0x8	/* don't read from disk or reinit */
 
-/*
- * flags for AG inode iterator
- */
-#define XFS_INODE_WALK_INEW_WAIT	0x1	/* wait on new inodes */
-
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);
 
@@ -68,9 +63,9 @@ int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 
-int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
+int xfs_inode_walk(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, void *args),
-	void *args, int tag);
+	void *args);
 
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index ca1b57d291dc..dad4d3fc3df3 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -795,6 +795,5 @@ xfs_qm_dqrele_all_inodes(
 	uint			flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&flags, XFS_ICI_NO_TAG);
+	xfs_inode_walk(mp, xfs_dqrele_inode, &flags);
 }

