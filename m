Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD5F7ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGSbGnXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7521C433C7;
	Mon,  1 Jan 2024 00:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068503;
	bh=8mUtgVsfp1PxqCBHnrkvD6iz8V8FRjbPc8BqophbShU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oGSbGnXP6Y3Lzzbj2GGilEX/vSIaWkWWbkBmnIh8LgkGT/Sse8JHvwaHHhMG6Md1U
	 jT+6wCW1T22v25vkhqJdxXDu3T1dyK5USyK9vYeaB6e2ioOxfTDPKtjBGYj2Y7hE/S
	 85VPZtgeIZyeaH8EL1nNDHEjJAoDUtfiLWGRodvBScJU6xBkuTDnIsOUGgzTr/8Gri
	 k8A33G6WQfYdVm2/kz0QrIlVBctzmZRf5/tzSAk6BEdnI7zW+Rumn1kPSLU2l7g+hk
	 zbYFKgdnZV06n/I6nV5bf6E9Z/i/rf+mKzzv3/GAgkL1OChMP01a9XDIv/104AEsvY
	 yLGVpJND4NyAw==
Date: Sun, 31 Dec 2023 16:21:43 +9900
Subject: [PATCH 43/47] xfs_repair: rebuild the bmap btree for realtime files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015886.1815505.15186385222227343688.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Use the realtime rmap btree information to rebuild an inode's data fork
when appropriate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/bmap_repair.c |  131 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 127 insertions(+), 4 deletions(-)


diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index dfd1405cca2..5d4da861322 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -212,6 +212,122 @@ xrep_bmap_scan_ag(
 	return error;
 }
 
+/* Check for any obvious errors or conflicts in the file mapping. */
+STATIC int
+xrep_bmap_check_rtfork_rmap(
+	struct repair_ctx		*sc,
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec)
+{
+	/* xattr extents are never stored on realtime devices */
+	if (rec->rm_flags & XFS_RMAP_ATTR_FORK)
+		return EFSCORRUPTED;
+
+	/* bmbt blocks are never stored on realtime devices */
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK)
+		return EFSCORRUPTED;
+
+	/* Data extents for non-rt files are never stored on the rt device. */
+	if (!XFS_IS_REALTIME_INODE(sc->ip))
+		return EFSCORRUPTED;
+
+	/* Check the file offsets and physical extents. */
+	if (!xfs_verify_fileext(sc->mp, rec->rm_offset, rec->rm_blockcount))
+		return EFSCORRUPTED;
+
+	/* Check that this fits in the rt volume. */
+	if (!xfs_verify_rgbext(cur->bc_ino.rtg, rec->rm_startblock,
+				rec->rm_blockcount))
+		return EFSCORRUPTED;
+
+	return 0;
+}
+
+/* Record realtime extents that belong to this inode's fork. */
+STATIC int
+xrep_bmap_walk_rtrmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_bmap		*rb = priv;
+	int				error = 0;
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != rb->sc->ip->i_ino)
+		return 0;
+
+	error = xrep_bmap_check_rtfork_rmap(rb->sc, cur, rec);
+	if (error)
+		return error;
+
+	/*
+	 * Record all blocks allocated to this file even if the extent isn't
+	 * for the fork we're rebuilding so that we can reset di_nblocks later.
+	 */
+	rb->nblocks += rec->rm_blockcount;
+
+	/* If this rmap isn't for the fork we want, we're done. */
+	if (rb->whichfork == XFS_DATA_FORK &&
+	    (rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+	if (rb->whichfork == XFS_ATTR_FORK &&
+	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+
+	return xrep_bmap_from_rmap(rb, rec->rm_offset, rec->rm_startblock,
+			rec->rm_blockcount,
+			rec->rm_flags & XFS_RMAP_UNWRITTEN);
+}
+
+/*
+ * Scan the realtime reverse mappings to build the new extent map.  The rt rmap
+ * inodes must be loaded from disk explicitly here, since we have not yet
+ * validated the metadata directory tree but do not wish to throw away user
+ * data unnecessarily.
+ */
+STATIC int
+xrep_bmap_scan_rt(
+	struct xrep_bmap	*rb,
+	struct xfs_rtgroup	*rtg)
+{
+	struct repair_ctx	*sc = rb->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_btree_cur	*cur;
+	struct xfs_inode	*ip;
+	struct xfs_imeta_path	*path;
+	xfs_ino_t		ino;
+	int			error;
+
+	error = -libxfs_rtrmapbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		return error;
+
+	error = -libxfs_imeta_lookup(sc->tp, path, &ino);
+	if (error)
+		goto out_path;
+
+	if (ino == NULLFSINO) {
+		error = EFSCORRUPTED;
+		goto out_path;
+	}
+
+	error = -libxfs_imeta_iget(sc->tp, ino, XFS_DIR3_FT_REG_FILE, &ip);
+	if (error)
+		goto out_path;
+
+	cur = libxfs_rtrmapbt_init_cursor(mp, sc->tp, rtg, ip);
+	error = -libxfs_rmap_query_all(cur, xrep_bmap_walk_rtrmap, rb);
+	if (error)
+		goto out_cur;
+out_cur:
+	libxfs_btree_del_cursor(cur, error);
+	libxfs_imeta_irele(ip);
+out_path:
+	libxfs_imeta_free_path(path);
+	return error;
+}
+
 /*
  * Collect block mappings for this fork of this inode and decide if we have
  * enough space to rebuild.  Caller is responsible for cleaning up the list if
@@ -222,9 +338,20 @@ xrep_bmap_find_mappings(
 	struct xrep_bmap	*rb)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	int			error;
 
+	/* Iterate the rtrmaps for extents. */
+	for_each_rtgroup(rb->sc->mp, rgno, rtg) {
+		error = xrep_bmap_scan_rt(rb, rtg);
+		if (error) {
+			libxfs_rtgroup_put(rtg);
+			return error;
+		}
+	}
+
 	/* Iterate the rmaps for extents. */
 	for_each_perag(rb->sc->mp, agno, pag) {
 		error = xrep_bmap_scan_ag(rb, pag);
@@ -572,10 +699,6 @@ xrep_bmap_check_inputs(
 		return EINVAL;
 	}
 
-	/* Don't know how to rebuild realtime data forks. */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
-		return EOPNOTSUPP;
-
 	return 0;
 }
 

