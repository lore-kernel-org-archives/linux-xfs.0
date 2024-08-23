Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71806B653
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372205; cv=none; b=D9auXHV762n5r54JOy5yP804eXzRDu1jQFuewB4Nb7wZn+SZAFy50jjzY1sgnko/g2scGgBKkJefFfKgvhbjNIMYUgkFMnbUAUf4W28NutEZpqepR/WN5pKPKRnfBdbAWr/Znm4Yb/rOyLrDNUNkrr9vgCYHKn60CJF/PTs1jBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372205; c=relaxed/simple;
	bh=ozA4EmSscf8tKuWueZ/FTlxMDe7YcyxIJ4VhbpEOcvQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XAkdUvAx401WtV0YeXk0gz6VjbZXLIb5fYulWHzMfEkvTjs/ndslKoXnDsNcsoqVdUTVRrbcqQRi29N1y5mGlAOmodppxSoKJ08mq4LugKH0/cHvQk3qk8EEs6gIA4DyzsCetFkdjWepeIGiaUItMlrFHA89E/o0grotaX2bHj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pZOUj1Oq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pZOUj1Oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032FCC32782;
	Fri, 23 Aug 2024 00:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372205;
	bh=ozA4EmSscf8tKuWueZ/FTlxMDe7YcyxIJ4VhbpEOcvQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pZOUj1OqvDjOBu5lw9eT0nvRzgQeX7KI39IHSb/bB/SYQGI9m4RjI+nXbWXjAHMuZ
	 LBANA3Ki7DX/cAyv3kU0bALFTqxXMhrrJxbIpANNrWlvOyf8CQkl7qP27qLiXGK8hP
	 +Q+f1IDGo3eR2hHAtM5WNzE7PSPpZFUFTHYil6UKpqKgUrzkCRIkk5XxDqOlNkEt4o
	 HVvVoh2+LZM2nRusoovSg+7EY24GFZSEbEw2J+O7NSeCXWeRY67ZvPYtPMdrsn9fn5
	 8zZsqGsvmzgcIbyNJTfSioAok4mVGEQD/guTKH8631Oh6Giu2T+7j4WSuXnV1+dCxO
	 3z2Qi4NXtIAaQ==
Date: Thu, 22 Aug 2024 17:16:44 -0700
Subject: [PATCH 08/24] xfs: replace m_rsumsize with m_rsumblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087380.59588.7712029800357305412.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Track the RT summary file size in blocks, just like the RT bitmap
file.  While we have users of both units, blocks are used slightly
more often and this matches the bitmap file for consistency.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c    |    2 +-
 fs/xfs/libxfs/xfs_trans_resv.c  |    2 +-
 fs/xfs/scrub/rtsummary.c        |   11 +++++------
 fs/xfs/scrub/rtsummary.h        |    2 +-
 fs/xfs/scrub/rtsummary_repair.c |   12 +++++-------
 fs/xfs/xfs_mount.h              |    2 +-
 fs/xfs/xfs_rtalloc.c            |   13 +++++--------
 7 files changed, 19 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 76706e8bbc4ea..27a4472402bac 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -162,7 +162,7 @@ xfs_rtsummary_read_buf(
 {
 	struct xfs_mount		*mp = args->mp;
 
-	if (XFS_IS_CORRUPT(mp, block >= XFS_B_TO_FSB(mp, mp->m_rsumsize))) {
+	if (XFS_IS_CORRUPT(mp, block >= mp->m_rsumblocks)) {
 		xfs_rt_mark_sick(args->mp, XFS_SICK_RT_SUMMARY);
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 45aaf169806aa..2e6d7bb3b5a2f 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -918,7 +918,7 @@ xfs_calc_growrtfree_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		xfs_calc_inode_res(mp, 2) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_blocksize) +
-		xfs_calc_buf_res(1, mp->m_rsumsize);
+		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, mp->m_rsumblocks));
 }
 
 /*
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 3fee603f52441..7c7366c98338b 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -63,7 +63,8 @@ xchk_setup_rtsummary(
 	 * us to avoid pinning kernel memory for this purpose.
 	 */
 	descr = xchk_xfile_descr(sc, "realtime summary file");
