Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AF8C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiJBSfF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiJBSfE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:35:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CE4186C5
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 989EB60F07
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0EAC433D6;
        Sun,  2 Oct 2022 18:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735700;
        bh=z9h4Ngbki9Z6+pgXN5cWidvHclrK1xf/jw0pftTNZWM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TDRpzVQig15lOq8STnJPFyqAEpDWE5bakLGyPa53T0Q1A72/crkP6UlDbxt2s2Bgt
         GOAOJF4wBpZTGKxBzvagHC3UOWVrAXgp4bQuQJPX1MxFLcxNotURKtHXcGFGnVW3Yz
         NUVjpBhInLsB8hDfiJwp3rLrsZMVnZg/VUNZ3PDFrv2ebL7kvTrd8WPtVJKXc7ePXn
         Fi3y/YceX0uL/83nR5BNxfpJL/s2iEsPOaNdqFjmMSJBIBcjrsSqCGBRttEYIHUpPS
         mTj9qEFULQFOCOIoarTPceDjwidTYcvzo5XIxmzEhzP3bD2sD5FJwk8LoVHrHxYlNz
         b1eD9H2E4ysjQ==
Subject: [PATCH 1/3] xfs: make checking directory dotdot entries more reliable
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:32 -0700
Message-ID: <166473483278.1084804.14032671424392139245.stgit@magnolia>
In-Reply-To: <166473483259.1084804.16578148649615408100.stgit@magnolia>
References: <166473483259.1084804.16578148649615408100.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The current directory parent scrubbing code could be tighter in its
execution -- instead of bailing out to userspace after a couple of
seconds of waiting for the (alleged) parent directory's IOLOCK while
refusing to release the child directory's IOLOCK, we could just cycle
both locks until we get both or the child process absorbs a fatal
signal.

Note that because the usual sequence is to take IOLOCKs before grabbing
a transaction, we have to use the _nowait variants on both inodes to
avoid an ABBA deadlock.  Since parent pointer checking is the only place
in scrub that needs this kind of functionality, move it to parent.c as a
private function.

Furthermore, if the child directory's parent changes during the lock
cycling, we know that the new parent has stamped the correct parent into
the dotdot entry, so we can conclude that the parent entry is correct.

This eliminates an entire source of -EDEADLOCK-based "retry harder"
scrub executions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |   22 -----
 fs/xfs/scrub/common.h |    1 
 fs/xfs/scrub/parent.c |  203 +++++++++++++++++++++++--------------------------
 3 files changed, 97 insertions(+), 129 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index dd60c7ced780..53dbffd4418e 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1120,28 +1120,6 @@ xchk_metadata_inode_forks(
 	return 0;
 }
 
-/*
- * Try to lock an inode in violation of the usual locking order rules.  For
- * example, trying to get the IOLOCK while in transaction context, or just
- * plain breaking AG-order or inode-order inode locking rules.  Either way,
- * the only way to avoid an ABBA deadlock is to use trylock and back off if
- * we can't.
- */
-int
-xchk_ilock_inverted(
-	struct xfs_inode	*ip,
-	uint			lock_mode)
-{
-	int			i;
-
-	for (i = 0; i < 20; i++) {
-		if (xfs_ilock_nowait(ip, lock_mode))
-			return 0;
-		delay(1);
-	}
-	return -EDEADLOCK;
-}
-
 /* Pause background reaping of resources. */
 void
 xchk_stop_reaping(
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 4d621811eb89..c12d2165866f 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -156,7 +156,6 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 }
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
-int xchk_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
 void xchk_stop_reaping(struct xfs_scrub *sc);
 void xchk_start_reaping(struct xfs_scrub *sc);
 
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 38ea04e66468..5fa83f805d74 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -120,6 +120,48 @@ xchk_parent_count_parent_dentries(
 	return error;
 }
 
