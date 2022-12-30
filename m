Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE38C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbiL3X0W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbiL3X0D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:26:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF0A659F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:26:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7962161C0D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD527C433D2;
        Fri, 30 Dec 2022 23:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442761;
        bh=zT/XcXJA3phg7Tk1BbM9ltsWTx26ncjYJxXW75i9GR4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=l8Lr1ahYV3eHIQBRCBfoflhM4SDrbMDtjf3l1Y13P2kj01FVshbPLckXCrR75l3YF
         a+PPBHtV0rp0x3s5MEnCSJ1EVqRAcIY1KTKO3GYic89UzqCwGYnXk/VlGtuFCrR996
         +gNQ82dR/3dkoImF8A45d2Vz5R3i140lQWNdYE86p3NJdLGLytCyXKe8hOKRdOwgdV
         YhD8HAw0YGffHsEobC+ujRvvNyPk+cemd+CKRIr8HMta4//gBihy3jwNcanVW2XHyF
         B46wo/MY+9PclpJXdp0HSzQ5SxJA0GeybbFE1EQnoF4a1p6GEWT+yAPi3AVWRyyx+8
         Go68gPR4CxptA==
Subject: [PATCH 1/4] xfs: get our own reference to inodes that we want to
 scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:38 -0800
Message-ID: <167243835891.692714.3524655393033620039.stgit@magnolia>
In-Reply-To: <167243835873.692714.18058284706535171995.stgit@magnolia>
References: <167243835873.692714.18058284706535171995.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we want to scrub a file, get our own reference to the inode
unconditionally.  This will make disposal rules simpler in the long run.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c   |   25 +++++++++++++++++++++----
 fs/xfs/scrub/common.h   |    1 +
 fs/xfs/scrub/inode.c    |    5 ++++-
 fs/xfs/scrub/quota.c    |    6 +++++-
 fs/xfs/scrub/rtbitmap.c |    6 ++++--
 fs/xfs/scrub/scrub.c    |    6 +-----
 6 files changed, 36 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 6b2e14aecd66..305bbacc03df 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -807,6 +807,25 @@ xchk_install_handle_inode(
 	return 0;
 }
 
+/*
+ * Install an already-referenced inode for scrubbing.  Get our own reference to
+ * the inode to make disposal simpler.  The inode must not be in I_FREEING or
+ * I_WILL_FREE state!
+ */
+int
+xchk_install_live_inode(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	if (!igrab(VFS_I(ip))) {
+		xchk_ino_set_corrupt(sc, ip->i_ino);
+		return -EFSCORRUPTED;
+	}
+
+	sc->ip = ip;
+	return 0;
+}
+
 /*
  * In preparation to scrub metadata structures that hang off of an inode,
  * grab either the inode referenced in the scrub control structure or the
@@ -829,10 +848,8 @@ xchk_iget_for_scrubbing(
 	ASSERT(sc->tp == NULL);
 
 	/* We want to scan the inode we already had opened. */
-	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino) {
-		sc->ip = ip_in;
-		return 0;
-	}
+	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino)
+		return xchk_install_live_inode(sc, ip_in);
 
 	/* Reject internal metadata files and obviously bad inode numbers. */
 	if (xfs_internal_inum(mp, sc->sm->sm_ino))
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 9cfc2660dbb4..e51f4b6d287c 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -137,6 +137,7 @@ int xchk_count_rmap_ownedby_ag(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 int xchk_setup_ag_btree(struct xfs_scrub *sc, bool force_log);
 int xchk_iget_for_scrubbing(struct xfs_scrub *sc);
 int xchk_setup_inode_contents(struct xfs_scrub *sc, unsigned int resblks);
+int xchk_install_live_inode(struct xfs_scrub *sc, struct xfs_inode *ip);
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 
 int xchk_iget(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 51b8ba7037f3..30437a7f5660 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -81,7 +81,10 @@ xchk_setup_inode(
 
 	/* We want to scan the opened inode, so lock it and exit. */
 	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino) {
-		sc->ip = ip_in;
+		error = xchk_install_live_inode(sc, ip_in);
+		if (error)
+			return error;
+
 		return xchk_prepare_iscrub(sc);
 	}
 
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 7b21e1012eff..57330694cb37 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -59,7 +59,11 @@ xchk_setup_quota(
 	error = xchk_setup_fs(sc);
 	if (error)
 		return error;
-	sc->ip = xfs_quota_inode(sc->mp, dqtype);
+
+	error = xchk_install_live_inode(sc, xfs_quota_inode(sc->mp, dqtype));
+	if (error)
+		return error;
+
 	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
 	sc->ilock_flags = XFS_ILOCK_EXCL;
 	return 0;
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 0a3bde64c675..41dcffeb2947 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -28,10 +28,12 @@ xchk_setup_rt(
 	if (error)
 		return error;
 
+	error = xchk_install_live_inode(sc, sc->mp->m_rbmip);
+	if (error)
+		return error;
+
 	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
-	sc->ip = sc->mp->m_rbmip;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index afd481f5a15e..5f006e6799c6 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -168,8 +168,6 @@ xchk_teardown(
 	struct xfs_scrub	*sc,
 	int			error)
 {
-	struct xfs_inode	*ip_in = XFS_I(file_inode(sc->file));
-
 	xchk_ag_free(sc, &sc->sa);
 	if (sc->tp) {
 		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
@@ -181,9 +179,7 @@ xchk_teardown(
 	if (sc->ip) {
 		if (sc->ilock_flags)
 			xfs_iunlock(sc->ip, sc->ilock_flags);
-		if (sc->ip != ip_in &&
-		    !xfs_internal_inum(sc->mp, sc->ip->i_ino))
-			xchk_irele(sc, sc->ip);
+		xchk_irele(sc, sc->ip);
 		sc->ip = NULL;
 	}
 	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)