-	error = xfile_create(descr, mp->m_rsumsize, &sc->xfile);
+	error = xfile_create(descr, XFS_FSB_TO_B(mp, mp->m_rsumblocks),
+			&sc->xfile);
 	kfree(descr);
 	if (error)
 		return error;
@@ -95,16 +96,14 @@ xchk_setup_rtsummary(
 	 * volume.  Hence it is safe to compute and check the geometry values.
 	 */
 	if (mp->m_sb.sb_rblocks) {
-		xfs_filblks_t	rsumblocks;
 		int		rextslog;
 
 		rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
 		rextslog = xfs_compute_rextslog(rts->rextents);
 		rts->rsumlevels = rextslog + 1;
 		rts->rbmblocks = xfs_rtbitmap_blockcount(mp, rts->rextents);
-		rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
+		rts->rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
 				rts->rbmblocks);
-		rts->rsumsize = XFS_FSB_TO_B(mp, rsumblocks);
 	}
 	return 0;
 }
@@ -316,7 +315,7 @@ xchk_rtsummary(
 	}
 
 	/* Is m_rsumsize correct? */
-	if (mp->m_rsumsize != rts->rsumsize) {
+	if (mp->m_rsumblocks != rts->rsumblocks) {
 		xchk_ino_set_corrupt(sc, mp->m_rsumip->i_ino);
 		goto out_rbm;
 	}
@@ -332,7 +331,7 @@ xchk_rtsummary(
 	 * growfsrt expands the summary file before updating sb_rextents, so
 	 * the file can be larger than rsumsize.
 	 */
-	if (mp->m_rsumip->i_disk_size < rts->rsumsize) {
+	if (mp->m_rsumip->i_disk_size < XFS_FSB_TO_B(mp, rts->rsumblocks)) {
 		xchk_ino_set_corrupt(sc, mp->m_rsumip->i_ino);
 		goto out_rbm;
 	}
diff --git a/fs/xfs/scrub/rtsummary.h b/fs/xfs/scrub/rtsummary.h
index e1d50304d8d48..e44b04cb6e2d5 100644
--- a/fs/xfs/scrub/rtsummary.h
+++ b/fs/xfs/scrub/rtsummary.h
@@ -14,7 +14,7 @@ struct xchk_rtsummary {
 
 	uint64_t		rextents;
 	uint64_t		rbmblocks;
-	uint64_t		rsumsize;
+	xfs_filblks_t		rsumblocks;
 	unsigned int		rsumlevels;
 	unsigned int		resblks;
 
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index d9e971c4c79fb..7deeb948cb702 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -56,7 +56,7 @@ xrep_setup_rtsummary(
 	 * transaction (which we cannot drop because we cannot drop the
 	 * rtsummary ILOCK) and cannot ask for more reservation.
 	 */
-	blocks = XFS_B_TO_FSB(mp, mp->m_rsumsize);
+	blocks = mp->m_rsumblocks;
 	blocks += xfs_bmbt_calc_size(mp, blocks) * 2;
 	if (blocks > UINT_MAX)
 		return -EOPNOTSUPP;
@@ -100,7 +100,6 @@ xrep_rtsummary(
 {
 	struct xchk_rtsummary	*rts = sc->buf;
 	struct xfs_mount	*mp = sc->mp;
-	xfs_filblks_t		rsumblocks;
 	int			error;
 
 	/* We require the rmapbt to rebuild anything. */
@@ -131,10 +130,9 @@ xrep_rtsummary(
 	}
 
 	/* Make sure we have space allocated for the entire summary file. */
-	rsumblocks = XFS_B_TO_FSB(mp, rts->rsumsize);
 	xfs_trans_ijoin(sc->tp, sc->ip, 0);
 	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
-	error = xrep_tempfile_prealloc(sc, 0, rsumblocks);
+	error = xrep_tempfile_prealloc(sc, 0, rts->rsumblocks);
 	if (error)
 		return error;
 
@@ -143,11 +141,11 @@ xrep_rtsummary(
 		return error;
 
 	/* Copy the rtsummary file that we generated. */
-	error = xrep_tempfile_copyin(sc, 0, rsumblocks,
+	error = xrep_tempfile_copyin(sc, 0, rts->rsumblocks,
 			xrep_rtsummary_prep_buf, rts);
 	if (error)
 		return error;
-	error = xrep_tempfile_set_isize(sc, rts->rsumsize);
+	error = xrep_tempfile_set_isize(sc, XFS_FSB_TO_B(mp, rts->rsumblocks));
 	if (error)
 		return error;
 
@@ -168,7 +166,7 @@ xrep_rtsummary(
 		memset(mp->m_rsum_cache, 0xFF, mp->m_sb.sb_rbmblocks);
 
 	mp->m_rsumlevels = rts->rsumlevels;
-	mp->m_rsumsize = rts->rsumsize;
+	mp->m_rsumblocks = rts->rsumblocks;
 
 	/* Free the old rtsummary blocks if they're not in use. */
 	return xrep_reap_ifork(sc, sc->tempip, XFS_DATA_FORK);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6251ebced3062..9e883d2159fd9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -148,7 +148,7 @@ typedef struct xfs_mount {
 	int			m_logbufs;	/* number of log buffers */
 	int			m_logbsize;	/* size of each log buffer */
 	uint			m_rsumlevels;	/* rt summary levels */
-	uint			m_rsumsize;	/* size of rt summary, bytes */
+	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_qflags;	/* quota status flags */
 	uint64_t		m_features;	/* active filesystem features */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7854cd355311b..46a920b192d19 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -736,9 +736,8 @@ xfs_growfs_rt_bmblock(
 	nmp->m_sb.sb_rextents = xfs_rtb_to_rtx(nmp, nmp->m_sb.sb_rblocks);
 	nmp->m_sb.sb_rextslog = xfs_compute_rextslog(nmp->m_sb.sb_rextents);
 	nmp->m_rsumlevels = nmp->m_sb.sb_rextslog + 1;
-	nmp->m_rsumsize = XFS_FSB_TO_B(mp,
-		xfs_rtsummary_blockcount(mp, nmp->m_rsumlevels,
-			nmp->m_sb.sb_rbmblocks));
+	nmp->m_rsumblocks = xfs_rtsummary_blockcount(mp, nmp->m_rsumlevels,
+			nmp->m_sb.sb_rbmblocks);
 
 	/*
 	 * Recompute the growfsrt reservation from the new rsumsize, so that the
@@ -768,7 +767,7 @@ xfs_growfs_rt_bmblock(
 	 * so that inode inactivation won't punch what it thinks are "posteof"
 	 * blocks.
 	 */
-	rsumip->i_disk_size = nmp->m_rsumsize;
+	rsumip->i_disk_size = nmp->m_rsumblocks * nmp->m_sb.sb_blocksize;
 	i_size_write(VFS_I(rsumip), rsumip->i_disk_size);
 	xfs_trans_log_inode(args.tp, rsumip, XFS_ILOG_CORE);
 
@@ -820,7 +819,7 @@ xfs_growfs_rt_bmblock(
 	 * Update the calculated values in the real mount structure.
 	 */
 	mp->m_rsumlevels = nmp->m_rsumlevels;
-	mp->m_rsumsize = nmp->m_rsumsize;
+	mp->m_rsumblocks = nmp->m_rsumblocks;
 	xfs_mount_sb_set_rextsize(mp, &mp->m_sb);
 
 	/*
@@ -1024,7 +1023,6 @@ xfs_rtmount_init(
 	struct xfs_buf		*bp;	/* buffer for last block of subvolume */
 	struct xfs_sb		*sbp;	/* filesystem superblock copy in mount */
 	xfs_daddr_t		d;	/* address of last block of subvolume */
-	unsigned int		rsumblocks;
 	int			error;
 
 	sbp = &mp->m_sb;
@@ -1036,9 +1034,8 @@ xfs_rtmount_init(
 		return -ENODEV;
 	}
 	mp->m_rsumlevels = sbp->sb_rextslog + 1;
-	rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
+	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
 			mp->m_sb.sb_rbmblocks);
-	mp->m_rsumsize = XFS_FSB_TO_B(mp, rsumblocks);
 	mp->m_rbmip = mp->m_rsumip = NULL;
 	/*
 	 * Check that the realtime section is an ok size.

