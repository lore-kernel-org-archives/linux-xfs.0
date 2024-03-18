Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA2059B77
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798558; cv=none; b=qq5+uaVvHzMZfR8ndHgdXYJA5Fyos3V3qP3cQB4pmcnY1wRQPaDZwrjYe83JgEfgZkwlYvRrXmUQ5jw8ElzslF3h8F5vnXiEd8R3VOcyUDs4mstndYCI9iqHaZOIhMtfazhgvQ9i7iSAeIzWmZZzvOkS1HhixKdACOkl3PBfAqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798558; c=relaxed/simple;
	bh=R+7eQUbewDmcqbHoRIWyLJjwTV2W9ImSuEZYIm4V8ik=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qKGA7Tulwj/TJudgAm8mcBjtLn7UyjHrGKX743inOdapT1UbTRfrpbWvSvn/+V1ZSgqBn1rpgejLWA/YVovuQF3AdUgIA3QxwJO01IZEkObGmurtmLUbrbj3OPqkn1cnmYxHEjEZG/DdNylnY17efV4aEbmb5YzpOjOt04y/04U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p2l0nRXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2l0nRXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778DDC433F1;
	Mon, 18 Mar 2024 21:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798558;
	bh=R+7eQUbewDmcqbHoRIWyLJjwTV2W9ImSuEZYIm4V8ik=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p2l0nRXf0e+4nxAI+L9gKpPpTm7nTvwRRn20RMO8MBzuy2LGQfDWG9sbL/zbv3iwO
	 86zonULvV9nNByNh8B6RlAlLJrXzg2/Q7ZLAbdbckX6jGD6V01k7wcPZmJyfkA8vsR
	 W3T7h+b+QZI/NbBVhUyf0TOm9ByaBYHy/0EKvUUaDV4rEG0qhRhEn7puK0CEi4etDW
	 RVvDj7JFmOmSo4PbVBQCYHkGM69ic2t18VNqmKsJqFLdEDXHvNLTkz/aNa3iRFSsOH
	 bePJ8fHv2zM/kxOv+Tipa3oqGJ/KHXaJSfeYQPVU8rvg02KqfcFu5L7jMP1KizlJPr
	 doK7lndCnq5pg==
Date: Mon, 18 Mar 2024 14:49:17 -0700
Subject: [PATCH 05/23] xfs: deferred scrub of parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802775.3808642.9429941409602204849.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/Makefile       |    2 
 fs/xfs/scrub/parent.c |  263 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/trace.h  |    3 +
 3 files changed, 260 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 599085a18c292..74f669e5d10c1 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -178,6 +178,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   scrub.o \
 				   symlink.o \
 				   xfarray.o \
+				   xfblob.o \
 				   xfile.o \
 				   )
 
@@ -219,7 +220,6 @@ xfs-y				+= $(addprefix scrub/, \
 				   rmap_repair.o \
 				   symlink_repair.o \
 				   tempfile.o \
-				   xfblob.o \
 				   )
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 7a5c57cdf93e4..3bacd3e14f5d3 100644
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
 
 /* Does this parent pointer match the dotdot entry? */
@@ -475,8 +503,27 @@ xchk_parent_scan_attr(
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
 
@@ -491,6 +538,159 @@ xchk_parent_scan_attr(
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
+	if (lockmode) {
+		trace_xchk_parent_slowpath(sc->ip, pp->pptr.p_name,
+				pptr->namelen, dp->i_ino);
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
+	trace_xchk_parent_ultraslowpath(sc->ip, pp->pptr.p_name, pptr->namelen,
+			dp->i_ino);
+
+	error = xchk_dir_trylock_for_pptrs(sc, dp, &lockmode);
+	if (error)
+		goto out_rele;
+
+	/* Revalidate the parent pointer now that we cycled locks. */
+	error = xchk_parent_revalidate_pptr(pp);
+	if (error == -ENOENT) {
+		error = 0;
+		goto out_unlock;
+	}
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
+	const struct xfs_parent_name_irec *pptr,
+	void			*priv)
+{
+	struct xchk_pptrs	*pp = priv;
+
+	if (!xfs_parent_verify_irec(sc->mp, pptr))
+		return -EFSCORRUPTED;
+
+	pp->pptrs_found++;
+	return 0;
+}
+
 /*
  * Compare the number of parent pointers to the link count.  For
  * non-directories these should be the same.  For unlinked directories the
@@ -501,6 +701,24 @@ xchk_parent_count_pptrs(
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
+		error = xchk_pptr_walk(sc, sc->ip, xchk_parent_count_pptr,
+				&pp->pptr, pp);
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
@@ -525,6 +743,7 @@ xchk_parent_pptr(
 	struct xfs_scrub	*sc)
 {
 	struct xchk_pptrs	*pp;
+	char			*descr;
 	int			error;
 
 	pp = kvzalloc(sizeof(struct xchk_pptrs), XCHK_GFP_FLAGS);
@@ -532,16 +751,42 @@ xchk_parent_pptr(
 		return -ENOMEM;
 	pp->sc = sc;
 
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
@@ -559,7 +804,7 @@ xchk_parent_pptr(
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode)) {
 		error = xchk_parent_pptr_and_dotdot(pp);
 		if (error)
-			goto out_pp;
+			goto out_names;
 	}
 
 	if (pp->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -572,8 +817,12 @@ xchk_parent_pptr(
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
index d6957a9680190..e1471f8ff941f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1538,6 +1538,9 @@ DEFINE_EVENT(xchk_pptr_class, name, \
 DEFINE_XCHK_PPTR_EVENT(xchk_dir_defer);
 DEFINE_XCHK_PPTR_EVENT(xchk_dir_slowpath);
 DEFINE_XCHK_PPTR_EVENT(xchk_dir_ultraslowpath);
+DEFINE_XCHK_PPTR_EVENT(xchk_parent_defer);
+DEFINE_XCHK_PPTR_EVENT(xchk_parent_slowpath);
+DEFINE_XCHK_PPTR_EVENT(xchk_parent_ultraslowpath);
 
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)

