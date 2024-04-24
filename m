Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A8F947E
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928873; cv=none; b=TBDapDma59ynfLRkU5qi3Wl/j22V/PYzxnKLcOFoZ66nVldTs3BI9a2tJ6gTmWY71XiEU4U3sNO7aNTbhS0DsOR5DNoRtRRsHQN6CNPdcCF2wqjTAQRyn0iduza1o3p10ZkndDySDISDE4J/KWY/9yX7Gxx6XotlSKh3YmnX5hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928873; c=relaxed/simple;
	bh=daW+2yHw3mSr9N5FlE+oZRY3VNNeZZyeUVWNKgbQ+Zs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HOy+OMmzShkv3+3zhoZyW+KAKnJBiZGyE3NqDDHmRKSwBtlYOspeipy9Js9XOfp7i5zX4KnF2j3J+iXt1UTQN92j8/vNfF1/mYb8+MhZpT6V+q2bALN5ibtVodTvZ4sig1TVIcsXn6y2X6dS7baZKjChUSlXf1xxCVrcYZ5RMmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olVcVule; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olVcVule"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF3FC116B1;
	Wed, 24 Apr 2024 03:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928872;
	bh=daW+2yHw3mSr9N5FlE+oZRY3VNNeZZyeUVWNKgbQ+Zs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=olVcVuleoP1SDpkotH82at+KzQNmCXZq32Icr2Ll3Zwlhg8kjJeJVwipR6azcit1w
	 sx9znDvwaA3eH7Bdut4Tt60ptdZOC150apgw622bwwhc4vQYEqbGqwZP7rP4gNW8Ch
	 mj1buD05qUNQg5AowNG8QSmEXD2/b2uSAsRc9z7LA7dfMpdZ71n2XAfjilye5JzBlG
	 zQBDZVkzjOQFuV7gklnO0TmjdR4uOR7YRw5LDUl3QGQJkiI39s8Be4ruVX+pjB+UKX
	 AUB7CD2ryjvHS36FlZWPZXRhU8k4DStDtRCYha/xHGxq0w+nvj/iW7kHh2f8UBpBID
	 LfjXkaXjGjlng==
Date: Tue, 23 Apr 2024 20:21:11 -0700
Subject: [PATCH 3/7] xfs: deferred scrub of dirents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784187.1906133.8582345966991530386.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784119.1906133.5675060874223948555.stgit@frogsfrogsfrogs>
References: <171392784119.1906133.5675060874223948555.stgit@frogsfrogsfrogs>
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

If the trylock-based parent pointer check fails, retain those dirents
and check them at the end.  This may involve dropping the locks on the
file being scanned, so yay.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir.c     |  234 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/readdir.c |   78 ++++++++++++++++
 fs/xfs/scrub/readdir.h |    3 +
 fs/xfs/scrub/trace.h   |   34 +++++++
 4 files changed, 346 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index e11d73eb8935..62474d0557c4 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -24,6 +24,10 @@
 #include "scrub/readdir.h"
 #include "scrub/health.h"
 #include "scrub/repair.h"
+#include "scrub/trace.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
 
 /* Set us up to scrub directories. */
 int
@@ -43,12 +47,37 @@ xchk_setup_directory(
 
 /* Directories */
 
+/* Deferred directory entry that we saved for later. */
+struct xchk_dirent {
+	/* Cookie for retrieval of the dirent name. */
+	xfblob_cookie		name_cookie;
+
+	/* Child inode number. */
+	xfs_ino_t		ino;
+
+	/* Length of the pptr name. */
+	uint8_t			namelen;
+};
+
 struct xchk_dir {
 	struct xfs_scrub	*sc;
 
 	/* information for parent pointer validation. */
 	struct xfs_parent_rec	pptr_rec;
 	struct xfs_da_args	pptr_args;
+
+	/* Fixed-size array of xchk_dirent structures. */
+	struct xfarray		*dir_entries;
+
+	/* Blobs containing dirent names. */
+	struct xfblob		*dir_names;
+
+	/* If we've cycled the ILOCK, we must revalidate deferred dirents. */
+	bool			need_revalidate;
+
+	/* Name buffer for dirent revalidation. */
+	struct xfs_name		xname;
+	uint8_t			namebuf[MAXNAMELEN];
 };
 
 /* Scrub a directory entry. */
@@ -148,8 +177,26 @@ xchk_dir_check_pptr_fast(
 	/* Try to lock the inode. */
 	lockmode = xchk_dir_lock_child(sc, ip);
 	if (!lockmode) {
-		xchk_set_incomplete(sc);
-		return -ECANCELED;
+		struct xchk_dirent	save_de = {
+			.namelen	= name->len,
+			.ino		= ip->i_ino,
+		};
+
+		/* Couldn't lock the inode, so save the dirent for later. */
+		trace_xchk_dir_defer(sc->ip, name, ip->i_ino);
+
+		error = xfblob_storename(sd->dir_names, &save_de.name_cookie,
+				name);
+		if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+					&error))
+			return error;
+
+		error = xfarray_append(sd->dir_entries, &save_de);
+		if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+					&error))
+			return error;
+
+		return 0;
 	}
 
 	error = xchk_dir_parent_pointer(sd, name, ip);
@@ -865,6 +912,142 @@ xchk_directory_blocks(
 	return error;
 }
 