+/*
+ * Try to iolock the parent dir @dp in shared mode and the child dir @sc->ip
+ * exclusively.
+ */
+STATIC int
+xchk_parent_lock_two_dirs(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp)
+{
+	int			error = 0;
+
+	/* Callers shouldn't do this, but protect ourselves anyway. */
+	if (dp == sc->ip) {
+		ASSERT(dp != sc->ip);
+		return -EINVAL;
+	}
+
+	xfs_iunlock(sc->ip, sc->ilock_flags);
+	sc->ilock_flags = 0;
+	while (true) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		/*
+		 * Normal XFS takes the IOLOCK before grabbing a transaction.
+		 * Scrub holds a transaction, which means that we can't block
+		 * on either IOLOCK.
+		 */
+		if (xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
+			if (xfs_ilock_nowait(sc->ip, XFS_IOLOCK_EXCL)) {
+				sc->ilock_flags = XFS_IOLOCK_EXCL;
+				break;
+			}
+			xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+		}
+
+		delay(1);
+	}
+
+	return 0;
+}
+
 /*
  * Given the inode number of the alleged parent of the inode being
  * scrubbed, try to validate that the parent has exactly one directory
@@ -128,23 +170,20 @@ xchk_parent_count_parent_dentries(
 STATIC int
 xchk_parent_validate(
 	struct xfs_scrub	*sc,
-	xfs_ino_t		dnum,
-	bool			*try_again)
+	xfs_ino_t		parent_ino)
 {
 	struct xfs_inode	*dp = NULL;
 	xfs_nlink_t		expected_nlink;
 	xfs_nlink_t		nlink;
 	int			error = 0;
 
-	*try_again = false;
-
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		goto out;
+		return 0;
 
 	/* '..' must not point to ourselves. */
-	if (sc->ip->i_ino == dnum) {
+	if (sc->ip->i_ino == parent_ino) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-		goto out;
+		return 0;
 	}
 
 	/*
@@ -154,106 +193,80 @@ xchk_parent_validate(
 	expected_nlink = VFS_I(sc->ip)->i_nlink == 0 ? 0 : 1;
 
 	/*
-	 * Grab this parent inode.  We release the inode before we
-	 * cancel the scrub transaction.  Since we're don't know a
-	 * priori that releasing the inode won't trigger eofblocks
-	 * cleanup (which allocates what would be a nested transaction)
-	 * if the parent pointer erroneously points to a file, we
-	 * can't use DONTCACHE here because DONTCACHE inodes can trigger
-	 * immediate inactive cleanup of the inode.
+	 * Grab the parent directory inode.  This must be released before we
+	 * cancel the scrub transaction.
 	 *
 	 * If _iget returns -EINVAL or -ENOENT then the parent inode number is
 	 * garbage and the directory is corrupt.  If the _iget returns
 	 * -EFSCORRUPTED or -EFSBADCRC then the parent is corrupt which is a
 	 *  cross referencing error.  Any other error is an operational error.
 	 */
-	error = xchk_iget(sc, dnum, &dp);
+	error = xchk_iget(sc, parent_ino, &dp);
 	if (error == -EINVAL || error == -ENOENT) {
 		error = -EFSCORRUPTED;
 		xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error);
-		goto out;
+		return error;
 	}
 	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
-		goto out;
+		return error;
 	if (dp == sc->ip || !S_ISDIR(VFS_I(dp)->i_mode)) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out_rele;
 	}
 
 	/*
-	 * We prefer to keep the inode locked while we lock and search
-	 * its alleged parent for a forward reference.  If we can grab
-	 * the iolock, validate the pointers and we're done.  We must
-	 * use nowait here to avoid an ABBA deadlock on the parent and
-	 * the child inodes.
+	 * We prefer to keep the inode locked while we lock and search its
+	 * alleged parent for a forward reference.  If we can grab the iolock
+	 * of the alleged parent, then we can move ahead to counting dirents
+	 * and checking nlinks.
+	 *
+	 * However, if we fail to iolock the alleged parent while holding the
+	 * child iolock, we have no way to tell if a blocking lock() would
+	 * result in an ABBA deadlock.  Release the lock on the child, then
+	 * try to lock the alleged parent and trylock the child.
 	 */
-	if (xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
-		error = xchk_parent_count_parent_dentries(sc, dp, &nlink);
-		if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
-				&error))
+	if (!xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
+		error = xchk_parent_lock_two_dirs(sc, dp);
+		if (error)
+			goto out_rele;
+
+		/*
+		 * Now that we've locked out updates to the child directory,
+		 * re-sample the expected nlink and the '..' dirent.
+		 */
+		expected_nlink = VFS_I(sc->ip)->i_nlink == 0 ? 0 : 1;
+
+		error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot,
+				&parent_ino, NULL);
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+			goto out_unlock;
+
+		/*
+		 * After relocking the child directory, the '..' entry points
+		 * to a different parent than before.  This means someone moved
+		 * the child elsewhere in the directory tree, which means that
+		 * the parent link is now correct and we're done.
+		 */
+		if (parent_ino != dp->i_ino)
 			goto out_unlock;
