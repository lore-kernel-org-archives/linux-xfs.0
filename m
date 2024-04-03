Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F206917997
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 05:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712120587; cv=none; b=Wr24j1p5eWi1hqvc8YZiq+Kb145lKWQGNtV/29NdVJhYm+yjwHLTc6Kgulb8zhKNes5VlOcl3Z7NkpACauxpX/x6N5DSaH5321e1QALTB3ytucIsRzObsBoiMxP8d745rJpxSzGTPbnApPHCykN6v3rK2P1DJsz5iOBvY4uNUCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712120587; c=relaxed/simple;
	bh=uIoS3fIX8sx1iNTHzBH+UfwLQ4QrQcZfnG+jyaTy8lY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHujhbxT4N+7BJJD0E84dFoK7Ep7xnf7BkHrpeHbCTvpTC1MuAn5J1ulOXBJU8LTDc/x1NRLtq+eTFdUrGm2BG9EeyGHHYAhH8/T/uT7qQ04Eq5LWNy5XI7e6ORLQX47SXrDvgpRUbdAaaJMbUf3BWFZ4W29f35YrwarTdD4pno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pw6qseUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pw6qseUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1B3C433F1;
	Wed,  3 Apr 2024 05:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712120586;
	bh=uIoS3fIX8sx1iNTHzBH+UfwLQ4QrQcZfnG+jyaTy8lY=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=pw6qseUS5A3Tjjh18bNc08e5cfR9i+UITs6pTUa47eHkX1UyLbH0uycRzXlitNHIo
	 9RpG3ngwSO+E54lUxX/DFUFPxUtRLDuMj4F4fL+69Fyp8yJ0Hh1pDNZI1qPdqhfGmQ
	 UHuabas/BEAGJHnIvvldH/O8B8ndpOmpHXp1KPTKPDerdP+ps8A10esQ7MHWG04fVL
	 ybt6Wjr9ozLKmdGyrrvWKrBXSu3SOt4mRhtvm6M+ouvpfvT/6FoNNsQqY6XVF/ywLp
	 vLdRF383NvgYrQlHvoYUOli8pSlRLFIcA3TJRlLY0ASUlOzCuQ+/s+FvHdUSWZogKp
	 XNnLVoTvSUwfw==
Date: Tue, 2 Apr 2024 22:03:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, linux-xfs@vger.kernel.org
Subject: [PATCH v30.2 5/5] xfs: ask the dentry cache if it knows the parent
 of a directory
Message-ID: <20240403050305.GS6390@frogsfrogsfrogs>
References: <171150383515.3217994.11426825010369201405.stgit@frogsfrogsfrogs>
 <171150383612.3217994.12957852450843135792.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150383612.3217994.12957852450843135792.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

It's possible that the dentry cache can tell us the parent of a
directory.  Therefore, when repairing directory dot dot entries, query
the dcache as a last resort before scanning the entire filesystem.

A reviewer asks:

"How high is the chance that we actually have a valid dcache entry for a
file in a corrupted directory?"

There's a decent chance of this actually working.  Say you have a
1000-block directory foo, and block 980 gets corrupted.  Let's further
suppose that block 0 has a correct entry for ".." and "bar".  If someone
accesses /mnt/foo/bar, that will cause the dcache to create a dentry
from /mnt to /mnt/foo whose d_parent points back to /mnt.  If you then
want to rebuild the directory, XFS can obtain the parent from the dcache
without needing to wander into parent pointers or scan the filesystem to
find /mnt's connection to foo.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c    |   29 +++++++++++++++++++++++++++++
 fs/xfs/scrub/findparent.c    |   38 +++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/findparent.h    |    1 +
 fs/xfs/scrub/parent_repair.c |   13 +++++++++++++
 fs/xfs/scrub/trace.h         |    1 +
 5 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index b17de79207dba..34fe720fde0eb 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -208,6 +208,29 @@ xrep_dir_lookup_parent(
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
@@ -221,6 +244,12 @@ xrep_dir_find_parent(
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
index 7b3ec8d7d6cc9..712dd73e4789f 100644
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
@@ -410,3 +411,38 @@ xrep_findparent_self_reference(
 
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
+	ASSERT(parent->d_sb == sc->ip->i_mount->m_super);
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
index 78097803e8ec8..6c9e8084132fc 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2613,6 +2613,7 @@ DEFINE_EVENT(xrep_parent_salvage_class, name, \
 	TP_ARGS(dp, ino))
 DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_dir_salvaged_parent);
 DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_findparent_dirent);
+DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_findparent_from_dcache);
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
