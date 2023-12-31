Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F60ABA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKNGcnSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BEEC433C8;
	Sun, 31 Dec 2023 21:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057259;
	bh=NSt0hVXurvaHjUR2RpdoU55pSaxjlAGxq1IYToCRxYw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dKNGcnSJhTTdeeERt0F382geS2PaMIx4N6LZPrrbycjtcSH/mrjaoMtrIht0hZX+/
	 OrqSyxuE8p7Ijua2DM2xg0OEfU8DIKHb0+s8w3VmneBCM913joq9GPzZq2DC22e7P5
	 M3A4Y3LxTyuoM1bqoYfDFzvoo8LwG9/Z4CgfnFJ5ys9Swk0EfUiXQoDnUxwAm9ZUf3
	 87HB4z5/20MTOLf+mk1TXa+g4ApzBUxAc91G3kfatRuxx3aPomtoiDQrzT2D/UBMgV
	 ZKIblHs0y6dJZzYTCpXN24EFM4oMGLIlFn6zPe7CPhlgJfGbUEOJFX9OWgWNYaFghp
	 juNF/Y0ygdLeg==
Date: Sun, 31 Dec 2023 13:14:18 -0800
Subject: [PATCH 31/32] xfs: fix up repair functions for metadata directory
 roots
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845365.1760491.18052862070815177818.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Amend the directory and parent pointer repair code to handle the root of
the metadata directory tree correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c    |    2 +-
 fs/xfs/scrub/inode_repair.c  |    8 ++++----
 fs/xfs/scrub/orphanage.c     |    2 ++
 fs/xfs/scrub/parent_repair.c |    2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 304eb042df7c9..a6e2219941be7 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1324,7 +1324,7 @@ xrep_dir_scan_dirtree(
 	int			error;
 
 	/* Roots of directory trees are their own parents. */
-	if (sc->ip == sc->mp->m_rootip)
+	if (sc->ip == sc->mp->m_rootip || sc->ip == sc->mp->m_metadirip)
 		xrep_findparent_scan_found(&rd->pscan, sc->ip->i_ino);
 
 	/*
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index e2dde5834051c..2c4209054f41b 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1718,14 +1718,14 @@ xrep_inode_pptr(
 		return 0;
 
 	/* The root directory doesn't have a parent pointer. */
-	if (ip == mp->m_rootip)
+	if (ip == mp->m_rootip || ip == mp->m_metadirip)
 		return 0;
 
 	/*
-	 * Metadata inodes are rooted in the superblock and do not have any
-	 * parents.
+	 * Prior to metadata directories, all metadata inodes are rooted in the
+	 * superblock and do not have any parents.
 	 */
-	if (xfs_is_metadata_inode(ip))
+	if (!xfs_has_metadir(mp) && xfs_is_metadata_inode(ip))
 		return 0;
 
 	/* Inode already has an attr fork; no further work possible here. */
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index f1711d6031613..1c8f854aaf552 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -297,6 +297,8 @@ xrep_orphanage_can_adopt(
 		return false;
 	if (xfs_internal_inum(sc->mp, sc->ip->i_ino))
 		return false;
+	if (xfs_is_metadata_inode(sc->ip))
+		return false;
 	return true;
 }
 
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 04ea0b05ed088..65158dff840bb 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -1345,7 +1345,7 @@ xrep_parent_rebuild_pptrs(
 	 * so that we can decide if we're moving this file to the orphanage.
 	 * For this purpose, root directories are their own parents.
 	 */
-	if (sc->ip == sc->mp->m_rootip) {
+	if (sc->ip == sc->mp->m_rootip || sc->ip == sc->mp->m_metadirip) {
 		xrep_findparent_scan_found(&rp->pscan, sc->ip->i_ino);
 	} else {
 		error = xrep_parent_lookup_pptrs(sc, &parent_ino);

