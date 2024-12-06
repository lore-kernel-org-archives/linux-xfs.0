Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B6D1F3D48
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528817; cv=none; b=phXr61GOStd+3mRDDnEVBr3i+9SaXzSTi/n/KbKKH+P/uYUKDALpgfVGkZvqQjbImuf/J+KY19fawYQJi/KzuziTw1fQIYWJnASNvGGsKv82IZ5GdadaOe7aydPO9oq+7OBPnG+q9PK0JX6vYXUQS9ESt8CjtF9LTilKmzibLPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528817; c=relaxed/simple;
	bh=plUQwkfPZjL4cRipqiwhlTcf5eW4BgXVf/yaGdTcS1g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HNeK46bJ5F/lhc1cwWI/UwPNWOSK04kggn0xTRUPczc3xP5yoTKvHH8kjFXfodL6SU6VHThnCqF0KI9Ks+0M/kFn6dso5WZPQbw6ok9bkDhaYjMODUcP5XysmbVCxy0inLqpscA4JKa+bjWz7+IZlBIfNwiOacZsgyY/PIIeIo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M+buSaNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M+buSaNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D87C4CED1;
	Fri,  6 Dec 2024 23:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528817;
	bh=plUQwkfPZjL4cRipqiwhlTcf5eW4BgXVf/yaGdTcS1g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M+buSaNwaoatsTUOtMakYIMTjIRGxN9XVZf/AtnCh15bPhPXnsTxvWBRRXpc7hSoV
	 E6gQ63alXi/FQsq7mwHbmTU3scsbHLpL1lFsGsJg+Qq51IGQbbJCb7VXrAq6hsajQN
	 m/NBeqcSKZgEFzkLHR3lav/eJfEJLn34e1Pr9/iGUb0G3xIeWsSKL/fcBpbXeosUfe
	 dscY5Ht36sDIifMuHGUcl2YrRNVfEaw2G2R3QV6p4ktnXF0SeCz9zXgMOaM5+wfEmn
	 3nyZeu1YWw2nn0jyQHAca4ZdVeO0zdLT/Lfux7QAXrd/Kz1HPC4gwDFLhh7QwLFVz0
	 4EcSN+7UO6qRg==
Date: Fri, 06 Dec 2024 15:46:56 -0800
Subject: [PATCH 28/41] xfs_repair: use libxfs_metafile_iget for quota/rt
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748664.122992.1499549460905283888.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use the new iget function for these metadata files so that we can check
types, etc.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase6.c     |   23 +++++++++--------------
 repair/quotacheck.c |   17 ++++++++++++++---
 repair/rt.c         |   29 ++++++++++++++++++++++-------
 3 files changed, 45 insertions(+), 24 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index e15d728ddc0469..84d2676e34fa53 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -484,6 +484,11 @@ ensure_rtino(
 	struct xfs_mount		*mp = tp->t_mountp;
 	int				error;
 
+	/*
+	 * Don't use metafile iget here because we're resetting sb-rooted
+	 * inodes that live at fixed inumbers, but these inodes could be in
+	 * an arbitrary state.
+	 */
 	error = -libxfs_iget(mp, tp, ino, 0, ipp);
 	if (error)
 		return error;
@@ -524,16 +529,11 @@ static void
 fill_rbmino(
 	struct xfs_mount	*mp)
 {
-	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
 	int			error;
 
-	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
-	if (error)
-		res_failed(error);
-
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip);
-	libxfs_trans_cancel(tp);
+	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_rbmino,
+			XFS_METAFILE_RTBITMAP, &ip);
 	if (error)
 		do_error(
 _("couldn't iget realtime bitmap inode, error %d\n"), error);
