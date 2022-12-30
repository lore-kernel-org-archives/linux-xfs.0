Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41069C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiL3X1D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbiL3X0V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:26:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B4E63C5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:26:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CACAFB81DA2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7754EC433D2;
        Fri, 30 Dec 2022 23:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442777;
        bh=6znhL/TBmmgZJ8MQxu1PxpGJBMKgStSnqzA7cRj4Nok=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CgeMeS+q/rYlZBwal5lvT25G+tAmHx35Pzs2pjJiliBUHTnXuJKntPSktBEJKSpLh
         6JOA3BHG96bAxLoFNsnYMiOKpiuBLSBn+8pWu1+tD2xedphp/YFw4wAY18p6/eIxNu
         1TY6CUzcRzhFtbajCsLfpsKwzyK6XVULxmJJFfYz+Er0UE/J9JYuZzPo9Bey+rYMyo
         xUhCTjMMXyTacsrpNpZvR3/0cDQlonoaL7DTZkAj7lcDBVr021cEMeQ/RJ5r7O83Fj
         2elRhXH1Qbs1v/Cz5pXehhETz8A8Kuwq5b9VFN2qmC/c2JKDYYG7y/rDHKfvZT1yze
         cFV53MN8MmvsA==
Subject: [PATCH 2/4] xfs: wrap ilock/iunlock operations on sc->ip
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:39 -0800
Message-ID: <167243835906.692714.9514272978081187991.stgit@magnolia>
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

Scrub tracks the resources that it's holding onto in the xfs_scrub
structure.  This includes the inode being checked (if applicable) and
the inode lock state of that inode.  Replace the open-coded structure
manipulation with a trivial helper to eliminate sources of error.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c     |    6 ++----
 fs/xfs/scrub/common.c   |   38 +++++++++++++++++++++++++++++++++-----
 fs/xfs/scrub/common.h   |    5 +++++
 fs/xfs/scrub/dir.c      |    3 +--
 fs/xfs/scrub/inode.c    |    6 ++----
 fs/xfs/scrub/parent.c   |   10 +++-------
 fs/xfs/scrub/quota.c    |    9 +++------
 fs/xfs/scrub/rtbitmap.c |    9 ++++-----
 fs/xfs/scrub/scrub.c    |    2 +-
 9 files changed, 54 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 499e82110f2f..2dc5bcd5c4fa 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -38,8 +38,7 @@ xchk_setup_inode_bmap(
 	if (error)
 		goto out;
 
-	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	/*
 	 * We don't want any ephemeral data fork updates sitting around
@@ -76,9 +75,8 @@ xchk_setup_inode_bmap(
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
index 305bbacc03df..0c1fa210deae 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -986,19 +986,47 @@ xchk_setup_inode_contents(
 		return error;
 
 	/* Got the inode, lock it and we're ready to go. */
-	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
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
+	sc->ilock_flags |= ilock_flags;
+	xfs_ilock(sc->ip, ilock_flags);
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
+	xfs_iunlock(sc->ip, ilock_flags);
+	sc->ilock_flags &= ~ilock_flags;
+}
+
 /*
  * Predicate that decides if we need to evaluate the cross-reference check.
  * If there was an error accessing the cross-reference btree, just delete
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e51f4b6d287c..d755ff734c9e 100644
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
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 8076e7620734..2a3107cc8ccb 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -840,8 +840,7 @@ xchk_directory(
 	 * _dir_lookup routines, which do their own ILOCK locking.
 	 */
 	oldpos = 0;
-	sc->ilock_flags &= ~XFS_ILOCK_EXCL;
-	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
 	while (true) {
 		error = xfs_readdir(sc->tp, sc->ip, &sdc.dir_iter, bufsize);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0,
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 30437a7f5660..7a248f26a03c 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -31,15 +31,13 @@ xchk_prepare_iscrub(
 {
 	int			error;
 
-	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
 
-	sc->ilock_flags |= XFS_ILOCK_EXCL;
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 0c23fd49716b..8581a21bfbfd 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -137,8 +137,7 @@ xchk_parent_lock_two_dirs(
 		return -EINVAL;
 	}
 
-	xfs_iunlock(sc->ip, sc->ilock_flags);
-	sc->ilock_flags = 0;
+	xchk_iunlock(sc, sc->ilock_flags);
 	while (true) {
 		if (xchk_should_terminate(sc, &error))
 			return error;
@@ -149,10 +148,8 @@ xchk_parent_lock_two_dirs(
 		 * on either IOLOCK.
 		 */
 		if (xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
-			if (xfs_ilock_nowait(sc->ip, XFS_IOLOCK_EXCL)) {
-				sc->ilock_flags = XFS_IOLOCK_EXCL;
+			if (xchk_ilock_nowait(sc, XFS_IOLOCK_EXCL))
 				break;
-			}
 			xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 		}
 
@@ -299,8 +296,7 @@ xchk_parent(
 	 * getting a write lock on i_rwsem.  Therefore, it is safe for us
 	 * to drop the ILOCK here in order to do directory lookups.
 	 */
-	sc->ilock_flags &= ~(XFS_ILOCK_EXCL | XFS_MMAPLOCK_EXCL);
-	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL | XFS_MMAPLOCK_EXCL);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	/* Look up '..' */
 	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &parent_ino,
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 57330694cb37..085ff234f6ba 100644
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
index 41dcffeb2947..c58c86fa1b03 100644
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
index 5f006e6799c6..189a56f93279 100644
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

