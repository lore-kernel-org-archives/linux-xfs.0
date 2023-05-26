Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DECDC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjEZAtD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbjEZAtB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:49:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D569E12E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 716AE619B3
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D590FC433D2;
        Fri, 26 May 2023 00:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062138;
        bh=WiDwwC+ZV2YlaF2qsqxzRcxneCI5fza1/sjRSi0yDsM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=bj7/n0N2sqNdzkJMnbYgiJpuAkzSQqk8V4tKr7/BS/lexPxU4h2jYBgwOMSf3NsAi
         9tMJHNWVkb1hbagcQqz89vl4wdL0lb/nLBXOBkW0H8RIL0HzE+dn6uw+R6RYTuBd9J
         o71/GVJRAqIZB4evnpsJOBw6kck/J5AGb5MvWjHN7Se3voXzN1ncgxyyDn3goBS+J3
         zdTvoJjgw+rXL5/slp8bkImZfhKkm5dM1+5Kq/Q81EU6ON4C2v0p5n/PI+BFL1BKT8
         azY7XuBFztNOwiyrVXfAaDIOX0M5MqwasXenJJ2vx3hg9ZDQP+pA55q5YxX/Tq/kca
         LiaYVASOCwZ5w==
Date:   Thu, 25 May 2023 17:48:58 -0700
Subject: [PATCH 1/4] xfs: get our own reference to inodes that we want to
 scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506056878.3729869.4781141167438600338.stgit@frogsfrogsfrogs>
In-Reply-To: <168506056859.3729869.14765688109434520098.stgit@frogsfrogsfrogs>
References: <168506056859.3729869.14765688109434520098.stgit@frogsfrogsfrogs>
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
index 532fa6729af4..bcec584742e7 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -832,6 +832,25 @@ xchk_install_handle_inode(
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
@@ -855,10 +874,8 @@ xchk_iget_for_scrubbing(
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
index 791235cd9b00..065d4bbd77ec 100644
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
index 3e1e02e340a6..1d8097f77760 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -83,7 +83,10 @@ xchk_setup_inode(
 
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
index e6caa358cbda..19bf7f1182d4 100644
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
index e7dace7b4be8..3bd4d0af94f7 100644
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
index d603efa2a9af..390c4f1ac271 100644
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

