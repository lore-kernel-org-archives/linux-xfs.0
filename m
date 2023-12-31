Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFA7BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMHbweIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B44C433C8;
	Sun, 31 Dec 2023 20:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054927;
	bh=VdZDDDq+tgGs7GYXCjxVC+0FT8uaAnEEc55RtoaQP88=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hMHbweINTMCIKHMFQqbZGubDHT6ZxCkpK+WDsLOHIxw+pRrsIyVNARxQJPrNZaqyu
	 xgM/ibawr46+mxwtP/2twU0gA2iijs1LjWS5szRbocyU+ABg9oG5fXt9FjUUo9dRvX
	 HInIiShNYO3hgM33CmO7AOJtbo8BQhghqDmZ+5r6HlcdqDRzDhBR3I6RdXo8Ym8WgV
	 R/wfnIAABaajMcozgAwbDw+98bPvg4UWmfQ4yhaEpllAFZooMaAsyFXIBn/iYvuml3
	 CNSs5s1hObLrETpgt47ekdBaAworrSGofKsoHLwwKpNTZUjm20LRYY6FVLZdMQ8EWO
	 oW6hQ8A88wkXw==
Date: Sun, 31 Dec 2023 12:35:27 -0800
Subject: [PATCH 2/6] xfs: use atomic extent swapping to fix user file fork
 data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404835245.1753315.12607896932356278287.stgit@frogsfrogsfrogs>
In-Reply-To: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
References: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
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

Build on the code that was recently added to the temporary repair file
code so that we can atomically switch the contents of any file fork,
even if the fork is in local format.  The upcoming functions to repair
xattrs, directories, and symlinks will need that capability.

Repair can lock out access to these user files by holding IOLOCK_EXCL on
these user files.  Therefore, it is safe to drop the ILOCK of both the
file being repaired and the tempfile being used for staging, and cancel
the scrub transaction.  We do this so that we can reuse the resource
estimation and transaction allocation functions used by a regular file
exchange operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_swapext.c |    2 
 fs/xfs/libxfs/xfs_swapext.h |    1 
 fs/xfs/scrub/tempfile.c     |  203 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h     |    3 +
 fs/xfs/scrub/tempswap.h     |    2 
 5 files changed, 210 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index 554da23a575eb..244ef3d8431fd 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -769,7 +769,7 @@ xfs_swapext_rmapbt_blocks(
 }
 
 /* Estimate the bmbt and rmapbt overhead required to exchange extents. */
