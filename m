Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707BA7464
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231326; cv=none; b=o9U7+RIilzhKFC6C0z8bQ1cEH7WqyAXtR+UxFP5yYkxBXIPTWv7PpklA+p3FIX26OjTl+GD1mparQDuCOZLsP6ugETvhTY1p3epr+0X1SXcTJBHdP8pmEr6+A/DKV/mcWlwLJxPUMCTzyuDv/aZVmI6XzMdjKhUHxVF174sQE+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231326; c=relaxed/simple;
	bh=ycLX4Qpg+BWFmiv8jNq5jV7cVsc6ns61OyKpvBcnzzc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qHH0YHblXp58LjmfquUIiCaNXmbCoe+dwWGBo8VHHw+qAfg5FDXpgp82hYJEww4FKPcOfarWihow2THKtWhwq7comMrjrIUMNjWUAmYn7BEZuAHmMZM+tXaKxOModbVVejqLUA05/WVGHsIA5Jj2zxIgepiTyLfbDpNiarUpoOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cgmtmz/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cgmtmz/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25F2C113CC;
	Tue, 16 Apr 2024 01:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231326;
	bh=ycLX4Qpg+BWFmiv8jNq5jV7cVsc6ns61OyKpvBcnzzc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Cgmtmz/H9+9UpuRHDPKsDEGHNVGfdEx1xtbLJahWK8nHa5Wkf2YBV3kS+uvHd4qaI
	 8kHe3wgz8RUvkCTB0AVJSfB9tp+PYYUx4FTpF0wHzaY+/7vhELL8zsSvvHfZA97OJg
	 BebUUxQWXWpjt4V9xZp0NmUvCUIY5CpP1naFuHD9iZWt5D1uOyJrIJznDSYa52Dzix
	 pP6CK5Z66zCBAH3OEKa10Q6wy/DUyA5HsxIRxfX45O2gTOAF6XBOilC5n7msE3IJSP
	 sQP22+2eoGTSk853H8W6mknmJyQVI/e5DO3wKzZVlbqJiRiNh93OuQNKoZf7sxTWdC
	 dWjJn4F4oLr7A==
Date: Mon, 15 Apr 2024 18:35:25 -0700
Subject: [PATCH 5/7] xfs: deferred scrub of parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028748.252774.11137696310734613102.stgit@frogsfrogsfrogs>
In-Reply-To: <171323028648.252774.8320615230798893063.stgit@frogsfrogsfrogs>
References: <171323028648.252774.8320615230798893063.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the trylock-based dirent check fails, retain those parent pointers
and check them at the end.  This may involve dropping the locks on the
file being scanned, so yay.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile       |    2 
 fs/xfs/scrub/parent.c |  267 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/trace.h  |    3 +
 3 files changed, 264 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c969b11ce0f47..af99a455ce4db 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -177,6 +177,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   scrub.o \
 				   symlink.o \
 				   xfarray.o \
+				   xfblob.o \
 				   xfile.o \
 				   )
 
@@ -218,7 +219,6 @@ xfs-y				+= $(addprefix scrub/, \
 				   rmap_repair.o \
 				   symlink_repair.o \
 				   tempfile.o \
-				   xfblob.o \
 				   )
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 6ebbb71041269..f14e6f643fb60 100644
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
@@ -211,6 +214,18 @@ xchk_parent_validate(
  * forward to the child file.
  */
 
+/* Deferred parent pointer entry that we saved for later. */
+struct xchk_pptr {
+	/* Cookie for retrieval of the pptr name. */
+	xfblob_cookie		name_cookie;
+
+	/* Parent pointer record. */
+	struct xfs_parent_rec	pptr_rec;
+
+	/* Length of the pptr name. */
+	uint8_t			namelen;
+};
+
 struct xchk_pptrs {
 	struct xfs_scrub	*sc;
 
@@ -219,6 +234,22 @@ struct xchk_pptrs {
 
 	/* Parent of this directory. */
 	xfs_ino_t		parent_ino;
+
+	/* Fixed-size array of xchk_pptr structures. */
+	struct xfarray		*pptr_entries;
+
+	/* Blobs containing parent pointer names. */
+	struct xfblob		*pptr_names;
+
+	/* Scratch buffer for scanning pptr xattrs */
+	struct xfs_da_args	pptr_args;
+
+	/* If we've cycled the ILOCK, we must revalidate all deferred pptrs. */
+	bool			need_revalidate;
+
+	/* Name buffer */
+	struct xfs_name		xname;
+	char			namebuf[MAXNAMELEN];
 };
 
 /* Does this parent pointer match the dotdot entry? */
@@ -461,8 +492,25 @@ xchk_parent_scan_attr(
 	/* Try to lock the inode. */
 	lockmode = xchk_parent_lock_dir(sc, dp);
 	if (!lockmode) {
-		xchk_set_incomplete(sc);
-		error = -ECANCELED;
+		struct xchk_pptr	save_pp = {
+			.pptr_rec	= *pptr_rec, /* struct copy */
+			.namelen	= namelen,
+		};
+
+		/* Couldn't lock the inode, so save the pptr for later. */
+		trace_xchk_parent_defer(sc->ip, &xname, dp->i_ino);
+
+		error = xfblob_storename(pp->pptr_names, &save_pp.name_cookie,
+				&xname);
+		if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0,
+					&error))
+			goto out_rele;
+
+		error = xfarray_append(pp->pptr_entries, &save_pp);
+		if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0,
+					&error))
+			goto out_rele;
+
 		goto out_rele;
 	}
 
@@ -477,6 +525,162 @@ xchk_parent_scan_attr(
 	return error;
 }
 
