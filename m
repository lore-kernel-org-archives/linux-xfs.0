Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77328469
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371736; cv=none; b=LokR+ZA84B3hhB+g/meEnWu3vi3Me9dVjwU/E6N4qVXscA99AhrC/XVrwPxE3mdjcigqLOBJEfnF7I8ctrk1uv4Il4bzkkI0UpZc5eF5X1UZxr9oFSc2GRgTccficap98iH8lgrm4xmEOjEOu526R2DtQJXAu6EGwW35Q/aLejI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371736; c=relaxed/simple;
	bh=rYNEItJZijO5DtW3TPuLKsRre1NimvfHLcxS8ez9WdI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E5/6N/9gJsdOBb+TM5akzXr8mOqh8hLlXntIq1H35ayaXMU4/MTOecJNga3rKg600f7F70NA3fCG3wZYmM/iYWCMwoKZU1/FpEPwqoU930RchQx0ZTRooAKVslCRWB0djfBJbr92OXVQ45l2z/Iy2Hnpm5dnOAE7ap3rMPJReBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pENME43X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pENME43X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75665C32782;
	Fri, 23 Aug 2024 00:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371736;
	bh=rYNEItJZijO5DtW3TPuLKsRre1NimvfHLcxS8ez9WdI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pENME43XB291gNfzpIwUpb6AhZbjI3UFbYA17cwh3YlsqyJdkPODxRrAlDfTj7hRP
	 +vITM/SQTxx6yG/xDwrKe4pqHIcbkyQ5EifdFr3lbOlgz/akR521x1n+JOy7MThCL8
	 JHt3JlQ8aLw7jHo/135qja/E/RoJQmK8RtR1DL4EzHRdX8Psb1VA4mVl8Pg5ubaLLk
	 fo7DnifXLUi72BAYU0gZrzMHGXUonApmcuCHcZOETGCayHf1uW6yhVR+9tfo/+egzw
	 1HVs48+5jJJBsrrV1ZpyA2Dg35Ma/lCy1G6/naFmgpotY2xOz/0P7t1A4ddHAUr/sp
	 GRp+q5rcurhCQ==
Date: Thu, 22 Aug 2024 17:08:55 -0700
Subject: [PATCH 26/26] xfs: repair metadata directory file path connectivity
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085623.57482.13203244447795959369.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

Fix disconnected or incorrect metadata directory paths.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/metapath.c |  351 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h   |    3 
 fs/xfs/scrub/scrub.c    |    2 
 fs/xfs/scrub/trace.h    |    5 +
 4 files changed, 358 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index b7bd86df9877c..edc1a395c4015 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -16,10 +16,15 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_dir2.h"
+#include "xfs_parent.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_attr.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
 #include "scrub/readdir.h"
+#include "scrub/repair.h"
 
 /*
  * Metadata Directory Tree Paths
@@ -38,15 +43,28 @@ struct xchk_metapath {
 	/* Name for lookup */
 	struct xfs_name			xname;
 
-	/* Path for this metadata file and the parent directory */
+	/* Directory update for repairs */
+	struct xfs_dir_update		du;
+
+	/* Path down to this metadata file from the parent directory */
 	const char			*path;
-	const char			*parent_path;
 
 	/* Directory parent of the metadata file. */
 	struct xfs_inode		*dp;
 
 	/* Locks held on dp */
 	unsigned int			dp_ilock_flags;
+
+	/* Transaction block reservations */
+	unsigned int			link_resblks;
+	unsigned int			unlink_resblks;
+
+	/* Parent pointer updates */
+	struct xfs_parent_args		link_ppargs;
+	struct xfs_parent_args		unlink_ppargs;
+
+	/* Scratchpads for removing links */
+	struct xfs_da_args		pptr_args;
 };
 
 /* Release resources tracked in the buffer. */
