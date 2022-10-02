Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76037C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJBSea (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiJBSea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:34:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBB23C8C2
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAADB60F04
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40433C433C1;
        Sun,  2 Oct 2022 18:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735668;
        bh=aHr+W+WmpUpTQ2YHr3/TLO03gVzMeU2ljJqrFoiAToo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=arw9RvVhwbUI7JScDpZPxgi0ITi9Vy8L61pBXRDfH1rBSor1I37D0n6M+POHeorqk
         y9NIAZs7bIW2AiBkVdmu9+fwppON0mOW8PQhYxFbyXWs+F9IzTZdTFwQBA0McQ1aW8
         D5XPbiPpgFIG2j/nghAEV5uydOFNH1+nKaP3vQSgGqXDYCyy/oIDmE6iC2HvwUlaiO
         Vgt8MyQzxHkh27+Z4Msvq77t/Wq227Vr6xSirBfXDwWOvdSXHDvxmU/W1jXNohgoNT
         HikrL/RFcs/QFzYNuxUWaa3NOoAonJh18jIoOM1E618kXJ6fHI9hav2EnNfCJ463k9
         JE2Zh0ACHaA9g==
Subject: [PATCH 1/3] xfs: manage inode DONTCACHE status at irele time
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:29 -0700
Message-ID: <166473482943.1084685.12751834399982118437.stgit@magnolia>
In-Reply-To: <166473482923.1084685.3060991494529121939.stgit@magnolia>
References: <166473482923.1084685.3060991494529121939.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Right now, there are statements scattered all over the online fsck
codebase about how we can't use XFS_IGET_DONTCACHE because of concerns
about scrub's unusual practice of releasing inodes with transactions
held.

However, iget is the wrong place to handle this -- the DONTCACHE state
doesn't matter at all until we try to *release* the inode, and here we
get things wrong in multiple ways:

First, if we /do/ have a transaction, we must NOT drop the inode,
because the inode could have dirty pages, dropping the inode will
trigger writeback, and writeback can trigger a nested transaction.

Second, if the inode already had an active reference and the DONTCACHE
flag set, the icache hit when scrub grabs another ref will not clear
DONTCACHE.  This is sort of by design, since DONTCACHE is now used to
initiate cache drops so that sysadmins can change a file's access mode
between pagecache and DAX.

Third, if we do actually have the last active reference to the inode, we
can set DONTCACHE to avoid polluting the cache.  This is the /one/ case
where we actually want that flag.

Create an xchk_irele helper to encode all that logic and switch the
online fsck code to use it.  Since this now means that nearly all
scrubbers use the same xfs_iget flags, we can wrap them too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |   52 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/common.h |    3 +++
 fs/xfs/scrub/dir.c    |    2 +-
 fs/xfs/scrub/parent.c |    5 ++---
 fs/xfs/scrub/scrub.c  |    2 +-
 5 files changed, 55 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 73ac38c1126e..42a25488bd25 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -710,6 +710,16 @@ xchk_checkpoint_log(
 	return 0;
 }
 
+/* Verify that an inode is allocated ondisk, then return its cached inode. */
+int
+xchk_iget(
+	struct xfs_scrub	*sc,
+	xfs_ino_t		inum,
+	struct xfs_inode	**ipp)
+{
+	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
+}
+
 /*
  * Given an inode and the scrub control structure, grab either the
  * inode referenced in the control structure or the inode passed in.
@@ -734,8 +744,7 @@ xchk_get_inode(
 	/* Look up the inode, see if the generation number matches. */
 	if (xfs_internal_inum(mp, sc->sm->sm_ino))
 		return -ENOENT;
-	error = xfs_iget(mp, NULL, sc->sm->sm_ino,
-			XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE, 0, &ip);
+	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
 	switch (error) {
 	case -ENOENT:
 		/* Inode doesn't exist, just bail out. */
@@ -757,7 +766,7 @@ xchk_get_inode(
 		 * that it no longer exists.
 		 */
 		error = xfs_imap(sc->mp, sc->tp, sc->sm->sm_ino, &imap,
-				XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE);
+				XFS_IGET_UNTRUSTED);
 		if (error)
 			return -ENOENT;
 		error = -EFSCORRUPTED;
@@ -770,7 +779,7 @@ xchk_get_inode(
 		return error;
 	}
 	if (VFS_I(ip)->i_generation != sc->sm->sm_gen) {
-		xfs_irele(ip);
+		xchk_irele(sc, ip);
 		return -ENOENT;
 	}
 
@@ -778,6 +787,41 @@ xchk_get_inode(
 	return 0;
 }
 
+/* Release an inode, possibly dropping it in the process. */
+void
+xchk_irele(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	if (current->journal_info != NULL) {
+		ASSERT(current->journal_info == sc->tp);
+
+		/*
+		 * If we are in a transaction, we /cannot/ drop the inode
+		 * ourselves, because the VFS will trigger writeback, which
+		 * can require a transaction.  Clear DONTCACHE to force the
+		 * inode to the LRU, where someone else can take care of
+		 * dropping it.
+		 *
+		 * Note that when we grabbed our reference to the inode, it
+		 * could have had an active ref and DONTCACHE set if a sysadmin
+		 * is trying to coerce a change in file access mode.  icache
+		 * hits do not clear DONTCACHE, so we must do it here.
+		 */
+		spin_lock(&VFS_I(ip)->i_lock);
+		VFS_I(ip)->i_state &= ~I_DONTCACHE;
+		spin_unlock(&VFS_I(ip)->i_lock);
+	} else if (atomic_read(&VFS_I(ip)->i_count) == 1) {
+		/*
+		 * If this is the last reference to the inode and the caller
+		 * permits it, set DONTCACHE to avoid thrashing.
+		 */
+		d_mark_dontcache(VFS_I(ip));
+	}
+
+	xfs_irele(ip);
+}
+
 /* Set us up to scrub a file's contents. */
 int
 xchk_setup_inode_contents(
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 0efe6b947d88..7472c41d9cfe 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -137,6 +137,9 @@ int xchk_get_inode(struct xfs_scrub *sc);
 int xchk_setup_inode_contents(struct xfs_scrub *sc, unsigned int resblks);
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 
+int xchk_iget(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp);
+void xchk_irele(struct xfs_scrub *sc, struct xfs_inode *ip);
+
 /*
  * Don't bother cross-referencing if we already found corruption or cross
  * referencing discrepancies.
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 58b9761db48d..43a1cbf2ac67 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -86,7 +86,7 @@ xchk_dir_check_ftype(
 			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
 	if (ino_dtype != dtype)
 		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
-	xfs_irele(ip);
+	xchk_irele(sdc->sc, ip);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index ab182a5cd0c0..38ea04e66468 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -131,7 +131,6 @@ xchk_parent_validate(
 	xfs_ino_t		dnum,
 	bool			*try_again)
 {
-	struct xfs_mount	*mp = sc->mp;
 	struct xfs_inode	*dp = NULL;
 	xfs_nlink_t		expected_nlink;
 	xfs_nlink_t		nlink;
@@ -168,7 +167,7 @@ xchk_parent_validate(
 	 * -EFSCORRUPTED or -EFSBADCRC then the parent is corrupt which is a
 	 *  cross referencing error.  Any other error is an operational error.
 	 */
-	error = xfs_iget(mp, sc->tp, dnum, XFS_IGET_UNTRUSTED, 0, &dp);
+	error = xchk_iget(sc, dnum, &dp);
 	if (error == -EINVAL || error == -ENOENT) {
 		error = -EFSCORRUPTED;
 		xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error);
@@ -253,7 +252,7 @@ xchk_parent_validate(
 out_unlock:
 	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 out_rele:
-	xfs_irele(dp);
+	xchk_irele(sc, dp);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7a3557a69fe0..bc9638c7a379 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -181,7 +181,7 @@ xchk_teardown(
 			xfs_iunlock(sc->ip, sc->ilock_flags);
 		if (sc->ip != ip_in &&
 		    !xfs_internal_inum(sc->mp, sc->ip->i_ino))
-			xfs_irele(sc->ip);
+			xchk_irele(sc, sc->ip);
 		sc->ip = NULL;
 	}
 	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)

