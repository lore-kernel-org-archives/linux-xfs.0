Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D293621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711225; cv=none; b=s6XLPxP7yeL6j9BI5DEIAYINndSa38XLoa9GPyBKZXF5gU5cJA6aT++FOifGHO7WkFb4Lf6fJjZm188H2wm3w+LMVNUEnPwMOWA/BgarN1YcrsVRC0nyjWCbfAZC4nrCP+gFSdvXQAXOjLiiMPYek6Y0mhiOJWON2LpGeX4C+t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711225; c=relaxed/simple;
	bh=QAMUWuQswMloOkBUEe9GsM+cL8ea9k/ZhEpQUw3MSKs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FfAMU7daBUttEifNyOJjsQuQ3Xbe+i77fJ9CWv51ipz3N/GNtVK2SdxQpWFl4eWy3IRBKW/dCaTlrGP2hbtEPReImMkudeqPSqGvcvWoC/Ms1UCnKbuHldrNWexeqTCXc0s5PpGjUrzdqvyGHVBK+fjWdSudLoJ8QCAqTf7khIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohO9l5KY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohO9l5KY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DE6C433C7;
	Wed, 10 Apr 2024 01:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711225;
	bh=QAMUWuQswMloOkBUEe9GsM+cL8ea9k/ZhEpQUw3MSKs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ohO9l5KYWy1r3pef5Uw5PIFqnDpb3ZiMmEkz86KfFqfuwuKc4wHOx5GXXJlLu1v+B
	 m+c5zF1S4wgRP0sDoBn9nviaBorhYsqixR7mu8MtzyTcUqsDw5YRfA+jqh8BHkeOl2
	 7dPKFVNqqG4rcjBxarNoSBBHkXcI+wYkXT1hxylQlLzJigqv3dT7cZQykeT6qbKGQ6
	 3/CG3UXO09khod3qrIwRsUeSYTsmTOZZisTdCG2bwVmqpeHesCPckUPLwZGF0oEVtO
	 n+lPpR+hHUS7HsBi0BA+RFxlvjiGTL7sPMqBy2//o5SdVtzS6YO2unNrq4z5IPyNU/
	 yKmg3IWa8Jj+A==
Date: Tue, 09 Apr 2024 18:07:04 -0700
Subject: [PATCH 13/14] xfs: repair link count of nondirectories after
 rebuilding parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270971204.3632937.13387414768621786629.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/parent_repair.c |  104 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 02554c99d231f..d9ab5b85deb2d 100644
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
@@ -1367,6 +1371,99 @@ xrep_parent_rebuild_tree(
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
+	int			ret;
+
+	ret = xfs_parent_from_xattr(sc->mp, attr_flags, name, namelen,
+			value, valuelen, NULL, NULL);
+	if (ret != 1)
+		return ret;
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
@@ -1491,6 +1588,13 @@ xrep_parent(
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