@@ -172,3 +190,332 @@ xchk_metapath(
 	xchk_trans_cancel(sc);
 	return error;
 }
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+/* Create the dirent represented by the final component of the path. */
+STATIC int
+xrep_metapath_link(
+	struct xchk_metapath	*mpath)
+{
+	struct xfs_scrub	*sc = mpath->sc;
+
+	mpath->du.dp = mpath->dp;
+	mpath->du.name = &mpath->xname;
+	mpath->du.ip = sc->ip;
+
+	if (xfs_has_parent(sc->mp))
+		mpath->du.ppargs = &mpath->link_ppargs;
+	else
+		mpath->du.ppargs = NULL;
+
+	trace_xrep_metapath_link(sc, mpath->path, mpath->dp, sc->ip->i_ino);
+
+	return xfs_dir_add_child(sc->tp, mpath->link_resblks, &mpath->du);
+}
+
+/* Remove the dirent at the final component of the path. */
+STATIC int
+xrep_metapath_unlink(
+	struct xchk_metapath	*mpath,
+	xfs_ino_t		ino,
+	struct xfs_inode	*ip)
+{
+	struct xfs_parent_rec	rec;
+	struct xfs_scrub	*sc = mpath->sc;
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
+
+	trace_xrep_metapath_unlink(sc, mpath->path, mpath->dp, ino);
+
+	if (!ip) {
+		/* The child inode isn't allocated.  Junk the dirent. */
+		xfs_trans_log_inode(sc->tp, mpath->dp, XFS_ILOG_CORE);
+		return xfs_dir_removename(sc->tp, mpath->dp, &mpath->xname,
+				ino, mpath->unlink_resblks);
+	}
+
+	mpath->du.dp = mpath->dp;
+	mpath->du.name = &mpath->xname;
+	mpath->du.ip = ip;
+	mpath->du.ppargs = NULL;
+
+	/* Figure out if we're removing a parent pointer too. */
+	if (xfs_has_parent(mp)) {
+		xfs_inode_to_parent_rec(&rec, ip);
+		error = xfs_parent_lookup(sc->tp, ip, &mpath->xname, &rec,
+				&mpath->pptr_args);
+		switch (error) {
+		case -ENOATTR:
+			break;
+		case 0:
+			mpath->du.ppargs = &mpath->unlink_ppargs;
+			break;
+		default:
+			return error;
+		}
+	}
+
+	return xfs_dir_remove_child(sc->tp, mpath->unlink_resblks, &mpath->du);
+}
+
+/*
+ * Try to create a dirent in @mpath->dp with the name @mpath->xname that points
+ * to @sc->ip.  Returns:
+ *
+ * -EEXIST and an @alleged_child if the dirent that points to the wrong inode;
+ * 0 if there is now a dirent pointing to @sc->ip; or
+ * A negative errno on error.
+ */
+STATIC int
+xrep_metapath_try_link(
+	struct xchk_metapath	*mpath,
+	xfs_ino_t		*alleged_child)
+{
+	struct xfs_scrub	*sc = mpath->sc;
+	xfs_ino_t		ino;
+	int			error;
+
+	/* Allocate transaction, lock inodes, join to transaction. */
+	error = xchk_trans_alloc(sc, mpath->link_resblks);
+	if (error)
+		return error;
+
+	error = xchk_metapath_ilock_both(mpath);
+	if (error) {
+		xchk_trans_cancel(sc);
+		return error;
+	}
+	xfs_trans_ijoin(sc->tp, mpath->dp, 0);
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	error = xchk_dir_lookup(sc, mpath->dp, &mpath->xname, &ino);
+	trace_xrep_metapath_lookup(sc, mpath->path, mpath->dp, ino);
+	if (error == -ENOENT) {
+		/*
+		 * There is no dirent in the directory.  Create an entry
+		 * pointing to @sc->ip.
+		 */
+		error = xrep_metapath_link(mpath);
+		if (error)
+			goto out_cancel;
+
+		error = xrep_trans_commit(sc);
+		xchk_metapath_iunlock(mpath);
+		return error;
+	}
+	if (error)
+		goto out_cancel;
+
+	if (ino == sc->ip->i_ino) {
+		/* The dirent already points to @sc->ip; we're done. */
+		error = 0;
+		goto out_cancel;
+	}
+
+	/*
+	 * The dirent points elsewhere; pass that back so that the caller
+	 * can try to remove the dirent.
+	 */
+	*alleged_child = ino;
+	error = -EEXIST;
+
+out_cancel:
+	xchk_trans_cancel(sc);
+	xchk_metapath_iunlock(mpath);
+	return error;
+}
+
+/*
+ * Take the ILOCK on the metadata directory parent and a bad child, if one is
+ * supplied.  We do not know that the metadata directory is not corrupt, so we
+ * lock the parent and try to lock the child.  Returns 0 if successful, or
+ * -EINTR to abort the repair.  The lock state of @dp is not recorded in @mpath.
+ */
+STATIC int
+xchk_metapath_ilock_parent_and_child(
+	struct xchk_metapath	*mpath,
+	struct xfs_inode	*ip)
+{
+	struct xfs_scrub	*sc = mpath->sc;
+	int			error = 0;
+
+	while (true) {
+		xfs_ilock(mpath->dp, XFS_ILOCK_EXCL);
+		if (!ip || xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
+			return 0;
+		xfs_iunlock(mpath->dp, XFS_ILOCK_EXCL);
+
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		delay(1);
+	}
+
+	ASSERT(0);
+	return -EINTR;
+}
+
+/*
+ * Try to remove a dirent in @mpath->dp with the name @mpath->xname that points
+ * to @alleged_child.  Returns:
+ *
+ * 0 if there is no longer a dirent;
+ * -EEXIST if the dirent points to @sc->ip;
+ * -EAGAIN and an updated @alleged_child if the dirent points elsewhere; or
+ * A negative errno for any other error.
+ */
+STATIC int
+xrep_metapath_try_unlink(
+	struct xchk_metapath	*mpath,
+	xfs_ino_t		*alleged_child)
+{
+	struct xfs_scrub	*sc = mpath->sc;
+	struct xfs_inode	*ip = NULL;
+	xfs_ino_t		ino;
+	int			error;
+
+	ASSERT(*alleged_child != sc->ip->i_ino);
+
+	trace_xrep_metapath_try_unlink(sc, mpath->path, mpath->dp,
+			*alleged_child);
+
+	/*
+	 * Allocate transaction, grab the alleged child inode, lock inodes,
+	 * join to transaction.
+	 */
+	error = xchk_trans_alloc(sc, mpath->unlink_resblks);
+	if (error)
+		return error;
+
+	error = xchk_iget(sc, *alleged_child, &ip);
+	if (error == -EINVAL || error == -ENOENT) {
+		/* inode number is bogus, junk the dirent */
+		error = 0;
+	}
+	if (error) {
+		xchk_trans_cancel(sc);
+		return error;
+	}
+
+	error = xchk_metapath_ilock_parent_and_child(mpath, ip);
+	if (error) {
+		xchk_trans_cancel(sc);
+		return error;
+	}
+	xfs_trans_ijoin(sc->tp, mpath->dp, 0);
+	if (ip)
+		xfs_trans_ijoin(sc->tp, ip, 0);
+
+	error = xchk_dir_lookup(sc, mpath->dp, &mpath->xname, &ino);
+	trace_xrep_metapath_lookup(sc, mpath->path, mpath->dp, ino);
+	if (error == -ENOENT) {
+		/*
+		 * There is no dirent in the directory anymore.  We're ready to
+		 * try the link operation again.
+		 */
+		error = 0;
+		goto out_cancel;
+	}
+	if (error)
+		goto out_cancel;
+
+	if (ino == sc->ip->i_ino) {
+		/* The dirent already points to @sc->ip; we're done. */
+		error = -EEXIST;
+		goto out_cancel;
+	}
+
+	/*
+	 * The dirent does not point to the alleged child.  Update the caller
+	 * and signal that we want to be called again.
+	 */
+	if (ino != *alleged_child) {
+		*alleged_child = ino;
+		error = -EAGAIN;
+		goto out_cancel;
+	}
+
+	/* Remove the link to the child. */
+	error = xrep_metapath_unlink(mpath, ino, ip);
+	if (error)
+		goto out_cancel;
+
+	error = xrep_trans_commit(sc);
+	goto out_unlock;
+
+out_cancel:
+	xchk_trans_cancel(sc);
+out_unlock:
+	xfs_iunlock(mpath->dp, XFS_ILOCK_EXCL);
+	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xchk_irele(sc, ip);
+	}
+	return error;
+}
+
+/*
+ * Make sure the metadata directory path points to the child being examined.
+ *
+ * Repair needs to be able to create a directory structure, create its own
+ * transactions, and take ILOCKs.  This function /must/ be called after all
+ * other repairs have completed.
+ */
+int
+xrep_metapath(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_metapath	*mpath = sc->buf;
+	struct xfs_mount	*mp = sc->mp;
+	int			error = 0;
+
+	/* Just probing, nothing to repair. */
+	if (sc->sm->sm_ino == XFS_SCRUB_METAPATH_PROBE)
+		return 0;
+
+	/* Parent required to do anything else. */
+	if (mpath->dp == NULL)
+		return -EFSCORRUPTED;
+
+	/*
+	 * Make sure the child file actually has an attr fork to receive a new
+	 * parent pointer if the fs has parent pointers.
+	 */
+	if (xfs_has_parent(mp)) {
+		error = xfs_attr_add_fork(sc->ip,
+				sizeof(struct xfs_attr_sf_hdr), 1);
+		if (error)
+			return error;
+	}
+
+	/* Compute block reservation required to unlink and link a file. */
+	mpath->unlink_resblks = xfs_remove_space_res(mp, MAXNAMELEN);
+	mpath->link_resblks = xfs_link_space_res(mp, MAXNAMELEN);
+
+	do {
+		xfs_ino_t	alleged_child;
+
+		/* Re-establish the link, or tell us which inode to remove. */
+		error = xrep_metapath_try_link(mpath, &alleged_child);
+		if (!error)
+			return 0;
+		if (error != -EEXIST)
+			return error;
+
+		/*
+		 * Remove an incorrect link to an alleged child, or tell us
+		 * which inode to remove.
+		 */
+		do {
+			error = xrep_metapath_try_unlink(mpath, &alleged_child);
+		} while (error == -EAGAIN);
+		if (error == -EEXIST) {
+			/* Link established; we're done. */
+			error = 0;
+			break;
+		}
+	} while (!error);
+
+	return error;
+}
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 0e0dc2bf985c2..90f9cb3b5ad8b 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -134,6 +134,7 @@ int xrep_directory(struct xfs_scrub *sc);
 int xrep_parent(struct xfs_scrub *sc);
 int xrep_symlink(struct xfs_scrub *sc);
 int xrep_dirtree(struct xfs_scrub *sc);
