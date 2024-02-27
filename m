Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E80A134BC
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709001281; cv=none; b=DMj0WbPr07vUYVjm6IylwhlyFOiiajt9UIsUwnKCyCYsuzZJn1BH9v4LdxdLVQSBHItFftvJeu9QSjkhP0ZI1hpQXT2sH4OaWUgtIZVVrC9ELTOthvBd16HZkdHcSUYh0N7QrdSRIamnj/xy1e0m9Mvxf3zLp24v1BAgqjF23Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709001281; c=relaxed/simple;
	bh=1ix3oM9+ZlSftEucJRBMheQmtKO0CZIO3c0PXC4yq+I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tyxHfszAZKHFv+fe+HP/mroZbM84ZbsU4FRpdDiJBZrmAWHWbCS6CJF9EaWlJfL3YRY7Ld08+0UtBZ4hzB882Xnu6dl7K361F661WSa2yBVthuSFjKHgYUTNTJoFSx/mi2MRN0tIK3RSu55hOXd/bW9pNgXN/66SklJqETHefqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fn8AeVuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fn8AeVuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BBDC433C7;
	Tue, 27 Feb 2024 02:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709001281;
	bh=1ix3oM9+ZlSftEucJRBMheQmtKO0CZIO3c0PXC4yq+I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fn8AeVuc25widAtL1ryWjxPpnGnfZtP9ih1uXXE6CW2O33sIMAT0eUvjL5BfiEryz
	 1z+qdJMuKR9yY6xEYjKl+I5ccQr6BKPfQSd2aQMorGuiRKtn+rBVxZ43M+uKvLMQpQ
	 5afj7YzGItrkb3tgKweISJ1bX7kBStv6u3uGx681vvzoKfMgh5P6Ui/mMq/+Wc+hia
	 PjRijxwydTVdq+xvcrW0mJMp5yRhh2/RMkDRP9phuXEYbHvh84O3vdF4u/xCTG0Qtv
	 4P98SAbAev2vZbnEue10lOYtqPskUlhRANfFy3o3d+j8eT7sfZizPPKQFVpE9N7jVx
	 CHL+ARW1LvXyA==
Date: Mon, 26 Feb 2024 18:34:40 -0800
Subject: [PATCH 4/4] xfs: create subordinate scrub contexts for
 xchk_metadata_inode_subtype
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900016108.940004.1763623118016244603.stgit@frogsfrogsfrogs>
In-Reply-To: <170900016032.940004.10036483809627191806.stgit@frogsfrogsfrogs>
References: <170900016032.940004.10036483809627191806.stgit@frogsfrogsfrogs>
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

