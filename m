Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A811719F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416216; cv=none; b=mMEGi8YnCJUqK1b6vLPZoRYR2GWLyi6Rqdou3Gw6YDk1KMLlPla/8HGpZ4EfcQpWuhFzDxFdwO5SaN3pPj4Nt9/2AUW5hdSF2qV9Dsk2a5tJ84SJnBARnvHT1BrVv6e2yDmOVcWFbpS6FZbUingI7fLCa8uqxdPgPi1hcjGSD/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416216; c=relaxed/simple;
	bh=mtDnYIlDEa0PDjO4XIepg+t8AOQUSBrP/Y9TrPiaYNs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CYVz2Y8ygj0/WN5Ccd/XzxpeyilY3dHAPrHLRNAvNymyuE9myTrfp64imK5FvjBz21qeDCZ1NaYxqMBrUOab4VjwGtgNZcRGtzgctSBgJHSDk23EY3PRsWcpPtPMfmIA/LVgfd33cWpnnm5uBI5KkgIpYBI0RO73TC16yZHq5B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnazq27Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnazq27Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB6EC4CECF;
	Thu, 31 Oct 2024 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416216;
	bh=mtDnYIlDEa0PDjO4XIepg+t8AOQUSBrP/Y9TrPiaYNs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nnazq27Q0FY6XcQGNOP4Xx4c+zJrlLKwV601G0GuEarOMFC/kvIeKpyXyH8V5zuTJ
	 pmYlXDSdMpaE6/S71O3ZrUgbn1ghtO2ndpYSUGgHwhdbpxIVfZGqZnkCZ0xSaOLeNr
	 jGi+FZZ64TL1+TmHSsfcfGwkllUxZVHEjvVdSAeBcNhHUWueXtPbuaKosdmZf374LF
	 92cWYDyS55ACgwpZLri8I4GAYuxVDxCeko6Yagl1Ds/oP9y5IXh9XHM0WOOZz9h5ko
	 KIyaJCcBwVS4cOlxlwNXjjsm5ko2W4Q3PeLDthDIkIycfMAroAp8WqeiR68FeOudRv
	 s0nuYzXTrvnFQ==
Date: Thu, 31 Oct 2024 16:10:15 -0700
Subject: [PATCH 06/41] xfs: pass the icreate args object to xfs_dialloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566011.962545.7956432226389299300.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 390b4775d6787706b1846f15623a68e576ec900c

Pass the xfs_icreate_args object to xfs_dialloc since we can extract the
relevant mode (really just the file type) and parent inumber from there.
This simplifies the calling convention in preparation for the next
patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/iunlink.c        |    2 +-
 libxfs/xfs_ialloc.c |    5 +++--
 libxfs/xfs_ialloc.h |    4 +++-
 mkfs/proto.c        |    5 ++---
 repair/phase6.c     |    2 +-
 5 files changed, 10 insertions(+), 8 deletions(-)


diff --git a/db/iunlink.c b/db/iunlink.c
index 0dc68b7240c1a3..55ba5af5a3c563 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -223,7 +223,7 @@ create_unlinked(
 		return error;
 	}
 
-	error = -libxfs_dialloc(&tp, 0, args.mode, &ino);
+	error = -libxfs_dialloc(&tp, &args, &ino);
 	if (error) {
 		dbprintf(_("alloc inode: %s\n"), strerror(error));
 		goto out_cancel;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index c526f677e072b4..83e3d7d7c5a1b3 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1850,11 +1850,12 @@ xfs_dialloc_try_ag(
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
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index b549627e3a6150..3a1323155a455a 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
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
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 8a51bfb264cedf..42ac3e10929b52 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -428,7 +428,6 @@ creatproto(
 	};
 	struct xfs_inode	*ip;
 	struct inode		*inode;
-	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
 	xfs_ino_t		ino;
 	int			error;
 
@@ -440,7 +439,7 @@ creatproto(
 	 * Call the space management code to pick the on-disk inode to be
 	 * allocated.
 	 */
-	error = -libxfs_dialloc(tpp, parent_ino, mode, &ino);
+	error = -libxfs_dialloc(tpp, &args, &ino);
 	if (error)
 		return error;
 
@@ -769,7 +768,7 @@ create_sb_metadata_file(
 	if (error)
 		res_failed(error);
 
-	error = -libxfs_dialloc(&tp, 0, args.mode, &ino);
+	error = -libxfs_dialloc(&tp, &args, &ino);
 	if (error)
 		goto fail;
 
diff --git a/repair/phase6.c b/repair/phase6.c
index ba28edaa41c24c..b48f18b06a5c81 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -873,7 +873,7 @@ mk_orphanage(
 	if (i)
 		res_failed(i);
 
-	error = -libxfs_dialloc(&tp, mp->m_sb.sb_rootino, args.mode, &ino);
+	error = -libxfs_dialloc(&tp, &args, &ino);
 	if (error)
 		do_error(_("%s inode allocation failed %d\n"),
 			ORPHANAGE, error);