-		if (nlink != expected_nlink)
-			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-		goto out_unlock;
 	}
 
-	/*
-	 * The game changes if we get here.  We failed to lock the parent,
-	 * so we're going to try to verify both pointers while only holding
-	 * one lock so as to avoid deadlocking with something that's actually
-	 * trying to traverse down the directory tree.
-	 */
-	xfs_iunlock(sc->ip, sc->ilock_flags);
-	sc->ilock_flags = 0;
-	error = xchk_ilock_inverted(dp, XFS_IOLOCK_SHARED);
-	if (error)
-		goto out_rele;
-
-	/* Go looking for our dentry. */
+	/* Look for a directory entry in the parent pointing to the child. */
 	error = xchk_parent_count_parent_dentries(sc, dp, &nlink);
 	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out_unlock;
 
-	/* Drop the parent lock, relock this inode. */
-	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
-	error = xchk_ilock_inverted(sc->ip, XFS_IOLOCK_EXCL);
-	if (error)
-		goto out_rele;
-	sc->ilock_flags = XFS_IOLOCK_EXCL;
-
 	/*
-	 * If we're an unlinked directory, the parent /won't/ have a link
-	 * to us.  Otherwise, it should have one link.  We have to re-set
-	 * it here because we dropped the lock on sc->ip.
-	 */
-	expected_nlink = VFS_I(sc->ip)->i_nlink == 0 ? 0 : 1;
-
-	/* Look up '..' to see if the inode changed. */
-	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
-	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
-		goto out_rele;
-
-	/* Drat, parent changed.  Try again! */
-	if (dnum != dp->i_ino) {
-		xfs_irele(dp);
-		*try_again = true;
-		return 0;
-	}
-	xfs_irele(dp);
-
-	/*
-	 * '..' didn't change, so check that there was only one entry
-	 * for us in the parent.
+	 * Ensure that the parent has as many links to the child as the child
+	 * thinks it has to the parent.
 	 */
 	if (nlink != expected_nlink)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-	return error;
 
 out_unlock:
 	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 out_rele:
 	xchk_irele(sc, dp);
-out:
 	return error;
 }
 
@@ -263,10 +276,8 @@ xchk_parent(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
-	xfs_ino_t		dnum;
-	bool			try_again;
-	int			tries = 0;
-	int			error = 0;
+	xfs_ino_t		parent_ino;
+	int			error;
 
 	/*
 	 * If we're a directory, check that the '..' link points up to
@@ -278,7 +289,7 @@ xchk_parent(
 	/* We're not a special inode, are we? */
 	if (!xfs_verify_dir_ino(mp, sc->ip->i_ino)) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-		goto out;
+		return 0;
 	}
 
 	/*
@@ -292,42 +303,22 @@ xchk_parent(
 	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	/* Look up '..' */
-	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &dnum, NULL);
+	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &parent_ino,
+			NULL);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
-		goto out;
-	if (!xfs_verify_dir_ino(mp, dnum)) {
+		return error;
+	if (!xfs_verify_dir_ino(mp, parent_ino)) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-		goto out;
+		return 0;
 	}
 
 	/* Is this the root dir?  Then '..' must point to itself. */
 	if (sc->ip == mp->m_rootip) {
 		if (sc->ip->i_ino != mp->m_sb.sb_rootino ||
-		    sc->ip->i_ino != dnum)
+		    sc->ip->i_ino != parent_ino)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-		goto out;
+		return 0;
 	}
 
-	do {
-		error = xchk_parent_validate(sc, dnum, &try_again);
-		if (error)
-			goto out;
-	} while (try_again && ++tries < 20);
-
-	/*
-	 * We gave it our best shot but failed, so mark this scrub
-	 * incomplete.  Userspace can decide if it wants to try again.
-	 */
-	if (try_again && tries == 20)
-		xchk_set_incomplete(sc);
-out:
-	/*
-	 * If we failed to lock the parent inode even after a retry, just mark
-	 * this scrub incomplete and return.
-	 */
-	if ((sc->flags & XCHK_TRY_HARDER) && error == -EDEADLOCK) {
-		error = 0;
-		xchk_set_incomplete(sc);
-	}
-	return error;
+	return xchk_parent_validate(sc, parent_ino);
 }