+/*
+ * Revalidate a dirent that we collected in the past but couldn't check because
+ * of lock contention.  Returns 0 if the dirent is still valid, -ENOENT if it
+ * has gone away on us, or a negative errno.
+ */
+STATIC int
+xchk_dir_revalidate_dirent(
+	struct xchk_dir		*sd,
+	const struct xfs_name	*xname,
+	xfs_ino_t		ino)
+{
+	struct xfs_scrub	*sc = sd->sc;
+	xfs_ino_t		child_ino;
+	int			error;
+
+	/*
+	 * Look up the directory entry.  If we get -ENOENT, the directory entry
+	 * went away and there's nothing to revalidate.  Return any other
+	 * error.
+	 */
+	error = xchk_dir_lookup(sc, sc->ip, xname, &child_ino);
+	if (error)
+		return error;
+
+	/* The inode number changed, nothing to revalidate. */
+	if (ino != child_ino)
+		return -ENOENT;
+
+	return 0;
+}
+
+/*
+ * Check a directory entry's parent pointers the slow way, which means we cycle
+ * locks a bunch and put up with revalidation until we get it done.
+ */
+STATIC int
+xchk_dir_slow_dirent(
+	struct xchk_dir		*sd,
+	struct xchk_dirent	*dirent,
+	const struct xfs_name	*xname)
+{
+	struct xfs_scrub	*sc = sd->sc;
+	struct xfs_inode	*ip;
+	unsigned int		lockmode;
+	int			error;
+
+	/* Check that the deferred dirent still exists. */
+	if (sd->need_revalidate) {
+		error = xchk_dir_revalidate_dirent(sd, xname, dirent->ino);
+		if (error == -ENOENT)
+			return 0;
+		if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+					&error))
+			return error;
+	}
+
+	error = xchk_iget(sc, dirent->ino, &ip);
+	if (error == -EINVAL || error == -ENOENT) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
+		return error;
+
+	/*
+	 * If we can grab both IOLOCK and ILOCK of the alleged child, we can
+	 * proceed with the validation.
+	 */
+	lockmode = xchk_dir_lock_child(sc, ip);
+	if (lockmode) {
+		trace_xchk_dir_slowpath(sc->ip, xname, ip->i_ino);
+		goto check_pptr;
+	}
+
+	/*
+	 * We couldn't lock the child file.  Drop all the locks and try to
+	 * get them again, one at a time.
+	 */
+	xchk_iunlock(sc, sc->ilock_flags);
+	sd->need_revalidate = true;
+
+	trace_xchk_dir_ultraslowpath(sc->ip, xname, ip->i_ino);
+
+	error = xchk_dir_trylock_for_pptrs(sc, ip, &lockmode);
+	if (error)
+		goto out_rele;
+
+	/* Revalidate, since we just cycled the locks. */
+	error = xchk_dir_revalidate_dirent(sd, xname, dirent->ino);
+	if (error == -ENOENT) {
+		error = 0;
+		goto out_unlock;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
+		goto out_unlock;
+
+check_pptr:
+	error = xchk_dir_parent_pointer(sd, xname, ip);
+out_unlock:
+	xfs_iunlock(ip, lockmode);
+out_rele:
+	xchk_irele(sc, ip);
+	return error;
+}
+
+/* Check all the dirents that we deferred the first time around. */
+STATIC int
+xchk_dir_finish_slow_dirents(
+	struct xchk_dir		*sd)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	foreach_xfarray_idx(sd->dir_entries, array_cur) {
+		struct xchk_dirent	dirent;
+
+		if (sd->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			return 0;
+
+		error = xfarray_load(sd->dir_entries, array_cur, &dirent);
+		if (error)
+			return error;
+
+		error = xfblob_loadname(sd->dir_names, dirent.name_cookie,
+				&sd->xname, dirent.namelen);
+		if (error)
+			return error;
+
+		error = xchk_dir_slow_dirent(sd, &dirent, &sd->xname);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
 /* Scrub a whole directory. */
 int
 xchk_directory(
@@ -907,11 +1090,56 @@ xchk_directory(
 	if (!sd)
 		return -ENOMEM;
 	sd->sc = sc;
+	sd->xname.name = sd->namebuf;
+
+	if (xfs_has_parent(sc->mp)) {
+		char		*descr;
+
+		/*
+		 * Set up some staging memory for dirents that we can't check
+		 * due to locking contention.
+		 */
+		descr = xchk_xfile_ino_descr(sc, "slow directory entries");
+		error = xfarray_create(descr, 0, sizeof(struct xchk_dirent),
+				&sd->dir_entries);
+		kfree(descr);
+		if (error)
+			goto out_sd;
+
+		descr = xchk_xfile_ino_descr(sc, "slow directory entry names");
+		error = xfblob_create(descr, &sd->dir_names);
+		kfree(descr);
+		if (error)
+			goto out_entries;
+	}
 
 	/* Look up every name in this directory by hash. */
 	error = xchk_dir_walk(sc, sc->ip, xchk_dir_actor, sd);
+	if (error == -ECANCELED)
+		error = 0;
+	if (error)
+		goto out_names;
+
+	if (xfs_has_parent(sc->mp)) {
+		error = xchk_dir_finish_slow_dirents(sd);
+		if (error == -ETIMEDOUT) {
+			/* Couldn't grab a lock, scrub was marked incomplete */
+			error = 0;
+			goto out_names;
+		}
+		if (error)
+			goto out_names;
+	}
+
+out_names:
+	if (sd->dir_names)
+		xfblob_destroy(sd->dir_names);
+out_entries:
+	if (sd->dir_entries)
+		xfarray_destroy(sd->dir_entries);
+out_sd:
 	kvfree(sd);
-	if (error && error != -ECANCELED)
+	if (error)
 		return error;
 
 	/* If the dir is clean, it is clearly not zapped. */
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index 028690761c62..28a94c78b0b1 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_error.h"
 #include "scrub/scrub.h"
+#include "scrub/common.h"
 #include "scrub/readdir.h"
 
 /* Call a function for every entry in a shortform directory. */
@@ -380,3 +381,80 @@ xchk_dir_lookup(
 		*ino = args.inumber;
 	return error;
 }
+
+/*
+ * Try to grab the IOLOCK and ILOCK of sc->ip and ip, returning @ip's lock
+ * state.  The caller may have a transaction, so we must use trylock for both
+ * IOLOCKs.
+ */
+static inline unsigned int
+xchk_dir_trylock_both(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip)
+{
+	if (!xchk_ilock_nowait(sc, XFS_IOLOCK_EXCL))
+		return 0;
+
+	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
+		goto parent_iolock;
+
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
+		goto parent_ilock;
+
+	return XFS_IOLOCK_SHARED | XFS_ILOCK_EXCL;
+
+parent_ilock:
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+parent_iolock:
+	xchk_iunlock(sc, XFS_IOLOCK_EXCL);
+	return 0;
+}
+
+/*
+ * Try for a limited time to grab the IOLOCK and ILOCK of both the scrub target
+ * (@sc->ip) and the inode at the other end (@ip) of a directory or parent
+ * pointer link so that we can check that link.
+ *
+ * We do not know ahead of time that the directory tree is /not/ corrupt, so we
+ * cannot use the "lock two inode" functions because we do not know that there
+ * is not a racing thread trying to take the locks in opposite order.  First
+ * take IOLOCK_EXCL of the scrub target, and then try to take IOLOCK_SHARED
+ * of @ip to synchronize with the VFS.  Next, take ILOCK_EXCL of the scrub
+ * target and @ip to synchronize with XFS.
+ *
+ * If the trylocks succeed, *lockmode will be set to the locks held for @ip;
+ * @sc->ilock_flags will be set for the locks held for @sc->ip; and zero will
+ * be returned.  If not, returns -EDEADLOCK to try again; or -ETIMEDOUT if
+ * XCHK_TRY_HARDER was set.  Returns -EINTR if the process has been killed.
+ */
+int
+xchk_dir_trylock_for_pptrs(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		*lockmode)
+{
+	unsigned int		nr;
+	int			error = 0;
+
+	ASSERT(sc->ilock_flags == 0);
+
+	for (nr = 0; nr < HZ; nr++) {
+		*lockmode = xchk_dir_trylock_both(sc, ip);
+		if (*lockmode)
+			return 0;
+
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		delay(1);
+	}
+
+	if (sc->flags & XCHK_TRY_HARDER) {
+		xchk_set_incomplete(sc);
+		return -ETIMEDOUT;
+	}
+
+	return -EDEADLOCK;
+}
diff --git a/fs/xfs/scrub/readdir.h b/fs/xfs/scrub/readdir.h
index 55787f4df123..da501877a64d 100644
--- a/fs/xfs/scrub/readdir.h
+++ b/fs/xfs/scrub/readdir.h
@@ -16,4 +16,7 @@ int xchk_dir_walk(struct xfs_scrub *sc, struct xfs_inode *dp,
 int xchk_dir_lookup(struct xfs_scrub *sc, struct xfs_inode *dp,
 		const struct xfs_name *name, xfs_ino_t *ino);
 
+int xchk_dir_trylock_for_pptrs(struct xfs_scrub *sc, struct xfs_inode *ip,
+		unsigned int *lockmode);
+
 #endif /* __XFS_SCRUB_READDIR_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 814db1d1747a..4db762480b8d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1511,6 +1511,40 @@ DEFINE_EVENT(xchk_nlinks_diff_class, name, \
 	TP_ARGS(mp, ip, live))
 DEFINE_SCRUB_NLINKS_DIFF_EVENT(xchk_nlinks_compare_inode);
 
+DECLARE_EVENT_CLASS(xchk_pptr_class,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_name *name,
+		 xfs_ino_t far_ino),
+	TP_ARGS(ip, name, far_ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, name->len)
+		__field(xfs_ino_t, far_ino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->namelen = name->len;
+		memcpy(__get_str(name), name, name->len);
+		__entry->far_ino = far_ino;
+	),
+	TP_printk("dev %d:%d ino 0x%llx name '%.*s' far_ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->namelen,
+		  __get_str(name),
+		  __entry->far_ino)
+)
+#define DEFINE_XCHK_PPTR_EVENT(name) \
+DEFINE_EVENT(xchk_pptr_class, name, \
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_name *name, \
+		 xfs_ino_t far_ino), \
+	TP_ARGS(ip, name, far_ino))
+DEFINE_XCHK_PPTR_EVENT(xchk_dir_defer);
+DEFINE_XCHK_PPTR_EVENT(xchk_dir_slowpath);
+DEFINE_XCHK_PPTR_EVENT(xchk_dir_ultraslowpath);
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 

