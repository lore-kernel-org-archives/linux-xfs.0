Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643354A08
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371331; cv=none; b=Te3J9hNiQv+DY2kxaN/jYUvtuGf9lfEg+pDSOT0uMbwbPgo1IRDH2IqA0rf0ysZ76XdP7mhoj+MC9n0tJ0XbKrtHwPcCKRR2BNuyqGsiKBsaFvTNyPo6lNjnonLW8x2bH/KncBXIoSp5dDeR9ItJ5KEqCKma7UespwIcUNaAs4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371331; c=relaxed/simple;
	bh=CG0Spvgj1tzBHFviDm3HIqXicChYDAu68kJk5XL1DJo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YAX+vreo/4tPD7tTsLrss6Fs0VQ8ggOG5uf8Q5BmH1HwuWHn0FWoXzGeWyhGiSJXjy1/72JpPpQGsvnXyg1UuMP5hz7UHa+2c7HjrnffKNhUi37oGYOr4NzcuUZtngtC9nVQVh9VjEtFfu+l5D7/7X3GG2TIG+s28E6cBwk2Gtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTenPTnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTenPTnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74D9C32782;
	Fri, 23 Aug 2024 00:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371330;
	bh=CG0Spvgj1tzBHFviDm3HIqXicChYDAu68kJk5XL1DJo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hTenPTnLYABtstVl2HCjeQKRAG3kTs6OwPNPSjTIE9/jFy9JD9Cd5b3AgQHUNcWAh
	 rQcKbsebPk63lh0rz/ApNvFPv1m0McAzLcaWmUU1zj6xhdLXtnuYevlGnyw14R2SOA
	 ofSpEPFfNIqNgtL6VHECVJPyZxUf3R+Aobd/885LgfrcDBO4KBhIS4xQP05ktHgReH
	 QFFWaV1BqxtkA2QNEPQsoF33rhS3QWbQPSqUXNF01pxzHHROODeJy6VXxg+JdcpORF
	 AmW9MxmHLMieHW/Fv3rU9BV25VPyHyJQoHmWAYiaVk0mn1UOb0nwGh8+BV4wSE0fc5
	 9x/IprkxQpqgg==
Date: Thu, 22 Aug 2024 17:02:09 -0700
Subject: [PATCH 3/3] xfs: pass the icreate args object to xfs_dialloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437084690.57308.4842818086745573630.stgit@frogsfrogsfrogs>
In-Reply-To: <172437084629.57308.17035804596151035899.stgit@frogsfrogsfrogs>
References: <172437084629.57308.17035804596151035899.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_ialloc.c |    5 +++--
 fs/xfs/libxfs/xfs_ialloc.h |    4 +++-
 fs/xfs/scrub/tempfile.c    |    2 +-
 fs/xfs/xfs_inode.c         |    4 ++--
 fs/xfs/xfs_qm.c            |    2 +-
 fs/xfs/xfs_symlink.c       |    2 +-
 6 files changed, 11 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 0af5b7a33d055..fc70601e8d8ee 100644
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
index b549627e3a615..3a1323155a455 100644
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
index d390d56cd8751..177f922acfaf1 100644
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
index 7dc6f326936ca..9ea7a18f5da14 100644
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
index 9490b913a4ab4..63f6ca2db2515 100644
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
index 77f19e2f66e07..4252b07cd2513 100644
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