When a file-based metadata structure is being scrubbed in
xchk_metadata_inode_subtype, we should create an entirely new scrub
context so that each scrubber doesn't trip over another's buffers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |   23 +++--------------
 fs/xfs/scrub/repair.c |   67 ++++++++++---------------------------------------
 fs/xfs/scrub/scrub.c  |   63 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h  |   11 ++++++++
 4 files changed, 91 insertions(+), 73 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 4afaa0a0760c6..599de8690f335 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1205,27 +1205,12 @@ xchk_metadata_inode_subtype(
 	struct xfs_scrub	*sc,
 	unsigned int		scrub_type)
 {
-	__u32			smtype = sc->sm->sm_type;
-	unsigned int		sick_mask = sc->sick_mask;
+	struct xfs_scrub_subord	*sub;
 	int			error;
 
-	sc->sm->sm_type = scrub_type;
-
-	switch (scrub_type) {
-	case XFS_SCRUB_TYPE_INODE:
-		error = xchk_inode(sc);
-		break;
-	case XFS_SCRUB_TYPE_BMBTD:
-		error = xchk_bmap_data(sc);
-		break;
-	default:
-		ASSERT(0);
-		error = -EFSCORRUPTED;
-		break;
-	}
-
-	sc->sick_mask = sick_mask;
-	sc->sm->sm_type = smtype;
+	sub = xchk_scrub_create_subord(sc, scrub_type);
+	error = sub->sc.ops->scrub(&sub->sc);
+	xchk_scrub_free_subord(sub);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 9cf0014ecd3e0..445ff3f76b339 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1009,55 +1009,27 @@ xrep_metadata_inode_subtype(
 	struct xfs_scrub	*sc,
 	unsigned int		scrub_type)
 {
-	__u32			smtype = sc->sm->sm_type;
-	__u32			smflags = sc->sm->sm_flags;
-	unsigned int		sick_mask = sc->sick_mask;
+	struct xfs_scrub_subord	*sub;
 	int			error;
 
 	/*
-	 * Let's see if the inode needs repair.  We're going to open-code calls
-	 * to the scrub and repair functions so that we can hang on to the
+	 * Let's see if the inode needs repair.  Use a subordinate scrub context
+	 * to call the scrub and repair functions so that we can hang on to the
 	 * resources that we already acquired instead of using the standard
 	 * setup/teardown routines.
 	 */
-	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
-	sc->sm->sm_type = scrub_type;
-
-	switch (scrub_type) {
-	case XFS_SCRUB_TYPE_INODE:
-		error = xchk_inode(sc);
-		break;
-	case XFS_SCRUB_TYPE_BMBTD:
-		error = xchk_bmap_data(sc);
-		break;
-	case XFS_SCRUB_TYPE_BMBTA:
-		error = xchk_bmap_attr(sc);
-		break;
-	default:
-		ASSERT(0);
-		error = -EFSCORRUPTED;
-	}
+	sub = xchk_scrub_create_subord(sc, scrub_type);
+	error = sub->sc.ops->scrub(&sub->sc);
 	if (error)
 		goto out;
-
-	if (!xrep_will_attempt(sc))
+	if (!xrep_will_attempt(&sub->sc))
 		goto out;
 
 	/*
 	 * Repair some part of the inode.  This will potentially join the inode
 	 * to the transaction.
 	 */
-	switch (scrub_type) {
-	case XFS_SCRUB_TYPE_INODE:
-		error = xrep_inode(sc);
-		break;
-	case XFS_SCRUB_TYPE_BMBTD:
-		error = xrep_bmap(sc, XFS_DATA_FORK, false);
-		break;
-	case XFS_SCRUB_TYPE_BMBTA:
-		error = xrep_bmap(sc, XFS_ATTR_FORK, false);
-		break;
-	}
+	error = sub->sc.ops->repair(&sub->sc);
 	if (error)
 		goto out;
 
@@ -1066,10 +1038,10 @@ xrep_metadata_inode_subtype(
 	 * that the inode will not be joined to the transaction when we exit
 	 * the function.
 	 */
-	error = xfs_defer_finish(&sc->tp);
+	error = xfs_defer_finish(&sub->sc.tp);
 	if (error)
 		goto out;
-	error = xfs_trans_roll(&sc->tp);
+	error = xfs_trans_roll(&sub->sc.tp);
 	if (error)
 		goto out;
 
@@ -1077,31 +1049,18 @@ xrep_metadata_inode_subtype(
 	 * Clear the corruption flags and re-check the metadata that we just
 	 * repaired.
 	 */
-	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
-
-	switch (scrub_type) {
-	case XFS_SCRUB_TYPE_INODE:
-		error = xchk_inode(sc);
-		break;
-	case XFS_SCRUB_TYPE_BMBTD:
-		error = xchk_bmap_data(sc);
-		break;
-	case XFS_SCRUB_TYPE_BMBTA:
-		error = xchk_bmap_attr(sc);
-		break;
-	}
+	sub->sc.sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	error = sub->sc.ops->scrub(&sub->sc);
 	if (error)
 		goto out;
 
 	/* If corruption persists, the repair has failed. */
-	if (xchk_needs_repair(sc->sm)) {
+	if (xchk_needs_repair(sub->sc.sm)) {
 		error = -EFSCORRUPTED;
 		goto out;
 	}
 out:
-	sc->sick_mask = sick_mask;
-	sc->sm->sm_type = smtype;
-	sc->sm->sm_flags = smflags;
+	xchk_scrub_free_subord(sub);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 301d5b753fdd5..ebb06838c31be 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -177,6 +177,39 @@ xchk_fsgates_disable(
 }
 #undef FSGATES_MASK
 
+/* Free the resources associated with a scrub subtype. */
+void
+xchk_scrub_free_subord(
+	struct xfs_scrub_subord	*sub)
+{
+	struct xfs_scrub	*sc = sub->parent_sc;
+
+	ASSERT(sc->ip == sub->sc.ip);
+	ASSERT(sc->orphanage == sub->sc.orphanage);
+	ASSERT(sc->tempip == sub->sc.tempip);
+
+	sc->sm->sm_type = sub->old_smtype;
+	sc->sm->sm_flags = sub->old_smflags |
+				(sc->sm->sm_flags & XFS_SCRUB_FLAGS_OUT);
+	sc->tp = sub->sc.tp;
+
+	if (sub->sc.buf) {
+		if (sub->sc.buf_cleanup)
+			sub->sc.buf_cleanup(sub->sc.buf);
+		kvfree(sub->sc.buf);
+	}
+	if (sub->sc.xmbtp)
+		xmbuf_free(sub->sc.xmbtp);
+	if (sub->sc.xfile)
+		xfile_destroy(sub->sc.xfile);
+
+	sc->ilock_flags = sub->sc.ilock_flags;
+	sc->orphanage_ilock_flags = sub->sc.orphanage_ilock_flags;
+	sc->temp_ilock_flags = sub->sc.temp_ilock_flags;
+
+	kfree(sub);
+}
+
 /* Free all the resources and finish the transactions. */
 STATIC int
 xchk_teardown(
@@ -505,6 +538,36 @@ static inline void xchk_postmortem(struct xfs_scrub *sc)
 }
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
+/*
+ * Create a new scrub context from an existing one, but with a different scrub
+ * type.
+ */
+struct xfs_scrub_subord *
+xchk_scrub_create_subord(
+	struct xfs_scrub	*sc,
+	unsigned int		subtype)
+{
+	struct xfs_scrub_subord	*sub;
+
+	sub = kzalloc(sizeof(*sub), XCHK_GFP_FLAGS);
+	if (!sub)
+		return ERR_PTR(-ENOMEM);
+
+	sub->old_smtype = sc->sm->sm_type;
+	sub->old_smflags = sc->sm->sm_flags;
+	sub->parent_sc = sc;
+	memcpy(&sub->sc, sc, sizeof(struct xfs_scrub));
+	sub->sc.ops = &meta_scrub_ops[subtype];
+	sub->sc.sm->sm_type = subtype;
+	sub->sc.sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	sub->sc.buf = NULL;
+	sub->sc.buf_cleanup = NULL;
+	sub->sc.xfile = NULL;
+	sub->sc.xmbtp = NULL;
+
+	return sub;
+}
+
 /* Dispatch metadata scrubbing. */
 int
 xfs_scrub_metadata(
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 456bb181399f4..2661874b01ab2 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -156,6 +156,17 @@ struct xfs_scrub {
  */
 #define XREP_FSGATES_ALL	(XREP_FSGATES_EXCHMAPS)
 
+struct xfs_scrub_subord {
+	struct xfs_scrub	sc;
+	struct xfs_scrub	*parent_sc;
+	unsigned int		old_smtype;
+	unsigned int		old_smflags;
+};
+
+struct xfs_scrub_subord *xchk_scrub_create_subord(struct xfs_scrub *sc,
+		unsigned int subtype);
+void xchk_scrub_free_subord(struct xfs_scrub_subord *sub);
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);

