Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021DD157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224996; cv=none; b=pUppjPGyHjeoFYMg2xp6TtfKzxn5Z4HMMTTh++n/U626S5FfIL3MVqfL4/8oizVsjliYlggEXtmY8XGFVs2n0g44OsmpzBLOafT1UFbnp+FHGkrJIeJYt7CNwrky31yU1tg/rRouWno0sxYSDonvpe2pMWgSYozNVMubfFb0Z5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224996; c=relaxed/simple;
	bh=0E+uidfNznwPbHV7Dc2VQletE+zFvPf8Mzlwe2Fsxv8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JISMN/+ZXm8lHwz+e6X+WeEMTNhz5TcYZPjmiGVdCqVJ7/qANkg19RSeC1M9wwdQ0RXEztriX9QgUzAdXuKWTRb4wuwA5ds+qse+zzL++uTZO3DH84QSb6cZqqgpsigY/bPoUHY+hyuV9vZM7vsPBuM9Yb7LHwIDApeeOnfxKK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMxU4yga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMxU4yga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25A1C113CC;
	Mon, 15 Apr 2024 23:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224995;
	bh=0E+uidfNznwPbHV7Dc2VQletE+zFvPf8Mzlwe2Fsxv8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YMxU4ygaHQVI1+f3AueYlSoQ/dBY/Buj0/I12aaFgzpYo6/qO0rmiIZgHAb4VW1Ub
	 PPdloeGNUbDIUjC0go7JLhCdbppno5gOIpx1P/mAEo1mi6o+c+BGVWYep+IUN/pZ7f
	 d+sJcGcSVoZB7fpN5ijngSwnj/4cjLKGuD6j689IX7ha91RYXdzZqM8G75EKnuHknJ
	 IR8DMUL2/hX6tQQ9+zpPJ4giqahLfdMav6cqrVJ+axBhw3Txs2cgokYUMtUA91WCI1
	 MkpF9DhwR8J1v7au0ixtB6WvG5imMNlv8dhF6k8GxEZNPqya/LQnLa8GkqaUtsSDsR
	 FPJtmb9Sa8Sig==
Date: Mon, 15 Apr 2024 16:49:55 -0700
Subject: [PATCH 3/7] xfs: use atomic extent swapping to fix user file fork
 data
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383130.88776.6212953029661225048.stgit@frogsfrogsfrogs>
In-Reply-To: <171322383061.88776.6099178844393502891.stgit@frogsfrogsfrogs>
References: <171322383061.88776.6099178844393502891.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_exchmaps.c |    2 
 fs/xfs/libxfs/xfs_exchmaps.h |    1 
 fs/xfs/scrub/tempexch.h      |    2 
 fs/xfs/scrub/tempfile.c      |  204 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h      |    3 +
 5 files changed, 211 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 3880ae32eecf..44ab6a9235c0 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -675,7 +675,7 @@ xfs_exchmaps_rmapbt_blocks(
 }
 
 /* Estimate the bmbt and rmapbt overhead required to exchange mappings. */
-static int
+int
 xfs_exchmaps_estimate_overhead(
 	struct xfs_exchmaps_req		*req)
 {
diff --git a/fs/xfs/libxfs/xfs_exchmaps.h b/fs/xfs/libxfs/xfs_exchmaps.h
index d8718fca606e..fa822dff202a 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.h
+++ b/fs/xfs/libxfs/xfs_exchmaps.h
@@ -97,6 +97,7 @@ xfs_exchmaps_reqfork(const struct xfs_exchmaps_req *req)
 	return XFS_DATA_FORK;
 }
 
+int xfs_exchmaps_estimate_overhead(struct xfs_exchmaps_req *req);
 int xfs_exchmaps_estimate(struct xfs_exchmaps_req *req);
 
 extern struct kmem_cache	*xfs_exchmaps_intent_cache;
