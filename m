Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB550179BF
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608033; cv=none; b=lyfN9OoCb79g4iWrlN/BoHdmVSsGTW0uRrqDi6LAVa4XxAN8weYADLbPbr9m0WcDFO9f6RpRExLSYpqMoUTDOqLUFf0eIirIk1R8Jme3RX5NXhPgASwV7DW7X2jLaOscAoCniCcapopqT44H82IAe0ORHjYRq/8RFGsO7vnjXfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608033; c=relaxed/simple;
	bh=wKMZ5cfp5HRqh3X8z6MvR8LKiu17lRFidy4V3a988Tc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F7reMfjIuxNja2oaOCXV4whxx9cTmjLLspikVV47/j0lEyjx6+lfWAk2+uxUsBgqOp4LlpBfOfzt460Y+k16nKyPWhqm0vIWys31uJBZLU8Df8wVd1SE+AgnTUwXz+AKG1CDsP+wgcayI6iDjYTjNnILaYSYKtABraj4eB5T5OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tn0Xu4wO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tn0Xu4wO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72204C4CEC5;
	Fri, 11 Oct 2024 00:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608032;
	bh=wKMZ5cfp5HRqh3X8z6MvR8LKiu17lRFidy4V3a988Tc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tn0Xu4wO5WZl9ZUlsU6BEZ+/lFLz/SO1SLql1mVKHVlphKTTnlrUhX7Ir9Lhso43Q
	 tKWluj1De6LSpzCaN/uuc/gth49hbjWW51HxG7B0zpy/SLO8Abf3EWOClyvm32Pqok
	 LpZ76xZPYL2+2fNDyDErlLE8GWEdBuIq81VvxUVK7knNwSq5rFQakzLfb+XQgBIbyh
	 6YycUFGPN/xs+4anCTbYpE/ZWVXw5ginjurOgF0FbijvB+Ioih2+fpJNl6qmmHXvIy
	 Hm1q8QvqUCZxuUGLwycp3ixDcRucCPb1HLO1EJHfDDEwzLCsblzbEFu2o2FoQB+KDr
	 UEDLdze3Z2k2g==
Date: Thu, 10 Oct 2024 17:53:51 -0700
Subject: [PATCH 21/28] xfs: adjust parent pointer scrubber for sb-rooted
 metadata files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642379.4176876.6094931305549892158.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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

Starting with the metadata directory feature, we're allowed to call the
directory and parent pointer scrubbers for every metadata file,
including the ones that are children of the superblock.

For these children, checking the link count against the number of parent
pointers is a bit funny -- there's no such thing as a parent pointer for
a child of the superblock since there's no corresponding dirent.  For
purposes of validating nlink, we pretend that there is a parent pointer.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/parent.c        |    8 ++++++++
 fs/xfs/scrub/parent_repair.c |   35 +++++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 582536076433a4..d8ea393f505970 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -720,6 +720,14 @@ xchk_parent_count_pptrs(
 			 pp->pptrs_found == 0)
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 	} else {
+		/*
+		 * Starting with metadir, we allow checking of parent pointers
+		 * of non-directory files that are children of the superblock.
+		 * Pretend that we found a parent pointer attr.
+		 */
+		if (xfs_has_metadir(sc->mp) && xchk_inode_is_sb_rooted(sc->ip))
+			pp->pptrs_found++;
+
 		if (VFS_I(sc->ip)->i_nlink != pp->pptrs_found)
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 	}
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index f4e4845b7ec099..31bfe10be22a21 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -1354,21 +1354,40 @@ STATIC int
 xrep_parent_rebuild_tree(
 	struct xrep_parent	*rp)
 {
+	struct xfs_scrub	*sc = rp->sc;
+	bool			try_adoption;
 	int			error;
 
-	if (xfs_has_parent(rp->sc->mp)) {
+	if (xfs_has_parent(sc->mp)) {
 		error = xrep_parent_rebuild_pptrs(rp);
 		if (error)
 			return error;
 	}
 
-	if (rp->pscan.parent_ino == NULLFSINO) {
-		if (xrep_orphanage_can_adopt(rp->sc))
+	/*
+	 * Any file with no parent could be adopted.  This check happens after
+	 * rebuilding the parent pointer structure because we might have cycled
+	 * the ILOCK during that process.
+	 */
+	try_adoption = rp->pscan.parent_ino == NULLFSINO;
+
+	/*
+	 * Starting with metadir, we allow checking of parent pointers
+	 * of non-directory files that are children of the superblock.
+	 * Lack of parent is ok here.
+	 */
+	if (try_adoption && xfs_has_metadir(sc->mp) &&
+	    xchk_inode_is_sb_rooted(sc->ip))
+		try_adoption = false;
+
+	if (try_adoption) {
+		if (xrep_orphanage_can_adopt(sc))
 			return xrep_parent_move_to_orphanage(rp);
 		return -EFSCORRUPTED;
+
 	}
 
-	if (S_ISDIR(VFS_I(rp->sc->ip)->i_mode))
+	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
 		return xrep_parent_reset_dotdot(rp);
 
 	return 0;
@@ -1422,6 +1441,14 @@ xrep_parent_set_nondir_nlink(
 	if (error)
 		return error;
 
+	/*
+	 * Starting with metadir, we allow checking of parent pointers of
+	 * non-directory files that are children of the superblock.  Pretend
+	 * that we found a parent pointer attr.
+	 */
+	if (xfs_has_metadir(sc->mp) && xchk_inode_is_sb_rooted(sc->ip))
+		rp->parents++;
+
 	if (rp->parents > 0 && xfs_inode_on_unlinked_list(ip)) {
 		xfs_trans_ijoin(sc->tp, sc->ip, 0);
 		joined = true;

