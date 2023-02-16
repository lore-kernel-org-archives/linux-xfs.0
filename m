Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE203C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjBPUom (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjBPUol (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:44:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63FB4ECDC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:44:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4336B60C0D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DACC433EF;
        Thu, 16 Feb 2023 20:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580278;
        bh=4laOPs7NPNcTKBrT5yfzvk9PmOWg6/x+S/nqDKng3j4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UlEYujp90XpNDArRsHhnfr8zrHu3bv8FujCC9YNgYaMg+Y/Gb+iRxutkwWbQXznCw
         ouggQJIVWxrDlvT3HF32MGgoRlVvSaxP6QjYpjH0ARzso69lZrit58cm0/A+r0L0v8
         RR5RybOhrDqgQecWEqBECdhV2WlT0ms0PEabWZvwBSWCSUzpw884bEYUAfhqPATR/U
         zLyZ5Vlbv6uoUmkYeUQNVWem1WXijwYvvblOpZ8UMbH9EOZJ9bDPuSVaoHzGd/lSHv
         8You4kYpWDNDnx58p2UzNGWK+QXIH7Zg3zF2Jrp0FFBx/IE9Tca7/4jovEq6qBEx5G
         NaLUUexgHsyjg==
Date:   Thu, 16 Feb 2023 12:44:38 -0800
Subject: [PATCH 11/23] xfs: wrap ilock/iunlock operations on sc->ip
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873992.3474338.10845989906566490411.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
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
 fs/xfs/scrub/common.h   |    4 ++++
 fs/xfs/scrub/dir.c      |    3 +--
 fs/xfs/scrub/inode.c    |    6 ++----
 fs/xfs/scrub/parent.c   |   10 +++-------
 fs/xfs/scrub/quota.c    |    9 +++------
 fs/xfs/scrub/rtbitmap.c |   11 +++++------
 fs/xfs/scrub/scrub.c    |    2 +-
 9 files changed, 54 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index d50d0eab196a..bab3c5db437b 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -35,8 +35,7 @@ xchk_setup_inode_bmap(
 	if (error)
 		goto out;
 
-	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	/*
 	 * We don't want any ephemeral data fork updates sitting around
@@ -73,9 +72,8 @@ xchk_setup_inode_bmap(
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
index d523cbb2c90b..dc78e28a9447 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -750,19 +750,47 @@ xchk_setup_inode_contents(
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
index 367f754c5cef..5286c263ff60 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -139,6 +139,10 @@ void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 int xchk_iget(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp);
 void xchk_irele(struct xfs_scrub *sc, struct xfs_inode *ip);
 
+void xchk_ilock(struct xfs_scrub *sc, unsigned int ilock_flags);
+bool xchk_ilock_nowait(struct xfs_scrub *sc, unsigned int ilock_flags);
+void xchk_iunlock(struct xfs_scrub *sc, unsigned int ilock_flags);
+
 /*
  * Don't bother cross-referencing if we already found corruption or cross
  * referencing discrepancies.
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
index 7a2f38e5202c..a0ee3ce35ed9 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -48,13 +48,11 @@ xchk_setup_inode(
 	}
 
 	/* Got the inode, lock it and we're ready to go. */
-	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		goto out;
-	sc->ilock_flags |= XFS_ILOCK_EXCL;
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 
 out:
 	/* scrub teardown will unlock and release the inode for us */
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
index 9eeac8565394..d3db47a3dafb 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -57,8 +57,7 @@ xchk_setup_quota(
 	if (error)
 		return error;
 	sc->ip = xfs_quota_inode(sc->mp, dqtype);
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
-	sc->ilock_flags = XFS_ILOCK_EXCL;
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	return 0;
 }
 
@@ -232,13 +231,11 @@ xchk_quota(
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
index 0a3bde64c675..340964a35963 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -28,10 +28,9 @@ xchk_setup_rt(
 	if (error)
 		return error;
 
-	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
 	sc->ip = sc->mp->m_rbmip;
-	xfs_ilock(sc->ip, sc->ilock_flags);
-
+	sc->ilock_flags = 0;
+	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
 	return 0;
 }
 
@@ -141,8 +140,8 @@ xchk_rtsummary(
 	 * flags so that we don't mix up the inode state that @sc tracks.
 	 */
 	sc->ip = rsumip;
-	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	sc->ilock_flags = 0;
+	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
 
 	/* Invoke the fork scrubber. */
 	error = xchk_metadata_inode_forks(sc);
@@ -153,7 +152,7 @@ xchk_rtsummary(
 	xchk_set_incomplete(sc);
 out:
 	/* Switch back to the rtbitmap inode and lock flags. */
-	xfs_iunlock(sc->ip, sc->ilock_flags);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
 	sc->ilock_flags = old_ilock_flags;
 	sc->ip = old_ip;
 	return error;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 752cb4fbd26f..6aedce9b67fc 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -163,7 +163,7 @@ xchk_teardown(
 	}
 	if (sc->ip) {
 		if (sc->ilock_flags)
-			xfs_iunlock(sc->ip, sc->ilock_flags);
+			xchk_iunlock(sc, sc->ilock_flags);
 		if (sc->ip != ip_in &&
 		    !xfs_internal_inum(sc->mp, sc->ip->i_ino))
 			xchk_irele(sc, sc->ip);

