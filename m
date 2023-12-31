Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C810C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCjiAw18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDAFC433C8;
	Sun, 31 Dec 2023 22:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061780;
	bh=K11lKVQysg2s7uYmLtAbjoHbqUzpeJ2FAuE0YomIMo4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kCjiAw18iBVO50I+IgwS45PzG1I+D1Dwz1JIPFwBgq9IXKiqoFzQmweEOORY/uApK
	 NFpXEF9fQeni4q0Zl1tBm8lFWuXoJ+2ZibeDeD7DOyVRNpw2Xf25UbUjQgc6wDOm5e
	 el96ASBXcM0cfNTcPs7DUw+zrKyrr9C3FVaRhsTGEITO1w1GVHyC57/YqMHhoGNDLe
	 W4Xuxk95QvejDX0p1If2FTnkKtGmuFqlwoiibKS89ufySNc7xZt57Heyy24zgNb6T4
	 it2xgNF4tXZeaNIuigi3AprA0evBcGGJL965XZ5twvMZtawxdNZGYVYnuiku2MZxSs
	 4V+x9lZtiIuJw==
Date: Sun, 31 Dec 2023 14:29:39 -0800
Subject: [PATCH 10/20] xfs: condense symbolic links after an atomic swap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996408.1796128.13108294692843196899.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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

The previous commit added a new swapext flag that enables us to perform
post-swap processing on file2 once we're done swapping the extent maps.
Now add this ability for symlinks.

This isn't used anywhere right now, but we need to have the basic ondisk
flags in place so that a future online symlink repair feature can
salvage the remote target in a temporary link and swap the data forks
when ready.  If one file is in extents format and the other is inline,
we will have to promote both to extents format to perform the swap.
After the swap, we can try to condense the fixed symlink down to inline
format if possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_swapext.c        |   48 ++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_symlink_remote.c |   47 ++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_symlink_remote.h |    1 +
 3 files changed, 95 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index c5d404cfa56..364ae16252d 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -28,6 +28,7 @@
 #include "xfs_attr.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_dir2.h"
+#include "xfs_symlink_remote.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -431,6 +432,48 @@ xfs_swapext_dir_to_sf(
 	return xfs_dir2_block_to_sf(&args, bp, size, &sfh);
 }
 
+/* Convert inode2's remote symlink target back to shortform, if possible. */
+STATIC int
+xfs_swapext_link_to_sf(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	struct xfs_inode		*ip = sxi->sxi_ip2;
+	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	char				*buf;
+	int				error;
+
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL ||
+	    ip->i_disk_size > xfs_inode_data_fork_size(ip))
+		return 0;
+
+	/* Read the current symlink target into a buffer. */
+	buf = kmem_alloc(ip->i_disk_size + 1, KM_NOFS);
+	if (!buf) {
+		ASSERT(0);
+		return -ENOMEM;
+	}
+
+	error = xfs_symlink_remote_read(ip, buf);
+	if (error)
+		goto free;
+
+	/* Remove the blocks. */
+	error = xfs_symlink_remote_truncate(tp, ip);
+	if (error)
+		goto free;
+
+	/* Convert fork to local format and log our changes. */
+	xfs_idestroy_fork(ifp);
+	ifp->if_bytes = 0;
+	ifp->if_format = XFS_DINODE_FMT_LOCAL;
+	xfs_init_local_fork(ip, XFS_DATA_FORK, buf, ip->i_disk_size);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
+free:
+	kmem_free(buf);
+	return error;
+}
+
 static inline void
 xfs_swapext_clear_reflink(
 	struct xfs_trans	*tp,
@@ -455,6 +498,8 @@ xfs_swapext_do_postop_work(
 			error = xfs_swapext_attr_to_sf(tp, sxi);
 		else if (S_ISDIR(VFS_I(sxi->sxi_ip2)->i_mode))
 			error = xfs_swapext_dir_to_sf(tp, sxi);
+		else if (S_ISLNK(VFS_I(sxi->sxi_ip2)->i_mode))
+			error = xfs_swapext_link_to_sf(tp, sxi);
 		sxi->sxi_flags &= ~XFS_SWAP_EXT_CVT_INO2_SF;
 		if (error)
 			return error;
@@ -1111,7 +1156,8 @@ xfs_swapext(
 	if (req->req_flags & XFS_SWAP_REQ_CVT_INO2_SF)
 		ASSERT(req->whichfork == XFS_ATTR_FORK ||
 		       (req->whichfork == XFS_DATA_FORK &&
-			S_ISDIR(VFS_I(req->ip2)->i_mode)));
+			(S_ISDIR(VFS_I(req->ip2)->i_mode) ||
+			 S_ISLNK(VFS_I(req->ip2)->i_mode))));
 
 	if (req->blockcount == 0)
 		return;
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 2f3aca8d02b..a4a242bc3d4 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -377,3 +377,50 @@ xfs_symlink_write_target(
 	ASSERT(pathlen == 0);
 	return 0;
 }
+
+/* Remove all the blocks from a symlink and invalidate buffers. */
+int
+xfs_symlink_remote_truncate(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*bp;
+	int			nmaps = XFS_SYMLINK_MAPS;
+	int			done = 0;
+	int			i;
+	int			error;
+
+	/* Read mappings and invalidate buffers. */
+	error = xfs_bmapi_read(ip, 0, XFS_MAX_FILEOFF, mval, &nmaps, 0);
+	if (error)
+		return error;
+
+	for (i = 0; i < nmaps; i++) {
+		if (!xfs_bmap_is_real_extent(&mval[i]))
+			break;
+
+		error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, mval[i].br_startblock),
+				XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0,
+				&bp);
+		if (error)
+			return error;
+
+		xfs_trans_binval(tp, bp);
+	}
+
+	/* Unmap the remote blocks. */
+	error = xfs_bunmapi(tp, ip, 0, XFS_MAX_FILEOFF, 0, nmaps, &done);
+	if (error)
+		return error;
+	if (!done) {
+		ASSERT(done);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
+		return -EFSCORRUPTED;
+	}
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
diff --git a/libxfs/xfs_symlink_remote.h b/libxfs/xfs_symlink_remote.h
index a63bd38ae4f..ac3dac8f617 100644
--- a/libxfs/xfs_symlink_remote.h
+++ b/libxfs/xfs_symlink_remote.h
@@ -22,5 +22,6 @@ int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
 		const char *target_path, int pathlen, xfs_fsblock_t fs_blocks,
 		uint resblks);
+int xfs_symlink_remote_truncate(struct xfs_trans *tp, struct xfs_inode *ip);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */

