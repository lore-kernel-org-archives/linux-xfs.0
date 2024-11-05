Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A291DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845326; cv=none; b=A/MnsnYk6sN3MYCFdfTs8nnas75ozx7T33Jgd+TsgjhCdrr/qFwYrGqe+FisURKiZMjNfWiQsCvHbiorrHEAPV0kpu9eqRO2Nm+2AO7xzsQIqpESKLoEhX1KRDjzd723dSa+IvYFuheFuHoHm4GTymxDAyZJEAavoa9lTFsq4mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845326; c=relaxed/simple;
	bh=wKMZ5cfp5HRqh3X8z6MvR8LKiu17lRFidy4V3a988Tc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z7UdGT8izjaieBL2Mmp9mpjDwgDQGkw+hv84X8tVfH6zVsq0WpxboTViM4CuRTc64Zm7Eg25hqFA9/Ti1D7WZT0ovXAOVKkiRFmedTis4O59fEJ+Be6yzq5OYyXKGWdoEV7MbYS/peeeDh16UY5CpMq+QoOxMqtSUoJ6LvmXJ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+pWi1uM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+pWi1uM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA8AC4CECF;
	Tue,  5 Nov 2024 22:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845326;
	bh=wKMZ5cfp5HRqh3X8z6MvR8LKiu17lRFidy4V3a988Tc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i+pWi1uM2GQMbEIH/yMrF5ftfVhsKGeC5A8YJ4o7bU2fhyCqIF5EAPlNuR/kVkcMu
	 6gJkemEpTrPFBlDpiMmhh62NE0COkbTGULQb6DzuEfTLwCrVdvu36Hf2n0WKBsIN4R
	 krM+9nTXbooSe2nkweBErzCWr5MkSoXbyW6VIo/Z8RIdKvZ2OUxXfdXmpCkwxQPe6L
	 XylzPH89pqYI1+oBzvYfKXzoidBIYVYDyNUF/Qe2QKN+MAj/51zGzXklaezwkU7sho
	 7Z3T1Nl+w7LZPuquQghFEzQJJEtnFcG2qDKg9D2eC/+/Wf/jDCTfxj0otpn+B/0NrT
	 YbxgD4jYs11YA==
Date: Tue, 05 Nov 2024 14:22:06 -0800
Subject: [PATCH 21/28] xfs: adjust parent pointer scrubber for sb-rooted
 metadata files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396380.1870066.13741850001983424436.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
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