+/*
+ * Revalidate a parent pointer that we collected in the past but couldn't check
+ * because of lock contention.  Returns 0 if the parent pointer is still valid,
+ * -ENOENT if it has gone away on us, or a negative errno.
+ */
+STATIC int
+xchk_parent_revalidate_pptr(
+	struct xchk_pptrs		*pp,
+	const struct xfs_name		*xname,
+	struct xfs_parent_rec		*pptr)
+{
+	struct xfs_scrub		*sc = pp->sc;
+	int				error;
+
+	error = xfs_parent_lookup(sc->tp, sc->ip, xname, pptr, &pp->pptr_args);
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
+	const struct xfs_name	*xname,
+	struct xfs_parent_rec	*pptr)
+{
+	struct xfs_scrub	*sc = pp->sc;
+	struct xfs_inode	*dp = NULL;
+	unsigned int		lockmode;
+	int			error;
+
+	/* Check that the deferred parent pointer still exists. */
+	if (pp->need_revalidate) {
+		error = xchk_parent_revalidate_pptr(pp, xname, pptr);
+		if (error == -ENOENT)
+			return 0;
+		if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0,
+					&error))
+			return error;
+	}
+
+	error = xchk_parent_iget(pp, pptr, &dp);
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
+	if (lockmode) {
+		trace_xchk_parent_slowpath(sc->ip, xname, dp->i_ino);
+		goto check_dirent;
+	}
+
+	/*
+	 * We couldn't lock the parent dir.  Drop all the locks and try to
+	 * get them again, one at a time.
+	 */
+	xchk_iunlock(sc, sc->ilock_flags);
+	pp->need_revalidate = true;
+
+	trace_xchk_parent_ultraslowpath(sc->ip, xname, dp->i_ino);
+
+	error = xchk_dir_trylock_for_pptrs(sc, dp, &lockmode);
+	if (error)
+		goto out_rele;
+
+	/* Revalidate the parent pointer now that we cycled locks. */
+	error = xchk_parent_revalidate_pptr(pp, xname, pptr);
+	if (error == -ENOENT) {
+		error = 0;
+		goto out_unlock;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &error))
+		goto out_unlock;
+
+check_dirent:
+	error = xchk_parent_dirent(pp, xname, dp);
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
+		error = xfblob_loadname(pp->pptr_names, pptr.name_cookie,
+				&pp->xname, pptr.namelen);
+		if (error)
+			return error;
+
+		error = xchk_parent_slow_pptr(pp, &pp->xname, &pptr.pptr_rec);
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
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	unsigned int			attr_flags,
+	const unsigned char		*name,
+	unsigned int			namelen,
+	const void			*value,
+	unsigned int			valuelen,
+	void				*priv)
+{
+	struct xchk_pptrs		*pp = priv;
+	int				error;
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	error = xfs_parent_from_attr(sc->mp, attr_flags, name, namelen, value,
+			valuelen, NULL, NULL);
+	if (error)
+		return error;
+
+	pp->pptrs_found++;
+	return 0;
+}
+
 /*
  * Compare the number of parent pointers to the link count.  For
  * non-directories these should be the same.  For unlinked directories the
@@ -487,6 +691,23 @@ xchk_parent_count_pptrs(
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
+		if (error == -EFSCORRUPTED) {
+			/* Found a bad parent pointer */
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			return 0;
+		}
+		if (error)
+			return error;
+	}
 
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode)) {
 		if (sc->ip == sc->mp->m_rootip)
@@ -511,23 +732,51 @@ xchk_parent_pptr(
 	struct xfs_scrub	*sc)
 {
 	struct xchk_pptrs	*pp;
+	char			*descr;
 	int			error;
 
 	pp = kvzalloc(sizeof(struct xchk_pptrs), XCHK_GFP_FLAGS);
 	if (!pp)
 		return -ENOMEM;
 	pp->sc = sc;
+	pp->xname.name = pp->namebuf;
+
+	/*
+	 * Set up some staging memory for parent pointers that we can't check
+	 * due to locking contention.
+	 */
+	descr = xchk_xfile_ino_descr(sc, "slow parent pointer entries");
+	error = xfarray_create(descr, 0, sizeof(struct xchk_pptr),
+			&pp->pptr_entries);
+	kfree(descr);
+	if (error)
+		goto out_pp;
+
+	descr = xchk_xfile_ino_descr(sc, "slow parent pointer names");
+	error = xfblob_create(descr, &pp->pptr_names);
+	kfree(descr);
+	if (error)
+		goto out_entries;
 
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
+	if (error == -ETIMEDOUT) {
+		/* Couldn't grab a lock, scrub was marked incomplete */
+		error = 0;
+		goto out_names;
+	}
+	if (error)
+		goto out_names;
 
 	if (pp->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		goto out_pp;
+		goto out_names;
 
 	/*
 	 * For subdirectories, make sure the dotdot entry references the same
@@ -545,7 +794,7 @@ xchk_parent_pptr(
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode)) {
 		error = xchk_parent_pptr_and_dotdot(pp);
 		if (error)
-			goto out_pp;
+			goto out_names;
 	}
 
 	if (pp->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -558,8 +807,12 @@ xchk_parent_pptr(
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
index 4db762480b8d4..97a106519b531 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1544,6 +1544,9 @@ DEFINE_EVENT(xchk_pptr_class, name, \
 DEFINE_XCHK_PPTR_EVENT(xchk_dir_defer);
 DEFINE_XCHK_PPTR_EVENT(xchk_dir_slowpath);
 DEFINE_XCHK_PPTR_EVENT(xchk_dir_ultraslowpath);
+DEFINE_XCHK_PPTR_EVENT(xchk_parent_defer);
+DEFINE_XCHK_PPTR_EVENT(xchk_parent_slowpath);
+DEFINE_XCHK_PPTR_EVENT(xchk_parent_ultraslowpath);
 
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)

