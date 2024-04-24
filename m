Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642B185C46
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929170; cv=none; b=itEnyRrW422pTKA6zb93McDCric2y7iXiRV9G+3l5Sa7wF+XbkLJyErdkWgdopPSn4xjmRZcOs+6XUZ+ML2BZbLHNzHiiiRH7pv3MA/6AeGW8oRnAnjtyRxrs1g0BvPzbiTSLLSWtR5ijfxXSebDCtoifvQC1DjoGUKV0BoXz/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929170; c=relaxed/simple;
	bh=5T5IUB+nfLe8ErMs2n2kI9tnS9abRI9NQ2e5eI7EqLc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kwjxmzm+MsZNh43LdeUoG1whxuhbZD64ELSTvAyHc0JFJhoWiJq2FEbcXWTaFehytZ8FhldvbGYlWqYxo2b1CmmeKjEjyaipeudv+DK//tC97+RVwQT9KnOnM9CYOuoAx0l361Dt0FUBWgvIwYhkYxZNtJgswm9Mp8Thi34Ad5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NATEurSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NATEurSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA872C116B1;
	Wed, 24 Apr 2024 03:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929170;
	bh=5T5IUB+nfLe8ErMs2n2kI9tnS9abRI9NQ2e5eI7EqLc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NATEurSbhh4XBStBS1iNjKmRsaUp/+0gHrzv5tJQ1MCqk8pvnOYknvci92wzrXct0
	 7bz0uH+bm+RUxQASWIud4nrOm4U8bpZkXBY/UQ0dkwb0r0GxOPozMBGX1JITROW3m/
	 aMR4vBrh3B5bSKa6QzIK7S0ZHIOYGz/JGahghdSLzjPBCF5jRwl3nB3VpyiRF5EhmF
	 IoqA3nb6qIH266es4TlJRaDnH4ClkOQa//Kgq2EExxvgbkHm84x0S0cvm2/zsgR5Kz
	 fDiMCnvzWhQrag5+XegSxaB0/0Wjc1FNSu4K9M7RSmb72WAcAZvg7hGLtlcFAtITlz
	 /y5vFhUS1BFsw==
Date: Tue, 23 Apr 2024 20:26:09 -0700
Subject: [PATCH 15/16] xfs: repair link count of nondirectories after
 rebuilding parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784907.1906420.7569932751648364489.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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

Since the parent pointer scrubber does not exhaustively search the
filesystem for missing parent pointers, it doesn't have a good way to
determine that there are pointers missing from an otherwise uncorrupt
xattr structure.  Instead, for nondirectories it employs a heuristic of
comparing the file link count to the number of parent pointers found.

However, we don't want this heuristic flagging a false corruption after
a repair has actually scanned the entire filesystem to rebuild the
parent pointers.  Therefore, reset the file link count in this one case
because we actually know the correct link count.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/parent_repair.c |  107 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 28e9746c0663..ee88ce5a12b8 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -27,6 +27,7 @@
 #include "xfs_parent.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
+#include "xfs_ag.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -156,6 +157,9 @@ struct xrep_parent {
 
 	/* Have we seen any live updates of parent pointers recently? */
 	bool			saw_pptr_updates;
+
+	/* Number of parents we found after all other repairs */
+	unsigned long long	parents;
 };
 
 struct xrep_parent_xattr {
@@ -1370,6 +1374,102 @@ xrep_parent_rebuild_tree(
 	return 0;
 }
 
+/* Count the number of parent pointers. */
+STATIC int
+xrep_parent_count_pptr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct xrep_parent	*rp = priv;
+	int			error;
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	error = xfs_parent_from_attr(sc->mp, attr_flags, name, namelen, value,
+			valuelen, NULL, NULL);
+	if (error)
+		return error;
+
+	rp->parents++;
+	return 0;
+}
+
+/*
+ * After all parent pointer rebuilding and adoption activity completes, reset
+ * the link count of this nondirectory, having scanned the fs to rebuild all
+ * parent pointers.
+ */
+STATIC int
+xrep_parent_set_nondir_nlink(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	struct xfs_inode	*ip = sc->ip;
+	struct xfs_perag	*pag;
+	bool			joined = false;
+	int			error;
+
+	/* Count parent pointers so we can reset the file link count. */
+	rp->parents = 0;
+	error = xchk_xattr_walk(sc, ip, xrep_parent_count_pptr, NULL, rp);
+	if (error)
+		return error;
+
+	if (rp->parents > 0 && xfs_inode_on_unlinked_list(ip)) {
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		joined = true;
+
+		/*
+		 * The file is on the unlinked list but we found parents.
+		 * Remove the file from the unlinked list.
+		 */
+		pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, ip->i_ino));
+		if (!pag) {
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+
+		error = xfs_iunlink_remove(sc->tp, pag, ip);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+	} else if (rp->parents == 0 && !xfs_inode_on_unlinked_list(ip)) {
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		joined = true;
+
+		/*
+		 * The file is not on the unlinked list but we found no
+		 * parents.  Add the file to the unlinked list.
+		 */
+		error = xfs_iunlink(sc->tp, ip);
+		if (error)
+			return error;
+	}
+
+	/* Set the correct link count. */
+	if (VFS_I(ip)->i_nlink != rp->parents) {
+		if (!joined) {
+			xfs_trans_ijoin(sc->tp, sc->ip, 0);
+			joined = true;
+		}
+
+		set_nlink(VFS_I(ip), min_t(unsigned long long, rp->parents,
+					   XFS_NLINK_PINNED));
+	}
+
+	/* Log the inode to keep it moving forward if we dirtied anything. */
+	if (joined)
+		xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
+
 /* Set up the filesystem scan so we can look for parents. */
 STATIC int
 xrep_parent_setup_scan(
@@ -1494,6 +1594,13 @@ xrep_parent(
 	error = xrep_parent_rebuild_tree(rp);
 	if (error)
 		goto out_teardown;
+	if (xfs_has_parent(sc->mp) && !S_ISDIR(VFS_I(sc->ip)->i_mode)) {
+		error = xrep_parent_set_nondir_nlink(rp);
+		if (error)
+			goto out_teardown;
+	}
+
+	error = xrep_defer_finish(sc);
 
 out_teardown:
 	xrep_parent_teardown(rp);

