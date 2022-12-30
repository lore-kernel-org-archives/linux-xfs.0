Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686DBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiL3Wp1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235648AbiL3Wp0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:45:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A300E13CE7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:45:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 217EEB81D95
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0009C433EF;
        Fri, 30 Dec 2022 22:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440322;
        bh=JIahKHH/l85s1b1gz16xSPI2G6MObjwEZ1+HUZP/OlU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MC02PLqxa0rbCAgrv3kmHpj7qj53j0OEkI+QuuO5ogTZp+Ff+/Jg35/ObArV9ij9p
         QFHN3Iz9Tu0mbyGk24q3W6AJWetAfJ3g1ViynmkLV5aHT1QShIlf5kR6vWeoz8GLxQ
         5HbfoAN90KOk/0JJVPgovSKtSCGNfMPlgBMuFpKopjkkTbqOARNAt0UAryCS6uyA92
         S9oIOaknDZMJxJw5MIhn1yGwTb3CgRby7y5tkQuxRcGC72E9oJXiFsGzcOTr0wgYSF
         bBKZIjG38cyt+i9aaVRldkAhxEmSJgq4fIzI2EjkYBP0zzDFr8vMKCPdVg8+hj3Jes
         EEIU+ObZgX6wQ==
Subject: [PATCH 2/4] xfs: fix an inode lookup race in xchk_get_inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:35 -0800
Message-ID: <167243829583.684831.13639022660758037510.stgit@magnolia>
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

In commit d658e, we tried to improve the robustnes of xchk_get_inode in
the face of EINVAL returns from iget by calling xfs_imap to see if the
inobt itself thinks that the inode is allocated.  Unfortunately, that
commit didn't consider the possibility that the inode gets allocated
after iget but before imap.  In this case, the imap call will succeed,
but we turn that into a corruption error and tell userspace the inode is
corrupt.

Avoid this false corruption report by grabbing the AGI header and
retrying the iget before calling imap.  If the iget succeeds, we can
proceed with the usual scrub-by-handle code.  Fix all the incorrect
comments too, since unreadable/corrupt inodes no longer result in EINVAL
returns.

Fixes: d658e72b4a09 ("xfs: distinguish between corrupt inode and invalid inum in xfs_scrub_get_inode")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |  207 ++++++++++++++++++++++++++++++++++++++++---------
 fs/xfs/scrub/common.h |    4 +
 fs/xfs/xfs_icache.c   |    3 -
 fs/xfs/xfs_icache.h   |   11 ++-
 4 files changed, 182 insertions(+), 43 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 28c43d9f1c56..70ee293bc58f 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -635,6 +635,14 @@ xchk_ag_init(
 
 /* Per-scrubber setup functions */
 
+void
+xchk_trans_cancel(
+	struct xfs_scrub	*sc)
+{
+	xfs_trans_cancel(sc->tp);
+	sc->tp = NULL;
+}
+
 /*
  * Grab an empty transaction so that we can re-grab locked buffers if
  * one of our btrees turns out to be cyclic.
@@ -720,6 +728,84 @@ xchk_iget(
 	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
 }
 
+/*
+ * Try to grab an inode in a manner that avoids races with physical inode
+ * allocation.  If we can't, return the locked AGI buffer so that the caller
+ * can single-step the loading process to see where things went wrong.
+ *
+ * If the iget succeeds, return 0, a NULL AGI, and the inode.
+ *
+ * If the iget fails, return the error, the locked AGI, and a NULL inode.  This
+ * can include -EINVAL and -ENOENT for invalid inode numbers or inodes that are
+ * no longer allocated; or any other corruption or runtime error.
+ *
+ * If the AGI read fails, return the error, a NULL AGI, and NULL inode.
+ *
+ * If a fatal signal is pending, return -EINTR, a NULL AGI, and a NULL inode.
+ */
+int
+xchk_iget_agi(
+	struct xfs_scrub	*sc,
+	xfs_ino_t		inum,
+	struct xfs_buf		**agi_bpp,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_trans	*tp = sc->tp;
+	struct xfs_perag	*pag;
+	int			error;
+
+again:
+	*agi_bpp = NULL;
+	*ipp = NULL;
+	error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
+	error = xfs_ialloc_read_agi(pag, tp, agi_bpp);
+	xfs_perag_put(pag);
+	if (error)
+		return error;
+
+	error = xfs_iget(mp, tp, inum,
+			XFS_IGET_NORETRY | XFS_IGET_UNTRUSTED, 0, ipp);
+	if (error == -EAGAIN) {
+		/*
+		 * The inode may be in core but temporarily unavailable and may
+		 * require the AGI buffer before it can be returned.  Drop the
+		 * AGI buffer and retry the lookup.
+		 */
+		xfs_trans_brelse(tp, *agi_bpp);
+		delay(1);
+		goto again;
+	}
+	if (error)
+		return error;
+
+	/* We got the inode, so we can release the AGI. */
+	ASSERT(*ipp != NULL);
+	xfs_trans_brelse(tp, *agi_bpp);
+	*agi_bpp = NULL;
+	return 0;
+}
+
+/* Install an inode that we opened by handle for scrubbing. */
+static int
+xchk_install_handle_inode(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	if (VFS_I(ip)->i_generation != sc->sm->sm_gen) {
+		xchk_irele(sc, ip);
+		return -ENOENT;
+	}
+
+	sc->ip = ip;
+	return 0;
+}
+
 /*
  * Given an inode and the scrub control structure, grab either the
  * inode referenced in the control structure or the inode passed in.
@@ -731,60 +817,105 @@ xchk_get_inode(
 {
 	struct xfs_imap		imap;
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*agi_bp;
 	struct xfs_inode	*ip_in = XFS_I(file_inode(sc->file));
 	struct xfs_inode	*ip = NULL;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, sc->sm->sm_ino);
 	int			error;
 
+	ASSERT(sc->tp == NULL);
+
 	/* We want to scan the inode we already had opened. */
 	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino) {
 		sc->ip = ip_in;
 		return 0;
 	}
 
