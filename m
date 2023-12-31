Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CF8BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NrZG/65L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764A5C433C8;
	Sun, 31 Dec 2023 20:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055303;
	bh=PU5pm544TpoEkPCwkm6A52eCiTGlNOmcHtEOrsDRXuk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NrZG/65LXIGaJScdLKrkpntA0VECQEYwJAwQMigNqppB4wjuzHmx1wJd1lRiFvUZH
	 hoHyco4IrlPSXIIzBiczjwnb50T7LFGUegBOZQAi/vYaJQWbfcnXTU4EI0wzMbaFC6
	 lcItvQngaIdrmJLELgzmDnzY9GKUfBn3C+QBzwN/DqH3nG29YbvXaFD11EBury7vK2
	 1Mj5yXshpi+j+o99hiJvI6wle8sljUsTLnz2K+OlEuo3WBDj6+i/KCL+r+X7o0qIAJ
	 GcP1/d1gNLoc9EyTAI2E88hfzdQ3KhpsQuRhDpG2uVy8zmwQ02WsFcy6GMTtq27qAj
	 L8LknA4Ef35Eg==
Date: Sun, 31 Dec 2023 12:41:42 -0800
Subject: [PATCH 4/4] xfs: create subordinate scrub contexts for
 xchk_metadata_inode_subtype
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404838064.1754231.17919127065917597016.stgit@frogsfrogsfrogs>
In-Reply-To: <170404837990.1754231.2175141512934229542.stgit@frogsfrogsfrogs>
References: <170404837990.1754231.2175141512934229542.stgit@frogsfrogsfrogs>
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
index c16cd9774f525..9a8bd6f050af9 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1201,27 +1201,12 @@ xchk_metadata_inode_subtype(
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
index ef17a08320782..b15eee680510c 100644
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
index df6f5d3474048..440b8cb1957f4 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -180,6 +180,39 @@ xchk_fsgates_disable(
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
+	if (sub->sc.xfile_buftarg)
+		xfile_free_buftarg(sub->sc.xfile_buftarg);
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
@@ -508,6 +541,36 @@ static inline void xchk_postmortem(struct xfs_scrub *sc)
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
+	sub->sc.xfile_buftarg = NULL;
+
+	return sub;
+}
+
 /* Dispatch metadata scrubbing. */
 int
 xfs_scrub_metadata(
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 09769af6b66a9..665da3e3c1af1 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -156,6 +156,17 @@ struct xfs_scrub {
  */
 #define XREP_FSGATES_ALL	(XREP_FSGATES_ATOMIC_XCHG)
 
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

