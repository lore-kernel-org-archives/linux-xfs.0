Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490ABEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjG0Wav (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjG0Wau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:30:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE28A2D64
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B4EE61F3E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1D7C433C9;
        Thu, 27 Jul 2023 22:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497048;
        bh=Qd582uOiklmxeno6PYimND5w7aa8joswiTVCf+eGnBc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rt5oAwk1WZYf18CTNRNTr4JE8FKVT5l8pPm62caI83swxKBdy7Yt3QA/Nz6MO8ATn
         BXDEmjrywhtmIBLGGN+/QToK5pn2GLhtujeniLmUBmhPY9+Pqnm9UZ8z9qT2W44L4q
         ukcMm5KcZGcaweCt3vtypUTe980l42DV4++yTsutvVIJlK6E2JSEQAM8USfkSdr3IU
         pv7Kyn81/gJ4kj/i2op2BrMxU53muFitDylIWL+5lsmaxA/qlRRd1EY1IN/99Dvpys
         xOB0DN05dzTX8LuWOX/kDRoOOh6cutxwv3AsopYUYu/PKrjy/iT7zDLquYwcVXe7B5
         op49ZjEOy+F6w==
Date:   Thu, 27 Jul 2023 15:30:48 -0700
Subject: [PATCH 2/5] xfs: hide xfs_inode_is_allocated in scrub common code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049625739.922264.2263489616800569557.stgit@frogsfrogsfrogs>
In-Reply-To: <169049625702.922264.5146998399930069330.stgit@frogsfrogsfrogs>
References: <169049625702.922264.5146998399930069330.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This function is only used by online fsck, so let's move it there.
In the next patch, we'll fix it to work properly and to require that the
caller hold the AGI buffer locked.  No major changes aside from
adjusting the signature a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |   37 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h |    2 ++
 fs/xfs/scrub/ialloc.c |    3 +--
 fs/xfs/xfs_icache.c   |   38 --------------------------------------
 fs/xfs/xfs_icache.h   |    4 ----
 5 files changed, 40 insertions(+), 44 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index a769063f84841..8ae4a54c7be46 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1231,3 +1231,40 @@ xchk_fsgates_enable(
 
 	sc->flags |= scrub_fsgates;
 }
+
+/*
+ * Decide if this is this a cached inode that's also allocated.
+ *
+ * Look up an inode by number in the given file system.  If the inode is
+ * in cache and isn't in purgatory, return 1 if the inode is allocated
+ * and 0 if it is not.  For all other cases (not in cache, being torn
+ * down, etc.), return a negative error code.
+ *
+ * The caller has to prevent inode allocation and freeing activity,
+ * presumably by locking the AGI buffer.   This is to ensure that an
+ * inode cannot transition from allocated to freed until the caller is
+ * ready to allow that.  If the inode is in an intermediate state (new,
+ * reclaimable, or being reclaimed), -EAGAIN will be returned; if the
+ * inode is not in the cache, -ENOENT will be returned.  The caller must
+ * deal with these scenarios appropriately.
+ *
+ * This is a specialized use case for the online scrubber; if you're
+ * reading this, you probably want xfs_iget.
+ */
+int
+xchk_inode_is_allocated(
+	struct xfs_scrub	*sc,
+	xfs_ino_t		ino,
+	bool			*inuse)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	error = xfs_iget(sc->mp, sc->tp, ino, XFS_IGET_INCORE, 0, &ip);
+	if (error)
+		return error;
+
+	*inuse = !!(VFS_I(ip)->i_mode);
+	xfs_irele(ip);
+	return 0;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 6936927ad991e..77b3338a67c6d 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -222,4 +222,6 @@ static inline bool xchk_need_intent_drain(struct xfs_scrub *sc)
 
 void xchk_fsgates_enable(struct xfs_scrub *sc, unsigned int scrub_fshooks);
 
+int xchk_inode_is_allocated(struct xfs_scrub *sc, xfs_ino_t ino, bool *inuse);
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 575f22a02ebe5..3a3d750b02e0e 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -328,8 +328,7 @@ xchk_iallocbt_check_cluster_ifree(
 		goto out;
 	}
 
-	error = xfs_icache_inode_is_allocated(mp, bs->cur->bc_tp, fsino,
-			&ino_inuse);
+	error = xchk_inode_is_allocated(bs->sc, fsino, &ino_inuse);
 	if (error == -ENODATA) {
 		/* Not cached, just read the disk buffer */
 		freemask_ok = irec_free ^ !!(dip->di_mode);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 453890942d9f5..e541f5c0bc251 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -802,44 +802,6 @@ xfs_iget(
 	return error;
 }
 
-/*
- * "Is this a cached inode that's also allocated?"
- *
- * Look up an inode by number in the given file system.  If the inode is
- * in cache and isn't in purgatory, return 1 if the inode is allocated
- * and 0 if it is not.  For all other cases (not in cache, being torn
- * down, etc.), return a negative error code.
- *
- * The caller has to prevent inode allocation and freeing activity,
- * presumably by locking the AGI buffer.   This is to ensure that an
- * inode cannot transition from allocated to freed until the caller is
- * ready to allow that.  If the inode is in an intermediate state (new,
- * reclaimable, or being reclaimed), -EAGAIN will be returned; if the
- * inode is not in the cache, -ENOENT will be returned.  The caller must
- * deal with these scenarios appropriately.
- *
- * This is a specialized use case for the online scrubber; if you're
- * reading this, you probably want xfs_iget.
- */
-int
-xfs_icache_inode_is_allocated(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	xfs_ino_t		ino,
-	bool			*inuse)
-{
-	struct xfs_inode	*ip;
-	int			error;
-
-	error = xfs_iget(mp, tp, ino, XFS_IGET_INCORE, 0, &ip);
-	if (error)
-		return error;
-
-	*inuse = !!(VFS_I(ip)->i_mode);
-	xfs_irele(ip);
-	return 0;
-}
-
 /*
  * Grab the inode for reclaim exclusively.
  *
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 1dcdcb23796ed..2fa6f2e09d078 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -71,10 +71,6 @@ void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 
 void xfs_blockgc_worker(struct work_struct *work);
-
-int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
-				  xfs_ino_t ino, bool *inuse);
-
 void xfs_blockgc_stop(struct xfs_mount *mp);
 void xfs_blockgc_start(struct xfs_mount *mp);
 

