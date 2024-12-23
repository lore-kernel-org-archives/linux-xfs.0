Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819AF1422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990812; cv=none; b=MOJrByKlzkETenPBAYMT89XlfQ8ZoU5okt/265UofEacL9xtLhJ5b+hYP8eoox2bQ6/nwMpzxgZzSLdMmFXOtXNJolFtCGpfYpuQBQIgNaSxhv3bQgqru+ivPCkq9QikUTDI2ZLiK6r2FUBKMEtEOlrsmdMNnEKMsNO5QTh4Gs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990812; c=relaxed/simple;
	bh=nlKdakrj9YPbtnIN9/CWeNbT0nxicy6fP+nObhMf/B4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tCcR1QSFTMRMnPt/kMeYixPHSMSc42WHg2PtXs4hJVjvkep+xUK1H0ZL+whDq7eO/QlfHa797S4SV6I+Tc3WhffCD2kn/kAbykhUcLR3r4ebbk4IVjtaZXA5COkQqFvF7CiLzN2qIi3UBCFklvV9/coC76xKBhz59quOnlsxKVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKeSeazz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKeSeazz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EFFC4CED3;
	Mon, 23 Dec 2024 21:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990812;
	bh=nlKdakrj9YPbtnIN9/CWeNbT0nxicy6fP+nObhMf/B4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BKeSeazzJOG77eYRmz6f8nD/pqAbU92Vzu2idNAPaDZ9x3uxO9o2vdHzMl2M6wK9D
	 h16lZGocyBhzBgzCjDkasWcd5RjBXI30PPkHbc3DlbZZ+NR4q2266YgMPYb/2Qt+H9
	 HI0xv9KIm1J+0pjgu7Vcw8QY9QHj8sqesNFfz7+YQoCDXMeSIctk5LeMKuiwknHtTZ
	 asUXsE6NdDvDRMOEPfZHiH9q8hPSvVBGG2vH7y8m9pFw7bUv+3ju0U4td5oZYfMjBx
	 okYg+ViXbOVhG/MuIKfSJTMfVRI/oYMkSlTgBQ8N4r6tXZVNhu1R+0EH75rmnLJEMy
	 mLjuMCR1JHPLw==
Date: Mon, 23 Dec 2024 13:53:31 -0800
Subject: [PATCH 27/41] xfs_repair: refactor grabbing realtime metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941382.2294268.17205149313239172434.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a helper function to grab a realtime metadata inode.  When
metadir arrives, the bitmap and summary inodes can float, so we'll
turn this function into a "load or allocate" function.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase6.c |   51 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 17 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index b3c013138be6c8..1decfe2286fa47 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -474,6 +474,24 @@ reset_sbroot_ino(
 	libxfs_inode_init(tp, &args, ip);
 }
 
+/* Load a realtime freespace metadata inode from disk and reset it. */
+static int
+ensure_rtino(
+	struct xfs_trans		*tp,
+	xfs_ino_t			ino,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	int				error;
+
+	error = -libxfs_iget(mp, tp, ino, 0, ipp);
+	if (error)
+		return error;
+
+	reset_sbroot_ino(tp, S_IFREG, *ipp);
+	return 0;
+}
+
 static void
 mk_rbmino(
 	struct xfs_mount	*mp)
@@ -486,15 +504,14 @@ mk_rbmino(
 	if (error)
 		res_failed(error);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime bitmap inode -- error - %d\n"),
-			error);
-	}
-
 	/* Reset the realtime bitmap inode. */
-	reset_sbroot_ino(tp, S_IFREG, ip);
+	error = ensure_rtino(tp, mp->m_sb.sb_rbmino, &ip);
+	if (error) {
+		do_error(
+		_("couldn't iget realtime bitmap inode -- error - %d\n"),
+			error);
+	}
+
 	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
@@ -560,7 +577,8 @@ _("couldn't re-initialize realtime summary inode, error %d\n"), error);
 }
 
 static void
-mk_rsumino(xfs_mount_t *mp)
+mk_rsumino(
+	struct xfs_mount	*mp)
 {
 	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
@@ -570,15 +588,14 @@ mk_rsumino(xfs_mount_t *mp)
 	if (error)
 		res_failed(error);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime summary inode -- error - %d\n"),
-			error);
-	}
-
 	/* Reset the rt summary inode. */
-	reset_sbroot_ino(tp, S_IFREG, ip);
+	error = ensure_rtino(tp, mp->m_sb.sb_rsumino, &ip);
+	if (error) {
+		do_error(
+		_("couldn't iget realtime summary inode -- error - %d\n"),
+			error);
+	}
+
 	ip->i_disk_size = mp->m_rsumblocks * mp->m_sb.sb_blocksize;
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);

