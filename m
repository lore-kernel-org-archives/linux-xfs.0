Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D68620
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371627; cv=none; b=IIXedBbTXc1v6D70gamHvjOTkaHGlJfWG5QfD70CoU7kk7p2iiGv2OkysvoGUm5poVGVlg8ek28tGz31ZCfS/lgEPn6WUal2bchsHWLQ66Wt2yw4KZXoARMNvyipv5DqBEtYuGhQWBjNHEZrgK9C+lQZHlnYMPAjiY0t07zub4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371627; c=relaxed/simple;
	bh=0FU7AnKHFeosLzIqCQliAiyGWDSYu/NR3Xgz2vIblWQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CfHk/AWf3ZoE8ZmnuLWyIGHLa9d/9fxmDqf9eUCMtRYvwtCvDr0IIWHnMh1thPAiXg+RuqMxUMYvOI6D4bF2oqW9ncPfE0aMGwEVAc+dElvSXt71yemDX4Vszgfgo+ZXwkKHQ346imo+BAHf/N/F8ptU5TS1CFy5EkOSU3J/0cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tShlDJ5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tShlDJ5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1072DC32782;
	Fri, 23 Aug 2024 00:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371627;
	bh=0FU7AnKHFeosLzIqCQliAiyGWDSYu/NR3Xgz2vIblWQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tShlDJ5f+iWa4GNfzPUmBMT4cxtIVZ4V/AfELPslKs+tcCmoRB1ARJ6f/iOa+S4FV
	 wu8e2Z6pl4BAFT4fMtPOIXhTrRX4B/c9fTXQ3RsgygqU88syEf345VSMPAOWg9TldX
	 0QnaAftsEnioUCK1WUB983N8jw3kv7ijmXD6Nm0ziovkEZ/WZqEE1tJQA/RvvL42DV
	 3jnM8eOdAryaHp/Okmg0SgNadm0HuLWLEGL8y0tvUl9TbQqi7xuJgPQJcdKW2phg+x
	 cHAKxk12fHyyS1cxz+qD4x6lW4twTnnYp21C9jhS03HUSUpcLTq1RQMZlqgMq8G/BM
	 q1jAmvPi7Rg+Q==
Date: Thu, 22 Aug 2024 17:07:06 -0700
Subject: [PATCH 19/26] xfs: adjust parent pointer scrubber for sb-rooted
 metadata files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085501.57482.6596528336134519104.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/parent.c        |    8 ++++++++
 fs/xfs/scrub/parent_repair.c |   35 +++++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 582536076433a..d8ea393f50597 100644
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
index f4e4845b7ec09..31bfe10be22a2 100644
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

