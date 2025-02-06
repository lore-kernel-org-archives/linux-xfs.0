Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D232417C2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882544; cv=none; b=uTKTyPm3Lfb09zsutzmalzhyONBFGhl8jGOqrfhQUw4uDeoSZmLTIeSrzKxO4DYZCuLSFneZLeTexphDlmTml83r6ZsFwxDYecAS0OlB7iu9X27iNcDDOeMIKWlDP8QyKQQ52hYKkDf/UcuxRGn84H7pceKXCV3LCFZ0QynYEbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882544; c=relaxed/simple;
	bh=d/2NK6Ngfr/vCc7VVdpTnnSK+BFmPYQWGUEIJakjkL4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vC94emfvdpv1l5tL2nGBWeRXmtisIEzBpK/aOD7nDZOioQkwHDbVUVKIcjyKpm0ypLa9N2t+zK93bqIQTVQcMvXr+K4n6mAOwVHfVDRW1NmDn/32Ht2cXm6auHSi1IpQxsMSn2jR983JhS8dVz2cdpLnZWxFneDVYLS8KIPKbi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PIiXcWsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PIiXcWsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B332C4CEDD;
	Thu,  6 Feb 2025 22:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882544;
	bh=d/2NK6Ngfr/vCc7VVdpTnnSK+BFmPYQWGUEIJakjkL4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PIiXcWsGRHilSw60NmWl4WDQUvLXdOA/n3IPhfqSpMvVsx/36j9L6RgrEZYqmk6nt
	 78fCkv+lyz2S06aY/2KScCYKd6KEJRTr8YM8ufJtJVIaRsKIO41tic1u209FwwNsI1
	 TAw6FIWlnACHt13yrGuQ7hh6XmID4J2U6QKwYd2hsCJnyo5bTn+8yVvOPQFgG9pmxg
	 tAR9P25bfRFozYPXQ5rABgBgm/lmO2gFMdyG0W+A/JSY6EAFKQBDtZosbszHaxk87b
	 W/AwGT4Un7LXDQsdaHxHWr5YU44+tXK3eXbYs9QelubT2YO3yah9GmOvzMwsq6gmTW
	 jZ9wRPoePFMBg==
Date: Thu, 06 Feb 2025 14:55:43 -0800
Subject: [PATCH 23/27] xfs_repair: rebuild the bmap btree for realtime files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088448.2741033.9119599638346403244.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/bmap_repair.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 105 insertions(+), 4 deletions(-)


diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 7e7c2a39f5724b..5d1f639be81ff4 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -209,6 +209,101 @@ xrep_bmap_scan_ag(
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
+	if (!xfs_verify_rgbext(to_rtg(cur->bc_group), rec->rm_startblock,
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
+	struct xfs_inode	*ip = rtg_rmap(rtg);
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	/* failed to load the rtdir inode? */
+	if (!xfs_has_rtrmapbt(mp) || !ip)
+		return ENOENT;
+
+	cur = libxfs_rtrmapbt_init_cursor(sc->tp, rtg);
+	error = -libxfs_rmap_query_all(cur, xrep_bmap_walk_rtrmap, rb);
+	libxfs_btree_del_cursor(cur, error);
+	return error;
+}
+
 /*
  * Collect block mappings for this fork of this inode and decide if we have
  * enough space to rebuild.  Caller is responsible for cleaning up the list if
@@ -219,8 +314,18 @@ xrep_bmap_find_mappings(
 	struct xrep_bmap	*rb)
 {
 	struct xfs_perag	*pag = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
 	int			error;
 
+	/* Iterate the rtrmaps for extents. */
+	while ((rtg = xfs_rtgroup_next(rb->sc->mp, rtg))) {
+		error = xrep_bmap_scan_rt(rb, rtg);
+		if (error) {
+			libxfs_rtgroup_put(rtg);
+			return error;
+		}
+	}
+
 	/* Iterate the rmaps for extents. */
 	while ((pag = xfs_perag_next(rb->sc->mp, pag))) {
 		error = xrep_bmap_scan_ag(rb, pag);
@@ -570,10 +675,6 @@ xrep_bmap_check_inputs(
 		return EINVAL;
 	}
 
-	/* Don't know how to rebuild realtime data forks. */
-	if (XFS_IS_REALTIME_INODE(sc->ip))
-		return EOPNOTSUPP;
-
 	return 0;
 }
 

