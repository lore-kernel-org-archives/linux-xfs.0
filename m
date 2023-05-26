Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B96C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjEZCPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjEZCPn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:15:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8D819D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:15:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F21F96157B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFE6C433D2;
        Fri, 26 May 2023 02:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067337;
        bh=lluAXURufSR96U0k4fhHVJn2SBw3m2m4u3w7U0FphQ0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=i7J67WUII6tsPLvZiPUcp4X2hzRb1O0++1dEcL69GpDc6EM6ASkD5gDbLpMGVdTe7
         azdQW9m4iIAh+Zsjx0yPvVI4UDfjb4RaywH4uMxvl0O4gfkmfazhSCD+WssaIta0sT
         zyaA/z76tZ7avVXE2qvPnSApGZ7PaW1xUr/mdWi89V5sRy6vky+NZb4KXCpcRSaXEt
         PLoqcAjQZ1PoustEBHPIvppTJOrXPy2vOjUAxwhwlBiodLUxmRJgUGQOFTRb0dyflZ
         Zc2eDCFuvD5oFkxQQm2nsIPlqYjZkxr8CJ2+qoNZaNSgaLj1MDYTBYepQrZwSBkxzs
         OiyaJhH6Jj7Yw==
Date:   Thu, 25 May 2023 19:15:36 -0700
Subject: [PATCH 04/17] xfs: deferred scrub of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073353.3745075.18102281884357315758.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the trylock-based dirent check fails, retain those parent pointers
and check them at the end.  This may involve dropping the locks on the
file being scanned, so yay.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile       |    2 
 fs/xfs/scrub/parent.c |  269 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/trace.h  |    2 
 3 files changed, 266 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 39b9443608e2..99fd4a5cf051 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -176,6 +176,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   scrub.o \
 				   symlink.o \
 				   xfarray.o \
+				   xfblob.o \
 				   xfile.o \
 				   )
 
@@ -214,7 +215,6 @@ xfs-y				+= $(addprefix scrub/, \
 				   rmap_repair.o \
 				   symlink_repair.o \
 				   tempfile.o \
-				   xfblob.o \
 				   xfbtree.o \
 				   )
 
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 6427f4f14022..8daf08a627b7 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -23,6 +23,9 @@
 #include "scrub/tempfile.h"
 #include "scrub/repair.h"
 #include "scrub/listxattr.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
 #include "scrub/trace.h"
 
 /* Set us up to scrub parents. */
@@ -211,17 +214,42 @@ xchk_parent_validate(
  * forward to the child file.
  */
 
+/* Deferred parent pointer entry that we saved for later. */
+struct xchk_pptr {
+	/* Cookie for retrieval of the pptr name. */
+	xfblob_cookie			name_cookie;
+
+	/* Parent pointer attr key. */
+	xfs_ino_t			p_ino;
+	uint32_t			p_gen;
+
+	/* Length of the pptr name. */
+	uint8_t				namelen;
+};
+
 struct xchk_pptrs {
 	struct xfs_scrub	*sc;
 
 	/* Scratch buffer for scanning pptr xattrs */
 	struct xfs_parent_name_irec pptr;
 
+	/* Fixed-size array of xchk_pptr structures. */
+	struct xfarray		*pptr_entries;
+
+	/* Blobs containing parent pointer names. */
+	struct xfblob		*pptr_names;
+
 	/* How many parent pointers did we find at the end? */
 	unsigned long long	pptrs_found;
 
 	/* Parent of this directory. */
 	xfs_ino_t		parent_ino;
+
+	/* If we've cycled the ILOCK, we must revalidate all deferred pptrs. */
+	bool			need_revalidate;
+
+	/* xattr key and da args for parent pointer revalidation. */
+	struct xfs_parent_scratch pptr_scratch;
 };
 
 /* Look up the dotdot entry so that we can check it as we walk the pptrs. */
@@ -446,8 +474,27 @@ xchk_parent_scan_attr(
 	/* Try to lock the inode. */
 	lockmode = xchk_parent_lock_dir(sc, dp);
 	if (!lockmode) {
-		xchk_set_incomplete(sc);
-		error = -ECANCELED;
+		struct xchk_pptr	save_pp = {
+			.p_ino		= pp->pptr.p_ino,
+			.p_gen		= pp->pptr.p_gen,
+			.namelen	= pp->pptr.p_namelen,
+		};
+
+		/* Couldn't lock the inode, so save the pptr for later. */
+		trace_xchk_parent_defer(sc->ip, pp->pptr.p_name,
+				pp->pptr.p_namelen, dp->i_ino);
+
+		error = xfblob_store(pp->pptr_names, &save_pp.name_cookie,
+				pp->pptr.p_name, pp->pptr.p_namelen);
+		if (xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0,
+					&error))
+			goto out_rele;
+
+		error = xfarray_append(pp->pptr_entries, &save_pp);
+		if (xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0,
+					&error))
+			goto out_rele;
+
 		goto out_rele;
 	}
 
@@ -462,6 +509,180 @@ xchk_parent_scan_attr(
 	return error;
 }
 
+/*
+ * Revalidate a parent pointer that we collected in the past but couldn't check
+ * because of lock contention.  Returns 0 if the parent pointer is still valid,
+ * -ENOENT if it has gone away on us, or a negative errno.
+ */
+STATIC int
+xchk_parent_revalidate_pptr(
+	struct xchk_pptrs	*pp)
+{
+	struct xfs_scrub	*sc = pp->sc;
+	int			error;
+
+	error = xfs_parent_lookup(sc->tp, sc->ip, &pp->pptr,
+			&pp->pptr_scratch);
+	if (error == -ENOATTR) {
+		/* Parent pointer went away, nothing to revalidate. */
+		return -ENOENT;
+	}
+
+	return error;
+}
+
+/*
+ * Check a parent pointer the slow way, which means we cycle locks a bunch
+ * and put up with revalidation until we get it done.
+ */
+STATIC int
+xchk_parent_slow_pptr(
+	struct xchk_pptrs	*pp,
+	struct xchk_pptr	*pptr)
+{
+	struct xfs_scrub	*sc = pp->sc;
+	struct xfs_inode	*dp = NULL;
+	unsigned int		lockmode;
+	int			error;
+
+	/* Restore the saved parent pointer into the irec. */
+	pp->pptr.p_ino = pptr->p_ino;
+	pp->pptr.p_gen = pptr->p_gen;
+
+	error = xfblob_load(pp->pptr_names, pptr->name_cookie, pp->pptr.p_name,
+			pptr->namelen);
+	if (error)
+		return error;
+	pp->pptr.p_name[MAXNAMELEN - 1] = 0;
+	pp->pptr.p_namelen = pptr->namelen;
+	xfs_parent_irec_hashname(sc->mp, &pp->pptr);
+
+	/* Check that the deferred parent pointer still exists. */
+	if (pp->need_revalidate) {
+		error = xchk_parent_revalidate_pptr(pp);
+		if (error == -ENOENT)
+			return 0;
+		if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0,
+					&error))
+			return error;
+	}
+
+	error = xchk_parent_iget(pp, &dp);
+	if (error)
+		return error;
+	if (!dp)
+		return 0;
+
+	/*
+	 * If we can grab both IOLOCK and ILOCK of the alleged parent, we
+	 * can proceed with the validation.
+	 */
+	lockmode = xchk_parent_lock_dir(sc, dp);
+	if (lockmode)
+		goto check_dirent;
+
+	/*
+	 * We couldn't lock the parent dir.  Drop all the locks and try to
+	 * get them again, one at a time.
+	 */
+	xchk_iunlock(sc, sc->ilock_flags);
+	pp->need_revalidate = true;
+
+	trace_xchk_parent_slowpath(sc->ip, pp->pptr.p_name, pptr->namelen,
+			dp->i_ino);
+
+	while (true) {
+		xchk_ilock(sc, XFS_IOLOCK_EXCL);
+		if (xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
+			xchk_ilock(sc, XFS_ILOCK_EXCL);
+			if (xfs_ilock_nowait(dp, XFS_ILOCK_EXCL)) {
+				break;
+			}
+			xchk_iunlock(sc, XFS_ILOCK_EXCL);
+		}
+		xchk_iunlock(sc, XFS_IOLOCK_EXCL);
+
+		if (xchk_should_terminate(sc, &error))
+			goto out_rele;
+
+		delay(1);
+	}
+	lockmode = XFS_IOLOCK_SHARED | XFS_ILOCK_EXCL;
+
+	/*
+	 * If we didn't already find a parent pointer matching the dotdot
+	 * entry, re-query the dotdot entry so that we can validate it.
+	 */
+	if (pp->parent_ino != NULLFSINO) {
+		error = xchk_parent_dotdot(pp);
+		if (error)
+			goto out_unlock;
+	}
+
+	/* Revalidate the parent pointer now that we cycled locks. */
+	error = xchk_parent_revalidate_pptr(pp);
+	if (error == -ENOENT)
+		goto out_unlock;
+	if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &error))
+		goto out_unlock;
+
+check_dirent:
+	error = xchk_parent_dirent(pp, dp);
+out_unlock:
+	xfs_iunlock(dp, lockmode);
+out_rele:
+	xchk_irele(sc, dp);
+	return error;
+}
+
+/* Check all the parent pointers that we deferred the first time around. */
+STATIC int
+xchk_parent_finish_slow_pptrs(
+	struct xchk_pptrs	*pp)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	foreach_xfarray_idx(pp->pptr_entries, array_cur) {
+		struct xchk_pptr	pptr;
+
+		if (pp->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			return 0;
+
+		error = xfarray_load(pp->pptr_entries, array_cur, &pptr);
+		if (error)
+			return error;
+
+		error = xchk_parent_slow_pptr(pp, &pptr);
+		if (error)
+			return error;
+	}
+
+	/* Empty out both xfiles now that we've checked everything. */
+	xfarray_truncate(pp->pptr_entries);
+	xfblob_truncate(pp->pptr_names);
+	return 0;
+}
+
+/* Count the number of parent pointers. */
+STATIC int
+xchk_parent_count_pptr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct xchk_pptrs	*pp = priv;
+
+	if (attr_flags & XFS_ATTR_PARENT)
+		pp->pptrs_found++;
+	return 0;
+}
+
 /*
  * Compare the number of parent pointers to the link count.  For
  * non-directories these should be the same.  For unlinked directories the
@@ -472,6 +693,20 @@ xchk_parent_count_pptrs(
 	struct xchk_pptrs	*pp)
 {
 	struct xfs_scrub	*sc = pp->sc;
+	int			error;
+
+	/*
+	 * If we cycled the ILOCK while cross-checking parent pointers with
+	 * dirents, then we need to recalculate the number of parent pointers.
+	 */
+	if (pp->need_revalidate) {
+		pp->pptrs_found = 0;
+		error = xchk_xattr_walk(sc, sc->ip, xchk_parent_count_pptr, pp);
+		if (error == -ECANCELED)
+			return 0;
+		if (error)
+			return error;
+	}
 
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode)) {
 		if (sc->ip == sc->mp->m_rootip)
@@ -511,16 +746,34 @@ xchk_parent_pptr(
 	if (error)
 		goto out_pp;
 
+	/*
+	 * Set up some staging memory for parent pointers that we can't check
+	 * due to locking contention.
+	 */
+	error = xfarray_create(sc->mp, "slow parent pointer entries", 0,
+			sizeof(struct xchk_pptr), &pp->pptr_entries);
+	if (error)
+		goto out_pp;
+
+	error = xfblob_create(sc->mp, "slow parent pointer names",
+			&pp->pptr_names);
+	if (error)
+		goto out_entries;
+
 	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_attr, pp);
 	if (error == -ECANCELED) {
 		error = 0;
-		goto out_pp;
+		goto out_names;
 	}
 	if (error)
-		goto out_pp;
+		goto out_names;
+
+	error = xchk_parent_finish_slow_pptrs(pp);
+	if (error)
+		goto out_names;
 
 	if (pp->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		goto out_pp;
+		goto out_names;
 
 	/*
 	 * If the parent pointers aren't corrupt, complain if the number of
@@ -528,8 +781,12 @@ xchk_parent_pptr(
 	 */
 	error = xchk_parent_count_pptrs(pp);
 	if (error)
-		goto out_pp;
+		goto out_names;
 
+out_names:
+	xfblob_destroy(pp->pptr_names);
+out_entries:
+	xfarray_destroy(pp->pptr_entries);
 out_pp:
 	kvfree(pp);
 	return error;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 539c51545bcd..28232e4611d7 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1449,6 +1449,8 @@ DEFINE_EVENT(xchk_pptr_class, name, \
 	TP_ARGS(ip, name, namelen, parent_ino))
 DEFINE_XCHK_PPTR_CLASS(xchk_dir_defer);
 DEFINE_XCHK_PPTR_CLASS(xchk_dir_slowpath);
+DEFINE_XCHK_PPTR_CLASS(xchk_parent_defer);
+DEFINE_XCHK_PPTR_CLASS(xchk_parent_slowpath);
 
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)

