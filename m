Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3919157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225168; cv=none; b=gfMueSvhuWIFwzi+BQA3HRKOen8USs1cRzQCJzRX1z3tOjNpOyzA4HBUZ0U8rbgTXLxDz+HRQqfNBe+CZ/zG+RxggHAWrzbLtvoKoggifhbLcUcOumPPCD7Ak2aossAzAW5bc6WEFCLCeJEFvvZkbh+pGj+T8oIXgFM4U0x23v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225168; c=relaxed/simple;
	bh=BG0FuaVEiTqKafL3OHG3003WfTdRQJ3inJps/lzGU9o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WrR5MZG6RKVaQHOPCwl3sCv4hRiSfBr3fme6XcIUJjzJvvMviw6JXxsTtp7jn5/qvTdqJ8whrEmHCBMPU+whB/u/zc1+Jg8H0RT6GAlyh54s2+8D6Gq6d2zrMVd6/+mQAQQtkR+dTULj0H7HD9+l1ICcGgyC0OqsUZO2OkmyjTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rr1vKnnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rr1vKnnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CE8C113CC;
	Mon, 15 Apr 2024 23:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225167;
	bh=BG0FuaVEiTqKafL3OHG3003WfTdRQJ3inJps/lzGU9o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rr1vKnnM9CzkF4gazwypaHSHHi+7leHBuMOh44W093R/5wZAM/E6bkbAGdS8naICz
	 2iYpK5SwofHg6FS1C8DJZf5kBBbFZf8JpQnj505jq4+Oa77ke/mFX4piO7agaSLP69
	 iwu2jzjtxvlu8Tb2JCyDe/pqe+oBtKLq5f3lWmgZUQnYQf8GrlbhiYiWJe7d3E5kfW
	 AZSr9mkVLBArBfWpNMSCxmnFyqOM2MKWanlgwfEWSxkQemUq+kE53XTNQs/ShI5nWk
	 eNS88T0TImaSGeFDde7BmaYtHLmwvIIVqSDlKLPyjoIJOlhauF+Z5cgALIQDuOx0Ku
	 N7bDF1nHVAKtA==
Date: Mon, 15 Apr 2024 16:52:47 -0700
Subject: [PATCH 5/5] xfs: ask the dentry cache if it knows the parent of a
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383956.89193.16384128565851779175.stgit@frogsfrogsfrogs>
In-Reply-To: <171322383857.89193.15436066970892287907.stgit@frogsfrogsfrogs>
References: <171322383857.89193.15436066970892287907.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir_repair.c    |   29 +++++++++++++++++++++++++++++
 fs/xfs/scrub/findparent.c    |   38 +++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/findparent.h    |    1 +
 fs/xfs/scrub/parent_repair.c |   13 +++++++++++++
 fs/xfs/scrub/trace.h         |    1 +
 5 files changed, 81 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index b17de79207db..34fe720fde0e 100644
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
index 7b3ec8d7d6cc..712dd73e4789 100644
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
index d946bc81f34e..501f99d3164e 100644
--- a/fs/xfs/scrub/findparent.h
+++ b/fs/xfs/scrub/findparent.h
@@ -45,5 +45,6 @@ void xrep_findparent_scan_finish_early(struct xrep_parent_scan_info *pscan,
 int xrep_findparent_confirm(struct xfs_scrub *sc, xfs_ino_t *parent_ino);
 
 xfs_ino_t xrep_findparent_self_reference(struct xfs_scrub *sc);
+xfs_ino_t xrep_findparent_from_dcache(struct xfs_scrub *sc);
 
 #endif /* __XFS_SCRUB_FINDPARENT_H__ */
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 0a9651bb0b05..826926c2bb0d 100644
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
index e1755fe63e67..d68ec8e2781e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2613,6 +2613,7 @@ DEFINE_EVENT(xrep_parent_salvage_class, name, \
 	TP_ARGS(dp, ino))
 DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_dir_salvaged_parent);
 DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_findparent_dirent);
+DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_findparent_from_dcache);
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 

