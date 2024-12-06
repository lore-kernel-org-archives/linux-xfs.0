Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFEC212F87
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528223; cv=none; b=qjXgbefEDZt0BmDbyaSI1+gjQA5wrajPfZobdrGko62noeGKO2SxpUDA5NUTglJt1QyV/tSLzCvKKMrlkm/LmL9Z3NwB7D4oMYpctun9baP6roEFLFahVF7dE6r4QEepG3SwWRQQCiukvC49n14+UkNkVq2fMbbasPk9QesD9m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528223; c=relaxed/simple;
	bh=cJbkPUaZrSX8ZRuS3Ka4nE1/x3YQO12vka1VZu/O9/o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tyf/2ETQ7zHEhQgleGBmIEyQiQD2FcpANK0SRRwpIKiB4eUe6eGBnx5DSPGOKTMMJDTUE/IXXL3rwDmbN6PXClaIyHJ3yc9/aBjuNzS9mC3wk/gEmHDEIUbt0rFe6v7IN9lJ+az+AUhM1r9xBU/5Kdp6y9Wi63f0EG5Rnu0EzTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQPT39wx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQPT39wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0425EC4CEE3;
	Fri,  6 Dec 2024 23:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528223;
	bh=cJbkPUaZrSX8ZRuS3Ka4nE1/x3YQO12vka1VZu/O9/o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cQPT39wxUAmnQ0fKDKOFUeTNYJXz5XTDcuv84UK9QizLEe7xShkkkZcO/yMLWNsfh
	 jGXVuiP03ExDw6GkEfAGYx33P85ph638UESeZ1vlmcZLMTDpkjnCgPTJHYsdnIGc7g
	 ajmJmYBqskDxJM+AJsQPDKfZxGdvyfHSJXbff6gmWWp6xmHdARKsHsjCrDl46pYOv2
	 LQuUkTnBCMwhodDt/LCybKjUymGmyiIAfaK6aNZjFOdUFZyOQTbBJj2Tt1p1UIgZEh
	 OtZJtDwRDdAl6p+8eH0C7tJZxn7WERxraILRBTMb6plO4hpGgURw8PqVbeGy9vxghr
	 qHGug4Mj4XofQ==
Date: Fri, 06 Dec 2024 15:37:02 -0800
Subject: [PATCH 26/36] xfs: rename metadata inode predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747272.121772.9751250500228982931.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 4d272929a5258074328dae206c935634e0fd1a54

The predicate xfs_internal_inum tells us if an inumber refers to one of
the inodes rooted in the superblock.  Soon we're going to have internal
inodes in a metadata directory tree, so this helper should be renamed
to capture its limited scope.

Ondisk inodes will soon have a flag to indicate that they're metadata
inodes.  Head off some confusion by renaming the xfs_is_metadata_inode
predicate to xfs_is_internal_inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    2 +-
 libxfs/xfs_types.c       |    4 ++--
 libxfs/xfs_types.h       |    2 +-
 repair/rmap.c            |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 483a7a9a4cbf45..92e26eebabfed8 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -199,7 +199,7 @@
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
 
-#define xfs_internal_inum		libxfs_internal_inum
+#define xfs_is_sb_inum			libxfs_is_sb_inum
 
 #define xfs_iread_extents		libxfs_iread_extents
 #define xfs_irele			libxfs_irele
diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index 0d1b86ae59d93e..a70c0395979cf8 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -111,7 +111,7 @@ xfs_verify_ino(
 
 /* Is this an internal inode number? */
 inline bool
-xfs_internal_inum(
+xfs_is_sb_inum(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
@@ -129,7 +129,7 @@ xfs_verify_dir_ino(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
-	if (xfs_internal_inum(mp, ino))
+	if (xfs_is_sb_inum(mp, ino))
 		return false;
 	return xfs_verify_ino(mp, ino);
 }
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index d3cb6ff3b91301..25053a66c225ed 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -230,7 +230,7 @@ bool xfs_verify_fsbext(struct xfs_mount *mp, xfs_fsblock_t fsbno,
 		xfs_fsblock_t len);
 
 bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
-bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
+bool xfs_is_sb_inum(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 bool xfs_verify_rtbext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
diff --git a/repair/rmap.c b/repair/rmap.c
index 29af74eee11831..3b998a22cee10d 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -814,7 +814,7 @@ rmap_shareable(
 		return false;
 
 	/* Metadata in files are never shareable */
-	if (libxfs_internal_inum(mp, rmap->rm_owner))
+	if (libxfs_is_sb_inum(mp, rmap->rm_owner))
 		return false;
 
 	/* Metadata and unwritten file blocks are not shareable. */

