Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52A61D7E46
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990234; cv=none; b=OBv6X6kE6AwLIDW3K+sK2kJ9PENwB10G5UBg2u+cOtcNbDW/y2oIYjbX1oNPLHhaU7FyEQ/KBnZ7fDMu6H3S6FllArkjARsw+e5i12Y4dDrTzHbVk2gJfX9Sl0pzExg+l/Sp+UHhr4uvXSXB3DGrwEOyScbDlGp1mosTNoWYDdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990234; c=relaxed/simple;
	bh=cJbkPUaZrSX8ZRuS3Ka4nE1/x3YQO12vka1VZu/O9/o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSgM97YK9VQdXjoYZOT3ZBYB3VOpyKjdd0t0oOhGc6QTVgH0slwk8rx48T8Ls5k13XHu+tEgxj1kGu0+oU+Lo1ou1erosRV4dEu+KXMkUf/gU4ibBpomNKRoGMh6Noi4F7w5oJa8bXK5WIKoKGRQTuL5xI+jYVKjO5SLrcDXf9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JiffVfWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JiffVfWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9F7C4CED3;
	Mon, 23 Dec 2024 21:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990234;
	bh=cJbkPUaZrSX8ZRuS3Ka4nE1/x3YQO12vka1VZu/O9/o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JiffVfWtq1GPuG3/c3kEVxEKSP9nv8MqXfPxeUh3IpOuV4khxbtcyTnkSlZ68INIM
	 C4f5EEbtBrWa4l1Eo3kxCIK11rs9OU53MPIjA+xa6CZIlFv/ndtVxxA3KSCOYQLt7e
	 omBqmW/JrzfUDGUw++5rf6rsas8RFwGZk7ARWRxoAnIyDP1JmLQZsISZwQ48Udcali
	 Bl07dxJinHDIG26dBSfLCpXqQ1MrdxpM9SZDVV3cugfgmJW92VVAHot6arBW+xXp/4
	 OIh3T57o6cp7Zt69mV5nD6uAfsisQ9xPLdECHhxZDGe9TJwOvds5sP5JWN9dK80x8K
	 x6AOKmZRdcw9g==
Date: Mon, 23 Dec 2024 13:43:53 -0800
Subject: [PATCH 26/36] xfs: rename metadata inode predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940340.2293042.3014490112263022011.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
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

