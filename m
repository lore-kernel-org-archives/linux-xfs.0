Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E051096F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709001109; cv=none; b=i1iy46/KX5jW2iKgISk4kDjEBF/bOPJl0ouGSNEU0s6n/iAmr7qt/Fbu7HRa0c6akFV2rD/q7CxCUwyt2AD6HNDatwEiTs+EJOE/rCgqXOg4LHNxxiTOW8qpUPSzcb+VHMpI7cKquqI8VYBJAgN7DT5jih9tIf9z+yZKGYYw0/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709001109; c=relaxed/simple;
	bh=eAF911LXSm7VfAqr9HkzD8YEHK1y37jgdU7VPO6bjss=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+YW4H5epppaGU9N0DjcMoRRSqAdBD/cS9Bcq3xzlV6XUFwHUTUGbYzRZEPO6ZO5WorrJWbkisumsAClbCP8Dp9K1v4RpZ5cdG6uCOwkhnthh/w8/LJGVcxJyku1JBiDoncswqzr7tPopRPe883IIbIbK5UkdDYZDuWGiDI9FTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQXspY76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQXspY76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0814BC433F1;
	Tue, 27 Feb 2024 02:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709001109;
	bh=eAF911LXSm7VfAqr9HkzD8YEHK1y37jgdU7VPO6bjss=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lQXspY765X6EK4hf9BPhR5+/fYkui14t5C4b1PJjOKytnekYp2zO9UehlKxeirDhX
	 wGgcB2W12pQMjt6nCBuxwhFh4mS9bOPhzU4LpN4W3yQJ9132t2yhXafQnuDS4JjcEd
	 PVyLc+037rK3ADH+suyYhl7Mbq9JMs/M4TM7jRENufy6QCeLDVgzUeccm4jTPUf5vw
	 AV/JoE0duFZx+IVvG0t1ZeQEyGes3UCp4E8O5kzL84hZIlRoxxfQIVR/VYbZwhYqaK
	 wL0LwMmmlX29p0T69FVODauAOLPasMy6Y4pDZSGi6wxZJ7aRQSgOSPd9u8ozMSUT5l
	 LTQh3r7ywQ7/w==
Date: Mon, 26 Feb 2024 18:31:48 -0800
Subject: [PATCH 4/4] xfs: ask the dentry cache if it knows the parent of a
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900014522.939516.4778985900477583664.stgit@frogsfrogsfrogs>
In-Reply-To: <170900014444.939516.15598694515763925938.stgit@frogsfrogsfrogs>
References: <170900014444.939516.15598694515763925938.stgit@frogsfrogsfrogs>
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

It's possible that the dentry cache can tell us the parent of a
directory.  Therefore, when repairing directory dot dot entries, query
the dcache as a last resort before scanning the entire filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c    |   29 +++++++++++++++++++++++++++++
 fs/xfs/scrub/findparent.c    |   41 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/findparent.h    |    1 +
 fs/xfs/scrub/parent_repair.c |   13 +++++++++++++
 fs/xfs/scrub/trace.h         |    1 +
 5 files changed, 84 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index e6979ed49408d..dba8745767eab 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -206,6 +206,29 @@ xrep_dir_lookup_parent(
 	return ino;
 }
 
