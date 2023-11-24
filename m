Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918DA39FC7
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xge3bHyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24386C433C8;
	Fri, 24 Nov 2023 23:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700870084;
	bh=Lr+V9F+BkN7P9e4KVzKgiv1H6SiAyNPvTK8k+ETH2xk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xge3bHyunqo+mLNF6LGEmvaWUr0e4DViK9Dw7c0Ift3Lkbpcixue0JQ8ygUQ4TIFX
	 nqNgtKUomlv419srA4ENYUuNC7icKkAfshydv2wopHNyIml3FmpO5sraI4FWy3qya2
	 +BhnhUfz3DfvieH5yoz4wUpS2MgAtBKi0ouCPcRVvDOh88DZMI3U07+Oymo/bO7/os
	 4HoA79Xe67WglR4gZ01wZD/0vB9BKTyXbdqXnfvofKORthg4MDBLBO1iEDP8urzdQ8
	 E8XyQdt7M5k8Z3uGoa2UWdH3obvNOQXOAI5qrLIBQfI/AygnpJWyxePCgKONXWfzYg
	 T5DhxzbipYNWA==
Date: Fri, 24 Nov 2023 15:54:43 -0800
Subject: [PATCH 2/6] xfs: check rt summary file geometry more thoroughly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086928377.2771542.14818456920992275639.stgit@frogsfrogsfrogs>
In-Reply-To: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
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

I forgot that the xfs_mount tracks the size and number of levels in the
realtime summary file, and that the rt summary file can have more blocks
mapped to the data fork than m_rsumsize implies if growfsrt fails.

So.  Add to the rtsummary scrubber an explicit check that all the
summary geometry values are correct, then adjust the rtsummary i_size
checks to allow for the growfsrt failure case.  Finally, flag post-eof
blocks in the summary file.

While we're at it, split the extent map checking so that we only call
xfs_bmapi_read once per extent instead of once per rtsummary block.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rtsummary.c |  132 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 105 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index f94800a029f35..41f64158c8626 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -31,6 +31,18 @@
  * (potentially large) amount of data in pageable memory.
  */
 