-static int
+int
 xfs_swapext_estimate_overhead(
 	struct xfs_swapext_req	*req)
 {
diff --git a/fs/xfs/libxfs/xfs_swapext.h b/fs/xfs/libxfs/xfs_swapext.h
index 37842a4ee9a6d..a4768eddc9c8c 100644
--- a/fs/xfs/libxfs/xfs_swapext.h
+++ b/fs/xfs/libxfs/xfs_swapext.h
@@ -200,6 +200,7 @@ unsigned int xfs_swapext_reflink_prep(const struct xfs_swapext_req *req);
 void xfs_swapext_reflink_finish(struct xfs_trans *tp,
 		const struct xfs_swapext_req *req, unsigned int reflink_state);
 
+int xfs_swapext_estimate_overhead(struct xfs_swapext_req *req);
 int xfs_swapext_estimate(struct xfs_swapext_req *req);
 
 extern struct kmem_cache	*xfs_swapext_intent_cache;
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index a1736a3556a7d..f1726822e18f7 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -239,6 +239,28 @@ xrep_tempfile_iunlock(
 	sc->temp_ilock_flags &= ~XFS_ILOCK_EXCL;
 }
 
+/*
+ * Begin the process of making changes to both the file being scrubbed and
+ * the temporary file by taking ILOCK_EXCL on both.
+ */
+void
+xrep_tempfile_ilock_both(
+	struct xfs_scrub	*sc)
+{
+	xfs_lock_two_inodes(sc->ip, XFS_ILOCK_EXCL, sc->tempip, XFS_ILOCK_EXCL);
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	sc->temp_ilock_flags |= XFS_ILOCK_EXCL;
+}
+
+/* Unlock ILOCK_EXCL on both files. */
+void
+xrep_tempfile_iunlock_both(
+	struct xfs_scrub	*sc)
+{
+	xrep_tempfile_iunlock(sc);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+}
+
 /* Release the temporary file. */
 void
 xrep_tempfile_rele(
@@ -526,6 +548,88 @@ xrep_tempswap_prep_request(
 	return 0;
 }
 
+/*
+ * Fill out the swapext resource estimation structures in preparation for
+ * swapping the contents of a metadata file that we've rebuilt in the temp
+ * file.  Caller must hold IOLOCK_EXCL but not ILOCK_EXCL on both files.
+ */
+STATIC int
+xrep_tempswap_estimate(
+	struct xfs_scrub	*sc,
+	struct xrep_tempswap	*tx)
+{
+	struct xfs_swapext_req	*req = &tx->req;
+	struct xfs_ifork	*ifp;
+	struct xfs_ifork	*tifp;
+	int			state = 0;
+
+	/*
+	 * Deal with either fork being in local format.  The swapext code only
+	 * knows how to exchange block mappings for regular files, so we only
+	 * have to know about local format for xattrs and directories.
+	 */
+	ifp = xfs_ifork_ptr(sc->ip, req->whichfork);
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL)
+		state |= 1;
+
+	tifp = xfs_ifork_ptr(sc->tempip, req->whichfork);
+	if (tifp->if_format == XFS_DINODE_FMT_LOCAL)
+		state |= 2;
+
+	switch (state) {
+	case 0:
+		/* Both files have mapped extents; use the regular estimate. */
+		return xfs_xchg_range_estimate(req);
+	case 1:
+		/*
+		 * The file being repaired is in local format, but the temp
+		 * file has mapped extents.  To perform the swap, the file
+		 * being repaired must have its shorform data converted to a
+		 * fsblock, and the fork changed to extents format.  We need
+		 * one resblk for the conversion; the number of exchanges is
+		 * (worst case) the temporary file's extent count plus the
+		 * block we converted.
+		 */
+		req->ip1_bcount = sc->tempip->i_nblocks;
+		req->ip2_bcount = 1;
+		req->nr_exchanges = 1 + tifp->if_nextents;
+		req->resblks = 1;
+		break;
+	case 2:
+		/*
+		 * The temporary file is in local format, but the file being
+		 * repaired has mapped extents.  To perform the swap, the temp
+		 * file must have its shortform data converted to an fsblock,
+		 * and the fork changed to extents format.  We need one resblk
+		 * for the conversion; the number of exchanges is (worst case)
+		 * the extent count of the file being repaired plus the block
+		 * we converted.
+		 */
+		req->ip1_bcount = 1;
+		req->ip2_bcount = sc->ip->i_nblocks;
+		req->nr_exchanges = 1 + ifp->if_nextents;
+		req->resblks = 1;
+		break;
+	case 3:
+		/*
+		 * Both forks are in local format.  To perform the swap, both
+		 * files must have their shortform data converted to fsblocks,
+		 * and both forks must be converted to extents format.  We
+		 * need two resblks for the two conversions, and the number of
+		 * exchanges is 1 since there's only one block at fileoff 0.
+		 * Presumably, the caller could not exchange the two inode fork
+		 * areas directly.
+		 */
+		req->ip1_bcount = 1;
+		req->ip2_bcount = 1;
+		req->nr_exchanges = 1;
+		req->resblks = 2;
+		break;
+	}
+
+	return xfs_swapext_estimate_overhead(req);
+}
+
 /*
  * Obtain a quota reservation to make sure we don't hit EDQUOT.  We can skip
  * this if quota enforcement is disabled or if both inodes' dquots are the
@@ -616,6 +720,55 @@ xrep_tempswap_trans_reserve(
 	return xrep_tempswap_reserve_quota(sc, tx);
 }
 
+/*
+ * Create a new transaction for a swap.
+ *
+ * This function fills out the swapext request and resource estimation
+ * structures in preparation for swapping the contents of a metadata file that
+ * has been rebuilt in the temp file.  Next, it reserves space, takes
+ * ILOCK_EXCL of both inodes, joins them to the transaction and reserves quota
+ * for the transaction.
+ *
+ * The caller is responsible for dropping both ILOCKs when appropriate.
+ */
+int
+xrep_tempswap_trans_alloc(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	struct xrep_tempswap	*tx)
+{
+	unsigned int		flags = 0;
+	int			error;
+
+	ASSERT(sc->tp == NULL);
+
+	error = xrep_tempswap_prep_request(sc, whichfork, tx);
+	if (error)
+		return error;
+
+	error = xrep_tempswap_estimate(sc, tx);
+	if (error)
+		return error;
+
+	if (xfs_has_lazysbcount(sc->mp))
+		flags |= XFS_TRANS_RES_FDBLKS;
+
+	error = xrep_tempswap_grab_log_assist(sc);
+	if (error)
+		return error;
+
+	error = xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
+			tx->req.resblks, 0, flags, &sc->tp);
+	if (error)
+		return error;
+
+	sc->temp_ilock_flags |= XFS_ILOCK_EXCL;
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	xfs_xchg_range_ilock(sc->tp, sc->ip, sc->tempip);
+
+	return xrep_tempswap_reserve_quota(sc, tx);
+}
+
 /*
  * Swap forks between the file being repaired and the temporary file.  Returns
  * with both inodes locked and joined to a clean scrub transaction.
@@ -650,3 +803,53 @@ xrep_tempswap_contents(
 
 	return 0;
 }
+
+/*
+ * Write local format data from one of the temporary file's forks into the same
+ * fork of file being repaired, and swap the file sizes, if appropriate.
+ * Caller must ensure that the file being repaired has enough fork space to
+ * hold all the bytes.
+ */
+void
+xrep_tempfile_copyout_local(
+	struct xfs_scrub	*sc,
+	int			whichfork)
+{
+	struct xfs_ifork	*temp_ifp;
+	struct xfs_ifork	*ifp;
+	unsigned int		ilog_flags = XFS_ILOG_CORE;
+
+	temp_ifp = xfs_ifork_ptr(sc->tempip, whichfork);
+	ifp = xfs_ifork_ptr(sc->ip, whichfork);
+
+	ASSERT(temp_ifp != NULL);
+	ASSERT(ifp != NULL);
+	ASSERT(temp_ifp->if_format == XFS_DINODE_FMT_LOCAL);
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		ASSERT(sc->tempip->i_disk_size <=
+					xfs_inode_data_fork_size(sc->ip));
+		break;
+	case XFS_ATTR_FORK:
+		ASSERT(sc->tempip->i_forkoff >= sc->ip->i_forkoff);
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
+
+	/* Recreate @sc->ip's incore fork (ifp) with data from temp_ifp. */
+	xfs_idestroy_fork(ifp);
+	xfs_init_local_fork(sc->ip, whichfork, temp_ifp->if_u1.if_data,
+			temp_ifp->if_bytes);
+
+	if (whichfork == XFS_DATA_FORK) {
+		i_size_write(VFS_I(sc->ip), i_size_read(VFS_I(sc->tempip)));
+		sc->ip->i_disk_size = sc->tempip->i_disk_size;
+	}
+
+	ilog_flags |= xfs_ilog_fdata(whichfork);
+	xfs_trans_log_inode(sc->tp, sc->ip, ilog_flags);
+}
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
index 7980f9c4de552..d57e4f145a7c8 100644
--- a/fs/xfs/scrub/tempfile.h
+++ b/fs/xfs/scrub/tempfile.h
@@ -17,6 +17,8 @@ void xrep_tempfile_iounlock(struct xfs_scrub *sc);
 void xrep_tempfile_ilock(struct xfs_scrub *sc);
 bool xrep_tempfile_ilock_nowait(struct xfs_scrub *sc);
 void xrep_tempfile_iunlock(struct xfs_scrub *sc);
