Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9039C5227
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231607; cv=none; b=cpA5JPS4NqFd1apGgpITBVFeLsaXYbPBt3dJebpLNcn4UyTXT3xWHEeHVIwBhQAzPBeN15nRehHCpXq10rHAA57roxegkA2vxm9l3d5q0ZG/ierCax/C+k5zRQzSinDjzrvbX5fdAMlioQudy2/yGT1gtKpWv8YPTkX+kk3uv7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231607; c=relaxed/simple;
	bh=H9JBaeYSF53k+WFhJH2TaCJLr4+/GzTJbreljwkOfeM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IMCqWvWQtkyXFA8KF3qlX2mhb3D3+5MaKNnIIL1Go/ORyJ7S58WOS26OLa52suxiUdthUDEXIAyW6LSjrm15yFNDruMXSzT9MeASwpJrgtOuPdoAYR9lXczf7fSmhJhyMV8ANvWWVPNDxxFflokdhWzXZjhMddRXzAfmBcTu2nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxmJdGwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxmJdGwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674F2C113CC;
	Tue, 16 Apr 2024 01:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231607;
	bh=H9JBaeYSF53k+WFhJH2TaCJLr4+/GzTJbreljwkOfeM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KxmJdGwnU08o59BkGy8yoWXQMBLJ28Uq+wbuCUFHQYw9YGfKOD9WHu9za0AILCZF6
	 y5fzRIlY6MjMRrOWuCRrCpWrqZ2T5K5XpWxfa3+vaph0opHYAhJpVyiwNxPuTGv1i7
	 o2XlvkfWI+eXICMcpa/mSJe9ilThn/mlbsAD9pP/CBkogwHIeyFcNNx/YTqc+ZGxgD
	 YfgPsJ12IxJtBMWbPiPOV3pPhhxUkLBsI5XTfnYiks2BEkDAOCyNi+GVPOsFFgLjEU
	 B5C7W7Y+xxJHasaM8U5zq95Iyim0Z8yqE/Nkk2Y+6H/lk5n017MnMlN6JeFw+CjIvp
	 hsJImtm4SwklQ==
Date: Mon, 15 Apr 2024 18:40:06 -0700
Subject: [PATCH 16/17] xfs: repair link count of nondirectories after
 rebuilding parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323029443.253068.2993570753880366430.stgit@frogsfrogsfrogs>
In-Reply-To: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
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
index 28e9746c06631..ee88ce5a12b83 100644
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