diff --git a/fs/xfs/scrub/tempexch.h b/fs/xfs/scrub/tempexch.h
index 98222b684b6a..c1dd4adec4f1 100644
--- a/fs/xfs/scrub/tempexch.h
+++ b/fs/xfs/scrub/tempexch.h
@@ -14,6 +14,8 @@ struct xrep_tempexch {
 int xrep_tempexch_enable(struct xfs_scrub *sc);
 int xrep_tempexch_trans_reserve(struct xfs_scrub *sc, int whichfork,
 		struct xrep_tempexch *ti);
+int xrep_tempexch_trans_alloc(struct xfs_scrub *sc, int whichfork,
+		struct xrep_tempexch *ti);
 
 int xrep_tempexch_contents(struct xfs_scrub *sc, struct xrep_tempexch *ti);
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 7791336ca820..0b3060be938f 100644
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
@@ -514,6 +536,89 @@ xrep_tempexch_prep_request(
 	return 0;
 }
 
+/*
+ * Fill out the mapping exchange resource estimation structures in preparation
+ * for exchanging the contents of a metadata file that we've rebuilt in the
+ * temp file.  Caller must hold IOLOCK_EXCL but not ILOCK_EXCL on both files.
+ */
+STATIC int
+xrep_tempexch_estimate(
+	struct xfs_scrub	*sc,
+	struct xrep_tempexch	*tx)
+{
+	struct xfs_exchmaps_req	*req = &tx->req;
+	struct xfs_ifork	*ifp;
+	struct xfs_ifork	*tifp;
+	int			whichfork = xfs_exchmaps_reqfork(req);
+	int			state = 0;
+
+	/*
+	 * The exchmaps code only knows how to exchange file fork space
+	 * mappings.  Any fork data in local format must be promoted to a
+	 * single block before the exchange can take place.
+	 */
+	ifp = xfs_ifork_ptr(sc->ip, whichfork);
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL)
+		state |= 1;
+
+	tifp = xfs_ifork_ptr(sc->tempip, whichfork);
+	if (tifp->if_format == XFS_DINODE_FMT_LOCAL)
+		state |= 2;
+
+	switch (state) {
+	case 0:
+		/* Both files have mapped extents; use the regular estimate. */
+		return xfs_exchrange_estimate(req);
+	case 1:
+		/*
+		 * The file being repaired is in local format, but the temp
+		 * file has mapped extents.  To perform the exchange, the file
+		 * being repaired must have its shorform data converted to an
+		 * ondisk block so that the forks will be in extents format.
+		 * We need one resblk for the conversion; the number of
+		 * exchanges is (worst case) the temporary file's extent count
+		 * plus the block we converted.
+		 */
+		req->ip1_bcount = sc->tempip->i_nblocks;
+		req->ip2_bcount = 1;
+		req->nr_exchanges = 1 + tifp->if_nextents;
+		req->resblks = 1;
+		break;
+	case 2:
+		/*
+		 * The temporary file is in local format, but the file being
+		 * repaired has mapped extents.  To perform the exchange, the
+		 * temp file must have its shortform data converted to an
+		 * ondisk block, and the fork changed to extents format.  We
+		 * need one resblk for the conversion; the number of exchanges
+		 * is (worst case) the extent count of the file being repaired
+		 * plus the block we converted.
+		 */
+		req->ip1_bcount = 1;
+		req->ip2_bcount = sc->ip->i_nblocks;
+		req->nr_exchanges = 1 + ifp->if_nextents;
+		req->resblks = 1;
+		break;
+	case 3:
+		/*
+		 * Both forks are in local format.  To perform the exchange,
+		 * both files must have their shortform data converted to
+		 * fsblocks, and both forks must be converted to extents
+		 * format.  We need two resblks for the two conversions, and
+		 * the number of exchanges is 1 since there's only one block at
+		 * fileoff 0.  Presumably, the caller could not exchange the
+		 * two inode fork areas directly.
+		 */
+		req->ip1_bcount = 1;
+		req->ip2_bcount = 1;
+		req->nr_exchanges = 1;
+		req->resblks = 2;
+		break;
+	}
+
+	return xfs_exchmaps_estimate_overhead(req);
+}
+
 /*
  * Obtain a quota reservation to make sure we don't hit EDQUOT.  We can skip
  * this if quota enforcement is disabled or if both inodes' dquots are the
@@ -604,6 +709,55 @@ xrep_tempexch_trans_reserve(
 	return xrep_tempexch_reserve_quota(sc, tx);
 }
 
+/*
+ * Create a new transaction for a file contents exchange.
+ *
+ * This function fills out the mapping excahange request and resource
+ * estimation structures in preparation for exchanging the contents of a
+ * metadata file that has been rebuilt in the temp file.  Next, it reserves
+ * space, takes ILOCK_EXCL of both inodes, joins them to the transaction and
+ * reserves quota for the transaction.
+ *
+ * The caller is responsible for dropping both ILOCKs when appropriate.
+ */
+int
+xrep_tempexch_trans_alloc(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	struct xrep_tempexch	*tx)
+{
+	unsigned int		flags = 0;
+	int			error;
+
+	ASSERT(sc->tp == NULL);
+
+	error = xrep_tempexch_prep_request(sc, whichfork, tx);
+	if (error)
+		return error;
+
+	error = xrep_tempexch_estimate(sc, tx);
+	if (error)
+		return error;
+
+	if (xfs_has_lazysbcount(sc->mp))
+		flags |= XFS_TRANS_RES_FDBLKS;
+
+	error = xrep_tempexch_enable(sc);
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
+	xfs_exchrange_ilock(sc->tp, sc->ip, sc->tempip);
+
+	return xrep_tempexch_reserve_quota(sc, tx);
+}
+
 /*
  * Exchange file mappings (and hence file contents) between the file being
  * repaired and the temporary file.  Returns with both inodes locked and joined
@@ -637,3 +791,53 @@ xrep_tempexch_contents(
 
 	return 0;
 }
+
+/*
+ * Write local format data from one of the temporary file's forks into the same
+ * fork of file being repaired, and exchange the file sizes, if appropriate.
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
+	xfs_init_local_fork(sc->ip, whichfork, temp_ifp->if_data,
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
index 7980f9c4de55..d57e4f145a7c 100644
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

