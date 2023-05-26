Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7874CC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbjEZAtR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbjEZAtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:49:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB72194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:49:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1901D616EF
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C293C433D2;
        Fri, 26 May 2023 00:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062154;
        bh=97e1k+YS8Bx9w2VqlvFIz7DBtXlE2v4wtfkf5Zby/Cs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=tipPfXGWA5EUugtekd2sL3Ko7+uTNFb21929WSpwqYb7p3PykY76X6fgEyDt1M70o
         DQWrLuRtdTNCpuHUSW/KZM4cNN57B4eh3JHbvFyx5yaQeVyITTY+BSgMXHnPKgTddD
         zOrYEp16Q2nAVeq8+vGJ4OmXSqjhfzxujcZFEeZmUbWZVqhh+BtVn7MH4fNfD0g9j3
         VPpgVJYLQTmLbwU5K2SUmw1saN2RaKUBbBigEGflbMJQWqiGLJc2gYjrMZ6jPWCc7b
         Bbrl5m6b6rUI9p2BxQYDxuQfgWPCHuvH+Q9pN7+F60x6dqUGZ71jncAe1DKMvW6sRB
         KZxVCf3mP+j0g==
Date:   Thu, 25 May 2023 17:49:14 -0700
Subject: [PATCH 2/4] xfs: wrap ilock/iunlock operations on sc->ip
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506056892.3729869.12044082984050667272.stgit@frogsfrogsfrogs>
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

