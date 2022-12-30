Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD74CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiL3Wp6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbiL3Wp5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:45:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6749832F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:45:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14950B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C982BC433D2;
        Fri, 30 Dec 2022 22:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440353;
        bh=ss4HSUGiNE347TM7oxjMvA8FZDCGCRazOdKSvQITjaw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=N4lp9w7RIY7TbPYYhbUP6S8n/1GSRWSwWAltW5VwaLgR4NmMv0bz2uZOD/r6zhuWY
         CIWqyFJ04dsLzGDbx0RaCvUF7Km1aGZAD+bGLyvzjY+Zy3GA8eOgiJakXi+rj2A6IQ
         qR7sy4ovC+J7hXj3rVKuPcIDQHWPjhqW57H4+sMcYXf21+3Nveyv9+fQmMAOh5+MOA
         UQPer7j14GA2cfrMVEGcJgIIZ5HLvdZgNlYLNVpVI5pr5FNwwZ8rowxyqt/Hm3SNUh
         e+MdAcXGypgPyRk0PnUS3kJC26e2gh388vB3ft41W11b2fuK/0a7OZIqTskSpMmj1r
         ILBtR2yBXbLEg==
Subject: [PATCH 4/4] xfs: retain the AGI when we can't iget an inode to scrub
 the core
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:36 -0800
Message-ID: <167243829611.684831.4165413752588458060.stgit@magnolia>
In-Reply-To: <167243829551.684831.7487988225134202107.stgit@magnolia>
References: <167243829551.684831.7487988225134202107.stgit@magnolia>
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

xchk_setup_inode prepares to check or repair an inode record, so it must
continue the scrub operation even if the inode/inobt verifiers cause
xfs_iget to return EFSCORRUPTED.  This is done by attaching the locked
AGI buffer to the scrub transaction and returning 0 to move on to the
actual scrub.  (Later, the online inode repair code will also want the
xfs_imap structure so that it can reset the ondisk xfs_dinode
structure.)

xchk_get_inode retrieves an inode on behalf of a scrubber that operates
on an incore inode -- data/attr/cow forks, directories, xattrs,
symlinks, parent pointers, etc.  If the inode/inobt verifiers fail and
xfs_iget returns EFSCORRUPTED, we want to exit to userspace (because the
caller should be fix the inode first) and drop everything we acquired
along the way.

A behavior common to both functions is that it's possible that xfs_scrub
asked for a scrub-by-handle concurrent with the inode being freed or the
passed-in inumber is invalid.  In this case, we call xfs_imap to see if
the inobt index thinks the inode is allocated, and return ENOENT
("nothing to check here") to userspace if this is not the case.  The
imap lookup is why both functions call xchk_iget_agi.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |    2 -
 fs/xfs/scrub/common.h |    1 
 fs/xfs/scrub/inode.c  |  180 +++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 153 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 90f53f415d99..e0c1be0161f3 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -792,7 +792,7 @@ xchk_iget_agi(
 }
 
 /* Install an inode that we opened by handle for scrubbing. */
-static int
+int
 xchk_install_handle_inode(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 5ef27e6bdac6..07daea2c7ab4 100644
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
index 39ac7cc09fbd..51b8ba7037f3 100644
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
@@ -20,48 +22,168 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "scrub/trace.h"
 
-/*
- * Grab total control of the inode metadata.  It doesn't matter here if
- * the file data is still changing; exclusive access to the metadata is
- * the goal.
- */
-int
-xchk_setup_inode(
+/* Prepare the attached inode for scrubbing. */
+static inline int
+xchk_prepare_iscrub(
 	struct xfs_scrub	*sc)
 {
 	int			error;
 
-	if (xchk_need_fshook_drain(sc))
-		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
-
-	/*
-	 * Try to get the inode.  If the verifiers fail, we try again
-	 * in raw mode.
-	 */
-	error = xchk_iget_for_scrubbing(sc);
-	switch (error) {
-	case 0:
-		break;
-	case -EFSCORRUPTED:
-	case -EFSBADCRC:
-		return xchk_trans_alloc(sc, 0);
-	default:
-		return error;
-	}
-
-	/* Got the inode, lock it and we're ready to go. */
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
-		goto out;
+		return error;
+
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
 	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+	return 0;
+}
 
-out:
-	/* scrub teardown will unlock and release the inode for us */
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
+
+/*
+ * Grab total control of the inode metadata.  In the best case, we grab the
+ * incore inode and take all locks on it.  If the incore inode cannot be
+ * constructed due to corruption problems, lock the AGI so that we can single
+ * step the loading process to fix everything that can go wrong.
+ */
+int
+xchk_setup_inode(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_imap		imap;
+	struct xfs_inode	*ip;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip_in = XFS_I(file_inode(sc->file));
+	struct xfs_buf		*agi_bp;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, sc->sm->sm_ino);
+	int			error;
+
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
+
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
+		return error;
+	if (error != -EFSCORRUPTED && error != -EFSBADCRC && error != -EINVAL)
+		goto out_error;
+
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
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		goto out_error;
+
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