@@ -551,16 +551,11 @@ static void
 fill_rsumino(
 	struct xfs_mount	*mp)
 {
-	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
 	int			error;
 
-	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
-	if (error)
-		res_failed(error);
-
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip);
-	libxfs_trans_cancel(tp);
+	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_rsumino,
+			XFS_METAFILE_RTSUMMARY, &ip);
 	if (error)
 		do_error(
 _("couldn't iget realtime summary inode, error %d\n"), error);
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 4cb38db3ddd6d7..d9e08059927f80 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -403,21 +403,26 @@ quotacheck_verify(
 	struct xfs_ifork	*ifp;
 	struct qc_dquots	*dquots = NULL;
 	struct avl64node	*node, *n;
+	struct xfs_trans	*tp;
 	xfs_ino_t		ino = NULLFSINO;
+	enum xfs_metafile_type	metafile_type;
 	int			error;
 
 	switch (type) {
 	case XFS_DQTYPE_USER:
 		ino = mp->m_sb.sb_uquotino;
 		dquots = user_dquots;
+		metafile_type = XFS_METAFILE_USRQUOTA;
 		break;
 	case XFS_DQTYPE_GROUP:
 		ino = mp->m_sb.sb_gquotino;
 		dquots = group_dquots;
+		metafile_type = XFS_METAFILE_GRPQUOTA;
 		break;
 	case XFS_DQTYPE_PROJ:
 		ino = mp->m_sb.sb_pquotino;
 		dquots = proj_dquots;
+		metafile_type = XFS_METAFILE_PRJQUOTA;
 		break;
 	}
 
@@ -429,17 +434,21 @@ quotacheck_verify(
 	if (!dquots || !chkd_flags)
 		return;
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		do_error(_("could not alloc transaction to open quota file\n"));
+
+	error = -libxfs_trans_metafile_iget(tp, ino, metafile_type, &ip);
 	if (error) {
 		do_warn(
 	_("could not open %s inode %"PRIu64" for quotacheck, err=%d\n"),
 			qflags_typestr(type), ino, error);
 		chkd_flags = 0;
-		return;
+		goto out_trans;
 	}
 
 	ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
-	error = -libxfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+	error = -libxfs_iread_extents(tp, ip, XFS_DATA_FORK);
 	if (error) {
 		do_warn(
 	_("could not read %s inode %"PRIu64" extents, err=%d\n"),
@@ -477,6 +486,8 @@ _("%s record for id %u not found on disk (bcount %"PRIu64" rtbcount %"PRIu64" ic
 	}
 err:
 	libxfs_irele(ip);
+out_trans:
+	libxfs_trans_cancel(tp);
 }
 
 /*
diff --git a/repair/rt.c b/repair/rt.c
index 721c363cc1dd10..9ae421168e84b4 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -144,18 +144,34 @@ generate_rtinfo(
 static void
 check_rtfile_contents(
 	struct xfs_mount	*mp,
-	const char		*filename,
-	xfs_ino_t		ino,
-	void			*buf,
+	enum xfs_metafile_type	metafile_type,
 	xfs_fileoff_t		filelen)
 {
 	struct xfs_bmbt_irec	map;
 	struct xfs_buf		*bp;
 	struct xfs_inode	*ip;
+	const char		*filename;
+	void			*buf;
+	xfs_ino_t		ino;
 	xfs_fileoff_t		bno = 0;
 	int			error;
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
+	switch (metafile_type) {
+	case XFS_METAFILE_RTBITMAP:
+		ino = mp->m_sb.sb_rbmino;
+		filename = "rtbitmap";
+		buf = btmcompute;
+		break;
+	case XFS_METAFILE_RTSUMMARY:
+		ino = mp->m_sb.sb_rsumino;
+		filename = "rtsummary";
+		buf = sumcompute;
+		break;
+	default:
+		return;
+	}
+
+	error = -libxfs_metafile_iget(mp, ino, metafile_type, &ip);
 	if (error) {
 		do_warn(_("unable to open %s file, err %d\n"), filename, error);
 		return;
@@ -216,7 +232,7 @@ check_rtbitmap(
 	if (need_rbmino)
 		return;
 
-	check_rtfile_contents(mp, "rtbitmap", mp->m_sb.sb_rbmino, btmcompute,
+	check_rtfile_contents(mp, XFS_METAFILE_RTBITMAP,
 			mp->m_sb.sb_rbmblocks);
 }
 
@@ -227,6 +243,5 @@ check_rtsummary(
 	if (need_rsumino)
 		return;
 
-	check_rtfile_contents(mp, "rtsummary", mp->m_sb.sb_rsumino, sumcompute,
-			mp->m_rsumblocks);
+	check_rtfile_contents(mp, XFS_METAFILE_RTSUMMARY, mp->m_rsumblocks);
 }