Scrub tracks the resources that it's holding onto in the xfs_scrub
structure.  This includes the inode being checked (if applicable) and
the inode lock state of that inode.  Replace the open-coded structure
manipulation with a trivial helper to eliminate sources of error.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c     |    9 +++------
 fs/xfs/scrub/common.c   |   38 +++++++++++++++++++++++++++++++++-----
 fs/xfs/scrub/common.h   |    5 +++++
 fs/xfs/scrub/inode.c    |    6 ++----
 fs/xfs/scrub/parent.c   |    4 ++--
 fs/xfs/scrub/quota.c    |    9 +++------
 fs/xfs/scrub/rtbitmap.c |    9 ++++-----
 fs/xfs/scrub/scrub.c    |    2 +-
 8 files changed, 53 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 5bf4326e9783..20ab5d4e92ff 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -38,8 +38,7 @@ xchk_setup_inode_bmap(
 	if (error)
 		goto out;
 
-	sc->ilock_flags = XFS_IOLOCK_EXCL;
-	xfs_ilock(sc->ip, XFS_IOLOCK_EXCL);
+	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
 	/*
 	 * We don't want any ephemeral data/cow fork updates sitting around
@@ -50,8 +49,7 @@ xchk_setup_inode_bmap(
 	    sc->sm->sm_type != XFS_SCRUB_TYPE_BMBTA) {
 		struct address_space	*mapping = VFS_I(sc->ip)->i_mapping;
 
-		sc->ilock_flags |= XFS_MMAPLOCK_EXCL;
-		xfs_ilock(sc->ip, XFS_MMAPLOCK_EXCL);
+		xchk_ilock(sc, XFS_MMAPLOCK_EXCL);
 
 		inode_dio_wait(VFS_I(sc->ip));
 
@@ -79,9 +77,8 @@ xchk_setup_inode_bmap(
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		goto out;
-	sc->ilock_flags |= XFS_ILOCK_EXCL;
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
 
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 out:
 	/* scrub teardown will unlock and release the inode */
 	return error;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index bcec584742e7..a769063f8484 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1023,20 +1023,48 @@ xchk_setup_inode_contents(
 		return error;
 
 	/* Lock the inode so the VFS cannot touch this file. */
-	sc->ilock_flags = XFS_IOLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
 	error = xchk_trans_alloc(sc, resblks);
 	if (error)
 		goto out;
-	sc->ilock_flags |= XFS_ILOCK_EXCL;
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
-
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 out:
 	/* scrub teardown will unlock and release the inode for us */
 	return error;
 }
 
+void
+xchk_ilock(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	xfs_ilock(sc->ip, ilock_flags);
+	sc->ilock_flags |= ilock_flags;
+}
+
+bool
+xchk_ilock_nowait(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	if (xfs_ilock_nowait(sc->ip, ilock_flags)) {
+		sc->ilock_flags |= ilock_flags;
+		return true;
+	}
+
+	return false;
+}
+
+void
+xchk_iunlock(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	sc->ilock_flags &= ~ilock_flags;
+	xfs_iunlock(sc->ip, ilock_flags);
+}
+
 /*
  * Predicate that decides if we need to evaluate the cross-reference check.
  * If there was an error accessing the cross-reference btree, just delete
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 065d4bbd77ec..6495a39e9123 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -138,6 +138,11 @@ int xchk_setup_ag_btree(struct xfs_scrub *sc, bool force_log);
 int xchk_iget_for_scrubbing(struct xfs_scrub *sc);
 int xchk_setup_inode_contents(struct xfs_scrub *sc, unsigned int resblks);
 int xchk_install_live_inode(struct xfs_scrub *sc, struct xfs_inode *ip);
+
+void xchk_ilock(struct xfs_scrub *sc, unsigned int ilock_flags);
+bool xchk_ilock_nowait(struct xfs_scrub *sc, unsigned int ilock_flags);
+void xchk_iunlock(struct xfs_scrub *sc, unsigned int ilock_flags);
+
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 
 int xchk_iget(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 1d8097f77760..59d7912fb75f 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -32,15 +32,13 @@ xchk_prepare_iscrub(
 {
 	int			error;
 
-	sc->ilock_flags = XFS_IOLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
 
-	sc->ilock_flags |= XFS_ILOCK_EXCL;
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 58d5dfb7ea21..e6155d86f791 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -150,8 +150,8 @@ xchk_parent_validate(
 
 	lock_mode = xchk_parent_ilock_dir(dp);
 	if (!lock_mode) {
-		xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
-		xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+		xchk_iunlock(sc, XFS_ILOCK_EXCL);
+		xchk_ilock(sc, XFS_ILOCK_EXCL);
 		error = -EAGAIN;
 		goto out_rele;
 	}
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 19bf7f1182d4..5671c8153433 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -64,8 +64,7 @@ xchk_setup_quota(
 	if (error)
 		return error;
 
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
-	sc->ilock_flags = XFS_ILOCK_EXCL;
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	return 0;
 }
 
@@ -239,13 +238,11 @@ xchk_quota(
 	 * data fork we have to drop ILOCK_EXCL to use the regular dquot
 	 * functions.
 	 */
-	xfs_iunlock(sc->ip, sc->ilock_flags);
-	sc->ilock_flags = 0;
+	xchk_iunlock(sc, sc->ilock_flags);
 	sqi.sc = sc;
 	sqi.last_id = 0;
 	error = xfs_qm_dqiterate(mp, dqtype, xchk_quota_item, &sqi);
-	sc->ilock_flags = XFS_ILOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	if (error == -ECANCELED)
 		error = 0;
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 3bd4d0af94f7..d42e5fc20ebd 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -32,8 +32,7 @@ xchk_setup_rt(
 	if (error)
 		return error;
 
-	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
 	return 0;
 }
 
@@ -143,8 +142,8 @@ xchk_rtsummary(
 	 * flags so that we don't mix up the inode state that @sc tracks.
 	 */
 	sc->ip = rsumip;
-	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	sc->ilock_flags = 0;
+	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
 
 	/* Invoke the fork scrubber. */
 	error = xchk_metadata_inode_forks(sc);
@@ -155,7 +154,7 @@ xchk_rtsummary(
 	xchk_set_incomplete(sc);
 out:
 	/* Switch back to the rtbitmap inode and lock flags. */
-	xfs_iunlock(sc->ip, sc->ilock_flags);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
 	sc->ilock_flags = old_ilock_flags;
 	sc->ip = old_ip;
 	return error;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 390c4f1ac271..da3a3c1c0ed3 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -178,7 +178,7 @@ xchk_teardown(
 	}
 	if (sc->ip) {
 		if (sc->ilock_flags)
-			xfs_iunlock(sc->ip, sc->ilock_flags);
+			xchk_iunlock(sc, sc->ilock_flags);
 		xchk_irele(sc, sc->ip);
 		sc->ip = NULL;
 	}