+/*
+ * Look up '..' in the dentry cache and confirm that it's really the parent.
+ * Returns NULLFSINO if the dcache misses or if the hit is implausible.
+ */
+static inline xfs_ino_t
+xrep_dir_dcache_parent(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	xfs_ino_t		parent_ino;
+	int			error;
+
+	parent_ino = xrep_findparent_from_dcache(sc);
+	if (parent_ino == NULLFSINO)
+		return parent_ino;
+
+	error = xrep_findparent_confirm(sc, &parent_ino);
+	if (error)
+		return NULLFSINO;
+
+	return parent_ino;
+}
+
 /* Try to find the parent of the directory being repaired. */
 STATIC int
 xrep_dir_find_parent(
@@ -219,6 +242,12 @@ xrep_dir_find_parent(
 		return 0;
 	}
 
+	ino = xrep_dir_dcache_parent(rd);
+	if (ino != NULLFSINO) {
+		xrep_findparent_scan_finish_early(&rd->pscan, ino);
+		return 0;
+	}
+
 	ino = xrep_dir_lookup_parent(rd);
 	if (ino != NULLFSINO) {
 		xrep_findparent_scan_finish_early(&rd->pscan, ino);
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index 7b3ec8d7d6cc9..2606e180e41e4 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -53,7 +53,8 @@
  * must not read the scan results without re-taking @sc->ip's ILOCK.
  *
  * There are a few shortcuts that we can take to avoid scanning the entire
- * filesystem, such as noticing directory tree roots.
+ * filesystem, such as noticing directory tree roots and querying the dentry
+ * cache for parent information.
  */
 
 struct xrep_findparent_info {
@@ -410,3 +411,41 @@ xrep_findparent_self_reference(
 
 	return NULLFSINO;
 }
+
+/* Check the dentry cache to see if knows of a parent for the scrub target. */
+xfs_ino_t
+xrep_findparent_from_dcache(
+	struct xfs_scrub	*sc)
+{
+	struct inode		*pip = NULL;
+	struct dentry		*dentry, *parent;
+	xfs_ino_t		ret = NULLFSINO;
+
+	dentry = d_find_alias(VFS_I(sc->ip));
+	if (!dentry)
+		goto out;
+
+	parent = dget_parent(dentry);
+	if (!parent)
+		goto out_dput;
+
+	if (parent->d_sb != sc->ip->i_mount->m_super) {
+		dput(parent);
+		goto out_dput;
+	}
+
+	pip = igrab(d_inode(parent));
+	dput(parent);
+
+	if (S_ISDIR(pip->i_mode)) {
+		trace_xrep_findparent_from_dcache(sc->ip, XFS_I(pip)->i_ino);
+		ret = XFS_I(pip)->i_ino;
+	}
+
+	xchk_irele(sc, XFS_I(pip));
+
+out_dput:
+	dput(dentry);
+out:
+	return ret;
+}
diff --git a/fs/xfs/scrub/findparent.h b/fs/xfs/scrub/findparent.h
index d946bc81f34e6..501f99d3164ed 100644
--- a/fs/xfs/scrub/findparent.h
+++ b/fs/xfs/scrub/findparent.h
@@ -45,5 +45,6 @@ void xrep_findparent_scan_finish_early(struct xrep_parent_scan_info *pscan,
 int xrep_findparent_confirm(struct xfs_scrub *sc, xfs_ino_t *parent_ino);
 
 xfs_ino_t xrep_findparent_self_reference(struct xfs_scrub *sc);
+xfs_ino_t xrep_findparent_from_dcache(struct xfs_scrub *sc);
 
 #endif /* __XFS_SCRUB_FINDPARENT_H__ */
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 0a9651bb0b057..826926c2bb0dd 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -118,7 +118,20 @@ xrep_parent_find_dotdot(
 	 * then retake the ILOCK so that we can salvage directory entries.
 	 */
 	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/* Does the VFS dcache have an answer for us? */
+	ino = xrep_findparent_from_dcache(sc);
+	if (ino != NULLFSINO) {
+		error = xrep_findparent_confirm(sc, &ino);
+		if (!error && ino != NULLFSINO) {
+			xrep_findparent_scan_finish_early(&rp->pscan, ino);
+			goto out_relock;
+		}
+	}
+
+	/* Scan the entire filesystem for a parent. */
 	error = xrep_findparent_scan(&rp->pscan);
+out_relock:
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
 
 	return error;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index a7cefe6c252e9..883accdd53f04 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2607,6 +2607,7 @@ DEFINE_EVENT(xrep_parent_salvage_class, name, \
 	TP_ARGS(dp, ino))
 DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_dir_salvaged_parent);
 DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_findparent_dirent);
+DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_findparent_from_dcache);
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 