+int xrep_metapath(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -208,6 +209,7 @@ xrep_setup_nothing(
 #define xrep_setup_parent		xrep_setup_nothing
 #define xrep_setup_nlinks		xrep_setup_nothing
 #define xrep_setup_dirtree		xrep_setup_nothing
+#define xrep_setup_metapath		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
@@ -243,6 +245,7 @@ static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_parent			xrep_notsupported
 #define xrep_symlink			xrep_notsupported
 #define xrep_dirtree			xrep_notsupported
+#define xrep_metapath			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f1b2714e2894a..04a7a5944837d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -447,7 +447,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_metapath,
 		.scrub	= xchk_metapath,
 		.has	= xfs_has_metadir,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_metapath,
 	},
 };
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d4ca3f98679a2..fe901b9138b4b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3607,6 +3607,11 @@ DEFINE_XCHK_DIRTREE_EVENT(xrep_dirtree_delete_path);
 DEFINE_XCHK_DIRTREE_EVENT(xrep_dirtree_create_adoption);
 DEFINE_XCHK_DIRTREE_EVALUATE_EVENT(xrep_dirtree_decided_fate);
 
+DEFINE_XCHK_METAPATH_EVENT(xrep_metapath_lookup);
+DEFINE_XCHK_METAPATH_EVENT(xrep_metapath_try_unlink);
+DEFINE_XCHK_METAPATH_EVENT(xrep_metapath_unlink);
+DEFINE_XCHK_METAPATH_EVENT(xrep_metapath_link);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