+struct xchk_rtsummary {
+	struct xfs_rtalloc_args	args;
+
+	uint64_t		rextents;
+	uint64_t		rbmblocks;
+	uint64_t		rsumsize;
+	unsigned int		rsumlevels;
+
+	/* Memory buffer for the summary comparison. */
+	union xfs_suminfo_raw	words[];
+};
+
 /* Set us up to check the rtsummary file. */
 int
 xchk_setup_rtsummary(
@@ -38,8 +50,16 @@ xchk_setup_rtsummary(
 {
 	struct xfs_mount	*mp = sc->mp;
 	char			*descr;
+	struct xchk_rtsummary	*rts;
+	xfs_filblks_t		rsumblocks;
 	int			error;
 
+	rts = kvzalloc(struct_size(rts, words, mp->m_blockwsize),
+			XCHK_GFP_FLAGS);
+	if (!rts)
+		return -ENOMEM;
+	sc->buf = rts;
+
 	/*
 	 * Create an xfile to construct a new rtsummary file.  The xfile allows
 	 * us to avoid pinning kernel memory for this purpose.
@@ -54,11 +74,6 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
-	/* Allocate a memory buffer for the summary comparison. */
-	sc->buf = kvmalloc(mp->m_sb.sb_blocksize, XCHK_GFP_FLAGS);
-	if (!sc->buf)
-		return -ENOMEM;
-
 	error = xchk_install_live_inode(sc, mp->m_rsumip);
 	if (error)
 		return error;
@@ -75,13 +90,23 @@ xchk_setup_rtsummary(
 	 */
 	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+
+	/*
+	 * Now that we've locked the rtbitmap and rtsummary, we can't race with
+	 * growfsrt trying to expand the summary or change the size of the rt
+	 * volume.  Hence it is safe to compute and check the geometry values.
+	 */
+	rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
+	rts->rbmblocks = xfs_rtbitmap_blockcount(mp, rts->rextents);
+	rts->rsumlevels = rts->rextents ? xfs_highbit32(rts->rextents) + 1 : 0;
+	rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
+			rts->rbmblocks);
+	rts->rsumsize = XFS_FSB_TO_B(mp, rsumblocks);
 	return 0;
 }
 
 /* Helper functions to record suminfo words in an xfile. */
 
-typedef unsigned int xchk_rtsumoff_t;
-
 static inline int
 xfsum_load(
 	struct xfs_scrub	*sc,
@@ -192,19 +217,29 @@ STATIC int
 xchk_rtsum_compare(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_rtalloc_args args = {
-		.mp		= sc->mp,
-		.tp		= sc->tp,
-	};
-	struct xfs_mount	*mp = sc->mp;
 	struct xfs_bmbt_irec	map;
-	xfs_fileoff_t		off;
-	xchk_rtsumoff_t		sumoff = 0;
-	int			nmap;
+	struct xfs_iext_cursor	icur;
 
-	for (off = 0; off < XFS_B_TO_FSB(mp, mp->m_rsumsize); off++) {
-		union xfs_suminfo_raw *ondisk_info;
-		int		error = 0;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip = sc->ip;
+	struct xchk_rtsummary	*rts = sc->buf;
+	xfs_fileoff_t		off = 0;
+	xfs_fileoff_t		endoff;
+	xfs_rtsumoff_t		sumoff = 0;
+	int			error = 0;
+
+	rts->args.mp = sc->mp;
+	rts->args.tp = sc->tp;
+
+	/* Mappings may not cross or lie beyond EOF. */
+	endoff = XFS_B_TO_FSB(mp, ip->i_disk_size);
+	if (xfs_iext_lookup_extent(ip, &ip->i_df, endoff, &icur, &map)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, endoff);
+		return 0;
+	}
+
+	while (off < endoff) {
+		int		nmap = 1;
 
 		if (xchk_should_terminate(sc, &error))
 			return error;
@@ -212,8 +247,7 @@ xchk_rtsum_compare(
 			return 0;
 
 		/* Make sure we have a written extent. */
-		nmap = 1;
-		error = xfs_bmapi_read(mp->m_rsumip, off, 1, &map, &nmap,
+		error = xfs_bmapi_read(ip, off, endoff - off, &map, &nmap,
 				XFS_DATA_FORK);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, off, &error))
 			return error;
@@ -223,24 +257,33 @@ xchk_rtsum_compare(
 			return 0;
 		}
 
+		off += map.br_blockcount;
+	}
+
+	for (off = 0; off < endoff; off++) {
+		union xfs_suminfo_raw	*ondisk_info;
+
 		/* Read a block's worth of ondisk rtsummary file. */
-		error = xfs_rtsummary_read_buf(&args, off);
+		error = xfs_rtsummary_read_buf(&rts->args, off);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, off, &error))
 			return error;
 
 		/* Read a block's worth of computed rtsummary file. */
-		error = xfsum_copyout(sc, sumoff, sc->buf, mp->m_blockwsize);
+		error = xfsum_copyout(sc, sumoff, rts->words, mp->m_blockwsize);
 		if (error) {
-			xfs_rtbuf_cache_relse(&args);
+			xfs_rtbuf_cache_relse(&rts->args);
 			return error;
 		}
 
-		ondisk_info = xfs_rsumblock_infoptr(&args, 0);
-		if (memcmp(ondisk_info, sc->buf,
-					mp->m_blockwsize << XFS_WORDLOG) != 0)
+		ondisk_info = xfs_rsumblock_infoptr(&rts->args, 0);
+		if (memcmp(ondisk_info, rts->words,
+					mp->m_blockwsize << XFS_WORDLOG) != 0) {
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
+			xfs_rtbuf_cache_relse(&rts->args);
+			return error;
+		}
 
-		xfs_rtbuf_cache_relse(&args);
+		xfs_rtbuf_cache_relse(&rts->args);
 		sumoff += mp->m_blockwsize;
 	}
 
@@ -253,8 +296,43 @@ xchk_rtsummary(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xchk_rtsummary	*rts = sc->buf;
 	int			error = 0;
 
+	/* Is sb_rextents correct? */
+	if (mp->m_sb.sb_rextents != rts->rextents) {
+		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+		goto out_rbm;
+	}
+
+	/* Is m_rsumlevels correct? */
+	if (mp->m_rsumlevels != rts->rsumlevels) {
+		xchk_ino_set_corrupt(sc, mp->m_rsumip->i_ino);
+		goto out_rbm;
+	}
+
+	/* Is m_rsumsize correct? */
+	if (mp->m_rsumsize != rts->rsumsize) {
+		xchk_ino_set_corrupt(sc, mp->m_rsumip->i_ino);
+		goto out_rbm;
+	}
+
+	/* The summary file length must be aligned to an fsblock. */
+	if (mp->m_rsumip->i_disk_size & mp->m_blockmask) {
+		xchk_ino_set_corrupt(sc, mp->m_rsumip->i_ino);
+		goto out_rbm;
+	}
+
+	/*
+	 * Is the summary file itself large enough to handle the rt volume?
+	 * growfsrt expands the summary file before updating sb_rextents, so
+	 * the file can be larger than rsumsize.
+	 */
+	if (mp->m_rsumip->i_disk_size < rts->rsumsize) {
+		xchk_ino_set_corrupt(sc, mp->m_rsumip->i_ino);
+		goto out_rbm;
+	}
+
 	/* Invoke the fork scrubber. */
 	error = xchk_metadata_inode_forks(sc);
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))

