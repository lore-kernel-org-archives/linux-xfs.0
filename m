Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005C159B64
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798825; cv=none; b=VyoqqzenpWWNNb6ZCLRo/OfHKaDFcLEwoO4rZeZq+84YjxCjG2eNWwijlsdQWZj5btjGpEkL2kJhheflOEm5EbXUPV3pE/23Z+kwFEWjEsj63bp6X3clgduq06r6MLawjw1Adfr9896nHM3QOyKSYZ2KUg67Y9RA6RfY61ZXVkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798825; c=relaxed/simple;
	bh=ZtQeD5c4U6ujrbp1bEvXP8BWv3vu5/sK01OJ/2cj8Yc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BtQCDTbCKoPPzQ9ZspwekEkAfYWxjExKPPBl9lXfkFl3WWlpWe6OxMsStXvnNnFZp/GxnI5wlA1dCgygQQBCJLeCMool7ZEyCc0G7Pd1SDK09Wdg8cna9AQrtKK22e1Ys0M9JN4r1NFmUA8hG9FQ1XDDwldf8FHt8SVQApEGpcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J10du6QY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J10du6QY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CCFC433C7;
	Mon, 18 Mar 2024 21:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798824;
	bh=ZtQeD5c4U6ujrbp1bEvXP8BWv3vu5/sK01OJ/2cj8Yc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J10du6QYgarst173kmX+/X0vBgy/6U+DnXNaaO79QatGNz0xexL+YrKS5w3NM8tez
	 X03RDQbjk3eC09aTrNMt0TINGAS/L3du+nZPmy6C3pZEfIlNx6E1RLNqPGQUzswQhv
	 z2M0n62pWxF00Spxh8gta5FJ8Mf/aW3K3gkSHxHtZ6D0eXMpJziyV5lrtnTj/HReeK
	 fxiwS9fDBqIo/wZ6Nx1Ky8AfEBEpl0384lyCL51jjP3NM3Cc5r5zZUgs1LZv6CTy8O
	 RaVHyY8DSlDyLUSGTLwlBztSbMcbEKQSqR2bQH599wWoYGzZvVYpMtnVL2xSR4M05v
	 aB7CpBC5GHhlg==
Date: Mon, 18 Mar 2024 14:53:44 -0700
Subject: [PATCH 22/23] xfs: repair link count of nondirectories after
 rebuilding parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079803053.3808642.16071447218004632493.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/parent_repair.c |   97 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 116d3383cc2c1..1fd3736abcb84 100644
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
@@ -160,6 +161,9 @@ struct xrep_parent {
 	 * lost+found filename if we need to reparent the file.
 	 */
 	struct xfs_parent_name_irec pptr;
+
+	/* Number of parents we found after all other repairs */
+	unsigned long long	parents;
 };
 
 struct xrep_parent_xattr {
@@ -1382,6 +1386,92 @@ xrep_parent_rebuild_tree(
 	return 0;
 }
 
+/* Count the number of parent pointers. */
+STATIC int
+xrep_parent_count_pptr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	const struct xfs_parent_name_irec *pptr,
+	void			*priv)
+{
+	struct xrep_parent	*rp = priv;
+
+	if (!xfs_parent_verify_irec(sc->mp, pptr))
+		return -EFSCORRUPTED;
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
+	error = xchk_pptr_walk(sc, ip, xrep_parent_count_pptr, &rp->pptr, rp);
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
@@ -1506,6 +1596,13 @@ xrep_parent(
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

