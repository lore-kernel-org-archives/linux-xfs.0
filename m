Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162D2C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiJBSez (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiJBSev (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7D512AE5
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:34:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09BDE60F06
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674B9C433C1;
        Sun,  2 Oct 2022 18:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735689;
        bh=rFOm2mQU0QIOyb7Q+F44YuJS0w1QvoxTG9CmzWT1Gzg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JF9kqw0xLCr19dd+p0pzMVG2in4buRkzIC6+C4Fys+0wwqRrfgk/lzYfQ/El5AS7r
         akizF3RdzZJYKLlsJOb+RCKKRgTFbRb7Bgo0jkLUCalbbIPFCjbiIYTA2Vm5mpu+oI
         oyClNwE0BatLcwRXw8rI/8cIhgoF7wgIS+5n35/JqqeXb6NdZ6aGZD4sPtk8rsnY7J
         hAbDmlOh4T/fUvFRqmx2RNVkkGQsjZi+LGaPPi9T2Y043tpuVPZ5qt2/bKGs8Kw7Ks
         Jd0Gugk56nWtJNH/I0e7BzHmAMDd3I+/4ujGcfBZqRbFf2NwIgJ4mEWODUURFM3MTV
         gLLHquwk5lqSQ==
Subject: [PATCH 3/3] xfs: retain the AGI when we can't iget an inode to scrub
 the core
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:29 -0700
Message-ID: <166473482971.1084685.9939611867095895186.stgit@magnolia>
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

xchk_get_inode is not quite the right function to be calling from the
inode scrubber setup function.  The common get_inode function either
gets an inode and installs it in the scrub context, or it returns an
error code explaining what happened.  This is acceptable for most file
scrubbers because it is not in their scope to fix corruptions in the
inode core and fork areas that cause iget to fail.

Dealing with these problems is within the scope of the inode scrubber,
however.  If iget fails with EFSCORRUPTED, we need to xchk_inode to flag
that as corruption.  Since we can't get our hands on an incore inode, we
need to hold the AGI to prevent inode allocation activity so that
nothing changes in the inode metadata.

Looking ahead to the inode core repair patches, we will also need to
hold the AGI buffer into xrep_inode so that we can make modifications to
the xfs_dinode structure without any other thread swooping in to
allocate or free the inode.

Adapt the xchk_get_inode into xchk_setup_inode since this is a one-off
use case where the error codes we check for are a little different, and
the return state is much different from the common function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |    2 -
 fs/xfs/scrub/common.h |    1 
 fs/xfs/scrub/inode.c  |  163 +++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 144 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9a811c5fa8f7..dd60c7ced780 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -788,7 +788,7 @@ xchk_iget_agi(
 }
 
 /* Install an inode that we opened by handle for scrubbing. */
-static int
+int
 xchk_install_handle_inode(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 6a7fe2596841..4d621811eb89 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -143,6 +143,7 @@ int xchk_iget(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp);
 int xchk_iget_agi(struct xfs_scrub *sc, xfs_ino_t inum,
 		struct xfs_buf **agi_bpp, struct xfs_inode **ipp);
 void xchk_irele(struct xfs_scrub *sc, struct xfs_inode *ip);
+int xchk_install_handle_inode(struct xfs_scrub *sc, struct xfs_inode *ip);
 
 /*
  * Don't bother cross-referencing if we already found corruption or cross
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 3b272c86d0ad..c1136b62811b 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -11,8 +11,10 @@
 #include "xfs_mount.h"
 #include "xfs_btree.h"
 #include "xfs_log_format.h"
+#include "xfs_trans.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
+#include "xfs_icache.h"
 #include "xfs_da_format.h"
 #include "xfs_reflink.h"
 #include "xfs_rmap.h"
@@ -20,6 +22,41 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "scrub/trace.h"
+
+/* Prepare the attached inode for scrubbing. */
+static inline int
+xchk_prepare_iscrub(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/* Install this scrub-by-handle inode and prepare it for scrubbing. */
+static inline int
+xchk_install_handle_iscrub(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	int			error;
+
+	error = xchk_install_handle_inode(sc, ip);
+	if (error)
+		return error;
+
+	return xchk_prepare_iscrub(sc);
+}
 
 /*
  * Grab total control of the inode metadata.  It doesn't matter here if
@@ -30,38 +67,122 @@ int
 xchk_setup_inode(
 	struct xfs_scrub	*sc)
 {
+	struct xfs_imap		imap;
+	struct xfs_inode	*ip;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip_in = XFS_I(file_inode(sc->file));
+	struct xfs_buf		*agi_bp;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, sc->sm->sm_ino);
 	int			error;
 
 	if (xchk_need_fshook_drain(sc))
 		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
 
-	/*
-	 * Try to get the inode.  If the verifiers fail, we try again
-	 * in raw mode.
-	 */
-	error = xchk_get_inode(sc);
-	switch (error) {
-	case 0:
-		break;
-	case -EFSCORRUPTED:
-	case -EFSBADCRC:
-		return xchk_trans_alloc(sc, 0);
-	default:
+	/* We want to scan the opened inode, so lock it and exit. */
+	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino) {
+		sc->ip = ip_in;
+		return xchk_prepare_iscrub(sc);
+	}
+
+	/* Reject internal metadata files and obviously bad inode numbers. */
+	if (xfs_internal_inum(mp, sc->sm->sm_ino))
+		return -ENOENT;
+	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
+		return -ENOENT;
+
+	/* Try a regular untrusted iget. */
+	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
+	if (!error)
+		return xchk_install_handle_iscrub(sc, ip);
+	if (error == -ENOENT)
 		return error;
-	}
+	if (error != -EFSCORRUPTED && error != -EFSBADCRC && error != -EINVAL)
+		goto out_error;
 
-	/* Got the inode, lock it and we're ready to go. */
-	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	/*
+	 * EINVAL with IGET_UNTRUSTED probably means one of several things:
+	 * userspace gave us an inode number that doesn't correspond to fs
+	 * space; the inode btree lacks a record for this inode; or there is
+	 * a record, and it says this inode is free.
+	 *
+	 * EFSCORRUPTED/EFSBADCRC could mean that the inode was mappable, but
+	 * some other metadata corruption (e.g. inode forks) prevented
+	 * instantiation of the incore inode.  Or it could mean the inobt is
+	 * corrupt.
+	 *
+	 * We want to look up this inode in the inobt directly to distinguish
+	 * three different scenarios: (1) the inobt says the inode is free,
+	 * in which case there's nothing to do; (2) the inobt is corrupt so we
+	 * should flag the corruption and exit to userspace to let it fix the
+	 * inobt; and (3) the inobt says the inode is allocated, but loading it
+	 * failed due to corruption.
+	 *
+	 * Allocate a transaction and grab the AGI to prevent inobt activity in
+	 * this AG.  Retry the iget in case someone allocated a new inode after
+	 * the first iget failed.
+	 */
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
-		goto out;
-	sc->ilock_flags |= XFS_ILOCK_EXCL;
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+		goto out_error;
 
-out:
-	/* scrub teardown will unlock and release the inode for us */
+	error = xchk_iget_agi(sc, sc->sm->sm_ino, &agi_bp, &ip);
+	if (error == 0) {
+		/* Actually got the incore inode, so install it and proceed. */
+		xchk_trans_cancel(sc);
+		return xchk_install_handle_iscrub(sc, ip);
+	}
+	if (error == -ENOENT)
+		goto out_gone;
+	if (error != -EFSCORRUPTED && error != -EFSBADCRC && error != -EINVAL)
+		goto out_cancel;
+
+	/* Ensure that we have protected against inode allocation/freeing. */
+	if (agi_bp == NULL) {
+		ASSERT(agi_bp != NULL);
+		error = -ECANCELED;
+		goto out_cancel;
+	}
+
+	/*
+	 * Untrusted iget failed a second time.  Let's try an inobt lookup.
+	 * If the inobt doesn't think this is an allocated inode then we'll
+	 * return ENOENT to signal that the check can be skipped.
+	 *
+	 * If the lookup signals corruption, we'll mark this inode corrupt and
+	 * exit to userspace.  There's little chance of fixing anything until
+	 * the inobt is straightened out, but there's nothing we can do here.
+	 *
+	 * If the lookup encounters a runtime error, exit to userspace.
+	 */
+	error = xfs_imap(mp, sc->tp, sc->sm->sm_ino, &imap,
+			XFS_IGET_UNTRUSTED);
+	if (error == -EINVAL || error == -ENOENT)
+		goto out_gone;
+	if (error)
+		goto out_cancel;
+
+	/*
+	 * The lookup succeeded.  Chances are the ondisk inode is corrupt and
+	 * preventing iget from reading it.  Retain the scrub transaction and
+	 * the AGI buffer to prevent anyone from allocating or freeing inodes.
+	 * This ensures that we preserve the inconsistency between the inobt
+	 * saying the inode is allocated and the icache being unable to load
+	 * the inode until we can flag the corruption in xchk_inode.  The
+	 * scrub function has to note the corruption, since we're not really
+	 * supposed to do that from the setup function.
+	 */
+	return 0;
+
+out_cancel:
+	xchk_trans_cancel(sc);
+out_error:
+	trace_xchk_op_error(sc, agno, XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
+			error, __return_address);
 	return error;
+out_gone:
+	/* The file is gone, so there's nothing to check. */
+	xchk_trans_cancel(sc);
+	return -ENOENT;
 }
 
 /* Inode core */