+void xrep_tempfile_iunlock_both(struct xfs_scrub *sc);
+void xrep_tempfile_ilock_both(struct xfs_scrub *sc);
 
 int xrep_tempfile_prealloc(struct xfs_scrub *sc, xfs_fileoff_t off,
 		xfs_filblks_t len);
@@ -32,6 +34,7 @@ int xrep_tempfile_copyin(struct xfs_scrub *sc, xfs_fileoff_t off,
 int xrep_tempfile_set_isize(struct xfs_scrub *sc, unsigned long long isize);
 
 int xrep_tempfile_roll_trans(struct xfs_scrub *sc);
+void xrep_tempfile_copyout_local(struct xfs_scrub *sc, int whichfork);
 #else
 static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
 {
diff --git a/fs/xfs/scrub/tempswap.h b/fs/xfs/scrub/tempswap.h
index e8f8a6e3c8861..83900eef8cfc5 100644
--- a/fs/xfs/scrub/tempswap.h
+++ b/fs/xfs/scrub/tempswap.h
@@ -14,6 +14,8 @@ struct xrep_tempswap {
 int xrep_tempswap_grab_log_assist(struct xfs_scrub *sc);
 int xrep_tempswap_trans_reserve(struct xfs_scrub *sc, int whichfork,
 		struct xrep_tempswap *ti);
+int xrep_tempswap_trans_alloc(struct xfs_scrub *sc, int whichfork,
+		struct xrep_tempswap *ti);
 
 int xrep_tempswap_contents(struct xfs_scrub *sc, struct xrep_tempswap *ti);
 #endif /* CONFIG_XFS_ONLINE_REPAIR */