-	/* Look up the inode, see if the generation number matches. */
+	/* Reject internal metadata files and obviously bad inode numbers. */
 	if (xfs_internal_inum(mp, sc->sm->sm_ino))
 		return -ENOENT;
+	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
+		return -ENOENT;
+
+	/* Try a regular untrusted iget. */
 	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
-	switch (error) {
-	case -ENOENT:
-		/* Inode doesn't exist, just bail out. */
+	if (!error)
+		return xchk_install_handle_inode(sc, ip);
+	if (error == -ENOENT)
 		return error;
-	case 0:
-		/* Got an inode, continue. */
-		break;
-	case -EINVAL:
-		/*
-		 * -EINVAL with IGET_UNTRUSTED could mean one of several
-		 * things: userspace gave us an inode number that doesn't
-		 * correspond to fs space, or doesn't have an inobt entry;
-		 * or it could simply mean that the inode buffer failed the
-		 * read verifiers.
-		 *
-		 * Try just the inode mapping lookup -- if it succeeds, then
-		 * the inode buffer verifier failed and something needs fixing.
-		 * Otherwise, we really couldn't find it so tell userspace
-		 * that it no longer exists.
-		 */
-		error = xfs_imap(sc->mp, sc->tp, sc->sm->sm_ino, &imap,
-				XFS_IGET_UNTRUSTED);
-		if (error)
-			return -ENOENT;
+	if (error != -EINVAL)
+		goto out_error;
+
+	/*
+	 * EINVAL with IGET_UNTRUSTED probably means one of several things:
+	 * userspace gave us an inode number that doesn't correspond to fs
+	 * space; the inode btree lacks a record for this inode; or there is a
+	 * record, and it says this inode is free.
+	 *
+	 * We want to look up this inode in the inobt to distinguish two
+	 * scenarios: (1) the inobt says the inode is free, in which case
+	 * there's nothing to do; and (2) the inobt says the inode is
+	 * allocated, but loading it failed due to corruption.
+	 *
+	 * Allocate a transaction and grab the AGI to prevent inobt activity
+	 * in this AG.  Retry the iget in case someone allocated a new inode
+	 * after the first iget failed.
+	 */
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		goto out_error;
+
+	error = xchk_iget_agi(sc, sc->sm->sm_ino, &agi_bp, &ip);
+	if (error == 0) {
+		/* Actually got the inode, so install it. */
+		xchk_trans_cancel(sc);
+		return xchk_install_handle_inode(sc, ip);
+	}
+	if (error == -ENOENT)
+		goto out_gone;
+	if (error != -EINVAL)
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
+	 * If the inobt thinks this the inode neither can exist inside the
+	 * filesystem nor is allocated, return ENOENT to signal that the check
+	 * can be skipped.
+	 *
+	 * If the lookup returns corruption, we'll mark this inode corrupt and
+	 * exit to userspace.  There's little chance of fixing anything until
+	 * the inobt is straightened out, but there's nothing we can do here.
+	 *
+	 * If the lookup encounters any other error, exit to userspace.
+	 *
+	 * If the lookup succeeds, something else must be very wrong in the fs
+	 * such that setting up the incore inode failed in some strange way.
+	 * Treat those as corruptions.
+	 */
+	error = xfs_imap(sc->mp, sc->tp, sc->sm->sm_ino, &imap,
+			XFS_IGET_UNTRUSTED);
+	if (error == -EINVAL || error == -ENOENT)
+		goto out_gone;
+	if (!error)
 		error = -EFSCORRUPTED;
-		fallthrough;
-	default:
-		trace_xchk_op_error(sc,
-				XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
-				XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
-				error, __return_address);
-		return error;
-	}
-	if (VFS_I(ip)->i_generation != sc->sm->sm_gen) {
-		xchk_irele(sc, ip);
-		return -ENOENT;
-	}
 
-	sc->ip = ip;
-	return 0;
+out_cancel:
+	xchk_trans_cancel(sc);
+out_error:
+	trace_xchk_op_error(sc, agno, XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
+			error, __return_address);
+	return error;
+out_gone:
+	/* The file is gone, so there's nothing to check. */
+	xchk_trans_cancel(sc);
+	return -ENOENT;
 }
 
 /* Release an inode, possibly dropping it in the process. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 7472c41d9cfe..6a7fe2596841 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -32,6 +32,8 @@ xchk_should_terminate(
 }
 
 int xchk_trans_alloc(struct xfs_scrub *sc, uint resblks);
+void xchk_trans_cancel(struct xfs_scrub *sc);
+
 bool xchk_process_error(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		xfs_agblock_t bno, int *error);
 bool xchk_fblock_process_error(struct xfs_scrub *sc, int whichfork,
@@ -138,6 +140,8 @@ int xchk_setup_inode_contents(struct xfs_scrub *sc, unsigned int resblks);
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 
 int xchk_iget(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp);
+int xchk_iget_agi(struct xfs_scrub *sc, xfs_ino_t inum,
+		struct xfs_buf **agi_bpp, struct xfs_inode **ipp);
 void xchk_irele(struct xfs_scrub *sc, struct xfs_inode *ip);
 
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ddeaccc04aec..0d58d7b0d8ac 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -767,7 +767,8 @@ xfs_iget(
 	return 0;
 
 out_error_or_again:
-	if (!(flags & XFS_IGET_INCORE) && error == -EAGAIN) {
+	if (!(flags & (XFS_IGET_INCORE | XFS_IGET_NORETRY)) &&
+	    error == -EAGAIN) {
 		delay(1);
 		goto again;
 	}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 6cd180721659..87910191a9dd 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -34,10 +34,13 @@ struct xfs_icwalk {
 /*
  * Flags for xfs_iget()
  */
-#define XFS_IGET_CREATE		0x1
-#define XFS_IGET_UNTRUSTED	0x2
-#define XFS_IGET_DONTCACHE	0x4
-#define XFS_IGET_INCORE		0x8	/* don't read from disk or reinit */
+#define XFS_IGET_CREATE		(1U << 0)
+#define XFS_IGET_UNTRUSTED	(1U << 1)
+#define XFS_IGET_DONTCACHE	(1U << 2)
+/* don't read from disk or reinit */
+#define XFS_IGET_INCORE		(1U << 3)
+/* Return -EAGAIN immediately if the inode is unavailable. */
+#define XFS_IGET_NORETRY	(1U << 4)
 
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);

