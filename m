Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CF819CC03
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301435; cv=none; b=RjlGsPz9T1wtZCGPThcFLYM9Tv01ffsBUb72w0VA5eiLiGSkz4q7HGCPhoDODOTiPimh7P1EG4qBQO+dZhq8sy1Tief3tMbKEFHaRQTHqKoXQ6358u8zUKcg2Ukk4zV+n1KTYTjhTQ9cav/Q3+2+Bx3IIr/THHkSL4Cxx/mkJ6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301435; c=relaxed/simple;
	bh=tbOv9CTHgtChSiHs2pGqKJMRyMTKRa9HG4Q60s+dG1Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SN+AT3CkB93QT6GCDBvuN7HU7gGPebSGzBT6SBbi4yHvgLIC9K4BNotFpa+1G9HVALmLd9nbiWm78XfrmWFYTEEaHaF99Gx/ETgkbgzKg6gEilvKbM91Amo/6SZnep7Ey+k9yp70parUGXVIHZafmsAqZnr8fDMLwpQPOObOVYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEAffdNK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEAffdNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AD8C4CEC2;
	Mon,  2 Sep 2024 18:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301434;
	bh=tbOv9CTHgtChSiHs2pGqKJMRyMTKRa9HG4Q60s+dG1Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TEAffdNKnsAvLy11iUYHtfsPvmakSGBgphGRATqCmANFNqRsJc1j+U9IoPthedo1Z
	 nd30BBaB3YGijGu5VDWd2qwnIKuLPJ7xUy/7xWSoe6SeNOzU0Q6rfbCVm1ctbrrxY7
	 gebcQ2zQQ1jif6ivOJDT4NzQRThQ2pwPu5ezbVpzs++gqTy9U5VL7icLIU6u3N9Onn
	 blfkBgoxmcbFYFVB6GFvwZL/dQonQNk+AwVL4uw1qoDGudSBMn5exjjt+ncyWtQ90P
	 CZQi/6WUxxbofDz+sth+wDLj9YTg4/fqFqgURB/sByeskErTxtMO/tbgxAT4ysyXG8
	 oa+9DoG7PsQ6g==
Date: Mon, 02 Sep 2024 11:23:54 -0700
Subject: [PATCH 3/3] xfs: pass the icreate args object to xfs_dialloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530105356.3324987.8567603124185540522.stgit@frogsfrogsfrogs>
In-Reply-To: <172530105300.3324987.5977059243804546726.stgit@frogsfrogsfrogs>
References: <172530105300.3324987.5977059243804546726.stgit@frogsfrogsfrogs>
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

Pass the xfs_icreate_args object to xfs_dialloc since we can extract the
relevant mode (really just the file type) and parent inumber from there.
This simplifies the calling convention in preparation for the next
patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.c |    5 +++--
 fs/xfs/libxfs/xfs_ialloc.h |    4 +++-
 fs/xfs/scrub/tempfile.c    |    2 +-
 fs/xfs/xfs_inode.c         |    4 ++--
 fs/xfs/xfs_qm.c            |    2 +-
 fs/xfs/xfs_symlink.c       |    2 +-
 6 files changed, 11 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0af5b7a33d05..fc70601e8d8e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1855,11 +1855,12 @@ xfs_dialloc_try_ag(
 int
 xfs_dialloc(
 	struct xfs_trans	**tpp,
-	xfs_ino_t		parent,
-	umode_t			mode,
+	const struct xfs_icreate_args *args,
 	xfs_ino_t		*new_ino)
 {
 	struct xfs_mount	*mp = (*tpp)->t_mountp;
+	xfs_ino_t		parent = args->pip ? args->pip->i_ino : 0;
+	umode_t			mode = args->mode & S_IFMT;
 	xfs_agnumber_t		agno;
 	int			error = 0;
 	xfs_agnumber_t		start_agno;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index b549627e3a61..3a1323155a45 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -33,11 +33,13 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 	return xfs_buf_offset(b, o << (mp)->m_sb.sb_inodelog);
 }
 
+struct xfs_icreate_args;
+
 /*
  * Allocate an inode on disk.  Mode is used to tell whether the new inode will
  * need space, and whether it is a directory.
  */
-int xfs_dialloc(struct xfs_trans **tpp, xfs_ino_t parent, umode_t mode,
+int xfs_dialloc(struct xfs_trans **tpp, const struct xfs_icreate_args *args,
 		xfs_ino_t *new_ino);
 
 int xfs_difree(struct xfs_trans *tp, struct xfs_perag *pag,
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index d390d56cd875..177f922acfaf 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -88,7 +88,7 @@ xrep_tempfile_create(
 		goto out_release_dquots;
 
 	/* Allocate inode, set up directory. */
-	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
+	error = xfs_dialloc(&tp, &args, &ino);
 	if (error)
 		goto out_trans_cancel;
 	error = xfs_icreate(tp, ino, &args, &sc->tempip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7dc6f326936c..9ea7a18f5da1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -704,7 +704,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
+	error = xfs_dialloc(&tp, args, &ino);
 	if (!error)
 		error = xfs_icreate(tp, ino, args, &du.ip);
 	if (error)
@@ -812,7 +812,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_release_dquots;
 
-	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
+	error = xfs_dialloc(&tp, args, &ino);
 	if (!error)
 		error = xfs_icreate(tp, ino, args, &ip);
 	if (error)
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 9490b913a4ab..63f6ca2db251 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -799,7 +799,7 @@ xfs_qm_qino_alloc(
 		};
 		xfs_ino_t	ino;
 
-		error = xfs_dialloc(&tp, 0, S_IFREG, &ino);
+		error = xfs_dialloc(&tp, &args, &ino);
 		if (!error)
 			error = xfs_icreate(tp, ino, &args, ipp);
 		if (error) {
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 77f19e2f66e0..4252b07cd251 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -165,7 +165,7 @@ xfs_symlink(
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-	error = xfs_dialloc(&tp, dp->i_ino, S_IFLNK, &ino);
+	error = xfs_dialloc(&tp, &args, &ino);
 	if (!error)
 		error = xfs_icreate(tp, ino, &args, &du.ip);
 	if (error)

